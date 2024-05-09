1 // SPDX-License-Identifier: MIT
2 
3 // File: @rari-capital/solmate/src/auth/Owned.sol
4 
5 
6 pragma solidity >=0.8.0;
7 
8 /// @notice Simple single owner authorization mixin.
9 /// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/auth/Owned.sol)
10 abstract contract Owned {
11     /*//////////////////////////////////////////////////////////////
12                                  EVENTS
13     //////////////////////////////////////////////////////////////*/
14 
15     event OwnerUpdated(address indexed user, address indexed newOwner);
16 
17     /*//////////////////////////////////////////////////////////////
18                             OWNERSHIP STORAGE
19     //////////////////////////////////////////////////////////////*/
20 
21     address public owner;
22 
23     modifier onlyOwner() virtual {
24         require(msg.sender == owner, "UNAUTHORIZED");
25 
26         _;
27     }
28 
29     /*//////////////////////////////////////////////////////////////
30                                CONSTRUCTOR
31     //////////////////////////////////////////////////////////////*/
32 
33     constructor(address _owner) {
34         owner = _owner;
35 
36         emit OwnerUpdated(address(0), _owner);
37     }
38 
39     /*//////////////////////////////////////////////////////////////
40                              OWNERSHIP LOGIC
41     //////////////////////////////////////////////////////////////*/
42 
43     function setOwner(address newOwner) public virtual onlyOwner {
44         owner = newOwner;
45 
46         emit OwnerUpdated(msg.sender, newOwner);
47     }
48 }
49 
50 // File: erc721a/contracts/IERC721A.sol
51 
52 
53 // ERC721A Contracts v4.2.0
54 // Creator: Chiru Labs
55 
56 pragma solidity ^0.8.4;
57 
58 /**
59  * @dev Interface of ERC721A.
60  */
61 interface IERC721A {
62     /**
63      * The caller must own the token or be an approved operator.
64      */
65     error ApprovalCallerNotOwnerNorApproved();
66 
67     /**
68      * The token does not exist.
69      */
70     error ApprovalQueryForNonexistentToken();
71 
72     /**
73      * The caller cannot approve to their own address.
74      */
75     error ApproveToCaller();
76 
77     /**
78      * Cannot query the balance for the zero address.
79      */
80     error BalanceQueryForZeroAddress();
81 
82     /**
83      * Cannot mint to the zero address.
84      */
85     error MintToZeroAddress();
86 
87     /**
88      * The quantity of tokens minted must be more than zero.
89      */
90     error MintZeroQuantity();
91 
92     /**
93      * The token does not exist.
94      */
95     error OwnerQueryForNonexistentToken();
96 
97     /**
98      * The caller must own the token or be an approved operator.
99      */
100     error TransferCallerNotOwnerNorApproved();
101 
102     /**
103      * The token must be owned by `from`.
104      */
105     error TransferFromIncorrectOwner();
106 
107     /**
108      * Cannot safely transfer to a contract that does not implement the
109      * ERC721Receiver interface.
110      */
111     error TransferToNonERC721ReceiverImplementer();
112 
113     /**
114      * Cannot transfer to the zero address.
115      */
116     error TransferToZeroAddress();
117 
118     /**
119      * The token does not exist.
120      */
121     error URIQueryForNonexistentToken();
122 
123     /**
124      * The `quantity` minted with ERC2309 exceeds the safety limit.
125      */
126     error MintERC2309QuantityExceedsLimit();
127 
128     /**
129      * The `extraData` cannot be set on an unintialized ownership slot.
130      */
131     error OwnershipNotInitializedForExtraData();
132 
133     // =============================================================
134     //                            STRUCTS
135     // =============================================================
136 
137     struct TokenOwnership {
138         // The address of the owner.
139         address addr;
140         // Stores the start time of ownership with minimal overhead for tokenomics.
141         uint64 startTimestamp;
142         // Whether the token has been burned.
143         bool burned;
144         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
145         uint24 extraData;
146     }
147 
148     // =============================================================
149     //                         TOKEN COUNTERS
150     // =============================================================
151 
152     /**
153      * @dev Returns the total number of tokens in existence.
154      * Burned tokens will reduce the count.
155      * To get the total number of tokens minted, please see {_totalMinted}.
156      */
157     function totalSupply() external view returns (uint256);
158 
159     // =============================================================
160     //                            IERC165
161     // =============================================================
162 
163     /**
164      * @dev Returns true if this contract implements the interface defined by
165      * `interfaceId`. See the corresponding
166      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
167      * to learn more about how these ids are created.
168      *
169      * This function call must use less than 30000 gas.
170      */
171     function supportsInterface(bytes4 interfaceId) external view returns (bool);
172 
173     // =============================================================
174     //                            IERC721
175     // =============================================================
176 
177     /**
178      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
179      */
180     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
181 
182     /**
183      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
184      */
185     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
186 
187     /**
188      * @dev Emitted when `owner` enables or disables
189      * (`approved`) `operator` to manage all of its assets.
190      */
191     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
192 
193     /**
194      * @dev Returns the number of tokens in `owner`'s account.
195      */
196     function balanceOf(address owner) external view returns (uint256 balance);
197 
198     /**
199      * @dev Returns the owner of the `tokenId` token.
200      *
201      * Requirements:
202      *
203      * - `tokenId` must exist.
204      */
205     function ownerOf(uint256 tokenId) external view returns (address owner);
206 
207     /**
208      * @dev Safely transfers `tokenId` token from `from` to `to`,
209      * checking first that contract recipients are aware of the ERC721 protocol
210      * to prevent tokens from being forever locked.
211      *
212      * Requirements:
213      *
214      * - `from` cannot be the zero address.
215      * - `to` cannot be the zero address.
216      * - `tokenId` token must exist and be owned by `from`.
217      * - If the caller is not `from`, it must be have been allowed to move
218      * this token by either {approve} or {setApprovalForAll}.
219      * - If `to` refers to a smart contract, it must implement
220      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
221      *
222      * Emits a {Transfer} event.
223      */
224     function safeTransferFrom(
225         address from,
226         address to,
227         uint256 tokenId,
228         bytes calldata data
229     ) external;
230 
231     /**
232      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
233      */
234     function safeTransferFrom(
235         address from,
236         address to,
237         uint256 tokenId
238     ) external;
239 
240     /**
241      * @dev Transfers `tokenId` from `from` to `to`.
242      *
243      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
244      * whenever possible.
245      *
246      * Requirements:
247      *
248      * - `from` cannot be the zero address.
249      * - `to` cannot be the zero address.
250      * - `tokenId` token must be owned by `from`.
251      * - If the caller is not `from`, it must be approved to move this token
252      * by either {approve} or {setApprovalForAll}.
253      *
254      * Emits a {Transfer} event.
255      */
256     function transferFrom(
257         address from,
258         address to,
259         uint256 tokenId
260     ) external;
261 
262     /**
263      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
264      * The approval is cleared when the token is transferred.
265      *
266      * Only a single account can be approved at a time, so approving the
267      * zero address clears previous approvals.
268      *
269      * Requirements:
270      *
271      * - The caller must own the token or be an approved operator.
272      * - `tokenId` must exist.
273      *
274      * Emits an {Approval} event.
275      */
276     function approve(address to, uint256 tokenId) external;
277 
278     /**
279      * @dev Approve or remove `operator` as an operator for the caller.
280      * Operators can call {transferFrom} or {safeTransferFrom}
281      * for any token owned by the caller.
282      *
283      * Requirements:
284      *
285      * - The `operator` cannot be the caller.
286      *
287      * Emits an {ApprovalForAll} event.
288      */
289     function setApprovalForAll(address operator, bool _approved) external;
290 
291     /**
292      * @dev Returns the account approved for `tokenId` token.
293      *
294      * Requirements:
295      *
296      * - `tokenId` must exist.
297      */
298     function getApproved(uint256 tokenId) external view returns (address operator);
299 
300     /**
301      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
302      *
303      * See {setApprovalForAll}.
304      */
305     function isApprovedForAll(address owner, address operator) external view returns (bool);
306 
307     // =============================================================
308     //                        IERC721Metadata
309     // =============================================================
310 
311     /**
312      * @dev Returns the token collection name.
313      */
314     function name() external view returns (string memory);
315 
316     /**
317      * @dev Returns the token collection symbol.
318      */
319     function symbol() external view returns (string memory);
320 
321     /**
322      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
323      */
324     function tokenURI(uint256 tokenId) external view returns (string memory);
325 
326     // =============================================================
327     //                           IERC2309
328     // =============================================================
329 
330     /**
331      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
332      * (inclusive) is transferred from `from` to `to`, as defined in the
333      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
334      *
335      * See {_mintERC2309} for more details.
336      */
337     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
338 }
339 
340 // File: erc721a/contracts/extensions/IERC721AQueryable.sol
341 
342 
343 // ERC721A Contracts v4.2.0
344 // Creator: Chiru Labs
345 
346 pragma solidity ^0.8.4;
347 
348 
349 /**
350  * @dev Interface of ERC721AQueryable.
351  */
352 interface IERC721AQueryable is IERC721A {
353     /**
354      * Invalid query range (`start` >= `stop`).
355      */
356     error InvalidQueryRange();
357 
358     /**
359      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
360      *
361      * If the `tokenId` is out of bounds:
362      *
363      * - `addr = address(0)`
364      * - `startTimestamp = 0`
365      * - `burned = false`
366      * - `extraData = 0`
367      *
368      * If the `tokenId` is burned:
369      *
370      * - `addr = <Address of owner before token was burned>`
371      * - `startTimestamp = <Timestamp when token was burned>`
372      * - `burned = true`
373      * - `extraData = <Extra data when token was burned>`
374      *
375      * Otherwise:
376      *
377      * - `addr = <Address of owner>`
378      * - `startTimestamp = <Timestamp of start of ownership>`
379      * - `burned = false`
380      * - `extraData = <Extra data at start of ownership>`
381      */
382     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
383 
384     /**
385      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
386      * See {ERC721AQueryable-explicitOwnershipOf}
387      */
388     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
389 
390     /**
391      * @dev Returns an array of token IDs owned by `owner`,
392      * in the range [`start`, `stop`)
393      * (i.e. `start <= tokenId < stop`).
394      *
395      * This function allows for tokens to be queried if the collection
396      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
397      *
398      * Requirements:
399      *
400      * - `start < stop`
401      */
402     function tokensOfOwnerIn(
403         address owner,
404         uint256 start,
405         uint256 stop
406     ) external view returns (uint256[] memory);
407 
408     /**
409      * @dev Returns an array of token IDs owned by `owner`.
410      *
411      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
412      * It is meant to be called off-chain.
413      *
414      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
415      * multiple smaller scans if the collection is large enough to cause
416      * an out-of-gas error (10K collections should be fine).
417      */
418     function tokensOfOwner(address owner) external view returns (uint256[] memory);
419 }
420 
421 // File: erc721a/contracts/ERC721A.sol
422 
423 
424 // ERC721A Contracts v4.2.0
425 // Creator: Chiru Labs
426 
427 pragma solidity ^0.8.4;
428 
429 
430 /**
431  * @dev Interface of ERC721 token receiver.
432  */
433 interface ERC721A__IERC721Receiver {
434     function onERC721Received(
435         address operator,
436         address from,
437         uint256 tokenId,
438         bytes calldata data
439     ) external returns (bytes4);
440 }
441 
442 /**
443  * @title ERC721A
444  *
445  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
446  * Non-Fungible Token Standard, including the Metadata extension.
447  * Optimized for lower gas during batch mints.
448  *
449  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
450  * starting from `_startTokenId()`.
451  *
452  * Assumptions:
453  *
454  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
455  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
456  */
457 contract ERC721A is IERC721A {
458     // Reference type for token approval.
459     struct TokenApprovalRef {
460         address value;
461     }
462 
463     // =============================================================
464     //                           CONSTANTS
465     // =============================================================
466 
467     // Mask of an entry in packed address data.
468     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
469 
470     // The bit position of `numberMinted` in packed address data.
471     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
472 
473     // The bit position of `numberBurned` in packed address data.
474     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
475 
476     // The bit position of `aux` in packed address data.
477     uint256 private constant _BITPOS_AUX = 192;
478 
479     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
480     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
481 
482     // The bit position of `startTimestamp` in packed ownership.
483     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
484 
485     // The bit mask of the `burned` bit in packed ownership.
486     uint256 private constant _BITMASK_BURNED = 1 << 224;
487 
488     // The bit position of the `nextInitialized` bit in packed ownership.
489     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
490 
491     // The bit mask of the `nextInitialized` bit in packed ownership.
492     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
493 
494     // The bit position of `extraData` in packed ownership.
495     uint256 private constant _BITPOS_EXTRA_DATA = 232;
496 
497     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
498     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
499 
500     // The mask of the lower 160 bits for addresses.
501     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
502 
503     // The maximum `quantity` that can be minted with {_mintERC2309}.
504     // This limit is to prevent overflows on the address data entries.
505     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
506     // is required to cause an overflow, which is unrealistic.
507     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
508 
509     // The `Transfer` event signature is given by:
510     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
511     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
512         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
513 
514     // =============================================================
515     //                            STORAGE
516     // =============================================================
517 
518     // The next token ID to be minted.
519     uint256 private _currentIndex;
520 
521     // The number of tokens burned.
522     uint256 private _burnCounter;
523 
524     // Token name
525     string private _name;
526 
527     // Token symbol
528     string private _symbol;
529 
530     // Mapping from token ID to ownership details
531     // An empty struct value does not necessarily mean the token is unowned.
532     // See {_packedOwnershipOf} implementation for details.
533     //
534     // Bits Layout:
535     // - [0..159]   `addr`
536     // - [160..223] `startTimestamp`
537     // - [224]      `burned`
538     // - [225]      `nextInitialized`
539     // - [232..255] `extraData`
540     mapping(uint256 => uint256) private _packedOwnerships;
541 
542     // Mapping owner address to address data.
543     //
544     // Bits Layout:
545     // - [0..63]    `balance`
546     // - [64..127]  `numberMinted`
547     // - [128..191] `numberBurned`
548     // - [192..255] `aux`
549     mapping(address => uint256) private _packedAddressData;
550 
551     // Mapping from token ID to approved address.
552     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
553 
554     // Mapping from owner to operator approvals
555     mapping(address => mapping(address => bool)) private _operatorApprovals;
556 
557     // =============================================================
558     //                          CONSTRUCTOR
559     // =============================================================
560 
561     constructor(string memory name_, string memory symbol_) {
562         _name = name_;
563         _symbol = symbol_;
564         _currentIndex = _startTokenId();
565     }
566 
567     // =============================================================
568     //                   TOKEN COUNTING OPERATIONS
569     // =============================================================
570 
571     /**
572      * @dev Returns the starting token ID.
573      * To change the starting token ID, please override this function.
574      */
575     function _startTokenId() internal view virtual returns (uint256) {
576         return 0;
577     }
578 
579     /**
580      * @dev Returns the next token ID to be minted.
581      */
582     function _nextTokenId() internal view virtual returns (uint256) {
583         return _currentIndex;
584     }
585 
586     /**
587      * @dev Returns the total number of tokens in existence.
588      * Burned tokens will reduce the count.
589      * To get the total number of tokens minted, please see {_totalMinted}.
590      */
591     function totalSupply() public view virtual override returns (uint256) {
592         // Counter underflow is impossible as _burnCounter cannot be incremented
593         // more than `_currentIndex - _startTokenId()` times.
594         unchecked {
595             return _currentIndex - _burnCounter - _startTokenId();
596         }
597     }
598 
599     /**
600      * @dev Returns the total amount of tokens minted in the contract.
601      */
602     function _totalMinted() internal view virtual returns (uint256) {
603         // Counter underflow is impossible as `_currentIndex` does not decrement,
604         // and it is initialized to `_startTokenId()`.
605         unchecked {
606             return _currentIndex - _startTokenId();
607         }
608     }
609 
610     /**
611      * @dev Returns the total number of tokens burned.
612      */
613     function _totalBurned() internal view virtual returns (uint256) {
614         return _burnCounter;
615     }
616 
617     // =============================================================
618     //                    ADDRESS DATA OPERATIONS
619     // =============================================================
620 
621     /**
622      * @dev Returns the number of tokens in `owner`'s account.
623      */
624     function balanceOf(address owner) public view virtual override returns (uint256) {
625         if (owner == address(0)) revert BalanceQueryForZeroAddress();
626         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
627     }
628 
629     /**
630      * Returns the number of tokens minted by `owner`.
631      */
632     function _numberMinted(address owner) internal view returns (uint256) {
633         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
634     }
635 
636     /**
637      * Returns the number of tokens burned by or on behalf of `owner`.
638      */
639     function _numberBurned(address owner) internal view returns (uint256) {
640         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
641     }
642 
643     /**
644      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
645      */
646     function _getAux(address owner) internal view returns (uint64) {
647         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
648     }
649 
650     /**
651      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
652      * If there are multiple variables, please pack them into a uint64.
653      */
654     function _setAux(address owner, uint64 aux) internal virtual {
655         uint256 packed = _packedAddressData[owner];
656         uint256 auxCasted;
657         // Cast `aux` with assembly to avoid redundant masking.
658         assembly {
659             auxCasted := aux
660         }
661         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
662         _packedAddressData[owner] = packed;
663     }
664 
665     // =============================================================
666     //                            IERC165
667     // =============================================================
668 
669     /**
670      * @dev Returns true if this contract implements the interface defined by
671      * `interfaceId`. See the corresponding
672      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
673      * to learn more about how these ids are created.
674      *
675      * This function call must use less than 30000 gas.
676      */
677     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
678         // The interface IDs are constants representing the first 4 bytes
679         // of the XOR of all function selectors in the interface.
680         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
681         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
682         return
683             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
684             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
685             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
686     }
687 
688     // =============================================================
689     //                        IERC721Metadata
690     // =============================================================
691 
692     /**
693      * @dev Returns the token collection name.
694      */
695     function name() public view virtual override returns (string memory) {
696         return _name;
697     }
698 
699     /**
700      * @dev Returns the token collection symbol.
701      */
702     function symbol() public view virtual override returns (string memory) {
703         return _symbol;
704     }
705 
706     /**
707      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
708      */
709     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
710         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
711 
712         string memory baseURI = _baseURI();
713         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
714     }
715 
716     /**
717      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
718      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
719      * by default, it can be overridden in child contracts.
720      */
721     function _baseURI() internal view virtual returns (string memory) {
722         return '';
723     }
724 
725     // =============================================================
726     //                     OWNERSHIPS OPERATIONS
727     // =============================================================
728 
729     /**
730      * @dev Returns the owner of the `tokenId` token.
731      *
732      * Requirements:
733      *
734      * - `tokenId` must exist.
735      */
736     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
737         return address(uint160(_packedOwnershipOf(tokenId)));
738     }
739 
740     /**
741      * @dev Gas spent here starts off proportional to the maximum mint batch size.
742      * It gradually moves to O(1) as tokens get transferred around over time.
743      */
744     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
745         return _unpackedOwnership(_packedOwnershipOf(tokenId));
746     }
747 
748     /**
749      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
750      */
751     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
752         return _unpackedOwnership(_packedOwnerships[index]);
753     }
754 
755     /**
756      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
757      */
758     function _initializeOwnershipAt(uint256 index) internal virtual {
759         if (_packedOwnerships[index] == 0) {
760             _packedOwnerships[index] = _packedOwnershipOf(index);
761         }
762     }
763 
764     /**
765      * Returns the packed ownership data of `tokenId`.
766      */
767     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
768         uint256 curr = tokenId;
769 
770         unchecked {
771             if (_startTokenId() <= curr)
772                 if (curr < _currentIndex) {
773                     uint256 packed = _packedOwnerships[curr];
774                     // If not burned.
775                     if (packed & _BITMASK_BURNED == 0) {
776                         // Invariant:
777                         // There will always be an initialized ownership slot
778                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
779                         // before an unintialized ownership slot
780                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
781                         // Hence, `curr` will not underflow.
782                         //
783                         // We can directly compare the packed value.
784                         // If the address is zero, packed will be zero.
785                         while (packed == 0) {
786                             packed = _packedOwnerships[--curr];
787                         }
788                         return packed;
789                     }
790                 }
791         }
792         revert OwnerQueryForNonexistentToken();
793     }
794 
795     /**
796      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
797      */
798     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
799         ownership.addr = address(uint160(packed));
800         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
801         ownership.burned = packed & _BITMASK_BURNED != 0;
802         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
803     }
804 
805     /**
806      * @dev Packs ownership data into a single uint256.
807      */
808     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
809         assembly {
810             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
811             owner := and(owner, _BITMASK_ADDRESS)
812             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
813             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
814         }
815     }
816 
817     /**
818      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
819      */
820     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
821         // For branchless setting of the `nextInitialized` flag.
822         assembly {
823             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
824             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
825         }
826     }
827 
828     // =============================================================
829     //                      APPROVAL OPERATIONS
830     // =============================================================
831 
832     /**
833      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
834      * The approval is cleared when the token is transferred.
835      *
836      * Only a single account can be approved at a time, so approving the
837      * zero address clears previous approvals.
838      *
839      * Requirements:
840      *
841      * - The caller must own the token or be an approved operator.
842      * - `tokenId` must exist.
843      *
844      * Emits an {Approval} event.
845      */
846     function approve(address to, uint256 tokenId) public virtual override {
847         address owner = ownerOf(tokenId);
848 
849         if (_msgSenderERC721A() != owner)
850             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
851                 revert ApprovalCallerNotOwnerNorApproved();
852             }
853 
854         _tokenApprovals[tokenId].value = to;
855         emit Approval(owner, to, tokenId);
856     }
857 
858     /**
859      * @dev Returns the account approved for `tokenId` token.
860      *
861      * Requirements:
862      *
863      * - `tokenId` must exist.
864      */
865     function getApproved(uint256 tokenId) public view virtual override returns (address) {
866         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
867 
868         return _tokenApprovals[tokenId].value;
869     }
870 
871     /**
872      * @dev Approve or remove `operator` as an operator for the caller.
873      * Operators can call {transferFrom} or {safeTransferFrom}
874      * for any token owned by the caller.
875      *
876      * Requirements:
877      *
878      * - The `operator` cannot be the caller.
879      *
880      * Emits an {ApprovalForAll} event.
881      */
882     function setApprovalForAll(address operator, bool approved) public virtual override {
883         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
884 
885         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
886         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
887     }
888 
889     /**
890      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
891      *
892      * See {setApprovalForAll}.
893      */
894     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
895         return _operatorApprovals[owner][operator];
896     }
897 
898     /**
899      * @dev Returns whether `tokenId` exists.
900      *
901      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
902      *
903      * Tokens start existing when they are minted. See {_mint}.
904      */
905     function _exists(uint256 tokenId) internal view virtual returns (bool) {
906         return
907             _startTokenId() <= tokenId &&
908             tokenId < _currentIndex && // If within bounds,
909             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
910     }
911 
912     /**
913      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
914      */
915     function _isSenderApprovedOrOwner(
916         address approvedAddress,
917         address owner,
918         address msgSender
919     ) private pure returns (bool result) {
920         assembly {
921             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
922             owner := and(owner, _BITMASK_ADDRESS)
923             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
924             msgSender := and(msgSender, _BITMASK_ADDRESS)
925             // `msgSender == owner || msgSender == approvedAddress`.
926             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
927         }
928     }
929 
930     /**
931      * @dev Returns the storage slot and value for the approved address of `tokenId`.
932      */
933     function _getApprovedSlotAndAddress(uint256 tokenId)
934         private
935         view
936         returns (uint256 approvedAddressSlot, address approvedAddress)
937     {
938         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
939         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
940         assembly {
941             approvedAddressSlot := tokenApproval.slot
942             approvedAddress := sload(approvedAddressSlot)
943         }
944     }
945 
946     // =============================================================
947     //                      TRANSFER OPERATIONS
948     // =============================================================
949 
950     /**
951      * @dev Transfers `tokenId` from `from` to `to`.
952      *
953      * Requirements:
954      *
955      * - `from` cannot be the zero address.
956      * - `to` cannot be the zero address.
957      * - `tokenId` token must be owned by `from`.
958      * - If the caller is not `from`, it must be approved to move this token
959      * by either {approve} or {setApprovalForAll}.
960      *
961      * Emits a {Transfer} event.
962      */
963     function transferFrom(
964         address from,
965         address to,
966         uint256 tokenId
967     ) public virtual override {
968         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
969 
970         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
971 
972         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
973 
974         // The nested ifs save around 20+ gas over a compound boolean condition.
975         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
976             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
977 
978         if (to == address(0)) revert TransferToZeroAddress();
979 
980         _beforeTokenTransfers(from, to, tokenId, 1);
981 
982         // Clear approvals from the previous owner.
983         assembly {
984             if approvedAddress {
985                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
986                 sstore(approvedAddressSlot, 0)
987             }
988         }
989 
990         // Underflow of the sender's balance is impossible because we check for
991         // ownership above and the recipient's balance can't realistically overflow.
992         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
993         unchecked {
994             // We can directly increment and decrement the balances.
995             --_packedAddressData[from]; // Updates: `balance -= 1`.
996             ++_packedAddressData[to]; // Updates: `balance += 1`.
997 
998             // Updates:
999             // - `address` to the next owner.
1000             // - `startTimestamp` to the timestamp of transfering.
1001             // - `burned` to `false`.
1002             // - `nextInitialized` to `true`.
1003             _packedOwnerships[tokenId] = _packOwnershipData(
1004                 to,
1005                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1006             );
1007 
1008             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1009             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1010                 uint256 nextTokenId = tokenId + 1;
1011                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1012                 if (_packedOwnerships[nextTokenId] == 0) {
1013                     // If the next slot is within bounds.
1014                     if (nextTokenId != _currentIndex) {
1015                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1016                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1017                     }
1018                 }
1019             }
1020         }
1021 
1022         emit Transfer(from, to, tokenId);
1023         _afterTokenTransfers(from, to, tokenId, 1);
1024     }
1025 
1026     /**
1027      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1028      */
1029     function safeTransferFrom(
1030         address from,
1031         address to,
1032         uint256 tokenId
1033     ) public virtual override {
1034         safeTransferFrom(from, to, tokenId, '');
1035     }
1036 
1037     /**
1038      * @dev Safely transfers `tokenId` token from `from` to `to`.
1039      *
1040      * Requirements:
1041      *
1042      * - `from` cannot be the zero address.
1043      * - `to` cannot be the zero address.
1044      * - `tokenId` token must exist and be owned by `from`.
1045      * - If the caller is not `from`, it must be approved to move this token
1046      * by either {approve} or {setApprovalForAll}.
1047      * - If `to` refers to a smart contract, it must implement
1048      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1049      *
1050      * Emits a {Transfer} event.
1051      */
1052     function safeTransferFrom(
1053         address from,
1054         address to,
1055         uint256 tokenId,
1056         bytes memory _data
1057     ) public virtual override {
1058         transferFrom(from, to, tokenId);
1059         if (to.code.length != 0)
1060             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1061                 revert TransferToNonERC721ReceiverImplementer();
1062             }
1063     }
1064 
1065     /**
1066      * @dev Hook that is called before a set of serially-ordered token IDs
1067      * are about to be transferred. This includes minting.
1068      * And also called before burning one token.
1069      *
1070      * `startTokenId` - the first token ID to be transferred.
1071      * `quantity` - the amount to be transferred.
1072      *
1073      * Calling conditions:
1074      *
1075      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1076      * transferred to `to`.
1077      * - When `from` is zero, `tokenId` will be minted for `to`.
1078      * - When `to` is zero, `tokenId` will be burned by `from`.
1079      * - `from` and `to` are never both zero.
1080      */
1081     function _beforeTokenTransfers(
1082         address from,
1083         address to,
1084         uint256 startTokenId,
1085         uint256 quantity
1086     ) internal virtual {}
1087 
1088     /**
1089      * @dev Hook that is called after a set of serially-ordered token IDs
1090      * have been transferred. This includes minting.
1091      * And also called after one token has been burned.
1092      *
1093      * `startTokenId` - the first token ID to be transferred.
1094      * `quantity` - the amount to be transferred.
1095      *
1096      * Calling conditions:
1097      *
1098      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1099      * transferred to `to`.
1100      * - When `from` is zero, `tokenId` has been minted for `to`.
1101      * - When `to` is zero, `tokenId` has been burned by `from`.
1102      * - `from` and `to` are never both zero.
1103      */
1104     function _afterTokenTransfers(
1105         address from,
1106         address to,
1107         uint256 startTokenId,
1108         uint256 quantity
1109     ) internal virtual {}
1110 
1111     /**
1112      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1113      *
1114      * `from` - Previous owner of the given token ID.
1115      * `to` - Target address that will receive the token.
1116      * `tokenId` - Token ID to be transferred.
1117      * `_data` - Optional data to send along with the call.
1118      *
1119      * Returns whether the call correctly returned the expected magic value.
1120      */
1121     function _checkContractOnERC721Received(
1122         address from,
1123         address to,
1124         uint256 tokenId,
1125         bytes memory _data
1126     ) private returns (bool) {
1127         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1128             bytes4 retval
1129         ) {
1130             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1131         } catch (bytes memory reason) {
1132             if (reason.length == 0) {
1133                 revert TransferToNonERC721ReceiverImplementer();
1134             } else {
1135                 assembly {
1136                     revert(add(32, reason), mload(reason))
1137                 }
1138             }
1139         }
1140     }
1141 
1142     // =============================================================
1143     //                        MINT OPERATIONS
1144     // =============================================================
1145 
1146     /**
1147      * @dev Mints `quantity` tokens and transfers them to `to`.
1148      *
1149      * Requirements:
1150      *
1151      * - `to` cannot be the zero address.
1152      * - `quantity` must be greater than 0.
1153      *
1154      * Emits a {Transfer} event for each mint.
1155      */
1156     function _mint(address to, uint256 quantity) internal virtual {
1157         uint256 startTokenId = _currentIndex;
1158         if (quantity == 0) revert MintZeroQuantity();
1159 
1160         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1161 
1162         // Overflows are incredibly unrealistic.
1163         // `balance` and `numberMinted` have a maximum limit of 2**64.
1164         // `tokenId` has a maximum limit of 2**256.
1165         unchecked {
1166             // Updates:
1167             // - `balance += quantity`.
1168             // - `numberMinted += quantity`.
1169             //
1170             // We can directly add to the `balance` and `numberMinted`.
1171             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1172 
1173             // Updates:
1174             // - `address` to the owner.
1175             // - `startTimestamp` to the timestamp of minting.
1176             // - `burned` to `false`.
1177             // - `nextInitialized` to `quantity == 1`.
1178             _packedOwnerships[startTokenId] = _packOwnershipData(
1179                 to,
1180                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1181             );
1182 
1183             uint256 toMasked;
1184             uint256 end = startTokenId + quantity;
1185 
1186             // Use assembly to loop and emit the `Transfer` event for gas savings.
1187             assembly {
1188                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1189                 toMasked := and(to, _BITMASK_ADDRESS)
1190                 // Emit the `Transfer` event.
1191                 log4(
1192                     0, // Start of data (0, since no data).
1193                     0, // End of data (0, since no data).
1194                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1195                     0, // `address(0)`.
1196                     toMasked, // `to`.
1197                     startTokenId // `tokenId`.
1198                 )
1199 
1200                 for {
1201                     let tokenId := add(startTokenId, 1)
1202                 } iszero(eq(tokenId, end)) {
1203                     tokenId := add(tokenId, 1)
1204                 } {
1205                     // Emit the `Transfer` event. Similar to above.
1206                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1207                 }
1208             }
1209             if (toMasked == 0) revert MintToZeroAddress();
1210 
1211             _currentIndex = end;
1212         }
1213         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1214     }
1215 
1216     /**
1217      * @dev Mints `quantity` tokens and transfers them to `to`.
1218      *
1219      * This function is intended for efficient minting only during contract creation.
1220      *
1221      * It emits only one {ConsecutiveTransfer} as defined in
1222      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1223      * instead of a sequence of {Transfer} event(s).
1224      *
1225      * Calling this function outside of contract creation WILL make your contract
1226      * non-compliant with the ERC721 standard.
1227      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1228      * {ConsecutiveTransfer} event is only permissible during contract creation.
1229      *
1230      * Requirements:
1231      *
1232      * - `to` cannot be the zero address.
1233      * - `quantity` must be greater than 0.
1234      *
1235      * Emits a {ConsecutiveTransfer} event.
1236      */
1237     function _mintERC2309(address to, uint256 quantity) internal virtual {
1238         uint256 startTokenId = _currentIndex;
1239         if (to == address(0)) revert MintToZeroAddress();
1240         if (quantity == 0) revert MintZeroQuantity();
1241         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1242 
1243         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1244 
1245         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1246         unchecked {
1247             // Updates:
1248             // - `balance += quantity`.
1249             // - `numberMinted += quantity`.
1250             //
1251             // We can directly add to the `balance` and `numberMinted`.
1252             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1253 
1254             // Updates:
1255             // - `address` to the owner.
1256             // - `startTimestamp` to the timestamp of minting.
1257             // - `burned` to `false`.
1258             // - `nextInitialized` to `quantity == 1`.
1259             _packedOwnerships[startTokenId] = _packOwnershipData(
1260                 to,
1261                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1262             );
1263 
1264             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1265 
1266             _currentIndex = startTokenId + quantity;
1267         }
1268         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1269     }
1270 
1271     /**
1272      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1273      *
1274      * Requirements:
1275      *
1276      * - If `to` refers to a smart contract, it must implement
1277      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1278      * - `quantity` must be greater than 0.
1279      *
1280      * See {_mint}.
1281      *
1282      * Emits a {Transfer} event for each mint.
1283      */
1284     function _safeMint(
1285         address to,
1286         uint256 quantity,
1287         bytes memory _data
1288     ) internal virtual {
1289         _mint(to, quantity);
1290 
1291         unchecked {
1292             if (to.code.length != 0) {
1293                 uint256 end = _currentIndex;
1294                 uint256 index = end - quantity;
1295                 do {
1296                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1297                         revert TransferToNonERC721ReceiverImplementer();
1298                     }
1299                 } while (index < end);
1300                 // Reentrancy protection.
1301                 if (_currentIndex != end) revert();
1302             }
1303         }
1304     }
1305 
1306     /**
1307      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1308      */
1309     function _safeMint(address to, uint256 quantity) internal virtual {
1310         _safeMint(to, quantity, '');
1311     }
1312 
1313     // =============================================================
1314     //                        BURN OPERATIONS
1315     // =============================================================
1316 
1317     /**
1318      * @dev Equivalent to `_burn(tokenId, false)`.
1319      */
1320     function _burn(uint256 tokenId) internal virtual {
1321         _burn(tokenId, false);
1322     }
1323 
1324     /**
1325      * @dev Destroys `tokenId`.
1326      * The approval is cleared when the token is burned.
1327      *
1328      * Requirements:
1329      *
1330      * - `tokenId` must exist.
1331      *
1332      * Emits a {Transfer} event.
1333      */
1334     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1335         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1336 
1337         address from = address(uint160(prevOwnershipPacked));
1338 
1339         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1340 
1341         if (approvalCheck) {
1342             // The nested ifs save around 20+ gas over a compound boolean condition.
1343             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1344                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1345         }
1346 
1347         _beforeTokenTransfers(from, address(0), tokenId, 1);
1348 
1349         // Clear approvals from the previous owner.
1350         assembly {
1351             if approvedAddress {
1352                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1353                 sstore(approvedAddressSlot, 0)
1354             }
1355         }
1356 
1357         // Underflow of the sender's balance is impossible because we check for
1358         // ownership above and the recipient's balance can't realistically overflow.
1359         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1360         unchecked {
1361             // Updates:
1362             // - `balance -= 1`.
1363             // - `numberBurned += 1`.
1364             //
1365             // We can directly decrement the balance, and increment the number burned.
1366             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1367             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1368 
1369             // Updates:
1370             // - `address` to the last owner.
1371             // - `startTimestamp` to the timestamp of burning.
1372             // - `burned` to `true`.
1373             // - `nextInitialized` to `true`.
1374             _packedOwnerships[tokenId] = _packOwnershipData(
1375                 from,
1376                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1377             );
1378 
1379             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1380             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1381                 uint256 nextTokenId = tokenId + 1;
1382                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1383                 if (_packedOwnerships[nextTokenId] == 0) {
1384                     // If the next slot is within bounds.
1385                     if (nextTokenId != _currentIndex) {
1386                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1387                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1388                     }
1389                 }
1390             }
1391         }
1392 
1393         emit Transfer(from, address(0), tokenId);
1394         _afterTokenTransfers(from, address(0), tokenId, 1);
1395 
1396         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1397         unchecked {
1398             _burnCounter++;
1399         }
1400     }
1401 
1402     // =============================================================
1403     //                     EXTRA DATA OPERATIONS
1404     // =============================================================
1405 
1406     /**
1407      * @dev Directly sets the extra data for the ownership data `index`.
1408      */
1409     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1410         uint256 packed = _packedOwnerships[index];
1411         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1412         uint256 extraDataCasted;
1413         // Cast `extraData` with assembly to avoid redundant masking.
1414         assembly {
1415             extraDataCasted := extraData
1416         }
1417         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1418         _packedOwnerships[index] = packed;
1419     }
1420 
1421     /**
1422      * @dev Called during each token transfer to set the 24bit `extraData` field.
1423      * Intended to be overridden by the cosumer contract.
1424      *
1425      * `previousExtraData` - the value of `extraData` before transfer.
1426      *
1427      * Calling conditions:
1428      *
1429      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1430      * transferred to `to`.
1431      * - When `from` is zero, `tokenId` will be minted for `to`.
1432      * - When `to` is zero, `tokenId` will be burned by `from`.
1433      * - `from` and `to` are never both zero.
1434      */
1435     function _extraData(
1436         address from,
1437         address to,
1438         uint24 previousExtraData
1439     ) internal view virtual returns (uint24) {}
1440 
1441     /**
1442      * @dev Returns the next extra data for the packed ownership data.
1443      * The returned result is shifted into position.
1444      */
1445     function _nextExtraData(
1446         address from,
1447         address to,
1448         uint256 prevOwnershipPacked
1449     ) private view returns (uint256) {
1450         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1451         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1452     }
1453 
1454     // =============================================================
1455     //                       OTHER OPERATIONS
1456     // =============================================================
1457 
1458     /**
1459      * @dev Returns the message sender (defaults to `msg.sender`).
1460      *
1461      * If you are writing GSN compatible contracts, you need to override this function.
1462      */
1463     function _msgSenderERC721A() internal view virtual returns (address) {
1464         return msg.sender;
1465     }
1466 
1467     /**
1468      * @dev Converts a uint256 to its ASCII string decimal representation.
1469      */
1470     function _toString(uint256 value) internal pure virtual returns (string memory ptr) {
1471         assembly {
1472             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1473             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1474             // We will need 1 32-byte word to store the length,
1475             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1476             ptr := add(mload(0x40), 128)
1477             // Update the free memory pointer to allocate.
1478             mstore(0x40, ptr)
1479 
1480             // Cache the end of the memory to calculate the length later.
1481             let end := ptr
1482 
1483             // We write the string from the rightmost digit to the leftmost digit.
1484             // The following is essentially a do-while loop that also handles the zero case.
1485             // Costs a bit more than early returning for the zero case,
1486             // but cheaper in terms of deployment and overall runtime costs.
1487             for {
1488                 // Initialize and perform the first pass without check.
1489                 let temp := value
1490                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1491                 ptr := sub(ptr, 1)
1492                 // Write the character to the pointer.
1493                 // The ASCII index of the '0' character is 48.
1494                 mstore8(ptr, add(48, mod(temp, 10)))
1495                 temp := div(temp, 10)
1496             } temp {
1497                 // Keep dividing `temp` until zero.
1498                 temp := div(temp, 10)
1499             } {
1500                 // Body of the for loop.
1501                 ptr := sub(ptr, 1)
1502                 mstore8(ptr, add(48, mod(temp, 10)))
1503             }
1504 
1505             let length := sub(end, ptr)
1506             // Move the pointer 32 bytes leftwards to make room for the length.
1507             ptr := sub(ptr, 32)
1508             // Store the length.
1509             mstore(ptr, length)
1510         }
1511     }
1512 }
1513 
1514 // File: erc721a/contracts/extensions/ERC721AQueryable.sol
1515 
1516 
1517 // ERC721A Contracts v4.2.0
1518 // Creator: Chiru Labs
1519 
1520 pragma solidity ^0.8.4;
1521 
1522 
1523 
1524 /**
1525  * @title ERC721AQueryable.
1526  *
1527  * @dev ERC721A subclass with convenience query functions.
1528  */
1529 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1530     /**
1531      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1532      *
1533      * If the `tokenId` is out of bounds:
1534      *
1535      * - `addr = address(0)`
1536      * - `startTimestamp = 0`
1537      * - `burned = false`
1538      * - `extraData = 0`
1539      *
1540      * If the `tokenId` is burned:
1541      *
1542      * - `addr = <Address of owner before token was burned>`
1543      * - `startTimestamp = <Timestamp when token was burned>`
1544      * - `burned = true`
1545      * - `extraData = <Extra data when token was burned>`
1546      *
1547      * Otherwise:
1548      *
1549      * - `addr = <Address of owner>`
1550      * - `startTimestamp = <Timestamp of start of ownership>`
1551      * - `burned = false`
1552      * - `extraData = <Extra data at start of ownership>`
1553      */
1554     function explicitOwnershipOf(uint256 tokenId) public view virtual override returns (TokenOwnership memory) {
1555         TokenOwnership memory ownership;
1556         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1557             return ownership;
1558         }
1559         ownership = _ownershipAt(tokenId);
1560         if (ownership.burned) {
1561             return ownership;
1562         }
1563         return _ownershipOf(tokenId);
1564     }
1565 
1566     /**
1567      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1568      * See {ERC721AQueryable-explicitOwnershipOf}
1569      */
1570     function explicitOwnershipsOf(uint256[] calldata tokenIds)
1571         external
1572         view
1573         virtual
1574         override
1575         returns (TokenOwnership[] memory)
1576     {
1577         unchecked {
1578             uint256 tokenIdsLength = tokenIds.length;
1579             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1580             for (uint256 i; i != tokenIdsLength; ++i) {
1581                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1582             }
1583             return ownerships;
1584         }
1585     }
1586 
1587     /**
1588      * @dev Returns an array of token IDs owned by `owner`,
1589      * in the range [`start`, `stop`)
1590      * (i.e. `start <= tokenId < stop`).
1591      *
1592      * This function allows for tokens to be queried if the collection
1593      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1594      *
1595      * Requirements:
1596      *
1597      * - `start < stop`
1598      */
1599     function tokensOfOwnerIn(
1600         address owner,
1601         uint256 start,
1602         uint256 stop
1603     ) external view virtual override returns (uint256[] memory) {
1604         unchecked {
1605             if (start >= stop) revert InvalidQueryRange();
1606             uint256 tokenIdsIdx;
1607             uint256 stopLimit = _nextTokenId();
1608             // Set `start = max(start, _startTokenId())`.
1609             if (start < _startTokenId()) {
1610                 start = _startTokenId();
1611             }
1612             // Set `stop = min(stop, stopLimit)`.
1613             if (stop > stopLimit) {
1614                 stop = stopLimit;
1615             }
1616             uint256 tokenIdsMaxLength = balanceOf(owner);
1617             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1618             // to cater for cases where `balanceOf(owner)` is too big.
1619             if (start < stop) {
1620                 uint256 rangeLength = stop - start;
1621                 if (rangeLength < tokenIdsMaxLength) {
1622                     tokenIdsMaxLength = rangeLength;
1623                 }
1624             } else {
1625                 tokenIdsMaxLength = 0;
1626             }
1627             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1628             if (tokenIdsMaxLength == 0) {
1629                 return tokenIds;
1630             }
1631             // We need to call `explicitOwnershipOf(start)`,
1632             // because the slot at `start` may not be initialized.
1633             TokenOwnership memory ownership = explicitOwnershipOf(start);
1634             address currOwnershipAddr;
1635             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1636             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1637             if (!ownership.burned) {
1638                 currOwnershipAddr = ownership.addr;
1639             }
1640             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1641                 ownership = _ownershipAt(i);
1642                 if (ownership.burned) {
1643                     continue;
1644                 }
1645                 if (ownership.addr != address(0)) {
1646                     currOwnershipAddr = ownership.addr;
1647                 }
1648                 if (currOwnershipAddr == owner) {
1649                     tokenIds[tokenIdsIdx++] = i;
1650                 }
1651             }
1652             // Downsize the array to fit.
1653             assembly {
1654                 mstore(tokenIds, tokenIdsIdx)
1655             }
1656             return tokenIds;
1657         }
1658     }
1659 
1660     /**
1661      * @dev Returns an array of token IDs owned by `owner`.
1662      *
1663      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
1664      * It is meant to be called off-chain.
1665      *
1666      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1667      * multiple smaller scans if the collection is large enough to cause
1668      * an out-of-gas error (10K collections should be fine).
1669      */
1670     function tokensOfOwner(address owner) external view virtual override returns (uint256[] memory) {
1671         unchecked {
1672             uint256 tokenIdsIdx;
1673             address currOwnershipAddr;
1674             uint256 tokenIdsLength = balanceOf(owner);
1675             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1676             TokenOwnership memory ownership;
1677             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1678                 ownership = _ownershipAt(i);
1679                 if (ownership.burned) {
1680                     continue;
1681                 }
1682                 if (ownership.addr != address(0)) {
1683                     currOwnershipAddr = ownership.addr;
1684                 }
1685                 if (currOwnershipAddr == owner) {
1686                     tokenIds[tokenIdsIdx++] = i;
1687                 }
1688             }
1689             return tokenIds;
1690         }
1691     }
1692 }
1693 
1694 // File: contracts/pixelastronauts.sol
1695 
1696 
1697 pragma solidity ^0.8.4;
1698 
1699 
1700 
1701 
1702 contract PixelAstronauts is ERC721A, Owned {
1703     uint256 public maxSupply = 4444;
1704     uint256 public maxPerWallet = 20;
1705     uint256 public maxPerTx = 10;
1706     uint256 public price = 0.00 ether;
1707 
1708     bool public activated;
1709 
1710     mapping(uint256 => string) private _tokenURIs;
1711 
1712     address private _ownerWallet = 0x16015457f2Fa70b1FDfe8eD091A14E837528C4AD;
1713 
1714     string public baseURI = "ipfs://QmQVWLQNZUST8Fooom4S23vYcSNuFSRdU8HmMG2AVzs2iH/";
1715     bool public revealed = false;
1716 
1717 
1718       constructor() ERC721A("Pixel Astronauts", "PXAS") Owned(msg.sender) {}
1719 
1720     function _baseURI() internal view override returns (string memory) {
1721         return baseURI;
1722     }
1723 
1724 
1725     function _startTokenId() internal view virtual override returns (uint256) {
1726         return 1;
1727     }
1728 
1729     ////  MINT
1730     function mint(uint256 numberOfTokens) external payable {
1731         require(activated, "Inactive");
1732         require(totalSupply() + numberOfTokens <= maxSupply, "All minted");
1733         require(numberOfTokens <= maxPerTx, "Too many for Tx");
1734         require(_numberMinted(msg.sender) + numberOfTokens <= maxPerWallet,"Too many for address");
1735         require(msg.value >= price * numberOfTokens, "Not enought funds");
1736 
1737         
1738         _safeMint(msg.sender, numberOfTokens);
1739     }
1740 
1741     ////  SETTERS
1742 
1743        function changeRevealed(bool _revealed) public onlyOwner{
1744         revealed = _revealed;
1745     }
1746 
1747     function ChangeBaseURI(string memory baseURI_) public onlyOwner {
1748         baseURI = baseURI_;
1749     }
1750 
1751     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1752         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1753 
1754         string memory baseURI_ = _baseURI();
1755 
1756         if (revealed) {
1757         return bytes(baseURI_).length > 0 ? string(abi.encodePacked(baseURI, tokenId, ".json")) : "";
1758         } else {
1759             return string(abi.encodePacked(baseURI_, "hidden.json"));
1760         }
1761 
1762 
1763     }
1764 
1765     function setPrice(uint256 _price) public onlyOwner {
1766     price = _price;
1767   }
1768 
1769     function setMaxSupply(uint256 _maxSupply) external onlyOwner {
1770         maxSupply = _maxSupply;
1771     }
1772 
1773     function collectReserves() external onlyOwner {
1774     require(totalSupply() == 0, "RESERVES TAKEN");
1775 
1776     _mint(msg.sender, 150);
1777   }
1778 
1779     function setIsActive(bool _isActive) external onlyOwner {
1780         activated = _isActive;
1781     }
1782 
1783     function withdraw() external onlyOwner {
1784     require(
1785       payable(owner).send(address(this).balance),
1786       "UNSUCCESSFUL"
1787     );
1788   }
1789 }