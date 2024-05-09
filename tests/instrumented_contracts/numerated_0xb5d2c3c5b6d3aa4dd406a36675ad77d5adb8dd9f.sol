1 // Bamboo Meta.
2 // Inspire life with genius minds. Benefit from creativity.
3 // SPDX-License-Identifier: MIT
4 // ERC721A Contracts v4.2.3
5 // Thanks: Chiru Labs
6 // China Invest.
7 
8 pragma solidity ^0.8.4;
9 
10 /**
11  * @dev Interface of ERC721A.
12  */
13 interface IERC721A {
14     /**
15      * The caller must own the token or be an approved operator.
16      */
17     error ApprovalCallerNotOwnerNorApproved();
18 
19     /**
20      * The token does not exist.
21      */
22     error ApprovalQueryForNonexistentToken();
23 
24     /**
25      * Cannot query the balance for the zero address.
26      */
27     error BalanceQueryForZeroAddress();
28 
29     /**
30      * Cannot mint to the zero address.
31      */
32     error MintToZeroAddress();
33 
34     /**
35      * The quantity of tokens minted must be more than zero.
36      */
37     error MintZeroQuantity();
38 
39     /**
40      * The token does not exist.
41      */
42     error OwnerQueryForNonexistentToken();
43 
44     /**
45      * The caller must own the token or be an approved operator.
46      */
47     error TransferCallerNotOwnerNorApproved();
48 
49     /**
50      * The token must be owned by `from`.
51      */
52     error TransferFromIncorrectOwner();
53 
54     /**
55      * Cannot safely transfer to a contract that does not implement the
56      * ERC721Receiver interface.
57      */
58     error TransferToNonERC721ReceiverImplementer();
59 
60     /**
61      * Cannot transfer to the zero address.
62      */
63     error TransferToZeroAddress();
64 
65     /**
66      * The token does not exist.
67      */
68     error URIQueryForNonexistentToken();
69 
70     /**
71      * The `quantity` minted with ERC2309 exceeds the safety limit.
72      */
73     error MintERC2309QuantityExceedsLimit();
74 
75     /**
76      * The `extraData` cannot be set on an unintialized ownership slot.
77      */
78     error OwnershipNotInitializedForExtraData();
79 
80     // =============================================================
81     //                            STRUCTS
82     // =============================================================
83 
84     struct TokenOwnership {
85         // The address of the owner.
86         address addr;
87         // Stores the start time of ownership with minimal overhead for tokenomics.
88         uint64 startTimestamp;
89         // Whether the token has been burned.
90         bool burned;
91         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
92         uint24 extraData;
93     }
94 
95     // =============================================================
96     //                         TOKEN COUNTERS
97     // =============================================================
98 
99     /**
100      * @dev Returns the total number of tokens in existence.
101      * Burned tokens will reduce the count.
102      * To get the total number of tokens minted, please see {_totalMinted}.
103      */
104     function totalSupply() external view returns (uint256);
105 
106     // =============================================================
107     //                            IERC165
108     // =============================================================
109 
110     /**
111      * @dev Returns true if this contract implements the interface defined by
112      * `interfaceId`. See the corresponding
113      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
114      * to learn more about how these ids are created.
115      *
116      * This function call must use less than 30000 gas.
117      */
118     function supportsInterface(bytes4 interfaceId) external view returns (bool);
119 
120     // =============================================================
121     //                            IERC721
122     // =============================================================
123 
124     /**
125      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
126      */
127     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
128 
129     /**
130      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
131      */
132     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
133 
134     /**
135      * @dev Emitted when `owner` enables or disables
136      * (`approved`) `operator` to manage all of its assets.
137      */
138     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
139 
140     /**
141      * @dev Returns the number of tokens in `owner`'s account.
142      */
143     function balanceOf(address owner) external view returns (uint256 balance);
144 
145     /**
146      * @dev Returns the owner of the `tokenId` token.
147      *
148      * Requirements:
149      *
150      * - `tokenId` must exist.
151      */
152     function ownerOf(uint256 tokenId) external view returns (address owner);
153 
154     /**
155      * @dev Safely transfers `tokenId` token from `from` to `to`,
156      * checking first that contract recipients are aware of the ERC721 protocol
157      * to prevent tokens from being forever locked.
158      *
159      * Requirements:
160      *
161      * - `from` cannot be the zero address.
162      * - `to` cannot be the zero address.
163      * - `tokenId` token must exist and be owned by `from`.
164      * - If the caller is not `from`, it must be have been allowed to move
165      * this token by either {approve} or {setApprovalForAll}.
166      * - If `to` refers to a smart contract, it must implement
167      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
168      *
169      * Emits a {Transfer} event.
170      */
171     function safeTransferFrom(
172         address from,
173         address to,
174         uint256 tokenId,
175         bytes calldata data
176     ) external payable;
177 
178     /**
179      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
180      */
181     function safeTransferFrom(
182         address from,
183         address to,
184         uint256 tokenId
185     ) external payable;
186 
187     /**
188      * @dev Transfers `tokenId` from `from` to `to`.
189      *
190      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
191      * whenever possible.
192      *
193      * Requirements:
194      *
195      * - `from` cannot be the zero address.
196      * - `to` cannot be the zero address.
197      * - `tokenId` token must be owned by `from`.
198      * - If the caller is not `from`, it must be approved to move this token
199      * by either {approve} or {setApprovalForAll}.
200      *
201      * Emits a {Transfer} event.
202      */
203     function transferFrom(
204         address from,
205         address to,
206         uint256 tokenId
207     ) external payable;
208 
209     /**
210      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
211      * The approval is cleared when the token is transferred.
212      *
213      * Only a single account can be approved at a time, so approving the
214      * zero address clears previous approvals.
215      *
216      * Requirements:
217      *
218      * - The caller must own the token or be an approved operator.
219      * - `tokenId` must exist.
220      *
221      * Emits an {Approval} event.
222      */
223     function approve(address to, uint256 tokenId) external payable;
224 
225     /**
226      * @dev Approve or remove `operator` as an operator for the caller.
227      * Operators can call {transferFrom} or {safeTransferFrom}
228      * for any token owned by the caller.
229      *
230      * Requirements:
231      *
232      * - The `operator` cannot be the caller.
233      *
234      * Emits an {ApprovalForAll} event.
235      */
236     function setApprovalForAll(address operator, bool _approved) external;
237 
238     /**
239      * @dev Returns the account approved for `tokenId` token.
240      *
241      * Requirements:
242      *
243      * - `tokenId` must exist.
244      */
245     function getApproved(uint256 tokenId) external view returns (address operator);
246 
247     /**
248      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
249      *
250      * See {setApprovalForAll}.
251      */
252     function isApprovedForAll(address owner, address operator) external view returns (bool);
253 
254     // =============================================================
255     //                        IERC721Metadata
256     // =============================================================
257 
258     /**
259      * @dev Returns the token collection name.
260      */
261     function name() external view returns (string memory);
262 
263     /**
264      * @dev Returns the token collection symbol.
265      */
266     function symbol() external view returns (string memory);
267 
268     /**
269      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
270      */
271     function tokenURI(uint256 tokenId) external view returns (string memory);
272 }
273 
274 abstract contract Context {
275     function _msgSender() internal view virtual returns (address) {
276         return msg.sender;
277     }
278 
279     function _msgData() internal view virtual returns (bytes calldata) {
280         return msg.data;
281     }
282 }
283 
284 abstract contract Ownable is Context {
285     address private _owner;
286 
287     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
288 
289     /**
290      * @dev Initializes the contract setting the deployer as the initial owner.
291      */
292     constructor() {
293         _transferOwnership(_msgSender());
294     }
295 
296     /**
297      * @dev Throws if called by any account other than the owner.
298      */
299     modifier onlyOwner() {
300         _checkOwner();
301         _;
302     }
303 
304     /**
305      * @dev Returns the address of the current owner.
306      */
307     function owner() public view virtual returns (address) {
308         return _owner;
309     }
310 
311     /**
312      * @dev Throws if the sender is not the owner.
313      */
314     function _checkOwner() internal view virtual {
315         require(owner() == _msgSender(), "Ownable: caller is not the owner");
316     }
317 
318     /**
319      * @dev Transfers ownership of the contract to a new account (`newOwner`).
320      * Can only be called by the current owner.
321      */
322     function transferOwnership(address newOwner) public virtual onlyOwner {
323         require(newOwner != address(0), "Ownable: new owner is the zero address");
324         _transferOwnership(newOwner);
325     }
326 
327     /**
328      * @dev Transfers ownership of the contract to a new account (`newOwner`).
329      * Internal function without access restriction.
330      */
331     function _transferOwnership(address newOwner) internal virtual {
332         address oldOwner = _owner;
333         _owner = newOwner;
334         emit OwnershipTransferred(oldOwner, newOwner);
335     }
336 }
337 
338 /**
339  * @dev Interface of ERC721 token receiver.
340  */
341 interface ERC721A__IERC721Receiver {
342     function onERC721Received(
343         address operator,
344         address from,
345         uint256 tokenId,
346         bytes calldata data
347     ) external returns (bytes4);
348 }
349 
350 
351 /**
352  * @title ERC721A
353  *
354  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
355  * Non-Fungible Token Standard, including the Metadata extension.
356  * Optimized for lower gas during batch mints.
357  *
358  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
359  * starting from `_startTokenId()`.
360  *
361  * Assumptions:
362  *
363  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
364  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
365  */
366 contract ERC721A is IERC721A {
367     // Bypass for a `--via-ir` bug.
368     struct TokenApprovalRef {
369         address value;
370     }
371 
372     // =============================================================
373     //                           CONSTANTS
374     // =============================================================
375 
376     // Mask of an entry in packed address data.
377     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
378 
379     // The bit position of `numberMinted` in packed address data.
380     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
381 
382     // The bit position of `numberBurned` in packed address data.
383     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
384 
385     // The bit position of `aux` in packed address data.
386     uint256 private constant _BITPOS_AUX = 192;
387 
388     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
389     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
390 
391     // The bit position of `startTimestamp` in packed ownership.
392     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
393 
394     // The bit mask of the `burned` bit in packed ownership.
395     uint256 private constant _BITMASK_BURNED = 1 << 224;
396 
397     // The bit position of the `nextInitialized` bit in packed ownership.
398     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
399 
400     // The bit mask of the `nextInitialized` bit in packed ownership.
401     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
402 
403     // The bit position of `extraData` in packed ownership.
404     uint256 private constant _BITPOS_EXTRA_DATA = 232;
405 
406     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
407     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
408 
409     // The mask of the lower 160 bits for addresses.
410     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
411 
412     // The `Transfer` event signature is given by:
413     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
414     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
415     0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
416 
417     // =============================================================
418     //                            STORAGE
419     // =============================================================
420 
421     // The next token ID to be minted.
422     uint256 private _currentIndex;
423 
424     // The number of tokens burned.
425     uint256 private _burnCounter;
426 
427     // Token name
428     string private _name;
429 
430     // Token symbol
431     string private _symbol;
432 
433     // Mapping from token ID to ownership details
434     // An empty struct value does not necessarily mean the token is unowned.
435     // See {_packedOwnershipOf} implementation for details.
436     //
437     // Bits Layout:
438     // - [0..159]   `addr`
439     // - [160..223] `startTimestamp`
440     // - [224]      `burned`
441     // - [225]      `nextInitialized`
442     // - [232..255] `extraData`
443     mapping(uint256 => uint256) private _packedOwnerships;
444 
445     // Mapping owner address to address data.
446     //
447     // Bits Layout:
448     // - [0..63]    `balance`
449     // - [64..127]  `numberMinted`
450     // - [128..191] `numberBurned`
451     // - [192..255] `aux`
452     mapping(address => uint256) private _packedAddressData;
453 
454     // Mapping from token ID to approved address.
455     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
456 
457     // Mapping from owner to operator approvals
458     mapping(address => mapping(address => bool)) private _operatorApprovals;
459 
460     // =============================================================
461     //                          CONSTRUCTOR
462     // =============================================================
463 
464     constructor(string memory name_, string memory symbol_) {
465         _name = name_;
466         _symbol = symbol_;
467         _currentIndex = _startTokenId();
468     }
469 
470     // =============================================================
471     //                   TOKEN COUNTING OPERATIONS
472     // =============================================================
473 
474     /**
475      * @dev Returns the starting token ID.
476      * To change the starting token ID, please override this function.
477      */
478     function _startTokenId() internal view virtual returns (uint256) {
479         return 0;
480     }
481 
482     /**
483      * @dev Returns the next token ID to be minted.
484      */
485     function _nextTokenId() internal view virtual returns (uint256) {
486         return _currentIndex;
487     }
488 
489     /**
490      * @dev Returns the total number of tokens in existence.
491      * Burned tokens will reduce the count.
492      * To get the total number of tokens minted, please see {_totalMinted}.
493      */
494     function totalSupply() public view virtual override returns (uint256) {
495         // Counter underflow is impossible as _burnCounter cannot be incremented
496         // more than `_currentIndex - _startTokenId()` times.
497     unchecked {
498         return _currentIndex - _burnCounter - _startTokenId();
499     }
500     }
501 
502     /**
503      * @dev Returns the total amount of tokens minted in the contract.
504      */
505     function _totalMinted() internal view virtual returns (uint256) {
506         // Counter underflow is impossible as `_currentIndex` does not decrement,
507         // and it is initialized to `_startTokenId()`.
508     unchecked {
509         return _currentIndex - _startTokenId();
510     }
511     }
512 
513     /**
514      * @dev Returns the total number of tokens burned.
515      */
516     function _totalBurned() internal view virtual returns (uint256) {
517         return _burnCounter;
518     }
519 
520     // =============================================================
521     //                    ADDRESS DATA OPERATIONS
522     // =============================================================
523 
524     /**
525      * @dev Returns the number of tokens in `owner`'s account.
526      */
527     function balanceOf(address owner) public view virtual override returns (uint256) {
528         if (owner == address(0)) _revert(BalanceQueryForZeroAddress.selector);
529         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
530     }
531 
532     /**
533      * Returns the number of tokens minted by `owner`.
534      */
535     function _numberMinted(address owner) internal view returns (uint256) {
536         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
537     }
538 
539     /**
540      * Returns the number of tokens burned by or on behalf of `owner`.
541      */
542     function _numberBurned(address owner) internal view returns (uint256) {
543         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
544     }
545 
546     /**
547      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
548      */
549     function _getAux(address owner) internal view returns (uint64) {
550         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
551     }
552 
553     /**
554      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
555      * If there are multiple variables, please pack them into a uint64.
556      */
557     function _setAux(address owner, uint64 aux) internal virtual {
558         uint256 packed = _packedAddressData[owner];
559         uint256 auxCasted;
560         // Cast `aux` with assembly to avoid redundant masking.
561         assembly {
562             auxCasted := aux
563         }
564         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
565         _packedAddressData[owner] = packed;
566     }
567 
568     // =============================================================
569     //                            IERC165
570     // =============================================================
571 
572     /**
573      * @dev Returns true if this contract implements the interface defined by
574      * `interfaceId`. See the corresponding
575      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
576      * to learn more about how these ids are created.
577      *
578      * This function call must use less than 30000 gas.
579      */
580     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
581         // The interface IDs are constants representing the first 4 bytes
582         // of the XOR of all function selectors in the interface.
583         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
584         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
585         return
586         interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
587         interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
588         interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
589     }
590 
591     // =============================================================
592     //                        IERC721Metadata
593     // =============================================================
594 
595     /**
596      * @dev Returns the token collection name.
597      */
598     function name() public view virtual override returns (string memory) {
599         return _name;
600     }
601 
602     /**
603      * @dev Returns the token collection symbol.
604      */
605     function symbol() public view virtual override returns (string memory) {
606         return _symbol;
607     }
608 
609     /**
610      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
611      */
612     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
613         if (!_exists(tokenId)) _revert(URIQueryForNonexistentToken.selector);
614 
615         string memory baseURI = _baseURI();
616         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
617     }
618 
619     /**
620      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
621      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
622      * by default, it can be overridden in child contracts.
623      */
624     function _baseURI() internal view virtual returns (string memory) {
625         return '';
626     }
627 
628     // =============================================================
629     //                     OWNERSHIPS OPERATIONS
630     // =============================================================
631 
632     /**
633      * @dev Returns the owner of the `tokenId` token.
634      *
635      * Requirements:
636      *
637      * - `tokenId` must exist.
638      */
639     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
640         return address(uint160(_packedOwnershipOf(tokenId)));
641     }
642 
643     /**
644      * @dev Gas spent here starts off proportional to the maximum mint batch size.
645      * It gradually moves to O(1) as tokens get transferred around over time.
646      */
647     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
648         return _unpackedOwnership(_packedOwnershipOf(tokenId));
649     }
650 
651     /**
652      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
653      */
654     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
655         return _unpackedOwnership(_packedOwnerships[index]);
656     }
657 
658     /**
659      * @dev Returns whether the ownership slot at `index` is initialized.
660      * An uninitialized slot does not necessarily mean that the slot has no owner.
661      */
662     function _ownershipIsInitialized(uint256 index) internal view virtual returns (bool) {
663         return _packedOwnerships[index] != 0;
664     }
665 
666     /**
667      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
668      */
669     function _initializeOwnershipAt(uint256 index) internal virtual {
670         if (_packedOwnerships[index] == 0) {
671             _packedOwnerships[index] = _packedOwnershipOf(index);
672         }
673     }
674 
675     /**
676      * Returns the packed ownership data of `tokenId`.
677      */
678     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256 packed) {
679         if (_startTokenId() <= tokenId) {
680             packed = _packedOwnerships[tokenId];
681             // If the data at the starting slot does not exist, start the scan.
682             if (packed == 0) {
683                 if (tokenId >= _currentIndex) _revert(OwnerQueryForNonexistentToken.selector);
684                 // Invariant:
685                 // There will always be an initialized ownership slot
686                 // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
687                 // before an unintialized ownership slot
688                 // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
689                 // Hence, `tokenId` will not underflow.
690                 //
691                 // We can directly compare the packed value.
692                 // If the address is zero, packed will be zero.
693                 for (;;) {
694                 unchecked {
695                     packed = _packedOwnerships[--tokenId];
696                 }
697                     if (packed == 0) continue;
698                     if (packed & _BITMASK_BURNED == 0) return packed;
699                     // Otherwise, the token is burned, and we must revert.
700                     // This handles the case of batch burned tokens, where only the burned bit
701                     // of the starting slot is set, and remaining slots are left uninitialized.
702                     _revert(OwnerQueryForNonexistentToken.selector);
703                 }
704             }
705             // Otherwise, the data exists and we can skip the scan.
706             // This is possible because we have already achieved the target condition.
707             // This saves 2143 gas on transfers of initialized tokens.
708             // If the token is not burned, return `packed`. Otherwise, revert.
709             if (packed & _BITMASK_BURNED == 0) return packed;
710         }
711         _revert(OwnerQueryForNonexistentToken.selector);
712     }
713 
714     /**
715      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
716      */
717     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
718         ownership.addr = address(uint160(packed));
719         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
720         ownership.burned = packed & _BITMASK_BURNED != 0;
721         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
722     }
723 
724     /**
725      * @dev Packs ownership data into a single uint256.
726      */
727     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
728         assembly {
729         // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
730             owner := and(owner, _BITMASK_ADDRESS)
731         // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
732             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
733         }
734     }
735 
736     /**
737      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
738      */
739     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
740         // For branchless setting of the `nextInitialized` flag.
741         assembly {
742         // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
743             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
744         }
745     }
746 
747     // =============================================================
748     //                      APPROVAL OPERATIONS
749     // =============================================================
750 
751     /**
752      * @dev Gives permission to `to` to transfer `tokenId` token to another account. See {ERC721A-_approve}.
753      *
754      * Requirements:
755      *
756      * - The caller must own the token or be an approved operator.
757      */
758     function approve(address to, uint256 tokenId) public payable virtual override {
759         _approve(to, tokenId, true);
760     }
761 
762     /**
763      * @dev Returns the account approved for `tokenId` token.
764      *
765      * Requirements:
766      *
767      * - `tokenId` must exist.
768      */
769     function getApproved(uint256 tokenId) public view virtual override returns (address) {
770         if (!_exists(tokenId)) _revert(ApprovalQueryForNonexistentToken.selector);
771 
772         return _tokenApprovals[tokenId].value;
773     }
774 
775     /**
776      * @dev Approve or remove `operator` as an operator for the caller.
777      * Operators can call {transferFrom} or {safeTransferFrom}
778      * for any token owned by the caller.
779      *
780      * Requirements:
781      *
782      * - The `operator` cannot be the caller.
783      *
784      * Emits an {ApprovalForAll} event.
785      */
786     function setApprovalForAll(address operator, bool approved) public virtual override {
787         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
788         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
789     }
790 
791     /**
792      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
793      *
794      * See {setApprovalForAll}.
795      */
796     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
797         return _operatorApprovals[owner][operator];
798     }
799 
800     /**
801      * @dev Returns whether `tokenId` exists.
802      *
803      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
804      *
805      * Tokens start existing when they are minted. See {_mint}.
806      */
807     function _exists(uint256 tokenId) internal view virtual returns (bool result) {
808         if (_startTokenId() <= tokenId) {
809             if (tokenId < _currentIndex) {
810                 uint256 packed;
811                 while ((packed = _packedOwnerships[tokenId]) == 0) --tokenId;
812                 result = packed & _BITMASK_BURNED == 0;
813             }
814         }
815     }
816 
817     /**
818      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
819      */
820     function _isSenderApprovedOrOwner(
821         address approvedAddress,
822         address owner,
823         address msgSender
824     ) private pure returns (bool result) {
825         assembly {
826         // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
827             owner := and(owner, _BITMASK_ADDRESS)
828         // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
829             msgSender := and(msgSender, _BITMASK_ADDRESS)
830         // `msgSender == owner || msgSender == approvedAddress`.
831             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
832         }
833     }
834 
835     /**
836      * @dev Returns the storage slot and value for the approved address of `tokenId`.
837      */
838     function _getApprovedSlotAndAddress(uint256 tokenId)
839     private
840     view
841     returns (uint256 approvedAddressSlot, address approvedAddress)
842     {
843         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
844         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
845         assembly {
846             approvedAddressSlot := tokenApproval.slot
847             approvedAddress := sload(approvedAddressSlot)
848         }
849     }
850 
851     // =============================================================
852     //                      TRANSFER OPERATIONS
853     // =============================================================
854 
855     /**
856      * @dev Transfers `tokenId` from `from` to `to`.
857      *
858      * Requirements:
859      *
860      * - `from` cannot be the zero address.
861      * - `to` cannot be the zero address.
862      * - `tokenId` token must be owned by `from`.
863      * - If the caller is not `from`, it must be approved to move this token
864      * by either {approve} or {setApprovalForAll}.
865      *
866      * Emits a {Transfer} event.
867      */
868     function transferFrom(
869         address from,
870         address to,
871         uint256 tokenId
872     ) public payable virtual override {
873         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
874 
875         // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
876         from = address(uint160(uint256(uint160(from)) & _BITMASK_ADDRESS));
877 
878         if (address(uint160(prevOwnershipPacked)) != from) _revert(TransferFromIncorrectOwner.selector);
879 
880         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
881 
882         // The nested ifs save around 20+ gas over a compound boolean condition.
883         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
884             if (!isApprovedForAll(from, _msgSenderERC721A())) _revert(TransferCallerNotOwnerNorApproved.selector);
885 
886         _beforeTokenTransfers(from, to, tokenId, 1);
887 
888         // Clear approvals from the previous owner.
889         assembly {
890             if approvedAddress {
891             // This is equivalent to `delete _tokenApprovals[tokenId]`.
892                 sstore(approvedAddressSlot, 0)
893             }
894         }
895 
896         // Underflow of the sender's balance is impossible because we check for
897         // ownership above and the recipient's balance can't realistically overflow.
898         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
899     unchecked {
900         // We can directly increment and decrement the balances.
901         --_packedAddressData[from]; // Updates: `balance -= 1`.
902         ++_packedAddressData[to]; // Updates: `balance += 1`.
903 
904         // Updates:
905         // - `address` to the next owner.
906         // - `startTimestamp` to the timestamp of transfering.
907         // - `burned` to `false`.
908         // - `nextInitialized` to `true`.
909         _packedOwnerships[tokenId] = _packOwnershipData(
910             to,
911             _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
912         );
913 
914         // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
915         if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
916             uint256 nextTokenId = tokenId + 1;
917             // If the next slot's address is zero and not burned (i.e. packed value is zero).
918             if (_packedOwnerships[nextTokenId] == 0) {
919                 // If the next slot is within bounds.
920                 if (nextTokenId != _currentIndex) {
921                     // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
922                     _packedOwnerships[nextTokenId] = prevOwnershipPacked;
923                 }
924             }
925         }
926     }
927 
928         // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
929         uint256 toMasked = uint256(uint160(to)) & _BITMASK_ADDRESS;
930         assembly {
931         // Emit the `Transfer` event.
932             log4(
933             0, // Start of data (0, since no data).
934             0, // End of data (0, since no data).
935             _TRANSFER_EVENT_SIGNATURE, // Signature.
936             from, // `from`.
937             toMasked, // `to`.
938             tokenId // `tokenId`.
939             )
940         }
941         if (toMasked == 0) _revert(TransferToZeroAddress.selector);
942 
943         _afterTokenTransfers(from, to, tokenId, 1);
944     }
945 
946     /**
947      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
948      */
949     function safeTransferFrom(
950         address from,
951         address to,
952         uint256 tokenId
953     ) public payable virtual override {
954         safeTransferFrom(from, to, tokenId, '');
955     }
956 
957     /**
958      * @dev Safely transfers `tokenId` token from `from` to `to`.
959      *
960      * Requirements:
961      *
962      * - `from` cannot be the zero address.
963      * - `to` cannot be the zero address.
964      * - `tokenId` token must exist and be owned by `from`.
965      * - If the caller is not `from`, it must be approved to move this token
966      * by either {approve} or {setApprovalForAll}.
967      * - If `to` refers to a smart contract, it must implement
968      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
969      *
970      * Emits a {Transfer} event.
971      */
972     function safeTransferFrom(
973         address from,
974         address to,
975         uint256 tokenId,
976         bytes memory _data
977     ) public payable virtual override {
978         transferFrom(from, to, tokenId);
979         if (to.code.length != 0)
980             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
981                 _revert(TransferToNonERC721ReceiverImplementer.selector);
982             }
983     }
984 
985     /**
986      * @dev Hook that is called before a set of serially-ordered token IDs
987      * are about to be transferred. This includes minting.
988      * And also called before burning one token.
989      *
990      * `startTokenId` - the first token ID to be transferred.
991      * `quantity` - the amount to be transferred.
992      *
993      * Calling conditions:
994      *
995      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
996      * transferred to `to`.
997      * - When `from` is zero, `tokenId` will be minted for `to`.
998      * - When `to` is zero, `tokenId` will be burned by `from`.
999      * - `from` and `to` are never both zero.
1000      */
1001     function _beforeTokenTransfers(
1002         address from,
1003         address to,
1004         uint256 startTokenId,
1005         uint256 quantity
1006     ) internal virtual {}
1007 
1008     /**
1009      * @dev Hook that is called after a set of serially-ordered token IDs
1010      * have been transferred. This includes minting.
1011      * And also called after one token has been burned.
1012      *
1013      * `startTokenId` - the first token ID to be transferred.
1014      * `quantity` - the amount to be transferred.
1015      *
1016      * Calling conditions:
1017      *
1018      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1019      * transferred to `to`.
1020      * - When `from` is zero, `tokenId` has been minted for `to`.
1021      * - When `to` is zero, `tokenId` has been burned by `from`.
1022      * - `from` and `to` are never both zero.
1023      */
1024     function _afterTokenTransfers(
1025         address from,
1026         address to,
1027         uint256 startTokenId,
1028         uint256 quantity
1029     ) internal virtual {}
1030 
1031     /**
1032      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1033      *
1034      * `from` - Previous owner of the given token ID.
1035      * `to` - Target address that will receive the token.
1036      * `tokenId` - Token ID to be transferred.
1037      * `_data` - Optional data to send along with the call.
1038      *
1039      * Returns whether the call correctly returned the expected magic value.
1040      */
1041     function _checkContractOnERC721Received(
1042         address from,
1043         address to,
1044         uint256 tokenId,
1045         bytes memory _data
1046     ) private returns (bool) {
1047         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1048             bytes4 retval
1049         ) {
1050             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1051         } catch (bytes memory reason) {
1052             if (reason.length == 0) {
1053                 _revert(TransferToNonERC721ReceiverImplementer.selector);
1054             }
1055             assembly {
1056                 revert(add(32, reason), mload(reason))
1057             }
1058         }
1059     }
1060 
1061     // =============================================================
1062     //                        MINT OPERATIONS
1063     // =============================================================
1064 
1065     /**
1066      * @dev Mints `quantity` tokens and transfers them to `to`.
1067      *
1068      * Requirements:
1069      *
1070      * - `to` cannot be the zero address.
1071      * - `quantity` must be greater than 0.
1072      *
1073      * Emits a {Transfer} event for each mint.
1074      */
1075     function _mint(address to, uint256 quantity) internal virtual {
1076         uint256 startTokenId = _currentIndex;
1077         if (quantity == 0) _revert(MintZeroQuantity.selector);
1078 
1079         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1080 
1081         // Overflows are incredibly unrealistic.
1082         // `balance` and `numberMinted` have a maximum limit of 2**64.
1083         // `tokenId` has a maximum limit of 2**256.
1084     unchecked {
1085         // Updates:
1086         // - `address` to the owner.
1087         // - `startTimestamp` to the timestamp of minting.
1088         // - `burned` to `false`.
1089         // - `nextInitialized` to `quantity == 1`.
1090         _packedOwnerships[startTokenId] = _packOwnershipData(
1091             to,
1092             _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1093         );
1094 
1095         // Updates:
1096         // - `balance += quantity`.
1097         // - `numberMinted += quantity`.
1098         //
1099         // We can directly add to the `balance` and `numberMinted`.
1100         _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1101 
1102         // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1103         uint256 toMasked = uint256(uint160(to)) & _BITMASK_ADDRESS;
1104 
1105         if (toMasked == 0) _revert(MintToZeroAddress.selector);
1106 
1107         uint256 end = startTokenId + quantity;
1108         uint256 tokenId = startTokenId;
1109 
1110         do {
1111             assembly {
1112             // Emit the `Transfer` event.
1113                 log4(
1114                 0, // Start of data (0, since no data).
1115                 0, // End of data (0, since no data).
1116                 _TRANSFER_EVENT_SIGNATURE, // Signature.
1117                 0, // `address(0)`.
1118                 toMasked, // `to`.
1119                 tokenId // `tokenId`.
1120                 )
1121             }
1122             // The `!=` check ensures that large values of `quantity`
1123             // that overflows uint256 will make the loop run out of gas.
1124         } while (++tokenId != end);
1125 
1126         _currentIndex = end;
1127     }
1128         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1129     }
1130 
1131 
1132     /**
1133      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1134      *
1135      * Requirements:
1136      *
1137      * - If `to` refers to a smart contract, it must implement
1138      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1139      * - `quantity` must be greater than 0.
1140      *
1141      * See {_mint}.
1142      *
1143      * Emits a {Transfer} event for each mint.
1144      */
1145     function _safeMint(
1146         address to,
1147         uint256 quantity,
1148         bytes memory _data
1149     ) internal virtual {
1150         _mint(to, quantity);
1151 
1152     unchecked {
1153         if (to.code.length != 0) {
1154             uint256 end = _currentIndex;
1155             uint256 index = end - quantity;
1156             do {
1157                 if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1158                     _revert(TransferToNonERC721ReceiverImplementer.selector);
1159                 }
1160             } while (index < end);
1161             // Reentrancy protection.
1162             if (_currentIndex != end) _revert(bytes4(0));
1163         }
1164     }
1165     }
1166 
1167     /**
1168      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1169      */
1170     function _safeMint(address to, uint256 quantity) internal virtual {
1171         _safeMint(to, quantity, '');
1172     }
1173 
1174     // =============================================================
1175     //                       APPROVAL OPERATIONS
1176     // =============================================================
1177 
1178     /**
1179      * @dev Equivalent to `_approve(to, tokenId, false)`.
1180      */
1181     function _approve(address to, uint256 tokenId) internal virtual {
1182         _approve(to, tokenId, false);
1183     }
1184 
1185     /**
1186      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1187      * The approval is cleared when the token is transferred.
1188      *
1189      * Only a single account can be approved at a time, so approving the
1190      * zero address clears previous approvals.
1191      *
1192      * Requirements:
1193      *
1194      * - `tokenId` must exist.
1195      *
1196      * Emits an {Approval} event.
1197      */
1198     function _approve(
1199         address to,
1200         uint256 tokenId,
1201         bool approvalCheck
1202     ) internal virtual {
1203         address owner = ownerOf(tokenId);
1204 
1205         if (approvalCheck && _msgSenderERC721A() != owner)
1206             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1207                 _revert(ApprovalCallerNotOwnerNorApproved.selector);
1208             }
1209 
1210         _tokenApprovals[tokenId].value = to;
1211         emit Approval(owner, to, tokenId);
1212     }
1213 
1214     // =============================================================
1215     //                     EXTRA DATA OPERATIONS
1216     // =============================================================
1217 
1218     /**
1219      * @dev Directly sets the extra data for the ownership data `index`.
1220      */
1221     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1222         uint256 packed = _packedOwnerships[index];
1223         if (packed == 0) _revert(OwnershipNotInitializedForExtraData.selector);
1224         uint256 extraDataCasted;
1225         // Cast `extraData` with assembly to avoid redundant masking.
1226         assembly {
1227             extraDataCasted := extraData
1228         }
1229         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1230         _packedOwnerships[index] = packed;
1231     }
1232 
1233     /**
1234      * @dev Called during each token transfer to set the 24bit `extraData` field.
1235      * Intended to be overridden by the cosumer contract.
1236      *
1237      * `previousExtraData` - the value of `extraData` before transfer.
1238      *
1239      * Calling conditions:
1240      *
1241      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1242      * transferred to `to`.
1243      * - When `from` is zero, `tokenId` will be minted for `to`.
1244      * - When `to` is zero, `tokenId` will be burned by `from`.
1245      * - `from` and `to` are never both zero.
1246      */
1247     function _extraData(
1248         address from,
1249         address to,
1250         uint24 previousExtraData
1251     ) internal view virtual returns (uint24) {}
1252 
1253     /**
1254      * @dev Returns the next extra data for the packed ownership data.
1255      * The returned result is shifted into position.
1256      */
1257     function _nextExtraData(
1258         address from,
1259         address to,
1260         uint256 prevOwnershipPacked
1261     ) private view returns (uint256) {
1262         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1263         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1264     }
1265 
1266     // =============================================================
1267     //                       OTHER OPERATIONS
1268     // =============================================================
1269 
1270     /**
1271      * @dev Returns the message sender (defaults to `msg.sender`).
1272      *
1273      * If you are writing GSN compatible contracts, you need to override this function.
1274      */
1275     function _msgSenderERC721A() internal view virtual returns (address) {
1276         return msg.sender;
1277     }
1278 
1279     /**
1280      * @dev Converts a uint256 to its ASCII string decimal representation.
1281      */
1282     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1283         assembly {
1284         // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1285         // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1286         // We will need 1 word for the trailing zeros padding, 1 word for the length,
1287         // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1288             let m := add(mload(0x40), 0xa0)
1289         // Update the free memory pointer to allocate.
1290             mstore(0x40, m)
1291         // Assign the `str` to the end.
1292             str := sub(m, 0x20)
1293         // Zeroize the slot after the string.
1294             mstore(str, 0)
1295 
1296         // Cache the end of the memory to calculate the length later.
1297             let end := str
1298 
1299         // We write the string from rightmost digit to leftmost digit.
1300         // The following is essentially a do-while loop that also handles the zero case.
1301         // prettier-ignore
1302             for { let temp := value } 1 {} {
1303                 str := sub(str, 1)
1304             // Write the character to the pointer.
1305             // The ASCII index of the '0' character is 48.
1306                 mstore8(str, add(48, mod(temp, 10)))
1307             // Keep dividing `temp` until zero.
1308                 temp := div(temp, 10)
1309             // prettier-ignore
1310                 if iszero(temp) { break }
1311             }
1312 
1313             let length := sub(end, str)
1314         // Move the pointer 32 bytes leftwards to make room for the length.
1315             str := sub(str, 0x20)
1316         // Store the length.
1317             mstore(str, length)
1318         }
1319     }
1320 
1321     /**
1322      * @dev For more efficient reverts.
1323      */
1324     function _revert(bytes4 errorSelector) internal pure {
1325         assembly {
1326             mstore(0x00, errorSelector)
1327             revert(0x00, 0x04)
1328         }
1329     }
1330 }
1331 
1332 library MerkleProof {
1333     /**
1334      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1335      * defined by `root`. For this, a `proof` must be provided, containing
1336      * sibling hashes on the branch from the leaf to the root of the tree. Each
1337      * pair of leaves and each pair of pre-images are assumed to be sorted.
1338      */
1339     function verify(
1340         bytes32[] memory proof,
1341         bytes32 root,
1342         bytes32 leaf
1343     ) internal pure returns (bool) {
1344         return processProof(proof, leaf) == root;
1345     }
1346 
1347     /**
1348      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1349      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1350      * hash matches the root of the tree. When processing the proof, the pairs
1351      * of leafs & pre-images are assumed to be sorted.
1352      *
1353      * _Available since v4.4._
1354      */
1355     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1356         bytes32 computedHash = leaf;
1357         for (uint256 i = 0; i < proof.length; i++) {
1358             bytes32 proofElement = proof[i];
1359             if (computedHash <= proofElement) {
1360                 // Hash(current computed hash + current element of the proof)
1361                 computedHash = _efficientHash(computedHash, proofElement);
1362             } else {
1363                 // Hash(current element of the proof + current computed hash)
1364                 computedHash = _efficientHash(proofElement, computedHash);
1365             }
1366         }
1367         return computedHash;
1368     }
1369 
1370     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1371         assembly {
1372             mstore(0x00, a)
1373             mstore(0x20, b)
1374             value := keccak256(0x00, 0x40)
1375         }
1376     }
1377 }
1378 
1379 
1380 contract BambooColor is ERC721A, Ownable
1381 {
1382 
1383     struct Message {
1384         address addr;
1385         string content;
1386     }
1387 
1388     struct MintConfig {
1389         bool isOpen;
1390         uint16 maxPerTx;
1391         uint16 maxPerWallet;
1392         uint256 price;
1393     }
1394 
1395     uint256 constant public maxSupply = 456;
1396     bytes32 private whitelistMerkleRoot;
1397 
1398     mapping(address => mapping(uint256 => uint256)) whiteHolderMinted;
1399     mapping(address => uint256) public whitelistMinted;
1400     mapping(uint256 => string) public privateURI;
1401     mapping(uint256 => Message[]) public tokenInscription;
1402     mapping(uint256 => mapping(address => bool)) public holderInscripted;
1403     mapping(uint256 => Message[]) public tokenMessage;
1404 
1405     MintConfig public whitelistMintConf;
1406     MintConfig public whiteHolderMintConf;
1407     MintConfig public publicMintConf;
1408 
1409     address private CONTRACT_A_ADDR;
1410 
1411     bool isInscriptionOpen;
1412     bool ismessageSendOpen;
1413 
1414     string private baseURI = "ipfs://";
1415 
1416     constructor() ERC721A("Bamboo Color", "Color"){}
1417 
1418     function changeBaseURI(string memory newUri) public onlyOwner {
1419         baseURI = newUri;
1420     }
1421 
1422     function _baseURI() internal view virtual override returns (string memory) {
1423         return baseURI;
1424     }
1425 
1426 
1427     // PUBLIC MINT
1428     function setMintConfig(uint16 mode, MintConfig memory _conf) public onlyOwner {
1429         if (mode == 1) {
1430             whitelistMintConf = _conf;
1431         }else if (mode == 2) {
1432             whiteHolderMintConf = _conf;
1433         }else if (mode == 3) {
1434             publicMintConf = _conf;
1435         }
1436     }
1437 
1438 
1439     function publicMint(address to, uint16 amount) public payable {
1440         require(publicMintConf.isOpen, "Public Mint is not available!");
1441         require(totalSupply() + amount <= maxSupply, "No more NFT!");
1442         require(publicMintConf.maxPerTx == 0 || amount <= publicMintConf.maxPerTx, "Reached limit per tx");
1443         require(publicMintConf.price == 0 || msg.value >= publicMintConf.price, "Insufficient value!");
1444 
1445         address toAddr = to == address(0) ? msg.sender : to;
1446 
1447         _safeMint(toAddr, amount);
1448     }
1449 
1450     // WHITELIST MINT
1451     function setWhitelistMerkleRoot(bytes32 root) public onlyOwner {
1452         whitelistMerkleRoot = root;
1453     }
1454 
1455     function whitelistMint(address to, uint16 amount, bytes32[] memory proof) public payable {
1456         require(whitelistMintConf.isOpen, "Whitelist Mint is not available!");
1457         require(totalSupply() + amount <= maxSupply, "No more NFT!");
1458         require(whitelistMintConf.maxPerTx == 0 || amount <= whitelistMintConf.maxPerTx, "Reached limit per tx");
1459         require(whitelistMintConf.price == 0 || msg.value >= whitelistMintConf.price, "Insufficient value!");
1460 
1461 
1462         address toAddr = to == address(0) ? msg.sender : to;
1463         require(checkWhitelist(toAddr, whitelistMerkleRoot, proof), "You are not in whitelist");
1464         require(whitelistMintConf.maxPerWallet == 0 || whitelistMinted[toAddr] + amount <= whitelistMintConf.maxPerWallet, "Reached limit per wallet");
1465 
1466         whitelistMinted[toAddr] += amount;
1467         _safeMint(toAddr, amount);
1468     }
1469 
1470     function checkWhitelist(address to, bytes32 root, bytes32[] memory proof) public pure returns (bool){
1471         return MerkleProof.verify(proof, root, keccak256(abi.encodePacked(to)));
1472     }
1473 
1474     // HOLDER MINT
1475     function setWhiteListContract(address addr) public onlyOwner {
1476         CONTRACT_A_ADDR = addr;
1477     }
1478 
1479     function whiteHolderMint(address to, uint256 tokenID, uint16 amount) public payable {
1480         require(whiteHolderMintConf.isOpen, "Holder A Mint is not available!");
1481         require(totalSupply() + amount <= maxSupply, "No more NFT!");
1482         require(CONTRACT_A_ADDR != address(0), "Contract A addr not set");
1483         require(whiteHolderMintConf.price == 0 || msg.value >= whiteHolderMintConf.price, "Insufficient value!");
1484 
1485         address toAddr = to == address(0) ? msg.sender : to;
1486         require(IERC721A(CONTRACT_A_ADDR).ownerOf(tokenID) == toAddr, "Don't have this nft");
1487         require(whiteHolderMintConf.maxPerTx == 0 || whiteHolderMinted[CONTRACT_A_ADDR][tokenID] + amount <= whiteHolderMintConf.maxPerTx, "TokenID is used");
1488 
1489         whiteHolderMinted[CONTRACT_A_ADDR][tokenID] += amount;
1490         _safeMint(toAddr, amount);
1491     }
1492 
1493     function checkHolderTokenMinted(address addr, uint16 tokenID) public view returns (uint256) {
1494         return whiteHolderMinted[addr][tokenID];
1495     }
1496 
1497     // ADMIN MINT
1498     function adminMint(address[] memory accounts, uint16[] memory nums) public onlyOwner {
1499         require(accounts.length > 0 && accounts.length == nums.length, "Length not match");
1500         for (uint i = 0; i < accounts.length; i++) {
1501             _safeMint(accounts[i], nums[i]);
1502         }
1503     }
1504 
1505     // InscriptToken
1506     function setIsInscriptionTokenOpen(bool isOpen) public onlyOwner {
1507         isInscriptionOpen = isOpen;
1508     }
1509 
1510     function inscriptToken(uint256 tokenID, string memory content) public {
1511         require(isInscriptionOpen, "Inscription not open");
1512         require(ownerOf(tokenID) == msg.sender, "not owner");
1513         require(!holderInscripted[tokenID][msg.sender], "already inscripted");
1514 
1515         Message memory m = Message(msg.sender, content);
1516         tokenInscription[tokenID].push(m);
1517     }
1518 
1519     function setIsmessageSendOpen(bool isOpen) public onlyOwner {
1520         ismessageSendOpen = isOpen;
1521     }
1522 
1523     function messageSend(uint256 tokenID, string memory content) public {
1524         require(ismessageSendOpen, "messageSend not open");
1525         Message memory m = Message(msg.sender, content);
1526         tokenMessage[tokenID].push(m);
1527     }
1528 
1529     function messageDelete(uint256 tokenID, uint256 index) public {
1530         require(tokenMessage[tokenID].length > index, "index out of range");
1531         tokenMessage[tokenID][index] = Message(address(0), '');
1532     }
1533 
1534     function readAllInscription(uint256 tokenID) public view returns (Message[] memory) {
1535         return tokenInscription[tokenID];
1536     }
1537 
1538     function readAllMessages(uint256 tokenID) public view returns (Message[] memory) {
1539         return tokenMessage[tokenID];
1540     }
1541 
1542 
1543     function setPrivateURI(uint256 tokenID, string memory uri) public onlyOwner {
1544         privateURI[tokenID] = uri;
1545     }
1546 
1547     function resetPrivateURI(uint256 tokenID) public onlyOwner {
1548         privateURI[tokenID] = '';
1549     }
1550 
1551     function tokenURI(uint256 tokenID) public view virtual override returns (string memory) {
1552         if (!_exists(tokenID)) _revert(URIQueryForNonexistentToken.selector);
1553 
1554         if  (bytes(privateURI[tokenID]).length != 0) {
1555             return privateURI[tokenID];
1556         }
1557 
1558         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenID))) : '';
1559     }
1560 
1561     function _startTokenId() internal view virtual override returns (uint256) {
1562         return 1;
1563     }
1564 
1565     function withdraw() public onlyOwner {
1566         uint balance = address(this).balance;
1567         payable(_msgSender()).transfer(balance);
1568     }
1569 }