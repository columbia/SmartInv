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
399 // File: erc721a/contracts/ERC721A.sol
400 
401 
402 // ERC721A Contracts v4.2.3
403 // Creator: Chiru Labs
404 
405 pragma solidity ^0.8.4;
406 
407 
408 /**
409  * @dev Interface of ERC721 token receiver.
410  */
411 interface ERC721A__IERC721Receiver {
412     function onERC721Received(
413         address operator,
414         address from,
415         uint256 tokenId,
416         bytes calldata data
417     ) external returns (bytes4);
418 }
419 
420 /**
421  * @title ERC721A
422  *
423  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
424  * Non-Fungible Token Standard, including the Metadata extension.
425  * Optimized for lower gas during batch mints.
426  *
427  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
428  * starting from `_startTokenId()`.
429  *
430  * Assumptions:
431  *
432  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
433  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
434  */
435 contract ERC721A is IERC721A {
436     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
437     struct TokenApprovalRef {
438         address value;
439     }
440 
441     // =============================================================
442     //                           CONSTANTS
443     // =============================================================
444 
445     // Mask of an entry in packed address data.
446     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
447 
448     // The bit position of `numberMinted` in packed address data.
449     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
450 
451     // The bit position of `numberBurned` in packed address data.
452     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
453 
454     // The bit position of `aux` in packed address data.
455     uint256 private constant _BITPOS_AUX = 192;
456 
457     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
458     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
459 
460     // The bit position of `startTimestamp` in packed ownership.
461     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
462 
463     // The bit mask of the `burned` bit in packed ownership.
464     uint256 private constant _BITMASK_BURNED = 1 << 224;
465 
466     // The bit position of the `nextInitialized` bit in packed ownership.
467     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
468 
469     // The bit mask of the `nextInitialized` bit in packed ownership.
470     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
471 
472     // The bit position of `extraData` in packed ownership.
473     uint256 private constant _BITPOS_EXTRA_DATA = 232;
474 
475     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
476     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
477 
478     // The mask of the lower 160 bits for addresses.
479     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
480 
481     // The maximum `quantity` that can be minted with {_mintERC2309}.
482     // This limit is to prevent overflows on the address data entries.
483     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
484     // is required to cause an overflow, which is unrealistic.
485     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
486 
487     // The `Transfer` event signature is given by:
488     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
489     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
490         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
491 
492     // =============================================================
493     //                            STORAGE
494     // =============================================================
495 
496     // The next token ID to be minted.
497     uint256 private _currentIndex;
498 
499     // The number of tokens burned.
500     uint256 private _burnCounter;
501 
502     // Token name
503     string private _name;
504 
505     // Token symbol
506     string private _symbol;
507 
508     // Mapping from token ID to ownership details
509     // An empty struct value does not necessarily mean the token is unowned.
510     // See {_packedOwnershipOf} implementation for details.
511     //
512     // Bits Layout:
513     // - [0..159]   `addr`
514     // - [160..223] `startTimestamp`
515     // - [224]      `burned`
516     // - [225]      `nextInitialized`
517     // - [232..255] `extraData`
518     mapping(uint256 => uint256) private _packedOwnerships;
519 
520     // Mapping owner address to address data.
521     //
522     // Bits Layout:
523     // - [0..63]    `balance`
524     // - [64..127]  `numberMinted`
525     // - [128..191] `numberBurned`
526     // - [192..255] `aux`
527     mapping(address => uint256) private _packedAddressData;
528 
529     // Mapping from token ID to approved address.
530     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
531 
532     // Mapping from owner to operator approvals
533     mapping(address => mapping(address => bool)) private _operatorApprovals;
534 
535     // =============================================================
536     //                          CONSTRUCTOR
537     // =============================================================
538 
539     constructor(string memory name_, string memory symbol_) {
540         _name = name_;
541         _symbol = symbol_;
542         _currentIndex = _startTokenId();
543     }
544 
545     // =============================================================
546     //                   TOKEN COUNTING OPERATIONS
547     // =============================================================
548 
549     /**
550      * @dev Returns the starting token ID.
551      * To change the starting token ID, please override this function.
552      */
553     function _startTokenId() internal view virtual returns (uint256) {
554         return 0;
555     }
556 
557     /**
558      * @dev Returns the next token ID to be minted.
559      */
560     function _nextTokenId() internal view virtual returns (uint256) {
561         return _currentIndex;
562     }
563 
564     /**
565      * @dev Returns the total number of tokens in existence.
566      * Burned tokens will reduce the count.
567      * To get the total number of tokens minted, please see {_totalMinted}.
568      */
569     function totalSupply() public view virtual override returns (uint256) {
570         // Counter underflow is impossible as _burnCounter cannot be incremented
571         // more than `_currentIndex - _startTokenId()` times.
572         unchecked {
573             return _currentIndex - _burnCounter - _startTokenId();
574         }
575     }
576 
577     /**
578      * @dev Returns the total amount of tokens minted in the contract.
579      */
580     function _totalMinted() internal view virtual returns (uint256) {
581         // Counter underflow is impossible as `_currentIndex` does not decrement,
582         // and it is initialized to `_startTokenId()`.
583         unchecked {
584             return _currentIndex - _startTokenId();
585         }
586     }
587 
588     /**
589      * @dev Returns the total number of tokens burned.
590      */
591     function _totalBurned() internal view virtual returns (uint256) {
592         return _burnCounter;
593     }
594 
595     // =============================================================
596     //                    ADDRESS DATA OPERATIONS
597     // =============================================================
598 
599     /**
600      * @dev Returns the number of tokens in `owner`'s account.
601      */
602     function balanceOf(address owner) public view virtual override returns (uint256) {
603         if (owner == address(0)) revert BalanceQueryForZeroAddress();
604         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
605     }
606 
607     /**
608      * Returns the number of tokens minted by `owner`.
609      */
610     function _numberMinted(address owner) internal view returns (uint256) {
611         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
612     }
613 
614     /**
615      * Returns the number of tokens burned by or on behalf of `owner`.
616      */
617     function _numberBurned(address owner) internal view returns (uint256) {
618         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
619     }
620 
621     /**
622      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
623      */
624     function _getAux(address owner) internal view returns (uint64) {
625         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
626     }
627 
628     /**
629      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
630      * If there are multiple variables, please pack them into a uint64.
631      */
632     function _setAux(address owner, uint64 aux) internal virtual {
633         uint256 packed = _packedAddressData[owner];
634         uint256 auxCasted;
635         // Cast `aux` with assembly to avoid redundant masking.
636         assembly {
637             auxCasted := aux
638         }
639         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
640         _packedAddressData[owner] = packed;
641     }
642 
643     // =============================================================
644     //                            IERC165
645     // =============================================================
646 
647     /**
648      * @dev Returns true if this contract implements the interface defined by
649      * `interfaceId`. See the corresponding
650      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
651      * to learn more about how these ids are created.
652      *
653      * This function call must use less than 30000 gas.
654      */
655     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
656         // The interface IDs are constants representing the first 4 bytes
657         // of the XOR of all function selectors in the interface.
658         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
659         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
660         return
661             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
662             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
663             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
664     }
665 
666     // =============================================================
667     //                        IERC721Metadata
668     // =============================================================
669 
670     /**
671      * @dev Returns the token collection name.
672      */
673     function name() public view virtual override returns (string memory) {
674         return _name;
675     }
676 
677     /**
678      * @dev Returns the token collection symbol.
679      */
680     function symbol() public view virtual override returns (string memory) {
681         return _symbol;
682     }
683 
684     /**
685      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
686      */
687     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
688         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
689 
690         string memory baseURI = _baseURI();
691         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
692     }
693 
694     /**
695      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
696      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
697      * by default, it can be overridden in child contracts.
698      */
699     function _baseURI() internal view virtual returns (string memory) {
700         return '';
701     }
702 
703     // =============================================================
704     //                     OWNERSHIPS OPERATIONS
705     // =============================================================
706 
707     /**
708      * @dev Returns the owner of the `tokenId` token.
709      *
710      * Requirements:
711      *
712      * - `tokenId` must exist.
713      */
714     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
715         return address(uint160(_packedOwnershipOf(tokenId)));
716     }
717 
718     /**
719      * @dev Gas spent here starts off proportional to the maximum mint batch size.
720      * It gradually moves to O(1) as tokens get transferred around over time.
721      */
722     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
723         return _unpackedOwnership(_packedOwnershipOf(tokenId));
724     }
725 
726     /**
727      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
728      */
729     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
730         return _unpackedOwnership(_packedOwnerships[index]);
731     }
732 
733     /**
734      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
735      */
736     function _initializeOwnershipAt(uint256 index) internal virtual {
737         if (_packedOwnerships[index] == 0) {
738             _packedOwnerships[index] = _packedOwnershipOf(index);
739         }
740     }
741 
742     /**
743      * Returns the packed ownership data of `tokenId`.
744      */
745     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
746         uint256 curr = tokenId;
747 
748         unchecked {
749             if (_startTokenId() <= curr)
750                 if (curr < _currentIndex) {
751                     uint256 packed = _packedOwnerships[curr];
752                     // If not burned.
753                     if (packed & _BITMASK_BURNED == 0) {
754                         // Invariant:
755                         // There will always be an initialized ownership slot
756                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
757                         // before an unintialized ownership slot
758                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
759                         // Hence, `curr` will not underflow.
760                         //
761                         // We can directly compare the packed value.
762                         // If the address is zero, packed will be zero.
763                         while (packed == 0) {
764                             packed = _packedOwnerships[--curr];
765                         }
766                         return packed;
767                     }
768                 }
769         }
770         revert OwnerQueryForNonexistentToken();
771     }
772 
773     /**
774      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
775      */
776     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
777         ownership.addr = address(uint160(packed));
778         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
779         ownership.burned = packed & _BITMASK_BURNED != 0;
780         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
781     }
782 
783     /**
784      * @dev Packs ownership data into a single uint256.
785      */
786     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
787         assembly {
788             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
789             owner := and(owner, _BITMASK_ADDRESS)
790             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
791             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
792         }
793     }
794 
795     /**
796      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
797      */
798     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
799         // For branchless setting of the `nextInitialized` flag.
800         assembly {
801             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
802             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
803         }
804     }
805 
806     // =============================================================
807     //                      APPROVAL OPERATIONS
808     // =============================================================
809 
810     /**
811      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
812      * The approval is cleared when the token is transferred.
813      *
814      * Only a single account can be approved at a time, so approving the
815      * zero address clears previous approvals.
816      *
817      * Requirements:
818      *
819      * - The caller must own the token or be an approved operator.
820      * - `tokenId` must exist.
821      *
822      * Emits an {Approval} event.
823      */
824     function approve(address to, uint256 tokenId) public payable virtual override {
825         address owner = ownerOf(tokenId);
826 
827         if (_msgSenderERC721A() != owner)
828             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
829                 revert ApprovalCallerNotOwnerNorApproved();
830             }
831 
832         _tokenApprovals[tokenId].value = to;
833         emit Approval(owner, to, tokenId);
834     }
835 
836     /**
837      * @dev Returns the account approved for `tokenId` token.
838      *
839      * Requirements:
840      *
841      * - `tokenId` must exist.
842      */
843     function getApproved(uint256 tokenId) public view virtual override returns (address) {
844         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
845 
846         return _tokenApprovals[tokenId].value;
847     }
848 
849     /**
850      * @dev Approve or remove `operator` as an operator for the caller.
851      * Operators can call {transferFrom} or {safeTransferFrom}
852      * for any token owned by the caller.
853      *
854      * Requirements:
855      *
856      * - The `operator` cannot be the caller.
857      *
858      * Emits an {ApprovalForAll} event.
859      */
860     function setApprovalForAll(address operator, bool approved) public virtual override {
861         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
862         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
863     }
864 
865     /**
866      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
867      *
868      * See {setApprovalForAll}.
869      */
870     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
871         return _operatorApprovals[owner][operator];
872     }
873 
874     /**
875      * @dev Returns whether `tokenId` exists.
876      *
877      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
878      *
879      * Tokens start existing when they are minted. See {_mint}.
880      */
881     function _exists(uint256 tokenId) internal view virtual returns (bool) {
882         return
883             _startTokenId() <= tokenId &&
884             tokenId < _currentIndex && // If within bounds,
885             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
886     }
887 
888     /**
889      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
890      */
891     function _isSenderApprovedOrOwner(
892         address approvedAddress,
893         address owner,
894         address msgSender
895     ) private pure returns (bool result) {
896         assembly {
897             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
898             owner := and(owner, _BITMASK_ADDRESS)
899             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
900             msgSender := and(msgSender, _BITMASK_ADDRESS)
901             // `msgSender == owner || msgSender == approvedAddress`.
902             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
903         }
904     }
905 
906     /**
907      * @dev Returns the storage slot and value for the approved address of `tokenId`.
908      */
909     function _getApprovedSlotAndAddress(uint256 tokenId)
910         private
911         view
912         returns (uint256 approvedAddressSlot, address approvedAddress)
913     {
914         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
915         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
916         assembly {
917             approvedAddressSlot := tokenApproval.slot
918             approvedAddress := sload(approvedAddressSlot)
919         }
920     }
921 
922     // =============================================================
923     //                      TRANSFER OPERATIONS
924     // =============================================================
925 
926     /**
927      * @dev Transfers `tokenId` from `from` to `to`.
928      *
929      * Requirements:
930      *
931      * - `from` cannot be the zero address.
932      * - `to` cannot be the zero address.
933      * - `tokenId` token must be owned by `from`.
934      * - If the caller is not `from`, it must be approved to move this token
935      * by either {approve} or {setApprovalForAll}.
936      *
937      * Emits a {Transfer} event.
938      */
939     function transferFrom(
940         address from,
941         address to,
942         uint256 tokenId
943     ) public payable virtual override {
944         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
945 
946         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
947 
948         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
949 
950         // The nested ifs save around 20+ gas over a compound boolean condition.
951         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
952             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
953 
954         if (to == address(0)) revert TransferToZeroAddress();
955 
956         _beforeTokenTransfers(from, to, tokenId, 1);
957 
958         // Clear approvals from the previous owner.
959         assembly {
960             if approvedAddress {
961                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
962                 sstore(approvedAddressSlot, 0)
963             }
964         }
965 
966         // Underflow of the sender's balance is impossible because we check for
967         // ownership above and the recipient's balance can't realistically overflow.
968         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
969         unchecked {
970             // We can directly increment and decrement the balances.
971             --_packedAddressData[from]; // Updates: `balance -= 1`.
972             ++_packedAddressData[to]; // Updates: `balance += 1`.
973 
974             // Updates:
975             // - `address` to the next owner.
976             // - `startTimestamp` to the timestamp of transfering.
977             // - `burned` to `false`.
978             // - `nextInitialized` to `true`.
979             _packedOwnerships[tokenId] = _packOwnershipData(
980                 to,
981                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
982             );
983 
984             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
985             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
986                 uint256 nextTokenId = tokenId + 1;
987                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
988                 if (_packedOwnerships[nextTokenId] == 0) {
989                     // If the next slot is within bounds.
990                     if (nextTokenId != _currentIndex) {
991                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
992                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
993                     }
994                 }
995             }
996         }
997 
998         emit Transfer(from, to, tokenId);
999         _afterTokenTransfers(from, to, tokenId, 1);
1000     }
1001 
1002     /**
1003      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1004      */
1005     function safeTransferFrom(
1006         address from,
1007         address to,
1008         uint256 tokenId
1009     ) public payable virtual override {
1010         safeTransferFrom(from, to, tokenId, '');
1011     }
1012 
1013     /**
1014      * @dev Safely transfers `tokenId` token from `from` to `to`.
1015      *
1016      * Requirements:
1017      *
1018      * - `from` cannot be the zero address.
1019      * - `to` cannot be the zero address.
1020      * - `tokenId` token must exist and be owned by `from`.
1021      * - If the caller is not `from`, it must be approved to move this token
1022      * by either {approve} or {setApprovalForAll}.
1023      * - If `to` refers to a smart contract, it must implement
1024      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1025      *
1026      * Emits a {Transfer} event.
1027      */
1028     function safeTransferFrom(
1029         address from,
1030         address to,
1031         uint256 tokenId,
1032         bytes memory _data
1033     ) public payable virtual override {
1034         transferFrom(from, to, tokenId);
1035         if (to.code.length != 0)
1036             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1037                 revert TransferToNonERC721ReceiverImplementer();
1038             }
1039     }
1040 
1041     /**
1042      * @dev Hook that is called before a set of serially-ordered token IDs
1043      * are about to be transferred. This includes minting.
1044      * And also called before burning one token.
1045      *
1046      * `startTokenId` - the first token ID to be transferred.
1047      * `quantity` - the amount to be transferred.
1048      *
1049      * Calling conditions:
1050      *
1051      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1052      * transferred to `to`.
1053      * - When `from` is zero, `tokenId` will be minted for `to`.
1054      * - When `to` is zero, `tokenId` will be burned by `from`.
1055      * - `from` and `to` are never both zero.
1056      */
1057     function _beforeTokenTransfers(
1058         address from,
1059         address to,
1060         uint256 startTokenId,
1061         uint256 quantity
1062     ) internal virtual {}
1063 
1064     /**
1065      * @dev Hook that is called after a set of serially-ordered token IDs
1066      * have been transferred. This includes minting.
1067      * And also called after one token has been burned.
1068      *
1069      * `startTokenId` - the first token ID to be transferred.
1070      * `quantity` - the amount to be transferred.
1071      *
1072      * Calling conditions:
1073      *
1074      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1075      * transferred to `to`.
1076      * - When `from` is zero, `tokenId` has been minted for `to`.
1077      * - When `to` is zero, `tokenId` has been burned by `from`.
1078      * - `from` and `to` are never both zero.
1079      */
1080     function _afterTokenTransfers(
1081         address from,
1082         address to,
1083         uint256 startTokenId,
1084         uint256 quantity
1085     ) internal virtual {}
1086 
1087     /**
1088      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1089      *
1090      * `from` - Previous owner of the given token ID.
1091      * `to` - Target address that will receive the token.
1092      * `tokenId` - Token ID to be transferred.
1093      * `_data` - Optional data to send along with the call.
1094      *
1095      * Returns whether the call correctly returned the expected magic value.
1096      */
1097     function _checkContractOnERC721Received(
1098         address from,
1099         address to,
1100         uint256 tokenId,
1101         bytes memory _data
1102     ) private returns (bool) {
1103         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1104             bytes4 retval
1105         ) {
1106             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1107         } catch (bytes memory reason) {
1108             if (reason.length == 0) {
1109                 revert TransferToNonERC721ReceiverImplementer();
1110             } else {
1111                 assembly {
1112                     revert(add(32, reason), mload(reason))
1113                 }
1114             }
1115         }
1116     }
1117 
1118     // =============================================================
1119     //                        MINT OPERATIONS
1120     // =============================================================
1121 
1122     /**
1123      * @dev Mints `quantity` tokens and transfers them to `to`.
1124      *
1125      * Requirements:
1126      *
1127      * - `to` cannot be the zero address.
1128      * - `quantity` must be greater than 0.
1129      *
1130      * Emits a {Transfer} event for each mint.
1131      */
1132     function _mint(address to, uint256 quantity) internal virtual {
1133         uint256 startTokenId = _currentIndex;
1134         if (quantity == 0) revert MintZeroQuantity();
1135 
1136         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1137 
1138         // Overflows are incredibly unrealistic.
1139         // `balance` and `numberMinted` have a maximum limit of 2**64.
1140         // `tokenId` has a maximum limit of 2**256.
1141         unchecked {
1142             // Updates:
1143             // - `balance += quantity`.
1144             // - `numberMinted += quantity`.
1145             //
1146             // We can directly add to the `balance` and `numberMinted`.
1147             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1148 
1149             // Updates:
1150             // - `address` to the owner.
1151             // - `startTimestamp` to the timestamp of minting.
1152             // - `burned` to `false`.
1153             // - `nextInitialized` to `quantity == 1`.
1154             _packedOwnerships[startTokenId] = _packOwnershipData(
1155                 to,
1156                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1157             );
1158 
1159             uint256 toMasked;
1160             uint256 end = startTokenId + quantity;
1161 
1162             // Use assembly to loop and emit the `Transfer` event for gas savings.
1163             // The duplicated `log4` removes an extra check and reduces stack juggling.
1164             // The assembly, together with the surrounding Solidity code, have been
1165             // delicately arranged to nudge the compiler into producing optimized opcodes.
1166             assembly {
1167                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1168                 toMasked := and(to, _BITMASK_ADDRESS)
1169                 // Emit the `Transfer` event.
1170                 log4(
1171                     0, // Start of data (0, since no data).
1172                     0, // End of data (0, since no data).
1173                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1174                     0, // `address(0)`.
1175                     toMasked, // `to`.
1176                     startTokenId // `tokenId`.
1177                 )
1178 
1179                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1180                 // that overflows uint256 will make the loop run out of gas.
1181                 // The compiler will optimize the `iszero` away for performance.
1182                 for {
1183                     let tokenId := add(startTokenId, 1)
1184                 } iszero(eq(tokenId, end)) {
1185                     tokenId := add(tokenId, 1)
1186                 } {
1187                     // Emit the `Transfer` event. Similar to above.
1188                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1189                 }
1190             }
1191             if (toMasked == 0) revert MintToZeroAddress();
1192 
1193             _currentIndex = end;
1194         }
1195         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1196     }
1197 
1198     /**
1199      * @dev Mints `quantity` tokens and transfers them to `to`.
1200      *
1201      * This function is intended for efficient minting only during contract creation.
1202      *
1203      * It emits only one {ConsecutiveTransfer} as defined in
1204      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1205      * instead of a sequence of {Transfer} event(s).
1206      *
1207      * Calling this function outside of contract creation WILL make your contract
1208      * non-compliant with the ERC721 standard.
1209      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1210      * {ConsecutiveTransfer} event is only permissible during contract creation.
1211      *
1212      * Requirements:
1213      *
1214      * - `to` cannot be the zero address.
1215      * - `quantity` must be greater than 0.
1216      *
1217      * Emits a {ConsecutiveTransfer} event.
1218      */
1219     function _mintERC2309(address to, uint256 quantity) internal virtual {
1220         uint256 startTokenId = _currentIndex;
1221         if (to == address(0)) revert MintToZeroAddress();
1222         if (quantity == 0) revert MintZeroQuantity();
1223         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1224 
1225         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1226 
1227         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
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
1246             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1247 
1248             _currentIndex = startTokenId + quantity;
1249         }
1250         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1251     }
1252 
1253     /**
1254      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1255      *
1256      * Requirements:
1257      *
1258      * - If `to` refers to a smart contract, it must implement
1259      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1260      * - `quantity` must be greater than 0.
1261      *
1262      * See {_mint}.
1263      *
1264      * Emits a {Transfer} event for each mint.
1265      */
1266     function _safeMint(
1267         address to,
1268         uint256 quantity,
1269         bytes memory _data
1270     ) internal virtual {
1271         _mint(to, quantity);
1272 
1273         unchecked {
1274             if (to.code.length != 0) {
1275                 uint256 end = _currentIndex;
1276                 uint256 index = end - quantity;
1277                 do {
1278                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1279                         revert TransferToNonERC721ReceiverImplementer();
1280                     }
1281                 } while (index < end);
1282                 // Reentrancy protection.
1283                 if (_currentIndex != end) revert();
1284             }
1285         }
1286     }
1287 
1288     /**
1289      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1290      */
1291     function _safeMint(address to, uint256 quantity) internal virtual {
1292         _safeMint(to, quantity, '');
1293     }
1294 
1295     // =============================================================
1296     //                        BURN OPERATIONS
1297     // =============================================================
1298 
1299     /**
1300      * @dev Equivalent to `_burn(tokenId, false)`.
1301      */
1302     function _burn(uint256 tokenId) internal virtual {
1303         _burn(tokenId, false);
1304     }
1305 
1306     /**
1307      * @dev Destroys `tokenId`.
1308      * The approval is cleared when the token is burned.
1309      *
1310      * Requirements:
1311      *
1312      * - `tokenId` must exist.
1313      *
1314      * Emits a {Transfer} event.
1315      */
1316     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1317         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1318 
1319         address from = address(uint160(prevOwnershipPacked));
1320 
1321         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1322 
1323         if (approvalCheck) {
1324             // The nested ifs save around 20+ gas over a compound boolean condition.
1325             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1326                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1327         }
1328 
1329         _beforeTokenTransfers(from, address(0), tokenId, 1);
1330 
1331         // Clear approvals from the previous owner.
1332         assembly {
1333             if approvedAddress {
1334                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1335                 sstore(approvedAddressSlot, 0)
1336             }
1337         }
1338 
1339         // Underflow of the sender's balance is impossible because we check for
1340         // ownership above and the recipient's balance can't realistically overflow.
1341         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1342         unchecked {
1343             // Updates:
1344             // - `balance -= 1`.
1345             // - `numberBurned += 1`.
1346             //
1347             // We can directly decrement the balance, and increment the number burned.
1348             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1349             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1350 
1351             // Updates:
1352             // - `address` to the last owner.
1353             // - `startTimestamp` to the timestamp of burning.
1354             // - `burned` to `true`.
1355             // - `nextInitialized` to `true`.
1356             _packedOwnerships[tokenId] = _packOwnershipData(
1357                 from,
1358                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1359             );
1360 
1361             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1362             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1363                 uint256 nextTokenId = tokenId + 1;
1364                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1365                 if (_packedOwnerships[nextTokenId] == 0) {
1366                     // If the next slot is within bounds.
1367                     if (nextTokenId != _currentIndex) {
1368                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1369                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1370                     }
1371                 }
1372             }
1373         }
1374 
1375         emit Transfer(from, address(0), tokenId);
1376         _afterTokenTransfers(from, address(0), tokenId, 1);
1377 
1378         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1379         unchecked {
1380             _burnCounter++;
1381         }
1382     }
1383 
1384     // =============================================================
1385     //                     EXTRA DATA OPERATIONS
1386     // =============================================================
1387 
1388     /**
1389      * @dev Directly sets the extra data for the ownership data `index`.
1390      */
1391     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1392         uint256 packed = _packedOwnerships[index];
1393         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1394         uint256 extraDataCasted;
1395         // Cast `extraData` with assembly to avoid redundant masking.
1396         assembly {
1397             extraDataCasted := extraData
1398         }
1399         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1400         _packedOwnerships[index] = packed;
1401     }
1402 
1403     /**
1404      * @dev Called during each token transfer to set the 24bit `extraData` field.
1405      * Intended to be overridden by the cosumer contract.
1406      *
1407      * `previousExtraData` - the value of `extraData` before transfer.
1408      *
1409      * Calling conditions:
1410      *
1411      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1412      * transferred to `to`.
1413      * - When `from` is zero, `tokenId` will be minted for `to`.
1414      * - When `to` is zero, `tokenId` will be burned by `from`.
1415      * - `from` and `to` are never both zero.
1416      */
1417     function _extraData(
1418         address from,
1419         address to,
1420         uint24 previousExtraData
1421     ) internal view virtual returns (uint24) {}
1422 
1423     /**
1424      * @dev Returns the next extra data for the packed ownership data.
1425      * The returned result is shifted into position.
1426      */
1427     function _nextExtraData(
1428         address from,
1429         address to,
1430         uint256 prevOwnershipPacked
1431     ) private view returns (uint256) {
1432         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1433         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1434     }
1435 
1436     // =============================================================
1437     //                       OTHER OPERATIONS
1438     // =============================================================
1439 
1440     /**
1441      * @dev Returns the message sender (defaults to `msg.sender`).
1442      *
1443      * If you are writing GSN compatible contracts, you need to override this function.
1444      */
1445     function _msgSenderERC721A() internal view virtual returns (address) {
1446         return msg.sender;
1447     }
1448 
1449     /**
1450      * @dev Converts a uint256 to its ASCII string decimal representation.
1451      */
1452     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1453         assembly {
1454             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1455             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1456             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1457             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1458             let m := add(mload(0x40), 0xa0)
1459             // Update the free memory pointer to allocate.
1460             mstore(0x40, m)
1461             // Assign the `str` to the end.
1462             str := sub(m, 0x20)
1463             // Zeroize the slot after the string.
1464             mstore(str, 0)
1465 
1466             // Cache the end of the memory to calculate the length later.
1467             let end := str
1468 
1469             // We write the string from rightmost digit to leftmost digit.
1470             // The following is essentially a do-while loop that also handles the zero case.
1471             // prettier-ignore
1472             for { let temp := value } 1 {} {
1473                 str := sub(str, 1)
1474                 // Write the character to the pointer.
1475                 // The ASCII index of the '0' character is 48.
1476                 mstore8(str, add(48, mod(temp, 10)))
1477                 // Keep dividing `temp` until zero.
1478                 temp := div(temp, 10)
1479                 // prettier-ignore
1480                 if iszero(temp) { break }
1481             }
1482 
1483             let length := sub(end, str)
1484             // Move the pointer 32 bytes leftwards to make room for the length.
1485             str := sub(str, 0x20)
1486             // Store the length.
1487             mstore(str, length)
1488         }
1489     }
1490 }
1491 
1492 // File: contracts/Saints.sol
1493 
1494 
1495 pragma solidity ^0.8.4;
1496 
1497 
1498 
1499 contract Saints is ERC721A, Ownable {
1500     uint256 MAX_MINTS = 10;
1501     uint256 MAX_SUPPLY = 12000;
1502     uint256 public mintPrice = 0.8 ether;
1503     bool public paused = false;
1504 
1505     string public baseURI = "ipfs://QmYMVLm5yspZNL8AhSbSp3owtjZdWWsjqhbjXc9FshKDcw/";
1506 
1507     constructor() ERC721A("Saints", "SAT") {}
1508 
1509     function mint(uint256 quantity) external payable {
1510         // _safeMint's second argument now takes in a quantity, not a tokenId.
1511         require(!paused);
1512         require(totalSupply() + quantity <= MAX_SUPPLY, "Not enough tokens left");
1513         if (msg.sender != owner()) {
1514             require(quantity + _numberMinted(msg.sender) <= MAX_MINTS, "Exceeded the limit");
1515             require(msg.value >= (mintPrice * quantity), "Not enough ether sent");
1516         }
1517         
1518         _safeMint(msg.sender, quantity);
1519     }
1520 
1521     function ownerMint(address to, uint256 quantity) external onlyOwner {
1522         // _safeMint's second argument now takes in a quantity, not a tokenId.
1523         
1524         require(totalSupply() + quantity <= MAX_SUPPLY, "Not enough tokens left");
1525         
1526         _safeMint(to, quantity);
1527     }
1528 
1529     function withdraw() external payable onlyOwner {
1530         payable(owner()).transfer(address(this).balance);
1531     }
1532 
1533     function _baseURI() internal view override returns (string memory) {
1534         return baseURI;
1535     }
1536 
1537     function _startTokenId() internal pure override returns (uint256) {
1538         return 1;
1539     }
1540 
1541     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1542         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1543 
1544         string memory currentBaseURI = _baseURI();
1545         return bytes(baseURI).length != 0 ? string(abi.encodePacked(currentBaseURI, _toString(tokenId), ".json")) : '';
1546     }
1547 
1548     function setMintPrice(uint256 _mintPrice) public onlyOwner {
1549         mintPrice = _mintPrice;
1550     }
1551 
1552     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1553         baseURI = _newBaseURI;
1554     }
1555     
1556     function pause(bool _state) public onlyOwner {
1557         paused = _state;
1558     }
1559 }