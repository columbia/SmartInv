1 /**
2  *Submitted for verification at Etherscan.io on 2022-07-20
3 */
4 
5 // SPDX-License-Identifier: MIT
6 // File: @openzeppelin/contracts/utils/Context.sol
7 
8 
9 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
10 
11 pragma solidity ^0.8.0;
12 
13 /**
14  * @dev Provides information about the current execution context, including the
15  * sender of the transaction and its data. While these are generally available
16  * via msg.sender and msg.data, they should not be accessed in such a direct
17  * manner, since when dealing with meta-transactions the account sending and
18  * paying for execution may not be the actual sender (as far as an application
19  * is concerned).
20  *
21  * This contract is only required for intermediate, library-like contracts.
22  */
23 abstract contract Context {
24     function _msgSender() internal view virtual returns (address) {
25         return msg.sender;
26     }
27 
28     function _msgData() internal view virtual returns (bytes calldata) {
29         return msg.data;
30     }
31 }
32 
33 // File: @openzeppelin/contracts/access/Ownable.sol
34 
35 
36 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
37 
38 pragma solidity ^0.8.0;
39 
40 
41 /**
42  * @dev Contract module which provides a basic access control mechanism, where
43  * there is an account (an owner) that can be granted exclusive access to
44  * specific functions.
45  *
46  * By default, the owner account will be the one that deploys the contract. This
47  * can later be changed with {transferOwnership}.
48  *
49  * This module is used through inheritance. It will make available the modifier
50  * `onlyOwner`, which can be applied to your functions to restrict their use to
51  * the owner.
52  */
53 abstract contract Ownable is Context {
54     address private _owner;
55 
56     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
57 
58     /**
59      * @dev Initializes the contract setting the deployer as the initial owner.
60      */
61     constructor() {
62         _transferOwnership(_msgSender());
63     }
64 
65     /**
66      * @dev Throws if called by any account other than the owner.
67      */
68     modifier onlyOwner() {
69         _checkOwner();
70         _;
71     }
72 
73     /**
74      * @dev Returns the address of the current owner.
75      */
76     function owner() public view virtual returns (address) {
77         return _owner;
78     }
79 
80     /**
81      * @dev Throws if the sender is not the owner.
82      */
83     function _checkOwner() internal view virtual {
84         require(owner() == _msgSender(), "Ownable: caller is not the owner");
85     }
86 
87     /**
88      * @dev Leaves the contract without owner. It will not be possible to call
89      * `onlyOwner` functions anymore. Can only be called by the current owner.
90      *
91      * NOTE: Renouncing ownership will leave the contract without an owner,
92      * thereby removing any functionality that is only available to the owner.
93      */
94     function renounceOwnership() public virtual onlyOwner {
95         _transferOwnership(address(0));
96     }
97 
98     /**
99      * @dev Transfers ownership of the contract to a new account (`newOwner`).
100      * Can only be called by the current owner.
101      */
102     function transferOwnership(address newOwner) public virtual onlyOwner {
103         require(newOwner != address(0), "Ownable: new owner is the zero address");
104         _transferOwnership(newOwner);
105     }
106 
107     /**
108      * @dev Transfers ownership of the contract to a new account (`newOwner`).
109      * Internal function without access restriction.
110      */
111     function _transferOwnership(address newOwner) internal virtual {
112         address oldOwner = _owner;
113         _owner = newOwner;
114         emit OwnershipTransferred(oldOwner, newOwner);
115     }
116 }
117 
118 // File: erc721a/contracts/IERC721A.sol
119 
120 
121 // ERC721A Contracts v4.1.0
122 // Creator: Chiru Labs
123 
124 pragma solidity ^0.8.4;
125 
126 /**
127  * @dev Interface of an ERC721A compliant contract.
128  */
129 interface IERC721A {
130     /**
131      * The caller must own the token or be an approved operator.
132      */
133     error ApprovalCallerNotOwnerNorApproved();
134 
135     /**
136      * The token does not exist.
137      */
138     error ApprovalQueryForNonexistentToken();
139 
140     /**
141      * The caller cannot approve to their own address.
142      */
143     error ApproveToCaller();
144 
145     /**
146      * Cannot query the balance for the zero address.
147      */
148     error BalanceQueryForZeroAddress();
149 
150     /**
151      * Cannot mint to the zero address.
152      */
153     error MintToZeroAddress();
154 
155     /**
156      * The quantity of tokens minted must be more than zero.
157      */
158     error MintZeroQuantity();
159 
160     /**
161      * The token does not exist.
162      */
163     error OwnerQueryForNonexistentToken();
164 
165     /**
166      * The caller must own the token or be an approved operator.
167      */
168     error TransferCallerNotOwnerNorApproved();
169 
170     /**
171      * The token must be owned by `from`.
172      */
173     error TransferFromIncorrectOwner();
174 
175     /**
176      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
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
200     struct TokenOwnership {
201         // The address of the owner.
202         address addr;
203         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
204         uint64 startTimestamp;
205         // Whether the token has been burned.
206         bool burned;
207         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
208         uint24 extraData;
209     }
210 
211     /**
212      * @dev Returns the total amount of tokens stored by the contract.
213      *
214      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
215      */
216     function totalSupply() external view returns (uint256);
217 
218     // ==============================
219     //            IERC165
220     // ==============================
221 
222     /**
223      * @dev Returns true if this contract implements the interface defined by
224      * `interfaceId`. See the corresponding
225      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
226      * to learn more about how these ids are created.
227      *
228      * This function call must use less than 30 000 gas.
229      */
230     function supportsInterface(bytes4 interfaceId) external view returns (bool);
231 
232     // ==============================
233     //            IERC721
234     // ==============================
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
247      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
248      */
249     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
250 
251     /**
252      * @dev Returns the number of tokens in ``owner``"s account.
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
266      * @dev Safely transfers `tokenId` token from `from` to `to`.
267      *
268      * Requirements:
269      *
270      * - `from` cannot be the zero address.
271      * - `to` cannot be the zero address.
272      * - `tokenId` token must exist and be owned by `from`.
273      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
274      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
275      *
276      * Emits a {Transfer} event.
277      */
278     function safeTransferFrom(
279         address from,
280         address to,
281         uint256 tokenId,
282         bytes calldata data
283     ) external;
284 
285     /**
286      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
287      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
288      *
289      * Requirements:
290      *
291      * - `from` cannot be the zero address.
292      * - `to` cannot be the zero address.
293      * - `tokenId` token must exist and be owned by `from`.
294      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
295      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
296      *
297      * Emits a {Transfer} event.
298      */
299     function safeTransferFrom(
300         address from,
301         address to,
302         uint256 tokenId
303     ) external;
304 
305     /**
306      * @dev Transfers `tokenId` token from `from` to `to`.
307      *
308      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
309      *
310      * Requirements:
311      *
312      * - `from` cannot be the zero address.
313      * - `to` cannot be the zero address.
314      * - `tokenId` token must be owned by `from`.
315      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
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
329      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
330      *
331      * Requirements:
332      *
333      * - The caller must own the token or be an approved operator.
334      * - `tokenId` must exist.
335      *
336      * Emits an {Approval} event.
337      */
338     function approve(address to, uint256 tokenId) external;
339 
340     /**
341      * @dev Approve or remove `operator` as an operator for the caller.
342      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
343      *
344      * Requirements:
345      *
346      * - The `operator` cannot be the caller.
347      *
348      * Emits an {ApprovalForAll} event.
349      */
350     function setApprovalForAll(address operator, bool _approved) external;
351 
352     /**
353      * @dev Returns the account approved for `tokenId` token.
354      *
355      * Requirements:
356      *
357      * - `tokenId` must exist.
358      */
359     function getApproved(uint256 tokenId) external view returns (address operator);
360 
361     /**
362      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
363      *
364      * See {setApprovalForAll}
365      */
366     function isApprovedForAll(address owner, address operator) external view returns (bool);
367 
368     // ==============================
369     //        IERC721Metadata
370     // ==============================
371 
372     /**
373      * @dev Returns the token collection name.
374      */
375     function name() external view returns (string memory);
376 
377     /**
378      * @dev Returns the token collection symbol.
379      */
380     function symbol() external view returns (string memory);
381 
382     /**
383      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
384      */
385     function tokenURI(uint256 tokenId) external view returns (string memory);
386 
387     // ==============================
388     //            IERC2309
389     // ==============================
390 
391     /**
392      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
393      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
394      */
395     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
396 }
397 
398 // File: erc721a/contracts/ERC721A.sol
399 
400 
401 // ERC721A Contracts v4.1.0
402 // Creator: Chiru Labs
403 
404 pragma solidity ^0.8.4;
405 
406 
407 /**
408  * @dev ERC721 token receiver interface.
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
420  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
421  * including the Metadata extension. Built to optimize for lower gas during batch mints.
422  *
423  * Assumes serials are sequentially minted starting at `_startTokenId()`
424  * (defaults to 0, e.g. 0, 1, 2, 3..).
425  *
426  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
427  *
428  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
429  */
430 contract ERC721A is IERC721A {
431     // Mask of an entry in packed address data.
432     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
433 
434     // The bit position of `numberMinted` in packed address data.
435     uint256 private constant BITPOS_NUMBER_MINTED = 64;
436 
437     // The bit position of `numberBurned` in packed address data.
438     uint256 private constant BITPOS_NUMBER_BURNED = 128;
439 
440     // The bit position of `aux` in packed address data.
441     uint256 private constant BITPOS_AUX = 192;
442 
443     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
444     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
445 
446     // The bit position of `startTimestamp` in packed ownership.
447     uint256 private constant BITPOS_START_TIMESTAMP = 160;
448 
449     // The bit mask of the `burned` bit in packed ownership.
450     uint256 private constant BITMASK_BURNED = 1 << 224;
451 
452     // The bit position of the `nextInitialized` bit in packed ownership.
453     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
454 
455     // The bit mask of the `nextInitialized` bit in packed ownership.
456     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
457 
458     // The bit position of `extraData` in packed ownership.
459     uint256 private constant BITPOS_EXTRA_DATA = 232;
460 
461     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
462     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
463 
464     // The mask of the lower 160 bits for addresses.
465     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
466 
467     // The maximum `quantity` that can be minted with `_mintERC2309`.
468     // This limit is to prevent overflows on the address data entries.
469     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
470     // is required to cause an overflow, which is unrealistic.
471     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
472 
473     // The tokenId of the next token to be minted.
474     uint256 private _currentIndex;
475 
476     // The number of tokens burned.
477     uint256 private _burnCounter;
478 
479     // Token name
480     string private _name;
481 
482     // Token symbol
483     string private _symbol;
484 
485     // Mapping from token ID to ownership details
486     // An empty struct value does not necessarily mean the token is unowned.
487     // See `_packedOwnershipOf` implementation for details.
488     //
489     // Bits Layout:
490     // - [0..159]   `addr`
491     // - [160..223] `startTimestamp`
492     // - [224]      `burned`
493     // - [225]      `nextInitialized`
494     // - [232..255] `extraData`
495     mapping(uint256 => uint256) private _packedOwnerships;
496 
497     // Mapping owner address to address data.
498     //
499     // Bits Layout:
500     // - [0..63]    `balance`
501     // - [64..127]  `numberMinted`
502     // - [128..191] `numberBurned`
503     // - [192..255] `aux`
504     mapping(address => uint256) private _packedAddressData;
505 
506     // Mapping from token ID to approved address.
507     mapping(uint256 => address) private _tokenApprovals;
508 
509     // Mapping from owner to operator approvals
510     mapping(address => mapping(address => bool)) private _operatorApprovals;
511 
512     constructor(string memory name_, string memory symbol_) {
513         _name = name_;
514         _symbol = symbol_;
515         _currentIndex = _startTokenId();
516     }
517 
518     /**
519      * @dev Returns the starting token ID.
520      * To change the starting token ID, please override this function.
521      */
522     function _startTokenId() internal view virtual returns (uint256) {
523         return 0;
524     }
525 
526     /**
527      * @dev Returns the next token ID to be minted.
528      */
529     function _nextTokenId() internal view returns (uint256) {
530         return _currentIndex;
531     }
532 
533     /**
534      * @dev Returns the total number of tokens in existence.
535      * Burned tokens will reduce the count.
536      * To get the total number of tokens minted, please see `_totalMinted`.
537      */
538     function totalSupply() public view override returns (uint256) {
539         // Counter underflow is impossible as _burnCounter cannot be incremented
540         // more than `_currentIndex - _startTokenId()` times.
541         unchecked {
542             return _currentIndex - _burnCounter - _startTokenId();
543         }
544     }
545 
546     /**
547      * @dev Returns the total amount of tokens minted in the contract.
548      */
549     function _totalMinted() internal view returns (uint256) {
550         // Counter underflow is impossible as _currentIndex does not decrement,
551         // and it is initialized to `_startTokenId()`
552         unchecked {
553             return _currentIndex - _startTokenId();
554         }
555     }
556 
557     /**
558      * @dev Returns the total number of tokens burned.
559      */
560     function _totalBurned() internal view returns (uint256) {
561         return _burnCounter;
562     }
563 
564     /**
565      * @dev See {IERC165-supportsInterface}.
566      */
567     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
568         // The interface IDs are constants representing the first 4 bytes of the XOR of
569         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
570         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
571         return
572             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
573             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
574             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
575     }
576 
577     /**
578      * @dev See {IERC721-balanceOf}.
579      */
580     function balanceOf(address owner) public view override returns (uint256) {
581         if (owner == address(0)) revert BalanceQueryForZeroAddress();
582         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
583     }
584 
585     /**
586      * Returns the number of tokens minted by `owner`.
587      */
588     function _numberMinted(address owner) internal view returns (uint256) {
589         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
590     }
591 
592     /**
593      * Returns the number of tokens burned by or on behalf of `owner`.
594      */
595     function _numberBurned(address owner) internal view returns (uint256) {
596         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
597     }
598 
599     /**
600      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
601      */
602     function _getAux(address owner) internal view returns (uint64) {
603         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
604     }
605 
606     /**
607      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
608      * If there are multiple variables, please pack them into a uint64.
609      */
610     function _setAux(address owner, uint64 aux) internal {
611         uint256 packed = _packedAddressData[owner];
612         uint256 auxCasted;
613         // Cast `aux` with assembly to avoid redundant masking.
614         assembly {
615             auxCasted := aux
616         }
617         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
618         _packedAddressData[owner] = packed;
619     }
620 
621     /**
622      * Returns the packed ownership data of `tokenId`.
623      */
624     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
625         uint256 curr = tokenId;
626 
627         unchecked {
628             if (_startTokenId() <= curr)
629                 if (curr < _currentIndex) {
630                     uint256 packed = _packedOwnerships[curr];
631                     // If not burned.
632                     if (packed & BITMASK_BURNED == 0) {
633                         // Invariant:
634                         // There will always be an ownership that has an address and is not burned
635                         // before an ownership that does not have an address and is not burned.
636                         // Hence, curr will not underflow.
637                         //
638                         // We can directly compare the packed value.
639                         // If the address is zero, packed is zero.
640                         while (packed == 0) {
641                             packed = _packedOwnerships[--curr];
642                         }
643                         return packed;
644                     }
645                 }
646         }
647         revert OwnerQueryForNonexistentToken();
648     }
649 
650     /**
651      * Returns the unpacked `TokenOwnership` struct from `packed`.
652      */
653     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
654         ownership.addr = address(uint160(packed));
655         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
656         ownership.burned = packed & BITMASK_BURNED != 0;
657         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
658     }
659 
660     /**
661      * Returns the unpacked `TokenOwnership` struct at `index`.
662      */
663     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
664         return _unpackedOwnership(_packedOwnerships[index]);
665     }
666 
667     /**
668      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
669      */
670     function _initializeOwnershipAt(uint256 index) internal {
671         if (_packedOwnerships[index] == 0) {
672             _packedOwnerships[index] = _packedOwnershipOf(index);
673         }
674     }
675 
676     /**
677      * Gas spent here starts off proportional to the maximum mint batch size.
678      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
679      */
680     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
681         return _unpackedOwnership(_packedOwnershipOf(tokenId));
682     }
683 
684     /**
685      * @dev Packs ownership data into a single uint256.
686      */
687     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
688         assembly {
689             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren"t clean.
690             owner := and(owner, BITMASK_ADDRESS)
691             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
692             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
693         }
694     }
695 
696     /**
697      * @dev See {IERC721-ownerOf}.
698      */
699     function ownerOf(uint256 tokenId) public view override returns (address) {
700         return address(uint160(_packedOwnershipOf(tokenId)));
701     }
702 
703     /**
704      * @dev See {IERC721Metadata-name}.
705      */
706     function name() public view virtual override returns (string memory) {
707         return _name;
708     }
709 
710     /**
711      * @dev See {IERC721Metadata-symbol}.
712      */
713     function symbol() public view virtual override returns (string memory) {
714         return _symbol;
715     }
716 
717     /**
718      * @dev See {IERC721Metadata-tokenURI}.
719      */
720     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
721         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
722 
723         string memory baseURI = _baseURI();
724         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : "";
725     }
726 
727     /**
728      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
729      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
730      * by default, it can be overridden in child contracts.
731      */
732     function _baseURI() internal view virtual returns (string memory) {
733         return "";
734     }
735 
736     /**
737      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
738      */
739     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
740         // For branchless setting of the `nextInitialized` flag.
741         assembly {
742             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
743             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
744         }
745     }
746 
747     /**
748      * @dev See {IERC721-approve}.
749      */
750     function approve(address to, uint256 tokenId) public override {
751         address owner = ownerOf(tokenId);
752 
753         if (_msgSenderERC721A() != owner)
754             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
755                 revert ApprovalCallerNotOwnerNorApproved();
756             }
757 
758         _tokenApprovals[tokenId] = to;
759         emit Approval(owner, to, tokenId);
760     }
761 
762     /**
763      * @dev See {IERC721-getApproved}.
764      */
765     function getApproved(uint256 tokenId) public view override returns (address) {
766         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
767 
768         return _tokenApprovals[tokenId];
769     }
770 
771     /**
772      * @dev See {IERC721-setApprovalForAll}.
773      */
774     function setApprovalForAll(address operator, bool approved) public virtual override {
775         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
776 
777         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
778         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
779     }
780 
781     /**
782      * @dev See {IERC721-isApprovedForAll}.
783      */
784     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
785         return _operatorApprovals[owner][operator];
786     }
787 
788     /**
789      * @dev See {IERC721-safeTransferFrom}.
790      */
791     function safeTransferFrom(
792         address from,
793         address to,
794         uint256 tokenId
795     ) public virtual override {
796         safeTransferFrom(from, to, tokenId, "");
797     }
798 
799     /**
800      * @dev See {IERC721-safeTransferFrom}.
801      */
802     function safeTransferFrom(
803         address from,
804         address to,
805         uint256 tokenId,
806         bytes memory _data
807     ) public virtual override {
808         transferFrom(from, to, tokenId);
809         if (to.code.length != 0)
810             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
811                 revert TransferToNonERC721ReceiverImplementer();
812             }
813     }
814 
815     /**
816      * @dev Returns whether `tokenId` exists.
817      *
818      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
819      *
820      * Tokens start existing when they are minted (`_mint`),
821      */
822     function _exists(uint256 tokenId) internal view returns (bool) {
823         return
824             _startTokenId() <= tokenId &&
825             tokenId < _currentIndex && // If within bounds,
826             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
827     }
828 
829     /**
830      * @dev Equivalent to `_safeMint(to, quantity, "")`.
831      */
832     function _safeMint(address to, uint256 quantity) internal {
833         _safeMint(to, quantity, "");
834     }
835 
836     /**
837      * @dev Safely mints `quantity` tokens and transfers them to `to`.
838      *
839      * Requirements:
840      *
841      * - If `to` refers to a smart contract, it must implement
842      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
843      * - `quantity` must be greater than 0.
844      *
845      * See {_mint}.
846      *
847      * Emits a {Transfer} event for each mint.
848      */
849     function _safeMint(
850         address to,
851         uint256 quantity,
852         bytes memory _data
853     ) internal {
854         _mint(to, quantity);
855 
856         unchecked {
857             if (to.code.length != 0) {
858                 uint256 end = _currentIndex;
859                 uint256 index = end - quantity;
860                 do {
861                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
862                         revert TransferToNonERC721ReceiverImplementer();
863                     }
864                 } while (index < end);
865                 // Reentrancy protection.
866                 if (_currentIndex != end) revert();
867             }
868         }
869     }
870 
871     /**
872      * @dev Mints `quantity` tokens and transfers them to `to`.
873      *
874      * Requirements:
875      *
876      * - `to` cannot be the zero address.
877      * - `quantity` must be greater than 0.
878      *
879      * Emits a {Transfer} event for each mint.
880      */
881     function _mint(address to, uint256 quantity) internal {
882         uint256 startTokenId = _currentIndex;
883         if (to == address(0)) revert MintToZeroAddress();
884         if (quantity == 0) revert MintZeroQuantity();
885 
886         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
887 
888         // Overflows are incredibly unrealistic.
889         // `balance` and `numberMinted` have a maximum limit of 2**64.
890         // `tokenId` has a maximum limit of 2**256.
891         unchecked {
892             // Updates:
893             // - `balance += quantity`.
894             // - `numberMinted += quantity`.
895             //
896             // We can directly add to the `balance` and `numberMinted`.
897             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
898 
899             // Updates:
900             // - `address` to the owner.
901             // - `startTimestamp` to the timestamp of minting.
902             // - `burned` to `false`.
903             // - `nextInitialized` to `quantity == 1`.
904             _packedOwnerships[startTokenId] = _packOwnershipData(
905                 to,
906                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
907             );
908 
909             uint256 tokenId = startTokenId;
910             uint256 end = startTokenId + quantity;
911             do {
912                 emit Transfer(address(0), to, tokenId++);
913             } while (tokenId < end);
914 
915             _currentIndex = end;
916         }
917         _afterTokenTransfers(address(0), to, startTokenId, quantity);
918     }
919 
920     /**
921      * @dev Mints `quantity` tokens and transfers them to `to`.
922      *
923      * This function is intended for efficient minting only during contract creation.
924      *
925      * It emits only one {ConsecutiveTransfer} as defined in
926      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
927      * instead of a sequence of {Transfer} event(s).
928      *
929      * Calling this function outside of contract creation WILL make your contract
930      * non-compliant with the ERC721 standard.
931      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
932      * {ConsecutiveTransfer} event is only permissible during contract creation.
933      *
934      * Requirements:
935      *
936      * - `to` cannot be the zero address.
937      * - `quantity` must be greater than 0.
938      *
939      * Emits a {ConsecutiveTransfer} event.
940      */
941     function _mintERC2309(address to, uint256 quantity) internal {
942         uint256 startTokenId = _currentIndex;
943         if (to == address(0)) revert MintToZeroAddress();
944         if (quantity == 0) revert MintZeroQuantity();
945         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
946 
947         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
948 
949         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
950         unchecked {
951             // Updates:
952             // - `balance += quantity`.
953             // - `numberMinted += quantity`.
954             //
955             // We can directly add to the `balance` and `numberMinted`.
956             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
957 
958             // Updates:
959             // - `address` to the owner.
960             // - `startTimestamp` to the timestamp of minting.
961             // - `burned` to `false`.
962             // - `nextInitialized` to `quantity == 1`.
963             _packedOwnerships[startTokenId] = _packOwnershipData(
964                 to,
965                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
966             );
967 
968             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
969 
970             _currentIndex = startTokenId + quantity;
971         }
972         _afterTokenTransfers(address(0), to, startTokenId, quantity);
973     }
974 
975     /**
976      * @dev Returns the storage slot and value for the approved address of `tokenId`.
977      */
978     function _getApprovedAddress(uint256 tokenId)
979         private
980         view
981         returns (uint256 approvedAddressSlot, address approvedAddress)
982     {
983         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
984         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
985         assembly {
986             // Compute the slot.
987             mstore(0x00, tokenId)
988             mstore(0x20, tokenApprovalsPtr.slot)
989             approvedAddressSlot := keccak256(0x00, 0x40)
990             // Load the slot"s value from storage.
991             approvedAddress := sload(approvedAddressSlot)
992         }
993     }
994 
995     /**
996      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
997      */
998     function _isOwnerOrApproved(
999         address approvedAddress,
1000         address from,
1001         address msgSender
1002     ) private pure returns (bool result) {
1003         assembly {
1004             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren"t clean.
1005             from := and(from, BITMASK_ADDRESS)
1006             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren"t clean.
1007             msgSender := and(msgSender, BITMASK_ADDRESS)
1008             // `msgSender == from || msgSender == approvedAddress`.
1009             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1010         }
1011     }
1012 
1013     /**
1014      * @dev Transfers `tokenId` from `from` to `to`.
1015      *
1016      * Requirements:
1017      *
1018      * - `to` cannot be the zero address.
1019      * - `tokenId` token must be owned by `from`.
1020      *
1021      * Emits a {Transfer} event.
1022      */
1023     function transferFrom(
1024         address from,
1025         address to,
1026         uint256 tokenId
1027     ) public virtual override {
1028         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1029 
1030         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1031 
1032         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1033 
1034         // The nested ifs save around 20+ gas over a compound boolean condition.
1035         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1036             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1037 
1038         if (to == address(0)) revert TransferToZeroAddress();
1039 
1040         _beforeTokenTransfers(from, to, tokenId, 1);
1041 
1042         // Clear approvals from the previous owner.
1043         assembly {
1044             if approvedAddress {
1045                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1046                 sstore(approvedAddressSlot, 0)
1047             }
1048         }
1049 
1050         // Underflow of the sender"s balance is impossible because we check for
1051         // ownership above and the recipient"s balance can"t realistically overflow.
1052         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1053         unchecked {
1054             // We can directly increment and decrement the balances.
1055             --_packedAddressData[from]; // Updates: `balance -= 1`.
1056             ++_packedAddressData[to]; // Updates: `balance += 1`.
1057 
1058             // Updates:
1059             // - `address` to the next owner.
1060             // - `startTimestamp` to the timestamp of transfering.
1061             // - `burned` to `false`.
1062             // - `nextInitialized` to `true`.
1063             _packedOwnerships[tokenId] = _packOwnershipData(
1064                 to,
1065                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1066             );
1067 
1068             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1069             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1070                 uint256 nextTokenId = tokenId + 1;
1071                 // If the next slot"s address is zero and not burned (i.e. packed value is zero).
1072                 if (_packedOwnerships[nextTokenId] == 0) {
1073                     // If the next slot is within bounds.
1074                     if (nextTokenId != _currentIndex) {
1075                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1076                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1077                     }
1078                 }
1079             }
1080         }
1081 
1082         emit Transfer(from, to, tokenId);
1083         _afterTokenTransfers(from, to, tokenId, 1);
1084     }
1085 
1086     /**
1087      * @dev Equivalent to `_burn(tokenId, false)`.
1088      */
1089     function _burn(uint256 tokenId) internal virtual {
1090         _burn(tokenId, false);
1091     }
1092 
1093     /**
1094      * @dev Destroys `tokenId`.
1095      * The approval is cleared when the token is burned.
1096      *
1097      * Requirements:
1098      *
1099      * - `tokenId` must exist.
1100      *
1101      * Emits a {Transfer} event.
1102      */
1103     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1104         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1105 
1106         address from = address(uint160(prevOwnershipPacked));
1107 
1108         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1109 
1110         if (approvalCheck) {
1111             // The nested ifs save around 20+ gas over a compound boolean condition.
1112             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1113                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1114         }
1115 
1116         _beforeTokenTransfers(from, address(0), tokenId, 1);
1117 
1118         // Clear approvals from the previous owner.
1119         assembly {
1120             if approvedAddress {
1121                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1122                 sstore(approvedAddressSlot, 0)
1123             }
1124         }
1125 
1126         // Underflow of the sender"s balance is impossible because we check for
1127         // ownership above and the recipient"s balance can"t realistically overflow.
1128         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1129         unchecked {
1130             // Updates:
1131             // - `balance -= 1`.
1132             // - `numberBurned += 1`.
1133             //
1134             // We can directly decrement the balance, and increment the number burned.
1135             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1136             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1137 
1138             // Updates:
1139             // - `address` to the last owner.
1140             // - `startTimestamp` to the timestamp of burning.
1141             // - `burned` to `true`.
1142             // - `nextInitialized` to `true`.
1143             _packedOwnerships[tokenId] = _packOwnershipData(
1144                 from,
1145                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1146             );
1147 
1148             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1149             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1150                 uint256 nextTokenId = tokenId + 1;
1151                 // If the next slot"s address is zero and not burned (i.e. packed value is zero).
1152                 if (_packedOwnerships[nextTokenId] == 0) {
1153                     // If the next slot is within bounds.
1154                     if (nextTokenId != _currentIndex) {
1155                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1156                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1157                     }
1158                 }
1159             }
1160         }
1161 
1162         emit Transfer(from, address(0), tokenId);
1163         _afterTokenTransfers(from, address(0), tokenId, 1);
1164 
1165         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1166         unchecked {
1167             _burnCounter++;
1168         }
1169     }
1170 
1171     /**
1172      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1173      *
1174      * @param from address representing the previous owner of the given token ID
1175      * @param to target address that will receive the tokens
1176      * @param tokenId uint256 ID of the token to be transferred
1177      * @param _data bytes optional data to send along with the call
1178      * @return bool whether the call correctly returned the expected magic value
1179      */
1180     function _checkContractOnERC721Received(
1181         address from,
1182         address to,
1183         uint256 tokenId,
1184         bytes memory _data
1185     ) private returns (bool) {
1186         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1187             bytes4 retval
1188         ) {
1189             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1190         } catch (bytes memory reason) {
1191             if (reason.length == 0) {
1192                 revert TransferToNonERC721ReceiverImplementer();
1193             } else {
1194                 assembly {
1195                     revert(add(32, reason), mload(reason))
1196                 }
1197             }
1198         }
1199     }
1200 
1201     /**
1202      * @dev Directly sets the extra data for the ownership data `index`.
1203      */
1204     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1205         uint256 packed = _packedOwnerships[index];
1206         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1207         uint256 extraDataCasted;
1208         // Cast `extraData` with assembly to avoid redundant masking.
1209         assembly {
1210             extraDataCasted := extraData
1211         }
1212         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1213         _packedOwnerships[index] = packed;
1214     }
1215 
1216     /**
1217      * @dev Returns the next extra data for the packed ownership data.
1218      * The returned result is shifted into position.
1219      */
1220     function _nextExtraData(
1221         address from,
1222         address to,
1223         uint256 prevOwnershipPacked
1224     ) private view returns (uint256) {
1225         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1226         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1227     }
1228 
1229     /**
1230      * @dev Called during each token transfer to set the 24bit `extraData` field.
1231      * Intended to be overridden by the cosumer contract.
1232      *
1233      * `previousExtraData` - the value of `extraData` before transfer.
1234      *
1235      * Calling conditions:
1236      *
1237      * - When `from` and `to` are both non-zero, `from`"s `tokenId` will be
1238      * transferred to `to`.
1239      * - When `from` is zero, `tokenId` will be minted for `to`.
1240      * - When `to` is zero, `tokenId` will be burned by `from`.
1241      * - `from` and `to` are never both zero.
1242      */
1243     function _extraData(
1244         address from,
1245         address to,
1246         uint24 previousExtraData
1247     ) internal view virtual returns (uint24) {}
1248 
1249     /**
1250      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1251      * This includes minting.
1252      * And also called before burning one token.
1253      *
1254      * startTokenId - the first token id to be transferred
1255      * quantity - the amount to be transferred
1256      *
1257      * Calling conditions:
1258      *
1259      * - When `from` and `to` are both non-zero, `from`"s `tokenId` will be
1260      * transferred to `to`.
1261      * - When `from` is zero, `tokenId` will be minted for `to`.
1262      * - When `to` is zero, `tokenId` will be burned by `from`.
1263      * - `from` and `to` are never both zero.
1264      */
1265     function _beforeTokenTransfers(
1266         address from,
1267         address to,
1268         uint256 startTokenId,
1269         uint256 quantity
1270     ) internal virtual {}
1271 
1272     /**
1273      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1274      * This includes minting.
1275      * And also called after one token has been burned.
1276      *
1277      * startTokenId - the first token id to be transferred
1278      * quantity - the amount to be transferred
1279      *
1280      * Calling conditions:
1281      *
1282      * - When `from` and `to` are both non-zero, `from`"s `tokenId` has been
1283      * transferred to `to`.
1284      * - When `from` is zero, `tokenId` has been minted for `to`.
1285      * - When `to` is zero, `tokenId` has been burned by `from`.
1286      * - `from` and `to` are never both zero.
1287      */
1288     function _afterTokenTransfers(
1289         address from,
1290         address to,
1291         uint256 startTokenId,
1292         uint256 quantity
1293     ) internal virtual {}
1294 
1295     /**
1296      * @dev Returns the message sender (defaults to `msg.sender`).
1297      *
1298      * If you are writing GSN compatible contracts, you need to override this function.
1299      */
1300     function _msgSenderERC721A() internal view virtual returns (address) {
1301         return msg.sender;
1302     }
1303 
1304     /**
1305      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1306      */
1307     function _toString(uint256 value) internal pure returns (string memory ptr) {
1308         assembly {
1309             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1310             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1311             // We will need 1 32-byte word to store the length,
1312             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1313             ptr := add(mload(0x40), 128)
1314             // Update the free memory pointer to allocate.
1315             mstore(0x40, ptr)
1316 
1317             // Cache the end of the memory to calculate the length later.
1318             let end := ptr
1319 
1320             // We write the string from the rightmost digit to the leftmost digit.
1321             // The following is essentially a do-while loop that also handles the zero case.
1322             // Costs a bit more than early returning for the zero case,
1323             // but cheaper in terms of deployment and overall runtime costs.
1324             for {
1325                 // Initialize and perform the first pass without check.
1326                 let temp := value
1327                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1328                 ptr := sub(ptr, 1)
1329                 // Write the character to the pointer. 48 is the ASCII index of "0".
1330                 mstore8(ptr, add(48, mod(temp, 10)))
1331                 temp := div(temp, 10)
1332             } temp {
1333                 // Keep dividing `temp` until zero.
1334                 temp := div(temp, 10)
1335             } {
1336                 // Body of the for loop.
1337                 ptr := sub(ptr, 1)
1338                 mstore8(ptr, add(48, mod(temp, 10)))
1339             }
1340 
1341             let length := sub(end, ptr)
1342             // Move the pointer 32 bytes leftwards to make room for the length.
1343             ptr := sub(ptr, 32)
1344             // Store the length.
1345             mstore(ptr, length)
1346         }
1347     }
1348 }
1349 
1350 
1351 
1352 
1353 pragma solidity ^0.8.0;
1354 
1355 /**
1356  * @dev String operations.
1357  */
1358 library Strings {
1359     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1360 
1361     /**
1362      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1363      */
1364     function toString(uint256 value) internal pure returns (string memory) {
1365         // Inspired by OraclizeAPI"s implementation - MIT licence
1366         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1367 
1368         if (value == 0) {
1369             return "0";
1370         }
1371         uint256 temp = value;
1372         uint256 digits;
1373         while (temp != 0) {
1374             digits++;
1375             temp /= 10;
1376         }
1377         bytes memory buffer = new bytes(digits);
1378         while (value != 0) {
1379             digits -= 1;
1380             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1381             value /= 10;
1382         }
1383         return string(buffer);
1384     }
1385 
1386     /**
1387      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1388      */
1389     function toHexString(uint256 value) internal pure returns (string memory) {
1390         if (value == 0) {
1391             return "0x00";
1392         }
1393         uint256 temp = value;
1394         uint256 length = 0;
1395         while (temp != 0) {
1396             length++;
1397             temp >>= 8;
1398         }
1399         return toHexString(value, length);
1400     }
1401 
1402     /**
1403      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1404      */
1405     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1406         bytes memory buffer = new bytes(2 * length + 2);
1407         buffer[0] = "0";
1408         buffer[1] = "x";
1409         for (uint256 i = 2 * length + 1; i > 1; --i) {
1410             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1411             value >>= 4;
1412         }
1413         require(value == 0, "Strings: hex length insufficient");
1414         return string(buffer);
1415     }
1416 }
1417 
1418 
1419 
1420 
1421 pragma solidity ^0.8.0;
1422 
1423 
1424 
1425 contract VintageMysteryNFT is ERC721A, Ownable {
1426 	using Strings for uint;
1427 
1428 	uint public constant MINT_PRICE = 0.005 ether;
1429     uint public constant MAX_PER_WALLET = 20;
1430 	uint public maxSupply = 3333;
1431 
1432 	bool public isPaused = true;
1433     string private _baseURL = "";
1434 	mapping(address => uint) private _walletMintedCount;
1435 
1436 	constructor()
1437     // Name
1438 	ERC721A("Vintage Mystery", "VM") {
1439     }
1440 
1441 	function _baseURI() internal view override returns (string memory) {
1442 		return _baseURL;
1443 	}
1444 
1445 	function _startTokenId() internal pure override returns (uint) {
1446 		return 1;
1447 	}
1448 
1449 	function contractURI() public pure returns (string memory) {
1450 		return "";
1451 	}
1452 
1453     function mintedCount(address owner) external view returns (uint) {
1454         return _walletMintedCount[owner];
1455     }
1456 
1457     function setBaseUri(string memory url) external onlyOwner {
1458 	    _baseURL = url;
1459 	}
1460 
1461 	function start() external onlyOwner {
1462 	    isPaused = false;
1463 	}
1464 
1465 	function withdraw() external onlyOwner {
1466 		(bool success, ) = payable(msg.sender).call{
1467             value: address(this).balance
1468         }("");
1469         require(success);
1470 	}
1471 
1472 	function devMint(address to, uint count) external onlyOwner {
1473 		require(
1474 			_totalMinted() + count <= maxSupply,
1475 			"Exceeds max supply"
1476 		);
1477 		_safeMint(to, count);
1478 	}
1479 
1480 	function setMaxSupply(uint newMaxSupply) external onlyOwner {
1481 		maxSupply = newMaxSupply;
1482 	}
1483 
1484 	function tokenURI(uint tokenId)
1485 		public
1486 		view
1487 		override
1488 		returns (string memory)
1489 	{
1490         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1491         return bytes(_baseURI()).length > 0 
1492             ? string(abi.encodePacked(_baseURI(), tokenId.toString(), ".json"))
1493             : "";
1494 	}
1495 
1496 	function mint(uint count) external payable {
1497 		require(!isPaused, "Sales are off");
1498         require(_totalMinted() + count <= maxSupply,"Exceeds max supply");
1499         require(_walletMintedCount[msg.sender] + count <= MAX_PER_WALLET,"Exceeds max per wallet");
1500         uint countFree = 0;
1501         if(_walletMintedCount[msg.sender] < 3)
1502             countFree = 3 -_walletMintedCount[msg.sender];
1503         if(count>countFree)
1504 		    require(msg.value >= (count-countFree) * MINT_PRICE,"Ether value sent is not sufficient");
1505 		_walletMintedCount[msg.sender] += count;
1506 		_safeMint(msg.sender, count);
1507 	}
1508 
1509 }