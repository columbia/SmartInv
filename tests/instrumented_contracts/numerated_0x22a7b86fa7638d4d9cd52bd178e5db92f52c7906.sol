1 // SPDX-License-Identifier: MIT
2 
3 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
4 
5 
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
30 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
31 
32 
33 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
34 
35 pragma solidity ^0.8.0;
36 
37 
38 /**
39  * @dev Contract module which provides a basic access control mechanism, where
40  * there is an account (an owner) that can be granted exclusive access to
41  * specific functions.
42  *
43  * By default, the owner account will be the one that deploys the contract. This
44  * can later be changed with {transferOwnership}.
45  *
46  * This module is used through inheritance. It will make available the modifier
47  * `onlyOwner`, which can be applied to your functions to restrict their use to
48  * the owner.
49  */
50 abstract contract Ownable is Context {
51     address private _owner;
52 
53     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
54 
55     /**
56      * @dev Initializes the contract setting the deployer as the initial owner.
57      */
58     constructor() {
59         _transferOwnership(_msgSender());
60     }
61 
62     /**
63      * @dev Throws if called by any account other than the owner.
64      */
65     modifier onlyOwner() {
66         _checkOwner();
67         _;
68     }
69 
70     /**
71      * @dev Returns the address of the current owner.
72      */
73     function owner() public view virtual returns (address) {
74         return _owner;
75     }
76 
77     /**
78      * @dev Throws if the sender is not the owner.
79      */
80     function _checkOwner() internal view virtual {
81         require(owner() == _msgSender(), "Ownable: caller is not the owner");
82     }
83 
84     /**
85      * @dev Leaves the contract without owner. It will not be possible to call
86      * `onlyOwner` functions anymore. Can only be called by the current owner.
87      *
88      * NOTE: Renouncing ownership will leave the contract without an owner,
89      * thereby removing any functionality that is only available to the owner.
90      */
91     function renounceOwnership() public virtual onlyOwner {
92         _transferOwnership(address(0));
93     }
94 
95     /**
96      * @dev Transfers ownership of the contract to a new account (`newOwner`).
97      * Can only be called by the current owner.
98      */
99     function transferOwnership(address newOwner) public virtual onlyOwner {
100         require(newOwner != address(0), "Ownable: new owner is the zero address");
101         _transferOwnership(newOwner);
102     }
103 
104     /**
105      * @dev Transfers ownership of the contract to a new account (`newOwner`).
106      * Internal function without access restriction.
107      */
108     function _transferOwnership(address newOwner) internal virtual {
109         address oldOwner = _owner;
110         _owner = newOwner;
111         emit OwnershipTransferred(oldOwner, newOwner);
112     }
113 }
114 
115 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/IERC721A.sol
116 
117 
118 // ERC721A Contracts v4.2.3
119 // Creator: Chiru Labs
120 
121 pragma solidity ^0.8.4;
122 
123 /**
124  * @dev Interface of ERC721A.
125  */
126 interface IERC721A {
127     /**
128      * The caller must own the token or be an approved operator.
129      */
130     error ApprovalCallerNotOwnerNorApproved();
131 
132     /**
133      * The token does not exist.
134      */
135     error ApprovalQueryForNonexistentToken();
136 
137     /**
138      * Cannot query the balance for the zero address.
139      */
140     error BalanceQueryForZeroAddress();
141 
142     /**
143      * Cannot mint to the zero address.
144      */
145     error MintToZeroAddress();
146 
147     /**
148      * The quantity of tokens minted must be more than zero.
149      */
150     error MintZeroQuantity();
151 
152     /**
153      * The token does not exist.
154      */
155     error OwnerQueryForNonexistentToken();
156 
157     /**
158      * The caller must own the token or be an approved operator.
159      */
160     error TransferCallerNotOwnerNorApproved();
161 
162     /**
163      * The token must be owned by `from`.
164      */
165     error TransferFromIncorrectOwner();
166 
167     /**
168      * Cannot safely transfer to a contract that does not implement the
169      * ERC721Receiver interface.
170      */
171     error TransferToNonERC721ReceiverImplementer();
172 
173     /**
174      * Cannot transfer to the zero address.
175      */
176     error TransferToZeroAddress();
177 
178     /**
179      * The token does not exist.
180      */
181     error URIQueryForNonexistentToken();
182 
183     /**
184      * The `quantity` minted with ERC2309 exceeds the safety limit.
185      */
186     error MintERC2309QuantityExceedsLimit();
187 
188     /**
189      * The `extraData` cannot be set on an unintialized ownership slot.
190      */
191     error OwnershipNotInitializedForExtraData();
192 
193     // =============================================================
194     //                            STRUCTS
195     // =============================================================
196 
197     struct TokenOwnership {
198         // The address of the owner.
199         address addr;
200         // Stores the start time of ownership with minimal overhead for tokenomics.
201         uint64 startTimestamp;
202         // Whether the token has been burned.
203         bool burned;
204         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
205         uint24 extraData;
206     }
207 
208     // =============================================================
209     //                         TOKEN COUNTERS
210     // =============================================================
211 
212     /**
213      * @dev Returns the total number of tokens in existence.
214      * Burned tokens will reduce the count.
215      * To get the total number of tokens minted, please see {_totalMinted}.
216      */
217     function totalSupply() external view returns (uint256);
218 
219     // =============================================================
220     //                            IERC165
221     // =============================================================
222 
223     /**
224      * @dev Returns true if this contract implements the interface defined by
225      * `interfaceId`. See the corresponding
226      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
227      * to learn more about how these ids are created.
228      *
229      * This function call must use less than 30000 gas.
230      */
231     function supportsInterface(bytes4 interfaceId) external view returns (bool);
232 
233     // =============================================================
234     //                            IERC721
235     // =============================================================
236 
237     /**
238      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
239      */
240     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
241 
242     /**
243      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
244      */
245     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
246 
247     /**
248      * @dev Emitted when `owner` enables or disables
249      * (`approved`) `operator` to manage all of its assets.
250      */
251     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
252 
253     /**
254      * @dev Returns the number of tokens in `owner`'s account.
255      */
256     function balanceOf(address owner) external view returns (uint256 balance);
257 
258     /**
259      * @dev Returns the owner of the `tokenId` token.
260      *
261      * Requirements:
262      *
263      * - `tokenId` must exist.
264      */
265     function ownerOf(uint256 tokenId) external view returns (address owner);
266 
267     /**
268      * @dev Safely transfers `tokenId` token from `from` to `to`,
269      * checking first that contract recipients are aware of the ERC721 protocol
270      * to prevent tokens from being forever locked.
271      *
272      * Requirements:
273      *
274      * - `from` cannot be the zero address.
275      * - `to` cannot be the zero address.
276      * - `tokenId` token must exist and be owned by `from`.
277      * - If the caller is not `from`, it must be have been allowed to move
278      * this token by either {approve} or {setApprovalForAll}.
279      * - If `to` refers to a smart contract, it must implement
280      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
281      *
282      * Emits a {Transfer} event.
283      */
284     function safeTransferFrom(
285         address from,
286         address to,
287         uint256 tokenId,
288         bytes calldata data
289     ) external payable;
290 
291     /**
292      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
293      */
294     function safeTransferFrom(
295         address from,
296         address to,
297         uint256 tokenId
298     ) external payable;
299 
300     /**
301      * @dev Transfers `tokenId` from `from` to `to`.
302      *
303      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
304      * whenever possible.
305      *
306      * Requirements:
307      *
308      * - `from` cannot be the zero address.
309      * - `to` cannot be the zero address.
310      * - `tokenId` token must be owned by `from`.
311      * - If the caller is not `from`, it must be approved to move this token
312      * by either {approve} or {setApprovalForAll}.
313      *
314      * Emits a {Transfer} event.
315      */
316     function transferFrom(
317         address from,
318         address to,
319         uint256 tokenId
320     ) external payable;
321 
322     /**
323      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
324      * The approval is cleared when the token is transferred.
325      *
326      * Only a single account can be approved at a time, so approving the
327      * zero address clears previous approvals.
328      *
329      * Requirements:
330      *
331      * - The caller must own the token or be an approved operator.
332      * - `tokenId` must exist.
333      *
334      * Emits an {Approval} event.
335      */
336     function approve(address to, uint256 tokenId) external payable;
337 
338     /**
339      * @dev Approve or remove `operator` as an operator for the caller.
340      * Operators can call {transferFrom} or {safeTransferFrom}
341      * for any token owned by the caller.
342      *
343      * Requirements:
344      *
345      * - The `operator` cannot be the caller.
346      *
347      * Emits an {ApprovalForAll} event.
348      */
349     function setApprovalForAll(address operator, bool _approved) external;
350 
351     /**
352      * @dev Returns the account approved for `tokenId` token.
353      *
354      * Requirements:
355      *
356      * - `tokenId` must exist.
357      */
358     function getApproved(uint256 tokenId) external view returns (address operator);
359 
360     /**
361      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
362      *
363      * See {setApprovalForAll}.
364      */
365     function isApprovedForAll(address owner, address operator) external view returns (bool);
366 
367     // =============================================================
368     //                        IERC721Metadata
369     // =============================================================
370 
371     /**
372      * @dev Returns the token collection name.
373      */
374     function name() external view returns (string memory);
375 
376     /**
377      * @dev Returns the token collection symbol.
378      */
379     function symbol() external view returns (string memory);
380 
381     /**
382      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
383      */
384     function tokenURI(uint256 tokenId) external view returns (string memory);
385 
386     // =============================================================
387     //                           IERC2309
388     // =============================================================
389 
390     /**
391      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
392      * (inclusive) is transferred from `from` to `to`, as defined in the
393      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
394      *
395      * See {_mintERC2309} for more details.
396      */
397     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
398 }
399 
400 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol
401 
402 
403 // ERC721A Contracts v4.2.3
404 // Creator: Chiru Labs
405 
406 pragma solidity ^0.8.4;
407 
408 
409 /**
410  * @dev Interface of ERC721 token receiver.
411  */
412 interface ERC721A__IERC721Receiver {
413     function onERC721Received(
414         address operator,
415         address from,
416         uint256 tokenId,
417         bytes calldata data
418     ) external returns (bytes4);
419 }
420 
421 /**
422  * @title ERC721A
423  *
424  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
425  * Non-Fungible Token Standard, including the Metadata extension.
426  * Optimized for lower gas during batch mints.
427  *
428  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
429  * starting from `_startTokenId()`.
430  *
431  * Assumptions:
432  *
433  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
434  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
435  */
436 contract ERC721A is IERC721A {
437     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
438     struct TokenApprovalRef {
439         address value;
440     }
441 
442     // =============================================================
443     //                           CONSTANTS
444     // =============================================================
445 
446     // Mask of an entry in packed address data.
447     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
448 
449     // The bit position of `numberMinted` in packed address data.
450     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
451 
452     // The bit position of `numberBurned` in packed address data.
453     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
454 
455     // The bit position of `aux` in packed address data.
456     uint256 private constant _BITPOS_AUX = 192;
457 
458     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
459     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
460 
461     // The bit position of `startTimestamp` in packed ownership.
462     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
463 
464     // The bit mask of the `burned` bit in packed ownership.
465     uint256 private constant _BITMASK_BURNED = 1 << 224;
466 
467     // The bit position of the `nextInitialized` bit in packed ownership.
468     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
469 
470     // The bit mask of the `nextInitialized` bit in packed ownership.
471     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
472 
473     // The bit position of `extraData` in packed ownership.
474     uint256 private constant _BITPOS_EXTRA_DATA = 232;
475 
476     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
477     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
478 
479     // The mask of the lower 160 bits for addresses.
480     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
481 
482     // The maximum `quantity` that can be minted with {_mintERC2309}.
483     // This limit is to prevent overflows on the address data entries.
484     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
485     // is required to cause an overflow, which is unrealistic.
486     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
487 
488     // The `Transfer` event signature is given by:
489     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
490     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
491         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
492 
493     // =============================================================
494     //                            STORAGE
495     // =============================================================
496 
497     // The next token ID to be minted.
498     uint256 private _currentIndex;
499 
500     // The number of tokens burned.
501     uint256 private _burnCounter;
502 
503     // Token name
504     string private _name;
505 
506     // Token symbol
507     string private _symbol;
508 
509     // Mapping from token ID to ownership details
510     // An empty struct value does not necessarily mean the token is unowned.
511     // See {_packedOwnershipOf} implementation for details.
512     //
513     // Bits Layout:
514     // - [0..159]   `addr`
515     // - [160..223] `startTimestamp`
516     // - [224]      `burned`
517     // - [225]      `nextInitialized`
518     // - [232..255] `extraData`
519     mapping(uint256 => uint256) private _packedOwnerships;
520 
521     // Mapping owner address to address data.
522     //
523     // Bits Layout:
524     // - [0..63]    `balance`
525     // - [64..127]  `numberMinted`
526     // - [128..191] `numberBurned`
527     // - [192..255] `aux`
528     mapping(address => uint256) private _packedAddressData;
529 
530     // Mapping from token ID to approved address.
531     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
532 
533     // Mapping from owner to operator approvals
534     mapping(address => mapping(address => bool)) private _operatorApprovals;
535 
536     // =============================================================
537     //                          CONSTRUCTOR
538     // =============================================================
539 
540     constructor(string memory name_, string memory symbol_) {
541         _name = name_;
542         _symbol = symbol_;
543         _currentIndex = _startTokenId();
544     }
545 
546     // =============================================================
547     //                   TOKEN COUNTING OPERATIONS
548     // =============================================================
549 
550     /**
551      * @dev Returns the starting token ID.
552      * To change the starting token ID, please override this function.
553      */
554     function _startTokenId() internal view virtual returns (uint256) {
555         return 0;
556     }
557 
558     /**
559      * @dev Returns the next token ID to be minted.
560      */
561     function _nextTokenId() internal view virtual returns (uint256) {
562         return _currentIndex;
563     }
564 
565     /**
566      * @dev Returns the total number of tokens in existence.
567      * Burned tokens will reduce the count.
568      * To get the total number of tokens minted, please see {_totalMinted}.
569      */
570     function totalSupply() public view virtual override returns (uint256) {
571         // Counter underflow is impossible as _burnCounter cannot be incremented
572         // more than `_currentIndex - _startTokenId()` times.
573         unchecked {
574             return _currentIndex - _burnCounter - _startTokenId();
575         }
576     }
577 
578     /**
579      * @dev Returns the total amount of tokens minted in the contract.
580      */
581     function _totalMinted() internal view virtual returns (uint256) {
582         // Counter underflow is impossible as `_currentIndex` does not decrement,
583         // and it is initialized to `_startTokenId()`.
584         unchecked {
585             return _currentIndex - _startTokenId();
586         }
587     }
588 
589     /**
590      * @dev Returns the total number of tokens burned.
591      */
592     function _totalBurned() internal view virtual returns (uint256) {
593         return _burnCounter;
594     }
595 
596     // =============================================================
597     //                    ADDRESS DATA OPERATIONS
598     // =============================================================
599 
600     /**
601      * @dev Returns the number of tokens in `owner`'s account.
602      */
603     function balanceOf(address owner) public view virtual override returns (uint256) {
604         if (owner == address(0)) revert BalanceQueryForZeroAddress();
605         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
606     }
607 
608     /**
609      * Returns the number of tokens minted by `owner`.
610      */
611     function _numberMinted(address owner) internal view returns (uint256) {
612         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
613     }
614 
615     /**
616      * Returns the number of tokens burned by or on behalf of `owner`.
617      */
618     function _numberBurned(address owner) internal view returns (uint256) {
619         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
620     }
621 
622     /**
623      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
624      */
625     function _getAux(address owner) internal view returns (uint64) {
626         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
627     }
628 
629     /**
630      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
631      * If there are multiple variables, please pack them into a uint64.
632      */
633     function _setAux(address owner, uint64 aux) internal virtual {
634         uint256 packed = _packedAddressData[owner];
635         uint256 auxCasted;
636         // Cast `aux` with assembly to avoid redundant masking.
637         assembly {
638             auxCasted := aux
639         }
640         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
641         _packedAddressData[owner] = packed;
642     }
643 
644     // =============================================================
645     //                            IERC165
646     // =============================================================
647 
648     /**
649      * @dev Returns true if this contract implements the interface defined by
650      * `interfaceId`. See the corresponding
651      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
652      * to learn more about how these ids are created.
653      *
654      * This function call must use less than 30000 gas.
655      */
656     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
657         // The interface IDs are constants representing the first 4 bytes
658         // of the XOR of all function selectors in the interface.
659         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
660         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
661         return
662             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
663             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
664             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
665     }
666 
667     // =============================================================
668     //                        IERC721Metadata
669     // =============================================================
670 
671     /**
672      * @dev Returns the token collection name.
673      */
674     function name() public view virtual override returns (string memory) {
675         return _name;
676     }
677 
678     /**
679      * @dev Returns the token collection symbol.
680      */
681     function symbol() public view virtual override returns (string memory) {
682         return _symbol;
683     }
684 
685     /**
686      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
687      */
688     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
689         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
690 
691         string memory baseURI = _baseURI();
692         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
693     }
694 
695     /**
696      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
697      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
698      * by default, it can be overridden in child contracts.
699      */
700     function _baseURI() internal view virtual returns (string memory) {
701         return '';
702     }
703 
704     // =============================================================
705     //                     OWNERSHIPS OPERATIONS
706     // =============================================================
707 
708     /**
709      * @dev Returns the owner of the `tokenId` token.
710      *
711      * Requirements:
712      *
713      * - `tokenId` must exist.
714      */
715     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
716         return address(uint160(_packedOwnershipOf(tokenId)));
717     }
718 
719     /**
720      * @dev Gas spent here starts off proportional to the maximum mint batch size.
721      * It gradually moves to O(1) as tokens get transferred around over time.
722      */
723     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
724         return _unpackedOwnership(_packedOwnershipOf(tokenId));
725     }
726 
727     /**
728      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
729      */
730     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
731         return _unpackedOwnership(_packedOwnerships[index]);
732     }
733 
734     /**
735      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
736      */
737     function _initializeOwnershipAt(uint256 index) internal virtual {
738         if (_packedOwnerships[index] == 0) {
739             _packedOwnerships[index] = _packedOwnershipOf(index);
740         }
741     }
742 
743     /**
744      * Returns the packed ownership data of `tokenId`.
745      */
746     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
747         uint256 curr = tokenId;
748 
749         unchecked {
750             if (_startTokenId() <= curr)
751                 if (curr < _currentIndex) {
752                     uint256 packed = _packedOwnerships[curr];
753                     // If not burned.
754                     if (packed & _BITMASK_BURNED == 0) {
755                         // Invariant:
756                         // There will always be an initialized ownership slot
757                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
758                         // before an unintialized ownership slot
759                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
760                         // Hence, `curr` will not underflow.
761                         //
762                         // We can directly compare the packed value.
763                         // If the address is zero, packed will be zero.
764                         while (packed == 0) {
765                             packed = _packedOwnerships[--curr];
766                         }
767                         return packed;
768                     }
769                 }
770         }
771         revert OwnerQueryForNonexistentToken();
772     }
773 
774     /**
775      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
776      */
777     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
778         ownership.addr = address(uint160(packed));
779         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
780         ownership.burned = packed & _BITMASK_BURNED != 0;
781         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
782     }
783 
784     /**
785      * @dev Packs ownership data into a single uint256.
786      */
787     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
788         assembly {
789             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
790             owner := and(owner, _BITMASK_ADDRESS)
791             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
792             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
793         }
794     }
795 
796     /**
797      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
798      */
799     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
800         // For branchless setting of the `nextInitialized` flag.
801         assembly {
802             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
803             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
804         }
805     }
806 
807     // =============================================================
808     //                      APPROVAL OPERATIONS
809     // =============================================================
810 
811     /**
812      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
813      * The approval is cleared when the token is transferred.
814      *
815      * Only a single account can be approved at a time, so approving the
816      * zero address clears previous approvals.
817      *
818      * Requirements:
819      *
820      * - The caller must own the token or be an approved operator.
821      * - `tokenId` must exist.
822      *
823      * Emits an {Approval} event.
824      */
825     function approve(address to, uint256 tokenId) public payable virtual override {
826         address owner = ownerOf(tokenId);
827 
828         if (_msgSenderERC721A() != owner)
829             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
830                 revert ApprovalCallerNotOwnerNorApproved();
831             }
832 
833         _tokenApprovals[tokenId].value = to;
834         emit Approval(owner, to, tokenId);
835     }
836 
837     /**
838      * @dev Returns the account approved for `tokenId` token.
839      *
840      * Requirements:
841      *
842      * - `tokenId` must exist.
843      */
844     function getApproved(uint256 tokenId) public view virtual override returns (address) {
845         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
846 
847         return _tokenApprovals[tokenId].value;
848     }
849 
850     /**
851      * @dev Approve or remove `operator` as an operator for the caller.
852      * Operators can call {transferFrom} or {safeTransferFrom}
853      * for any token owned by the caller.
854      *
855      * Requirements:
856      *
857      * - The `operator` cannot be the caller.
858      *
859      * Emits an {ApprovalForAll} event.
860      */
861     function setApprovalForAll(address operator, bool approved) public virtual override {
862         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
863         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
864     }
865 
866     /**
867      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
868      *
869      * See {setApprovalForAll}.
870      */
871     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
872         return _operatorApprovals[owner][operator];
873     }
874 
875     /**
876      * @dev Returns whether `tokenId` exists.
877      *
878      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
879      *
880      * Tokens start existing when they are minted. See {_mint}.
881      */
882     function _exists(uint256 tokenId) internal view virtual returns (bool) {
883         return
884             _startTokenId() <= tokenId &&
885             tokenId < _currentIndex && // If within bounds,
886             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
887     }
888 
889     /**
890      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
891      */
892     function _isSenderApprovedOrOwner(
893         address approvedAddress,
894         address owner,
895         address msgSender
896     ) private pure returns (bool result) {
897         assembly {
898             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
899             owner := and(owner, _BITMASK_ADDRESS)
900             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
901             msgSender := and(msgSender, _BITMASK_ADDRESS)
902             // `msgSender == owner || msgSender == approvedAddress`.
903             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
904         }
905     }
906 
907     /**
908      * @dev Returns the storage slot and value for the approved address of `tokenId`.
909      */
910     function _getApprovedSlotAndAddress(uint256 tokenId)
911         private
912         view
913         returns (uint256 approvedAddressSlot, address approvedAddress)
914     {
915         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
916         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
917         assembly {
918             approvedAddressSlot := tokenApproval.slot
919             approvedAddress := sload(approvedAddressSlot)
920         }
921     }
922 
923     // =============================================================
924     //                      TRANSFER OPERATIONS
925     // =============================================================
926 
927     /**
928      * @dev Transfers `tokenId` from `from` to `to`.
929      *
930      * Requirements:
931      *
932      * - `from` cannot be the zero address.
933      * - `to` cannot be the zero address.
934      * - `tokenId` token must be owned by `from`.
935      * - If the caller is not `from`, it must be approved to move this token
936      * by either {approve} or {setApprovalForAll}.
937      *
938      * Emits a {Transfer} event.
939      */
940     function transferFrom(
941         address from,
942         address to,
943         uint256 tokenId
944     ) public payable virtual override {
945         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
946 
947         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
948 
949         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
950 
951         // The nested ifs save around 20+ gas over a compound boolean condition.
952         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
953             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
954 
955         if (to == address(0)) revert TransferToZeroAddress();
956 
957         _beforeTokenTransfers(from, to, tokenId, 1);
958 
959         // Clear approvals from the previous owner.
960         assembly {
961             if approvedAddress {
962                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
963                 sstore(approvedAddressSlot, 0)
964             }
965         }
966 
967         // Underflow of the sender's balance is impossible because we check for
968         // ownership above and the recipient's balance can't realistically overflow.
969         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
970         unchecked {
971             // We can directly increment and decrement the balances.
972             --_packedAddressData[from]; // Updates: `balance -= 1`.
973             ++_packedAddressData[to]; // Updates: `balance += 1`.
974 
975             // Updates:
976             // - `address` to the next owner.
977             // - `startTimestamp` to the timestamp of transfering.
978             // - `burned` to `false`.
979             // - `nextInitialized` to `true`.
980             _packedOwnerships[tokenId] = _packOwnershipData(
981                 to,
982                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
983             );
984 
985             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
986             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
987                 uint256 nextTokenId = tokenId + 1;
988                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
989                 if (_packedOwnerships[nextTokenId] == 0) {
990                     // If the next slot is within bounds.
991                     if (nextTokenId != _currentIndex) {
992                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
993                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
994                     }
995                 }
996             }
997         }
998 
999         emit Transfer(from, to, tokenId);
1000         _afterTokenTransfers(from, to, tokenId, 1);
1001     }
1002 
1003     /**
1004      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1005      */
1006     function safeTransferFrom(
1007         address from,
1008         address to,
1009         uint256 tokenId
1010     ) public payable virtual override {
1011         safeTransferFrom(from, to, tokenId, '');
1012     }
1013 
1014     /**
1015      * @dev Safely transfers `tokenId` token from `from` to `to`.
1016      *
1017      * Requirements:
1018      *
1019      * - `from` cannot be the zero address.
1020      * - `to` cannot be the zero address.
1021      * - `tokenId` token must exist and be owned by `from`.
1022      * - If the caller is not `from`, it must be approved to move this token
1023      * by either {approve} or {setApprovalForAll}.
1024      * - If `to` refers to a smart contract, it must implement
1025      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1026      *
1027      * Emits a {Transfer} event.
1028      */
1029     function safeTransferFrom(
1030         address from,
1031         address to,
1032         uint256 tokenId,
1033         bytes memory _data
1034     ) public payable virtual override {
1035         transferFrom(from, to, tokenId);
1036         if (to.code.length != 0)
1037             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1038                 revert TransferToNonERC721ReceiverImplementer();
1039             }
1040     }
1041 
1042     /**
1043      * @dev Hook that is called before a set of serially-ordered token IDs
1044      * are about to be transferred. This includes minting.
1045      * And also called before burning one token.
1046      *
1047      * `startTokenId` - the first token ID to be transferred.
1048      * `quantity` - the amount to be transferred.
1049      *
1050      * Calling conditions:
1051      *
1052      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1053      * transferred to `to`.
1054      * - When `from` is zero, `tokenId` will be minted for `to`.
1055      * - When `to` is zero, `tokenId` will be burned by `from`.
1056      * - `from` and `to` are never both zero.
1057      */
1058     function _beforeTokenTransfers(
1059         address from,
1060         address to,
1061         uint256 startTokenId,
1062         uint256 quantity
1063     ) internal virtual {}
1064 
1065     /**
1066      * @dev Hook that is called after a set of serially-ordered token IDs
1067      * have been transferred. This includes minting.
1068      * And also called after one token has been burned.
1069      *
1070      * `startTokenId` - the first token ID to be transferred.
1071      * `quantity` - the amount to be transferred.
1072      *
1073      * Calling conditions:
1074      *
1075      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1076      * transferred to `to`.
1077      * - When `from` is zero, `tokenId` has been minted for `to`.
1078      * - When `to` is zero, `tokenId` has been burned by `from`.
1079      * - `from` and `to` are never both zero.
1080      */
1081     function _afterTokenTransfers(
1082         address from,
1083         address to,
1084         uint256 startTokenId,
1085         uint256 quantity
1086     ) internal virtual {}
1087 
1088     /**
1089      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1090      *
1091      * `from` - Previous owner of the given token ID.
1092      * `to` - Target address that will receive the token.
1093      * `tokenId` - Token ID to be transferred.
1094      * `_data` - Optional data to send along with the call.
1095      *
1096      * Returns whether the call correctly returned the expected magic value.
1097      */
1098     function _checkContractOnERC721Received(
1099         address from,
1100         address to,
1101         uint256 tokenId,
1102         bytes memory _data
1103     ) private returns (bool) {
1104         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1105             bytes4 retval
1106         ) {
1107             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1108         } catch (bytes memory reason) {
1109             if (reason.length == 0) {
1110                 revert TransferToNonERC721ReceiverImplementer();
1111             } else {
1112                 assembly {
1113                     revert(add(32, reason), mload(reason))
1114                 }
1115             }
1116         }
1117     }
1118 
1119     // =============================================================
1120     //                        MINT OPERATIONS
1121     // =============================================================
1122 
1123     /**
1124      * @dev Mints `quantity` tokens and transfers them to `to`.
1125      *
1126      * Requirements:
1127      *
1128      * - `to` cannot be the zero address.
1129      * - `quantity` must be greater than 0.
1130      *
1131      * Emits a {Transfer} event for each mint.
1132      */
1133     function _mint(address to, uint256 quantity) internal virtual {
1134         uint256 startTokenId = _currentIndex;
1135         if (quantity == 0) revert MintZeroQuantity();
1136 
1137         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1138 
1139         // Overflows are incredibly unrealistic.
1140         // `balance` and `numberMinted` have a maximum limit of 2**64.
1141         // `tokenId` has a maximum limit of 2**256.
1142         unchecked {
1143             // Updates:
1144             // - `balance += quantity`.
1145             // - `numberMinted += quantity`.
1146             //
1147             // We can directly add to the `balance` and `numberMinted`.
1148             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1149 
1150             // Updates:
1151             // - `address` to the owner.
1152             // - `startTimestamp` to the timestamp of minting.
1153             // - `burned` to `false`.
1154             // - `nextInitialized` to `quantity == 1`.
1155             _packedOwnerships[startTokenId] = _packOwnershipData(
1156                 to,
1157                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1158             );
1159 
1160             uint256 toMasked;
1161             uint256 end = startTokenId + quantity;
1162 
1163             // Use assembly to loop and emit the `Transfer` event for gas savings.
1164             // The duplicated `log4` removes an extra check and reduces stack juggling.
1165             // The assembly, together with the surrounding Solidity code, have been
1166             // delicately arranged to nudge the compiler into producing optimized opcodes.
1167             assembly {
1168                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1169                 toMasked := and(to, _BITMASK_ADDRESS)
1170                 // Emit the `Transfer` event.
1171                 log4(
1172                     0, // Start of data (0, since no data).
1173                     0, // End of data (0, since no data).
1174                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1175                     0, // `address(0)`.
1176                     toMasked, // `to`.
1177                     startTokenId // `tokenId`.
1178                 )
1179 
1180                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1181                 // that overflows uint256 will make the loop run out of gas.
1182                 // The compiler will optimize the `iszero` away for performance.
1183                 for {
1184                     let tokenId := add(startTokenId, 1)
1185                 } iszero(eq(tokenId, end)) {
1186                     tokenId := add(tokenId, 1)
1187                 } {
1188                     // Emit the `Transfer` event. Similar to above.
1189                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1190                 }
1191             }
1192             if (toMasked == 0) revert MintToZeroAddress();
1193 
1194             _currentIndex = end;
1195         }
1196         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1197     }
1198 
1199     /**
1200      * @dev Mints `quantity` tokens and transfers them to `to`.
1201      *
1202      * This function is intended for efficient minting only during contract creation.
1203      *
1204      * It emits only one {ConsecutiveTransfer} as defined in
1205      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1206      * instead of a sequence of {Transfer} event(s).
1207      *
1208      * Calling this function outside of contract creation WILL make your contract
1209      * non-compliant with the ERC721 standard.
1210      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1211      * {ConsecutiveTransfer} event is only permissible during contract creation.
1212      *
1213      * Requirements:
1214      *
1215      * - `to` cannot be the zero address.
1216      * - `quantity` must be greater than 0.
1217      *
1218      * Emits a {ConsecutiveTransfer} event.
1219      */
1220     function _mintERC2309(address to, uint256 quantity) internal virtual {
1221         uint256 startTokenId = _currentIndex;
1222         if (to == address(0)) revert MintToZeroAddress();
1223         if (quantity == 0) revert MintZeroQuantity();
1224         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1225 
1226         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1227 
1228         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1229         unchecked {
1230             // Updates:
1231             // - `balance += quantity`.
1232             // - `numberMinted += quantity`.
1233             //
1234             // We can directly add to the `balance` and `numberMinted`.
1235             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1236 
1237             // Updates:
1238             // - `address` to the owner.
1239             // - `startTimestamp` to the timestamp of minting.
1240             // - `burned` to `false`.
1241             // - `nextInitialized` to `quantity == 1`.
1242             _packedOwnerships[startTokenId] = _packOwnershipData(
1243                 to,
1244                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1245             );
1246 
1247             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1248 
1249             _currentIndex = startTokenId + quantity;
1250         }
1251         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1252     }
1253 
1254     /**
1255      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1256      *
1257      * Requirements:
1258      *
1259      * - If `to` refers to a smart contract, it must implement
1260      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1261      * - `quantity` must be greater than 0.
1262      *
1263      * See {_mint}.
1264      *
1265      * Emits a {Transfer} event for each mint.
1266      */
1267     function _safeMint(
1268         address to,
1269         uint256 quantity,
1270         bytes memory _data
1271     ) internal virtual {
1272         _mint(to, quantity);
1273 
1274         unchecked {
1275             if (to.code.length != 0) {
1276                 uint256 end = _currentIndex;
1277                 uint256 index = end - quantity;
1278                 do {
1279                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1280                         revert TransferToNonERC721ReceiverImplementer();
1281                     }
1282                 } while (index < end);
1283                 // Reentrancy protection.
1284                 if (_currentIndex != end) revert();
1285             }
1286         }
1287     }
1288 
1289     /**
1290      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1291      */
1292     function _safeMint(address to, uint256 quantity) internal virtual {
1293         _safeMint(to, quantity, '');
1294     }
1295 
1296     // =============================================================
1297     //                        BURN OPERATIONS
1298     // =============================================================
1299 
1300     /**
1301      * @dev Equivalent to `_burn(tokenId, false)`.
1302      */
1303     function _burn(uint256 tokenId) internal virtual {
1304         _burn(tokenId, false);
1305     }
1306 
1307     /**
1308      * @dev Destroys `tokenId`.
1309      * The approval is cleared when the token is burned.
1310      *
1311      * Requirements:
1312      *
1313      * - `tokenId` must exist.
1314      *
1315      * Emits a {Transfer} event.
1316      */
1317     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1318         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1319 
1320         address from = address(uint160(prevOwnershipPacked));
1321 
1322         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1323 
1324         if (approvalCheck) {
1325             // The nested ifs save around 20+ gas over a compound boolean condition.
1326             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1327                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1328         }
1329 
1330         _beforeTokenTransfers(from, address(0), tokenId, 1);
1331 
1332         // Clear approvals from the previous owner.
1333         assembly {
1334             if approvedAddress {
1335                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1336                 sstore(approvedAddressSlot, 0)
1337             }
1338         }
1339 
1340         // Underflow of the sender's balance is impossible because we check for
1341         // ownership above and the recipient's balance can't realistically overflow.
1342         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1343         unchecked {
1344             // Updates:
1345             // - `balance -= 1`.
1346             // - `numberBurned += 1`.
1347             //
1348             // We can directly decrement the balance, and increment the number burned.
1349             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1350             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1351 
1352             // Updates:
1353             // - `address` to the last owner.
1354             // - `startTimestamp` to the timestamp of burning.
1355             // - `burned` to `true`.
1356             // - `nextInitialized` to `true`.
1357             _packedOwnerships[tokenId] = _packOwnershipData(
1358                 from,
1359                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1360             );
1361 
1362             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1363             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1364                 uint256 nextTokenId = tokenId + 1;
1365                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1366                 if (_packedOwnerships[nextTokenId] == 0) {
1367                     // If the next slot is within bounds.
1368                     if (nextTokenId != _currentIndex) {
1369                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1370                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1371                     }
1372                 }
1373             }
1374         }
1375 
1376         emit Transfer(from, address(0), tokenId);
1377         _afterTokenTransfers(from, address(0), tokenId, 1);
1378 
1379         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1380         unchecked {
1381             _burnCounter++;
1382         }
1383     }
1384 
1385     // =============================================================
1386     //                     EXTRA DATA OPERATIONS
1387     // =============================================================
1388 
1389     /**
1390      * @dev Directly sets the extra data for the ownership data `index`.
1391      */
1392     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1393         uint256 packed = _packedOwnerships[index];
1394         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1395         uint256 extraDataCasted;
1396         // Cast `extraData` with assembly to avoid redundant masking.
1397         assembly {
1398             extraDataCasted := extraData
1399         }
1400         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1401         _packedOwnerships[index] = packed;
1402     }
1403 
1404     /**
1405      * @dev Called during each token transfer to set the 24bit `extraData` field.
1406      * Intended to be overridden by the cosumer contract.
1407      *
1408      * `previousExtraData` - the value of `extraData` before transfer.
1409      *
1410      * Calling conditions:
1411      *
1412      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1413      * transferred to `to`.
1414      * - When `from` is zero, `tokenId` will be minted for `to`.
1415      * - When `to` is zero, `tokenId` will be burned by `from`.
1416      * - `from` and `to` are never both zero.
1417      */
1418     function _extraData(
1419         address from,
1420         address to,
1421         uint24 previousExtraData
1422     ) internal view virtual returns (uint24) {}
1423 
1424     /**
1425      * @dev Returns the next extra data for the packed ownership data.
1426      * The returned result is shifted into position.
1427      */
1428     function _nextExtraData(
1429         address from,
1430         address to,
1431         uint256 prevOwnershipPacked
1432     ) private view returns (uint256) {
1433         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1434         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1435     }
1436 
1437     // =============================================================
1438     //                       OTHER OPERATIONS
1439     // =============================================================
1440 
1441     /**
1442      * @dev Returns the message sender (defaults to `msg.sender`).
1443      *
1444      * If you are writing GSN compatible contracts, you need to override this function.
1445      */
1446     function _msgSenderERC721A() internal view virtual returns (address) {
1447         return msg.sender;
1448     }
1449 
1450     /**
1451      * @dev Converts a uint256 to its ASCII string decimal representation.
1452      */
1453     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1454         assembly {
1455             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1456             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1457             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1458             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1459             let m := add(mload(0x40), 0xa0)
1460             // Update the free memory pointer to allocate.
1461             mstore(0x40, m)
1462             // Assign the `str` to the end.
1463             str := sub(m, 0x20)
1464             // Zeroize the slot after the string.
1465             mstore(str, 0)
1466 
1467             // Cache the end of the memory to calculate the length later.
1468             let end := str
1469 
1470             // We write the string from rightmost digit to leftmost digit.
1471             // The following is essentially a do-while loop that also handles the zero case.
1472             // prettier-ignore
1473             for { let temp := value } 1 {} {
1474                 str := sub(str, 1)
1475                 // Write the character to the pointer.
1476                 // The ASCII index of the '0' character is 48.
1477                 mstore8(str, add(48, mod(temp, 10)))
1478                 // Keep dividing `temp` until zero.
1479                 temp := div(temp, 10)
1480                 // prettier-ignore
1481                 if iszero(temp) { break }
1482             }
1483 
1484             let length := sub(end, str)
1485             // Move the pointer 32 bytes leftwards to make room for the length.
1486             str := sub(str, 0x20)
1487             // Store the length.
1488             mstore(str, length)
1489         }
1490     }
1491 }
1492 
1493 // File: https://github.com/Vectorized/solady/blob/main/src/utils/ECDSA.sol
1494 
1495 
1496 pragma solidity ^0.8.4;
1497 
1498 /// @notice Gas optimized ECDSA wrapper.
1499 /// @author Solady (https://github.com/vectorized/solady/blob/main/src/utils/ECDSA.sol)
1500 /// @author Modified from Solmate (https://github.com/transmissions11/solmate/blob/main/src/utils/ECDSA.sol)
1501 /// @author Modified from OpenZeppelin (https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/cryptography/ECDSA.sol)
1502 library ECDSA {
1503     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
1504     /*                         CONSTANTS                          */
1505     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
1506 
1507     /// @dev The number which `s` must not exceed in order for
1508     /// the signature to be non-malleable.
1509     bytes32 private constant _MALLEABILITY_THRESHOLD =
1510         0x7fffffffffffffffffffffffffffffff5d576e7357a4501ddfe92f46681b20a0;
1511 
1512     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
1513     /*                    RECOVERY OPERATIONS                     */
1514     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
1515 
1516     /// @dev Recovers the signer's address from a message digest `hash`,
1517     /// and the `signature`.
1518     ///
1519     /// This function does NOT accept EIP-2098 short form signatures.
1520     /// Use `recover(bytes32 hash, bytes32 r, bytes32 vs)` for EIP-2098
1521     /// short form signatures instead.
1522     ///
1523     /// WARNING!
1524     /// The `result` will be the zero address upon recovery failure.
1525     /// As such, it is extremely important to ensure that the address which
1526     /// the `result` is compared against is never zero.
1527     function recover(bytes32 hash, bytes calldata signature) internal view returns (address result) {
1528         assembly {
1529             if eq(signature.length, 65) {
1530                 // Copy the free memory pointer so that we can restore it later.
1531                 let m := mload(0x40)
1532                 // Directly copy `r` and `s` from the calldata.
1533                 calldatacopy(0x40, signature.offset, 0x40)
1534 
1535                 // If `s` in lower half order, such that the signature is not malleable.
1536                 if iszero(gt(mload(0x60), _MALLEABILITY_THRESHOLD)) {
1537                     mstore(0x00, hash)
1538                     // Compute `v` and store it in the scratch space.
1539                     mstore(0x20, byte(0, calldataload(add(signature.offset, 0x40))))
1540                     pop(
1541                         staticcall(
1542                             gas(), // Amount of gas left for the transaction.
1543                             0x01, // Address of `ecrecover`.
1544                             0x00, // Start of input.
1545                             0x80, // Size of input.
1546                             0x40, // Start of output.
1547                             0x20 // Size of output.
1548                         )
1549                     )
1550                     // Restore the zero slot.
1551                     mstore(0x60, 0)
1552                     // `returndatasize()` will be `0x20` upon success, and `0x00` otherwise.
1553                     result := mload(sub(0x60, returndatasize()))
1554                 }
1555                 // Restore the free memory pointer.
1556                 mstore(0x40, m)
1557             }
1558         }
1559     }
1560 
1561     /// @dev Recovers the signer's address from a message digest `hash`,
1562     /// and the EIP-2098 short form signature defined by `r` and `vs`.
1563     ///
1564     /// This function only accepts EIP-2098 short form signatures.
1565     /// See: https://eips.ethereum.org/EIPS/eip-2098
1566     ///
1567     /// To be honest, I do not recommend using EIP-2098 signatures
1568     /// for simplicity, performance, and security reasons. Most if not
1569     /// all clients support traditional non EIP-2098 signatures by default.
1570     /// As such, this method is intentionally not fully inlined.
1571     /// It is merely included for completeness.
1572     ///
1573     /// WARNING!
1574     /// The `result` will be the zero address upon recovery failure.
1575     /// As such, it is extremely important to ensure that the address which
1576     /// the `result` is compared against is never zero.
1577     function recover(
1578         bytes32 hash,
1579         bytes32 r,
1580         bytes32 vs
1581     ) internal view returns (address result) {
1582         uint8 v;
1583         bytes32 s;
1584         assembly {
1585             s := shr(1, shl(1, vs))
1586             v := add(shr(255, vs), 27)
1587         }
1588         result = recover(hash, v, r, s);
1589     }
1590 
1591     /// @dev Recovers the signer's address from a message digest `hash`,
1592     /// and the signature defined by `v`, `r`, `s`.
1593     ///
1594     /// WARNING!
1595     /// The `result` will be the zero address upon recovery failure.
1596     /// As such, it is extremely important to ensure that the address which
1597     /// the `result` is compared against is never zero.
1598     function recover(
1599         bytes32 hash,
1600         uint8 v,
1601         bytes32 r,
1602         bytes32 s
1603     ) internal view returns (address result) {
1604         assembly {
1605             // Copy the free memory pointer so that we can restore it later.
1606             let m := mload(0x40)
1607 
1608             // If `s` in lower half order, such that the signature is not malleable.
1609             if iszero(gt(s, _MALLEABILITY_THRESHOLD)) {
1610                 mstore(0x00, hash)
1611                 mstore(0x20, v)
1612                 mstore(0x40, r)
1613                 mstore(0x60, s)
1614                 pop(
1615                     staticcall(
1616                         gas(), // Amount of gas left for the transaction.
1617                         0x01, // Address of `ecrecover`.
1618                         0x00, // Start of input.
1619                         0x80, // Size of input.
1620                         0x40, // Start of output.
1621                         0x20 // Size of output.
1622                     )
1623                 )
1624                 // Restore the zero slot.
1625                 mstore(0x60, 0)
1626                 // `returndatasize()` will be `0x20` upon success, and `0x00` otherwise.
1627                 result := mload(sub(0x60, returndatasize()))
1628             }
1629             // Restore the free memory pointer.
1630             mstore(0x40, m)
1631         }
1632     }
1633 
1634     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
1635     /*                     HASHING OPERATIONS                     */
1636     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
1637 
1638     /// @dev Returns an Ethereum Signed Message, created from a `hash`.
1639     /// This produces a hash corresponding to the one signed with the
1640     /// [`eth_sign`](https://eth.wiki/json-rpc/API#eth_sign)
1641     /// JSON-RPC method as part of EIP-191.
1642     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32 result) {
1643         assembly {
1644             // Store into scratch space for keccak256.
1645             mstore(0x20, hash)
1646             mstore(0x00, "\x00\x00\x00\x00\x19Ethereum Signed Message:\n32")
1647             // 0x40 - 0x04 = 0x3c
1648             result := keccak256(0x04, 0x3c)
1649         }
1650     }
1651 
1652     /// @dev Returns an Ethereum Signed Message, created from `s`.
1653     /// This produces a hash corresponding to the one signed with the
1654     /// [`eth_sign`](https://eth.wiki/json-rpc/API#eth_sign)
1655     /// JSON-RPC method as part of EIP-191.
1656     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32 result) {
1657         assembly {
1658             // We need at most 128 bytes for Ethereum signed message header.
1659             // The max length of the ASCII reprenstation of a uint256 is 78 bytes.
1660             // The length of "\x19Ethereum Signed Message:\n" is 26 bytes (i.e. 0x1a).
1661             // The next multiple of 32 above 78 + 26 is 128 (i.e. 0x80).
1662 
1663             // Instead of allocating, we temporarily copy the 128 bytes before the
1664             // start of `s` data to some variables.
1665             let m3 := mload(sub(s, 0x60))
1666             let m2 := mload(sub(s, 0x40))
1667             let m1 := mload(sub(s, 0x20))
1668             // The length of `s` is in bytes.
1669             let sLength := mload(s)
1670 
1671             let ptr := add(s, 0x20)
1672 
1673             // `end` marks the end of the memory which we will compute the keccak256 of.
1674             let end := add(ptr, sLength)
1675 
1676             // Convert the length of the bytes to ASCII decimal representation
1677             // and store it into the memory.
1678             // prettier-ignore
1679             for { let temp := sLength } 1 {} {
1680                 ptr := sub(ptr, 1)
1681                 mstore8(ptr, add(48, mod(temp, 10)))
1682                 temp := div(temp, 10)
1683                 // prettier-ignore
1684                 if iszero(temp) { break }
1685             }
1686 
1687             // Copy the header over to the memory.
1688             mstore(sub(ptr, 0x20), "\x00\x00\x00\x00\x00\x00\x19Ethereum Signed Message:\n")
1689             // Compute the keccak256 of the memory.
1690             result := keccak256(sub(ptr, 0x1a), sub(end, sub(ptr, 0x1a)))
1691 
1692             // Restore the previous memory.
1693             mstore(s, sLength)
1694             mstore(sub(s, 0x20), m1)
1695             mstore(sub(s, 0x40), m2)
1696             mstore(sub(s, 0x60), m3)
1697         }
1698     }
1699 }
1700 
1701 // File: contracts/azul.sol
1702 
1703 
1704 pragma solidity 0.8.10;
1705 
1706 contract Azul is ERC721A, Ownable {
1707     error PhaseInactive();
1708     error InvalidQuantity();
1709     error MintedOut();
1710     error NonSufficientFunds();
1711     error AlreadyMinted();
1712     error InvalidSignature();
1713     error ApprovalNotAllowedYet();
1714 
1715     address private constant _deployer = 0x81B0f36C06DBA182E0F3CF1394bB89A3592626d1;
1716     address private immutable _signer;
1717     uint256 private constant _maxMint = 1;
1718 
1719     uint256 private _price = 0.5 ether;
1720     uint256 private _maxSupply = 750;
1721 
1722     bool private _publicActive;
1723     bool private _whitelistActive;
1724     bool private _waitlistActive;
1725     bool private _approvalAllowed;
1726 
1727     string private _metadataUri;
1728 
1729     constructor(address signer, string memory metadataUri) ERC721A("Azul", "AZUL") {
1730         _signer = signer;
1731         _metadataUri = metadataUri;
1732     }
1733 
1734     function whitelistMint(uint256 quantity, bytes calldata signature) external payable
1735     {
1736         if (!_whitelistActive) revert PhaseInactive();
1737         if (totalSupply() == _maxSupply) revert MintedOut();
1738         if (msg.value < _price) revert NonSufficientFunds();
1739         if (_numberMinted(msg.sender) > 0) revert AlreadyMinted();
1740         if (quantity == _maxMint) {
1741             bytes32 data;
1742             assembly {
1743                 //prepare signature data
1744                 mstore(0x00, shl(0x60, caller()))
1745                 mstore(0x20, keccak256(0x00, 0x14))
1746                 mstore(0x00, "\x00\x00\x00\x00\x19Ethereum Signed Message:\n32")
1747                 data := keccak256(0x04, 0x3c)
1748             }
1749             if (_signer == ECDSA.recover(data, signature)) _mint(msg.sender, _maxMint);
1750             else revert InvalidSignature();
1751         } 
1752         else revert InvalidQuantity();
1753     }
1754 
1755     function waitlistMint(uint256 quantity, bytes calldata signature) external payable
1756     {
1757         if (!_waitlistActive) revert PhaseInactive();
1758         if (totalSupply() == _maxSupply) revert MintedOut();
1759         if (msg.value < _price) revert NonSufficientFunds();
1760         if (_numberMinted(msg.sender) != 0) revert AlreadyMinted();
1761         if (quantity == _maxMint) {
1762             bytes32 data;
1763             assembly {
1764                 //prepare signature data
1765                 mstore(0x00, or(shl(0xF8, 0x1), shl(0x58, caller())))
1766                 mstore(0x20, keccak256(0x00, 0x15))
1767                 mstore(0x00, "\x00\x00\x00\x00\x19Ethereum Signed Message:\n32")
1768                 data := keccak256(0x04, 0x3c)
1769             }
1770             if (_signer == ECDSA.recover(data, signature)) _mint(msg.sender, _maxMint);
1771             else revert InvalidSignature();
1772         }
1773         else revert InvalidQuantity();
1774     }
1775 
1776    function publicMint(uint256 quantity) external payable {
1777         if (!_publicActive) revert PhaseInactive();
1778         if (totalSupply() == _maxSupply) revert MintedOut();
1779         if (msg.value < _price) revert NonSufficientFunds();
1780         if (quantity == _maxMint) _mint(msg.sender, _maxMint);
1781         else revert InvalidQuantity();
1782     }
1783 
1784     //View functions
1785     function price() external view returns (uint256) {
1786         return _price;
1787     }
1788 
1789     function maxSupply() external view returns (uint256) {
1790         return _maxSupply;
1791     }
1792 
1793     function maxMint() external pure returns (uint256) {
1794         return _maxMint;
1795     }
1796 
1797     function approvalAllowed() external view returns (bool) {
1798         return _approvalAllowed;
1799     }
1800 
1801     function mintState() external view 
1802         returns (bool whitelistActive, bool waitlistActive, bool publicActive, bool soldOut)
1803     {
1804         return ( _whitelistActive,  _waitlistActive, _publicActive, totalSupply() == _maxSupply);
1805     }
1806 
1807 	function approve(address to, uint256 tokenId) public payable virtual override {
1808         if(!_approvalAllowed)  revert ApprovalNotAllowedYet();
1809         super.approve(to, tokenId);
1810     }
1811  
1812     function setApprovalForAll(address operator, bool approved) public virtual override {
1813         if(!_approvalAllowed)  revert ApprovalNotAllowedYet();
1814         super.setApprovalForAll(operator, approved);
1815     }
1816 
1817     function _baseURI() internal view virtual override returns (string memory) {
1818         return _metadataUri;
1819     }
1820     
1821     //Ownable Functions
1822     function publicSwitch() external onlyOwner {
1823         _publicActive = !_publicActive;
1824     }
1825 
1826     function whitelistSwitch() external onlyOwner {
1827         _whitelistActive = !_whitelistActive;
1828     }
1829 
1830     function waitlistSwitch() external onlyOwner {
1831         _waitlistActive = !_waitlistActive;
1832     }
1833     
1834     function allowApprovals() external onlyOwner {
1835         _approvalAllowed = true;
1836     }
1837 
1838     function withdraw() external onlyOwner {
1839        payable(_deployer).transfer(address(this).balance);
1840     }
1841 
1842    
1843     function setMetadataUri(string calldata _uri) external onlyOwner {
1844         _metadataUri = _uri;
1845     }
1846 
1847     function setPrice(uint256 _newPrice) external onlyOwner {
1848         _price = _newPrice;
1849     }
1850 
1851     function updateSupply(uint256 _newAmount) external onlyOwner {
1852         require(_newAmount > totalSupply(), "Error updating supply"); 
1853         _maxSupply = _newAmount;
1854     }
1855   
1856 }