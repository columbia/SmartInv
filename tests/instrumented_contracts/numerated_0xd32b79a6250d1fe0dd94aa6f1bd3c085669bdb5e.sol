1 /**
2  *Submitted for verification at Etherscan.io on 2022-06-04
3 */
4 
5 // File: erc721a/contracts/IERC721A.sol
6 
7 
8 // ERC721A Contracts v4.0.0
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
268 // File: erc721a/contracts/ERC721A.sol
269 
270 
271 // ERC721A Contracts v4.0.0
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
1086 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
1087 
1088 
1089 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
1090 
1091 pragma solidity ^0.8.0;
1092 
1093 // CAUTION
1094 // This version of SafeMath should only be used with Solidity 0.8 or later,
1095 // because it relies on the compiler's built in overflow checks.
1096 
1097 /**
1098  * @dev Wrappers over Solidity's arithmetic operations.
1099  *
1100  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
1101  * now has built in overflow checking.
1102  */
1103 library SafeMath {
1104     /**
1105      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1106      *
1107      * _Available since v3.4._
1108      */
1109     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1110         unchecked {
1111             uint256 c = a + b;
1112             if (c < a) return (false, 0);
1113             return (true, c);
1114         }
1115     }
1116 
1117     /**
1118      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
1119      *
1120      * _Available since v3.4._
1121      */
1122     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1123         unchecked {
1124             if (b > a) return (false, 0);
1125             return (true, a - b);
1126         }
1127     }
1128 
1129     /**
1130      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1131      *
1132      * _Available since v3.4._
1133      */
1134     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1135         unchecked {
1136             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1137             // benefit is lost if 'b' is also tested.
1138             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1139             if (a == 0) return (true, 0);
1140             uint256 c = a * b;
1141             if (c / a != b) return (false, 0);
1142             return (true, c);
1143         }
1144     }
1145 
1146     /**
1147      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1148      *
1149      * _Available since v3.4._
1150      */
1151     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1152         unchecked {
1153             if (b == 0) return (false, 0);
1154             return (true, a / b);
1155         }
1156     }
1157 
1158     /**
1159      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1160      *
1161      * _Available since v3.4._
1162      */
1163     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1164         unchecked {
1165             if (b == 0) return (false, 0);
1166             return (true, a % b);
1167         }
1168     }
1169 
1170     /**
1171      * @dev Returns the addition of two unsigned integers, reverting on
1172      * overflow.
1173      *
1174      * Counterpart to Solidity's `+` operator.
1175      *
1176      * Requirements:
1177      *
1178      * - Addition cannot overflow.
1179      */
1180     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1181         return a + b;
1182     }
1183 
1184     /**
1185      * @dev Returns the subtraction of two unsigned integers, reverting on
1186      * overflow (when the result is negative).
1187      *
1188      * Counterpart to Solidity's `-` operator.
1189      *
1190      * Requirements:
1191      *
1192      * - Subtraction cannot overflow.
1193      */
1194     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1195         return a - b;
1196     }
1197 
1198     /**
1199      * @dev Returns the multiplication of two unsigned integers, reverting on
1200      * overflow.
1201      *
1202      * Counterpart to Solidity's `*` operator.
1203      *
1204      * Requirements:
1205      *
1206      * - Multiplication cannot overflow.
1207      */
1208     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1209         return a * b;
1210     }
1211 
1212     /**
1213      * @dev Returns the integer division of two unsigned integers, reverting on
1214      * division by zero. The result is rounded towards zero.
1215      *
1216      * Counterpart to Solidity's `/` operator.
1217      *
1218      * Requirements:
1219      *
1220      * - The divisor cannot be zero.
1221      */
1222     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1223         return a / b;
1224     }
1225 
1226     /**
1227      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1228      * reverting when dividing by zero.
1229      *
1230      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1231      * opcode (which leaves remaining gas untouched) while Solidity uses an
1232      * invalid opcode to revert (consuming all remaining gas).
1233      *
1234      * Requirements:
1235      *
1236      * - The divisor cannot be zero.
1237      */
1238     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1239         return a % b;
1240     }
1241 
1242     /**
1243      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1244      * overflow (when the result is negative).
1245      *
1246      * CAUTION: This function is deprecated because it requires allocating memory for the error
1247      * message unnecessarily. For custom revert reasons use {trySub}.
1248      *
1249      * Counterpart to Solidity's `-` operator.
1250      *
1251      * Requirements:
1252      *
1253      * - Subtraction cannot overflow.
1254      */
1255     function sub(
1256         uint256 a,
1257         uint256 b,
1258         string memory errorMessage
1259     ) internal pure returns (uint256) {
1260         unchecked {
1261             require(b <= a, errorMessage);
1262             return a - b;
1263         }
1264     }
1265 
1266     /**
1267      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1268      * division by zero. The result is rounded towards zero.
1269      *
1270      * Counterpart to Solidity's `/` operator. Note: this function uses a
1271      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1272      * uses an invalid opcode to revert (consuming all remaining gas).
1273      *
1274      * Requirements:
1275      *
1276      * - The divisor cannot be zero.
1277      */
1278     function div(
1279         uint256 a,
1280         uint256 b,
1281         string memory errorMessage
1282     ) internal pure returns (uint256) {
1283         unchecked {
1284             require(b > 0, errorMessage);
1285             return a / b;
1286         }
1287     }
1288 
1289     /**
1290      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1291      * reverting with custom message when dividing by zero.
1292      *
1293      * CAUTION: This function is deprecated because it requires allocating memory for the error
1294      * message unnecessarily. For custom revert reasons use {tryMod}.
1295      *
1296      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1297      * opcode (which leaves remaining gas untouched) while Solidity uses an
1298      * invalid opcode to revert (consuming all remaining gas).
1299      *
1300      * Requirements:
1301      *
1302      * - The divisor cannot be zero.
1303      */
1304     function mod(
1305         uint256 a,
1306         uint256 b,
1307         string memory errorMessage
1308     ) internal pure returns (uint256) {
1309         unchecked {
1310             require(b > 0, errorMessage);
1311             return a % b;
1312         }
1313     }
1314 }
1315 
1316 // File: @openzeppelin/contracts/utils/Strings.sol
1317 
1318 
1319 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
1320 
1321 pragma solidity ^0.8.0;
1322 
1323 /**
1324  * @dev String operations.
1325  */
1326 library Strings {
1327     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1328 
1329     /**
1330      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1331      */
1332     function toString(uint256 value) internal pure returns (string memory) {
1333         // Inspired by OraclizeAPI's implementation - MIT licence
1334         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1335 
1336         if (value == 0) {
1337             return "0";
1338         }
1339         uint256 temp = value;
1340         uint256 digits;
1341         while (temp != 0) {
1342             digits++;
1343             temp /= 10;
1344         }
1345         bytes memory buffer = new bytes(digits);
1346         while (value != 0) {
1347             digits -= 1;
1348             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1349             value /= 10;
1350         }
1351         return string(buffer);
1352     }
1353 
1354     /**
1355      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1356      */
1357     function toHexString(uint256 value) internal pure returns (string memory) {
1358         if (value == 0) {
1359             return "0x00";
1360         }
1361         uint256 temp = value;
1362         uint256 length = 0;
1363         while (temp != 0) {
1364             length++;
1365             temp >>= 8;
1366         }
1367         return toHexString(value, length);
1368     }
1369 
1370     /**
1371      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1372      */
1373     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1374         bytes memory buffer = new bytes(2 * length + 2);
1375         buffer[0] = "0";
1376         buffer[1] = "x";
1377         for (uint256 i = 2 * length + 1; i > 1; --i) {
1378             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1379             value >>= 4;
1380         }
1381         require(value == 0, "Strings: hex length insufficient");
1382         return string(buffer);
1383     }
1384 }
1385 
1386 // File: @openzeppelin/contracts/utils/Context.sol
1387 
1388 
1389 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1390 
1391 pragma solidity ^0.8.0;
1392 
1393 /**
1394  * @dev Provides information about the current execution context, including the
1395  * sender of the transaction and its data. While these are generally available
1396  * via msg.sender and msg.data, they should not be accessed in such a direct
1397  * manner, since when dealing with meta-transactions the account sending and
1398  * paying for execution may not be the actual sender (as far as an application
1399  * is concerned).
1400  *
1401  * This contract is only required for intermediate, library-like contracts.
1402  */
1403 abstract contract Context {
1404     function _msgSender() internal view virtual returns (address) {
1405         return msg.sender;
1406     }
1407 
1408     function _msgData() internal view virtual returns (bytes calldata) {
1409         return msg.data;
1410     }
1411 }
1412 
1413 // File: @openzeppelin/contracts/access/Ownable.sol
1414 
1415 
1416 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1417 
1418 pragma solidity ^0.8.0;
1419 
1420 
1421 /**
1422  * @dev Contract module which provides a basic access control mechanism, where
1423  * there is an account (an owner) that can be granted exclusive access to
1424  * specific functions.
1425  *
1426  * By default, the owner account will be the one that deploys the contract. This
1427  * can later be changed with {transferOwnership}.
1428  *
1429  * This module is used through inheritance. It will make available the modifier
1430  * `onlyOwner`, which can be applied to your functions to restrict their use to
1431  * the owner.
1432  */
1433 abstract contract Ownable is Context {
1434     address private _owner;
1435 
1436     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1437 
1438     /**
1439      * @dev Initializes the contract setting the deployer as the initial owner.
1440      */
1441     constructor() {
1442         _transferOwnership(_msgSender());
1443     }
1444 
1445     /**
1446      * @dev Returns the address of the current owner.
1447      */
1448     function owner() public view virtual returns (address) {
1449         return _owner;
1450     }
1451 
1452     /**
1453      * @dev Throws if called by any account other than the owner.
1454      */
1455     modifier onlyOwner() {
1456         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1457         _;
1458     }
1459 
1460     /**
1461      * @dev Leaves the contract without owner. It will not be possible to call
1462      * `onlyOwner` functions anymore. Can only be called by the current owner.
1463      *
1464      * NOTE: Renouncing ownership will leave the contract without an owner,
1465      * thereby removing any functionality that is only available to the owner.
1466      */
1467     function renounceOwnership() public virtual onlyOwner {
1468         _transferOwnership(address(0));
1469     }
1470 
1471     /**
1472      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1473      * Can only be called by the current owner.
1474      */
1475     function transferOwnership(address newOwner) public virtual onlyOwner {
1476         require(newOwner != address(0), "Ownable: new owner is the zero address");
1477         _transferOwnership(newOwner);
1478     }
1479 
1480     /**
1481      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1482      * Internal function without access restriction.
1483      */
1484     function _transferOwnership(address newOwner) internal virtual {
1485         address oldOwner = _owner;
1486         _owner = newOwner;
1487         emit OwnershipTransferred(oldOwner, newOwner);
1488     }
1489 }
1490 
1491 // File: contracts/aidoitwtftown.sol
1492 
1493 
1494 
1495 
1496 
1497 
1498 pragma solidity ^0.8.7;
1499 
1500 //     _____  .___/\.__  .__        .___       .__  __   
1501 //    /  _  \ |   )/|  | |  |     __| _/____   |__|/  |_ 
1502 //   /  /_\  \|   | |  | |  |    / __ |/  _ \  |  \   __\
1503 //  /    |    \   | |  |_|  |__ / /_/ (  <_> ) |  ||  |  
1504 //  \____|__  /___| |____/____/ \____ |\____/  |__||__|  
1505 //          \/                       \/                
1506 
1507 contract ailldoitwtftown is ERC721A, Ownable {
1508     using SafeMath for uint256;
1509     using Strings for uint256;
1510 
1511     uint256 public maxPerTx = 10;
1512     uint256 public maxSupply = 1000;
1513     uint256 public freeMintMax = 1000; // Free supply
1514     uint256 public price = 0.002 ether;
1515     uint256 public maxFreePerWallet = 3; 
1516 
1517     string private baseURI = "";
1518     string public constant baseExtension = ".json";
1519 
1520     mapping(address => uint256) private _mintedFreeAmount; 
1521 
1522     bool public paused = true;
1523     bool public revealed = true;
1524     error freeMintIsOver();
1525 
1526     constructor() ERC721A("AIlldoitwtftown", "AILLDIWTFTOWN") {}
1527 
1528     function mint(uint256 count) external payable {
1529         uint256 cost = price;
1530         bool isFree = ((totalSupply() + count < freeMintMax + 1) &&
1531             (_mintedFreeAmount[msg.sender] + count <= maxFreePerWallet));
1532 
1533         if (isFree) {
1534             cost = 0;
1535         }
1536 
1537         require(!paused, "Contract Paused.");
1538         require(msg.value >= count * cost, "Please send the exact amount.");
1539         require(totalSupply() + count < maxSupply + 1, "No more");
1540         require(count < maxPerTx + 1, "Max per TX reached.");
1541 
1542         if (isFree) {
1543             _mintedFreeAmount[msg.sender] += count;
1544         }
1545 
1546         _safeMint(msg.sender, count);
1547     } 
1548 
1549     function devMint(uint256 _number) external onlyOwner {
1550         require(totalSupply() + _number <= maxSupply, "Minting would exceed maxSupply");
1551         _safeMint(_msgSender(), _number);
1552     }
1553 
1554     function setMaxFreeMintSupply(uint256 _max) public onlyOwner {
1555         freeMintMax = _max;
1556     }
1557 
1558     function setMaxPaidPerTx(uint256 _max) public onlyOwner {
1559         maxPerTx = _max;
1560     }
1561 
1562     function setMaxSupply(uint256 _max) public onlyOwner {
1563         maxSupply = _max;
1564     }
1565 
1566     function setMaxFreePerWallet(uint256 _max) external onlyOwner {
1567         maxFreePerWallet = _max;
1568     } 
1569 
1570     function reveal() public onlyOwner {
1571         revealed = true;
1572     }  
1573 
1574     function _startTokenId() internal override view virtual returns (uint256) {
1575         return 1;
1576     }
1577 
1578     function minted(address _owner) public view returns (uint256) {
1579         return _numberMinted(_owner);
1580     }
1581 
1582     function _withdraw(address _address, uint256 _amount) external onlyOwner {
1583         (bool success, ) = _address.call{value: _amount}("");
1584         require(success, "Failed to withdraw Ether");
1585     }
1586 
1587     function setPrice(uint256 _price) external onlyOwner {
1588         price = _price;
1589     }
1590 
1591     function setPause(bool _state) external onlyOwner {
1592         paused = _state;
1593     }
1594 
1595     function _baseURI() internal view virtual override returns (string memory) {
1596       return baseURI;
1597     }
1598     
1599     function setBaseURI(string memory baseURI_) external onlyOwner {
1600         baseURI = baseURI_;
1601     }
1602 
1603     function tokenURI(uint256 tokenId) public view virtual override returns (string memory)
1604     {
1605         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1606 
1607 
1608         string memory _tokenURI = super.tokenURI(tokenId);
1609         return bytes(_tokenURI).length > 0 ? string(abi.encodePacked(_tokenURI, ".json")) : "";
1610     }
1611 }