1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.18;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes calldata) {
11         return msg.data;
12     }
13 }
14 
15 abstract contract Ownable is Context {
16     address private _owner;
17 
18     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
19 
20     constructor() {
21         _transferOwnership(_msgSender());
22     }
23 
24     modifier onlyOwner() {
25         _checkOwner();
26         _;
27     }
28 
29     function owner() public view virtual returns (address) {
30         return _owner;
31     }
32 
33     function _checkOwner() internal view virtual {
34         require(owner() == _msgSender(), "Ownable: caller is not the owner");
35     }
36 
37     function renounceOwnership() public virtual onlyOwner {
38         _transferOwnership(address(0));
39     }
40 
41 
42     function transferOwnership(address newOwner) public virtual onlyOwner {
43         require(newOwner != address(0), "Ownable: new owner is the zero address");
44         _transferOwnership(newOwner);
45     }
46 
47     function _transferOwnership(address newOwner) internal virtual {
48         address oldOwner = _owner;
49         _owner = newOwner;
50         emit OwnershipTransferred(oldOwner, newOwner);
51     }
52 }
53 
54 /**
55  * @dev Interface of ERC721A.
56  */
57 interface IERC721A {
58     /**
59      * The caller must own the token or be an approved operator.
60      */
61     error ApprovalCallerNotOwnerNorApproved();
62 
63     /**
64      * The token does not exist.
65      */
66     error ApprovalQueryForNonexistentToken();
67 
68     /**
69      * The caller cannot approve to their own address.
70      */
71     error ApproveToCaller();
72 
73     /**
74      * Cannot query the balance for the zero address.
75      */
76     error BalanceQueryForZeroAddress();
77 
78     /**
79      * Cannot mint to the zero address.
80      */
81     error MintToZeroAddress();
82 
83     /**
84      * The quantity of tokens minted must be more than zero.
85      */
86     error MintZeroQuantity();
87 
88     /**
89      * The token does not exist.
90      */
91     error OwnerQueryForNonexistentToken();
92 
93     /**
94      * The caller must own the token or be an approved operator.
95      */
96     error TransferCallerNotOwnerNorApproved();
97 
98     /**
99      * The token must be owned by `from`.
100      */
101     error TransferFromIncorrectOwner();
102 
103     /**
104      * Cannot safely transfer to a contract that does not implement the
105      * ERC721Receiver interface.
106      */
107     error TransferToNonERC721ReceiverImplementer();
108 
109     /**
110      * Cannot transfer to the zero address.
111      */
112     error TransferToZeroAddress();
113 
114     /**
115      * The token does not exist.
116      */
117     error URIQueryForNonexistentToken();
118 
119     /**
120      * The `quantity` minted with ERC2309 exceeds the safety limit.
121      */
122     error MintERC2309QuantityExceedsLimit();
123 
124     /**
125      * The `extraData` cannot be set on an unintialized ownership slot.
126      */
127     error OwnershipNotInitializedForExtraData();
128 
129     // =============================================================
130     //                            STRUCTS
131     // =============================================================
132 
133     struct TokenOwnership {
134         // The address of the owner.
135         address addr;
136         // Stores the start time of ownership with minimal overhead for tokenomics.
137         uint64 startTimestamp;
138         // Whether the token has been burned.
139         bool burned;
140         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
141         uint24 extraData;
142     }
143 
144     // =============================================================
145     //                         TOKEN COUNTERS
146     // =============================================================
147 
148     /**
149      * @dev Returns the total number of tokens in existence.
150      * Burned tokens will reduce the count.
151      * To get the total number of tokens minted, please see {_totalMinted}.
152      */
153     function totalSupply() external view returns (uint256);
154 
155     // =============================================================
156     //                            IERC165
157     // =============================================================
158 
159     /**
160      * @dev Returns true if this contract implements the interface defined by
161      * `interfaceId`. See the corresponding
162      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
163      * to learn more about how these ids are created.
164      *
165      * This function call must use less than 30000 gas.
166      */
167     function supportsInterface(bytes4 interfaceId) external view returns (bool);
168 
169     // =============================================================
170     //                            IERC721
171     // =============================================================
172 
173     /**
174      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
175      */
176     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
177 
178     /**
179      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
180      */
181     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
182 
183     /**
184      * @dev Emitted when `owner` enables or disables
185      * (`approved`) `operator` to manage all of its assets.
186      */
187     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
188 
189     /**
190      * @dev Returns the number of tokens in `owner`'s account.
191      */
192     function balanceOf(address owner) external view returns (uint256 balance);
193 
194     /**
195      * @dev Returns the owner of the `tokenId` token.
196      *
197      * Requirements:
198      *
199      * - `tokenId` must exist.
200      */
201     function ownerOf(uint256 tokenId) external view returns (address owner);
202 
203     /**
204      * @dev Safely transfers `tokenId` token from `from` to `to`,
205      * checking first that contract recipients are aware of the ERC721 protocol
206      * to prevent tokens from being forever locked.
207      *
208      * Requirements:
209      *
210      * - `from` cannot be the zero address.
211      * - `to` cannot be the zero address.
212      * - `tokenId` token must exist and be owned by `from`.
213      * - If the caller is not `from`, it must be have been allowed to move
214      * this token by either {approve} or {setApprovalForAll}.
215      * - If `to` refers to a smart contract, it must implement
216      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
217      *
218      * Emits a {Transfer} event.
219      */
220     function safeTransferFrom(
221         address from,
222         address to,
223         uint256 tokenId,
224         bytes calldata data
225     ) external;
226 
227     /**
228      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
229      */
230     function safeTransferFrom(
231         address from,
232         address to,
233         uint256 tokenId
234     ) external;
235 
236     /**
237      * @dev Transfers `tokenId` from `from` to `to`.
238      *
239      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
240      * whenever possible.
241      *
242      * Requirements:
243      *
244      * - `from` cannot be the zero address.
245      * - `to` cannot be the zero address.
246      * - `tokenId` token must be owned by `from`.
247      * - If the caller is not `from`, it must be approved to move this token
248      * by either {approve} or {setApprovalForAll}.
249      *
250      * Emits a {Transfer} event.
251      */
252     function transferFrom(
253         address from,
254         address to,
255         uint256 tokenId
256     ) external;
257 
258     /**
259      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
260      * The approval is cleared when the token is transferred.
261      *
262      * Only a single account can be approved at a time, so approving the
263      * zero address clears previous approvals.
264      *
265      * Requirements:
266      *
267      * - The caller must own the token or be an approved operator.
268      * - `tokenId` must exist.
269      *
270      * Emits an {Approval} event.
271      */
272     function approve(address to, uint256 tokenId) external;
273 
274     /**
275      * @dev Approve or remove `operator` as an operator for the caller.
276      * Operators can call {transferFrom} or {safeTransferFrom}
277      * for any token owned by the caller.
278      *
279      * Requirements:
280      *
281      * - The `operator` cannot be the caller.
282      *
283      * Emits an {ApprovalForAll} event.
284      */
285     function setApprovalForAll(address operator, bool _approved) external;
286 
287     /**
288      * @dev Returns the account approved for `tokenId` token.
289      *
290      * Requirements:
291      *
292      * - `tokenId` must exist.
293      */
294     function getApproved(uint256 tokenId) external view returns (address operator);
295 
296     /**
297      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
298      *
299      * See {setApprovalForAll}.
300      */
301     function isApprovedForAll(address owner, address operator) external view returns (bool);
302 
303     // =============================================================
304     //                        IERC721Metadata
305     // =============================================================
306 
307     /**
308      * @dev Returns the token collection name.
309      */
310     function name() external view returns (string memory);
311 
312     /**
313      * @dev Returns the token collection symbol.
314      */
315     function symbol() external view returns (string memory);
316 
317     /**
318      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
319      */
320     function tokenURI(uint256 tokenId) external view returns (string memory);
321 
322     // =============================================================
323     //                           IERC2309
324     // =============================================================
325 
326     /**
327      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
328      * (inclusive) is transferred from `from` to `to`, as defined in the
329      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
330      *
331      * See {_mintERC2309} for more details.
332      */
333     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
334 }
335 
336 /**
337  * @dev Interface of ERC721 token receiver.
338  */
339 interface ERC721A__IERC721Receiver {
340     function onERC721Received(
341         address operator,
342         address from,
343         uint256 tokenId,
344         bytes calldata data
345     ) external returns (bytes4);
346 }
347 
348 /**
349  * @title ERC721A
350  *
351  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
352  * Non-Fungible Token Standard, including the Metadata extension.
353  * Optimized for lower gas during batch mints.
354  *
355  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
356  * starting from `_startTokenId()`.
357  *
358  * Assumptions:
359  *
360  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
361  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
362  */
363 contract ERC721A is IERC721A {
364     // Reference type for token approval.
365     struct TokenApprovalRef {
366         address value;
367     }
368 
369     // =============================================================
370     //                           CONSTANTS
371     // =============================================================
372 
373     // Mask of an entry in packed address data.
374     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
375 
376     // The bit position of `numberMinted` in packed address data.
377     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
378 
379     // The bit position of `numberBurned` in packed address data.
380     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
381 
382     // The bit position of `aux` in packed address data.
383     uint256 private constant _BITPOS_AUX = 192;
384 
385     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
386     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
387 
388     // The bit position of `startTimestamp` in packed ownership.
389     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
390 
391     // The bit mask of the `burned` bit in packed ownership.
392     uint256 private constant _BITMASK_BURNED = 1 << 224;
393 
394     // The bit position of the `nextInitialized` bit in packed ownership.
395     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
396 
397     // The bit mask of the `nextInitialized` bit in packed ownership.
398     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
399 
400     // The bit position of `extraData` in packed ownership.
401     uint256 private constant _BITPOS_EXTRA_DATA = 232;
402 
403     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
404     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
405 
406     // The mask of the lower 160 bits for addresses.
407     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
408 
409     // The maximum `quantity` that can be minted with {_mintERC2309}.
410     // This limit is to prevent overflows on the address data entries.
411     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
412     // is required to cause an overflow, which is unrealistic.
413     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
414 
415     // The `Transfer` event signature is given by:
416     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
417     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
418         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
419 
420     // =============================================================
421     //                            STORAGE
422     // =============================================================
423 
424     // The next token ID to be minted.
425     uint256 private _currentIndex;
426 
427     // The number of tokens burned.
428     uint256 private _burnCounter;
429 
430     // Token name
431     string private _name;
432 
433     // Token symbol
434     string private _symbol;
435 
436     // Mapping from token ID to ownership details
437     // An empty struct value does not necessarily mean the token is unowned.
438     // See {_packedOwnershipOf} implementation for details.
439     //
440     // Bits Layout:
441     // - [0..159]   `addr`
442     // - [160..223] `startTimestamp`
443     // - [224]      `burned`
444     // - [225]      `nextInitialized`
445     // - [232..255] `extraData`
446     mapping(uint256 => uint256) private _packedOwnerships;
447 
448     // Mapping owner address to address data.
449     //
450     // Bits Layout:
451     // - [0..63]    `balance`
452     // - [64..127]  `numberMinted`
453     // - [128..191] `numberBurned`
454     // - [192..255] `aux`
455     mapping(address => uint256) private _packedAddressData;
456 
457     // Mapping from token ID to approved address.
458     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
459 
460     // Mapping from owner to operator approvals
461     mapping(address => mapping(address => bool)) private _operatorApprovals;
462 
463     // =============================================================
464     //                          CONSTRUCTOR
465     // =============================================================
466 
467     constructor(string memory name_, string memory symbol_) {
468         _name = name_;
469         _symbol = symbol_;
470         _currentIndex = _startTokenId();
471     }
472 
473     // =============================================================
474     //                   TOKEN COUNTING OPERATIONS
475     // =============================================================
476 
477     /**
478      * @dev Returns the starting token ID.
479      * To change the starting token ID, please override this function.
480      */
481     function _startTokenId() internal view virtual returns (uint256) {
482         return 0;
483     }
484 
485     /**
486      * @dev Returns the next token ID to be minted.
487      */
488     function _nextTokenId() internal view virtual returns (uint256) {
489         return _currentIndex;
490     }
491 
492     /**
493      * @dev Returns the total number of tokens in existence.
494      * Burned tokens will reduce the count.
495      * To get the total number of tokens minted, please see {_totalMinted}.
496      */
497     function totalSupply() public view virtual override returns (uint256) {
498         // Counter underflow is impossible as _burnCounter cannot be incremented
499         // more than `_currentIndex - _startTokenId()` times.
500         unchecked {
501             return _currentIndex - _burnCounter - _startTokenId();
502         }
503     }
504 
505     /**
506      * @dev Returns the total amount of tokens minted in the contract.
507      */
508     function _totalMinted() internal view virtual returns (uint256) {
509         // Counter underflow is impossible as `_currentIndex` does not decrement,
510         // and it is initialized to `_startTokenId()`.
511         unchecked {
512             return _currentIndex - _startTokenId();
513         }
514     }
515 
516     /**
517      * @dev Returns the total number of tokens burned.
518      */
519     function _totalBurned() internal view virtual returns (uint256) {
520         return _burnCounter;
521     }
522 
523     // =============================================================
524     //                    ADDRESS DATA OPERATIONS
525     // =============================================================
526 
527     /**
528      * @dev Returns the number of tokens in `owner`'s account.
529      */
530     function balanceOf(address owner) public view virtual override returns (uint256) {
531         if (owner == address(0)) revert BalanceQueryForZeroAddress();
532         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
533     }
534 
535     /**
536      * Returns the number of tokens minted by `owner`.
537      */
538     function _numberMinted(address owner) internal view returns (uint256) {
539         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
540     }
541 
542     /**
543      * Returns the number of tokens burned by or on behalf of `owner`.
544      */
545     function _numberBurned(address owner) internal view returns (uint256) {
546         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
547     }
548 
549     /**
550      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
551      */
552     function _getAux(address owner) internal view returns (uint64) {
553         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
554     }
555 
556     /**
557      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
558      * If there are multiple variables, please pack them into a uint64.
559      */
560     function _setAux(address owner, uint64 aux) internal virtual {
561         uint256 packed = _packedAddressData[owner];
562         uint256 auxCasted;
563         // Cast `aux` with assembly to avoid redundant masking.
564         assembly {
565             auxCasted := aux
566         }
567         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
568         _packedAddressData[owner] = packed;
569     }
570 
571     // =============================================================
572     //                            IERC165
573     // =============================================================
574 
575     /**
576      * @dev Returns true if this contract implements the interface defined by
577      * `interfaceId`. See the corresponding
578      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
579      * to learn more about how these ids are created.
580      *
581      * This function call must use less than 30000 gas.
582      */
583     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
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
615     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
616         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
617 
618         string memory baseURI = _baseURI();
619         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
620     }
621 
622     /**
623      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
624      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
625      * by default, it can be overridden in child contracts.
626      */
627     function _baseURI() internal view virtual returns (string memory) {
628         return '';
629     }
630 
631     // =============================================================
632     //                     OWNERSHIPS OPERATIONS
633     // =============================================================
634 
635     /**
636      * @dev Returns the owner of the `tokenId` token.
637      *
638      * Requirements:
639      *
640      * - `tokenId` must exist.
641      */
642     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
643         return address(uint160(_packedOwnershipOf(tokenId)));
644     }
645 
646     /**
647      * @dev Gas spent here starts off proportional to the maximum mint batch size.
648      * It gradually moves to O(1) as tokens get transferred around over time.
649      */
650     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
651         return _unpackedOwnership(_packedOwnershipOf(tokenId));
652     }
653 
654     /**
655      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
656      */
657     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
658         return _unpackedOwnership(_packedOwnerships[index]);
659     }
660 
661     /**
662      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
663      */
664     function _initializeOwnershipAt(uint256 index) internal virtual {
665         if (_packedOwnerships[index] == 0) {
666             _packedOwnerships[index] = _packedOwnershipOf(index);
667         }
668     }
669 
670     /**
671      * Returns the packed ownership data of `tokenId`.
672      */
673     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
674         uint256 curr = tokenId;
675 
676         unchecked {
677             if (_startTokenId() <= curr)
678                 if (curr < _currentIndex) {
679                     uint256 packed = _packedOwnerships[curr];
680                     // If not burned.
681                     if (packed & _BITMASK_BURNED == 0) {
682                         // Invariant:
683                         // There will always be an initialized ownership slot
684                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
685                         // before an unintialized ownership slot
686                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
687                         // Hence, `curr` will not underflow.
688                         //
689                         // We can directly compare the packed value.
690                         // If the address is zero, packed will be zero.
691                         while (packed == 0) {
692                             packed = _packedOwnerships[--curr];
693                         }
694                         return packed;
695                     }
696                 }
697         }
698         revert OwnerQueryForNonexistentToken();
699     }
700 
701     /**
702      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
703      */
704     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
705         ownership.addr = address(uint160(packed));
706         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
707         ownership.burned = packed & _BITMASK_BURNED != 0;
708         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
709     }
710 
711     /**
712      * @dev Packs ownership data into a single uint256.
713      */
714     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
715         assembly {
716             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
717             owner := and(owner, _BITMASK_ADDRESS)
718             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
719             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
720         }
721     }
722 
723     /**
724      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
725      */
726     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
727         // For branchless setting of the `nextInitialized` flag.
728         assembly {
729             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
730             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
731         }
732     }
733 
734     // =============================================================
735     //                      APPROVAL OPERATIONS
736     // =============================================================
737 
738     /**
739      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
740      * The approval is cleared when the token is transferred.
741      *
742      * Only a single account can be approved at a time, so approving the
743      * zero address clears previous approvals.
744      *
745      * Requirements:
746      *
747      * - The caller must own the token or be an approved operator.
748      * - `tokenId` must exist.
749      *
750      * Emits an {Approval} event.
751      */
752     function approve(address to, uint256 tokenId) public virtual override {
753         address owner = ownerOf(tokenId);
754 
755         if (_msgSenderERC721A() != owner)
756             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
757                 revert ApprovalCallerNotOwnerNorApproved();
758             }
759 
760         _tokenApprovals[tokenId].value = to;
761         emit Approval(owner, to, tokenId);
762     }
763 
764     /**
765      * @dev Returns the account approved for `tokenId` token.
766      *
767      * Requirements:
768      *
769      * - `tokenId` must exist.
770      */
771     function getApproved(uint256 tokenId) public view virtual override returns (address) {
772         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
773 
774         return _tokenApprovals[tokenId].value;
775     }
776 
777     /**
778      * @dev Approve or remove `operator` as an operator for the caller.
779      * Operators can call {transferFrom} or {safeTransferFrom}
780      * for any token owned by the caller.
781      *
782      * Requirements:
783      *
784      * - The `operator` cannot be the caller.
785      *
786      * Emits an {ApprovalForAll} event.
787      */
788     function setApprovalForAll(address operator, bool approved) public virtual override {
789         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
790 
791         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
792         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
793     }
794 
795     /**
796      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
797      *
798      * See {setApprovalForAll}.
799      */
800     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
801         return _operatorApprovals[owner][operator];
802     }
803 
804     /**
805      * @dev Returns whether `tokenId` exists.
806      *
807      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
808      *
809      * Tokens start existing when they are minted. See {_mint}.
810      */
811     function _exists(uint256 tokenId) internal view virtual returns (bool) {
812         return
813             _startTokenId() <= tokenId &&
814             tokenId < _currentIndex && // If within bounds,
815             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
816     }
817 
818     /**
819      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
820      */
821     function _isSenderApprovedOrOwner(
822         address approvedAddress,
823         address owner,
824         address msgSender
825     ) private pure returns (bool result) {
826         assembly {
827             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
828             owner := and(owner, _BITMASK_ADDRESS)
829             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
830             msgSender := and(msgSender, _BITMASK_ADDRESS)
831             // `msgSender == owner || msgSender == approvedAddress`.
832             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
833         }
834     }
835 
836     /**
837      * @dev Returns the storage slot and value for the approved address of `tokenId`.
838      */
839     function _getApprovedSlotAndAddress(uint256 tokenId)
840         private
841         view
842         returns (uint256 approvedAddressSlot, address approvedAddress)
843     {
844         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
845         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
846         assembly {
847             approvedAddressSlot := tokenApproval.slot
848             approvedAddress := sload(approvedAddressSlot)
849         }
850     }
851 
852     // =============================================================
853     //                      TRANSFER OPERATIONS
854     // =============================================================
855 
856     /**
857      * @dev Transfers `tokenId` from `from` to `to`.
858      *
859      * Requirements:
860      *
861      * - `from` cannot be the zero address.
862      * - `to` cannot be the zero address.
863      * - `tokenId` token must be owned by `from`.
864      * - If the caller is not `from`, it must be approved to move this token
865      * by either {approve} or {setApprovalForAll}.
866      *
867      * Emits a {Transfer} event.
868      */
869     function transferFrom(
870         address from,
871         address to,
872         uint256 tokenId
873     ) public virtual override {
874         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
875 
876         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
877 
878         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
879 
880         // The nested ifs save around 20+ gas over a compound boolean condition.
881         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
882             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
883 
884         if (to == address(0)) revert TransferToZeroAddress();
885 
886         _beforeTokenTransfers(from, to, tokenId, 1);
887 
888         // Clear approvals from the previous owner.
889         assembly {
890             if approvedAddress {
891                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
892                 sstore(approvedAddressSlot, 0)
893             }
894         }
895 
896         // Underflow of the sender's balance is impossible because we check for
897         // ownership above and the recipient's balance can't realistically overflow.
898         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
899         unchecked {
900             // We can directly increment and decrement the balances.
901             --_packedAddressData[from]; // Updates: `balance -= 1`.
902             ++_packedAddressData[to]; // Updates: `balance += 1`.
903 
904             // Updates:
905             // - `address` to the next owner.
906             // - `startTimestamp` to the timestamp of transfering.
907             // - `burned` to `false`.
908             // - `nextInitialized` to `true`.
909             _packedOwnerships[tokenId] = _packOwnershipData(
910                 to,
911                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
912             );
913 
914             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
915             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
916                 uint256 nextTokenId = tokenId + 1;
917                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
918                 if (_packedOwnerships[nextTokenId] == 0) {
919                     // If the next slot is within bounds.
920                     if (nextTokenId != _currentIndex) {
921                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
922                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
923                     }
924                 }
925             }
926         }
927 
928         emit Transfer(from, to, tokenId);
929         _afterTokenTransfers(from, to, tokenId, 1);
930     }
931 
932     /**
933      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
934      */
935     function safeTransferFrom(
936         address from,
937         address to,
938         uint256 tokenId
939     ) public virtual override {
940         safeTransferFrom(from, to, tokenId, '');
941     }
942 
943     /**
944      * @dev Safely transfers `tokenId` token from `from` to `to`.
945      *
946      * Requirements:
947      *
948      * - `from` cannot be the zero address.
949      * - `to` cannot be the zero address.
950      * - `tokenId` token must exist and be owned by `from`.
951      * - If the caller is not `from`, it must be approved to move this token
952      * by either {approve} or {setApprovalForAll}.
953      * - If `to` refers to a smart contract, it must implement
954      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
955      *
956      * Emits a {Transfer} event.
957      */
958     function safeTransferFrom(
959         address from,
960         address to,
961         uint256 tokenId,
962         bytes memory _data
963     ) public virtual override {
964         transferFrom(from, to, tokenId);
965         if (to.code.length != 0)
966             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
967                 revert TransferToNonERC721ReceiverImplementer();
968             }
969     }
970 
971     /**
972      * @dev Hook that is called before a set of serially-ordered token IDs
973      * are about to be transferred. This includes minting.
974      * And also called before burning one token.
975      *
976      * `startTokenId` - the first token ID to be transferred.
977      * `quantity` - the amount to be transferred.
978      *
979      * Calling conditions:
980      *
981      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
982      * transferred to `to`.
983      * - When `from` is zero, `tokenId` will be minted for `to`.
984      * - When `to` is zero, `tokenId` will be burned by `from`.
985      * - `from` and `to` are never both zero.
986      */
987     function _beforeTokenTransfers(
988         address from,
989         address to,
990         uint256 startTokenId,
991         uint256 quantity
992     ) internal virtual {}
993 
994     /**
995      * @dev Hook that is called after a set of serially-ordered token IDs
996      * have been transferred. This includes minting.
997      * And also called after one token has been burned.
998      *
999      * `startTokenId` - the first token ID to be transferred.
1000      * `quantity` - the amount to be transferred.
1001      *
1002      * Calling conditions:
1003      *
1004      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1005      * transferred to `to`.
1006      * - When `from` is zero, `tokenId` has been minted for `to`.
1007      * - When `to` is zero, `tokenId` has been burned by `from`.
1008      * - `from` and `to` are never both zero.
1009      */
1010     function _afterTokenTransfers(
1011         address from,
1012         address to,
1013         uint256 startTokenId,
1014         uint256 quantity
1015     ) internal virtual {}
1016 
1017     /**
1018      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1019      *
1020      * `from` - Previous owner of the given token ID.
1021      * `to` - Target address that will receive the token.
1022      * `tokenId` - Token ID to be transferred.
1023      * `_data` - Optional data to send along with the call.
1024      *
1025      * Returns whether the call correctly returned the expected magic value.
1026      */
1027     function _checkContractOnERC721Received(
1028         address from,
1029         address to,
1030         uint256 tokenId,
1031         bytes memory _data
1032     ) private returns (bool) {
1033         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1034             bytes4 retval
1035         ) {
1036             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1037         } catch (bytes memory reason) {
1038             if (reason.length == 0) {
1039                 revert TransferToNonERC721ReceiverImplementer();
1040             } else {
1041                 assembly {
1042                     revert(add(32, reason), mload(reason))
1043                 }
1044             }
1045         }
1046     }
1047 
1048     // =============================================================
1049     //                        MINT OPERATIONS
1050     // =============================================================
1051 
1052     /**
1053      * @dev Mints `quantity` tokens and transfers them to `to`.
1054      *
1055      * Requirements:
1056      *
1057      * - `to` cannot be the zero address.
1058      * - `quantity` must be greater than 0.
1059      *
1060      * Emits a {Transfer} event for each mint.
1061      */
1062     function _mint(address to, uint256 quantity) internal virtual {
1063         uint256 startTokenId = _currentIndex;
1064         if (quantity == 0) revert MintZeroQuantity();
1065 
1066         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1067 
1068         // Overflows are incredibly unrealistic.
1069         // `balance` and `numberMinted` have a maximum limit of 2**64.
1070         // `tokenId` has a maximum limit of 2**256.
1071         unchecked {
1072             // Updates:
1073             // - `balance += quantity`.
1074             // - `numberMinted += quantity`.
1075             //
1076             // We can directly add to the `balance` and `numberMinted`.
1077             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1078 
1079             // Updates:
1080             // - `address` to the owner.
1081             // - `startTimestamp` to the timestamp of minting.
1082             // - `burned` to `false`.
1083             // - `nextInitialized` to `quantity == 1`.
1084             _packedOwnerships[startTokenId] = _packOwnershipData(
1085                 to,
1086                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1087             );
1088 
1089             uint256 toMasked;
1090             uint256 end = startTokenId + quantity;
1091 
1092             // Use assembly to loop and emit the `Transfer` event for gas savings.
1093             assembly {
1094                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1095                 toMasked := and(to, _BITMASK_ADDRESS)
1096                 // Emit the `Transfer` event.
1097                 log4(
1098                     0, // Start of data (0, since no data).
1099                     0, // End of data (0, since no data).
1100                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1101                     0, // `address(0)`.
1102                     toMasked, // `to`.
1103                     startTokenId // `tokenId`.
1104                 )
1105 
1106                 for {
1107                     let tokenId := add(startTokenId, 1)
1108                 } iszero(eq(tokenId, end)) {
1109                     tokenId := add(tokenId, 1)
1110                 } {
1111                     // Emit the `Transfer` event. Similar to above.
1112                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1113                 }
1114             }
1115             if (toMasked == 0) revert MintToZeroAddress();
1116 
1117             _currentIndex = end;
1118         }
1119         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1120     }
1121 
1122     /**
1123      * @dev Mints `quantity` tokens and transfers them to `to`.
1124      *
1125      * This function is intended for efficient minting only during contract creation.
1126      *
1127      * It emits only one {ConsecutiveTransfer} as defined in
1128      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1129      * instead of a sequence of {Transfer} event(s).
1130      *
1131      * Calling this function outside of contract creation WILL make your contract
1132      * non-compliant with the ERC721 standard.
1133      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1134      * {ConsecutiveTransfer} event is only permissible during contract creation.
1135      *
1136      * Requirements:
1137      *
1138      * - `to` cannot be the zero address.
1139      * - `quantity` must be greater than 0.
1140      *
1141      * Emits a {ConsecutiveTransfer} event.
1142      */
1143     function _mintERC2309(address to, uint256 quantity) internal virtual {
1144         uint256 startTokenId = _currentIndex;
1145         if (to == address(0)) revert MintToZeroAddress();
1146         if (quantity == 0) revert MintZeroQuantity();
1147         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1148 
1149         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1150 
1151         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1152         unchecked {
1153             // Updates:
1154             // - `balance += quantity`.
1155             // - `numberMinted += quantity`.
1156             //
1157             // We can directly add to the `balance` and `numberMinted`.
1158             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1159 
1160             // Updates:
1161             // - `address` to the owner.
1162             // - `startTimestamp` to the timestamp of minting.
1163             // - `burned` to `false`.
1164             // - `nextInitialized` to `quantity == 1`.
1165             _packedOwnerships[startTokenId] = _packOwnershipData(
1166                 to,
1167                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1168             );
1169 
1170             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1171 
1172             _currentIndex = startTokenId + quantity;
1173         }
1174         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1175     }
1176 
1177     /**
1178      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1179      *
1180      * Requirements:
1181      *
1182      * - If `to` refers to a smart contract, it must implement
1183      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1184      * - `quantity` must be greater than 0.
1185      *
1186      * See {_mint}.
1187      *
1188      * Emits a {Transfer} event for each mint.
1189      */
1190     function _safeMint(
1191         address to,
1192         uint256 quantity,
1193         bytes memory _data
1194     ) internal virtual {
1195         _mint(to, quantity);
1196 
1197         unchecked {
1198             if (to.code.length != 0) {
1199                 uint256 end = _currentIndex;
1200                 uint256 index = end - quantity;
1201                 do {
1202                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1203                         revert TransferToNonERC721ReceiverImplementer();
1204                     }
1205                 } while (index < end);
1206                 // Reentrancy protection.
1207                 if (_currentIndex != end) revert();
1208             }
1209         }
1210     }
1211 
1212     /**
1213      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1214      */
1215     function _safeMint(address to, uint256 quantity) internal virtual {
1216         _safeMint(to, quantity, '');
1217     }
1218 
1219     // =============================================================
1220     //                        BURN OPERATIONS
1221     // =============================================================
1222 
1223     /**
1224      * @dev Equivalent to `_burn(tokenId, false)`.
1225      */
1226     function _burn(uint256 tokenId) internal virtual {
1227         _burn(tokenId, false);
1228     }
1229 
1230     /**
1231      * @dev Destroys `tokenId`.
1232      * The approval is cleared when the token is burned.
1233      *
1234      * Requirements:
1235      *
1236      * - `tokenId` must exist.
1237      *
1238      * Emits a {Transfer} event.
1239      */
1240     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1241         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1242 
1243         address from = address(uint160(prevOwnershipPacked));
1244 
1245         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1246 
1247         if (approvalCheck) {
1248             // The nested ifs save around 20+ gas over a compound boolean condition.
1249             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1250                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1251         }
1252 
1253         _beforeTokenTransfers(from, address(0), tokenId, 1);
1254 
1255         // Clear approvals from the previous owner.
1256         assembly {
1257             if approvedAddress {
1258                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1259                 sstore(approvedAddressSlot, 0)
1260             }
1261         }
1262 
1263         // Underflow of the sender's balance is impossible because we check for
1264         // ownership above and the recipient's balance can't realistically overflow.
1265         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1266         unchecked {
1267             // Updates:
1268             // - `balance -= 1`.
1269             // - `numberBurned += 1`.
1270             //
1271             // We can directly decrement the balance, and increment the number burned.
1272             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1273             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1274 
1275             // Updates:
1276             // - `address` to the last owner.
1277             // - `startTimestamp` to the timestamp of burning.
1278             // - `burned` to `true`.
1279             // - `nextInitialized` to `true`.
1280             _packedOwnerships[tokenId] = _packOwnershipData(
1281                 from,
1282                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1283             );
1284 
1285             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1286             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1287                 uint256 nextTokenId = tokenId + 1;
1288                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1289                 if (_packedOwnerships[nextTokenId] == 0) {
1290                     // If the next slot is within bounds.
1291                     if (nextTokenId != _currentIndex) {
1292                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1293                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1294                     }
1295                 }
1296             }
1297         }
1298 
1299         emit Transfer(from, address(0), tokenId);
1300         _afterTokenTransfers(from, address(0), tokenId, 1);
1301 
1302         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1303         unchecked {
1304             _burnCounter++;
1305         }
1306     }
1307 
1308     // =============================================================
1309     //                     EXTRA DATA OPERATIONS
1310     // =============================================================
1311 
1312     /**
1313      * @dev Directly sets the extra data for the ownership data `index`.
1314      */
1315     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1316         uint256 packed = _packedOwnerships[index];
1317         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1318         uint256 extraDataCasted;
1319         // Cast `extraData` with assembly to avoid redundant masking.
1320         assembly {
1321             extraDataCasted := extraData
1322         }
1323         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1324         _packedOwnerships[index] = packed;
1325     }
1326 
1327     /**
1328      * @dev Called during each token transfer to set the 24bit `extraData` field.
1329      * Intended to be overridden by the cosumer contract.
1330      *
1331      * `previousExtraData` - the value of `extraData` before transfer.
1332      *
1333      * Calling conditions:
1334      *
1335      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1336      * transferred to `to`.
1337      * - When `from` is zero, `tokenId` will be minted for `to`.
1338      * - When `to` is zero, `tokenId` will be burned by `from`.
1339      * - `from` and `to` are never both zero.
1340      */
1341     function _extraData(
1342         address from,
1343         address to,
1344         uint24 previousExtraData
1345     ) internal view virtual returns (uint24) {}
1346 
1347     /**
1348      * @dev Returns the next extra data for the packed ownership data.
1349      * The returned result is shifted into position.
1350      */
1351     function _nextExtraData(
1352         address from,
1353         address to,
1354         uint256 prevOwnershipPacked
1355     ) private view returns (uint256) {
1356         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1357         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1358     }
1359 
1360     // =============================================================
1361     //                       OTHER OPERATIONS
1362     // =============================================================
1363 
1364     /**
1365      * @dev Returns the message sender (defaults to `msg.sender`).
1366      *
1367      * If you are writing GSN compatible contracts, you need to override this function.
1368      */
1369     function _msgSenderERC721A() internal view virtual returns (address) {
1370         return msg.sender;
1371     }
1372 
1373     /**
1374      * @dev Converts a uint256 to its ASCII string decimal representation.
1375      */
1376     function _toString(uint256 value) internal pure virtual returns (string memory ptr) {
1377         assembly {
1378             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1379             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1380             // We will need 1 32-byte word to store the length,
1381             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1382             ptr := add(mload(0x40), 128)
1383             // Update the free memory pointer to allocate.
1384             mstore(0x40, ptr)
1385 
1386             // Cache the end of the memory to calculate the length later.
1387             let end := ptr
1388 
1389             // We write the string from the rightmost digit to the leftmost digit.
1390             // The following is essentially a do-while loop that also handles the zero case.
1391             // Costs a bit more than early returning for the zero case,
1392             // but cheaper in terms of deployment and overall runtime costs.
1393             for {
1394                 // Initialize and perform the first pass without check.
1395                 let temp := value
1396                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1397                 ptr := sub(ptr, 1)
1398                 // Write the character to the pointer.
1399                 // The ASCII index of the '0' character is 48.
1400                 mstore8(ptr, add(48, mod(temp, 10)))
1401                 temp := div(temp, 10)
1402             } temp {
1403                 // Keep dividing `temp` until zero.
1404                 temp := div(temp, 10)
1405             } {
1406                 // Body of the for loop.
1407                 ptr := sub(ptr, 1)
1408                 mstore8(ptr, add(48, mod(temp, 10)))
1409             }
1410 
1411             let length := sub(end, ptr)
1412             // Move the pointer 32 bytes leftwards to make room for the length.
1413             ptr := sub(ptr, 32)
1414             // Store the length.
1415             mstore(ptr, length)
1416         }
1417     }
1418 }
1419 
1420 contract Palestinian is ERC721A, Ownable  {
1421     
1422     uint256 public maxSupply = 3333;
1423 
1424     uint256 public maxFreeSupply;
1425 
1426     uint256 public cost = 0.0005 ether;
1427 
1428     uint256 public freeAmount;
1429 
1430     string  private uri = "";
1431     
1432     function publicMint(uint32 amount) public payable {
1433         require(totalSupply() + amount <= maxSupply, "sold_out");
1434         _mint(amount);
1435     }
1436 
1437     function _mint(uint32 amount) internal  {
1438         bool isFree = msg.value == 0;
1439         if (isFree) {
1440             require(amount <= freeAmount);
1441             require(totalSupply() + amount <= maxFreeSupply);
1442             require(msg.sender == owner() || balanceOf(msg.sender) < freeAmount);
1443             _safeMint(msg.sender, amount);
1444         } else {
1445             require(msg.value >= cost * amount);
1446             _safeMint(msg.sender, amount);
1447         }
1448     }
1449 
1450     constructor() ERC721A("Palestinian", "Palestinian") {
1451         maxFreeSupply = 2333;
1452         freeAmount = 8;
1453     }
1454 
1455     function setFree(uint256 freeamount, uint256 mf) onlyOwner public  {
1456         freeAmount = freeamount;
1457         maxFreeSupply = mf;
1458     }
1459 
1460     function setUri(string memory i) onlyOwner public  {
1461         uri = i;
1462     }
1463 
1464     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1465         return string(abi.encodePacked(uri, _toString(tokenId), ".json"));
1466     }
1467 
1468     function withdraw() external onlyOwner {
1469         payable(msg.sender).transfer(address(this).balance);
1470     }
1471 }