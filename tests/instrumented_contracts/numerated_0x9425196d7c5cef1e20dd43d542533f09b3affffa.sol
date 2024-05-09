1 // File: contracts/IERC721A.sol
2 
3 
4 // ERC721A Contracts v4.2.3
5 // Creator: Chiru Labs
6 
7 pragma solidity ^0.8.4;
8 
9 /**
10  * @dev Interface of ERC721A.
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
24      * Cannot query the balance for the zero address.
25      */
26     error BalanceQueryForZeroAddress();
27 
28     /**
29      * Cannot mint to the zero address.
30      */
31     error MintToZeroAddress();
32 
33     /**
34      * The quantity of tokens minted must be more than zero.
35      */
36     error MintZeroQuantity();
37 
38     /**
39      * The token does not exist.
40      */
41     error OwnerQueryForNonexistentToken();
42 
43     /**
44      * The caller must own the token or be an approved operator.
45      */
46     error TransferCallerNotOwnerNorApproved();
47 
48     /**
49      * The token must be owned by `from`.
50      */
51     error TransferFromIncorrectOwner();
52 
53     /**
54      * Cannot safely transfer to a contract that does not implement the
55      * ERC721Receiver interface.
56      */
57     error TransferToNonERC721ReceiverImplementer();
58 
59     /**
60      * Cannot transfer to the zero address.
61      */
62     error TransferToZeroAddress();
63 
64     /**
65      * The token does not exist.
66      */
67     error URIQueryForNonexistentToken();
68 
69     /**
70      * The `quantity` minted with ERC2309 exceeds the safety limit.
71      */
72     error MintERC2309QuantityExceedsLimit();
73 
74     /**
75      * The `extraData` cannot be set on an unintialized ownership slot.
76      */
77     error OwnershipNotInitializedForExtraData();
78 
79     // =============================================================
80     //                            STRUCTS
81     // =============================================================
82 
83     struct TokenOwnership {
84         // The address of the owner.
85         address addr;
86         // Stores the start time of ownership with minimal overhead for tokenomics.
87         uint64 startTimestamp;
88         // Whether the token has been burned.
89         bool burned;
90         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
91         uint24 extraData;
92     }
93 
94     // =============================================================
95     //                         TOKEN COUNTERS
96     // =============================================================
97 
98     /**
99      * @dev Returns the total number of tokens in existence.
100      * Burned tokens will reduce the count.
101      * To get the total number of tokens minted, please see {_totalMinted}.
102      */
103     function totalSupply() external view returns (uint256);
104 
105     // =============================================================
106     //                            IERC165
107     // =============================================================
108 
109     /**
110      * @dev Returns true if this contract implements the interface defined by
111      * `interfaceId`. See the corresponding
112      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
113      * to learn more about how these ids are created.
114      *
115      * This function call must use less than 30000 gas.
116      */
117     function supportsInterface(bytes4 interfaceId) external view returns (bool);
118 
119     // =============================================================
120     //                            IERC721
121     // =============================================================
122 
123     /**
124      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
125      */
126     event Transfer(
127         address indexed from,
128         address indexed to,
129         uint256 indexed tokenId
130     );
131 
132     /**
133      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
134      */
135     event Approval(
136         address indexed owner,
137         address indexed approved,
138         uint256 indexed tokenId
139     );
140 
141     /**
142      * @dev Emitted when `owner` enables or disables
143      * (`approved`) `operator` to manage all of its assets.
144      */
145     event ApprovalForAll(
146         address indexed owner,
147         address indexed operator,
148         bool approved
149     );
150 
151     /**
152      * @dev Returns the number of tokens in `owner`'s account.
153      */
154     function balanceOf(address owner) external view returns (uint256 balance);
155 
156     /**
157      * @dev Returns the owner of the `tokenId` token.
158      *
159      * Requirements:
160      *
161      * - `tokenId` must exist.
162      */
163     function ownerOf(uint256 tokenId) external view returns (address owner);
164 
165     /**
166      * @dev Safely transfers `tokenId` token from `from` to `to`,
167      * checking first that contract recipients are aware of the ERC721 protocol
168      * to prevent tokens from being forever locked.
169      *
170      * Requirements:
171      *
172      * - `from` cannot be the zero address.
173      * - `to` cannot be the zero address.
174      * - `tokenId` token must exist and be owned by `from`.
175      * - If the caller is not `from`, it must be have been allowed to move
176      * this token by either {approve} or {setApprovalForAll}.
177      * - If `to` refers to a smart contract, it must implement
178      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
179      *
180      * Emits a {Transfer} event.
181      */
182     function safeTransferFrom(
183         address from,
184         address to,
185         uint256 tokenId,
186         bytes calldata data
187     ) external payable;
188 
189     /**
190      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
191      */
192     function safeTransferFrom(
193         address from,
194         address to,
195         uint256 tokenId
196     ) external payable;
197 
198     /**
199      * @dev Transfers `tokenId` from `from` to `to`.
200      *
201      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
202      * whenever possible.
203      *
204      * Requirements:
205      *
206      * - `from` cannot be the zero address.
207      * - `to` cannot be the zero address.
208      * - `tokenId` token must be owned by `from`.
209      * - If the caller is not `from`, it must be approved to move this token
210      * by either {approve} or {setApprovalForAll}.
211      *
212      * Emits a {Transfer} event.
213      */
214     function transferFrom(
215         address from,
216         address to,
217         uint256 tokenId
218     ) external payable;
219 
220     /**
221      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
222      * The approval is cleared when the token is transferred.
223      *
224      * Only a single account can be approved at a time, so approving the
225      * zero address clears previous approvals.
226      *
227      * Requirements:
228      *
229      * - The caller must own the token or be an approved operator.
230      * - `tokenId` must exist.
231      *
232      * Emits an {Approval} event.
233      */
234     function approve(address to, uint256 tokenId) external payable;
235 
236     /**
237      * @dev Approve or remove `operator` as an operator for the caller.
238      * Operators can call {transferFrom} or {safeTransferFrom}
239      * for any token owned by the caller.
240      *
241      * Requirements:
242      *
243      * - The `operator` cannot be the caller.
244      *
245      * Emits an {ApprovalForAll} event.
246      */
247     function setApprovalForAll(address operator, bool _approved) external;
248 
249     /**
250      * @dev Returns the account approved for `tokenId` token.
251      *
252      * Requirements:
253      *
254      * - `tokenId` must exist.
255      */
256     function getApproved(uint256 tokenId)
257         external
258         view
259         returns (address operator);
260 
261     /**
262      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
263      *
264      * See {setApprovalForAll}.
265      */
266     function isApprovedForAll(address owner, address operator)
267         external
268         view
269         returns (bool);
270 
271     // =============================================================
272     //                        IERC721Metadata
273     // =============================================================
274 
275     /**
276      * @dev Returns the token collection name.
277      */
278     function name() external view returns (string memory);
279 
280     /**
281      * @dev Returns the token collection symbol.
282      */
283     function symbol() external view returns (string memory);
284 
285     /**
286      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
287      */
288     function tokenURI(uint256 tokenId) external view returns (string memory);
289 
290     // =============================================================
291     //                           IERC2309
292     // =============================================================
293 
294     /**
295      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
296      * (inclusive) is transferred from `from` to `to`, as defined in the
297      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
298      *
299      * See {_mintERC2309} for more details.
300      */
301     event ConsecutiveTransfer(
302         uint256 indexed fromTokenId,
303         uint256 toTokenId,
304         address indexed from,
305         address indexed to
306     );
307 }
308 
309 // File: contracts/ERC721A.sol
310 
311 
312 // ERC721A Contracts v4.2.3
313 // Creator: Chiru Labs
314 
315 pragma solidity ^0.8.4;
316 
317 
318 /**
319  * @dev Interface of ERC721 token receiver.
320  */
321 interface ERC721A__IERC721Receiver {
322     function onERC721Received(
323         address operator,
324         address from,
325         uint256 tokenId,
326         bytes calldata data
327     ) external returns (bytes4);
328 }
329 
330 /**
331  * @title ERC721A
332  *
333  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
334  * Non-Fungible Token Standard, including the Metadata extension.
335  * Optimized for lower gas during batch mints.
336  *
337  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
338  * starting from `_startTokenId()`.
339  *
340  * Assumptions:
341  *
342  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
343  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
344  */
345 contract ERC721A is IERC721A {
346     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
347     struct TokenApprovalRef {
348         address value;
349     }
350 
351     // =============================================================
352     //                           CONSTANTS
353     // =============================================================
354 
355     // Mask of an entry in packed address data.
356     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
357 
358     // The bit position of `numberMinted` in packed address data.
359     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
360 
361     // The bit position of `numberBurned` in packed address data.
362     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
363 
364     // The bit position of `aux` in packed address data.
365     uint256 private constant _BITPOS_AUX = 192;
366 
367     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
368     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
369 
370     // The bit position of `startTimestamp` in packed ownership.
371     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
372 
373     // The bit mask of the `burned` bit in packed ownership.
374     uint256 private constant _BITMASK_BURNED = 1 << 224;
375 
376     // The bit position of the `nextInitialized` bit in packed ownership.
377     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
378 
379     // The bit mask of the `nextInitialized` bit in packed ownership.
380     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
381 
382     // The bit position of `extraData` in packed ownership.
383     uint256 private constant _BITPOS_EXTRA_DATA = 232;
384 
385     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
386     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
387 
388     // The mask of the lower 160 bits for addresses.
389     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
390 
391     // The maximum `quantity` that can be minted with {_mintERC2309}.
392     // This limit is to prevent overflows on the address data entries.
393     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
394     // is required to cause an overflow, which is unrealistic.
395     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
396 
397     // The `Transfer` event signature is given by:
398     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
399     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
400         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
401 
402     // =============================================================
403     //                            STORAGE
404     // =============================================================
405 
406     // The next token ID to be minted.
407     uint256 private _currentIndex;
408 
409     // The number of tokens burned.
410     uint256 private _burnCounter;
411 
412     // Token name
413     string private _name;
414 
415     // Token symbol
416     string private _symbol;
417 
418     // Mapping from token ID to ownership details
419     // An empty struct value does not necessarily mean the token is unowned.
420     // See {_packedOwnershipOf} implementation for details.
421     //
422     // Bits Layout:
423     // - [0..159]   `addr`
424     // - [160..223] `startTimestamp`
425     // - [224]      `burned`
426     // - [225]      `nextInitialized`
427     // - [232..255] `extraData`
428     mapping(uint256 => uint256) private _packedOwnerships;
429 
430     // Mapping owner address to address data.
431     //
432     // Bits Layout:
433     // - [0..63]    `balance`
434     // - [64..127]  `numberMinted`
435     // - [128..191] `numberBurned`
436     // - [192..255] `aux`
437     mapping(address => uint256) private _packedAddressData;
438 
439     // Mapping from token ID to approved address.
440     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
441 
442     // Mapping from owner to operator approvals
443     mapping(address => mapping(address => bool)) private _operatorApprovals;
444 
445     // =============================================================
446     //                          CONSTRUCTOR
447     // =============================================================
448 
449     constructor(string memory name_, string memory symbol_) {
450         _name = name_;
451         _symbol = symbol_;
452         _currentIndex = _startTokenId();
453     }
454 
455     // =============================================================
456     //                   TOKEN COUNTING OPERATIONS
457     // =============================================================
458 
459     /**
460      * @dev Returns the starting token ID.
461      * To change the starting token ID, please override this function.
462      */
463     function _startTokenId() internal view virtual returns (uint256) {
464         return 0;
465     }
466 
467     /**
468      * @dev Returns the next token ID to be minted.
469      */
470     function _nextTokenId() internal view virtual returns (uint256) {
471         return _currentIndex;
472     }
473 
474     /**
475      * @dev Returns the total number of tokens in existence.
476      * Burned tokens will reduce the count.
477      * To get the total number of tokens minted, please see {_totalMinted}.
478      */
479     function totalSupply() public view virtual override returns (uint256) {
480         // Counter underflow is impossible as _burnCounter cannot be incremented
481         // more than `_currentIndex - _startTokenId()` times.
482         unchecked {
483             return _currentIndex - _burnCounter - _startTokenId();
484         }
485     }
486 
487     /**
488      * @dev Returns the total amount of tokens minted in the contract.
489      */
490     function _totalMinted() internal view virtual returns (uint256) {
491         // Counter underflow is impossible as `_currentIndex` does not decrement,
492         // and it is initialized to `_startTokenId()`.
493         unchecked {
494             return _currentIndex - _startTokenId();
495         }
496     }
497 
498     /**
499      * @dev Returns the total number of tokens burned.
500      */
501     function _totalBurned() internal view virtual returns (uint256) {
502         return _burnCounter;
503     }
504 
505     // =============================================================
506     //                    ADDRESS DATA OPERATIONS
507     // =============================================================
508 
509     /**
510      * @dev Returns the number of tokens in `owner`'s account.
511      */
512     function balanceOf(address owner)
513         public
514         view
515         virtual
516         override
517         returns (uint256)
518     {
519         if (owner == address(0)) revert BalanceQueryForZeroAddress();
520         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
521     }
522 
523     /**
524      * Returns the number of tokens minted by `owner`.
525      */
526     function _numberMinted(address owner) internal view returns (uint256) {
527         return
528             (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) &
529             _BITMASK_ADDRESS_DATA_ENTRY;
530     }
531 
532     /**
533      * Returns the number of tokens burned by or on behalf of `owner`.
534      */
535     function _numberBurned(address owner) internal view returns (uint256) {
536         return
537             (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) &
538             _BITMASK_ADDRESS_DATA_ENTRY;
539     }
540 
541     /**
542      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
543      */
544     function _getAux(address owner) internal view returns (uint64) {
545         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
546     }
547 
548     /**
549      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
550      * If there are multiple variables, please pack them into a uint64.
551      */
552     function _setAux(address owner, uint64 aux) internal virtual {
553         uint256 packed = _packedAddressData[owner];
554         uint256 auxCasted;
555         // Cast `aux` with assembly to avoid redundant masking.
556         assembly {
557             auxCasted := aux
558         }
559         packed =
560             (packed & _BITMASK_AUX_COMPLEMENT) |
561             (auxCasted << _BITPOS_AUX);
562         _packedAddressData[owner] = packed;
563     }
564 
565     // =============================================================
566     //                            IERC165
567     // =============================================================
568 
569     /**
570      * @dev Returns true if this contract implements the interface defined by
571      * `interfaceId`. See the corresponding
572      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
573      * to learn more about how these ids are created.
574      *
575      * This function call must use less than 30000 gas.
576      */
577     function supportsInterface(bytes4 interfaceId)
578         public
579         view
580         virtual
581         override
582         returns (bool)
583     {
584         // The interface IDs are constants representing the first 4 bytes
585         // of the XOR of all function selectors in the interface.
586         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
587         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
588         return
589             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
590             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
591             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
592     }
593 
594     // =============================================================
595     //                        IERC721Metadata
596     // =============================================================
597 
598     /**
599      * @dev Returns the token collection name.
600      */
601     function name() public view virtual override returns (string memory) {
602         return _name;
603     }
604 
605     /**
606      * @dev Returns the token collection symbol.
607      */
608     function symbol() public view virtual override returns (string memory) {
609         return _symbol;
610     }
611 
612     /**
613      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
614      */
615     function tokenURI(uint256 tokenId)
616         public
617         view
618         virtual
619         override
620         returns (string memory)
621     {
622         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
623 
624         string memory baseURI = _baseURI();
625         return
626             bytes(baseURI).length != 0
627                 ? string(abi.encodePacked(baseURI, _toString(tokenId)))
628                 : "";
629     }
630 
631     /**
632      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
633      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
634      * by default, it can be overridden in child contracts.
635      */
636     function _baseURI() internal view virtual returns (string memory) {
637         return "";
638     }
639 
640     // =============================================================
641     //                     OWNERSHIPS OPERATIONS
642     // =============================================================
643 
644     /**
645      * @dev Returns the owner of the `tokenId` token.
646      *
647      * Requirements:
648      *
649      * - `tokenId` must exist.
650      */
651     function ownerOf(uint256 tokenId)
652         public
653         view
654         virtual
655         override
656         returns (address)
657     {
658         return address(uint160(_packedOwnershipOf(tokenId)));
659     }
660 
661     /**
662      * @dev Gas spent here starts off proportional to the maximum mint batch size.
663      * It gradually moves to O(1) as tokens get transferred around over time.
664      */
665     function _ownershipOf(uint256 tokenId)
666         internal
667         view
668         virtual
669         returns (TokenOwnership memory)
670     {
671         return _unpackedOwnership(_packedOwnershipOf(tokenId));
672     }
673 
674     /**
675      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
676      */
677     function _ownershipAt(uint256 index)
678         internal
679         view
680         virtual
681         returns (TokenOwnership memory)
682     {
683         return _unpackedOwnership(_packedOwnerships[index]);
684     }
685 
686     /**
687      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
688      */
689     function _initializeOwnershipAt(uint256 index) internal virtual {
690         if (_packedOwnerships[index] == 0) {
691             _packedOwnerships[index] = _packedOwnershipOf(index);
692         }
693     }
694 
695     /**
696      * Returns the packed ownership data of `tokenId`.
697      */
698     function _packedOwnershipOf(uint256 tokenId)
699         private
700         view
701         returns (uint256)
702     {
703         uint256 curr = tokenId;
704 
705         unchecked {
706             if (_startTokenId() <= curr)
707                 if (curr < _currentIndex) {
708                     uint256 packed = _packedOwnerships[curr];
709                     // If not burned.
710                     if (packed & _BITMASK_BURNED == 0) {
711                         // Invariant:
712                         // There will always be an initialized ownership slot
713                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
714                         // before an unintialized ownership slot
715                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
716                         // Hence, `curr` will not underflow.
717                         //
718                         // We can directly compare the packed value.
719                         // If the address is zero, packed will be zero.
720                         while (packed == 0) {
721                             packed = _packedOwnerships[--curr];
722                         }
723                         return packed;
724                     }
725                 }
726         }
727         revert OwnerQueryForNonexistentToken();
728     }
729 
730     /**
731      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
732      */
733     function _unpackedOwnership(uint256 packed)
734         private
735         pure
736         returns (TokenOwnership memory ownership)
737     {
738         ownership.addr = address(uint160(packed));
739         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
740         ownership.burned = packed & _BITMASK_BURNED != 0;
741         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
742     }
743 
744     /**
745      * @dev Packs ownership data into a single uint256.
746      */
747     function _packOwnershipData(address owner, uint256 flags)
748         private
749         view
750         returns (uint256 result)
751     {
752         assembly {
753             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
754             owner := and(owner, _BITMASK_ADDRESS)
755             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
756             result := or(
757                 owner,
758                 or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags)
759             )
760         }
761     }
762 
763     /**
764      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
765      */
766     function _nextInitializedFlag(uint256 quantity)
767         private
768         pure
769         returns (uint256 result)
770     {
771         // For branchless setting of the `nextInitialized` flag.
772         assembly {
773             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
774             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
775         }
776     }
777 
778     // =============================================================
779     //                      APPROVAL OPERATIONS
780     // =============================================================
781 
782     /**
783      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
784      * The approval is cleared when the token is transferred.
785      *
786      * Only a single account can be approved at a time, so approving the
787      * zero address clears previous approvals.
788      *
789      * Requirements:
790      *
791      * - The caller must own the token or be an approved operator.
792      * - `tokenId` must exist.
793      *
794      * Emits an {Approval} event.
795      */
796     function approve(address to, uint256 tokenId)
797         public
798         payable
799         virtual
800         override
801     {
802         address owner = ownerOf(tokenId);
803 
804         if (_msgSenderERC721A() != owner)
805             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
806                 revert ApprovalCallerNotOwnerNorApproved();
807             }
808 
809         _tokenApprovals[tokenId].value = to;
810         emit Approval(owner, to, tokenId);
811     }
812 
813     /**
814      * @dev Returns the account approved for `tokenId` token.
815      *
816      * Requirements:
817      *
818      * - `tokenId` must exist.
819      */
820     function getApproved(uint256 tokenId)
821         public
822         view
823         virtual
824         override
825         returns (address)
826     {
827         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
828 
829         return _tokenApprovals[tokenId].value;
830     }
831 
832     /**
833      * @dev Approve or remove `operator` as an operator for the caller.
834      * Operators can call {transferFrom} or {safeTransferFrom}
835      * for any token owned by the caller.
836      *
837      * Requirements:
838      *
839      * - The `operator` cannot be the caller.
840      *
841      * Emits an {ApprovalForAll} event.
842      */
843     function setApprovalForAll(address operator, bool approved)
844         public
845         virtual
846         override
847     {
848         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
849         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
850     }
851 
852     /**
853      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
854      *
855      * See {setApprovalForAll}.
856      */
857     function isApprovedForAll(address owner, address operator)
858         public
859         view
860         virtual
861         override
862         returns (bool)
863     {
864         return _operatorApprovals[owner][operator];
865     }
866 
867     /**
868      * @dev Returns whether `tokenId` exists.
869      *
870      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
871      *
872      * Tokens start existing when they are minted. See {_mint}.
873      */
874     function _exists(uint256 tokenId) internal view virtual returns (bool) {
875         return
876             _startTokenId() <= tokenId &&
877             tokenId < _currentIndex && // If within bounds,
878             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
879     }
880 
881     /**
882      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
883      */
884     function _isSenderApprovedOrOwner(
885         address approvedAddress,
886         address owner,
887         address msgSender
888     ) private pure returns (bool result) {
889         assembly {
890             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
891             owner := and(owner, _BITMASK_ADDRESS)
892             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
893             msgSender := and(msgSender, _BITMASK_ADDRESS)
894             // `msgSender == owner || msgSender == approvedAddress`.
895             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
896         }
897     }
898 
899     /**
900      * @dev Returns the storage slot and value for the approved address of `tokenId`.
901      */
902     function _getApprovedSlotAndAddress(uint256 tokenId)
903         private
904         view
905         returns (uint256 approvedAddressSlot, address approvedAddress)
906     {
907         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
908         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
909         assembly {
910             approvedAddressSlot := tokenApproval.slot
911             approvedAddress := sload(approvedAddressSlot)
912         }
913     }
914 
915     // =============================================================
916     //                      TRANSFER OPERATIONS
917     // =============================================================
918 
919     /**
920      * @dev Transfers `tokenId` from `from` to `to`.
921      *
922      * Requirements:
923      *
924      * - `from` cannot be the zero address.
925      * - `to` cannot be the zero address.
926      * - `tokenId` token must be owned by `from`.
927      * - If the caller is not `from`, it must be approved to move this token
928      * by either {approve} or {setApprovalForAll}.
929      *
930      * Emits a {Transfer} event.
931      */
932     function transferFrom(
933         address from,
934         address to,
935         uint256 tokenId
936     ) public payable virtual override {
937         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
938 
939         if (address(uint160(prevOwnershipPacked)) != from)
940             revert TransferFromIncorrectOwner();
941 
942         (
943             uint256 approvedAddressSlot,
944             address approvedAddress
945         ) = _getApprovedSlotAndAddress(tokenId);
946 
947         // The nested ifs save around 20+ gas over a compound boolean condition.
948         if (
949             !_isSenderApprovedOrOwner(
950                 approvedAddress,
951                 from,
952                 _msgSenderERC721A()
953             )
954         )
955             if (!isApprovedForAll(from, _msgSenderERC721A()))
956                 revert TransferCallerNotOwnerNorApproved();
957 
958         if (to == address(0)) revert TransferToZeroAddress();
959 
960         _beforeTokenTransfers(from, to, tokenId, 1);
961 
962         // Clear approvals from the previous owner.
963         assembly {
964             if approvedAddress {
965                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
966                 sstore(approvedAddressSlot, 0)
967             }
968         }
969 
970         // Underflow of the sender's balance is impossible because we check for
971         // ownership above and the recipient's balance can't realistically overflow.
972         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
973         unchecked {
974             // We can directly increment and decrement the balances.
975             --_packedAddressData[from]; // Updates: `balance -= 1`.
976             ++_packedAddressData[to]; // Updates: `balance += 1`.
977 
978             // Updates:
979             // - `address` to the next owner.
980             // - `startTimestamp` to the timestamp of transfering.
981             // - `burned` to `false`.
982             // - `nextInitialized` to `true`.
983             _packedOwnerships[tokenId] = _packOwnershipData(
984                 to,
985                 _BITMASK_NEXT_INITIALIZED |
986                     _nextExtraData(from, to, prevOwnershipPacked)
987             );
988 
989             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
990             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
991                 uint256 nextTokenId = tokenId + 1;
992                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
993                 if (_packedOwnerships[nextTokenId] == 0) {
994                     // If the next slot is within bounds.
995                     if (nextTokenId != _currentIndex) {
996                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
997                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
998                     }
999                 }
1000             }
1001         }
1002 
1003         emit Transfer(from, to, tokenId);
1004         _afterTokenTransfers(from, to, tokenId, 1);
1005     }
1006 
1007     /**
1008      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1009      */
1010     function safeTransferFrom(
1011         address from,
1012         address to,
1013         uint256 tokenId
1014     ) public payable virtual override {
1015         safeTransferFrom(from, to, tokenId, "");
1016     }
1017 
1018     /**
1019      * @dev Safely transfers `tokenId` token from `from` to `to`.
1020      *
1021      * Requirements:
1022      *
1023      * - `from` cannot be the zero address.
1024      * - `to` cannot be the zero address.
1025      * - `tokenId` token must exist and be owned by `from`.
1026      * - If the caller is not `from`, it must be approved to move this token
1027      * by either {approve} or {setApprovalForAll}.
1028      * - If `to` refers to a smart contract, it must implement
1029      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1030      *
1031      * Emits a {Transfer} event.
1032      */
1033     function safeTransferFrom(
1034         address from,
1035         address to,
1036         uint256 tokenId,
1037         bytes memory _data
1038     ) public payable virtual override {
1039         transferFrom(from, to, tokenId);
1040         if (to.code.length != 0)
1041             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1042                 revert TransferToNonERC721ReceiverImplementer();
1043             }
1044     }
1045 
1046     /**
1047      * @dev Hook that is called before a set of serially-ordered token IDs
1048      * are about to be transferred. This includes minting.
1049      * And also called before burning one token.
1050      *
1051      * `startTokenId` - the first token ID to be transferred.
1052      * `quantity` - the amount to be transferred.
1053      *
1054      * Calling conditions:
1055      *
1056      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1057      * transferred to `to`.
1058      * - When `from` is zero, `tokenId` will be minted for `to`.
1059      * - When `to` is zero, `tokenId` will be burned by `from`.
1060      * - `from` and `to` are never both zero.
1061      */
1062     function _beforeTokenTransfers(
1063         address from,
1064         address to,
1065         uint256 startTokenId,
1066         uint256 quantity
1067     ) internal virtual {}
1068 
1069     /**
1070      * @dev Hook that is called after a set of serially-ordered token IDs
1071      * have been transferred. This includes minting.
1072      * And also called after one token has been burned.
1073      *
1074      * `startTokenId` - the first token ID to be transferred.
1075      * `quantity` - the amount to be transferred.
1076      *
1077      * Calling conditions:
1078      *
1079      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1080      * transferred to `to`.
1081      * - When `from` is zero, `tokenId` has been minted for `to`.
1082      * - When `to` is zero, `tokenId` has been burned by `from`.
1083      * - `from` and `to` are never both zero.
1084      */
1085     function _afterTokenTransfers(
1086         address from,
1087         address to,
1088         uint256 startTokenId,
1089         uint256 quantity
1090     ) internal virtual {}
1091 
1092     /**
1093      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1094      *
1095      * `from` - Previous owner of the given token ID.
1096      * `to` - Target address that will receive the token.
1097      * `tokenId` - Token ID to be transferred.
1098      * `_data` - Optional data to send along with the call.
1099      *
1100      * Returns whether the call correctly returned the expected magic value.
1101      */
1102     function _checkContractOnERC721Received(
1103         address from,
1104         address to,
1105         uint256 tokenId,
1106         bytes memory _data
1107     ) private returns (bool) {
1108         try
1109             ERC721A__IERC721Receiver(to).onERC721Received(
1110                 _msgSenderERC721A(),
1111                 from,
1112                 tokenId,
1113                 _data
1114             )
1115         returns (bytes4 retval) {
1116             return
1117                 retval ==
1118                 ERC721A__IERC721Receiver(to).onERC721Received.selector;
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
1130     // =============================================================
1131     //                        MINT OPERATIONS
1132     // =============================================================
1133 
1134     /**
1135      * @dev Mints `quantity` tokens and transfers them to `to`.
1136      *
1137      * Requirements:
1138      *
1139      * - `to` cannot be the zero address.
1140      * - `quantity` must be greater than 0.
1141      *
1142      * Emits a {Transfer} event for each mint.
1143      */
1144     function _mint(address to, uint256 quantity) internal virtual {
1145         uint256 startTokenId = _currentIndex;
1146         if (quantity == 0) revert MintZeroQuantity();
1147 
1148         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1149 
1150         // Overflows are incredibly unrealistic.
1151         // `balance` and `numberMinted` have a maximum limit of 2**64.
1152         // `tokenId` has a maximum limit of 2**256.
1153         unchecked {
1154             // Updates:
1155             // - `balance += quantity`.
1156             // - `numberMinted += quantity`.
1157             //
1158             // We can directly add to the `balance` and `numberMinted`.
1159             _packedAddressData[to] +=
1160                 quantity *
1161                 ((1 << _BITPOS_NUMBER_MINTED) | 1);
1162 
1163             // Updates:
1164             // - `address` to the owner.
1165             // - `startTimestamp` to the timestamp of minting.
1166             // - `burned` to `false`.
1167             // - `nextInitialized` to `quantity == 1`.
1168             _packedOwnerships[startTokenId] = _packOwnershipData(
1169                 to,
1170                 _nextInitializedFlag(quantity) |
1171                     _nextExtraData(address(0), to, 0)
1172             );
1173 
1174             uint256 toMasked;
1175             uint256 end = startTokenId + quantity;
1176 
1177             // Use assembly to loop and emit the `Transfer` event for gas savings.
1178             // The duplicated `log4` removes an extra check and reduces stack juggling.
1179             // The assembly, together with the surrounding Solidity code, have been
1180             // delicately arranged to nudge the compiler into producing optimized opcodes.
1181             assembly {
1182                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1183                 toMasked := and(to, _BITMASK_ADDRESS)
1184                 // Emit the `Transfer` event.
1185                 log4(
1186                     0, // Start of data (0, since no data).
1187                     0, // End of data (0, since no data).
1188                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1189                     0, // `address(0)`.
1190                     toMasked, // `to`.
1191                     startTokenId // `tokenId`.
1192                 )
1193 
1194                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1195                 // that overflows uint256 will make the loop run out of gas.
1196                 // The compiler will optimize the `iszero` away for performance.
1197                 for {
1198                     let tokenId := add(startTokenId, 1)
1199                 } iszero(eq(tokenId, end)) {
1200                     tokenId := add(tokenId, 1)
1201                 } {
1202                     // Emit the `Transfer` event. Similar to above.
1203                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1204                 }
1205             }
1206             if (toMasked == 0) revert MintToZeroAddress();
1207 
1208             _currentIndex = end;
1209         }
1210         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1211     }
1212 
1213     /**
1214      * @dev Mints `quantity` tokens and transfers them to `to`.
1215      *
1216      * This function is intended for efficient minting only during contract creation.
1217      *
1218      * It emits only one {ConsecutiveTransfer} as defined in
1219      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1220      * instead of a sequence of {Transfer} event(s).
1221      *
1222      * Calling this function outside of contract creation WILL make your contract
1223      * non-compliant with the ERC721 standard.
1224      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1225      * {ConsecutiveTransfer} event is only permissible during contract creation.
1226      *
1227      * Requirements:
1228      *
1229      * - `to` cannot be the zero address.
1230      * - `quantity` must be greater than 0.
1231      *
1232      * Emits a {ConsecutiveTransfer} event.
1233      */
1234     function _mintERC2309(address to, uint256 quantity) internal virtual {
1235         uint256 startTokenId = _currentIndex;
1236         if (to == address(0)) revert MintToZeroAddress();
1237         if (quantity == 0) revert MintZeroQuantity();
1238         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT)
1239             revert MintERC2309QuantityExceedsLimit();
1240 
1241         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1242 
1243         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1244         unchecked {
1245             // Updates:
1246             // - `balance += quantity`.
1247             // - `numberMinted += quantity`.
1248             //
1249             // We can directly add to the `balance` and `numberMinted`.
1250             _packedAddressData[to] +=
1251                 quantity *
1252                 ((1 << _BITPOS_NUMBER_MINTED) | 1);
1253 
1254             // Updates:
1255             // - `address` to the owner.
1256             // - `startTimestamp` to the timestamp of minting.
1257             // - `burned` to `false`.
1258             // - `nextInitialized` to `quantity == 1`.
1259             _packedOwnerships[startTokenId] = _packOwnershipData(
1260                 to,
1261                 _nextInitializedFlag(quantity) |
1262                     _nextExtraData(address(0), to, 0)
1263             );
1264 
1265             emit ConsecutiveTransfer(
1266                 startTokenId,
1267                 startTokenId + quantity - 1,
1268                 address(0),
1269                 to
1270             );
1271 
1272             _currentIndex = startTokenId + quantity;
1273         }
1274         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1275     }
1276 
1277     /**
1278      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1279      *
1280      * Requirements:
1281      *
1282      * - If `to` refers to a smart contract, it must implement
1283      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1284      * - `quantity` must be greater than 0.
1285      *
1286      * See {_mint}.
1287      *
1288      * Emits a {Transfer} event for each mint.
1289      */
1290     function _safeMint(
1291         address to,
1292         uint256 quantity,
1293         bytes memory _data
1294     ) internal virtual {
1295         _mint(to, quantity);
1296 
1297         unchecked {
1298             if (to.code.length != 0) {
1299                 uint256 end = _currentIndex;
1300                 uint256 index = end - quantity;
1301                 do {
1302                     if (
1303                         !_checkContractOnERC721Received(
1304                             address(0),
1305                             to,
1306                             index++,
1307                             _data
1308                         )
1309                     ) {
1310                         revert TransferToNonERC721ReceiverImplementer();
1311                     }
1312                 } while (index < end);
1313                 // Reentrancy protection.
1314                 if (_currentIndex != end) revert();
1315             }
1316         }
1317     }
1318 
1319     /**
1320      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1321      */
1322     function _safeMint(address to, uint256 quantity) internal virtual {
1323         _safeMint(to, quantity, "");
1324     }
1325 
1326     // =============================================================
1327     //                        BURN OPERATIONS
1328     // =============================================================
1329 
1330     /**
1331      * @dev Equivalent to `_burn(tokenId, false)`.
1332      */
1333     function _burn(uint256 tokenId) internal virtual {
1334         _burn(tokenId, false);
1335     }
1336 
1337     /**
1338      * @dev Destroys `tokenId`.
1339      * The approval is cleared when the token is burned.
1340      *
1341      * Requirements:
1342      *
1343      * - `tokenId` must exist.
1344      *
1345      * Emits a {Transfer} event.
1346      */
1347     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1348         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1349 
1350         address from = address(uint160(prevOwnershipPacked));
1351 
1352         (
1353             uint256 approvedAddressSlot,
1354             address approvedAddress
1355         ) = _getApprovedSlotAndAddress(tokenId);
1356 
1357         if (approvalCheck) {
1358             // The nested ifs save around 20+ gas over a compound boolean condition.
1359             if (
1360                 !_isSenderApprovedOrOwner(
1361                     approvedAddress,
1362                     from,
1363                     _msgSenderERC721A()
1364                 )
1365             )
1366                 if (!isApprovedForAll(from, _msgSenderERC721A()))
1367                     revert TransferCallerNotOwnerNorApproved();
1368         }
1369 
1370         _beforeTokenTransfers(from, address(0), tokenId, 1);
1371 
1372         // Clear approvals from the previous owner.
1373         assembly {
1374             if approvedAddress {
1375                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1376                 sstore(approvedAddressSlot, 0)
1377             }
1378         }
1379 
1380         // Underflow of the sender's balance is impossible because we check for
1381         // ownership above and the recipient's balance can't realistically overflow.
1382         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1383         unchecked {
1384             // Updates:
1385             // - `balance -= 1`.
1386             // - `numberBurned += 1`.
1387             //
1388             // We can directly decrement the balance, and increment the number burned.
1389             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1390             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1391 
1392             // Updates:
1393             // - `address` to the last owner.
1394             // - `startTimestamp` to the timestamp of burning.
1395             // - `burned` to `true`.
1396             // - `nextInitialized` to `true`.
1397             _packedOwnerships[tokenId] = _packOwnershipData(
1398                 from,
1399                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) |
1400                     _nextExtraData(from, address(0), prevOwnershipPacked)
1401             );
1402 
1403             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1404             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1405                 uint256 nextTokenId = tokenId + 1;
1406                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1407                 if (_packedOwnerships[nextTokenId] == 0) {
1408                     // If the next slot is within bounds.
1409                     if (nextTokenId != _currentIndex) {
1410                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1411                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1412                     }
1413                 }
1414             }
1415         }
1416 
1417         emit Transfer(from, address(0), tokenId);
1418         _afterTokenTransfers(from, address(0), tokenId, 1);
1419 
1420         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1421         unchecked {
1422             _burnCounter++;
1423         }
1424     }
1425 
1426     // =============================================================
1427     //                     EXTRA DATA OPERATIONS
1428     // =============================================================
1429 
1430     /**
1431      * @dev Directly sets the extra data for the ownership data `index`.
1432      */
1433     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1434         uint256 packed = _packedOwnerships[index];
1435         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1436         uint256 extraDataCasted;
1437         // Cast `extraData` with assembly to avoid redundant masking.
1438         assembly {
1439             extraDataCasted := extraData
1440         }
1441         packed =
1442             (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) |
1443             (extraDataCasted << _BITPOS_EXTRA_DATA);
1444         _packedOwnerships[index] = packed;
1445     }
1446 
1447     /**
1448      * @dev Called during each token transfer to set the 24bit `extraData` field.
1449      * Intended to be overridden by the cosumer contract.
1450      *
1451      * `previousExtraData` - the value of `extraData` before transfer.
1452      *
1453      * Calling conditions:
1454      *
1455      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1456      * transferred to `to`.
1457      * - When `from` is zero, `tokenId` will be minted for `to`.
1458      * - When `to` is zero, `tokenId` will be burned by `from`.
1459      * - `from` and `to` are never both zero.
1460      */
1461     function _extraData(
1462         address from,
1463         address to,
1464         uint24 previousExtraData
1465     ) internal view virtual returns (uint24) {}
1466 
1467     /**
1468      * @dev Returns the next extra data for the packed ownership data.
1469      * The returned result is shifted into position.
1470      */
1471     function _nextExtraData(
1472         address from,
1473         address to,
1474         uint256 prevOwnershipPacked
1475     ) private view returns (uint256) {
1476         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1477         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1478     }
1479 
1480     // =============================================================
1481     //                       OTHER OPERATIONS
1482     // =============================================================
1483 
1484     /**
1485      * @dev Returns the message sender (defaults to `msg.sender`).
1486      *
1487      * If you are writing GSN compatible contracts, you need to override this function.
1488      */
1489     function _msgSenderERC721A() internal view virtual returns (address) {
1490         return msg.sender;
1491     }
1492 
1493     /**
1494      * @dev Converts a uint256 to its ASCII string decimal representation.
1495      */
1496     function _toString(uint256 value)
1497         internal
1498         pure
1499         virtual
1500         returns (string memory str)
1501     {
1502         assembly {
1503             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1504             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1505             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1506             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1507             let m := add(mload(0x40), 0xa0)
1508             // Update the free memory pointer to allocate.
1509             mstore(0x40, m)
1510             // Assign the `str` to the end.
1511             str := sub(m, 0x20)
1512             // Zeroize the slot after the string.
1513             mstore(str, 0)
1514 
1515             // Cache the end of the memory to calculate the length later.
1516             let end := str
1517 
1518             // We write the string from rightmost digit to leftmost digit.
1519             // The following is essentially a do-while loop that also handles the zero case.
1520             // prettier-ignore
1521             for { let temp := value } 1 {} {
1522                 str := sub(str, 1)
1523                 // Write the character to the pointer.
1524                 // The ASCII index of the '0' character is 48.
1525                 mstore8(str, add(48, mod(temp, 10)))
1526                 // Keep dividing `temp` until zero.
1527                 temp := div(temp, 10)
1528                 // prettier-ignore
1529                 if iszero(temp) { break }
1530             }
1531 
1532             let length := sub(end, str)
1533             // Move the pointer 32 bytes leftwards to make room for the length.
1534             str := sub(str, 0x20)
1535             // Store the length.
1536             mstore(str, length)
1537         }
1538     }
1539 }
1540 
1541 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
1542 
1543 
1544 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/MerkleProof.sol)
1545 
1546 pragma solidity ^0.8.0;
1547 
1548 /**
1549  * @dev These functions deal with verification of Merkle Tree proofs.
1550  *
1551  * The tree and the proofs can be generated using our
1552  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
1553  * You will find a quickstart guide in the readme.
1554  *
1555  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1556  * hashing, or use a hash function other than keccak256 for hashing leaves.
1557  * This is because the concatenation of a sorted pair of internal nodes in
1558  * the merkle tree could be reinterpreted as a leaf value.
1559  * OpenZeppelin's JavaScript library generates merkle trees that are safe
1560  * against this attack out of the box.
1561  */
1562 library MerkleProof {
1563     /**
1564      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1565      * defined by `root`. For this, a `proof` must be provided, containing
1566      * sibling hashes on the branch from the leaf to the root of the tree. Each
1567      * pair of leaves and each pair of pre-images are assumed to be sorted.
1568      */
1569     function verify(
1570         bytes32[] memory proof,
1571         bytes32 root,
1572         bytes32 leaf
1573     ) internal pure returns (bool) {
1574         return processProof(proof, leaf) == root;
1575     }
1576 
1577     /**
1578      * @dev Calldata version of {verify}
1579      *
1580      * _Available since v4.7._
1581      */
1582     function verifyCalldata(
1583         bytes32[] calldata proof,
1584         bytes32 root,
1585         bytes32 leaf
1586     ) internal pure returns (bool) {
1587         return processProofCalldata(proof, leaf) == root;
1588     }
1589 
1590     /**
1591      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1592      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1593      * hash matches the root of the tree. When processing the proof, the pairs
1594      * of leafs & pre-images are assumed to be sorted.
1595      *
1596      * _Available since v4.4._
1597      */
1598     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1599         bytes32 computedHash = leaf;
1600         for (uint256 i = 0; i < proof.length; i++) {
1601             computedHash = _hashPair(computedHash, proof[i]);
1602         }
1603         return computedHash;
1604     }
1605 
1606     /**
1607      * @dev Calldata version of {processProof}
1608      *
1609      * _Available since v4.7._
1610      */
1611     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
1612         bytes32 computedHash = leaf;
1613         for (uint256 i = 0; i < proof.length; i++) {
1614             computedHash = _hashPair(computedHash, proof[i]);
1615         }
1616         return computedHash;
1617     }
1618 
1619     /**
1620      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
1621      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
1622      *
1623      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
1624      *
1625      * _Available since v4.7._
1626      */
1627     function multiProofVerify(
1628         bytes32[] memory proof,
1629         bool[] memory proofFlags,
1630         bytes32 root,
1631         bytes32[] memory leaves
1632     ) internal pure returns (bool) {
1633         return processMultiProof(proof, proofFlags, leaves) == root;
1634     }
1635 
1636     /**
1637      * @dev Calldata version of {multiProofVerify}
1638      *
1639      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
1640      *
1641      * _Available since v4.7._
1642      */
1643     function multiProofVerifyCalldata(
1644         bytes32[] calldata proof,
1645         bool[] calldata proofFlags,
1646         bytes32 root,
1647         bytes32[] memory leaves
1648     ) internal pure returns (bool) {
1649         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
1650     }
1651 
1652     /**
1653      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
1654      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
1655      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
1656      * respectively.
1657      *
1658      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
1659      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
1660      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
1661      *
1662      * _Available since v4.7._
1663      */
1664     function processMultiProof(
1665         bytes32[] memory proof,
1666         bool[] memory proofFlags,
1667         bytes32[] memory leaves
1668     ) internal pure returns (bytes32 merkleRoot) {
1669         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1670         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1671         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1672         // the merkle tree.
1673         uint256 leavesLen = leaves.length;
1674         uint256 totalHashes = proofFlags.length;
1675 
1676         // Check proof validity.
1677         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1678 
1679         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1680         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1681         bytes32[] memory hashes = new bytes32[](totalHashes);
1682         uint256 leafPos = 0;
1683         uint256 hashPos = 0;
1684         uint256 proofPos = 0;
1685         // At each step, we compute the next hash using two values:
1686         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1687         //   get the next hash.
1688         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1689         //   `proof` array.
1690         for (uint256 i = 0; i < totalHashes; i++) {
1691             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1692             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1693             hashes[i] = _hashPair(a, b);
1694         }
1695 
1696         if (totalHashes > 0) {
1697             return hashes[totalHashes - 1];
1698         } else if (leavesLen > 0) {
1699             return leaves[0];
1700         } else {
1701             return proof[0];
1702         }
1703     }
1704 
1705     /**
1706      * @dev Calldata version of {processMultiProof}.
1707      *
1708      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
1709      *
1710      * _Available since v4.7._
1711      */
1712     function processMultiProofCalldata(
1713         bytes32[] calldata proof,
1714         bool[] calldata proofFlags,
1715         bytes32[] memory leaves
1716     ) internal pure returns (bytes32 merkleRoot) {
1717         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1718         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1719         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1720         // the merkle tree.
1721         uint256 leavesLen = leaves.length;
1722         uint256 totalHashes = proofFlags.length;
1723 
1724         // Check proof validity.
1725         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1726 
1727         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1728         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1729         bytes32[] memory hashes = new bytes32[](totalHashes);
1730         uint256 leafPos = 0;
1731         uint256 hashPos = 0;
1732         uint256 proofPos = 0;
1733         // At each step, we compute the next hash using two values:
1734         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1735         //   get the next hash.
1736         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1737         //   `proof` array.
1738         for (uint256 i = 0; i < totalHashes; i++) {
1739             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1740             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1741             hashes[i] = _hashPair(a, b);
1742         }
1743 
1744         if (totalHashes > 0) {
1745             return hashes[totalHashes - 1];
1746         } else if (leavesLen > 0) {
1747             return leaves[0];
1748         } else {
1749             return proof[0];
1750         }
1751     }
1752 
1753     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
1754         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
1755     }
1756 
1757     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1758         /// @solidity memory-safe-assembly
1759         assembly {
1760             mstore(0x00, a)
1761             mstore(0x20, b)
1762             value := keccak256(0x00, 0x40)
1763         }
1764     }
1765 }
1766 
1767 // File: @openzeppelin/contracts/utils/math/Math.sol
1768 
1769 
1770 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
1771 
1772 pragma solidity ^0.8.0;
1773 
1774 /**
1775  * @dev Standard math utilities missing in the Solidity language.
1776  */
1777 library Math {
1778     enum Rounding {
1779         Down, // Toward negative infinity
1780         Up, // Toward infinity
1781         Zero // Toward zero
1782     }
1783 
1784     /**
1785      * @dev Returns the largest of two numbers.
1786      */
1787     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1788         return a > b ? a : b;
1789     }
1790 
1791     /**
1792      * @dev Returns the smallest of two numbers.
1793      */
1794     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1795         return a < b ? a : b;
1796     }
1797 
1798     /**
1799      * @dev Returns the average of two numbers. The result is rounded towards
1800      * zero.
1801      */
1802     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1803         // (a + b) / 2 can overflow.
1804         return (a & b) + (a ^ b) / 2;
1805     }
1806 
1807     /**
1808      * @dev Returns the ceiling of the division of two numbers.
1809      *
1810      * This differs from standard division with `/` in that it rounds up instead
1811      * of rounding down.
1812      */
1813     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
1814         // (a + b - 1) / b can overflow on addition, so we distribute.
1815         return a == 0 ? 0 : (a - 1) / b + 1;
1816     }
1817 
1818     /**
1819      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
1820      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
1821      * with further edits by Uniswap Labs also under MIT license.
1822      */
1823     function mulDiv(
1824         uint256 x,
1825         uint256 y,
1826         uint256 denominator
1827     ) internal pure returns (uint256 result) {
1828         unchecked {
1829             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
1830             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
1831             // variables such that product = prod1 * 2^256 + prod0.
1832             uint256 prod0; // Least significant 256 bits of the product
1833             uint256 prod1; // Most significant 256 bits of the product
1834             assembly {
1835                 let mm := mulmod(x, y, not(0))
1836                 prod0 := mul(x, y)
1837                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
1838             }
1839 
1840             // Handle non-overflow cases, 256 by 256 division.
1841             if (prod1 == 0) {
1842                 return prod0 / denominator;
1843             }
1844 
1845             // Make sure the result is less than 2^256. Also prevents denominator == 0.
1846             require(denominator > prod1);
1847 
1848             ///////////////////////////////////////////////
1849             // 512 by 256 division.
1850             ///////////////////////////////////////////////
1851 
1852             // Make division exact by subtracting the remainder from [prod1 prod0].
1853             uint256 remainder;
1854             assembly {
1855                 // Compute remainder using mulmod.
1856                 remainder := mulmod(x, y, denominator)
1857 
1858                 // Subtract 256 bit number from 512 bit number.
1859                 prod1 := sub(prod1, gt(remainder, prod0))
1860                 prod0 := sub(prod0, remainder)
1861             }
1862 
1863             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
1864             // See https://cs.stackexchange.com/q/138556/92363.
1865 
1866             // Does not overflow because the denominator cannot be zero at this stage in the function.
1867             uint256 twos = denominator & (~denominator + 1);
1868             assembly {
1869                 // Divide denominator by twos.
1870                 denominator := div(denominator, twos)
1871 
1872                 // Divide [prod1 prod0] by twos.
1873                 prod0 := div(prod0, twos)
1874 
1875                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
1876                 twos := add(div(sub(0, twos), twos), 1)
1877             }
1878 
1879             // Shift in bits from prod1 into prod0.
1880             prod0 |= prod1 * twos;
1881 
1882             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
1883             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
1884             // four bits. That is, denominator * inv = 1 mod 2^4.
1885             uint256 inverse = (3 * denominator) ^ 2;
1886 
1887             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
1888             // in modular arithmetic, doubling the correct bits in each step.
1889             inverse *= 2 - denominator * inverse; // inverse mod 2^8
1890             inverse *= 2 - denominator * inverse; // inverse mod 2^16
1891             inverse *= 2 - denominator * inverse; // inverse mod 2^32
1892             inverse *= 2 - denominator * inverse; // inverse mod 2^64
1893             inverse *= 2 - denominator * inverse; // inverse mod 2^128
1894             inverse *= 2 - denominator * inverse; // inverse mod 2^256
1895 
1896             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
1897             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
1898             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
1899             // is no longer required.
1900             result = prod0 * inverse;
1901             return result;
1902         }
1903     }
1904 
1905     /**
1906      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
1907      */
1908     function mulDiv(
1909         uint256 x,
1910         uint256 y,
1911         uint256 denominator,
1912         Rounding rounding
1913     ) internal pure returns (uint256) {
1914         uint256 result = mulDiv(x, y, denominator);
1915         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
1916             result += 1;
1917         }
1918         return result;
1919     }
1920 
1921     /**
1922      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
1923      *
1924      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
1925      */
1926     function sqrt(uint256 a) internal pure returns (uint256) {
1927         if (a == 0) {
1928             return 0;
1929         }
1930 
1931         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
1932         //
1933         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
1934         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
1935         //
1936         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
1937         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
1938         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
1939         //
1940         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
1941         uint256 result = 1 << (log2(a) >> 1);
1942 
1943         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
1944         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
1945         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
1946         // into the expected uint128 result.
1947         unchecked {
1948             result = (result + a / result) >> 1;
1949             result = (result + a / result) >> 1;
1950             result = (result + a / result) >> 1;
1951             result = (result + a / result) >> 1;
1952             result = (result + a / result) >> 1;
1953             result = (result + a / result) >> 1;
1954             result = (result + a / result) >> 1;
1955             return min(result, a / result);
1956         }
1957     }
1958 
1959     /**
1960      * @notice Calculates sqrt(a), following the selected rounding direction.
1961      */
1962     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
1963         unchecked {
1964             uint256 result = sqrt(a);
1965             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
1966         }
1967     }
1968 
1969     /**
1970      * @dev Return the log in base 2, rounded down, of a positive value.
1971      * Returns 0 if given 0.
1972      */
1973     function log2(uint256 value) internal pure returns (uint256) {
1974         uint256 result = 0;
1975         unchecked {
1976             if (value >> 128 > 0) {
1977                 value >>= 128;
1978                 result += 128;
1979             }
1980             if (value >> 64 > 0) {
1981                 value >>= 64;
1982                 result += 64;
1983             }
1984             if (value >> 32 > 0) {
1985                 value >>= 32;
1986                 result += 32;
1987             }
1988             if (value >> 16 > 0) {
1989                 value >>= 16;
1990                 result += 16;
1991             }
1992             if (value >> 8 > 0) {
1993                 value >>= 8;
1994                 result += 8;
1995             }
1996             if (value >> 4 > 0) {
1997                 value >>= 4;
1998                 result += 4;
1999             }
2000             if (value >> 2 > 0) {
2001                 value >>= 2;
2002                 result += 2;
2003             }
2004             if (value >> 1 > 0) {
2005                 result += 1;
2006             }
2007         }
2008         return result;
2009     }
2010 
2011     /**
2012      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
2013      * Returns 0 if given 0.
2014      */
2015     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
2016         unchecked {
2017             uint256 result = log2(value);
2018             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
2019         }
2020     }
2021 
2022     /**
2023      * @dev Return the log in base 10, rounded down, of a positive value.
2024      * Returns 0 if given 0.
2025      */
2026     function log10(uint256 value) internal pure returns (uint256) {
2027         uint256 result = 0;
2028         unchecked {
2029             if (value >= 10**64) {
2030                 value /= 10**64;
2031                 result += 64;
2032             }
2033             if (value >= 10**32) {
2034                 value /= 10**32;
2035                 result += 32;
2036             }
2037             if (value >= 10**16) {
2038                 value /= 10**16;
2039                 result += 16;
2040             }
2041             if (value >= 10**8) {
2042                 value /= 10**8;
2043                 result += 8;
2044             }
2045             if (value >= 10**4) {
2046                 value /= 10**4;
2047                 result += 4;
2048             }
2049             if (value >= 10**2) {
2050                 value /= 10**2;
2051                 result += 2;
2052             }
2053             if (value >= 10**1) {
2054                 result += 1;
2055             }
2056         }
2057         return result;
2058     }
2059 
2060     /**
2061      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
2062      * Returns 0 if given 0.
2063      */
2064     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
2065         unchecked {
2066             uint256 result = log10(value);
2067             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
2068         }
2069     }
2070 
2071     /**
2072      * @dev Return the log in base 256, rounded down, of a positive value.
2073      * Returns 0 if given 0.
2074      *
2075      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
2076      */
2077     function log256(uint256 value) internal pure returns (uint256) {
2078         uint256 result = 0;
2079         unchecked {
2080             if (value >> 128 > 0) {
2081                 value >>= 128;
2082                 result += 16;
2083             }
2084             if (value >> 64 > 0) {
2085                 value >>= 64;
2086                 result += 8;
2087             }
2088             if (value >> 32 > 0) {
2089                 value >>= 32;
2090                 result += 4;
2091             }
2092             if (value >> 16 > 0) {
2093                 value >>= 16;
2094                 result += 2;
2095             }
2096             if (value >> 8 > 0) {
2097                 result += 1;
2098             }
2099         }
2100         return result;
2101     }
2102 
2103     /**
2104      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
2105      * Returns 0 if given 0.
2106      */
2107     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
2108         unchecked {
2109             uint256 result = log256(value);
2110             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
2111         }
2112     }
2113 }
2114 
2115 // File: @openzeppelin/contracts/utils/Strings.sol
2116 
2117 
2118 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
2119 
2120 pragma solidity ^0.8.0;
2121 
2122 
2123 /**
2124  * @dev String operations.
2125  */
2126 library Strings {
2127     bytes16 private constant _SYMBOLS = "0123456789abcdef";
2128     uint8 private constant _ADDRESS_LENGTH = 20;
2129 
2130     /**
2131      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
2132      */
2133     function toString(uint256 value) internal pure returns (string memory) {
2134         unchecked {
2135             uint256 length = Math.log10(value) + 1;
2136             string memory buffer = new string(length);
2137             uint256 ptr;
2138             /// @solidity memory-safe-assembly
2139             assembly {
2140                 ptr := add(buffer, add(32, length))
2141             }
2142             while (true) {
2143                 ptr--;
2144                 /// @solidity memory-safe-assembly
2145                 assembly {
2146                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
2147                 }
2148                 value /= 10;
2149                 if (value == 0) break;
2150             }
2151             return buffer;
2152         }
2153     }
2154 
2155     /**
2156      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
2157      */
2158     function toHexString(uint256 value) internal pure returns (string memory) {
2159         unchecked {
2160             return toHexString(value, Math.log256(value) + 1);
2161         }
2162     }
2163 
2164     /**
2165      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
2166      */
2167     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
2168         bytes memory buffer = new bytes(2 * length + 2);
2169         buffer[0] = "0";
2170         buffer[1] = "x";
2171         for (uint256 i = 2 * length + 1; i > 1; --i) {
2172             buffer[i] = _SYMBOLS[value & 0xf];
2173             value >>= 4;
2174         }
2175         require(value == 0, "Strings: hex length insufficient");
2176         return string(buffer);
2177     }
2178 
2179     /**
2180      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
2181      */
2182     function toHexString(address addr) internal pure returns (string memory) {
2183         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
2184     }
2185 }
2186 
2187 // File: @openzeppelin/contracts/utils/Context.sol
2188 
2189 
2190 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
2191 
2192 pragma solidity ^0.8.0;
2193 
2194 /**
2195  * @dev Provides information about the current execution context, including the
2196  * sender of the transaction and its data. While these are generally available
2197  * via msg.sender and msg.data, they should not be accessed in such a direct
2198  * manner, since when dealing with meta-transactions the account sending and
2199  * paying for execution may not be the actual sender (as far as an application
2200  * is concerned).
2201  *
2202  * This contract is only required for intermediate, library-like contracts.
2203  */
2204 abstract contract Context {
2205     function _msgSender() internal view virtual returns (address) {
2206         return msg.sender;
2207     }
2208 
2209     function _msgData() internal view virtual returns (bytes calldata) {
2210         return msg.data;
2211     }
2212 }
2213 
2214 // File: @openzeppelin/contracts/access/Ownable.sol
2215 
2216 
2217 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
2218 
2219 pragma solidity ^0.8.0;
2220 
2221 
2222 /**
2223  * @dev Contract module which provides a basic access control mechanism, where
2224  * there is an account (an owner) that can be granted exclusive access to
2225  * specific functions.
2226  *
2227  * By default, the owner account will be the one that deploys the contract. This
2228  * can later be changed with {transferOwnership}.
2229  *
2230  * This module is used through inheritance. It will make available the modifier
2231  * `onlyOwner`, which can be applied to your functions to restrict their use to
2232  * the owner.
2233  */
2234 abstract contract Ownable is Context {
2235     address private _owner;
2236 
2237     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2238 
2239     /**
2240      * @dev Initializes the contract setting the deployer as the initial owner.
2241      */
2242     constructor() {
2243         _transferOwnership(_msgSender());
2244     }
2245 
2246     /**
2247      * @dev Throws if called by any account other than the owner.
2248      */
2249     modifier onlyOwner() {
2250         _checkOwner();
2251         _;
2252     }
2253 
2254     /**
2255      * @dev Returns the address of the current owner.
2256      */
2257     function owner() public view virtual returns (address) {
2258         return _owner;
2259     }
2260 
2261     /**
2262      * @dev Throws if the sender is not the owner.
2263      */
2264     function _checkOwner() internal view virtual {
2265         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2266     }
2267 
2268     /**
2269      * @dev Leaves the contract without owner. It will not be possible to call
2270      * `onlyOwner` functions anymore. Can only be called by the current owner.
2271      *
2272      * NOTE: Renouncing ownership will leave the contract without an owner,
2273      * thereby removing any functionality that is only available to the owner.
2274      */
2275     function renounceOwnership() public virtual onlyOwner {
2276         _transferOwnership(address(0));
2277     }
2278 
2279     /**
2280      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2281      * Can only be called by the current owner.
2282      */
2283     function transferOwnership(address newOwner) public virtual onlyOwner {
2284         require(newOwner != address(0), "Ownable: new owner is the zero address");
2285         _transferOwnership(newOwner);
2286     }
2287 
2288     /**
2289      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2290      * Internal function without access restriction.
2291      */
2292     function _transferOwnership(address newOwner) internal virtual {
2293         address oldOwner = _owner;
2294         _owner = newOwner;
2295         emit OwnershipTransferred(oldOwner, newOwner);
2296     }
2297 }
2298 
2299 // File: contracts/DexbotsWorldCup.sol
2300 
2301 
2302 
2303 pragma solidity ^0.8.4;
2304 
2305 
2306 
2307 
2308 
2309 
2310 
2311 interface Dexbot {
2312 
2313     function balanceOf(address _owner) external view returns (uint256);
2314 
2315 
2316 
2317     function ownerOf(uint256 tokenId) external view returns (address owner);
2318 
2319 }
2320 
2321 
2322 
2323 contract DexbotsWorldCup is ERC721A, Ownable {
2324 
2325     constructor(
2326 
2327         string memory _name,
2328 
2329         string memory _symbol,
2330 
2331         string memory _uriPrefix,
2332 
2333         address _dexbotsAddress
2334 
2335     ) ERC721A(_name, _symbol) {
2336 
2337         uriPrefix = _uriPrefix;
2338 
2339         dexbotsContract = Dexbot(_dexbotsAddress);
2340 
2341     }
2342 
2343 
2344 
2345     Dexbot dexbotsContract;
2346 
2347 
2348 
2349     uint256 public currentMinting = 3;
2350 
2351 
2352 
2353     uint256 public maxSupply = 2000;
2354 
2355     uint256 public maxMintPerTx = 3;
2356 
2357     uint256 public price = 0.0 ether;
2358 
2359 
2360 
2361     uint256 public maxDevMints = 500;
2362 
2363     uint256 public devMints = 0;
2364 
2365 
2366 
2367     mapping(uint256 => bool) public dexbotMinted;
2368 
2369 
2370 
2371     string public uriPrefix;
2372 
2373 
2374 
2375     function setMaxSupply(uint256 _maxSupply) public onlyOwner {
2376 
2377         require(_maxSupply > 0, "Max supply must be greater than 0!");
2378 
2379         require(
2380 
2381             _maxSupply < maxSupply,
2382 
2383             "Max supply must be less than the current max supply!"
2384 
2385         );
2386 
2387         maxSupply = _maxSupply;
2388 
2389     }
2390 
2391 
2392 
2393     function setMaxMintPerTx(uint256 _maxMintPerTx) public onlyOwner {
2394 
2395         require(_maxMintPerTx > 0, "Max mint per tx must be greater than 0!");
2396 
2397         maxMintPerTx = _maxMintPerTx;
2398 
2399     }
2400 
2401 
2402 
2403     function setCurrentMinting(uint256 _currentMinting) public onlyOwner {
2404 
2405         require(
2406 
2407             _currentMinting >= 0 && _currentMinting <= 3,
2408 
2409             "Current minting must be between 0 and 3!"
2410 
2411         );
2412 
2413         currentMinting = _currentMinting;
2414 
2415     }
2416 
2417 
2418 
2419     function setPrice(uint256 _price) public onlyOwner {
2420 
2421         require(_price > 0, "Price must be greater than 0!");
2422 
2423         price = _price * 1 ether;
2424 
2425     }
2426 
2427 
2428 
2429     function setUriPrefix(string memory _uriPrefix) public onlyOwner {
2430 
2431         uriPrefix = _uriPrefix;
2432 
2433     }
2434 
2435 
2436 
2437     function tokenURI(uint256 _tokenId)
2438 
2439         public
2440 
2441         view
2442 
2443         virtual
2444 
2445         override
2446 
2447         returns (string memory)
2448 
2449     {
2450 
2451         if (!_exists(_tokenId)) revert URIQueryForNonexistentToken();
2452 
2453 
2454 
2455         return
2456 
2457             bytes(uriPrefix).length != 0
2458 
2459                 ? string(
2460 
2461                     abi.encodePacked(
2462 
2463                         uriPrefix,
2464 
2465                         Strings.toString(_tokenId),
2466 
2467                         ".json"
2468 
2469                     )
2470 
2471                 )
2472 
2473                 : "";
2474 
2475     }
2476 
2477 
2478 
2479     function _safeSaveDexbots(uint256[] memory _dexbots) internal {
2480 
2481         uint256 dexbotsCount = _dexbots.length;
2482 
2483 
2484 
2485         for (uint256 i = 0; i < dexbotsCount; i++) {
2486 
2487             uint256 currentDexbot = _dexbots[i];
2488 
2489 
2490 
2491             address currentOwner = dexbotsContract.ownerOf(currentDexbot);
2492 
2493 
2494 
2495             require(
2496 
2497                 currentOwner == msg.sender,
2498 
2499                 "You can only select your own NFTs"
2500 
2501             );
2502 
2503 
2504 
2505             require(
2506 
2507                 !dexbotMinted[currentDexbot],
2508 
2509                 "You can only select NFTs that have not been claimed"
2510 
2511             );
2512 
2513 
2514 
2515             dexbotMinted[currentDexbot] = true;
2516 
2517         }
2518 
2519     }
2520 
2521 
2522 
2523     function dexbotMint(uint256[] memory _dexbots) public {
2524 
2525         require(
2526 
2527             currentMinting == 0 || currentMinting == 2,
2528 
2529             "Minting is not open yet"
2530 
2531         );
2532 
2533         
2534 
2535         require(
2536 
2537             _dexbots.length * 2 + totalSupply() <= maxSupply,
2538 
2539             "Max supply exceeded!"
2540 
2541         );
2542 
2543 
2544 
2545         require(_dexbots.length > 0, "You must select at least one NFT");
2546 
2547 
2548 
2549         require(
2550 
2551             dexbotsContract.balanceOf(msg.sender) >= _dexbots.length,
2552 
2553             "You do not own enough NFTs"
2554 
2555         );
2556 
2557 
2558 
2559         _safeSaveDexbots(_dexbots);
2560 
2561 
2562 
2563         _safeMint(msg.sender, _dexbots.length * 2);
2564 
2565     }
2566 
2567 
2568 
2569     // dev mint
2570 
2571     function devMint(uint256 _quantity) public onlyOwner {
2572 
2573         require(currentMinting == 3, "Dev minting is not active!");
2574 
2575         require(_quantity > 0, "Quantity must be greater than 0!");
2576 
2577         require(
2578 
2579             totalSupply() + _quantity <= maxSupply,
2580 
2581             "Quantity exceeds max supply!"
2582 
2583         );
2584 
2585         require(
2586 
2587             devMints + _quantity <= maxDevMints,
2588 
2589             "Quantity exceeds max allowed for devs!"
2590 
2591         );
2592 
2593 
2594 
2595         devMints += _quantity;
2596 
2597         _safeMint(msg.sender, _quantity);
2598 
2599     }
2600 
2601 
2602 
2603     function mint(uint256 _quantity) external payable {
2604 
2605         require(currentMinting == 2, "Public minting is not active!");
2606 
2607         require(_quantity <= maxMintPerTx, "Quantity exceeds max mint per tx!");
2608 
2609         require(_quantity + totalSupply() <= maxSupply, "Max supply exceeded!");
2610 
2611         require(msg.value == price * _quantity, "Insufficient funds to mint!");
2612 
2613 
2614 
2615         _safeMint(msg.sender, _quantity);
2616 
2617     }
2618 
2619 
2620 
2621     function withdraw() external onlyOwner {
2622 
2623         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
2624 
2625 
2626 
2627         require(os);
2628 
2629     }
2630 
2631 }