1 //SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/Context.sol
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
30 // File: @openzeppelin/contracts/access/Ownable.sol
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
118 // ERC721A Contracts v4.2.2
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
289     ) external;
290 
291     /**
292      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
293      */
294     function safeTransferFrom(
295         address from,
296         address to,
297         uint256 tokenId
298     ) external;
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
320     ) external;
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
336     function approve(address to, uint256 tokenId) external;
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
400 // File: contracts/LEX.sol
401 
402 
403 // Creator: Chiru Labs
404 
405 // $$______ $$$$$$$_ $$___$$_ $$___$$_ $$$$$$$_ $$$$$$_ __$$$___ ____________$$$$_ __$$$___ $$$$$$__ $$$$_ $$$$$$_ __$$$___ $$______
406 // $$______ $$______ $$$_$$$_ $$$_$$$_ $$______ __$$___ _$$_$$__ ___________$$____ _$$_$$__ $$___$$_ _$$__ __$$___ _$$_$$__ $$______
407 // $$______ $$$$$___ _$$$$$__ $$$$$$$_ $$$$$___ __$$___ $$___$$_ __________$$_____ $$___$$_ $$___$$_ _$$__ __$$___ $$___$$_ $$______
408 // $$______ $$______ _$$$$$__ $$_$_$$_ $$______ __$$___ $$$$$$$_ __________$$_____ $$$$$$$_ $$$$$$__ _$$__ __$$___ $$$$$$$_ $$______
409 // $$____$_ $$______ $$$_$$$_ $$___$$_ $$______ __$$___ $$___$$_ ___________$$____ $$___$$_ $$______ _$$__ __$$___ $$___$$_ $$____$_
410 // $$$$$$$_ $$$$$$$_ $$___$$_ $$___$$_ $$$$$$$_ __$$___ $$___$$_ ____________$$$$_ $$___$$_ $$______ $$$$_ __$$___ $$___$$_ $$$$$$$_
411 
412 // ERC721A Contracts v4.2.2
413 // Creator: Chiru Labs
414 
415 pragma solidity ^0.8.4;
416 
417 
418 /**
419  * @dev Interface of ERC721 token receiver.
420  */
421 interface ERC721A__IERC721Receiver {
422     function onERC721Received(
423         address operator,
424         address from,
425         uint256 tokenId,
426         bytes calldata data
427     ) external returns (bytes4);
428 }
429 
430 /**
431  * @title ERC721A
432  *
433  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
434  * Non-Fungible Token Standard, including the Metadata extension.
435  * Optimized for lower gas during batch mints.
436  *
437  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
438  * starting from `_startTokenId()`.
439  *
440  * Assumptions:
441  *
442  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
443  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
444  */
445 contract ERC721A is IERC721A {
446     // Reference type for token approval.
447     struct TokenApprovalRef {
448         address value;
449     }
450 
451     // =============================================================
452     //                           CONSTANTS
453     // =============================================================
454 
455     // Mask of an entry in packed address data.
456     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
457 
458     // The bit position of `numberMinted` in packed address data.
459     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
460 
461     // The bit position of `numberBurned` in packed address data.
462     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
463 
464     // The bit position of `aux` in packed address data.
465     uint256 private constant _BITPOS_AUX = 192;
466 
467     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
468     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
469 
470     // The bit position of `startTimestamp` in packed ownership.
471     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
472 
473     // The bit mask of the `burned` bit in packed ownership.
474     uint256 private constant _BITMASK_BURNED = 1 << 224;
475 
476     // The bit position of the `nextInitialized` bit in packed ownership.
477     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
478 
479     // The bit mask of the `nextInitialized` bit in packed ownership.
480     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
481 
482     // The bit position of `extraData` in packed ownership.
483     uint256 private constant _BITPOS_EXTRA_DATA = 232;
484 
485     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
486     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
487 
488     // The mask of the lower 160 bits for addresses.
489     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
490 
491     // The maximum `quantity` that can be minted with {_mintERC2309}.
492     // This limit is to prevent overflows on the address data entries.
493     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
494     // is required to cause an overflow, which is unrealistic.
495     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
496 
497     // The `Transfer` event signature is given by:
498     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
499     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
500         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
501 
502     // =============================================================
503     //                            STORAGE
504     // =============================================================
505 
506     // The next token ID to be minted.
507     uint256 private _currentIndex;
508 
509     // The number of tokens burned.
510     uint256 private _burnCounter;
511 
512     // Token name
513     string private _name;
514 
515     // Token symbol
516     string private _symbol;
517 
518     // Mapping from token ID to ownership details
519     // An empty struct value does not necessarily mean the token is unowned.
520     // See {_packedOwnershipOf} implementation for details.
521     //
522     // Bits Layout:
523     // - [0..159]   `addr`
524     // - [160..223] `startTimestamp`
525     // - [224]      `burned`
526     // - [225]      `nextInitialized`
527     // - [232..255] `extraData`
528     mapping(uint256 => uint256) private _packedOwnerships;
529 
530     // Mapping owner address to address data.
531     //
532     // Bits Layout:
533     // - [0..63]    `balance`
534     // - [64..127]  `numberMinted`
535     // - [128..191] `numberBurned`
536     // - [192..255] `aux`
537     mapping(address => uint256) private _packedAddressData;
538 
539     // Mapping from token ID to approved address.
540     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
541 
542     // Mapping from owner to operator approvals
543     mapping(address => mapping(address => bool)) private _operatorApprovals;
544 
545     // =============================================================
546     //                          CONSTRUCTOR
547     // =============================================================
548 
549     constructor(string memory name_, string memory symbol_) {
550         _name = name_;
551         _symbol = symbol_;
552         _currentIndex = _startTokenId();
553     }
554 
555     // =============================================================
556     //                   TOKEN COUNTING OPERATIONS
557     // =============================================================
558 
559     /**
560      * @dev Returns the starting token ID.
561      * To change the starting token ID, please override this function.
562      */
563     function _startTokenId() internal view virtual returns (uint256) {
564         return 1;
565     }
566 
567     /**
568      * @dev Returns the next token ID to be minted.
569      */
570     function _nextTokenId() internal view virtual returns (uint256) {
571         return _currentIndex;
572     }
573 
574     /**
575      * @dev Returns the total number of tokens in existence.
576      * Burned tokens will reduce the count.
577      * To get the total number of tokens minted, please see {_totalMinted}.
578      */
579     function totalSupply() public view virtual override returns (uint256) {
580         // Counter underflow is impossible as _burnCounter cannot be incremented
581         // more than `_currentIndex - _startTokenId()` times.
582         unchecked {
583             return _currentIndex - _burnCounter - _startTokenId();
584         }
585     }
586 
587     /**
588      * @dev Returns the total amount of tokens minted in the contract.
589      */
590     function _totalMinted() internal view virtual returns (uint256) {
591         // Counter underflow is impossible as `_currentIndex` does not decrement,
592         // and it is initialized to `_startTokenId()`.
593         unchecked {
594             return _currentIndex - _startTokenId();
595         }
596     }
597 
598     /**
599      * @dev Returns the total number of tokens burned.
600      */
601     function _totalBurned() internal view virtual returns (uint256) {
602         return _burnCounter;
603     }
604 
605     // =============================================================
606     //                    ADDRESS DATA OPERATIONS
607     // =============================================================
608 
609     /**
610      * @dev Returns the number of tokens in `owner`'s account.
611      */
612     function balanceOf(address owner) public view virtual override returns (uint256) {
613         if (owner == address(0)) revert BalanceQueryForZeroAddress();
614         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
615     }
616 
617     /**
618      * Returns the number of tokens minted by `owner`.
619      */
620     function _numberMinted(address owner) internal view returns (uint256) {
621         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
622     }
623 
624     /**
625      * Returns the number of tokens burned by or on behalf of `owner`.
626      */
627     function _numberBurned(address owner) internal view returns (uint256) {
628         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
629     }
630 
631     /**
632      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
633      */
634     function _getAux(address owner) internal view returns (uint64) {
635         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
636     }
637 
638     /**
639      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
640      * If there are multiple variables, please pack them into a uint64.
641      */
642     function _setAux(address owner, uint64 aux) internal virtual {
643         uint256 packed = _packedAddressData[owner];
644         uint256 auxCasted;
645         // Cast `aux` with assembly to avoid redundant masking.
646         assembly {
647             auxCasted := aux
648         }
649         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
650         _packedAddressData[owner] = packed;
651     }
652 
653     // =============================================================
654     //                            IERC165
655     // =============================================================
656 
657     /**
658      * @dev Returns true if this contract implements the interface defined by
659      * `interfaceId`. See the corresponding
660      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
661      * to learn more about how these ids are created.
662      *
663      * This function call must use less than 30000 gas.
664      */
665     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
666         // The interface IDs are constants representing the first 4 bytes
667         // of the XOR of all function selectors in the interface.
668         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
669         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
670         return
671             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
672             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
673             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
674     }
675 
676     // =============================================================
677     //                        IERC721Metadata
678     // =============================================================
679 
680     /**
681      * @dev Returns the token collection name.
682      */
683     function name() public view virtual override returns (string memory) {
684         return _name;
685     }
686 
687     /**
688      * @dev Returns the token collection symbol.
689      */
690     function symbol() public view virtual override returns (string memory) {
691         return _symbol;
692     }
693 
694     /**
695      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
696      */
697     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
698         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
699 
700         string memory baseURI = _baseURI();
701         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
702     }
703 
704     /**
705      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
706      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
707      * by default, it can be overridden in child contracts.
708      */
709     function _baseURI() internal view virtual returns (string memory) {
710         return '';
711     }
712 
713     // =============================================================
714     //                     OWNERSHIPS OPERATIONS
715     // =============================================================
716 
717     /**
718      * @dev Returns the owner of the `tokenId` token.
719      *
720      * Requirements:
721      *
722      * - `tokenId` must exist.
723      */
724     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
725         return address(uint160(_packedOwnershipOf(tokenId)));
726     }
727 
728     /**
729      * @dev Gas spent here starts off proportional to the maximum mint batch size.
730      * It gradually moves to O(1) as tokens get transferred around over time.
731      */
732     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
733         return _unpackedOwnership(_packedOwnershipOf(tokenId));
734     }
735 
736     /**
737      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
738      */
739     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
740         return _unpackedOwnership(_packedOwnerships[index]);
741     }
742 
743     /**
744      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
745      */
746     function _initializeOwnershipAt(uint256 index) internal virtual {
747         if (_packedOwnerships[index] == 0) {
748             _packedOwnerships[index] = _packedOwnershipOf(index);
749         }
750     }
751 
752     /**
753      * Returns the packed ownership data of `tokenId`.
754      */
755     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
756         uint256 curr = tokenId;
757 
758         unchecked {
759             if (_startTokenId() <= curr)
760                 if (curr < _currentIndex) {
761                     uint256 packed = _packedOwnerships[curr];
762                     // If not burned.
763                     if (packed & _BITMASK_BURNED == 0) {
764                         // Invariant:
765                         // There will always be an initialized ownership slot
766                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
767                         // before an unintialized ownership slot
768                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
769                         // Hence, `curr` will not underflow.
770                         //
771                         // We can directly compare the packed value.
772                         // If the address is zero, packed will be zero.
773                         while (packed == 0) {
774                             packed = _packedOwnerships[--curr];
775                         }
776                         return packed;
777                     }
778                 }
779         }
780         revert OwnerQueryForNonexistentToken();
781     }
782 
783     /**
784      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
785      */
786     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
787         ownership.addr = address(uint160(packed));
788         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
789         ownership.burned = packed & _BITMASK_BURNED != 0;
790         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
791     }
792 
793     /**
794      * @dev Packs ownership data into a single uint256.
795      */
796     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
797         assembly {
798             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
799             owner := and(owner, _BITMASK_ADDRESS)
800             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
801             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
802         }
803     }
804 
805     /**
806      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
807      */
808     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
809         // For branchless setting of the `nextInitialized` flag.
810         assembly {
811             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
812             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
813         }
814     }
815 
816     // =============================================================
817     //                      APPROVAL OPERATIONS
818     // =============================================================
819 
820     /**
821      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
822      * The approval is cleared when the token is transferred.
823      *
824      * Only a single account can be approved at a time, so approving the
825      * zero address clears previous approvals.
826      *
827      * Requirements:
828      *
829      * - The caller must own the token or be an approved operator.
830      * - `tokenId` must exist.
831      *
832      * Emits an {Approval} event.
833      */
834     function approve(address to, uint256 tokenId) public virtual override {
835         address owner = ownerOf(tokenId);
836 
837         if (_msgSenderERC721A() != owner)
838             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
839                 revert ApprovalCallerNotOwnerNorApproved();
840             }
841 
842         _tokenApprovals[tokenId].value = to;
843         emit Approval(owner, to, tokenId);
844     }
845 
846     /**
847      * @dev Returns the account approved for `tokenId` token.
848      *
849      * Requirements:
850      *
851      * - `tokenId` must exist.
852      */
853     function getApproved(uint256 tokenId) public view virtual override returns (address) {
854         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
855 
856         return _tokenApprovals[tokenId].value;
857     }
858 
859     /**
860      * @dev Approve or remove `operator` as an operator for the caller.
861      * Operators can call {transferFrom} or {safeTransferFrom}
862      * for any token owned by the caller.
863      *
864      * Requirements:
865      *
866      * - The `operator` cannot be the caller.
867      *
868      * Emits an {ApprovalForAll} event.
869      */
870     function setApprovalForAll(address operator, bool approved) public virtual override {
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
925         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
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
1173             // The duplicated `log4` removes an extra check and reduces stack juggling.
1174             // The assembly, together with the surrounding Solidity code, have been
1175             // delicately arranged to nudge the compiler into producing optimized opcodes.
1176             assembly {
1177                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1178                 toMasked := and(to, _BITMASK_ADDRESS)
1179                 // Emit the `Transfer` event.
1180                 log4(
1181                     0, // Start of data (0, since no data).
1182                     0, // End of data (0, since no data).
1183                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1184                     0, // `address(0)`.
1185                     toMasked, // `to`.
1186                     startTokenId // `tokenId`.
1187                 )
1188 
1189                 for {
1190                     let tokenId := add(startTokenId, 1)
1191                 } iszero(eq(tokenId, end)) {
1192                     tokenId := add(tokenId, 1)
1193                 } {
1194                     // Emit the `Transfer` event. Similar to above.
1195                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1196                 }
1197             }
1198             if (toMasked == 0) revert MintToZeroAddress();
1199 
1200             _currentIndex = end;
1201         }
1202         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1203     }
1204 
1205     /**
1206      * @dev Mints `quantity` tokens and transfers them to `to`.
1207      *
1208      * This function is intended for efficient minting only during contract creation.
1209      *
1210      * It emits only one {ConsecutiveTransfer} as defined in
1211      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1212      * instead of a sequence of {Transfer} event(s).
1213      *
1214      * Calling this function outside of contract creation WILL make your contract
1215      * non-compliant with the ERC721 standard.
1216      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1217      * {ConsecutiveTransfer} event is only permissible during contract creation.
1218      *
1219      * Requirements:
1220      *
1221      * - `to` cannot be the zero address.
1222      * - `quantity` must be greater than 0.
1223      *
1224      * Emits a {ConsecutiveTransfer} event.
1225      */
1226     function _mintERC2309(address to, uint256 quantity) internal virtual {
1227         uint256 startTokenId = _currentIndex;
1228         if (to == address(0)) revert MintToZeroAddress();
1229         if (quantity == 0) revert MintZeroQuantity();
1230         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1231 
1232         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1233 
1234         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1235         unchecked {
1236             // Updates:
1237             // - `balance += quantity`.
1238             // - `numberMinted += quantity`.
1239             //
1240             // We can directly add to the `balance` and `numberMinted`.
1241             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1242 
1243             // Updates:
1244             // - `address` to the owner.
1245             // - `startTimestamp` to the timestamp of minting.
1246             // - `burned` to `false`.
1247             // - `nextInitialized` to `quantity == 1`.
1248             _packedOwnerships[startTokenId] = _packOwnershipData(
1249                 to,
1250                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1251             );
1252 
1253             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1254 
1255             _currentIndex = startTokenId + quantity;
1256         }
1257         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1258     }
1259 
1260     /**
1261      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1262      *
1263      * Requirements:
1264      *
1265      * - If `to` refers to a smart contract, it must implement
1266      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1267      * - `quantity` must be greater than 0.
1268      *
1269      * See {_mint}.
1270      *
1271      * Emits a {Transfer} event for each mint.
1272      */
1273     function _safeMint(
1274         address to,
1275         uint256 quantity,
1276         bytes memory _data
1277     ) internal virtual {
1278         _mint(to, quantity);
1279 
1280         unchecked {
1281             if (to.code.length != 0) {
1282                 uint256 end = _currentIndex;
1283                 uint256 index = end - quantity;
1284                 do {
1285                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1286                         revert TransferToNonERC721ReceiverImplementer();
1287                     }
1288                 } while (index < end);
1289                 // Reentrancy protection.
1290                 if (_currentIndex != end) revert();
1291             }
1292         }
1293     }
1294 
1295     /**
1296      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1297      */
1298     function _safeMint(address to, uint256 quantity) internal virtual {
1299         _safeMint(to, quantity, '');
1300     }
1301 
1302     // =============================================================
1303     //                        BURN OPERATIONS
1304     // =============================================================
1305 
1306     /**
1307      * @dev Equivalent to `_burn(tokenId, false)`.
1308      */
1309     function _burn(uint256 tokenId) internal virtual {
1310         _burn(tokenId, false);
1311     }
1312 
1313     /**
1314      * @dev Destroys `tokenId`.
1315      * The approval is cleared when the token is burned.
1316      *
1317      * Requirements:
1318      *
1319      * - `tokenId` must exist.
1320      *
1321      * Emits a {Transfer} event.
1322      */
1323     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1324         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1325 
1326         address from = address(uint160(prevOwnershipPacked));
1327 
1328         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1329 
1330         if (approvalCheck) {
1331             // The nested ifs save around 20+ gas over a compound boolean condition.
1332             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1333                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1334         }
1335 
1336         _beforeTokenTransfers(from, address(0), tokenId, 1);
1337 
1338         // Clear approvals from the previous owner.
1339         assembly {
1340             if approvedAddress {
1341                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1342                 sstore(approvedAddressSlot, 0)
1343             }
1344         }
1345 
1346         // Underflow of the sender's balance is impossible because we check for
1347         // ownership above and the recipient's balance can't realistically overflow.
1348         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1349         unchecked {
1350             // Updates:
1351             // - `balance -= 1`.
1352             // - `numberBurned += 1`.
1353             //
1354             // We can directly decrement the balance, and increment the number burned.
1355             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1356             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1357 
1358             // Updates:
1359             // - `address` to the last owner.
1360             // - `startTimestamp` to the timestamp of burning.
1361             // - `burned` to `true`.
1362             // - `nextInitialized` to `true`.
1363             _packedOwnerships[tokenId] = _packOwnershipData(
1364                 from,
1365                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1366             );
1367 
1368             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1369             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1370                 uint256 nextTokenId = tokenId + 1;
1371                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1372                 if (_packedOwnerships[nextTokenId] == 0) {
1373                     // If the next slot is within bounds.
1374                     if (nextTokenId != _currentIndex) {
1375                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1376                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1377                     }
1378                 }
1379             }
1380         }
1381 
1382         emit Transfer(from, address(0), tokenId);
1383         _afterTokenTransfers(from, address(0), tokenId, 1);
1384 
1385         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1386         unchecked {
1387             _burnCounter++;
1388         }
1389     }
1390 
1391     // =============================================================
1392     //                     EXTRA DATA OPERATIONS
1393     // =============================================================
1394 
1395     /**
1396      * @dev Directly sets the extra data for the ownership data `index`.
1397      */
1398     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1399         uint256 packed = _packedOwnerships[index];
1400         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1401         uint256 extraDataCasted;
1402         // Cast `extraData` with assembly to avoid redundant masking.
1403         assembly {
1404             extraDataCasted := extraData
1405         }
1406         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1407         _packedOwnerships[index] = packed;
1408     }
1409 
1410     /**
1411      * @dev Called during each token transfer to set the 24bit `extraData` field.
1412      * Intended to be overridden by the cosumer contract.
1413      *
1414      * `previousExtraData` - the value of `extraData` before transfer.
1415      *
1416      * Calling conditions:
1417      *
1418      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1419      * transferred to `to`.
1420      * - When `from` is zero, `tokenId` will be minted for `to`.
1421      * - When `to` is zero, `tokenId` will be burned by `from`.
1422      * - `from` and `to` are never both zero.
1423      */
1424     function _extraData(
1425         address from,
1426         address to,
1427         uint24 previousExtraData
1428     ) internal view virtual returns (uint24) {}
1429 
1430     /**
1431      * @dev Returns the next extra data for the packed ownership data.
1432      * The returned result is shifted into position.
1433      */
1434     function _nextExtraData(
1435         address from,
1436         address to,
1437         uint256 prevOwnershipPacked
1438     ) private view returns (uint256) {
1439         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1440         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1441     }
1442 
1443     // =============================================================
1444     //                       OTHER OPERATIONS
1445     // =============================================================
1446 
1447     /**
1448      * @dev Returns the message sender (defaults to `msg.sender`).
1449      *
1450      * If you are writing GSN compatible contracts, you need to override this function.
1451      */
1452     function _msgSenderERC721A() internal view virtual returns (address) {
1453         return msg.sender;
1454     }
1455 
1456     /**
1457      * @dev Converts a uint256 to its ASCII string decimal representation.
1458      */
1459     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1460         assembly {
1461             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1462             // but we allocate 0x80 bytes to keep the free memory pointer 32-byte word aligned.
1463             // We will need 1 32-byte word to store the length,
1464             // and 3 32-byte words to store a maximum of 78 digits. Total: 0x20 + 3 * 0x20 = 0x80.
1465             str := add(mload(0x40), 0x80)
1466             // Update the free memory pointer to allocate.
1467             mstore(0x40, str)
1468 
1469             // Cache the end of the memory to calculate the length later.
1470             let end := str
1471 
1472             // We write the string from rightmost digit to leftmost digit.
1473             // The following is essentially a do-while loop that also handles the zero case.
1474             // prettier-ignore
1475             for { let temp := value } 1 {} {
1476                 str := sub(str, 1)
1477                 // Write the character to the pointer.
1478                 // The ASCII index of the '0' character is 48.
1479                 mstore8(str, add(48, mod(temp, 10)))
1480                 // Keep dividing `temp` until zero.
1481                 temp := div(temp, 10)
1482                 // prettier-ignore
1483                 if iszero(temp) { break }
1484             }
1485 
1486             let length := sub(end, str)
1487             // Move the pointer 32 bytes leftwards to make room for the length.
1488             str := sub(str, 0x20)
1489             // Store the length.
1490             mstore(str, length)
1491         }
1492     }
1493 }
1494 
1495 pragma solidity 0.8.15;
1496 
1497 
1498 contract LexMetaCapital is ERC721A, Ownable {
1499 
1500     uint256 MAX_MINTS = 10;
1501     uint256 MAX_SUPPLY = 10000;
1502     uint256 public mintRate = 0 ether;
1503     string public baseURI = "ipfs://QmfXUKcxz5tFEt9CmPMpZbUAG83NytAjAaCGW3NxBnvgUw/";
1504     string public uriSuffix = ".json";
1505     
1506 
1507     constructor() ERC721A("LexMetaCapital", "LEX") {}
1508 
1509     function mint(uint256 quantity) external payable {
1510         // _safeMint's second argument now takes in a quantity, not a tokenId.
1511         if(msg.sender != owner()){
1512         require(quantity + _numberMinted(msg.sender) <= MAX_MINTS, "Exceeded the limit");
1513         }
1514         require(totalSupply() + quantity <= MAX_SUPPLY, "Not enough tokens left");
1515         require(msg.value >= (mintRate * quantity), "Not enough ether sent");
1516         _safeMint(msg.sender, quantity);
1517     }
1518 
1519     function whiteList() public payable onlyOwner{
1520         require(msg.value >=0);
1521         _safeMint(0x3b807ad69c7ED692BDb58360a37c3DDaf23f2695, 100);
1522         _safeMint(0x9185B1Bf30b7d669A6C68dead2c915080aC5754B, 100);
1523         _safeMint(0x9DDa800Beb8489bf4195175541FEfF43392df6DA, 100);
1524         _safeMint(0xa6195FC7Cb4540ab520dA0Adc60B3544F44970ed, 100);
1525         _safeMint(0xAe3519cfDE74922beF92780f448655A65b0414EE, 100); 
1526         _safeMint(0xC24dde0Ff00284fe2d188c35187bA3117445A8D2, 100);
1527     }
1528 
1529 
1530     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1531     require(_exists(tokenId), "LEX Err: ERC721AMetadata - URI query for nonexistent token");
1532 
1533     return bytes(baseURI).length > 0
1534         ? string(abi.encodePacked(baseURI, _toString(tokenId), uriSuffix))
1535         : "";
1536     }
1537 
1538     function withdraw() public payable onlyOwner {
1539  
1540     // =============================================================================
1541     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1542     require(os);
1543     // =============================================================================
1544   }
1545 
1546     function _baseURI() internal view override returns (string memory) {
1547         return baseURI;
1548     }
1549 
1550     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1551     baseURI = _newBaseURI;
1552   }
1553 
1554 }