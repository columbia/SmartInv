1 /**
2  *Submitted for verification at Etherscan.io on 2022-05-25
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2022-05-25
7 */
8 
9 // SPDX-License-Identifier: MIT
10 
11 // ERC721A Contracts v3.3.0
12 // Creator: Chiru Labs
13 
14 pragma solidity ^0.8.4;
15 
16 /**
17  * @dev Interface of an ERC721A compliant contract.
18  */
19 interface IERC721A {
20     /**
21      * The caller must own the token or be an approved operator.
22      */
23     error ApprovalCallerNotOwnerNorApproved();
24 
25     /**
26      * The token does not exist.
27      */
28     error ApprovalQueryForNonexistentToken();
29 
30     /**
31      * The caller cannot approve to their own address.
32      */
33     error ApproveToCaller();
34 
35     /**
36      * The caller cannot approve to the current owner.
37      */
38     error ApprovalToCurrentOwner();
39 
40     /**
41      * Cannot query the balance for the zero address.
42      */
43     error BalanceQueryForZeroAddress();
44 
45     /**
46      * Cannot mint to the zero address.
47      */
48     error MintToZeroAddress();
49 
50     /**
51      * The quantity of tokens minted must be more than zero.
52      */
53     error MintZeroQuantity();
54 
55     /**
56      * The token does not exist.
57      */
58     error OwnerQueryForNonexistentToken();
59 
60     /**
61      * The caller must own the token or be an approved operator.
62      */
63     error TransferCallerNotOwnerNorApproved();
64 
65     /**
66      * The token must be owned by `from`.
67      */
68     error TransferFromIncorrectOwner();
69 
70     /**
71      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
72      */
73     error TransferToNonERC721ReceiverImplementer();
74 
75     /**
76      * Cannot transfer to the zero address.
77      */
78     error TransferToZeroAddress();
79 
80     /**
81      * The token does not exist.
82      */
83     error URIQueryForNonexistentToken();
84 
85     struct TokenOwnership {
86         // The address of the owner.
87         address addr;
88         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
89         uint64 startTimestamp;
90         // Whether the token has been burned.
91         bool burned;
92     }
93 
94     /**
95      * @dev Returns the total amount of tokens stored by the contract.
96      *
97      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
98      */
99     function totalSupply() external view returns (uint256);
100 
101     // ==============================
102     //            IERC165
103     // ==============================
104 
105     /**
106      * @dev Returns true if this contract implements the interface defined by
107      * `interfaceId`. See the corresponding
108      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
109      * to learn more about how these ids are created.
110      *
111      * This function call must use less than 30 000 gas.
112      */
113     function supportsInterface(bytes4 interfaceId) external view returns (bool);
114 
115     // ==============================
116     //            IERC721
117     // ==============================
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
130      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
131      */
132     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
133 
134     /**
135      * @dev Returns the number of tokens in ``owner``'s account.
136      */
137     function balanceOf(address owner) external view returns (uint256 balance);
138 
139     /**
140      * @dev Returns the owner of the `tokenId` token.
141      *
142      * Requirements:
143      *
144      * - `tokenId` must exist.
145      */
146     function ownerOf(uint256 tokenId) external view returns (address owner);
147 
148     /**
149      * @dev Safely transfers `tokenId` token from `from` to `to`.
150      *
151      * Requirements:
152      *
153      * - `from` cannot be the zero address.
154      * - `to` cannot be the zero address.
155      * - `tokenId` token must exist and be owned by `from`.
156      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
157      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
158      *
159      * Emits a {Transfer} event.
160      */
161     function safeTransferFrom(
162         address from,
163         address to,
164         uint256 tokenId,
165         bytes calldata data
166     ) external;
167 
168     /**
169      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
170      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
171      *
172      * Requirements:
173      *
174      * - `from` cannot be the zero address.
175      * - `to` cannot be the zero address.
176      * - `tokenId` token must exist and be owned by `from`.
177      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
178      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
179      *
180      * Emits a {Transfer} event.
181      */
182     function safeTransferFrom(
183         address from,
184         address to,
185         uint256 tokenId
186     ) external;
187 
188     /**
189      * @dev Transfers `tokenId` token from `from` to `to`.
190      *
191      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
192      *
193      * Requirements:
194      *
195      * - `from` cannot be the zero address.
196      * - `to` cannot be the zero address.
197      * - `tokenId` token must be owned by `from`.
198      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
199      *
200      * Emits a {Transfer} event.
201      */
202     function transferFrom(
203         address from,
204         address to,
205         uint256 tokenId
206     ) external;
207 
208     /**
209      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
210      * The approval is cleared when the token is transferred.
211      *
212      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
213      *
214      * Requirements:
215      *
216      * - The caller must own the token or be an approved operator.
217      * - `tokenId` must exist.
218      *
219      * Emits an {Approval} event.
220      */
221     function approve(address to, uint256 tokenId) external;
222 
223     /**
224      * @dev Approve or remove `operator` as an operator for the caller.
225      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
226      *
227      * Requirements:
228      *
229      * - The `operator` cannot be the caller.
230      *
231      * Emits an {ApprovalForAll} event.
232      */
233     function setApprovalForAll(address operator, bool _approved) external;
234 
235     /**
236      * @dev Returns the account approved for `tokenId` token.
237      *
238      * Requirements:
239      *
240      * - `tokenId` must exist.
241      */
242     function getApproved(uint256 tokenId) external view returns (address operator);
243 
244     /**
245      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
246      *
247      * See {setApprovalForAll}
248      */
249     function isApprovedForAll(address owner, address operator) external view returns (bool);
250 
251     // ==============================
252     //        IERC721Metadata
253     // ==============================
254 
255     /**
256      * @dev Returns the token collection name.
257      */
258     function name() external view returns (string memory);
259 
260     /**
261      * @dev Returns the token collection symbol.
262      */
263     function symbol() external view returns (string memory);
264 
265     /**
266      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
267      */
268     function tokenURI(uint256 tokenId) external view returns (string memory);
269 }
270 
271 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol
272 
273 
274 // ERC721A Contracts v3.3.0
275 // Creator: Chiru Labs
276 
277 pragma solidity ^0.8.4;
278 
279 
280 /**
281  * @dev ERC721 token receiver interface.
282  */
283 interface ERC721A__IERC721Receiver {
284     function onERC721Received(
285         address operator,
286         address from,
287         uint256 tokenId,
288         bytes calldata data
289     ) external returns (bytes4);
290 }
291 
292 /**
293  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
294  * the Metadata extension. Built to optimize for lower gas during batch mints.
295  *
296  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
297  *
298  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
299  *
300  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
301  */
302 contract ERC721A is IERC721A {
303     // Mask of an entry in packed address data.
304     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
305 
306     // The bit position of `numberMinted` in packed address data.
307     uint256 private constant BITPOS_NUMBER_MINTED = 64;
308 
309     // The bit position of `numberBurned` in packed address data.
310     uint256 private constant BITPOS_NUMBER_BURNED = 128;
311 
312     // The bit position of `aux` in packed address data.
313     uint256 private constant BITPOS_AUX = 192;
314 
315     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
316     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
317 
318     // The bit position of `startTimestamp` in packed ownership.
319     uint256 private constant BITPOS_START_TIMESTAMP = 160;
320 
321     // The bit mask of the `burned` bit in packed ownership.
322     uint256 private constant BITMASK_BURNED = 1 << 224;
323     
324     // The bit position of the `nextInitialized` bit in packed ownership.
325     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
326 
327     // The bit mask of the `nextInitialized` bit in packed ownership.
328     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
329 
330     // The tokenId of the next token to be minted.
331     uint256 private _currentIndex;
332 
333     // The number of tokens burned.
334     uint256 private _burnCounter;
335 
336     // Token name
337     string private _name;
338 
339     // Token symbol
340     string private _symbol;
341 
342     // Mapping from token ID to ownership details
343     // An empty struct value does not necessarily mean the token is unowned.
344     // See `_packedOwnershipOf` implementation for details.
345     //
346     // Bits Layout:
347     // - [0..159]   `addr`
348     // - [160..223] `startTimestamp`
349     // - [224]      `burned`
350     // - [225]      `nextInitialized`
351     mapping(uint256 => uint256) private _packedOwnerships;
352 
353     // Mapping owner address to address data.
354     //
355     // Bits Layout:
356     // - [0..63]    `balance`
357     // - [64..127]  `numberMinted`
358     // - [128..191] `numberBurned`
359     // - [192..255] `aux`
360     mapping(address => uint256) private _packedAddressData;
361 
362     // Mapping from token ID to approved address.
363     mapping(uint256 => address) private _tokenApprovals;
364 
365     // Mapping from owner to operator approvals
366     mapping(address => mapping(address => bool)) private _operatorApprovals;
367 
368     constructor(string memory name_, string memory symbol_) {
369         _name = name_;
370         _symbol = symbol_;
371         _currentIndex = _startTokenId();
372     }
373 
374     /**
375      * @dev Returns the starting token ID. 
376      * To change the starting token ID, please override this function.
377      */
378     function _startTokenId() internal view virtual returns (uint256) {
379         return 0;
380     }
381 
382     /**
383      * @dev Returns the next token ID to be minted.
384      */
385     function _nextTokenId() internal view returns (uint256) {
386         return _currentIndex;
387     }
388 
389     /**
390      * @dev Returns the total number of tokens in existence.
391      * Burned tokens will reduce the count. 
392      * To get the total number of tokens minted, please see `_totalMinted`.
393      */
394     function totalSupply() public view override returns (uint256) {
395         // Counter underflow is impossible as _burnCounter cannot be incremented
396         // more than `_currentIndex - _startTokenId()` times.
397         unchecked {
398             return _currentIndex - _burnCounter - _startTokenId();
399         }
400     }
401 
402     /**
403      * @dev Returns the total amount of tokens minted in the contract.
404      */
405     function _totalMinted() internal view returns (uint256) {
406         // Counter underflow is impossible as _currentIndex does not decrement,
407         // and it is initialized to `_startTokenId()`
408         unchecked {
409             return _currentIndex - _startTokenId();
410         }
411     }
412 
413     /**
414      * @dev Returns the total number of tokens burned.
415      */
416     function _totalBurned() internal view returns (uint256) {
417         return _burnCounter;
418     }
419 
420     /**
421      * @dev See {IERC165-supportsInterface}.
422      */
423     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
424         // The interface IDs are constants representing the first 4 bytes of the XOR of
425         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
426         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
427         return
428             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
429             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
430             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
431     }
432 
433     /**
434      * @dev See {IERC721-balanceOf}.
435      */
436     function balanceOf(address owner) public view override returns (uint256) {
437         if (owner == address(0)) revert BalanceQueryForZeroAddress();
438         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
439     }
440 
441     /**
442      * Returns the number of tokens minted by `owner`.
443      */
444     function _numberMinted(address owner) internal view returns (uint256) {
445         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
446     }
447 
448     /**
449      * Returns the number of tokens burned by or on behalf of `owner`.
450      */
451     function _numberBurned(address owner) internal view returns (uint256) {
452         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
453     }
454 
455     /**
456      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
457      */
458     function _getAux(address owner) internal view returns (uint64) {
459         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
460     }
461 
462     /**
463      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
464      * If there are multiple variables, please pack them into a uint64.
465      */
466     function _setAux(address owner, uint64 aux) internal {
467         uint256 packed = _packedAddressData[owner];
468         uint256 auxCasted;
469         assembly { // Cast aux without masking.
470             auxCasted := aux
471         }
472         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
473         _packedAddressData[owner] = packed;
474     }
475 
476     /**
477      * Returns the packed ownership data of `tokenId`.
478      */
479     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
480         uint256 curr = tokenId;
481 
482         unchecked {
483             if (_startTokenId() <= curr)
484                 if (curr < _currentIndex) {
485                     uint256 packed = _packedOwnerships[curr];
486                     // If not burned.
487                     if (packed & BITMASK_BURNED == 0) {
488                         // Invariant:
489                         // There will always be an ownership that has an address and is not burned
490                         // before an ownership that does not have an address and is not burned.
491                         // Hence, curr will not underflow.
492                         //
493                         // We can directly compare the packed value.
494                         // If the address is zero, packed is zero.
495                         while (packed == 0) {
496                             packed = _packedOwnerships[--curr];
497                         }
498                         return packed;
499                     }
500                 }
501         }
502         revert OwnerQueryForNonexistentToken();
503     }
504 
505     /**
506      * Returns the unpacked `TokenOwnership` struct from `packed`.
507      */
508     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
509         ownership.addr = address(uint160(packed));
510         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
511         ownership.burned = packed & BITMASK_BURNED != 0;
512     }
513 
514     /**
515      * Returns the unpacked `TokenOwnership` struct at `index`.
516      */
517     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
518         return _unpackedOwnership(_packedOwnerships[index]);
519     }
520 
521     /**
522      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
523      */
524     function _initializeOwnershipAt(uint256 index) internal {
525         if (_packedOwnerships[index] == 0) {
526             _packedOwnerships[index] = _packedOwnershipOf(index);
527         }
528     }
529 
530     /**
531      * Gas spent here starts off proportional to the maximum mint batch size.
532      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
533      */
534     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
535         return _unpackedOwnership(_packedOwnershipOf(tokenId));
536     }
537 
538     /**
539      * @dev See {IERC721-ownerOf}.
540      */
541     function ownerOf(uint256 tokenId) public view override returns (address) {
542         return address(uint160(_packedOwnershipOf(tokenId)));
543     }
544 
545     /**
546      * @dev See {IERC721Metadata-name}.
547      */
548     function name() public view virtual override returns (string memory) {
549         return _name;
550     }
551 
552     /**
553      * @dev See {IERC721Metadata-symbol}.
554      */
555     function symbol() public view virtual override returns (string memory) {
556         return _symbol;
557     }
558 
559     /**
560      * @dev See {IERC721Metadata-tokenURI}.
561      */
562     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
563         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
564 
565         string memory baseURI = _baseURI();
566         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
567     }
568 
569     /**
570      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
571      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
572      * by default, can be overriden in child contracts.
573      */
574     function _baseURI() internal view virtual returns (string memory) {
575         return '';
576     }
577 
578     /**
579      * @dev Casts the address to uint256 without masking.
580      */
581     function _addressToUint256(address value) private pure returns (uint256 result) {
582         assembly {
583             result := value
584         }
585     }
586 
587     /**
588      * @dev Casts the boolean to uint256 without branching.
589      */
590     function _boolToUint256(bool value) private pure returns (uint256 result) {
591         assembly {
592             result := value
593         }
594     }
595 
596     /**
597      * @dev See {IERC721-approve}.
598      */
599     function approve(address to, uint256 tokenId) public override {
600         address owner = address(uint160(_packedOwnershipOf(tokenId)));
601         if (to == owner) revert ApprovalToCurrentOwner();
602 
603         if (_msgSenderERC721A() != owner)
604             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
605                 revert ApprovalCallerNotOwnerNorApproved();
606             }
607 
608         _tokenApprovals[tokenId] = to;
609         emit Approval(owner, to, tokenId);
610     }
611 
612     /**
613      * @dev See {IERC721-getApproved}.
614      */
615     function getApproved(uint256 tokenId) public view override returns (address) {
616         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
617 
618         return _tokenApprovals[tokenId];
619     }
620 
621     /**
622      * @dev See {IERC721-setApprovalForAll}.
623      */
624     function setApprovalForAll(address operator, bool approved) public virtual override {
625         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
626 
627         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
628         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
629     }
630 
631     /**
632      * @dev See {IERC721-isApprovedForAll}.
633      */
634     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
635         return _operatorApprovals[owner][operator];
636     }
637 
638     /**
639      * @dev See {IERC721-transferFrom}.
640      */
641     function transferFrom(
642         address from,
643         address to,
644         uint256 tokenId
645     ) public virtual override {
646         _transfer(from, to, tokenId);
647     }
648 
649     /**
650      * @dev See {IERC721-safeTransferFrom}.
651      */
652     function safeTransferFrom(
653         address from,
654         address to,
655         uint256 tokenId
656     ) public virtual override {
657         safeTransferFrom(from, to, tokenId, '');
658     }
659 
660     /**
661      * @dev See {IERC721-safeTransferFrom}.
662      */
663     function safeTransferFrom(
664         address from,
665         address to,
666         uint256 tokenId,
667         bytes memory _data
668     ) public virtual override {
669         _transfer(from, to, tokenId);
670         if (to.code.length != 0)
671             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
672                 revert TransferToNonERC721ReceiverImplementer();
673             }
674     }
675 
676     /**
677      * @dev Returns whether `tokenId` exists.
678      *
679      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
680      *
681      * Tokens start existing when they are minted (`_mint`),
682      */
683     function _exists(uint256 tokenId) internal view returns (bool) {
684         return
685             _startTokenId() <= tokenId &&
686             tokenId < _currentIndex && // If within bounds,
687             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
688     }
689 
690     /**
691      * @dev Equivalent to `_safeMint(to, quantity, '')`.
692      */
693     function _safeMint(address to, uint256 quantity) internal {
694         _safeMint(to, quantity, '');
695     }
696 
697     /**
698      * @dev Safely mints `quantity` tokens and transfers them to `to`.
699      *
700      * Requirements:
701      *
702      * - If `to` refers to a smart contract, it must implement
703      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
704      * - `quantity` must be greater than 0.
705      *
706      * Emits a {Transfer} event.
707      */
708     function _safeMint(
709         address to,
710         uint256 quantity,
711         bytes memory _data
712     ) internal {
713         uint256 startTokenId = _currentIndex;
714         if (to == address(0)) revert MintToZeroAddress();
715         if (quantity == 0) revert MintZeroQuantity();
716 
717         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
718 
719         // Overflows are incredibly unrealistic.
720         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
721         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
722         unchecked {
723             // Updates:
724             // - `balance += quantity`.
725             // - `numberMinted += quantity`.
726             //
727             // We can directly add to the balance and number minted.
728             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
729 
730             // Updates:
731             // - `address` to the owner.
732             // - `startTimestamp` to the timestamp of minting.
733             // - `burned` to `false`.
734             // - `nextInitialized` to `quantity == 1`.
735             _packedOwnerships[startTokenId] =
736                 _addressToUint256(to) |
737                 (block.timestamp << BITPOS_START_TIMESTAMP) |
738                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
739 
740             uint256 updatedIndex = startTokenId;
741             uint256 end = updatedIndex + quantity;
742 
743             if (to.code.length != 0) {
744                 do {
745                     emit Transfer(address(0), to, updatedIndex);
746                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
747                         revert TransferToNonERC721ReceiverImplementer();
748                     }
749                 } while (updatedIndex < end);
750                 // Reentrancy protection
751                 if (_currentIndex != startTokenId) revert();
752             } else {
753                 do {
754                     emit Transfer(address(0), to, updatedIndex++);
755                 } while (updatedIndex < end);
756             }
757             _currentIndex = updatedIndex;
758         }
759         _afterTokenTransfers(address(0), to, startTokenId, quantity);
760     }
761 
762     /**
763      * @dev Mints `quantity` tokens and transfers them to `to`.
764      *
765      * Requirements:
766      *
767      * - `to` cannot be the zero address.
768      * - `quantity` must be greater than 0.
769      *
770      * Emits a {Transfer} event.
771      */
772     function _mint(address to, uint256 quantity) internal {
773         uint256 startTokenId = _currentIndex;
774         if (to == address(0)) revert MintToZeroAddress();
775         if (quantity == 0) revert MintZeroQuantity();
776 
777         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
778 
779         // Overflows are incredibly unrealistic.
780         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
781         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
782         unchecked {
783             // Updates:
784             // - `balance += quantity`.
785             // - `numberMinted += quantity`.
786             //
787             // We can directly add to the balance and number minted.
788             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
789 
790             // Updates:
791             // - `address` to the owner.
792             // - `startTimestamp` to the timestamp of minting.
793             // - `burned` to `false`.
794             // - `nextInitialized` to `quantity == 1`.
795             _packedOwnerships[startTokenId] =
796                 _addressToUint256(to) |
797                 (block.timestamp << BITPOS_START_TIMESTAMP) |
798                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
799 
800             uint256 updatedIndex = startTokenId;
801             uint256 end = updatedIndex + quantity;
802 
803             do {
804                 emit Transfer(address(0), to, updatedIndex++);
805             } while (updatedIndex < end);
806 
807             _currentIndex = updatedIndex;
808         }
809         _afterTokenTransfers(address(0), to, startTokenId, quantity);
810     }
811 
812     /**
813      * @dev Transfers `tokenId` from `from` to `to`.
814      *
815      * Requirements:
816      *
817      * - `to` cannot be the zero address.
818      * - `tokenId` token must be owned by `from`.
819      *
820      * Emits a {Transfer} event.
821      */
822     function _transfer(
823         address from,
824         address to,
825         uint256 tokenId
826     ) private {
827         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
828 
829         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
830 
831         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
832             isApprovedForAll(from, _msgSenderERC721A()) ||
833             getApproved(tokenId) == _msgSenderERC721A());
834 
835         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
836         if (to == address(0)) revert TransferToZeroAddress();
837 
838         _beforeTokenTransfers(from, to, tokenId, 1);
839 
840         // Clear approvals from the previous owner.
841         delete _tokenApprovals[tokenId];
842 
843         // Underflow of the sender's balance is impossible because we check for
844         // ownership above and the recipient's balance can't realistically overflow.
845         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
846         unchecked {
847             // We can directly increment and decrement the balances.
848             --_packedAddressData[from]; // Updates: `balance -= 1`.
849             ++_packedAddressData[to]; // Updates: `balance += 1`.
850 
851             // Updates:
852             // - `address` to the next owner.
853             // - `startTimestamp` to the timestamp of transfering.
854             // - `burned` to `false`.
855             // - `nextInitialized` to `true`.
856             _packedOwnerships[tokenId] =
857                 _addressToUint256(to) |
858                 (block.timestamp << BITPOS_START_TIMESTAMP) |
859                 BITMASK_NEXT_INITIALIZED;
860 
861             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
862             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
863                 uint256 nextTokenId = tokenId + 1;
864                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
865                 if (_packedOwnerships[nextTokenId] == 0) {
866                     // If the next slot is within bounds.
867                     if (nextTokenId != _currentIndex) {
868                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
869                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
870                     }
871                 }
872             }
873         }
874 
875         emit Transfer(from, to, tokenId);
876         _afterTokenTransfers(from, to, tokenId, 1);
877     }
878 
879     /**
880      * @dev Equivalent to `_burn(tokenId, false)`.
881      */
882     function _burn(uint256 tokenId) internal virtual {
883         _burn(tokenId, false);
884     }
885 
886     /**
887      * @dev Destroys `tokenId`.
888      * The approval is cleared when the token is burned.
889      *
890      * Requirements:
891      *
892      * - `tokenId` must exist.
893      *
894      * Emits a {Transfer} event.
895      */
896     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
897         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
898 
899         address from = address(uint160(prevOwnershipPacked));
900 
901         if (approvalCheck) {
902             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
903                 isApprovedForAll(from, _msgSenderERC721A()) ||
904                 getApproved(tokenId) == _msgSenderERC721A());
905 
906             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
907         }
908 
909         _beforeTokenTransfers(from, address(0), tokenId, 1);
910 
911         // Clear approvals from the previous owner.
912         delete _tokenApprovals[tokenId];
913 
914         // Underflow of the sender's balance is impossible because we check for
915         // ownership above and the recipient's balance can't realistically overflow.
916         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
917         unchecked {
918             // Updates:
919             // - `balance -= 1`.
920             // - `numberBurned += 1`.
921             //
922             // We can directly decrement the balance, and increment the number burned.
923             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
924             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
925 
926             // Updates:
927             // - `address` to the last owner.
928             // - `startTimestamp` to the timestamp of burning.
929             // - `burned` to `true`.
930             // - `nextInitialized` to `true`.
931             _packedOwnerships[tokenId] =
932                 _addressToUint256(from) |
933                 (block.timestamp << BITPOS_START_TIMESTAMP) |
934                 BITMASK_BURNED | 
935                 BITMASK_NEXT_INITIALIZED;
936 
937             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
938             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
939                 uint256 nextTokenId = tokenId + 1;
940                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
941                 if (_packedOwnerships[nextTokenId] == 0) {
942                     // If the next slot is within bounds.
943                     if (nextTokenId != _currentIndex) {
944                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
945                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
946                     }
947                 }
948             }
949         }
950 
951         emit Transfer(from, address(0), tokenId);
952         _afterTokenTransfers(from, address(0), tokenId, 1);
953 
954         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
955         unchecked {
956             _burnCounter++;
957         }
958     }
959 
960     /**
961      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
962      *
963      * @param from address representing the previous owner of the given token ID
964      * @param to target address that will receive the tokens
965      * @param tokenId uint256 ID of the token to be transferred
966      * @param _data bytes optional data to send along with the call
967      * @return bool whether the call correctly returned the expected magic value
968      */
969     function _checkContractOnERC721Received(
970         address from,
971         address to,
972         uint256 tokenId,
973         bytes memory _data
974     ) private returns (bool) {
975         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
976             bytes4 retval
977         ) {
978             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
979         } catch (bytes memory reason) {
980             if (reason.length == 0) {
981                 revert TransferToNonERC721ReceiverImplementer();
982             } else {
983                 assembly {
984                     revert(add(32, reason), mload(reason))
985                 }
986             }
987         }
988     }
989 
990     /**
991      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
992      * And also called before burning one token.
993      *
994      * startTokenId - the first token id to be transferred
995      * quantity - the amount to be transferred
996      *
997      * Calling conditions:
998      *
999      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1000      * transferred to `to`.
1001      * - When `from` is zero, `tokenId` will be minted for `to`.
1002      * - When `to` is zero, `tokenId` will be burned by `from`.
1003      * - `from` and `to` are never both zero.
1004      */
1005     function _beforeTokenTransfers(
1006         address from,
1007         address to,
1008         uint256 startTokenId,
1009         uint256 quantity
1010     ) internal virtual {}
1011 
1012     /**
1013      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1014      * minting.
1015      * And also called after one token has been burned.
1016      *
1017      * startTokenId - the first token id to be transferred
1018      * quantity - the amount to be transferred
1019      *
1020      * Calling conditions:
1021      *
1022      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1023      * transferred to `to`.
1024      * - When `from` is zero, `tokenId` has been minted for `to`.
1025      * - When `to` is zero, `tokenId` has been burned by `from`.
1026      * - `from` and `to` are never both zero.
1027      */
1028     function _afterTokenTransfers(
1029         address from,
1030         address to,
1031         uint256 startTokenId,
1032         uint256 quantity
1033     ) internal virtual {}
1034 
1035     /**
1036      * @dev Returns the message sender (defaults to `msg.sender`).
1037      *
1038      * If you are writing GSN compatible contracts, you need to override this function.
1039      */
1040     function _msgSenderERC721A() internal view virtual returns (address) {
1041         return msg.sender;
1042     }
1043 
1044     /**
1045      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1046      */
1047     function _toString(uint256 value) internal pure returns (string memory ptr) {
1048         assembly {
1049             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1050             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1051             // We will need 1 32-byte word to store the length, 
1052             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1053             ptr := add(mload(0x40), 128)
1054             // Update the free memory pointer to allocate.
1055             mstore(0x40, ptr)
1056 
1057             // Cache the end of the memory to calculate the length later.
1058             let end := ptr
1059 
1060             // We write the string from the rightmost digit to the leftmost digit.
1061             // The following is essentially a do-while loop that also handles the zero case.
1062             // Costs a bit more than early returning for the zero case,
1063             // but cheaper in terms of deployment and overall runtime costs.
1064             for { 
1065                 // Initialize and perform the first pass without check.
1066                 let temp := value
1067                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1068                 ptr := sub(ptr, 1)
1069                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1070                 mstore8(ptr, add(48, mod(temp, 10)))
1071                 temp := div(temp, 10)
1072             } temp { 
1073                 // Keep dividing `temp` until zero.
1074                 temp := div(temp, 10)
1075             } { // Body of the for loop.
1076                 ptr := sub(ptr, 1)
1077                 mstore8(ptr, add(48, mod(temp, 10)))
1078             }
1079             
1080             let length := sub(end, ptr)
1081             // Move the pointer 32 bytes leftwards to make room for the length.
1082             ptr := sub(ptr, 32)
1083             // Store the length.
1084             mstore(ptr, length)
1085         }
1086     }
1087 }
1088 
1089 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
1090 
1091 
1092 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
1093 
1094 pragma solidity ^0.8.0;
1095 
1096 /**
1097  * @dev String operations.
1098  */
1099 library Strings {
1100     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1101     uint8 private constant _ADDRESS_LENGTH = 20;
1102 
1103     /**
1104      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1105      */
1106     function toString(uint256 value) internal pure returns (string memory) {
1107         // Inspired by OraclizeAPI's implementation - MIT licence
1108         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1109 
1110         if (value == 0) {
1111             return "0";
1112         }
1113         uint256 temp = value;
1114         uint256 digits;
1115         while (temp != 0) {
1116             digits++;
1117             temp /= 10;
1118         }
1119         bytes memory buffer = new bytes(digits);
1120         while (value != 0) {
1121             digits -= 1;
1122             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1123             value /= 10;
1124         }
1125         return string(buffer);
1126     }
1127 
1128     /**
1129      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1130      */
1131     function toHexString(uint256 value) internal pure returns (string memory) {
1132         if (value == 0) {
1133             return "0x00";
1134         }
1135         uint256 temp = value;
1136         uint256 length = 0;
1137         while (temp != 0) {
1138             length++;
1139             temp >>= 8;
1140         }
1141         return toHexString(value, length);
1142     }
1143 
1144     /**
1145      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1146      */
1147     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1148         bytes memory buffer = new bytes(2 * length + 2);
1149         buffer[0] = "0";
1150         buffer[1] = "x";
1151         for (uint256 i = 2 * length + 1; i > 1; --i) {
1152             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1153             value >>= 4;
1154         }
1155         require(value == 0, "Strings: hex length insufficient");
1156         return string(buffer);
1157     }
1158 
1159     /**
1160      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1161      */
1162     function toHexString(address addr) internal pure returns (string memory) {
1163         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1164     }
1165 }
1166 
1167 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
1168 
1169 
1170 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1171 
1172 pragma solidity ^0.8.0;
1173 
1174 /**
1175  * @dev Provides information about the current execution context, including the
1176  * sender of the transaction and its data. While these are generally available
1177  * via msg.sender and msg.data, they should not be accessed in such a direct
1178  * manner, since when dealing with meta-transactions the account sending and
1179  * paying for execution may not be the actual sender (as far as an application
1180  * is concerned).
1181  *
1182  * This contract is only required for intermediate, library-like contracts.
1183  */
1184 abstract contract Context {
1185     function _msgSender() internal view virtual returns (address) {
1186         return msg.sender;
1187     }
1188 
1189     function _msgData() internal view virtual returns (bytes calldata) {
1190         return msg.data;
1191     }
1192 }
1193 
1194 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
1195 
1196 
1197 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1198 
1199 pragma solidity ^0.8.0;
1200 
1201 
1202 /**
1203  * @dev Contract module which provides a basic access control mechanism, where
1204  * there is an account (an owner) that can be granted exclusive access to
1205  * specific functions.
1206  *
1207  * By default, the owner account will be the one that deploys the contract. This
1208  * can later be changed with {transferOwnership}.
1209  *
1210  * This module is used through inheritance. It will make available the modifier
1211  * `onlyOwner`, which can be applied to your functions to restrict their use to
1212  * the owner.
1213  */
1214 abstract contract Ownable is Context {
1215     address private _owner;
1216 
1217     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1218 
1219     /**
1220      * @dev Initializes the contract setting the deployer as the initial owner.
1221      */
1222     constructor() {
1223         _transferOwnership(_msgSender());
1224     }
1225 
1226     /**
1227      * @dev Returns the address of the current owner.
1228      */
1229     function owner() public view virtual returns (address) {
1230         return _owner;
1231     }
1232 
1233     /**
1234      * @dev Throws if called by any account other than the owner.
1235      */
1236     modifier onlyOwner() {
1237         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1238         _;
1239     }
1240 
1241     /**
1242      * @dev Leaves the contract without owner. It will not be possible to call
1243      * `onlyOwner` functions anymore. Can only be called by the current owner.
1244      *
1245      * NOTE: Renouncing ownership will leave the contract without an owner,
1246      * thereby removing any functionality that is only available to the owner.
1247      */
1248     function renounceOwnership() public virtual onlyOwner {
1249         _transferOwnership(address(0));
1250     }
1251 
1252     /**
1253      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1254      * Can only be called by the current owner.
1255      */
1256     function transferOwnership(address newOwner) public virtual onlyOwner {
1257         require(newOwner != address(0), "Ownable: new owner is the zero address");
1258         _transferOwnership(newOwner);
1259     }
1260 
1261     /**
1262      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1263      * Internal function without access restriction.
1264      */
1265     function _transferOwnership(address newOwner) internal virtual {
1266         address oldOwner = _owner;
1267         _owner = newOwner;
1268         emit OwnershipTransferred(oldOwner, newOwner);
1269     }
1270 }
1271 
1272 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol
1273 
1274 
1275 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
1276 
1277 pragma solidity ^0.8.1;
1278 
1279 /**
1280  * @dev Collection of functions related to the address type
1281  */
1282 library Address {
1283     /**
1284      * @dev Returns true if `account` is a contract.
1285      *
1286      * [IMPORTANT]
1287      * ====
1288      * It is unsafe to assume that an address for which this function returns
1289      * false is an externally-owned account (EOA) and not a contract.
1290      *
1291      * Among others, `isContract` will return false for the following
1292      * types of addresses:
1293      *
1294      *  - an externally-owned account
1295      *  - a contract in construction
1296      *  - an address where a contract will be created
1297      *  - an address where a contract lived, but was destroyed
1298      * ====
1299      *
1300      * [IMPORTANT]
1301      * ====
1302      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1303      *
1304      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1305      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1306      * constructor.
1307      * ====
1308      */
1309     function isContract(address account) internal view returns (bool) {
1310         // This method relies on extcodesize/address.code.length, which returns 0
1311         // for contracts in construction, since the code is only stored at the end
1312         // of the constructor execution.
1313 
1314         return account.code.length > 0;
1315     }
1316 
1317     /**
1318      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1319      * `recipient`, forwarding all available gas and reverting on errors.
1320      *
1321      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1322      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1323      * imposed by `transfer`, making them unable to receive funds via
1324      * `transfer`. {sendValue} removes this limitation.
1325      *
1326      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1327      *
1328      * IMPORTANT: because control is transferred to `recipient`, care must be
1329      * taken to not create reentrancy vulnerabilities. Consider using
1330      * {ReentrancyGuard} or the
1331      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1332      */
1333     function sendValue(address payable recipient, uint256 amount) internal {
1334         require(address(this).balance >= amount, "Address: insufficient balance");
1335 
1336         (bool success, ) = recipient.call{value: amount}("");
1337         require(success, "Address: unable to send value, recipient may have reverted");
1338     }
1339 
1340     /**
1341      * @dev Performs a Solidity function call using a low level `call`. A
1342      * plain `call` is an unsafe replacement for a function call: use this
1343      * function instead.
1344      *
1345      * If `target` reverts with a revert reason, it is bubbled up by this
1346      * function (like regular Solidity function calls).
1347      *
1348      * Returns the raw returned data. To convert to the expected return value,
1349      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1350      *
1351      * Requirements:
1352      *
1353      * - `target` must be a contract.
1354      * - calling `target` with `data` must not revert.
1355      *
1356      * _Available since v3.1._
1357      */
1358     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1359         return functionCall(target, data, "Address: low-level call failed");
1360     }
1361 
1362     /**
1363      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1364      * `errorMessage` as a fallback revert reason when `target` reverts.
1365      *
1366      * _Available since v3.1._
1367      */
1368     function functionCall(
1369         address target,
1370         bytes memory data,
1371         string memory errorMessage
1372     ) internal returns (bytes memory) {
1373         return functionCallWithValue(target, data, 0, errorMessage);
1374     }
1375 
1376     /**
1377      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1378      * but also transferring `value` wei to `target`.
1379      *
1380      * Requirements:
1381      *
1382      * - the calling contract must have an ETH balance of at least `value`.
1383      * - the called Solidity function must be `payable`.
1384      *
1385      * _Available since v3.1._
1386      */
1387     function functionCallWithValue(
1388         address target,
1389         bytes memory data,
1390         uint256 value
1391     ) internal returns (bytes memory) {
1392         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1393     }
1394 
1395     /**
1396      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1397      * with `errorMessage` as a fallback revert reason when `target` reverts.
1398      *
1399      * _Available since v3.1._
1400      */
1401     function functionCallWithValue(
1402         address target,
1403         bytes memory data,
1404         uint256 value,
1405         string memory errorMessage
1406     ) internal returns (bytes memory) {
1407         require(address(this).balance >= value, "Address: insufficient balance for call");
1408         require(isContract(target), "Address: call to non-contract");
1409 
1410         (bool success, bytes memory returndata) = target.call{value: value}(data);
1411         return verifyCallResult(success, returndata, errorMessage);
1412     }
1413 
1414     /**
1415      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1416      * but performing a static call.
1417      *
1418      * _Available since v3.3._
1419      */
1420     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1421         return functionStaticCall(target, data, "Address: low-level static call failed");
1422     }
1423 
1424     /**
1425      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1426      * but performing a static call.
1427      *
1428      * _Available since v3.3._
1429      */
1430     function functionStaticCall(
1431         address target,
1432         bytes memory data,
1433         string memory errorMessage
1434     ) internal view returns (bytes memory) {
1435         require(isContract(target), "Address: static call to non-contract");
1436 
1437         (bool success, bytes memory returndata) = target.staticcall(data);
1438         return verifyCallResult(success, returndata, errorMessage);
1439     }
1440 
1441     /**
1442      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1443      * but performing a delegate call.
1444      *
1445      * _Available since v3.4._
1446      */
1447     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1448         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1449     }
1450 
1451     /**
1452      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1453      * but performing a delegate call.
1454      *
1455      * _Available since v3.4._
1456      */
1457     function functionDelegateCall(
1458         address target,
1459         bytes memory data,
1460         string memory errorMessage
1461     ) internal returns (bytes memory) {
1462         require(isContract(target), "Address: delegate call to non-contract");
1463 
1464         (bool success, bytes memory returndata) = target.delegatecall(data);
1465         return verifyCallResult(success, returndata, errorMessage);
1466     }
1467 
1468     /**
1469      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1470      * revert reason using the provided one.
1471      *
1472      * _Available since v4.3._
1473      */
1474     function verifyCallResult(
1475         bool success,
1476         bytes memory returndata,
1477         string memory errorMessage
1478     ) internal pure returns (bytes memory) {
1479         if (success) {
1480             return returndata;
1481         } else {
1482             // Look for revert reason and bubble it up if present
1483             if (returndata.length > 0) {
1484                 // The easiest way to bubble the revert reason is using memory via assembly
1485 
1486                 assembly {
1487                     let returndata_size := mload(returndata)
1488                     revert(add(32, returndata), returndata_size)
1489                 }
1490             } else {
1491                 revert(errorMessage);
1492             }
1493         }
1494     }
1495 }
1496 
1497 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721Receiver.sol
1498 
1499 
1500 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
1501 
1502 pragma solidity ^0.8.0;
1503 
1504 /**
1505  * @title ERC721 token receiver interface
1506  * @dev Interface for any contract that wants to support safeTransfers
1507  * from ERC721 asset contracts.
1508  */
1509 interface IERC721Receiver {
1510     /**
1511      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1512      * by `operator` from `from`, this function is called.
1513      *
1514      * It must return its Solidity selector to confirm the token transfer.
1515      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1516      *
1517      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
1518      */
1519     function onERC721Received(
1520         address operator,
1521         address from,
1522         uint256 tokenId,
1523         bytes calldata data
1524     ) external returns (bytes4);
1525 }
1526 
1527 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/IERC165.sol
1528 
1529 
1530 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1531 
1532 pragma solidity ^0.8.0;
1533 
1534 /**
1535  * @dev Interface of the ERC165 standard, as defined in the
1536  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1537  *
1538  * Implementers can declare support of contract interfaces, which can then be
1539  * queried by others ({ERC165Checker}).
1540  *
1541  * For an implementation, see {ERC165}.
1542  */
1543 interface IERC165 {
1544     /**
1545      * @dev Returns true if this contract implements the interface defined by
1546      * `interfaceId`. See the corresponding
1547      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1548      * to learn more about how these ids are created.
1549      *
1550      * This function call must use less than 30 000 gas.
1551      */
1552     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1553 }
1554 
1555 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/ERC165.sol
1556 
1557 
1558 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1559 
1560 pragma solidity ^0.8.0;
1561 
1562 
1563 /**
1564  * @dev Implementation of the {IERC165} interface.
1565  *
1566  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1567  * for the additional interface id that will be supported. For example:
1568  *
1569  * ```solidity
1570  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1571  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1572  * }
1573  * ```
1574  *
1575  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1576  */
1577 abstract contract ERC165 is IERC165 {
1578     /**
1579      * @dev See {IERC165-supportsInterface}.
1580      */
1581     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1582         return interfaceId == type(IERC165).interfaceId;
1583     }
1584 }
1585 
1586 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721.sol
1587 
1588 
1589 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
1590 
1591 pragma solidity ^0.8.0;
1592 
1593 
1594 /**
1595  * @dev Required interface of an ERC721 compliant contract.
1596  */
1597 interface IERC721 is IERC165 {
1598     /**
1599      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1600      */
1601     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1602 
1603     /**
1604      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1605      */
1606     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1607 
1608     /**
1609      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1610      */
1611     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1612 
1613     /**
1614      * @dev Returns the number of tokens in ``owner``'s account.
1615      */
1616     function balanceOf(address owner) external view returns (uint256 balance);
1617 
1618     /**
1619      * @dev Returns the owner of the `tokenId` token.
1620      *
1621      * Requirements:
1622      *
1623      * - `tokenId` must exist.
1624      */
1625     function ownerOf(uint256 tokenId) external view returns (address owner);
1626 
1627     /**
1628      * @dev Safely transfers `tokenId` token from `from` to `to`.
1629      *
1630      * Requirements:
1631      *
1632      * - `from` cannot be the zero address.
1633      * - `to` cannot be the zero address.
1634      * - `tokenId` token must exist and be owned by `from`.
1635      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1636      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1637      *
1638      * Emits a {Transfer} event.
1639      */
1640     function safeTransferFrom(
1641         address from,
1642         address to,
1643         uint256 tokenId,
1644         bytes calldata data
1645     ) external;
1646 
1647     /**
1648      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1649      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1650      *
1651      * Requirements:
1652      *
1653      * - `from` cannot be the zero address.
1654      * - `to` cannot be the zero address.
1655      * - `tokenId` token must exist and be owned by `from`.
1656      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1657      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1658      *
1659      * Emits a {Transfer} event.
1660      */
1661     function safeTransferFrom(
1662         address from,
1663         address to,
1664         uint256 tokenId
1665     ) external;
1666 
1667     /**
1668      * @dev Transfers `tokenId` token from `from` to `to`.
1669      *
1670      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1671      *
1672      * Requirements:
1673      *
1674      * - `from` cannot be the zero address.
1675      * - `to` cannot be the zero address.
1676      * - `tokenId` token must be owned by `from`.
1677      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1678      *
1679      * Emits a {Transfer} event.
1680      */
1681     function transferFrom(
1682         address from,
1683         address to,
1684         uint256 tokenId
1685     ) external;
1686 
1687     /**
1688      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1689      * The approval is cleared when the token is transferred.
1690      *
1691      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1692      *
1693      * Requirements:
1694      *
1695      * - The caller must own the token or be an approved operator.
1696      * - `tokenId` must exist.
1697      *
1698      * Emits an {Approval} event.
1699      */
1700     function approve(address to, uint256 tokenId) external;
1701 
1702     /**
1703      * @dev Approve or remove `operator` as an operator for the caller.
1704      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1705      *
1706      * Requirements:
1707      *
1708      * - The `operator` cannot be the caller.
1709      *
1710      * Emits an {ApprovalForAll} event.
1711      */
1712     function setApprovalForAll(address operator, bool _approved) external;
1713 
1714     /**
1715      * @dev Returns the account approved for `tokenId` token.
1716      *
1717      * Requirements:
1718      *
1719      * - `tokenId` must exist.
1720      */
1721     function getApproved(uint256 tokenId) external view returns (address operator);
1722 
1723     /**
1724      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1725      *
1726      * See {setApprovalForAll}
1727      */
1728     function isApprovedForAll(address owner, address operator) external view returns (bool);
1729 }
1730 
1731 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/IERC721Metadata.sol
1732 
1733 
1734 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1735 
1736 pragma solidity ^0.8.0;
1737 
1738 
1739 /**
1740  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1741  * @dev See https://eips.ethereum.org/EIPS/eip-721
1742  */
1743 interface IERC721Metadata is IERC721 {
1744     /**
1745      * @dev Returns the token collection name.
1746      */
1747     function name() external view returns (string memory);
1748 
1749     /**
1750      * @dev Returns the token collection symbol.
1751      */
1752     function symbol() external view returns (string memory);
1753 
1754     /**
1755      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1756      */
1757     function tokenURI(uint256 tokenId) external view returns (string memory);
1758 }
1759 
1760 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol
1761 
1762 
1763 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
1764 
1765 pragma solidity ^0.8.0;
1766 
1767 
1768 
1769 
1770 
1771 
1772 
1773 
1774 /**
1775  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1776  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1777  * {ERC721Enumerable}.
1778  */
1779 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1780     using Address for address;
1781     using Strings for uint256;
1782 
1783     // Token name
1784     string private _name;
1785 
1786     // Token symbol
1787     string private _symbol;
1788 
1789     // Mapping from token ID to owner address
1790     mapping(uint256 => address) private _owners;
1791 
1792     // Mapping owner address to token count
1793     mapping(address => uint256) private _balances;
1794 
1795     // Mapping from token ID to approved address
1796     mapping(uint256 => address) private _tokenApprovals;
1797 
1798     // Mapping from owner to operator approvals
1799     mapping(address => mapping(address => bool)) private _operatorApprovals;
1800 
1801     /**
1802      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1803      */
1804     constructor(string memory name_, string memory symbol_) {
1805         _name = name_;
1806         _symbol = symbol_;
1807     }
1808 
1809     /**
1810      * @dev See {IERC165-supportsInterface}.
1811      */
1812     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1813         return
1814             interfaceId == type(IERC721).interfaceId ||
1815             interfaceId == type(IERC721Metadata).interfaceId ||
1816             super.supportsInterface(interfaceId);
1817     }
1818 
1819     /**
1820      * @dev See {IERC721-balanceOf}.
1821      */
1822     function balanceOf(address owner) public view virtual override returns (uint256) {
1823         require(owner != address(0), "ERC721: address zero is not a valid owner");
1824         return _balances[owner];
1825     }
1826 
1827     /**
1828      * @dev See {IERC721-ownerOf}.
1829      */
1830     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1831         address owner = _owners[tokenId];
1832         require(owner != address(0), "ERC721: owner query for nonexistent token");
1833         return owner;
1834     }
1835 
1836     /**
1837      * @dev See {IERC721Metadata-name}.
1838      */
1839     function name() public view virtual override returns (string memory) {
1840         return _name;
1841     }
1842 
1843     /**
1844      * @dev See {IERC721Metadata-symbol}.
1845      */
1846     function symbol() public view virtual override returns (string memory) {
1847         return _symbol;
1848     }
1849 
1850     /**
1851      * @dev See {IERC721Metadata-tokenURI}.
1852      */
1853     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1854         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1855 
1856         string memory baseURI = _baseURI();
1857         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1858     }
1859 
1860     /**
1861      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1862      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1863      * by default, can be overridden in child contracts.
1864      */
1865     function _baseURI() internal view virtual returns (string memory) {
1866         return "";
1867     }
1868 
1869     /**
1870      * @dev See {IERC721-approve}.
1871      */
1872     function approve(address to, uint256 tokenId) public virtual override {
1873         address owner = ERC721.ownerOf(tokenId);
1874         require(to != owner, "ERC721: approval to current owner");
1875 
1876         require(
1877             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1878             "ERC721: approve caller is not owner nor approved for all"
1879         );
1880 
1881         _approve(to, tokenId);
1882     }
1883 
1884     /**
1885      * @dev See {IERC721-getApproved}.
1886      */
1887     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1888         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1889 
1890         return _tokenApprovals[tokenId];
1891     }
1892 
1893     /**
1894      * @dev See {IERC721-setApprovalForAll}.
1895      */
1896     function setApprovalForAll(address operator, bool approved) public virtual override {
1897         _setApprovalForAll(_msgSender(), operator, approved);
1898     }
1899 
1900     /**
1901      * @dev See {IERC721-isApprovedForAll}.
1902      */
1903     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1904         return _operatorApprovals[owner][operator];
1905     }
1906 
1907     /**
1908      * @dev See {IERC721-transferFrom}.
1909      */
1910     function transferFrom(
1911         address from,
1912         address to,
1913         uint256 tokenId
1914     ) public virtual override {
1915         //solhint-disable-next-line max-line-length
1916         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1917 
1918         _transfer(from, to, tokenId);
1919     }
1920 
1921     /**
1922      * @dev See {IERC721-safeTransferFrom}.
1923      */
1924     function safeTransferFrom(
1925         address from,
1926         address to,
1927         uint256 tokenId
1928     ) public virtual override {
1929         safeTransferFrom(from, to, tokenId, "");
1930     }
1931 
1932     /**
1933      * @dev See {IERC721-safeTransferFrom}.
1934      */
1935     function safeTransferFrom(
1936         address from,
1937         address to,
1938         uint256 tokenId,
1939         bytes memory data
1940     ) public virtual override {
1941         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1942         _safeTransfer(from, to, tokenId, data);
1943     }
1944 
1945     /**
1946      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1947      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1948      *
1949      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1950      *
1951      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1952      * implement alternative mechanisms to perform token transfer, such as signature-based.
1953      *
1954      * Requirements:
1955      *
1956      * - `from` cannot be the zero address.
1957      * - `to` cannot be the zero address.
1958      * - `tokenId` token must exist and be owned by `from`.
1959      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1960      *
1961      * Emits a {Transfer} event.
1962      */
1963     function _safeTransfer(
1964         address from,
1965         address to,
1966         uint256 tokenId,
1967         bytes memory data
1968     ) internal virtual {
1969         _transfer(from, to, tokenId);
1970         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1971     }
1972 
1973     /**
1974      * @dev Returns whether `tokenId` exists.
1975      *
1976      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1977      *
1978      * Tokens start existing when they are minted (`_mint`),
1979      * and stop existing when they are burned (`_burn`).
1980      */
1981     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1982         return _owners[tokenId] != address(0);
1983     }
1984 
1985     /**
1986      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1987      *
1988      * Requirements:
1989      *
1990      * - `tokenId` must exist.
1991      */
1992     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1993         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1994         address owner = ERC721.ownerOf(tokenId);
1995         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1996     }
1997 
1998     /**
1999      * @dev Safely mints `tokenId` and transfers it to `to`.
2000      *
2001      * Requirements:
2002      *
2003      * - `tokenId` must not exist.
2004      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2005      *
2006      * Emits a {Transfer} event.
2007      */
2008     function _safeMint(address to, uint256 tokenId) internal virtual {
2009         _safeMint(to, tokenId, "");
2010     }
2011 
2012     /**
2013      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
2014      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
2015      */
2016     function _safeMint(
2017         address to,
2018         uint256 tokenId,
2019         bytes memory data
2020     ) internal virtual {
2021         _mint(to, tokenId);
2022         require(
2023             _checkOnERC721Received(address(0), to, tokenId, data),
2024             "ERC721: transfer to non ERC721Receiver implementer"
2025         );
2026     }
2027 
2028     /**
2029      * @dev Mints `tokenId` and transfers it to `to`.
2030      *
2031      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
2032      *
2033      * Requirements:
2034      *
2035      * - `tokenId` must not exist.
2036      * - `to` cannot be the zero address.
2037      *
2038      * Emits a {Transfer} event.
2039      */
2040     function _mint(address to, uint256 tokenId) internal virtual {
2041         require(to != address(0), "ERC721: mint to the zero address");
2042         require(!_exists(tokenId), "ERC721: token already minted");
2043 
2044         _beforeTokenTransfer(address(0), to, tokenId);
2045 
2046         _balances[to] += 1;
2047         _owners[tokenId] = to;
2048 
2049         emit Transfer(address(0), to, tokenId);
2050 
2051         _afterTokenTransfer(address(0), to, tokenId);
2052     }
2053 
2054     /**
2055      * @dev Destroys `tokenId`.
2056      * The approval is cleared when the token is burned.
2057      *
2058      * Requirements:
2059      *
2060      * - `tokenId` must exist.
2061      *
2062      * Emits a {Transfer} event.
2063      */
2064     function _burn(uint256 tokenId) internal virtual {
2065         address owner = ERC721.ownerOf(tokenId);
2066 
2067         _beforeTokenTransfer(owner, address(0), tokenId);
2068 
2069         // Clear approvals
2070         _approve(address(0), tokenId);
2071 
2072         _balances[owner] -= 1;
2073         delete _owners[tokenId];
2074 
2075         emit Transfer(owner, address(0), tokenId);
2076 
2077         _afterTokenTransfer(owner, address(0), tokenId);
2078     }
2079 
2080     /**
2081      * @dev Transfers `tokenId` from `from` to `to`.
2082      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2083      *
2084      * Requirements:
2085      *
2086      * - `to` cannot be the zero address.
2087      * - `tokenId` token must be owned by `from`.
2088      *
2089      * Emits a {Transfer} event.
2090      */
2091     function _transfer(
2092         address from,
2093         address to,
2094         uint256 tokenId
2095     ) internal virtual {
2096         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
2097         require(to != address(0), "ERC721: transfer to the zero address");
2098 
2099         _beforeTokenTransfer(from, to, tokenId);
2100 
2101         // Clear approvals from the previous owner
2102         _approve(address(0), tokenId);
2103 
2104         _balances[from] -= 1;
2105         _balances[to] += 1;
2106         _owners[tokenId] = to;
2107 
2108         emit Transfer(from, to, tokenId);
2109 
2110         _afterTokenTransfer(from, to, tokenId);
2111     }
2112 
2113     /**
2114      * @dev Approve `to` to operate on `tokenId`
2115      *
2116      * Emits an {Approval} event.
2117      */
2118     function _approve(address to, uint256 tokenId) internal virtual {
2119         _tokenApprovals[tokenId] = to;
2120         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
2121     }
2122 
2123     /**
2124      * @dev Approve `operator` to operate on all of `owner` tokens
2125      *
2126      * Emits an {ApprovalForAll} event.
2127      */
2128     function _setApprovalForAll(
2129         address owner,
2130         address operator,
2131         bool approved
2132     ) internal virtual {
2133         require(owner != operator, "ERC721: approve to caller");
2134         _operatorApprovals[owner][operator] = approved;
2135         emit ApprovalForAll(owner, operator, approved);
2136     }
2137 
2138     /**
2139      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2140      * The call is not executed if the target address is not a contract.
2141      *
2142      * @param from address representing the previous owner of the given token ID
2143      * @param to target address that will receive the tokens
2144      * @param tokenId uint256 ID of the token to be transferred
2145      * @param data bytes optional data to send along with the call
2146      * @return bool whether the call correctly returned the expected magic value
2147      */
2148     function _checkOnERC721Received(
2149         address from,
2150         address to,
2151         uint256 tokenId,
2152         bytes memory data
2153     ) private returns (bool) {
2154         if (to.isContract()) {
2155             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
2156                 return retval == IERC721Receiver.onERC721Received.selector;
2157             } catch (bytes memory reason) {
2158                 if (reason.length == 0) {
2159                     revert("ERC721: transfer to non ERC721Receiver implementer");
2160                 } else {
2161                     assembly {
2162                         revert(add(32, reason), mload(reason))
2163                     }
2164                 }
2165             }
2166         } else {
2167             return true;
2168         }
2169     }
2170 
2171     /**
2172      * @dev Hook that is called before any token transfer. This includes minting
2173      * and burning.
2174      *
2175      * Calling conditions:
2176      *
2177      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2178      * transferred to `to`.
2179      * - When `from` is zero, `tokenId` will be minted for `to`.
2180      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2181      * - `from` and `to` are never both zero.
2182      *
2183      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2184      */
2185     function _beforeTokenTransfer(
2186         address from,
2187         address to,
2188         uint256 tokenId
2189     ) internal virtual {}
2190 
2191     /**
2192      * @dev Hook that is called after any transfer of tokens. This includes
2193      * minting and burning.
2194      *
2195      * Calling conditions:
2196      *
2197      * - when `from` and `to` are both non-zero.
2198      * - `from` and `to` are never both zero.
2199      *
2200      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2201      */
2202     function _afterTokenTransfer(
2203         address from,
2204         address to,
2205         uint256 tokenId
2206     ) internal virtual {}
2207 }
2208 
2209 
2210 pragma solidity ^0.8.0;
2211 
2212 
2213 contract Oddities is ERC721A, Ownable {
2214 
2215     using Strings for uint256;
2216 
2217     string private baseURI;
2218 
2219     uint256 public price = 0.005 ether;
2220 
2221     uint256 public maxPerTx = 10;
2222 
2223     uint256 public maxFreePerWallet = 3;
2224 
2225     uint256 public totalFree = 900;
2226 
2227     uint256 public maxSupply = 3333;
2228 
2229     bool public mintEnabled = true;
2230 
2231     mapping(address => uint256) private _mintedFreeAmount;
2232 
2233     constructor() ERC721A("Oddities", "Odd") {
2234         _safeMint(msg.sender, 5);
2235         setBaseURI("ipfs://QmPD39kJQFfg9HyzRiSsdfkGrSr1HVA44ZFGt9UF67CjDM/");
2236     }
2237 
2238     function mint(uint256 count) external payable {
2239         uint256 cost = price;
2240         bool isFree = ((totalSupply() + count < totalFree + 1) &&
2241             (_mintedFreeAmount[msg.sender] + count <= maxFreePerWallet));
2242 
2243         if (isFree) {
2244             cost = 0;
2245         }
2246 
2247         require(msg.value >= count * cost, "Please send the exact amount.");
2248         require(totalSupply() + count < maxSupply + 1, "No more");
2249         require(mintEnabled, "Minting is not live yet");
2250         require(count < maxPerTx + 1, "Max per TX reached.");
2251 
2252         if (isFree) {
2253             _mintedFreeAmount[msg.sender] += count;
2254         }
2255 
2256         _safeMint(msg.sender, count);
2257     }
2258 
2259     function _baseURI() internal view virtual override returns (string memory) {
2260         return baseURI;
2261     }
2262 
2263     function tokenURI(uint256 tokenId)
2264         public
2265         view
2266         virtual
2267         override
2268         returns (string memory)
2269     {
2270         require(
2271             _exists(tokenId),
2272             "ERC721Metadata: URI query for nonexistent token"
2273         );
2274         return string(abi.encodePacked(baseURI, tokenId.toString(), ""));
2275     }
2276 
2277     function setBaseURI(string memory uri) public onlyOwner {
2278         baseURI = uri;
2279     }
2280 
2281     function setFreeAmount(uint256 amount) external onlyOwner {
2282         totalFree = amount;
2283     }
2284 
2285     function setPrice(uint256 _newPrice) external onlyOwner {
2286         price = _newPrice;
2287     }
2288 
2289     function flipSale() external onlyOwner {
2290         mintEnabled = !mintEnabled;
2291     }
2292 
2293     function withdraw() external onlyOwner {
2294         (bool success, ) = payable(msg.sender).call{
2295             value: address(this).balance
2296         }("");
2297         require(success, "Transfer failed.");
2298     }
2299 }