1 // File: contracts/bebeenfts.sol
2 
3 
4 pragma solidity ^0.8.16;
5 
6 abstract contract Context {
7     function _msgSender() internal view virtual returns (address) {
8         return msg.sender;
9     }
10 
11     function _msgData() internal view virtual returns (bytes calldata) {
12         return msg.data;
13     }
14 }
15 
16 abstract contract Ownable is Context {
17     address private _owner;
18 
19     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
20 
21     /**
22      * @dev Initializes the contract setting the deployer as the initial owner.
23      */
24     constructor() {
25         _transferOwnership(_msgSender());
26     }
27 
28     /**
29      * @dev Throws if called by any account other than the owner.
30      */
31     modifier onlyOwner() {
32         _checkOwner();
33         _;
34     }
35 
36     /**
37      * @dev Returns the address of the current owner.
38      */
39     function owner() public view virtual returns (address) {
40         return _owner;
41     }
42 
43     /**
44      * @dev Throws if the sender is not the owner.
45      */
46     function _checkOwner() internal view virtual {
47         require(owner() == _msgSender(), "Ownable: caller is not the owner");
48     }
49 
50     /**
51      * @dev Leaves the contract without owner. It will not be possible to call
52      * `onlyOwner` functions anymore. Can only be called by the current owner.
53      *
54      * NOTE: Renouncing ownership will leave the contract without an owner,
55      * thereby removing any functionality that is only available to the owner.
56      */
57     function renounceOwnership() public virtual onlyOwner {
58         _transferOwnership(address(0));
59     }
60 
61     /**
62      * @dev Transfers ownership of the contract to a new account (`newOwner`).
63      * Can only be called by the current owner.
64      */
65     function transferOwnership(address newOwner) public virtual onlyOwner {
66         require(newOwner != address(0), "Ownable: new owner is the zero address");
67         _transferOwnership(newOwner);
68     }
69 
70     /**
71      * @dev Transfers ownership of the contract to a new account (`newOwner`).
72      * Internal function without access restriction.
73      */
74     function _transferOwnership(address newOwner) internal virtual {
75         address oldOwner = _owner;
76         _owner = newOwner;
77         emit OwnershipTransferred(oldOwner, newOwner);
78     }
79 }
80 
81 interface IERC721A {
82     /**
83      * The caller must own the token or be an approved operator.
84      */
85     error ApprovalCallerNotOwnerNorApproved();
86 
87     /**
88      * The token does not exist.
89      */
90     error ApprovalQueryForNonexistentToken();
91 
92     /**
93      * The caller cannot approve to their own address.
94      */
95     error ApproveToCaller();
96 
97     /**
98      * Cannot query the balance for the zero address.
99      */
100     error BalanceQueryForZeroAddress();
101 
102     /**
103      * Cannot mint to the zero address.
104      */
105     error MintToZeroAddress();
106 
107     /**
108      * The quantity of tokens minted must be more than zero.
109      */
110     error MintZeroQuantity();
111 
112     /**
113      * The token does not exist.
114      */
115     error OwnerQueryForNonexistentToken();
116 
117     /**
118      * The caller must own the token or be an approved operator.
119      */
120     error TransferCallerNotOwnerNorApproved();
121 
122     /**
123      * The token must be owned by `from`.
124      */
125     error TransferFromIncorrectOwner();
126 
127     /**
128      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
129      */
130     error TransferToNonERC721ReceiverImplementer();
131 
132     /**
133      * Cannot transfer to the zero address.
134      */
135     error TransferToZeroAddress();
136 
137     /**
138      * The token does not exist.
139      */
140     error URIQueryForNonexistentToken();
141 
142     /**
143      * The `quantity` minted with ERC2309 exceeds the safety limit.
144      */
145     error MintERC2309QuantityExceedsLimit();
146 
147     /**
148      * The `extraData` cannot be set on an unintialized ownership slot.
149      */
150     error OwnershipNotInitializedForExtraData();
151 
152     struct TokenOwnership {
153         // The address of the owner.
154         address addr;
155         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
156         uint64 startTimestamp;
157         // Whether the token has been burned.
158         bool burned;
159         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
160         uint24 extraData;
161     }
162 
163     /**
164      * @dev Returns the total amount of tokens stored by the contract.
165      *
166      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
167      */
168     function totalSupply() external view returns (uint256);
169 
170     // ==============================
171     //            IERC165
172     // ==============================
173 
174     /**
175      * @dev Returns true if this contract implements the interface defined by
176      * `interfaceId`. See the corresponding
177      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
178      * to learn more about how these ids are created.
179      *
180      * This function call must use less than 30 000 gas.
181      */
182     function supportsInterface(bytes4 interfaceId) external view returns (bool);
183 
184     // ==============================
185     //            IERC721
186     // ==============================
187 
188     /**
189      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
190      */
191     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
192 
193     /**
194      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
195      */
196     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
197 
198     /**
199      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
200      */
201     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
202 
203     /**
204      * @dev Returns the number of tokens in ``owner``'s account.
205      */
206     function balanceOf(address owner) external view returns (uint256 balance);
207 
208     /**
209      * @dev Returns the owner of the `tokenId` token.
210      *
211      * Requirements:
212      *
213      * - `tokenId` must exist.
214      */
215     function ownerOf(uint256 tokenId) external view returns (address owner);
216 
217     /**
218      * @dev Safely transfers `tokenId` token from `from` to `to`.
219      *
220      * Requirements:
221      *
222      * - `from` cannot be the zero address.
223      * - `to` cannot be the zero address.
224      * - `tokenId` token must exist and be owned by `from`.
225      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
226      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
227      *
228      * Emits a {Transfer} event.
229      */
230     function safeTransferFrom(
231         address from,
232         address to,
233         uint256 tokenId,
234         bytes calldata data
235     ) external;
236 
237     /**
238      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
239      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
240      *
241      * Requirements:
242      *
243      * - `from` cannot be the zero address.
244      * - `to` cannot be the zero address.
245      * - `tokenId` token must exist and be owned by `from`.
246      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
247      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
248      *
249      * Emits a {Transfer} event.
250      */
251     function safeTransferFrom(
252         address from,
253         address to,
254         uint256 tokenId
255     ) external;
256 
257     /**
258      * @dev Transfers `tokenId` token from `from` to `to`.
259      *
260      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
261      *
262      * Requirements:
263      *
264      * - `from` cannot be the zero address.
265      * - `to` cannot be the zero address.
266      * - `tokenId` token must be owned by `from`.
267      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
268      *
269      * Emits a {Transfer} event.
270      */
271     function transferFrom(
272         address from,
273         address to,
274         uint256 tokenId
275     ) external;
276 
277     /**
278      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
279      * The approval is cleared when the token is transferred.
280      *
281      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
282      *
283      * Requirements:
284      *
285      * - The caller must own the token or be an approved operator.
286      * - `tokenId` must exist.
287      *
288      * Emits an {Approval} event.
289      */
290     function approve(address to, uint256 tokenId) external;
291 
292     /**
293      * @dev Approve or remove `operator` as an operator for the caller.
294      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
295      *
296      * Requirements:
297      *
298      * - The `operator` cannot be the caller.
299      *
300      * Emits an {ApprovalForAll} event.
301      */
302     function setApprovalForAll(address operator, bool _approved) external;
303 
304     /**
305      * @dev Returns the account approved for `tokenId` token.
306      *
307      * Requirements:
308      *
309      * - `tokenId` must exist.
310      */
311     function getApproved(uint256 tokenId) external view returns (address operator);
312 
313     /**
314      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
315      *
316      * See {setApprovalForAll}
317      */
318     function isApprovedForAll(address owner, address operator) external view returns (bool);
319 
320     // ==============================
321     //        IERC721Metadata
322     // ==============================
323 
324     /**
325      * @dev Returns the token collection name.
326      */
327     function name() external view returns (string memory);
328 
329     /**
330      * @dev Returns the token collection symbol.
331      */
332     function symbol() external view returns (string memory);
333 
334     /**
335      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
336      */
337     function tokenURI(uint256 tokenId) external view returns (string memory);
338 
339     // ==============================
340     //            IERC2309
341     // ==============================
342 
343     /**
344      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
345      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
346      */
347     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
348 }
349 
350 interface ERC721A__IERC721Receiver {
351     function onERC721Received(
352         address operator,
353         address from,
354         uint256 tokenId,
355         bytes calldata data
356     ) external returns (bytes4);
357 }
358 
359 contract ERC721A is IERC721A {
360     // Mask of an entry in packed address data.
361     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
362 
363     // The bit position of `numberMinted` in packed address data.
364     uint256 private constant BITPOS_NUMBER_MINTED = 64;
365 
366     // The bit position of `numberBurned` in packed address data.
367     uint256 private constant BITPOS_NUMBER_BURNED = 128;
368 
369     // The bit position of `aux` in packed address data.
370     uint256 private constant BITPOS_AUX = 192;
371 
372     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
373     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
374 
375     // The bit position of `startTimestamp` in packed ownership.
376     uint256 private constant BITPOS_START_TIMESTAMP = 160;
377 
378     // The bit mask of the `burned` bit in packed ownership.
379     uint256 private constant BITMASK_BURNED = 1 << 224;
380 
381     // The bit position of the `nextInitialized` bit in packed ownership.
382     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
383 
384     // The bit mask of the `nextInitialized` bit in packed ownership.
385     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
386 
387     // The bit position of `extraData` in packed ownership.
388     uint256 private constant BITPOS_EXTRA_DATA = 232;
389 
390     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
391     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
392 
393     // The mask of the lower 160 bits for addresses.
394     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
395 
396     // The maximum `quantity` that can be minted with `_mintERC2309`.
397     // This limit is to prevent overflows on the address data entries.
398     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
399     // is required to cause an overflow, which is unrealistic.
400     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
401 
402     // The tokenId of the next token to be minted.
403     uint256 private _currentIndex;
404 
405     // The number of tokens burned.
406     uint256 private _burnCounter;
407 
408     // Token name
409     string private _name;
410 
411     // Token symbol
412     string private _symbol;
413 
414     // Mapping from token ID to ownership details
415     // An empty struct value does not necessarily mean the token is unowned.
416     // See `_packedOwnershipOf` implementation for details.
417     //
418     // Bits Layout:
419     // - [0..159]   `addr`
420     // - [160..223] `startTimestamp`
421     // - [224]      `burned`
422     // - [225]      `nextInitialized`
423     // - [232..255] `extraData`
424     mapping(uint256 => uint256) private _packedOwnerships;
425 
426     // Mapping owner address to address data.
427     //
428     // Bits Layout:
429     // - [0..63]    `balance`
430     // - [64..127]  `numberMinted`
431     // - [128..191] `numberBurned`
432     // - [192..255] `aux`
433     mapping(address => uint256) private _packedAddressData;
434 
435     // Mapping from token ID to approved address.
436     mapping(uint256 => address) private _tokenApprovals;
437 
438     // Mapping from owner to operator approvals
439     mapping(address => mapping(address => bool)) private _operatorApprovals;
440 
441     constructor(string memory name_, string memory symbol_) {
442         _name = name_;
443         _symbol = symbol_;
444         _currentIndex = _startTokenId();
445     }
446 
447     /**
448      * @dev Returns the starting token ID.
449      * To change the starting token ID, please override this function.
450      */
451     function _startTokenId() internal view virtual returns (uint256) {
452         return 0;
453     }
454 
455     /**
456      * @dev Returns the next token ID to be minted.
457      */
458     function _nextTokenId() internal view returns (uint256) {
459         return _currentIndex;
460     }
461 
462     /**
463      * @dev Returns the total number of tokens in existence.
464      * Burned tokens will reduce the count.
465      * To get the total number of tokens minted, please see `_totalMinted`.
466      */
467     function totalSupply() public view override returns (uint256) {
468         // Counter underflow is impossible as _burnCounter cannot be incremented
469         // more than `_currentIndex - _startTokenId()` times.
470         unchecked {
471             return _currentIndex - _burnCounter - _startTokenId();
472         }
473     }
474 
475     /**
476      * @dev Returns the total amount of tokens minted in the contract.
477      */
478     function _totalMinted() internal view returns (uint256) {
479         // Counter underflow is impossible as _currentIndex does not decrement,
480         // and it is initialized to `_startTokenId()`
481         unchecked {
482             return _currentIndex - _startTokenId();
483         }
484     }
485 
486     /**
487      * @dev Returns the total number of tokens burned.
488      */
489     function _totalBurned() internal view returns (uint256) {
490         return _burnCounter;
491     }
492 
493     /**
494      * @dev See {IERC165-supportsInterface}.
495      */
496     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
497         // The interface IDs are constants representing the first 4 bytes of the XOR of
498         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
499         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
500         return
501             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
502             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
503             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
504     }
505 
506     /**
507      * @dev See {IERC721-balanceOf}.
508      */
509     function balanceOf(address owner) public view override returns (uint256) {
510         if (owner == address(0)) revert BalanceQueryForZeroAddress();
511         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
512     }
513 
514     /**
515      * Returns the number of tokens minted by `owner`.
516      */
517     function _numberMinted(address owner) internal view returns (uint256) {
518         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
519     }
520 
521     /**
522      * Returns the number of tokens burned by or on behalf of `owner`.
523      */
524     function _numberBurned(address owner) internal view returns (uint256) {
525         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
526     }
527 
528     /**
529      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
530      */
531     function _getAux(address owner) internal view returns (uint64) {
532         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
533     }
534 
535     /**
536      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
537      * If there are multiple variables, please pack them into a uint64.
538      */
539     function _setAux(address owner, uint64 aux) internal {
540         uint256 packed = _packedAddressData[owner];
541         uint256 auxCasted;
542         // Cast `aux` with assembly to avoid redundant masking.
543         assembly {
544             auxCasted := aux
545         }
546         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
547         _packedAddressData[owner] = packed;
548     }
549 
550     /**
551      * Returns the packed ownership data of `tokenId`.
552      */
553     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
554         uint256 curr = tokenId;
555 
556         unchecked {
557             if (_startTokenId() <= curr)
558                 if (curr < _currentIndex) {
559                     uint256 packed = _packedOwnerships[curr];
560                     // If not burned.
561                     if (packed & BITMASK_BURNED == 0) {
562                         // Invariant:
563                         // There will always be an ownership that has an address and is not burned
564                         // before an ownership that does not have an address and is not burned.
565                         // Hence, curr will not underflow.
566                         //
567                         // We can directly compare the packed value.
568                         // If the address is zero, packed is zero.
569                         while (packed == 0) {
570                             packed = _packedOwnerships[--curr];
571                         }
572                         return packed;
573                     }
574                 }
575         }
576         revert OwnerQueryForNonexistentToken();
577     }
578 
579     /**
580      * Returns the unpacked `TokenOwnership` struct from `packed`.
581      */
582     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
583         ownership.addr = address(uint160(packed));
584         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
585         ownership.burned = packed & BITMASK_BURNED != 0;
586         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
587     }
588 
589     /**
590      * Returns the unpacked `TokenOwnership` struct at `index`.
591      */
592     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
593         return _unpackedOwnership(_packedOwnerships[index]);
594     }
595 
596     /**
597      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
598      */
599     function _initializeOwnershipAt(uint256 index) internal {
600         if (_packedOwnerships[index] == 0) {
601             _packedOwnerships[index] = _packedOwnershipOf(index);
602         }
603     }
604 
605     /**
606      * Gas spent here starts off proportional to the maximum mint batch size.
607      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
608      */
609     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
610         return _unpackedOwnership(_packedOwnershipOf(tokenId));
611     }
612 
613     /**
614      * @dev Packs ownership data into a single uint256.
615      */
616     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
617         assembly {
618             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
619             owner := and(owner, BITMASK_ADDRESS)
620             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
621             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
622         }
623     }
624 
625     /**
626      * @dev See {IERC721-ownerOf}.
627      */
628     function ownerOf(uint256 tokenId) public view override returns (address) {
629         return address(uint160(_packedOwnershipOf(tokenId)));
630     }
631 
632     /**
633      * @dev See {IERC721Metadata-name}.
634      */
635     function name() public view virtual override returns (string memory) {
636         return _name;
637     }
638 
639     /**
640      * @dev See {IERC721Metadata-symbol}.
641      */
642     function symbol() public view virtual override returns (string memory) {
643         return _symbol;
644     }
645 
646     /**
647      * @dev See {IERC721Metadata-tokenURI}.
648      */
649     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
650         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
651 
652         string memory baseURI = _baseURI();
653         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId), ".json")) : '';
654     }
655 
656     /**
657      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
658      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
659      * by default, it can be overridden in child contracts.
660      */
661     function _baseURI() internal view virtual returns (string memory) {
662         return '';
663     }
664 
665     /**
666      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
667      */
668     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
669         // For branchless setting of the `nextInitialized` flag.
670         assembly {
671             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
672             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
673         }
674     }
675 
676     /**
677      * @dev See {IERC721-approve}.
678      */
679     function approve(address to, uint256 tokenId) public override {
680         address owner = ownerOf(tokenId);
681 
682         if (_msgSenderERC721A() != owner)
683             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
684                 revert ApprovalCallerNotOwnerNorApproved();
685             }
686 
687         _tokenApprovals[tokenId] = to;
688         emit Approval(owner, to, tokenId);
689     }
690 
691     /**
692      * @dev See {IERC721-getApproved}.
693      */
694     function getApproved(uint256 tokenId) public view override returns (address) {
695         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
696 
697         return _tokenApprovals[tokenId];
698     }
699 
700     /**
701      * @dev See {IERC721-setApprovalForAll}.
702      */
703     function setApprovalForAll(address operator, bool approved) public virtual override {
704         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
705 
706         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
707         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
708     }
709 
710     /**
711      * @dev See {IERC721-isApprovedForAll}.
712      */
713     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
714         return _operatorApprovals[owner][operator];
715     }
716 
717     /**
718      * @dev See {IERC721-safeTransferFrom}.
719      */
720     function safeTransferFrom(
721         address from,
722         address to,
723         uint256 tokenId
724     ) public virtual override {
725         safeTransferFrom(from, to, tokenId, '');
726     }
727 
728     /**
729      * @dev See {IERC721-safeTransferFrom}.
730      */
731     function safeTransferFrom(
732         address from,
733         address to,
734         uint256 tokenId,
735         bytes memory _data
736     ) public virtual override {
737         transferFrom(from, to, tokenId);
738         if (to.code.length != 0)
739             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
740                 revert TransferToNonERC721ReceiverImplementer();
741             }
742     }
743 
744     /**
745      * @dev Returns whether `tokenId` exists.
746      *
747      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
748      *
749      * Tokens start existing when they are minted (`_mint`),
750      */
751     function _exists(uint256 tokenId) internal view returns (bool) {
752         return
753             _startTokenId() <= tokenId &&
754             tokenId < _currentIndex && // If within bounds,
755             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
756     }
757 
758     /**
759      * @dev Equivalent to `_safeMint(to, quantity, '')`.
760      */
761     function _safeMint(address to, uint256 quantity) internal {
762         _safeMint(to, quantity, '');
763     }
764 
765     /**
766      * @dev Safely mints `quantity` tokens and transfers them to `to`.
767      *
768      * Requirements:
769      *
770      * - If `to` refers to a smart contract, it must implement
771      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
772      * - `quantity` must be greater than 0.
773      *
774      * See {_mint}.
775      *
776      * Emits a {Transfer} event for each mint.
777      */
778     function _safeMint(
779         address to,
780         uint256 quantity,
781         bytes memory _data
782     ) internal {
783         _mint(to, quantity);
784 
785         unchecked {
786             if (to.code.length != 0) {
787                 uint256 end = _currentIndex;
788                 uint256 index = end - quantity;
789                 do {
790                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
791                         revert TransferToNonERC721ReceiverImplementer();
792                     }
793                 } while (index < end);
794                 // Reentrancy protection.
795                 if (_currentIndex != end) revert();
796             }
797         }
798     }
799 
800     /**
801      * @dev Mints `quantity` tokens and transfers them to `to`.
802      *
803      * Requirements:
804      *
805      * - `to` cannot be the zero address.
806      * - `quantity` must be greater than 0.
807      *
808      * Emits a {Transfer} event for each mint.
809      */
810     function _mint(address to, uint256 quantity) internal {
811         uint256 startTokenId = _currentIndex;
812         if (to == address(0)) revert MintToZeroAddress();
813         if (quantity == 0) revert MintZeroQuantity();
814 
815         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
816 
817         // Overflows are incredibly unrealistic.
818         // `balance` and `numberMinted` have a maximum limit of 2**64.
819         // `tokenId` has a maximum limit of 2**256.
820         unchecked {
821             // Updates:
822             // - `balance += quantity`.
823             // - `numberMinted += quantity`.
824             //
825             // We can directly add to the `balance` and `numberMinted`.
826             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
827 
828             // Updates:
829             // - `address` to the owner.
830             // - `startTimestamp` to the timestamp of minting.
831             // - `burned` to `false`.
832             // - `nextInitialized` to `quantity == 1`.
833             _packedOwnerships[startTokenId] = _packOwnershipData(
834                 to,
835                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
836             );
837 
838             uint256 tokenId = startTokenId;
839             uint256 end = startTokenId + quantity;
840             do {
841                 emit Transfer(address(0), to, tokenId++);
842             } while (tokenId < end);
843 
844             _currentIndex = end;
845         }
846         _afterTokenTransfers(address(0), to, startTokenId, quantity);
847     }
848 
849     /**
850      * @dev Mints `quantity` tokens and transfers them to `to`.
851      *
852      * This function is intended for efficient minting only during contract creation.
853      *
854      * It emits only one {ConsecutiveTransfer} as defined in
855      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
856      * instead of a sequence of {Transfer} event(s).
857      *
858      * Calling this function outside of contract creation WILL make your contract
859      * non-compliant with the ERC721 standard.
860      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
861      * {ConsecutiveTransfer} event is only permissible during contract creation.
862      *
863      * Requirements:
864      *
865      * - `to` cannot be the zero address.
866      * - `quantity` must be greater than 0.
867      *
868      * Emits a {ConsecutiveTransfer} event.
869      */
870     function _mintERC2309(address to, uint256 quantity) internal {
871         uint256 startTokenId = _currentIndex;
872         if (to == address(0)) revert MintToZeroAddress();
873         if (quantity == 0) revert MintZeroQuantity();
874         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
875 
876         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
877 
878         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
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
897             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
898 
899             _currentIndex = startTokenId + quantity;
900         }
901         _afterTokenTransfers(address(0), to, startTokenId, quantity);
902     }
903 
904     /**
905      * @dev Returns the storage slot and value for the approved address of `tokenId`.
906      */
907     function _getApprovedAddress(uint256 tokenId)
908         private
909         view
910         returns (uint256 approvedAddressSlot, address approvedAddress)
911     {
912         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
913         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
914         assembly {
915             // Compute the slot.
916             mstore(0x00, tokenId)
917             mstore(0x20, tokenApprovalsPtr.slot)
918             approvedAddressSlot := keccak256(0x00, 0x40)
919             // Load the slot's value from storage.
920             approvedAddress := sload(approvedAddressSlot)
921         }
922     }
923 
924     /**
925      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
926      */
927     function _isOwnerOrApproved(
928         address approvedAddress,
929         address from,
930         address msgSender
931     ) private pure returns (bool result) {
932         assembly {
933             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
934             from := and(from, BITMASK_ADDRESS)
935             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
936             msgSender := and(msgSender, BITMASK_ADDRESS)
937             // `msgSender == from || msgSender == approvedAddress`.
938             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
939         }
940     }
941 
942     /**
943      * @dev Transfers `tokenId` from `from` to `to`.
944      *
945      * Requirements:
946      *
947      * - `to` cannot be the zero address.
948      * - `tokenId` token must be owned by `from`.
949      *
950      * Emits a {Transfer} event.
951      */
952     function transferFrom(
953         address from,
954         address to,
955         uint256 tokenId
956     ) public virtual override {
957         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
958 
959         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
960 
961         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
962 
963         // The nested ifs save around 20+ gas over a compound boolean condition.
964         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
965             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
966 
967         if (to == address(0)) revert TransferToZeroAddress();
968 
969         _beforeTokenTransfers(from, to, tokenId, 1);
970 
971         // Clear approvals from the previous owner.
972         assembly {
973             if approvedAddress {
974                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
975                 sstore(approvedAddressSlot, 0)
976             }
977         }
978 
979         // Underflow of the sender's balance is impossible because we check for
980         // ownership above and the recipient's balance can't realistically overflow.
981         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
982         unchecked {
983             // We can directly increment and decrement the balances.
984             --_packedAddressData[from]; // Updates: `balance -= 1`.
985             ++_packedAddressData[to]; // Updates: `balance += 1`.
986 
987             // Updates:
988             // - `address` to the next owner.
989             // - `startTimestamp` to the timestamp of transfering.
990             // - `burned` to `false`.
991             // - `nextInitialized` to `true`.
992             _packedOwnerships[tokenId] = _packOwnershipData(
993                 to,
994                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
995             );
996 
997             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
998             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
999                 uint256 nextTokenId = tokenId + 1;
1000                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1001                 if (_packedOwnerships[nextTokenId] == 0) {
1002                     // If the next slot is within bounds.
1003                     if (nextTokenId != _currentIndex) {
1004                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1005                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1006                     }
1007                 }
1008             }
1009         }
1010 
1011         emit Transfer(from, to, tokenId);
1012         _afterTokenTransfers(from, to, tokenId, 1);
1013     }
1014 
1015     /**
1016      * @dev Equivalent to `_burn(tokenId, false)`.
1017      */
1018     function _burn(uint256 tokenId) internal virtual {
1019         _burn(tokenId, false);
1020     }
1021 
1022     /**
1023      * @dev Destroys `tokenId`.
1024      * The approval is cleared when the token is burned.
1025      *
1026      * Requirements:
1027      *
1028      * - `tokenId` must exist.
1029      *
1030      * Emits a {Transfer} event.
1031      */
1032     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1033         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1034 
1035         address from = address(uint160(prevOwnershipPacked));
1036 
1037         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1038 
1039         if (approvalCheck) {
1040             // The nested ifs save around 20+ gas over a compound boolean condition.
1041             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1042                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1043         }
1044 
1045         _beforeTokenTransfers(from, address(0), tokenId, 1);
1046 
1047         // Clear approvals from the previous owner.
1048         assembly {
1049             if approvedAddress {
1050                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1051                 sstore(approvedAddressSlot, 0)
1052             }
1053         }
1054 
1055         // Underflow of the sender's balance is impossible because we check for
1056         // ownership above and the recipient's balance can't realistically overflow.
1057         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1058         unchecked {
1059             // Updates:
1060             // - `balance -= 1`.
1061             // - `numberBurned += 1`.
1062             //
1063             // We can directly decrement the balance, and increment the number burned.
1064             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1065             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1066 
1067             // Updates:
1068             // - `address` to the last owner.
1069             // - `startTimestamp` to the timestamp of burning.
1070             // - `burned` to `true`.
1071             // - `nextInitialized` to `true`.
1072             _packedOwnerships[tokenId] = _packOwnershipData(
1073                 from,
1074                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1075             );
1076 
1077             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1078             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1079                 uint256 nextTokenId = tokenId + 1;
1080                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1081                 if (_packedOwnerships[nextTokenId] == 0) {
1082                     // If the next slot is within bounds.
1083                     if (nextTokenId != _currentIndex) {
1084                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1085                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1086                     }
1087                 }
1088             }
1089         }
1090 
1091         emit Transfer(from, address(0), tokenId);
1092         _afterTokenTransfers(from, address(0), tokenId, 1);
1093 
1094         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1095         unchecked {
1096             _burnCounter++;
1097         }
1098     }
1099 
1100     /**
1101      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1102      *
1103      * @param from address representing the previous owner of the given token ID
1104      * @param to target address that will receive the tokens
1105      * @param tokenId uint256 ID of the token to be transferred
1106      * @param _data bytes optional data to send along with the call
1107      * @return bool whether the call correctly returned the expected magic value
1108      */
1109     function _checkContractOnERC721Received(
1110         address from,
1111         address to,
1112         uint256 tokenId,
1113         bytes memory _data
1114     ) private returns (bool) {
1115         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1116             bytes4 retval
1117         ) {
1118             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1119         } catch (bytes memory reason) {
1120             if (reason.length == 0) {
1121                 revert TransferToNonERC721ReceiverImplementer();
1122             } else {
1123                 assembly {
1124                     revert(add(32, reason), mload(reason))
1125                 }
1126             }
1127         }
1128     }
1129 
1130     /**
1131      * @dev Directly sets the extra data for the ownership data `index`.
1132      */
1133     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1134         uint256 packed = _packedOwnerships[index];
1135         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1136         uint256 extraDataCasted;
1137         // Cast `extraData` with assembly to avoid redundant masking.
1138         assembly {
1139             extraDataCasted := extraData
1140         }
1141         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1142         _packedOwnerships[index] = packed;
1143     }
1144 
1145     /**
1146      * @dev Returns the next extra data for the packed ownership data.
1147      * The returned result is shifted into position.
1148      */
1149     function _nextExtraData(
1150         address from,
1151         address to,
1152         uint256 prevOwnershipPacked
1153     ) private view returns (uint256) {
1154         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1155         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1156     }
1157 
1158     /**
1159      * @dev Called during each token transfer to set the 24bit `extraData` field.
1160      * Intended to be overridden by the cosumer contract.
1161      *
1162      * `previousExtraData` - the value of `extraData` before transfer.
1163      *
1164      * Calling conditions:
1165      *
1166      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1167      * transferred to `to`.
1168      * - When `from` is zero, `tokenId` will be minted for `to`.
1169      * - When `to` is zero, `tokenId` will be burned by `from`.
1170      * - `from` and `to` are never both zero.
1171      */
1172     function _extraData(
1173         address from,
1174         address to,
1175         uint24 previousExtraData
1176     ) internal view virtual returns (uint24) {}
1177 
1178     /**
1179      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1180      * This includes minting.
1181      * And also called before burning one token.
1182      *
1183      * startTokenId - the first token id to be transferred
1184      * quantity - the amount to be transferred
1185      *
1186      * Calling conditions:
1187      *
1188      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1189      * transferred to `to`.
1190      * - When `from` is zero, `tokenId` will be minted for `to`.
1191      * - When `to` is zero, `tokenId` will be burned by `from`.
1192      * - `from` and `to` are never both zero.
1193      */
1194     function _beforeTokenTransfers(
1195         address from,
1196         address to,
1197         uint256 startTokenId,
1198         uint256 quantity
1199     ) internal virtual {}
1200 
1201     /**
1202      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1203      * This includes minting.
1204      * And also called after one token has been burned.
1205      *
1206      * startTokenId - the first token id to be transferred
1207      * quantity - the amount to be transferred
1208      *
1209      * Calling conditions:
1210      *
1211      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1212      * transferred to `to`.
1213      * - When `from` is zero, `tokenId` has been minted for `to`.
1214      * - When `to` is zero, `tokenId` has been burned by `from`.
1215      * - `from` and `to` are never both zero.
1216      */
1217     function _afterTokenTransfers(
1218         address from,
1219         address to,
1220         uint256 startTokenId,
1221         uint256 quantity
1222     ) internal virtual {}
1223 
1224     /**
1225      * @dev Returns the message sender (defaults to `msg.sender`).
1226      *
1227      * If you are writing GSN compatible contracts, you need to override this function.
1228      */
1229     function _msgSenderERC721A() internal view virtual returns (address) {
1230         return msg.sender;
1231     }
1232 
1233     /**
1234      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1235      */
1236     function _toString(uint256 value) internal pure returns (string memory ptr) {
1237         assembly {
1238             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1239             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1240             // We will need 1 32-byte word to store the length,
1241             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1242             ptr := add(mload(0x40), 128)
1243             // Update the free memory pointer to allocate.
1244             mstore(0x40, ptr)
1245 
1246             // Cache the end of the memory to calculate the length later.
1247             let end := ptr
1248 
1249             // We write the string from the rightmost digit to the leftmost digit.
1250             // The following is essentially a do-while loop that also handles the zero case.
1251             // Costs a bit more than early returning for the zero case,
1252             // but cheaper in terms of deployment and overall runtime costs.
1253             for {
1254                 // Initialize and perform the first pass without check.
1255                 let temp := value
1256                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1257                 ptr := sub(ptr, 1)
1258                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1259                 mstore8(ptr, add(48, mod(temp, 10)))
1260                 temp := div(temp, 10)
1261             } temp {
1262                 // Keep dividing `temp` until zero.
1263                 temp := div(temp, 10)
1264             } {
1265                 // Body of the for loop.
1266                 ptr := sub(ptr, 1)
1267                 mstore8(ptr, add(48, mod(temp, 10)))
1268             }
1269 
1270             let length := sub(end, ptr)
1271             // Move the pointer 32 bytes leftwards to make room for the length.
1272             ptr := sub(ptr, 32)
1273             // Store the length.
1274             mstore(ptr, length)
1275         }
1276     }
1277 }
1278 
1279 contract BebeeNfts is Ownable, ERC721A {
1280   string public baseURI = "https://bafybeideys4dhruyjk7b7eebvqdshrbeiydbn3rnvpuxdllgca4dniuqrm.ipfs.nftstorage.link/";
1281 
1282   bool public isMintOpen = false;
1283 
1284   bool public isFreeMintOpen = true;
1285 
1286   uint256 public immutable unitPrice = 0.008 ether;
1287 
1288   uint256 public immutable maxSupply = 3333;
1289 
1290   uint256 public immutable maxWalletSupply = 3;
1291 
1292   uint256 public immutable maxWalletFreeSupply = 1;
1293 
1294   constructor(uint256 _mintCntToOwner) ERC721A('BeBee', 'BEE') {
1295     _mint(msg.sender, _mintCntToOwner);
1296   }
1297 
1298   function _baseURI() internal view override returns (string memory) {
1299     return baseURI;
1300   }
1301 
1302   function _startTokenId() internal pure override returns (uint256) {
1303     return 1;
1304   }
1305 
1306   function startTokenId() external pure returns (uint256) {
1307     return _startTokenId();
1308   }
1309 
1310   function nextTokenId() external view returns (uint256) {
1311     return _nextTokenId();
1312   }
1313 
1314   function numberMinted(address owner) external view returns (uint256) {
1315     return _numberMinted(owner);
1316   }
1317 
1318   function getBalance() external view returns (uint256) {
1319     return address(this).balance;
1320   }
1321 
1322   function mint(uint256 quantity) external payable {
1323     unchecked {
1324       require(isMintOpen, '0');
1325 
1326       uint256 currentSupply = _nextTokenId() - 1;
1327       require((currentSupply + quantity) <= maxSupply, '1');
1328 
1329       uint256 walletSupply = _numberMinted(msg.sender);
1330       require((walletSupply + quantity) <= maxWalletSupply, '2');
1331 
1332       if (isFreeMintOpen == false || currentSupply >= 3332) {
1333         require(msg.value >= unitPrice * quantity, '3');
1334       } else {
1335         uint256 walletFreeSupply = walletSupply > maxWalletFreeSupply
1336             ? maxWalletFreeSupply
1337             : walletSupply;
1338         uint256 freeQuantity = maxWalletFreeSupply > walletFreeSupply
1339             ? maxWalletFreeSupply - walletFreeSupply
1340             : 0;
1341         require(
1342             msg.value >= unitPrice * (quantity > freeQuantity ? quantity - freeQuantity : 0),
1343             '4'
1344         );
1345       }
1346     }
1347 
1348     _mint(msg.sender, quantity);
1349   }
1350 
1351   function setBaseURI(string calldata uri) external onlyOwner {
1352     baseURI = uri;
1353   }
1354 
1355   function setIsMintOpen(bool _isMintOpen) external onlyOwner {
1356     isMintOpen = _isMintOpen;
1357   }
1358 
1359   function setIsFreeMintOpen(bool _isFreeMintOpen) external onlyOwner {
1360     isFreeMintOpen = _isFreeMintOpen;
1361   }
1362 
1363   function withdraw(address to) external onlyOwner {
1364     payable(to).transfer(address(this).balance);
1365   }
1366 
1367   function marketMint(address[] memory marketmintaddress, uint256[] memory mintquantity) public onlyOwner {
1368     for (uint256 i = 0; i < marketmintaddress.length; i++) {
1369       require(totalSupply() + mintquantity[i] <= maxSupply, "Exceed supply");
1370       _safeMint(marketmintaddress[i], mintquantity[i]);
1371     }
1372   }
1373 }