1 // File: @openzeppelin/contracts/utils/Context.sol
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
28 // File: @openzeppelin/contracts/access/Ownable.sol
29 
30 
31 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
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
84      * `onlyOwner` functions. Can only be called by the current owner.
85      *
86      * NOTE: Renouncing ownership will leave the contract without an owner,
87      * thereby disabling any functionality that is only available to the owner.
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
116 // ERC721A Contracts v4.2.3
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
136      * Cannot query the balance for the zero address.
137      */
138     error BalanceQueryForZeroAddress();
139 
140     /**
141      * Cannot mint to the zero address.
142      */
143     error MintToZeroAddress();
144 
145     /**
146      * The quantity of tokens minted must be more than zero.
147      */
148     error MintZeroQuantity();
149 
150     /**
151      * The token does not exist.
152      */
153     error OwnerQueryForNonexistentToken();
154 
155     /**
156      * The caller must own the token or be an approved operator.
157      */
158     error TransferCallerNotOwnerNorApproved();
159 
160     /**
161      * The token must be owned by `from`.
162      */
163     error TransferFromIncorrectOwner();
164 
165     /**
166      * Cannot safely transfer to a contract that does not implement the
167      * ERC721Receiver interface.
168      */
169     error TransferToNonERC721ReceiverImplementer();
170 
171     /**
172      * Cannot transfer to the zero address.
173      */
174     error TransferToZeroAddress();
175 
176     /**
177      * The token does not exist.
178      */
179     error URIQueryForNonexistentToken();
180 
181     /**
182      * The `quantity` minted with ERC2309 exceeds the safety limit.
183      */
184     error MintERC2309QuantityExceedsLimit();
185 
186     /**
187      * The `extraData` cannot be set on an unintialized ownership slot.
188      */
189     error OwnershipNotInitializedForExtraData();
190 
191     // =============================================================
192     //                            STRUCTS
193     // =============================================================
194 
195     struct TokenOwnership {
196         // The address of the owner.
197         address addr;
198         // Stores the start time of ownership with minimal overhead for tokenomics.
199         uint64 startTimestamp;
200         // Whether the token has been burned.
201         bool burned;
202         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
203         uint24 extraData;
204     }
205 
206     // =============================================================
207     //                         TOKEN COUNTERS
208     // =============================================================
209 
210     /**
211      * @dev Returns the total number of tokens in existence.
212      * Burned tokens will reduce the count.
213      * To get the total number of tokens minted, please see {_totalMinted}.
214      */
215     function totalSupply() external view returns (uint256);
216 
217     // =============================================================
218     //                            IERC165
219     // =============================================================
220 
221     /**
222      * @dev Returns true if this contract implements the interface defined by
223      * `interfaceId`. See the corresponding
224      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
225      * to learn more about how these ids are created.
226      *
227      * This function call must use less than 30000 gas.
228      */
229     function supportsInterface(bytes4 interfaceId) external view returns (bool);
230 
231     // =============================================================
232     //                            IERC721
233     // =============================================================
234 
235     /**
236      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
237      */
238     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
239 
240     /**
241      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
242      */
243     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
244 
245     /**
246      * @dev Emitted when `owner` enables or disables
247      * (`approved`) `operator` to manage all of its assets.
248      */
249     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
250 
251     /**
252      * @dev Returns the number of tokens in `owner`'s account.
253      */
254     function balanceOf(address owner) external view returns (uint256 balance);
255 
256     /**
257      * @dev Returns the owner of the `tokenId` token.
258      *
259      * Requirements:
260      *
261      * - `tokenId` must exist.
262      */
263     function ownerOf(uint256 tokenId) external view returns (address owner);
264 
265     /**
266      * @dev Safely transfers `tokenId` token from `from` to `to`,
267      * checking first that contract recipients are aware of the ERC721 protocol
268      * to prevent tokens from being forever locked.
269      *
270      * Requirements:
271      *
272      * - `from` cannot be the zero address.
273      * - `to` cannot be the zero address.
274      * - `tokenId` token must exist and be owned by `from`.
275      * - If the caller is not `from`, it must be have been allowed to move
276      * this token by either {approve} or {setApprovalForAll}.
277      * - If `to` refers to a smart contract, it must implement
278      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
279      *
280      * Emits a {Transfer} event.
281      */
282     function safeTransferFrom(
283         address from,
284         address to,
285         uint256 tokenId,
286         bytes calldata data
287     ) external payable;
288 
289     /**
290      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
291      */
292     function safeTransferFrom(
293         address from,
294         address to,
295         uint256 tokenId
296     ) external payable;
297 
298     /**
299      * @dev Transfers `tokenId` from `from` to `to`.
300      *
301      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
302      * whenever possible.
303      *
304      * Requirements:
305      *
306      * - `from` cannot be the zero address.
307      * - `to` cannot be the zero address.
308      * - `tokenId` token must be owned by `from`.
309      * - If the caller is not `from`, it must be approved to move this token
310      * by either {approve} or {setApprovalForAll}.
311      *
312      * Emits a {Transfer} event.
313      */
314     function transferFrom(
315         address from,
316         address to,
317         uint256 tokenId
318     ) external payable;
319 
320     /**
321      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
322      * The approval is cleared when the token is transferred.
323      *
324      * Only a single account can be approved at a time, so approving the
325      * zero address clears previous approvals.
326      *
327      * Requirements:
328      *
329      * - The caller must own the token or be an approved operator.
330      * - `tokenId` must exist.
331      *
332      * Emits an {Approval} event.
333      */
334     function approve(address to, uint256 tokenId) external payable;
335 
336     /**
337      * @dev Approve or remove `operator` as an operator for the caller.
338      * Operators can call {transferFrom} or {safeTransferFrom}
339      * for any token owned by the caller.
340      *
341      * Requirements:
342      *
343      * - The `operator` cannot be the caller.
344      *
345      * Emits an {ApprovalForAll} event.
346      */
347     function setApprovalForAll(address operator, bool _approved) external;
348 
349     /**
350      * @dev Returns the account approved for `tokenId` token.
351      *
352      * Requirements:
353      *
354      * - `tokenId` must exist.
355      */
356     function getApproved(uint256 tokenId) external view returns (address operator);
357 
358     /**
359      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
360      *
361      * See {setApprovalForAll}.
362      */
363     function isApprovedForAll(address owner, address operator) external view returns (bool);
364 
365     // =============================================================
366     //                        IERC721Metadata
367     // =============================================================
368 
369     /**
370      * @dev Returns the token collection name.
371      */
372     function name() external view returns (string memory);
373 
374     /**
375      * @dev Returns the token collection symbol.
376      */
377     function symbol() external view returns (string memory);
378 
379     /**
380      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
381      */
382     function tokenURI(uint256 tokenId) external view returns (string memory);
383 
384     // =============================================================
385     //                           IERC2309
386     // =============================================================
387 
388     /**
389      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
390      * (inclusive) is transferred from `from` to `to`, as defined in the
391      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
392      *
393      * See {_mintERC2309} for more details.
394      */
395     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
396 }
397 
398 // File: erc721a/contracts/ERC721A.sol
399 
400 
401 // ERC721A Contracts v4.2.3
402 // Creator: Chiru Labs
403 
404 pragma solidity ^0.8.4;
405 
406 
407 /**
408  * @dev Interface of ERC721 token receiver.
409  */
410 interface ERC721A__IERC721Receiver {
411     function onERC721Received(
412         address operator,
413         address from,
414         uint256 tokenId,
415         bytes calldata data
416     ) external returns (bytes4);
417 }
418 
419 /**
420  * @title ERC721A
421  *
422  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
423  * Non-Fungible Token Standard, including the Metadata extension.
424  * Optimized for lower gas during batch mints.
425  *
426  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
427  * starting from `_startTokenId()`.
428  *
429  * Assumptions:
430  *
431  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
432  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
433  */
434 contract ERC721A is IERC721A {
435     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
436     struct TokenApprovalRef {
437         address value;
438     }
439 
440     // =============================================================
441     //                           CONSTANTS
442     // =============================================================
443 
444     // Mask of an entry in packed address data.
445     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
446 
447     // The bit position of `numberMinted` in packed address data.
448     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
449 
450     // The bit position of `numberBurned` in packed address data.
451     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
452 
453     // The bit position of `aux` in packed address data.
454     uint256 private constant _BITPOS_AUX = 192;
455 
456     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
457     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
458 
459     // The bit position of `startTimestamp` in packed ownership.
460     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
461 
462     // The bit mask of the `burned` bit in packed ownership.
463     uint256 private constant _BITMASK_BURNED = 1 << 224;
464 
465     // The bit position of the `nextInitialized` bit in packed ownership.
466     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
467 
468     // The bit mask of the `nextInitialized` bit in packed ownership.
469     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
470 
471     // The bit position of `extraData` in packed ownership.
472     uint256 private constant _BITPOS_EXTRA_DATA = 232;
473 
474     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
475     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
476 
477     // The mask of the lower 160 bits for addresses.
478     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
479 
480     // The maximum `quantity` that can be minted with {_mintERC2309}.
481     // This limit is to prevent overflows on the address data entries.
482     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
483     // is required to cause an overflow, which is unrealistic.
484     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
485 
486     // The `Transfer` event signature is given by:
487     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
488     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
489         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
490 
491     // =============================================================
492     //                            STORAGE
493     // =============================================================
494 
495     // The next token ID to be minted.
496     uint256 private _currentIndex;
497 
498     // The number of tokens burned.
499     uint256 private _burnCounter;
500 
501     // Token name
502     string private _name;
503 
504     // Token symbol
505     string private _symbol;
506 
507     // Mapping from token ID to ownership details
508     // An empty struct value does not necessarily mean the token is unowned.
509     // See {_packedOwnershipOf} implementation for details.
510     //
511     // Bits Layout:
512     // - [0..159]   `addr`
513     // - [160..223] `startTimestamp`
514     // - [224]      `burned`
515     // - [225]      `nextInitialized`
516     // - [232..255] `extraData`
517     mapping(uint256 => uint256) private _packedOwnerships;
518 
519     // Mapping owner address to address data.
520     //
521     // Bits Layout:
522     // - [0..63]    `balance`
523     // - [64..127]  `numberMinted`
524     // - [128..191] `numberBurned`
525     // - [192..255] `aux`
526     mapping(address => uint256) private _packedAddressData;
527 
528     // Mapping from token ID to approved address.
529     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
530 
531     // Mapping from owner to operator approvals
532     mapping(address => mapping(address => bool)) private _operatorApprovals;
533 
534     // =============================================================
535     //                          CONSTRUCTOR
536     // =============================================================
537 
538     constructor(string memory name_, string memory symbol_) {
539         _name = name_;
540         _symbol = symbol_;
541         _currentIndex = _startTokenId();
542     }
543 
544     // =============================================================
545     //                   TOKEN COUNTING OPERATIONS
546     // =============================================================
547 
548     /**
549      * @dev Returns the starting token ID.
550      * To change the starting token ID, please override this function.
551      */
552     function _startTokenId() internal view virtual returns (uint256) {
553         return 0;
554     }
555 
556     /**
557      * @dev Returns the next token ID to be minted.
558      */
559     function _nextTokenId() internal view virtual returns (uint256) {
560         return _currentIndex;
561     }
562 
563     /**
564      * @dev Returns the total number of tokens in existence.
565      * Burned tokens will reduce the count.
566      * To get the total number of tokens minted, please see {_totalMinted}.
567      */
568     function totalSupply() public view virtual override returns (uint256) {
569         // Counter underflow is impossible as _burnCounter cannot be incremented
570         // more than `_currentIndex - _startTokenId()` times.
571         unchecked {
572             return _currentIndex - _burnCounter - _startTokenId();
573         }
574     }
575 
576     /**
577      * @dev Returns the total amount of tokens minted in the contract.
578      */
579     function _totalMinted() internal view virtual returns (uint256) {
580         // Counter underflow is impossible as `_currentIndex` does not decrement,
581         // and it is initialized to `_startTokenId()`.
582         unchecked {
583             return _currentIndex - _startTokenId();
584         }
585     }
586 
587     /**
588      * @dev Returns the total number of tokens burned.
589      */
590     function _totalBurned() internal view virtual returns (uint256) {
591         return _burnCounter;
592     }
593 
594     // =============================================================
595     //                    ADDRESS DATA OPERATIONS
596     // =============================================================
597 
598     /**
599      * @dev Returns the number of tokens in `owner`'s account.
600      */
601     function balanceOf(address owner) public view virtual override returns (uint256) {
602         if (owner == address(0)) revert BalanceQueryForZeroAddress();
603         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
604     }
605 
606     /**
607      * Returns the number of tokens minted by `owner`.
608      */
609     function _numberMinted(address owner) internal view returns (uint256) {
610         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
611     }
612 
613     /**
614      * Returns the number of tokens burned by or on behalf of `owner`.
615      */
616     function _numberBurned(address owner) internal view returns (uint256) {
617         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
618     }
619 
620     /**
621      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
622      */
623     function _getAux(address owner) internal view returns (uint64) {
624         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
625     }
626 
627     /**
628      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
629      * If there are multiple variables, please pack them into a uint64.
630      */
631     function _setAux(address owner, uint64 aux) internal virtual {
632         uint256 packed = _packedAddressData[owner];
633         uint256 auxCasted;
634         // Cast `aux` with assembly to avoid redundant masking.
635         assembly {
636             auxCasted := aux
637         }
638         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
639         _packedAddressData[owner] = packed;
640     }
641 
642     // =============================================================
643     //                            IERC165
644     // =============================================================
645 
646     /**
647      * @dev Returns true if this contract implements the interface defined by
648      * `interfaceId`. See the corresponding
649      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
650      * to learn more about how these ids are created.
651      *
652      * This function call must use less than 30000 gas.
653      */
654     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
655         // The interface IDs are constants representing the first 4 bytes
656         // of the XOR of all function selectors in the interface.
657         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
658         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
659         return
660             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
661             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
662             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
663     }
664 
665     // =============================================================
666     //                        IERC721Metadata
667     // =============================================================
668 
669     /**
670      * @dev Returns the token collection name.
671      */
672     function name() public view virtual override returns (string memory) {
673         return _name;
674     }
675 
676     /**
677      * @dev Returns the token collection symbol.
678      */
679     function symbol() public view virtual override returns (string memory) {
680         return _symbol;
681     }
682 
683     /**
684      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
685      */
686     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
687         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
688 
689         string memory baseURI = _baseURI();
690         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
691     }
692 
693     /**
694      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
695      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
696      * by default, it can be overridden in child contracts.
697      */
698     function _baseURI() internal view virtual returns (string memory) {
699         return '';
700     }
701 
702     // =============================================================
703     //                     OWNERSHIPS OPERATIONS
704     // =============================================================
705 
706     /**
707      * @dev Returns the owner of the `tokenId` token.
708      *
709      * Requirements:
710      *
711      * - `tokenId` must exist.
712      */
713     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
714         return address(uint160(_packedOwnershipOf(tokenId)));
715     }
716 
717     /**
718      * @dev Gas spent here starts off proportional to the maximum mint batch size.
719      * It gradually moves to O(1) as tokens get transferred around over time.
720      */
721     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
722         return _unpackedOwnership(_packedOwnershipOf(tokenId));
723     }
724 
725     /**
726      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
727      */
728     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
729         return _unpackedOwnership(_packedOwnerships[index]);
730     }
731 
732     /**
733      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
734      */
735     function _initializeOwnershipAt(uint256 index) internal virtual {
736         if (_packedOwnerships[index] == 0) {
737             _packedOwnerships[index] = _packedOwnershipOf(index);
738         }
739     }
740 
741     /**
742      * Returns the packed ownership data of `tokenId`.
743      */
744     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
745         uint256 curr = tokenId;
746 
747         unchecked {
748             if (_startTokenId() <= curr)
749                 if (curr < _currentIndex) {
750                     uint256 packed = _packedOwnerships[curr];
751                     // If not burned.
752                     if (packed & _BITMASK_BURNED == 0) {
753                         // Invariant:
754                         // There will always be an initialized ownership slot
755                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
756                         // before an unintialized ownership slot
757                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
758                         // Hence, `curr` will not underflow.
759                         //
760                         // We can directly compare the packed value.
761                         // If the address is zero, packed will be zero.
762                         while (packed == 0) {
763                             packed = _packedOwnerships[--curr];
764                         }
765                         return packed;
766                     }
767                 }
768         }
769         revert OwnerQueryForNonexistentToken();
770     }
771 
772     /**
773      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
774      */
775     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
776         ownership.addr = address(uint160(packed));
777         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
778         ownership.burned = packed & _BITMASK_BURNED != 0;
779         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
780     }
781 
782     /**
783      * @dev Packs ownership data into a single uint256.
784      */
785     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
786         assembly {
787             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
788             owner := and(owner, _BITMASK_ADDRESS)
789             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
790             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
791         }
792     }
793 
794     /**
795      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
796      */
797     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
798         // For branchless setting of the `nextInitialized` flag.
799         assembly {
800             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
801             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
802         }
803     }
804 
805     // =============================================================
806     //                      APPROVAL OPERATIONS
807     // =============================================================
808 
809     /**
810      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
811      * The approval is cleared when the token is transferred.
812      *
813      * Only a single account can be approved at a time, so approving the
814      * zero address clears previous approvals.
815      *
816      * Requirements:
817      *
818      * - The caller must own the token or be an approved operator.
819      * - `tokenId` must exist.
820      *
821      * Emits an {Approval} event.
822      */
823     function approve(address to, uint256 tokenId) public payable virtual override {
824         address owner = ownerOf(tokenId);
825 
826         if (_msgSenderERC721A() != owner)
827             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
828                 revert ApprovalCallerNotOwnerNorApproved();
829             }
830 
831         _tokenApprovals[tokenId].value = to;
832         emit Approval(owner, to, tokenId);
833     }
834 
835     /**
836      * @dev Returns the account approved for `tokenId` token.
837      *
838      * Requirements:
839      *
840      * - `tokenId` must exist.
841      */
842     function getApproved(uint256 tokenId) public view virtual override returns (address) {
843         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
844 
845         return _tokenApprovals[tokenId].value;
846     }
847 
848     /**
849      * @dev Approve or remove `operator` as an operator for the caller.
850      * Operators can call {transferFrom} or {safeTransferFrom}
851      * for any token owned by the caller.
852      *
853      * Requirements:
854      *
855      * - The `operator` cannot be the caller.
856      *
857      * Emits an {ApprovalForAll} event.
858      */
859     function setApprovalForAll(address operator, bool approved) public virtual override {
860         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
861         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
862     }
863 
864     /**
865      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
866      *
867      * See {setApprovalForAll}.
868      */
869     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
870         return _operatorApprovals[owner][operator];
871     }
872 
873     /**
874      * @dev Returns whether `tokenId` exists.
875      *
876      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
877      *
878      * Tokens start existing when they are minted. See {_mint}.
879      */
880     function _exists(uint256 tokenId) internal view virtual returns (bool) {
881         return
882             _startTokenId() <= tokenId &&
883             tokenId < _currentIndex && // If within bounds,
884             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
885     }
886 
887     /**
888      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
889      */
890     function _isSenderApprovedOrOwner(
891         address approvedAddress,
892         address owner,
893         address msgSender
894     ) private pure returns (bool result) {
895         assembly {
896             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
897             owner := and(owner, _BITMASK_ADDRESS)
898             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
899             msgSender := and(msgSender, _BITMASK_ADDRESS)
900             // `msgSender == owner || msgSender == approvedAddress`.
901             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
902         }
903     }
904 
905     /**
906      * @dev Returns the storage slot and value for the approved address of `tokenId`.
907      */
908     function _getApprovedSlotAndAddress(uint256 tokenId)
909         private
910         view
911         returns (uint256 approvedAddressSlot, address approvedAddress)
912     {
913         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
914         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
915         assembly {
916             approvedAddressSlot := tokenApproval.slot
917             approvedAddress := sload(approvedAddressSlot)
918         }
919     }
920 
921     // =============================================================
922     //                      TRANSFER OPERATIONS
923     // =============================================================
924 
925     /**
926      * @dev Transfers `tokenId` from `from` to `to`.
927      *
928      * Requirements:
929      *
930      * - `from` cannot be the zero address.
931      * - `to` cannot be the zero address.
932      * - `tokenId` token must be owned by `from`.
933      * - If the caller is not `from`, it must be approved to move this token
934      * by either {approve} or {setApprovalForAll}.
935      *
936      * Emits a {Transfer} event.
937      */
938     function transferFrom(
939         address from,
940         address to,
941         uint256 tokenId
942     ) public payable virtual override {
943         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
944 
945         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
946 
947         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
948 
949         // The nested ifs save around 20+ gas over a compound boolean condition.
950         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
951             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
952 
953         if (to == address(0)) revert TransferToZeroAddress();
954 
955         _beforeTokenTransfers(from, to, tokenId, 1);
956 
957         // Clear approvals from the previous owner.
958         assembly {
959             if approvedAddress {
960                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
961                 sstore(approvedAddressSlot, 0)
962             }
963         }
964 
965         // Underflow of the sender's balance is impossible because we check for
966         // ownership above and the recipient's balance can't realistically overflow.
967         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
968         unchecked {
969             // We can directly increment and decrement the balances.
970             --_packedAddressData[from]; // Updates: `balance -= 1`.
971             ++_packedAddressData[to]; // Updates: `balance += 1`.
972 
973             // Updates:
974             // - `address` to the next owner.
975             // - `startTimestamp` to the timestamp of transfering.
976             // - `burned` to `false`.
977             // - `nextInitialized` to `true`.
978             _packedOwnerships[tokenId] = _packOwnershipData(
979                 to,
980                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
981             );
982 
983             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
984             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
985                 uint256 nextTokenId = tokenId + 1;
986                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
987                 if (_packedOwnerships[nextTokenId] == 0) {
988                     // If the next slot is within bounds.
989                     if (nextTokenId != _currentIndex) {
990                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
991                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
992                     }
993                 }
994             }
995         }
996 
997         emit Transfer(from, to, tokenId);
998         _afterTokenTransfers(from, to, tokenId, 1);
999     }
1000 
1001     /**
1002      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1003      */
1004     function safeTransferFrom(
1005         address from,
1006         address to,
1007         uint256 tokenId
1008     ) public payable virtual override {
1009         safeTransferFrom(from, to, tokenId, '');
1010     }
1011 
1012     /**
1013      * @dev Safely transfers `tokenId` token from `from` to `to`.
1014      *
1015      * Requirements:
1016      *
1017      * - `from` cannot be the zero address.
1018      * - `to` cannot be the zero address.
1019      * - `tokenId` token must exist and be owned by `from`.
1020      * - If the caller is not `from`, it must be approved to move this token
1021      * by either {approve} or {setApprovalForAll}.
1022      * - If `to` refers to a smart contract, it must implement
1023      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1024      *
1025      * Emits a {Transfer} event.
1026      */
1027     function safeTransferFrom(
1028         address from,
1029         address to,
1030         uint256 tokenId,
1031         bytes memory _data
1032     ) public payable virtual override {
1033         transferFrom(from, to, tokenId);
1034         if (to.code.length != 0)
1035             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1036                 revert TransferToNonERC721ReceiverImplementer();
1037             }
1038     }
1039 
1040     /**
1041      * @dev Hook that is called before a set of serially-ordered token IDs
1042      * are about to be transferred. This includes minting.
1043      * And also called before burning one token.
1044      *
1045      * `startTokenId` - the first token ID to be transferred.
1046      * `quantity` - the amount to be transferred.
1047      *
1048      * Calling conditions:
1049      *
1050      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1051      * transferred to `to`.
1052      * - When `from` is zero, `tokenId` will be minted for `to`.
1053      * - When `to` is zero, `tokenId` will be burned by `from`.
1054      * - `from` and `to` are never both zero.
1055      */
1056     function _beforeTokenTransfers(
1057         address from,
1058         address to,
1059         uint256 startTokenId,
1060         uint256 quantity
1061     ) internal virtual {}
1062 
1063     /**
1064      * @dev Hook that is called after a set of serially-ordered token IDs
1065      * have been transferred. This includes minting.
1066      * And also called after one token has been burned.
1067      *
1068      * `startTokenId` - the first token ID to be transferred.
1069      * `quantity` - the amount to be transferred.
1070      *
1071      * Calling conditions:
1072      *
1073      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1074      * transferred to `to`.
1075      * - When `from` is zero, `tokenId` has been minted for `to`.
1076      * - When `to` is zero, `tokenId` has been burned by `from`.
1077      * - `from` and `to` are never both zero.
1078      */
1079     function _afterTokenTransfers(
1080         address from,
1081         address to,
1082         uint256 startTokenId,
1083         uint256 quantity
1084     ) internal virtual {}
1085 
1086     /**
1087      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1088      *
1089      * `from` - Previous owner of the given token ID.
1090      * `to` - Target address that will receive the token.
1091      * `tokenId` - Token ID to be transferred.
1092      * `_data` - Optional data to send along with the call.
1093      *
1094      * Returns whether the call correctly returned the expected magic value.
1095      */
1096     function _checkContractOnERC721Received(
1097         address from,
1098         address to,
1099         uint256 tokenId,
1100         bytes memory _data
1101     ) private returns (bool) {
1102         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1103             bytes4 retval
1104         ) {
1105             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1106         } catch (bytes memory reason) {
1107             if (reason.length == 0) {
1108                 revert TransferToNonERC721ReceiverImplementer();
1109             } else {
1110                 assembly {
1111                     revert(add(32, reason), mload(reason))
1112                 }
1113             }
1114         }
1115     }
1116 
1117     // =============================================================
1118     //                        MINT OPERATIONS
1119     // =============================================================
1120 
1121     /**
1122      * @dev Mints `quantity` tokens and transfers them to `to`.
1123      *
1124      * Requirements:
1125      *
1126      * - `to` cannot be the zero address.
1127      * - `quantity` must be greater than 0.
1128      *
1129      * Emits a {Transfer} event for each mint.
1130      */
1131     function _mint(address to, uint256 quantity) internal virtual {
1132         uint256 startTokenId = _currentIndex;
1133         if (quantity == 0) revert MintZeroQuantity();
1134 
1135         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1136 
1137         // Overflows are incredibly unrealistic.
1138         // `balance` and `numberMinted` have a maximum limit of 2**64.
1139         // `tokenId` has a maximum limit of 2**256.
1140         unchecked {
1141             // Updates:
1142             // - `balance += quantity`.
1143             // - `numberMinted += quantity`.
1144             //
1145             // We can directly add to the `balance` and `numberMinted`.
1146             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1147 
1148             // Updates:
1149             // - `address` to the owner.
1150             // - `startTimestamp` to the timestamp of minting.
1151             // - `burned` to `false`.
1152             // - `nextInitialized` to `quantity == 1`.
1153             _packedOwnerships[startTokenId] = _packOwnershipData(
1154                 to,
1155                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1156             );
1157 
1158             uint256 toMasked;
1159             uint256 end = startTokenId + quantity;
1160 
1161             // Use assembly to loop and emit the `Transfer` event for gas savings.
1162             // The duplicated `log4` removes an extra check and reduces stack juggling.
1163             // The assembly, together with the surrounding Solidity code, have been
1164             // delicately arranged to nudge the compiler into producing optimized opcodes.
1165             assembly {
1166                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1167                 toMasked := and(to, _BITMASK_ADDRESS)
1168                 // Emit the `Transfer` event.
1169                 log4(
1170                     0, // Start of data (0, since no data).
1171                     0, // End of data (0, since no data).
1172                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1173                     0, // `address(0)`.
1174                     toMasked, // `to`.
1175                     startTokenId // `tokenId`.
1176                 )
1177 
1178                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1179                 // that overflows uint256 will make the loop run out of gas.
1180                 // The compiler will optimize the `iszero` away for performance.
1181                 for {
1182                     let tokenId := add(startTokenId, 1)
1183                 } iszero(eq(tokenId, end)) {
1184                     tokenId := add(tokenId, 1)
1185                 } {
1186                     // Emit the `Transfer` event. Similar to above.
1187                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1188                 }
1189             }
1190             if (toMasked == 0) revert MintToZeroAddress();
1191 
1192             _currentIndex = end;
1193         }
1194         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1195     }
1196 
1197     /**
1198      * @dev Mints `quantity` tokens and transfers them to `to`.
1199      *
1200      * This function is intended for efficient minting only during contract creation.
1201      *
1202      * It emits only one {ConsecutiveTransfer} as defined in
1203      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1204      * instead of a sequence of {Transfer} event(s).
1205      *
1206      * Calling this function outside of contract creation WILL make your contract
1207      * non-compliant with the ERC721 standard.
1208      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1209      * {ConsecutiveTransfer} event is only permissible during contract creation.
1210      *
1211      * Requirements:
1212      *
1213      * - `to` cannot be the zero address.
1214      * - `quantity` must be greater than 0.
1215      *
1216      * Emits a {ConsecutiveTransfer} event.
1217      */
1218     function _mintERC2309(address to, uint256 quantity) internal virtual {
1219         uint256 startTokenId = _currentIndex;
1220         if (to == address(0)) revert MintToZeroAddress();
1221         if (quantity == 0) revert MintZeroQuantity();
1222         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1223 
1224         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1225 
1226         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1227         unchecked {
1228             // Updates:
1229             // - `balance += quantity`.
1230             // - `numberMinted += quantity`.
1231             //
1232             // We can directly add to the `balance` and `numberMinted`.
1233             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1234 
1235             // Updates:
1236             // - `address` to the owner.
1237             // - `startTimestamp` to the timestamp of minting.
1238             // - `burned` to `false`.
1239             // - `nextInitialized` to `quantity == 1`.
1240             _packedOwnerships[startTokenId] = _packOwnershipData(
1241                 to,
1242                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1243             );
1244 
1245             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1246 
1247             _currentIndex = startTokenId + quantity;
1248         }
1249         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1250     }
1251 
1252     /**
1253      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1254      *
1255      * Requirements:
1256      *
1257      * - If `to` refers to a smart contract, it must implement
1258      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1259      * - `quantity` must be greater than 0.
1260      *
1261      * See {_mint}.
1262      *
1263      * Emits a {Transfer} event for each mint.
1264      */
1265     function _safeMint(
1266         address to,
1267         uint256 quantity,
1268         bytes memory _data
1269     ) internal virtual {
1270         _mint(to, quantity);
1271 
1272         unchecked {
1273             if (to.code.length != 0) {
1274                 uint256 end = _currentIndex;
1275                 uint256 index = end - quantity;
1276                 do {
1277                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1278                         revert TransferToNonERC721ReceiverImplementer();
1279                     }
1280                 } while (index < end);
1281                 // Reentrancy protection.
1282                 if (_currentIndex != end) revert();
1283             }
1284         }
1285     }
1286 
1287     /**
1288      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1289      */
1290     function _safeMint(address to, uint256 quantity) internal virtual {
1291         _safeMint(to, quantity, '');
1292     }
1293 
1294     // =============================================================
1295     //                        BURN OPERATIONS
1296     // =============================================================
1297 
1298     /**
1299      * @dev Equivalent to `_burn(tokenId, false)`.
1300      */
1301     function _burn(uint256 tokenId) internal virtual {
1302         _burn(tokenId, false);
1303     }
1304 
1305     /**
1306      * @dev Destroys `tokenId`.
1307      * The approval is cleared when the token is burned.
1308      *
1309      * Requirements:
1310      *
1311      * - `tokenId` must exist.
1312      *
1313      * Emits a {Transfer} event.
1314      */
1315     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1316         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1317 
1318         address from = address(uint160(prevOwnershipPacked));
1319 
1320         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1321 
1322         if (approvalCheck) {
1323             // The nested ifs save around 20+ gas over a compound boolean condition.
1324             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1325                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1326         }
1327 
1328         _beforeTokenTransfers(from, address(0), tokenId, 1);
1329 
1330         // Clear approvals from the previous owner.
1331         assembly {
1332             if approvedAddress {
1333                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1334                 sstore(approvedAddressSlot, 0)
1335             }
1336         }
1337 
1338         // Underflow of the sender's balance is impossible because we check for
1339         // ownership above and the recipient's balance can't realistically overflow.
1340         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1341         unchecked {
1342             // Updates:
1343             // - `balance -= 1`.
1344             // - `numberBurned += 1`.
1345             //
1346             // We can directly decrement the balance, and increment the number burned.
1347             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1348             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1349 
1350             // Updates:
1351             // - `address` to the last owner.
1352             // - `startTimestamp` to the timestamp of burning.
1353             // - `burned` to `true`.
1354             // - `nextInitialized` to `true`.
1355             _packedOwnerships[tokenId] = _packOwnershipData(
1356                 from,
1357                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1358             );
1359 
1360             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1361             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1362                 uint256 nextTokenId = tokenId + 1;
1363                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1364                 if (_packedOwnerships[nextTokenId] == 0) {
1365                     // If the next slot is within bounds.
1366                     if (nextTokenId != _currentIndex) {
1367                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1368                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1369                     }
1370                 }
1371             }
1372         }
1373 
1374         emit Transfer(from, address(0), tokenId);
1375         _afterTokenTransfers(from, address(0), tokenId, 1);
1376 
1377         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1378         unchecked {
1379             _burnCounter++;
1380         }
1381     }
1382 
1383     // =============================================================
1384     //                     EXTRA DATA OPERATIONS
1385     // =============================================================
1386 
1387     /**
1388      * @dev Directly sets the extra data for the ownership data `index`.
1389      */
1390     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1391         uint256 packed = _packedOwnerships[index];
1392         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1393         uint256 extraDataCasted;
1394         // Cast `extraData` with assembly to avoid redundant masking.
1395         assembly {
1396             extraDataCasted := extraData
1397         }
1398         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1399         _packedOwnerships[index] = packed;
1400     }
1401 
1402     /**
1403      * @dev Called during each token transfer to set the 24bit `extraData` field.
1404      * Intended to be overridden by the cosumer contract.
1405      *
1406      * `previousExtraData` - the value of `extraData` before transfer.
1407      *
1408      * Calling conditions:
1409      *
1410      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1411      * transferred to `to`.
1412      * - When `from` is zero, `tokenId` will be minted for `to`.
1413      * - When `to` is zero, `tokenId` will be burned by `from`.
1414      * - `from` and `to` are never both zero.
1415      */
1416     function _extraData(
1417         address from,
1418         address to,
1419         uint24 previousExtraData
1420     ) internal view virtual returns (uint24) {}
1421 
1422     /**
1423      * @dev Returns the next extra data for the packed ownership data.
1424      * The returned result is shifted into position.
1425      */
1426     function _nextExtraData(
1427         address from,
1428         address to,
1429         uint256 prevOwnershipPacked
1430     ) private view returns (uint256) {
1431         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1432         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1433     }
1434 
1435     // =============================================================
1436     //                       OTHER OPERATIONS
1437     // =============================================================
1438 
1439     /**
1440      * @dev Returns the message sender (defaults to `msg.sender`).
1441      *
1442      * If you are writing GSN compatible contracts, you need to override this function.
1443      */
1444     function _msgSenderERC721A() internal view virtual returns (address) {
1445         return msg.sender;
1446     }
1447 
1448     /**
1449      * @dev Converts a uint256 to its ASCII string decimal representation.
1450      */
1451     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1452         assembly {
1453             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1454             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1455             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1456             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1457             let m := add(mload(0x40), 0xa0)
1458             // Update the free memory pointer to allocate.
1459             mstore(0x40, m)
1460             // Assign the `str` to the end.
1461             str := sub(m, 0x20)
1462             // Zeroize the slot after the string.
1463             mstore(str, 0)
1464 
1465             // Cache the end of the memory to calculate the length later.
1466             let end := str
1467 
1468             // We write the string from rightmost digit to leftmost digit.
1469             // The following is essentially a do-while loop that also handles the zero case.
1470             // prettier-ignore
1471             for { let temp := value } 1 {} {
1472                 str := sub(str, 1)
1473                 // Write the character to the pointer.
1474                 // The ASCII index of the '0' character is 48.
1475                 mstore8(str, add(48, mod(temp, 10)))
1476                 // Keep dividing `temp` until zero.
1477                 temp := div(temp, 10)
1478                 // prettier-ignore
1479                 if iszero(temp) { break }
1480             }
1481 
1482             let length := sub(end, str)
1483             // Move the pointer 32 bytes leftwards to make room for the length.
1484             str := sub(str, 0x20)
1485             // Store the length.
1486             mstore(str, length)
1487         }
1488     }
1489 }
1490 
1491 // File: contracts/milady.sol
1492 
1493 
1494 pragma solidity ^0.8.4;
1495 
1496 
1497 
1498 contract BoringMilady is ERC721A, Ownable {
1499 
1500     string private baseURI;
1501     uint public price = 0.002 ether;
1502     uint256 public maxPerTx = 5;
1503     uint256 public maxFreePerWallet = 3;
1504     uint256 public maxSupply = 5555;
1505     uint256 public maxFreeSupply = 2555;
1506     bool public mintEnabled = false;
1507 
1508     mapping(address => uint256) private _mintedFreeAmount;
1509 
1510     constructor(string memory _name, string memory _symbol) ERC721A(_name, _symbol) {
1511         _safeMint(msg.sender, 3);
1512         setBaseURI("ipfs://QmWXdXpNstJt5kvgFgEhpDk9cnhrnhZYkMK7zKhDwPNQx4/");
1513     }
1514 
1515     function mint(uint256 count) external payable {
1516         uint256 cost = price;
1517         bool isFree = ((totalSupply() + count < maxFreeSupply + 1) &&
1518             (_mintedFreeAmount[msg.sender] + count <= maxFreePerWallet));
1519 
1520         if (isFree) {
1521             cost = 0;
1522         }
1523 
1524         require(msg.value >= count * cost, "Not enough ether sent");
1525         require(totalSupply() + count < maxSupply + 1, "Not enough tokens left");
1526         require(mintEnabled, "Mint is not live yet.");
1527         require(count + _numberMinted(msg.sender) <= maxPerTx, "Exceeded the limit");
1528         require(tx.origin == msg.sender, "Contract minting is not allowed");
1529 
1530 
1531         if (isFree) {
1532             _mintedFreeAmount[msg.sender] += count;
1533         }
1534 
1535         _safeMint(msg.sender, count);
1536     }
1537 
1538     function flipSale() external onlyOwner {
1539         mintEnabled = !mintEnabled;
1540     }
1541 
1542     function withdraw() external payable onlyOwner {
1543         payable(owner()).transfer(address(this).balance);
1544     }
1545 
1546     function _baseURI() internal view virtual override returns (string memory) {
1547         return baseURI;
1548     }
1549 
1550     function setBaseURI(string memory uri) public onlyOwner {
1551         baseURI = uri;
1552     }
1553 
1554     function setPrice(uint256 _price) public onlyOwner {
1555         price = _price;
1556     }
1557 }