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
116 // ERC721A Contracts v4.1.0
117 // Creator: Chiru Labs
118 
119 pragma solidity ^0.8.4;
120 
121 /**
122  * @dev Interface of an ERC721A compliant contract.
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
171      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
172      */
173     error TransferToNonERC721ReceiverImplementer();
174 
175     /**
176      * Cannot transfer to the zero address.
177      */
178     error TransferToZeroAddress();
179 
180     /**
181      * The token does not exist.
182      */
183     error URIQueryForNonexistentToken();
184 
185     /**
186      * The `quantity` minted with ERC2309 exceeds the safety limit.
187      */
188     error MintERC2309QuantityExceedsLimit();
189 
190     /**
191      * The `extraData` cannot be set on an unintialized ownership slot.
192      */
193     error OwnershipNotInitializedForExtraData();
194 
195     struct TokenOwnership {
196         // The address of the owner.
197         address addr;
198         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
199         uint64 startTimestamp;
200         // Whether the token has been burned.
201         bool burned;
202         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
203         uint24 extraData;
204     }
205 
206     /**
207      * @dev Returns the total amount of tokens stored by the contract.
208      *
209      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
210      */
211     function totalSupply() external view returns (uint256);
212 
213     // ==============================
214     //            IERC165
215     // ==============================
216 
217     /**
218      * @dev Returns true if this contract implements the interface defined by
219      * `interfaceId`. See the corresponding
220      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
221      * to learn more about how these ids are created.
222      *
223      * This function call must use less than 30 000 gas.
224      */
225     function supportsInterface(bytes4 interfaceId) external view returns (bool);
226 
227     // ==============================
228     //            IERC721
229     // ==============================
230 
231     /**
232      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
233      */
234     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
235 
236     /**
237      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
238      */
239     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
240 
241     /**
242      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
243      */
244     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
245 
246     /**
247      * @dev Returns the number of tokens in ``owner``'s account.
248      */
249     function balanceOf(address owner) external view returns (uint256 balance);
250 
251     /**
252      * @dev Returns the owner of the `tokenId` token.
253      *
254      * Requirements:
255      *
256      * - `tokenId` must exist.
257      */
258     function ownerOf(uint256 tokenId) external view returns (address owner);
259 
260     /**
261      * @dev Safely transfers `tokenId` token from `from` to `to`.
262      *
263      * Requirements:
264      *
265      * - `from` cannot be the zero address.
266      * - `to` cannot be the zero address.
267      * - `tokenId` token must exist and be owned by `from`.
268      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
269      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
270      *
271      * Emits a {Transfer} event.
272      */
273     function safeTransferFrom(
274         address from,
275         address to,
276         uint256 tokenId,
277         bytes calldata data
278     ) external;
279 
280     /**
281      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
282      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
283      *
284      * Requirements:
285      *
286      * - `from` cannot be the zero address.
287      * - `to` cannot be the zero address.
288      * - `tokenId` token must exist and be owned by `from`.
289      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
290      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
291      *
292      * Emits a {Transfer} event.
293      */
294     function safeTransferFrom(
295         address from,
296         address to,
297         uint256 tokenId
298     ) external;
299 
300     /**
301      * @dev Transfers `tokenId` token from `from` to `to`.
302      *
303      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
304      *
305      * Requirements:
306      *
307      * - `from` cannot be the zero address.
308      * - `to` cannot be the zero address.
309      * - `tokenId` token must be owned by `from`.
310      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
311      *
312      * Emits a {Transfer} event.
313      */
314     function transferFrom(
315         address from,
316         address to,
317         uint256 tokenId
318     ) external;
319 
320     /**
321      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
322      * The approval is cleared when the token is transferred.
323      *
324      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
325      *
326      * Requirements:
327      *
328      * - The caller must own the token or be an approved operator.
329      * - `tokenId` must exist.
330      *
331      * Emits an {Approval} event.
332      */
333     function approve(address to, uint256 tokenId) external;
334 
335     /**
336      * @dev Approve or remove `operator` as an operator for the caller.
337      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
338      *
339      * Requirements:
340      *
341      * - The `operator` cannot be the caller.
342      *
343      * Emits an {ApprovalForAll} event.
344      */
345     function setApprovalForAll(address operator, bool _approved) external;
346 
347     /**
348      * @dev Returns the account approved for `tokenId` token.
349      *
350      * Requirements:
351      *
352      * - `tokenId` must exist.
353      */
354     function getApproved(uint256 tokenId) external view returns (address operator);
355 
356     /**
357      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
358      *
359      * See {setApprovalForAll}
360      */
361     function isApprovedForAll(address owner, address operator) external view returns (bool);
362 
363     // ==============================
364     //        IERC721Metadata
365     // ==============================
366 
367     /**
368      * @dev Returns the token collection name.
369      */
370     function name() external view returns (string memory);
371 
372     /**
373      * @dev Returns the token collection symbol.
374      */
375     function symbol() external view returns (string memory);
376 
377     /**
378      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
379      */
380     function tokenURI(uint256 tokenId) external view returns (string memory);
381 
382     // ==============================
383     //            IERC2309
384     // ==============================
385 
386     /**
387      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
388      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
389      */
390     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
391 }
392 
393 // File: erc721a/contracts/ERC721A.sol
394 
395 
396 // ERC721A Contracts v4.1.0
397 // Creator: Chiru Labs
398 
399 pragma solidity ^0.8.4;
400 
401 
402 /**
403  * @dev ERC721 token receiver interface.
404  */
405 interface ERC721A__IERC721Receiver {
406     function onERC721Received(
407         address operator,
408         address from,
409         uint256 tokenId,
410         bytes calldata data
411     ) external returns (bytes4);
412 }
413 
414 /**
415  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
416  * including the Metadata extension. Built to optimize for lower gas during batch mints.
417  *
418  * Assumes serials are sequentially minted starting at `_startTokenId()`
419  * (defaults to 0, e.g. 0, 1, 2, 3..).
420  *
421  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
422  *
423  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
424  */
425 contract ERC721A is IERC721A {
426     // Mask of an entry in packed address data.
427     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
428 
429     // The bit position of `numberMinted` in packed address data.
430     uint256 private constant BITPOS_NUMBER_MINTED = 64;
431 
432     // The bit position of `numberBurned` in packed address data.
433     uint256 private constant BITPOS_NUMBER_BURNED = 128;
434 
435     // The bit position of `aux` in packed address data.
436     uint256 private constant BITPOS_AUX = 192;
437 
438     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
439     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
440 
441     // The bit position of `startTimestamp` in packed ownership.
442     uint256 private constant BITPOS_START_TIMESTAMP = 160;
443 
444     // The bit mask of the `burned` bit in packed ownership.
445     uint256 private constant BITMASK_BURNED = 1 << 224;
446 
447     // The bit position of the `nextInitialized` bit in packed ownership.
448     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
449 
450     // The bit mask of the `nextInitialized` bit in packed ownership.
451     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
452 
453     // The bit position of `extraData` in packed ownership.
454     uint256 private constant BITPOS_EXTRA_DATA = 232;
455 
456     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
457     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
458 
459     // The mask of the lower 160 bits for addresses.
460     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
461 
462     // The maximum `quantity` that can be minted with `_mintERC2309`.
463     // This limit is to prevent overflows on the address data entries.
464     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
465     // is required to cause an overflow, which is unrealistic.
466     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
467 
468     // The tokenId of the next token to be minted.
469     uint256 private _currentIndex;
470 
471     // The number of tokens burned.
472     uint256 private _burnCounter;
473 
474     // Token name
475     string private _name;
476 
477     // Token symbol
478     string private _symbol;
479 
480     // Mapping from token ID to ownership details
481     // An empty struct value does not necessarily mean the token is unowned.
482     // See `_packedOwnershipOf` implementation for details.
483     //
484     // Bits Layout:
485     // - [0..159]   `addr`
486     // - [160..223] `startTimestamp`
487     // - [224]      `burned`
488     // - [225]      `nextInitialized`
489     // - [232..255] `extraData`
490     mapping(uint256 => uint256) private _packedOwnerships;
491 
492     // Mapping owner address to address data.
493     //
494     // Bits Layout:
495     // - [0..63]    `balance`
496     // - [64..127]  `numberMinted`
497     // - [128..191] `numberBurned`
498     // - [192..255] `aux`
499     mapping(address => uint256) private _packedAddressData;
500 
501     // Mapping from token ID to approved address.
502     mapping(uint256 => address) private _tokenApprovals;
503 
504     // Mapping from owner to operator approvals
505     mapping(address => mapping(address => bool)) private _operatorApprovals;
506 
507     constructor(string memory name_, string memory symbol_) {
508         _name = name_;
509         _symbol = symbol_;
510         _currentIndex = _startTokenId();
511     }
512 
513     /**
514      * @dev Returns the starting token ID.
515      * To change the starting token ID, please override this function.
516      */
517     function _startTokenId() internal view virtual returns (uint256) {
518         return 0;
519     }
520 
521     /**
522      * @dev Returns the next token ID to be minted.
523      */
524     function _nextTokenId() internal view returns (uint256) {
525         return _currentIndex;
526     }
527 
528     /**
529      * @dev Returns the total number of tokens in existence.
530      * Burned tokens will reduce the count.
531      * To get the total number of tokens minted, please see `_totalMinted`.
532      */
533     function totalSupply() public view override returns (uint256) {
534         // Counter underflow is impossible as _burnCounter cannot be incremented
535         // more than `_currentIndex - _startTokenId()` times.
536         unchecked {
537             return _currentIndex - _burnCounter - _startTokenId();
538         }
539     }
540 
541     /**
542      * @dev Returns the total amount of tokens minted in the contract.
543      */
544     function _totalMinted() internal view returns (uint256) {
545         // Counter underflow is impossible as _currentIndex does not decrement,
546         // and it is initialized to `_startTokenId()`
547         unchecked {
548             return _currentIndex - _startTokenId();
549         }
550     }
551 
552     /**
553      * @dev Returns the total number of tokens burned.
554      */
555     function _totalBurned() internal view returns (uint256) {
556         return _burnCounter;
557     }
558 
559     /**
560      * @dev See {IERC165-supportsInterface}.
561      */
562     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
563         // The interface IDs are constants representing the first 4 bytes of the XOR of
564         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
565         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
566         return
567             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
568             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
569             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
570     }
571 
572     /**
573      * @dev See {IERC721-balanceOf}.
574      */
575     function balanceOf(address owner) public view override returns (uint256) {
576         if (owner == address(0)) revert BalanceQueryForZeroAddress();
577         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
578     }
579 
580     /**
581      * Returns the number of tokens minted by `owner`.
582      */
583     function _numberMinted(address owner) internal view returns (uint256) {
584         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
585     }
586 
587     /**
588      * Returns the number of tokens burned by or on behalf of `owner`.
589      */
590     function _numberBurned(address owner) internal view returns (uint256) {
591         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
592     }
593 
594     /**
595      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
596      */
597     function _getAux(address owner) internal view returns (uint64) {
598         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
599     }
600 
601     /**
602      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
603      * If there are multiple variables, please pack them into a uint64.
604      */
605     function _setAux(address owner, uint64 aux) internal {
606         uint256 packed = _packedAddressData[owner];
607         uint256 auxCasted;
608         // Cast `aux` with assembly to avoid redundant masking.
609         assembly {
610             auxCasted := aux
611         }
612         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
613         _packedAddressData[owner] = packed;
614     }
615 
616     /**
617      * Returns the packed ownership data of `tokenId`.
618      */
619     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
620         uint256 curr = tokenId;
621 
622         unchecked {
623             if (_startTokenId() <= curr)
624                 if (curr < _currentIndex) {
625                     uint256 packed = _packedOwnerships[curr];
626                     // If not burned.
627                     if (packed & BITMASK_BURNED == 0) {
628                         // Invariant:
629                         // There will always be an ownership that has an address and is not burned
630                         // before an ownership that does not have an address and is not burned.
631                         // Hence, curr will not underflow.
632                         //
633                         // We can directly compare the packed value.
634                         // If the address is zero, packed is zero.
635                         while (packed == 0) {
636                             packed = _packedOwnerships[--curr];
637                         }
638                         return packed;
639                     }
640                 }
641         }
642         revert OwnerQueryForNonexistentToken();
643     }
644 
645     /**
646      * Returns the unpacked `TokenOwnership` struct from `packed`.
647      */
648     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
649         ownership.addr = address(uint160(packed));
650         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
651         ownership.burned = packed & BITMASK_BURNED != 0;
652         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
653     }
654 
655     /**
656      * Returns the unpacked `TokenOwnership` struct at `index`.
657      */
658     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
659         return _unpackedOwnership(_packedOwnerships[index]);
660     }
661 
662     /**
663      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
664      */
665     function _initializeOwnershipAt(uint256 index) internal {
666         if (_packedOwnerships[index] == 0) {
667             _packedOwnerships[index] = _packedOwnershipOf(index);
668         }
669     }
670 
671     /**
672      * Gas spent here starts off proportional to the maximum mint batch size.
673      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
674      */
675     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
676         return _unpackedOwnership(_packedOwnershipOf(tokenId));
677     }
678 
679     /**
680      * @dev Packs ownership data into a single uint256.
681      */
682     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
683         assembly {
684             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
685             owner := and(owner, BITMASK_ADDRESS)
686             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
687             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
688         }
689     }
690 
691     /**
692      * @dev See {IERC721-ownerOf}.
693      */
694     function ownerOf(uint256 tokenId) public view override returns (address) {
695         return address(uint160(_packedOwnershipOf(tokenId)));
696     }
697 
698     /**
699      * @dev See {IERC721Metadata-name}.
700      */
701     function name() public view virtual override returns (string memory) {
702         return _name;
703     }
704 
705     /**
706      * @dev See {IERC721Metadata-symbol}.
707      */
708     function symbol() public view virtual override returns (string memory) {
709         return _symbol;
710     }
711 
712     /**
713      * @dev See {IERC721Metadata-tokenURI}.
714      */
715     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
716         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
717 
718         string memory baseURI = _baseURI();
719         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
720     }
721 
722     /**
723      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
724      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
725      * by default, it can be overridden in child contracts.
726      */
727     function _baseURI() internal view virtual returns (string memory) {
728         return '';
729     }
730 
731     /**
732      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
733      */
734     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
735         // For branchless setting of the `nextInitialized` flag.
736         assembly {
737             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
738             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
739         }
740     }
741 
742     /**
743      * @dev See {IERC721-approve}.
744      */
745     function approve(address to, uint256 tokenId) public override {
746         address owner = ownerOf(tokenId);
747 
748         if (_msgSenderERC721A() != owner)
749             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
750                 revert ApprovalCallerNotOwnerNorApproved();
751             }
752 
753         _tokenApprovals[tokenId] = to;
754         emit Approval(owner, to, tokenId);
755     }
756 
757     /**
758      * @dev See {IERC721-getApproved}.
759      */
760     function getApproved(uint256 tokenId) public view override returns (address) {
761         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
762 
763         return _tokenApprovals[tokenId];
764     }
765 
766     /**
767      * @dev See {IERC721-setApprovalForAll}.
768      */
769     function setApprovalForAll(address operator, bool approved) public virtual override {
770         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
771 
772         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
773         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
774     }
775 
776     /**
777      * @dev See {IERC721-isApprovedForAll}.
778      */
779     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
780         return _operatorApprovals[owner][operator];
781     }
782 
783     /**
784      * @dev See {IERC721-safeTransferFrom}.
785      */
786     function safeTransferFrom(
787         address from,
788         address to,
789         uint256 tokenId
790     ) public virtual override {
791         safeTransferFrom(from, to, tokenId, '');
792     }
793 
794     /**
795      * @dev See {IERC721-safeTransferFrom}.
796      */
797     function safeTransferFrom(
798         address from,
799         address to,
800         uint256 tokenId,
801         bytes memory _data
802     ) public virtual override {
803         transferFrom(from, to, tokenId);
804         if (to.code.length != 0)
805             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
806                 revert TransferToNonERC721ReceiverImplementer();
807             }
808     }
809 
810     /**
811      * @dev Returns whether `tokenId` exists.
812      *
813      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
814      *
815      * Tokens start existing when they are minted (`_mint`),
816      */
817     function _exists(uint256 tokenId) internal view returns (bool) {
818         return
819             _startTokenId() <= tokenId &&
820             tokenId < _currentIndex && // If within bounds,
821             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
822     }
823 
824     /**
825      * @dev Equivalent to `_safeMint(to, quantity, '')`.
826      */
827     function _safeMint(address to, uint256 quantity) internal {
828         _safeMint(to, quantity, '');
829     }
830 
831     /**
832      * @dev Safely mints `quantity` tokens and transfers them to `to`.
833      *
834      * Requirements:
835      *
836      * - If `to` refers to a smart contract, it must implement
837      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
838      * - `quantity` must be greater than 0.
839      *
840      * See {_mint}.
841      *
842      * Emits a {Transfer} event for each mint.
843      */
844     function _safeMint(
845         address to,
846         uint256 quantity,
847         bytes memory _data
848     ) internal {
849         _mint(to, quantity);
850 
851         unchecked {
852             if (to.code.length != 0) {
853                 uint256 end = _currentIndex;
854                 uint256 index = end - quantity;
855                 do {
856                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
857                         revert TransferToNonERC721ReceiverImplementer();
858                     }
859                 } while (index < end);
860                 // Reentrancy protection.
861                 if (_currentIndex != end) revert();
862             }
863         }
864     }
865 
866     /**
867      * @dev Mints `quantity` tokens and transfers them to `to`.
868      *
869      * Requirements:
870      *
871      * - `to` cannot be the zero address.
872      * - `quantity` must be greater than 0.
873      *
874      * Emits a {Transfer} event for each mint.
875      */
876     function _mint(address to, uint256 quantity) internal {
877         uint256 startTokenId = _currentIndex;
878         if (to == address(0)) revert MintToZeroAddress();
879         if (quantity == 0) revert MintZeroQuantity();
880 
881         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
882 
883         // Overflows are incredibly unrealistic.
884         // `balance` and `numberMinted` have a maximum limit of 2**64.
885         // `tokenId` has a maximum limit of 2**256.
886         unchecked {
887             // Updates:
888             // - `balance += quantity`.
889             // - `numberMinted += quantity`.
890             //
891             // We can directly add to the `balance` and `numberMinted`.
892             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
893 
894             // Updates:
895             // - `address` to the owner.
896             // - `startTimestamp` to the timestamp of minting.
897             // - `burned` to `false`.
898             // - `nextInitialized` to `quantity == 1`.
899             _packedOwnerships[startTokenId] = _packOwnershipData(
900                 to,
901                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
902             );
903 
904             uint256 tokenId = startTokenId;
905             uint256 end = startTokenId + quantity;
906             do {
907                 emit Transfer(address(0), to, tokenId++);
908             } while (tokenId < end);
909 
910             _currentIndex = end;
911         }
912         _afterTokenTransfers(address(0), to, startTokenId, quantity);
913     }
914 
915     /**
916      * @dev Mints `quantity` tokens and transfers them to `to`.
917      *
918      * This function is intended for efficient minting only during contract creation.
919      *
920      * It emits only one {ConsecutiveTransfer} as defined in
921      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
922      * instead of a sequence of {Transfer} event(s).
923      *
924      * Calling this function outside of contract creation WILL make your contract
925      * non-compliant with the ERC721 standard.
926      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
927      * {ConsecutiveTransfer} event is only permissible during contract creation.
928      *
929      * Requirements:
930      *
931      * - `to` cannot be the zero address.
932      * - `quantity` must be greater than 0.
933      *
934      * Emits a {ConsecutiveTransfer} event.
935      */
936     function _mintERC2309(address to, uint256 quantity) internal {
937         uint256 startTokenId = _currentIndex;
938         if (to == address(0)) revert MintToZeroAddress();
939         if (quantity == 0) revert MintZeroQuantity();
940         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
941 
942         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
943 
944         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
945         unchecked {
946             // Updates:
947             // - `balance += quantity`.
948             // - `numberMinted += quantity`.
949             //
950             // We can directly add to the `balance` and `numberMinted`.
951             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
952 
953             // Updates:
954             // - `address` to the owner.
955             // - `startTimestamp` to the timestamp of minting.
956             // - `burned` to `false`.
957             // - `nextInitialized` to `quantity == 1`.
958             _packedOwnerships[startTokenId] = _packOwnershipData(
959                 to,
960                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
961             );
962 
963             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
964 
965             _currentIndex = startTokenId + quantity;
966         }
967         _afterTokenTransfers(address(0), to, startTokenId, quantity);
968     }
969 
970     /**
971      * @dev Returns the storage slot and value for the approved address of `tokenId`.
972      */
973     function _getApprovedAddress(uint256 tokenId)
974         private
975         view
976         returns (uint256 approvedAddressSlot, address approvedAddress)
977     {
978         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
979         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
980         assembly {
981             // Compute the slot.
982             mstore(0x00, tokenId)
983             mstore(0x20, tokenApprovalsPtr.slot)
984             approvedAddressSlot := keccak256(0x00, 0x40)
985             // Load the slot's value from storage.
986             approvedAddress := sload(approvedAddressSlot)
987         }
988     }
989 
990     /**
991      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
992      */
993     function _isOwnerOrApproved(
994         address approvedAddress,
995         address from,
996         address msgSender
997     ) private pure returns (bool result) {
998         assembly {
999             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1000             from := and(from, BITMASK_ADDRESS)
1001             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1002             msgSender := and(msgSender, BITMASK_ADDRESS)
1003             // `msgSender == from || msgSender == approvedAddress`.
1004             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1005         }
1006     }
1007 
1008     /**
1009      * @dev Transfers `tokenId` from `from` to `to`.
1010      *
1011      * Requirements:
1012      *
1013      * - `to` cannot be the zero address.
1014      * - `tokenId` token must be owned by `from`.
1015      *
1016      * Emits a {Transfer} event.
1017      */
1018     function transferFrom(
1019         address from,
1020         address to,
1021         uint256 tokenId
1022     ) public virtual override {
1023         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1024 
1025         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1026 
1027         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1028 
1029         // The nested ifs save around 20+ gas over a compound boolean condition.
1030         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1031             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1032 
1033         if (to == address(0)) revert TransferToZeroAddress();
1034 
1035         _beforeTokenTransfers(from, to, tokenId, 1);
1036 
1037         // Clear approvals from the previous owner.
1038         assembly {
1039             if approvedAddress {
1040                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1041                 sstore(approvedAddressSlot, 0)
1042             }
1043         }
1044 
1045         // Underflow of the sender's balance is impossible because we check for
1046         // ownership above and the recipient's balance can't realistically overflow.
1047         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1048         unchecked {
1049             // We can directly increment and decrement the balances.
1050             --_packedAddressData[from]; // Updates: `balance -= 1`.
1051             ++_packedAddressData[to]; // Updates: `balance += 1`.
1052 
1053             // Updates:
1054             // - `address` to the next owner.
1055             // - `startTimestamp` to the timestamp of transfering.
1056             // - `burned` to `false`.
1057             // - `nextInitialized` to `true`.
1058             _packedOwnerships[tokenId] = _packOwnershipData(
1059                 to,
1060                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1061             );
1062 
1063             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1064             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1065                 uint256 nextTokenId = tokenId + 1;
1066                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1067                 if (_packedOwnerships[nextTokenId] == 0) {
1068                     // If the next slot is within bounds.
1069                     if (nextTokenId != _currentIndex) {
1070                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1071                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1072                     }
1073                 }
1074             }
1075         }
1076 
1077         emit Transfer(from, to, tokenId);
1078         _afterTokenTransfers(from, to, tokenId, 1);
1079     }
1080 
1081     /**
1082      * @dev Equivalent to `_burn(tokenId, false)`.
1083      */
1084     function _burn(uint256 tokenId) internal virtual {
1085         _burn(tokenId, false);
1086     }
1087 
1088     /**
1089      * @dev Destroys `tokenId`.
1090      * The approval is cleared when the token is burned.
1091      *
1092      * Requirements:
1093      *
1094      * - `tokenId` must exist.
1095      *
1096      * Emits a {Transfer} event.
1097      */
1098     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1099         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1100 
1101         address from = address(uint160(prevOwnershipPacked));
1102 
1103         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1104 
1105         if (approvalCheck) {
1106             // The nested ifs save around 20+ gas over a compound boolean condition.
1107             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1108                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1109         }
1110 
1111         _beforeTokenTransfers(from, address(0), tokenId, 1);
1112 
1113         // Clear approvals from the previous owner.
1114         assembly {
1115             if approvedAddress {
1116                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1117                 sstore(approvedAddressSlot, 0)
1118             }
1119         }
1120 
1121         // Underflow of the sender's balance is impossible because we check for
1122         // ownership above and the recipient's balance can't realistically overflow.
1123         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1124         unchecked {
1125             // Updates:
1126             // - `balance -= 1`.
1127             // - `numberBurned += 1`.
1128             //
1129             // We can directly decrement the balance, and increment the number burned.
1130             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1131             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1132 
1133             // Updates:
1134             // - `address` to the last owner.
1135             // - `startTimestamp` to the timestamp of burning.
1136             // - `burned` to `true`.
1137             // - `nextInitialized` to `true`.
1138             _packedOwnerships[tokenId] = _packOwnershipData(
1139                 from,
1140                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1141             );
1142 
1143             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1144             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1145                 uint256 nextTokenId = tokenId + 1;
1146                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1147                 if (_packedOwnerships[nextTokenId] == 0) {
1148                     // If the next slot is within bounds.
1149                     if (nextTokenId != _currentIndex) {
1150                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1151                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1152                     }
1153                 }
1154             }
1155         }
1156 
1157         emit Transfer(from, address(0), tokenId);
1158         _afterTokenTransfers(from, address(0), tokenId, 1);
1159 
1160         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1161         unchecked {
1162             _burnCounter++;
1163         }
1164     }
1165 
1166     /**
1167      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1168      *
1169      * @param from address representing the previous owner of the given token ID
1170      * @param to target address that will receive the tokens
1171      * @param tokenId uint256 ID of the token to be transferred
1172      * @param _data bytes optional data to send along with the call
1173      * @return bool whether the call correctly returned the expected magic value
1174      */
1175     function _checkContractOnERC721Received(
1176         address from,
1177         address to,
1178         uint256 tokenId,
1179         bytes memory _data
1180     ) private returns (bool) {
1181         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1182             bytes4 retval
1183         ) {
1184             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1185         } catch (bytes memory reason) {
1186             if (reason.length == 0) {
1187                 revert TransferToNonERC721ReceiverImplementer();
1188             } else {
1189                 assembly {
1190                     revert(add(32, reason), mload(reason))
1191                 }
1192             }
1193         }
1194     }
1195 
1196     /**
1197      * @dev Directly sets the extra data for the ownership data `index`.
1198      */
1199     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1200         uint256 packed = _packedOwnerships[index];
1201         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1202         uint256 extraDataCasted;
1203         // Cast `extraData` with assembly to avoid redundant masking.
1204         assembly {
1205             extraDataCasted := extraData
1206         }
1207         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1208         _packedOwnerships[index] = packed;
1209     }
1210 
1211     /**
1212      * @dev Returns the next extra data for the packed ownership data.
1213      * The returned result is shifted into position.
1214      */
1215     function _nextExtraData(
1216         address from,
1217         address to,
1218         uint256 prevOwnershipPacked
1219     ) private view returns (uint256) {
1220         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1221         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1222     }
1223 
1224     /**
1225      * @dev Called during each token transfer to set the 24bit `extraData` field.
1226      * Intended to be overridden by the cosumer contract.
1227      *
1228      * `previousExtraData` - the value of `extraData` before transfer.
1229      *
1230      * Calling conditions:
1231      *
1232      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1233      * transferred to `to`.
1234      * - When `from` is zero, `tokenId` will be minted for `to`.
1235      * - When `to` is zero, `tokenId` will be burned by `from`.
1236      * - `from` and `to` are never both zero.
1237      */
1238     function _extraData(
1239         address from,
1240         address to,
1241         uint24 previousExtraData
1242     ) internal view virtual returns (uint24) {}
1243 
1244     /**
1245      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1246      * This includes minting.
1247      * And also called before burning one token.
1248      *
1249      * startTokenId - the first token id to be transferred
1250      * quantity - the amount to be transferred
1251      *
1252      * Calling conditions:
1253      *
1254      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1255      * transferred to `to`.
1256      * - When `from` is zero, `tokenId` will be minted for `to`.
1257      * - When `to` is zero, `tokenId` will be burned by `from`.
1258      * - `from` and `to` are never both zero.
1259      */
1260     function _beforeTokenTransfers(
1261         address from,
1262         address to,
1263         uint256 startTokenId,
1264         uint256 quantity
1265     ) internal virtual {}
1266 
1267     /**
1268      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1269      * This includes minting.
1270      * And also called after one token has been burned.
1271      *
1272      * startTokenId - the first token id to be transferred
1273      * quantity - the amount to be transferred
1274      *
1275      * Calling conditions:
1276      *
1277      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1278      * transferred to `to`.
1279      * - When `from` is zero, `tokenId` has been minted for `to`.
1280      * - When `to` is zero, `tokenId` has been burned by `from`.
1281      * - `from` and `to` are never both zero.
1282      */
1283     function _afterTokenTransfers(
1284         address from,
1285         address to,
1286         uint256 startTokenId,
1287         uint256 quantity
1288     ) internal virtual {}
1289 
1290     /**
1291      * @dev Returns the message sender (defaults to `msg.sender`).
1292      *
1293      * If you are writing GSN compatible contracts, you need to override this function.
1294      */
1295     function _msgSenderERC721A() internal view virtual returns (address) {
1296         return msg.sender;
1297     }
1298 
1299     /**
1300      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1301      */
1302     function _toString(uint256 value) internal pure returns (string memory ptr) {
1303         assembly {
1304             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1305             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1306             // We will need 1 32-byte word to store the length,
1307             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1308             ptr := add(mload(0x40), 128)
1309             // Update the free memory pointer to allocate.
1310             mstore(0x40, ptr)
1311 
1312             // Cache the end of the memory to calculate the length later.
1313             let end := ptr
1314 
1315             // We write the string from the rightmost digit to the leftmost digit.
1316             // The following is essentially a do-while loop that also handles the zero case.
1317             // Costs a bit more than early returning for the zero case,
1318             // but cheaper in terms of deployment and overall runtime costs.
1319             for {
1320                 // Initialize and perform the first pass without check.
1321                 let temp := value
1322                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1323                 ptr := sub(ptr, 1)
1324                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1325                 mstore8(ptr, add(48, mod(temp, 10)))
1326                 temp := div(temp, 10)
1327             } temp {
1328                 // Keep dividing `temp` until zero.
1329                 temp := div(temp, 10)
1330             } {
1331                 // Body of the for loop.
1332                 ptr := sub(ptr, 1)
1333                 mstore8(ptr, add(48, mod(temp, 10)))
1334             }
1335 
1336             let length := sub(end, ptr)
1337             // Move the pointer 32 bytes leftwards to make room for the length.
1338             ptr := sub(ptr, 32)
1339             // Store the length.
1340             mstore(ptr, length)
1341         }
1342     }
1343 }
1344 
1345 // File: contracts/STEPN3rdRealm.sol
1346 
1347 
1348 pragma solidity ^0.8.14;
1349 
1350 
1351 
1352 contract STEPN3rdRealm is ERC721A, Ownable {
1353   
1354   uint256 public mintPrice = 0.009 ether;
1355 
1356   string _baseTokenURI;
1357 
1358   bool public isActive = false;
1359 
1360   uint256 public MAX_SUPPLY = 2000;
1361   uint256 public constant FREE_MAX_SUPPLY = 1500;
1362   uint256 public constant MAX_FREE_PER_WALLET = 2;
1363   uint256 public constant MAX_FREE_PER_TX = 2;
1364   uint256 public maximumAllowedTokensPerPurchase = 20;
1365   uint256 public maximumAllowedTokensPerWallet = 20;
1366 
1367   constructor(string memory baseURI) ERC721A("STEPN3rdRealm", "STEPN 3rd Realm") {
1368     setBaseURI(baseURI);
1369   }
1370 
1371   modifier saleIsOpen {
1372     require(totalSupply() <= MAX_SUPPLY, "Sale has ended.");
1373     _;
1374   }
1375 
1376   function setMaximumAllowedTokens(uint256 _count) public onlyOwner {
1377     maximumAllowedTokensPerPurchase = _count;
1378   }
1379 
1380 
1381   function setMaximumAllowedTokensPerWallet(uint256 _count) public onlyOwner {
1382     maximumAllowedTokensPerWallet = _count;
1383   }
1384 
1385   function setMaxMintSupply(uint256 maxMintSupply) external  onlyOwner {
1386     MAX_SUPPLY = maxMintSupply;
1387   }
1388 
1389 
1390   function setPrice(uint256 _price) public onlyOwner {
1391     mintPrice = _price;
1392   }
1393 
1394   function toggleSaleStatus() public onlyOwner {
1395     isActive = !isActive;
1396   }
1397 
1398   function setBaseURI(string memory baseURI) public onlyOwner {
1399     _baseTokenURI = baseURI;
1400   }
1401 
1402 
1403   function _baseURI() internal view virtual override returns (string memory) {
1404     return _baseTokenURI;
1405   }
1406 
1407   function mint(uint256 _count) public payable saleIsOpen {
1408     uint256 mintIndex = totalSupply();
1409 
1410     require(isActive, "Sale is not active currently.");
1411     require(mintIndex + _count <= MAX_SUPPLY, "Total supply exceeded.");
1412     require(balanceOf(msg.sender) + _count <= maximumAllowedTokensPerWallet, "Max holding cap reached.");
1413     require( _count <= maximumAllowedTokensPerPurchase, "Exceeds maximum allowed tokens");
1414 
1415     if(mintIndex < FREE_MAX_SUPPLY) {
1416       require(balanceOf(msg.sender) + _count <= MAX_FREE_PER_WALLET, "Max FREE holding cap reached.");
1417       require( _count <= MAX_FREE_PER_TX, "Exceeds FREE allowed tokens per TX");
1418     }
1419 
1420     if(mintIndex > FREE_MAX_SUPPLY) {
1421       if(balanceOf(msg.sender) >= 2) {
1422         require(msg.value >= mintPrice * _count, "Insufficient ETH amount sent.");
1423       }
1424     }
1425 
1426     _safeMint(msg.sender, _count);
1427     
1428   }
1429 
1430   function withdraw() external onlyOwner {
1431     uint balance = address(this).balance;
1432     payable(owner()).transfer(balance);
1433   }
1434 }