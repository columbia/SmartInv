1 /**
2  *Submitted for verification at Etherscan.io on 2022-06-05
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2022-06-02
7 */
8 
9 // File: @openzeppelin/contracts/utils/Context.sol
10 
11 
12 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
13 
14 pragma solidity ^0.8.0;
15 
16 /**
17  * @dev Provides information about the current execution context, including the
18  * sender of the transaction and its data. While these are generally available
19  * via msg.sender and msg.data, they should not be accessed in such a direct
20  * manner, since when dealing with meta-transactions the account sending and
21  * paying for execution may not be the actual sender (as far as an application
22  * is concerned).
23  *
24  * This contract is only required for intermediate, library-like contracts.
25  */
26 abstract contract Context {
27     function _msgSender() internal view virtual returns (address) {
28         return msg.sender;
29     }
30 
31     function _msgData() internal view virtual returns (bytes calldata) {
32         return msg.data;
33     }
34 }
35 
36 // File: @openzeppelin/contracts/access/Ownable.sol
37 
38 
39 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
40 
41 pragma solidity ^0.8.0;
42 
43 
44 /**
45  * @dev Contract module which provides a basic access control mechanism, where
46  * there is an account (an owner) that can be granted exclusive access to
47  * specific functions.
48  *
49  * By default, the owner account will be the one that deploys the contract. This
50  * can later be changed with {transferOwnership}.
51  *
52  * This module is used through inheritance. It will make available the modifier
53  * `onlyOwner`, which can be applied to your functions to restrict their use to
54  * the owner.
55  */
56 abstract contract Ownable is Context {
57     address private _owner;
58 
59     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
60 
61     /**
62      * @dev Initializes the contract setting the deployer as the initial owner.
63      */
64     constructor() {
65         _transferOwnership(_msgSender());
66     }
67 
68     /**
69      * @dev Returns the address of the current owner.
70      */
71     function owner() public view virtual returns (address) {
72         return _owner;
73     }
74 
75     /**
76      * @dev Throws if called by any account other than the owner.
77      */
78     modifier onlyOwner() {
79         require(owner() == _msgSender(), "Ownable: caller is not the owner");
80         _;
81     }
82 
83     /**
84      * @dev Leaves the contract without owner. It will not be possible to call
85      * `onlyOwner` functions anymore. Can only be called by the current owner.
86      *
87      * NOTE: Renouncing ownership will leave the contract without an owner,
88      * thereby removing any functionality that is only available to the owner.
89      */
90     function renounceOwnership() public virtual onlyOwner {
91         _transferOwnership(address(0));
92     }
93 
94     /**
95      * @dev Transfers ownership of the contract to a new account (`newOwner`).
96      * Can only be called by the current owner.
97      */
98     function transferOwnership(address newOwner) public virtual onlyOwner {
99         require(newOwner != address(0), "Ownable: new owner is the zero address");
100         _transferOwnership(newOwner);
101     }
102 
103     /**
104      * @dev Transfers ownership of the contract to a new account (`newOwner`).
105      * Internal function without access restriction.
106      */
107     function _transferOwnership(address newOwner) internal virtual {
108         address oldOwner = _owner;
109         _owner = newOwner;
110         emit OwnershipTransferred(oldOwner, newOwner);
111     }
112 }
113 
114 // File: erc721a/contracts/IERC721A.sol
115 
116 
117 // ERC721A Contracts v4.0.0
118 // Creator: Chiru Labs
119 
120 pragma solidity ^0.8.4;
121 
122 /**
123  * @dev Interface of an ERC721A compliant contract.
124  */
125 interface IERC721A {
126     /**
127      * The caller must own the token or be an approved operator.
128      */
129     error ApprovalCallerNotOwnerNorApproved();
130 
131     /**
132      * The token does not exist.
133      */
134     error ApprovalQueryForNonexistentToken();
135 
136     /**
137      * The caller cannot approve to their own address.
138      */
139     error ApproveToCaller();
140 
141     /**
142      * The caller cannot approve to the current owner.
143      */
144     error ApprovalToCurrentOwner();
145 
146     /**
147      * Cannot query the balance for the zero address.
148      */
149     error BalanceQueryForZeroAddress();
150 
151     /**
152      * Cannot mint to the zero address.
153      */
154     error MintToZeroAddress();
155 
156     /**
157      * The quantity of tokens minted must be more than zero.
158      */
159     error MintZeroQuantity();
160 
161     /**
162      * The token does not exist.
163      */
164     error OwnerQueryForNonexistentToken();
165 
166     /**
167      * The caller must own the token or be an approved operator.
168      */
169     error TransferCallerNotOwnerNorApproved();
170 
171     /**
172      * The token must be owned by `from`.
173      */
174     error TransferFromIncorrectOwner();
175 
176     /**
177      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
178      */
179     error TransferToNonERC721ReceiverImplementer();
180 
181     /**
182      * Cannot transfer to the zero address.
183      */
184     error TransferToZeroAddress();
185 
186     /**
187      * The token does not exist.
188      */
189     error URIQueryForNonexistentToken();
190 
191     struct TokenOwnership {
192         // The address of the owner.
193         address addr;
194         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
195         uint64 startTimestamp;
196         // Whether the token has been burned.
197         bool burned;
198     }
199 
200     /**
201      * @dev Returns the total amount of tokens stored by the contract.
202      *
203      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
204      */
205     function totalSupply() external view returns (uint256);
206 
207     // ==============================
208     //            IERC165
209     // ==============================
210 
211     /**
212      * @dev Returns true if this contract implements the interface defined by
213      * `interfaceId`. See the corresponding
214      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
215      * to learn more about how these ids are created.
216      *
217      * This function call must use less than 30 000 gas.
218      */
219     function supportsInterface(bytes4 interfaceId) external view returns (bool);
220 
221     // ==============================
222     //            IERC721
223     // ==============================
224 
225     /**
226      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
227      */
228     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
229 
230     /**
231      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
232      */
233     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
234 
235     /**
236      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
237      */
238     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
239 
240     /**
241      * @dev Returns the number of tokens in ``owner``'s account.
242      */
243     function balanceOf(address owner) external view returns (uint256 balance);
244 
245     /**
246      * @dev Returns the owner of the `tokenId` token.
247      *
248      * Requirements:
249      *
250      * - `tokenId` must exist.
251      */
252     function ownerOf(uint256 tokenId) external view returns (address owner);
253 
254     /**
255      * @dev Safely transfers `tokenId` token from `from` to `to`.
256      *
257      * Requirements:
258      *
259      * - `from` cannot be the zero address.
260      * - `to` cannot be the zero address.
261      * - `tokenId` token must exist and be owned by `from`.
262      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
263      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
264      *
265      * Emits a {Transfer} event.
266      */
267     function safeTransferFrom(
268         address from,
269         address to,
270         uint256 tokenId,
271         bytes calldata data
272     ) external;
273 
274     /**
275      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
276      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
277      *
278      * Requirements:
279      *
280      * - `from` cannot be the zero address.
281      * - `to` cannot be the zero address.
282      * - `tokenId` token must exist and be owned by `from`.
283      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
284      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
285      *
286      * Emits a {Transfer} event.
287      */
288     function safeTransferFrom(
289         address from,
290         address to,
291         uint256 tokenId
292     ) external;
293 
294     /**
295      * @dev Transfers `tokenId` token from `from` to `to`.
296      *
297      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
298      *
299      * Requirements:
300      *
301      * - `from` cannot be the zero address.
302      * - `to` cannot be the zero address.
303      * - `tokenId` token must be owned by `from`.
304      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
305      *
306      * Emits a {Transfer} event.
307      */
308     function transferFrom(
309         address from,
310         address to,
311         uint256 tokenId
312     ) external;
313 
314     /**
315      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
316      * The approval is cleared when the token is transferred.
317      *
318      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
319      *
320      * Requirements:
321      *
322      * - The caller must own the token or be an approved operator.
323      * - `tokenId` must exist.
324      *
325      * Emits an {Approval} event.
326      */
327     function approve(address to, uint256 tokenId) external;
328 
329     /**
330      * @dev Approve or remove `operator` as an operator for the caller.
331      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
332      *
333      * Requirements:
334      *
335      * - The `operator` cannot be the caller.
336      *
337      * Emits an {ApprovalForAll} event.
338      */
339     function setApprovalForAll(address operator, bool _approved) external;
340 
341     /**
342      * @dev Returns the account approved for `tokenId` token.
343      *
344      * Requirements:
345      *
346      * - `tokenId` must exist.
347      */
348     function getApproved(uint256 tokenId) external view returns (address operator);
349 
350     /**
351      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
352      *
353      * See {setApprovalForAll}
354      */
355     function isApprovedForAll(address owner, address operator) external view returns (bool);
356 
357     // ==============================
358     //        IERC721Metadata
359     // ==============================
360 
361     /**
362      * @dev Returns the token collection name.
363      */
364     function name() external view returns (string memory);
365 
366     /**
367      * @dev Returns the token collection symbol.
368      */
369     function symbol() external view returns (string memory);
370 
371     /**
372      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
373      */
374     function tokenURI(uint256 tokenId) external view returns (string memory);
375 }
376 
377 // File: erc721a/contracts/ERC721A.sol
378 
379 
380 // ERC721A Contracts v4.0.0
381 // Creator: Chiru Labs
382 
383 pragma solidity ^0.8.4;
384 
385 
386 /**
387  * @dev ERC721 token receiver interface.
388  */
389 interface ERC721A__IERC721Receiver {
390     function onERC721Received(
391         address operator,
392         address from,
393         uint256 tokenId,
394         bytes calldata data
395     ) external returns (bytes4);
396 }
397 
398 /**
399  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
400  * the Metadata extension. Built to optimize for lower gas during batch mints.
401  *
402  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
403  *
404  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
405  *
406  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
407  */
408 contract ERC721A is IERC721A {
409     // Mask of an entry in packed address data.
410     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
411 
412     // The bit position of `numberMinted` in packed address data.
413     uint256 private constant BITPOS_NUMBER_MINTED = 64;
414 
415     // The bit position of `numberBurned` in packed address data.
416     uint256 private constant BITPOS_NUMBER_BURNED = 128;
417 
418     // The bit position of `aux` in packed address data.
419     uint256 private constant BITPOS_AUX = 192;
420 
421     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
422     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
423 
424     // The bit position of `startTimestamp` in packed ownership.
425     uint256 private constant BITPOS_START_TIMESTAMP = 160;
426 
427     // The bit mask of the `burned` bit in packed ownership.
428     uint256 private constant BITMASK_BURNED = 1 << 224;
429     
430     // The bit position of the `nextInitialized` bit in packed ownership.
431     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
432 
433     // The bit mask of the `nextInitialized` bit in packed ownership.
434     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
435 
436     // The tokenId of the next token to be minted.
437     uint256 private _currentIndex;
438 
439     // The number of tokens burned.
440     uint256 private _burnCounter;
441 
442     // Token name
443     string private _name;
444 
445     // Token symbol
446     string private _symbol;
447 
448     // Mapping from token ID to ownership details
449     // An empty struct value does not necessarily mean the token is unowned.
450     // See `_packedOwnershipOf` implementation for details.
451     //
452     // Bits Layout:
453     // - [0..159]   `addr`
454     // - [160..223] `startTimestamp`
455     // - [224]      `burned`
456     // - [225]      `nextInitialized`
457     mapping(uint256 => uint256) private _packedOwnerships;
458 
459     // Mapping owner address to address data.
460     //
461     // Bits Layout:
462     // - [0..63]    `balance`
463     // - [64..127]  `numberMinted`
464     // - [128..191] `numberBurned`
465     // - [192..255] `aux`
466     mapping(address => uint256) private _packedAddressData;
467 
468     // Mapping from token ID to approved address.
469     mapping(uint256 => address) private _tokenApprovals;
470 
471     // Mapping from owner to operator approvals
472     mapping(address => mapping(address => bool)) private _operatorApprovals;
473 
474     constructor(string memory name_, string memory symbol_) {
475         _name = name_;
476         _symbol = symbol_;
477         _currentIndex = _startTokenId();
478     }
479 
480     /**
481      * @dev Returns the starting token ID. 
482      * To change the starting token ID, please override this function.
483      */
484     function _startTokenId() internal view virtual returns (uint256) {
485         return 0;
486     }
487 
488     /**
489      * @dev Returns the next token ID to be minted.
490      */
491     function _nextTokenId() internal view returns (uint256) {
492         return _currentIndex;
493     }
494 
495     /**
496      * @dev Returns the total number of tokens in existence.
497      * Burned tokens will reduce the count. 
498      * To get the total number of tokens minted, please see `_totalMinted`.
499      */
500     function totalSupply() public view override returns (uint256) {
501         // Counter underflow is impossible as _burnCounter cannot be incremented
502         // more than `_currentIndex - _startTokenId()` times.
503         unchecked {
504             return _currentIndex - _burnCounter - _startTokenId();
505         }
506     }
507 
508     /**
509      * @dev Returns the total amount of tokens minted in the contract.
510      */
511     function _totalMinted() internal view returns (uint256) {
512         // Counter underflow is impossible as _currentIndex does not decrement,
513         // and it is initialized to `_startTokenId()`
514         unchecked {
515             return _currentIndex - _startTokenId();
516         }
517     }
518 
519     /**
520      * @dev Returns the total number of tokens burned.
521      */
522     function _totalBurned() internal view returns (uint256) {
523         return _burnCounter;
524     }
525 
526     /**
527      * @dev See {IERC165-supportsInterface}.
528      */
529     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
530         // The interface IDs are constants representing the first 4 bytes of the XOR of
531         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
532         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
533         return
534             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
535             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
536             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
537     }
538 
539     /**
540      * @dev See {IERC721-balanceOf}.
541      */
542     function balanceOf(address owner) public view override returns (uint256) {
543         if (owner == address(0)) revert BalanceQueryForZeroAddress();
544         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
545     }
546 
547     /**
548      * Returns the number of tokens minted by `owner`.
549      */
550     function _numberMinted(address owner) internal view returns (uint256) {
551         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
552     }
553 
554     /**
555      * Returns the number of tokens burned by or on behalf of `owner`.
556      */
557     function _numberBurned(address owner) internal view returns (uint256) {
558         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
559     }
560 
561     /**
562      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
563      */
564     function _getAux(address owner) internal view returns (uint64) {
565         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
566     }
567 
568     /**
569      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
570      * If there are multiple variables, please pack them into a uint64.
571      */
572     function _setAux(address owner, uint64 aux) internal {
573         uint256 packed = _packedAddressData[owner];
574         uint256 auxCasted;
575         assembly { // Cast aux without masking.
576             auxCasted := aux
577         }
578         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
579         _packedAddressData[owner] = packed;
580     }
581 
582     /**
583      * Returns the packed ownership data of `tokenId`.
584      */
585     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
586         uint256 curr = tokenId;
587 
588         unchecked {
589             if (_startTokenId() <= curr)
590                 if (curr < _currentIndex) {
591                     uint256 packed = _packedOwnerships[curr];
592                     // If not burned.
593                     if (packed & BITMASK_BURNED == 0) {
594                         // Invariant:
595                         // There will always be an ownership that has an address and is not burned
596                         // before an ownership that does not have an address and is not burned.
597                         // Hence, curr will not underflow.
598                         //
599                         // We can directly compare the packed value.
600                         // If the address is zero, packed is zero.
601                         while (packed == 0) {
602                             packed = _packedOwnerships[--curr];
603                         }
604                         return packed;
605                     }
606                 }
607         }
608         revert OwnerQueryForNonexistentToken();
609     }
610 
611     /**
612      * Returns the unpacked `TokenOwnership` struct from `packed`.
613      */
614     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
615         ownership.addr = address(uint160(packed));
616         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
617         ownership.burned = packed & BITMASK_BURNED != 0;
618     }
619 
620     /**
621      * Returns the unpacked `TokenOwnership` struct at `index`.
622      */
623     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
624         return _unpackedOwnership(_packedOwnerships[index]);
625     }
626 
627     /**
628      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
629      */
630     function _initializeOwnershipAt(uint256 index) internal {
631         if (_packedOwnerships[index] == 0) {
632             _packedOwnerships[index] = _packedOwnershipOf(index);
633         }
634     }
635 
636     /**
637      * Gas spent here starts off proportional to the maximum mint batch size.
638      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
639      */
640     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
641         return _unpackedOwnership(_packedOwnershipOf(tokenId));
642     }
643 
644     /**
645      * @dev See {IERC721-ownerOf}.
646      */
647     function ownerOf(uint256 tokenId) public view override returns (address) {
648         return address(uint160(_packedOwnershipOf(tokenId)));
649     }
650 
651     /**
652      * @dev See {IERC721Metadata-name}.
653      */
654     function name() public view virtual override returns (string memory) {
655         return _name;
656     }
657 
658     /**
659      * @dev See {IERC721Metadata-symbol}.
660      */
661     function symbol() public view virtual override returns (string memory) {
662         return _symbol;
663     }
664 
665     /**
666      * @dev See {IERC721Metadata-tokenURI}.
667      */
668     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
669         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
670 
671         string memory baseURI = _baseURI();
672         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
673     }
674 
675     /**
676      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
677      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
678      * by default, can be overriden in child contracts.
679      */
680     function _baseURI() internal view virtual returns (string memory) {
681         return '';
682     }
683 
684     /**
685      * @dev Casts the address to uint256 without masking.
686      */
687     function _addressToUint256(address value) private pure returns (uint256 result) {
688         assembly {
689             result := value
690         }
691     }
692 
693     /**
694      * @dev Casts the boolean to uint256 without branching.
695      */
696     function _boolToUint256(bool value) private pure returns (uint256 result) {
697         assembly {
698             result := value
699         }
700     }
701 
702     /**
703      * @dev See {IERC721-approve}.
704      */
705     function approve(address to, uint256 tokenId) public override {
706         address owner = address(uint160(_packedOwnershipOf(tokenId)));
707         if (to == owner) revert ApprovalToCurrentOwner();
708 
709         if (_msgSenderERC721A() != owner)
710             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
711                 revert ApprovalCallerNotOwnerNorApproved();
712             }
713 
714         _tokenApprovals[tokenId] = to;
715         emit Approval(owner, to, tokenId);
716     }
717 
718     /**
719      * @dev See {IERC721-getApproved}.
720      */
721     function getApproved(uint256 tokenId) public view override returns (address) {
722         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
723 
724         return _tokenApprovals[tokenId];
725     }
726 
727     /**
728      * @dev See {IERC721-setApprovalForAll}.
729      */
730     function setApprovalForAll(address operator, bool approved) public virtual override {
731         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
732 
733         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
734         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
735     }
736 
737     /**
738      * @dev See {IERC721-isApprovedForAll}.
739      */
740     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
741         return _operatorApprovals[owner][operator];
742     }
743 
744     /**
745      * @dev See {IERC721-transferFrom}.
746      */
747     function transferFrom(
748         address from,
749         address to,
750         uint256 tokenId
751     ) public virtual override {
752         _transfer(from, to, tokenId);
753     }
754 
755     /**
756      * @dev See {IERC721-safeTransferFrom}.
757      */
758     function safeTransferFrom(
759         address from,
760         address to,
761         uint256 tokenId
762     ) public virtual override {
763         safeTransferFrom(from, to, tokenId, '');
764     }
765 
766     /**
767      * @dev See {IERC721-safeTransferFrom}.
768      */
769     function safeTransferFrom(
770         address from,
771         address to,
772         uint256 tokenId,
773         bytes memory _data
774     ) public virtual override {
775         _transfer(from, to, tokenId);
776         if (to.code.length != 0)
777             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
778                 revert TransferToNonERC721ReceiverImplementer();
779             }
780     }
781 
782     /**
783      * @dev Returns whether `tokenId` exists.
784      *
785      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
786      *
787      * Tokens start existing when they are minted (`_mint`),
788      */
789     function _exists(uint256 tokenId) internal view returns (bool) {
790         return
791             _startTokenId() <= tokenId &&
792             tokenId < _currentIndex && // If within bounds,
793             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
794     }
795 
796     /**
797      * @dev Equivalent to `_safeMint(to, quantity, '')`.
798      */
799     function _safeMint(address to, uint256 quantity) internal {
800         _safeMint(to, quantity, '');
801     }
802 
803     /**
804      * @dev Safely mints `quantity` tokens and transfers them to `to`.
805      *
806      * Requirements:
807      *
808      * - If `to` refers to a smart contract, it must implement
809      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
810      * - `quantity` must be greater than 0.
811      *
812      * Emits a {Transfer} event.
813      */
814     function _safeMint(
815         address to,
816         uint256 quantity,
817         bytes memory _data
818     ) internal {
819         uint256 startTokenId = _currentIndex;
820         if (to == address(0)) revert MintToZeroAddress();
821         if (quantity == 0) revert MintZeroQuantity();
822 
823         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
824 
825         // Overflows are incredibly unrealistic.
826         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
827         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
828         unchecked {
829             // Updates:
830             // - `balance += quantity`.
831             // - `numberMinted += quantity`.
832             //
833             // We can directly add to the balance and number minted.
834             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
835 
836             // Updates:
837             // - `address` to the owner.
838             // - `startTimestamp` to the timestamp of minting.
839             // - `burned` to `false`.
840             // - `nextInitialized` to `quantity == 1`.
841             _packedOwnerships[startTokenId] =
842                 _addressToUint256(to) |
843                 (block.timestamp << BITPOS_START_TIMESTAMP) |
844                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
845 
846             uint256 updatedIndex = startTokenId;
847             uint256 end = updatedIndex + quantity;
848 
849             if (to.code.length != 0) {
850                 do {
851                     emit Transfer(address(0), to, updatedIndex);
852                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
853                         revert TransferToNonERC721ReceiverImplementer();
854                     }
855                 } while (updatedIndex < end);
856                 // Reentrancy protection
857                 if (_currentIndex != startTokenId) revert();
858             } else {
859                 do {
860                     emit Transfer(address(0), to, updatedIndex++);
861                 } while (updatedIndex < end);
862             }
863             _currentIndex = updatedIndex;
864         }
865         _afterTokenTransfers(address(0), to, startTokenId, quantity);
866     }
867 
868     /**
869      * @dev Mints `quantity` tokens and transfers them to `to`.
870      *
871      * Requirements:
872      *
873      * - `to` cannot be the zero address.
874      * - `quantity` must be greater than 0.
875      *
876      * Emits a {Transfer} event.
877      */
878     function _mint(address to, uint256 quantity) internal {
879         uint256 startTokenId = _currentIndex;
880         if (to == address(0)) revert MintToZeroAddress();
881         if (quantity == 0) revert MintZeroQuantity();
882 
883         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
884 
885         // Overflows are incredibly unrealistic.
886         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
887         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
888         unchecked {
889             // Updates:
890             // - `balance += quantity`.
891             // - `numberMinted += quantity`.
892             //
893             // We can directly add to the balance and number minted.
894             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
895 
896             // Updates:
897             // - `address` to the owner.
898             // - `startTimestamp` to the timestamp of minting.
899             // - `burned` to `false`.
900             // - `nextInitialized` to `quantity == 1`.
901             _packedOwnerships[startTokenId] =
902                 _addressToUint256(to) |
903                 (block.timestamp << BITPOS_START_TIMESTAMP) |
904                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
905 
906             uint256 updatedIndex = startTokenId;
907             uint256 end = updatedIndex + quantity;
908 
909             do {
910                 emit Transfer(address(0), to, updatedIndex++);
911             } while (updatedIndex < end);
912 
913             _currentIndex = updatedIndex;
914         }
915         _afterTokenTransfers(address(0), to, startTokenId, quantity);
916     }
917 
918     /**
919      * @dev Transfers `tokenId` from `from` to `to`.
920      *
921      * Requirements:
922      *
923      * - `to` cannot be the zero address.
924      * - `tokenId` token must be owned by `from`.
925      *
926      * Emits a {Transfer} event.
927      */
928     function _transfer(
929         address from,
930         address to,
931         uint256 tokenId
932     ) private {
933         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
934 
935         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
936 
937         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
938             isApprovedForAll(from, _msgSenderERC721A()) ||
939             getApproved(tokenId) == _msgSenderERC721A());
940 
941         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
942         if (to == address(0)) revert TransferToZeroAddress();
943 
944         _beforeTokenTransfers(from, to, tokenId, 1);
945 
946         // Clear approvals from the previous owner.
947         delete _tokenApprovals[tokenId];
948 
949         // Underflow of the sender's balance is impossible because we check for
950         // ownership above and the recipient's balance can't realistically overflow.
951         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
952         unchecked {
953             // We can directly increment and decrement the balances.
954             --_packedAddressData[from]; // Updates: `balance -= 1`.
955             ++_packedAddressData[to]; // Updates: `balance += 1`.
956 
957             // Updates:
958             // - `address` to the next owner.
959             // - `startTimestamp` to the timestamp of transfering.
960             // - `burned` to `false`.
961             // - `nextInitialized` to `true`.
962             _packedOwnerships[tokenId] =
963                 _addressToUint256(to) |
964                 (block.timestamp << BITPOS_START_TIMESTAMP) |
965                 BITMASK_NEXT_INITIALIZED;
966 
967             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
968             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
969                 uint256 nextTokenId = tokenId + 1;
970                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
971                 if (_packedOwnerships[nextTokenId] == 0) {
972                     // If the next slot is within bounds.
973                     if (nextTokenId != _currentIndex) {
974                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
975                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
976                     }
977                 }
978             }
979         }
980 
981         emit Transfer(from, to, tokenId);
982         _afterTokenTransfers(from, to, tokenId, 1);
983     }
984 
985     /**
986      * @dev Equivalent to `_burn(tokenId, false)`.
987      */
988     function _burn(uint256 tokenId) internal virtual {
989         _burn(tokenId, false);
990     }
991 
992     /**
993      * @dev Destroys `tokenId`.
994      * The approval is cleared when the token is burned.
995      *
996      * Requirements:
997      *
998      * - `tokenId` must exist.
999      *
1000      * Emits a {Transfer} event.
1001      */
1002     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1003         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1004 
1005         address from = address(uint160(prevOwnershipPacked));
1006 
1007         if (approvalCheck) {
1008             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1009                 isApprovedForAll(from, _msgSenderERC721A()) ||
1010                 getApproved(tokenId) == _msgSenderERC721A());
1011 
1012             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1013         }
1014 
1015         _beforeTokenTransfers(from, address(0), tokenId, 1);
1016 
1017         // Clear approvals from the previous owner.
1018         delete _tokenApprovals[tokenId];
1019 
1020         // Underflow of the sender's balance is impossible because we check for
1021         // ownership above and the recipient's balance can't realistically overflow.
1022         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1023         unchecked {
1024             // Updates:
1025             // - `balance -= 1`.
1026             // - `numberBurned += 1`.
1027             //
1028             // We can directly decrement the balance, and increment the number burned.
1029             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1030             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1031 
1032             // Updates:
1033             // - `address` to the last owner.
1034             // - `startTimestamp` to the timestamp of burning.
1035             // - `burned` to `true`.
1036             // - `nextInitialized` to `true`.
1037             _packedOwnerships[tokenId] =
1038                 _addressToUint256(from) |
1039                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1040                 BITMASK_BURNED | 
1041                 BITMASK_NEXT_INITIALIZED;
1042 
1043             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1044             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1045                 uint256 nextTokenId = tokenId + 1;
1046                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1047                 if (_packedOwnerships[nextTokenId] == 0) {
1048                     // If the next slot is within bounds.
1049                     if (nextTokenId != _currentIndex) {
1050                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1051                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1052                     }
1053                 }
1054             }
1055         }
1056 
1057         emit Transfer(from, address(0), tokenId);
1058         _afterTokenTransfers(from, address(0), tokenId, 1);
1059 
1060         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1061         unchecked {
1062             _burnCounter++;
1063         }
1064     }
1065 
1066     /**
1067      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1068      *
1069      * @param from address representing the previous owner of the given token ID
1070      * @param to target address that will receive the tokens
1071      * @param tokenId uint256 ID of the token to be transferred
1072      * @param _data bytes optional data to send along with the call
1073      * @return bool whether the call correctly returned the expected magic value
1074      */
1075     function _checkContractOnERC721Received(
1076         address from,
1077         address to,
1078         uint256 tokenId,
1079         bytes memory _data
1080     ) private returns (bool) {
1081         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1082             bytes4 retval
1083         ) {
1084             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1085         } catch (bytes memory reason) {
1086             if (reason.length == 0) {
1087                 revert TransferToNonERC721ReceiverImplementer();
1088             } else {
1089                 assembly {
1090                     revert(add(32, reason), mload(reason))
1091                 }
1092             }
1093         }
1094     }
1095 
1096     /**
1097      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1098      * And also called before burning one token.
1099      *
1100      * startTokenId - the first token id to be transferred
1101      * quantity - the amount to be transferred
1102      *
1103      * Calling conditions:
1104      *
1105      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1106      * transferred to `to`.
1107      * - When `from` is zero, `tokenId` will be minted for `to`.
1108      * - When `to` is zero, `tokenId` will be burned by `from`.
1109      * - `from` and `to` are never both zero.
1110      */
1111     function _beforeTokenTransfers(
1112         address from,
1113         address to,
1114         uint256 startTokenId,
1115         uint256 quantity
1116     ) internal virtual {}
1117 
1118     /**
1119      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1120      * minting.
1121      * And also called after one token has been burned.
1122      *
1123      * startTokenId - the first token id to be transferred
1124      * quantity - the amount to be transferred
1125      *
1126      * Calling conditions:
1127      *
1128      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1129      * transferred to `to`.
1130      * - When `from` is zero, `tokenId` has been minted for `to`.
1131      * - When `to` is zero, `tokenId` has been burned by `from`.
1132      * - `from` and `to` are never both zero.
1133      */
1134     function _afterTokenTransfers(
1135         address from,
1136         address to,
1137         uint256 startTokenId,
1138         uint256 quantity
1139     ) internal virtual {}
1140 
1141     /**
1142      * @dev Returns the message sender (defaults to `msg.sender`).
1143      *
1144      * If you are writing GSN compatible contracts, you need to override this function.
1145      */
1146     function _msgSenderERC721A() internal view virtual returns (address) {
1147         return msg.sender;
1148     }
1149 
1150     /**
1151      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1152      */
1153     function _toString(uint256 value) internal pure returns (string memory ptr) {
1154         assembly {
1155             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1156             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1157             // We will need 1 32-byte word to store the length, 
1158             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1159             ptr := add(mload(0x40), 128)
1160             // Update the free memory pointer to allocate.
1161             mstore(0x40, ptr)
1162 
1163             // Cache the end of the memory to calculate the length later.
1164             let end := ptr
1165 
1166             // We write the string from the rightmost digit to the leftmost digit.
1167             // The following is essentially a do-while loop that also handles the zero case.
1168             // Costs a bit more than early returning for the zero case,
1169             // but cheaper in terms of deployment and overall runtime costs.
1170             for { 
1171                 // Initialize and perform the first pass without check.
1172                 let temp := value
1173                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1174                 ptr := sub(ptr, 1)
1175                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1176                 mstore8(ptr, add(48, mod(temp, 10)))
1177                 temp := div(temp, 10)
1178             } temp { 
1179                 // Keep dividing `temp` until zero.
1180                 temp := div(temp, 10)
1181             } { // Body of the for loop.
1182                 ptr := sub(ptr, 1)
1183                 mstore8(ptr, add(48, mod(temp, 10)))
1184             }
1185             
1186             let length := sub(end, ptr)
1187             // Move the pointer 32 bytes leftwards to make room for the length.
1188             ptr := sub(ptr, 32)
1189             // Store the length.
1190             mstore(ptr, length)
1191         }
1192     }
1193 }
1194 
1195 // File: nft.sol
1196 
1197 
1198 // SPDX-License-Identifier: MIT
1199 pragma solidity ^0.8.13;
1200 
1201 
1202 
1203 contract DiscordAvatar is Ownable, ERC721A {
1204     uint256 public maxSupply                    = 10000;
1205     uint256 public maxFreeSupply                = 0;
1206     
1207     uint256 public maxPerTxDuringMint           = 1;
1208     uint256 public maxPerAddressDuringMint      = 1;
1209     uint256 public maxPerAddressDuringFreeMint  = 1;
1210     
1211     uint256 public price                        = 0.0069 ether;
1212     bool    public saleIsActive                 = false;
1213 
1214     address constant internal TEAM_ADDRESS = 0x556B892Ad1Fe260DFE68880992D189E4FDfaD2A6;
1215 
1216     string private _baseTokenURI;
1217 
1218     mapping(address => uint256) public freeMintedAmount;
1219     mapping(address => uint256) public mintedAmount;
1220 
1221     constructor() ERC721A("FuckCopyTraders", "FCT") {
1222         _safeMint(msg.sender, 1);
1223     }
1224 
1225     modifier mintCompliance() {
1226         require(saleIsActive, "Sale is not active yet.");
1227         require(tx.origin == msg.sender, "Wrong Caller");
1228         _;
1229     }
1230 
1231     function mint(uint256 _quantity) external payable mintCompliance() {
1232         require(
1233             msg.value >= price * _quantity,
1234             "GDZ: Insufficient Fund."
1235         );
1236         require(
1237             maxSupply >= totalSupply() + _quantity,
1238             "GDZ: Exceeds max supply."
1239         );
1240         uint256 _mintedAmount = mintedAmount[msg.sender];
1241         require(
1242             _mintedAmount + _quantity <= maxPerAddressDuringMint,
1243             "GDZ: Exceeds max mints per address!"
1244         );
1245         require(
1246             _quantity > 0 && _quantity <= maxPerTxDuringMint,
1247             "Invalid mint amount."
1248         );
1249         mintedAmount[msg.sender] = _mintedAmount + _quantity;
1250         _safeMint(msg.sender, _quantity);
1251     }
1252 
1253     function freeMint(uint256 _quantity) external mintCompliance() {
1254         require(
1255             maxFreeSupply >= totalSupply() + _quantity,
1256             "GDZ: Exceeds max supply."
1257         );
1258         uint256 _freeMintedAmount = freeMintedAmount[msg.sender];
1259         require(
1260             _freeMintedAmount + _quantity <= maxPerAddressDuringFreeMint,
1261             "GDZ: Exceeds max free mints per address!"
1262         );
1263         freeMintedAmount[msg.sender] = _freeMintedAmount + _quantity;
1264         _safeMint(msg.sender, _quantity);
1265     }
1266 
1267     function setPrice(uint256 _price) external onlyOwner {
1268         price = _price;
1269     }
1270 
1271     function setMaxPerTx(uint256 _amount) external onlyOwner {
1272         maxPerTxDuringMint = _amount;
1273     }
1274 
1275     function setMaxPerAddress(uint256 _amount) external onlyOwner {
1276         maxPerAddressDuringMint = _amount;
1277     }
1278 
1279     function setMaxFreePerAddress(uint256 _amount) external onlyOwner {
1280         maxPerAddressDuringFreeMint = _amount;
1281     }
1282 
1283     function flipSale() public onlyOwner {
1284         saleIsActive = !saleIsActive;
1285     }
1286 
1287     function cutMaxSupply(uint256 _amount) public onlyOwner {
1288         require(
1289             maxSupply - _amount >= totalSupply(), 
1290             "Supply cannot fall below minted tokens."
1291         );
1292         maxSupply -= _amount;
1293     }
1294 
1295     function setBaseURI(string calldata baseURI) external onlyOwner {
1296         _baseTokenURI = baseURI;
1297     }
1298 
1299     function _baseURI() internal view virtual override returns (string memory) {
1300         return _baseTokenURI;
1301     }
1302 
1303     function withdrawBalance() external payable onlyOwner {
1304 
1305         (bool success, ) = payable(TEAM_ADDRESS).call{
1306             value: address(this).balance
1307         }("");
1308         require(success, "transfer failed.");
1309     }
1310 }