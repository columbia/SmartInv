1 // 
2 // .__ .___.  ..___.  .  .._..__  __.  
3 // [__)[__ |_/   |    |_/  | |  \(__   
4 // |  \[___|  \  |    |  \_|_|__/.__)  
5 //                                     
6 //
7 
8 // File: erc721a/contracts/IERC721A.sol
9 
10 
11 // ERC721A Contracts v4.2.2
12 // Creator: Chiru Labs
13 
14 pragma solidity ^0.8.4;
15 
16 /**
17  * @dev Interface of ERC721A.
18  */
19 interface IERC721A {
20     /**
21      * The caller must own the token or be an approved operator.
22      */
23     error ApprovalCallerNotOwnerNorApproved();
24 
25     /**
26      * The token does not exist.
27      */
28     error ApprovalQueryForNonexistentToken();
29 
30     /**
31      * The caller cannot approve to their own address.
32      */
33     error ApproveToCaller();
34 
35     /**
36      * Cannot query the balance for the zero address.
37      */
38     error BalanceQueryForZeroAddress();
39 
40     /**
41      * Cannot mint to the zero address.
42      */
43     error MintToZeroAddress();
44 
45     /**
46      * The quantity of tokens minted must be more than zero.
47      */
48     error MintZeroQuantity();
49 
50     /**
51      * The token does not exist.
52      */
53     error OwnerQueryForNonexistentToken();
54 
55     /**
56      * The caller must own the token or be an approved operator.
57      */
58     error TransferCallerNotOwnerNorApproved();
59 
60     /**
61      * The token must be owned by `from`.
62      */
63     error TransferFromIncorrectOwner();
64 
65     /**
66      * Cannot safely transfer to a contract that does not implement the
67      * ERC721Receiver interface.
68      */
69     error TransferToNonERC721ReceiverImplementer();
70 
71     /**
72      * Cannot transfer to the zero address.
73      */
74     error TransferToZeroAddress();
75 
76     /**
77      * The token does not exist.
78      */
79     error URIQueryForNonexistentToken();
80 
81     /**
82      * The `quantity` minted with ERC2309 exceeds the safety limit.
83      */
84     error MintERC2309QuantityExceedsLimit();
85 
86     /**
87      * The `extraData` cannot be set on an unintialized ownership slot.
88      */
89     error OwnershipNotInitializedForExtraData();
90 
91     // =============================================================
92     //                            STRUCTS
93     // =============================================================
94 
95     struct TokenOwnership {
96         // The address of the owner.
97         address addr;
98         // Stores the start time of ownership with minimal overhead for tokenomics.
99         uint64 startTimestamp;
100         // Whether the token has been burned.
101         bool burned;
102         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
103         uint24 extraData;
104     }
105 
106     // =============================================================
107     //                         TOKEN COUNTERS
108     // =============================================================
109 
110     /**
111      * @dev Returns the total number of tokens in existence.
112      * Burned tokens will reduce the count.
113      * To get the total number of tokens minted, please see {_totalMinted}.
114      */
115     function totalSupply() external view returns (uint256);
116 
117     // =============================================================
118     //                            IERC165
119     // =============================================================
120 
121     /**
122      * @dev Returns true if this contract implements the interface defined by
123      * `interfaceId`. See the corresponding
124      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
125      * to learn more about how these ids are created.
126      *
127      * This function call must use less than 30000 gas.
128      */
129     function supportsInterface(bytes4 interfaceId) external view returns (bool);
130 
131     // =============================================================
132     //                            IERC721
133     // =============================================================
134 
135     /**
136      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
137      */
138     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
139 
140     /**
141      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
142      */
143     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
144 
145     /**
146      * @dev Emitted when `owner` enables or disables
147      * (`approved`) `operator` to manage all of its assets.
148      */
149     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
150 
151     /**
152      * @dev Returns the number of tokens in `owner`'s account.
153      */
154     function balanceOf(address owner) external view returns (uint256 balance);
155 
156     /**
157      * @dev Returns the owner of the `tokenId` token.
158      *
159      * Requirements:
160      *
161      * - `tokenId` must exist.
162      */
163     function ownerOf(uint256 tokenId) external view returns (address owner);
164 
165     /**
166      * @dev Safely transfers `tokenId` token from `from` to `to`,
167      * checking first that contract recipients are aware of the ERC721 protocol
168      * to prevent tokens from being forever locked.
169      *
170      * Requirements:
171      *
172      * - `from` cannot be the zero address.
173      * - `to` cannot be the zero address.
174      * - `tokenId` token must exist and be owned by `from`.
175      * - If the caller is not `from`, it must be have been allowed to move
176      * this token by either {approve} or {setApprovalForAll}.
177      * - If `to` refers to a smart contract, it must implement
178      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
179      *
180      * Emits a {Transfer} event.
181      */
182     function safeTransferFrom(
183         address from,
184         address to,
185         uint256 tokenId,
186         bytes calldata data
187     ) external;
188 
189     /**
190      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
191      */
192     function safeTransferFrom(
193         address from,
194         address to,
195         uint256 tokenId
196     ) external;
197 
198     /**
199      * @dev Transfers `tokenId` from `from` to `to`.
200      *
201      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
202      * whenever possible.
203      *
204      * Requirements:
205      *
206      * - `from` cannot be the zero address.
207      * - `to` cannot be the zero address.
208      * - `tokenId` token must be owned by `from`.
209      * - If the caller is not `from`, it must be approved to move this token
210      * by either {approve} or {setApprovalForAll}.
211      *
212      * Emits a {Transfer} event.
213      */
214     function transferFrom(
215         address from,
216         address to,
217         uint256 tokenId
218     ) external;
219 
220     /**
221      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
222      * The approval is cleared when the token is transferred.
223      *
224      * Only a single account can be approved at a time, so approving the
225      * zero address clears previous approvals.
226      *
227      * Requirements:
228      *
229      * - The caller must own the token or be an approved operator.
230      * - `tokenId` must exist.
231      *
232      * Emits an {Approval} event.
233      */
234     function approve(address to, uint256 tokenId) external;
235 
236     /**
237      * @dev Approve or remove `operator` as an operator for the caller.
238      * Operators can call {transferFrom} or {safeTransferFrom}
239      * for any token owned by the caller.
240      *
241      * Requirements:
242      *
243      * - The `operator` cannot be the caller.
244      *
245      * Emits an {ApprovalForAll} event.
246      */
247     function setApprovalForAll(address operator, bool _approved) external;
248 
249     /**
250      * @dev Returns the account approved for `tokenId` token.
251      *
252      * Requirements:
253      *
254      * - `tokenId` must exist.
255      */
256     function getApproved(uint256 tokenId) external view returns (address operator);
257 
258     /**
259      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
260      *
261      * See {setApprovalForAll}.
262      */
263     function isApprovedForAll(address owner, address operator) external view returns (bool);
264 
265     // =============================================================
266     //                        IERC721Metadata
267     // =============================================================
268 
269     /**
270      * @dev Returns the token collection name.
271      */
272     function name() external view returns (string memory);
273 
274     /**
275      * @dev Returns the token collection symbol.
276      */
277     function symbol() external view returns (string memory);
278 
279     /**
280      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
281      */
282     function tokenURI(uint256 tokenId) external view returns (string memory);
283 
284     // =============================================================
285     //                           IERC2309
286     // =============================================================
287 
288     /**
289      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
290      * (inclusive) is transferred from `from` to `to`, as defined in the
291      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
292      *
293      * See {_mintERC2309} for more details.
294      */
295     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
296 }
297 
298 // File: erc721a/contracts/ERC721A.sol
299 
300 
301 // ERC721A Contracts v4.2.2
302 // Creator: Chiru Labs
303 
304 pragma solidity ^0.8.4;
305 
306 
307 /**
308  * @dev Interface of ERC721 token receiver.
309  */
310 interface ERC721A__IERC721Receiver {
311     function onERC721Received(
312         address operator,
313         address from,
314         uint256 tokenId,
315         bytes calldata data
316     ) external returns (bytes4);
317 }
318 
319 /**
320  * @title ERC721A
321  *
322  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
323  * Non-Fungible Token Standard, including the Metadata extension.
324  * Optimized for lower gas during batch mints.
325  *
326  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
327  * starting from `_startTokenId()`.
328  *
329  * Assumptions:
330  *
331  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
332  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
333  */
334 contract ERC721A is IERC721A {
335     // Reference type for token approval.
336     struct TokenApprovalRef {
337         address value;
338     }
339 
340     // =============================================================
341     //                           CONSTANTS
342     // =============================================================
343 
344     // Mask of an entry in packed address data.
345     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
346 
347     // The bit position of `numberMinted` in packed address data.
348     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
349 
350     // The bit position of `numberBurned` in packed address data.
351     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
352 
353     // The bit position of `aux` in packed address data.
354     uint256 private constant _BITPOS_AUX = 192;
355 
356     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
357     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
358 
359     // The bit position of `startTimestamp` in packed ownership.
360     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
361 
362     // The bit mask of the `burned` bit in packed ownership.
363     uint256 private constant _BITMASK_BURNED = 1 << 224;
364 
365     // The bit position of the `nextInitialized` bit in packed ownership.
366     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
367 
368     // The bit mask of the `nextInitialized` bit in packed ownership.
369     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
370 
371     // The bit position of `extraData` in packed ownership.
372     uint256 private constant _BITPOS_EXTRA_DATA = 232;
373 
374     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
375     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
376 
377     // The mask of the lower 160 bits for addresses.
378     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
379 
380     // The maximum `quantity` that can be minted with {_mintERC2309}.
381     // This limit is to prevent overflows on the address data entries.
382     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
383     // is required to cause an overflow, which is unrealistic.
384     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
385 
386     // The `Transfer` event signature is given by:
387     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
388     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
389         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
390 
391     // =============================================================
392     //                            STORAGE
393     // =============================================================
394 
395     // The next token ID to be minted.
396     uint256 private _currentIndex;
397 
398     // The number of tokens burned.
399     uint256 private _burnCounter;
400 
401     // Token name
402     string private _name;
403 
404     // Token symbol
405     string private _symbol;
406 
407     // Mapping from token ID to ownership details
408     // An empty struct value does not necessarily mean the token is unowned.
409     // See {_packedOwnershipOf} implementation for details.
410     //
411     // Bits Layout:
412     // - [0..159]   `addr`
413     // - [160..223] `startTimestamp`
414     // - [224]      `burned`
415     // - [225]      `nextInitialized`
416     // - [232..255] `extraData`
417     mapping(uint256 => uint256) private _packedOwnerships;
418 
419     // Mapping owner address to address data.
420     //
421     // Bits Layout:
422     // - [0..63]    `balance`
423     // - [64..127]  `numberMinted`
424     // - [128..191] `numberBurned`
425     // - [192..255] `aux`
426     mapping(address => uint256) private _packedAddressData;
427 
428     // Mapping from token ID to approved address.
429     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
430 
431     // Mapping from owner to operator approvals
432     mapping(address => mapping(address => bool)) private _operatorApprovals;
433 
434     // =============================================================
435     //                          CONSTRUCTOR
436     // =============================================================
437 
438     constructor(string memory name_, string memory symbol_) {
439         _name = name_;
440         _symbol = symbol_;
441         _currentIndex = _startTokenId();
442     }
443 
444     // =============================================================
445     //                   TOKEN COUNTING OPERATIONS
446     // =============================================================
447 
448     /**
449      * @dev Returns the starting token ID.
450      * To change the starting token ID, please override this function.
451      */
452     function _startTokenId() internal view virtual returns (uint256) {
453         return 0;
454     }
455 
456     /**
457      * @dev Returns the next token ID to be minted.
458      */
459     function _nextTokenId() internal view virtual returns (uint256) {
460         return _currentIndex;
461     }
462 
463     /**
464      * @dev Returns the total number of tokens in existence.
465      * Burned tokens will reduce the count.
466      * To get the total number of tokens minted, please see {_totalMinted}.
467      */
468     function totalSupply() public view virtual override returns (uint256) {
469         // Counter underflow is impossible as _burnCounter cannot be incremented
470         // more than `_currentIndex - _startTokenId()` times.
471         unchecked {
472             return _currentIndex - _burnCounter - _startTokenId();
473         }
474     }
475 
476     /**
477      * @dev Returns the total amount of tokens minted in the contract.
478      */
479     function _totalMinted() internal view virtual returns (uint256) {
480         // Counter underflow is impossible as `_currentIndex` does not decrement,
481         // and it is initialized to `_startTokenId()`.
482         unchecked {
483             return _currentIndex - _startTokenId();
484         }
485     }
486 
487     /**
488      * @dev Returns the total number of tokens burned.
489      */
490     function _totalBurned() internal view virtual returns (uint256) {
491         return _burnCounter;
492     }
493 
494     // =============================================================
495     //                    ADDRESS DATA OPERATIONS
496     // =============================================================
497 
498     /**
499      * @dev Returns the number of tokens in `owner`'s account.
500      */
501     function balanceOf(address owner) public view virtual override returns (uint256) {
502         if (owner == address(0)) revert BalanceQueryForZeroAddress();
503         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
504     }
505 
506     /**
507      * Returns the number of tokens minted by `owner`.
508      */
509     function _numberMinted(address owner) internal view returns (uint256) {
510         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
511     }
512 
513     /**
514      * Returns the number of tokens burned by or on behalf of `owner`.
515      */
516     function _numberBurned(address owner) internal view returns (uint256) {
517         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
518     }
519 
520     /**
521      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
522      */
523     function _getAux(address owner) internal view returns (uint64) {
524         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
525     }
526 
527     /**
528      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
529      * If there are multiple variables, please pack them into a uint64.
530      */
531     function _setAux(address owner, uint64 aux) internal virtual {
532         uint256 packed = _packedAddressData[owner];
533         uint256 auxCasted;
534         // Cast `aux` with assembly to avoid redundant masking.
535         assembly {
536             auxCasted := aux
537         }
538         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
539         _packedAddressData[owner] = packed;
540     }
541 
542     // =============================================================
543     //                            IERC165
544     // =============================================================
545 
546     /**
547      * @dev Returns true if this contract implements the interface defined by
548      * `interfaceId`. See the corresponding
549      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
550      * to learn more about how these ids are created.
551      *
552      * This function call must use less than 30000 gas.
553      */
554     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
555         // The interface IDs are constants representing the first 4 bytes
556         // of the XOR of all function selectors in the interface.
557         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
558         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
559         return
560             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
561             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
562             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
563     }
564 
565     // =============================================================
566     //                        IERC721Metadata
567     // =============================================================
568 
569     /**
570      * @dev Returns the token collection name.
571      */
572     function name() public view virtual override returns (string memory) {
573         return _name;
574     }
575 
576     /**
577      * @dev Returns the token collection symbol.
578      */
579     function symbol() public view virtual override returns (string memory) {
580         return _symbol;
581     }
582 
583     /**
584      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
585      */
586     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
587         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
588 
589         string memory baseURI = _baseURI();
590         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
591     }
592 
593     /**
594      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
595      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
596      * by default, it can be overridden in child contracts.
597      */
598     function _baseURI() internal view virtual returns (string memory) {
599         return '';
600     }
601 
602     // =============================================================
603     //                     OWNERSHIPS OPERATIONS
604     // =============================================================
605 
606     /**
607      * @dev Returns the owner of the `tokenId` token.
608      *
609      * Requirements:
610      *
611      * - `tokenId` must exist.
612      */
613     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
614         return address(uint160(_packedOwnershipOf(tokenId)));
615     }
616 
617     /**
618      * @dev Gas spent here starts off proportional to the maximum mint batch size.
619      * It gradually moves to O(1) as tokens get transferred around over time.
620      */
621     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
622         return _unpackedOwnership(_packedOwnershipOf(tokenId));
623     }
624 
625     /**
626      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
627      */
628     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
629         return _unpackedOwnership(_packedOwnerships[index]);
630     }
631 
632     /**
633      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
634      */
635     function _initializeOwnershipAt(uint256 index) internal virtual {
636         if (_packedOwnerships[index] == 0) {
637             _packedOwnerships[index] = _packedOwnershipOf(index);
638         }
639     }
640 
641     /**
642      * Returns the packed ownership data of `tokenId`.
643      */
644     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
645         uint256 curr = tokenId;
646 
647         unchecked {
648             if (_startTokenId() <= curr)
649                 if (curr < _currentIndex) {
650                     uint256 packed = _packedOwnerships[curr];
651                     // If not burned.
652                     if (packed & _BITMASK_BURNED == 0) {
653                         // Invariant:
654                         // There will always be an initialized ownership slot
655                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
656                         // before an unintialized ownership slot
657                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
658                         // Hence, `curr` will not underflow.
659                         //
660                         // We can directly compare the packed value.
661                         // If the address is zero, packed will be zero.
662                         while (packed == 0) {
663                             packed = _packedOwnerships[--curr];
664                         }
665                         return packed;
666                     }
667                 }
668         }
669         revert OwnerQueryForNonexistentToken();
670     }
671 
672     /**
673      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
674      */
675     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
676         ownership.addr = address(uint160(packed));
677         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
678         ownership.burned = packed & _BITMASK_BURNED != 0;
679         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
680     }
681 
682     /**
683      * @dev Packs ownership data into a single uint256.
684      */
685     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
686         assembly {
687             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
688             owner := and(owner, _BITMASK_ADDRESS)
689             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
690             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
691         }
692     }
693 
694     /**
695      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
696      */
697     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
698         // For branchless setting of the `nextInitialized` flag.
699         assembly {
700             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
701             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
702         }
703     }
704 
705     // =============================================================
706     //                      APPROVAL OPERATIONS
707     // =============================================================
708 
709     /**
710      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
711      * The approval is cleared when the token is transferred.
712      *
713      * Only a single account can be approved at a time, so approving the
714      * zero address clears previous approvals.
715      *
716      * Requirements:
717      *
718      * - The caller must own the token or be an approved operator.
719      * - `tokenId` must exist.
720      *
721      * Emits an {Approval} event.
722      */
723     function approve(address to, uint256 tokenId) public virtual override {
724         address owner = ownerOf(tokenId);
725 
726         if (_msgSenderERC721A() != owner)
727             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
728                 revert ApprovalCallerNotOwnerNorApproved();
729             }
730 
731         _tokenApprovals[tokenId].value = to;
732         emit Approval(owner, to, tokenId);
733     }
734 
735     /**
736      * @dev Returns the account approved for `tokenId` token.
737      *
738      * Requirements:
739      *
740      * - `tokenId` must exist.
741      */
742     function getApproved(uint256 tokenId) public view virtual override returns (address) {
743         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
744 
745         return _tokenApprovals[tokenId].value;
746     }
747 
748     /**
749      * @dev Approve or remove `operator` as an operator for the caller.
750      * Operators can call {transferFrom} or {safeTransferFrom}
751      * for any token owned by the caller.
752      *
753      * Requirements:
754      *
755      * - The `operator` cannot be the caller.
756      *
757      * Emits an {ApprovalForAll} event.
758      */
759     function setApprovalForAll(address operator, bool approved) public virtual override {
760         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
761 
762         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
763         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
764     }
765 
766     /**
767      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
768      *
769      * See {setApprovalForAll}.
770      */
771     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
772         return _operatorApprovals[owner][operator];
773     }
774 
775     /**
776      * @dev Returns whether `tokenId` exists.
777      *
778      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
779      *
780      * Tokens start existing when they are minted. See {_mint}.
781      */
782     function _exists(uint256 tokenId) internal view virtual returns (bool) {
783         return
784             _startTokenId() <= tokenId &&
785             tokenId < _currentIndex && // If within bounds,
786             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
787     }
788 
789     /**
790      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
791      */
792     function _isSenderApprovedOrOwner(
793         address approvedAddress,
794         address owner,
795         address msgSender
796     ) private pure returns (bool result) {
797         assembly {
798             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
799             owner := and(owner, _BITMASK_ADDRESS)
800             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
801             msgSender := and(msgSender, _BITMASK_ADDRESS)
802             // `msgSender == owner || msgSender == approvedAddress`.
803             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
804         }
805     }
806 
807     /**
808      * @dev Returns the storage slot and value for the approved address of `tokenId`.
809      */
810     function _getApprovedSlotAndAddress(uint256 tokenId)
811         private
812         view
813         returns (uint256 approvedAddressSlot, address approvedAddress)
814     {
815         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
816         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
817         assembly {
818             approvedAddressSlot := tokenApproval.slot
819             approvedAddress := sload(approvedAddressSlot)
820         }
821     }
822 
823     // =============================================================
824     //                      TRANSFER OPERATIONS
825     // =============================================================
826 
827     /**
828      * @dev Transfers `tokenId` from `from` to `to`.
829      *
830      * Requirements:
831      *
832      * - `from` cannot be the zero address.
833      * - `to` cannot be the zero address.
834      * - `tokenId` token must be owned by `from`.
835      * - If the caller is not `from`, it must be approved to move this token
836      * by either {approve} or {setApprovalForAll}.
837      *
838      * Emits a {Transfer} event.
839      */
840     function transferFrom(
841         address from,
842         address to,
843         uint256 tokenId
844     ) public virtual override {
845         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
846 
847         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
848 
849         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
850 
851         // The nested ifs save around 20+ gas over a compound boolean condition.
852         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
853             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
854 
855         if (to == address(0)) revert TransferToZeroAddress();
856 
857         _beforeTokenTransfers(from, to, tokenId, 1);
858 
859         // Clear approvals from the previous owner.
860         assembly {
861             if approvedAddress {
862                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
863                 sstore(approvedAddressSlot, 0)
864             }
865         }
866 
867         // Underflow of the sender's balance is impossible because we check for
868         // ownership above and the recipient's balance can't realistically overflow.
869         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
870         unchecked {
871             // We can directly increment and decrement the balances.
872             --_packedAddressData[from]; // Updates: `balance -= 1`.
873             ++_packedAddressData[to]; // Updates: `balance += 1`.
874 
875             // Updates:
876             // - `address` to the next owner.
877             // - `startTimestamp` to the timestamp of transfering.
878             // - `burned` to `false`.
879             // - `nextInitialized` to `true`.
880             _packedOwnerships[tokenId] = _packOwnershipData(
881                 to,
882                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
883             );
884 
885             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
886             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
887                 uint256 nextTokenId = tokenId + 1;
888                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
889                 if (_packedOwnerships[nextTokenId] == 0) {
890                     // If the next slot is within bounds.
891                     if (nextTokenId != _currentIndex) {
892                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
893                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
894                     }
895                 }
896             }
897         }
898 
899         emit Transfer(from, to, tokenId);
900         _afterTokenTransfers(from, to, tokenId, 1);
901     }
902 
903     /**
904      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
905      */
906     function safeTransferFrom(
907         address from,
908         address to,
909         uint256 tokenId
910     ) public virtual override {
911         safeTransferFrom(from, to, tokenId, '');
912     }
913 
914     /**
915      * @dev Safely transfers `tokenId` token from `from` to `to`.
916      *
917      * Requirements:
918      *
919      * - `from` cannot be the zero address.
920      * - `to` cannot be the zero address.
921      * - `tokenId` token must exist and be owned by `from`.
922      * - If the caller is not `from`, it must be approved to move this token
923      * by either {approve} or {setApprovalForAll}.
924      * - If `to` refers to a smart contract, it must implement
925      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
926      *
927      * Emits a {Transfer} event.
928      */
929     function safeTransferFrom(
930         address from,
931         address to,
932         uint256 tokenId,
933         bytes memory _data
934     ) public virtual override {
935         transferFrom(from, to, tokenId);
936         if (to.code.length != 0)
937             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
938                 revert TransferToNonERC721ReceiverImplementer();
939             }
940     }
941 
942     /**
943      * @dev Hook that is called before a set of serially-ordered token IDs
944      * are about to be transferred. This includes minting.
945      * And also called before burning one token.
946      *
947      * `startTokenId` - the first token ID to be transferred.
948      * `quantity` - the amount to be transferred.
949      *
950      * Calling conditions:
951      *
952      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
953      * transferred to `to`.
954      * - When `from` is zero, `tokenId` will be minted for `to`.
955      * - When `to` is zero, `tokenId` will be burned by `from`.
956      * - `from` and `to` are never both zero.
957      */
958     function _beforeTokenTransfers(
959         address from,
960         address to,
961         uint256 startTokenId,
962         uint256 quantity
963     ) internal virtual {}
964 
965     /**
966      * @dev Hook that is called after a set of serially-ordered token IDs
967      * have been transferred. This includes minting.
968      * And also called after one token has been burned.
969      *
970      * `startTokenId` - the first token ID to be transferred.
971      * `quantity` - the amount to be transferred.
972      *
973      * Calling conditions:
974      *
975      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
976      * transferred to `to`.
977      * - When `from` is zero, `tokenId` has been minted for `to`.
978      * - When `to` is zero, `tokenId` has been burned by `from`.
979      * - `from` and `to` are never both zero.
980      */
981     function _afterTokenTransfers(
982         address from,
983         address to,
984         uint256 startTokenId,
985         uint256 quantity
986     ) internal virtual {}
987 
988     /**
989      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
990      *
991      * `from` - Previous owner of the given token ID.
992      * `to` - Target address that will receive the token.
993      * `tokenId` - Token ID to be transferred.
994      * `_data` - Optional data to send along with the call.
995      *
996      * Returns whether the call correctly returned the expected magic value.
997      */
998     function _checkContractOnERC721Received(
999         address from,
1000         address to,
1001         uint256 tokenId,
1002         bytes memory _data
1003     ) private returns (bool) {
1004         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1005             bytes4 retval
1006         ) {
1007             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1008         } catch (bytes memory reason) {
1009             if (reason.length == 0) {
1010                 revert TransferToNonERC721ReceiverImplementer();
1011             } else {
1012                 assembly {
1013                     revert(add(32, reason), mload(reason))
1014                 }
1015             }
1016         }
1017     }
1018 
1019     // =============================================================
1020     //                        MINT OPERATIONS
1021     // =============================================================
1022 
1023     /**
1024      * @dev Mints `quantity` tokens and transfers them to `to`.
1025      *
1026      * Requirements:
1027      *
1028      * - `to` cannot be the zero address.
1029      * - `quantity` must be greater than 0.
1030      *
1031      * Emits a {Transfer} event for each mint.
1032      */
1033     function _mint(address to, uint256 quantity) internal virtual {
1034         uint256 startTokenId = _currentIndex;
1035         if (quantity == 0) revert MintZeroQuantity();
1036 
1037         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1038 
1039         // Overflows are incredibly unrealistic.
1040         // `balance` and `numberMinted` have a maximum limit of 2**64.
1041         // `tokenId` has a maximum limit of 2**256.
1042         unchecked {
1043             // Updates:
1044             // - `balance += quantity`.
1045             // - `numberMinted += quantity`.
1046             //
1047             // We can directly add to the `balance` and `numberMinted`.
1048             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1049 
1050             // Updates:
1051             // - `address` to the owner.
1052             // - `startTimestamp` to the timestamp of minting.
1053             // - `burned` to `false`.
1054             // - `nextInitialized` to `quantity == 1`.
1055             _packedOwnerships[startTokenId] = _packOwnershipData(
1056                 to,
1057                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1058             );
1059 
1060             uint256 toMasked;
1061             uint256 end = startTokenId + quantity;
1062 
1063             // Use assembly to loop and emit the `Transfer` event for gas savings.
1064             assembly {
1065                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1066                 toMasked := and(to, _BITMASK_ADDRESS)
1067                 // Emit the `Transfer` event.
1068                 log4(
1069                     0, // Start of data (0, since no data).
1070                     0, // End of data (0, since no data).
1071                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1072                     0, // `address(0)`.
1073                     toMasked, // `to`.
1074                     startTokenId // `tokenId`.
1075                 )
1076 
1077                 for {
1078                     let tokenId := add(startTokenId, 1)
1079                 } iszero(eq(tokenId, end)) {
1080                     tokenId := add(tokenId, 1)
1081                 } {
1082                     // Emit the `Transfer` event. Similar to above.
1083                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1084                 }
1085             }
1086             if (toMasked == 0) revert MintToZeroAddress();
1087 
1088             _currentIndex = end;
1089         }
1090         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1091     }
1092 
1093     /**
1094      * @dev Mints `quantity` tokens and transfers them to `to`.
1095      *
1096      * This function is intended for efficient minting only during contract creation.
1097      *
1098      * It emits only one {ConsecutiveTransfer} as defined in
1099      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1100      * instead of a sequence of {Transfer} event(s).
1101      *
1102      * Calling this function outside of contract creation WILL make your contract
1103      * non-compliant with the ERC721 standard.
1104      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1105      * {ConsecutiveTransfer} event is only permissible during contract creation.
1106      *
1107      * Requirements:
1108      *
1109      * - `to` cannot be the zero address.
1110      * - `quantity` must be greater than 0.
1111      *
1112      * Emits a {ConsecutiveTransfer} event.
1113      */
1114     function _mintERC2309(address to, uint256 quantity) internal virtual {
1115         uint256 startTokenId = _currentIndex;
1116         if (to == address(0)) revert MintToZeroAddress();
1117         if (quantity == 0) revert MintZeroQuantity();
1118         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1119 
1120         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1121 
1122         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1123         unchecked {
1124             // Updates:
1125             // - `balance += quantity`.
1126             // - `numberMinted += quantity`.
1127             //
1128             // We can directly add to the `balance` and `numberMinted`.
1129             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1130 
1131             // Updates:
1132             // - `address` to the owner.
1133             // - `startTimestamp` to the timestamp of minting.
1134             // - `burned` to `false`.
1135             // - `nextInitialized` to `quantity == 1`.
1136             _packedOwnerships[startTokenId] = _packOwnershipData(
1137                 to,
1138                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1139             );
1140 
1141             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1142 
1143             _currentIndex = startTokenId + quantity;
1144         }
1145         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1146     }
1147 
1148     /**
1149      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1150      *
1151      * Requirements:
1152      *
1153      * - If `to` refers to a smart contract, it must implement
1154      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1155      * - `quantity` must be greater than 0.
1156      *
1157      * See {_mint}.
1158      *
1159      * Emits a {Transfer} event for each mint.
1160      */
1161     function _safeMint(
1162         address to,
1163         uint256 quantity,
1164         bytes memory _data
1165     ) internal virtual {
1166         _mint(to, quantity);
1167 
1168         unchecked {
1169             if (to.code.length != 0) {
1170                 uint256 end = _currentIndex;
1171                 uint256 index = end - quantity;
1172                 do {
1173                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1174                         revert TransferToNonERC721ReceiverImplementer();
1175                     }
1176                 } while (index < end);
1177                 // Reentrancy protection.
1178                 if (_currentIndex != end) revert();
1179             }
1180         }
1181     }
1182 
1183     /**
1184      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1185      */
1186     function _safeMint(address to, uint256 quantity) internal virtual {
1187         _safeMint(to, quantity, '');
1188     }
1189 
1190     // =============================================================
1191     //                        BURN OPERATIONS
1192     // =============================================================
1193 
1194     /**
1195      * @dev Equivalent to `_burn(tokenId, false)`.
1196      */
1197     function _burn(uint256 tokenId) internal virtual {
1198         _burn(tokenId, false);
1199     }
1200 
1201     /**
1202      * @dev Destroys `tokenId`.
1203      * The approval is cleared when the token is burned.
1204      *
1205      * Requirements:
1206      *
1207      * - `tokenId` must exist.
1208      *
1209      * Emits a {Transfer} event.
1210      */
1211     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1212         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1213 
1214         address from = address(uint160(prevOwnershipPacked));
1215 
1216         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1217 
1218         if (approvalCheck) {
1219             // The nested ifs save around 20+ gas over a compound boolean condition.
1220             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1221                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1222         }
1223 
1224         _beforeTokenTransfers(from, address(0), tokenId, 1);
1225 
1226         // Clear approvals from the previous owner.
1227         assembly {
1228             if approvedAddress {
1229                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1230                 sstore(approvedAddressSlot, 0)
1231             }
1232         }
1233 
1234         // Underflow of the sender's balance is impossible because we check for
1235         // ownership above and the recipient's balance can't realistically overflow.
1236         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1237         unchecked {
1238             // Updates:
1239             // - `balance -= 1`.
1240             // - `numberBurned += 1`.
1241             //
1242             // We can directly decrement the balance, and increment the number burned.
1243             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1244             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1245 
1246             // Updates:
1247             // - `address` to the last owner.
1248             // - `startTimestamp` to the timestamp of burning.
1249             // - `burned` to `true`.
1250             // - `nextInitialized` to `true`.
1251             _packedOwnerships[tokenId] = _packOwnershipData(
1252                 from,
1253                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1254             );
1255 
1256             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1257             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1258                 uint256 nextTokenId = tokenId + 1;
1259                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1260                 if (_packedOwnerships[nextTokenId] == 0) {
1261                     // If the next slot is within bounds.
1262                     if (nextTokenId != _currentIndex) {
1263                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1264                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1265                     }
1266                 }
1267             }
1268         }
1269 
1270         emit Transfer(from, address(0), tokenId);
1271         _afterTokenTransfers(from, address(0), tokenId, 1);
1272 
1273         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1274         unchecked {
1275             _burnCounter++;
1276         }
1277     }
1278 
1279     // =============================================================
1280     //                     EXTRA DATA OPERATIONS
1281     // =============================================================
1282 
1283     /**
1284      * @dev Directly sets the extra data for the ownership data `index`.
1285      */
1286     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1287         uint256 packed = _packedOwnerships[index];
1288         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1289         uint256 extraDataCasted;
1290         // Cast `extraData` with assembly to avoid redundant masking.
1291         assembly {
1292             extraDataCasted := extraData
1293         }
1294         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1295         _packedOwnerships[index] = packed;
1296     }
1297 
1298     /**
1299      * @dev Called during each token transfer to set the 24bit `extraData` field.
1300      * Intended to be overridden by the cosumer contract.
1301      *
1302      * `previousExtraData` - the value of `extraData` before transfer.
1303      *
1304      * Calling conditions:
1305      *
1306      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1307      * transferred to `to`.
1308      * - When `from` is zero, `tokenId` will be minted for `to`.
1309      * - When `to` is zero, `tokenId` will be burned by `from`.
1310      * - `from` and `to` are never both zero.
1311      */
1312     function _extraData(
1313         address from,
1314         address to,
1315         uint24 previousExtraData
1316     ) internal view virtual returns (uint24) {}
1317 
1318     /**
1319      * @dev Returns the next extra data for the packed ownership data.
1320      * The returned result is shifted into position.
1321      */
1322     function _nextExtraData(
1323         address from,
1324         address to,
1325         uint256 prevOwnershipPacked
1326     ) private view returns (uint256) {
1327         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1328         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1329     }
1330 
1331     // =============================================================
1332     //                       OTHER OPERATIONS
1333     // =============================================================
1334 
1335     /**
1336      * @dev Returns the message sender (defaults to `msg.sender`).
1337      *
1338      * If you are writing GSN compatible contracts, you need to override this function.
1339      */
1340     function _msgSenderERC721A() internal view virtual returns (address) {
1341         return msg.sender;
1342     }
1343 
1344     /**
1345      * @dev Converts a uint256 to its ASCII string decimal representation.
1346      */
1347     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1348         assembly {
1349             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1350             // but we allocate 0x80 bytes to keep the free memory pointer 32-byte word aliged.
1351             // We will need 1 32-byte word to store the length,
1352             // and 3 32-byte words to store a maximum of 78 digits. Total: 0x20 + 3 * 0x20 = 0x80.
1353             str := add(mload(0x40), 0x80)
1354             // Update the free memory pointer to allocate.
1355             mstore(0x40, str)
1356 
1357             // Cache the end of the memory to calculate the length later.
1358             let end := str
1359 
1360             // We write the string from rightmost digit to leftmost digit.
1361             // The following is essentially a do-while loop that also handles the zero case.
1362             // prettier-ignore
1363             for { let temp := value } 1 {} {
1364                 str := sub(str, 1)
1365                 // Write the character to the pointer.
1366                 // The ASCII index of the '0' character is 48.
1367                 mstore8(str, add(48, mod(temp, 10)))
1368                 // Keep dividing `temp` until zero.
1369                 temp := div(temp, 10)
1370                 // prettier-ignore
1371                 if iszero(temp) { break }
1372             }
1373 
1374             let length := sub(end, str)
1375             // Move the pointer 32 bytes leftwards to make room for the length.
1376             str := sub(str, 0x20)
1377             // Store the length.
1378             mstore(str, length)
1379         }
1380     }
1381 }
1382 
1383 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
1384 
1385 
1386 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1387 
1388 pragma solidity ^0.8.0;
1389 
1390 /**
1391  * @dev Contract module that helps prevent reentrant calls to a function.
1392  *
1393  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1394  * available, which can be applied to functions to make sure there are no nested
1395  * (reentrant) calls to them.
1396  *
1397  * Note that because there is a single `nonReentrant` guard, functions marked as
1398  * `nonReentrant` may not call one another. This can be worked around by making
1399  * those functions `private`, and then adding `external` `nonReentrant` entry
1400  * points to them.
1401  *
1402  * TIP: If you would like to learn more about reentrancy and alternative ways
1403  * to protect against it, check out our blog post
1404  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1405  */
1406 abstract contract ReentrancyGuard {
1407     // Booleans are more expensive than uint256 or any type that takes up a full
1408     // word because each write operation emits an extra SLOAD to first read the
1409     // slot's contents, replace the bits taken up by the boolean, and then write
1410     // back. This is the compiler's defense against contract upgrades and
1411     // pointer aliasing, and it cannot be disabled.
1412 
1413     // The values being non-zero value makes deployment a bit more expensive,
1414     // but in exchange the refund on every call to nonReentrant will be lower in
1415     // amount. Since refunds are capped to a percentage of the total
1416     // transaction's gas, it is best to keep them low in cases like this one, to
1417     // increase the likelihood of the full refund coming into effect.
1418     uint256 private constant _NOT_ENTERED = 1;
1419     uint256 private constant _ENTERED = 2;
1420 
1421     uint256 private _status;
1422 
1423     constructor() {
1424         _status = _NOT_ENTERED;
1425     }
1426 
1427     /**
1428      * @dev Prevents a contract from calling itself, directly or indirectly.
1429      * Calling a `nonReentrant` function from another `nonReentrant`
1430      * function is not supported. It is possible to prevent this from happening
1431      * by making the `nonReentrant` function external, and making it call a
1432      * `private` function that does the actual work.
1433      */
1434     modifier nonReentrant() {
1435         // On the first call to nonReentrant, _notEntered will be true
1436         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1437 
1438         // Any calls to nonReentrant after this point will fail
1439         _status = _ENTERED;
1440 
1441         _;
1442 
1443         // By storing the original value once again, a refund is triggered (see
1444         // https://eips.ethereum.org/EIPS/eip-2200)
1445         _status = _NOT_ENTERED;
1446     }
1447 }
1448 
1449 // File: @openzeppelin/contracts/utils/Context.sol
1450 
1451 
1452 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1453 
1454 pragma solidity ^0.8.0;
1455 
1456 /**
1457  * @dev Provides information about the current execution context, including the
1458  * sender of the transaction and its data. While these are generally available
1459  * via msg.sender and msg.data, they should not be accessed in such a direct
1460  * manner, since when dealing with meta-transactions the account sending and
1461  * paying for execution may not be the actual sender (as far as an application
1462  * is concerned).
1463  *
1464  * This contract is only required for intermediate, library-like contracts.
1465  */
1466 abstract contract Context {
1467     function _msgSender() internal view virtual returns (address) {
1468         return msg.sender;
1469     }
1470 
1471     function _msgData() internal view virtual returns (bytes calldata) {
1472         return msg.data;
1473     }
1474 }
1475 
1476 // File: @openzeppelin/contracts/access/Ownable.sol
1477 
1478 
1479 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1480 
1481 pragma solidity ^0.8.0;
1482 
1483 
1484 /**
1485  * @dev Contract module which provides a basic access control mechanism, where
1486  * there is an account (an owner) that can be granted exclusive access to
1487  * specific functions.
1488  *
1489  * By default, the owner account will be the one that deploys the contract. This
1490  * can later be changed with {transferOwnership}.
1491  *
1492  * This module is used through inheritance. It will make available the modifier
1493  * `onlyOwner`, which can be applied to your functions to restrict their use to
1494  * the owner.
1495  */
1496 abstract contract Ownable is Context {
1497     address private _owner;
1498 
1499     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1500 
1501     /**
1502      * @dev Initializes the contract setting the deployer as the initial owner.
1503      */
1504     constructor() {
1505         _transferOwnership(_msgSender());
1506     }
1507 
1508     /**
1509      * @dev Throws if called by any account other than the owner.
1510      */
1511     modifier onlyOwner() {
1512         _checkOwner();
1513         _;
1514     }
1515 
1516     /**
1517      * @dev Returns the address of the current owner.
1518      */
1519     function owner() public view virtual returns (address) {
1520         return _owner;
1521     }
1522 
1523     /**
1524      * @dev Throws if the sender is not the owner.
1525      */
1526     function _checkOwner() internal view virtual {
1527         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1528     }
1529 
1530     /**
1531      * @dev Leaves the contract without owner. It will not be possible to call
1532      * `onlyOwner` functions anymore. Can only be called by the current owner.
1533      *
1534      * NOTE: Renouncing ownership will leave the contract without an owner,
1535      * thereby removing any functionality that is only available to the owner.
1536      */
1537     function renounceOwnership() public virtual onlyOwner {
1538         _transferOwnership(address(0));
1539     }
1540 
1541     /**
1542      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1543      * Can only be called by the current owner.
1544      */
1545     function transferOwnership(address newOwner) public virtual onlyOwner {
1546         require(newOwner != address(0), "Ownable: new owner is the zero address");
1547         _transferOwnership(newOwner);
1548     }
1549 
1550     /**
1551      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1552      * Internal function without access restriction.
1553      */
1554     function _transferOwnership(address newOwner) internal virtual {
1555         address oldOwner = _owner;
1556         _owner = newOwner;
1557         emit OwnershipTransferred(oldOwner, newOwner);
1558     }
1559 }
1560 
1561 // File: contracts/rektkids.sol
1562 
1563 
1564 pragma solidity ^0.8.4;
1565 
1566 
1567 
1568 
1569 contract RektKids is Ownable, ERC721A, ReentrancyGuard {
1570     mapping(address => uint256) public minted;
1571     RektKidsConfig public rektKidsConfig;
1572 
1573     struct RektKidsConfig {
1574         uint256 price;
1575         uint256 maxMint;
1576         uint256 maxSupply;
1577     }
1578 
1579     constructor() ERC721A("RektKids", "REKT-KIDS") {
1580         rektKidsConfig.maxSupply = 4000;
1581         rektKidsConfig.price = 9000000000000000;
1582         rektKidsConfig.maxMint = 5;
1583     }
1584 
1585     function getRekt(uint256 quantity) external payable {
1586         RektKidsConfig memory config = rektKidsConfig;
1587         uint256 price = uint256(config.price);
1588         uint256 maxMint = uint256(config.maxMint);
1589         uint256 buyed = getAddressBuyed(msg.sender);
1590 
1591         require(
1592             totalSupply() + quantity <= getMaxSupply(),
1593             "Sold out."
1594         );
1595     
1596         require(
1597             buyed + quantity <= maxMint,
1598             "Exceed maxmium mint."
1599         );
1600 
1601         require(
1602             quantity * price <= msg.value,
1603             "No enough eth."
1604         );
1605 
1606         _safeMint(msg.sender, quantity);
1607         minted[msg.sender] += quantity;
1608     }
1609 
1610     function devMint(uint256 quantity) external onlyOwner {
1611         require(
1612             totalSupply() + quantity <= getMaxSupply(),
1613             "Sold out."
1614         );
1615 
1616         _safeMint(msg.sender, quantity);
1617     }
1618 
1619     function getAddressBuyed(address owner) public view returns (uint256) {
1620         return minted[owner];
1621     }
1622     
1623     function getMaxSupply() private view returns (uint256) {
1624         RektKidsConfig memory config = rektKidsConfig;
1625         uint256 max = uint256(config.maxSupply);
1626         return max;
1627     }
1628 
1629     string private _baseTokenURI;
1630 
1631     function _baseURI() internal view virtual override returns (string memory) {
1632         return _baseTokenURI;
1633     }
1634 
1635     function setURI(string calldata baseURI) external onlyOwner {
1636         _baseTokenURI = baseURI;
1637     }
1638 
1639     function setPrice(uint256 _price) external onlyOwner {
1640         rektKidsConfig.price = _price;
1641     }
1642 
1643     function setMaxMint(uint256 _amount) external onlyOwner {
1644         rektKidsConfig.maxMint = _amount;
1645     }
1646 
1647     function withdraw() external onlyOwner nonReentrant {
1648         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1649         require(success, "ok");
1650     }
1651 }
1652 
1653 
1654 // SPDX-License-Identifier: MIT