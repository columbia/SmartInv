1 /**
2 *                                                       .....................
3 *                   ,dOOOOOOOOOOkkkkkkxxxl'           .o0XXXXXXXXXXXXXXXXXXXKx'
4 *                  '0MMMMMMMMMMMMMMMMMMMMMX;          cWMMMMMMMMMMMMMMMMMMMMMMx.
5 *                  .xWMMMMMMMMMMMMMMMMMMMMWc          'kNWMMMMMMWMMMMMMMMMMMMMk.
6 *                   .;lloooookNMMMMMMMMMMMX;            ';;;;;;;lKMMMMMMMMMMMWo
7 *                            .xWMMMMMMMMMWd.                     :XMMMMMMMMMNx.
8 *                             .c0WMMMMMW0c.                       'd0NWWWX0x;
9 *                               .,codoc,.                           .',;,..
10 *
11 *
12 *                                        .cdoc;,'''''',;:coxOOd,
13 *                                       .xWMMMMWNNNNNWWMMMMMMMMx.
14 *                                        c0NMMMMMMMMMMMMMMWNX0x,
15 *                                         .,:looddddddollc;'..
16 *                   .','...                                                ..,:cll,
17 *                 ,kXWWNXK0Oxdlc;,'.....                     .....';:clodxOKXWMMMMNo.
18 *                .kMMMWMMMMMMMMMMWNXXK000OOkkkkxkkkkkkOOOOOO00KKXNWWMMMMMMMMMMMMMMWk.
19 *                .dWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNl
20 *                 .kWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWk.
21 *                  .xNWMMMMMMMMMMMMMN0OO0KKXNNNNWWMMMWNNXXK0Okxd0MMMMMMMMMMMMMMMW0'
22 *                   .lXMMMMMMMMMMMMMK;  ......'':0MMWx,'....    cWMMMMMMMMMMMMMWO'
23 *                     ,kNMMMMMMMMMMMK;       .:d0NMMMXko,       :NMMMMMMMMMMMMNx.
24 *                       ;kNMMMMMMMMMX;      ;0WN0KWMMXXNO.      ;XMMMMMMMMMMWO:.
25 *                         ;xXMMMMMMMX;     .kMWx'oWMMx''.       ;XMMMMMMMMNO:.
26 *                           'o0WMMMMN:      ;0WNKXWMMKc.        ;XMMMMMNOo,.
27 *                             .OMMMMWo       .;ld0WMMMMXk;      :NMMMMMd.
28 *                              cNMMMMk.          ,KMMXxOWNo.    oWMMMMNc
29 *                              '0MMMMX;     .:;. 'OMMK,:NMO.   .OMMMMM0'
30 *                              .dWMMMWd.    lNWKkkXMMNk0MNc    :NMMMMWo
31 *                               ,0MMMMX:     ,lx0XWMMMWXk;    .OMMMMM0'
32 *                                :XMMMMK:       .,OMMWx.     .dWMMMMXc
33 *                                 :XMMMMNd'       :O00;     .oNMMMMNo
34 *                                  ,OWMMMMXd;.      ..    .;kNMMMMWd.
35 *                                   .c0WMMMMWXOxolllcclloxKWMMMMMXl.
36 *                                     .:kNMMMMMMMMMMMMMMMMMMMMMXd'
37 *                                        'cx0NWMMMMMMMMMMMWN0xc.
38 *                                           ..,:llooooollc;'.
39 *
40 */
41 
42 // File: erc721a/contracts/IERC721A.sol
43 
44 
45 // ERC721A Contracts v4.0.0
46 // Creator: Chiru Labs
47 
48 pragma solidity ^0.8.4;
49 
50 /**
51  * @dev Interface of an ERC721A compliant contract.
52  */
53 interface IERC721A {
54     /**
55      * The caller must own the token or be an approved operator.
56      */
57     error ApprovalCallerNotOwnerNorApproved();
58 
59     /**
60      * The token does not exist.
61      */
62     error ApprovalQueryForNonexistentToken();
63 
64     /**
65      * The caller cannot approve to their own address.
66      */
67     error ApproveToCaller();
68 
69     /**
70      * The caller cannot approve to the current owner.
71      */
72     error ApprovalToCurrentOwner();
73 
74     /**
75      * Cannot query the balance for the zero address.
76      */
77     error BalanceQueryForZeroAddress();
78 
79     /**
80      * Cannot mint to the zero address.
81      */
82     error MintToZeroAddress();
83 
84     /**
85      * The quantity of tokens minted must be more than zero.
86      */
87     error MintZeroQuantity();
88 
89     /**
90      * The token does not exist.
91      */
92     error OwnerQueryForNonexistentToken();
93 
94     /**
95      * The caller must own the token or be an approved operator.
96      */
97     error TransferCallerNotOwnerNorApproved();
98 
99     /**
100      * The token must be owned by `from`.
101      */
102     error TransferFromIncorrectOwner();
103 
104     /**
105      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
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
119     struct TokenOwnership {
120         // The address of the owner.
121         address addr;
122         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
123         uint64 startTimestamp;
124         // Whether the token has been burned.
125         bool burned;
126     }
127 
128     /**
129      * @dev Returns the total amount of tokens stored by the contract.
130      *
131      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
132      */
133     function totalSupply() external view returns (uint256);
134 
135     // ==============================
136     //            IERC165
137     // ==============================
138 
139     /**
140      * @dev Returns true if this contract implements the interface defined by
141      * `interfaceId`. See the corresponding
142      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
143      * to learn more about how these ids are created.
144      *
145      * This function call must use less than 30 000 gas.
146      */
147     function supportsInterface(bytes4 interfaceId) external view returns (bool);
148 
149     // ==============================
150     //            IERC721
151     // ==============================
152 
153     /**
154      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
155      */
156     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
157 
158     /**
159      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
160      */
161     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
162 
163     /**
164      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
165      */
166     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
167 
168     /**
169      * @dev Returns the number of tokens in ``owner``'s account.
170      */
171     function balanceOf(address owner) external view returns (uint256 balance);
172 
173     /**
174      * @dev Returns the owner of the `tokenId` token.
175      *
176      * Requirements:
177      *
178      * - `tokenId` must exist.
179      */
180     function ownerOf(uint256 tokenId) external view returns (address owner);
181 
182     /**
183      * @dev Safely transfers `tokenId` token from `from` to `to`.
184      *
185      * Requirements:
186      *
187      * - `from` cannot be the zero address.
188      * - `to` cannot be the zero address.
189      * - `tokenId` token must exist and be owned by `from`.
190      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
191      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
192      *
193      * Emits a {Transfer} event.
194      */
195     function safeTransferFrom(
196         address from,
197         address to,
198         uint256 tokenId,
199         bytes calldata data
200     ) external;
201 
202     /**
203      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
204      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
205      *
206      * Requirements:
207      *
208      * - `from` cannot be the zero address.
209      * - `to` cannot be the zero address.
210      * - `tokenId` token must exist and be owned by `from`.
211      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
212      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
213      *
214      * Emits a {Transfer} event.
215      */
216     function safeTransferFrom(
217         address from,
218         address to,
219         uint256 tokenId
220     ) external;
221 
222     /**
223      * @dev Transfers `tokenId` token from `from` to `to`.
224      *
225      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
226      *
227      * Requirements:
228      *
229      * - `from` cannot be the zero address.
230      * - `to` cannot be the zero address.
231      * - `tokenId` token must be owned by `from`.
232      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
233      *
234      * Emits a {Transfer} event.
235      */
236     function transferFrom(
237         address from,
238         address to,
239         uint256 tokenId
240     ) external;
241 
242     /**
243      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
244      * The approval is cleared when the token is transferred.
245      *
246      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
247      *
248      * Requirements:
249      *
250      * - The caller must own the token or be an approved operator.
251      * - `tokenId` must exist.
252      *
253      * Emits an {Approval} event.
254      */
255     function approve(address to, uint256 tokenId) external;
256 
257     /**
258      * @dev Approve or remove `operator` as an operator for the caller.
259      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
260      *
261      * Requirements:
262      *
263      * - The `operator` cannot be the caller.
264      *
265      * Emits an {ApprovalForAll} event.
266      */
267     function setApprovalForAll(address operator, bool _approved) external;
268 
269     /**
270      * @dev Returns the account approved for `tokenId` token.
271      *
272      * Requirements:
273      *
274      * - `tokenId` must exist.
275      */
276     function getApproved(uint256 tokenId) external view returns (address operator);
277 
278     /**
279      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
280      *
281      * See {setApprovalForAll}
282      */
283     function isApprovedForAll(address owner, address operator) external view returns (bool);
284 
285     // ==============================
286     //        IERC721Metadata
287     // ==============================
288 
289     /**
290      * @dev Returns the token collection name.
291      */
292     function name() external view returns (string memory);
293 
294     /**
295      * @dev Returns the token collection symbol.
296      */
297     function symbol() external view returns (string memory);
298 
299     /**
300      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
301      */
302     function tokenURI(uint256 tokenId) external view returns (string memory);
303 }
304 
305 // File: erc721a/contracts/ERC721A.sol
306 
307 
308 // ERC721A Contracts v4.0.0
309 // Creator: Chiru Labs
310 
311 pragma solidity ^0.8.4;
312 
313 
314 /**
315  * @dev ERC721 token receiver interface.
316  */
317 interface ERC721A__IERC721Receiver {
318     function onERC721Received(
319         address operator,
320         address from,
321         uint256 tokenId,
322         bytes calldata data
323     ) external returns (bytes4);
324 }
325 
326 /**
327  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
328  * the Metadata extension. Built to optimize for lower gas during batch mints.
329  *
330  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
331  *
332  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
333  *
334  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
335  */
336 contract ERC721A is IERC721A {
337     // Mask of an entry in packed address data.
338     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
339 
340     // The bit position of `numberMinted` in packed address data.
341     uint256 private constant BITPOS_NUMBER_MINTED = 64;
342 
343     // The bit position of `numberBurned` in packed address data.
344     uint256 private constant BITPOS_NUMBER_BURNED = 128;
345 
346     // The bit position of `aux` in packed address data.
347     uint256 private constant BITPOS_AUX = 192;
348 
349     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
350     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
351 
352     // The bit position of `startTimestamp` in packed ownership.
353     uint256 private constant BITPOS_START_TIMESTAMP = 160;
354 
355     // The bit mask of the `burned` bit in packed ownership.
356     uint256 private constant BITMASK_BURNED = 1 << 224;
357     
358     // The bit position of the `nextInitialized` bit in packed ownership.
359     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
360 
361     // The bit mask of the `nextInitialized` bit in packed ownership.
362     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
363 
364     // The tokenId of the next token to be minted.
365     uint256 private _currentIndex;
366 
367     // The number of tokens burned.
368     uint256 private _burnCounter;
369 
370     // Token name
371     string private _name;
372 
373     // Token symbol
374     string private _symbol;
375 
376     // Mapping from token ID to ownership details
377     // An empty struct value does not necessarily mean the token is unowned.
378     // See `_packedOwnershipOf` implementation for details.
379     //
380     // Bits Layout:
381     // - [0..159]   `addr`
382     // - [160..223] `startTimestamp`
383     // - [224]      `burned`
384     // - [225]      `nextInitialized`
385     mapping(uint256 => uint256) private _packedOwnerships;
386 
387     // Mapping owner address to address data.
388     //
389     // Bits Layout:
390     // - [0..63]    `balance`
391     // - [64..127]  `numberMinted`
392     // - [128..191] `numberBurned`
393     // - [192..255] `aux`
394     mapping(address => uint256) private _packedAddressData;
395 
396     // Mapping from token ID to approved address.
397     mapping(uint256 => address) private _tokenApprovals;
398 
399     // Mapping from owner to operator approvals
400     mapping(address => mapping(address => bool)) private _operatorApprovals;
401 
402     constructor(string memory name_, string memory symbol_) {
403         _name = name_;
404         _symbol = symbol_;
405         _currentIndex = _startTokenId();
406     }
407 
408     /**
409      * @dev Returns the starting token ID. 
410      * To change the starting token ID, please override this function.
411      */
412     function _startTokenId() internal view virtual returns (uint256) {
413         return 0;
414     }
415 
416     /**
417      * @dev Returns the next token ID to be minted.
418      */
419     function _nextTokenId() internal view returns (uint256) {
420         return _currentIndex;
421     }
422 
423     /**
424      * @dev Returns the total number of tokens in existence.
425      * Burned tokens will reduce the count. 
426      * To get the total number of tokens minted, please see `_totalMinted`.
427      */
428     function totalSupply() public view override returns (uint256) {
429         // Counter underflow is impossible as _burnCounter cannot be incremented
430         // more than `_currentIndex - _startTokenId()` times.
431         unchecked {
432             return _currentIndex - _burnCounter - _startTokenId();
433         }
434     }
435 
436     /**
437      * @dev Returns the total amount of tokens minted in the contract.
438      */
439     function _totalMinted() internal view returns (uint256) {
440         // Counter underflow is impossible as _currentIndex does not decrement,
441         // and it is initialized to `_startTokenId()`
442         unchecked {
443             return _currentIndex - _startTokenId();
444         }
445     }
446 
447     /**
448      * @dev Returns the total number of tokens burned.
449      */
450     function _totalBurned() internal view returns (uint256) {
451         return _burnCounter;
452     }
453 
454     /**
455      * @dev See {IERC165-supportsInterface}.
456      */
457     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
458         // The interface IDs are constants representing the first 4 bytes of the XOR of
459         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
460         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
461         return
462             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
463             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
464             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
465     }
466 
467     /**
468      * @dev See {IERC721-balanceOf}.
469      */
470     function balanceOf(address owner) public view override returns (uint256) {
471         if (owner == address(0)) revert BalanceQueryForZeroAddress();
472         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
473     }
474 
475     /**
476      * Returns the number of tokens minted by `owner`.
477      */
478     function _numberMinted(address owner) internal view returns (uint256) {
479         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
480     }
481 
482     /**
483      * Returns the number of tokens burned by or on behalf of `owner`.
484      */
485     function _numberBurned(address owner) internal view returns (uint256) {
486         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
487     }
488 
489     /**
490      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
491      */
492     function _getAux(address owner) internal view returns (uint64) {
493         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
494     }
495 
496     /**
497      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
498      * If there are multiple variables, please pack them into a uint64.
499      */
500     function _setAux(address owner, uint64 aux) internal {
501         uint256 packed = _packedAddressData[owner];
502         uint256 auxCasted;
503         assembly { // Cast aux without masking.
504             auxCasted := aux
505         }
506         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
507         _packedAddressData[owner] = packed;
508     }
509 
510     /**
511      * Returns the packed ownership data of `tokenId`.
512      */
513     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
514         uint256 curr = tokenId;
515 
516         unchecked {
517             if (_startTokenId() <= curr)
518                 if (curr < _currentIndex) {
519                     uint256 packed = _packedOwnerships[curr];
520                     // If not burned.
521                     if (packed & BITMASK_BURNED == 0) {
522                         // Invariant:
523                         // There will always be an ownership that has an address and is not burned
524                         // before an ownership that does not have an address and is not burned.
525                         // Hence, curr will not underflow.
526                         //
527                         // We can directly compare the packed value.
528                         // If the address is zero, packed is zero.
529                         while (packed == 0) {
530                             packed = _packedOwnerships[--curr];
531                         }
532                         return packed;
533                     }
534                 }
535         }
536         revert OwnerQueryForNonexistentToken();
537     }
538 
539     /**
540      * Returns the unpacked `TokenOwnership` struct from `packed`.
541      */
542     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
543         ownership.addr = address(uint160(packed));
544         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
545         ownership.burned = packed & BITMASK_BURNED != 0;
546     }
547 
548     /**
549      * Returns the unpacked `TokenOwnership` struct at `index`.
550      */
551     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
552         return _unpackedOwnership(_packedOwnerships[index]);
553     }
554 
555     /**
556      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
557      */
558     function _initializeOwnershipAt(uint256 index) internal {
559         if (_packedOwnerships[index] == 0) {
560             _packedOwnerships[index] = _packedOwnershipOf(index);
561         }
562     }
563 
564     /**
565      * Gas spent here starts off proportional to the maximum mint batch size.
566      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
567      */
568     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
569         return _unpackedOwnership(_packedOwnershipOf(tokenId));
570     }
571 
572     /**
573      * @dev See {IERC721-ownerOf}.
574      */
575     function ownerOf(uint256 tokenId) public view override returns (address) {
576         return address(uint160(_packedOwnershipOf(tokenId)));
577     }
578 
579     /**
580      * @dev See {IERC721Metadata-name}.
581      */
582     function name() public view virtual override returns (string memory) {
583         return _name;
584     }
585 
586     /**
587      * @dev See {IERC721Metadata-symbol}.
588      */
589     function symbol() public view virtual override returns (string memory) {
590         return _symbol;
591     }
592 
593     /**
594      * @dev See {IERC721Metadata-tokenURI}.
595      */
596     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
597         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
598 
599         string memory baseURI = _baseURI();
600         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
601     }
602 
603     /**
604      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
605      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
606      * by default, can be overriden in child contracts.
607      */
608     function _baseURI() internal view virtual returns (string memory) {
609         return '';
610     }
611 
612     /**
613      * @dev Casts the address to uint256 without masking.
614      */
615     function _addressToUint256(address value) private pure returns (uint256 result) {
616         assembly {
617             result := value
618         }
619     }
620 
621     /**
622      * @dev Casts the boolean to uint256 without branching.
623      */
624     function _boolToUint256(bool value) private pure returns (uint256 result) {
625         assembly {
626             result := value
627         }
628     }
629 
630     /**
631      * @dev See {IERC721-approve}.
632      */
633     function approve(address to, uint256 tokenId) public override {
634         address owner = address(uint160(_packedOwnershipOf(tokenId)));
635         if (to == owner) revert ApprovalToCurrentOwner();
636 
637         if (_msgSenderERC721A() != owner)
638             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
639                 revert ApprovalCallerNotOwnerNorApproved();
640             }
641 
642         _tokenApprovals[tokenId] = to;
643         emit Approval(owner, to, tokenId);
644     }
645 
646     /**
647      * @dev See {IERC721-getApproved}.
648      */
649     function getApproved(uint256 tokenId) public view override returns (address) {
650         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
651 
652         return _tokenApprovals[tokenId];
653     }
654 
655     /**
656      * @dev See {IERC721-setApprovalForAll}.
657      */
658     function setApprovalForAll(address operator, bool approved) public virtual override {
659         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
660 
661         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
662         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
663     }
664 
665     /**
666      * @dev See {IERC721-isApprovedForAll}.
667      */
668     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
669         return _operatorApprovals[owner][operator];
670     }
671 
672     /**
673      * @dev See {IERC721-transferFrom}.
674      */
675     function transferFrom(
676         address from,
677         address to,
678         uint256 tokenId
679     ) public virtual override {
680         _transfer(from, to, tokenId);
681     }
682 
683     /**
684      * @dev See {IERC721-safeTransferFrom}.
685      */
686     function safeTransferFrom(
687         address from,
688         address to,
689         uint256 tokenId
690     ) public virtual override {
691         safeTransferFrom(from, to, tokenId, '');
692     }
693 
694     /**
695      * @dev See {IERC721-safeTransferFrom}.
696      */
697     function safeTransferFrom(
698         address from,
699         address to,
700         uint256 tokenId,
701         bytes memory _data
702     ) public virtual override {
703         _transfer(from, to, tokenId);
704         if (to.code.length != 0)
705             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
706                 revert TransferToNonERC721ReceiverImplementer();
707             }
708     }
709 
710     /**
711      * @dev Returns whether `tokenId` exists.
712      *
713      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
714      *
715      * Tokens start existing when they are minted (`_mint`),
716      */
717     function _exists(uint256 tokenId) internal view returns (bool) {
718         return
719             _startTokenId() <= tokenId &&
720             tokenId < _currentIndex && // If within bounds,
721             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
722     }
723 
724     /**
725      * @dev Equivalent to `_safeMint(to, quantity, '')`.
726      */
727     function _safeMint(address to, uint256 quantity) internal {
728         _safeMint(to, quantity, '');
729     }
730 
731     /**
732      * @dev Safely mints `quantity` tokens and transfers them to `to`.
733      *
734      * Requirements:
735      *
736      * - If `to` refers to a smart contract, it must implement
737      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
738      * - `quantity` must be greater than 0.
739      *
740      * Emits a {Transfer} event.
741      */
742     function _safeMint(
743         address to,
744         uint256 quantity,
745         bytes memory _data
746     ) internal {
747         uint256 startTokenId = _currentIndex;
748         if (to == address(0)) revert MintToZeroAddress();
749         if (quantity == 0) revert MintZeroQuantity();
750 
751         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
752 
753         // Overflows are incredibly unrealistic.
754         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
755         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
756         unchecked {
757             // Updates:
758             // - `balance += quantity`.
759             // - `numberMinted += quantity`.
760             //
761             // We can directly add to the balance and number minted.
762             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
763 
764             // Updates:
765             // - `address` to the owner.
766             // - `startTimestamp` to the timestamp of minting.
767             // - `burned` to `false`.
768             // - `nextInitialized` to `quantity == 1`.
769             _packedOwnerships[startTokenId] =
770                 _addressToUint256(to) |
771                 (block.timestamp << BITPOS_START_TIMESTAMP) |
772                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
773 
774             uint256 updatedIndex = startTokenId;
775             uint256 end = updatedIndex + quantity;
776 
777             if (to.code.length != 0) {
778                 do {
779                     emit Transfer(address(0), to, updatedIndex);
780                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
781                         revert TransferToNonERC721ReceiverImplementer();
782                     }
783                 } while (updatedIndex < end);
784                 // Reentrancy protection
785                 if (_currentIndex != startTokenId) revert();
786             } else {
787                 do {
788                     emit Transfer(address(0), to, updatedIndex++);
789                 } while (updatedIndex < end);
790             }
791             _currentIndex = updatedIndex;
792         }
793         _afterTokenTransfers(address(0), to, startTokenId, quantity);
794     }
795 
796     /**
797      * @dev Mints `quantity` tokens and transfers them to `to`.
798      *
799      * Requirements:
800      *
801      * - `to` cannot be the zero address.
802      * - `quantity` must be greater than 0.
803      *
804      * Emits a {Transfer} event.
805      */
806     function _mint(address to, uint256 quantity) internal {
807         uint256 startTokenId = _currentIndex;
808         if (to == address(0)) revert MintToZeroAddress();
809         if (quantity == 0) revert MintZeroQuantity();
810 
811         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
812 
813         // Overflows are incredibly unrealistic.
814         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
815         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
816         unchecked {
817             // Updates:
818             // - `balance += quantity`.
819             // - `numberMinted += quantity`.
820             //
821             // We can directly add to the balance and number minted.
822             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
823 
824             // Updates:
825             // - `address` to the owner.
826             // - `startTimestamp` to the timestamp of minting.
827             // - `burned` to `false`.
828             // - `nextInitialized` to `quantity == 1`.
829             _packedOwnerships[startTokenId] =
830                 _addressToUint256(to) |
831                 (block.timestamp << BITPOS_START_TIMESTAMP) |
832                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
833 
834             uint256 updatedIndex = startTokenId;
835             uint256 end = updatedIndex + quantity;
836 
837             do {
838                 emit Transfer(address(0), to, updatedIndex++);
839             } while (updatedIndex < end);
840 
841             _currentIndex = updatedIndex;
842         }
843         _afterTokenTransfers(address(0), to, startTokenId, quantity);
844     }
845 
846     /**
847      * @dev Transfers `tokenId` from `from` to `to`.
848      *
849      * Requirements:
850      *
851      * - `to` cannot be the zero address.
852      * - `tokenId` token must be owned by `from`.
853      *
854      * Emits a {Transfer} event.
855      */
856     function _transfer(
857         address from,
858         address to,
859         uint256 tokenId
860     ) private {
861         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
862 
863         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
864 
865         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
866             isApprovedForAll(from, _msgSenderERC721A()) ||
867             getApproved(tokenId) == _msgSenderERC721A());
868 
869         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
870         if (to == address(0)) revert TransferToZeroAddress();
871 
872         _beforeTokenTransfers(from, to, tokenId, 1);
873 
874         // Clear approvals from the previous owner.
875         delete _tokenApprovals[tokenId];
876 
877         // Underflow of the sender's balance is impossible because we check for
878         // ownership above and the recipient's balance can't realistically overflow.
879         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
880         unchecked {
881             // We can directly increment and decrement the balances.
882             --_packedAddressData[from]; // Updates: `balance -= 1`.
883             ++_packedAddressData[to]; // Updates: `balance += 1`.
884 
885             // Updates:
886             // - `address` to the next owner.
887             // - `startTimestamp` to the timestamp of transfering.
888             // - `burned` to `false`.
889             // - `nextInitialized` to `true`.
890             _packedOwnerships[tokenId] =
891                 _addressToUint256(to) |
892                 (block.timestamp << BITPOS_START_TIMESTAMP) |
893                 BITMASK_NEXT_INITIALIZED;
894 
895             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
896             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
897                 uint256 nextTokenId = tokenId + 1;
898                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
899                 if (_packedOwnerships[nextTokenId] == 0) {
900                     // If the next slot is within bounds.
901                     if (nextTokenId != _currentIndex) {
902                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
903                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
904                     }
905                 }
906             }
907         }
908 
909         emit Transfer(from, to, tokenId);
910         _afterTokenTransfers(from, to, tokenId, 1);
911     }
912 
913     /**
914      * @dev Equivalent to `_burn(tokenId, false)`.
915      */
916     function _burn(uint256 tokenId) internal virtual {
917         _burn(tokenId, false);
918     }
919 
920     /**
921      * @dev Destroys `tokenId`.
922      * The approval is cleared when the token is burned.
923      *
924      * Requirements:
925      *
926      * - `tokenId` must exist.
927      *
928      * Emits a {Transfer} event.
929      */
930     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
931         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
932 
933         address from = address(uint160(prevOwnershipPacked));
934 
935         if (approvalCheck) {
936             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
937                 isApprovedForAll(from, _msgSenderERC721A()) ||
938                 getApproved(tokenId) == _msgSenderERC721A());
939 
940             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
941         }
942 
943         _beforeTokenTransfers(from, address(0), tokenId, 1);
944 
945         // Clear approvals from the previous owner.
946         delete _tokenApprovals[tokenId];
947 
948         // Underflow of the sender's balance is impossible because we check for
949         // ownership above and the recipient's balance can't realistically overflow.
950         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
951         unchecked {
952             // Updates:
953             // - `balance -= 1`.
954             // - `numberBurned += 1`.
955             //
956             // We can directly decrement the balance, and increment the number burned.
957             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
958             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
959 
960             // Updates:
961             // - `address` to the last owner.
962             // - `startTimestamp` to the timestamp of burning.
963             // - `burned` to `true`.
964             // - `nextInitialized` to `true`.
965             _packedOwnerships[tokenId] =
966                 _addressToUint256(from) |
967                 (block.timestamp << BITPOS_START_TIMESTAMP) |
968                 BITMASK_BURNED | 
969                 BITMASK_NEXT_INITIALIZED;
970 
971             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
972             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
973                 uint256 nextTokenId = tokenId + 1;
974                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
975                 if (_packedOwnerships[nextTokenId] == 0) {
976                     // If the next slot is within bounds.
977                     if (nextTokenId != _currentIndex) {
978                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
979                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
980                     }
981                 }
982             }
983         }
984 
985         emit Transfer(from, address(0), tokenId);
986         _afterTokenTransfers(from, address(0), tokenId, 1);
987 
988         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
989         unchecked {
990             _burnCounter++;
991         }
992     }
993 
994     /**
995      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
996      *
997      * @param from address representing the previous owner of the given token ID
998      * @param to target address that will receive the tokens
999      * @param tokenId uint256 ID of the token to be transferred
1000      * @param _data bytes optional data to send along with the call
1001      * @return bool whether the call correctly returned the expected magic value
1002      */
1003     function _checkContractOnERC721Received(
1004         address from,
1005         address to,
1006         uint256 tokenId,
1007         bytes memory _data
1008     ) private returns (bool) {
1009         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1010             bytes4 retval
1011         ) {
1012             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1013         } catch (bytes memory reason) {
1014             if (reason.length == 0) {
1015                 revert TransferToNonERC721ReceiverImplementer();
1016             } else {
1017                 assembly {
1018                     revert(add(32, reason), mload(reason))
1019                 }
1020             }
1021         }
1022     }
1023 
1024     /**
1025      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1026      * And also called before burning one token.
1027      *
1028      * startTokenId - the first token id to be transferred
1029      * quantity - the amount to be transferred
1030      *
1031      * Calling conditions:
1032      *
1033      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1034      * transferred to `to`.
1035      * - When `from` is zero, `tokenId` will be minted for `to`.
1036      * - When `to` is zero, `tokenId` will be burned by `from`.
1037      * - `from` and `to` are never both zero.
1038      */
1039     function _beforeTokenTransfers(
1040         address from,
1041         address to,
1042         uint256 startTokenId,
1043         uint256 quantity
1044     ) internal virtual {}
1045 
1046     /**
1047      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1048      * minting.
1049      * And also called after one token has been burned.
1050      *
1051      * startTokenId - the first token id to be transferred
1052      * quantity - the amount to be transferred
1053      *
1054      * Calling conditions:
1055      *
1056      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1057      * transferred to `to`.
1058      * - When `from` is zero, `tokenId` has been minted for `to`.
1059      * - When `to` is zero, `tokenId` has been burned by `from`.
1060      * - `from` and `to` are never both zero.
1061      */
1062     function _afterTokenTransfers(
1063         address from,
1064         address to,
1065         uint256 startTokenId,
1066         uint256 quantity
1067     ) internal virtual {}
1068 
1069     /**
1070      * @dev Returns the message sender (defaults to `msg.sender`).
1071      *
1072      * If you are writing GSN compatible contracts, you need to override this function.
1073      */
1074     function _msgSenderERC721A() internal view virtual returns (address) {
1075         return msg.sender;
1076     }
1077 
1078     /**
1079      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1080      */
1081     function _toString(uint256 value) internal pure returns (string memory ptr) {
1082         assembly {
1083             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1084             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1085             // We will need 1 32-byte word to store the length, 
1086             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1087             ptr := add(mload(0x40), 128)
1088             // Update the free memory pointer to allocate.
1089             mstore(0x40, ptr)
1090 
1091             // Cache the end of the memory to calculate the length later.
1092             let end := ptr
1093 
1094             // We write the string from the rightmost digit to the leftmost digit.
1095             // The following is essentially a do-while loop that also handles the zero case.
1096             // Costs a bit more than early returning for the zero case,
1097             // but cheaper in terms of deployment and overall runtime costs.
1098             for { 
1099                 // Initialize and perform the first pass without check.
1100                 let temp := value
1101                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1102                 ptr := sub(ptr, 1)
1103                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1104                 mstore8(ptr, add(48, mod(temp, 10)))
1105                 temp := div(temp, 10)
1106             } temp { 
1107                 // Keep dividing `temp` until zero.
1108                 temp := div(temp, 10)
1109             } { // Body of the for loop.
1110                 ptr := sub(ptr, 1)
1111                 mstore8(ptr, add(48, mod(temp, 10)))
1112             }
1113             
1114             let length := sub(end, ptr)
1115             // Move the pointer 32 bytes leftwards to make room for the length.
1116             ptr := sub(ptr, 32)
1117             // Store the length.
1118             mstore(ptr, length)
1119         }
1120     }
1121 }
1122 
1123 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
1124 
1125 
1126 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
1127 
1128 pragma solidity ^0.8.0;
1129 
1130 /**
1131  * @dev String operations.
1132  */
1133 library Strings {
1134     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1135 
1136     /**
1137      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1138      */
1139     function toString(uint256 value) internal pure returns (string memory) {
1140         // Inspired by OraclizeAPI's implementation - MIT licence
1141         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1142 
1143         if (value == 0) {
1144             return "0";
1145         }
1146         uint256 temp = value;
1147         uint256 digits;
1148         while (temp != 0) {
1149             digits++;
1150             temp /= 10;
1151         }
1152         bytes memory buffer = new bytes(digits);
1153         while (value != 0) {
1154             digits -= 1;
1155             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1156             value /= 10;
1157         }
1158         return string(buffer);
1159     }
1160 
1161     /**
1162      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1163      */
1164     function toHexString(uint256 value) internal pure returns (string memory) {
1165         if (value == 0) {
1166             return "0x00";
1167         }
1168         uint256 temp = value;
1169         uint256 length = 0;
1170         while (temp != 0) {
1171             length++;
1172             temp >>= 8;
1173         }
1174         return toHexString(value, length);
1175     }
1176 
1177     /**
1178      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1179      */
1180     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1181         bytes memory buffer = new bytes(2 * length + 2);
1182         buffer[0] = "0";
1183         buffer[1] = "x";
1184         for (uint256 i = 2 * length + 1; i > 1; --i) {
1185             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1186             value >>= 4;
1187         }
1188         require(value == 0, "Strings: hex length insufficient");
1189         return string(buffer);
1190     }
1191 }
1192 
1193 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
1194 
1195 
1196 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1197 
1198 pragma solidity ^0.8.0;
1199 
1200 /**
1201  * @dev Provides information about the current execution context, including the
1202  * sender of the transaction and its data. While these are generally available
1203  * via msg.sender and msg.data, they should not be accessed in such a direct
1204  * manner, since when dealing with meta-transactions the account sending and
1205  * paying for execution may not be the actual sender (as far as an application
1206  * is concerned).
1207  *
1208  * This contract is only required for intermediate, library-like contracts.
1209  */
1210 abstract contract Context {
1211     function _msgSender() internal view virtual returns (address) {
1212         return msg.sender;
1213     }
1214 
1215     function _msgData() internal view virtual returns (bytes calldata) {
1216         return msg.data;
1217     }
1218 }
1219 
1220 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
1221 
1222 
1223 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1224 
1225 pragma solidity ^0.8.0;
1226 
1227 
1228 /**
1229  * @dev Contract module which provides a basic access control mechanism, where
1230  * there is an account (an owner) that can be granted exclusive access to
1231  * specific functions.
1232  *
1233  * By default, the owner account will be the one that deploys the contract. This
1234  * can later be changed with {transferOwnership}.
1235  *
1236  * This module is used through inheritance. It will make available the modifier
1237  * `onlyOwner`, which can be applied to your functions to restrict their use to
1238  * the owner.
1239  */
1240 abstract contract Ownable is Context {
1241     address private _owner;
1242 
1243     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1244 
1245     /**
1246      * @dev Initializes the contract setting the deployer as the initial owner.
1247      */
1248     constructor() {
1249         _transferOwnership(_msgSender());
1250     }
1251 
1252     /**
1253      * @dev Returns the address of the current owner.
1254      */
1255     function owner() public view virtual returns (address) {
1256         return _owner;
1257     }
1258 
1259     /**
1260      * @dev Throws if called by any account other than the owner.
1261      */
1262     modifier onlyOwner() {
1263         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1264         _;
1265     }
1266 
1267     /**
1268      * @dev Leaves the contract without owner. It will not be possible to call
1269      * `onlyOwner` functions anymore. Can only be called by the current owner.
1270      *
1271      * NOTE: Renouncing ownership will leave the contract without an owner,
1272      * thereby removing any functionality that is only available to the owner.
1273      */
1274     function renounceOwnership() public virtual onlyOwner {
1275         _transferOwnership(address(0));
1276     }
1277 
1278     /**
1279      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1280      * Can only be called by the current owner.
1281      */
1282     function transferOwnership(address newOwner) public virtual onlyOwner {
1283         require(newOwner != address(0), "Ownable: new owner is the zero address");
1284         _transferOwnership(newOwner);
1285     }
1286 
1287     /**
1288      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1289      * Internal function without access restriction.
1290      */
1291     function _transferOwnership(address newOwner) internal virtual {
1292         address oldOwner = _owner;
1293         _owner = newOwner;
1294         emit OwnershipTransferred(oldOwner, newOwner);
1295     }
1296 }
1297 
1298 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/security/Pausable.sol
1299 
1300 
1301 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
1302 
1303 pragma solidity ^0.8.0;
1304 
1305 
1306 /**
1307  * @dev Contract module which allows children to implement an emergency stop
1308  * mechanism that can be triggered by an authorized account.
1309  *
1310  * This module is used through inheritance. It will make available the
1311  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1312  * the functions of your contract. Note that they will not be pausable by
1313  * simply including this module, only once the modifiers are put in place.
1314  */
1315 abstract contract Pausable is Context {
1316     /**
1317      * @dev Emitted when the pause is triggered by `account`.
1318      */
1319     event Paused(address account);
1320 
1321     /**
1322      * @dev Emitted when the pause is lifted by `account`.
1323      */
1324     event Unpaused(address account);
1325 
1326     bool private _paused;
1327 
1328     /**
1329      * @dev Initializes the contract in unpaused state.
1330      */
1331     constructor() {
1332         _paused = false;
1333     }
1334 
1335     /**
1336      * @dev Modifier to make a function callable only when the contract is not paused.
1337      *
1338      * Requirements:
1339      *
1340      * - The contract must not be paused.
1341      */
1342     modifier whenNotPaused() {
1343         _requireNotPaused();
1344         _;
1345     }
1346 
1347     /**
1348      * @dev Modifier to make a function callable only when the contract is paused.
1349      *
1350      * Requirements:
1351      *
1352      * - The contract must be paused.
1353      */
1354     modifier whenPaused() {
1355         _requirePaused();
1356         _;
1357     }
1358 
1359     /**
1360      * @dev Returns true if the contract is paused, and false otherwise.
1361      */
1362     function paused() public view virtual returns (bool) {
1363         return _paused;
1364     }
1365 
1366     /**
1367      * @dev Throws if the contract is paused.
1368      */
1369     function _requireNotPaused() internal view virtual {
1370         require(!paused(), "Pausable: paused");
1371     }
1372 
1373     /**
1374      * @dev Throws if the contract is not paused.
1375      */
1376     function _requirePaused() internal view virtual {
1377         require(paused(), "Pausable: not paused");
1378     }
1379 
1380     /**
1381      * @dev Triggers stopped state.
1382      *
1383      * Requirements:
1384      *
1385      * - The contract must not be paused.
1386      */
1387     function _pause() internal virtual whenNotPaused {
1388         _paused = true;
1389         emit Paused(_msgSender());
1390     }
1391 
1392     /**
1393      * @dev Returns to normal state.
1394      *
1395      * Requirements:
1396      *
1397      * - The contract must be paused.
1398      */
1399     function _unpause() internal virtual whenPaused {
1400         _paused = false;
1401         emit Unpaused(_msgSender());
1402     }
1403 }
1404 
1405 // File: bord-stack.sol
1406 
1407 
1408 pragma solidity ^ 0.8 .4;
1409 
1410 
1411 
1412 
1413 
1414 
1415 
1416 
1417 contract BoredStackers is ERC721A, Pausable, Ownable {
1418     using Strings for uint256;
1419 
1420     enum SalePhase {
1421         Phase01,
1422         Phase02,
1423         Phase03
1424     }
1425 
1426     enum CouponType {
1427         Vip,
1428         Normal,
1429         Raffle,
1430         Public
1431     }
1432 
1433     struct Coupon {
1434         bytes32 r;
1435         bytes32 s;
1436         uint8 v;
1437     }
1438 
1439     uint64 public maxSupply = 5000;
1440     uint64 private constant mintPrice_TypeVip =  0.10 ether;
1441     uint64 private constant mintPrice_TypeNormal =  0.125 ether;
1442     uint64 private constant mintPrice_TypeRaffle =  0.15 ether;
1443     uint64 private mintPrice_Phase03_TypeAll =  0.15 ether;
1444     uint64 private constant maxMints_GiveAway = 100;
1445     uint64 private maxMints_PerAddress = 20;
1446     uint8 private constant maxMint_TypeVip_PerAddress = 5;
1447     uint8 private constant maxMint_TypeNormal_PerAddress = 3;
1448     uint8 private constant maxMint_TypeRaffle_PerAddress = 1;
1449 
1450     bool private isGiveAway;
1451 
1452     string private baseURI = "https://nft.boredstackers.com/metadata/";
1453 
1454     address private constant _adminSigner = 0x948C509D377b94e500d1ed97a4E28d4DF3289d14;
1455     address private constant treasuryAddress = 0xAc05046Eb1271489B061C8E95204800ac0bcaB72;
1456 
1457     mapping(address => uint256) public MintsCount;
1458 
1459     event NewURI(string newURI, address updatedBy);
1460     event WithdrawnPayment(uint256 tresuryBalance, address tresuryAddress, uint256 ownerBalance, address owner);
1461     event updatePhase(SalePhase phase, address updatedBy);
1462     event updateAdminSigner(address adminSigner, address updatedBy);
1463     event updateGiveAwayAddress(address giveAwayAddress, address updatedBy);
1464     event updateMaxSupply(uint256 newMaxSupply, address updatedBy);
1465     event updateMaxMintsPerAddress(uint256 newMaxMintsPerAddress, address updatedBy);
1466     event updateMintPricePhase03TypeAll(uint256 MintPricePhase03TypeAll, address updatedBy);
1467 
1468     SalePhase public phase = SalePhase.Phase01;
1469 
1470     constructor() ERC721A("Bored Stackers", "B$") {
1471         pause();
1472     }
1473 
1474 
1475     modifier onlyPhase03() {
1476         require(phase == SalePhase.Phase03, "Invalid phase");
1477         _;
1478     }
1479 
1480     /**
1481      * @dev setMaxSupply updates maxSupply
1482      *
1483      * Emits a {updateMaxSupply} event.
1484      *
1485      * Requirements:
1486      *
1487      * - Only the owner can call this function
1488      */
1489     function setMaxSupply(uint64 newMaxSupply)
1490     external
1491     onlyOwner {
1492         require(newMaxSupply > totalSupply(), "Invalid max supply");
1493         maxSupply = newMaxSupply;
1494         emit updateMaxSupply(newMaxSupply, msg.sender);
1495     }
1496 
1497     /**
1498      * @dev setMaxMintsPerAddress updates maxMintsPerAddress
1499      *
1500      * Emits a {updateMaxMintsPerAddress} event.
1501      *
1502      * Requirements:
1503      *
1504      * - Only the owner can call this function
1505      */
1506     function setMaxMintsPerAddress(uint8 max)
1507     external
1508     onlyOwner
1509     onlyPhase03 {
1510         maxMints_PerAddress = max;
1511         emit updateMaxMintsPerAddress(max, msg.sender);
1512     }
1513 
1514     /**
1515      * @dev setMintPricePhase03TypeAll updates mintPrice_Phase03_TypeAll
1516      *
1517      * Emits a {updateMintPricePhase03TypeAll} event.
1518      * Requirements:
1519      *
1520      * - Only the owner can call this function
1521      */
1522     function setMintPricePhase03TypeAll(uint8 max)
1523     external
1524     onlyOwner
1525     onlyPhase03 {
1526         mintPrice_Phase03_TypeAll = max;
1527         emit updateMintPricePhase03TypeAll(max, msg.sender);
1528     }
1529 
1530     /**
1531      * @dev setPhase updates the price and the phase to (Locked, Private, Presale or Public).
1532      $
1533      * Emits a {Unpaused} event.
1534      *
1535      * Requirements:
1536      *
1537      * - Only the owner can call this function
1538      */
1539 
1540     function setPhase(SalePhase phase_)
1541     external
1542     onlyOwner {
1543         phase = phase_;
1544         emit updatePhase(phase_, msg.sender);
1545     }
1546 
1547 
1548     /**
1549      * @dev setBaseUri updates the new token URI in contract.
1550      *
1551      * Emits a {NewURI} event.
1552      *
1553      * Requirements:
1554      *
1555      * - Only owner of contract can call this function
1556      **/
1557 
1558     function setBaseUri(string memory uri)
1559     external
1560     onlyOwner {
1561         baseURI = uri;
1562         emit NewURI(uri, msg.sender);
1563     }
1564 
1565     /**
1566      * @dev Mint to mint nft
1567      *
1568      * Emits [Transfer] event.
1569      *
1570      * Requirements:
1571      *
1572      * - should have a valid coupon if we are ()
1573      **/
1574 
1575     function mint(uint64 amount, Coupon memory coupon, CouponType couponType)
1576     external
1577     payable
1578     whenNotPaused {
1579 
1580         // verify coupon
1581         bytes32 digest = keccak256(
1582             abi.encode(couponType, msg.sender)
1583         );
1584         require(_isVerifiedCoupon(digest, coupon), "Invalid coupon");
1585 
1586         // check if user can mint
1587         if(phase == SalePhase.Phase01) {
1588             require(couponType == CouponType.Vip || couponType == CouponType.Normal,
1589                 "Invalid coupon");
1590             if(couponType == CouponType.Vip) {
1591                 _checkMint(amount, maxMint_TypeVip_PerAddress, mintPrice_TypeVip);
1592             }
1593             else if(couponType == CouponType.Normal) {
1594                 _checkMint(amount, maxMint_TypeNormal_PerAddress, mintPrice_TypeNormal);
1595             }
1596         } else if(phase == SalePhase.Phase02) {
1597              require(couponType == CouponType.Vip || couponType == CouponType.Normal || couponType == CouponType.Raffle,
1598                 "Invalid coupon");
1599             if(couponType == CouponType.Vip) {
1600                 _checkMint(amount, maxMint_TypeVip_PerAddress, mintPrice_TypeVip);
1601             } else if(couponType == CouponType.Normal) {
1602                 _checkMint(amount, maxMint_TypeNormal_PerAddress, mintPrice_TypeNormal);
1603             } else {
1604                 _checkMint(amount, maxMint_TypeRaffle_PerAddress, mintPrice_TypeRaffle);
1605             }
1606         } else {
1607             require(couponType == CouponType.Vip || couponType == CouponType.Normal
1608                         || couponType == CouponType.Raffle || couponType == CouponType.Public,
1609                 "Invalid coupon");
1610             _checkMint(amount, maxMints_PerAddress, mintPrice_Phase03_TypeAll);
1611         }
1612 
1613         // increment mint count
1614         unchecked {
1615             MintsCount[msg.sender] = MintsCount[msg.sender] + amount;
1616         }
1617 
1618         // mint
1619         _mint(msg.sender, amount);
1620     }
1621 
1622     function _checkMint(uint64 amount, uint64 maxMint, uint64 price) internal {
1623         require(amount < maxMint + 1, "Invalid amount");
1624         require(msg.value > amount * price - 1, "Insufficient funds in the wallet");
1625         require(MintsCount[msg.sender] + amount < maxMint + 1,
1626             "Maximum amount per wallet already minted for this phase");
1627         require(totalSupply() + amount < maxSupply + 1,
1628             "Max supply reached");
1629     }
1630 
1631     /**
1632      * @dev giveAway mints 100 NFT once.
1633      *
1634      * Emits a {Transfer} event.
1635      *
1636      * Requirements:
1637      *
1638      * - Only the giveAwayAddress call this function
1639      */
1640 
1641     function giveAway() external {
1642         require(msg.sender == treasuryAddress, "Invalid user");
1643         require(!isGiveAway, "Already minted");
1644         uint256 _tokenId = _nextTokenId();
1645         require(_tokenId + maxMints_GiveAway < maxSupply + 1, "Max supply limit reached");
1646         _mint(msg.sender, maxMints_GiveAway);
1647         isGiveAway = true;
1648     }
1649 
1650     /**
1651      * @dev _isVerifiedCoupon verify the coupon
1652      *
1653      */
1654 
1655     function _isVerifiedCoupon(bytes32 digest, Coupon memory coupon)
1656     internal
1657     pure
1658     returns(bool) {
1659         address signer = ecrecover(digest, coupon.v, coupon.r, coupon.s);
1660         require(signer != address(0), "ECDSA: invalid signature"); // Added check for zero address
1661         return signer == _adminSigner;
1662     }
1663 
1664     /**
1665      * @dev getAdminSigner returns the adminSigner address
1666      *
1667      */
1668 
1669     function getAdminSigner() public pure returns(address) {
1670         return _adminSigner;
1671     }
1672 
1673     /**
1674      * @dev getTreasuryAddress returns the treasury address
1675      *
1676      */
1677 
1678     function getTreasuryAddress() public pure returns(address) {
1679         return treasuryAddress;
1680     }
1681 
1682     /**
1683          * @dev getMintsCount returns count mints by address
1684      *
1685      */
1686     function getMintsCount(address _address) public view returns(uint256) {
1687         return MintsCount[_address];
1688     }
1689 
1690     /**
1691      * @dev getbaseURI returns the base uri
1692      *
1693      */
1694 
1695     function getbaseURI() public view returns(string memory) {
1696         return baseURI;
1697     }
1698 
1699     /**
1700      * @dev tokenURI returns the uri to meta data
1701      *
1702      */
1703 
1704     function tokenURI(uint256 tokenId)
1705     public
1706     view
1707     override
1708     returns(string memory) {
1709         require(_exists(tokenId), "ERC721A: Query for non-existent token");
1710             return bytes(baseURI).length > 0 ?
1711                 string(abi.encodePacked(baseURI, tokenId.toString())) :
1712                 "";
1713 
1714     }
1715 
1716     /// @dev Returns the starting token ID.
1717     function _startTokenId() internal view virtual override returns (uint256) {
1718         return 1;
1719     }
1720 
1721 
1722     /**
1723      * @dev pause() is used to pause contract.
1724      *
1725      * Emits a {Paused} event.
1726      *
1727      * Requirements:
1728      *
1729      * - Only the owner can call this function
1730      **/
1731 
1732     function pause() public onlyOwner whenNotPaused {
1733         _pause();
1734     }
1735 
1736     /**
1737      * @dev unpause() is used to unpause contract.
1738      *
1739      * Emits a {Unpaused} event.
1740      *
1741      * Requirements:
1742      *
1743      * - Only the owner can call this function
1744      **/
1745 
1746     function unpause() public onlyOwner whenPaused {
1747         _unpause();
1748     }
1749 
1750     /**
1751      * @dev withdraw is used to withdraw payment from contract.
1752      *
1753      * Emits a {WithdrawnPayment} event.
1754      *
1755      * Requirements:
1756      *
1757      * - Only the owner can call this function
1758      **/
1759 
1760     function withdraw() public {
1761         require(msg.sender == treasuryAddress || msg.sender == owner(), "Invalid user");
1762         uint256 balanceOwner = address(this).balance * 400 / 10000;
1763         address owner = owner();
1764         (bool success, ) = payable(owner).call{ value: balanceOwner }("");
1765         require(success, "Failed Transfer funds to owner");
1766         uint256 balanceTreasury = address(this).balance;
1767         (success, ) = payable(treasuryAddress).call{ value: balanceTreasury }("");
1768         require(success, "Failed Transfer funds to treasury");
1769         emit WithdrawnPayment(balanceTreasury, treasuryAddress, balanceOwner, owner);
1770     }
1771 
1772 }