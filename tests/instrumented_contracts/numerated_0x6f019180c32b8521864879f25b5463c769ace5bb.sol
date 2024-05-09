1 // File: ODYC.sol
2 
3 /**
4  *Submitted for verification at Etherscan.io on 2022-05-26
5 */
6 
7 
8 //╭━━━┳╮╱╱╱╱╱╱╱╱╱╭━━━╮╱╱╱╱╱╱╱╱╱╭╮╱╱╭╮╱╱╱╱╭╮╱╭╮╱╭━━━┳╮╱╱╱╭╮
9 //┃╭━╮┃┃╱╱╱╱╱╱╱╱╱╰╮╭╮┃╱╱╱╱╱╱╱╱╱┃╰╮╭╯┃╱╱╱╱┃┃╭╯╰╮┃╭━╮┃┃╱╱╱┃┃
10 //┃┃╱┃┃┃╭┳━━┳╮╱╭╮╱┃┃┃┣╮╭┳━━┳╮//╰╮╰╯╭┻━┳━━┫╰┻╮╭╯┃┃╱╰┫┃╭╮╭┫╰━╮
11 //┃┃╱┃┃╰╯┫╭╮┃┃╱┃┃╱┃┃┃┃┃┃┃╭━┫┃//╱╰╮╭┫╭╮┃╭━┫╭╮┃┃╱┃┃╱╭┫┃┃┃┃┃╭╮┃
12 //┃╰━╯┃╭╮┫╭╮┃╰━╯┃╭╯╰╯┃╰╯┃╰━┫┃////┃┃┃╭╮┃╰━┫┃┃┃╰╮┃╰━╯┃╰┫╰╯┃╰╯┃
13 //╰━━━┻╯╰┻╯╰┻━╮╭╯╰━━━┻━━┻━━┻┃//╱╱╰╯╰╯╰┻━━┻╯╰┻━╯╰━━━┻━┻━━┻━━╯
14 //╱╱╱╱╱╱╱╱╱╱╭━╯┃/////////╭━╯┃/////////////////////////////
15 //╱╱╱╱╱╱╱╱╱╱╰━━╯/////////╰━━╯//////////////////////////////
16 
17 
18 
19 
20 // Creator: @cryptoCharlieva
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
279 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol
280 
281 
282 // ERC721A Contracts v3.3.0
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
1097 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
1098 
1099 
1100 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
1101 
1102 pragma solidity ^0.8.0;
1103 
1104 /**
1105  * @dev String operations.
1106  */
1107 library Strings {
1108     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1109     uint8 private constant _ADDRESS_LENGTH = 20;
1110 
1111     /**
1112      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1113      */
1114     function toString(uint256 value) internal pure returns (string memory) {
1115         // Inspired by OraclizeAPI's implementation - MIT licence
1116         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1117 
1118         if (value == 0) {
1119             return "0";
1120         }
1121         uint256 temp = value;
1122         uint256 digits;
1123         while (temp != 0) {
1124             digits++;
1125             temp /= 10;
1126         }
1127         bytes memory buffer = new bytes(digits);
1128         while (value != 0) {
1129             digits -= 1;
1130             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1131             value /= 10;
1132         }
1133         return string(buffer);
1134     }
1135 
1136     /**
1137      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1138      */
1139     function toHexString(uint256 value) internal pure returns (string memory) {
1140         if (value == 0) {
1141             return "0x00";
1142         }
1143         uint256 temp = value;
1144         uint256 length = 0;
1145         while (temp != 0) {
1146             length++;
1147             temp >>= 8;
1148         }
1149         return toHexString(value, length);
1150     }
1151 
1152     /**
1153      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1154      */
1155     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1156         bytes memory buffer = new bytes(2 * length + 2);
1157         buffer[0] = "0";
1158         buffer[1] = "x";
1159         for (uint256 i = 2 * length + 1; i > 1; --i) {
1160             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1161             value >>= 4;
1162         }
1163         require(value == 0, "Strings: hex length insufficient");
1164         return string(buffer);
1165     }
1166 
1167     /**
1168      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1169      */
1170     function toHexString(address addr) internal pure returns (string memory) {
1171         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1172     }
1173 }
1174 
1175 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
1176 
1177 
1178 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1179 
1180 pragma solidity ^0.8.0;
1181 
1182 /**
1183  * @dev Provides information about the current execution context, including the
1184  * sender of the transaction and its data. While these are generally available
1185  * via msg.sender and msg.data, they should not be accessed in such a direct
1186  * manner, since when dealing with meta-transactions the account sending and
1187  * paying for execution may not be the actual sender (as far as an application
1188  * is concerned).
1189  *
1190  * This contract is only required for intermediate, library-like contracts.
1191  */
1192 abstract contract Context {
1193     function _msgSender() internal view virtual returns (address) {
1194         return msg.sender;
1195     }
1196 
1197     function _msgData() internal view virtual returns (bytes calldata) {
1198         return msg.data;
1199     }
1200 }
1201 
1202 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
1203 
1204 
1205 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1206 
1207 pragma solidity ^0.8.0;
1208 
1209 
1210 /**
1211  * @dev Contract module which provides a basic access control mechanism, where
1212  * there is an account (an owner) that can be granted exclusive access to
1213  * specific functions.
1214  *
1215  * By default, the owner account will be the one that deploys the contract. This
1216  * can later be changed with {transferOwnership}.
1217  *
1218  * This module is used through inheritance. It will make available the modifier
1219  * `onlyOwner`, which can be applied to your functions to restrict their use to
1220  * the owner.
1221  */
1222 abstract contract Ownable is Context {
1223     address private _owner;
1224 
1225     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1226 
1227     /**
1228      * @dev Initializes the contract setting the deployer as the initial owner.
1229      */
1230     constructor() {
1231         _transferOwnership(_msgSender());
1232     }
1233 
1234     /**
1235      * @dev Returns the address of the current owner.
1236      */
1237     function owner() public view virtual returns (address) {
1238         return _owner;
1239     }
1240 
1241     /**
1242      * @dev Throws if called by any account other than the owner.
1243      */
1244     modifier onlyOwner() {
1245         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1246         _;
1247     }
1248 
1249     /**
1250      * @dev Leaves the contract without owner. It will not be possible to call
1251      * `onlyOwner` functions anymore. Can only be called by the current owner.
1252      *
1253      * NOTE: Renouncing ownership will leave the contract without an owner,
1254      * thereby removing any functionality that is only available to the owner.
1255      */
1256     function renounceOwnership() public virtual onlyOwner {
1257         _transferOwnership(address(0));
1258     }
1259 
1260     /**
1261      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1262      * Can only be called by the current owner.
1263      */
1264     function transferOwnership(address newOwner) public virtual onlyOwner {
1265         require(newOwner != address(0), "Ownable: new owner is the zero address");
1266         _transferOwnership(newOwner);
1267     }
1268 
1269     /**
1270      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1271      * Internal function without access restriction.
1272      */
1273     function _transferOwnership(address newOwner) internal virtual {
1274         address oldOwner = _owner;
1275         _owner = newOwner;
1276         emit OwnershipTransferred(oldOwner, newOwner);
1277     }
1278 }
1279 
1280 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol
1281 
1282 
1283 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
1284 
1285 pragma solidity ^0.8.1;
1286 
1287 /**
1288  * @dev Collection of functions related to the address type
1289  */
1290 library Address {
1291     /**
1292      * @dev Returns true if `account` is a contract.
1293      *
1294      * [IMPORTANT]
1295      * ====
1296      * It is unsafe to assume that an address for which this function returns
1297      * false is an externally-owned account (EOA) and not a contract.
1298      *
1299      * Among others, `isContract` will return false for the following
1300      * types of addresses:
1301      *
1302      *  - an externally-owned account
1303      *  - a contract in construction
1304      *  - an address where a contract will be created
1305      *  - an address where a contract lived, but was destroyed
1306      * ====
1307      *
1308      * [IMPORTANT]
1309      * ====
1310      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1311      *
1312      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1313      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1314      * constructor.
1315      * ====
1316      */
1317     function isContract(address account) internal view returns (bool) {
1318         // This method relies on extcodesize/address.code.length, which returns 0
1319         // for contracts in construction, since the code is only stored at the end
1320         // of the constructor execution.
1321 
1322         return account.code.length > 0;
1323     }
1324 
1325     /**
1326      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1327      * `recipient`, forwarding all available gas and reverting on errors.
1328      *
1329      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1330      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1331      * imposed by `transfer`, making them unable to receive funds via
1332      * `transfer`. {sendValue} removes this limitation.
1333      *
1334      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1335      *
1336      * IMPORTANT: because control is transferred to `recipient`, care must be
1337      * taken to not create reentrancy vulnerabilities. Consider using
1338      * {ReentrancyGuard} or the
1339      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1340      */
1341     function sendValue(address payable recipient, uint256 amount) internal {
1342         require(address(this).balance >= amount, "Address: insufficient balance");
1343 
1344         (bool success, ) = recipient.call{value: amount}("");
1345         require(success, "Address: unable to send value, recipient may have reverted");
1346     }
1347 
1348     /**
1349      * @dev Performs a Solidity function call using a low level `call`. A
1350      * plain `call` is an unsafe replacement for a function call: use this
1351      * function instead.
1352      *
1353      * If `target` reverts with a revert reason, it is bubbled up by this
1354      * function (like regular Solidity function calls).
1355      *
1356      * Returns the raw returned data. To convert to the expected return value,
1357      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1358      *
1359      * Requirements:
1360      *
1361      * - `target` must be a contract.
1362      * - calling `target` with `data` must not revert.
1363      *
1364      * _Available since v3.1._
1365      */
1366     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1367         return functionCall(target, data, "Address: low-level call failed");
1368     }
1369 
1370     /**
1371      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1372      * `errorMessage` as a fallback revert reason when `target` reverts.
1373      *
1374      * _Available since v3.1._
1375      */
1376     function functionCall(
1377         address target,
1378         bytes memory data,
1379         string memory errorMessage
1380     ) internal returns (bytes memory) {
1381         return functionCallWithValue(target, data, 0, errorMessage);
1382     }
1383 
1384     /**
1385      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1386      * but also transferring `value` wei to `target`.
1387      *
1388      * Requirements:
1389      *
1390      * - the calling contract must have an ETH balance of at least `value`.
1391      * - the called Solidity function must be `payable`.
1392      *
1393      * _Available since v3.1._
1394      */
1395     function functionCallWithValue(
1396         address target,
1397         bytes memory data,
1398         uint256 value
1399     ) internal returns (bytes memory) {
1400         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1401     }
1402 
1403     /**
1404      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1405      * with `errorMessage` as a fallback revert reason when `target` reverts.
1406      *
1407      * _Available since v3.1._
1408      */
1409     function functionCallWithValue(
1410         address target,
1411         bytes memory data,
1412         uint256 value,
1413         string memory errorMessage
1414     ) internal returns (bytes memory) {
1415         require(address(this).balance >= value, "Address: insufficient balance for call");
1416         require(isContract(target), "Address: call to non-contract");
1417 
1418         (bool success, bytes memory returndata) = target.call{value: value}(data);
1419         return verifyCallResult(success, returndata, errorMessage);
1420     }
1421 
1422     /**
1423      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1424      * but performing a static call.
1425      *
1426      * _Available since v3.3._
1427      */
1428     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1429         return functionStaticCall(target, data, "Address: low-level static call failed");
1430     }
1431 
1432     /**
1433      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1434      * but performing a static call.
1435      *
1436      * _Available since v3.3._
1437      */
1438     function functionStaticCall(
1439         address target,
1440         bytes memory data,
1441         string memory errorMessage
1442     ) internal view returns (bytes memory) {
1443         require(isContract(target), "Address: static call to non-contract");
1444 
1445         (bool success, bytes memory returndata) = target.staticcall(data);
1446         return verifyCallResult(success, returndata, errorMessage);
1447     }
1448 
1449     /**
1450      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1451      * but performing a delegate call.
1452      *
1453      * _Available since v3.4._
1454      */
1455     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1456         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1457     }
1458 
1459     /**
1460      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1461      * but performing a delegate call.
1462      *
1463      * _Available since v3.4._
1464      */
1465     function functionDelegateCall(
1466         address target,
1467         bytes memory data,
1468         string memory errorMessage
1469     ) internal returns (bytes memory) {
1470         require(isContract(target), "Address: delegate call to non-contract");
1471 
1472         (bool success, bytes memory returndata) = target.delegatecall(data);
1473         return verifyCallResult(success, returndata, errorMessage);
1474     }
1475 
1476     /**
1477      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1478      * revert reason using the provided one.
1479      *
1480      * _Available since v4.3._
1481      */
1482     function verifyCallResult(
1483         bool success,
1484         bytes memory returndata,
1485         string memory errorMessage
1486     ) internal pure returns (bytes memory) {
1487         if (success) {
1488             return returndata;
1489         } else {
1490             // Look for revert reason and bubble it up if present
1491             if (returndata.length > 0) {
1492                 // The easiest way to bubble the revert reason is using memory via assembly
1493 
1494                 assembly {
1495                     let returndata_size := mload(returndata)
1496                     revert(add(32, returndata), returndata_size)
1497                 }
1498             } else {
1499                 revert(errorMessage);
1500             }
1501         }
1502     }
1503 }
1504 
1505 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721Receiver.sol
1506 
1507 
1508 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
1509 
1510 pragma solidity ^0.8.0;
1511 
1512 /**
1513  * @title ERC721 token receiver interface
1514  * @dev Interface for any contract that wants to support safeTransfers
1515  * from ERC721 asset contracts.
1516  */
1517 interface IERC721Receiver {
1518     /**
1519      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1520      * by `operator` from `from`, this function is called.
1521      *
1522      * It must return its Solidity selector to confirm the token transfer.
1523      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1524      *
1525      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
1526      */
1527     function onERC721Received(
1528         address operator,
1529         address from,
1530         uint256 tokenId,
1531         bytes calldata data
1532     ) external returns (bytes4);
1533 }
1534 
1535 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/IERC165.sol
1536 
1537 
1538 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1539 
1540 pragma solidity ^0.8.0;
1541 
1542 /**
1543  * @dev Interface of the ERC165 standard, as defined in the
1544  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1545  *
1546  * Implementers can declare support of contract interfaces, which can then be
1547  * queried by others ({ERC165Checker}).
1548  *
1549  * For an implementation, see {ERC165}.
1550  */
1551 interface IERC165 {
1552     /**
1553      * @dev Returns true if this contract implements the interface defined by
1554      * `interfaceId`. See the corresponding
1555      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1556      * to learn more about how these ids are created.
1557      *
1558      * This function call must use less than 30 000 gas.
1559      */
1560     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1561 }
1562 
1563 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/ERC165.sol
1564 
1565 
1566 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1567 
1568 pragma solidity ^0.8.0;
1569 
1570 
1571 /**
1572  * @dev Implementation of the {IERC165} interface.
1573  *
1574  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1575  * for the additional interface id that will be supported. For example:
1576  *
1577  * ```solidity
1578  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1579  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1580  * }
1581  * ```
1582  *
1583  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1584  */
1585 abstract contract ERC165 is IERC165 {
1586     /**
1587      * @dev See {IERC165-supportsInterface}.
1588      */
1589     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1590         return interfaceId == type(IERC165).interfaceId;
1591     }
1592 }
1593 
1594 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721.sol
1595 
1596 
1597 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
1598 
1599 pragma solidity ^0.8.0;
1600 
1601 
1602 /**
1603  * @dev Required interface of an ERC721 compliant contract.
1604  */
1605 interface IERC721 is IERC165 {
1606     /**
1607      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1608      */
1609     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1610 
1611     /**
1612      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1613      */
1614     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1615 
1616     /**
1617      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1618      */
1619     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1620 
1621     /**
1622      * @dev Returns the number of tokens in ``owner``'s account.
1623      */
1624     function balanceOf(address owner) external view returns (uint256 balance);
1625 
1626     /**
1627      * @dev Returns the owner of the `tokenId` token.
1628      *
1629      * Requirements:
1630      *
1631      * - `tokenId` must exist.
1632      */
1633     function ownerOf(uint256 tokenId) external view returns (address owner);
1634 
1635     /**
1636      * @dev Safely transfers `tokenId` token from `from` to `to`.
1637      *
1638      * Requirements:
1639      *
1640      * - `from` cannot be the zero address.
1641      * - `to` cannot be the zero address.
1642      * - `tokenId` token must exist and be owned by `from`.
1643      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1644      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1645      *
1646      * Emits a {Transfer} event.
1647      */
1648     function safeTransferFrom(
1649         address from,
1650         address to,
1651         uint256 tokenId,
1652         bytes calldata data
1653     ) external;
1654 
1655     /**
1656      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1657      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1658      *
1659      * Requirements:
1660      *
1661      * - `from` cannot be the zero address.
1662      * - `to` cannot be the zero address.
1663      * - `tokenId` token must exist and be owned by `from`.
1664      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1665      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1666      *
1667      * Emits a {Transfer} event.
1668      */
1669     function safeTransferFrom(
1670         address from,
1671         address to,
1672         uint256 tokenId
1673     ) external;
1674 
1675     /**
1676      * @dev Transfers `tokenId` token from `from` to `to`.
1677      *
1678      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1679      *
1680      * Requirements:
1681      *
1682      * - `from` cannot be the zero address.
1683      * - `to` cannot be the zero address.
1684      * - `tokenId` token must be owned by `from`.
1685      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1686      *
1687      * Emits a {Transfer} event.
1688      */
1689     function transferFrom(
1690         address from,
1691         address to,
1692         uint256 tokenId
1693     ) external;
1694 
1695     /**
1696      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1697      * The approval is cleared when the token is transferred.
1698      *
1699      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1700      *
1701      * Requirements:
1702      *
1703      * - The caller must own the token or be an approved operator.
1704      * - `tokenId` must exist.
1705      *
1706      * Emits an {Approval} event.
1707      */
1708     function approve(address to, uint256 tokenId) external;
1709 
1710     /**
1711      * @dev Approve or remove `operator` as an operator for the caller.
1712      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1713      *
1714      * Requirements:
1715      *
1716      * - The `operator` cannot be the caller.
1717      *
1718      * Emits an {ApprovalForAll} event.
1719      */
1720     function setApprovalForAll(address operator, bool _approved) external;
1721 
1722     /**
1723      * @dev Returns the account approved for `tokenId` token.
1724      *
1725      * Requirements:
1726      *
1727      * - `tokenId` must exist.
1728      */
1729     function getApproved(uint256 tokenId) external view returns (address operator);
1730 
1731     /**
1732      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1733      *
1734      * See {setApprovalForAll}
1735      */
1736     function isApprovedForAll(address owner, address operator) external view returns (bool);
1737 }
1738 
1739 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/IERC721Metadata.sol
1740 
1741 
1742 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1743 
1744 pragma solidity ^0.8.0;
1745 
1746 
1747 /**
1748  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1749  * @dev See https://eips.ethereum.org/EIPS/eip-721
1750  */
1751 interface IERC721Metadata is IERC721 {
1752     /**
1753      * @dev Returns the token collection name.
1754      */
1755     function name() external view returns (string memory);
1756 
1757     /**
1758      * @dev Returns the token collection symbol.
1759      */
1760     function symbol() external view returns (string memory);
1761 
1762     /**
1763      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1764      */
1765     function tokenURI(uint256 tokenId) external view returns (string memory);
1766 }
1767 
1768 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol
1769 
1770 
1771 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
1772 
1773 pragma solidity ^0.8.0;
1774 
1775 
1776 
1777 
1778 
1779 
1780 
1781 
1782 /**
1783  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1784  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1785  * {ERC721Enumerable}.
1786  */
1787 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1788     using Address for address;
1789     using Strings for uint256;
1790 
1791     // Token name
1792     string private _name;
1793 
1794     // Token symbol
1795     string private _symbol;
1796 
1797     // Mapping from token ID to owner address
1798     mapping(uint256 => address) private _owners;
1799 
1800     // Mapping owner address to token count
1801     mapping(address => uint256) private _balances;
1802 
1803     // Mapping from token ID to approved address
1804     mapping(uint256 => address) private _tokenApprovals;
1805 
1806     // Mapping from owner to operator approvals
1807     mapping(address => mapping(address => bool)) private _operatorApprovals;
1808 
1809     /**
1810      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1811      */
1812     constructor(string memory name_, string memory symbol_) {
1813         _name = name_;
1814         _symbol = symbol_;
1815     }
1816 
1817     /**
1818      * @dev See {IERC165-supportsInterface}.
1819      */
1820     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1821         return
1822             interfaceId == type(IERC721).interfaceId ||
1823             interfaceId == type(IERC721Metadata).interfaceId ||
1824             super.supportsInterface(interfaceId);
1825     }
1826 
1827     /**
1828      * @dev See {IERC721-balanceOf}.
1829      */
1830     function balanceOf(address owner) public view virtual override returns (uint256) {
1831         require(owner != address(0), "ERC721: address zero is not a valid owner");
1832         return _balances[owner];
1833     }
1834 
1835     /**
1836      * @dev See {IERC721-ownerOf}.
1837      */
1838     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1839         address owner = _owners[tokenId];
1840         require(owner != address(0), "ERC721: owner query for nonexistent token");
1841         return owner;
1842     }
1843 
1844     /**
1845      * @dev See {IERC721Metadata-name}.
1846      */
1847     function name() public view virtual override returns (string memory) {
1848         return _name;
1849     }
1850 
1851     /**
1852      * @dev See {IERC721Metadata-symbol}.
1853      */
1854     function symbol() public view virtual override returns (string memory) {
1855         return _symbol;
1856     }
1857 
1858     /**
1859      * @dev See {IERC721Metadata-tokenURI}.
1860      */
1861     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1862         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1863 
1864         string memory baseURI = _baseURI();
1865         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1866     }
1867 
1868     /**
1869      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1870      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1871      * by default, can be overridden in child contracts.
1872      */
1873     function _baseURI() internal view virtual returns (string memory) {
1874         return "";
1875     }
1876 
1877     /**
1878      * @dev See {IERC721-approve}.
1879      */
1880     function approve(address to, uint256 tokenId) public virtual override {
1881         address owner = ERC721.ownerOf(tokenId);
1882         require(to != owner, "ERC721: approval to current owner");
1883 
1884         require(
1885             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1886             "ERC721: approve caller is not owner nor approved for all"
1887         );
1888 
1889         _approve(to, tokenId);
1890     }
1891 
1892     /**
1893      * @dev See {IERC721-getApproved}.
1894      */
1895     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1896         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1897 
1898         return _tokenApprovals[tokenId];
1899     }
1900 
1901     /**
1902      * @dev See {IERC721-setApprovalForAll}.
1903      */
1904     function setApprovalForAll(address operator, bool approved) public virtual override {
1905         _setApprovalForAll(_msgSender(), operator, approved);
1906     }
1907 
1908     /**
1909      * @dev See {IERC721-isApprovedForAll}.
1910      */
1911     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1912         return _operatorApprovals[owner][operator];
1913     }
1914 
1915     /**
1916      * @dev See {IERC721-transferFrom}.
1917      */
1918     function transferFrom(
1919         address from,
1920         address to,
1921         uint256 tokenId
1922     ) public virtual override {
1923         //solhint-disable-next-line max-line-length
1924         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1925 
1926         _transfer(from, to, tokenId);
1927     }
1928 
1929     /**
1930      * @dev See {IERC721-safeTransferFrom}.
1931      */
1932     function safeTransferFrom(
1933         address from,
1934         address to,
1935         uint256 tokenId
1936     ) public virtual override {
1937         safeTransferFrom(from, to, tokenId, "");
1938     }
1939 
1940     /**
1941      * @dev See {IERC721-safeTransferFrom}.
1942      */
1943     function safeTransferFrom(
1944         address from,
1945         address to,
1946         uint256 tokenId,
1947         bytes memory data
1948     ) public virtual override {
1949         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1950         _safeTransfer(from, to, tokenId, data);
1951     }
1952 
1953     /**
1954      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1955      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1956      *
1957      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1958      *
1959      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1960      * implement alternative mechanisms to perform token transfer, such as signature-based.
1961      *
1962      * Requirements:
1963      *
1964      * - `from` cannot be the zero address.
1965      * - `to` cannot be the zero address.
1966      * - `tokenId` token must exist and be owned by `from`.
1967      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1968      *
1969      * Emits a {Transfer} event.
1970      */
1971     function _safeTransfer(
1972         address from,
1973         address to,
1974         uint256 tokenId,
1975         bytes memory data
1976     ) internal virtual {
1977         _transfer(from, to, tokenId);
1978         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1979     }
1980 
1981     /**
1982      * @dev Returns whether `tokenId` exists.
1983      *
1984      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1985      *
1986      * Tokens start existing when they are minted (`_mint`),
1987      * and stop existing when they are burned (`_burn`).
1988      */
1989     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1990         return _owners[tokenId] != address(0);
1991     }
1992 
1993     /**
1994      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1995      *
1996      * Requirements:
1997      *
1998      * - `tokenId` must exist.
1999      */
2000     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
2001         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
2002         address owner = ERC721.ownerOf(tokenId);
2003         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
2004     }
2005 
2006     /**
2007      * @dev Safely mints `tokenId` and transfers it to `to`.
2008      *
2009      * Requirements:
2010      *
2011      * - `tokenId` must not exist.
2012      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2013      *
2014      * Emits a {Transfer} event.
2015      */
2016     function _safeMint(address to, uint256 tokenId) internal virtual {
2017         _safeMint(to, tokenId, "");
2018     }
2019 
2020     /**
2021      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
2022      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
2023      */
2024     function _safeMint(
2025         address to,
2026         uint256 tokenId,
2027         bytes memory data
2028     ) internal virtual {
2029         _mint(to, tokenId);
2030         require(
2031             _checkOnERC721Received(address(0), to, tokenId, data),
2032             "ERC721: transfer to non ERC721Receiver implementer"
2033         );
2034     }
2035 
2036     /**
2037      * @dev Mints `tokenId` and transfers it to `to`.
2038      *
2039      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
2040      *
2041      * Requirements:
2042      *
2043      * - `tokenId` must not exist.
2044      * - `to` cannot be the zero address.
2045      *
2046      * Emits a {Transfer} event.
2047      */
2048     function _mint(address to, uint256 tokenId) internal virtual {
2049         require(to != address(0), "ERC721: mint to the zero address");
2050         require(!_exists(tokenId), "ERC721: token already minted");
2051 
2052         _beforeTokenTransfer(address(0), to, tokenId);
2053 
2054         _balances[to] += 1;
2055         _owners[tokenId] = to;
2056 
2057         emit Transfer(address(0), to, tokenId);
2058 
2059         _afterTokenTransfer(address(0), to, tokenId);
2060     }
2061 
2062     /**
2063      * @dev Destroys `tokenId`.
2064      * The approval is cleared when the token is burned.
2065      *
2066      * Requirements:
2067      *
2068      * - `tokenId` must exist.
2069      *
2070      * Emits a {Transfer} event.
2071      */
2072     function _burn(uint256 tokenId) internal virtual {
2073         address owner = ERC721.ownerOf(tokenId);
2074 
2075         _beforeTokenTransfer(owner, address(0), tokenId);
2076 
2077         // Clear approvals
2078         _approve(address(0), tokenId);
2079 
2080         _balances[owner] -= 1;
2081         delete _owners[tokenId];
2082 
2083         emit Transfer(owner, address(0), tokenId);
2084 
2085         _afterTokenTransfer(owner, address(0), tokenId);
2086     }
2087 
2088     /**
2089      * @dev Transfers `tokenId` from `from` to `to`.
2090      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2091      *
2092      * Requirements:
2093      *
2094      * - `to` cannot be the zero address.
2095      * - `tokenId` token must be owned by `from`.
2096      *
2097      * Emits a {Transfer} event.
2098      */
2099     function _transfer(
2100         address from,
2101         address to,
2102         uint256 tokenId
2103     ) internal virtual {
2104         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
2105         require(to != address(0), "ERC721: transfer to the zero address");
2106 
2107         _beforeTokenTransfer(from, to, tokenId);
2108 
2109         // Clear approvals from the previous owner
2110         _approve(address(0), tokenId);
2111 
2112         _balances[from] -= 1;
2113         _balances[to] += 1;
2114         _owners[tokenId] = to;
2115 
2116         emit Transfer(from, to, tokenId);
2117 
2118         _afterTokenTransfer(from, to, tokenId);
2119     }
2120 
2121     /**
2122      * @dev Approve `to` to operate on `tokenId`
2123      *
2124      * Emits an {Approval} event.
2125      */
2126     function _approve(address to, uint256 tokenId) internal virtual {
2127         _tokenApprovals[tokenId] = to;
2128         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
2129     }
2130 
2131     /**
2132      * @dev Approve `operator` to operate on all of `owner` tokens
2133      *
2134      * Emits an {ApprovalForAll} event.
2135      */
2136     function _setApprovalForAll(
2137         address owner,
2138         address operator,
2139         bool approved
2140     ) internal virtual {
2141         require(owner != operator, "ERC721: approve to caller");
2142         _operatorApprovals[owner][operator] = approved;
2143         emit ApprovalForAll(owner, operator, approved);
2144     }
2145 
2146     /**
2147      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2148      * The call is not executed if the target address is not a contract.
2149      *
2150      * @param from address representing the previous owner of the given token ID
2151      * @param to target address that will receive the tokens
2152      * @param tokenId uint256 ID of the token to be transferred
2153      * @param data bytes optional data to send along with the call
2154      * @return bool whether the call correctly returned the expected magic value
2155      */
2156     function _checkOnERC721Received(
2157         address from,
2158         address to,
2159         uint256 tokenId,
2160         bytes memory data
2161     ) private returns (bool) {
2162         if (to.isContract()) {
2163             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
2164                 return retval == IERC721Receiver.onERC721Received.selector;
2165             } catch (bytes memory reason) {
2166                 if (reason.length == 0) {
2167                     revert("ERC721: transfer to non ERC721Receiver implementer");
2168                 } else {
2169                     assembly {
2170                         revert(add(32, reason), mload(reason))
2171                     }
2172                 }
2173             }
2174         } else {
2175             return true;
2176         }
2177     }
2178 
2179     /**
2180      * @dev Hook that is called before any token transfer. This includes minting
2181      * and burning.
2182      *
2183      * Calling conditions:
2184      *
2185      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2186      * transferred to `to`.
2187      * - When `from` is zero, `tokenId` will be minted for `to`.
2188      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2189      * - `from` and `to` are never both zero.
2190      *
2191      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2192      */
2193     function _beforeTokenTransfer(
2194         address from,
2195         address to,
2196         uint256 tokenId
2197     ) internal virtual {}
2198 
2199     /**
2200      * @dev Hook that is called after any transfer of tokens. This includes
2201      * minting and burning.
2202      *
2203      * Calling conditions:
2204      *
2205      * - when `from` and `to` are both non-zero.
2206      * - `from` and `to` are never both zero.
2207      *
2208      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2209      */
2210     function _afterTokenTransfer(
2211         address from,
2212         address to,
2213         uint256 tokenId
2214     ) internal virtual {}
2215 }
2216 
2217 // File: contracts/ODYC.sol
2218 
2219 
2220 pragma solidity ^0.8.0;
2221 
2222 
2223 contract ODYC is ERC721A, Ownable {
2224     using Strings for uint256;
2225 
2226     string private baseURI;
2227 
2228     uint256 public price = 0.004 ether;
2229 
2230     uint256 public maxPerTx = 10;
2231 
2232     uint256 public maxFreePerWallet = 10;
2233 
2234     uint256 public totalFree = 1500;
2235 
2236     uint256 public maxSupply = 5555;
2237 
2238     bool public mintEnabled = true;
2239 
2240     mapping(address => uint256) private _mintedFreeAmount;
2241 
2242     constructor() ERC721A("Okay Duck Yacht Club", "ODYC") {
2243         _safeMint(msg.sender, 10);
2244         setBaseURI("ipfs://QmRhmHLEGPDLMZHm2yoBjsCw67G3B4TLyUxDgVV8s3dHfg/");
2245     }
2246 
2247     function mint(uint256 count) external payable {
2248         uint256 cost = price;
2249         bool isFree = ((totalSupply() + count < totalFree + 1) &&
2250             (_mintedFreeAmount[msg.sender] + count <= maxFreePerWallet));
2251 
2252         if (isFree) {
2253             cost = 0;
2254         }
2255 
2256         require(msg.value >= count * cost, "Please send the exact amount.");
2257         require(totalSupply() + count < maxSupply + 1, "No more");
2258         require(mintEnabled, "Minting is not live yet");
2259         require(count < maxPerTx + 1, "Max per TX reached.");
2260 
2261         if (isFree) {
2262             _mintedFreeAmount[msg.sender] += count;
2263         }
2264 
2265         _safeMint(msg.sender, count);
2266     }
2267 
2268     function _baseURI() internal view virtual override returns (string memory) {
2269         return baseURI;
2270     }
2271 
2272     function tokenURI(uint256 tokenId)
2273         public
2274         view
2275         virtual
2276         override
2277         returns (string memory)
2278     {
2279         require(
2280             _exists(tokenId),
2281             "ERC721Metadata: URI query for nonexistent token"
2282         );
2283         return string(abi.encodePacked(baseURI, tokenId.toString(), ".json"));
2284     }
2285 
2286     function setBaseURI(string memory uri) public onlyOwner {
2287         baseURI = uri;
2288     }
2289 
2290     function setFreeAmount(uint256 amount) external onlyOwner {
2291         totalFree = amount;
2292     }
2293 
2294     function setPrice(uint256 _newPrice) external onlyOwner {
2295         price = _newPrice;
2296     }
2297 
2298     function flipSale() external onlyOwner {
2299         mintEnabled = !mintEnabled;
2300     }
2301 
2302     function withdraw() external onlyOwner {
2303         (bool success, ) = payable(msg.sender).call{
2304             value: address(this).balance
2305         }("");
2306         require(success, "Transfer failed.");
2307     }
2308 }