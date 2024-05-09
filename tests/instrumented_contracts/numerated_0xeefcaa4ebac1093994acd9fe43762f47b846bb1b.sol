1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
5 
6 /*
7               __                     
8  _ __ ___    / _|   ___   _ __   ___   _ ___
9 | '_ ` _ \  | |_   / _ \ | '__| / __| | __  |
10 | | | | | | |  _| |  __/ | |    \__ \  __/ /
11 |_| |_| |_| |_|    \___| |_|    |___/ |_____'
12                                      
13 */
14 
15 pragma solidity ^0.8.0;
16 
17 /**
18  * @dev Provides information about the current execution context, including the
19  * sender of the transaction and its data. While these are generally available
20  * via msg.sender and msg.data, they should not be accessed in such a direct
21  * manner, since when dealing with meta-transactions the account sending and
22  * paying for execution may not be the actual sender (as far as an application
23  * is concerned).
24  *
25  * This contract is only required for intermediate, library-like contracts.
26  */
27 abstract contract Context {
28     function _msgSender() internal view virtual returns (address) {
29         return msg.sender;
30     }
31 
32     function _msgData() internal view virtual returns (bytes calldata) {
33         return msg.data;
34     }
35 }
36 
37 // File: @openzeppelin/contracts/access/Ownable.sol
38 
39 
40 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
41 
42 pragma solidity ^0.8.0;
43 
44 
45 /**
46  * @dev Contract module which provides a basic access control mechanism, where
47  * there is an account (an owner) that can be granted exclusive access to
48  * specific functions.
49  *
50  * By default, the owner account will be the one that deploys the contract. This
51  * can later be changed with {transferOwnership}.
52  *
53  * This module is used through inheritance. It will make available the modifier
54  * `onlyOwner`, which can be applied to your functions to restrict their use to
55  * the owner.
56  */
57 abstract contract Ownable is Context {
58     address private _owner;
59 
60     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
61 
62     /**
63      * @dev Initializes the contract setting the deployer as the initial owner.
64      */
65     constructor() {
66         _transferOwnership(_msgSender());
67     }
68 
69     /**
70      * @dev Throws if called by any account other than the owner.
71      */
72     modifier onlyOwner() {
73         _checkOwner();
74         _;
75     }
76 
77     /**
78      * @dev Returns the address of the current owner.
79      */
80     function owner() public view virtual returns (address) {
81         return _owner;
82     }
83 
84     /**
85      * @dev Throws if the sender is not the owner.
86      */
87     function _checkOwner() internal view virtual {
88         require(owner() == _msgSender(), "Ownable: caller is not the owner");
89     }
90 
91     /**
92      * @dev Leaves the contract without owner. It will not be possible to call
93      * `onlyOwner` functions anymore. Can only be called by the current owner.
94      *
95      * NOTE: Renouncing ownership will leave the contract without an owner,
96      * thereby removing any functionality that is only available to the owner.
97      */
98     function renounceOwnership() public virtual onlyOwner {
99         _transferOwnership(address(0));
100     }
101 
102     /**
103      * @dev Transfers ownership of the contract to a new account (`newOwner`).
104      * Can only be called by the current owner.
105      */
106     function transferOwnership(address newOwner) public virtual onlyOwner {
107         require(newOwner != address(0), "Ownable: new owner is the zero address");
108         _transferOwnership(newOwner);
109     }
110 
111     /**
112      * @dev Transfers ownership of the contract to a new account (`newOwner`).
113      * Internal function without access restriction.
114      */
115     function _transferOwnership(address newOwner) internal virtual {
116         address oldOwner = _owner;
117         _owner = newOwner;
118         emit OwnershipTransferred(oldOwner, newOwner);
119     }
120 }
121 
122 // File: erc721a/contracts/IERC721A.sol
123 
124 
125 // ERC721A Contracts v4.2.2
126 // Creator: Chiru Labs
127 
128 pragma solidity ^0.8.4;
129 
130 /**
131  * @dev Interface of ERC721A.
132  */
133 interface IERC721A {
134     /**
135      * The caller must own the token or be an approved operator.
136      */
137     error ApprovalCallerNotOwnerNorApproved();
138 
139     /**
140      * The token does not exist.
141      */
142     error ApprovalQueryForNonexistentToken();
143 
144     /**
145      * The caller cannot approve to their own address.
146      */
147     error ApproveToCaller();
148 
149     /**
150      * Cannot query the balance for the zero address.
151      */
152     error BalanceQueryForZeroAddress();
153 
154     /**
155      * Cannot mint to the zero address.
156      */
157     error MintToZeroAddress();
158 
159     /**
160      * The quantity of tokens minted must be more than zero.
161      */
162     error MintZeroQuantity();
163 
164     /**
165      * The token does not exist.
166      */
167     error OwnerQueryForNonexistentToken();
168 
169     /**
170      * The caller must own the token or be an approved operator.
171      */
172     error TransferCallerNotOwnerNorApproved();
173 
174     /**
175      * The token must be owned by `from`.
176      */
177     error TransferFromIncorrectOwner();
178 
179     /**
180      * Cannot safely transfer to a contract that does not implement the
181      * ERC721Receiver interface.
182      */
183     error TransferToNonERC721ReceiverImplementer();
184 
185     /**
186      * Cannot transfer to the zero address.
187      */
188     error TransferToZeroAddress();
189 
190     /**
191      * The token does not exist.
192      */
193     error URIQueryForNonexistentToken();
194 
195     /**
196      * The `quantity` minted with ERC2309 exceeds the safety limit.
197      */
198     error MintERC2309QuantityExceedsLimit();
199 
200     /**
201      * The `extraData` cannot be set on an unintialized ownership slot.
202      */
203     error OwnershipNotInitializedForExtraData();
204 
205     // =============================================================
206     //                            STRUCTS
207     // =============================================================
208 
209     struct TokenOwnership {
210         // The address of the owner.
211         address addr;
212         // Stores the start time of ownership with minimal overhead for tokenomics.
213         uint64 startTimestamp;
214         // Whether the token has been burned.
215         bool burned;
216         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
217         uint24 extraData;
218     }
219 
220     // =============================================================
221     //                         TOKEN COUNTERS
222     // =============================================================
223 
224     /**
225      * @dev Returns the total number of tokens in existence.
226      * Burned tokens will reduce the count.
227      * To get the total number of tokens minted, please see {_totalMinted}.
228      */
229     function totalSupply() external view returns (uint256);
230 
231     // =============================================================
232     //                            IERC165
233     // =============================================================
234 
235     /**
236      * @dev Returns true if this contract implements the interface defined by
237      * `interfaceId`. See the corresponding
238      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
239      * to learn more about how these ids are created.
240      *
241      * This function call must use less than 30000 gas.
242      */
243     function supportsInterface(bytes4 interfaceId) external view returns (bool);
244 
245     // =============================================================
246     //                            IERC721
247     // =============================================================
248 
249     /**
250      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
251      */
252     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
253 
254     /**
255      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
256      */
257     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
258 
259     /**
260      * @dev Emitted when `owner` enables or disables
261      * (`approved`) `operator` to manage all of its assets.
262      */
263     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
264 
265     /**
266      * @dev Returns the number of tokens in `owner`'s account.
267      */
268     function balanceOf(address owner) external view returns (uint256 balance);
269 
270     /**
271      * @dev Returns the owner of the `tokenId` token.
272      *
273      * Requirements:
274      *
275      * - `tokenId` must exist.
276      */
277     function ownerOf(uint256 tokenId) external view returns (address owner);
278 
279     /**
280      * @dev Safely transfers `tokenId` token from `from` to `to`,
281      * checking first that contract recipients are aware of the ERC721 protocol
282      * to prevent tokens from being forever locked.
283      *
284      * Requirements:
285      *
286      * - `from` cannot be the zero address.
287      * - `to` cannot be the zero address.
288      * - `tokenId` token must exist and be owned by `from`.
289      * - If the caller is not `from`, it must be have been allowed to move
290      * this token by either {approve} or {setApprovalForAll}.
291      * - If `to` refers to a smart contract, it must implement
292      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
293      *
294      * Emits a {Transfer} event.
295      */
296     function safeTransferFrom(
297         address from,
298         address to,
299         uint256 tokenId,
300         bytes calldata data
301     ) external;
302 
303     /**
304      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
305      */
306     function safeTransferFrom(
307         address from,
308         address to,
309         uint256 tokenId
310     ) external;
311 
312     /**
313      * @dev Transfers `tokenId` from `from` to `to`.
314      *
315      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
316      * whenever possible.
317      *
318      * Requirements:
319      *
320      * - `from` cannot be the zero address.
321      * - `to` cannot be the zero address.
322      * - `tokenId` token must be owned by `from`.
323      * - If the caller is not `from`, it must be approved to move this token
324      * by either {approve} or {setApprovalForAll}.
325      *
326      * Emits a {Transfer} event.
327      */
328     function transferFrom(
329         address from,
330         address to,
331         uint256 tokenId
332     ) external;
333 
334     /**
335      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
336      * The approval is cleared when the token is transferred.
337      *
338      * Only a single account can be approved at a time, so approving the
339      * zero address clears previous approvals.
340      *
341      * Requirements:
342      *
343      * - The caller must own the token or be an approved operator.
344      * - `tokenId` must exist.
345      *
346      * Emits an {Approval} event.
347      */
348     function approve(address to, uint256 tokenId) external;
349 
350     /**
351      * @dev Approve or remove `operator` as an operator for the caller.
352      * Operators can call {transferFrom} or {safeTransferFrom}
353      * for any token owned by the caller.
354      *
355      * Requirements:
356      *
357      * - The `operator` cannot be the caller.
358      *
359      * Emits an {ApprovalForAll} event.
360      */
361     function setApprovalForAll(address operator, bool _approved) external;
362 
363     /**
364      * @dev Returns the account approved for `tokenId` token.
365      *
366      * Requirements:
367      *
368      * - `tokenId` must exist.
369      */
370     function getApproved(uint256 tokenId) external view returns (address operator);
371 
372     /**
373      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
374      *
375      * See {setApprovalForAll}.
376      */
377     function isApprovedForAll(address owner, address operator) external view returns (bool);
378 
379     // =============================================================
380     //                        IERC721Metadata
381     // =============================================================
382 
383     /**
384      * @dev Returns the token collection name.
385      */
386     function name() external view returns (string memory);
387 
388     /**
389      * @dev Returns the token collection symbol.
390      */
391     function symbol() external view returns (string memory);
392 
393     /**
394      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
395      */
396     function tokenURI(uint256 tokenId) external view returns (string memory);
397 
398     // =============================================================
399     //                           IERC2309
400     // =============================================================
401 
402     /**
403      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
404      * (inclusive) is transferred from `from` to `to`, as defined in the
405      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
406      *
407      * See {_mintERC2309} for more details.
408      */
409     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
410 }
411 
412 // File: erc721a/contracts/ERC721A.sol
413 
414 
415 // ERC721A Contracts v4.2.2
416 // Creator: Chiru Labs
417 
418 pragma solidity ^0.8.4;
419 
420 
421 /**
422  * @dev Interface of ERC721 token receiver.
423  */
424 interface ERC721A__IERC721Receiver {
425     function onERC721Received(
426         address operator,
427         address from,
428         uint256 tokenId,
429         bytes calldata data
430     ) external returns (bytes4);
431 }
432 
433 /**
434  * @title ERC721A
435  *
436  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
437  * Non-Fungible Token Standard, including the Metadata extension.
438  * Optimized for lower gas during batch mints.
439  *
440  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
441  * starting from `_startTokenId()`.
442  *
443  * Assumptions:
444  *
445  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
446  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
447  */
448 contract ERC721A is IERC721A {
449     // Reference type for token approval.
450     struct TokenApprovalRef {
451         address value;
452     }
453 
454     // =============================================================
455     //                           CONSTANTS
456     // =============================================================
457 
458     // Mask of an entry in packed address data.
459     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
460 
461     // The bit position of `numberMinted` in packed address data.
462     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
463 
464     // The bit position of `numberBurned` in packed address data.
465     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
466 
467     // The bit position of `aux` in packed address data.
468     uint256 private constant _BITPOS_AUX = 192;
469 
470     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
471     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
472 
473     // The bit position of `startTimestamp` in packed ownership.
474     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
475 
476     // The bit mask of the `burned` bit in packed ownership.
477     uint256 private constant _BITMASK_BURNED = 1 << 224;
478 
479     // The bit position of the `nextInitialized` bit in packed ownership.
480     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
481 
482     // The bit mask of the `nextInitialized` bit in packed ownership.
483     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
484 
485     // The bit position of `extraData` in packed ownership.
486     uint256 private constant _BITPOS_EXTRA_DATA = 232;
487 
488     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
489     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
490 
491     // The mask of the lower 160 bits for addresses.
492     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
493 
494     // The maximum `quantity` that can be minted with {_mintERC2309}.
495     // This limit is to prevent overflows on the address data entries.
496     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
497     // is required to cause an overflow, which is unrealistic.
498     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
499 
500     // The `Transfer` event signature is given by:
501     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
502     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
503         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
504 
505     // =============================================================
506     //                            STORAGE
507     // =============================================================
508 
509     // The next token ID to be minted.
510     uint256 private _currentIndex;
511 
512     // The number of tokens burned.
513     uint256 private _burnCounter;
514 
515     // Token name
516     string private _name;
517 
518     // Token symbol
519     string private _symbol;
520 
521     // Mapping from token ID to ownership details
522     // An empty struct value does not necessarily mean the token is unowned.
523     // See {_packedOwnershipOf} implementation for details.
524     //
525     // Bits Layout:
526     // - [0..159]   `addr`
527     // - [160..223] `startTimestamp`
528     // - [224]      `burned`
529     // - [225]      `nextInitialized`
530     // - [232..255] `extraData`
531     mapping(uint256 => uint256) private _packedOwnerships;
532 
533     // Mapping owner address to address data.
534     //
535     // Bits Layout:
536     // - [0..63]    `balance`
537     // - [64..127]  `numberMinted`
538     // - [128..191] `numberBurned`
539     // - [192..255] `aux`
540     mapping(address => uint256) private _packedAddressData;
541 
542     // Mapping from token ID to approved address.
543     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
544 
545     // Mapping from owner to operator approvals
546     mapping(address => mapping(address => bool)) private _operatorApprovals;
547 
548     // =============================================================
549     //                          CONSTRUCTOR
550     // =============================================================
551 
552     constructor(string memory name_, string memory symbol_) {
553         _name = name_;
554         _symbol = symbol_;
555         _currentIndex = _startTokenId();
556     }
557 
558     // =============================================================
559     //                   TOKEN COUNTING OPERATIONS
560     // =============================================================
561 
562     /**
563      * @dev Returns the starting token ID.
564      * To change the starting token ID, please override this function.
565      */
566     function _startTokenId() internal view virtual returns (uint256) {
567         return 0;
568     }
569 
570     /**
571      * @dev Returns the next token ID to be minted.
572      */
573     function _nextTokenId() internal view virtual returns (uint256) {
574         return _currentIndex;
575     }
576 
577     /**
578      * @dev Returns the total number of tokens in existence.
579      * Burned tokens will reduce the count.
580      * To get the total number of tokens minted, please see {_totalMinted}.
581      */
582     function totalSupply() public view virtual override returns (uint256) {
583         // Counter underflow is impossible as _burnCounter cannot be incremented
584         // more than `_currentIndex - _startTokenId()` times.
585         unchecked {
586             return _currentIndex - _burnCounter - _startTokenId();
587         }
588     }
589 
590     /**
591      * @dev Returns the total amount of tokens minted in the contract.
592      */
593     function _totalMinted() internal view virtual returns (uint256) {
594         // Counter underflow is impossible as `_currentIndex` does not decrement,
595         // and it is initialized to `_startTokenId()`.
596         unchecked {
597             return _currentIndex - _startTokenId();
598         }
599     }
600 
601     /**
602      * @dev Returns the total number of tokens burned.
603      */
604     function _totalBurned() internal view virtual returns (uint256) {
605         return _burnCounter;
606     }
607 
608     // =============================================================
609     //                    ADDRESS DATA OPERATIONS
610     // =============================================================
611 
612     /**
613      * @dev Returns the number of tokens in `owner`'s account.
614      */
615     function balanceOf(address owner) public view virtual override returns (uint256) {
616         if (owner == address(0)) revert BalanceQueryForZeroAddress();
617         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
618     }
619 
620     /**
621      * Returns the number of tokens minted by `owner`.
622      */
623     function _numberMinted(address owner) internal view returns (uint256) {
624         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
625     }
626 
627     /**
628      * Returns the number of tokens burned by or on behalf of `owner`.
629      */
630     function _numberBurned(address owner) internal view returns (uint256) {
631         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
632     }
633 
634     /**
635      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
636      */
637     function _getAux(address owner) internal view returns (uint64) {
638         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
639     }
640 
641     /**
642      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
643      * If there are multiple variables, please pack them into a uint64.
644      */
645     function _setAux(address owner, uint64 aux) internal virtual {
646         uint256 packed = _packedAddressData[owner];
647         uint256 auxCasted;
648         // Cast `aux` with assembly to avoid redundant masking.
649         assembly {
650             auxCasted := aux
651         }
652         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
653         _packedAddressData[owner] = packed;
654     }
655 
656     // =============================================================
657     //                            IERC165
658     // =============================================================
659 
660     /**
661      * @dev Returns true if this contract implements the interface defined by
662      * `interfaceId`. See the corresponding
663      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
664      * to learn more about how these ids are created.
665      *
666      * This function call must use less than 30000 gas.
667      */
668     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
669         // The interface IDs are constants representing the first 4 bytes
670         // of the XOR of all function selectors in the interface.
671         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
672         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
673         return
674             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
675             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
676             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
677     }
678 
679     // =============================================================
680     //                        IERC721Metadata
681     // =============================================================
682 
683     /**
684      * @dev Returns the token collection name.
685      */
686     function name() public view virtual override returns (string memory) {
687         return _name;
688     }
689 
690     /**
691      * @dev Returns the token collection symbol.
692      */
693     function symbol() public view virtual override returns (string memory) {
694         return _symbol;
695     }
696 
697     /**
698      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
699      */
700     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
701         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
702 
703         string memory baseURI = _baseURI();
704         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
705     }
706 
707     /**
708      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
709      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
710      * by default, it can be overridden in child contracts.
711      */
712     function _baseURI() internal view virtual returns (string memory) {
713         return '';
714     }
715 
716     // =============================================================
717     //                     OWNERSHIPS OPERATIONS
718     // =============================================================
719 
720     /**
721      * @dev Returns the owner of the `tokenId` token.
722      *
723      * Requirements:
724      *
725      * - `tokenId` must exist.
726      */
727     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
728         return address(uint160(_packedOwnershipOf(tokenId)));
729     }
730 
731     /**
732      * @dev Gas spent here starts off proportional to the maximum mint batch size.
733      * It gradually moves to O(1) as tokens get transferred around over time.
734      */
735     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
736         return _unpackedOwnership(_packedOwnershipOf(tokenId));
737     }
738 
739     /**
740      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
741      */
742     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
743         return _unpackedOwnership(_packedOwnerships[index]);
744     }
745 
746     /**
747      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
748      */
749     function _initializeOwnershipAt(uint256 index) internal virtual {
750         if (_packedOwnerships[index] == 0) {
751             _packedOwnerships[index] = _packedOwnershipOf(index);
752         }
753     }
754 
755     /**
756      * Returns the packed ownership data of `tokenId`.
757      */
758     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
759         uint256 curr = tokenId;
760 
761         unchecked {
762             if (_startTokenId() <= curr)
763                 if (curr < _currentIndex) {
764                     uint256 packed = _packedOwnerships[curr];
765                     // If not burned.
766                     if (packed & _BITMASK_BURNED == 0) {
767                         // Invariant:
768                         // There will always be an initialized ownership slot
769                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
770                         // before an unintialized ownership slot
771                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
772                         // Hence, `curr` will not underflow.
773                         //
774                         // We can directly compare the packed value.
775                         // If the address is zero, packed will be zero.
776                         while (packed == 0) {
777                             packed = _packedOwnerships[--curr];
778                         }
779                         return packed;
780                     }
781                 }
782         }
783         revert OwnerQueryForNonexistentToken();
784     }
785 
786     /**
787      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
788      */
789     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
790         ownership.addr = address(uint160(packed));
791         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
792         ownership.burned = packed & _BITMASK_BURNED != 0;
793         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
794     }
795 
796     /**
797      * @dev Packs ownership data into a single uint256.
798      */
799     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
800         assembly {
801             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
802             owner := and(owner, _BITMASK_ADDRESS)
803             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
804             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
805         }
806     }
807 
808     /**
809      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
810      */
811     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
812         // For branchless setting of the `nextInitialized` flag.
813         assembly {
814             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
815             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
816         }
817     }
818 
819     // =============================================================
820     //                      APPROVAL OPERATIONS
821     // =============================================================
822 
823     /**
824      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
825      * The approval is cleared when the token is transferred.
826      *
827      * Only a single account can be approved at a time, so approving the
828      * zero address clears previous approvals.
829      *
830      * Requirements:
831      *
832      * - The caller must own the token or be an approved operator.
833      * - `tokenId` must exist.
834      *
835      * Emits an {Approval} event.
836      */
837     function approve(address to, uint256 tokenId) public virtual override {
838         address owner = ownerOf(tokenId);
839 
840         if (_msgSenderERC721A() != owner)
841             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
842                 revert ApprovalCallerNotOwnerNorApproved();
843             }
844 
845         _tokenApprovals[tokenId].value = to;
846         emit Approval(owner, to, tokenId);
847     }
848 
849     /**
850      * @dev Returns the account approved for `tokenId` token.
851      *
852      * Requirements:
853      *
854      * - `tokenId` must exist.
855      */
856     function getApproved(uint256 tokenId) public view virtual override returns (address) {
857         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
858 
859         return _tokenApprovals[tokenId].value;
860     }
861 
862     /**
863      * @dev Approve or remove `operator` as an operator for the caller.
864      * Operators can call {transferFrom} or {safeTransferFrom}
865      * for any token owned by the caller.
866      *
867      * Requirements:
868      *
869      * - The `operator` cannot be the caller.
870      *
871      * Emits an {ApprovalForAll} event.
872      */
873     function setApprovalForAll(address operator, bool approved) public virtual override {
874         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
875 
876         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
877         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
878     }
879 
880     /**
881      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
882      *
883      * See {setApprovalForAll}.
884      */
885     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
886         return _operatorApprovals[owner][operator];
887     }
888 
889     /**
890      * @dev Returns whether `tokenId` exists.
891      *
892      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
893      *
894      * Tokens start existing when they are minted. See {_mint}.
895      */
896     function _exists(uint256 tokenId) internal view virtual returns (bool) {
897         return
898             _startTokenId() <= tokenId &&
899             tokenId < _currentIndex && // If within bounds,
900             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
901     }
902 
903     /**
904      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
905      */
906     function _isSenderApprovedOrOwner(
907         address approvedAddress,
908         address owner,
909         address msgSender
910     ) private pure returns (bool result) {
911         assembly {
912             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
913             owner := and(owner, _BITMASK_ADDRESS)
914             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
915             msgSender := and(msgSender, _BITMASK_ADDRESS)
916             // `msgSender == owner || msgSender == approvedAddress`.
917             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
918         }
919     }
920 
921     /**
922      * @dev Returns the storage slot and value for the approved address of `tokenId`.
923      */
924     function _getApprovedSlotAndAddress(uint256 tokenId)
925         private
926         view
927         returns (uint256 approvedAddressSlot, address approvedAddress)
928     {
929         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
930         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
931         assembly {
932             approvedAddressSlot := tokenApproval.slot
933             approvedAddress := sload(approvedAddressSlot)
934         }
935     }
936 
937     // =============================================================
938     //                      TRANSFER OPERATIONS
939     // =============================================================
940 
941     /**
942      * @dev Transfers `tokenId` from `from` to `to`.
943      *
944      * Requirements:
945      *
946      * - `from` cannot be the zero address.
947      * - `to` cannot be the zero address.
948      * - `tokenId` token must be owned by `from`.
949      * - If the caller is not `from`, it must be approved to move this token
950      * by either {approve} or {setApprovalForAll}.
951      *
952      * Emits a {Transfer} event.
953      */
954     function transferFrom(
955         address from,
956         address to,
957         uint256 tokenId
958     ) public virtual override {
959         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
960 
961         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
962 
963         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
964 
965         // The nested ifs save around 20+ gas over a compound boolean condition.
966         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
967             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
968 
969         if (to == address(0)) revert TransferToZeroAddress();
970 
971         _beforeTokenTransfers(from, to, tokenId, 1);
972 
973         // Clear approvals from the previous owner.
974         assembly {
975             if approvedAddress {
976                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
977                 sstore(approvedAddressSlot, 0)
978             }
979         }
980 
981         // Underflow of the sender's balance is impossible because we check for
982         // ownership above and the recipient's balance can't realistically overflow.
983         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
984         unchecked {
985             // We can directly increment and decrement the balances.
986             --_packedAddressData[from]; // Updates: `balance -= 1`.
987             ++_packedAddressData[to]; // Updates: `balance += 1`.
988 
989             // Updates:
990             // - `address` to the next owner.
991             // - `startTimestamp` to the timestamp of transfering.
992             // - `burned` to `false`.
993             // - `nextInitialized` to `true`.
994             _packedOwnerships[tokenId] = _packOwnershipData(
995                 to,
996                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
997             );
998 
999             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1000             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1001                 uint256 nextTokenId = tokenId + 1;
1002                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1003                 if (_packedOwnerships[nextTokenId] == 0) {
1004                     // If the next slot is within bounds.
1005                     if (nextTokenId != _currentIndex) {
1006                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1007                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1008                     }
1009                 }
1010             }
1011         }
1012 
1013         emit Transfer(from, to, tokenId);
1014         _afterTokenTransfers(from, to, tokenId, 1);
1015     }
1016 
1017     /**
1018      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1019      */
1020     function safeTransferFrom(
1021         address from,
1022         address to,
1023         uint256 tokenId
1024     ) public virtual override {
1025         safeTransferFrom(from, to, tokenId, '');
1026     }
1027 
1028     /**
1029      * @dev Safely transfers `tokenId` token from `from` to `to`.
1030      *
1031      * Requirements:
1032      *
1033      * - `from` cannot be the zero address.
1034      * - `to` cannot be the zero address.
1035      * - `tokenId` token must exist and be owned by `from`.
1036      * - If the caller is not `from`, it must be approved to move this token
1037      * by either {approve} or {setApprovalForAll}.
1038      * - If `to` refers to a smart contract, it must implement
1039      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1040      *
1041      * Emits a {Transfer} event.
1042      */
1043     function safeTransferFrom(
1044         address from,
1045         address to,
1046         uint256 tokenId,
1047         bytes memory _data
1048     ) public virtual override {
1049         transferFrom(from, to, tokenId);
1050         if (to.code.length != 0)
1051             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1052                 revert TransferToNonERC721ReceiverImplementer();
1053             }
1054     }
1055 
1056     /**
1057      * @dev Hook that is called before a set of serially-ordered token IDs
1058      * are about to be transferred. This includes minting.
1059      * And also called before burning one token.
1060      *
1061      * `startTokenId` - the first token ID to be transferred.
1062      * `quantity` - the amount to be transferred.
1063      *
1064      * Calling conditions:
1065      *
1066      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1067      * transferred to `to`.
1068      * - When `from` is zero, `tokenId` will be minted for `to`.
1069      * - When `to` is zero, `tokenId` will be burned by `from`.
1070      * - `from` and `to` are never both zero.
1071      */
1072     function _beforeTokenTransfers(
1073         address from,
1074         address to,
1075         uint256 startTokenId,
1076         uint256 quantity
1077     ) internal virtual {}
1078 
1079     /**
1080      * @dev Hook that is called after a set of serially-ordered token IDs
1081      * have been transferred. This includes minting.
1082      * And also called after one token has been burned.
1083      *
1084      * `startTokenId` - the first token ID to be transferred.
1085      * `quantity` - the amount to be transferred.
1086      *
1087      * Calling conditions:
1088      *
1089      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1090      * transferred to `to`.
1091      * - When `from` is zero, `tokenId` has been minted for `to`.
1092      * - When `to` is zero, `tokenId` has been burned by `from`.
1093      * - `from` and `to` are never both zero.
1094      */
1095     function _afterTokenTransfers(
1096         address from,
1097         address to,
1098         uint256 startTokenId,
1099         uint256 quantity
1100     ) internal virtual {}
1101 
1102     /**
1103      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1104      *
1105      * `from` - Previous owner of the given token ID.
1106      * `to` - Target address that will receive the token.
1107      * `tokenId` - Token ID to be transferred.
1108      * `_data` - Optional data to send along with the call.
1109      *
1110      * Returns whether the call correctly returned the expected magic value.
1111      */
1112     function _checkContractOnERC721Received(
1113         address from,
1114         address to,
1115         uint256 tokenId,
1116         bytes memory _data
1117     ) private returns (bool) {
1118         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1119             bytes4 retval
1120         ) {
1121             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1122         } catch (bytes memory reason) {
1123             if (reason.length == 0) {
1124                 revert TransferToNonERC721ReceiverImplementer();
1125             } else {
1126                 assembly {
1127                     revert(add(32, reason), mload(reason))
1128                 }
1129             }
1130         }
1131     }
1132 
1133     // =============================================================
1134     //                        MINT OPERATIONS
1135     // =============================================================
1136 
1137     /**
1138      * @dev Mints `quantity` tokens and transfers them to `to`.
1139      *
1140      * Requirements:
1141      *
1142      * - `to` cannot be the zero address.
1143      * - `quantity` must be greater than 0.
1144      *
1145      * Emits a {Transfer} event for each mint.
1146      */
1147     function _mint(address to, uint256 quantity) internal virtual {
1148         uint256 startTokenId = _currentIndex;
1149         if (quantity == 0) revert MintZeroQuantity();
1150 
1151         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1152 
1153         // Overflows are incredibly unrealistic.
1154         // `balance` and `numberMinted` have a maximum limit of 2**64.
1155         // `tokenId` has a maximum limit of 2**256.
1156         unchecked {
1157             // Updates:
1158             // - `balance += quantity`.
1159             // - `numberMinted += quantity`.
1160             //
1161             // We can directly add to the `balance` and `numberMinted`.
1162             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1163 
1164             // Updates:
1165             // - `address` to the owner.
1166             // - `startTimestamp` to the timestamp of minting.
1167             // - `burned` to `false`.
1168             // - `nextInitialized` to `quantity == 1`.
1169             _packedOwnerships[startTokenId] = _packOwnershipData(
1170                 to,
1171                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1172             );
1173 
1174             uint256 toMasked;
1175             uint256 end = startTokenId + quantity;
1176 
1177             // Use assembly to loop and emit the `Transfer` event for gas savings.
1178             assembly {
1179                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1180                 toMasked := and(to, _BITMASK_ADDRESS)
1181                 // Emit the `Transfer` event.
1182                 log4(
1183                     0, // Start of data (0, since no data).
1184                     0, // End of data (0, since no data).
1185                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1186                     0, // `address(0)`.
1187                     toMasked, // `to`.
1188                     startTokenId // `tokenId`.
1189                 )
1190 
1191                 for {
1192                     let tokenId := add(startTokenId, 1)
1193                 } iszero(eq(tokenId, end)) {
1194                     tokenId := add(tokenId, 1)
1195                 } {
1196                     // Emit the `Transfer` event. Similar to above.
1197                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1198                 }
1199             }
1200             if (toMasked == 0) revert MintToZeroAddress();
1201 
1202             _currentIndex = end;
1203         }
1204         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1205     }
1206 
1207     /**
1208      * @dev Mints `quantity` tokens and transfers them to `to`.
1209      *
1210      * This function is intended for efficient minting only during contract creation.
1211      *
1212      * It emits only one {ConsecutiveTransfer} as defined in
1213      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1214      * instead of a sequence of {Transfer} event(s).
1215      *
1216      * Calling this function outside of contract creation WILL make your contract
1217      * non-compliant with the ERC721 standard.
1218      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1219      * {ConsecutiveTransfer} event is only permissible during contract creation.
1220      *
1221      * Requirements:
1222      *
1223      * - `to` cannot be the zero address.
1224      * - `quantity` must be greater than 0.
1225      *
1226      * Emits a {ConsecutiveTransfer} event.
1227      */
1228     function _mintERC2309(address to, uint256 quantity) internal virtual {
1229         uint256 startTokenId = _currentIndex;
1230         if (to == address(0)) revert MintToZeroAddress();
1231         if (quantity == 0) revert MintZeroQuantity();
1232         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1233 
1234         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1235 
1236         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1237         unchecked {
1238             // Updates:
1239             // - `balance += quantity`.
1240             // - `numberMinted += quantity`.
1241             //
1242             // We can directly add to the `balance` and `numberMinted`.
1243             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1244 
1245             // Updates:
1246             // - `address` to the owner.
1247             // - `startTimestamp` to the timestamp of minting.
1248             // - `burned` to `false`.
1249             // - `nextInitialized` to `quantity == 1`.
1250             _packedOwnerships[startTokenId] = _packOwnershipData(
1251                 to,
1252                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1253             );
1254 
1255             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1256 
1257             _currentIndex = startTokenId + quantity;
1258         }
1259         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1260     }
1261 
1262     /**
1263      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1264      *
1265      * Requirements:
1266      *
1267      * - If `to` refers to a smart contract, it must implement
1268      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1269      * - `quantity` must be greater than 0.
1270      *
1271      * See {_mint}.
1272      *
1273      * Emits a {Transfer} event for each mint.
1274      */
1275     function _safeMint(
1276         address to,
1277         uint256 quantity,
1278         bytes memory _data
1279     ) internal virtual {
1280         _mint(to, quantity);
1281 
1282         unchecked {
1283             if (to.code.length != 0) {
1284                 uint256 end = _currentIndex;
1285                 uint256 index = end - quantity;
1286                 do {
1287                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1288                         revert TransferToNonERC721ReceiverImplementer();
1289                     }
1290                 } while (index < end);
1291                 // Reentrancy protection.
1292                 if (_currentIndex != end) revert();
1293             }
1294         }
1295     }
1296 
1297     /**
1298      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1299      */
1300     function _safeMint(address to, uint256 quantity) internal virtual {
1301         _safeMint(to, quantity, '');
1302     }
1303 
1304     // =============================================================
1305     //                        BURN OPERATIONS
1306     // =============================================================
1307 
1308     /**
1309      * @dev Equivalent to `_burn(tokenId, false)`.
1310      */
1311     function _burn(uint256 tokenId) internal virtual {
1312         _burn(tokenId, false);
1313     }
1314 
1315     /**
1316      * @dev Destroys `tokenId`.
1317      * The approval is cleared when the token is burned.
1318      *
1319      * Requirements:
1320      *
1321      * - `tokenId` must exist.
1322      *
1323      * Emits a {Transfer} event.
1324      */
1325     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1326         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1327 
1328         address from = address(uint160(prevOwnershipPacked));
1329 
1330         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1331 
1332         if (approvalCheck) {
1333             // The nested ifs save around 20+ gas over a compound boolean condition.
1334             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1335                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1336         }
1337 
1338         _beforeTokenTransfers(from, address(0), tokenId, 1);
1339 
1340         // Clear approvals from the previous owner.
1341         assembly {
1342             if approvedAddress {
1343                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1344                 sstore(approvedAddressSlot, 0)
1345             }
1346         }
1347 
1348         // Underflow of the sender's balance is impossible because we check for
1349         // ownership above and the recipient's balance can't realistically overflow.
1350         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1351         unchecked {
1352             // Updates:
1353             // - `balance -= 1`.
1354             // - `numberBurned += 1`.
1355             //
1356             // We can directly decrement the balance, and increment the number burned.
1357             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1358             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1359 
1360             // Updates:
1361             // - `address` to the last owner.
1362             // - `startTimestamp` to the timestamp of burning.
1363             // - `burned` to `true`.
1364             // - `nextInitialized` to `true`.
1365             _packedOwnerships[tokenId] = _packOwnershipData(
1366                 from,
1367                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1368             );
1369 
1370             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1371             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1372                 uint256 nextTokenId = tokenId + 1;
1373                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1374                 if (_packedOwnerships[nextTokenId] == 0) {
1375                     // If the next slot is within bounds.
1376                     if (nextTokenId != _currentIndex) {
1377                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1378                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1379                     }
1380                 }
1381             }
1382         }
1383 
1384         emit Transfer(from, address(0), tokenId);
1385         _afterTokenTransfers(from, address(0), tokenId, 1);
1386 
1387         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1388         unchecked {
1389             _burnCounter++;
1390         }
1391     }
1392 
1393     // =============================================================
1394     //                     EXTRA DATA OPERATIONS
1395     // =============================================================
1396 
1397     /**
1398      * @dev Directly sets the extra data for the ownership data `index`.
1399      */
1400     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1401         uint256 packed = _packedOwnerships[index];
1402         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1403         uint256 extraDataCasted;
1404         // Cast `extraData` with assembly to avoid redundant masking.
1405         assembly {
1406             extraDataCasted := extraData
1407         }
1408         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1409         _packedOwnerships[index] = packed;
1410     }
1411 
1412     /**
1413      * @dev Called during each token transfer to set the 24bit `extraData` field.
1414      * Intended to be overridden by the cosumer contract.
1415      *
1416      * `previousExtraData` - the value of `extraData` before transfer.
1417      *
1418      * Calling conditions:
1419      *
1420      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1421      * transferred to `to`.
1422      * - When `from` is zero, `tokenId` will be minted for `to`.
1423      * - When `to` is zero, `tokenId` will be burned by `from`.
1424      * - `from` and `to` are never both zero.
1425      */
1426     function _extraData(
1427         address from,
1428         address to,
1429         uint24 previousExtraData
1430     ) internal view virtual returns (uint24) {}
1431 
1432     /**
1433      * @dev Returns the next extra data for the packed ownership data.
1434      * The returned result is shifted into position.
1435      */
1436     function _nextExtraData(
1437         address from,
1438         address to,
1439         uint256 prevOwnershipPacked
1440     ) private view returns (uint256) {
1441         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1442         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1443     }
1444 
1445     // =============================================================
1446     //                       OTHER OPERATIONS
1447     // =============================================================
1448 
1449     /**
1450      * @dev Returns the message sender (defaults to `msg.sender`).
1451      *
1452      * If you are writing GSN compatible contracts, you need to override this function.
1453      */
1454     function _msgSenderERC721A() internal view virtual returns (address) {
1455         return msg.sender;
1456     }
1457 
1458     /**
1459      * @dev Converts a uint256 to its ASCII string decimal representation.
1460      */
1461     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1462         assembly {
1463             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1464             // but we allocate 0x80 bytes to keep the free memory pointer 32-byte word aliged.
1465             // We will need 1 32-byte word to store the length,
1466             // and 3 32-byte words to store a maximum of 78 digits. Total: 0x20 + 3 * 0x20 = 0x80.
1467             str := add(mload(0x40), 0x80)
1468             // Update the free memory pointer to allocate.
1469             mstore(0x40, str)
1470 
1471             // Cache the end of the memory to calculate the length later.
1472             let end := str
1473 
1474             // We write the string from rightmost digit to leftmost digit.
1475             // The following is essentially a do-while loop that also handles the zero case.
1476             // prettier-ignore
1477             for { let temp := value } 1 {} {
1478                 str := sub(str, 1)
1479                 // Write the character to the pointer.
1480                 // The ASCII index of the '0' character is 48.
1481                 mstore8(str, add(48, mod(temp, 10)))
1482                 // Keep dividing `temp` until zero.
1483                 temp := div(temp, 10)
1484                 // prettier-ignore
1485                 if iszero(temp) { break }
1486             }
1487 
1488             let length := sub(end, str)
1489             // Move the pointer 32 bytes leftwards to make room for the length.
1490             str := sub(str, 0x20)
1491             // Store the length.
1492             mstore(str, length)
1493         }
1494     }
1495 }
1496 
1497 // File: mfers2.sol
1498 
1499 
1500 pragma solidity >=0.8.10 <0.9.0;
1501 
1502 
1503 
1504 contract mfers2 is ERC721A, Ownable {
1505     constructor(string memory baseURI) ERC721A("mfer2", "MFER2") {
1506         _baseTokenURI = baseURI;
1507         _safeMint(0x9B1eE9375B71c816936186b94022918f2D3B16A3, 21);
1508     }
1509 
1510     string _baseTokenURI;
1511 
1512     // its free , every wallet limits 10 
1513     function mint(uint256 quantity) public {
1514         require(totalSupply() + quantity <= 10021, "All mfer2 minted");
1515         require(_numberMinted(msg.sender) + quantity <= 10, "Cant mint more than 10 mfer2 per wallet");
1516         _safeMint(msg.sender, quantity);
1517     }
1518 
1519     function _baseURI() internal view virtual override returns (string memory) {
1520         return _baseTokenURI;
1521     }
1522 
1523     function setBaseURI(string memory baseURI) public onlyOwner {
1524         _baseTokenURI = baseURI;
1525     }
1526 }