1 // SPDX-License-Identifier: MIT
2 // File: erc721a/contracts/IERC721A.sol
3 
4 /** Template created by arczi.eth - I do not take responsibility for 
5  any malfunctions in the script operation and I also declare that I have no influence or 
6  connection with any frauds for which my template was used.**/
7 
8 // ERC721A Contracts v4.1.0
9 
10 pragma solidity ^0.8.4;
11 
12 /**
13  * @dev Interface of an ERC721A compliant contract.
14  */
15 interface IERC721A {
16     /**
17      * The caller must own the token or be an approved operator.
18      */
19     error ApprovalCallerNotOwnerNorApproved();
20 
21     /**
22      * The token does not exist.
23      */
24     error ApprovalQueryForNonexistentToken();
25 
26     /**
27      * The caller cannot approve to their own address.
28      */
29     error ApproveToCaller();
30 
31     /**
32      * Cannot query the balance for the zero address.
33      */
34     error BalanceQueryForZeroAddress();
35 
36     /**
37      * Cannot mint to the zero address.
38      */
39     error MintToZeroAddress();
40 
41     /**
42      * The quantity of tokens minted must be more than zero.
43      */
44     error MintZeroQuantity();
45 
46     /**
47      * The token does not exist.
48      */
49     error OwnerQueryForNonexistentToken();
50 
51     /**
52      * The caller must own the token or be an approved operator.
53      */
54     error TransferCallerNotOwnerNorApproved();
55 
56     /**
57      * The token must be owned by `from`.
58      */
59     error TransferFromIncorrectOwner();
60 
61     /**
62      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
63      */
64     error TransferToNonERC721ReceiverImplementer();
65 
66     /**
67      * Cannot transfer to the zero address.
68      */
69     error TransferToZeroAddress();
70 
71     /**
72      * The token does not exist.
73      */
74     error URIQueryForNonexistentToken();
75 
76     /**
77      * The `quantity` minted with ERC2309 exceeds the safety limit.
78      */
79     error MintERC2309QuantityExceedsLimit();
80 
81     /**
82      * The `extraData` cannot be set on an unintialized ownership slot.
83      */
84     error OwnershipNotInitializedForExtraData();
85 
86     struct TokenOwnership {
87         // The address of the owner.
88         address addr;
89         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
90         uint64 startTimestamp;
91         // Whether the token has been burned.
92         bool burned;
93         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
94         uint24 extraData;
95     }
96 
97     /**
98      * @dev Returns the total amount of tokens stored by the contract.
99      *
100      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
101      */
102     function totalSupply() external view returns (uint256);
103 
104     // ==============================
105     //            IERC165
106     // ==============================
107 
108     /**
109      * @dev Returns true if this contract implements the interface defined by
110      * `interfaceId`. See the corresponding
111      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
112      * to learn more about how these ids are created.
113      *
114      * This function call must use less than 30 000 gas.
115      */
116     function supportsInterface(bytes4 interfaceId) external view returns (bool);
117 
118     // ==============================
119     //            IERC721
120     // ==============================
121 
122     /**
123      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
124      */
125     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
126 
127     /**
128      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
129      */
130     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
131 
132     /**
133      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
134      */
135     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
136 
137     /**
138      * @dev Returns the number of tokens in ``owner``'s account.
139      */
140     function balanceOf(address owner) external view returns (uint256 balance);
141 
142     /**
143      * @dev Returns the owner of the `tokenId` token.
144      *
145      * Requirements:
146      *
147      * - `tokenId` must exist.
148      */
149     function ownerOf(uint256 tokenId) external view returns (address owner);
150 
151     /**
152      * @dev Safely transfers `tokenId` token from `from` to `to`.
153      *
154      * Requirements:
155      *
156      * - `from` cannot be the zero address.
157      * - `to` cannot be the zero address.
158      * - `tokenId` token must exist and be owned by `from`.
159      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
160      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
161      *
162      * Emits a {Transfer} event.
163      */
164     function safeTransferFrom(
165         address from,
166         address to,
167         uint256 tokenId,
168         bytes calldata data
169     ) external;
170 
171     /**
172      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
173      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
174      *
175      * Requirements:
176      *
177      * - `from` cannot be the zero address.
178      * - `to` cannot be the zero address.
179      * - `tokenId` token must exist and be owned by `from`.
180      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
181      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
182      *
183      * Emits a {Transfer} event.
184      */
185     function safeTransferFrom(
186         address from,
187         address to,
188         uint256 tokenId
189     ) external;
190 
191     /**
192      * @dev Transfers `tokenId` token from `from` to `to`.
193      *
194      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
195      *
196      * Requirements:
197      *
198      * - `from` cannot be the zero address.
199      * - `to` cannot be the zero address.
200      * - `tokenId` token must be owned by `from`.
201      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
202      *
203      * Emits a {Transfer} event.
204      */
205     function transferFrom(
206         address from,
207         address to,
208         uint256 tokenId
209     ) external;
210 
211     /**
212      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
213      * The approval is cleared when the token is transferred.
214      *
215      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
216      *
217      * Requirements:
218      *
219      * - The caller must own the token or be an approved operator.
220      * - `tokenId` must exist.
221      *
222      * Emits an {Approval} event.
223      */
224     function approve(address to, uint256 tokenId) external;
225 
226     /**
227      * @dev Approve or remove `operator` as an operator for the caller.
228      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
229      *
230      * Requirements:
231      *
232      * - The `operator` cannot be the caller.
233      *
234      * Emits an {ApprovalForAll} event.
235      */
236     function setApprovalForAll(address operator, bool _approved) external;
237 
238     /**
239      * @dev Returns the account approved for `tokenId` token.
240      *
241      * Requirements:
242      *
243      * - `tokenId` must exist.
244      */
245     function getApproved(uint256 tokenId) external view returns (address operator);
246 
247     /**
248      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
249      *
250      * See {setApprovalForAll}
251      */
252     function isApprovedForAll(address owner, address operator) external view returns (bool);
253 
254     // ==============================
255     //        IERC721Metadata
256     // ==============================
257 
258     /**
259      * @dev Returns the token collection name.
260      */
261     function name() external view returns (string memory);
262 
263     /**
264      * @dev Returns the token collection symbol.
265      */
266     function symbol() external view returns (string memory);
267 
268     /**
269      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
270      */
271     function tokenURI(uint256 tokenId) external view returns (string memory);
272 
273     // ==============================
274     //            IERC2309
275     // ==============================
276 
277     /**
278      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
279      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
280      */
281     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
282 }
283 
284 // File: erc721a/contracts/ERC721A.sol
285 
286 
287 // ERC721A Contracts v4.1.0
288 // Creator: Chiru Labs
289 
290 pragma solidity ^0.8.4;
291 
292 
293 /**
294  * @dev ERC721 token receiver interface.
295  */
296 interface ERC721A__IERC721Receiver {
297     function onERC721Received(
298         address operator,
299         address from,
300         uint256 tokenId,
301         bytes calldata data
302     ) external returns (bytes4);
303 }
304 
305 /**
306  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
307  * including the Metadata extension. Built to optimize for lower gas during batch mints.
308  *
309  * Assumes serials are sequentially minted starting at `_startTokenId()`
310  * (defaults to 0, e.g. 0, 1, 2, 3..).
311  *
312  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
313  *
314  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
315  */
316 contract ERC721A is IERC721A {
317     // Mask of an entry in packed address data.
318     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
319 
320     // The bit position of `numberMinted` in packed address data.
321     uint256 private constant BITPOS_NUMBER_MINTED = 64;
322 
323     // The bit position of `numberBurned` in packed address data.
324     uint256 private constant BITPOS_NUMBER_BURNED = 128;
325 
326     // The bit position of `aux` in packed address data.
327     uint256 private constant BITPOS_AUX = 192;
328 
329     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
330     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
331 
332     // The bit position of `startTimestamp` in packed ownership.
333     uint256 private constant BITPOS_START_TIMESTAMP = 160;
334 
335     // The bit mask of the `burned` bit in packed ownership.
336     uint256 private constant BITMASK_BURNED = 1 << 224;
337 
338     // The bit position of the `nextInitialized` bit in packed ownership.
339     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
340 
341     // The bit mask of the `nextInitialized` bit in packed ownership.
342     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
343 
344     // The bit position of `extraData` in packed ownership.
345     uint256 private constant BITPOS_EXTRA_DATA = 232;
346 
347     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
348     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
349 
350     // The mask of the lower 160 bits for addresses.
351     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
352 
353     // The maximum `quantity` that can be minted with `_mintERC2309`.
354     // This limit is to prevent overflows on the address data entries.
355     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
356     // is required to cause an overflow, which is unrealistic.
357     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
358 
359     // The tokenId of the next token to be minted.
360     uint256 private _currentIndex;
361 
362     // The number of tokens burned.
363     uint256 private _burnCounter;
364 
365     // Token name
366     string private _name;
367 
368     // Token symbol
369     string private _symbol;
370 
371     // Mapping from token ID to ownership details
372     // An empty struct value does not necessarily mean the token is unowned.
373     // See `_packedOwnershipOf` implementation for details.
374     //
375     // Bits Layout:
376     // - [0..159]   `addr`
377     // - [160..223] `startTimestamp`
378     // - [224]      `burned`
379     // - [225]      `nextInitialized`
380     // - [232..255] `extraData`
381     mapping(uint256 => uint256) private _packedOwnerships;
382 
383     // Mapping owner address to address data.
384     //
385     // Bits Layout:
386     // - [0..63]    `balance`
387     // - [64..127]  `numberMinted`
388     // - [128..191] `numberBurned`
389     // - [192..255] `aux`
390     mapping(address => uint256) private _packedAddressData;
391 
392     // Mapping from token ID to approved address.
393     mapping(uint256 => address) private _tokenApprovals;
394 
395     // Mapping from owner to operator approvals
396     mapping(address => mapping(address => bool)) private _operatorApprovals;
397 
398     constructor(string memory name_, string memory symbol_) {
399         _name = name_;
400         _symbol = symbol_;
401         _currentIndex = _startTokenId();
402     }
403 
404     /**
405      * @dev Returns the starting token ID.
406      * To change the starting token ID, please override this function.
407      */
408     function _startTokenId() internal view virtual returns (uint256) {
409         return 0;
410     }
411 
412     /**
413      * @dev Returns the next token ID to be minted.
414      */
415     function _nextTokenId() internal view returns (uint256) {
416         return _currentIndex;
417     }
418 
419     /**
420      * @dev Returns the total number of tokens in existence.
421      * Burned tokens will reduce the count.
422      * To get the total number of tokens minted, please see `_totalMinted`.
423      */
424     function totalSupply() public view override returns (uint256) {
425         // Counter underflow is impossible as _burnCounter cannot be incremented
426         // more than `_currentIndex - _startTokenId()` times.
427         unchecked {
428             return _currentIndex - _burnCounter - _startTokenId();
429         }
430     }
431 
432     /**
433      * @dev Returns the total amount of tokens minted in the contract.
434      */
435     function _totalMinted() internal view returns (uint256) {
436         // Counter underflow is impossible as _currentIndex does not decrement,
437         // and it is initialized to `_startTokenId()`
438         unchecked {
439             return _currentIndex - _startTokenId();
440         }
441     }
442 
443     /**
444      * @dev Returns the total number of tokens burned.
445      */
446     function _totalBurned() internal view returns (uint256) {
447         return _burnCounter;
448     }
449 
450     /**
451      * @dev See {IERC165-supportsInterface}.
452      */
453     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
454         // The interface IDs are constants representing the first 4 bytes of the XOR of
455         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
456         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
457         return
458             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
459             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
460             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
461     }
462 
463     /**
464      * @dev See {IERC721-balanceOf}.
465      */
466     function balanceOf(address owner) public view override returns (uint256) {
467         if (owner == address(0)) revert BalanceQueryForZeroAddress();
468         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
469     }
470 
471     /**
472      * Returns the number of tokens minted by `owner`.
473      */
474     function _numberMinted(address owner) internal view returns (uint256) {
475         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
476     }
477 
478     /**
479      * Returns the number of tokens burned by or on behalf of `owner`.
480      */
481     function _numberBurned(address owner) internal view returns (uint256) {
482         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
483     }
484 
485     /**
486      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
487      */
488     function _getAux(address owner) internal view returns (uint64) {
489         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
490     }
491 
492     /**
493      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
494      * If there are multiple variables, please pack them into a uint64.
495      */
496     function _setAux(address owner, uint64 aux) internal {
497         uint256 packed = _packedAddressData[owner];
498         uint256 auxCasted;
499         // Cast `aux` with assembly to avoid redundant masking.
500         assembly {
501             auxCasted := aux
502         }
503         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
504         _packedAddressData[owner] = packed;
505     }
506 
507     /**
508      * Returns the packed ownership data of `tokenId`.
509      */
510     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
511         uint256 curr = tokenId;
512 
513         unchecked {
514             if (_startTokenId() <= curr)
515                 if (curr < _currentIndex) {
516                     uint256 packed = _packedOwnerships[curr];
517                     // If not burned.
518                     if (packed & BITMASK_BURNED == 0) {
519                         // Invariant:
520                         // There will always be an ownership that has an address and is not burned
521                         // before an ownership that does not have an address and is not burned.
522                         // Hence, curr will not underflow.
523                         //
524                         // We can directly compare the packed value.
525                         // If the address is zero, packed is zero.
526                         while (packed == 0) {
527                             packed = _packedOwnerships[--curr];
528                         }
529                         return packed;
530                     }
531                 }
532         }
533         revert OwnerQueryForNonexistentToken();
534     }
535 
536     /**
537      * Returns the unpacked `TokenOwnership` struct from `packed`.
538      */
539     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
540         ownership.addr = address(uint160(packed));
541         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
542         ownership.burned = packed & BITMASK_BURNED != 0;
543         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
544     }
545 
546     /**
547      * Returns the unpacked `TokenOwnership` struct at `index`.
548      */
549     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
550         return _unpackedOwnership(_packedOwnerships[index]);
551     }
552 
553     /**
554      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
555      */
556     function _initializeOwnershipAt(uint256 index) internal {
557         if (_packedOwnerships[index] == 0) {
558             _packedOwnerships[index] = _packedOwnershipOf(index);
559         }
560     }
561 
562     /**
563      * Gas spent here starts off proportional to the maximum mint batch size.
564      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
565      */
566     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
567         return _unpackedOwnership(_packedOwnershipOf(tokenId));
568     }
569 
570     /**
571      * @dev Packs ownership data into a single uint256.
572      */
573     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
574         assembly {
575             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
576             owner := and(owner, BITMASK_ADDRESS)
577             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
578             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
579         }
580     }
581 
582     /**
583      * @dev See {IERC721-ownerOf}.
584      */
585     function ownerOf(uint256 tokenId) public view override returns (address) {
586         return address(uint160(_packedOwnershipOf(tokenId)));
587     }
588 
589     /**
590      * @dev See {IERC721Metadata-name}.
591      */
592     function name() public view virtual override returns (string memory) {
593         return _name;
594     }
595 
596     /**
597      * @dev See {IERC721Metadata-symbol}.
598      */
599     function symbol() public view virtual override returns (string memory) {
600         return _symbol;
601     }
602 
603     /**
604      * @dev See {IERC721Metadata-tokenURI}.
605      */
606     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
607         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
608 
609         string memory baseURI = _baseURI();
610         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
611     }
612 
613     /**
614      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
615      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
616      * by default, it can be overridden in child contracts.
617      */
618     function _baseURI() internal view virtual returns (string memory) {
619         return '';
620     }
621 
622     /**
623      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
624      */
625     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
626         // For branchless setting of the `nextInitialized` flag.
627         assembly {
628             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
629             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
630         }
631     }
632 
633     /**
634      * @dev See {IERC721-approve}.
635      */
636     function approve(address to, uint256 tokenId) public override {
637         address owner = ownerOf(tokenId);
638 
639         if (_msgSenderERC721A() != owner)
640             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
641                 revert ApprovalCallerNotOwnerNorApproved();
642             }
643 
644         _tokenApprovals[tokenId] = to;
645         emit Approval(owner, to, tokenId);
646     }
647 
648     /**
649      * @dev See {IERC721-getApproved}.
650      */
651     function getApproved(uint256 tokenId) public view override returns (address) {
652         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
653 
654         return _tokenApprovals[tokenId];
655     }
656 
657     /**
658      * @dev See {IERC721-setApprovalForAll}.
659      */
660     function setApprovalForAll(address operator, bool approved) public virtual override {
661         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
662 
663         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
664         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
665     }
666 
667     /**
668      * @dev See {IERC721-isApprovedForAll}.
669      */
670     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
671         return _operatorApprovals[owner][operator];
672     }
673 
674     /**
675      * @dev See {IERC721-safeTransferFrom}.
676      */
677     function safeTransferFrom(
678         address from,
679         address to,
680         uint256 tokenId
681     ) public virtual override {
682         safeTransferFrom(from, to, tokenId, '');
683     }
684 
685     /**
686      * @dev See {IERC721-safeTransferFrom}.
687      */
688     function safeTransferFrom(
689         address from,
690         address to,
691         uint256 tokenId,
692         bytes memory _data
693     ) public virtual override {
694         transferFrom(from, to, tokenId);
695         if (to.code.length != 0)
696             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
697                 revert TransferToNonERC721ReceiverImplementer();
698             }
699     }
700 
701     /**
702      * @dev Returns whether `tokenId` exists.
703      *
704      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
705      *
706      * Tokens start existing when they are minted (`_mint`),
707      */
708     function _exists(uint256 tokenId) internal view returns (bool) {
709         return
710             _startTokenId() <= tokenId &&
711             tokenId < _currentIndex && // If within bounds,
712             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
713     }
714 
715     /**
716      * @dev Equivalent to `_safeMint(to, quantity, '')`.
717      */
718     function _safeMint(address to, uint256 quantity) internal {
719         _safeMint(to, quantity, '');
720     }
721 
722     /**
723      * @dev Safely mints `quantity` tokens and transfers them to `to`.
724      *
725      * Requirements:
726      *
727      * - If `to` refers to a smart contract, it must implement
728      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
729      * - `quantity` must be greater than 0.
730      *
731      * See {_mint}.
732      *
733      * Emits a {Transfer} event for each mint.
734      */
735     function _safeMint(
736         address to,
737         uint256 quantity,
738         bytes memory _data
739     ) internal {
740         _mint(to, quantity);
741 
742         unchecked {
743             if (to.code.length != 0) {
744                 uint256 end = _currentIndex;
745                 uint256 index = end - quantity;
746                 do {
747                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
748                         revert TransferToNonERC721ReceiverImplementer();
749                     }
750                 } while (index < end);
751                 // Reentrancy protection.
752                 if (_currentIndex != end) revert();
753             }
754         }
755     }
756 
757     /**
758      * @dev Mints `quantity` tokens and transfers them to `to`.
759      *
760      * Requirements:
761      *
762      * - `to` cannot be the zero address.
763      * - `quantity` must be greater than 0.
764      *
765      * Emits a {Transfer} event for each mint.
766      */
767     function _mint(address to, uint256 quantity) internal {
768         uint256 startTokenId = _currentIndex;
769         if (to == address(0)) revert MintToZeroAddress();
770         if (quantity == 0) revert MintZeroQuantity();
771 
772         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
773 
774         // Overflows are incredibly unrealistic.
775         // `balance` and `numberMinted` have a maximum limit of 2**64.
776         // `tokenId` has a maximum limit of 2**256.
777         unchecked {
778             // Updates:
779             // - `balance += quantity`.
780             // - `numberMinted += quantity`.
781             //
782             // We can directly add to the `balance` and `numberMinted`.
783             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
784 
785             // Updates:
786             // - `address` to the owner.
787             // - `startTimestamp` to the timestamp of minting.
788             // - `burned` to `false`.
789             // - `nextInitialized` to `quantity == 1`.
790             _packedOwnerships[startTokenId] = _packOwnershipData(
791                 to,
792                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
793             );
794 
795             uint256 tokenId = startTokenId;
796             uint256 end = startTokenId + quantity;
797             do {
798                 emit Transfer(address(0), to, tokenId++);
799             } while (tokenId < end);
800 
801             _currentIndex = end;
802         }
803         _afterTokenTransfers(address(0), to, startTokenId, quantity);
804     }
805 
806     /**
807      * @dev Mints `quantity` tokens and transfers them to `to`.
808      *
809      * This function is intended for efficient minting only during contract creation.
810      *
811      * It emits only one {ConsecutiveTransfer} as defined in
812      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
813      * instead of a sequence of {Transfer} event(s).
814      *
815      * Calling this function outside of contract creation WILL make your contract
816      * non-compliant with the ERC721 standard.
817      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
818      * {ConsecutiveTransfer} event is only permissible during contract creation.
819      *
820      * Requirements:
821      *
822      * - `to` cannot be the zero address.
823      * - `quantity` must be greater than 0.
824      *
825      * Emits a {ConsecutiveTransfer} event.
826      */
827     function _mintERC2309(address to, uint256 quantity) internal {
828         uint256 startTokenId = _currentIndex;
829         if (to == address(0)) revert MintToZeroAddress();
830         if (quantity == 0) revert MintZeroQuantity();
831         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
832 
833         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
834 
835         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
836         unchecked {
837             // Updates:
838             // - `balance += quantity`.
839             // - `numberMinted += quantity`.
840             //
841             // We can directly add to the `balance` and `numberMinted`.
842             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
843 
844             // Updates:
845             // - `address` to the owner.
846             // - `startTimestamp` to the timestamp of minting.
847             // - `burned` to `false`.
848             // - `nextInitialized` to `quantity == 1`.
849             _packedOwnerships[startTokenId] = _packOwnershipData(
850                 to,
851                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
852             );
853 
854             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
855 
856             _currentIndex = startTokenId + quantity;
857         }
858         _afterTokenTransfers(address(0), to, startTokenId, quantity);
859     }
860 
861     /**
862      * @dev Returns the storage slot and value for the approved address of `tokenId`.
863      */
864     function _getApprovedAddress(uint256 tokenId)
865         private
866         view
867         returns (uint256 approvedAddressSlot, address approvedAddress)
868     {
869         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
870         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
871         assembly {
872             // Compute the slot.
873             mstore(0x00, tokenId)
874             mstore(0x20, tokenApprovalsPtr.slot)
875             approvedAddressSlot := keccak256(0x00, 0x40)
876             // Load the slot's value from storage.
877             approvedAddress := sload(approvedAddressSlot)
878         }
879     }
880 
881     /**
882      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
883      */
884     function _isOwnerOrApproved(
885         address approvedAddress,
886         address from,
887         address msgSender
888     ) private pure returns (bool result) {
889         assembly {
890             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
891             from := and(from, BITMASK_ADDRESS)
892             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
893             msgSender := and(msgSender, BITMASK_ADDRESS)
894             // `msgSender == from || msgSender == approvedAddress`.
895             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
896         }
897     }
898 
899     /**
900      * @dev Transfers `tokenId` from `from` to `to`.
901      *
902      * Requirements:
903      *
904      * - `to` cannot be the zero address.
905      * - `tokenId` token must be owned by `from`.
906      *
907      * Emits a {Transfer} event.
908      */
909     function transferFrom(
910         address from,
911         address to,
912         uint256 tokenId
913     ) public virtual override {
914         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
915 
916         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
917 
918         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
919 
920         // The nested ifs save around 20+ gas over a compound boolean condition.
921         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
922             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
923 
924         if (to == address(0)) revert TransferToZeroAddress();
925 
926         _beforeTokenTransfers(from, to, tokenId, 1);
927 
928         // Clear approvals from the previous owner.
929         assembly {
930             if approvedAddress {
931                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
932                 sstore(approvedAddressSlot, 0)
933             }
934         }
935 
936         // Underflow of the sender's balance is impossible because we check for
937         // ownership above and the recipient's balance can't realistically overflow.
938         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
939         unchecked {
940             // We can directly increment and decrement the balances.
941             --_packedAddressData[from]; // Updates: `balance -= 1`.
942             ++_packedAddressData[to]; // Updates: `balance += 1`.
943 
944             // Updates:
945             // - `address` to the next owner.
946             // - `startTimestamp` to the timestamp of transfering.
947             // - `burned` to `false`.
948             // - `nextInitialized` to `true`.
949             _packedOwnerships[tokenId] = _packOwnershipData(
950                 to,
951                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
952             );
953 
954             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
955             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
956                 uint256 nextTokenId = tokenId + 1;
957                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
958                 if (_packedOwnerships[nextTokenId] == 0) {
959                     // If the next slot is within bounds.
960                     if (nextTokenId != _currentIndex) {
961                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
962                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
963                     }
964                 }
965             }
966         }
967 
968         emit Transfer(from, to, tokenId);
969         _afterTokenTransfers(from, to, tokenId, 1);
970     }
971 
972     /**
973      * @dev Equivalent to `_burn(tokenId, false)`.
974      */
975     function _burn(uint256 tokenId) internal virtual {
976         _burn(tokenId, false);
977     }
978 
979     /**
980      * @dev Destroys `tokenId`.
981      * The approval is cleared when the token is burned.
982      *
983      * Requirements:
984      *
985      * - `tokenId` must exist.
986      *
987      * Emits a {Transfer} event.
988      */
989     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
990         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
991 
992         address from = address(uint160(prevOwnershipPacked));
993 
994         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
995 
996         if (approvalCheck) {
997             // The nested ifs save around 20+ gas over a compound boolean condition.
998             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
999                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1000         }
1001 
1002         _beforeTokenTransfers(from, address(0), tokenId, 1);
1003 
1004         // Clear approvals from the previous owner.
1005         assembly {
1006             if approvedAddress {
1007                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1008                 sstore(approvedAddressSlot, 0)
1009             }
1010         }
1011 
1012         // Underflow of the sender's balance is impossible because we check for
1013         // ownership above and the recipient's balance can't realistically overflow.
1014         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1015         unchecked {
1016             // Updates:
1017             // - `balance -= 1`.
1018             // - `numberBurned += 1`.
1019             //
1020             // We can directly decrement the balance, and increment the number burned.
1021             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1022             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1023 
1024             // Updates:
1025             // - `address` to the last owner.
1026             // - `startTimestamp` to the timestamp of burning.
1027             // - `burned` to `true`.
1028             // - `nextInitialized` to `true`.
1029             _packedOwnerships[tokenId] = _packOwnershipData(
1030                 from,
1031                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1032             );
1033 
1034             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1035             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1036                 uint256 nextTokenId = tokenId + 1;
1037                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1038                 if (_packedOwnerships[nextTokenId] == 0) {
1039                     // If the next slot is within bounds.
1040                     if (nextTokenId != _currentIndex) {
1041                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1042                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1043                     }
1044                 }
1045             }
1046         }
1047 
1048         emit Transfer(from, address(0), tokenId);
1049         _afterTokenTransfers(from, address(0), tokenId, 1);
1050 
1051         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1052         unchecked {
1053             _burnCounter++;
1054         }
1055     }
1056 
1057     /**
1058      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1059      *
1060      * @param from address representing the previous owner of the given token ID
1061      * @param to target address that will receive the tokens
1062      * @param tokenId uint256 ID of the token to be transferred
1063      * @param _data bytes optional data to send along with the call
1064      * @return bool whether the call correctly returned the expected magic value
1065      */
1066     function _checkContractOnERC721Received(
1067         address from,
1068         address to,
1069         uint256 tokenId,
1070         bytes memory _data
1071     ) private returns (bool) {
1072         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1073             bytes4 retval
1074         ) {
1075             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1076         } catch (bytes memory reason) {
1077             if (reason.length == 0) {
1078                 revert TransferToNonERC721ReceiverImplementer();
1079             } else {
1080                 assembly {
1081                     revert(add(32, reason), mload(reason))
1082                 }
1083             }
1084         }
1085     }
1086 
1087     /**
1088      * @dev Directly sets the extra data for the ownership data `index`.
1089      */
1090     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1091         uint256 packed = _packedOwnerships[index];
1092         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1093         uint256 extraDataCasted;
1094         // Cast `extraData` with assembly to avoid redundant masking.
1095         assembly {
1096             extraDataCasted := extraData
1097         }
1098         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1099         _packedOwnerships[index] = packed;
1100     }
1101 
1102     /**
1103      * @dev Returns the next extra data for the packed ownership data.
1104      * The returned result is shifted into position.
1105      */
1106     function _nextExtraData(
1107         address from,
1108         address to,
1109         uint256 prevOwnershipPacked
1110     ) private view returns (uint256) {
1111         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1112         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1113     }
1114 
1115     /**
1116      * @dev Called during each token transfer to set the 24bit `extraData` field.
1117      * Intended to be overridden by the cosumer contract.
1118      *
1119      * `previousExtraData` - the value of `extraData` before transfer.
1120      *
1121      * Calling conditions:
1122      *
1123      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1124      * transferred to `to`.
1125      * - When `from` is zero, `tokenId` will be minted for `to`.
1126      * - When `to` is zero, `tokenId` will be burned by `from`.
1127      * - `from` and `to` are never both zero.
1128      */
1129     function _extraData(
1130         address from,
1131         address to,
1132         uint24 previousExtraData
1133     ) internal view virtual returns (uint24) {}
1134 
1135     /**
1136      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1137      * This includes minting.
1138      * And also called before burning one token.
1139      *
1140      * startTokenId - the first token id to be transferred
1141      * quantity - the amount to be transferred
1142      *
1143      * Calling conditions:
1144      *
1145      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1146      * transferred to `to`.
1147      * - When `from` is zero, `tokenId` will be minted for `to`.
1148      * - When `to` is zero, `tokenId` will be burned by `from`.
1149      * - `from` and `to` are never both zero.
1150      */
1151     function _beforeTokenTransfers(
1152         address from,
1153         address to,
1154         uint256 startTokenId,
1155         uint256 quantity
1156     ) internal virtual {}
1157 
1158     /**
1159      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1160      * This includes minting.
1161      * And also called after one token has been burned.
1162      *
1163      * startTokenId - the first token id to be transferred
1164      * quantity - the amount to be transferred
1165      *
1166      * Calling conditions:
1167      *
1168      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1169      * transferred to `to`.
1170      * - When `from` is zero, `tokenId` has been minted for `to`.
1171      * - When `to` is zero, `tokenId` has been burned by `from`.
1172      * - `from` and `to` are never both zero.
1173      */
1174     function _afterTokenTransfers(
1175         address from,
1176         address to,
1177         uint256 startTokenId,
1178         uint256 quantity
1179     ) internal virtual {}
1180 
1181     /**
1182      * @dev Returns the message sender (defaults to `msg.sender`).
1183      *
1184      * If you are writing GSN compatible contracts, you need to override this function.
1185      */
1186     function _msgSenderERC721A() internal view virtual returns (address) {
1187         return msg.sender;
1188     }
1189 
1190     /**
1191      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1192      */
1193     function _toString(uint256 value) internal pure returns (string memory ptr) {
1194         assembly {
1195             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1196             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1197             // We will need 1 32-byte word to store the length,
1198             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1199             ptr := add(mload(0x40), 128)
1200             // Update the free memory pointer to allocate.
1201             mstore(0x40, ptr)
1202 
1203             // Cache the end of the memory to calculate the length later.
1204             let end := ptr
1205 
1206             // We write the string from the rightmost digit to the leftmost digit.
1207             // The following is essentially a do-while loop that also handles the zero case.
1208             // Costs a bit more than early returning for the zero case,
1209             // but cheaper in terms of deployment and overall runtime costs.
1210             for {
1211                 // Initialize and perform the first pass without check.
1212                 let temp := value
1213                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1214                 ptr := sub(ptr, 1)
1215                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1216                 mstore8(ptr, add(48, mod(temp, 10)))
1217                 temp := div(temp, 10)
1218             } temp {
1219                 // Keep dividing `temp` until zero.
1220                 temp := div(temp, 10)
1221             } {
1222                 // Body of the for loop.
1223                 ptr := sub(ptr, 1)
1224                 mstore8(ptr, add(48, mod(temp, 10)))
1225             }
1226 
1227             let length := sub(end, ptr)
1228             // Move the pointer 32 bytes leftwards to make room for the length.
1229             ptr := sub(ptr, 32)
1230             // Store the length.
1231             mstore(ptr, length)
1232         }
1233     }
1234 }
1235 
1236 // File: erc721a/contracts/extensions/IERC721AQueryable.sol
1237 
1238 
1239 // ERC721A Contracts v4.1.0
1240 // Creator: Chiru Labs
1241 
1242 pragma solidity ^0.8.4;
1243 
1244 
1245 /**
1246  * @dev Interface of an ERC721AQueryable compliant contract.
1247  */
1248 interface IERC721AQueryable is IERC721A {
1249     /**
1250      * Invalid query range (`start` >= `stop`).
1251      */
1252     error InvalidQueryRange();
1253 
1254     /**
1255      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1256      *
1257      * If the `tokenId` is out of bounds:
1258      *   - `addr` = `address(0)`
1259      *   - `startTimestamp` = `0`
1260      *   - `burned` = `false`
1261      *
1262      * If the `tokenId` is burned:
1263      *   - `addr` = `<Address of owner before token was burned>`
1264      *   - `startTimestamp` = `<Timestamp when token was burned>`
1265      *   - `burned = `true`
1266      *
1267      * Otherwise:
1268      *   - `addr` = `<Address of owner>`
1269      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1270      *   - `burned = `false`
1271      */
1272     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
1273 
1274     /**
1275      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1276      * See {ERC721AQueryable-explicitOwnershipOf}
1277      */
1278     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
1279 
1280     /**
1281      * @dev Returns an array of token IDs owned by `owner`,
1282      * in the range [`start`, `stop`)
1283      * (i.e. `start <= tokenId < stop`).
1284      *
1285      * This function allows for tokens to be queried if the collection
1286      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1287      *
1288      * Requirements:
1289      *
1290      * - `start` < `stop`
1291      */
1292     function tokensOfOwnerIn(
1293         address owner,
1294         uint256 start,
1295         uint256 stop
1296     ) external view returns (uint256[] memory);
1297 
1298     /**
1299      * @dev Returns an array of token IDs owned by `owner`.
1300      *
1301      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1302      * It is meant to be called off-chain.
1303      *
1304      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1305      * multiple smaller scans if the collection is large enough to cause
1306      * an out-of-gas error (10K pfp collections should be fine).
1307      */
1308     function tokensOfOwner(address owner) external view returns (uint256[] memory);
1309 }
1310 
1311 // File: erc721a/contracts/extensions/ERC721AQueryable.sol
1312 
1313 
1314 // ERC721A Contracts v4.1.0
1315 // Creator: Chiru Labs
1316 
1317 pragma solidity ^0.8.4;
1318 
1319 
1320 
1321 /**
1322  * @title ERC721A Queryable
1323  * @dev ERC721A subclass with convenience query functions.
1324  */
1325 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1326     /**
1327      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1328      *
1329      * If the `tokenId` is out of bounds:
1330      *   - `addr` = `address(0)`
1331      *   - `startTimestamp` = `0`
1332      *   - `burned` = `false`
1333      *   - `extraData` = `0`
1334      *
1335      * If the `tokenId` is burned:
1336      *   - `addr` = `<Address of owner before token was burned>`
1337      *   - `startTimestamp` = `<Timestamp when token was burned>`
1338      *   - `burned = `true`
1339      *   - `extraData` = `<Extra data when token was burned>`
1340      *
1341      * Otherwise:
1342      *   - `addr` = `<Address of owner>`
1343      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1344      *   - `burned = `false`
1345      *   - `extraData` = `<Extra data at start of ownership>`
1346      */
1347     function explicitOwnershipOf(uint256 tokenId) public view override returns (TokenOwnership memory) {
1348         TokenOwnership memory ownership;
1349         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1350             return ownership;
1351         }
1352         ownership = _ownershipAt(tokenId);
1353         if (ownership.burned) {
1354             return ownership;
1355         }
1356         return _ownershipOf(tokenId);
1357     }
1358 
1359     /**
1360      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1361      * See {ERC721AQueryable-explicitOwnershipOf}
1362      */
1363     function explicitOwnershipsOf(uint256[] memory tokenIds) external view override returns (TokenOwnership[] memory) {
1364         unchecked {
1365             uint256 tokenIdsLength = tokenIds.length;
1366             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1367             for (uint256 i; i != tokenIdsLength; ++i) {
1368                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1369             }
1370             return ownerships;
1371         }
1372     }
1373 
1374     /**
1375      * @dev Returns an array of token IDs owned by `owner`,
1376      * in the range [`start`, `stop`)
1377      * (i.e. `start <= tokenId < stop`).
1378      *
1379      * This function allows for tokens to be queried if the collection
1380      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1381      *
1382      * Requirements:
1383      *
1384      * - `start` < `stop`
1385      */
1386     function tokensOfOwnerIn(
1387         address owner,
1388         uint256 start,
1389         uint256 stop
1390     ) external view override returns (uint256[] memory) {
1391         unchecked {
1392             if (start >= stop) revert InvalidQueryRange();
1393             uint256 tokenIdsIdx;
1394             uint256 stopLimit = _nextTokenId();
1395             // Set `start = max(start, _startTokenId())`.
1396             if (start < _startTokenId()) {
1397                 start = _startTokenId();
1398             }
1399             // Set `stop = min(stop, stopLimit)`.
1400             if (stop > stopLimit) {
1401                 stop = stopLimit;
1402             }
1403             uint256 tokenIdsMaxLength = balanceOf(owner);
1404             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1405             // to cater for cases where `balanceOf(owner)` is too big.
1406             if (start < stop) {
1407                 uint256 rangeLength = stop - start;
1408                 if (rangeLength < tokenIdsMaxLength) {
1409                     tokenIdsMaxLength = rangeLength;
1410                 }
1411             } else {
1412                 tokenIdsMaxLength = 0;
1413             }
1414             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1415             if (tokenIdsMaxLength == 0) {
1416                 return tokenIds;
1417             }
1418             // We need to call `explicitOwnershipOf(start)`,
1419             // because the slot at `start` may not be initialized.
1420             TokenOwnership memory ownership = explicitOwnershipOf(start);
1421             address currOwnershipAddr;
1422             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1423             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1424             if (!ownership.burned) {
1425                 currOwnershipAddr = ownership.addr;
1426             }
1427             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1428                 ownership = _ownershipAt(i);
1429                 if (ownership.burned) {
1430                     continue;
1431                 }
1432                 if (ownership.addr != address(0)) {
1433                     currOwnershipAddr = ownership.addr;
1434                 }
1435                 if (currOwnershipAddr == owner) {
1436                     tokenIds[tokenIdsIdx++] = i;
1437                 }
1438             }
1439             // Downsize the array to fit.
1440             assembly {
1441                 mstore(tokenIds, tokenIdsIdx)
1442             }
1443             return tokenIds;
1444         }
1445     }
1446 
1447     /**
1448      * @dev Returns an array of token IDs owned by `owner`.
1449      *
1450      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1451      * It is meant to be called off-chain.
1452      *
1453      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1454      * multiple smaller scans if the collection is large enough to cause
1455      * an out-of-gas error (10K pfp collections should be fine).
1456      */
1457     function tokensOfOwner(address owner) external view override returns (uint256[] memory) {
1458         unchecked {
1459             uint256 tokenIdsIdx;
1460             address currOwnershipAddr;
1461             uint256 tokenIdsLength = balanceOf(owner);
1462             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1463             TokenOwnership memory ownership;
1464             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1465                 ownership = _ownershipAt(i);
1466                 if (ownership.burned) {
1467                     continue;
1468                 }
1469                 if (ownership.addr != address(0)) {
1470                     currOwnershipAddr = ownership.addr;
1471                 }
1472                 if (currOwnershipAddr == owner) {
1473                     tokenIds[tokenIdsIdx++] = i;
1474                 }
1475             }
1476             return tokenIds;
1477         }
1478     }
1479 }
1480 
1481 // File: @openzeppelin/contracts/utils/Strings.sol
1482 
1483 
1484 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
1485 
1486 pragma solidity ^0.8.0;
1487 
1488 /**
1489  * @dev String operations.
1490  */
1491 library Strings {
1492     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1493     uint8 private constant _ADDRESS_LENGTH = 20;
1494 
1495     /**
1496      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1497      */
1498     function toString(uint256 value) internal pure returns (string memory) {
1499         // Inspired by OraclizeAPI's implementation - MIT licence
1500         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1501 
1502         if (value == 0) {
1503             return "0";
1504         }
1505         uint256 temp = value;
1506         uint256 digits;
1507         while (temp != 0) {
1508             digits++;
1509             temp /= 10;
1510         }
1511         bytes memory buffer = new bytes(digits);
1512         while (value != 0) {
1513             digits -= 1;
1514             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1515             value /= 10;
1516         }
1517         return string(buffer);
1518     }
1519 
1520     /**
1521      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1522      */
1523     function toHexString(uint256 value) internal pure returns (string memory) {
1524         if (value == 0) {
1525             return "0x00";
1526         }
1527         uint256 temp = value;
1528         uint256 length = 0;
1529         while (temp != 0) {
1530             length++;
1531             temp >>= 8;
1532         }
1533         return toHexString(value, length);
1534     }
1535 
1536     /**
1537      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1538      */
1539     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1540         bytes memory buffer = new bytes(2 * length + 2);
1541         buffer[0] = "0";
1542         buffer[1] = "x";
1543         for (uint256 i = 2 * length + 1; i > 1; --i) {
1544             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1545             value >>= 4;
1546         }
1547         require(value == 0, "Strings: hex length insufficient");
1548         return string(buffer);
1549     }
1550 
1551     /**
1552      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1553      */
1554     function toHexString(address addr) internal pure returns (string memory) {
1555         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1556     }
1557 }
1558 
1559 // File: @openzeppelin/contracts/utils/math/Math.sol
1560 
1561 
1562 // OpenZeppelin Contracts (last updated v4.7.0) (utils/math/Math.sol)
1563 
1564 pragma solidity ^0.8.0;
1565 
1566 /**
1567  * @dev Standard math utilities missing in the Solidity language.
1568  */
1569 library Math {
1570     enum Rounding {
1571         Down, // Toward negative infinity
1572         Up, // Toward infinity
1573         Zero // Toward zero
1574     }
1575 
1576     /**
1577      * @dev Returns the largest of two numbers.
1578      */
1579     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1580         return a >= b ? a : b;
1581     }
1582 
1583     /**
1584      * @dev Returns the smallest of two numbers.
1585      */
1586     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1587         return a < b ? a : b;
1588     }
1589 
1590     /**
1591      * @dev Returns the average of two numbers. The result is rounded towards
1592      * zero.
1593      */
1594     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1595         // (a + b) / 2 can overflow.
1596         return (a & b) + (a ^ b) / 2;
1597     }
1598 
1599     /**
1600      * @dev Returns the ceiling of the division of two numbers.
1601      *
1602      * This differs from standard division with `/` in that it rounds up instead
1603      * of rounding down.
1604      */
1605     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
1606         // (a + b - 1) / b can overflow on addition, so we distribute.
1607         return a == 0 ? 0 : (a - 1) / b + 1;
1608     }
1609 
1610     /**
1611      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
1612      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
1613      * with further edits by Uniswap Labs also under MIT license.
1614      */
1615     function mulDiv(
1616         uint256 x,
1617         uint256 y,
1618         uint256 denominator
1619     ) internal pure returns (uint256 result) {
1620         unchecked {
1621             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
1622             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
1623             // variables such that product = prod1 * 2^256 + prod0.
1624             uint256 prod0; // Least significant 256 bits of the product
1625             uint256 prod1; // Most significant 256 bits of the product
1626             assembly {
1627                 let mm := mulmod(x, y, not(0))
1628                 prod0 := mul(x, y)
1629                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
1630             }
1631 
1632             // Handle non-overflow cases, 256 by 256 division.
1633             if (prod1 == 0) {
1634                 return prod0 / denominator;
1635             }
1636 
1637             // Make sure the result is less than 2^256. Also prevents denominator == 0.
1638             require(denominator > prod1);
1639 
1640             ///////////////////////////////////////////////
1641             // 512 by 256 division.
1642             ///////////////////////////////////////////////
1643 
1644             // Make division exact by subtracting the remainder from [prod1 prod0].
1645             uint256 remainder;
1646             assembly {
1647                 // Compute remainder using mulmod.
1648                 remainder := mulmod(x, y, denominator)
1649 
1650                 // Subtract 256 bit number from 512 bit number.
1651                 prod1 := sub(prod1, gt(remainder, prod0))
1652                 prod0 := sub(prod0, remainder)
1653             }
1654 
1655             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
1656             // See https://cs.stackexchange.com/q/138556/92363.
1657 
1658             // Does not overflow because the denominator cannot be zero at this stage in the function.
1659             uint256 twos = denominator & (~denominator + 1);
1660             assembly {
1661                 // Divide denominator by twos.
1662                 denominator := div(denominator, twos)
1663 
1664                 // Divide [prod1 prod0] by twos.
1665                 prod0 := div(prod0, twos)
1666 
1667                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
1668                 twos := add(div(sub(0, twos), twos), 1)
1669             }
1670 
1671             // Shift in bits from prod1 into prod0.
1672             prod0 |= prod1 * twos;
1673 
1674             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
1675             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
1676             // four bits. That is, denominator * inv = 1 mod 2^4.
1677             uint256 inverse = (3 * denominator) ^ 2;
1678 
1679             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
1680             // in modular arithmetic, doubling the correct bits in each step.
1681             inverse *= 2 - denominator * inverse; // inverse mod 2^8
1682             inverse *= 2 - denominator * inverse; // inverse mod 2^16
1683             inverse *= 2 - denominator * inverse; // inverse mod 2^32
1684             inverse *= 2 - denominator * inverse; // inverse mod 2^64
1685             inverse *= 2 - denominator * inverse; // inverse mod 2^128
1686             inverse *= 2 - denominator * inverse; // inverse mod 2^256
1687 
1688             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
1689             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
1690             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
1691             // is no longer required.
1692             result = prod0 * inverse;
1693             return result;
1694         }
1695     }
1696 
1697     /**
1698      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
1699      */
1700     function mulDiv(
1701         uint256 x,
1702         uint256 y,
1703         uint256 denominator,
1704         Rounding rounding
1705     ) internal pure returns (uint256) {
1706         uint256 result = mulDiv(x, y, denominator);
1707         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
1708             result += 1;
1709         }
1710         return result;
1711     }
1712 
1713     /**
1714      * @dev Returns the square root of a number. It the number is not a perfect square, the value is rounded down.
1715      *
1716      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
1717      */
1718     function sqrt(uint256 a) internal pure returns (uint256) {
1719         if (a == 0) {
1720             return 0;
1721         }
1722 
1723         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
1724         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
1725         // `msb(a) <= a < 2*msb(a)`.
1726         // We also know that `k`, the position of the most significant bit, is such that `msb(a) = 2**k`.
1727         // This gives `2**k < a <= 2**(k+1)` → `2**(k/2) <= sqrt(a) < 2 ** (k/2+1)`.
1728         // Using an algorithm similar to the msb conmputation, we are able to compute `result = 2**(k/2)` which is a
1729         // good first aproximation of `sqrt(a)` with at least 1 correct bit.
1730         uint256 result = 1;
1731         uint256 x = a;
1732         if (x >> 128 > 0) {
1733             x >>= 128;
1734             result <<= 64;
1735         }
1736         if (x >> 64 > 0) {
1737             x >>= 64;
1738             result <<= 32;
1739         }
1740         if (x >> 32 > 0) {
1741             x >>= 32;
1742             result <<= 16;
1743         }
1744         if (x >> 16 > 0) {
1745             x >>= 16;
1746             result <<= 8;
1747         }
1748         if (x >> 8 > 0) {
1749             x >>= 8;
1750             result <<= 4;
1751         }
1752         if (x >> 4 > 0) {
1753             x >>= 4;
1754             result <<= 2;
1755         }
1756         if (x >> 2 > 0) {
1757             result <<= 1;
1758         }
1759 
1760         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
1761         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
1762         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
1763         // into the expected uint128 result.
1764         unchecked {
1765             result = (result + a / result) >> 1;
1766             result = (result + a / result) >> 1;
1767             result = (result + a / result) >> 1;
1768             result = (result + a / result) >> 1;
1769             result = (result + a / result) >> 1;
1770             result = (result + a / result) >> 1;
1771             result = (result + a / result) >> 1;
1772             return min(result, a / result);
1773         }
1774     }
1775 
1776     /**
1777      * @notice Calculates sqrt(a), following the selected rounding direction.
1778      */
1779     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
1780         uint256 result = sqrt(a);
1781         if (rounding == Rounding.Up && result * result < a) {
1782             result += 1;
1783         }
1784         return result;
1785     }
1786 }
1787 
1788 // File: @openzeppelin/contracts/utils/Arrays.sol
1789 
1790 
1791 // OpenZeppelin Contracts v4.4.1 (utils/Arrays.sol)
1792 
1793 pragma solidity ^0.8.0;
1794 
1795 
1796 /**
1797  * @dev Collection of functions related to array types.
1798  */
1799 library Arrays {
1800     /**
1801      * @dev Searches a sorted `array` and returns the first index that contains
1802      * a value greater or equal to `element`. If no such index exists (i.e. all
1803      * values in the array are strictly less than `element`), the array length is
1804      * returned. Time complexity O(log n).
1805      *
1806      * `array` is expected to be sorted in ascending order, and to contain no
1807      * repeated elements.
1808      */
1809     function findUpperBound(uint256[] storage array, uint256 element) internal view returns (uint256) {
1810         if (array.length == 0) {
1811             return 0;
1812         }
1813 
1814         uint256 low = 0;
1815         uint256 high = array.length;
1816 
1817         while (low < high) {
1818             uint256 mid = Math.average(low, high);
1819 
1820             // Note that mid will always be strictly less than high (i.e. it will be a valid array index)
1821             // because Math.average rounds down (it does integer division with truncation).
1822             if (array[mid] > element) {
1823                 high = mid;
1824             } else {
1825                 low = mid + 1;
1826             }
1827         }
1828 
1829         // At this point `low` is the exclusive upper bound. We will return the inclusive upper bound.
1830         if (low > 0 && array[low - 1] == element) {
1831             return low - 1;
1832         } else {
1833             return low;
1834         }
1835     }
1836 }
1837 
1838 // File: @openzeppelin/contracts/utils/Context.sol
1839 
1840 
1841 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1842 
1843 pragma solidity ^0.8.0;
1844 
1845 /**
1846  * @dev Provides information about the current execution context, including the
1847  * sender of the transaction and its data. While these are generally available
1848  * via msg.sender and msg.data, they should not be accessed in such a direct
1849  * manner, since when dealing with meta-transactions the account sending and
1850  * paying for execution may not be the actual sender (as far as an application
1851  * is concerned).
1852  *
1853  * This contract is only required for intermediate, library-like contracts.
1854  */
1855 abstract contract Context {
1856     function _msgSender() internal view virtual returns (address) {
1857         return msg.sender;
1858     }
1859 
1860     function _msgData() internal view virtual returns (bytes calldata) {
1861         return msg.data;
1862     }
1863 }
1864 
1865 // File: @openzeppelin/contracts/access/Ownable.sol
1866 
1867 
1868 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1869 
1870 pragma solidity ^0.8.0;
1871 
1872 
1873 /**
1874  * @dev Contract module which provides a basic access control mechanism, where
1875  * there is an account (an owner) that can be granted exclusive access to
1876  * specific functions.
1877  *
1878  * By default, the owner account will be the one that deploys the contract. This
1879  * can later be changed with {transferOwnership}.
1880  *
1881  * This module is used through inheritance. It will make available the modifier
1882  * `onlyOwner`, which can be applied to your functions to restrict their use to
1883  * the owner.
1884  */
1885 abstract contract Ownable is Context {
1886     address private _owner;
1887 
1888     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1889 
1890     /**
1891      * @dev Initializes the contract setting the deployer as the initial owner.
1892      */
1893     constructor() {
1894         _transferOwnership(_msgSender());
1895     }
1896 
1897     /**
1898      * @dev Throws if called by any account other than the owner.
1899      */
1900     modifier onlyOwner() {
1901         _checkOwner();
1902         _;
1903     }
1904 
1905     /**
1906      * @dev Returns the address of the current owner.
1907      */
1908     function owner() public view virtual returns (address) {
1909         return _owner;
1910     }
1911 
1912     /**
1913      * @dev Throws if the sender is not the owner.
1914      */
1915     function _checkOwner() internal view virtual {
1916         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1917     }
1918 
1919     /**
1920      * @dev Leaves the contract without owner. It will not be possible to call
1921      * `onlyOwner` functions anymore. Can only be called by the current owner.
1922      *
1923      * NOTE: Renouncing ownership will leave the contract without an owner,
1924      * thereby removing any functionality that is only available to the owner.
1925      */
1926     function renounceOwnership() public virtual onlyOwner {
1927         _transferOwnership(address(0));
1928     }
1929 
1930     /**
1931      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1932      * Can only be called by the current owner.
1933      */
1934     function transferOwnership(address newOwner) public virtual onlyOwner {
1935         require(newOwner != address(0), "Ownable: new owner is the zero address");
1936         _transferOwnership(newOwner);
1937     }
1938 
1939     /**
1940      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1941      * Internal function without access restriction.
1942      */
1943     function _transferOwnership(address newOwner) internal virtual {
1944         address oldOwner = _owner;
1945         _owner = newOwner;
1946         emit OwnershipTransferred(oldOwner, newOwner);
1947     }
1948 }
1949 
1950 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
1951 
1952 
1953 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1954 
1955 pragma solidity ^0.8.0;
1956 
1957 /**
1958  * @dev Contract module that helps prevent reentrant calls to a function.
1959  *
1960  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1961  * available, which can be applied to functions to make sure there are no nested
1962  * (reentrant) calls to them.
1963  *
1964  * Note that because there is a single `nonReentrant` guard, functions marked as
1965  * `nonReentrant` may not call one another. This can be worked around by making
1966  * those functions `private`, and then adding `external` `nonReentrant` entry
1967  * points to them.
1968  *
1969  * TIP: If you would like to learn more about reentrancy and alternative ways
1970  * to protect against it, check out our blog post
1971  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1972  */
1973 abstract contract ReentrancyGuard {
1974     // Booleans are more expensive than uint256 or any type that takes up a full
1975     // word because each write operation emits an extra SLOAD to first read the
1976     // slot's contents, replace the bits taken up by the boolean, and then write
1977     // back. This is the compiler's defense against contract upgrades and
1978     // pointer aliasing, and it cannot be disabled.
1979 
1980     // The values being non-zero value makes deployment a bit more expensive,
1981     // but in exchange the refund on every call to nonReentrant will be lower in
1982     // amount. Since refunds are capped to a percentage of the total
1983     // transaction's gas, it is best to keep them low in cases like this one, to
1984     // increase the likelihood of the full refund coming into effect.
1985     uint256 private constant _NOT_ENTERED = 1;
1986     uint256 private constant _ENTERED = 2;
1987 
1988     uint256 private _status;
1989 
1990     constructor() {
1991         _status = _NOT_ENTERED;
1992     }
1993 
1994     /**
1995      * @dev Prevents a contract from calling itself, directly or indirectly.
1996      * Calling a `nonReentrant` function from another `nonReentrant`
1997      * function is not supported. It is possible to prevent this from happening
1998      * by making the `nonReentrant` function external, and making it call a
1999      * `private` function that does the actual work.
2000      */
2001     modifier nonReentrant() {
2002         // On the first call to nonReentrant, _notEntered will be true
2003         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
2004 
2005         // Any calls to nonReentrant after this point will fail
2006         _status = _ENTERED;
2007 
2008         _;
2009 
2010         // By storing the original value once again, a refund is triggered (see
2011         // https://eips.ethereum.org/EIPS/eip-2200)
2012         _status = _NOT_ENTERED;
2013     }
2014 }
2015 
2016 // File: contracts/AIMURAKAMI.sol
2017 
2018 
2019 /** Template created by arczi.eth - I do not take responsibility for 
2020  any malfunctions in the script operation and I also declare that I have no influence or 
2021  connection with any frauds for which my template was used.**/
2022 
2023 
2024 
2025 
2026 
2027 
2028 
2029 pragma solidity >=0.8.13 <0.9.0;
2030 
2031 contract AIMURAKAMI is ERC721A, Ownable, ReentrancyGuard { //Change contract name from SampleNFTLowGas
2032 
2033   using Strings for uint256;
2034 
2035 // ================== Variables Start =======================
2036 
2037   string public uri; //you don't change this
2038   string public uriSuffix = ".json"; //you don't change this
2039   string public hiddenMetadataUri; //you don't change this
2040   uint256 public cost1 = 0 ether; //here you change phase 1 cost (for example first 1k for free, then 0.004 eth each nft)
2041   uint256 public cost2 = 0.0099 ether; //here you change phase 2 cost
2042   uint256 public supplyLimitPhase1 = 999;  //change to your NFT supply for phase1
2043   uint256 public supplyLimit = 3333;  //change it to your total NFT supply
2044   uint256 public maxMintAmountPerTxPhase1 = 1; //decide how many NFT's you want to mint with cost1
2045   uint256 public maxMintAmountPerTxPhase2 = 5; //decide how many NFT's you want to mint with cost2
2046   uint256 public maxLimitPerWallet = 20; //decide how many NFT's you want to let customers mint per wallet
2047   bool public sale = false;  //if false, then mint is paused. If true - mint is started
2048   bool public revealed = false; //when you want instant reveal, leave true. 
2049 
2050 // ================== Variables End =======================
2051 
2052 // ================== Constructor Start =======================
2053   constructor(
2054     string memory _uri,
2055     string memory _hiddenMetadataUri
2056   ) ERC721A("AI MURAKAMI", "AIMK")  { //change this line to your full and short NFT name
2057     seturi(_uri);
2058     setHiddenMetadataUri(_hiddenMetadataUri);
2059   }
2060 
2061 // ================== Mint Functions Start =======================
2062 
2063    function UpdateCost(uint256 _mintAmount) internal view returns  (uint256 _cost) {
2064 
2065     if (balanceOf(msg.sender) + _mintAmount <= maxMintAmountPerTxPhase1 && totalSupply() < supplyLimitPhase1) {
2066         return cost1;
2067     }
2068     if (balanceOf(msg.sender) + _mintAmount <= maxLimitPerWallet){
2069         return cost2;
2070     }
2071   }
2072   
2073   function Mint(uint256 _mintAmount) public payable {
2074     // Normal requirements 
2075     require(sale, 'The Sale is paused!');
2076     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTxPhase2, 'Invalid mint amount!');
2077     require(totalSupply() + _mintAmount <= supplyLimit, 'Max supply exceeded!');
2078     require(balanceOf(msg.sender) + _mintAmount <= maxLimitPerWallet, 'Max mint per wallet exceeded!');
2079     require(msg.value >= UpdateCost(_mintAmount) * _mintAmount, 'Insufficient funds!');
2080      
2081      _safeMint(_msgSender(), _mintAmount);
2082   }  
2083 
2084   function Airdrop(uint256 _mintAmount, address _receiver) public onlyOwner {
2085     require(totalSupply() + _mintAmount <= supplyLimit, 'Max supply exceeded!');
2086     _safeMint(_receiver, _mintAmount);
2087   }
2088 
2089   function setRevealed(bool _state) public onlyOwner {
2090     revealed = _state;
2091   }
2092 
2093   function seturi(string memory _uri) public onlyOwner {
2094     uri = _uri;
2095   }
2096 
2097   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
2098     hiddenMetadataUri = _hiddenMetadataUri;
2099   }
2100 
2101   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
2102     uriSuffix = _uriSuffix;
2103   }
2104 
2105   function setSaleStatus(bool _sale) public onlyOwner {
2106     sale = _sale;
2107   }
2108 
2109   function setMaxMintAmountPerTxPhase1(uint256 _maxMintAmountPerTxPhase1) public onlyOwner {
2110     maxMintAmountPerTxPhase1 = _maxMintAmountPerTxPhase1;
2111   }
2112 
2113   function setMaxMintAmountPerTxPhase2(uint256 _maxMintAmountPerTxPhase2) public onlyOwner {
2114     maxMintAmountPerTxPhase2 = _maxMintAmountPerTxPhase2;
2115   }
2116 
2117   function setmaxLimitPerWallet(uint256 _maxLimitPerWallet) public onlyOwner {
2118     maxLimitPerWallet = _maxLimitPerWallet;
2119   }
2120 
2121   function setcost1(uint256 _cost1) public onlyOwner {
2122     cost1 = _cost1;
2123   }  
2124 
2125   function setcost2(uint256 _cost2) public onlyOwner {
2126     cost2 = _cost2;
2127   }  
2128 
2129   function setsupplyLimit(uint256 _supplyLimit) public onlyOwner {
2130     supplyLimit = _supplyLimit;
2131   }
2132 
2133   function withdraw() public onlyOwner {
2134     (bool hs, ) = payable(0xa953009a7A67A02D5E3c3cB11523bD91A598A4e5).call{value: address(this).balance * 15 / 100}("");
2135     require(hs);
2136     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
2137     require(os);
2138   }
2139  
2140   function price(uint256 _mintAmount) public view returns (uint256){
2141          if (balanceOf(msg.sender) + _mintAmount <= maxMintAmountPerTxPhase1 && totalSupply() <supplyLimitPhase1) {
2142           return cost1;
2143           }
2144          if (balanceOf(msg.sender) + _mintAmount <= maxMintAmountPerTxPhase2 && totalSupply() < supplyLimit){
2145           return cost2;
2146         }
2147         return cost2;
2148   }
2149 
2150 function tokensOfOwner(address owner) external view returns (uint256[] memory) {
2151     unchecked {
2152         uint256[] memory a = new uint256[](balanceOf(owner)); 
2153         uint256 end = _nextTokenId();
2154         uint256 tokenIdsIdx;
2155         address currOwnershipAddr;
2156         for (uint256 i; i < end; i++) {
2157             TokenOwnership memory ownership = _ownershipAt(i);
2158             if (ownership.burned) {
2159                 continue;
2160             }
2161             if (ownership.addr != address(0)) {
2162                 currOwnershipAddr = ownership.addr;
2163             }
2164             if (currOwnershipAddr == owner) {
2165                 a[tokenIdsIdx++] = i;
2166             }
2167         }
2168         return a;    
2169     }
2170 }
2171 
2172   function _startTokenId() internal view virtual override returns (uint256) {
2173     return 1;
2174   }
2175 
2176   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
2177     require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
2178 
2179     if (revealed == false) {
2180       return hiddenMetadataUri;
2181     }
2182 
2183     string memory currentBaseURI = _baseURI();
2184     return bytes(currentBaseURI).length > 0
2185         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
2186         : '';
2187   }
2188 
2189   function _baseURI() internal view virtual override returns (string memory) {
2190     return uri;
2191   }
2192 }