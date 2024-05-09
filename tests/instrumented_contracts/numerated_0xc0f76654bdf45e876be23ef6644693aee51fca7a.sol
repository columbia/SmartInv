1 //. 
2 //. .-. .-.  .--.   .----..-. .-..-..-.   .-. .----.  .---.  .----.     .---.   .--.  .---. 
3 //. | {_} | / {} \ { {__  | {_} || ||  `.'  |/  {}  \{_   _}/  {}  \   /  ___} / {} \{_   _}
4 //. | { } |/  /\  \.-._} }| { } || || |\ /| |\      /  | |  \      /   \     }/  /\  \ | |  
5 //. `-' `-'`-'  `-'`----' `-' `-'`-'`-' ` `-' `----'   `-'   `----'     `---' `-'  `-' `-'  
6 //. 
7 
8 // SPDX-License-Identifier: MIT
9 
10 // File: erc721a/contracts/IERC721A.sol
11 
12 
13 // ERC721A Contracts v4.1.0
14 // Creator: Chiru Labs
15 
16 pragma solidity ^0.8.4;
17 
18 /**
19  * @dev Interface of an ERC721A compliant contract.
20  */
21 interface IERC721A {
22     /**
23      * The caller must own the token or be an approved operator.
24      */
25     error ApprovalCallerNotOwnerNorApproved();
26 
27     /**
28      * The token does not exist.
29      */
30     error ApprovalQueryForNonexistentToken();
31 
32     /**
33      * The caller cannot approve to their own address.
34      */
35     error ApproveToCaller();
36 
37     /**
38      * Cannot query the balance for the zero address.
39      */
40     error BalanceQueryForZeroAddress();
41 
42     /**
43      * Cannot mint to the zero address.
44      */
45     error MintToZeroAddress();
46 
47     /**
48      * The quantity of tokens minted must be more than zero.
49      */
50     error MintZeroQuantity();
51 
52     /**
53      * The token does not exist.
54      */
55     error OwnerQueryForNonexistentToken();
56 
57     /**
58      * The caller must own the token or be an approved operator.
59      */
60     error TransferCallerNotOwnerNorApproved();
61 
62     /**
63      * The token must be owned by `from`.
64      */
65     error TransferFromIncorrectOwner();
66 
67     /**
68      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
69      */
70     error TransferToNonERC721ReceiverImplementer();
71 
72     /**
73      * Cannot transfer to the zero address.
74      */
75     error TransferToZeroAddress();
76 
77     /**
78      * The token does not exist.
79      */
80     error URIQueryForNonexistentToken();
81 
82     /**
83      * The `quantity` minted with ERC2309 exceeds the safety limit.
84      */
85     error MintERC2309QuantityExceedsLimit();
86 
87     /**
88      * The `extraData` cannot be set on an unintialized ownership slot.
89      */
90     error OwnershipNotInitializedForExtraData();
91 
92     struct TokenOwnership {
93         // The address of the owner.
94         address addr;
95         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
96         uint64 startTimestamp;
97         // Whether the token has been burned.
98         bool burned;
99         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
100         uint24 extraData;
101     }
102 
103     /**
104      * @dev Returns the total amount of tokens stored by the contract.
105      *
106      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
107      */
108     function totalSupply() external view returns (uint256);
109 
110     // ==============================
111     //            IERC165
112     // ==============================
113 
114     /**
115      * @dev Returns true if this contract implements the interface defined by
116      * `interfaceId`. See the corresponding
117      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
118      * to learn more about how these ids are created.
119      *
120      * This function call must use less than 30 000 gas.
121      */
122     function supportsInterface(bytes4 interfaceId) external view returns (bool);
123 
124     // ==============================
125     //            IERC721
126     // ==============================
127 
128     /**
129      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
130      */
131     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
132 
133     /**
134      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
135      */
136     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
137 
138     /**
139      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
140      */
141     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
142 
143     /**
144      * @dev Returns the number of tokens in ``owner``'s account.
145      */
146     function balanceOf(address owner) external view returns (uint256 balance);
147 
148     /**
149      * @dev Returns the owner of the `tokenId` token.
150      *
151      * Requirements:
152      *
153      * - `tokenId` must exist.
154      */
155     function ownerOf(uint256 tokenId) external view returns (address owner);
156 
157     /**
158      * @dev Safely transfers `tokenId` token from `from` to `to`.
159      *
160      * Requirements:
161      *
162      * - `from` cannot be the zero address.
163      * - `to` cannot be the zero address.
164      * - `tokenId` token must exist and be owned by `from`.
165      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
166      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
167      *
168      * Emits a {Transfer} event.
169      */
170     function safeTransferFrom(
171         address from,
172         address to,
173         uint256 tokenId,
174         bytes calldata data
175     ) external;
176 
177     /**
178      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
179      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
180      *
181      * Requirements:
182      *
183      * - `from` cannot be the zero address.
184      * - `to` cannot be the zero address.
185      * - `tokenId` token must exist and be owned by `from`.
186      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
187      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
188      *
189      * Emits a {Transfer} event.
190      */
191     function safeTransferFrom(
192         address from,
193         address to,
194         uint256 tokenId
195     ) external;
196 
197     /**
198      * @dev Transfers `tokenId` token from `from` to `to`.
199      *
200      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
201      *
202      * Requirements:
203      *
204      * - `from` cannot be the zero address.
205      * - `to` cannot be the zero address.
206      * - `tokenId` token must be owned by `from`.
207      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
208      *
209      * Emits a {Transfer} event.
210      */
211     function transferFrom(
212         address from,
213         address to,
214         uint256 tokenId
215     ) external;
216 
217     /**
218      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
219      * The approval is cleared when the token is transferred.
220      *
221      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
222      *
223      * Requirements:
224      *
225      * - The caller must own the token or be an approved operator.
226      * - `tokenId` must exist.
227      *
228      * Emits an {Approval} event.
229      */
230     function approve(address to, uint256 tokenId) external;
231 
232     /**
233      * @dev Approve or remove `operator` as an operator for the caller.
234      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
235      *
236      * Requirements:
237      *
238      * - The `operator` cannot be the caller.
239      *
240      * Emits an {ApprovalForAll} event.
241      */
242     function setApprovalForAll(address operator, bool _approved) external;
243 
244     /**
245      * @dev Returns the account approved for `tokenId` token.
246      *
247      * Requirements:
248      *
249      * - `tokenId` must exist.
250      */
251     function getApproved(uint256 tokenId) external view returns (address operator);
252 
253     /**
254      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
255      *
256      * See {setApprovalForAll}
257      */
258     function isApprovedForAll(address owner, address operator) external view returns (bool);
259 
260     // ==============================
261     //        IERC721Metadata
262     // ==============================
263 
264     /**
265      * @dev Returns the token collection name.
266      */
267     function name() external view returns (string memory);
268 
269     /**
270      * @dev Returns the token collection symbol.
271      */
272     function symbol() external view returns (string memory);
273 
274     /**
275      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
276      */
277     function tokenURI(uint256 tokenId) external view returns (string memory);
278 
279     // ==============================
280     //            IERC2309
281     // ==============================
282 
283     /**
284      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
285      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
286      */
287     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
288 }
289 
290 // File: erc721a/contracts/ERC721A.sol
291 
292 
293 // ERC721A Contracts v4.1.0
294 // Creator: Chiru Labs
295 
296 pragma solidity ^0.8.4;
297 
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
312  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
313  * including the Metadata extension. Built to optimize for lower gas during batch mints.
314  *
315  * Assumes serials are sequentially minted starting at `_startTokenId()`
316  * (defaults to 0, e.g. 0, 1, 2, 3..).
317  *
318  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
319  *
320  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
321  */
322 contract ERC721A is IERC721A {
323     // Mask of an entry in packed address data.
324     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
325 
326     // The bit position of `numberMinted` in packed address data.
327     uint256 private constant BITPOS_NUMBER_MINTED = 64;
328 
329     // The bit position of `numberBurned` in packed address data.
330     uint256 private constant BITPOS_NUMBER_BURNED = 128;
331 
332     // The bit position of `aux` in packed address data.
333     uint256 private constant BITPOS_AUX = 192;
334 
335     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
336     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
337 
338     // The bit position of `startTimestamp` in packed ownership.
339     uint256 private constant BITPOS_START_TIMESTAMP = 160;
340 
341     // The bit mask of the `burned` bit in packed ownership.
342     uint256 private constant BITMASK_BURNED = 1 << 224;
343 
344     // The bit position of the `nextInitialized` bit in packed ownership.
345     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
346 
347     // The bit mask of the `nextInitialized` bit in packed ownership.
348     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
349 
350     // The bit position of `extraData` in packed ownership.
351     uint256 private constant BITPOS_EXTRA_DATA = 232;
352 
353     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
354     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
355 
356     // The mask of the lower 160 bits for addresses.
357     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
358 
359     // The maximum `quantity` that can be minted with `_mintERC2309`.
360     // This limit is to prevent overflows on the address data entries.
361     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
362     // is required to cause an overflow, which is unrealistic.
363     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
364 
365     // The tokenId of the next token to be minted.
366     uint256 private _currentIndex;
367 
368     // The number of tokens burned.
369     uint256 private _burnCounter;
370 
371     // Token name
372     string private _name;
373 
374     // Token symbol
375     string private _symbol;
376 
377     // Mapping from token ID to ownership details
378     // An empty struct value does not necessarily mean the token is unowned.
379     // See `_packedOwnershipOf` implementation for details.
380     //
381     // Bits Layout:
382     // - [0..159]   `addr`
383     // - [160..223] `startTimestamp`
384     // - [224]      `burned`
385     // - [225]      `nextInitialized`
386     // - [232..255] `extraData`
387     mapping(uint256 => uint256) private _packedOwnerships;
388 
389     // Mapping owner address to address data.
390     //
391     // Bits Layout:
392     // - [0..63]    `balance`
393     // - [64..127]  `numberMinted`
394     // - [128..191] `numberBurned`
395     // - [192..255] `aux`
396     mapping(address => uint256) private _packedAddressData;
397 
398     // Mapping from token ID to approved address.
399     mapping(uint256 => address) private _tokenApprovals;
400 
401     // Mapping from owner to operator approvals
402     mapping(address => mapping(address => bool)) private _operatorApprovals;
403 
404     constructor(string memory name_, string memory symbol_) {
405         _name = name_;
406         _symbol = symbol_;
407         _currentIndex = _startTokenId();
408     }
409 
410     /**
411      * @dev Returns the starting token ID.
412      * To change the starting token ID, please override this function.
413      */
414     function _startTokenId() internal view virtual returns (uint256) {
415         return 0;
416     }
417 
418     /**
419      * @dev Returns the next token ID to be minted.
420      */
421     function _nextTokenId() internal view returns (uint256) {
422         return _currentIndex;
423     }
424 
425     /**
426      * @dev Returns the total number of tokens in existence.
427      * Burned tokens will reduce the count.
428      * To get the total number of tokens minted, please see `_totalMinted`.
429      */
430     function totalSupply() public view override returns (uint256) {
431         // Counter underflow is impossible as _burnCounter cannot be incremented
432         // more than `_currentIndex - _startTokenId()` times.
433         unchecked {
434             return _currentIndex - _burnCounter - _startTokenId();
435         }
436     }
437 
438     /**
439      * @dev Returns the total amount of tokens minted in the contract.
440      */
441     function _totalMinted() internal view returns (uint256) {
442         // Counter underflow is impossible as _currentIndex does not decrement,
443         // and it is initialized to `_startTokenId()`
444         unchecked {
445             return _currentIndex - _startTokenId();
446         }
447     }
448 
449     /**
450      * @dev Returns the total number of tokens burned.
451      */
452     function _totalBurned() internal view returns (uint256) {
453         return _burnCounter;
454     }
455 
456     /**
457      * @dev See {IERC165-supportsInterface}.
458      */
459     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
460         // The interface IDs are constants representing the first 4 bytes of the XOR of
461         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
462         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
463         return
464             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
465             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
466             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
467     }
468 
469     /**
470      * @dev See {IERC721-balanceOf}.
471      */
472     function balanceOf(address owner) public view override returns (uint256) {
473         if (owner == address(0)) revert BalanceQueryForZeroAddress();
474         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
475     }
476 
477     /**
478      * Returns the number of tokens minted by `owner`.
479      */
480     function _numberMinted(address owner) internal view returns (uint256) {
481         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
482     }
483 
484     /**
485      * Returns the number of tokens burned by or on behalf of `owner`.
486      */
487     function _numberBurned(address owner) internal view returns (uint256) {
488         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
489     }
490 
491     /**
492      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
493      */
494     function _getAux(address owner) internal view returns (uint64) {
495         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
496     }
497 
498     /**
499      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
500      * If there are multiple variables, please pack them into a uint64.
501      */
502     function _setAux(address owner, uint64 aux) internal {
503         uint256 packed = _packedAddressData[owner];
504         uint256 auxCasted;
505         // Cast `aux` with assembly to avoid redundant masking.
506         assembly {
507             auxCasted := aux
508         }
509         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
510         _packedAddressData[owner] = packed;
511     }
512 
513     /**
514      * Returns the packed ownership data of `tokenId`.
515      */
516     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
517         uint256 curr = tokenId;
518 
519         unchecked {
520             if (_startTokenId() <= curr)
521                 if (curr < _currentIndex) {
522                     uint256 packed = _packedOwnerships[curr];
523                     // If not burned.
524                     if (packed & BITMASK_BURNED == 0) {
525                         // Invariant:
526                         // There will always be an ownership that has an address and is not burned
527                         // before an ownership that does not have an address and is not burned.
528                         // Hence, curr will not underflow.
529                         //
530                         // We can directly compare the packed value.
531                         // If the address is zero, packed is zero.
532                         while (packed == 0) {
533                             packed = _packedOwnerships[--curr];
534                         }
535                         return packed;
536                     }
537                 }
538         }
539         revert OwnerQueryForNonexistentToken();
540     }
541 
542     /**
543      * Returns the unpacked `TokenOwnership` struct from `packed`.
544      */
545     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
546         ownership.addr = address(uint160(packed));
547         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
548         ownership.burned = packed & BITMASK_BURNED != 0;
549         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
550     }
551 
552     /**
553      * Returns the unpacked `TokenOwnership` struct at `index`.
554      */
555     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
556         return _unpackedOwnership(_packedOwnerships[index]);
557     }
558 
559     /**
560      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
561      */
562     function _initializeOwnershipAt(uint256 index) internal {
563         if (_packedOwnerships[index] == 0) {
564             _packedOwnerships[index] = _packedOwnershipOf(index);
565         }
566     }
567 
568     /**
569      * Gas spent here starts off proportional to the maximum mint batch size.
570      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
571      */
572     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
573         return _unpackedOwnership(_packedOwnershipOf(tokenId));
574     }
575 
576     /**
577      * @dev Packs ownership data into a single uint256.
578      */
579     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
580         assembly {
581             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
582             owner := and(owner, BITMASK_ADDRESS)
583             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
584             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
585         }
586     }
587 
588     /**
589      * @dev See {IERC721-ownerOf}.
590      */
591     function ownerOf(uint256 tokenId) public view override returns (address) {
592         return address(uint160(_packedOwnershipOf(tokenId)));
593     }
594 
595     /**
596      * @dev See {IERC721Metadata-name}.
597      */
598     function name() public view virtual override returns (string memory) {
599         return _name;
600     }
601 
602     /**
603      * @dev See {IERC721Metadata-symbol}.
604      */
605     function symbol() public view virtual override returns (string memory) {
606         return _symbol;
607     }
608 
609     /**
610      * @dev See {IERC721Metadata-tokenURI}.
611      */
612     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
613         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
614 
615         string memory baseURI = _baseURI();
616         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
617     }
618 
619     /**
620      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
621      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
622      * by default, it can be overridden in child contracts.
623      */
624     function _baseURI() internal view virtual returns (string memory) {
625         return '';
626     }
627 
628     /**
629      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
630      */
631     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
632         // For branchless setting of the `nextInitialized` flag.
633         assembly {
634             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
635             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
636         }
637     }
638 
639     /**
640      * @dev See {IERC721-approve}.
641      */
642     function approve(address to, uint256 tokenId) public override {
643         address owner = ownerOf(tokenId);
644 
645         if (_msgSenderERC721A() != owner)
646             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
647                 revert ApprovalCallerNotOwnerNorApproved();
648             }
649 
650         _tokenApprovals[tokenId] = to;
651         emit Approval(owner, to, tokenId);
652     }
653 
654     /**
655      * @dev See {IERC721-getApproved}.
656      */
657     function getApproved(uint256 tokenId) public view override returns (address) {
658         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
659 
660         return _tokenApprovals[tokenId];
661     }
662 
663     /**
664      * @dev See {IERC721-setApprovalForAll}.
665      */
666     function setApprovalForAll(address operator, bool approved) public virtual override {
667         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
668 
669         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
670         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
671     }
672 
673     /**
674      * @dev See {IERC721-isApprovedForAll}.
675      */
676     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
677         return _operatorApprovals[owner][operator];
678     }
679 
680     /**
681      * @dev See {IERC721-safeTransferFrom}.
682      */
683     function safeTransferFrom(
684         address from,
685         address to,
686         uint256 tokenId
687     ) public virtual override {
688         safeTransferFrom(from, to, tokenId, '');
689     }
690 
691     /**
692      * @dev See {IERC721-safeTransferFrom}.
693      */
694     function safeTransferFrom(
695         address from,
696         address to,
697         uint256 tokenId,
698         bytes memory _data
699     ) public virtual override {
700         transferFrom(from, to, tokenId);
701         if (to.code.length != 0)
702             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
703                 revert TransferToNonERC721ReceiverImplementer();
704             }
705     }
706 
707     /**
708      * @dev Returns whether `tokenId` exists.
709      *
710      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
711      *
712      * Tokens start existing when they are minted (`_mint`),
713      */
714     function _exists(uint256 tokenId) internal view returns (bool) {
715         return
716             _startTokenId() <= tokenId &&
717             tokenId < _currentIndex && // If within bounds,
718             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
719     }
720 
721     /**
722      * @dev Equivalent to `_safeMint(to, quantity, '')`.
723      */
724     function _safeMint(address to, uint256 quantity) internal {
725         _safeMint(to, quantity, '');
726     }
727 
728     /**
729      * @dev Safely mints `quantity` tokens and transfers them to `to`.
730      *
731      * Requirements:
732      *
733      * - If `to` refers to a smart contract, it must implement
734      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
735      * - `quantity` must be greater than 0.
736      *
737      * See {_mint}.
738      *
739      * Emits a {Transfer} event for each mint.
740      */
741     function _safeMint(
742         address to,
743         uint256 quantity,
744         bytes memory _data
745     ) internal {
746         _mint(to, quantity);
747 
748         unchecked {
749             if (to.code.length != 0) {
750                 uint256 end = _currentIndex;
751                 uint256 index = end - quantity;
752                 do {
753                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
754                         revert TransferToNonERC721ReceiverImplementer();
755                     }
756                 } while (index < end);
757                 // Reentrancy protection.
758                 if (_currentIndex != end) revert();
759             }
760         }
761     }
762 
763     /**
764      * @dev Mints `quantity` tokens and transfers them to `to`.
765      *
766      * Requirements:
767      *
768      * - `to` cannot be the zero address.
769      * - `quantity` must be greater than 0.
770      *
771      * Emits a {Transfer} event for each mint.
772      */
773     function _mint(address to, uint256 quantity) internal {
774         uint256 startTokenId = _currentIndex;
775         if (to == address(0)) revert MintToZeroAddress();
776         if (quantity == 0) revert MintZeroQuantity();
777 
778         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
779 
780         // Overflows are incredibly unrealistic.
781         // `balance` and `numberMinted` have a maximum limit of 2**64.
782         // `tokenId` has a maximum limit of 2**256.
783         unchecked {
784             // Updates:
785             // - `balance += quantity`.
786             // - `numberMinted += quantity`.
787             //
788             // We can directly add to the `balance` and `numberMinted`.
789             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
790 
791             // Updates:
792             // - `address` to the owner.
793             // - `startTimestamp` to the timestamp of minting.
794             // - `burned` to `false`.
795             // - `nextInitialized` to `quantity == 1`.
796             _packedOwnerships[startTokenId] = _packOwnershipData(
797                 to,
798                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
799             );
800 
801             uint256 tokenId = startTokenId;
802             uint256 end = startTokenId + quantity;
803             do {
804                 emit Transfer(address(0), to, tokenId++);
805             } while (tokenId < end);
806 
807             _currentIndex = end;
808         }
809         _afterTokenTransfers(address(0), to, startTokenId, quantity);
810     }
811 
812     /**
813      * @dev Mints `quantity` tokens and transfers them to `to`.
814      *
815      * This function is intended for efficient minting only during contract creation.
816      *
817      * It emits only one {ConsecutiveTransfer} as defined in
818      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
819      * instead of a sequence of {Transfer} event(s).
820      *
821      * Calling this function outside of contract creation WILL make your contract
822      * non-compliant with the ERC721 standard.
823      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
824      * {ConsecutiveTransfer} event is only permissible during contract creation.
825      *
826      * Requirements:
827      *
828      * - `to` cannot be the zero address.
829      * - `quantity` must be greater than 0.
830      *
831      * Emits a {ConsecutiveTransfer} event.
832      */
833     function _mintERC2309(address to, uint256 quantity) internal {
834         uint256 startTokenId = _currentIndex;
835         if (to == address(0)) revert MintToZeroAddress();
836         if (quantity == 0) revert MintZeroQuantity();
837         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
838 
839         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
840 
841         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
842         unchecked {
843             // Updates:
844             // - `balance += quantity`.
845             // - `numberMinted += quantity`.
846             //
847             // We can directly add to the `balance` and `numberMinted`.
848             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
849 
850             // Updates:
851             // - `address` to the owner.
852             // - `startTimestamp` to the timestamp of minting.
853             // - `burned` to `false`.
854             // - `nextInitialized` to `quantity == 1`.
855             _packedOwnerships[startTokenId] = _packOwnershipData(
856                 to,
857                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
858             );
859 
860             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
861 
862             _currentIndex = startTokenId + quantity;
863         }
864         _afterTokenTransfers(address(0), to, startTokenId, quantity);
865     }
866 
867     /**
868      * @dev Returns the storage slot and value for the approved address of `tokenId`.
869      */
870     function _getApprovedAddress(uint256 tokenId)
871         private
872         view
873         returns (uint256 approvedAddressSlot, address approvedAddress)
874     {
875         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
876         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
877         assembly {
878             // Compute the slot.
879             mstore(0x00, tokenId)
880             mstore(0x20, tokenApprovalsPtr.slot)
881             approvedAddressSlot := keccak256(0x00, 0x40)
882             // Load the slot's value from storage.
883             approvedAddress := sload(approvedAddressSlot)
884         }
885     }
886 
887     /**
888      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
889      */
890     function _isOwnerOrApproved(
891         address approvedAddress,
892         address from,
893         address msgSender
894     ) private pure returns (bool result) {
895         assembly {
896             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
897             from := and(from, BITMASK_ADDRESS)
898             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
899             msgSender := and(msgSender, BITMASK_ADDRESS)
900             // `msgSender == from || msgSender == approvedAddress`.
901             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
902         }
903     }
904 
905     /**
906      * @dev Transfers `tokenId` from `from` to `to`.
907      *
908      * Requirements:
909      *
910      * - `to` cannot be the zero address.
911      * - `tokenId` token must be owned by `from`.
912      *
913      * Emits a {Transfer} event.
914      */
915     function transferFrom(
916         address from,
917         address to,
918         uint256 tokenId
919     ) public virtual override {
920         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
921 
922         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
923 
924         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
925 
926         // The nested ifs save around 20+ gas over a compound boolean condition.
927         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
928             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
929 
930         if (to == address(0)) revert TransferToZeroAddress();
931 
932         _beforeTokenTransfers(from, to, tokenId, 1);
933 
934         // Clear approvals from the previous owner.
935         assembly {
936             if approvedAddress {
937                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
938                 sstore(approvedAddressSlot, 0)
939             }
940         }
941 
942         // Underflow of the sender's balance is impossible because we check for
943         // ownership above and the recipient's balance can't realistically overflow.
944         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
945         unchecked {
946             // We can directly increment and decrement the balances.
947             --_packedAddressData[from]; // Updates: `balance -= 1`.
948             ++_packedAddressData[to]; // Updates: `balance += 1`.
949 
950             // Updates:
951             // - `address` to the next owner.
952             // - `startTimestamp` to the timestamp of transfering.
953             // - `burned` to `false`.
954             // - `nextInitialized` to `true`.
955             _packedOwnerships[tokenId] = _packOwnershipData(
956                 to,
957                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
958             );
959 
960             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
961             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
962                 uint256 nextTokenId = tokenId + 1;
963                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
964                 if (_packedOwnerships[nextTokenId] == 0) {
965                     // If the next slot is within bounds.
966                     if (nextTokenId != _currentIndex) {
967                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
968                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
969                     }
970                 }
971             }
972         }
973 
974         emit Transfer(from, to, tokenId);
975         _afterTokenTransfers(from, to, tokenId, 1);
976     }
977 
978     /**
979      * @dev Equivalent to `_burn(tokenId, false)`.
980      */
981     function _burn(uint256 tokenId) internal virtual {
982         _burn(tokenId, false);
983     }
984 
985     /**
986      * @dev Destroys `tokenId`.
987      * The approval is cleared when the token is burned.
988      *
989      * Requirements:
990      *
991      * - `tokenId` must exist.
992      *
993      * Emits a {Transfer} event.
994      */
995     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
996         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
997 
998         address from = address(uint160(prevOwnershipPacked));
999 
1000         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1001 
1002         if (approvalCheck) {
1003             // The nested ifs save around 20+ gas over a compound boolean condition.
1004             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1005                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1006         }
1007 
1008         _beforeTokenTransfers(from, address(0), tokenId, 1);
1009 
1010         // Clear approvals from the previous owner.
1011         assembly {
1012             if approvedAddress {
1013                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1014                 sstore(approvedAddressSlot, 0)
1015             }
1016         }
1017 
1018         // Underflow of the sender's balance is impossible because we check for
1019         // ownership above and the recipient's balance can't realistically overflow.
1020         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1021         unchecked {
1022             // Updates:
1023             // - `balance -= 1`.
1024             // - `numberBurned += 1`.
1025             //
1026             // We can directly decrement the balance, and increment the number burned.
1027             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1028             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1029 
1030             // Updates:
1031             // - `address` to the last owner.
1032             // - `startTimestamp` to the timestamp of burning.
1033             // - `burned` to `true`.
1034             // - `nextInitialized` to `true`.
1035             _packedOwnerships[tokenId] = _packOwnershipData(
1036                 from,
1037                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1038             );
1039 
1040             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1041             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1042                 uint256 nextTokenId = tokenId + 1;
1043                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1044                 if (_packedOwnerships[nextTokenId] == 0) {
1045                     // If the next slot is within bounds.
1046                     if (nextTokenId != _currentIndex) {
1047                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1048                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1049                     }
1050                 }
1051             }
1052         }
1053 
1054         emit Transfer(from, address(0), tokenId);
1055         _afterTokenTransfers(from, address(0), tokenId, 1);
1056 
1057         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1058         unchecked {
1059             _burnCounter++;
1060         }
1061     }
1062 
1063     /**
1064      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1065      *
1066      * @param from address representing the previous owner of the given token ID
1067      * @param to target address that will receive the tokens
1068      * @param tokenId uint256 ID of the token to be transferred
1069      * @param _data bytes optional data to send along with the call
1070      * @return bool whether the call correctly returned the expected magic value
1071      */
1072     function _checkContractOnERC721Received(
1073         address from,
1074         address to,
1075         uint256 tokenId,
1076         bytes memory _data
1077     ) private returns (bool) {
1078         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1079             bytes4 retval
1080         ) {
1081             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1082         } catch (bytes memory reason) {
1083             if (reason.length == 0) {
1084                 revert TransferToNonERC721ReceiverImplementer();
1085             } else {
1086                 assembly {
1087                     revert(add(32, reason), mload(reason))
1088                 }
1089             }
1090         }
1091     }
1092 
1093     /**
1094      * @dev Directly sets the extra data for the ownership data `index`.
1095      */
1096     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1097         uint256 packed = _packedOwnerships[index];
1098         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1099         uint256 extraDataCasted;
1100         // Cast `extraData` with assembly to avoid redundant masking.
1101         assembly {
1102             extraDataCasted := extraData
1103         }
1104         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1105         _packedOwnerships[index] = packed;
1106     }
1107 
1108     /**
1109      * @dev Returns the next extra data for the packed ownership data.
1110      * The returned result is shifted into position.
1111      */
1112     function _nextExtraData(
1113         address from,
1114         address to,
1115         uint256 prevOwnershipPacked
1116     ) private view returns (uint256) {
1117         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1118         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1119     }
1120 
1121     /**
1122      * @dev Called during each token transfer to set the 24bit `extraData` field.
1123      * Intended to be overridden by the cosumer contract.
1124      *
1125      * `previousExtraData` - the value of `extraData` before transfer.
1126      *
1127      * Calling conditions:
1128      *
1129      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1130      * transferred to `to`.
1131      * - When `from` is zero, `tokenId` will be minted for `to`.
1132      * - When `to` is zero, `tokenId` will be burned by `from`.
1133      * - `from` and `to` are never both zero.
1134      */
1135     function _extraData(
1136         address from,
1137         address to,
1138         uint24 previousExtraData
1139     ) internal view virtual returns (uint24) {}
1140 
1141     /**
1142      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1143      * This includes minting.
1144      * And also called before burning one token.
1145      *
1146      * startTokenId - the first token id to be transferred
1147      * quantity - the amount to be transferred
1148      *
1149      * Calling conditions:
1150      *
1151      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1152      * transferred to `to`.
1153      * - When `from` is zero, `tokenId` will be minted for `to`.
1154      * - When `to` is zero, `tokenId` will be burned by `from`.
1155      * - `from` and `to` are never both zero.
1156      */
1157     function _beforeTokenTransfers(
1158         address from,
1159         address to,
1160         uint256 startTokenId,
1161         uint256 quantity
1162     ) internal virtual {}
1163 
1164     /**
1165      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1166      * This includes minting.
1167      * And also called after one token has been burned.
1168      *
1169      * startTokenId - the first token id to be transferred
1170      * quantity - the amount to be transferred
1171      *
1172      * Calling conditions:
1173      *
1174      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1175      * transferred to `to`.
1176      * - When `from` is zero, `tokenId` has been minted for `to`.
1177      * - When `to` is zero, `tokenId` has been burned by `from`.
1178      * - `from` and `to` are never both zero.
1179      */
1180     function _afterTokenTransfers(
1181         address from,
1182         address to,
1183         uint256 startTokenId,
1184         uint256 quantity
1185     ) internal virtual {}
1186 
1187     /**
1188      * @dev Returns the message sender (defaults to `msg.sender`).
1189      *
1190      * If you are writing GSN compatible contracts, you need to override this function.
1191      */
1192     function _msgSenderERC721A() internal view virtual returns (address) {
1193         return msg.sender;
1194     }
1195 
1196     /**
1197      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1198      */
1199     function _toString(uint256 value) internal pure returns (string memory ptr) {
1200         assembly {
1201             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1202             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1203             // We will need 1 32-byte word to store the length,
1204             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1205             ptr := add(mload(0x40), 128)
1206             // Update the free memory pointer to allocate.
1207             mstore(0x40, ptr)
1208 
1209             // Cache the end of the memory to calculate the length later.
1210             let end := ptr
1211 
1212             // We write the string from the rightmost digit to the leftmost digit.
1213             // The following is essentially a do-while loop that also handles the zero case.
1214             // Costs a bit more than early returning for the zero case,
1215             // but cheaper in terms of deployment and overall runtime costs.
1216             for {
1217                 // Initialize and perform the first pass without check.
1218                 let temp := value
1219                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1220                 ptr := sub(ptr, 1)
1221                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1222                 mstore8(ptr, add(48, mod(temp, 10)))
1223                 temp := div(temp, 10)
1224             } temp {
1225                 // Keep dividing `temp` until zero.
1226                 temp := div(temp, 10)
1227             } {
1228                 // Body of the for loop.
1229                 ptr := sub(ptr, 1)
1230                 mstore8(ptr, add(48, mod(temp, 10)))
1231             }
1232 
1233             let length := sub(end, ptr)
1234             // Move the pointer 32 bytes leftwards to make room for the length.
1235             ptr := sub(ptr, 32)
1236             // Store the length.
1237             mstore(ptr, length)
1238         }
1239     }
1240 }
1241 
1242 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
1243 
1244 
1245 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1246 
1247 pragma solidity ^0.8.0;
1248 
1249 /**
1250  * @dev Contract module that helps prevent reentrant calls to a function.
1251  *
1252  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1253  * available, which can be applied to functions to make sure there are no nested
1254  * (reentrant) calls to them.
1255  *
1256  * Note that because there is a single `nonReentrant` guard, functions marked as
1257  * `nonReentrant` may not call one another. This can be worked around by making
1258  * those functions `private`, and then adding `external` `nonReentrant` entry
1259  * points to them.
1260  *
1261  * TIP: If you would like to learn more about reentrancy and alternative ways
1262  * to protect against it, check out our blog post
1263  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1264  */
1265 abstract contract ReentrancyGuard {
1266     // Booleans are more expensive than uint256 or any type that takes up a full
1267     // word because each write operation emits an extra SLOAD to first read the
1268     // slot's contents, replace the bits taken up by the boolean, and then write
1269     // back. This is the compiler's defense against contract upgrades and
1270     // pointer aliasing, and it cannot be disabled.
1271 
1272     // The values being non-zero value makes deployment a bit more expensive,
1273     // but in exchange the refund on every call to nonReentrant will be lower in
1274     // amount. Since refunds are capped to a percentage of the total
1275     // transaction's gas, it is best to keep them low in cases like this one, to
1276     // increase the likelihood of the full refund coming into effect.
1277     uint256 private constant _NOT_ENTERED = 1;
1278     uint256 private constant _ENTERED = 2;
1279 
1280     uint256 private _status;
1281 
1282     constructor() {
1283         _status = _NOT_ENTERED;
1284     }
1285 
1286     /**
1287      * @dev Prevents a contract from calling itself, directly or indirectly.
1288      * Calling a `nonReentrant` function from another `nonReentrant`
1289      * function is not supported. It is possible to prevent this from happening
1290      * by making the `nonReentrant` function external, and making it call a
1291      * `private` function that does the actual work.
1292      */
1293     modifier nonReentrant() {
1294         // On the first call to nonReentrant, _notEntered will be true
1295         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1296 
1297         // Any calls to nonReentrant after this point will fail
1298         _status = _ENTERED;
1299 
1300         _;
1301 
1302         // By storing the original value once again, a refund is triggered (see
1303         // https://eips.ethereum.org/EIPS/eip-2200)
1304         _status = _NOT_ENTERED;
1305     }
1306 }
1307 
1308 // File: @openzeppelin/contracts/utils/Context.sol
1309 
1310 
1311 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1312 
1313 pragma solidity ^0.8.0;
1314 
1315 /**
1316  * @dev Provides information about the current execution context, including the
1317  * sender of the transaction and its data. While these are generally available
1318  * via msg.sender and msg.data, they should not be accessed in such a direct
1319  * manner, since when dealing with meta-transactions the account sending and
1320  * paying for execution may not be the actual sender (as far as an application
1321  * is concerned).
1322  *
1323  * This contract is only required for intermediate, library-like contracts.
1324  */
1325 abstract contract Context {
1326     function _msgSender() internal view virtual returns (address) {
1327         return msg.sender;
1328     }
1329 
1330     function _msgData() internal view virtual returns (bytes calldata) {
1331         return msg.data;
1332     }
1333 }
1334 
1335 // File: @openzeppelin/contracts/access/Ownable.sol
1336 
1337 
1338 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1339 
1340 pragma solidity ^0.8.0;
1341 
1342 
1343 /**
1344  * @dev Contract module which provides a basic access control mechanism, where
1345  * there is an account (an owner) that can be granted exclusive access to
1346  * specific functions.
1347  *
1348  * By default, the owner account will be the one that deploys the contract. This
1349  * can later be changed with {transferOwnership}.
1350  *
1351  * This module is used through inheritance. It will make available the modifier
1352  * `onlyOwner`, which can be applied to your functions to restrict their use to
1353  * the owner.
1354  */
1355 abstract contract Ownable is Context {
1356     address private _owner;
1357 
1358     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1359 
1360     /**
1361      * @dev Initializes the contract setting the deployer as the initial owner.
1362      */
1363     constructor() {
1364         _transferOwnership(_msgSender());
1365     }
1366 
1367     /**
1368      * @dev Throws if called by any account other than the owner.
1369      */
1370     modifier onlyOwner() {
1371         _checkOwner();
1372         _;
1373     }
1374 
1375     /**
1376      * @dev Returns the address of the current owner.
1377      */
1378     function owner() public view virtual returns (address) {
1379         return _owner;
1380     }
1381 
1382     /**
1383      * @dev Throws if the sender is not the owner.
1384      */
1385     function _checkOwner() internal view virtual {
1386         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1387     }
1388 
1389     /**
1390      * @dev Leaves the contract without owner. It will not be possible to call
1391      * `onlyOwner` functions anymore. Can only be called by the current owner.
1392      *
1393      * NOTE: Renouncing ownership will leave the contract without an owner,
1394      * thereby removing any functionality that is only available to the owner.
1395      */
1396     function renounceOwnership() public virtual onlyOwner {
1397         _transferOwnership(address(0));
1398     }
1399 
1400     /**
1401      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1402      * Can only be called by the current owner.
1403      */
1404     function transferOwnership(address newOwner) public virtual onlyOwner {
1405         require(newOwner != address(0), "Ownable: new owner is the zero address");
1406         _transferOwnership(newOwner);
1407     }
1408 
1409     /**
1410      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1411      * Internal function without access restriction.
1412      */
1413     function _transferOwnership(address newOwner) internal virtual {
1414         address oldOwner = _owner;
1415         _owner = newOwner;
1416         emit OwnershipTransferred(oldOwner, newOwner);
1417     }
1418 }
1419 
1420 // File: contracts/hashimotocat.sol
1421 
1422 
1423 
1424 pragma solidity ^0.8.4;
1425 
1426 
1427 
1428 
1429 
1430 contract HashimotoCat is Ownable, ERC721A, ReentrancyGuard {
1431     mapping(address => uint256) public minted;
1432 
1433     constructor() ERC721A("Hashimotocat", "HSMT-CAT") {
1434         hashimotocatConfig.pause = false;
1435         hashimotocatConfig.price = 10000000000000000;
1436         hashimotocatConfig.maxMint = 5;
1437         hashimotocatConfig.maxSupply = 10000;
1438     }
1439 
1440     struct HashimotocatConfig {
1441         bool pause;
1442         uint256 price;
1443         uint256 maxMint;
1444         uint256 maxSupply;
1445     }
1446     HashimotocatConfig public hashimotocatConfig;
1447 
1448     function mint(uint256 quantity) external payable {
1449         HashimotocatConfig memory config = hashimotocatConfig;
1450         bool pause = bool(config.pause);
1451         uint256 price = uint256(config.price);
1452         uint256 maxMint = uint256(config.maxMint);
1453         uint256 buyed = getAddressBuyed(msg.sender);
1454 
1455         require(
1456             !pause,
1457             "Mint paused."
1458         );
1459 
1460         require(
1461             totalSupply() + quantity <= getMaxSupply(),
1462             "No more hashimoto cat."
1463         );
1464     
1465         require(
1466             buyed + quantity <= maxMint,
1467             "Exceed maxmium mint."
1468         );
1469 
1470         bool requirePay = ( quantity > 1 || buyed > 0 ) ? true : false;
1471         if (requirePay) {
1472             uint256 freeQuota = buyed == 0 ? 1 : 0;
1473             uint256 finalPrice = (quantity - freeQuota) * price;
1474             
1475             require(
1476                 finalPrice <= msg.value,
1477                 "No enough eth."
1478             );
1479         }
1480 
1481         _safeMint(msg.sender, quantity);
1482         minted[msg.sender] += quantity;
1483     }
1484 
1485     function makeHashimotocat(uint256 quantity) external onlyOwner {
1486         require(
1487             totalSupply() + quantity <= getMaxSupply(),
1488             "No more hashimoto cat."
1489         );
1490 
1491         _safeMint(msg.sender, quantity);
1492     }
1493 
1494     function getAddressBuyed(address owner) public view returns (uint256) {
1495         return minted[owner];
1496     }
1497     
1498     function getMaxSupply() private view returns (uint256) {
1499         HashimotocatConfig memory config = hashimotocatConfig;
1500         uint256 max = uint256(config.maxSupply);
1501         return max;
1502     }
1503 
1504     string private _baseTokenURI;
1505 
1506     function _baseURI() internal view virtual override returns (string memory) {
1507         return _baseTokenURI;
1508     }
1509 
1510     function setURI(string calldata baseURI) external onlyOwner {
1511         _baseTokenURI = baseURI;
1512     }
1513 
1514     function setPrice(uint256 _price) external onlyOwner {
1515         hashimotocatConfig.price = _price;
1516     }
1517 
1518     function setPause(bool _pause) external onlyOwner {
1519         hashimotocatConfig.pause = _pause;
1520     }
1521 
1522     function withdraw() external onlyOwner nonReentrant {
1523         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1524         require(success, "a");
1525     }
1526 }