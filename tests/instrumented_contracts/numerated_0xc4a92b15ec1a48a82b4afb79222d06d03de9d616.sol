1 /**
2  *Submitted for verification at Etherscan.io on 2022-06-10
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2022-06-09
7 */
8 
9 /**
10  *Submitted for verification at Etherscan.io on 2022-06-02
11 */
12 
13 // File: @openzeppelin/contracts/utils/Context.sol
14 
15 
16 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
17 
18 pragma solidity ^0.8.0;
19 
20 /**
21  * @dev Provides information about the current execution context, including the
22  * sender of the transaction and its data. While these are generally available
23  * via msg.sender and msg.data, they should not be accessed in such a direct
24  * manner, since when dealing with meta-transactions the account sending and
25  * paying for execution may not be the actual sender (as far as an application
26  * is concerned).
27  *
28  * This contract is only required for intermediate, library-like contracts.
29  */
30 abstract contract Context {
31     function _msgSender() internal view virtual returns (address) {
32         return msg.sender;
33     }
34 
35     function _msgData() internal view virtual returns (bytes calldata) {
36         return msg.data;
37     }
38 }
39 
40 // File: @openzeppelin/contracts/access/Ownable.sol
41 
42 
43 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
44 
45 pragma solidity ^0.8.0;
46 
47 
48 /**
49  * @dev Contract module which provides a basic access control mechanism, where
50  * there is an account (an owner) that can be granted exclusive access to
51  * specific functions.
52  *
53  * By default, the owner account will be the one that deploys the contract. This
54  * can later be changed with {transferOwnership}.
55  *
56  * This module is used through inheritance. It will make available the modifier
57  * `onlyOwner`, which can be applied to your functions to restrict their use to
58  * the owner.
59  */
60 abstract contract Ownable is Context {
61     address private _owner;
62 
63     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
64 
65     /**
66      * @dev Initializes the contract setting the deployer as the initial owner.
67      */
68     constructor() {
69         _transferOwnership(_msgSender());
70     }
71 
72     /**
73      * @dev Returns the address of the current owner.
74      */
75     function owner() public view virtual returns (address) {
76         return _owner;
77     }
78 
79     /**
80      * @dev Throws if called by any account other than the owner.
81      */
82     modifier onlyOwner() {
83         require(owner() == _msgSender(), "Ownable: caller is not the owner");
84         _;
85     }
86 
87     /**
88      * @dev Leaves the contract without owner. It will not be possible to call
89      * `onlyOwner` functions anymore. Can only be called by the current owner.
90      *
91      * NOTE: Renouncing ownership will leave the contract without an owner,
92      * thereby removing any functionality that is only available to the owner.
93      */
94     function renounceOwnership() public virtual onlyOwner {
95         _transferOwnership(address(0));
96     }
97 
98     /**
99      * @dev Transfers ownership of the contract to a new account (`newOwner`).
100      * Can only be called by the current owner.
101      */
102     function transferOwnership(address newOwner) public virtual onlyOwner {
103         require(newOwner != address(0), "Ownable: new owner is the zero address");
104         _transferOwnership(newOwner);
105     }
106 
107     /**
108      * @dev Transfers ownership of the contract to a new account (`newOwner`).
109      * Internal function without access restriction.
110      */
111     function _transferOwnership(address newOwner) internal virtual {
112         address oldOwner = _owner;
113         _owner = newOwner;
114         emit OwnershipTransferred(oldOwner, newOwner);
115     }
116 }
117 
118 // File: erc721a/contracts/IERC721A.sol
119 
120 
121 // ERC721A Contracts v4.0.0
122 // Creator: Chiru Labs
123 
124 pragma solidity ^0.8.4;
125 
126 /**
127  * @dev Interface of an ERC721A compliant contract.
128  */
129 interface IERC721A {
130     /**
131      * The caller must own the token or be an approved operator.
132      */
133     error ApprovalCallerNotOwnerNorApproved();
134 
135     /**
136      * The token does not exist.
137      */
138     error ApprovalQueryForNonexistentToken();
139 
140     /**
141      * The caller cannot approve to their own address.
142      */
143     error ApproveToCaller();
144 
145     /**
146      * The caller cannot approve to the current owner.
147      */
148     error ApprovalToCurrentOwner();
149 
150     /**
151      * Cannot query the balance for the zero address.
152      */
153     error BalanceQueryForZeroAddress();
154 
155     /**
156      * Cannot mint to the zero address.
157      */
158     error MintToZeroAddress();
159 
160     /**
161      * The quantity of tokens minted must be more than zero.
162      */
163     error MintZeroQuantity();
164 
165     /**
166      * The token does not exist.
167      */
168     error OwnerQueryForNonexistentToken();
169 
170     /**
171      * The caller must own the token or be an approved operator.
172      */
173     error TransferCallerNotOwnerNorApproved();
174 
175     /**
176      * The token must be owned by `from`.
177      */
178     error TransferFromIncorrectOwner();
179 
180     /**
181      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
182      */
183     error TransferToNonERC721ReceiverImplementer();
184 
185     /**
186      * Cannot transfer to the zero address.
187      */
188     error TransferToZeroAddress();
189 
190     /**
191      * The token does not exist.
192      */
193     error URIQueryForNonexistentToken();
194 
195     struct TokenOwnership {
196         // The address of the owner.
197         address addr;
198         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
199         uint64 startTimestamp;
200         // Whether the token has been burned.
201         bool burned;
202     }
203 
204     /**
205      * @dev Returns the total amount of tokens stored by the contract.
206      *
207      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
208      */
209     function totalSupply() external view returns (uint256);
210 
211     // ==============================
212     //            IERC165
213     // ==============================
214 
215     /**
216      * @dev Returns true if this contract implements the interface defined by
217      * `interfaceId`. See the corresponding
218      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
219      * to learn more about how these ids are created.
220      *
221      * This function call must use less than 30 000 gas.
222      */
223     function supportsInterface(bytes4 interfaceId) external view returns (bool);
224 
225     // ==============================
226     //            IERC721
227     // ==============================
228 
229     /**
230      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
231      */
232     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
233 
234     /**
235      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
236      */
237     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
238 
239     /**
240      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
241      */
242     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
243 
244     /**
245      * @dev Returns the number of tokens in ``owner``'s account.
246      */
247     function balanceOf(address owner) external view returns (uint256 balance);
248 
249     /**
250      * @dev Returns the owner of the `tokenId` token.
251      *
252      * Requirements:
253      *
254      * - `tokenId` must exist.
255      */
256     function ownerOf(uint256 tokenId) external view returns (address owner);
257 
258     /**
259      * @dev Safely transfers `tokenId` token from `from` to `to`.
260      *
261      * Requirements:
262      *
263      * - `from` cannot be the zero address.
264      * - `to` cannot be the zero address.
265      * - `tokenId` token must exist and be owned by `from`.
266      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
267      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
268      *
269      * Emits a {Transfer} event.
270      */
271     function safeTransferFrom(
272         address from,
273         address to,
274         uint256 tokenId,
275         bytes calldata data
276     ) external;
277 
278     /**
279      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
280      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
281      *
282      * Requirements:
283      *
284      * - `from` cannot be the zero address.
285      * - `to` cannot be the zero address.
286      * - `tokenId` token must exist and be owned by `from`.
287      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
288      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
289      *
290      * Emits a {Transfer} event.
291      */
292     function safeTransferFrom(
293         address from,
294         address to,
295         uint256 tokenId
296     ) external;
297 
298     /**
299      * @dev Transfers `tokenId` token from `from` to `to`.
300      *
301      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
302      *
303      * Requirements:
304      *
305      * - `from` cannot be the zero address.
306      * - `to` cannot be the zero address.
307      * - `tokenId` token must be owned by `from`.
308      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
309      *
310      * Emits a {Transfer} event.
311      */
312     function transferFrom(
313         address from,
314         address to,
315         uint256 tokenId
316     ) external;
317 
318     /**
319      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
320      * The approval is cleared when the token is transferred.
321      *
322      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
323      *
324      * Requirements:
325      *
326      * - The caller must own the token or be an approved operator.
327      * - `tokenId` must exist.
328      *
329      * Emits an {Approval} event.
330      */
331     function approve(address to, uint256 tokenId) external;
332 
333     /**
334      * @dev Approve or remove `operator` as an operator for the caller.
335      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
336      *
337      * Requirements:
338      *
339      * - The `operator` cannot be the caller.
340      *
341      * Emits an {ApprovalForAll} event.
342      */
343     function setApprovalForAll(address operator, bool _approved) external;
344 
345     /**
346      * @dev Returns the account approved for `tokenId` token.
347      *
348      * Requirements:
349      *
350      * - `tokenId` must exist.
351      */
352     function getApproved(uint256 tokenId) external view returns (address operator);
353 
354     /**
355      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
356      *
357      * See {setApprovalForAll}
358      */
359     function isApprovedForAll(address owner, address operator) external view returns (bool);
360 
361     // ==============================
362     //        IERC721Metadata
363     // ==============================
364 
365     /**
366      * @dev Returns the token collection name.
367      */
368     function name() external view returns (string memory);
369 
370     /**
371      * @dev Returns the token collection symbol.
372      */
373     function symbol() external view returns (string memory);
374 
375     /**
376      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
377      */
378     function tokenURI(uint256 tokenId) external view returns (string memory);
379 }
380 
381 // File: erc721a/contracts/ERC721A.sol
382 
383 
384 // ERC721A Contracts v4.0.0
385 // Creator: Chiru Labs
386 
387 pragma solidity ^0.8.4;
388 
389 
390 /**
391  * @dev ERC721 token receiver interface.
392  */
393 interface ERC721A__IERC721Receiver {
394     function onERC721Received(
395         address operator,
396         address from,
397         uint256 tokenId,
398         bytes calldata data
399     ) external returns (bytes4);
400 }
401 
402 /**
403  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
404  * the Metadata extension. Built to optimize for lower gas during batch mints.
405  *
406  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
407  *
408  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
409  *
410  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
411  */
412 contract ERC721A is IERC721A {
413     // Mask of an entry in packed address data.
414     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
415 
416     // The bit position of `numberMinted` in packed address data.
417     uint256 private constant BITPOS_NUMBER_MINTED = 64;
418 
419     // The bit position of `numberBurned` in packed address data.
420     uint256 private constant BITPOS_NUMBER_BURNED = 128;
421 
422     // The bit position of `aux` in packed address data.
423     uint256 private constant BITPOS_AUX = 192;
424 
425     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
426     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
427 
428     // The bit position of `startTimestamp` in packed ownership.
429     uint256 private constant BITPOS_START_TIMESTAMP = 160;
430 
431     // The bit mask of the `burned` bit in packed ownership.
432     uint256 private constant BITMASK_BURNED = 1 << 224;
433     
434     // The bit position of the `nextInitialized` bit in packed ownership.
435     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
436 
437     // The bit mask of the `nextInitialized` bit in packed ownership.
438     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
439 
440     // The tokenId of the next token to be minted.
441     uint256 private _currentIndex;
442 
443     // The number of tokens burned.
444     uint256 private _burnCounter;
445 
446     // Token name
447     string private _name;
448 
449     // Token symbol
450     string private _symbol;
451 
452     // Mapping from token ID to ownership details
453     // An empty struct value does not necessarily mean the token is unowned.
454     // See `_packedOwnershipOf` implementation for details.
455     //
456     // Bits Layout:
457     // - [0..159]   `addr`
458     // - [160..223] `startTimestamp`
459     // - [224]      `burned`
460     // - [225]      `nextInitialized`
461     mapping(uint256 => uint256) private _packedOwnerships;
462 
463     // Mapping owner address to address data.
464     //
465     // Bits Layout:
466     // - [0..63]    `balance`
467     // - [64..127]  `numberMinted`
468     // - [128..191] `numberBurned`
469     // - [192..255] `aux`
470     mapping(address => uint256) private _packedAddressData;
471 
472     // Mapping from token ID to approved address.
473     mapping(uint256 => address) private _tokenApprovals;
474 
475     // Mapping from owner to operator approvals
476     mapping(address => mapping(address => bool)) private _operatorApprovals;
477 
478     constructor(string memory name_, string memory symbol_) {
479         _name = name_;
480         _symbol = symbol_;
481         _currentIndex = _startTokenId();
482     }
483 
484     /**
485      * @dev Returns the starting token ID. 
486      * To change the starting token ID, please override this function.
487      */
488     function _startTokenId() internal view virtual returns (uint256) {
489         return 0;
490     }
491 
492     /**
493      * @dev Returns the next token ID to be minted.
494      */
495     function _nextTokenId() internal view returns (uint256) {
496         return _currentIndex;
497     }
498 
499     /**
500      * @dev Returns the total number of tokens in existence.
501      * Burned tokens will reduce the count. 
502      * To get the total number of tokens minted, please see `_totalMinted`.
503      */
504     function totalSupply() public view override returns (uint256) {
505         // Counter underflow is impossible as _burnCounter cannot be incremented
506         // more than `_currentIndex - _startTokenId()` times.
507         unchecked {
508             return _currentIndex - _burnCounter - _startTokenId();
509         }
510     }
511 
512     /**
513      * @dev Returns the total amount of tokens minted in the contract.
514      */
515     function _totalMinted() internal view returns (uint256) {
516         // Counter underflow is impossible as _currentIndex does not decrement,
517         // and it is initialized to `_startTokenId()`
518         unchecked {
519             return _currentIndex - _startTokenId();
520         }
521     }
522 
523     /**
524      * @dev Returns the total number of tokens burned.
525      */
526     function _totalBurned() internal view returns (uint256) {
527         return _burnCounter;
528     }
529 
530     /**
531      * @dev See {IERC165-supportsInterface}.
532      */
533     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
534         // The interface IDs are constants representing the first 4 bytes of the XOR of
535         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
536         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
537         return
538             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
539             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
540             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
541     }
542 
543     /**
544      * @dev See {IERC721-balanceOf}.
545      */
546     function balanceOf(address owner) public view override returns (uint256) {
547         if (owner == address(0)) revert BalanceQueryForZeroAddress();
548         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
549     }
550 
551     /**
552      * Returns the number of tokens minted by `owner`.
553      */
554     function _numberMinted(address owner) internal view returns (uint256) {
555         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
556     }
557 
558     /**
559      * Returns the number of tokens burned by or on behalf of `owner`.
560      */
561     function _numberBurned(address owner) internal view returns (uint256) {
562         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
563     }
564 
565     /**
566      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
567      */
568     function _getAux(address owner) internal view returns (uint64) {
569         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
570     }
571 
572     /**
573      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
574      * If there are multiple variables, please pack them into a uint64.
575      */
576     function _setAux(address owner, uint64 aux) internal {
577         uint256 packed = _packedAddressData[owner];
578         uint256 auxCasted;
579         assembly { // Cast aux without masking.
580             auxCasted := aux
581         }
582         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
583         _packedAddressData[owner] = packed;
584     }
585 
586     /**
587      * Returns the packed ownership data of `tokenId`.
588      */
589     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
590         uint256 curr = tokenId;
591 
592         unchecked {
593             if (_startTokenId() <= curr)
594                 if (curr < _currentIndex) {
595                     uint256 packed = _packedOwnerships[curr];
596                     // If not burned.
597                     if (packed & BITMASK_BURNED == 0) {
598                         // Invariant:
599                         // There will always be an ownership that has an address and is not burned
600                         // before an ownership that does not have an address and is not burned.
601                         // Hence, curr will not underflow.
602                         //
603                         // We can directly compare the packed value.
604                         // If the address is zero, packed is zero.
605                         while (packed == 0) {
606                             packed = _packedOwnerships[--curr];
607                         }
608                         return packed;
609                     }
610                 }
611         }
612         revert OwnerQueryForNonexistentToken();
613     }
614 
615     /**
616      * Returns the unpacked `TokenOwnership` struct from `packed`.
617      */
618     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
619         ownership.addr = address(uint160(packed));
620         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
621         ownership.burned = packed & BITMASK_BURNED != 0;
622     }
623 
624     /**
625      * Returns the unpacked `TokenOwnership` struct at `index`.
626      */
627     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
628         return _unpackedOwnership(_packedOwnerships[index]);
629     }
630 
631     /**
632      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
633      */
634     function _initializeOwnershipAt(uint256 index) internal {
635         if (_packedOwnerships[index] == 0) {
636             _packedOwnerships[index] = _packedOwnershipOf(index);
637         }
638     }
639 
640     /**
641      * Gas spent here starts off proportional to the maximum mint batch size.
642      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
643      */
644     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
645         return _unpackedOwnership(_packedOwnershipOf(tokenId));
646     }
647 
648     /**
649      * @dev See {IERC721-ownerOf}.
650      */
651     function ownerOf(uint256 tokenId) public view override returns (address) {
652         return address(uint160(_packedOwnershipOf(tokenId)));
653     }
654 
655     /**
656      * @dev See {IERC721Metadata-name}.
657      */
658     function name() public view virtual override returns (string memory) {
659         return _name;
660     }
661 
662     /**
663      * @dev See {IERC721Metadata-symbol}.
664      */
665     function symbol() public view virtual override returns (string memory) {
666         return _symbol;
667     }
668 
669     /**
670      * @dev See {IERC721Metadata-tokenURI}.
671      */
672     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
673         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
674 
675         string memory baseURI = _baseURI();
676         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
677     }
678 
679     /**
680      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
681      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
682      * by default, can be overriden in child contracts.
683      */
684     function _baseURI() internal view virtual returns (string memory) {
685         return '';
686     }
687 
688     /**
689      * @dev Casts the address to uint256 without masking.
690      */
691     function _addressToUint256(address value) private pure returns (uint256 result) {
692         assembly {
693             result := value
694         }
695     }
696 
697     /**
698      * @dev Casts the boolean to uint256 without branching.
699      */
700     function _boolToUint256(bool value) private pure returns (uint256 result) {
701         assembly {
702             result := value
703         }
704     }
705 
706     /**
707      * @dev See {IERC721-approve}.
708      */
709     function approve(address to, uint256 tokenId) public override {
710         address owner = address(uint160(_packedOwnershipOf(tokenId)));
711         if (to == owner) revert ApprovalToCurrentOwner();
712 
713         if (_msgSenderERC721A() != owner)
714             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
715                 revert ApprovalCallerNotOwnerNorApproved();
716             }
717 
718         _tokenApprovals[tokenId] = to;
719         emit Approval(owner, to, tokenId);
720     }
721 
722     /**
723      * @dev See {IERC721-getApproved}.
724      */
725     function getApproved(uint256 tokenId) public view override returns (address) {
726         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
727 
728         return _tokenApprovals[tokenId];
729     }
730 
731     /**
732      * @dev See {IERC721-setApprovalForAll}.
733      */
734     function setApprovalForAll(address operator, bool approved) public virtual override {
735         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
736 
737         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
738         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
739     }
740 
741     /**
742      * @dev See {IERC721-isApprovedForAll}.
743      */
744     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
745         return _operatorApprovals[owner][operator];
746     }
747 
748     /**
749      * @dev See {IERC721-transferFrom}.
750      */
751     function transferFrom(
752         address from,
753         address to,
754         uint256 tokenId
755     ) public virtual override {
756         _transfer(from, to, tokenId);
757     }
758 
759     /**
760      * @dev See {IERC721-safeTransferFrom}.
761      */
762     function safeTransferFrom(
763         address from,
764         address to,
765         uint256 tokenId
766     ) public virtual override {
767         safeTransferFrom(from, to, tokenId, '');
768     }
769 
770     /**
771      * @dev See {IERC721-safeTransferFrom}.
772      */
773     function safeTransferFrom(
774         address from,
775         address to,
776         uint256 tokenId,
777         bytes memory _data
778     ) public virtual override {
779         _transfer(from, to, tokenId);
780         if (to.code.length != 0)
781             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
782                 revert TransferToNonERC721ReceiverImplementer();
783             }
784     }
785 
786     /**
787      * @dev Returns whether `tokenId` exists.
788      *
789      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
790      *
791      * Tokens start existing when they are minted (`_mint`),
792      */
793     function _exists(uint256 tokenId) internal view returns (bool) {
794         return
795             _startTokenId() <= tokenId &&
796             tokenId < _currentIndex && // If within bounds,
797             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
798     }
799 
800     /**
801      * @dev Equivalent to `_safeMint(to, quantity, '')`.
802      */
803     function _safeMint(address to, uint256 quantity) internal {
804         _safeMint(to, quantity, '');
805     }
806 
807     /**
808      * @dev Safely mints `quantity` tokens and transfers them to `to`.
809      *
810      * Requirements:
811      *
812      * - If `to` refers to a smart contract, it must implement
813      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
814      * - `quantity` must be greater than 0.
815      *
816      * Emits a {Transfer} event.
817      */
818     function _safeMint(
819         address to,
820         uint256 quantity,
821         bytes memory _data
822     ) internal {
823         uint256 startTokenId = _currentIndex;
824         if (to == address(0)) revert MintToZeroAddress();
825         if (quantity == 0) revert MintZeroQuantity();
826 
827         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
828 
829         // Overflows are incredibly unrealistic.
830         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
831         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
832         unchecked {
833             // Updates:
834             // - `balance += quantity`.
835             // - `numberMinted += quantity`.
836             //
837             // We can directly add to the balance and number minted.
838             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
839 
840             // Updates:
841             // - `address` to the owner.
842             // - `startTimestamp` to the timestamp of minting.
843             // - `burned` to `false`.
844             // - `nextInitialized` to `quantity == 1`.
845             _packedOwnerships[startTokenId] =
846                 _addressToUint256(to) |
847                 (block.timestamp << BITPOS_START_TIMESTAMP) |
848                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
849 
850             uint256 updatedIndex = startTokenId;
851             uint256 end = updatedIndex + quantity;
852 
853             if (to.code.length != 0) {
854                 do {
855                     emit Transfer(address(0), to, updatedIndex);
856                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
857                         revert TransferToNonERC721ReceiverImplementer();
858                     }
859                 } while (updatedIndex < end);
860                 // Reentrancy protection
861                 if (_currentIndex != startTokenId) revert();
862             } else {
863                 do {
864                     emit Transfer(address(0), to, updatedIndex++);
865                 } while (updatedIndex < end);
866             }
867             _currentIndex = updatedIndex;
868         }
869         _afterTokenTransfers(address(0), to, startTokenId, quantity);
870     }
871 
872     /**
873      * @dev Mints `quantity` tokens and transfers them to `to`.
874      *
875      * Requirements:
876      *
877      * - `to` cannot be the zero address.
878      * - `quantity` must be greater than 0.
879      *
880      * Emits a {Transfer} event.
881      */
882     function _mint(address to, uint256 quantity) internal {
883         uint256 startTokenId = _currentIndex;
884         if (to == address(0)) revert MintToZeroAddress();
885         if (quantity == 0) revert MintZeroQuantity();
886 
887         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
888 
889         // Overflows are incredibly unrealistic.
890         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
891         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
892         unchecked {
893             // Updates:
894             // - `balance += quantity`.
895             // - `numberMinted += quantity`.
896             //
897             // We can directly add to the balance and number minted.
898             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
899 
900             // Updates:
901             // - `address` to the owner.
902             // - `startTimestamp` to the timestamp of minting.
903             // - `burned` to `false`.
904             // - `nextInitialized` to `quantity == 1`.
905             _packedOwnerships[startTokenId] =
906                 _addressToUint256(to) |
907                 (block.timestamp << BITPOS_START_TIMESTAMP) |
908                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
909 
910             uint256 updatedIndex = startTokenId;
911             uint256 end = updatedIndex + quantity;
912 
913             do {
914                 emit Transfer(address(0), to, updatedIndex++);
915             } while (updatedIndex < end);
916 
917             _currentIndex = updatedIndex;
918         }
919         _afterTokenTransfers(address(0), to, startTokenId, quantity);
920     }
921 
922     /**
923      * @dev Transfers `tokenId` from `from` to `to`.
924      *
925      * Requirements:
926      *
927      * - `to` cannot be the zero address.
928      * - `tokenId` token must be owned by `from`.
929      *
930      * Emits a {Transfer} event.
931      */
932     function _transfer(
933         address from,
934         address to,
935         uint256 tokenId
936     ) private {
937         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
938 
939         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
940 
941         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
942             isApprovedForAll(from, _msgSenderERC721A()) ||
943             getApproved(tokenId) == _msgSenderERC721A());
944 
945         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
946         if (to == address(0)) revert TransferToZeroAddress();
947 
948         _beforeTokenTransfers(from, to, tokenId, 1);
949 
950         // Clear approvals from the previous owner.
951         delete _tokenApprovals[tokenId];
952 
953         // Underflow of the sender's balance is impossible because we check for
954         // ownership above and the recipient's balance can't realistically overflow.
955         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
956         unchecked {
957             // We can directly increment and decrement the balances.
958             --_packedAddressData[from]; // Updates: `balance -= 1`.
959             ++_packedAddressData[to]; // Updates: `balance += 1`.
960 
961             // Updates:
962             // - `address` to the next owner.
963             // - `startTimestamp` to the timestamp of transfering.
964             // - `burned` to `false`.
965             // - `nextInitialized` to `true`.
966             _packedOwnerships[tokenId] =
967                 _addressToUint256(to) |
968                 (block.timestamp << BITPOS_START_TIMESTAMP) |
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
985         emit Transfer(from, to, tokenId);
986         _afterTokenTransfers(from, to, tokenId, 1);
987     }
988 
989     /**
990      * @dev Equivalent to `_burn(tokenId, false)`.
991      */
992     function _burn(uint256 tokenId) internal virtual {
993         _burn(tokenId, false);
994     }
995 
996     /**
997      * @dev Destroys `tokenId`.
998      * The approval is cleared when the token is burned.
999      *
1000      * Requirements:
1001      *
1002      * - `tokenId` must exist.
1003      *
1004      * Emits a {Transfer} event.
1005      */
1006     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1007         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1008 
1009         address from = address(uint160(prevOwnershipPacked));
1010 
1011         if (approvalCheck) {
1012             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1013                 isApprovedForAll(from, _msgSenderERC721A()) ||
1014                 getApproved(tokenId) == _msgSenderERC721A());
1015 
1016             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1017         }
1018 
1019         _beforeTokenTransfers(from, address(0), tokenId, 1);
1020 
1021         // Clear approvals from the previous owner.
1022         delete _tokenApprovals[tokenId];
1023 
1024         // Underflow of the sender's balance is impossible because we check for
1025         // ownership above and the recipient's balance can't realistically overflow.
1026         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1027         unchecked {
1028             // Updates:
1029             // - `balance -= 1`.
1030             // - `numberBurned += 1`.
1031             //
1032             // We can directly decrement the balance, and increment the number burned.
1033             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1034             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1035 
1036             // Updates:
1037             // - `address` to the last owner.
1038             // - `startTimestamp` to the timestamp of burning.
1039             // - `burned` to `true`.
1040             // - `nextInitialized` to `true`.
1041             _packedOwnerships[tokenId] =
1042                 _addressToUint256(from) |
1043                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1044                 BITMASK_BURNED | 
1045                 BITMASK_NEXT_INITIALIZED;
1046 
1047             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1048             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1049                 uint256 nextTokenId = tokenId + 1;
1050                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1051                 if (_packedOwnerships[nextTokenId] == 0) {
1052                     // If the next slot is within bounds.
1053                     if (nextTokenId != _currentIndex) {
1054                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1055                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1056                     }
1057                 }
1058             }
1059         }
1060 
1061         emit Transfer(from, address(0), tokenId);
1062         _afterTokenTransfers(from, address(0), tokenId, 1);
1063 
1064         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1065         unchecked {
1066             _burnCounter++;
1067         }
1068     }
1069 
1070     /**
1071      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1072      *
1073      * @param from address representing the previous owner of the given token ID
1074      * @param to target address that will receive the tokens
1075      * @param tokenId uint256 ID of the token to be transferred
1076      * @param _data bytes optional data to send along with the call
1077      * @return bool whether the call correctly returned the expected magic value
1078      */
1079     function _checkContractOnERC721Received(
1080         address from,
1081         address to,
1082         uint256 tokenId,
1083         bytes memory _data
1084     ) private returns (bool) {
1085         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1086             bytes4 retval
1087         ) {
1088             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1089         } catch (bytes memory reason) {
1090             if (reason.length == 0) {
1091                 revert TransferToNonERC721ReceiverImplementer();
1092             } else {
1093                 assembly {
1094                     revert(add(32, reason), mload(reason))
1095                 }
1096             }
1097         }
1098     }
1099 
1100     /**
1101      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1102      * And also called before burning one token.
1103      *
1104      * startTokenId - the first token id to be transferred
1105      * quantity - the amount to be transferred
1106      *
1107      * Calling conditions:
1108      *
1109      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1110      * transferred to `to`.
1111      * - When `from` is zero, `tokenId` will be minted for `to`.
1112      * - When `to` is zero, `tokenId` will be burned by `from`.
1113      * - `from` and `to` are never both zero.
1114      */
1115     function _beforeTokenTransfers(
1116         address from,
1117         address to,
1118         uint256 startTokenId,
1119         uint256 quantity
1120     ) internal virtual {}
1121 
1122     /**
1123      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1124      * minting.
1125      * And also called after one token has been burned.
1126      *
1127      * startTokenId - the first token id to be transferred
1128      * quantity - the amount to be transferred
1129      *
1130      * Calling conditions:
1131      *
1132      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1133      * transferred to `to`.
1134      * - When `from` is zero, `tokenId` has been minted for `to`.
1135      * - When `to` is zero, `tokenId` has been burned by `from`.
1136      * - `from` and `to` are never both zero.
1137      */
1138     function _afterTokenTransfers(
1139         address from,
1140         address to,
1141         uint256 startTokenId,
1142         uint256 quantity
1143     ) internal virtual {}
1144 
1145     /**
1146      * @dev Returns the message sender (defaults to `msg.sender`).
1147      *
1148      * If you are writing GSN compatible contracts, you need to override this function.
1149      */
1150     function _msgSenderERC721A() internal view virtual returns (address) {
1151         return msg.sender;
1152     }
1153 
1154     /**
1155      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1156      */
1157     function _toString(uint256 value) internal pure returns (string memory ptr) {
1158         assembly {
1159             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1160             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1161             // We will need 1 32-byte word to store the length, 
1162             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1163             ptr := add(mload(0x40), 128)
1164             // Update the free memory pointer to allocate.
1165             mstore(0x40, ptr)
1166 
1167             // Cache the end of the memory to calculate the length later.
1168             let end := ptr
1169 
1170             // We write the string from the rightmost digit to the leftmost digit.
1171             // The following is essentially a do-while loop that also handles the zero case.
1172             // Costs a bit more than early returning for the zero case,
1173             // but cheaper in terms of deployment and overall runtime costs.
1174             for { 
1175                 // Initialize and perform the first pass without check.
1176                 let temp := value
1177                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1178                 ptr := sub(ptr, 1)
1179                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1180                 mstore8(ptr, add(48, mod(temp, 10)))
1181                 temp := div(temp, 10)
1182             } temp { 
1183                 // Keep dividing `temp` until zero.
1184                 temp := div(temp, 10)
1185             } { // Body of the for loop.
1186                 ptr := sub(ptr, 1)
1187                 mstore8(ptr, add(48, mod(temp, 10)))
1188             }
1189             
1190             let length := sub(end, ptr)
1191             // Move the pointer 32 bytes leftwards to make room for the length.
1192             ptr := sub(ptr, 32)
1193             // Store the length.
1194             mstore(ptr, length)
1195         }
1196     }
1197 }
1198 
1199 // File: nft.sol
1200 
1201 
1202 // SPDX-License-Identifier: MIT
1203 pragma solidity ^0.8.13;
1204 
1205 
1206 
1207 contract SHREK is Ownable, ERC721A {
1208     uint256 public maxSupply                    = 3333;
1209     uint256 public maxFreeSupply                = 3333;
1210     
1211     uint256 public maxPerTxDuringMint           = 10;
1212     uint256 public maxPerAddressDuringMint      = 101;
1213     uint256 public maxPerAddressDuringFreeMint  = 1;
1214     
1215     uint256 public price                        = 0.003 ether;
1216     bool    public saleIsActive                 = false;
1217 
1218     address constant internal TEAM_ADDRESS = 0x204343288e68b6515FaA9514edC632B439854336;
1219 
1220     string private _baseTokenURI;
1221 
1222     mapping(address => uint256) public freeMintedAmount;
1223     mapping(address => uint256) public mintedAmount;
1224 
1225     constructor() ERC721A("shrektown.wtf", "SHREK") {
1226         _safeMint(msg.sender, 10);
1227     }
1228 
1229     modifier mintCompliance() {
1230         require(saleIsActive, "Sale is not active yet.");
1231         require(tx.origin == msg.sender, "Wrong Caller");
1232         _;
1233     }
1234 
1235     function mint(uint256 _quantity) external payable mintCompliance() {
1236         require(
1237             msg.value >= price * _quantity,
1238             "GDZ: Insufficient Fund."
1239         );
1240         require(
1241             maxSupply >= totalSupply() + _quantity,
1242             "GDZ: Exceeds max supply."
1243         );
1244         uint256 _mintedAmount = mintedAmount[msg.sender];
1245         require(
1246             _mintedAmount + _quantity <= maxPerAddressDuringMint,
1247             "GDZ: Exceeds max mints per address!"
1248         );
1249         require(
1250             _quantity > 0 && _quantity <= maxPerTxDuringMint,
1251             "Invalid mint amount."
1252         );
1253         mintedAmount[msg.sender] = _mintedAmount + _quantity;
1254         _safeMint(msg.sender, _quantity);
1255     }
1256 
1257     function freeMint(uint256 _quantity) external mintCompliance() {
1258         require(
1259             maxFreeSupply >= totalSupply() + _quantity,
1260             "GDZ: Exceeds max supply."
1261         );
1262         uint256 _freeMintedAmount = freeMintedAmount[msg.sender];
1263         require(
1264             _freeMintedAmount + _quantity <= maxPerAddressDuringFreeMint,
1265             "GDZ: Exceeds max free mints per address!"
1266         );
1267         freeMintedAmount[msg.sender] = _freeMintedAmount + _quantity;
1268         _safeMint(msg.sender, _quantity);
1269     }
1270 
1271     function setPrice(uint256 _price) external onlyOwner {
1272         price = _price;
1273     }
1274 
1275     function setMaxPerTx(uint256 _amount) external onlyOwner {
1276         maxPerTxDuringMint = _amount;
1277     }
1278 
1279     function setMaxPerAddress(uint256 _amount) external onlyOwner {
1280         maxPerAddressDuringMint = _amount;
1281     }
1282 
1283     function setMaxFreePerAddress(uint256 _amount) external onlyOwner {
1284         maxPerAddressDuringFreeMint = _amount;
1285     }
1286 
1287     function flipSale() public onlyOwner {
1288         saleIsActive = !saleIsActive;
1289     }
1290 
1291     function cutMaxSupply(uint256 _amount) public onlyOwner {
1292         require(
1293             maxSupply - _amount >= totalSupply(), 
1294             "Supply cannot fall below minted tokens."
1295         );
1296         maxSupply -= _amount;
1297     }
1298 
1299     function setBaseURI(string calldata baseURI) external onlyOwner {
1300         _baseTokenURI = baseURI;
1301     }
1302 
1303     function _baseURI() internal view virtual override returns (string memory) {
1304         return _baseTokenURI;
1305     }
1306 
1307     function withdrawBalance() external payable onlyOwner {
1308 
1309         (bool success, ) = payable(TEAM_ADDRESS).call{
1310             value: address(this).balance
1311         }("");
1312         require(success, "transfer failed.");
1313     }
1314 }