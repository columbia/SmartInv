1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.4;
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
259 pragma solidity ^0.8.4;
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
327 pragma solidity ^0.8.4;
328 
329 /**
330  * @dev Interface of an ERC721ABurnable compliant contract.
331  */
332 interface IERC721ABurnable is IERC721A {
333     /**
334      * @dev Burns `tokenId`. See {ERC721A-_burn}.
335      *
336      * Requirements:
337      *
338      * - The caller must own `tokenId` or be an approved operator.
339      */
340     function burn(uint256 tokenId) external;
341 }
342 
343 pragma solidity ^0.8.4;
344 
345 /**
346  * @dev Provides information about the current execution context, including the
347  * sender of the transaction and its data. While these are generally available
348  * via msg.sender and msg.data, they should not be accessed in such a direct
349  * manner, since when dealing with meta-transactions the account sending and
350  * paying for execution may not be the actual sender (as far as an application
351  * is concerned).
352  *
353  * This contract is only required for intermediate, library-like contracts.
354  */
355 abstract contract Context {
356     function _msgSender() internal view virtual returns (address) {
357         return msg.sender;
358     }
359 
360     function _msgData() internal view virtual returns (bytes calldata) {
361         return msg.data;
362     }
363 }
364 
365 pragma solidity ^0.8.4;
366 
367 /**
368  * @dev Contract module which provides a basic access control mechanism, where
369  * there is an account (an owner) that can be granted exclusive access to
370  * specific functions.
371  *
372  * By default, the owner account will be the one that deploys the contract. This
373  * can later be changed with {transferOwnership}.
374  *
375  * This module is used through inheritance. It will make available the modifier
376  * `onlyOwner`, which can be applied to your functions to restrict their use to
377  * the owner.
378  */
379 abstract contract Ownable is Context {
380     address private _owner;
381 
382     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
383 
384     /**
385      * @dev Initializes the contract setting the deployer as the initial owner.
386      */
387     constructor() {
388         _transferOwnership(_msgSender());
389     }
390 
391     /**
392      * @dev Returns the address of the current owner.
393      */
394     function owner() public view virtual returns (address) {
395         return _owner;
396     }
397 
398     /**
399      * @dev Throws if called by any account other than the owner.
400      */
401     modifier onlyOwner() {
402         require(owner() == _msgSender(), "Ownable: caller is not the owner");
403         _;
404     }
405 
406     /**
407      * @dev Leaves the contract without owner. It will not be possible to call
408      * `onlyOwner` functions anymore. Can only be called by the current owner.
409      *
410      * NOTE: Renouncing ownership will leave the contract without an owner,
411      * thereby removing any functionality that is only available to the owner.
412      */
413     function renounceOwnership() public virtual onlyOwner {
414         _transferOwnership(address(0));
415     }
416 
417     /**
418      * @dev Transfers ownership of the contract to a new account (`newOwner`).
419      * Can only be called by the current owner.
420      */
421     function transferOwnership(address newOwner) public virtual onlyOwner {
422         require(newOwner != address(0), "Ownable: new owner is the zero address");
423         _transferOwnership(newOwner);
424     }
425 
426     /**
427      * @dev Transfers ownership of the contract to a new account (`newOwner`).
428      * Internal function without access restriction.
429      */
430     function _transferOwnership(address newOwner) internal virtual {
431         address oldOwner = _owner;
432         _owner = newOwner;
433         emit OwnershipTransferred(oldOwner, newOwner);
434     }
435 }
436 
437 pragma solidity ^0.8.4;
438 
439 /**
440  * @dev ERC721 token receiver interface.
441  */
442 interface ERC721A__IERC721Receiver {
443     function onERC721Received(
444         address operator,
445         address from,
446         uint256 tokenId,
447         bytes calldata data
448     ) external returns (bytes4);
449 }
450 
451 pragma solidity ^0.8.4;
452 
453 /**
454  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
455  * the Metadata extension. Built to optimize for lower gas during batch mints.
456  *
457  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
458  *
459  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
460  *
461  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
462  */
463 contract ERC721A is IERC721A {
464     // Mask of an entry in packed address data.
465     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
466 
467     // The bit position of `numberMinted` in packed address data.
468     uint256 private constant BITPOS_NUMBER_MINTED = 64;
469 
470     // The bit position of `numberBurned` in packed address data.
471     uint256 private constant BITPOS_NUMBER_BURNED = 128;
472 
473     // The bit position of `aux` in packed address data.
474     uint256 private constant BITPOS_AUX = 192;
475 
476     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
477     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
478 
479     // The bit position of `startTimestamp` in packed ownership.
480     uint256 private constant BITPOS_START_TIMESTAMP = 160;
481 
482     // The bit mask of the `burned` bit in packed ownership.
483     uint256 private constant BITMASK_BURNED = 1 << 224;
484 
485     // The bit position of the `nextInitialized` bit in packed ownership.
486     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
487 
488     // The bit mask of the `nextInitialized` bit in packed ownership.
489     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
490 
491     // The tokenId of the next token to be minted.
492     uint256 private _currentIndex;
493 
494     // The number of tokens burned.
495     uint256 private _burnCounter;
496 
497     // Token name
498     string private _name;
499 
500     // Token symbol
501     string private _symbol;
502 
503     // Mapping from token ID to ownership details
504     // An empty struct value does not necessarily mean the token is unowned.
505     // See `_packedOwnershipOf` implementation for details.
506     //
507     // Bits Layout:
508     // - [0..159]   `addr`
509     // - [160..223] `startTimestamp`
510     // - [224]      `burned`
511     // - [225]      `nextInitialized`
512     mapping(uint256 => uint256) private _packedOwnerships;
513 
514     // Mapping owner address to address data.
515     //
516     // Bits Layout:
517     // - [0..63]    `balance`
518     // - [64..127]  `numberMinted`
519     // - [128..191] `numberBurned`
520     // - [192..255] `aux`
521     mapping(address => uint256) private _packedAddressData;
522 
523     // Mapping from token ID to approved address.
524     mapping(uint256 => address) private _tokenApprovals;
525 
526     // Mapping from owner to operator approvals
527     mapping(address => mapping(address => bool)) private _operatorApprovals;
528 
529     constructor(string memory name_, string memory symbol_) {
530         _name = name_;
531         _symbol = symbol_;
532         _currentIndex = _startTokenId();
533     }
534 
535     /**
536      * @dev Returns the starting token ID.
537      * To change the starting token ID, please override this function.
538      */
539     function _startTokenId() internal view virtual returns (uint256) {
540         return 0;
541     }
542 
543     /**
544      * @dev Returns the next token ID to be minted.
545      */
546     function _nextTokenId() internal view returns (uint256) {
547         return _currentIndex;
548     }
549 
550     /**
551      * @dev Returns the total number of tokens in existence.
552      * Burned tokens will reduce the count.
553      * To get the total number of tokens minted, please see `_totalMinted`.
554      */
555     function totalSupply() public view override returns (uint256) {
556         // Counter underflow is impossible as _burnCounter cannot be incremented
557         // more than `_currentIndex - _startTokenId()` times.
558     unchecked {
559         return _currentIndex - _burnCounter - _startTokenId();
560     }
561     }
562 
563     /**
564      * @dev Returns the total amount of tokens minted in the contract.
565      */
566     function _totalMinted() internal view returns (uint256) {
567         // Counter underflow is impossible as _currentIndex does not decrement,
568         // and it is initialized to `_startTokenId()`
569     unchecked {
570         return _currentIndex - _startTokenId();
571     }
572     }
573 
574     /**
575      * @dev Returns the total number of tokens burned.
576      */
577     function _totalBurned() internal view returns (uint256) {
578         return _burnCounter;
579     }
580 
581     /**
582      * @dev See {IERC165-supportsInterface}.
583      */
584     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
585         // The interface IDs are constants representing the first 4 bytes of the XOR of
586         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
587         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
588         return
589         interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
590         interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
591         interfaceId == 0x5b5e139f;
592         // ERC165 interface ID for ERC721Metadata.
593     }
594 
595     /**
596      * @dev See {IERC721-balanceOf}.
597      */
598     function balanceOf(address owner) public view override returns (uint256) {
599         if (owner == address(0)) revert BalanceQueryForZeroAddress();
600         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
601     }
602 
603     /**
604      * Returns the number of tokens minted by `owner`.
605      */
606     function _numberMinted(address owner) internal view returns (uint256) {
607         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
608     }
609 
610     /**
611      * Returns the number of tokens burned by or on behalf of `owner`.
612      */
613     function _numberBurned(address owner) internal view returns (uint256) {
614         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
615     }
616 
617     /**
618      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
619      */
620     function _getAux(address owner) internal view returns (uint64) {
621         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
622     }
623 
624     /**
625      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
626      * If there are multiple variables, please pack them into a uint64.
627      */
628     function _setAux(address owner, uint64 aux) internal {
629         uint256 packed = _packedAddressData[owner];
630         uint256 auxCasted;
631         assembly {// Cast aux without masking.
632             auxCasted := aux
633         }
634         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
635         _packedAddressData[owner] = packed;
636     }
637 
638     /**
639      * Returns the packed ownership data of `tokenId`.
640      */
641     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
642         uint256 curr = tokenId;
643 
644     unchecked {
645         if (_startTokenId() <= curr)
646             if (curr < _currentIndex) {
647                 uint256 packed = _packedOwnerships[curr];
648                 // If not burned.
649                 if (packed & BITMASK_BURNED == 0) {
650                     // Invariant:
651                     // There will always be an ownership that has an address and is not burned
652                     // before an ownership that does not have an address and is not burned.
653                     // Hence, curr will not underflow.
654                     //
655                     // We can directly compare the packed value.
656                     // If the address is zero, packed is zero.
657                     while (packed == 0) {
658                         packed = _packedOwnerships[--curr];
659                     }
660                     return packed;
661                 }
662             }
663     }
664         revert OwnerQueryForNonexistentToken();
665     }
666 
667     /**
668      * Returns the unpacked `TokenOwnership` struct from `packed`.
669      */
670     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
671         ownership.addr = address(uint160(packed));
672         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
673         ownership.burned = packed & BITMASK_BURNED != 0;
674         return ownership;
675     }
676 
677     /**
678      * Returns the unpacked `TokenOwnership` struct at `index`.
679      */
680     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
681         return _unpackedOwnership(_packedOwnerships[index]);
682     }
683 
684     /**
685      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
686      */
687     function _initializeOwnershipAt(uint256 index) internal {
688         if (_packedOwnerships[index] == 0) {
689             _packedOwnerships[index] = _packedOwnershipOf(index);
690         }
691     }
692 
693     /**
694      * Gas spent here starts off proportional to the maximum mint batch size.
695      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
696      */
697     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
698         return _unpackedOwnership(_packedOwnershipOf(tokenId));
699     }
700 
701     /**
702      * @dev See {IERC721-ownerOf}.
703      */
704     function ownerOf(uint256 tokenId) public view override returns (address) {
705         return address(uint160(_packedOwnershipOf(tokenId)));
706     }
707 
708     /**
709      * @dev See {IERC721Metadata-name}.
710      */
711     function name() public view virtual override returns (string memory) {
712         return _name;
713     }
714 
715     /**
716      * @dev See {IERC721Metadata-symbol}.
717      */
718     function symbol() public view virtual override returns (string memory) {
719         return _symbol;
720     }
721 
722     /**
723      * @dev See {IERC721Metadata-tokenURI}.
724      */
725     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
726         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
727 
728         string memory baseURI = _baseURI();
729         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
730     }
731 
732     /**
733      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
734      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
735      * by default, can be overriden in child contracts.
736      */
737     function _baseURI() internal view virtual returns (string memory) {
738         return '';
739     }
740 
741     /**
742      * @dev Casts the address to uint256 without masking.
743      */
744     function _addressToUint256(address value) private pure returns (uint256 result) {
745         assembly {
746             result := value
747         }
748     }
749 
750     /**
751      * @dev Casts the boolean to uint256 without branching.
752      */
753     function _boolToUint256(bool value) private pure returns (uint256 result) {
754         assembly {
755             result := value
756         }
757     }
758 
759     /**
760      * @dev See {IERC721-approve}.
761      */
762     function approve(address to, uint256 tokenId) public override {
763         address owner = address(uint160(_packedOwnershipOf(tokenId)));
764         if (to == owner) revert ApprovalToCurrentOwner();
765 
766         if (_msgSenderERC721A() != owner)
767             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
768                 revert ApprovalCallerNotOwnerNorApproved();
769             }
770 
771         _tokenApprovals[tokenId] = to;
772         emit Approval(owner, to, tokenId);
773     }
774 
775     /**
776      * @dev See {IERC721-getApproved}.
777      */
778     function getApproved(uint256 tokenId) public view override returns (address) {
779         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
780 
781         return _tokenApprovals[tokenId];
782     }
783 
784     /**
785      * @dev See {IERC721-setApprovalForAll}.
786      */
787     function setApprovalForAll(address operator, bool approved) public virtual override {
788         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
789 
790         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
791         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
792     }
793 
794     /**
795      * @dev See {IERC721-isApprovedForAll}.
796      */
797     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
798         return _operatorApprovals[owner][operator];
799     }
800 
801     /**
802      * @dev See {IERC721-transferFrom}.
803      */
804     function transferFrom(
805         address from,
806         address to,
807         uint256 tokenId
808     ) public virtual override {
809         _transfer(from, to, tokenId);
810     }
811 
812     /**
813      * @dev See {IERC721-safeTransferFrom}.
814      */
815     function safeTransferFrom(
816         address from,
817         address to,
818         uint256 tokenId
819     ) public virtual override {
820         safeTransferFrom(from, to, tokenId, '');
821     }
822 
823     /**
824      * @dev See {IERC721-safeTransferFrom}.
825      */
826     function safeTransferFrom(
827         address from,
828         address to,
829         uint256 tokenId,
830         bytes memory _data
831     ) public virtual override {
832         _transfer(from, to, tokenId);
833         if (to.code.length != 0)
834             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
835                 revert TransferToNonERC721ReceiverImplementer();
836             }
837     }
838 
839     /**
840      * @dev Returns whether `tokenId` exists.
841      *
842      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
843      *
844      * Tokens start existing when they are minted (`_mint`),
845      */
846     function _exists(uint256 tokenId) internal view returns (bool) {
847         return
848         _startTokenId() <= tokenId &&
849         tokenId < _currentIndex && // If within bounds,
850         _packedOwnerships[tokenId] & BITMASK_BURNED == 0;
851         // and not burned.
852     }
853 
854     /**
855      * @dev Equivalent to `_safeMint(to, quantity, '')`.
856      */
857     function _safeMint(address to, uint256 quantity) internal {
858         _safeMint(to, quantity, '');
859     }
860 
861     /**
862      * @dev Safely mints `quantity` tokens and transfers them to `to`.
863      *
864      * Requirements:
865      *
866      * - If `to` refers to a smart contract, it must implement
867      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
868      * - `quantity` must be greater than 0.
869      *
870      * Emits a {Transfer} event.
871      */
872     function _safeMint(
873         address to,
874         uint256 quantity,
875         bytes memory _data
876     ) internal {
877         uint256 startTokenId = _currentIndex;
878         if (to == address(0)) revert MintToZeroAddress();
879         if (quantity == 0) revert MintZeroQuantity();
880 
881         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
882 
883         // Overflows are incredibly unrealistic.
884         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
885         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
886     unchecked {
887         // Updates:
888         // - `balance += quantity`.
889         // - `numberMinted += quantity`.
890         //
891         // We can directly add to the balance and number minted.
892         _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
893 
894         // Updates:
895         // - `address` to the owner.
896         // - `startTimestamp` to the timestamp of minting.
897         // - `burned` to `false`.
898         // - `nextInitialized` to `quantity == 1`.
899         _packedOwnerships[startTokenId] =
900         _addressToUint256(to) |
901         (block.timestamp << BITPOS_START_TIMESTAMP) |
902         (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
903 
904         uint256 updatedIndex = startTokenId;
905         uint256 end = updatedIndex + quantity;
906 
907         if (to.code.length != 0) {
908             do {
909                 emit Transfer(address(0), to, updatedIndex);
910                 if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
911                     revert TransferToNonERC721ReceiverImplementer();
912                 }
913             }
914             while (updatedIndex < end);
915             // Reentrancy protection
916             if (_currentIndex != startTokenId) revert();
917         } else {
918             do {
919                 emit Transfer(address(0), to, updatedIndex++);
920             }
921             while (updatedIndex < end);
922         }
923         _currentIndex = updatedIndex;
924     }
925         _afterTokenTransfers(address(0), to, startTokenId, quantity);
926     }
927 
928     /**
929      * @dev Mints `quantity` tokens and transfers them to `to`.
930      *
931      * Requirements:
932      *
933      * - `to` cannot be the zero address.
934      * - `quantity` must be greater than 0.
935      *
936      * Emits a {Transfer} event.
937      */
938     function _mint(address to, uint256 quantity) internal {
939         uint256 startTokenId = _currentIndex;
940         if (to == address(0)) revert MintToZeroAddress();
941         if (quantity == 0) revert MintZeroQuantity();
942 
943         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
944 
945         // Overflows are incredibly unrealistic.
946         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
947         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
948     unchecked {
949         // Updates:
950         // - `balance += quantity`.
951         // - `numberMinted += quantity`.
952         //
953         // We can directly add to the balance and number minted.
954         _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
955 
956         // Updates:
957         // - `address` to the owner.
958         // - `startTimestamp` to the timestamp of minting.
959         // - `burned` to `false`.
960         // - `nextInitialized` to `quantity == 1`.
961         _packedOwnerships[startTokenId] =
962         _addressToUint256(to) |
963         (block.timestamp << BITPOS_START_TIMESTAMP) |
964         (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
965 
966         uint256 updatedIndex = startTokenId;
967         uint256 end = updatedIndex + quantity;
968 
969         do {
970             emit Transfer(address(0), to, updatedIndex++);
971         }
972         while (updatedIndex < end);
973 
974         _currentIndex = updatedIndex;
975     }
976         _afterTokenTransfers(address(0), to, startTokenId, quantity);
977     }
978 
979     /**
980      * @dev Transfers `tokenId` from `from` to `to`.
981      *
982      * Requirements:
983      *
984      * - `to` cannot be the zero address.
985      * - `tokenId` token must be owned by `from`.
986      *
987      * Emits a {Transfer} event.
988      */
989     function _transfer(
990         address from,
991         address to,
992         uint256 tokenId
993     ) private {
994         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
995 
996         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
997 
998         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
999         isApprovedForAll(from, _msgSenderERC721A()) ||
1000         getApproved(tokenId) == _msgSenderERC721A());
1001 
1002         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1003         if (to == address(0)) revert TransferToZeroAddress();
1004 
1005         _beforeTokenTransfers(from, to, tokenId, 1);
1006 
1007         // Clear approvals from the previous owner.
1008         delete _tokenApprovals[tokenId];
1009 
1010         // Underflow of the sender's balance is impossible because we check for
1011         // ownership above and the recipient's balance can't realistically overflow.
1012         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1013     unchecked {
1014         // We can directly increment and decrement the balances.
1015         --_packedAddressData[from];
1016         // Updates: `balance -= 1`.
1017         ++_packedAddressData[to];
1018         // Updates: `balance += 1`.
1019 
1020         // Updates:
1021         // - `address` to the next owner.
1022         // - `startTimestamp` to the timestamp of transfering.
1023         // - `burned` to `false`.
1024         // - `nextInitialized` to `true`.
1025         _packedOwnerships[tokenId] =
1026         _addressToUint256(to) |
1027         (block.timestamp << BITPOS_START_TIMESTAMP) |
1028         BITMASK_NEXT_INITIALIZED;
1029 
1030         // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1031         if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1032             uint256 nextTokenId = tokenId + 1;
1033             // If the next slot's address is zero and not burned (i.e. packed value is zero).
1034             if (_packedOwnerships[nextTokenId] == 0) {
1035                 // If the next slot is within bounds.
1036                 if (nextTokenId != _currentIndex) {
1037                     // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1038                     _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1039                 }
1040             }
1041         }
1042     }
1043 
1044         emit Transfer(from, to, tokenId);
1045         _afterTokenTransfers(from, to, tokenId, 1);
1046     }
1047 
1048     /**
1049      * @dev Equivalent to `_burn(tokenId, false)`.
1050      */
1051     function _burn(uint256 tokenId) internal virtual {
1052         _burn(tokenId, false);
1053     }
1054 
1055     /**
1056      * @dev Destroys `tokenId`.
1057      * The approval is cleared when the token is burned.
1058      *
1059      * Requirements:
1060      *
1061      * - `tokenId` must exist.
1062      *
1063      * Emits a {Transfer} event.
1064      */
1065     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1066         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1067 
1068         address from = address(uint160(prevOwnershipPacked));
1069 
1070         if (approvalCheck) {
1071             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1072             isApprovedForAll(from, _msgSenderERC721A()) ||
1073             getApproved(tokenId) == _msgSenderERC721A());
1074 
1075             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1076         }
1077 
1078         _beforeTokenTransfers(from, address(0), tokenId, 1);
1079 
1080         // Clear approvals from the previous owner.
1081         delete _tokenApprovals[tokenId];
1082 
1083         // Underflow of the sender's balance is impossible because we check for
1084         // ownership above and the recipient's balance can't realistically overflow.
1085         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1086     unchecked {
1087         // Updates:
1088         // - `balance -= 1`.
1089         // - `numberBurned += 1`.
1090         //
1091         // We can directly decrement the balance, and increment the number burned.
1092         // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1093         _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1094 
1095         // Updates:
1096         // - `address` to the last owner.
1097         // - `startTimestamp` to the timestamp of burning.
1098         // - `burned` to `true`.
1099         // - `nextInitialized` to `true`.
1100         _packedOwnerships[tokenId] =
1101         _addressToUint256(from) |
1102         (block.timestamp << BITPOS_START_TIMESTAMP) |
1103         BITMASK_BURNED |
1104         BITMASK_NEXT_INITIALIZED;
1105 
1106         // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1107         if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1108             uint256 nextTokenId = tokenId + 1;
1109             // If the next slot's address is zero and not burned (i.e. packed value is zero).
1110             if (_packedOwnerships[nextTokenId] == 0) {
1111                 // If the next slot is within bounds.
1112                 if (nextTokenId != _currentIndex) {
1113                     // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1114                     _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1115                 }
1116             }
1117         }
1118     }
1119 
1120         emit Transfer(from, address(0), tokenId);
1121         _afterTokenTransfers(from, address(0), tokenId, 1);
1122 
1123         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1124     unchecked {
1125         _burnCounter++;
1126     }
1127     }
1128 
1129     /**
1130      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1131      *
1132      * @param from address representing the previous owner of the given token ID
1133      * @param to target address that will receive the tokens
1134      * @param tokenId uint256 ID of the token to be transferred
1135      * @param _data bytes optional data to send along with the call
1136      * @return bool whether the call correctly returned the expected magic value
1137      */
1138     function _checkContractOnERC721Received(
1139         address from,
1140         address to,
1141         uint256 tokenId,
1142         bytes memory _data
1143     ) private returns (bool) {
1144         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1145             bytes4 retval
1146         ) {
1147             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1148         } catch (bytes memory reason) {
1149             if (reason.length == 0) {
1150                 revert TransferToNonERC721ReceiverImplementer();
1151             } else {
1152                 assembly {
1153                     revert(add(32, reason), mload(reason))
1154                 }
1155             }
1156         }
1157     }
1158 
1159     /**
1160      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1161      * And also called before burning one token.
1162      *
1163      * startTokenId - the first token id to be transferred
1164      * quantity - the amount to be transferred
1165      *
1166      * Calling conditions:
1167      *
1168      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1169      * transferred to `to`.
1170      * - When `from` is zero, `tokenId` will be minted for `to`.
1171      * - When `to` is zero, `tokenId` will be burned by `from`.
1172      * - `from` and `to` are never both zero.
1173      */
1174     function _beforeTokenTransfers(
1175         address from,
1176         address to,
1177         uint256 startTokenId,
1178         uint256 quantity
1179     ) internal virtual {}
1180 
1181     /**
1182      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1183      * minting.
1184      * And also called after one token has been burned.
1185      *
1186      * startTokenId - the first token id to be transferred
1187      * quantity - the amount to be transferred
1188      *
1189      * Calling conditions:
1190      *
1191      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1192      * transferred to `to`.
1193      * - When `from` is zero, `tokenId` has been minted for `to`.
1194      * - When `to` is zero, `tokenId` has been burned by `from`.
1195      * - `from` and `to` are never both zero.
1196      */
1197     function _afterTokenTransfers(
1198         address from,
1199         address to,
1200         uint256 startTokenId,
1201         uint256 quantity
1202     ) internal virtual {}
1203 
1204     /**
1205      * @dev Returns the message sender (defaults to `msg.sender`).
1206      *
1207      * If you are writing GSN compatible contracts, you need to override this function.
1208      */
1209     function _msgSenderERC721A() internal view virtual returns (address) {
1210         return msg.sender;
1211     }
1212 
1213     /**
1214      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1215      */
1216     function _toString(uint256 value) internal pure returns (string memory ptr) {
1217         assembly {
1218         // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1219         // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1220         // We will need 1 32-byte word to store the length,
1221         // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1222             ptr := add(mload(0x40), 128)
1223         // Update the free memory pointer to allocate.
1224             mstore(0x40, ptr)
1225 
1226         // Cache the end of the memory to calculate the length later.
1227             let end := ptr
1228 
1229         // We write the string from the rightmost digit to the leftmost digit.
1230         // The following is essentially a do-while loop that also handles the zero case.
1231         // Costs a bit more than early returning for the zero case,
1232         // but cheaper in terms of deployment and overall runtime costs.
1233             for {
1234             // Initialize and perform the first pass without check.
1235                 let temp := value
1236             // Move the pointer 1 byte leftwards to point to an empty character slot.
1237                 ptr := sub(ptr, 1)
1238             // Write the character to the pointer. 48 is the ASCII index of '0'.
1239                 mstore8(ptr, add(48, mod(temp, 10)))
1240                 temp := div(temp, 10)
1241             } temp {
1242             // Keep dividing `temp` until zero.
1243                 temp := div(temp, 10)
1244             } {// Body of the for loop.
1245                 ptr := sub(ptr, 1)
1246                 mstore8(ptr, add(48, mod(temp, 10)))
1247             }
1248 
1249             let length := sub(end, ptr)
1250         // Move the pointer 32 bytes leftwards to make room for the length.
1251             ptr := sub(ptr, 32)
1252         // Store the length.
1253             mstore(ptr, length)
1254         }
1255     }
1256 }
1257 
1258 pragma solidity ^0.8.4;
1259 
1260 /**
1261  * @title ERC721A Burnable Token
1262  * @dev ERC721A Token that can be irreversibly burned (destroyed).
1263  */
1264 abstract contract ERC721ABurnable is ERC721A, IERC721ABurnable {
1265     /**
1266      * @dev Burns `tokenId`. See {ERC721A-_burn}.
1267      *
1268      * Requirements:
1269      *
1270      * - The caller must own `tokenId` or be an approved operator.
1271      */
1272     function burn(uint256 tokenId) public virtual override {
1273         _burn(tokenId, true);
1274     }
1275 }
1276 
1277 pragma solidity ^0.8.4;
1278 
1279 /**
1280  * @title ERC721A Queryable
1281  * @dev ERC721A subclass with convenience query functions.
1282  */
1283 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1284     /**
1285      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1286      *
1287      * If the `tokenId` is out of bounds:
1288      *   - `addr` = `address(0)`
1289      *   - `startTimestamp` = `0`
1290      *   - `burned` = `false`
1291      *
1292      * If the `tokenId` is burned:
1293      *   - `addr` = `<Address of owner before token was burned>`
1294      *   - `startTimestamp` = `<Timestamp when token was burned>`
1295      *   - `burned = `true`
1296      *
1297      * Otherwise:
1298      *   - `addr` = `<Address of owner>`
1299      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1300      *   - `burned = `false`
1301      */
1302     function explicitOwnershipOf(uint256 tokenId) public view override returns (TokenOwnership memory) {
1303         TokenOwnership memory ownership;
1304         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1305             return ownership;
1306         }
1307         ownership = _ownershipAt(tokenId);
1308         if (ownership.burned) {
1309             return ownership;
1310         }
1311         return _ownershipOf(tokenId);
1312     }
1313 
1314     /**
1315      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1316      * See {ERC721AQueryable-explicitOwnershipOf}
1317      */
1318     function explicitOwnershipsOf(uint256[] memory tokenIds) external view override returns (TokenOwnership[] memory) {
1319     unchecked {
1320         uint256 tokenIdsLength = tokenIds.length;
1321         TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1322         for (uint256 i; i != tokenIdsLength; ++i) {
1323             ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1324         }
1325         return ownerships;
1326     }
1327     }
1328 
1329     /**
1330      * @dev Returns an array of token IDs owned by `owner`,
1331      * in the range [`start`, `stop`)
1332      * (i.e. `start <= tokenId < stop`).
1333      *
1334      * This function allows for tokens to be queried if the collection
1335      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1336      *
1337      * Requirements:
1338      *
1339      * - `start` < `stop`
1340      */
1341     function tokensOfOwnerIn(
1342         address owner,
1343         uint256 start,
1344         uint256 stop
1345     ) external view override returns (uint256[] memory) {
1346     unchecked {
1347         if (start >= stop) revert InvalidQueryRange();
1348         uint256 tokenIdsIdx;
1349         uint256 stopLimit = _nextTokenId();
1350         // Set `start = max(start, _startTokenId())`.
1351         if (start < _startTokenId()) {
1352             start = _startTokenId();
1353         }
1354         // Set `stop = min(stop, stopLimit)`.
1355         if (stop > stopLimit) {
1356             stop = stopLimit;
1357         }
1358         uint256 tokenIdsMaxLength = balanceOf(owner);
1359         // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1360         // to cater for cases where `balanceOf(owner)` is too big.
1361         if (start < stop) {
1362             uint256 rangeLength = stop - start;
1363             if (rangeLength < tokenIdsMaxLength) {
1364                 tokenIdsMaxLength = rangeLength;
1365             }
1366         } else {
1367             tokenIdsMaxLength = 0;
1368         }
1369         uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1370         if (tokenIdsMaxLength == 0) {
1371             return tokenIds;
1372         }
1373         // We need to call `explicitOwnershipOf(start)`,
1374         // because the slot at `start` may not be initialized.
1375         TokenOwnership memory ownership = explicitOwnershipOf(start);
1376         address currOwnershipAddr;
1377         // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1378         // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1379         if (!ownership.burned) {
1380             currOwnershipAddr = ownership.addr;
1381         }
1382         for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1383             ownership = _ownershipAt(i);
1384             if (ownership.burned) {
1385                 continue;
1386             }
1387             if (ownership.addr != address(0)) {
1388                 currOwnershipAddr = ownership.addr;
1389             }
1390             if (currOwnershipAddr == owner) {
1391                 tokenIds[tokenIdsIdx++] = i;
1392             }
1393         }
1394         // Downsize the array to fit.
1395         assembly {
1396             mstore(tokenIds, tokenIdsIdx)
1397         }
1398         return tokenIds;
1399     }
1400     }
1401 
1402     /**
1403      * @dev Returns an array of token IDs owned by `owner`.
1404      *
1405      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1406      * It is meant to be called off-chain.
1407      *
1408      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1409      * multiple smaller scans if the collection is large enough to cause
1410      * an out-of-gas error (10K pfp collections should be fine).
1411      */
1412     function tokensOfOwner(address owner) external view override returns (uint256[] memory) {
1413     unchecked {
1414         uint256 tokenIdsIdx;
1415         address currOwnershipAddr;
1416         uint256 tokenIdsLength = balanceOf(owner);
1417         uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1418         TokenOwnership memory ownership;
1419         for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1420             ownership = _ownershipAt(i);
1421             if (ownership.burned) {
1422                 continue;
1423             }
1424             if (ownership.addr != address(0)) {
1425                 currOwnershipAddr = ownership.addr;
1426             }
1427             if (currOwnershipAddr == owner) {
1428                 tokenIds[tokenIdsIdx++] = i;
1429             }
1430         }
1431         return tokenIds;
1432     }
1433     }
1434 }
1435 
1436 
1437 pragma solidity ^0.8.4;
1438 
1439 /**
1440  * @dev Library for managing
1441  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
1442  * types.
1443  *
1444  * Sets have the following properties:
1445  *
1446  * - Elements are added, removed, and checked for existence in constant time
1447  * (O(1)).
1448  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
1449  *
1450  * ```
1451  * contract Example {
1452  *     // Add the library methods
1453  *     using EnumerableSet for EnumerableSet.AddressSet;
1454  *
1455  *     // Declare a set state variable
1456  *     EnumerableSet.AddressSet private mySet;
1457  * }
1458  * ```
1459  *
1460  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
1461  * and `uint256` (`UintSet`) are supported.
1462  */
1463 library EnumerableSet {
1464     // To implement this library for multiple types with as little code
1465     // repetition as possible, we write it in terms of a generic Set type with
1466     // bytes32 values.
1467     // The Set implementation uses private functions, and user-facing
1468     // implementations (such as AddressSet) are just wrappers around the
1469     // underlying Set.
1470     // This means that we can only create new EnumerableSets for types that fit
1471     // in bytes32.
1472 
1473     struct Set {
1474         // Storage of set values
1475         bytes32[] _values;
1476         // Position of the value in the `values` array, plus 1 because index 0
1477         // means a value is not in the set.
1478         mapping(bytes32 => uint256) _indexes;
1479     }
1480 
1481     /**
1482      * @dev Add a value to a set. O(1).
1483      *
1484      * Returns true if the value was added to the set, that is if it was not
1485      * already present.
1486      */
1487     function _add(Set storage set, bytes32 value) private returns (bool) {
1488         if (!_contains(set, value)) {
1489             set._values.push(value);
1490             // The value is stored at length-1, but we add 1 to all indexes
1491             // and use 0 as a sentinel value
1492             set._indexes[value] = set._values.length;
1493             return true;
1494         } else {
1495             return false;
1496         }
1497     }
1498 
1499     /**
1500      * @dev Removes a value from a set. O(1).
1501      *
1502      * Returns true if the value was removed from the set, that is if it was
1503      * present.
1504      */
1505     function _remove(Set storage set, bytes32 value) private returns (bool) {
1506         // We read and store the value's index to prevent multiple reads from the same storage slot
1507         uint256 valueIndex = set._indexes[value];
1508 
1509         if (valueIndex != 0) {
1510             // Equivalent to contains(set, value)
1511             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
1512             // the array, and then remove the last element (sometimes called as 'swap and pop').
1513             // This modifies the order of the array, as noted in {at}.
1514 
1515             uint256 toDeleteIndex = valueIndex - 1;
1516             uint256 lastIndex = set._values.length - 1;
1517 
1518             if (lastIndex != toDeleteIndex) {
1519                 bytes32 lastValue = set._values[lastIndex];
1520 
1521                 // Move the last value to the index where the value to delete is
1522                 set._values[toDeleteIndex] = lastValue;
1523                 // Update the index for the moved value
1524                 set._indexes[lastValue] = valueIndex;
1525                 // Replace lastValue's index to valueIndex
1526             }
1527 
1528             // Delete the slot where the moved value was stored
1529             set._values.pop();
1530 
1531             // Delete the index for the deleted slot
1532             delete set._indexes[value];
1533 
1534             return true;
1535         } else {
1536             return false;
1537         }
1538     }
1539 
1540     /**
1541      * @dev Returns true if the value is in the set. O(1).
1542      */
1543     function _contains(Set storage set, bytes32 value) private view returns (bool) {
1544         return set._indexes[value] != 0;
1545     }
1546 
1547     /**
1548      * @dev Returns the number of values on the set. O(1).
1549      */
1550     function _length(Set storage set) private view returns (uint256) {
1551         return set._values.length;
1552     }
1553 
1554     /**
1555      * @dev Returns the value stored at position `index` in the set. O(1).
1556      *
1557      * Note that there are no guarantees on the ordering of values inside the
1558      * array, and it may change when more values are added or removed.
1559      *
1560      * Requirements:
1561      *
1562      * - `index` must be strictly less than {length}.
1563      */
1564     function _at(Set storage set, uint256 index) private view returns (bytes32) {
1565         return set._values[index];
1566     }
1567 
1568     /**
1569      * @dev Return the entire set in an array
1570      *
1571      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1572      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1573      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1574      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1575      */
1576     function _values(Set storage set) private view returns (bytes32[] memory) {
1577         return set._values;
1578     }
1579 
1580     // Bytes32Set
1581 
1582     struct Bytes32Set {
1583         Set _inner;
1584     }
1585 
1586     /**
1587      * @dev Add a value to a set. O(1).
1588      *
1589      * Returns true if the value was added to the set, that is if it was not
1590      * already present.
1591      */
1592     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1593         return _add(set._inner, value);
1594     }
1595 
1596     /**
1597      * @dev Removes a value from a set. O(1).
1598      *
1599      * Returns true if the value was removed from the set, that is if it was
1600      * present.
1601      */
1602     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1603         return _remove(set._inner, value);
1604     }
1605 
1606     /**
1607      * @dev Returns true if the value is in the set. O(1).
1608      */
1609     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
1610         return _contains(set._inner, value);
1611     }
1612 
1613     /**
1614      * @dev Returns the number of values in the set. O(1).
1615      */
1616     function length(Bytes32Set storage set) internal view returns (uint256) {
1617         return _length(set._inner);
1618     }
1619 
1620     /**
1621      * @dev Returns the value stored at position `index` in the set. O(1).
1622      *
1623      * Note that there are no guarantees on the ordering of values inside the
1624      * array, and it may change when more values are added or removed.
1625      *
1626      * Requirements:
1627      *
1628      * - `index` must be strictly less than {length}.
1629      */
1630     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
1631         return _at(set._inner, index);
1632     }
1633 
1634     /**
1635      * @dev Return the entire set in an array
1636      *
1637      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1638      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1639      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1640      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1641      */
1642     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
1643         return _values(set._inner);
1644     }
1645 
1646     // AddressSet
1647 
1648     struct AddressSet {
1649         Set _inner;
1650     }
1651 
1652     /**
1653      * @dev Add a value to a set. O(1).
1654      *
1655      * Returns true if the value was added to the set, that is if it was not
1656      * already present.
1657      */
1658     function add(AddressSet storage set, address value) internal returns (bool) {
1659         return _add(set._inner, bytes32(uint256(uint160(value))));
1660     }
1661 
1662     /**
1663      * @dev Removes a value from a set. O(1).
1664      *
1665      * Returns true if the value was removed from the set, that is if it was
1666      * present.
1667      */
1668     function remove(AddressSet storage set, address value) internal returns (bool) {
1669         return _remove(set._inner, bytes32(uint256(uint160(value))));
1670     }
1671 
1672     /**
1673      * @dev Returns true if the value is in the set. O(1).
1674      */
1675     function contains(AddressSet storage set, address value) internal view returns (bool) {
1676         return _contains(set._inner, bytes32(uint256(uint160(value))));
1677     }
1678 
1679     /**
1680      * @dev Returns the number of values in the set. O(1).
1681      */
1682     function length(AddressSet storage set) internal view returns (uint256) {
1683         return _length(set._inner);
1684     }
1685 
1686     /**
1687      * @dev Returns the value stored at position `index` in the set. O(1).
1688      *
1689      * Note that there are no guarantees on the ordering of values inside the
1690      * array, and it may change when more values are added or removed.
1691      *
1692      * Requirements:
1693      *
1694      * - `index` must be strictly less than {length}.
1695      */
1696     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1697         return address(uint160(uint256(_at(set._inner, index))));
1698     }
1699 
1700     /**
1701      * @dev Return the entire set in an array
1702      *
1703      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1704      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1705      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1706      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1707      */
1708     function values(AddressSet storage set) internal view returns (address[] memory) {
1709         bytes32[] memory store = _values(set._inner);
1710         address[] memory result;
1711 
1712         assembly {
1713             result := store
1714         }
1715 
1716         return result;
1717     }
1718 
1719     // UintSet
1720 
1721     struct UintSet {
1722         Set _inner;
1723     }
1724 
1725     /**
1726      * @dev Add a value to a set. O(1).
1727      *
1728      * Returns true if the value was added to the set, that is if it was not
1729      * already present.
1730      */
1731     function add(UintSet storage set, uint256 value) internal returns (bool) {
1732         return _add(set._inner, bytes32(value));
1733     }
1734 
1735     /**
1736      * @dev Removes a value from a set. O(1).
1737      *
1738      * Returns true if the value was removed from the set, that is if it was
1739      * present.
1740      */
1741     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1742         return _remove(set._inner, bytes32(value));
1743     }
1744 
1745     /**
1746      * @dev Returns true if the value is in the set. O(1).
1747      */
1748     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1749         return _contains(set._inner, bytes32(value));
1750     }
1751 
1752     /**
1753      * @dev Returns the number of values on the set. O(1).
1754      */
1755     function length(UintSet storage set) internal view returns (uint256) {
1756         return _length(set._inner);
1757     }
1758 
1759     /**
1760      * @dev Returns the value stored at position `index` in the set. O(1).
1761      *
1762      * Note that there are no guarantees on the ordering of values inside the
1763      * array, and it may change when more values are added or removed.
1764      *
1765      * Requirements:
1766      *
1767      * - `index` must be strictly less than {length}.
1768      */
1769     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1770         return uint256(_at(set._inner, index));
1771     }
1772 
1773     /**
1774      * @dev Return the entire set in an array
1775      *
1776      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1777      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1778      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1779      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1780      */
1781     function values(UintSet storage set) internal view returns (uint256[] memory) {
1782         bytes32[] memory store = _values(set._inner);
1783         uint256[] memory result;
1784 
1785         assembly {
1786             result := store
1787         }
1788 
1789         return result;
1790     }
1791 }
1792 
1793 pragma solidity ^0.8.4;
1794 
1795 contract Pepeverse is ERC721AQueryable, ERC721ABurnable, Ownable {
1796     using EnumerableSet for EnumerableSet.UintSet;
1797 
1798     uint256 public constant MAX_SUPPLY = 333;
1799 
1800     uint256 public maxByWallet = 1;
1801     mapping(address => uint256) public mintedByWallet;
1802 
1803     // 0:close | 1:open
1804     bool public saleState;
1805 
1806     bool public collectMarketing = true;
1807 
1808     //baseURI
1809     string public baseURI;
1810 
1811     //uriSuffix
1812     string public uriSuffix;
1813 
1814     constructor(
1815         string memory name,
1816         string memory symbol,
1817         string memory baseURI_,
1818         string memory uriSuffix_
1819     ) ERC721A(name, symbol) {
1820         baseURI = baseURI_;
1821         uriSuffix = uriSuffix_;
1822     }
1823 
1824     uint256 public MINT_PRICE = .009 ether;
1825 
1826     /******************** PUBLIC ********************/
1827 
1828     function mint(uint256 amount) external payable {
1829         require(msg.sender == tx.origin, "not allowed");
1830         require(saleState, "Sale is closed!");
1831         require(_totalMinted() + amount <= MAX_SUPPLY, "Exceed MAX_SUPPLY");
1832         require(amount > 0, "Amount can't be 0");
1833         require(amount + mintedByWallet[msg.sender] <= maxByWallet, "Exceed maxByWallet");
1834 
1835         if (collectMarketing) {
1836             require(amount * MINT_PRICE <= msg.value, "Invalid payment amount");
1837         }
1838 
1839         mintedByWallet[msg.sender] += amount;
1840 
1841         _safeMint(msg.sender, amount);
1842     }
1843 
1844     /******************** OVERRIDES ********************/
1845 
1846     function _startTokenId() internal view virtual override returns (uint256) {
1847         return 1;
1848     }
1849 
1850     function _baseURI() internal view virtual override returns (string memory) {
1851         return baseURI;
1852     }
1853 
1854     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1855         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1856 
1857         if (bytes(baseURI).length == 0) {
1858             return _toString(tokenId);
1859         }
1860 
1861         return string(abi.encodePacked(baseURI, _toString(tokenId), uriSuffix));
1862     }
1863 
1864     /******************** OWNER ********************/
1865 
1866     /// @notice Set baseURI.
1867     /// @param newBaseURI New baseURI.
1868     /// @param newUriSuffix New uriSuffix.
1869     function setBaseURI(string memory newBaseURI, string memory newUriSuffix) external onlyOwner {
1870         baseURI = newBaseURI;
1871         uriSuffix = newUriSuffix;
1872     }
1873 
1874     /// @notice Set saleState.
1875     /// @param newSaleState New sale state.
1876     function setSaleState(bool newSaleState) external onlyOwner {
1877         saleState = newSaleState;
1878     }
1879 
1880     /// @notice Set collectMarketing.
1881     /// @param newCollectMarketing New collect marketing flag.
1882     function setCollectMarketing(bool newCollectMarketing) external onlyOwner {
1883         collectMarketing = newCollectMarketing;
1884     }
1885 
1886     /// @notice Set maxByWallet.
1887     /// @param newMaxByWallet New max by wallet
1888     function setMaxByWallet(uint256 newMaxByWallet) external onlyOwner {
1889         maxByWallet = newMaxByWallet;
1890     }
1891 
1892     /******************** ALPHA MINT ********************/
1893 
1894     function alphaMint(address[] calldata addresses, uint256[] calldata count) external onlyOwner {
1895         require(!saleState, "sale is open!");
1896         require(addresses.length == count.length, "mismatching lengths!");
1897 
1898         for (uint256 i; i < addresses.length; i++) {
1899             _safeMint(addresses[i], count[i]);
1900         }
1901 
1902         require(_totalMinted() <= MAX_SUPPLY, "Exceed MAX_SUPPLY");
1903     }
1904 
1905     function withdraw() external onlyOwner {
1906         payable(owner()).transfer(address(this).balance);
1907     }
1908 }