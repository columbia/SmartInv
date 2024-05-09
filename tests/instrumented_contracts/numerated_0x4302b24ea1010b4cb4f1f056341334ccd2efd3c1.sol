1 // File: default_workspace/contracts/IDungeonRewards.sol
2 
3 
4 pragma solidity ^0.8.12;
5 
6 interface IDungeonRewards {
7 
8     // so we can confirm whether a wallet holds any staked dungeons, useful for Generative Avatars gas-only mint
9     function balanceOfDungeons(address owner) external view returns (uint256);
10     // so we can confirm when a wallet staked their dungeons, useful for Generative Avatars gas-only mint
11     function dungeonFirstStaked(address owner) external view returns (uint256);
12 
13     function balanceOfAvatars(address owner) external view returns (uint256);
14     function avatarFirstStaked(address owner) external  view returns (uint256);
15 
16     function balanceOfQuests(address owner) external view returns (uint256);
17     function questFirstStaked(address owner) external view returns (uint256);
18 
19     function getStakedTokens(address user) external view returns (uint256[] memory dungeons, uint256[] memory avatars, 
20                                                                   uint256[] memory quests);
21   
22 }
23 // File: erc721a/contracts/IERC721A.sol
24 
25 
26 // ERC721A Contracts v4.2.0
27 // Creator: Chiru Labs
28 
29 pragma solidity ^0.8.4;
30 
31 /**
32  * @dev Interface of ERC721A.
33  */
34 interface IERC721A {
35     /**
36      * The caller must own the token or be an approved operator.
37      */
38     error ApprovalCallerNotOwnerNorApproved();
39 
40     /**
41      * The token does not exist.
42      */
43     error ApprovalQueryForNonexistentToken();
44 
45     /**
46      * The caller cannot approve to their own address.
47      */
48     error ApproveToCaller();
49 
50     /**
51      * Cannot query the balance for the zero address.
52      */
53     error BalanceQueryForZeroAddress();
54 
55     /**
56      * Cannot mint to the zero address.
57      */
58     error MintToZeroAddress();
59 
60     /**
61      * The quantity of tokens minted must be more than zero.
62      */
63     error MintZeroQuantity();
64 
65     /**
66      * The token does not exist.
67      */
68     error OwnerQueryForNonexistentToken();
69 
70     /**
71      * The caller must own the token or be an approved operator.
72      */
73     error TransferCallerNotOwnerNorApproved();
74 
75     /**
76      * The token must be owned by `from`.
77      */
78     error TransferFromIncorrectOwner();
79 
80     /**
81      * Cannot safely transfer to a contract that does not implement the
82      * ERC721Receiver interface.
83      */
84     error TransferToNonERC721ReceiverImplementer();
85 
86     /**
87      * Cannot transfer to the zero address.
88      */
89     error TransferToZeroAddress();
90 
91     /**
92      * The token does not exist.
93      */
94     error URIQueryForNonexistentToken();
95 
96     /**
97      * The `quantity` minted with ERC2309 exceeds the safety limit.
98      */
99     error MintERC2309QuantityExceedsLimit();
100 
101     /**
102      * The `extraData` cannot be set on an unintialized ownership slot.
103      */
104     error OwnershipNotInitializedForExtraData();
105 
106     // =============================================================
107     //                            STRUCTS
108     // =============================================================
109 
110     struct TokenOwnership {
111         // The address of the owner.
112         address addr;
113         // Stores the start time of ownership with minimal overhead for tokenomics.
114         uint64 startTimestamp;
115         // Whether the token has been burned.
116         bool burned;
117         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
118         uint24 extraData;
119     }
120 
121     // =============================================================
122     //                         TOKEN COUNTERS
123     // =============================================================
124 
125     /**
126      * @dev Returns the total number of tokens in existence.
127      * Burned tokens will reduce the count.
128      * To get the total number of tokens minted, please see {_totalMinted}.
129      */
130     function totalSupply() external view returns (uint256);
131 
132     // =============================================================
133     //                            IERC165
134     // =============================================================
135 
136     /**
137      * @dev Returns true if this contract implements the interface defined by
138      * `interfaceId`. See the corresponding
139      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
140      * to learn more about how these ids are created.
141      *
142      * This function call must use less than 30000 gas.
143      */
144     function supportsInterface(bytes4 interfaceId) external view returns (bool);
145 
146     // =============================================================
147     //                            IERC721
148     // =============================================================
149 
150     /**
151      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
152      */
153     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
154 
155     /**
156      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
157      */
158     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
159 
160     /**
161      * @dev Emitted when `owner` enables or disables
162      * (`approved`) `operator` to manage all of its assets.
163      */
164     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
165 
166     /**
167      * @dev Returns the number of tokens in `owner`'s account.
168      */
169     function balanceOf(address owner) external view returns (uint256 balance);
170 
171     /**
172      * @dev Returns the owner of the `tokenId` token.
173      *
174      * Requirements:
175      *
176      * - `tokenId` must exist.
177      */
178     function ownerOf(uint256 tokenId) external view returns (address owner);
179 
180     /**
181      * @dev Safely transfers `tokenId` token from `from` to `to`,
182      * checking first that contract recipients are aware of the ERC721 protocol
183      * to prevent tokens from being forever locked.
184      *
185      * Requirements:
186      *
187      * - `from` cannot be the zero address.
188      * - `to` cannot be the zero address.
189      * - `tokenId` token must exist and be owned by `from`.
190      * - If the caller is not `from`, it must be have been allowed to move
191      * this token by either {approve} or {setApprovalForAll}.
192      * - If `to` refers to a smart contract, it must implement
193      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
194      *
195      * Emits a {Transfer} event.
196      */
197     function safeTransferFrom(
198         address from,
199         address to,
200         uint256 tokenId,
201         bytes calldata data
202     ) external;
203 
204     /**
205      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
206      */
207     function safeTransferFrom(
208         address from,
209         address to,
210         uint256 tokenId
211     ) external;
212 
213     /**
214      * @dev Transfers `tokenId` from `from` to `to`.
215      *
216      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
217      * whenever possible.
218      *
219      * Requirements:
220      *
221      * - `from` cannot be the zero address.
222      * - `to` cannot be the zero address.
223      * - `tokenId` token must be owned by `from`.
224      * - If the caller is not `from`, it must be approved to move this token
225      * by either {approve} or {setApprovalForAll}.
226      *
227      * Emits a {Transfer} event.
228      */
229     function transferFrom(
230         address from,
231         address to,
232         uint256 tokenId
233     ) external;
234 
235     /**
236      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
237      * The approval is cleared when the token is transferred.
238      *
239      * Only a single account can be approved at a time, so approving the
240      * zero address clears previous approvals.
241      *
242      * Requirements:
243      *
244      * - The caller must own the token or be an approved operator.
245      * - `tokenId` must exist.
246      *
247      * Emits an {Approval} event.
248      */
249     function approve(address to, uint256 tokenId) external;
250 
251     /**
252      * @dev Approve or remove `operator` as an operator for the caller.
253      * Operators can call {transferFrom} or {safeTransferFrom}
254      * for any token owned by the caller.
255      *
256      * Requirements:
257      *
258      * - The `operator` cannot be the caller.
259      *
260      * Emits an {ApprovalForAll} event.
261      */
262     function setApprovalForAll(address operator, bool _approved) external;
263 
264     /**
265      * @dev Returns the account approved for `tokenId` token.
266      *
267      * Requirements:
268      *
269      * - `tokenId` must exist.
270      */
271     function getApproved(uint256 tokenId) external view returns (address operator);
272 
273     /**
274      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
275      *
276      * See {setApprovalForAll}.
277      */
278     function isApprovedForAll(address owner, address operator) external view returns (bool);
279 
280     // =============================================================
281     //                        IERC721Metadata
282     // =============================================================
283 
284     /**
285      * @dev Returns the token collection name.
286      */
287     function name() external view returns (string memory);
288 
289     /**
290      * @dev Returns the token collection symbol.
291      */
292     function symbol() external view returns (string memory);
293 
294     /**
295      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
296      */
297     function tokenURI(uint256 tokenId) external view returns (string memory);
298 
299     // =============================================================
300     //                           IERC2309
301     // =============================================================
302 
303     /**
304      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
305      * (inclusive) is transferred from `from` to `to`, as defined in the
306      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
307      *
308      * See {_mintERC2309} for more details.
309      */
310     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
311 }
312 
313 // File: erc721a/contracts/extensions/IERC4907A.sol
314 
315 
316 // ERC721A Contracts v4.2.0
317 // Creator: Chiru Labs
318 
319 pragma solidity ^0.8.4;
320 
321 
322 /**
323  * @dev Interface of ERC4907A.
324  */
325 interface IERC4907A is IERC721A {
326     /**
327      * The caller must own the token or be an approved operator.
328      */
329     error SetUserCallerNotOwnerNorApproved();
330 
331     /**
332      * @dev Emitted when the `user` of an NFT or the `expires` of the `user` is changed.
333      * The zero address for user indicates that there is no user address.
334      */
335     event UpdateUser(uint256 indexed tokenId, address indexed user, uint64 expires);
336 
337     /**
338      * @dev Sets the `user` and `expires` for `tokenId`.
339      * The zero address indicates there is no user.
340      *
341      * Requirements:
342      *
343      * - The caller must own `tokenId` or be an approved operator.
344      */
345     function setUser(
346         uint256 tokenId,
347         address user,
348         uint64 expires
349     ) external;
350 
351     /**
352      * @dev Returns the user address for `tokenId`.
353      * The zero address indicates that there is no user or if the user is expired.
354      */
355     function userOf(uint256 tokenId) external view returns (address);
356 
357     /**
358      * @dev Returns the user's expires of `tokenId`.
359      */
360     function userExpires(uint256 tokenId) external view returns (uint256);
361 }
362 
363 // File: erc721a/contracts/ERC721A.sol
364 
365 
366 // ERC721A Contracts v4.2.0
367 // Creator: Chiru Labs
368 
369 pragma solidity ^0.8.4;
370 
371 
372 /**
373  * @dev Interface of ERC721 token receiver.
374  */
375 interface ERC721A__IERC721Receiver {
376     function onERC721Received(
377         address operator,
378         address from,
379         uint256 tokenId,
380         bytes calldata data
381     ) external returns (bytes4);
382 }
383 
384 /**
385  * @title ERC721A
386  *
387  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
388  * Non-Fungible Token Standard, including the Metadata extension.
389  * Optimized for lower gas during batch mints.
390  *
391  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
392  * starting from `_startTokenId()`.
393  *
394  * Assumptions:
395  *
396  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
397  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
398  */
399 contract ERC721A is IERC721A {
400     // Reference type for token approval.
401     struct TokenApprovalRef {
402         address value;
403     }
404 
405     // =============================================================
406     //                           CONSTANTS
407     // =============================================================
408 
409     // Mask of an entry in packed address data.
410     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
411 
412     // The bit position of `numberMinted` in packed address data.
413     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
414 
415     // The bit position of `numberBurned` in packed address data.
416     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
417 
418     // The bit position of `aux` in packed address data.
419     uint256 private constant _BITPOS_AUX = 192;
420 
421     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
422     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
423 
424     // The bit position of `startTimestamp` in packed ownership.
425     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
426 
427     // The bit mask of the `burned` bit in packed ownership.
428     uint256 private constant _BITMASK_BURNED = 1 << 224;
429 
430     // The bit position of the `nextInitialized` bit in packed ownership.
431     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
432 
433     // The bit mask of the `nextInitialized` bit in packed ownership.
434     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
435 
436     // The bit position of `extraData` in packed ownership.
437     uint256 private constant _BITPOS_EXTRA_DATA = 232;
438 
439     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
440     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
441 
442     // The mask of the lower 160 bits for addresses.
443     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
444 
445     // The maximum `quantity` that can be minted with {_mintERC2309}.
446     // This limit is to prevent overflows on the address data entries.
447     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
448     // is required to cause an overflow, which is unrealistic.
449     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
450 
451     // The `Transfer` event signature is given by:
452     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
453     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
454         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
455 
456     // =============================================================
457     //                            STORAGE
458     // =============================================================
459 
460     // The next token ID to be minted.
461     uint256 private _currentIndex;
462 
463     // The number of tokens burned.
464     uint256 private _burnCounter;
465 
466     // Token name
467     string private _name;
468 
469     // Token symbol
470     string private _symbol;
471 
472     // Mapping from token ID to ownership details
473     // An empty struct value does not necessarily mean the token is unowned.
474     // See {_packedOwnershipOf} implementation for details.
475     //
476     // Bits Layout:
477     // - [0..159]   `addr`
478     // - [160..223] `startTimestamp`
479     // - [224]      `burned`
480     // - [225]      `nextInitialized`
481     // - [232..255] `extraData`
482     mapping(uint256 => uint256) private _packedOwnerships;
483 
484     // Mapping owner address to address data.
485     //
486     // Bits Layout:
487     // - [0..63]    `balance`
488     // - [64..127]  `numberMinted`
489     // - [128..191] `numberBurned`
490     // - [192..255] `aux`
491     mapping(address => uint256) private _packedAddressData;
492 
493     // Mapping from token ID to approved address.
494     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
495 
496     // Mapping from owner to operator approvals
497     mapping(address => mapping(address => bool)) private _operatorApprovals;
498 
499     // =============================================================
500     //                          CONSTRUCTOR
501     // =============================================================
502 
503     constructor(string memory name_, string memory symbol_) {
504         _name = name_;
505         _symbol = symbol_;
506         _currentIndex = _startTokenId();
507     }
508 
509     // =============================================================
510     //                   TOKEN COUNTING OPERATIONS
511     // =============================================================
512 
513     /**
514      * @dev Returns the starting token ID.
515      * To change the starting token ID, please override this function.
516      */
517     function _startTokenId() internal view virtual returns (uint256) {
518         return 0;
519     }
520 
521     /**
522      * @dev Returns the next token ID to be minted.
523      */
524     function _nextTokenId() internal view virtual returns (uint256) {
525         return _currentIndex;
526     }
527 
528     /**
529      * @dev Returns the total number of tokens in existence.
530      * Burned tokens will reduce the count.
531      * To get the total number of tokens minted, please see {_totalMinted}.
532      */
533     function totalSupply() public view virtual override returns (uint256) {
534         // Counter underflow is impossible as _burnCounter cannot be incremented
535         // more than `_currentIndex - _startTokenId()` times.
536         unchecked {
537             return _currentIndex - _burnCounter - _startTokenId();
538         }
539     }
540 
541     /**
542      * @dev Returns the total amount of tokens minted in the contract.
543      */
544     function _totalMinted() internal view virtual returns (uint256) {
545         // Counter underflow is impossible as `_currentIndex` does not decrement,
546         // and it is initialized to `_startTokenId()`.
547         unchecked {
548             return _currentIndex - _startTokenId();
549         }
550     }
551 
552     /**
553      * @dev Returns the total number of tokens burned.
554      */
555     function _totalBurned() internal view virtual returns (uint256) {
556         return _burnCounter;
557     }
558 
559     // =============================================================
560     //                    ADDRESS DATA OPERATIONS
561     // =============================================================
562 
563     /**
564      * @dev Returns the number of tokens in `owner`'s account.
565      */
566     function balanceOf(address owner) public view virtual override returns (uint256) {
567         if (owner == address(0)) revert BalanceQueryForZeroAddress();
568         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
569     }
570 
571     /**
572      * Returns the number of tokens minted by `owner`.
573      */
574     function _numberMinted(address owner) internal view returns (uint256) {
575         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
576     }
577 
578     /**
579      * Returns the number of tokens burned by or on behalf of `owner`.
580      */
581     function _numberBurned(address owner) internal view returns (uint256) {
582         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
583     }
584 
585     /**
586      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
587      */
588     function _getAux(address owner) internal view returns (uint64) {
589         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
590     }
591 
592     /**
593      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
594      * If there are multiple variables, please pack them into a uint64.
595      */
596     function _setAux(address owner, uint64 aux) internal virtual {
597         uint256 packed = _packedAddressData[owner];
598         uint256 auxCasted;
599         // Cast `aux` with assembly to avoid redundant masking.
600         assembly {
601             auxCasted := aux
602         }
603         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
604         _packedAddressData[owner] = packed;
605     }
606 
607     // =============================================================
608     //                            IERC165
609     // =============================================================
610 
611     /**
612      * @dev Returns true if this contract implements the interface defined by
613      * `interfaceId`. See the corresponding
614      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
615      * to learn more about how these ids are created.
616      *
617      * This function call must use less than 30000 gas.
618      */
619     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
620         // The interface IDs are constants representing the first 4 bytes
621         // of the XOR of all function selectors in the interface.
622         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
623         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
624         return
625             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
626             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
627             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
628     }
629 
630     // =============================================================
631     //                        IERC721Metadata
632     // =============================================================
633 
634     /**
635      * @dev Returns the token collection name.
636      */
637     function name() public view virtual override returns (string memory) {
638         return _name;
639     }
640 
641     /**
642      * @dev Returns the token collection symbol.
643      */
644     function symbol() public view virtual override returns (string memory) {
645         return _symbol;
646     }
647 
648     /**
649      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
650      */
651     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
652         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
653 
654         string memory baseURI = _baseURI();
655         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
656     }
657 
658     /**
659      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
660      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
661      * by default, it can be overridden in child contracts.
662      */
663     function _baseURI() internal view virtual returns (string memory) {
664         return '';
665     }
666 
667     // =============================================================
668     //                     OWNERSHIPS OPERATIONS
669     // =============================================================
670 
671     /**
672      * @dev Returns the owner of the `tokenId` token.
673      *
674      * Requirements:
675      *
676      * - `tokenId` must exist.
677      */
678     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
679         return address(uint160(_packedOwnershipOf(tokenId)));
680     }
681 
682     /**
683      * @dev Gas spent here starts off proportional to the maximum mint batch size.
684      * It gradually moves to O(1) as tokens get transferred around over time.
685      */
686     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
687         return _unpackedOwnership(_packedOwnershipOf(tokenId));
688     }
689 
690     /**
691      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
692      */
693     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
694         return _unpackedOwnership(_packedOwnerships[index]);
695     }
696 
697     /**
698      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
699      */
700     function _initializeOwnershipAt(uint256 index) internal virtual {
701         if (_packedOwnerships[index] == 0) {
702             _packedOwnerships[index] = _packedOwnershipOf(index);
703         }
704     }
705 
706     /**
707      * Returns the packed ownership data of `tokenId`.
708      */
709     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
710         uint256 curr = tokenId;
711 
712         unchecked {
713             if (_startTokenId() <= curr)
714                 if (curr < _currentIndex) {
715                     uint256 packed = _packedOwnerships[curr];
716                     // If not burned.
717                     if (packed & _BITMASK_BURNED == 0) {
718                         // Invariant:
719                         // There will always be an initialized ownership slot
720                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
721                         // before an unintialized ownership slot
722                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
723                         // Hence, `curr` will not underflow.
724                         //
725                         // We can directly compare the packed value.
726                         // If the address is zero, packed will be zero.
727                         while (packed == 0) {
728                             packed = _packedOwnerships[--curr];
729                         }
730                         return packed;
731                     }
732                 }
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
775      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
776      * The approval is cleared when the token is transferred.
777      *
778      * Only a single account can be approved at a time, so approving the
779      * zero address clears previous approvals.
780      *
781      * Requirements:
782      *
783      * - The caller must own the token or be an approved operator.
784      * - `tokenId` must exist.
785      *
786      * Emits an {Approval} event.
787      */
788     function approve(address to, uint256 tokenId) public virtual override {
789         address owner = ownerOf(tokenId);
790 
791         if (_msgSenderERC721A() != owner)
792             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
793                 revert ApprovalCallerNotOwnerNorApproved();
794             }
795 
796         _tokenApprovals[tokenId].value = to;
797         emit Approval(owner, to, tokenId);
798     }
799 
800     /**
801      * @dev Returns the account approved for `tokenId` token.
802      *
803      * Requirements:
804      *
805      * - `tokenId` must exist.
806      */
807     function getApproved(uint256 tokenId) public view virtual override returns (address) {
808         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
809 
810         return _tokenApprovals[tokenId].value;
811     }
812 
813     /**
814      * @dev Approve or remove `operator` as an operator for the caller.
815      * Operators can call {transferFrom} or {safeTransferFrom}
816      * for any token owned by the caller.
817      *
818      * Requirements:
819      *
820      * - The `operator` cannot be the caller.
821      *
822      * Emits an {ApprovalForAll} event.
823      */
824     function setApprovalForAll(address operator, bool approved) public virtual override {
825         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
826 
827         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
828         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
829     }
830 
831     /**
832      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
833      *
834      * See {setApprovalForAll}.
835      */
836     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
837         return _operatorApprovals[owner][operator];
838     }
839 
840     /**
841      * @dev Returns whether `tokenId` exists.
842      *
843      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
844      *
845      * Tokens start existing when they are minted. See {_mint}.
846      */
847     function _exists(uint256 tokenId) internal view virtual returns (bool) {
848         return
849             _startTokenId() <= tokenId &&
850             tokenId < _currentIndex && // If within bounds,
851             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
852     }
853 
854     /**
855      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
856      */
857     function _isSenderApprovedOrOwner(
858         address approvedAddress,
859         address owner,
860         address msgSender
861     ) private pure returns (bool result) {
862         assembly {
863             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
864             owner := and(owner, _BITMASK_ADDRESS)
865             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
866             msgSender := and(msgSender, _BITMASK_ADDRESS)
867             // `msgSender == owner || msgSender == approvedAddress`.
868             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
869         }
870     }
871 
872     /**
873      * @dev Returns the storage slot and value for the approved address of `tokenId`.
874      */
875     function _getApprovedSlotAndAddress(uint256 tokenId)
876         private
877         view
878         returns (uint256 approvedAddressSlot, address approvedAddress)
879     {
880         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
881         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
882         assembly {
883             approvedAddressSlot := tokenApproval.slot
884             approvedAddress := sload(approvedAddressSlot)
885         }
886     }
887 
888     // =============================================================
889     //                      TRANSFER OPERATIONS
890     // =============================================================
891 
892     /**
893      * @dev Transfers `tokenId` from `from` to `to`.
894      *
895      * Requirements:
896      *
897      * - `from` cannot be the zero address.
898      * - `to` cannot be the zero address.
899      * - `tokenId` token must be owned by `from`.
900      * - If the caller is not `from`, it must be approved to move this token
901      * by either {approve} or {setApprovalForAll}.
902      *
903      * Emits a {Transfer} event.
904      */
905     function transferFrom(
906         address from,
907         address to,
908         uint256 tokenId
909     ) public virtual override {
910         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
911 
912         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
913 
914         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
915 
916         // The nested ifs save around 20+ gas over a compound boolean condition.
917         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
918             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
919 
920         if (to == address(0)) revert TransferToZeroAddress();
921 
922         _beforeTokenTransfers(from, to, tokenId, 1);
923 
924         // Clear approvals from the previous owner.
925         assembly {
926             if approvedAddress {
927                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
928                 sstore(approvedAddressSlot, 0)
929             }
930         }
931 
932         // Underflow of the sender's balance is impossible because we check for
933         // ownership above and the recipient's balance can't realistically overflow.
934         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
935         unchecked {
936             // We can directly increment and decrement the balances.
937             --_packedAddressData[from]; // Updates: `balance -= 1`.
938             ++_packedAddressData[to]; // Updates: `balance += 1`.
939 
940             // Updates:
941             // - `address` to the next owner.
942             // - `startTimestamp` to the timestamp of transfering.
943             // - `burned` to `false`.
944             // - `nextInitialized` to `true`.
945             _packedOwnerships[tokenId] = _packOwnershipData(
946                 to,
947                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
948             );
949 
950             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
951             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
952                 uint256 nextTokenId = tokenId + 1;
953                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
954                 if (_packedOwnerships[nextTokenId] == 0) {
955                     // If the next slot is within bounds.
956                     if (nextTokenId != _currentIndex) {
957                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
958                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
959                     }
960                 }
961             }
962         }
963 
964         emit Transfer(from, to, tokenId);
965         _afterTokenTransfers(from, to, tokenId, 1);
966     }
967 
968     /**
969      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
970      */
971     function safeTransferFrom(
972         address from,
973         address to,
974         uint256 tokenId
975     ) public virtual override {
976         safeTransferFrom(from, to, tokenId, '');
977     }
978 
979     /**
980      * @dev Safely transfers `tokenId` token from `from` to `to`.
981      *
982      * Requirements:
983      *
984      * - `from` cannot be the zero address.
985      * - `to` cannot be the zero address.
986      * - `tokenId` token must exist and be owned by `from`.
987      * - If the caller is not `from`, it must be approved to move this token
988      * by either {approve} or {setApprovalForAll}.
989      * - If `to` refers to a smart contract, it must implement
990      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
991      *
992      * Emits a {Transfer} event.
993      */
994     function safeTransferFrom(
995         address from,
996         address to,
997         uint256 tokenId,
998         bytes memory _data
999     ) public virtual override {
1000         transferFrom(from, to, tokenId);
1001         if (to.code.length != 0)
1002             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1003                 revert TransferToNonERC721ReceiverImplementer();
1004             }
1005     }
1006 
1007     /**
1008      * @dev Hook that is called before a set of serially-ordered token IDs
1009      * are about to be transferred. This includes minting.
1010      * And also called before burning one token.
1011      *
1012      * `startTokenId` - the first token ID to be transferred.
1013      * `quantity` - the amount to be transferred.
1014      *
1015      * Calling conditions:
1016      *
1017      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1018      * transferred to `to`.
1019      * - When `from` is zero, `tokenId` will be minted for `to`.
1020      * - When `to` is zero, `tokenId` will be burned by `from`.
1021      * - `from` and `to` are never both zero.
1022      */
1023     function _beforeTokenTransfers(
1024         address from,
1025         address to,
1026         uint256 startTokenId,
1027         uint256 quantity
1028     ) internal virtual {}
1029 
1030     /**
1031      * @dev Hook that is called after a set of serially-ordered token IDs
1032      * have been transferred. This includes minting.
1033      * And also called after one token has been burned.
1034      *
1035      * `startTokenId` - the first token ID to be transferred.
1036      * `quantity` - the amount to be transferred.
1037      *
1038      * Calling conditions:
1039      *
1040      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1041      * transferred to `to`.
1042      * - When `from` is zero, `tokenId` has been minted for `to`.
1043      * - When `to` is zero, `tokenId` has been burned by `from`.
1044      * - `from` and `to` are never both zero.
1045      */
1046     function _afterTokenTransfers(
1047         address from,
1048         address to,
1049         uint256 startTokenId,
1050         uint256 quantity
1051     ) internal virtual {}
1052 
1053     /**
1054      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1055      *
1056      * `from` - Previous owner of the given token ID.
1057      * `to` - Target address that will receive the token.
1058      * `tokenId` - Token ID to be transferred.
1059      * `_data` - Optional data to send along with the call.
1060      *
1061      * Returns whether the call correctly returned the expected magic value.
1062      */
1063     function _checkContractOnERC721Received(
1064         address from,
1065         address to,
1066         uint256 tokenId,
1067         bytes memory _data
1068     ) private returns (bool) {
1069         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1070             bytes4 retval
1071         ) {
1072             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1073         } catch (bytes memory reason) {
1074             if (reason.length == 0) {
1075                 revert TransferToNonERC721ReceiverImplementer();
1076             } else {
1077                 assembly {
1078                     revert(add(32, reason), mload(reason))
1079                 }
1080             }
1081         }
1082     }
1083 
1084     // =============================================================
1085     //                        MINT OPERATIONS
1086     // =============================================================
1087 
1088     /**
1089      * @dev Mints `quantity` tokens and transfers them to `to`.
1090      *
1091      * Requirements:
1092      *
1093      * - `to` cannot be the zero address.
1094      * - `quantity` must be greater than 0.
1095      *
1096      * Emits a {Transfer} event for each mint.
1097      */
1098     function _mint(address to, uint256 quantity) internal virtual {
1099         uint256 startTokenId = _currentIndex;
1100         if (quantity == 0) revert MintZeroQuantity();
1101 
1102         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1103 
1104         // Overflows are incredibly unrealistic.
1105         // `balance` and `numberMinted` have a maximum limit of 2**64.
1106         // `tokenId` has a maximum limit of 2**256.
1107         unchecked {
1108             // Updates:
1109             // - `balance += quantity`.
1110             // - `numberMinted += quantity`.
1111             //
1112             // We can directly add to the `balance` and `numberMinted`.
1113             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1114 
1115             // Updates:
1116             // - `address` to the owner.
1117             // - `startTimestamp` to the timestamp of minting.
1118             // - `burned` to `false`.
1119             // - `nextInitialized` to `quantity == 1`.
1120             _packedOwnerships[startTokenId] = _packOwnershipData(
1121                 to,
1122                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1123             );
1124 
1125             uint256 toMasked;
1126             uint256 end = startTokenId + quantity;
1127 
1128             // Use assembly to loop and emit the `Transfer` event for gas savings.
1129             assembly {
1130                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1131                 toMasked := and(to, _BITMASK_ADDRESS)
1132                 // Emit the `Transfer` event.
1133                 log4(
1134                     0, // Start of data (0, since no data).
1135                     0, // End of data (0, since no data).
1136                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1137                     0, // `address(0)`.
1138                     toMasked, // `to`.
1139                     startTokenId // `tokenId`.
1140                 )
1141 
1142                 for {
1143                     let tokenId := add(startTokenId, 1)
1144                 } iszero(eq(tokenId, end)) {
1145                     tokenId := add(tokenId, 1)
1146                 } {
1147                     // Emit the `Transfer` event. Similar to above.
1148                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1149                 }
1150             }
1151             if (toMasked == 0) revert MintToZeroAddress();
1152 
1153             _currentIndex = end;
1154         }
1155         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1156     }
1157 
1158     /**
1159      * @dev Mints `quantity` tokens and transfers them to `to`.
1160      *
1161      * This function is intended for efficient minting only during contract creation.
1162      *
1163      * It emits only one {ConsecutiveTransfer} as defined in
1164      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1165      * instead of a sequence of {Transfer} event(s).
1166      *
1167      * Calling this function outside of contract creation WILL make your contract
1168      * non-compliant with the ERC721 standard.
1169      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1170      * {ConsecutiveTransfer} event is only permissible during contract creation.
1171      *
1172      * Requirements:
1173      *
1174      * - `to` cannot be the zero address.
1175      * - `quantity` must be greater than 0.
1176      *
1177      * Emits a {ConsecutiveTransfer} event.
1178      */
1179     function _mintERC2309(address to, uint256 quantity) internal virtual {
1180         uint256 startTokenId = _currentIndex;
1181         if (to == address(0)) revert MintToZeroAddress();
1182         if (quantity == 0) revert MintZeroQuantity();
1183         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1184 
1185         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1186 
1187         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1188         unchecked {
1189             // Updates:
1190             // - `balance += quantity`.
1191             // - `numberMinted += quantity`.
1192             //
1193             // We can directly add to the `balance` and `numberMinted`.
1194             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1195 
1196             // Updates:
1197             // - `address` to the owner.
1198             // - `startTimestamp` to the timestamp of minting.
1199             // - `burned` to `false`.
1200             // - `nextInitialized` to `quantity == 1`.
1201             _packedOwnerships[startTokenId] = _packOwnershipData(
1202                 to,
1203                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1204             );
1205 
1206             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1207 
1208             _currentIndex = startTokenId + quantity;
1209         }
1210         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1211     }
1212 
1213     /**
1214      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1215      *
1216      * Requirements:
1217      *
1218      * - If `to` refers to a smart contract, it must implement
1219      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1220      * - `quantity` must be greater than 0.
1221      *
1222      * See {_mint}.
1223      *
1224      * Emits a {Transfer} event for each mint.
1225      */
1226     function _safeMint(
1227         address to,
1228         uint256 quantity,
1229         bytes memory _data
1230     ) internal virtual {
1231         _mint(to, quantity);
1232 
1233         unchecked {
1234             if (to.code.length != 0) {
1235                 uint256 end = _currentIndex;
1236                 uint256 index = end - quantity;
1237                 do {
1238                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1239                         revert TransferToNonERC721ReceiverImplementer();
1240                     }
1241                 } while (index < end);
1242                 // Reentrancy protection.
1243                 if (_currentIndex != end) revert();
1244             }
1245         }
1246     }
1247 
1248     /**
1249      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1250      */
1251     function _safeMint(address to, uint256 quantity) internal virtual {
1252         _safeMint(to, quantity, '');
1253     }
1254 
1255     // =============================================================
1256     //                        BURN OPERATIONS
1257     // =============================================================
1258 
1259     /**
1260      * @dev Equivalent to `_burn(tokenId, false)`.
1261      */
1262     function _burn(uint256 tokenId) internal virtual {
1263         _burn(tokenId, false);
1264     }
1265 
1266     /**
1267      * @dev Destroys `tokenId`.
1268      * The approval is cleared when the token is burned.
1269      *
1270      * Requirements:
1271      *
1272      * - `tokenId` must exist.
1273      *
1274      * Emits a {Transfer} event.
1275      */
1276     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1277         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1278 
1279         address from = address(uint160(prevOwnershipPacked));
1280 
1281         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1282 
1283         if (approvalCheck) {
1284             // The nested ifs save around 20+ gas over a compound boolean condition.
1285             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1286                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1287         }
1288 
1289         _beforeTokenTransfers(from, address(0), tokenId, 1);
1290 
1291         // Clear approvals from the previous owner.
1292         assembly {
1293             if approvedAddress {
1294                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1295                 sstore(approvedAddressSlot, 0)
1296             }
1297         }
1298 
1299         // Underflow of the sender's balance is impossible because we check for
1300         // ownership above and the recipient's balance can't realistically overflow.
1301         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1302         unchecked {
1303             // Updates:
1304             // - `balance -= 1`.
1305             // - `numberBurned += 1`.
1306             //
1307             // We can directly decrement the balance, and increment the number burned.
1308             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1309             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1310 
1311             // Updates:
1312             // - `address` to the last owner.
1313             // - `startTimestamp` to the timestamp of burning.
1314             // - `burned` to `true`.
1315             // - `nextInitialized` to `true`.
1316             _packedOwnerships[tokenId] = _packOwnershipData(
1317                 from,
1318                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1319             );
1320 
1321             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1322             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1323                 uint256 nextTokenId = tokenId + 1;
1324                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1325                 if (_packedOwnerships[nextTokenId] == 0) {
1326                     // If the next slot is within bounds.
1327                     if (nextTokenId != _currentIndex) {
1328                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1329                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1330                     }
1331                 }
1332             }
1333         }
1334 
1335         emit Transfer(from, address(0), tokenId);
1336         _afterTokenTransfers(from, address(0), tokenId, 1);
1337 
1338         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1339         unchecked {
1340             _burnCounter++;
1341         }
1342     }
1343 
1344     // =============================================================
1345     //                     EXTRA DATA OPERATIONS
1346     // =============================================================
1347 
1348     /**
1349      * @dev Directly sets the extra data for the ownership data `index`.
1350      */
1351     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1352         uint256 packed = _packedOwnerships[index];
1353         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1354         uint256 extraDataCasted;
1355         // Cast `extraData` with assembly to avoid redundant masking.
1356         assembly {
1357             extraDataCasted := extraData
1358         }
1359         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1360         _packedOwnerships[index] = packed;
1361     }
1362 
1363     /**
1364      * @dev Called during each token transfer to set the 24bit `extraData` field.
1365      * Intended to be overridden by the cosumer contract.
1366      *
1367      * `previousExtraData` - the value of `extraData` before transfer.
1368      *
1369      * Calling conditions:
1370      *
1371      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1372      * transferred to `to`.
1373      * - When `from` is zero, `tokenId` will be minted for `to`.
1374      * - When `to` is zero, `tokenId` will be burned by `from`.
1375      * - `from` and `to` are never both zero.
1376      */
1377     function _extraData(
1378         address from,
1379         address to,
1380         uint24 previousExtraData
1381     ) internal view virtual returns (uint24) {}
1382 
1383     /**
1384      * @dev Returns the next extra data for the packed ownership data.
1385      * The returned result is shifted into position.
1386      */
1387     function _nextExtraData(
1388         address from,
1389         address to,
1390         uint256 prevOwnershipPacked
1391     ) private view returns (uint256) {
1392         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1393         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1394     }
1395 
1396     // =============================================================
1397     //                       OTHER OPERATIONS
1398     // =============================================================
1399 
1400     /**
1401      * @dev Returns the message sender (defaults to `msg.sender`).
1402      *
1403      * If you are writing GSN compatible contracts, you need to override this function.
1404      */
1405     function _msgSenderERC721A() internal view virtual returns (address) {
1406         return msg.sender;
1407     }
1408 
1409     /**
1410      * @dev Converts a uint256 to its ASCII string decimal representation.
1411      */
1412     function _toString(uint256 value) internal pure virtual returns (string memory ptr) {
1413         assembly {
1414             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1415             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1416             // We will need 1 32-byte word to store the length,
1417             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1418             ptr := add(mload(0x40), 128)
1419             // Update the free memory pointer to allocate.
1420             mstore(0x40, ptr)
1421 
1422             // Cache the end of the memory to calculate the length later.
1423             let end := ptr
1424 
1425             // We write the string from the rightmost digit to the leftmost digit.
1426             // The following is essentially a do-while loop that also handles the zero case.
1427             // Costs a bit more than early returning for the zero case,
1428             // but cheaper in terms of deployment and overall runtime costs.
1429             for {
1430                 // Initialize and perform the first pass without check.
1431                 let temp := value
1432                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1433                 ptr := sub(ptr, 1)
1434                 // Write the character to the pointer.
1435                 // The ASCII index of the '0' character is 48.
1436                 mstore8(ptr, add(48, mod(temp, 10)))
1437                 temp := div(temp, 10)
1438             } temp {
1439                 // Keep dividing `temp` until zero.
1440                 temp := div(temp, 10)
1441             } {
1442                 // Body of the for loop.
1443                 ptr := sub(ptr, 1)
1444                 mstore8(ptr, add(48, mod(temp, 10)))
1445             }
1446 
1447             let length := sub(end, ptr)
1448             // Move the pointer 32 bytes leftwards to make room for the length.
1449             ptr := sub(ptr, 32)
1450             // Store the length.
1451             mstore(ptr, length)
1452         }
1453     }
1454 }
1455 
1456 // File: erc721a/contracts/extensions/IERC721AQueryable.sol
1457 
1458 
1459 // ERC721A Contracts v4.2.0
1460 // Creator: Chiru Labs
1461 
1462 pragma solidity ^0.8.4;
1463 
1464 
1465 /**
1466  * @dev Interface of ERC721AQueryable.
1467  */
1468 interface IERC721AQueryable is IERC721A {
1469     /**
1470      * Invalid query range (`start` >= `stop`).
1471      */
1472     error InvalidQueryRange();
1473 
1474     /**
1475      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1476      *
1477      * If the `tokenId` is out of bounds:
1478      *
1479      * - `addr = address(0)`
1480      * - `startTimestamp = 0`
1481      * - `burned = false`
1482      * - `extraData = 0`
1483      *
1484      * If the `tokenId` is burned:
1485      *
1486      * - `addr = <Address of owner before token was burned>`
1487      * - `startTimestamp = <Timestamp when token was burned>`
1488      * - `burned = true`
1489      * - `extraData = <Extra data when token was burned>`
1490      *
1491      * Otherwise:
1492      *
1493      * - `addr = <Address of owner>`
1494      * - `startTimestamp = <Timestamp of start of ownership>`
1495      * - `burned = false`
1496      * - `extraData = <Extra data at start of ownership>`
1497      */
1498     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
1499 
1500     /**
1501      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1502      * See {ERC721AQueryable-explicitOwnershipOf}
1503      */
1504     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
1505 
1506     /**
1507      * @dev Returns an array of token IDs owned by `owner`,
1508      * in the range [`start`, `stop`)
1509      * (i.e. `start <= tokenId < stop`).
1510      *
1511      * This function allows for tokens to be queried if the collection
1512      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1513      *
1514      * Requirements:
1515      *
1516      * - `start < stop`
1517      */
1518     function tokensOfOwnerIn(
1519         address owner,
1520         uint256 start,
1521         uint256 stop
1522     ) external view returns (uint256[] memory);
1523 
1524     /**
1525      * @dev Returns an array of token IDs owned by `owner`.
1526      *
1527      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
1528      * It is meant to be called off-chain.
1529      *
1530      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1531      * multiple smaller scans if the collection is large enough to cause
1532      * an out-of-gas error (10K collections should be fine).
1533      */
1534     function tokensOfOwner(address owner) external view returns (uint256[] memory);
1535 }
1536 
1537 // File: erc721a/contracts/extensions/ERC721AQueryable.sol
1538 
1539 
1540 // ERC721A Contracts v4.2.0
1541 // Creator: Chiru Labs
1542 
1543 pragma solidity ^0.8.4;
1544 
1545 
1546 
1547 /**
1548  * @title ERC721AQueryable.
1549  *
1550  * @dev ERC721A subclass with convenience query functions.
1551  */
1552 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1553     /**
1554      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1555      *
1556      * If the `tokenId` is out of bounds:
1557      *
1558      * - `addr = address(0)`
1559      * - `startTimestamp = 0`
1560      * - `burned = false`
1561      * - `extraData = 0`
1562      *
1563      * If the `tokenId` is burned:
1564      *
1565      * - `addr = <Address of owner before token was burned>`
1566      * - `startTimestamp = <Timestamp when token was burned>`
1567      * - `burned = true`
1568      * - `extraData = <Extra data when token was burned>`
1569      *
1570      * Otherwise:
1571      *
1572      * - `addr = <Address of owner>`
1573      * - `startTimestamp = <Timestamp of start of ownership>`
1574      * - `burned = false`
1575      * - `extraData = <Extra data at start of ownership>`
1576      */
1577     function explicitOwnershipOf(uint256 tokenId) public view virtual override returns (TokenOwnership memory) {
1578         TokenOwnership memory ownership;
1579         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1580             return ownership;
1581         }
1582         ownership = _ownershipAt(tokenId);
1583         if (ownership.burned) {
1584             return ownership;
1585         }
1586         return _ownershipOf(tokenId);
1587     }
1588 
1589     /**
1590      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1591      * See {ERC721AQueryable-explicitOwnershipOf}
1592      */
1593     function explicitOwnershipsOf(uint256[] calldata tokenIds)
1594         external
1595         view
1596         virtual
1597         override
1598         returns (TokenOwnership[] memory)
1599     {
1600         unchecked {
1601             uint256 tokenIdsLength = tokenIds.length;
1602             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1603             for (uint256 i; i != tokenIdsLength; ++i) {
1604                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1605             }
1606             return ownerships;
1607         }
1608     }
1609 
1610     /**
1611      * @dev Returns an array of token IDs owned by `owner`,
1612      * in the range [`start`, `stop`)
1613      * (i.e. `start <= tokenId < stop`).
1614      *
1615      * This function allows for tokens to be queried if the collection
1616      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1617      *
1618      * Requirements:
1619      *
1620      * - `start < stop`
1621      */
1622     function tokensOfOwnerIn(
1623         address owner,
1624         uint256 start,
1625         uint256 stop
1626     ) external view virtual override returns (uint256[] memory) {
1627         unchecked {
1628             if (start >= stop) revert InvalidQueryRange();
1629             uint256 tokenIdsIdx;
1630             uint256 stopLimit = _nextTokenId();
1631             // Set `start = max(start, _startTokenId())`.
1632             if (start < _startTokenId()) {
1633                 start = _startTokenId();
1634             }
1635             // Set `stop = min(stop, stopLimit)`.
1636             if (stop > stopLimit) {
1637                 stop = stopLimit;
1638             }
1639             uint256 tokenIdsMaxLength = balanceOf(owner);
1640             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1641             // to cater for cases where `balanceOf(owner)` is too big.
1642             if (start < stop) {
1643                 uint256 rangeLength = stop - start;
1644                 if (rangeLength < tokenIdsMaxLength) {
1645                     tokenIdsMaxLength = rangeLength;
1646                 }
1647             } else {
1648                 tokenIdsMaxLength = 0;
1649             }
1650             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1651             if (tokenIdsMaxLength == 0) {
1652                 return tokenIds;
1653             }
1654             // We need to call `explicitOwnershipOf(start)`,
1655             // because the slot at `start` may not be initialized.
1656             TokenOwnership memory ownership = explicitOwnershipOf(start);
1657             address currOwnershipAddr;
1658             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1659             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1660             if (!ownership.burned) {
1661                 currOwnershipAddr = ownership.addr;
1662             }
1663             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1664                 ownership = _ownershipAt(i);
1665                 if (ownership.burned) {
1666                     continue;
1667                 }
1668                 if (ownership.addr != address(0)) {
1669                     currOwnershipAddr = ownership.addr;
1670                 }
1671                 if (currOwnershipAddr == owner) {
1672                     tokenIds[tokenIdsIdx++] = i;
1673                 }
1674             }
1675             // Downsize the array to fit.
1676             assembly {
1677                 mstore(tokenIds, tokenIdsIdx)
1678             }
1679             return tokenIds;
1680         }
1681     }
1682 
1683     /**
1684      * @dev Returns an array of token IDs owned by `owner`.
1685      *
1686      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
1687      * It is meant to be called off-chain.
1688      *
1689      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1690      * multiple smaller scans if the collection is large enough to cause
1691      * an out-of-gas error (10K collections should be fine).
1692      */
1693     function tokensOfOwner(address owner) external view virtual override returns (uint256[] memory) {
1694         unchecked {
1695             uint256 tokenIdsIdx;
1696             address currOwnershipAddr;
1697             uint256 tokenIdsLength = balanceOf(owner);
1698             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1699             TokenOwnership memory ownership;
1700             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1701                 ownership = _ownershipAt(i);
1702                 if (ownership.burned) {
1703                     continue;
1704                 }
1705                 if (ownership.addr != address(0)) {
1706                     currOwnershipAddr = ownership.addr;
1707                 }
1708                 if (currOwnershipAddr == owner) {
1709                     tokenIds[tokenIdsIdx++] = i;
1710                 }
1711             }
1712             return tokenIds;
1713         }
1714     }
1715 }
1716 
1717 // File: default_workspace/contracts/ERC4907AQueryable.sol
1718 
1719 
1720 // ERC721A Contracts v4.2.0
1721 // Creator: Chiru Labs
1722 
1723 pragma solidity ^0.8.4;
1724 
1725 
1726 
1727 /**
1728  * @title ERC4907A
1729  *
1730  * @dev [ERC4907](https://eips.ethereum.org/EIPS/eip-4907) compliant
1731  * extension of ERC721A, which allows owners and authorized addresses
1732  * to add a time-limited role with restricted permissions to ERC721 tokens.
1733  */
1734 abstract contract ERC4907AQueryable is ERC721AQueryable, IERC4907A {
1735     // The bit position of `expires` in packed user info.
1736     uint256 private constant _BITPOS_EXPIRES = 160;
1737 
1738     // Mapping from token ID to user info.
1739     //
1740     // Bits Layout:
1741     // - [0..159]   `user`
1742     // - [160..223] `expires`
1743     mapping(uint256 => uint256) private _packedUserInfo;
1744 
1745     /**
1746      * @dev Sets the `user` and `expires` for `tokenId`.
1747      * The zero address indicates there is no user.
1748      *
1749      * Requirements:
1750      *
1751      * - The caller must own `tokenId` or be an approved operator.
1752      */
1753     function setUser(
1754         uint256 tokenId,
1755         address user,
1756         uint64 expires
1757     ) public virtual {
1758         // Require the caller to be either the token owner or an approved operator.
1759         address owner = ownerOf(tokenId);
1760         if (_msgSenderERC721A() != owner)
1761             if (!isApprovedForAll(owner, _msgSenderERC721A()))
1762                 if (getApproved(tokenId) != _msgSenderERC721A()) revert SetUserCallerNotOwnerNorApproved();
1763 
1764         _packedUserInfo[tokenId] = (uint256(expires) << _BITPOS_EXPIRES) | uint256(uint160(user));
1765 
1766         emit UpdateUser(tokenId, user, expires);
1767     }
1768 
1769     /**
1770      * @dev Returns the user address for `tokenId`.
1771      * The zero address indicates that there is no user or if the user is expired.
1772      */
1773     function userOf(uint256 tokenId) public view virtual returns (address) {
1774         uint256 packed = _packedUserInfo[tokenId];
1775         assembly {
1776             // Branchless `packed *= (block.timestamp <= expires ? 1 : 0)`.
1777             // If the `block.timestamp == expires`, the `lt` clause will be true
1778             // if there is a non-zero user address in the lower 160 bits of `packed`.
1779             packed := mul(
1780                 packed,
1781                 // `block.timestamp <= expires ? 1 : 0`.
1782                 lt(shl(_BITPOS_EXPIRES, timestamp()), packed)
1783             )
1784         }
1785         return address(uint160(packed));
1786     }
1787 
1788     /**
1789      * @dev Returns the user's expires of `tokenId`.
1790      */
1791     function userExpires(uint256 tokenId) public view virtual returns (uint256) {
1792         return _packedUserInfo[tokenId] >> _BITPOS_EXPIRES;
1793     }
1794 
1795     /**
1796      * @dev Override of {IERC165-supportsInterface}.
1797      */
1798     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721A, IERC721A) returns (bool) {
1799         // The interface ID for ERC4907 is `0xad092b5c`,
1800         // as defined in [ERC4907](https://eips.ethereum.org/EIPS/eip-4907).
1801         return super.supportsInterface(interfaceId) || interfaceId == 0xad092b5c;
1802     }
1803 
1804     /**
1805      * @dev Returns the user address for `tokenId`, ignoring the expiry status.
1806      */
1807     function _explicitUserOf(uint256 tokenId) internal view virtual returns (address) {
1808         return address(uint160(_packedUserInfo[tokenId]));
1809     }
1810 }
1811 
1812 // File: @openzeppelin/contracts/utils/Context.sol
1813 
1814 
1815 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1816 
1817 pragma solidity ^0.8.0;
1818 
1819 /**
1820  * @dev Provides information about the current execution context, including the
1821  * sender of the transaction and its data. While these are generally available
1822  * via msg.sender and msg.data, they should not be accessed in such a direct
1823  * manner, since when dealing with meta-transactions the account sending and
1824  * paying for execution may not be the actual sender (as far as an application
1825  * is concerned).
1826  *
1827  * This contract is only required for intermediate, library-like contracts.
1828  */
1829 abstract contract Context {
1830     function _msgSender() internal view virtual returns (address) {
1831         return msg.sender;
1832     }
1833 
1834     function _msgData() internal view virtual returns (bytes calldata) {
1835         return msg.data;
1836     }
1837 }
1838 
1839 // File: @openzeppelin/contracts/access/Ownable.sol
1840 
1841 
1842 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1843 
1844 pragma solidity ^0.8.0;
1845 
1846 
1847 /**
1848  * @dev Contract module which provides a basic access control mechanism, where
1849  * there is an account (an owner) that can be granted exclusive access to
1850  * specific functions.
1851  *
1852  * By default, the owner account will be the one that deploys the contract. This
1853  * can later be changed with {transferOwnership}.
1854  *
1855  * This module is used through inheritance. It will make available the modifier
1856  * `onlyOwner`, which can be applied to your functions to restrict their use to
1857  * the owner.
1858  */
1859 abstract contract Ownable is Context {
1860     address private _owner;
1861 
1862     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1863 
1864     /**
1865      * @dev Initializes the contract setting the deployer as the initial owner.
1866      */
1867     constructor() {
1868         _transferOwnership(_msgSender());
1869     }
1870 
1871     /**
1872      * @dev Returns the address of the current owner.
1873      */
1874     function owner() public view virtual returns (address) {
1875         return _owner;
1876     }
1877 
1878     /**
1879      * @dev Throws if called by any account other than the owner.
1880      */
1881     modifier onlyOwner() {
1882         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1883         _;
1884     }
1885 
1886     /**
1887      * @dev Leaves the contract without owner. It will not be possible to call
1888      * `onlyOwner` functions anymore. Can only be called by the current owner.
1889      *
1890      * NOTE: Renouncing ownership will leave the contract without an owner,
1891      * thereby removing any functionality that is only available to the owner.
1892      */
1893     function renounceOwnership() public virtual onlyOwner {
1894         _transferOwnership(address(0));
1895     }
1896 
1897     /**
1898      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1899      * Can only be called by the current owner.
1900      */
1901     function transferOwnership(address newOwner) public virtual onlyOwner {
1902         require(newOwner != address(0), "Ownable: new owner is the zero address");
1903         _transferOwnership(newOwner);
1904     }
1905 
1906     /**
1907      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1908      * Internal function without access restriction.
1909      */
1910     function _transferOwnership(address newOwner) internal virtual {
1911         address oldOwner = _owner;
1912         _owner = newOwner;
1913         emit OwnershipTransferred(oldOwner, newOwner);
1914     }
1915 }
1916 
1917 // File: default_workspace/contracts/GenerativeAvatars.sol
1918 
1919 
1920 
1921 pragma solidity ^0.8.12;
1922 
1923 //import "erc721a/contracts/extensions/ERC721AQueryable.sol";
1924 
1925 
1926 //import "./DungeonStaking/IDungeonRewards.sol";
1927 
1928 /*
1929 
1930  ________  _______   ________   _______   ________  ________  _________  ___  ___      ___ _______      
1931 |\   ____\|\  ___ \ |\   ___  \|\  ___ \ |\   __  \|\   __  \|\___   ___\\  \|\  \    /  /|\  ___ \     
1932 \ \  \___|\ \   __/|\ \  \\ \  \ \   __/|\ \  \|\  \ \  \|\  \|___ \  \_\ \  \ \  \  /  / | \   __/|    
1933  \ \  \  __\ \  \_|/_\ \  \\ \  \ \  \_|/_\ \   _  _\ \   __  \   \ \  \ \ \  \ \  \/  / / \ \  \_|/__  
1934   \ \  \|\  \ \  \_|\ \ \  \\ \  \ \  \_|\ \ \  \\  \\ \  \ \  \   \ \  \ \ \  \ \    / /   \ \  \_|\ \ 
1935    \ \_______\ \_______\ \__\\ \__\ \_______\ \__\\ _\\ \__\ \__\   \ \__\ \ \__\ \__/ /     \ \_______\
1936     \|_______|\|_______|\|__| \|__|\|_______|\|__|\|__|\|__|\|__|    \|__|  \|__|\|__|/       \|_______|
1937                                                                                                         
1938                                                                                                         
1939                                                                                                         
1940  ________  ___      ___ ________  _________  ________  ________  ________                               
1941 |\   __  \|\  \    /  /|\   __  \|\___   ___\\   __  \|\   __  \|\   ____\                              
1942 \ \  \|\  \ \  \  /  / | \  \|\  \|___ \  \_\ \  \|\  \ \  \|\  \ \  \___|_                             
1943  \ \   __  \ \  \/  / / \ \   __  \   \ \  \ \ \   __  \ \   _  _\ \_____  \                            
1944   \ \  \ \  \ \    / /   \ \  \ \  \   \ \  \ \ \  \ \  \ \  \\  \\|____|\  \                           
1945    \ \__\ \__\ \__/ /     \ \__\ \__\   \ \__\ \ \__\ \__\ \__\\ _\ ____\_\  \                          
1946     \|__|\|__|\|__|/       \|__|\|__|    \|__|  \|__|\|__|\|__|\|__|\_________\                         
1947                                                                    \|_________|                         
1948                                                                                                         
1949 */
1950 
1951 contract GenerativeAvatars is ERC4907AQueryable, Ownable {
1952 
1953     IDungeonRewards public dungeonRewardsContract;
1954 
1955     string public BASE_METADATA_URI = "";
1956 
1957     // max number of NFTs to batch mint at the same time
1958     uint256 MINT_BATCH_SIZE=10;
1959 
1960     uint256 public MAX_FREE_NFTS_PLUS_1=3001;
1961     uint256 public MAX_NONFREE_NFTS_PLUS_1=3001;
1962 
1963     // stored as seconds --> 1209600
1964     uint256 public MIN_STAKING_PERIOD = 4 days; // 4 days min initial staking period to qualify for free avatar mint
1965 
1966     uint256 public PRICE_WHITELIST = 0.05 ether;
1967     uint256 public PRICE_PUBLIC = 0.07 ether;
1968 
1969     uint256 public QUANTITY_LIMIT_WHITELIST_PLUS_1 = 2; // max 1 per whitelist
1970     uint256 public QUANTITY_LIMIT_PUBLIC_PLUS_1 = 6; // max 5 for each public mint transaction
1971 
1972     /**
1973       * store whether a dungeon has already used up its free mint
1974       */
1975     mapping(uint256 => bool) public dungeonFreeMints;
1976     /**
1977       * store the last time someone claimed a free mint (used to limit free mint claims to min staking period)
1978       */    
1979     mapping(address => uint256) public lastFreeMint;
1980 
1981     bool private locked; // for re-entrancy guard
1982 
1983     uint256 totalNonFree=0;
1984     uint256 totalFree=0;
1985 
1986     bool public publicSaleActive = false;
1987     bool public whitelistSaleActive = false; 
1988     bool public freeMintActive = false; 
1989 
1990     constructor(address _dungeonRewardsContract) ERC721A("Generative Avatars", "GAVA") {
1991         dungeonRewardsContract = IDungeonRewards(_dungeonRewardsContract);
1992     }
1993 
1994     modifier callerIsUser() {
1995         require(tx.origin == msg.sender, "Cannot be called by a contract");
1996         _;
1997     }
1998 
1999     modifier dungeonsStaked() {
2000         uint256 firstStakeDate = dungeonRewardsContract.dungeonFirstStaked(msg.sender);
2001         require(firstStakeDate!=0, "No dungeons staked");
2002         require(block.timestamp - firstStakeDate > MIN_STAKING_PERIOD && 
2003                 block.timestamp - lastFreeMint[msg.sender] > MIN_STAKING_PERIOD, 
2004                         "Dungeons have not been staked long enough to qualify. If you have just minted, you must wait MIN_STAKING_PERIOD before trying again.");
2005         _;
2006     }
2007 
2008     // from openzeppelin-contracts/contracts/security/ReentrancyGuard.sol
2009     modifier nonReentrant() {
2010         require(!locked, "Reentrant call");
2011         locked = true;
2012         _;
2013         locked = false;
2014     }
2015 
2016     // for whitelisted mint 
2017 	modifier onlyWhitelisted(uint8 _v,
2018                     		bytes32 _r,
2019 		                    bytes32 _s
2020 	) {
2021 		require (owner() == ecrecover(
2022 				keccak256( abi.encodePacked('\x19Ethereum Signed Message:\n32', 
2023                                             keccak256( abi.encodePacked(address(this), msg.sender)))), 
2024                                     _v, _r, _s), 
2025                 'Not whitelisted');
2026 		_;
2027 	}
2028 
2029     function _baseURI() internal view virtual override returns (string memory) {
2030         return BASE_METADATA_URI;
2031     }
2032 
2033     function setBaseURI(string memory _baseMetaDataURI) public onlyOwner {
2034         BASE_METADATA_URI = _baseMetaDataURI;
2035     }
2036 
2037     /*
2038     * Pause public sale if active, make active if paused
2039     */
2040     function flipPublicSaleActive() public onlyOwner {
2041         publicSaleActive = !publicSaleActive;
2042     }
2043     function flipWhitelistSaleActive() public onlyOwner {
2044         whitelistSaleActive = !whitelistSaleActive;
2045     }
2046     function flipFreeMintActive() public onlyOwner {
2047         freeMintActive = !freeMintActive;
2048     }
2049 
2050     // in case we want to tweak (though mostly for testing)
2051     function setMinStakingPeriod(uint _minStakingPeriod) public onlyOwner {
2052         MIN_STAKING_PERIOD = _minStakingPeriod;
2053     }
2054     function setMaxFreeNfts(uint _maxFreeNfts) public onlyOwner {
2055         MAX_FREE_NFTS_PLUS_1 = _maxFreeNfts;
2056     }
2057     function setMaxNonFreeNfts(uint _maxNonFreeNfts) public onlyOwner {
2058         MAX_NONFREE_NFTS_PLUS_1 = _maxNonFreeNfts;
2059     }
2060 
2061     /*
2062     * in case Eth is volatile
2063     */
2064     function setPricePublic(uint256 _newPrice) public onlyOwner() {
2065         PRICE_PUBLIC = _newPrice;
2066     }
2067     /*
2068     * in case Eth is volatile
2069     */
2070     function setPriceWhitelist(uint256 _newPrice) public onlyOwner() {
2071         PRICE_WHITELIST = _newPrice;
2072     }
2073     /*
2074      * in case we need to adjust the wallet limit 
2075      */
2076     function setPublicQuantityLimit(uint256 _newLimit) public onlyOwner() {
2077         QUANTITY_LIMIT_PUBLIC_PLUS_1 = _newLimit;
2078     }
2079     /*
2080      * in case we need to adjust the wallet limit 
2081      */
2082     function setWhitelistQuantityLimit(uint256 _newLimit) public onlyOwner() {
2083         QUANTITY_LIMIT_WHITELIST_PLUS_1 = _newLimit;
2084     }
2085 
2086     /*
2087      * airdrops ignore wallet and per transaction limits
2088      */
2089     function airDrop(address _addr, uint256 _quantity) public onlyOwner {
2090         uint256 supply = totalSupply(); // store to save gas
2091         require(supply + _quantity < (MAX_NONFREE_NFTS_PLUS_1), "Exceeds max non-free NFT supply"); //use < rather than <= to save gas
2092 
2093         uint batchCount = _quantity / MINT_BATCH_SIZE;
2094         uint remainder = _quantity % MINT_BATCH_SIZE;
2095 
2096         for (uint i; i < batchCount; ++i) {
2097             _mint(_addr, MINT_BATCH_SIZE);
2098         }
2099         if (remainder > 0) {
2100             _mint(_addr, remainder);
2101         }
2102 
2103         totalNonFree+=_quantity;
2104     }
2105 
2106     function withdraw() external onlyOwner nonReentrant {
2107         (bool success, ) = msg.sender.call{value: address(this).balance}("");
2108         require(success, "Transfer failed.");
2109     }
2110 
2111     /**
2112       * check if your wallet qualifies for a free mint
2113       */
2114     function checkQualifyForFreeMint() public view returns (string memory)
2115     {
2116         uint256 firstStakeDate = dungeonRewardsContract.dungeonFirstStaked(msg.sender);
2117         if (firstStakeDate!=0 && block.timestamp - firstStakeDate > MIN_STAKING_PERIOD &&
2118             block.timestamp - lastFreeMint[msg.sender] > MIN_STAKING_PERIOD) {
2119             return "Your wallet qualifies for a free mint.";
2120         }
2121         else {
2122             return string.concat(string.concat(string.concat("You don't qualify for a free mint. Dungeon first staked: ", _toString(firstStakeDate)),","),
2123             _toString(lastFreeMint[msg.sender]));
2124         }
2125     }
2126 
2127     function _startTokenId() internal override view virtual returns (uint256) {
2128         return 1; // start at 1
2129     }
2130 
2131     /**
2132       * return the number of free mints
2133       */
2134     function checkFreeMints() public view returns (uint256)
2135     {
2136         (uint256[] memory dungeons, uint256[] memory avatars, uint256[] memory quests) = 
2137                                     dungeonRewardsContract.getStakedTokens(msg.sender); 
2138 
2139         uint256 quantity = 0;
2140         for (uint256 i=0; i < dungeons.length; i++) {
2141             if (!dungeonFreeMints[dungeons[i]]) { // haven't already used up the free mint for this dungeon?
2142                 quantity++;
2143             }
2144         }
2145         return quantity;
2146     }
2147 
2148     /**
2149       * free mint routine
2150       */
2151     function mintFree() external callerIsUser dungeonsStaked nonReentrant {
2152         require(freeMintActive, "Free mint paused");
2153 
2154         (uint256[] memory dungeons, uint256[] memory avatars, uint256[] memory quests) = 
2155                                     dungeonRewardsContract.getStakedTokens(msg.sender); 
2156 
2157         require (dungeons.length > 0, "You have no dungeons staked"); // not entirely necessary because of dungeonsStaked modifier, but leaving in as a sanity check
2158 
2159         uint256[] memory finalList = new uint256[](dungeons.length);
2160         uint256 quantity = 0;
2161         for (uint256 i=0; i < dungeons.length; i++) {
2162             if (!dungeonFreeMints[dungeons[i]]) { // haven't already used up the free mint for this dungeon?
2163                 finalList[quantity++] = dungeons[i];
2164             }
2165         }
2166 
2167         require(quantity > 0, "You have used up all your free mints for the staked dungeons");
2168         require(totalFree + quantity < MAX_FREE_NFTS_PLUS_1, "Exceeds max free NFT supply"); // shouldn't need, but keeping as a sanity check
2169 
2170         // mint in batches so that transfers don't ever require more than 10 lookups to determine 
2171         // token ownership in the future (erc721a is cheap on mints, but not so cheap on transfers, which is why we do this to lower the cost of transfers)
2172         uint batchCount = quantity / MINT_BATCH_SIZE;
2173         uint remainder = quantity % MINT_BATCH_SIZE;
2174 
2175         for (uint i; i < batchCount; ++i) {
2176             _mint(msg.sender, MINT_BATCH_SIZE);
2177         }
2178         if (remainder > 0) {
2179             _mint(msg.sender, remainder);
2180         }
2181 
2182         for (uint i=0; i < quantity; i++) {
2183             dungeonFreeMints[finalList[i]]=true;  // mark these dungeon free mints as used
2184         }
2185         totalFree+=quantity;
2186         
2187         lastFreeMint[msg.sender] = block.timestamp;
2188     }
2189 
2190     /**
2191     * allows whitelisted addresses to mint NFTs
2192     */
2193     function mintWhitelist(uint256 _numberOfTokens, 
2194                             uint8 _v,
2195                     		bytes32 _r,
2196 		                    bytes32 _s) public payable callerIsUser nonReentrant onlyWhitelisted(_v, _r, _s) {
2197         require(whitelistSaleActive, "Whitelist sale paused");
2198         require(_getAux(msg.sender)==0, "Already claimed whitelist spot");
2199 
2200         // we hold the whitelist data off-chain and verify on-chain via onlyWhilelisted; 
2201         // still have to check against max nft supply in case people whitelist late
2202         require(totalNonFree + _numberOfTokens < MAX_NONFREE_NFTS_PLUS_1, "Exceeds max non-free NFT supply"); //use < rather than <= to save gas
2203         require(msg.value >= PRICE_WHITELIST * _numberOfTokens, "Ether sent is not correct");
2204         require(_numberOfTokens < QUANTITY_LIMIT_WHITELIST_PLUS_1, "Requested too many tokens");
2205 
2206         _mint(msg.sender, _numberOfTokens);
2207 
2208         totalNonFree+=_numberOfTokens;
2209 
2210         _setAux(msg.sender, 1); // they claimed their whitelist spot
2211     }
2212 
2213 
2214     /**
2215     * Mints NFTs
2216     */
2217     function mintPublic(uint256 _numberOfTokens) public payable callerIsUser nonReentrant {
2218         require(publicSaleActive, "Public sale paused");
2219         require(totalNonFree + _numberOfTokens < MAX_NONFREE_NFTS_PLUS_1, "Exceeds max non-free NFT supply"); //use < rather than <= to save gas
2220         require(msg.value >= PRICE_PUBLIC * _numberOfTokens, "Ether sent is not correct");
2221         require(_numberOfTokens < QUANTITY_LIMIT_PUBLIC_PLUS_1, "Requested too many tokens");
2222 
2223         _mint(msg.sender, _numberOfTokens);
2224         totalNonFree+=_numberOfTokens;
2225     }
2226 
2227 }