1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.13;
3 
4 /**
5  * @dev Interface of an ERC721A compliant contract.
6  */
7 interface IERC721A {
8     /**
9      * The caller must own the token or be an approved operator.
10      */
11     error ApprovalCallerNotOwnerNorApproved();
12 
13     /**
14      * The token does not exist.
15      */
16     error ApprovalQueryForNonexistentToken();
17 
18     /**
19      * The caller cannot approve to their own address.
20      */
21     error ApproveToCaller();
22 
23     /**
24      * The caller cannot approve to the current owner.
25      */
26     error ApprovalToCurrentOwner();
27 
28     /**
29      * Cannot query the balance for the zero address.
30      */
31     error BalanceQueryForZeroAddress();
32 
33     /**
34      * Cannot mint to the zero address.
35      */
36     error MintToZeroAddress();
37 
38     /**
39      * The quantity of tokens minted must be more than zero.
40      */
41     error MintZeroQuantity();
42 
43     /**
44      * The token does not exist.
45      */
46     error OwnerQueryForNonexistentToken();
47 
48     /**
49      * The caller must own the token or be an approved operator.
50      */
51     error TransferCallerNotOwnerNorApproved();
52 
53     /**
54      * The token must be owned by `from`.
55      */
56     error TransferFromIncorrectOwner();
57 
58     /**
59      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
60      */
61     error TransferToNonERC721ReceiverImplementer();
62 
63     /**
64      * Cannot transfer to the zero address.
65      */
66     error TransferToZeroAddress();
67 
68     /**
69      * The token does not exist.
70      */
71     error URIQueryForNonexistentToken();
72 
73     struct TokenOwnership {
74         // The address of the owner.
75         address addr;
76         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
77         uint64 startTimestamp;
78         // Whether the token has been burned.
79         bool burned;
80     }
81 
82     /**
83      * @dev Returns the total amount of tokens stored by the contract.
84      *
85      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
86      */
87     function totalSupply() external view returns (uint256);
88 
89     // ==============================
90     //            IERC165
91     // ==============================
92 
93     /**
94      * @dev Returns true if this contract implements the interface defined by
95      * `interfaceId`. See the corresponding
96      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
97      * to learn more about how these ids are created.
98      *
99      * This function call must use less than 30 000 gas.
100      */
101     function supportsInterface(bytes4 interfaceId) external view returns (bool);
102 
103     // ==============================
104     //            IERC721
105     // ==============================
106 
107     /**
108      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
109      */
110     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
111 
112     /**
113      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
114      */
115     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
116 
117     /**
118      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
119      */
120     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
121 
122     /**
123      * @dev Returns the number of tokens in ``owner``'s account.
124      */
125     function balanceOf(address owner) external view returns (uint256 balance);
126 
127     /**
128      * @dev Returns the owner of the `tokenId` token.
129      *
130      * Requirements:
131      *
132      * - `tokenId` must exist.
133      */
134     function ownerOf(uint256 tokenId) external view returns (address owner);
135 
136     /**
137      * @dev Safely transfers `tokenId` token from `from` to `to`.
138      *
139      * Requirements:
140      *
141      * - `from` cannot be the zero address.
142      * - `to` cannot be the zero address.
143      * - `tokenId` token must exist and be owned by `from`.
144      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
145      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
146      *
147      * Emits a {Transfer} event.
148      */
149     function safeTransferFrom(
150         address from,
151         address to,
152         uint256 tokenId,
153         bytes calldata data
154     ) external;
155 
156     /**
157      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
158      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
159      *
160      * Requirements:
161      *
162      * - `from` cannot be the zero address.
163      * - `to` cannot be the zero address.
164      * - `tokenId` token must exist and be owned by `from`.
165      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
166      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
167      *
168      * Emits a {Transfer} event.
169      */
170     function safeTransferFrom(
171         address from,
172         address to,
173         uint256 tokenId
174     ) external;
175 
176     /**
177      * @dev Transfers `tokenId` token from `from` to `to`.
178      *
179      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
180      *
181      * Requirements:
182      *
183      * - `from` cannot be the zero address.
184      * - `to` cannot be the zero address.
185      * - `tokenId` token must be owned by `from`.
186      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
187      *
188      * Emits a {Transfer} event.
189      */
190     function transferFrom(
191         address from,
192         address to,
193         uint256 tokenId
194     ) external;
195 
196     /**
197      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
198      * The approval is cleared when the token is transferred.
199      *
200      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
201      *
202      * Requirements:
203      *
204      * - The caller must own the token or be an approved operator.
205      * - `tokenId` must exist.
206      *
207      * Emits an {Approval} event.
208      */
209     function approve(address to, uint256 tokenId) external;
210 
211     /**
212      * @dev Approve or remove `operator` as an operator for the caller.
213      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
214      *
215      * Requirements:
216      *
217      * - The `operator` cannot be the caller.
218      *
219      * Emits an {ApprovalForAll} event.
220      */
221     function setApprovalForAll(address operator, bool _approved) external;
222 
223     /**
224      * @dev Returns the account approved for `tokenId` token.
225      *
226      * Requirements:
227      *
228      * - `tokenId` must exist.
229      */
230     function getApproved(uint256 tokenId) external view returns (address operator);
231 
232     /**
233      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
234      *
235      * See {setApprovalForAll}
236      */
237     function isApprovedForAll(address owner, address operator) external view returns (bool);
238 
239     // ==============================
240     //        IERC721Metadata
241     // ==============================
242 
243     /**
244      * @dev Returns the token collection name.
245      */
246     function name() external view returns (string memory);
247 
248     /**
249      * @dev Returns the token collection symbol.
250      */
251     function symbol() external view returns (string memory);
252 
253     /**
254      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
255      */
256     function tokenURI(uint256 tokenId) external view returns (string memory);
257 }
258 
259 
260 
261 /**
262  * @dev Interface of an ERC721AQueryable compliant contract.
263  */
264 interface IERC721AQueryable is IERC721A {
265     /**
266      * Invalid query range (`start` >= `stop`).
267      */
268     error InvalidQueryRange();
269 
270     /**
271      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
272      *
273      * If the `tokenId` is out of bounds:
274      *   - `addr` = `address(0)`
275      *   - `startTimestamp` = `0`
276      *   - `burned` = `false`
277      *
278      * If the `tokenId` is burned:
279      *   - `addr` = `<Address of owner before token was burned>`
280      *   - `startTimestamp` = `<Timestamp when token was burned>`
281      *   - `burned = `true`
282      *
283      * Otherwise:
284      *   - `addr` = `<Address of owner>`
285      *   - `startTimestamp` = `<Timestamp of start of ownership>`
286      *   - `burned = `false`
287      */
288     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
289 
290     /**
291      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
292      * See {ERC721AQueryable-explicitOwnershipOf}
293      */
294     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
295 
296     /**
297      * @dev Returns an array of token IDs owned by `owner`,
298      * in the range [`start`, `stop`)
299      * (i.e. `start <= tokenId < stop`).
300      *
301      * This function allows for tokens to be queried if the collection
302      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
303      *
304      * Requirements:
305      *
306      * - `start` < `stop`
307      */
308     function tokensOfOwnerIn(
309         address owner,
310         uint256 start,
311         uint256 stop
312     ) external view returns (uint256[] memory);
313 
314     /**
315      * @dev Returns an array of token IDs owned by `owner`.
316      *
317      * This function scans the ownership mapping and is O(totalSupply) in complexity.
318      * It is meant to be called off-chain.
319      *
320      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
321      * multiple smaller scans if the collection is large enough to cause
322      * an out-of-gas error (10K pfp collections should be fine).
323      */
324     function tokensOfOwner(address owner) external view returns (uint256[] memory);
325 }
326 
327 
328 /**
329  * @dev ERC721 token receiver interface.
330  */
331 interface ERC721A__IERC721Receiver {
332     function onERC721Received(
333         address operator,
334         address from,
335         uint256 tokenId,
336         bytes calldata data
337     ) external returns (bytes4);
338 }
339 
340 contract ERC721A is IERC721A {
341     // Mask of an entry in packed address data.
342     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
343 
344     // The bit position of `numberMinted` in packed address data.
345     uint256 private constant BITPOS_NUMBER_MINTED = 64;
346 
347     // The bit position of `numberBurned` in packed address data.
348     uint256 private constant BITPOS_NUMBER_BURNED = 128;
349 
350     // The bit position of `aux` in packed address data.
351     uint256 private constant BITPOS_AUX = 192;
352 
353     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
354     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
355 
356     // The bit position of `startTimestamp` in packed ownership.
357     uint256 private constant BITPOS_START_TIMESTAMP = 160;
358 
359     // The bit mask of the `burned` bit in packed ownership.
360     uint256 private constant BITMASK_BURNED = 1 << 224;
361     
362     // The bit position of the `nextInitialized` bit in packed ownership.
363     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
364 
365     // The bit mask of the `nextInitialized` bit in packed ownership.
366     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
367 
368     // The tokenId of the next token to be minted.
369     uint256 private _currentIndex;
370 
371     // The number of tokens burned.
372     uint256 private _burnCounter;
373 
374     // Token name
375     string private _name;
376 
377     // Token symbol
378     string private _symbol;
379 
380     // Mapping from token ID to ownership details
381     // An empty struct value does not necessarily mean the token is unowned.
382     // See `_packedOwnershipOf` implementation for details.
383     //
384     // Bits Layout:
385     // - [0..159]   `addr`
386     // - [160..223] `startTimestamp`
387     // - [224]      `burned`
388     // - [225]      `nextInitialized`
389     mapping(uint256 => uint256) private _packedOwnerships;
390 
391     // Mapping owner address to address data.
392     //
393     // Bits Layout:
394     // - [0..63]    `balance`
395     // - [64..127]  `numberMinted`
396     // - [128..191] `numberBurned`
397     // - [192..255] `aux`
398     mapping(address => uint256) private _packedAddressData;
399 
400     // Mapping from token ID to approved address.
401     mapping(uint256 => address) private _tokenApprovals;
402 
403     // Mapping from owner to operator approvals
404     mapping(address => mapping(address => bool)) private _operatorApprovals;
405 
406     constructor(string memory name_, string memory symbol_) {
407         _name = name_;
408         _symbol = symbol_;
409         _currentIndex = _startTokenId();
410     }
411 
412     /**
413      * @dev Returns the starting token ID. 
414      * To change the starting token ID, please override this function.
415      */
416     function _startTokenId() internal view virtual returns (uint256) {
417         return 0;
418     }
419 
420     /**
421      * @dev Returns the next token ID to be minted.
422      */
423     function _nextTokenId() internal view returns (uint256) {
424         return _currentIndex;
425     }
426 
427     /**
428      * @dev Returns the total number of tokens in existence.
429      * Burned tokens will reduce the count. 
430      * To get the total number of tokens minted, please see `_totalMinted`.
431      */
432     function totalSupply() public view override returns (uint256) {
433         // Counter underflow is impossible as _burnCounter cannot be incremented
434         // more than `_currentIndex - _startTokenId()` times.
435         unchecked {
436             return _currentIndex - _burnCounter - _startTokenId();
437         }
438     }
439 
440     /**
441      * @dev Returns the total amount of tokens minted in the contract.
442      */
443     function _totalMinted() internal view returns (uint256) {
444         // Counter underflow is impossible as _currentIndex does not decrement,
445         // and it is initialized to `_startTokenId()`
446         unchecked {
447             return _currentIndex - _startTokenId();
448         }
449     }
450 
451     /**
452      * @dev Returns the total number of tokens burned.
453      */
454     function _totalBurned() internal view returns (uint256) {
455         return _burnCounter;
456     }
457 
458     /**
459      * @dev See {IERC165-supportsInterface}.
460      */
461     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
462         // The interface IDs are constants representing the first 4 bytes of the XOR of
463         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
464         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
465         return
466             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
467             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
468             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
469     }
470 
471     /**
472      * @dev See {IERC721-balanceOf}.
473      */
474     function balanceOf(address owner) public view override returns (uint256) {
475         if (owner == address(0)) revert BalanceQueryForZeroAddress();
476         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
477     }
478 
479     /**
480      * Returns the number of tokens minted by `owner`.
481      */
482     function _numberMinted(address owner) internal view returns (uint256) {
483         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
484     }
485 
486     /**
487      * Returns the number of tokens burned by or on behalf of `owner`.
488      */
489     function _numberBurned(address owner) internal view returns (uint256) {
490         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
491     }
492 
493     /**
494      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
495      */
496     function _getAux(address owner) internal view returns (uint64) {
497         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
498     }
499 
500     /**
501      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
502      * If there are multiple variables, please pack them into a uint64.
503      */
504     function _setAux(address owner, uint64 aux) internal {
505         uint256 packed = _packedAddressData[owner];
506         uint256 auxCasted;
507         assembly { // Cast aux without masking.
508             auxCasted := aux
509         }
510         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
511         _packedAddressData[owner] = packed;
512     }
513 
514     /**
515      * Returns the packed ownership data of `tokenId`.
516      */
517     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
518         uint256 curr = tokenId;
519 
520         unchecked {
521             if (_startTokenId() <= curr)
522                 if (curr < _currentIndex) {
523                     uint256 packed = _packedOwnerships[curr];
524                     // If not burned.
525                     if (packed & BITMASK_BURNED == 0) {
526                         // Invariant:
527                         // There will always be an ownership that has an address and is not burned
528                         // before an ownership that does not have an address and is not burned.
529                         // Hence, curr will not underflow.
530                         //
531                         // We can directly compare the packed value.
532                         // If the address is zero, packed is zero.
533                         while (packed == 0) {
534                             packed = _packedOwnerships[--curr];
535                         }
536                         return packed;
537                     }
538                 }
539         }
540         revert OwnerQueryForNonexistentToken();
541     }
542 
543     /**
544      * Returns the unpacked `TokenOwnership` struct from `packed`.
545      */
546     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
547         ownership.addr = address(uint160(packed));
548         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
549         ownership.burned = packed & BITMASK_BURNED != 0;
550     }
551 
552     /**
553      * Returns the unpacked `TokenOwnership` struct at `index`.
554      */
555     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
556         return _unpackedOwnership(_packedOwnerships[index]);
557     }
558 
559     /**
560      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
561      */
562     function _initializeOwnershipAt(uint256 index) internal {
563         if (_packedOwnerships[index] == 0) {
564             _packedOwnerships[index] = _packedOwnershipOf(index);
565         }
566     }
567 
568     /**
569      * Gas spent here starts off proportional to the maximum mint batch size.
570      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
571      */
572     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
573         return _unpackedOwnership(_packedOwnershipOf(tokenId));
574     }
575 
576     /**
577      * @dev See {IERC721-ownerOf}.
578      */
579     function ownerOf(uint256 tokenId) public view override returns (address) {
580         return address(uint160(_packedOwnershipOf(tokenId)));
581     }
582 
583     /**
584      * @dev See {IERC721Metadata-name}.
585      */
586     function name() public view virtual override returns (string memory) {
587         return _name;
588     }
589 
590     /**
591      * @dev See {IERC721Metadata-symbol}.
592      */
593     function symbol() public view virtual override returns (string memory) {
594         return _symbol;
595     }
596 
597     /**
598      * @dev See {IERC721Metadata-tokenURI}.
599      */
600     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
601         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
602 
603         string memory baseURI = _baseURI();
604         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
605     }
606 
607     /**
608      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
609      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
610      * by default, can be overriden in child contracts.
611      */
612     function _baseURI() internal view virtual returns (string memory) {
613         return '';
614     }
615 
616     /**
617      * @dev Casts the address to uint256 without masking.
618      */
619     function _addressToUint256(address value) private pure returns (uint256 result) {
620         assembly {
621             result := value
622         }
623     }
624 
625     /**
626      * @dev Casts the boolean to uint256 without branching.
627      */
628     function _boolToUint256(bool value) private pure returns (uint256 result) {
629         assembly {
630             result := value
631         }
632     }
633 
634     /**
635      * @dev See {IERC721-approve}.
636      */
637     function approve(address to, uint256 tokenId) public override {
638         address owner = address(uint160(_packedOwnershipOf(tokenId)));
639         if (to == owner) revert ApprovalToCurrentOwner();
640 
641         if (_msgSenderERC721A() != owner)
642             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
643                 revert ApprovalCallerNotOwnerNorApproved();
644             }
645 
646         _tokenApprovals[tokenId] = to;
647         emit Approval(owner, to, tokenId);
648     }
649 
650     /**
651      * @dev See {IERC721-getApproved}.
652      */
653     function getApproved(uint256 tokenId) public view override returns (address) {
654         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
655 
656         return _tokenApprovals[tokenId];
657     }
658 
659     /**
660      * @dev See {IERC721-setApprovalForAll}.
661      */
662     function setApprovalForAll(address operator, bool approved) public virtual override {
663         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
664 
665         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
666         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
667     }
668 
669     /**
670      * @dev See {IERC721-isApprovedForAll}.
671      */
672     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
673         return _operatorApprovals[owner][operator];
674     }
675 
676     /**
677      * @dev See {IERC721-transferFrom}.
678      */
679     function transferFrom(
680         address from,
681         address to,
682         uint256 tokenId
683     ) public virtual override {
684         _transfer(from, to, tokenId);
685     }
686 
687     /**
688      * @dev See {IERC721-safeTransferFrom}.
689      */
690     function safeTransferFrom(
691         address from,
692         address to,
693         uint256 tokenId
694     ) public virtual override {
695         safeTransferFrom(from, to, tokenId, '');
696     }
697 
698     /**
699      * @dev See {IERC721-safeTransferFrom}.
700      */
701     function safeTransferFrom(
702         address from,
703         address to,
704         uint256 tokenId,
705         bytes memory _data
706     ) public virtual override {
707         _transfer(from, to, tokenId);
708         if (to.code.length != 0)
709             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
710                 revert TransferToNonERC721ReceiverImplementer();
711             }
712     }
713 
714     /**
715      * @dev Returns whether `tokenId` exists.
716      *
717      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
718      *
719      * Tokens start existing when they are minted (`_mint`),
720      */
721     function _exists(uint256 tokenId) internal view returns (bool) {
722         return
723             _startTokenId() <= tokenId &&
724             tokenId < _currentIndex && // If within bounds,
725             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
726     }
727 
728     /**
729      * @dev Equivalent to `_safeMint(to, quantity, '')`.
730      */
731     function _safeMint(address to, uint256 quantity) internal {
732         _safeMint(to, quantity, '');
733     }
734 
735     /**
736      * @dev Safely mints `quantity` tokens and transfers them to `to`.
737      *
738      * Requirements:
739      *
740      * - If `to` refers to a smart contract, it must implement
741      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
742      * - `quantity` must be greater than 0.
743      *
744      * Emits a {Transfer} event.
745      */
746     function _safeMint(
747         address to,
748         uint256 quantity,
749         bytes memory _data
750     ) internal {
751         uint256 startTokenId = _currentIndex;
752         if (to == address(0)) revert MintToZeroAddress();
753         if (quantity == 0) revert MintZeroQuantity();
754 
755         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
756 
757         // Overflows are incredibly unrealistic.
758         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
759         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
760         unchecked {
761             // Updates:
762             // - `balance += quantity`.
763             // - `numberMinted += quantity`.
764             //
765             // We can directly add to the balance and number minted.
766             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
767 
768             // Updates:
769             // - `address` to the owner.
770             // - `startTimestamp` to the timestamp of minting.
771             // - `burned` to `false`.
772             // - `nextInitialized` to `quantity == 1`.
773             _packedOwnerships[startTokenId] =
774                 _addressToUint256(to) |
775                 (block.timestamp << BITPOS_START_TIMESTAMP) |
776                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
777 
778             uint256 updatedIndex = startTokenId;
779             uint256 end = updatedIndex + quantity;
780 
781             if (to.code.length != 0) {
782                 do {
783                     emit Transfer(address(0), to, updatedIndex);
784                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
785                         revert TransferToNonERC721ReceiverImplementer();
786                     }
787                 } while (updatedIndex < end);
788                 // Reentrancy protection
789                 if (_currentIndex != startTokenId) revert();
790             } else {
791                 do {
792                     emit Transfer(address(0), to, updatedIndex++);
793                 } while (updatedIndex < end);
794             }
795             _currentIndex = updatedIndex;
796         }
797         _afterTokenTransfers(address(0), to, startTokenId, quantity);
798     }
799 
800     /**
801      * @dev Mints `quantity` tokens and transfers them to `to`.
802      *
803      * Requirements:
804      *
805      * - `to` cannot be the zero address.
806      * - `quantity` must be greater than 0.
807      *
808      * Emits a {Transfer} event.
809      */
810     function _mint(address to, uint256 quantity) internal {
811         uint256 startTokenId = _currentIndex;
812         if (to == address(0)) revert MintToZeroAddress();
813         if (quantity == 0) revert MintZeroQuantity();
814 
815         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
816 
817         // Overflows are incredibly unrealistic.
818         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
819         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
820         unchecked {
821             // Updates:
822             // - `balance += quantity`.
823             // - `numberMinted += quantity`.
824             //
825             // We can directly add to the balance and number minted.
826             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
827 
828             // Updates:
829             // - `address` to the owner.
830             // - `startTimestamp` to the timestamp of minting.
831             // - `burned` to `false`.
832             // - `nextInitialized` to `quantity == 1`.
833             _packedOwnerships[startTokenId] =
834                 _addressToUint256(to) |
835                 (block.timestamp << BITPOS_START_TIMESTAMP) |
836                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
837 
838             uint256 updatedIndex = startTokenId;
839             uint256 end = updatedIndex + quantity;
840 
841             do {
842                 emit Transfer(address(0), to, updatedIndex++);
843             } while (updatedIndex < end);
844 
845             _currentIndex = updatedIndex;
846         }
847         _afterTokenTransfers(address(0), to, startTokenId, quantity);
848     }
849 
850     /**
851      * @dev Transfers `tokenId` from `from` to `to`.
852      *
853      * Requirements:
854      *
855      * - `to` cannot be the zero address.
856      * - `tokenId` token must be owned by `from`.
857      *
858      * Emits a {Transfer} event.
859      */
860     function _transfer(
861         address from,
862         address to,
863         uint256 tokenId
864     ) private {
865         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
866 
867         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
868 
869         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
870             isApprovedForAll(from, _msgSenderERC721A()) ||
871             getApproved(tokenId) == _msgSenderERC721A());
872 
873         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
874         if (to == address(0)) revert TransferToZeroAddress();
875 
876         _beforeTokenTransfers(from, to, tokenId, 1);
877 
878         // Clear approvals from the previous owner.
879         delete _tokenApprovals[tokenId];
880 
881         // Underflow of the sender's balance is impossible because we check for
882         // ownership above and the recipient's balance can't realistically overflow.
883         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
884         unchecked {
885             // We can directly increment and decrement the balances.
886             --_packedAddressData[from]; // Updates: `balance -= 1`.
887             ++_packedAddressData[to]; // Updates: `balance += 1`.
888 
889             // Updates:
890             // - `address` to the next owner.
891             // - `startTimestamp` to the timestamp of transfering.
892             // - `burned` to `false`.
893             // - `nextInitialized` to `true`.
894             _packedOwnerships[tokenId] =
895                 _addressToUint256(to) |
896                 (block.timestamp << BITPOS_START_TIMESTAMP) |
897                 BITMASK_NEXT_INITIALIZED;
898 
899             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
900             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
901                 uint256 nextTokenId = tokenId + 1;
902                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
903                 if (_packedOwnerships[nextTokenId] == 0) {
904                     // If the next slot is within bounds.
905                     if (nextTokenId != _currentIndex) {
906                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
907                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
908                     }
909                 }
910             }
911         }
912 
913         emit Transfer(from, to, tokenId);
914         _afterTokenTransfers(from, to, tokenId, 1);
915     }
916 
917     /**
918      * @dev Equivalent to `_burn(tokenId, false)`.
919      */
920     function _burn(uint256 tokenId) internal virtual {
921         _burn(tokenId, false);
922     }
923 
924     /**
925      * @dev Destroys `tokenId`.
926      * The approval is cleared when the token is burned.
927      *
928      * Requirements:
929      *
930      * - `tokenId` must exist.
931      *
932      * Emits a {Transfer} event.
933      */
934     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
935         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
936 
937         address from = address(uint160(prevOwnershipPacked));
938 
939         if (approvalCheck) {
940             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
941                 isApprovedForAll(from, _msgSenderERC721A()) ||
942                 getApproved(tokenId) == _msgSenderERC721A());
943 
944             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
945         }
946 
947         _beforeTokenTransfers(from, address(0), tokenId, 1);
948 
949         // Clear approvals from the previous owner.
950         delete _tokenApprovals[tokenId];
951 
952         // Underflow of the sender's balance is impossible because we check for
953         // ownership above and the recipient's balance can't realistically overflow.
954         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
955         unchecked {
956             // Updates:
957             // - `balance -= 1`.
958             // - `numberBurned += 1`.
959             //
960             // We can directly decrement the balance, and increment the number burned.
961             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
962             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
963 
964             // Updates:
965             // - `address` to the last owner.
966             // - `startTimestamp` to the timestamp of burning.
967             // - `burned` to `true`.
968             // - `nextInitialized` to `true`.
969             _packedOwnerships[tokenId] =
970                 _addressToUint256(from) |
971                 (block.timestamp << BITPOS_START_TIMESTAMP) |
972                 BITMASK_BURNED | 
973                 BITMASK_NEXT_INITIALIZED;
974 
975             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
976             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
977                 uint256 nextTokenId = tokenId + 1;
978                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
979                 if (_packedOwnerships[nextTokenId] == 0) {
980                     // If the next slot is within bounds.
981                     if (nextTokenId != _currentIndex) {
982                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
983                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
984                     }
985                 }
986             }
987         }
988 
989         emit Transfer(from, address(0), tokenId);
990         _afterTokenTransfers(from, address(0), tokenId, 1);
991 
992         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
993         unchecked {
994             _burnCounter++;
995         }
996     }
997 
998     /**
999      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1000      *
1001      * @param from address representing the previous owner of the given token ID
1002      * @param to target address that will receive the tokens
1003      * @param tokenId uint256 ID of the token to be transferred
1004      * @param _data bytes optional data to send along with the call
1005      * @return bool whether the call correctly returned the expected magic value
1006      */
1007     function _checkContractOnERC721Received(
1008         address from,
1009         address to,
1010         uint256 tokenId,
1011         bytes memory _data
1012     ) private returns (bool) {
1013         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1014             bytes4 retval
1015         ) {
1016             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1017         } catch (bytes memory reason) {
1018             if (reason.length == 0) {
1019                 revert TransferToNonERC721ReceiverImplementer();
1020             } else {
1021                 assembly {
1022                     revert(add(32, reason), mload(reason))
1023                 }
1024             }
1025         }
1026     }
1027 
1028     /**
1029      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1030      * And also called before burning one token.
1031      *
1032      * startTokenId - the first token id to be transferred
1033      * quantity - the amount to be transferred
1034      *
1035      * Calling conditions:
1036      *
1037      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1038      * transferred to `to`.
1039      * - When `from` is zero, `tokenId` will be minted for `to`.
1040      * - When `to` is zero, `tokenId` will be burned by `from`.
1041      * - `from` and `to` are never both zero.
1042      */
1043     function _beforeTokenTransfers(
1044         address from,
1045         address to,
1046         uint256 startTokenId,
1047         uint256 quantity
1048     ) internal virtual {}
1049 
1050     /**
1051      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1052      * minting.
1053      * And also called after one token has been burned.
1054      *
1055      * startTokenId - the first token id to be transferred
1056      * quantity - the amount to be transferred
1057      *
1058      * Calling conditions:
1059      *
1060      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1061      * transferred to `to`.
1062      * - When `from` is zero, `tokenId` has been minted for `to`.
1063      * - When `to` is zero, `tokenId` has been burned by `from`.
1064      * - `from` and `to` are never both zero.
1065      */
1066     function _afterTokenTransfers(
1067         address from,
1068         address to,
1069         uint256 startTokenId,
1070         uint256 quantity
1071     ) internal virtual {}
1072 
1073     /**
1074      * @dev Returns the message sender (defaults to `msg.sender`).
1075      *
1076      * If you are writing GSN compatible contracts, you need to override this function.
1077      */
1078     function _msgSenderERC721A() internal view virtual returns (address) {
1079         return msg.sender;
1080     }
1081 
1082     /**
1083      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1084      */
1085     function _toString(uint256 value) internal pure returns (string memory ptr) {
1086         assembly {
1087             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1088             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1089             // We will need 1 32-byte word to store the length, 
1090             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1091             ptr := add(mload(0x40), 128)
1092             // Update the free memory pointer to allocate.
1093             mstore(0x40, ptr)
1094 
1095             // Cache the end of the memory to calculate the length later.
1096             let end := ptr
1097 
1098             // We write the string from the rightmost digit to the leftmost digit.
1099             // The following is essentially a do-while loop that also handles the zero case.
1100             // Costs a bit more than early returning for the zero case,
1101             // but cheaper in terms of deployment and overall runtime costs.
1102             for { 
1103                 // Initialize and perform the first pass without check.
1104                 let temp := value
1105                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1106                 ptr := sub(ptr, 1)
1107                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1108                 mstore8(ptr, add(48, mod(temp, 10)))
1109                 temp := div(temp, 10)
1110             } temp { 
1111                 // Keep dividing `temp` until zero.
1112                 temp := div(temp, 10)
1113             } { // Body of the for loop.
1114                 ptr := sub(ptr, 1)
1115                 mstore8(ptr, add(48, mod(temp, 10)))
1116             }
1117             
1118             let length := sub(end, ptr)
1119             // Move the pointer 32 bytes leftwards to make room for the length.
1120             ptr := sub(ptr, 32)
1121             // Store the length.
1122             mstore(ptr, length)
1123         }
1124     }
1125 }
1126 
1127 
1128 /**
1129  * @title ERC721A Queryable
1130  * @dev ERC721A subclass with convenience query functions.
1131  */
1132 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1133     /**
1134      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1135      *
1136      * If the `tokenId` is out of bounds:
1137      *   - `addr` = `address(0)`
1138      *   - `startTimestamp` = `0`
1139      *   - `burned` = `false`
1140      *
1141      * If the `tokenId` is burned:
1142      *   - `addr` = `<Address of owner before token was burned>`
1143      *   - `startTimestamp` = `<Timestamp when token was burned>`
1144      *   - `burned = `true`
1145      *
1146      * Otherwise:
1147      *   - `addr` = `<Address of owner>`
1148      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1149      *   - `burned = `false`
1150      */
1151     function explicitOwnershipOf(uint256 tokenId) public view override returns (TokenOwnership memory) {
1152         TokenOwnership memory ownership;
1153         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1154             return ownership;
1155         }
1156         ownership = _ownershipAt(tokenId);
1157         if (ownership.burned) {
1158             return ownership;
1159         }
1160         return _ownershipOf(tokenId);
1161     }
1162 
1163     /**
1164      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1165      * See {ERC721AQueryable-explicitOwnershipOf}
1166      */
1167     function explicitOwnershipsOf(uint256[] memory tokenIds) external view override returns (TokenOwnership[] memory) {
1168         unchecked {
1169             uint256 tokenIdsLength = tokenIds.length;
1170             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1171             for (uint256 i; i != tokenIdsLength; ++i) {
1172                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1173             }
1174             return ownerships;
1175         }
1176     }
1177 
1178     /**
1179      * @dev Returns an array of token IDs owned by `owner`,
1180      * in the range [`start`, `stop`)
1181      * (i.e. `start <= tokenId < stop`).
1182      *
1183      * This function allows for tokens to be queried if the collection
1184      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1185      *
1186      * Requirements:
1187      *
1188      * - `start` < `stop`
1189      */
1190     function tokensOfOwnerIn(
1191         address owner,
1192         uint256 start,
1193         uint256 stop
1194     ) external view override returns (uint256[] memory) {
1195         unchecked {
1196             if (start >= stop) revert InvalidQueryRange();
1197             uint256 tokenIdsIdx;
1198             uint256 stopLimit = _nextTokenId();
1199             // Set `start = max(start, _startTokenId())`.
1200             if (start < _startTokenId()) {
1201                 start = _startTokenId();
1202             }
1203             // Set `stop = min(stop, stopLimit)`.
1204             if (stop > stopLimit) {
1205                 stop = stopLimit;
1206             }
1207             uint256 tokenIdsMaxLength = balanceOf(owner);
1208             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1209             // to cater for cases where `balanceOf(owner)` is too big.
1210             if (start < stop) {
1211                 uint256 rangeLength = stop - start;
1212                 if (rangeLength < tokenIdsMaxLength) {
1213                     tokenIdsMaxLength = rangeLength;
1214                 }
1215             } else {
1216                 tokenIdsMaxLength = 0;
1217             }
1218             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1219             if (tokenIdsMaxLength == 0) {
1220                 return tokenIds;
1221             }
1222             // We need to call `explicitOwnershipOf(start)`,
1223             // because the slot at `start` may not be initialized.
1224             TokenOwnership memory ownership = explicitOwnershipOf(start);
1225             address currOwnershipAddr;
1226             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1227             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1228             if (!ownership.burned) {
1229                 currOwnershipAddr = ownership.addr;
1230             }
1231             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1232                 ownership = _ownershipAt(i);
1233                 if (ownership.burned) {
1234                     continue;
1235                 }
1236                 if (ownership.addr != address(0)) {
1237                     currOwnershipAddr = ownership.addr;
1238                 }
1239                 if (currOwnershipAddr == owner) {
1240                     tokenIds[tokenIdsIdx++] = i;
1241                 }
1242             }
1243             // Downsize the array to fit.
1244             assembly {
1245                 mstore(tokenIds, tokenIdsIdx)
1246             }
1247             return tokenIds;
1248         }
1249     }
1250 
1251     /**
1252      * @dev Returns an array of token IDs owned by `owner`.
1253      *
1254      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1255      * It is meant to be called off-chain.
1256      *
1257      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1258      * multiple smaller scans if the collection is large enough to cause
1259      * an out-of-gas error (10K pfp collections should be fine).
1260      */
1261     function tokensOfOwner(address owner) external view override returns (uint256[] memory) {
1262         unchecked {
1263             uint256 tokenIdsIdx;
1264             address currOwnershipAddr;
1265             uint256 tokenIdsLength = balanceOf(owner);
1266             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1267             TokenOwnership memory ownership;
1268             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1269                 ownership = _ownershipAt(i);
1270                 if (ownership.burned) {
1271                     continue;
1272                 }
1273                 if (ownership.addr != address(0)) {
1274                     currOwnershipAddr = ownership.addr;
1275                 }
1276                 if (currOwnershipAddr == owner) {
1277                     tokenIds[tokenIdsIdx++] = i;
1278                 }
1279             }
1280             return tokenIds;
1281         }
1282     }
1283 }
1284 
1285 /**
1286  * @dev Provides information about the current execution context, including the
1287  * sender of the transaction and its data. While these are generally available
1288  * via msg.sender and msg.data, they should not be accessed in such a direct
1289  * manner, since when dealing with meta-transactions the account sending and
1290  * paying for execution may not be the actual sender (as far as an application
1291  * is concerned).
1292  *
1293  * This contract is only required for intermediate, library-like contracts.
1294  */
1295 abstract contract Context {
1296     function _msgSender() internal view virtual returns (address) {
1297         return msg.sender;
1298     }
1299 
1300     function _msgData() internal view virtual returns (bytes calldata) {
1301         return msg.data;
1302     }
1303 }
1304 
1305 
1306 /**
1307  * @dev Contract module which provides a basic access control mechanism, where
1308  * there is an account (an owner) that can be granted exclusive access to
1309  * specific functions.
1310  *
1311  * By default, the owner account will be the one that deploys the contract. This
1312  * can later be changed with {transferOwnership}.
1313  *
1314  * This module is used through inheritance. It will make available the modifier
1315  * `onlyOwner`, which can be applied to your functions to restrict their use to
1316  * the owner.
1317  */
1318 abstract contract Ownable is Context {
1319     address private _owner;
1320 
1321     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1322 
1323     /**
1324      * @dev Initializes the contract setting the deployer as the initial owner.
1325      */
1326     constructor() {
1327         _transferOwnership(_msgSender());
1328     }
1329 
1330     /**
1331      * @dev Returns the address of the current owner.
1332      */
1333     function owner() public view virtual returns (address) {
1334         return _owner;
1335     }
1336 
1337     /**
1338      * @dev Throws if called by any account other than the owner.
1339      */
1340     modifier onlyOwner() {
1341         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1342         _;
1343     }
1344 
1345     /**
1346      * @dev Leaves the contract without owner. It will not be possible to call
1347      * `onlyOwner` functions anymore. Can only be called by the current owner.
1348      *
1349      * NOTE: Renouncing ownership will leave the contract without an owner,
1350      * thereby removing any functionality that is only available to the owner.
1351      */
1352     function renounceOwnership() public virtual onlyOwner {
1353         _transferOwnership(address(0));
1354     }
1355 
1356     /**
1357      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1358      * Can only be called by the current owner.
1359      */
1360     function transferOwnership(address newOwner) public virtual onlyOwner {
1361         require(newOwner != address(0), "Ownable: new owner is the zero address");
1362         _transferOwnership(newOwner);
1363     }
1364 
1365     /**
1366      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1367      * Internal function without access restriction.
1368      */
1369     function _transferOwnership(address newOwner) internal virtual {
1370         address oldOwner = _owner;
1371         _owner = newOwner;
1372         emit OwnershipTransferred(oldOwner, newOwner);
1373     }
1374 }
1375 
1376 
1377 
1378 contract LuffyContract is ERC721AQueryable, Ownable {
1379 
1380   uint256 public MAX_Supply = 10000; // maximum supply is 10K.
1381   uint256 public publicMintFee = 0.04 ether; // public minting fees in ether.
1382 
1383   bool public revealed = false; // All Nfts revealed or not?
1384 
1385   string private baseUri; 
1386   string private unrevealedUri; // uri for unrevealed nfts.
1387   string private baseExtension = ".json";
1388 
1389   address public feeReceiver; // address for the fee receiver for the public mint.
1390 
1391   mapping(uint256 => bool) public revealedByTokenId; // to reveal some amount of nfts.
1392   mapping(address => uint256) public freeMintAllowed; // free Mint allowed for airdrops and all.
1393 
1394 
1395   // To check minting supply before Every mint. 
1396   modifier checkMintSupply(uint256 amount){
1397     require(totalSupply() + amount <= MAX_Supply, "Amount Exceeds Supply");
1398     _;
1399   }
1400 
1401   constructor(string memory baseUri_, string memory unrevealedUri_, address feeReceiver_) ERC721A("LUFFY OFFICIAL NFT", "LUFFYNFT") {
1402     baseUri = baseUri_;
1403     unrevealedUri = unrevealedUri_;
1404     feeReceiver = feeReceiver_;
1405   }
1406 
1407   function remainingSupply() public view returns(uint256) {
1408     return MAX_Supply - totalSupply();
1409   }
1410 
1411   function _startTokenId() internal pure override returns (uint256) {
1412     return 1;
1413   }
1414 
1415   function setBaseUri(string memory _baseUri) public onlyOwner {
1416     baseUri = _baseUri;
1417   }
1418 
1419   // Don't have to worry about it it is mandatory for the baseUri string to make tokenUri
1420   function _baseURI() internal view virtual override returns (string memory) {
1421       return baseUri;
1422   }
1423   
1424   // Function is to reveal all the nfts at one function call. No nfts can be unrevealed after calling this function.
1425   function revealAll() public onlyOwner {
1426     revealed = true;
1427   }
1428 
1429   // This is to reveal some nfts for some special cases if necessary.
1430   function revealByTokenId(uint256[] memory _tokenIds) public onlyOwner {
1431     for(uint i; i < _tokenIds.length; i++){
1432       revealedByTokenId[_tokenIds[i]] = true;
1433     }
1434   }
1435 
1436   // function to change public mint fee.
1437   function changePublicMintFee(uint256 _newFee) public onlyOwner {
1438     publicMintFee = _newFee;
1439   }
1440 
1441   //  function to give token uri this is an standard function which is modified to give the needed uri.
1442   function tokenURI(uint256 tokenId) public view virtual override(ERC721A, IERC721A) returns (string memory) {
1443     if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1444 
1445     string memory baseURI = _baseURI();
1446     return revealed || revealedByTokenId[tokenId] ? string(abi.encodePacked(baseURI, _toString(tokenId), baseExtension)) : unrevealedUri;
1447   }
1448 
1449   // This is for the owner mint.
1450   function adminMint(uint256 amount) public onlyOwner {
1451     require(totalSupply() + amount <= MAX_Supply, "Amount Exceed supply");
1452     _safeMint(msg.sender, amount);
1453   }
1454 
1455   // this is to free mint allowed by the owner for the airdrops and rewards.
1456   function freeMint(uint256 amount) public checkMintSupply(amount) {
1457     require(freeMintAllowed[msg.sender] >= amount, "Free allowed is less than amount");
1458     freeMintAllowed[msg.sender] -= amount;
1459     _safeMint(msg.sender, amount);
1460   }
1461 
1462   // This is to mint payed nfts.
1463   function publicMint(uint256 amount) public payable checkMintSupply(amount) {
1464     require((amount*publicMintFee) <= msg.value, "Insufficient Fee value");
1465     _safeMint(msg.sender, amount);
1466     payable(feeReceiver).transfer(msg.value);
1467   }
1468 
1469   // function to allow free Mints for airdrops and rewards.
1470   function allowFreeMint(address[] memory _addresses, uint256[] memory _amounts) public onlyOwner {
1471     require(_addresses.length== _amounts.length, "Length should be same");
1472     for(uint i; i < _addresses.length; i++){
1473       freeMintAllowed[_addresses[i]] = _amounts[i];
1474     }
1475   }
1476 
1477   // function to allow free Mints for airdrops and rewards.
1478   // Difference between this and the above function is.
1479   // This will add mint with the existing allowed mints.
1480   function addFreeMintAllowance(address[] memory _addresses, uint256[] memory _amounts) public onlyOwner {
1481     require(_addresses.length == _amounts.length, "Length should be same");
1482     for(uint i; i < _addresses.length; i++){
1483       freeMintAllowed[_addresses[i]] += _amounts[i];
1484     }
1485   }
1486 
1487 }