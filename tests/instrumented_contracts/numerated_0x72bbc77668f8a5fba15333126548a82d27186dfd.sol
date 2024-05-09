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
31 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
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
61      * @dev Returns the address of the current owner.
62      */
63     function owner() public view virtual returns (address) {
64         return _owner;
65     }
66 
67     /**
68      * @dev Throws if called by any account other than the owner.
69      */
70     modifier onlyOwner() {
71         require(owner() == _msgSender(), "Ownable: caller is not the owner");
72         _;
73     }
74 
75     /**
76      * @dev Leaves the contract without owner. It will not be possible to call
77      * `onlyOwner` functions anymore. Can only be called by the current owner.
78      *
79      * NOTE: Renouncing ownership will leave the contract without an owner,
80      * thereby removing any functionality that is only available to the owner.
81      */
82     function renounceOwnership() public virtual onlyOwner {
83         _transferOwnership(address(0));
84     }
85 
86     /**
87      * @dev Transfers ownership of the contract to a new account (`newOwner`).
88      * Can only be called by the current owner.
89      */
90     function transferOwnership(address newOwner) public virtual onlyOwner {
91         require(newOwner != address(0), "Ownable: new owner is the zero address");
92         _transferOwnership(newOwner);
93     }
94 
95     /**
96      * @dev Transfers ownership of the contract to a new account (`newOwner`).
97      * Internal function without access restriction.
98      */
99     function _transferOwnership(address newOwner) internal virtual {
100         address oldOwner = _owner;
101         _owner = newOwner;
102         emit OwnershipTransferred(oldOwner, newOwner);
103     }
104 }
105 
106 // File: erc721a/contracts/IERC721A.sol
107 
108 
109 // ERC721A Contracts v4.1.0
110 // Creator: Chiru Labs
111 
112 pragma solidity ^0.8.4;
113 
114 /**
115  * @dev Interface of an ERC721A compliant contract.
116  */
117 interface IERC721A {
118     /**
119      * The caller must own the token or be an approved operator.
120      */
121     error ApprovalCallerNotOwnerNorApproved();
122 
123     /**
124      * The token does not exist.
125      */
126     error ApprovalQueryForNonexistentToken();
127 
128     /**
129      * The caller cannot approve to their own address.
130      */
131     error ApproveToCaller();
132 
133     /**
134      * Cannot query the balance for the zero address.
135      */
136     error BalanceQueryForZeroAddress();
137 
138     /**
139      * Cannot mint to the zero address.
140      */
141     error MintToZeroAddress();
142 
143     /**
144      * The quantity of tokens minted must be more than zero.
145      */
146     error MintZeroQuantity();
147 
148     /**
149      * The token does not exist.
150      */
151     error OwnerQueryForNonexistentToken();
152 
153     /**
154      * The caller must own the token or be an approved operator.
155      */
156     error TransferCallerNotOwnerNorApproved();
157 
158     /**
159      * The token must be owned by `from`.
160      */
161     error TransferFromIncorrectOwner();
162 
163     /**
164      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
165      */
166     error TransferToNonERC721ReceiverImplementer();
167 
168     /**
169      * Cannot transfer to the zero address.
170      */
171     error TransferToZeroAddress();
172 
173     /**
174      * The token does not exist.
175      */
176     error URIQueryForNonexistentToken();
177 
178     /**
179      * The `quantity` minted with ERC2309 exceeds the safety limit.
180      */
181     error MintERC2309QuantityExceedsLimit();
182 
183     /**
184      * The `extraData` cannot be set on an unintialized ownership slot.
185      */
186     error OwnershipNotInitializedForExtraData();
187 
188     struct TokenOwnership {
189         // The address of the owner.
190         address addr;
191         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
192         uint64 startTimestamp;
193         // Whether the token has been burned.
194         bool burned;
195         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
196         uint24 extraData;
197     }
198 
199     /**
200      * @dev Returns the total amount of tokens stored by the contract.
201      *
202      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
203      */
204     function totalSupply() external view returns (uint256);
205 
206     // ==============================
207     //            IERC165
208     // ==============================
209 
210     /**
211      * @dev Returns true if this contract implements the interface defined by
212      * `interfaceId`. See the corresponding
213      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
214      * to learn more about how these ids are created.
215      *
216      * This function call must use less than 30 000 gas.
217      */
218     function supportsInterface(bytes4 interfaceId) external view returns (bool);
219 
220     // ==============================
221     //            IERC721
222     // ==============================
223 
224     /**
225      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
226      */
227     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
228 
229     /**
230      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
231      */
232     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
233 
234     /**
235      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
236      */
237     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
238 
239     /**
240      * @dev Returns the number of tokens in ``owner``'s account.
241      */
242     function balanceOf(address owner) external view returns (uint256 balance);
243 
244     /**
245      * @dev Returns the owner of the `tokenId` token.
246      *
247      * Requirements:
248      *
249      * - `tokenId` must exist.
250      */
251     function ownerOf(uint256 tokenId) external view returns (address owner);
252 
253     /**
254      * @dev Safely transfers `tokenId` token from `from` to `to`.
255      *
256      * Requirements:
257      *
258      * - `from` cannot be the zero address.
259      * - `to` cannot be the zero address.
260      * - `tokenId` token must exist and be owned by `from`.
261      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
262      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
263      *
264      * Emits a {Transfer} event.
265      */
266     function safeTransferFrom(
267         address from,
268         address to,
269         uint256 tokenId,
270         bytes calldata data
271     ) external;
272 
273     /**
274      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
275      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
276      *
277      * Requirements:
278      *
279      * - `from` cannot be the zero address.
280      * - `to` cannot be the zero address.
281      * - `tokenId` token must exist and be owned by `from`.
282      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
283      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
284      *
285      * Emits a {Transfer} event.
286      */
287     function safeTransferFrom(
288         address from,
289         address to,
290         uint256 tokenId
291     ) external;
292 
293     /**
294      * @dev Transfers `tokenId` token from `from` to `to`.
295      *
296      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
297      *
298      * Requirements:
299      *
300      * - `from` cannot be the zero address.
301      * - `to` cannot be the zero address.
302      * - `tokenId` token must be owned by `from`.
303      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
304      *
305      * Emits a {Transfer} event.
306      */
307     function transferFrom(
308         address from,
309         address to,
310         uint256 tokenId
311     ) external;
312 
313     /**
314      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
315      * The approval is cleared when the token is transferred.
316      *
317      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
318      *
319      * Requirements:
320      *
321      * - The caller must own the token or be an approved operator.
322      * - `tokenId` must exist.
323      *
324      * Emits an {Approval} event.
325      */
326     function approve(address to, uint256 tokenId) external;
327 
328     /**
329      * @dev Approve or remove `operator` as an operator for the caller.
330      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
331      *
332      * Requirements:
333      *
334      * - The `operator` cannot be the caller.
335      *
336      * Emits an {ApprovalForAll} event.
337      */
338     function setApprovalForAll(address operator, bool _approved) external;
339 
340     /**
341      * @dev Returns the account approved for `tokenId` token.
342      *
343      * Requirements:
344      *
345      * - `tokenId` must exist.
346      */
347     function getApproved(uint256 tokenId) external view returns (address operator);
348 
349     /**
350      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
351      *
352      * See {setApprovalForAll}
353      */
354     function isApprovedForAll(address owner, address operator) external view returns (bool);
355 
356     // ==============================
357     //        IERC721Metadata
358     // ==============================
359 
360     /**
361      * @dev Returns the token collection name.
362      */
363     function name() external view returns (string memory);
364 
365     /**
366      * @dev Returns the token collection symbol.
367      */
368     function symbol() external view returns (string memory);
369 
370     /**
371      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
372      */
373     function tokenURI(uint256 tokenId) external view returns (string memory);
374 
375     // ==============================
376     //            IERC2309
377     // ==============================
378 
379     /**
380      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
381      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
382      */
383     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
384 }
385 
386 // File: erc721a/contracts/ERC721A.sol
387 
388 
389 // ERC721A Contracts v4.1.0
390 // Creator: Chiru Labs
391 
392 pragma solidity ^0.8.4;
393 
394 
395 /**
396  * @dev ERC721 token receiver interface.
397  */
398 interface ERC721A__IERC721Receiver {
399     function onERC721Received(
400         address operator,
401         address from,
402         uint256 tokenId,
403         bytes calldata data
404     ) external returns (bytes4);
405 }
406 
407 /**
408  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
409  * including the Metadata extension. Built to optimize for lower gas during batch mints.
410  *
411  * Assumes serials are sequentially minted starting at `_startTokenId()`
412  * (defaults to 0, e.g. 0, 1, 2, 3..).
413  *
414  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
415  *
416  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
417  */
418 contract ERC721A is IERC721A {
419     // Mask of an entry in packed address data.
420     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
421 
422     // The bit position of `numberMinted` in packed address data.
423     uint256 private constant BITPOS_NUMBER_MINTED = 64;
424 
425     // The bit position of `numberBurned` in packed address data.
426     uint256 private constant BITPOS_NUMBER_BURNED = 128;
427 
428     // The bit position of `aux` in packed address data.
429     uint256 private constant BITPOS_AUX = 192;
430 
431     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
432     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
433 
434     // The bit position of `startTimestamp` in packed ownership.
435     uint256 private constant BITPOS_START_TIMESTAMP = 160;
436 
437     // The bit mask of the `burned` bit in packed ownership.
438     uint256 private constant BITMASK_BURNED = 1 << 224;
439 
440     // The bit position of the `nextInitialized` bit in packed ownership.
441     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
442 
443     // The bit mask of the `nextInitialized` bit in packed ownership.
444     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
445 
446     // The bit position of `extraData` in packed ownership.
447     uint256 private constant BITPOS_EXTRA_DATA = 232;
448 
449     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
450     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
451 
452     // The mask of the lower 160 bits for addresses.
453     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
454 
455     // The maximum `quantity` that can be minted with `_mintERC2309`.
456     // This limit is to prevent overflows on the address data entries.
457     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
458     // is required to cause an overflow, which is unrealistic.
459     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
460 
461     // The tokenId of the next token to be minted.
462     uint256 private _currentIndex;
463 
464     // The number of tokens burned.
465     uint256 private _burnCounter;
466 
467     // Token name
468     string private _name;
469 
470     // Token symbol
471     string private _symbol;
472 
473     // Mapping from token ID to ownership details
474     // An empty struct value does not necessarily mean the token is unowned.
475     // See `_packedOwnershipOf` implementation for details.
476     //
477     // Bits Layout:
478     // - [0..159]   `addr`
479     // - [160..223] `startTimestamp`
480     // - [224]      `burned`
481     // - [225]      `nextInitialized`
482     // - [232..255] `extraData`
483     mapping(uint256 => uint256) private _packedOwnerships;
484 
485     // Mapping owner address to address data.
486     //
487     // Bits Layout:
488     // - [0..63]    `balance`
489     // - [64..127]  `numberMinted`
490     // - [128..191] `numberBurned`
491     // - [192..255] `aux`
492     mapping(address => uint256) private _packedAddressData;
493 
494     // Mapping from token ID to approved address.
495     mapping(uint256 => address) private _tokenApprovals;
496 
497     // Mapping from owner to operator approvals
498     mapping(address => mapping(address => bool)) private _operatorApprovals;
499 
500     constructor(string memory name_, string memory symbol_) {
501         _name = name_;
502         _symbol = symbol_;
503         _currentIndex = _startTokenId();
504     }
505 
506     /**
507      * @dev Returns the starting token ID.
508      * To change the starting token ID, please override this function.
509      */
510     function _startTokenId() internal view virtual returns (uint256) {
511         return 0;
512     }
513 
514     /**
515      * @dev Returns the next token ID to be minted.
516      */
517     function _nextTokenId() internal view returns (uint256) {
518         return _currentIndex;
519     }
520 
521     /**
522      * @dev Returns the total number of tokens in existence.
523      * Burned tokens will reduce the count.
524      * To get the total number of tokens minted, please see `_totalMinted`.
525      */
526     function totalSupply() public view override returns (uint256) {
527         // Counter underflow is impossible as _burnCounter cannot be incremented
528         // more than `_currentIndex - _startTokenId()` times.
529         unchecked {
530             return _currentIndex - _burnCounter - _startTokenId();
531         }
532     }
533 
534     /**
535      * @dev Returns the total amount of tokens minted in the contract.
536      */
537     function _totalMinted() internal view returns (uint256) {
538         // Counter underflow is impossible as _currentIndex does not decrement,
539         // and it is initialized to `_startTokenId()`
540         unchecked {
541             return _currentIndex - _startTokenId();
542         }
543     }
544 
545     /**
546      * @dev Returns the total number of tokens burned.
547      */
548     function _totalBurned() internal view returns (uint256) {
549         return _burnCounter;
550     }
551 
552     /**
553      * @dev See {IERC165-supportsInterface}.
554      */
555     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
556         // The interface IDs are constants representing the first 4 bytes of the XOR of
557         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
558         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
559         return
560             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
561             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
562             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
563     }
564 
565     /**
566      * @dev See {IERC721-balanceOf}.
567      */
568     function balanceOf(address owner) public view override returns (uint256) {
569         if (owner == address(0)) revert BalanceQueryForZeroAddress();
570         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
571     }
572 
573     /**
574      * Returns the number of tokens minted by `owner`.
575      */
576     function _numberMinted(address owner) internal view returns (uint256) {
577         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
578     }
579 
580     /**
581      * Returns the number of tokens burned by or on behalf of `owner`.
582      */
583     function _numberBurned(address owner) internal view returns (uint256) {
584         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
585     }
586 
587     /**
588      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
589      */
590     function _getAux(address owner) internal view returns (uint64) {
591         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
592     }
593 
594     /**
595      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
596      * If there are multiple variables, please pack them into a uint64.
597      */
598     function _setAux(address owner, uint64 aux) internal {
599         uint256 packed = _packedAddressData[owner];
600         uint256 auxCasted;
601         // Cast `aux` with assembly to avoid redundant masking.
602         assembly {
603             auxCasted := aux
604         }
605         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
606         _packedAddressData[owner] = packed;
607     }
608 
609     /**
610      * Returns the packed ownership data of `tokenId`.
611      */
612     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
613         uint256 curr = tokenId;
614 
615         unchecked {
616             if (_startTokenId() <= curr)
617                 if (curr < _currentIndex) {
618                     uint256 packed = _packedOwnerships[curr];
619                     // If not burned.
620                     if (packed & BITMASK_BURNED == 0) {
621                         // Invariant:
622                         // There will always be an ownership that has an address and is not burned
623                         // before an ownership that does not have an address and is not burned.
624                         // Hence, curr will not underflow.
625                         //
626                         // We can directly compare the packed value.
627                         // If the address is zero, packed is zero.
628                         while (packed == 0) {
629                             packed = _packedOwnerships[--curr];
630                         }
631                         return packed;
632                     }
633                 }
634         }
635         revert OwnerQueryForNonexistentToken();
636     }
637 
638     /**
639      * Returns the unpacked `TokenOwnership` struct from `packed`.
640      */
641     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
642         ownership.addr = address(uint160(packed));
643         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
644         ownership.burned = packed & BITMASK_BURNED != 0;
645         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
646     }
647 
648     /**
649      * Returns the unpacked `TokenOwnership` struct at `index`.
650      */
651     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
652         return _unpackedOwnership(_packedOwnerships[index]);
653     }
654 
655     /**
656      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
657      */
658     function _initializeOwnershipAt(uint256 index) internal {
659         if (_packedOwnerships[index] == 0) {
660             _packedOwnerships[index] = _packedOwnershipOf(index);
661         }
662     }
663 
664     /**
665      * Gas spent here starts off proportional to the maximum mint batch size.
666      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
667      */
668     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
669         return _unpackedOwnership(_packedOwnershipOf(tokenId));
670     }
671 
672     /**
673      * @dev Packs ownership data into a single uint256.
674      */
675     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
676         assembly {
677             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
678             owner := and(owner, BITMASK_ADDRESS)
679             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
680             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
681         }
682     }
683 
684     /**
685      * @dev See {IERC721-ownerOf}.
686      */
687     function ownerOf(uint256 tokenId) public view override returns (address) {
688         return address(uint160(_packedOwnershipOf(tokenId)));
689     }
690 
691     /**
692      * @dev See {IERC721Metadata-name}.
693      */
694     function name() public view virtual override returns (string memory) {
695         return _name;
696     }
697 
698     /**
699      * @dev See {IERC721Metadata-symbol}.
700      */
701     function symbol() public view virtual override returns (string memory) {
702         return _symbol;
703     }
704 
705     /**
706      * @dev See {IERC721Metadata-tokenURI}.
707      */
708     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
709         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
710 
711         string memory baseURI = _baseURI();
712         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
713     }
714 
715     /**
716      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
717      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
718      * by default, it can be overridden in child contracts.
719      */
720     function _baseURI() internal view virtual returns (string memory) {
721         return '';
722     }
723 
724     /**
725      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
726      */
727     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
728         // For branchless setting of the `nextInitialized` flag.
729         assembly {
730             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
731             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
732         }
733     }
734 
735     /**
736      * @dev See {IERC721-approve}.
737      */
738     function approve(address to, uint256 tokenId) public override {
739         address owner = ownerOf(tokenId);
740 
741         if (_msgSenderERC721A() != owner)
742             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
743                 revert ApprovalCallerNotOwnerNorApproved();
744             }
745 
746         _tokenApprovals[tokenId] = to;
747         emit Approval(owner, to, tokenId);
748     }
749 
750     /**
751      * @dev See {IERC721-getApproved}.
752      */
753     function getApproved(uint256 tokenId) public view override returns (address) {
754         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
755 
756         return _tokenApprovals[tokenId];
757     }
758 
759     /**
760      * @dev See {IERC721-setApprovalForAll}.
761      */
762     function setApprovalForAll(address operator, bool approved) public virtual override {
763         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
764 
765         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
766         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
767     }
768 
769     /**
770      * @dev See {IERC721-isApprovedForAll}.
771      */
772     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
773         return _operatorApprovals[owner][operator];
774     }
775 
776     /**
777      * @dev See {IERC721-safeTransferFrom}.
778      */
779     function safeTransferFrom(
780         address from,
781         address to,
782         uint256 tokenId
783     ) public virtual override {
784         safeTransferFrom(from, to, tokenId, '');
785     }
786 
787     /**
788      * @dev See {IERC721-safeTransferFrom}.
789      */
790     function safeTransferFrom(
791         address from,
792         address to,
793         uint256 tokenId,
794         bytes memory _data
795     ) public virtual override {
796         transferFrom(from, to, tokenId);
797         if (to.code.length != 0)
798             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
799                 revert TransferToNonERC721ReceiverImplementer();
800             }
801     }
802 
803     /**
804      * @dev Returns whether `tokenId` exists.
805      *
806      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
807      *
808      * Tokens start existing when they are minted (`_mint`),
809      */
810     function _exists(uint256 tokenId) internal view returns (bool) {
811         return
812             _startTokenId() <= tokenId &&
813             tokenId < _currentIndex && // If within bounds,
814             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
815     }
816 
817     /**
818      * @dev Equivalent to `_safeMint(to, quantity, '')`.
819      */
820     function _safeMint(address to, uint256 quantity) internal {
821         _safeMint(to, quantity, '');
822     }
823 
824     /**
825      * @dev Safely mints `quantity` tokens and transfers them to `to`.
826      *
827      * Requirements:
828      *
829      * - If `to` refers to a smart contract, it must implement
830      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
831      * - `quantity` must be greater than 0.
832      *
833      * See {_mint}.
834      *
835      * Emits a {Transfer} event for each mint.
836      */
837     function _safeMint(
838         address to,
839         uint256 quantity,
840         bytes memory _data
841     ) internal {
842         _mint(to, quantity);
843 
844         unchecked {
845             if (to.code.length != 0) {
846                 uint256 end = _currentIndex;
847                 uint256 index = end - quantity;
848                 do {
849                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
850                         revert TransferToNonERC721ReceiverImplementer();
851                     }
852                 } while (index < end);
853                 // Reentrancy protection.
854                 if (_currentIndex != end) revert();
855             }
856         }
857     }
858 
859     /**
860      * @dev Mints `quantity` tokens and transfers them to `to`.
861      *
862      * Requirements:
863      *
864      * - `to` cannot be the zero address.
865      * - `quantity` must be greater than 0.
866      *
867      * Emits a {Transfer} event for each mint.
868      */
869     function _mint(address to, uint256 quantity) internal {
870         uint256 startTokenId = _currentIndex;
871         if (to == address(0)) revert MintToZeroAddress();
872         if (quantity == 0) revert MintZeroQuantity();
873 
874         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
875 
876         // Overflows are incredibly unrealistic.
877         // `balance` and `numberMinted` have a maximum limit of 2**64.
878         // `tokenId` has a maximum limit of 2**256.
879         unchecked {
880             // Updates:
881             // - `balance += quantity`.
882             // - `numberMinted += quantity`.
883             //
884             // We can directly add to the `balance` and `numberMinted`.
885             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
886 
887             // Updates:
888             // - `address` to the owner.
889             // - `startTimestamp` to the timestamp of minting.
890             // - `burned` to `false`.
891             // - `nextInitialized` to `quantity == 1`.
892             _packedOwnerships[startTokenId] = _packOwnershipData(
893                 to,
894                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
895             );
896 
897             uint256 tokenId = startTokenId;
898             uint256 end = startTokenId + quantity;
899             do {
900                 emit Transfer(address(0), to, tokenId++);
901             } while (tokenId < end);
902 
903             _currentIndex = end;
904         }
905         _afterTokenTransfers(address(0), to, startTokenId, quantity);
906     }
907 
908     /**
909      * @dev Mints `quantity` tokens and transfers them to `to`.
910      *
911      * This function is intended for efficient minting only during contract creation.
912      *
913      * It emits only one {ConsecutiveTransfer} as defined in
914      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
915      * instead of a sequence of {Transfer} event(s).
916      *
917      * Calling this function outside of contract creation WILL make your contract
918      * non-compliant with the ERC721 standard.
919      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
920      * {ConsecutiveTransfer} event is only permissible during contract creation.
921      *
922      * Requirements:
923      *
924      * - `to` cannot be the zero address.
925      * - `quantity` must be greater than 0.
926      *
927      * Emits a {ConsecutiveTransfer} event.
928      */
929     function _mintERC2309(address to, uint256 quantity) internal {
930         uint256 startTokenId = _currentIndex;
931         if (to == address(0)) revert MintToZeroAddress();
932         if (quantity == 0) revert MintZeroQuantity();
933         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
934 
935         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
936 
937         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
938         unchecked {
939             // Updates:
940             // - `balance += quantity`.
941             // - `numberMinted += quantity`.
942             //
943             // We can directly add to the `balance` and `numberMinted`.
944             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
945 
946             // Updates:
947             // - `address` to the owner.
948             // - `startTimestamp` to the timestamp of minting.
949             // - `burned` to `false`.
950             // - `nextInitialized` to `quantity == 1`.
951             _packedOwnerships[startTokenId] = _packOwnershipData(
952                 to,
953                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
954             );
955 
956             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
957 
958             _currentIndex = startTokenId + quantity;
959         }
960         _afterTokenTransfers(address(0), to, startTokenId, quantity);
961     }
962 
963     /**
964      * @dev Returns the storage slot and value for the approved address of `tokenId`.
965      */
966     function _getApprovedAddress(uint256 tokenId)
967         private
968         view
969         returns (uint256 approvedAddressSlot, address approvedAddress)
970     {
971         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
972         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
973         assembly {
974             // Compute the slot.
975             mstore(0x00, tokenId)
976             mstore(0x20, tokenApprovalsPtr.slot)
977             approvedAddressSlot := keccak256(0x00, 0x40)
978             // Load the slot's value from storage.
979             approvedAddress := sload(approvedAddressSlot)
980         }
981     }
982 
983     /**
984      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
985      */
986     function _isOwnerOrApproved(
987         address approvedAddress,
988         address from,
989         address msgSender
990     ) private pure returns (bool result) {
991         assembly {
992             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
993             from := and(from, BITMASK_ADDRESS)
994             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
995             msgSender := and(msgSender, BITMASK_ADDRESS)
996             // `msgSender == from || msgSender == approvedAddress`.
997             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
998         }
999     }
1000 
1001     /**
1002      * @dev Transfers `tokenId` from `from` to `to`.
1003      *
1004      * Requirements:
1005      *
1006      * - `to` cannot be the zero address.
1007      * - `tokenId` token must be owned by `from`.
1008      *
1009      * Emits a {Transfer} event.
1010      */
1011     function transferFrom(
1012         address from,
1013         address to,
1014         uint256 tokenId
1015     ) public virtual override {
1016         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1017 
1018         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1019 
1020         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1021 
1022         // The nested ifs save around 20+ gas over a compound boolean condition.
1023         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1024             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1025 
1026         if (to == address(0)) revert TransferToZeroAddress();
1027 
1028         _beforeTokenTransfers(from, to, tokenId, 1);
1029 
1030         // Clear approvals from the previous owner.
1031         assembly {
1032             if approvedAddress {
1033                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1034                 sstore(approvedAddressSlot, 0)
1035             }
1036         }
1037 
1038         // Underflow of the sender's balance is impossible because we check for
1039         // ownership above and the recipient's balance can't realistically overflow.
1040         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1041         unchecked {
1042             // We can directly increment and decrement the balances.
1043             --_packedAddressData[from]; // Updates: `balance -= 1`.
1044             ++_packedAddressData[to]; // Updates: `balance += 1`.
1045 
1046             // Updates:
1047             // - `address` to the next owner.
1048             // - `startTimestamp` to the timestamp of transfering.
1049             // - `burned` to `false`.
1050             // - `nextInitialized` to `true`.
1051             _packedOwnerships[tokenId] = _packOwnershipData(
1052                 to,
1053                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1054             );
1055 
1056             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1057             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1058                 uint256 nextTokenId = tokenId + 1;
1059                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1060                 if (_packedOwnerships[nextTokenId] == 0) {
1061                     // If the next slot is within bounds.
1062                     if (nextTokenId != _currentIndex) {
1063                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1064                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1065                     }
1066                 }
1067             }
1068         }
1069 
1070         emit Transfer(from, to, tokenId);
1071         _afterTokenTransfers(from, to, tokenId, 1);
1072     }
1073 
1074     /**
1075      * @dev Equivalent to `_burn(tokenId, false)`.
1076      */
1077     function _burn(uint256 tokenId) internal virtual {
1078         _burn(tokenId, false);
1079     }
1080 
1081     /**
1082      * @dev Destroys `tokenId`.
1083      * The approval is cleared when the token is burned.
1084      *
1085      * Requirements:
1086      *
1087      * - `tokenId` must exist.
1088      *
1089      * Emits a {Transfer} event.
1090      */
1091     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1092         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1093 
1094         address from = address(uint160(prevOwnershipPacked));
1095 
1096         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1097 
1098         if (approvalCheck) {
1099             // The nested ifs save around 20+ gas over a compound boolean condition.
1100             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1101                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1102         }
1103 
1104         _beforeTokenTransfers(from, address(0), tokenId, 1);
1105 
1106         // Clear approvals from the previous owner.
1107         assembly {
1108             if approvedAddress {
1109                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1110                 sstore(approvedAddressSlot, 0)
1111             }
1112         }
1113 
1114         // Underflow of the sender's balance is impossible because we check for
1115         // ownership above and the recipient's balance can't realistically overflow.
1116         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1117         unchecked {
1118             // Updates:
1119             // - `balance -= 1`.
1120             // - `numberBurned += 1`.
1121             //
1122             // We can directly decrement the balance, and increment the number burned.
1123             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1124             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1125 
1126             // Updates:
1127             // - `address` to the last owner.
1128             // - `startTimestamp` to the timestamp of burning.
1129             // - `burned` to `true`.
1130             // - `nextInitialized` to `true`.
1131             _packedOwnerships[tokenId] = _packOwnershipData(
1132                 from,
1133                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1134             );
1135 
1136             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1137             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1138                 uint256 nextTokenId = tokenId + 1;
1139                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1140                 if (_packedOwnerships[nextTokenId] == 0) {
1141                     // If the next slot is within bounds.
1142                     if (nextTokenId != _currentIndex) {
1143                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1144                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1145                     }
1146                 }
1147             }
1148         }
1149 
1150         emit Transfer(from, address(0), tokenId);
1151         _afterTokenTransfers(from, address(0), tokenId, 1);
1152 
1153         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1154         unchecked {
1155             _burnCounter++;
1156         }
1157     }
1158 
1159     /**
1160      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1161      *
1162      * @param from address representing the previous owner of the given token ID
1163      * @param to target address that will receive the tokens
1164      * @param tokenId uint256 ID of the token to be transferred
1165      * @param _data bytes optional data to send along with the call
1166      * @return bool whether the call correctly returned the expected magic value
1167      */
1168     function _checkContractOnERC721Received(
1169         address from,
1170         address to,
1171         uint256 tokenId,
1172         bytes memory _data
1173     ) private returns (bool) {
1174         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1175             bytes4 retval
1176         ) {
1177             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1178         } catch (bytes memory reason) {
1179             if (reason.length == 0) {
1180                 revert TransferToNonERC721ReceiverImplementer();
1181             } else {
1182                 assembly {
1183                     revert(add(32, reason), mload(reason))
1184                 }
1185             }
1186         }
1187     }
1188 
1189     /**
1190      * @dev Directly sets the extra data for the ownership data `index`.
1191      */
1192     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1193         uint256 packed = _packedOwnerships[index];
1194         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1195         uint256 extraDataCasted;
1196         // Cast `extraData` with assembly to avoid redundant masking.
1197         assembly {
1198             extraDataCasted := extraData
1199         }
1200         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1201         _packedOwnerships[index] = packed;
1202     }
1203 
1204     /**
1205      * @dev Returns the next extra data for the packed ownership data.
1206      * The returned result is shifted into position.
1207      */
1208     function _nextExtraData(
1209         address from,
1210         address to,
1211         uint256 prevOwnershipPacked
1212     ) private view returns (uint256) {
1213         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1214         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1215     }
1216 
1217     /**
1218      * @dev Called during each token transfer to set the 24bit `extraData` field.
1219      * Intended to be overridden by the cosumer contract.
1220      *
1221      * `previousExtraData` - the value of `extraData` before transfer.
1222      *
1223      * Calling conditions:
1224      *
1225      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1226      * transferred to `to`.
1227      * - When `from` is zero, `tokenId` will be minted for `to`.
1228      * - When `to` is zero, `tokenId` will be burned by `from`.
1229      * - `from` and `to` are never both zero.
1230      */
1231     function _extraData(
1232         address from,
1233         address to,
1234         uint24 previousExtraData
1235     ) internal view virtual returns (uint24) {}
1236 
1237     /**
1238      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1239      * This includes minting.
1240      * And also called before burning one token.
1241      *
1242      * startTokenId - the first token id to be transferred
1243      * quantity - the amount to be transferred
1244      *
1245      * Calling conditions:
1246      *
1247      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1248      * transferred to `to`.
1249      * - When `from` is zero, `tokenId` will be minted for `to`.
1250      * - When `to` is zero, `tokenId` will be burned by `from`.
1251      * - `from` and `to` are never both zero.
1252      */
1253     function _beforeTokenTransfers(
1254         address from,
1255         address to,
1256         uint256 startTokenId,
1257         uint256 quantity
1258     ) internal virtual {}
1259 
1260     /**
1261      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1262      * This includes minting.
1263      * And also called after one token has been burned.
1264      *
1265      * startTokenId - the first token id to be transferred
1266      * quantity - the amount to be transferred
1267      *
1268      * Calling conditions:
1269      *
1270      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1271      * transferred to `to`.
1272      * - When `from` is zero, `tokenId` has been minted for `to`.
1273      * - When `to` is zero, `tokenId` has been burned by `from`.
1274      * - `from` and `to` are never both zero.
1275      */
1276     function _afterTokenTransfers(
1277         address from,
1278         address to,
1279         uint256 startTokenId,
1280         uint256 quantity
1281     ) internal virtual {}
1282 
1283     /**
1284      * @dev Returns the message sender (defaults to `msg.sender`).
1285      *
1286      * If you are writing GSN compatible contracts, you need to override this function.
1287      */
1288     function _msgSenderERC721A() internal view virtual returns (address) {
1289         return msg.sender;
1290     }
1291 
1292     /**
1293      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1294      */
1295     function _toString(uint256 value) internal pure returns (string memory ptr) {
1296         assembly {
1297             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1298             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1299             // We will need 1 32-byte word to store the length,
1300             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1301             ptr := add(mload(0x40), 128)
1302             // Update the free memory pointer to allocate.
1303             mstore(0x40, ptr)
1304 
1305             // Cache the end of the memory to calculate the length later.
1306             let end := ptr
1307 
1308             // We write the string from the rightmost digit to the leftmost digit.
1309             // The following is essentially a do-while loop that also handles the zero case.
1310             // Costs a bit more than early returning for the zero case,
1311             // but cheaper in terms of deployment and overall runtime costs.
1312             for {
1313                 // Initialize and perform the first pass without check.
1314                 let temp := value
1315                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1316                 ptr := sub(ptr, 1)
1317                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1318                 mstore8(ptr, add(48, mod(temp, 10)))
1319                 temp := div(temp, 10)
1320             } temp {
1321                 // Keep dividing `temp` until zero.
1322                 temp := div(temp, 10)
1323             } {
1324                 // Body of the for loop.
1325                 ptr := sub(ptr, 1)
1326                 mstore8(ptr, add(48, mod(temp, 10)))
1327             }
1328 
1329             let length := sub(end, ptr)
1330             // Move the pointer 32 bytes leftwards to make room for the length.
1331             ptr := sub(ptr, 32)
1332             // Store the length.
1333             mstore(ptr, length)
1334         }
1335     }
1336 }
1337 
1338 // File: contracts/MoonGoblz.sol
1339 
1340 
1341 pragma solidity ^0.8.11;
1342 
1343 
1344 
1345 contract MoonGoblz is ERC721A, Ownable {
1346   string _baseTokenURI;
1347   
1348   bool public isSaleActive = false;
1349   uint256 public constant mintPrice = 0.002 ether;
1350   uint256 public constant MAX_SUPPLY = 6666;
1351   uint256 public constant MAX_FREE_SUPPLY = 3333;
1352   uint256 public constant MAX_FREE_WALLET = 3;
1353   uint256 public constant MAX_PER_TX = 20;
1354 
1355   constructor(string memory baseURI) ERC721A("Moon Goblz", "MG") {
1356     setBaseURI(baseURI);
1357   }
1358 
1359   modifier saleIsOpen {
1360     require(totalSupply() <= MAX_SUPPLY, "Sale has ended.");
1361     _;
1362   }
1363 
1364   modifier onlyAuthorized() {
1365     require(owner() == msg.sender);
1366     _;
1367   }
1368 
1369   function toggleSale() public onlyAuthorized {
1370     isSaleActive = !isSaleActive;
1371   }
1372 
1373 
1374   function setBaseURI(string memory baseURI) public onlyAuthorized {
1375     _baseTokenURI = baseURI;
1376   }
1377 
1378   function _baseURI() internal view virtual override returns (string memory) {
1379     return _baseTokenURI;
1380   }
1381 
1382   function mint(uint256 _count) public payable saleIsOpen {
1383     uint256 mintIndex = totalSupply();
1384 
1385     if (msg.sender != owner()) {
1386       require(isSaleActive, "Sale is not active currently.");
1387     }
1388 
1389     require(mintIndex + _count <= MAX_SUPPLY, "Total supply exceeded.");
1390     require(_count <= MAX_PER_TX,"Exceeds maximum allowed tokens");
1391 
1392     if(mintIndex + _count > MAX_FREE_SUPPLY) {
1393       require(msg.value >= mintPrice * _count, "Insufficient ETH amount sent.");
1394     }
1395 
1396     if(mintIndex + _count < MAX_FREE_SUPPLY) {
1397       require(balanceOf(msg.sender) + _count <= MAX_FREE_WALLET, "Exceeds Free maximum allowed tokens per wallet");
1398     }
1399 
1400     _safeMint(msg.sender, _count);
1401 
1402   }
1403 
1404   function withdraw() external onlyAuthorized {
1405     uint balance = address(this).balance;
1406     payable(owner()).transfer(balance);
1407   }
1408 }