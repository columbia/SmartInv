1 /**
2  *Submitted for verification at Etherscan.io on 2022-08-02
3 */
4 
5 // File: @openzeppelin/contracts/utils/Context.sol
6 
7 
8 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
9 
10 pragma solidity ^0.8.0;
11 
12 /**
13  * @dev Provides information about the current execution context, including the
14  * sender of the transaction and its data. While these are generally available
15  * via msg.sender and msg.data, they should not be accessed in such a direct
16  * manner, since when dealing with meta-transactions the account sending and
17  * paying for execution may not be the actual sender (as far as an application
18  * is concerned).
19  *
20  * This contract is only required for intermediate, library-like contracts.
21  */
22 abstract contract Context {
23     function _msgSender() internal view virtual returns (address) {
24         return msg.sender;
25     }
26 
27     function _msgData() internal view virtual returns (bytes calldata) {
28         return msg.data;
29     }
30 }
31 
32 // File: @openzeppelin/contracts/access/Ownable.sol
33 
34 
35 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
36 
37 pragma solidity ^0.8.0;
38 
39 
40 /**
41  * @dev Contract module which provides a basic access control mechanism, where
42  * there is an account (an owner) that can be granted exclusive access to
43  * specific functions.
44  *
45  * By default, the owner account will be the one that deploys the contract. This
46  * can later be changed with {transferOwnership}.
47  *
48  * This module is used through inheritance. It will make available the modifier
49  * `onlyOwner`, which can be applied to your functions to restrict their use to
50  * the owner.
51  */
52 abstract contract Ownable is Context {
53     address private _owner;
54 
55     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
56 
57     /**
58      * @dev Initializes the contract setting the deployer as the initial owner.
59      */
60     constructor() {
61         _transferOwnership(_msgSender());
62     }
63 
64     /**
65      * @dev Throws if called by any account other than the owner.
66      */
67     modifier onlyOwner() {
68         _checkOwner();
69         _;
70     }
71 
72     /**
73      * @dev Returns the address of the current owner.
74      */
75     function owner() public view virtual returns (address) {
76         return _owner;
77     }
78 
79     /**
80      * @dev Throws if the sender is not the owner.
81      */
82     function _checkOwner() internal view virtual {
83         require(owner() == _msgSender(), "Ownable: caller is not the owner");
84     }
85 
86     /**
87      * @dev Leaves the contract without owner. It will not be possible to call
88      * `onlyOwner` functions anymore. Can only be called by the current owner.
89      *
90      * NOTE: Renouncing ownership will leave the contract without an owner,
91      * thereby removing any functionality that is only available to the owner.
92      */
93     function renounceOwnership() public virtual onlyOwner {
94         _transferOwnership(address(0));
95     }
96 
97     /**
98      * @dev Transfers ownership of the contract to a new account (`newOwner`).
99      * Can only be called by the current owner.
100      */
101     function transferOwnership(address newOwner) public virtual onlyOwner {
102         require(newOwner != address(0), "Ownable: new owner is the zero address");
103         _transferOwnership(newOwner);
104     }
105 
106     /**
107      * @dev Transfers ownership of the contract to a new account (`newOwner`).
108      * Internal function without access restriction.
109      */
110     function _transferOwnership(address newOwner) internal virtual {
111         address oldOwner = _owner;
112         _owner = newOwner;
113         emit OwnershipTransferred(oldOwner, newOwner);
114     }
115 }
116 
117 // File: erc721a/contracts/IERC721A.sol
118 
119 
120 // ERC721A Contracts v4.2.0
121 // Creator: Chiru Labs
122 
123 pragma solidity ^0.8.4;
124 
125 /**
126  * @dev Interface of ERC721A.
127  */
128 interface IERC721A {
129     /**
130      * The caller must own the token or be an approved operator.
131      */
132     error ApprovalCallerNotOwnerNorApproved();
133 
134     /**
135      * The token does not exist.
136      */
137     error ApprovalQueryForNonexistentToken();
138 
139     /**
140      * The caller cannot approve to their own address.
141      */
142     error ApproveToCaller();
143 
144     /**
145      * Cannot query the balance for the zero address.
146      */
147     error BalanceQueryForZeroAddress();
148 
149     /**
150      * Cannot mint to the zero address.
151      */
152     error MintToZeroAddress();
153 
154     /**
155      * The quantity of tokens minted must be more than zero.
156      */
157     error MintZeroQuantity();
158 
159     /**
160      * The token does not exist.
161      */
162     error OwnerQueryForNonexistentToken();
163 
164     /**
165      * The caller must own the token or be an approved operator.
166      */
167     error TransferCallerNotOwnerNorApproved();
168 
169     /**
170      * The token must be owned by `from`.
171      */
172     error TransferFromIncorrectOwner();
173 
174     /**
175      * Cannot safely transfer to a contract that does not implement the
176      * ERC721Receiver interface.
177      */
178     error TransferToNonERC721ReceiverImplementer();
179 
180     /**
181      * Cannot transfer to the zero address.
182      */
183     error TransferToZeroAddress();
184 
185     /**
186      * The token does not exist.
187      */
188     error URIQueryForNonexistentToken();
189 
190     /**
191      * The `quantity` minted with ERC2309 exceeds the safety limit.
192      */
193     error MintERC2309QuantityExceedsLimit();
194 
195     /**
196      * The `extraData` cannot be set on an unintialized ownership slot.
197      */
198     error OwnershipNotInitializedForExtraData();
199 
200     // =============================================================
201     //                            STRUCTS
202     // =============================================================
203 
204     struct TokenOwnership {
205         // The address of the owner.
206         address addr;
207         // Stores the start time of ownership with minimal overhead for tokenomics.
208         uint64 startTimestamp;
209         // Whether the token has been burned.
210         bool burned;
211         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
212         uint24 extraData;
213     }
214 
215     // =============================================================
216     //                         TOKEN COUNTERS
217     // =============================================================
218 
219     /**
220      * @dev Returns the total number of tokens in existence.
221      * Burned tokens will reduce the count.
222      * To get the total number of tokens minted, please see {_totalMinted}.
223      */
224     function totalSupply() external view returns (uint256);
225 
226     // =============================================================
227     //                            IERC165
228     // =============================================================
229 
230     /**
231      * @dev Returns true if this contract implements the interface defined by
232      * `interfaceId`. See the corresponding
233      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
234      * to learn more about how these ids are created.
235      *
236      * This function call must use less than 30000 gas.
237      */
238     function supportsInterface(bytes4 interfaceId) external view returns (bool);
239 
240     // =============================================================
241     //                            IERC721
242     // =============================================================
243 
244     /**
245      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
246      */
247     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
248 
249     /**
250      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
251      */
252     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
253 
254     /**
255      * @dev Emitted when `owner` enables or disables
256      * (`approved`) `operator` to manage all of its assets.
257      */
258     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
259 
260     /**
261      * @dev Returns the number of tokens in `owner`'s account.
262      */
263     function balanceOf(address owner) external view returns (uint256 balance);
264 
265     /**
266      * @dev Returns the owner of the `tokenId` token.
267      *
268      * Requirements:
269      *
270      * - `tokenId` must exist.
271      */
272     function ownerOf(uint256 tokenId) external view returns (address owner);
273 
274     /**
275      * @dev Safely transfers `tokenId` token from `from` to `to`,
276      * checking first that contract recipients are aware of the ERC721 protocol
277      * to prevent tokens from being forever locked.
278      *
279      * Requirements:
280      *
281      * - `from` cannot be the zero address.
282      * - `to` cannot be the zero address.
283      * - `tokenId` token must exist and be owned by `from`.
284      * - If the caller is not `from`, it must be have been allowed to move
285      * this token by either {approve} or {setApprovalForAll}.
286      * - If `to` refers to a smart contract, it must implement
287      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
288      *
289      * Emits a {Transfer} event.
290      */
291     function safeTransferFrom(
292         address from,
293         address to,
294         uint256 tokenId,
295         bytes calldata data
296     ) external;
297 
298     /**
299      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
300      */
301     function safeTransferFrom(
302         address from,
303         address to,
304         uint256 tokenId
305     ) external;
306 
307     /**
308      * @dev Transfers `tokenId` from `from` to `to`.
309      *
310      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
311      * whenever possible.
312      *
313      * Requirements:
314      *
315      * - `from` cannot be the zero address.
316      * - `to` cannot be the zero address.
317      * - `tokenId` token must be owned by `from`.
318      * - If the caller is not `from`, it must be approved to move this token
319      * by either {approve} or {setApprovalForAll}.
320      *
321      * Emits a {Transfer} event.
322      */
323     function transferFrom(
324         address from,
325         address to,
326         uint256 tokenId
327     ) external;
328 
329     /**
330      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
331      * The approval is cleared when the token is transferred.
332      *
333      * Only a single account can be approved at a time, so approving the
334      * zero address clears previous approvals.
335      *
336      * Requirements:
337      *
338      * - The caller must own the token or be an approved operator.
339      * - `tokenId` must exist.
340      *
341      * Emits an {Approval} event.
342      */
343     function approve(address to, uint256 tokenId) external;
344 
345     /**
346      * @dev Approve or remove `operator` as an operator for the caller.
347      * Operators can call {transferFrom} or {safeTransferFrom}
348      * for any token owned by the caller.
349      *
350      * Requirements:
351      *
352      * - The `operator` cannot be the caller.
353      *
354      * Emits an {ApprovalForAll} event.
355      */
356     function setApprovalForAll(address operator, bool _approved) external;
357 
358     /**
359      * @dev Returns the account approved for `tokenId` token.
360      *
361      * Requirements:
362      *
363      * - `tokenId` must exist.
364      */
365     function getApproved(uint256 tokenId) external view returns (address operator);
366 
367     /**
368      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
369      *
370      * See {setApprovalForAll}.
371      */
372     function isApprovedForAll(address owner, address operator) external view returns (bool);
373 
374     // =============================================================
375     //                        IERC721Metadata
376     // =============================================================
377 
378     /**
379      * @dev Returns the token collection name.
380      */
381     function name() external view returns (string memory);
382 
383     /**
384      * @dev Returns the token collection symbol.
385      */
386     function symbol() external view returns (string memory);
387 
388     /**
389      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
390      */
391     function tokenURI(uint256 tokenId) external view returns (string memory);
392 
393     // =============================================================
394     //                           IERC2309
395     // =============================================================
396 
397     /**
398      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
399      * (inclusive) is transferred from `from` to `to`, as defined in the
400      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
401      *
402      * See {_mintERC2309} for more details.
403      */
404     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
405 }
406 
407 // File: erc721a/contracts/ERC721A.sol
408 
409 
410 // ERC721A Contracts v4.2.0
411 // Creator: Chiru Labs
412 
413 pragma solidity ^0.8.4;
414 
415 
416 /**
417  * @dev Interface of ERC721 token receiver.
418  */
419 interface ERC721A__IERC721Receiver {
420     function onERC721Received(
421         address operator,
422         address from,
423         uint256 tokenId,
424         bytes calldata data
425     ) external returns (bytes4);
426 }
427 
428 /**
429  * @title ERC721A
430  *
431  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
432  * Non-Fungible Token Standard, including the Metadata extension.
433  * Optimized for lower gas during batch mints.
434  *
435  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
436  * starting from `_startTokenId()`.
437  *
438  * Assumptions:
439  *
440  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
441  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
442  */
443 contract ERC721A is IERC721A {
444     // Reference type for token approval.
445     struct TokenApprovalRef {
446         address value;
447     }
448 
449     // =============================================================
450     //                           CONSTANTS
451     // =============================================================
452 
453     // Mask of an entry in packed address data.
454     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
455 
456     // The bit position of `numberMinted` in packed address data.
457     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
458 
459     // The bit position of `numberBurned` in packed address data.
460     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
461 
462     // The bit position of `aux` in packed address data.
463     uint256 private constant _BITPOS_AUX = 192;
464 
465     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
466     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
467 
468     // The bit position of `startTimestamp` in packed ownership.
469     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
470 
471     // The bit mask of the `burned` bit in packed ownership.
472     uint256 private constant _BITMASK_BURNED = 1 << 224;
473 
474     // The bit position of the `nextInitialized` bit in packed ownership.
475     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
476 
477     // The bit mask of the `nextInitialized` bit in packed ownership.
478     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
479 
480     // The bit position of `extraData` in packed ownership.
481     uint256 private constant _BITPOS_EXTRA_DATA = 232;
482 
483     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
484     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
485 
486     // The mask of the lower 160 bits for addresses.
487     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
488 
489     // The maximum `quantity` that can be minted with {_mintERC2309}.
490     // This limit is to prevent overflows on the address data entries.
491     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
492     // is required to cause an overflow, which is unrealistic.
493     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
494 
495     // The `Transfer` event signature is given by:
496     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
497     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
498         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
499 
500     // =============================================================
501     //                            STORAGE
502     // =============================================================
503 
504     // The next token ID to be minted.
505     uint256 private _currentIndex;
506 
507     // The number of tokens burned.
508     uint256 private _burnCounter;
509 
510     // Token name
511     string private _name;
512 
513     // Token symbol
514     string private _symbol;
515 
516     // Mapping from token ID to ownership details
517     // An empty struct value does not necessarily mean the token is unowned.
518     // See {_packedOwnershipOf} implementation for details.
519     //
520     // Bits Layout:
521     // - [0..159]   `addr`
522     // - [160..223] `startTimestamp`
523     // - [224]      `burned`
524     // - [225]      `nextInitialized`
525     // - [232..255] `extraData`
526     mapping(uint256 => uint256) private _packedOwnerships;
527 
528     // Mapping owner address to address data.
529     //
530     // Bits Layout:
531     // - [0..63]    `balance`
532     // - [64..127]  `numberMinted`
533     // - [128..191] `numberBurned`
534     // - [192..255] `aux`
535     mapping(address => uint256) private _packedAddressData;
536 
537     // Mapping from token ID to approved address.
538     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
539 
540     // Mapping from owner to operator approvals
541     mapping(address => mapping(address => bool)) private _operatorApprovals;
542 
543     // =============================================================
544     //                          CONSTRUCTOR
545     // =============================================================
546 
547     constructor(string memory name_, string memory symbol_) {
548         _name = name_;
549         _symbol = symbol_;
550         _currentIndex = _startTokenId();
551     }
552 
553     // =============================================================
554     //                   TOKEN COUNTING OPERATIONS
555     // =============================================================
556 
557     /**
558      * @dev Returns the starting token ID.
559      * To change the starting token ID, please override this function.
560      */
561     function _startTokenId() internal view virtual returns (uint256) {
562         return 0;
563     }
564 
565     /**
566      * @dev Returns the next token ID to be minted.
567      */
568     function _nextTokenId() internal view virtual returns (uint256) {
569         return _currentIndex;
570     }
571 
572     /**
573      * @dev Returns the total number of tokens in existence.
574      * Burned tokens will reduce the count.
575      * To get the total number of tokens minted, please see {_totalMinted}.
576      */
577     function totalSupply() public view virtual override returns (uint256) {
578         // Counter underflow is impossible as _burnCounter cannot be incremented
579         // more than `_currentIndex - _startTokenId()` times.
580         unchecked {
581             return _currentIndex - _burnCounter - _startTokenId();
582         }
583     }
584 
585     /**
586      * @dev Returns the total amount of tokens minted in the contract.
587      */
588     function _totalMinted() internal view virtual returns (uint256) {
589         // Counter underflow is impossible as `_currentIndex` does not decrement,
590         // and it is initialized to `_startTokenId()`.
591         unchecked {
592             return _currentIndex - _startTokenId();
593         }
594     }
595 
596     /**
597      * @dev Returns the total number of tokens burned.
598      */
599     function _totalBurned() internal view virtual returns (uint256) {
600         return _burnCounter;
601     }
602 
603     // =============================================================
604     //                    ADDRESS DATA OPERATIONS
605     // =============================================================
606 
607     /**
608      * @dev Returns the number of tokens in `owner`'s account.
609      */
610     function balanceOf(address owner) public view virtual override returns (uint256) {
611         if (owner == address(0)) revert BalanceQueryForZeroAddress();
612         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
613     }
614 
615     /**
616      * Returns the number of tokens minted by `owner`.
617      */
618     function _numberMinted(address owner) internal view returns (uint256) {
619         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
620     }
621 
622     /**
623      * Returns the number of tokens burned by or on behalf of `owner`.
624      */
625     function _numberBurned(address owner) internal view returns (uint256) {
626         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
627     }
628 
629     /**
630      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
631      */
632     function _getAux(address owner) internal view returns (uint64) {
633         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
634     }
635 
636     /**
637      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
638      * If there are multiple variables, please pack them into a uint64.
639      */
640     function _setAux(address owner, uint64 aux) internal virtual {
641         uint256 packed = _packedAddressData[owner];
642         uint256 auxCasted;
643         // Cast `aux` with assembly to avoid redundant masking.
644         assembly {
645             auxCasted := aux
646         }
647         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
648         _packedAddressData[owner] = packed;
649     }
650 
651     // =============================================================
652     //                            IERC165
653     // =============================================================
654 
655     /**
656      * @dev Returns true if this contract implements the interface defined by
657      * `interfaceId`. See the corresponding
658      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
659      * to learn more about how these ids are created.
660      *
661      * This function call must use less than 30000 gas.
662      */
663     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
664         // The interface IDs are constants representing the first 4 bytes
665         // of the XOR of all function selectors in the interface.
666         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
667         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
668         return
669             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
670             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
671             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
672     }
673 
674     // =============================================================
675     //                        IERC721Metadata
676     // =============================================================
677 
678     /**
679      * @dev Returns the token collection name.
680      */
681     function name() public view virtual override returns (string memory) {
682         return _name;
683     }
684 
685     /**
686      * @dev Returns the token collection symbol.
687      */
688     function symbol() public view virtual override returns (string memory) {
689         return _symbol;
690     }
691 
692     /**
693      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
694      */
695     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
696         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
697 
698         string memory baseURI = _baseURI();
699         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
700     }
701 
702     /**
703      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
704      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
705      * by default, it can be overridden in child contracts.
706      */
707     function _baseURI() internal view virtual returns (string memory) {
708         return '';
709     }
710 
711     // =============================================================
712     //                     OWNERSHIPS OPERATIONS
713     // =============================================================
714 
715     /**
716      * @dev Returns the owner of the `tokenId` token.
717      *
718      * Requirements:
719      *
720      * - `tokenId` must exist.
721      */
722     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
723         return address(uint160(_packedOwnershipOf(tokenId)));
724     }
725 
726     /**
727      * @dev Gas spent here starts off proportional to the maximum mint batch size.
728      * It gradually moves to O(1) as tokens get transferred around over time.
729      */
730     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
731         return _unpackedOwnership(_packedOwnershipOf(tokenId));
732     }
733 
734     /**
735      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
736      */
737     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
738         return _unpackedOwnership(_packedOwnerships[index]);
739     }
740 
741     /**
742      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
743      */
744     function _initializeOwnershipAt(uint256 index) internal virtual {
745         if (_packedOwnerships[index] == 0) {
746             _packedOwnerships[index] = _packedOwnershipOf(index);
747         }
748     }
749 
750     /**
751      * Returns the packed ownership data of `tokenId`.
752      */
753     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
754         uint256 curr = tokenId;
755 
756         unchecked {
757             if (_startTokenId() <= curr)
758                 if (curr < _currentIndex) {
759                     uint256 packed = _packedOwnerships[curr];
760                     // If not burned.
761                     if (packed & _BITMASK_BURNED == 0) {
762                         // Invariant:
763                         // There will always be an initialized ownership slot
764                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
765                         // before an unintialized ownership slot
766                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
767                         // Hence, `curr` will not underflow.
768                         //
769                         // We can directly compare the packed value.
770                         // If the address is zero, packed will be zero.
771                         while (packed == 0) {
772                             packed = _packedOwnerships[--curr];
773                         }
774                         return packed;
775                     }
776                 }
777         }
778         revert OwnerQueryForNonexistentToken();
779     }
780 
781     /**
782      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
783      */
784     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
785         ownership.addr = address(uint160(packed));
786         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
787         ownership.burned = packed & _BITMASK_BURNED != 0;
788         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
789     }
790 
791     /**
792      * @dev Packs ownership data into a single uint256.
793      */
794     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
795         assembly {
796             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
797             owner := and(owner, _BITMASK_ADDRESS)
798             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
799             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
800         }
801     }
802 
803     /**
804      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
805      */
806     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
807         // For branchless setting of the `nextInitialized` flag.
808         assembly {
809             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
810             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
811         }
812     }
813 
814     // =============================================================
815     //                      APPROVAL OPERATIONS
816     // =============================================================
817 
818     /**
819      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
820      * The approval is cleared when the token is transferred.
821      *
822      * Only a single account can be approved at a time, so approving the
823      * zero address clears previous approvals.
824      *
825      * Requirements:
826      *
827      * - The caller must own the token or be an approved operator.
828      * - `tokenId` must exist.
829      *
830      * Emits an {Approval} event.
831      */
832     function approve(address to, uint256 tokenId) public virtual override {
833         address owner = ownerOf(tokenId);
834 
835         if (_msgSenderERC721A() != owner)
836             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
837                 revert ApprovalCallerNotOwnerNorApproved();
838             }
839 
840         _tokenApprovals[tokenId].value = to;
841         emit Approval(owner, to, tokenId);
842     }
843 
844     /**
845      * @dev Returns the account approved for `tokenId` token.
846      *
847      * Requirements:
848      *
849      * - `tokenId` must exist.
850      */
851     function getApproved(uint256 tokenId) public view virtual override returns (address) {
852         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
853 
854         return _tokenApprovals[tokenId].value;
855     }
856 
857     /**
858      * @dev Approve or remove `operator` as an operator for the caller.
859      * Operators can call {transferFrom} or {safeTransferFrom}
860      * for any token owned by the caller.
861      *
862      * Requirements:
863      *
864      * - The `operator` cannot be the caller.
865      *
866      * Emits an {ApprovalForAll} event.
867      */
868     function setApprovalForAll(address operator, bool approved) public virtual override {
869         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
870 
871         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
872         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
873     }
874 
875     /**
876      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
877      *
878      * See {setApprovalForAll}.
879      */
880     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
881         return _operatorApprovals[owner][operator];
882     }
883 
884     /**
885      * @dev Returns whether `tokenId` exists.
886      *
887      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
888      *
889      * Tokens start existing when they are minted. See {_mint}.
890      */
891     function _exists(uint256 tokenId) internal view virtual returns (bool) {
892         return
893             _startTokenId() <= tokenId &&
894             tokenId < _currentIndex && // If within bounds,
895             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
896     }
897 
898     /**
899      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
900      */
901     function _isSenderApprovedOrOwner(
902         address approvedAddress,
903         address owner,
904         address msgSender
905     ) private pure returns (bool result) {
906         assembly {
907             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
908             owner := and(owner, _BITMASK_ADDRESS)
909             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
910             msgSender := and(msgSender, _BITMASK_ADDRESS)
911             // `msgSender == owner || msgSender == approvedAddress`.
912             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
913         }
914     }
915 
916     /**
917      * @dev Returns the storage slot and value for the approved address of `tokenId`.
918      */
919     function _getApprovedSlotAndAddress(uint256 tokenId)
920         private
921         view
922         returns (uint256 approvedAddressSlot, address approvedAddress)
923     {
924         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
925         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
926         assembly {
927             approvedAddressSlot := tokenApproval.slot
928             approvedAddress := sload(approvedAddressSlot)
929         }
930     }
931 
932     // =============================================================
933     //                      TRANSFER OPERATIONS
934     // =============================================================
935 
936     /**
937      * @dev Transfers `tokenId` from `from` to `to`.
938      *
939      * Requirements:
940      *
941      * - `from` cannot be the zero address.
942      * - `to` cannot be the zero address.
943      * - `tokenId` token must be owned by `from`.
944      * - If the caller is not `from`, it must be approved to move this token
945      * by either {approve} or {setApprovalForAll}.
946      *
947      * Emits a {Transfer} event.
948      */
949     function transferFrom(
950         address from,
951         address to,
952         uint256 tokenId
953     ) public virtual override {
954         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
955 
956         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
957 
958         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
959 
960         // The nested ifs save around 20+ gas over a compound boolean condition.
961         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
962             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
963 
964         if (to == address(0)) revert TransferToZeroAddress();
965 
966         _beforeTokenTransfers(from, to, tokenId, 1);
967 
968         // Clear approvals from the previous owner.
969         assembly {
970             if approvedAddress {
971                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
972                 sstore(approvedAddressSlot, 0)
973             }
974         }
975 
976         // Underflow of the sender's balance is impossible because we check for
977         // ownership above and the recipient's balance can't realistically overflow.
978         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
979         unchecked {
980             // We can directly increment and decrement the balances.
981             --_packedAddressData[from]; // Updates: `balance -= 1`.
982             ++_packedAddressData[to]; // Updates: `balance += 1`.
983 
984             // Updates:
985             // - `address` to the next owner.
986             // - `startTimestamp` to the timestamp of transfering.
987             // - `burned` to `false`.
988             // - `nextInitialized` to `true`.
989             _packedOwnerships[tokenId] = _packOwnershipData(
990                 to,
991                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
992             );
993 
994             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
995             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
996                 uint256 nextTokenId = tokenId + 1;
997                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
998                 if (_packedOwnerships[nextTokenId] == 0) {
999                     // If the next slot is within bounds.
1000                     if (nextTokenId != _currentIndex) {
1001                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1002                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1003                     }
1004                 }
1005             }
1006         }
1007 
1008         emit Transfer(from, to, tokenId);
1009         _afterTokenTransfers(from, to, tokenId, 1);
1010     }
1011 
1012     /**
1013      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1014      */
1015     function safeTransferFrom(
1016         address from,
1017         address to,
1018         uint256 tokenId
1019     ) public virtual override {
1020         safeTransferFrom(from, to, tokenId, '');
1021     }
1022 
1023     /**
1024      * @dev Safely transfers `tokenId` token from `from` to `to`.
1025      *
1026      * Requirements:
1027      *
1028      * - `from` cannot be the zero address.
1029      * - `to` cannot be the zero address.
1030      * - `tokenId` token must exist and be owned by `from`.
1031      * - If the caller is not `from`, it must be approved to move this token
1032      * by either {approve} or {setApprovalForAll}.
1033      * - If `to` refers to a smart contract, it must implement
1034      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1035      *
1036      * Emits a {Transfer} event.
1037      */
1038     function safeTransferFrom(
1039         address from,
1040         address to,
1041         uint256 tokenId,
1042         bytes memory _data
1043     ) public virtual override {
1044         transferFrom(from, to, tokenId);
1045         if (to.code.length != 0)
1046             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1047                 revert TransferToNonERC721ReceiverImplementer();
1048             }
1049     }
1050 
1051     /**
1052      * @dev Hook that is called before a set of serially-ordered token IDs
1053      * are about to be transferred. This includes minting.
1054      * And also called before burning one token.
1055      *
1056      * `startTokenId` - the first token ID to be transferred.
1057      * `quantity` - the amount to be transferred.
1058      *
1059      * Calling conditions:
1060      *
1061      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1062      * transferred to `to`.
1063      * - When `from` is zero, `tokenId` will be minted for `to`.
1064      * - When `to` is zero, `tokenId` will be burned by `from`.
1065      * - `from` and `to` are never both zero.
1066      */
1067     function _beforeTokenTransfers(
1068         address from,
1069         address to,
1070         uint256 startTokenId,
1071         uint256 quantity
1072     ) internal virtual {}
1073 
1074     /**
1075      * @dev Hook that is called after a set of serially-ordered token IDs
1076      * have been transferred. This includes minting.
1077      * And also called after one token has been burned.
1078      *
1079      * `startTokenId` - the first token ID to be transferred.
1080      * `quantity` - the amount to be transferred.
1081      *
1082      * Calling conditions:
1083      *
1084      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1085      * transferred to `to`.
1086      * - When `from` is zero, `tokenId` has been minted for `to`.
1087      * - When `to` is zero, `tokenId` has been burned by `from`.
1088      * - `from` and `to` are never both zero.
1089      */
1090     function _afterTokenTransfers(
1091         address from,
1092         address to,
1093         uint256 startTokenId,
1094         uint256 quantity
1095     ) internal virtual {}
1096 
1097     /**
1098      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1099      *
1100      * `from` - Previous owner of the given token ID.
1101      * `to` - Target address that will receive the token.
1102      * `tokenId` - Token ID to be transferred.
1103      * `_data` - Optional data to send along with the call.
1104      *
1105      * Returns whether the call correctly returned the expected magic value.
1106      */
1107     function _checkContractOnERC721Received(
1108         address from,
1109         address to,
1110         uint256 tokenId,
1111         bytes memory _data
1112     ) private returns (bool) {
1113         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1114             bytes4 retval
1115         ) {
1116             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1117         } catch (bytes memory reason) {
1118             if (reason.length == 0) {
1119                 revert TransferToNonERC721ReceiverImplementer();
1120             } else {
1121                 assembly {
1122                     revert(add(32, reason), mload(reason))
1123                 }
1124             }
1125         }
1126     }
1127 
1128     // =============================================================
1129     //                        MINT OPERATIONS
1130     // =============================================================
1131 
1132     /**
1133      * @dev Mints `quantity` tokens and transfers them to `to`.
1134      *
1135      * Requirements:
1136      *
1137      * - `to` cannot be the zero address.
1138      * - `quantity` must be greater than 0.
1139      *
1140      * Emits a {Transfer} event for each mint.
1141      */
1142     function _mint(address to, uint256 quantity) internal virtual {
1143         uint256 startTokenId = _currentIndex;
1144         if (quantity == 0) revert MintZeroQuantity();
1145 
1146         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1147 
1148         // Overflows are incredibly unrealistic.
1149         // `balance` and `numberMinted` have a maximum limit of 2**64.
1150         // `tokenId` has a maximum limit of 2**256.
1151         unchecked {
1152             // Updates:
1153             // - `balance += quantity`.
1154             // - `numberMinted += quantity`.
1155             //
1156             // We can directly add to the `balance` and `numberMinted`.
1157             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1158 
1159             // Updates:
1160             // - `address` to the owner.
1161             // - `startTimestamp` to the timestamp of minting.
1162             // - `burned` to `false`.
1163             // - `nextInitialized` to `quantity == 1`.
1164             _packedOwnerships[startTokenId] = _packOwnershipData(
1165                 to,
1166                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1167             );
1168 
1169             uint256 toMasked;
1170             uint256 end = startTokenId + quantity;
1171 
1172             // Use assembly to loop and emit the `Transfer` event for gas savings.
1173             assembly {
1174                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1175                 toMasked := and(to, _BITMASK_ADDRESS)
1176                 // Emit the `Transfer` event.
1177                 log4(
1178                     0, // Start of data (0, since no data).
1179                     0, // End of data (0, since no data).
1180                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1181                     0, // `address(0)`.
1182                     toMasked, // `to`.
1183                     startTokenId // `tokenId`.
1184                 )
1185 
1186                 for {
1187                     let tokenId := add(startTokenId, 1)
1188                 } iszero(eq(tokenId, end)) {
1189                     tokenId := add(tokenId, 1)
1190                 } {
1191                     // Emit the `Transfer` event. Similar to above.
1192                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1193                 }
1194             }
1195             if (toMasked == 0) revert MintToZeroAddress();
1196 
1197             _currentIndex = end;
1198         }
1199         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1200     }
1201 
1202     /**
1203      * @dev Mints `quantity` tokens and transfers them to `to`.
1204      *
1205      * This function is intended for efficient minting only during contract creation.
1206      *
1207      * It emits only one {ConsecutiveTransfer} as defined in
1208      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1209      * instead of a sequence of {Transfer} event(s).
1210      *
1211      * Calling this function outside of contract creation WILL make your contract
1212      * non-compliant with the ERC721 standard.
1213      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1214      * {ConsecutiveTransfer} event is only permissible during contract creation.
1215      *
1216      * Requirements:
1217      *
1218      * - `to` cannot be the zero address.
1219      * - `quantity` must be greater than 0.
1220      *
1221      * Emits a {ConsecutiveTransfer} event.
1222      */
1223     function _mintERC2309(address to, uint256 quantity) internal virtual {
1224         uint256 startTokenId = _currentIndex;
1225         if (to == address(0)) revert MintToZeroAddress();
1226         if (quantity == 0) revert MintZeroQuantity();
1227         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1228 
1229         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1230 
1231         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1232         unchecked {
1233             // Updates:
1234             // - `balance += quantity`.
1235             // - `numberMinted += quantity`.
1236             //
1237             // We can directly add to the `balance` and `numberMinted`.
1238             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1239 
1240             // Updates:
1241             // - `address` to the owner.
1242             // - `startTimestamp` to the timestamp of minting.
1243             // - `burned` to `false`.
1244             // - `nextInitialized` to `quantity == 1`.
1245             _packedOwnerships[startTokenId] = _packOwnershipData(
1246                 to,
1247                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1248             );
1249 
1250             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1251 
1252             _currentIndex = startTokenId + quantity;
1253         }
1254         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1255     }
1256 
1257     /**
1258      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1259      *
1260      * Requirements:
1261      *
1262      * - If `to` refers to a smart contract, it must implement
1263      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1264      * - `quantity` must be greater than 0.
1265      *
1266      * See {_mint}.
1267      *
1268      * Emits a {Transfer} event for each mint.
1269      */
1270     function _safeMint(
1271         address to,
1272         uint256 quantity,
1273         bytes memory _data
1274     ) internal virtual {
1275         _mint(to, quantity);
1276 
1277         unchecked {
1278             if (to.code.length != 0) {
1279                 uint256 end = _currentIndex;
1280                 uint256 index = end - quantity;
1281                 do {
1282                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1283                         revert TransferToNonERC721ReceiverImplementer();
1284                     }
1285                 } while (index < end);
1286                 // Reentrancy protection.
1287                 if (_currentIndex != end) revert();
1288             }
1289         }
1290     }
1291 
1292     /**
1293      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1294      */
1295     function _safeMint(address to, uint256 quantity) internal virtual {
1296         _safeMint(to, quantity, '');
1297     }
1298 
1299     // =============================================================
1300     //                        BURN OPERATIONS
1301     // =============================================================
1302 
1303     /**
1304      * @dev Equivalent to `_burn(tokenId, false)`.
1305      */
1306     function _burn(uint256 tokenId) internal virtual {
1307         _burn(tokenId, false);
1308     }
1309 
1310     /**
1311      * @dev Destroys `tokenId`.
1312      * The approval is cleared when the token is burned.
1313      *
1314      * Requirements:
1315      *
1316      * - `tokenId` must exist.
1317      *
1318      * Emits a {Transfer} event.
1319      */
1320     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1321         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1322 
1323         address from = address(uint160(prevOwnershipPacked));
1324 
1325         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1326 
1327         if (approvalCheck) {
1328             // The nested ifs save around 20+ gas over a compound boolean condition.
1329             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1330                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1331         }
1332 
1333         _beforeTokenTransfers(from, address(0), tokenId, 1);
1334 
1335         // Clear approvals from the previous owner.
1336         assembly {
1337             if approvedAddress {
1338                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1339                 sstore(approvedAddressSlot, 0)
1340             }
1341         }
1342 
1343         // Underflow of the sender's balance is impossible because we check for
1344         // ownership above and the recipient's balance can't realistically overflow.
1345         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1346         unchecked {
1347             // Updates:
1348             // - `balance -= 1`.
1349             // - `numberBurned += 1`.
1350             //
1351             // We can directly decrement the balance, and increment the number burned.
1352             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1353             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1354 
1355             // Updates:
1356             // - `address` to the last owner.
1357             // - `startTimestamp` to the timestamp of burning.
1358             // - `burned` to `true`.
1359             // - `nextInitialized` to `true`.
1360             _packedOwnerships[tokenId] = _packOwnershipData(
1361                 from,
1362                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1363             );
1364 
1365             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1366             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1367                 uint256 nextTokenId = tokenId + 1;
1368                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1369                 if (_packedOwnerships[nextTokenId] == 0) {
1370                     // If the next slot is within bounds.
1371                     if (nextTokenId != _currentIndex) {
1372                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1373                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1374                     }
1375                 }
1376             }
1377         }
1378 
1379         emit Transfer(from, address(0), tokenId);
1380         _afterTokenTransfers(from, address(0), tokenId, 1);
1381 
1382         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1383         unchecked {
1384             _burnCounter++;
1385         }
1386     }
1387 
1388     // =============================================================
1389     //                     EXTRA DATA OPERATIONS
1390     // =============================================================
1391 
1392     /**
1393      * @dev Directly sets the extra data for the ownership data `index`.
1394      */
1395     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1396         uint256 packed = _packedOwnerships[index];
1397         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1398         uint256 extraDataCasted;
1399         // Cast `extraData` with assembly to avoid redundant masking.
1400         assembly {
1401             extraDataCasted := extraData
1402         }
1403         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1404         _packedOwnerships[index] = packed;
1405     }
1406 
1407     /**
1408      * @dev Called during each token transfer to set the 24bit `extraData` field.
1409      * Intended to be overridden by the cosumer contract.
1410      *
1411      * `previousExtraData` - the value of `extraData` before transfer.
1412      *
1413      * Calling conditions:
1414      *
1415      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1416      * transferred to `to`.
1417      * - When `from` is zero, `tokenId` will be minted for `to`.
1418      * - When `to` is zero, `tokenId` will be burned by `from`.
1419      * - `from` and `to` are never both zero.
1420      */
1421     function _extraData(
1422         address from,
1423         address to,
1424         uint24 previousExtraData
1425     ) internal view virtual returns (uint24) {}
1426 
1427     /**
1428      * @dev Returns the next extra data for the packed ownership data.
1429      * The returned result is shifted into position.
1430      */
1431     function _nextExtraData(
1432         address from,
1433         address to,
1434         uint256 prevOwnershipPacked
1435     ) private view returns (uint256) {
1436         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1437         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1438     }
1439 
1440     // =============================================================
1441     //                       OTHER OPERATIONS
1442     // =============================================================
1443 
1444     /**
1445      * @dev Returns the message sender (defaults to `msg.sender`).
1446      *
1447      * If you are writing GSN compatible contracts, you need to override this function.
1448      */
1449     function _msgSenderERC721A() internal view virtual returns (address) {
1450         return msg.sender;
1451     }
1452 
1453     /**
1454      * @dev Converts a uint256 to its ASCII string decimal representation.
1455      */
1456     function _toString(uint256 value) internal pure virtual returns (string memory ptr) {
1457         assembly {
1458             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1459             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1460             // We will need 1 32-byte word to store the length,
1461             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1462             ptr := add(mload(0x40), 128)
1463             // Update the free memory pointer to allocate.
1464             mstore(0x40, ptr)
1465 
1466             // Cache the end of the memory to calculate the length later.
1467             let end := ptr
1468 
1469             // We write the string from the rightmost digit to the leftmost digit.
1470             // The following is essentially a do-while loop that also handles the zero case.
1471             // Costs a bit more than early returning for the zero case,
1472             // but cheaper in terms of deployment and overall runtime costs.
1473             for {
1474                 // Initialize and perform the first pass without check.
1475                 let temp := value
1476                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1477                 ptr := sub(ptr, 1)
1478                 // Write the character to the pointer.
1479                 // The ASCII index of the '0' character is 48.
1480                 mstore8(ptr, add(48, mod(temp, 10)))
1481                 temp := div(temp, 10)
1482             } temp {
1483                 // Keep dividing `temp` until zero.
1484                 temp := div(temp, 10)
1485             } {
1486                 // Body of the for loop.
1487                 ptr := sub(ptr, 1)
1488                 mstore8(ptr, add(48, mod(temp, 10)))
1489             }
1490 
1491             let length := sub(end, ptr)
1492             // Move the pointer 32 bytes leftwards to make room for the length.
1493             ptr := sub(ptr, 32)
1494             // Store the length.
1495             mstore(ptr, length)
1496         }
1497     }
1498 }
1499 
1500 // File: contracts/OneMintPass.sol
1501 
1502 pragma solidity ^0.8.7;
1503 
1504 
1505 
1506 contract OneMintCreatorPass is ERC721A, Ownable {
1507   string private baseURI = "";
1508   bool public souldbound = true;
1509   bool public open = true;
1510   uint256 public constant cost = 0 ether;
1511   uint256 public constant maxPerMint = 1;
1512   uint256 public constant maxPerWallet = 1;
1513 
1514   constructor() ERC721A("OneMint Creator Pass", "OMCP") {}
1515 
1516   /**
1517    * @dev Intentional unused argument
1518    */
1519   function mint(uint256 _count) external payable {
1520     require(msg.sender == tx.origin);
1521     require(open);
1522     require(balanceOf(msg.sender) == 0);
1523 
1524     _mint(msg.sender, 1);
1525   }
1526 
1527   function airdrop(address[] memory _addresses) public onlyOwner {
1528     for (uint256 i = 0; i < _addresses.length; i++) {
1529       _mint(_addresses[i], 1);
1530     }
1531   }
1532 
1533   function _startTokenId() internal view virtual override returns (uint256) {
1534     return 1;
1535   }
1536 
1537   function _baseURI() internal view virtual override returns (string memory) {
1538     return baseURI;
1539   }
1540 
1541   function setBaseURI(string memory _uri) public onlyOwner {
1542     baseURI = _uri;
1543   }
1544 
1545   function setSouldbound(bool _soulbound) public onlyOwner {
1546     souldbound = _soulbound;
1547   }
1548 
1549   function setOpen(bool _open) public onlyOwner {
1550     open = _open;
1551   }
1552 
1553   function supply() public view returns (uint256) {
1554     return totalSupply();
1555   }
1556 
1557   function _beforeTokenTransfers(
1558     address from,
1559     address _to,
1560     uint256 _startTokenId,
1561     uint256 _quantity
1562   ) internal virtual override {
1563     if (from != address(0)) {
1564       require(!souldbound, "Soulbound Token");
1565     }
1566   }
1567 }