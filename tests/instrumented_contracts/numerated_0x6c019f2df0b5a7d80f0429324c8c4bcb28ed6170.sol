1 // File: contracts\CollectionProxy\IERC1538.sol
2 
3 pragma solidity ^0.8.0;
4 
5 /// @title ERC1538 Transparent Contract Standard
6 /// @dev Required interface
7 ///  Note: the ERC-165 identifier for this interface is 0x61455567
8 interface IERC1538 {
9 
10     /// @dev This emits when one or a set of functions are updated in a transparent contract.
11     ///  The message string should give a short description of the change and why
12     ///  the change was made.
13     event CommitMessage(string message);
14 
15     /// @dev This emits for each function that is updated in a transparent contract.
16     ///  functionId is the bytes4 of the keccak256 of the function signature.
17     ///  oldDelegate is the delegate contract address of the old delegate contract if
18     ///  the function is being replaced or removed.
19     ///  oldDelegate is the zero value address(0) if a function is being added for the
20     ///  first time.
21     ///  newDelegate is the delegate contract address of the new delegate contract if
22     ///  the function is being added for the first time or if the function is being
23     ///  replaced.
24     ///  newDelegate is the zero value address(0) if the function is being removed.
25     event FunctionUpdate(bytes4 indexed functionId, address indexed oldDelegate, address indexed newDelegate, string functionSignature);
26 
27     /// @notice Updates functions in a transparent contract.
28     /// @dev If the value of _delegate is zero then the functions specified
29     ///  in _functionSignatures are removed.
30     ///  If the value of _delegate is a delegate contract address then the functions
31     ///  specified in _functionSignatures will be delegated to that address.
32     /// @param _delegate The address of a delegate contract to delegate to or zero
33     ///        to remove functions.
34     /// @param _functionSignatures A list of function signatures listed one after the other
35     /// @param _commitMessage A short description of the change and why it is made
36     ///        This message is passed to the CommitMessage event.
37     function updateContract(address _delegate, string calldata _functionSignatures, string calldata _commitMessage) external;
38 }
39 
40 // File: contracts\CollectionProxy\ProxyBaseStorage.sol
41 
42 pragma solidity ^0.8.0;
43 
44 ///////////////////////////////////////////////////////////////////////////////////////////////////
45 /**
46  * @title ProxyBaseStorage
47  * @dev Defining base storage for the proxy contract.
48  */
49 ///////////////////////////////////////////////////////////////////////////////////////////////////
50 
51 contract ProxyBaseStorage {
52 
53     //////////////////////////////////////////// VARS /////////////////////////////////////////////
54 
55     // maps functions to the delegate contracts that execute the functions.
56     // funcId => delegate contract
57     mapping(bytes4 => address) public delegates;
58 
59     // array of function signatures supported by the contract.
60     bytes[] public funcSignatures;
61 
62     // maps each function signature to its position in the funcSignatures array.
63     // signature => index+1
64     mapping(bytes => uint256) internal funcSignatureToIndex;
65 
66     // proxy address of itself, can be used for cross-delegate calls but also safety checking.
67     address proxy;
68 
69     ///////////////////////////////////////////////////////////////////////////////////////////////
70 
71 }
72 
73 // File: contracts\IERC721A.sol
74 
75 
76 // ERC721A Contracts v4.2.3
77 // Creator: Chiru Labs
78 
79 pragma solidity ^0.8.4;
80 
81 /**
82  * @dev Interface of ERC721A.
83  */
84 interface IERC721A {
85     /**
86      * The caller must own the token or be an approved operator.
87      */
88     error ApprovalCallerNotOwnerNorApproved();
89 
90     /**
91      * The token does not exist.
92      */
93     error ApprovalQueryForNonexistentToken();
94 
95     /**
96      * Cannot query the balance for the zero address.
97      */
98     error BalanceQueryForZeroAddress();
99 
100     /**
101      * Cannot mint to the zero address.
102      */
103     error MintToZeroAddress();
104 
105     /**
106      * The quantity of tokens minted must be more than zero.
107      */
108     error MintZeroQuantity();
109 
110     /**
111      * The token does not exist.
112      */
113     error OwnerQueryForNonexistentToken();
114 
115     /**
116      * The caller must own the token or be an approved operator.
117      */
118     error TransferCallerNotOwnerNorApproved();
119 
120     /**
121      * The token must be owned by `from`.
122      */
123     error TransferFromIncorrectOwner();
124 
125     /**
126      * Cannot safely transfer to a contract that does not implement the
127      * ERC721Receiver interface.
128      */
129     error TransferToNonERC721ReceiverImplementer();
130 
131     /**
132      * Cannot transfer to the zero address.
133      */
134     error TransferToZeroAddress();
135 
136     /**
137      * The token does not exist.
138      */
139     error URIQueryForNonexistentToken();
140 
141     /**
142      * The `quantity` minted with ERC2309 exceeds the safety limit.
143      */
144     error MintERC2309QuantityExceedsLimit();
145 
146     /**
147      * The `extraData` cannot be set on an unintialized ownership slot.
148      */
149     error OwnershipNotInitializedForExtraData();
150 
151     // =============================================================
152     //                            STRUCTS
153     // =============================================================
154 
155     struct TokenOwnership {
156         // The address of the owner.
157         address addr;
158         // Stores the start time of ownership with minimal overhead for tokenomics.
159         uint64 startTimestamp;
160         // Whether the token has been burned.
161         bool burned;
162         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
163         uint24 extraData;
164     }
165 
166     // =============================================================
167     //                         TOKEN COUNTERS
168     // =============================================================
169 
170     /**
171      * @dev Returns the total number of tokens in existence.
172      * Burned tokens will reduce the count.
173      * To get the total number of tokens minted, please see {_totalMinted}.
174      */
175     function totalSupply() external view returns (uint256);
176 
177     // =============================================================
178     //                            IERC165
179     // =============================================================
180 
181     /**
182      * @dev Returns true if this contract implements the interface defined by
183      * `interfaceId`. See the corresponding
184      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
185      * to learn more about how these ids are created.
186      *
187      * This function call must use less than 30000 gas.
188      */
189     function supportsInterface(bytes4 interfaceId) external view returns (bool);
190 
191     // =============================================================
192     //                            IERC721
193     // =============================================================
194 
195     /**
196      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
197      */
198     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
199 
200     /**
201      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
202      */
203     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
204 
205     /**
206      * @dev Emitted when `owner` enables or disables
207      * (`approved`) `operator` to manage all of its assets.
208      */
209     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
210 
211     /**
212      * @dev Returns the number of tokens in `owner`'s account.
213      */
214     function balanceOf(address owner) external view returns (uint256 balance);
215 
216     /**
217      * @dev Returns the owner of the `tokenId` token.
218      *
219      * Requirements:
220      *
221      * - `tokenId` must exist.
222      */
223     function ownerOf(uint256 tokenId) external view returns (address owner);
224 
225     /**
226      * @dev Safely transfers `tokenId` token from `from` to `to`,
227      * checking first that contract recipients are aware of the ERC721 protocol
228      * to prevent tokens from being forever locked.
229      *
230      * Requirements:
231      *
232      * - `from` cannot be the zero address.
233      * - `to` cannot be the zero address.
234      * - `tokenId` token must exist and be owned by `from`.
235      * - If the caller is not `from`, it must be have been allowed to move
236      * this token by either {approve} or {setApprovalForAll}.
237      * - If `to` refers to a smart contract, it must implement
238      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
239      *
240      * Emits a {Transfer} event.
241      */
242     function safeTransferFrom(
243         address from,
244         address to,
245         uint256 tokenId,
246         bytes calldata data
247     ) external payable;
248 
249     /**
250      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
251      */
252     function safeTransferFrom(
253         address from,
254         address to,
255         uint256 tokenId
256     ) external payable;
257 
258     /**
259      * @dev Transfers `tokenId` from `from` to `to`.
260      *
261      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
262      * whenever possible.
263      *
264      * Requirements:
265      *
266      * - `from` cannot be the zero address.
267      * - `to` cannot be the zero address.
268      * - `tokenId` token must be owned by `from`.
269      * - If the caller is not `from`, it must be approved to move this token
270      * by either {approve} or {setApprovalForAll}.
271      *
272      * Emits a {Transfer} event.
273      */
274     function transferFrom(
275         address from,
276         address to,
277         uint256 tokenId
278     ) external payable;
279 
280     /**
281      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
282      * The approval is cleared when the token is transferred.
283      *
284      * Only a single account can be approved at a time, so approving the
285      * zero address clears previous approvals.
286      *
287      * Requirements:
288      *
289      * - The caller must own the token or be an approved operator.
290      * - `tokenId` must exist.
291      *
292      * Emits an {Approval} event.
293      */
294     function approve(address to, uint256 tokenId) external payable;
295 
296     /**
297      * @dev Approve or remove `operator` as an operator for the caller.
298      * Operators can call {transferFrom} or {safeTransferFrom}
299      * for any token owned by the caller.
300      *
301      * Requirements:
302      *
303      * - The `operator` cannot be the caller.
304      *
305      * Emits an {ApprovalForAll} event.
306      */
307     function setApprovalForAll(address operator, bool _approved) external;
308 
309     /**
310      * @dev Returns the account approved for `tokenId` token.
311      *
312      * Requirements:
313      *
314      * - `tokenId` must exist.
315      */
316     function getApproved(uint256 tokenId) external view returns (address operator);
317 
318     /**
319      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
320      *
321      * See {setApprovalForAll}.
322      */
323     function isApprovedForAll(address owner, address operator) external view returns (bool);
324 
325     // =============================================================
326     //                        IERC721Metadata
327     // =============================================================
328 
329     /**
330      * @dev Returns the token collection name.
331      */
332     function name() external view returns (string memory);
333 
334     /**
335      * @dev Returns the token collection symbol.
336      */
337     function symbol() external view returns (string memory);
338 
339     /**
340      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
341      */
342     function tokenURI(uint256 tokenId) external view returns (string memory);
343 
344     // =============================================================
345     //                           IERC2309
346     // =============================================================
347 
348     /**
349      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
350      * (inclusive) is transferred from `from` to `to`, as defined in the
351      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
352      *
353      * See {_mintERC2309} for more details.
354      */
355     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
356 }
357 
358 // File: contracts\ERC721A.sol
359 
360 
361 // ERC721A Contracts v4.2.3
362 // Creator: Chiru Labs
363 
364 pragma solidity ^0.8.4;
365 
366 /**
367  * @dev Interface of ERC721 token receiver.
368  */
369 interface ERC721A__IERC721Receiver {
370     function onERC721Received(
371         address operator,
372         address from,
373         uint256 tokenId,
374         bytes calldata data
375     ) external returns (bytes4);
376 }
377 
378 /**
379  * @title ERC721A
380  *
381  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
382  * Non-Fungible Token Standard, including the Metadata extension.
383  * Optimized for lower gas during batch mints.
384  *
385  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
386  * starting from `_startTokenId()`.
387  *
388  * Assumptions:
389  *
390  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
391  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
392  */
393 contract ERC721A is IERC721A {
394     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
395     struct TokenApprovalRef {
396         address value;
397     }
398 
399     // =============================================================
400     //                           CONSTANTS
401     // =============================================================
402 
403     // Mask of an entry in packed address data.
404     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
405 
406     // The bit position of `numberMinted` in packed address data.
407     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
408 
409     // The bit position of `numberBurned` in packed address data.
410     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
411 
412     // The bit position of `aux` in packed address data.
413     uint256 private constant _BITPOS_AUX = 192;
414 
415     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
416     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
417 
418     // The bit position of `startTimestamp` in packed ownership.
419     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
420 
421     // The bit mask of the `burned` bit in packed ownership.
422     uint256 private constant _BITMASK_BURNED = 1 << 224;
423 
424     // The bit position of the `nextInitialized` bit in packed ownership.
425     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
426 
427     // The bit mask of the `nextInitialized` bit in packed ownership.
428     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
429 
430     // The bit position of `extraData` in packed ownership.
431     uint256 private constant _BITPOS_EXTRA_DATA = 232;
432 
433     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
434     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
435 
436     // The mask of the lower 160 bits for addresses.
437     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
438 
439     // The maximum `quantity` that can be minted with {_mintERC2309}.
440     // This limit is to prevent overflows on the address data entries.
441     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
442     // is required to cause an overflow, which is unrealistic.
443     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
444 
445     // The `Transfer` event signature is given by:
446     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
447     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
448         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
449 
450     // =============================================================
451     //                            STORAGE
452     // =============================================================
453 
454     // The next token ID to be minted.
455     uint256 internal _currentIndex;
456 
457     // The number of tokens burned.
458     uint256 private _burnCounter;
459 
460     // Token name
461     string private _name;
462 
463     // Token symbol
464     string private _symbol;
465 
466     // Mapping from token ID to ownership details
467     // An empty struct value does not necessarily mean the token is unowned.
468     // See {_packedOwnershipOf} implementation for details.
469     //
470     // Bits Layout:
471     // - [0..159]   `addr`
472     // - [160..223] `startTimestamp`
473     // - [224]      `burned`
474     // - [225]      `nextInitialized`
475     // - [232..255] `extraData`
476     mapping(uint256 => uint256) private _packedOwnerships;
477 
478     // Mapping owner address to address data.
479     //
480     // Bits Layout:
481     // - [0..63]    `balance`
482     // - [64..127]  `numberMinted`
483     // - [128..191] `numberBurned`
484     // - [192..255] `aux`
485     mapping(address => uint256) private _packedAddressData;
486 
487     // Mapping from token ID to approved address.
488     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
489 
490     // Mapping from owner to operator approvals
491     mapping(address => mapping(address => bool)) public _operatorApprovals;
492 
493     // =============================================================
494     //                          CONSTRUCTOR
495     // =============================================================
496 
497     constructor(string memory name_, string memory symbol_) {
498         _name = name_;
499         _symbol = symbol_;
500         _currentIndex = _startTokenId();
501     }
502 
503     // =============================================================
504     //                   TOKEN COUNTING OPERATIONS
505     // =============================================================
506 
507     /**
508      * @dev Returns the starting token ID.
509      * To change the starting token ID, please override this function.
510      */
511     function _startTokenId() internal view virtual returns (uint256) {
512         return 1;
513     }
514 
515     /**
516      * @dev Returns the next token ID to be minted.
517      */
518     function _nextTokenId() internal view virtual returns (uint256) {
519         return _currentIndex;
520     }
521 
522     /**
523      * @dev Returns the total number of tokens in existence.
524      * Burned tokens will reduce the count.
525      * To get the total number of tokens minted, please see {_totalMinted}.
526      */
527     function totalSupply() public view virtual override returns (uint256) {
528         // Counter underflow is impossible as _burnCounter cannot be incremented
529         // more than `_currentIndex - _startTokenId()` times.
530         unchecked {
531             return _currentIndex - _burnCounter - _startTokenId();
532         }
533     }
534 
535     /**
536      * @dev Returns the total amount of tokens minted in the contract.
537      */
538     function _totalMinted() internal view virtual returns (uint256) {
539         // Counter underflow is impossible as `_currentIndex` does not decrement,
540         // and it is initialized to `_startTokenId()`.
541         unchecked {
542             return _currentIndex - _startTokenId();
543         }
544     }
545 
546     /**
547      * @dev Returns the total number of tokens burned.
548      */
549     function _totalBurned() internal view virtual returns (uint256) {
550         return _burnCounter;
551     }
552 
553     // =============================================================
554     //                    ADDRESS DATA OPERATIONS
555     // =============================================================
556 
557     /**
558      * @dev Returns the number of tokens in `owner`'s account.
559      */
560     function balanceOf(address owner) public view virtual override returns (uint256) {
561         if (owner == address(0)) revert BalanceQueryForZeroAddress();
562         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
563     }
564 
565     /**
566      * Returns the number of tokens minted by `owner`.
567      */
568     function _numberMinted(address owner) internal view returns (uint256) {
569         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
570     }
571 
572     /**
573      * Returns the number of tokens burned by or on behalf of `owner`.
574      */
575     function _numberBurned(address owner) internal view returns (uint256) {
576         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
577     }
578 
579     /**
580      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
581      */
582     function _getAux(address owner) internal view returns (uint64) {
583         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
584     }
585 
586     /**
587      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
588      * If there are multiple variables, please pack them into a uint64.
589      */
590     function _setAux(address owner, uint64 aux) internal virtual {
591         uint256 packed = _packedAddressData[owner];
592         uint256 auxCasted;
593         // Cast `aux` with assembly to avoid redundant masking.
594         assembly {
595             auxCasted := aux
596         }
597         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
598         _packedAddressData[owner] = packed;
599     }
600 
601     // =============================================================
602     //                            IERC165
603     // =============================================================
604 
605     /**
606      * @dev Returns true if this contract implements the interface defined by
607      * `interfaceId`. See the corresponding
608      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
609      * to learn more about how these ids are created.
610      *
611      * This function call must use less than 30000 gas.
612      */
613     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
614         // The interface IDs are constants representing the first 4 bytes
615         // of the XOR of all function selectors in the interface.
616         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
617         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
618         return
619             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
620             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
621             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
622     }
623 
624     // =============================================================
625     //                        IERC721Metadata
626     // =============================================================
627 
628     /**
629      * @dev Returns the token collection name.
630      */
631     function name() public view virtual override returns (string memory) {
632         return _name;
633     }
634 
635     /**
636      * @dev Returns the token collection symbol.
637      */
638     function symbol() public view virtual override returns (string memory) {
639         return _symbol;
640     }
641 
642     /**
643      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
644      */
645     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
646         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
647 
648         string memory baseURI = _baseURI();
649         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
650     }
651 
652     /**
653      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
654      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
655      * by default, it can be overridden in child contracts.
656      */
657     function _baseURI() internal view virtual returns (string memory) {
658         return '';
659     }
660 
661     // =============================================================
662     //                     OWNERSHIPS OPERATIONS
663     // =============================================================
664 
665     /**
666      * @dev Returns the owner of the `tokenId` token.
667      *
668      * Requirements:
669      *
670      * - `tokenId` must exist.
671      */
672     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
673         return address(uint160(_packedOwnershipOf(tokenId)));
674     }
675 
676     /**
677      * @dev Gas spent here starts off proportional to the maximum mint batch size.
678      * It gradually moves to O(1) as tokens get transferred around over time.
679      */
680     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
681         return _unpackedOwnership(_packedOwnershipOf(tokenId));
682     }
683 
684     /**
685      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
686      */
687     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
688         return _unpackedOwnership(_packedOwnerships[index]);
689     }
690 
691     /**
692      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
693      */
694     function _initializeOwnershipAt(uint256 index) internal virtual {
695         if (_packedOwnerships[index] == 0) {
696             _packedOwnerships[index] = _packedOwnershipOf(index);
697         }
698     }
699 
700     /**
701      * Returns the packed ownership data of `tokenId`.
702      */
703     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256 packed) {
704         if (_startTokenId() <= tokenId) {
705             packed = _packedOwnerships[tokenId];
706             // If not burned.
707             if (packed & _BITMASK_BURNED == 0) {
708                 // If the data at the starting slot does not exist, start the scan.
709                 if (packed == 0) {
710                     if (tokenId >= _currentIndex) revert OwnerQueryForNonexistentToken();
711                     // Invariant:
712                     // There will always be an initialized ownership slot
713                     // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
714                     // before an unintialized ownership slot
715                     // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
716                     // Hence, `tokenId` will not underflow.
717                     //
718                     // We can directly compare the packed value.
719                     // If the address is zero, packed will be zero.
720                     for (;;) {
721                         unchecked {
722                             packed = _packedOwnerships[--tokenId];
723                         }
724                         if (packed == 0) continue;
725                         return packed;
726                     }
727                 }
728                 // Otherwise, the data exists and is not burned. We can skip the scan.
729                 // This is possible because we have already achieved the target condition.
730                 // This saves 2143 gas on transfers of initialized tokens.
731                 return packed;
732             }
733         }
734         revert OwnerQueryForNonexistentToken();
735     }
736 
737     /**
738      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
739      */
740     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
741         ownership.addr = address(uint160(packed));
742         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
743         ownership.burned = packed & _BITMASK_BURNED != 0;
744         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
745     }
746 
747     /**
748      * @dev Packs ownership data into a single uint256.
749      */
750     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
751         assembly {
752             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
753             owner := and(owner, _BITMASK_ADDRESS)
754             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
755             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
756         }
757     }
758 
759     /**
760      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
761      */
762     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
763         // For branchless setting of the `nextInitialized` flag.
764         assembly {
765             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
766             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
767         }
768     }
769 
770     // =============================================================
771     //                      APPROVAL OPERATIONS
772     // =============================================================
773 
774     /**
775      * @dev Gives permission to `to` to transfer `tokenId` token to another account. See {ERC721A-_approve}.
776      *
777      * Requirements:
778      *
779      * - The caller must own the token or be an approved operator.
780      */
781     function approve(address to, uint256 tokenId) public payable virtual override {
782         _approve(to, tokenId, true);
783     }
784 
785     /**
786      * @dev Returns the account approved for `tokenId` token.
787      *
788      * Requirements:
789      *
790      * - `tokenId` must exist.
791      */
792     function getApproved(uint256 tokenId) public view virtual override returns (address) {
793         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
794 
795         return _tokenApprovals[tokenId].value;
796     }
797 
798     /**
799      * @dev Approve or remove `operator` as an operator for the caller.
800      * Operators can call {transferFrom} or {safeTransferFrom}
801      * for any token owned by the caller.
802      *
803      * Requirements:
804      *
805      * - The `operator` cannot be the caller.
806      *
807      * Emits an {ApprovalForAll} event.
808      */
809     function setApprovalForAll(address operator, bool approved) public virtual override {
810         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
811         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
812     }
813 
814     /**
815      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
816      *
817      * See {setApprovalForAll}.
818      */
819     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
820         return _operatorApprovals[owner][operator];
821     }
822 
823     /**
824      * @dev Returns whether `tokenId` exists.
825      *
826      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
827      *
828      * Tokens start existing when they are minted. See {_mint}.
829      */
830     function _exists(uint256 tokenId) internal view virtual returns (bool) {
831         return
832             _startTokenId() <= tokenId &&
833             tokenId < _currentIndex && // If within bounds,
834             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
835     }
836 
837     /**
838      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
839      */
840     function _isSenderApprovedOrOwner(
841         address approvedAddress,
842         address owner,
843         address msgSender
844     ) private pure returns (bool result) {
845         assembly {
846             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
847             owner := and(owner, _BITMASK_ADDRESS)
848             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
849             msgSender := and(msgSender, _BITMASK_ADDRESS)
850             // `msgSender == owner || msgSender == approvedAddress`.
851             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
852         }
853     }
854 
855     /**
856      * @dev Returns the storage slot and value for the approved address of `tokenId`.
857      */
858     function _getApprovedSlotAndAddress(uint256 tokenId)
859         private
860         view
861         returns (uint256 approvedAddressSlot, address approvedAddress)
862     {
863         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
864         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
865         assembly {
866             approvedAddressSlot := tokenApproval.slot
867             approvedAddress := sload(approvedAddressSlot)
868         }
869     }
870 
871     // =============================================================
872     //                      TRANSFER OPERATIONS
873     // =============================================================
874 
875     /**
876      * @dev Transfers `tokenId` from `from` to `to`.
877      *
878      * Requirements:
879      *
880      * - `from` cannot be the zero address.
881      * - `to` cannot be the zero address.
882      * - `tokenId` token must be owned by `from`.
883      * - If the caller is not `from`, it must be approved to move this token
884      * by either {approve} or {setApprovalForAll}.
885      *
886      * Emits a {Transfer} event.
887      */
888     function transferFrom(
889         address from,
890         address to,
891         uint256 tokenId
892     ) public payable virtual override {
893         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
894 
895         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
896 
897         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
898 
899         // The nested ifs save around 20+ gas over a compound boolean condition.
900         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
901             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
902 
903         if (to == address(0)) revert TransferToZeroAddress();
904 
905         _beforeTokenTransfers(from, to, tokenId, 1);
906 
907         // Clear approvals from the previous owner.
908         assembly {
909             if approvedAddress {
910                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
911                 sstore(approvedAddressSlot, 0)
912             }
913         }
914 
915         // Underflow of the sender's balance is impossible because we check for
916         // ownership above and the recipient's balance can't realistically overflow.
917         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
918         unchecked {
919             // We can directly increment and decrement the balances.
920             --_packedAddressData[from]; // Updates: `balance -= 1`.
921             ++_packedAddressData[to]; // Updates: `balance += 1`.
922 
923             // Updates:
924             // - `address` to the next owner.
925             // - `startTimestamp` to the timestamp of transfering.
926             // - `burned` to `false`.
927             // - `nextInitialized` to `true`.
928             _packedOwnerships[tokenId] = _packOwnershipData(
929                 to,
930                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
931             );
932 
933             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
934             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
935                 uint256 nextTokenId = tokenId + 1;
936                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
937                 if (_packedOwnerships[nextTokenId] == 0) {
938                     // If the next slot is within bounds.
939                     if (nextTokenId != _currentIndex) {
940                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
941                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
942                     }
943                 }
944             }
945         }
946 
947         emit Transfer(from, to, tokenId);
948         _afterTokenTransfers(from, to, tokenId, 1);
949     }
950 
951     /**
952      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
953      */
954     function safeTransferFrom(
955         address from,
956         address to,
957         uint256 tokenId
958     ) public payable virtual override {
959         safeTransferFrom(from, to, tokenId, '');
960     }
961 
962     /**
963      * @dev Safely transfers `tokenId` token from `from` to `to`.
964      *
965      * Requirements:
966      *
967      * - `from` cannot be the zero address.
968      * - `to` cannot be the zero address.
969      * - `tokenId` token must exist and be owned by `from`.
970      * - If the caller is not `from`, it must be approved to move this token
971      * by either {approve} or {setApprovalForAll}.
972      * - If `to` refers to a smart contract, it must implement
973      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
974      *
975      * Emits a {Transfer} event.
976      */
977     function safeTransferFrom(
978         address from,
979         address to,
980         uint256 tokenId,
981         bytes memory _data
982     ) public payable virtual override {
983         transferFrom(from, to, tokenId);
984         if (to.code.length != 0)
985             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
986                 revert TransferToNonERC721ReceiverImplementer();
987             }
988     }
989 
990     /**
991      * @dev Hook that is called before a set of serially-ordered token IDs
992      * are about to be transferred. This includes minting.
993      * And also called before burning one token.
994      *
995      * `startTokenId` - the first token ID to be transferred.
996      * `quantity` - the amount to be transferred.
997      *
998      * Calling conditions:
999      *
1000      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1001      * transferred to `to`.
1002      * - When `from` is zero, `tokenId` will be minted for `to`.
1003      * - When `to` is zero, `tokenId` will be burned by `from`.
1004      * - `from` and `to` are never both zero.
1005      */
1006     function _beforeTokenTransfers(
1007         address from,
1008         address to,
1009         uint256 startTokenId,
1010         uint256 quantity
1011     ) internal virtual {}
1012 
1013     /**
1014      * @dev Hook that is called after a set of serially-ordered token IDs
1015      * have been transferred. This includes minting.
1016      * And also called after one token has been burned.
1017      *
1018      * `startTokenId` - the first token ID to be transferred.
1019      * `quantity` - the amount to be transferred.
1020      *
1021      * Calling conditions:
1022      *
1023      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1024      * transferred to `to`.
1025      * - When `from` is zero, `tokenId` has been minted for `to`.
1026      * - When `to` is zero, `tokenId` has been burned by `from`.
1027      * - `from` and `to` are never both zero.
1028      */
1029     function _afterTokenTransfers(
1030         address from,
1031         address to,
1032         uint256 startTokenId,
1033         uint256 quantity
1034     ) internal virtual {}
1035 
1036     /**
1037      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1038      *
1039      * `from` - Previous owner of the given token ID.
1040      * `to` - Target address that will receive the token.
1041      * `tokenId` - Token ID to be transferred.
1042      * `_data` - Optional data to send along with the call.
1043      *
1044      * Returns whether the call correctly returned the expected magic value.
1045      */
1046     function _checkContractOnERC721Received(
1047         address from,
1048         address to,
1049         uint256 tokenId,
1050         bytes memory _data
1051     ) private returns (bool) {
1052         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1053             bytes4 retval
1054         ) {
1055             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1056         } catch (bytes memory reason) {
1057             if (reason.length == 0) {
1058                 revert TransferToNonERC721ReceiverImplementer();
1059             } else {
1060                 assembly {
1061                     revert(add(32, reason), mload(reason))
1062                 }
1063             }
1064         }
1065     }
1066 
1067     // =============================================================
1068     //                        MINT OPERATIONS
1069     // =============================================================
1070 
1071     /**
1072      * @dev Mints `quantity` tokens and transfers them to `to`.
1073      *
1074      * Requirements:
1075      *
1076      * - `to` cannot be the zero address.
1077      * - `quantity` must be greater than 0.
1078      *
1079      * Emits a {Transfer} event for each mint.
1080      */
1081     function _mint(address to, uint256 quantity) internal virtual {
1082         uint256 startTokenId = _currentIndex;
1083         if (quantity == 0) revert MintZeroQuantity();
1084 
1085         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1086 
1087         // Overflows are incredibly unrealistic.
1088         // `balance` and `numberMinted` have a maximum limit of 2**64.
1089         // `tokenId` has a maximum limit of 2**256.
1090         unchecked {
1091             // Updates:
1092             // - `balance += quantity`.
1093             // - `numberMinted += quantity`.
1094             //
1095             // We can directly add to the `balance` and `numberMinted`.
1096             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1097 
1098             // Updates:
1099             // - `address` to the owner.
1100             // - `startTimestamp` to the timestamp of minting.
1101             // - `burned` to `false`.
1102             // - `nextInitialized` to `quantity == 1`.
1103             _packedOwnerships[startTokenId] = _packOwnershipData(
1104                 to,
1105                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1106             );
1107 
1108             uint256 toMasked;
1109             uint256 end = startTokenId + quantity;
1110 
1111             // Use assembly to loop and emit the `Transfer` event for gas savings.
1112             // The duplicated `log4` removes an extra check and reduces stack juggling.
1113             // The assembly, together with the surrounding Solidity code, have been
1114             // delicately arranged to nudge the compiler into producing optimized opcodes.
1115             assembly {
1116                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1117                 toMasked := and(to, _BITMASK_ADDRESS)
1118                 // Emit the `Transfer` event.
1119                 log4(
1120                     0, // Start of data (0, since no data).
1121                     0, // End of data (0, since no data).
1122                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1123                     0, // `address(0)`.
1124                     toMasked, // `to`.
1125                     startTokenId // `tokenId`.
1126                 )
1127 
1128                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1129                 // that overflows uint256 will make the loop run out of gas.
1130                 // The compiler will optimize the `iszero` away for performance.
1131                 for {
1132                     let tokenId := add(startTokenId, 1)
1133                 } iszero(eq(tokenId, end)) {
1134                     tokenId := add(tokenId, 1)
1135                 } {
1136                     // Emit the `Transfer` event. Similar to above.
1137                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1138                 }
1139             }
1140             if (toMasked == 0) revert MintToZeroAddress();
1141 
1142             _currentIndex = end;
1143         }
1144         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1145     }
1146 
1147     /**
1148      * @dev Mints `quantity` tokens and transfers them to `to`.
1149      *
1150      * This function is intended for efficient minting only during contract creation.
1151      *
1152      * It emits only one {ConsecutiveTransfer} as defined in
1153      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1154      * instead of a sequence of {Transfer} event(s).
1155      *
1156      * Calling this function outside of contract creation WILL make your contract
1157      * non-compliant with the ERC721 standard.
1158      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1159      * {ConsecutiveTransfer} event is only permissible during contract creation.
1160      *
1161      * Requirements:
1162      *
1163      * - `to` cannot be the zero address.
1164      * - `quantity` must be greater than 0.
1165      *
1166      * Emits a {ConsecutiveTransfer} event.
1167      */
1168     function _mintERC2309(address to, uint256 quantity) internal virtual {
1169         uint256 startTokenId = _currentIndex;
1170         if (to == address(0)) revert MintToZeroAddress();
1171         if (quantity == 0) revert MintZeroQuantity();
1172         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1173 
1174         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1175 
1176         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1177         unchecked {
1178             // Updates:
1179             // - `balance += quantity`.
1180             // - `numberMinted += quantity`.
1181             //
1182             // We can directly add to the `balance` and `numberMinted`.
1183             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1184 
1185             // Updates:
1186             // - `address` to the owner.
1187             // - `startTimestamp` to the timestamp of minting.
1188             // - `burned` to `false`.
1189             // - `nextInitialized` to `quantity == 1`.
1190             _packedOwnerships[startTokenId] = _packOwnershipData(
1191                 to,
1192                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1193             );
1194 
1195             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1196 
1197             _currentIndex = startTokenId + quantity;
1198         }
1199         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1200     }
1201 
1202     /**
1203      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1204      *
1205      * Requirements:
1206      *
1207      * - If `to` refers to a smart contract, it must implement
1208      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1209      * - `quantity` must be greater than 0.
1210      *
1211      * See {_mint}.
1212      *
1213      * Emits a {Transfer} event for each mint.
1214      */
1215     function _safeMint(
1216         address to,
1217         uint256 quantity,
1218         bytes memory _data
1219     ) internal virtual {
1220         _mint(to, quantity);
1221 
1222         unchecked {
1223             if (to.code.length != 0) {
1224                 uint256 end = _currentIndex;
1225                 uint256 index = end - quantity;
1226                 do {
1227                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1228                         revert TransferToNonERC721ReceiverImplementer();
1229                     }
1230                 } while (index < end);
1231                 // Reentrancy protection.
1232                 if (_currentIndex != end) revert();
1233             }
1234         }
1235     }
1236 
1237     /**
1238      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1239      */
1240     function _safeMint(address to, uint256 quantity) internal virtual {
1241         _safeMint(to, quantity, '');
1242     }
1243 
1244     // =============================================================
1245     //                       APPROVAL OPERATIONS
1246     // =============================================================
1247 
1248     /**
1249      * @dev Equivalent to `_approve(to, tokenId, false)`.
1250      */
1251     function _approve(address to, uint256 tokenId) internal virtual {
1252         _approve(to, tokenId, false);
1253     }
1254 
1255     /**
1256      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1257      * The approval is cleared when the token is transferred.
1258      *
1259      * Only a single account can be approved at a time, so approving the
1260      * zero address clears previous approvals.
1261      *
1262      * Requirements:
1263      *
1264      * - `tokenId` must exist.
1265      *
1266      * Emits an {Approval} event.
1267      */
1268     function _approve(
1269         address to,
1270         uint256 tokenId,
1271         bool approvalCheck
1272     ) internal virtual {
1273         address owner = ownerOf(tokenId);
1274 
1275         if (approvalCheck)
1276             if (_msgSenderERC721A() != owner)
1277                 if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1278                     revert ApprovalCallerNotOwnerNorApproved();
1279                 }
1280 
1281         _tokenApprovals[tokenId].value = to;
1282         emit Approval(owner, to, tokenId);
1283     }
1284 
1285     // =============================================================
1286     //                        BURN OPERATIONS
1287     // =============================================================
1288 
1289     /**
1290      * @dev Equivalent to `_burn(tokenId, false)`.
1291      */
1292     function _burn(uint256 tokenId) internal virtual {
1293         _burn(tokenId, false);
1294     }
1295 
1296     /**
1297      * @dev Destroys `tokenId`.
1298      * The approval is cleared when the token is burned.
1299      *
1300      * Requirements:
1301      *
1302      * - `tokenId` must exist.
1303      *
1304      * Emits a {Transfer} event.
1305      */
1306     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1307         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1308 
1309         address from = address(uint160(prevOwnershipPacked));
1310 
1311         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1312 
1313         if (approvalCheck) {
1314             // The nested ifs save around 20+ gas over a compound boolean condition.
1315             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1316                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1317         }
1318 
1319         _beforeTokenTransfers(from, address(0), tokenId, 1);
1320 
1321         // Clear approvals from the previous owner.
1322         assembly {
1323             if approvedAddress {
1324                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1325                 sstore(approvedAddressSlot, 0)
1326             }
1327         }
1328 
1329         // Underflow of the sender's balance is impossible because we check for
1330         // ownership above and the recipient's balance can't realistically overflow.
1331         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1332         unchecked {
1333             // Updates:
1334             // - `balance -= 1`.
1335             // - `numberBurned += 1`.
1336             //
1337             // We can directly decrement the balance, and increment the number burned.
1338             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1339             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1340 
1341             // Updates:
1342             // - `address` to the last owner.
1343             // - `startTimestamp` to the timestamp of burning.
1344             // - `burned` to `true`.
1345             // - `nextInitialized` to `true`.
1346             _packedOwnerships[tokenId] = _packOwnershipData(
1347                 from,
1348                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1349             );
1350 
1351             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1352             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1353                 uint256 nextTokenId = tokenId + 1;
1354                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1355                 if (_packedOwnerships[nextTokenId] == 0) {
1356                     // If the next slot is within bounds.
1357                     if (nextTokenId != _currentIndex) {
1358                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1359                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1360                     }
1361                 }
1362             }
1363         }
1364 
1365         emit Transfer(from, address(0), tokenId);
1366         _afterTokenTransfers(from, address(0), tokenId, 1);
1367 
1368         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1369         unchecked {
1370             _burnCounter++;
1371         }
1372     }
1373 
1374     // =============================================================
1375     //                     EXTRA DATA OPERATIONS
1376     // =============================================================
1377 
1378     /**
1379      * @dev Directly sets the extra data for the ownership data `index`.
1380      */
1381     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1382         uint256 packed = _packedOwnerships[index];
1383         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1384         uint256 extraDataCasted;
1385         // Cast `extraData` with assembly to avoid redundant masking.
1386         assembly {
1387             extraDataCasted := extraData
1388         }
1389         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1390         _packedOwnerships[index] = packed;
1391     }
1392 
1393     /**
1394      * @dev Called during each token transfer to set the 24bit `extraData` field.
1395      * Intended to be overridden by the cosumer contract.
1396      *
1397      * `previousExtraData` - the value of `extraData` before transfer.
1398      *
1399      * Calling conditions:
1400      *
1401      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1402      * transferred to `to`.
1403      * - When `from` is zero, `tokenId` will be minted for `to`.
1404      * - When `to` is zero, `tokenId` will be burned by `from`.
1405      * - `from` and `to` are never both zero.
1406      */
1407     function _extraData(
1408         address from,
1409         address to,
1410         uint24 previousExtraData
1411     ) internal view virtual returns (uint24) {}
1412 
1413     /**
1414      * @dev Returns the next extra data for the packed ownership data.
1415      * The returned result is shifted into position.
1416      */
1417     function _nextExtraData(
1418         address from,
1419         address to,
1420         uint256 prevOwnershipPacked
1421     ) private view returns (uint256) {
1422         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1423         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1424     }
1425 
1426     // =============================================================
1427     //                       OTHER OPERATIONS
1428     // =============================================================
1429 
1430     /**
1431      * @dev Returns the message sender (defaults to `msg.sender`).
1432      *
1433      * If you are writing GSN compatible contracts, you need to override this function.
1434      */
1435     function _msgSenderERC721A() internal view virtual returns (address) {
1436         return msg.sender;
1437     }
1438 
1439     /**
1440      * @dev Converts a uint256 to its ASCII string decimal representation.
1441      */
1442     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1443         assembly {
1444             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1445             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1446             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1447             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1448             let m := add(mload(0x40), 0xa0)
1449             // Update the free memory pointer to allocate.
1450             mstore(0x40, m)
1451             // Assign the `str` to the end.
1452             str := sub(m, 0x20)
1453             // Zeroize the slot after the string.
1454             mstore(str, 0)
1455 
1456             // Cache the end of the memory to calculate the length later.
1457             let end := str
1458 
1459             // We write the string from rightmost digit to leftmost digit.
1460             // The following is essentially a do-while loop that also handles the zero case.
1461             // prettier-ignore
1462             for { let temp := value } 1 {} {
1463                 str := sub(str, 1)
1464                 // Write the character to the pointer.
1465                 // The ASCII index of the '0' character is 48.
1466                 mstore8(str, add(48, mod(temp, 10)))
1467                 // Keep dividing `temp` until zero.
1468                 temp := div(temp, 10)
1469                 // prettier-ignore
1470                 if iszero(temp) { break }
1471             }
1472 
1473             let length := sub(end, str)
1474             // Move the pointer 32 bytes leftwards to make room for the length.
1475             str := sub(str, 0x20)
1476             // Store the length.
1477             mstore(str, length)
1478         }
1479     }
1480 }
1481 
1482 // File: contracts\OpenseaStandard\IOperatorFilterRegistry.sol
1483 
1484 
1485 pragma solidity ^0.8.13;
1486 
1487 interface IOperatorFilterRegistry {
1488     /**
1489      * @notice Returns true if operator is not filtered for a given token, either by address or codeHash. Also returns
1490      *         true if supplied registrant address is not registered.
1491      */
1492     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1493 
1494     /**
1495      * @notice Registers an address with the registry. May be called by address itself or by EIP-173 owner.
1496      */
1497     function register(address registrant) external;
1498 
1499     /**
1500      * @notice Registers an address with the registry and "subscribes" to another address's filtered operators and codeHashes.
1501      */
1502     function registerAndSubscribe(address registrant, address subscription) external;
1503 
1504     /**
1505      * @notice Registers an address with the registry and copies the filtered operators and codeHashes from another
1506      *         address without subscribing.
1507      */
1508     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1509 
1510     /**
1511      * @notice Unregisters an address with the registry and removes its subscription. May be called by address itself or by EIP-173 owner.
1512      *         Note that this does not remove any filtered addresses or codeHashes.
1513      *         Also note that any subscriptions to this registrant will still be active and follow the existing filtered addresses and codehashes.
1514      */
1515     function unregister(address addr) external;
1516 
1517     /**
1518      * @notice Update an operator address for a registered address - when filtered is true, the operator is filtered.
1519      */
1520     function updateOperator(address registrant, address operator, bool filtered) external;
1521 
1522     /**
1523      * @notice Update multiple operators for a registered address - when filtered is true, the operators will be filtered. Reverts on duplicates.
1524      */
1525     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1526 
1527     /**
1528      * @notice Update a codeHash for a registered address - when filtered is true, the codeHash is filtered.
1529      */
1530     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1531 
1532     /**
1533      * @notice Update multiple codeHashes for a registered address - when filtered is true, the codeHashes will be filtered. Reverts on duplicates.
1534      */
1535     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1536 
1537     /**
1538      * @notice Subscribe an address to another registrant's filtered operators and codeHashes. Will remove previous
1539      *         subscription if present.
1540      *         Note that accounts with subscriptions may go on to subscribe to other accounts - in this case,
1541      *         subscriptions will not be forwarded. Instead the former subscription's existing entries will still be
1542      *         used.
1543      */
1544     function subscribe(address registrant, address registrantToSubscribe) external;
1545 
1546     /**
1547      * @notice Unsubscribe an address from its current subscribed registrant, and optionally copy its filtered operators and codeHashes.
1548      */
1549     function unsubscribe(address registrant, bool copyExistingEntries) external;
1550 
1551     /**
1552      * @notice Get the subscription address of a given registrant, if any.
1553      */
1554     function subscriptionOf(address addr) external returns (address registrant);
1555 
1556     /**
1557      * @notice Get the set of addresses subscribed to a given registrant.
1558      *         Note that order is not guaranteed as updates are made.
1559      */
1560     function subscribers(address registrant) external returns (address[] memory);
1561 
1562     /**
1563      * @notice Get the subscriber at a given index in the set of addresses subscribed to a given registrant.
1564      *         Note that order is not guaranteed as updates are made.
1565      */
1566     function subscriberAt(address registrant, uint256 index) external returns (address);
1567 
1568     /**
1569      * @notice Copy filtered operators and codeHashes from a different registrantToCopy to addr.
1570      */
1571     function copyEntriesOf(address registrant, address registrantToCopy) external;
1572 
1573     /**
1574      * @notice Returns true if operator is filtered by a given address or its subscription.
1575      */
1576     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1577 
1578     /**
1579      * @notice Returns true if the hash of an address's code is filtered by a given address or its subscription.
1580      */
1581     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1582 
1583     /**
1584      * @notice Returns true if a codeHash is filtered by a given address or its subscription.
1585      */
1586     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1587 
1588     /**
1589      * @notice Returns a list of filtered operators for a given address or its subscription.
1590      */
1591     function filteredOperators(address addr) external returns (address[] memory);
1592 
1593     /**
1594      * @notice Returns the set of filtered codeHashes for a given address or its subscription.
1595      *         Note that order is not guaranteed as updates are made.
1596      */
1597     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1598 
1599     /**
1600      * @notice Returns the filtered operator at the given index of the set of filtered operators for a given address or
1601      *         its subscription.
1602      *         Note that order is not guaranteed as updates are made.
1603      */
1604     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1605 
1606     /**
1607      * @notice Returns the filtered codeHash at the given index of the list of filtered codeHashes for a given address or
1608      *         its subscription.
1609      *         Note that order is not guaranteed as updates are made.
1610      */
1611     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1612 
1613     /**
1614      * @notice Returns true if an address has registered
1615      */
1616     function isRegistered(address addr) external returns (bool);
1617 
1618     /**
1619      * @dev Convenience method to compute the code hash of an arbitrary contract
1620      */
1621     function codeHashOf(address addr) external returns (bytes32);
1622 }
1623 
1624 // File: contracts\OpenseaStandard\lib\Constants.sol
1625 
1626 
1627 pragma solidity ^0.8.13;
1628 
1629 address constant CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS = 0x000000000000AAeB6D7670E522A718067333cd4E;
1630 address constant CANONICAL_CORI_SUBSCRIPTION = 0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6;
1631 
1632 // File: contracts\OpenseaStandard\OperatorFilterer.sol
1633 
1634 
1635 pragma solidity ^0.8.13;
1636 
1637 
1638 /**
1639  * @title  OperatorFilterer
1640  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
1641  *         registrant's entries in the OperatorFilterRegistry.
1642  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
1643  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
1644  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
1645  *         Please note that if your token contract does not provide an owner with EIP-173, it must provide
1646  *         administration methods on the contract itself to interact with the registry otherwise the subscription
1647  *         will be locked to the options set during construction.
1648  */
1649 
1650 abstract contract OperatorFilterer {
1651     /// @dev Emitted when an operator is not allowed.
1652     error OperatorNotAllowed(address operator);
1653 
1654     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
1655         IOperatorFilterRegistry(CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS);
1656 
1657     /// @dev The constructor that is called when the contract is being deployed.
1658     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1659         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1660         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1661         // order for the modifier to filter addresses.
1662         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1663             if (subscribe) {
1664                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1665             } else {
1666                 if (subscriptionOrRegistrantToCopy != address(0)) {
1667                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1668                 } else {
1669                     OPERATOR_FILTER_REGISTRY.register(address(this));
1670                 }
1671             }
1672         }
1673     }
1674 
1675     /**
1676      * @dev A helper function to check if an operator is allowed.
1677      */
1678     modifier onlyAllowedOperator(address from) virtual {
1679         // Allow spending tokens from addresses with balance
1680         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1681         // from an EOA.
1682         if (from != msg.sender) {
1683             _checkFilterOperator(msg.sender);
1684         }
1685         _;
1686     }
1687 
1688     /**
1689      * @dev A helper function to check if an operator approval is allowed.
1690      */
1691     modifier onlyAllowedOperatorApproval(address operator) virtual {
1692         _checkFilterOperator(operator);
1693         _;
1694     }
1695 
1696     /**
1697      * @dev A helper function to check if an operator is allowed.
1698      */
1699     function _checkFilterOperator(address operator) internal view virtual {
1700         // Check registry code length to facilitate testing in environments without a deployed registry.
1701         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1702             // under normal circumstances, this function will revert rather than return false, but inheriting contracts
1703             // may specify their own OperatorFilterRegistry implementations, which may behave differently
1704             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
1705                 revert OperatorNotAllowed(operator);
1706             }
1707         }
1708     }
1709 }
1710 
1711 // File: contracts\OpenseaStandard\DefaultOperatorFilterer.sol
1712 
1713 
1714 pragma solidity ^0.8.13;
1715 
1716 
1717 /**
1718  * @title  DefaultOperatorFilterer
1719  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
1720  * @dev    Please note that if your token contract does not provide an owner with EIP-173, it must provide
1721  *         administration methods on the contract itself to interact with the registry otherwise the subscription
1722  *         will be locked to the options set during construction.
1723  */
1724 
1725 abstract contract DefaultOperatorFilterer is OperatorFilterer {
1726     /// @dev The constructor that is called when the contract is being deployed.
1727     constructor() OperatorFilterer(CANONICAL_CORI_SUBSCRIPTION, true) {}
1728 }
1729 
1730 // File: contracts\NFTLimit.sol
1731 
1732 pragma solidity ^0.8.13;
1733 abstract contract NFTLimit is ERC721A, DefaultOperatorFilterer {
1734 
1735     mapping(address => bool) public isTransferAllowed;
1736     mapping(uint256 => bool) public nftLock;
1737 
1738      modifier  onlyTransferAllowed(address from) {
1739         require(isTransferAllowed[from],"ERC721: transfer not allowed");
1740         _;
1741     }
1742 
1743      modifier  isNFTLock(uint256 tokenId) {
1744         require(!nftLock[tokenId],"ERC721: NFT is locked");
1745         _;
1746     }
1747 
1748     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator)  {
1749         require(isTransferAllowed[operator],"ERC721: transfer not allowed");
1750         super.setApprovalForAll(operator, approved);
1751     }
1752 
1753      // OpenSea Enforcer functions
1754     function transferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from)  {
1755         require(isTransferAllowed[msg.sender],"ERC721: transfer not allowed");
1756         require(!nftLock[tokenId],"ERC721: NFT is locked");
1757         super.transferFrom(from, to, tokenId);
1758     }
1759 
1760     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from)   {
1761         require(isTransferAllowed[msg.sender],"ERC721: transfer not allowed");
1762         require(!nftLock[tokenId],"ERC721: NFT is locked");
1763         super.safeTransferFrom(from, to, tokenId);
1764     }
1765 
1766     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public payable override onlyAllowedOperator(from)  {
1767         require(isTransferAllowed[msg.sender],"ERC721: transfer not allowed");
1768         require(!nftLock[tokenId],"ERC721: NFT is locked");
1769         super.safeTransferFrom(from, to, tokenId, data);
1770     }
1771 
1772   
1773 }
1774 
1775 // File: contracts\CollectionProxy\CollectionStorage.sol
1776 
1777 pragma solidity ^0.8.13;
1778 
1779 contract CollectionStorage {
1780 
1781 // Counters.Counter tokenIds;
1782 string public baseURI;
1783 mapping(address => bool) public _allowAddress;
1784 
1785 
1786  mapping(uint256 => bytes32) internal whiteListRoot;
1787 
1788  uint256 internal MaxSupply;
1789 
1790  uint256 public status;
1791 
1792  uint256 internal mainPrice;
1793 
1794  address internal seller;
1795 
1796  uint256 internal royalty;
1797 
1798 uint256 public bundleId;
1799  uint256 public perPurchaseNFTToMint;
1800 
1801  
1802 
1803  uint256[] rarity;
1804 
1805  struct SaleDetail {
1806     uint256 startTime;
1807     uint256 endTime;
1808     uint256 price;
1809  }
1810 
1811  mapping (uint256=>SaleDetail) internal _saleDetails;
1812  mapping(address => mapping(uint256 => uint256)) internal userBought;
1813  mapping(uint256 => bool) internal isReserveWhitelist;
1814  mapping(uint256 => uint256) public reservedNFT;
1815  uint256 public perTransactionLimit;
1816 
1817 }
1818 
1819 // File: @openzeppelin\contracts\utils\Context.sol
1820 
1821 
1822 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1823 
1824 pragma solidity ^0.8.0;
1825 
1826 /**
1827  * @dev Provides information about the current execution context, including the
1828  * sender of the transaction and its data. While these are generally available
1829  * via msg.sender and msg.data, they should not be accessed in such a direct
1830  * manner, since when dealing with meta-transactions the account sending and
1831  * paying for execution may not be the actual sender (as far as an application
1832  * is concerned).
1833  *
1834  * This contract is only required for intermediate, library-like contracts.
1835  */
1836 abstract contract Context {
1837     function _msgSender() internal view virtual returns (address) {
1838         return msg.sender;
1839     }
1840 
1841     function _msgData() internal view virtual returns (bytes calldata) {
1842         return msg.data;
1843     }
1844 }
1845 
1846 // File: contracts\CollectionProxy\Ownable.sol
1847 
1848 
1849 
1850 pragma solidity ^0.8.0;
1851 /**
1852  * @dev Contract module which provides a basic access control mechanism, where
1853  * there is an account (an owner) that can be granted exclusive access to
1854  * specific functions.
1855  *
1856  * By default, the owner account will be the one that deploys the contract. This
1857  * can later be changed with {transferOwnership}.
1858  *
1859  * This module is used through inheritance. It will make available the modifier
1860  * `onlyOwner`, which can be applied to your functions to restrict their use to
1861  * the owner.
1862  */
1863 abstract contract Ownable is Context {
1864     address private _owner;
1865 
1866     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1867 
1868     /**
1869      * @dev Initializes the contract setting the deployer as the initial owner.
1870      */
1871     constructor() {
1872         _setOwner(_msgSender());
1873     }
1874 
1875     /**
1876      * @dev Returns the address of the current owner.
1877      */
1878     function owner() public view virtual returns (address) {
1879         return _owner;
1880     }
1881 
1882     /**
1883      * @dev Throws if called by any account other than the owner.
1884      */
1885     modifier onlyOwner() {
1886         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1887         _;
1888     }
1889 
1890     /**
1891      * @dev Leaves the contract without owner. It will not be possible to call
1892      * `onlyOwner` functions anymore. Can only be called by the current owner.
1893      *
1894      * NOTE: Renouncing ownership will leave the contract without an owner,
1895      * thereby removing any functionality that is only available to the owner.
1896      */
1897     function renounceOwnership() public virtual onlyOwner {
1898         _setOwner(address(0));
1899     }
1900 
1901     /**
1902      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1903      * Can only be called by the current owner.
1904      */
1905     function transferOwnership(address newOwner) public virtual onlyOwner {
1906         require(newOwner != address(0), "Ownable: new owner is the zero address");
1907         _setOwner(newOwner);
1908     }
1909 
1910     function _setOwner(address newOwner) internal {
1911         address oldOwner = _owner;
1912         _owner = newOwner;
1913         emit OwnershipTransferred(oldOwner, newOwner);
1914     }
1915 }
1916 
1917 // File: @openzeppelin\contracts\utils\Strings.sol
1918 
1919 
1920 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
1921 
1922 pragma solidity ^0.8.0;
1923 
1924 /**
1925  * @dev String operations.
1926  */
1927 library Strings {
1928     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1929     uint8 private constant _ADDRESS_LENGTH = 20;
1930 
1931     /**
1932      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1933      */
1934     function toString(uint256 value) internal pure returns (string memory) {
1935         // Inspired by OraclizeAPI's implementation - MIT licence
1936         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1937 
1938         if (value == 0) {
1939             return "0";
1940         }
1941         uint256 temp = value;
1942         uint256 digits;
1943         while (temp != 0) {
1944             digits++;
1945             temp /= 10;
1946         }
1947         bytes memory buffer = new bytes(digits);
1948         while (value != 0) {
1949             digits -= 1;
1950             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1951             value /= 10;
1952         }
1953         return string(buffer);
1954     }
1955 
1956     /**
1957      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1958      */
1959     function toHexString(uint256 value) internal pure returns (string memory) {
1960         if (value == 0) {
1961             return "0x00";
1962         }
1963         uint256 temp = value;
1964         uint256 length = 0;
1965         while (temp != 0) {
1966             length++;
1967             temp >>= 8;
1968         }
1969         return toHexString(value, length);
1970     }
1971 
1972     /**
1973      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1974      */
1975     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1976         bytes memory buffer = new bytes(2 * length + 2);
1977         buffer[0] = "0";
1978         buffer[1] = "x";
1979         for (uint256 i = 2 * length + 1; i > 1; --i) {
1980             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1981             value >>= 4;
1982         }
1983         require(value == 0, "Strings: hex length insufficient");
1984         return string(buffer);
1985     }
1986 
1987     /**
1988      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1989      */
1990     function toHexString(address addr) internal pure returns (string memory) {
1991         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1992     }
1993 }
1994 
1995 // File: contracts\CollectionProxy\CollectionProxy.sol
1996 
1997 pragma solidity ^0.8.13;
1998 ///////////////////////////////////////////////////////////////////////////////////////////////////
1999 /**
2000  * @title ProxyReceiver Contract
2001  * @dev Handles forwarding calls to receiver delegates while offering transparency of updates.
2002  *      Follows ERC-1538 standard.
2003  *
2004  *    NOTE: Not recommended for direct use in a production contract, as no security control.
2005  *          Provided as simple example only.
2006  */
2007 ///////////////////////////////////////////////////////////////////////////////////////////////////
2008 
2009 contract CollectionProxy is ProxyBaseStorage, IERC1538, NFTLimit, Ownable, CollectionStorage {
2010 using Strings for uint256;
2011 
2012     constructor(address implementation)ERC721A("XANA x BreakingDown", "BD") {
2013 
2014         proxy = address(this);
2015         _allowAddress[msg.sender] = true;
2016         baseURI = "https://testapi.xanalia.com/xanalia/get-nft-meta?tokenId=";
2017         MaxSupply = 4801;
2018         //Adding ERC1538 updateContract function
2019         bytes memory signature = "updateContract(address,string,string)";
2020          constructorRegisterFunction(signature, proxy);
2021          bytes memory setBaseURISig = "setBaseURI(string)";
2022          constructorRegisterFunction(setBaseURISig, implementation);
2023          setBaseURISig = "getUserBoughtCount(address,uint256)";
2024          constructorRegisterFunction(setBaseURISig, implementation);
2025          setBaseURISig = "isWhitelisted(address,bytes32[],uint256,uint256)";
2026          constructorRegisterFunction(setBaseURISig, implementation);
2027          setBaseURISig = "mint(address,uint256)";
2028          constructorRegisterFunction(setBaseURISig, implementation);
2029          setBaseURISig = "setSeed(uint256)";
2030          constructorRegisterFunction(setBaseURISig, implementation);
2031          setBaseURISig = "preOrder(bytes32[],uint256,uint256)";
2032          constructorRegisterFunction(setBaseURISig, implementation);
2033          setBaseURISig = "claim()";
2034          constructorRegisterFunction(setBaseURISig, implementation);
2035          setBaseURISig = "buy(bytes32[],uint256,bool,uint256)";
2036          constructorRegisterFunction(setBaseURISig, implementation);
2037          setBaseURISig = "burnAdmin(uint256)";
2038          constructorRegisterFunction(setBaseURISig, implementation);
2039          setBaseURISig = "setWhitelistRoot(bytes32,uint256,bool)";
2040          constructorRegisterFunction(setBaseURISig, implementation);
2041          setBaseURISig = "setAuthor(address)";
2042          constructorRegisterFunction(setBaseURISig, implementation);
2043          setBaseURISig = "setMaxSupply(uint256)";
2044          constructorRegisterFunction(setBaseURISig, implementation);
2045          setBaseURISig = "setStatus(uint256)";
2046          constructorRegisterFunction(setBaseURISig, implementation);
2047          setBaseURISig = "setTransferAllowed(address,bool)";
2048          constructorRegisterFunction(setBaseURISig, implementation);
2049          setBaseURISig = "setSaleDetails(uint256,uint256,uint256)";
2050          constructorRegisterFunction(setBaseURISig, implementation);
2051          setBaseURISig = "setPerBundleNFTToMint(uint256)";
2052          constructorRegisterFunction(setBaseURISig, implementation);
2053          setBaseURISig = "setPerTransactionLimit(uint256)";
2054          constructorRegisterFunction(setBaseURISig, implementation);
2055          setBaseURISig = "tokenURI(uint256)";
2056          constructorRegisterFunction(setBaseURISig, implementation);
2057          setBaseURISig = "setPrice(uint256)";
2058          constructorRegisterFunction(setBaseURISig, implementation);
2059          setBaseURISig = "setRoyalty(uint256)";
2060          constructorRegisterFunction(setBaseURISig, implementation);
2061          setBaseURISig = "getPrice()";
2062          constructorRegisterFunction(setBaseURISig, implementation);
2063          setBaseURISig = "getMaxSupply()";
2064          constructorRegisterFunction(setBaseURISig, implementation);
2065          setBaseURISig = "getAuthor(uint256)";
2066          constructorRegisterFunction(setBaseURISig, implementation);
2067          setBaseURISig = "getRoyaltyFee(uint256)";
2068          constructorRegisterFunction(setBaseURISig, implementation);
2069          setBaseURISig = "getCreator(uint256)";
2070          constructorRegisterFunction(setBaseURISig, implementation);
2071          setBaseURISig = "getSaleDetails(uint256)public view returns(uint256,uint256)";
2072          constructorRegisterFunction(setBaseURISig, implementation);
2073     }
2074 
2075      function constructorRegisterFunction(bytes memory signature, address proxy) internal {
2076         bytes4 funcId = bytes4(keccak256(signature));
2077         delegates[funcId] = proxy;
2078         funcSignatures.push(signature);
2079         funcSignatureToIndex[signature] = funcSignatures.length;
2080        
2081         emit FunctionUpdate(funcId, address(0), proxy, string(signature));
2082         
2083         emit CommitMessage("Added ERC1538 updateContract function at contract creation");
2084     }
2085 
2086     ///////////////////////////////////////////////////////////////////////////////////////////////
2087 
2088     fallback() external payable {
2089         if (msg.sig == bytes4(0) && msg.value != uint(0)) { // skipping ethers/BNB received to delegate
2090             return;
2091         }
2092         address delegate = delegates[msg.sig];
2093         require(delegate != address(0), "Function does not exist.");
2094         assembly {
2095             let ptr := mload(0x40)
2096             calldatacopy(ptr, 0, calldatasize())
2097             let result := delegatecall(gas(), delegate, ptr, calldatasize(), 0, 0)
2098             let size := returndatasize()
2099             returndatacopy(ptr, 0, size)
2100             switch result
2101             case 0 {revert(ptr, size)}
2102             default {return (ptr, size)}
2103         }
2104     }
2105 
2106     ///////////////////////////////////////////////////////////////////////////////////////////////
2107 
2108     /// @notice Updates functions in a transparent contract.
2109     /// @dev If the value of _delegate is zero then the functions specified
2110     ///  in _functionSignatures are removed.
2111     ///  If the value of _delegate is a delegate contract address then the functions
2112     ///  specified in _functionSignatures will be delegated to that address.
2113     /// @param _delegate The address of a delegate contract to delegate to or zero
2114     /// @param _functionSignatures A list of function signatures listed one after the other
2115     /// @param _commitMessage A short description of the change and why it is made
2116     ///        This message is passed to the CommitMessage event.
2117     function updateContract(address _delegate, string calldata _functionSignatures, string calldata _commitMessage) override onlyOwner external {
2118         // pos is first used to check the size of the delegate contract.
2119         // After that pos is the current memory location of _functionSignatures.
2120         // It is used to move through the characters of _functionSignatures
2121         uint256 pos;
2122         if(_delegate != address(0)) {
2123             assembly {
2124                 pos := extcodesize(_delegate)
2125             }
2126             require(pos > 0, "_delegate address is not a contract and is not address(0)");
2127         }
2128 
2129         // creates a bytes version of _functionSignatures
2130         bytes memory signatures = bytes(_functionSignatures);
2131         // stores the position in memory where _functionSignatures ends.
2132         uint256 signaturesEnd;
2133         // stores the starting position of a function signature in _functionSignatures
2134         uint256 start;
2135         assembly {
2136             pos := add(signatures,32)
2137             start := pos
2138             signaturesEnd := add(pos,mload(signatures))
2139         }
2140         // the function id of the current function signature
2141         bytes4 funcId;
2142         // the delegate address that is being replaced or address(0) if removing functions
2143         address oldDelegate;
2144         // the length of the current function signature in _functionSignatures
2145         uint256 num;
2146         // the current character in _functionSignatures
2147         uint256 char;
2148         // the position of the current function signature in the funcSignatures array
2149         uint256 index;
2150         // the last position in the funcSignatures array
2151         uint256 lastIndex;
2152         // parse the _functionSignatures string and handle each function
2153         for (; pos < signaturesEnd; pos++) {
2154             assembly {char := byte(0,mload(pos))}
2155             // 0x29 == )
2156             if (char == 0x29) {
2157                 pos++;
2158                 num = (pos - start);
2159                 start = pos;
2160                 assembly {
2161                     mstore(signatures,num)
2162                 }
2163                 funcId = bytes4(keccak256(signatures));
2164                 oldDelegate = delegates[funcId];
2165                 if(_delegate == address(0)) {
2166                     index = funcSignatureToIndex[signatures];
2167                     require(index != 0, "Function does not exist.");
2168                     index--;
2169                     lastIndex = funcSignatures.length - 1;
2170                     if (index != lastIndex) {
2171                         funcSignatures[index] = funcSignatures[lastIndex];
2172                         funcSignatureToIndex[funcSignatures[lastIndex]] = index + 1;
2173                     }
2174                     funcSignatures.pop();
2175                     delete funcSignatureToIndex[signatures];
2176                     delete delegates[funcId];
2177                     emit FunctionUpdate(funcId, oldDelegate, address(0), string(signatures));
2178                 }
2179                 else if (funcSignatureToIndex[signatures] == 0) {
2180                     require(oldDelegate == address(0), "FuncId clash.");
2181                     delegates[funcId] = _delegate;
2182                     funcSignatures.push(signatures);
2183                     funcSignatureToIndex[signatures] = funcSignatures.length;
2184                     emit FunctionUpdate(funcId, address(0), _delegate, string(signatures));
2185                 }
2186                 else if (delegates[funcId] != _delegate) {
2187                     delegates[funcId] = _delegate;
2188                     emit FunctionUpdate(funcId, oldDelegate, _delegate, string(signatures));
2189 
2190                 }
2191                 assembly {signatures := add(signatures,num)}
2192             }
2193         }
2194         emit CommitMessage(_commitMessage);
2195     }
2196 
2197     function _baseURI() internal view virtual override returns (string memory) {
2198       return baseURI;
2199     }
2200 
2201  /**
2202      * @dev See {IERC721Metadata-tokenURI}.
2203      */
2204     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2205         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
2206 
2207         string memory baseURI = _baseURI();
2208         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
2209     }
2210 
2211     ///////////////////////////////////////////////////////////////////////////////////////////////
2212 
2213 }
2214 
2215 ///////////////////////////////////////////////////////////////////////////////////////////////////