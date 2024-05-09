1 // SPDX-License-Identifier: GPL-3.0                                                                                                                        
2                                                                                                                                 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Interface of ERC721A.
7  */
8 interface IERC721A {
9     /**
10      * The caller must own the token or be an approved operator.
11      */
12     error ApprovalCallerNotOwnerNorApproved();
13 
14     /**
15      * The token does not exist.
16      */
17     error ApprovalQueryForNonexistentToken();
18 
19     /**
20      * Cannot query the balance for the zero address.
21      */
22     error BalanceQueryForZeroAddress();
23 
24     /**
25      * Cannot mint to the zero address.
26      */
27     error MintToZeroAddress();
28 
29     /**
30      * The quantity of tokens minted must be more than zero.
31      */
32     error MintZeroQuantity();
33 
34     /**
35      * The token does not exist.
36      */
37     error OwnerQueryForNonexistentToken();
38 
39     /**
40      * The caller must own the token or be an approved operator.
41      */
42     error TransferCallerNotOwnerNorApproved();
43 
44     /**
45      * The token must be owned by `from`.
46      */
47     error TransferFromIncorrectOwner();
48 
49     /**
50      * Cannot safely transfer to a contract that does not implement the
51      * ERC721Receiver interface.
52      */
53     error TransferToNonERC721ReceiverImplementer();
54 
55     /**
56      * Cannot transfer to the zero address.
57      */
58     error TransferToZeroAddress();
59 
60     /**
61      * The token does not exist.
62      */
63     error URIQueryForNonexistentToken();
64 
65     /**
66      * The `quantity` minted with ERC2309 exceeds the safety limit.
67      */
68     error MintERC2309QuantityExceedsLimit();
69 
70     /**
71      * The `extraData` cannot be set on an unintialized ownership slot.
72      */
73     error OwnershipNotInitializedForExtraData();
74 
75     // =============================================================
76     //                            STRUCTS
77     // =============================================================
78 
79     struct TokenOwnership {
80         // The address of the owner.
81         address addr;
82         // Stores the start time of ownership with minimal overhead for tokenomics.
83         uint64 startTimestamp;
84         // Whether the token has been burned.
85         bool burned;
86         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
87         uint24 extraData;
88     }
89 
90     // =============================================================
91     //                         TOKEN COUNTERS
92     // =============================================================
93 
94     /**
95      * @dev Returns the total number of tokens in existence.
96      * Burned tokens will reduce the count.
97      * To get the total number of tokens minted, please see {_totalMinted}.
98      */
99     function totalSupply() external view returns (uint256);
100 
101     // =============================================================
102     //                            IERC165
103     // =============================================================
104 
105     /**
106      * @dev Returns true if this contract implements the interface defined by
107      * `interfaceId`. See the corresponding
108      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
109      * to learn more about how these ids are created.
110      *
111      * This function call must use less than 30000 gas.
112      */
113     function supportsInterface(bytes4 interfaceId) external view returns (bool);
114 
115     // =============================================================
116     //                            IERC721
117     // =============================================================
118 
119     /**
120      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
121      */
122     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
123 
124     /**
125      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
126      */
127     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
128 
129     /**
130      * @dev Emitted when `owner` enables or disables
131      * (`approved`) `operator` to manage all of its assets.
132      */
133     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
134 
135     /**
136      * @dev Returns the number of tokens in `owner`'s account.
137      */
138     function balanceOf(address owner) external view returns (uint256 balance);
139 
140     /**
141      * @dev Returns the owner of the `tokenId` token.
142      *
143      * Requirements:
144      *
145      * - `tokenId` must exist.
146      */
147     function ownerOf(uint256 tokenId) external view returns (address owner);
148 
149     /**
150      * @dev Safely transfers `tokenId` token from `from` to `to`,
151      * checking first that contract recipients are aware of the ERC721 protocol
152      * to prevent tokens from being forever locked.
153      *
154      * Requirements:
155      *
156      * - `from` cannot be the zero address.
157      * - `to` cannot be the zero address.
158      * - `tokenId` token must exist and be owned by `from`.
159      * - If the caller is not `from`, it must be have been allowed to move
160      * this token by either {approve} or {setApprovalForAll}.
161      * - If `to` refers to a smart contract, it must implement
162      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
163      *
164      * Emits a {Transfer} event.
165      */
166     function safeTransferFrom(
167         address from,
168         address to,
169         uint256 tokenId,
170         bytes calldata data
171     ) external payable;
172 
173     /**
174      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
175      */
176     function safeTransferFrom(
177         address from,
178         address to,
179         uint256 tokenId
180     ) external payable;
181 
182     /**
183      * @dev Transfers `tokenId` from `from` to `to`.
184      *
185      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
186      * whenever possible.
187      *
188      * Requirements:
189      *
190      * - `from` cannot be the zero address.
191      * - `to` cannot be the zero address.
192      * - `tokenId` token must be owned by `from`.
193      * - If the caller is not `from`, it must be approved to move this token
194      * by either {approve} or {setApprovalForAll}.
195      *
196      * Emits a {Transfer} event.
197      */
198     function transferFrom(
199         address from,
200         address to,
201         uint256 tokenId
202     ) external payable;
203 
204     /**
205      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
206      * The approval is cleared when the token is transferred.
207      *
208      * Only a single account can be approved at a time, so approving the
209      * zero address clears previous approvals.
210      *
211      * Requirements:
212      *
213      * - The caller must own the token or be an approved operator.
214      * - `tokenId` must exist.
215      *
216      * Emits an {Approval} event.
217      */
218     function approve(address to, uint256 tokenId) external payable;
219 
220     /**
221      * @dev Approve or remove `operator` as an operator for the caller.
222      * Operators can call {transferFrom} or {safeTransferFrom}
223      * for any token owned by the caller.
224      *
225      * Requirements:
226      *
227      * - The `operator` cannot be the caller.
228      *
229      * Emits an {ApprovalForAll} event.
230      */
231     function setApprovalForAll(address operator, bool _approved) external;
232 
233     /**
234      * @dev Returns the account approved for `tokenId` token.
235      *
236      * Requirements:
237      *
238      * - `tokenId` must exist.
239      */
240     function getApproved(uint256 tokenId) external view returns (address operator);
241 
242     /**
243      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
244      *
245      * See {setApprovalForAll}.
246      */
247     function isApprovedForAll(address owner, address operator) external view returns (bool);
248 
249     // =============================================================
250     //                        IERC721Metadata
251     // =============================================================
252 
253     /**
254      * @dev Returns the token collection name.
255      */
256     function name() external view returns (string memory);
257 
258     /**
259      * @dev Returns the token collection symbol.
260      */
261     function symbol() external view returns (string memory);
262 
263     /**
264      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
265      */
266     function tokenURI(uint256 tokenId) external view returns (string memory);
267 
268     // =============================================================
269     //                           IERC2309
270     // =============================================================
271 
272     /**
273      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
274      * (inclusive) is transferred from `from` to `to`, as defined in the
275      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
276      *
277      * See {_mintERC2309} for more details.
278      */
279     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
280 }
281 
282 /**
283  * @title ERC721A
284  *
285  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
286  * Non-Fungible Token Standard, including the Metadata extension.
287  * Optimized for lower gas during batch mints.
288  *
289  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
290  * starting from `_startTokenId()`.
291  *
292  * Assumptions:
293  *
294  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
295  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
296  */
297 interface ERC721A__IERC721Receiver {
298     function onERC721Received(
299         address operator,
300         address from,
301         uint256 tokenId,
302         bytes calldata data
303     ) external returns (bytes4);
304 }
305 
306 /**
307  * @title ERC721A
308  *
309  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
310  * Non-Fungible Token Standard, including the Metadata extension.
311  * Optimized for lower gas during batch mints.
312  *
313  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
314  * starting from `_startTokenId()`.
315  *
316  * Assumptions:
317  *
318  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
319  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
320  */
321 contract ZenPepe_ERC721A is IERC721A {
322     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
323     struct TokenApprovalRef {
324         address value;
325     }
326 
327     // =============================================================
328     //                           CONSTANTS
329     // =============================================================
330 
331     // Mask of an entry in packed address data.
332     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
333 
334     // The bit position of `numberMinted` in packed address data.
335     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
336 
337     // The bit position of `numberBurned` in packed address data.
338     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
339 
340     // The bit position of `aux` in packed address data.
341     uint256 private constant _BITPOS_AUX = 192;
342 
343     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
344     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
345 
346     // The bit position of `startTimestamp` in packed ownership.
347     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
348 
349     // The bit mask of the `burned` bit in packed ownership.
350     uint256 private constant _BITMASK_BURNED = 1 << 224;
351 
352     // The bit position of the `nextInitialized` bit in packed ownership.
353     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
354 
355     // The bit mask of the `nextInitialized` bit in packed ownership.
356     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
357 
358     // The bit position of `extraData` in packed ownership.
359     uint256 private constant _BITPOS_EXTRA_DATA = 232;
360 
361     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
362     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
363 
364     // The mask of the lower 160 bits for addresses.
365     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
366 
367     // The maximum `quantity` that can be minted with {_mintERC2309}.
368     // This limit is to prevent overflows on the address data entries.
369     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
370     // is required to cause an overflow, which is unrealistic.
371     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
372 
373     // The `Transfer` event signature is given by:
374     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
375     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
376         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
377 
378     // =============================================================
379     //                            STORAGE
380     // =============================================================
381 
382     // The next token ID to be minted.
383     uint256 private _currentIndex;
384 
385     // The number of tokens burned.
386     uint256 private _burnCounter;
387 
388     // Token name
389     string private _name;
390 
391     // Token symbol
392     string private _symbol;
393 
394     // Mapping from token ID to ownership details
395     // An empty struct value does not necessarily mean the token is unowned.
396     // See {_packedOwnershipOf} implementation for details.
397     //
398     // Bits Layout:
399     // - [0..159]   `addr`
400     // - [160..223] `startTimestamp`
401     // - [224]      `burned`
402     // - [225]      `nextInitialized`
403     // - [232..255] `extraData`
404     mapping(uint256 => uint256) private _packedOwnerships;
405 
406     // Mapping owner address to address data.
407     //
408     // Bits Layout:
409     // - [0..63]    `balance`
410     // - [64..127]  `numberMinted`
411     // - [128..191] `numberBurned`
412     // - [192..255] `aux`
413     mapping(address => uint256) private _packedAddressData;
414 
415     // Mapping from token ID to approved address.
416     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
417 
418     // Mapping from owner to operator approvals
419     mapping(address => mapping(address => bool)) private _operatorApprovals;
420 
421     address public owner;
422 
423     uint256 public constant maxSupply = 999;
424 
425     uint256 public constant COST = 0.003 ether;
426 
427     mapping(address => uint256) private _userForFree;
428 
429     mapping(uint256 => uint256) private _userMinted;
430 
431     // =============================================================
432     //                          CONSTRUCTOR
433     // =============================================================
434 
435     constructor() {
436         owner = msg.sender;
437         _name = "Zen Pepe";
438         _symbol = "ZPepe";
439         _currentIndex = _startTokenId();
440     }
441 
442 
443     function mint(uint256 amount) 
444         canmint(amount) 
445         payable 
446         public {
447         require(totalSupply() + amount <= maxSupply);
448         _safeMint(msg.sender, amount);
449     }
450 
451     function team_mint(address addr, uint256 amount) 
452         public 
453         onlyOwner {
454         require(totalSupply() + amount <= maxSupply);
455         _safeMint(addr, amount);
456     }
457 
458     modifier canmint(uint256 amount) {
459         if (msg.value == 0) {
460             require(amount == 1);
461             if (totalSupply() > maxSupply / 5) {
462                 require(_userMinted[block.number] < FreeNum() 
463                     && _userForFree[tx.origin] < 1 );
464                 _userForFree[tx.origin]++;
465                 _userMinted[block.number]++;
466             }
467         } else {
468             require(msg.value >= amount * COST);
469         }
470         _;
471     }
472     
473     modifier onlyOwner {
474         require(owner == msg.sender);
475         _;
476     }
477 
478 
479     function tokenURI(uint256 tokenId) public view override returns (string memory) {
480         return string(abi.encodePacked("ipfs://QmUkP8pnhuUAXmJJzAdcQmBCQy39VS4e8t9cboyaH6TFaP/", _toString(tokenId), ".json"));
481     }
482 
483     function FreeNum() internal returns (uint256){
484         return (maxSupply - totalSupply()) / 12;
485     }
486 
487     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual returns (address, uint256) {
488         uint256 royaltyAmount = (_salePrice * 50) / 1000;
489         return (owner, royaltyAmount);
490     }
491 
492     function withdraw() external onlyOwner {
493         payable(msg.sender).transfer(address(this).balance);
494     }
495 
496     // =============================================================
497     //                   TOKEN COUNTING OPERATIONS
498     // =============================================================
499 
500     /**
501      * @dev Returns the starting token ID.
502      * To change the starting token ID, please override this function.
503      */
504     function _startTokenId() internal view virtual returns (uint256) {
505         return 0;
506     }
507 
508     /**
509      * @dev Returns the next token ID to be minted.
510      */
511     function _nextTokenId() internal view virtual returns (uint256) {
512         return _currentIndex;
513     }
514 
515     /**
516      * @dev Returns the total number of tokens in existence.
517      * Burned tokens will reduce the count.
518      * To get the total number of tokens minted, please see {_totalMinted}.
519      */
520     function totalSupply() public view virtual override returns (uint256) {
521         // Counter underflow is impossible as _burnCounter cannot be incremented
522         // more than `_currentIndex - _startTokenId()` times.
523         unchecked {
524             return _currentIndex - _burnCounter - _startTokenId();
525         }
526     }
527 
528     /**
529      * @dev Returns the total amount of tokens minted in the contract.
530      */
531     function _totalMinted() internal view virtual returns (uint256) {
532         // Counter underflow is impossible as `_currentIndex` does not decrement,
533         // and it is initialized to `_startTokenId()`.
534         unchecked {
535             return _currentIndex - _startTokenId();
536         }
537     }
538 
539     /**
540      * @dev Returns the total number of tokens burned.
541      */
542     function _totalBurned() internal view virtual returns (uint256) {
543         return _burnCounter;
544     }
545 
546     // =============================================================
547     //                    ADDRESS DATA OPERATIONS
548     // =============================================================
549 
550     /**
551      * @dev Returns the number of tokens in `owner`'s account.
552      */
553     function balanceOf(address owner) public view virtual override returns (uint256) {
554         if (owner == address(0)) revert BalanceQueryForZeroAddress();
555         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
556     }
557 
558     /**
559      * Returns the number of tokens minted by `owner`.
560      */
561     function _numberMinted(address owner) internal view returns (uint256) {
562         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
563     }
564 
565     /**
566      * Returns the number of tokens burned by or on behalf of `owner`.
567      */
568     function _numberBurned(address owner) internal view returns (uint256) {
569         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
570     }
571 
572     /**
573      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
574      */
575     function _getAux(address owner) internal view returns (uint64) {
576         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
577     }
578 
579     /**
580      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
581      * If there are multiple variables, please pack them into a uint64.
582      */
583     function _setAux(address owner, uint64 aux) internal virtual {
584         uint256 packed = _packedAddressData[owner];
585         uint256 auxCasted;
586         // Cast `aux` with assembly to avoid redundant masking.
587         assembly {
588             auxCasted := aux
589         }
590         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
591         _packedAddressData[owner] = packed;
592     }
593 
594     // =============================================================
595     //                            IERC165
596     // =============================================================
597 
598     /**
599      * @dev Returns true if this contract implements the interface defined by
600      * `interfaceId`. See the corresponding
601      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
602      * to learn more about how these ids are created.
603      *
604      * This function call must use less than 30000 gas.
605      */
606     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
607         // The interface IDs are constants representing the first 4 bytes
608         // of the XOR of all function selectors in the interface.
609         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
610         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
611         return
612             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
613             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
614             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
615     }
616 
617     // =============================================================
618     //                        IERC721Metadata
619     // =============================================================
620 
621     /**
622      * @dev Returns the token collection name.
623      */
624     function name() public view virtual override returns (string memory) {
625         return _name;
626     }
627 
628     /**
629      * @dev Returns the token collection symbol.
630      */
631     function symbol() public view virtual override returns (string memory) {
632         return _symbol;
633     }
634 
635     /**
636      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
637      */
638     // function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
639     //     if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
640 
641     //     string memory baseURI = _baseURI();
642     //     return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
643     // }
644 
645     /**
646      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
647      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
648      * by default, it can be overridden in child contracts.
649      */
650     function _baseURI() internal view virtual returns (string memory) {
651         return '';
652     }
653 
654     // =============================================================
655     //                     OWNERSHIPS OPERATIONS
656     // =============================================================
657 
658     /**
659      * @dev Returns the owner of the `tokenId` token.
660      *
661      * Requirements:
662      *
663      * - `tokenId` must exist.
664      */
665     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
666         return address(uint160(_packedOwnershipOf(tokenId)));
667     }
668 
669     /**
670      * @dev Gas spent here starts off proportional to the maximum mint batch size.
671      * It gradually moves to O(1) as tokens get transferred around over time.
672      */
673     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
674         return _unpackedOwnership(_packedOwnershipOf(tokenId));
675     }
676 
677     /**
678      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
679      */
680     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
681         return _unpackedOwnership(_packedOwnerships[index]);
682     }
683 
684     /**
685      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
686      */
687     function _initializeOwnershipAt(uint256 index) internal virtual {
688         if (_packedOwnerships[index] == 0) {
689             _packedOwnerships[index] = _packedOwnershipOf(index);
690         }
691     }
692 
693     /**
694      * Returns the packed ownership data of `tokenId`.
695      */
696     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
697         uint256 curr = tokenId;
698 
699         unchecked {
700             if (_startTokenId() <= curr)
701                 if (curr < _currentIndex) {
702                     uint256 packed = _packedOwnerships[curr];
703                     // If not burned.
704                     if (packed & _BITMASK_BURNED == 0) {
705                         // Invariant:
706                         // There will always be an initialized ownership slot
707                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
708                         // before an unintialized ownership slot
709                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
710                         // Hence, `curr` will not underflow.
711                         //
712                         // We can directly compare the packed value.
713                         // If the address is zero, packed will be zero.
714                         while (packed == 0) {
715                             packed = _packedOwnerships[--curr];
716                         }
717                         return packed;
718                     }
719                 }
720         }
721         revert OwnerQueryForNonexistentToken();
722     }
723 
724     /**
725      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
726      */
727     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
728         ownership.addr = address(uint160(packed));
729         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
730         ownership.burned = packed & _BITMASK_BURNED != 0;
731         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
732     }
733 
734     /**
735      * @dev Packs ownership data into a single uint256.
736      */
737     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
738         assembly {
739             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
740             owner := and(owner, _BITMASK_ADDRESS)
741             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
742             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
743         }
744     }
745 
746     /**
747      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
748      */
749     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
750         // For branchless setting of the `nextInitialized` flag.
751         assembly {
752             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
753             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
754         }
755     }
756 
757     // =============================================================
758     //                      APPROVAL OPERATIONS
759     // =============================================================
760 
761     /**
762      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
763      * The approval is cleared when the token is transferred.
764      *
765      * Only a single account can be approved at a time, so approving the
766      * zero address clears previous approvals.
767      *
768      * Requirements:
769      *
770      * - The caller must own the token or be an approved operator.
771      * - `tokenId` must exist.
772      *
773      * Emits an {Approval} event.
774      */
775     function approve(address to, uint256 tokenId) public payable virtual override {
776         address owner = ownerOf(tokenId);
777 
778         if (_msgSenderERC721A() != owner)
779             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
780                 revert ApprovalCallerNotOwnerNorApproved();
781             }
782 
783         _tokenApprovals[tokenId].value = to;
784         emit Approval(owner, to, tokenId);
785     }
786 
787     /**
788      * @dev Returns the account approved for `tokenId` token.
789      *
790      * Requirements:
791      *
792      * - `tokenId` must exist.
793      */
794     function getApproved(uint256 tokenId) public view virtual override returns (address) {
795         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
796 
797         return _tokenApprovals[tokenId].value;
798     }
799 
800     /**
801      * @dev Approve or remove `operator` as an operator for the caller.
802      * Operators can call {transferFrom} or {safeTransferFrom}
803      * for any token owned by the caller.
804      *
805      * Requirements:
806      *
807      * - The `operator` cannot be the caller.
808      *
809      * Emits an {ApprovalForAll} event.
810      */
811     function setApprovalForAll(address operator, bool approved) public virtual override {
812         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
813         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
814     }
815 
816     /**
817      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
818      *
819      * See {setApprovalForAll}.
820      */
821     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
822         return _operatorApprovals[owner][operator];
823     }
824 
825     /**
826      * @dev Returns whether `tokenId` exists.
827      *
828      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
829      *
830      * Tokens start existing when they are minted. See {_mint}.
831      */
832     function _exists(uint256 tokenId) internal view virtual returns (bool) {
833         return
834             _startTokenId() <= tokenId &&
835             tokenId < _currentIndex && // If within bounds,
836             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
837     }
838 
839     /**
840      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
841      */
842     function _isSenderApprovedOrOwner(
843         address approvedAddress,
844         address owner,
845         address msgSender
846     ) private pure returns (bool result) {
847         assembly {
848             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
849             owner := and(owner, _BITMASK_ADDRESS)
850             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
851             msgSender := and(msgSender, _BITMASK_ADDRESS)
852             // `msgSender == owner || msgSender == approvedAddress`.
853             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
854         }
855     }
856 
857     /**
858      * @dev Returns the storage slot and value for the approved address of `tokenId`.
859      */
860     function _getApprovedSlotAndAddress(uint256 tokenId)
861         private
862         view
863         returns (uint256 approvedAddressSlot, address approvedAddress)
864     {
865         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
866         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
867         assembly {
868             approvedAddressSlot := tokenApproval.slot
869             approvedAddress := sload(approvedAddressSlot)
870         }
871     }
872 
873     // =============================================================
874     //                      TRANSFER OPERATIONS
875     // =============================================================
876 
877     /**
878      * @dev Transfers `tokenId` from `from` to `to`.
879      *
880      * Requirements:
881      *
882      * - `from` cannot be the zero address.
883      * - `to` cannot be the zero address.
884      * - `tokenId` token must be owned by `from`.
885      * - If the caller is not `from`, it must be approved to move this token
886      * by either {approve} or {setApprovalForAll}.
887      *
888      * Emits a {Transfer} event.
889      */
890     function transferFrom(
891         address from,
892         address to,
893         uint256 tokenId
894     ) public payable virtual override {
895         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
896 
897         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
898 
899         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
900 
901         // The nested ifs save around 20+ gas over a compound boolean condition.
902         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
903             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
904 
905         if (to == address(0)) revert TransferToZeroAddress();
906 
907         _beforeTokenTransfers(from, to, tokenId, 1);
908 
909         // Clear approvals from the previous owner.
910         assembly {
911             if approvedAddress {
912                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
913                 sstore(approvedAddressSlot, 0)
914             }
915         }
916 
917         // Underflow of the sender's balance is impossible because we check for
918         // ownership above and the recipient's balance can't realistically overflow.
919         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
920         unchecked {
921             // We can directly increment and decrement the balances.
922             --_packedAddressData[from]; // Updates: `balance -= 1`.
923             ++_packedAddressData[to]; // Updates: `balance += 1`.
924 
925             // Updates:
926             // - `address` to the next owner.
927             // - `startTimestamp` to the timestamp of transfering.
928             // - `burned` to `false`.
929             // - `nextInitialized` to `true`.
930             _packedOwnerships[tokenId] = _packOwnershipData(
931                 to,
932                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
933             );
934 
935             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
936             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
937                 uint256 nextTokenId = tokenId + 1;
938                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
939                 if (_packedOwnerships[nextTokenId] == 0) {
940                     // If the next slot is within bounds.
941                     if (nextTokenId != _currentIndex) {
942                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
943                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
944                     }
945                 }
946             }
947         }
948 
949         emit Transfer(from, to, tokenId);
950         _afterTokenTransfers(from, to, tokenId, 1);
951     }
952 
953     /**
954      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
955      */
956     function safeTransferFrom(
957         address from,
958         address to,
959         uint256 tokenId
960     ) public payable virtual override {
961         safeTransferFrom(from, to, tokenId, '');
962     }
963 
964 
965     /**
966      * @dev Safely transfers `tokenId` token from `from` to `to`.
967      *
968      * Requirements:
969      *
970      * - `from` cannot be the zero address.
971      * - `to` cannot be the zero address.
972      * - `tokenId` token must exist and be owned by `from`.
973      * - If the caller is not `from`, it must be approved to move this token
974      * by either {approve} or {setApprovalForAll}.
975      * - If `to` refers to a smart contract, it must implement
976      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
977      *
978      * Emits a {Transfer} event.
979      */
980     function safeTransferFrom(
981         address from,
982         address to,
983         uint256 tokenId,
984         bytes memory _data
985     ) public payable virtual override {
986         transferFrom(from, to, tokenId);
987         if (to.code.length != 0)
988             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
989                 revert TransferToNonERC721ReceiverImplementer();
990             }
991     }
992 
993     /**
994      * @dev Hook that is called before a set of serially-ordered token IDs
995      * are about to be transferred. This includes minting.
996      * And also called before burning one token.
997      *
998      * `startTokenId` - the first token ID to be transferred.
999      * `quantity` - the amount to be transferred.
1000      *
1001      * Calling conditions:
1002      *
1003      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1004      * transferred to `to`.
1005      * - When `from` is zero, `tokenId` will be minted for `to`.
1006      * - When `to` is zero, `tokenId` will be burned by `from`.
1007      * - `from` and `to` are never both zero.
1008      */
1009     function _beforeTokenTransfers(
1010         address from,
1011         address to,
1012         uint256 startTokenId,
1013         uint256 quantity
1014     ) internal virtual {}
1015 
1016     /**
1017      * @dev Hook that is called after a set of serially-ordered token IDs
1018      * have been transferred. This includes minting.
1019      * And also called after one token has been burned.
1020      *
1021      * `startTokenId` - the first token ID to be transferred.
1022      * `quantity` - the amount to be transferred.
1023      *
1024      * Calling conditions:
1025      *
1026      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1027      * transferred to `to`.
1028      * - When `from` is zero, `tokenId` has been minted for `to`.
1029      * - When `to` is zero, `tokenId` has been burned by `from`.
1030      * - `from` and `to` are never both zero.
1031      */
1032     function _afterTokenTransfers(
1033         address from,
1034         address to,
1035         uint256 startTokenId,
1036         uint256 quantity
1037     ) internal virtual {}
1038 
1039     /**
1040      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1041      *
1042      * `from` - Previous owner of the given token ID.
1043      * `to` - Target address that will receive the token.
1044      * `tokenId` - Token ID to be transferred.
1045      * `_data` - Optional data to send along with the call.
1046      *
1047      * Returns whether the call correctly returned the expected magic value.
1048      */
1049     function _checkContractOnERC721Received(
1050         address from,
1051         address to,
1052         uint256 tokenId,
1053         bytes memory _data
1054     ) private returns (bool) {
1055         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1056             bytes4 retval
1057         ) {
1058             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
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
1070     // =============================================================
1071     //                        MINT OPERATIONS
1072     // =============================================================
1073 
1074     /**
1075      * @dev Mints `quantity` tokens and transfers them to `to`.
1076      *
1077      * Requirements:
1078      *
1079      * - `to` cannot be the zero address.
1080      * - `quantity` must be greater than 0.
1081      *
1082      * Emits a {Transfer} event for each mint.
1083      */
1084     function _mint(address to, uint256 quantity) internal virtual {
1085         uint256 startTokenId = _currentIndex;
1086         if (quantity == 0) revert MintZeroQuantity();
1087 
1088         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1089 
1090         // Overflows are incredibly unrealistic.
1091         // `balance` and `numberMinted` have a maximum limit of 2**64.
1092         // `tokenId` has a maximum limit of 2**256.
1093         unchecked {
1094             // Updates:
1095             // - `balance += quantity`.
1096             // - `numberMinted += quantity`.
1097             //
1098             // We can directly add to the `balance` and `numberMinted`.
1099             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1100 
1101             // Updates:
1102             // - `address` to the owner.
1103             // - `startTimestamp` to the timestamp of minting.
1104             // - `burned` to `false`.
1105             // - `nextInitialized` to `quantity == 1`.
1106             _packedOwnerships[startTokenId] = _packOwnershipData(
1107                 to,
1108                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1109             );
1110 
1111             uint256 toMasked;
1112             uint256 end = startTokenId + quantity;
1113 
1114             // Use assembly to loop and emit the `Transfer` event for gas savings.
1115             // The duplicated `log4` removes an extra check and reduces stack juggling.
1116             // The assembly, together with the surrounding Solidity code, have been
1117             // delicately arranged to nudge the compiler into producing optimized opcodes.
1118             assembly {
1119                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1120                 toMasked := and(to, _BITMASK_ADDRESS)
1121                 // Emit the `Transfer` event.
1122                 log4(
1123                     0, // Start of data (0, since no data).
1124                     0, // End of data (0, since no data).
1125                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1126                     0, // `address(0)`.
1127                     toMasked, // `to`.
1128                     startTokenId // `tokenId`.
1129                 )
1130 
1131                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1132                 // that overflows uint256 will make the loop run out of gas.
1133                 // The compiler will optimize the `iszero` away for performance.
1134                 for {
1135                     let tokenId := add(startTokenId, 1)
1136                 } iszero(eq(tokenId, end)) {
1137                     tokenId := add(tokenId, 1)
1138                 } {
1139                     // Emit the `Transfer` event. Similar to above.
1140                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1141                 }
1142             }
1143             if (toMasked == 0) revert MintToZeroAddress();
1144 
1145             _currentIndex = end;
1146         }
1147         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1148     }
1149 
1150     /**
1151      * @dev Mints `quantity` tokens and transfers them to `to`.
1152      *
1153      * This function is intended for efficient minting only during contract creation.
1154      *
1155      * It emits only one {ConsecutiveTransfer} as defined in
1156      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1157      * instead of a sequence of {Transfer} event(s).
1158      *
1159      * Calling this function outside of contract creation WILL make your contract
1160      * non-compliant with the ERC721 standard.
1161      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1162      * {ConsecutiveTransfer} event is only permissible during contract creation.
1163      *
1164      * Requirements:
1165      *
1166      * - `to` cannot be the zero address.
1167      * - `quantity` must be greater than 0.
1168      *
1169      * Emits a {ConsecutiveTransfer} event.
1170      */
1171     function _mintERC2309(address to, uint256 quantity) internal virtual {
1172         uint256 startTokenId = _currentIndex;
1173         if (to == address(0)) revert MintToZeroAddress();
1174         if (quantity == 0) revert MintZeroQuantity();
1175         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1176 
1177         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1178 
1179         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1180         unchecked {
1181             // Updates:
1182             // - `balance += quantity`.
1183             // - `numberMinted += quantity`.
1184             //
1185             // We can directly add to the `balance` and `numberMinted`.
1186             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1187 
1188             // Updates:
1189             // - `address` to the owner.
1190             // - `startTimestamp` to the timestamp of minting.
1191             // - `burned` to `false`.
1192             // - `nextInitialized` to `quantity == 1`.
1193             _packedOwnerships[startTokenId] = _packOwnershipData(
1194                 to,
1195                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1196             );
1197 
1198             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1199 
1200             _currentIndex = startTokenId + quantity;
1201         }
1202         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1203     }
1204 
1205     /**
1206      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1207      *
1208      * Requirements:
1209      *
1210      * - If `to` refers to a smart contract, it must implement
1211      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1212      * - `quantity` must be greater than 0.
1213      *
1214      * See {_mint}.
1215      *
1216      * Emits a {Transfer} event for each mint.
1217      */
1218     function _safeMint(
1219         address to,
1220         uint256 quantity,
1221         bytes memory _data
1222     ) internal virtual {
1223         _mint(to, quantity);
1224 
1225         unchecked {
1226             if (to.code.length != 0) {
1227                 uint256 end = _currentIndex;
1228                 uint256 index = end - quantity;
1229                 do {
1230                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1231                         revert TransferToNonERC721ReceiverImplementer();
1232                     }
1233                 } while (index < end);
1234                 // Reentrancy protection.
1235                 if (_currentIndex != end) revert();
1236             }
1237         }
1238     }
1239 
1240     /**
1241      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1242      */
1243     function _safeMint(address to, uint256 quantity) internal virtual {
1244         _safeMint(to, quantity, '');
1245     }
1246 
1247     // =============================================================
1248     //                        BURN OPERATIONS
1249     // =============================================================
1250 
1251     /**
1252      * @dev Equivalent to `_burn(tokenId, false)`.
1253      */
1254     function _burn(uint256 tokenId) internal virtual {
1255         _burn(tokenId, false);
1256     }
1257 
1258     /**
1259      * @dev Destroys `tokenId`.
1260      * The approval is cleared when the token is burned.
1261      *
1262      * Requirements:
1263      *
1264      * - `tokenId` must exist.
1265      *
1266      * Emits a {Transfer} event.
1267      */
1268     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1269         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1270 
1271         address from = address(uint160(prevOwnershipPacked));
1272 
1273         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1274 
1275         if (approvalCheck) {
1276             // The nested ifs save around 20+ gas over a compound boolean condition.
1277             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1278                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1279         }
1280 
1281         _beforeTokenTransfers(from, address(0), tokenId, 1);
1282 
1283         // Clear approvals from the previous owner.
1284         assembly {
1285             if approvedAddress {
1286                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1287                 sstore(approvedAddressSlot, 0)
1288             }
1289         }
1290 
1291         // Underflow of the sender's balance is impossible because we check for
1292         // ownership above and the recipient's balance can't realistically overflow.
1293         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1294         unchecked {
1295             // Updates:
1296             // - `balance -= 1`.
1297             // - `numberBurned += 1`.
1298             //
1299             // We can directly decrement the balance, and increment the number burned.
1300             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1301             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1302 
1303             // Updates:
1304             // - `address` to the last owner.
1305             // - `startTimestamp` to the timestamp of burning.
1306             // - `burned` to `true`.
1307             // - `nextInitialized` to `true`.
1308             _packedOwnerships[tokenId] = _packOwnershipData(
1309                 from,
1310                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1311             );
1312 
1313             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1314             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1315                 uint256 nextTokenId = tokenId + 1;
1316                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1317                 if (_packedOwnerships[nextTokenId] == 0) {
1318                     // If the next slot is within bounds.
1319                     if (nextTokenId != _currentIndex) {
1320                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1321                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1322                     }
1323                 }
1324             }
1325         }
1326 
1327         emit Transfer(from, address(0), tokenId);
1328         _afterTokenTransfers(from, address(0), tokenId, 1);
1329 
1330         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1331         unchecked {
1332             _burnCounter++;
1333         }
1334     }
1335 
1336     // =============================================================
1337     //                     EXTRA DATA OPERATIONS
1338     // =============================================================
1339 
1340     /**
1341      * @dev Directly sets the extra data for the ownership data `index`.
1342      */
1343     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1344         uint256 packed = _packedOwnerships[index];
1345         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1346         uint256 extraDataCasted;
1347         // Cast `extraData` with assembly to avoid redundant masking.
1348         assembly {
1349             extraDataCasted := extraData
1350         }
1351         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1352         _packedOwnerships[index] = packed;
1353     }
1354 
1355     /**
1356      * @dev Called during each token transfer to set the 24bit `extraData` field.
1357      * Intended to be overridden by the cosumer contract.
1358      *
1359      * `previousExtraData` - the value of `extraData` before transfer.
1360      *
1361      * Calling conditions:
1362      *
1363      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1364      * transferred to `to`.
1365      * - When `from` is zero, `tokenId` will be minted for `to`.
1366      * - When `to` is zero, `tokenId` will be burned by `from`.
1367      * - `from` and `to` are never both zero.
1368      */
1369     function _extraData(
1370         address from,
1371         address to,
1372         uint24 previousExtraData
1373     ) internal view virtual returns (uint24) {}
1374 
1375     /**
1376      * @dev Returns the next extra data for the packed ownership data.
1377      * The returned result is shifted into position.
1378      */
1379     function _nextExtraData(
1380         address from,
1381         address to,
1382         uint256 prevOwnershipPacked
1383     ) private view returns (uint256) {
1384         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1385         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1386     }
1387 
1388     // =============================================================
1389     //                       OTHER OPERATIONS
1390     // =============================================================
1391 
1392     /**
1393      * @dev Returns the message sender (defaults to `msg.sender`).
1394      *
1395      * If you are writing GSN compatible contracts, you need to override this function.
1396      */
1397     function _msgSenderERC721A() internal view virtual returns (address) {
1398         return msg.sender;
1399     }
1400 
1401     /**
1402      * @dev Converts a uint256 to its ASCII string decimal representation.
1403      */
1404     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1405         assembly {
1406             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1407             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1408             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1409             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1410             let m := add(mload(0x40), 0xa0)
1411             // Update the free memory pointer to allocate.
1412             mstore(0x40, m)
1413             // Assign the `str` to the end.
1414             str := sub(m, 0x20)
1415             // Zeroize the slot after the string.
1416             mstore(str, 0)
1417 
1418             // Cache the end of the memory to calculate the length later.
1419             let end := str
1420 
1421             // We write the string from rightmost digit to leftmost digit.
1422             // The following is essentially a do-while loop that also handles the zero case.
1423             // prettier-ignore
1424             for { let temp := value } 1 {} {
1425                 str := sub(str, 1)
1426                 // Write the character to the pointer.
1427                 // The ASCII index of the '0' character is 48.
1428                 mstore8(str, add(48, mod(temp, 10)))
1429                 // Keep dividing `temp` until zero.
1430                 temp := div(temp, 10)
1431                 // prettier-ignore
1432                 if iszero(temp) { break }
1433             }
1434 
1435             let length := sub(end, str)
1436             // Move the pointer 32 bytes leftwards to make room for the length.
1437             str := sub(str, 0x20)
1438             // Store the length.
1439             mstore(str, length)
1440         }
1441     }
1442 }