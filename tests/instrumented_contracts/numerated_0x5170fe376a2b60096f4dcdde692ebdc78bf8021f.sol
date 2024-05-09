1 // File: contracts/Seaman.sol
2 
3 
4 pragma solidity ^0.8.7;
5 
6 /** 
7  __    __  _______   _______    ______    ______  
8 /  |  /  |/       \ /       \  /      \  /      \ 
9 $$ |  $$ |$$$$$$$  |$$$$$$$  |/$$$$$$  |/$$$$$$  |
10 $$ |  $$ |$$ |__$$ |$$ |  $$ |$$ |__$$ |$$ |  $$ |
11 $$ |  $$ |$$    $$/ $$ |  $$ |$$    $$ |$$ |  $$ |
12 $$ |  $$ |$$$$$$$/  $$ |  $$ |$$$$$$$$ |$$ |  $$ |
13 $$ \__$$ |$$ |      $$ |__$$ |$$ |  $$ |$$ \__$$ |
14 $$    $$/ $$ |      $$    $$/ $$ |  $$ |$$    $$/ 
15  $$$$$$/  $$/       $$$$$$$/  $$/   $$/  $$$$$$/ 
16 
17 *
18 * This is the main contract that mints the Seaman NFT.
19 * 
20 * The UPDAO a diversified community of award-wining engineers, 
21 * product managers and NFT/WEB3 investors, with Great Sailing spirit in mind. 
22 * Our primary mission is to enable everyone to be a marketplace by building innovative products and tools. 
23 * We will connect NFTs with both real world and metaverse, bringing 100 million people into NFT world.
24 * 
25 **/
26 
27 // ERC721A Contracts v4.2.0
28 
29 /**
30  * @dev Interface of ERC721A.
31  */
32 interface IERC721A {
33     /**
34      * The caller must own the token or be an approved operator.
35      */
36     error ApprovalCallerNotOwnerNorApproved();
37 
38     /**
39      * The token does not exist.
40      */
41     error ApprovalQueryForNonexistentToken();
42 
43     /**
44      * The caller cannot approve to their own address.
45      */
46     error ApproveToCaller();
47 
48     /**
49      * Cannot query the balance for the zero address.
50      */
51     error BalanceQueryForZeroAddress();
52 
53     /**
54      * Cannot mint to the zero address.
55      */
56     error MintToZeroAddress();
57 
58     /**
59      * The quantity of tokens minted must be more than zero.
60      */
61     error MintZeroQuantity();
62 
63     /**
64      * The token does not exist.
65      */
66     error OwnerQueryForNonexistentToken();
67 
68     /**
69      * The caller must own the token or be an approved operator.
70      */
71     error TransferCallerNotOwnerNorApproved();
72 
73     /**
74      * The token must be owned by `from`.
75      */
76     error TransferFromIncorrectOwner();
77 
78     /**
79      * Cannot safely transfer to a contract that does not implement the
80      * ERC721Receiver interface.
81      */
82     error TransferToNonERC721ReceiverImplementer();
83 
84     /**
85      * Cannot transfer to the zero address.
86      */
87     error TransferToZeroAddress();
88 
89     /**
90      * The token does not exist.
91      */
92     error URIQueryForNonexistentToken();
93 
94     /**
95      * The `quantity` minted with ERC2309 exceeds the safety limit.
96      */
97     error MintERC2309QuantityExceedsLimit();
98 
99     /**
100      * The `extraData` cannot be set on an unintialized ownership slot.
101      */
102     error OwnershipNotInitializedForExtraData();
103 
104     // =============================================================
105     //                            STRUCTS
106     // =============================================================
107 
108     struct TokenOwnership {
109         // The address of the owner.
110         address addr;
111         // Stores the start time of ownership with minimal overhead for tokenomics.
112         uint64 startTimestamp;
113         // Whether the token has been burned.
114         bool burned;
115         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
116         uint24 extraData;
117     }
118 
119     // =============================================================
120     //                         TOKEN COUNTERS
121     // =============================================================
122 
123     /**
124      * @dev Returns the total number of tokens in existence.
125      * Burned tokens will reduce the count.
126      * To get the total number of tokens minted, please see {_totalMinted}.
127      */
128     function totalSupply() external view returns (uint256);
129 
130     // =============================================================
131     //                            IERC165
132     // =============================================================
133 
134     /**
135      * @dev Returns true if this contract implements the interface defined by
136      * `interfaceId`. See the corresponding
137      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
138      * to learn more about how these ids are created.
139      *
140      * This function call must use less than 30000 gas.
141      */
142     function supportsInterface(bytes4 interfaceId) external view returns (bool);
143 
144     // =============================================================
145     //                            IERC721
146     // =============================================================
147 
148     /**
149      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
150      */
151     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
152 
153     /**
154      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
155      */
156     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
157 
158     /**
159      * @dev Emitted when `owner` enables or disables
160      * (`approved`) `operator` to manage all of its assets.
161      */
162     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
163 
164     /**
165      * @dev Returns the number of tokens in `owner`'s account.
166      */
167     function balanceOf(address owner) external view returns (uint256 balance);
168 
169     /**
170      * @dev Returns the owner of the `tokenId` token.
171      *
172      * Requirements:
173      *
174      * - `tokenId` must exist.
175      */
176     function ownerOf(uint256 tokenId) external view returns (address owner);
177 
178     /**
179      * @dev Safely transfers `tokenId` token from `from` to `to`,
180      * checking first that contract recipients are aware of the ERC721 protocol
181      * to prevent tokens from being forever locked.
182      *
183      * Requirements:
184      *
185      * - `from` cannot be the zero address.
186      * - `to` cannot be the zero address.
187      * - `tokenId` token must exist and be owned by `from`.
188      * - If the caller is not `from`, it must be have been allowed to move
189      * this token by either {approve} or {setApprovalForAll}.
190      * - If `to` refers to a smart contract, it must implement
191      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
192      *
193      * Emits a {Transfer} event.
194      */
195     function safeTransferFrom(
196         address from,
197         address to,
198         uint256 tokenId,
199         bytes calldata data
200     ) external;
201 
202     /**
203      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
204      */
205     function safeTransferFrom(
206         address from,
207         address to,
208         uint256 tokenId
209     ) external;
210 
211     /**
212      * @dev Transfers `tokenId` from `from` to `to`.
213      *
214      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
215      * whenever possible.
216      *
217      * Requirements:
218      *
219      * - `from` cannot be the zero address.
220      * - `to` cannot be the zero address.
221      * - `tokenId` token must be owned by `from`.
222      * - If the caller is not `from`, it must be approved to move this token
223      * by either {approve} or {setApprovalForAll}.
224      *
225      * Emits a {Transfer} event.
226      */
227     function transferFrom(
228         address from,
229         address to,
230         uint256 tokenId
231     ) external;
232 
233     /**
234      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
235      * The approval is cleared when the token is transferred.
236      *
237      * Only a single account can be approved at a time, so approving the
238      * zero address clears previous approvals.
239      *
240      * Requirements:
241      *
242      * - The caller must own the token or be an approved operator.
243      * - `tokenId` must exist.
244      *
245      * Emits an {Approval} event.
246      */
247     function approve(address to, uint256 tokenId) external;
248 
249     /**
250      * @dev Approve or remove `operator` as an operator for the caller.
251      * Operators can call {transferFrom} or {safeTransferFrom}
252      * for any token owned by the caller.
253      *
254      * Requirements:
255      *
256      * - The `operator` cannot be the caller.
257      *
258      * Emits an {ApprovalForAll} event.
259      */
260     function setApprovalForAll(address operator, bool _approved) external;
261 
262     /**
263      * @dev Returns the account approved for `tokenId` token.
264      *
265      * Requirements:
266      *
267      * - `tokenId` must exist.
268      */
269     function getApproved(uint256 tokenId) external view returns (address operator);
270 
271     /**
272      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
273      *
274      * See {setApprovalForAll}.
275      */
276     function isApprovedForAll(address owner, address operator) external view returns (bool);
277 
278     // =============================================================
279     //                        IERC721Metadata
280     // =============================================================
281 
282     /**
283      * @dev Returns the token collection name.
284      */
285     function name() external view returns (string memory);
286 
287     /**
288      * @dev Returns the token collection symbol.
289      */
290     function symbol() external view returns (string memory);
291 
292     /**
293      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
294      */
295     function tokenURI(uint256 tokenId) external view returns (string memory);
296 
297     // =============================================================
298     //                           IERC2309
299     // =============================================================
300 
301     /**
302      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
303      * (inclusive) is transferred from `from` to `to`, as defined in the
304      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
305      *
306      * See {_mintERC2309} for more details.
307      */
308     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
309 }
310 
311 /**
312  * @dev Interface of ERC721 token receiver.
313  */
314 interface ERC721A__IERC721Receiver {
315     function onERC721Received(
316         address operator,
317         address from,
318         uint256 tokenId,
319         bytes calldata data
320     ) external returns (bytes4);
321 }
322 
323 /**
324  * @title ERC721A
325  *
326  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
327  * Non-Fungible Token Standard, including the Metadata extension.
328  * Optimized for lower gas during batch mints.
329  *
330  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
331  * starting from `_startTokenId()`.
332  *
333  * Assumptions:
334  *
335  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
336  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
337  */
338 contract ERC721A is IERC721A {
339     // Reference type for token approval.
340     struct TokenApprovalRef {
341         address value;
342     }
343 
344     // =============================================================
345     //                           CONSTANTS
346     // =============================================================
347 
348     // Mask of an entry in packed address data.
349     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
350 
351     // The bit position of `numberMinted` in packed address data.
352     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
353 
354     // The bit position of `numberBurned` in packed address data.
355     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
356 
357     // The bit position of `aux` in packed address data.
358     uint256 private constant _BITPOS_AUX = 192;
359 
360     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
361     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
362 
363     // The bit position of `startTimestamp` in packed ownership.
364     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
365 
366     // The bit mask of the `burned` bit in packed ownership.
367     uint256 private constant _BITMASK_BURNED = 1 << 224;
368 
369     // The bit position of the `nextInitialized` bit in packed ownership.
370     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
371 
372     // The bit mask of the `nextInitialized` bit in packed ownership.
373     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
374 
375     // The bit position of `extraData` in packed ownership.
376     uint256 private constant _BITPOS_EXTRA_DATA = 232;
377 
378     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
379     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
380 
381     // The mask of the lower 160 bits for addresses.
382     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
383 
384     // The maximum `quantity` that can be minted with {_mintERC2309}.
385     // This limit is to prevent overflows on the address data entries.
386     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
387     // is required to cause an overflow, which is unrealistic.
388     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
389 
390     // The `Transfer` event signature is given by:
391     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
392     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
393         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
394 
395     // =============================================================
396     //                            STORAGE
397     // =============================================================
398 
399     // The next token ID to be minted.
400     uint256 private _currentIndex;
401 
402     // The number of tokens burned.
403     uint256 private _burnCounter;
404 
405     // Token name
406     string private _name;
407 
408     // Token symbol
409     string private _symbol;
410 
411     // Mapping from token ID to ownership details
412     // An empty struct value does not necessarily mean the token is unowned.
413     // See {_packedOwnershipOf} implementation for details.
414     //
415     // Bits Layout:
416     // - [0..159]   `addr`
417     // - [160..223] `startTimestamp`
418     // - [224]      `burned`
419     // - [225]      `nextInitialized`
420     // - [232..255] `extraData`
421     mapping(uint256 => uint256) private _packedOwnerships;
422 
423     // Mapping owner address to address data.
424     //
425     // Bits Layout:
426     // - [0..63]    `balance`
427     // - [64..127]  `numberMinted`
428     // - [128..191] `numberBurned`
429     // - [192..255] `aux`
430     mapping(address => uint256) private _packedAddressData;
431 
432     // Mapping from token ID to approved address.
433     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
434 
435     // Mapping from owner to operator approvals
436     mapping(address => mapping(address => bool)) private _operatorApprovals;
437 
438     // =============================================================
439     //                          CONSTRUCTOR
440     // =============================================================
441 
442     constructor(string memory name_, string memory symbol_) {
443         _name = name_;
444         _symbol = symbol_;
445         _currentIndex = _startTokenId();
446     }
447 
448     // =============================================================
449     //                   TOKEN COUNTING OPERATIONS
450     // =============================================================
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
463     function _nextTokenId() internal view virtual returns (uint256) {
464         return _currentIndex;
465     }
466 
467     /**
468      * @dev Returns the total number of tokens in existence.
469      * Burned tokens will reduce the count.
470      * To get the total number of tokens minted, please see {_totalMinted}.
471      */
472     function totalSupply() public view virtual override returns (uint256) {
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
483     function _totalMinted() internal view virtual returns (uint256) {
484         // Counter underflow is impossible as `_currentIndex` does not decrement,
485         // and it is initialized to `_startTokenId()`.
486         unchecked {
487             return _currentIndex - _startTokenId();
488         }
489     }
490 
491     /**
492      * @dev Returns the total number of tokens burned.
493      */
494     function _totalBurned() internal view virtual returns (uint256) {
495         return _burnCounter;
496     }
497 
498     // =============================================================
499     //                    ADDRESS DATA OPERATIONS
500     // =============================================================
501 
502     /**
503      * @dev Returns the number of tokens in `owner`'s account.
504      */
505     function balanceOf(address owner) public view virtual override returns (uint256) {
506         if (owner == address(0)) revert BalanceQueryForZeroAddress();
507         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
508     }
509 
510     /**
511      * Returns the number of tokens minted by `owner`.
512      */
513     function _numberMinted(address owner) internal view returns (uint256) {
514         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
515     }
516 
517     /**
518      * Returns the number of tokens burned by or on behalf of `owner`.
519      */
520     function _numberBurned(address owner) internal view returns (uint256) {
521         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
522     }
523 
524     /**
525      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
526      */
527     function _getAux(address owner) internal view returns (uint64) {
528         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
529     }
530 
531     /**
532      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
533      * If there are multiple variables, please pack them into a uint64.
534      */
535     function _setAux(address owner, uint64 aux) internal virtual {
536         uint256 packed = _packedAddressData[owner];
537         uint256 auxCasted;
538         // Cast `aux` with assembly to avoid redundant masking.
539         assembly {
540             auxCasted := aux
541         }
542         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
543         _packedAddressData[owner] = packed;
544     }
545 
546     // =============================================================
547     //                            IERC165
548     // =============================================================
549 
550     /**
551      * @dev Returns true if this contract implements the interface defined by
552      * `interfaceId`. See the corresponding
553      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
554      * to learn more about how these ids are created.
555      *
556      * This function call must use less than 30000 gas.
557      */
558     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
559         // The interface IDs are constants representing the first 4 bytes
560         // of the XOR of all function selectors in the interface.
561         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
562         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
563         return
564             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
565             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
566             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
567     }
568 
569     // =============================================================
570     //                        IERC721Metadata
571     // =============================================================
572 
573     /**
574      * @dev Returns the token collection name.
575      */
576     function name() public view virtual override returns (string memory) {
577         return _name;
578     }
579 
580     /**
581      * @dev Returns the token collection symbol.
582      */
583     function symbol() public view virtual override returns (string memory) {
584         return _symbol;
585     }
586 
587     /**
588      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
589      */
590     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
591         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
592 
593         string memory baseURI = _baseURI();
594         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
595     }
596 
597     /**
598      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
599      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
600      * by default, it can be overridden in child contracts.
601      */
602     function _baseURI() internal view virtual returns (string memory) {
603         return '';
604     }
605 
606     // =============================================================
607     //                     OWNERSHIPS OPERATIONS
608     // =============================================================
609 
610     /**
611      * @dev Returns the owner of the `tokenId` token.
612      *
613      * Requirements:
614      *
615      * - `tokenId` must exist.
616      */
617     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
618         return address(uint160(_packedOwnershipOf(tokenId)));
619     }
620 
621     /**
622      * @dev Gas spent here starts off proportional to the maximum mint batch size.
623      * It gradually moves to O(1) as tokens get transferred around over time.
624      */
625     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
626         return _unpackedOwnership(_packedOwnershipOf(tokenId));
627     }
628 
629     /**
630      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
631      */
632     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
633         return _unpackedOwnership(_packedOwnerships[index]);
634     }
635 
636     /**
637      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
638      */
639     function _initializeOwnershipAt(uint256 index) internal virtual {
640         if (_packedOwnerships[index] == 0) {
641             _packedOwnerships[index] = _packedOwnershipOf(index);
642         }
643     }
644 
645     /**
646      * Returns the packed ownership data of `tokenId`.
647      */
648     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
649         uint256 curr = tokenId;
650 
651         unchecked {
652             if (_startTokenId() <= curr)
653                 if (curr < _currentIndex) {
654                     uint256 packed = _packedOwnerships[curr];
655                     // If not burned.
656                     if (packed & _BITMASK_BURNED == 0) {
657                         // Invariant:
658                         // There will always be an initialized ownership slot
659                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
660                         // before an unintialized ownership slot
661                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
662                         // Hence, `curr` will not underflow.
663                         //
664                         // We can directly compare the packed value.
665                         // If the address is zero, packed will be zero.
666                         while (packed == 0) {
667                             packed = _packedOwnerships[--curr];
668                         }
669                         return packed;
670                     }
671                 }
672         }
673         revert OwnerQueryForNonexistentToken();
674     }
675 
676     /**
677      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
678      */
679     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
680         ownership.addr = address(uint160(packed));
681         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
682         ownership.burned = packed & _BITMASK_BURNED != 0;
683         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
684     }
685 
686     /**
687      * @dev Packs ownership data into a single uint256.
688      */
689     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
690         assembly {
691             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
692             owner := and(owner, _BITMASK_ADDRESS)
693             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
694             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
695         }
696     }
697 
698     /**
699      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
700      */
701     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
702         // For branchless setting of the `nextInitialized` flag.
703         assembly {
704             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
705             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
706         }
707     }
708 
709     // =============================================================
710     //                      APPROVAL OPERATIONS
711     // =============================================================
712 
713     /**
714      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
715      * The approval is cleared when the token is transferred.
716      *
717      * Only a single account can be approved at a time, so approving the
718      * zero address clears previous approvals.
719      *
720      * Requirements:
721      *
722      * - The caller must own the token or be an approved operator.
723      * - `tokenId` must exist.
724      *
725      * Emits an {Approval} event.
726      */
727     function approve(address to, uint256 tokenId) public virtual override {
728         address owner = ownerOf(tokenId);
729 
730         if (_msgSenderERC721A() != owner)
731             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
732                 revert ApprovalCallerNotOwnerNorApproved();
733             }
734 
735         _tokenApprovals[tokenId].value = to;
736         emit Approval(owner, to, tokenId);
737     }
738 
739     /**
740      * @dev Returns the account approved for `tokenId` token.
741      *
742      * Requirements:
743      *
744      * - `tokenId` must exist.
745      */
746     function getApproved(uint256 tokenId) public view virtual override returns (address) {
747         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
748 
749         return _tokenApprovals[tokenId].value;
750     }
751 
752     /**
753      * @dev Approve or remove `operator` as an operator for the caller.
754      * Operators can call {transferFrom} or {safeTransferFrom}
755      * for any token owned by the caller.
756      *
757      * Requirements:
758      *
759      * - The `operator` cannot be the caller.
760      *
761      * Emits an {ApprovalForAll} event.
762      */
763     function setApprovalForAll(address operator, bool approved) public virtual override {
764         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
765 
766         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
767         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
768     }
769 
770     /**
771      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
772      *
773      * See {setApprovalForAll}.
774      */
775     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
776         return _operatorApprovals[owner][operator];
777     }
778 
779     /**
780      * @dev Returns whether `tokenId` exists.
781      *
782      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
783      *
784      * Tokens start existing when they are minted. See {_mint}.
785      */
786     function _exists(uint256 tokenId) internal view virtual returns (bool) {
787         return
788             _startTokenId() <= tokenId &&
789             tokenId < _currentIndex && // If within bounds,
790             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
791     }
792 
793     /**
794      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
795      */
796     function _isSenderApprovedOrOwner(
797         address approvedAddress,
798         address owner,
799         address msgSender
800     ) private pure returns (bool result) {
801         assembly {
802             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
803             owner := and(owner, _BITMASK_ADDRESS)
804             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
805             msgSender := and(msgSender, _BITMASK_ADDRESS)
806             // `msgSender == owner || msgSender == approvedAddress`.
807             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
808         }
809     }
810 
811     /**
812      * @dev Returns the storage slot and value for the approved address of `tokenId`.
813      */
814     function _getApprovedSlotAndAddress(uint256 tokenId)
815         private
816         view
817         returns (uint256 approvedAddressSlot, address approvedAddress)
818     {
819         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
820         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
821         assembly {
822             approvedAddressSlot := tokenApproval.slot
823             approvedAddress := sload(approvedAddressSlot)
824         }
825     }
826 
827     // =============================================================
828     //                      TRANSFER OPERATIONS
829     // =============================================================
830 
831     /**
832      * @dev Transfers `tokenId` from `from` to `to`.
833      *
834      * Requirements:
835      *
836      * - `from` cannot be the zero address.
837      * - `to` cannot be the zero address.
838      * - `tokenId` token must be owned by `from`.
839      * - If the caller is not `from`, it must be approved to move this token
840      * by either {approve} or {setApprovalForAll}.
841      *
842      * Emits a {Transfer} event.
843      */
844     function transferFrom(
845         address from,
846         address to,
847         uint256 tokenId
848     ) public virtual override {
849         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
850 
851         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
852 
853         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
854 
855         // The nested ifs save around 20+ gas over a compound boolean condition.
856         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
857             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
858 
859         if (to == address(0)) revert TransferToZeroAddress();
860 
861         _beforeTokenTransfers(from, to, tokenId, 1);
862 
863         // Clear approvals from the previous owner.
864         assembly {
865             if approvedAddress {
866                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
867                 sstore(approvedAddressSlot, 0)
868             }
869         }
870 
871         // Underflow of the sender's balance is impossible because we check for
872         // ownership above and the recipient's balance can't realistically overflow.
873         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
874         unchecked {
875             // We can directly increment and decrement the balances.
876             --_packedAddressData[from]; // Updates: `balance -= 1`.
877             ++_packedAddressData[to]; // Updates: `balance += 1`.
878 
879             // Updates:
880             // - `address` to the next owner.
881             // - `startTimestamp` to the timestamp of transfering.
882             // - `burned` to `false`.
883             // - `nextInitialized` to `true`.
884             _packedOwnerships[tokenId] = _packOwnershipData(
885                 to,
886                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
887             );
888 
889             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
890             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
891                 uint256 nextTokenId = tokenId + 1;
892                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
893                 if (_packedOwnerships[nextTokenId] == 0) {
894                     // If the next slot is within bounds.
895                     if (nextTokenId != _currentIndex) {
896                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
897                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
898                     }
899                 }
900             }
901         }
902 
903         emit Transfer(from, to, tokenId);
904         _afterTokenTransfers(from, to, tokenId, 1);
905     }
906 
907     /**
908      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
909      */
910     function safeTransferFrom(
911         address from,
912         address to,
913         uint256 tokenId
914     ) public virtual override {
915         safeTransferFrom(from, to, tokenId, '');
916     }
917 
918     /**
919      * @dev Safely transfers `tokenId` token from `from` to `to`.
920      *
921      * Requirements:
922      *
923      * - `from` cannot be the zero address.
924      * - `to` cannot be the zero address.
925      * - `tokenId` token must exist and be owned by `from`.
926      * - If the caller is not `from`, it must be approved to move this token
927      * by either {approve} or {setApprovalForAll}.
928      * - If `to` refers to a smart contract, it must implement
929      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
930      *
931      * Emits a {Transfer} event.
932      */
933     function safeTransferFrom(
934         address from,
935         address to,
936         uint256 tokenId,
937         bytes memory _data
938     ) public virtual override {
939         transferFrom(from, to, tokenId);
940         if (to.code.length != 0)
941             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
942                 revert TransferToNonERC721ReceiverImplementer();
943             }
944     }
945 
946     /**
947      * @dev Hook that is called before a set of serially-ordered token IDs
948      * are about to be transferred. This includes minting.
949      * And also called before burning one token.
950      *
951      * `startTokenId` - the first token ID to be transferred.
952      * `quantity` - the amount to be transferred.
953      *
954      * Calling conditions:
955      *
956      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
957      * transferred to `to`.
958      * - When `from` is zero, `tokenId` will be minted for `to`.
959      * - When `to` is zero, `tokenId` will be burned by `from`.
960      * - `from` and `to` are never both zero.
961      */
962     function _beforeTokenTransfers(
963         address from,
964         address to,
965         uint256 startTokenId,
966         uint256 quantity
967     ) internal virtual {}
968 
969     /**
970      * @dev Hook that is called after a set of serially-ordered token IDs
971      * have been transferred. This includes minting.
972      * And also called after one token has been burned.
973      *
974      * `startTokenId` - the first token ID to be transferred.
975      * `quantity` - the amount to be transferred.
976      *
977      * Calling conditions:
978      *
979      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
980      * transferred to `to`.
981      * - When `from` is zero, `tokenId` has been minted for `to`.
982      * - When `to` is zero, `tokenId` has been burned by `from`.
983      * - `from` and `to` are never both zero.
984      */
985     function _afterTokenTransfers(
986         address from,
987         address to,
988         uint256 startTokenId,
989         uint256 quantity
990     ) internal virtual {}
991 
992     /**
993      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
994      *
995      * `from` - Previous owner of the given token ID.
996      * `to` - Target address that will receive the token.
997      * `tokenId` - Token ID to be transferred.
998      * `_data` - Optional data to send along with the call.
999      *
1000      * Returns whether the call correctly returned the expected magic value.
1001      */
1002     function _checkContractOnERC721Received(
1003         address from,
1004         address to,
1005         uint256 tokenId,
1006         bytes memory _data
1007     ) private returns (bool) {
1008         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1009             bytes4 retval
1010         ) {
1011             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1012         } catch (bytes memory reason) {
1013             if (reason.length == 0) {
1014                 revert TransferToNonERC721ReceiverImplementer();
1015             } else {
1016                 assembly {
1017                     revert(add(32, reason), mload(reason))
1018                 }
1019             }
1020         }
1021     }
1022 
1023     // =============================================================
1024     //                        MINT OPERATIONS
1025     // =============================================================
1026 
1027     /**
1028      * @dev Mints `quantity` tokens and transfers them to `to`.
1029      *
1030      * Requirements:
1031      *
1032      * - `to` cannot be the zero address.
1033      * - `quantity` must be greater than 0.
1034      *
1035      * Emits a {Transfer} event for each mint.
1036      */
1037     function _mint(address to, uint256 quantity) internal virtual {
1038         uint256 startTokenId = _currentIndex;
1039         if (quantity == 0) revert MintZeroQuantity();
1040 
1041         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1042 
1043         // Overflows are incredibly unrealistic.
1044         // `balance` and `numberMinted` have a maximum limit of 2**64.
1045         // `tokenId` has a maximum limit of 2**256.
1046         unchecked {
1047             // Updates:
1048             // - `balance += quantity`.
1049             // - `numberMinted += quantity`.
1050             //
1051             // We can directly add to the `balance` and `numberMinted`.
1052             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1053 
1054             // Updates:
1055             // - `address` to the owner.
1056             // - `startTimestamp` to the timestamp of minting.
1057             // - `burned` to `false`.
1058             // - `nextInitialized` to `quantity == 1`.
1059             _packedOwnerships[startTokenId] = _packOwnershipData(
1060                 to,
1061                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1062             );
1063 
1064             uint256 toMasked;
1065             uint256 end = startTokenId + quantity;
1066 
1067             // Use assembly to loop and emit the `Transfer` event for gas savings.
1068             assembly {
1069                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1070                 toMasked := and(to, _BITMASK_ADDRESS)
1071                 // Emit the `Transfer` event.
1072                 log4(
1073                     0, // Start of data (0, since no data).
1074                     0, // End of data (0, since no data).
1075                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1076                     0, // `address(0)`.
1077                     toMasked, // `to`.
1078                     startTokenId // `tokenId`.
1079                 )
1080 
1081                 for {
1082                     let tokenId := add(startTokenId, 1)
1083                 } iszero(eq(tokenId, end)) {
1084                     tokenId := add(tokenId, 1)
1085                 } {
1086                     // Emit the `Transfer` event. Similar to above.
1087                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1088                 }
1089             }
1090             if (toMasked == 0) revert MintToZeroAddress();
1091 
1092             _currentIndex = end;
1093         }
1094         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1095     }
1096 
1097     /**
1098      * @dev Mints `quantity` tokens and transfers them to `to`.
1099      *
1100      * This function is intended for efficient minting only during contract creation.
1101      *
1102      * It emits only one {ConsecutiveTransfer} as defined in
1103      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1104      * instead of a sequence of {Transfer} event(s).
1105      *
1106      * Calling this function outside of contract creation WILL make your contract
1107      * non-compliant with the ERC721 standard.
1108      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1109      * {ConsecutiveTransfer} event is only permissible during contract creation.
1110      *
1111      * Requirements:
1112      *
1113      * - `to` cannot be the zero address.
1114      * - `quantity` must be greater than 0.
1115      *
1116      * Emits a {ConsecutiveTransfer} event.
1117      */
1118     function _mintERC2309(address to, uint256 quantity) internal virtual {
1119         uint256 startTokenId = _currentIndex;
1120         if (to == address(0)) revert MintToZeroAddress();
1121         if (quantity == 0) revert MintZeroQuantity();
1122         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1123 
1124         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1125 
1126         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1127         unchecked {
1128             // Updates:
1129             // - `balance += quantity`.
1130             // - `numberMinted += quantity`.
1131             //
1132             // We can directly add to the `balance` and `numberMinted`.
1133             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1134 
1135             // Updates:
1136             // - `address` to the owner.
1137             // - `startTimestamp` to the timestamp of minting.
1138             // - `burned` to `false`.
1139             // - `nextInitialized` to `quantity == 1`.
1140             _packedOwnerships[startTokenId] = _packOwnershipData(
1141                 to,
1142                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1143             );
1144 
1145             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1146 
1147             _currentIndex = startTokenId + quantity;
1148         }
1149         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1150     }
1151 
1152     /**
1153      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1154      *
1155      * Requirements:
1156      *
1157      * - If `to` refers to a smart contract, it must implement
1158      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1159      * - `quantity` must be greater than 0.
1160      *
1161      * See {_mint}.
1162      *
1163      * Emits a {Transfer} event for each mint.
1164      */
1165     function _safeMint(
1166         address to,
1167         uint256 quantity,
1168         bytes memory _data
1169     ) internal virtual {
1170         _mint(to, quantity);
1171 
1172         unchecked {
1173             if (to.code.length != 0) {
1174                 uint256 end = _currentIndex;
1175                 uint256 index = end - quantity;
1176                 do {
1177                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1178                         revert TransferToNonERC721ReceiverImplementer();
1179                     }
1180                 } while (index < end);
1181                 // Reentrancy protection.
1182                 if (_currentIndex != end) revert();
1183             }
1184         }
1185     }
1186 
1187     /**
1188      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1189      */
1190     function _safeMint(address to, uint256 quantity) internal virtual {
1191         _safeMint(to, quantity, '');
1192     }
1193 
1194     // =============================================================
1195     //                        BURN OPERATIONS
1196     // =============================================================
1197 
1198     /**
1199      * @dev Equivalent to `_burn(tokenId, false)`.
1200      */
1201     function _burn(uint256 tokenId) internal virtual {
1202         _burn(tokenId, false);
1203     }
1204 
1205     /**
1206      * @dev Destroys `tokenId`.
1207      * The approval is cleared when the token is burned.
1208      *
1209      * Requirements:
1210      *
1211      * - `tokenId` must exist.
1212      *
1213      * Emits a {Transfer} event.
1214      */
1215     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1216         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1217 
1218         address from = address(uint160(prevOwnershipPacked));
1219 
1220         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1221 
1222         if (approvalCheck) {
1223             // The nested ifs save around 20+ gas over a compound boolean condition.
1224             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1225                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1226         }
1227 
1228         _beforeTokenTransfers(from, address(0), tokenId, 1);
1229 
1230         // Clear approvals from the previous owner.
1231         assembly {
1232             if approvedAddress {
1233                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1234                 sstore(approvedAddressSlot, 0)
1235             }
1236         }
1237 
1238         // Underflow of the sender's balance is impossible because we check for
1239         // ownership above and the recipient's balance can't realistically overflow.
1240         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1241         unchecked {
1242             // Updates:
1243             // - `balance -= 1`.
1244             // - `numberBurned += 1`.
1245             //
1246             // We can directly decrement the balance, and increment the number burned.
1247             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1248             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1249 
1250             // Updates:
1251             // - `address` to the last owner.
1252             // - `startTimestamp` to the timestamp of burning.
1253             // - `burned` to `true`.
1254             // - `nextInitialized` to `true`.
1255             _packedOwnerships[tokenId] = _packOwnershipData(
1256                 from,
1257                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1258             );
1259 
1260             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1261             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1262                 uint256 nextTokenId = tokenId + 1;
1263                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1264                 if (_packedOwnerships[nextTokenId] == 0) {
1265                     // If the next slot is within bounds.
1266                     if (nextTokenId != _currentIndex) {
1267                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1268                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1269                     }
1270                 }
1271             }
1272         }
1273 
1274         emit Transfer(from, address(0), tokenId);
1275         _afterTokenTransfers(from, address(0), tokenId, 1);
1276 
1277         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1278         unchecked {
1279             _burnCounter++;
1280         }
1281     }
1282 
1283     // =============================================================
1284     //                     EXTRA DATA OPERATIONS
1285     // =============================================================
1286 
1287     /**
1288      * @dev Directly sets the extra data for the ownership data `index`.
1289      */
1290     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1291         uint256 packed = _packedOwnerships[index];
1292         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1293         uint256 extraDataCasted;
1294         // Cast `extraData` with assembly to avoid redundant masking.
1295         assembly {
1296             extraDataCasted := extraData
1297         }
1298         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1299         _packedOwnerships[index] = packed;
1300     }
1301 
1302     /**
1303      * @dev Called during each token transfer to set the 24bit `extraData` field.
1304      * Intended to be overridden by the cosumer contract.
1305      *
1306      * `previousExtraData` - the value of `extraData` before transfer.
1307      *
1308      * Calling conditions:
1309      *
1310      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1311      * transferred to `to`.
1312      * - When `from` is zero, `tokenId` will be minted for `to`.
1313      * - When `to` is zero, `tokenId` will be burned by `from`.
1314      * - `from` and `to` are never both zero.
1315      */
1316     function _extraData(
1317         address from,
1318         address to,
1319         uint24 previousExtraData
1320     ) internal view virtual returns (uint24) {}
1321 
1322     /**
1323      * @dev Returns the next extra data for the packed ownership data.
1324      * The returned result is shifted into position.
1325      */
1326     function _nextExtraData(
1327         address from,
1328         address to,
1329         uint256 prevOwnershipPacked
1330     ) private view returns (uint256) {
1331         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1332         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1333     }
1334 
1335     // =============================================================
1336     //                       OTHER OPERATIONS
1337     // =============================================================
1338 
1339     /**
1340      * @dev Returns the message sender (defaults to `msg.sender`).
1341      *
1342      * If you are writing GSN compatible contracts, you need to override this function.
1343      */
1344     function _msgSenderERC721A() internal view virtual returns (address) {
1345         return msg.sender;
1346     }
1347 
1348     /**
1349      * @dev Converts a uint256 to its ASCII string decimal representation.
1350      */
1351     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1352         assembly {
1353             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1354             // but we allocate 0x80 bytes to keep the free memory pointer 32-byte word aliged.
1355             // We will need 1 32-byte word to store the length,
1356             // and 3 32-byte words to store a maximum of 78 digits. Total: 0x20 + 3 * 0x20 = 0x80.
1357             str := add(mload(0x40), 0x80)
1358             // Update the free memory pointer to allocate.
1359             mstore(0x40, str)
1360 
1361             // Cache the end of the memory to calculate the length later.
1362             let end := str
1363 
1364             // We write the string from rightmost digit to leftmost digit.
1365             // The following is essentially a do-while loop that also handles the zero case.
1366             // prettier-ignore
1367             for { let temp := value } 1 {} {
1368                 str := sub(str, 1)
1369                 // Write the character to the pointer.
1370                 // The ASCII index of the '0' character is 48.
1371                 mstore8(str, add(48, mod(temp, 10)))
1372                 // Keep dividing `temp` until zero.
1373                 temp := div(temp, 10)
1374                 // prettier-ignore
1375                 if iszero(temp) { break }
1376             }
1377 
1378             let length := sub(end, str)
1379             // Move the pointer 32 bytes leftwards to make room for the length.
1380             str := sub(str, 0x20)
1381             // Store the length.
1382             mstore(str, length)
1383         }
1384     }
1385 }
1386 
1387 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1388 
1389 /**
1390  * @dev Provides information about the current execution context, including the
1391  * sender of the transaction and its data. While these are generally available
1392  * via msg.sender and msg.data, they should not be accessed in such a direct
1393  * manner, since when dealing with meta-transactions the account sending and
1394  * paying for execution may not be the actual sender (as far as an application
1395  * is concerned).
1396  *
1397  * This contract is only required for intermediate, library-like contracts.
1398  */
1399 abstract contract Context {
1400     function _msgSender() internal view virtual returns (address) {
1401         return msg.sender;
1402     }
1403 
1404     function _msgData() internal view virtual returns (bytes calldata) {
1405         return msg.data;
1406     }
1407 }
1408 
1409 
1410 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1411 
1412 /**
1413  * @dev Contract module which provides a basic access control mechanism, where
1414  * there is an account (an owner) that can be granted exclusive access to
1415  * specific functions.
1416  *
1417  * By default, the owner account will be the one that deploys the contract. This
1418  * can later be changed with {transferOwnership}.
1419  *
1420  * This module is used through inheritance. It will make available the modifier
1421  * `onlyOwner`, which can be applied to your functions to restrict their use to
1422  * the owner.
1423  */
1424 abstract contract Ownable is Context {
1425     address private _owner;
1426 
1427     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1428 
1429     /**
1430      * @dev Initializes the contract setting the deployer as the initial owner.
1431      */
1432     constructor() {
1433         _transferOwnership(_msgSender());
1434     }
1435 
1436     /**
1437      * @dev Throws if called by any account other than the owner.
1438      */
1439     modifier onlyOwner() {
1440         _checkOwner();
1441         _;
1442     }
1443 
1444     /**
1445      * @dev Returns the address of the current owner.
1446      */
1447     function owner() public view virtual returns (address) {
1448         return _owner;
1449     }
1450 
1451     /**
1452      * @dev Throws if the sender is not the owner.
1453      */
1454     function _checkOwner() internal view virtual {
1455         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1456     }
1457 
1458     /**
1459      * @dev Leaves the contract without owner. It will not be possible to call
1460      * `onlyOwner` functions anymore. Can only be called by the current owner.
1461      *
1462      * NOTE: Renouncing ownership will leave the contract without an owner,
1463      * thereby removing any functionality that is only available to the owner.
1464      */
1465     function renounceOwnership() public virtual onlyOwner {
1466         _transferOwnership(address(0));
1467     }
1468 
1469     /**
1470      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1471      * Can only be called by the current owner.
1472      */
1473     function transferOwnership(address newOwner) public virtual onlyOwner {
1474         require(newOwner != address(0), "Ownable: new owner is the zero address");
1475         _transferOwnership(newOwner);
1476     }
1477 
1478     /**
1479      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1480      * Internal function without access restriction.
1481      */
1482     function _transferOwnership(address newOwner) internal virtual {
1483         address oldOwner = _owner;
1484         _owner = newOwner;
1485         emit OwnershipTransferred(oldOwner, newOwner);
1486     }
1487 }
1488 
1489 // Updao - SeamanNFT
1490 contract Seaman is ERC721A, Ownable {
1491 
1492     uint256 public constant _MAX_SUPPLY = 5555;
1493     string private _uriContract = "";
1494     string private _uriBase = "";
1495     string private _uriExtension = ".json";
1496     address private _minter;
1497 
1498     modifier onlyMinter() {
1499         require(msg.sender == owner() || msg.sender == _minter, "Caller is not the minter");
1500         _;
1501     }
1502 
1503     constructor() ERC721A("Seaman", "UPMAN") {
1504         _minter = msg.sender;
1505     }
1506 
1507     function setMinter(address one) public onlyOwner {
1508         require(one != address(0), "Cannot be the zero address");
1509         _minter = one;
1510     }
1511 
1512     function setContractURI(string memory uri) public onlyOwner {
1513         _uriContract = uri;
1514     }
1515 
1516     function contractURI() public view returns (string memory) {
1517         return _uriContract;
1518     }
1519 
1520     function setBaseUriAndExtension(string memory base, string memory ext) public onlyOwner {
1521         _uriBase = base; // http://base.url/
1522         _uriExtension = ext; // .json
1523     }
1524 
1525     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1526         if (!_exists(tokenId)) {
1527             revert URIQueryForNonexistentToken();
1528         }
1529         return string(abi.encodePacked(_uriBase, _toString(tokenId), _uriExtension));
1530     }
1531 
1532     function burn(uint256 tokenId) public {
1533         _burn(tokenId, true);
1534     }
1535 
1536     function mint(address to, uint256 quantity) public onlyMinter {
1537         require(_totalMinted() + quantity <= _MAX_SUPPLY, "Exceeds max supply");
1538         _safeMint(to, quantity);
1539     }
1540 
1541     function numberMinted(address one) public view returns (uint256) {
1542         return _numberMinted(one);
1543     }
1544 
1545     receive() external payable {
1546         payable(owner()).transfer(msg.value);
1547     }
1548 
1549 }