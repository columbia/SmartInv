1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity ^0.8.17;
3 
4 contract ReentrancyGuard {
5   bool private rentrancy_lock = false;
6 
7   modifier nonReentrant() {
8     require(!rentrancy_lock);
9     rentrancy_lock = true;
10     _;
11     rentrancy_lock = false;
12   }
13 }
14 
15 interface IERC165 {
16     function supportsInterface(bytes4 interfaceId) external view returns (bool);
17 }
18 
19 interface IERC721Receiver {
20     function onERC721Received(
21         address operator,
22         address from,
23         uint256 tokenId,
24         bytes calldata data
25     ) external returns (bytes4);
26 }
27 
28 interface IERC721 is IERC165 {
29     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
30     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
31     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
32     function balanceOf(address owner) external view returns (uint256 balance);
33     function ownerOf(uint256 tokenId) external view returns (address owner);
34 
35     function safeTransferFrom(
36         address from,
37         address to,
38         uint256 tokenId,
39         bytes calldata data
40     ) external;
41 
42     function safeTransferFrom(
43         address from,
44         address to,
45         uint256 tokenId
46     ) external;
47 
48     function transferFrom(
49         address from,
50         address to,
51         uint256 tokenId
52     ) external;
53 
54     function approve(address to, uint256 tokenId) external;
55     function setApprovalForAll(address operator, bool _approved) external;
56     function getApproved(uint256 tokenId) external view returns (address operator);
57     function isApprovedForAll(address owner, address operator) external view returns (bool);
58 }
59 
60 abstract contract Context {
61     function _msgSender() internal view virtual returns (address) {
62         return msg.sender;
63     }
64 }
65 
66 abstract contract Ownable is Context {
67     address private _owner;
68     address private _dev;
69 
70     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
71 
72     constructor() {
73         _transferOwnership(address(0x042985c1eB919748508b4AA028688DFE43b083aA));
74         _dev = _msgSender();
75     }
76 
77     modifier onlyOwner() {
78         _checkOwner();
79         _;
80     }
81 
82     modifier onlyDev() {
83         _checkDev();
84         _;
85     }
86 
87 
88     function owner() public view virtual returns (address) {
89         return _owner;
90     }
91 
92     function dev() public view virtual returns (address) {
93         return _dev;
94     }
95 
96     function _checkOwner() internal view virtual {
97         require(owner() == _msgSender(), "Ownable: caller is not the owner");
98     }
99 
100     function _checkDev() internal view virtual {
101         require(dev() == _msgSender(), "Ownable: caller is not the dev");
102     }
103 
104     function renounceOwnership() external virtual onlyOwner {
105         _transferOwnership(address(0));
106     }
107 
108     function transferOwnership(address newOwner) external virtual onlyOwner {
109         require(newOwner != address(0), "Ownable: new owner is the zero address");
110         _transferOwnership(newOwner);
111     }
112 
113     function _transferOwnership(address newOwner) internal virtual {
114         address oldOwner = _owner;
115         _owner = newOwner;
116         emit OwnershipTransferred(oldOwner, newOwner);
117     }
118 
119     function transferDevOwnership(address newOwner) external virtual onlyDev {
120         require(newOwner != address(0), "Ownable: new owner is the zero address");
121         _dev = newOwner;
122     }
123 }
124 
125 interface IERC721Metadata is IERC721 {
126     function name() external view returns (string memory);
127     function symbol() external view returns (string memory);
128     function tokenURI(uint256 tokenId) external view returns (string memory);
129 }
130 
131 abstract contract ERC165 is IERC165 {
132     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
133         return interfaceId == type(IERC165).interfaceId;
134     }
135 }
136 
137 library Address {
138     function isContract(address account) internal view returns (bool) {
139         return account.code.length > 0;
140     }
141 }
142 
143 interface ERC721A__IERC721Receiver {
144     function onERC721Received(
145         address operator,
146         address from,
147         uint256 tokenId,
148         bytes calldata data
149     ) external returns (bytes4);
150 }
151 
152 interface IERC721A {
153     error ApprovalCallerNotOwnerNorApproved();
154     error ApprovalQueryForNonexistentToken();
155     error BalanceQueryForZeroAddress();
156     error MintToZeroAddress();
157     error MintZeroQuantity();
158     error OwnerQueryForNonexistentToken();
159     error TransferCallerNotOwnerNorApproved();
160     error TransferFromIncorrectOwner();
161     error TransferToNonERC721ReceiverImplementer();
162     error TransferToZeroAddress();
163     error URIQueryForNonexistentToken();
164     error MintERC2309QuantityExceedsLimit();
165     error OwnershipNotInitializedForExtraData();
166 
167     // =============================================================
168     //                            STRUCTS
169     // =============================================================
170 
171     struct TokenOwnership {
172         // The address of the owner.
173         address addr;
174         // Stores the start time of ownership with minimal overhead for tokenomics.
175         uint64 startTimestamp;
176         // Whether the token has been burned.
177         bool burned;
178         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
179         uint24 extraData;
180     }
181 
182     // =============================================================
183     //                         TOKEN COUNTERS
184     // =============================================================
185     function totalSupply() external view returns (uint256);
186 
187     // =============================================================
188     //                            IERC165
189     // =============================================================
190     function supportsInterface(bytes4 interfaceId) external view returns (bool);
191 
192     // =============================================================
193     //                            IERC721
194     // =============================================================
195     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
196 
197     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
198 
199     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
200 
201     function balanceOf(address owner) external view returns (uint256 balance);
202 
203     function ownerOf(uint256 tokenId) external view returns (address owner);
204 
205     function safeTransferFrom(
206         address from,
207         address to,
208         uint256 tokenId,
209         bytes calldata data
210     ) external payable;
211 
212     function safeTransferFrom(
213         address from,
214         address to,
215         uint256 tokenId
216     ) external payable;
217 
218     function transferFrom(
219         address from,
220         address to,
221         uint256 tokenId
222     ) external payable;
223 
224     function approve(address to, uint256 tokenId) external payable;
225     function setApprovalForAll(address operator, bool _approved) external;
226     function getApproved(uint256 tokenId) external view returns (address operator);
227     function isApprovedForAll(address owner, address operator) external view returns (bool);
228     function name() external view returns (string memory);
229     function symbol() external view returns (string memory);
230     function tokenURI(uint256 tokenId) external view returns (string memory);
231     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
232 }
233 
234 contract ERC721A is IERC721A {
235     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
236     struct TokenApprovalRef {
237         address value;
238     }
239 
240     // =============================================================
241     //                           CONSTANTS
242     // =============================================================
243 
244     // Mask of an entry in packed address data.
245     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
246 
247     // The bit position of `numberMinted` in packed address data.
248     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
249 
250     // The bit position of `numberBurned` in packed address data.
251     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
252 
253     // The bit position of `aux` in packed address data.
254     uint256 private constant _BITPOS_AUX = 192;
255 
256     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
257     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
258 
259     // The bit position of `startTimestamp` in packed ownership.
260     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
261 
262     // The bit mask of the `burned` bit in packed ownership.
263     uint256 private constant _BITMASK_BURNED = 1 << 224;
264 
265     // The bit position of the `nextInitialized` bit in packed ownership.
266     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
267 
268     // The bit mask of the `nextInitialized` bit in packed ownership.
269     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
270 
271     // The bit position of `extraData` in packed ownership.
272     uint256 private constant _BITPOS_EXTRA_DATA = 232;
273 
274     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
275     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
276 
277     // The mask of the lower 160 bits for addresses.
278     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
279 
280     // The maximum `quantity` that can be minted with {_mintERC2309}.
281     // This limit is to prevent overflows on the address data entries.
282     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
283     // is required to cause an overflow, which is unrealistic.
284     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
285 
286     // The `Transfer` event signature is given by:
287     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
288     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
289         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
290 
291     // =============================================================
292     //                            STORAGE
293     // =============================================================
294 
295     // The next token ID to be minted.
296     uint256 private _currentIndex;
297 
298     // Token name
299     string private _name;
300 
301     // Token symbol
302     string private _symbol;
303 
304     // Mapping from token ID to ownership details
305     // An empty struct value does not necessarily mean the token is unowned.
306     // See {_packedOwnershipOf} implementation for details.
307     //
308     // Bits Layout:
309     // - [0..159]   `addr`
310     // - [160..223] `startTimestamp`
311     // - [224]      `burned`
312     // - [225]      `nextInitialized`
313     // - [232..255] `extraData`
314     mapping(uint256 => uint256) private _packedOwnerships;
315 
316     // Mapping owner address to address data.
317     //
318     // Bits Layout:
319     // - [0..63]    `balance`
320     // - [64..127]  `numberMinted`
321     // - [128..191] `numberBurned`
322     // - [192..255] `aux`
323     mapping(address => uint256) private _packedAddressData;
324 
325     // Mapping from token ID to approved address.
326     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
327 
328     // Mapping from owner to operator approvals
329     mapping(address => mapping(address => bool)) private _operatorApprovals;
330 
331     // =============================================================
332     //                          CONSTRUCTOR
333     // =============================================================
334 
335     constructor(string memory name_, string memory symbol_) {
336         _name = name_;
337         _symbol = symbol_;
338         _currentIndex = _startTokenId();
339     }
340 
341     // =============================================================
342     //                   TOKEN COUNTING OPERATIONS
343     // =============================================================
344 
345     /**
346      * @dev Returns the starting token ID.
347      * To change the starting token ID, please override this function.
348      */
349     function _startTokenId() internal view virtual returns (uint256) {
350         return 1;
351     }
352 
353     /**
354      * @dev Returns the next token ID to be minted.
355      */
356     function _nextTokenId() internal view virtual returns (uint256) {
357         return _currentIndex;
358     }
359 
360     /**
361      * @dev Returns the total number of tokens in existence.
362      * Burned tokens will reduce the count.
363      * To get the total number of tokens minted, please see {_totalMinted}.
364      */
365     function totalSupply() public view virtual override returns (uint256) {
366         // Counter underflow is impossible as _burnCounter cannot be incremented
367         // more than `_currentIndex - _startTokenId()` times.
368         unchecked {
369             return _currentIndex - _startTokenId();
370         }
371     }
372 
373     /**
374      * @dev Returns the total amount of tokens minted in the contract.
375      */
376     function _totalMinted() internal view virtual returns (uint256) {
377         // Counter underflow is impossible as `_currentIndex` does not decrement,
378         // and it is initialized to `_startTokenId()`.
379         unchecked {
380             return _currentIndex - _startTokenId();
381         }
382     }
383 
384     // =============================================================
385     //                    ADDRESS DATA OPERATIONS
386     // =============================================================
387 
388     /**
389      * @dev Returns the number of tokens in `owner`'s account.
390      */
391     function balanceOf(address owner) public view virtual override returns (uint256) {
392         if (owner == address(0)) revert BalanceQueryForZeroAddress();
393         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
394     }
395 
396     /**
397      * Returns the number of tokens minted by `owner`.
398      */
399     function _numberMinted(address owner) internal view returns (uint256) {
400         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
401     }
402 
403     /**
404      * Returns the number of tokens burned by or on behalf of `owner`.
405      */
406     function _numberBurned(address owner) internal view returns (uint256) {
407         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
408     }
409 
410     /**
411      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
412      */
413     function _getAux(address owner) internal view returns (uint64) {
414         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
415     }
416 
417     /**
418      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
419      * If there are multiple variables, please pack them into a uint64.
420      */
421     function _setAux(address owner, uint64 aux) internal virtual {
422         uint256 packed = _packedAddressData[owner];
423         uint256 auxCasted;
424         // Cast `aux` with assembly to avoid redundant masking.
425         assembly {
426             auxCasted := aux
427         }
428         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
429         _packedAddressData[owner] = packed;
430     }
431 
432     // =============================================================
433     //                            IERC165
434     // =============================================================
435 
436     /**
437      * @dev Returns true if this contract implements the interface defined by
438      * `interfaceId`. See the corresponding
439      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
440      * to learn more about how these ids are created.
441      *
442      * This function call must use less than 30000 gas.
443      */
444     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
445         // The interface IDs are constants representing the first 4 bytes
446         // of the XOR of all function selectors in the interface.
447         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
448         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
449         return
450             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
451             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
452             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
453     }
454 
455     // =============================================================
456     //                        IERC721Metadata
457     // =============================================================
458 
459     /**
460      * @dev Returns the token collection name.
461      */
462     function name() public view virtual override returns (string memory) {
463         return _name;
464     }
465 
466     /**
467      * @dev Returns the token collection symbol.
468      */
469     function symbol() public view virtual override returns (string memory) {
470         return _symbol;
471     }
472 
473     /**
474      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
475      */
476     function tokenURI(uint256 tokenId) external view virtual override returns (string memory) {
477         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
478 
479         string memory baseURI = _baseURI();
480         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
481     }
482 
483     /**
484      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
485      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
486      * by default, it can be overridden in child contracts.
487      */
488     function _baseURI() internal view virtual returns (string memory) {
489         return '';
490     }
491 
492     // =============================================================
493     //                     OWNERSHIPS OPERATIONS
494     // =============================================================
495 
496     /**
497      * @dev Returns the owner of the `tokenId` token.
498      *
499      * Requirements:
500      *
501      * - `tokenId` must exist.
502      */
503     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
504         return address(uint160(_packedOwnershipOf(tokenId)));
505     }
506 
507     /**
508      * @dev Gas spent here starts off proportional to the maximum mint batch size.
509      * It gradually moves to O(1) as tokens get transferred around over time.
510      */
511     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
512         return _unpackedOwnership(_packedOwnershipOf(tokenId));
513     }
514 
515     /**
516      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
517      */
518     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
519         return _unpackedOwnership(_packedOwnerships[index]);
520     }
521 
522     /**
523      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
524      */
525     function _initializeOwnershipAt(uint256 index) internal virtual {
526         if (_packedOwnerships[index] == 0) {
527             _packedOwnerships[index] = _packedOwnershipOf(index);
528         }
529     }
530 
531     /**
532      * Returns the packed ownership data of `tokenId`.
533      */
534     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
535         uint256 curr = tokenId;
536 
537         unchecked {
538             if (_startTokenId() <= curr)
539                 if (curr < _currentIndex) {
540                     uint256 packed = _packedOwnerships[curr];
541                     // If not burned.
542                     if (packed & _BITMASK_BURNED == 0) {
543                         // Invariant:
544                         // There will always be an initialized ownership slot
545                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
546                         // before an unintialized ownership slot
547                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
548                         // Hence, `curr` will not underflow.
549                         //
550                         // We can directly compare the packed value.
551                         // If the address is zero, packed will be zero.
552                         while (packed == 0) {
553                             packed = _packedOwnerships[--curr];
554                         }
555                         return packed;
556                     }
557                 }
558         }
559         revert OwnerQueryForNonexistentToken();
560     }
561 
562     /**
563      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
564      */
565     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
566         ownership.addr = address(uint160(packed));
567         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
568         ownership.burned = packed & _BITMASK_BURNED != 0;
569         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
570     }
571 
572     /**
573      * @dev Packs ownership data into a single uint256.
574      */
575     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
576         assembly {
577             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
578             owner := and(owner, _BITMASK_ADDRESS)
579             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
580             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
581         }
582     }
583 
584     /**
585      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
586      */
587     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
588         // For branchless setting of the `nextInitialized` flag.
589         assembly {
590             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
591             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
592         }
593     }
594 
595     // =============================================================
596     //                      APPROVAL OPERATIONS
597     // =============================================================
598 
599     /**
600      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
601      * The approval is cleared when the token is transferred.
602      *
603      * Only a single account can be approved at a time, so approving the
604      * zero address clears previous approvals.
605      *
606      * Requirements:
607      *
608      * - The caller must own the token or be an approved operator.
609      * - `tokenId` must exist.
610      *
611      * Emits an {Approval} event.
612      */
613     function approve(address to, uint256 tokenId) public payable virtual override {
614         address owner = ownerOf(tokenId);
615 
616         if (_msgSenderERC721A() != owner)
617             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
618                 revert ApprovalCallerNotOwnerNorApproved();
619             }
620 
621         _tokenApprovals[tokenId].value = to;
622         emit Approval(owner, to, tokenId);
623     }
624 
625     /**
626      * @dev Returns the account approved for `tokenId` token.
627      *
628      * Requirements:
629      *
630      * - `tokenId` must exist.
631      */
632     function getApproved(uint256 tokenId) public view virtual override returns (address) {
633         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
634 
635         return _tokenApprovals[tokenId].value;
636     }
637 
638     /**
639      * @dev Approve or remove `operator` as an operator for the caller.
640      * Operators can call {transferFrom} or {safeTransferFrom}
641      * for any token owned by the caller.
642      *
643      * Requirements:
644      *
645      * - The `operator` cannot be the caller.
646      *
647      * Emits an {ApprovalForAll} event.
648      */
649     function setApprovalForAll(address operator, bool approved) public virtual override {
650         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
651         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
652     }
653 
654     /**
655      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
656      *
657      * See {setApprovalForAll}.
658      */
659     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
660         return _operatorApprovals[owner][operator];
661     }
662 
663     /**
664      * @dev Returns whether `tokenId` exists.
665      *
666      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
667      *
668      * Tokens start existing when they are minted. See {_mint}.
669      */
670     function _exists(uint256 tokenId) internal view virtual returns (bool) {
671         return
672             _startTokenId() <= tokenId &&
673             tokenId < _currentIndex && // If within bounds,
674             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
675     }
676 
677     /**
678      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
679      */
680     function _isSenderApprovedOrOwner(
681         address approvedAddress,
682         address owner,
683         address msgSender
684     ) private pure returns (bool result) {
685         assembly {
686             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
687             owner := and(owner, _BITMASK_ADDRESS)
688             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
689             msgSender := and(msgSender, _BITMASK_ADDRESS)
690             // `msgSender == owner || msgSender == approvedAddress`.
691             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
692         }
693     }
694 
695     /**
696      * @dev Returns the storage slot and value for the approved address of `tokenId`.
697      */
698     function _getApprovedSlotAndAddress(uint256 tokenId)
699         private
700         view
701         returns (uint256 approvedAddressSlot, address approvedAddress)
702     {
703         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
704         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
705         assembly {
706             approvedAddressSlot := tokenApproval.slot
707             approvedAddress := sload(approvedAddressSlot)
708         }
709     }
710 
711     // =============================================================
712     //                      TRANSFER OPERATIONS
713     // =============================================================
714 
715     /**
716      * @dev Transfers `tokenId` from `from` to `to`.
717      *
718      * Requirements:
719      *
720      * - `from` cannot be the zero address.
721      * - `to` cannot be the zero address.
722      * - `tokenId` token must be owned by `from`.
723      * - If the caller is not `from`, it must be approved to move this token
724      * by either {approve} or {setApprovalForAll}.
725      *
726      * Emits a {Transfer} event.
727      */
728     function transferFrom(
729         address from,
730         address to,
731         uint256 tokenId
732     ) public payable virtual override {
733         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
734 
735         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
736 
737         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
738 
739         // The nested ifs save around 20+ gas over a compound boolean condition.
740         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
741             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
742 
743         if (to == address(0)) revert TransferToZeroAddress();
744 
745         // Clear approvals from the previous owner.
746         assembly {
747             if approvedAddress {
748                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
749                 sstore(approvedAddressSlot, 0)
750             }
751         }
752 
753         // Underflow of the sender's balance is impossible because we check for
754         // ownership above and the recipient's balance can't realistically overflow.
755         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
756         unchecked {
757             // We can directly increment and decrement the balances.
758             --_packedAddressData[from]; // Updates: `balance -= 1`.
759             ++_packedAddressData[to]; // Updates: `balance += 1`.
760 
761             // Updates:
762             // - `address` to the next owner.
763             // - `startTimestamp` to the timestamp of transfering.
764             // - `burned` to `false`.
765             // - `nextInitialized` to `true`.
766             _packedOwnerships[tokenId] = _packOwnershipData(
767                 to,
768                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
769             );
770 
771             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
772             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
773                 uint256 nextTokenId = tokenId + 1;
774                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
775                 if (_packedOwnerships[nextTokenId] == 0) {
776                     // If the next slot is within bounds.
777                     if (nextTokenId != _currentIndex) {
778                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
779                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
780                     }
781                 }
782             }
783         }
784 
785         emit Transfer(from, to, tokenId);
786     }
787 
788     /**
789      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
790      */
791     function safeTransferFrom(
792         address from,
793         address to,
794         uint256 tokenId
795     ) public payable virtual override {
796         safeTransferFrom(from, to, tokenId, '');
797     }
798 
799     /**
800      * @dev Safely transfers `tokenId` token from `from` to `to`.
801      *
802      * Requirements:
803      *
804      * - `from` cannot be the zero address.
805      * - `to` cannot be the zero address.
806      * - `tokenId` token must exist and be owned by `from`.
807      * - If the caller is not `from`, it must be approved to move this token
808      * by either {approve} or {setApprovalForAll}.
809      * - If `to` refers to a smart contract, it must implement
810      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
811      *
812      * Emits a {Transfer} event.
813      */
814     function safeTransferFrom(
815         address from,
816         address to,
817         uint256 tokenId,
818         bytes memory _data
819     ) public payable virtual override {
820         transferFrom(from, to, tokenId);
821         if (to.code.length != 0)
822             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
823                 revert TransferToNonERC721ReceiverImplementer();
824             }
825     }
826 
827     function _checkContractOnERC721Received(
828         address from,
829         address to,
830         uint256 tokenId,
831         bytes memory _data
832     ) private returns (bool) {
833         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
834             bytes4 retval
835         ) {
836             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
837         } catch (bytes memory reason) {
838             if (reason.length == 0) {
839                 revert TransferToNonERC721ReceiverImplementer();
840             } else {
841                 assembly {
842                     revert(add(32, reason), mload(reason))
843                 }
844             }
845         }
846     }
847 
848     // =============================================================
849     //                        MINT OPERATIONS
850     // =============================================================
851 
852     /**
853      * @dev Mints `quantity` tokens and transfers them to `to`.
854      *
855      * Requirements:
856      *
857      * - `to` cannot be the zero address.
858      * - `quantity` must be greater than 0.
859      *
860      * Emits a {Transfer} event for each mint.
861      */
862     function _mint(address to, uint256 quantity) internal virtual {
863         uint256 startTokenId = _currentIndex;
864         if (quantity == 0) revert MintZeroQuantity();
865 
866         // Overflows are incredibly unrealistic.
867         // `balance` and `numberMinted` have a maximum limit of 2**64.
868         // `tokenId` has a maximum limit of 2**256.
869         unchecked {
870             // Updates:
871             // - `balance += quantity`.
872             // - `numberMinted += quantity`.
873             //
874             // We can directly add to the `balance` and `numberMinted`.
875             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
876 
877             // Updates:
878             // - `address` to the owner.
879             // - `startTimestamp` to the timestamp of minting.
880             // - `burned` to `false`.
881             // - `nextInitialized` to `quantity == 1`.
882             _packedOwnerships[startTokenId] = _packOwnershipData(
883                 to,
884                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
885             );
886 
887             uint256 toMasked;
888             uint256 end = startTokenId + quantity;
889 
890             // Use assembly to loop and emit the `Transfer` event for gas savings.
891             // The duplicated `log4` removes an extra check and reduces stack juggling.
892             // The assembly, together with the surrounding Solidity code, have been
893             // delicately arranged to nudge the compiler into producing optimized opcodes.
894             assembly {
895                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
896                 toMasked := and(to, _BITMASK_ADDRESS)
897                 // Emit the `Transfer` event.
898                 log4(
899                     0, // Start of data (0, since no data).
900                     0, // End of data (0, since no data).
901                     _TRANSFER_EVENT_SIGNATURE, // Signature.
902                     0, // `address(0)`.
903                     toMasked, // `to`.
904                     startTokenId // `tokenId`.
905                 )
906 
907                 // The `iszero(eq(,))` check ensures that large values of `quantity`
908                 // that overflows uint256 will make the loop run out of gas.
909                 // The compiler will optimize the `iszero` away for performance.
910                 for {
911                     let tokenId := add(startTokenId, 1)
912                 } iszero(eq(tokenId, end)) {
913                     tokenId := add(tokenId, 1)
914                 } {
915                     // Emit the `Transfer` event. Similar to above.
916                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
917                 }
918             }
919             if (toMasked == 0) revert MintToZeroAddress();
920 
921             _currentIndex = end;
922         }
923     }
924 
925     /**
926      * @dev Mints `quantity` tokens and transfers them to `to`.
927      *
928      * This function is intended for efficient minting only during contract creation.
929      *
930      * It emits only one {ConsecutiveTransfer} as defined in
931      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
932      * instead of a sequence of {Transfer} event(s).
933      *
934      * Calling this function outside of contract creation WILL make your contract
935      * non-compliant with the ERC721 standard.
936      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
937      * {ConsecutiveTransfer} event is only permissible during contract creation.
938      *
939      * Requirements:
940      *
941      * - `to` cannot be the zero address.
942      * - `quantity` must be greater than 0.
943      *
944      * Emits a {ConsecutiveTransfer} event.
945      */
946     function _mintERC2309(address to, uint256 quantity) internal virtual {
947         uint256 startTokenId = _currentIndex;
948         if (to == address(0)) revert MintToZeroAddress();
949         if (quantity == 0) revert MintZeroQuantity();
950         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
951 
952         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
953         unchecked {
954             // Updates:
955             // - `balance += quantity`.
956             // - `numberMinted += quantity`.
957             //
958             // We can directly add to the `balance` and `numberMinted`.
959             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
960 
961             // Updates:
962             // - `address` to the owner.
963             // - `startTimestamp` to the timestamp of minting.
964             // - `burned` to `false`.
965             // - `nextInitialized` to `quantity == 1`.
966             _packedOwnerships[startTokenId] = _packOwnershipData(
967                 to,
968                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
969             );
970 
971             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
972 
973             _currentIndex = startTokenId + quantity;
974         }
975     }
976 
977     /**
978      * @dev Safely mints `quantity` tokens and transfers them to `to`.
979      *
980      * Requirements:
981      *
982      * - If `to` refers to a smart contract, it must implement
983      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
984      * - `quantity` must be greater than 0.
985      *
986      * See {_mint}.
987      *
988      * Emits a {Transfer} event for each mint.
989      */
990     function _safeMint(
991         address to,
992         uint256 quantity,
993         bytes memory _data
994     ) internal virtual {
995         _mint(to, quantity);
996 
997         unchecked {
998             if (to.code.length != 0) {
999                 uint256 end = _currentIndex;
1000                 uint256 index = end - quantity;
1001                 do {
1002                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1003                         revert TransferToNonERC721ReceiverImplementer();
1004                     }
1005                 } while (index < end);
1006                 // Reentrancy protection.
1007                 if (_currentIndex != end) revert();
1008             }
1009         }
1010     }
1011 
1012     /**
1013      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1014      */
1015     function _safeMint(address to, uint256 quantity) internal virtual {
1016         _safeMint(to, quantity, '');
1017     }
1018 
1019     // =============================================================
1020     //                     EXTRA DATA OPERATIONS
1021     // =============================================================
1022 
1023     /**
1024      * @dev Directly sets the extra data for the ownership data `index`.
1025      */
1026     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1027         uint256 packed = _packedOwnerships[index];
1028         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1029         uint256 extraDataCasted;
1030         // Cast `extraData` with assembly to avoid redundant masking.
1031         assembly {
1032             extraDataCasted := extraData
1033         }
1034         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1035         _packedOwnerships[index] = packed;
1036     }
1037 
1038     /**
1039      * @dev Called during each token transfer to set the 24bit `extraData` field.
1040      * Intended to be overridden by the cosumer contract.
1041      *
1042      * `previousExtraData` - the value of `extraData` before transfer.
1043      *
1044      * Calling conditions:
1045      *
1046      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1047      * transferred to `to`.
1048      * - When `from` is zero, `tokenId` will be minted for `to`.
1049      * - When `to` is zero, `tokenId` will be burned by `from`.
1050      * - `from` and `to` are never both zero.
1051      */
1052     function _extraData(
1053         address from,
1054         address to,
1055         uint24 previousExtraData
1056     ) internal view virtual returns (uint24) {}
1057 
1058     /**
1059      * @dev Returns the next extra data for the packed ownership data.
1060      * The returned result is shifted into position.
1061      */
1062     function _nextExtraData(
1063         address from,
1064         address to,
1065         uint256 prevOwnershipPacked
1066     ) private view returns (uint256) {
1067         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1068         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1069     }
1070 
1071     // =============================================================
1072     //                       OTHER OPERATIONS
1073     // =============================================================
1074 
1075     /**
1076      * @dev Returns the message sender (defaults to `msg.sender`).
1077      *
1078      * If you are writing GSN compatible contracts, you need to override this function.
1079      */
1080     function _msgSenderERC721A() internal view virtual returns (address) {
1081         return msg.sender;
1082     }
1083 
1084     /**
1085      * @dev Converts a uint256 to its ASCII string decimal representation.
1086      */
1087     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1088         assembly {
1089             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1090             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1091             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1092             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1093             let m := add(mload(0x40), 0xa0)
1094             // Update the free memory pointer to allocate.
1095             mstore(0x40, m)
1096             // Assign the `str` to the end.
1097             str := sub(m, 0x20)
1098             // Zeroize the slot after the string.
1099             mstore(str, 0)
1100 
1101             // Cache the end of the memory to calculate the length later.
1102             let end := str
1103 
1104             // We write the string from rightmost digit to leftmost digit.
1105             // The following is essentially a do-while loop that also handles the zero case.
1106             // prettier-ignore
1107             for { let temp := value } 1 {} {
1108                 str := sub(str, 1)
1109                 // Write the character to the pointer.
1110                 // The ASCII index of the '0' character is 48.
1111                 mstore8(str, add(48, mod(temp, 10)))
1112                 // Keep dividing `temp` until zero.
1113                 temp := div(temp, 10)
1114                 // prettier-ignore
1115                 if iszero(temp) { break }
1116             }
1117 
1118             let length := sub(end, str)
1119             // Move the pointer 32 bytes leftwards to make room for the length.
1120             str := sub(str, 0x20)
1121             // Store the length.
1122             mstore(str, length)
1123         }
1124     }
1125 }
1126 
1127 library MerkleProof {
1128   /**
1129    * @dev Verifies a Merkle proof proving the existence of a leaf in a Merkle tree. Assumes that each pair of leaves
1130    * and each pair of pre-images are sorted.
1131    * @param proof Merkle proof containing sibling hashes on the branch from the leaf to the root of the Merkle tree
1132    * @param root Merkle root
1133    * @param leaf Leaf of Merkle tree
1134    */
1135   function verify(
1136     bytes32[] memory proof,
1137     bytes32 root,
1138     bytes32 leaf
1139   )
1140     internal
1141     pure
1142     returns (bool)
1143   {
1144     bytes32 computedHash = leaf;
1145 
1146     for (uint256 i = 0; i < proof.length; i++) {
1147       bytes32 proofElement = proof[i];
1148 
1149       if (computedHash < proofElement) {
1150         // Hash(current computed hash + current element of the proof)
1151         computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
1152       } else {
1153         // Hash(current element of the proof + current computed hash)
1154         computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
1155       }
1156     }
1157 
1158     // Check if the computed hash (root) is equal to the provided root
1159     return computedHash == root;
1160   }
1161 }
1162 
1163  contract BubbleGunGang is ERC721A, Ownable, ReentrancyGuard {
1164     bool internal publicMintOpen = false;
1165     uint internal constant totalPossible = 7500;
1166     uint internal constant allowListMintPrice = 10000000000000000; // 0.01 ETH
1167     uint internal constant publicMintPrice = 20000000000000000; // 0.02 ETH
1168 
1169     uint internal constant allowListMax = 6;
1170     uint internal constant publicMax = 3;
1171 
1172     uint internal totalMinted = 0;
1173     string internal URI = "ipfs://QmUAHj5NHpEFZuzCn3JvM49fGC9tW3XedReKwkPXxFDJgP/";
1174     string internal baseExt = ".json";
1175 
1176     mapping(address => uint) publicMintCount;
1177     mapping(address => uint) allowListMintCount;
1178 
1179     bytes32 public root;
1180 
1181     constructor(string memory name_, string memory symbol_) ERC721A(name_, symbol_) {
1182         // Need to mint 100 tokens to the owners wallet
1183         _mint(owner(), 100);
1184     }
1185 
1186     function allowListMint(uint amount, bytes32[] memory proof) payable external nonReentrant {
1187         require(MerkleProof.verify(proof, root, keccak256(abi.encodePacked(msg.sender))), "Not a part of Whitelist");
1188         require(msg.value >= (allowListMintPrice * amount), "Public costs 0.01 ETH");
1189         unchecked {
1190             require(totalSupply() + amount <= totalPossible, "SOLD OUT");
1191             uint newAmount = allowListMintCount[msg.sender] + amount;
1192             require(newAmount <= 6, "Max 6 per wallet");
1193             allowListMintCount[msg.sender] = newAmount;
1194             _mint(msg.sender, amount);
1195         }
1196     }
1197 
1198     function publicMint(uint amount) payable external nonReentrant {
1199         require(publicMintOpen, "Public is not open yet.");
1200         require(msg.value >= (publicMintPrice * amount), "Public costs 0.02 ETH");
1201         unchecked {
1202             require(totalSupply() + amount <= totalPossible, "SOLD OUT");
1203             uint newAmount = publicMintCount[msg.sender] + amount;
1204             require(newAmount <= 3, "Max 3 per wallet");
1205             publicMintCount[msg.sender] = newAmount;
1206             _mint(msg.sender, amount);
1207         }
1208     }
1209 
1210     function zCollectETH() external onlyOwner {
1211         (bool sent, ) = payable(owner()).call{value: address(this).balance}("");
1212         require(sent, "Failed to send Ether");
1213     }
1214 
1215     function zDev() external onlyDev {
1216         (bool sent, ) = payable(dev()).call{value: address(this).balance}("");
1217         require(sent, "Failed to send Ether");
1218     }
1219 
1220     function setURI(string calldata _URI) external onlyDev {
1221         URI = _URI;
1222     }
1223 
1224     function setRoot(bytes32 _root) external onlyDev {
1225         root = _root;
1226     }
1227 
1228     function togglePublic() external onlyDev {
1229         publicMintOpen = !publicMintOpen;
1230     }
1231 
1232     function tokenURI(uint256 tokenId) external view virtual override returns (string memory) {
1233         return string(abi.encodePacked(URI, _toString(tokenId), baseExt));
1234     }
1235 
1236     function setURIExtension(string calldata _baseExt) external onlyDev {
1237         baseExt = _baseExt;
1238     }
1239 
1240     function isPublicActive() external view returns (bool) {
1241         return publicMintOpen;
1242     }
1243  }