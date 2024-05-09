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
114 // File: contracts/IERC721A.sol
115 
116 
117 // ERC721A Contracts v4.1.0
118 // Creator: Chiru Labs
119 
120 pragma solidity ^0.8.4;
121 
122 /**
123  * @dev Interface of an ERC721A compliant contract.
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
137      * The caller cannot approve to their own address.
138      */
139     error ApproveToCaller();
140 
141     /**
142      * Cannot query the balance for the zero address.
143      */
144     error BalanceQueryForZeroAddress();
145 
146     /**
147      * Cannot mint to the zero address.
148      */
149     error MintToZeroAddress();
150 
151     /**
152      * The quantity of tokens minted must be more than zero.
153      */
154     error MintZeroQuantity();
155 
156     /**
157      * The token does not exist.
158      */
159     error OwnerQueryForNonexistentToken();
160 
161     /**
162      * The caller must own the token or be an approved operator.
163      */
164     error TransferCallerNotOwnerNorApproved();
165 
166     /**
167      * The token must be owned by `from`.
168      */
169     error TransferFromIncorrectOwner();
170 
171     /**
172      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
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
196     struct TokenOwnership {
197         // The address of the owner.
198         address addr;
199         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
200         uint64 startTimestamp;
201         // Whether the token has been burned.
202         bool burned;
203         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
204         uint24 extraData;
205     }
206 
207     /**
208      * @dev Returns the total amount of tokens stored by the contract.
209      *
210      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
211      */
212     function totalSupply() external view returns (uint256);
213 
214     // ==============================
215     //            IERC165
216     // ==============================
217 
218     /**
219      * @dev Returns true if this contract implements the interface defined by
220      * `interfaceId`. See the corresponding
221      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
222      * to learn more about how these ids are created.
223      *
224      * This function call must use less than 30 000 gas.
225      */
226     function supportsInterface(bytes4 interfaceId) external view returns (bool);
227 
228     // ==============================
229     //            IERC721
230     // ==============================
231 
232     /**
233      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
234      */
235     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
236 
237     /**
238      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
239      */
240     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
241 
242     /**
243      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
244      */
245     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
246 
247     /**
248      * @dev Returns the number of tokens in ``owner``'s account.
249      */
250     function balanceOf(address owner) external view returns (uint256 balance);
251 
252     /**
253      * @dev Returns the owner of the `tokenId` token.
254      *
255      * Requirements:
256      *
257      * - `tokenId` must exist.
258      */
259     function ownerOf(uint256 tokenId) external view returns (address owner);
260 
261     /**
262      * @dev Safely transfers `tokenId` token from `from` to `to`.
263      *
264      * Requirements:
265      *
266      * - `from` cannot be the zero address.
267      * - `to` cannot be the zero address.
268      * - `tokenId` token must exist and be owned by `from`.
269      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
270      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
271      *
272      * Emits a {Transfer} event.
273      */
274     function safeTransferFrom(
275         address from,
276         address to,
277         uint256 tokenId,
278         bytes calldata data
279     ) external;
280 
281     /**
282      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
283      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
284      *
285      * Requirements:
286      *
287      * - `from` cannot be the zero address.
288      * - `to` cannot be the zero address.
289      * - `tokenId` token must exist and be owned by `from`.
290      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
291      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
292      *
293      * Emits a {Transfer} event.
294      */
295     function safeTransferFrom(
296         address from,
297         address to,
298         uint256 tokenId
299     ) external;
300 
301     /**
302      * @dev Transfers `tokenId` token from `from` to `to`.
303      *
304      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
305      *
306      * Requirements:
307      *
308      * - `from` cannot be the zero address.
309      * - `to` cannot be the zero address.
310      * - `tokenId` token must be owned by `from`.
311      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
312      *
313      * Emits a {Transfer} event.
314      */
315     function transferFrom(
316         address from,
317         address to,
318         uint256 tokenId
319     ) external;
320 
321     /**
322      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
323      * The approval is cleared when the token is transferred.
324      *
325      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
326      *
327      * Requirements:
328      *
329      * - The caller must own the token or be an approved operator.
330      * - `tokenId` must exist.
331      *
332      * Emits an {Approval} event.
333      */
334     function approve(address to, uint256 tokenId) external;
335 
336     /**
337      * @dev Approve or remove `operator` as an operator for the caller.
338      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
339      *
340      * Requirements:
341      *
342      * - The `operator` cannot be the caller.
343      *
344      * Emits an {ApprovalForAll} event.
345      */
346     function setApprovalForAll(address operator, bool _approved) external;
347 
348     /**
349      * @dev Returns the account approved for `tokenId` token.
350      *
351      * Requirements:
352      *
353      * - `tokenId` must exist.
354      */
355     function getApproved(uint256 tokenId) external view returns (address operator);
356 
357     /**
358      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
359      *
360      * See {setApprovalForAll}
361      */
362     function isApprovedForAll(address owner, address operator) external view returns (bool);
363 
364     // ==============================
365     //        IERC721Metadata
366     // ==============================
367 
368     /**
369      * @dev Returns the token collection name.
370      */
371     function name() external view returns (string memory);
372 
373     /**
374      * @dev Returns the token collection symbol.
375      */
376     function symbol() external view returns (string memory);
377 
378     /**
379      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
380      */
381     function tokenURI(uint256 tokenId) external view returns (string memory);
382 
383     // ==============================
384     //            IERC2309
385     // ==============================
386 
387     /**
388      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
389      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
390      */
391     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
392 }
393 
394 // File: contracts/ERC721A.sol
395 
396 
397 // ERC721A Contracts v4.1.0
398 // Creator: Chiru Labs
399 
400 pragma solidity ^0.8.4;
401 
402 
403 /**
404  * @dev ERC721 token receiver interface.
405  */
406 interface ERC721A__IERC721Receiver {
407     function onERC721Received(
408         address operator,
409         address from,
410         uint256 tokenId,
411         bytes calldata data
412     ) external returns (bytes4);
413 }
414 
415 /**
416  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
417  * including the Metadata extension. Built to optimize for lower gas during batch mints.
418  *
419  * Assumes serials are sequentially minted starting at `_startTokenId()`
420  * (defaults to 0, e.g. 0, 1, 2, 3..).
421  *
422  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
423  *
424  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
425  */
426 contract ERC721A is IERC721A {
427     // Mask of an entry in packed address data.
428     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
429 
430     // The bit position of `numberMinted` in packed address data.
431     uint256 private constant BITPOS_NUMBER_MINTED = 64;
432 
433     // The bit position of `numberBurned` in packed address data.
434     uint256 private constant BITPOS_NUMBER_BURNED = 128;
435 
436     // The bit position of `aux` in packed address data.
437     uint256 private constant BITPOS_AUX = 192;
438 
439     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
440     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
441 
442     // The bit position of `startTimestamp` in packed ownership.
443     uint256 private constant BITPOS_START_TIMESTAMP = 160;
444 
445     // The bit mask of the `burned` bit in packed ownership.
446     uint256 private constant BITMASK_BURNED = 1 << 224;
447 
448     // The bit position of the `nextInitialized` bit in packed ownership.
449     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
450 
451     // The bit mask of the `nextInitialized` bit in packed ownership.
452     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
453 
454     // The bit position of `extraData` in packed ownership.
455     uint256 private constant BITPOS_EXTRA_DATA = 232;
456 
457     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
458     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
459 
460     // The mask of the lower 160 bits for addresses.
461     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
462 
463     // The maximum `quantity` that can be minted with `_mintERC2309`.
464     // This limit is to prevent overflows on the address data entries.
465     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
466     // is required to cause an overflow, which is unrealistic.
467     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
468 
469     // The tokenId of the next token to be minted.
470     uint256 private _currentIndex;
471 
472     // The number of tokens burned.
473     uint256 private _burnCounter;
474 
475     // Token name
476     string private _name;
477 
478     // Token symbol
479     string private _symbol;
480 
481     // Mapping from token ID to ownership details
482     // An empty struct value does not necessarily mean the token is unowned.
483     // See `_packedOwnershipOf` implementation for details.
484     //
485     // Bits Layout:
486     // - [0..159]   `addr`
487     // - [160..223] `startTimestamp`
488     // - [224]      `burned`
489     // - [225]      `nextInitialized`
490     // - [232..255] `extraData`
491     mapping(uint256 => uint256) private _packedOwnerships;
492 
493     // Mapping owner address to address data.
494     //
495     // Bits Layout:
496     // - [0..63]    `balance`
497     // - [64..127]  `numberMinted`
498     // - [128..191] `numberBurned`
499     // - [192..255] `aux`
500     mapping(address => uint256) private _packedAddressData;
501 
502     // Mapping from token ID to approved address.
503     mapping(uint256 => address) private _tokenApprovals;
504 
505     // Mapping from owner to operator approvals
506     mapping(address => mapping(address => bool)) private _operatorApprovals;
507 
508     constructor(string memory name_, string memory symbol_) {
509         _name = name_;
510         _symbol = symbol_;
511         _currentIndex = _startTokenId();
512     }
513 
514     /**
515      * @dev Returns the starting token ID.
516      * To change the starting token ID, please override this function.
517      */
518     function _startTokenId() internal view virtual returns (uint256) {
519         return 1;
520     }
521 
522     /**
523      * @dev Returns the next token ID to be minted.
524      */
525     function _nextTokenId() internal view returns (uint256) {
526         return _currentIndex;
527     }
528 
529     /**
530      * @dev Returns the total number of tokens in existence.
531      * Burned tokens will reduce the count.
532      * To get the total number of tokens minted, please see `_totalMinted`.
533      */
534     function totalSupply() public view override returns (uint256) {
535         // Counter underflow is impossible as _burnCounter cannot be incremented
536         // more than `_currentIndex - _startTokenId()` times.
537         unchecked {
538             return _currentIndex - _burnCounter - _startTokenId();
539         }
540     }
541 
542     /**
543      * @dev Returns the total amount of tokens minted in the contract.
544      */
545     function _totalMinted() internal view returns (uint256) {
546         // Counter underflow is impossible as _currentIndex does not decrement,
547         // and it is initialized to `_startTokenId()`
548         unchecked {
549             return _currentIndex - _startTokenId();
550         }
551     }
552 
553     /**
554      * @dev Returns the total number of tokens burned.
555      */
556     function _totalBurned() internal view returns (uint256) {
557         return _burnCounter;
558     }
559 
560     /**
561      * @dev See {IERC165-supportsInterface}.
562      */
563     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
564         // The interface IDs are constants representing the first 4 bytes of the XOR of
565         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
566         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
567         return
568             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
569             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
570             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
571     }
572 
573     /**
574      * @dev See {IERC721-balanceOf}.
575      */
576     function balanceOf(address owner) public view override returns (uint256) {
577         if (owner == address(0)) revert BalanceQueryForZeroAddress();
578         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
579     }
580 
581     /**
582      * Returns the number of tokens minted by `owner`.
583      */
584     function _numberMinted(address owner) internal view returns (uint256) {
585         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
586     }
587 
588     /**
589      * Returns the number of tokens burned by or on behalf of `owner`.
590      */
591     function _numberBurned(address owner) internal view returns (uint256) {
592         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
593     }
594 
595     /**
596      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
597      */
598     function _getAux(address owner) internal view returns (uint64) {
599         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
600     }
601 
602     /**
603      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
604      * If there are multiple variables, please pack them into a uint64.
605      */
606     function _setAux(address owner, uint64 aux) internal {
607         uint256 packed = _packedAddressData[owner];
608         uint256 auxCasted;
609         // Cast `aux` with assembly to avoid redundant masking.
610         assembly {
611             auxCasted := aux
612         }
613         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
614         _packedAddressData[owner] = packed;
615     }
616 
617     /**
618      * Returns the packed ownership data of `tokenId`.
619      */
620     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
621         uint256 curr = tokenId;
622 
623         unchecked {
624             if (_startTokenId() <= curr)
625                 if (curr < _currentIndex) {
626                     uint256 packed = _packedOwnerships[curr];
627                     // If not burned.
628                     if (packed & BITMASK_BURNED == 0) {
629                         // Invariant:
630                         // There will always be an ownership that has an address and is not burned
631                         // before an ownership that does not have an address and is not burned.
632                         // Hence, curr will not underflow.
633                         //
634                         // We can directly compare the packed value.
635                         // If the address is zero, packed is zero.
636                         while (packed == 0) {
637                             packed = _packedOwnerships[--curr];
638                         }
639                         return packed;
640                     }
641                 }
642         }
643         revert OwnerQueryForNonexistentToken();
644     }
645 
646     /**
647      * Returns the unpacked `TokenOwnership` struct from `packed`.
648      */
649     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
650         ownership.addr = address(uint160(packed));
651         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
652         ownership.burned = packed & BITMASK_BURNED != 0;
653         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
654     }
655 
656     /**
657      * Returns the unpacked `TokenOwnership` struct at `index`.
658      */
659     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
660         return _unpackedOwnership(_packedOwnerships[index]);
661     }
662 
663     /**
664      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
665      */
666     function _initializeOwnershipAt(uint256 index) internal {
667         if (_packedOwnerships[index] == 0) {
668             _packedOwnerships[index] = _packedOwnershipOf(index);
669         }
670     }
671 
672     /**
673      * Gas spent here starts off proportional to the maximum mint batch size.
674      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
675      */
676     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
677         return _unpackedOwnership(_packedOwnershipOf(tokenId));
678     }
679 
680     /**
681      * @dev Packs ownership data into a single uint256.
682      */
683     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
684         assembly {
685             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
686             owner := and(owner, BITMASK_ADDRESS)
687             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
688             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
689         }
690     }
691 
692     /**
693      * @dev See {IERC721-ownerOf}.
694      */
695     function ownerOf(uint256 tokenId) public view override returns (address) {
696         return address(uint160(_packedOwnershipOf(tokenId)));
697     }
698 
699     /**
700      * @dev See {IERC721Metadata-name}.
701      */
702     function name() public view virtual override returns (string memory) {
703         return _name;
704     }
705 
706     /**
707      * @dev See {IERC721Metadata-symbol}.
708      */
709     function symbol() public view virtual override returns (string memory) {
710         return _symbol;
711     }
712 
713     /**
714      * @dev See {IERC721Metadata-tokenURI}.
715      */
716     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
717         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
718 
719         string memory baseURI = _baseURI();
720         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
721     }
722 
723     /**
724      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
725      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
726      * by default, it can be overridden in child contracts.
727      */
728     function _baseURI() internal view virtual returns (string memory) {
729         return '';
730     }
731 
732     /**
733      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
734      */
735     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
736         // For branchless setting of the `nextInitialized` flag.
737         assembly {
738             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
739             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
740         }
741     }
742 
743     /**
744      * @dev See {IERC721-approve}.
745      */
746     function approve(address to, uint256 tokenId) public override {
747         address owner = ownerOf(tokenId);
748 
749         if (_msgSenderERC721A() != owner)
750             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
751                 revert ApprovalCallerNotOwnerNorApproved();
752             }
753 
754         _tokenApprovals[tokenId] = to;
755         emit Approval(owner, to, tokenId);
756     }
757 
758     /**
759      * @dev See {IERC721-getApproved}.
760      */
761     function getApproved(uint256 tokenId) public view override returns (address) {
762         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
763 
764         return _tokenApprovals[tokenId];
765     }
766 
767     /**
768      * @dev See {IERC721-setApprovalForAll}.
769      */
770     function setApprovalForAll(address operator, bool approved) public virtual override {
771         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
772 
773         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
774         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
775     }
776 
777     /**
778      * @dev See {IERC721-isApprovedForAll}.
779      */
780     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
781         return _operatorApprovals[owner][operator];
782     }
783 
784     /**
785      * @dev See {IERC721-safeTransferFrom}.
786      */
787     function safeTransferFrom(
788         address from,
789         address to,
790         uint256 tokenId
791     ) public virtual override {
792         safeTransferFrom(from, to, tokenId, '');
793     }
794 
795     /**
796      * @dev See {IERC721-safeTransferFrom}.
797      */
798     function safeTransferFrom(
799         address from,
800         address to,
801         uint256 tokenId,
802         bytes memory _data
803     ) public virtual override {
804         transferFrom(from, to, tokenId);
805         if (to.code.length != 0)
806             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
807                 revert TransferToNonERC721ReceiverImplementer();
808             }
809     }
810 
811     /**
812      * @dev Returns whether `tokenId` exists.
813      *
814      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
815      *
816      * Tokens start existing when they are minted (`_mint`),
817      */
818     function _exists(uint256 tokenId) internal view returns (bool) {
819         return
820             _startTokenId() <= tokenId &&
821             tokenId < _currentIndex && // If within bounds,
822             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
823     }
824 
825     /**
826      * @dev Equivalent to `_safeMint(to, quantity, '')`.
827      */
828     function _safeMint(address to, uint256 quantity) internal {
829         _safeMint(to, quantity, '');
830     }
831 
832     /**
833      * @dev Safely mints `quantity` tokens and transfers them to `to`.
834      *
835      * Requirements:
836      *
837      * - If `to` refers to a smart contract, it must implement
838      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
839      * - `quantity` must be greater than 0.
840      *
841      * See {_mint}.
842      *
843      * Emits a {Transfer} event for each mint.
844      */
845     function _safeMint(
846         address to,
847         uint256 quantity,
848         bytes memory _data
849     ) internal {
850         _mint(to, quantity);
851 
852         unchecked {
853             if (to.code.length != 0) {
854                 uint256 end = _currentIndex;
855                 uint256 index = end - quantity;
856                 do {
857                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
858                         revert TransferToNonERC721ReceiverImplementer();
859                     }
860                 } while (index < end);
861                 // Reentrancy protection.
862                 if (_currentIndex != end) revert();
863             }
864         }
865     }
866 
867     /**
868      * @dev Mints `quantity` tokens and transfers them to `to`.
869      *
870      * Requirements:
871      *
872      * - `to` cannot be the zero address.
873      * - `quantity` must be greater than 0.
874      *
875      * Emits a {Transfer} event for each mint.
876      */
877     function _mint(address to, uint256 quantity) internal {
878         uint256 startTokenId = _currentIndex;
879         if (to == address(0)) revert MintToZeroAddress();
880         if (quantity == 0) revert MintZeroQuantity();
881 
882         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
883 
884         // Overflows are incredibly unrealistic.
885         // `balance` and `numberMinted` have a maximum limit of 2**64.
886         // `tokenId` has a maximum limit of 2**256.
887         unchecked {
888             // Updates:
889             // - `balance += quantity`.
890             // - `numberMinted += quantity`.
891             //
892             // We can directly add to the `balance` and `numberMinted`.
893             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
894 
895             // Updates:
896             // - `address` to the owner.
897             // - `startTimestamp` to the timestamp of minting.
898             // - `burned` to `false`.
899             // - `nextInitialized` to `quantity == 1`.
900             _packedOwnerships[startTokenId] = _packOwnershipData(
901                 to,
902                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
903             );
904 
905             uint256 tokenId = startTokenId;
906             uint256 end = startTokenId + quantity;
907             do {
908                 emit Transfer(address(0), to, tokenId++);
909             } while (tokenId < end);
910 
911             _currentIndex = end;
912         }
913         _afterTokenTransfers(address(0), to, startTokenId, quantity);
914     }
915 
916     /**
917      * @dev Mints `quantity` tokens and transfers them to `to`.
918      *
919      * This function is intended for efficient minting only during contract creation.
920      *
921      * It emits only one {ConsecutiveTransfer} as defined in
922      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
923      * instead of a sequence of {Transfer} event(s).
924      *
925      * Calling this function outside of contract creation WILL make your contract
926      * non-compliant with the ERC721 standard.
927      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
928      * {ConsecutiveTransfer} event is only permissible during contract creation.
929      *
930      * Requirements:
931      *
932      * - `to` cannot be the zero address.
933      * - `quantity` must be greater than 0.
934      *
935      * Emits a {ConsecutiveTransfer} event.
936      */
937     function _mintERC2309(address to, uint256 quantity) internal {
938         uint256 startTokenId = _currentIndex;
939         if (to == address(0)) revert MintToZeroAddress();
940         if (quantity == 0) revert MintZeroQuantity();
941         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
942 
943         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
944 
945         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
946         unchecked {
947             // Updates:
948             // - `balance += quantity`.
949             // - `numberMinted += quantity`.
950             //
951             // We can directly add to the `balance` and `numberMinted`.
952             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
953 
954             // Updates:
955             // - `address` to the owner.
956             // - `startTimestamp` to the timestamp of minting.
957             // - `burned` to `false`.
958             // - `nextInitialized` to `quantity == 1`.
959             _packedOwnerships[startTokenId] = _packOwnershipData(
960                 to,
961                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
962             );
963 
964             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
965 
966             _currentIndex = startTokenId + quantity;
967         }
968         _afterTokenTransfers(address(0), to, startTokenId, quantity);
969     }
970 
971     /**
972      * @dev Returns the storage slot and value for the approved address of `tokenId`.
973      */
974     function _getApprovedAddress(uint256 tokenId)
975         private
976         view
977         returns (uint256 approvedAddressSlot, address approvedAddress)
978     {
979         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
980         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
981         assembly {
982             // Compute the slot.
983             mstore(0x00, tokenId)
984             mstore(0x20, tokenApprovalsPtr.slot)
985             approvedAddressSlot := keccak256(0x00, 0x40)
986             // Load the slot's value from storage.
987             approvedAddress := sload(approvedAddressSlot)
988         }
989     }
990 
991     /**
992      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
993      */
994     function _isOwnerOrApproved(
995         address approvedAddress,
996         address from,
997         address msgSender
998     ) private pure returns (bool result) {
999         assembly {
1000             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1001             from := and(from, BITMASK_ADDRESS)
1002             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1003             msgSender := and(msgSender, BITMASK_ADDRESS)
1004             // `msgSender == from || msgSender == approvedAddress`.
1005             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1006         }
1007     }
1008 
1009     /**
1010      * @dev Transfers `tokenId` from `from` to `to`.
1011      *
1012      * Requirements:
1013      *
1014      * - `to` cannot be the zero address.
1015      * - `tokenId` token must be owned by `from`.
1016      *
1017      * Emits a {Transfer} event.
1018      */
1019     function transferFrom(
1020         address from,
1021         address to,
1022         uint256 tokenId
1023     ) public virtual override {
1024         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1025 
1026         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1027 
1028         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1029 
1030         // The nested ifs save around 20+ gas over a compound boolean condition.
1031         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1032             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1033 
1034         if (to == address(0)) revert TransferToZeroAddress();
1035 
1036         _beforeTokenTransfers(from, to, tokenId, 1);
1037 
1038         // Clear approvals from the previous owner.
1039         assembly {
1040             if approvedAddress {
1041                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1042                 sstore(approvedAddressSlot, 0)
1043             }
1044         }
1045 
1046         // Underflow of the sender's balance is impossible because we check for
1047         // ownership above and the recipient's balance can't realistically overflow.
1048         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1049         unchecked {
1050             // We can directly increment and decrement the balances.
1051             --_packedAddressData[from]; // Updates: `balance -= 1`.
1052             ++_packedAddressData[to]; // Updates: `balance += 1`.
1053 
1054             // Updates:
1055             // - `address` to the next owner.
1056             // - `startTimestamp` to the timestamp of transfering.
1057             // - `burned` to `false`.
1058             // - `nextInitialized` to `true`.
1059             _packedOwnerships[tokenId] = _packOwnershipData(
1060                 to,
1061                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1062             );
1063 
1064             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1065             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1066                 uint256 nextTokenId = tokenId + 1;
1067                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1068                 if (_packedOwnerships[nextTokenId] == 0) {
1069                     // If the next slot is within bounds.
1070                     if (nextTokenId != _currentIndex) {
1071                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1072                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1073                     }
1074                 }
1075             }
1076         }
1077 
1078         emit Transfer(from, to, tokenId);
1079         _afterTokenTransfers(from, to, tokenId, 1);
1080     }
1081 
1082     /**
1083      * @dev Equivalent to `_burn(tokenId, false)`.
1084      */
1085     function _burn(uint256 tokenId) internal virtual {
1086         _burn(tokenId, false);
1087     }
1088 
1089     /**
1090      * @dev Destroys `tokenId`.
1091      * The approval is cleared when the token is burned.
1092      *
1093      * Requirements:
1094      *
1095      * - `tokenId` must exist.
1096      *
1097      * Emits a {Transfer} event.
1098      */
1099     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1100         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1101 
1102         address from = address(uint160(prevOwnershipPacked));
1103 
1104         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1105 
1106         if (approvalCheck) {
1107             // The nested ifs save around 20+ gas over a compound boolean condition.
1108             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1109                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1110         }
1111 
1112         _beforeTokenTransfers(from, address(0), tokenId, 1);
1113 
1114         // Clear approvals from the previous owner.
1115         assembly {
1116             if approvedAddress {
1117                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1118                 sstore(approvedAddressSlot, 0)
1119             }
1120         }
1121 
1122         // Underflow of the sender's balance is impossible because we check for
1123         // ownership above and the recipient's balance can't realistically overflow.
1124         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1125         unchecked {
1126             // Updates:
1127             // - `balance -= 1`.
1128             // - `numberBurned += 1`.
1129             //
1130             // We can directly decrement the balance, and increment the number burned.
1131             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1132             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1133 
1134             // Updates:
1135             // - `address` to the last owner.
1136             // - `startTimestamp` to the timestamp of burning.
1137             // - `burned` to `true`.
1138             // - `nextInitialized` to `true`.
1139             _packedOwnerships[tokenId] = _packOwnershipData(
1140                 from,
1141                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1142             );
1143 
1144             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1145             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1146                 uint256 nextTokenId = tokenId + 1;
1147                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1148                 if (_packedOwnerships[nextTokenId] == 0) {
1149                     // If the next slot is within bounds.
1150                     if (nextTokenId != _currentIndex) {
1151                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1152                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1153                     }
1154                 }
1155             }
1156         }
1157 
1158         emit Transfer(from, address(0), tokenId);
1159         _afterTokenTransfers(from, address(0), tokenId, 1);
1160 
1161         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1162         unchecked {
1163             _burnCounter++;
1164         }
1165     }
1166 
1167     /**
1168      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1169      *
1170      * @param from address representing the previous owner of the given token ID
1171      * @param to target address that will receive the tokens
1172      * @param tokenId uint256 ID of the token to be transferred
1173      * @param _data bytes optional data to send along with the call
1174      * @return bool whether the call correctly returned the expected magic value
1175      */
1176     function _checkContractOnERC721Received(
1177         address from,
1178         address to,
1179         uint256 tokenId,
1180         bytes memory _data
1181     ) private returns (bool) {
1182         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1183             bytes4 retval
1184         ) {
1185             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1186         } catch (bytes memory reason) {
1187             if (reason.length == 0) {
1188                 revert TransferToNonERC721ReceiverImplementer();
1189             } else {
1190                 assembly {
1191                     revert(add(32, reason), mload(reason))
1192                 }
1193             }
1194         }
1195     }
1196 
1197     /**
1198      * @dev Directly sets the extra data for the ownership data `index`.
1199      */
1200     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1201         uint256 packed = _packedOwnerships[index];
1202         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1203         uint256 extraDataCasted;
1204         // Cast `extraData` with assembly to avoid redundant masking.
1205         assembly {
1206             extraDataCasted := extraData
1207         }
1208         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1209         _packedOwnerships[index] = packed;
1210     }
1211 
1212     /**
1213      * @dev Returns the next extra data for the packed ownership data.
1214      * The returned result is shifted into position.
1215      */
1216     function _nextExtraData(
1217         address from,
1218         address to,
1219         uint256 prevOwnershipPacked
1220     ) private view returns (uint256) {
1221         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1222         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1223     }
1224 
1225     /**
1226      * @dev Called during each token transfer to set the 24bit `extraData` field.
1227      * Intended to be overridden by the cosumer contract.
1228      *
1229      * `previousExtraData` - the value of `extraData` before transfer.
1230      *
1231      * Calling conditions:
1232      *
1233      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1234      * transferred to `to`.
1235      * - When `from` is zero, `tokenId` will be minted for `to`.
1236      * - When `to` is zero, `tokenId` will be burned by `from`.
1237      * - `from` and `to` are never both zero.
1238      */
1239     function _extraData(
1240         address from,
1241         address to,
1242         uint24 previousExtraData
1243     ) internal view virtual returns (uint24) {}
1244 
1245     /**
1246      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1247      * This includes minting.
1248      * And also called before burning one token.
1249      *
1250      * startTokenId - the first token id to be transferred
1251      * quantity - the amount to be transferred
1252      *
1253      * Calling conditions:
1254      *
1255      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1256      * transferred to `to`.
1257      * - When `from` is zero, `tokenId` will be minted for `to`.
1258      * - When `to` is zero, `tokenId` will be burned by `from`.
1259      * - `from` and `to` are never both zero.
1260      */
1261     function _beforeTokenTransfers(
1262         address from,
1263         address to,
1264         uint256 startTokenId,
1265         uint256 quantity
1266     ) internal virtual {}
1267 
1268     /**
1269      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1270      * This includes minting.
1271      * And also called after one token has been burned.
1272      *
1273      * startTokenId - the first token id to be transferred
1274      * quantity - the amount to be transferred
1275      *
1276      * Calling conditions:
1277      *
1278      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1279      * transferred to `to`.
1280      * - When `from` is zero, `tokenId` has been minted for `to`.
1281      * - When `to` is zero, `tokenId` has been burned by `from`.
1282      * - `from` and `to` are never both zero.
1283      */
1284     function _afterTokenTransfers(
1285         address from,
1286         address to,
1287         uint256 startTokenId,
1288         uint256 quantity
1289     ) internal virtual {}
1290 
1291     /**
1292      * @dev Returns the message sender (defaults to `msg.sender`).
1293      *
1294      * If you are writing GSN compatible contracts, you need to override this function.
1295      */
1296     function _msgSenderERC721A() internal view virtual returns (address) {
1297         return msg.sender;
1298     }
1299 
1300     /**
1301      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1302      */
1303     function _toString(uint256 value) internal pure returns (string memory ptr) {
1304         assembly {
1305             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1306             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1307             // We will need 1 32-byte word to store the length,
1308             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1309             ptr := add(mload(0x40), 128)
1310             // Update the free memory pointer to allocate.
1311             mstore(0x40, ptr)
1312 
1313             // Cache the end of the memory to calculate the length later.
1314             let end := ptr
1315 
1316             // We write the string from the rightmost digit to the leftmost digit.
1317             // The following is essentially a do-while loop that also handles the zero case.
1318             // Costs a bit more than early returning for the zero case,
1319             // but cheaper in terms of deployment and overall runtime costs.
1320             for {
1321                 // Initialize and perform the first pass without check.
1322                 let temp := value
1323                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1324                 ptr := sub(ptr, 1)
1325                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1326                 mstore8(ptr, add(48, mod(temp, 10)))
1327                 temp := div(temp, 10)
1328             } temp {
1329                 // Keep dividing `temp` until zero.
1330                 temp := div(temp, 10)
1331             } {
1332                 // Body of the for loop.
1333                 ptr := sub(ptr, 1)
1334                 mstore8(ptr, add(48, mod(temp, 10)))
1335             }
1336 
1337             let length := sub(end, ptr)
1338             // Move the pointer 32 bytes leftwards to make room for the length.
1339             ptr := sub(ptr, 32)
1340             // Store the length.
1341             mstore(ptr, length)
1342         }
1343     }
1344 }
1345 
1346 // File: contracts/Fibonacci.sol
1347 
1348 
1349 // Fibonacci
1350 
1351 pragma solidity >=0.8.9 <0.9.0;
1352 
1353 
1354 
1355 contract Fibonacci is ERC721A, Ownable {
1356     string public baseURI;
1357     string public baseExtension = ".json";
1358     string public notRevealedUri;
1359 
1360     uint256 public PRICE = 0.0069 ether;
1361     uint256 public MAX_SUPPLY = 10000;
1362     uint256 public FREE_SUPPLY = 3000;
1363     uint256 public MAX_MINT = 10;
1364     uint256 public MAX_FREE_MINT = 5;
1365 
1366     bool public PAUSE = true;
1367     bool public REVEALED = false;
1368 
1369     mapping(address => uint256) public FREE_MINT_BALANCE;
1370 
1371     /// @notice Contract is paused
1372     error ContractIsPaused();
1373     /// @notice Zero amount mint
1374     error ZeroAmountMint();
1375     /// @notice Max amount has currently been minted
1376     error MaxSupplyReached();
1377     /// @notice User has reached max mint amount
1378     error MaxMintAmountReached();
1379     /// @notice User has sent the correct amount of ETH
1380     error InsufficientFunds();
1381     /// @notice There are no more free mints
1382     error FreeMintSoldOut();
1383 
1384     constructor(
1385         string memory _name,
1386         string memory _symbol,
1387         string memory _initBaseURI,
1388         string memory _initNotRevealedUri
1389     ) ERC721A(_name, _symbol) {
1390         setBaseURI(_initBaseURI);
1391         setNotRevealedURI(_initNotRevealedUri);
1392     }
1393 
1394     // internal
1395     function _baseURI() internal view virtual override returns (string memory) {
1396         return baseURI;
1397     }
1398 
1399     modifier mintCompliance(uint256 _mintAmount) {
1400         uint256 supply = totalSupply();
1401         if (PAUSE) revert ContractIsPaused();
1402         if (_mintAmount == 0) revert ZeroAmountMint();
1403         if (supply + _mintAmount > MAX_SUPPLY) revert MaxSupplyReached();
1404         if (_mintAmount > MAX_MINT) revert MaxMintAmountReached();
1405         _;
1406     }
1407 
1408     // public
1409     function mint(uint256 _mintAmount)
1410         public
1411         payable
1412         mintCompliance(_mintAmount)
1413     {
1414         if (msg.value == 0) {
1415             if (totalSupply() + _mintAmount > FREE_SUPPLY)
1416                 revert FreeMintSoldOut();
1417 
1418             uint256 FREE_MINT_COUNT = FREE_MINT_BALANCE[msg.sender];
1419             if (FREE_MINT_COUNT + _mintAmount > MAX_FREE_MINT)
1420                 revert MaxMintAmountReached();
1421 
1422             FREE_MINT_BALANCE[msg.sender] += _mintAmount;
1423         } else {
1424 
1425             if (msg.value > PRICE * _mintAmount) revert InsufficientFunds();
1426         }
1427 
1428         _safeMint(msg.sender, _mintAmount);
1429     }
1430 
1431     // owner mint
1432     function mintForOwner(uint256 _mintAmount) public onlyOwner {
1433         uint256 supply = totalSupply();
1434         if (MAX_SUPPLY <= supply + _mintAmount) revert MaxSupplyReached();
1435         _safeMint(msg.sender, _mintAmount);
1436     }
1437 
1438     function contractURI() public view returns (string memory) {
1439         string memory currentBaseURI = _baseURI();
1440         return
1441             bytes(currentBaseURI).length > 0
1442                 ? string(
1443                     abi.encodePacked(
1444                         currentBaseURI,
1445                         "contract-data",
1446                         baseExtension
1447                     )
1448                 )
1449                 : "";
1450     }
1451 
1452     function tokenURI(uint256 tokenId)
1453         public
1454         view
1455         virtual
1456         override
1457         returns (string memory)
1458     {
1459         require(
1460             _exists(tokenId),
1461             "ERC721Metadata: URI query for nonexistent token"
1462         );
1463 
1464         if (REVEALED == false) {
1465             return notRevealedUri;
1466         }
1467 
1468         string memory currentBaseURI = _baseURI();
1469         return
1470             bytes(currentBaseURI).length > 0
1471                 ? string(
1472                     abi.encodePacked(
1473                         currentBaseURI,
1474                         _toString(tokenId),
1475                         baseExtension
1476                     )
1477                 )
1478                 : "";
1479     }
1480 
1481     //only owner    
1482     function reveal() public onlyOwner {
1483         REVEALED = true;
1484     }
1485 
1486     function setCost(uint256 _newCost) public onlyOwner {
1487         PRICE = _newCost;
1488     }
1489 
1490     function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1491         MAX_MINT = _newmaxMintAmount;
1492     }
1493 
1494     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1495         notRevealedUri = _notRevealedURI;
1496     }
1497 
1498     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1499         baseURI = _newBaseURI;
1500     }
1501 
1502     function setBaseExtension(string memory _newBaseExtension)
1503         public
1504         onlyOwner
1505     {
1506         baseExtension = _newBaseExtension;
1507     }
1508 
1509     function setPause(bool _state) public onlyOwner {
1510         PAUSE = _state;
1511     }
1512 
1513     function withdraw() public payable onlyOwner {
1514         (bool finished, ) = payable(0x6568615f468D177de965DA903F3B49B8509Dc7f7).call{
1515             value: (address(this).balance * 33) / 100
1516         }("");
1517         require(finished);
1518 
1519         (bool hs, ) = payable(0x8106AF408125B39cEfA2fdfD34CF6C313E7B77D0).call{
1520             value: (address(this).balance * 33) / 100
1521         }("");
1522         require(hs);
1523         
1524         (bool os, ) = payable(0x85fd31EcBAd82634A2a14Ed7f068B898E2e47152).call{value: address(this).balance}("");
1525         require(os);
1526     }
1527 }