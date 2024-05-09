1 // Sources flattened with hardhat v2.12.3 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/Context.sol@v4.8.0
4 
5 // SPDX-License-Identifier: MIT
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
30 
31 // File @openzeppelin/contracts/access/Ownable.sol@v4.8.0
32 
33 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
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
114 
115 // File erc721a/contracts/IERC721A.sol@v4.2.3
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
399 
400 // File erc721a/contracts/ERC721A.sol@v4.2.3
401 
402 // ERC721A Contracts v4.2.3
403 // Creator: Chiru Labs
404 
405 pragma solidity ^0.8.4;
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
1491 
1492 // File @openzeppelin/contracts/utils/math/Math.sol@v4.8.0
1493 
1494 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
1495 
1496 pragma solidity ^0.8.0;
1497 
1498 /**
1499  * @dev Standard math utilities missing in the Solidity language.
1500  */
1501 library Math {
1502     enum Rounding {
1503         Down, // Toward negative infinity
1504         Up, // Toward infinity
1505         Zero // Toward zero
1506     }
1507 
1508     /**
1509      * @dev Returns the largest of two numbers.
1510      */
1511     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1512         return a > b ? a : b;
1513     }
1514 
1515     /**
1516      * @dev Returns the smallest of two numbers.
1517      */
1518     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1519         return a < b ? a : b;
1520     }
1521 
1522     /**
1523      * @dev Returns the average of two numbers. The result is rounded towards
1524      * zero.
1525      */
1526     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1527         // (a + b) / 2 can overflow.
1528         return (a & b) + (a ^ b) / 2;
1529     }
1530 
1531     /**
1532      * @dev Returns the ceiling of the division of two numbers.
1533      *
1534      * This differs from standard division with `/` in that it rounds up instead
1535      * of rounding down.
1536      */
1537     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
1538         // (a + b - 1) / b can overflow on addition, so we distribute.
1539         return a == 0 ? 0 : (a - 1) / b + 1;
1540     }
1541 
1542     /**
1543      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
1544      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
1545      * with further edits by Uniswap Labs also under MIT license.
1546      */
1547     function mulDiv(
1548         uint256 x,
1549         uint256 y,
1550         uint256 denominator
1551     ) internal pure returns (uint256 result) {
1552         unchecked {
1553             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
1554             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
1555             // variables such that product = prod1 * 2^256 + prod0.
1556             uint256 prod0; // Least significant 256 bits of the product
1557             uint256 prod1; // Most significant 256 bits of the product
1558             assembly {
1559                 let mm := mulmod(x, y, not(0))
1560                 prod0 := mul(x, y)
1561                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
1562             }
1563 
1564             // Handle non-overflow cases, 256 by 256 division.
1565             if (prod1 == 0) {
1566                 return prod0 / denominator;
1567             }
1568 
1569             // Make sure the result is less than 2^256. Also prevents denominator == 0.
1570             require(denominator > prod1);
1571 
1572             ///////////////////////////////////////////////
1573             // 512 by 256 division.
1574             ///////////////////////////////////////////////
1575 
1576             // Make division exact by subtracting the remainder from [prod1 prod0].
1577             uint256 remainder;
1578             assembly {
1579                 // Compute remainder using mulmod.
1580                 remainder := mulmod(x, y, denominator)
1581 
1582                 // Subtract 256 bit number from 512 bit number.
1583                 prod1 := sub(prod1, gt(remainder, prod0))
1584                 prod0 := sub(prod0, remainder)
1585             }
1586 
1587             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
1588             // See https://cs.stackexchange.com/q/138556/92363.
1589 
1590             // Does not overflow because the denominator cannot be zero at this stage in the function.
1591             uint256 twos = denominator & (~denominator + 1);
1592             assembly {
1593                 // Divide denominator by twos.
1594                 denominator := div(denominator, twos)
1595 
1596                 // Divide [prod1 prod0] by twos.
1597                 prod0 := div(prod0, twos)
1598 
1599                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
1600                 twos := add(div(sub(0, twos), twos), 1)
1601             }
1602 
1603             // Shift in bits from prod1 into prod0.
1604             prod0 |= prod1 * twos;
1605 
1606             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
1607             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
1608             // four bits. That is, denominator * inv = 1 mod 2^4.
1609             uint256 inverse = (3 * denominator) ^ 2;
1610 
1611             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
1612             // in modular arithmetic, doubling the correct bits in each step.
1613             inverse *= 2 - denominator * inverse; // inverse mod 2^8
1614             inverse *= 2 - denominator * inverse; // inverse mod 2^16
1615             inverse *= 2 - denominator * inverse; // inverse mod 2^32
1616             inverse *= 2 - denominator * inverse; // inverse mod 2^64
1617             inverse *= 2 - denominator * inverse; // inverse mod 2^128
1618             inverse *= 2 - denominator * inverse; // inverse mod 2^256
1619 
1620             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
1621             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
1622             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
1623             // is no longer required.
1624             result = prod0 * inverse;
1625             return result;
1626         }
1627     }
1628 
1629     /**
1630      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
1631      */
1632     function mulDiv(
1633         uint256 x,
1634         uint256 y,
1635         uint256 denominator,
1636         Rounding rounding
1637     ) internal pure returns (uint256) {
1638         uint256 result = mulDiv(x, y, denominator);
1639         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
1640             result += 1;
1641         }
1642         return result;
1643     }
1644 
1645     /**
1646      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
1647      *
1648      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
1649      */
1650     function sqrt(uint256 a) internal pure returns (uint256) {
1651         if (a == 0) {
1652             return 0;
1653         }
1654 
1655         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
1656         //
1657         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
1658         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
1659         //
1660         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
1661         // ΓåÆ `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
1662         // ΓåÆ `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
1663         //
1664         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
1665         uint256 result = 1 << (log2(a) >> 1);
1666 
1667         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
1668         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
1669         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
1670         // into the expected uint128 result.
1671         unchecked {
1672             result = (result + a / result) >> 1;
1673             result = (result + a / result) >> 1;
1674             result = (result + a / result) >> 1;
1675             result = (result + a / result) >> 1;
1676             result = (result + a / result) >> 1;
1677             result = (result + a / result) >> 1;
1678             result = (result + a / result) >> 1;
1679             return min(result, a / result);
1680         }
1681     }
1682 
1683     /**
1684      * @notice Calculates sqrt(a), following the selected rounding direction.
1685      */
1686     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
1687         unchecked {
1688             uint256 result = sqrt(a);
1689             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
1690         }
1691     }
1692 
1693     /**
1694      * @dev Return the log in base 2, rounded down, of a positive value.
1695      * Returns 0 if given 0.
1696      */
1697     function log2(uint256 value) internal pure returns (uint256) {
1698         uint256 result = 0;
1699         unchecked {
1700             if (value >> 128 > 0) {
1701                 value >>= 128;
1702                 result += 128;
1703             }
1704             if (value >> 64 > 0) {
1705                 value >>= 64;
1706                 result += 64;
1707             }
1708             if (value >> 32 > 0) {
1709                 value >>= 32;
1710                 result += 32;
1711             }
1712             if (value >> 16 > 0) {
1713                 value >>= 16;
1714                 result += 16;
1715             }
1716             if (value >> 8 > 0) {
1717                 value >>= 8;
1718                 result += 8;
1719             }
1720             if (value >> 4 > 0) {
1721                 value >>= 4;
1722                 result += 4;
1723             }
1724             if (value >> 2 > 0) {
1725                 value >>= 2;
1726                 result += 2;
1727             }
1728             if (value >> 1 > 0) {
1729                 result += 1;
1730             }
1731         }
1732         return result;
1733     }
1734 
1735     /**
1736      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
1737      * Returns 0 if given 0.
1738      */
1739     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
1740         unchecked {
1741             uint256 result = log2(value);
1742             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
1743         }
1744     }
1745 
1746     /**
1747      * @dev Return the log in base 10, rounded down, of a positive value.
1748      * Returns 0 if given 0.
1749      */
1750     function log10(uint256 value) internal pure returns (uint256) {
1751         uint256 result = 0;
1752         unchecked {
1753             if (value >= 10**64) {
1754                 value /= 10**64;
1755                 result += 64;
1756             }
1757             if (value >= 10**32) {
1758                 value /= 10**32;
1759                 result += 32;
1760             }
1761             if (value >= 10**16) {
1762                 value /= 10**16;
1763                 result += 16;
1764             }
1765             if (value >= 10**8) {
1766                 value /= 10**8;
1767                 result += 8;
1768             }
1769             if (value >= 10**4) {
1770                 value /= 10**4;
1771                 result += 4;
1772             }
1773             if (value >= 10**2) {
1774                 value /= 10**2;
1775                 result += 2;
1776             }
1777             if (value >= 10**1) {
1778                 result += 1;
1779             }
1780         }
1781         return result;
1782     }
1783 
1784     /**
1785      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1786      * Returns 0 if given 0.
1787      */
1788     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
1789         unchecked {
1790             uint256 result = log10(value);
1791             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
1792         }
1793     }
1794 
1795     /**
1796      * @dev Return the log in base 256, rounded down, of a positive value.
1797      * Returns 0 if given 0.
1798      *
1799      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
1800      */
1801     function log256(uint256 value) internal pure returns (uint256) {
1802         uint256 result = 0;
1803         unchecked {
1804             if (value >> 128 > 0) {
1805                 value >>= 128;
1806                 result += 16;
1807             }
1808             if (value >> 64 > 0) {
1809                 value >>= 64;
1810                 result += 8;
1811             }
1812             if (value >> 32 > 0) {
1813                 value >>= 32;
1814                 result += 4;
1815             }
1816             if (value >> 16 > 0) {
1817                 value >>= 16;
1818                 result += 2;
1819             }
1820             if (value >> 8 > 0) {
1821                 result += 1;
1822             }
1823         }
1824         return result;
1825     }
1826 
1827     /**
1828      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1829      * Returns 0 if given 0.
1830      */
1831     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
1832         unchecked {
1833             uint256 result = log256(value);
1834             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
1835         }
1836     }
1837 }
1838 
1839 
1840 // File @openzeppelin/contracts/utils/Strings.sol@v4.8.0
1841 
1842 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
1843 
1844 pragma solidity ^0.8.0;
1845 
1846 /**
1847  * @dev String operations.
1848  */
1849 library Strings {
1850     bytes16 private constant _SYMBOLS = "0123456789abcdef";
1851     uint8 private constant _ADDRESS_LENGTH = 20;
1852 
1853     /**
1854      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1855      */
1856     function toString(uint256 value) internal pure returns (string memory) {
1857         unchecked {
1858             uint256 length = Math.log10(value) + 1;
1859             string memory buffer = new string(length);
1860             uint256 ptr;
1861             /// @solidity memory-safe-assembly
1862             assembly {
1863                 ptr := add(buffer, add(32, length))
1864             }
1865             while (true) {
1866                 ptr--;
1867                 /// @solidity memory-safe-assembly
1868                 assembly {
1869                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
1870                 }
1871                 value /= 10;
1872                 if (value == 0) break;
1873             }
1874             return buffer;
1875         }
1876     }
1877 
1878     /**
1879      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1880      */
1881     function toHexString(uint256 value) internal pure returns (string memory) {
1882         unchecked {
1883             return toHexString(value, Math.log256(value) + 1);
1884         }
1885     }
1886 
1887     /**
1888      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1889      */
1890     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1891         bytes memory buffer = new bytes(2 * length + 2);
1892         buffer[0] = "0";
1893         buffer[1] = "x";
1894         for (uint256 i = 2 * length + 1; i > 1; --i) {
1895             buffer[i] = _SYMBOLS[value & 0xf];
1896             value >>= 4;
1897         }
1898         require(value == 0, "Strings: hex length insufficient");
1899         return string(buffer);
1900     }
1901 
1902     /**
1903      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1904      */
1905     function toHexString(address addr) internal pure returns (string memory) {
1906         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1907     }
1908 }
1909 
1910 
1911 // File @openzeppelin/contracts/security/Pausable.sol@v4.8.0
1912 
1913 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
1914 
1915 pragma solidity ^0.8.0;
1916 
1917 /**
1918  * @dev Contract module which allows children to implement an emergency stop
1919  * mechanism that can be triggered by an authorized account.
1920  *
1921  * This module is used through inheritance. It will make available the
1922  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1923  * the functions of your contract. Note that they will not be pausable by
1924  * simply including this module, only once the modifiers are put in place.
1925  */
1926 abstract contract Pausable is Context {
1927     /**
1928      * @dev Emitted when the pause is triggered by `account`.
1929      */
1930     event Paused(address account);
1931 
1932     /**
1933      * @dev Emitted when the pause is lifted by `account`.
1934      */
1935     event Unpaused(address account);
1936 
1937     bool private _paused;
1938 
1939     /**
1940      * @dev Initializes the contract in unpaused state.
1941      */
1942     constructor() {
1943         _paused = false;
1944     }
1945 
1946     /**
1947      * @dev Modifier to make a function callable only when the contract is not paused.
1948      *
1949      * Requirements:
1950      *
1951      * - The contract must not be paused.
1952      */
1953     modifier whenNotPaused() {
1954         _requireNotPaused();
1955         _;
1956     }
1957 
1958     /**
1959      * @dev Modifier to make a function callable only when the contract is paused.
1960      *
1961      * Requirements:
1962      *
1963      * - The contract must be paused.
1964      */
1965     modifier whenPaused() {
1966         _requirePaused();
1967         _;
1968     }
1969 
1970     /**
1971      * @dev Returns true if the contract is paused, and false otherwise.
1972      */
1973     function paused() public view virtual returns (bool) {
1974         return _paused;
1975     }
1976 
1977     /**
1978      * @dev Throws if the contract is paused.
1979      */
1980     function _requireNotPaused() internal view virtual {
1981         require(!paused(), "Pausable: paused");
1982     }
1983 
1984     /**
1985      * @dev Throws if the contract is not paused.
1986      */
1987     function _requirePaused() internal view virtual {
1988         require(paused(), "Pausable: not paused");
1989     }
1990 
1991     /**
1992      * @dev Triggers stopped state.
1993      *
1994      * Requirements:
1995      *
1996      * - The contract must not be paused.
1997      */
1998     function _pause() internal virtual whenNotPaused {
1999         _paused = true;
2000         emit Paused(_msgSender());
2001     }
2002 
2003     /**
2004      * @dev Returns to normal state.
2005      *
2006      * Requirements:
2007      *
2008      * - The contract must be paused.
2009      */
2010     function _unpause() internal virtual whenPaused {
2011         _paused = false;
2012         emit Unpaused(_msgSender());
2013     }
2014 }
2015 
2016 
2017 // File contracts/InterstellarSamuraiNFT.sol
2018 
2019 //Contract based on [https://docs.openzeppelin.com/contracts/3.x/erc721](https://docs.openzeppelin.com/contracts/3.x/erc721)
2020 pragma solidity ^0.8.17;
2021 interface IVRFConsumer {
2022     /// @dev The function is called by the VRF provider in order to deliver results to the consumer.
2023     /// @param seed Any string that used to initialize the randomizer.
2024     /// @param time Timestamp where the random data was created.
2025     /// @param result A random bytes for given seed anfd time.
2026     function consume(
2027         string calldata seed,
2028         uint64 time,
2029         bytes32 result
2030     ) external;
2031 }
2032 
2033 interface IVRFProvider {
2034     /// @dev The function for consumers who want random data.
2035     /// Consumers can simply make requests to get random data back later.
2036     /// @param seed Any string that used to initialize the randomizer.
2037     function requestRandomData(string calldata seed) external payable;
2038 }
2039 
2040 contract InterstellarSamuraiNFT is ERC721A, Ownable, Pausable, IVRFConsumer {
2041     event RandomResolved(string seed, uint64 time, bytes32 result);
2042     event RoundChanged(ROUND);
2043 
2044     enum ROUND {
2045         NONE,
2046         PRIVATE,
2047         PUBLIC
2048     }
2049 
2050     using Strings for uint256;
2051 
2052     ROUND public round = ROUND.PRIVATE;
2053 
2054     string public baseURI = "";
2055 
2056     uint256 public constant maxSupply = 4444;
2057 
2058     uint256 public constant price = 0 ether;
2059 
2060     uint256 public constant maxQuantity = 3;
2061 
2062     IVRFProvider public provider;
2063 
2064     bool private VRFRequested = false;
2065 
2066     string public VRFSeed;
2067 
2068     uint64 public VRFTime;
2069 
2070     bytes32 public VRFResult;
2071 
2072     constructor(
2073         string memory _name,
2074         string memory _symbol,
2075         IVRFProvider _provider
2076     ) ERC721A(_name, _symbol) {
2077         provider = _provider;
2078     }
2079 
2080     function _baseURI() internal view virtual override returns (string memory) {
2081         return baseURI;
2082     }
2083 
2084     function tokenURI(uint256 tokenId)
2085         public
2086         view
2087         virtual
2088         override
2089         returns (string memory)
2090     {
2091         require(
2092             _exists(tokenId),
2093             "ERC721Metadata: URI query for nonexistent token"
2094         );
2095 
2096         string memory currentBaseURI = _baseURI();
2097         return
2098             bytes(currentBaseURI).length > 0
2099                 ? string(abi.encodePacked(currentBaseURI, tokenId.toString()))
2100                 : "";
2101     }
2102 
2103     function mint(uint256 _quantity) external payable whenNotPaused {
2104         require(round == ROUND.PUBLIC);
2105         uint256 supply = totalSupply();
2106 
2107         require(_quantity > 0, "invalid quantity.");
2108         require(_quantity <= maxQuantity, "quantity exceeds");
2109 
2110         require(
2111             balanceOf(msg.sender) < maxQuantity,
2112             "Max mint per wallet exceeds"
2113         );
2114 
2115         require(supply + _quantity <= maxSupply, "exceeds max supply.");
2116         require(msg.value >= price * _quantity);
2117 
2118         _safeMint(msg.sender, _quantity);
2119     }
2120 
2121     function setRound(ROUND _round) external onlyOwner {
2122         round = _round;
2123         emit RoundChanged(_round);
2124     }
2125 
2126     function setBaseURI(string memory _newBaseURI) external onlyOwner {
2127         baseURI = _newBaseURI;
2128     }
2129 
2130     function setVRFProvider(IVRFProvider _provider) external onlyOwner {
2131         provider = _provider;
2132     }
2133 
2134     function pause(bool _state) external onlyOwner {
2135         if (_state) {
2136             _pause();
2137         } else {
2138             _unpause();
2139         }
2140     }
2141 
2142     function withdraw() external payable onlyOwner {
2143         (bool success, ) = payable(msg.sender).call{
2144             value: address(this).balance
2145         }("");
2146         require(success);
2147     }
2148 
2149     function requestRandomFromVRF(string calldata _seed) external onlyOwner {
2150         require(!VRFRequested, "Only one time request random from VRF.");
2151         provider.requestRandomData{value: 0}(_seed);
2152         VRFRequested = true;
2153     }
2154 
2155     function consume(
2156         string calldata _seed,
2157         uint64 _time,
2158         bytes32 _result
2159     ) external override {
2160         require(msg.sender == address(provider), "Caller is not the provider");
2161         emit RandomResolved(_seed, _time, _result);
2162 
2163         VRFSeed = _seed;
2164         VRFTime = _time;
2165         VRFResult = _result;
2166     }
2167 
2168     function VRFRandomProof(uint256 _tokenId, uint256 _traitId)
2169         external
2170         view
2171         returns (bytes32)
2172     {
2173         return hashRandomSeedFromVRF(_tokenId, _traitId);
2174     }
2175 
2176     function hashSeed(uint256 _tokenId, uint256 _traitId)
2177         external
2178         view
2179         returns (uint256)
2180     {
2181         bytes32 proof = hashRandomSeedFromVRF(_tokenId, _traitId);
2182 
2183         string memory seed = uint256(proof).toString();
2184         uint256 hash = 0;
2185         uint256 k = 281997; // Pre-compute 281 * 997
2186         for (uint256 i = 0; i < bytes(seed).length / 1; i++) {
2187             hash = ((hash * k) ^ uint8(bytes(seed)[i])) & 0xFFFFFFFF;
2188         }
2189         return hash;
2190     }
2191 
2192     function hashRandomSeedFromVRF(uint256 _tokenId, uint256 _traitId)
2193         internal
2194         view
2195         returns (bytes32)
2196     {
2197         return
2198             keccak256(
2199                 abi.encodePacked(
2200                     uint256(VRFResult).toString(),
2201                     _tokenId.toString(),
2202                     _traitId.toString()
2203                 )
2204             );
2205     }
2206 }