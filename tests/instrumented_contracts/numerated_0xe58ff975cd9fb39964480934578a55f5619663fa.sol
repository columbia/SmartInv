1 pragma solidity ^0.8.0;
2 
3 /**
4  * @dev Provides information about the current execution context, including the
5  * sender of the transaction and its data. While these are generally available
6  * via msg.sender and msg.data, they should not be accessed in such a direct
7  * manner, since when dealing with meta-transactions the account sending and
8  * paying for execution may not be the actual sender (as far as an application
9  * is concerned).
10  *
11  * This contract is only required for intermediate, library-like contracts.
12  */
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address) {
15         return msg.sender;
16     }
17 
18     function _msgData() internal view virtual returns (bytes calldata) {
19         return msg.data;
20     }
21 }
22 
23 
24 
25 
26 pragma solidity ^0.8.0;
27 
28 /**
29  * @dev Contract module which provides a basic access control mechanism, where
30  * there is an account (an owner) that can be granted exclusive access to
31  * specific functions.
32  *
33  * By default, the owner account will be the one that deploys the contract. This
34  * can later be changed with {transferOwnership}.
35  *
36  * This module is used through inheritance. It will make available the modifier
37  * `onlyOwner`, which can be applied to your functions to restrict their use to
38  * the owner.
39  */
40 abstract contract Ownable is Context {
41     address private _owner;
42 
43     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45     /**
46      * @dev Initializes the contract setting the deployer as the initial owner.
47      */
48     constructor() {
49         _transferOwnership(_msgSender());
50     }
51 
52     /**
53      * @dev Returns the address of the current owner.
54      */
55     function owner() public view virtual returns (address) {
56         return _owner;
57     }
58 
59     /**
60      * @dev Throws if called by any account other than the owner.
61      */
62     modifier onlyOwner() {
63         require(owner() == _msgSender(), "Ownable: caller is not the owner");
64         _;
65     }
66 
67     /**
68      * @dev Leaves the contract without owner. It will not be possible to call
69      * `onlyOwner` functions anymore. Can only be called by the current owner.
70      *
71      * NOTE: Renouncing ownership will leave the contract without an owner,
72      * thereby removing any functionality that is only available to the owner.
73      */
74     function renounceOwnership() public virtual onlyOwner {
75         _transferOwnership(address(0));
76     }
77 
78     /**
79      * @dev Transfers ownership of the contract to a new account (`newOwner`).
80      * Can only be called by the current owner.
81      */
82     function transferOwnership(address newOwner) public virtual onlyOwner {
83         require(newOwner != address(0), "Ownable: new owner is the zero address");
84         _transferOwnership(newOwner);
85     }
86 
87     /**
88      * @dev Transfers ownership of the contract to a new account (`newOwner`).
89      * Internal function without access restriction.
90      */
91     function _transferOwnership(address newOwner) internal virtual {
92         address oldOwner = _owner;
93         _owner = newOwner;
94         emit OwnershipTransferred(oldOwner, newOwner);
95     }
96 }
97 
98 
99 
100 
101 pragma solidity ^0.8.4;
102 
103 /**
104  * @dev Interface of an ERC721A compliant contract.
105  */
106 interface IERC721A {
107     /**
108      * The caller must own the token or be an approved operator.
109      */
110     error ApprovalCallerNotOwnerNorApproved();
111 
112     /**
113      * The token does not exist.
114      */
115     error ApprovalQueryForNonexistentToken();
116 
117     /**
118      * The caller cannot approve to their own address.
119      */
120     error ApproveToCaller();
121 
122     /**
123      * Cannot query the balance for the zero address.
124      */
125     error BalanceQueryForZeroAddress();
126 
127     /**
128      * Cannot mint to the zero address.
129      */
130     error MintToZeroAddress();
131 
132     /**
133      * The quantity of tokens minted must be more than zero.
134      */
135     error MintZeroQuantity();
136 
137     /**
138      * The token does not exist.
139      */
140     error OwnerQueryForNonexistentToken();
141 
142     /**
143      * The caller must own the token or be an approved operator.
144      */
145     error TransferCallerNotOwnerNorApproved();
146 
147     /**
148      * The token must be owned by `from`.
149      */
150     error TransferFromIncorrectOwner();
151 
152     /**
153      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
154      */
155     error TransferToNonERC721ReceiverImplementer();
156 
157     /**
158      * Cannot transfer to the zero address.
159      */
160     error TransferToZeroAddress();
161 
162     /**
163      * The token does not exist.
164      */
165     error URIQueryForNonexistentToken();
166 
167     /**
168      * The `quantity` minted with ERC2309 exceeds the safety limit.
169      */
170     error MintERC2309QuantityExceedsLimit();
171 
172     /**
173      * The `extraData` cannot be set on an unintialized ownership slot.
174      */
175     error OwnershipNotInitializedForExtraData();
176 
177     struct TokenOwnership {
178         address addr;
179         uint64 startTimestamp;
180         bool burned;
181         uint24 extraData;
182     }
183 
184     /**
185      * @dev Returns the total amount of tokens stored by the contract.
186      *
187      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
188      */
189     function totalSupply() external view returns (uint256);
190 
191 
192     /**
193      * @dev Returns true if this contract implements the interface defined by
194      * `interfaceId`. See the corresponding
195      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
196      * to learn more about how these ids are created.
197      *
198      * This function call must use less than 30 000 gas.
199      */
200     function supportsInterface(bytes4 interfaceId) external view returns (bool);
201 
202 
203     /**
204      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
205      */
206     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
207 
208     /**
209      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
210      */
211     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
212 
213     /**
214      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
215      */
216     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
217 
218     /**
219      * @dev Returns the number of tokens in ``owner``'s account.
220      */
221     function balanceOf(address owner) external view returns (uint256 balance);
222 
223     /**
224      * @dev Returns the owner of the `tokenId` token.
225      *
226      * Requirements:
227      *
228      * - `tokenId` must exist.
229      */
230     function ownerOf(uint256 tokenId) external view returns (address owner);
231 
232     /**
233      * @dev Safely transfers `tokenId` token from `from` to `to`.
234      *
235      * Requirements:
236      *
237      * - `from` cannot be the zero address.
238      * - `to` cannot be the zero address.
239      * - `tokenId` token must exist and be owned by `from`.
240      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
241      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
242      *
243      * Emits a {Transfer} event.
244      */
245     function safeTransferFrom(
246         address from,
247         address to,
248         uint256 tokenId,
249         bytes calldata data
250     ) external;
251 
252     /**
253      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
254      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
255      *
256      * Requirements:
257      *
258      * - `from` cannot be the zero address.
259      * - `to` cannot be the zero address.
260      * - `tokenId` token must exist and be owned by `from`.
261      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
262      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
263      *
264      * Emits a {Transfer} event.
265      */
266     function safeTransferFrom(
267         address from,
268         address to,
269         uint256 tokenId
270     ) external;
271 
272     /**
273      * @dev Transfers `tokenId` token from `from` to `to`.
274      *
275      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
276      *
277      * Requirements:
278      *
279      * - `from` cannot be the zero address.
280      * - `to` cannot be the zero address.
281      * - `tokenId` token must be owned by `from`.
282      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
283      *
284      * Emits a {Transfer} event.
285      */
286     function transferFrom(
287         address from,
288         address to,
289         uint256 tokenId
290     ) external;
291 
292     /**
293      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
294      * The approval is cleared when the token is transferred.
295      *
296      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
297      *
298      * Requirements:
299      *
300      * - The caller must own the token or be an approved operator.
301      * - `tokenId` must exist.
302      *
303      * Emits an {Approval} event.
304      */
305     function approve(address to, uint256 tokenId) external;
306 
307     /**
308      * @dev Approve or remove `operator` as an operator for the caller.
309      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
310      *
311      * Requirements:
312      *
313      * - The `operator` cannot be the caller.
314      *
315      * Emits an {ApprovalForAll} event.
316      */
317     function setApprovalForAll(address operator, bool _approved) external;
318 
319     /**
320      * @dev Returns the account approved for `tokenId` token.
321      *
322      * Requirements:
323      *
324      * - `tokenId` must exist.
325      */
326     function getApproved(uint256 tokenId) external view returns (address operator);
327 
328     /**
329      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
330      *
331      * See {setApprovalForAll}
332      */
333     function isApprovedForAll(address owner, address operator) external view returns (bool);
334 
335 
336     /**
337      * @dev Returns the token collection name.
338      */
339     function name() external view returns (string memory);
340 
341     /**
342      * @dev Returns the token collection symbol.
343      */
344     function symbol() external view returns (string memory);
345 
346     /**
347      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
348      */
349     function tokenURI(uint256 tokenId) external view returns (string memory);
350 
351 
352     /**
353      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
354      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
355      */
356     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
357 }
358 
359 
360 
361 
362 pragma solidity ^0.8.4;
363 
364 /**
365  * @dev ERC721 token receiver interface.
366  */
367 interface ERC721A__IERC721Receiver {
368     function onERC721Received(
369         address operator,
370         address from,
371         uint256 tokenId,
372         bytes calldata data
373     ) external returns (bytes4);
374 }
375 
376 /**
377  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
378  * including the Metadata extension. Built to optimize for lower gas during batch mints.
379  *
380  * Assumes serials are sequentially minted starting at `_startTokenId()`
381  * (defaults to 0, e.g. 0, 1, 2, 3..).
382  *
383  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
384  *
385  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
386  */
387 contract ERC721A is IERC721A {
388     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
389 
390     uint256 private constant BITPOS_NUMBER_MINTED = 64;
391 
392     uint256 private constant BITPOS_NUMBER_BURNED = 128;
393 
394     uint256 private constant BITPOS_AUX = 192;
395 
396     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
397 
398     uint256 private constant BITPOS_START_TIMESTAMP = 160;
399 
400     uint256 private constant BITMASK_BURNED = 1 << 224;
401 
402     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
403 
404     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
405 
406     uint256 private constant BITPOS_EXTRA_DATA = 232;
407 
408     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
409 
410     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
411 
412     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
413 
414     uint256 private _currentIndex;
415 
416     uint256 private _burnCounter;
417 
418     string private _name;
419 
420     string private _symbol;
421 
422     mapping(uint256 => uint256) private _packedOwnerships;
423 
424     mapping(address => uint256) private _packedAddressData;
425 
426     mapping(uint256 => address) private _tokenApprovals;
427 
428     mapping(address => mapping(address => bool)) private _operatorApprovals;
429 
430     constructor(string memory name_, string memory symbol_) {
431         _name = name_;
432         _symbol = symbol_;
433         _currentIndex = _startTokenId();
434     }
435 
436     /**
437      * @dev Returns the starting token ID.
438      * To change the starting token ID, please override this function.
439      */
440     function _startTokenId() internal view virtual returns (uint256) {
441         return 0;
442     }
443 
444     /**
445      * @dev Returns the next token ID to be minted.
446      */
447     function _nextTokenId() internal view returns (uint256) {
448         return _currentIndex;
449     }
450 
451     /**
452      * @dev Returns the total number of tokens in existence.
453      * Burned tokens will reduce the count.
454      * To get the total number of tokens minted, please see `_totalMinted`.
455      */
456     function totalSupply() public view override returns (uint256) {
457         unchecked {
458             return _currentIndex - _burnCounter - _startTokenId();
459         }
460     }
461 
462     /**
463      * @dev Returns the total amount of tokens minted in the contract.
464      */
465     function _totalMinted() internal view returns (uint256) {
466         unchecked {
467             return _currentIndex - _startTokenId();
468         }
469     }
470 
471     /**
472      * @dev Returns the total number of tokens burned.
473      */
474     function _totalBurned() internal view returns (uint256) {
475         return _burnCounter;
476     }
477 
478     /**
479      * @dev See {IERC165-supportsInterface}.
480      */
481     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
482         return
483             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
484             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
485             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
486     }
487 
488     /**
489      * @dev See {IERC721-balanceOf}.
490      */
491     function balanceOf(address owner) public view override returns (uint256) {
492         if (owner == address(0)) revert BalanceQueryForZeroAddress();
493         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
494     }
495 
496     /**
497      * Returns the number of tokens minted by `owner`.
498      */
499     function _numberMinted(address owner) internal view returns (uint256) {
500         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
501     }
502 
503     /**
504      * Returns the number of tokens burned by or on behalf of `owner`.
505      */
506     function _numberBurned(address owner) internal view returns (uint256) {
507         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
508     }
509 
510     /**
511      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
512      */
513     function _getAux(address owner) internal view returns (uint64) {
514         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
515     }
516 
517     /**
518      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
519      * If there are multiple variables, please pack them into a uint64.
520      */
521     function _setAux(address owner, uint64 aux) internal {
522         uint256 packed = _packedAddressData[owner];
523         uint256 auxCasted;
524         assembly {
525             auxCasted := aux
526         }
527         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
528         _packedAddressData[owner] = packed;
529     }
530 
531     /**
532      * Returns the packed ownership data of `tokenId`.
533      */
534     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
535         uint256 curr = tokenId;
536 
537         unchecked {
538             if (_startTokenId() <= curr)
539                 if (curr < _currentIndex) {
540                     uint256 packed = _packedOwnerships[curr];
541                     if (packed & BITMASK_BURNED == 0) {
542                         while (packed == 0) {
543                             packed = _packedOwnerships[--curr];
544                         }
545                         return packed;
546                     }
547                 }
548         }
549         revert OwnerQueryForNonexistentToken();
550     }
551 
552     /**
553      * Returns the unpacked `TokenOwnership` struct from `packed`.
554      */
555     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
556         ownership.addr = address(uint160(packed));
557         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
558         ownership.burned = packed & BITMASK_BURNED != 0;
559         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
560     }
561 
562     /**
563      * Returns the unpacked `TokenOwnership` struct at `index`.
564      */
565     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
566         return _unpackedOwnership(_packedOwnerships[index]);
567     }
568 
569     /**
570      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
571      */
572     function _initializeOwnershipAt(uint256 index) internal {
573         if (_packedOwnerships[index] == 0) {
574             _packedOwnerships[index] = _packedOwnershipOf(index);
575         }
576     }
577 
578     /**
579      * Gas spent here starts off proportional to the maximum mint batch size.
580      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
581      */
582     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
583         return _unpackedOwnership(_packedOwnershipOf(tokenId));
584     }
585 
586     /**
587      * @dev Packs ownership data into a single uint256.
588      */
589     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
590         assembly {
591             owner := and(owner, BITMASK_ADDRESS)
592             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
593         }
594     }
595 
596     /**
597      * @dev See {IERC721-ownerOf}.
598      */
599     function ownerOf(uint256 tokenId) public view override returns (address) {
600         return address(uint160(_packedOwnershipOf(tokenId)));
601     }
602 
603     /**
604      * @dev See {IERC721Metadata-name}.
605      */
606     function name() public view virtual override returns (string memory) {
607         return _name;
608     }
609 
610     /**
611      * @dev See {IERC721Metadata-symbol}.
612      */
613     function symbol() public view virtual override returns (string memory) {
614         return _symbol;
615     }
616 
617     /**
618      * @dev See {IERC721Metadata-tokenURI}.
619      */
620     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
621         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
622 
623         string memory baseURI = _baseURI();
624         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
625     }
626 
627     /**
628      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
629      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
630      * by default, it can be overridden in child contracts.
631      */
632     function _baseURI() internal view virtual returns (string memory) {
633         return '';
634     }
635 
636     /**
637      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
638      */
639     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
640         assembly {
641             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
642         }
643     }
644 
645     /**
646      * @dev See {IERC721-approve}.
647      */
648     function approve(address to, uint256 tokenId) public override {
649         address owner = ownerOf(tokenId);
650 
651         if (_msgSenderERC721A() != owner)
652             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
653                 revert ApprovalCallerNotOwnerNorApproved();
654             }
655 
656         _tokenApprovals[tokenId] = to;
657         emit Approval(owner, to, tokenId);
658     }
659 
660     /**
661      * @dev See {IERC721-getApproved}.
662      */
663     function getApproved(uint256 tokenId) public view override returns (address) {
664         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
665 
666         return _tokenApprovals[tokenId];
667     }
668 
669     /**
670      * @dev See {IERC721-setApprovalForAll}.
671      */
672     function setApprovalForAll(address operator, bool approved) public virtual override {
673         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
674 
675         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
676         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
677     }
678 
679     /**
680      * @dev See {IERC721-isApprovedForAll}.
681      */
682     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
683         return _operatorApprovals[owner][operator];
684     }
685 
686     /**
687      * @dev See {IERC721-safeTransferFrom}.
688      */
689     function safeTransferFrom(
690         address from,
691         address to,
692         uint256 tokenId
693     ) public virtual override {
694         safeTransferFrom(from, to, tokenId, '');
695     }
696 
697     /**
698      * @dev See {IERC721-safeTransferFrom}.
699      */
700     function safeTransferFrom(
701         address from,
702         address to,
703         uint256 tokenId,
704         bytes memory _data
705     ) public virtual override {
706         transferFrom(from, to, tokenId);
707         if (to.code.length != 0)
708             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
709                 revert TransferToNonERC721ReceiverImplementer();
710             }
711     }
712 
713     /**
714      * @dev Returns whether `tokenId` exists.
715      *
716      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
717      *
718      * Tokens start existing when they are minted (`_mint`),
719      */
720     function _exists(uint256 tokenId) internal view returns (bool) {
721         return
722             _startTokenId() <= tokenId &&
723             tokenId < _currentIndex && // If within bounds,
724             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
725     }
726 
727     /**
728      * @dev Equivalent to `_safeMint(to, quantity, '')`.
729      */
730     function _safeMint(address to, uint256 quantity) internal {
731         _safeMint(to, quantity, '');
732     }
733 
734     /**
735      * @dev Safely mints `quantity` tokens and transfers them to `to`.
736      *
737      * Requirements:
738      *
739      * - If `to` refers to a smart contract, it must implement
740      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
741      * - `quantity` must be greater than 0.
742      *
743      * See {_mint}.
744      *
745      * Emits a {Transfer} event for each mint.
746      */
747     function _safeMint(
748         address to,
749         uint256 quantity,
750         bytes memory _data
751     ) internal {
752         _mint(to, quantity);
753 
754         unchecked {
755             if (to.code.length != 0) {
756                 uint256 end = _currentIndex;
757                 uint256 index = end - quantity;
758                 do {
759                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
760                         revert TransferToNonERC721ReceiverImplementer();
761                     }
762                 } while (index < end);
763                 if (_currentIndex != end) revert();
764             }
765         }
766     }
767 
768     /**
769      * @dev Mints `quantity` tokens and transfers them to `to`.
770      *
771      * Requirements:
772      *
773      * - `to` cannot be the zero address.
774      * - `quantity` must be greater than 0.
775      *
776      * Emits a {Transfer} event for each mint.
777      */
778     function _mint(address to, uint256 quantity) internal {
779         uint256 startTokenId = _currentIndex;
780         if (to == address(0)) revert MintToZeroAddress();
781         if (quantity == 0) revert MintZeroQuantity();
782 
783         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
784 
785         unchecked {
786             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
787 
788             _packedOwnerships[startTokenId] = _packOwnershipData(
789                 to,
790                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
791             );
792 
793             uint256 tokenId = startTokenId;
794             uint256 end = startTokenId + quantity;
795             do {
796                 emit Transfer(address(0), to, tokenId++);
797             } while (tokenId < end);
798 
799             _currentIndex = end;
800         }
801         _afterTokenTransfers(address(0), to, startTokenId, quantity);
802     }
803 
804     /**
805      * @dev Mints `quantity` tokens and transfers them to `to`.
806      *
807      * This function is intended for efficient minting only during contract creation.
808      *
809      * It emits only one {ConsecutiveTransfer} as defined in
810      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
811      * instead of a sequence of {Transfer} event(s).
812      *
813      * Calling this function outside of contract creation WILL make your contract
814      * non-compliant with the ERC721 standard.
815      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
816      * {ConsecutiveTransfer} event is only permissible during contract creation.
817      *
818      * Requirements:
819      *
820      * - `to` cannot be the zero address.
821      * - `quantity` must be greater than 0.
822      *
823      * Emits a {ConsecutiveTransfer} event.
824      */
825     function _mintERC2309(address to, uint256 quantity) internal {
826         uint256 startTokenId = _currentIndex;
827         if (to == address(0)) revert MintToZeroAddress();
828         if (quantity == 0) revert MintZeroQuantity();
829         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
830 
831         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
832 
833         unchecked {
834             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
835 
836             _packedOwnerships[startTokenId] = _packOwnershipData(
837                 to,
838                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
839             );
840 
841             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
842 
843             _currentIndex = startTokenId + quantity;
844         }
845         _afterTokenTransfers(address(0), to, startTokenId, quantity);
846     }
847 
848     /**
849      * @dev Returns the storage slot and value for the approved address of `tokenId`.
850      */
851     function _getApprovedAddress(uint256 tokenId)
852         private
853         view
854         returns (uint256 approvedAddressSlot, address approvedAddress)
855     {
856         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
857         assembly {
858             mstore(0x00, tokenId)
859             mstore(0x20, tokenApprovalsPtr.slot)
860             approvedAddressSlot := keccak256(0x00, 0x40)
861             approvedAddress := sload(approvedAddressSlot)
862         }
863     }
864 
865     /**
866      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
867      */
868     function _isOwnerOrApproved(
869         address approvedAddress,
870         address from,
871         address msgSender
872     ) private pure returns (bool result) {
873         assembly {
874             from := and(from, BITMASK_ADDRESS)
875             msgSender := and(msgSender, BITMASK_ADDRESS)
876             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
877         }
878     }
879 
880     /**
881      * @dev Transfers `tokenId` from `from` to `to`.
882      *
883      * Requirements:
884      *
885      * - `to` cannot be the zero address.
886      * - `tokenId` token must be owned by `from`.
887      *
888      * Emits a {Transfer} event.
889      */
890     function transferFrom(
891         address from,
892         address to,
893         uint256 tokenId
894     ) public virtual override {
895         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
896 
897         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
898 
899         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
900 
901         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
902             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
903 
904         if (to == address(0)) revert TransferToZeroAddress();
905 
906         _beforeTokenTransfers(from, to, tokenId, 1);
907 
908         assembly {
909             if approvedAddress {
910                 sstore(approvedAddressSlot, 0)
911             }
912         }
913 
914         unchecked {
915             --_packedAddressData[from]; // Updates: `balance -= 1`.
916             ++_packedAddressData[to]; // Updates: `balance += 1`.
917 
918             _packedOwnerships[tokenId] = _packOwnershipData(
919                 to,
920                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
921             );
922 
923             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
924                 uint256 nextTokenId = tokenId + 1;
925                 if (_packedOwnerships[nextTokenId] == 0) {
926                     if (nextTokenId != _currentIndex) {
927                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
928                     }
929                 }
930             }
931         }
932 
933         emit Transfer(from, to, tokenId);
934         _afterTokenTransfers(from, to, tokenId, 1);
935     }
936 
937     /**
938      * @dev Equivalent to `_burn(tokenId, false)`.
939      */
940     function _burn(uint256 tokenId) internal virtual {
941         _burn(tokenId, false);
942     }
943 
944     /**
945      * @dev Destroys `tokenId`.
946      * The approval is cleared when the token is burned.
947      *
948      * Requirements:
949      *
950      * - `tokenId` must exist.
951      *
952      * Emits a {Transfer} event.
953      */
954     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
955         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
956 
957         address from = address(uint160(prevOwnershipPacked));
958 
959         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
960 
961         if (approvalCheck) {
962             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
963                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
964         }
965 
966         _beforeTokenTransfers(from, address(0), tokenId, 1);
967 
968         assembly {
969             if approvedAddress {
970                 sstore(approvedAddressSlot, 0)
971             }
972         }
973 
974         unchecked {
975             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
976 
977             _packedOwnerships[tokenId] = _packOwnershipData(
978                 from,
979                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
980             );
981 
982             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
983                 uint256 nextTokenId = tokenId + 1;
984                 if (_packedOwnerships[nextTokenId] == 0) {
985                     if (nextTokenId != _currentIndex) {
986                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
987                     }
988                 }
989             }
990         }
991 
992         emit Transfer(from, address(0), tokenId);
993         _afterTokenTransfers(from, address(0), tokenId, 1);
994 
995         unchecked {
996             _burnCounter++;
997         }
998     }
999 
1000     /**
1001      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1002      *
1003      * @param from address representing the previous owner of the given token ID
1004      * @param to target address that will receive the tokens
1005      * @param tokenId uint256 ID of the token to be transferred
1006      * @param _data bytes optional data to send along with the call
1007      * @return bool whether the call correctly returned the expected magic value
1008      */
1009     function _checkContractOnERC721Received(
1010         address from,
1011         address to,
1012         uint256 tokenId,
1013         bytes memory _data
1014     ) private returns (bool) {
1015         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1016             bytes4 retval
1017         ) {
1018             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1019         } catch (bytes memory reason) {
1020             if (reason.length == 0) {
1021                 revert TransferToNonERC721ReceiverImplementer();
1022             } else {
1023                 assembly {
1024                     revert(add(32, reason), mload(reason))
1025                 }
1026             }
1027         }
1028     }
1029 
1030     /**
1031      * @dev Directly sets the extra data for the ownership data `index`.
1032      */
1033     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1034         uint256 packed = _packedOwnerships[index];
1035         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1036         uint256 extraDataCasted;
1037         assembly {
1038             extraDataCasted := extraData
1039         }
1040         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1041         _packedOwnerships[index] = packed;
1042     }
1043 
1044     /**
1045      * @dev Returns the next extra data for the packed ownership data.
1046      * The returned result is shifted into position.
1047      */
1048     function _nextExtraData(
1049         address from,
1050         address to,
1051         uint256 prevOwnershipPacked
1052     ) private view returns (uint256) {
1053         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1054         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1055     }
1056 
1057     /**
1058      * @dev Called during each token transfer to set the 24bit `extraData` field.
1059      * Intended to be overridden by the cosumer contract.
1060      *
1061      * `previousExtraData` - the value of `extraData` before transfer.
1062      *
1063      * Calling conditions:
1064      *
1065      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1066      * transferred to `to`.
1067      * - When `from` is zero, `tokenId` will be minted for `to`.
1068      * - When `to` is zero, `tokenId` will be burned by `from`.
1069      * - `from` and `to` are never both zero.
1070      */
1071     function _extraData(
1072         address from,
1073         address to,
1074         uint24 previousExtraData
1075     ) internal view virtual returns (uint24) {}
1076 
1077     /**
1078      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1079      * This includes minting.
1080      * And also called before burning one token.
1081      *
1082      * startTokenId - the first token id to be transferred
1083      * quantity - the amount to be transferred
1084      *
1085      * Calling conditions:
1086      *
1087      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1088      * transferred to `to`.
1089      * - When `from` is zero, `tokenId` will be minted for `to`.
1090      * - When `to` is zero, `tokenId` will be burned by `from`.
1091      * - `from` and `to` are never both zero.
1092      */
1093     function _beforeTokenTransfers(
1094         address from,
1095         address to,
1096         uint256 startTokenId,
1097         uint256 quantity
1098     ) internal virtual {}
1099 
1100     /**
1101      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1102      * This includes minting.
1103      * And also called after one token has been burned.
1104      *
1105      * startTokenId - the first token id to be transferred
1106      * quantity - the amount to be transferred
1107      *
1108      * Calling conditions:
1109      *
1110      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1111      * transferred to `to`.
1112      * - When `from` is zero, `tokenId` has been minted for `to`.
1113      * - When `to` is zero, `tokenId` has been burned by `from`.
1114      * - `from` and `to` are never both zero.
1115      */
1116     function _afterTokenTransfers(
1117         address from,
1118         address to,
1119         uint256 startTokenId,
1120         uint256 quantity
1121     ) internal virtual {}
1122 
1123     /**
1124      * @dev Returns the message sender (defaults to `msg.sender`).
1125      *
1126      * If you are writing GSN compatible contracts, you need to override this function.
1127      */
1128     function _msgSenderERC721A() internal view virtual returns (address) {
1129         return msg.sender;
1130     }
1131 
1132     /**
1133      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1134      */
1135     function _toString(uint256 value) internal pure returns (string memory ptr) {
1136         assembly {
1137             ptr := add(mload(0x40), 128)
1138             mstore(0x40, ptr)
1139 
1140             let end := ptr
1141 
1142             for {
1143                 let temp := value
1144                 ptr := sub(ptr, 1)
1145                 mstore8(ptr, add(48, mod(temp, 10)))
1146                 temp := div(temp, 10)
1147             } temp {
1148                 temp := div(temp, 10)
1149             } {
1150                 ptr := sub(ptr, 1)
1151                 mstore8(ptr, add(48, mod(temp, 10)))
1152             }
1153 
1154             let length := sub(end, ptr)
1155             ptr := sub(ptr, 32)
1156             mstore(ptr, length)
1157         }
1158     }
1159 }
1160 
1161 
1162 
1163 /**
1164    ______ ____   ______ ___   ______ ____   ____   __     ___     ____ 
1165   / ____// __ \ / ____//   | /_  __// __ \ / __ \ / /    /   |   / __ )
1166  / /    / /_/ // __/  / /| |  / /  / / / // /_/ // /    / /| |  / __  |
1167 / /___ / _, _// /___ / ___ | / /  / /_/ // _, _// /___ / ___ | / /_/ / 
1168 \____//_/ |_|/_____//_/  |_|/_/   \____//_/ |_|/_____//_/  |_|/_____/  
1169                                                                                                                                                        
1170  */
1171 
1172 pragma solidity ^0.8.4;
1173 
1174 
1175 contract ToiletSocietyNFT is Ownable, ERC721A {
1176     string public constant uriSuffix = ".json";
1177     uint256 public constant collectionSize = 1001;
1178     uint256 public constant maxPerAddressDuringMint = 3;
1179     string private _baseTokenURI = "ipfs://bafybeib67o4eo3cqgx7x7zjbck2gbaxphsevqfnr3dxjohuerxg5wyjh6e/";
1180     
1181     uint256 public amountForDevs = 69;
1182             
1183     uint32 public publicSaleStartTime = 1657807200;
1184     uint256 public publicPrice = 0 ether; 
1185     uint256 public amountForPublic = 432;
1186     
1187     
1188     constructor() ERC721A("ToiletSocietyNFT", "ToiletPoop") {}
1189 
1190     modifier callerIsUser() {
1191         require(tx.origin == msg.sender, "The caller is another contract");
1192         _;
1193     }
1194 
1195     function devMint(uint256 quantity_) external onlyOwner {
1196         uint256 maxPerAddressDuringMint_ = maxPerAddressDuringMint;
1197         uint256 amountForDevs_ = amountForDevs;
1198         require(
1199             quantity_ <= amountForDevs_,
1200             "The quantity exceeds the remaining amount for Dev Mint."
1201         );
1202         require(
1203             quantity_ % maxPerAddressDuringMint_ == 0,
1204             "Can only dev mint a multiple of the maxPerAddressDuringMint"
1205         );
1206         amountForDevs = amountForDevs_ - quantity_;
1207         uint256 numChunks = quantity_ / maxPerAddressDuringMint_;
1208         for (uint256 i = 0; i < numChunks; i++) {
1209             _safeMint(msg.sender, maxPerAddressDuringMint_);
1210         }
1211     }
1212 
1213     function setAmountForDevs(uint256 amountForDevs_) external onlyOwner {
1214         require(
1215             amountForDevs_ % maxPerAddressDuringMint == 0,
1216             "Amount for Dev Mint must be a multiple of the maxPerAddressDuringMint"
1217         );
1218         require(
1219             _totalMinted() + amountForDevs_ + amountForPublic <= collectionSize,
1220             "The total amount set up for all minting cannot exceed collectionSize."
1221         ); 
1222         amountForDevs = amountForDevs_;
1223     }    
1224     
1225     
1226     function publicSaleMint(uint256 quantity_) external payable callerIsUser {
1227         uint256 publicSaleStartTime_ = uint256(publicSaleStartTime);
1228 
1229         require(
1230             block.timestamp >= publicSaleStartTime_, 
1231             "Public sale has not begun yet or has ended"
1232         );
1233 
1234         uint256 amountForPublic_ = amountForPublic;
1235         require(
1236             quantity_ <= amountForPublic_, 
1237             "The quantity exceeds the remaining amount for Public Mint."
1238         );
1239         require(
1240             quantity_ <= maxPerAddressDuringMint,
1241             "Can not mint more than maxPerAddressDuringMint"
1242         );
1243 
1244         amountForPublic = amountForPublic_ - quantity_;
1245         uint256 publicPrice_ = uint256(publicPrice);
1246         _refundIfOver(publicPrice_ * quantity_);
1247         _safeMint(msg.sender, quantity_);
1248     }    
1249 
1250     function setPublicPrice(uint256 publicPriceWei_) external onlyOwner {
1251         publicPrice = publicPriceWei_;
1252     }
1253 
1254     function setPublicSaleStartTime(uint32 timestamp_) external onlyOwner {
1255         publicSaleStartTime = timestamp_;
1256     }
1257 
1258     function setAmountForPublic(uint256 amountForPublic_) external onlyOwner {
1259         require(
1260             _totalMinted() + amountForPublic_ + amountForDevs <= collectionSize,
1261             "The total amount set up for all minting cannot exceed collectionSize."
1262         ); 
1263         amountForPublic = amountForPublic_;
1264     }    
1265     
1266     function _refundIfOver(uint256 price_) private {
1267         require(msg.value >= price_, "Need to send more ETH.");
1268         if (msg.value > price_) {
1269             payable(msg.sender).transfer(msg.value - price_);
1270         }
1271     }    
1272     
1273     function tokenURI(uint256 tokenId_) public view virtual override returns (string memory) {
1274         require(
1275             _exists(tokenId_),
1276             "ERC721AMetadata: URI query for nonexistant token"
1277         );
1278 
1279         string memory currentBaseURI_ = _baseURI();
1280         return
1281             bytes(currentBaseURI_).length > 0
1282                 ? string(
1283                     abi.encodePacked(
1284                         currentBaseURI_,
1285                         _toString(tokenId_),
1286                         uriSuffix
1287                     )
1288                 )
1289                 : "";
1290     }
1291 
1292     function _baseURI() internal view virtual override returns (string memory) {
1293         return _baseTokenURI;
1294     }
1295 
1296     function setBaseURI(string calldata baseURI_) external onlyOwner {
1297         _baseTokenURI = baseURI_;
1298     }
1299 
1300     function withdrawMoney(uint256 amount_) external onlyOwner {
1301         require(
1302             address(this).balance >= amount_,
1303             "Address: insufficient balance"
1304         );
1305         (bool toCreatorLab, ) = payable(0x2655B531038E9286616fD92a13B4D00219E1Bb36).call{value: (amount_ * 10 ) / 100}("");
1306         require(toCreatorLab);
1307 
1308         (bool success, ) = msg.sender.call{value: (amount_ * 90) / 100}(""); 
1309         require(success, "Transfer failed.");
1310     }
1311 
1312 }