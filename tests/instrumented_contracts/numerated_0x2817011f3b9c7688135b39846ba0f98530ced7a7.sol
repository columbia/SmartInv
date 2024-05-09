1 /**
2 
3   .-')      ('-.       .-') _   .-')    ('-. .-.          
4  ( OO ).  _(  OO)     ( OO ) ) ( OO ). ( OO )  /          
5 (_)---\_)(,------.,--./ ,--,' (_)---\_),--. ,--.  ,-.-')  
6 /    _ |  |  .---'|   \ |  |\ /    _ | |  | |  |  |  |OO) 
7 \  :` `.  |  |    |    \|  | )\  :` `. |   .|  |  |  |  \ 
8  '..`''.)(|  '--. |  .     |/  '..`''.)|       |  |  |(_/ 
9 .-._)   \ |  .--' |  |\    |  .-._)   \|  .-.  | ,|  |_.' 
10 \       / |  `---.|  | \   |  \       /|  | |  |(_|  |    
11  `-----'  `------'`--'  `--'   `-----' `--' `--'  `--'    
12 
13 */
14 
15 // SPDX-License-Identifier: MIT
16 
17 pragma solidity ^0.8.13;
18 
19 // File: erc721a/contracts/IERC721A.sol
20 
21 // ERC721A Contracts v4.2.3
22 // Creator: Chiru Labs
23 
24 /**
25  * @dev Interface of ERC721A.
26  */
27 interface IERC721A {
28     /**
29      * The caller must own the token or be an approved operator.
30      */
31     error ApprovalCallerNotOwnerNorApproved();
32 
33     /**
34      * The token does not exist.
35      */
36     error ApprovalQueryForNonexistentToken();
37 
38     /**
39      * Cannot query the balance for the zero address.
40      */
41     error BalanceQueryForZeroAddress();
42 
43     /**
44      * Cannot mint to the zero address.
45      */
46     error MintToZeroAddress();
47 
48     /**
49      * The quantity of tokens minted must be more than zero.
50      */
51     error MintZeroQuantity();
52 
53     /**
54      * The token does not exist.
55      */
56     error OwnerQueryForNonexistentToken();
57 
58     /**
59      * The caller must own the token or be an approved operator.
60      */
61     error TransferCallerNotOwnerNorApproved();
62 
63     /**
64      * The token must be owned by `from`.
65      */
66     error TransferFromIncorrectOwner();
67 
68     /**
69      * Cannot safely transfer to a contract that does not implement the
70      * ERC721Receiver interface.
71      */
72     error TransferToNonERC721ReceiverImplementer();
73 
74     /**
75      * Cannot transfer to the zero address.
76      */
77     error TransferToZeroAddress();
78 
79     /**
80      * The token does not exist.
81      */
82     error URIQueryForNonexistentToken();
83 
84     /**
85      * The `quantity` minted with ERC2309 exceeds the safety limit.
86      */
87     error MintERC2309QuantityExceedsLimit();
88 
89     /**
90      * The `extraData` cannot be set on an unintialized ownership slot.
91      */
92     error OwnershipNotInitializedForExtraData();
93 
94     // =============================================================
95     //                            STRUCTS
96     // =============================================================
97 
98     struct TokenOwnership {
99         // The address of the owner.
100         address addr;
101         // Stores the start time of ownership with minimal overhead for tokenomics.
102         uint64 startTimestamp;
103         // Whether the token has been burned.
104         bool burned;
105         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
106         uint24 extraData;
107     }
108 
109     // =============================================================
110     //                         TOKEN COUNTERS
111     // =============================================================
112 
113     /**
114      * @dev Returns the total number of tokens in existence.
115      * Burned tokens will reduce the count.
116      * To get the total number of tokens minted, please see {_totalMinted}.
117      */
118     function totalSupply() external view returns (uint256);
119 
120     // =============================================================
121     //                            IERC165
122     // =============================================================
123 
124     /**
125      * @dev Returns true if this contract implements the interface defined by
126      * `interfaceId`. See the corresponding
127      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
128      * to learn more about how these ids are created.
129      *
130      * This function call must use less than 30000 gas.
131      */
132     function supportsInterface(bytes4 interfaceId) external view returns (bool);
133 
134     // =============================================================
135     //                            IERC721
136     // =============================================================
137 
138     /**
139      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
140      */
141     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
142 
143     /**
144      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
145      */
146     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
147 
148     /**
149      * @dev Emitted when `owner` enables or disables
150      * (`approved`) `operator` to manage all of its assets.
151      */
152     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
153 
154     /**
155      * @dev Returns the number of tokens in `owner`'s account.
156      */
157     function balanceOf(address owner) external view returns (uint256 balance);
158 
159     /**
160      * @dev Returns the owner of the `tokenId` token.
161      *
162      * Requirements:
163      *
164      * - `tokenId` must exist.
165      */
166     function ownerOf(uint256 tokenId) external view returns (address owner);
167 
168     /**
169      * @dev Safely transfers `tokenId` token from `from` to `to`,
170      * checking first that contract recipients are aware of the ERC721 protocol
171      * to prevent tokens from being forever locked.
172      *
173      * Requirements:
174      *
175      * - `from` cannot be the zero address.
176      * - `to` cannot be the zero address.
177      * - `tokenId` token must exist and be owned by `from`.
178      * - If the caller is not `from`, it must be have been allowed to move
179      * this token by either {approve} or {setApprovalForAll}.
180      * - If `to` refers to a smart contract, it must implement
181      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
182      *
183      * Emits a {Transfer} event.
184      */
185     function safeTransferFrom(
186         address from,
187         address to,
188         uint256 tokenId,
189         bytes calldata data
190     ) external payable;
191 
192     /**
193      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
194      */
195     function safeTransferFrom(
196         address from,
197         address to,
198         uint256 tokenId
199     ) external payable;
200 
201     /**
202      * @dev Transfers `tokenId` from `from` to `to`.
203      *
204      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
205      * whenever possible.
206      *
207      * Requirements:
208      *
209      * - `from` cannot be the zero address.
210      * - `to` cannot be the zero address.
211      * - `tokenId` token must be owned by `from`.
212      * - If the caller is not `from`, it must be approved to move this token
213      * by either {approve} or {setApprovalForAll}.
214      *
215      * Emits a {Transfer} event.
216      */
217     function transferFrom(
218         address from,
219         address to,
220         uint256 tokenId
221     ) external payable;
222 
223     /**
224      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
225      * The approval is cleared when the token is transferred.
226      *
227      * Only a single account can be approved at a time, so approving the
228      * zero address clears previous approvals.
229      *
230      * Requirements:
231      *
232      * - The caller must own the token or be an approved operator.
233      * - `tokenId` must exist.
234      *
235      * Emits an {Approval} event.
236      */
237     function approve(address to, uint256 tokenId) external payable;
238 
239     /**
240      * @dev Approve or remove `operator` as an operator for the caller.
241      * Operators can call {transferFrom} or {safeTransferFrom}
242      * for any token owned by the caller.
243      *
244      * Requirements:
245      *
246      * - The `operator` cannot be the caller.
247      *
248      * Emits an {ApprovalForAll} event.
249      */
250     function setApprovalForAll(address operator, bool _approved) external;
251 
252     /**
253      * @dev Returns the account approved for `tokenId` token.
254      *
255      * Requirements:
256      *
257      * - `tokenId` must exist.
258      */
259     function getApproved(uint256 tokenId) external view returns (address operator);
260 
261     /**
262      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
263      *
264      * See {setApprovalForAll}.
265      */
266     function isApprovedForAll(address owner, address operator) external view returns (bool);
267 
268     // =============================================================
269     //                        IERC721Metadata
270     // =============================================================
271 
272     /**
273      * @dev Returns the token collection name.
274      */
275     function name() external view returns (string memory);
276 
277     /**
278      * @dev Returns the token collection symbol.
279      */
280     function symbol() external view returns (string memory);
281 
282     /**
283      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
284      */
285     function tokenURI(uint256 tokenId) external view returns (string memory);
286 
287     // =============================================================
288     //                           IERC2309
289     // =============================================================
290 
291     /**
292      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
293      * (inclusive) is transferred from `from` to `to`, as defined in the
294      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
295      *
296      * See {_mintERC2309} for more details.
297      */
298     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
299 }
300 
301 
302 // File: erc721a/contracts/ERC721A.sol
303 
304 // ERC721A Contracts v4.2.3
305 // Creator: Chiru Labs
306 
307 pragma solidity ^0.8.4;
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
337     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
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
455         return 0;
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
725     function approve(address to, uint256 tokenId) public payable virtual override {
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
816         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
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
844     ) public payable virtual override {
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
910     ) public payable virtual override {
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
934     ) public payable virtual override {
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
1064             // The duplicated `log4` removes an extra check and reduces stack juggling.
1065             // The assembly, together with the surrounding Solidity code, have been
1066             // delicately arranged to nudge the compiler into producing optimized opcodes.
1067             assembly {
1068                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1069                 toMasked := and(to, _BITMASK_ADDRESS)
1070                 // Emit the `Transfer` event.
1071                 log4(
1072                     0, // Start of data (0, since no data).
1073                     0, // End of data (0, since no data).
1074                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1075                     0, // `address(0)`.
1076                     toMasked, // `to`.
1077                     startTokenId // `tokenId`.
1078                 )
1079 
1080                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1081                 // that overflows uint256 will make the loop run out of gas.
1082                 // The compiler will optimize the `iszero` away for performance.
1083                 for {
1084                     let tokenId := add(startTokenId, 1)
1085                 } iszero(eq(tokenId, end)) {
1086                     tokenId := add(tokenId, 1)
1087                 } {
1088                     // Emit the `Transfer` event. Similar to above.
1089                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1090                 }
1091             }
1092             if (toMasked == 0) revert MintToZeroAddress();
1093 
1094             _currentIndex = end;
1095         }
1096         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1097     }
1098 
1099     /**
1100      * @dev Mints `quantity` tokens and transfers them to `to`.
1101      *
1102      * This function is intended for efficient minting only during contract creation.
1103      *
1104      * It emits only one {ConsecutiveTransfer} as defined in
1105      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1106      * instead of a sequence of {Transfer} event(s).
1107      *
1108      * Calling this function outside of contract creation WILL make your contract
1109      * non-compliant with the ERC721 standard.
1110      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1111      * {ConsecutiveTransfer} event is only permissible during contract creation.
1112      *
1113      * Requirements:
1114      *
1115      * - `to` cannot be the zero address.
1116      * - `quantity` must be greater than 0.
1117      *
1118      * Emits a {ConsecutiveTransfer} event.
1119      */
1120     function _mintERC2309(address to, uint256 quantity) internal virtual {
1121         uint256 startTokenId = _currentIndex;
1122         if (to == address(0)) revert MintToZeroAddress();
1123         if (quantity == 0) revert MintZeroQuantity();
1124         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1125 
1126         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1127 
1128         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1129         unchecked {
1130             // Updates:
1131             // - `balance += quantity`.
1132             // - `numberMinted += quantity`.
1133             //
1134             // We can directly add to the `balance` and `numberMinted`.
1135             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1136 
1137             // Updates:
1138             // - `address` to the owner.
1139             // - `startTimestamp` to the timestamp of minting.
1140             // - `burned` to `false`.
1141             // - `nextInitialized` to `quantity == 1`.
1142             _packedOwnerships[startTokenId] = _packOwnershipData(
1143                 to,
1144                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1145             );
1146 
1147             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1148 
1149             _currentIndex = startTokenId + quantity;
1150         }
1151         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1152     }
1153 
1154     /**
1155      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1156      *
1157      * Requirements:
1158      *
1159      * - If `to` refers to a smart contract, it must implement
1160      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1161      * - `quantity` must be greater than 0.
1162      *
1163      * See {_mint}.
1164      *
1165      * Emits a {Transfer} event for each mint.
1166      */
1167     function _safeMint(
1168         address to,
1169         uint256 quantity,
1170         bytes memory _data
1171     ) internal virtual {
1172         _mint(to, quantity);
1173 
1174         unchecked {
1175             if (to.code.length != 0) {
1176                 uint256 end = _currentIndex;
1177                 uint256 index = end - quantity;
1178                 do {
1179                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1180                         revert TransferToNonERC721ReceiverImplementer();
1181                     }
1182                 } while (index < end);
1183                 // Reentrancy protection.
1184                 if (_currentIndex != end) revert();
1185             }
1186         }
1187     }
1188 
1189     /**
1190      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1191      */
1192     function _safeMint(address to, uint256 quantity) internal virtual {
1193         _safeMint(to, quantity, '');
1194     }
1195 
1196     // =============================================================
1197     //                        BURN OPERATIONS
1198     // =============================================================
1199 
1200     /**
1201      * @dev Equivalent to `_burn(tokenId, false)`.
1202      */
1203     function _burn(uint256 tokenId) internal virtual {
1204         _burn(tokenId, false);
1205     }
1206 
1207     /**
1208      * @dev Destroys `tokenId`.
1209      * The approval is cleared when the token is burned.
1210      *
1211      * Requirements:
1212      *
1213      * - `tokenId` must exist.
1214      *
1215      * Emits a {Transfer} event.
1216      */
1217     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1218         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1219 
1220         address from = address(uint160(prevOwnershipPacked));
1221 
1222         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1223 
1224         if (approvalCheck) {
1225             // The nested ifs save around 20+ gas over a compound boolean condition.
1226             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1227                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1228         }
1229 
1230         _beforeTokenTransfers(from, address(0), tokenId, 1);
1231 
1232         // Clear approvals from the previous owner.
1233         assembly {
1234             if approvedAddress {
1235                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1236                 sstore(approvedAddressSlot, 0)
1237             }
1238         }
1239 
1240         // Underflow of the sender's balance is impossible because we check for
1241         // ownership above and the recipient's balance can't realistically overflow.
1242         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1243         unchecked {
1244             // Updates:
1245             // - `balance -= 1`.
1246             // - `numberBurned += 1`.
1247             //
1248             // We can directly decrement the balance, and increment the number burned.
1249             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1250             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1251 
1252             // Updates:
1253             // - `address` to the last owner.
1254             // - `startTimestamp` to the timestamp of burning.
1255             // - `burned` to `true`.
1256             // - `nextInitialized` to `true`.
1257             _packedOwnerships[tokenId] = _packOwnershipData(
1258                 from,
1259                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1260             );
1261 
1262             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1263             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1264                 uint256 nextTokenId = tokenId + 1;
1265                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1266                 if (_packedOwnerships[nextTokenId] == 0) {
1267                     // If the next slot is within bounds.
1268                     if (nextTokenId != _currentIndex) {
1269                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1270                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1271                     }
1272                 }
1273             }
1274         }
1275 
1276         emit Transfer(from, address(0), tokenId);
1277         _afterTokenTransfers(from, address(0), tokenId, 1);
1278 
1279         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1280         unchecked {
1281             _burnCounter++;
1282         }
1283     }
1284 
1285     // =============================================================
1286     //                     EXTRA DATA OPERATIONS
1287     // =============================================================
1288 
1289     /**
1290      * @dev Directly sets the extra data for the ownership data `index`.
1291      */
1292     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1293         uint256 packed = _packedOwnerships[index];
1294         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1295         uint256 extraDataCasted;
1296         // Cast `extraData` with assembly to avoid redundant masking.
1297         assembly {
1298             extraDataCasted := extraData
1299         }
1300         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1301         _packedOwnerships[index] = packed;
1302     }
1303 
1304     /**
1305      * @dev Called during each token transfer to set the 24bit `extraData` field.
1306      * Intended to be overridden by the cosumer contract.
1307      *
1308      * `previousExtraData` - the value of `extraData` before transfer.
1309      *
1310      * Calling conditions:
1311      *
1312      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1313      * transferred to `to`.
1314      * - When `from` is zero, `tokenId` will be minted for `to`.
1315      * - When `to` is zero, `tokenId` will be burned by `from`.
1316      * - `from` and `to` are never both zero.
1317      */
1318     function _extraData(
1319         address from,
1320         address to,
1321         uint24 previousExtraData
1322     ) internal view virtual returns (uint24) {}
1323 
1324     /**
1325      * @dev Returns the next extra data for the packed ownership data.
1326      * The returned result is shifted into position.
1327      */
1328     function _nextExtraData(
1329         address from,
1330         address to,
1331         uint256 prevOwnershipPacked
1332     ) private view returns (uint256) {
1333         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1334         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1335     }
1336 
1337     // =============================================================
1338     //                       OTHER OPERATIONS
1339     // =============================================================
1340 
1341     /**
1342      * @dev Returns the message sender (defaults to `msg.sender`).
1343      *
1344      * If you are writing GSN compatible contracts, you need to override this function.
1345      */
1346     function _msgSenderERC721A() internal view virtual returns (address) {
1347         return msg.sender;
1348     }
1349 
1350     /**
1351      * @dev Converts a uint256 to its ASCII string decimal representation.
1352      */
1353     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1354         assembly {
1355             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1356             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1357             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1358             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1359             let m := add(mload(0x40), 0xa0)
1360             // Update the free memory pointer to allocate.
1361             mstore(0x40, m)
1362             // Assign the `str` to the end.
1363             str := sub(m, 0x20)
1364             // Zeroize the slot after the string.
1365             mstore(str, 0)
1366 
1367             // Cache the end of the memory to calculate the length later.
1368             let end := str
1369 
1370             // We write the string from rightmost digit to leftmost digit.
1371             // The following is essentially a do-while loop that also handles the zero case.
1372             // prettier-ignore
1373             for { let temp := value } 1 {} {
1374                 str := sub(str, 1)
1375                 // Write the character to the pointer.
1376                 // The ASCII index of the '0' character is 48.
1377                 mstore8(str, add(48, mod(temp, 10)))
1378                 // Keep dividing `temp` until zero.
1379                 temp := div(temp, 10)
1380                 // prettier-ignore
1381                 if iszero(temp) { break }
1382             }
1383 
1384             let length := sub(end, str)
1385             // Move the pointer 32 bytes leftwards to make room for the length.
1386             str := sub(str, 0x20)
1387             // Store the length.
1388             mstore(str, length)
1389         }
1390     }
1391 }
1392 
1393 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
1394 
1395 
1396 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
1397 
1398 pragma solidity ^0.8.0;
1399 
1400 /**
1401  * @dev Contract module that helps prevent reentrant calls to a function.
1402  *
1403  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1404  * available, which can be applied to functions to make sure there are no nested
1405  * (reentrant) calls to them.
1406  *
1407  * Note that because there is a single `nonReentrant` guard, functions marked as
1408  * `nonReentrant` may not call one another. This can be worked around by making
1409  * those functions `private`, and then adding `external` `nonReentrant` entry
1410  * points to them.
1411  *
1412  * TIP: If you would like to learn more about reentrancy and alternative ways
1413  * to protect against it, check out our blog post
1414  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1415  */
1416 abstract contract ReentrancyGuard {
1417     // Booleans are more expensive than uint256 or any type that takes up a full
1418     // word because each write operation emits an extra SLOAD to first read the
1419     // slot's contents, replace the bits taken up by the boolean, and then write
1420     // back. This is the compiler's defense against contract upgrades and
1421     // pointer aliasing, and it cannot be disabled.
1422 
1423     // The values being non-zero value makes deployment a bit more expensive,
1424     // but in exchange the refund on every call to nonReentrant will be lower in
1425     // amount. Since refunds are capped to a percentage of the total
1426     // transaction's gas, it is best to keep them low in cases like this one, to
1427     // increase the likelihood of the full refund coming into effect.
1428     uint256 private constant _NOT_ENTERED = 1;
1429     uint256 private constant _ENTERED = 2;
1430 
1431     uint256 private _status;
1432 
1433     constructor() {
1434         _status = _NOT_ENTERED;
1435     }
1436 
1437     /**
1438      * @dev Prevents a contract from calling itself, directly or indirectly.
1439      * Calling a `nonReentrant` function from another `nonReentrant`
1440      * function is not supported. It is possible to prevent this from happening
1441      * by making the `nonReentrant` function external, and making it call a
1442      * `private` function that does the actual work.
1443      */
1444     modifier nonReentrant() {
1445         _nonReentrantBefore();
1446         _;
1447         _nonReentrantAfter();
1448     }
1449 
1450     function _nonReentrantBefore() private {
1451         // On the first call to nonReentrant, _status will be _NOT_ENTERED
1452         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1453 
1454         // Any calls to nonReentrant after this point will fail
1455         _status = _ENTERED;
1456     }
1457 
1458     function _nonReentrantAfter() private {
1459         // By storing the original value once again, a refund is triggered (see
1460         // https://eips.ethereum.org/EIPS/eip-2200)
1461         _status = _NOT_ENTERED;
1462     }
1463 }
1464 
1465 // File: @openzeppelin/contracts/utils/Context.sol
1466 
1467 
1468 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1469 
1470 pragma solidity ^0.8.0;
1471 
1472 /**
1473  * @dev Provides information about the current execution context, including the
1474  * sender of the transaction and its data. While these are generally available
1475  * via msg.sender and msg.data, they should not be accessed in such a direct
1476  * manner, since when dealing with meta-transactions the account sending and
1477  * paying for execution may not be the actual sender (as far as an application
1478  * is concerned).
1479  *
1480  * This contract is only required for intermediate, library-like contracts.
1481  */
1482 abstract contract Context {
1483     function _msgSender() internal view virtual returns (address) {
1484         return msg.sender;
1485     }
1486 
1487     function _msgData() internal view virtual returns (bytes calldata) {
1488         return msg.data;
1489     }
1490 }
1491 
1492 // File: @openzeppelin/contracts/access/Ownable.sol
1493 
1494 
1495 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1496 
1497 pragma solidity ^0.8.0;
1498 
1499 
1500 /**
1501  * @dev Contract module which provides a basic access control mechanism, where
1502  * there is an account (an owner) that can be granted exclusive access to
1503  * specific functions.
1504  *
1505  * By default, the owner account will be the one that deploys the contract. This
1506  * can later be changed with {transferOwnership}.
1507  *
1508  * This module is used through inheritance. It will make available the modifier
1509  * `onlyOwner`, which can be applied to your functions to restrict their use to
1510  * the owner.
1511  */
1512 abstract contract Ownable is Context {
1513     address private _owner;
1514 
1515     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1516 
1517     /**
1518      * @dev Initializes the contract setting the deployer as the initial owner.
1519      */
1520     constructor() {
1521         _transferOwnership(_msgSender());
1522     }
1523 
1524     /**
1525      * @dev Throws if called by any account other than the owner.
1526      */
1527     modifier onlyOwner() {
1528         _checkOwner();
1529         _;
1530     }
1531 
1532     /**
1533      * @dev Returns the address of the current owner.
1534      */
1535     function owner() public view virtual returns (address) {
1536         return _owner;
1537     }
1538 
1539     /**
1540      * @dev Throws if the sender is not the owner.
1541      */
1542     function _checkOwner() internal view virtual {
1543         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1544     }
1545 
1546     /**
1547      * @dev Leaves the contract without owner. It will not be possible to call
1548      * `onlyOwner` functions anymore. Can only be called by the current owner.
1549      *
1550      * NOTE: Renouncing ownership will leave the contract without an owner,
1551      * thereby removing any functionality that is only available to the owner.
1552      */
1553     function renounceOwnership() public virtual onlyOwner {
1554         _transferOwnership(address(0));
1555     }
1556 
1557     /**
1558      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1559      * Can only be called by the current owner.
1560      */
1561     function transferOwnership(address newOwner) public virtual onlyOwner {
1562         require(newOwner != address(0), "Ownable: new owner is the zero address");
1563         _transferOwnership(newOwner);
1564     }
1565 
1566     /**
1567      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1568      * Internal function without access restriction.
1569      */
1570     function _transferOwnership(address newOwner) internal virtual {
1571         address oldOwner = _owner;
1572         _owner = newOwner;
1573         emit OwnershipTransferred(oldOwner, newOwner);
1574     }
1575 }
1576 
1577 pragma solidity ^0.8.15;
1578 
1579 contract Senshi is ERC721A, Ownable {
1580 
1581     string public baseURI = "ipfs://QmWHmthGenmUig2Q1SZimFSNxZ1Z3wpL47k9gZxtBHvPkp/";
1582     uint256 public maxSupply = 555;
1583     uint256 public maxPerWallet = 1;
1584     bool public saleActive = false;
1585 
1586     mapping(address => uint) public addressToMinted;
1587 
1588     modifier callerIsUser() {
1589         require(tx.origin == msg.sender, "The caller is another contract");
1590         _;
1591     }
1592 
1593     constructor () ERC721A("Senshi", "SENSHI") {
1594     }
1595 
1596     function _startTokenId() internal view virtual override returns (uint256) {
1597         return 1;
1598     }
1599 
1600     // Mint
1601     function mintToy(uint256 mintAmount) public callerIsUser {
1602         require(saleActive, "Sale Is Not Active");
1603         require(addressToMinted[msg.sender] + mintAmount <= maxPerWallet, "Already Minted");
1604         require(totalSupply() + mintAmount <= maxSupply, "Sold Out");
1605         
1606         addressToMinted[msg.sender] += mintAmount;
1607 
1608         _safeMint(msg.sender, mintAmount);
1609     }
1610 
1611     // Team
1612     function teamToy(uint256 mintAmount) public onlyOwner {
1613         require(totalSupply() + mintAmount <= maxSupply, "Sold Out");
1614 
1615         _safeMint(msg.sender, mintAmount);
1616     }
1617 
1618     /////////////////////////////
1619     // CONTRACT MANAGEMENT 
1620     /////////////////////////////
1621 
1622     function toggleSale() external onlyOwner {
1623         saleActive = !saleActive;
1624     }
1625 
1626     function _baseURI() internal view virtual override returns (string memory) {
1627         return baseURI;
1628     }
1629 
1630     function setBaseURI(string memory baseURI_) external onlyOwner {
1631         baseURI = baseURI_;
1632     } 
1633 
1634     function withdraw() public onlyOwner {
1635 		payable(msg.sender).transfer(address(this).balance);
1636 	}
1637     
1638 }