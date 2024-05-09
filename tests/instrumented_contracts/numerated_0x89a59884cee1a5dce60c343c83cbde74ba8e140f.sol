1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 // Trippin Aliens Collection
4 
5 // SPDX-License-Identifier: MIT
6 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Provides information about the current execution context, including the
12  * sender of the transaction and its data. While these are generally available
13  * via msg.sender and msg.data, they should not be accessed in such a direct
14  * manner, since when dealing with meta-transactions the account sending and
15  * paying for execution may not be the actual sender (as far as an application
16  * is concerned).
17  *
18  * This contract is only required for intermediate, library-like contracts.
19  */
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view virtual returns (bytes calldata) {
26         return msg.data;
27     }
28 }
29 
30 // File: @openzeppelin/contracts/access/Ownable.sol
31 
32 
33 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
34 
35 pragma solidity ^0.8.0;
36 
37 
38 /**
39  * @dev Contract module which provides a basic access control mechanism, where
40  * there is an account (an owner) that can be granted exclusive access to
41  * specific functions.
42  *
43  * By default, the owner account will be the one that deploys the contract. This
44  * can later be changed with {transferOwnership}.
45  *
46  * This module is used through inheritance. It will make available the modifier
47  * `onlyOwner`, which can be applied to your functions to restrict their use to
48  * the owner.
49  */
50 abstract contract Ownable is Context {
51     address private _owner;
52 
53     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
54 
55     /**
56      * @dev Initializes the contract setting the deployer as the initial owner.
57      */
58     constructor() {
59         _transferOwnership(_msgSender());
60     }
61 
62     /**
63      * @dev Returns the address of the current owner.
64      */
65     function owner() public view virtual returns (address) {
66         return _owner;
67     }
68 
69     /**
70      * @dev Throws if called by any account other than the owner.
71      */
72     modifier onlyOwner() {
73         require(owner() == _msgSender(), "Ownable: caller is not the owner");
74         _;
75     }
76 
77     /**
78      * @dev Leaves the contract without owner. It will not be possible to call
79      * `onlyOwner` functions anymore. Can only be called by the current owner.
80      *
81      * NOTE: Renouncing ownership will leave the contract without an owner,
82      * thereby removing any functionality that is only available to the owner.
83      */
84     function renounceOwnership() public virtual onlyOwner {
85         _transferOwnership(address(0));
86     }
87 
88     /**
89      * @dev Transfers ownership of the contract to a new account (`newOwner`).
90      * Can only be called by the current owner.
91      */
92     function transferOwnership(address newOwner) public virtual onlyOwner {
93         require(newOwner != address(0), "Ownable: new owner is the zero address");
94         _transferOwnership(newOwner);
95     }
96 
97     /**
98      * @dev Transfers ownership of the contract to a new account (`newOwner`).
99      * Internal function without access restriction.
100      */
101     function _transferOwnership(address newOwner) internal virtual {
102         address oldOwner = _owner;
103         _owner = newOwner;
104         emit OwnershipTransferred(oldOwner, newOwner);
105     }
106 }
107 
108 // File: erc721a/contracts/IERC721A.sol
109 
110 
111 // ERC721A Contracts v4.0.0
112 // Creator: Chiru Labs
113 
114 pragma solidity ^0.8.4;
115 
116 /**
117  * @dev Interface of an ERC721A compliant contract.
118  */
119 interface IERC721A {
120     /**
121      * The caller must own the token or be an approved operator.
122      */
123     error ApprovalCallerNotOwnerNorApproved();
124 
125     /**
126      * The token does not exist.
127      */
128     error ApprovalQueryForNonexistentToken();
129 
130     /**
131      * The caller cannot approve to their own address.
132      */
133     error ApproveToCaller();
134 
135     /**
136      * The caller cannot approve to the current owner.
137      */
138     error ApprovalToCurrentOwner();
139 
140     /**
141      * Cannot query the balance for the zero address.
142      */
143     error BalanceQueryForZeroAddress();
144 
145     /**
146      * Cannot mint to the zero address.
147      */
148     error MintToZeroAddress();
149 
150     /**
151      * The quantity of tokens minted must be more than zero.
152      */
153     error MintZeroQuantity();
154 
155     /**
156      * The token does not exist.
157      */
158     error OwnerQueryForNonexistentToken();
159 
160     /**
161      * The caller must own the token or be an approved operator.
162      */
163     error TransferCallerNotOwnerNorApproved();
164 
165     /**
166      * The token must be owned by `from`.
167      */
168     error TransferFromIncorrectOwner();
169 
170     /**
171      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
172      */
173     error TransferToNonERC721ReceiverImplementer();
174 
175     /**
176      * Cannot transfer to the zero address.
177      */
178     error TransferToZeroAddress();
179 
180     /**
181      * The token does not exist.
182      */
183     error URIQueryForNonexistentToken();
184 
185     struct TokenOwnership {
186         // The address of the owner.
187         address addr;
188         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
189         uint64 startTimestamp;
190         // Whether the token has been burned.
191         bool burned;
192     }
193 
194     /**
195      * @dev Returns the total amount of tokens stored by the contract.
196      *
197      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
198      */
199     function totalSupply() external view returns (uint256);
200 
201     // ==============================
202     //            IERC165
203     // ==============================
204 
205     /**
206      * @dev Returns true if this contract implements the interface defined by
207      * `interfaceId`. See the corresponding
208      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
209      * to learn more about how these ids are created.
210      *
211      * This function call must use less than 30 000 gas.
212      */
213     function supportsInterface(bytes4 interfaceId) external view returns (bool);
214 
215     // ==============================
216     //            IERC721
217     // ==============================
218 
219     /**
220      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
221      */
222     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
223 
224     /**
225      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
226      */
227     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
228 
229     /**
230      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
231      */
232     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
233 
234     /**
235      * @dev Returns the number of tokens in ``owner``'s account.
236      */
237     function balanceOf(address owner) external view returns (uint256 balance);
238 
239     /**
240      * @dev Returns the owner of the `tokenId` token.
241      *
242      * Requirements:
243      *
244      * - `tokenId` must exist.
245      */
246     function ownerOf(uint256 tokenId) external view returns (address owner);
247 
248     /**
249      * @dev Safely transfers `tokenId` token from `from` to `to`.
250      *
251      * Requirements:
252      *
253      * - `from` cannot be the zero address.
254      * - `to` cannot be the zero address.
255      * - `tokenId` token must exist and be owned by `from`.
256      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
257      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
258      *
259      * Emits a {Transfer} event.
260      */
261     function safeTransferFrom(
262         address from,
263         address to,
264         uint256 tokenId,
265         bytes calldata data
266     ) external;
267 
268     /**
269      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
270      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
271      *
272      * Requirements:
273      *
274      * - `from` cannot be the zero address.
275      * - `to` cannot be the zero address.
276      * - `tokenId` token must exist and be owned by `from`.
277      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
278      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
279      *
280      * Emits a {Transfer} event.
281      */
282     function safeTransferFrom(
283         address from,
284         address to,
285         uint256 tokenId
286     ) external;
287 
288     /**
289      * @dev Transfers `tokenId` token from `from` to `to`.
290      *
291      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
292      *
293      * Requirements:
294      *
295      * - `from` cannot be the zero address.
296      * - `to` cannot be the zero address.
297      * - `tokenId` token must be owned by `from`.
298      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
299      *
300      * Emits a {Transfer} event.
301      */
302     function transferFrom(
303         address from,
304         address to,
305         uint256 tokenId
306     ) external;
307 
308     /**
309      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
310      * The approval is cleared when the token is transferred.
311      *
312      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
313      *
314      * Requirements:
315      *
316      * - The caller must own the token or be an approved operator.
317      * - `tokenId` must exist.
318      *
319      * Emits an {Approval} event.
320      */
321     function approve(address to, uint256 tokenId) external;
322 
323     /**
324      * @dev Approve or remove `operator` as an operator for the caller.
325      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
326      *
327      * Requirements:
328      *
329      * - The `operator` cannot be the caller.
330      *
331      * Emits an {ApprovalForAll} event.
332      */
333     function setApprovalForAll(address operator, bool _approved) external;
334 
335     /**
336      * @dev Returns the account approved for `tokenId` token.
337      *
338      * Requirements:
339      *
340      * - `tokenId` must exist.
341      */
342     function getApproved(uint256 tokenId) external view returns (address operator);
343 
344     /**
345      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
346      *
347      * See {setApprovalForAll}
348      */
349     function isApprovedForAll(address owner, address operator) external view returns (bool);
350 
351     // ==============================
352     //        IERC721Metadata
353     // ==============================
354 
355     /**
356      * @dev Returns the token collection name.
357      */
358     function name() external view returns (string memory);
359 
360     /**
361      * @dev Returns the token collection symbol.
362      */
363     function symbol() external view returns (string memory);
364 
365     /**
366      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
367      */
368     function tokenURI(uint256 tokenId) external view returns (string memory);
369 }
370 
371 // File: erc721a/contracts/ERC721A.sol
372 
373 
374 // ERC721A Contracts v4.0.0
375 // Creator: Chiru Labs
376 
377 pragma solidity ^0.8.4;
378 
379 
380 /**
381  * @dev ERC721 token receiver interface.
382  */
383 interface ERC721A__IERC721Receiver {
384     function onERC721Received(
385         address operator,
386         address from,
387         uint256 tokenId,
388         bytes calldata data
389     ) external returns (bytes4);
390 }
391 
392 /**
393  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
394  * the Metadata extension. Built to optimize for lower gas during batch mints.
395  *
396  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
397  *
398  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
399  *
400  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
401  */
402 contract ERC721A is IERC721A {
403     // Mask of an entry in packed address data.
404     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
405 
406     // The bit position of `numberMinted` in packed address data.
407     uint256 private constant BITPOS_NUMBER_MINTED = 64;
408 
409     // The bit position of `numberBurned` in packed address data.
410     uint256 private constant BITPOS_NUMBER_BURNED = 128;
411 
412     // The bit position of `aux` in packed address data.
413     uint256 private constant BITPOS_AUX = 192;
414 
415     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
416     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
417 
418     // The bit position of `startTimestamp` in packed ownership.
419     uint256 private constant BITPOS_START_TIMESTAMP = 160;
420 
421     // The bit mask of the `burned` bit in packed ownership.
422     uint256 private constant BITMASK_BURNED = 1 << 224;
423     
424     // The bit position of the `nextInitialized` bit in packed ownership.
425     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
426 
427     // The bit mask of the `nextInitialized` bit in packed ownership.
428     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
429 
430     // The tokenId of the next token to be minted.
431     uint256 private _currentIndex;
432 
433     // The number of tokens burned.
434     uint256 private _burnCounter;
435 
436     // Token name
437     string private _name;
438 
439     // Token symbol
440     string private _symbol;
441 
442     // Mapping from token ID to ownership details
443     // An empty struct value does not necessarily mean the token is unowned.
444     // See `_packedOwnershipOf` implementation for details.
445     //
446     // Bits Layout:
447     // - [0..159]   `addr`
448     // - [160..223] `startTimestamp`
449     // - [224]      `burned`
450     // - [225]      `nextInitialized`
451     mapping(uint256 => uint256) private _packedOwnerships;
452 
453     // Mapping owner address to address data.
454     //
455     // Bits Layout:
456     // - [0..63]    `balance`
457     // - [64..127]  `numberMinted`
458     // - [128..191] `numberBurned`
459     // - [192..255] `aux`
460     mapping(address => uint256) private _packedAddressData;
461 
462     // Mapping from token ID to approved address.
463     mapping(uint256 => address) private _tokenApprovals;
464 
465     // Mapping from owner to operator approvals
466     mapping(address => mapping(address => bool)) private _operatorApprovals;
467 
468     constructor(string memory name_, string memory symbol_) {
469         _name = name_;
470         _symbol = symbol_;
471         _currentIndex = _startTokenId();
472     }
473 
474     /**
475      * @dev Returns the starting token ID. 
476      * To change the starting token ID, please override this function.
477      */
478     function _startTokenId() internal view virtual returns (uint256) {
479         return 1;
480     }
481 
482     /**
483      * @dev Returns the next token ID to be minted.
484      */
485     function _nextTokenId() internal view returns (uint256) {
486         return _currentIndex;
487     }
488 
489     /**
490      * @dev Returns the total number of tokens in existence.
491      * Burned tokens will reduce the count. 
492      * To get the total number of tokens minted, please see `_totalMinted`.
493      */
494     function totalSupply() public view override returns (uint256) {
495         // Counter underflow is impossible as _burnCounter cannot be incremented
496         // more than `_currentIndex - _startTokenId()` times.
497         unchecked {
498             return _currentIndex - _burnCounter - _startTokenId();
499         }
500     }
501 
502     /**
503      * @dev Returns the total amount of tokens minted in the contract.
504      */
505     function _totalMinted() internal view returns (uint256) {
506         // Counter underflow is impossible as _currentIndex does not decrement,
507         // and it is initialized to `_startTokenId()`
508         unchecked {
509             return _currentIndex - _startTokenId();
510         }
511     }
512 
513     /**
514      * @dev Returns the total number of tokens burned.
515      */
516     function _totalBurned() internal view returns (uint256) {
517         return _burnCounter;
518     }
519 
520     /**
521      * @dev See {IERC165-supportsInterface}.
522      */
523     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
524         // The interface IDs are constants representing the first 4 bytes of the XOR of
525         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
526         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
527         return
528             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
529             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
530             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
531     }
532 
533     /**
534      * @dev See {IERC721-balanceOf}.
535      */
536     function balanceOf(address owner) public view override returns (uint256) {
537         if (owner == address(0)) revert BalanceQueryForZeroAddress();
538         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
539     }
540 
541     /**
542      * Returns the number of tokens minted by `owner`.
543      */
544     function _numberMinted(address owner) internal view returns (uint256) {
545         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
546     }
547 
548     /**
549      * Returns the number of tokens burned by or on behalf of `owner`.
550      */
551     function _numberBurned(address owner) internal view returns (uint256) {
552         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
553     }
554 
555     /**
556      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
557      */
558     function _getAux(address owner) internal view returns (uint64) {
559         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
560     }
561 
562     /**
563      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
564      * If there are multiple variables, please pack them into a uint64.
565      */
566     function _setAux(address owner, uint64 aux) internal {
567         uint256 packed = _packedAddressData[owner];
568         uint256 auxCasted;
569         assembly { // Cast aux without masking.
570             auxCasted := aux
571         }
572         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
573         _packedAddressData[owner] = packed;
574     }
575 
576     /**
577      * Returns the packed ownership data of `tokenId`.
578      */
579     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
580         uint256 curr = tokenId;
581 
582         unchecked {
583             if (_startTokenId() <= curr)
584                 if (curr < _currentIndex) {
585                     uint256 packed = _packedOwnerships[curr];
586                     // If not burned.
587                     if (packed & BITMASK_BURNED == 0) {
588                         // Invariant:
589                         // There will always be an ownership that has an address and is not burned
590                         // before an ownership that does not have an address and is not burned.
591                         // Hence, curr will not underflow.
592                         //
593                         // We can directly compare the packed value.
594                         // If the address is zero, packed is zero.
595                         while (packed == 0) {
596                             packed = _packedOwnerships[--curr];
597                         }
598                         return packed;
599                     }
600                 }
601         }
602         revert OwnerQueryForNonexistentToken();
603     }
604 
605     /**
606      * Returns the unpacked `TokenOwnership` struct from `packed`.
607      */
608     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
609         ownership.addr = address(uint160(packed));
610         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
611         ownership.burned = packed & BITMASK_BURNED != 0;
612     }
613 
614     /**
615      * Returns the unpacked `TokenOwnership` struct at `index`.
616      */
617     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
618         return _unpackedOwnership(_packedOwnerships[index]);
619     }
620 
621     /**
622      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
623      */
624     function _initializeOwnershipAt(uint256 index) internal {
625         if (_packedOwnerships[index] == 0) {
626             _packedOwnerships[index] = _packedOwnershipOf(index);
627         }
628     }
629 
630     /**
631      * Gas spent here starts off proportional to the maximum mint batch size.
632      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
633      */
634     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
635         return _unpackedOwnership(_packedOwnershipOf(tokenId));
636     }
637 
638     /**
639      * @dev See {IERC721-ownerOf}.
640      */
641     function ownerOf(uint256 tokenId) public view override returns (address) {
642         return address(uint160(_packedOwnershipOf(tokenId)));
643     }
644 
645     /**
646      * @dev See {IERC721Metadata-name}.
647      */
648     function name() public view virtual override returns (string memory) {
649         return _name;
650     }
651 
652     /**
653      * @dev See {IERC721Metadata-symbol}.
654      */
655     function symbol() public view virtual override returns (string memory) {
656         return _symbol;
657     }
658 
659     /**
660      * @dev See {IERC721Metadata-tokenURI}.
661      */
662     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
663         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
664 
665         string memory baseURI = _baseURI();
666         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
667     }
668 
669     /**
670      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
671      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
672      * by default, can be overriden in child contracts.
673      */
674     function _baseURI() internal view virtual returns (string memory) {
675         return '';
676     }
677 
678     /**
679      * @dev Casts the address to uint256 without masking.
680      */
681     function _addressToUint256(address value) private pure returns (uint256 result) {
682         assembly {
683             result := value
684         }
685     }
686 
687     /**
688      * @dev Casts the boolean to uint256 without branching.
689      */
690     function _boolToUint256(bool value) private pure returns (uint256 result) {
691         assembly {
692             result := value
693         }
694     }
695 
696     /**
697      * @dev See {IERC721-approve}.
698      */
699     function approve(address to, uint256 tokenId) public override {
700         address owner = address(uint160(_packedOwnershipOf(tokenId)));
701         if (to == owner) revert ApprovalToCurrentOwner();
702 
703         if (_msgSenderERC721A() != owner)
704             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
705                 revert ApprovalCallerNotOwnerNorApproved();
706             }
707 
708         _tokenApprovals[tokenId] = to;
709         emit Approval(owner, to, tokenId);
710     }
711 
712     /**
713      * @dev See {IERC721-getApproved}.
714      */
715     function getApproved(uint256 tokenId) public view override returns (address) {
716         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
717 
718         return _tokenApprovals[tokenId];
719     }
720 
721     /**
722      * @dev See {IERC721-setApprovalForAll}.
723      */
724     function setApprovalForAll(address operator, bool approved) public virtual override {
725         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
726 
727         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
728         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
729     }
730 
731     /**
732      * @dev See {IERC721-isApprovedForAll}.
733      */
734     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
735         return _operatorApprovals[owner][operator];
736     }
737 
738     /**
739      * @dev See {IERC721-transferFrom}.
740      */
741     function transferFrom(
742         address from,
743         address to,
744         uint256 tokenId
745     ) public virtual override {
746         _transfer(from, to, tokenId);
747     }
748 
749     /**
750      * @dev See {IERC721-safeTransferFrom}.
751      */
752     function safeTransferFrom(
753         address from,
754         address to,
755         uint256 tokenId
756     ) public virtual override {
757         safeTransferFrom(from, to, tokenId, '');
758     }
759 
760     /**
761      * @dev See {IERC721-safeTransferFrom}.
762      */
763     function safeTransferFrom(
764         address from,
765         address to,
766         uint256 tokenId,
767         bytes memory _data
768     ) public virtual override {
769         _transfer(from, to, tokenId);
770         if (to.code.length != 0)
771             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
772                 revert TransferToNonERC721ReceiverImplementer();
773             }
774     }
775 
776     /**
777      * @dev Returns whether `tokenId` exists.
778      *
779      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
780      *
781      * Tokens start existing when they are minted (`_mint`),
782      */
783     function _exists(uint256 tokenId) internal view returns (bool) {
784         return
785             _startTokenId() <= tokenId &&
786             tokenId < _currentIndex && // If within bounds,
787             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
788     }
789 
790     /**
791      * @dev Equivalent to `_safeMint(to, quantity, '')`.
792      */
793     function _safeMint(address to, uint256 quantity) internal {
794         _safeMint(to, quantity, '');
795     }
796 
797     /**
798      * @dev Safely mints `quantity` tokens and transfers them to `to`.
799      *
800      * Requirements:
801      *
802      * - If `to` refers to a smart contract, it must implement
803      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
804      * - `quantity` must be greater than 0.
805      *
806      * Emits a {Transfer} event.
807      */
808     function _safeMint(
809         address to,
810         uint256 quantity,
811         bytes memory _data
812     ) internal {
813         uint256 startTokenId = _currentIndex;
814         if (to == address(0)) revert MintToZeroAddress();
815         if (quantity == 0) revert MintZeroQuantity();
816 
817         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
818 
819         // Overflows are incredibly unrealistic.
820         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
821         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
822         unchecked {
823             // Updates:
824             // - `balance += quantity`.
825             // - `numberMinted += quantity`.
826             //
827             // We can directly add to the balance and number minted.
828             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
829 
830             // Updates:
831             // - `address` to the owner.
832             // - `startTimestamp` to the timestamp of minting.
833             // - `burned` to `false`.
834             // - `nextInitialized` to `quantity == 1`.
835             _packedOwnerships[startTokenId] =
836                 _addressToUint256(to) |
837                 (block.timestamp << BITPOS_START_TIMESTAMP) |
838                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
839 
840             uint256 updatedIndex = startTokenId;
841             uint256 end = updatedIndex + quantity;
842 
843             if (to.code.length != 0) {
844                 do {
845                     emit Transfer(address(0), to, updatedIndex);
846                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
847                         revert TransferToNonERC721ReceiverImplementer();
848                     }
849                 } while (updatedIndex < end);
850                 // Reentrancy protection
851                 if (_currentIndex != startTokenId) revert();
852             } else {
853                 do {
854                     emit Transfer(address(0), to, updatedIndex++);
855                 } while (updatedIndex < end);
856             }
857             _currentIndex = updatedIndex;
858         }
859         _afterTokenTransfers(address(0), to, startTokenId, quantity);
860     }
861 
862     /**
863      * @dev Mints `quantity` tokens and transfers them to `to`.
864      *
865      * Requirements:
866      *
867      * - `to` cannot be the zero address.
868      * - `quantity` must be greater than 0.
869      *
870      * Emits a {Transfer} event.
871      */
872     function _mint(address to, uint256 quantity) internal {
873         uint256 startTokenId = _currentIndex;
874         if (to == address(0)) revert MintToZeroAddress();
875         if (quantity == 0) revert MintZeroQuantity();
876 
877         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
878 
879         // Overflows are incredibly unrealistic.
880         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
881         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
882         unchecked {
883             // Updates:
884             // - `balance += quantity`.
885             // - `numberMinted += quantity`.
886             //
887             // We can directly add to the balance and number minted.
888             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
889 
890             // Updates:
891             // - `address` to the owner.
892             // - `startTimestamp` to the timestamp of minting.
893             // - `burned` to `false`.
894             // - `nextInitialized` to `quantity == 1`.
895             _packedOwnerships[startTokenId] =
896                 _addressToUint256(to) |
897                 (block.timestamp << BITPOS_START_TIMESTAMP) |
898                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
899 
900             uint256 updatedIndex = startTokenId;
901             uint256 end = updatedIndex + quantity;
902 
903             do {
904                 emit Transfer(address(0), to, updatedIndex++);
905             } while (updatedIndex < end);
906 
907             _currentIndex = updatedIndex;
908         }
909         _afterTokenTransfers(address(0), to, startTokenId, quantity);
910     }
911 
912     /**
913      * @dev Transfers `tokenId` from `from` to `to`.
914      *
915      * Requirements:
916      *
917      * - `to` cannot be the zero address.
918      * - `tokenId` token must be owned by `from`.
919      *
920      * Emits a {Transfer} event.
921      */
922     function _transfer(
923         address from,
924         address to,
925         uint256 tokenId
926     ) private {
927         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
928 
929         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
930 
931         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
932             isApprovedForAll(from, _msgSenderERC721A()) ||
933             getApproved(tokenId) == _msgSenderERC721A());
934 
935         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
936         if (to == address(0)) revert TransferToZeroAddress();
937 
938         _beforeTokenTransfers(from, to, tokenId, 1);
939 
940         // Clear approvals from the previous owner.
941         delete _tokenApprovals[tokenId];
942 
943         // Underflow of the sender's balance is impossible because we check for
944         // ownership above and the recipient's balance can't realistically overflow.
945         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
946         unchecked {
947             // We can directly increment and decrement the balances.
948             --_packedAddressData[from]; // Updates: `balance -= 1`.
949             ++_packedAddressData[to]; // Updates: `balance += 1`.
950 
951             // Updates:
952             // - `address` to the next owner.
953             // - `startTimestamp` to the timestamp of transfering.
954             // - `burned` to `false`.
955             // - `nextInitialized` to `true`.
956             _packedOwnerships[tokenId] =
957                 _addressToUint256(to) |
958                 (block.timestamp << BITPOS_START_TIMESTAMP) |
959                 BITMASK_NEXT_INITIALIZED;
960 
961             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
962             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
963                 uint256 nextTokenId = tokenId + 1;
964                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
965                 if (_packedOwnerships[nextTokenId] == 0) {
966                     // If the next slot is within bounds.
967                     if (nextTokenId != _currentIndex) {
968                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
969                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
970                     }
971                 }
972             }
973         }
974 
975         emit Transfer(from, to, tokenId);
976         _afterTokenTransfers(from, to, tokenId, 1);
977     }
978 
979     /**
980      * @dev Equivalent to `_burn(tokenId, false)`.
981      */
982     function _burn(uint256 tokenId) internal virtual {
983         _burn(tokenId, false);
984     }
985 
986     /**
987      * @dev Destroys `tokenId`.
988      * The approval is cleared when the token is burned.
989      *
990      * Requirements:
991      *
992      * - `tokenId` must exist.
993      *
994      * Emits a {Transfer} event.
995      */
996     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
997         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
998 
999         address from = address(uint160(prevOwnershipPacked));
1000 
1001         if (approvalCheck) {
1002             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1003                 isApprovedForAll(from, _msgSenderERC721A()) ||
1004                 getApproved(tokenId) == _msgSenderERC721A());
1005 
1006             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1007         }
1008 
1009         _beforeTokenTransfers(from, address(0), tokenId, 1);
1010 
1011         // Clear approvals from the previous owner.
1012         delete _tokenApprovals[tokenId];
1013 
1014         // Underflow of the sender's balance is impossible because we check for
1015         // ownership above and the recipient's balance can't realistically overflow.
1016         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1017         unchecked {
1018             // Updates:
1019             // - `balance -= 1`.
1020             // - `numberBurned += 1`.
1021             //
1022             // We can directly decrement the balance, and increment the number burned.
1023             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1024             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1025 
1026             // Updates:
1027             // - `address` to the last owner.
1028             // - `startTimestamp` to the timestamp of burning.
1029             // - `burned` to `true`.
1030             // - `nextInitialized` to `true`.
1031             _packedOwnerships[tokenId] =
1032                 _addressToUint256(from) |
1033                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1034                 BITMASK_BURNED | 
1035                 BITMASK_NEXT_INITIALIZED;
1036 
1037             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1038             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1039                 uint256 nextTokenId = tokenId + 1;
1040                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1041                 if (_packedOwnerships[nextTokenId] == 0) {
1042                     // If the next slot is within bounds.
1043                     if (nextTokenId != _currentIndex) {
1044                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1045                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1046                     }
1047                 }
1048             }
1049         }
1050 
1051         emit Transfer(from, address(0), tokenId);
1052         _afterTokenTransfers(from, address(0), tokenId, 1);
1053 
1054         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1055         unchecked {
1056             _burnCounter++;
1057         }
1058     }
1059 
1060     /**
1061      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1062      *
1063      * @param from address representing the previous owner of the given token ID
1064      * @param to target address that will receive the tokens
1065      * @param tokenId uint256 ID of the token to be transferred
1066      * @param _data bytes optional data to send along with the call
1067      * @return bool whether the call correctly returned the expected magic value
1068      */
1069     function _checkContractOnERC721Received(
1070         address from,
1071         address to,
1072         uint256 tokenId,
1073         bytes memory _data
1074     ) private returns (bool) {
1075         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1076             bytes4 retval
1077         ) {
1078             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1079         } catch (bytes memory reason) {
1080             if (reason.length == 0) {
1081                 revert TransferToNonERC721ReceiverImplementer();
1082             } else {
1083                 assembly {
1084                     revert(add(32, reason), mload(reason))
1085                 }
1086             }
1087         }
1088     }
1089 
1090     /**
1091      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1092      * And also called before burning one token.
1093      *
1094      * startTokenId - the first token id to be transferred
1095      * quantity - the amount to be transferred
1096      *
1097      * Calling conditions:
1098      *
1099      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1100      * transferred to `to`.
1101      * - When `from` is zero, `tokenId` will be minted for `to`.
1102      * - When `to` is zero, `tokenId` will be burned by `from`.
1103      * - `from` and `to` are never both zero.
1104      */
1105     function _beforeTokenTransfers(
1106         address from,
1107         address to,
1108         uint256 startTokenId,
1109         uint256 quantity
1110     ) internal virtual {}
1111 
1112     /**
1113      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1114      * minting.
1115      * And also called after one token has been burned.
1116      *
1117      * startTokenId - the first token id to be transferred
1118      * quantity - the amount to be transferred
1119      *
1120      * Calling conditions:
1121      *
1122      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1123      * transferred to `to`.
1124      * - When `from` is zero, `tokenId` has been minted for `to`.
1125      * - When `to` is zero, `tokenId` has been burned by `from`.
1126      * - `from` and `to` are never both zero.
1127      */
1128     function _afterTokenTransfers(
1129         address from,
1130         address to,
1131         uint256 startTokenId,
1132         uint256 quantity
1133     ) internal virtual {}
1134 
1135     /**
1136      * @dev Returns the message sender (defaults to `msg.sender`).
1137      *
1138      * If you are writing GSN compatible contracts, you need to override this function.
1139      */
1140     function _msgSenderERC721A() internal view virtual returns (address) {
1141         return msg.sender;
1142     }
1143 
1144     /**
1145      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1146      */
1147     function _toString(uint256 value) internal pure returns (string memory ptr) {
1148         assembly {
1149             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1150             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1151             // We will need 1 32-byte word to store the length, 
1152             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1153             ptr := add(mload(0x40), 128)
1154             // Update the free memory pointer to allocate.
1155             mstore(0x40, ptr)
1156 
1157             // Cache the end of the memory to calculate the length later.
1158             let end := ptr
1159 
1160             // We write the string from the rightmost digit to the leftmost digit.
1161             // The following is essentially a do-while loop that also handles the zero case.
1162             // Costs a bit more than early returning for the zero case,
1163             // but cheaper in terms of deployment and overall runtime costs.
1164             for { 
1165                 // Initialize and perform the first pass without check.
1166                 let temp := value
1167                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1168                 ptr := sub(ptr, 1)
1169                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1170                 mstore8(ptr, add(48, mod(temp, 10)))
1171                 temp := div(temp, 10)
1172             } temp { 
1173                 // Keep dividing `temp` until zero.
1174                 temp := div(temp, 10)
1175             } { // Body of the for loop.
1176                 ptr := sub(ptr, 1)
1177                 mstore8(ptr, add(48, mod(temp, 10)))
1178             }
1179             
1180             let length := sub(end, ptr)
1181             // Move the pointer 32 bytes leftwards to make room for the length.
1182             ptr := sub(ptr, 32)
1183             // Store the length.
1184             mstore(ptr, length)
1185         }
1186     }
1187 }
1188 
1189 // File: contracts/TrippinAliens.sol
1190 
1191 
1192 pragma solidity ^0.8.11;
1193 
1194  
1195 
1196 contract TrippinAliens is ERC721A, Ownable {
1197 
1198   string _baseTokenURI;
1199 
1200   bool public isActive = false;
1201   uint256 public mintPrice = 0.005 ether;
1202   uint256 public constant MAX_SUPPLY = 7777;
1203   uint256 public maxAllowedTokensPerPurchase = 10;
1204 
1205  
1206 
1207   constructor(string memory baseURI) ERC721A("Trippin Aliens", "TA") {
1208     setBaseURI(baseURI);
1209   }
1210 
1211   modifier saleIsOpen {
1212     require(totalSupply() <= MAX_SUPPLY, "Sale has ended.");
1213     _;
1214   }
1215 
1216   modifier onlyAuthorized() {
1217     require(owner() == msg.sender);
1218     _;
1219   }
1220   
1221    function tokenURI(uint256 tokenId)
1222         public
1223         view
1224         virtual
1225         override
1226         returns (string memory)
1227     {
1228         require(
1229             _exists(tokenId),
1230             "ERC721Metadata: URI query for nonexistent token"
1231         );
1232 
1233         string memory _tokenURI = super.tokenURI(tokenId);
1234         return
1235             bytes(_tokenURI).length > 0
1236                 ? string(abi.encodePacked(_tokenURI, ".json"))
1237                 : "";
1238     }
1239 
1240   function toggleSale() public onlyAuthorized {
1241     isActive = !isActive;
1242   }
1243 
1244   function setPrice(uint256 _price) public onlyAuthorized {
1245     mintPrice = _price;
1246   }
1247 
1248   function setBaseURI(string memory baseURI) public onlyAuthorized {
1249     _baseTokenURI = baseURI;
1250   }
1251 
1252   function _baseURI() internal view virtual override returns (string memory) {
1253     return _baseTokenURI;
1254   }
1255 
1256   function freeMint(uint256 _count) public payable saleIsOpen {
1257     uint256 mintIndex = totalSupply();
1258     uint256 discountPrice = _count;
1259 
1260     if (msg.sender != owner()) {
1261       require(isActive, "Sale is not active currently.");
1262     }
1263 
1264     require(mintIndex + _count <= MAX_SUPPLY, "Total supply exceeded.");
1265     require(
1266       _count <= maxAllowedTokensPerPurchase,
1267       "Exceeds maximum allowed tokens"
1268     );
1269 
1270     if(_count > 1){
1271       discountPrice = _count - 1;
1272     }
1273 
1274     if(balanceOf(msg.sender) >= 1 || _count > 1) {
1275       require(msg.value >= mintPrice * discountPrice, "Insufficient ETH amount sent.");
1276     }
1277    
1278     _safeMint(msg.sender, _count);
1279 
1280   }
1281 
1282   function withdraw() external onlyAuthorized {
1283     uint balance = address(this).balance;
1284     payable(owner()).transfer(balance);
1285   }
1286 }