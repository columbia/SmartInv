1 //             _     
2 //    .""""">.(8)_   
3 //     `(/_|_\)"  \  
4 //      /  |  \    "  
5 //
6 // $$$$$$$\                            $$\ $$$$$$$$\ $$\                 $$\      $$\                     $$\       $$\ 
7 // $$  __$$\                           $$ |$$  _____|$$ |                $$ | $\  $$ |                    $$ |      $$ |
8 // $$ |  $$ | $$$$$$\   $$$$$$\   $$$$$$$ |$$ |      $$ |$$\   $$\       $$ |$$$\ $$ | $$$$$$\   $$$$$$\  $$ | $$$$$$$ |
9 // $$ |  $$ |$$  __$$\  \____$$\ $$  __$$ |$$$$$\    $$ |$$ |  $$ |      $$ $$ $$\$$ |$$  __$$\ $$  __$$\ $$ |$$  __$$ |
10 // $$ |  $$ |$$$$$$$$ | $$$$$$$ |$$ /  $$ |$$  __|   $$ |$$ |  $$ |      $$$$  _$$$$ |$$ /  $$ |$$ |  \__|$$ |$$ /  $$ |
11 // $$ |  $$ |$$   ____|$$  __$$ |$$ |  $$ |$$ |      $$ |$$ |  $$ |      $$$  / \$$$ |$$ |  $$ |$$ |      $$ |$$ |  $$ |
12 // $$$$$$$  |\$$$$$$$\ \$$$$$$$ |\$$$$$$$ |$$ |      $$ |\$$$$$$$ |      $$  /   \$$ |\$$$$$$  |$$ |      $$ |\$$$$$$$ |
13 // \_______/  \_______| \_______| \_______|\__|      \__| \____$$ |      \__/     \__| \______/ \__|      \__| \_______|
14 //                                                       $$\   $$ |                                                     
15 //                                                       \$$$$$$  |                                                     
16 //                                                        \______/                                                      
17         
18 
19 
20 // ERC721A Contracts v4.0.0
21 // Creator: Chiru Labs
22 
23 pragma solidity ^0.8.4;
24 
25 /**
26  * @dev Interface of an ERC721A compliant contract.
27  */
28 interface IERC721A {
29     /**
30      * The caller must own the token or be an approved operator.
31      */
32     error ApprovalCallerNotOwnerNorApproved();
33 
34     /**
35      * The token does not exist.
36      */
37     error ApprovalQueryForNonexistentToken();
38 
39     /**
40      * The caller cannot approve to their own address.
41      */
42     error ApproveToCaller();
43 
44     /**
45      * The caller cannot approve to the current owner.
46      */
47     error ApprovalToCurrentOwner();
48 
49     /**
50      * Cannot query the balance for the zero address.
51      */
52     error BalanceQueryForZeroAddress();
53 
54     /**
55      * Cannot mint to the zero address.
56      */
57     error MintToZeroAddress();
58 
59     /**
60      * The quantity of tokens minted must be more than zero.
61      */
62     error MintZeroQuantity();
63 
64     /**
65      * The token does not exist.
66      */
67     error OwnerQueryForNonexistentToken();
68 
69     /**
70      * The caller must own the token or be an approved operator.
71      */
72     error TransferCallerNotOwnerNorApproved();
73 
74     /**
75      * The token must be owned by `from`.
76      */
77     error TransferFromIncorrectOwner();
78 
79     /**
80      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
81      */
82     error TransferToNonERC721ReceiverImplementer();
83 
84     /**
85      * Cannot transfer to the zero address.
86      */
87     error TransferToZeroAddress();
88 
89     /**
90      * The token does not exist.
91      */
92     error URIQueryForNonexistentToken();
93 
94     struct TokenOwnership {
95         // The address of the owner.
96         address addr;
97         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
98         uint64 startTimestamp;
99         // Whether the token has been burned.
100         bool burned;
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
278 }
279 
280 // File: erc721a/contracts/ERC721A.sol
281 
282 
283 // ERC721A Contracts v4.0.0
284 // Creator: Chiru Labs
285 
286 pragma solidity ^0.8.4;
287 
288 
289 /**
290  * @dev ERC721 token receiver interface.
291  */
292 interface ERC721A__IERC721Receiver {
293     function onERC721Received(
294         address operator,
295         address from,
296         uint256 tokenId,
297         bytes calldata data
298     ) external returns (bytes4);
299 }
300 
301 /**
302  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
303  * the Metadata extension. Built to optimize for lower gas during batch mints.
304  *
305  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
306  *
307  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
308  *
309  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
310  */
311 contract ERC721A is IERC721A {
312     // Mask of an entry in packed address data.
313     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
314 
315     // The bit position of `numberMinted` in packed address data.
316     uint256 private constant BITPOS_NUMBER_MINTED = 64;
317 
318     // The bit position of `numberBurned` in packed address data.
319     uint256 private constant BITPOS_NUMBER_BURNED = 128;
320 
321     // The bit position of `aux` in packed address data.
322     uint256 private constant BITPOS_AUX = 192;
323 
324     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
325     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
326 
327     // The bit position of `startTimestamp` in packed ownership.
328     uint256 private constant BITPOS_START_TIMESTAMP = 160;
329 
330     // The bit mask of the `burned` bit in packed ownership.
331     uint256 private constant BITMASK_BURNED = 1 << 224;
332     
333     // The bit position of the `nextInitialized` bit in packed ownership.
334     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
335 
336     // The bit mask of the `nextInitialized` bit in packed ownership.
337     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
338 
339     // The tokenId of the next token to be minted.
340     uint256 private _currentIndex;
341 
342     // The number of tokens burned.
343     uint256 private _burnCounter;
344 
345     // Token name
346     string private _name;
347 
348     // Token symbol
349     string private _symbol;
350 
351     // Mapping from token ID to ownership details
352     // An empty struct value does not necessarily mean the token is unowned.
353     // See `_packedOwnershipOf` implementation for details.
354     //
355     // Bits Layout:
356     // - [0..159]   `addr`
357     // - [160..223] `startTimestamp`
358     // - [224]      `burned`
359     // - [225]      `nextInitialized`
360     mapping(uint256 => uint256) private _packedOwnerships;
361 
362     // Mapping owner address to address data.
363     //
364     // Bits Layout:
365     // - [0..63]    `balance`
366     // - [64..127]  `numberMinted`
367     // - [128..191] `numberBurned`
368     // - [192..255] `aux`
369     mapping(address => uint256) private _packedAddressData;
370 
371     // Mapping from token ID to approved address.
372     mapping(uint256 => address) private _tokenApprovals;
373 
374     // Mapping from owner to operator approvals
375     mapping(address => mapping(address => bool)) private _operatorApprovals;
376 
377     constructor(string memory name_, string memory symbol_) {
378         _name = name_;
379         _symbol = symbol_;
380         _currentIndex = _startTokenId();
381     }
382 
383     /**
384      * @dev Returns the starting token ID. 
385      * To change the starting token ID, please override this function.
386      */
387     function _startTokenId() internal view virtual returns (uint256) {
388         return 0;
389     }
390 
391     /**
392      * @dev Returns the next token ID to be minted.
393      */
394     function _nextTokenId() internal view returns (uint256) {
395         return _currentIndex;
396     }
397 
398     /**
399      * @dev Returns the total number of tokens in existence.
400      * Burned tokens will reduce the count. 
401      * To get the total number of tokens minted, please see `_totalMinted`.
402      */
403     function totalSupply() public view override returns (uint256) {
404         // Counter underflow is impossible as _burnCounter cannot be incremented
405         // more than `_currentIndex - _startTokenId()` times.
406         unchecked {
407             return _currentIndex - _burnCounter - _startTokenId();
408         }
409     }
410 
411     /**
412      * @dev Returns the total amount of tokens minted in the contract.
413      */
414     function _totalMinted() internal view returns (uint256) {
415         // Counter underflow is impossible as _currentIndex does not decrement,
416         // and it is initialized to `_startTokenId()`
417         unchecked {
418             return _currentIndex - _startTokenId();
419         }
420     }
421 
422     /**
423      * @dev Returns the total number of tokens burned.
424      */
425     function _totalBurned() internal view returns (uint256) {
426         return _burnCounter;
427     }
428 
429     /**
430      * @dev See {IERC165-supportsInterface}.
431      */
432     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
433         // The interface IDs are constants representing the first 4 bytes of the XOR of
434         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
435         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
436         return
437             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
438             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
439             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
440     }
441 
442     /**
443      * @dev See {IERC721-balanceOf}.
444      */
445     function balanceOf(address owner) public view override returns (uint256) {
446         if (owner == address(0)) revert BalanceQueryForZeroAddress();
447         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
448     }
449 
450     /**
451      * Returns the number of tokens minted by `owner`.
452      */
453     function _numberMinted(address owner) internal view returns (uint256) {
454         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
455     }
456 
457     /**
458      * Returns the number of tokens burned by or on behalf of `owner`.
459      */
460     function _numberBurned(address owner) internal view returns (uint256) {
461         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
462     }
463 
464     /**
465      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
466      */
467     function _getAux(address owner) internal view returns (uint64) {
468         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
469     }
470 
471     /**
472      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
473      * If there are multiple variables, please pack them into a uint64.
474      */
475     function _setAux(address owner, uint64 aux) internal {
476         uint256 packed = _packedAddressData[owner];
477         uint256 auxCasted;
478         assembly { // Cast aux without masking.
479             auxCasted := aux
480         }
481         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
482         _packedAddressData[owner] = packed;
483     }
484 
485     /**
486      * Returns the packed ownership data of `tokenId`.
487      */
488     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
489         uint256 curr = tokenId;
490 
491         unchecked {
492             if (_startTokenId() <= curr)
493                 if (curr < _currentIndex) {
494                     uint256 packed = _packedOwnerships[curr];
495                     // If not burned.
496                     if (packed & BITMASK_BURNED == 0) {
497                         // Invariant:
498                         // There will always be an ownership that has an address and is not burned
499                         // before an ownership that does not have an address and is not burned.
500                         // Hence, curr will not underflow.
501                         //
502                         // We can directly compare the packed value.
503                         // If the address is zero, packed is zero.
504                         while (packed == 0) {
505                             packed = _packedOwnerships[--curr];
506                         }
507                         return packed;
508                     }
509                 }
510         }
511         revert OwnerQueryForNonexistentToken();
512     }
513 
514     /**
515      * Returns the unpacked `TokenOwnership` struct from `packed`.
516      */
517     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
518         ownership.addr = address(uint160(packed));
519         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
520         ownership.burned = packed & BITMASK_BURNED != 0;
521     }
522 
523     /**
524      * Returns the unpacked `TokenOwnership` struct at `index`.
525      */
526     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
527         return _unpackedOwnership(_packedOwnerships[index]);
528     }
529 
530     /**
531      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
532      */
533     function _initializeOwnershipAt(uint256 index) internal {
534         if (_packedOwnerships[index] == 0) {
535             _packedOwnerships[index] = _packedOwnershipOf(index);
536         }
537     }
538 
539     /**
540      * Gas spent here starts off proportional to the maximum mint batch size.
541      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
542      */
543     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
544         return _unpackedOwnership(_packedOwnershipOf(tokenId));
545     }
546 
547     /**
548      * @dev See {IERC721-ownerOf}.
549      */
550     function ownerOf(uint256 tokenId) public view override returns (address) {
551         return address(uint160(_packedOwnershipOf(tokenId)));
552     }
553 
554     /**
555      * @dev See {IERC721Metadata-name}.
556      */
557     function name() public view virtual override returns (string memory) {
558         return _name;
559     }
560 
561     /**
562      * @dev See {IERC721Metadata-symbol}.
563      */
564     function symbol() public view virtual override returns (string memory) {
565         return _symbol;
566     }
567 
568     /**
569      * @dev See {IERC721Metadata-tokenURI}.
570      */
571     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
572         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
573 
574         string memory baseURI = _baseURI();
575         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
576     }
577 
578     /**
579      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
580      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
581      * by default, can be overriden in child contracts.
582      */
583     function _baseURI() internal view virtual returns (string memory) {
584         return '';
585     }
586 
587     /**
588      * @dev Casts the address to uint256 without masking.
589      */
590     function _addressToUint256(address value) private pure returns (uint256 result) {
591         assembly {
592             result := value
593         }
594     }
595 
596     /**
597      * @dev Casts the boolean to uint256 without branching.
598      */
599     function _boolToUint256(bool value) private pure returns (uint256 result) {
600         assembly {
601             result := value
602         }
603     }
604 
605     /**
606      * @dev See {IERC721-approve}.
607      */
608     function approve(address to, uint256 tokenId) public override {
609         address owner = address(uint160(_packedOwnershipOf(tokenId)));
610         if (to == owner) revert ApprovalToCurrentOwner();
611 
612         if (_msgSenderERC721A() != owner)
613             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
614                 revert ApprovalCallerNotOwnerNorApproved();
615             }
616 
617         _tokenApprovals[tokenId] = to;
618         emit Approval(owner, to, tokenId);
619     }
620 
621     /**
622      * @dev See {IERC721-getApproved}.
623      */
624     function getApproved(uint256 tokenId) public view override returns (address) {
625         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
626 
627         return _tokenApprovals[tokenId];
628     }
629 
630     /**
631      * @dev See {IERC721-setApprovalForAll}.
632      */
633     function setApprovalForAll(address operator, bool approved) public virtual override {
634         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
635 
636         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
637         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
638     }
639 
640     /**
641      * @dev See {IERC721-isApprovedForAll}.
642      */
643     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
644         return _operatorApprovals[owner][operator];
645     }
646 
647     /**
648      * @dev See {IERC721-transferFrom}.
649      */
650     function transferFrom(
651         address from,
652         address to,
653         uint256 tokenId
654     ) public virtual override {
655         _transfer(from, to, tokenId);
656     }
657 
658     /**
659      * @dev See {IERC721-safeTransferFrom}.
660      */
661     function safeTransferFrom(
662         address from,
663         address to,
664         uint256 tokenId
665     ) public virtual override {
666         safeTransferFrom(from, to, tokenId, '');
667     }
668 
669     /**
670      * @dev See {IERC721-safeTransferFrom}.
671      */
672     function safeTransferFrom(
673         address from,
674         address to,
675         uint256 tokenId,
676         bytes memory _data
677     ) public virtual override {
678         _transfer(from, to, tokenId);
679         if (to.code.length != 0)
680             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
681                 revert TransferToNonERC721ReceiverImplementer();
682             }
683     }
684 
685     /**
686      * @dev Returns whether `tokenId` exists.
687      *
688      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
689      *
690      * Tokens start existing when they are minted (`_mint`),
691      */
692     function _exists(uint256 tokenId) internal view returns (bool) {
693         return
694             _startTokenId() <= tokenId &&
695             tokenId < _currentIndex && // If within bounds,
696             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
697     }
698 
699     /**
700      * @dev Equivalent to `_safeMint(to, quantity, '')`.
701      */
702     function _safeMint(address to, uint256 quantity) internal {
703         _safeMint(to, quantity, '');
704     }
705 
706     /**
707      * @dev Safely mints `quantity` tokens and transfers them to `to`.
708      *
709      * Requirements:
710      *
711      * - If `to` refers to a smart contract, it must implement
712      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
713      * - `quantity` must be greater than 0.
714      *
715      * Emits a {Transfer} event.
716      */
717     function _safeMint(
718         address to,
719         uint256 quantity,
720         bytes memory _data
721     ) internal {
722         uint256 startTokenId = _currentIndex;
723         if (to == address(0)) revert MintToZeroAddress();
724         if (quantity == 0) revert MintZeroQuantity();
725 
726         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
727 
728         // Overflows are incredibly unrealistic.
729         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
730         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
731         unchecked {
732             // Updates:
733             // - `balance += quantity`.
734             // - `numberMinted += quantity`.
735             //
736             // We can directly add to the balance and number minted.
737             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
738 
739             // Updates:
740             // - `address` to the owner.
741             // - `startTimestamp` to the timestamp of minting.
742             // - `burned` to `false`.
743             // - `nextInitialized` to `quantity == 1`.
744             _packedOwnerships[startTokenId] =
745                 _addressToUint256(to) |
746                 (block.timestamp << BITPOS_START_TIMESTAMP) |
747                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
748 
749             uint256 updatedIndex = startTokenId;
750             uint256 end = updatedIndex + quantity;
751 
752             if (to.code.length != 0) {
753                 do {
754                     emit Transfer(address(0), to, updatedIndex);
755                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
756                         revert TransferToNonERC721ReceiverImplementer();
757                     }
758                 } while (updatedIndex < end);
759                 // Reentrancy protection
760                 if (_currentIndex != startTokenId) revert();
761             } else {
762                 do {
763                     emit Transfer(address(0), to, updatedIndex++);
764                 } while (updatedIndex < end);
765             }
766             _currentIndex = updatedIndex;
767         }
768         _afterTokenTransfers(address(0), to, startTokenId, quantity);
769     }
770 
771     /**
772      * @dev Mints `quantity` tokens and transfers them to `to`.
773      *
774      * Requirements:
775      *
776      * - `to` cannot be the zero address.
777      * - `quantity` must be greater than 0.
778      *
779      * Emits a {Transfer} event.
780      */
781     function _mint(address to, uint256 quantity) internal {
782         uint256 startTokenId = _currentIndex;
783         if (to == address(0)) revert MintToZeroAddress();
784         if (quantity == 0) revert MintZeroQuantity();
785 
786         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
787 
788         // Overflows are incredibly unrealistic.
789         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
790         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
791         unchecked {
792             // Updates:
793             // - `balance += quantity`.
794             // - `numberMinted += quantity`.
795             //
796             // We can directly add to the balance and number minted.
797             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
798 
799             // Updates:
800             // - `address` to the owner.
801             // - `startTimestamp` to the timestamp of minting.
802             // - `burned` to `false`.
803             // - `nextInitialized` to `quantity == 1`.
804             _packedOwnerships[startTokenId] =
805                 _addressToUint256(to) |
806                 (block.timestamp << BITPOS_START_TIMESTAMP) |
807                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
808 
809             uint256 updatedIndex = startTokenId;
810             uint256 end = updatedIndex + quantity;
811 
812             do {
813                 emit Transfer(address(0), to, updatedIndex++);
814             } while (updatedIndex < end);
815 
816             _currentIndex = updatedIndex;
817         }
818         _afterTokenTransfers(address(0), to, startTokenId, quantity);
819     }
820 
821     /**
822      * @dev Transfers `tokenId` from `from` to `to`.
823      *
824      * Requirements:
825      *
826      * - `to` cannot be the zero address.
827      * - `tokenId` token must be owned by `from`.
828      *
829      * Emits a {Transfer} event.
830      */
831     function _transfer(
832         address from,
833         address to,
834         uint256 tokenId
835     ) private {
836         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
837 
838         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
839 
840         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
841             isApprovedForAll(from, _msgSenderERC721A()) ||
842             getApproved(tokenId) == _msgSenderERC721A());
843 
844         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
845         if (to == address(0)) revert TransferToZeroAddress();
846 
847         _beforeTokenTransfers(from, to, tokenId, 1);
848 
849         // Clear approvals from the previous owner.
850         delete _tokenApprovals[tokenId];
851 
852         // Underflow of the sender's balance is impossible because we check for
853         // ownership above and the recipient's balance can't realistically overflow.
854         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
855         unchecked {
856             // We can directly increment and decrement the balances.
857             --_packedAddressData[from]; // Updates: `balance -= 1`.
858             ++_packedAddressData[to]; // Updates: `balance += 1`.
859 
860             // Updates:
861             // - `address` to the next owner.
862             // - `startTimestamp` to the timestamp of transfering.
863             // - `burned` to `false`.
864             // - `nextInitialized` to `true`.
865             _packedOwnerships[tokenId] =
866                 _addressToUint256(to) |
867                 (block.timestamp << BITPOS_START_TIMESTAMP) |
868                 BITMASK_NEXT_INITIALIZED;
869 
870             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
871             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
872                 uint256 nextTokenId = tokenId + 1;
873                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
874                 if (_packedOwnerships[nextTokenId] == 0) {
875                     // If the next slot is within bounds.
876                     if (nextTokenId != _currentIndex) {
877                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
878                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
879                     }
880                 }
881             }
882         }
883 
884         emit Transfer(from, to, tokenId);
885         _afterTokenTransfers(from, to, tokenId, 1);
886     }
887 
888     /**
889      * @dev Equivalent to `_burn(tokenId, false)`.
890      */
891     function _burn(uint256 tokenId) internal virtual {
892         _burn(tokenId, false);
893     }
894 
895     /**
896      * @dev Destroys `tokenId`.
897      * The approval is cleared when the token is burned.
898      *
899      * Requirements:
900      *
901      * - `tokenId` must exist.
902      *
903      * Emits a {Transfer} event.
904      */
905     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
906         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
907 
908         address from = address(uint160(prevOwnershipPacked));
909 
910         if (approvalCheck) {
911             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
912                 isApprovedForAll(from, _msgSenderERC721A()) ||
913                 getApproved(tokenId) == _msgSenderERC721A());
914 
915             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
916         }
917 
918         _beforeTokenTransfers(from, address(0), tokenId, 1);
919 
920         // Clear approvals from the previous owner.
921         delete _tokenApprovals[tokenId];
922 
923         // Underflow of the sender's balance is impossible because we check for
924         // ownership above and the recipient's balance can't realistically overflow.
925         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
926         unchecked {
927             // Updates:
928             // - `balance -= 1`.
929             // - `numberBurned += 1`.
930             //
931             // We can directly decrement the balance, and increment the number burned.
932             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
933             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
934 
935             // Updates:
936             // - `address` to the last owner.
937             // - `startTimestamp` to the timestamp of burning.
938             // - `burned` to `true`.
939             // - `nextInitialized` to `true`.
940             _packedOwnerships[tokenId] =
941                 _addressToUint256(from) |
942                 (block.timestamp << BITPOS_START_TIMESTAMP) |
943                 BITMASK_BURNED | 
944                 BITMASK_NEXT_INITIALIZED;
945 
946             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
947             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
948                 uint256 nextTokenId = tokenId + 1;
949                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
950                 if (_packedOwnerships[nextTokenId] == 0) {
951                     // If the next slot is within bounds.
952                     if (nextTokenId != _currentIndex) {
953                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
954                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
955                     }
956                 }
957             }
958         }
959 
960         emit Transfer(from, address(0), tokenId);
961         _afterTokenTransfers(from, address(0), tokenId, 1);
962 
963         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
964         unchecked {
965             _burnCounter++;
966         }
967     }
968 
969     /**
970      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
971      *
972      * @param from address representing the previous owner of the given token ID
973      * @param to target address that will receive the tokens
974      * @param tokenId uint256 ID of the token to be transferred
975      * @param _data bytes optional data to send along with the call
976      * @return bool whether the call correctly returned the expected magic value
977      */
978     function _checkContractOnERC721Received(
979         address from,
980         address to,
981         uint256 tokenId,
982         bytes memory _data
983     ) private returns (bool) {
984         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
985             bytes4 retval
986         ) {
987             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
988         } catch (bytes memory reason) {
989             if (reason.length == 0) {
990                 revert TransferToNonERC721ReceiverImplementer();
991             } else {
992                 assembly {
993                     revert(add(32, reason), mload(reason))
994                 }
995             }
996         }
997     }
998 
999     /**
1000      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1001      * And also called before burning one token.
1002      *
1003      * startTokenId - the first token id to be transferred
1004      * quantity - the amount to be transferred
1005      *
1006      * Calling conditions:
1007      *
1008      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1009      * transferred to `to`.
1010      * - When `from` is zero, `tokenId` will be minted for `to`.
1011      * - When `to` is zero, `tokenId` will be burned by `from`.
1012      * - `from` and `to` are never both zero.
1013      */
1014     function _beforeTokenTransfers(
1015         address from,
1016         address to,
1017         uint256 startTokenId,
1018         uint256 quantity
1019     ) internal virtual {}
1020 
1021     /**
1022      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1023      * minting.
1024      * And also called after one token has been burned.
1025      *
1026      * startTokenId - the first token id to be transferred
1027      * quantity - the amount to be transferred
1028      *
1029      * Calling conditions:
1030      *
1031      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1032      * transferred to `to`.
1033      * - When `from` is zero, `tokenId` has been minted for `to`.
1034      * - When `to` is zero, `tokenId` has been burned by `from`.
1035      * - `from` and `to` are never both zero.
1036      */
1037     function _afterTokenTransfers(
1038         address from,
1039         address to,
1040         uint256 startTokenId,
1041         uint256 quantity
1042     ) internal virtual {}
1043 
1044     /**
1045      * @dev Returns the message sender (defaults to `msg.sender`).
1046      *
1047      * If you are writing GSN compatible contracts, you need to override this function.
1048      */
1049     function _msgSenderERC721A() internal view virtual returns (address) {
1050         return msg.sender;
1051     }
1052 
1053     /**
1054      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1055      */
1056     function _toString(uint256 value) internal pure returns (string memory ptr) {
1057         assembly {
1058             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1059             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1060             // We will need 1 32-byte word to store the length, 
1061             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1062             ptr := add(mload(0x40), 128)
1063             // Update the free memory pointer to allocate.
1064             mstore(0x40, ptr)
1065 
1066             // Cache the end of the memory to calculate the length later.
1067             let end := ptr
1068 
1069             // We write the string from the rightmost digit to the leftmost digit.
1070             // The following is essentially a do-while loop that also handles the zero case.
1071             // Costs a bit more than early returning for the zero case,
1072             // but cheaper in terms of deployment and overall runtime costs.
1073             for { 
1074                 // Initialize and perform the first pass without check.
1075                 let temp := value
1076                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1077                 ptr := sub(ptr, 1)
1078                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1079                 mstore8(ptr, add(48, mod(temp, 10)))
1080                 temp := div(temp, 10)
1081             } temp { 
1082                 // Keep dividing `temp` until zero.
1083                 temp := div(temp, 10)
1084             } { // Body of the for loop.
1085                 ptr := sub(ptr, 1)
1086                 mstore8(ptr, add(48, mod(temp, 10)))
1087             }
1088             
1089             let length := sub(end, ptr)
1090             // Move the pointer 32 bytes leftwards to make room for the length.
1091             ptr := sub(ptr, 32)
1092             // Store the length.
1093             mstore(ptr, length)
1094         }
1095     }
1096 }
1097 
1098 // File: erc721a/contracts/extensions/IERC721AQueryable.sol
1099 
1100 
1101 // ERC721A Contracts v4.1.0
1102 // Creator: Chiru Labs
1103 
1104 pragma solidity ^0.8.4;
1105 
1106 
1107 /**
1108  * @dev Interface of an ERC721AQueryable compliant contract.
1109  */
1110 interface IERC721AQueryable is IERC721A {
1111     /**
1112      * Invalid query range (`start` >= `stop`).
1113      */
1114     error InvalidQueryRange();
1115 
1116     /**
1117      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1118      *
1119      * If the `tokenId` is out of bounds:
1120      *   - `addr` = `address(0)`
1121      *   - `startTimestamp` = `0`
1122      *   - `burned` = `false`
1123      *
1124      * If the `tokenId` is burned:
1125      *   - `addr` = `<Address of owner before token was burned>`
1126      *   - `startTimestamp` = `<Timestamp when token was burned>`
1127      *   - `burned = `true`
1128      *
1129      * Otherwise:
1130      *   - `addr` = `<Address of owner>`
1131      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1132      *   - `burned = `false`
1133      */
1134     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
1135 
1136     /**
1137      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1138      * See {ERC721AQueryable-explicitOwnershipOf}
1139      */
1140     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
1141 
1142     /**
1143      * @dev Returns an array of token IDs owned by `owner`,
1144      * in the range [`start`, `stop`)
1145      * (i.e. `start <= tokenId < stop`).
1146      *
1147      * This function allows for tokens to be queried if the collection
1148      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1149      *
1150      * Requirements:
1151      *
1152      * - `start` < `stop`
1153      */
1154     function tokensOfOwnerIn(
1155         address owner,
1156         uint256 start,
1157         uint256 stop
1158     ) external view returns (uint256[] memory);
1159 
1160     /**
1161      * @dev Returns an array of token IDs owned by `owner`.
1162      *
1163      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1164      * It is meant to be called off-chain.
1165      *
1166      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1167      * multiple smaller scans if the collection is large enough to cause
1168      * an out-of-gas error (10K pfp collections should be fine).
1169      */
1170     function tokensOfOwner(address owner) external view returns (uint256[] memory);
1171 }
1172 
1173 // File: erc721a/contracts/extensions/ERC721AQueryable.sol
1174 
1175 
1176 // ERC721A Contracts v4.1.0
1177 // Creator: Chiru Labs
1178 
1179 pragma solidity ^0.8.4;
1180 
1181 
1182 
1183 /**
1184  * @title ERC721A Queryable
1185  * @dev ERC721A subclass with convenience query functions.
1186  */
1187 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1188     /**
1189      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1190      *
1191      * If the `tokenId` is out of bounds:
1192      *   - `addr` = `address(0)`
1193      *   - `startTimestamp` = `0`
1194      *   - `burned` = `false`
1195      *   - `extraData` = `0`
1196      *
1197      * If the `tokenId` is burned:
1198      *   - `addr` = `<Address of owner before token was burned>`
1199      *   - `startTimestamp` = `<Timestamp when token was burned>`
1200      *   - `burned = `true`
1201      *   - `extraData` = `<Extra data when token was burned>`
1202      *
1203      * Otherwise:
1204      *   - `addr` = `<Address of owner>`
1205      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1206      *   - `burned = `false`
1207      *   - `extraData` = `<Extra data at start of ownership>`
1208      */
1209     function explicitOwnershipOf(uint256 tokenId) public view override returns (TokenOwnership memory) {
1210         TokenOwnership memory ownership;
1211         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1212             return ownership;
1213         }
1214         ownership = _ownershipAt(tokenId);
1215         if (ownership.burned) {
1216             return ownership;
1217         }
1218         return _ownershipOf(tokenId);
1219     }
1220 
1221     /**
1222      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1223      * See {ERC721AQueryable-explicitOwnershipOf}
1224      */
1225     function explicitOwnershipsOf(uint256[] memory tokenIds) external view override returns (TokenOwnership[] memory) {
1226         unchecked {
1227             uint256 tokenIdsLength = tokenIds.length;
1228             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1229             for (uint256 i; i != tokenIdsLength; ++i) {
1230                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1231             }
1232             return ownerships;
1233         }
1234     }
1235 
1236     /**
1237      * @dev Returns an array of token IDs owned by `owner`,
1238      * in the range [`start`, `stop`)
1239      * (i.e. `start <= tokenId < stop`).
1240      *
1241      * This function allows for tokens to be queried if the collection
1242      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1243      *
1244      * Requirements:
1245      *
1246      * - `start` < `stop`
1247      */
1248     function tokensOfOwnerIn(
1249         address owner,
1250         uint256 start,
1251         uint256 stop
1252     ) external view override returns (uint256[] memory) {
1253         unchecked {
1254             if (start >= stop) revert InvalidQueryRange();
1255             uint256 tokenIdsIdx;
1256             uint256 stopLimit = _nextTokenId();
1257             // Set `start = max(start, _startTokenId())`.
1258             if (start < _startTokenId()) {
1259                 start = _startTokenId();
1260             }
1261             // Set `stop = min(stop, stopLimit)`.
1262             if (stop > stopLimit) {
1263                 stop = stopLimit;
1264             }
1265             uint256 tokenIdsMaxLength = balanceOf(owner);
1266             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1267             // to cater for cases where `balanceOf(owner)` is too big.
1268             if (start < stop) {
1269                 uint256 rangeLength = stop - start;
1270                 if (rangeLength < tokenIdsMaxLength) {
1271                     tokenIdsMaxLength = rangeLength;
1272                 }
1273             } else {
1274                 tokenIdsMaxLength = 0;
1275             }
1276             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1277             if (tokenIdsMaxLength == 0) {
1278                 return tokenIds;
1279             }
1280             // We need to call `explicitOwnershipOf(start)`,
1281             // because the slot at `start` may not be initialized.
1282             TokenOwnership memory ownership = explicitOwnershipOf(start);
1283             address currOwnershipAddr;
1284             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1285             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1286             if (!ownership.burned) {
1287                 currOwnershipAddr = ownership.addr;
1288             }
1289             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1290                 ownership = _ownershipAt(i);
1291                 if (ownership.burned) {
1292                     continue;
1293                 }
1294                 if (ownership.addr != address(0)) {
1295                     currOwnershipAddr = ownership.addr;
1296                 }
1297                 if (currOwnershipAddr == owner) {
1298                     tokenIds[tokenIdsIdx++] = i;
1299                 }
1300             }
1301             // Downsize the array to fit.
1302             assembly {
1303                 mstore(tokenIds, tokenIdsIdx)
1304             }
1305             return tokenIds;
1306         }
1307     }
1308 
1309     /**
1310      * @dev Returns an array of token IDs owned by `owner`.
1311      *
1312      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1313      * It is meant to be called off-chain.
1314      *
1315      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1316      * multiple smaller scans if the collection is large enough to cause
1317      * an out-of-gas error (10K pfp collections should be fine).
1318      */
1319     function tokensOfOwner(address owner) external view override returns (uint256[] memory) {
1320         unchecked {
1321             uint256 tokenIdsIdx;
1322             address currOwnershipAddr;
1323             uint256 tokenIdsLength = balanceOf(owner);
1324             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1325             TokenOwnership memory ownership;
1326             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1327                 ownership = _ownershipAt(i);
1328                 if (ownership.burned) {
1329                     continue;
1330                 }
1331                 if (ownership.addr != address(0)) {
1332                     currOwnershipAddr = ownership.addr;
1333                 }
1334                 if (currOwnershipAddr == owner) {
1335                     tokenIds[tokenIdsIdx++] = i;
1336                 }
1337             }
1338             return tokenIds;
1339         }
1340     }
1341 }
1342 
1343 // File: @openzeppelin/contracts/utils/Context.sol
1344 
1345 
1346 
1347 pragma solidity ^0.8.0;
1348 
1349 /**
1350  * @dev Provides information about the current execution context, including the
1351  * sender of the transaction and its data. While these are generally available
1352  * via msg.sender and msg.data, they should not be accessed in such a direct
1353  * manner, since when dealing with meta-transactions the account sending and
1354  * paying for execution may not be the actual sender (as far as an application
1355  * is concerned).
1356  *
1357  * This contract is only required for intermediate, library-like contracts.
1358  */
1359 abstract contract Context {
1360     function _msgSender() internal view virtual returns (address) {
1361         return msg.sender;
1362     }
1363 
1364     function _msgData() internal view virtual returns (bytes calldata) {
1365         return msg.data;
1366     }
1367 }
1368 
1369 // File: @openzeppelin/contracts/access/Ownable.sol
1370 
1371 
1372 
1373 pragma solidity ^0.8.0;
1374 
1375 
1376 /**
1377  * @dev Contract module which provides a basic access control mechanism, where
1378  * there is an account (an owner) that can be granted exclusive access to
1379  * specific functions.
1380  *
1381  * By default, the owner account will be the one that deploys the contract. This
1382  * can later be changed with {transferOwnership}.
1383  *
1384  * This module is used through inheritance. It will make available the modifier
1385  * `onlyOwner`, which can be applied to your functions to restrict their use to
1386  * the owner.
1387  */
1388 abstract contract Ownable is Context {
1389     address private _owner;
1390 
1391     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1392 
1393     /**
1394      * @dev Initializes the contract setting the deployer as the initial owner.
1395      */
1396     constructor() {
1397         _setOwner(_msgSender());
1398     }
1399 
1400     /**
1401      * @dev Returns the address of the current owner.
1402      */
1403     function owner() public view virtual returns (address) {
1404         return _owner;
1405     }
1406 
1407     /**
1408      * @dev Throws if called by any account other than the owner.
1409      */
1410     modifier onlyOwner() {
1411         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1412         _;
1413     }
1414 
1415     /**
1416      * @dev Leaves the contract without owner. It will not be possible to call
1417      * `onlyOwner` functions anymore. Can only be called by the current owner.
1418      *
1419      * NOTE: Renouncing ownership will leave the contract without an owner,
1420      * thereby removing any functionality that is only available to the owner.
1421      */
1422     function renounceOwnership() public virtual onlyOwner {
1423         _setOwner(address(0));
1424     }
1425 
1426     /**
1427      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1428      * Can only be called by the current owner.
1429      */
1430     function transferOwnership(address newOwner) public virtual onlyOwner {
1431         require(newOwner != address(0), "Ownable: new owner is the zero address");
1432         _setOwner(newOwner);
1433     }
1434 
1435     function _setOwner(address newOwner) private {
1436         address oldOwner = _owner;
1437         _owner = newOwner;
1438         emit OwnershipTransferred(oldOwner, newOwner);
1439     }
1440 }
1441 
1442 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
1443 
1444 
1445 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
1446 
1447 pragma solidity ^0.8.0;
1448 
1449 /**
1450  * @dev These functions deal with verification of Merkle Trees proofs.
1451  *
1452  * The proofs can be generated using the JavaScript library
1453  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1454  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1455  *
1456  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1457  *
1458  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1459  * hashing, or use a hash function other than keccak256 for hashing leaves.
1460  * This is because the concatenation of a sorted pair of internal nodes in
1461  * the merkle tree could be reinterpreted as a leaf value.
1462  */
1463 library MerkleProof {
1464     /**
1465      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1466      * defined by `root`. For this, a `proof` must be provided, containing
1467      * sibling hashes on the branch from the leaf to the root of the tree. Each
1468      * pair of leaves and each pair of pre-images are assumed to be sorted.
1469      */
1470     function verify(
1471         bytes32[] memory proof,
1472         bytes32 root,
1473         bytes32 leaf
1474     ) internal pure returns (bool) {
1475         return processProof(proof, leaf) == root;
1476     }
1477 
1478     /**
1479      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1480      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1481      * hash matches the root of the tree. When processing the proof, the pairs
1482      * of leafs & pre-images are assumed to be sorted.
1483      *
1484      * _Available since v4.4._
1485      */
1486     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1487         bytes32 computedHash = leaf;
1488         for (uint256 i = 0; i < proof.length; i++) {
1489             bytes32 proofElement = proof[i];
1490             if (computedHash <= proofElement) {
1491                 // Hash(current computed hash + current element of the proof)
1492                 computedHash = _efficientHash(computedHash, proofElement);
1493             } else {
1494                 // Hash(current element of the proof + current computed hash)
1495                 computedHash = _efficientHash(proofElement, computedHash);
1496             }
1497         }
1498         return computedHash;
1499     }
1500 
1501     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1502         assembly {
1503             mstore(0x00, a)
1504             mstore(0x20, b)
1505             value := keccak256(0x00, 0x40)
1506         }
1507     }
1508 }
1509 
1510 // File: contracts/fly.sol
1511                                             
1512 
1513 pragma solidity >=0.7.0 <0.9.0;
1514 
1515 
1516 
1517 
1518 
1519 contract Fly is ERC721AQueryable, Ownable {
1520     enum Status {
1521         Paused,
1522         Preminting,
1523         Started,
1524         Hatched
1525     }
1526 
1527     Status public status = Status.Paused;
1528     bytes32 public root;
1529     string public baseURI;
1530     string public eggURI;
1531     address public deliveryRoom;
1532     uint256 public constant MAX_MINT_PER_ADDR = 1;
1533     uint256 public constant MAX_PREMINT_PER_ADDR = 1;
1534     uint256 public constant teamSupply = 100;
1535     uint256 public constant genesisSupply = 2000;
1536     uint256 public constant maxSupply = 10000;
1537 
1538     event Minted(address minter, uint256 amount);
1539 
1540     modifier onlyMinter() {
1541         require(msg.sender == deliveryRoom, "FLY: Minter Only");
1542         _;
1543     }
1544 
1545 
1546     constructor(string memory initEggURI) ERC721A("DeadFlyWorld", "DeadFly"){
1547         eggURI = initEggURI;
1548     }
1549 
1550     function _startTokenId() internal view override returns (uint256) {
1551         return 1;
1552     }
1553 
1554     function _baseURI() internal view override returns (string memory) {
1555         return baseURI;
1556     }
1557 
1558     function tokenURI(uint256 tokenId)
1559         public
1560         view
1561         override
1562         returns (string memory)
1563     {
1564         if (status != Status.Hatched && tokenId > genesisSupply) {
1565             return eggURI;
1566         }
1567         return bytes(baseURI).length != 0
1568         ? string(abi.encodePacked(baseURI, _toString(tokenId), ".json"))
1569         : eggURI;
1570     }
1571 
1572     function mint() external payable {
1573         uint256 quantity = 1;
1574         require(status == Status.Started, "FLY: Not Started");
1575         require(tx.origin == msg.sender, "FLY: Human Only");
1576         require(
1577             numberMinted(msg.sender) + quantity <= MAX_MINT_PER_ADDR,
1578             "FLY: Too many flies for you"
1579         );
1580         require(
1581             totalSupply() + quantity <= genesisSupply,
1582             "FLY: Too many flies for everyone"
1583         );
1584         _safeMint(msg.sender, quantity);
1585         emit Minted(msg.sender, quantity);
1586     }
1587 
1588     function whitelistMint(bytes32[] memory _proof, uint256 quantity)
1589         external
1590         payable
1591     {
1592         require(status == Status.Preminting, "FLY: Preminting not started");
1593         require(tx.origin == msg.sender, "FLY: Human Only");
1594         require(_verify(_leaf(msg.sender), _proof), "FLY: Not whitelisted");
1595         require(
1596             numberMinted(msg.sender) + quantity <= MAX_PREMINT_PER_ADDR,
1597             "FLY: Too many flies for you"
1598         );
1599         require(
1600             totalSupply() + quantity <= genesisSupply,
1601             "FLY: Too many flies for everyone"
1602         );
1603         _safeMint(msg.sender, quantity);
1604         emit Minted(msg.sender, quantity);
1605     }
1606 
1607     function devMint(uint256 quantity) external payable onlyOwner {
1608         require(
1609             numberMinted(msg.sender) + quantity <= teamSupply,
1610             "FLY: Too many flies for you"
1611         );
1612         require(
1613             totalSupply() + quantity <= teamSupply,
1614             "FLY: Too many flies for everyone"
1615         );
1616         _safeMint(msg.sender, quantity);
1617         emit Minted(msg.sender, quantity);
1618     }
1619 
1620     function delivery(address receiver) public onlyMinter returns (uint256 tokenId) {
1621         uint256 quantity = 1;
1622         require(
1623             totalSupply() + quantity <= maxSupply,
1624             "FLY: Too many flies for everyone"
1625         );
1626         tokenId = _nextTokenId();
1627         _safeMint(receiver, quantity);
1628         emit Minted(receiver, quantity);
1629         return tokenId;
1630     }
1631 
1632     function numberMinted(address owner) public view returns (uint256) {
1633         return _numberMinted(owner);
1634     }
1635 
1636     function withdraw() public payable onlyOwner {
1637         payable(owner()).transfer(address(this).balance);
1638     }
1639 
1640     function setBaseURI(string calldata uri) public onlyOwner {
1641         baseURI = uri;
1642     }
1643 
1644     function setEggURI(string calldata uri) public onlyOwner {
1645         eggURI = uri;
1646     }
1647 
1648     function setStatus(Status newStatus) public onlyOwner {
1649         status = newStatus;
1650     }
1651 
1652     function setDeliveryRoom(address room) public onlyOwner {
1653         deliveryRoom = room;
1654     }
1655 
1656     function setRoot(uint256 _root) public onlyOwner {
1657         root = bytes32(_root);
1658     }
1659 
1660     function _leaf(address account) internal pure returns (bytes32) {
1661         return keccak256(abi.encodePacked(account));
1662     }
1663 
1664     function _verify(bytes32 leaf, bytes32[] memory proof)
1665         internal
1666         view
1667         returns (bool)
1668     {
1669         return MerkleProof.verify(proof, root, leaf);
1670     }
1671 }