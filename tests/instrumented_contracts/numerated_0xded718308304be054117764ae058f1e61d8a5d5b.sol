1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.11;
4 
5 interface IERC721A {
6   /**
7    * The caller must own the token or be an approved operator.
8    */
9   error ApprovalCallerNotOwnerNorApproved();
10   /**
11    * The token does not exist.
12    */
13   error ApprovalQueryForNonexistentToken();
14   /**
15    * The caller cannot approve to their own address.
16    */
17   error ApproveToCaller();
18   /**
19    * Cannot query the balance for the zero address.
20    */
21   error BalanceQueryForZeroAddress();
22   /**
23    * Cannot mint to the zero address.
24    */
25   error MintToZeroAddress();
26   /**
27    * The quantity of tokens minted must be more than zero.
28    */
29   error MintZeroQuantity();
30   /**
31    * The token does not exist.
32    */
33   error OwnerQueryForNonexistentToken();
34   /**
35    * The caller must own the token or be an approved operator.
36    */
37   error TransferCallerNotOwnerNorApproved();
38   /**
39    * The token must be owned by `from`.
40    */
41   error TransferFromIncorrectOwner();
42   /**
43    * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
44    */
45   error TransferToNonERC721ReceiverImplementer();
46   /**
47    * Cannot transfer to the zero address.
48    */
49   error TransferToZeroAddress();
50   /**
51    * The token does not exist.
52    */
53   error URIQueryForNonexistentToken();
54   /**
55    * The `quantity` minted with ERC2309 exceeds the safety limit.
56    */
57   error MintERC2309QuantityExceedsLimit();
58   /**
59    * The `extraData` cannot be set on an unintialized ownership slot.
60    */
61   error OwnershipNotInitializedForExtraData();
62   struct TokenOwnership {
63     // The address of the owner.
64     address addr;
65     // Keeps track of the start time of ownership with minimal overhead for tokenomics.
66     uint64 startTimestamp;
67     // Whether the token has been burned.
68     bool burned;
69     // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
70     uint24 extraData;
71   }
72 
73   /**
74    * @dev Returns the total amount of tokens stored by the contract.
75    *
76    * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
77    */
78   function totalSupply() external view returns (uint256);
79 
80   // ==============================
81   //            IERC165
82   // ==============================
83   /**
84    * @dev Returns true if this contract implements the interface defined by
85    * `interfaceId`. See the corresponding
86    * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
87    * to learn more about how these ids are created.
88    *
89    * This function call must use less than 30 000 gas.
90    */
91   function supportsInterface(bytes4 interfaceId) external view returns (bool);
92 
93   // ==============================
94   //            IERC721
95   // ==============================
96   /**
97    * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
98    */
99   event Transfer(
100     address indexed from,
101     address indexed to,
102     uint256 indexed tokenId
103   );
104   /**
105    * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
106    */
107   event Approval(
108     address indexed owner,
109     address indexed approved,
110     uint256 indexed tokenId
111   );
112   /**
113    * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
114    */
115   event ApprovalForAll(
116     address indexed owner,
117     address indexed operator,
118     bool approved
119   );
120 
121   /**
122    * @dev Returns the number of tokens in ``owner``'s account.
123    */
124   function balanceOf(address owner) external view returns (uint256 balance);
125 
126   /**
127    * @dev Returns the owner of the `tokenId` token.
128    *
129    * Requirements:
130    *
131    * - `tokenId` must exist.
132    */
133   function ownerOf(uint256 tokenId) external view returns (address owner);
134 
135   /**
136    * @dev Safely transfers `tokenId` token from `from` to `to`.
137    *
138    * Requirements:
139    *
140    * - `from` cannot be the zero address.
141    * - `to` cannot be the zero address.
142    * - `tokenId` token must exist and be owned by `from`.
143    * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
144    * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
145    *
146    * Emits a {Transfer} event.
147    */
148   function safeTransferFrom(
149     address from,
150     address to,
151     uint256 tokenId,
152     bytes calldata data
153   ) external;
154 
155   /**
156    * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
157    * are aware of the ERC721 protocol to prevent tokens from being forever locked.
158    *
159    * Requirements:
160    *
161    * - `from` cannot be the zero address.
162    * - `to` cannot be the zero address.
163    * - `tokenId` token must exist and be owned by `from`.
164    * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
165    * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
166    *
167    * Emits a {Transfer} event.
168    */
169   function safeTransferFrom(
170     address from,
171     address to,
172     uint256 tokenId
173   ) external;
174 
175   /**
176    * @dev Transfers `tokenId` token from `from` to `to`.
177    *
178    * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
179    *
180    * Requirements:
181    *
182    * - `from` cannot be the zero address.
183    * - `to` cannot be the zero address.
184    * - `tokenId` token must be owned by `from`.
185    * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
186    *
187    * Emits a {Transfer} event.
188    */
189   function transferFrom(
190     address from,
191     address to,
192     uint256 tokenId
193   ) external;
194 
195   /**
196    * @dev Gives permission to `to` to transfer `tokenId` token to another account.
197    * The approval is cleared when the token is transferred.
198    *
199    * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
200    *
201    * Requirements:
202    *
203    * - The caller must own the token or be an approved operator.
204    * - `tokenId` must exist.
205    *
206    * Emits an {Approval} event.
207    */
208   function approve(address to, uint256 tokenId) external;
209 
210   /**
211    * @dev Approve or remove `operator` as an operator for the caller.
212    * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
213    *
214    * Requirements:
215    *
216    * - The `operator` cannot be the caller.
217    *
218    * Emits an {ApprovalForAll} event.
219    */
220   function setApprovalForAll(address operator, bool _approved) external;
221 
222   /**
223    * @dev Returns the account approved for `tokenId` token.
224    *
225    * Requirements:
226    *
227    * - `tokenId` must exist.
228    */
229   function getApproved(uint256 tokenId)
230     external
231     view
232     returns (address operator);
233 
234   /**
235    * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
236    *
237    * See {setApprovalForAll}
238    */
239   function isApprovedForAll(address owner, address operator)
240     external
241     view
242     returns (bool);
243 
244   // ==============================
245   //        IERC721Metadata
246   // ==============================
247   /**
248    * @dev Returns the token collection name.
249    */
250   function name() external view returns (string memory);
251 
252   /**
253    * @dev Returns the token collection symbol.
254    */
255   function symbol() external view returns (string memory);
256 
257   /**
258    * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
259    */
260   function tokenURI(uint256 tokenId) external view returns (string memory);
261 
262   // ==============================
263   //            IERC2309
264   // ==============================
265   /**
266    * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
267    * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
268    */
269   event ConsecutiveTransfer(
270     uint256 indexed fromTokenId,
271     uint256 toTokenId,
272     address indexed from,
273     address indexed to
274   );
275 }
276 
277 interface ERC721A__IERC721Receiver {
278   function onERC721Received(
279     address operator,
280     address from,
281     uint256 tokenId,
282     bytes calldata data
283   ) external returns (bytes4);
284 }
285 
286 /**
287  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
288  * including the Metadata extension. Built to optimize for lower gas during batch mints.
289  *
290  * Assumes serials are sequentially minted starting at `_startTokenId()`
291  * (defaults to 0, e.g. 0, 1, 2, 3..).
292  *
293  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
294  *
295  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
296  */
297 contract ERC721A is IERC721A {
298   // Mask of an entry in packed address data.
299   uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
300   // The bit position of `numberMinted` in packed address data.
301   uint256 private constant BITPOS_NUMBER_MINTED = 64;
302   // The bit position of `numberBurned` in packed address data.
303   uint256 private constant BITPOS_NUMBER_BURNED = 128;
304   // The bit position of `aux` in packed address data.
305   uint256 private constant BITPOS_AUX = 192;
306   // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
307   uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
308   // The bit position of `startTimestamp` in packed ownership.
309   uint256 private constant BITPOS_START_TIMESTAMP = 160;
310   // The bit mask of the `burned` bit in packed ownership.
311   uint256 private constant BITMASK_BURNED = 1 << 224;
312   // The bit position of the `nextInitialized` bit in packed ownership.
313   uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
314   // The bit mask of the `nextInitialized` bit in packed ownership.
315   uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
316   // The bit position of `extraData` in packed ownership.
317   uint256 private constant BITPOS_EXTRA_DATA = 232;
318   // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
319   uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
320   // The mask of the lower 160 bits for addresses.
321   uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
322   // The maximum `quantity` that can be minted with `_mintERC2309`.
323   // This limit is to prevent overflows on the address data entries.
324   // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
325   // is required to cause an overflow, which is unrealistic.
326   uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
327   // The tokenId of the next token to be minted.
328   uint256 private _currentIndex;
329   // The number of tokens burned.
330   uint256 private _burnCounter;
331   // Token name
332   string private _name;
333   // Token symbol
334   string private _symbol;
335   // Mapping from token ID to ownership details
336   // An empty struct value does not necessarily mean the token is unowned.
337   // See `_packedOwnershipOf` implementation for details.
338   //
339   // Bits Layout:
340   // - [0..159]   `addr`
341   // - [160..223] `startTimestamp`
342   // - [224]      `burned`
343   // - [225]      `nextInitialized`
344   // - [232..255] `extraData`
345   mapping(uint256 => uint256) private _packedOwnerships;
346   // Mapping owner address to address data.
347   //
348   // Bits Layout:
349   // - [0..63]    `balance`
350   // - [64..127]  `numberMinted`
351   // - [128..191] `numberBurned`
352   // - [192..255] `aux`
353   mapping(address => uint256) private _packedAddressData;
354   // Mapping from token ID to approved address.
355   mapping(uint256 => address) private _tokenApprovals;
356   // Mapping from owner to operator approvals
357   mapping(address => mapping(address => bool)) private _operatorApprovals;
358 
359   constructor(string memory name_, string memory symbol_) {
360     _name = name_;
361     _symbol = symbol_;
362     _currentIndex = _startTokenId();
363   }
364 
365   /**
366    * @dev Returns the starting token ID.
367    * To change the starting token ID, please override this function.
368    */
369   function _startTokenId() internal view virtual returns (uint256) {
370     return 0;
371   }
372 
373   /**
374    * @dev Returns the next token ID to be minted.
375    */
376   function _nextTokenId() internal view returns (uint256) {
377     return _currentIndex;
378   }
379 
380   /**
381    * @dev Returns the total number of tokens in existence.
382    * Burned tokens will reduce the count.
383    * To get the total number of tokens minted, please see `_totalMinted`.
384    */
385   function totalSupply() public view override returns (uint256) {
386     // Counter underflow is impossible as _burnCounter cannot be incremented
387     // more than `_currentIndex - _startTokenId()` times.
388     unchecked {
389       return _currentIndex - _burnCounter - _startTokenId();
390     }
391   }
392 
393   /**
394    * @dev Returns the total amount of tokens minted in the contract.
395    */
396   function _totalMinted() internal view returns (uint256) {
397     // Counter underflow is impossible as _currentIndex does not decrement,
398     // and it is initialized to `_startTokenId()`
399     unchecked {
400       return _currentIndex - _startTokenId();
401     }
402   }
403 
404   /**
405    * @dev Returns the total number of tokens burned.
406    */
407   function _totalBurned() internal view returns (uint256) {
408     return _burnCounter;
409   }
410 
411   /**
412    * @dev See {IERC165-supportsInterface}.
413    */
414   function supportsInterface(bytes4 interfaceId)
415     public
416     view
417     virtual
418     override
419     returns (bool)
420   {
421     // The interface IDs are constants representing the first 4 bytes of the XOR of
422     // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
423     // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
424     return
425       interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
426       interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
427       interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
428   }
429 
430   /**
431    * @dev See {IERC721-balanceOf}.
432    */
433   function balanceOf(address owner) public view override returns (uint256) {
434     if (owner == address(0)) revert BalanceQueryForZeroAddress();
435     return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
436   }
437 
438   /**
439    * Returns the number of tokens minted by `owner`.
440    */
441   function _numberMinted(address owner) internal view returns (uint256) {
442     return
443       (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) &
444       BITMASK_ADDRESS_DATA_ENTRY;
445   }
446 
447   /**
448    * Returns the number of tokens burned by or on behalf of `owner`.
449    */
450   function _numberBurned(address owner) internal view returns (uint256) {
451     return
452       (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) &
453       BITMASK_ADDRESS_DATA_ENTRY;
454   }
455 
456   /**
457    * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
458    */
459   function _getAux(address owner) internal view returns (uint64) {
460     return uint64(_packedAddressData[owner] >> BITPOS_AUX);
461   }
462 
463   /**
464    * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
465    * If there are multiple variables, please pack them into a uint64.
466    */
467   function _setAux(address owner, uint64 aux) internal {
468     uint256 packed = _packedAddressData[owner];
469     uint256 auxCasted;
470     // Cast `aux` with assembly to avoid redundant masking.
471     assembly {
472       auxCasted := aux
473     }
474     packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
475     _packedAddressData[owner] = packed;
476   }
477 
478   /**
479    * Returns the packed ownership data of `tokenId`.
480    */
481   function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
482     uint256 curr = tokenId;
483     unchecked {
484       if (_startTokenId() <= curr)
485         if (curr < _currentIndex) {
486           uint256 packed = _packedOwnerships[curr];
487           // If not burned.
488           if (packed & BITMASK_BURNED == 0) {
489             // Invariant:
490             // There will always be an ownership that has an address and is not burned
491             // before an ownership that does not have an address and is not burned.
492             // Hence, curr will not underflow.
493             //
494             // We can directly compare the packed value.
495             // If the address is zero, packed is zero.
496             while (packed == 0) {
497               packed = _packedOwnerships[--curr];
498             }
499             return packed;
500           }
501         }
502     }
503     revert OwnerQueryForNonexistentToken();
504   }
505 
506   /**
507    * Returns the unpacked `TokenOwnership` struct from `packed`.
508    */
509   function _unpackedOwnership(uint256 packed)
510     private
511     pure
512     returns (TokenOwnership memory ownership)
513   {
514     ownership.addr = address(uint160(packed));
515     ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
516     ownership.burned = packed & BITMASK_BURNED != 0;
517     ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
518   }
519 
520   /**
521    * Returns the unpacked `TokenOwnership` struct at `index`.
522    */
523   function _ownershipAt(uint256 index)
524     internal
525     view
526     returns (TokenOwnership memory)
527   {
528     return _unpackedOwnership(_packedOwnerships[index]);
529   }
530 
531   /**
532    * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
533    */
534   function _initializeOwnershipAt(uint256 index) internal {
535     if (_packedOwnerships[index] == 0) {
536       _packedOwnerships[index] = _packedOwnershipOf(index);
537     }
538   }
539 
540   /**
541    * Gas spent here starts off proportional to the maximum mint batch size.
542    * It gradually moves to O(1) as tokens get transferred around in the collection over time.
543    */
544   function _ownershipOf(uint256 tokenId)
545     internal
546     view
547     returns (TokenOwnership memory)
548   {
549     return _unpackedOwnership(_packedOwnershipOf(tokenId));
550   }
551 
552   /**
553    * @dev Packs ownership data into a single uint256.
554    */
555   function _packOwnershipData(address owner, uint256 flags)
556     private
557     view
558     returns (uint256 result)
559   {
560     assembly {
561       // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
562       owner := and(owner, BITMASK_ADDRESS)
563       // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
564       result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
565     }
566   }
567 
568   /**
569    * @dev See {IERC721-ownerOf}.
570    */
571   function ownerOf(uint256 tokenId) public view override returns (address) {
572     return address(uint160(_packedOwnershipOf(tokenId)));
573   }
574 
575   /**
576    * @dev See {IERC721Metadata-name}.
577    */
578   function name() public view virtual override returns (string memory) {
579     return _name;
580   }
581 
582   /**
583    * @dev See {IERC721Metadata-symbol}.
584    */
585   function symbol() public view virtual override returns (string memory) {
586     return _symbol;
587   }
588 
589   /**
590    * @dev See {IERC721Metadata-tokenURI}.
591    */
592   function tokenURI(uint256 tokenId)
593     public
594     view
595     virtual
596     override
597     returns (string memory)
598   {
599     if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
600     string memory baseURI = _baseURI();
601     return
602       bytes(baseURI).length != 0
603         ? string(abi.encodePacked(baseURI, _toString(tokenId)))
604         : "";
605   }
606 
607   /**
608    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
609    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
610    * by default, it can be overridden in child contracts.
611    */
612   function _baseURI() internal view virtual returns (string memory) {
613     return "";
614   }
615 
616   /**
617    * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
618    */
619   function _nextInitializedFlag(uint256 quantity)
620     private
621     pure
622     returns (uint256 result)
623   {
624     // For branchless setting of the `nextInitialized` flag.
625     assembly {
626       // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
627       result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
628     }
629   }
630 
631   /**
632    * @dev See {IERC721-approve}.
633    */
634   function approve(address to, uint256 tokenId) public override {
635     address owner = ownerOf(tokenId);
636     if (_msgSenderERC721A() != owner)
637       if (!isApprovedForAll(owner, _msgSenderERC721A())) {
638         revert ApprovalCallerNotOwnerNorApproved();
639       }
640     _tokenApprovals[tokenId] = to;
641     emit Approval(owner, to, tokenId);
642   }
643 
644   /**
645    * @dev See {IERC721-getApproved}.
646    */
647   function getApproved(uint256 tokenId) public view override returns (address) {
648     if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
649     return _tokenApprovals[tokenId];
650   }
651 
652   /**
653    * @dev See {IERC721-setApprovalForAll}.
654    */
655   function setApprovalForAll(address operator, bool approved)
656     public
657     virtual
658     override
659   {
660     if (operator == _msgSenderERC721A()) revert ApproveToCaller();
661     _operatorApprovals[_msgSenderERC721A()][operator] = approved;
662     emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
663   }
664 
665   /**
666    * @dev See {IERC721-isApprovedForAll}.
667    */
668   function isApprovedForAll(address owner, address operator)
669     public
670     view
671     virtual
672     override
673     returns (bool)
674   {
675     return _operatorApprovals[owner][operator];
676   }
677 
678   /**
679    * @dev See {IERC721-safeTransferFrom}.
680    */
681   function safeTransferFrom(
682     address from,
683     address to,
684     uint256 tokenId
685   ) public virtual override {
686     safeTransferFrom(from, to, tokenId, "");
687   }
688 
689   /**
690    * @dev See {IERC721-safeTransferFrom}.
691    */
692   function safeTransferFrom(
693     address from,
694     address to,
695     uint256 tokenId,
696     bytes memory _data
697   ) public virtual override {
698     transferFrom(from, to, tokenId);
699     if (to.code.length != 0)
700       if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
701         revert TransferToNonERC721ReceiverImplementer();
702       }
703   }
704 
705   /**
706    * @dev Returns whether `tokenId` exists.
707    *
708    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
709    *
710    * Tokens start existing when they are minted (`_mint`),
711    */
712   function _exists(uint256 tokenId) internal view returns (bool) {
713     return
714       _startTokenId() <= tokenId &&
715       tokenId < _currentIndex && // If within bounds,
716       _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
717   }
718 
719   /**
720    * @dev Equivalent to `_safeMint(to, quantity, '')`.
721    */
722   function _safeMint(address to, uint256 quantity) internal {
723     _safeMint(to, quantity, "");
724   }
725 
726   /**
727    * @dev Safely mints `quantity` tokens and transfers them to `to`.
728    *
729    * Requirements:
730    *
731    * - If `to` refers to a smart contract, it must implement
732    *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
733    * - `quantity` must be greater than 0.
734    *
735    * See {_mint}.
736    *
737    * Emits a {Transfer} event for each mint.
738    */
739   function _safeMint(
740     address to,
741     uint256 quantity,
742     bytes memory _data
743   ) internal {
744     _mint(to, quantity);
745     unchecked {
746       if (to.code.length != 0) {
747         uint256 end = _currentIndex;
748         uint256 index = end - quantity;
749         do {
750           if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
751             revert TransferToNonERC721ReceiverImplementer();
752           }
753         } while (index < end);
754         // Reentrancy protection.
755         if (_currentIndex != end) revert();
756       }
757     }
758   }
759 
760   /**
761    * @dev Mints `quantity` tokens and transfers them to `to`.
762    *
763    * Requirements:
764    *
765    * - `to` cannot be the zero address.
766    * - `quantity` must be greater than 0.
767    *
768    * Emits a {Transfer} event for each mint.
769    */
770   function _mint(address to, uint256 quantity) internal {
771     uint256 startTokenId = _currentIndex;
772     if (to == address(0)) revert MintToZeroAddress();
773     if (quantity == 0) revert MintZeroQuantity();
774     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
775     // Overflows are incredibly unrealistic.
776     // `balance` and `numberMinted` have a maximum limit of 2**64.
777     // `tokenId` has a maximum limit of 2**256.
778     unchecked {
779       // Updates:
780       // - `balance += quantity`.
781       // - `numberMinted += quantity`.
782       //
783       // We can directly add to the `balance` and `numberMinted`.
784       _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
785       // Updates:
786       // - `address` to the owner.
787       // - `startTimestamp` to the timestamp of minting.
788       // - `burned` to `false`.
789       // - `nextInitialized` to `quantity == 1`.
790       _packedOwnerships[startTokenId] = _packOwnershipData(
791         to,
792         _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
793       );
794       uint256 tokenId = startTokenId;
795       uint256 end = startTokenId + quantity;
796       do {
797         emit Transfer(address(0), to, tokenId++);
798       } while (tokenId < end);
799       _currentIndex = end;
800     }
801     _afterTokenTransfers(address(0), to, startTokenId, quantity);
802   }
803 
804   /**
805    * @dev Mints `quantity` tokens and transfers them to `to`.
806    *
807    * This function is intended for efficient minting only during contract creation.
808    *
809    * It emits only one {ConsecutiveTransfer} as defined in
810    * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
811    * instead of a sequence of {Transfer} event(s).
812    *
813    * Calling this function outside of contract creation WILL make your contract
814    * non-compliant with the ERC721 standard.
815    * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
816    * {ConsecutiveTransfer} event is only permissible during contract creation.
817    *
818    * Requirements:
819    *
820    * - `to` cannot be the zero address.
821    * - `quantity` must be greater than 0.
822    *
823    * Emits a {ConsecutiveTransfer} event.
824    */
825   function _mintERC2309(address to, uint256 quantity) internal {
826     uint256 startTokenId = _currentIndex;
827     if (to == address(0)) revert MintToZeroAddress();
828     if (quantity == 0) revert MintZeroQuantity();
829     if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT)
830       revert MintERC2309QuantityExceedsLimit();
831     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
832     // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
833     unchecked {
834       // Updates:
835       // - `balance += quantity`.
836       // - `numberMinted += quantity`.
837       //
838       // We can directly add to the `balance` and `numberMinted`.
839       _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
840       // Updates:
841       // - `address` to the owner.
842       // - `startTimestamp` to the timestamp of minting.
843       // - `burned` to `false`.
844       // - `nextInitialized` to `quantity == 1`.
845       _packedOwnerships[startTokenId] = _packOwnershipData(
846         to,
847         _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
848       );
849       emit ConsecutiveTransfer(
850         startTokenId,
851         startTokenId + quantity - 1,
852         address(0),
853         to
854       );
855       _currentIndex = startTokenId + quantity;
856     }
857     _afterTokenTransfers(address(0), to, startTokenId, quantity);
858   }
859 
860   /**
861    * @dev Returns the storage slot and value for the approved address of `tokenId`.
862    */
863   function _getApprovedAddress(uint256 tokenId)
864     private
865     view
866     returns (uint256 approvedAddressSlot, address approvedAddress)
867   {
868     mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
869     // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
870     assembly {
871       // Compute the slot.
872       mstore(0x00, tokenId)
873       mstore(0x20, tokenApprovalsPtr.slot)
874       approvedAddressSlot := keccak256(0x00, 0x40)
875       // Load the slot's value from storage.
876       approvedAddress := sload(approvedAddressSlot)
877     }
878   }
879 
880   /**
881    * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
882    */
883   function _isOwnerOrApproved(
884     address approvedAddress,
885     address from,
886     address msgSender
887   ) private pure returns (bool result) {
888     assembly {
889       // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
890       from := and(from, BITMASK_ADDRESS)
891       // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
892       msgSender := and(msgSender, BITMASK_ADDRESS)
893       // `msgSender == from || msgSender == approvedAddress`.
894       result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
895     }
896   }
897 
898   /**
899    * @dev Transfers `tokenId` from `from` to `to`.
900    *
901    * Requirements:
902    *
903    * - `to` cannot be the zero address.
904    * - `tokenId` token must be owned by `from`.
905    *
906    * Emits a {Transfer} event.
907    */
908   function transferFrom(
909     address from,
910     address to,
911     uint256 tokenId
912   ) public virtual override {
913     uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
914     if (address(uint160(prevOwnershipPacked)) != from)
915       revert TransferFromIncorrectOwner();
916     (
917       uint256 approvedAddressSlot,
918       address approvedAddress
919     ) = _getApprovedAddress(tokenId);
920     // The nested ifs save around 20+ gas over a compound boolean condition.
921     if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
922       if (!isApprovedForAll(from, _msgSenderERC721A()))
923         revert TransferCallerNotOwnerNorApproved();
924     if (to == address(0)) revert TransferToZeroAddress();
925     _beforeTokenTransfers(from, to, tokenId, 1);
926     // Clear approvals from the previous owner.
927     assembly {
928       if approvedAddress {
929         // This is equivalent to `delete _tokenApprovals[tokenId]`.
930         sstore(approvedAddressSlot, 0)
931       }
932     }
933     // Underflow of the sender's balance is impossible because we check for
934     // ownership above and the recipient's balance can't realistically overflow.
935     // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
936     unchecked {
937       // We can directly increment and decrement the balances.
938       --_packedAddressData[from]; // Updates: `balance -= 1`.
939       ++_packedAddressData[to]; // Updates: `balance += 1`.
940       // Updates:
941       // - `address` to the next owner.
942       // - `startTimestamp` to the timestamp of transfering.
943       // - `burned` to `false`.
944       // - `nextInitialized` to `true`.
945       _packedOwnerships[tokenId] = _packOwnershipData(
946         to,
947         BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
948       );
949       // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
950       if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
951         uint256 nextTokenId = tokenId + 1;
952         // If the next slot's address is zero and not burned (i.e. packed value is zero).
953         if (_packedOwnerships[nextTokenId] == 0) {
954           // If the next slot is within bounds.
955           if (nextTokenId != _currentIndex) {
956             // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
957             _packedOwnerships[nextTokenId] = prevOwnershipPacked;
958           }
959         }
960       }
961     }
962     emit Transfer(from, to, tokenId);
963     _afterTokenTransfers(from, to, tokenId, 1);
964   }
965 
966   /**
967    * @dev Equivalent to `_burn(tokenId, false)`.
968    */
969   function _burn(uint256 tokenId) internal virtual {
970     _burn(tokenId, false);
971   }
972 
973   /**
974    * @dev Destroys `tokenId`.
975    * The approval is cleared when the token is burned.
976    *
977    * Requirements:
978    *
979    * - `tokenId` must exist.
980    *
981    * Emits a {Transfer} event.
982    */
983   function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
984     uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
985     address from = address(uint160(prevOwnershipPacked));
986     (
987       uint256 approvedAddressSlot,
988       address approvedAddress
989     ) = _getApprovedAddress(tokenId);
990     if (approvalCheck) {
991       // The nested ifs save around 20+ gas over a compound boolean condition.
992       if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
993         if (!isApprovedForAll(from, _msgSenderERC721A()))
994           revert TransferCallerNotOwnerNorApproved();
995     }
996     _beforeTokenTransfers(from, address(0), tokenId, 1);
997     // Clear approvals from the previous owner.
998     assembly {
999       if approvedAddress {
1000         // This is equivalent to `delete _tokenApprovals[tokenId]`.
1001         sstore(approvedAddressSlot, 0)
1002       }
1003     }
1004     // Underflow of the sender's balance is impossible because we check for
1005     // ownership above and the recipient's balance can't realistically overflow.
1006     // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1007     unchecked {
1008       // Updates:
1009       // - `balance -= 1`.
1010       // - `numberBurned += 1`.
1011       //
1012       // We can directly decrement the balance, and increment the number burned.
1013       // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1014       _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1015       // Updates:
1016       // - `address` to the last owner.
1017       // - `startTimestamp` to the timestamp of burning.
1018       // - `burned` to `true`.
1019       // - `nextInitialized` to `true`.
1020       _packedOwnerships[tokenId] = _packOwnershipData(
1021         from,
1022         (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) |
1023           _nextExtraData(from, address(0), prevOwnershipPacked)
1024       );
1025       // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1026       if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1027         uint256 nextTokenId = tokenId + 1;
1028         // If the next slot's address is zero and not burned (i.e. packed value is zero).
1029         if (_packedOwnerships[nextTokenId] == 0) {
1030           // If the next slot is within bounds.
1031           if (nextTokenId != _currentIndex) {
1032             // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1033             _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1034           }
1035         }
1036       }
1037     }
1038     emit Transfer(from, address(0), tokenId);
1039     _afterTokenTransfers(from, address(0), tokenId, 1);
1040     // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1041     unchecked {
1042       _burnCounter++;
1043     }
1044   }
1045 
1046   /**
1047    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1048    *
1049    * @param from address representing the previous owner of the given token ID
1050    * @param to target address that will receive the tokens
1051    * @param tokenId uint256 ID of the token to be transferred
1052    * @param _data bytes optional data to send along with the call
1053    * @return bool whether the call correctly returned the expected magic value
1054    */
1055   function _checkContractOnERC721Received(
1056     address from,
1057     address to,
1058     uint256 tokenId,
1059     bytes memory _data
1060   ) private returns (bool) {
1061     try
1062       ERC721A__IERC721Receiver(to).onERC721Received(
1063         _msgSenderERC721A(),
1064         from,
1065         tokenId,
1066         _data
1067       )
1068     returns (bytes4 retval) {
1069       return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1070     } catch (bytes memory reason) {
1071       if (reason.length == 0) {
1072         revert TransferToNonERC721ReceiverImplementer();
1073       } else {
1074         assembly {
1075           revert(add(32, reason), mload(reason))
1076         }
1077       }
1078     }
1079   }
1080 
1081   /**
1082    * @dev Directly sets the extra data for the ownership data `index`.
1083    */
1084   function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1085     uint256 packed = _packedOwnerships[index];
1086     if (packed == 0) revert OwnershipNotInitializedForExtraData();
1087     uint256 extraDataCasted;
1088     // Cast `extraData` with assembly to avoid redundant masking.
1089     assembly {
1090       extraDataCasted := extraData
1091     }
1092     packed =
1093       (packed & BITMASK_EXTRA_DATA_COMPLEMENT) |
1094       (extraDataCasted << BITPOS_EXTRA_DATA);
1095     _packedOwnerships[index] = packed;
1096   }
1097 
1098   /**
1099    * @dev Returns the next extra data for the packed ownership data.
1100    * The returned result is shifted into position.
1101    */
1102   function _nextExtraData(
1103     address from,
1104     address to,
1105     uint256 prevOwnershipPacked
1106   ) private view returns (uint256) {
1107     uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1108     return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1109   }
1110 
1111   /**
1112    * @dev Called during each token transfer to set the 24bit `extraData` field.
1113    * Intended to be overridden by the cosumer contract.
1114    *
1115    * `previousExtraData` - the value of `extraData` before transfer.
1116    *
1117    * Calling conditions:
1118    *
1119    * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1120    * transferred to `to`.
1121    * - When `from` is zero, `tokenId` will be minted for `to`.
1122    * - When `to` is zero, `tokenId` will be burned by `from`.
1123    * - `from` and `to` are never both zero.
1124    */
1125   function _extraData(
1126     address from,
1127     address to,
1128     uint24 previousExtraData
1129   ) internal view virtual returns (uint24) {}
1130 
1131   /**
1132    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1133    * This includes minting.
1134    * And also called before burning one token.
1135    *
1136    * startTokenId - the first token id to be transferred
1137    * quantity - the amount to be transferred
1138    *
1139    * Calling conditions:
1140    *
1141    * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1142    * transferred to `to`.
1143    * - When `from` is zero, `tokenId` will be minted for `to`.
1144    * - When `to` is zero, `tokenId` will be burned by `from`.
1145    * - `from` and `to` are never both zero.
1146    */
1147   function _beforeTokenTransfers(
1148     address from,
1149     address to,
1150     uint256 startTokenId,
1151     uint256 quantity
1152   ) internal virtual {}
1153 
1154   /**
1155    * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1156    * This includes minting.
1157    * And also called after one token has been burned.
1158    *
1159    * startTokenId - the first token id to be transferred
1160    * quantity - the amount to be transferred
1161    *
1162    * Calling conditions:
1163    *
1164    * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1165    * transferred to `to`.
1166    * - When `from` is zero, `tokenId` has been minted for `to`.
1167    * - When `to` is zero, `tokenId` has been burned by `from`.
1168    * - `from` and `to` are never both zero.
1169    */
1170   function _afterTokenTransfers(
1171     address from,
1172     address to,
1173     uint256 startTokenId,
1174     uint256 quantity
1175   ) internal virtual {}
1176 
1177   /**
1178    * @dev Returns the message sender (defaults to `msg.sender`).
1179    *
1180    * If you are writing GSN compatible contracts, you need to override this function.
1181    */
1182   function _msgSenderERC721A() internal view virtual returns (address) {
1183     return msg.sender;
1184   }
1185 
1186   /**
1187    * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1188    */
1189   function _toString(uint256 value) internal pure returns (string memory ptr) {
1190     assembly {
1191       // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1192       // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1193       // We will need 1 32-byte word to store the length,
1194       // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1195       ptr := add(mload(0x40), 128)
1196       // Update the free memory pointer to allocate.
1197       mstore(0x40, ptr)
1198       // Cache the end of the memory to calculate the length later.
1199       let end := ptr
1200       // We write the string from the rightmost digit to the leftmost digit.
1201       // The following is essentially a do-while loop that also handles the zero case.
1202       // Costs a bit more than early returning for the zero case,
1203       // but cheaper in terms of deployment and overall runtime costs.
1204       for {
1205         // Initialize and perform the first pass without check.
1206         let temp := value
1207         // Move the pointer 1 byte leftwards to point to an empty character slot.
1208         ptr := sub(ptr, 1)
1209         // Write the character to the pointer. 48 is the ASCII index of '0'.
1210         mstore8(ptr, add(48, mod(temp, 10)))
1211         temp := div(temp, 10)
1212       } temp {
1213         // Keep dividing `temp` until zero.
1214         temp := div(temp, 10)
1215       } {
1216         // Body of the for loop.
1217         ptr := sub(ptr, 1)
1218         mstore8(ptr, add(48, mod(temp, 10)))
1219       }
1220       let length := sub(end, ptr)
1221       // Move the pointer 32 bytes leftwards to make room for the length.
1222       ptr := sub(ptr, 32)
1223       // Store the length.
1224       mstore(ptr, length)
1225     }
1226   }
1227 }
1228 
1229 /**
1230  * @title ERC721 token receiver interface
1231  * @dev Interface for any contract that wants to support safeTransfers
1232  * from ERC721 asset contracts.
1233  */
1234 interface IERC721Receiver {
1235   /**
1236    * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1237    * by `operator` from `from`, this function is called.
1238    *
1239    * It must return its Solidity selector to confirm the token transfer.
1240    * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1241    *
1242    * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1243    */
1244   function onERC721Received(
1245     address operator,
1246     address from,
1247     uint256 tokenId,
1248     bytes calldata data
1249   ) external returns (bytes4);
1250 }
1251 
1252 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1253 /**
1254  * @dev Provides information about the current execution context, including the
1255  * sender of the transaction and its data. While these are generally available
1256  * via msg.sender and msg.data, they should not be accessed in such a direct
1257  * manner, since when dealing with meta-transactions the account sending and
1258  * paying for execution may not be the actual sender (as far as an application
1259  * is concerned).
1260  *
1261  * This contract is only required for intermediate, library-like contracts.
1262  */
1263 abstract contract Context {
1264   function _msgSender() internal view virtual returns (address) {
1265     return msg.sender;
1266   }
1267 
1268   function _msgData() internal view virtual returns (bytes calldata) {
1269     return msg.data;
1270   }
1271 }
1272 
1273 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1274 /**
1275  * @dev Contract module which provides a basic access control mechanism, where
1276  * there is an account (an owner) that can be granted exclusive access to
1277  * specific functions.
1278  *
1279  * By default, the owner account will be the one that deploys the contract. This
1280  * can later be changed with {transferOwnership}.
1281  *
1282  * This module is used through inheritance. It will make available the modifier
1283  * `onlyOwner`, which can be applied to your functions to restrict their use to
1284  * the owner.
1285  */
1286 abstract contract Ownable is Context {
1287   address private _owner;
1288   event OwnershipTransferred(
1289     address indexed previousOwner,
1290     address indexed newOwner
1291   );
1292 
1293   /**
1294    * @dev Initializes the contract setting the deployer as the initial owner.
1295    */
1296   constructor() {
1297     _transferOwnership(_msgSender());
1298   }
1299 
1300   /**
1301    * @dev Returns the address of the current owner.
1302    */
1303   function owner() public view virtual returns (address) {
1304     return _owner;
1305   }
1306 
1307   /**
1308    * @dev Throws if called by any account other than the owner.
1309    */
1310   modifier onlyOwner() {
1311     require(owner() == _msgSender(), "Ownable: caller is not the owner");
1312     _;
1313   }
1314 
1315   /**
1316    * @dev Leaves the contract without owner. It will not be possible to call
1317    * `onlyOwner` functions anymore. Can only be called by the current owner.
1318    *
1319    * NOTE: Renouncing ownership will leave the contract without an owner,
1320    * thereby removing any functionality that is only available to the owner.
1321    */
1322   function renounceOwnership() public virtual onlyOwner {
1323     _transferOwnership(address(0));
1324   }
1325 
1326   /**
1327    * @dev Transfers ownership of the contract to a new account (`newOwner`).
1328    * Can only be called by the current owner.
1329    */
1330   function transferOwnership(address newOwner) public virtual onlyOwner {
1331     require(newOwner != address(0), "Ownable: new owner is the zero address");
1332     _transferOwnership(newOwner);
1333   }
1334 
1335   /**
1336    * @dev Transfers ownership of the contract to a new account (`newOwner`).
1337    * Internal function without access restriction.
1338    */
1339   function _transferOwnership(address newOwner) internal virtual {
1340     address oldOwner = _owner;
1341     _owner = newOwner;
1342     emit OwnershipTransferred(oldOwner, newOwner);
1343   }
1344 }
1345 
1346 /**
1347  * @dev String operations.
1348  */
1349 library Strings {
1350   bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1351 
1352   /**
1353    * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1354    */
1355   function toString(uint256 value) internal pure returns (string memory) {
1356     // Inspired by OraclizeAPI's implementation - MIT licence
1357     // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1358     if (value == 0) {
1359       return "0";
1360     }
1361     uint256 temp = value;
1362     uint256 digits;
1363     while (temp != 0) {
1364       digits++;
1365       temp /= 10;
1366     }
1367     bytes memory buffer = new bytes(digits);
1368     while (value != 0) {
1369       digits -= 1;
1370       buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1371       value /= 10;
1372     }
1373     return string(buffer);
1374   }
1375 
1376   /**
1377    * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1378    */
1379   function toHexString(uint256 value) internal pure returns (string memory) {
1380     if (value == 0) {
1381       return "0x00";
1382     }
1383     uint256 temp = value;
1384     uint256 length = 0;
1385     while (temp != 0) {
1386       length++;
1387       temp >>= 8;
1388     }
1389     return toHexString(value, length);
1390   }
1391 
1392   /**
1393    * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1394    */
1395   function toHexString(uint256 value, uint256 length)
1396     internal
1397     pure
1398     returns (string memory)
1399   {
1400     bytes memory buffer = new bytes(2 * length + 2);
1401     buffer[0] = "0";
1402     buffer[1] = "x";
1403     for (uint256 i = 2 * length + 1; i > 1; --i) {
1404       buffer[i] = _HEX_SYMBOLS[value & 0xf];
1405       value >>= 4;
1406     }
1407     require(value == 0, "Strings: hex length insufficient");
1408     return string(buffer);
1409   }
1410 }
1411 
1412 /**
1413  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1414  *
1415  * These functions can be used to verify that a message was signed by the holder
1416  * of the private keys of a given address.
1417  */
1418 library ECDSA {
1419   enum RecoverError {
1420     NoError,
1421     InvalidSignature,
1422     InvalidSignatureLength,
1423     InvalidSignatureS,
1424     InvalidSignatureV
1425   }
1426 
1427   function _throwError(RecoverError error) private pure {
1428     if (error == RecoverError.NoError) {
1429       return; // no error: do nothing
1430     } else if (error == RecoverError.InvalidSignature) {
1431       revert("ECDSA: invalid signature");
1432     } else if (error == RecoverError.InvalidSignatureLength) {
1433       revert("ECDSA: invalid signature length");
1434     } else if (error == RecoverError.InvalidSignatureS) {
1435       revert("ECDSA: invalid signature 's' value");
1436     } else if (error == RecoverError.InvalidSignatureV) {
1437       revert("ECDSA: invalid signature 'v' value");
1438     }
1439   }
1440 
1441   /**
1442    * @dev Returns the address that signed a hashed message (`hash`) with
1443    * `signature` or error string. This address can then be used for verification purposes.
1444    *
1445    * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1446    * this function rejects them by requiring the `s` value to be in the lower
1447    * half order, and the `v` value to be either 27 or 28.
1448    *
1449    * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1450    * verification to be secure: it is possible to craft signatures that
1451    * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1452    * this is by receiving a hash of the original message (which may otherwise
1453    * be too long), and then calling {toEthSignedMessageHash} on it.
1454    *
1455    * Documentation for signature generation:
1456    * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1457    * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1458    *
1459    * _Available since v4.3._
1460    */
1461   function tryRecover(bytes32 hash, bytes memory signature)
1462     internal
1463     pure
1464     returns (address, RecoverError)
1465   {
1466     // Check the signature length
1467     // - case 65: r,s,v signature (standard)
1468     // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
1469     if (signature.length == 65) {
1470       bytes32 r;
1471       bytes32 s;
1472       uint8 v;
1473       // ecrecover takes the signature parameters, and the only way to get them
1474       // currently is to use assembly.
1475       assembly {
1476         r := mload(add(signature, 0x20))
1477         s := mload(add(signature, 0x40))
1478         v := byte(0, mload(add(signature, 0x60)))
1479       }
1480       return tryRecover(hash, v, r, s);
1481     } else if (signature.length == 64) {
1482       bytes32 r;
1483       bytes32 vs;
1484       // ecrecover takes the signature parameters, and the only way to get them
1485       // currently is to use assembly.
1486       assembly {
1487         r := mload(add(signature, 0x20))
1488         vs := mload(add(signature, 0x40))
1489       }
1490       return tryRecover(hash, r, vs);
1491     } else {
1492       return (address(0), RecoverError.InvalidSignatureLength);
1493     }
1494   }
1495 
1496   /**
1497    * @dev Returns the address that signed a hashed message (`hash`) with
1498    * `signature`. This address can then be used for verification purposes.
1499    *
1500    * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1501    * this function rejects them by requiring the `s` value to be in the lower
1502    * half order, and the `v` value to be either 27 or 28.
1503    *
1504    * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1505    * verification to be secure: it is possible to craft signatures that
1506    * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1507    * this is by receiving a hash of the original message (which may otherwise
1508    * be too long), and then calling {toEthSignedMessageHash} on it.
1509    */
1510   function recover(bytes32 hash, bytes memory signature)
1511     internal
1512     pure
1513     returns (address)
1514   {
1515     (address recovered, RecoverError error) = tryRecover(hash, signature);
1516     _throwError(error);
1517     return recovered;
1518   }
1519 
1520   /**
1521    * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1522    *
1523    * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1524    *
1525    * _Available since v4.3._
1526    */
1527   function tryRecover(
1528     bytes32 hash,
1529     bytes32 r,
1530     bytes32 vs
1531   ) internal pure returns (address, RecoverError) {
1532     bytes32 s = vs &
1533       bytes32(
1534         0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
1535       );
1536     uint8 v = uint8((uint256(vs) >> 255) + 27);
1537     return tryRecover(hash, v, r, s);
1538   }
1539 
1540   /**
1541    * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1542    *
1543    * _Available since v4.2._
1544    */
1545   function recover(
1546     bytes32 hash,
1547     bytes32 r,
1548     bytes32 vs
1549   ) internal pure returns (address) {
1550     (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1551     _throwError(error);
1552     return recovered;
1553   }
1554 
1555   /**
1556    * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1557    * `r` and `s` signature fields separately.
1558    *
1559    * _Available since v4.3._
1560    */
1561   function tryRecover(
1562     bytes32 hash,
1563     uint8 v,
1564     bytes32 r,
1565     bytes32 s
1566   ) internal pure returns (address, RecoverError) {
1567     // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1568     // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1569     // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1570     // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1571     //
1572     // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1573     // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1574     // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1575     // these malleable signatures as well.
1576     if (
1577       uint256(s) >
1578       0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0
1579     ) {
1580       return (address(0), RecoverError.InvalidSignatureS);
1581     }
1582     if (v != 27 && v != 28) {
1583       return (address(0), RecoverError.InvalidSignatureV);
1584     }
1585     // If the signature is valid (and not malleable), return the signer address
1586     address signer = ecrecover(hash, v, r, s);
1587     if (signer == address(0)) {
1588       return (address(0), RecoverError.InvalidSignature);
1589     }
1590     return (signer, RecoverError.NoError);
1591   }
1592 
1593   /**
1594    * @dev Overload of {ECDSA-recover} that receives the `v`,
1595    * `r` and `s` signature fields separately.
1596    */
1597   function recover(
1598     bytes32 hash,
1599     uint8 v,
1600     bytes32 r,
1601     bytes32 s
1602   ) internal pure returns (address) {
1603     (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1604     _throwError(error);
1605     return recovered;
1606   }
1607 
1608   /**
1609    * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1610    * produces hash corresponding to the one signed with the
1611    * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1612    * JSON-RPC method as part of EIP-191.
1613    *
1614    * See {recover}.
1615    */
1616   function toEthSignedMessageHash(bytes32 hash)
1617     internal
1618     pure
1619     returns (bytes32)
1620   {
1621     // 32 is the length in bytes of hash,
1622     // enforced by the type signature above
1623     return
1624       keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1625   }
1626 
1627   /**
1628    * @dev Returns an Ethereum Signed Message, created from `s`. This
1629    * produces hash corresponding to the one signed with the
1630    * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1631    * JSON-RPC method as part of EIP-191.
1632    *
1633    * See {recover}.
1634    */
1635   function toEthSignedMessageHash(bytes memory s)
1636     internal
1637     pure
1638     returns (bytes32)
1639   {
1640     return
1641       keccak256(
1642         abi.encodePacked(
1643           "\x19Ethereum Signed Message:\n",
1644           Strings.toString(s.length),
1645           s
1646         )
1647       );
1648   }
1649 
1650   /**
1651    * @dev Returns an Ethereum Signed Typed Data, created from a
1652    * `domainSeparator` and a `structHash`. This produces hash corresponding
1653    * to the one signed with the
1654    * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1655    * JSON-RPC method as part of EIP-712.
1656    *
1657    * See {recover}.
1658    */
1659   function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash)
1660     internal
1661     pure
1662     returns (bytes32)
1663   {
1664     return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1665   }
1666 }
1667 
1668 /**
1669  * @dev Interface of the ERC165 standard, as defined in the
1670  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1671  *
1672  * Implementers can declare support of contract interfaces, which can then be
1673  * queried by others ({ERC165Checker}).
1674  *
1675  * For an implementation, see {ERC165}.
1676  */
1677 interface IERC165 {
1678   /**
1679    * @dev Returns true if this contract implements the interface defined by
1680    * `interfaceId`. See the corresponding
1681    * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1682    * to learn more about how these ids are created.
1683    *
1684    * This function call must use less than 30 000 gas.
1685    */
1686   function supportsInterface(bytes4 interfaceId) external view returns (bool);
1687 }
1688 
1689 /**
1690  * @dev Required interface of an ERC721 compliant contract.
1691  */
1692 interface IERC721 is IERC165 {
1693   /**
1694    * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1695    */
1696   event Transfer(
1697     address indexed from,
1698     address indexed to,
1699     uint256 indexed tokenId
1700   );
1701   /**
1702    * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1703    */
1704   event Approval(
1705     address indexed owner,
1706     address indexed approved,
1707     uint256 indexed tokenId
1708   );
1709   /**
1710    * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1711    */
1712   event ApprovalForAll(
1713     address indexed owner,
1714     address indexed operator,
1715     bool approved
1716   );
1717 
1718   /**
1719    * @dev Returns the number of tokens in ``owner``'s account.
1720    */
1721   function balanceOf(address owner) external view returns (uint256 balance);
1722 
1723   /**
1724    * @dev Returns the owner of the `tokenId` token.
1725    *
1726    * Requirements:
1727    *
1728    * - `tokenId` must exist.
1729    */
1730   function ownerOf(uint256 tokenId) external view returns (address owner);
1731 
1732   /**
1733    * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1734    * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1735    *
1736    * Requirements:
1737    *
1738    * - `from` cannot be the zero address.
1739    * - `to` cannot be the zero address.
1740    * - `tokenId` token must exist and be owned by `from`.
1741    * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1742    * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1743    *
1744    * Emits a {Transfer} event.
1745    */
1746   function safeTransferFrom(
1747     address from,
1748     address to,
1749     uint256 tokenId
1750   ) external;
1751 
1752   /**
1753    * @dev Transfers `tokenId` token from `from` to `to`.
1754    *
1755    * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1756    *
1757    * Requirements:
1758    *
1759    * - `from` cannot be the zero address.
1760    * - `to` cannot be the zero address.
1761    * - `tokenId` token must be owned by `from`.
1762    * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1763    *
1764    * Emits a {Transfer} event.
1765    */
1766   function transferFrom(
1767     address from,
1768     address to,
1769     uint256 tokenId
1770   ) external;
1771 
1772   /**
1773    * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1774    * The approval is cleared when the token is transferred.
1775    *
1776    * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1777    *
1778    * Requirements:
1779    *
1780    * - The caller must own the token or be an approved operator.
1781    * - `tokenId` must exist.
1782    *
1783    * Emits an {Approval} event.
1784    */
1785   function approve(address to, uint256 tokenId) external;
1786 
1787   /**
1788    * @dev Returns the account approved for `tokenId` token.
1789    *
1790    * Requirements:
1791    *
1792    * - `tokenId` must exist.
1793    */
1794   function getApproved(uint256 tokenId)
1795     external
1796     view
1797     returns (address operator);
1798 
1799   /**
1800    * @dev Approve or remove `operator` as an operator for the caller.
1801    * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1802    *
1803    * Requirements:
1804    *
1805    * - The `operator` cannot be the caller.
1806    *
1807    * Emits an {ApprovalForAll} event.
1808    */
1809   function setApprovalForAll(address operator, bool _approved) external;
1810 
1811   /**
1812    * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1813    *
1814    * See {setApprovalForAll}
1815    */
1816   function isApprovedForAll(address owner, address operator)
1817     external
1818     view
1819     returns (bool);
1820 
1821   /**
1822    * @dev Safely transfers `tokenId` token from `from` to `to`.
1823    *
1824    * Requirements:
1825    *
1826    * - `from` cannot be the zero address.
1827    * - `to` cannot be the zero address.
1828    * - `tokenId` token must exist and be owned by `from`.
1829    * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1830    * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1831    *
1832    * Emits a {Transfer} event.
1833    */
1834   function safeTransferFrom(
1835     address from,
1836     address to,
1837     uint256 tokenId,
1838     bytes calldata data
1839   ) external;
1840 }
1841 
1842 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
1843 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1844 /**
1845  * @dev Contract module that helps prevent reentrant calls to a function.
1846  *
1847  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1848  * available, which can be applied to functions to make sure there are no nested
1849  * (reentrant) calls to them.
1850  *
1851  * Note that because there is a single `nonReentrant` guard, functions marked as
1852  * `nonReentrant` may not call one another. This can be worked around by making
1853  * those functions `private`, and then adding `external` `nonReentrant` entry
1854  * points to them.
1855  *
1856  * TIP: If you would like to learn more about reentrancy and alternative ways
1857  * to protect against it, check out our blog post
1858  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1859  */
1860 abstract contract ReentrancyGuard {
1861   // Booleans are more expensive than uint256 or any type that takes up a full
1862   // word because each write operation emits an extra SLOAD to first read the
1863   // slot's contents, replace the bits taken up by the boolean, and then write
1864   // back. This is the compiler's defense against contract upgrades and
1865   // pointer aliasing, and it cannot be disabled.
1866   // The values being non-zero value makes deployment a bit more expensive,
1867   // but in exchange the refund on every call to nonReentrant will be lower in
1868   // amount. Since refunds are capped to a percentage of the total
1869   // transaction's gas, it is best to keep them low in cases like this one, to
1870   // increase the likelihood of the full refund coming into effect.
1871   uint256 private constant _NOT_ENTERED = 1;
1872   uint256 private constant _ENTERED = 2;
1873   uint256 private _status;
1874 
1875   constructor() {
1876     _status = _NOT_ENTERED;
1877   }
1878 
1879   /**
1880    * @dev Prevents a contract from calling itself, directly or indirectly.
1881    * Calling a `nonReentrant` function from another `nonReentrant`
1882    * function is not supported. It is possible to prevent this from happening
1883    * by making the `nonReentrant` function external, and making it call a
1884    * `private` function that does the actual work.
1885    */
1886   modifier nonReentrant() {
1887     // On the first call to nonReentrant, _notEntered will be true
1888     require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1889     // Any calls to nonReentrant after this point will fail
1890     _status = _ENTERED;
1891     _;
1892     // By storing the original value once again, a refund is triggered (see
1893     // https://eips.ethereum.org/EIPS/eip-2200)
1894     _status = _NOT_ENTERED;
1895   }
1896 }
1897 
1898 /*
1899 ╦═╗┌─┐┌─┐┬ ┬┬─┐┬─┐┌─┐┌─┐┌┬┐┬┌─┐┌┐┌
1900 ╠╦╝├┤ └─┐│ │├┬┘├┬┘├┤ │   │ ││ ││││
1901 ╩╚═└─┘└─┘└─┘┴└─┴└─└─┘└─┘ ┴ ┴└─┘┘└┘
1902 by Coniun
1903 @creator:     ConiunIO
1904 @security:    batuhan@coniun.io
1905 @author:      Batuhan KATIRCI (@batuhan_katirci)
1906 @website:     https://coniun.io/
1907 */
1908 error InvalidSignature(string message);
1909 struct CallDataInfo {
1910   uint256 _tokenId;
1911   address _contractAddress;
1912   uint256 _amount;
1913   uint256 _backendMintStage;
1914   bytes _signature;
1915 }
1916 
1917 contract ResurrectionByConiunV2 is
1918   ERC721A,
1919   IERC721Receiver,
1920   Ownable,
1921   ReentrancyGuard
1922 {
1923   event NftMinted(
1924     address indexed contractAddress,
1925     address indexed minterAddress,
1926     uint256 amount,
1927     uint256 mintStartFrom,
1928     uint256 sourceTokenId
1929   );
1930   using ECDSA for bytes32;
1931   string public TOKEN_BASE_URL =
1932     "https://temp-cdn.coniun.io/resurrection_metadata/mainnet/";
1933   string public TOKEN_URL_SUFFIX = ".json";
1934   // 0 -> paused
1935   // 1 -> whitelist
1936   // 2 -> public
1937   uint256 public MAX_SUPPLY = 4444;
1938   uint256 public MINT_STAGE = 0;
1939   uint256 public WALLET_TRANSFER_LIMIT = 2;
1940   address private _signerAddress;
1941   address private _vaultAddress;
1942   address private _editor;
1943 
1944   constructor(address signerAddress_, address vaultAddress_)
1945     ERC721A("RESURRECTION", "RES")
1946   {
1947     _signerAddress = signerAddress_;
1948     _vaultAddress = vaultAddress_;
1949   }
1950 
1951   function getTransferCount(address wallet)
1952     public
1953     view
1954     virtual
1955     returns (uint256)
1956   {
1957     return _getAux(wallet);
1958   }
1959 
1960   function _baseURI() internal view virtual override returns (string memory) {
1961     return TOKEN_BASE_URL;
1962   }
1963 
1964   function _suffix() internal view virtual returns (string memory) {
1965     return TOKEN_URL_SUFFIX;
1966   }
1967 
1968   function tokenURI(uint256 tokenId)
1969     public
1970     view
1971     virtual
1972     override
1973     returns (string memory)
1974   {
1975     if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1976     string memory baseURI = _baseURI();
1977     string memory suffix = _suffix();
1978     return
1979       bytes(baseURI).length != 0
1980         ? string(abi.encodePacked(baseURI, _toString(tokenId), suffix))
1981         : "";
1982   }
1983 
1984   // admin functions
1985   function setTokenBaseUrl(string memory _tokenBaseUrl) public editorOrOwner {
1986     TOKEN_BASE_URL = _tokenBaseUrl;
1987   }
1988 
1989   function setTokenSuffix(string memory _tokenUrlSuffix) public editorOrOwner {
1990     TOKEN_URL_SUFFIX = _tokenUrlSuffix;
1991   }
1992 
1993   function setAuxAdmin(address forAddress, uint64 value) public editorOrOwner {
1994     _setAux(forAddress, value);
1995   }
1996 
1997   function adminMint(uint256 quantity, address toAddress)
1998     external
1999     editorOrOwner
2000   {
2001     require(totalSupply() + quantity <= MAX_SUPPLY, "max_supply_reached");
2002     _safeMint(toAddress, quantity);
2003   }
2004 
2005   function setSignerAddress(address signerAddress) public editorOrOwner {
2006     _signerAddress = signerAddress;
2007   }
2008 
2009   function setMintStage(uint256 _mintStage) public editorOrOwner {
2010     MINT_STAGE = _mintStage;
2011   }
2012 
2013   function setWalletTransferLimit(uint256 _walletTransferLimit)
2014     public
2015     editorOrOwner
2016   {
2017     WALLET_TRANSFER_LIMIT = _walletTransferLimit;
2018   }
2019 
2020   function setEditor(address editor) public onlyOwner {
2021     _editor = editor;
2022   }
2023 
2024   modifier editorOrOwner() {
2025     require(
2026       _editor == _msgSender() || owner() == _msgSender(),
2027       "Editor or Owner required"
2028     );
2029     _;
2030   }
2031 
2032   // signature releated functions
2033   function getMessageHash(
2034     uint256 _amount,
2035     uint256 _tokenId,
2036     uint256 _backendMintStage,
2037     address _contractAddress
2038   ) internal pure returns (bytes32) {
2039     return
2040       keccak256(
2041         abi.encodePacked(_amount, _tokenId, _backendMintStage, _contractAddress)
2042       );
2043   }
2044 
2045   function getEthSignedMessageHash(bytes32 _messageHash)
2046     private
2047     pure
2048     returns (bytes32)
2049   {
2050     return
2051       keccak256(
2052         abi.encodePacked("\x19Ethereum Signed Message:\n32", _messageHash)
2053       );
2054   }
2055 
2056   function verifySignature(
2057     uint256 _amount,
2058     uint256 _tokenId,
2059     uint256 _backendMintStage,
2060     address _contractAddress,
2061     bytes memory signature
2062   ) private view returns (bool) {
2063     bytes32 messageHash = getMessageHash(
2064       _amount,
2065       _tokenId,
2066       _backendMintStage,
2067       _contractAddress
2068     );
2069     bytes32 ethSignedMessageHash = getEthSignedMessageHash(messageHash);
2070     return recoverSigner(ethSignedMessageHash, signature) == _signerAddress;
2071   }
2072 
2073   function recoverSigner(bytes32 _ethSignedMessageHash, bytes memory _signature)
2074     private
2075     pure
2076     returns (address)
2077   {
2078     (bytes32 r, bytes32 s, uint8 v) = splitSignature(_signature);
2079     return ecrecover(_ethSignedMessageHash, v, r, s);
2080   }
2081 
2082   function splitSignature(bytes memory sig)
2083     private
2084     pure
2085     returns (
2086       bytes32 r,
2087       bytes32 s,
2088       uint8 v
2089     )
2090   {
2091     if (sig.length != 65) {
2092       revert InvalidSignature("Signature length is not 65 bytes");
2093     }
2094     assembly {
2095       r := mload(add(sig, 32))
2096       s := mload(add(sig, 64))
2097       v := byte(0, mload(add(sig, 96)))
2098     }
2099   }
2100 
2101   function dataToBytes(
2102     uint256 tokenId,
2103     uint256 amount,
2104     uint256 backendMintStage,
2105     address contractAddress,
2106     bytes memory signature
2107   ) public pure returns (bytes memory result) {
2108     result = abi.encode(
2109       tokenId,
2110       amount,
2111       backendMintStage,
2112       contractAddress,
2113       signature
2114     );
2115   }
2116 
2117   function bytesToData(bytes memory source)
2118     public
2119     pure
2120     returns (
2121       uint256 tokenId,
2122       uint256 amount,
2123       uint256 backendMintStage,
2124       address contractAddress,
2125       bytes memory signature
2126     )
2127   {
2128     return abi.decode(source, (uint256, uint256, uint256, address, bytes));
2129   }
2130 
2131   // # 'Mint by Transfer' function
2132   // At here we are using IERC721 safeTransferFroom hook
2133   // and utilize a mint action
2134   // Our backend will create a payload for minting (how many, is eligible etc.)
2135   function onERC721Received(
2136     address,
2137     address from,
2138     uint256 tokenId,
2139     bytes calldata data
2140   ) external nonReentrant returns (bytes4) {
2141     if (msg.sender == tx.origin) {
2142       revert("only_from_contracts");
2143     }
2144     // Verify ownership of the token
2145     IERC721 proxy = IERC721(msg.sender);
2146     require(proxy.ownerOf(tokenId) == address(this), "nft_not_transferred");
2147     CallDataInfo memory callDataInfo;
2148     (
2149       callDataInfo._tokenId,
2150       callDataInfo._amount,
2151       callDataInfo._backendMintStage,
2152       callDataInfo._contractAddress,
2153       callDataInfo._signature
2154     ) = bytesToData(data);
2155     require(
2156       totalSupply() + callDataInfo._amount <= MAX_SUPPLY,
2157       "max_supply_reached"
2158     );
2159     if (
2160       callDataInfo._tokenId != tokenId ||
2161       callDataInfo._contractAddress != msg.sender
2162     ) {
2163       revert("calldata_mismatch");
2164     }
2165     require(
2166       callDataInfo._backendMintStage == MINT_STAGE,
2167       "mint_stage_mismatch"
2168     );
2169     require(_getAux(from) < WALLET_TRANSFER_LIMIT, "too_many_transfers");
2170     if (
2171       verifySignature(
2172         callDataInfo._amount,
2173         callDataInfo._tokenId,
2174         callDataInfo._backendMintStage,
2175         callDataInfo._contractAddress,
2176         callDataInfo._signature
2177       ) != true
2178     ) {
2179       revert InvalidSignature("signature_failed");
2180     }
2181     proxy.transferFrom(address(this), _vaultAddress, tokenId);
2182     emit NftMinted(
2183       callDataInfo._contractAddress, // contract
2184       from, // minter
2185       callDataInfo._amount, // amount
2186       _nextTokenId(), // currentIdx
2187       tokenId // usedTokenId
2188     );
2189     _mint(from, callDataInfo._amount);
2190     _setAux(from, _getAux(from) + 1);
2191     return IERC721Receiver.onERC721Received.selector;
2192   }
2193 }