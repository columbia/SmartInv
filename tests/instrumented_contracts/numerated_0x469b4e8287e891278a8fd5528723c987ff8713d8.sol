1 /**
2 
3 // SPDX-License-Identifier: MIT
4 
5 
6 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/IERC721A.sol
7 
8 
9 // ERC721A Contracts v3.3.0
10 // Creator: Chiru Labs
11 
12 pragma solidity ^0.8.4;
13 
14 /**
15  * @dev Interface of an ERC721A compliant contract.
16  */
17 interface IERC721A {
18     /**
19      * The caller must own the token or be an approved operator.
20      */
21     error ApprovalCallerNotOwnerNorApproved();
22 
23     /**
24      * The token does not exist.
25      */
26     error ApprovalQueryForNonexistentToken();
27 
28     /**
29      * The caller cannot approve to their own address.
30      */
31     error ApproveToCaller();
32 
33     /**
34      * The caller cannot approve to the current owner.
35      */
36     error ApprovalToCurrentOwner();
37 
38     /**
39      * Cannot query the balance for the zero address.
40      */
41     error BalanceQueryForZeroAddress();
42 
43     /**
44      * Cannot mint to the zero address.
45      */
46     error MintToZeroAddress();
47 
48     /**
49      * The quantity of tokens minted must be more than zero.
50      */
51     error MintZeroQuantity();
52 
53     /**
54      * The token does not exist.
55      */
56     error OwnerQueryForNonexistentToken();
57 
58     /**
59      * The caller must own the token or be an approved operator.
60      */
61     error TransferCallerNotOwnerNorApproved();
62 
63     /**
64      * The token must be owned by `from`.
65      */
66     error TransferFromIncorrectOwner();
67 
68     /**
69      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
70      */
71     error TransferToNonERC721ReceiverImplementer();
72 
73     /**
74      * Cannot transfer to the zero address.
75      */
76     error TransferToZeroAddress();
77 
78     /**
79      * The token does not exist.
80      */
81     error URIQueryForNonexistentToken();
82 
83     struct TokenOwnership {
84         // The address of the owner.
85         address addr;
86         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
87         uint64 startTimestamp;
88         // Whether the token has been burned.
89         bool burned;
90     }
91 
92     /**
93      * @dev Returns the total amount of tokens stored by the contract.
94      *
95      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
96      */
97     function totalSupply() external view returns (uint256);
98 
99     // ==============================
100     //            IERC165
101     // ==============================
102 
103     /**
104      * @dev Returns true if this contract implements the interface defined by
105      * `interfaceId`. See the corresponding
106      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
107      * to learn more about how these ids are created.
108      *
109      * This function call must use less than 30 000 gas.
110      */
111     function supportsInterface(bytes4 interfaceId) external view returns (bool);
112 
113     // ==============================
114     //            IERC721
115     // ==============================
116 
117     /**
118      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
119      */
120     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
121 
122     /**
123      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
124      */
125     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
126 
127     /**
128      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
129      */
130     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
131 
132     /**
133      * @dev Returns the number of tokens in ``owner``'s account.
134      */
135     function balanceOf(address owner) external view returns (uint256 balance);
136 
137     /**
138      * @dev Returns the owner of the `tokenId` token.
139      *
140      * Requirements:
141      *
142      * - `tokenId` must exist.
143      */
144     function ownerOf(uint256 tokenId) external view returns (address owner);
145 
146     /**
147      * @dev Safely transfers `tokenId` token from `from` to `to`.
148      *
149      * Requirements:
150      *
151      * - `from` cannot be the zero address.
152      * - `to` cannot be the zero address.
153      * - `tokenId` token must exist and be owned by `from`.
154      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
155      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
156      *
157      * Emits a {Transfer} event.
158      */
159     function safeTransferFrom(
160         address from,
161         address to,
162         uint256 tokenId,
163         bytes calldata data
164     ) external;
165 
166     /**
167      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
168      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
169      *
170      * Requirements:
171      *
172      * - `from` cannot be the zero address.
173      * - `to` cannot be the zero address.
174      * - `tokenId` token must exist and be owned by `from`.
175      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
176      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
177      *
178      * Emits a {Transfer} event.
179      */
180     function safeTransferFrom(
181         address from,
182         address to,
183         uint256 tokenId
184     ) external;
185 
186     /**
187      * @dev Transfers `tokenId` token from `from` to `to`.
188      *
189      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
190      *
191      * Requirements:
192      *
193      * - `from` cannot be the zero address.
194      * - `to` cannot be the zero address.
195      * - `tokenId` token must be owned by `from`.
196      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
197      *
198      * Emits a {Transfer} event.
199      */
200     function transferFrom(
201         address from,
202         address to,
203         uint256 tokenId
204     ) external;
205 
206     /**
207      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
208      * The approval is cleared when the token is transferred.
209      *
210      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
211      *
212      * Requirements:
213      *
214      * - The caller must own the token or be an approved operator.
215      * - `tokenId` must exist.
216      *
217      * Emits an {Approval} event.
218      */
219     function approve(address to, uint256 tokenId) external;
220 
221     /**
222      * @dev Approve or remove `operator` as an operator for the caller.
223      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
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
245      * See {setApprovalForAll}
246      */
247     function isApprovedForAll(address owner, address operator) external view returns (bool);
248 
249     // ==============================
250     //        IERC721Metadata
251     // ==============================
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
267 }
268 
269 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol
270 
271 
272 // ERC721A Contracts v3.3.0
273 // Creator: Chiru Labs
274 
275 pragma solidity ^0.8.4;
276 
277 
278 /**
279  * @dev ERC721 token receiver interface.
280  */
281 interface ERC721A__IERC721Receiver {
282     function onERC721Received(
283         address operator,
284         address from,
285         uint256 tokenId,
286         bytes calldata data
287     ) external returns (bytes4);
288 }
289 
290 /**
291  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
292  * the Metadata extension. Built to optimize for lower gas during batch mints.
293  *
294  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
295  *
296  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
297  *
298  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
299  */
300 contract ERC721A is IERC721A {
301     // Mask of an entry in packed address data.
302     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
303 
304     // The bit position of `numberMinted` in packed address data.
305     uint256 private constant BITPOS_NUMBER_MINTED = 64;
306 
307     // The bit position of `numberBurned` in packed address data.
308     uint256 private constant BITPOS_NUMBER_BURNED = 128;
309 
310     // The bit position of `aux` in packed address data.
311     uint256 private constant BITPOS_AUX = 192;
312 
313     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
314     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
315 
316     // The bit position of `startTimestamp` in packed ownership.
317     uint256 private constant BITPOS_START_TIMESTAMP = 160;
318 
319     // The bit mask of the `burned` bit in packed ownership.
320     uint256 private constant BITMASK_BURNED = 1 << 224;
321     
322     // The bit position of the `nextInitialized` bit in packed ownership.
323     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
324 
325     // The bit mask of the `nextInitialized` bit in packed ownership.
326     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
327 
328     // The tokenId of the next token to be minted.
329     uint256 private _currentIndex;
330 
331     // The number of tokens burned.
332     uint256 private _burnCounter;
333 
334     // Token name
335     string private _name;
336 
337     // Token symbol
338     string private _symbol;
339 
340     // Mapping from token ID to ownership details
341     // An empty struct value does not necessarily mean the token is unowned.
342     // See `_packedOwnershipOf` implementation for details.
343     //
344     // Bits Layout:
345     // - [0..159]   `addr`
346     // - [160..223] `startTimestamp`
347     // - [224]      `burned`
348     // - [225]      `nextInitialized`
349     mapping(uint256 => uint256) private _packedOwnerships;
350 
351     // Mapping owner address to address data.
352     //
353     // Bits Layout:
354     // - [0..63]    `balance`
355     // - [64..127]  `numberMinted`
356     // - [128..191] `numberBurned`
357     // - [192..255] `aux`
358     mapping(address => uint256) private _packedAddressData;
359 
360     // Mapping from token ID to approved address.
361     mapping(uint256 => address) private _tokenApprovals;
362 
363     // Mapping from owner to operator approvals
364     mapping(address => mapping(address => bool)) private _operatorApprovals;
365 
366     constructor(string memory name_, string memory symbol_) {
367         _name = name_;
368         _symbol = symbol_;
369         _currentIndex = _startTokenId();
370     }
371 
372     /**
373      * @dev Returns the starting token ID. 
374      * To change the starting token ID, please override this function.
375      */
376     function _startTokenId() internal view virtual returns (uint256) {
377         return 0;
378     }
379 
380     /**
381      * @dev Returns the next token ID to be minted.
382      */
383     function _nextTokenId() internal view returns (uint256) {
384         return _currentIndex;
385     }
386 
387     /**
388      * @dev Returns the total number of tokens in existence.
389      * Burned tokens will reduce the count. 
390      * To get the total number of tokens minted, please see `_totalMinted`.
391      */
392     function totalSupply() public view override returns (uint256) {
393         // Counter underflow is impossible as _burnCounter cannot be incremented
394         // more than `_currentIndex - _startTokenId()` times.
395         unchecked {
396             return _currentIndex - _burnCounter - _startTokenId();
397         }
398     }
399 
400     /**
401      * @dev Returns the total amount of tokens minted in the contract.
402      */
403     function _totalMinted() internal view returns (uint256) {
404         // Counter underflow is impossible as _currentIndex does not decrement,
405         // and it is initialized to `_startTokenId()`
406         unchecked {
407             return _currentIndex - _startTokenId();
408         }
409     }
410 
411     /**
412      * @dev Returns the total number of tokens burned.
413      */
414     function _totalBurned() internal view returns (uint256) {
415         return _burnCounter;
416     }
417 
418     /**
419      * @dev See {IERC165-supportsInterface}.
420      */
421     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
422         // The interface IDs are constants representing the first 4 bytes of the XOR of
423         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
424         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
425         return
426             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
427             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
428             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
429     }
430 
431     /**
432      * @dev See {IERC721-balanceOf}.
433      */
434     function balanceOf(address owner) public view override returns (uint256) {
435         if (owner == address(0)) revert BalanceQueryForZeroAddress();
436         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
437     }
438 
439     /**
440      * Returns the number of tokens minted by `owner`.
441      */
442     function _numberMinted(address owner) internal view returns (uint256) {
443         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
444     }
445 
446     /**
447      * Returns the number of tokens burned by or on behalf of `owner`.
448      */
449     function _numberBurned(address owner) internal view returns (uint256) {
450         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
451     }
452 
453     /**
454      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
455      */
456     function _getAux(address owner) internal view returns (uint64) {
457         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
458     }
459 
460     /**
461      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
462      * If there are multiple variables, please pack them into a uint64.
463      */
464     function _setAux(address owner, uint64 aux) internal {
465         uint256 packed = _packedAddressData[owner];
466         uint256 auxCasted;
467         assembly { // Cast aux without masking.
468             auxCasted := aux
469         }
470         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
471         _packedAddressData[owner] = packed;
472     }
473 
474     /**
475      * Returns the packed ownership data of `tokenId`.
476      */
477     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
478         uint256 curr = tokenId;
479 
480         unchecked {
481             if (_startTokenId() <= curr)
482                 if (curr < _currentIndex) {
483                     uint256 packed = _packedOwnerships[curr];
484                     // If not burned.
485                     if (packed & BITMASK_BURNED == 0) {
486                         // Invariant:
487                         // There will always be an ownership that has an address and is not burned
488                         // before an ownership that does not have an address and is not burned.
489                         // Hence, curr will not underflow.
490                         //
491                         // We can directly compare the packed value.
492                         // If the address is zero, packed is zero.
493                         while (packed == 0) {
494                             packed = _packedOwnerships[--curr];
495                         }
496                         return packed;
497                     }
498                 }
499         }
500         revert OwnerQueryForNonexistentToken();
501     }
502 
503     /**
504      * Returns the unpacked `TokenOwnership` struct from `packed`.
505      */
506     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
507         ownership.addr = address(uint160(packed));
508         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
509         ownership.burned = packed & BITMASK_BURNED != 0;
510     }
511 
512     /**
513      * Returns the unpacked `TokenOwnership` struct at `index`.
514      */
515     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
516         return _unpackedOwnership(_packedOwnerships[index]);
517     }
518 
519     /**
520      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
521      */
522     function _initializeOwnershipAt(uint256 index) internal {
523         if (_packedOwnerships[index] == 0) {
524             _packedOwnerships[index] = _packedOwnershipOf(index);
525         }
526     }
527 
528     /**
529      * Gas spent here starts off proportional to the maximum mint batch size.
530      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
531      */
532     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
533         return _unpackedOwnership(_packedOwnershipOf(tokenId));
534     }
535 
536     /**
537      * @dev See {IERC721-ownerOf}.
538      */
539     function ownerOf(uint256 tokenId) public view override returns (address) {
540         return address(uint160(_packedOwnershipOf(tokenId)));
541     }
542 
543     /**
544      * @dev See {IERC721Metadata-name}.
545      */
546     function name() public view virtual override returns (string memory) {
547         return _name;
548     }
549 
550     /**
551      * @dev See {IERC721Metadata-symbol}.
552      */
553     function symbol() public view virtual override returns (string memory) {
554         return _symbol;
555     }
556 
557     /**
558      * @dev See {IERC721Metadata-tokenURI}.
559      */
560     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
561         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
562 
563         string memory baseURI = _baseURI();
564         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
565     }
566 
567     /**
568      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
569      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
570      * by default, can be overriden in child contracts.
571      */
572     function _baseURI() internal view virtual returns (string memory) {
573         return '';
574     }
575 
576     /**
577      * @dev Casts the address to uint256 without masking.
578      */
579     function _addressToUint256(address value) private pure returns (uint256 result) {
580         assembly {
581             result := value
582         }
583     }
584 
585     /**
586      * @dev Casts the boolean to uint256 without branching.
587      */
588     function _boolToUint256(bool value) private pure returns (uint256 result) {
589         assembly {
590             result := value
591         }
592     }
593 
594     /**
595      * @dev See {IERC721-approve}.
596      */
597     function approve(address to, uint256 tokenId) public override {
598         address owner = address(uint160(_packedOwnershipOf(tokenId)));
599         if (to == owner) revert ApprovalToCurrentOwner();
600 
601         if (_msgSenderERC721A() != owner)
602             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
603                 revert ApprovalCallerNotOwnerNorApproved();
604             }
605 
606         _tokenApprovals[tokenId] = to;
607         emit Approval(owner, to, tokenId);
608     }
609 
610     /**
611      * @dev See {IERC721-getApproved}.
612      */
613     function getApproved(uint256 tokenId) public view override returns (address) {
614         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
615 
616         return _tokenApprovals[tokenId];
617     }
618 
619     /**
620      * @dev See {IERC721-setApprovalForAll}.
621      */
622     function setApprovalForAll(address operator, bool approved) public virtual override {
623         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
624 
625         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
626         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
627     }
628 
629     /**
630      * @dev See {IERC721-isApprovedForAll}.
631      */
632     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
633         return _operatorApprovals[owner][operator];
634     }
635 
636     /**
637      * @dev See {IERC721-transferFrom}.
638      */
639     function transferFrom(
640         address from,
641         address to,
642         uint256 tokenId
643     ) public virtual override {
644         _transfer(from, to, tokenId);
645     }
646 
647     /**
648      * @dev See {IERC721-safeTransferFrom}.
649      */
650     function safeTransferFrom(
651         address from,
652         address to,
653         uint256 tokenId
654     ) public virtual override {
655         safeTransferFrom(from, to, tokenId, '');
656     }
657 
658     /**
659      * @dev See {IERC721-safeTransferFrom}.
660      */
661     function safeTransferFrom(
662         address from,
663         address to,
664         uint256 tokenId,
665         bytes memory _data
666     ) public virtual override {
667         _transfer(from, to, tokenId);
668         if (to.code.length != 0)
669             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
670                 revert TransferToNonERC721ReceiverImplementer();
671             }
672     }
673 
674     /**
675      * @dev Returns whether `tokenId` exists.
676      *
677      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
678      *
679      * Tokens start existing when they are minted (`_mint`),
680      */
681     function _exists(uint256 tokenId) internal view returns (bool) {
682         return
683             _startTokenId() <= tokenId &&
684             tokenId < _currentIndex && // If within bounds,
685             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
686     }
687 
688     /**
689      * @dev Equivalent to `_safeMint(to, quantity, '')`.
690      */
691     function _safeMint(address to, uint256 quantity) internal {
692         _safeMint(to, quantity, '');
693     }
694 
695     /**
696      * @dev Safely mints `quantity` tokens and transfers them to `to`.
697      *
698      * Requirements:
699      *
700      * - If `to` refers to a smart contract, it must implement
701      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
702      * - `quantity` must be greater than 0.
703      *
704      * Emits a {Transfer} event.
705      */
706     function _safeMint(
707         address to,
708         uint256 quantity,
709         bytes memory _data
710     ) internal {
711         uint256 startTokenId = _currentIndex;
712         if (to == address(0)) revert MintToZeroAddress();
713         if (quantity == 0) revert MintZeroQuantity();
714 
715         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
716 
717         // Overflows are incredibly unrealistic.
718         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
719         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
720         unchecked {
721             // Updates:
722             // - `balance += quantity`.
723             // - `numberMinted += quantity`.
724             //
725             // We can directly add to the balance and number minted.
726             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
727 
728             // Updates:
729             // - `address` to the owner.
730             // - `startTimestamp` to the timestamp of minting.
731             // - `burned` to `false`.
732             // - `nextInitialized` to `quantity == 1`.
733             _packedOwnerships[startTokenId] =
734                 _addressToUint256(to) |
735                 (block.timestamp << BITPOS_START_TIMESTAMP) |
736                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
737 
738             uint256 updatedIndex = startTokenId;
739             uint256 end = updatedIndex + quantity;
740 
741             if (to.code.length != 0) {
742                 do {
743                     emit Transfer(address(0), to, updatedIndex);
744                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
745                         revert TransferToNonERC721ReceiverImplementer();
746                     }
747                 } while (updatedIndex < end);
748                 // Reentrancy protection
749                 if (_currentIndex != startTokenId) revert();
750             } else {
751                 do {
752                     emit Transfer(address(0), to, updatedIndex++);
753                 } while (updatedIndex < end);
754             }
755             _currentIndex = updatedIndex;
756         }
757         _afterTokenTransfers(address(0), to, startTokenId, quantity);
758     }
759 
760     /**
761      * @dev Mints `quantity` tokens and transfers them to `to`.
762      *
763      * Requirements:
764      *
765      * - `to` cannot be the zero address.
766      * - `quantity` must be greater than 0.
767      *
768      * Emits a {Transfer} event.
769      */
770     function _mint(address to, uint256 quantity) internal {
771         uint256 startTokenId = _currentIndex;
772         if (to == address(0)) revert MintToZeroAddress();
773         if (quantity == 0) revert MintZeroQuantity();
774 
775         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
776 
777         // Overflows are incredibly unrealistic.
778         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
779         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
780         unchecked {
781             // Updates:
782             // - `balance += quantity`.
783             // - `numberMinted += quantity`.
784             //
785             // We can directly add to the balance and number minted.
786             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
787 
788             // Updates:
789             // - `address` to the owner.
790             // - `startTimestamp` to the timestamp of minting.
791             // - `burned` to `false`.
792             // - `nextInitialized` to `quantity == 1`.
793             _packedOwnerships[startTokenId] =
794                 _addressToUint256(to) |
795                 (block.timestamp << BITPOS_START_TIMESTAMP) |
796                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
797 
798             uint256 updatedIndex = startTokenId;
799             uint256 end = updatedIndex + quantity;
800 
801             do {
802                 emit Transfer(address(0), to, updatedIndex++);
803             } while (updatedIndex < end);
804 
805             _currentIndex = updatedIndex;
806         }
807         _afterTokenTransfers(address(0), to, startTokenId, quantity);
808     }
809 
810     /**
811      * @dev Transfers `tokenId` from `from` to `to`.
812      *
813      * Requirements:
814      *
815      * - `to` cannot be the zero address.
816      * - `tokenId` token must be owned by `from`.
817      *
818      * Emits a {Transfer} event.
819      */
820     function _transfer(
821         address from,
822         address to,
823         uint256 tokenId
824     ) private {
825         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
826 
827         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
828 
829         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
830             isApprovedForAll(from, _msgSenderERC721A()) ||
831             getApproved(tokenId) == _msgSenderERC721A());
832 
833         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
834         if (to == address(0)) revert TransferToZeroAddress();
835 
836         _beforeTokenTransfers(from, to, tokenId, 1);
837 
838         // Clear approvals from the previous owner.
839         delete _tokenApprovals[tokenId];
840 
841         // Underflow of the sender's balance is impossible because we check for
842         // ownership above and the recipient's balance can't realistically overflow.
843         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
844         unchecked {
845             // We can directly increment and decrement the balances.
846             --_packedAddressData[from]; // Updates: `balance -= 1`.
847             ++_packedAddressData[to]; // Updates: `balance += 1`.
848 
849             // Updates:
850             // - `address` to the next owner.
851             // - `startTimestamp` to the timestamp of transfering.
852             // - `burned` to `false`.
853             // - `nextInitialized` to `true`.
854             _packedOwnerships[tokenId] =
855                 _addressToUint256(to) |
856                 (block.timestamp << BITPOS_START_TIMESTAMP) |
857                 BITMASK_NEXT_INITIALIZED;
858 
859             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
860             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
861                 uint256 nextTokenId = tokenId + 1;
862                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
863                 if (_packedOwnerships[nextTokenId] == 0) {
864                     // If the next slot is within bounds.
865                     if (nextTokenId != _currentIndex) {
866                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
867                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
868                     }
869                 }
870             }
871         }
872 
873         emit Transfer(from, to, tokenId);
874         _afterTokenTransfers(from, to, tokenId, 1);
875     }
876 
877     /**
878      * @dev Equivalent to `_burn(tokenId, false)`.
879      */
880     function _burn(uint256 tokenId) internal virtual {
881         _burn(tokenId, false);
882     }
883 
884     /**
885      * @dev Destroys `tokenId`.
886      * The approval is cleared when the token is burned.
887      *
888      * Requirements:
889      *
890      * - `tokenId` must exist.
891      *
892      * Emits a {Transfer} event.
893      */
894     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
895         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
896 
897         address from = address(uint160(prevOwnershipPacked));
898 
899         if (approvalCheck) {
900             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
901                 isApprovedForAll(from, _msgSenderERC721A()) ||
902                 getApproved(tokenId) == _msgSenderERC721A());
903 
904             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
905         }
906 
907         _beforeTokenTransfers(from, address(0), tokenId, 1);
908 
909         // Clear approvals from the previous owner.
910         delete _tokenApprovals[tokenId];
911 
912         // Underflow of the sender's balance is impossible because we check for
913         // ownership above and the recipient's balance can't realistically overflow.
914         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
915         unchecked {
916             // Updates:
917             // - `balance -= 1`.
918             // - `numberBurned += 1`.
919             //
920             // We can directly decrement the balance, and increment the number burned.
921             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
922             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
923 
924             // Updates:
925             // - `address` to the last owner.
926             // - `startTimestamp` to the timestamp of burning.
927             // - `burned` to `true`.
928             // - `nextInitialized` to `true`.
929             _packedOwnerships[tokenId] =
930                 _addressToUint256(from) |
931                 (block.timestamp << BITPOS_START_TIMESTAMP) |
932                 BITMASK_BURNED | 
933                 BITMASK_NEXT_INITIALIZED;
934 
935             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
936             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
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
949         emit Transfer(from, address(0), tokenId);
950         _afterTokenTransfers(from, address(0), tokenId, 1);
951 
952         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
953         unchecked {
954             _burnCounter++;
955         }
956     }
957 
958     /**
959      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
960      *
961      * @param from address representing the previous owner of the given token ID
962      * @param to target address that will receive the tokens
963      * @param tokenId uint256 ID of the token to be transferred
964      * @param _data bytes optional data to send along with the call
965      * @return bool whether the call correctly returned the expected magic value
966      */
967     function _checkContractOnERC721Received(
968         address from,
969         address to,
970         uint256 tokenId,
971         bytes memory _data
972     ) private returns (bool) {
973         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
974             bytes4 retval
975         ) {
976             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
977         } catch (bytes memory reason) {
978             if (reason.length == 0) {
979                 revert TransferToNonERC721ReceiverImplementer();
980             } else {
981                 assembly {
982                     revert(add(32, reason), mload(reason))
983                 }
984             }
985         }
986     }
987 
988     /**
989      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
990      * And also called before burning one token.
991      *
992      * startTokenId - the first token id to be transferred
993      * quantity - the amount to be transferred
994      *
995      * Calling conditions:
996      *
997      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
998      * transferred to `to`.
999      * - When `from` is zero, `tokenId` will be minted for `to`.
1000      * - When `to` is zero, `tokenId` will be burned by `from`.
1001      * - `from` and `to` are never both zero.
1002      */
1003     function _beforeTokenTransfers(
1004         address from,
1005         address to,
1006         uint256 startTokenId,
1007         uint256 quantity
1008     ) internal virtual {}
1009 
1010     /**
1011      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1012      * minting.
1013      * And also called after one token has been burned.
1014      *
1015      * startTokenId - the first token id to be transferred
1016      * quantity - the amount to be transferred
1017      *
1018      * Calling conditions:
1019      *
1020      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1021      * transferred to `to`.
1022      * - When `from` is zero, `tokenId` has been minted for `to`.
1023      * - When `to` is zero, `tokenId` has been burned by `from`.
1024      * - `from` and `to` are never both zero.
1025      */
1026     function _afterTokenTransfers(
1027         address from,
1028         address to,
1029         uint256 startTokenId,
1030         uint256 quantity
1031     ) internal virtual {}
1032 
1033     /**
1034      * @dev Returns the message sender (defaults to `msg.sender`).
1035      *
1036      * If you are writing GSN compatible contracts, you need to override this function.
1037      */
1038     function _msgSenderERC721A() internal view virtual returns (address) {
1039         return msg.sender;
1040     }
1041 
1042     /**
1043      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1044      */
1045     function _toString(uint256 value) internal pure returns (string memory ptr) {
1046         assembly {
1047             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1048             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1049             // We will need 1 32-byte word to store the length, 
1050             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1051             ptr := add(mload(0x40), 128)
1052             // Update the free memory pointer to allocate.
1053             mstore(0x40, ptr)
1054 
1055             // Cache the end of the memory to calculate the length later.
1056             let end := ptr
1057 
1058             // We write the string from the rightmost digit to the leftmost digit.
1059             // The following is essentially a do-while loop that also handles the zero case.
1060             // Costs a bit more than early returning for the zero case,
1061             // but cheaper in terms of deployment and overall runtime costs.
1062             for { 
1063                 // Initialize and perform the first pass without check.
1064                 let temp := value
1065                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1066                 ptr := sub(ptr, 1)
1067                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1068                 mstore8(ptr, add(48, mod(temp, 10)))
1069                 temp := div(temp, 10)
1070             } temp { 
1071                 // Keep dividing `temp` until zero.
1072                 temp := div(temp, 10)
1073             } { // Body of the for loop.
1074                 ptr := sub(ptr, 1)
1075                 mstore8(ptr, add(48, mod(temp, 10)))
1076             }
1077             
1078             let length := sub(end, ptr)
1079             // Move the pointer 32 bytes leftwards to make room for the length.
1080             ptr := sub(ptr, 32)
1081             // Store the length.
1082             mstore(ptr, length)
1083         }
1084     }
1085 }
1086 
1087 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
1088 
1089 
1090 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
1091 
1092 pragma solidity ^0.8.0;
1093 
1094 /**
1095  * @dev String operations.
1096  */
1097 library Strings {
1098     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1099     uint8 private constant _ADDRESS_LENGTH = 20;
1100 
1101     /**
1102      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1103      */
1104     function toString(uint256 value) internal pure returns (string memory) {
1105         // Inspired by OraclizeAPI's implementation - MIT licence
1106         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1107 
1108         if (value == 0) {
1109             return "0";
1110         }
1111         uint256 temp = value;
1112         uint256 digits;
1113         while (temp != 0) {
1114             digits++;
1115             temp /= 10;
1116         }
1117         bytes memory buffer = new bytes(digits);
1118         while (value != 0) {
1119             digits -= 1;
1120             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1121             value /= 10;
1122         }
1123         return string(buffer);
1124     }
1125 
1126     /**
1127      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1128      */
1129     function toHexString(uint256 value) internal pure returns (string memory) {
1130         if (value == 0) {
1131             return "0x00";
1132         }
1133         uint256 temp = value;
1134         uint256 length = 0;
1135         while (temp != 0) {
1136             length++;
1137             temp >>= 8;
1138         }
1139         return toHexString(value, length);
1140     }
1141 
1142     /**
1143      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1144      */
1145     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1146         bytes memory buffer = new bytes(2 * length + 2);
1147         buffer[0] = "0";
1148         buffer[1] = "x";
1149         for (uint256 i = 2 * length + 1; i > 1; --i) {
1150             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1151             value >>= 4;
1152         }
1153         require(value == 0, "Strings: hex length insufficient");
1154         return string(buffer);
1155     }
1156 
1157     /**
1158      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1159      */
1160     function toHexString(address addr) internal pure returns (string memory) {
1161         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1162     }
1163 }
1164 
1165 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
1166 
1167 
1168 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1169 
1170 pragma solidity ^0.8.0;
1171 
1172 /**
1173  * @dev Provides information about the current execution context, including the
1174  * sender of the transaction and its data. While these are generally available
1175  * via msg.sender and msg.data, they should not be accessed in such a direct
1176  * manner, since when dealing with meta-transactions the account sending and
1177  * paying for execution may not be the actual sender (as far as an application
1178  * is concerned).
1179  *
1180  * This contract is only required for intermediate, library-like contracts.
1181  */
1182 abstract contract Context {
1183     function _msgSender() internal view virtual returns (address) {
1184         return msg.sender;
1185     }
1186 
1187     function _msgData() internal view virtual returns (bytes calldata) {
1188         return msg.data;
1189     }
1190 }
1191 
1192 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
1193 
1194 
1195 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1196 
1197 pragma solidity ^0.8.0;
1198 
1199 
1200 /**
1201  * @dev Contract module which provides a basic access control mechanism, where
1202  * there is an account (an owner) that can be granted exclusive access to
1203  * specific functions.
1204  *
1205  * By default, the owner account will be the one that deploys the contract. This
1206  * can later be changed with {transferOwnership}.
1207  *
1208  * This module is used through inheritance. It will make available the modifier
1209  * `onlyOwner`, which can be applied to your functions to restrict their use to
1210  * the owner.
1211  */
1212 abstract contract Ownable is Context {
1213     address private _owner;
1214 
1215     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1216 
1217     /**
1218      * @dev Initializes the contract setting the deployer as the initial owner.
1219      */
1220     constructor() {
1221         _transferOwnership(_msgSender());
1222     }
1223 
1224     /**
1225      * @dev Returns the address of the current owner.
1226      */
1227     function owner() public view virtual returns (address) {
1228         return _owner;
1229     }
1230 
1231     /**
1232      * @dev Throws if called by any account other than the owner.
1233      */
1234     modifier onlyOwner() {
1235         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1236         _;
1237     }
1238 
1239     /**
1240      * @dev Leaves the contract without owner. It will not be possible to call
1241      * `onlyOwner` functions anymore. Can only be called by the current owner.
1242      *
1243      * NOTE: Renouncing ownership will leave the contract without an owner,
1244      * thereby removing any functionality that is only available to the owner.
1245      */
1246     function renounceOwnership() public virtual onlyOwner {
1247         _transferOwnership(address(0));
1248     }
1249 
1250     /**
1251      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1252      * Can only be called by the current owner.
1253      */
1254     function transferOwnership(address newOwner) public virtual onlyOwner {
1255         require(newOwner != address(0), "Ownable: new owner is the zero address");
1256         _transferOwnership(newOwner);
1257     }
1258 
1259     /**
1260      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1261      * Internal function without access restriction.
1262      */
1263     function _transferOwnership(address newOwner) internal virtual {
1264         address oldOwner = _owner;
1265         _owner = newOwner;
1266         emit OwnershipTransferred(oldOwner, newOwner);
1267     }
1268 }
1269 
1270 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol
1271 
1272 
1273 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
1274 
1275 pragma solidity ^0.8.1;
1276 
1277 /**
1278  * @dev Collection of functions related to the address type
1279  */
1280 library Address {
1281     /**
1282      * @dev Returns true if `account` is a contract.
1283      *
1284      * [IMPORTANT]
1285      * ====
1286      * It is unsafe to assume that an address for which this function returns
1287      * false is an externally-owned account (EOA) and not a contract.
1288      *
1289      * Among others, `isContract` will return false for the following
1290      * types of addresses:
1291      *
1292      *  - an externally-owned account
1293      *  - a contract in construction
1294      *  - an address where a contract will be created
1295      *  - an address where a contract lived, but was destroyed
1296      * ====
1297      *
1298      * [IMPORTANT]
1299      * ====
1300      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1301      *
1302      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1303      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1304      * constructor.
1305      * ====
1306      */
1307     function isContract(address account) internal view returns (bool) {
1308         // This method relies on extcodesize/address.code.length, which returns 0
1309         // for contracts in construction, since the code is only stored at the end
1310         // of the constructor execution.
1311 
1312         return account.code.length > 0;
1313     }
1314 
1315     /**
1316      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1317      * `recipient`, forwarding all available gas and reverting on errors.
1318      *
1319      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1320      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1321      * imposed by `transfer`, making them unable to receive funds via
1322      * `transfer`. {sendValue} removes this limitation.
1323      *
1324      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1325      *
1326      * IMPORTANT: because control is transferred to `recipient`, care must be
1327      * taken to not create reentrancy vulnerabilities. Consider using
1328      * {ReentrancyGuard} or the
1329      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1330      */
1331     function sendValue(address payable recipient, uint256 amount) internal {
1332         require(address(this).balance >= amount, "Address: insufficient balance");
1333 
1334         (bool success, ) = recipient.call{value: amount}("");
1335         require(success, "Address: unable to send value, recipient may have reverted");
1336     }
1337 
1338     /**
1339      * @dev Performs a Solidity function call using a low level `call`. A
1340      * plain `call` is an unsafe replacement for a function call: use this
1341      * function instead.
1342      *
1343      * If `target` reverts with a revert reason, it is bubbled up by this
1344      * function (like regular Solidity function calls).
1345      *
1346      * Returns the raw returned data. To convert to the expected return value,
1347      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1348      *
1349      * Requirements:
1350      *
1351      * - `target` must be a contract.
1352      * - calling `target` with `data` must not revert.
1353      *
1354      * _Available since v3.1._
1355      */
1356     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1357         return functionCall(target, data, "Address: low-level call failed");
1358     }
1359 
1360     /**
1361      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1362      * `errorMessage` as a fallback revert reason when `target` reverts.
1363      *
1364      * _Available since v3.1._
1365      */
1366     function functionCall(
1367         address target,
1368         bytes memory data,
1369         string memory errorMessage
1370     ) internal returns (bytes memory) {
1371         return functionCallWithValue(target, data, 0, errorMessage);
1372     }
1373 
1374     /**
1375      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1376      * but also transferring `value` wei to `target`.
1377      *
1378      * Requirements:
1379      *
1380      * - the calling contract must have an ETH balance of at least `value`.
1381      * - the called Solidity function must be `payable`.
1382      *
1383      * _Available since v3.1._
1384      */
1385     function functionCallWithValue(
1386         address target,
1387         bytes memory data,
1388         uint256 value
1389     ) internal returns (bytes memory) {
1390         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1391     }
1392 
1393     /**
1394      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1395      * with `errorMessage` as a fallback revert reason when `target` reverts.
1396      *
1397      * _Available since v3.1._
1398      */
1399     function functionCallWithValue(
1400         address target,
1401         bytes memory data,
1402         uint256 value,
1403         string memory errorMessage
1404     ) internal returns (bytes memory) {
1405         require(address(this).balance >= value, "Address: insufficient balance for call");
1406         require(isContract(target), "Address: call to non-contract");
1407 
1408         (bool success, bytes memory returndata) = target.call{value: value}(data);
1409         return verifyCallResult(success, returndata, errorMessage);
1410     }
1411 
1412     /**
1413      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1414      * but performing a static call.
1415      *
1416      * _Available since v3.3._
1417      */
1418     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1419         return functionStaticCall(target, data, "Address: low-level static call failed");
1420     }
1421 
1422     /**
1423      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1424      * but performing a static call.
1425      *
1426      * _Available since v3.3._
1427      */
1428     function functionStaticCall(
1429         address target,
1430         bytes memory data,
1431         string memory errorMessage
1432     ) internal view returns (bytes memory) {
1433         require(isContract(target), "Address: static call to non-contract");
1434 
1435         (bool success, bytes memory returndata) = target.staticcall(data);
1436         return verifyCallResult(success, returndata, errorMessage);
1437     }
1438 
1439     /**
1440      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1441      * but performing a delegate call.
1442      *
1443      * _Available since v3.4._
1444      */
1445     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1446         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1447     }
1448 
1449     /**
1450      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1451      * but performing a delegate call.
1452      *
1453      * _Available since v3.4._
1454      */
1455     function functionDelegateCall(
1456         address target,
1457         bytes memory data,
1458         string memory errorMessage
1459     ) internal returns (bytes memory) {
1460         require(isContract(target), "Address: delegate call to non-contract");
1461 
1462         (bool success, bytes memory returndata) = target.delegatecall(data);
1463         return verifyCallResult(success, returndata, errorMessage);
1464     }
1465 
1466     /**
1467      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1468      * revert reason using the provided one.
1469      *
1470      * _Available since v4.3._
1471      */
1472     function verifyCallResult(
1473         bool success,
1474         bytes memory returndata,
1475         string memory errorMessage
1476     ) internal pure returns (bytes memory) {
1477         if (success) {
1478             return returndata;
1479         } else {
1480             // Look for revert reason and bubble it up if present
1481             if (returndata.length > 0) {
1482                 // The easiest way to bubble the revert reason is using memory via assembly
1483 
1484                 assembly {
1485                     let returndata_size := mload(returndata)
1486                     revert(add(32, returndata), returndata_size)
1487                 }
1488             } else {
1489                 revert(errorMessage);
1490             }
1491         }
1492     }
1493 }
1494 
1495 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721Receiver.sol
1496 
1497 
1498 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
1499 
1500 pragma solidity ^0.8.0;
1501 
1502 /**
1503  * @title ERC721 token receiver interface
1504  * @dev Interface for any contract that wants to support safeTransfers
1505  * from ERC721 asset contracts.
1506  */
1507 interface IERC721Receiver {
1508     /**
1509      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1510      * by `operator` from `from`, this function is called.
1511      *
1512      * It must return its Solidity selector to confirm the token transfer.
1513      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1514      *
1515      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
1516      */
1517     function onERC721Received(
1518         address operator,
1519         address from,
1520         uint256 tokenId,
1521         bytes calldata data
1522     ) external returns (bytes4);
1523 }
1524 
1525 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/IERC165.sol
1526 
1527 
1528 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1529 
1530 pragma solidity ^0.8.0;
1531 
1532 /**
1533  * @dev Interface of the ERC165 standard, as defined in the
1534  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1535  *
1536  * Implementers can declare support of contract interfaces, which can then be
1537  * queried by others ({ERC165Checker}).
1538  *
1539  * For an implementation, see {ERC165}.
1540  */
1541 interface IERC165 {
1542     /**
1543      * @dev Returns true if this contract implements the interface defined by
1544      * `interfaceId`. See the corresponding
1545      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1546      * to learn more about how these ids are created.
1547      *
1548      * This function call must use less than 30 000 gas.
1549      */
1550     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1551 }
1552 
1553 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/ERC165.sol
1554 
1555 
1556 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1557 
1558 pragma solidity ^0.8.0;
1559 
1560 
1561 /**
1562  * @dev Implementation of the {IERC165} interface.
1563  *
1564  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1565  * for the additional interface id that will be supported. For example:
1566  *
1567  * ```solidity
1568  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1569  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1570  * }
1571  * ```
1572  *
1573  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1574  */
1575 abstract contract ERC165 is IERC165 {
1576     /**
1577      * @dev See {IERC165-supportsInterface}.
1578      */
1579     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1580         return interfaceId == type(IERC165).interfaceId;
1581     }
1582 }
1583 
1584 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721.sol
1585 
1586 
1587 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
1588 
1589 pragma solidity ^0.8.0;
1590 
1591 
1592 /**
1593  * @dev Required interface of an ERC721 compliant contract.
1594  */
1595 interface IERC721 is IERC165 {
1596     /**
1597      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1598      */
1599     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1600 
1601     /**
1602      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1603      */
1604     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1605 
1606     /**
1607      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1608      */
1609     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1610 
1611     /**
1612      * @dev Returns the number of tokens in ``owner``'s account.
1613      */
1614     function balanceOf(address owner) external view returns (uint256 balance);
1615 
1616     /**
1617      * @dev Returns the owner of the `tokenId` token.
1618      *
1619      * Requirements:
1620      *
1621      * - `tokenId` must exist.
1622      */
1623     function ownerOf(uint256 tokenId) external view returns (address owner);
1624 
1625     /**
1626      * @dev Safely transfers `tokenId` token from `from` to `to`.
1627      *
1628      * Requirements:
1629      *
1630      * - `from` cannot be the zero address.
1631      * - `to` cannot be the zero address.
1632      * - `tokenId` token must exist and be owned by `from`.
1633      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1634      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1635      *
1636      * Emits a {Transfer} event.
1637      */
1638     function safeTransferFrom(
1639         address from,
1640         address to,
1641         uint256 tokenId,
1642         bytes calldata data
1643     ) external;
1644 
1645     /**
1646      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1647      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1648      *
1649      * Requirements:
1650      *
1651      * - `from` cannot be the zero address.
1652      * - `to` cannot be the zero address.
1653      * - `tokenId` token must exist and be owned by `from`.
1654      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1655      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1656      *
1657      * Emits a {Transfer} event.
1658      */
1659     function safeTransferFrom(
1660         address from,
1661         address to,
1662         uint256 tokenId
1663     ) external;
1664 
1665     /**
1666      * @dev Transfers `tokenId` token from `from` to `to`.
1667      *
1668      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1669      *
1670      * Requirements:
1671      *
1672      * - `from` cannot be the zero address.
1673      * - `to` cannot be the zero address.
1674      * - `tokenId` token must be owned by `from`.
1675      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1676      *
1677      * Emits a {Transfer} event.
1678      */
1679     function transferFrom(
1680         address from,
1681         address to,
1682         uint256 tokenId
1683     ) external;
1684 
1685     /**
1686      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1687      * The approval is cleared when the token is transferred.
1688      *
1689      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1690      *
1691      * Requirements:
1692      *
1693      * - The caller must own the token or be an approved operator.
1694      * - `tokenId` must exist.
1695      *
1696      * Emits an {Approval} event.
1697      */
1698     function approve(address to, uint256 tokenId) external;
1699 
1700     /**
1701      * @dev Approve or remove `operator` as an operator for the caller.
1702      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1703      *
1704      * Requirements:
1705      *
1706      * - The `operator` cannot be the caller.
1707      *
1708      * Emits an {ApprovalForAll} event.
1709      */
1710     function setApprovalForAll(address operator, bool _approved) external;
1711 
1712     /**
1713      * @dev Returns the account approved for `tokenId` token.
1714      *
1715      * Requirements:
1716      *
1717      * - `tokenId` must exist.
1718      */
1719     function getApproved(uint256 tokenId) external view returns (address operator);
1720 
1721     /**
1722      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1723      *
1724      * See {setApprovalForAll}
1725      */
1726     function isApprovedForAll(address owner, address operator) external view returns (bool);
1727 }
1728 
1729 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/IERC721Metadata.sol
1730 
1731 
1732 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1733 
1734 pragma solidity ^0.8.0;
1735 
1736 
1737 /**
1738  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1739  * @dev See https://eips.ethereum.org/EIPS/eip-721
1740  */
1741 interface IERC721Metadata is IERC721 {
1742     /**
1743      * @dev Returns the token collection name.
1744      */
1745     function name() external view returns (string memory);
1746 
1747     /**
1748      * @dev Returns the token collection symbol.
1749      */
1750     function symbol() external view returns (string memory);
1751 
1752     /**
1753      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1754      */
1755     function tokenURI(uint256 tokenId) external view returns (string memory);
1756 }
1757 
1758 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol
1759 
1760 
1761 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
1762 
1763 pragma solidity ^0.8.0;
1764 
1765 
1766 
1767 
1768 
1769 
1770 
1771 
1772 /**
1773  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1774  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1775  * {ERC721Enumerable}.
1776  */
1777 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1778     using Address for address;
1779     using Strings for uint256;
1780 
1781     // Token name
1782     string private _name;
1783 
1784     // Token symbol
1785     string private _symbol;
1786 
1787     // Mapping from token ID to owner address
1788     mapping(uint256 => address) private _owners;
1789 
1790     // Mapping owner address to token count
1791     mapping(address => uint256) private _balances;
1792 
1793     // Mapping from token ID to approved address
1794     mapping(uint256 => address) private _tokenApprovals;
1795 
1796     // Mapping from owner to operator approvals
1797     mapping(address => mapping(address => bool)) private _operatorApprovals;
1798 
1799     /**
1800      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1801      */
1802     constructor(string memory name_, string memory symbol_) {
1803         _name = name_;
1804         _symbol = symbol_;
1805     }
1806 
1807     /**
1808      * @dev See {IERC165-supportsInterface}.
1809      */
1810     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1811         return
1812             interfaceId == type(IERC721).interfaceId ||
1813             interfaceId == type(IERC721Metadata).interfaceId ||
1814             super.supportsInterface(interfaceId);
1815     }
1816 
1817     /**
1818      * @dev See {IERC721-balanceOf}.
1819      */
1820     function balanceOf(address owner) public view virtual override returns (uint256) {
1821         require(owner != address(0), "ERC721: address zero is not a valid owner");
1822         return _balances[owner];
1823     }
1824 
1825     /**
1826      * @dev See {IERC721-ownerOf}.
1827      */
1828     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1829         address owner = _owners[tokenId];
1830         require(owner != address(0), "ERC721: owner query for nonexistent token");
1831         return owner;
1832     }
1833 
1834     /**
1835      * @dev See {IERC721Metadata-name}.
1836      */
1837     function name() public view virtual override returns (string memory) {
1838         return _name;
1839     }
1840 
1841     /**
1842      * @dev See {IERC721Metadata-symbol}.
1843      */
1844     function symbol() public view virtual override returns (string memory) {
1845         return _symbol;
1846     }
1847 
1848     /**
1849      * @dev See {IERC721Metadata-tokenURI}.
1850      */
1851     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1852         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1853 
1854         string memory baseURI = _baseURI();
1855         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1856     }
1857 
1858     /**
1859      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1860      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1861      * by default, can be overridden in child contracts.
1862      */
1863     function _baseURI() internal view virtual returns (string memory) {
1864         return "";
1865     }
1866 
1867     /**
1868      * @dev See {IERC721-approve}.
1869      */
1870     function approve(address to, uint256 tokenId) public virtual override {
1871         address owner = ERC721.ownerOf(tokenId);
1872         require(to != owner, "ERC721: approval to current owner");
1873 
1874         require(
1875             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1876             "ERC721: approve caller is not owner nor approved for all"
1877         );
1878 
1879         _approve(to, tokenId);
1880     }
1881 
1882     /**
1883      * @dev See {IERC721-getApproved}.
1884      */
1885     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1886         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1887 
1888         return _tokenApprovals[tokenId];
1889     }
1890 
1891     /**
1892      * @dev See {IERC721-setApprovalForAll}.
1893      */
1894     function setApprovalForAll(address operator, bool approved) public virtual override {
1895         _setApprovalForAll(_msgSender(), operator, approved);
1896     }
1897 
1898     /**
1899      * @dev See {IERC721-isApprovedForAll}.
1900      */
1901     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1902         return _operatorApprovals[owner][operator];
1903     }
1904 
1905     /**
1906      * @dev See {IERC721-transferFrom}.
1907      */
1908     function transferFrom(
1909         address from,
1910         address to,
1911         uint256 tokenId
1912     ) public virtual override {
1913         //solhint-disable-next-line max-line-length
1914         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1915 
1916         _transfer(from, to, tokenId);
1917     }
1918 
1919     /**
1920      * @dev See {IERC721-safeTransferFrom}.
1921      */
1922     function safeTransferFrom(
1923         address from,
1924         address to,
1925         uint256 tokenId
1926     ) public virtual override {
1927         safeTransferFrom(from, to, tokenId, "");
1928     }
1929 
1930     /**
1931      * @dev See {IERC721-safeTransferFrom}.
1932      */
1933     function safeTransferFrom(
1934         address from,
1935         address to,
1936         uint256 tokenId,
1937         bytes memory data
1938     ) public virtual override {
1939         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1940         _safeTransfer(from, to, tokenId, data);
1941     }
1942 
1943     /**
1944      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1945      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1946      *
1947      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1948      *
1949      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1950      * implement alternative mechanisms to perform token transfer, such as signature-based.
1951      *
1952      * Requirements:
1953      *
1954      * - `from` cannot be the zero address.
1955      * - `to` cannot be the zero address.
1956      * - `tokenId` token must exist and be owned by `from`.
1957      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1958      *
1959      * Emits a {Transfer} event.
1960      */
1961     function _safeTransfer(
1962         address from,
1963         address to,
1964         uint256 tokenId,
1965         bytes memory data
1966     ) internal virtual {
1967         _transfer(from, to, tokenId);
1968         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1969     }
1970 
1971     /**
1972      * @dev Returns whether `tokenId` exists.
1973      *
1974      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1975      *
1976      * Tokens start existing when they are minted (`_mint`),
1977      * and stop existing when they are burned (`_burn`).
1978      */
1979     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1980         return _owners[tokenId] != address(0);
1981     }
1982 
1983     /**
1984      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1985      *
1986      * Requirements:
1987      *
1988      * - `tokenId` must exist.
1989      */
1990     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1991         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1992         address owner = ERC721.ownerOf(tokenId);
1993         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1994     }
1995 
1996     /**
1997      * @dev Safely mints `tokenId` and transfers it to `to`.
1998      *
1999      * Requirements:
2000      *
2001      * - `tokenId` must not exist.
2002      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2003      *
2004      * Emits a {Transfer} event.
2005      */
2006     function _safeMint(address to, uint256 tokenId) internal virtual {
2007         _safeMint(to, tokenId, "");
2008     }
2009 
2010     /**
2011      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
2012      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
2013      */
2014     function _safeMint(
2015         address to,
2016         uint256 tokenId,
2017         bytes memory data
2018     ) internal virtual {
2019         _mint(to, tokenId);
2020         require(
2021             _checkOnERC721Received(address(0), to, tokenId, data),
2022             "ERC721: transfer to non ERC721Receiver implementer"
2023         );
2024     }
2025 
2026     /**
2027      * @dev Mints `tokenId` and transfers it to `to`.
2028      *
2029      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
2030      *
2031      * Requirements:
2032      *
2033      * - `tokenId` must not exist.
2034      * - `to` cannot be the zero address.
2035      *
2036      * Emits a {Transfer} event.
2037      */
2038     function _mint(address to, uint256 tokenId) internal virtual {
2039         require(to != address(0), "ERC721: mint to the zero address");
2040         require(!_exists(tokenId), "ERC721: token already minted");
2041 
2042         _beforeTokenTransfer(address(0), to, tokenId);
2043 
2044         _balances[to] += 1;
2045         _owners[tokenId] = to;
2046 
2047         emit Transfer(address(0), to, tokenId);
2048 
2049         _afterTokenTransfer(address(0), to, tokenId);
2050     }
2051 
2052     /**
2053      * @dev Destroys `tokenId`.
2054      * The approval is cleared when the token is burned.
2055      *
2056      * Requirements:
2057      *
2058      * - `tokenId` must exist.
2059      *
2060      * Emits a {Transfer} event.
2061      */
2062     function _burn(uint256 tokenId) internal virtual {
2063         address owner = ERC721.ownerOf(tokenId);
2064 
2065         _beforeTokenTransfer(owner, address(0), tokenId);
2066 
2067         // Clear approvals
2068         _approve(address(0), tokenId);
2069 
2070         _balances[owner] -= 1;
2071         delete _owners[tokenId];
2072 
2073         emit Transfer(owner, address(0), tokenId);
2074 
2075         _afterTokenTransfer(owner, address(0), tokenId);
2076     }
2077 
2078     /**
2079      * @dev Transfers `tokenId` from `from` to `to`.
2080      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2081      *
2082      * Requirements:
2083      *
2084      * - `to` cannot be the zero address.
2085      * - `tokenId` token must be owned by `from`.
2086      *
2087      * Emits a {Transfer} event.
2088      */
2089     function _transfer(
2090         address from,
2091         address to,
2092         uint256 tokenId
2093     ) internal virtual {
2094         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
2095         require(to != address(0), "ERC721: transfer to the zero address");
2096 
2097         _beforeTokenTransfer(from, to, tokenId);
2098 
2099         // Clear approvals from the previous owner
2100         _approve(address(0), tokenId);
2101 
2102         _balances[from] -= 1;
2103         _balances[to] += 1;
2104         _owners[tokenId] = to;
2105 
2106         emit Transfer(from, to, tokenId);
2107 
2108         _afterTokenTransfer(from, to, tokenId);
2109     }
2110 
2111     /**
2112      * @dev Approve `to` to operate on `tokenId`
2113      *
2114      * Emits an {Approval} event.
2115      */
2116     function _approve(address to, uint256 tokenId) internal virtual {
2117         _tokenApprovals[tokenId] = to;
2118         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
2119     }
2120 
2121     /**
2122      * @dev Approve `operator` to operate on all of `owner` tokens
2123      *
2124      * Emits an {ApprovalForAll} event.
2125      */
2126     function _setApprovalForAll(
2127         address owner,
2128         address operator,
2129         bool approved
2130     ) internal virtual {
2131         require(owner != operator, "ERC721: approve to caller");
2132         _operatorApprovals[owner][operator] = approved;
2133         emit ApprovalForAll(owner, operator, approved);
2134     }
2135 
2136     /**
2137      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2138      * The call is not executed if the target address is not a contract.
2139      *
2140      * @param from address representing the previous owner of the given token ID
2141      * @param to target address that will receive the tokens
2142      * @param tokenId uint256 ID of the token to be transferred
2143      * @param data bytes optional data to send along with the call
2144      * @return bool whether the call correctly returned the expected magic value
2145      */
2146     function _checkOnERC721Received(
2147         address from,
2148         address to,
2149         uint256 tokenId,
2150         bytes memory data
2151     ) private returns (bool) {
2152         if (to.isContract()) {
2153             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
2154                 return retval == IERC721Receiver.onERC721Received.selector;
2155             } catch (bytes memory reason) {
2156                 if (reason.length == 0) {
2157                     revert("ERC721: transfer to non ERC721Receiver implementer");
2158                 } else {
2159                     assembly {
2160                         revert(add(32, reason), mload(reason))
2161                     }
2162                 }
2163             }
2164         } else {
2165             return true;
2166         }
2167     }
2168 
2169     /**
2170      * @dev Hook that is called before any token transfer. This includes minting
2171      * and burning.
2172      *
2173      * Calling conditions:
2174      *
2175      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2176      * transferred to `to`.
2177      * - When `from` is zero, `tokenId` will be minted for `to`.
2178      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2179      * - `from` and `to` are never both zero.
2180      *
2181      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2182      */
2183     function _beforeTokenTransfer(
2184         address from,
2185         address to,
2186         uint256 tokenId
2187     ) internal virtual {}
2188 
2189     /**
2190      * @dev Hook that is called after any transfer of tokens. This includes
2191      * minting and burning.
2192      *
2193      * Calling conditions:
2194      *
2195      * - when `from` and `to` are both non-zero.
2196      * - `from` and `to` are never both zero.
2197      *
2198      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2199      */
2200     function _afterTokenTransfer(
2201         address from,
2202         address to,
2203         uint256 tokenId
2204     ) internal virtual {}
2205 }
2206 
2207 // File: contracts/cockydoge.sol
2208 
2209 
2210 pragma solidity ^0.8.0;
2211 
2212 
2213 
2214 
2215 contract COCKYDOGE is ERC721A, Ownable {
2216     using Strings for uint256;
2217 
2218     string private baseURI;
2219 
2220     uint256 public price = 0.002 ether;
2221 
2222     uint256 public maxPerTx = 20;
2223 
2224     uint256 public maxFreePerWallet = 10;
2225 
2226     uint256 public totalFree = 5000;
2227 
2228     uint256 public maxSupply = 7777;
2229 
2230     bool public mintEnabled = true;
2231 
2232     mapping(address => uint256) private _mintedFreeAmount;
2233 
2234     constructor() ERC721A("Cocky Doge", "CockyDoge") {
2235         _safeMint(msg.sender, 50);
2236         setBaseURI("ipfs://");
2237     }
2238 
2239     function mint(uint256 count) external payable {
2240         uint256 cost = price;
2241         bool isFree = ((totalSupply() + count < totalFree + 1) &&
2242             (_mintedFreeAmount[msg.sender] + count <= maxFreePerWallet));
2243 
2244         if (isFree) {
2245             cost = 0;
2246         }
2247 
2248         require(msg.value >= count * cost, "Please send the exact amount.");
2249         require(totalSupply() + count < maxSupply + 1, "No more");
2250         require(mintEnabled, "Minting is not live yet");
2251         require(count < maxPerTx + 1, "Max per TX reached.");
2252 
2253         if (isFree) {
2254             _mintedFreeAmount[msg.sender] += count;
2255         }
2256 
2257         _safeMint(msg.sender, count);
2258     }
2259 
2260     function _baseURI() internal view virtual override returns (string memory) {
2261         return baseURI;
2262     }
2263 
2264     function tokenURI(uint256 tokenId)
2265         public
2266         view
2267         virtual
2268         override
2269         returns (string memory)
2270     {
2271         require(
2272             _exists(tokenId),
2273             "ERC721Metadata: URI query for nonexistent token"
2274         );
2275         return string(abi.encodePacked(baseURI, tokenId.toString(), ".json"));
2276     }
2277 
2278     function setBaseURI(string memory uri) public onlyOwner {
2279         baseURI = uri;
2280     }
2281 
2282     function setFreeAmount(uint256 amount) external onlyOwner {
2283         totalFree = amount;
2284     }
2285 
2286     function setPrice(uint256 _newPrice) external onlyOwner {
2287         price = _newPrice;
2288     }
2289 
2290     function flipSale() external onlyOwner {
2291         mintEnabled = !mintEnabled;
2292     }
2293 
2294     function withdraw() external onlyOwner {
2295         (bool success, ) = payable(msg.sender).call{
2296             value: address(this).balance
2297         }("");
2298         require(success, "Transfer failed.");
2299     }
2300 }