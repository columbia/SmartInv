1 /* 
2 
3 :......::::.......::::::..:::::........:::......:::..:::::..:::::..::::::......:::
4 :'######::'##::::'##:'########:'########::'######:::::'###::::'########::'######::
5 '##... ##: ##:::: ##:... ##..:: ##.....::'##... ##:::'## ##:::... ##..::'##... ##:
6  ##:::..:: ##:::: ##:::: ##:::: ##::::::: ##:::..:::'##:. ##::::: ##:::: ##:::..::
7  ##::::::: ##:::: ##:::: ##:::: ######::: ##:::::::'##:::. ##:::: ##::::. ######::
8  ##::::::: ##:::: ##:::: ##:::: ##...:::: ##::::::: #########:::: ##:::::..... ##:
9  ##::: ##: ##:::: ##:::: ##:::: ##::::::: ##::: ##: ##.... ##:::: ##::::'##::: ##:
10 . ######::. #######::::: ##:::: ########:. ######:: ##:::: ##:::: ##::::. ######::
11 :......::::.......::::::..:::::........:::......:::..:::::..:::::..::::::......:::
12 
13 
14 /**
15  *Submitted for verification at Etherscan.io on 2022-05-24
16 */
17 
18 // SPDX-License-Identifier: MIT
19 
20 
21 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/IERC721A.sol
22 
23 
24 // ERC721A Contracts v3.3.0
25 // Creator: Chiru Labs
26 
27 pragma solidity ^0.8.4;
28 
29 /**
30  * @dev Interface of an ERC721A compliant contract.
31  */
32 interface IERC721A {
33     /**
34      * The caller must own the token or be an approved operator.
35      */
36     error ApprovalCallerNotOwnerNorApproved();
37 
38     /**
39      * The token does not exist.
40      */
41     error ApprovalQueryForNonexistentToken();
42 
43     /**
44      * The caller cannot approve to their own address.
45      */
46     error ApproveToCaller();
47 
48     /**
49      * The caller cannot approve to the current owner.
50      */
51     error ApprovalToCurrentOwner();
52 
53     /**
54      * Cannot query the balance for the zero address.
55      */
56     error BalanceQueryForZeroAddress();
57 
58     /**
59      * Cannot mint to the zero address.
60      */
61     error MintToZeroAddress();
62 
63     /**
64      * The quantity of tokens minted must be more than zero.
65      */
66     error MintZeroQuantity();
67 
68     /**
69      * The token does not exist.
70      */
71     error OwnerQueryForNonexistentToken();
72 
73     /**
74      * The caller must own the token or be an approved operator.
75      */
76     error TransferCallerNotOwnerNorApproved();
77 
78     /**
79      * The token must be owned by `from`.
80      */
81     error TransferFromIncorrectOwner();
82 
83     /**
84      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
85      */
86     error TransferToNonERC721ReceiverImplementer();
87 
88     /**
89      * Cannot transfer to the zero address.
90      */
91     error TransferToZeroAddress();
92 
93     /**
94      * The token does not exist.
95      */
96     error URIQueryForNonexistentToken();
97 
98     struct TokenOwnership {
99         // The address of the owner.
100         address addr;
101         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
102         uint64 startTimestamp;
103         // Whether the token has been burned.
104         bool burned;
105     }
106 
107     /**
108      * @dev Returns the total amount of tokens stored by the contract.
109      *
110      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
111      */
112     function totalSupply() external view returns (uint256);
113 
114     // ==============================
115     //            IERC165
116     // ==============================
117 
118     /**
119      * @dev Returns true if this contract implements the interface defined by
120      * `interfaceId`. See the corresponding
121      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
122      * to learn more about how these ids are created.
123      *
124      * This function call must use less than 30 000 gas.
125      */
126     function supportsInterface(bytes4 interfaceId) external view returns (bool);
127 
128     // ==============================
129     //            IERC721
130     // ==============================
131 
132     /**
133      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
134      */
135     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
136 
137     /**
138      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
139      */
140     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
141 
142     /**
143      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
144      */
145     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
146 
147     /**
148      * @dev Returns the number of tokens in ``owner``'s account.
149      */
150     function balanceOf(address owner) external view returns (uint256 balance);
151 
152     /**
153      * @dev Returns the owner of the `tokenId` token.
154      *
155      * Requirements:
156      *
157      * - `tokenId` must exist.
158      */
159     function ownerOf(uint256 tokenId) external view returns (address owner);
160 
161     /**
162      * @dev Safely transfers `tokenId` token from `from` to `to`.
163      *
164      * Requirements:
165      *
166      * - `from` cannot be the zero address.
167      * - `to` cannot be the zero address.
168      * - `tokenId` token must exist and be owned by `from`.
169      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
170      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
171      *
172      * Emits a {Transfer} event.
173      */
174     function safeTransferFrom(
175         address from,
176         address to,
177         uint256 tokenId,
178         bytes calldata data
179     ) external;
180 
181     /**
182      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
183      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
184      *
185      * Requirements:
186      *
187      * - `from` cannot be the zero address.
188      * - `to` cannot be the zero address.
189      * - `tokenId` token must exist and be owned by `from`.
190      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
191      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
192      *
193      * Emits a {Transfer} event.
194      */
195     function safeTransferFrom(
196         address from,
197         address to,
198         uint256 tokenId
199     ) external;
200 
201     /**
202      * @dev Transfers `tokenId` token from `from` to `to`.
203      *
204      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
205      *
206      * Requirements:
207      *
208      * - `from` cannot be the zero address.
209      * - `to` cannot be the zero address.
210      * - `tokenId` token must be owned by `from`.
211      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
212      *
213      * Emits a {Transfer} event.
214      */
215     function transferFrom(
216         address from,
217         address to,
218         uint256 tokenId
219     ) external;
220 
221     /**
222      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
223      * The approval is cleared when the token is transferred.
224      *
225      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
226      *
227      * Requirements:
228      *
229      * - The caller must own the token or be an approved operator.
230      * - `tokenId` must exist.
231      *
232      * Emits an {Approval} event.
233      */
234     function approve(address to, uint256 tokenId) external;
235 
236     /**
237      * @dev Approve or remove `operator` as an operator for the caller.
238      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
239      *
240      * Requirements:
241      *
242      * - The `operator` cannot be the caller.
243      *
244      * Emits an {ApprovalForAll} event.
245      */
246     function setApprovalForAll(address operator, bool _approved) external;
247 
248     /**
249      * @dev Returns the account approved for `tokenId` token.
250      *
251      * Requirements:
252      *
253      * - `tokenId` must exist.
254      */
255     function getApproved(uint256 tokenId) external view returns (address operator);
256 
257     /**
258      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
259      *
260      * See {setApprovalForAll}
261      */
262     function isApprovedForAll(address owner, address operator) external view returns (bool);
263 
264     // ==============================
265     //        IERC721Metadata
266     // ==============================
267 
268     /**
269      * @dev Returns the token collection name.
270      */
271     function name() external view returns (string memory);
272 
273     /**
274      * @dev Returns the token collection symbol.
275      */
276     function symbol() external view returns (string memory);
277 
278     /**
279      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
280      */
281     function tokenURI(uint256 tokenId) external view returns (string memory);
282 }
283 
284 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol
285 
286 
287 // ERC721A Contracts v3.3.0
288 // Creator: Chiru Labs
289 
290 pragma solidity ^0.8.4;
291 
292 
293 /**
294  * @dev ERC721 token receiver interface.
295  */
296 interface ERC721A__IERC721Receiver {
297     function onERC721Received(
298         address operator,
299         address from,
300         uint256 tokenId,
301         bytes calldata data
302     ) external returns (bytes4);
303 }
304 
305 /**
306  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
307  * the Metadata extension. Built to optimize for lower gas during batch mints.
308  *
309  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
310  *
311  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
312  *
313  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
314  */
315 contract ERC721A is IERC721A {
316     // Mask of an entry in packed address data.
317     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
318 
319     // The bit position of `numberMinted` in packed address data.
320     uint256 private constant BITPOS_NUMBER_MINTED = 64;
321 
322     // The bit position of `numberBurned` in packed address data.
323     uint256 private constant BITPOS_NUMBER_BURNED = 128;
324 
325     // The bit position of `aux` in packed address data.
326     uint256 private constant BITPOS_AUX = 192;
327 
328     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
329     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
330 
331     // The bit position of `startTimestamp` in packed ownership.
332     uint256 private constant BITPOS_START_TIMESTAMP = 160;
333 
334     // The bit mask of the `burned` bit in packed ownership.
335     uint256 private constant BITMASK_BURNED = 1 << 224;
336     
337     // The bit position of the `nextInitialized` bit in packed ownership.
338     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
339 
340     // The bit mask of the `nextInitialized` bit in packed ownership.
341     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
342 
343     // The tokenId of the next token to be minted.
344     uint256 private _currentIndex;
345 
346     // The number of tokens burned.
347     uint256 private _burnCounter;
348 
349     // Token name
350     string private _name;
351 
352     // Token symbol
353     string private _symbol;
354 
355     // Mapping from token ID to ownership details
356     // An empty struct value does not necessarily mean the token is unowned.
357     // See `_packedOwnershipOf` implementation for details.
358     //
359     // Bits Layout:
360     // - [0..159]   `addr`
361     // - [160..223] `startTimestamp`
362     // - [224]      `burned`
363     // - [225]      `nextInitialized`
364     mapping(uint256 => uint256) private _packedOwnerships;
365 
366     // Mapping owner address to address data.
367     //
368     // Bits Layout:
369     // - [0..63]    `balance`
370     // - [64..127]  `numberMinted`
371     // - [128..191] `numberBurned`
372     // - [192..255] `aux`
373     mapping(address => uint256) private _packedAddressData;
374 
375     // Mapping from token ID to approved address.
376     mapping(uint256 => address) private _tokenApprovals;
377 
378     // Mapping from owner to operator approvals
379     mapping(address => mapping(address => bool)) private _operatorApprovals;
380 
381     constructor(string memory name_, string memory symbol_) {
382         _name = name_;
383         _symbol = symbol_;
384         _currentIndex = _startTokenId();
385     }
386 
387     /**
388      * @dev Returns the starting token ID. 
389      * To change the starting token ID, please override this function.
390      */
391     function _startTokenId() internal view virtual returns (uint256) {
392         return 1;
393     }
394 
395     /**
396      * @dev Returns the next token ID to be minted.
397      */
398     function _nextTokenId() internal view returns (uint256) {
399         return _currentIndex;
400     }
401 
402     /**
403      * @dev Returns the total number of tokens in existence.
404      * Burned tokens will reduce the count. 
405      * To get the total number of tokens minted, please see `_totalMinted`.
406      */
407     function totalSupply() public view override returns (uint256) {
408         // Counter underflow is impossible as _burnCounter cannot be incremented
409         // more than `_currentIndex - _startTokenId()` times.
410         unchecked {
411             return _currentIndex - _burnCounter - _startTokenId();
412         }
413     }
414 
415     /**
416      * @dev Returns the total amount of tokens minted in the contract.
417      */
418     function _totalMinted() internal view returns (uint256) {
419         // Counter underflow is impossible as _currentIndex does not decrement,
420         // and it is initialized to `_startTokenId()`
421         unchecked {
422             return _currentIndex - _startTokenId();
423         }
424     }
425 
426     /**
427      * @dev Returns the total number of tokens burned.
428      */
429     function _totalBurned() internal view returns (uint256) {
430         return _burnCounter;
431     }
432 
433     /**
434      * @dev See {IERC165-supportsInterface}.
435      */
436     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
437         // The interface IDs are constants representing the first 4 bytes of the XOR of
438         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
439         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
440         return
441             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
442             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
443             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
444     }
445 
446     /**
447      * @dev See {IERC721-balanceOf}.
448      */
449     function balanceOf(address owner) public view override returns (uint256) {
450         if (owner == address(0)) revert BalanceQueryForZeroAddress();
451         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
452     }
453 
454     /**
455      * Returns the number of tokens minted by `owner`.
456      */
457     function _numberMinted(address owner) internal view returns (uint256) {
458         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
459     }
460 
461     /**
462      * Returns the number of tokens burned by or on behalf of `owner`.
463      */
464     function _numberBurned(address owner) internal view returns (uint256) {
465         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
466     }
467 
468     /**
469      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
470      */
471     function _getAux(address owner) internal view returns (uint64) {
472         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
473     }
474 
475     /**
476      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
477      * If there are multiple variables, please pack them into a uint64.
478      */
479     function _setAux(address owner, uint64 aux) internal {
480         uint256 packed = _packedAddressData[owner];
481         uint256 auxCasted;
482         assembly { // Cast aux without masking.
483             auxCasted := aux
484         }
485         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
486         _packedAddressData[owner] = packed;
487     }
488 
489     /**
490      * Returns the packed ownership data of `tokenId`.
491      */
492     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
493         uint256 curr = tokenId;
494 
495         unchecked {
496             if (_startTokenId() <= curr)
497                 if (curr < _currentIndex) {
498                     uint256 packed = _packedOwnerships[curr];
499                     // If not burned.
500                     if (packed & BITMASK_BURNED == 0) {
501                         // Invariant:
502                         // There will always be an ownership that has an address and is not burned
503                         // before an ownership that does not have an address and is not burned.
504                         // Hence, curr will not underflow.
505                         //
506                         // We can directly compare the packed value.
507                         // If the address is zero, packed is zero.
508                         while (packed == 0) {
509                             packed = _packedOwnerships[--curr];
510                         }
511                         return packed;
512                     }
513                 }
514         }
515         revert OwnerQueryForNonexistentToken();
516     }
517 
518     /**
519      * Returns the unpacked `TokenOwnership` struct from `packed`.
520      */
521     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
522         ownership.addr = address(uint160(packed));
523         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
524         ownership.burned = packed & BITMASK_BURNED != 0;
525     }
526 
527     /**
528      * Returns the unpacked `TokenOwnership` struct at `index`.
529      */
530     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
531         return _unpackedOwnership(_packedOwnerships[index]);
532     }
533 
534     /**
535      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
536      */
537     function _initializeOwnershipAt(uint256 index) internal {
538         if (_packedOwnerships[index] == 0) {
539             _packedOwnerships[index] = _packedOwnershipOf(index);
540         }
541     }
542 
543     /**
544      * Gas spent here starts off proportional to the maximum mint batch size.
545      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
546      */
547     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
548         return _unpackedOwnership(_packedOwnershipOf(tokenId));
549     }
550 
551     /**
552      * @dev See {IERC721-ownerOf}.
553      */
554     function ownerOf(uint256 tokenId) public view override returns (address) {
555         return address(uint160(_packedOwnershipOf(tokenId)));
556     }
557 
558     /**
559      * @dev See {IERC721Metadata-name}.
560      */
561     function name() public view virtual override returns (string memory) {
562         return _name;
563     }
564 
565     /**
566      * @dev See {IERC721Metadata-symbol}.
567      */
568     function symbol() public view virtual override returns (string memory) {
569         return _symbol;
570     }
571 
572     /**
573      * @dev See {IERC721Metadata-tokenURI}.
574      */
575     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
576         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
577 
578         string memory baseURI = _baseURI();
579         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
580     }
581 
582     /**
583      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
584      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
585      * by default, can be overriden in child contracts.
586      */
587     function _baseURI() internal view virtual returns (string memory) {
588         return '';
589     }
590 
591     /**
592      * @dev Casts the address to uint256 without masking.
593      */
594     function _addressToUint256(address value) private pure returns (uint256 result) {
595         assembly {
596             result := value
597         }
598     }
599 
600     /**
601      * @dev Casts the boolean to uint256 without branching.
602      */
603     function _boolToUint256(bool value) private pure returns (uint256 result) {
604         assembly {
605             result := value
606         }
607     }
608 
609     /**
610      * @dev See {IERC721-approve}.
611      */
612     function approve(address to, uint256 tokenId) public override {
613         address owner = address(uint160(_packedOwnershipOf(tokenId)));
614         if (to == owner) revert ApprovalToCurrentOwner();
615 
616         if (_msgSenderERC721A() != owner)
617             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
618                 revert ApprovalCallerNotOwnerNorApproved();
619             }
620 
621         _tokenApprovals[tokenId] = to;
622         emit Approval(owner, to, tokenId);
623     }
624 
625     /**
626      * @dev See {IERC721-getApproved}.
627      */
628     function getApproved(uint256 tokenId) public view override returns (address) {
629         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
630 
631         return _tokenApprovals[tokenId];
632     }
633 
634     /**
635      * @dev See {IERC721-setApprovalForAll}.
636      */
637     function setApprovalForAll(address operator, bool approved) public virtual override {
638         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
639 
640         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
641         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
642     }
643 
644     /**
645      * @dev See {IERC721-isApprovedForAll}.
646      */
647     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
648         return _operatorApprovals[owner][operator];
649     }
650 
651     /**
652      * @dev See {IERC721-transferFrom}.
653      */
654     function transferFrom(
655         address from,
656         address to,
657         uint256 tokenId
658     ) public virtual override {
659         _transfer(from, to, tokenId);
660     }
661 
662     /**
663      * @dev See {IERC721-safeTransferFrom}.
664      */
665     function safeTransferFrom(
666         address from,
667         address to,
668         uint256 tokenId
669     ) public virtual override {
670         safeTransferFrom(from, to, tokenId, '');
671     }
672 
673     /**
674      * @dev See {IERC721-safeTransferFrom}.
675      */
676     function safeTransferFrom(
677         address from,
678         address to,
679         uint256 tokenId,
680         bytes memory _data
681     ) public virtual override {
682         _transfer(from, to, tokenId);
683         if (to.code.length != 0)
684             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
685                 revert TransferToNonERC721ReceiverImplementer();
686             }
687     }
688 
689     /**
690      * @dev Returns whether `tokenId` exists.
691      *
692      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
693      *
694      * Tokens start existing when they are minted (`_mint`),
695      */
696     function _exists(uint256 tokenId) internal view returns (bool) {
697         return
698             _startTokenId() <= tokenId &&
699             tokenId < _currentIndex && // If within bounds,
700             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
701     }
702 
703     /**
704      * @dev Equivalent to `_safeMint(to, quantity, '')`.
705      */
706     function _safeMint(address to, uint256 quantity) internal {
707         _safeMint(to, quantity, '');
708     }
709 
710     /**
711      * @dev Safely mints `quantity` tokens and transfers them to `to`.
712      *
713      * Requirements:
714      *
715      * - If `to` refers to a smart contract, it must implement
716      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
717      * - `quantity` must be greater than 0.
718      *
719      * Emits a {Transfer} event.
720      */
721     function _safeMint(
722         address to,
723         uint256 quantity,
724         bytes memory _data
725     ) internal {
726         uint256 startTokenId = _currentIndex;
727         if (to == address(0)) revert MintToZeroAddress();
728         if (quantity == 0) revert MintZeroQuantity();
729 
730         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
731 
732         // Overflows are incredibly unrealistic.
733         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
734         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
735         unchecked {
736             // Updates:
737             // - `balance += quantity`.
738             // - `numberMinted += quantity`.
739             //
740             // We can directly add to the balance and number minted.
741             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
742 
743             // Updates:
744             // - `address` to the owner.
745             // - `startTimestamp` to the timestamp of minting.
746             // - `burned` to `false`.
747             // - `nextInitialized` to `quantity == 1`.
748             _packedOwnerships[startTokenId] =
749                 _addressToUint256(to) |
750                 (block.timestamp << BITPOS_START_TIMESTAMP) |
751                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
752 
753             uint256 updatedIndex = startTokenId;
754             uint256 end = updatedIndex + quantity;
755 
756             if (to.code.length != 0) {
757                 do {
758                     emit Transfer(address(0), to, updatedIndex);
759                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
760                         revert TransferToNonERC721ReceiverImplementer();
761                     }
762                 } while (updatedIndex < end);
763                 // Reentrancy protection
764                 if (_currentIndex != startTokenId) revert();
765             } else {
766                 do {
767                     emit Transfer(address(0), to, updatedIndex++);
768                 } while (updatedIndex < end);
769             }
770             _currentIndex = updatedIndex;
771         }
772         _afterTokenTransfers(address(0), to, startTokenId, quantity);
773     }
774 
775     /**
776      * @dev Mints `quantity` tokens and transfers them to `to`.
777      *
778      * Requirements:
779      *
780      * - `to` cannot be the zero address.
781      * - `quantity` must be greater than 0.
782      *
783      * Emits a {Transfer} event.
784      */
785     function _mint(address to, uint256 quantity) internal {
786         uint256 startTokenId = _currentIndex;
787         if (to == address(0)) revert MintToZeroAddress();
788         if (quantity == 0) revert MintZeroQuantity();
789 
790         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
791 
792         // Overflows are incredibly unrealistic.
793         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
794         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
795         unchecked {
796             // Updates:
797             // - `balance += quantity`.
798             // - `numberMinted += quantity`.
799             //
800             // We can directly add to the balance and number minted.
801             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
802 
803             // Updates:
804             // - `address` to the owner.
805             // - `startTimestamp` to the timestamp of minting.
806             // - `burned` to `false`.
807             // - `nextInitialized` to `quantity == 1`.
808             _packedOwnerships[startTokenId] =
809                 _addressToUint256(to) |
810                 (block.timestamp << BITPOS_START_TIMESTAMP) |
811                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
812 
813             uint256 updatedIndex = startTokenId;
814             uint256 end = updatedIndex + quantity;
815 
816             do {
817                 emit Transfer(address(0), to, updatedIndex++);
818             } while (updatedIndex < end);
819 
820             _currentIndex = updatedIndex;
821         }
822         _afterTokenTransfers(address(0), to, startTokenId, quantity);
823     }
824 
825     /**
826      * @dev Transfers `tokenId` from `from` to `to`.
827      *
828      * Requirements:
829      *
830      * - `to` cannot be the zero address.
831      * - `tokenId` token must be owned by `from`.
832      *
833      * Emits a {Transfer} event.
834      */
835     function _transfer(
836         address from,
837         address to,
838         uint256 tokenId
839     ) private {
840         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
841 
842         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
843 
844         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
845             isApprovedForAll(from, _msgSenderERC721A()) ||
846             getApproved(tokenId) == _msgSenderERC721A());
847 
848         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
849         if (to == address(0)) revert TransferToZeroAddress();
850 
851         _beforeTokenTransfers(from, to, tokenId, 1);
852 
853         // Clear approvals from the previous owner.
854         delete _tokenApprovals[tokenId];
855 
856         // Underflow of the sender's balance is impossible because we check for
857         // ownership above and the recipient's balance can't realistically overflow.
858         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
859         unchecked {
860             // We can directly increment and decrement the balances.
861             --_packedAddressData[from]; // Updates: `balance -= 1`.
862             ++_packedAddressData[to]; // Updates: `balance += 1`.
863 
864             // Updates:
865             // - `address` to the next owner.
866             // - `startTimestamp` to the timestamp of transfering.
867             // - `burned` to `false`.
868             // - `nextInitialized` to `true`.
869             _packedOwnerships[tokenId] =
870                 _addressToUint256(to) |
871                 (block.timestamp << BITPOS_START_TIMESTAMP) |
872                 BITMASK_NEXT_INITIALIZED;
873 
874             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
875             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
876                 uint256 nextTokenId = tokenId + 1;
877                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
878                 if (_packedOwnerships[nextTokenId] == 0) {
879                     // If the next slot is within bounds.
880                     if (nextTokenId != _currentIndex) {
881                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
882                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
883                     }
884                 }
885             }
886         }
887 
888         emit Transfer(from, to, tokenId);
889         _afterTokenTransfers(from, to, tokenId, 1);
890     }
891 
892     /**
893      * @dev Equivalent to `_burn(tokenId, false)`.
894      */
895     function _burn(uint256 tokenId) internal virtual {
896         _burn(tokenId, false);
897     }
898 
899     /**
900      * @dev Destroys `tokenId`.
901      * The approval is cleared when the token is burned.
902      *
903      * Requirements:
904      *
905      * - `tokenId` must exist.
906      *
907      * Emits a {Transfer} event.
908      */
909     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
910         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
911 
912         address from = address(uint160(prevOwnershipPacked));
913 
914         if (approvalCheck) {
915             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
916                 isApprovedForAll(from, _msgSenderERC721A()) ||
917                 getApproved(tokenId) == _msgSenderERC721A());
918 
919             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
920         }
921 
922         _beforeTokenTransfers(from, address(0), tokenId, 1);
923 
924         // Clear approvals from the previous owner.
925         delete _tokenApprovals[tokenId];
926 
927         // Underflow of the sender's balance is impossible because we check for
928         // ownership above and the recipient's balance can't realistically overflow.
929         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
930         unchecked {
931             // Updates:
932             // - `balance -= 1`.
933             // - `numberBurned += 1`.
934             //
935             // We can directly decrement the balance, and increment the number burned.
936             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
937             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
938 
939             // Updates:
940             // - `address` to the last owner.
941             // - `startTimestamp` to the timestamp of burning.
942             // - `burned` to `true`.
943             // - `nextInitialized` to `true`.
944             _packedOwnerships[tokenId] =
945                 _addressToUint256(from) |
946                 (block.timestamp << BITPOS_START_TIMESTAMP) |
947                 BITMASK_BURNED | 
948                 BITMASK_NEXT_INITIALIZED;
949 
950             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
951             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
952                 uint256 nextTokenId = tokenId + 1;
953                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
954                 if (_packedOwnerships[nextTokenId] == 0) {
955                     // If the next slot is within bounds.
956                     if (nextTokenId != _currentIndex) {
957                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
958                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
959                     }
960                 }
961             }
962         }
963 
964         emit Transfer(from, address(0), tokenId);
965         _afterTokenTransfers(from, address(0), tokenId, 1);
966 
967         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
968         unchecked {
969             _burnCounter++;
970         }
971     }
972 
973     /**
974      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
975      *
976      * @param from address representing the previous owner of the given token ID
977      * @param to target address that will receive the tokens
978      * @param tokenId uint256 ID of the token to be transferred
979      * @param _data bytes optional data to send along with the call
980      * @return bool whether the call correctly returned the expected magic value
981      */
982     function _checkContractOnERC721Received(
983         address from,
984         address to,
985         uint256 tokenId,
986         bytes memory _data
987     ) private returns (bool) {
988         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
989             bytes4 retval
990         ) {
991             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
992         } catch (bytes memory reason) {
993             if (reason.length == 0) {
994                 revert TransferToNonERC721ReceiverImplementer();
995             } else {
996                 assembly {
997                     revert(add(32, reason), mload(reason))
998                 }
999             }
1000         }
1001     }
1002 
1003     /**
1004      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1005      * And also called before burning one token.
1006      *
1007      * startTokenId - the first token id to be transferred
1008      * quantity - the amount to be transferred
1009      *
1010      * Calling conditions:
1011      *
1012      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1013      * transferred to `to`.
1014      * - When `from` is zero, `tokenId` will be minted for `to`.
1015      * - When `to` is zero, `tokenId` will be burned by `from`.
1016      * - `from` and `to` are never both zero.
1017      */
1018     function _beforeTokenTransfers(
1019         address from,
1020         address to,
1021         uint256 startTokenId,
1022         uint256 quantity
1023     ) internal virtual {}
1024 
1025     /**
1026      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1027      * minting.
1028      * And also called after one token has been burned.
1029      *
1030      * startTokenId - the first token id to be transferred
1031      * quantity - the amount to be transferred
1032      *
1033      * Calling conditions:
1034      *
1035      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1036      * transferred to `to`.
1037      * - When `from` is zero, `tokenId` has been minted for `to`.
1038      * - When `to` is zero, `tokenId` has been burned by `from`.
1039      * - `from` and `to` are never both zero.
1040      */
1041     function _afterTokenTransfers(
1042         address from,
1043         address to,
1044         uint256 startTokenId,
1045         uint256 quantity
1046     ) internal virtual {}
1047 
1048     /**
1049      * @dev Returns the message sender (defaults to `msg.sender`).
1050      *
1051      * If you are writing GSN compatible contracts, you need to override this function.
1052      */
1053     function _msgSenderERC721A() internal view virtual returns (address) {
1054         return msg.sender;
1055     }
1056 
1057     /**
1058      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1059      */
1060     function _toString(uint256 value) internal pure returns (string memory ptr) {
1061         assembly {
1062             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1063             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1064             // We will need 1 32-byte word to store the length, 
1065             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1066             ptr := add(mload(0x40), 128)
1067             // Update the free memory pointer to allocate.
1068             mstore(0x40, ptr)
1069 
1070             // Cache the end of the memory to calculate the length later.
1071             let end := ptr
1072 
1073             // We write the string from the rightmost digit to the leftmost digit.
1074             // The following is essentially a do-while loop that also handles the zero case.
1075             // Costs a bit more than early returning for the zero case,
1076             // but cheaper in terms of deployment and overall runtime costs.
1077             for { 
1078                 // Initialize and perform the first pass without check.
1079                 let temp := value
1080                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1081                 ptr := sub(ptr, 1)
1082                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1083                 mstore8(ptr, add(48, mod(temp, 10)))
1084                 temp := div(temp, 10)
1085             } temp { 
1086                 // Keep dividing `temp` until zero.
1087                 temp := div(temp, 10)
1088             } { // Body of the for loop.
1089                 ptr := sub(ptr, 1)
1090                 mstore8(ptr, add(48, mod(temp, 10)))
1091             }
1092             
1093             let length := sub(end, ptr)
1094             // Move the pointer 32 bytes leftwards to make room for the length.
1095             ptr := sub(ptr, 32)
1096             // Store the length.
1097             mstore(ptr, length)
1098         }
1099     }
1100 }
1101 
1102 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
1103 
1104 
1105 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
1106 
1107 pragma solidity ^0.8.0;
1108 
1109 /**
1110  * @dev String operations.
1111  */
1112 library Strings {
1113     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1114     uint8 private constant _ADDRESS_LENGTH = 20;
1115 
1116     /**
1117      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1118      */
1119     function toString(uint256 value) internal pure returns (string memory) {
1120         // Inspired by OraclizeAPI's implementation - MIT licence
1121         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1122 
1123         if (value == 0) {
1124             return "0";
1125         }
1126         uint256 temp = value;
1127         uint256 digits;
1128         while (temp != 0) {
1129             digits++;
1130             temp /= 10;
1131         }
1132         bytes memory buffer = new bytes(digits);
1133         while (value != 0) {
1134             digits -= 1;
1135             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1136             value /= 10;
1137         }
1138         return string(buffer);
1139     }
1140 
1141     /**
1142      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1143      */
1144     function toHexString(uint256 value) internal pure returns (string memory) {
1145         if (value == 0) {
1146             return "0x00";
1147         }
1148         uint256 temp = value;
1149         uint256 length = 0;
1150         while (temp != 0) {
1151             length++;
1152             temp >>= 8;
1153         }
1154         return toHexString(value, length);
1155     }
1156 
1157     /**
1158      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1159      */
1160     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1161         bytes memory buffer = new bytes(2 * length + 2);
1162         buffer[0] = "0";
1163         buffer[1] = "x";
1164         for (uint256 i = 2 * length + 1; i > 1; --i) {
1165             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1166             value >>= 4;
1167         }
1168         require(value == 0, "Strings: hex length insufficient");
1169         return string(buffer);
1170     }
1171 
1172     /**
1173      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1174      */
1175     function toHexString(address addr) internal pure returns (string memory) {
1176         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1177     }
1178 }
1179 
1180 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
1181 
1182 
1183 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1184 
1185 pragma solidity ^0.8.0;
1186 
1187 /**
1188  * @dev Provides information about the current execution context, including the
1189  * sender of the transaction and its data. While these are generally available
1190  * via msg.sender and msg.data, they should not be accessed in such a direct
1191  * manner, since when dealing with meta-transactions the account sending and
1192  * paying for execution may not be the actual sender (as far as an application
1193  * is concerned).
1194  *
1195  * This contract is only required for intermediate, library-like contracts.
1196  */
1197 abstract contract Context {
1198     function _msgSender() internal view virtual returns (address) {
1199         return msg.sender;
1200     }
1201 
1202     function _msgData() internal view virtual returns (bytes calldata) {
1203         return msg.data;
1204     }
1205 }
1206 
1207 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
1208 
1209 
1210 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1211 
1212 pragma solidity ^0.8.0;
1213 
1214 
1215 /**
1216  * @dev Contract module which provides a basic access control mechanism, where
1217  * there is an account (an owner) that can be granted exclusive access to
1218  * specific functions.
1219  *
1220  * By default, the owner account will be the one that deploys the contract. This
1221  * can later be changed with {transferOwnership}.
1222  *
1223  * This module is used through inheritance. It will make available the modifier
1224  * `onlyOwner`, which can be applied to your functions to restrict their use to
1225  * the owner.
1226  */
1227 abstract contract Ownable is Context {
1228     address private _owner;
1229 
1230     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1231 
1232     /**
1233      * @dev Initializes the contract setting the deployer as the initial owner.
1234      */
1235     constructor() {
1236         _transferOwnership(_msgSender());
1237     }
1238 
1239     /**
1240      * @dev Returns the address of the current owner.
1241      */
1242     function owner() public view virtual returns (address) {
1243         return _owner;
1244     }
1245 
1246     /**
1247      * @dev Throws if called by any account other than the owner.
1248      */
1249     modifier onlyOwner() {
1250         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1251         _;
1252     }
1253 
1254     /**
1255      * @dev Leaves the contract without owner. It will not be possible to call
1256      * `onlyOwner` functions anymore. Can only be called by the current owner.
1257      *
1258      * NOTE: Renouncing ownership will leave the contract without an owner,
1259      * thereby removing any functionality that is only available to the owner.
1260      */
1261     function renounceOwnership() public virtual onlyOwner {
1262         _transferOwnership(address(0));
1263     }
1264 
1265     /**
1266      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1267      * Can only be called by the current owner.
1268      */
1269     function transferOwnership(address newOwner) public virtual onlyOwner {
1270         require(newOwner != address(0), "Ownable: new owner is the zero address");
1271         _transferOwnership(newOwner);
1272     }
1273 
1274     /**
1275      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1276      * Internal function without access restriction.
1277      */
1278     function _transferOwnership(address newOwner) internal virtual {
1279         address oldOwner = _owner;
1280         _owner = newOwner;
1281         emit OwnershipTransferred(oldOwner, newOwner);
1282     }
1283 }
1284 
1285 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol
1286 
1287 
1288 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
1289 
1290 pragma solidity ^0.8.1;
1291 
1292 /**
1293  * @dev Collection of functions related to the address type
1294  */
1295 library Address {
1296     /**
1297      * @dev Returns true if `account` is a contract.
1298      *
1299      * [IMPORTANT]
1300      * ====
1301      * It is unsafe to assume that an address for which this function returns
1302      * false is an externally-owned account (EOA) and not a contract.
1303      *
1304      * Among others, `isContract` will return false for the following
1305      * types of addresses:
1306      *
1307      *  - an externally-owned account
1308      *  - a contract in construction
1309      *  - an address where a contract will be created
1310      *  - an address where a contract lived, but was destroyed
1311      * ====
1312      *
1313      * [IMPORTANT]
1314      * ====
1315      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1316      *
1317      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1318      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1319      * constructor.
1320      * ====
1321      */
1322     function isContract(address account) internal view returns (bool) {
1323         // This method relies on extcodesize/address.code.length, which returns 0
1324         // for contracts in construction, since the code is only stored at the end
1325         // of the constructor execution.
1326 
1327         return account.code.length > 0;
1328     }
1329 
1330     /**
1331      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1332      * `recipient`, forwarding all available gas and reverting on errors.
1333      *
1334      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1335      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1336      * imposed by `transfer`, making them unable to receive funds via
1337      * `transfer`. {sendValue} removes this limitation.
1338      *
1339      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1340      *
1341      * IMPORTANT: because control is transferred to `recipient`, care must be
1342      * taken to not create reentrancy vulnerabilities. Consider using
1343      * {ReentrancyGuard} or the
1344      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1345      */
1346     function sendValue(address payable recipient, uint256 amount) internal {
1347         require(address(this).balance >= amount, "Address: insufficient balance");
1348 
1349         (bool success, ) = recipient.call{value: amount}("");
1350         require(success, "Address: unable to send value, recipient may have reverted");
1351     }
1352 
1353     /**
1354      * @dev Performs a Solidity function call using a low level `call`. A
1355      * plain `call` is an unsafe replacement for a function call: use this
1356      * function instead.
1357      *
1358      * If `target` reverts with a revert reason, it is bubbled up by this
1359      * function (like regular Solidity function calls).
1360      *
1361      * Returns the raw returned data. To convert to the expected return value,
1362      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1363      *
1364      * Requirements:
1365      *
1366      * - `target` must be a contract.
1367      * - calling `target` with `data` must not revert.
1368      *
1369      * _Available since v3.1._
1370      */
1371     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1372         return functionCall(target, data, "Address: low-level call failed");
1373     }
1374 
1375     /**
1376      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1377      * `errorMessage` as a fallback revert reason when `target` reverts.
1378      *
1379      * _Available since v3.1._
1380      */
1381     function functionCall(
1382         address target,
1383         bytes memory data,
1384         string memory errorMessage
1385     ) internal returns (bytes memory) {
1386         return functionCallWithValue(target, data, 0, errorMessage);
1387     }
1388 
1389     /**
1390      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1391      * but also transferring `value` wei to `target`.
1392      *
1393      * Requirements:
1394      *
1395      * - the calling contract must have an ETH balance of at least `value`.
1396      * - the called Solidity function must be `payable`.
1397      *
1398      * _Available since v3.1._
1399      */
1400     function functionCallWithValue(
1401         address target,
1402         bytes memory data,
1403         uint256 value
1404     ) internal returns (bytes memory) {
1405         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1406     }
1407 
1408     /**
1409      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1410      * with `errorMessage` as a fallback revert reason when `target` reverts.
1411      *
1412      * _Available since v3.1._
1413      */
1414     function functionCallWithValue(
1415         address target,
1416         bytes memory data,
1417         uint256 value,
1418         string memory errorMessage
1419     ) internal returns (bytes memory) {
1420         require(address(this).balance >= value, "Address: insufficient balance for call");
1421         require(isContract(target), "Address: call to non-contract");
1422 
1423         (bool success, bytes memory returndata) = target.call{value: value}(data);
1424         return verifyCallResult(success, returndata, errorMessage);
1425     }
1426 
1427     /**
1428      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1429      * but performing a static call.
1430      *
1431      * _Available since v3.3._
1432      */
1433     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1434         return functionStaticCall(target, data, "Address: low-level static call failed");
1435     }
1436 
1437     /**
1438      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1439      * but performing a static call.
1440      *
1441      * _Available since v3.3._
1442      */
1443     function functionStaticCall(
1444         address target,
1445         bytes memory data,
1446         string memory errorMessage
1447     ) internal view returns (bytes memory) {
1448         require(isContract(target), "Address: static call to non-contract");
1449 
1450         (bool success, bytes memory returndata) = target.staticcall(data);
1451         return verifyCallResult(success, returndata, errorMessage);
1452     }
1453 
1454     /**
1455      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1456      * but performing a delegate call.
1457      *
1458      * _Available since v3.4._
1459      */
1460     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1461         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1462     }
1463 
1464     /**
1465      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1466      * but performing a delegate call.
1467      *
1468      * _Available since v3.4._
1469      */
1470     function functionDelegateCall(
1471         address target,
1472         bytes memory data,
1473         string memory errorMessage
1474     ) internal returns (bytes memory) {
1475         require(isContract(target), "Address: delegate call to non-contract");
1476 
1477         (bool success, bytes memory returndata) = target.delegatecall(data);
1478         return verifyCallResult(success, returndata, errorMessage);
1479     }
1480 
1481     /**
1482      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1483      * revert reason using the provided one.
1484      *
1485      * _Available since v4.3._
1486      */
1487     function verifyCallResult(
1488         bool success,
1489         bytes memory returndata,
1490         string memory errorMessage
1491     ) internal pure returns (bytes memory) {
1492         if (success) {
1493             return returndata;
1494         } else {
1495             // Look for revert reason and bubble it up if present
1496             if (returndata.length > 0) {
1497                 // The easiest way to bubble the revert reason is using memory via assembly
1498 
1499                 assembly {
1500                     let returndata_size := mload(returndata)
1501                     revert(add(32, returndata), returndata_size)
1502                 }
1503             } else {
1504                 revert(errorMessage);
1505             }
1506         }
1507     }
1508 }
1509 
1510 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721Receiver.sol
1511 
1512 
1513 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
1514 
1515 pragma solidity ^0.8.0;
1516 
1517 /**
1518  * @title ERC721 token receiver interface
1519  * @dev Interface for any contract that wants to support safeTransfers
1520  * from ERC721 asset contracts.
1521  */
1522 interface IERC721Receiver {
1523     /**
1524      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1525      * by `operator` from `from`, this function is called.
1526      *
1527      * It must return its Solidity selector to confirm the token transfer.
1528      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1529      *
1530      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
1531      */
1532     function onERC721Received(
1533         address operator,
1534         address from,
1535         uint256 tokenId,
1536         bytes calldata data
1537     ) external returns (bytes4);
1538 }
1539 
1540 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/IERC165.sol
1541 
1542 
1543 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1544 
1545 pragma solidity ^0.8.0;
1546 
1547 /**
1548  * @dev Interface of the ERC165 standard, as defined in the
1549  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1550  *
1551  * Implementers can declare support of contract interfaces, which can then be
1552  * queried by others ({ERC165Checker}).
1553  *
1554  * For an implementation, see {ERC165}.
1555  */
1556 interface IERC165 {
1557     /**
1558      * @dev Returns true if this contract implements the interface defined by
1559      * `interfaceId`. See the corresponding
1560      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1561      * to learn more about how these ids are created.
1562      *
1563      * This function call must use less than 30 000 gas.
1564      */
1565     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1566 }
1567 
1568 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/ERC165.sol
1569 
1570 
1571 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1572 
1573 pragma solidity ^0.8.0;
1574 
1575 
1576 /**
1577  * @dev Implementation of the {IERC165} interface.
1578  *
1579  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1580  * for the additional interface id that will be supported. For example:
1581  *
1582  * ```solidity
1583  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1584  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1585  * }
1586  * ```
1587  *
1588  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1589  */
1590 abstract contract ERC165 is IERC165 {
1591     /**
1592      * @dev See {IERC165-supportsInterface}.
1593      */
1594     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1595         return interfaceId == type(IERC165).interfaceId;
1596     }
1597 }
1598 
1599 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721.sol
1600 
1601 
1602 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
1603 
1604 pragma solidity ^0.8.0;
1605 
1606 
1607 /**
1608  * @dev Required interface of an ERC721 compliant contract.
1609  */
1610 interface IERC721 is IERC165 {
1611     /**
1612      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1613      */
1614     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1615 
1616     /**
1617      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1618      */
1619     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1620 
1621     /**
1622      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1623      */
1624     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1625 
1626     /**
1627      * @dev Returns the number of tokens in ``owner``'s account.
1628      */
1629     function balanceOf(address owner) external view returns (uint256 balance);
1630 
1631     /**
1632      * @dev Returns the owner of the `tokenId` token.
1633      *
1634      * Requirements:
1635      *
1636      * - `tokenId` must exist.
1637      */
1638     function ownerOf(uint256 tokenId) external view returns (address owner);
1639 
1640     /**
1641      * @dev Safely transfers `tokenId` token from `from` to `to`.
1642      *
1643      * Requirements:
1644      *
1645      * - `from` cannot be the zero address.
1646      * - `to` cannot be the zero address.
1647      * - `tokenId` token must exist and be owned by `from`.
1648      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1649      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1650      *
1651      * Emits a {Transfer} event.
1652      */
1653     function safeTransferFrom(
1654         address from,
1655         address to,
1656         uint256 tokenId,
1657         bytes calldata data
1658     ) external;
1659 
1660     /**
1661      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1662      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1663      *
1664      * Requirements:
1665      *
1666      * - `from` cannot be the zero address.
1667      * - `to` cannot be the zero address.
1668      * - `tokenId` token must exist and be owned by `from`.
1669      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1670      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1671      *
1672      * Emits a {Transfer} event.
1673      */
1674     function safeTransferFrom(
1675         address from,
1676         address to,
1677         uint256 tokenId
1678     ) external;
1679 
1680     /**
1681      * @dev Transfers `tokenId` token from `from` to `to`.
1682      *
1683      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1684      *
1685      * Requirements:
1686      *
1687      * - `from` cannot be the zero address.
1688      * - `to` cannot be the zero address.
1689      * - `tokenId` token must be owned by `from`.
1690      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1691      *
1692      * Emits a {Transfer} event.
1693      */
1694     function transferFrom(
1695         address from,
1696         address to,
1697         uint256 tokenId
1698     ) external;
1699 
1700     /**
1701      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1702      * The approval is cleared when the token is transferred.
1703      *
1704      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1705      *
1706      * Requirements:
1707      *
1708      * - The caller must own the token or be an approved operator.
1709      * - `tokenId` must exist.
1710      *
1711      * Emits an {Approval} event.
1712      */
1713     function approve(address to, uint256 tokenId) external;
1714 
1715     /**
1716      * @dev Approve or remove `operator` as an operator for the caller.
1717      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1718      *
1719      * Requirements:
1720      *
1721      * - The `operator` cannot be the caller.
1722      *
1723      * Emits an {ApprovalForAll} event.
1724      */
1725     function setApprovalForAll(address operator, bool _approved) external;
1726 
1727     /**
1728      * @dev Returns the account approved for `tokenId` token.
1729      *
1730      * Requirements:
1731      *
1732      * - `tokenId` must exist.
1733      */
1734     function getApproved(uint256 tokenId) external view returns (address operator);
1735 
1736     /**
1737      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1738      *
1739      * See {setApprovalForAll}
1740      */
1741     function isApprovedForAll(address owner, address operator) external view returns (bool);
1742 }
1743 
1744 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/IERC721Metadata.sol
1745 
1746 
1747 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1748 
1749 pragma solidity ^0.8.0;
1750 
1751 
1752 /**
1753  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1754  * @dev See https://eips.ethereum.org/EIPS/eip-721
1755  */
1756 interface IERC721Metadata is IERC721 {
1757     /**
1758      * @dev Returns the token collection name.
1759      */
1760     function name() external view returns (string memory);
1761 
1762     /**
1763      * @dev Returns the token collection symbol.
1764      */
1765     function symbol() external view returns (string memory);
1766 
1767     /**
1768      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1769      */
1770     function tokenURI(uint256 tokenId) external view returns (string memory);
1771 }
1772 
1773 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol
1774 
1775 
1776 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
1777 
1778 pragma solidity ^0.8.0;
1779 
1780 
1781 
1782 
1783 
1784 
1785 
1786 
1787 /**
1788  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1789  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1790  * {ERC721Enumerable}.
1791  */
1792 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1793     using Address for address;
1794     using Strings for uint256;
1795 
1796     // Token name
1797     string private _name;
1798 
1799     // Token symbol
1800     string private _symbol;
1801 
1802     // Mapping from token ID to owner address
1803     mapping(uint256 => address) private _owners;
1804 
1805     // Mapping owner address to token count
1806     mapping(address => uint256) private _balances;
1807 
1808     // Mapping from token ID to approved address
1809     mapping(uint256 => address) private _tokenApprovals;
1810 
1811     // Mapping from owner to operator approvals
1812     mapping(address => mapping(address => bool)) private _operatorApprovals;
1813 
1814     /**
1815      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1816      */
1817     constructor(string memory name_, string memory symbol_) {
1818         _name = name_;
1819         _symbol = symbol_;
1820     }
1821 
1822     /**
1823      * @dev See {IERC165-supportsInterface}.
1824      */
1825     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1826         return
1827             interfaceId == type(IERC721).interfaceId ||
1828             interfaceId == type(IERC721Metadata).interfaceId ||
1829             super.supportsInterface(interfaceId);
1830     }
1831 
1832     /**
1833      * @dev See {IERC721-balanceOf}.
1834      */
1835     function balanceOf(address owner) public view virtual override returns (uint256) {
1836         require(owner != address(0), "ERC721: address zero is not a valid owner");
1837         return _balances[owner];
1838     }
1839 
1840     /**
1841      * @dev See {IERC721-ownerOf}.
1842      */
1843     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1844         address owner = _owners[tokenId];
1845         require(owner != address(0), "ERC721: owner query for nonexistent token");
1846         return owner;
1847     }
1848 
1849     /**
1850      * @dev See {IERC721Metadata-name}.
1851      */
1852     function name() public view virtual override returns (string memory) {
1853         return _name;
1854     }
1855 
1856     /**
1857      * @dev See {IERC721Metadata-symbol}.
1858      */
1859     function symbol() public view virtual override returns (string memory) {
1860         return _symbol;
1861     }
1862 
1863     /**
1864      * @dev See {IERC721Metadata-tokenURI}.
1865      */
1866     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1867         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1868 
1869         string memory baseURI = _baseURI();
1870         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1871     }
1872 
1873     /**
1874      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1875      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1876      * by default, can be overridden in child contracts.
1877      */
1878     function _baseURI() internal view virtual returns (string memory) {
1879         return "";
1880     }
1881 
1882     /**
1883      * @dev See {IERC721-approve}.
1884      */
1885     function approve(address to, uint256 tokenId) public virtual override {
1886         address owner = ERC721.ownerOf(tokenId);
1887         require(to != owner, "ERC721: approval to current owner");
1888 
1889         require(
1890             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1891             "ERC721: approve caller is not owner nor approved for all"
1892         );
1893 
1894         _approve(to, tokenId);
1895     }
1896 
1897     /**
1898      * @dev See {IERC721-getApproved}.
1899      */
1900     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1901         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1902 
1903         return _tokenApprovals[tokenId];
1904     }
1905 
1906     /**
1907      * @dev See {IERC721-setApprovalForAll}.
1908      */
1909     function setApprovalForAll(address operator, bool approved) public virtual override {
1910         _setApprovalForAll(_msgSender(), operator, approved);
1911     }
1912 
1913     /**
1914      * @dev See {IERC721-isApprovedForAll}.
1915      */
1916     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1917         return _operatorApprovals[owner][operator];
1918     }
1919 
1920     /**
1921      * @dev See {IERC721-transferFrom}.
1922      */
1923     function transferFrom(
1924         address from,
1925         address to,
1926         uint256 tokenId
1927     ) public virtual override {
1928         //solhint-disable-next-line max-line-length
1929         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1930 
1931         _transfer(from, to, tokenId);
1932     }
1933 
1934     /**
1935      * @dev See {IERC721-safeTransferFrom}.
1936      */
1937     function safeTransferFrom(
1938         address from,
1939         address to,
1940         uint256 tokenId
1941     ) public virtual override {
1942         safeTransferFrom(from, to, tokenId, "");
1943     }
1944 
1945     /**
1946      * @dev See {IERC721-safeTransferFrom}.
1947      */
1948     function safeTransferFrom(
1949         address from,
1950         address to,
1951         uint256 tokenId,
1952         bytes memory data
1953     ) public virtual override {
1954         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1955         _safeTransfer(from, to, tokenId, data);
1956     }
1957 
1958     /**
1959      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1960      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1961      *
1962      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1963      *
1964      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1965      * implement alternative mechanisms to perform token transfer, such as signature-based.
1966      *
1967      * Requirements:
1968      *
1969      * - `from` cannot be the zero address.
1970      * - `to` cannot be the zero address.
1971      * - `tokenId` token must exist and be owned by `from`.
1972      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1973      *
1974      * Emits a {Transfer} event.
1975      */
1976     function _safeTransfer(
1977         address from,
1978         address to,
1979         uint256 tokenId,
1980         bytes memory data
1981     ) internal virtual {
1982         _transfer(from, to, tokenId);
1983         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1984     }
1985 
1986     /**
1987      * @dev Returns whether `tokenId` exists.
1988      *
1989      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1990      *
1991      * Tokens start existing when they are minted (`_mint`),
1992      * and stop existing when they are burned (`_burn`).
1993      */
1994     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1995         return _owners[tokenId] != address(0);
1996     }
1997 
1998     /**
1999      * @dev Returns whether `spender` is allowed to manage `tokenId`.
2000      *
2001      * Requirements:
2002      *
2003      * - `tokenId` must exist.
2004      */
2005     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
2006         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
2007         address owner = ERC721.ownerOf(tokenId);
2008         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
2009     }
2010 
2011     /**
2012      * @dev Safely mints `tokenId` and transfers it to `to`.
2013      *
2014      * Requirements:
2015      *
2016      * - `tokenId` must not exist.
2017      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2018      *
2019      * Emits a {Transfer} event.
2020      */
2021     function _safeMint(address to, uint256 tokenId) internal virtual {
2022         _safeMint(to, tokenId, "");
2023     }
2024 
2025     /**
2026      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
2027      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
2028      */
2029     function _safeMint(
2030         address to,
2031         uint256 tokenId,
2032         bytes memory data
2033     ) internal virtual {
2034         _mint(to, tokenId);
2035         require(
2036             _checkOnERC721Received(address(0), to, tokenId, data),
2037             "ERC721: transfer to non ERC721Receiver implementer"
2038         );
2039     }
2040 
2041     /**
2042      * @dev Mints `tokenId` and transfers it to `to`.
2043      *
2044      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
2045      *
2046      * Requirements:
2047      *
2048      * - `tokenId` must not exist.
2049      * - `to` cannot be the zero address.
2050      *
2051      * Emits a {Transfer} event.
2052      */
2053     function _mint(address to, uint256 tokenId) internal virtual {
2054         require(to != address(0), "ERC721: mint to the zero address");
2055         require(!_exists(tokenId), "ERC721: token already minted");
2056 
2057         _beforeTokenTransfer(address(0), to, tokenId);
2058 
2059         _balances[to] += 1;
2060         _owners[tokenId] = to;
2061 
2062         emit Transfer(address(0), to, tokenId);
2063 
2064         _afterTokenTransfer(address(0), to, tokenId);
2065     }
2066 
2067     /**
2068      * @dev Destroys `tokenId`.
2069      * The approval is cleared when the token is burned.
2070      *
2071      * Requirements:
2072      *
2073      * - `tokenId` must exist.
2074      *
2075      * Emits a {Transfer} event.
2076      */
2077     function _burn(uint256 tokenId) internal virtual {
2078         address owner = ERC721.ownerOf(tokenId);
2079 
2080         _beforeTokenTransfer(owner, address(0), tokenId);
2081 
2082         // Clear approvals
2083         _approve(address(0), tokenId);
2084 
2085         _balances[owner] -= 1;
2086         delete _owners[tokenId];
2087 
2088         emit Transfer(owner, address(0), tokenId);
2089 
2090         _afterTokenTransfer(owner, address(0), tokenId);
2091     }
2092 
2093     /**
2094      * @dev Transfers `tokenId` from `from` to `to`.
2095      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2096      *
2097      * Requirements:
2098      *
2099      * - `to` cannot be the zero address.
2100      * - `tokenId` token must be owned by `from`.
2101      *
2102      * Emits a {Transfer} event.
2103      */
2104     function _transfer(
2105         address from,
2106         address to,
2107         uint256 tokenId
2108     ) internal virtual {
2109         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
2110         require(to != address(0), "ERC721: transfer to the zero address");
2111 
2112         _beforeTokenTransfer(from, to, tokenId);
2113 
2114         // Clear approvals from the previous owner
2115         _approve(address(0), tokenId);
2116 
2117         _balances[from] -= 1;
2118         _balances[to] += 1;
2119         _owners[tokenId] = to;
2120 
2121         emit Transfer(from, to, tokenId);
2122 
2123         _afterTokenTransfer(from, to, tokenId);
2124     }
2125 
2126     /**
2127      * @dev Approve `to` to operate on `tokenId`
2128      *
2129      * Emits an {Approval} event.
2130      */
2131     function _approve(address to, uint256 tokenId) internal virtual {
2132         _tokenApprovals[tokenId] = to;
2133         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
2134     }
2135 
2136     /**
2137      * @dev Approve `operator` to operate on all of `owner` tokens
2138      *
2139      * Emits an {ApprovalForAll} event.
2140      */
2141     function _setApprovalForAll(
2142         address owner,
2143         address operator,
2144         bool approved
2145     ) internal virtual {
2146         require(owner != operator, "ERC721: approve to caller");
2147         _operatorApprovals[owner][operator] = approved;
2148         emit ApprovalForAll(owner, operator, approved);
2149     }
2150 
2151     /**
2152      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2153      * The call is not executed if the target address is not a contract.
2154      *
2155      * @param from address representing the previous owner of the given token ID
2156      * @param to target address that will receive the tokens
2157      * @param tokenId uint256 ID of the token to be transferred
2158      * @param data bytes optional data to send along with the call
2159      * @return bool whether the call correctly returned the expected magic value
2160      */
2161     function _checkOnERC721Received(
2162         address from,
2163         address to,
2164         uint256 tokenId,
2165         bytes memory data
2166     ) private returns (bool) {
2167         if (to.isContract()) {
2168             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
2169                 return retval == IERC721Receiver.onERC721Received.selector;
2170             } catch (bytes memory reason) {
2171                 if (reason.length == 0) {
2172                     revert("ERC721: transfer to non ERC721Receiver implementer");
2173                 } else {
2174                     assembly {
2175                         revert(add(32, reason), mload(reason))
2176                     }
2177                 }
2178             }
2179         } else {
2180             return true;
2181         }
2182     }
2183 
2184     /**
2185      * @dev Hook that is called before any token transfer. This includes minting
2186      * and burning.
2187      *
2188      * Calling conditions:
2189      *
2190      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2191      * transferred to `to`.
2192      * - When `from` is zero, `tokenId` will be minted for `to`.
2193      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2194      * - `from` and `to` are never both zero.
2195      *
2196      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2197      */
2198     function _beforeTokenTransfer(
2199         address from,
2200         address to,
2201         uint256 tokenId
2202     ) internal virtual {}
2203 
2204     /**
2205      * @dev Hook that is called after any transfer of tokens. This includes
2206      * minting and burning.
2207      *
2208      * Calling conditions:
2209      *
2210      * - when `from` and `to` are both non-zero.
2211      * - `from` and `to` are never both zero.
2212      *
2213      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2214      */
2215     function _afterTokenTransfer(
2216         address from,
2217         address to,
2218         uint256 tokenId
2219     ) internal virtual {}
2220 }
2221 
2222 // File: contracts/test.sol
2223 
2224 
2225 pragma solidity ^0.8.0;
2226 
2227 
2228 
2229 
2230 contract CuteCats is ERC721A, Ownable {
2231     using Strings for uint256;
2232 
2233     string private baseURI;
2234     uint256 public price = 0.0069 ether;
2235     uint256 public maxPerTx = 4;
2236     uint256 public maxPerWallet = 4;
2237     uint256 public maxFreePerWallet = 0;
2238     uint256 public totalFree = 0;
2239     uint256 public maxSupply = 3333;
2240 
2241     bool public mintEnabled = true;
2242 
2243     mapping(address => uint256) private _Amount;
2244 
2245     constructor() ERC721A("Cute Cats", "CC") {
2246         _safeMint(msg.sender, 5);
2247         setBaseURI("ipfs://QmQBYPdhXd1Tt8qnTCSKSMuBo7ENrqSaAM7k8cPqYsezMe/");
2248     }
2249 
2250     function mint(uint256 count) external payable {
2251         uint256 cost = price;
2252         bool isFree = ((totalSupply() + count < totalFree + 1) &&
2253             (_Amount[msg.sender] + count <= maxPerWallet));
2254 
2255         if (isFree) {
2256             cost = 0;
2257         }
2258 
2259 
2260        
2261         require(msg.value >= count * cost, "Please send the exact amount.");
2262         require(totalSupply() + count < maxSupply + 1, "No more");
2263         require(mintEnabled, "Minting is not live yet");
2264         require(count < maxPerTx + 1, "Max per TX reached.");
2265         require(count < maxPerWallet + 1, "No.");
2266 
2267 
2268         if (isFree) {
2269             _Amount[msg.sender] += count;
2270         }
2271 
2272         _safeMint(msg.sender, count);
2273     }
2274 
2275     function _baseURI() internal view virtual override returns (string memory) {
2276         return baseURI;
2277     }
2278 
2279     function tokenURI(uint256 tokenId)
2280         public
2281         view
2282         virtual
2283         override
2284         returns (string memory)
2285     {
2286         require(
2287             _exists(tokenId),
2288             "ERC721Metadata: URI query for nonexistent token"
2289         );
2290         return string(abi.encodePacked(baseURI, tokenId.toString(), ".json"));
2291     }
2292 
2293     function setBaseURI(string memory uri) public onlyOwner {
2294         baseURI = uri;
2295     }
2296 
2297     function setFreeAmount(uint256 amount) external onlyOwner {
2298         totalFree = amount;
2299     }
2300 
2301     function setPrice(uint256 _newPrice) external onlyOwner {
2302         price = _newPrice;
2303     }
2304 
2305     function flipSale() external onlyOwner {
2306         mintEnabled = !mintEnabled;
2307     }
2308 
2309     function withdraw() external onlyOwner {
2310         (bool success, ) = payable(msg.sender).call{
2311             value: address(this).balance
2312         }("");
2313         require(success, "Transfer failed.");
2314     }
2315 }