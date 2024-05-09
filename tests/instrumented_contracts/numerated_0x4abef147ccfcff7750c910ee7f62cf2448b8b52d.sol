1 //  _   _       _ _                     _   _ _____ _____
2 // | | | | ___ | | | _____      _____  | \ | |  ___|_   _|
3 // | |_| |/ _ \| | |/ _ \ \ /\ / / __| |  \| | |_    | |
4 // |  _  | (_) | | | (_) \ V  V /\__ \ | |\  |  _|   | |
5 // |_| |_|\___/|_|_|\___/ \_/\_/ |___/ |_| \_|_|     |_|
6 //
7 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
8 
9 // SPDX-License-Identifier: MIT
10 // ERC721A Contracts v4.0.0
11 // Creator: Chiru Labs
12 
13 pragma solidity ^0.8.4;
14 
15 /**
16  * @dev Interface of an ERC721A compliant contract.
17  */
18 interface IERC721A {
19     /**
20      * The caller must own the token or be an approved operator.
21      */
22     error ApprovalCallerNotOwnerNorApproved();
23 
24     /**
25      * The token does not exist.
26      */
27     error ApprovalQueryForNonexistentToken();
28 
29     /**
30      * The caller cannot approve to their own address.
31      */
32     error ApproveToCaller();
33 
34     /**
35      * Cannot query the balance for the zero address.
36      */
37     error BalanceQueryForZeroAddress();
38 
39     /**
40      * Cannot mint to the zero address.
41      */
42     error MintToZeroAddress();
43 
44     /**
45      * The quantity of tokens minted must be more than zero.
46      */
47     error MintZeroQuantity();
48 
49     /**
50      * The token does not exist.
51      */
52     error OwnerQueryForNonexistentToken();
53 
54     /**
55      * The caller must own the token or be an approved operator.
56      */
57     error TransferCallerNotOwnerNorApproved();
58 
59     /**
60      * The token must be owned by `from`.
61      */
62     error TransferFromIncorrectOwner();
63 
64     /**
65      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
66      */
67     error TransferToNonERC721ReceiverImplementer();
68 
69     /**
70      * Cannot transfer to the zero address.
71      */
72     error TransferToZeroAddress();
73 
74     /**
75      * The token does not exist.
76      */
77     error URIQueryForNonexistentToken();
78 
79     /**
80      * The `quantity` minted with ERC2309 exceeds the safety limit.
81      */
82     error MintERC2309QuantityExceedsLimit();
83 
84     struct TokenOwnership {
85         // The address of the owner.
86         address addr;
87         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
88         uint64 startTimestamp;
89         // Whether the token has been burned.
90         bool burned;
91         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
92         uint24 extraData;
93     }
94 
95     /**
96      * @dev Returns the total amount of tokens stored by the contract.
97      *
98      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
99      */
100     function totalSupply() external view returns (uint256);
101 
102     // ==============================
103     //            IERC165
104     // ==============================
105 
106     /**
107      * @dev Returns true if this contract implements the interface defined by
108      * `interfaceId`. See the corresponding
109      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
110      * to learn more about how these ids are created.
111      *
112      * This function call must use less than 30 000 gas.
113      */
114     function supportsInterface(bytes4 interfaceId) external view returns (bool);
115 
116     // ==============================
117     //            IERC721
118     // ==============================
119 
120     /**
121      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
122      */
123     event Transfer(
124         address indexed from,
125         address indexed to,
126         uint256 indexed tokenId
127     );
128 
129     /**
130      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
131      */
132     event Approval(
133         address indexed owner,
134         address indexed approved,
135         uint256 indexed tokenId
136     );
137 
138     /**
139      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
140      */
141     event ApprovalForAll(
142         address indexed owner,
143         address indexed operator,
144         bool approved
145     );
146 
147     /**
148      * @dev Returns the number of tokens in ``owner``'s account.
149      */
150     function balanceOf(address owner) external view returns (uint256 balance);
151 
152     /**
153      * @dev Returns the owner of the `tokenId` token.
154      *
155      * Requirements:
156      *
157      * - `tokenId` must exist.
158      */
159     function ownerOf(uint256 tokenId) external view returns (address owner);
160 
161     /**
162      * @dev Safely transfers `tokenId` token from `from` to `to`.
163      *
164      * Requirements:
165      *
166      * - `from` cannot be the zero address.
167      * - `to` cannot be the zero address.
168      * - `tokenId` token must exist and be owned by `from`.
169      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
170      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
171      *
172      * Emits a {Transfer} event.
173      */
174     function safeTransferFrom(
175         address from,
176         address to,
177         uint256 tokenId,
178         bytes calldata data
179     ) external;
180 
181     /**
182      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
183      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
184      *
185      * Requirements:
186      *
187      * - `from` cannot be the zero address.
188      * - `to` cannot be the zero address.
189      * - `tokenId` token must exist and be owned by `from`.
190      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
191      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
192      *
193      * Emits a {Transfer} event.
194      */
195     function safeTransferFrom(
196         address from,
197         address to,
198         uint256 tokenId
199     ) external;
200 
201     /**
202      * @dev Transfers `tokenId` token from `from` to `to`.
203      *
204      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
205      *
206      * Requirements:
207      *
208      * - `from` cannot be the zero address.
209      * - `to` cannot be the zero address.
210      * - `tokenId` token must be owned by `from`.
211      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
212      *
213      * Emits a {Transfer} event.
214      */
215     function transferFrom(
216         address from,
217         address to,
218         uint256 tokenId
219     ) external;
220 
221     /**
222      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
223      * The approval is cleared when the token is transferred.
224      *
225      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
226      *
227      * Requirements:
228      *
229      * - The caller must own the token or be an approved operator.
230      * - `tokenId` must exist.
231      *
232      * Emits an {Approval} event.
233      */
234     function approve(address to, uint256 tokenId) external;
235 
236     /**
237      * @dev Approve or remove `operator` as an operator for the caller.
238      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
239      *
240      * Requirements:
241      *
242      * - The `operator` cannot be the caller.
243      *
244      * Emits an {ApprovalForAll} event.
245      */
246     function setApprovalForAll(address operator, bool _approved) external;
247 
248     /**
249      * @dev Returns the account approved for `tokenId` token.
250      *
251      * Requirements:
252      *
253      * - `tokenId` must exist.
254      */
255     function getApproved(uint256 tokenId)
256         external
257         view
258         returns (address operator);
259 
260     /**
261      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
262      *
263      * See {setApprovalForAll}
264      */
265     function isApprovedForAll(address owner, address operator)
266         external
267         view
268         returns (bool);
269 
270     // ==============================
271     //        IERC721Metadata
272     // ==============================
273 
274     /**
275      * @dev Returns the token collection name.
276      */
277     function name() external view returns (string memory);
278 
279     /**
280      * @dev Returns the token collection symbol.
281      */
282     function symbol() external view returns (string memory);
283 
284     /**
285      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
286      */
287     function tokenURI(uint256 tokenId) external view returns (string memory);
288 
289     // ==============================
290     //            IERC2309
291     // ==============================
292 
293     /**
294      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
295      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
296      */
297     event ConsecutiveTransfer(
298         uint256 indexed fromTokenId,
299         uint256 toTokenId,
300         address indexed from,
301         address indexed to
302     );
303 }
304 
305 /**
306  * @dev ERC721 token receiver interface.
307  */
308 interface ERC721A__IERC721Receiver {
309     function onERC721Received(
310         address operator,
311         address from,
312         uint256 tokenId,
313         bytes calldata data
314     ) external returns (bytes4);
315 }
316 
317 /**
318  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
319  * the Metadata extension. Built to optimize for lower gas during batch mints.
320  *
321  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
322  *
323  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
324  *
325  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
326  */
327 contract ERC721A is IERC721A {
328     // Mask of an entry in packed address data.
329     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
330 
331     // The bit position of `numberMinted` in packed address data.
332     uint256 private constant BITPOS_NUMBER_MINTED = 64;
333 
334     // The bit position of `numberBurned` in packed address data.
335     uint256 private constant BITPOS_NUMBER_BURNED = 128;
336 
337     // The bit position of `aux` in packed address data.
338     uint256 private constant BITPOS_AUX = 192;
339 
340     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
341     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
342 
343     // The bit position of `startTimestamp` in packed ownership.
344     uint256 private constant BITPOS_START_TIMESTAMP = 160;
345 
346     // The bit mask of the `burned` bit in packed ownership.
347     uint256 private constant BITMASK_BURNED = 1 << 224;
348 
349     // The bit position of the `nextInitialized` bit in packed ownership.
350     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
351 
352     // The bit mask of the `nextInitialized` bit in packed ownership.
353     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
354 
355     // The bit position of `extraData` in packed ownership.
356     uint256 private constant BITPOS_EXTRA_DATA = 232;
357 
358     // The mask of the lower 160 bits for addresses.
359     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
360 
361     // The maximum `quantity` that can be minted with `_mintERC2309`.
362     // This limit is to prevent overflows on the address data entries.
363     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
364     // is required to cause an overflow, which is unrealistic.
365     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
366 
367     // The tokenId of the next token to be minted.
368     uint256 private _currentIndex;
369 
370     // The number of tokens burned.
371     uint256 private _burnCounter;
372 
373     // Token name
374     string private _name;
375 
376     // Token symbol
377     string private _symbol;
378 
379     // Mapping from token ID to ownership details
380     // An empty struct value does not necessarily mean the token is unowned.
381     // See `_packedOwnershipOf` implementation for details.
382     //
383     // Bits Layout:
384     // - [0..159]   `addr`
385     // - [160..223] `startTimestamp`
386     // - [224]      `burned`
387     // - [225]      `nextInitialized`
388     // - [232..255] `extraData`
389     mapping(uint256 => uint256) private _packedOwnerships;
390 
391     // Mapping owner address to address data.
392     //
393     // Bits Layout:
394     // - [0..63]    `balance`
395     // - [64..127]  `numberMinted`
396     // - [128..191] `numberBurned`
397     // - [192..255] `aux`
398     mapping(address => uint256) private _packedAddressData;
399 
400     // Mapping from token ID to approved address.
401     mapping(uint256 => address) private _tokenApprovals;
402 
403     // Mapping from owner to operator approvals
404     mapping(address => mapping(address => bool)) private _operatorApprovals;
405 
406     constructor(string memory name_, string memory symbol_) {
407         _name = name_;
408         _symbol = symbol_;
409         _currentIndex = _startTokenId();
410     }
411 
412     /**
413      * @dev Returns the starting token ID.
414      * To change the starting token ID, please override this function.
415      */
416     function _startTokenId() internal view virtual returns (uint256) {
417         return 0;
418     }
419 
420     /**
421      * @dev Returns the next token ID to be minted.
422      */
423     function _nextTokenId() internal view returns (uint256) {
424         return _currentIndex;
425     }
426 
427     /**
428      * @dev Returns the total number of tokens in existence.
429      * Burned tokens will reduce the count.
430      * To get the total number of tokens minted, please see `_totalMinted`.
431      */
432     function totalSupply() public view override returns (uint256) {
433         // Counter underflow is impossible as _burnCounter cannot be incremented
434         // more than `_currentIndex - _startTokenId()` times.
435         unchecked {
436             return _currentIndex - _burnCounter - _startTokenId();
437         }
438     }
439 
440     /**
441      * @dev Returns the total amount of tokens minted in the contract.
442      */
443     function _totalMinted() internal view returns (uint256) {
444         // Counter underflow is impossible as _currentIndex does not decrement,
445         // and it is initialized to `_startTokenId()`
446         unchecked {
447             return _currentIndex - _startTokenId();
448         }
449     }
450 
451     /**
452      * @dev Returns the total number of tokens burned.
453      */
454     function _totalBurned() internal view returns (uint256) {
455         return _burnCounter;
456     }
457 
458     /**
459      * @dev See {IERC165-supportsInterface}.
460      */
461     function supportsInterface(bytes4 interfaceId)
462         public
463         view
464         virtual
465         override
466         returns (bool)
467     {
468         // The interface IDs are constants representing the first 4 bytes of the XOR of
469         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
470         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
471         return
472             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
473             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
474             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
475     }
476 
477     /**
478      * @dev See {IERC721-balanceOf}.
479      */
480     function balanceOf(address owner) public view override returns (uint256) {
481         if (owner == address(0)) revert BalanceQueryForZeroAddress();
482         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
483     }
484 
485     /**
486      * Returns the number of tokens minted by `owner`.
487      */
488     function _numberMinted(address owner) internal view returns (uint256) {
489         return
490             (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) &
491             BITMASK_ADDRESS_DATA_ENTRY;
492     }
493 
494     /**
495      * Returns the number of tokens burned by or on behalf of `owner`.
496      */
497     function _numberBurned(address owner) internal view returns (uint256) {
498         return
499             (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) &
500             BITMASK_ADDRESS_DATA_ENTRY;
501     }
502 
503     /**
504      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
505      */
506     function _getAux(address owner) internal view returns (uint64) {
507         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
508     }
509 
510     /**
511      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
512      * If there are multiple variables, please pack them into a uint64.
513      */
514     function _setAux(address owner, uint64 aux) internal {
515         uint256 packed = _packedAddressData[owner];
516         uint256 auxCasted;
517         assembly {
518             // Cast aux without masking.
519             auxCasted := aux
520         }
521         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
522         _packedAddressData[owner] = packed;
523     }
524 
525     /**
526      * Returns the packed ownership data of `tokenId`.
527      */
528     function _packedOwnershipOf(uint256 tokenId)
529         private
530         view
531         returns (uint256)
532     {
533         uint256 curr = tokenId;
534 
535         unchecked {
536             if (_startTokenId() <= curr)
537                 if (curr < _currentIndex) {
538                     uint256 packed = _packedOwnerships[curr];
539                     // If not burned.
540                     if (packed & BITMASK_BURNED == 0) {
541                         // Invariant:
542                         // There will always be an ownership that has an address and is not burned
543                         // before an ownership that does not have an address and is not burned.
544                         // Hence, curr will not underflow.
545                         //
546                         // We can directly compare the packed value.
547                         // If the address is zero, packed is zero.
548                         while (packed == 0) {
549                             packed = _packedOwnerships[--curr];
550                         }
551                         return packed;
552                     }
553                 }
554         }
555         revert OwnerQueryForNonexistentToken();
556     }
557 
558     /**
559      * Returns the unpacked `TokenOwnership` struct from `packed`.
560      */
561     function _unpackedOwnership(uint256 packed)
562         private
563         pure
564         returns (TokenOwnership memory ownership)
565     {
566         ownership.addr = address(uint160(packed));
567         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
568         ownership.burned = packed & BITMASK_BURNED != 0;
569         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
570     }
571 
572     /**
573      * Returns the unpacked `TokenOwnership` struct at `index`.
574      */
575     function _ownershipAt(uint256 index)
576         internal
577         view
578         returns (TokenOwnership memory)
579     {
580         return _unpackedOwnership(_packedOwnerships[index]);
581     }
582 
583     /**
584      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
585      */
586     function _initializeOwnershipAt(uint256 index) internal {
587         if (_packedOwnerships[index] == 0) {
588             _packedOwnerships[index] = _packedOwnershipOf(index);
589         }
590     }
591 
592     /**
593      * Gas spent here starts off proportional to the maximum mint batch size.
594      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
595      */
596     function _ownershipOf(uint256 tokenId)
597         internal
598         view
599         returns (TokenOwnership memory)
600     {
601         return _unpackedOwnership(_packedOwnershipOf(tokenId));
602     }
603 
604     /**
605      * @dev Packs ownership data into a single uint256.
606      */
607     function _packOwnershipData(address owner, uint256 flags)
608         private
609         view
610         returns (uint256 value)
611     {
612         assembly {
613             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
614             owner := and(owner, BITMASK_ADDRESS)
615             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
616             value := or(
617                 owner,
618                 or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags)
619             )
620         }
621     }
622 
623     /**
624      * @dev See {IERC721-ownerOf}.
625      */
626     function ownerOf(uint256 tokenId) public view override returns (address) {
627         return address(uint160(_packedOwnershipOf(tokenId)));
628     }
629 
630     /**
631      * @dev See {IERC721Metadata-name}.
632      */
633     function name() public view virtual override returns (string memory) {
634         return _name;
635     }
636 
637     /**
638      * @dev See {IERC721Metadata-symbol}.
639      */
640     function symbol() public view virtual override returns (string memory) {
641         return _symbol;
642     }
643 
644     /**
645      * @dev See {IERC721Metadata-tokenURI}.
646      */
647     function tokenURI(uint256 tokenId)
648         public
649         view
650         virtual
651         override
652         returns (string memory)
653     {
654         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
655 
656         string memory baseURI = _baseURI();
657         return
658             bytes(baseURI).length != 0
659                 ? string(abi.encodePacked(baseURI, _toString(tokenId), ".json"))
660                 : "";
661     }
662 
663     /**
664      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
665      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
666      * by default, it can be overridden in child contracts.
667      */
668     function _baseURI() internal view virtual returns (string memory) {
669         return "";
670     }
671 
672     /**
673      * @dev Casts the boolean to uint256 without branching.
674      */
675     function _boolToUint256(bool value) private pure returns (uint256 result) {
676         assembly {
677             result := value
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
699     function getApproved(uint256 tokenId)
700         public
701         view
702         override
703         returns (address)
704     {
705         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
706 
707         return _tokenApprovals[tokenId];
708     }
709 
710     /**
711      * @dev See {IERC721-setApprovalForAll}.
712      */
713     function setApprovalForAll(address operator, bool approved)
714         public
715         virtual
716         override
717     {
718         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
719 
720         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
721         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
722     }
723 
724     /**
725      * @dev See {IERC721-isApprovedForAll}.
726      */
727     function isApprovedForAll(address owner, address operator)
728         public
729         view
730         virtual
731         override
732         returns (bool)
733     {
734         return _operatorApprovals[owner][operator];
735     }
736 
737     /**
738      * @dev See {IERC721-transferFrom}.
739      */
740     function transferFrom(
741         address from,
742         address to,
743         uint256 tokenId
744     ) public virtual override {
745         _transfer(from, to, tokenId);
746     }
747 
748     /**
749      * @dev See {IERC721-safeTransferFrom}.
750      */
751     function safeTransferFrom(
752         address from,
753         address to,
754         uint256 tokenId
755     ) public virtual override {
756         safeTransferFrom(from, to, tokenId, "");
757     }
758 
759     /**
760      * @dev See {IERC721-safeTransferFrom}.
761      */
762     function safeTransferFrom(
763         address from,
764         address to,
765         uint256 tokenId,
766         bytes memory _data
767     ) public virtual override {
768         _transfer(from, to, tokenId);
769         if (to.code.length != 0)
770             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
771                 revert TransferToNonERC721ReceiverImplementer();
772             }
773     }
774 
775     /**
776      * @dev Returns whether `tokenId` exists.
777      *
778      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
779      *
780      * Tokens start existing when they are minted (`_mint`),
781      */
782     function _exists(uint256 tokenId) internal view returns (bool) {
783         return
784             _startTokenId() <= tokenId &&
785             tokenId < _currentIndex && // If within bounds,
786             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
787     }
788 
789     /**
790      * @dev Equivalent to `_safeMint(to, quantity, '')`.
791      */
792     function _safeMint(address to, uint256 quantity) internal {
793         _safeMint(to, quantity, "");
794     }
795 
796     /**
797      * @dev Safely mints `quantity` tokens and transfers them to `to`.
798      *
799      * Requirements:
800      *
801      * - If `to` refers to a smart contract, it must implement
802      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
803      * - `quantity` must be greater than 0.
804      *
805      * See {_mint}.
806      *
807      * Emits a {Transfer} event for each mint.
808      */
809     function _safeMint(
810         address to,
811         uint256 quantity,
812         bytes memory _data
813     ) internal {
814         _mint(to, quantity);
815 
816         unchecked {
817             if (to.code.length != 0) {
818                 uint256 end = _currentIndex;
819                 uint256 index = end - quantity;
820                 do {
821                     if (
822                         !_checkContractOnERC721Received(
823                             address(0),
824                             to,
825                             index++,
826                             _data
827                         )
828                     ) {
829                         revert TransferToNonERC721ReceiverImplementer();
830                     }
831                 } while (index < end);
832                 // Reentrancy protection.
833                 if (_currentIndex != end) revert();
834             }
835         }
836     }
837 
838     /**
839      * @dev Mints `quantity` tokens and transfers them to `to`.
840      *
841      * Requirements:
842      *
843      * - `to` cannot be the zero address.
844      * - `quantity` must be greater than 0.
845      *
846      * Emits a {Transfer} event for each mint.
847      */
848     function _mint(address to, uint256 quantity) internal {
849         uint256 startTokenId = _currentIndex;
850         if (to == address(0)) revert MintToZeroAddress();
851         if (quantity == 0) revert MintZeroQuantity();
852 
853         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
854 
855         // Overflows are incredibly unrealistic.
856         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
857         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
858         unchecked {
859             // Updates:
860             // - `balance += quantity`.
861             // - `numberMinted += quantity`.
862             //
863             // We can directly add to the balance and number minted.
864             _packedAddressData[to] +=
865                 quantity *
866                 ((1 << BITPOS_NUMBER_MINTED) | 1);
867 
868             // Updates:
869             // - `address` to the owner.
870             // - `startTimestamp` to the timestamp of minting.
871             // - `burned` to `false`.
872             // - `nextInitialized` to `quantity == 1`.
873             _packedOwnerships[startTokenId] = _packOwnershipData(
874                 to,
875                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED) |
876                     _nextExtraData(address(0), to, 0)
877             );
878 
879             uint256 offset = startTokenId;
880             uint256 end = quantity + startTokenId;
881             do {
882                 emit Transfer(address(0), to, offset++);
883             } while (offset < end);
884 
885             _currentIndex = startTokenId + quantity;
886         }
887         _afterTokenTransfers(address(0), to, startTokenId, quantity);
888     }
889 
890     /**
891      * @dev Mints `quantity` tokens and transfers them to `to`.
892      *
893      * This function is intended for efficient minting only during contract creation.
894      *
895      * It emits only one {ConsecutiveTransfer} as defined in
896      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
897      * instead of a sequence of {Transfer} event(s).
898      *
899      * Calling this function outside of contract creation WILL make your contract
900      * non-compliant with the ERC721 standard.
901      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
902      * {ConsecutiveTransfer} event is only permissible during contract creation.
903      *
904      * Requirements:
905      *
906      * - `to` cannot be the zero address.
907      * - `quantity` must be greater than 0.
908      *
909      * Emits a {ConsecutiveTransfer} event.
910      */
911     function _mintERC2309(address to, uint256 quantity) internal {
912         uint256 startTokenId = _currentIndex;
913         if (to == address(0)) revert MintToZeroAddress();
914         if (quantity == 0) revert MintZeroQuantity();
915         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT)
916             revert MintERC2309QuantityExceedsLimit();
917 
918         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
919 
920         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
921         unchecked {
922             // Updates:
923             // - `balance += quantity`.
924             // - `numberMinted += quantity`.
925             //
926             // We can directly add to the balance and number minted.
927             _packedAddressData[to] +=
928                 quantity *
929                 ((1 << BITPOS_NUMBER_MINTED) | 1);
930 
931             // Updates:
932             // - `address` to the owner.
933             // - `startTimestamp` to the timestamp of minting.
934             // - `burned` to `false`.
935             // - `nextInitialized` to `quantity == 1`.
936             _packedOwnerships[startTokenId] = _packOwnershipData(
937                 to,
938                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED) |
939                     _nextExtraData(address(0), to, 0)
940             );
941 
942             emit ConsecutiveTransfer(
943                 startTokenId,
944                 startTokenId + quantity - 1,
945                 address(0),
946                 to
947             );
948 
949             _currentIndex = startTokenId + quantity;
950         }
951         _afterTokenTransfers(address(0), to, startTokenId, quantity);
952     }
953 
954     /**
955      * @dev Zeroes out _tokenApprovals[tokenId]
956      */
957     function _removeTokenApproval(uint256 tokenId) private {
958         mapping(uint256 => address) storage tokenApprovalPtr = _tokenApprovals;
959         assembly {
960             mstore(0x00, tokenId)
961             mstore(0x20, tokenApprovalPtr.slot)
962             let hash := keccak256(0, 0x40)
963             sstore(hash, 0)
964         }
965     }
966 
967     /**
968      * @dev Transfers `tokenId` from `from` to `to`.
969      *
970      * Requirements:
971      *
972      * - `to` cannot be the zero address.
973      * - `tokenId` token must be owned by `from`.
974      *
975      * Emits a {Transfer} event.
976      */
977     function _transfer(
978         address from,
979         address to,
980         uint256 tokenId
981     ) private {
982         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
983 
984         if (address(uint160(prevOwnershipPacked)) != from)
985             revert TransferFromIncorrectOwner();
986 
987         address approvedAddress = _tokenApprovals[tokenId];
988 
989         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
990             isApprovedForAll(from, _msgSenderERC721A()) ||
991             approvedAddress == _msgSenderERC721A());
992 
993         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
994         if (to == address(0)) revert TransferToZeroAddress();
995 
996         _beforeTokenTransfers(from, to, tokenId, 1);
997 
998         // Clear approvals from the previous owner.
999         if (approvedAddress != address(0)) {
1000             _removeTokenApproval(tokenId);
1001         }
1002 
1003         // Underflow of the sender's balance is impossible because we check for
1004         // ownership above and the recipient's balance can't realistically overflow.
1005         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1006         unchecked {
1007             // We can directly increment and decrement the balances.
1008             --_packedAddressData[from]; // Updates: `balance -= 1`.
1009             ++_packedAddressData[to]; // Updates: `balance += 1`.
1010 
1011             // Updates:
1012             // - `address` to the next owner.
1013             // - `startTimestamp` to the timestamp of transfering.
1014             // - `burned` to `false`.
1015             // - `nextInitialized` to `true`.
1016             _packedOwnerships[tokenId] = _packOwnershipData(
1017                 to,
1018                 BITMASK_NEXT_INITIALIZED |
1019                     _nextExtraData(from, to, prevOwnershipPacked)
1020             );
1021 
1022             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1023             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1024                 uint256 nextTokenId = tokenId + 1;
1025                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1026                 if (_packedOwnerships[nextTokenId] == 0) {
1027                     // If the next slot is within bounds.
1028                     if (nextTokenId != _currentIndex) {
1029                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1030                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1031                     }
1032                 }
1033             }
1034         }
1035 
1036         emit Transfer(from, to, tokenId);
1037         _afterTokenTransfers(from, to, tokenId, 1);
1038     }
1039 
1040     /**
1041      * @dev Equivalent to `_burn(tokenId, false)`.
1042      */
1043     function _burn(uint256 tokenId) internal virtual {
1044         _burn(tokenId, false);
1045     }
1046 
1047     /**
1048      * @dev Destroys `tokenId`.
1049      * The approval is cleared when the token is burned.
1050      *
1051      * Requirements:
1052      *
1053      * - `tokenId` must exist.
1054      *
1055      * Emits a {Transfer} event.
1056      */
1057     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1058         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1059 
1060         address from = address(uint160(prevOwnershipPacked));
1061         address approvedAddress = _tokenApprovals[tokenId];
1062 
1063         if (approvalCheck) {
1064             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1065                 isApprovedForAll(from, _msgSenderERC721A()) ||
1066                 approvedAddress == _msgSenderERC721A());
1067 
1068             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1069         }
1070 
1071         _beforeTokenTransfers(from, address(0), tokenId, 1);
1072 
1073         // Clear approvals from the previous owner.
1074         if (approvedAddress != address(0)) {
1075             _removeTokenApproval(tokenId);
1076         }
1077 
1078         // Underflow of the sender's balance is impossible because we check for
1079         // ownership above and the recipient's balance can't realistically overflow.
1080         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1081         unchecked {
1082             // Updates:
1083             // - `balance -= 1`.
1084             // - `numberBurned += 1`.
1085             //
1086             // We can directly decrement the balance, and increment the number burned.
1087             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1088             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1089 
1090             // Updates:
1091             // - `address` to the last owner.
1092             // - `startTimestamp` to the timestamp of burning.
1093             // - `burned` to `true`.
1094             // - `nextInitialized` to `true`.
1095             _packedOwnerships[tokenId] = _packOwnershipData(
1096                 from,
1097                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) |
1098                     _nextExtraData(from, address(0), prevOwnershipPacked)
1099             );
1100 
1101             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1102             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1103                 uint256 nextTokenId = tokenId + 1;
1104                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1105                 if (_packedOwnerships[nextTokenId] == 0) {
1106                     // If the next slot is within bounds.
1107                     if (nextTokenId != _currentIndex) {
1108                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1109                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1110                     }
1111                 }
1112             }
1113         }
1114 
1115         emit Transfer(from, address(0), tokenId);
1116         _afterTokenTransfers(from, address(0), tokenId, 1);
1117 
1118         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1119         unchecked {
1120             _burnCounter++;
1121         }
1122     }
1123 
1124     /**
1125      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1126      *
1127      * @param from address representing the previous owner of the given token ID
1128      * @param to target address that will receive the tokens
1129      * @param tokenId uint256 ID of the token to be transferred
1130      * @param _data bytes optional data to send along with the call
1131      * @return bool whether the call correctly returned the expected magic value
1132      */
1133     function _checkContractOnERC721Received(
1134         address from,
1135         address to,
1136         uint256 tokenId,
1137         bytes memory _data
1138     ) private returns (bool) {
1139         try
1140             ERC721A__IERC721Receiver(to).onERC721Received(
1141                 _msgSenderERC721A(),
1142                 from,
1143                 tokenId,
1144                 _data
1145             )
1146         returns (bytes4 retval) {
1147             return
1148                 retval ==
1149                 ERC721A__IERC721Receiver(to).onERC721Received.selector;
1150         } catch (bytes memory reason) {
1151             if (reason.length == 0) {
1152                 revert TransferToNonERC721ReceiverImplementer();
1153             } else {
1154                 assembly {
1155                     revert(add(32, reason), mload(reason))
1156                 }
1157             }
1158         }
1159     }
1160 
1161     /**
1162      * @dev Returns the next extra data for the packed ownership data.
1163      * The returned result is shifted into position.
1164      */
1165     function _nextExtraData(
1166         address from,
1167         address to,
1168         uint256 prevOwnershipPacked
1169     ) internal view virtual returns (uint256) {
1170         uint24 previousExtraData;
1171         assembly {
1172             previousExtraData := shr(BITPOS_EXTRA_DATA, prevOwnershipPacked)
1173         }
1174         return
1175             uint256(_extraData(from, to, previousExtraData)) <<
1176             BITPOS_EXTRA_DATA;
1177     }
1178 
1179     /**
1180      * @dev Called during each token transfer to set the 24bit `extraData` field.
1181      * Intended to be overridden by the cosumer contract.
1182      *
1183      * `previousExtraData` - the value of `extraData` before transfer.
1184      *
1185      * Calling conditions:
1186      *
1187      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1188      * transferred to `to`.
1189      * - When `from` is zero, `tokenId` will be minted for `to`.
1190      * - When `to` is zero, `tokenId` will be burned by `from`.
1191      * - `from` and `to` are never both zero.
1192      */
1193     function _extraData(
1194         address from,
1195         address to,
1196         uint24 previousExtraData
1197     ) internal view virtual returns (uint24) {}
1198 
1199     /**
1200      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1201      * And also called before burning one token.
1202      *
1203      * startTokenId - the first token id to be transferred
1204      * quantity - the amount to be transferred
1205      *
1206      * Calling conditions:
1207      *
1208      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1209      * transferred to `to`.
1210      * - When `from` is zero, `tokenId` will be minted for `to`.
1211      * - When `to` is zero, `tokenId` will be burned by `from`.
1212      * - `from` and `to` are never both zero.
1213      */
1214     function _beforeTokenTransfers(
1215         address from,
1216         address to,
1217         uint256 startTokenId,
1218         uint256 quantity
1219     ) internal virtual {}
1220 
1221     /**
1222      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1223      * minting.
1224      * And also called after one token has been burned.
1225      *
1226      * startTokenId - the first token id to be transferred
1227      * quantity - the amount to be transferred
1228      *
1229      * Calling conditions:
1230      *
1231      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1232      * transferred to `to`.
1233      * - When `from` is zero, `tokenId` has been minted for `to`.
1234      * - When `to` is zero, `tokenId` has been burned by `from`.
1235      * - `from` and `to` are never both zero.
1236      */
1237     function _afterTokenTransfers(
1238         address from,
1239         address to,
1240         uint256 startTokenId,
1241         uint256 quantity
1242     ) internal virtual {}
1243 
1244     /**
1245      * @dev Returns the message sender (defaults to `msg.sender`).
1246      *
1247      * If you are writing GSN compatible contracts, you need to override this function.
1248      */
1249     function _msgSenderERC721A() internal view virtual returns (address) {
1250         return msg.sender;
1251     }
1252 
1253     /**
1254      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1255      */
1256     function _toString(uint256 value)
1257         internal
1258         pure
1259         returns (string memory ptr)
1260     {
1261         assembly {
1262             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1263             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1264             // We will need 1 32-byte word to store the length,
1265             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1266             ptr := add(mload(0x40), 128)
1267             // Update the free memory pointer to allocate.
1268             mstore(0x40, ptr)
1269 
1270             // Cache the end of the memory to calculate the length later.
1271             let end := ptr
1272 
1273             // We write the string from the rightmost digit to the leftmost digit.
1274             // The following is essentially a do-while loop that also handles the zero case.
1275             // Costs a bit more than early returning for the zero case,
1276             // but cheaper in terms of deployment and overall runtime costs.
1277             for {
1278                 // Initialize and perform the first pass without check.
1279                 let temp := value
1280                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1281                 ptr := sub(ptr, 1)
1282                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1283                 mstore8(ptr, add(48, mod(temp, 10)))
1284                 temp := div(temp, 10)
1285             } temp {
1286                 // Keep dividing `temp` until zero.
1287                 temp := div(temp, 10)
1288             } {
1289                 // Body of the for loop.
1290                 ptr := sub(ptr, 1)
1291                 mstore8(ptr, add(48, mod(temp, 10)))
1292             }
1293 
1294             let length := sub(end, ptr)
1295             // Move the pointer 32 bytes leftwards to make room for the length.
1296             ptr := sub(ptr, 32)
1297             // Store the length.
1298             mstore(ptr, length)
1299         }
1300     }
1301 }
1302 
1303 pragma solidity ^0.8.0;
1304 
1305 /**
1306  * @dev Provides information about the current execution context, including the
1307  * sender of the transaction and its data. While these are generally available
1308  * via msg.sender and msg.data, they should not be accessed in such a direct
1309  * manner, since when dealing with meta-transactions the account sending and
1310  * paying for execution may not be the actual sender (as far as an application
1311  * is concerned).
1312  *
1313  * This contract is only required for intermediate, library-like contracts.
1314  */
1315 abstract contract Context {
1316     function _msgSender() internal view virtual returns (address) {
1317         return msg.sender;
1318     }
1319 
1320     function _msgData() internal view virtual returns (bytes calldata) {
1321         return msg.data;
1322     }
1323 }
1324 
1325 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1326 
1327 pragma solidity ^0.8.0;
1328 
1329 /**
1330  * @dev Contract module which provides a basic access control mechanism, where
1331  * there is an account (an owner) that can be granted exclusive access to
1332  * specific functions.
1333  *
1334  * By default, the owner account will be the one that deploys the contract. This
1335  * can later be changed with {transferOwnership}.
1336  *
1337  * This module is used through inheritance. It will make available the modifier
1338  * `onlyOwner`, which can be applied to your functions to restrict their use to
1339  * the owner.
1340  */
1341 abstract contract Ownable is Context {
1342     address private _owner;
1343 
1344     event OwnershipTransferred(
1345         address indexed previousOwner,
1346         address indexed newOwner
1347     );
1348 
1349     /**
1350      * @dev Initializes the contract setting the deployer as the initial owner.
1351      */
1352     constructor() {
1353         _transferOwnership(_msgSender());
1354     }
1355 
1356     /**
1357      * @dev Returns the address of the current owner.
1358      */
1359     function owner() public view virtual returns (address) {
1360         return _owner;
1361     }
1362 
1363     /**
1364      * @dev Throws if called by any account other than the owner.
1365      */
1366     modifier onlyOwner() {
1367         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1368         _;
1369     }
1370 
1371     /**
1372      * @dev Leaves the contract without owner. It will not be possible to call
1373      * `onlyOwner` functions anymore. Can only be called by the current owner.
1374      *
1375      * NOTE: Renouncing ownership will leave the contract without an owner,
1376      * thereby removing any functionality that is only available to the owner.
1377      */
1378     function renounceOwnership() public virtual onlyOwner {
1379         _transferOwnership(address(0));
1380     }
1381 
1382     /**
1383      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1384      * Can only be called by the current owner.
1385      */
1386     function transferOwnership(address newOwner) public virtual onlyOwner {
1387         require(
1388             newOwner != address(0),
1389             "Ownable: new owner is the zero address"
1390         );
1391         _transferOwnership(newOwner);
1392     }
1393 
1394     /**
1395      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1396      * Internal function without access restriction.
1397      */
1398     function _transferOwnership(address newOwner) internal virtual {
1399         address oldOwner = _owner;
1400         _owner = newOwner;
1401         emit OwnershipTransferred(oldOwner, newOwner);
1402     }
1403 }
1404 
1405 pragma solidity ^0.8.4;
1406 
1407 contract HollowsNFT is Ownable, ERC721A {
1408     uint256 public constant maxPerTx = 5;
1409     uint256 public constant maxFree = 2;
1410     uint256 public constant freeMints = 1000;
1411     uint256 public constant price = 0.002 ether;
1412     uint256 public maxSupply = 3600;
1413     bool public mintActive;
1414     string private _baseTokenURI;
1415 
1416     constructor(string memory _inputURI) ERC721A("Hollows NFT", "HOLLOWS") {
1417         _baseTokenURI = _inputURI;
1418     }
1419 
1420     modifier mintCompliance() {
1421         require(tx.origin == msg.sender, "Wrong Caller");
1422         require(mintActive, "Mint inactive");
1423         _;
1424     }
1425 
1426     function _baseURI() internal view virtual override returns (string memory) {
1427         return _baseTokenURI;
1428     }
1429 
1430     function freeMint(uint256 _quantity) external mintCompliance {
1431         require(
1432             _numberMinted(msg.sender) + _quantity <= maxFree,
1433             "Exceeds users free mints"
1434         );
1435         require(freeMints >= totalSupply() + _quantity, "Free mint over");
1436         _safeMint(msg.sender, _quantity);
1437     }
1438 
1439     //Ownable functions
1440     function teamMint(uint256 _quantity, address _to) external onlyOwner {
1441         require(maxSupply >= totalSupply() + _quantity, "Exceeds max supply");
1442         _safeMint(_to, _quantity);
1443     }
1444 
1445     function flipMintState() external onlyOwner {
1446         mintActive = !mintActive;
1447     }
1448 
1449     function reduceSupply(uint256 _amount) external onlyOwner {
1450         require(_amount >= totalSupply(), "Less than current supply");
1451         require(_amount < maxSupply, "Can't increase supply");
1452         maxSupply = _amount;
1453     }
1454 
1455     function setBaseURI(string memory _inputURI) public onlyOwner {
1456         _baseTokenURI = _inputURI;
1457     }
1458 
1459     function withdrawFunds(address _to) external onlyOwner {
1460         (bool success, ) = payable(_to).call{value: address(this).balance}("");
1461         require(success, "transfer failed.");
1462     }
1463 
1464     //Payable functions
1465 
1466     function paidMint(uint256 _quantity) external payable mintCompliance {
1467         require(_quantity <= maxPerTx, "Exceeds max per tx");
1468         require(msg.value >= price * _quantity, "Not enough eth");
1469         require(maxSupply >= totalSupply() + _quantity, "Exceeds max supply");
1470         _safeMint(msg.sender, _quantity);
1471     }
1472 }