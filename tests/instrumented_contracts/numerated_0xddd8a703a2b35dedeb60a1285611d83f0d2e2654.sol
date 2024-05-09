1 // File: Space Punks/Space Punks.sol
2 
3 /**
4  *Submitted for verification at Etherscan.io on 2022-09-25
5 */
6 
7 
8 // ERC721A Contracts v3.3.0
9 // Creator: Chiru Labs
10 
11 pragma solidity ^0.8.4;
12 
13 /**
14  * @dev Interface of an ERC721A compliant contract.
15  */
16 interface IERC721A {
17     /**
18      * The caller must own the token or be an approved operator.
19      */
20     error ApprovalCallerNotOwnerNorApproved();
21 
22     /**
23      * The token does not exist.
24      */
25     error ApprovalQueryForNonexistentToken();
26 
27     /**
28      * The caller cannot approve to their own address.
29      */
30     error ApproveToCaller();
31 
32     /**
33      * The caller cannot approve to the current owner.
34      */
35     error ApprovalToCurrentOwner();
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
82     struct TokenOwnership {
83         // The address of the owner.
84         address addr;
85         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
86         uint64 startTimestamp;
87         // Whether the token has been burned.
88         bool burned;
89     }
90 
91     /**
92      * @dev Returns the total amount of tokens stored by the contract.
93      *
94      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
95      */
96     function totalSupply() external view returns (uint256);
97 
98     // ==============================
99     //            IERC165
100     // ==============================
101 
102     /**
103      * @dev Returns true if this contract implements the interface defined by
104      * `interfaceId`. See the corresponding
105      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
106      * to learn more about how these ids are created.
107      *
108      * This function call must use less than 30 000 gas.
109      */
110     function supportsInterface(bytes4 interfaceId) external view returns (bool);
111 
112     // ==============================
113     //            IERC721
114     // ==============================
115 
116     /**
117      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
118      */
119     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
120 
121     /**
122      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
123      */
124     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
125 
126     /**
127      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
128      */
129     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
130 
131     /**
132      * @dev Returns the number of tokens in ``owner``'s account.
133      */
134     function balanceOf(address owner) external view returns (uint256 balance);
135 
136     /**
137      * @dev Returns the owner of the `tokenId` token.
138      *
139      * Requirements:
140      *
141      * - `tokenId` must exist.
142      */
143     function ownerOf(uint256 tokenId) external view returns (address owner);
144 
145     /**
146      * @dev Safely transfers `tokenId` token from `from` to `to`.
147      *
148      * Requirements:
149      *
150      * - `from` cannot be the zero address.
151      * - `to` cannot be the zero address.
152      * - `tokenId` token must exist and be owned by `from`.
153      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
154      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
155      *
156      * Emits a {Transfer} event.
157      */
158     function safeTransferFrom(
159         address from,
160         address to,
161         uint256 tokenId,
162         bytes calldata data
163     ) external;
164 
165     /**
166      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
167      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
168      *
169      * Requirements:
170      *
171      * - `from` cannot be the zero address.
172      * - `to` cannot be the zero address.
173      * - `tokenId` token must exist and be owned by `from`.
174      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
175      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
176      *
177      * Emits a {Transfer} event.
178      */
179     function safeTransferFrom(
180         address from,
181         address to,
182         uint256 tokenId
183     ) external;
184 
185     /**
186      * @dev Transfers `tokenId` token from `from` to `to`.
187      *
188      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
189      *
190      * Requirements:
191      *
192      * - `from` cannot be the zero address.
193      * - `to` cannot be the zero address.
194      * - `tokenId` token must be owned by `from`.
195      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
196      *
197      * Emits a {Transfer} event.
198      */
199     function transferFrom(
200         address from,
201         address to,
202         uint256 tokenId
203     ) external;
204 
205     /**
206      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
207      * The approval is cleared when the token is transferred.
208      *
209      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
210      *
211      * Requirements:
212      *
213      * - The caller must own the token or be an approved operator.
214      * - `tokenId` must exist.
215      *
216      * Emits an {Approval} event.
217      */
218     function approve(address to, uint256 tokenId) external;
219 
220     /**
221      * @dev Approve or remove `operator` as an operator for the caller.
222      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
223      *
224      * Requirements:
225      *
226      * - The `operator` cannot be the caller.
227      *
228      * Emits an {ApprovalForAll} event.
229      */
230     function setApprovalForAll(address operator, bool _approved) external;
231 
232     /**
233      * @dev Returns the account approved for `tokenId` token.
234      *
235      * Requirements:
236      *
237      * - `tokenId` must exist.
238      */
239     function getApproved(uint256 tokenId) external view returns (address operator);
240 
241     /**
242      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
243      *
244      * See {setApprovalForAll}
245      */
246     function isApprovedForAll(address owner, address operator) external view returns (bool);
247 
248     // ==============================
249     //        IERC721Metadata
250     // ==============================
251 
252     /**
253      * @dev Returns the token collection name.
254      */
255     function name() external view returns (string memory);
256 
257     /**
258      * @dev Returns the token collection symbol.
259      */
260     function symbol() external view returns (string memory);
261 
262     /**
263      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
264      */
265     function tokenURI(uint256 tokenId) external view returns (string memory);
266 }
267 
268 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol
269 
270 
271 // ERC721A Contracts v3.3.0
272 // Creator: Chiru Labs
273 
274 pragma solidity ^0.8.4;
275 
276 
277 /**
278  * @dev ERC721 token receiver interface.
279  */
280 interface ERC721A__IERC721Receiver {
281     function onERC721Received(
282         address operator,
283         address from,
284         uint256 tokenId,
285         bytes calldata data
286     ) external returns (bytes4);
287 }
288 
289 /**
290  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
291  * the Metadata extension. Built to optimize for lower gas during batch mints.
292  *
293  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
294  *
295  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
296  *
297  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
298  */
299 contract ERC721A is IERC721A {
300     // Mask of an entry in packed address data.
301     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
302 
303     // The bit position of `numberMinted` in packed address data.
304     uint256 private constant BITPOS_NUMBER_MINTED = 64;
305 
306     // The bit position of `numberBurned` in packed address data.
307     uint256 private constant BITPOS_NUMBER_BURNED = 128;
308 
309     // The bit position of `aux` in packed address data.
310     uint256 private constant BITPOS_AUX = 192;
311 
312     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
313     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
314 
315     // The bit position of `startTimestamp` in packed ownership.
316     uint256 private constant BITPOS_START_TIMESTAMP = 160;
317 
318     // The bit mask of the `burned` bit in packed ownership.
319     uint256 private constant BITMASK_BURNED = 1 << 224;
320     
321     // The bit position of the `nextInitialized` bit in packed ownership.
322     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
323 
324     // The bit mask of the `nextInitialized` bit in packed ownership.
325     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
326 
327     // The tokenId of the next token to be minted.
328     uint256 private _currentIndex;
329 
330     // The number of tokens burned.
331     uint256 private _burnCounter;
332 
333     // Token name
334     string private _name;
335 
336     // Token symbol
337     string private _symbol;
338 
339     // Mapping from token ID to ownership details
340     // An empty struct value does not necessarily mean the token is unowned.
341     // See `_packedOwnershipOf` implementation for details.
342     //
343     // Bits Layout:
344     // - [0..159]   `addr`
345     // - [160..223] `startTimestamp`
346     // - [224]      `burned`
347     // - [225]      `nextInitialized`
348     mapping(uint256 => uint256) private _packedOwnerships;
349 
350     // Mapping owner address to address data.
351     //
352     // Bits Layout:
353     // - [0..63]    `balance`
354     // - [64..127]  `numberMinted`
355     // - [128..191] `numberBurned`
356     // - [192..255] `aux`
357     mapping(address => uint256) private _packedAddressData;
358 
359     // Mapping from token ID to approved address.
360     mapping(uint256 => address) private _tokenApprovals;
361 
362     // Mapping from owner to operator approvals
363     mapping(address => mapping(address => bool)) private _operatorApprovals;
364 
365     constructor(string memory name_, string memory symbol_) {
366         _name = name_;
367         _symbol = symbol_;
368         _currentIndex = _startTokenId();
369     }
370 
371     /**
372      * @dev Returns the starting token ID. 
373      * To change the starting token ID, please override this function.
374      */
375     function _startTokenId() internal view virtual returns (uint256) {
376         return 0;
377     }
378 
379     /**
380      * @dev Returns the next token ID to be minted.
381      */
382     function _nextTokenId() internal view returns (uint256) {
383         return _currentIndex;
384     }
385 
386     /**
387      * @dev Returns the total number of tokens in existence.
388      * Burned tokens will reduce the count. 
389      * To get the total number of tokens minted, please see `_totalMinted`.
390      */
391     function totalSupply() public view override returns (uint256) {
392         // Counter underflow is impossible as _burnCounter cannot be incremented
393         // more than `_currentIndex - _startTokenId()` times.
394         unchecked {
395             return _currentIndex - _burnCounter - _startTokenId();
396         }
397     }
398 
399     /**
400      * @dev Returns the total amount of tokens minted in the contract.
401      */
402     function _totalMinted() internal view returns (uint256) {
403         // Counter underflow is impossible as _currentIndex does not decrement,
404         // and it is initialized to `_startTokenId()`
405         unchecked {
406             return _currentIndex - _startTokenId();
407         }
408     }
409 
410     /**
411      * @dev Returns the total number of tokens burned.
412      */
413     function _totalBurned() internal view returns (uint256) {
414         return _burnCounter;
415     }
416 
417     /**
418      * @dev See {IERC165-supportsInterface}.
419      */
420     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
421         // The interface IDs are constants representing the first 4 bytes of the XOR of
422         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
423         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
424         return
425             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
426             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
427             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
428     }
429 
430     /**
431      * @dev See {IERC721-balanceOf}.
432      */
433     function balanceOf(address owner) public view override returns (uint256) {
434         if (owner == address(0)) revert BalanceQueryForZeroAddress();
435         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
436     }
437 
438     /**
439      * Returns the number of tokens minted by `owner`.
440      */
441     function _numberMinted(address owner) internal view returns (uint256) {
442         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
443     }
444 
445     /**
446      * Returns the number of tokens burned by or on behalf of `owner`.
447      */
448     function _numberBurned(address owner) internal view returns (uint256) {
449         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
450     }
451 
452     /**
453      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
454      */
455     function _getAux(address owner) internal view returns (uint64) {
456         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
457     }
458 
459     /**
460      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
461      * If there are multiple variables, please pack them into a uint64.
462      */
463     function _setAux(address owner, uint64 aux) internal {
464         uint256 packed = _packedAddressData[owner];
465         uint256 auxCasted;
466         assembly { // Cast aux without masking.
467             auxCasted := aux
468         }
469         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
470         _packedAddressData[owner] = packed;
471     }
472 
473     /**
474      * Returns the packed ownership data of `tokenId`.
475      */
476     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
477         uint256 curr = tokenId;
478 
479         unchecked {
480             if (_startTokenId() <= curr)
481                 if (curr < _currentIndex) {
482                     uint256 packed = _packedOwnerships[curr];
483                     // If not burned.
484                     if (packed & BITMASK_BURNED == 0) {
485                         // Invariant:
486                         // There will always be an ownership that has an address and is not burned
487                         // before an ownership that does not have an address and is not burned.
488                         // Hence, curr will not underflow.
489                         //
490                         // We can directly compare the packed value.
491                         // If the address is zero, packed is zero.
492                         while (packed == 0) {
493                             packed = _packedOwnerships[--curr];
494                         }
495                         return packed;
496                     }
497                 }
498         }
499         revert OwnerQueryForNonexistentToken();
500     }
501 
502     /**
503      * Returns the unpacked `TokenOwnership` struct from `packed`.
504      */
505     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
506         ownership.addr = address(uint160(packed));
507         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
508         ownership.burned = packed & BITMASK_BURNED != 0;
509     }
510 
511     /**
512      * Returns the unpacked `TokenOwnership` struct at `index`.
513      */
514     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
515         return _unpackedOwnership(_packedOwnerships[index]);
516     }
517 
518     /**
519      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
520      */
521     function _initializeOwnershipAt(uint256 index) internal {
522         if (_packedOwnerships[index] == 0) {
523             _packedOwnerships[index] = _packedOwnershipOf(index);
524         }
525     }
526 
527     /**
528      * Gas spent here starts off proportional to the maximum mint batch size.
529      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
530      */
531     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
532         return _unpackedOwnership(_packedOwnershipOf(tokenId));
533     }
534 
535     /**
536      * @dev See {IERC721-ownerOf}.
537      */
538     function ownerOf(uint256 tokenId) public view override returns (address) {
539         return address(uint160(_packedOwnershipOf(tokenId)));
540     }
541 
542     /**
543      * @dev See {IERC721Metadata-name}.
544      */
545     function name() public view virtual override returns (string memory) {
546         return _name;
547     }
548 
549     /**
550      * @dev See {IERC721Metadata-symbol}.
551      */
552     function symbol() public view virtual override returns (string memory) {
553         return _symbol;
554     }
555 
556     /**
557      * @dev See {IERC721Metadata-tokenURI}.
558      */
559     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
560         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
561 
562         string memory baseURI = _baseURI();
563         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
564     }
565 
566     /**
567      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
568      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
569      * by default, can be overriden in child contracts.
570      */
571     function _baseURI() internal view virtual returns (string memory) {
572         return '';
573     }
574 
575     /**
576      * @dev Casts the address to uint256 without masking.
577      */
578     function _addressToUint256(address value) private pure returns (uint256 result) {
579         assembly {
580             result := value
581         }
582     }
583 
584     /**
585      * @dev Casts the boolean to uint256 without branching.
586      */
587     function _boolToUint256(bool value) private pure returns (uint256 result) {
588         assembly {
589             result := value
590         }
591     }
592 
593     /**
594      * @dev See {IERC721-approve}.
595      */
596     function approve(address to, uint256 tokenId) public override {
597         address owner = address(uint160(_packedOwnershipOf(tokenId)));
598         if (to == owner) revert ApprovalToCurrentOwner();
599 
600         if (_msgSenderERC721A() != owner)
601             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
602                 revert ApprovalCallerNotOwnerNorApproved();
603             }
604 
605         _tokenApprovals[tokenId] = to;
606         emit Approval(owner, to, tokenId);
607     }
608 
609     /**
610      * @dev See {IERC721-getApproved}.
611      */
612     function getApproved(uint256 tokenId) public view override returns (address) {
613         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
614 
615         return _tokenApprovals[tokenId];
616     }
617 
618     /**
619      * @dev See {IERC721-setApprovalForAll}.
620      */
621     function setApprovalForAll(address operator, bool approved) public virtual override {
622         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
623 
624         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
625         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
626     }
627 
628     /**
629      * @dev See {IERC721-isApprovedForAll}.
630      */
631     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
632         return _operatorApprovals[owner][operator];
633     }
634 
635     /**
636      * @dev See {IERC721-transferFrom}.
637      */
638     function transferFrom(
639         address from,
640         address to,
641         uint256 tokenId
642     ) public virtual override {
643         _transfer(from, to, tokenId);
644     }
645 
646     /**
647      * @dev See {IERC721-safeTransferFrom}.
648      */
649     function safeTransferFrom(
650         address from,
651         address to,
652         uint256 tokenId
653     ) public virtual override {
654         safeTransferFrom(from, to, tokenId, '');
655     }
656 
657     /**
658      * @dev See {IERC721-safeTransferFrom}.
659      */
660     function safeTransferFrom(
661         address from,
662         address to,
663         uint256 tokenId,
664         bytes memory _data
665     ) public virtual override {
666         _transfer(from, to, tokenId);
667         if (to.code.length != 0)
668             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
669                 revert TransferToNonERC721ReceiverImplementer();
670             }
671     }
672 
673     /**
674      * @dev Returns whether `tokenId` exists.
675      *
676      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
677      *
678      * Tokens start existing when they are minted (`_mint`),
679      */
680     function _exists(uint256 tokenId) internal view returns (bool) {
681         return
682             _startTokenId() <= tokenId &&
683             tokenId < _currentIndex && // If within bounds,
684             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
685     }
686 
687     /**
688      * @dev Equivalent to `_safeMint(to, quantity, '')`.
689      */
690     function _safeMint(address to, uint256 quantity) internal {
691         _safeMint(to, quantity, '');
692     }
693 
694     /**
695      * @dev Safely mints `quantity` tokens and transfers them to `to`.
696      *
697      * Requirements:
698      *
699      * - If `to` refers to a smart contract, it must implement
700      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
701      * - `quantity` must be greater than 0.
702      *
703      * Emits a {Transfer} event.
704      */
705     function _safeMint(
706         address to,
707         uint256 quantity,
708         bytes memory _data
709     ) internal {
710         uint256 startTokenId = _currentIndex;
711         if (to == address(0)) revert MintToZeroAddress();
712         if (quantity == 0) revert MintZeroQuantity();
713 
714         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
715 
716         // Overflows are incredibly unrealistic.
717         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
718         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
719         unchecked {
720             // Updates:
721             // - `balance += quantity`.
722             // - `numberMinted += quantity`.
723             //
724             // We can directly add to the balance and number minted.
725             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
726 
727             // Updates:
728             // - `address` to the owner.
729             // - `startTimestamp` to the timestamp of minting.
730             // - `burned` to `false`.
731             // - `nextInitialized` to `quantity == 1`.
732             _packedOwnerships[startTokenId] =
733                 _addressToUint256(to) |
734                 (block.timestamp << BITPOS_START_TIMESTAMP) |
735                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
736 
737             uint256 updatedIndex = startTokenId;
738             uint256 end = updatedIndex + quantity;
739 
740             if (to.code.length != 0) {
741                 do {
742                     emit Transfer(address(0), to, updatedIndex);
743                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
744                         revert TransferToNonERC721ReceiverImplementer();
745                     }
746                 } while (updatedIndex < end);
747                 // Reentrancy protection
748                 if (_currentIndex != startTokenId) revert();
749             } else {
750                 do {
751                     emit Transfer(address(0), to, updatedIndex++);
752                 } while (updatedIndex < end);
753             }
754             _currentIndex = updatedIndex;
755         }
756         _afterTokenTransfers(address(0), to, startTokenId, quantity);
757     }
758 
759     /**
760      * @dev Mints `quantity` tokens and transfers them to `to`.
761      *
762      * Requirements:
763      *
764      * - `to` cannot be the zero address.
765      * - `quantity` must be greater than 0.
766      *
767      * Emits a {Transfer} event.
768      */
769     function _mint(address to, uint256 quantity) internal {
770         uint256 startTokenId = _currentIndex;
771         if (to == address(0)) revert MintToZeroAddress();
772         if (quantity == 0) revert MintZeroQuantity();
773 
774         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
775 
776         // Overflows are incredibly unrealistic.
777         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
778         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
779         unchecked {
780             // Updates:
781             // - `balance += quantity`.
782             // - `numberMinted += quantity`.
783             //
784             // We can directly add to the balance and number minted.
785             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
786 
787             // Updates:
788             // - `address` to the owner.
789             // - `startTimestamp` to the timestamp of minting.
790             // - `burned` to `false`.
791             // - `nextInitialized` to `quantity == 1`.
792             _packedOwnerships[startTokenId] =
793                 _addressToUint256(to) |
794                 (block.timestamp << BITPOS_START_TIMESTAMP) |
795                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
796 
797             uint256 updatedIndex = startTokenId;
798             uint256 end = updatedIndex + quantity;
799 
800             do {
801                 emit Transfer(address(0), to, updatedIndex++);
802             } while (updatedIndex < end);
803 
804             _currentIndex = updatedIndex;
805         }
806         _afterTokenTransfers(address(0), to, startTokenId, quantity);
807     }
808 
809     /**
810      * @dev Transfers `tokenId` from `from` to `to`.
811      *
812      * Requirements:
813      *
814      * - `to` cannot be the zero address.
815      * - `tokenId` token must be owned by `from`.
816      *
817      * Emits a {Transfer} event.
818      */
819     function _transfer(
820         address from,
821         address to,
822         uint256 tokenId
823     ) private {
824         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
825 
826         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
827 
828         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
829             isApprovedForAll(from, _msgSenderERC721A()) ||
830             getApproved(tokenId) == _msgSenderERC721A());
831 
832         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
833         if (to == address(0)) revert TransferToZeroAddress();
834 
835         _beforeTokenTransfers(from, to, tokenId, 1);
836 
837         // Clear approvals from the previous owner.
838         delete _tokenApprovals[tokenId];
839 
840         // Underflow of the sender's balance is impossible because we check for
841         // ownership above and the recipient's balance can't realistically overflow.
842         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
843         unchecked {
844             // We can directly increment and decrement the balances.
845             --_packedAddressData[from]; // Updates: `balance -= 1`.
846             ++_packedAddressData[to]; // Updates: `balance += 1`.
847 
848             // Updates:
849             // - `address` to the next owner.
850             // - `startTimestamp` to the timestamp of transfering.
851             // - `burned` to `false`.
852             // - `nextInitialized` to `true`.
853             _packedOwnerships[tokenId] =
854                 _addressToUint256(to) |
855                 (block.timestamp << BITPOS_START_TIMESTAMP) |
856                 BITMASK_NEXT_INITIALIZED;
857 
858             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
859             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
860                 uint256 nextTokenId = tokenId + 1;
861                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
862                 if (_packedOwnerships[nextTokenId] == 0) {
863                     // If the next slot is within bounds.
864                     if (nextTokenId != _currentIndex) {
865                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
866                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
867                     }
868                 }
869             }
870         }
871 
872         emit Transfer(from, to, tokenId);
873         _afterTokenTransfers(from, to, tokenId, 1);
874     }
875 
876     /**
877      * @dev Equivalent to `_burn(tokenId, false)`.
878      */
879     function _burn(uint256 tokenId) internal virtual {
880         _burn(tokenId, false);
881     }
882 
883     /**
884      * @dev Destroys `tokenId`.
885      * The approval is cleared when the token is burned.
886      *
887      * Requirements:
888      *
889      * - `tokenId` must exist.
890      *
891      * Emits a {Transfer} event.
892      */
893     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
894         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
895 
896         address from = address(uint160(prevOwnershipPacked));
897 
898         if (approvalCheck) {
899             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
900                 isApprovedForAll(from, _msgSenderERC721A()) ||
901                 getApproved(tokenId) == _msgSenderERC721A());
902 
903             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
904         }
905 
906         _beforeTokenTransfers(from, address(0), tokenId, 1);
907 
908         // Clear approvals from the previous owner.
909         delete _tokenApprovals[tokenId];
910 
911         // Underflow of the sender's balance is impossible because we check for
912         // ownership above and the recipient's balance can't realistically overflow.
913         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
914         unchecked {
915             // Updates:
916             // - `balance -= 1`.
917             // - `numberBurned += 1`.
918             //
919             // We can directly decrement the balance, and increment the number burned.
920             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
921             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
922 
923             // Updates:
924             // - `address` to the last owner.
925             // - `startTimestamp` to the timestamp of burning.
926             // - `burned` to `true`.
927             // - `nextInitialized` to `true`.
928             _packedOwnerships[tokenId] =
929                 _addressToUint256(from) |
930                 (block.timestamp << BITPOS_START_TIMESTAMP) |
931                 BITMASK_BURNED | 
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
948         emit Transfer(from, address(0), tokenId);
949         _afterTokenTransfers(from, address(0), tokenId, 1);
950 
951         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
952         unchecked {
953             _burnCounter++;
954         }
955     }
956 
957     /**
958      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
959      *
960      * @param from address representing the previous owner of the given token ID
961      * @param to target address that will receive the tokens
962      * @param tokenId uint256 ID of the token to be transferred
963      * @param _data bytes optional data to send along with the call
964      * @return bool whether the call correctly returned the expected magic value
965      */
966     function _checkContractOnERC721Received(
967         address from,
968         address to,
969         uint256 tokenId,
970         bytes memory _data
971     ) private returns (bool) {
972         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
973             bytes4 retval
974         ) {
975             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
976         } catch (bytes memory reason) {
977             if (reason.length == 0) {
978                 revert TransferToNonERC721ReceiverImplementer();
979             } else {
980                 assembly {
981                     revert(add(32, reason), mload(reason))
982                 }
983             }
984         }
985     }
986 
987     /**
988      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
989      * And also called before burning one token.
990      *
991      * startTokenId - the first token id to be transferred
992      * quantity - the amount to be transferred
993      *
994      * Calling conditions:
995      *
996      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
997      * transferred to `to`.
998      * - When `from` is zero, `tokenId` will be minted for `to`.
999      * - When `to` is zero, `tokenId` will be burned by `from`.
1000      * - `from` and `to` are never both zero.
1001      */
1002     function _beforeTokenTransfers(
1003         address from,
1004         address to,
1005         uint256 startTokenId,
1006         uint256 quantity
1007     ) internal virtual {}
1008 
1009     /**
1010      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1011      * minting.
1012      * And also called after one token has been burned.
1013      *
1014      * startTokenId - the first token id to be transferred
1015      * quantity - the amount to be transferred
1016      *
1017      * Calling conditions:
1018      *
1019      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1020      * transferred to `to`.
1021      * - When `from` is zero, `tokenId` has been minted for `to`.
1022      * - When `to` is zero, `tokenId` has been burned by `from`.
1023      * - `from` and `to` are never both zero.
1024      */
1025     function _afterTokenTransfers(
1026         address from,
1027         address to,
1028         uint256 startTokenId,
1029         uint256 quantity
1030     ) internal virtual {}
1031 
1032     /**
1033      * @dev Returns the message sender (defaults to `msg.sender`).
1034      *
1035      * If you are writing GSN compatible contracts, you need to override this function.
1036      */
1037     function _msgSenderERC721A() internal view virtual returns (address) {
1038         return msg.sender;
1039     }
1040 
1041     /**
1042      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1043      */
1044     function _toString(uint256 value) internal pure returns (string memory ptr) {
1045         assembly {
1046             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1047             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1048             // We will need 1 32-byte word to store the length, 
1049             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1050             ptr := add(mload(0x40), 128)
1051             // Update the free memory pointer to allocate.
1052             mstore(0x40, ptr)
1053 
1054             // Cache the end of the memory to calculate the length later.
1055             let end := ptr
1056 
1057             // We write the string from the rightmost digit to the leftmost digit.
1058             // The following is essentially a do-while loop that also handles the zero case.
1059             // Costs a bit more than early returning for the zero case,
1060             // but cheaper in terms of deployment and overall runtime costs.
1061             for { 
1062                 // Initialize and perform the first pass without check.
1063                 let temp := value
1064                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1065                 ptr := sub(ptr, 1)
1066                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1067                 mstore8(ptr, add(48, mod(temp, 10)))
1068                 temp := div(temp, 10)
1069             } temp { 
1070                 // Keep dividing `temp` until zero.
1071                 temp := div(temp, 10)
1072             } { // Body of the for loop.
1073                 ptr := sub(ptr, 1)
1074                 mstore8(ptr, add(48, mod(temp, 10)))
1075             }
1076             
1077             let length := sub(end, ptr)
1078             // Move the pointer 32 bytes leftwards to make room for the length.
1079             ptr := sub(ptr, 32)
1080             // Store the length.
1081             mstore(ptr, length)
1082         }
1083     }
1084 }
1085 
1086 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
1087 
1088 
1089 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
1090 
1091 pragma solidity ^0.8.0;
1092 
1093 /**
1094  * @dev String operations.
1095  */
1096 library Strings {
1097     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1098     uint8 private constant _ADDRESS_LENGTH = 20;
1099 
1100     /**
1101      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1102      */
1103     function toString(uint256 value) internal pure returns (string memory) {
1104         // Inspired by OraclizeAPI's implementation - MIT licence
1105         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1106 
1107         if (value == 0) {
1108             return "0";
1109         }
1110         uint256 temp = value;
1111         uint256 digits;
1112         while (temp != 0) {
1113             digits++;
1114             temp /= 10;
1115         }
1116         bytes memory buffer = new bytes(digits);
1117         while (value != 0) {
1118             digits -= 1;
1119             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1120             value /= 10;
1121         }
1122         return string(buffer);
1123     }
1124 
1125     /**
1126      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1127      */
1128     function toHexString(uint256 value) internal pure returns (string memory) {
1129         if (value == 0) {
1130             return "0x00";
1131         }
1132         uint256 temp = value;
1133         uint256 length = 0;
1134         while (temp != 0) {
1135             length++;
1136             temp >>= 8;
1137         }
1138         return toHexString(value, length);
1139     }
1140 
1141     /**
1142      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1143      */
1144     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1145         bytes memory buffer = new bytes(2 * length + 2);
1146         buffer[0] = "0";
1147         buffer[1] = "x";
1148         for (uint256 i = 2 * length + 1; i > 1; --i) {
1149             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1150             value >>= 4;
1151         }
1152         require(value == 0, "Strings: hex length insufficient");
1153         return string(buffer);
1154     }
1155 
1156     /**
1157      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1158      */
1159     function toHexString(address addr) internal pure returns (string memory) {
1160         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1161     }
1162 }
1163 
1164 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
1165 
1166 
1167 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1168 
1169 pragma solidity ^0.8.0;
1170 
1171 /**
1172  * @dev Provides information about the current execution context, including the
1173  * sender of the transaction and its data. While these are generally available
1174  * via msg.sender and msg.data, they should not be accessed in such a direct
1175  * manner, since when dealing with meta-transactions the account sending and
1176  * paying for execution may not be the actual sender (as far as an application
1177  * is concerned).
1178  *
1179  * This contract is only required for intermediate, library-like contracts.
1180  */
1181 abstract contract Context {
1182     function _msgSender() internal view virtual returns (address) {
1183         return msg.sender;
1184     }
1185 
1186     function _msgData() internal view virtual returns (bytes calldata) {
1187         return msg.data;
1188     }
1189 }
1190 
1191 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
1192 
1193 
1194 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1195 
1196 pragma solidity ^0.8.0;
1197 
1198 
1199 /**
1200  * @dev Contract module which provides a basic access control mechanism, where
1201  * there is an account (an owner) that can be granted exclusive access to
1202  * specific functions.
1203  *
1204  * By default, the owner account will be the one that deploys the contract. This
1205  * can later be changed with {transferOwnership}.
1206  *
1207  * This module is used through inheritance. It will make available the modifier
1208  * `onlyOwner`, which can be applied to your functions to restrict their use to
1209  * the owner.
1210  */
1211 abstract contract Ownable is Context {
1212     address private _owner;
1213 
1214     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1215 
1216     /**
1217      * @dev Initializes the contract setting the deployer as the initial owner.
1218      */
1219     constructor() {
1220         _transferOwnership(_msgSender());
1221     }
1222 
1223     /**
1224      * @dev Returns the address of the current owner.
1225      */
1226     function owner() public view virtual returns (address) {
1227         return _owner;
1228     }
1229 
1230     /**
1231      * @dev Throws if called by any account other than the owner.
1232      */
1233     modifier onlyOwner() {
1234         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1235         _;
1236     }
1237 
1238     /**
1239      * @dev Leaves the contract without owner. It will not be possible to call
1240      * `onlyOwner` functions anymore. Can only be called by the current owner.
1241      *
1242      * NOTE: Renouncing ownership will leave the contract without an owner,
1243      * thereby removing any functionality that is only available to the owner.
1244      */
1245     function renounceOwnership() public virtual onlyOwner {
1246         _transferOwnership(address(0));
1247     }
1248 
1249     /**
1250      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1251      * Can only be called by the current owner.
1252      */
1253     function transferOwnership(address newOwner) public virtual onlyOwner {
1254         require(newOwner != address(0), "Ownable: new owner is the zero address");
1255         _transferOwnership(newOwner);
1256     }
1257 
1258     /**
1259      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1260      * Internal function without access restriction.
1261      */
1262     function _transferOwnership(address newOwner) internal virtual {
1263         address oldOwner = _owner;
1264         _owner = newOwner;
1265         emit OwnershipTransferred(oldOwner, newOwner);
1266     }
1267 }
1268 
1269 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol
1270 
1271 
1272 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
1273 
1274 pragma solidity ^0.8.1;
1275 
1276 /**
1277  * @dev Collection of functions related to the address type
1278  */
1279 library Address {
1280     /**
1281      * @dev Returns true if `account` is a contract.
1282      *
1283      * [IMPORTANT]
1284      * ====
1285      * It is unsafe to assume that an address for which this function returns
1286      * false is an externally-owned account (EOA) and not a contract.
1287      *
1288      * Among others, `isContract` will return false for the following
1289      * types of addresses:
1290      *
1291      *  - an externally-owned account
1292      *  - a contract in construction
1293      *  - an address where a contract will be created
1294      *  - an address where a contract lived, but was destroyed
1295      * ====
1296      *
1297      * [IMPORTANT]
1298      * ====
1299      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1300      *
1301      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1302      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1303      * constructor.
1304      * ====
1305      */
1306     function isContract(address account) internal view returns (bool) {
1307         // This method relies on extcodesize/address.code.length, which returns 0
1308         // for contracts in construction, since the code is only stored at the end
1309         // of the constructor execution.
1310 
1311         return account.code.length > 0;
1312     }
1313 
1314     /**
1315      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1316      * `recipient`, forwarding all available gas and reverting on errors.
1317      *
1318      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1319      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1320      * imposed by `transfer`, making them unable to receive funds via
1321      * `transfer`. {sendValue} removes this limitation.
1322      *
1323      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1324      *
1325      * IMPORTANT: because control is transferred to `recipient`, care must be
1326      * taken to not create reentrancy vulnerabilities. Consider using
1327      * {ReentrancyGuard} or the
1328      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1329      */
1330     function sendValue(address payable recipient, uint256 amount) internal {
1331         require(address(this).balance >= amount, "Address: insufficient balance");
1332 
1333         (bool success, ) = recipient.call{value: amount}("");
1334         require(success, "Address: unable to send value, recipient may have reverted");
1335     }
1336 
1337     /**
1338      * @dev Performs a Solidity function call using a low level `call`. A
1339      * plain `call` is an unsafe replacement for a function call: use this
1340      * function instead.
1341      *
1342      * If `target` reverts with a revert reason, it is bubbled up by this
1343      * function (like regular Solidity function calls).
1344      *
1345      * Returns the raw returned data. To convert to the expected return value,
1346      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1347      *
1348      * Requirements:
1349      *
1350      * - `target` must be a contract.
1351      * - calling `target` with `data` must not revert.
1352      *
1353      * _Available since v3.1._
1354      */
1355     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1356         return functionCall(target, data, "Address: low-level call failed");
1357     }
1358 
1359     /**
1360      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1361      * `errorMessage` as a fallback revert reason when `target` reverts.
1362      *
1363      * _Available since v3.1._
1364      */
1365     function functionCall(
1366         address target,
1367         bytes memory data,
1368         string memory errorMessage
1369     ) internal returns (bytes memory) {
1370         return functionCallWithValue(target, data, 0, errorMessage);
1371     }
1372 
1373     /**
1374      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1375      * but also transferring `value` wei to `target`.
1376      *
1377      * Requirements:
1378      *
1379      * - the calling contract must have an ETH balance of at least `value`.
1380      * - the called Solidity function must be `payable`.
1381      *
1382      * _Available since v3.1._
1383      */
1384     function functionCallWithValue(
1385         address target,
1386         bytes memory data,
1387         uint256 value
1388     ) internal returns (bytes memory) {
1389         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1390     }
1391 
1392     /**
1393      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1394      * with `errorMessage` as a fallback revert reason when `target` reverts.
1395      *
1396      * _Available since v3.1._
1397      */
1398     function functionCallWithValue(
1399         address target,
1400         bytes memory data,
1401         uint256 value,
1402         string memory errorMessage
1403     ) internal returns (bytes memory) {
1404         require(address(this).balance >= value, "Address: insufficient balance for call");
1405         require(isContract(target), "Address: call to non-contract");
1406 
1407         (bool success, bytes memory returndata) = target.call{value: value}(data);
1408         return verifyCallResult(success, returndata, errorMessage);
1409     }
1410 
1411     /**
1412      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1413      * but performing a static call.
1414      *
1415      * _Available since v3.3._
1416      */
1417     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1418         return functionStaticCall(target, data, "Address: low-level static call failed");
1419     }
1420 
1421     /**
1422      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1423      * but performing a static call.
1424      *
1425      * _Available since v3.3._
1426      */
1427     function functionStaticCall(
1428         address target,
1429         bytes memory data,
1430         string memory errorMessage
1431     ) internal view returns (bytes memory) {
1432         require(isContract(target), "Address: static call to non-contract");
1433 
1434         (bool success, bytes memory returndata) = target.staticcall(data);
1435         return verifyCallResult(success, returndata, errorMessage);
1436     }
1437 
1438     /**
1439      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1440      * but performing a delegate call.
1441      *
1442      * _Available since v3.4._
1443      */
1444     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1445         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1446     }
1447 
1448     /**
1449      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1450      * but performing a delegate call.
1451      *
1452      * _Available since v3.4._
1453      */
1454     function functionDelegateCall(
1455         address target,
1456         bytes memory data,
1457         string memory errorMessage
1458     ) internal returns (bytes memory) {
1459         require(isContract(target), "Address: delegate call to non-contract");
1460 
1461         (bool success, bytes memory returndata) = target.delegatecall(data);
1462         return verifyCallResult(success, returndata, errorMessage);
1463     }
1464 
1465     /**
1466      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1467      * revert reason using the provided one.
1468      *
1469      * _Available since v4.3._
1470      */
1471     function verifyCallResult(
1472         bool success,
1473         bytes memory returndata,
1474         string memory errorMessage
1475     ) internal pure returns (bytes memory) {
1476         if (success) {
1477             return returndata;
1478         } else {
1479             // Look for revert reason and bubble it up if present
1480             if (returndata.length > 0) {
1481                 // The easiest way to bubble the revert reason is using memory via assembly
1482 
1483                 assembly {
1484                     let returndata_size := mload(returndata)
1485                     revert(add(32, returndata), returndata_size)
1486                 }
1487             } else {
1488                 revert(errorMessage);
1489             }
1490         }
1491     }
1492 }
1493 
1494 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721Receiver.sol
1495 
1496 
1497 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
1498 
1499 pragma solidity ^0.8.0;
1500 
1501 /**
1502  * @title ERC721 token receiver interface
1503  * @dev Interface for any contract that wants to support safeTransfers
1504  * from ERC721 asset contracts.
1505  */
1506 interface IERC721Receiver {
1507     /**
1508      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1509      * by `operator` from `from`, this function is called.
1510      *
1511      * It must return its Solidity selector to confirm the token transfer.
1512      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1513      *
1514      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
1515      */
1516     function onERC721Received(
1517         address operator,
1518         address from,
1519         uint256 tokenId,
1520         bytes calldata data
1521     ) external returns (bytes4);
1522 }
1523 
1524 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/IERC165.sol
1525 
1526 
1527 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1528 
1529 pragma solidity ^0.8.0;
1530 
1531 /**
1532  * @dev Interface of the ERC165 standard, as defined in the
1533  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1534  *
1535  * Implementers can declare support of contract interfaces, which can then be
1536  * queried by others ({ERC165Checker}).
1537  *
1538  * For an implementation, see {ERC165}.
1539  */
1540 interface IERC165 {
1541     /**
1542      * @dev Returns true if this contract implements the interface defined by
1543      * `interfaceId`. See the corresponding
1544      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1545      * to learn more about how these ids are created.
1546      *
1547      * This function call must use less than 30 000 gas.
1548      */
1549     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1550 }
1551 
1552 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/ERC165.sol
1553 
1554 
1555 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1556 
1557 pragma solidity ^0.8.0;
1558 
1559 
1560 /**
1561  * @dev Implementation of the {IERC165} interface.
1562  *
1563  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1564  * for the additional interface id that will be supported. For example:
1565  *
1566  * ```solidity
1567  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1568  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1569  * }
1570  * ```
1571  *
1572  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1573  */
1574 abstract contract ERC165 is IERC165 {
1575     /**
1576      * @dev See {IERC165-supportsInterface}.
1577      */
1578     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1579         return interfaceId == type(IERC165).interfaceId;
1580     }
1581 }
1582 
1583 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721.sol
1584 
1585 
1586 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
1587 
1588 pragma solidity ^0.8.0;
1589 
1590 
1591 /**
1592  * @dev Required interface of an ERC721 compliant contract.
1593  */
1594 interface IERC721 is IERC165 {
1595     /**
1596      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1597      */
1598     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1599 
1600     /**
1601      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1602      */
1603     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1604 
1605     /**
1606      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1607      */
1608     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1609 
1610     /**
1611      * @dev Returns the number of tokens in ``owner``'s account.
1612      */
1613     function balanceOf(address owner) external view returns (uint256 balance);
1614 
1615     /**
1616      * @dev Returns the owner of the `tokenId` token.
1617      *
1618      * Requirements:
1619      *
1620      * - `tokenId` must exist.
1621      */
1622     function ownerOf(uint256 tokenId) external view returns (address owner);
1623 
1624     /**
1625      * @dev Safely transfers `tokenId` token from `from` to `to`.
1626      *
1627      * Requirements:
1628      *
1629      * - `from` cannot be the zero address.
1630      * - `to` cannot be the zero address.
1631      * - `tokenId` token must exist and be owned by `from`.
1632      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1633      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1634      *
1635      * Emits a {Transfer} event.
1636      */
1637     function safeTransferFrom(
1638         address from,
1639         address to,
1640         uint256 tokenId,
1641         bytes calldata data
1642     ) external;
1643 
1644     /**
1645      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1646      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1647      *
1648      * Requirements:
1649      *
1650      * - `from` cannot be the zero address.
1651      * - `to` cannot be the zero address.
1652      * - `tokenId` token must exist and be owned by `from`.
1653      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1654      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1655      *
1656      * Emits a {Transfer} event.
1657      */
1658     function safeTransferFrom(
1659         address from,
1660         address to,
1661         uint256 tokenId
1662     ) external;
1663 
1664     /**
1665      * @dev Transfers `tokenId` token from `from` to `to`.
1666      *
1667      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1668      *
1669      * Requirements:
1670      *
1671      * - `from` cannot be the zero address.
1672      * - `to` cannot be the zero address.
1673      * - `tokenId` token must be owned by `from`.
1674      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1675      *
1676      * Emits a {Transfer} event.
1677      */
1678     function transferFrom(
1679         address from,
1680         address to,
1681         uint256 tokenId
1682     ) external;
1683 
1684     /**
1685      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1686      * The approval is cleared when the token is transferred.
1687      *
1688      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1689      *
1690      * Requirements:
1691      *
1692      * - The caller must own the token or be an approved operator.
1693      * - `tokenId` must exist.
1694      *
1695      * Emits an {Approval} event.
1696      */
1697     function approve(address to, uint256 tokenId) external;
1698 
1699     /**
1700      * @dev Approve or remove `operator` as an operator for the caller.
1701      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1702      *
1703      * Requirements:
1704      *
1705      * - The `operator` cannot be the caller.
1706      *
1707      * Emits an {ApprovalForAll} event.
1708      */
1709     function setApprovalForAll(address operator, bool _approved) external;
1710 
1711     /**
1712      * @dev Returns the account approved for `tokenId` token.
1713      *
1714      * Requirements:
1715      *
1716      * - `tokenId` must exist.
1717      */
1718     function getApproved(uint256 tokenId) external view returns (address operator);
1719 
1720     /**
1721      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1722      *
1723      * See {setApprovalForAll}
1724      */
1725     function isApprovedForAll(address owner, address operator) external view returns (bool);
1726 }
1727 
1728 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/IERC721Metadata.sol
1729 
1730 
1731 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1732 
1733 pragma solidity ^0.8.0;
1734 
1735 
1736 /**
1737  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1738  * @dev See https://eips.ethereum.org/EIPS/eip-721
1739  */
1740 interface IERC721Metadata is IERC721 {
1741     /**
1742      * @dev Returns the token collection name.
1743      */
1744     function name() external view returns (string memory);
1745 
1746     /**
1747      * @dev Returns the token collection symbol.
1748      */
1749     function symbol() external view returns (string memory);
1750 
1751     /**
1752      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1753      */
1754     function tokenURI(uint256 tokenId) external view returns (string memory);
1755 }
1756 
1757 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol
1758 
1759 
1760 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
1761 
1762 pragma solidity ^0.8.0;
1763 
1764 
1765 
1766 
1767 
1768 
1769 
1770 
1771 /**
1772  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1773  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1774  * {ERC721Enumerable}.
1775  */
1776 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1777     using Address for address;
1778     using Strings for uint256;
1779 
1780     // Token name
1781     string private _name;
1782 
1783     // Token symbol
1784     string private _symbol;
1785 
1786     // Mapping from token ID to owner address
1787     mapping(uint256 => address) private _owners;
1788 
1789     // Mapping owner address to token count
1790     mapping(address => uint256) private _balances;
1791 
1792     // Mapping from token ID to approved address
1793     mapping(uint256 => address) private _tokenApprovals;
1794 
1795     // Mapping from owner to operator approvals
1796     mapping(address => mapping(address => bool)) private _operatorApprovals;
1797 
1798     /**
1799      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1800      */
1801     constructor(string memory name_, string memory symbol_) {
1802         _name = name_;
1803         _symbol = symbol_;
1804     }
1805 
1806     /**
1807      * @dev See {IERC165-supportsInterface}.
1808      */
1809     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1810         return
1811             interfaceId == type(IERC721).interfaceId ||
1812             interfaceId == type(IERC721Metadata).interfaceId ||
1813             super.supportsInterface(interfaceId);
1814     }
1815 
1816     /**
1817      * @dev See {IERC721-balanceOf}.
1818      */
1819     function balanceOf(address owner) public view virtual override returns (uint256) {
1820         require(owner != address(0), "ERC721: address zero is not a valid owner");
1821         return _balances[owner];
1822     }
1823 
1824     /**
1825      * @dev See {IERC721-ownerOf}.
1826      */
1827     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1828         address owner = _owners[tokenId];
1829         require(owner != address(0), "ERC721: owner query for nonexistent token");
1830         return owner;
1831     }
1832 
1833     /**
1834      * @dev See {IERC721Metadata-name}.
1835      */
1836     function name() public view virtual override returns (string memory) {
1837         return _name;
1838     }
1839 
1840     /**
1841      * @dev See {IERC721Metadata-symbol}.
1842      */
1843     function symbol() public view virtual override returns (string memory) {
1844         return _symbol;
1845     }
1846 
1847     /**
1848      * @dev See {IERC721Metadata-tokenURI}.
1849      */
1850     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1851         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1852 
1853         string memory baseURI = _baseURI();
1854         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1855     }
1856 
1857     /**
1858      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1859      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1860      * by default, can be overridden in child contracts.
1861      */
1862     function _baseURI() internal view virtual returns (string memory) {
1863         return "";
1864     }
1865 
1866     /**
1867      * @dev See {IERC721-approve}.
1868      */
1869     function approve(address to, uint256 tokenId) public virtual override {
1870         address owner = ERC721.ownerOf(tokenId);
1871         require(to != owner, "ERC721: approval to current owner");
1872 
1873         require(
1874             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1875             "ERC721: approve caller is not owner nor approved for all"
1876         );
1877 
1878         _approve(to, tokenId);
1879     }
1880 
1881     /**
1882      * @dev See {IERC721-getApproved}.
1883      */
1884     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1885         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1886 
1887         return _tokenApprovals[tokenId];
1888     }
1889 
1890     /**
1891      * @dev See {IERC721-setApprovalForAll}.
1892      */
1893     function setApprovalForAll(address operator, bool approved) public virtual override {
1894         _setApprovalForAll(_msgSender(), operator, approved);
1895     }
1896 
1897     /**
1898      * @dev See {IERC721-isApprovedForAll}.
1899      */
1900     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1901         return _operatorApprovals[owner][operator];
1902     }
1903 
1904     /**
1905      * @dev See {IERC721-transferFrom}.
1906      */
1907     function transferFrom(
1908         address from,
1909         address to,
1910         uint256 tokenId
1911     ) public virtual override {
1912         //solhint-disable-next-line max-line-length
1913         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1914 
1915         _transfer(from, to, tokenId);
1916     }
1917 
1918     /**
1919      * @dev See {IERC721-safeTransferFrom}.
1920      */
1921     function safeTransferFrom(
1922         address from,
1923         address to,
1924         uint256 tokenId
1925     ) public virtual override {
1926         safeTransferFrom(from, to, tokenId, "");
1927     }
1928 
1929     /**
1930      * @dev See {IERC721-safeTransferFrom}.
1931      */
1932     function safeTransferFrom(
1933         address from,
1934         address to,
1935         uint256 tokenId,
1936         bytes memory data
1937     ) public virtual override {
1938         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1939         _safeTransfer(from, to, tokenId, data);
1940     }
1941 
1942     /**
1943      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1944      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1945      *
1946      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1947      *
1948      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1949      * implement alternative mechanisms to perform token transfer, such as signature-based.
1950      *
1951      * Requirements:
1952      *
1953      * - `from` cannot be the zero address.
1954      * - `to` cannot be the zero address.
1955      * - `tokenId` token must exist and be owned by `from`.
1956      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1957      *
1958      * Emits a {Transfer} event.
1959      */
1960     function _safeTransfer(
1961         address from,
1962         address to,
1963         uint256 tokenId,
1964         bytes memory data
1965     ) internal virtual {
1966         _transfer(from, to, tokenId);
1967         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1968     }
1969 
1970     /**
1971      * @dev Returns whether `tokenId` exists.
1972      *
1973      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1974      *
1975      * Tokens start existing when they are minted (`_mint`),
1976      * and stop existing when they are burned (`_burn`).
1977      */
1978     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1979         return _owners[tokenId] != address(0);
1980     }
1981 
1982     /**
1983      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1984      *
1985      * Requirements:
1986      *
1987      * - `tokenId` must exist.
1988      */
1989     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1990         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1991         address owner = ERC721.ownerOf(tokenId);
1992         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1993     }
1994 
1995     /**
1996      * @dev Safely mints `tokenId` and transfers it to `to`.
1997      *
1998      * Requirements:
1999      *
2000      * - `tokenId` must not exist.
2001      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2002      *
2003      * Emits a {Transfer} event.
2004      */
2005     function _safeMint(address to, uint256 tokenId) internal virtual {
2006         _safeMint(to, tokenId, "");
2007     }
2008 
2009     /**
2010      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
2011      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
2012      */
2013     function _safeMint(
2014         address to,
2015         uint256 tokenId,
2016         bytes memory data
2017     ) internal virtual {
2018         _mint(to, tokenId);
2019         require(
2020             _checkOnERC721Received(address(0), to, tokenId, data),
2021             "ERC721: transfer to non ERC721Receiver implementer"
2022         );
2023     }
2024 
2025     /**
2026      * @dev Mints `tokenId` and transfers it to `to`.
2027      *
2028      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
2029      *
2030      * Requirements:
2031      *
2032      * - `tokenId` must not exist.
2033      * - `to` cannot be the zero address.
2034      *
2035      * Emits a {Transfer} event.
2036      */
2037     function _mint(address to, uint256 tokenId) internal virtual {
2038         require(to != address(0), "ERC721: mint to the zero address");
2039         require(!_exists(tokenId), "ERC721: token already minted");
2040 
2041         _beforeTokenTransfer(address(0), to, tokenId);
2042 
2043         _balances[to] += 1;
2044         _owners[tokenId] = to;
2045 
2046         emit Transfer(address(0), to, tokenId);
2047 
2048         _afterTokenTransfer(address(0), to, tokenId);
2049     }
2050 
2051     /**
2052      * @dev Destroys `tokenId`.
2053      * The approval is cleared when the token is burned.
2054      *
2055      * Requirements:
2056      *
2057      * - `tokenId` must exist.
2058      *
2059      * Emits a {Transfer} event.
2060      */
2061     function _burn(uint256 tokenId) internal virtual {
2062         address owner = ERC721.ownerOf(tokenId);
2063 
2064         _beforeTokenTransfer(owner, address(0), tokenId);
2065 
2066         // Clear approvals
2067         _approve(address(0), tokenId);
2068 
2069         _balances[owner] -= 1;
2070         delete _owners[tokenId];
2071 
2072         emit Transfer(owner, address(0), tokenId);
2073 
2074         _afterTokenTransfer(owner, address(0), tokenId);
2075     }
2076 
2077     /**
2078      * @dev Transfers `tokenId` from `from` to `to`.
2079      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2080      *
2081      * Requirements:
2082      *
2083      * - `to` cannot be the zero address.
2084      * - `tokenId` token must be owned by `from`.
2085      *
2086      * Emits a {Transfer} event.
2087      */
2088     function _transfer(
2089         address from,
2090         address to,
2091         uint256 tokenId
2092     ) internal virtual {
2093         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
2094         require(to != address(0), "ERC721: transfer to the zero address");
2095 
2096         _beforeTokenTransfer(from, to, tokenId);
2097 
2098         // Clear approvals from the previous owner
2099         _approve(address(0), tokenId);
2100 
2101         _balances[from] -= 1;
2102         _balances[to] += 1;
2103         _owners[tokenId] = to;
2104 
2105         emit Transfer(from, to, tokenId);
2106 
2107         _afterTokenTransfer(from, to, tokenId);
2108     }
2109 
2110     /**
2111      * @dev Approve `to` to operate on `tokenId`
2112      *
2113      * Emits an {Approval} event.
2114      */
2115     function _approve(address to, uint256 tokenId) internal virtual {
2116         _tokenApprovals[tokenId] = to;
2117         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
2118     }
2119 
2120     /**
2121      * @dev Approve `operator` to operate on all of `owner` tokens
2122      *
2123      * Emits an {ApprovalForAll} event.
2124      */
2125     function _setApprovalForAll(
2126         address owner,
2127         address operator,
2128         bool approved
2129     ) internal virtual {
2130         require(owner != operator, "ERC721: approve to caller");
2131         _operatorApprovals[owner][operator] = approved;
2132         emit ApprovalForAll(owner, operator, approved);
2133     }
2134 
2135     /**
2136      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2137      * The call is not executed if the target address is not a contract.
2138      *
2139      * @param from address representing the previous owner of the given token ID
2140      * @param to target address that will receive the tokens
2141      * @param tokenId uint256 ID of the token to be transferred
2142      * @param data bytes optional data to send along with the call
2143      * @return bool whether the call correctly returned the expected magic value
2144      */
2145     function _checkOnERC721Received(
2146         address from,
2147         address to,
2148         uint256 tokenId,
2149         bytes memory data
2150     ) private returns (bool) {
2151         if (to.isContract()) {
2152             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
2153                 return retval == IERC721Receiver.onERC721Received.selector;
2154             } catch (bytes memory reason) {
2155                 if (reason.length == 0) {
2156                     revert("ERC721: transfer to non ERC721Receiver implementer");
2157                 } else {
2158                     assembly {
2159                         revert(add(32, reason), mload(reason))
2160                     }
2161                 }
2162             }
2163         } else {
2164             return true;
2165         }
2166     }
2167 
2168     /**
2169      * @dev Hook that is called before any token transfer. This includes minting
2170      * and burning.
2171      *
2172      * Calling conditions:
2173      *
2174      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2175      * transferred to `to`.
2176      * - When `from` is zero, `tokenId` will be minted for `to`.
2177      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2178      * - `from` and `to` are never both zero.
2179      *
2180      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2181      */
2182     function _beforeTokenTransfer(
2183         address from,
2184         address to,
2185         uint256 tokenId
2186     ) internal virtual {}
2187 
2188     /**
2189      * @dev Hook that is called after any transfer of tokens. This includes
2190      * minting and burning.
2191      *
2192      * Calling conditions:
2193      *
2194      * - when `from` and `to` are both non-zero.
2195      * - `from` and `to` are never both zero.
2196      *
2197      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2198      */
2199     function _afterTokenTransfer(
2200         address from,
2201         address to,
2202         uint256 tokenId
2203     ) internal virtual {}
2204 }
2205 
2206 
2207 pragma solidity ^0.8.0;
2208 
2209 
2210 contract SpacePunks is ERC721A, Ownable {
2211 
2212     using Strings for uint256;
2213 
2214     string private baseURI;
2215 
2216     uint256 public price = 0.001 ether;
2217 
2218     uint256 public maxPerTx = 20;
2219 
2220     uint256 public maxFreePerWallet = 5;
2221 
2222     uint256 public totalFree = 350;
2223 
2224     uint256 public maxSupply = 1111;
2225 
2226     bool public mintEnabled = true;
2227 
2228     mapping(address => uint256) private _mintedFreeAmount;
2229 
2230     constructor() ERC721A("Space-Punks", "SP") {
2231         _safeMint(msg.sender, 1);
2232         setBaseURI("https://ipfs.io/ipfs/QmQZ6xKXKPaMsXofcPNgucDDV14WA7vo8wbBVVeu4pdMbi/");
2233     }
2234 
2235     function mint(uint256 count) external payable {
2236         uint256 cost = price;
2237         bool isFree = ((totalSupply() + count < totalFree + 1) &&
2238             (_mintedFreeAmount[msg.sender] + count <= maxFreePerWallet));
2239 
2240         if (isFree) {
2241             cost = 0;
2242         }
2243 
2244         require(msg.value >= count * cost, "Please send the exact amount.");
2245         require(totalSupply() + count < maxSupply + 1, "No more");
2246         require(mintEnabled, "Minting is not live yet");
2247         require(count < maxPerTx + 1, "Max per TX reached.");
2248 
2249         if (isFree) {
2250             _mintedFreeAmount[msg.sender] += count;
2251         }
2252 
2253         _safeMint(msg.sender, count);
2254     }
2255 
2256     function _baseURI() internal view virtual override returns (string memory) {
2257         return baseURI;
2258     }
2259 
2260     function tokenURI(uint256 tokenId)
2261         public
2262         view
2263         virtual
2264         override
2265         returns (string memory)
2266     {
2267         require(
2268             _exists(tokenId),
2269             "ERC721Metadata: URI query for nonexistent token"
2270         );
2271         return string(abi.encodePacked(baseURI, tokenId.toString(), ""));
2272     }
2273 
2274     function setBaseURI(string memory uri) public onlyOwner {
2275         baseURI = uri;
2276     }
2277 
2278     function setFreeAmount(uint256 amount) external onlyOwner {
2279         totalFree = amount;
2280     }
2281 
2282     function setPrice(uint256 _newPrice) external onlyOwner {
2283         price = _newPrice;
2284     }
2285 
2286     function flipSale() external onlyOwner {
2287         mintEnabled = !mintEnabled;
2288     }
2289 
2290     function withdraw() external onlyOwner {
2291         (bool success, ) = payable(msg.sender).call{
2292             value: address(this).balance
2293         }("");
2294         require(success, "Transfer failed.");
2295     }
2296 }