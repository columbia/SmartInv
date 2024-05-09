1 //   
2 //    ███▄    █  ▄▄▄       ███▄    █   ▄████  ▒█████      ██░ ██ ▓█████  ███▄    █ ▄▄▄█████▓ ▄▄▄       ██▓
3 //    ██ ▀█   █ ▒████▄     ██ ▀█   █  ██▒ ▀█▒▒██▒  ██▒   ▓██░ ██▒▓█   ▀  ██ ▀█   █ ▓  ██▒ ▓▒▒████▄    ▓██▒
4 //   ▓██  ▀█ ██▒▒██  ▀█▄  ▓██  ▀█ ██▒▒██░▄▄▄░▒██░  ██▒   ▒██▀▀██░▒███   ▓██  ▀█ ██▒▒ ▓██░ ▒░▒██  ▀█▄  ▒██▒
5 //   ▓██▒  ▐▌██▒░██▄▄▄▄██ ▓██▒  ▐▌██▒░▓█  ██▓▒██   ██░   ░▓█ ░██ ▒▓█  ▄ ▓██▒  ▐▌██▒░ ▓██▓ ░ ░██▄▄▄▄██ ░██░
6 //   ▒██░   ▓██░ ▓█   ▓██▒▒██░   ▓██░░▒▓███▀▒░ ████▓▒░   ░▓█▒░██▓░▒████▒▒██░   ▓██░  ▒██▒ ░  ▓█   ▓██▒░██░
7 //   ░ ▒░   ▒ ▒  ▒▒   ▓▒█░░ ▒░   ▒ ▒  ░▒   ▒ ░ ▒░▒░▒░     ▒ ░░▒░▒░░ ▒░ ░░ ▒░   ▒ ▒   ▒ ░░    ▒▒   ▓▒█░░▓  
8 //   ░ ░░   ░ ▒░  ▒   ▒▒ ░░ ░░   ░ ▒░  ░   ░   ░ ▒ ▒░     ▒ ░▒░ ░ ░ ░  ░░ ░░   ░ ▒░    ░      ▒   ▒▒ ░ ▒ ░
9 //      ░   ░ ░   ░   ▒      ░   ░ ░ ░ ░   ░ ░ ░ ░ ▒      ░  ░░ ░   ░      ░   ░ ░   ░        ░   ▒    ▒ ░
10 //            ░       ░  ░         ░       ░     ░ ░      ░  ░  ░   ░  ░         ░                ░  ░ ░  
11 //                                                                                                        
12 //   NANGO HENTAI...
13 
14 //SPDX-License-Identifier: MIT
15 
16 // File: erc721a/contracts/IERC721A.sol
17 
18 
19 // ERC721A Contracts v4.2.2
20 // Creator: Chiru Labs
21 
22 pragma solidity ^0.8.4;
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
39      * The caller cannot approve to their own address.
40      */
41     error ApproveToCaller();
42 
43     /**
44      * Cannot query the balance for the zero address.
45      */
46     error BalanceQueryForZeroAddress();
47 
48     /**
49      * Cannot mint to the zero address.
50      */
51     error MintToZeroAddress();
52 
53     /**
54      * The quantity of tokens minted must be more than zero.
55      */
56     error MintZeroQuantity();
57 
58     /**
59      * The token does not exist.
60      */
61     error OwnerQueryForNonexistentToken();
62 
63     /**
64      * The caller must own the token or be an approved operator.
65      */
66     error TransferCallerNotOwnerNorApproved();
67 
68     /**
69      * The token must be owned by `from`.
70      */
71     error TransferFromIncorrectOwner();
72 
73     /**
74      * Cannot safely transfer to a contract that does not implement the
75      * ERC721Receiver interface.
76      */
77     error TransferToNonERC721ReceiverImplementer();
78 
79     /**
80      * Cannot transfer to the zero address.
81      */
82     error TransferToZeroAddress();
83 
84     /**
85      * The token does not exist.
86      */
87     error URIQueryForNonexistentToken();
88 
89     /**
90      * The `quantity` minted with ERC2309 exceeds the safety limit.
91      */
92     error MintERC2309QuantityExceedsLimit();
93 
94     /**
95      * The `extraData` cannot be set on an unintialized ownership slot.
96      */
97     error OwnershipNotInitializedForExtraData();
98 
99     // =============================================================
100     //                            STRUCTS
101     // =============================================================
102 
103     struct TokenOwnership {
104         // The address of the owner.
105         address addr;
106         // Stores the start time of ownership with minimal overhead for tokenomics.
107         uint64 startTimestamp;
108         // Whether the token has been burned.
109         bool burned;
110         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
111         uint24 extraData;
112     }
113 
114     // =============================================================
115     //                         TOKEN COUNTERS
116     // =============================================================
117 
118     /**
119      * @dev Returns the total number of tokens in existence.
120      * Burned tokens will reduce the count.
121      * To get the total number of tokens minted, please see {_totalMinted}.
122      */
123     function totalSupply() external view returns (uint256);
124 
125     // =============================================================
126     //                            IERC165
127     // =============================================================
128 
129     /**
130      * @dev Returns true if this contract implements the interface defined by
131      * `interfaceId`. See the corresponding
132      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
133      * to learn more about how these ids are created.
134      *
135      * This function call must use less than 30000 gas.
136      */
137     function supportsInterface(bytes4 interfaceId) external view returns (bool);
138 
139     // =============================================================
140     //                            IERC721
141     // =============================================================
142 
143     /**
144      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
145      */
146     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
147 
148     /**
149      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
150      */
151     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
152 
153     /**
154      * @dev Emitted when `owner` enables or disables
155      * (`approved`) `operator` to manage all of its assets.
156      */
157     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
158 
159     /**
160      * @dev Returns the number of tokens in `owner`'s account.
161      */
162     function balanceOf(address owner) external view returns (uint256 balance);
163 
164     /**
165      * @dev Returns the owner of the `tokenId` token.
166      *
167      * Requirements:
168      *
169      * - `tokenId` must exist.
170      */
171     function ownerOf(uint256 tokenId) external view returns (address owner);
172 
173     /**
174      * @dev Safely transfers `tokenId` token from `from` to `to`,
175      * checking first that contract recipients are aware of the ERC721 protocol
176      * to prevent tokens from being forever locked.
177      *
178      * Requirements:
179      *
180      * - `from` cannot be the zero address.
181      * - `to` cannot be the zero address.
182      * - `tokenId` token must exist and be owned by `from`.
183      * - If the caller is not `from`, it must be have been allowed to move
184      * this token by either {approve} or {setApprovalForAll}.
185      * - If `to` refers to a smart contract, it must implement
186      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
187      *
188      * Emits a {Transfer} event.
189      */
190     function safeTransferFrom(
191         address from,
192         address to,
193         uint256 tokenId,
194         bytes calldata data
195     ) external;
196 
197     /**
198      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
199      */
200     function safeTransferFrom(
201         address from,
202         address to,
203         uint256 tokenId
204     ) external;
205 
206     /**
207      * @dev Transfers `tokenId` from `from` to `to`.
208      *
209      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
210      * whenever possible.
211      *
212      * Requirements:
213      *
214      * - `from` cannot be the zero address.
215      * - `to` cannot be the zero address.
216      * - `tokenId` token must be owned by `from`.
217      * - If the caller is not `from`, it must be approved to move this token
218      * by either {approve} or {setApprovalForAll}.
219      *
220      * Emits a {Transfer} event.
221      */
222     function transferFrom(
223         address from,
224         address to,
225         uint256 tokenId
226     ) external;
227 
228     /**
229      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
230      * The approval is cleared when the token is transferred.
231      *
232      * Only a single account can be approved at a time, so approving the
233      * zero address clears previous approvals.
234      *
235      * Requirements:
236      *
237      * - The caller must own the token or be an approved operator.
238      * - `tokenId` must exist.
239      *
240      * Emits an {Approval} event.
241      */
242     function approve(address to, uint256 tokenId) external;
243 
244     /**
245      * @dev Approve or remove `operator` as an operator for the caller.
246      * Operators can call {transferFrom} or {safeTransferFrom}
247      * for any token owned by the caller.
248      *
249      * Requirements:
250      *
251      * - The `operator` cannot be the caller.
252      *
253      * Emits an {ApprovalForAll} event.
254      */
255     function setApprovalForAll(address operator, bool _approved) external;
256 
257     /**
258      * @dev Returns the account approved for `tokenId` token.
259      *
260      * Requirements:
261      *
262      * - `tokenId` must exist.
263      */
264     function getApproved(uint256 tokenId) external view returns (address operator);
265 
266     /**
267      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
268      *
269      * See {setApprovalForAll}.
270      */
271     function isApprovedForAll(address owner, address operator) external view returns (bool);
272 
273     // =============================================================
274     //                        IERC721Metadata
275     // =============================================================
276 
277     /**
278      * @dev Returns the token collection name.
279      */
280     function name() external view returns (string memory);
281 
282     /**
283      * @dev Returns the token collection symbol.
284      */
285     function symbol() external view returns (string memory);
286 
287     /**
288      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
289      */
290     function tokenURI(uint256 tokenId) external view returns (string memory);
291 
292     // =============================================================
293     //                           IERC2309
294     // =============================================================
295 
296     /**
297      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
298      * (inclusive) is transferred from `from` to `to`, as defined in the
299      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
300      *
301      * See {_mintERC2309} for more details.
302      */
303     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
304 }
305 
306 // File: erc721a/contracts/ERC721A.sol
307 
308 
309 // ERC721A Contracts v4.2.2
310 // Creator: Chiru Labs
311 
312 pragma solidity ^0.8.4;
313 
314 
315 /**
316  * @dev Interface of ERC721 token receiver.
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
343     // Reference type for token approval.
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
614     /**
615      * @dev Returns the owner of the `tokenId` token.
616      *
617      * Requirements:
618      *
619      * - `tokenId` must exist.
620      */
621     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
622         return address(uint160(_packedOwnershipOf(tokenId)));
623     }
624 
625     /**
626      * @dev Gas spent here starts off proportional to the maximum mint batch size.
627      * It gradually moves to O(1) as tokens get transferred around over time.
628      */
629     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
630         return _unpackedOwnership(_packedOwnershipOf(tokenId));
631     }
632 
633     /**
634      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
635      */
636     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
637         return _unpackedOwnership(_packedOwnerships[index]);
638     }
639 
640     /**
641      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
642      */
643     function _initializeOwnershipAt(uint256 index) internal virtual {
644         if (_packedOwnerships[index] == 0) {
645             _packedOwnerships[index] = _packedOwnershipOf(index);
646         }
647     }
648 
649     /**
650      * Returns the packed ownership data of `tokenId`.
651      */
652     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
653         uint256 curr = tokenId;
654 
655         unchecked {
656             if (_startTokenId() <= curr)
657                 if (curr < _currentIndex) {
658                     uint256 packed = _packedOwnerships[curr];
659                     // If not burned.
660                     if (packed & _BITMASK_BURNED == 0) {
661                         // Invariant:
662                         // There will always be an initialized ownership slot
663                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
664                         // before an unintialized ownership slot
665                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
666                         // Hence, `curr` will not underflow.
667                         //
668                         // We can directly compare the packed value.
669                         // If the address is zero, packed will be zero.
670                         while (packed == 0) {
671                             packed = _packedOwnerships[--curr];
672                         }
673                         return packed;
674                     }
675                 }
676         }
677         revert OwnerQueryForNonexistentToken();
678     }
679 
680     /**
681      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
682      */
683     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
684         ownership.addr = address(uint160(packed));
685         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
686         ownership.burned = packed & _BITMASK_BURNED != 0;
687         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
688     }
689 
690     /**
691      * @dev Packs ownership data into a single uint256.
692      */
693     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
694         assembly {
695             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
696             owner := and(owner, _BITMASK_ADDRESS)
697             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
698             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
699         }
700     }
701 
702     /**
703      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
704      */
705     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
706         // For branchless setting of the `nextInitialized` flag.
707         assembly {
708             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
709             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
710         }
711     }
712 
713     // =============================================================
714     //                      APPROVAL OPERATIONS
715     // =============================================================
716 
717     /**
718      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
719      * The approval is cleared when the token is transferred.
720      *
721      * Only a single account can be approved at a time, so approving the
722      * zero address clears previous approvals.
723      *
724      * Requirements:
725      *
726      * - The caller must own the token or be an approved operator.
727      * - `tokenId` must exist.
728      *
729      * Emits an {Approval} event.
730      */
731     function approve(address to, uint256 tokenId) public virtual override {
732         address owner = ownerOf(tokenId);
733 
734         if (_msgSenderERC721A() != owner)
735             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
736                 revert ApprovalCallerNotOwnerNorApproved();
737             }
738 
739         _tokenApprovals[tokenId].value = to;
740         emit Approval(owner, to, tokenId);
741     }
742 
743     /**
744      * @dev Returns the account approved for `tokenId` token.
745      *
746      * Requirements:
747      *
748      * - `tokenId` must exist.
749      */
750     function getApproved(uint256 tokenId) public view virtual override returns (address) {
751         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
752 
753         return _tokenApprovals[tokenId].value;
754     }
755 
756     /**
757      * @dev Approve or remove `operator` as an operator for the caller.
758      * Operators can call {transferFrom} or {safeTransferFrom}
759      * for any token owned by the caller.
760      *
761      * Requirements:
762      *
763      * - The `operator` cannot be the caller.
764      *
765      * Emits an {ApprovalForAll} event.
766      */
767     function setApprovalForAll(address operator, bool approved) public virtual override {
768         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
769 
770         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
771         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
772     }
773 
774     /**
775      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
776      *
777      * See {setApprovalForAll}.
778      */
779     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
780         return _operatorApprovals[owner][operator];
781     }
782 
783     /**
784      * @dev Returns whether `tokenId` exists.
785      *
786      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
787      *
788      * Tokens start existing when they are minted. See {_mint}.
789      */
790     function _exists(uint256 tokenId) internal view virtual returns (bool) {
791         return
792             _startTokenId() <= tokenId &&
793             tokenId < _currentIndex && // If within bounds,
794             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
795     }
796 
797     /**
798      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
799      */
800     function _isSenderApprovedOrOwner(
801         address approvedAddress,
802         address owner,
803         address msgSender
804     ) private pure returns (bool result) {
805         assembly {
806             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
807             owner := and(owner, _BITMASK_ADDRESS)
808             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
809             msgSender := and(msgSender, _BITMASK_ADDRESS)
810             // `msgSender == owner || msgSender == approvedAddress`.
811             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
812         }
813     }
814 
815     /**
816      * @dev Returns the storage slot and value for the approved address of `tokenId`.
817      */
818     function _getApprovedSlotAndAddress(uint256 tokenId)
819         private
820         view
821         returns (uint256 approvedAddressSlot, address approvedAddress)
822     {
823         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
824         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
825         assembly {
826             approvedAddressSlot := tokenApproval.slot
827             approvedAddress := sload(approvedAddressSlot)
828         }
829     }
830 
831     // =============================================================
832     //                      TRANSFER OPERATIONS
833     // =============================================================
834 
835     /**
836      * @dev Transfers `tokenId` from `from` to `to`.
837      *
838      * Requirements:
839      *
840      * - `from` cannot be the zero address.
841      * - `to` cannot be the zero address.
842      * - `tokenId` token must be owned by `from`.
843      * - If the caller is not `from`, it must be approved to move this token
844      * by either {approve} or {setApprovalForAll}.
845      *
846      * Emits a {Transfer} event.
847      */
848     function transferFrom(
849         address from,
850         address to,
851         uint256 tokenId
852     ) public virtual override {
853         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
854 
855         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
856 
857         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
858 
859         // The nested ifs save around 20+ gas over a compound boolean condition.
860         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
861             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
862 
863         if (to == address(0)) revert TransferToZeroAddress();
864 
865         _beforeTokenTransfers(from, to, tokenId, 1);
866 
867         // Clear approvals from the previous owner.
868         assembly {
869             if approvedAddress {
870                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
871                 sstore(approvedAddressSlot, 0)
872             }
873         }
874 
875         // Underflow of the sender's balance is impossible because we check for
876         // ownership above and the recipient's balance can't realistically overflow.
877         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
878         unchecked {
879             // We can directly increment and decrement the balances.
880             --_packedAddressData[from]; // Updates: `balance -= 1`.
881             ++_packedAddressData[to]; // Updates: `balance += 1`.
882 
883             // Updates:
884             // - `address` to the next owner.
885             // - `startTimestamp` to the timestamp of transfering.
886             // - `burned` to `false`.
887             // - `nextInitialized` to `true`.
888             _packedOwnerships[tokenId] = _packOwnershipData(
889                 to,
890                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
891             );
892 
893             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
894             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
895                 uint256 nextTokenId = tokenId + 1;
896                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
897                 if (_packedOwnerships[nextTokenId] == 0) {
898                     // If the next slot is within bounds.
899                     if (nextTokenId != _currentIndex) {
900                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
901                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
902                     }
903                 }
904             }
905         }
906 
907         emit Transfer(from, to, tokenId);
908         _afterTokenTransfers(from, to, tokenId, 1);
909     }
910 
911     /**
912      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
913      */
914     function safeTransferFrom(
915         address from,
916         address to,
917         uint256 tokenId
918     ) public virtual override {
919         safeTransferFrom(from, to, tokenId, '');
920     }
921 
922     /**
923      * @dev Safely transfers `tokenId` token from `from` to `to`.
924      *
925      * Requirements:
926      *
927      * - `from` cannot be the zero address.
928      * - `to` cannot be the zero address.
929      * - `tokenId` token must exist and be owned by `from`.
930      * - If the caller is not `from`, it must be approved to move this token
931      * by either {approve} or {setApprovalForAll}.
932      * - If `to` refers to a smart contract, it must implement
933      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
934      *
935      * Emits a {Transfer} event.
936      */
937     function safeTransferFrom(
938         address from,
939         address to,
940         uint256 tokenId,
941         bytes memory _data
942     ) public virtual override {
943         transferFrom(from, to, tokenId);
944         if (to.code.length != 0)
945             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
946                 revert TransferToNonERC721ReceiverImplementer();
947             }
948     }
949 
950     /**
951      * @dev Hook that is called before a set of serially-ordered token IDs
952      * are about to be transferred. This includes minting.
953      * And also called before burning one token.
954      *
955      * `startTokenId` - the first token ID to be transferred.
956      * `quantity` - the amount to be transferred.
957      *
958      * Calling conditions:
959      *
960      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
961      * transferred to `to`.
962      * - When `from` is zero, `tokenId` will be minted for `to`.
963      * - When `to` is zero, `tokenId` will be burned by `from`.
964      * - `from` and `to` are never both zero.
965      */
966     function _beforeTokenTransfers(
967         address from,
968         address to,
969         uint256 startTokenId,
970         uint256 quantity
971     ) internal virtual {}
972 
973     /**
974      * @dev Hook that is called after a set of serially-ordered token IDs
975      * have been transferred. This includes minting.
976      * And also called after one token has been burned.
977      *
978      * `startTokenId` - the first token ID to be transferred.
979      * `quantity` - the amount to be transferred.
980      *
981      * Calling conditions:
982      *
983      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
984      * transferred to `to`.
985      * - When `from` is zero, `tokenId` has been minted for `to`.
986      * - When `to` is zero, `tokenId` has been burned by `from`.
987      * - `from` and `to` are never both zero.
988      */
989     function _afterTokenTransfers(
990         address from,
991         address to,
992         uint256 startTokenId,
993         uint256 quantity
994     ) internal virtual {}
995 
996     /**
997      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
998      *
999      * `from` - Previous owner of the given token ID.
1000      * `to` - Target address that will receive the token.
1001      * `tokenId` - Token ID to be transferred.
1002      * `_data` - Optional data to send along with the call.
1003      *
1004      * Returns whether the call correctly returned the expected magic value.
1005      */
1006     function _checkContractOnERC721Received(
1007         address from,
1008         address to,
1009         uint256 tokenId,
1010         bytes memory _data
1011     ) private returns (bool) {
1012         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1013             bytes4 retval
1014         ) {
1015             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1016         } catch (bytes memory reason) {
1017             if (reason.length == 0) {
1018                 revert TransferToNonERC721ReceiverImplementer();
1019             } else {
1020                 assembly {
1021                     revert(add(32, reason), mload(reason))
1022                 }
1023             }
1024         }
1025     }
1026 
1027     // =============================================================
1028     //                        MINT OPERATIONS
1029     // =============================================================
1030 
1031     /**
1032      * @dev Mints `quantity` tokens and transfers them to `to`.
1033      *
1034      * Requirements:
1035      *
1036      * - `to` cannot be the zero address.
1037      * - `quantity` must be greater than 0.
1038      *
1039      * Emits a {Transfer} event for each mint.
1040      */
1041     function _mint(address to, uint256 quantity) internal virtual {
1042         uint256 startTokenId = _currentIndex;
1043         if (quantity == 0) revert MintZeroQuantity();
1044 
1045         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1046 
1047         // Overflows are incredibly unrealistic.
1048         // `balance` and `numberMinted` have a maximum limit of 2**64.
1049         // `tokenId` has a maximum limit of 2**256.
1050         unchecked {
1051             // Updates:
1052             // - `balance += quantity`.
1053             // - `numberMinted += quantity`.
1054             //
1055             // We can directly add to the `balance` and `numberMinted`.
1056             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1057 
1058             // Updates:
1059             // - `address` to the owner.
1060             // - `startTimestamp` to the timestamp of minting.
1061             // - `burned` to `false`.
1062             // - `nextInitialized` to `quantity == 1`.
1063             _packedOwnerships[startTokenId] = _packOwnershipData(
1064                 to,
1065                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1066             );
1067 
1068             uint256 toMasked;
1069             uint256 end = startTokenId + quantity;
1070 
1071             // Use assembly to loop and emit the `Transfer` event for gas savings.
1072             assembly {
1073                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1074                 toMasked := and(to, _BITMASK_ADDRESS)
1075                 // Emit the `Transfer` event.
1076                 log4(
1077                     0, // Start of data (0, since no data).
1078                     0, // End of data (0, since no data).
1079                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1080                     0, // `address(0)`.
1081                     toMasked, // `to`.
1082                     startTokenId // `tokenId`.
1083                 )
1084 
1085                 for {
1086                     let tokenId := add(startTokenId, 1)
1087                 } iszero(eq(tokenId, end)) {
1088                     tokenId := add(tokenId, 1)
1089                 } {
1090                     // Emit the `Transfer` event. Similar to above.
1091                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1092                 }
1093             }
1094             if (toMasked == 0) revert MintToZeroAddress();
1095 
1096             _currentIndex = end;
1097         }
1098         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1099     }
1100 
1101     /**
1102      * @dev Mints `quantity` tokens and transfers them to `to`.
1103      *
1104      * This function is intended for efficient minting only during contract creation.
1105      *
1106      * It emits only one {ConsecutiveTransfer} as defined in
1107      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1108      * instead of a sequence of {Transfer} event(s).
1109      *
1110      * Calling this function outside of contract creation WILL make your contract
1111      * non-compliant with the ERC721 standard.
1112      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1113      * {ConsecutiveTransfer} event is only permissible during contract creation.
1114      *
1115      * Requirements:
1116      *
1117      * - `to` cannot be the zero address.
1118      * - `quantity` must be greater than 0.
1119      *
1120      * Emits a {ConsecutiveTransfer} event.
1121      */
1122     function _mintERC2309(address to, uint256 quantity) internal virtual {
1123         uint256 startTokenId = _currentIndex;
1124         if (to == address(0)) revert MintToZeroAddress();
1125         if (quantity == 0) revert MintZeroQuantity();
1126         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1127 
1128         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1129 
1130         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1131         unchecked {
1132             // Updates:
1133             // - `balance += quantity`.
1134             // - `numberMinted += quantity`.
1135             //
1136             // We can directly add to the `balance` and `numberMinted`.
1137             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1138 
1139             // Updates:
1140             // - `address` to the owner.
1141             // - `startTimestamp` to the timestamp of minting.
1142             // - `burned` to `false`.
1143             // - `nextInitialized` to `quantity == 1`.
1144             _packedOwnerships[startTokenId] = _packOwnershipData(
1145                 to,
1146                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1147             );
1148 
1149             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1150 
1151             _currentIndex = startTokenId + quantity;
1152         }
1153         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1154     }
1155 
1156     /**
1157      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1158      *
1159      * Requirements:
1160      *
1161      * - If `to` refers to a smart contract, it must implement
1162      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1163      * - `quantity` must be greater than 0.
1164      *
1165      * See {_mint}.
1166      *
1167      * Emits a {Transfer} event for each mint.
1168      */
1169     function _safeMint(
1170         address to,
1171         uint256 quantity,
1172         bytes memory _data
1173     ) internal virtual {
1174         _mint(to, quantity);
1175 
1176         unchecked {
1177             if (to.code.length != 0) {
1178                 uint256 end = _currentIndex;
1179                 uint256 index = end - quantity;
1180                 do {
1181                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1182                         revert TransferToNonERC721ReceiverImplementer();
1183                     }
1184                 } while (index < end);
1185                 // Reentrancy protection.
1186                 if (_currentIndex != end) revert();
1187             }
1188         }
1189     }
1190 
1191     /**
1192      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1193      */
1194     function _safeMint(address to, uint256 quantity) internal virtual {
1195         _safeMint(to, quantity, '');
1196     }
1197 
1198     // =============================================================
1199     //                        BURN OPERATIONS
1200     // =============================================================
1201 
1202     /**
1203      * @dev Equivalent to `_burn(tokenId, false)`.
1204      */
1205     function _burn(uint256 tokenId) internal virtual {
1206         _burn(tokenId, false);
1207     }
1208 
1209     /**
1210      * @dev Destroys `tokenId`.
1211      * The approval is cleared when the token is burned.
1212      *
1213      * Requirements:
1214      *
1215      * - `tokenId` must exist.
1216      *
1217      * Emits a {Transfer} event.
1218      */
1219     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1220         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1221 
1222         address from = address(uint160(prevOwnershipPacked));
1223 
1224         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1225 
1226         if (approvalCheck) {
1227             // The nested ifs save around 20+ gas over a compound boolean condition.
1228             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1229                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1230         }
1231 
1232         _beforeTokenTransfers(from, address(0), tokenId, 1);
1233 
1234         // Clear approvals from the previous owner.
1235         assembly {
1236             if approvedAddress {
1237                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1238                 sstore(approvedAddressSlot, 0)
1239             }
1240         }
1241 
1242         // Underflow of the sender's balance is impossible because we check for
1243         // ownership above and the recipient's balance can't realistically overflow.
1244         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1245         unchecked {
1246             // Updates:
1247             // - `balance -= 1`.
1248             // - `numberBurned += 1`.
1249             //
1250             // We can directly decrement the balance, and increment the number burned.
1251             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1252             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1253 
1254             // Updates:
1255             // - `address` to the last owner.
1256             // - `startTimestamp` to the timestamp of burning.
1257             // - `burned` to `true`.
1258             // - `nextInitialized` to `true`.
1259             _packedOwnerships[tokenId] = _packOwnershipData(
1260                 from,
1261                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1262             );
1263 
1264             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1265             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1266                 uint256 nextTokenId = tokenId + 1;
1267                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1268                 if (_packedOwnerships[nextTokenId] == 0) {
1269                     // If the next slot is within bounds.
1270                     if (nextTokenId != _currentIndex) {
1271                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1272                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1273                     }
1274                 }
1275             }
1276         }
1277 
1278         emit Transfer(from, address(0), tokenId);
1279         _afterTokenTransfers(from, address(0), tokenId, 1);
1280 
1281         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1282         unchecked {
1283             _burnCounter++;
1284         }
1285     }
1286 
1287     // =============================================================
1288     //                     EXTRA DATA OPERATIONS
1289     // =============================================================
1290 
1291     /**
1292      * @dev Directly sets the extra data for the ownership data `index`.
1293      */
1294     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1295         uint256 packed = _packedOwnerships[index];
1296         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1297         uint256 extraDataCasted;
1298         // Cast `extraData` with assembly to avoid redundant masking.
1299         assembly {
1300             extraDataCasted := extraData
1301         }
1302         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1303         _packedOwnerships[index] = packed;
1304     }
1305 
1306     /**
1307      * @dev Called during each token transfer to set the 24bit `extraData` field.
1308      * Intended to be overridden by the cosumer contract.
1309      *
1310      * `previousExtraData` - the value of `extraData` before transfer.
1311      *
1312      * Calling conditions:
1313      *
1314      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1315      * transferred to `to`.
1316      * - When `from` is zero, `tokenId` will be minted for `to`.
1317      * - When `to` is zero, `tokenId` will be burned by `from`.
1318      * - `from` and `to` are never both zero.
1319      */
1320     function _extraData(
1321         address from,
1322         address to,
1323         uint24 previousExtraData
1324     ) internal view virtual returns (uint24) {}
1325 
1326     /**
1327      * @dev Returns the next extra data for the packed ownership data.
1328      * The returned result is shifted into position.
1329      */
1330     function _nextExtraData(
1331         address from,
1332         address to,
1333         uint256 prevOwnershipPacked
1334     ) private view returns (uint256) {
1335         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1336         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1337     }
1338 
1339     // =============================================================
1340     //                       OTHER OPERATIONS
1341     // =============================================================
1342 
1343     /**
1344      * @dev Returns the message sender (defaults to `msg.sender`).
1345      *
1346      * If you are writing GSN compatible contracts, you need to override this function.
1347      */
1348     function _msgSenderERC721A() internal view virtual returns (address) {
1349         return msg.sender;
1350     }
1351 
1352     /**
1353      * @dev Converts a uint256 to its ASCII string decimal representation.
1354      */
1355     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1356         assembly {
1357             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1358             // but we allocate 0x80 bytes to keep the free memory pointer 32-byte word aliged.
1359             // We will need 1 32-byte word to store the length,
1360             // and 3 32-byte words to store a maximum of 78 digits. Total: 0x20 + 3 * 0x20 = 0x80.
1361             str := add(mload(0x40), 0x80)
1362             // Update the free memory pointer to allocate.
1363             mstore(0x40, str)
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
1391 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
1392 
1393 
1394 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1395 
1396 pragma solidity ^0.8.0;
1397 
1398 /**
1399  * @dev Contract module that helps prevent reentrant calls to a function.
1400  *
1401  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1402  * available, which can be applied to functions to make sure there are no nested
1403  * (reentrant) calls to them.
1404  *
1405  * Note that because there is a single `nonReentrant` guard, functions marked as
1406  * `nonReentrant` may not call one another. This can be worked around by making
1407  * those functions `private`, and then adding `external` `nonReentrant` entry
1408  * points to them.
1409  *
1410  * TIP: If you would like to learn more about reentrancy and alternative ways
1411  * to protect against it, check out our blog post
1412  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1413  */
1414 abstract contract ReentrancyGuard {
1415     // Booleans are more expensive than uint256 or any type that takes up a full
1416     // word because each write operation emits an extra SLOAD to first read the
1417     // slot's contents, replace the bits taken up by the boolean, and then write
1418     // back. This is the compiler's defense against contract upgrades and
1419     // pointer aliasing, and it cannot be disabled.
1420 
1421     // The values being non-zero value makes deployment a bit more expensive,
1422     // but in exchange the refund on every call to nonReentrant will be lower in
1423     // amount. Since refunds are capped to a percentage of the total
1424     // transaction's gas, it is best to keep them low in cases like this one, to
1425     // increase the likelihood of the full refund coming into effect.
1426     uint256 private constant _NOT_ENTERED = 1;
1427     uint256 private constant _ENTERED = 2;
1428 
1429     uint256 private _status;
1430 
1431     constructor() {
1432         _status = _NOT_ENTERED;
1433     }
1434 
1435     /**
1436      * @dev Prevents a contract from calling itself, directly or indirectly.
1437      * Calling a `nonReentrant` function from another `nonReentrant`
1438      * function is not supported. It is possible to prevent this from happening
1439      * by making the `nonReentrant` function external, and making it call a
1440      * `private` function that does the actual work.
1441      */
1442     modifier nonReentrant() {
1443         // On the first call to nonReentrant, _notEntered will be true
1444         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1445 
1446         // Any calls to nonReentrant after this point will fail
1447         _status = _ENTERED;
1448 
1449         _;
1450 
1451         // By storing the original value once again, a refund is triggered (see
1452         // https://eips.ethereum.org/EIPS/eip-2200)
1453         _status = _NOT_ENTERED;
1454     }
1455 }
1456 
1457 // File: @openzeppelin/contracts/utils/Context.sol
1458 
1459 
1460 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1461 
1462 pragma solidity ^0.8.0;
1463 
1464 /**
1465  * @dev Provides information about the current execution context, including the
1466  * sender of the transaction and its data. While these are generally available
1467  * via msg.sender and msg.data, they should not be accessed in such a direct
1468  * manner, since when dealing with meta-transactions the account sending and
1469  * paying for execution may not be the actual sender (as far as an application
1470  * is concerned).
1471  *
1472  * This contract is only required for intermediate, library-like contracts.
1473  */
1474 abstract contract Context {
1475     function _msgSender() internal view virtual returns (address) {
1476         return msg.sender;
1477     }
1478 
1479     function _msgData() internal view virtual returns (bytes calldata) {
1480         return msg.data;
1481     }
1482 }
1483 
1484 // File: @openzeppelin/contracts/access/Ownable.sol
1485 
1486 
1487 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1488 
1489 pragma solidity ^0.8.0;
1490 
1491 
1492 /**
1493  * @dev Contract module which provides a basic access control mechanism, where
1494  * there is an account (an owner) that can be granted exclusive access to
1495  * specific functions.
1496  *
1497  * By default, the owner account will be the one that deploys the contract. This
1498  * can later be changed with {transferOwnership}.
1499  *
1500  * This module is used through inheritance. It will make available the modifier
1501  * `onlyOwner`, which can be applied to your functions to restrict their use to
1502  * the owner.
1503  */
1504 abstract contract Ownable is Context {
1505     address private _owner;
1506 
1507     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1508 
1509     /**
1510      * @dev Initializes the contract setting the deployer as the initial owner.
1511      */
1512     constructor() {
1513         _transferOwnership(_msgSender());
1514     }
1515 
1516     /**
1517      * @dev Throws if called by any account other than the owner.
1518      */
1519     modifier onlyOwner() {
1520         _checkOwner();
1521         _;
1522     }
1523 
1524     /**
1525      * @dev Returns the address of the current owner.
1526      */
1527     function owner() public view virtual returns (address) {
1528         return _owner;
1529     }
1530 
1531     /**
1532      * @dev Throws if the sender is not the owner.
1533      */
1534     function _checkOwner() internal view virtual {
1535         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1536     }
1537 
1538     /**
1539      * @dev Leaves the contract without owner. It will not be possible to call
1540      * `onlyOwner` functions anymore. Can only be called by the current owner.
1541      *
1542      * NOTE: Renouncing ownership will leave the contract without an owner,
1543      * thereby removing any functionality that is only available to the owner.
1544      */
1545     function renounceOwnership() public virtual onlyOwner {
1546         _transferOwnership(address(0));
1547     }
1548 
1549     /**
1550      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1551      * Can only be called by the current owner.
1552      */
1553     function transferOwnership(address newOwner) public virtual onlyOwner {
1554         require(newOwner != address(0), "Ownable: new owner is the zero address");
1555         _transferOwnership(newOwner);
1556     }
1557 
1558     /**
1559      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1560      * Internal function without access restriction.
1561      */
1562     function _transferOwnership(address newOwner) internal virtual {
1563         address oldOwner = _owner;
1564         _owner = newOwner;
1565         emit OwnershipTransferred(oldOwner, newOwner);
1566     }
1567 }
1568 
1569 // File: contracts/nangoHentai.sol
1570 
1571 
1572 pragma solidity ^0.8.4;
1573 
1574 
1575 
1576 
1577 contract NangoHentai is Ownable, ERC721A, ReentrancyGuard {
1578     mapping(address => uint256) public minted;
1579     NangoHentaiConfig public nangoHentaiConfig;
1580 
1581     uint256 public freeSlots = 600;
1582 
1583     struct NangoHentaiConfig {
1584         uint256 price;
1585         uint256 maxMint;
1586         uint256 maxSupply;
1587         uint256 maxFree;
1588     }
1589 
1590     constructor() ERC721A("NangoHentai", "N-Hentai") {
1591         nangoHentaiConfig.maxSupply = 5000;
1592         nangoHentaiConfig.price = 7500000000000000;
1593         nangoHentaiConfig.maxMint = 20;
1594         nangoHentaiConfig.maxFree = 3;
1595     }
1596 
1597     function mint(uint256 quantity) external payable {
1598         NangoHentaiConfig memory config = nangoHentaiConfig;
1599         uint256 price = uint256(config.price);
1600         uint256 maxMint = uint256(config.maxMint);
1601         uint256 maxFree = uint256(config.maxFree);
1602         uint256 buyed = getAddressBuyed(msg.sender);
1603 
1604         require(
1605             totalSupply() + quantity <= getMaxSupply(),
1606             "Sold out."
1607         );
1608     
1609         require(
1610             buyed + quantity <= maxMint,
1611             "Exceed maxmium mint."
1612         );
1613 
1614         if (freeSlots == 0) {
1615             require(
1616                 quantity * price <= msg.value,
1617                 "No enough eth."
1618             );
1619         } else {
1620             require(
1621                 buyed + quantity <= maxFree,
1622                 "Exceed max free mint."
1623             );
1624             freeSlots -= quantity;
1625         }
1626 
1627         _safeMint(msg.sender, quantity);
1628         minted[msg.sender] += quantity;
1629     }
1630 
1631     function devMint(uint256 quantity) external onlyOwner {
1632         require(
1633             totalSupply() + quantity <= getMaxSupply(),
1634             "Sold out."
1635         );
1636 
1637         _safeMint(msg.sender, quantity);
1638     }
1639 
1640     function getAddressBuyed(address owner) public view returns (uint256) {
1641         return minted[owner];
1642     }
1643     
1644     function getMaxSupply() private view returns (uint256) {
1645         NangoHentaiConfig memory config = nangoHentaiConfig;
1646         uint256 max = uint256(config.maxSupply);
1647         return max;
1648     }
1649 
1650     string private _baseTokenURI;
1651 
1652     function _baseURI() internal view virtual override returns (string memory) {
1653         return _baseTokenURI;
1654     }
1655 
1656     function setURI(string calldata baseURI) external onlyOwner {
1657         _baseTokenURI = baseURI;
1658     }
1659 
1660     function setPrice(uint256 _price) external onlyOwner {
1661         nangoHentaiConfig.price = _price;
1662     }
1663 
1664     function setMaxMint(uint256 _amount) external onlyOwner {
1665         nangoHentaiConfig.maxMint = _amount;
1666     }
1667 
1668     function withdraw() external onlyOwner nonReentrant {
1669         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1670         require(success, "ok");
1671     }
1672 }