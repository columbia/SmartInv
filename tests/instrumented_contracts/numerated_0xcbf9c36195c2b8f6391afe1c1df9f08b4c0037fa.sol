1 /**
2  _     ____  _      ____  ____ 
3 / \   /  _ \/ \__/|/  __\/  _ \
4 | |   | / \|| |\/||| | //| / \|
5 | |_/\| |-||| |  ||| |_\\| \_/|
6 \____/\_/ \|\_/  \|\____/\____/
7                                
8  */
9 /**
10 https://twitter.com/WENLAMBO_XYZ
11  */
12 
13 
14 // SPDX-License-Identifier: MIT
15 
16 pragma solidity ^0.8.7;
17 
18 /**
19  * @dev Interface of ERC721A.
20  */
21 interface IERC721A {
22     /**
23      * The caller must own the token or be an approved operator.
24      */
25     error ApprovalCallerNotOwnerNorApproved();
26 
27     /**
28      * The token does not exist.
29      */
30     error ApprovalQueryForNonexistentToken();
31 
32     /**
33      * Cannot query the balance for the zero address.
34      */
35     error BalanceQueryForZeroAddress();
36 
37     /**
38      * Cannot mint to the zero address.
39      */
40     error MintToZeroAddress();
41 
42     /**
43      * The quantity of tokens minted must be more than zero.
44      */
45     error MintZeroQuantity();
46 
47     /**
48      * The token does not exist.
49      */
50     error OwnerQueryForNonexistentToken();
51 
52     /**
53      * The caller must own the token or be an approved operator.
54      */
55     error TransferCallerNotOwnerNorApproved();
56 
57     /**
58      * The token must be owned by `from`.
59      */
60     error TransferFromIncorrectOwner();
61 
62     /**
63      * Cannot safely transfer to a contract that does not implement the
64      * ERC721Receiver interface.
65      */
66     error TransferToNonERC721ReceiverImplementer();
67 
68     /**
69      * Cannot transfer to the zero address.
70      */
71     error TransferToZeroAddress();
72 
73     /**
74      * The token does not exist.
75      */
76     error URIQueryForNonexistentToken();
77 
78     /**
79      * The `quantity` minted with ERC2309 exceeds the safety limit.
80      */
81     error MintERC2309QuantityExceedsLimit();
82 
83     /**
84      * The `extraData` cannot be set on an unintialized ownership slot.
85      */
86     error OwnershipNotInitializedForExtraData();
87 
88     // =============================================================
89     //                            STRUCTS
90     // =============================================================
91 
92     struct TokenOwnership {
93         // The address of the owner.
94         address addr;
95         // Stores the start time of ownership with minimal overhead for tokenomics.
96         uint64 startTimestamp;
97         // Whether the token has been burned.
98         bool burned;
99         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
100         uint24 extraData;
101     }
102 
103     // =============================================================
104     //                         TOKEN COUNTERS
105     // =============================================================
106 
107     /**
108      * @dev Returns the total number of tokens in existence.
109      * Burned tokens will reduce the count.
110      * To get the total number of tokens minted, please see {_totalMinted}.
111      */
112     function totalSupply() external view returns (uint256);
113 
114     // =============================================================
115     //                            IERC165
116     // =============================================================
117 
118     /**
119      * @dev Returns true if this contract implements the interface defined by
120      * `interfaceId`. See the corresponding
121      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
122      * to learn more about how these ids are created.
123      *
124      * This function call must use less than 30000 gas.
125      */
126     function supportsInterface(bytes4 interfaceId) external view returns (bool);
127 
128     // =============================================================
129     //                            IERC721
130     // =============================================================
131 
132     /**
133      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
134      */
135     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
136 
137     /**
138      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
139      */
140     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
141 
142     /**
143      * @dev Emitted when `owner` enables or disables
144      * (`approved`) `operator` to manage all of its assets.
145      */
146     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
147 
148     /**
149      * @dev Returns the number of tokens in `owner`'s account.
150      */
151     function balanceOf(address owner) external view returns (uint256 balance);
152 
153     /**
154      * @dev Returns the owner of the `tokenId` token.
155      *
156      * Requirements:
157      *
158      * - `tokenId` must exist.
159      */
160     function ownerOf(uint256 tokenId) external view returns (address owner);
161 
162     /**
163      * @dev Safely transfers `tokenId` token from `from` to `to`,
164      * checking first that contract recipients are aware of the ERC721 protocol
165      * to prevent tokens from being forever locked.
166      *
167      * Requirements:
168      *
169      * - `from` cannot be the zero address.
170      * - `to` cannot be the zero address.
171      * - `tokenId` token must exist and be owned by `from`.
172      * - If the caller is not `from`, it must be have been allowed to move
173      * this token by either {approve} or {setApprovalForAll}.
174      * - If `to` refers to a smart contract, it must implement
175      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
176      *
177      * Emits a {Transfer} event.
178      */
179     function safeTransferFrom(
180         address from,
181         address to,
182         uint256 tokenId,
183         bytes calldata data
184     ) external payable;
185 
186     /**
187      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
188      */
189     function safeTransferFrom(
190         address from,
191         address to,
192         uint256 tokenId
193     ) external payable;
194 
195     /**
196      * @dev Transfers `tokenId` from `from` to `to`.
197      *
198      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
199      * whenever possible.
200      *
201      * Requirements:
202      *
203      * - `from` cannot be the zero address.
204      * - `to` cannot be the zero address.
205      * - `tokenId` token must be owned by `from`.
206      * - If the caller is not `from`, it must be approved to move this token
207      * by either {approve} or {setApprovalForAll}.
208      *
209      * Emits a {Transfer} event.
210      */
211     function transferFrom(
212         address from,
213         address to,
214         uint256 tokenId
215     ) external payable;
216 
217     /**
218      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
219      * The approval is cleared when the token is transferred.
220      *
221      * Only a single account can be approved at a time, so approving the
222      * zero address clears previous approvals.
223      *
224      * Requirements:
225      *
226      * - The caller must own the token or be an approved operator.
227      * - `tokenId` must exist.
228      *
229      * Emits an {Approval} event.
230      */
231     function approve(address to, uint256 tokenId) external payable;
232 
233     /**
234      * @dev Approve or remove `operator` as an operator for the caller.
235      * Operators can call {transferFrom} or {safeTransferFrom}
236      * for any token owned by the caller.
237      *
238      * Requirements:
239      *
240      * - The `operator` cannot be the caller.
241      *
242      * Emits an {ApprovalForAll} event.
243      */
244     function setApprovalForAll(address operator, bool _approved) external;
245 
246     /**
247      * @dev Returns the account approved for `tokenId` token.
248      *
249      * Requirements:
250      *
251      * - `tokenId` must exist.
252      */
253     function getApproved(uint256 tokenId) external view returns (address operator);
254 
255     /**
256      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
257      *
258      * See {setApprovalForAll}.
259      */
260     function isApprovedForAll(address owner, address operator) external view returns (bool);
261 
262     // =============================================================
263     //                        IERC721Metadata
264     // =============================================================
265 
266     /**
267      * @dev Returns the token collection name.
268      */
269     function name() external view returns (string memory);
270 
271     /**
272      * @dev Returns the token collection symbol.
273      */
274     function symbol() external view returns (string memory);
275 
276     /**
277      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
278      */
279     function tokenURI(uint256 tokenId) external view returns (string memory);
280 
281     // =============================================================
282     //                           IERC2309
283     // =============================================================
284 
285     /**
286      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
287      * (inclusive) is transferred from `from` to `to`, as defined in the
288      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
289      *
290      * See {_mintERC2309} for more details.
291      */
292     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
293 }
294 
295 /**
296  * @title ERC721A
297  *
298  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
299  * Non-Fungible Token Standard, including the Metadata extension.
300  * Optimized for lower gas during batch mints.
301  *
302  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
303  * starting from `_startTokenId()`.
304  *
305  * Assumptions:
306  *
307  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
308  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
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
335     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
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
723     function approve(address to, uint256 tokenId) public payable virtual override {
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
760         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
761         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
762     }
763 
764     /**
765      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
766      *
767      * See {setApprovalForAll}.
768      */
769     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
770         return _operatorApprovals[owner][operator];
771     }
772 
773     /**
774      * @dev Returns whether `tokenId` exists.
775      *
776      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
777      *
778      * Tokens start existing when they are minted. See {_mint}.
779      */
780     function _exists(uint256 tokenId) internal view virtual returns (bool) {
781         return
782             _startTokenId() <= tokenId &&
783             tokenId < _currentIndex && // If within bounds,
784             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
785     }
786 
787     /**
788      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
789      */
790     function _isSenderApprovedOrOwner(
791         address approvedAddress,
792         address owner,
793         address msgSender
794     ) private pure returns (bool result) {
795         assembly {
796             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
797             owner := and(owner, _BITMASK_ADDRESS)
798             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
799             msgSender := and(msgSender, _BITMASK_ADDRESS)
800             // `msgSender == owner || msgSender == approvedAddress`.
801             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
802         }
803     }
804 
805     /**
806      * @dev Returns the storage slot and value for the approved address of `tokenId`.
807      */
808     function _getApprovedSlotAndAddress(uint256 tokenId)
809         private
810         view
811         returns (uint256 approvedAddressSlot, address approvedAddress)
812     {
813         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
814         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
815         assembly {
816             approvedAddressSlot := tokenApproval.slot
817             approvedAddress := sload(approvedAddressSlot)
818         }
819     }
820 
821     // =============================================================
822     //                      TRANSFER OPERATIONS
823     // =============================================================
824 
825     /**
826      * @dev Transfers `tokenId` from `from` to `to`.
827      *
828      * Requirements:
829      *
830      * - `from` cannot be the zero address.
831      * - `to` cannot be the zero address.
832      * - `tokenId` token must be owned by `from`.
833      * - If the caller is not `from`, it must be approved to move this token
834      * by either {approve} or {setApprovalForAll}.
835      *
836      * Emits a {Transfer} event.
837      */
838     function transferFrom(
839         address from,
840         address to,
841         uint256 tokenId
842     ) public payable virtual override {
843         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
844 
845         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
846 
847         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
848 
849         // The nested ifs save around 20+ gas over a compound boolean condition.
850         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
851             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
852 
853         if (to == address(0)) revert TransferToZeroAddress();
854 
855         _beforeTokenTransfers(from, to, tokenId, 1);
856 
857         // Clear approvals from the previous owner.
858         assembly {
859             if approvedAddress {
860                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
861                 sstore(approvedAddressSlot, 0)
862             }
863         }
864 
865         // Underflow of the sender's balance is impossible because we check for
866         // ownership above and the recipient's balance can't realistically overflow.
867         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
868         unchecked {
869             // We can directly increment and decrement the balances.
870             --_packedAddressData[from]; // Updates: `balance -= 1`.
871             ++_packedAddressData[to]; // Updates: `balance += 1`.
872 
873             // Updates:
874             // - `address` to the next owner.
875             // - `startTimestamp` to the timestamp of transfering.
876             // - `burned` to `false`.
877             // - `nextInitialized` to `true`.
878             _packedOwnerships[tokenId] = _packOwnershipData(
879                 to,
880                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
881             );
882 
883             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
884             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
885                 uint256 nextTokenId = tokenId + 1;
886                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
887                 if (_packedOwnerships[nextTokenId] == 0) {
888                     // If the next slot is within bounds.
889                     if (nextTokenId != _currentIndex) {
890                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
891                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
892                     }
893                 }
894             }
895         }
896 
897         emit Transfer(from, to, tokenId);
898         _afterTokenTransfers(from, to, tokenId, 1);
899     }
900 
901     /**
902      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
903      */
904     function safeTransferFrom(
905         address from,
906         address to,
907         uint256 tokenId
908     ) public payable virtual override {
909         safeTransferFrom(from, to, tokenId, '');
910     }
911 
912     /**
913      * @dev Safely transfers `tokenId` token from `from` to `to`.
914      *
915      * Requirements:
916      *
917      * - `from` cannot be the zero address.
918      * - `to` cannot be the zero address.
919      * - `tokenId` token must exist and be owned by `from`.
920      * - If the caller is not `from`, it must be approved to move this token
921      * by either {approve} or {setApprovalForAll}.
922      * - If `to` refers to a smart contract, it must implement
923      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
924      *
925      * Emits a {Transfer} event.
926      */
927     function safeTransferFrom(
928         address from,
929         address to,
930         uint256 tokenId,
931         bytes memory _data
932     ) public payable virtual override {
933         transferFrom(from, to, tokenId);
934         if (to.code.length != 0)
935             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
936                 revert TransferToNonERC721ReceiverImplementer();
937             }
938     }
939 
940     /**
941      * @dev Hook that is called before a set of serially-ordered token IDs
942      * are about to be transferred. This includes minting.
943      * And also called before burning one token.
944      *
945      * `startTokenId` - the first token ID to be transferred.
946      * `quantity` - the amount to be transferred.
947      *
948      * Calling conditions:
949      *
950      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
951      * transferred to `to`.
952      * - When `from` is zero, `tokenId` will be minted for `to`.
953      * - When `to` is zero, `tokenId` will be burned by `from`.
954      * - `from` and `to` are never both zero.
955      */
956     function _beforeTokenTransfers(
957         address from,
958         address to,
959         uint256 startTokenId,
960         uint256 quantity
961     ) internal virtual {}
962 
963     /**
964      * @dev Hook that is called after a set of serially-ordered token IDs
965      * have been transferred. This includes minting.
966      * And also called after one token has been burned.
967      *
968      * `startTokenId` - the first token ID to be transferred.
969      * `quantity` - the amount to be transferred.
970      *
971      * Calling conditions:
972      *
973      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
974      * transferred to `to`.
975      * - When `from` is zero, `tokenId` has been minted for `to`.
976      * - When `to` is zero, `tokenId` has been burned by `from`.
977      * - `from` and `to` are never both zero.
978      */
979     function _afterTokenTransfers(
980         address from,
981         address to,
982         uint256 startTokenId,
983         uint256 quantity
984     ) internal virtual {}
985 
986     /**
987      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
988      *
989      * `from` - Previous owner of the given token ID.
990      * `to` - Target address that will receive the token.
991      * `tokenId` - Token ID to be transferred.
992      * `_data` - Optional data to send along with the call.
993      *
994      * Returns whether the call correctly returned the expected magic value.
995      */
996     function _checkContractOnERC721Received(
997         address from,
998         address to,
999         uint256 tokenId,
1000         bytes memory _data
1001     ) private returns (bool) {
1002         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1003             bytes4 retval
1004         ) {
1005             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1006         } catch (bytes memory reason) {
1007             if (reason.length == 0) {
1008                 revert TransferToNonERC721ReceiverImplementer();
1009             } else {
1010                 assembly {
1011                     revert(add(32, reason), mload(reason))
1012                 }
1013             }
1014         }
1015     }
1016 
1017     // =============================================================
1018     //                        MINT OPERATIONS
1019     // =============================================================
1020 
1021     /**
1022      * @dev Mints `quantity` tokens and transfers them to `to`.
1023      *
1024      * Requirements:
1025      *
1026      * - `to` cannot be the zero address.
1027      * - `quantity` must be greater than 0.
1028      *
1029      * Emits a {Transfer} event for each mint.
1030      */
1031     function _mint(address to, uint256 quantity) internal virtual {
1032         uint256 startTokenId = _currentIndex;
1033         if (quantity == 0) revert MintZeroQuantity();
1034 
1035         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1036 
1037         // Overflows are incredibly unrealistic.
1038         // `balance` and `numberMinted` have a maximum limit of 2**64.
1039         // `tokenId` has a maximum limit of 2**256.
1040         unchecked {
1041             // Updates:
1042             // - `balance += quantity`.
1043             // - `numberMinted += quantity`.
1044             //
1045             // We can directly add to the `balance` and `numberMinted`.
1046             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1047 
1048             // Updates:
1049             // - `address` to the owner.
1050             // - `startTimestamp` to the timestamp of minting.
1051             // - `burned` to `false`.
1052             // - `nextInitialized` to `quantity == 1`.
1053             _packedOwnerships[startTokenId] = _packOwnershipData(
1054                 to,
1055                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1056             );
1057 
1058             uint256 toMasked;
1059             uint256 end = startTokenId + quantity;
1060 
1061             // Use assembly to loop and emit the `Transfer` event for gas savings.
1062             // The duplicated `log4` removes an extra check and reduces stack juggling.
1063             // The assembly, together with the surrounding Solidity code, have been
1064             // delicately arranged to nudge the compiler into producing optimized opcodes.
1065             assembly {
1066                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1067                 toMasked := and(to, _BITMASK_ADDRESS)
1068                 // Emit the `Transfer` event.
1069                 log4(
1070                     0, // Start of data (0, since no data).
1071                     0, // End of data (0, since no data).
1072                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1073                     0, // `address(0)`.
1074                     toMasked, // `to`.
1075                     startTokenId // `tokenId`.
1076                 )
1077 
1078                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1079                 // that overflows uint256 will make the loop run out of gas.
1080                 // The compiler will optimize the `iszero` away for performance.
1081                 for {
1082                     let tokenId := add(startTokenId, 1)
1083                 } iszero(eq(tokenId, end)) {
1084                     tokenId := add(tokenId, 1)
1085                 } {
1086                     // Emit the `Transfer` event. Similar to above.
1087                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1088                 }
1089             }
1090             if (toMasked == 0) revert MintToZeroAddress();
1091 
1092             _currentIndex = end;
1093         }
1094         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1095     }
1096 
1097     /**
1098      * @dev Mints `quantity` tokens and transfers them to `to`.
1099      *
1100      * This function is intended for efficient minting only during contract creation.
1101      *
1102      * It emits only one {ConsecutiveTransfer} as defined in
1103      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1104      * instead of a sequence of {Transfer} event(s).
1105      *
1106      * Calling this function outside of contract creation WILL make your contract
1107      * non-compliant with the ERC721 standard.
1108      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1109      * {ConsecutiveTransfer} event is only permissible during contract creation.
1110      *
1111      * Requirements:
1112      *
1113      * - `to` cannot be the zero address.
1114      * - `quantity` must be greater than 0.
1115      *
1116      * Emits a {ConsecutiveTransfer} event.
1117      */
1118     function _mintERC2309(address to, uint256 quantity) internal virtual {
1119         uint256 startTokenId = _currentIndex;
1120         if (to == address(0)) revert MintToZeroAddress();
1121         if (quantity == 0) revert MintZeroQuantity();
1122         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1123 
1124         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1125 
1126         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1127         unchecked {
1128             // Updates:
1129             // - `balance += quantity`.
1130             // - `numberMinted += quantity`.
1131             //
1132             // We can directly add to the `balance` and `numberMinted`.
1133             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1134 
1135             // Updates:
1136             // - `address` to the owner.
1137             // - `startTimestamp` to the timestamp of minting.
1138             // - `burned` to `false`.
1139             // - `nextInitialized` to `quantity == 1`.
1140             _packedOwnerships[startTokenId] = _packOwnershipData(
1141                 to,
1142                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1143             );
1144 
1145             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1146 
1147             _currentIndex = startTokenId + quantity;
1148         }
1149         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1150     }
1151 
1152     /**
1153      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1154      *
1155      * Requirements:
1156      *
1157      * - If `to` refers to a smart contract, it must implement
1158      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1159      * - `quantity` must be greater than 0.
1160      *
1161      * See {_mint}.
1162      *
1163      * Emits a {Transfer} event for each mint.
1164      */
1165     function _safeMint(
1166         address to,
1167         uint256 quantity,
1168         bytes memory _data
1169     ) internal virtual {
1170         _mint(to, quantity);
1171 
1172         unchecked {
1173             if (to.code.length != 0) {
1174                 uint256 end = _currentIndex;
1175                 uint256 index = end - quantity;
1176                 do {
1177                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1178                         revert TransferToNonERC721ReceiverImplementer();
1179                     }
1180                 } while (index < end);
1181                 // Reentrancy protection.
1182                 if (_currentIndex != end) revert();
1183             }
1184         }
1185     }
1186 
1187     /**
1188      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1189      */
1190     function _safeMint(address to, uint256 quantity) internal virtual {
1191         _safeMint(to, quantity, '');
1192     }
1193 
1194     // =============================================================
1195     //                        BURN OPERATIONS
1196     // =============================================================
1197 
1198     /**
1199      * @dev Equivalent to `_burn(tokenId, false)`.
1200      */
1201     function _burn(uint256 tokenId) internal virtual {
1202         _burn(tokenId, false);
1203     }
1204 
1205     /**
1206      * @dev Destroys `tokenId`.
1207      * The approval is cleared when the token is burned.
1208      *
1209      * Requirements:
1210      *
1211      * - `tokenId` must exist.
1212      *
1213      * Emits a {Transfer} event.
1214      */
1215     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1216         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1217 
1218         address from = address(uint160(prevOwnershipPacked));
1219 
1220         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1221 
1222         if (approvalCheck) {
1223             // The nested ifs save around 20+ gas over a compound boolean condition.
1224             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1225                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1226         }
1227 
1228         _beforeTokenTransfers(from, address(0), tokenId, 1);
1229 
1230         // Clear approvals from the previous owner.
1231         assembly {
1232             if approvedAddress {
1233                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1234                 sstore(approvedAddressSlot, 0)
1235             }
1236         }
1237 
1238         // Underflow of the sender's balance is impossible because we check for
1239         // ownership above and the recipient's balance can't realistically overflow.
1240         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1241         unchecked {
1242             // Updates:
1243             // - `balance -= 1`.
1244             // - `numberBurned += 1`.
1245             //
1246             // We can directly decrement the balance, and increment the number burned.
1247             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1248             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1249 
1250             // Updates:
1251             // - `address` to the last owner.
1252             // - `startTimestamp` to the timestamp of burning.
1253             // - `burned` to `true`.
1254             // - `nextInitialized` to `true`.
1255             _packedOwnerships[tokenId] = _packOwnershipData(
1256                 from,
1257                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1258             );
1259 
1260             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1261             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1262                 uint256 nextTokenId = tokenId + 1;
1263                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1264                 if (_packedOwnerships[nextTokenId] == 0) {
1265                     // If the next slot is within bounds.
1266                     if (nextTokenId != _currentIndex) {
1267                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1268                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1269                     }
1270                 }
1271             }
1272         }
1273 
1274         emit Transfer(from, address(0), tokenId);
1275         _afterTokenTransfers(from, address(0), tokenId, 1);
1276 
1277         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1278         unchecked {
1279             _burnCounter++;
1280         }
1281     }
1282 
1283     // =============================================================
1284     //                     EXTRA DATA OPERATIONS
1285     // =============================================================
1286 
1287     /**
1288      * @dev Directly sets the extra data for the ownership data `index`.
1289      */
1290     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1291         uint256 packed = _packedOwnerships[index];
1292         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1293         uint256 extraDataCasted;
1294         // Cast `extraData` with assembly to avoid redundant masking.
1295         assembly {
1296             extraDataCasted := extraData
1297         }
1298         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1299         _packedOwnerships[index] = packed;
1300     }
1301 
1302     /**
1303      * @dev Called during each token transfer to set the 24bit `extraData` field.
1304      * Intended to be overridden by the cosumer contract.
1305      *
1306      * `previousExtraData` - the value of `extraData` before transfer.
1307      *
1308      * Calling conditions:
1309      *
1310      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1311      * transferred to `to`.
1312      * - When `from` is zero, `tokenId` will be minted for `to`.
1313      * - When `to` is zero, `tokenId` will be burned by `from`.
1314      * - `from` and `to` are never both zero.
1315      */
1316     function _extraData(
1317         address from,
1318         address to,
1319         uint24 previousExtraData
1320     ) internal view virtual returns (uint24) {}
1321 
1322     /**
1323      * @dev Returns the next extra data for the packed ownership data.
1324      * The returned result is shifted into position.
1325      */
1326     function _nextExtraData(
1327         address from,
1328         address to,
1329         uint256 prevOwnershipPacked
1330     ) private view returns (uint256) {
1331         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1332         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1333     }
1334 
1335     // =============================================================
1336     //                       OTHER OPERATIONS
1337     // =============================================================
1338 
1339     /**
1340      * @dev Returns the message sender (defaults to `msg.sender`).
1341      *
1342      * If you are writing GSN compatible contracts, you need to override this function.
1343      */
1344     function _msgSenderERC721A() internal view virtual returns (address) {
1345         return msg.sender;
1346     }
1347 
1348     /**
1349      * @dev Converts a uint256 to its ASCII string decimal representation.
1350      */
1351     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1352         assembly {
1353             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1354             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1355             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1356             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1357             let m := add(mload(0x40), 0xa0)
1358             // Update the free memory pointer to allocate.
1359             mstore(0x40, m)
1360             // Assign the `str` to the end.
1361             str := sub(m, 0x20)
1362             // Zeroize the slot after the string.
1363             mstore(str, 0)
1364 
1365             // Cache the end of the memory to calculate the length later.
1366             let end := str
1367 
1368             // We write the string from rightmost digit to leftmost digit.
1369             // The following is essentially a do-while loop that also handles the zero case.
1370             // prettier-ignore
1371             for { let temp := value } 1 {} {
1372                 str := sub(str, 1)
1373                 // Write the character to the pointer.
1374                 // The ASCII index of the '0' character is 48.
1375                 mstore8(str, add(48, mod(temp, 10)))
1376                 // Keep dividing `temp` until zero.
1377                 temp := div(temp, 10)
1378                 // prettier-ignore
1379                 if iszero(temp) { break }
1380             }
1381 
1382             let length := sub(end, str)
1383             // Move the pointer 32 bytes leftwards to make room for the length.
1384             str := sub(str, 0x20)
1385             // Store the length.
1386             mstore(str, length)
1387         }
1388     }
1389 }
1390 
1391 
1392 interface IOperatorFilterRegistry {
1393     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1394     function register(address registrant) external;
1395     function registerAndSubscribe(address registrant, address subscription) external;
1396     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1397     function unregister(address addr) external;
1398     function updateOperator(address registrant, address operator, bool filtered) external;
1399     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1400     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1401     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1402     function subscribe(address registrant, address registrantToSubscribe) external;
1403     function unsubscribe(address registrant, bool copyExistingEntries) external;
1404     function subscriptionOf(address addr) external returns (address registrant);
1405     function subscribers(address registrant) external returns (address[] memory);
1406     function subscriberAt(address registrant, uint256 index) external returns (address);
1407     function copyEntriesOf(address registrant, address registrantToCopy) external;
1408     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1409     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1410     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1411     function filteredOperators(address addr) external returns (address[] memory);
1412     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1413     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1414     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1415     function isRegistered(address addr) external returns (bool);
1416     function codeHashOf(address addr) external returns (bytes32);
1417 }
1418 
1419 
1420 /**
1421  * @title  OperatorFilterer
1422  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
1423  *         registrant's entries in the OperatorFilterRegistry.
1424  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
1425  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
1426  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
1427  */
1428 abstract contract OperatorFilterer {
1429     error OperatorNotAllowed(address operator);
1430 
1431     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
1432         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1433 
1434     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1435         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1436         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1437         // order for the modifier to filter addresses.
1438         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1439             if (subscribe) {
1440                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1441             } else {
1442                 if (subscriptionOrRegistrantToCopy != address(0)) {
1443                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1444                 } else {
1445                     OPERATOR_FILTER_REGISTRY.register(address(this));
1446                 }
1447             }
1448         }
1449     }
1450 
1451     modifier onlyAllowedOperator(address from) virtual {
1452         // Check registry code length to facilitate testing in environments without a deployed registry.
1453         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1454             // Allow spending tokens from addresses with balance
1455             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1456             // from an EOA.
1457             if (from == msg.sender) {
1458                 _;
1459                 return;
1460             }
1461             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), msg.sender)) {
1462                 revert OperatorNotAllowed(msg.sender);
1463             }
1464         }
1465         _;
1466     }
1467 
1468     modifier onlyAllowedOperatorApproval(address operator) virtual {
1469         // Check registry code length to facilitate testing in environments without a deployed registry.
1470         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1471             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
1472                 revert OperatorNotAllowed(operator);
1473             }
1474         }
1475         _;
1476     }
1477 }
1478 
1479 /**
1480  * @title  DefaultOperatorFilterer
1481  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
1482  */
1483 abstract contract DefaultOperatorFilterer is OperatorFilterer {
1484     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1485     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1486 }
1487 
1488 contract WENLAMBO is ERC721A, DefaultOperatorFilterer {
1489     mapping(uint256 => uint256) blockFree;
1490 
1491     mapping(address => bool) minted;
1492 
1493     uint256 public maxSupply = 999;
1494 
1495     uint256 public maxPerTx = 10;    
1496 
1497     uint256 public price = 0.0025 ether;
1498 
1499     uint256 public royalty = 50;
1500 
1501     bool pause;
1502 
1503     function mint(uint256 amount) payable public {
1504         require(totalSupply() + amount <= maxSupply);
1505         require(amount <= maxPerTx);
1506         _mint(amount);
1507     }
1508 
1509     string uri = "ipfs://bafybeicw6irrj4kusodzrfcfg7gkg4n5ixcje66pt4w4epjttn7vm2abhi/";
1510     function setUri(string memory _uri) external onlyOwner {
1511         uri = _uri;
1512     }
1513 
1514     address owner;
1515     modifier onlyOwner {
1516         require(owner == msg.sender);
1517         _;
1518     }
1519     
1520     constructor() ERC721A("WEN LAMBO", "LAMBO") {
1521         owner = msg.sender;
1522     }
1523 
1524     function _mint(uint256 amount) internal {
1525         require(msg.sender == tx.origin);
1526         if (msg.value == 0) {
1527             uint256 freeNum = (maxSupply - totalSupply()) / 12;
1528             require(blockFree[block.number] + 1 <= freeNum);
1529             blockFree[block.number] += 1;
1530             _safeMint(msg.sender, 1);
1531             return;
1532         }
1533         require(msg.value >= amount * price);
1534         _safeMint(msg.sender, amount);
1535     }
1536 
1537     function reserve(uint16 _mintAmount, address _receiver) external onlyOwner {
1538         uint16 totalSupply = uint16(totalSupply());
1539         require(totalSupply + _mintAmount <= maxSupply, "Exceeds max supply.");
1540         _safeMint(_receiver , _mintAmount);
1541     }
1542 
1543     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual returns (address, uint256) {
1544         uint256 royaltyAmount = (_salePrice * royalty) / 1000;
1545         return (owner, royaltyAmount);
1546     }
1547 
1548     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1549         return string(abi.encodePacked(uri, _toString(tokenId), ".json"));
1550     }
1551 
1552     function withdraw() external onlyOwner {
1553         payable(msg.sender).transfer(address(this).balance);
1554     }
1555 
1556     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1557         super.setApprovalForAll(operator, approved);
1558     }
1559 
1560     function approve(address operator, uint256 tokenId) public payable override onlyAllowedOperatorApproval(operator) {
1561         super.approve(operator, tokenId);
1562     }
1563 
1564     function transferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1565         super.transferFrom(from, to, tokenId);
1566     }
1567 
1568     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1569         super.safeTransferFrom(from, to, tokenId);
1570     }
1571 
1572     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1573         public
1574         payable
1575         override
1576         onlyAllowedOperator(from)
1577     {
1578         super.safeTransferFrom(from, to, tokenId, data);
1579     }
1580 }