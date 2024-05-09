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
113 // File: contracts/contracts/IERC721A.sol
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
392 // File: contracts/contracts/ERC721A.sol
393 
394 
395 // ERC721A Contracts v4.1.0
396 // Creator: Chiru Labs
397 
398 pragma solidity ^0.8.4;
399 
400 
401 /**
402  * @dev ERC721 token receiver interface.
403  */
404 interface ERC721A__IERC721Receiver {
405     function onERC721Received(
406         address operator,
407         address from,
408         uint256 tokenId,
409         bytes calldata data
410     ) external returns (bytes4);
411 }
412 
413 /**
414  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
415  * including the Metadata extension. Built to optimize for lower gas during batch mints.
416  *
417  * Assumes serials are sequentially minted starting at `_startTokenId()`
418  * (defaults to 0, e.g. 0, 1, 2, 3..).
419  *
420  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
421  *
422  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
423  */
424 contract ERC721A is IERC721A {
425     // Mask of an entry in packed address data.
426     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
427 
428     // The bit position of `numberMinted` in packed address data.
429     uint256 private constant BITPOS_NUMBER_MINTED = 64;
430 
431     // The bit position of `numberBurned` in packed address data.
432     uint256 private constant BITPOS_NUMBER_BURNED = 128;
433 
434     // The bit position of `aux` in packed address data.
435     uint256 private constant BITPOS_AUX = 192;
436 
437     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
438     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
439 
440     // The bit position of `startTimestamp` in packed ownership.
441     uint256 private constant BITPOS_START_TIMESTAMP = 160;
442 
443     // The bit mask of the `burned` bit in packed ownership.
444     uint256 private constant BITMASK_BURNED = 1 << 224;
445 
446     // The bit position of the `nextInitialized` bit in packed ownership.
447     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
448 
449     // The bit mask of the `nextInitialized` bit in packed ownership.
450     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
451 
452     // The bit position of `extraData` in packed ownership.
453     uint256 private constant BITPOS_EXTRA_DATA = 232;
454 
455     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
456     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
457 
458     // The mask of the lower 160 bits for addresses.
459     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
460 
461     // The maximum `quantity` that can be minted with `_mintERC2309`.
462     // This limit is to prevent overflows on the address data entries.
463     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
464     // is required to cause an overflow, which is unrealistic.
465     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
466 
467     // The tokenId of the next token to be minted.
468     uint256 private _currentIndex;
469 
470     // The number of tokens burned.
471     uint256 private _burnCounter;
472 
473     // Token name
474     string private _name;
475 
476     // Token symbol
477     string private _symbol;
478 
479     // Mapping from token ID to ownership details
480     // An empty struct value does not necessarily mean the token is unowned.
481     // See `_packedOwnershipOf` implementation for details.
482     //
483     // Bits Layout:
484     // - [0..159]   `addr`
485     // - [160..223] `startTimestamp`
486     // - [224]      `burned`
487     // - [225]      `nextInitialized`
488     // - [232..255] `extraData`
489     mapping(uint256 => uint256) private _packedOwnerships;
490 
491     // Mapping owner address to address data.
492     //
493     // Bits Layout:
494     // - [0..63]    `balance`
495     // - [64..127]  `numberMinted`
496     // - [128..191] `numberBurned`
497     // - [192..255] `aux`
498     mapping(address => uint256) private _packedAddressData;
499 
500     // Mapping from token ID to approved address.
501     mapping(uint256 => address) private _tokenApprovals;
502 
503     // Mapping from owner to operator approvals
504     mapping(address => mapping(address => bool)) private _operatorApprovals;
505 
506     constructor(string memory name_, string memory symbol_) {
507         _name = name_;
508         _symbol = symbol_;
509         _currentIndex = _startTokenId();
510     }
511 
512     /**
513      * @dev Returns the starting token ID.
514      * To change the starting token ID, please override this function.
515      */
516     function _startTokenId() internal view virtual returns (uint256) {
517         return 1;
518     }
519 
520     /**
521      * @dev Returns the next token ID to be minted.
522      */
523     function _nextTokenId() internal view returns (uint256) {
524         return _currentIndex;
525     }
526 
527     /**
528      * @dev Returns the total number of tokens in existence.
529      * Burned tokens will reduce the count.
530      * To get the total number of tokens minted, please see `_totalMinted`.
531      */
532     function totalSupply() public view override returns (uint256) {
533         // Counter underflow is impossible as _burnCounter cannot be incremented
534         // more than `_currentIndex - _startTokenId()` times.
535         unchecked {
536             return _currentIndex - _burnCounter - _startTokenId();
537         }
538     }
539 
540     /**
541      * @dev Returns the total amount of tokens minted in the contract.
542      */
543     function _totalMinted() internal view returns (uint256) {
544         // Counter underflow is impossible as _currentIndex does not decrement,
545         // and it is initialized to `_startTokenId()`
546         unchecked {
547             return _currentIndex - _startTokenId();
548         }
549     }
550 
551     /**
552      * @dev Returns the total number of tokens burned.
553      */
554     function _totalBurned() internal view returns (uint256) {
555         return _burnCounter;
556     }
557 
558     /**
559      * @dev See {IERC165-supportsInterface}.
560      */
561     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
562         // The interface IDs are constants representing the first 4 bytes of the XOR of
563         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
564         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
565         return
566             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
567             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
568             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
569     }
570 
571     /**
572      * @dev See {IERC721-balanceOf}.
573      */
574     function balanceOf(address owner) public view override returns (uint256) {
575         if (owner == address(0)) revert BalanceQueryForZeroAddress();
576         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
577     }
578 
579     /**
580      * Returns the number of tokens minted by `owner`.
581      */
582     function _numberMinted(address owner) internal view returns (uint256) {
583         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
584     }
585 
586     /**
587      * Returns the number of tokens burned by or on behalf of `owner`.
588      */
589     function _numberBurned(address owner) internal view returns (uint256) {
590         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
591     }
592 
593     /**
594      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
595      */
596     function _getAux(address owner) internal view returns (uint64) {
597         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
598     }
599 
600     /**
601      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
602      * If there are multiple variables, please pack them into a uint64.
603      */
604     function _setAux(address owner, uint64 aux) internal {
605         uint256 packed = _packedAddressData[owner];
606         uint256 auxCasted;
607         // Cast `aux` with assembly to avoid redundant masking.
608         assembly {
609             auxCasted := aux
610         }
611         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
612         _packedAddressData[owner] = packed;
613     }
614 
615     /**
616      * Returns the packed ownership data of `tokenId`.
617      */
618     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
619         uint256 curr = tokenId;
620 
621         unchecked {
622             if (_startTokenId() <= curr)
623                 if (curr < _currentIndex) {
624                     uint256 packed = _packedOwnerships[curr];
625                     // If not burned.
626                     if (packed & BITMASK_BURNED == 0) {
627                         // Invariant:
628                         // There will always be an ownership that has an address and is not burned
629                         // before an ownership that does not have an address and is not burned.
630                         // Hence, curr will not underflow.
631                         //
632                         // We can directly compare the packed value.
633                         // If the address is zero, packed is zero.
634                         while (packed == 0) {
635                             packed = _packedOwnerships[--curr];
636                         }
637                         return packed;
638                     }
639                 }
640         }
641         revert OwnerQueryForNonexistentToken();
642     }
643 
644     /**
645      * Returns the unpacked `TokenOwnership` struct from `packed`.
646      */
647     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
648         ownership.addr = address(uint160(packed));
649         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
650         ownership.burned = packed & BITMASK_BURNED != 0;
651         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
652     }
653 
654     /**
655      * Returns the unpacked `TokenOwnership` struct at `index`.
656      */
657     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
658         return _unpackedOwnership(_packedOwnerships[index]);
659     }
660 
661     /**
662      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
663      */
664     function _initializeOwnershipAt(uint256 index) internal {
665         if (_packedOwnerships[index] == 0) {
666             _packedOwnerships[index] = _packedOwnershipOf(index);
667         }
668     }
669 
670     /**
671      * Gas spent here starts off proportional to the maximum mint batch size.
672      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
673      */
674     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
675         return _unpackedOwnership(_packedOwnershipOf(tokenId));
676     }
677 
678     /**
679      * @dev Packs ownership data into a single uint256.
680      */
681     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
682         assembly {
683             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
684             owner := and(owner, BITMASK_ADDRESS)
685             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
686             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
687         }
688     }
689 
690     /**
691      * @dev See {IERC721-ownerOf}.
692      */
693     function ownerOf(uint256 tokenId) public view override returns (address) {
694         return address(uint160(_packedOwnershipOf(tokenId)));
695     }
696 
697     /**
698      * @dev See {IERC721Metadata-name}.
699      */
700     function name() public view virtual override returns (string memory) {
701         return _name;
702     }
703 
704     /**
705      * @dev See {IERC721Metadata-symbol}.
706      */
707     function symbol() public view virtual override returns (string memory) {
708         return _symbol;
709     }
710 
711     /**
712      * @dev See {IERC721Metadata-tokenURI}.
713      */
714     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
715         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
716 
717         string memory baseURI = _baseURI();
718         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId), ".json")) : '';
719     }
720 
721     /**
722      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
723      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
724      * by default, it can be overridden in child contracts.
725      */
726     function _baseURI() internal view virtual returns (string memory) {
727         return '';
728     }
729 
730     /**
731      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
732      */
733     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
734         // For branchless setting of the `nextInitialized` flag.
735         assembly {
736             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
737             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
738         }
739     }
740 
741     /**
742      * @dev See {IERC721-approve}.
743      */
744     function approve(address to, uint256 tokenId) public override {
745         address owner = ownerOf(tokenId);
746 
747         if (_msgSenderERC721A() != owner)
748             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
749                 revert ApprovalCallerNotOwnerNorApproved();
750             }
751 
752         _tokenApprovals[tokenId] = to;
753         emit Approval(owner, to, tokenId);
754     }
755 
756     /**
757      * @dev See {IERC721-getApproved}.
758      */
759     function getApproved(uint256 tokenId) public view override returns (address) {
760         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
761 
762         return _tokenApprovals[tokenId];
763     }
764 
765     /**
766      * @dev See {IERC721-setApprovalForAll}.
767      */
768     function setApprovalForAll(address operator, bool approved) public virtual override {
769         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
770 
771         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
772         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
773     }
774 
775     /**
776      * @dev See {IERC721-isApprovedForAll}.
777      */
778     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
779         return _operatorApprovals[owner][operator];
780     }
781 
782     /**
783      * @dev See {IERC721-safeTransferFrom}.
784      */
785     function safeTransferFrom(
786         address from,
787         address to,
788         uint256 tokenId
789     ) public virtual override {
790         safeTransferFrom(from, to, tokenId, '');
791     }
792 
793     /**
794      * @dev See {IERC721-safeTransferFrom}.
795      */
796     function safeTransferFrom(
797         address from,
798         address to,
799         uint256 tokenId,
800         bytes memory _data
801     ) public virtual override {
802         transferFrom(from, to, tokenId);
803         if (to.code.length != 0)
804             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
805                 revert TransferToNonERC721ReceiverImplementer();
806             }
807     }
808 
809     /**
810      * @dev Returns whether `tokenId` exists.
811      *
812      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
813      *
814      * Tokens start existing when they are minted (`_mint`),
815      */
816     function _exists(uint256 tokenId) internal view returns (bool) {
817         return
818             _startTokenId() <= tokenId &&
819             tokenId < _currentIndex && // If within bounds,
820             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
821     }
822 
823     /**
824      * @dev Equivalent to `_safeMint(to, quantity, '')`.
825      */
826     function _safeMint(address to, uint256 quantity) internal {
827         _safeMint(to, quantity, '');
828     }
829 
830     /**
831      * @dev Safely mints `quantity` tokens and transfers them to `to`.
832      *
833      * Requirements:
834      *
835      * - If `to` refers to a smart contract, it must implement
836      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
837      * - `quantity` must be greater than 0.
838      *
839      * See {_mint}.
840      *
841      * Emits a {Transfer} event for each mint.
842      */
843     function _safeMint(
844         address to,
845         uint256 quantity,
846         bytes memory _data
847     ) internal {
848         _mint(to, quantity);
849 
850         unchecked {
851             if (to.code.length != 0) {
852                 uint256 end = _currentIndex;
853                 uint256 index = end - quantity;
854                 do {
855                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
856                         revert TransferToNonERC721ReceiverImplementer();
857                     }
858                 } while (index < end);
859                 // Reentrancy protection.
860                 if (_currentIndex != end) revert();
861             }
862         }
863     }
864 
865     /**
866      * @dev Mints `quantity` tokens and transfers them to `to`.
867      *
868      * Requirements:
869      *
870      * - `to` cannot be the zero address.
871      * - `quantity` must be greater than 0.
872      *
873      * Emits a {Transfer} event for each mint.
874      */
875     function _mint(address to, uint256 quantity) internal {
876         uint256 startTokenId = _currentIndex;
877         if (to == address(0)) revert MintToZeroAddress();
878         if (quantity == 0) revert MintZeroQuantity();
879 
880         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
881 
882         // Overflows are incredibly unrealistic.
883         // `balance` and `numberMinted` have a maximum limit of 2**64.
884         // `tokenId` has a maximum limit of 2**256.
885         unchecked {
886             // Updates:
887             // - `balance += quantity`.
888             // - `numberMinted += quantity`.
889             //
890             // We can directly add to the `balance` and `numberMinted`.
891             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
892 
893             // Updates:
894             // - `address` to the owner.
895             // - `startTimestamp` to the timestamp of minting.
896             // - `burned` to `false`.
897             // - `nextInitialized` to `quantity == 1`.
898             _packedOwnerships[startTokenId] = _packOwnershipData(
899                 to,
900                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
901             );
902 
903             uint256 tokenId = startTokenId;
904             uint256 end = startTokenId + quantity;
905             do {
906                 emit Transfer(address(0), to, tokenId++);
907             } while (tokenId < end);
908 
909             _currentIndex = end;
910         }
911         _afterTokenTransfers(address(0), to, startTokenId, quantity);
912     }
913 
914     /**
915      * @dev Mints `quantity` tokens and transfers them to `to`.
916      *
917      * This function is intended for efficient minting only during contract creation.
918      *
919      * It emits only one {ConsecutiveTransfer} as defined in
920      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
921      * instead of a sequence of {Transfer} event(s).
922      *
923      * Calling this function outside of contract creation WILL make your contract
924      * non-compliant with the ERC721 standard.
925      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
926      * {ConsecutiveTransfer} event is only permissible during contract creation.
927      *
928      * Requirements:
929      *
930      * - `to` cannot be the zero address.
931      * - `quantity` must be greater than 0.
932      *
933      * Emits a {ConsecutiveTransfer} event.
934      */
935     function _mintERC2309(address to, uint256 quantity) internal {
936         uint256 startTokenId = _currentIndex;
937         if (to == address(0)) revert MintToZeroAddress();
938         if (quantity == 0) revert MintZeroQuantity();
939         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
940 
941         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
942 
943         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
944         unchecked {
945             // Updates:
946             // - `balance += quantity`.
947             // - `numberMinted += quantity`.
948             //
949             // We can directly add to the `balance` and `numberMinted`.
950             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
951 
952             // Updates:
953             // - `address` to the owner.
954             // - `startTimestamp` to the timestamp of minting.
955             // - `burned` to `false`.
956             // - `nextInitialized` to `quantity == 1`.
957             _packedOwnerships[startTokenId] = _packOwnershipData(
958                 to,
959                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
960             );
961 
962             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
963 
964             _currentIndex = startTokenId + quantity;
965         }
966         _afterTokenTransfers(address(0), to, startTokenId, quantity);
967     }
968 
969     /**
970      * @dev Returns the storage slot and value for the approved address of `tokenId`.
971      */
972     function _getApprovedAddress(uint256 tokenId)
973         private
974         view
975         returns (uint256 approvedAddressSlot, address approvedAddress)
976     {
977         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
978         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
979         assembly {
980             // Compute the slot.
981             mstore(0x00, tokenId)
982             mstore(0x20, tokenApprovalsPtr.slot)
983             approvedAddressSlot := keccak256(0x00, 0x40)
984             // Load the slot's value from storage.
985             approvedAddress := sload(approvedAddressSlot)
986         }
987     }
988 
989     /**
990      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
991      */
992     function _isOwnerOrApproved(
993         address approvedAddress,
994         address from,
995         address msgSender
996     ) private pure returns (bool result) {
997         assembly {
998             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
999             from := and(from, BITMASK_ADDRESS)
1000             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1001             msgSender := and(msgSender, BITMASK_ADDRESS)
1002             // `msgSender == from || msgSender == approvedAddress`.
1003             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1004         }
1005     }
1006 
1007     /**
1008      * @dev Transfers `tokenId` from `from` to `to`.
1009      *
1010      * Requirements:
1011      *
1012      * - `to` cannot be the zero address.
1013      * - `tokenId` token must be owned by `from`.
1014      *
1015      * Emits a {Transfer} event.
1016      */
1017     function transferFrom(
1018         address from,
1019         address to,
1020         uint256 tokenId
1021     ) public virtual override {
1022         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1023 
1024         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1025 
1026         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1027 
1028         // The nested ifs save around 20+ gas over a compound boolean condition.
1029         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1030             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1031 
1032         if (to == address(0)) revert TransferToZeroAddress();
1033 
1034         _beforeTokenTransfers(from, to, tokenId, 1);
1035 
1036         // Clear approvals from the previous owner.
1037         assembly {
1038             if approvedAddress {
1039                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1040                 sstore(approvedAddressSlot, 0)
1041             }
1042         }
1043 
1044         // Underflow of the sender's balance is impossible because we check for
1045         // ownership above and the recipient's balance can't realistically overflow.
1046         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1047         unchecked {
1048             // We can directly increment and decrement the balances.
1049             --_packedAddressData[from]; // Updates: `balance -= 1`.
1050             ++_packedAddressData[to]; // Updates: `balance += 1`.
1051 
1052             // Updates:
1053             // - `address` to the next owner.
1054             // - `startTimestamp` to the timestamp of transfering.
1055             // - `burned` to `false`.
1056             // - `nextInitialized` to `true`.
1057             _packedOwnerships[tokenId] = _packOwnershipData(
1058                 to,
1059                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1060             );
1061 
1062             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1063             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1064                 uint256 nextTokenId = tokenId + 1;
1065                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1066                 if (_packedOwnerships[nextTokenId] == 0) {
1067                     // If the next slot is within bounds.
1068                     if (nextTokenId != _currentIndex) {
1069                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1070                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1071                     }
1072                 }
1073             }
1074         }
1075 
1076         emit Transfer(from, to, tokenId);
1077         _afterTokenTransfers(from, to, tokenId, 1);
1078     }
1079 
1080     /**
1081      * @dev Equivalent to `_burn(tokenId, false)`.
1082      */
1083     function _burn(uint256 tokenId) internal virtual {
1084         _burn(tokenId, false);
1085     }
1086 
1087     /**
1088      * @dev Destroys `tokenId`.
1089      * The approval is cleared when the token is burned.
1090      *
1091      * Requirements:
1092      *
1093      * - `tokenId` must exist.
1094      *
1095      * Emits a {Transfer} event.
1096      */
1097     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1098         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1099 
1100         address from = address(uint160(prevOwnershipPacked));
1101 
1102         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1103 
1104         if (approvalCheck) {
1105             // The nested ifs save around 20+ gas over a compound boolean condition.
1106             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1107                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1108         }
1109 
1110         _beforeTokenTransfers(from, address(0), tokenId, 1);
1111 
1112         // Clear approvals from the previous owner.
1113         assembly {
1114             if approvedAddress {
1115                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1116                 sstore(approvedAddressSlot, 0)
1117             }
1118         }
1119 
1120         // Underflow of the sender's balance is impossible because we check for
1121         // ownership above and the recipient's balance can't realistically overflow.
1122         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1123         unchecked {
1124             // Updates:
1125             // - `balance -= 1`.
1126             // - `numberBurned += 1`.
1127             //
1128             // We can directly decrement the balance, and increment the number burned.
1129             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1130             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1131 
1132             // Updates:
1133             // - `address` to the last owner.
1134             // - `startTimestamp` to the timestamp of burning.
1135             // - `burned` to `true`.
1136             // - `nextInitialized` to `true`.
1137             _packedOwnerships[tokenId] = _packOwnershipData(
1138                 from,
1139                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1140             );
1141 
1142             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1143             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1144                 uint256 nextTokenId = tokenId + 1;
1145                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1146                 if (_packedOwnerships[nextTokenId] == 0) {
1147                     // If the next slot is within bounds.
1148                     if (nextTokenId != _currentIndex) {
1149                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1150                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1151                     }
1152                 }
1153             }
1154         }
1155 
1156         emit Transfer(from, address(0), tokenId);
1157         _afterTokenTransfers(from, address(0), tokenId, 1);
1158 
1159         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1160         unchecked {
1161             _burnCounter++;
1162         }
1163     }
1164 
1165     /**
1166      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1167      *
1168      * @param from address representing the previous owner of the given token ID
1169      * @param to target address that will receive the tokens
1170      * @param tokenId uint256 ID of the token to be transferred
1171      * @param _data bytes optional data to send along with the call
1172      * @return bool whether the call correctly returned the expected magic value
1173      */
1174     function _checkContractOnERC721Received(
1175         address from,
1176         address to,
1177         uint256 tokenId,
1178         bytes memory _data
1179     ) private returns (bool) {
1180         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1181             bytes4 retval
1182         ) {
1183             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1184         } catch (bytes memory reason) {
1185             if (reason.length == 0) {
1186                 revert TransferToNonERC721ReceiverImplementer();
1187             } else {
1188                 assembly {
1189                     revert(add(32, reason), mload(reason))
1190                 }
1191             }
1192         }
1193     }
1194 
1195     /**
1196      * @dev Directly sets the extra data for the ownership data `index`.
1197      */
1198     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1199         uint256 packed = _packedOwnerships[index];
1200         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1201         uint256 extraDataCasted;
1202         // Cast `extraData` with assembly to avoid redundant masking.
1203         assembly {
1204             extraDataCasted := extraData
1205         }
1206         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1207         _packedOwnerships[index] = packed;
1208     }
1209 
1210     /**
1211      * @dev Returns the next extra data for the packed ownership data.
1212      * The returned result is shifted into position.
1213      */
1214     function _nextExtraData(
1215         address from,
1216         address to,
1217         uint256 prevOwnershipPacked
1218     ) private view returns (uint256) {
1219         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1220         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1221     }
1222 
1223     /**
1224      * @dev Called during each token transfer to set the 24bit `extraData` field.
1225      * Intended to be overridden by the cosumer contract.
1226      *
1227      * `previousExtraData` - the value of `extraData` before transfer.
1228      *
1229      * Calling conditions:
1230      *
1231      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1232      * transferred to `to`.
1233      * - When `from` is zero, `tokenId` will be minted for `to`.
1234      * - When `to` is zero, `tokenId` will be burned by `from`.
1235      * - `from` and `to` are never both zero.
1236      */
1237     function _extraData(
1238         address from,
1239         address to,
1240         uint24 previousExtraData
1241     ) internal view virtual returns (uint24) {}
1242 
1243     /**
1244      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1245      * This includes minting.
1246      * And also called before burning one token.
1247      *
1248      * startTokenId - the first token id to be transferred
1249      * quantity - the amount to be transferred
1250      *
1251      * Calling conditions:
1252      *
1253      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1254      * transferred to `to`.
1255      * - When `from` is zero, `tokenId` will be minted for `to`.
1256      * - When `to` is zero, `tokenId` will be burned by `from`.
1257      * - `from` and `to` are never both zero.
1258      */
1259     function _beforeTokenTransfers(
1260         address from,
1261         address to,
1262         uint256 startTokenId,
1263         uint256 quantity
1264     ) internal virtual {}
1265 
1266     /**
1267      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1268      * This includes minting.
1269      * And also called after one token has been burned.
1270      *
1271      * startTokenId - the first token id to be transferred
1272      * quantity - the amount to be transferred
1273      *
1274      * Calling conditions:
1275      *
1276      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1277      * transferred to `to`.
1278      * - When `from` is zero, `tokenId` has been minted for `to`.
1279      * - When `to` is zero, `tokenId` has been burned by `from`.
1280      * - `from` and `to` are never both zero.
1281      */
1282     function _afterTokenTransfers(
1283         address from,
1284         address to,
1285         uint256 startTokenId,
1286         uint256 quantity
1287     ) internal virtual {}
1288 
1289     /**
1290      * @dev Returns the message sender (defaults to `msg.sender`).
1291      *
1292      * If you are writing GSN compatible contracts, you need to override this function.
1293      */
1294     function _msgSenderERC721A() internal view virtual returns (address) {
1295         return msg.sender;
1296     }
1297 
1298     /**
1299      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1300      */
1301     function _toString(uint256 value) internal pure returns (string memory ptr) {
1302         assembly {
1303             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1304             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1305             // We will need 1 32-byte word to store the length,
1306             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1307             ptr := add(mload(0x40), 128)
1308             // Update the free memory pointer to allocate.
1309             mstore(0x40, ptr)
1310 
1311             // Cache the end of the memory to calculate the length later.
1312             let end := ptr
1313 
1314             // We write the string from the rightmost digit to the leftmost digit.
1315             // The following is essentially a do-while loop that also handles the zero case.
1316             // Costs a bit more than early returning for the zero case,
1317             // but cheaper in terms of deployment and overall runtime costs.
1318             for {
1319                 // Initialize and perform the first pass without check.
1320                 let temp := value
1321                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1322                 ptr := sub(ptr, 1)
1323                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1324                 mstore8(ptr, add(48, mod(temp, 10)))
1325                 temp := div(temp, 10)
1326             } temp {
1327                 // Keep dividing `temp` until zero.
1328                 temp := div(temp, 10)
1329             } {
1330                 // Body of the for loop.
1331                 ptr := sub(ptr, 1)
1332                 mstore8(ptr, add(48, mod(temp, 10)))
1333             }
1334 
1335             let length := sub(end, ptr)
1336             // Move the pointer 32 bytes leftwards to make room for the length.
1337             ptr := sub(ptr, 32)
1338             // Store the length.
1339             mstore(ptr, length)
1340         }
1341     }
1342 }
1343 // File: contracts/metaforce.sol
1344 
1345 
1346 // MetaForce Army Contract
1347 
1348 pragma solidity ^0.8.4;
1349 
1350 
1351 
1352 contract MetaForceArmy is ERC721A, Ownable {
1353   string public baseURI;
1354   string public baseExtension = ".json";
1355   uint256 public publicCost = 1 wei;
1356   uint256 public maxSupply = 3333;
1357   uint256 public maxMintAmount = 2;
1358   bool public isPublic = false;
1359 
1360     constructor() ERC721A("Meta Force Army", "MFA") {
1361         setBaseURI("https://mint.metaforcearmy.com/nfts/");
1362         _mint(msg.sender, 130);
1363     }
1364 
1365         function setBaseURI(string memory _newBaseURI) public onlyOwner {
1366             baseURI = _newBaseURI;
1367         }
1368 
1369         function setPublicPrice(uint256 _newPrice) public onlyOwner {
1370             publicCost = _newPrice;
1371         }
1372 
1373         function _baseURI() internal view virtual override returns (string memory) {
1374             return baseURI;
1375         }
1376 
1377         function setPublicMint(bool _paused) public {
1378             require(msg.sender == owner(), "You are not the owner");
1379             isPublic = _paused;
1380         }
1381 
1382         function withdraw(uint256 withdrawAmount) public onlyOwner {
1383             require(withdrawAmount <= address(this).balance, "Invalid amount");
1384             payable(msg.sender).transfer(withdrawAmount);
1385         }
1386 
1387         function publicMint(uint256 quantity) external payable {
1388               if (msg.sender != owner()) {
1389                     require(isPublic == true, "Public Mint not activated");
1390                     require((balanceOf(msg.sender) + quantity) <= 2, "Cannot mint more than 2 NFTs per wallet");
1391                     require(quantity > 0, "Cannot mint less than 1");
1392                     require(quantity <= 2, "Cannot mint more than 2");
1393                     require(msg.value >= publicCost * quantity, "Insufficient funds");
1394               }
1395             require(_totalMinted() + quantity <= maxSupply, "Cannot mint more than maxSupply");
1396             _mint(msg.sender, quantity);
1397         }
1398 }