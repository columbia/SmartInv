1 // SPDX-License-Identifier: MIT
2 
3 //    _____                      _____              
4 //   / ____|                    |  __ \             
5 //  | (___  _ __   __ _  ___ ___| |__) |_ _ ___ ___ 
6 //   \___ \| '_ \ / _` |/ __/ _ \  ___/ _` / __/ __|
7 //   ____) | |_) | (_| | (_|  __/ |  | (_| \__ \__ \
8 //  |_____/| .__/ \__,_|\___\___|_|   \__,_|___/___/
9 //         | |                                      
10 //         |_|                                      
11 // @author PlaguedLabs (plaguedlabs@gmail.com)
12 
13 // File: erc721a/contracts/IERC721A.sol
14 
15 
16 // ERC721A Contracts v4.0.0
17 // Creator: Chiru Labs
18 
19 pragma solidity ^0.8.4;
20 
21 /**
22  * @dev Interface of an ERC721A compliant contract.
23  */
24 interface IERC721A {
25     /**
26      * The caller must own the token or be an approved operator.
27      */
28     error ApprovalCallerNotOwnerNorApproved();
29 
30     /**
31      * The token does not exist.
32      */
33     error ApprovalQueryForNonexistentToken();
34 
35     /**
36      * The caller cannot approve to their own address.
37      */
38     error ApproveToCaller();
39 
40     /**
41      * The caller cannot approve to the current owner.
42      */
43     error ApprovalToCurrentOwner();
44 
45     /**
46      * Cannot query the balance for the zero address.
47      */
48     error BalanceQueryForZeroAddress();
49 
50     /**
51      * Cannot mint to the zero address.
52      */
53     error MintToZeroAddress();
54 
55     /**
56      * The quantity of tokens minted must be more than zero.
57      */
58     error MintZeroQuantity();
59 
60     /**
61      * The token does not exist.
62      */
63     error OwnerQueryForNonexistentToken();
64 
65     /**
66      * The caller must own the token or be an approved operator.
67      */
68     error TransferCallerNotOwnerNorApproved();
69 
70     /**
71      * The token must be owned by `from`.
72      */
73     error TransferFromIncorrectOwner();
74 
75     /**
76      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
77      */
78     error TransferToNonERC721ReceiverImplementer();
79 
80     /**
81      * Cannot transfer to the zero address.
82      */
83     error TransferToZeroAddress();
84 
85     /**
86      * The token does not exist.
87      */
88     error URIQueryForNonexistentToken();
89 
90     struct TokenOwnership {
91         // The address of the owner.
92         address addr;
93         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
94         uint64 startTimestamp;
95         // Whether the token has been burned.
96         bool burned;
97     }
98 
99     /**
100      * @dev Returns the total amount of tokens stored by the contract.
101      *
102      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
103      */
104     function totalSupply() external view returns (uint256);
105 
106     // ==============================
107     //            IERC165
108     // ==============================
109 
110     /**
111      * @dev Returns true if this contract implements the interface defined by
112      * `interfaceId`. See the corresponding
113      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
114      * to learn more about how these ids are created.
115      *
116      * This function call must use less than 30 000 gas.
117      */
118     function supportsInterface(bytes4 interfaceId) external view returns (bool);
119 
120     // ==============================
121     //            IERC721
122     // ==============================
123 
124     /**
125      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
126      */
127     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
128 
129     /**
130      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
131      */
132     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
133 
134     /**
135      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
136      */
137     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
138 
139     /**
140      * @dev Returns the number of tokens in ``owner``'s account.
141      */
142     function balanceOf(address owner) external view returns (uint256 balance);
143 
144     /**
145      * @dev Returns the owner of the `tokenId` token.
146      *
147      * Requirements:
148      *
149      * - `tokenId` must exist.
150      */
151     function ownerOf(uint256 tokenId) external view returns (address owner);
152 
153     /**
154      * @dev Safely transfers `tokenId` token from `from` to `to`.
155      *
156      * Requirements:
157      *
158      * - `from` cannot be the zero address.
159      * - `to` cannot be the zero address.
160      * - `tokenId` token must exist and be owned by `from`.
161      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
162      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
163      *
164      * Emits a {Transfer} event.
165      */
166     function safeTransferFrom(
167         address from,
168         address to,
169         uint256 tokenId,
170         bytes calldata data
171     ) external;
172 
173     /**
174      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
175      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
176      *
177      * Requirements:
178      *
179      * - `from` cannot be the zero address.
180      * - `to` cannot be the zero address.
181      * - `tokenId` token must exist and be owned by `from`.
182      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
183      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
184      *
185      * Emits a {Transfer} event.
186      */
187     function safeTransferFrom(
188         address from,
189         address to,
190         uint256 tokenId
191     ) external;
192 
193     /**
194      * @dev Transfers `tokenId` token from `from` to `to`.
195      *
196      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
197      *
198      * Requirements:
199      *
200      * - `from` cannot be the zero address.
201      * - `to` cannot be the zero address.
202      * - `tokenId` token must be owned by `from`.
203      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
204      *
205      * Emits a {Transfer} event.
206      */
207     function transferFrom(
208         address from,
209         address to,
210         uint256 tokenId
211     ) external;
212 
213     /**
214      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
215      * The approval is cleared when the token is transferred.
216      *
217      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
218      *
219      * Requirements:
220      *
221      * - The caller must own the token or be an approved operator.
222      * - `tokenId` must exist.
223      *
224      * Emits an {Approval} event.
225      */
226     function approve(address to, uint256 tokenId) external;
227 
228     /**
229      * @dev Approve or remove `operator` as an operator for the caller.
230      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
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
252      * See {setApprovalForAll}
253      */
254     function isApprovedForAll(address owner, address operator) external view returns (bool);
255 
256     // ==============================
257     //        IERC721Metadata
258     // ==============================
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
274 }
275 
276 // File: erc721a/contracts/ERC721A.sol
277 
278 
279 // ERC721A Contracts v4.0.0
280 // Creator: Chiru Labs
281 
282 pragma solidity ^0.8.4;
283 
284 
285 /**
286  * @dev ERC721 token receiver interface.
287  */
288 interface ERC721A__IERC721Receiver {
289     function onERC721Received(
290         address operator,
291         address from,
292         uint256 tokenId,
293         bytes calldata data
294     ) external returns (bytes4);
295 }
296 
297 /**
298  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
299  * the Metadata extension. Built to optimize for lower gas during batch mints.
300  *
301  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
302  *
303  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
304  *
305  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
306  */
307 contract ERC721A is IERC721A {
308     // Mask of an entry in packed address data.
309     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
310 
311     // The bit position of `numberMinted` in packed address data.
312     uint256 private constant BITPOS_NUMBER_MINTED = 64;
313 
314     // The bit position of `numberBurned` in packed address data.
315     uint256 private constant BITPOS_NUMBER_BURNED = 128;
316 
317     // The bit position of `aux` in packed address data.
318     uint256 private constant BITPOS_AUX = 192;
319 
320     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
321     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
322 
323     // The bit position of `startTimestamp` in packed ownership.
324     uint256 private constant BITPOS_START_TIMESTAMP = 160;
325 
326     // The bit mask of the `burned` bit in packed ownership.
327     uint256 private constant BITMASK_BURNED = 1 << 224;
328     
329     // The bit position of the `nextInitialized` bit in packed ownership.
330     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
331 
332     // The bit mask of the `nextInitialized` bit in packed ownership.
333     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
334 
335     // The tokenId of the next token to be minted.
336     uint256 private _currentIndex;
337 
338     // The number of tokens burned.
339     uint256 private _burnCounter;
340 
341     // Token name
342     string private _name;
343 
344     // Token symbol
345     string private _symbol;
346 
347     // Mapping from token ID to ownership details
348     // An empty struct value does not necessarily mean the token is unowned.
349     // See `_packedOwnershipOf` implementation for details.
350     //
351     // Bits Layout:
352     // - [0..159]   `addr`
353     // - [160..223] `startTimestamp`
354     // - [224]      `burned`
355     // - [225]      `nextInitialized`
356     mapping(uint256 => uint256) private _packedOwnerships;
357 
358     // Mapping owner address to address data.
359     //
360     // Bits Layout:
361     // - [0..63]    `balance`
362     // - [64..127]  `numberMinted`
363     // - [128..191] `numberBurned`
364     // - [192..255] `aux`
365     mapping(address => uint256) private _packedAddressData;
366 
367     // Mapping from token ID to approved address.
368     mapping(uint256 => address) private _tokenApprovals;
369 
370     // Mapping from owner to operator approvals
371     mapping(address => mapping(address => bool)) private _operatorApprovals;
372 
373     constructor(string memory name_, string memory symbol_) {
374         _name = name_;
375         _symbol = symbol_;
376         _currentIndex = _startTokenId();
377     }
378 
379     /**
380      * @dev Returns the starting token ID. 
381      * To change the starting token ID, please override this function.
382      */
383     function _startTokenId() internal view virtual returns (uint256) {
384         return 0;
385     }
386 
387     /**
388      * @dev Returns the next token ID to be minted.
389      */
390     function _nextTokenId() internal view returns (uint256) {
391         return _currentIndex;
392     }
393 
394     /**
395      * @dev Returns the total number of tokens in existence.
396      * Burned tokens will reduce the count. 
397      * To get the total number of tokens minted, please see `_totalMinted`.
398      */
399     function totalSupply() public view override returns (uint256) {
400         // Counter underflow is impossible as _burnCounter cannot be incremented
401         // more than `_currentIndex - _startTokenId()` times.
402         unchecked {
403             return _currentIndex - _burnCounter - _startTokenId();
404         }
405     }
406 
407     /**
408      * @dev Returns the total amount of tokens minted in the contract.
409      */
410     function _totalMinted() internal view returns (uint256) {
411         // Counter underflow is impossible as _currentIndex does not decrement,
412         // and it is initialized to `_startTokenId()`
413         unchecked {
414             return _currentIndex - _startTokenId();
415         }
416     }
417 
418     /**
419      * @dev Returns the total number of tokens burned.
420      */
421     function _totalBurned() internal view returns (uint256) {
422         return _burnCounter;
423     }
424 
425     /**
426      * @dev See {IERC165-supportsInterface}.
427      */
428     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
429         // The interface IDs are constants representing the first 4 bytes of the XOR of
430         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
431         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
432         return
433             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
434             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
435             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
436     }
437 
438     /**
439      * @dev See {IERC721-balanceOf}.
440      */
441     function balanceOf(address owner) public view override returns (uint256) {
442         if (owner == address(0)) revert BalanceQueryForZeroAddress();
443         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
444     }
445 
446     /**
447      * Returns the number of tokens minted by `owner`.
448      */
449     function _numberMinted(address owner) internal view returns (uint256) {
450         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
451     }
452 
453     /**
454      * Returns the number of tokens burned by or on behalf of `owner`.
455      */
456     function _numberBurned(address owner) internal view returns (uint256) {
457         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
458     }
459 
460     /**
461      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
462      */
463     function _getAux(address owner) internal view returns (uint64) {
464         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
465     }
466 
467     /**
468      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
469      * If there are multiple variables, please pack them into a uint64.
470      */
471     function _setAux(address owner, uint64 aux) internal {
472         uint256 packed = _packedAddressData[owner];
473         uint256 auxCasted;
474         assembly { // Cast aux without masking.
475             auxCasted := aux
476         }
477         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
478         _packedAddressData[owner] = packed;
479     }
480 
481     /**
482      * Returns the packed ownership data of `tokenId`.
483      */
484     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
485         uint256 curr = tokenId;
486 
487         unchecked {
488             if (_startTokenId() <= curr)
489                 if (curr < _currentIndex) {
490                     uint256 packed = _packedOwnerships[curr];
491                     // If not burned.
492                     if (packed & BITMASK_BURNED == 0) {
493                         // Invariant:
494                         // There will always be an ownership that has an address and is not burned
495                         // before an ownership that does not have an address and is not burned.
496                         // Hence, curr will not underflow.
497                         //
498                         // We can directly compare the packed value.
499                         // If the address is zero, packed is zero.
500                         while (packed == 0) {
501                             packed = _packedOwnerships[--curr];
502                         }
503                         return packed;
504                     }
505                 }
506         }
507         revert OwnerQueryForNonexistentToken();
508     }
509 
510     /**
511      * Returns the unpacked `TokenOwnership` struct from `packed`.
512      */
513     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
514         ownership.addr = address(uint160(packed));
515         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
516         ownership.burned = packed & BITMASK_BURNED != 0;
517     }
518 
519     /**
520      * Returns the unpacked `TokenOwnership` struct at `index`.
521      */
522     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
523         return _unpackedOwnership(_packedOwnerships[index]);
524     }
525 
526     /**
527      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
528      */
529     function _initializeOwnershipAt(uint256 index) internal {
530         if (_packedOwnerships[index] == 0) {
531             _packedOwnerships[index] = _packedOwnershipOf(index);
532         }
533     }
534 
535     /**
536      * Gas spent here starts off proportional to the maximum mint batch size.
537      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
538      */
539     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
540         return _unpackedOwnership(_packedOwnershipOf(tokenId));
541     }
542 
543     /**
544      * @dev See {IERC721-ownerOf}.
545      */
546     function ownerOf(uint256 tokenId) public view override returns (address) {
547         return address(uint160(_packedOwnershipOf(tokenId)));
548     }
549 
550     /**
551      * @dev See {IERC721Metadata-name}.
552      */
553     function name() public view virtual override returns (string memory) {
554         return _name;
555     }
556 
557     /**
558      * @dev See {IERC721Metadata-symbol}.
559      */
560     function symbol() public view virtual override returns (string memory) {
561         return _symbol;
562     }
563 
564     /**
565      * @dev See {IERC721Metadata-tokenURI}.
566      */
567     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
568         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
569 
570         string memory baseURI = _baseURI();
571         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
572     }
573 
574     /**
575      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
576      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
577      * by default, can be overriden in child contracts.
578      */
579     function _baseURI() internal view virtual returns (string memory) {
580         return '';
581     }
582 
583     /**
584      * @dev Casts the address to uint256 without masking.
585      */
586     function _addressToUint256(address value) private pure returns (uint256 result) {
587         assembly {
588             result := value
589         }
590     }
591 
592     /**
593      * @dev Casts the boolean to uint256 without branching.
594      */
595     function _boolToUint256(bool value) private pure returns (uint256 result) {
596         assembly {
597             result := value
598         }
599     }
600 
601     /**
602      * @dev See {IERC721-approve}.
603      */
604     function approve(address to, uint256 tokenId) public override {
605         address owner = address(uint160(_packedOwnershipOf(tokenId)));
606         if (to == owner) revert ApprovalToCurrentOwner();
607 
608         if (_msgSenderERC721A() != owner)
609             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
610                 revert ApprovalCallerNotOwnerNorApproved();
611             }
612 
613         _tokenApprovals[tokenId] = to;
614         emit Approval(owner, to, tokenId);
615     }
616 
617     /**
618      * @dev See {IERC721-getApproved}.
619      */
620     function getApproved(uint256 tokenId) public view override returns (address) {
621         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
622 
623         return _tokenApprovals[tokenId];
624     }
625 
626     /**
627      * @dev See {IERC721-setApprovalForAll}.
628      */
629     function setApprovalForAll(address operator, bool approved) public virtual override {
630         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
631 
632         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
633         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
634     }
635 
636     /**
637      * @dev See {IERC721-isApprovedForAll}.
638      */
639     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
640         return _operatorApprovals[owner][operator];
641     }
642 
643     /**
644      * @dev See {IERC721-transferFrom}.
645      */
646     function transferFrom(
647         address from,
648         address to,
649         uint256 tokenId
650     ) public virtual override {
651         _transfer(from, to, tokenId);
652     }
653 
654     /**
655      * @dev See {IERC721-safeTransferFrom}.
656      */
657     function safeTransferFrom(
658         address from,
659         address to,
660         uint256 tokenId
661     ) public virtual override {
662         safeTransferFrom(from, to, tokenId, '');
663     }
664 
665     /**
666      * @dev See {IERC721-safeTransferFrom}.
667      */
668     function safeTransferFrom(
669         address from,
670         address to,
671         uint256 tokenId,
672         bytes memory _data
673     ) public virtual override {
674         _transfer(from, to, tokenId);
675         if (to.code.length != 0)
676             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
677                 revert TransferToNonERC721ReceiverImplementer();
678             }
679     }
680 
681     /**
682      * @dev Returns whether `tokenId` exists.
683      *
684      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
685      *
686      * Tokens start existing when they are minted (`_mint`),
687      */
688     function _exists(uint256 tokenId) internal view returns (bool) {
689         return
690             _startTokenId() <= tokenId &&
691             tokenId < _currentIndex && // If within bounds,
692             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
693     }
694 
695     /**
696      * @dev Equivalent to `_safeMint(to, quantity, '')`.
697      */
698     function _safeMint(address to, uint256 quantity) internal {
699         _safeMint(to, quantity, '');
700     }
701 
702     /**
703      * @dev Safely mints `quantity` tokens and transfers them to `to`.
704      *
705      * Requirements:
706      *
707      * - If `to` refers to a smart contract, it must implement
708      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
709      * - `quantity` must be greater than 0.
710      *
711      * Emits a {Transfer} event.
712      */
713     function _safeMint(
714         address to,
715         uint256 quantity,
716         bytes memory _data
717     ) internal {
718         uint256 startTokenId = _currentIndex;
719         if (to == address(0)) revert MintToZeroAddress();
720         if (quantity == 0) revert MintZeroQuantity();
721 
722         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
723 
724         // Overflows are incredibly unrealistic.
725         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
726         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
727         unchecked {
728             // Updates:
729             // - `balance += quantity`.
730             // - `numberMinted += quantity`.
731             //
732             // We can directly add to the balance and number minted.
733             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
734 
735             // Updates:
736             // - `address` to the owner.
737             // - `startTimestamp` to the timestamp of minting.
738             // - `burned` to `false`.
739             // - `nextInitialized` to `quantity == 1`.
740             _packedOwnerships[startTokenId] =
741                 _addressToUint256(to) |
742                 (block.timestamp << BITPOS_START_TIMESTAMP) |
743                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
744 
745             uint256 updatedIndex = startTokenId;
746             uint256 end = updatedIndex + quantity;
747 
748             if (to.code.length != 0) {
749                 do {
750                     emit Transfer(address(0), to, updatedIndex);
751                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
752                         revert TransferToNonERC721ReceiverImplementer();
753                     }
754                 } while (updatedIndex < end);
755                 // Reentrancy protection
756                 if (_currentIndex != startTokenId) revert();
757             } else {
758                 do {
759                     emit Transfer(address(0), to, updatedIndex++);
760                 } while (updatedIndex < end);
761             }
762             _currentIndex = updatedIndex;
763         }
764         _afterTokenTransfers(address(0), to, startTokenId, quantity);
765     }
766 
767     /**
768      * @dev Mints `quantity` tokens and transfers them to `to`.
769      *
770      * Requirements:
771      *
772      * - `to` cannot be the zero address.
773      * - `quantity` must be greater than 0.
774      *
775      * Emits a {Transfer} event.
776      */
777     function _mint(address to, uint256 quantity) internal {
778         uint256 startTokenId = _currentIndex;
779         if (to == address(0)) revert MintToZeroAddress();
780         if (quantity == 0) revert MintZeroQuantity();
781 
782         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
783 
784         // Overflows are incredibly unrealistic.
785         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
786         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
787         unchecked {
788             // Updates:
789             // - `balance += quantity`.
790             // - `numberMinted += quantity`.
791             //
792             // We can directly add to the balance and number minted.
793             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
794 
795             // Updates:
796             // - `address` to the owner.
797             // - `startTimestamp` to the timestamp of minting.
798             // - `burned` to `false`.
799             // - `nextInitialized` to `quantity == 1`.
800             _packedOwnerships[startTokenId] =
801                 _addressToUint256(to) |
802                 (block.timestamp << BITPOS_START_TIMESTAMP) |
803                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
804 
805             uint256 updatedIndex = startTokenId;
806             uint256 end = updatedIndex + quantity;
807 
808             do {
809                 emit Transfer(address(0), to, updatedIndex++);
810             } while (updatedIndex < end);
811 
812             _currentIndex = updatedIndex;
813         }
814         _afterTokenTransfers(address(0), to, startTokenId, quantity);
815     }
816 
817     /**
818      * @dev Transfers `tokenId` from `from` to `to`.
819      *
820      * Requirements:
821      *
822      * - `to` cannot be the zero address.
823      * - `tokenId` token must be owned by `from`.
824      *
825      * Emits a {Transfer} event.
826      */
827     function _transfer(
828         address from,
829         address to,
830         uint256 tokenId
831     ) private {
832         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
833 
834         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
835 
836         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
837             isApprovedForAll(from, _msgSenderERC721A()) ||
838             getApproved(tokenId) == _msgSenderERC721A());
839 
840         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
841         if (to == address(0)) revert TransferToZeroAddress();
842 
843         _beforeTokenTransfers(from, to, tokenId, 1);
844 
845         // Clear approvals from the previous owner.
846         delete _tokenApprovals[tokenId];
847 
848         // Underflow of the sender's balance is impossible because we check for
849         // ownership above and the recipient's balance can't realistically overflow.
850         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
851         unchecked {
852             // We can directly increment and decrement the balances.
853             --_packedAddressData[from]; // Updates: `balance -= 1`.
854             ++_packedAddressData[to]; // Updates: `balance += 1`.
855 
856             // Updates:
857             // - `address` to the next owner.
858             // - `startTimestamp` to the timestamp of transfering.
859             // - `burned` to `false`.
860             // - `nextInitialized` to `true`.
861             _packedOwnerships[tokenId] =
862                 _addressToUint256(to) |
863                 (block.timestamp << BITPOS_START_TIMESTAMP) |
864                 BITMASK_NEXT_INITIALIZED;
865 
866             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
867             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
868                 uint256 nextTokenId = tokenId + 1;
869                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
870                 if (_packedOwnerships[nextTokenId] == 0) {
871                     // If the next slot is within bounds.
872                     if (nextTokenId != _currentIndex) {
873                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
874                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
875                     }
876                 }
877             }
878         }
879 
880         emit Transfer(from, to, tokenId);
881         _afterTokenTransfers(from, to, tokenId, 1);
882     }
883 
884     /**
885      * @dev Equivalent to `_burn(tokenId, false)`.
886      */
887     function _burn(uint256 tokenId) internal virtual {
888         _burn(tokenId, false);
889     }
890 
891     /**
892      * @dev Destroys `tokenId`.
893      * The approval is cleared when the token is burned.
894      *
895      * Requirements:
896      *
897      * - `tokenId` must exist.
898      *
899      * Emits a {Transfer} event.
900      */
901     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
902         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
903 
904         address from = address(uint160(prevOwnershipPacked));
905 
906         if (approvalCheck) {
907             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
908                 isApprovedForAll(from, _msgSenderERC721A()) ||
909                 getApproved(tokenId) == _msgSenderERC721A());
910 
911             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
912         }
913 
914         _beforeTokenTransfers(from, address(0), tokenId, 1);
915 
916         // Clear approvals from the previous owner.
917         delete _tokenApprovals[tokenId];
918 
919         // Underflow of the sender's balance is impossible because we check for
920         // ownership above and the recipient's balance can't realistically overflow.
921         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
922         unchecked {
923             // Updates:
924             // - `balance -= 1`.
925             // - `numberBurned += 1`.
926             //
927             // We can directly decrement the balance, and increment the number burned.
928             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
929             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
930 
931             // Updates:
932             // - `address` to the last owner.
933             // - `startTimestamp` to the timestamp of burning.
934             // - `burned` to `true`.
935             // - `nextInitialized` to `true`.
936             _packedOwnerships[tokenId] =
937                 _addressToUint256(from) |
938                 (block.timestamp << BITPOS_START_TIMESTAMP) |
939                 BITMASK_BURNED | 
940                 BITMASK_NEXT_INITIALIZED;
941 
942             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
943             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
944                 uint256 nextTokenId = tokenId + 1;
945                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
946                 if (_packedOwnerships[nextTokenId] == 0) {
947                     // If the next slot is within bounds.
948                     if (nextTokenId != _currentIndex) {
949                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
950                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
951                     }
952                 }
953             }
954         }
955 
956         emit Transfer(from, address(0), tokenId);
957         _afterTokenTransfers(from, address(0), tokenId, 1);
958 
959         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
960         unchecked {
961             _burnCounter++;
962         }
963     }
964 
965     /**
966      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
967      *
968      * @param from address representing the previous owner of the given token ID
969      * @param to target address that will receive the tokens
970      * @param tokenId uint256 ID of the token to be transferred
971      * @param _data bytes optional data to send along with the call
972      * @return bool whether the call correctly returned the expected magic value
973      */
974     function _checkContractOnERC721Received(
975         address from,
976         address to,
977         uint256 tokenId,
978         bytes memory _data
979     ) private returns (bool) {
980         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
981             bytes4 retval
982         ) {
983             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
984         } catch (bytes memory reason) {
985             if (reason.length == 0) {
986                 revert TransferToNonERC721ReceiverImplementer();
987             } else {
988                 assembly {
989                     revert(add(32, reason), mload(reason))
990                 }
991             }
992         }
993     }
994 
995     /**
996      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
997      * And also called before burning one token.
998      *
999      * startTokenId - the first token id to be transferred
1000      * quantity - the amount to be transferred
1001      *
1002      * Calling conditions:
1003      *
1004      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1005      * transferred to `to`.
1006      * - When `from` is zero, `tokenId` will be minted for `to`.
1007      * - When `to` is zero, `tokenId` will be burned by `from`.
1008      * - `from` and `to` are never both zero.
1009      */
1010     function _beforeTokenTransfers(
1011         address from,
1012         address to,
1013         uint256 startTokenId,
1014         uint256 quantity
1015     ) internal virtual {}
1016 
1017     /**
1018      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1019      * minting.
1020      * And also called after one token has been burned.
1021      *
1022      * startTokenId - the first token id to be transferred
1023      * quantity - the amount to be transferred
1024      *
1025      * Calling conditions:
1026      *
1027      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1028      * transferred to `to`.
1029      * - When `from` is zero, `tokenId` has been minted for `to`.
1030      * - When `to` is zero, `tokenId` has been burned by `from`.
1031      * - `from` and `to` are never both zero.
1032      */
1033     function _afterTokenTransfers(
1034         address from,
1035         address to,
1036         uint256 startTokenId,
1037         uint256 quantity
1038     ) internal virtual {}
1039 
1040     /**
1041      * @dev Returns the message sender (defaults to `msg.sender`).
1042      *
1043      * If you are writing GSN compatible contracts, you need to override this function.
1044      */
1045     function _msgSenderERC721A() internal view virtual returns (address) {
1046         return msg.sender;
1047     }
1048 
1049     /**
1050      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1051      */
1052     function _toString(uint256 value) internal pure returns (string memory ptr) {
1053         assembly {
1054             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1055             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1056             // We will need 1 32-byte word to store the length, 
1057             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1058             ptr := add(mload(0x40), 128)
1059             // Update the free memory pointer to allocate.
1060             mstore(0x40, ptr)
1061 
1062             // Cache the end of the memory to calculate the length later.
1063             let end := ptr
1064 
1065             // We write the string from the rightmost digit to the leftmost digit.
1066             // The following is essentially a do-while loop that also handles the zero case.
1067             // Costs a bit more than early returning for the zero case,
1068             // but cheaper in terms of deployment and overall runtime costs.
1069             for { 
1070                 // Initialize and perform the first pass without check.
1071                 let temp := value
1072                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1073                 ptr := sub(ptr, 1)
1074                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1075                 mstore8(ptr, add(48, mod(temp, 10)))
1076                 temp := div(temp, 10)
1077             } temp { 
1078                 // Keep dividing `temp` until zero.
1079                 temp := div(temp, 10)
1080             } { // Body of the for loop.
1081                 ptr := sub(ptr, 1)
1082                 mstore8(ptr, add(48, mod(temp, 10)))
1083             }
1084             
1085             let length := sub(end, ptr)
1086             // Move the pointer 32 bytes leftwards to make room for the length.
1087             ptr := sub(ptr, 32)
1088             // Store the length.
1089             mstore(ptr, length)
1090         }
1091     }
1092 }
1093 
1094 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
1095 
1096 
1097 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
1098 
1099 pragma solidity ^0.8.0;
1100 
1101 /**
1102  * @dev These functions deal with verification of Merkle Trees proofs.
1103  *
1104  * The proofs can be generated using the JavaScript library
1105  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1106  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1107  *
1108  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1109  *
1110  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1111  * hashing, or use a hash function other than keccak256 for hashing leaves.
1112  * This is because the concatenation of a sorted pair of internal nodes in
1113  * the merkle tree could be reinterpreted as a leaf value.
1114  */
1115 library MerkleProof {
1116     /**
1117      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1118      * defined by `root`. For this, a `proof` must be provided, containing
1119      * sibling hashes on the branch from the leaf to the root of the tree. Each
1120      * pair of leaves and each pair of pre-images are assumed to be sorted.
1121      */
1122     function verify(
1123         bytes32[] memory proof,
1124         bytes32 root,
1125         bytes32 leaf
1126     ) internal pure returns (bool) {
1127         return processProof(proof, leaf) == root;
1128     }
1129 
1130     /**
1131      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1132      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1133      * hash matches the root of the tree. When processing the proof, the pairs
1134      * of leafs & pre-images are assumed to be sorted.
1135      *
1136      * _Available since v4.4._
1137      */
1138     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1139         bytes32 computedHash = leaf;
1140         for (uint256 i = 0; i < proof.length; i++) {
1141             bytes32 proofElement = proof[i];
1142             if (computedHash <= proofElement) {
1143                 // Hash(current computed hash + current element of the proof)
1144                 computedHash = _efficientHash(computedHash, proofElement);
1145             } else {
1146                 // Hash(current element of the proof + current computed hash)
1147                 computedHash = _efficientHash(proofElement, computedHash);
1148             }
1149         }
1150         return computedHash;
1151     }
1152 
1153     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1154         assembly {
1155             mstore(0x00, a)
1156             mstore(0x20, b)
1157             value := keccak256(0x00, 0x40)
1158         }
1159     }
1160 }
1161 
1162 // File: @openzeppelin/contracts/utils/Context.sol
1163 
1164 
1165 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1166 
1167 pragma solidity ^0.8.0;
1168 
1169 /**
1170  * @dev Provides information about the current execution context, including the
1171  * sender of the transaction and its data. While these are generally available
1172  * via msg.sender and msg.data, they should not be accessed in such a direct
1173  * manner, since when dealing with meta-transactions the account sending and
1174  * paying for execution may not be the actual sender (as far as an application
1175  * is concerned).
1176  *
1177  * This contract is only required for intermediate, library-like contracts.
1178  */
1179 abstract contract Context {
1180     function _msgSender() internal view virtual returns (address) {
1181         return msg.sender;
1182     }
1183 
1184     function _msgData() internal view virtual returns (bytes calldata) {
1185         return msg.data;
1186     }
1187 }
1188 
1189 // File: @openzeppelin/contracts/access/Ownable.sol
1190 
1191 
1192 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1193 
1194 pragma solidity ^0.8.0;
1195 
1196 
1197 /**
1198  * @dev Contract module which provides a basic access control mechanism, where
1199  * there is an account (an owner) that can be granted exclusive access to
1200  * specific functions.
1201  *
1202  * By default, the owner account will be the one that deploys the contract. This
1203  * can later be changed with {transferOwnership}.
1204  *
1205  * This module is used through inheritance. It will make available the modifier
1206  * `onlyOwner`, which can be applied to your functions to restrict their use to
1207  * the owner.
1208  */
1209 abstract contract Ownable is Context {
1210     address private _owner;
1211 
1212     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1213 
1214     /**
1215      * @dev Initializes the contract setting the deployer as the initial owner.
1216      */
1217     constructor() {
1218         _transferOwnership(_msgSender());
1219     }
1220 
1221     /**
1222      * @dev Returns the address of the current owner.
1223      */
1224     function owner() public view virtual returns (address) {
1225         return _owner;
1226     }
1227 
1228     /**
1229      * @dev Throws if called by any account other than the owner.
1230      */
1231     modifier onlyOwner() {
1232         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1233         _;
1234     }
1235 
1236     /**
1237      * @dev Leaves the contract without owner. It will not be possible to call
1238      * `onlyOwner` functions anymore. Can only be called by the current owner.
1239      *
1240      * NOTE: Renouncing ownership will leave the contract without an owner,
1241      * thereby removing any functionality that is only available to the owner.
1242      */
1243     function renounceOwnership() public virtual onlyOwner {
1244         _transferOwnership(address(0));
1245     }
1246 
1247     /**
1248      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1249      * Can only be called by the current owner.
1250      */
1251     function transferOwnership(address newOwner) public virtual onlyOwner {
1252         require(newOwner != address(0), "Ownable: new owner is the zero address");
1253         _transferOwnership(newOwner);
1254     }
1255 
1256     /**
1257      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1258      * Internal function without access restriction.
1259      */
1260     function _transferOwnership(address newOwner) internal virtual {
1261         address oldOwner = _owner;
1262         _owner = newOwner;
1263         emit OwnershipTransferred(oldOwner, newOwner);
1264     }
1265 }
1266 
1267 // File: spacepass.sol
1268 
1269 
1270 pragma solidity >=0.7.0 <0.9.0;
1271 
1272 
1273 
1274 
1275 //    _____                      _____              
1276 //   / ____|                    |  __ \             
1277 //  | (___  _ __   __ _  ___ ___| |__) |_ _ ___ ___ 
1278 //   \___ \| '_ \ / _` |/ __/ _ \  ___/ _` / __/ __|
1279 //   ____) | |_) | (_| | (_|  __/ |  | (_| \__ \__ \
1280 //  |_____/| .__/ \__,_|\___\___|_|   \__,_|___/___/
1281 //         | |                                      
1282 //         |_|                                      
1283 /// @author PlaguedLabs (plaguedlabs@gmail.com)
1284 
1285 struct PresaleConfig {
1286   uint32 startTime;
1287   uint32 endTime;
1288   uint256 whitelistMaxSupply;
1289   uint256 whitelistPrice;
1290 }
1291 
1292 contract SpacePass is ERC721A, Ownable {
1293 
1294     /// ERRORS ///
1295     error ContractMint();
1296     error OutOfSupply();
1297     error ExceedsTxnLimit();
1298     error ExceedsWalletLimit();
1299     error InsufficientFunds();
1300     
1301     error MintPaused();
1302     error MintInactive();
1303     error InvalidProof();
1304 
1305     bytes32 public merkleRoot;
1306 
1307     string public baseURI;
1308     
1309     uint32 publicSaleStartTime;
1310 
1311     uint256 public PRICE = 0.01 ether;
1312     uint256 public SUPPLY_MAX = 555;
1313 
1314     PresaleConfig public presaleConfig;
1315 
1316     bool public presalePaused;
1317     bool public publicSalePaused;
1318     bool public revealed;
1319 
1320     mapping(address => bool) public publicWalletMinted;
1321 
1322     constructor() ERC721A("Space Pass", "SpacePass") payable {
1323         presaleConfig = PresaleConfig({
1324             startTime: 1654981200, // JULY 11 5:00:00 PM EST
1325             endTime: 1654983000,   // JULY 11 5:30:00 PM EST
1326             whitelistMaxSupply: 107,
1327             whitelistPrice: 0.005 ether
1328         });
1329         publicSaleStartTime = 1654983300; // July 11 5:35:00 PM EST
1330     }
1331 
1332     modifier mintCompliance() {
1333         if (msg.sender != tx.origin) revert ContractMint();
1334         if ((totalSupply() + 1) > SUPPLY_MAX) revert OutOfSupply();
1335         _;
1336     }
1337 
1338     function presaleMint(bytes32[] calldata _merkleProof)
1339         external
1340         payable
1341         mintCompliance 
1342     {
1343         PresaleConfig memory config_ = presaleConfig;
1344         
1345         if (presalePaused) revert MintPaused();
1346         unchecked {
1347             if (block.timestamp < config_.startTime || block.timestamp > config_.endTime) revert MintInactive();
1348             if ((totalSupply() + 1) > config_.whitelistMaxSupply) revert OutOfSupply();
1349             if (_numberMinted(msg.sender) > 0) revert ExceedsWalletLimit();
1350             if (msg.value < config_.whitelistPrice) revert InsufficientFunds();
1351         }
1352         
1353         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1354         if (!MerkleProof.verify(_merkleProof, merkleRoot, leaf)) revert InvalidProof();
1355 
1356         _mint(msg.sender, 1);
1357     }
1358 
1359     function publicMint()
1360         external
1361         payable
1362         mintCompliance
1363     {
1364         if (publicSalePaused) revert MintPaused();
1365         if (publicWalletMinted[msg.sender]) revert ExceedsWalletLimit();
1366         unchecked {
1367             if (block.timestamp < publicSaleStartTime) revert MintInactive();
1368             if (msg.value < PRICE) revert InsufficientFunds();
1369         }
1370         publicWalletMinted[msg.sender] = true;
1371 
1372         _mint(msg.sender, 1);
1373     }
1374     
1375     /// @notice Airdrop for a single wallet.
1376     function mintForAddress(uint256 _mintAmount, address _receiver) external onlyOwner {
1377         _mint(_receiver, _mintAmount);
1378     }
1379 
1380     /// @notice Airdrops to multiple wallets.
1381     function batchMintForAddress(address[] calldata addresses, uint256[] calldata quantities) external onlyOwner {
1382         uint32 i;
1383         for (i=0; i < addresses.length; ++i) {
1384             _mint(addresses[i], quantities[i]);
1385         }
1386     }
1387 
1388     function _startTokenId()
1389         internal
1390         view
1391         virtual
1392         override returns (uint256) 
1393     {
1394         return 1;
1395     }
1396 
1397     function setRevealed() public onlyOwner {
1398         revealed = true;
1399     }
1400 
1401     function pausePublicSale(bool _state) public onlyOwner {
1402         publicSalePaused = _state;
1403     }
1404 
1405     function pausePresale(bool _state) public onlyOwner {
1406         presalePaused = _state;
1407     }
1408 
1409     function setPublicSaleStartTime(uint32 startTime_) public onlyOwner {
1410         publicSaleStartTime = startTime_;
1411     }
1412 
1413     function setPresaleStartTime(uint32 startTime_, uint32 endTime_) public onlyOwner {
1414         presaleConfig.startTime = startTime_;
1415         presaleConfig.endTime = endTime_;
1416     }
1417 
1418     function setMerkleRoot(bytes32 merkleRoot_) public onlyOwner {
1419         merkleRoot = merkleRoot_;
1420     }
1421 
1422     function setPublicPrice(uint256 _price) public onlyOwner {
1423         PRICE = _price;
1424     }
1425 
1426     function setWhitelistPrice(uint256 _price) public onlyOwner {
1427         presaleConfig.whitelistPrice = _price;
1428     }
1429 
1430     function withdraw() public onlyOwner {
1431         payable(owner()).transfer(address(this).balance);
1432     }
1433 
1434     /// METADATA URI ///
1435 
1436     function _baseURI()
1437         internal 
1438         view 
1439         virtual
1440         override returns (string memory)
1441     {
1442         return baseURI;
1443     }
1444 
1445     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1446         baseURI = _newBaseURI;
1447     }
1448 
1449     /// @dev Returning concatenated URI with .json as suffix on the tokenID when revealed.
1450     function tokenURI(uint256 _tokenId)
1451         public
1452         view
1453         virtual
1454         override
1455         returns (string memory)
1456     {
1457         require(
1458             _exists(_tokenId),
1459             "ERC721Metadata: URI query for nonexistent token"
1460         );
1461         return string(abi.encodePacked(_baseURI(), "spacecalls.json"));
1462     }
1463 
1464 }