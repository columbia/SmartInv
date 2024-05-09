1 // ERC721A Contracts v4.0.0
2 // Creator: Chiru Labs
3 
4 pragma solidity ^0.8.4;
5 
6 /**
7  * @dev Interface of an ERC721A compliant contract.
8  */
9 interface IERC721A {
10     /**
11      * The caller must own the token or be an approved operator.
12      */
13     error ApprovalCallerNotOwnerNorApproved();
14 
15     /**
16      * The token does not exist.
17      */
18     error ApprovalQueryForNonexistentToken();
19 
20     /**
21      * The caller cannot approve to their own address.
22      */
23     error ApproveToCaller();
24 
25     /**
26      * The caller cannot approve to the current owner.
27      */
28     error ApprovalToCurrentOwner();
29 
30     /**
31      * Cannot query the balance for the zero address.
32      */
33     error BalanceQueryForZeroAddress();
34 
35     /**
36      * Cannot mint to the zero address.
37      */
38     error MintToZeroAddress();
39 
40     /**
41      * The quantity of tokens minted must be more than zero.
42      */
43     error MintZeroQuantity();
44 
45     /**
46      * The token does not exist.
47      */
48     error OwnerQueryForNonexistentToken();
49 
50     /**
51      * The caller must own the token or be an approved operator.
52      */
53     error TransferCallerNotOwnerNorApproved();
54 
55     /**
56      * The token must be owned by `from`.
57      */
58     error TransferFromIncorrectOwner();
59 
60     /**
61      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
62      */
63     error TransferToNonERC721ReceiverImplementer();
64 
65     /**
66      * Cannot transfer to the zero address.
67      */
68     error TransferToZeroAddress();
69 
70     /**
71      * The token does not exist.
72      */
73     error URIQueryForNonexistentToken();
74 
75     struct TokenOwnership {
76         // The address of the owner.
77         address addr;
78         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
79         uint64 startTimestamp;
80         // Whether the token has been burned.
81         bool burned;
82     }
83 
84     /**
85      * @dev Returns the total amount of tokens stored by the contract.
86      *
87      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
88      */
89     function totalSupply() external view returns (uint256);
90 
91     // ==============================
92     //            IERC165
93     // ==============================
94 
95     /**
96      * @dev Returns true if this contract implements the interface defined by
97      * `interfaceId`. See the corresponding
98      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
99      * to learn more about how these ids are created.
100      *
101      * This function call must use less than 30 000 gas.
102      */
103     function supportsInterface(bytes4 interfaceId) external view returns (bool);
104 
105     // ==============================
106     //            IERC721
107     // ==============================
108 
109     /**
110      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
111      */
112     event Transfer(
113         address indexed from,
114         address indexed to,
115         uint256 indexed tokenId
116     );
117 
118     /**
119      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
120      */
121     event Approval(
122         address indexed owner,
123         address indexed approved,
124         uint256 indexed tokenId
125     );
126 
127     /**
128      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
129      */
130     event ApprovalForAll(
131         address indexed owner,
132         address indexed operator,
133         bool approved
134     );
135 
136     /**
137      * @dev Returns the number of tokens in ``owner``'s account.
138      */
139     function balanceOf(address owner) external view returns (uint256 balance);
140 
141     /**
142      * @dev Returns the owner of the `tokenId` token.
143      *
144      * Requirements:
145      *
146      * - `tokenId` must exist.
147      */
148     function ownerOf(uint256 tokenId) external view returns (address owner);
149 
150     /**
151      * @dev Safely transfers `tokenId` token from `from` to `to`.
152      *
153      * Requirements:
154      *
155      * - `from` cannot be the zero address.
156      * - `to` cannot be the zero address.
157      * - `tokenId` token must exist and be owned by `from`.
158      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
159      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
160      *
161      * Emits a {Transfer} event.
162      */
163     function safeTransferFrom(
164         address from,
165         address to,
166         uint256 tokenId,
167         bytes calldata data
168     ) external;
169 
170     /**
171      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
172      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
173      *
174      * Requirements:
175      *
176      * - `from` cannot be the zero address.
177      * - `to` cannot be the zero address.
178      * - `tokenId` token must exist and be owned by `from`.
179      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
180      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
181      *
182      * Emits a {Transfer} event.
183      */
184     function safeTransferFrom(
185         address from,
186         address to,
187         uint256 tokenId
188     ) external;
189 
190     /**
191      * @dev Transfers `tokenId` token from `from` to `to`.
192      *
193      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
194      *
195      * Requirements:
196      *
197      * - `from` cannot be the zero address.
198      * - `to` cannot be the zero address.
199      * - `tokenId` token must be owned by `from`.
200      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
201      *
202      * Emits a {Transfer} event.
203      */
204     function transferFrom(
205         address from,
206         address to,
207         uint256 tokenId
208     ) external;
209 
210     /**
211      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
212      * The approval is cleared when the token is transferred.
213      *
214      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
215      *
216      * Requirements:
217      *
218      * - The caller must own the token or be an approved operator.
219      * - `tokenId` must exist.
220      *
221      * Emits an {Approval} event.
222      */
223     function approve(address to, uint256 tokenId) external;
224 
225     /**
226      * @dev Approve or remove `operator` as an operator for the caller.
227      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
228      *
229      * Requirements:
230      *
231      * - The `operator` cannot be the caller.
232      *
233      * Emits an {ApprovalForAll} event.
234      */
235     function setApprovalForAll(address operator, bool _approved) external;
236 
237     /**
238      * @dev Returns the account approved for `tokenId` token.
239      *
240      * Requirements:
241      *
242      * - `tokenId` must exist.
243      */
244     function getApproved(uint256 tokenId)
245         external
246         view
247         returns (address operator);
248 
249     /**
250      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
251      *
252      * See {setApprovalForAll}
253      */
254     function isApprovedForAll(address owner, address operator)
255         external
256         view
257         returns (bool);
258 
259     // ==============================
260     //        IERC721Metadata
261     // ==============================
262 
263     /**
264      * @dev Returns the token collection name.
265      */
266     function name() external view returns (string memory);
267 
268     /**
269      * @dev Returns the token collection symbol.
270      */
271     function symbol() external view returns (string memory);
272 
273     /**
274      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
275      */
276     function tokenURI(uint256 tokenId) external view returns (string memory);
277 }
278 
279 // File: erc721a/contracts/ERC721A.sol
280 
281 // ERC721A Contracts v4.0.0
282 // Creator: Chiru Labs
283 
284 pragma solidity ^0.8.4;
285 
286 /**
287  * @dev ERC721 token receiver interface.
288  */
289 interface ERC721A__IERC721Receiver {
290     function onERC721Received(
291         address operator,
292         address from,
293         uint256 tokenId,
294         bytes calldata data
295     ) external returns (bytes4);
296 }
297 
298 /**
299  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
300  * the Metadata extension. Built to optimize for lower gas during batch mints.
301  *
302  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
303  *
304  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
305  *
306  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
307  */
308 contract ERC721A is IERC721A {
309     // Mask of an entry in packed address data.
310     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
311 
312     // The bit position of `numberMinted` in packed address data.
313     uint256 private constant BITPOS_NUMBER_MINTED = 64;
314 
315     // The bit position of `numberBurned` in packed address data.
316     uint256 private constant BITPOS_NUMBER_BURNED = 128;
317 
318     // The bit position of `aux` in packed address data.
319     uint256 private constant BITPOS_AUX = 192;
320 
321     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
322     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
323 
324     // The bit position of `startTimestamp` in packed ownership.
325     uint256 private constant BITPOS_START_TIMESTAMP = 160;
326 
327     // The bit mask of the `burned` bit in packed ownership.
328     uint256 private constant BITMASK_BURNED = 1 << 224;
329 
330     // The bit position of the `nextInitialized` bit in packed ownership.
331     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
332 
333     // The bit mask of the `nextInitialized` bit in packed ownership.
334     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
335 
336     // The tokenId of the next token to be minted.
337     uint256 private _currentIndex;
338 
339     // The number of tokens burned.
340     uint256 private _burnCounter;
341 
342     // Token name
343     string private _name;
344 
345     // Token symbol
346     string private _symbol;
347 
348     // Mapping from token ID to ownership details
349     // An empty struct value does not necessarily mean the token is unowned.
350     // See `_packedOwnershipOf` implementation for details.
351     //
352     // Bits Layout:
353     // - [0..159]   `addr`
354     // - [160..223] `startTimestamp`
355     // - [224]      `burned`
356     // - [225]      `nextInitialized`
357     mapping(uint256 => uint256) private _packedOwnerships;
358 
359     // Mapping owner address to address data.
360     //
361     // Bits Layout:
362     // - [0..63]    `balance`
363     // - [64..127]  `numberMinted`
364     // - [128..191] `numberBurned`
365     // - [192..255] `aux`
366     mapping(address => uint256) private _packedAddressData;
367 
368     // Mapping from token ID to approved address.
369     mapping(uint256 => address) private _tokenApprovals;
370 
371     // Mapping from owner to operator approvals
372     mapping(address => mapping(address => bool)) private _operatorApprovals;
373 
374     constructor(string memory name_, string memory symbol_) {
375         _name = name_;
376         _symbol = symbol_;
377         _currentIndex = _startTokenId();
378     }
379 
380     /**
381      * @dev Returns the starting token ID.
382      * To change the starting token ID, please override this function.
383      */
384     function _startTokenId() internal view virtual returns (uint256) {
385         return 0;
386     }
387 
388     /**
389      * @dev Returns the next token ID to be minted.
390      */
391     function _nextTokenId() internal view returns (uint256) {
392         return _currentIndex;
393     }
394 
395     /**
396      * @dev Returns the total number of tokens in existence.
397      * Burned tokens will reduce the count.
398      * To get the total number of tokens minted, please see `_totalMinted`.
399      */
400     function totalSupply() public view override returns (uint256) {
401         // Counter underflow is impossible as _burnCounter cannot be incremented
402         // more than `_currentIndex - _startTokenId()` times.
403         unchecked {
404             return _currentIndex - _burnCounter - _startTokenId();
405         }
406     }
407 
408     /**
409      * @dev Returns the total amount of tokens minted in the contract.
410      */
411     function _totalMinted() internal view returns (uint256) {
412         // Counter underflow is impossible as _currentIndex does not decrement,
413         // and it is initialized to `_startTokenId()`
414         unchecked {
415             return _currentIndex - _startTokenId();
416         }
417     }
418 
419     /**
420      * @dev Returns the total number of tokens burned.
421      */
422     function _totalBurned() internal view returns (uint256) {
423         return _burnCounter;
424     }
425 
426     /**
427      * @dev See {IERC165-supportsInterface}.
428      */
429     function supportsInterface(bytes4 interfaceId)
430         public
431         view
432         virtual
433         override
434         returns (bool)
435     {
436         // The interface IDs are constants representing the first 4 bytes of the XOR of
437         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
438         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
439         return
440             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
441             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
442             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
443     }
444 
445     /**
446      * @dev See {IERC721-balanceOf}.
447      */
448     function balanceOf(address owner) public view override returns (uint256) {
449         if (owner == address(0)) revert BalanceQueryForZeroAddress();
450         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
451     }
452 
453     /**
454      * Returns the number of tokens minted by `owner`.
455      */
456     function _numberMinted(address owner) internal view returns (uint256) {
457         return
458             (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) &
459             BITMASK_ADDRESS_DATA_ENTRY;
460     }
461 
462     /**
463      * Returns the number of tokens burned by or on behalf of `owner`.
464      */
465     function _numberBurned(address owner) internal view returns (uint256) {
466         return
467             (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) &
468             BITMASK_ADDRESS_DATA_ENTRY;
469     }
470 
471     /**
472      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
473      */
474     function _getAux(address owner) internal view returns (uint64) {
475         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
476     }
477 
478     /**
479      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
480      * If there are multiple variables, please pack them into a uint64.
481      */
482     function _setAux(address owner, uint64 aux) internal {
483         uint256 packed = _packedAddressData[owner];
484         uint256 auxCasted;
485         assembly {
486             // Cast aux without masking.
487             auxCasted := aux
488         }
489         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
490         _packedAddressData[owner] = packed;
491     }
492 
493     /**
494      * Returns the packed ownership data of `tokenId`.
495      */
496     function _packedOwnershipOf(uint256 tokenId)
497         private
498         view
499         returns (uint256)
500     {
501         uint256 curr = tokenId;
502 
503         unchecked {
504             if (_startTokenId() <= curr)
505                 if (curr < _currentIndex) {
506                     uint256 packed = _packedOwnerships[curr];
507                     // If not burned.
508                     if (packed & BITMASK_BURNED == 0) {
509                         // Invariant:
510                         // There will always be an ownership that has an address and is not burned
511                         // before an ownership that does not have an address and is not burned.
512                         // Hence, curr will not underflow.
513                         //
514                         // We can directly compare the packed value.
515                         // If the address is zero, packed is zero.
516                         while (packed == 0) {
517                             packed = _packedOwnerships[--curr];
518                         }
519                         return packed;
520                     }
521                 }
522         }
523         revert OwnerQueryForNonexistentToken();
524     }
525 
526     /**
527      * Returns the unpacked `TokenOwnership` struct from `packed`.
528      */
529     function _unpackedOwnership(uint256 packed)
530         private
531         pure
532         returns (TokenOwnership memory ownership)
533     {
534         ownership.addr = address(uint160(packed));
535         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
536         ownership.burned = packed & BITMASK_BURNED != 0;
537     }
538 
539     /**
540      * Returns the unpacked `TokenOwnership` struct at `index`.
541      */
542     function _ownershipAt(uint256 index)
543         internal
544         view
545         returns (TokenOwnership memory)
546     {
547         return _unpackedOwnership(_packedOwnerships[index]);
548     }
549 
550     /**
551      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
552      */
553     function _initializeOwnershipAt(uint256 index) internal {
554         if (_packedOwnerships[index] == 0) {
555             _packedOwnerships[index] = _packedOwnershipOf(index);
556         }
557     }
558 
559     /**
560      * Gas spent here starts off proportional to the maximum mint batch size.
561      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
562      */
563     function _ownershipOf(uint256 tokenId)
564         internal
565         view
566         returns (TokenOwnership memory)
567     {
568         return _unpackedOwnership(_packedOwnershipOf(tokenId));
569     }
570 
571     /**
572      * @dev See {IERC721-ownerOf}.
573      */
574     function ownerOf(uint256 tokenId) public view override returns (address) {
575         return address(uint160(_packedOwnershipOf(tokenId)));
576     }
577 
578     /**
579      * @dev See {IERC721Metadata-name}.
580      */
581     function name() public view virtual override returns (string memory) {
582         return _name;
583     }
584 
585     /**
586      * @dev See {IERC721Metadata-symbol}.
587      */
588     function symbol() public view virtual override returns (string memory) {
589         return _symbol;
590     }
591 
592     /**
593      * @dev See {IERC721Metadata-tokenURI}.
594      */
595     function tokenURI(uint256 tokenId)
596         public
597         view
598         virtual
599         override
600         returns (string memory)
601     {
602         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
603 
604         string memory baseURI = _baseURI();
605         return
606             bytes(baseURI).length != 0
607                 ? string(abi.encodePacked(baseURI, _toString(tokenId)))
608                 : "";
609     }
610 
611     /**
612      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
613      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
614      * by default, can be overriden in child contracts.
615      */
616     function _baseURI() internal view virtual returns (string memory) {
617         return "";
618     }
619 
620     /**
621      * @dev Casts the address to uint256 without masking.
622      */
623     function _addressToUint256(address value)
624         private
625         pure
626         returns (uint256 result)
627     {
628         assembly {
629             result := value
630         }
631     }
632 
633     /**
634      * @dev Casts the boolean to uint256 without branching.
635      */
636     function _boolToUint256(bool value) private pure returns (uint256 result) {
637         assembly {
638             result := value
639         }
640     }
641 
642     /**
643      * @dev See {IERC721-approve}.
644      */
645     function approve(address to, uint256 tokenId) public override {
646         address owner = address(uint160(_packedOwnershipOf(tokenId)));
647         if (to == owner) revert ApprovalToCurrentOwner();
648 
649         if (_msgSenderERC721A() != owner)
650             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
651                 revert ApprovalCallerNotOwnerNorApproved();
652             }
653 
654         _tokenApprovals[tokenId] = to;
655         emit Approval(owner, to, tokenId);
656     }
657 
658     /**
659      * @dev See {IERC721-getApproved}.
660      */
661     function getApproved(uint256 tokenId)
662         public
663         view
664         override
665         returns (address)
666     {
667         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
668 
669         return _tokenApprovals[tokenId];
670     }
671 
672     /**
673      * @dev See {IERC721-setApprovalForAll}.
674      */
675     function setApprovalForAll(address operator, bool approved)
676         public
677         virtual
678         override
679     {
680         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
681 
682         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
683         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
684     }
685 
686     /**
687      * @dev See {IERC721-isApprovedForAll}.
688      */
689     function isApprovedForAll(address owner, address operator)
690         public
691         view
692         virtual
693         override
694         returns (bool)
695     {
696         return _operatorApprovals[owner][operator];
697     }
698 
699     /**
700      * @dev See {IERC721-transferFrom}.
701      */
702     function transferFrom(
703         address from,
704         address to,
705         uint256 tokenId
706     ) public virtual override {
707         _transfer(from, to, tokenId);
708     }
709 
710     /**
711      * @dev See {IERC721-safeTransferFrom}.
712      */
713     function safeTransferFrom(
714         address from,
715         address to,
716         uint256 tokenId
717     ) public virtual override {
718         safeTransferFrom(from, to, tokenId, "");
719     }
720 
721     /**
722      * @dev See {IERC721-safeTransferFrom}.
723      */
724     function safeTransferFrom(
725         address from,
726         address to,
727         uint256 tokenId,
728         bytes memory _data
729     ) public virtual override {
730         _transfer(from, to, tokenId);
731         if (to.code.length != 0)
732             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
733                 revert TransferToNonERC721ReceiverImplementer();
734             }
735     }
736 
737     /**
738      * @dev Returns whether `tokenId` exists.
739      *
740      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
741      *
742      * Tokens start existing when they are minted (`_mint`),
743      */
744     function _exists(uint256 tokenId) internal view returns (bool) {
745         return
746             _startTokenId() <= tokenId &&
747             tokenId < _currentIndex && // If within bounds,
748             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
749     }
750 
751     /**
752      * @dev Equivalent to `_safeMint(to, quantity, '')`.
753      */
754     function _safeMint(address to, uint256 quantity) internal {
755         _safeMint(to, quantity, "");
756     }
757 
758     /**
759      * @dev Safely mints `quantity` tokens and transfers them to `to`.
760      *
761      * Requirements:
762      *
763      * - If `to` refers to a smart contract, it must implement
764      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
765      * - `quantity` must be greater than 0.
766      *
767      * Emits a {Transfer} event.
768      */
769     function _safeMint(
770         address to,
771         uint256 quantity,
772         bytes memory _data
773     ) internal {
774         uint256 startTokenId = _currentIndex;
775         if (to == address(0)) revert MintToZeroAddress();
776         if (quantity == 0) revert MintZeroQuantity();
777 
778         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
779 
780         // Overflows are incredibly unrealistic.
781         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
782         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
783         unchecked {
784             // Updates:
785             // - `balance += quantity`.
786             // - `numberMinted += quantity`.
787             //
788             // We can directly add to the balance and number minted.
789             _packedAddressData[to] +=
790                 quantity *
791                 ((1 << BITPOS_NUMBER_MINTED) | 1);
792 
793             // Updates:
794             // - `address` to the owner.
795             // - `startTimestamp` to the timestamp of minting.
796             // - `burned` to `false`.
797             // - `nextInitialized` to `quantity == 1`.
798             _packedOwnerships[startTokenId] =
799                 _addressToUint256(to) |
800                 (block.timestamp << BITPOS_START_TIMESTAMP) |
801                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
802 
803             uint256 updatedIndex = startTokenId;
804             uint256 end = updatedIndex + quantity;
805 
806             if (to.code.length != 0) {
807                 do {
808                     emit Transfer(address(0), to, updatedIndex);
809                     if (
810                         !_checkContractOnERC721Received(
811                             address(0),
812                             to,
813                             updatedIndex++,
814                             _data
815                         )
816                     ) {
817                         revert TransferToNonERC721ReceiverImplementer();
818                     }
819                 } while (updatedIndex < end);
820                 // Reentrancy protection
821                 if (_currentIndex != startTokenId) revert();
822             } else {
823                 do {
824                     emit Transfer(address(0), to, updatedIndex++);
825                 } while (updatedIndex < end);
826             }
827             _currentIndex = updatedIndex;
828         }
829         _afterTokenTransfers(address(0), to, startTokenId, quantity);
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
840      * Emits a {Transfer} event.
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
867             _packedOwnerships[startTokenId] =
868                 _addressToUint256(to) |
869                 (block.timestamp << BITPOS_START_TIMESTAMP) |
870                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
871 
872             uint256 updatedIndex = startTokenId;
873             uint256 end = updatedIndex + quantity;
874 
875             do {
876                 emit Transfer(address(0), to, updatedIndex++);
877             } while (updatedIndex < end);
878 
879             _currentIndex = updatedIndex;
880         }
881         _afterTokenTransfers(address(0), to, startTokenId, quantity);
882     }
883 
884     /**
885      * @dev Transfers `tokenId` from `from` to `to`.
886      *
887      * Requirements:
888      *
889      * - `to` cannot be the zero address.
890      * - `tokenId` token must be owned by `from`.
891      *
892      * Emits a {Transfer} event.
893      */
894     function _transfer(
895         address from,
896         address to,
897         uint256 tokenId
898     ) private {
899         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
900 
901         if (address(uint160(prevOwnershipPacked)) != from)
902             revert TransferFromIncorrectOwner();
903 
904         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
905             isApprovedForAll(from, _msgSenderERC721A()) ||
906             getApproved(tokenId) == _msgSenderERC721A());
907 
908         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
909         if (to == address(0)) revert TransferToZeroAddress();
910 
911         _beforeTokenTransfers(from, to, tokenId, 1);
912 
913         // Clear approvals from the previous owner.
914         delete _tokenApprovals[tokenId];
915 
916         // Underflow of the sender's balance is impossible because we check for
917         // ownership above and the recipient's balance can't realistically overflow.
918         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
919         unchecked {
920             // We can directly increment and decrement the balances.
921             --_packedAddressData[from]; // Updates: `balance -= 1`.
922             ++_packedAddressData[to]; // Updates: `balance += 1`.
923 
924             // Updates:
925             // - `address` to the next owner.
926             // - `startTimestamp` to the timestamp of transfering.
927             // - `burned` to `false`.
928             // - `nextInitialized` to `true`.
929             _packedOwnerships[tokenId] =
930                 _addressToUint256(to) |
931                 (block.timestamp << BITPOS_START_TIMESTAMP) |
932                 BITMASK_NEXT_INITIALIZED;
933 
934             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
935             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
936                 uint256 nextTokenId = tokenId + 1;
937                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
938                 if (_packedOwnerships[nextTokenId] == 0) {
939                     // If the next slot is within bounds.
940                     if (nextTokenId != _currentIndex) {
941                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
942                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
943                     }
944                 }
945             }
946         }
947 
948         emit Transfer(from, to, tokenId);
949         _afterTokenTransfers(from, to, tokenId, 1);
950     }
951 
952     /**
953      * @dev Equivalent to `_burn(tokenId, false)`.
954      */
955     function _burn(uint256 tokenId) internal virtual {
956         _burn(tokenId, false);
957     }
958 
959     /**
960      * @dev Destroys `tokenId`.
961      * The approval is cleared when the token is burned.
962      *
963      * Requirements:
964      *
965      * - `tokenId` must exist.
966      *
967      * Emits a {Transfer} event.
968      */
969     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
970         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
971 
972         address from = address(uint160(prevOwnershipPacked));
973 
974         if (approvalCheck) {
975             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
976                 isApprovedForAll(from, _msgSenderERC721A()) ||
977                 getApproved(tokenId) == _msgSenderERC721A());
978 
979             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
980         }
981 
982         _beforeTokenTransfers(from, address(0), tokenId, 1);
983 
984         // Clear approvals from the previous owner.
985         delete _tokenApprovals[tokenId];
986 
987         // Underflow of the sender's balance is impossible because we check for
988         // ownership above and the recipient's balance can't realistically overflow.
989         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
990         unchecked {
991             // Updates:
992             // - `balance -= 1`.
993             // - `numberBurned += 1`.
994             //
995             // We can directly decrement the balance, and increment the number burned.
996             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
997             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
998 
999             // Updates:
1000             // - `address` to the last owner.
1001             // - `startTimestamp` to the timestamp of burning.
1002             // - `burned` to `true`.
1003             // - `nextInitialized` to `true`.
1004             _packedOwnerships[tokenId] =
1005                 _addressToUint256(from) |
1006                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1007                 BITMASK_BURNED |
1008                 BITMASK_NEXT_INITIALIZED;
1009 
1010             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1011             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1012                 uint256 nextTokenId = tokenId + 1;
1013                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1014                 if (_packedOwnerships[nextTokenId] == 0) {
1015                     // If the next slot is within bounds.
1016                     if (nextTokenId != _currentIndex) {
1017                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1018                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1019                     }
1020                 }
1021             }
1022         }
1023 
1024         emit Transfer(from, address(0), tokenId);
1025         _afterTokenTransfers(from, address(0), tokenId, 1);
1026 
1027         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1028         unchecked {
1029             _burnCounter++;
1030         }
1031     }
1032 
1033     /**
1034      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1035      *
1036      * @param from address representing the previous owner of the given token ID
1037      * @param to target address that will receive the tokens
1038      * @param tokenId uint256 ID of the token to be transferred
1039      * @param _data bytes optional data to send along with the call
1040      * @return bool whether the call correctly returned the expected magic value
1041      */
1042     function _checkContractOnERC721Received(
1043         address from,
1044         address to,
1045         uint256 tokenId,
1046         bytes memory _data
1047     ) private returns (bool) {
1048         try
1049             ERC721A__IERC721Receiver(to).onERC721Received(
1050                 _msgSenderERC721A(),
1051                 from,
1052                 tokenId,
1053                 _data
1054             )
1055         returns (bytes4 retval) {
1056             return
1057                 retval ==
1058                 ERC721A__IERC721Receiver(to).onERC721Received.selector;
1059         } catch (bytes memory reason) {
1060             if (reason.length == 0) {
1061                 revert TransferToNonERC721ReceiverImplementer();
1062             } else {
1063                 assembly {
1064                     revert(add(32, reason), mload(reason))
1065                 }
1066             }
1067         }
1068     }
1069 
1070     /**
1071      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1072      * And also called before burning one token.
1073      *
1074      * startTokenId - the first token id to be transferred
1075      * quantity - the amount to be transferred
1076      *
1077      * Calling conditions:
1078      *
1079      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1080      * transferred to `to`.
1081      * - When `from` is zero, `tokenId` will be minted for `to`.
1082      * - When `to` is zero, `tokenId` will be burned by `from`.
1083      * - `from` and `to` are never both zero.
1084      */
1085     function _beforeTokenTransfers(
1086         address from,
1087         address to,
1088         uint256 startTokenId,
1089         uint256 quantity
1090     ) internal virtual {}
1091 
1092     /**
1093      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1094      * minting.
1095      * And also called after one token has been burned.
1096      *
1097      * startTokenId - the first token id to be transferred
1098      * quantity - the amount to be transferred
1099      *
1100      * Calling conditions:
1101      *
1102      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1103      * transferred to `to`.
1104      * - When `from` is zero, `tokenId` has been minted for `to`.
1105      * - When `to` is zero, `tokenId` has been burned by `from`.
1106      * - `from` and `to` are never both zero.
1107      */
1108     function _afterTokenTransfers(
1109         address from,
1110         address to,
1111         uint256 startTokenId,
1112         uint256 quantity
1113     ) internal virtual {}
1114 
1115     /**
1116      * @dev Returns the message sender (defaults to `msg.sender`).
1117      *
1118      * If you are writing GSN compatible contracts, you need to override this function.
1119      */
1120     function _msgSenderERC721A() internal view virtual returns (address) {
1121         return msg.sender;
1122     }
1123 
1124     /**
1125      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1126      */
1127     function _toString(uint256 value)
1128         internal
1129         pure
1130         returns (string memory ptr)
1131     {
1132         assembly {
1133             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1134             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1135             // We will need 1 32-byte word to store the length,
1136             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1137             ptr := add(mload(0x40), 128)
1138             // Update the free memory pointer to allocate.
1139             mstore(0x40, ptr)
1140 
1141             // Cache the end of the memory to calculate the length later.
1142             let end := ptr
1143 
1144             // We write the string from the rightmost digit to the leftmost digit.
1145             // The following is essentially a do-while loop that also handles the zero case.
1146             // Costs a bit more than early returning for the zero case,
1147             // but cheaper in terms of deployment and overall runtime costs.
1148             for {
1149                 // Initialize and perform the first pass without check.
1150                 let temp := value
1151                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1152                 ptr := sub(ptr, 1)
1153                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1154                 mstore8(ptr, add(48, mod(temp, 10)))
1155                 temp := div(temp, 10)
1156             } temp {
1157                 // Keep dividing `temp` until zero.
1158                 temp := div(temp, 10)
1159             } {
1160                 // Body of the for loop.
1161                 ptr := sub(ptr, 1)
1162                 mstore8(ptr, add(48, mod(temp, 10)))
1163             }
1164 
1165             let length := sub(end, ptr)
1166             // Move the pointer 32 bytes leftwards to make room for the length.
1167             ptr := sub(ptr, 32)
1168             // Store the length.
1169             mstore(ptr, length)
1170         }
1171     }
1172 }
1173 
1174 // File: @openzeppelin/contracts/utils/Context.sol
1175 
1176 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1177 
1178 pragma solidity ^0.8.0;
1179 
1180 /**
1181  * @dev Provides information about the current execution context, including the
1182  * sender of the transaction and its data. While these are generally available
1183  * via msg.sender and msg.data, they should not be accessed in such a direct
1184  * manner, since when dealing with meta-transactions the account sending and
1185  * paying for execution may not be the actual sender (as far as an application
1186  * is concerned).
1187  *
1188  * This contract is only required for intermediate, library-like contracts.
1189  */
1190 abstract contract Context {
1191     function _msgSender() internal view virtual returns (address) {
1192         return msg.sender;
1193     }
1194 
1195     function _msgData() internal view virtual returns (bytes calldata) {
1196         return msg.data;
1197     }
1198 }
1199 
1200 // File: @openzeppelin/contracts/access/Ownable.sol
1201 
1202 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1203 
1204 pragma solidity ^0.8.0;
1205 
1206 /**
1207  * @dev Contract module which provides a basic access control mechanism, where
1208  * there is an account (an owner) that can be granted exclusive access to
1209  * specific functions.
1210  *
1211  * By default, the owner account will be the one that deploys the contract. This
1212  * can later be changed with {transferOwnership}.
1213  *
1214  * This module is used through inheritance. It will make available the modifier
1215  * `onlyOwner`, which can be applied to your functions to restrict their use to
1216  * the owner.
1217  */
1218 abstract contract Ownable is Context {
1219     address private _owner;
1220 
1221     event OwnershipTransferred(
1222         address indexed previousOwner,
1223         address indexed newOwner
1224     );
1225 
1226     /**
1227      * @dev Initializes the contract setting the deployer as the initial owner.
1228      */
1229     constructor() {
1230         _transferOwnership(_msgSender());
1231     }
1232 
1233     /**
1234      * @dev Returns the address of the current owner.
1235      */
1236     function owner() public view virtual returns (address) {
1237         return _owner;
1238     }
1239 
1240     /**
1241      * @dev Throws if called by any account other than the owner.
1242      */
1243     modifier onlyOwner() {
1244         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1245         _;
1246     }
1247 
1248     /**
1249      * @dev Leaves the contract without owner. It will not be possible to call
1250      * `onlyOwner` functions anymore. Can only be called by the current owner.
1251      *
1252      * NOTE: Renouncing ownership will leave the contract without an owner,
1253      * thereby removing any functionality that is only available to the owner.
1254      */
1255     function renounceOwnership() public virtual onlyOwner {
1256         _transferOwnership(address(0));
1257     }
1258 
1259     /**
1260      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1261      * Can only be called by the current owner.
1262      */
1263     function transferOwnership(address newOwner) public virtual onlyOwner {
1264         require(
1265             newOwner != address(0),
1266             "Ownable: new owner is the zero address"
1267         );
1268         _transferOwnership(newOwner);
1269     }
1270 
1271     /**
1272      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1273      * Internal function without access restriction.
1274      */
1275     function _transferOwnership(address newOwner) internal virtual {
1276         address oldOwner = _owner;
1277         _owner = newOwner;
1278         emit OwnershipTransferred(oldOwner, newOwner);
1279     }
1280 }
1281 
1282 // File: contracts/1.sol
1283 
1284 pragma solidity >=0.8.6;
1285 
1286 contract SPACEXNFT is ERC721A, Ownable {
1287     uint256 public price = 0 ether;
1288     uint256 public maxSupply = 4170;
1289     uint256 public maxTx = 5;
1290 
1291     bool private mintOpen = false;
1292 
1293     string internal baseTokenURI =
1294         "https://green-active-beaver-186.mypinata.cloud/ipfs/QmT3PCnq1nmsqXtLVySPgxqi2t57KAbdhbpP4LcQV8nrm8/box.gif?";
1295 
1296     constructor() ERC721A("SpaceX NFT", "spaceX NFT") {}
1297 
1298     function toggleMint() external onlyOwner {
1299         mintOpen = !mintOpen;
1300     }
1301 
1302     function setPrice(uint256 newPrice) external onlyOwner {
1303         price = newPrice;
1304     }
1305 
1306     function setBaseTokenURI(string calldata _uri) external onlyOwner {
1307         baseTokenURI = _uri;
1308     }
1309 
1310     function setMaxSupply(uint256 newSupply) external onlyOwner {
1311         maxSupply = newSupply;
1312     }
1313 
1314     function setMaxTx(uint256 newMax) external onlyOwner {
1315         maxTx = newMax;
1316     }
1317 
1318     function _baseURI() internal view override returns (string memory) {
1319         return baseTokenURI;
1320     }
1321 
1322     function buyTo(address to, uint256 qty) external onlyOwner {
1323         _mintTo(to, qty);
1324     }
1325 
1326     function buy(uint256 qty) external payable {
1327         require(mintOpen, "store closed");
1328         _buy(qty);
1329     }
1330 
1331     function _buy(uint256 qty) internal {
1332         require(
1333             qty <= maxTx && qty > 0,
1334             "TRANSACTION: qty of mints not alowed"
1335         );
1336         //uint free = balanceOf(_msgSender()) == 0 ? 1 : 0;
1337         // require(msg.value >= price * (qty - free), "PAYMENT: invalid value");
1338         require(msg.value >= price * qty, "PAYMENT: invalid value");
1339         _mintTo(_msgSender(), qty);
1340     }
1341 
1342     function _mintTo(address to, uint256 qty) internal {
1343         require(
1344             qty + totalSupply() <= maxSupply,
1345             "SUPPLY: Value exceeds totalSupply"
1346         );
1347         _mint(to, qty);
1348     }
1349 
1350     function withdraw() external onlyOwner {
1351         payable(_msgSender()).transfer(address(this).balance);
1352     }
1353 
1354     function airdrop(address[] calldata _to) external onlyOwner {
1355         for (uint256 i; i < _to.length; ) {
1356             _mint(_to[i], 1);
1357 
1358             unchecked {
1359                 i++;
1360             }
1361         }
1362     }
1363 }