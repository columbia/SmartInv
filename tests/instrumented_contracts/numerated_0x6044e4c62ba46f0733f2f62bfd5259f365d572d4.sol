1 // SPDX-License-Identifier: MIT
2 
3 // File: contracts/Context.sol
4 
5 
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
29 // File: contracts/Ownable.sol
30 
31 
32 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
33 
34 pragma solidity ^0.8.0;
35 
36 
37 /**
38  * @dev Contract module which provides a basic access control mechanism, where
39  * there is an account (an owner) that can be granted exclusive access to
40  * specific functions.
41  *
42  * By default, the owner account will be the one that deploys the contract. This
43  * can later be changed with {transferOwnership}.
44  *
45  * This module is used through inheritance. It will make available the modifier
46  * `onlyOwner`, which can be applied to your functions to restrict their use to
47  * the owner.
48  */
49 abstract contract Ownable is Context {
50     address private _owner;
51 
52     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
53 
54     /**
55      * @dev Initializes the contract setting the deployer as the initial owner.
56      */
57     constructor() {
58         _transferOwnership(_msgSender());
59     }
60 
61     /**
62      * @dev Returns the address of the current owner.
63      */
64     function owner() public view virtual returns (address) {
65         return _owner;
66     }
67 
68     /**
69      * @dev Throws if called by any account other than the owner.
70      */
71     modifier onlyOwner() {
72         require(owner() == _msgSender(), "Ownable: caller is not the owner");
73         _;
74     }
75 
76     /**
77      * @dev Leaves the contract without owner. It will not be possible to call
78      * `onlyOwner` functions anymore. Can only be called by the current owner.
79      *
80      * NOTE: Renouncing ownership will leave the contract without an owner,
81      * thereby removing any functionality that is only available to the owner.
82      */
83     function renounceOwnership() public virtual onlyOwner {
84         _transferOwnership(address(0));
85     }
86 
87     /**
88      * @dev Transfers ownership of the contract to a new account (`newOwner`).
89      * Can only be called by the current owner.
90      */
91     function transferOwnership(address newOwner) public virtual onlyOwner {
92         require(newOwner != address(0), "Ownable: new owner is the zero address");
93         _transferOwnership(newOwner);
94     }
95 
96     /**
97      * @dev Transfers ownership of the contract to a new account (`newOwner`).
98      * Internal function without access restriction.
99      */
100     function _transferOwnership(address newOwner) internal virtual {
101         address oldOwner = _owner;
102         _owner = newOwner;
103         emit OwnershipTransferred(oldOwner, newOwner);
104     }
105 }
106 // File: contracts/IERC721A.sol
107 
108 
109 // ERC721A Contracts v4.0.0
110 // Creator: Chiru Labs
111 
112 pragma solidity ^0.8.4;
113 
114 /**
115  * @dev Interface of an ERC721A compliant contract.
116  */
117 interface IERC721A {
118     /**
119      * The caller must own the token or be an approved operator.
120      */
121     error ApprovalCallerNotOwnerNorApproved();
122 
123     /**
124      * The token does not exist.
125      */
126     error ApprovalQueryForNonexistentToken();
127 
128     /**
129      * The caller cannot approve to their own address.
130      */
131     error ApproveToCaller();
132 
133     /**
134      * Cannot query the balance for the zero address.
135      */
136     error BalanceQueryForZeroAddress();
137 
138     /**
139      * Cannot mint to the zero address.
140      */
141     error MintToZeroAddress();
142 
143     /**
144      * The quantity of tokens minted must be more than zero.
145      */
146     error MintZeroQuantity();
147 
148     /**
149      * The token does not exist.
150      */
151     error OwnerQueryForNonexistentToken();
152 
153     /**
154      * The caller must own the token or be an approved operator.
155      */
156     error TransferCallerNotOwnerNorApproved();
157 
158     /**
159      * The token must be owned by `from`.
160      */
161     error TransferFromIncorrectOwner();
162 
163     /**
164      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
165      */
166     error TransferToNonERC721ReceiverImplementer();
167 
168     /**
169      * Cannot transfer to the zero address.
170      */
171     error TransferToZeroAddress();
172 
173     /**
174      * The token does not exist.
175      */
176     error URIQueryForNonexistentToken();
177 
178     struct TokenOwnership {
179         // The address of the owner.
180         address addr;
181         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
182         uint64 startTimestamp;
183         // Whether the token has been burned.
184         bool burned;
185     }
186 
187     /**
188      * @dev Returns the total amount of tokens stored by the contract.
189      *
190      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
191      */
192     function totalSupply() external view returns (uint256);
193 
194     // ==============================
195     //            IERC165
196     // ==============================
197 
198     /**
199      * @dev Returns true if this contract implements the interface defined by
200      * `interfaceId`. See the corresponding
201      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
202      * to learn more about how these ids are created.
203      *
204      * This function call must use less than 30 000 gas.
205      */
206     function supportsInterface(bytes4 interfaceId) external view returns (bool);
207 
208     // ==============================
209     //            IERC721
210     // ==============================
211 
212     /**
213      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
214      */
215     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
216 
217     /**
218      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
219      */
220     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
221 
222     /**
223      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
224      */
225     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
226 
227     /**
228      * @dev Returns the number of tokens in ``owner``'s account.
229      */
230     function balanceOf(address owner) external view returns (uint256 balance);
231 
232     /**
233      * @dev Returns the owner of the `tokenId` token.
234      *
235      * Requirements:
236      *
237      * - `tokenId` must exist.
238      */
239     function ownerOf(uint256 tokenId) external view returns (address owner);
240 
241     /**
242      * @dev Safely transfers `tokenId` token from `from` to `to`.
243      *
244      * Requirements:
245      *
246      * - `from` cannot be the zero address.
247      * - `to` cannot be the zero address.
248      * - `tokenId` token must exist and be owned by `from`.
249      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
250      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
251      *
252      * Emits a {Transfer} event.
253      */
254     function safeTransferFrom(
255         address from,
256         address to,
257         uint256 tokenId,
258         bytes calldata data
259     ) external;
260 
261     /**
262      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
263      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
264      *
265      * Requirements:
266      *
267      * - `from` cannot be the zero address.
268      * - `to` cannot be the zero address.
269      * - `tokenId` token must exist and be owned by `from`.
270      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
271      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
272      *
273      * Emits a {Transfer} event.
274      */
275     function safeTransferFrom(
276         address from,
277         address to,
278         uint256 tokenId
279     ) external;
280 
281     /**
282      * @dev Transfers `tokenId` token from `from` to `to`.
283      *
284      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
285      *
286      * Requirements:
287      *
288      * - `from` cannot be the zero address.
289      * - `to` cannot be the zero address.
290      * - `tokenId` token must be owned by `from`.
291      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
292      *
293      * Emits a {Transfer} event.
294      */
295     function transferFrom(
296         address from,
297         address to,
298         uint256 tokenId
299     ) external;
300 
301     /**
302      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
303      * The approval is cleared when the token is transferred.
304      *
305      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
306      *
307      * Requirements:
308      *
309      * - The caller must own the token or be an approved operator.
310      * - `tokenId` must exist.
311      *
312      * Emits an {Approval} event.
313      */
314     function approve(address to, uint256 tokenId) external;
315 
316     /**
317      * @dev Approve or remove `operator` as an operator for the caller.
318      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
319      *
320      * Requirements:
321      *
322      * - The `operator` cannot be the caller.
323      *
324      * Emits an {ApprovalForAll} event.
325      */
326     function setApprovalForAll(address operator, bool _approved) external;
327 
328     /**
329      * @dev Returns the account approved for `tokenId` token.
330      *
331      * Requirements:
332      *
333      * - `tokenId` must exist.
334      */
335     function getApproved(uint256 tokenId) external view returns (address operator);
336 
337     /**
338      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
339      *
340      * See {setApprovalForAll}
341      */
342     function isApprovedForAll(address owner, address operator) external view returns (bool);
343 
344     // ==============================
345     //        IERC721Metadata
346     // ==============================
347 
348     /**
349      * @dev Returns the token collection name.
350      */
351     function name() external view returns (string memory);
352 
353     /**
354      * @dev Returns the token collection symbol.
355      */
356     function symbol() external view returns (string memory);
357 
358     /**
359      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
360      */
361     function tokenURI(uint256 tokenId) external view returns (string memory);
362 }
363 // File: contracts/ERC721A.sol
364 
365 
366 // ERC721A Contracts v4.0.0
367 // Creator: Chiru Labs
368 
369 pragma solidity ^0.8.4;
370 
371 
372 /**
373  * @dev ERC721 token receiver interface.
374  */
375 interface ERC721A__IERC721Receiver {
376     function onERC721Received(
377         address operator,
378         address from,
379         uint256 tokenId,
380         bytes calldata data
381     ) external returns (bytes4);
382 }
383 
384 /**
385  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
386  * the Metadata extension. Built to optimize for lower gas during batch mints.
387  *
388  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
389  *
390  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
391  *
392  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
393  */
394 contract ERC721A is IERC721A {
395     // Mask of an entry in packed address data.
396     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
397 
398     // The bit position of `numberMinted` in packed address data.
399     uint256 private constant BITPOS_NUMBER_MINTED = 64;
400 
401     // The bit position of `numberBurned` in packed address data.
402     uint256 private constant BITPOS_NUMBER_BURNED = 128;
403 
404     // The bit position of `aux` in packed address data.
405     uint256 private constant BITPOS_AUX = 192;
406 
407     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
408     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
409 
410     // The bit position of `startTimestamp` in packed ownership.
411     uint256 private constant BITPOS_START_TIMESTAMP = 160;
412 
413     // The bit mask of the `burned` bit in packed ownership.
414     uint256 private constant BITMASK_BURNED = 1 << 224;
415 
416     // The bit position of the `nextInitialized` bit in packed ownership.
417     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
418 
419     // The bit mask of the `nextInitialized` bit in packed ownership.
420     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
421 
422     // The tokenId of the next token to be minted.
423     uint256 private _currentIndex;
424 
425     // The number of tokens burned.
426     uint256 private _burnCounter;
427 
428     // Token name
429     string private _name;
430 
431     // Token symbol
432     string private _symbol;
433 
434     // Mapping from token ID to ownership details
435     // An empty struct value does not necessarily mean the token is unowned.
436     // See `_packedOwnershipOf` implementation for details.
437     //
438     // Bits Layout:
439     // - [0..159]   `addr`
440     // - [160..223] `startTimestamp`
441     // - [224]      `burned`
442     // - [225]      `nextInitialized`
443     mapping(uint256 => uint256) private _packedOwnerships;
444 
445     // Mapping owner address to address data.
446     //
447     // Bits Layout:
448     // - [0..63]    `balance`
449     // - [64..127]  `numberMinted`
450     // - [128..191] `numberBurned`
451     // - [192..255] `aux`
452     mapping(address => uint256) private _packedAddressData;
453 
454     // Mapping from token ID to approved address.
455     mapping(uint256 => address) private _tokenApprovals;
456 
457     // Mapping from owner to operator approvals
458     mapping(address => mapping(address => bool)) private _operatorApprovals;
459 
460     constructor(string memory name_, string memory symbol_) {
461         _name = name_;
462         _symbol = symbol_;
463         _currentIndex = _startTokenId();
464     }
465 
466     /**
467      * @dev Returns the starting token ID.
468      * To change the starting token ID, please override this function.
469      */
470     function _startTokenId() internal view virtual returns (uint256) {
471         return 0;
472     }
473 
474     /**
475      * @dev Returns the next token ID to be minted.
476      */
477     function _nextTokenId() internal view returns (uint256) {
478         return _currentIndex;
479     }
480 
481     /**
482      * @dev Returns the total number of tokens in existence.
483      * Burned tokens will reduce the count.
484      * To get the total number of tokens minted, please see `_totalMinted`.
485      */
486     function totalSupply() public view override returns (uint256) {
487         // Counter underflow is impossible as _burnCounter cannot be incremented
488         // more than `_currentIndex - _startTokenId()` times.
489         unchecked {
490             return _currentIndex - _burnCounter - _startTokenId();
491         }
492     }
493 
494     /**
495      * @dev Returns the total amount of tokens minted in the contract.
496      */
497     function _totalMinted() internal view returns (uint256) {
498         // Counter underflow is impossible as _currentIndex does not decrement,
499         // and it is initialized to `_startTokenId()`
500         unchecked {
501             return _currentIndex - _startTokenId();
502         }
503     }
504 
505     /**
506      * @dev Returns the total number of tokens burned.
507      */
508     function _totalBurned() internal view returns (uint256) {
509         return _burnCounter;
510     }
511 
512     /**
513      * @dev See {IERC165-supportsInterface}.
514      */
515     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
516         // The interface IDs are constants representing the first 4 bytes of the XOR of
517         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
518         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
519         return
520             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
521             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
522             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
523     }
524 
525     /**
526      * @dev See {IERC721-balanceOf}.
527      */
528     function balanceOf(address owner) public view override returns (uint256) {
529         if (_addressToUint256(owner) == 0) revert BalanceQueryForZeroAddress();
530         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
531     }
532 
533     /**
534      * Returns the number of tokens minted by `owner`.
535      */
536     function _numberMinted(address owner) internal view returns (uint256) {
537         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
538     }
539 
540     /**
541      * Returns the number of tokens burned by or on behalf of `owner`.
542      */
543     function _numberBurned(address owner) internal view returns (uint256) {
544         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
545     }
546 
547     /**
548      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
549      */
550     function _getAux(address owner) internal view returns (uint64) {
551         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
552     }
553 
554     /**
555      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
556      * If there are multiple variables, please pack them into a uint64.
557      */
558     function _setAux(address owner, uint64 aux) internal {
559         uint256 packed = _packedAddressData[owner];
560         uint256 auxCasted;
561         assembly {
562             // Cast aux without masking.
563             auxCasted := aux
564         }
565         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
566         _packedAddressData[owner] = packed;
567     }
568 
569     /**
570      * Returns the packed ownership data of `tokenId`.
571      */
572     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
573         uint256 curr = tokenId;
574 
575         unchecked {
576             if (_startTokenId() <= curr)
577                 if (curr < _currentIndex) {
578                     uint256 packed = _packedOwnerships[curr];
579                     // If not burned.
580                     if (packed & BITMASK_BURNED == 0) {
581                         // Invariant:
582                         // There will always be an ownership that has an address and is not burned
583                         // before an ownership that does not have an address and is not burned.
584                         // Hence, curr will not underflow.
585                         //
586                         // We can directly compare the packed value.
587                         // If the address is zero, packed is zero.
588                         while (packed == 0) {
589                             packed = _packedOwnerships[--curr];
590                         }
591                         return packed;
592                     }
593                 }
594         }
595         revert OwnerQueryForNonexistentToken();
596     }
597 
598     /**
599      * Returns the unpacked `TokenOwnership` struct from `packed`.
600      */
601     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
602         ownership.addr = address(uint160(packed));
603         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
604         ownership.burned = packed & BITMASK_BURNED != 0;
605     }
606 
607     /**
608      * Returns the unpacked `TokenOwnership` struct at `index`.
609      */
610     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
611         return _unpackedOwnership(_packedOwnerships[index]);
612     }
613 
614     /**
615      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
616      */
617     function _initializeOwnershipAt(uint256 index) internal {
618         if (_packedOwnerships[index] == 0) {
619             _packedOwnerships[index] = _packedOwnershipOf(index);
620         }
621     }
622 
623     /**
624      * Gas spent here starts off proportional to the maximum mint batch size.
625      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
626      */
627     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
628         return _unpackedOwnership(_packedOwnershipOf(tokenId));
629     }
630 
631     /**
632      * @dev Packs ownership data into a single uint256.
633      */
634     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 value) {
635         assembly {
636             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
637             value := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
638         }
639     }
640 
641     /**
642      * @dev See {IERC721-ownerOf}.
643      */
644     function ownerOf(uint256 tokenId) public view override returns (address) {
645         return address(uint160(_packedOwnershipOf(tokenId)));
646     }
647 
648     /**
649      * @dev See {IERC721Metadata-name}.
650      */
651     function name() public view virtual override returns (string memory) {
652         return _name;
653     }
654 
655     /**
656      * @dev See {IERC721Metadata-symbol}.
657      */
658     function symbol() public view virtual override returns (string memory) {
659         return _symbol;
660     }
661 
662     /**
663      * @dev See {IERC721Metadata-tokenURI}.
664      */
665     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
666         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
667 
668         string memory baseURI = _baseURI();
669         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
670     }
671 
672     /**
673      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
674      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
675      * by default, it can be overridden in child contracts.
676      */
677     function _baseURI() internal view virtual returns (string memory) {
678         return '';
679     }
680 
681     /**
682      * @dev Casts the address to uint256 without masking.
683      */
684     function _addressToUint256(address value) private pure returns (uint256 result) {
685         assembly {
686             result := value
687         }
688     }
689 
690     /**
691      * @dev Casts the boolean to uint256 without branching.
692      */
693     function _boolToUint256(bool value) private pure returns (uint256 result) {
694         assembly {
695             result := value
696         }
697     }
698 
699     /**
700      * @dev See {IERC721-approve}.
701      */
702     function approve(address to, uint256 tokenId) public override {
703         address owner = ownerOf(tokenId);
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
808      * Emits a {Transfer} event for each mint.
809      */
810     function _safeMint(
811         address to,
812         uint256 quantity,
813         bytes memory _data
814     ) internal {
815         _mint(to, quantity);
816 
817         unchecked {
818             if (to.code.length != 0) {
819                 uint256 end = _currentIndex;
820                 uint256 index = end - quantity;
821                 do {
822                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
823                         revert TransferToNonERC721ReceiverImplementer();
824                     }
825                 } while (index < end);
826                 // Reentrancy protection.
827                 if (_currentIndex != end) revert();
828             }
829         }
830     }
831 
832     /**
833      * @dev Mints `quantity` tokens and transfers them to `to`.
834      *
835      * Requirements:
836      *
837      * - `to` cannot be the zero address.
838      * - `quantity` must be greater than 0.
839      *
840      * Emits a {Transfer} event for each mint.
841      */
842     function _mint(address to, uint256 quantity) internal {
843         uint256 startTokenId = _currentIndex;
844         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
845         if (quantity == 0) revert MintZeroQuantity();
846 
847         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
848 
849         // Overflows are incredibly unrealistic.
850         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
851         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
852         unchecked {
853             // Updates:
854             // - `balance += quantity`.
855             // - `numberMinted += quantity`.
856             //
857             // We can directly add to the balance and number minted.
858             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
859 
860             // Updates:
861             // - `address` to the owner.
862             // - `startTimestamp` to the timestamp of minting.
863             // - `burned` to `false`.
864             // - `nextInitialized` to `quantity == 1`.
865             _packedOwnerships[startTokenId] = _packOwnershipData(
866                 to,
867                 _boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED
868             );
869 
870             uint256 offset = startTokenId;
871             uint256 end = quantity + startTokenId;
872             do {
873                 emit Transfer(address(0), to, offset++);
874             } while (offset < end);
875 
876             _currentIndex = startTokenId + quantity;
877         }
878         _afterTokenTransfers(address(0), to, startTokenId, quantity);
879     }
880 
881     /**
882      * @dev Transfers `tokenId` from `from` to `to`.
883      *
884      * Requirements:
885      *
886      * - `to` cannot be the zero address.
887      * - `tokenId` token must be owned by `from`.
888      *
889      * Emits a {Transfer} event.
890      */
891     function _transfer(
892         address from,
893         address to,
894         uint256 tokenId
895     ) private {
896         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
897 
898         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
899 
900         address approvedAddress = _tokenApprovals[tokenId];
901 
902         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
903             isApprovedForAll(from, _msgSenderERC721A()) ||
904             approvedAddress == _msgSenderERC721A());
905 
906         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
907         if (_addressToUint256(to) == 0) revert TransferToZeroAddress();
908 
909         _beforeTokenTransfers(from, to, tokenId, 1);
910 
911         // Clear approvals from the previous owner.
912         if (_addressToUint256(approvedAddress) != 0) {
913             delete _tokenApprovals[tokenId];
914         }
915 
916         // Underflow of the sender's balance is impossible because we check for
917         // ownership above and the recipient's balance can't realistically overflow.
918         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
919         unchecked {
920             // We can directly increment and decrement the balances.
921             --_packedAddressData[from]; // Updates: `balance -= 1`.
922             ++_packedAddressData[to]; // Updates: `balance += 1`.
923 
924             // Updates:
925             // - `address` to the next owner.
926             // - `startTimestamp` to the timestamp of transfering.
927             // - `burned` to `false`.
928             // - `nextInitialized` to `true`.
929             _packedOwnerships[tokenId] = _packOwnershipData(to, BITMASK_NEXT_INITIALIZED);
930 
931             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
932             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
933                 uint256 nextTokenId = tokenId + 1;
934                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
935                 if (_packedOwnerships[nextTokenId] == 0) {
936                     // If the next slot is within bounds.
937                     if (nextTokenId != _currentIndex) {
938                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
939                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
940                     }
941                 }
942             }
943         }
944 
945         emit Transfer(from, to, tokenId);
946         _afterTokenTransfers(from, to, tokenId, 1);
947     }
948 
949     /**
950      * @dev Equivalent to `_burn(tokenId, false)`.
951      */
952     function _burn(uint256 tokenId) internal virtual {
953         _burn(tokenId, false);
954     }
955 
956     /**
957      * @dev Destroys `tokenId`.
958      * The approval is cleared when the token is burned.
959      *
960      * Requirements:
961      *
962      * - `tokenId` must exist.
963      *
964      * Emits a {Transfer} event.
965      */
966     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
967         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
968 
969         address from = address(uint160(prevOwnershipPacked));
970         address approvedAddress = _tokenApprovals[tokenId];
971 
972         if (approvalCheck) {
973             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
974                 isApprovedForAll(from, _msgSenderERC721A()) ||
975                 approvedAddress == _msgSenderERC721A());
976 
977             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
978         }
979 
980         _beforeTokenTransfers(from, address(0), tokenId, 1);
981 
982         // Clear approvals from the previous owner.
983         if (_addressToUint256(approvedAddress) != 0) {
984             delete _tokenApprovals[tokenId];
985         }
986 
987         // Underflow of the sender's balance is impossible because we check for
988         // ownership above and the recipient's balance can't realistically overflow.
989         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
990         unchecked {
991             // Updates:
992             // - `balance -= 1`.
993             // - `numberBurned += 1`.
994             //
995             // We can directly decrement the balance, and increment the number burned.
996             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
997             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
998 
999             // Updates:
1000             // - `address` to the last owner.
1001             // - `startTimestamp` to the timestamp of burning.
1002             // - `burned` to `true`.
1003             // - `nextInitialized` to `true`.
1004             _packedOwnerships[tokenId] = _packOwnershipData(from, BITMASK_BURNED | BITMASK_NEXT_INITIALIZED);
1005 
1006             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1007             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1008                 uint256 nextTokenId = tokenId + 1;
1009                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1010                 if (_packedOwnerships[nextTokenId] == 0) {
1011                     // If the next slot is within bounds.
1012                     if (nextTokenId != _currentIndex) {
1013                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1014                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1015                     }
1016                 }
1017             }
1018         }
1019 
1020         emit Transfer(from, address(0), tokenId);
1021         _afterTokenTransfers(from, address(0), tokenId, 1);
1022 
1023         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1024         unchecked {
1025             _burnCounter++;
1026         }
1027     }
1028 
1029     /**
1030      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1031      *
1032      * @param from address representing the previous owner of the given token ID
1033      * @param to target address that will receive the tokens
1034      * @param tokenId uint256 ID of the token to be transferred
1035      * @param _data bytes optional data to send along with the call
1036      * @return bool whether the call correctly returned the expected magic value
1037      */
1038     function _checkContractOnERC721Received(
1039         address from,
1040         address to,
1041         uint256 tokenId,
1042         bytes memory _data
1043     ) private returns (bool) {
1044         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1045             bytes4 retval
1046         ) {
1047             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1048         } catch (bytes memory reason) {
1049             if (reason.length == 0) {
1050                 revert TransferToNonERC721ReceiverImplementer();
1051             } else {
1052                 assembly {
1053                     revert(add(32, reason), mload(reason))
1054                 }
1055             }
1056         }
1057     }
1058 
1059     /**
1060      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1061      * And also called before burning one token.
1062      *
1063      * startTokenId - the first token id to be transferred
1064      * quantity - the amount to be transferred
1065      *
1066      * Calling conditions:
1067      *
1068      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1069      * transferred to `to`.
1070      * - When `from` is zero, `tokenId` will be minted for `to`.
1071      * - When `to` is zero, `tokenId` will be burned by `from`.
1072      * - `from` and `to` are never both zero.
1073      */
1074     function _beforeTokenTransfers(
1075         address from,
1076         address to,
1077         uint256 startTokenId,
1078         uint256 quantity
1079     ) internal virtual {}
1080 
1081     /**
1082      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1083      * minting.
1084      * And also called after one token has been burned.
1085      *
1086      * startTokenId - the first token id to be transferred
1087      * quantity - the amount to be transferred
1088      *
1089      * Calling conditions:
1090      *
1091      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1092      * transferred to `to`.
1093      * - When `from` is zero, `tokenId` has been minted for `to`.
1094      * - When `to` is zero, `tokenId` has been burned by `from`.
1095      * - `from` and `to` are never both zero.
1096      */
1097     function _afterTokenTransfers(
1098         address from,
1099         address to,
1100         uint256 startTokenId,
1101         uint256 quantity
1102     ) internal virtual {}
1103 
1104     /**
1105      * @dev Returns the message sender (defaults to `msg.sender`).
1106      *
1107      * If you are writing GSN compatible contracts, you need to override this function.
1108      */
1109     function _msgSenderERC721A() internal view virtual returns (address) {
1110         return msg.sender;
1111     }
1112 
1113     /**
1114      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1115      */
1116     function _toString(uint256 value) internal pure returns (string memory ptr) {
1117         assembly {
1118             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1119             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1120             // We will need 1 32-byte word to store the length,
1121             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1122             ptr := add(mload(0x40), 128)
1123             // Update the free memory pointer to allocate.
1124             mstore(0x40, ptr)
1125 
1126             // Cache the end of the memory to calculate the length later.
1127             let end := ptr
1128 
1129             // We write the string from the rightmost digit to the leftmost digit.
1130             // The following is essentially a do-while loop that also handles the zero case.
1131             // Costs a bit more than early returning for the zero case,
1132             // but cheaper in terms of deployment and overall runtime costs.
1133             for {
1134                 // Initialize and perform the first pass without check.
1135                 let temp := value
1136                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1137                 ptr := sub(ptr, 1)
1138                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1139                 mstore8(ptr, add(48, mod(temp, 10)))
1140                 temp := div(temp, 10)
1141             } temp {
1142                 // Keep dividing `temp` until zero.
1143                 temp := div(temp, 10)
1144             } {
1145                 // Body of the for loop.
1146                 ptr := sub(ptr, 1)
1147                 mstore8(ptr, add(48, mod(temp, 10)))
1148             }
1149 
1150             let length := sub(end, ptr)
1151             // Move the pointer 32 bytes leftwards to make room for the length.
1152             ptr := sub(ptr, 32)
1153             // Store the length.
1154             mstore(ptr, length)
1155         }
1156     }
1157 }
1158 // File: contracts/Poonicorns.sol
1159 
1160 
1161 pragma solidity ^0.8.14;
1162 
1163 
1164 
1165 contract Poonicorns is ERC721A, Ownable { 
1166     uint public constant maxPublicSupply = 1000;
1167 
1168     bool private mintOpen = false;
1169     bool private daoClaimed = false;
1170 
1171     string internal baseTokenURI = "ipfs://QmazszK41a41Edp4wKN7teGGRppZnfR1vzNFv3y8z748QQ/";
1172     
1173     constructor() ERC721A("Poonicorn DAO", "POOU") {}
1174 
1175     function toggleMint() external onlyOwner {
1176         mintOpen = !mintOpen;
1177     }
1178     
1179     function setBaseTokenURI(string calldata _uri) external onlyOwner {
1180         baseTokenURI = _uri;
1181     }
1182 
1183     function _baseURI() internal override view returns (string memory) {
1184         return baseTokenURI;
1185     }
1186 
1187     //All 100% free (1000 supply available for public, 1 per wallet) 100% secondary to community DAO control
1188     function mint() external {
1189         require(mintOpen, "NotOpen");
1190         require(_totalMinted() < maxPublicSupply, "MaxSupply");
1191         require(_numberMinted(msg.sender) < 1, "AlreadyMinted");
1192         _mint(msg.sender, 1);
1193     }
1194 
1195     //Used for DAO community wallet
1196     function mintForDao() external onlyOwner {
1197         require(!daoClaimed, "AlreadyClaimed");
1198         daoClaimed = true;
1199         _mint(msg.sender, 111);
1200     }
1201 
1202     function _startTokenId() internal override view virtual returns (uint256) {
1203         return 1;
1204     }
1205 }