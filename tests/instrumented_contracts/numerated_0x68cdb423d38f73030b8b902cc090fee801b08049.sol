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
116 // ERC721A Contracts v4.2.0
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
403 // File: erc721a/contracts/ERC721A.sol
404 
405 
406 // ERC721A Contracts v4.2.0
407 // Creator: Chiru Labs
408 
409 pragma solidity ^0.8.4;
410 
411 
412 /**
413  * @dev Interface of ERC721 token receiver.
414  */
415 interface ERC721A__IERC721Receiver {
416     function onERC721Received(
417         address operator,
418         address from,
419         uint256 tokenId,
420         bytes calldata data
421     ) external returns (bytes4);
422 }
423 
424 /**
425  * @title ERC721A
426  *
427  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
428  * Non-Fungible Token Standard, including the Metadata extension.
429  * Optimized for lower gas during batch mints.
430  *
431  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
432  * starting from `_startTokenId()`.
433  *
434  * Assumptions:
435  *
436  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
437  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
438  */
439 contract ERC721A is IERC721A {
440     // Reference type for token approval.
441     struct TokenApprovalRef {
442         address value;
443     }
444 
445     // =============================================================
446     //                           CONSTANTS
447     // =============================================================
448 
449     // Mask of an entry in packed address data.
450     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
451 
452     // The bit position of `numberMinted` in packed address data.
453     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
454 
455     // The bit position of `numberBurned` in packed address data.
456     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
457 
458     // The bit position of `aux` in packed address data.
459     uint256 private constant _BITPOS_AUX = 192;
460 
461     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
462     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
463 
464     // The bit position of `startTimestamp` in packed ownership.
465     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
466 
467     // The bit mask of the `burned` bit in packed ownership.
468     uint256 private constant _BITMASK_BURNED = 1 << 224;
469 
470     // The bit position of the `nextInitialized` bit in packed ownership.
471     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
472 
473     // The bit mask of the `nextInitialized` bit in packed ownership.
474     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
475 
476     // The bit position of `extraData` in packed ownership.
477     uint256 private constant _BITPOS_EXTRA_DATA = 232;
478 
479     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
480     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
481 
482     // The mask of the lower 160 bits for addresses.
483     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
484 
485     // The maximum `quantity` that can be minted with {_mintERC2309}.
486     // This limit is to prevent overflows on the address data entries.
487     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
488     // is required to cause an overflow, which is unrealistic.
489     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
490 
491     // The `Transfer` event signature is given by:
492     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
493     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
494         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
495 
496     // =============================================================
497     //                            STORAGE
498     // =============================================================
499 
500     // The next token ID to be minted.
501     uint256 private _currentIndex;
502 
503     // The number of tokens burned.
504     uint256 private _burnCounter;
505 
506     // Token name
507     string private _name;
508 
509     // Token symbol
510     string private _symbol;
511 
512     // Mapping from token ID to ownership details
513     // An empty struct value does not necessarily mean the token is unowned.
514     // See {_packedOwnershipOf} implementation for details.
515     //
516     // Bits Layout:
517     // - [0..159]   `addr`
518     // - [160..223] `startTimestamp`
519     // - [224]      `burned`
520     // - [225]      `nextInitialized`
521     // - [232..255] `extraData`
522     mapping(uint256 => uint256) private _packedOwnerships;
523 
524     // Mapping owner address to address data.
525     //
526     // Bits Layout:
527     // - [0..63]    `balance`
528     // - [64..127]  `numberMinted`
529     // - [128..191] `numberBurned`
530     // - [192..255] `aux`
531     mapping(address => uint256) private _packedAddressData;
532 
533     // Mapping from token ID to approved address.
534     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
535 
536     // Mapping from owner to operator approvals
537     mapping(address => mapping(address => bool)) private _operatorApprovals;
538 
539     // =============================================================
540     //                          CONSTRUCTOR
541     // =============================================================
542 
543     constructor(string memory name_, string memory symbol_) {
544         _name = name_;
545         _symbol = symbol_;
546         _currentIndex = _startTokenId();
547     }
548 
549     // =============================================================
550     //                   TOKEN COUNTING OPERATIONS
551     // =============================================================
552 
553     /**
554      * @dev Returns the starting token ID.
555      * To change the starting token ID, please override this function.
556      */
557     function _startTokenId() internal view virtual returns (uint256) {
558         return 0;
559     }
560 
561     /**
562      * @dev Returns the next token ID to be minted.
563      */
564     function _nextTokenId() internal view virtual returns (uint256) {
565         return _currentIndex;
566     }
567 
568     /**
569      * @dev Returns the total number of tokens in existence.
570      * Burned tokens will reduce the count.
571      * To get the total number of tokens minted, please see {_totalMinted}.
572      */
573     function totalSupply() public view virtual override returns (uint256) {
574         // Counter underflow is impossible as _burnCounter cannot be incremented
575         // more than `_currentIndex - _startTokenId()` times.
576         unchecked {
577             return _currentIndex - _burnCounter - _startTokenId();
578         }
579     }
580 
581     /**
582      * @dev Returns the total amount of tokens minted in the contract.
583      */
584     function _totalMinted() internal view virtual returns (uint256) {
585         // Counter underflow is impossible as `_currentIndex` does not decrement,
586         // and it is initialized to `_startTokenId()`.
587         unchecked {
588             return _currentIndex - _startTokenId();
589         }
590     }
591 
592     /**
593      * @dev Returns the total number of tokens burned.
594      */
595     function _totalBurned() internal view virtual returns (uint256) {
596         return _burnCounter;
597     }
598 
599     // =============================================================
600     //                    ADDRESS DATA OPERATIONS
601     // =============================================================
602 
603     /**
604      * @dev Returns the number of tokens in `owner`'s account.
605      */
606     function balanceOf(address owner) public view virtual override returns (uint256) {
607         if (owner == address(0)) revert BalanceQueryForZeroAddress();
608         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
609     }
610 
611     /**
612      * Returns the number of tokens minted by `owner`.
613      */
614     function _numberMinted(address owner) internal view returns (uint256) {
615         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
616     }
617 
618     /**
619      * Returns the number of tokens burned by or on behalf of `owner`.
620      */
621     function _numberBurned(address owner) internal view returns (uint256) {
622         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
623     }
624 
625     /**
626      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
627      */
628     function _getAux(address owner) internal view returns (uint64) {
629         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
630     }
631 
632     /**
633      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
634      * If there are multiple variables, please pack them into a uint64.
635      */
636     function _setAux(address owner, uint64 aux) internal virtual {
637         uint256 packed = _packedAddressData[owner];
638         uint256 auxCasted;
639         // Cast `aux` with assembly to avoid redundant masking.
640         assembly {
641             auxCasted := aux
642         }
643         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
644         _packedAddressData[owner] = packed;
645     }
646 
647     // =============================================================
648     //                            IERC165
649     // =============================================================
650 
651     /**
652      * @dev Returns true if this contract implements the interface defined by
653      * `interfaceId`. See the corresponding
654      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
655      * to learn more about how these ids are created.
656      *
657      * This function call must use less than 30000 gas.
658      */
659     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
660         // The interface IDs are constants representing the first 4 bytes
661         // of the XOR of all function selectors in the interface.
662         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
663         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
664         return
665             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
666             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
667             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
668     }
669 
670     // =============================================================
671     //                        IERC721Metadata
672     // =============================================================
673 
674     /**
675      * @dev Returns the token collection name.
676      */
677     function name() public view virtual override returns (string memory) {
678         return _name;
679     }
680 
681     /**
682      * @dev Returns the token collection symbol.
683      */
684     function symbol() public view virtual override returns (string memory) {
685         return _symbol;
686     }
687 
688     /**
689      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
690      */
691     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
692         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
693 
694         string memory baseURI = _baseURI();
695         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
696     }
697 
698     /**
699      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
700      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
701      * by default, it can be overridden in child contracts.
702      */
703     function _baseURI() internal view virtual returns (string memory) {
704         return '';
705     }
706 
707     // =============================================================
708     //                     OWNERSHIPS OPERATIONS
709     // =============================================================
710 
711     /**
712      * @dev Returns the owner of the `tokenId` token.
713      *
714      * Requirements:
715      *
716      * - `tokenId` must exist.
717      */
718     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
719         return address(uint160(_packedOwnershipOf(tokenId)));
720     }
721 
722     /**
723      * @dev Gas spent here starts off proportional to the maximum mint batch size.
724      * It gradually moves to O(1) as tokens get transferred around over time.
725      */
726     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
727         return _unpackedOwnership(_packedOwnershipOf(tokenId));
728     }
729 
730     /**
731      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
732      */
733     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
734         return _unpackedOwnership(_packedOwnerships[index]);
735     }
736 
737     /**
738      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
739      */
740     function _initializeOwnershipAt(uint256 index) internal virtual {
741         if (_packedOwnerships[index] == 0) {
742             _packedOwnerships[index] = _packedOwnershipOf(index);
743         }
744     }
745 
746     /**
747      * Returns the packed ownership data of `tokenId`.
748      */
749     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
750         uint256 curr = tokenId;
751 
752         unchecked {
753             if (_startTokenId() <= curr)
754                 if (curr < _currentIndex) {
755                     uint256 packed = _packedOwnerships[curr];
756                     // If not burned.
757                     if (packed & _BITMASK_BURNED == 0) {
758                         // Invariant:
759                         // There will always be an initialized ownership slot
760                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
761                         // before an unintialized ownership slot
762                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
763                         // Hence, `curr` will not underflow.
764                         //
765                         // We can directly compare the packed value.
766                         // If the address is zero, packed will be zero.
767                         while (packed == 0) {
768                             packed = _packedOwnerships[--curr];
769                         }
770                         return packed;
771                     }
772                 }
773         }
774         revert OwnerQueryForNonexistentToken();
775     }
776 
777     /**
778      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
779      */
780     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
781         ownership.addr = address(uint160(packed));
782         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
783         ownership.burned = packed & _BITMASK_BURNED != 0;
784         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
785     }
786 
787     /**
788      * @dev Packs ownership data into a single uint256.
789      */
790     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
791         assembly {
792             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
793             owner := and(owner, _BITMASK_ADDRESS)
794             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
795             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
796         }
797     }
798 
799     /**
800      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
801      */
802     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
803         // For branchless setting of the `nextInitialized` flag.
804         assembly {
805             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
806             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
807         }
808     }
809 
810     // =============================================================
811     //                      APPROVAL OPERATIONS
812     // =============================================================
813 
814     /**
815      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
816      * The approval is cleared when the token is transferred.
817      *
818      * Only a single account can be approved at a time, so approving the
819      * zero address clears previous approvals.
820      *
821      * Requirements:
822      *
823      * - The caller must own the token or be an approved operator.
824      * - `tokenId` must exist.
825      *
826      * Emits an {Approval} event.
827      */
828     function approve(address to, uint256 tokenId) public virtual override {
829         address owner = ownerOf(tokenId);
830 
831         if (_msgSenderERC721A() != owner)
832             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
833                 revert ApprovalCallerNotOwnerNorApproved();
834             }
835 
836         _tokenApprovals[tokenId].value = to;
837         emit Approval(owner, to, tokenId);
838     }
839 
840     /**
841      * @dev Returns the account approved for `tokenId` token.
842      *
843      * Requirements:
844      *
845      * - `tokenId` must exist.
846      */
847     function getApproved(uint256 tokenId) public view virtual override returns (address) {
848         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
849 
850         return _tokenApprovals[tokenId].value;
851     }
852 
853     /**
854      * @dev Approve or remove `operator` as an operator for the caller.
855      * Operators can call {transferFrom} or {safeTransferFrom}
856      * for any token owned by the caller.
857      *
858      * Requirements:
859      *
860      * - The `operator` cannot be the caller.
861      *
862      * Emits an {ApprovalForAll} event.
863      */
864     function setApprovalForAll(address operator, bool approved) public virtual override {
865         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
866 
867         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
868         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
869     }
870 
871     /**
872      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
873      *
874      * See {setApprovalForAll}.
875      */
876     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
877         return _operatorApprovals[owner][operator];
878     }
879 
880     /**
881      * @dev Returns whether `tokenId` exists.
882      *
883      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
884      *
885      * Tokens start existing when they are minted. See {_mint}.
886      */
887     function _exists(uint256 tokenId) internal view virtual returns (bool) {
888         return
889             _startTokenId() <= tokenId &&
890             tokenId < _currentIndex && // If within bounds,
891             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
892     }
893 
894     /**
895      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
896      */
897     function _isSenderApprovedOrOwner(
898         address approvedAddress,
899         address owner,
900         address msgSender
901     ) private pure returns (bool result) {
902         assembly {
903             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
904             owner := and(owner, _BITMASK_ADDRESS)
905             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
906             msgSender := and(msgSender, _BITMASK_ADDRESS)
907             // `msgSender == owner || msgSender == approvedAddress`.
908             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
909         }
910     }
911 
912     /**
913      * @dev Returns the storage slot and value for the approved address of `tokenId`.
914      */
915     function _getApprovedSlotAndAddress(uint256 tokenId)
916         private
917         view
918         returns (uint256 approvedAddressSlot, address approvedAddress)
919     {
920         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
921         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
922         assembly {
923             approvedAddressSlot := tokenApproval.slot
924             approvedAddress := sload(approvedAddressSlot)
925         }
926     }
927 
928     // =============================================================
929     //                      TRANSFER OPERATIONS
930     // =============================================================
931 
932     /**
933      * @dev Transfers `tokenId` from `from` to `to`.
934      *
935      * Requirements:
936      *
937      * - `from` cannot be the zero address.
938      * - `to` cannot be the zero address.
939      * - `tokenId` token must be owned by `from`.
940      * - If the caller is not `from`, it must be approved to move this token
941      * by either {approve} or {setApprovalForAll}.
942      *
943      * Emits a {Transfer} event.
944      */
945     function transferFrom(
946         address from,
947         address to,
948         uint256 tokenId
949     ) public virtual override {
950         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
951 
952         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
953 
954         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
955 
956         // The nested ifs save around 20+ gas over a compound boolean condition.
957         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
958             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
959 
960         if (to == address(0)) revert TransferToZeroAddress();
961 
962         _beforeTokenTransfers(from, to, tokenId, 1);
963 
964         // Clear approvals from the previous owner.
965         assembly {
966             if approvedAddress {
967                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
968                 sstore(approvedAddressSlot, 0)
969             }
970         }
971 
972         // Underflow of the sender's balance is impossible because we check for
973         // ownership above and the recipient's balance can't realistically overflow.
974         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
975         unchecked {
976             // We can directly increment and decrement the balances.
977             --_packedAddressData[from]; // Updates: `balance -= 1`.
978             ++_packedAddressData[to]; // Updates: `balance += 1`.
979 
980             // Updates:
981             // - `address` to the next owner.
982             // - `startTimestamp` to the timestamp of transfering.
983             // - `burned` to `false`.
984             // - `nextInitialized` to `true`.
985             _packedOwnerships[tokenId] = _packOwnershipData(
986                 to,
987                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
988             );
989 
990             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
991             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
992                 uint256 nextTokenId = tokenId + 1;
993                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
994                 if (_packedOwnerships[nextTokenId] == 0) {
995                     // If the next slot is within bounds.
996                     if (nextTokenId != _currentIndex) {
997                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
998                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
999                     }
1000                 }
1001             }
1002         }
1003 
1004         emit Transfer(from, to, tokenId);
1005         _afterTokenTransfers(from, to, tokenId, 1);
1006     }
1007 
1008     /**
1009      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1010      */
1011     function safeTransferFrom(
1012         address from,
1013         address to,
1014         uint256 tokenId
1015     ) public virtual override {
1016         safeTransferFrom(from, to, tokenId, '');
1017     }
1018 
1019     /**
1020      * @dev Safely transfers `tokenId` token from `from` to `to`.
1021      *
1022      * Requirements:
1023      *
1024      * - `from` cannot be the zero address.
1025      * - `to` cannot be the zero address.
1026      * - `tokenId` token must exist and be owned by `from`.
1027      * - If the caller is not `from`, it must be approved to move this token
1028      * by either {approve} or {setApprovalForAll}.
1029      * - If `to` refers to a smart contract, it must implement
1030      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1031      *
1032      * Emits a {Transfer} event.
1033      */
1034     function safeTransferFrom(
1035         address from,
1036         address to,
1037         uint256 tokenId,
1038         bytes memory _data
1039     ) public virtual override {
1040         transferFrom(from, to, tokenId);
1041         if (to.code.length != 0)
1042             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1043                 revert TransferToNonERC721ReceiverImplementer();
1044             }
1045     }
1046 
1047     /**
1048      * @dev Hook that is called before a set of serially-ordered token IDs
1049      * are about to be transferred. This includes minting.
1050      * And also called before burning one token.
1051      *
1052      * `startTokenId` - the first token ID to be transferred.
1053      * `quantity` - the amount to be transferred.
1054      *
1055      * Calling conditions:
1056      *
1057      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1058      * transferred to `to`.
1059      * - When `from` is zero, `tokenId` will be minted for `to`.
1060      * - When `to` is zero, `tokenId` will be burned by `from`.
1061      * - `from` and `to` are never both zero.
1062      */
1063     function _beforeTokenTransfers(
1064         address from,
1065         address to,
1066         uint256 startTokenId,
1067         uint256 quantity
1068     ) internal virtual {}
1069 
1070     /**
1071      * @dev Hook that is called after a set of serially-ordered token IDs
1072      * have been transferred. This includes minting.
1073      * And also called after one token has been burned.
1074      *
1075      * `startTokenId` - the first token ID to be transferred.
1076      * `quantity` - the amount to be transferred.
1077      *
1078      * Calling conditions:
1079      *
1080      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1081      * transferred to `to`.
1082      * - When `from` is zero, `tokenId` has been minted for `to`.
1083      * - When `to` is zero, `tokenId` has been burned by `from`.
1084      * - `from` and `to` are never both zero.
1085      */
1086     function _afterTokenTransfers(
1087         address from,
1088         address to,
1089         uint256 startTokenId,
1090         uint256 quantity
1091     ) internal virtual {}
1092 
1093     /**
1094      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1095      *
1096      * `from` - Previous owner of the given token ID.
1097      * `to` - Target address that will receive the token.
1098      * `tokenId` - Token ID to be transferred.
1099      * `_data` - Optional data to send along with the call.
1100      *
1101      * Returns whether the call correctly returned the expected magic value.
1102      */
1103     function _checkContractOnERC721Received(
1104         address from,
1105         address to,
1106         uint256 tokenId,
1107         bytes memory _data
1108     ) private returns (bool) {
1109         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1110             bytes4 retval
1111         ) {
1112             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1113         } catch (bytes memory reason) {
1114             if (reason.length == 0) {
1115                 revert TransferToNonERC721ReceiverImplementer();
1116             } else {
1117                 assembly {
1118                     revert(add(32, reason), mload(reason))
1119                 }
1120             }
1121         }
1122     }
1123 
1124     // =============================================================
1125     //                        MINT OPERATIONS
1126     // =============================================================
1127 
1128     /**
1129      * @dev Mints `quantity` tokens and transfers them to `to`.
1130      *
1131      * Requirements:
1132      *
1133      * - `to` cannot be the zero address.
1134      * - `quantity` must be greater than 0.
1135      *
1136      * Emits a {Transfer} event for each mint.
1137      */
1138     function _mint(address to, uint256 quantity) internal virtual {
1139         uint256 startTokenId = _currentIndex;
1140         if (quantity == 0) revert MintZeroQuantity();
1141 
1142         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1143 
1144         // Overflows are incredibly unrealistic.
1145         // `balance` and `numberMinted` have a maximum limit of 2**64.
1146         // `tokenId` has a maximum limit of 2**256.
1147         unchecked {
1148             // Updates:
1149             // - `balance += quantity`.
1150             // - `numberMinted += quantity`.
1151             //
1152             // We can directly add to the `balance` and `numberMinted`.
1153             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1154 
1155             // Updates:
1156             // - `address` to the owner.
1157             // - `startTimestamp` to the timestamp of minting.
1158             // - `burned` to `false`.
1159             // - `nextInitialized` to `quantity == 1`.
1160             _packedOwnerships[startTokenId] = _packOwnershipData(
1161                 to,
1162                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1163             );
1164 
1165             uint256 toMasked;
1166             uint256 end = startTokenId + quantity;
1167 
1168             // Use assembly to loop and emit the `Transfer` event for gas savings.
1169             assembly {
1170                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1171                 toMasked := and(to, _BITMASK_ADDRESS)
1172                 // Emit the `Transfer` event.
1173                 log4(
1174                     0, // Start of data (0, since no data).
1175                     0, // End of data (0, since no data).
1176                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1177                     0, // `address(0)`.
1178                     toMasked, // `to`.
1179                     startTokenId // `tokenId`.
1180                 )
1181 
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
1452     function _toString(uint256 value) internal pure virtual returns (string memory ptr) {
1453         assembly {
1454             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1455             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1456             // We will need 1 32-byte word to store the length,
1457             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1458             ptr := add(mload(0x40), 128)
1459             // Update the free memory pointer to allocate.
1460             mstore(0x40, ptr)
1461 
1462             // Cache the end of the memory to calculate the length later.
1463             let end := ptr
1464 
1465             // We write the string from the rightmost digit to the leftmost digit.
1466             // The following is essentially a do-while loop that also handles the zero case.
1467             // Costs a bit more than early returning for the zero case,
1468             // but cheaper in terms of deployment and overall runtime costs.
1469             for {
1470                 // Initialize and perform the first pass without check.
1471                 let temp := value
1472                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1473                 ptr := sub(ptr, 1)
1474                 // Write the character to the pointer.
1475                 // The ASCII index of the '0' character is 48.
1476                 mstore8(ptr, add(48, mod(temp, 10)))
1477                 temp := div(temp, 10)
1478             } temp {
1479                 // Keep dividing `temp` until zero.
1480                 temp := div(temp, 10)
1481             } {
1482                 // Body of the for loop.
1483                 ptr := sub(ptr, 1)
1484                 mstore8(ptr, add(48, mod(temp, 10)))
1485             }
1486 
1487             let length := sub(end, ptr)
1488             // Move the pointer 32 bytes leftwards to make room for the length.
1489             ptr := sub(ptr, 32)
1490             // Store the length.
1491             mstore(ptr, length)
1492         }
1493     }
1494 }
1495 
1496 // File: contracts/InEthWeTrust.sol
1497 
1498 
1499 pragma solidity ^0.8.11;
1500 
1501 
1502 
1503 contract InEthWeTrust is ERC721A, Ownable {
1504   
1505   uint256 public mintPrice = 0.004878 ether;
1506 
1507   string _baseTokenURI;
1508 
1509   bool public isActive = false;
1510 
1511   uint256 public MAX_SUPPLY = 4878;
1512   uint256 public constant MAX_FREE_PER_WALLET = 1;
1513   uint256 public maximumAllowedTokensPerPurchase = 10;
1514   uint256 public maximumAllowedTokensPerWallet = 10;
1515 
1516   constructor(string memory baseURI) ERC721A("In Eth We Trust", "IEWT") {
1517     setBaseURI(baseURI);
1518   }
1519 
1520   modifier saleIsOpen {
1521     require(totalSupply() <= MAX_SUPPLY, "Sale has ended.");
1522     _;
1523   }
1524 
1525   function setMaximumAllowedTokens(uint256 _count) public onlyOwner {
1526     maximumAllowedTokensPerPurchase = _count;
1527   }
1528 
1529 
1530   function setMaximumAllowedTokensPerWallet(uint256 _count) public onlyOwner {
1531     maximumAllowedTokensPerWallet = _count;
1532   }
1533 
1534   function setMaxMintSupply(uint256 maxMintSupply) external  onlyOwner {
1535     MAX_SUPPLY = maxMintSupply;
1536   }
1537 
1538 
1539   function setPrice(uint256 _price) public onlyOwner {
1540     mintPrice = _price;
1541   }
1542 
1543   function toggleSaleStatus() public onlyOwner {
1544     isActive = !isActive;
1545   }
1546 
1547   function setBaseURI(string memory baseURI) public onlyOwner {
1548     _baseTokenURI = baseURI;
1549   }
1550 
1551 
1552   function _baseURI() internal view virtual override returns (string memory) {
1553     return _baseTokenURI;
1554   }
1555 
1556   function mint(uint256 _count) public payable saleIsOpen {
1557     uint256 mintIndex = totalSupply();
1558     
1559     require(balanceOf(msg.sender) + _count <= maximumAllowedTokensPerWallet, "Max holding cap reached.");
1560     require( _count <= maximumAllowedTokensPerPurchase, "Exceeds maximum allowed tokens");
1561     require(isActive, "Sale is not active currently.");
1562     require(mintIndex + _count <= MAX_SUPPLY, "Total supply exceeded.");
1563 
1564     if(balanceOf(msg.sender) == 0 && _count > 1) {
1565         uint256 discountPrice = _count - 1;
1566         require(msg.value >= mintPrice * discountPrice, "Insufficient ETH amount sent.");
1567     }
1568 
1569 
1570     if(balanceOf(msg.sender) >= 1) {
1571       require(msg.value >= mintPrice * _count, "Insufficient ETH amount sent.");
1572     }
1573    
1574     _safeMint(msg.sender, _count);
1575   }
1576 
1577   function withdraw() external onlyOwner {
1578     uint balance = address(this).balance;
1579     payable(owner()).transfer(balance);
1580   }
1581 }