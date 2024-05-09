1 //      .'(   )\.---.          /`-.      /`-.   )\.---.          /`-.    .')       .')                  
2 //  ,') \  ) (   ,-._(       ,' _  \   ,' _  \ (   ,-._(       ,' _  \  ( /       ( /                   
3 // (  /(/ /   \  '-,        (  '-' (  (  '-' (  \  '-,        (  '-' (   ))        ))                   
4 //  )    (     ) ,-`         )   _  )  ) ,_ .'   ) ,-`         )   _  )  )'._.-.   )'._.-.              
5 // (  .'\ \   (  ``-.       (  ,' ) \ (  ' ) \  (  ``-.       (  ,' ) \ (       ) (       )             
6 //  )/   )/    )..-.(        )/    )/  )/   )/   )..-.(        )/    )/  )/,__.'   )/,__.'              
7 //    )\.-.      .-./(  .'(   )\  )\     )\.-.        .-,.-.,-.    .-./(      .'(   )\     .-./(  .'(     )\.-.  
8 //  ,' ,-,_)   ,'     ) \  ) (  \, /   ,' ,-,_)       ) ,, ,. (  ,'     )     \  ) , /   ,'     ) \  )  ,'     ) 
9 // (  .   __  (  .-, (  ) (   ) \ (   (  .   __       \( |(  )/ (  .-, (      ) ( (  (  (  .-, (   ) (  (  .-, (  
10 //  ) '._\ _)  ) '._\ ) \  ) ( ( \ \   ) '._\ _)         ) \     ) '._\ )     \  ) \ \   ) '._\ ) \  )  ) '._\ ) 
11 // (  ,   (   (  ,   (   ) \  `.)/  ) (  ,   (           \ (    (  ,   (       ) \ /  ) (  ,   (   ) \ (  ,   (  
12 //  )/'._.'    )/ ._.'    )/     '.(   )/'._.'            )/     )/ ._.'        )/__.(   )/ ._.'    )/  )/ ._.'  
13 //                                                                                                     
14 // SPDX-License-Identifier: MIT
15 
16 // File: erc721a/contracts/IERC721A.sol
17 
18 
19 // ERC721A Contracts v4.0.0
20 // Creator: Chiru Labs
21 
22 pragma solidity ^0.8.4;
23 
24 /**
25  * @dev Interface of an ERC721A compliant contract.
26  */
27 interface IERC721A {
28     /**
29      * The caller must own the token or be an approved operator.
30      */
31     error ApprovalCallerNotOwnerNorApproved();
32 
33     /**
34      * The token does not exist.
35      */
36     error ApprovalQueryForNonexistentToken();
37 
38     /**
39      * The caller cannot approve to their own address.
40      */
41     error ApproveToCaller();
42 
43     /**
44      * The caller cannot approve to the current owner.
45      */
46     error ApprovalToCurrentOwner();
47 
48     /**
49      * Cannot query the balance for the zero address.
50      */
51     error BalanceQueryForZeroAddress();
52 
53     /**
54      * Cannot mint to the zero address.
55      */
56     error MintToZeroAddress();
57 
58     /**
59      * The quantity of tokens minted must be more than zero.
60      */
61     error MintZeroQuantity();
62 
63     /**
64      * The token does not exist.
65      */
66     error OwnerQueryForNonexistentToken();
67 
68     /**
69      * The caller must own the token or be an approved operator.
70      */
71     error TransferCallerNotOwnerNorApproved();
72 
73     /**
74      * The token must be owned by `from`.
75      */
76     error TransferFromIncorrectOwner();
77 
78     /**
79      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
80      */
81     error TransferToNonERC721ReceiverImplementer();
82 
83     /**
84      * Cannot transfer to the zero address.
85      */
86     error TransferToZeroAddress();
87 
88     /**
89      * The token does not exist.
90      */
91     error URIQueryForNonexistentToken();
92 
93     struct TokenOwnership {
94         // The address of the owner.
95         address addr;
96         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
97         uint64 startTimestamp;
98         // Whether the token has been burned.
99         bool burned;
100     }
101 
102     /**
103      * @dev Returns the total amount of tokens stored by the contract.
104      *
105      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
106      */
107     function totalSupply() external view returns (uint256);
108 
109     // ==============================
110     //            IERC165
111     // ==============================
112 
113     /**
114      * @dev Returns true if this contract implements the interface defined by
115      * `interfaceId`. See the corresponding
116      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
117      * to learn more about how these ids are created.
118      *
119      * This function call must use less than 30 000 gas.
120      */
121     function supportsInterface(bytes4 interfaceId) external view returns (bool);
122 
123     // ==============================
124     //            IERC721
125     // ==============================
126 
127     /**
128      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
129      */
130     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
131 
132     /**
133      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
134      */
135     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
136 
137     /**
138      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
139      */
140     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
141 
142     /**
143      * @dev Returns the number of tokens in ``owner``'s account.
144      */
145     function balanceOf(address owner) external view returns (uint256 balance);
146 
147     /**
148      * @dev Returns the owner of the `tokenId` token.
149      *
150      * Requirements:
151      *
152      * - `tokenId` must exist.
153      */
154     function ownerOf(uint256 tokenId) external view returns (address owner);
155 
156     /**
157      * @dev Safely transfers `tokenId` token from `from` to `to`.
158      *
159      * Requirements:
160      *
161      * - `from` cannot be the zero address.
162      * - `to` cannot be the zero address.
163      * - `tokenId` token must exist and be owned by `from`.
164      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
165      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
166      *
167      * Emits a {Transfer} event.
168      */
169     function safeTransferFrom(
170         address from,
171         address to,
172         uint256 tokenId,
173         bytes calldata data
174     ) external;
175 
176     /**
177      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
178      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
179      *
180      * Requirements:
181      *
182      * - `from` cannot be the zero address.
183      * - `to` cannot be the zero address.
184      * - `tokenId` token must exist and be owned by `from`.
185      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
186      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
187      *
188      * Emits a {Transfer} event.
189      */
190     function safeTransferFrom(
191         address from,
192         address to,
193         uint256 tokenId
194     ) external;
195 
196     /**
197      * @dev Transfers `tokenId` token from `from` to `to`.
198      *
199      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
200      *
201      * Requirements:
202      *
203      * - `from` cannot be the zero address.
204      * - `to` cannot be the zero address.
205      * - `tokenId` token must be owned by `from`.
206      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
207      *
208      * Emits a {Transfer} event.
209      */
210     function transferFrom(
211         address from,
212         address to,
213         uint256 tokenId
214     ) external;
215 
216     /**
217      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
218      * The approval is cleared when the token is transferred.
219      *
220      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
221      *
222      * Requirements:
223      *
224      * - The caller must own the token or be an approved operator.
225      * - `tokenId` must exist.
226      *
227      * Emits an {Approval} event.
228      */
229     function approve(address to, uint256 tokenId) external;
230 
231     /**
232      * @dev Approve or remove `operator` as an operator for the caller.
233      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
234      *
235      * Requirements:
236      *
237      * - The `operator` cannot be the caller.
238      *
239      * Emits an {ApprovalForAll} event.
240      */
241     function setApprovalForAll(address operator, bool _approved) external;
242 
243     /**
244      * @dev Returns the account approved for `tokenId` token.
245      *
246      * Requirements:
247      *
248      * - `tokenId` must exist.
249      */
250     function getApproved(uint256 tokenId) external view returns (address operator);
251 
252     /**
253      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
254      *
255      * See {setApprovalForAll}
256      */
257     function isApprovedForAll(address owner, address operator) external view returns (bool);
258 
259     // ==============================
260     //        IERC721Metadata
261     // ==============================
262 
263     /**
264      * @dev Returns the token collection name.
265      */
266     function name() external view returns (string memory);
267 
268     /**
269      * @dev Returns the token collection symbol.
270      */
271     function symbol() external view returns (string memory);
272 
273     /**
274      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
275      */
276     function tokenURI(uint256 tokenId) external view returns (string memory);
277 }
278 
279 // File: erc721a/contracts/ERC721A.sol
280 
281 
282 // ERC721A Contracts v4.0.0
283 // Creator: Chiru Labs
284 
285 pragma solidity ^0.8.4;
286 
287 
288 /**
289  * @dev ERC721 token receiver interface.
290  */
291 interface ERC721A__IERC721Receiver {
292     function onERC721Received(
293         address operator,
294         address from,
295         uint256 tokenId,
296         bytes calldata data
297     ) external returns (bytes4);
298 }
299 
300 /**
301  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
302  * the Metadata extension. Built to optimize for lower gas during batch mints.
303  *
304  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
305  *
306  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
307  *
308  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
309  */
310 contract ERC721A is IERC721A {
311     // Mask of an entry in packed address data.
312     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
313 
314     // The bit position of `numberMinted` in packed address data.
315     uint256 private constant BITPOS_NUMBER_MINTED = 64;
316 
317     // The bit position of `numberBurned` in packed address data.
318     uint256 private constant BITPOS_NUMBER_BURNED = 128;
319 
320     // The bit position of `aux` in packed address data.
321     uint256 private constant BITPOS_AUX = 192;
322 
323     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
324     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
325 
326     // The bit position of `startTimestamp` in packed ownership.
327     uint256 private constant BITPOS_START_TIMESTAMP = 160;
328 
329     // The bit mask of the `burned` bit in packed ownership.
330     uint256 private constant BITMASK_BURNED = 1 << 224;
331     
332     // The bit position of the `nextInitialized` bit in packed ownership.
333     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
334 
335     // The bit mask of the `nextInitialized` bit in packed ownership.
336     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
337 
338     // The tokenId of the next token to be minted.
339     uint256 private _currentIndex;
340 
341     // The number of tokens burned.
342     uint256 private _burnCounter;
343 
344     // Token name
345     string private _name;
346 
347     // Token symbol
348     string private _symbol;
349 
350     // Mapping from token ID to ownership details
351     // An empty struct value does not necessarily mean the token is unowned.
352     // See `_packedOwnershipOf` implementation for details.
353     //
354     // Bits Layout:
355     // - [0..159]   `addr`
356     // - [160..223] `startTimestamp`
357     // - [224]      `burned`
358     // - [225]      `nextInitialized`
359     mapping(uint256 => uint256) private _packedOwnerships;
360 
361     // Mapping owner address to address data.
362     //
363     // Bits Layout:
364     // - [0..63]    `balance`
365     // - [64..127]  `numberMinted`
366     // - [128..191] `numberBurned`
367     // - [192..255] `aux`
368     mapping(address => uint256) private _packedAddressData;
369 
370     // Mapping from token ID to approved address.
371     mapping(uint256 => address) private _tokenApprovals;
372 
373     // Mapping from owner to operator approvals
374     mapping(address => mapping(address => bool)) private _operatorApprovals;
375 
376     constructor(string memory name_, string memory symbol_) {
377         _name = name_;
378         _symbol = symbol_;
379         _currentIndex = _startTokenId();
380     }
381 
382     /**
383      * @dev Returns the starting token ID. 
384      * To change the starting token ID, please override this function.
385      */
386     function _startTokenId() internal view virtual returns (uint256) {
387         return 0;
388     }
389 
390     /**
391      * @dev Returns the next token ID to be minted.
392      */
393     function _nextTokenId() internal view returns (uint256) {
394         return _currentIndex;
395     }
396 
397     /**
398      * @dev Returns the total number of tokens in existence.
399      * Burned tokens will reduce the count. 
400      * To get the total number of tokens minted, please see `_totalMinted`.
401      */
402     function totalSupply() public view override returns (uint256) {
403         // Counter underflow is impossible as _burnCounter cannot be incremented
404         // more than `_currentIndex - _startTokenId()` times.
405         unchecked {
406             return _currentIndex - _burnCounter - _startTokenId();
407         }
408     }
409 
410     /**
411      * @dev Returns the total amount of tokens minted in the contract.
412      */
413     function _totalMinted() internal view returns (uint256) {
414         // Counter underflow is impossible as _currentIndex does not decrement,
415         // and it is initialized to `_startTokenId()`
416         unchecked {
417             return _currentIndex - _startTokenId();
418         }
419     }
420 
421     /**
422      * @dev Returns the total number of tokens burned.
423      */
424     function _totalBurned() internal view returns (uint256) {
425         return _burnCounter;
426     }
427 
428     /**
429      * @dev See {IERC165-supportsInterface}.
430      */
431     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
432         // The interface IDs are constants representing the first 4 bytes of the XOR of
433         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
434         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
435         return
436             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
437             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
438             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
439     }
440 
441     /**
442      * @dev See {IERC721-balanceOf}.
443      */
444     function balanceOf(address owner) public view override returns (uint256) {
445         if (owner == address(0)) revert BalanceQueryForZeroAddress();
446         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
447     }
448 
449     /**
450      * Returns the number of tokens minted by `owner`.
451      */
452     function _numberMinted(address owner) internal view returns (uint256) {
453         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
454     }
455 
456     /**
457      * Returns the number of tokens burned by or on behalf of `owner`.
458      */
459     function _numberBurned(address owner) internal view returns (uint256) {
460         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
461     }
462 
463     /**
464      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
465      */
466     function _getAux(address owner) internal view returns (uint64) {
467         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
468     }
469 
470     /**
471      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
472      * If there are multiple variables, please pack them into a uint64.
473      */
474     function _setAux(address owner, uint64 aux) internal {
475         uint256 packed = _packedAddressData[owner];
476         uint256 auxCasted;
477         assembly { // Cast aux without masking.
478             auxCasted := aux
479         }
480         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
481         _packedAddressData[owner] = packed;
482     }
483 
484     /**
485      * Returns the packed ownership data of `tokenId`.
486      */
487     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
488         uint256 curr = tokenId;
489 
490         unchecked {
491             if (_startTokenId() <= curr)
492                 if (curr < _currentIndex) {
493                     uint256 packed = _packedOwnerships[curr];
494                     // If not burned.
495                     if (packed & BITMASK_BURNED == 0) {
496                         // Invariant:
497                         // There will always be an ownership that has an address and is not burned
498                         // before an ownership that does not have an address and is not burned.
499                         // Hence, curr will not underflow.
500                         //
501                         // We can directly compare the packed value.
502                         // If the address is zero, packed is zero.
503                         while (packed == 0) {
504                             packed = _packedOwnerships[--curr];
505                         }
506                         return packed;
507                     }
508                 }
509         }
510         revert OwnerQueryForNonexistentToken();
511     }
512 
513     /**
514      * Returns the unpacked `TokenOwnership` struct from `packed`.
515      */
516     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
517         ownership.addr = address(uint160(packed));
518         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
519         ownership.burned = packed & BITMASK_BURNED != 0;
520     }
521 
522     /**
523      * Returns the unpacked `TokenOwnership` struct at `index`.
524      */
525     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
526         return _unpackedOwnership(_packedOwnerships[index]);
527     }
528 
529     /**
530      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
531      */
532     function _initializeOwnershipAt(uint256 index) internal {
533         if (_packedOwnerships[index] == 0) {
534             _packedOwnerships[index] = _packedOwnershipOf(index);
535         }
536     }
537 
538     /**
539      * Gas spent here starts off proportional to the maximum mint batch size.
540      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
541      */
542     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
543         return _unpackedOwnership(_packedOwnershipOf(tokenId));
544     }
545 
546     /**
547      * @dev See {IERC721-ownerOf}.
548      */
549     function ownerOf(uint256 tokenId) public view override returns (address) {
550         return address(uint160(_packedOwnershipOf(tokenId)));
551     }
552 
553     /**
554      * @dev See {IERC721Metadata-name}.
555      */
556     function name() public view virtual override returns (string memory) {
557         return _name;
558     }
559 
560     /**
561      * @dev See {IERC721Metadata-symbol}.
562      */
563     function symbol() public view virtual override returns (string memory) {
564         return _symbol;
565     }
566 
567     /**
568      * @dev See {IERC721Metadata-tokenURI}.
569      */
570     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
571         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
572 
573         string memory baseURI = _baseURI();
574         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
575     }
576 
577     /**
578      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
579      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
580      * by default, can be overriden in child contracts.
581      */
582     function _baseURI() internal view virtual returns (string memory) {
583         return '';
584     }
585 
586     /**
587      * @dev Casts the address to uint256 without masking.
588      */
589     function _addressToUint256(address value) private pure returns (uint256 result) {
590         assembly {
591             result := value
592         }
593     }
594 
595     /**
596      * @dev Casts the boolean to uint256 without branching.
597      */
598     function _boolToUint256(bool value) private pure returns (uint256 result) {
599         assembly {
600             result := value
601         }
602     }
603 
604     /**
605      * @dev See {IERC721-approve}.
606      */
607     function approve(address to, uint256 tokenId) public override {
608         address owner = address(uint160(_packedOwnershipOf(tokenId)));
609         if (to == owner) revert ApprovalToCurrentOwner();
610 
611         if (_msgSenderERC721A() != owner)
612             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
613                 revert ApprovalCallerNotOwnerNorApproved();
614             }
615 
616         _tokenApprovals[tokenId] = to;
617         emit Approval(owner, to, tokenId);
618     }
619 
620     /**
621      * @dev See {IERC721-getApproved}.
622      */
623     function getApproved(uint256 tokenId) public view override returns (address) {
624         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
625 
626         return _tokenApprovals[tokenId];
627     }
628 
629     /**
630      * @dev See {IERC721-setApprovalForAll}.
631      */
632     function setApprovalForAll(address operator, bool approved) public virtual override {
633         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
634 
635         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
636         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
637     }
638 
639     /**
640      * @dev See {IERC721-isApprovedForAll}.
641      */
642     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
643         return _operatorApprovals[owner][operator];
644     }
645 
646     /**
647      * @dev See {IERC721-transferFrom}.
648      */
649     function transferFrom(
650         address from,
651         address to,
652         uint256 tokenId
653     ) public virtual override {
654         _transfer(from, to, tokenId);
655     }
656 
657     /**
658      * @dev See {IERC721-safeTransferFrom}.
659      */
660     function safeTransferFrom(
661         address from,
662         address to,
663         uint256 tokenId
664     ) public virtual override {
665         safeTransferFrom(from, to, tokenId, '');
666     }
667 
668     /**
669      * @dev See {IERC721-safeTransferFrom}.
670      */
671     function safeTransferFrom(
672         address from,
673         address to,
674         uint256 tokenId,
675         bytes memory _data
676     ) public virtual override {
677         _transfer(from, to, tokenId);
678         if (to.code.length != 0)
679             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
680                 revert TransferToNonERC721ReceiverImplementer();
681             }
682     }
683 
684     /**
685      * @dev Returns whether `tokenId` exists.
686      *
687      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
688      *
689      * Tokens start existing when they are minted (`_mint`),
690      */
691     function _exists(uint256 tokenId) internal view returns (bool) {
692         return
693             _startTokenId() <= tokenId &&
694             tokenId < _currentIndex && // If within bounds,
695             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
696     }
697 
698     /**
699      * @dev Equivalent to `_safeMint(to, quantity, '')`.
700      */
701     function _safeMint(address to, uint256 quantity) internal {
702         _safeMint(to, quantity, '');
703     }
704 
705     /**
706      * @dev Safely mints `quantity` tokens and transfers them to `to`.
707      *
708      * Requirements:
709      *
710      * - If `to` refers to a smart contract, it must implement
711      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
712      * - `quantity` must be greater than 0.
713      *
714      * Emits a {Transfer} event.
715      */
716     function _safeMint(
717         address to,
718         uint256 quantity,
719         bytes memory _data
720     ) internal {
721         uint256 startTokenId = _currentIndex;
722         if (to == address(0)) revert MintToZeroAddress();
723         if (quantity == 0) revert MintZeroQuantity();
724 
725         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
726 
727         // Overflows are incredibly unrealistic.
728         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
729         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
730         unchecked {
731             // Updates:
732             // - `balance += quantity`.
733             // - `numberMinted += quantity`.
734             //
735             // We can directly add to the balance and number minted.
736             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
737 
738             // Updates:
739             // - `address` to the owner.
740             // - `startTimestamp` to the timestamp of minting.
741             // - `burned` to `false`.
742             // - `nextInitialized` to `quantity == 1`.
743             _packedOwnerships[startTokenId] =
744                 _addressToUint256(to) |
745                 (block.timestamp << BITPOS_START_TIMESTAMP) |
746                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
747 
748             uint256 updatedIndex = startTokenId;
749             uint256 end = updatedIndex + quantity;
750 
751             if (to.code.length != 0) {
752                 do {
753                     emit Transfer(address(0), to, updatedIndex);
754                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
755                         revert TransferToNonERC721ReceiverImplementer();
756                     }
757                 } while (updatedIndex < end);
758                 // Reentrancy protection
759                 if (_currentIndex != startTokenId) revert();
760             } else {
761                 do {
762                     emit Transfer(address(0), to, updatedIndex++);
763                 } while (updatedIndex < end);
764             }
765             _currentIndex = updatedIndex;
766         }
767         _afterTokenTransfers(address(0), to, startTokenId, quantity);
768     }
769 
770     /**
771      * @dev Mints `quantity` tokens and transfers them to `to`.
772      *
773      * Requirements:
774      *
775      * - `to` cannot be the zero address.
776      * - `quantity` must be greater than 0.
777      *
778      * Emits a {Transfer} event.
779      */
780     function _mint(address to, uint256 quantity) internal {
781         uint256 startTokenId = _currentIndex;
782         if (to == address(0)) revert MintToZeroAddress();
783         if (quantity == 0) revert MintZeroQuantity();
784 
785         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
786 
787         // Overflows are incredibly unrealistic.
788         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
789         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
790         unchecked {
791             // Updates:
792             // - `balance += quantity`.
793             // - `numberMinted += quantity`.
794             //
795             // We can directly add to the balance and number minted.
796             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
797 
798             // Updates:
799             // - `address` to the owner.
800             // - `startTimestamp` to the timestamp of minting.
801             // - `burned` to `false`.
802             // - `nextInitialized` to `quantity == 1`.
803             _packedOwnerships[startTokenId] =
804                 _addressToUint256(to) |
805                 (block.timestamp << BITPOS_START_TIMESTAMP) |
806                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
807 
808             uint256 updatedIndex = startTokenId;
809             uint256 end = updatedIndex + quantity;
810 
811             do {
812                 emit Transfer(address(0), to, updatedIndex++);
813             } while (updatedIndex < end);
814 
815             _currentIndex = updatedIndex;
816         }
817         _afterTokenTransfers(address(0), to, startTokenId, quantity);
818     }
819 
820     /**
821      * @dev Transfers `tokenId` from `from` to `to`.
822      *
823      * Requirements:
824      *
825      * - `to` cannot be the zero address.
826      * - `tokenId` token must be owned by `from`.
827      *
828      * Emits a {Transfer} event.
829      */
830     function _transfer(
831         address from,
832         address to,
833         uint256 tokenId
834     ) private {
835         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
836 
837         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
838 
839         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
840             isApprovedForAll(from, _msgSenderERC721A()) ||
841             getApproved(tokenId) == _msgSenderERC721A());
842 
843         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
844         if (to == address(0)) revert TransferToZeroAddress();
845 
846         _beforeTokenTransfers(from, to, tokenId, 1);
847 
848         // Clear approvals from the previous owner.
849         delete _tokenApprovals[tokenId];
850 
851         // Underflow of the sender's balance is impossible because we check for
852         // ownership above and the recipient's balance can't realistically overflow.
853         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
854         unchecked {
855             // We can directly increment and decrement the balances.
856             --_packedAddressData[from]; // Updates: `balance -= 1`.
857             ++_packedAddressData[to]; // Updates: `balance += 1`.
858 
859             // Updates:
860             // - `address` to the next owner.
861             // - `startTimestamp` to the timestamp of transfering.
862             // - `burned` to `false`.
863             // - `nextInitialized` to `true`.
864             _packedOwnerships[tokenId] =
865                 _addressToUint256(to) |
866                 (block.timestamp << BITPOS_START_TIMESTAMP) |
867                 BITMASK_NEXT_INITIALIZED;
868 
869             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
870             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
871                 uint256 nextTokenId = tokenId + 1;
872                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
873                 if (_packedOwnerships[nextTokenId] == 0) {
874                     // If the next slot is within bounds.
875                     if (nextTokenId != _currentIndex) {
876                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
877                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
878                     }
879                 }
880             }
881         }
882 
883         emit Transfer(from, to, tokenId);
884         _afterTokenTransfers(from, to, tokenId, 1);
885     }
886 
887     /**
888      * @dev Equivalent to `_burn(tokenId, false)`.
889      */
890     function _burn(uint256 tokenId) internal virtual {
891         _burn(tokenId, false);
892     }
893 
894     /**
895      * @dev Destroys `tokenId`.
896      * The approval is cleared when the token is burned.
897      *
898      * Requirements:
899      *
900      * - `tokenId` must exist.
901      *
902      * Emits a {Transfer} event.
903      */
904     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
905         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
906 
907         address from = address(uint160(prevOwnershipPacked));
908 
909         if (approvalCheck) {
910             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
911                 isApprovedForAll(from, _msgSenderERC721A()) ||
912                 getApproved(tokenId) == _msgSenderERC721A());
913 
914             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
915         }
916 
917         _beforeTokenTransfers(from, address(0), tokenId, 1);
918 
919         // Clear approvals from the previous owner.
920         delete _tokenApprovals[tokenId];
921 
922         // Underflow of the sender's balance is impossible because we check for
923         // ownership above and the recipient's balance can't realistically overflow.
924         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
925         unchecked {
926             // Updates:
927             // - `balance -= 1`.
928             // - `numberBurned += 1`.
929             //
930             // We can directly decrement the balance, and increment the number burned.
931             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
932             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
933 
934             // Updates:
935             // - `address` to the last owner.
936             // - `startTimestamp` to the timestamp of burning.
937             // - `burned` to `true`.
938             // - `nextInitialized` to `true`.
939             _packedOwnerships[tokenId] =
940                 _addressToUint256(from) |
941                 (block.timestamp << BITPOS_START_TIMESTAMP) |
942                 BITMASK_BURNED | 
943                 BITMASK_NEXT_INITIALIZED;
944 
945             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
946             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
947                 uint256 nextTokenId = tokenId + 1;
948                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
949                 if (_packedOwnerships[nextTokenId] == 0) {
950                     // If the next slot is within bounds.
951                     if (nextTokenId != _currentIndex) {
952                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
953                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
954                     }
955                 }
956             }
957         }
958 
959         emit Transfer(from, address(0), tokenId);
960         _afterTokenTransfers(from, address(0), tokenId, 1);
961 
962         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
963         unchecked {
964             _burnCounter++;
965         }
966     }
967 
968     /**
969      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
970      *
971      * @param from address representing the previous owner of the given token ID
972      * @param to target address that will receive the tokens
973      * @param tokenId uint256 ID of the token to be transferred
974      * @param _data bytes optional data to send along with the call
975      * @return bool whether the call correctly returned the expected magic value
976      */
977     function _checkContractOnERC721Received(
978         address from,
979         address to,
980         uint256 tokenId,
981         bytes memory _data
982     ) private returns (bool) {
983         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
984             bytes4 retval
985         ) {
986             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
987         } catch (bytes memory reason) {
988             if (reason.length == 0) {
989                 revert TransferToNonERC721ReceiverImplementer();
990             } else {
991                 assembly {
992                     revert(add(32, reason), mload(reason))
993                 }
994             }
995         }
996     }
997 
998     /**
999      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1000      * And also called before burning one token.
1001      *
1002      * startTokenId - the first token id to be transferred
1003      * quantity - the amount to be transferred
1004      *
1005      * Calling conditions:
1006      *
1007      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1008      * transferred to `to`.
1009      * - When `from` is zero, `tokenId` will be minted for `to`.
1010      * - When `to` is zero, `tokenId` will be burned by `from`.
1011      * - `from` and `to` are never both zero.
1012      */
1013     function _beforeTokenTransfers(
1014         address from,
1015         address to,
1016         uint256 startTokenId,
1017         uint256 quantity
1018     ) internal virtual {}
1019 
1020     /**
1021      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1022      * minting.
1023      * And also called after one token has been burned.
1024      *
1025      * startTokenId - the first token id to be transferred
1026      * quantity - the amount to be transferred
1027      *
1028      * Calling conditions:
1029      *
1030      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1031      * transferred to `to`.
1032      * - When `from` is zero, `tokenId` has been minted for `to`.
1033      * - When `to` is zero, `tokenId` has been burned by `from`.
1034      * - `from` and `to` are never both zero.
1035      */
1036     function _afterTokenTransfers(
1037         address from,
1038         address to,
1039         uint256 startTokenId,
1040         uint256 quantity
1041     ) internal virtual {}
1042 
1043     /**
1044      * @dev Returns the message sender (defaults to `msg.sender`).
1045      *
1046      * If you are writing GSN compatible contracts, you need to override this function.
1047      */
1048     function _msgSenderERC721A() internal view virtual returns (address) {
1049         return msg.sender;
1050     }
1051 
1052     /**
1053      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1054      */
1055     function _toString(uint256 value) internal pure returns (string memory ptr) {
1056         assembly {
1057             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1058             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1059             // We will need 1 32-byte word to store the length, 
1060             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1061             ptr := add(mload(0x40), 128)
1062             // Update the free memory pointer to allocate.
1063             mstore(0x40, ptr)
1064 
1065             // Cache the end of the memory to calculate the length later.
1066             let end := ptr
1067 
1068             // We write the string from the rightmost digit to the leftmost digit.
1069             // The following is essentially a do-while loop that also handles the zero case.
1070             // Costs a bit more than early returning for the zero case,
1071             // but cheaper in terms of deployment and overall runtime costs.
1072             for { 
1073                 // Initialize and perform the first pass without check.
1074                 let temp := value
1075                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1076                 ptr := sub(ptr, 1)
1077                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1078                 mstore8(ptr, add(48, mod(temp, 10)))
1079                 temp := div(temp, 10)
1080             } temp { 
1081                 // Keep dividing `temp` until zero.
1082                 temp := div(temp, 10)
1083             } { // Body of the for loop.
1084                 ptr := sub(ptr, 1)
1085                 mstore8(ptr, add(48, mod(temp, 10)))
1086             }
1087             
1088             let length := sub(end, ptr)
1089             // Move the pointer 32 bytes leftwards to make room for the length.
1090             ptr := sub(ptr, 32)
1091             // Store the length.
1092             mstore(ptr, length)
1093         }
1094     }
1095 }
1096 
1097 // File: @openzeppelin/contracts/utils/Context.sol
1098 
1099 
1100 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1101 
1102 pragma solidity ^0.8.0;
1103 
1104 /**
1105  * @dev Provides information about the current execution context, including the
1106  * sender of the transaction and its data. While these are generally available
1107  * via msg.sender and msg.data, they should not be accessed in such a direct
1108  * manner, since when dealing with meta-transactions the account sending and
1109  * paying for execution may not be the actual sender (as far as an application
1110  * is concerned).
1111  *
1112  * This contract is only required for intermediate, library-like contracts.
1113  */
1114 abstract contract Context {
1115     function _msgSender() internal view virtual returns (address) {
1116         return msg.sender;
1117     }
1118 
1119     function _msgData() internal view virtual returns (bytes calldata) {
1120         return msg.data;
1121     }
1122 }
1123 
1124 // File: @openzeppelin/contracts/access/Ownable.sol
1125 
1126 
1127 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1128 
1129 pragma solidity ^0.8.0;
1130 
1131 
1132 /**
1133  * @dev Contract module which provides a basic access control mechanism, where
1134  * there is an account (an owner) that can be granted exclusive access to
1135  * specific functions.
1136  *
1137  * By default, the owner account will be the one that deploys the contract. This
1138  * can later be changed with {transferOwnership}.
1139  *
1140  * This module is used through inheritance. It will make available the modifier
1141  * `onlyOwner`, which can be applied to your functions to restrict their use to
1142  * the owner.
1143  */
1144 abstract contract Ownable is Context {
1145     address private _owner;
1146 
1147     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1148 
1149     /**
1150      * @dev Initializes the contract setting the deployer as the initial owner.
1151      */
1152     constructor() {
1153         _transferOwnership(_msgSender());
1154     }
1155 
1156     /**
1157      * @dev Returns the address of the current owner.
1158      */
1159     function owner() public view virtual returns (address) {
1160         return _owner;
1161     }
1162 
1163     /**
1164      * @dev Throws if called by any account other than the owner.
1165      */
1166     modifier onlyOwner() {
1167         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1168         _;
1169     }
1170 
1171     /**
1172      * @dev Leaves the contract without owner. It will not be possible to call
1173      * `onlyOwner` functions anymore. Can only be called by the current owner.
1174      *
1175      * NOTE: Renouncing ownership will leave the contract without an owner,
1176      * thereby removing any functionality that is only available to the owner.
1177      */
1178     function renounceOwnership() public virtual onlyOwner {
1179         _transferOwnership(address(0));
1180     }
1181 
1182     /**
1183      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1184      * Can only be called by the current owner.
1185      */
1186     function transferOwnership(address newOwner) public virtual onlyOwner {
1187         require(newOwner != address(0), "Ownable: new owner is the zero address");
1188         _transferOwnership(newOwner);
1189     }
1190 
1191     /**
1192      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1193      * Internal function without access restriction.
1194      */
1195     function _transferOwnership(address newOwner) internal virtual {
1196         address oldOwner = _owner;
1197         _owner = newOwner;
1198         emit OwnershipTransferred(oldOwner, newOwner);
1199     }
1200 }
1201 
1202 // File: contracts/WAGV.sol
1203 
1204 //      .'(   )\.---.          /`-.      /`-.   )\.---.          /`-.    .')       .')                  
1205 //  ,') \  ) (   ,-._(       ,' _  \   ,' _  \ (   ,-._(       ,' _  \  ( /       ( /                   
1206 // (  /(/ /   \  '-,        (  '-' (  (  '-' (  \  '-,        (  '-' (   ))        ))                   
1207 //  )    (     ) ,-`         )   _  )  ) ,_ .'   ) ,-`         )   _  )  )'._.-.   )'._.-.              
1208 // (  .'\ \   (  ``-.       (  ,' ) \ (  ' ) \  (  ``-.       (  ,' ) \ (       ) (       )             
1209 //  )/   )/    )..-.(        )/    )/  )/   )/   )..-.(        )/    )/  )/,__.'   )/,__.'              
1210 //    )\.-.      .-./(  .'(   )\  )\     )\.-.        .-,.-.,-.    .-./(      .'(   )\     .-./(  .'(     )\.-.  
1211 //  ,' ,-,_)   ,'     ) \  ) (  \, /   ,' ,-,_)       ) ,, ,. (  ,'     )     \  ) , /   ,'     ) \  )  ,'     ) 
1212 // (  .   __  (  .-, (  ) (   ) \ (   (  .   __       \( |(  )/ (  .-, (      ) ( (  (  (  .-, (   ) (  (  .-, (  
1213 //  ) '._\ _)  ) '._\ ) \  ) ( ( \ \   ) '._\ _)         ) \     ) '._\ )     \  ) \ \   ) '._\ ) \  )  ) '._\ ) 
1214 // (  ,   (   (  ,   (   ) \  `.)/  ) (  ,   (           \ (    (  ,   (       ) \ /  ) (  ,   (   ) \ (  ,   (  
1215 //  )/'._.'    )/ ._.'    )/     '.(   )/'._.'            )/     )/ ._.'        )/__.(   )/ ._.'    )/  )/ ._.'  
1216 //                                                                                                     
1217 
1218 
1219 pragma solidity 0.8.7;
1220 
1221 
1222 
1223 contract WAGV is ERC721A, Ownable {
1224   // "Private" Variables
1225   address private teamAddress = 0xadA438cd70aa1a8A3f386f51E1B8851cAf62eB17;
1226   string private baseURI;
1227   string private notRevealedUri = "ipfs://QmaaoYY9izE2FpPv4otHHMgoZeD2A1du9aJS56ERLjGzQh/";
1228   string private baseExtension = ".json";
1229 
1230   // Public Variables
1231   bool public started = true;
1232   bool public claimed = false;
1233   bool public revealed = false;
1234   uint256 public constant MAX_SUPPLY = 6666;
1235   uint256 public constant FREE_SUPPLY = 666;
1236   uint256 public maxMint = 2;
1237   uint256 public constant TEAM_CLAIM_AMOUNT = 55;
1238   uint256 public mintPrice = 0.0066 ether;
1239 
1240   constructor() ERC721A("We Are All Going To Void", "WAGV") {}
1241 
1242   // Start tokenid at 1 instead of 0
1243   function _startTokenId() internal view virtual override returns (uint256) {
1244       return 1;
1245   }
1246 
1247   function mint(uint256 tokenQuantity) external payable {
1248     require(started, "The pilgrimage to this land has not yet started");
1249     require(balanceOf(_msgSender()) + tokenQuantity <= maxMint, "You have already received your Token of Worship");
1250     if (totalSupply() >= FREE_SUPPLY) {
1251         require(tokenQuantity * mintPrice <= msg.value, "Not enough ether sent");
1252     } else if (totalSupply() + tokenQuantity >= FREE_SUPPLY) {
1253         require((tokenQuantity - (FREE_SUPPLY - totalSupply())) * mintPrice <= msg.value, "Not enough ether sent");
1254     }
1255     require(totalSupply() + tokenQuantity <= MAX_SUPPLY, "All lost souls have been accounted for");
1256     // mint
1257     _safeMint(msg.sender, tokenQuantity);
1258   }
1259 
1260   function teamClaim() external onlyOwner {
1261     require(!claimed, "Team already claimed");
1262     // claim
1263     if (teamAddress == address(0)) revert MintToZeroAddress();
1264     _safeMint(teamAddress, TEAM_CLAIM_AMOUNT);
1265     claimed = true;
1266   }
1267 
1268   function _baseURI() internal view virtual override returns (string memory) {
1269       return baseURI;
1270   }
1271 
1272   function enableMint(bool mintStarted) external onlyOwner {
1273       started = mintStarted;
1274   }
1275 
1276   function setTeamAddress(address teamAddress_) external onlyOwner {
1277     teamAddress = teamAddress_;
1278   }
1279 
1280   function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1281     if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1282 
1283     if (revealed == false) {
1284         return bytes(notRevealedUri).length != 0 ? string(abi.encodePacked(notRevealedUri, _toString(tokenId), baseExtension)) : '';
1285     }
1286     
1287     return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId), baseExtension)) : '';
1288   }
1289 
1290   function flipReveal() external onlyOwner {
1291       revealed = !revealed;
1292   }
1293 
1294   function setNotRevealedURI(string memory notRevealedURI_) external onlyOwner {
1295       notRevealedUri = notRevealedURI_;
1296   }
1297 
1298   function setMintPrice(uint256 mintPrice_) external onlyOwner {
1299     mintPrice = mintPrice_;
1300   }
1301 
1302   function setBaseURI(string memory baseURI_) external onlyOwner {
1303       baseURI = baseURI_;
1304   }
1305 
1306   function setBaseExtension(string memory newBaseExtension_) external onlyOwner
1307   {
1308       baseExtension = newBaseExtension_;
1309   }
1310 
1311   function withdraw(address to) external onlyOwner {
1312       uint256 balance = address(this).balance;
1313       payable(to).transfer(balance);
1314   }
1315 }