1 /**
2  *Submitted for verification at Etherscan.io on 2022-12-08
3 */
4 
5 // SPDX-License-Identifier: MIT
6 /**
7  *Submitted for verification at Etherscan.io on 2022-08-02
8 */
9 
10 // File: erc721a/contracts/IERC721A.sol
11 
12 
13 // ERC721A Contracts v4.2.0
14 // Creator: Chiru Labs
15 
16 pragma solidity ^0.8.4;
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
33      * The caller cannot approve to their own address.
34      */
35     error ApproveToCaller();
36 
37     /**
38      * Cannot query the balance for the zero address.
39      */
40     error BalanceQueryForZeroAddress();
41 
42     /**
43      * Cannot mint to the zero address.
44      */
45     error MintToZeroAddress();
46 
47     /**
48      * The quantity of tokens minted must be more than zero.
49      */
50     error MintZeroQuantity();
51 
52     /**
53      * The token does not exist.
54      */
55     error OwnerQueryForNonexistentToken();
56 
57     /**
58      * The caller must own the token or be an approved operator.
59      */
60     error TransferCallerNotOwnerNorApproved();
61 
62     /**
63      * The token must be owned by `from`.
64      */
65     error TransferFromIncorrectOwner();
66 
67     /**
68      * Cannot safely transfer to a contract that does not implement the
69      * ERC721Receiver interface.
70      */
71     error TransferToNonERC721ReceiverImplementer();
72 
73     /**
74      * Cannot transfer to the zero address.
75      */
76     error TransferToZeroAddress();
77 
78     /**
79      * The token does not exist.
80      */
81     error URIQueryForNonexistentToken();
82 
83     /**
84      * The `quantity` minted with ERC2309 exceeds the safety limit.
85      */
86     error MintERC2309QuantityExceedsLimit();
87 
88     /**
89      * The `extraData` cannot be set on an unintialized ownership slot.
90      */
91     error OwnershipNotInitializedForExtraData();
92 
93     // =============================================================
94     //                            STRUCTS
95     // =============================================================
96 
97     struct TokenOwnership {
98         // The address of the owner.
99         address addr;
100         // Stores the start time of ownership with minimal overhead for tokenomics.
101         uint64 startTimestamp;
102         // Whether the token has been burned.
103         bool burned;
104         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
105         uint24 extraData;
106     }
107 
108     // =============================================================
109     //                         TOKEN COUNTERS
110     // =============================================================
111 
112     /**
113      * @dev Returns the total number of tokens in existence.
114      * Burned tokens will reduce the count.
115      * To get the total number of tokens minted, please see {_totalMinted}.
116      */
117     function totalSupply() external view returns (uint256);
118 
119     // =============================================================
120     //                            IERC165
121     // =============================================================
122 
123     /**
124      * @dev Returns true if this contract implements the interface defined by
125      * `interfaceId`. See the corresponding
126      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
127      * to learn more about how these ids are created.
128      *
129      * This function call must use less than 30000 gas.
130      */
131     function supportsInterface(bytes4 interfaceId) external view returns (bool);
132 
133     // =============================================================
134     //                            IERC721
135     // =============================================================
136 
137     /**
138      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
139      */
140     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
141 
142     /**
143      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
144      */
145     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
146 
147     /**
148      * @dev Emitted when `owner` enables or disables
149      * (`approved`) `operator` to manage all of its assets.
150      */
151     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
152 
153     /**
154      * @dev Returns the number of tokens in `owner`'s account.
155      */
156     function balanceOf(address owner) external view returns (uint256 balance);
157 
158     /**
159      * @dev Returns the owner of the `tokenId` token.
160      *
161      * Requirements:
162      *
163      * - `tokenId` must exist.
164      */
165     function ownerOf(uint256 tokenId) external view returns (address owner);
166 
167     /**
168      * @dev Safely transfers `tokenId` token from `from` to `to`,
169      * checking first that contract recipients are aware of the ERC721 protocol
170      * to prevent tokens from being forever locked.
171      *
172      * Requirements:
173      *
174      * - `from` cannot be the zero address.
175      * - `to` cannot be the zero address.
176      * - `tokenId` token must exist and be owned by `from`.
177      * - If the caller is not `from`, it must be have been allowed to move
178      * this token by either {approve} or {setApprovalForAll}.
179      * - If `to` refers to a smart contract, it must implement
180      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
181      *
182      * Emits a {Transfer} event.
183      */
184     function safeTransferFrom(
185         address from,
186         address to,
187         uint256 tokenId,
188         bytes calldata data
189     ) external;
190 
191     /**
192      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
193      */
194     function safeTransferFrom(
195         address from,
196         address to,
197         uint256 tokenId
198     ) external;
199 
200     /**
201      * @dev Transfers `tokenId` from `from` to `to`.
202      *
203      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
204      * whenever possible.
205      *
206      * Requirements:
207      *
208      * - `from` cannot be the zero address.
209      * - `to` cannot be the zero address.
210      * - `tokenId` token must be owned by `from`.
211      * - If the caller is not `from`, it must be approved to move this token
212      * by either {approve} or {setApprovalForAll}.
213      *
214      * Emits a {Transfer} event.
215      */
216     function transferFrom(
217         address from,
218         address to,
219         uint256 tokenId
220     ) external;
221 
222     /**
223      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
224      * The approval is cleared when the token is transferred.
225      *
226      * Only a single account can be approved at a time, so approving the
227      * zero address clears previous approvals.
228      *
229      * Requirements:
230      *
231      * - The caller must own the token or be an approved operator.
232      * - `tokenId` must exist.
233      *
234      * Emits an {Approval} event.
235      */
236     function approve(address to, uint256 tokenId) external;
237 
238     /**
239      * @dev Approve or remove `operator` as an operator for the caller.
240      * Operators can call {transferFrom} or {safeTransferFrom}
241      * for any token owned by the caller.
242      *
243      * Requirements:
244      *
245      * - The `operator` cannot be the caller.
246      *
247      * Emits an {ApprovalForAll} event.
248      */
249     function setApprovalForAll(address operator, bool _approved) external;
250 
251     /**
252      * @dev Returns the account approved for `tokenId` token.
253      *
254      * Requirements:
255      *
256      * - `tokenId` must exist.
257      */
258     function getApproved(uint256 tokenId) external view returns (address operator);
259 
260     /**
261      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
262      *
263      * See {setApprovalForAll}.
264      */
265     function isApprovedForAll(address owner, address operator) external view returns (bool);
266 
267     // =============================================================
268     //                        IERC721Metadata
269     // =============================================================
270 
271     /**
272      * @dev Returns the token collection name.
273      */
274     function name() external view returns (string memory);
275 
276     /**
277      * @dev Returns the token collection symbol.
278      */
279     function symbol() external view returns (string memory);
280 
281     /**
282      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
283      */
284     function tokenURI(uint256 tokenId) external view returns (string memory);
285 
286     // =============================================================
287     //                           IERC2309
288     // =============================================================
289 
290     /**
291      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
292      * (inclusive) is transferred from `from` to `to`, as defined in the
293      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
294      *
295      * See {_mintERC2309} for more details.
296      */
297     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
298 }
299 
300 // File: erc721a/contracts/ERC721A.sol
301 
302 
303 // ERC721A Contracts v4.2.0
304 // Creator: Chiru Labs
305 
306 pragma solidity ^0.8.4;
307 
308 
309 /**
310  * @dev Interface of ERC721 token receiver.
311  */
312 interface ERC721A__IERC721Receiver {
313     function onERC721Received(
314         address operator,
315         address from,
316         uint256 tokenId,
317         bytes calldata data
318     ) external returns (bytes4);
319 }
320 
321 /**
322  * @title ERC721A
323  *
324  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
325  * Non-Fungible Token Standard, including the Metadata extension.
326  * Optimized for lower gas during batch mints.
327  *
328  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
329  * starting from `_startTokenId()`.
330  *
331  * Assumptions:
332  *
333  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
334  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
335  */
336 contract ERC721A is IERC721A {
337     // Reference type for token approval.
338     struct TokenApprovalRef {
339         address value;
340     }
341 
342     // =============================================================
343     //                           CONSTANTS
344     // =============================================================
345 
346     // Mask of an entry in packed address data.
347     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
348 
349     // The bit position of `numberMinted` in packed address data.
350     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
351 
352     // The bit position of `numberBurned` in packed address data.
353     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
354 
355     // The bit position of `aux` in packed address data.
356     uint256 private constant _BITPOS_AUX = 192;
357 
358     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
359     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
360 
361     // The bit position of `startTimestamp` in packed ownership.
362     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
363 
364     // The bit mask of the `burned` bit in packed ownership.
365     uint256 private constant _BITMASK_BURNED = 1 << 224;
366 
367     // The bit position of the `nextInitialized` bit in packed ownership.
368     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
369 
370     // The bit mask of the `nextInitialized` bit in packed ownership.
371     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
372 
373     // The bit position of `extraData` in packed ownership.
374     uint256 private constant _BITPOS_EXTRA_DATA = 232;
375 
376     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
377     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
378 
379     // The mask of the lower 160 bits for addresses.
380     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
381 
382     // The maximum `quantity` that can be minted with {_mintERC2309}.
383     // This limit is to prevent overflows on the address data entries.
384     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
385     // is required to cause an overflow, which is unrealistic.
386     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
387 
388     // The `Transfer` event signature is given by:
389     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
390     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
391         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
392 
393     // =============================================================
394     //                            STORAGE
395     // =============================================================
396 
397     // The next token ID to be minted.
398     uint256 private _currentIndex;
399 
400     // The number of tokens burned.
401     uint256 private _burnCounter;
402 
403     // Token name
404     string private _name;
405 
406     // Token symbol
407     string private _symbol;
408 
409     // Mapping from token ID to ownership details
410     // An empty struct value does not necessarily mean the token is unowned.
411     // See {_packedOwnershipOf} implementation for details.
412     //
413     // Bits Layout:
414     // - [0..159]   `addr`
415     // - [160..223] `startTimestamp`
416     // - [224]      `burned`
417     // - [225]      `nextInitialized`
418     // - [232..255] `extraData`
419     mapping(uint256 => uint256) private _packedOwnerships;
420 
421     // Mapping owner address to address data.
422     //
423     // Bits Layout:
424     // - [0..63]    `balance`
425     // - [64..127]  `numberMinted`
426     // - [128..191] `numberBurned`
427     // - [192..255] `aux`
428     mapping(address => uint256) private _packedAddressData;
429 
430     // Mapping from token ID to approved address.
431     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
432 
433     // Mapping from owner to operator approvals
434     mapping(address => mapping(address => bool)) private _operatorApprovals;
435 
436     // =============================================================
437     //                          CONSTRUCTOR
438     // =============================================================
439 
440     constructor(string memory name_, string memory symbol_) {
441         _name = name_;
442         _symbol = symbol_;
443         _currentIndex = _startTokenId();
444     }
445 
446     // =============================================================
447     //                   TOKEN COUNTING OPERATIONS
448     // =============================================================
449 
450     /**
451      * @dev Returns the starting token ID.
452      * To change the starting token ID, please override this function.
453      */
454     function _startTokenId() internal view virtual returns (uint256) {
455         return 1;
456     }
457 
458     /**
459      * @dev Returns the next token ID to be minted.
460      */
461     function _nextTokenId() internal view virtual returns (uint256) {
462         return _currentIndex;
463     }
464 
465     /**
466      * @dev Returns the total number of tokens in existence.
467      * Burned tokens will reduce the count.
468      * To get the total number of tokens minted, please see {_totalMinted}.
469      */
470     function totalSupply() public view virtual override returns (uint256) {
471         // Counter underflow is impossible as _burnCounter cannot be incremented
472         // more than `_currentIndex - _startTokenId()` times.
473         unchecked {
474             return _currentIndex - _burnCounter - _startTokenId();
475         }
476     }
477 
478     /**
479      * @dev Returns the total amount of tokens minted in the contract.
480      */
481     function _totalMinted() internal view virtual returns (uint256) {
482         // Counter underflow is impossible as `_currentIndex` does not decrement,
483         // and it is initialized to `_startTokenId()`.
484         unchecked {
485             return _currentIndex - _startTokenId();
486         }
487     }
488 
489     /**
490      * @dev Returns the total number of tokens burned.
491      */
492     function _totalBurned() internal view virtual returns (uint256) {
493         return _burnCounter;
494     }
495 
496     // =============================================================
497     //                    ADDRESS DATA OPERATIONS
498     // =============================================================
499 
500     /**
501      * @dev Returns the number of tokens in `owner`'s account.
502      */
503     function balanceOf(address owner) public view virtual override returns (uint256) {
504         if (owner == address(0)) revert BalanceQueryForZeroAddress();
505         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
506     }
507 
508     /**
509      * Returns the number of tokens minted by `owner`.
510      */
511     function _numberMinted(address owner) internal view returns (uint256) {
512         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
513     }
514 
515     /**
516      * Returns the number of tokens burned by or on behalf of `owner`.
517      */
518     function _numberBurned(address owner) internal view returns (uint256) {
519         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
520     }
521 
522     /**
523      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
524      */
525     function _getAux(address owner) internal view returns (uint64) {
526         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
527     }
528 
529     /**
530      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
531      * If there are multiple variables, please pack them into a uint64.
532      */
533     function _setAux(address owner, uint64 aux) internal virtual {
534         uint256 packed = _packedAddressData[owner];
535         uint256 auxCasted;
536         // Cast `aux` with assembly to avoid redundant masking.
537         assembly {
538             auxCasted := aux
539         }
540         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
541         _packedAddressData[owner] = packed;
542     }
543 
544     // =============================================================
545     //                            IERC165
546     // =============================================================
547 
548     /**
549      * @dev Returns true if this contract implements the interface defined by
550      * `interfaceId`. See the corresponding
551      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
552      * to learn more about how these ids are created.
553      *
554      * This function call must use less than 30000 gas.
555      */
556     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
557         // The interface IDs are constants representing the first 4 bytes
558         // of the XOR of all function selectors in the interface.
559         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
560         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
561         return
562             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
563             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
564             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
565     }
566 
567     // =============================================================
568     //                        IERC721Metadata
569     // =============================================================
570 
571     /**
572      * @dev Returns the token collection name.
573      */
574     function name() public view virtual override returns (string memory) {
575         return _name;
576     }
577 
578     /**
579      * @dev Returns the token collection symbol.
580      */
581     function symbol() public view virtual override returns (string memory) {
582         return _symbol;
583     }
584 
585     /**
586      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
587      */
588     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
589         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
590 
591         string memory baseURI = _baseURI();
592         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
593     }
594 
595     /**
596      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
597      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
598      * by default, it can be overridden in child contracts.
599      */
600     function _baseURI() internal view virtual returns (string memory) {
601         return '';
602     }
603 
604     // =============================================================
605     //                     OWNERSHIPS OPERATIONS
606     // =============================================================
607 
608     /**
609      * @dev Returns the owner of the `tokenId` token.
610      *
611      * Requirements:
612      *
613      * - `tokenId` must exist.
614      */
615     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
616         return address(uint160(_packedOwnershipOf(tokenId)));
617     }
618 
619     /**
620      * @dev Gas spent here starts off proportional to the maximum mint batch size.
621      * It gradually moves to O(1) as tokens get transferred around over time.
622      */
623     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
624         return _unpackedOwnership(_packedOwnershipOf(tokenId));
625     }
626 
627     /**
628      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
629      */
630     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
631         return _unpackedOwnership(_packedOwnerships[index]);
632     }
633 
634     /**
635      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
636      */
637     function _initializeOwnershipAt(uint256 index) internal virtual {
638         if (_packedOwnerships[index] == 0) {
639             _packedOwnerships[index] = _packedOwnershipOf(index);
640         }
641     }
642 
643     /**
644      * Returns the packed ownership data of `tokenId`.
645      */
646     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
647         uint256 curr = tokenId;
648 
649         unchecked {
650             if (_startTokenId() <= curr)
651                 if (curr < _currentIndex) {
652                     uint256 packed = _packedOwnerships[curr];
653                     // If not burned.
654                     if (packed & _BITMASK_BURNED == 0) {
655                         // Invariant:
656                         // There will always be an initialized ownership slot
657                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
658                         // before an unintialized ownership slot
659                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
660                         // Hence, `curr` will not underflow.
661                         //
662                         // We can directly compare the packed value.
663                         // If the address is zero, packed will be zero.
664                         while (packed == 0) {
665                             packed = _packedOwnerships[--curr];
666                         }
667                         return packed;
668                     }
669                 }
670         }
671         revert OwnerQueryForNonexistentToken();
672     }
673 
674     /**
675      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
676      */
677     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
678         ownership.addr = address(uint160(packed));
679         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
680         ownership.burned = packed & _BITMASK_BURNED != 0;
681         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
682     }
683 
684     /**
685      * @dev Packs ownership data into a single uint256.
686      */
687     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
688         assembly {
689             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
690             owner := and(owner, _BITMASK_ADDRESS)
691             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
692             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
693         }
694     }
695 
696     /**
697      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
698      */
699     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
700         // For branchless setting of the `nextInitialized` flag.
701         assembly {
702             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
703             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
704         }
705     }
706 
707     // =============================================================
708     //                      APPROVAL OPERATIONS
709     // =============================================================
710 
711     /**
712      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
713      * The approval is cleared when the token is transferred.
714      *
715      * Only a single account can be approved at a time, so approving the
716      * zero address clears previous approvals.
717      *
718      * Requirements:
719      *
720      * - The caller must own the token or be an approved operator.
721      * - `tokenId` must exist.
722      *
723      * Emits an {Approval} event.
724      */
725     function approve(address to, uint256 tokenId) public virtual override {
726         address owner = ownerOf(tokenId);
727 
728         if (_msgSenderERC721A() != owner)
729             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
730                 revert ApprovalCallerNotOwnerNorApproved();
731             }
732 
733         _tokenApprovals[tokenId].value = to;
734         emit Approval(owner, to, tokenId);
735     }
736 
737     /**
738      * @dev Returns the account approved for `tokenId` token.
739      *
740      * Requirements:
741      *
742      * - `tokenId` must exist.
743      */
744     function getApproved(uint256 tokenId) public view virtual override returns (address) {
745         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
746 
747         return _tokenApprovals[tokenId].value;
748     }
749 
750     /**
751      * @dev Approve or remove `operator` as an operator for the caller.
752      * Operators can call {transferFrom} or {safeTransferFrom}
753      * for any token owned by the caller.
754      *
755      * Requirements:
756      *
757      * - The `operator` cannot be the caller.
758      *
759      * Emits an {ApprovalForAll} event.
760      */
761     function setApprovalForAll(address operator, bool approved) public virtual override {
762         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
763 
764         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
765         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
766     }
767 
768     /**
769      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
770      *
771      * See {setApprovalForAll}.
772      */
773     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
774         return _operatorApprovals[owner][operator];
775     }
776 
777     /**
778      * @dev Returns whether `tokenId` exists.
779      *
780      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
781      *
782      * Tokens start existing when they are minted. See {_mint}.
783      */
784     function _exists(uint256 tokenId) internal view virtual returns (bool) {
785         return
786             _startTokenId() <= tokenId &&
787             tokenId < _currentIndex && // If within bounds,
788             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
789     }
790 
791     /**
792      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
793      */
794     function _isSenderApprovedOrOwner(
795         address approvedAddress,
796         address owner,
797         address msgSender
798     ) private pure returns (bool result) {
799         assembly {
800             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
801             owner := and(owner, _BITMASK_ADDRESS)
802             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
803             msgSender := and(msgSender, _BITMASK_ADDRESS)
804             // `msgSender == owner || msgSender == approvedAddress`.
805             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
806         }
807     }
808 
809     /**
810      * @dev Returns the storage slot and value for the approved address of `tokenId`.
811      */
812     function _getApprovedSlotAndAddress(uint256 tokenId)
813         private
814         view
815         returns (uint256 approvedAddressSlot, address approvedAddress)
816     {
817         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
818         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
819         assembly {
820             approvedAddressSlot := tokenApproval.slot
821             approvedAddress := sload(approvedAddressSlot)
822         }
823     }
824 
825     // =============================================================
826     //                      TRANSFER OPERATIONS
827     // =============================================================
828 
829     /**
830      * @dev Transfers `tokenId` from `from` to `to`.
831      *
832      * Requirements:
833      *
834      * - `from` cannot be the zero address.
835      * - `to` cannot be the zero address.
836      * - `tokenId` token must be owned by `from`.
837      * - If the caller is not `from`, it must be approved to move this token
838      * by either {approve} or {setApprovalForAll}.
839      *
840      * Emits a {Transfer} event.
841      */
842     function transferFrom(
843         address from,
844         address to,
845         uint256 tokenId
846     ) public virtual override {
847         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
848 
849         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
850 
851         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
852 
853         // The nested ifs save around 20+ gas over a compound boolean condition.
854         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
855             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
856 
857         if (to == address(0)) revert TransferToZeroAddress();
858 
859         _beforeTokenTransfers(from, to, tokenId, 1);
860 
861         // Clear approvals from the previous owner.
862         assembly {
863             if approvedAddress {
864                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
865                 sstore(approvedAddressSlot, 0)
866             }
867         }
868 
869         // Underflow of the sender's balance is impossible because we check for
870         // ownership above and the recipient's balance can't realistically overflow.
871         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
872         unchecked {
873             // We can directly increment and decrement the balances.
874             --_packedAddressData[from]; // Updates: `balance -= 1`.
875             ++_packedAddressData[to]; // Updates: `balance += 1`.
876 
877             // Updates:
878             // - `address` to the next owner.
879             // - `startTimestamp` to the timestamp of transfering.
880             // - `burned` to `false`.
881             // - `nextInitialized` to `true`.
882             _packedOwnerships[tokenId] = _packOwnershipData(
883                 to,
884                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
885             );
886 
887             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
888             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
889                 uint256 nextTokenId = tokenId + 1;
890                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
891                 if (_packedOwnerships[nextTokenId] == 0) {
892                     // If the next slot is within bounds.
893                     if (nextTokenId != _currentIndex) {
894                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
895                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
896                     }
897                 }
898             }
899         }
900 
901         emit Transfer(from, to, tokenId);
902         _afterTokenTransfers(from, to, tokenId, 1);
903     }
904 
905     /**
906      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
907      */
908     function safeTransferFrom(
909         address from,
910         address to,
911         uint256 tokenId
912     ) public virtual override {
913         safeTransferFrom(from, to, tokenId, '');
914     }
915 
916     /**
917      * @dev Safely transfers `tokenId` token from `from` to `to`.
918      *
919      * Requirements:
920      *
921      * - `from` cannot be the zero address.
922      * - `to` cannot be the zero address.
923      * - `tokenId` token must exist and be owned by `from`.
924      * - If the caller is not `from`, it must be approved to move this token
925      * by either {approve} or {setApprovalForAll}.
926      * - If `to` refers to a smart contract, it must implement
927      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
928      *
929      * Emits a {Transfer} event.
930      */
931     function safeTransferFrom(
932         address from,
933         address to,
934         uint256 tokenId,
935         bytes memory _data
936     ) public virtual override {
937         transferFrom(from, to, tokenId);
938         if (to.code.length != 0)
939             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
940                 revert TransferToNonERC721ReceiverImplementer();
941             }
942     }
943 
944     /**
945      * @dev Hook that is called before a set of serially-ordered token IDs
946      * are about to be transferred. This includes minting.
947      * And also called before burning one token.
948      *
949      * `startTokenId` - the first token ID to be transferred.
950      * `quantity` - the amount to be transferred.
951      *
952      * Calling conditions:
953      *
954      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
955      * transferred to `to`.
956      * - When `from` is zero, `tokenId` will be minted for `to`.
957      * - When `to` is zero, `tokenId` will be burned by `from`.
958      * - `from` and `to` are never both zero.
959      */
960     function _beforeTokenTransfers(
961         address from,
962         address to,
963         uint256 startTokenId,
964         uint256 quantity
965     ) internal virtual {}
966 
967     /**
968      * @dev Hook that is called after a set of serially-ordered token IDs
969      * have been transferred. This includes minting.
970      * And also called after one token has been burned.
971      *
972      * `startTokenId` - the first token ID to be transferred.
973      * `quantity` - the amount to be transferred.
974      *
975      * Calling conditions:
976      *
977      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
978      * transferred to `to`.
979      * - When `from` is zero, `tokenId` has been minted for `to`.
980      * - When `to` is zero, `tokenId` has been burned by `from`.
981      * - `from` and `to` are never both zero.
982      */
983     function _afterTokenTransfers(
984         address from,
985         address to,
986         uint256 startTokenId,
987         uint256 quantity
988     ) internal virtual {}
989 
990     /**
991      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
992      *
993      * `from` - Previous owner of the given token ID.
994      * `to` - Target address that will receive the token.
995      * `tokenId` - Token ID to be transferred.
996      * `_data` - Optional data to send along with the call.
997      *
998      * Returns whether the call correctly returned the expected magic value.
999      */
1000     function _checkContractOnERC721Received(
1001         address from,
1002         address to,
1003         uint256 tokenId,
1004         bytes memory _data
1005     ) private returns (bool) {
1006         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1007             bytes4 retval
1008         ) {
1009             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1010         } catch (bytes memory reason) {
1011             if (reason.length == 0) {
1012                 revert TransferToNonERC721ReceiverImplementer();
1013             } else {
1014                 assembly {
1015                     revert(add(32, reason), mload(reason))
1016                 }
1017             }
1018         }
1019     }
1020 
1021     // =============================================================
1022     //                        MINT OPERATIONS
1023     // =============================================================
1024 
1025     /**
1026      * @dev Mints `quantity` tokens and transfers them to `to`.
1027      *
1028      * Requirements:
1029      *
1030      * - `to` cannot be the zero address.
1031      * - `quantity` must be greater than 0.
1032      *
1033      * Emits a {Transfer} event for each mint.
1034      */
1035     function _mint(address to, uint256 quantity) internal virtual {
1036         uint256 startTokenId = _currentIndex;
1037         if (quantity == 0) revert MintZeroQuantity();
1038 
1039         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1040 
1041         // Overflows are incredibly unrealistic.
1042         // `balance` and `numberMinted` have a maximum limit of 2**64.
1043         // `tokenId` has a maximum limit of 2**256.
1044         unchecked {
1045             // Updates:
1046             // - `balance += quantity`.
1047             // - `numberMinted += quantity`.
1048             //
1049             // We can directly add to the `balance` and `numberMinted`.
1050             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1051 
1052             // Updates:
1053             // - `address` to the owner.
1054             // - `startTimestamp` to the timestamp of minting.
1055             // - `burned` to `false`.
1056             // - `nextInitialized` to `quantity == 1`.
1057             _packedOwnerships[startTokenId] = _packOwnershipData(
1058                 to,
1059                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1060             );
1061 
1062             uint256 toMasked;
1063             uint256 end = startTokenId + quantity;
1064 
1065             // Use assembly to loop and emit the `Transfer` event for gas savings.
1066             assembly {
1067                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1068                 toMasked := and(to, _BITMASK_ADDRESS)
1069                 // Emit the `Transfer` event.
1070                 log4(
1071                     0, // Start of data (0, since no data).
1072                     0, // End of data (0, since no data).
1073                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1074                     0, // `address(0)`.
1075                     toMasked, // `to`.
1076                     startTokenId // `tokenId`.
1077                 )
1078 
1079                 for {
1080                     let tokenId := add(startTokenId, 1)
1081                 } iszero(eq(tokenId, end)) {
1082                     tokenId := add(tokenId, 1)
1083                 } {
1084                     // Emit the `Transfer` event. Similar to above.
1085                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1086                 }
1087             }
1088             if (toMasked == 0) revert MintToZeroAddress();
1089 
1090             _currentIndex = end;
1091         }
1092         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1093     }
1094 
1095     /**
1096      * @dev Mints `quantity` tokens and transfers them to `to`.
1097      *
1098      * This function is intended for efficient minting only during contract creation.
1099      *
1100      * It emits only one {ConsecutiveTransfer} as defined in
1101      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1102      * instead of a sequence of {Transfer} event(s).
1103      *
1104      * Calling this function outside of contract creation WILL make your contract
1105      * non-compliant with the ERC721 standard.
1106      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1107      * {ConsecutiveTransfer} event is only permissible during contract creation.
1108      *
1109      * Requirements:
1110      *
1111      * - `to` cannot be the zero address.
1112      * - `quantity` must be greater than 0.
1113      *
1114      * Emits a {ConsecutiveTransfer} event.
1115      */
1116     function _mintERC2309(address to, uint256 quantity) internal virtual {
1117         uint256 startTokenId = _currentIndex;
1118         if (to == address(0)) revert MintToZeroAddress();
1119         if (quantity == 0) revert MintZeroQuantity();
1120         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1121 
1122         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1123 
1124         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1125         unchecked {
1126             // Updates:
1127             // - `balance += quantity`.
1128             // - `numberMinted += quantity`.
1129             //
1130             // We can directly add to the `balance` and `numberMinted`.
1131             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1132 
1133             // Updates:
1134             // - `address` to the owner.
1135             // - `startTimestamp` to the timestamp of minting.
1136             // - `burned` to `false`.
1137             // - `nextInitialized` to `quantity == 1`.
1138             _packedOwnerships[startTokenId] = _packOwnershipData(
1139                 to,
1140                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1141             );
1142 
1143             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1144 
1145             _currentIndex = startTokenId + quantity;
1146         }
1147         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1148     }
1149 
1150     /**
1151      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1152      *
1153      * Requirements:
1154      *
1155      * - If `to` refers to a smart contract, it must implement
1156      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1157      * - `quantity` must be greater than 0.
1158      *
1159      * See {_mint}.
1160      *
1161      * Emits a {Transfer} event for each mint.
1162      */
1163     function _safeMint(
1164         address to,
1165         uint256 quantity,
1166         bytes memory _data
1167     ) internal virtual {
1168         _mint(to, quantity);
1169 
1170         unchecked {
1171             if (to.code.length != 0) {
1172                 uint256 end = _currentIndex;
1173                 uint256 index = end - quantity;
1174                 do {
1175                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1176                         revert TransferToNonERC721ReceiverImplementer();
1177                     }
1178                 } while (index < end);
1179                 // Reentrancy protection.
1180                 if (_currentIndex != end) revert();
1181             }
1182         }
1183     }
1184 
1185     /**
1186      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1187      */
1188     function _safeMint(address to, uint256 quantity) internal virtual {
1189         _safeMint(to, quantity, '');
1190     }
1191 
1192     // =============================================================
1193     //                        BURN OPERATIONS
1194     // =============================================================
1195 
1196     /**
1197      * @dev Equivalent to `_burn(tokenId, false)`.
1198      */
1199     function _burn(uint256 tokenId) internal virtual {
1200         _burn(tokenId, false);
1201     }
1202 
1203     /**
1204      * @dev Destroys `tokenId`.
1205      * The approval is cleared when the token is burned.
1206      *
1207      * Requirements:
1208      *
1209      * - `tokenId` must exist.
1210      *
1211      * Emits a {Transfer} event.
1212      */
1213     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1214         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1215 
1216         address from = address(uint160(prevOwnershipPacked));
1217 
1218         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1219 
1220         if (approvalCheck) {
1221             // The nested ifs save around 20+ gas over a compound boolean condition.
1222             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1223                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1224         }
1225 
1226         _beforeTokenTransfers(from, address(0), tokenId, 1);
1227 
1228         // Clear approvals from the previous owner.
1229         assembly {
1230             if approvedAddress {
1231                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1232                 sstore(approvedAddressSlot, 0)
1233             }
1234         }
1235 
1236         // Underflow of the sender's balance is impossible because we check for
1237         // ownership above and the recipient's balance can't realistically overflow.
1238         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1239         unchecked {
1240             // Updates:
1241             // - `balance -= 1`.
1242             // - `numberBurned += 1`.
1243             //
1244             // We can directly decrement the balance, and increment the number burned.
1245             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1246             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1247 
1248             // Updates:
1249             // - `address` to the last owner.
1250             // - `startTimestamp` to the timestamp of burning.
1251             // - `burned` to `true`.
1252             // - `nextInitialized` to `true`.
1253             _packedOwnerships[tokenId] = _packOwnershipData(
1254                 from,
1255                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1256             );
1257 
1258             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1259             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1260                 uint256 nextTokenId = tokenId + 1;
1261                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1262                 if (_packedOwnerships[nextTokenId] == 0) {
1263                     // If the next slot is within bounds.
1264                     if (nextTokenId != _currentIndex) {
1265                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1266                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1267                     }
1268                 }
1269             }
1270         }
1271 
1272         emit Transfer(from, address(0), tokenId);
1273         _afterTokenTransfers(from, address(0), tokenId, 1);
1274 
1275         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1276         unchecked {
1277             _burnCounter++;
1278         }
1279     }
1280 
1281     // =============================================================
1282     //                     EXTRA DATA OPERATIONS
1283     // =============================================================
1284 
1285     /**
1286      * @dev Directly sets the extra data for the ownership data `index`.
1287      */
1288     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1289         uint256 packed = _packedOwnerships[index];
1290         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1291         uint256 extraDataCasted;
1292         // Cast `extraData` with assembly to avoid redundant masking.
1293         assembly {
1294             extraDataCasted := extraData
1295         }
1296         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1297         _packedOwnerships[index] = packed;
1298     }
1299 
1300     /**
1301      * @dev Called during each token transfer to set the 24bit `extraData` field.
1302      * Intended to be overridden by the cosumer contract.
1303      *
1304      * `previousExtraData` - the value of `extraData` before transfer.
1305      *
1306      * Calling conditions:
1307      *
1308      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1309      * transferred to `to`.
1310      * - When `from` is zero, `tokenId` will be minted for `to`.
1311      * - When `to` is zero, `tokenId` will be burned by `from`.
1312      * - `from` and `to` are never both zero.
1313      */
1314     function _extraData(
1315         address from,
1316         address to,
1317         uint24 previousExtraData
1318     ) internal view virtual returns (uint24) {}
1319 
1320     /**
1321      * @dev Returns the next extra data for the packed ownership data.
1322      * The returned result is shifted into position.
1323      */
1324     function _nextExtraData(
1325         address from,
1326         address to,
1327         uint256 prevOwnershipPacked
1328     ) private view returns (uint256) {
1329         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1330         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1331     }
1332 
1333     // =============================================================
1334     //                       OTHER OPERATIONS
1335     // =============================================================
1336 
1337     /**
1338      * @dev Returns the message sender (defaults to `msg.sender`).
1339      *
1340      * If you are writing GSN compatible contracts, you need to override this function.
1341      */
1342     function _msgSenderERC721A() internal view virtual returns (address) {
1343         return msg.sender;
1344     }
1345 
1346     /**
1347      * @dev Converts a uint256 to its ASCII string decimal representation.
1348      */
1349     function _toString(uint256 value) internal pure virtual returns (string memory ptr) {
1350         assembly {
1351             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1352             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1353             // We will need 1 32-byte word to store the length,
1354             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1355             ptr := add(mload(0x40), 128)
1356             // Update the free memory pointer to allocate.
1357             mstore(0x40, ptr)
1358 
1359             // Cache the end of the memory to calculate the length later.
1360             let end := ptr
1361 
1362             // We write the string from the rightmost digit to the leftmost digit.
1363             // The following is essentially a do-while loop that also handles the zero case.
1364             // Costs a bit more than early returning for the zero case,
1365             // but cheaper in terms of deployment and overall runtime costs.
1366             for {
1367                 // Initialize and perform the first pass without check.
1368                 let temp := value
1369                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1370                 ptr := sub(ptr, 1)
1371                 // Write the character to the pointer.
1372                 // The ASCII index of the '0' character is 48.
1373                 mstore8(ptr, add(48, mod(temp, 10)))
1374                 temp := div(temp, 10)
1375             } temp {
1376                 // Keep dividing `temp` until zero.
1377                 temp := div(temp, 10)
1378             } {
1379                 // Body of the for loop.
1380                 ptr := sub(ptr, 1)
1381                 mstore8(ptr, add(48, mod(temp, 10)))
1382             }
1383 
1384             let length := sub(end, ptr)
1385             // Move the pointer 32 bytes leftwards to make room for the length.
1386             ptr := sub(ptr, 32)
1387             // Store the length.
1388             mstore(ptr, length)
1389         }
1390     }
1391 }
1392 
1393 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
1394 
1395 
1396 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
1397 
1398 pragma solidity ^0.8.0;
1399 
1400 /**
1401  * @dev These functions deal with verification of Merkle Tree proofs.
1402  *
1403  * The proofs can be generated using the JavaScript library
1404  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1405  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1406  *
1407  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1408  *
1409  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1410  * hashing, or use a hash function other than keccak256 for hashing leaves.
1411  * This is because the concatenation of a sorted pair of internal nodes in
1412  * the merkle tree could be reinterpreted as a leaf value.
1413  */
1414 library MerkleProof {
1415     /**
1416      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1417      * defined by `root`. For this, a `proof` must be provided, containing
1418      * sibling hashes on the branch from the leaf to the root of the tree. Each
1419      * pair of leaves and each pair of pre-images are assumed to be sorted.
1420      */
1421     function verify(
1422         bytes32[] memory proof,
1423         bytes32 root,
1424         bytes32 leaf
1425     ) internal pure returns (bool) {
1426         return processProof(proof, leaf) == root;
1427     }
1428 
1429     /**
1430      * @dev Calldata version of {verify}
1431      *
1432      * _Available since v4.7._
1433      */
1434     function verifyCalldata(
1435         bytes32[] calldata proof,
1436         bytes32 root,
1437         bytes32 leaf
1438     ) internal pure returns (bool) {
1439         return processProofCalldata(proof, leaf) == root;
1440     }
1441 
1442     /**
1443      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1444      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1445      * hash matches the root of the tree. When processing the proof, the pairs
1446      * of leafs & pre-images are assumed to be sorted.
1447      *
1448      * _Available since v4.4._
1449      */
1450     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1451         bytes32 computedHash = leaf;
1452         for (uint256 i = 0; i < proof.length; i++) {
1453             computedHash = _hashPair(computedHash, proof[i]);
1454         }
1455         return computedHash;
1456     }
1457 
1458     /**
1459      * @dev Calldata version of {processProof}
1460      *
1461      * _Available since v4.7._
1462      */
1463     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
1464         bytes32 computedHash = leaf;
1465         for (uint256 i = 0; i < proof.length; i++) {
1466             computedHash = _hashPair(computedHash, proof[i]);
1467         }
1468         return computedHash;
1469     }
1470 
1471     /**
1472      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
1473      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
1474      *
1475      * _Available since v4.7._
1476      */
1477     function multiProofVerify(
1478         bytes32[] memory proof,
1479         bool[] memory proofFlags,
1480         bytes32 root,
1481         bytes32[] memory leaves
1482     ) internal pure returns (bool) {
1483         return processMultiProof(proof, proofFlags, leaves) == root;
1484     }
1485 
1486     /**
1487      * @dev Calldata version of {multiProofVerify}
1488      *
1489      * _Available since v4.7._
1490      */
1491     function multiProofVerifyCalldata(
1492         bytes32[] calldata proof,
1493         bool[] calldata proofFlags,
1494         bytes32 root,
1495         bytes32[] memory leaves
1496     ) internal pure returns (bool) {
1497         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
1498     }
1499 
1500     /**
1501      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
1502      * consuming from one or the other at each step according to the instructions given by
1503      * `proofFlags`.
1504      *
1505      * _Available since v4.7._
1506      */
1507     function processMultiProof(
1508         bytes32[] memory proof,
1509         bool[] memory proofFlags,
1510         bytes32[] memory leaves
1511     ) internal pure returns (bytes32 merkleRoot) {
1512         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1513         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1514         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1515         // the merkle tree.
1516         uint256 leavesLen = leaves.length;
1517         uint256 totalHashes = proofFlags.length;
1518 
1519         // Check proof validity.
1520         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1521 
1522         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1523         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1524         bytes32[] memory hashes = new bytes32[](totalHashes);
1525         uint256 leafPos = 0;
1526         uint256 hashPos = 0;
1527         uint256 proofPos = 0;
1528         // At each step, we compute the next hash using two values:
1529         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1530         //   get the next hash.
1531         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1532         //   `proof` array.
1533         for (uint256 i = 0; i < totalHashes; i++) {
1534             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1535             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1536             hashes[i] = _hashPair(a, b);
1537         }
1538 
1539         if (totalHashes > 0) {
1540             return hashes[totalHashes - 1];
1541         } else if (leavesLen > 0) {
1542             return leaves[0];
1543         } else {
1544             return proof[0];
1545         }
1546     }
1547 
1548     /**
1549      * @dev Calldata version of {processMultiProof}
1550      *
1551      * _Available since v4.7._
1552      */
1553     function processMultiProofCalldata(
1554         bytes32[] calldata proof,
1555         bool[] calldata proofFlags,
1556         bytes32[] memory leaves
1557     ) internal pure returns (bytes32 merkleRoot) {
1558         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1559         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1560         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1561         // the merkle tree.
1562         uint256 leavesLen = leaves.length;
1563         uint256 totalHashes = proofFlags.length;
1564 
1565         // Check proof validity.
1566         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1567 
1568         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1569         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1570         bytes32[] memory hashes = new bytes32[](totalHashes);
1571         uint256 leafPos = 0;
1572         uint256 hashPos = 0;
1573         uint256 proofPos = 0;
1574         // At each step, we compute the next hash using two values:
1575         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1576         //   get the next hash.
1577         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1578         //   `proof` array.
1579         for (uint256 i = 0; i < totalHashes; i++) {
1580             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1581             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1582             hashes[i] = _hashPair(a, b);
1583         }
1584 
1585         if (totalHashes > 0) {
1586             return hashes[totalHashes - 1];
1587         } else if (leavesLen > 0) {
1588             return leaves[0];
1589         } else {
1590             return proof[0];
1591         }
1592     }
1593 
1594     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
1595         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
1596     }
1597 
1598     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1599         /// @solidity memory-safe-assembly
1600         assembly {
1601             mstore(0x00, a)
1602             mstore(0x20, b)
1603             value := keccak256(0x00, 0x40)
1604         }
1605     }
1606 }
1607 
1608 // File: @openzeppelin/contracts/utils/Context.sol
1609 
1610 
1611 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1612 
1613 pragma solidity ^0.8.0;
1614 
1615 /**
1616  * @dev Provides information about the current execution context, including the
1617  * sender of the transaction and its data. While these are generally available
1618  * via msg.sender and msg.data, they should not be accessed in such a direct
1619  * manner, since when dealing with meta-transactions the account sending and
1620  * paying for execution may not be the actual sender (as far as an application
1621  * is concerned).
1622  *
1623  * This contract is only required for intermediate, library-like contracts.
1624  */
1625 abstract contract Context {
1626     function _msgSender() internal view virtual returns (address) {
1627         return msg.sender;
1628     }
1629 
1630     function _msgData() internal view virtual returns (bytes calldata) {
1631         return msg.data;
1632     }
1633 }
1634 
1635 // File: @openzeppelin/contracts/access/Ownable.sol
1636 
1637 
1638 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1639 
1640 pragma solidity ^0.8.0;
1641 
1642 
1643 /**
1644  * @dev Contract module which provides a basic access control mechanism, where
1645  * there is an account (an owner) that can be granted exclusive access to
1646  * specific functions.
1647  *
1648  * By default, the owner account will be the one that deploys the contract. This
1649  * can later be changed with {transferOwnership}.
1650  *
1651  * This module is used through inheritance. It will make available the modifier
1652  * `onlyOwner`, which can be applied to your functions to restrict their use to
1653  * the owner.
1654  */
1655 abstract contract Ownable is Context {
1656     address private _owner;
1657 
1658     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1659 
1660     /**
1661      * @dev Initializes the contract setting the deployer as the initial owner.
1662      */
1663     constructor() {
1664         _transferOwnership(_msgSender());
1665     }
1666 
1667     /**
1668      * @dev Throws if called by any account other than the owner.
1669      */
1670     modifier onlyOwner() {
1671         _checkOwner();
1672         _;
1673     }
1674 
1675     /**
1676      * @dev Returns the address of the current owner.
1677      */
1678     function owner() public view virtual returns (address) {
1679         return _owner;
1680     }
1681 
1682     /**
1683      * @dev Throws if the sender is not the owner.
1684      */
1685     function _checkOwner() internal view virtual {
1686         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1687     }
1688 
1689     /**
1690      * @dev Leaves the contract without owner. It will not be possible to call
1691      * `onlyOwner` functions anymore. Can only be called by the current owner.
1692      *
1693      * NOTE: Renouncing ownership will leave the contract without an owner,
1694      * thereby removing any functionality that is only available to the owner.
1695      */
1696     function renounceOwnership() public virtual onlyOwner {
1697         _transferOwnership(address(0));
1698     }
1699 
1700     /**
1701      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1702      * Can only be called by the current owner.
1703      */
1704     function transferOwnership(address newOwner) public virtual onlyOwner {
1705         require(newOwner != address(0), "Ownable: new owner is the zero address");
1706         _transferOwnership(newOwner);
1707     }
1708 
1709     /**
1710      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1711      * Internal function without access restriction.
1712      */
1713     function _transferOwnership(address newOwner) internal virtual {
1714         address oldOwner = _owner;
1715         _owner = newOwner;
1716         emit OwnershipTransferred(oldOwner, newOwner);
1717     }
1718 }
1719 
1720 // File: lilverse.sol
1721 
1722 
1723 pragma solidity ^0.8.0;
1724 
1725 
1726 //MAX_PER_WALLET - максимум на кошелек
1727 //MAX_PURCHASE - максимум за транзакцию
1728 
1729 contract Yukino is ERC721A, Ownable {
1730     uint256 public MINT_PRICE = 0.005 ether;
1731     uint256 public MAX_SUPPLY = 420;
1732     uint256 public MAX_PER_WALLET = 10;
1733     uint256 public constant MAX_PURCHASE = 20;
1734 
1735     constructor() ERC721A("Yukino", "YKN") {}
1736 
1737     modifier hasCorrectAmount(uint256 _wei, uint256 _quantity) {
1738         require(_wei >= MINT_PRICE * _quantity, "Insufficent funds");
1739         _;
1740     }
1741 
1742     modifier withinMaximumSupply(uint256 _quantity) {
1743         require(totalSupply() + _quantity <= MAX_SUPPLY, "Surpasses supply");
1744         _;
1745     }
1746 
1747     /**
1748      * Public sale and whitelist sale mechansim
1749      */
1750     bool public publicSale = false;
1751     
1752 
1753     modifier publicSaleActive() {
1754         require(publicSale, "Public sale not started");
1755         _;
1756     }
1757 
1758     function setPublicSale(bool toggle) external onlyOwner {
1759         publicSale = toggle;
1760     }
1761 
1762 
1763     /**
1764      * Public minting
1765      */
1766     mapping(address => uint256) public publicAddressMintCount;
1767 
1768     function mintPublic(uint256 _quantity)
1769         public
1770         payable
1771         publicSaleActive
1772         hasCorrectAmount(msg.value, _quantity)
1773         withinMaximumSupply(_quantity)
1774     {
1775         require(
1776             _quantity > 0 && _quantity <= MAX_PURCHASE &&
1777                 publicAddressMintCount[msg.sender] + _quantity <=
1778                 MAX_PER_WALLET,
1779             "Minting above public limit"
1780         );
1781         publicAddressMintCount[msg.sender] += _quantity;
1782         _safeMint(msg.sender, _quantity);
1783     }
1784 
1785     modifier hasValidTier(uint256 tier) {
1786         require(tier >= 0 && tier <= 4, "Invalid Tier");
1787         _;
1788     }
1789 
1790     modifier hasValidMerkleProof(bytes32[] calldata merkleProof, bytes32 root) {
1791         require(
1792             MerkleProof.verify(
1793                 merkleProof,
1794                 root,
1795                 keccak256(abi.encodePacked(msg.sender))
1796             ),
1797             "Address not whitelisted"
1798         );
1799         _;
1800     }
1801 
1802     function withdraw() external onlyOwner {
1803         payable(msg.sender).transfer(address(this).balance);
1804     }
1805 
1806     /**
1807      * Admin minting
1808      */
1809     function mintAdmin(address _recipient, uint256 _quantity)
1810         public
1811         onlyOwner
1812         withinMaximumSupply(_quantity)
1813     {
1814         _safeMint(_recipient, _quantity);
1815     }
1816 
1817     /**
1818      * Base URI
1819      */
1820     string private baseURI;
1821 
1822     function setBaseURI(string memory baseURI_) external onlyOwner {
1823         baseURI = baseURI_;
1824     }
1825 
1826     function _baseURI() internal view virtual override returns (string memory) {
1827         return baseURI;
1828     }
1829 
1830      function tokenURI(uint256 tokenId) public view override returns (string memory) {
1831         return string(abi.encodePacked(baseURI, _toString(tokenId), ".json"));
1832     }
1833 
1834     function cutS(uint256 maxT) external onlyOwner {
1835         MAX_SUPPLY = maxT;
1836     }
1837 
1838     function setPrice(uint256 newPrice, uint256 maxPerWallet) external onlyOwner {
1839         MINT_PRICE = newPrice;
1840         MAX_PER_WALLET = maxPerWallet;
1841     }
1842 
1843 }