1 // File: contracts/hg.sol
2 
3 /**
4  *Submitted for verification at Etherscan.io on 2022-09-07
5 */
6 
7 // File: contracts/MimicShhansHusband.sol
8 
9 pragma solidity ^0.8.16;
10 
11 abstract contract Context {
12     function _msgSender() internal view virtual returns (address) {
13         return msg.sender;
14     }
15 
16     function _msgData() internal view virtual returns (bytes calldata) {
17         return msg.data;
18     }
19 }
20 
21 abstract contract Ownable is Context {
22     address private _owner;
23 
24     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
25 
26     /**
27      * @dev Initializes the contract setting the deployer as the initial owner.
28      */
29     constructor() {
30         _transferOwnership(_msgSender());
31     }
32 
33     /**
34      * @dev Throws if called by any account other than the owner.
35      */
36     modifier onlyOwner() {
37         _checkOwner();
38         _;
39     }
40 
41     /**
42      * @dev Returns the address of the current owner.
43      */
44     function owner() public view virtual returns (address) {
45         return _owner;
46     }
47 
48     /**
49      * @dev Throws if the sender is not the owner.
50      */
51     function _checkOwner() internal view virtual {
52         require(owner() == _msgSender(), "Ownable: caller is not the owner");
53     }
54 
55     /**
56      * @dev Leaves the contract without owner. It will not be possible to call
57      * `onlyOwner` functions anymore. Can only be called by the current owner.
58      *
59      * NOTE: Renouncing ownership will leave the contract without an owner,
60      * thereby removing any functionality that is only available to the owner.
61      */
62     function renounceOwnership() public virtual onlyOwner {
63         _transferOwnership(address(0));
64     }
65 
66     /**
67      * @dev Transfers ownership of the contract to a new account (`newOwner`).
68      * Can only be called by the current owner.
69      */
70     function transferOwnership(address newOwner) public virtual onlyOwner {
71         require(newOwner != address(0), "Ownable: new owner is the zero address");
72         _transferOwnership(newOwner);
73     }
74 
75     /**
76      * @dev Transfers ownership of the contract to a new account (`newOwner`).
77      * Internal function without access restriction.
78      */
79     function _transferOwnership(address newOwner) internal virtual {
80         address oldOwner = _owner;
81         _owner = newOwner;
82         emit OwnershipTransferred(oldOwner, newOwner);
83     }
84 }
85 
86 interface IERC721A {
87     /**
88      * The caller must own the token or be an approved operator.
89      */
90     error ApprovalCallerNotOwnerNorApproved();
91 
92     /**
93      * The token does not exist.
94      */
95     error ApprovalQueryForNonexistentToken();
96 
97     /**
98      * The caller cannot approve to their own address.
99      */
100     error ApproveToCaller();
101 
102     /**
103      * Cannot query the balance for the zero address.
104      */
105     error BalanceQueryForZeroAddress();
106 
107     /**
108      * Cannot mint to the zero address.
109      */
110     error MintToZeroAddress();
111 
112     /**
113      * The quantity of tokens minted must be more than zero.
114      */
115     error MintZeroQuantity();
116 
117     /**
118      * The token does not exist.
119      */
120     error OwnerQueryForNonexistentToken();
121 
122     /**
123      * The caller must own the token or be an approved operator.
124      */
125     error TransferCallerNotOwnerNorApproved();
126 
127     /**
128      * The token must be owned by `from`.
129      */
130     error TransferFromIncorrectOwner();
131 
132     /**
133      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
134      */
135     error TransferToNonERC721ReceiverImplementer();
136 
137     /**
138      * Cannot transfer to the zero address.
139      */
140     error TransferToZeroAddress();
141 
142     /**
143      * The token does not exist.
144      */
145     error URIQueryForNonexistentToken();
146 
147     /**
148      * The `quantity` minted with ERC2309 exceeds the safety limit.
149      */
150     error MintERC2309QuantityExceedsLimit();
151 
152     /**
153      * The `extraData` cannot be set on an unintialized ownership slot.
154      */
155     error OwnershipNotInitializedForExtraData();
156 
157     struct TokenOwnership {
158         // The address of the owner.
159         address addr;
160         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
161         uint64 startTimestamp;
162         // Whether the token has been burned.
163         bool burned;
164         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
165         uint24 extraData;
166     }
167 
168     /**
169      * @dev Returns the total amount of tokens stored by the contract.
170      *
171      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
172      */
173     function totalSupply() external view returns (uint256);
174 
175     // ==============================
176     //            IERC165
177     // ==============================
178 
179     /**
180      * @dev Returns true if this contract implements the interface defined by
181      * `interfaceId`. See the corresponding
182      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
183      * to learn more about how these ids are created.
184      *
185      * This function call must use less than 30 000 gas.
186      */
187     function supportsInterface(bytes4 interfaceId) external view returns (bool);
188 
189     // ==============================
190     //            IERC721
191     // ==============================
192 
193     /**
194      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
195      */
196     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
197 
198     /**
199      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
200      */
201     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
202 
203     /**
204      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
205      */
206     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
207 
208     /**
209      * @dev Returns the number of tokens in ``owner``'s account.
210      */
211     function balanceOf(address owner) external view returns (uint256 balance);
212 
213     /**
214      * @dev Returns the owner of the `tokenId` token.
215      *
216      * Requirements:
217      *
218      * - `tokenId` must exist.
219      */
220     function ownerOf(uint256 tokenId) external view returns (address owner);
221 
222     /**
223      * @dev Safely transfers `tokenId` token from `from` to `to`.
224      *
225      * Requirements:
226      *
227      * - `from` cannot be the zero address.
228      * - `to` cannot be the zero address.
229      * - `tokenId` token must exist and be owned by `from`.
230      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
231      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
232      *
233      * Emits a {Transfer} event.
234      */
235     function safeTransferFrom(
236         address from,
237         address to,
238         uint256 tokenId,
239         bytes calldata data
240     ) external;
241 
242     /**
243      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
244      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
245      *
246      * Requirements:
247      *
248      * - `from` cannot be the zero address.
249      * - `to` cannot be the zero address.
250      * - `tokenId` token must exist and be owned by `from`.
251      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
252      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
253      *
254      * Emits a {Transfer} event.
255      */
256     function safeTransferFrom(
257         address from,
258         address to,
259         uint256 tokenId
260     ) external;
261 
262     /**
263      * @dev Transfers `tokenId` token from `from` to `to`.
264      *
265      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
266      *
267      * Requirements:
268      *
269      * - `from` cannot be the zero address.
270      * - `to` cannot be the zero address.
271      * - `tokenId` token must be owned by `from`.
272      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
273      *
274      * Emits a {Transfer} event.
275      */
276     function transferFrom(
277         address from,
278         address to,
279         uint256 tokenId
280     ) external;
281 
282     /**
283      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
284      * The approval is cleared when the token is transferred.
285      *
286      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
287      *
288      * Requirements:
289      *
290      * - The caller must own the token or be an approved operator.
291      * - `tokenId` must exist.
292      *
293      * Emits an {Approval} event.
294      */
295     function approve(address to, uint256 tokenId) external;
296 
297     /**
298      * @dev Approve or remove `operator` as an operator for the caller.
299      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
300      *
301      * Requirements:
302      *
303      * - The `operator` cannot be the caller.
304      *
305      * Emits an {ApprovalForAll} event.
306      */
307     function setApprovalForAll(address operator, bool _approved) external;
308 
309     /**
310      * @dev Returns the account approved for `tokenId` token.
311      *
312      * Requirements:
313      *
314      * - `tokenId` must exist.
315      */
316     function getApproved(uint256 tokenId) external view returns (address operator);
317 
318     /**
319      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
320      *
321      * See {setApprovalForAll}
322      */
323     function isApprovedForAll(address owner, address operator) external view returns (bool);
324 
325     // ==============================
326     //        IERC721Metadata
327     // ==============================
328 
329     /**
330      * @dev Returns the token collection name.
331      */
332     function name() external view returns (string memory);
333 
334     /**
335      * @dev Returns the token collection symbol.
336      */
337     function symbol() external view returns (string memory);
338 
339     /**
340      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
341      */
342     function tokenURI(uint256 tokenId) external view returns (string memory);
343 
344     // ==============================
345     //            IERC2309
346     // ==============================
347 
348     /**
349      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
350      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
351      */
352     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
353 }
354 
355 interface ERC721A__IERC721Receiver {
356     function onERC721Received(
357         address operator,
358         address from,
359         uint256 tokenId,
360         bytes calldata data
361     ) external returns (bytes4);
362 }
363 
364 contract ERC721A is IERC721A {
365     // Mask of an entry in packed address data.
366     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
367 
368     // The bit position of `numberMinted` in packed address data.
369     uint256 private constant BITPOS_NUMBER_MINTED = 64;
370 
371     // The bit position of `numberBurned` in packed address data.
372     uint256 private constant BITPOS_NUMBER_BURNED = 128;
373 
374     // The bit position of `aux` in packed address data.
375     uint256 private constant BITPOS_AUX = 192;
376 
377     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
378     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
379 
380     // The bit position of `startTimestamp` in packed ownership.
381     uint256 private constant BITPOS_START_TIMESTAMP = 160;
382 
383     // The bit mask of the `burned` bit in packed ownership.
384     uint256 private constant BITMASK_BURNED = 1 << 224;
385 
386     // The bit position of the `nextInitialized` bit in packed ownership.
387     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
388 
389     // The bit mask of the `nextInitialized` bit in packed ownership.
390     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
391 
392     // The bit position of `extraData` in packed ownership.
393     uint256 private constant BITPOS_EXTRA_DATA = 232;
394 
395     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
396     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
397 
398     // The mask of the lower 160 bits for addresses.
399     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
400 
401     // The maximum `quantity` that can be minted with `_mintERC2309`.
402     // This limit is to prevent overflows on the address data entries.
403     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
404     // is required to cause an overflow, which is unrealistic.
405     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
406 
407     // The tokenId of the next token to be minted.
408     uint256 private _currentIndex;
409 
410     // The number of tokens burned.
411     uint256 private _burnCounter;
412 
413     // Token name
414     string private _name;
415 
416     // Token symbol
417     string private _symbol;
418 
419     // Mapping from token ID to ownership details
420     // An empty struct value does not necessarily mean the token is unowned.
421     // See `_packedOwnershipOf` implementation for details.
422     //
423     // Bits Layout:
424     // - [0..159]   `addr`
425     // - [160..223] `startTimestamp`
426     // - [224]      `burned`
427     // - [225]      `nextInitialized`
428     // - [232..255] `extraData`
429     mapping(uint256 => uint256) private _packedOwnerships;
430 
431     // Mapping owner address to address data.
432     //
433     // Bits Layout:
434     // - [0..63]    `balance`
435     // - [64..127]  `numberMinted`
436     // - [128..191] `numberBurned`
437     // - [192..255] `aux`
438     mapping(address => uint256) private _packedAddressData;
439 
440     // Mapping from token ID to approved address.
441     mapping(uint256 => address) private _tokenApprovals;
442 
443     // Mapping from owner to operator approvals
444     mapping(address => mapping(address => bool)) private _operatorApprovals;
445 
446     constructor(string memory name_, string memory symbol_) {
447         _name = name_;
448         _symbol = symbol_;
449         _currentIndex = _startTokenId();
450     }
451 
452     /**
453      * @dev Returns the starting token ID.
454      * To change the starting token ID, please override this function.
455      */
456     function _startTokenId() internal view virtual returns (uint256) {
457         return 0;
458     }
459 
460     /**
461      * @dev Returns the next token ID to be minted.
462      */
463     function _nextTokenId() internal view returns (uint256) {
464         return _currentIndex;
465     }
466 
467     /**
468      * @dev Returns the total number of tokens in existence.
469      * Burned tokens will reduce the count.
470      * To get the total number of tokens minted, please see `_totalMinted`.
471      */
472     function totalSupply() public view override returns (uint256) {
473         // Counter underflow is impossible as _burnCounter cannot be incremented
474         // more than `_currentIndex - _startTokenId()` times.
475         unchecked {
476             return _currentIndex - _burnCounter - _startTokenId();
477         }
478     }
479 
480     /**
481      * @dev Returns the total amount of tokens minted in the contract.
482      */
483     function _totalMinted() internal view returns (uint256) {
484         // Counter underflow is impossible as _currentIndex does not decrement,
485         // and it is initialized to `_startTokenId()`
486         unchecked {
487             return _currentIndex - _startTokenId();
488         }
489     }
490 
491     /**
492      * @dev Returns the total number of tokens burned.
493      */
494     function _totalBurned() internal view returns (uint256) {
495         return _burnCounter;
496     }
497 
498     /**
499      * @dev See {IERC165-supportsInterface}.
500      */
501     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
502         // The interface IDs are constants representing the first 4 bytes of the XOR of
503         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
504         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
505         return
506             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
507             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
508             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
509     }
510 
511     /**
512      * @dev See {IERC721-balanceOf}.
513      */
514     function balanceOf(address owner) public view override returns (uint256) {
515         if (owner == address(0)) revert BalanceQueryForZeroAddress();
516         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
517     }
518 
519     /**
520      * Returns the number of tokens minted by `owner`.
521      */
522     function _numberMinted(address owner) internal view returns (uint256) {
523         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
524     }
525 
526     /**
527      * Returns the number of tokens burned by or on behalf of `owner`.
528      */
529     function _numberBurned(address owner) internal view returns (uint256) {
530         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
531     }
532 
533     /**
534      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
535      */
536     function _getAux(address owner) internal view returns (uint64) {
537         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
538     }
539 
540     /**
541      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
542      * If there are multiple variables, please pack them into a uint64.
543      */
544     function _setAux(address owner, uint64 aux) internal {
545         uint256 packed = _packedAddressData[owner];
546         uint256 auxCasted;
547         // Cast `aux` with assembly to avoid redundant masking.
548         assembly {
549             auxCasted := aux
550         }
551         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
552         _packedAddressData[owner] = packed;
553     }
554 
555     /**
556      * Returns the packed ownership data of `tokenId`.
557      */
558     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
559         uint256 curr = tokenId;
560 
561         unchecked {
562             if (_startTokenId() <= curr)
563                 if (curr < _currentIndex) {
564                     uint256 packed = _packedOwnerships[curr];
565                     // If not burned.
566                     if (packed & BITMASK_BURNED == 0) {
567                         // Invariant:
568                         // There will always be an ownership that has an address and is not burned
569                         // before an ownership that does not have an address and is not burned.
570                         // Hence, curr will not underflow.
571                         //
572                         // We can directly compare the packed value.
573                         // If the address is zero, packed is zero.
574                         while (packed == 0) {
575                             packed = _packedOwnerships[--curr];
576                         }
577                         return packed;
578                     }
579                 }
580         }
581         revert OwnerQueryForNonexistentToken();
582     }
583 
584     /**
585      * Returns the unpacked `TokenOwnership` struct from `packed`.
586      */
587     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
588         ownership.addr = address(uint160(packed));
589         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
590         ownership.burned = packed & BITMASK_BURNED != 0;
591         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
592     }
593 
594     /**
595      * Returns the unpacked `TokenOwnership` struct at `index`.
596      */
597     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
598         return _unpackedOwnership(_packedOwnerships[index]);
599     }
600 
601     /**
602      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
603      */
604     function _initializeOwnershipAt(uint256 index) internal {
605         if (_packedOwnerships[index] == 0) {
606             _packedOwnerships[index] = _packedOwnershipOf(index);
607         }
608     }
609 
610     /**
611      * Gas spent here starts off proportional to the maximum mint batch size.
612      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
613      */
614     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
615         return _unpackedOwnership(_packedOwnershipOf(tokenId));
616     }
617 
618     /**
619      * @dev Packs ownership data into a single uint256.
620      */
621     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
622         assembly {
623             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
624             owner := and(owner, BITMASK_ADDRESS)
625             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
626             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
627         }
628     }
629 
630     /**
631      * @dev See {IERC721-ownerOf}.
632      */
633     function ownerOf(uint256 tokenId) public view override returns (address) {
634         return address(uint160(_packedOwnershipOf(tokenId)));
635     }
636 
637     /**
638      * @dev See {IERC721Metadata-name}.
639      */
640     function name() public view virtual override returns (string memory) {
641         return _name;
642     }
643 
644     /**
645      * @dev See {IERC721Metadata-symbol}.
646      */
647     function symbol() public view virtual override returns (string memory) {
648         return _symbol;
649     }
650 
651     /**
652      * @dev See {IERC721Metadata-tokenURI}.
653      */
654     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
655         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
656 
657         string memory baseURI = _baseURI();
658         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId), ".json")) : '';
659     }
660 
661     /**
662      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
663      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
664      * by default, it can be overridden in child contracts.
665      */
666     function _baseURI() internal view virtual returns (string memory) {
667         return '';
668     }
669 
670     /**
671      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
672      */
673     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
674         // For branchless setting of the `nextInitialized` flag.
675         assembly {
676             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
677             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
678         }
679     }
680 
681     /**
682      * @dev See {IERC721-approve}.
683      */
684     function approve(address to, uint256 tokenId) public override {
685         address owner = ownerOf(tokenId);
686 
687         if (_msgSenderERC721A() != owner)
688             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
689                 revert ApprovalCallerNotOwnerNorApproved();
690             }
691 
692         _tokenApprovals[tokenId] = to;
693         emit Approval(owner, to, tokenId);
694     }
695 
696     /**
697      * @dev See {IERC721-getApproved}.
698      */
699     function getApproved(uint256 tokenId) public view override returns (address) {
700         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
701 
702         return _tokenApprovals[tokenId];
703     }
704 
705     /**
706      * @dev See {IERC721-setApprovalForAll}.
707      */
708     function setApprovalForAll(address operator, bool approved) public virtual override {
709         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
710 
711         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
712         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
713     }
714 
715     /**
716      * @dev See {IERC721-isApprovedForAll}.
717      */
718     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
719         return _operatorApprovals[owner][operator];
720     }
721 
722     /**
723      * @dev See {IERC721-safeTransferFrom}.
724      */
725     function safeTransferFrom(
726         address from,
727         address to,
728         uint256 tokenId
729     ) public virtual override {
730         safeTransferFrom(from, to, tokenId, '');
731     }
732 
733     /**
734      * @dev See {IERC721-safeTransferFrom}.
735      */
736     function safeTransferFrom(
737         address from,
738         address to,
739         uint256 tokenId,
740         bytes memory _data
741     ) public virtual override {
742         transferFrom(from, to, tokenId);
743         if (to.code.length != 0)
744             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
745                 revert TransferToNonERC721ReceiverImplementer();
746             }
747     }
748 
749     /**
750      * @dev Returns whether `tokenId` exists.
751      *
752      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
753      *
754      * Tokens start existing when they are minted (`_mint`),
755      */
756     function _exists(uint256 tokenId) internal view returns (bool) {
757         return
758             _startTokenId() <= tokenId &&
759             tokenId < _currentIndex && // If within bounds,
760             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
761     }
762 
763     /**
764      * @dev Equivalent to `_safeMint(to, quantity, '')`.
765      */
766     function _safeMint(address to, uint256 quantity) internal {
767         _safeMint(to, quantity, '');
768     }
769 
770     /**
771      * @dev Safely mints `quantity` tokens and transfers them to `to`.
772      *
773      * Requirements:
774      *
775      * - If `to` refers to a smart contract, it must implement
776      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
777      * - `quantity` must be greater than 0.
778      *
779      * See {_mint}.
780      *
781      * Emits a {Transfer} event for each mint.
782      */
783     function _safeMint(
784         address to,
785         uint256 quantity,
786         bytes memory _data
787     ) internal {
788         _mint(to, quantity);
789 
790         unchecked {
791             if (to.code.length != 0) {
792                 uint256 end = _currentIndex;
793                 uint256 index = end - quantity;
794                 do {
795                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
796                         revert TransferToNonERC721ReceiverImplementer();
797                     }
798                 } while (index < end);
799                 // Reentrancy protection.
800                 if (_currentIndex != end) revert();
801             }
802         }
803     }
804 
805     /**
806      * @dev Mints `quantity` tokens and transfers them to `to`.
807      *
808      * Requirements:
809      *
810      * - `to` cannot be the zero address.
811      * - `quantity` must be greater than 0.
812      *
813      * Emits a {Transfer} event for each mint.
814      */
815     function _mint(address to, uint256 quantity) internal {
816         uint256 startTokenId = _currentIndex;
817         if (to == address(0)) revert MintToZeroAddress();
818         if (quantity == 0) revert MintZeroQuantity();
819 
820         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
821 
822         // Overflows are incredibly unrealistic.
823         // `balance` and `numberMinted` have a maximum limit of 2**64.
824         // `tokenId` has a maximum limit of 2**256.
825         unchecked {
826             // Updates:
827             // - `balance += quantity`.
828             // - `numberMinted += quantity`.
829             //
830             // We can directly add to the `balance` and `numberMinted`.
831             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
832 
833             // Updates:
834             // - `address` to the owner.
835             // - `startTimestamp` to the timestamp of minting.
836             // - `burned` to `false`.
837             // - `nextInitialized` to `quantity == 1`.
838             _packedOwnerships[startTokenId] = _packOwnershipData(
839                 to,
840                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
841             );
842 
843             uint256 tokenId = startTokenId;
844             uint256 end = startTokenId + quantity;
845             do {
846                 emit Transfer(address(0), to, tokenId++);
847             } while (tokenId < end);
848 
849             _currentIndex = end;
850         }
851         _afterTokenTransfers(address(0), to, startTokenId, quantity);
852     }
853 
854     /**
855      * @dev Mints `quantity` tokens and transfers them to `to`.
856      *
857      * This function is intended for efficient minting only during contract creation.
858      *
859      * It emits only one {ConsecutiveTransfer} as defined in
860      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
861      * instead of a sequence of {Transfer} event(s).
862      *
863      * Calling this function outside of contract creation WILL make your contract
864      * non-compliant with the ERC721 standard.
865      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
866      * {ConsecutiveTransfer} event is only permissible during contract creation.
867      *
868      * Requirements:
869      *
870      * - `to` cannot be the zero address.
871      * - `quantity` must be greater than 0.
872      *
873      * Emits a {ConsecutiveTransfer} event.
874      */
875     function _mintERC2309(address to, uint256 quantity) internal {
876         uint256 startTokenId = _currentIndex;
877         if (to == address(0)) revert MintToZeroAddress();
878         if (quantity == 0) revert MintZeroQuantity();
879         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
880 
881         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
882 
883         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
884         unchecked {
885             // Updates:
886             // - `balance += quantity`.
887             // - `numberMinted += quantity`.
888             //
889             // We can directly add to the `balance` and `numberMinted`.
890             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
891 
892             // Updates:
893             // - `address` to the owner.
894             // - `startTimestamp` to the timestamp of minting.
895             // - `burned` to `false`.
896             // - `nextInitialized` to `quantity == 1`.
897             _packedOwnerships[startTokenId] = _packOwnershipData(
898                 to,
899                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
900             );
901 
902             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
903 
904             _currentIndex = startTokenId + quantity;
905         }
906         _afterTokenTransfers(address(0), to, startTokenId, quantity);
907     }
908 
909     /**
910      * @dev Returns the storage slot and value for the approved address of `tokenId`.
911      */
912     function _getApprovedAddress(uint256 tokenId)
913         private
914         view
915         returns (uint256 approvedAddressSlot, address approvedAddress)
916     {
917         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
918         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
919         assembly {
920             // Compute the slot.
921             mstore(0x00, tokenId)
922             mstore(0x20, tokenApprovalsPtr.slot)
923             approvedAddressSlot := keccak256(0x00, 0x40)
924             // Load the slot's value from storage.
925             approvedAddress := sload(approvedAddressSlot)
926         }
927     }
928 
929     /**
930      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
931      */
932     function _isOwnerOrApproved(
933         address approvedAddress,
934         address from,
935         address msgSender
936     ) private pure returns (bool result) {
937         assembly {
938             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
939             from := and(from, BITMASK_ADDRESS)
940             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
941             msgSender := and(msgSender, BITMASK_ADDRESS)
942             // `msgSender == from || msgSender == approvedAddress`.
943             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
944         }
945     }
946 
947     /**
948      * @dev Transfers `tokenId` from `from` to `to`.
949      *
950      * Requirements:
951      *
952      * - `to` cannot be the zero address.
953      * - `tokenId` token must be owned by `from`.
954      *
955      * Emits a {Transfer} event.
956      */
957     function transferFrom(
958         address from,
959         address to,
960         uint256 tokenId
961     ) public virtual override {
962         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
963 
964         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
965 
966         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
967 
968         // The nested ifs save around 20+ gas over a compound boolean condition.
969         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
970             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
971 
972         if (to == address(0)) revert TransferToZeroAddress();
973 
974         _beforeTokenTransfers(from, to, tokenId, 1);
975 
976         // Clear approvals from the previous owner.
977         assembly {
978             if approvedAddress {
979                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
980                 sstore(approvedAddressSlot, 0)
981             }
982         }
983 
984         // Underflow of the sender's balance is impossible because we check for
985         // ownership above and the recipient's balance can't realistically overflow.
986         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
987         unchecked {
988             // We can directly increment and decrement the balances.
989             --_packedAddressData[from]; // Updates: `balance -= 1`.
990             ++_packedAddressData[to]; // Updates: `balance += 1`.
991 
992             // Updates:
993             // - `address` to the next owner.
994             // - `startTimestamp` to the timestamp of transfering.
995             // - `burned` to `false`.
996             // - `nextInitialized` to `true`.
997             _packedOwnerships[tokenId] = _packOwnershipData(
998                 to,
999                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1000             );
1001 
1002             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1003             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1004                 uint256 nextTokenId = tokenId + 1;
1005                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1006                 if (_packedOwnerships[nextTokenId] == 0) {
1007                     // If the next slot is within bounds.
1008                     if (nextTokenId != _currentIndex) {
1009                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1010                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1011                     }
1012                 }
1013             }
1014         }
1015 
1016         emit Transfer(from, to, tokenId);
1017         _afterTokenTransfers(from, to, tokenId, 1);
1018     }
1019 
1020     /**
1021      * @dev Equivalent to `_burn(tokenId, false)`.
1022      */
1023     function _burn(uint256 tokenId) internal virtual {
1024         _burn(tokenId, false);
1025     }
1026 
1027     /**
1028      * @dev Destroys `tokenId`.
1029      * The approval is cleared when the token is burned.
1030      *
1031      * Requirements:
1032      *
1033      * - `tokenId` must exist.
1034      *
1035      * Emits a {Transfer} event.
1036      */
1037     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1038         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1039 
1040         address from = address(uint160(prevOwnershipPacked));
1041 
1042         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1043 
1044         if (approvalCheck) {
1045             // The nested ifs save around 20+ gas over a compound boolean condition.
1046             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1047                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1048         }
1049 
1050         _beforeTokenTransfers(from, address(0), tokenId, 1);
1051 
1052         // Clear approvals from the previous owner.
1053         assembly {
1054             if approvedAddress {
1055                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1056                 sstore(approvedAddressSlot, 0)
1057             }
1058         }
1059 
1060         // Underflow of the sender's balance is impossible because we check for
1061         // ownership above and the recipient's balance can't realistically overflow.
1062         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1063         unchecked {
1064             // Updates:
1065             // - `balance -= 1`.
1066             // - `numberBurned += 1`.
1067             //
1068             // We can directly decrement the balance, and increment the number burned.
1069             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1070             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1071 
1072             // Updates:
1073             // - `address` to the last owner.
1074             // - `startTimestamp` to the timestamp of burning.
1075             // - `burned` to `true`.
1076             // - `nextInitialized` to `true`.
1077             _packedOwnerships[tokenId] = _packOwnershipData(
1078                 from,
1079                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1080             );
1081 
1082             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1083             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1084                 uint256 nextTokenId = tokenId + 1;
1085                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1086                 if (_packedOwnerships[nextTokenId] == 0) {
1087                     // If the next slot is within bounds.
1088                     if (nextTokenId != _currentIndex) {
1089                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1090                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1091                     }
1092                 }
1093             }
1094         }
1095 
1096         emit Transfer(from, address(0), tokenId);
1097         _afterTokenTransfers(from, address(0), tokenId, 1);
1098 
1099         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1100         unchecked {
1101             _burnCounter++;
1102         }
1103     }
1104 
1105     /**
1106      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1107      *
1108      * @param from address representing the previous owner of the given token ID
1109      * @param to target address that will receive the tokens
1110      * @param tokenId uint256 ID of the token to be transferred
1111      * @param _data bytes optional data to send along with the call
1112      * @return bool whether the call correctly returned the expected magic value
1113      */
1114     function _checkContractOnERC721Received(
1115         address from,
1116         address to,
1117         uint256 tokenId,
1118         bytes memory _data
1119     ) private returns (bool) {
1120         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1121             bytes4 retval
1122         ) {
1123             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1124         } catch (bytes memory reason) {
1125             if (reason.length == 0) {
1126                 revert TransferToNonERC721ReceiverImplementer();
1127             } else {
1128                 assembly {
1129                     revert(add(32, reason), mload(reason))
1130                 }
1131             }
1132         }
1133     }
1134 
1135     /**
1136      * @dev Directly sets the extra data for the ownership data `index`.
1137      */
1138     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1139         uint256 packed = _packedOwnerships[index];
1140         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1141         uint256 extraDataCasted;
1142         // Cast `extraData` with assembly to avoid redundant masking.
1143         assembly {
1144             extraDataCasted := extraData
1145         }
1146         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1147         _packedOwnerships[index] = packed;
1148     }
1149 
1150     /**
1151      * @dev Returns the next extra data for the packed ownership data.
1152      * The returned result is shifted into position.
1153      */
1154     function _nextExtraData(
1155         address from,
1156         address to,
1157         uint256 prevOwnershipPacked
1158     ) private view returns (uint256) {
1159         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1160         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1161     }
1162 
1163     /**
1164      * @dev Called during each token transfer to set the 24bit `extraData` field.
1165      * Intended to be overridden by the cosumer contract.
1166      *
1167      * `previousExtraData` - the value of `extraData` before transfer.
1168      *
1169      * Calling conditions:
1170      *
1171      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1172      * transferred to `to`.
1173      * - When `from` is zero, `tokenId` will be minted for `to`.
1174      * - When `to` is zero, `tokenId` will be burned by `from`.
1175      * - `from` and `to` are never both zero.
1176      */
1177     function _extraData(
1178         address from,
1179         address to,
1180         uint24 previousExtraData
1181     ) internal view virtual returns (uint24) {}
1182 
1183     /**
1184      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1185      * This includes minting.
1186      * And also called before burning one token.
1187      *
1188      * startTokenId - the first token id to be transferred
1189      * quantity - the amount to be transferred
1190      *
1191      * Calling conditions:
1192      *
1193      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1194      * transferred to `to`.
1195      * - When `from` is zero, `tokenId` will be minted for `to`.
1196      * - When `to` is zero, `tokenId` will be burned by `from`.
1197      * - `from` and `to` are never both zero.
1198      */
1199     function _beforeTokenTransfers(
1200         address from,
1201         address to,
1202         uint256 startTokenId,
1203         uint256 quantity
1204     ) internal virtual {}
1205 
1206     /**
1207      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1208      * This includes minting.
1209      * And also called after one token has been burned.
1210      *
1211      * startTokenId - the first token id to be transferred
1212      * quantity - the amount to be transferred
1213      *
1214      * Calling conditions:
1215      *
1216      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1217      * transferred to `to`.
1218      * - When `from` is zero, `tokenId` has been minted for `to`.
1219      * - When `to` is zero, `tokenId` has been burned by `from`.
1220      * - `from` and `to` are never both zero.
1221      */
1222     function _afterTokenTransfers(
1223         address from,
1224         address to,
1225         uint256 startTokenId,
1226         uint256 quantity
1227     ) internal virtual {}
1228 
1229     /**
1230      * @dev Returns the message sender (defaults to `msg.sender`).
1231      *
1232      * If you are writing GSN compatible contracts, you need to override this function.
1233      */
1234     function _msgSenderERC721A() internal view virtual returns (address) {
1235         return msg.sender;
1236     }
1237 
1238     /**
1239      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1240      */
1241     function _toString(uint256 value) internal pure returns (string memory ptr) {
1242         assembly {
1243             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1244             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1245             // We will need 1 32-byte word to store the length,
1246             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1247             ptr := add(mload(0x40), 128)
1248             // Update the free memory pointer to allocate.
1249             mstore(0x40, ptr)
1250 
1251             // Cache the end of the memory to calculate the length later.
1252             let end := ptr
1253 
1254             // We write the string from the rightmost digit to the leftmost digit.
1255             // The following is essentially a do-while loop that also handles the zero case.
1256             // Costs a bit more than early returning for the zero case,
1257             // but cheaper in terms of deployment and overall runtime costs.
1258             for {
1259                 // Initialize and perform the first pass without check.
1260                 let temp := value
1261                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1262                 ptr := sub(ptr, 1)
1263                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1264                 mstore8(ptr, add(48, mod(temp, 10)))
1265                 temp := div(temp, 10)
1266             } temp {
1267                 // Keep dividing `temp` until zero.
1268                 temp := div(temp, 10)
1269             } {
1270                 // Body of the for loop.
1271                 ptr := sub(ptr, 1)
1272                 mstore8(ptr, add(48, mod(temp, 10)))
1273             }
1274 
1275             let length := sub(end, ptr)
1276             // Move the pointer 32 bytes leftwards to make room for the length.
1277             ptr := sub(ptr, 32)
1278             // Store the length.
1279             mstore(ptr, length)
1280         }
1281     }
1282 }
1283 
1284 contract Hideinthegarbage is Ownable, ERC721A {
1285   string public baseURI = "https://nftstorage.link/ipfs/bafybeia7jx37o27oigixmanvzwdhjs4qlm4a46pz3wmdra7wdadkop2gqy/";
1286 
1287   bool public isMintOpen = false;
1288 
1289   bool public isFreeMintOpen = true;
1290 
1291   uint256 public immutable unitPrice = 0.003 ether;
1292 
1293   uint256 public immutable maxSupply = 5555;
1294 
1295   uint256 public immutable maxWalletSupply = 20;
1296 
1297   uint256 public immutable maxWalletFreeSupply = 4;
1298 
1299   constructor(uint256 _mintCntToOwner) ERC721A('Hide in the garbage', 'HTG') {
1300     _mint(msg.sender, _mintCntToOwner);
1301   }
1302 
1303   function _baseURI() internal view override returns (string memory) {
1304     return baseURI;
1305   }
1306 
1307   function _startTokenId() internal pure override returns (uint256) {
1308     return 1;
1309   }
1310 
1311   function startTokenId() external pure returns (uint256) {
1312     return _startTokenId();
1313   }
1314 
1315   function nextTokenId() external view returns (uint256) {
1316     return _nextTokenId();
1317   }
1318 
1319   function numberMinted(address owner) external view returns (uint256) {
1320     return _numberMinted(owner);
1321   }
1322 
1323   function getBalance() external view returns (uint256) {
1324     return address(this).balance;
1325   }
1326 
1327   function mint(uint256 quantity) external payable {
1328     unchecked {
1329       require(isMintOpen, '0');
1330 
1331       uint256 currentSupply = _nextTokenId() - 1;
1332       require((currentSupply + quantity) <= maxSupply, '1');
1333 
1334       uint256 walletSupply = _numberMinted(msg.sender);
1335       require((walletSupply + quantity) <= maxWalletSupply, '2');
1336 
1337       if (isFreeMintOpen == false || currentSupply >= 2000) {
1338         require(msg.value >= unitPrice * quantity, '3');
1339       } else {
1340         uint256 walletFreeSupply = walletSupply > maxWalletFreeSupply
1341             ? maxWalletFreeSupply
1342             : walletSupply;
1343         uint256 freeQuantity = maxWalletFreeSupply > walletFreeSupply
1344             ? maxWalletFreeSupply - walletFreeSupply
1345             : 0;
1346         require(
1347             msg.value >= unitPrice * (quantity > freeQuantity ? quantity - freeQuantity : 0),
1348             '4'
1349         );
1350       }
1351     }
1352 
1353     _mint(msg.sender, quantity);
1354   }
1355 
1356   function setBaseURI(string calldata uri) external onlyOwner {
1357     baseURI = uri;
1358   }
1359 
1360   function setIsMintOpen(bool _isMintOpen) external onlyOwner {
1361     isMintOpen = _isMintOpen;
1362   }
1363 
1364   function setIsFreeMintOpen(bool _isFreeMintOpen) external onlyOwner {
1365     isFreeMintOpen = _isFreeMintOpen;
1366   }
1367 
1368   function withdraw(address to) external onlyOwner {
1369     payable(to).transfer(address(this).balance);
1370   }
1371 
1372   function marketMint(address[] memory marketmintaddress, uint256[] memory mintquantity) public onlyOwner {
1373     for (uint256 i = 0; i < marketmintaddress.length; i++) {
1374       require(totalSupply() + mintquantity[i] <= maxSupply, "Exceed supply");
1375       _safeMint(marketmintaddress[i], mintquantity[i]);
1376     }
1377   }
1378 }