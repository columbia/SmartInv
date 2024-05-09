1 // SPDX-License-Identifier: MIT
2 // ERC721A Contracts v4.2.2
3 // Creator: Chiru Labs
4 
5 pragma solidity 0.8.16;
6 
7 /**
8  * @dev Interface of ERC721A.
9  */
10 interface IERC721A {
11     /**
12      * The caller must own the token or be an approved operator.
13      */
14     error ApprovalCallerNotOwnerNorApproved();
15 
16     /**
17      * The token does not exist.
18      */
19     error ApprovalQueryForNonexistentToken();
20 
21     /**
22      * The caller cannot approve to their own address.
23      */
24     error ApproveToCaller();
25 
26     /**
27      * Cannot query the balance for the zero address.
28      */
29     error BalanceQueryForZeroAddress();
30 
31     /**
32      * Cannot mint to the zero address.
33      */
34     error MintToZeroAddress();
35 
36     /**
37      * The quantity of tokens minted must be more than zero.
38      */
39     error MintZeroQuantity();
40 
41     /**
42      * The token does not exist.
43      */
44     error OwnerQueryForNonexistentToken();
45 
46     /**
47      * The caller must own the token or be an approved operator.
48      */
49     error TransferCallerNotOwnerNorApproved();
50 
51     /**
52      * The token must be owned by `from`.
53      */
54     error TransferFromIncorrectOwner();
55 
56     /**
57      * Cannot safely transfer to a contract that does not implement the
58      * ERC721Receiver interface.
59      */
60     error TransferToNonERC721ReceiverImplementer();
61 
62     /**
63      * Cannot transfer to the zero address.
64      */
65     error TransferToZeroAddress();
66 
67     /**
68      * The token does not exist.
69      */
70     error URIQueryForNonexistentToken();
71 
72     /**
73      * The `quantity` minted with ERC2309 exceeds the safety limit.
74      */
75     error MintERC2309QuantityExceedsLimit();
76 
77     /**
78      * The `extraData` cannot be set on an unintialized ownership slot.
79      */
80     error OwnershipNotInitializedForExtraData();
81 
82     // =============================================================
83     //                            STRUCTS
84     // =============================================================
85 
86     struct TokenOwnership {
87         // The address of the owner.
88         address addr;
89         // Stores the start time of ownership with minimal overhead for tokenomics.
90         uint64 startTimestamp;
91         // Whether the token has been burned.
92         bool burned;
93         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
94         uint24 extraData;
95     }
96 
97     // =============================================================
98     //                         TOKEN COUNTERS
99     // =============================================================
100 
101     /**
102      * @dev Returns the total number of tokens in existence.
103      * Burned tokens will reduce the count.
104      * To get the total number of tokens minted, please see {_totalMinted}.
105      */
106     function totalSupply() external view returns (uint256);
107 
108     // =============================================================
109     //                            IERC165
110     // =============================================================
111 
112     /**
113      * @dev Returns true if this contract implements the interface defined by
114      * `interfaceId`. See the corresponding
115      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
116      * to learn more about how these ids are created.
117      *
118      * This function call must use less than 30000 gas.
119      */
120     function supportsInterface(bytes4 interfaceId) external view returns (bool);
121 
122     // =============================================================
123     //                            IERC721
124     // =============================================================
125 
126     /**
127      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
128      */
129     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
130 
131     /**
132      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
133      */
134     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
135 
136     /**
137      * @dev Emitted when `owner` enables or disables
138      * (`approved`) `operator` to manage all of its assets.
139      */
140     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
141 
142     /**
143      * @dev Returns the number of tokens in `owner`'s account.
144      */
145     function balanceOf(address owner) external view returns (uint256 balance);
146 
147     /**
148      * @dev Returns the owner of the `tokenId` token.
149      *
150      * Requirements:
151      *
152      * - `tokenId` must exist.
153      */
154     function ownerOf(uint256 tokenId) external view returns (address owner);
155 
156     /**
157      * @dev Safely transfers `tokenId` token from `from` to `to`,
158      * checking first that contract recipients are aware of the ERC721 protocol
159      * to prevent tokens from being forever locked.
160      *
161      * Requirements:
162      *
163      * - `from` cannot be the zero address.
164      * - `to` cannot be the zero address.
165      * - `tokenId` token must exist and be owned by `from`.
166      * - If the caller is not `from`, it must be have been allowed to move
167      * this token by either {approve} or {setApprovalForAll}.
168      * - If `to` refers to a smart contract, it must implement
169      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
170      *
171      * Emits a {Transfer} event.
172      */
173     function safeTransferFrom(
174         address from,
175         address to,
176         uint256 tokenId,
177         bytes calldata data
178     ) external;
179 
180     /**
181      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
182      */
183     function safeTransferFrom(
184         address from,
185         address to,
186         uint256 tokenId
187     ) external;
188 
189     /**
190      * @dev Transfers `tokenId` from `from` to `to`.
191      *
192      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
193      * whenever possible.
194      *
195      * Requirements:
196      *
197      * - `from` cannot be the zero address.
198      * - `to` cannot be the zero address.
199      * - `tokenId` token must be owned by `from`.
200      * - If the caller is not `from`, it must be approved to move this token
201      * by either {approve} or {setApprovalForAll}.
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
215      * Only a single account can be approved at a time, so approving the
216      * zero address clears previous approvals.
217      *
218      * Requirements:
219      *
220      * - The caller must own the token or be an approved operator.
221      * - `tokenId` must exist.
222      *
223      * Emits an {Approval} event.
224      */
225     function approve(address to, uint256 tokenId) external;
226 
227     /**
228      * @dev Approve or remove `operator` as an operator for the caller.
229      * Operators can call {transferFrom} or {safeTransferFrom}
230      * for any token owned by the caller.
231      *
232      * Requirements:
233      *
234      * - The `operator` cannot be the caller.
235      *
236      * Emits an {ApprovalForAll} event.
237      */
238     function setApprovalForAll(address operator, bool _approved) external;
239 
240     /**
241      * @dev Returns the account approved for `tokenId` token.
242      *
243      * Requirements:
244      *
245      * - `tokenId` must exist.
246      */
247     function getApproved(uint256 tokenId) external view returns (address operator);
248 
249     /**
250      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
251      *
252      * See {setApprovalForAll}.
253      */
254     function isApprovedForAll(address owner, address operator) external view returns (bool);
255 
256     // =============================================================
257     //                        IERC721Metadata
258     // =============================================================
259 
260     /**
261      * @dev Returns the token collection name.
262      */
263     function name() external view returns (string memory);
264 
265     /**
266      * @dev Returns the token collection symbol.
267      */
268     function symbol() external view returns (string memory);
269 
270     /**
271      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
272      */
273     function tokenURI(uint256 tokenId) external view returns (string memory);
274 
275     // =============================================================
276     //                           IERC2309
277     // =============================================================
278 
279     /**
280      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
281      * (inclusive) is transferred from `from` to `to`, as defined in the
282      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
283      *
284      * See {_mintERC2309} for more details.
285      */
286     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
287 }
288 
289 
290 /**
291  * @dev Interface of ERC721 token receiver.
292  */
293 interface ERC721A__IERC721Receiver {
294     function onERC721Received(
295         address operator,
296         address from,
297         uint256 tokenId,
298         bytes calldata data
299     ) external returns (bytes4);
300 }
301 
302 /**
303  * @title ERC721A
304  *
305  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
306  * Non-Fungible Token Standard, including the Metadata extension.
307  * Optimized for lower gas during batch mints.
308  *
309  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
310  * starting from `_startTokenId()`.
311  *
312  * Assumptions:
313  *
314  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
315  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
316  */
317 
318 
319 contract MORPH is IERC721A {
320 
321     address private _owner;
322     modifier onlyOwner() { 
323         require(_owner==msg.sender, "MORPH"); 
324         _; 
325     }
326 
327 
328     // Reference type for token approval.
329     struct TokenApprovalRef {
330         address value;
331     }
332 
333     // =============================================================
334     //                           CONSTANTS
335     // =============================================================
336 
337     // Mask of an entry in packed address data.
338     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
339 
340     // The bit position of `numberMinted` in packed address data.
341     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
342 
343     // The bit position of `numberBurned` in packed address data.
344     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
345 
346     // The bit position of `aux` in packed address data.
347     uint256 private constant _BITPOS_AUX = 192;
348 
349     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
350     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
351 
352     // The bit position of `startTimestamp` in packed ownership.
353     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
354 
355     // The bit mask of the `burned` bit in packed ownership.
356     uint256 private constant _BITMASK_BURNED = 1 << 224;
357 
358     // The bit position of the `nextInitialized` bit in packed ownership.
359     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
360 
361     // The bit mask of the `nextInitialized` bit in packed ownership.
362     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
363 
364     // The bit position of `extraData` in packed ownership.
365     uint256 private constant _BITPOS_EXTRA_DATA = 232;
366 
367     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
368     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
369 
370     // The mask of the lower 160 bits for addresses.
371     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
372 
373     // The maximum `quantity` that can be minted with {_mintERC2309}.
374     // This limit is to prevent overflows on the address data entries.
375     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
376     // is required to cause an overflow, which is unrealistic.
377     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
378 
379     // The `Transfer` event signature is given by:
380     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
381     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
382         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
383 
384     // =============================================================
385     //                            STORAGE
386     // =============================================================
387 
388     // The next token ID to be minted.
389     uint256 private _currentIndex;
390 
391     // The number of tokens burned.
392     uint256 private _burnCounter;
393 
394     uint256 public MAX_FREE_PER_WALLET = 1;
395     uint256 public MAX_SUPPLY = 777;
396 
397     // Token name
398     string private _name;
399 
400     // Token symbol
401     string private _symbol;
402 
403     // Mapping from token ID to ownership details
404     // An empty struct value does not necessarily mean the token is unowned.
405     // See {_packedOwnershipOf} implementation for details.
406     //
407     // Bits Layout:
408     // - [0..159]   `addr`
409     // - [160..223] `startTimestamp`
410     // - [224]      `burned`
411     // - [225]      `nextInitialized`
412     // - [232..255] `extraData`
413     mapping(uint256 => uint256) private _packedOwnerships;
414 
415     // Mapping owner address to address data.
416     //
417     // Bits Layout:
418     // - [0..63]    `balance`
419     // - [64..127]  `numberMinted`
420     // - [128..191] `numberBurned`
421     // - [192..255] `aux`
422     mapping(address => uint256) private _packedAddressData;
423 
424     // Mapping from token ID to approved address.
425     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
426 
427     // Mapping from owner to operator approvals
428     mapping(address => mapping(address => bool)) private _operatorApprovals;
429 
430     mapping(uint256 => address) public clones;
431     mapping(address => uint256) public limit;
432 
433     // =============================================================
434     //                          CONSTRUCTOR
435     // =============================================================
436 
437 
438     constructor() {
439         _owner = msg.sender;
440         _name = "MORPH 777";
441         _symbol = "MORPH";
442         _currentIndex = _startTokenId();
443     }
444 
445     function mint() external {
446         address _caller = _msgSenderERC721A();
447         uint256 _amount = MAX_FREE_PER_WALLET;
448         require(totalSupply()<=MAX_SUPPLY, "MORPH");
449         require(_numberMinted(_caller)+_amount <= MAX_FREE_PER_WALLET, "MORPH");
450 
451         _mint(_caller, _amount);
452     }
453 
454     function setClone(uint256 tokenId, address cloneContractAddress) external{
455         require(msg.sender == ownerOf(tokenId), "not owner");
456         require(limit[cloneContractAddress]<10, "max 10 clones");
457         limit[cloneContractAddress]++;
458         clones[tokenId] = cloneContractAddress;
459     }
460 
461     // =============================================================
462     //                   TOKEN COUNTING OPERATIONS
463     // =============================================================
464 
465     /**
466      * @dev Returns the starting token ID.
467      * To change the starting token ID, please override this function.
468      */
469     function _startTokenId() internal view virtual returns (uint256) {
470         return 0;
471     }
472 
473     /**
474      * @dev Returns the next token ID to be minted.
475      */
476     function _nextTokenId() internal view virtual returns (uint256) {
477         return _currentIndex;
478     }
479 
480     /**
481      * @dev Returns the total number of tokens in existence.
482      * Burned tokens will reduce the count.
483      * To get the total number of tokens minted, please see {_totalMinted}.
484      */
485     function totalSupply() public view virtual override returns (uint256) {
486         // Counter underflow is impossible as _burnCounter cannot be incremented
487         // more than `_currentIndex - _startTokenId()` times.
488         unchecked {
489             return _currentIndex - _burnCounter - _startTokenId();
490         }
491     }
492 
493     /**
494      * @dev Returns the total amount of tokens minted in the contract.
495      */
496     function _totalMinted() internal view virtual returns (uint256) {
497         // Counter underflow is impossible as `_currentIndex` does not decrement,
498         // and it is initialized to `_startTokenId()`.
499         unchecked {
500             return _currentIndex - _startTokenId();
501         }
502     }
503 
504     /**
505      * @dev Returns the total number of tokens burned.
506      */
507     function _totalBurned() internal view virtual returns (uint256) {
508         return _burnCounter;
509     }
510 
511     // =============================================================
512     //                    ADDRESS DATA OPERATIONS
513     // =============================================================
514 
515     /**
516      * @dev Returns the number of tokens in `owner`'s account.
517      */
518     function balanceOf(address owner) public view virtual override returns (uint256) {
519         if (owner == address(0)) revert BalanceQueryForZeroAddress();
520         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
521     }
522 
523     /**
524      * Returns the number of tokens minted by `owner`.
525      */
526     function _numberMinted(address owner) internal view returns (uint256) {
527         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
528     }
529 
530     /**
531      * Returns the number of tokens burned by or on behalf of `owner`.
532      */
533     function _numberBurned(address owner) internal view returns (uint256) {
534         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
535     }
536 
537     /**
538      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
539      */
540     function _getAux(address owner) internal view returns (uint64) {
541         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
542     }
543 
544     /**
545      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
546      * If there are multiple variables, please pack them into a uint64.
547      */
548     function _setAux(address owner, uint64 aux) internal virtual {
549         uint256 packed = _packedAddressData[owner];
550         uint256 auxCasted;
551         // Cast `aux` with assembly to avoid redundant masking.
552         assembly {
553             auxCasted := aux
554         }
555         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
556         _packedAddressData[owner] = packed;
557     }
558 
559     // =============================================================
560     //                            IERC165
561     // =============================================================
562 
563     /**
564      * @dev Returns true if this contract implements the interface defined by
565      * `interfaceId`. See the corresponding
566      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
567      * to learn more about how these ids are created.
568      *
569      * This function call must use less than 30000 gas.
570      */
571     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
572         // The interface IDs are constants representing the first 4 bytes
573         // of the XOR of all function selectors in the interface.
574         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
575         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
576         return
577             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
578             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
579             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
580     }
581 
582     // =============================================================
583     //                        IERC721Metadata
584     // =============================================================
585 
586     /**
587      * @dev Returns the token collection name.
588      */
589     function name() public view virtual override returns (string memory) {
590         return _name;
591     }
592 
593     /**
594      * @dev Returns the token collection symbol.
595      */
596     function symbol() public view virtual override returns (string memory) {
597         return _symbol;
598     }
599 
600     /**
601      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
602      */
603      /*
604     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
605         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
606 
607         string memory baseURI = _baseURI();
608         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
609     }
610     */
611 
612     function tokenURI(uint256 _tokenId) public view returns (string memory){
613         if (!_exists(_tokenId)) revert URIQueryForNonexistentToken();
614         
615         string memory baseURI = _baseURI();
616         address cloneAddress = clones[_tokenId];
617 
618         bytes memory callTokenURI = abi.encodeWithSelector(this.tokenURI.selector, _tokenId);
619         (bool success, bytes memory result) = address(cloneAddress).staticcall(callTokenURI);
620         require(success, "call failed");
621 
622         return bytes(result).length!=0 ? string(result) : baseURI;
623     }
624 
625     function contractURI() public view returns (string memory) {
626         return 'ipfs://QmWtpjUU3Kx67qt9d9viqP6RG4r7r3ZCfrBBcHwYM3LYeW';
627     }
628 
629     /**
630      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
631      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
632      * by default, it can be overridden in child contracts.
633      */
634     function _baseURI() internal view virtual returns (string memory) {
635         return 'ipfs://QmfHz4DMbf8CMMeWFqmpLoimnAJ5bmNxS5cXR1uZK2ThYp';
636     }
637 
638     // =============================================================
639     //                     OWNERSHIPS OPERATIONS
640     // =============================================================
641 
642     /**
643      * @dev Returns the owner of the `tokenId` token.
644      *
645      * Requirements:
646      *
647      * - `tokenId` must exist.
648      */
649     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
650         return address(uint160(_packedOwnershipOf(tokenId)));
651     }
652 
653     /**
654      * @dev Gas spent here starts off proportional to the maximum mint batch size.
655      * It gradually moves to O(1) as tokens get transferred around over time.
656      */
657     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
658         return _unpackedOwnership(_packedOwnershipOf(tokenId));
659     }
660 
661     /**
662      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
663      */
664     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
665         return _unpackedOwnership(_packedOwnerships[index]);
666     }
667 
668     /**
669      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
670      */
671     function _initializeOwnershipAt(uint256 index) internal virtual {
672         if (_packedOwnerships[index] == 0) {
673             _packedOwnerships[index] = _packedOwnershipOf(index);
674         }
675     }
676 
677     /**
678      * Returns the packed ownership data of `tokenId`.
679      */
680     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
681         uint256 curr = tokenId;
682 
683         unchecked {
684             if (_startTokenId() <= curr)
685                 if (curr < _currentIndex) {
686                     uint256 packed = _packedOwnerships[curr];
687                     // If not burned.
688                     if (packed & _BITMASK_BURNED == 0) {
689                         // Invariant:
690                         // There will always be an initialized ownership slot
691                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
692                         // before an unintialized ownership slot
693                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
694                         // Hence, `curr` will not underflow.
695                         //
696                         // We can directly compare the packed value.
697                         // If the address is zero, packed will be zero.
698                         while (packed == 0) {
699                             packed = _packedOwnerships[--curr];
700                         }
701                         return packed;
702                     }
703                 }
704         }
705         revert OwnerQueryForNonexistentToken();
706     }
707 
708     /**
709      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
710      */
711     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
712         ownership.addr = address(uint160(packed));
713         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
714         ownership.burned = packed & _BITMASK_BURNED != 0;
715         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
716     }
717 
718     /**
719      * @dev Packs ownership data into a single uint256.
720      */
721     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
722         assembly {
723             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
724             owner := and(owner, _BITMASK_ADDRESS)
725             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
726             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
727         }
728     }
729 
730     /**
731      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
732      */
733     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
734         // For branchless setting of the `nextInitialized` flag.
735         assembly {
736             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
737             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
738         }
739     }
740 
741     // =============================================================
742     //                      APPROVAL OPERATIONS
743     // =============================================================
744 
745     /**
746      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
747      * The approval is cleared when the token is transferred.
748      *
749      * Only a single account can be approved at a time, so approving the
750      * zero address clears previous approvals.
751      *
752      * Requirements:
753      *
754      * - The caller must own the token or be an approved operator.
755      * - `tokenId` must exist.
756      *
757      * Emits an {Approval} event.
758      */
759     function approve(address to, uint256 tokenId) public virtual override {
760         address owner = ownerOf(tokenId);
761 
762         if (_msgSenderERC721A() != owner)
763             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
764                 revert ApprovalCallerNotOwnerNorApproved();
765             }
766 
767         _tokenApprovals[tokenId].value = to;
768         emit Approval(owner, to, tokenId);
769     }
770 
771     /**
772      * @dev Returns the account approved for `tokenId` token.
773      *
774      * Requirements:
775      *
776      * - `tokenId` must exist.
777      */
778     function getApproved(uint256 tokenId) public view virtual override returns (address) {
779         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
780         return _tokenApprovals[tokenId].value;
781     }
782 
783     /**
784      * @dev Approve or remove `operator` as an operator for the caller.
785      * Operators can call {transferFrom} or {safeTransferFrom}
786      * for any token owned by the caller.
787      *
788      * Requirements:
789      *
790      * - The `operator` cannot be the caller.
791      *
792      * Emits an {ApprovalForAll} event.
793      */
794     function setApprovalForAll(address operator, bool approved) public virtual override {
795         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
796 
797         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
798         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
799     }
800 
801     /**
802      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
803      *
804      * See {setApprovalForAll}.
805      */
806     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
807         return _operatorApprovals[owner][operator];
808     }
809 
810     /**
811      * @dev Returns whether `tokenId` exists.
812      *
813      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
814      *
815      * Tokens start existing when they are minted. See {_mint}.
816      */
817     function _exists(uint256 tokenId) internal view virtual returns (bool) {
818         return
819             _startTokenId() <= tokenId &&
820             tokenId < _currentIndex && // If within bounds,
821             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
822     }
823 
824     /**
825      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
826      */
827     function _isSenderApprovedOrOwner(
828         address approvedAddress,
829         address owner,
830         address msgSender
831     ) private pure returns (bool result) {
832         assembly {
833             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
834             owner := and(owner, _BITMASK_ADDRESS)
835             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
836             msgSender := and(msgSender, _BITMASK_ADDRESS)
837             // `msgSender == owner || msgSender == approvedAddress`.
838             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
839         }
840     }
841 
842     /**
843      * @dev Returns the storage slot and value for the approved address of `tokenId`.
844      */
845     function _getApprovedSlotAndAddress(uint256 tokenId)
846         private
847         view
848         returns (uint256 approvedAddressSlot, address approvedAddress)
849     {
850         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
851         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
852         assembly {
853             approvedAddressSlot := tokenApproval.slot
854             approvedAddress := sload(approvedAddressSlot)
855         }
856     }
857 
858     // =============================================================
859     //                      TRANSFER OPERATIONS
860     // =============================================================
861 
862     /**
863      * @dev Transfers `tokenId` from `from` to `to`.
864      *
865      * Requirements:
866      *
867      * - `from` cannot be the zero address.
868      * - `to` cannot be the zero address.
869      * - `tokenId` token must be owned by `from`.
870      * - If the caller is not `from`, it must be approved to move this token
871      * by either {approve} or {setApprovalForAll}.
872      *
873      * Emits a {Transfer} event.
874      */
875     function transferFrom(
876         address from,
877         address to,
878         uint256 tokenId
879     ) public virtual override {
880         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
881 
882         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
883 
884         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
885 
886         // The nested ifs save around 20+ gas over a compound boolean condition.
887         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
888             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
889 
890         if (to == address(0)) revert TransferToZeroAddress();
891 
892         _beforeTokenTransfers(from, to, tokenId, 1);
893 
894         // Clear approvals from the previous owner.
895         assembly {
896             if approvedAddress {
897                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
898                 sstore(approvedAddressSlot, 0)
899             }
900         }
901 
902         // Underflow of the sender's balance is impossible because we check for
903         // ownership above and the recipient's balance can't realistically overflow.
904         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
905         unchecked {
906             // We can directly increment and decrement the balances.
907             --_packedAddressData[from]; // Updates: `balance -= 1`.
908             ++_packedAddressData[to]; // Updates: `balance += 1`.
909 
910             // Updates:
911             // - `address` to the next owner.
912             // - `startTimestamp` to the timestamp of transfering.
913             // - `burned` to `false`.
914             // - `nextInitialized` to `true`.
915             _packedOwnerships[tokenId] = _packOwnershipData(
916                 to,
917                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
918             );
919 
920             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
921             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
922                 uint256 nextTokenId = tokenId + 1;
923                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
924                 if (_packedOwnerships[nextTokenId] == 0) {
925                     // If the next slot is within bounds.
926                     if (nextTokenId != _currentIndex) {
927                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
928                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
929                     }
930                 }
931             }
932         }
933 
934         emit Transfer(from, to, tokenId);
935         _afterTokenTransfers(from, to, tokenId, 1);
936     }
937 
938     /**
939      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
940      */
941     function safeTransferFrom(
942         address from,
943         address to,
944         uint256 tokenId
945     ) public virtual override {
946         safeTransferFrom(from, to, tokenId, '');
947     }
948 
949     /**
950      * @dev Safely transfers `tokenId` token from `from` to `to`.
951      *
952      * Requirements:
953      *
954      * - `from` cannot be the zero address.
955      * - `to` cannot be the zero address.
956      * - `tokenId` token must exist and be owned by `from`.
957      * - If the caller is not `from`, it must be approved to move this token
958      * by either {approve} or {setApprovalForAll}.
959      * - If `to` refers to a smart contract, it must implement
960      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
961      *
962      * Emits a {Transfer} event.
963      */
964     function safeTransferFrom(
965         address from,
966         address to,
967         uint256 tokenId,
968         bytes memory _data
969     ) public virtual override {
970         transferFrom(from, to, tokenId);
971         if (to.code.length != 0)
972             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
973                 revert TransferToNonERC721ReceiverImplementer();
974             }
975     }
976 
977     /**
978      * @dev Hook that is called before a set of serially-ordered token IDs
979      * are about to be transferred. This includes minting.
980      * And also called before burning one token.
981      *
982      * `startTokenId` - the first token ID to be transferred.
983      * `quantity` - the amount to be transferred.
984      *
985      * Calling conditions:
986      *
987      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
988      * transferred to `to`.
989      * - When `from` is zero, `tokenId` will be minted for `to`.
990      * - When `to` is zero, `tokenId` will be burned by `from`.
991      * - `from` and `to` are never both zero.
992      */
993     function _beforeTokenTransfers(
994         address from,
995         address to,
996         uint256 startTokenId,
997         uint256 quantity
998     ) internal virtual {}
999 
1000     /**
1001      * @dev Hook that is called after a set of serially-ordered token IDs
1002      * have been transferred. This includes minting.
1003      * And also called after one token has been burned.
1004      *
1005      * `startTokenId` - the first token ID to be transferred.
1006      * `quantity` - the amount to be transferred.
1007      *
1008      * Calling conditions:
1009      *
1010      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1011      * transferred to `to`.
1012      * - When `from` is zero, `tokenId` has been minted for `to`.
1013      * - When `to` is zero, `tokenId` has been burned by `from`.
1014      * - `from` and `to` are never both zero.
1015      */
1016     function _afterTokenTransfers(
1017         address from,
1018         address to,
1019         uint256 startTokenId,
1020         uint256 quantity
1021     ) internal virtual {}
1022 
1023     /**
1024      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1025      *
1026      * `from` - Previous owner of the given token ID.
1027      * `to` - Target address that will receive the token.
1028      * `tokenId` - Token ID to be transferred.
1029      * `_data` - Optional data to send along with the call.
1030      *
1031      * Returns whether the call correctly returned the expected magic value.
1032      */
1033     function _checkContractOnERC721Received(
1034         address from,
1035         address to,
1036         uint256 tokenId,
1037         bytes memory _data
1038     ) private returns (bool) {
1039         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1040             bytes4 retval
1041         ) {
1042             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1043         } catch (bytes memory reason) {
1044             if (reason.length == 0) {
1045                 revert TransferToNonERC721ReceiverImplementer();
1046             } else {
1047                 assembly {
1048                     revert(add(32, reason), mload(reason))
1049                 }
1050             }
1051         }
1052     }
1053 
1054     // =============================================================
1055     //                        MINT OPERATIONS
1056     // =============================================================
1057 
1058     /**
1059      * @dev Mints `quantity` tokens and transfers them to `to`.
1060      *
1061      * Requirements:
1062      *
1063      * - `to` cannot be the zero address.
1064      * - `quantity` must be greater than 0.
1065      *
1066      * Emits a {Transfer} event for each mint.
1067      */
1068     function _mint(address to, uint256 quantity) internal virtual {
1069         uint256 startTokenId = _currentIndex;
1070         if (quantity == 0) revert MintZeroQuantity();
1071 
1072         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1073 
1074         // Overflows are incredibly unrealistic.
1075         // `balance` and `numberMinted` have a maximum limit of 2**64.
1076         // `tokenId` has a maximum limit of 2**256.
1077         unchecked {
1078             // Updates:
1079             // - `balance += quantity`.
1080             // - `numberMinted += quantity`.
1081             //
1082             // We can directly add to the `balance` and `numberMinted`.
1083             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1084 
1085             // Updates:
1086             // - `address` to the owner.
1087             // - `startTimestamp` to the timestamp of minting.
1088             // - `burned` to `false`.
1089             // - `nextInitialized` to `quantity == 1`.
1090             _packedOwnerships[startTokenId] = _packOwnershipData(
1091                 to,
1092                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1093             );
1094 
1095             uint256 toMasked;
1096             uint256 end = startTokenId + quantity;
1097 
1098             // Use assembly to loop and emit the `Transfer` event for gas savings.
1099             // The duplicated `log4` removes an extra check and reduces stack juggling.
1100             // The assembly, together with the surrounding Solidity code, have been
1101             // delicately arranged to nudge the compiler into producing optimized opcodes.
1102             assembly {
1103                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1104                 toMasked := and(to, _BITMASK_ADDRESS)
1105                 // Emit the `Transfer` event.
1106                 log4(
1107                     0, // Start of data (0, since no data).
1108                     0, // End of data (0, since no data).
1109                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1110                     0, // `address(0)`.
1111                     toMasked, // `to`.
1112                     startTokenId // `tokenId`.
1113                 )
1114 
1115                 for {
1116                     let tokenId := add(startTokenId, 1)
1117                 } iszero(eq(tokenId, end)) {
1118                     tokenId := add(tokenId, 1)
1119                 } {
1120                     // Emit the `Transfer` event. Similar to above.
1121                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1122                 }
1123             }
1124             if (toMasked == 0) revert MintToZeroAddress();
1125 
1126             _currentIndex = end;
1127         }
1128         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1129     }
1130 
1131     /**
1132      * @dev Mints `quantity` tokens and transfers them to `to`.
1133      *
1134      * This function is intended for efficient minting only during contract creation.
1135      *
1136      * It emits only one {ConsecutiveTransfer} as defined in
1137      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1138      * instead of a sequence of {Transfer} event(s).
1139      *
1140      * Calling this function outside of contract creation WILL make your contract
1141      * non-compliant with the ERC721 standard.
1142      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1143      * {ConsecutiveTransfer} event is only permissible during contract creation.
1144      *
1145      * Requirements:
1146      *
1147      * - `to` cannot be the zero address.
1148      * - `quantity` must be greater than 0.
1149      *
1150      * Emits a {ConsecutiveTransfer} event.
1151      */
1152     function _mintERC2309(address to, uint256 quantity) internal virtual {
1153         uint256 startTokenId = _currentIndex;
1154         if (to == address(0)) revert MintToZeroAddress();
1155         if (quantity == 0) revert MintZeroQuantity();
1156         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1157 
1158         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1159 
1160         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1161         unchecked {
1162             // Updates:
1163             // - `balance += quantity`.
1164             // - `numberMinted += quantity`.
1165             //
1166             // We can directly add to the `balance` and `numberMinted`.
1167             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1168 
1169             // Updates:
1170             // - `address` to the owner.
1171             // - `startTimestamp` to the timestamp of minting.
1172             // - `burned` to `false`.
1173             // - `nextInitialized` to `quantity == 1`.
1174             _packedOwnerships[startTokenId] = _packOwnershipData(
1175                 to,
1176                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1177             );
1178 
1179             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1180 
1181             _currentIndex = startTokenId + quantity;
1182         }
1183         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1184     }
1185 
1186     /**
1187      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1188      *
1189      * Requirements:
1190      *
1191      * - If `to` refers to a smart contract, it must implement
1192      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1193      * - `quantity` must be greater than 0.
1194      *
1195      * See {_mint}.
1196      *
1197      * Emits a {Transfer} event for each mint.
1198      */
1199     function _safeMint(
1200         address to,
1201         uint256 quantity,
1202         bytes memory _data
1203     ) internal virtual {
1204         _mint(to, quantity);
1205 
1206         unchecked {
1207             if (to.code.length != 0) {
1208                 uint256 end = _currentIndex;
1209                 uint256 index = end - quantity;
1210                 do {
1211                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1212                         revert TransferToNonERC721ReceiverImplementer();
1213                     }
1214                 } while (index < end);
1215                 // Reentrancy protection.
1216                 if (_currentIndex != end) revert();
1217             }
1218         }
1219     }
1220 
1221     /**
1222      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1223      */
1224     function _safeMint(address to, uint256 quantity) internal virtual {
1225         _safeMint(to, quantity, '');
1226     }
1227 
1228     // =============================================================
1229     //                        BURN OPERATIONS
1230     // =============================================================
1231 
1232     /**
1233      * @dev Equivalent to `_burn(tokenId, false)`.
1234      */
1235     function _burn(uint256 tokenId) internal virtual {
1236         _burn(tokenId, false);
1237     }
1238 
1239     /**
1240      * @dev Destroys `tokenId`.
1241      * The approval is cleared when the token is burned.
1242      *
1243      * Requirements:
1244      *
1245      * - `tokenId` must exist.
1246      *
1247      * Emits a {Transfer} event.
1248      */
1249     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1250         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1251 
1252         address from = address(uint160(prevOwnershipPacked));
1253 
1254         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1255 
1256         if (approvalCheck) {
1257             // The nested ifs save around 20+ gas over a compound boolean condition.
1258             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1259                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1260         }
1261 
1262         _beforeTokenTransfers(from, address(0), tokenId, 1);
1263 
1264         // Clear approvals from the previous owner.
1265         assembly {
1266             if approvedAddress {
1267                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1268                 sstore(approvedAddressSlot, 0)
1269             }
1270         }
1271 
1272         // Underflow of the sender's balance is impossible because we check for
1273         // ownership above and the recipient's balance can't realistically overflow.
1274         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1275         unchecked {
1276             // Updates:
1277             // - `balance -= 1`.
1278             // - `numberBurned += 1`.
1279             //
1280             // We can directly decrement the balance, and increment the number burned.
1281             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1282             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1283 
1284             // Updates:
1285             // - `address` to the last owner.
1286             // - `startTimestamp` to the timestamp of burning.
1287             // - `burned` to `true`.
1288             // - `nextInitialized` to `true`.
1289             _packedOwnerships[tokenId] = _packOwnershipData(
1290                 from,
1291                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1292             );
1293 
1294             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1295             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1296                 uint256 nextTokenId = tokenId + 1;
1297                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1298                 if (_packedOwnerships[nextTokenId] == 0) {
1299                     // If the next slot is within bounds.
1300                     if (nextTokenId != _currentIndex) {
1301                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1302                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1303                     }
1304                 }
1305             }
1306         }
1307 
1308         emit Transfer(from, address(0), tokenId);
1309         _afterTokenTransfers(from, address(0), tokenId, 1);
1310 
1311         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1312         unchecked {
1313             _burnCounter++;
1314         }
1315     }
1316 
1317     // =============================================================
1318     //                     EXTRA DATA OPERATIONS
1319     // =============================================================
1320 
1321     /**
1322      * @dev Directly sets the extra data for the ownership data `index`.
1323      */
1324     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1325         uint256 packed = _packedOwnerships[index];
1326         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1327         uint256 extraDataCasted;
1328         // Cast `extraData` with assembly to avoid redundant masking.
1329         assembly {
1330             extraDataCasted := extraData
1331         }
1332         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1333         _packedOwnerships[index] = packed;
1334     }
1335 
1336     /**
1337      * @dev Called during each token transfer to set the 24bit `extraData` field.
1338      * Intended to be overridden by the cosumer contract.
1339      *
1340      * `previousExtraData` - the value of `extraData` before transfer.
1341      *
1342      * Calling conditions:
1343      *
1344      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1345      * transferred to `to`.
1346      * - When `from` is zero, `tokenId` will be minted for `to`.
1347      * - When `to` is zero, `tokenId` will be burned by `from`.
1348      * - `from` and `to` are never both zero.
1349      */
1350     function _extraData(
1351         address from,
1352         address to,
1353         uint24 previousExtraData
1354     ) internal view virtual returns (uint24) {}
1355 
1356     /**
1357      * @dev Returns the next extra data for the packed ownership data.
1358      * The returned result is shifted into position.
1359      */
1360     function _nextExtraData(
1361         address from,
1362         address to,
1363         uint256 prevOwnershipPacked
1364     ) private view returns (uint256) {
1365         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1366         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1367     }
1368 
1369     // =============================================================
1370     //                       OTHER OPERATIONS
1371     // =============================================================
1372 
1373     /**
1374      * @dev Returns the message sender (defaults to `msg.sender`).
1375      *
1376      * If you are writing GSN compatible contracts, you need to override this function.
1377      */
1378     function _msgSenderERC721A() internal view virtual returns (address) {
1379         return msg.sender;
1380     }
1381 
1382     /**
1383      * @dev Converts a uint256 to its ASCII string decimal representation.
1384      */
1385     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1386         assembly {
1387             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1388             // but we allocate 0x80 bytes to keep the free memory pointer 32-byte word aligned.
1389             // We will need 1 32-byte word to store the length,
1390             // and 3 32-byte words to store a maximum of 78 digits. Total: 0x20 + 3 * 0x20 = 0x80.
1391             str := add(mload(0x40), 0x80)
1392             // Update the free memory pointer to allocate.
1393             mstore(0x40, str)
1394 
1395             // Cache the end of the memory to calculate the length later.
1396             let end := str
1397 
1398             // We write the string from rightmost digit to leftmost digit.
1399             // The following is essentially a do-while loop that also handles the zero case.
1400             // prettier-ignore
1401             for { let temp := value } 1 {} {
1402                 str := sub(str, 1)
1403                 // Write the character to the pointer.
1404                 // The ASCII index of the '0' character is 48.
1405                 mstore8(str, add(48, mod(temp, 10)))
1406                 // Keep dividing `temp` until zero.
1407                 temp := div(temp, 10)
1408                 // prettier-ignore
1409                 if iszero(temp) { break }
1410             }
1411 
1412             let length := sub(end, str)
1413             // Move the pointer 32 bytes leftwards to make room for the length.
1414             str := sub(str, 0x20)
1415             // Store the length.
1416             mstore(str, length)
1417         }
1418     }
1419 }