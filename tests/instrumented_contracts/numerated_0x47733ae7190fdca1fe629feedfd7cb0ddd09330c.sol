1 pragma solidity >=0.7.0 <0.9.0;
2 
3 abstract contract Context {
4     function _msgSender() internal view virtual returns (address) {
5         return msg.sender;
6     }
7 
8     function _msgData() internal view virtual returns (bytes calldata) {
9         return msg.data;
10     }
11 }
12 
13 abstract contract Pausable is Context {
14     /**
15      * @dev Emitted when the pause is triggered by `account`.
16      */
17     event Paused(address account);
18 
19     /**
20      * @dev Emitted when the pause is lifted by `account`.
21      */
22     event Unpaused(address account);
23 
24     bool private _paused;
25 
26     /**
27      * @dev Initializes the contract in unpaused state.
28      */
29     constructor() {
30         _paused = false;
31     }
32 
33     /**
34      * @dev Modifier to make a function callable only when the contract is not paused.
35      *
36      * Requirements:
37      *
38      * - The contract must not be paused.
39      */
40     modifier whenNotPaused() {
41         _requireNotPaused();
42         _;
43     }
44 
45     /**
46      * @dev Modifier to make a function callable only when the contract is paused.
47      *
48      * Requirements:
49      *
50      * - The contract must be paused.
51      */
52     modifier whenPaused() {
53         _requirePaused();
54         _;
55     }
56 
57     /**
58      * @dev Returns true if the contract is paused, and false otherwise.
59      */
60     function paused() public view virtual returns (bool) {
61         return _paused;
62     }
63 
64     /**
65      * @dev Throws if the contract is paused.
66      */
67     function _requireNotPaused() internal view virtual {
68         require(!paused(), "Pausable: paused");
69     }
70 
71     /**
72      * @dev Throws if the contract is not paused.
73      */
74     function _requirePaused() internal view virtual {
75         require(paused(), "Pausable: not paused");
76     }
77 
78     /**
79      * @dev Triggers stopped state.
80      *
81      * Requirements:
82      *
83      * - The contract must not be paused.
84      */
85     function _pause() internal virtual whenNotPaused {
86         _paused = true;
87         emit Paused(_msgSender());
88     }
89 
90     /**
91      * @dev Returns to normal state.
92      *
93      * Requirements:
94      *
95      * - The contract must be paused.
96      */
97     function _unpause() internal virtual whenPaused {
98         _paused = false;
99         emit Unpaused(_msgSender());
100     }
101 }
102 
103 abstract contract Ownable is Context {
104     address private _owner;
105 
106     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
107 
108     /**
109      * @dev Initializes the contract setting the deployer as the initial owner.
110      */
111     constructor() {
112         _transferOwnership(_msgSender());
113     }
114 
115     /**
116      * @dev Returns the address of the current owner.
117      */
118     function owner() public view virtual returns (address) {
119         return _owner;
120     }
121 
122     /**
123      * @dev Throws if called by any account other than the owner.
124      */
125     modifier onlyOwner() {
126         require(owner() == _msgSender(), "Ownable: caller is not the owner");
127         _;
128     }
129 
130     /**
131      * @dev Leaves the contract without owner. It will not be possible to call
132      * `onlyOwner` functions anymore. Can only be called by the current owner.
133      *
134      * NOTE: Renouncing ownership will leave the contract without an owner,
135      * thereby removing any functionality that is only available to the owner.
136      */
137     function renounceOwnership() public virtual onlyOwner {
138         _transferOwnership(address(0));
139     }
140 
141     /**
142      * @dev Transfers ownership of the contract to a new account (`newOwner`).
143      * Can only be called by the current owner.
144      */
145     function transferOwnership(address newOwner) public virtual onlyOwner {
146         require(newOwner != address(0), "Ownable: new owner is the zero address");
147         _transferOwnership(newOwner);
148     }
149 
150     /**
151      * @dev Transfers ownership of the contract to a new account (`newOwner`).
152      * Internal function without access restriction.
153      */
154     function _transferOwnership(address newOwner) internal virtual {
155         address oldOwner = _owner;
156         _owner = newOwner;
157         emit OwnershipTransferred(oldOwner, newOwner);
158     }
159 }
160 
161 interface ERC721A__IERC721Receiver {
162     function onERC721Received(
163         address operator,
164         address from,
165         uint256 tokenId,
166         bytes calldata data
167     ) external returns (bytes4);
168 }
169 
170 interface IERC721A {
171     /**
172      * The caller must own the token or be an approved operator.
173      */
174     error ApprovalCallerNotOwnerNorApproved();
175 
176     /**
177      * The token does not exist.
178      */
179     error ApprovalQueryForNonexistentToken();
180 
181     /**
182      * Cannot query the balance for the zero address.
183      */
184     error BalanceQueryForZeroAddress();
185 
186     /**
187      * Cannot mint to the zero address.
188      */
189     error MintToZeroAddress();
190 
191     /**
192      * The quantity of tokens minted must be more than zero.
193      */
194     error MintZeroQuantity();
195 
196     /**
197      * The token does not exist.
198      */
199     error OwnerQueryForNonexistentToken();
200 
201     /**
202      * The caller must own the token or be an approved operator.
203      */
204     error TransferCallerNotOwnerNorApproved();
205 
206     /**
207      * The token must be owned by `from`.
208      */
209     error TransferFromIncorrectOwner();
210 
211     /**
212      * Cannot safely transfer to a contract that does not implement the
213      * ERC721Receiver interface.
214      */
215     error TransferToNonERC721ReceiverImplementer();
216 
217     /**
218      * Cannot transfer to the zero address.
219      */
220     error TransferToZeroAddress();
221 
222     /**
223      * The token does not exist.
224      */
225     error URIQueryForNonexistentToken();
226 
227     /**
228      * The `quantity` minted with ERC2309 exceeds the safety limit.
229      */
230     error MintERC2309QuantityExceedsLimit();
231 
232     /**
233      * The `extraData` cannot be set on an unintialized ownership slot.
234      */
235     error OwnershipNotInitializedForExtraData();
236 
237     // =============================================================
238     //                            STRUCTS
239     // =============================================================
240 
241     struct TokenOwnership {
242         // The address of the owner.
243         address addr;
244         // Stores the start time of ownership with minimal overhead for tokenomics.
245         uint64 startTimestamp;
246         // Whether the token has been burned.
247         bool burned;
248         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
249         uint24 extraData;
250     }
251 
252     // =============================================================
253     //                         TOKEN COUNTERS
254     // =============================================================
255 
256     /**
257      * @dev Returns the total number of tokens in existence.
258      * Burned tokens will reduce the count.
259      * To get the total number of tokens minted, please see {_totalMinted}.
260      */
261     function totalSupply() external view returns (uint256);
262 
263     // =============================================================
264     //                            IERC165
265     // =============================================================
266 
267     /**
268      * @dev Returns true if this contract implements the interface defined by
269      * `interfaceId`. See the corresponding
270      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
271      * to learn more about how these ids are created.
272      *
273      * This function call must use less than 30000 gas.
274      */
275     function supportsInterface(bytes4 interfaceId) external view returns (bool);
276 
277     // =============================================================
278     //                            IERC721
279     // =============================================================
280 
281     /**
282      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
283      */
284     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
285 
286     /**
287      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
288      */
289     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
290 
291     /**
292      * @dev Emitted when `owner` enables or disables
293      * (`approved`) `operator` to manage all of its assets.
294      */
295     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
296 
297     /**
298      * @dev Returns the number of tokens in `owner`'s account.
299      */
300     function balanceOf(address owner) external view returns (uint256 balance);
301 
302     /**
303      * @dev Returns the owner of the `tokenId` token.
304      *
305      * Requirements:
306      *
307      * - `tokenId` must exist.
308      */
309     function ownerOf(uint256 tokenId) external view returns (address owner);
310 
311     /**
312      * @dev Safely transfers `tokenId` token from `from` to `to`,
313      * checking first that contract recipients are aware of the ERC721 protocol
314      * to prevent tokens from being forever locked.
315      *
316      * Requirements:
317      *
318      * - `from` cannot be the zero address.
319      * - `to` cannot be the zero address.
320      * - `tokenId` token must exist and be owned by `from`.
321      * - If the caller is not `from`, it must be have been allowed to move
322      * this token by either {approve} or {setApprovalForAll}.
323      * - If `to` refers to a smart contract, it must implement
324      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
325      *
326      * Emits a {Transfer} event.
327      */
328     function safeTransferFrom(
329         address from,
330         address to,
331         uint256 tokenId,
332         bytes calldata data
333     ) external payable;
334 
335     /**
336      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
337      */
338     function safeTransferFrom(
339         address from,
340         address to,
341         uint256 tokenId
342     ) external payable;
343 
344     /**
345      * @dev Transfers `tokenId` from `from` to `to`.
346      *
347      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
348      * whenever possible.
349      *
350      * Requirements:
351      *
352      * - `from` cannot be the zero address.
353      * - `to` cannot be the zero address.
354      * - `tokenId` token must be owned by `from`.
355      * - If the caller is not `from`, it must be approved to move this token
356      * by either {approve} or {setApprovalForAll}.
357      *
358      * Emits a {Transfer} event.
359      */
360     function transferFrom(
361         address from,
362         address to,
363         uint256 tokenId
364     ) external payable;
365 
366     /**
367      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
368      * The approval is cleared when the token is transferred.
369      *
370      * Only a single account can be approved at a time, so approving the
371      * zero address clears previous approvals.
372      *
373      * Requirements:
374      *
375      * - The caller must own the token or be an approved operator.
376      * - `tokenId` must exist.
377      *
378      * Emits an {Approval} event.
379      */
380     function approve(address to, uint256 tokenId) external payable;
381 
382     /**
383      * @dev Approve or remove `operator` as an operator for the caller.
384      * Operators can call {transferFrom} or {safeTransferFrom}
385      * for any token owned by the caller.
386      *
387      * Requirements:
388      *
389      * - The `operator` cannot be the caller.
390      *
391      * Emits an {ApprovalForAll} event.
392      */
393     function setApprovalForAll(address operator, bool _approved) external;
394 
395     /**
396      * @dev Returns the account approved for `tokenId` token.
397      *
398      * Requirements:
399      *
400      * - `tokenId` must exist.
401      */
402     function getApproved(uint256 tokenId) external view returns (address operator);
403 
404     /**
405      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
406      *
407      * See {setApprovalForAll}.
408      */
409     function isApprovedForAll(address owner, address operator) external view returns (bool);
410 
411     // =============================================================
412     //                        IERC721Metadata
413     // =============================================================
414 
415     /**
416      * @dev Returns the token collection name.
417      */
418     function name() external view returns (string memory);
419 
420     /**
421      * @dev Returns the token collection symbol.
422      */
423     function symbol() external view returns (string memory);
424 
425     /**
426      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
427      */
428     function tokenURI(uint256 tokenId) external view returns (string memory);
429 
430     // =============================================================
431     //                           IERC2309
432     // =============================================================
433 
434     /**
435      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
436      * (inclusive) is transferred from `from` to `to`, as defined in the
437      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
438      *
439      * See {_mintERC2309} for more details.
440      */
441     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
442 }
443 
444 contract ERC721A is IERC721A {
445     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
446     struct TokenApprovalRef {
447         address value;
448     }
449 
450     // =============================================================
451     //                           CONSTANTS
452     // =============================================================
453 
454     // Mask of an entry in packed address data.
455     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
456 
457     // The bit position of `numberMinted` in packed address data.
458     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
459 
460     // The bit position of `numberBurned` in packed address data.
461     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
462 
463     // The bit position of `aux` in packed address data.
464     uint256 private constant _BITPOS_AUX = 192;
465 
466     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
467     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
468 
469     // The bit position of `startTimestamp` in packed ownership.
470     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
471 
472     // The bit mask of the `burned` bit in packed ownership.
473     uint256 private constant _BITMASK_BURNED = 1 << 224;
474 
475     // The bit position of the `nextInitialized` bit in packed ownership.
476     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
477 
478     // The bit mask of the `nextInitialized` bit in packed ownership.
479     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
480 
481     // The bit position of `extraData` in packed ownership.
482     uint256 private constant _BITPOS_EXTRA_DATA = 232;
483 
484     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
485     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
486 
487     // The mask of the lower 160 bits for addresses.
488     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
489 
490     // The maximum `quantity` that can be minted with {_mintERC2309}.
491     // This limit is to prevent overflows on the address data entries.
492     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
493     // is required to cause an overflow, which is unrealistic.
494     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
495 
496     // The `Transfer` event signature is given by:
497     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
498     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
499         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
500 
501     // =============================================================
502     //                            STORAGE
503     // =============================================================
504 
505     // The next token ID to be minted.
506     uint256 private _currentIndex;
507 
508     // The number of tokens burned.
509     uint256 private _burnCounter;
510 
511     // Token name
512     string private _name;
513 
514     // Token symbol
515     string private _symbol;
516 
517     // Mapping from token ID to ownership details
518     // An empty struct value does not necessarily mean the token is unowned.
519     // See {_packedOwnershipOf} implementation for details.
520     //
521     // Bits Layout:
522     // - [0..159]   `addr`
523     // - [160..223] `startTimestamp`
524     // - [224]      `burned`
525     // - [225]      `nextInitialized`
526     // - [232..255] `extraData`
527     mapping(uint256 => uint256) private _packedOwnerships;
528 
529     // Mapping owner address to address data.
530     //
531     // Bits Layout:
532     // - [0..63]    `balance`
533     // - [64..127]  `numberMinted`
534     // - [128..191] `numberBurned`
535     // - [192..255] `aux`
536     mapping(address => uint256) private _packedAddressData;
537 
538     // Mapping from token ID to approved address.
539     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
540 
541     // Mapping from owner to operator approvals
542     mapping(address => mapping(address => bool)) private _operatorApprovals;
543 
544     // =============================================================
545     //                          CONSTRUCTOR
546     // =============================================================
547 
548     constructor(string memory name_, string memory symbol_) {
549         _name = name_;
550         _symbol = symbol_;
551         _currentIndex = _startTokenId();
552     }
553 
554     // =============================================================
555     //                   TOKEN COUNTING OPERATIONS
556     // =============================================================
557 
558     /**
559      * @dev Returns the starting token ID.
560      * To change the starting token ID, please override this function.
561      */
562     function _startTokenId() internal view virtual returns (uint256) {
563         return 0;
564     }
565 
566     /**
567      * @dev Returns the next token ID to be minted.
568      */
569     function _nextTokenId() internal view virtual returns (uint256) {
570         return _currentIndex;
571     }
572 
573     /**
574      * @dev Returns the total number of tokens in existence.
575      * Burned tokens will reduce the count.
576      * To get the total number of tokens minted, please see {_totalMinted}.
577      */
578     function totalSupply() public view virtual override returns (uint256) {
579         // Counter underflow is impossible as _burnCounter cannot be incremented
580         // more than `_currentIndex - _startTokenId()` times.
581         unchecked {
582             return _currentIndex - _burnCounter - _startTokenId();
583         }
584     }
585 
586     /**
587      * @dev Returns the total amount of tokens minted in the contract.
588      */
589     function _totalMinted() internal view virtual returns (uint256) {
590         // Counter underflow is impossible as `_currentIndex` does not decrement,
591         // and it is initialized to `_startTokenId()`.
592         unchecked {
593             return _currentIndex - _startTokenId();
594         }
595     }
596 
597     /**
598      * @dev Returns the total number of tokens burned.
599      */
600     function _totalBurned() internal view virtual returns (uint256) {
601         return _burnCounter;
602     }
603 
604     // =============================================================
605     //                    ADDRESS DATA OPERATIONS
606     // =============================================================
607 
608     /**
609      * @dev Returns the number of tokens in `owner`'s account.
610      */
611     function balanceOf(address owner) public view virtual override returns (uint256) {
612         if (owner == address(0)) revert BalanceQueryForZeroAddress();
613         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
614     }
615 
616     /**
617      * Returns the number of tokens minted by `owner`.
618      */
619     function _numberMinted(address owner) internal view returns (uint256) {
620         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
621     }
622 
623     /**
624      * Returns the number of tokens burned by or on behalf of `owner`.
625      */
626     function _numberBurned(address owner) internal view returns (uint256) {
627         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
628     }
629 
630     /**
631      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
632      */
633     function _getAux(address owner) internal view returns (uint64) {
634         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
635     }
636 
637     /**
638      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
639      * If there are multiple variables, please pack them into a uint64.
640      */
641     function _setAux(address owner, uint64 aux) internal virtual {
642         uint256 packed = _packedAddressData[owner];
643         uint256 auxCasted;
644         // Cast `aux` with assembly to avoid redundant masking.
645         assembly {
646             auxCasted := aux
647         }
648         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
649         _packedAddressData[owner] = packed;
650     }
651 
652     // =============================================================
653     //                            IERC165
654     // =============================================================
655 
656     /**
657      * @dev Returns true if this contract implements the interface defined by
658      * `interfaceId`. See the corresponding
659      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
660      * to learn more about how these ids are created.
661      *
662      * This function call must use less than 30000 gas.
663      */
664     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
665         // The interface IDs are constants representing the first 4 bytes
666         // of the XOR of all function selectors in the interface.
667         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
668         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
669         return
670             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
671             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
672             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
673     }
674 
675     // =============================================================
676     //                        IERC721Metadata
677     // =============================================================
678 
679     /**
680      * @dev Returns the token collection name.
681      */
682     function name() public view virtual override returns (string memory) {
683         return _name;
684     }
685 
686     /**
687      * @dev Returns the token collection symbol.
688      */
689     function symbol() public view virtual override returns (string memory) {
690         return _symbol;
691     }
692 
693     /**
694      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
695      */
696     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
697         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
698 
699         string memory baseURI = _baseURI();
700         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
701     }
702 
703     /**
704      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
705      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
706      * by default, it can be overridden in child contracts.
707      */
708     function _baseURI() internal view virtual returns (string memory) {
709         return '';
710     }
711 
712     // =============================================================
713     //                     OWNERSHIPS OPERATIONS
714     // =============================================================
715 
716     /**
717      * @dev Returns the owner of the `tokenId` token.
718      *
719      * Requirements:
720      *
721      * - `tokenId` must exist.
722      */
723     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
724         return address(uint160(_packedOwnershipOf(tokenId)));
725     }
726 
727     /**
728      * @dev Gas spent here starts off proportional to the maximum mint batch size.
729      * It gradually moves to O(1) as tokens get transferred around over time.
730      */
731     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
732         return _unpackedOwnership(_packedOwnershipOf(tokenId));
733     }
734 
735     /**
736      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
737      */
738     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
739         return _unpackedOwnership(_packedOwnerships[index]);
740     }
741 
742     /**
743      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
744      */
745     function _initializeOwnershipAt(uint256 index) internal virtual {
746         if (_packedOwnerships[index] == 0) {
747             _packedOwnerships[index] = _packedOwnershipOf(index);
748         }
749     }
750 
751     /**
752      * Returns the packed ownership data of `tokenId`.
753      */
754     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
755         uint256 curr = tokenId;
756 
757         unchecked {
758             if (_startTokenId() <= curr)
759                 if (curr < _currentIndex) {
760                     uint256 packed = _packedOwnerships[curr];
761                     // If not burned.
762                     if (packed & _BITMASK_BURNED == 0) {
763                         // Invariant:
764                         // There will always be an initialized ownership slot
765                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
766                         // before an unintialized ownership slot
767                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
768                         // Hence, `curr` will not underflow.
769                         //
770                         // We can directly compare the packed value.
771                         // If the address is zero, packed will be zero.
772                         while (packed == 0) {
773                             packed = _packedOwnerships[--curr];
774                         }
775                         return packed;
776                     }
777                 }
778         }
779         revert OwnerQueryForNonexistentToken();
780     }
781 
782     /**
783      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
784      */
785     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
786         ownership.addr = address(uint160(packed));
787         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
788         ownership.burned = packed & _BITMASK_BURNED != 0;
789         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
790     }
791 
792     /**
793      * @dev Packs ownership data into a single uint256.
794      */
795     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
796         assembly {
797             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
798             owner := and(owner, _BITMASK_ADDRESS)
799             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
800             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
801         }
802     }
803 
804     /**
805      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
806      */
807     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
808         // For branchless setting of the `nextInitialized` flag.
809         assembly {
810             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
811             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
812         }
813     }
814 
815     // =============================================================
816     //                      APPROVAL OPERATIONS
817     // =============================================================
818 
819     /**
820      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
821      * The approval is cleared when the token is transferred.
822      *
823      * Only a single account can be approved at a time, so approving the
824      * zero address clears previous approvals.
825      *
826      * Requirements:
827      *
828      * - The caller must own the token or be an approved operator.
829      * - `tokenId` must exist.
830      *
831      * Emits an {Approval} event.
832      */
833     function approve(address to, uint256 tokenId) public payable virtual override {
834         address owner = ownerOf(tokenId);
835 
836         if (_msgSenderERC721A() != owner)
837             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
838                 revert ApprovalCallerNotOwnerNorApproved();
839             }
840 
841         _tokenApprovals[tokenId].value = to;
842         emit Approval(owner, to, tokenId);
843     }
844 
845     /**
846      * @dev Returns the account approved for `tokenId` token.
847      *
848      * Requirements:
849      *
850      * - `tokenId` must exist.
851      */
852     function getApproved(uint256 tokenId) public view virtual override returns (address) {
853         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
854 
855         return _tokenApprovals[tokenId].value;
856     }
857 
858     /**
859      * @dev Approve or remove `operator` as an operator for the caller.
860      * Operators can call {transferFrom} or {safeTransferFrom}
861      * for any token owned by the caller.
862      *
863      * Requirements:
864      *
865      * - The `operator` cannot be the caller.
866      *
867      * Emits an {ApprovalForAll} event.
868      */
869     function setApprovalForAll(address operator, bool approved) public virtual override {
870         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
871         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
872     }
873 
874     /**
875      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
876      *
877      * See {setApprovalForAll}.
878      */
879     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
880         return _operatorApprovals[owner][operator];
881     }
882 
883     /**
884      * @dev Returns whether `tokenId` exists.
885      *
886      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
887      *
888      * Tokens start existing when they are minted. See {_mint}.
889      */
890     function _exists(uint256 tokenId) internal view virtual returns (bool) {
891         return
892             _startTokenId() <= tokenId &&
893             tokenId < _currentIndex && // If within bounds,
894             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
895     }
896 
897     /**
898      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
899      */
900     function _isSenderApprovedOrOwner(
901         address approvedAddress,
902         address owner,
903         address msgSender
904     ) private pure returns (bool result) {
905         assembly {
906             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
907             owner := and(owner, _BITMASK_ADDRESS)
908             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
909             msgSender := and(msgSender, _BITMASK_ADDRESS)
910             // `msgSender == owner || msgSender == approvedAddress`.
911             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
912         }
913     }
914 
915     /**
916      * @dev Returns the storage slot and value for the approved address of `tokenId`.
917      */
918     function _getApprovedSlotAndAddress(uint256 tokenId)
919         private
920         view
921         returns (uint256 approvedAddressSlot, address approvedAddress)
922     {
923         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
924         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
925         assembly {
926             approvedAddressSlot := tokenApproval.slot
927             approvedAddress := sload(approvedAddressSlot)
928         }
929     }
930 
931     // =============================================================
932     //                      TRANSFER OPERATIONS
933     // =============================================================
934 
935     /**
936      * @dev Transfers `tokenId` from `from` to `to`.
937      *
938      * Requirements:
939      *
940      * - `from` cannot be the zero address.
941      * - `to` cannot be the zero address.
942      * - `tokenId` token must be owned by `from`.
943      * - If the caller is not `from`, it must be approved to move this token
944      * by either {approve} or {setApprovalForAll}.
945      *
946      * Emits a {Transfer} event.
947      */
948     function transferFrom(
949         address from,
950         address to,
951         uint256 tokenId
952     ) public payable virtual override {
953         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
954 
955         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
956 
957         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
958 
959         // The nested ifs save around 20+ gas over a compound boolean condition.
960         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
961             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
962 
963         if (to == address(0)) revert TransferToZeroAddress();
964 
965         _beforeTokenTransfers(from, to, tokenId, 1);
966 
967         // Clear approvals from the previous owner.
968         assembly {
969             if approvedAddress {
970                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
971                 sstore(approvedAddressSlot, 0)
972             }
973         }
974 
975         // Underflow of the sender's balance is impossible because we check for
976         // ownership above and the recipient's balance can't realistically overflow.
977         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
978         unchecked {
979             // We can directly increment and decrement the balances.
980             --_packedAddressData[from]; // Updates: `balance -= 1`.
981             ++_packedAddressData[to]; // Updates: `balance += 1`.
982 
983             // Updates:
984             // - `address` to the next owner.
985             // - `startTimestamp` to the timestamp of transfering.
986             // - `burned` to `false`.
987             // - `nextInitialized` to `true`.
988             _packedOwnerships[tokenId] = _packOwnershipData(
989                 to,
990                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
991             );
992 
993             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
994             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
995                 uint256 nextTokenId = tokenId + 1;
996                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
997                 if (_packedOwnerships[nextTokenId] == 0) {
998                     // If the next slot is within bounds.
999                     if (nextTokenId != _currentIndex) {
1000                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1001                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1002                     }
1003                 }
1004             }
1005         }
1006 
1007         emit Transfer(from, to, tokenId);
1008         _afterTokenTransfers(from, to, tokenId, 1);
1009     }
1010 
1011     /**
1012      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1013      */
1014     function safeTransferFrom(
1015         address from,
1016         address to,
1017         uint256 tokenId
1018     ) public payable virtual override {
1019         safeTransferFrom(from, to, tokenId, '');
1020     }
1021 
1022     /**
1023      * @dev Safely transfers `tokenId` token from `from` to `to`.
1024      *
1025      * Requirements:
1026      *
1027      * - `from` cannot be the zero address.
1028      * - `to` cannot be the zero address.
1029      * - `tokenId` token must exist and be owned by `from`.
1030      * - If the caller is not `from`, it must be approved to move this token
1031      * by either {approve} or {setApprovalForAll}.
1032      * - If `to` refers to a smart contract, it must implement
1033      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1034      *
1035      * Emits a {Transfer} event.
1036      */
1037     function safeTransferFrom(
1038         address from,
1039         address to,
1040         uint256 tokenId,
1041         bytes memory _data
1042     ) public payable virtual override {
1043         transferFrom(from, to, tokenId);
1044         if (to.code.length != 0)
1045             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1046                 revert TransferToNonERC721ReceiverImplementer();
1047             }
1048     }
1049 
1050     /**
1051      * @dev Hook that is called before a set of serially-ordered token IDs
1052      * are about to be transferred. This includes minting.
1053      * And also called before burning one token.
1054      *
1055      * `startTokenId` - the first token ID to be transferred.
1056      * `quantity` - the amount to be transferred.
1057      *
1058      * Calling conditions:
1059      *
1060      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1061      * transferred to `to`.
1062      * - When `from` is zero, `tokenId` will be minted for `to`.
1063      * - When `to` is zero, `tokenId` will be burned by `from`.
1064      * - `from` and `to` are never both zero.
1065      */
1066     function _beforeTokenTransfers(
1067         address from,
1068         address to,
1069         uint256 startTokenId,
1070         uint256 quantity
1071     ) internal virtual {}
1072 
1073     /**
1074      * @dev Hook that is called after a set of serially-ordered token IDs
1075      * have been transferred. This includes minting.
1076      * And also called after one token has been burned.
1077      *
1078      * `startTokenId` - the first token ID to be transferred.
1079      * `quantity` - the amount to be transferred.
1080      *
1081      * Calling conditions:
1082      *
1083      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1084      * transferred to `to`.
1085      * - When `from` is zero, `tokenId` has been minted for `to`.
1086      * - When `to` is zero, `tokenId` has been burned by `from`.
1087      * - `from` and `to` are never both zero.
1088      */
1089     function _afterTokenTransfers(
1090         address from,
1091         address to,
1092         uint256 startTokenId,
1093         uint256 quantity
1094     ) internal virtual {}
1095 
1096     /**
1097      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1098      *
1099      * `from` - Previous owner of the given token ID.
1100      * `to` - Target address that will receive the token.
1101      * `tokenId` - Token ID to be transferred.
1102      * `_data` - Optional data to send along with the call.
1103      *
1104      * Returns whether the call correctly returned the expected magic value.
1105      */
1106     function _checkContractOnERC721Received(
1107         address from,
1108         address to,
1109         uint256 tokenId,
1110         bytes memory _data
1111     ) private returns (bool) {
1112         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1113             bytes4 retval
1114         ) {
1115             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1116         } catch (bytes memory reason) {
1117             if (reason.length == 0) {
1118                 revert TransferToNonERC721ReceiverImplementer();
1119             } else {
1120                 assembly {
1121                     revert(add(32, reason), mload(reason))
1122                 }
1123             }
1124         }
1125     }
1126 
1127     // =============================================================
1128     //                        MINT OPERATIONS
1129     // =============================================================
1130 
1131     /**
1132      * @dev Mints `quantity` tokens and transfers them to `to`.
1133      *
1134      * Requirements:
1135      *
1136      * - `to` cannot be the zero address.
1137      * - `quantity` must be greater than 0.
1138      *
1139      * Emits a {Transfer} event for each mint.
1140      */
1141     function _mint(address to, uint256 quantity) internal virtual {
1142         uint256 startTokenId = _currentIndex;
1143         if (quantity == 0) revert MintZeroQuantity();
1144 
1145         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1146 
1147         // Overflows are incredibly unrealistic.
1148         // `balance` and `numberMinted` have a maximum limit of 2**64.
1149         // `tokenId` has a maximum limit of 2**256.
1150         unchecked {
1151             // Updates:
1152             // - `balance += quantity`.
1153             // - `numberMinted += quantity`.
1154             //
1155             // We can directly add to the `balance` and `numberMinted`.
1156             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1157 
1158             // Updates:
1159             // - `address` to the owner.
1160             // - `startTimestamp` to the timestamp of minting.
1161             // - `burned` to `false`.
1162             // - `nextInitialized` to `quantity == 1`.
1163             _packedOwnerships[startTokenId] = _packOwnershipData(
1164                 to,
1165                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1166             );
1167 
1168             uint256 toMasked;
1169             uint256 end = startTokenId + quantity;
1170 
1171             // Use assembly to loop and emit the `Transfer` event for gas savings.
1172             // The duplicated `log4` removes an extra check and reduces stack juggling.
1173             // The assembly, together with the surrounding Solidity code, have been
1174             // delicately arranged to nudge the compiler into producing optimized opcodes.
1175             assembly {
1176                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1177                 toMasked := and(to, _BITMASK_ADDRESS)
1178                 // Emit the `Transfer` event.
1179                 log4(
1180                     0, // Start of data (0, since no data).
1181                     0, // End of data (0, since no data).
1182                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1183                     0, // `address(0)`.
1184                     toMasked, // `to`.
1185                     startTokenId // `tokenId`.
1186                 )
1187 
1188                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1189                 // that overflows uint256 will make the loop run out of gas.
1190                 // The compiler will optimize the `iszero` away for performance.
1191                 for {
1192                     let tokenId := add(startTokenId, 1)
1193                 } iszero(eq(tokenId, end)) {
1194                     tokenId := add(tokenId, 1)
1195                 } {
1196                     // Emit the `Transfer` event. Similar to above.
1197                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1198                 }
1199             }
1200             if (toMasked == 0) revert MintToZeroAddress();
1201 
1202             _currentIndex = end;
1203         }
1204         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1205     }
1206 
1207     /**
1208      * @dev Mints `quantity` tokens and transfers them to `to`.
1209      *
1210      * This function is intended for efficient minting only during contract creation.
1211      *
1212      * It emits only one {ConsecutiveTransfer} as defined in
1213      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1214      * instead of a sequence of {Transfer} event(s).
1215      *
1216      * Calling this function outside of contract creation WILL make your contract
1217      * non-compliant with the ERC721 standard.
1218      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1219      * {ConsecutiveTransfer} event is only permissible during contract creation.
1220      *
1221      * Requirements:
1222      *
1223      * - `to` cannot be the zero address.
1224      * - `quantity` must be greater than 0.
1225      *
1226      * Emits a {ConsecutiveTransfer} event.
1227      */
1228     function _mintERC2309(address to, uint256 quantity) internal virtual {
1229         uint256 startTokenId = _currentIndex;
1230         if (to == address(0)) revert MintToZeroAddress();
1231         if (quantity == 0) revert MintZeroQuantity();
1232         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1233 
1234         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1235 
1236         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1237         unchecked {
1238             // Updates:
1239             // - `balance += quantity`.
1240             // - `numberMinted += quantity`.
1241             //
1242             // We can directly add to the `balance` and `numberMinted`.
1243             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1244 
1245             // Updates:
1246             // - `address` to the owner.
1247             // - `startTimestamp` to the timestamp of minting.
1248             // - `burned` to `false`.
1249             // - `nextInitialized` to `quantity == 1`.
1250             _packedOwnerships[startTokenId] = _packOwnershipData(
1251                 to,
1252                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1253             );
1254 
1255             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1256 
1257             _currentIndex = startTokenId + quantity;
1258         }
1259         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1260     }
1261 
1262     /**
1263      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1264      *
1265      * Requirements:
1266      *
1267      * - If `to` refers to a smart contract, it must implement
1268      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1269      * - `quantity` must be greater than 0.
1270      *
1271      * See {_mint}.
1272      *
1273      * Emits a {Transfer} event for each mint.
1274      */
1275     function _safeMint(
1276         address to,
1277         uint256 quantity,
1278         bytes memory _data
1279     ) internal virtual {
1280         _mint(to, quantity);
1281 
1282         unchecked {
1283             if (to.code.length != 0) {
1284                 uint256 end = _currentIndex;
1285                 uint256 index = end - quantity;
1286                 do {
1287                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1288                         revert TransferToNonERC721ReceiverImplementer();
1289                     }
1290                 } while (index < end);
1291                 // Reentrancy protection.
1292                 if (_currentIndex != end) revert();
1293             }
1294         }
1295     }
1296 
1297     /**
1298      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1299      */
1300     function _safeMint(address to, uint256 quantity) internal virtual {
1301         _safeMint(to, quantity, '');
1302     }
1303 
1304     // =============================================================
1305     //                        BURN OPERATIONS
1306     // =============================================================
1307 
1308     /**
1309      * @dev Equivalent to `_burn(tokenId, false)`.
1310      */
1311     function _burn(uint256 tokenId) internal virtual {
1312         _burn(tokenId, false);
1313     }
1314 
1315     /**
1316      * @dev Destroys `tokenId`.
1317      * The approval is cleared when the token is burned.
1318      *
1319      * Requirements:
1320      *
1321      * - `tokenId` must exist.
1322      *
1323      * Emits a {Transfer} event.
1324      */
1325     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1326         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1327 
1328         address from = address(uint160(prevOwnershipPacked));
1329 
1330         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1331 
1332         if (approvalCheck) {
1333             // The nested ifs save around 20+ gas over a compound boolean condition.
1334             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1335                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1336         }
1337 
1338         _beforeTokenTransfers(from, address(0), tokenId, 1);
1339 
1340         // Clear approvals from the previous owner.
1341         assembly {
1342             if approvedAddress {
1343                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1344                 sstore(approvedAddressSlot, 0)
1345             }
1346         }
1347 
1348         // Underflow of the sender's balance is impossible because we check for
1349         // ownership above and the recipient's balance can't realistically overflow.
1350         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1351         unchecked {
1352             // Updates:
1353             // - `balance -= 1`.
1354             // - `numberBurned += 1`.
1355             //
1356             // We can directly decrement the balance, and increment the number burned.
1357             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1358             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1359 
1360             // Updates:
1361             // - `address` to the last owner.
1362             // - `startTimestamp` to the timestamp of burning.
1363             // - `burned` to `true`.
1364             // - `nextInitialized` to `true`.
1365             _packedOwnerships[tokenId] = _packOwnershipData(
1366                 from,
1367                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1368             );
1369 
1370             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1371             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1372                 uint256 nextTokenId = tokenId + 1;
1373                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1374                 if (_packedOwnerships[nextTokenId] == 0) {
1375                     // If the next slot is within bounds.
1376                     if (nextTokenId != _currentIndex) {
1377                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1378                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1379                     }
1380                 }
1381             }
1382         }
1383 
1384         emit Transfer(from, address(0), tokenId);
1385         _afterTokenTransfers(from, address(0), tokenId, 1);
1386 
1387         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1388         unchecked {
1389             _burnCounter++;
1390         }
1391     }
1392 
1393     // =============================================================
1394     //                     EXTRA DATA OPERATIONS
1395     // =============================================================
1396 
1397     /**
1398      * @dev Directly sets the extra data for the ownership data `index`.
1399      */
1400     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1401         uint256 packed = _packedOwnerships[index];
1402         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1403         uint256 extraDataCasted;
1404         // Cast `extraData` with assembly to avoid redundant masking.
1405         assembly {
1406             extraDataCasted := extraData
1407         }
1408         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1409         _packedOwnerships[index] = packed;
1410     }
1411 
1412     /**
1413      * @dev Called during each token transfer to set the 24bit `extraData` field.
1414      * Intended to be overridden by the cosumer contract.
1415      *
1416      * `previousExtraData` - the value of `extraData` before transfer.
1417      *
1418      * Calling conditions:
1419      *
1420      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1421      * transferred to `to`.
1422      * - When `from` is zero, `tokenId` will be minted for `to`.
1423      * - When `to` is zero, `tokenId` will be burned by `from`.
1424      * - `from` and `to` are never both zero.
1425      */
1426     function _extraData(
1427         address from,
1428         address to,
1429         uint24 previousExtraData
1430     ) internal view virtual returns (uint24) {}
1431 
1432     /**
1433      * @dev Returns the next extra data for the packed ownership data.
1434      * The returned result is shifted into position.
1435      */
1436     function _nextExtraData(
1437         address from,
1438         address to,
1439         uint256 prevOwnershipPacked
1440     ) private view returns (uint256) {
1441         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1442         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1443     }
1444 
1445     // =============================================================
1446     //                       OTHER OPERATIONS
1447     // =============================================================
1448 
1449     /**
1450      * @dev Returns the message sender (defaults to `msg.sender`).
1451      *
1452      * If you are writing GSN compatible contracts, you need to override this function.
1453      */
1454     function _msgSenderERC721A() internal view virtual returns (address) {
1455         return msg.sender;
1456     }
1457 
1458     /**
1459      * @dev Converts a uint256 to its ASCII string decimal representation.
1460      */
1461     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1462         assembly {
1463             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1464             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1465             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1466             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1467             let m := add(mload(0x40), 0xa0)
1468             // Update the free memory pointer to allocate.
1469             mstore(0x40, m)
1470             // Assign the `str` to the end.
1471             str := sub(m, 0x20)
1472             // Zeroize the slot after the string.
1473             mstore(str, 0)
1474 
1475             // Cache the end of the memory to calculate the length later.
1476             let end := str
1477 
1478             // We write the string from rightmost digit to leftmost digit.
1479             // The following is essentially a do-while loop that also handles the zero case.
1480             // prettier-ignore
1481             for { let temp := value } 1 {} {
1482                 str := sub(str, 1)
1483                 // Write the character to the pointer.
1484                 // The ASCII index of the '0' character is 48.
1485                 mstore8(str, add(48, mod(temp, 10)))
1486                 // Keep dividing `temp` until zero.
1487                 temp := div(temp, 10)
1488                 // prettier-ignore
1489                 if iszero(temp) { break }
1490             }
1491 
1492             let length := sub(end, str)
1493             // Move the pointer 32 bytes leftwards to make room for the length.
1494             str := sub(str, 0x20)
1495             // Store the length.
1496             mstore(str, length)
1497         }
1498     }
1499 }
1500 
1501 // SPDX-License-Identifier: MIT
1502 
1503 contract KOSMONFT is ERC721A, Ownable, Pausable {
1504   string public baseURI = "ipfs://bafybeidre74aqtyco3mpslcssxopznbkrs6imj2l5hniodq3lat3a7eakq/";
1505   uint256 public cost = 0.03 ether;
1506   uint256 public maxSupply = 5555;
1507   uint256 public maxMintAmount = 6;
1508   uint256 public nftPerCollectorPassLimit = 6;
1509   uint256 public nftPerWhitelistLimit = 2;
1510   uint256 public nftPerPublicLimit = 1;
1511 
1512   bool public onlyWhitelisted = true;
1513   mapping (address => bool) public collectorPassAddresses;
1514   mapping (address => bool) public whitelistedAddresses;
1515   mapping(address => uint256) public addressMintedBalance;
1516 
1517   event NewTokenURI(string);
1518 
1519   constructor() ERC721A("FULL METAL RABBIT - KOSMO", "FMRK") {}
1520 
1521   // internal
1522   function _baseURI() internal view virtual override returns (string memory) {
1523     return baseURI;
1524   }
1525 
1526   function _startTokenId() internal pure override returns (uint256) {
1527     return 1;
1528   } 
1529 
1530   // public
1531   function mint(uint256 _mintAmount) public payable {
1532     require(!paused(), "the contract is paused");
1533     uint256 supply = totalSupply();
1534     require(_mintAmount > 0, "need to mint at least 1 NFT");
1535     require(_mintAmount <= maxMintAmount, "max mint amount per session exceeded");
1536     require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
1537   
1538     if (msg.sender != owner()) {
1539       uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1540 
1541       if (onlyWhitelisted == true) {
1542         if (collectorPassAddresses[msg.sender]) {
1543           require(ownerMintedCount + _mintAmount <= nftPerCollectorPassLimit, "max NFT per Collector address exceeded");
1544         } else if (whitelistedAddresses[msg.sender]) {
1545           require(ownerMintedCount + _mintAmount <= nftPerWhitelistLimit, "max NFT per Whitelisted address exceeded");
1546         } else {
1547           require(whitelistedAddresses[msg.sender], "user is not whitelisted");
1548         }
1549       } else {
1550         require(ownerMintedCount + _mintAmount <= nftPerPublicLimit, "max NFT per address exceeded");
1551       }
1552 
1553       require(msg.value >= cost * _mintAmount, "insufficient funds");
1554     }
1555 
1556     addressMintedBalance[msg.sender] += _mintAmount;
1557     _safeMint(msg.sender, _mintAmount);
1558   }
1559 
1560   function mintReserved(address to, uint8 amount) external onlyOwner {
1561     require(amount > 0, "No amount specified");
1562     uint256 supply = totalSupply();
1563     require(supply + amount <= maxSupply, "max NFT limit exceeded");
1564     _safeMint(to, amount);
1565     addressMintedBalance[to] += amount;
1566   }
1567 
1568   function mintReservedList(address[] calldata addresses, uint8 amount) external onlyOwner {
1569     require(amount > 0, "No amount specified");
1570     uint256 supply = totalSupply();
1571     require(supply + (amount * addresses.length) <= maxSupply, "max NFT limit exceeded");
1572 
1573     for (uint256 i = 0; i < addresses.length; i++) {
1574       _safeMint(addresses[i], amount);
1575       addressMintedBalance[addresses[i]] += amount;
1576     }
1577   }
1578 
1579   function setNewURI(string memory _newURI) external onlyOwner {
1580     baseURI = _newURI;
1581     emit NewTokenURI(_newURI);
1582   }
1583 
1584   function setCost(uint256 _newCost) public onlyOwner {
1585     cost = _newCost;
1586   }
1587 
1588   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1589     maxMintAmount = _newmaxMintAmount;
1590   }
1591 
1592   function setNftPerCollectorPassLimit(uint256 _limit) public onlyOwner {
1593     nftPerCollectorPassLimit = _limit;
1594   }
1595 
1596   function setNftPerWhitelistLimit(uint256 _limit) public onlyOwner {
1597     nftPerWhitelistLimit = _limit;
1598   }
1599 
1600   function setNftPerPublicLimit(uint256 _limit) public onlyOwner {
1601     nftPerPublicLimit = _limit;
1602   }
1603 
1604   function pause() external onlyOwner {
1605     _pause();
1606   }
1607 
1608   function unpause() external onlyOwner {
1609     _unpause();
1610   }
1611 
1612   function setOnlyWhitelisted(bool _state) public onlyOwner {
1613     onlyWhitelisted = _state;
1614   }
1615 
1616   function endOnlyWhitelisted() public onlyOwner {
1617     onlyWhitelisted = false;
1618   }
1619 
1620   function collectorPassAddreses(address[] calldata addresses, bool isAllow) public onlyOwner {
1621     for (uint256 i = 0; i < addresses.length; i++) {
1622       collectorPassAddresses[addresses[i]] = isAllow;
1623     }
1624   }
1625 
1626   function whitelistAddreses(address[] calldata addresses, bool isAllow) public onlyOwner {
1627     for (uint256 i = 0; i < addresses.length; i++) {
1628       whitelistedAddresses[addresses[i]] = isAllow;
1629     }
1630   }
1631 
1632   function withdraw() public payable onlyOwner {
1633     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1634     require(os);
1635   }
1636 }