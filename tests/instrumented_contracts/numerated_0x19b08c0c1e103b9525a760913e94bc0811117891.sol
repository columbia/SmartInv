1 /**
2  *Submitted for verification at Etherscan.io on 2022-05-27
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 // ERC721A Contracts v3.3.0
8 // Creator: Chiru Labs
9 
10 pragma solidity ^0.8.4;
11 
12 /**
13  * @dev Interface of an ERC721A compliant contract.
14  */
15 interface IERC721A {
16     /**
17      * The caller must own the token or be an approved operator.
18      */
19     error ApprovalCallerNotOwnerNorApproved();
20 
21     /**
22      * The token does not exist.
23      */
24     error ApprovalQueryForNonexistentToken();
25 
26     /**
27      * The caller cannot approve to their own address.
28      */
29     error ApproveToCaller();
30 
31     /**
32      * The caller cannot approve to the current owner.
33      */
34     error ApprovalToCurrentOwner();
35 
36     /**
37      * Cannot query the balance for the zero address.
38      */
39     error BalanceQueryForZeroAddress();
40 
41     /**
42      * Cannot mint to the zero address.
43      */
44     error MintToZeroAddress();
45 
46     /**
47      * The quantity of tokens minted must be more than zero.
48      */
49     error MintZeroQuantity();
50 
51     /**
52      * The token does not exist.
53      */
54     error OwnerQueryForNonexistentToken();
55 
56     /**
57      * The caller must own the token or be an approved operator.
58      */
59     error TransferCallerNotOwnerNorApproved();
60 
61     /**
62      * The token must be owned by `from`.
63      */
64     error TransferFromIncorrectOwner();
65 
66     /**
67      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
68      */
69     error TransferToNonERC721ReceiverImplementer();
70 
71     /**
72      * Cannot transfer to the zero address.
73      */
74     error TransferToZeroAddress();
75 
76     /**
77      * The token does not exist.
78      */
79     error URIQueryForNonexistentToken();
80 
81     struct TokenOwnership {
82         // The address of the owner.
83         address addr;
84         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
85         uint64 startTimestamp;
86         // Whether the token has been burned.
87         bool burned;
88     }
89 
90     /**
91      * @dev Returns the total amount of tokens stored by the contract.
92      *
93      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
94      */
95     function totalSupply() external view returns (uint256);
96 
97     // ==============================
98     //            IERC165
99     // ==============================
100 
101     /**
102      * @dev Returns true if this contract implements the interface defined by
103      * `interfaceId`. See the corresponding
104      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
105      * to learn more about how these ids are created.
106      *
107      * This function call must use less than 30 000 gas.
108      */
109     function supportsInterface(bytes4 interfaceId) external view returns (bool);
110 
111     // ==============================
112     //            IERC721
113     // ==============================
114 
115     /**
116      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
117      */
118     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
119 
120     /**
121      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
122      */
123     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
124 
125     /**
126      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
127      */
128     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
129 
130     /**
131      * @dev Returns the number of tokens in ``owner``'s account.
132      */
133     function balanceOf(address owner) external view returns (uint256 balance);
134 
135     /**
136      * @dev Returns the owner of the `tokenId` token.
137      *
138      * Requirements:
139      *
140      * - `tokenId` must exist.
141      */
142     function ownerOf(uint256 tokenId) external view returns (address owner);
143 
144     /**
145      * @dev Safely transfers `tokenId` token from `from` to `to`.
146      *
147      * Requirements:
148      *
149      * - `from` cannot be the zero address.
150      * - `to` cannot be the zero address.
151      * - `tokenId` token must exist and be owned by `from`.
152      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
153      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
154      *
155      * Emits a {Transfer} event.
156      */
157     function safeTransferFrom(
158         address from,
159         address to,
160         uint256 tokenId,
161         bytes calldata data
162     ) external;
163 
164     /**
165      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
166      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
167      *
168      * Requirements:
169      *
170      * - `from` cannot be the zero address.
171      * - `to` cannot be the zero address.
172      * - `tokenId` token must exist and be owned by `from`.
173      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
174      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
175      *
176      * Emits a {Transfer} event.
177      */
178     function safeTransferFrom(
179         address from,
180         address to,
181         uint256 tokenId
182     ) external;
183 
184     /**
185      * @dev Transfers `tokenId` token from `from` to `to`.
186      *
187      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
188      *
189      * Requirements:
190      *
191      * - `from` cannot be the zero address.
192      * - `to` cannot be the zero address.
193      * - `tokenId` token must be owned by `from`.
194      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
195      *
196      * Emits a {Transfer} event.
197      */
198     function transferFrom(
199         address from,
200         address to,
201         uint256 tokenId
202     ) external;
203 
204     /**
205      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
206      * The approval is cleared when the token is transferred.
207      *
208      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
209      *
210      * Requirements:
211      *
212      * - The caller must own the token or be an approved operator.
213      * - `tokenId` must exist.
214      *
215      * Emits an {Approval} event.
216      */
217     function approve(address to, uint256 tokenId) external;
218 
219     /**
220      * @dev Approve or remove `operator` as an operator for the caller.
221      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
222      *
223      * Requirements:
224      *
225      * - The `operator` cannot be the caller.
226      *
227      * Emits an {ApprovalForAll} event.
228      */
229     function setApprovalForAll(address operator, bool _approved) external;
230 
231     /**
232      * @dev Returns the account approved for `tokenId` token.
233      *
234      * Requirements:
235      *
236      * - `tokenId` must exist.
237      */
238     function getApproved(uint256 tokenId) external view returns (address operator);
239 
240     /**
241      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
242      *
243      * See {setApprovalForAll}
244      */
245     function isApprovedForAll(address owner, address operator) external view returns (bool);
246 
247     // ==============================
248     //        IERC721Metadata
249     // ==============================
250 
251     /**
252      * @dev Returns the token collection name.
253      */
254     function name() external view returns (string memory);
255 
256     /**
257      * @dev Returns the token collection symbol.
258      */
259     function symbol() external view returns (string memory);
260 
261     /**
262      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
263      */
264     function tokenURI(uint256 tokenId) external view returns (string memory);
265 }
266 
267 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol
268 
269 
270 // ERC721A Contracts v3.3.0
271 // Creator: Chiru Labs
272 
273 pragma solidity ^0.8.4;
274 
275 
276 /**
277  * @dev ERC721 token receiver interface.
278  */
279 interface ERC721A__IERC721Receiver {
280     function onERC721Received(
281         address operator,
282         address from,
283         uint256 tokenId,
284         bytes calldata data
285     ) external returns (bytes4);
286 }
287 
288 /**
289  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
290  * the Metadata extension. Built to optimize for lower gas during batch mints.
291  *
292  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
293  *
294  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
295  *
296  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
297  */
298 contract ERC721A is IERC721A {
299     // Mask of an entry in packed address data.
300     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
301 
302     // The bit position of `numberMinted` in packed address data.
303     uint256 private constant BITPOS_NUMBER_MINTED = 64;
304 
305     // The bit position of `numberBurned` in packed address data.
306     uint256 private constant BITPOS_NUMBER_BURNED = 128;
307 
308     // The bit position of `aux` in packed address data.
309     uint256 private constant BITPOS_AUX = 192;
310 
311     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
312     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
313 
314     // The bit position of `startTimestamp` in packed ownership.
315     uint256 private constant BITPOS_START_TIMESTAMP = 160;
316 
317     // The bit mask of the `burned` bit in packed ownership.
318     uint256 private constant BITMASK_BURNED = 1 << 224;
319     
320     // The bit position of the `nextInitialized` bit in packed ownership.
321     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
322 
323     // The bit mask of the `nextInitialized` bit in packed ownership.
324     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
325 
326     // The tokenId of the next token to be minted.
327     uint256 private _currentIndex;
328 
329     // The number of tokens burned.
330     uint256 private _burnCounter;
331 
332     // Token name
333     string private _name;
334 
335     // Token symbol
336     string private _symbol;
337 
338     // Mapping from token ID to ownership details
339     // An empty struct value does not necessarily mean the token is unowned.
340     // See `_packedOwnershipOf` implementation for details.
341     //
342     // Bits Layout:
343     // - [0..159]   `addr`
344     // - [160..223] `startTimestamp`
345     // - [224]      `burned`
346     // - [225]      `nextInitialized`
347     mapping(uint256 => uint256) private _packedOwnerships;
348 
349     // Mapping owner address to address data.
350     //
351     // Bits Layout:
352     // - [0..63]    `balance`
353     // - [64..127]  `numberMinted`
354     // - [128..191] `numberBurned`
355     // - [192..255] `aux`
356     mapping(address => uint256) private _packedAddressData;
357 
358     // Mapping from token ID to approved address.
359     mapping(uint256 => address) private _tokenApprovals;
360 
361     // Mapping from owner to operator approvals
362     mapping(address => mapping(address => bool)) private _operatorApprovals;
363 
364     constructor(string memory name_, string memory symbol_) {
365         _name = name_;
366         _symbol = symbol_;
367         _currentIndex = _startTokenId();
368     }
369 
370     /**
371      * @dev Returns the starting token ID. 
372      * To change the starting token ID, please override this function.
373      */
374     function _startTokenId() internal view virtual returns (uint256) {
375         return 0;
376     }
377 
378     /**
379      * @dev Returns the next token ID to be minted.
380      */
381     function _nextTokenId() internal view returns (uint256) {
382         return _currentIndex;
383     }
384 
385     /**
386      * @dev Returns the total number of tokens in existence.
387      * Burned tokens will reduce the count. 
388      * To get the total number of tokens minted, please see `_totalMinted`.
389      */
390     function totalSupply() public view override returns (uint256) {
391         // Counter underflow is impossible as _burnCounter cannot be incremented
392         // more than `_currentIndex - _startTokenId()` times.
393         unchecked {
394             return _currentIndex - _burnCounter - _startTokenId();
395         }
396     }
397 
398     /**
399      * @dev Returns the total amount of tokens minted in the contract.
400      */
401     function _totalMinted() internal view returns (uint256) {
402         // Counter underflow is impossible as _currentIndex does not decrement,
403         // and it is initialized to `_startTokenId()`
404         unchecked {
405             return _currentIndex - _startTokenId();
406         }
407     }
408 
409     /**
410      * @dev Returns the total number of tokens burned.
411      */
412     function _totalBurned() internal view returns (uint256) {
413         return _burnCounter;
414     }
415 
416     /**
417      * @dev See {IERC165-supportsInterface}.
418      */
419     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
420         // The interface IDs are constants representing the first 4 bytes of the XOR of
421         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
422         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
423         return
424             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
425             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
426             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
427     }
428 
429     /**
430      * @dev See {IERC721-balanceOf}.
431      */
432     function balanceOf(address owner) public view override returns (uint256) {
433         if (owner == address(0)) revert BalanceQueryForZeroAddress();
434         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
435     }
436 
437     /**
438      * Returns the number of tokens minted by `owner`.
439      */
440     function _numberMinted(address owner) internal view returns (uint256) {
441         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
442     }
443 
444     /**
445      * Returns the number of tokens burned by or on behalf of `owner`.
446      */
447     function _numberBurned(address owner) internal view returns (uint256) {
448         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
449     }
450 
451     /**
452      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
453      */
454     function _getAux(address owner) internal view returns (uint64) {
455         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
456     }
457 
458     /**
459      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
460      * If there are multiple variables, please pack them into a uint64.
461      */
462     function _setAux(address owner, uint64 aux) internal {
463         uint256 packed = _packedAddressData[owner];
464         uint256 auxCasted;
465         assembly { // Cast aux without masking.
466             auxCasted := aux
467         }
468         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
469         _packedAddressData[owner] = packed;
470     }
471 
472     /**
473      * Returns the packed ownership data of `tokenId`.
474      */
475     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
476         uint256 curr = tokenId;
477 
478         unchecked {
479             if (_startTokenId() <= curr)
480                 if (curr < _currentIndex) {
481                     uint256 packed = _packedOwnerships[curr];
482                     // If not burned.
483                     if (packed & BITMASK_BURNED == 0) {
484                         // Invariant:
485                         // There will always be an ownership that has an address and is not burned
486                         // before an ownership that does not have an address and is not burned.
487                         // Hence, curr will not underflow.
488                         //
489                         // We can directly compare the packed value.
490                         // If the address is zero, packed is zero.
491                         while (packed == 0) {
492                             packed = _packedOwnerships[--curr];
493                         }
494                         return packed;
495                     }
496                 }
497         }
498         revert OwnerQueryForNonexistentToken();
499     }
500 
501     /**
502      * Returns the unpacked `TokenOwnership` struct from `packed`.
503      */
504     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
505         ownership.addr = address(uint160(packed));
506         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
507         ownership.burned = packed & BITMASK_BURNED != 0;
508     }
509 
510     /**
511      * Returns the unpacked `TokenOwnership` struct at `index`.
512      */
513     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
514         return _unpackedOwnership(_packedOwnerships[index]);
515     }
516 
517     /**
518      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
519      */
520     function _initializeOwnershipAt(uint256 index) internal {
521         if (_packedOwnerships[index] == 0) {
522             _packedOwnerships[index] = _packedOwnershipOf(index);
523         }
524     }
525 
526     /**
527      * Gas spent here starts off proportional to the maximum mint batch size.
528      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
529      */
530     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
531         return _unpackedOwnership(_packedOwnershipOf(tokenId));
532     }
533 
534     /**
535      * @dev See {IERC721-ownerOf}.
536      */
537     function ownerOf(uint256 tokenId) public view override returns (address) {
538         return address(uint160(_packedOwnershipOf(tokenId)));
539     }
540 
541     /**
542      * @dev See {IERC721Metadata-name}.
543      */
544     function name() public view virtual override returns (string memory) {
545         return _name;
546     }
547 
548     /**
549      * @dev See {IERC721Metadata-symbol}.
550      */
551     function symbol() public view virtual override returns (string memory) {
552         return _symbol;
553     }
554 
555     /**
556      * @dev See {IERC721Metadata-tokenURI}.
557      */
558     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
559         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
560 
561         string memory baseURI = _baseURI();
562         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
563     }
564 
565     /**
566      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
567      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
568      * by default, can be overriden in child contracts.
569      */
570     function _baseURI() internal view virtual returns (string memory) {
571         return '';
572     }
573 
574     /**
575      * @dev Casts the address to uint256 without masking.
576      */
577     function _addressToUint256(address value) private pure returns (uint256 result) {
578         assembly {
579             result := value
580         }
581     }
582 
583     /**
584      * @dev Casts the boolean to uint256 without branching.
585      */
586     function _boolToUint256(bool value) private pure returns (uint256 result) {
587         assembly {
588             result := value
589         }
590     }
591 
592     /**
593      * @dev See {IERC721-approve}.
594      */
595     function approve(address to, uint256 tokenId) public override {
596         address owner = address(uint160(_packedOwnershipOf(tokenId)));
597         if (to == owner) revert ApprovalToCurrentOwner();
598 
599         if (_msgSenderERC721A() != owner)
600             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
601                 revert ApprovalCallerNotOwnerNorApproved();
602             }
603 
604         _tokenApprovals[tokenId] = to;
605         emit Approval(owner, to, tokenId);
606     }
607 
608     /**
609      * @dev See {IERC721-getApproved}.
610      */
611     function getApproved(uint256 tokenId) public view override returns (address) {
612         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
613 
614         return _tokenApprovals[tokenId];
615     }
616 
617     /**
618      * @dev See {IERC721-setApprovalForAll}.
619      */
620     function setApprovalForAll(address operator, bool approved) public virtual override {
621         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
622 
623         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
624         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
625     }
626 
627     /**
628      * @dev See {IERC721-isApprovedForAll}.
629      */
630     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
631         return _operatorApprovals[owner][operator];
632     }
633 
634     /**
635      * @dev See {IERC721-transferFrom}.
636      */
637     function transferFrom(
638         address from,
639         address to,
640         uint256 tokenId
641     ) public virtual override {
642         _transfer(from, to, tokenId);
643     }
644 
645     /**
646      * @dev See {IERC721-safeTransferFrom}.
647      */
648     function safeTransferFrom(
649         address from,
650         address to,
651         uint256 tokenId
652     ) public virtual override {
653         safeTransferFrom(from, to, tokenId, '');
654     }
655 
656     /**
657      * @dev See {IERC721-safeTransferFrom}.
658      */
659     function safeTransferFrom(
660         address from,
661         address to,
662         uint256 tokenId,
663         bytes memory _data
664     ) public virtual override {
665         _transfer(from, to, tokenId);
666         if (to.code.length != 0)
667             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
668                 revert TransferToNonERC721ReceiverImplementer();
669             }
670     }
671 
672     /**
673      * @dev Returns whether `tokenId` exists.
674      *
675      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
676      *
677      * Tokens start existing when they are minted (`_mint`),
678      */
679     function _exists(uint256 tokenId) internal view returns (bool) {
680         return
681             _startTokenId() <= tokenId &&
682             tokenId < _currentIndex && // If within bounds,
683             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
684     }
685 
686     /**
687      * @dev Equivalent to `_safeMint(to, quantity, '')`.
688      */
689     function _safeMint(address to, uint256 quantity) internal {
690         _safeMint(to, quantity, '');
691     }
692 
693     /**
694      * @dev Safely mints `quantity` tokens and transfers them to `to`.
695      *
696      * Requirements:
697      *
698      * - If `to` refers to a smart contract, it must implement
699      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
700      * - `quantity` must be greater than 0.
701      *
702      * Emits a {Transfer} event.
703      */
704     function _safeMint(
705         address to,
706         uint256 quantity,
707         bytes memory _data
708     ) internal {
709         uint256 startTokenId = _currentIndex;
710         if (to == address(0)) revert MintToZeroAddress();
711         if (quantity == 0) revert MintZeroQuantity();
712 
713         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
714 
715         // Overflows are incredibly unrealistic.
716         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
717         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
718         unchecked {
719             // Updates:
720             // - `balance += quantity`.
721             // - `numberMinted += quantity`.
722             //
723             // We can directly add to the balance and number minted.
724             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
725 
726             // Updates:
727             // - `address` to the owner.
728             // - `startTimestamp` to the timestamp of minting.
729             // - `burned` to `false`.
730             // - `nextInitialized` to `quantity == 1`.
731             _packedOwnerships[startTokenId] =
732                 _addressToUint256(to) |
733                 (block.timestamp << BITPOS_START_TIMESTAMP) |
734                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
735 
736             uint256 updatedIndex = startTokenId;
737             uint256 end = updatedIndex + quantity;
738 
739             if (to.code.length != 0) {
740                 do {
741                     emit Transfer(address(0), to, updatedIndex);
742                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
743                         revert TransferToNonERC721ReceiverImplementer();
744                     }
745                 } while (updatedIndex < end);
746                 // Reentrancy protection
747                 if (_currentIndex != startTokenId) revert();
748             } else {
749                 do {
750                     emit Transfer(address(0), to, updatedIndex++);
751                 } while (updatedIndex < end);
752             }
753             _currentIndex = updatedIndex;
754         }
755         _afterTokenTransfers(address(0), to, startTokenId, quantity);
756     }
757 
758     /**
759      * @dev Mints `quantity` tokens and transfers them to `to`.
760      *
761      * Requirements:
762      *
763      * - `to` cannot be the zero address.
764      * - `quantity` must be greater than 0.
765      *
766      * Emits a {Transfer} event.
767      */
768     function _mint(address to, uint256 quantity) internal {
769         uint256 startTokenId = _currentIndex;
770         if (to == address(0)) revert MintToZeroAddress();
771         if (quantity == 0) revert MintZeroQuantity();
772 
773         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
774 
775         // Overflows are incredibly unrealistic.
776         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
777         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
778         unchecked {
779             // Updates:
780             // - `balance += quantity`.
781             // - `numberMinted += quantity`.
782             //
783             // We can directly add to the balance and number minted.
784             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
785 
786             // Updates:
787             // - `address` to the owner.
788             // - `startTimestamp` to the timestamp of minting.
789             // - `burned` to `false`.
790             // - `nextInitialized` to `quantity == 1`.
791             _packedOwnerships[startTokenId] =
792                 _addressToUint256(to) |
793                 (block.timestamp << BITPOS_START_TIMESTAMP) |
794                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
795 
796             uint256 updatedIndex = startTokenId;
797             uint256 end = updatedIndex + quantity;
798 
799             do {
800                 emit Transfer(address(0), to, updatedIndex++);
801             } while (updatedIndex < end);
802 
803             _currentIndex = updatedIndex;
804         }
805         _afterTokenTransfers(address(0), to, startTokenId, quantity);
806     }
807 
808     /**
809      * @dev Transfers `tokenId` from `from` to `to`.
810      *
811      * Requirements:
812      *
813      * - `to` cannot be the zero address.
814      * - `tokenId` token must be owned by `from`.
815      *
816      * Emits a {Transfer} event.
817      */
818     function _transfer(
819         address from,
820         address to,
821         uint256 tokenId
822     ) private {
823         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
824 
825         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
826 
827         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
828             isApprovedForAll(from, _msgSenderERC721A()) ||
829             getApproved(tokenId) == _msgSenderERC721A());
830 
831         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
832         if (to == address(0)) revert TransferToZeroAddress();
833 
834         _beforeTokenTransfers(from, to, tokenId, 1);
835 
836         // Clear approvals from the previous owner.
837         delete _tokenApprovals[tokenId];
838 
839         // Underflow of the sender's balance is impossible because we check for
840         // ownership above and the recipient's balance can't realistically overflow.
841         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
842         unchecked {
843             // We can directly increment and decrement the balances.
844             --_packedAddressData[from]; // Updates: `balance -= 1`.
845             ++_packedAddressData[to]; // Updates: `balance += 1`.
846 
847             // Updates:
848             // - `address` to the next owner.
849             // - `startTimestamp` to the timestamp of transfering.
850             // - `burned` to `false`.
851             // - `nextInitialized` to `true`.
852             _packedOwnerships[tokenId] =
853                 _addressToUint256(to) |
854                 (block.timestamp << BITPOS_START_TIMESTAMP) |
855                 BITMASK_NEXT_INITIALIZED;
856 
857             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
858             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
859                 uint256 nextTokenId = tokenId + 1;
860                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
861                 if (_packedOwnerships[nextTokenId] == 0) {
862                     // If the next slot is within bounds.
863                     if (nextTokenId != _currentIndex) {
864                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
865                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
866                     }
867                 }
868             }
869         }
870 
871         emit Transfer(from, to, tokenId);
872         _afterTokenTransfers(from, to, tokenId, 1);
873     }
874 
875     /**
876      * @dev Equivalent to `_burn(tokenId, false)`.
877      */
878     function _burn(uint256 tokenId) internal virtual {
879         _burn(tokenId, false);
880     }
881 
882     /**
883      * @dev Destroys `tokenId`.
884      * The approval is cleared when the token is burned.
885      *
886      * Requirements:
887      *
888      * - `tokenId` must exist.
889      *
890      * Emits a {Transfer} event.
891      */
892     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
893         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
894 
895         address from = address(uint160(prevOwnershipPacked));
896 
897         if (approvalCheck) {
898             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
899                 isApprovedForAll(from, _msgSenderERC721A()) ||
900                 getApproved(tokenId) == _msgSenderERC721A());
901 
902             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
903         }
904 
905         _beforeTokenTransfers(from, address(0), tokenId, 1);
906 
907         // Clear approvals from the previous owner.
908         delete _tokenApprovals[tokenId];
909 
910         // Underflow of the sender's balance is impossible because we check for
911         // ownership above and the recipient's balance can't realistically overflow.
912         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
913         unchecked {
914             // Updates:
915             // - `balance -= 1`.
916             // - `numberBurned += 1`.
917             //
918             // We can directly decrement the balance, and increment the number burned.
919             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
920             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
921 
922             // Updates:
923             // - `address` to the last owner.
924             // - `startTimestamp` to the timestamp of burning.
925             // - `burned` to `true`.
926             // - `nextInitialized` to `true`.
927             _packedOwnerships[tokenId] =
928                 _addressToUint256(from) |
929                 (block.timestamp << BITPOS_START_TIMESTAMP) |
930                 BITMASK_BURNED | 
931                 BITMASK_NEXT_INITIALIZED;
932 
933             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
934             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
935                 uint256 nextTokenId = tokenId + 1;
936                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
937                 if (_packedOwnerships[nextTokenId] == 0) {
938                     // If the next slot is within bounds.
939                     if (nextTokenId != _currentIndex) {
940                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
941                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
942                     }
943                 }
944             }
945         }
946 
947         emit Transfer(from, address(0), tokenId);
948         _afterTokenTransfers(from, address(0), tokenId, 1);
949 
950         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
951         unchecked {
952             _burnCounter++;
953         }
954     }
955 
956     /**
957      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
958      *
959      * @param from address representing the previous owner of the given token ID
960      * @param to target address that will receive the tokens
961      * @param tokenId uint256 ID of the token to be transferred
962      * @param _data bytes optional data to send along with the call
963      * @return bool whether the call correctly returned the expected magic value
964      */
965     function _checkContractOnERC721Received(
966         address from,
967         address to,
968         uint256 tokenId,
969         bytes memory _data
970     ) private returns (bool) {
971         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
972             bytes4 retval
973         ) {
974             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
975         } catch (bytes memory reason) {
976             if (reason.length == 0) {
977                 revert TransferToNonERC721ReceiverImplementer();
978             } else {
979                 assembly {
980                     revert(add(32, reason), mload(reason))
981                 }
982             }
983         }
984     }
985 
986     /**
987      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
988      * And also called before burning one token.
989      *
990      * startTokenId - the first token id to be transferred
991      * quantity - the amount to be transferred
992      *
993      * Calling conditions:
994      *
995      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
996      * transferred to `to`.
997      * - When `from` is zero, `tokenId` will be minted for `to`.
998      * - When `to` is zero, `tokenId` will be burned by `from`.
999      * - `from` and `to` are never both zero.
1000      */
1001     function _beforeTokenTransfers(
1002         address from,
1003         address to,
1004         uint256 startTokenId,
1005         uint256 quantity
1006     ) internal virtual {}
1007 
1008     /**
1009      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1010      * minting.
1011      * And also called after one token has been burned.
1012      *
1013      * startTokenId - the first token id to be transferred
1014      * quantity - the amount to be transferred
1015      *
1016      * Calling conditions:
1017      *
1018      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1019      * transferred to `to`.
1020      * - When `from` is zero, `tokenId` has been minted for `to`.
1021      * - When `to` is zero, `tokenId` has been burned by `from`.
1022      * - `from` and `to` are never both zero.
1023      */
1024     function _afterTokenTransfers(
1025         address from,
1026         address to,
1027         uint256 startTokenId,
1028         uint256 quantity
1029     ) internal virtual {}
1030 
1031     /**
1032      * @dev Returns the message sender (defaults to `msg.sender`).
1033      *
1034      * If you are writing GSN compatible contracts, you need to override this function.
1035      */
1036     function _msgSenderERC721A() internal view virtual returns (address) {
1037         return msg.sender;
1038     }
1039 
1040     /**
1041      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1042      */
1043     function _toString(uint256 value) internal pure returns (string memory ptr) {
1044         assembly {
1045             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1046             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1047             // We will need 1 32-byte word to store the length, 
1048             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1049             ptr := add(mload(0x40), 128)
1050             // Update the free memory pointer to allocate.
1051             mstore(0x40, ptr)
1052 
1053             // Cache the end of the memory to calculate the length later.
1054             let end := ptr
1055 
1056             // We write the string from the rightmost digit to the leftmost digit.
1057             // The following is essentially a do-while loop that also handles the zero case.
1058             // Costs a bit more than early returning for the zero case,
1059             // but cheaper in terms of deployment and overall runtime costs.
1060             for { 
1061                 // Initialize and perform the first pass without check.
1062                 let temp := value
1063                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1064                 ptr := sub(ptr, 1)
1065                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1066                 mstore8(ptr, add(48, mod(temp, 10)))
1067                 temp := div(temp, 10)
1068             } temp { 
1069                 // Keep dividing `temp` until zero.
1070                 temp := div(temp, 10)
1071             } { // Body of the for loop.
1072                 ptr := sub(ptr, 1)
1073                 mstore8(ptr, add(48, mod(temp, 10)))
1074             }
1075             
1076             let length := sub(end, ptr)
1077             // Move the pointer 32 bytes leftwards to make room for the length.
1078             ptr := sub(ptr, 32)
1079             // Store the length.
1080             mstore(ptr, length)
1081         }
1082     }
1083 }
1084 
1085 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
1086 
1087 
1088 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
1089 
1090 pragma solidity ^0.8.0;
1091 
1092 /**
1093  * @dev String operations.
1094  */
1095 library Strings {
1096     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1097     uint8 private constant _ADDRESS_LENGTH = 20;
1098 
1099     /**
1100      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1101      */
1102     function toString(uint256 value) internal pure returns (string memory) {
1103         // Inspired by OraclizeAPI's implementation - MIT licence
1104         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1105 
1106         if (value == 0) {
1107             return "0";
1108         }
1109         uint256 temp = value;
1110         uint256 digits;
1111         while (temp != 0) {
1112             digits++;
1113             temp /= 10;
1114         }
1115         bytes memory buffer = new bytes(digits);
1116         while (value != 0) {
1117             digits -= 1;
1118             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1119             value /= 10;
1120         }
1121         return string(buffer);
1122     }
1123 
1124     /**
1125      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1126      */
1127     function toHexString(uint256 value) internal pure returns (string memory) {
1128         if (value == 0) {
1129             return "0x00";
1130         }
1131         uint256 temp = value;
1132         uint256 length = 0;
1133         while (temp != 0) {
1134             length++;
1135             temp >>= 8;
1136         }
1137         return toHexString(value, length);
1138     }
1139 
1140     /**
1141      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1142      */
1143     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1144         bytes memory buffer = new bytes(2 * length + 2);
1145         buffer[0] = "0";
1146         buffer[1] = "x";
1147         for (uint256 i = 2 * length + 1; i > 1; --i) {
1148             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1149             value >>= 4;
1150         }
1151         require(value == 0, "Strings: hex length insufficient");
1152         return string(buffer);
1153     }
1154 
1155     /**
1156      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1157      */
1158     function toHexString(address addr) internal pure returns (string memory) {
1159         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1160     }
1161 }
1162 
1163 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
1164 
1165 
1166 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1167 
1168 pragma solidity ^0.8.0;
1169 
1170 /**
1171  * @dev Provides information about the current execution context, including the
1172  * sender of the transaction and its data. While these are generally available
1173  * via msg.sender and msg.data, they should not be accessed in such a direct
1174  * manner, since when dealing with meta-transactions the account sending and
1175  * paying for execution may not be the actual sender (as far as an application
1176  * is concerned).
1177  *
1178  * This contract is only required for intermediate, library-like contracts.
1179  */
1180 abstract contract Context {
1181     function _msgSender() internal view virtual returns (address) {
1182         return msg.sender;
1183     }
1184 
1185     function _msgData() internal view virtual returns (bytes calldata) {
1186         return msg.data;
1187     }
1188 }
1189 
1190 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
1191 
1192 
1193 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1194 
1195 pragma solidity ^0.8.0;
1196 
1197 
1198 /**
1199  * @dev Contract module which provides a basic access control mechanism, where
1200  * there is an account (an owner) that can be granted exclusive access to
1201  * specific functions.
1202  *
1203  * By default, the owner account will be the one that deploys the contract. This
1204  * can later be changed with {transferOwnership}.
1205  *
1206  * This module is used through inheritance. It will make available the modifier
1207  * `onlyOwner`, which can be applied to your functions to restrict their use to
1208  * the owner.
1209  */
1210 abstract contract Ownable is Context {
1211     address private _owner;
1212 
1213     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1214 
1215     /**
1216      * @dev Initializes the contract setting the deployer as the initial owner.
1217      */
1218     constructor() {
1219         _transferOwnership(_msgSender());
1220     }
1221 
1222     /**
1223      * @dev Returns the address of the current owner.
1224      */
1225     function owner() public view virtual returns (address) {
1226         return _owner;
1227     }
1228 
1229     /**
1230      * @dev Throws if called by any account other than the owner.
1231      */
1232     modifier onlyOwner() {
1233         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1234         _;
1235     }
1236 
1237     /**
1238      * @dev Leaves the contract without owner. It will not be possible to call
1239      * `onlyOwner` functions anymore. Can only be called by the current owner.
1240      *
1241      * NOTE: Renouncing ownership will leave the contract without an owner,
1242      * thereby removing any functionality that is only available to the owner.
1243      */
1244     function renounceOwnership() public virtual onlyOwner {
1245         _transferOwnership(address(0));
1246     }
1247 
1248     /**
1249      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1250      * Can only be called by the current owner.
1251      */
1252     function transferOwnership(address newOwner) public virtual onlyOwner {
1253         require(newOwner != address(0), "Ownable: new owner is the zero address");
1254         _transferOwnership(newOwner);
1255     }
1256 
1257     /**
1258      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1259      * Internal function without access restriction.
1260      */
1261     function _transferOwnership(address newOwner) internal virtual {
1262         address oldOwner = _owner;
1263         _owner = newOwner;
1264         emit OwnershipTransferred(oldOwner, newOwner);
1265     }
1266 }
1267 
1268 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol
1269 
1270 
1271 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
1272 
1273 pragma solidity ^0.8.1;
1274 
1275 /**
1276  * @dev Collection of functions related to the address type
1277  */
1278 library Address {
1279     /**
1280      * @dev Returns true if `account` is a contract.
1281      *
1282      * [IMPORTANT]
1283      * ====
1284      * It is unsafe to assume that an address for which this function returns
1285      * false is an externally-owned account (EOA) and not a contract.
1286      *
1287      * Among others, `isContract` will return false for the following
1288      * types of addresses:
1289      *
1290      *  - an externally-owned account
1291      *  - a contract in construction
1292      *  - an address where a contract will be created
1293      *  - an address where a contract lived, but was destroyed
1294      * ====
1295      *
1296      * [IMPORTANT]
1297      * ====
1298      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1299      *
1300      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1301      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1302      * constructor.
1303      * ====
1304      */
1305     function isContract(address account) internal view returns (bool) {
1306         // This method relies on extcodesize/address.code.length, which returns 0
1307         // for contracts in construction, since the code is only stored at the end
1308         // of the constructor execution.
1309 
1310         return account.code.length > 0;
1311     }
1312 
1313     /**
1314      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1315      * `recipient`, forwarding all available gas and reverting on errors.
1316      *
1317      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1318      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1319      * imposed by `transfer`, making them unable to receive funds via
1320      * `transfer`. {sendValue} removes this limitation.
1321      *
1322      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1323      *
1324      * IMPORTANT: because control is transferred to `recipient`, care must be
1325      * taken to not create reentrancy vulnerabilities. Consider using
1326      * {ReentrancyGuard} or the
1327      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1328      */
1329     function sendValue(address payable recipient, uint256 amount) internal {
1330         require(address(this).balance >= amount, "Address: insufficient balance");
1331 
1332         (bool success, ) = recipient.call{value: amount}("");
1333         require(success, "Address: unable to send value, recipient may have reverted");
1334     }
1335 
1336     /**
1337      * @dev Performs a Solidity function call using a low level `call`. A
1338      * plain `call` is an unsafe replacement for a function call: use this
1339      * function instead.
1340      *
1341      * If `target` reverts with a revert reason, it is bubbled up by this
1342      * function (like regular Solidity function calls).
1343      *
1344      * Returns the raw returned data. To convert to the expected return value,
1345      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1346      *
1347      * Requirements:
1348      *
1349      * - `target` must be a contract.
1350      * - calling `target` with `data` must not revert.
1351      *
1352      * _Available since v3.1._
1353      */
1354     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1355         return functionCall(target, data, "Address: low-level call failed");
1356     }
1357 
1358     /**
1359      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1360      * `errorMessage` as a fallback revert reason when `target` reverts.
1361      *
1362      * _Available since v3.1._
1363      */
1364     function functionCall(
1365         address target,
1366         bytes memory data,
1367         string memory errorMessage
1368     ) internal returns (bytes memory) {
1369         return functionCallWithValue(target, data, 0, errorMessage);
1370     }
1371 
1372     /**
1373      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1374      * but also transferring `value` wei to `target`.
1375      *
1376      * Requirements:
1377      *
1378      * - the calling contract must have an ETH balance of at least `value`.
1379      * - the called Solidity function must be `payable`.
1380      *
1381      * _Available since v3.1._
1382      */
1383     function functionCallWithValue(
1384         address target,
1385         bytes memory data,
1386         uint256 value
1387     ) internal returns (bytes memory) {
1388         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1389     }
1390 
1391     /**
1392      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1393      * with `errorMessage` as a fallback revert reason when `target` reverts.
1394      *
1395      * _Available since v3.1._
1396      */
1397     function functionCallWithValue(
1398         address target,
1399         bytes memory data,
1400         uint256 value,
1401         string memory errorMessage
1402     ) internal returns (bytes memory) {
1403         require(address(this).balance >= value, "Address: insufficient balance for call");
1404         require(isContract(target), "Address: call to non-contract");
1405 
1406         (bool success, bytes memory returndata) = target.call{value: value}(data);
1407         return verifyCallResult(success, returndata, errorMessage);
1408     }
1409 
1410     /**
1411      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1412      * but performing a static call.
1413      *
1414      * _Available since v3.3._
1415      */
1416     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1417         return functionStaticCall(target, data, "Address: low-level static call failed");
1418     }
1419 
1420     /**
1421      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1422      * but performing a static call.
1423      *
1424      * _Available since v3.3._
1425      */
1426     function functionStaticCall(
1427         address target,
1428         bytes memory data,
1429         string memory errorMessage
1430     ) internal view returns (bytes memory) {
1431         require(isContract(target), "Address: static call to non-contract");
1432 
1433         (bool success, bytes memory returndata) = target.staticcall(data);
1434         return verifyCallResult(success, returndata, errorMessage);
1435     }
1436 
1437     /**
1438      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1439      * but performing a delegate call.
1440      *
1441      * _Available since v3.4._
1442      */
1443     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1444         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1445     }
1446 
1447     /**
1448      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1449      * but performing a delegate call.
1450      *
1451      * _Available since v3.4._
1452      */
1453     function functionDelegateCall(
1454         address target,
1455         bytes memory data,
1456         string memory errorMessage
1457     ) internal returns (bytes memory) {
1458         require(isContract(target), "Address: delegate call to non-contract");
1459 
1460         (bool success, bytes memory returndata) = target.delegatecall(data);
1461         return verifyCallResult(success, returndata, errorMessage);
1462     }
1463 
1464     /**
1465      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1466      * revert reason using the provided one.
1467      *
1468      * _Available since v4.3._
1469      */
1470     function verifyCallResult(
1471         bool success,
1472         bytes memory returndata,
1473         string memory errorMessage
1474     ) internal pure returns (bytes memory) {
1475         if (success) {
1476             return returndata;
1477         } else {
1478             // Look for revert reason and bubble it up if present
1479             if (returndata.length > 0) {
1480                 // The easiest way to bubble the revert reason is using memory via assembly
1481 
1482                 assembly {
1483                     let returndata_size := mload(returndata)
1484                     revert(add(32, returndata), returndata_size)
1485                 }
1486             } else {
1487                 revert(errorMessage);
1488             }
1489         }
1490     }
1491 }
1492 
1493 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721Receiver.sol
1494 
1495 
1496 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
1497 
1498 pragma solidity ^0.8.0;
1499 
1500 /**
1501  * @title ERC721 token receiver interface
1502  * @dev Interface for any contract that wants to support safeTransfers
1503  * from ERC721 asset contracts.
1504  */
1505 interface IERC721Receiver {
1506     /**
1507      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1508      * by `operator` from `from`, this function is called.
1509      *
1510      * It must return its Solidity selector to confirm the token transfer.
1511      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1512      *
1513      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
1514      */
1515     function onERC721Received(
1516         address operator,
1517         address from,
1518         uint256 tokenId,
1519         bytes calldata data
1520     ) external returns (bytes4);
1521 }
1522 
1523 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/IERC165.sol
1524 
1525 
1526 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1527 
1528 pragma solidity ^0.8.0;
1529 
1530 /**
1531  * @dev Interface of the ERC165 standard, as defined in the
1532  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1533  *
1534  * Implementers can declare support of contract interfaces, which can then be
1535  * queried by others ({ERC165Checker}).
1536  *
1537  * For an implementation, see {ERC165}.
1538  */
1539 interface IERC165 {
1540     /**
1541      * @dev Returns true if this contract implements the interface defined by
1542      * `interfaceId`. See the corresponding
1543      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1544      * to learn more about how these ids are created.
1545      *
1546      * This function call must use less than 30 000 gas.
1547      */
1548     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1549 }
1550 
1551 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/ERC165.sol
1552 
1553 
1554 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1555 
1556 pragma solidity ^0.8.0;
1557 
1558 
1559 /**
1560  * @dev Implementation of the {IERC165} interface.
1561  *
1562  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1563  * for the additional interface id that will be supported. For example:
1564  *
1565  * ```solidity
1566  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1567  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1568  * }
1569  * ```
1570  *
1571  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1572  */
1573 abstract contract ERC165 is IERC165 {
1574     /**
1575      * @dev See {IERC165-supportsInterface}.
1576      */
1577     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1578         return interfaceId == type(IERC165).interfaceId;
1579     }
1580 }
1581 
1582 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721.sol
1583 
1584 
1585 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
1586 
1587 pragma solidity ^0.8.0;
1588 
1589 
1590 /**
1591  * @dev Required interface of an ERC721 compliant contract.
1592  */
1593 interface IERC721 is IERC165 {
1594     /**
1595      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1596      */
1597     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1598 
1599     /**
1600      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1601      */
1602     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1603 
1604     /**
1605      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1606      */
1607     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1608 
1609     /**
1610      * @dev Returns the number of tokens in ``owner``'s account.
1611      */
1612     function balanceOf(address owner) external view returns (uint256 balance);
1613 
1614     /**
1615      * @dev Returns the owner of the `tokenId` token.
1616      *
1617      * Requirements:
1618      *
1619      * - `tokenId` must exist.
1620      */
1621     function ownerOf(uint256 tokenId) external view returns (address owner);
1622 
1623     /**
1624      * @dev Safely transfers `tokenId` token from `from` to `to`.
1625      *
1626      * Requirements:
1627      *
1628      * - `from` cannot be the zero address.
1629      * - `to` cannot be the zero address.
1630      * - `tokenId` token must exist and be owned by `from`.
1631      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1632      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1633      *
1634      * Emits a {Transfer} event.
1635      */
1636     function safeTransferFrom(
1637         address from,
1638         address to,
1639         uint256 tokenId,
1640         bytes calldata data
1641     ) external;
1642 
1643     /**
1644      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1645      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1646      *
1647      * Requirements:
1648      *
1649      * - `from` cannot be the zero address.
1650      * - `to` cannot be the zero address.
1651      * - `tokenId` token must exist and be owned by `from`.
1652      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1653      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1654      *
1655      * Emits a {Transfer} event.
1656      */
1657     function safeTransferFrom(
1658         address from,
1659         address to,
1660         uint256 tokenId
1661     ) external;
1662 
1663     /**
1664      * @dev Transfers `tokenId` token from `from` to `to`.
1665      *
1666      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1667      *
1668      * Requirements:
1669      *
1670      * - `from` cannot be the zero address.
1671      * - `to` cannot be the zero address.
1672      * - `tokenId` token must be owned by `from`.
1673      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1674      *
1675      * Emits a {Transfer} event.
1676      */
1677     function transferFrom(
1678         address from,
1679         address to,
1680         uint256 tokenId
1681     ) external;
1682 
1683     /**
1684      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1685      * The approval is cleared when the token is transferred.
1686      *
1687      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1688      *
1689      * Requirements:
1690      *
1691      * - The caller must own the token or be an approved operator.
1692      * - `tokenId` must exist.
1693      *
1694      * Emits an {Approval} event.
1695      */
1696     function approve(address to, uint256 tokenId) external;
1697 
1698     /**
1699      * @dev Approve or remove `operator` as an operator for the caller.
1700      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1701      *
1702      * Requirements:
1703      *
1704      * - The `operator` cannot be the caller.
1705      *
1706      * Emits an {ApprovalForAll} event.
1707      */
1708     function setApprovalForAll(address operator, bool _approved) external;
1709 
1710     /**
1711      * @dev Returns the account approved for `tokenId` token.
1712      *
1713      * Requirements:
1714      *
1715      * - `tokenId` must exist.
1716      */
1717     function getApproved(uint256 tokenId) external view returns (address operator);
1718 
1719     /**
1720      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1721      *
1722      * See {setApprovalForAll}
1723      */
1724     function isApprovedForAll(address owner, address operator) external view returns (bool);
1725 }
1726 
1727 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/IERC721Metadata.sol
1728 
1729 
1730 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1731 
1732 pragma solidity ^0.8.0;
1733 
1734 
1735 /**
1736  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1737  * @dev See https://eips.ethereum.org/EIPS/eip-721
1738  */
1739 interface IERC721Metadata is IERC721 {
1740     /**
1741      * @dev Returns the token collection name.
1742      */
1743     function name() external view returns (string memory);
1744 
1745     /**
1746      * @dev Returns the token collection symbol.
1747      */
1748     function symbol() external view returns (string memory);
1749 
1750     /**
1751      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1752      */
1753     function tokenURI(uint256 tokenId) external view returns (string memory);
1754 }
1755 
1756 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol
1757 
1758 
1759 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
1760 
1761 pragma solidity ^0.8.0;
1762 
1763 
1764 
1765 
1766 
1767 
1768 
1769 
1770 /**
1771  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1772  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1773  * {ERC721Enumerable}.
1774  */
1775 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1776     using Address for address;
1777     using Strings for uint256;
1778 
1779     // Token name
1780     string private _name;
1781 
1782     // Token symbol
1783     string private _symbol;
1784 
1785     // Mapping from token ID to owner address
1786     mapping(uint256 => address) private _owners;
1787 
1788     // Mapping owner address to token count
1789     mapping(address => uint256) private _balances;
1790 
1791     // Mapping from token ID to approved address
1792     mapping(uint256 => address) private _tokenApprovals;
1793 
1794     // Mapping from owner to operator approvals
1795     mapping(address => mapping(address => bool)) private _operatorApprovals;
1796 
1797     /**
1798      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1799      */
1800     constructor(string memory name_, string memory symbol_) {
1801         _name = name_;
1802         _symbol = symbol_;
1803     }
1804 
1805     /**
1806      * @dev See {IERC165-supportsInterface}.
1807      */
1808     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1809         return
1810             interfaceId == type(IERC721).interfaceId ||
1811             interfaceId == type(IERC721Metadata).interfaceId ||
1812             super.supportsInterface(interfaceId);
1813     }
1814 
1815     /**
1816      * @dev See {IERC721-balanceOf}.
1817      */
1818     function balanceOf(address owner) public view virtual override returns (uint256) {
1819         require(owner != address(0), "ERC721: address zero is not a valid owner");
1820         return _balances[owner];
1821     }
1822 
1823     /**
1824      * @dev See {IERC721-ownerOf}.
1825      */
1826     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1827         address owner = _owners[tokenId];
1828         require(owner != address(0), "ERC721: owner query for nonexistent token");
1829         return owner;
1830     }
1831 
1832     /**
1833      * @dev See {IERC721Metadata-name}.
1834      */
1835     function name() public view virtual override returns (string memory) {
1836         return _name;
1837     }
1838 
1839     /**
1840      * @dev See {IERC721Metadata-symbol}.
1841      */
1842     function symbol() public view virtual override returns (string memory) {
1843         return _symbol;
1844     }
1845 
1846     /**
1847      * @dev See {IERC721Metadata-tokenURI}.
1848      */
1849     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1850         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1851 
1852         string memory baseURI = _baseURI();
1853         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1854     }
1855 
1856     /**
1857      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1858      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1859      * by default, can be overridden in child contracts.
1860      */
1861     function _baseURI() internal view virtual returns (string memory) {
1862         return "";
1863     }
1864 
1865     /**
1866      * @dev See {IERC721-approve}.
1867      */
1868     function approve(address to, uint256 tokenId) public virtual override {
1869         address owner = ERC721.ownerOf(tokenId);
1870         require(to != owner, "ERC721: approval to current owner");
1871 
1872         require(
1873             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1874             "ERC721: approve caller is not owner nor approved for all"
1875         );
1876 
1877         _approve(to, tokenId);
1878     }
1879 
1880     /**
1881      * @dev See {IERC721-getApproved}.
1882      */
1883     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1884         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1885 
1886         return _tokenApprovals[tokenId];
1887     }
1888 
1889     /**
1890      * @dev See {IERC721-setApprovalForAll}.
1891      */
1892     function setApprovalForAll(address operator, bool approved) public virtual override {
1893         _setApprovalForAll(_msgSender(), operator, approved);
1894     }
1895 
1896     /**
1897      * @dev See {IERC721-isApprovedForAll}.
1898      */
1899     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1900         return _operatorApprovals[owner][operator];
1901     }
1902 
1903     /**
1904      * @dev See {IERC721-transferFrom}.
1905      */
1906     function transferFrom(
1907         address from,
1908         address to,
1909         uint256 tokenId
1910     ) public virtual override {
1911         //solhint-disable-next-line max-line-length
1912         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1913 
1914         _transfer(from, to, tokenId);
1915     }
1916 
1917     /**
1918      * @dev See {IERC721-safeTransferFrom}.
1919      */
1920     function safeTransferFrom(
1921         address from,
1922         address to,
1923         uint256 tokenId
1924     ) public virtual override {
1925         safeTransferFrom(from, to, tokenId, "");
1926     }
1927 
1928     /**
1929      * @dev See {IERC721-safeTransferFrom}.
1930      */
1931     function safeTransferFrom(
1932         address from,
1933         address to,
1934         uint256 tokenId,
1935         bytes memory data
1936     ) public virtual override {
1937         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1938         _safeTransfer(from, to, tokenId, data);
1939     }
1940 
1941     /**
1942      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1943      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1944      *
1945      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1946      *
1947      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1948      * implement alternative mechanisms to perform token transfer, such as signature-based.
1949      *
1950      * Requirements:
1951      *
1952      * - `from` cannot be the zero address.
1953      * - `to` cannot be the zero address.
1954      * - `tokenId` token must exist and be owned by `from`.
1955      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1956      *
1957      * Emits a {Transfer} event.
1958      */
1959     function _safeTransfer(
1960         address from,
1961         address to,
1962         uint256 tokenId,
1963         bytes memory data
1964     ) internal virtual {
1965         _transfer(from, to, tokenId);
1966         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1967     }
1968 
1969     /**
1970      * @dev Returns whether `tokenId` exists.
1971      *
1972      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1973      *
1974      * Tokens start existing when they are minted (`_mint`),
1975      * and stop existing when they are burned (`_burn`).
1976      */
1977     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1978         return _owners[tokenId] != address(0);
1979     }
1980 
1981     /**
1982      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1983      *
1984      * Requirements:
1985      *
1986      * - `tokenId` must exist.
1987      */
1988     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1989         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1990         address owner = ERC721.ownerOf(tokenId);
1991         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1992     }
1993 
1994     /**
1995      * @dev Safely mints `tokenId` and transfers it to `to`.
1996      *
1997      * Requirements:
1998      *
1999      * - `tokenId` must not exist.
2000      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2001      *
2002      * Emits a {Transfer} event.
2003      */
2004     function _safeMint(address to, uint256 tokenId) internal virtual {
2005         _safeMint(to, tokenId, "");
2006     }
2007 
2008     /**
2009      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
2010      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
2011      */
2012     function _safeMint(
2013         address to,
2014         uint256 tokenId,
2015         bytes memory data
2016     ) internal virtual {
2017         _mint(to, tokenId);
2018         require(
2019             _checkOnERC721Received(address(0), to, tokenId, data),
2020             "ERC721: transfer to non ERC721Receiver implementer"
2021         );
2022     }
2023 
2024     /**
2025      * @dev Mints `tokenId` and transfers it to `to`.
2026      *
2027      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
2028      *
2029      * Requirements:
2030      *
2031      * - `tokenId` must not exist.
2032      * - `to` cannot be the zero address.
2033      *
2034      * Emits a {Transfer} event.
2035      */
2036     function _mint(address to, uint256 tokenId) internal virtual {
2037         require(to != address(0), "ERC721: mint to the zero address");
2038         require(!_exists(tokenId), "ERC721: token already minted");
2039 
2040         _beforeTokenTransfer(address(0), to, tokenId);
2041 
2042         _balances[to] += 1;
2043         _owners[tokenId] = to;
2044 
2045         emit Transfer(address(0), to, tokenId);
2046 
2047         _afterTokenTransfer(address(0), to, tokenId);
2048     }
2049 
2050     /**
2051      * @dev Destroys `tokenId`.
2052      * The approval is cleared when the token is burned.
2053      *
2054      * Requirements:
2055      *
2056      * - `tokenId` must exist.
2057      *
2058      * Emits a {Transfer} event.
2059      */
2060     function _burn(uint256 tokenId) internal virtual {
2061         address owner = ERC721.ownerOf(tokenId);
2062 
2063         _beforeTokenTransfer(owner, address(0), tokenId);
2064 
2065         // Clear approvals
2066         _approve(address(0), tokenId);
2067 
2068         _balances[owner] -= 1;
2069         delete _owners[tokenId];
2070 
2071         emit Transfer(owner, address(0), tokenId);
2072 
2073         _afterTokenTransfer(owner, address(0), tokenId);
2074     }
2075 
2076     /**
2077      * @dev Transfers `tokenId` from `from` to `to`.
2078      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2079      *
2080      * Requirements:
2081      *
2082      * - `to` cannot be the zero address.
2083      * - `tokenId` token must be owned by `from`.
2084      *
2085      * Emits a {Transfer} event.
2086      */
2087     function _transfer(
2088         address from,
2089         address to,
2090         uint256 tokenId
2091     ) internal virtual {
2092         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
2093         require(to != address(0), "ERC721: transfer to the zero address");
2094 
2095         _beforeTokenTransfer(from, to, tokenId);
2096 
2097         // Clear approvals from the previous owner
2098         _approve(address(0), tokenId);
2099 
2100         _balances[from] -= 1;
2101         _balances[to] += 1;
2102         _owners[tokenId] = to;
2103 
2104         emit Transfer(from, to, tokenId);
2105 
2106         _afterTokenTransfer(from, to, tokenId);
2107     }
2108 
2109     /**
2110      * @dev Approve `to` to operate on `tokenId`
2111      *
2112      * Emits an {Approval} event.
2113      */
2114     function _approve(address to, uint256 tokenId) internal virtual {
2115         _tokenApprovals[tokenId] = to;
2116         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
2117     }
2118 
2119     /**
2120      * @dev Approve `operator` to operate on all of `owner` tokens
2121      *
2122      * Emits an {ApprovalForAll} event.
2123      */
2124     function _setApprovalForAll(
2125         address owner,
2126         address operator,
2127         bool approved
2128     ) internal virtual {
2129         require(owner != operator, "ERC721: approve to caller");
2130         _operatorApprovals[owner][operator] = approved;
2131         emit ApprovalForAll(owner, operator, approved);
2132     }
2133 
2134     /**
2135      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2136      * The call is not executed if the target address is not a contract.
2137      *
2138      * @param from address representing the previous owner of the given token ID
2139      * @param to target address that will receive the tokens
2140      * @param tokenId uint256 ID of the token to be transferred
2141      * @param data bytes optional data to send along with the call
2142      * @return bool whether the call correctly returned the expected magic value
2143      */
2144     function _checkOnERC721Received(
2145         address from,
2146         address to,
2147         uint256 tokenId,
2148         bytes memory data
2149     ) private returns (bool) {
2150         if (to.isContract()) {
2151             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
2152                 return retval == IERC721Receiver.onERC721Received.selector;
2153             } catch (bytes memory reason) {
2154                 if (reason.length == 0) {
2155                     revert("ERC721: transfer to non ERC721Receiver implementer");
2156                 } else {
2157                     assembly {
2158                         revert(add(32, reason), mload(reason))
2159                     }
2160                 }
2161             }
2162         } else {
2163             return true;
2164         }
2165     }
2166 
2167     /**
2168      * @dev Hook that is called before any token transfer. This includes minting
2169      * and burning.
2170      *
2171      * Calling conditions:
2172      *
2173      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2174      * transferred to `to`.
2175      * - When `from` is zero, `tokenId` will be minted for `to`.
2176      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2177      * - `from` and `to` are never both zero.
2178      *
2179      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2180      */
2181     function _beforeTokenTransfer(
2182         address from,
2183         address to,
2184         uint256 tokenId
2185     ) internal virtual {}
2186 
2187     /**
2188      * @dev Hook that is called after any transfer of tokens. This includes
2189      * minting and burning.
2190      *
2191      * Calling conditions:
2192      *
2193      * - when `from` and `to` are both non-zero.
2194      * - `from` and `to` are never both zero.
2195      *
2196      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2197      */
2198     function _afterTokenTransfer(
2199         address from,
2200         address to,
2201         uint256 tokenId
2202     ) internal virtual {}
2203 }
2204 
2205 
2206 pragma solidity ^0.8.0;
2207 
2208 
2209 contract Moodbearz is ERC721A, Ownable {
2210 
2211     using Strings for uint256;
2212 
2213     string private baseURI;
2214 
2215     uint256 public price = 0.005 ether;
2216 
2217     uint256 public maxPerTx = 10;
2218 
2219     uint256 public maxFreePerWallet = 1;
2220 
2221     uint256 public totalFree = 2100;
2222 
2223     uint256 public maxSupply = 10001;
2224 
2225     bool public mintEnabled = false;
2226 
2227     mapping(address => uint256) private _mintedFreeAmount;
2228 
2229     constructor() ERC721A("Moodbearz", "MBZ") {
2230         _safeMint(msg.sender, 100);
2231         setBaseURI("ipfs://QmRszNbEjepD7yTWNrr4p4RepyxUafn8Gq6mZuKGFUePjM/");
2232     }
2233 
2234     function mint(uint256 count) external payable {
2235         uint256 cost = price;
2236         bool isFree = ((totalSupply() + count < totalFree + 1) &&
2237             (_mintedFreeAmount[msg.sender] + count <= maxFreePerWallet));
2238 
2239         if (isFree) {
2240             cost = 0;
2241         }
2242 
2243         require(msg.value >= count * cost, "Please send the exact amount.");
2244         require(totalSupply() + count < maxSupply + 1, "No more");
2245         require(mintEnabled, "Minting is not live yet");
2246         require(count < maxPerTx + 1, "Max per TX reached.");
2247 
2248         if (isFree) {
2249             _mintedFreeAmount[msg.sender] += count;
2250         }
2251 
2252         _safeMint(msg.sender, count);
2253     }
2254 
2255     function _baseURI() internal view virtual override returns (string memory) {
2256         return baseURI;
2257     }
2258 
2259     function tokenURI(uint256 tokenId)
2260         public
2261         view
2262         virtual
2263         override
2264         returns (string memory)
2265     {
2266         require(
2267             _exists(tokenId),
2268             "ERC721Metadata: URI query for nonexistent token"
2269         );
2270         return string(abi.encodePacked(baseURI, tokenId.toString(), ""));
2271     }
2272 
2273     function setBaseURI(string memory uri) public onlyOwner {
2274         baseURI = uri;
2275     }
2276 
2277     function setFreeAmount(uint256 amount) external onlyOwner {
2278         totalFree = amount;
2279     }
2280 
2281     function setPrice(uint256 _newPrice) external onlyOwner {
2282         price = _newPrice;
2283     }
2284 
2285     function flipSale() external onlyOwner {
2286         mintEnabled = !mintEnabled;
2287     }
2288 
2289     function withdraw() external onlyOwner {
2290         (bool success, ) = payable(msg.sender).call{
2291             value: address(this).balance
2292         }("");
2293         require(success, "Transfer failed.");
2294     }
2295 }