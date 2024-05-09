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
32 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
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
62      * @dev Returns the address of the current owner.
63      */
64     function owner() public view virtual returns (address) {
65         return _owner;
66     }
67 
68     /**
69      * @dev Throws if called by any account other than the owner.
70      */
71     modifier onlyOwner() {
72         require(owner() == _msgSender(), "Ownable: caller is not the owner");
73         _;
74     }
75 
76     /**
77      * @dev Leaves the contract without owner. It will not be possible to call
78      * `onlyOwner` functions anymore. Can only be called by the current owner.
79      *
80      * NOTE: Renouncing ownership will leave the contract without an owner,
81      * thereby removing any functionality that is only available to the owner.
82      */
83     function renounceOwnership() public virtual onlyOwner {
84         _transferOwnership(address(0));
85     }
86 
87     /**
88      * @dev Transfers ownership of the contract to a new account (`newOwner`).
89      * Can only be called by the current owner.
90      */
91     function transferOwnership(address newOwner) public virtual onlyOwner {
92         require(newOwner != address(0), "Ownable: new owner is the zero address");
93         _transferOwnership(newOwner);
94     }
95 
96     /**
97      * @dev Transfers ownership of the contract to a new account (`newOwner`).
98      * Internal function without access restriction.
99      */
100     function _transferOwnership(address newOwner) internal virtual {
101         address oldOwner = _owner;
102         _owner = newOwner;
103         emit OwnershipTransferred(oldOwner, newOwner);
104     }
105 }
106 
107 // File: contracts/IERC721A.sol
108 
109 
110 // ERC721A Contracts v4.1.0
111 // Creator: Chiru Labs
112 
113 pragma solidity ^0.8.4;
114 
115 /**
116  * @dev Interface of an ERC721A compliant contract.
117  */
118 interface IERC721A {
119     /**
120      * The caller must own the token or be an approved operator.
121      */
122     error ApprovalCallerNotOwnerNorApproved();
123 
124     /**
125      * The token does not exist.
126      */
127     error ApprovalQueryForNonexistentToken();
128 
129     /**
130      * The caller cannot approve to their own address.
131      */
132     error ApproveToCaller();
133 
134     /**
135      * Cannot query the balance for the zero address.
136      */
137     error BalanceQueryForZeroAddress();
138 
139     /**
140      * Cannot mint to the zero address.
141      */
142     error MintToZeroAddress();
143 
144     /**
145      * The quantity of tokens minted must be more than zero.
146      */
147     error MintZeroQuantity();
148 
149     /**
150      * The token does not exist.
151      */
152     error OwnerQueryForNonexistentToken();
153 
154     /**
155      * The caller must own the token or be an approved operator.
156      */
157     error TransferCallerNotOwnerNorApproved();
158 
159     /**
160      * The token must be owned by `from`.
161      */
162     error TransferFromIncorrectOwner();
163 
164     /**
165      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
166      */
167     error TransferToNonERC721ReceiverImplementer();
168 
169     /**
170      * Cannot transfer to the zero address.
171      */
172     error TransferToZeroAddress();
173 
174     /**
175      * The token does not exist.
176      */
177     error URIQueryForNonexistentToken();
178 
179     /**
180      * The `quantity` minted with ERC2309 exceeds the safety limit.
181      */
182     error MintERC2309QuantityExceedsLimit();
183 
184     /**
185      * The `extraData` cannot be set on an unintialized ownership slot.
186      */
187     error OwnershipNotInitializedForExtraData();
188 
189     struct TokenOwnership {
190         // The address of the owner.
191         address addr;
192         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
193         uint64 startTimestamp;
194         // Whether the token has been burned.
195         bool burned;
196         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
197         uint24 extraData;
198     }
199 
200     /**
201      * @dev Returns the total amount of tokens stored by the contract.
202      *
203      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
204      */
205     function totalSupply() external view returns (uint256);
206 
207     // ==============================
208     //            IERC165
209     // ==============================
210 
211     /**
212      * @dev Returns true if this contract implements the interface defined by
213      * `interfaceId`. See the corresponding
214      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
215      * to learn more about how these ids are created.
216      *
217      * This function call must use less than 30 000 gas.
218      */
219     function supportsInterface(bytes4 interfaceId) external view returns (bool);
220 
221     // ==============================
222     //            IERC721
223     // ==============================
224 
225     /**
226      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
227      */
228     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
229 
230     /**
231      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
232      */
233     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
234 
235     /**
236      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
237      */
238     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
239 
240     /**
241      * @dev Returns the number of tokens in ``owner``'s account.
242      */
243     function balanceOf(address owner) external view returns (uint256 balance);
244 
245     /**
246      * @dev Returns the owner of the `tokenId` token.
247      *
248      * Requirements:
249      *
250      * - `tokenId` must exist.
251      */
252     function ownerOf(uint256 tokenId) external view returns (address owner);
253 
254     /**
255      * @dev Safely transfers `tokenId` token from `from` to `to`.
256      *
257      * Requirements:
258      *
259      * - `from` cannot be the zero address.
260      * - `to` cannot be the zero address.
261      * - `tokenId` token must exist and be owned by `from`.
262      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
263      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
264      *
265      * Emits a {Transfer} event.
266      */
267     function safeTransferFrom(
268         address from,
269         address to,
270         uint256 tokenId,
271         bytes calldata data
272     ) external;
273 
274     /**
275      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
276      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
277      *
278      * Requirements:
279      *
280      * - `from` cannot be the zero address.
281      * - `to` cannot be the zero address.
282      * - `tokenId` token must exist and be owned by `from`.
283      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
284      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
285      *
286      * Emits a {Transfer} event.
287      */
288     function safeTransferFrom(
289         address from,
290         address to,
291         uint256 tokenId
292     ) external;
293 
294     /**
295      * @dev Transfers `tokenId` token from `from` to `to`.
296      *
297      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
298      *
299      * Requirements:
300      *
301      * - `from` cannot be the zero address.
302      * - `to` cannot be the zero address.
303      * - `tokenId` token must be owned by `from`.
304      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
305      *
306      * Emits a {Transfer} event.
307      */
308     function transferFrom(
309         address from,
310         address to,
311         uint256 tokenId
312     ) external;
313 
314     /**
315      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
316      * The approval is cleared when the token is transferred.
317      *
318      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
319      *
320      * Requirements:
321      *
322      * - The caller must own the token or be an approved operator.
323      * - `tokenId` must exist.
324      *
325      * Emits an {Approval} event.
326      */
327     function approve(address to, uint256 tokenId) external;
328 
329     /**
330      * @dev Approve or remove `operator` as an operator for the caller.
331      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
332      *
333      * Requirements:
334      *
335      * - The `operator` cannot be the caller.
336      *
337      * Emits an {ApprovalForAll} event.
338      */
339     function setApprovalForAll(address operator, bool _approved) external;
340 
341     /**
342      * @dev Returns the account approved for `tokenId` token.
343      *
344      * Requirements:
345      *
346      * - `tokenId` must exist.
347      */
348     function getApproved(uint256 tokenId) external view returns (address operator);
349 
350     /**
351      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
352      *
353      * See {setApprovalForAll}
354      */
355     function isApprovedForAll(address owner, address operator) external view returns (bool);
356 
357     // ==============================
358     //        IERC721Metadata
359     // ==============================
360 
361     /**
362      * @dev Returns the token collection name.
363      */
364     function name() external view returns (string memory);
365 
366     /**
367      * @dev Returns the token collection symbol.
368      */
369     function symbol() external view returns (string memory);
370 
371     /**
372      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
373      */
374     function tokenURI(uint256 tokenId) external view returns (string memory);
375 
376     // ==============================
377     //            IERC2309
378     // ==============================
379 
380     /**
381      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
382      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
383      */
384     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
385 }
386 
387 // File: contracts/ERC721A.sol
388 
389 
390 // ERC721A Contracts v4.1.0
391 // Creator: Chiru Labs
392 
393 pragma solidity ^0.8.4;
394 
395 
396 /**
397  * @dev ERC721 token receiver interface.
398  */
399 interface ERC721A__IERC721Receiver {
400     function onERC721Received(
401         address operator,
402         address from,
403         uint256 tokenId,
404         bytes calldata data
405     ) external returns (bytes4);
406 }
407 
408 /**
409  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
410  * including the Metadata extension. Built to optimize for lower gas during batch mints.
411  *
412  * Assumes serials are sequentially minted starting at `_startTokenId()`
413  * (defaults to 0, e.g. 0, 1, 2, 3..).
414  *
415  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
416  *
417  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
418  */
419 contract ERC721A is IERC721A {
420     // Mask of an entry in packed address data.
421     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
422 
423     // The bit position of `numberMinted` in packed address data.
424     uint256 private constant BITPOS_NUMBER_MINTED = 64;
425 
426     // The bit position of `numberBurned` in packed address data.
427     uint256 private constant BITPOS_NUMBER_BURNED = 128;
428 
429     // The bit position of `aux` in packed address data.
430     uint256 private constant BITPOS_AUX = 192;
431 
432     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
433     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
434 
435     // The bit position of `startTimestamp` in packed ownership.
436     uint256 private constant BITPOS_START_TIMESTAMP = 160;
437 
438     // The bit mask of the `burned` bit in packed ownership.
439     uint256 private constant BITMASK_BURNED = 1 << 224;
440 
441     // The bit position of the `nextInitialized` bit in packed ownership.
442     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
443 
444     // The bit mask of the `nextInitialized` bit in packed ownership.
445     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
446 
447     // The bit position of `extraData` in packed ownership.
448     uint256 private constant BITPOS_EXTRA_DATA = 232;
449 
450     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
451     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
452 
453     // The mask of the lower 160 bits for addresses.
454     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
455 
456     // The maximum `quantity` that can be minted with `_mintERC2309`.
457     // This limit is to prevent overflows on the address data entries.
458     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
459     // is required to cause an overflow, which is unrealistic.
460     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
461 
462     // The tokenId of the next token to be minted.
463     uint256 private _currentIndex;
464 
465     // The number of tokens burned.
466     uint256 private _burnCounter;
467 
468     // Token name
469     string private _name;
470 
471     // Token symbol
472     string private _symbol;
473 
474     // Mapping from token ID to ownership details
475     // An empty struct value does not necessarily mean the token is unowned.
476     // See `_packedOwnershipOf` implementation for details.
477     //
478     // Bits Layout:
479     // - [0..159]   `addr`
480     // - [160..223] `startTimestamp`
481     // - [224]      `burned`
482     // - [225]      `nextInitialized`
483     // - [232..255] `extraData`
484     mapping(uint256 => uint256) private _packedOwnerships;
485 
486     // Mapping owner address to address data.
487     //
488     // Bits Layout:
489     // - [0..63]    `balance`
490     // - [64..127]  `numberMinted`
491     // - [128..191] `numberBurned`
492     // - [192..255] `aux`
493     mapping(address => uint256) private _packedAddressData;
494 
495     // Mapping from token ID to approved address.
496     mapping(uint256 => address) private _tokenApprovals;
497 
498     // Mapping from owner to operator approvals
499     mapping(address => mapping(address => bool)) private _operatorApprovals;
500 
501     constructor(string memory name_, string memory symbol_) {
502         _name = name_;
503         _symbol = symbol_;
504         _currentIndex = _startTokenId();
505     }
506 
507     /**
508      * @dev Returns the starting token ID.
509      * To change the starting token ID, please override this function.
510      */
511     function _startTokenId() internal view virtual returns (uint256) {
512         return 1;
513     }
514 
515     /**
516      * @dev Returns the next token ID to be minted.
517      */
518     function _nextTokenId() internal view returns (uint256) {
519         return _currentIndex;
520     }
521 
522     /**
523      * @dev Returns the total number of tokens in existence.
524      * Burned tokens will reduce the count.
525      * To get the total number of tokens minted, please see `_totalMinted`.
526      */
527     function totalSupply() public view override returns (uint256) {
528         // Counter underflow is impossible as _burnCounter cannot be incremented
529         // more than `_currentIndex - _startTokenId()` times.
530         unchecked {
531             return _currentIndex - _burnCounter - _startTokenId();
532         }
533     }
534 
535     /**
536      * @dev Returns the total amount of tokens minted in the contract.
537      */
538     function _totalMinted() internal view returns (uint256) {
539         // Counter underflow is impossible as _currentIndex does not decrement,
540         // and it is initialized to `_startTokenId()`
541         unchecked {
542             return _currentIndex - _startTokenId();
543         }
544     }
545 
546     /**
547      * @dev Returns the total number of tokens burned.
548      */
549     function _totalBurned() internal view returns (uint256) {
550         return _burnCounter;
551     }
552 
553     /**
554      * @dev See {IERC165-supportsInterface}.
555      */
556     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
557         // The interface IDs are constants representing the first 4 bytes of the XOR of
558         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
559         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
560         return
561             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
562             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
563             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
564     }
565 
566     /**
567      * @dev See {IERC721-balanceOf}.
568      */
569     function balanceOf(address owner) public view override returns (uint256) {
570         if (owner == address(0)) revert BalanceQueryForZeroAddress();
571         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
572     }
573 
574     /**
575      * Returns the number of tokens minted by `owner`.
576      */
577     function _numberMinted(address owner) internal view returns (uint256) {
578         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
579     }
580 
581     /**
582      * Returns the number of tokens burned by or on behalf of `owner`.
583      */
584     function _numberBurned(address owner) internal view returns (uint256) {
585         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
586     }
587 
588     /**
589      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
590      */
591     function _getAux(address owner) internal view returns (uint64) {
592         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
593     }
594 
595     /**
596      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
597      * If there are multiple variables, please pack them into a uint64.
598      */
599     function _setAux(address owner, uint64 aux) internal {
600         uint256 packed = _packedAddressData[owner];
601         uint256 auxCasted;
602         // Cast `aux` with assembly to avoid redundant masking.
603         assembly {
604             auxCasted := aux
605         }
606         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
607         _packedAddressData[owner] = packed;
608     }
609 
610     /**
611      * Returns the packed ownership data of `tokenId`.
612      */
613     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
614         uint256 curr = tokenId;
615 
616         unchecked {
617             if (_startTokenId() <= curr)
618                 if (curr < _currentIndex) {
619                     uint256 packed = _packedOwnerships[curr];
620                     // If not burned.
621                     if (packed & BITMASK_BURNED == 0) {
622                         // Invariant:
623                         // There will always be an ownership that has an address and is not burned
624                         // before an ownership that does not have an address and is not burned.
625                         // Hence, curr will not underflow.
626                         //
627                         // We can directly compare the packed value.
628                         // If the address is zero, packed is zero.
629                         while (packed == 0) {
630                             packed = _packedOwnerships[--curr];
631                         }
632                         return packed;
633                     }
634                 }
635         }
636         revert OwnerQueryForNonexistentToken();
637     }
638 
639     /**
640      * Returns the unpacked `TokenOwnership` struct from `packed`.
641      */
642     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
643         ownership.addr = address(uint160(packed));
644         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
645         ownership.burned = packed & BITMASK_BURNED != 0;
646         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
647     }
648 
649     /**
650      * Returns the unpacked `TokenOwnership` struct at `index`.
651      */
652     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
653         return _unpackedOwnership(_packedOwnerships[index]);
654     }
655 
656     /**
657      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
658      */
659     function _initializeOwnershipAt(uint256 index) internal {
660         if (_packedOwnerships[index] == 0) {
661             _packedOwnerships[index] = _packedOwnershipOf(index);
662         }
663     }
664 
665     /**
666      * Gas spent here starts off proportional to the maximum mint batch size.
667      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
668      */
669     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
670         return _unpackedOwnership(_packedOwnershipOf(tokenId));
671     }
672 
673     /**
674      * @dev Packs ownership data into a single uint256.
675      */
676     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
677         assembly {
678             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
679             owner := and(owner, BITMASK_ADDRESS)
680             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
681             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
682         }
683     }
684 
685     /**
686      * @dev See {IERC721-ownerOf}.
687      */
688     function ownerOf(uint256 tokenId) public view override returns (address) {
689         return address(uint160(_packedOwnershipOf(tokenId)));
690     }
691 
692     /**
693      * @dev See {IERC721Metadata-name}.
694      */
695     function name() public view virtual override returns (string memory) {
696         return _name;
697     }
698 
699     /**
700      * @dev See {IERC721Metadata-symbol}.
701      */
702     function symbol() public view virtual override returns (string memory) {
703         return _symbol;
704     }
705 
706     /**
707      * @dev See {IERC721Metadata-tokenURI}.
708      */
709     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
710         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
711 
712         string memory baseURI = _baseURI();
713         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
714     }
715 
716     /**
717      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
718      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
719      * by default, it can be overridden in child contracts.
720      */
721     function _baseURI() internal view virtual returns (string memory) {
722         return '';
723     }
724 
725     /**
726      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
727      */
728     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
729         // For branchless setting of the `nextInitialized` flag.
730         assembly {
731             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
732             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
733         }
734     }
735 
736     /**
737      * @dev See {IERC721-approve}.
738      */
739     function approve(address to, uint256 tokenId) public override {
740         address owner = ownerOf(tokenId);
741 
742         if (_msgSenderERC721A() != owner)
743             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
744                 revert ApprovalCallerNotOwnerNorApproved();
745             }
746 
747         _tokenApprovals[tokenId] = to;
748         emit Approval(owner, to, tokenId);
749     }
750 
751     /**
752      * @dev See {IERC721-getApproved}.
753      */
754     function getApproved(uint256 tokenId) public view override returns (address) {
755         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
756 
757         return _tokenApprovals[tokenId];
758     }
759 
760     /**
761      * @dev See {IERC721-setApprovalForAll}.
762      */
763     function setApprovalForAll(address operator, bool approved) public virtual override {
764         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
765 
766         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
767         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
768     }
769 
770     /**
771      * @dev See {IERC721-isApprovedForAll}.
772      */
773     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
774         return _operatorApprovals[owner][operator];
775     }
776 
777     /**
778      * @dev See {IERC721-safeTransferFrom}.
779      */
780     function safeTransferFrom(
781         address from,
782         address to,
783         uint256 tokenId
784     ) public virtual override {
785         safeTransferFrom(from, to, tokenId, '');
786     }
787 
788     /**
789      * @dev See {IERC721-safeTransferFrom}.
790      */
791     function safeTransferFrom(
792         address from,
793         address to,
794         uint256 tokenId,
795         bytes memory _data
796     ) public virtual override {
797         transferFrom(from, to, tokenId);
798         if (to.code.length != 0)
799             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
800                 revert TransferToNonERC721ReceiverImplementer();
801             }
802     }
803 
804     /**
805      * @dev Returns whether `tokenId` exists.
806      *
807      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
808      *
809      * Tokens start existing when they are minted (`_mint`),
810      */
811     function _exists(uint256 tokenId) internal view returns (bool) {
812         return
813             _startTokenId() <= tokenId &&
814             tokenId < _currentIndex && // If within bounds,
815             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
816     }
817 
818     /**
819      * @dev Equivalent to `_safeMint(to, quantity, '')`.
820      */
821     function _safeMint(address to, uint256 quantity) internal {
822         _safeMint(to, quantity, '');
823     }
824 
825     /**
826      * @dev Safely mints `quantity` tokens and transfers them to `to`.
827      *
828      * Requirements:
829      *
830      * - If `to` refers to a smart contract, it must implement
831      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
832      * - `quantity` must be greater than 0.
833      *
834      * See {_mint}.
835      *
836      * Emits a {Transfer} event for each mint.
837      */
838     function _safeMint(
839         address to,
840         uint256 quantity,
841         bytes memory _data
842     ) internal {
843         _mint(to, quantity);
844 
845         unchecked {
846             if (to.code.length != 0) {
847                 uint256 end = _currentIndex;
848                 uint256 index = end - quantity;
849                 do {
850                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
851                         revert TransferToNonERC721ReceiverImplementer();
852                     }
853                 } while (index < end);
854                 // Reentrancy protection.
855                 if (_currentIndex != end) revert();
856             }
857         }
858     }
859 
860     /**
861      * @dev Mints `quantity` tokens and transfers them to `to`.
862      *
863      * Requirements:
864      *
865      * - `to` cannot be the zero address.
866      * - `quantity` must be greater than 0.
867      *
868      * Emits a {Transfer} event for each mint.
869      */
870     function _mint(address to, uint256 quantity) internal {
871         uint256 startTokenId = _currentIndex;
872         if (to == address(0)) revert MintToZeroAddress();
873         if (quantity == 0) revert MintZeroQuantity();
874 
875         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
876 
877         // Overflows are incredibly unrealistic.
878         // `balance` and `numberMinted` have a maximum limit of 2**64.
879         // `tokenId` has a maximum limit of 2**256.
880         unchecked {
881             // Updates:
882             // - `balance += quantity`.
883             // - `numberMinted += quantity`.
884             //
885             // We can directly add to the `balance` and `numberMinted`.
886             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
887 
888             // Updates:
889             // - `address` to the owner.
890             // - `startTimestamp` to the timestamp of minting.
891             // - `burned` to `false`.
892             // - `nextInitialized` to `quantity == 1`.
893             _packedOwnerships[startTokenId] = _packOwnershipData(
894                 to,
895                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
896             );
897 
898             uint256 tokenId = startTokenId;
899             uint256 end = startTokenId + quantity;
900             do {
901                 emit Transfer(address(0), to, tokenId++);
902             } while (tokenId < end);
903 
904             _currentIndex = end;
905         }
906         _afterTokenTransfers(address(0), to, startTokenId, quantity);
907     }
908 
909     /**
910      * @dev Mints `quantity` tokens and transfers them to `to`.
911      *
912      * This function is intended for efficient minting only during contract creation.
913      *
914      * It emits only one {ConsecutiveTransfer} as defined in
915      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
916      * instead of a sequence of {Transfer} event(s).
917      *
918      * Calling this function outside of contract creation WILL make your contract
919      * non-compliant with the ERC721 standard.
920      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
921      * {ConsecutiveTransfer} event is only permissible during contract creation.
922      *
923      * Requirements:
924      *
925      * - `to` cannot be the zero address.
926      * - `quantity` must be greater than 0.
927      *
928      * Emits a {ConsecutiveTransfer} event.
929      */
930     function _mintERC2309(address to, uint256 quantity) internal {
931         uint256 startTokenId = _currentIndex;
932         if (to == address(0)) revert MintToZeroAddress();
933         if (quantity == 0) revert MintZeroQuantity();
934         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
935 
936         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
937 
938         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
939         unchecked {
940             // Updates:
941             // - `balance += quantity`.
942             // - `numberMinted += quantity`.
943             //
944             // We can directly add to the `balance` and `numberMinted`.
945             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
946 
947             // Updates:
948             // - `address` to the owner.
949             // - `startTimestamp` to the timestamp of minting.
950             // - `burned` to `false`.
951             // - `nextInitialized` to `quantity == 1`.
952             _packedOwnerships[startTokenId] = _packOwnershipData(
953                 to,
954                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
955             );
956 
957             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
958 
959             _currentIndex = startTokenId + quantity;
960         }
961         _afterTokenTransfers(address(0), to, startTokenId, quantity);
962     }
963 
964     /**
965      * @dev Returns the storage slot and value for the approved address of `tokenId`.
966      */
967     function _getApprovedAddress(uint256 tokenId)
968         private
969         view
970         returns (uint256 approvedAddressSlot, address approvedAddress)
971     {
972         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
973         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
974         assembly {
975             // Compute the slot.
976             mstore(0x00, tokenId)
977             mstore(0x20, tokenApprovalsPtr.slot)
978             approvedAddressSlot := keccak256(0x00, 0x40)
979             // Load the slot's value from storage.
980             approvedAddress := sload(approvedAddressSlot)
981         }
982     }
983 
984     /**
985      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
986      */
987     function _isOwnerOrApproved(
988         address approvedAddress,
989         address from,
990         address msgSender
991     ) private pure returns (bool result) {
992         assembly {
993             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
994             from := and(from, BITMASK_ADDRESS)
995             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
996             msgSender := and(msgSender, BITMASK_ADDRESS)
997             // `msgSender == from || msgSender == approvedAddress`.
998             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
999         }
1000     }
1001 
1002     /**
1003      * @dev Transfers `tokenId` from `from` to `to`.
1004      *
1005      * Requirements:
1006      *
1007      * - `to` cannot be the zero address.
1008      * - `tokenId` token must be owned by `from`.
1009      *
1010      * Emits a {Transfer} event.
1011      */
1012     function transferFrom(
1013         address from,
1014         address to,
1015         uint256 tokenId
1016     ) public virtual override {
1017         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1018 
1019         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1020 
1021         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1022 
1023         // The nested ifs save around 20+ gas over a compound boolean condition.
1024         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1025             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1026 
1027         if (to == address(0)) revert TransferToZeroAddress();
1028 
1029         _beforeTokenTransfers(from, to, tokenId, 1);
1030 
1031         // Clear approvals from the previous owner.
1032         assembly {
1033             if approvedAddress {
1034                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1035                 sstore(approvedAddressSlot, 0)
1036             }
1037         }
1038 
1039         // Underflow of the sender's balance is impossible because we check for
1040         // ownership above and the recipient's balance can't realistically overflow.
1041         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1042         unchecked {
1043             // We can directly increment and decrement the balances.
1044             --_packedAddressData[from]; // Updates: `balance -= 1`.
1045             ++_packedAddressData[to]; // Updates: `balance += 1`.
1046 
1047             // Updates:
1048             // - `address` to the next owner.
1049             // - `startTimestamp` to the timestamp of transfering.
1050             // - `burned` to `false`.
1051             // - `nextInitialized` to `true`.
1052             _packedOwnerships[tokenId] = _packOwnershipData(
1053                 to,
1054                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1055             );
1056 
1057             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1058             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1059                 uint256 nextTokenId = tokenId + 1;
1060                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1061                 if (_packedOwnerships[nextTokenId] == 0) {
1062                     // If the next slot is within bounds.
1063                     if (nextTokenId != _currentIndex) {
1064                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1065                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1066                     }
1067                 }
1068             }
1069         }
1070 
1071         emit Transfer(from, to, tokenId);
1072         _afterTokenTransfers(from, to, tokenId, 1);
1073     }
1074 
1075     /**
1076      * @dev Equivalent to `_burn(tokenId, false)`.
1077      */
1078     function _burn(uint256 tokenId) internal virtual {
1079         _burn(tokenId, false);
1080     }
1081 
1082     /**
1083      * @dev Destroys `tokenId`.
1084      * The approval is cleared when the token is burned.
1085      *
1086      * Requirements:
1087      *
1088      * - `tokenId` must exist.
1089      *
1090      * Emits a {Transfer} event.
1091      */
1092     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1093         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1094 
1095         address from = address(uint160(prevOwnershipPacked));
1096 
1097         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1098 
1099         if (approvalCheck) {
1100             // The nested ifs save around 20+ gas over a compound boolean condition.
1101             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1102                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1103         }
1104 
1105         _beforeTokenTransfers(from, address(0), tokenId, 1);
1106 
1107         // Clear approvals from the previous owner.
1108         assembly {
1109             if approvedAddress {
1110                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1111                 sstore(approvedAddressSlot, 0)
1112             }
1113         }
1114 
1115         // Underflow of the sender's balance is impossible because we check for
1116         // ownership above and the recipient's balance can't realistically overflow.
1117         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1118         unchecked {
1119             // Updates:
1120             // - `balance -= 1`.
1121             // - `numberBurned += 1`.
1122             //
1123             // We can directly decrement the balance, and increment the number burned.
1124             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1125             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1126 
1127             // Updates:
1128             // - `address` to the last owner.
1129             // - `startTimestamp` to the timestamp of burning.
1130             // - `burned` to `true`.
1131             // - `nextInitialized` to `true`.
1132             _packedOwnerships[tokenId] = _packOwnershipData(
1133                 from,
1134                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1135             );
1136 
1137             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1138             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1139                 uint256 nextTokenId = tokenId + 1;
1140                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1141                 if (_packedOwnerships[nextTokenId] == 0) {
1142                     // If the next slot is within bounds.
1143                     if (nextTokenId != _currentIndex) {
1144                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1145                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1146                     }
1147                 }
1148             }
1149         }
1150 
1151         emit Transfer(from, address(0), tokenId);
1152         _afterTokenTransfers(from, address(0), tokenId, 1);
1153 
1154         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1155         unchecked {
1156             _burnCounter++;
1157         }
1158     }
1159 
1160     /**
1161      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1162      *
1163      * @param from address representing the previous owner of the given token ID
1164      * @param to target address that will receive the tokens
1165      * @param tokenId uint256 ID of the token to be transferred
1166      * @param _data bytes optional data to send along with the call
1167      * @return bool whether the call correctly returned the expected magic value
1168      */
1169     function _checkContractOnERC721Received(
1170         address from,
1171         address to,
1172         uint256 tokenId,
1173         bytes memory _data
1174     ) private returns (bool) {
1175         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1176             bytes4 retval
1177         ) {
1178             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1179         } catch (bytes memory reason) {
1180             if (reason.length == 0) {
1181                 revert TransferToNonERC721ReceiverImplementer();
1182             } else {
1183                 assembly {
1184                     revert(add(32, reason), mload(reason))
1185                 }
1186             }
1187         }
1188     }
1189 
1190     /**
1191      * @dev Directly sets the extra data for the ownership data `index`.
1192      */
1193     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1194         uint256 packed = _packedOwnerships[index];
1195         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1196         uint256 extraDataCasted;
1197         // Cast `extraData` with assembly to avoid redundant masking.
1198         assembly {
1199             extraDataCasted := extraData
1200         }
1201         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1202         _packedOwnerships[index] = packed;
1203     }
1204 
1205     /**
1206      * @dev Returns the next extra data for the packed ownership data.
1207      * The returned result is shifted into position.
1208      */
1209     function _nextExtraData(
1210         address from,
1211         address to,
1212         uint256 prevOwnershipPacked
1213     ) private view returns (uint256) {
1214         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1215         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1216     }
1217 
1218     /**
1219      * @dev Called during each token transfer to set the 24bit `extraData` field.
1220      * Intended to be overridden by the cosumer contract.
1221      *
1222      * `previousExtraData` - the value of `extraData` before transfer.
1223      *
1224      * Calling conditions:
1225      *
1226      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1227      * transferred to `to`.
1228      * - When `from` is zero, `tokenId` will be minted for `to`.
1229      * - When `to` is zero, `tokenId` will be burned by `from`.
1230      * - `from` and `to` are never both zero.
1231      */
1232     function _extraData(
1233         address from,
1234         address to,
1235         uint24 previousExtraData
1236     ) internal view virtual returns (uint24) {}
1237 
1238     /**
1239      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1240      * This includes minting.
1241      * And also called before burning one token.
1242      *
1243      * startTokenId - the first token id to be transferred
1244      * quantity - the amount to be transferred
1245      *
1246      * Calling conditions:
1247      *
1248      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1249      * transferred to `to`.
1250      * - When `from` is zero, `tokenId` will be minted for `to`.
1251      * - When `to` is zero, `tokenId` will be burned by `from`.
1252      * - `from` and `to` are never both zero.
1253      */
1254     function _beforeTokenTransfers(
1255         address from,
1256         address to,
1257         uint256 startTokenId,
1258         uint256 quantity
1259     ) internal virtual {}
1260 
1261     /**
1262      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1263      * This includes minting.
1264      * And also called after one token has been burned.
1265      *
1266      * startTokenId - the first token id to be transferred
1267      * quantity - the amount to be transferred
1268      *
1269      * Calling conditions:
1270      *
1271      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1272      * transferred to `to`.
1273      * - When `from` is zero, `tokenId` has been minted for `to`.
1274      * - When `to` is zero, `tokenId` has been burned by `from`.
1275      * - `from` and `to` are never both zero.
1276      */
1277     function _afterTokenTransfers(
1278         address from,
1279         address to,
1280         uint256 startTokenId,
1281         uint256 quantity
1282     ) internal virtual {}
1283 
1284     /**
1285      * @dev Returns the message sender (defaults to `msg.sender`).
1286      *
1287      * If you are writing GSN compatible contracts, you need to override this function.
1288      */
1289     function _msgSenderERC721A() internal view virtual returns (address) {
1290         return msg.sender;
1291     }
1292 
1293     /**
1294      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1295      */
1296     function _toString(uint256 value) internal pure returns (string memory ptr) {
1297         assembly {
1298             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1299             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1300             // We will need 1 32-byte word to store the length,
1301             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1302             ptr := add(mload(0x40), 128)
1303             // Update the free memory pointer to allocate.
1304             mstore(0x40, ptr)
1305 
1306             // Cache the end of the memory to calculate the length later.
1307             let end := ptr
1308 
1309             // We write the string from the rightmost digit to the leftmost digit.
1310             // The following is essentially a do-while loop that also handles the zero case.
1311             // Costs a bit more than early returning for the zero case,
1312             // but cheaper in terms of deployment and overall runtime costs.
1313             for {
1314                 // Initialize and perform the first pass without check.
1315                 let temp := value
1316                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1317                 ptr := sub(ptr, 1)
1318                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1319                 mstore8(ptr, add(48, mod(temp, 10)))
1320                 temp := div(temp, 10)
1321             } temp {
1322                 // Keep dividing `temp` until zero.
1323                 temp := div(temp, 10)
1324             } {
1325                 // Body of the for loop.
1326                 ptr := sub(ptr, 1)
1327                 mstore8(ptr, add(48, mod(temp, 10)))
1328             }
1329 
1330             let length := sub(end, ptr)
1331             // Move the pointer 32 bytes leftwards to make room for the length.
1332             ptr := sub(ptr, 32)
1333             // Store the length.
1334             mstore(ptr, length)
1335         }
1336     }
1337 }
1338 
1339 // File: contracts/AIBonzi.sol
1340 
1341 
1342 // AIBonzi
1343 
1344 /*
1345 Created by https://twitter.com/DanielFreakman
1346 **/
1347 
1348 pragma solidity >=0.8.9 <0.9.0;
1349 
1350 
1351 
1352 contract AIBonzi is ERC721A, Ownable {
1353     string public baseURI;
1354     string public baseExtension = ".json";
1355     string public notRevealedUri;
1356 
1357     uint256 public cost = 0.015 ether;
1358     uint256 public maxSupply = 1000;
1359     uint256 public freeSupply = 300;
1360     uint256 public teamSupply = 10;
1361     uint256 public maxMintAmount = 3;
1362 
1363     bool public pause = true;
1364 
1365     /// @notice Contract is paused
1366     error ContractIsPaused();
1367     /// @notice Zero amount mint
1368     error ZeroAmountMint();
1369     /// @notice Max amount has currently been minted
1370     error MaxSupplyReached();
1371     /// @notice User has reached max mint amount
1372     error MaxMintAmountReached();
1373     /// @notice User has sent the correct amount of ETH
1374     error InsufficientFunds();
1375 
1376     /**
1377     @dev keep track on how many has been minted
1378      */
1379     mapping(address => uint256) public addressMintedBalance;
1380     /**
1381     @dev keep track if user has claimed free NFT
1382      */
1383     mapping(address => bool) private freeClaimed;
1384 
1385     constructor(
1386         string memory _name,
1387         string memory _symbol,
1388         string memory _initBaseURI
1389     ) ERC721A(_name, _symbol) {
1390         setBaseURI(_initBaseURI);
1391     }
1392 
1393     // internal
1394     function _baseURI() internal view virtual override returns (string memory) {
1395         return baseURI;
1396     }
1397 
1398     modifier mintCompliance(uint256 _mintAmount) {
1399         uint256 supply = totalSupply();
1400         if (pause) revert ContractIsPaused();
1401         if (_mintAmount == 0) revert ZeroAmountMint();
1402         if (supply + _mintAmount >= maxSupply) revert MaxSupplyReached();        
1403         if(_mintAmount + addressMintedBalance[msg.sender] > maxMintAmount) revert MaxMintAmountReached();
1404         _;
1405     }
1406 
1407     // public
1408     function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1409         if(!freeClaimed[msg.sender]) {
1410             uint paidAmount = _mintAmount - 1;
1411             if(msg.value != paidAmount * cost) {
1412                 revert InsufficientFunds();
1413             }
1414         } else {            
1415             if(msg.value != _mintAmount * cost) {
1416                 revert InsufficientFunds();
1417             }
1418         }
1419             
1420         addressMintedBalance[msg.sender] += _mintAmount;
1421         freeClaimed[msg.sender] = true;
1422 
1423         _safeMint(msg.sender, _mintAmount);
1424     }
1425 
1426     // owner mint
1427     function mintForOwner(uint256 _mintAmount) public onlyOwner {
1428         uint256 supply = totalSupply();
1429         if (maxSupply <= supply + _mintAmount) revert MaxSupplyReached();
1430         _safeMint(msg.sender, _mintAmount);
1431     }
1432 
1433     function contractURI() public view returns (string memory) {
1434          string memory currentBaseURI = _baseURI();
1435         return
1436             bytes(currentBaseURI).length > 0
1437                 ? string(
1438                     abi.encodePacked(
1439                         currentBaseURI,
1440                         "contract-data",
1441                         baseExtension
1442                     )
1443                 )
1444                 : "";
1445     }
1446 
1447     function tokenURI(uint256 tokenId)
1448         public
1449         view
1450         virtual
1451         override
1452         returns (string memory)
1453     {
1454         require(
1455             _exists(tokenId),
1456             "ERC721Metadata: URI query for nonexistent token"
1457         );
1458 
1459         string memory currentBaseURI = _baseURI();
1460         return
1461             bytes(currentBaseURI).length > 0
1462                 ? string(
1463                     abi.encodePacked(
1464                         currentBaseURI,
1465                         _toString(tokenId),
1466                         baseExtension
1467                     )
1468                 )
1469                 : "";
1470     }
1471 
1472     //only owner
1473     function setCost(uint256 _newCost) public onlyOwner {
1474         cost = _newCost;
1475     }
1476 
1477     function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1478         maxMintAmount = _newmaxMintAmount;
1479     }
1480 
1481     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1482         baseURI = _newBaseURI;
1483     }
1484 
1485     function setBaseExtension(string memory _newBaseExtension)
1486         public
1487         onlyOwner
1488     {
1489         baseExtension = _newBaseExtension;
1490     }
1491 
1492     function setPause(bool _state) public onlyOwner {
1493         pause = _state;
1494     }
1495 
1496     function withdraw() public payable onlyOwner {        
1497         uint256 balance = address(this).balance;
1498         payable(msg.sender).transfer(balance);
1499     }
1500 }