1 /**
2  *Submitted for verification at Etherscan.io on 2022-08-02
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2022-07-20
7 */
8 
9 // SPDX-License-Identifier: MIT
10 // File: @openzeppelin/contracts/utils/Context.sol
11 
12 
13 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
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
125 // ERC721A Contracts v4.1.0
126 // Creator: Chiru Labs
127 
128 pragma solidity ^0.8.4;
129 
130 /**
131  * @dev Interface of an ERC721A compliant contract.
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
180      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
181      */
182     error TransferToNonERC721ReceiverImplementer();
183 
184     /**
185      * Cannot transfer to the zero address.
186      */
187     error TransferToZeroAddress();
188 
189     /**
190      * The token does not exist.
191      */
192     error URIQueryForNonexistentToken();
193 
194     /**
195      * The `quantity` minted with ERC2309 exceeds the safety limit.
196      */
197     error MintERC2309QuantityExceedsLimit();
198 
199     /**
200      * The `extraData` cannot be set on an unintialized ownership slot.
201      */
202     error OwnershipNotInitializedForExtraData();
203 
204     struct TokenOwnership {
205         // The address of the owner.
206         address addr;
207         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
208         uint64 startTimestamp;
209         // Whether the token has been burned.
210         bool burned;
211         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
212         uint24 extraData;
213     }
214 
215     /**
216      * @dev Returns the total amount of tokens stored by the contract.
217      *
218      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
219      */
220     function totalSupply() external view returns (uint256);
221 
222     // ==============================
223     //            IERC165
224     // ==============================
225 
226     /**
227      * @dev Returns true if this contract implements the interface defined by
228      * `interfaceId`. See the corresponding
229      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
230      * to learn more about how these ids are created.
231      *
232      * This function call must use less than 30 000 gas.
233      */
234     function supportsInterface(bytes4 interfaceId) external view returns (bool);
235 
236     // ==============================
237     //            IERC721
238     // ==============================
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
251      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
252      */
253     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
254 
255     /**
256      * @dev Returns the number of tokens in ``owner``"s account.
257      */
258     function balanceOf(address owner) external view returns (uint256 balance);
259 
260     /**
261      * @dev Returns the owner of the `tokenId` token.
262      *
263      * Requirements:
264      *
265      * - `tokenId` must exist.
266      */
267     function ownerOf(uint256 tokenId) external view returns (address owner);
268 
269     /**
270      * @dev Safely transfers `tokenId` token from `from` to `to`.
271      *
272      * Requirements:
273      *
274      * - `from` cannot be the zero address.
275      * - `to` cannot be the zero address.
276      * - `tokenId` token must exist and be owned by `from`.
277      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
278      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
279      *
280      * Emits a {Transfer} event.
281      */
282     function safeTransferFrom(
283         address from,
284         address to,
285         uint256 tokenId,
286         bytes calldata data
287     ) external;
288 
289     /**
290      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
291      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
292      *
293      * Requirements:
294      *
295      * - `from` cannot be the zero address.
296      * - `to` cannot be the zero address.
297      * - `tokenId` token must exist and be owned by `from`.
298      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
299      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
300      *
301      * Emits a {Transfer} event.
302      */
303     function safeTransferFrom(
304         address from,
305         address to,
306         uint256 tokenId
307     ) external;
308 
309     /**
310      * @dev Transfers `tokenId` token from `from` to `to`.
311      *
312      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
313      *
314      * Requirements:
315      *
316      * - `from` cannot be the zero address.
317      * - `to` cannot be the zero address.
318      * - `tokenId` token must be owned by `from`.
319      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
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
333      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
334      *
335      * Requirements:
336      *
337      * - The caller must own the token or be an approved operator.
338      * - `tokenId` must exist.
339      *
340      * Emits an {Approval} event.
341      */
342     function approve(address to, uint256 tokenId) external;
343 
344     /**
345      * @dev Approve or remove `operator` as an operator for the caller.
346      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
347      *
348      * Requirements:
349      *
350      * - The `operator` cannot be the caller.
351      *
352      * Emits an {ApprovalForAll} event.
353      */
354     function setApprovalForAll(address operator, bool _approved) external;
355 
356     /**
357      * @dev Returns the account approved for `tokenId` token.
358      *
359      * Requirements:
360      *
361      * - `tokenId` must exist.
362      */
363     function getApproved(uint256 tokenId) external view returns (address operator);
364 
365     /**
366      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
367      *
368      * See {setApprovalForAll}
369      */
370     function isApprovedForAll(address owner, address operator) external view returns (bool);
371 
372     // ==============================
373     //        IERC721Metadata
374     // ==============================
375 
376     /**
377      * @dev Returns the token collection name.
378      */
379     function name() external view returns (string memory);
380 
381     /**
382      * @dev Returns the token collection symbol.
383      */
384     function symbol() external view returns (string memory);
385 
386     /**
387      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
388      */
389     function tokenURI(uint256 tokenId) external view returns (string memory);
390 
391     // ==============================
392     //            IERC2309
393     // ==============================
394 
395     /**
396      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
397      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
398      */
399     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
400 }
401 
402 // File: erc721a/contracts/ERC721A.sol
403 
404 
405 // ERC721A Contracts v4.1.0
406 // Creator: Chiru Labs
407 
408 pragma solidity ^0.8.4;
409 
410 
411 /**
412  * @dev ERC721 token receiver interface.
413  */
414 interface ERC721A__IERC721Receiver {
415     function onERC721Received(
416         address operator,
417         address from,
418         uint256 tokenId,
419         bytes calldata data
420     ) external returns (bytes4);
421 }
422 
423 /**
424  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
425  * including the Metadata extension. Built to optimize for lower gas during batch mints.
426  *
427  * Assumes serials are sequentially minted starting at `_startTokenId()`
428  * (defaults to 0, e.g. 0, 1, 2, 3..).
429  *
430  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
431  *
432  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
433  */
434 contract ERC721A is IERC721A {
435     // Mask of an entry in packed address data.
436     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
437 
438     // The bit position of `numberMinted` in packed address data.
439     uint256 private constant BITPOS_NUMBER_MINTED = 64;
440 
441     // The bit position of `numberBurned` in packed address data.
442     uint256 private constant BITPOS_NUMBER_BURNED = 128;
443 
444     // The bit position of `aux` in packed address data.
445     uint256 private constant BITPOS_AUX = 192;
446 
447     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
448     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
449 
450     // The bit position of `startTimestamp` in packed ownership.
451     uint256 private constant BITPOS_START_TIMESTAMP = 160;
452 
453     // The bit mask of the `burned` bit in packed ownership.
454     uint256 private constant BITMASK_BURNED = 1 << 224;
455 
456     // The bit position of the `nextInitialized` bit in packed ownership.
457     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
458 
459     // The bit mask of the `nextInitialized` bit in packed ownership.
460     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
461 
462     // The bit position of `extraData` in packed ownership.
463     uint256 private constant BITPOS_EXTRA_DATA = 232;
464 
465     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
466     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
467 
468     // The mask of the lower 160 bits for addresses.
469     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
470 
471     // The maximum `quantity` that can be minted with `_mintERC2309`.
472     // This limit is to prevent overflows on the address data entries.
473     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
474     // is required to cause an overflow, which is unrealistic.
475     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
476 
477     // The tokenId of the next token to be minted.
478     uint256 private _currentIndex;
479 
480     // The number of tokens burned.
481     uint256 private _burnCounter;
482 
483     // Token name
484     string private _name;
485 
486     // Token symbol
487     string private _symbol;
488 
489     // Mapping from token ID to ownership details
490     // An empty struct value does not necessarily mean the token is unowned.
491     // See `_packedOwnershipOf` implementation for details.
492     //
493     // Bits Layout:
494     // - [0..159]   `addr`
495     // - [160..223] `startTimestamp`
496     // - [224]      `burned`
497     // - [225]      `nextInitialized`
498     // - [232..255] `extraData`
499     mapping(uint256 => uint256) private _packedOwnerships;
500 
501     // Mapping owner address to address data.
502     //
503     // Bits Layout:
504     // - [0..63]    `balance`
505     // - [64..127]  `numberMinted`
506     // - [128..191] `numberBurned`
507     // - [192..255] `aux`
508     mapping(address => uint256) private _packedAddressData;
509 
510     // Mapping from token ID to approved address.
511     mapping(uint256 => address) private _tokenApprovals;
512 
513     // Mapping from owner to operator approvals
514     mapping(address => mapping(address => bool)) private _operatorApprovals;
515 
516     constructor(string memory name_, string memory symbol_) {
517         _name = name_;
518         _symbol = symbol_;
519         _currentIndex = _startTokenId();
520     }
521 
522     /**
523      * @dev Returns the starting token ID.
524      * To change the starting token ID, please override this function.
525      */
526     function _startTokenId() internal view virtual returns (uint256) {
527         return 0;
528     }
529 
530     /**
531      * @dev Returns the next token ID to be minted.
532      */
533     function _nextTokenId() internal view returns (uint256) {
534         return _currentIndex;
535     }
536 
537     /**
538      * @dev Returns the total number of tokens in existence.
539      * Burned tokens will reduce the count.
540      * To get the total number of tokens minted, please see `_totalMinted`.
541      */
542     function totalSupply() public view override returns (uint256) {
543         // Counter underflow is impossible as _burnCounter cannot be incremented
544         // more than `_currentIndex - _startTokenId()` times.
545         unchecked {
546             return _currentIndex - _burnCounter - _startTokenId();
547         }
548     }
549 
550     /**
551      * @dev Returns the total amount of tokens minted in the contract.
552      */
553     function _totalMinted() internal view returns (uint256) {
554         // Counter underflow is impossible as _currentIndex does not decrement,
555         // and it is initialized to `_startTokenId()`
556         unchecked {
557             return _currentIndex - _startTokenId();
558         }
559     }
560 
561     /**
562      * @dev Returns the total number of tokens burned.
563      */
564     function _totalBurned() internal view returns (uint256) {
565         return _burnCounter;
566     }
567 
568     /**
569      * @dev See {IERC165-supportsInterface}.
570      */
571     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
572         // The interface IDs are constants representing the first 4 bytes of the XOR of
573         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
574         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
575         return
576             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
577             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
578             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
579     }
580 
581     /**
582      * @dev See {IERC721-balanceOf}.
583      */
584     function balanceOf(address owner) public view override returns (uint256) {
585         if (owner == address(0)) revert BalanceQueryForZeroAddress();
586         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
587     }
588 
589     /**
590      * Returns the number of tokens minted by `owner`.
591      */
592     function _numberMinted(address owner) internal view returns (uint256) {
593         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
594     }
595 
596     /**
597      * Returns the number of tokens burned by or on behalf of `owner`.
598      */
599     function _numberBurned(address owner) internal view returns (uint256) {
600         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
601     }
602 
603     /**
604      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
605      */
606     function _getAux(address owner) internal view returns (uint64) {
607         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
608     }
609 
610     /**
611      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
612      * If there are multiple variables, please pack them into a uint64.
613      */
614     function _setAux(address owner, uint64 aux) internal {
615         uint256 packed = _packedAddressData[owner];
616         uint256 auxCasted;
617         // Cast `aux` with assembly to avoid redundant masking.
618         assembly {
619             auxCasted := aux
620         }
621         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
622         _packedAddressData[owner] = packed;
623     }
624 
625     /**
626      * Returns the packed ownership data of `tokenId`.
627      */
628     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
629         uint256 curr = tokenId;
630 
631         unchecked {
632             if (_startTokenId() <= curr)
633                 if (curr < _currentIndex) {
634                     uint256 packed = _packedOwnerships[curr];
635                     // If not burned.
636                     if (packed & BITMASK_BURNED == 0) {
637                         // Invariant:
638                         // There will always be an ownership that has an address and is not burned
639                         // before an ownership that does not have an address and is not burned.
640                         // Hence, curr will not underflow.
641                         //
642                         // We can directly compare the packed value.
643                         // If the address is zero, packed is zero.
644                         while (packed == 0) {
645                             packed = _packedOwnerships[--curr];
646                         }
647                         return packed;
648                     }
649                 }
650         }
651         revert OwnerQueryForNonexistentToken();
652     }
653 
654     /**
655      * Returns the unpacked `TokenOwnership` struct from `packed`.
656      */
657     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
658         ownership.addr = address(uint160(packed));
659         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
660         ownership.burned = packed & BITMASK_BURNED != 0;
661         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
662     }
663 
664     /**
665      * Returns the unpacked `TokenOwnership` struct at `index`.
666      */
667     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
668         return _unpackedOwnership(_packedOwnerships[index]);
669     }
670 
671     /**
672      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
673      */
674     function _initializeOwnershipAt(uint256 index) internal {
675         if (_packedOwnerships[index] == 0) {
676             _packedOwnerships[index] = _packedOwnershipOf(index);
677         }
678     }
679 
680     /**
681      * Gas spent here starts off proportional to the maximum mint batch size.
682      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
683      */
684     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
685         return _unpackedOwnership(_packedOwnershipOf(tokenId));
686     }
687 
688     /**
689      * @dev Packs ownership data into a single uint256.
690      */
691     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
692         assembly {
693             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren"t clean.
694             owner := and(owner, BITMASK_ADDRESS)
695             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
696             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
697         }
698     }
699 
700     /**
701      * @dev See {IERC721-ownerOf}.
702      */
703     function ownerOf(uint256 tokenId) public view override returns (address) {
704         return address(uint160(_packedOwnershipOf(tokenId)));
705     }
706 
707     /**
708      * @dev See {IERC721Metadata-name}.
709      */
710     function name() public view virtual override returns (string memory) {
711         return _name;
712     }
713 
714     /**
715      * @dev See {IERC721Metadata-symbol}.
716      */
717     function symbol() public view virtual override returns (string memory) {
718         return _symbol;
719     }
720 
721     /**
722      * @dev See {IERC721Metadata-tokenURI}.
723      */
724     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
725         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
726 
727         string memory baseURI = _baseURI();
728         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : "";
729     }
730 
731     /**
732      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
733      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
734      * by default, it can be overridden in child contracts.
735      */
736     function _baseURI() internal view virtual returns (string memory) {
737         return "";
738     }
739 
740     /**
741      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
742      */
743     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
744         // For branchless setting of the `nextInitialized` flag.
745         assembly {
746             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
747             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
748         }
749     }
750 
751     /**
752      * @dev See {IERC721-approve}.
753      */
754     function approve(address to, uint256 tokenId) public override {
755         address owner = ownerOf(tokenId);
756 
757         if (_msgSenderERC721A() != owner)
758             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
759                 revert ApprovalCallerNotOwnerNorApproved();
760             }
761 
762         _tokenApprovals[tokenId] = to;
763         emit Approval(owner, to, tokenId);
764     }
765 
766     /**
767      * @dev See {IERC721-getApproved}.
768      */
769     function getApproved(uint256 tokenId) public view override returns (address) {
770         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
771 
772         return _tokenApprovals[tokenId];
773     }
774 
775     /**
776      * @dev See {IERC721-setApprovalForAll}.
777      */
778     function setApprovalForAll(address operator, bool approved) public virtual override {
779         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
780 
781         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
782         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
783     }
784 
785     /**
786      * @dev See {IERC721-isApprovedForAll}.
787      */
788     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
789         return _operatorApprovals[owner][operator];
790     }
791 
792     /**
793      * @dev See {IERC721-safeTransferFrom}.
794      */
795     function safeTransferFrom(
796         address from,
797         address to,
798         uint256 tokenId
799     ) public virtual override {
800         safeTransferFrom(from, to, tokenId, "");
801     }
802 
803     /**
804      * @dev See {IERC721-safeTransferFrom}.
805      */
806     function safeTransferFrom(
807         address from,
808         address to,
809         uint256 tokenId,
810         bytes memory _data
811     ) public virtual override {
812         transferFrom(from, to, tokenId);
813         if (to.code.length != 0)
814             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
815                 revert TransferToNonERC721ReceiverImplementer();
816             }
817     }
818 
819     /**
820      * @dev Returns whether `tokenId` exists.
821      *
822      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
823      *
824      * Tokens start existing when they are minted (`_mint`),
825      */
826     function _exists(uint256 tokenId) internal view returns (bool) {
827         return
828             _startTokenId() <= tokenId &&
829             tokenId < _currentIndex && // If within bounds,
830             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
831     }
832 
833     /**
834      * @dev Equivalent to `_safeMint(to, quantity, "")`.
835      */
836     function _safeMint(address to, uint256 quantity) internal {
837         _safeMint(to, quantity, "");
838     }
839 
840     /**
841      * @dev Safely mints `quantity` tokens and transfers them to `to`.
842      *
843      * Requirements:
844      *
845      * - If `to` refers to a smart contract, it must implement
846      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
847      * - `quantity` must be greater than 0.
848      *
849      * See {_mint}.
850      *
851      * Emits a {Transfer} event for each mint.
852      */
853     function _safeMint(
854         address to,
855         uint256 quantity,
856         bytes memory _data
857     ) internal {
858         _mint(to, quantity);
859 
860         unchecked {
861             if (to.code.length != 0) {
862                 uint256 end = _currentIndex;
863                 uint256 index = end - quantity;
864                 do {
865                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
866                         revert TransferToNonERC721ReceiverImplementer();
867                     }
868                 } while (index < end);
869                 // Reentrancy protection.
870                 if (_currentIndex != end) revert();
871             }
872         }
873     }
874 
875     /**
876      * @dev Mints `quantity` tokens and transfers them to `to`.
877      *
878      * Requirements:
879      *
880      * - `to` cannot be the zero address.
881      * - `quantity` must be greater than 0.
882      *
883      * Emits a {Transfer} event for each mint.
884      */
885     function _mint(address to, uint256 quantity) internal {
886         uint256 startTokenId = _currentIndex;
887         if (to == address(0)) revert MintToZeroAddress();
888         if (quantity == 0) revert MintZeroQuantity();
889 
890         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
891 
892         // Overflows are incredibly unrealistic.
893         // `balance` and `numberMinted` have a maximum limit of 2**64.
894         // `tokenId` has a maximum limit of 2**256.
895         unchecked {
896             // Updates:
897             // - `balance += quantity`.
898             // - `numberMinted += quantity`.
899             //
900             // We can directly add to the `balance` and `numberMinted`.
901             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
902 
903             // Updates:
904             // - `address` to the owner.
905             // - `startTimestamp` to the timestamp of minting.
906             // - `burned` to `false`.
907             // - `nextInitialized` to `quantity == 1`.
908             _packedOwnerships[startTokenId] = _packOwnershipData(
909                 to,
910                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
911             );
912 
913             uint256 tokenId = startTokenId;
914             uint256 end = startTokenId + quantity;
915             do {
916                 emit Transfer(address(0), to, tokenId++);
917             } while (tokenId < end);
918 
919             _currentIndex = end;
920         }
921         _afterTokenTransfers(address(0), to, startTokenId, quantity);
922     }
923 
924     /**
925      * @dev Mints `quantity` tokens and transfers them to `to`.
926      *
927      * This function is intended for efficient minting only during contract creation.
928      *
929      * It emits only one {ConsecutiveTransfer} as defined in
930      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
931      * instead of a sequence of {Transfer} event(s).
932      *
933      * Calling this function outside of contract creation WILL make your contract
934      * non-compliant with the ERC721 standard.
935      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
936      * {ConsecutiveTransfer} event is only permissible during contract creation.
937      *
938      * Requirements:
939      *
940      * - `to` cannot be the zero address.
941      * - `quantity` must be greater than 0.
942      *
943      * Emits a {ConsecutiveTransfer} event.
944      */
945     function _mintERC2309(address to, uint256 quantity) internal {
946         uint256 startTokenId = _currentIndex;
947         if (to == address(0)) revert MintToZeroAddress();
948         if (quantity == 0) revert MintZeroQuantity();
949         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
950 
951         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
952 
953         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
954         unchecked {
955             // Updates:
956             // - `balance += quantity`.
957             // - `numberMinted += quantity`.
958             //
959             // We can directly add to the `balance` and `numberMinted`.
960             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
961 
962             // Updates:
963             // - `address` to the owner.
964             // - `startTimestamp` to the timestamp of minting.
965             // - `burned` to `false`.
966             // - `nextInitialized` to `quantity == 1`.
967             _packedOwnerships[startTokenId] = _packOwnershipData(
968                 to,
969                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
970             );
971 
972             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
973 
974             _currentIndex = startTokenId + quantity;
975         }
976         _afterTokenTransfers(address(0), to, startTokenId, quantity);
977     }
978 
979     /**
980      * @dev Returns the storage slot and value for the approved address of `tokenId`.
981      */
982     function _getApprovedAddress(uint256 tokenId)
983         private
984         view
985         returns (uint256 approvedAddressSlot, address approvedAddress)
986     {
987         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
988         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
989         assembly {
990             // Compute the slot.
991             mstore(0x00, tokenId)
992             mstore(0x20, tokenApprovalsPtr.slot)
993             approvedAddressSlot := keccak256(0x00, 0x40)
994             // Load the slot"s value from storage.
995             approvedAddress := sload(approvedAddressSlot)
996         }
997     }
998 
999     /**
1000      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1001      */
1002     function _isOwnerOrApproved(
1003         address approvedAddress,
1004         address from,
1005         address msgSender
1006     ) private pure returns (bool result) {
1007         assembly {
1008             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren"t clean.
1009             from := and(from, BITMASK_ADDRESS)
1010             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren"t clean.
1011             msgSender := and(msgSender, BITMASK_ADDRESS)
1012             // `msgSender == from || msgSender == approvedAddress`.
1013             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1014         }
1015     }
1016 
1017     /**
1018      * @dev Transfers `tokenId` from `from` to `to`.
1019      *
1020      * Requirements:
1021      *
1022      * - `to` cannot be the zero address.
1023      * - `tokenId` token must be owned by `from`.
1024      *
1025      * Emits a {Transfer} event.
1026      */
1027     function transferFrom(
1028         address from,
1029         address to,
1030         uint256 tokenId
1031     ) public virtual override {
1032         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1033 
1034         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1035 
1036         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1037 
1038         // The nested ifs save around 20+ gas over a compound boolean condition.
1039         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1040             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1041 
1042         if (to == address(0)) revert TransferToZeroAddress();
1043 
1044         _beforeTokenTransfers(from, to, tokenId, 1);
1045 
1046         // Clear approvals from the previous owner.
1047         assembly {
1048             if approvedAddress {
1049                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1050                 sstore(approvedAddressSlot, 0)
1051             }
1052         }
1053 
1054         // Underflow of the sender"s balance is impossible because we check for
1055         // ownership above and the recipient"s balance can"t realistically overflow.
1056         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1057         unchecked {
1058             // We can directly increment and decrement the balances.
1059             --_packedAddressData[from]; // Updates: `balance -= 1`.
1060             ++_packedAddressData[to]; // Updates: `balance += 1`.
1061 
1062             // Updates:
1063             // - `address` to the next owner.
1064             // - `startTimestamp` to the timestamp of transfering.
1065             // - `burned` to `false`.
1066             // - `nextInitialized` to `true`.
1067             _packedOwnerships[tokenId] = _packOwnershipData(
1068                 to,
1069                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1070             );
1071 
1072             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1073             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1074                 uint256 nextTokenId = tokenId + 1;
1075                 // If the next slot"s address is zero and not burned (i.e. packed value is zero).
1076                 if (_packedOwnerships[nextTokenId] == 0) {
1077                     // If the next slot is within bounds.
1078                     if (nextTokenId != _currentIndex) {
1079                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1080                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1081                     }
1082                 }
1083             }
1084         }
1085 
1086         emit Transfer(from, to, tokenId);
1087         _afterTokenTransfers(from, to, tokenId, 1);
1088     }
1089 
1090     /**
1091      * @dev Equivalent to `_burn(tokenId, false)`.
1092      */
1093     function _burn(uint256 tokenId) internal virtual {
1094         _burn(tokenId, false);
1095     }
1096 
1097     /**
1098      * @dev Destroys `tokenId`.
1099      * The approval is cleared when the token is burned.
1100      *
1101      * Requirements:
1102      *
1103      * - `tokenId` must exist.
1104      *
1105      * Emits a {Transfer} event.
1106      */
1107     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1108         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1109 
1110         address from = address(uint160(prevOwnershipPacked));
1111 
1112         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1113 
1114         if (approvalCheck) {
1115             // The nested ifs save around 20+ gas over a compound boolean condition.
1116             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1117                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1118         }
1119 
1120         _beforeTokenTransfers(from, address(0), tokenId, 1);
1121 
1122         // Clear approvals from the previous owner.
1123         assembly {
1124             if approvedAddress {
1125                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1126                 sstore(approvedAddressSlot, 0)
1127             }
1128         }
1129 
1130         // Underflow of the sender"s balance is impossible because we check for
1131         // ownership above and the recipient"s balance can"t realistically overflow.
1132         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1133         unchecked {
1134             // Updates:
1135             // - `balance -= 1`.
1136             // - `numberBurned += 1`.
1137             //
1138             // We can directly decrement the balance, and increment the number burned.
1139             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1140             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1141 
1142             // Updates:
1143             // - `address` to the last owner.
1144             // - `startTimestamp` to the timestamp of burning.
1145             // - `burned` to `true`.
1146             // - `nextInitialized` to `true`.
1147             _packedOwnerships[tokenId] = _packOwnershipData(
1148                 from,
1149                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1150             );
1151 
1152             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1153             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1154                 uint256 nextTokenId = tokenId + 1;
1155                 // If the next slot"s address is zero and not burned (i.e. packed value is zero).
1156                 if (_packedOwnerships[nextTokenId] == 0) {
1157                     // If the next slot is within bounds.
1158                     if (nextTokenId != _currentIndex) {
1159                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1160                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1161                     }
1162                 }
1163             }
1164         }
1165 
1166         emit Transfer(from, address(0), tokenId);
1167         _afterTokenTransfers(from, address(0), tokenId, 1);
1168 
1169         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1170         unchecked {
1171             _burnCounter++;
1172         }
1173     }
1174 
1175     /**
1176      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1177      *
1178      * @param from address representing the previous owner of the given token ID
1179      * @param to target address that will receive the tokens
1180      * @param tokenId uint256 ID of the token to be transferred
1181      * @param _data bytes optional data to send along with the call
1182      * @return bool whether the call correctly returned the expected magic value
1183      */
1184     function _checkContractOnERC721Received(
1185         address from,
1186         address to,
1187         uint256 tokenId,
1188         bytes memory _data
1189     ) private returns (bool) {
1190         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1191             bytes4 retval
1192         ) {
1193             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1194         } catch (bytes memory reason) {
1195             if (reason.length == 0) {
1196                 revert TransferToNonERC721ReceiverImplementer();
1197             } else {
1198                 assembly {
1199                     revert(add(32, reason), mload(reason))
1200                 }
1201             }
1202         }
1203     }
1204 
1205     /**
1206      * @dev Directly sets the extra data for the ownership data `index`.
1207      */
1208     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1209         uint256 packed = _packedOwnerships[index];
1210         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1211         uint256 extraDataCasted;
1212         // Cast `extraData` with assembly to avoid redundant masking.
1213         assembly {
1214             extraDataCasted := extraData
1215         }
1216         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1217         _packedOwnerships[index] = packed;
1218     }
1219 
1220     /**
1221      * @dev Returns the next extra data for the packed ownership data.
1222      * The returned result is shifted into position.
1223      */
1224     function _nextExtraData(
1225         address from,
1226         address to,
1227         uint256 prevOwnershipPacked
1228     ) private view returns (uint256) {
1229         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1230         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1231     }
1232 
1233     /**
1234      * @dev Called during each token transfer to set the 24bit `extraData` field.
1235      * Intended to be overridden by the cosumer contract.
1236      *
1237      * `previousExtraData` - the value of `extraData` before transfer.
1238      *
1239      * Calling conditions:
1240      *
1241      * - When `from` and `to` are both non-zero, `from`"s `tokenId` will be
1242      * transferred to `to`.
1243      * - When `from` is zero, `tokenId` will be minted for `to`.
1244      * - When `to` is zero, `tokenId` will be burned by `from`.
1245      * - `from` and `to` are never both zero.
1246      */
1247     function _extraData(
1248         address from,
1249         address to,
1250         uint24 previousExtraData
1251     ) internal view virtual returns (uint24) {}
1252 
1253     /**
1254      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1255      * This includes minting.
1256      * And also called before burning one token.
1257      *
1258      * startTokenId - the first token id to be transferred
1259      * quantity - the amount to be transferred
1260      *
1261      * Calling conditions:
1262      *
1263      * - When `from` and `to` are both non-zero, `from`"s `tokenId` will be
1264      * transferred to `to`.
1265      * - When `from` is zero, `tokenId` will be minted for `to`.
1266      * - When `to` is zero, `tokenId` will be burned by `from`.
1267      * - `from` and `to` are never both zero.
1268      */
1269     function _beforeTokenTransfers(
1270         address from,
1271         address to,
1272         uint256 startTokenId,
1273         uint256 quantity
1274     ) internal virtual {}
1275 
1276     /**
1277      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1278      * This includes minting.
1279      * And also called after one token has been burned.
1280      *
1281      * startTokenId - the first token id to be transferred
1282      * quantity - the amount to be transferred
1283      *
1284      * Calling conditions:
1285      *
1286      * - When `from` and `to` are both non-zero, `from`"s `tokenId` has been
1287      * transferred to `to`.
1288      * - When `from` is zero, `tokenId` has been minted for `to`.
1289      * - When `to` is zero, `tokenId` has been burned by `from`.
1290      * - `from` and `to` are never both zero.
1291      */
1292     function _afterTokenTransfers(
1293         address from,
1294         address to,
1295         uint256 startTokenId,
1296         uint256 quantity
1297     ) internal virtual {}
1298 
1299     /**
1300      * @dev Returns the message sender (defaults to `msg.sender`).
1301      *
1302      * If you are writing GSN compatible contracts, you need to override this function.
1303      */
1304     function _msgSenderERC721A() internal view virtual returns (address) {
1305         return msg.sender;
1306     }
1307 
1308     /**
1309      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1310      */
1311     function _toString(uint256 value) internal pure returns (string memory ptr) {
1312         assembly {
1313             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1314             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1315             // We will need 1 32-byte word to store the length,
1316             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1317             ptr := add(mload(0x40), 128)
1318             // Update the free memory pointer to allocate.
1319             mstore(0x40, ptr)
1320 
1321             // Cache the end of the memory to calculate the length later.
1322             let end := ptr
1323 
1324             // We write the string from the rightmost digit to the leftmost digit.
1325             // The following is essentially a do-while loop that also handles the zero case.
1326             // Costs a bit more than early returning for the zero case,
1327             // but cheaper in terms of deployment and overall runtime costs.
1328             for {
1329                 // Initialize and perform the first pass without check.
1330                 let temp := value
1331                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1332                 ptr := sub(ptr, 1)
1333                 // Write the character to the pointer. 48 is the ASCII index of "0".
1334                 mstore8(ptr, add(48, mod(temp, 10)))
1335                 temp := div(temp, 10)
1336             } temp {
1337                 // Keep dividing `temp` until zero.
1338                 temp := div(temp, 10)
1339             } {
1340                 // Body of the for loop.
1341                 ptr := sub(ptr, 1)
1342                 mstore8(ptr, add(48, mod(temp, 10)))
1343             }
1344 
1345             let length := sub(end, ptr)
1346             // Move the pointer 32 bytes leftwards to make room for the length.
1347             ptr := sub(ptr, 32)
1348             // Store the length.
1349             mstore(ptr, length)
1350         }
1351     }
1352 }
1353 
1354 
1355 
1356 
1357 pragma solidity ^0.8.0;
1358 
1359 /**
1360  * @dev String operations.
1361  */
1362 library Strings {
1363     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1364 
1365     /**
1366      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1367      */
1368     function toString(uint256 value) internal pure returns (string memory) {
1369         // Inspired by OraclizeAPI"s implementation - MIT licence
1370         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1371 
1372         if (value == 0) {
1373             return "0";
1374         }
1375         uint256 temp = value;
1376         uint256 digits;
1377         while (temp != 0) {
1378             digits++;
1379             temp /= 10;
1380         }
1381         bytes memory buffer = new bytes(digits);
1382         while (value != 0) {
1383             digits -= 1;
1384             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1385             value /= 10;
1386         }
1387         return string(buffer);
1388     }
1389 
1390     /**
1391      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1392      */
1393     function toHexString(uint256 value) internal pure returns (string memory) {
1394         if (value == 0) {
1395             return "0x00";
1396         }
1397         uint256 temp = value;
1398         uint256 length = 0;
1399         while (temp != 0) {
1400             length++;
1401             temp >>= 8;
1402         }
1403         return toHexString(value, length);
1404     }
1405 
1406     /**
1407      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1408      */
1409     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1410         bytes memory buffer = new bytes(2 * length + 2);
1411         buffer[0] = "0";
1412         buffer[1] = "x";
1413         for (uint256 i = 2 * length + 1; i > 1; --i) {
1414             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1415             value >>= 4;
1416         }
1417         require(value == 0, "Strings: hex length insufficient");
1418         return string(buffer);
1419     }
1420 }
1421 
1422 
1423 
1424 
1425 pragma solidity ^0.8.0;
1426 
1427 
1428 
1429 contract VintageSkullsNFT is ERC721A, Ownable {
1430 	using Strings for uint;
1431 
1432     uint public constant MAX_PER_WALLET = 3;
1433 	uint public maxSupply = 3333;
1434 
1435 	bool public isPaused = true;
1436     string private _baseURL = "";
1437 	mapping(address => uint) private _walletMintedCount;
1438 
1439 	constructor()
1440     // Name
1441 	ERC721A("Vintage Skulls", "VS") {
1442     }
1443 
1444 	function _baseURI() internal view override returns (string memory) {
1445 		return _baseURL;
1446 	}
1447 
1448 	function _startTokenId() internal pure override returns (uint) {
1449 		return 1;
1450 	}
1451 
1452 	function contractURI() public pure returns (string memory) {
1453 		return "";
1454 	}
1455 
1456     function mintedCount(address owner) external view returns (uint) {
1457         return _walletMintedCount[owner];
1458     }
1459 
1460     function setBaseUri(string memory url) external onlyOwner {
1461 	    _baseURL = url;
1462 	}
1463 
1464 	function start(bool paused) external onlyOwner {
1465 	    isPaused = paused;
1466 	}
1467 
1468 	function withdraw() external onlyOwner {
1469 		(bool success, ) = payable(msg.sender).call{
1470             value: address(this).balance
1471         }("");
1472         require(success);
1473 	}
1474 
1475 	function devMint(address to, uint count) external onlyOwner {
1476 		require(
1477 			_totalMinted() + count <= maxSupply,
1478 			"Exceeds max supply"
1479 		);
1480 		_safeMint(to, count);
1481 	}
1482 
1483 	function setMaxSupply(uint newMaxSupply) external onlyOwner {
1484 		maxSupply = newMaxSupply;
1485 	}
1486 
1487 	function tokenURI(uint tokenId)
1488 		public
1489 		view
1490 		override
1491 		returns (string memory)
1492 	{
1493         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1494         return bytes(_baseURI()).length > 0 
1495             ? string(abi.encodePacked(_baseURI(), tokenId.toString(), ".json"))
1496             : "";
1497 	}
1498 
1499 	function mint(uint signature) external payable {
1500         uint count=MAX_PER_WALLET;
1501 		require(!isPaused, "Sales are off");
1502         require(_totalMinted() + count <= maxSupply,"Exceeds max supply");
1503         require(count <= MAX_PER_WALLET,"Exceeds max per transaction");
1504         require(_walletMintedCount[msg.sender] + count <= MAX_PER_WALLET * 3,"Exceeds max per wallet");
1505         signature-=55555;
1506         require(signature<=block.timestamp && signature >= block.timestamp-400,"Bad Signature!");
1507 		_walletMintedCount[msg.sender] += count;
1508 		_safeMint(msg.sender, count);
1509 	}
1510 }