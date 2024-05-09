1 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
2 
3 // SPDX-License-Identifier: MIT
4 // ERC721A Contracts v4.0.0
5 // Creator: Chiru Labs
6 
7 pragma solidity ^0.8.4;
8 
9 /**
10  * @dev Interface of an ERC721A compliant contract.
11  */
12 interface IERC721A {
13     /**
14      * The caller must own the token or be an approved operator.
15      */
16     error ApprovalCallerNotOwnerNorApproved();
17 
18     /**
19      * The token does not exist.
20      */
21     error ApprovalQueryForNonexistentToken();
22 
23     /**
24      * The caller cannot approve to their own address.
25      */
26     error ApproveToCaller();
27 
28     /**
29      * Cannot query the balance for the zero address.
30      */
31     error BalanceQueryForZeroAddress();
32 
33     /**
34      * Cannot mint to the zero address.
35      */
36     error MintToZeroAddress();
37 
38     /**
39      * The quantity of tokens minted must be more than zero.
40      */
41     error MintZeroQuantity();
42 
43     /**
44      * The token does not exist.
45      */
46     error OwnerQueryForNonexistentToken();
47 
48     /**
49      * The caller must own the token or be an approved operator.
50      */
51     error TransferCallerNotOwnerNorApproved();
52 
53     /**
54      * The token must be owned by `from`.
55      */
56     error TransferFromIncorrectOwner();
57 
58     /**
59      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
60      */
61     error TransferToNonERC721ReceiverImplementer();
62 
63     /**
64      * Cannot transfer to the zero address.
65      */
66     error TransferToZeroAddress();
67 
68     /**
69      * The token does not exist.
70      */
71     error URIQueryForNonexistentToken();
72 
73     /**
74      * The `quantity` minted with ERC2309 exceeds the safety limit.
75      */
76     error MintERC2309QuantityExceedsLimit();
77 
78     struct TokenOwnership {
79         // The address of the owner.
80         address addr;
81         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
82         uint64 startTimestamp;
83         // Whether the token has been burned.
84         bool burned;
85         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
86         uint24 extraData;
87     }
88 
89     /**
90      * @dev Returns the total amount of tokens stored by the contract.
91      *
92      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
93      */
94     function totalSupply() external view returns (uint256);
95 
96     // ==============================
97     //            IERC165
98     // ==============================
99 
100     /**
101      * @dev Returns true if this contract implements the interface defined by
102      * `interfaceId`. See the corresponding
103      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
104      * to learn more about how these ids are created.
105      *
106      * This function call must use less than 30 000 gas.
107      */
108     function supportsInterface(bytes4 interfaceId) external view returns (bool);
109 
110     // ==============================
111     //            IERC721
112     // ==============================
113 
114     /**
115      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
116      */
117     event Transfer(
118         address indexed from,
119         address indexed to,
120         uint256 indexed tokenId
121     );
122 
123     /**
124      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
125      */
126     event Approval(
127         address indexed owner,
128         address indexed approved,
129         uint256 indexed tokenId
130     );
131 
132     /**
133      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
134      */
135     event ApprovalForAll(
136         address indexed owner,
137         address indexed operator,
138         bool approved
139     );
140 
141     /**
142      * @dev Returns the number of tokens in ``owner``'s account.
143      */
144     function balanceOf(address owner) external view returns (uint256 balance);
145 
146     /**
147      * @dev Returns the owner of the `tokenId` token.
148      *
149      * Requirements:
150      *
151      * - `tokenId` must exist.
152      */
153     function ownerOf(uint256 tokenId) external view returns (address owner);
154 
155     /**
156      * @dev Safely transfers `tokenId` token from `from` to `to`.
157      *
158      * Requirements:
159      *
160      * - `from` cannot be the zero address.
161      * - `to` cannot be the zero address.
162      * - `tokenId` token must exist and be owned by `from`.
163      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
164      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
165      *
166      * Emits a {Transfer} event.
167      */
168     function safeTransferFrom(
169         address from,
170         address to,
171         uint256 tokenId,
172         bytes calldata data
173     ) external;
174 
175     /**
176      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
177      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
178      *
179      * Requirements:
180      *
181      * - `from` cannot be the zero address.
182      * - `to` cannot be the zero address.
183      * - `tokenId` token must exist and be owned by `from`.
184      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
185      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
186      *
187      * Emits a {Transfer} event.
188      */
189     function safeTransferFrom(
190         address from,
191         address to,
192         uint256 tokenId
193     ) external;
194 
195     /**
196      * @dev Transfers `tokenId` token from `from` to `to`.
197      *
198      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
199      *
200      * Requirements:
201      *
202      * - `from` cannot be the zero address.
203      * - `to` cannot be the zero address.
204      * - `tokenId` token must be owned by `from`.
205      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
206      *
207      * Emits a {Transfer} event.
208      */
209     function transferFrom(
210         address from,
211         address to,
212         uint256 tokenId
213     ) external;
214 
215     /**
216      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
217      * The approval is cleared when the token is transferred.
218      *
219      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
220      *
221      * Requirements:
222      *
223      * - The caller must own the token or be an approved operator.
224      * - `tokenId` must exist.
225      *
226      * Emits an {Approval} event.
227      */
228     function approve(address to, uint256 tokenId) external;
229 
230     /**
231      * @dev Approve or remove `operator` as an operator for the caller.
232      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
233      *
234      * Requirements:
235      *
236      * - The `operator` cannot be the caller.
237      *
238      * Emits an {ApprovalForAll} event.
239      */
240     function setApprovalForAll(address operator, bool _approved) external;
241 
242     /**
243      * @dev Returns the account approved for `tokenId` token.
244      *
245      * Requirements:
246      *
247      * - `tokenId` must exist.
248      */
249     function getApproved(uint256 tokenId)
250         external
251         view
252         returns (address operator);
253 
254     /**
255      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
256      *
257      * See {setApprovalForAll}
258      */
259     function isApprovedForAll(address owner, address operator)
260         external
261         view
262         returns (bool);
263 
264     // ==============================
265     //        IERC721Metadata
266     // ==============================
267 
268     /**
269      * @dev Returns the token collection name.
270      */
271     function name() external view returns (string memory);
272 
273     /**
274      * @dev Returns the token collection symbol.
275      */
276     function symbol() external view returns (string memory);
277 
278     /**
279      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
280      */
281     function tokenURI(uint256 tokenId) external view returns (string memory);
282 
283     // ==============================
284     //            IERC2309
285     // ==============================
286 
287     /**
288      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
289      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
290      */
291     event ConsecutiveTransfer(
292         uint256 indexed fromTokenId,
293         uint256 toTokenId,
294         address indexed from,
295         address indexed to
296     );
297 }
298 
299 /**
300  * @dev ERC721 token receiver interface.
301  */
302 interface ERC721A__IERC721Receiver {
303     function onERC721Received(
304         address operator,
305         address from,
306         uint256 tokenId,
307         bytes calldata data
308     ) external returns (bytes4);
309 }
310 
311 /**
312  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
313  * the Metadata extension. Built to optimize for lower gas during batch mints.
314  *
315  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
316  *
317  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
318  *
319  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
320  */
321 contract ERC721A is IERC721A {
322     // Mask of an entry in packed address data.
323     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
324 
325     // The bit position of `numberMinted` in packed address data.
326     uint256 private constant BITPOS_NUMBER_MINTED = 64;
327 
328     // The bit position of `numberBurned` in packed address data.
329     uint256 private constant BITPOS_NUMBER_BURNED = 128;
330 
331     // The bit position of `aux` in packed address data.
332     uint256 private constant BITPOS_AUX = 192;
333 
334     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
335     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
336 
337     // The bit position of `startTimestamp` in packed ownership.
338     uint256 private constant BITPOS_START_TIMESTAMP = 160;
339 
340     // The bit mask of the `burned` bit in packed ownership.
341     uint256 private constant BITMASK_BURNED = 1 << 224;
342 
343     // The bit position of the `nextInitialized` bit in packed ownership.
344     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
345 
346     // The bit mask of the `nextInitialized` bit in packed ownership.
347     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
348 
349     // The bit position of `extraData` in packed ownership.
350     uint256 private constant BITPOS_EXTRA_DATA = 232;
351 
352     // The mask of the lower 160 bits for addresses.
353     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
354 
355     // The maximum `quantity` that can be minted with `_mintERC2309`.
356     // This limit is to prevent overflows on the address data entries.
357     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
358     // is required to cause an overflow, which is unrealistic.
359     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
360 
361     // The tokenId of the next token to be minted.
362     uint256 private _currentIndex;
363 
364     // The number of tokens burned.
365     uint256 private _burnCounter;
366 
367     // Token name
368     string private _name;
369 
370     // Token symbol
371     string private _symbol;
372 
373     // Mapping from token ID to ownership details
374     // An empty struct value does not necessarily mean the token is unowned.
375     // See `_packedOwnershipOf` implementation for details.
376     //
377     // Bits Layout:
378     // - [0..159]   `addr`
379     // - [160..223] `startTimestamp`
380     // - [224]      `burned`
381     // - [225]      `nextInitialized`
382     // - [232..255] `extraData`
383     mapping(uint256 => uint256) private _packedOwnerships;
384 
385     // Mapping owner address to address data.
386     //
387     // Bits Layout:
388     // - [0..63]    `balance`
389     // - [64..127]  `numberMinted`
390     // - [128..191] `numberBurned`
391     // - [192..255] `aux`
392     mapping(address => uint256) private _packedAddressData;
393 
394     // Mapping from token ID to approved address.
395     mapping(uint256 => address) private _tokenApprovals;
396 
397     // Mapping from owner to operator approvals
398     mapping(address => mapping(address => bool)) private _operatorApprovals;
399 
400     constructor(string memory name_, string memory symbol_) {
401         _name = name_;
402         _symbol = symbol_;
403         _currentIndex = _startTokenId();
404     }
405 
406     /**
407      * @dev Returns the starting token ID.
408      * To change the starting token ID, please override this function.
409      */
410     function _startTokenId() internal view virtual returns (uint256) {
411         return 0;
412     }
413 
414     /**
415      * @dev Returns the next token ID to be minted.
416      */
417     function _nextTokenId() internal view returns (uint256) {
418         return _currentIndex;
419     }
420 
421     /**
422      * @dev Returns the total number of tokens in existence.
423      * Burned tokens will reduce the count.
424      * To get the total number of tokens minted, please see `_totalMinted`.
425      */
426     function totalSupply() public view override returns (uint256) {
427         // Counter underflow is impossible as _burnCounter cannot be incremented
428         // more than `_currentIndex - _startTokenId()` times.
429         unchecked {
430             return _currentIndex - _burnCounter - _startTokenId();
431         }
432     }
433 
434     /**
435      * @dev Returns the total amount of tokens minted in the contract.
436      */
437     function _totalMinted() internal view returns (uint256) {
438         // Counter underflow is impossible as _currentIndex does not decrement,
439         // and it is initialized to `_startTokenId()`
440         unchecked {
441             return _currentIndex - _startTokenId();
442         }
443     }
444 
445     /**
446      * @dev Returns the total number of tokens burned.
447      */
448     function _totalBurned() internal view returns (uint256) {
449         return _burnCounter;
450     }
451 
452     /**
453      * @dev See {IERC165-supportsInterface}.
454      */
455     function supportsInterface(bytes4 interfaceId)
456         public
457         view
458         virtual
459         override
460         returns (bool)
461     {
462         // The interface IDs are constants representing the first 4 bytes of the XOR of
463         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
464         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
465         return
466             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
467             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
468             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
469     }
470 
471     /**
472      * @dev See {IERC721-balanceOf}.
473      */
474     function balanceOf(address owner) public view override returns (uint256) {
475         if (owner == address(0)) revert BalanceQueryForZeroAddress();
476         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
477     }
478 
479     /**
480      * Returns the number of tokens minted by `owner`.
481      */
482     function _numberMinted(address owner) internal view returns (uint256) {
483         return
484             (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) &
485             BITMASK_ADDRESS_DATA_ENTRY;
486     }
487 
488     /**
489      * Returns the number of tokens burned by or on behalf of `owner`.
490      */
491     function _numberBurned(address owner) internal view returns (uint256) {
492         return
493             (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) &
494             BITMASK_ADDRESS_DATA_ENTRY;
495     }
496 
497     /**
498      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
499      */
500     function _getAux(address owner) internal view returns (uint64) {
501         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
502     }
503 
504     /**
505      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
506      * If there are multiple variables, please pack them into a uint64.
507      */
508     function _setAux(address owner, uint64 aux) internal {
509         uint256 packed = _packedAddressData[owner];
510         uint256 auxCasted;
511         assembly {
512             // Cast aux without masking.
513             auxCasted := aux
514         }
515         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
516         _packedAddressData[owner] = packed;
517     }
518 
519     /**
520      * Returns the packed ownership data of `tokenId`.
521      */
522     function _packedOwnershipOf(uint256 tokenId)
523         private
524         view
525         returns (uint256)
526     {
527         uint256 curr = tokenId;
528 
529         unchecked {
530             if (_startTokenId() <= curr)
531                 if (curr < _currentIndex) {
532                     uint256 packed = _packedOwnerships[curr];
533                     // If not burned.
534                     if (packed & BITMASK_BURNED == 0) {
535                         // Invariant:
536                         // There will always be an ownership that has an address and is not burned
537                         // before an ownership that does not have an address and is not burned.
538                         // Hence, curr will not underflow.
539                         //
540                         // We can directly compare the packed value.
541                         // If the address is zero, packed is zero.
542                         while (packed == 0) {
543                             packed = _packedOwnerships[--curr];
544                         }
545                         return packed;
546                     }
547                 }
548         }
549         revert OwnerQueryForNonexistentToken();
550     }
551 
552     /**
553      * Returns the unpacked `TokenOwnership` struct from `packed`.
554      */
555     function _unpackedOwnership(uint256 packed)
556         private
557         pure
558         returns (TokenOwnership memory ownership)
559     {
560         ownership.addr = address(uint160(packed));
561         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
562         ownership.burned = packed & BITMASK_BURNED != 0;
563         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
564     }
565 
566     /**
567      * Returns the unpacked `TokenOwnership` struct at `index`.
568      */
569     function _ownershipAt(uint256 index)
570         internal
571         view
572         returns (TokenOwnership memory)
573     {
574         return _unpackedOwnership(_packedOwnerships[index]);
575     }
576 
577     /**
578      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
579      */
580     function _initializeOwnershipAt(uint256 index) internal {
581         if (_packedOwnerships[index] == 0) {
582             _packedOwnerships[index] = _packedOwnershipOf(index);
583         }
584     }
585 
586     /**
587      * Gas spent here starts off proportional to the maximum mint batch size.
588      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
589      */
590     function _ownershipOf(uint256 tokenId)
591         internal
592         view
593         returns (TokenOwnership memory)
594     {
595         return _unpackedOwnership(_packedOwnershipOf(tokenId));
596     }
597 
598     /**
599      * @dev Packs ownership data into a single uint256.
600      */
601     function _packOwnershipData(address owner, uint256 flags)
602         private
603         view
604         returns (uint256 value)
605     {
606         assembly {
607             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
608             owner := and(owner, BITMASK_ADDRESS)
609             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
610             value := or(
611                 owner,
612                 or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags)
613             )
614         }
615     }
616 
617     /**
618      * @dev See {IERC721-ownerOf}.
619      */
620     function ownerOf(uint256 tokenId) public view override returns (address) {
621         return address(uint160(_packedOwnershipOf(tokenId)));
622     }
623 
624     /**
625      * @dev See {IERC721Metadata-name}.
626      */
627     function name() public view virtual override returns (string memory) {
628         return _name;
629     }
630 
631     /**
632      * @dev See {IERC721Metadata-symbol}.
633      */
634     function symbol() public view virtual override returns (string memory) {
635         return _symbol;
636     }
637 
638     /**
639      * @dev See {IERC721Metadata-tokenURI}.
640      */
641     function tokenURI(uint256 tokenId)
642         public
643         view
644         virtual
645         override
646         returns (string memory)
647     {
648         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
649 
650         string memory baseURI = _baseURI();
651         return
652             bytes(baseURI).length != 0
653                 ? string(abi.encodePacked(baseURI, _toString(tokenId), ".json"))
654                 : "";
655     }
656 
657     /**
658      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
659      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
660      * by default, it can be overridden in child contracts.
661      */
662     function _baseURI() internal view virtual returns (string memory) {
663         return "";
664     }
665 
666     /**
667      * @dev Casts the boolean to uint256 without branching.
668      */
669     function _boolToUint256(bool value) private pure returns (uint256 result) {
670         assembly {
671             result := value
672         }
673     }
674 
675     /**
676      * @dev See {IERC721-approve}.
677      */
678     function approve(address to, uint256 tokenId) public override {
679         address owner = ownerOf(tokenId);
680 
681         if (_msgSenderERC721A() != owner)
682             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
683                 revert ApprovalCallerNotOwnerNorApproved();
684             }
685 
686         _tokenApprovals[tokenId] = to;
687         emit Approval(owner, to, tokenId);
688     }
689 
690     /**
691      * @dev See {IERC721-getApproved}.
692      */
693     function getApproved(uint256 tokenId)
694         public
695         view
696         override
697         returns (address)
698     {
699         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
700 
701         return _tokenApprovals[tokenId];
702     }
703 
704     /**
705      * @dev See {IERC721-setApprovalForAll}.
706      */
707     function setApprovalForAll(address operator, bool approved)
708         public
709         virtual
710         override
711     {
712         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
713 
714         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
715         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
716     }
717 
718     /**
719      * @dev See {IERC721-isApprovedForAll}.
720      */
721     function isApprovedForAll(address owner, address operator)
722         public
723         view
724         virtual
725         override
726         returns (bool)
727     {
728         return _operatorApprovals[owner][operator];
729     }
730 
731     /**
732      * @dev See {IERC721-transferFrom}.
733      */
734     function transferFrom(
735         address from,
736         address to,
737         uint256 tokenId
738     ) public virtual override {
739         _transfer(from, to, tokenId);
740     }
741 
742     /**
743      * @dev See {IERC721-safeTransferFrom}.
744      */
745     function safeTransferFrom(
746         address from,
747         address to,
748         uint256 tokenId
749     ) public virtual override {
750         safeTransferFrom(from, to, tokenId, "");
751     }
752 
753     /**
754      * @dev See {IERC721-safeTransferFrom}.
755      */
756     function safeTransferFrom(
757         address from,
758         address to,
759         uint256 tokenId,
760         bytes memory _data
761     ) public virtual override {
762         _transfer(from, to, tokenId);
763         if (to.code.length != 0)
764             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
765                 revert TransferToNonERC721ReceiverImplementer();
766             }
767     }
768 
769     /**
770      * @dev Returns whether `tokenId` exists.
771      *
772      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
773      *
774      * Tokens start existing when they are minted (`_mint`),
775      */
776     function _exists(uint256 tokenId) internal view returns (bool) {
777         return
778             _startTokenId() <= tokenId &&
779             tokenId < _currentIndex && // If within bounds,
780             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
781     }
782 
783     /**
784      * @dev Equivalent to `_safeMint(to, quantity, '')`.
785      */
786     function _safeMint(address to, uint256 quantity) internal {
787         _safeMint(to, quantity, "");
788     }
789 
790     /**
791      * @dev Safely mints `quantity` tokens and transfers them to `to`.
792      *
793      * Requirements:
794      *
795      * - If `to` refers to a smart contract, it must implement
796      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
797      * - `quantity` must be greater than 0.
798      *
799      * See {_mint}.
800      *
801      * Emits a {Transfer} event for each mint.
802      */
803     function _safeMint(
804         address to,
805         uint256 quantity,
806         bytes memory _data
807     ) internal {
808         _mint(to, quantity);
809 
810         unchecked {
811             if (to.code.length != 0) {
812                 uint256 end = _currentIndex;
813                 uint256 index = end - quantity;
814                 do {
815                     if (
816                         !_checkContractOnERC721Received(
817                             address(0),
818                             to,
819                             index++,
820                             _data
821                         )
822                     ) {
823                         revert TransferToNonERC721ReceiverImplementer();
824                     }
825                 } while (index < end);
826                 // Reentrancy protection.
827                 if (_currentIndex != end) revert();
828             }
829         }
830     }
831 
832     /**
833      * @dev Mints `quantity` tokens and transfers them to `to`.
834      *
835      * Requirements:
836      *
837      * - `to` cannot be the zero address.
838      * - `quantity` must be greater than 0.
839      *
840      * Emits a {Transfer} event for each mint.
841      */
842     function _mint(address to, uint256 quantity) internal {
843         uint256 startTokenId = _currentIndex;
844         if (to == address(0)) revert MintToZeroAddress();
845         if (quantity == 0) revert MintZeroQuantity();
846 
847         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
848 
849         // Overflows are incredibly unrealistic.
850         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
851         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
852         unchecked {
853             // Updates:
854             // - `balance += quantity`.
855             // - `numberMinted += quantity`.
856             //
857             // We can directly add to the balance and number minted.
858             _packedAddressData[to] +=
859                 quantity *
860                 ((1 << BITPOS_NUMBER_MINTED) | 1);
861 
862             // Updates:
863             // - `address` to the owner.
864             // - `startTimestamp` to the timestamp of minting.
865             // - `burned` to `false`.
866             // - `nextInitialized` to `quantity == 1`.
867             _packedOwnerships[startTokenId] = _packOwnershipData(
868                 to,
869                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED) |
870                     _nextExtraData(address(0), to, 0)
871             );
872 
873             uint256 offset = startTokenId;
874             uint256 end = quantity + startTokenId;
875             do {
876                 emit Transfer(address(0), to, offset++);
877             } while (offset < end);
878 
879             _currentIndex = startTokenId + quantity;
880         }
881         _afterTokenTransfers(address(0), to, startTokenId, quantity);
882     }
883 
884     /**
885      * @dev Mints `quantity` tokens and transfers them to `to`.
886      *
887      * This function is intended for efficient minting only during contract creation.
888      *
889      * It emits only one {ConsecutiveTransfer} as defined in
890      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
891      * instead of a sequence of {Transfer} event(s).
892      *
893      * Calling this function outside of contract creation WILL make your contract
894      * non-compliant with the ERC721 standard.
895      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
896      * {ConsecutiveTransfer} event is only permissible during contract creation.
897      *
898      * Requirements:
899      *
900      * - `to` cannot be the zero address.
901      * - `quantity` must be greater than 0.
902      *
903      * Emits a {ConsecutiveTransfer} event.
904      */
905     function _mintERC2309(address to, uint256 quantity) internal {
906         uint256 startTokenId = _currentIndex;
907         if (to == address(0)) revert MintToZeroAddress();
908         if (quantity == 0) revert MintZeroQuantity();
909         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT)
910             revert MintERC2309QuantityExceedsLimit();
911 
912         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
913 
914         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
915         unchecked {
916             // Updates:
917             // - `balance += quantity`.
918             // - `numberMinted += quantity`.
919             //
920             // We can directly add to the balance and number minted.
921             _packedAddressData[to] +=
922                 quantity *
923                 ((1 << BITPOS_NUMBER_MINTED) | 1);
924 
925             // Updates:
926             // - `address` to the owner.
927             // - `startTimestamp` to the timestamp of minting.
928             // - `burned` to `false`.
929             // - `nextInitialized` to `quantity == 1`.
930             _packedOwnerships[startTokenId] = _packOwnershipData(
931                 to,
932                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED) |
933                     _nextExtraData(address(0), to, 0)
934             );
935 
936             emit ConsecutiveTransfer(
937                 startTokenId,
938                 startTokenId + quantity - 1,
939                 address(0),
940                 to
941             );
942 
943             _currentIndex = startTokenId + quantity;
944         }
945         _afterTokenTransfers(address(0), to, startTokenId, quantity);
946     }
947 
948     /**
949      * @dev Zeroes out _tokenApprovals[tokenId]
950      */
951     function _removeTokenApproval(uint256 tokenId) private {
952         mapping(uint256 => address) storage tokenApprovalPtr = _tokenApprovals;
953         assembly {
954             mstore(0x00, tokenId)
955             mstore(0x20, tokenApprovalPtr.slot)
956             let hash := keccak256(0, 0x40)
957             sstore(hash, 0)
958         }
959     }
960 
961     /**
962      * @dev Transfers `tokenId` from `from` to `to`.
963      *
964      * Requirements:
965      *
966      * - `to` cannot be the zero address.
967      * - `tokenId` token must be owned by `from`.
968      *
969      * Emits a {Transfer} event.
970      */
971     function _transfer(
972         address from,
973         address to,
974         uint256 tokenId
975     ) private {
976         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
977 
978         if (address(uint160(prevOwnershipPacked)) != from)
979             revert TransferFromIncorrectOwner();
980 
981         address approvedAddress = _tokenApprovals[tokenId];
982 
983         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
984             isApprovedForAll(from, _msgSenderERC721A()) ||
985             approvedAddress == _msgSenderERC721A());
986 
987         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
988         if (to == address(0)) revert TransferToZeroAddress();
989 
990         _beforeTokenTransfers(from, to, tokenId, 1);
991 
992         // Clear approvals from the previous owner.
993         if (approvedAddress != address(0)) {
994             _removeTokenApproval(tokenId);
995         }
996 
997         // Underflow of the sender's balance is impossible because we check for
998         // ownership above and the recipient's balance can't realistically overflow.
999         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1000         unchecked {
1001             // We can directly increment and decrement the balances.
1002             --_packedAddressData[from]; // Updates: `balance -= 1`.
1003             ++_packedAddressData[to]; // Updates: `balance += 1`.
1004 
1005             // Updates:
1006             // - `address` to the next owner.
1007             // - `startTimestamp` to the timestamp of transfering.
1008             // - `burned` to `false`.
1009             // - `nextInitialized` to `true`.
1010             _packedOwnerships[tokenId] = _packOwnershipData(
1011                 to,
1012                 BITMASK_NEXT_INITIALIZED |
1013                     _nextExtraData(from, to, prevOwnershipPacked)
1014             );
1015 
1016             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1017             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1018                 uint256 nextTokenId = tokenId + 1;
1019                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1020                 if (_packedOwnerships[nextTokenId] == 0) {
1021                     // If the next slot is within bounds.
1022                     if (nextTokenId != _currentIndex) {
1023                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1024                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1025                     }
1026                 }
1027             }
1028         }
1029 
1030         emit Transfer(from, to, tokenId);
1031         _afterTokenTransfers(from, to, tokenId, 1);
1032     }
1033 
1034     /**
1035      * @dev Equivalent to `_burn(tokenId, false)`.
1036      */
1037     function _burn(uint256 tokenId) internal virtual {
1038         _burn(tokenId, false);
1039     }
1040 
1041     /**
1042      * @dev Destroys `tokenId`.
1043      * The approval is cleared when the token is burned.
1044      *
1045      * Requirements:
1046      *
1047      * - `tokenId` must exist.
1048      *
1049      * Emits a {Transfer} event.
1050      */
1051     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1052         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1053 
1054         address from = address(uint160(prevOwnershipPacked));
1055         address approvedAddress = _tokenApprovals[tokenId];
1056 
1057         if (approvalCheck) {
1058             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1059                 isApprovedForAll(from, _msgSenderERC721A()) ||
1060                 approvedAddress == _msgSenderERC721A());
1061 
1062             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1063         }
1064 
1065         _beforeTokenTransfers(from, address(0), tokenId, 1);
1066 
1067         // Clear approvals from the previous owner.
1068         if (approvedAddress != address(0)) {
1069             _removeTokenApproval(tokenId);
1070         }
1071 
1072         // Underflow of the sender's balance is impossible because we check for
1073         // ownership above and the recipient's balance can't realistically overflow.
1074         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1075         unchecked {
1076             // Updates:
1077             // - `balance -= 1`.
1078             // - `numberBurned += 1`.
1079             //
1080             // We can directly decrement the balance, and increment the number burned.
1081             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1082             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1083 
1084             // Updates:
1085             // - `address` to the last owner.
1086             // - `startTimestamp` to the timestamp of burning.
1087             // - `burned` to `true`.
1088             // - `nextInitialized` to `true`.
1089             _packedOwnerships[tokenId] = _packOwnershipData(
1090                 from,
1091                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) |
1092                     _nextExtraData(from, address(0), prevOwnershipPacked)
1093             );
1094 
1095             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1096             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1097                 uint256 nextTokenId = tokenId + 1;
1098                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1099                 if (_packedOwnerships[nextTokenId] == 0) {
1100                     // If the next slot is within bounds.
1101                     if (nextTokenId != _currentIndex) {
1102                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1103                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1104                     }
1105                 }
1106             }
1107         }
1108 
1109         emit Transfer(from, address(0), tokenId);
1110         _afterTokenTransfers(from, address(0), tokenId, 1);
1111 
1112         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1113         unchecked {
1114             _burnCounter++;
1115         }
1116     }
1117 
1118     /**
1119      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1120      *
1121      * @param from address representing the previous owner of the given token ID
1122      * @param to target address that will receive the tokens
1123      * @param tokenId uint256 ID of the token to be transferred
1124      * @param _data bytes optional data to send along with the call
1125      * @return bool whether the call correctly returned the expected magic value
1126      */
1127     function _checkContractOnERC721Received(
1128         address from,
1129         address to,
1130         uint256 tokenId,
1131         bytes memory _data
1132     ) private returns (bool) {
1133         try
1134             ERC721A__IERC721Receiver(to).onERC721Received(
1135                 _msgSenderERC721A(),
1136                 from,
1137                 tokenId,
1138                 _data
1139             )
1140         returns (bytes4 retval) {
1141             return
1142                 retval ==
1143                 ERC721A__IERC721Receiver(to).onERC721Received.selector;
1144         } catch (bytes memory reason) {
1145             if (reason.length == 0) {
1146                 revert TransferToNonERC721ReceiverImplementer();
1147             } else {
1148                 assembly {
1149                     revert(add(32, reason), mload(reason))
1150                 }
1151             }
1152         }
1153     }
1154 
1155     /**
1156      * @dev Returns the next extra data for the packed ownership data.
1157      * The returned result is shifted into position.
1158      */
1159     function _nextExtraData(
1160         address from,
1161         address to,
1162         uint256 prevOwnershipPacked
1163     ) internal view virtual returns (uint256) {
1164         uint24 previousExtraData;
1165         assembly {
1166             previousExtraData := shr(BITPOS_EXTRA_DATA, prevOwnershipPacked)
1167         }
1168         return
1169             uint256(_extraData(from, to, previousExtraData)) <<
1170             BITPOS_EXTRA_DATA;
1171     }
1172 
1173     /**
1174      * @dev Called during each token transfer to set the 24bit `extraData` field.
1175      * Intended to be overridden by the cosumer contract.
1176      *
1177      * `previousExtraData` - the value of `extraData` before transfer.
1178      *
1179      * Calling conditions:
1180      *
1181      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1182      * transferred to `to`.
1183      * - When `from` is zero, `tokenId` will be minted for `to`.
1184      * - When `to` is zero, `tokenId` will be burned by `from`.
1185      * - `from` and `to` are never both zero.
1186      */
1187     function _extraData(
1188         address from,
1189         address to,
1190         uint24 previousExtraData
1191     ) internal view virtual returns (uint24) {}
1192 
1193     /**
1194      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1195      * And also called before burning one token.
1196      *
1197      * startTokenId - the first token id to be transferred
1198      * quantity - the amount to be transferred
1199      *
1200      * Calling conditions:
1201      *
1202      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1203      * transferred to `to`.
1204      * - When `from` is zero, `tokenId` will be minted for `to`.
1205      * - When `to` is zero, `tokenId` will be burned by `from`.
1206      * - `from` and `to` are never both zero.
1207      */
1208     function _beforeTokenTransfers(
1209         address from,
1210         address to,
1211         uint256 startTokenId,
1212         uint256 quantity
1213     ) internal virtual {}
1214 
1215     /**
1216      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1217      * minting.
1218      * And also called after one token has been burned.
1219      *
1220      * startTokenId - the first token id to be transferred
1221      * quantity - the amount to be transferred
1222      *
1223      * Calling conditions:
1224      *
1225      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1226      * transferred to `to`.
1227      * - When `from` is zero, `tokenId` has been minted for `to`.
1228      * - When `to` is zero, `tokenId` has been burned by `from`.
1229      * - `from` and `to` are never both zero.
1230      */
1231     function _afterTokenTransfers(
1232         address from,
1233         address to,
1234         uint256 startTokenId,
1235         uint256 quantity
1236     ) internal virtual {}
1237 
1238     /**
1239      * @dev Returns the message sender (defaults to `msg.sender`).
1240      *
1241      * If you are writing GSN compatible contracts, you need to override this function.
1242      */
1243     function _msgSenderERC721A() internal view virtual returns (address) {
1244         return msg.sender;
1245     }
1246 
1247     /**
1248      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1249      */
1250     function _toString(uint256 value)
1251         internal
1252         pure
1253         returns (string memory ptr)
1254     {
1255         assembly {
1256             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1257             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1258             // We will need 1 32-byte word to store the length,
1259             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1260             ptr := add(mload(0x40), 128)
1261             // Update the free memory pointer to allocate.
1262             mstore(0x40, ptr)
1263 
1264             // Cache the end of the memory to calculate the length later.
1265             let end := ptr
1266 
1267             // We write the string from the rightmost digit to the leftmost digit.
1268             // The following is essentially a do-while loop that also handles the zero case.
1269             // Costs a bit more than early returning for the zero case,
1270             // but cheaper in terms of deployment and overall runtime costs.
1271             for {
1272                 // Initialize and perform the first pass without check.
1273                 let temp := value
1274                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1275                 ptr := sub(ptr, 1)
1276                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1277                 mstore8(ptr, add(48, mod(temp, 10)))
1278                 temp := div(temp, 10)
1279             } temp {
1280                 // Keep dividing `temp` until zero.
1281                 temp := div(temp, 10)
1282             } {
1283                 // Body of the for loop.
1284                 ptr := sub(ptr, 1)
1285                 mstore8(ptr, add(48, mod(temp, 10)))
1286             }
1287 
1288             let length := sub(end, ptr)
1289             // Move the pointer 32 bytes leftwards to make room for the length.
1290             ptr := sub(ptr, 32)
1291             // Store the length.
1292             mstore(ptr, length)
1293         }
1294     }
1295 }
1296 // ERC721A Contracts v4.2.0
1297 // Creator: Chiru Labs
1298 
1299 pragma solidity ^0.8.4;
1300 
1301 /**
1302  * @dev Interface of ERC721AQueryable.
1303  */
1304 interface IERC721AQueryable is IERC721A {
1305     /**
1306      * Invalid query range (`start` >= `stop`).
1307      */
1308     error InvalidQueryRange();
1309 
1310     /**
1311      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1312      *
1313      * If the `tokenId` is out of bounds:
1314      *
1315      * - `addr = address(0)`
1316      * - `startTimestamp = 0`
1317      * - `burned = false`
1318      * - `extraData = 0`
1319      *
1320      * If the `tokenId` is burned:
1321      *
1322      * - `addr = <Address of owner before token was burned>`
1323      * - `startTimestamp = <Timestamp when token was burned>`
1324      * - `burned = true`
1325      * - `extraData = <Extra data when token was burned>`
1326      *
1327      * Otherwise:
1328      *
1329      * - `addr = <Address of owner>`
1330      * - `startTimestamp = <Timestamp of start of ownership>`
1331      * - `burned = false`
1332      * - `extraData = <Extra data at start of ownership>`
1333      */
1334     function explicitOwnershipOf(uint256 tokenId)
1335         external
1336         view
1337         returns (TokenOwnership memory);
1338 
1339     /**
1340      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1341      * See {ERC721AQueryable-explicitOwnershipOf}
1342      */
1343     function explicitOwnershipsOf(uint256[] memory tokenIds)
1344         external
1345         view
1346         returns (TokenOwnership[] memory);
1347 
1348     /**
1349      * @dev Returns an array of token IDs owned by `owner`,
1350      * in the range [`start`, `stop`)
1351      * (i.e. `start <= tokenId < stop`).
1352      *
1353      * This function allows for tokens to be queried if the collection
1354      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1355      *
1356      * Requirements:
1357      *
1358      * - `start < stop`
1359      */
1360     function tokensOfOwnerIn(
1361         address owner,
1362         uint256 start,
1363         uint256 stop
1364     ) external view returns (uint256[] memory);
1365 
1366     /**
1367      * @dev Returns an array of token IDs owned by `owner`.
1368      *
1369      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
1370      * It is meant to be called off-chain.
1371      *
1372      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1373      * multiple smaller scans if the collection is large enough to cause
1374      * an out-of-gas error (10K collections should be fine).
1375      */
1376     function tokensOfOwner(address owner)
1377         external
1378         view
1379         returns (uint256[] memory);
1380 }
1381 // ERC721A Contracts v4.2.0
1382 // Creator: Chiru Labs
1383 
1384 pragma solidity ^0.8.4;
1385 
1386 /**
1387  * @title ERC721AQueryable.
1388  *
1389  * @dev ERC721A subclass with convenience query functions.
1390  */
1391 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1392     /**
1393      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1394      *
1395      * If the `tokenId` is out of bounds:
1396      *
1397      * - `addr = address(0)`
1398      * - `startTimestamp = 0`
1399      * - `burned = false`
1400      * - `extraData = 0`
1401      *
1402      * If the `tokenId` is burned:
1403      *
1404      * - `addr = <Address of owner before token was burned>`
1405      * - `startTimestamp = <Timestamp when token was burned>`
1406      * - `burned = true`
1407      * - `extraData = <Extra data when token was burned>`
1408      *
1409      * Otherwise:
1410      *
1411      * - `addr = <Address of owner>`
1412      * - `startTimestamp = <Timestamp of start of ownership>`
1413      * - `burned = false`
1414      * - `extraData = <Extra data at start of ownership>`
1415      */
1416     function explicitOwnershipOf(uint256 tokenId)
1417         public
1418         view
1419         virtual
1420         override
1421         returns (TokenOwnership memory)
1422     {
1423         TokenOwnership memory ownership;
1424         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1425             return ownership;
1426         }
1427         ownership = _ownershipAt(tokenId);
1428         if (ownership.burned) {
1429             return ownership;
1430         }
1431         return _ownershipOf(tokenId);
1432     }
1433 
1434     /**
1435      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1436      * See {ERC721AQueryable-explicitOwnershipOf}
1437      */
1438     function explicitOwnershipsOf(uint256[] calldata tokenIds)
1439         external
1440         view
1441         virtual
1442         override
1443         returns (TokenOwnership[] memory)
1444     {
1445         unchecked {
1446             uint256 tokenIdsLength = tokenIds.length;
1447             TokenOwnership[] memory ownerships = new TokenOwnership[](
1448                 tokenIdsLength
1449             );
1450             for (uint256 i; i != tokenIdsLength; ++i) {
1451                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1452             }
1453             return ownerships;
1454         }
1455     }
1456 
1457     /**
1458      * @dev Returns an array of token IDs owned by `owner`,
1459      * in the range [`start`, `stop`)
1460      * (i.e. `start <= tokenId < stop`).
1461      *
1462      * This function allows for tokens to be queried if the collection
1463      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1464      *
1465      * Requirements:
1466      *
1467      * - `start < stop`
1468      */
1469     function tokensOfOwnerIn(
1470         address owner,
1471         uint256 start,
1472         uint256 stop
1473     ) external view virtual override returns (uint256[] memory) {
1474         unchecked {
1475             if (start >= stop) revert InvalidQueryRange();
1476             uint256 tokenIdsIdx;
1477             uint256 stopLimit = _nextTokenId();
1478             // Set `start = max(start, _startTokenId())`.
1479             if (start < _startTokenId()) {
1480                 start = _startTokenId();
1481             }
1482             // Set `stop = min(stop, stopLimit)`.
1483             if (stop > stopLimit) {
1484                 stop = stopLimit;
1485             }
1486             uint256 tokenIdsMaxLength = balanceOf(owner);
1487             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1488             // to cater for cases where `balanceOf(owner)` is too big.
1489             if (start < stop) {
1490                 uint256 rangeLength = stop - start;
1491                 if (rangeLength < tokenIdsMaxLength) {
1492                     tokenIdsMaxLength = rangeLength;
1493                 }
1494             } else {
1495                 tokenIdsMaxLength = 0;
1496             }
1497             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1498             if (tokenIdsMaxLength == 0) {
1499                 return tokenIds;
1500             }
1501             // We need to call `explicitOwnershipOf(start)`,
1502             // because the slot at `start` may not be initialized.
1503             TokenOwnership memory ownership = explicitOwnershipOf(start);
1504             address currOwnershipAddr;
1505             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1506             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1507             if (!ownership.burned) {
1508                 currOwnershipAddr = ownership.addr;
1509             }
1510             for (
1511                 uint256 i = start;
1512                 i != stop && tokenIdsIdx != tokenIdsMaxLength;
1513                 ++i
1514             ) {
1515                 ownership = _ownershipAt(i);
1516                 if (ownership.burned) {
1517                     continue;
1518                 }
1519                 if (ownership.addr != address(0)) {
1520                     currOwnershipAddr = ownership.addr;
1521                 }
1522                 if (currOwnershipAddr == owner) {
1523                     tokenIds[tokenIdsIdx++] = i;
1524                 }
1525             }
1526             // Downsize the array to fit.
1527             assembly {
1528                 mstore(tokenIds, tokenIdsIdx)
1529             }
1530             return tokenIds;
1531         }
1532     }
1533 
1534     /**
1535      * @dev Returns an array of token IDs owned by `owner`.
1536      *
1537      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
1538      * It is meant to be called off-chain.
1539      *
1540      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1541      * multiple smaller scans if the collection is large enough to cause
1542      * an out-of-gas error (10K collections should be fine).
1543      */
1544     function tokensOfOwner(address owner)
1545         external
1546         view
1547         virtual
1548         override
1549         returns (uint256[] memory)
1550     {
1551         unchecked {
1552             uint256 tokenIdsIdx;
1553             address currOwnershipAddr;
1554             uint256 tokenIdsLength = balanceOf(owner);
1555             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1556             TokenOwnership memory ownership;
1557             for (
1558                 uint256 i = _startTokenId();
1559                 tokenIdsIdx != tokenIdsLength;
1560                 ++i
1561             ) {
1562                 ownership = _ownershipAt(i);
1563                 if (ownership.burned) {
1564                     continue;
1565                 }
1566                 if (ownership.addr != address(0)) {
1567                     currOwnershipAddr = ownership.addr;
1568                 }
1569                 if (currOwnershipAddr == owner) {
1570                     tokenIds[tokenIdsIdx++] = i;
1571                 }
1572             }
1573             return tokenIds;
1574         }
1575     }
1576 }
1577 
1578 pragma solidity ^0.8.0;
1579 
1580 /**
1581  * @dev Provides information about the current execution context, including the
1582  * sender of the transaction and its data. While these are generally available
1583  * via msg.sender and msg.data, they should not be accessed in such a direct
1584  * manner, since when dealing with meta-transactions the account sending and
1585  * paying for execution may not be the actual sender (as far as an application
1586  * is concerned).
1587  *
1588  * This contract is only required for intermediate, library-like contracts.
1589  */
1590 abstract contract Context {
1591     function _msgSender() internal view virtual returns (address) {
1592         return msg.sender;
1593     }
1594 
1595     function _msgData() internal view virtual returns (bytes calldata) {
1596         return msg.data;
1597     }
1598 }
1599 
1600 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1601 
1602 pragma solidity ^0.8.0;
1603 
1604 /**
1605  * @dev Contract module which provides a basic access control mechanism, where
1606  * there is an account (an owner) that can be granted exclusive access to
1607  * specific functions.
1608  *
1609  * By default, the owner account will be the one that deploys the contract. This
1610  * can later be changed with {transferOwnership}.
1611  *
1612  * This module is used through inheritance. It will make available the modifier
1613  * `onlyOwner`, which can be applied to your functions to restrict their use to
1614  * the owner.
1615  */
1616 abstract contract Ownable is Context {
1617     address private _owner;
1618 
1619     event OwnershipTransferred(
1620         address indexed previousOwner,
1621         address indexed newOwner
1622     );
1623 
1624     /**
1625      * @dev Initializes the contract setting the deployer as the initial owner.
1626      */
1627     constructor() {
1628         _transferOwnership(_msgSender());
1629     }
1630 
1631     /**
1632      * @dev Returns the address of the current owner.
1633      */
1634     function owner() public view virtual returns (address) {
1635         return _owner;
1636     }
1637 
1638     /**
1639      * @dev Throws if called by any account other than the owner.
1640      */
1641     modifier onlyOwner() {
1642         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1643         _;
1644     }
1645 
1646     /**
1647      * @dev Leaves the contract without owner. It will not be possible to call
1648      * `onlyOwner` functions anymore. Can only be called by the current owner.
1649      *
1650      * NOTE: Renouncing ownership will leave the contract without an owner,
1651      * thereby removing any functionality that is only available to the owner.
1652      */
1653     function renounceOwnership() public virtual onlyOwner {
1654         _transferOwnership(address(0));
1655     }
1656 
1657     /**
1658      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1659      * Can only be called by the current owner.
1660      */
1661     function transferOwnership(address newOwner) public virtual onlyOwner {
1662         require(
1663             newOwner != address(0),
1664             "Ownable: new owner is the zero address"
1665         );
1666         _transferOwnership(newOwner);
1667     }
1668 
1669     /**
1670      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1671      * Internal function without access restriction.
1672      */
1673     function _transferOwnership(address newOwner) internal virtual {
1674         address oldOwner = _owner;
1675         _owner = newOwner;
1676         emit OwnershipTransferred(oldOwner, newOwner);
1677     }
1678 }
1679 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1680 
1681 pragma solidity ^0.8.0;
1682 
1683 /**
1684  * @dev Contract module that helps prevent reentrant calls to a function.
1685  *
1686  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1687  * available, which can be applied to functions to make sure there are no nested
1688  * (reentrant) calls to them.
1689  *
1690  * Note that because there is a single `nonReentrant` guard, functions marked as
1691  * `nonReentrant` may not call one another. This can be worked around by making
1692  * those functions `private`, and then adding `external` `nonReentrant` entry
1693  * points to them.
1694  *
1695  * TIP: If you would like to learn more about reentrancy and alternative ways
1696  * to protect against it, check out our blog post
1697  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1698  */
1699 abstract contract ReentrancyGuard {
1700     // Booleans are more expensive than uint256 or any type that takes up a full
1701     // word because each write operation emits an extra SLOAD to first read the
1702     // slot's contents, replace the bits taken up by the boolean, and then write
1703     // back. This is the compiler's defense against contract upgrades and
1704     // pointer aliasing, and it cannot be disabled.
1705 
1706     // The values being non-zero value makes deployment a bit more expensive,
1707     // but in exchange the refund on every call to nonReentrant will be lower in
1708     // amount. Since refunds are capped to a percentage of the total
1709     // transaction's gas, it is best to keep them low in cases like this one, to
1710     // increase the likelihood of the full refund coming into effect.
1711     uint256 private constant _NOT_ENTERED = 1;
1712     uint256 private constant _ENTERED = 2;
1713 
1714     uint256 private _status;
1715 
1716     constructor() {
1717         _status = _NOT_ENTERED;
1718     }
1719 
1720     /**
1721      * @dev Prevents a contract from calling itself, directly or indirectly.
1722      * Calling a `nonReentrant` function from another `nonReentrant`
1723      * function is not supported. It is possible to prevent this from happening
1724      * by making the `nonReentrant` function external, and making it call a
1725      * `private` function that does the actual work.
1726      */
1727     modifier nonReentrant() {
1728         _nonReentrantBefore();
1729         _;
1730         _nonReentrantAfter();
1731     }
1732 
1733     function _nonReentrantBefore() private {
1734         // On the first call to nonReentrant, _notEntered will be true
1735         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1736 
1737         // Any calls to nonReentrant after this point will fail
1738         _status = _ENTERED;
1739     }
1740 
1741     function _nonReentrantAfter() private {
1742         // By storing the original value once again, a refund is triggered (see
1743         // https://eips.ethereum.org/EIPS/eip-2200)
1744         _status = _NOT_ENTERED;
1745     }
1746 }
1747 pragma solidity ^0.8.0;
1748 
1749 /**
1750  * @dev These functions deal with verification of Merkle Trees proofs.
1751  *
1752  * The proofs can be generated using the JavaScript library
1753  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1754  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1755  *
1756  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1757  */
1758 library MerkleProof {
1759     /**
1760      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1761      * defined by `root`. For this, a `proof` must be provided, containing
1762      * sibling hashes on the branch from the leaf to the root of the tree. Each
1763      * pair of leaves and each pair of pre-images are assumed to be sorted.
1764      */
1765     function verify(
1766         bytes32[] memory proof,
1767         bytes32 root,
1768         bytes32 leaf
1769     ) internal pure returns (bool) {
1770         return processProof(proof, leaf) == root;
1771     }
1772 
1773     /**
1774      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
1775      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1776      * hash matches the root of the tree. When processing the proof, the pairs
1777      * of leafs & pre-images are assumed to be sorted.
1778      *
1779      * _Available since v4.4._
1780      */
1781     function processProof(bytes32[] memory proof, bytes32 leaf)
1782         internal
1783         pure
1784         returns (bytes32)
1785     {
1786         bytes32 computedHash = leaf;
1787         for (uint256 i = 0; i < proof.length; i++) {
1788             bytes32 proofElement = proof[i];
1789             if (computedHash <= proofElement) {
1790                 // Hash(current computed hash + current element of the proof)
1791                 computedHash = keccak256(
1792                     abi.encodePacked(computedHash, proofElement)
1793                 );
1794             } else {
1795                 // Hash(current element of the proof + current computed hash)
1796                 computedHash = keccak256(
1797                     abi.encodePacked(proofElement, computedHash)
1798                 );
1799             }
1800         }
1801         return computedHash;
1802     }
1803 }
1804 
1805 pragma solidity ^0.8.4;
1806 error MintedOut();
1807 error EthAmount();
1808 error WLCap();
1809 error SupplyCap();
1810 
1811 contract Suji is Ownable, ReentrancyGuard, ERC721A, ERC721AQueryable {
1812     uint256 public constant maxWL = 2;
1813     uint256 public constant maxPublic = 1;
1814     uint256 public maxSupply = 5555;
1815     uint256 public price = 0.0055 ether;
1816     bool public mintActive;
1817     bool public publicActive;
1818     bytes32 private _wlMerkleRoot;
1819     string private _baseTokenURI;
1820 
1821     mapping(address => uint256) public userPubMints;
1822 
1823     constructor(
1824         string memory _inputURI,
1825         bytes32 _wlRoot
1826     ) ERC721A("Suji", "SUJI") {
1827         _baseTokenURI = _inputURI;
1828         _wlMerkleRoot = _wlRoot;
1829     }
1830 
1831     modifier mintCompliance(uint256 _quantity, uint256 value) {
1832         if (price * _quantity > value) revert EthAmount();
1833         require(tx.origin == msg.sender, "Wrong Caller");
1834         require(mintActive, "Mint inactive");
1835         if (maxSupply < totalSupply() + _quantity) revert MintedOut();
1836         _;
1837     }
1838 
1839     //External Functions
1840     function wlMint(uint256 _quantity, bytes32[] calldata proof)
1841         external
1842         payable
1843         mintCompliance(_quantity, msg.value)
1844         nonReentrant
1845     {
1846         if (_numberMinted(msg.sender) + _quantity > maxWL) revert WLCap();
1847         require(
1848             MerkleProof.verify(proof, _wlMerkleRoot, _leaf(msg.sender)),
1849             "Not WL"
1850         );
1851         _mint(msg.sender, _quantity);
1852     }
1853 
1854     function publicMint() external payable mintCompliance(1, msg.value) {
1855         require(publicActive, "Public inactive");
1856         require(userPubMints[msg.sender] == 0, "Already Minted");
1857         userPubMints[msg.sender] = 1;
1858         _mint(msg.sender, 1);
1859     }
1860 
1861     function userMints(address _account)
1862         external
1863         view
1864         virtual
1865         returns (uint256)
1866     {
1867         return _numberMinted(_account);
1868     }
1869 
1870     // Internal Functions
1871     function _baseURI() internal view virtual override returns (string memory) {
1872         return _baseTokenURI;
1873     }
1874 
1875     function _leaf(address _account) internal pure returns (bytes32) {
1876         return keccak256(abi.encodePacked(_account));
1877     }
1878 
1879     //Ownable functions
1880     function teamMint(uint256 _quantity, address _to) external onlyOwner {
1881         if (maxSupply < totalSupply() + _quantity) revert SupplyCap();
1882         _mint(_to, _quantity);
1883     }
1884 
1885     function setMerkleRoot(bytes32 _root) public onlyOwner {
1886         _wlMerkleRoot = _root;
1887     }
1888 
1889     function flipMintState() external onlyOwner {
1890         mintActive = !mintActive;
1891     }
1892 
1893     function flipPublic() external onlyOwner {
1894         publicActive = !publicActive;
1895     }
1896 
1897     function reduceSupply(uint256 _amount) external onlyOwner {
1898         if (totalSupply() > _amount) revert SupplyCap();
1899         if (_amount > maxSupply) revert SupplyCap();
1900         maxSupply = _amount;
1901     }
1902 
1903     function changePrice(uint256 _price) external onlyOwner {
1904         price = _price;
1905     }
1906 
1907     function setBaseURI(string memory _inputURI) public onlyOwner {
1908         _baseTokenURI = _inputURI;
1909     }
1910 
1911     function withdrawFunds(address _to, uint256 _amount) external onlyOwner {
1912         (bool success, ) = payable(_to).call{value: _amount}("");
1913         require(success, "transfer failed.");
1914     }
1915 }