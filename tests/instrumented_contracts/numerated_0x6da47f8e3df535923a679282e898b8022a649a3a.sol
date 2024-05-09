1 /**
2  *Submitted for verification at Etherscan.io on 2022-06-02
3 */
4 
5 // File: @openzeppelin/contracts/utils/Context.sol
6 
7 
8 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
9 
10 pragma solidity ^0.8.0;
11 
12 /**
13  * @dev Provides information about the current execution context, including the
14  * sender of the transaction and its data. While these are generally available
15  * via msg.sender and msg.data, they should not be accessed in such a direct
16  * manner, since when dealing with meta-transactions the account sending and
17  * paying for execution may not be the actual sender (as far as an application
18  * is concerned).
19  *
20  * This contract is only required for intermediate, library-like contracts.
21  */
22 abstract contract Context {
23     function _msgSender() internal view virtual returns (address) {
24         return msg.sender;
25     }
26 
27     function _msgData() internal view virtual returns (bytes calldata) {
28         return msg.data;
29     }
30 }
31 
32 // File: @openzeppelin/contracts/access/Ownable.sol
33 
34 
35 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
36 
37 pragma solidity ^0.8.0;
38 
39 
40 /**
41  * @dev Contract module which provides a basic access control mechanism, where
42  * there is an account (an owner) that can be granted exclusive access to
43  * specific functions.
44  *
45  * By default, the owner account will be the one that deploys the contract. This
46  * can later be changed with {transferOwnership}.
47  *
48  * This module is used through inheritance. It will make available the modifier
49  * `onlyOwner`, which can be applied to your functions to restrict their use to
50  * the owner.
51  */
52 abstract contract Ownable is Context {
53     address private _owner;
54 
55     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
56 
57     /**
58      * @dev Initializes the contract setting the deployer as the initial owner.
59      */
60     constructor() {
61         _transferOwnership(_msgSender());
62     }
63 
64     /**
65      * @dev Returns the address of the current owner.
66      */
67     function owner() public view virtual returns (address) {
68         return _owner;
69     }
70 
71     /**
72      * @dev Throws if called by any account other than the owner.
73      */
74     modifier onlyOwner() {
75         require(owner() == _msgSender(), "Ownable: caller is not the owner");
76         _;
77     }
78 
79     /**
80      * @dev Leaves the contract without owner. It will not be possible to call
81      * `onlyOwner` functions anymore. Can only be called by the current owner.
82      *
83      * NOTE: Renouncing ownership will leave the contract without an owner,
84      * thereby removing any functionality that is only available to the owner.
85      */
86     function renounceOwnership() public virtual onlyOwner {
87         _transferOwnership(address(0));
88     }
89 
90     /**
91      * @dev Transfers ownership of the contract to a new account (`newOwner`).
92      * Can only be called by the current owner.
93      */
94     function transferOwnership(address newOwner) public virtual onlyOwner {
95         require(newOwner != address(0), "Ownable: new owner is the zero address");
96         _transferOwnership(newOwner);
97     }
98 
99     /**
100      * @dev Transfers ownership of the contract to a new account (`newOwner`).
101      * Internal function without access restriction.
102      */
103     function _transferOwnership(address newOwner) internal virtual {
104         address oldOwner = _owner;
105         _owner = newOwner;
106         emit OwnershipTransferred(oldOwner, newOwner);
107     }
108 }
109 
110 // File: erc721a/contracts/IERC721A.sol
111 
112 
113 // ERC721A Contracts v4.0.0
114 // Creator: Chiru Labs
115 
116 pragma solidity ^0.8.4;
117 
118 /**
119  * @dev Interface of an ERC721A compliant contract.
120  */
121 interface IERC721A {
122     /**
123      * The caller must own the token or be an approved operator.
124      */
125     error ApprovalCallerNotOwnerNorApproved();
126 
127     /**
128      * The token does not exist.
129      */
130     error ApprovalQueryForNonexistentToken();
131 
132     /**
133      * The caller cannot approve to their own address.
134      */
135     error ApproveToCaller();
136 
137     /**
138      * The caller cannot approve to the current owner.
139      */
140     error ApprovalToCurrentOwner();
141 
142     /**
143      * Cannot query the balance for the zero address.
144      */
145     error BalanceQueryForZeroAddress();
146 
147     /**
148      * Cannot mint to the zero address.
149      */
150     error MintToZeroAddress();
151 
152     /**
153      * The quantity of tokens minted must be more than zero.
154      */
155     error MintZeroQuantity();
156 
157     /**
158      * The token does not exist.
159      */
160     error OwnerQueryForNonexistentToken();
161 
162     /**
163      * The caller must own the token or be an approved operator.
164      */
165     error TransferCallerNotOwnerNorApproved();
166 
167     /**
168      * The token must be owned by `from`.
169      */
170     error TransferFromIncorrectOwner();
171 
172     /**
173      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
174      */
175     error TransferToNonERC721ReceiverImplementer();
176 
177     /**
178      * Cannot transfer to the zero address.
179      */
180     error TransferToZeroAddress();
181 
182     /**
183      * The token does not exist.
184      */
185     error URIQueryForNonexistentToken();
186 
187     struct TokenOwnership {
188         // The address of the owner.
189         address addr;
190         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
191         uint64 startTimestamp;
192         // Whether the token has been burned.
193         bool burned;
194     }
195 
196     /**
197      * @dev Returns the total amount of tokens stored by the contract.
198      *
199      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
200      */
201     function totalSupply() external view returns (uint256);
202 
203     // ==============================
204     //            IERC165
205     // ==============================
206 
207     /**
208      * @dev Returns true if this contract implements the interface defined by
209      * `interfaceId`. See the corresponding
210      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
211      * to learn more about how these ids are created.
212      *
213      * This function call must use less than 30 000 gas.
214      */
215     function supportsInterface(bytes4 interfaceId) external view returns (bool);
216 
217     // ==============================
218     //            IERC721
219     // ==============================
220 
221     /**
222      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
223      */
224     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
225 
226     /**
227      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
228      */
229     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
230 
231     /**
232      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
233      */
234     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
235 
236     /**
237      * @dev Returns the number of tokens in ``owner``'s account.
238      */
239     function balanceOf(address owner) external view returns (uint256 balance);
240 
241     /**
242      * @dev Returns the owner of the `tokenId` token.
243      *
244      * Requirements:
245      *
246      * - `tokenId` must exist.
247      */
248     function ownerOf(uint256 tokenId) external view returns (address owner);
249 
250     /**
251      * @dev Safely transfers `tokenId` token from `from` to `to`.
252      *
253      * Requirements:
254      *
255      * - `from` cannot be the zero address.
256      * - `to` cannot be the zero address.
257      * - `tokenId` token must exist and be owned by `from`.
258      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
259      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
260      *
261      * Emits a {Transfer} event.
262      */
263     function safeTransferFrom(
264         address from,
265         address to,
266         uint256 tokenId,
267         bytes calldata data
268     ) external;
269 
270     /**
271      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
272      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
273      *
274      * Requirements:
275      *
276      * - `from` cannot be the zero address.
277      * - `to` cannot be the zero address.
278      * - `tokenId` token must exist and be owned by `from`.
279      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
280      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
281      *
282      * Emits a {Transfer} event.
283      */
284     function safeTransferFrom(
285         address from,
286         address to,
287         uint256 tokenId
288     ) external;
289 
290     /**
291      * @dev Transfers `tokenId` token from `from` to `to`.
292      *
293      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
294      *
295      * Requirements:
296      *
297      * - `from` cannot be the zero address.
298      * - `to` cannot be the zero address.
299      * - `tokenId` token must be owned by `from`.
300      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
301      *
302      * Emits a {Transfer} event.
303      */
304     function transferFrom(
305         address from,
306         address to,
307         uint256 tokenId
308     ) external;
309 
310     /**
311      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
312      * The approval is cleared when the token is transferred.
313      *
314      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
315      *
316      * Requirements:
317      *
318      * - The caller must own the token or be an approved operator.
319      * - `tokenId` must exist.
320      *
321      * Emits an {Approval} event.
322      */
323     function approve(address to, uint256 tokenId) external;
324 
325     /**
326      * @dev Approve or remove `operator` as an operator for the caller.
327      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
328      *
329      * Requirements:
330      *
331      * - The `operator` cannot be the caller.
332      *
333      * Emits an {ApprovalForAll} event.
334      */
335     function setApprovalForAll(address operator, bool _approved) external;
336 
337     /**
338      * @dev Returns the account approved for `tokenId` token.
339      *
340      * Requirements:
341      *
342      * - `tokenId` must exist.
343      */
344     function getApproved(uint256 tokenId) external view returns (address operator);
345 
346     /**
347      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
348      *
349      * See {setApprovalForAll}
350      */
351     function isApprovedForAll(address owner, address operator) external view returns (bool);
352 
353     // ==============================
354     //        IERC721Metadata
355     // ==============================
356 
357     /**
358      * @dev Returns the token collection name.
359      */
360     function name() external view returns (string memory);
361 
362     /**
363      * @dev Returns the token collection symbol.
364      */
365     function symbol() external view returns (string memory);
366 
367     /**
368      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
369      */
370     function tokenURI(uint256 tokenId) external view returns (string memory);
371 }
372 
373 // File: erc721a/contracts/ERC721A.sol
374 
375 
376 // ERC721A Contracts v4.0.0
377 // Creator: Chiru Labs
378 
379 pragma solidity ^0.8.4;
380 
381 
382 /**
383  * @dev ERC721 token receiver interface.
384  */
385 interface ERC721A__IERC721Receiver {
386     function onERC721Received(
387         address operator,
388         address from,
389         uint256 tokenId,
390         bytes calldata data
391     ) external returns (bytes4);
392 }
393 
394 /**
395  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
396  * the Metadata extension. Built to optimize for lower gas during batch mints.
397  *
398  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
399  *
400  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
401  *
402  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
403  */
404 contract ERC721A is IERC721A {
405     // Mask of an entry in packed address data.
406     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
407 
408     // The bit position of `numberMinted` in packed address data.
409     uint256 private constant BITPOS_NUMBER_MINTED = 64;
410 
411     // The bit position of `numberBurned` in packed address data.
412     uint256 private constant BITPOS_NUMBER_BURNED = 128;
413 
414     // The bit position of `aux` in packed address data.
415     uint256 private constant BITPOS_AUX = 192;
416 
417     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
418     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
419 
420     // The bit position of `startTimestamp` in packed ownership.
421     uint256 private constant BITPOS_START_TIMESTAMP = 160;
422 
423     // The bit mask of the `burned` bit in packed ownership.
424     uint256 private constant BITMASK_BURNED = 1 << 224;
425     
426     // The bit position of the `nextInitialized` bit in packed ownership.
427     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
428 
429     // The bit mask of the `nextInitialized` bit in packed ownership.
430     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
431 
432     // The tokenId of the next token to be minted.
433     uint256 private _currentIndex;
434 
435     // The number of tokens burned.
436     uint256 private _burnCounter;
437 
438     // Token name
439     string private _name;
440 
441     // Token symbol
442     string private _symbol;
443 
444     // Mapping from token ID to ownership details
445     // An empty struct value does not necessarily mean the token is unowned.
446     // See `_packedOwnershipOf` implementation for details.
447     //
448     // Bits Layout:
449     // - [0..159]   `addr`
450     // - [160..223] `startTimestamp`
451     // - [224]      `burned`
452     // - [225]      `nextInitialized`
453     mapping(uint256 => uint256) private _packedOwnerships;
454 
455     // Mapping owner address to address data.
456     //
457     // Bits Layout:
458     // - [0..63]    `balance`
459     // - [64..127]  `numberMinted`
460     // - [128..191] `numberBurned`
461     // - [192..255] `aux`
462     mapping(address => uint256) private _packedAddressData;
463 
464     // Mapping from token ID to approved address.
465     mapping(uint256 => address) private _tokenApprovals;
466 
467     // Mapping from owner to operator approvals
468     mapping(address => mapping(address => bool)) private _operatorApprovals;
469 
470     constructor(string memory name_, string memory symbol_) {
471         _name = name_;
472         _symbol = symbol_;
473         _currentIndex = _startTokenId();
474     }
475 
476     /**
477      * @dev Returns the starting token ID. 
478      * To change the starting token ID, please override this function.
479      */
480     function _startTokenId() internal view virtual returns (uint256) {
481         return 0;
482     }
483 
484     /**
485      * @dev Returns the next token ID to be minted.
486      */
487     function _nextTokenId() internal view returns (uint256) {
488         return _currentIndex;
489     }
490 
491     /**
492      * @dev Returns the total number of tokens in existence.
493      * Burned tokens will reduce the count. 
494      * To get the total number of tokens minted, please see `_totalMinted`.
495      */
496     function totalSupply() public view override returns (uint256) {
497         // Counter underflow is impossible as _burnCounter cannot be incremented
498         // more than `_currentIndex - _startTokenId()` times.
499         unchecked {
500             return _currentIndex - _burnCounter - _startTokenId();
501         }
502     }
503 
504     /**
505      * @dev Returns the total amount of tokens minted in the contract.
506      */
507     function _totalMinted() internal view returns (uint256) {
508         // Counter underflow is impossible as _currentIndex does not decrement,
509         // and it is initialized to `_startTokenId()`
510         unchecked {
511             return _currentIndex - _startTokenId();
512         }
513     }
514 
515     /**
516      * @dev Returns the total number of tokens burned.
517      */
518     function _totalBurned() internal view returns (uint256) {
519         return _burnCounter;
520     }
521 
522     /**
523      * @dev See {IERC165-supportsInterface}.
524      */
525     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
526         // The interface IDs are constants representing the first 4 bytes of the XOR of
527         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
528         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
529         return
530             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
531             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
532             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
533     }
534 
535     /**
536      * @dev See {IERC721-balanceOf}.
537      */
538     function balanceOf(address owner) public view override returns (uint256) {
539         if (owner == address(0)) revert BalanceQueryForZeroAddress();
540         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
541     }
542 
543     /**
544      * Returns the number of tokens minted by `owner`.
545      */
546     function _numberMinted(address owner) internal view returns (uint256) {
547         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
548     }
549 
550     /**
551      * Returns the number of tokens burned by or on behalf of `owner`.
552      */
553     function _numberBurned(address owner) internal view returns (uint256) {
554         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
555     }
556 
557     /**
558      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
559      */
560     function _getAux(address owner) internal view returns (uint64) {
561         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
562     }
563 
564     /**
565      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
566      * If there are multiple variables, please pack them into a uint64.
567      */
568     function _setAux(address owner, uint64 aux) internal {
569         uint256 packed = _packedAddressData[owner];
570         uint256 auxCasted;
571         assembly { // Cast aux without masking.
572             auxCasted := aux
573         }
574         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
575         _packedAddressData[owner] = packed;
576     }
577 
578     /**
579      * Returns the packed ownership data of `tokenId`.
580      */
581     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
582         uint256 curr = tokenId;
583 
584         unchecked {
585             if (_startTokenId() <= curr)
586                 if (curr < _currentIndex) {
587                     uint256 packed = _packedOwnerships[curr];
588                     // If not burned.
589                     if (packed & BITMASK_BURNED == 0) {
590                         // Invariant:
591                         // There will always be an ownership that has an address and is not burned
592                         // before an ownership that does not have an address and is not burned.
593                         // Hence, curr will not underflow.
594                         //
595                         // We can directly compare the packed value.
596                         // If the address is zero, packed is zero.
597                         while (packed == 0) {
598                             packed = _packedOwnerships[--curr];
599                         }
600                         return packed;
601                     }
602                 }
603         }
604         revert OwnerQueryForNonexistentToken();
605     }
606 
607     /**
608      * Returns the unpacked `TokenOwnership` struct from `packed`.
609      */
610     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
611         ownership.addr = address(uint160(packed));
612         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
613         ownership.burned = packed & BITMASK_BURNED != 0;
614     }
615 
616     /**
617      * Returns the unpacked `TokenOwnership` struct at `index`.
618      */
619     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
620         return _unpackedOwnership(_packedOwnerships[index]);
621     }
622 
623     /**
624      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
625      */
626     function _initializeOwnershipAt(uint256 index) internal {
627         if (_packedOwnerships[index] == 0) {
628             _packedOwnerships[index] = _packedOwnershipOf(index);
629         }
630     }
631 
632     /**
633      * Gas spent here starts off proportional to the maximum mint batch size.
634      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
635      */
636     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
637         return _unpackedOwnership(_packedOwnershipOf(tokenId));
638     }
639 
640     /**
641      * @dev See {IERC721-ownerOf}.
642      */
643     function ownerOf(uint256 tokenId) public view override returns (address) {
644         return address(uint160(_packedOwnershipOf(tokenId)));
645     }
646 
647     /**
648      * @dev See {IERC721Metadata-name}.
649      */
650     function name() public view virtual override returns (string memory) {
651         return _name;
652     }
653 
654     /**
655      * @dev See {IERC721Metadata-symbol}.
656      */
657     function symbol() public view virtual override returns (string memory) {
658         return _symbol;
659     }
660 
661     /**
662      * @dev See {IERC721Metadata-tokenURI}.
663      */
664     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
665         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
666 
667         string memory baseURI = _baseURI();
668         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
669     }
670 
671     /**
672      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
673      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
674      * by default, can be overriden in child contracts.
675      */
676     function _baseURI() internal view virtual returns (string memory) {
677         return '';
678     }
679 
680     /**
681      * @dev Casts the address to uint256 without masking.
682      */
683     function _addressToUint256(address value) private pure returns (uint256 result) {
684         assembly {
685             result := value
686         }
687     }
688 
689     /**
690      * @dev Casts the boolean to uint256 without branching.
691      */
692     function _boolToUint256(bool value) private pure returns (uint256 result) {
693         assembly {
694             result := value
695         }
696     }
697 
698     /**
699      * @dev See {IERC721-approve}.
700      */
701     function approve(address to, uint256 tokenId) public override {
702         address owner = address(uint160(_packedOwnershipOf(tokenId)));
703         if (to == owner) revert ApprovalToCurrentOwner();
704 
705         if (_msgSenderERC721A() != owner)
706             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
707                 revert ApprovalCallerNotOwnerNorApproved();
708             }
709 
710         _tokenApprovals[tokenId] = to;
711         emit Approval(owner, to, tokenId);
712     }
713 
714     /**
715      * @dev See {IERC721-getApproved}.
716      */
717     function getApproved(uint256 tokenId) public view override returns (address) {
718         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
719 
720         return _tokenApprovals[tokenId];
721     }
722 
723     /**
724      * @dev See {IERC721-setApprovalForAll}.
725      */
726     function setApprovalForAll(address operator, bool approved) public virtual override {
727         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
728 
729         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
730         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
731     }
732 
733     /**
734      * @dev See {IERC721-isApprovedForAll}.
735      */
736     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
737         return _operatorApprovals[owner][operator];
738     }
739 
740     /**
741      * @dev See {IERC721-transferFrom}.
742      */
743     function transferFrom(
744         address from,
745         address to,
746         uint256 tokenId
747     ) public virtual override {
748         _transfer(from, to, tokenId);
749     }
750 
751     /**
752      * @dev See {IERC721-safeTransferFrom}.
753      */
754     function safeTransferFrom(
755         address from,
756         address to,
757         uint256 tokenId
758     ) public virtual override {
759         safeTransferFrom(from, to, tokenId, '');
760     }
761 
762     /**
763      * @dev See {IERC721-safeTransferFrom}.
764      */
765     function safeTransferFrom(
766         address from,
767         address to,
768         uint256 tokenId,
769         bytes memory _data
770     ) public virtual override {
771         _transfer(from, to, tokenId);
772         if (to.code.length != 0)
773             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
774                 revert TransferToNonERC721ReceiverImplementer();
775             }
776     }
777 
778     /**
779      * @dev Returns whether `tokenId` exists.
780      *
781      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
782      *
783      * Tokens start existing when they are minted (`_mint`),
784      */
785     function _exists(uint256 tokenId) internal view returns (bool) {
786         return
787             _startTokenId() <= tokenId &&
788             tokenId < _currentIndex && // If within bounds,
789             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
790     }
791 
792     /**
793      * @dev Equivalent to `_safeMint(to, quantity, '')`.
794      */
795     function _safeMint(address to, uint256 quantity) internal {
796         _safeMint(to, quantity, '');
797     }
798 
799     /**
800      * @dev Safely mints `quantity` tokens and transfers them to `to`.
801      *
802      * Requirements:
803      *
804      * - If `to` refers to a smart contract, it must implement
805      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
806      * - `quantity` must be greater than 0.
807      *
808      * Emits a {Transfer} event.
809      */
810     function _safeMint(
811         address to,
812         uint256 quantity,
813         bytes memory _data
814     ) internal {
815         uint256 startTokenId = _currentIndex;
816         if (to == address(0)) revert MintToZeroAddress();
817         if (quantity == 0) revert MintZeroQuantity();
818 
819         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
820 
821         // Overflows are incredibly unrealistic.
822         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
823         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
824         unchecked {
825             // Updates:
826             // - `balance += quantity`.
827             // - `numberMinted += quantity`.
828             //
829             // We can directly add to the balance and number minted.
830             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
831 
832             // Updates:
833             // - `address` to the owner.
834             // - `startTimestamp` to the timestamp of minting.
835             // - `burned` to `false`.
836             // - `nextInitialized` to `quantity == 1`.
837             _packedOwnerships[startTokenId] =
838                 _addressToUint256(to) |
839                 (block.timestamp << BITPOS_START_TIMESTAMP) |
840                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
841 
842             uint256 updatedIndex = startTokenId;
843             uint256 end = updatedIndex + quantity;
844 
845             if (to.code.length != 0) {
846                 do {
847                     emit Transfer(address(0), to, updatedIndex);
848                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
849                         revert TransferToNonERC721ReceiverImplementer();
850                     }
851                 } while (updatedIndex < end);
852                 // Reentrancy protection
853                 if (_currentIndex != startTokenId) revert();
854             } else {
855                 do {
856                     emit Transfer(address(0), to, updatedIndex++);
857                 } while (updatedIndex < end);
858             }
859             _currentIndex = updatedIndex;
860         }
861         _afterTokenTransfers(address(0), to, startTokenId, quantity);
862     }
863 
864     /**
865      * @dev Mints `quantity` tokens and transfers them to `to`.
866      *
867      * Requirements:
868      *
869      * - `to` cannot be the zero address.
870      * - `quantity` must be greater than 0.
871      *
872      * Emits a {Transfer} event.
873      */
874     function _mint(address to, uint256 quantity) internal {
875         uint256 startTokenId = _currentIndex;
876         if (to == address(0)) revert MintToZeroAddress();
877         if (quantity == 0) revert MintZeroQuantity();
878 
879         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
880 
881         // Overflows are incredibly unrealistic.
882         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
883         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
884         unchecked {
885             // Updates:
886             // - `balance += quantity`.
887             // - `numberMinted += quantity`.
888             //
889             // We can directly add to the balance and number minted.
890             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
891 
892             // Updates:
893             // - `address` to the owner.
894             // - `startTimestamp` to the timestamp of minting.
895             // - `burned` to `false`.
896             // - `nextInitialized` to `quantity == 1`.
897             _packedOwnerships[startTokenId] =
898                 _addressToUint256(to) |
899                 (block.timestamp << BITPOS_START_TIMESTAMP) |
900                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
901 
902             uint256 updatedIndex = startTokenId;
903             uint256 end = updatedIndex + quantity;
904 
905             do {
906                 emit Transfer(address(0), to, updatedIndex++);
907             } while (updatedIndex < end);
908 
909             _currentIndex = updatedIndex;
910         }
911         _afterTokenTransfers(address(0), to, startTokenId, quantity);
912     }
913 
914     /**
915      * @dev Transfers `tokenId` from `from` to `to`.
916      *
917      * Requirements:
918      *
919      * - `to` cannot be the zero address.
920      * - `tokenId` token must be owned by `from`.
921      *
922      * Emits a {Transfer} event.
923      */
924     function _transfer(
925         address from,
926         address to,
927         uint256 tokenId
928     ) private {
929         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
930 
931         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
932 
933         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
934             isApprovedForAll(from, _msgSenderERC721A()) ||
935             getApproved(tokenId) == _msgSenderERC721A());
936 
937         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
938         if (to == address(0)) revert TransferToZeroAddress();
939 
940         _beforeTokenTransfers(from, to, tokenId, 1);
941 
942         // Clear approvals from the previous owner.
943         delete _tokenApprovals[tokenId];
944 
945         // Underflow of the sender's balance is impossible because we check for
946         // ownership above and the recipient's balance can't realistically overflow.
947         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
948         unchecked {
949             // We can directly increment and decrement the balances.
950             --_packedAddressData[from]; // Updates: `balance -= 1`.
951             ++_packedAddressData[to]; // Updates: `balance += 1`.
952 
953             // Updates:
954             // - `address` to the next owner.
955             // - `startTimestamp` to the timestamp of transfering.
956             // - `burned` to `false`.
957             // - `nextInitialized` to `true`.
958             _packedOwnerships[tokenId] =
959                 _addressToUint256(to) |
960                 (block.timestamp << BITPOS_START_TIMESTAMP) |
961                 BITMASK_NEXT_INITIALIZED;
962 
963             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
964             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
965                 uint256 nextTokenId = tokenId + 1;
966                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
967                 if (_packedOwnerships[nextTokenId] == 0) {
968                     // If the next slot is within bounds.
969                     if (nextTokenId != _currentIndex) {
970                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
971                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
972                     }
973                 }
974             }
975         }
976 
977         emit Transfer(from, to, tokenId);
978         _afterTokenTransfers(from, to, tokenId, 1);
979     }
980 
981     /**
982      * @dev Equivalent to `_burn(tokenId, false)`.
983      */
984     function _burn(uint256 tokenId) internal virtual {
985         _burn(tokenId, false);
986     }
987 
988     /**
989      * @dev Destroys `tokenId`.
990      * The approval is cleared when the token is burned.
991      *
992      * Requirements:
993      *
994      * - `tokenId` must exist.
995      *
996      * Emits a {Transfer} event.
997      */
998     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
999         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1000 
1001         address from = address(uint160(prevOwnershipPacked));
1002 
1003         if (approvalCheck) {
1004             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1005                 isApprovedForAll(from, _msgSenderERC721A()) ||
1006                 getApproved(tokenId) == _msgSenderERC721A());
1007 
1008             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1009         }
1010 
1011         _beforeTokenTransfers(from, address(0), tokenId, 1);
1012 
1013         // Clear approvals from the previous owner.
1014         delete _tokenApprovals[tokenId];
1015 
1016         // Underflow of the sender's balance is impossible because we check for
1017         // ownership above and the recipient's balance can't realistically overflow.
1018         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1019         unchecked {
1020             // Updates:
1021             // - `balance -= 1`.
1022             // - `numberBurned += 1`.
1023             //
1024             // We can directly decrement the balance, and increment the number burned.
1025             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1026             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1027 
1028             // Updates:
1029             // - `address` to the last owner.
1030             // - `startTimestamp` to the timestamp of burning.
1031             // - `burned` to `true`.
1032             // - `nextInitialized` to `true`.
1033             _packedOwnerships[tokenId] =
1034                 _addressToUint256(from) |
1035                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1036                 BITMASK_BURNED | 
1037                 BITMASK_NEXT_INITIALIZED;
1038 
1039             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1040             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1041                 uint256 nextTokenId = tokenId + 1;
1042                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1043                 if (_packedOwnerships[nextTokenId] == 0) {
1044                     // If the next slot is within bounds.
1045                     if (nextTokenId != _currentIndex) {
1046                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1047                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1048                     }
1049                 }
1050             }
1051         }
1052 
1053         emit Transfer(from, address(0), tokenId);
1054         _afterTokenTransfers(from, address(0), tokenId, 1);
1055 
1056         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1057         unchecked {
1058             _burnCounter++;
1059         }
1060     }
1061 
1062     /**
1063      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1064      *
1065      * @param from address representing the previous owner of the given token ID
1066      * @param to target address that will receive the tokens
1067      * @param tokenId uint256 ID of the token to be transferred
1068      * @param _data bytes optional data to send along with the call
1069      * @return bool whether the call correctly returned the expected magic value
1070      */
1071     function _checkContractOnERC721Received(
1072         address from,
1073         address to,
1074         uint256 tokenId,
1075         bytes memory _data
1076     ) private returns (bool) {
1077         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1078             bytes4 retval
1079         ) {
1080             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1081         } catch (bytes memory reason) {
1082             if (reason.length == 0) {
1083                 revert TransferToNonERC721ReceiverImplementer();
1084             } else {
1085                 assembly {
1086                     revert(add(32, reason), mload(reason))
1087                 }
1088             }
1089         }
1090     }
1091 
1092     /**
1093      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1094      * And also called before burning one token.
1095      *
1096      * startTokenId - the first token id to be transferred
1097      * quantity - the amount to be transferred
1098      *
1099      * Calling conditions:
1100      *
1101      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1102      * transferred to `to`.
1103      * - When `from` is zero, `tokenId` will be minted for `to`.
1104      * - When `to` is zero, `tokenId` will be burned by `from`.
1105      * - `from` and `to` are never both zero.
1106      */
1107     function _beforeTokenTransfers(
1108         address from,
1109         address to,
1110         uint256 startTokenId,
1111         uint256 quantity
1112     ) internal virtual {}
1113 
1114     /**
1115      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1116      * minting.
1117      * And also called after one token has been burned.
1118      *
1119      * startTokenId - the first token id to be transferred
1120      * quantity - the amount to be transferred
1121      *
1122      * Calling conditions:
1123      *
1124      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1125      * transferred to `to`.
1126      * - When `from` is zero, `tokenId` has been minted for `to`.
1127      * - When `to` is zero, `tokenId` has been burned by `from`.
1128      * - `from` and `to` are never both zero.
1129      */
1130     function _afterTokenTransfers(
1131         address from,
1132         address to,
1133         uint256 startTokenId,
1134         uint256 quantity
1135     ) internal virtual {}
1136 
1137     /**
1138      * @dev Returns the message sender (defaults to `msg.sender`).
1139      *
1140      * If you are writing GSN compatible contracts, you need to override this function.
1141      */
1142     function _msgSenderERC721A() internal view virtual returns (address) {
1143         return msg.sender;
1144     }
1145 
1146     /**
1147      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1148      */
1149     function _toString(uint256 value) internal pure returns (string memory ptr) {
1150         assembly {
1151             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1152             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1153             // We will need 1 32-byte word to store the length, 
1154             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1155             ptr := add(mload(0x40), 128)
1156             // Update the free memory pointer to allocate.
1157             mstore(0x40, ptr)
1158 
1159             // Cache the end of the memory to calculate the length later.
1160             let end := ptr
1161 
1162             // We write the string from the rightmost digit to the leftmost digit.
1163             // The following is essentially a do-while loop that also handles the zero case.
1164             // Costs a bit more than early returning for the zero case,
1165             // but cheaper in terms of deployment and overall runtime costs.
1166             for { 
1167                 // Initialize and perform the first pass without check.
1168                 let temp := value
1169                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1170                 ptr := sub(ptr, 1)
1171                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1172                 mstore8(ptr, add(48, mod(temp, 10)))
1173                 temp := div(temp, 10)
1174             } temp { 
1175                 // Keep dividing `temp` until zero.
1176                 temp := div(temp, 10)
1177             } { // Body of the for loop.
1178                 ptr := sub(ptr, 1)
1179                 mstore8(ptr, add(48, mod(temp, 10)))
1180             }
1181             
1182             let length := sub(end, ptr)
1183             // Move the pointer 32 bytes leftwards to make room for the length.
1184             ptr := sub(ptr, 32)
1185             // Store the length.
1186             mstore(ptr, length)
1187         }
1188     }
1189 }
1190 
1191 // File: nft.sol
1192 
1193 
1194 // SPDX-License-Identifier: MIT
1195 pragma solidity ^0.8.13;
1196 
1197 
1198 
1199 contract DoraDreamon is Ownable, ERC721A {
1200     uint256 public maxSupply                    = 1111;
1201     uint256 public maxFreeSupply                = 333;
1202     
1203     uint256 public maxPerTxDuringMint           = 5;
1204     uint256 public maxPerAddressDuringMint      = 31;
1205     uint256 public maxPerAddressDuringFreeMint  = 1;
1206     
1207     uint256 public price                        = 0.005 ether;
1208     bool    public saleIsActive                 = false;
1209 
1210     address constant internal TEAM_ADDRESS = 0xdd67df4e68c9e0932fDE9AAab269f9CaB1CB407c;
1211 
1212     string private _baseTokenURI;
1213 
1214     mapping(address => uint256) public freeMintedAmount;
1215     mapping(address => uint256) public mintedAmount;
1216 
1217     constructor() ERC721A("DoraDreamon", "DORA") {
1218         _safeMint(msg.sender, 10);
1219     }
1220 
1221     modifier mintCompliance() {
1222         require(saleIsActive, "Sale is not active yet.");
1223         require(tx.origin == msg.sender, "Wrong Caller");
1224         _;
1225     }
1226 
1227     function mint(uint256 _quantity) external payable mintCompliance() {
1228         require(
1229             msg.value >= price * _quantity,
1230             "GDZ: Insufficient Fund."
1231         );
1232         require(
1233             maxSupply >= totalSupply() + _quantity,
1234             "GDZ: Exceeds max supply."
1235         );
1236         uint256 _mintedAmount = mintedAmount[msg.sender];
1237         require(
1238             _mintedAmount + _quantity <= maxPerAddressDuringMint,
1239             "GDZ: Exceeds max mints per address!"
1240         );
1241         require(
1242             _quantity > 0 && _quantity <= maxPerTxDuringMint,
1243             "Invalid mint amount."
1244         );
1245         mintedAmount[msg.sender] = _mintedAmount + _quantity;
1246         _safeMint(msg.sender, _quantity);
1247     }
1248 
1249     function freeMint(uint256 _quantity) external mintCompliance() {
1250         require(
1251             maxFreeSupply >= totalSupply() + _quantity,
1252             "GDZ: Exceeds max supply."
1253         );
1254         uint256 _freeMintedAmount = freeMintedAmount[msg.sender];
1255         require(
1256             _freeMintedAmount + _quantity <= maxPerAddressDuringFreeMint,
1257             "GDZ: Exceeds max free mints per address!"
1258         );
1259         freeMintedAmount[msg.sender] = _freeMintedAmount + _quantity;
1260         _safeMint(msg.sender, _quantity);
1261     }
1262 
1263     function setPrice(uint256 _price) external onlyOwner {
1264         price = _price;
1265     }
1266 
1267     function setMaxPerTx(uint256 _amount) external onlyOwner {
1268         maxPerTxDuringMint = _amount;
1269     }
1270 
1271     function setMaxPerAddress(uint256 _amount) external onlyOwner {
1272         maxPerAddressDuringMint = _amount;
1273     }
1274 
1275     function setMaxFreePerAddress(uint256 _amount) external onlyOwner {
1276         maxPerAddressDuringFreeMint = _amount;
1277     }
1278 
1279     function flipSale() public onlyOwner {
1280         saleIsActive = !saleIsActive;
1281     }
1282 
1283     function cutMaxSupply(uint256 _amount) public onlyOwner {
1284         require(
1285             maxSupply - _amount >= totalSupply(), 
1286             "Supply cannot fall below minted tokens."
1287         );
1288         maxSupply -= _amount;
1289     }
1290 
1291     function setBaseURI(string calldata baseURI) external onlyOwner {
1292         _baseTokenURI = baseURI;
1293     }
1294 
1295     function _baseURI() internal view virtual override returns (string memory) {
1296         return _baseTokenURI;
1297     }
1298 
1299     function withdrawBalance() external payable onlyOwner {
1300 
1301         (bool success, ) = payable(TEAM_ADDRESS).call{
1302             value: address(this).balance
1303         }("");
1304         require(success, "transfer failed.");
1305     }
1306 }