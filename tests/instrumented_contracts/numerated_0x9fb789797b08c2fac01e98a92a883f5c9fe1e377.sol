1 //SPDX-License-Identifier: UNLICENSED
2 //                                    .....,,,,,,,,,,,,,,,,,,,,,,.....                                
3 //                            .,,,,,,,********///*********//********,,,,,,,,,.                        
4 //                     .,,,,**//****************////*****/////************/**,,,,,,                   
5 //                 ,,,******************/*,.,,,************,,,,,,,,,**/************,,,                
6 //              .*********************/,*/**************************,,,,.*/*********/*,,              
7 //             ***********************.*******************************/*,,,,/*********/*.             
8 //           ./***********************,,/********************************,,,/***********,.            
9 //            ,************************,,,*//************/*,************,,.***********.*/.            
10 //           .*,.*************************,,,,,,,,,,,,,,**/************,.*/******/*,*****,.           
11 //           .*,,,,.**************************/////*****************/,,/*******,,/********            
12 //           .*,,,,,,,,,.,*//***********************************/*,*///*,..*/*************            
13 //           .,,,,,,,,,,,,,,,,,,,,.,,,,******************,,,,,..,,,,*********************/.           
14 //            ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,********************************/,           
15 //            ,,,,,,,*/*************///////////******************************************/,.          
16 //            .,,,,,/********************************************************************/,.          
17 //             ,,,,**********************************************************************/,.          
18 //             ,,,,,/********************************************************************/.           
19 //             .,,,,*********************************************************************/.           
20 //              ,,,,***************************/*./&@%.****************,/@@@@@*,/*********            
21 //               ,,,,***************************@@@@@@@(,**************,&@@@@@@%.*********.           
22 //               ,,,,,/*********************** %@@@@@@%,/**************/,/@@@@@#.*******/.            
23 //                ,,,,*************************.*#%#,./*******************/,..,*********/.            
24 //                 ,,,,**************************//************************************/,             
25 //                 .*,,,****************************************************************              
26 //                  .,,,,*************************************************************/.              
27 //                    ,,,,***********************************************************/,               
28 //                     ,,,,**********************************************************,                
29 //                      ,,,,,******************************************************/,                 
30 //                       .*,,,****************************************************/,                  
31 //                         .,,,,/************************************************/.                   
32 //                           ,,,,*/********************************************//                     
33 //                             ,,,,*/*****************************************/.                      
34 //                              ,,,,,**************************************/,                        
35 //                                .,,,,**********************************/.                          
36 //                                    .,,,,,***************************/,..                           
37 //                                        .,,,,,*******************/*,                                
38 //                                            ..,,,,,,*********,.                                     
39 //                                                    ....                                            
40 
41 // File: erc721a/contracts/IERC721A.sol
42 
43 // ERC721A Contracts v4.2.2
44 // Creator: Chiru Labs
45 
46 pragma solidity ^0.8.4;
47 
48 /**
49  * @dev Interface of ERC721A.
50  */
51 interface IERC721A {
52     /**
53      * The caller must own the token or be an approved operator.
54      */
55     error ApprovalCallerNotOwnerNorApproved();
56 
57     /**
58      * The token does not exist.
59      */
60     error ApprovalQueryForNonexistentToken();
61 
62     /**
63      * The caller cannot approve to their own address.
64      */
65     error ApproveToCaller();
66 
67     /**
68      * Cannot query the balance for the zero address.
69      */
70     error BalanceQueryForZeroAddress();
71 
72     /**
73      * Cannot mint to the zero address.
74      */
75     error MintToZeroAddress();
76 
77     /**
78      * The quantity of tokens minted must be more than zero.
79      */
80     error MintZeroQuantity();
81 
82     /**
83      * The token does not exist.
84      */
85     error OwnerQueryForNonexistentToken();
86 
87     /**
88      * The caller must own the token or be an approved operator.
89      */
90     error TransferCallerNotOwnerNorApproved();
91 
92     /**
93      * The token must be owned by `from`.
94      */
95     error TransferFromIncorrectOwner();
96 
97     /**
98      * Cannot safely transfer to a contract that does not implement the
99      * ERC721Receiver interface.
100      */
101     error TransferToNonERC721ReceiverImplementer();
102 
103     /**
104      * Cannot transfer to the zero address.
105      */
106     error TransferToZeroAddress();
107 
108     /**
109      * The token does not exist.
110      */
111     error URIQueryForNonexistentToken();
112 
113     /**
114      * The `quantity` minted with ERC2309 exceeds the safety limit.
115      */
116     error MintERC2309QuantityExceedsLimit();
117 
118     /**
119      * The `extraData` cannot be set on an unintialized ownership slot.
120      */
121     error OwnershipNotInitializedForExtraData();
122 
123     // =============================================================
124     //                            STRUCTS
125     // =============================================================
126 
127     struct TokenOwnership {
128         // The address of the owner.
129         address addr;
130         // Stores the start time of ownership with minimal overhead for tokenomics.
131         uint64 startTimestamp;
132         // Whether the token has been burned.
133         bool burned;
134         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
135         uint24 extraData;
136     }
137 
138     // =============================================================
139     //                         TOKEN COUNTERS
140     // =============================================================
141 
142     /**
143      * @dev Returns the total number of tokens in existence.
144      * Burned tokens will reduce the count.
145      * To get the total number of tokens minted, please see {_totalMinted}.
146      */
147     function totalSupply() external view returns (uint256);
148 
149     // =============================================================
150     //                            IERC165
151     // =============================================================
152 
153     /**
154      * @dev Returns true if this contract implements the interface defined by
155      * `interfaceId`. See the corresponding
156      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
157      * to learn more about how these ids are created.
158      *
159      * This function call must use less than 30000 gas.
160      */
161     function supportsInterface(bytes4 interfaceId) external view returns (bool);
162 
163     // =============================================================
164     //                            IERC721
165     // =============================================================
166 
167     /**
168      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
169      */
170     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
171 
172     /**
173      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
174      */
175     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
176 
177     /**
178      * @dev Emitted when `owner` enables or disables
179      * (`approved`) `operator` to manage all of its assets.
180      */
181     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
182 
183     /**
184      * @dev Returns the number of tokens in `owner`'s account.
185      */
186     function balanceOf(address owner) external view returns (uint256 balance);
187 
188     /**
189      * @dev Returns the owner of the `tokenId` token.
190      *
191      * Requirements:
192      *
193      * - `tokenId` must exist.
194      */
195     function ownerOf(uint256 tokenId) external view returns (address owner);
196 
197     /**
198      * @dev Safely transfers `tokenId` token from `from` to `to`,
199      * checking first that contract recipients are aware of the ERC721 protocol
200      * to prevent tokens from being forever locked.
201      *
202      * Requirements:
203      *
204      * - `from` cannot be the zero address.
205      * - `to` cannot be the zero address.
206      * - `tokenId` token must exist and be owned by `from`.
207      * - If the caller is not `from`, it must be have been allowed to move
208      * this token by either {approve} or {setApprovalForAll}.
209      * - If `to` refers to a smart contract, it must implement
210      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
211      *
212      * Emits a {Transfer} event.
213      */
214     function safeTransferFrom(
215         address from,
216         address to,
217         uint256 tokenId,
218         bytes calldata data
219     ) external;
220 
221     /**
222      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
223      */
224     function safeTransferFrom(
225         address from,
226         address to,
227         uint256 tokenId
228     ) external;
229 
230     /**
231      * @dev Transfers `tokenId` from `from` to `to`.
232      *
233      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
234      * whenever possible.
235      *
236      * Requirements:
237      *
238      * - `from` cannot be the zero address.
239      * - `to` cannot be the zero address.
240      * - `tokenId` token must be owned by `from`.
241      * - If the caller is not `from`, it must be approved to move this token
242      * by either {approve} or {setApprovalForAll}.
243      *
244      * Emits a {Transfer} event.
245      */
246     function transferFrom(
247         address from,
248         address to,
249         uint256 tokenId
250     ) external;
251 
252     /**
253      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
254      * The approval is cleared when the token is transferred.
255      *
256      * Only a single account can be approved at a time, so approving the
257      * zero address clears previous approvals.
258      *
259      * Requirements:
260      *
261      * - The caller must own the token or be an approved operator.
262      * - `tokenId` must exist.
263      *
264      * Emits an {Approval} event.
265      */
266     function approve(address to, uint256 tokenId) external;
267 
268     /**
269      * @dev Approve or remove `operator` as an operator for the caller.
270      * Operators can call {transferFrom} or {safeTransferFrom}
271      * for any token owned by the caller.
272      *
273      * Requirements:
274      *
275      * - The `operator` cannot be the caller.
276      *
277      * Emits an {ApprovalForAll} event.
278      */
279     function setApprovalForAll(address operator, bool _approved) external;
280 
281     /**
282      * @dev Returns the account approved for `tokenId` token.
283      *
284      * Requirements:
285      *
286      * - `tokenId` must exist.
287      */
288     function getApproved(uint256 tokenId) external view returns (address operator);
289 
290     /**
291      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
292      *
293      * See {setApprovalForAll}.
294      */
295     function isApprovedForAll(address owner, address operator) external view returns (bool);
296 
297     // =============================================================
298     //                        IERC721Metadata
299     // =============================================================
300 
301     /**
302      * @dev Returns the token collection name.
303      */
304     function name() external view returns (string memory);
305 
306     /**
307      * @dev Returns the token collection symbol.
308      */
309     function symbol() external view returns (string memory);
310 
311     /**
312      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
313      */
314     function tokenURI(uint256 tokenId) external view returns (string memory);
315 
316     // =============================================================
317     //                           IERC2309
318     // =============================================================
319 
320     /**
321      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
322      * (inclusive) is transferred from `from` to `to`, as defined in the
323      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
324      *
325      * See {_mintERC2309} for more details.
326      */
327     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
328 }
329 
330 // File: erc721a/contracts/ERC721A.sol
331 
332 // ERC721A Contracts v4.2.2
333 // Creator: Chiru Labs
334 
335 pragma solidity ^0.8.4;
336 
337 /**
338  * @dev Interface of ERC721 token receiver.
339  */
340 interface ERC721A__IERC721Receiver {
341     function onERC721Received(
342         address operator,
343         address from,
344         uint256 tokenId,
345         bytes calldata data
346     ) external returns (bytes4);
347 }
348 
349 /**
350  * @title ERC721A
351  *
352  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
353  * Non-Fungible Token Standard, including the Metadata extension.
354  * Optimized for lower gas during batch mints.
355  *
356  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
357  * starting from `_startTokenId()`.
358  *
359  * Assumptions:
360  *
361  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
362  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
363  */
364 contract ERC721A is IERC721A {
365     // Reference type for token approval.
366     struct TokenApprovalRef {
367         address value;
368     }
369 
370     // =============================================================
371     //                           CONSTANTS
372     // =============================================================
373 
374     // Mask of an entry in packed address data.
375     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
376 
377     // The bit position of `numberMinted` in packed address data.
378     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
379 
380     // The bit position of `numberBurned` in packed address data.
381     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
382 
383     // The bit position of `aux` in packed address data.
384     uint256 private constant _BITPOS_AUX = 192;
385 
386     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
387     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
388 
389     // The bit position of `startTimestamp` in packed ownership.
390     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
391 
392     // The bit mask of the `burned` bit in packed ownership.
393     uint256 private constant _BITMASK_BURNED = 1 << 224;
394 
395     // The bit position of the `nextInitialized` bit in packed ownership.
396     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
397 
398     // The bit mask of the `nextInitialized` bit in packed ownership.
399     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
400 
401     // The bit position of `extraData` in packed ownership.
402     uint256 private constant _BITPOS_EXTRA_DATA = 232;
403 
404     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
405     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
406 
407     // The mask of the lower 160 bits for addresses.
408     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
409 
410     // The maximum `quantity` that can be minted with {_mintERC2309}.
411     // This limit is to prevent overflows on the address data entries.
412     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
413     // is required to cause an overflow, which is unrealistic.
414     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
415 
416     // The `Transfer` event signature is given by:
417     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
418     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
419         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
420 
421     // =============================================================
422     //                            STORAGE
423     // =============================================================
424 
425     // The next token ID to be minted.
426     uint256 private _currentIndex;
427 
428     // The number of tokens burned.
429     uint256 private _burnCounter;
430 
431     // Token name
432     string private _name;
433 
434     // Token symbol
435     string private _symbol;
436 
437     // Mapping from token ID to ownership details
438     // An empty struct value does not necessarily mean the token is unowned.
439     // See {_packedOwnershipOf} implementation for details.
440     //
441     // Bits Layout:
442     // - [0..159]   `addr`
443     // - [160..223] `startTimestamp`
444     // - [224]      `burned`
445     // - [225]      `nextInitialized`
446     // - [232..255] `extraData`
447     mapping(uint256 => uint256) private _packedOwnerships;
448 
449     // Mapping owner address to address data.
450     //
451     // Bits Layout:
452     // - [0..63]    `balance`
453     // - [64..127]  `numberMinted`
454     // - [128..191] `numberBurned`
455     // - [192..255] `aux`
456     mapping(address => uint256) private _packedAddressData;
457 
458     // Mapping from token ID to approved address.
459     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
460 
461     // Mapping from owner to operator approvals
462     mapping(address => mapping(address => bool)) private _operatorApprovals;
463 
464     // =============================================================
465     //                          CONSTRUCTOR
466     // =============================================================
467 
468     constructor(string memory name_, string memory symbol_) {
469         _name = name_;
470         _symbol = symbol_;
471         _currentIndex = _startTokenId();
472     }
473 
474     // =============================================================
475     //                   TOKEN COUNTING OPERATIONS
476     // =============================================================
477 
478     /**
479      * @dev Returns the starting token ID.
480      * To change the starting token ID, please override this function.
481      */
482     function _startTokenId() internal view virtual returns (uint256) {
483         return 0;
484     }
485 
486     /**
487      * @dev Returns the next token ID to be minted.
488      */
489     function _nextTokenId() internal view virtual returns (uint256) {
490         return _currentIndex;
491     }
492 
493     /**
494      * @dev Returns the total number of tokens in existence.
495      * Burned tokens will reduce the count.
496      * To get the total number of tokens minted, please see {_totalMinted}.
497      */
498     function totalSupply() public view virtual override returns (uint256) {
499         // Counter underflow is impossible as _burnCounter cannot be incremented
500         // more than `_currentIndex - _startTokenId()` times.
501         unchecked {
502             return _currentIndex - _burnCounter - _startTokenId();
503         }
504     }
505 
506     /**
507      * @dev Returns the total amount of tokens minted in the contract.
508      */
509     function _totalMinted() internal view virtual returns (uint256) {
510         // Counter underflow is impossible as `_currentIndex` does not decrement,
511         // and it is initialized to `_startTokenId()`.
512         unchecked {
513             return _currentIndex - _startTokenId();
514         }
515     }
516 
517     /**
518      * @dev Returns the total number of tokens burned.
519      */
520     function _totalBurned() internal view virtual returns (uint256) {
521         return _burnCounter;
522     }
523 
524     // =============================================================
525     //                    ADDRESS DATA OPERATIONS
526     // =============================================================
527 
528     /**
529      * @dev Returns the number of tokens in `owner`'s account.
530      */
531     function balanceOf(address owner) public view virtual override returns (uint256) {
532         if (owner == address(0)) revert BalanceQueryForZeroAddress();
533         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
534     }
535 
536     /**
537      * Returns the number of tokens minted by `owner`.
538      */
539     function _numberMinted(address owner) internal view returns (uint256) {
540         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
541     }
542 
543     /**
544      * Returns the number of tokens burned by or on behalf of `owner`.
545      */
546     function _numberBurned(address owner) internal view returns (uint256) {
547         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
548     }
549 
550     /**
551      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
552      */
553     function _getAux(address owner) internal view returns (uint64) {
554         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
555     }
556 
557     /**
558      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
559      * If there are multiple variables, please pack them into a uint64.
560      */
561     function _setAux(address owner, uint64 aux) internal virtual {
562         uint256 packed = _packedAddressData[owner];
563         uint256 auxCasted;
564         // Cast `aux` with assembly to avoid redundant masking.
565         assembly {
566             auxCasted := aux
567         }
568         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
569         _packedAddressData[owner] = packed;
570     }
571 
572     // =============================================================
573     //                            IERC165
574     // =============================================================
575 
576     /**
577      * @dev Returns true if this contract implements the interface defined by
578      * `interfaceId`. See the corresponding
579      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
580      * to learn more about how these ids are created.
581      *
582      * This function call must use less than 30000 gas.
583      */
584     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
585         // The interface IDs are constants representing the first 4 bytes
586         // of the XOR of all function selectors in the interface.
587         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
588         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
589         return
590             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
591             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
592             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
593     }
594 
595     // =============================================================
596     //                        IERC721Metadata
597     // =============================================================
598 
599     /**
600      * @dev Returns the token collection name.
601      */
602     function name() public view virtual override returns (string memory) {
603         return _name;
604     }
605 
606     /**
607      * @dev Returns the token collection symbol.
608      */
609     function symbol() public view virtual override returns (string memory) {
610         return _symbol;
611     }
612 
613     /**
614      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
615      */
616     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
617         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
618 
619         string memory baseURI = _baseURI();
620         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
621     }
622 
623     /**
624      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
625      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
626      * by default, it can be overridden in child contracts.
627      */
628     function _baseURI() internal view virtual returns (string memory) {
629         return '';
630     }
631 
632     // =============================================================
633     //                     OWNERSHIPS OPERATIONS
634     // =============================================================
635 
636     /**
637      * @dev Returns the owner of the `tokenId` token.
638      *
639      * Requirements:
640      *
641      * - `tokenId` must exist.
642      */
643     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
644         return address(uint160(_packedOwnershipOf(tokenId)));
645     }
646 
647     /**
648      * @dev Gas spent here starts off proportional to the maximum mint batch size.
649      * It gradually moves to O(1) as tokens get transferred around over time.
650      */
651     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
652         return _unpackedOwnership(_packedOwnershipOf(tokenId));
653     }
654 
655     /**
656      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
657      */
658     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
659         return _unpackedOwnership(_packedOwnerships[index]);
660     }
661 
662     /**
663      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
664      */
665     function _initializeOwnershipAt(uint256 index) internal virtual {
666         if (_packedOwnerships[index] == 0) {
667             _packedOwnerships[index] = _packedOwnershipOf(index);
668         }
669     }
670 
671     /**
672      * Returns the packed ownership data of `tokenId`.
673      */
674     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
675         uint256 curr = tokenId;
676 
677         unchecked {
678             if (_startTokenId() <= curr)
679                 if (curr < _currentIndex) {
680                     uint256 packed = _packedOwnerships[curr];
681                     // If not burned.
682                     if (packed & _BITMASK_BURNED == 0) {
683                         // Invariant:
684                         // There will always be an initialized ownership slot
685                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
686                         // before an unintialized ownership slot
687                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
688                         // Hence, `curr` will not underflow.
689                         //
690                         // We can directly compare the packed value.
691                         // If the address is zero, packed will be zero.
692                         while (packed == 0) {
693                             packed = _packedOwnerships[--curr];
694                         }
695                         return packed;
696                     }
697                 }
698         }
699         revert OwnerQueryForNonexistentToken();
700     }
701 
702     /**
703      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
704      */
705     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
706         ownership.addr = address(uint160(packed));
707         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
708         ownership.burned = packed & _BITMASK_BURNED != 0;
709         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
710     }
711 
712     /**
713      * @dev Packs ownership data into a single uint256.
714      */
715     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
716         assembly {
717             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
718             owner := and(owner, _BITMASK_ADDRESS)
719             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
720             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
721         }
722     }
723 
724     /**
725      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
726      */
727     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
728         // For branchless setting of the `nextInitialized` flag.
729         assembly {
730             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
731             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
732         }
733     }
734 
735     // =============================================================
736     //                      APPROVAL OPERATIONS
737     // =============================================================
738 
739     /**
740      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
741      * The approval is cleared when the token is transferred.
742      *
743      * Only a single account can be approved at a time, so approving the
744      * zero address clears previous approvals.
745      *
746      * Requirements:
747      *
748      * - The caller must own the token or be an approved operator.
749      * - `tokenId` must exist.
750      *
751      * Emits an {Approval} event.
752      */
753     function approve(address to, uint256 tokenId) public virtual override {
754         address owner = ownerOf(tokenId);
755 
756         if (_msgSenderERC721A() != owner)
757             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
758                 revert ApprovalCallerNotOwnerNorApproved();
759             }
760 
761         _tokenApprovals[tokenId].value = to;
762         emit Approval(owner, to, tokenId);
763     }
764 
765     /**
766      * @dev Returns the account approved for `tokenId` token.
767      *
768      * Requirements:
769      *
770      * - `tokenId` must exist.
771      */
772     function getApproved(uint256 tokenId) public view virtual override returns (address) {
773         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
774 
775         return _tokenApprovals[tokenId].value;
776     }
777 
778     /**
779      * @dev Approve or remove `operator` as an operator for the caller.
780      * Operators can call {transferFrom} or {safeTransferFrom}
781      * for any token owned by the caller.
782      *
783      * Requirements:
784      *
785      * - The `operator` cannot be the caller.
786      *
787      * Emits an {ApprovalForAll} event.
788      */
789     function setApprovalForAll(address operator, bool approved) public virtual override {
790         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
791 
792         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
793         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
794     }
795 
796     /**
797      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
798      *
799      * See {setApprovalForAll}.
800      */
801     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
802         return _operatorApprovals[owner][operator];
803     }
804 
805     /**
806      * @dev Returns whether `tokenId` exists.
807      *
808      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
809      *
810      * Tokens start existing when they are minted. See {_mint}.
811      */
812     function _exists(uint256 tokenId) internal view virtual returns (bool) {
813         return
814             _startTokenId() <= tokenId &&
815             tokenId < _currentIndex && // If within bounds,
816             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
817     }
818 
819     /**
820      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
821      */
822     function _isSenderApprovedOrOwner(
823         address approvedAddress,
824         address owner,
825         address msgSender
826     ) private pure returns (bool result) {
827         assembly {
828             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
829             owner := and(owner, _BITMASK_ADDRESS)
830             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
831             msgSender := and(msgSender, _BITMASK_ADDRESS)
832             // `msgSender == owner || msgSender == approvedAddress`.
833             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
834         }
835     }
836 
837     /**
838      * @dev Returns the storage slot and value for the approved address of `tokenId`.
839      */
840     function _getApprovedSlotAndAddress(uint256 tokenId)
841         private
842         view
843         returns (uint256 approvedAddressSlot, address approvedAddress)
844     {
845         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
846         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
847         assembly {
848             approvedAddressSlot := tokenApproval.slot
849             approvedAddress := sload(approvedAddressSlot)
850         }
851     }
852 
853     // =============================================================
854     //                      TRANSFER OPERATIONS
855     // =============================================================
856 
857     /**
858      * @dev Transfers `tokenId` from `from` to `to`.
859      *
860      * Requirements:
861      *
862      * - `from` cannot be the zero address.
863      * - `to` cannot be the zero address.
864      * - `tokenId` token must be owned by `from`.
865      * - If the caller is not `from`, it must be approved to move this token
866      * by either {approve} or {setApprovalForAll}.
867      *
868      * Emits a {Transfer} event.
869      */
870     function transferFrom(
871         address from,
872         address to,
873         uint256 tokenId
874     ) public virtual override {
875         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
876 
877         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
878 
879         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
880 
881         // The nested ifs save around 20+ gas over a compound boolean condition.
882         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
883             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
884 
885         if (to == address(0)) revert TransferToZeroAddress();
886 
887         _beforeTokenTransfers(from, to, tokenId, 1);
888 
889         // Clear approvals from the previous owner.
890         assembly {
891             if approvedAddress {
892                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
893                 sstore(approvedAddressSlot, 0)
894             }
895         }
896 
897         // Underflow of the sender's balance is impossible because we check for
898         // ownership above and the recipient's balance can't realistically overflow.
899         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
900         unchecked {
901             // We can directly increment and decrement the balances.
902             --_packedAddressData[from]; // Updates: `balance -= 1`.
903             ++_packedAddressData[to]; // Updates: `balance += 1`.
904 
905             // Updates:
906             // - `address` to the next owner.
907             // - `startTimestamp` to the timestamp of transfering.
908             // - `burned` to `false`.
909             // - `nextInitialized` to `true`.
910             _packedOwnerships[tokenId] = _packOwnershipData(
911                 to,
912                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
913             );
914 
915             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
916             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
917                 uint256 nextTokenId = tokenId + 1;
918                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
919                 if (_packedOwnerships[nextTokenId] == 0) {
920                     // If the next slot is within bounds.
921                     if (nextTokenId != _currentIndex) {
922                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
923                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
924                     }
925                 }
926             }
927         }
928 
929         emit Transfer(from, to, tokenId);
930         _afterTokenTransfers(from, to, tokenId, 1);
931     }
932 
933     /**
934      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
935      */
936     function safeTransferFrom(
937         address from,
938         address to,
939         uint256 tokenId
940     ) public virtual override {
941         safeTransferFrom(from, to, tokenId, '');
942     }
943 
944     /**
945      * @dev Safely transfers `tokenId` token from `from` to `to`.
946      *
947      * Requirements:
948      *
949      * - `from` cannot be the zero address.
950      * - `to` cannot be the zero address.
951      * - `tokenId` token must exist and be owned by `from`.
952      * - If the caller is not `from`, it must be approved to move this token
953      * by either {approve} or {setApprovalForAll}.
954      * - If `to` refers to a smart contract, it must implement
955      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
956      *
957      * Emits a {Transfer} event.
958      */
959     function safeTransferFrom(
960         address from,
961         address to,
962         uint256 tokenId,
963         bytes memory _data
964     ) public virtual override {
965         transferFrom(from, to, tokenId);
966         if (to.code.length != 0)
967             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
968                 revert TransferToNonERC721ReceiverImplementer();
969             }
970     }
971 
972     /**
973      * @dev Hook that is called before a set of serially-ordered token IDs
974      * are about to be transferred. This includes minting.
975      * And also called before burning one token.
976      *
977      * `startTokenId` - the first token ID to be transferred.
978      * `quantity` - the amount to be transferred.
979      *
980      * Calling conditions:
981      *
982      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
983      * transferred to `to`.
984      * - When `from` is zero, `tokenId` will be minted for `to`.
985      * - When `to` is zero, `tokenId` will be burned by `from`.
986      * - `from` and `to` are never both zero.
987      */
988     function _beforeTokenTransfers(
989         address from,
990         address to,
991         uint256 startTokenId,
992         uint256 quantity
993     ) internal virtual {}
994 
995     /**
996      * @dev Hook that is called after a set of serially-ordered token IDs
997      * have been transferred. This includes minting.
998      * And also called after one token has been burned.
999      *
1000      * `startTokenId` - the first token ID to be transferred.
1001      * `quantity` - the amount to be transferred.
1002      *
1003      * Calling conditions:
1004      *
1005      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1006      * transferred to `to`.
1007      * - When `from` is zero, `tokenId` has been minted for `to`.
1008      * - When `to` is zero, `tokenId` has been burned by `from`.
1009      * - `from` and `to` are never both zero.
1010      */
1011     function _afterTokenTransfers(
1012         address from,
1013         address to,
1014         uint256 startTokenId,
1015         uint256 quantity
1016     ) internal virtual {}
1017 
1018     /**
1019      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1020      *
1021      * `from` - Previous owner of the given token ID.
1022      * `to` - Target address that will receive the token.
1023      * `tokenId` - Token ID to be transferred.
1024      * `_data` - Optional data to send along with the call.
1025      *
1026      * Returns whether the call correctly returned the expected magic value.
1027      */
1028     function _checkContractOnERC721Received(
1029         address from,
1030         address to,
1031         uint256 tokenId,
1032         bytes memory _data
1033     ) private returns (bool) {
1034         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1035             bytes4 retval
1036         ) {
1037             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1038         } catch (bytes memory reason) {
1039             if (reason.length == 0) {
1040                 revert TransferToNonERC721ReceiverImplementer();
1041             } else {
1042                 assembly {
1043                     revert(add(32, reason), mload(reason))
1044                 }
1045             }
1046         }
1047     }
1048 
1049     // =============================================================
1050     //                        MINT OPERATIONS
1051     // =============================================================
1052 
1053     /**
1054      * @dev Mints `quantity` tokens and transfers them to `to`.
1055      *
1056      * Requirements:
1057      *
1058      * - `to` cannot be the zero address.
1059      * - `quantity` must be greater than 0.
1060      *
1061      * Emits a {Transfer} event for each mint.
1062      */
1063     function _mint(address to, uint256 quantity) internal virtual {
1064         uint256 startTokenId = _currentIndex;
1065         if (quantity == 0) revert MintZeroQuantity();
1066 
1067         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1068 
1069         // Overflows are incredibly unrealistic.
1070         // `balance` and `numberMinted` have a maximum limit of 2**64.
1071         // `tokenId` has a maximum limit of 2**256.
1072         unchecked {
1073             // Updates:
1074             // - `balance += quantity`.
1075             // - `numberMinted += quantity`.
1076             //
1077             // We can directly add to the `balance` and `numberMinted`.
1078             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1079 
1080             // Updates:
1081             // - `address` to the owner.
1082             // - `startTimestamp` to the timestamp of minting.
1083             // - `burned` to `false`.
1084             // - `nextInitialized` to `quantity == 1`.
1085             _packedOwnerships[startTokenId] = _packOwnershipData(
1086                 to,
1087                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1088             );
1089 
1090             uint256 toMasked;
1091             uint256 end = startTokenId + quantity;
1092 
1093             // Use assembly to loop and emit the `Transfer` event for gas savings.
1094             assembly {
1095                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1096                 toMasked := and(to, _BITMASK_ADDRESS)
1097                 // Emit the `Transfer` event.
1098                 log4(
1099                     0, // Start of data (0, since no data).
1100                     0, // End of data (0, since no data).
1101                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1102                     0, // `address(0)`.
1103                     toMasked, // `to`.
1104                     startTokenId // `tokenId`.
1105                 )
1106 
1107                 for {
1108                     let tokenId := add(startTokenId, 1)
1109                 } iszero(eq(tokenId, end)) {
1110                     tokenId := add(tokenId, 1)
1111                 } {
1112                     // Emit the `Transfer` event. Similar to above.
1113                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1114                 }
1115             }
1116             if (toMasked == 0) revert MintToZeroAddress();
1117 
1118             _currentIndex = end;
1119         }
1120         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1121     }
1122 
1123     /**
1124      * @dev Mints `quantity` tokens and transfers them to `to`.
1125      *
1126      * This function is intended for efficient minting only during contract creation.
1127      *
1128      * It emits only one {ConsecutiveTransfer} as defined in
1129      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1130      * instead of a sequence of {Transfer} event(s).
1131      *
1132      * Calling this function outside of contract creation WILL make your contract
1133      * non-compliant with the ERC721 standard.
1134      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1135      * {ConsecutiveTransfer} event is only permissible during contract creation.
1136      *
1137      * Requirements:
1138      *
1139      * - `to` cannot be the zero address.
1140      * - `quantity` must be greater than 0.
1141      *
1142      * Emits a {ConsecutiveTransfer} event.
1143      */
1144     function _mintERC2309(address to, uint256 quantity) internal virtual {
1145         uint256 startTokenId = _currentIndex;
1146         if (to == address(0)) revert MintToZeroAddress();
1147         if (quantity == 0) revert MintZeroQuantity();
1148         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1149 
1150         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1151 
1152         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1153         unchecked {
1154             // Updates:
1155             // - `balance += quantity`.
1156             // - `numberMinted += quantity`.
1157             //
1158             // We can directly add to the `balance` and `numberMinted`.
1159             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1160 
1161             // Updates:
1162             // - `address` to the owner.
1163             // - `startTimestamp` to the timestamp of minting.
1164             // - `burned` to `false`.
1165             // - `nextInitialized` to `quantity == 1`.
1166             _packedOwnerships[startTokenId] = _packOwnershipData(
1167                 to,
1168                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1169             );
1170 
1171             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1172 
1173             _currentIndex = startTokenId + quantity;
1174         }
1175         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1176     }
1177 
1178     /**
1179      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1180      *
1181      * Requirements:
1182      *
1183      * - If `to` refers to a smart contract, it must implement
1184      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1185      * - `quantity` must be greater than 0.
1186      *
1187      * See {_mint}.
1188      *
1189      * Emits a {Transfer} event for each mint.
1190      */
1191     function _safeMint(
1192         address to,
1193         uint256 quantity,
1194         bytes memory _data
1195     ) internal virtual {
1196         _mint(to, quantity);
1197 
1198         unchecked {
1199             if (to.code.length != 0) {
1200                 uint256 end = _currentIndex;
1201                 uint256 index = end - quantity;
1202                 do {
1203                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1204                         revert TransferToNonERC721ReceiverImplementer();
1205                     }
1206                 } while (index < end);
1207                 // Reentrancy protection.
1208                 if (_currentIndex != end) revert();
1209             }
1210         }
1211     }
1212 
1213     /**
1214      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1215      */
1216     function _safeMint(address to, uint256 quantity) internal virtual {
1217         _safeMint(to, quantity, '');
1218     }
1219 
1220     // =============================================================
1221     //                        BURN OPERATIONS
1222     // =============================================================
1223 
1224     /**
1225      * @dev Equivalent to `_burn(tokenId, false)`.
1226      */
1227     function _burn(uint256 tokenId) internal virtual {
1228         _burn(tokenId, false);
1229     }
1230 
1231     /**
1232      * @dev Destroys `tokenId`.
1233      * The approval is cleared when the token is burned.
1234      *
1235      * Requirements:
1236      *
1237      * - `tokenId` must exist.
1238      *
1239      * Emits a {Transfer} event.
1240      */
1241     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1242         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1243 
1244         address from = address(uint160(prevOwnershipPacked));
1245 
1246         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1247 
1248         if (approvalCheck) {
1249             // The nested ifs save around 20+ gas over a compound boolean condition.
1250             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1251                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1252         }
1253 
1254         _beforeTokenTransfers(from, address(0), tokenId, 1);
1255 
1256         // Clear approvals from the previous owner.
1257         assembly {
1258             if approvedAddress {
1259                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1260                 sstore(approvedAddressSlot, 0)
1261             }
1262         }
1263 
1264         // Underflow of the sender's balance is impossible because we check for
1265         // ownership above and the recipient's balance can't realistically overflow.
1266         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1267         unchecked {
1268             // Updates:
1269             // - `balance -= 1`.
1270             // - `numberBurned += 1`.
1271             //
1272             // We can directly decrement the balance, and increment the number burned.
1273             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1274             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1275 
1276             // Updates:
1277             // - `address` to the last owner.
1278             // - `startTimestamp` to the timestamp of burning.
1279             // - `burned` to `true`.
1280             // - `nextInitialized` to `true`.
1281             _packedOwnerships[tokenId] = _packOwnershipData(
1282                 from,
1283                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1284             );
1285 
1286             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1287             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1288                 uint256 nextTokenId = tokenId + 1;
1289                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1290                 if (_packedOwnerships[nextTokenId] == 0) {
1291                     // If the next slot is within bounds.
1292                     if (nextTokenId != _currentIndex) {
1293                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1294                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1295                     }
1296                 }
1297             }
1298         }
1299 
1300         emit Transfer(from, address(0), tokenId);
1301         _afterTokenTransfers(from, address(0), tokenId, 1);
1302 
1303         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1304         unchecked {
1305             _burnCounter++;
1306         }
1307     }
1308 
1309     // =============================================================
1310     //                     EXTRA DATA OPERATIONS
1311     // =============================================================
1312 
1313     /**
1314      * @dev Directly sets the extra data for the ownership data `index`.
1315      */
1316     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1317         uint256 packed = _packedOwnerships[index];
1318         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1319         uint256 extraDataCasted;
1320         // Cast `extraData` with assembly to avoid redundant masking.
1321         assembly {
1322             extraDataCasted := extraData
1323         }
1324         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1325         _packedOwnerships[index] = packed;
1326     }
1327 
1328     /**
1329      * @dev Called during each token transfer to set the 24bit `extraData` field.
1330      * Intended to be overridden by the cosumer contract.
1331      *
1332      * `previousExtraData` - the value of `extraData` before transfer.
1333      *
1334      * Calling conditions:
1335      *
1336      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1337      * transferred to `to`.
1338      * - When `from` is zero, `tokenId` will be minted for `to`.
1339      * - When `to` is zero, `tokenId` will be burned by `from`.
1340      * - `from` and `to` are never both zero.
1341      */
1342     function _extraData(
1343         address from,
1344         address to,
1345         uint24 previousExtraData
1346     ) internal view virtual returns (uint24) {}
1347 
1348     /**
1349      * @dev Returns the next extra data for the packed ownership data.
1350      * The returned result is shifted into position.
1351      */
1352     function _nextExtraData(
1353         address from,
1354         address to,
1355         uint256 prevOwnershipPacked
1356     ) private view returns (uint256) {
1357         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1358         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1359     }
1360 
1361     // =============================================================
1362     //                       OTHER OPERATIONS
1363     // =============================================================
1364 
1365     /**
1366      * @dev Returns the message sender (defaults to `msg.sender`).
1367      *
1368      * If you are writing GSN compatible contracts, you need to override this function.
1369      */
1370     function _msgSenderERC721A() internal view virtual returns (address) {
1371         return msg.sender;
1372     }
1373 
1374     /**
1375      * @dev Converts a uint256 to its ASCII string decimal representation.
1376      */
1377     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1378         assembly {
1379             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1380             // but we allocate 0x80 bytes to keep the free memory pointer 32-byte word aliged.
1381             // We will need 1 32-byte word to store the length,
1382             // and 3 32-byte words to store a maximum of 78 digits. Total: 0x20 + 3 * 0x20 = 0x80.
1383             str := add(mload(0x40), 0x80)
1384             // Update the free memory pointer to allocate.
1385             mstore(0x40, str)
1386 
1387             // Cache the end of the memory to calculate the length later.
1388             let end := str
1389 
1390             // We write the string from rightmost digit to leftmost digit.
1391             // The following is essentially a do-while loop that also handles the zero case.
1392             // prettier-ignore
1393             for { let temp := value } 1 {} {
1394                 str := sub(str, 1)
1395                 // Write the character to the pointer.
1396                 // The ASCII index of the '0' character is 48.
1397                 mstore8(str, add(48, mod(temp, 10)))
1398                 // Keep dividing `temp` until zero.
1399                 temp := div(temp, 10)
1400                 // prettier-ignore
1401                 if iszero(temp) { break }
1402             }
1403 
1404             let length := sub(end, str)
1405             // Move the pointer 32 bytes leftwards to make room for the length.
1406             str := sub(str, 0x20)
1407             // Store the length.
1408             mstore(str, length)
1409         }
1410     }
1411 }
1412 
1413 // File: @openzeppelin/contracts/utils/Context.sol
1414 
1415 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1416 
1417 pragma solidity ^0.8.0;
1418 
1419 /**
1420  * @dev Provides information about the current execution context, including the
1421  * sender of the transaction and its data. While these are generally available
1422  * via msg.sender and msg.data, they should not be accessed in such a direct
1423  * manner, since when dealing with meta-transactions the account sending and
1424  * paying for execution may not be the actual sender (as far as an application
1425  * is concerned).
1426  *
1427  * This contract is only required for intermediate, library-like contracts.
1428  */
1429 abstract contract Context {
1430     function _msgSender() internal view virtual returns (address) {
1431         return msg.sender;
1432     }
1433 
1434     function _msgData() internal view virtual returns (bytes calldata) {
1435         return msg.data;
1436     }
1437 }
1438 
1439 // File: @openzeppelin/contracts/access/Ownable.sol
1440 
1441 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1442 
1443 pragma solidity ^0.8.0;
1444 
1445 /**
1446  * @dev Contract module which provides a basic access control mechanism, where
1447  * there is an account (an owner) that can be granted exclusive access to
1448  * specific functions.
1449  *
1450  * By default, the owner account will be the one that deploys the contract. This
1451  * can later be changed with {transferOwnership}.
1452  *
1453  * This module is used through inheritance. It will make available the modifier
1454  * `onlyOwner`, which can be applied to your functions to restrict their use to
1455  * the owner.
1456  */
1457 abstract contract Ownable is Context {
1458     address private _owner;
1459 
1460     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1461 
1462     /**
1463      * @dev Initializes the contract setting the deployer as the initial owner.
1464      */
1465     constructor() {
1466         _transferOwnership(_msgSender());
1467     }
1468 
1469     /**
1470      * @dev Throws if called by any account other than the owner.
1471      */
1472     modifier onlyOwner() {
1473         _checkOwner();
1474         _;
1475     }
1476 
1477     /**
1478      * @dev Returns the address of the current owner.
1479      */
1480     function owner() public view virtual returns (address) {
1481         return _owner;
1482     }
1483 
1484     /**
1485      * @dev Throws if the sender is not the owner.
1486      */
1487     function _checkOwner() internal view virtual {
1488         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1489     }
1490 
1491     /**
1492      * @dev Leaves the contract without owner. It will not be possible to call
1493      * `onlyOwner` functions anymore. Can only be called by the current owner.
1494      *
1495      * NOTE: Renouncing ownership will leave the contract without an owner,
1496      * thereby removing any functionality that is only available to the owner.
1497      */
1498     function renounceOwnership() public virtual onlyOwner {
1499         _transferOwnership(address(0));
1500     }
1501 
1502     /**
1503      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1504      * Can only be called by the current owner.
1505      */
1506     function transferOwnership(address newOwner) public virtual onlyOwner {
1507         require(newOwner != address(0), "Ownable: new owner is the zero address");
1508         _transferOwnership(newOwner);
1509     }
1510 
1511     /**
1512      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1513      * Internal function without access restriction.
1514      */
1515     function _transferOwnership(address newOwner) internal virtual {
1516         address oldOwner = _owner;
1517         _owner = newOwner;
1518         emit OwnershipTransferred(oldOwner, newOwner);
1519     }
1520 }
1521 
1522 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
1523 
1524 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
1525 
1526 pragma solidity ^0.8.0;
1527 
1528 /**
1529  * @dev These functions deal with verification of Merkle Tree proofs.
1530  *
1531  * The proofs can be generated using the JavaScript library
1532  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1533  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1534  *
1535  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1536  *
1537  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1538  * hashing, or use a hash function other than keccak256 for hashing leaves.
1539  * This is because the concatenation of a sorted pair of internal nodes in
1540  * the merkle tree could be reinterpreted as a leaf value.
1541  */
1542 library MerkleProof {
1543     /**
1544      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1545      * defined by `root`. For this, a `proof` must be provided, containing
1546      * sibling hashes on the branch from the leaf to the root of the tree. Each
1547      * pair of leaves and each pair of pre-images are assumed to be sorted.
1548      */
1549     function verify(
1550         bytes32[] memory proof,
1551         bytes32 root,
1552         bytes32 leaf
1553     ) internal pure returns (bool) {
1554         return processProof(proof, leaf) == root;
1555     }
1556 
1557     /**
1558      * @dev Calldata version of {verify}
1559      *
1560      * _Available since v4.7._
1561      */
1562     function verifyCalldata(
1563         bytes32[] calldata proof,
1564         bytes32 root,
1565         bytes32 leaf
1566     ) internal pure returns (bool) {
1567         return processProofCalldata(proof, leaf) == root;
1568     }
1569 
1570     /**
1571      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1572      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1573      * hash matches the root of the tree. When processing the proof, the pairs
1574      * of leafs & pre-images are assumed to be sorted.
1575      *
1576      * _Available since v4.4._
1577      */
1578     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1579         bytes32 computedHash = leaf;
1580         for (uint256 i = 0; i < proof.length; i++) {
1581             computedHash = _hashPair(computedHash, proof[i]);
1582         }
1583         return computedHash;
1584     }
1585 
1586     /**
1587      * @dev Calldata version of {processProof}
1588      *
1589      * _Available since v4.7._
1590      */
1591     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
1592         bytes32 computedHash = leaf;
1593         for (uint256 i = 0; i < proof.length; i++) {
1594             computedHash = _hashPair(computedHash, proof[i]);
1595         }
1596         return computedHash;
1597     }
1598 
1599     /**
1600      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
1601      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
1602      *
1603      * _Available since v4.7._
1604      */
1605     function multiProofVerify(
1606         bytes32[] memory proof,
1607         bool[] memory proofFlags,
1608         bytes32 root,
1609         bytes32[] memory leaves
1610     ) internal pure returns (bool) {
1611         return processMultiProof(proof, proofFlags, leaves) == root;
1612     }
1613 
1614     /**
1615      * @dev Calldata version of {multiProofVerify}
1616      *
1617      * _Available since v4.7._
1618      */
1619     function multiProofVerifyCalldata(
1620         bytes32[] calldata proof,
1621         bool[] calldata proofFlags,
1622         bytes32 root,
1623         bytes32[] memory leaves
1624     ) internal pure returns (bool) {
1625         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
1626     }
1627 
1628     /**
1629      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
1630      * consuming from one or the other at each step according to the instructions given by
1631      * `proofFlags`.
1632      *
1633      * _Available since v4.7._
1634      */
1635     function processMultiProof(
1636         bytes32[] memory proof,
1637         bool[] memory proofFlags,
1638         bytes32[] memory leaves
1639     ) internal pure returns (bytes32 merkleRoot) {
1640         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1641         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1642         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1643         // the merkle tree.
1644         uint256 leavesLen = leaves.length;
1645         uint256 totalHashes = proofFlags.length;
1646 
1647         // Check proof validity.
1648         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1649 
1650         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1651         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1652         bytes32[] memory hashes = new bytes32[](totalHashes);
1653         uint256 leafPos = 0;
1654         uint256 hashPos = 0;
1655         uint256 proofPos = 0;
1656         // At each step, we compute the next hash using two values:
1657         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1658         //   get the next hash.
1659         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1660         //   `proof` array.
1661         for (uint256 i = 0; i < totalHashes; i++) {
1662             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1663             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1664             hashes[i] = _hashPair(a, b);
1665         }
1666 
1667         if (totalHashes > 0) {
1668             return hashes[totalHashes - 1];
1669         } else if (leavesLen > 0) {
1670             return leaves[0];
1671         } else {
1672             return proof[0];
1673         }
1674     }
1675 
1676     /**
1677      * @dev Calldata version of {processMultiProof}
1678      *
1679      * _Available since v4.7._
1680      */
1681     function processMultiProofCalldata(
1682         bytes32[] calldata proof,
1683         bool[] calldata proofFlags,
1684         bytes32[] memory leaves
1685     ) internal pure returns (bytes32 merkleRoot) {
1686         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1687         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1688         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1689         // the merkle tree.
1690         uint256 leavesLen = leaves.length;
1691         uint256 totalHashes = proofFlags.length;
1692 
1693         // Check proof validity.
1694         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1695 
1696         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1697         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1698         bytes32[] memory hashes = new bytes32[](totalHashes);
1699         uint256 leafPos = 0;
1700         uint256 hashPos = 0;
1701         uint256 proofPos = 0;
1702         // At each step, we compute the next hash using two values:
1703         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1704         //   get the next hash.
1705         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1706         //   `proof` array.
1707         for (uint256 i = 0; i < totalHashes; i++) {
1708             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1709             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1710             hashes[i] = _hashPair(a, b);
1711         }
1712 
1713         if (totalHashes > 0) {
1714             return hashes[totalHashes - 1];
1715         } else if (leavesLen > 0) {
1716             return leaves[0];
1717         } else {
1718             return proof[0];
1719         }
1720     }
1721 
1722     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
1723         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
1724     }
1725 
1726     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1727         /// @solidity memory-safe-assembly
1728         assembly {
1729             mstore(0x00, a)
1730             mstore(0x20, b)
1731             value := keccak256(0x00, 0x40)
1732         }
1733     }
1734 }
1735 
1736 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
1737 
1738 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1739 
1740 pragma solidity ^0.8.0;
1741 
1742 /**
1743  * @dev Contract module that helps prevent reentrant calls to a function.
1744  *
1745  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1746  * available, which can be applied to functions to make sure there are no nested
1747  * (reentrant) calls to them.
1748  *
1749  * Note that because there is a single `nonReentrant` guard, functions marked as
1750  * `nonReentrant` may not call one another. This can be worked around by making
1751  * those functions `private`, and then adding `external` `nonReentrant` entry
1752  * points to them.
1753  *
1754  * TIP: If you would like to learn more about reentrancy and alternative ways
1755  * to protect against it, check out our blog post
1756  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1757  */
1758 abstract contract ReentrancyGuard {
1759     // Booleans are more expensive than uint256 or any type that takes up a full
1760     // word because each write operation emits an extra SLOAD to first read the
1761     // slot's contents, replace the bits taken up by the boolean, and then write
1762     // back. This is the compiler's defense against contract upgrades and
1763     // pointer aliasing, and it cannot be disabled.
1764 
1765     // The values being non-zero value makes deployment a bit more expensive,
1766     // but in exchange the refund on every call to nonReentrant will be lower in
1767     // amount. Since refunds are capped to a percentage of the total
1768     // transaction's gas, it is best to keep them low in cases like this one, to
1769     // increase the likelihood of the full refund coming into effect.
1770     uint256 private constant _NOT_ENTERED = 1;
1771     uint256 private constant _ENTERED = 2;
1772 
1773     uint256 private _status;
1774 
1775     constructor() {
1776         _status = _NOT_ENTERED;
1777     }
1778 
1779     /**
1780      * @dev Prevents a contract from calling itself, directly or indirectly.
1781      * Calling a `nonReentrant` function from another `nonReentrant`
1782      * function is not supported. It is possible to prevent this from happening
1783      * by making the `nonReentrant` function external, and making it call a
1784      * `private` function that does the actual work.
1785      */
1786     modifier nonReentrant() {
1787         // On the first call to nonReentrant, _notEntered will be true
1788         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1789 
1790         // Any calls to nonReentrant after this point will fail
1791         _status = _ENTERED;
1792 
1793         _;
1794 
1795         // By storing the original value once again, a refund is triggered (see
1796         // https://eips.ethereum.org/EIPS/eip-2200)
1797         _status = _NOT_ENTERED;
1798     }
1799 }
1800 
1801 // File: @openzeppelin/contracts/utils/Strings.sol
1802 
1803 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
1804 
1805 pragma solidity ^0.8.0;
1806 
1807 /**
1808  * @dev String operations.
1809  */
1810 library Strings {
1811     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1812     uint8 private constant _ADDRESS_LENGTH = 20;
1813 
1814     /**
1815      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1816      */
1817     function toString(uint256 value) internal pure returns (string memory) {
1818         // Inspired by OraclizeAPI's implementation - MIT licence
1819         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1820 
1821         if (value == 0) {
1822             return "0";
1823         }
1824         uint256 temp = value;
1825         uint256 digits;
1826         while (temp != 0) {
1827             digits++;
1828             temp /= 10;
1829         }
1830         bytes memory buffer = new bytes(digits);
1831         while (value != 0) {
1832             digits -= 1;
1833             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1834             value /= 10;
1835         }
1836         return string(buffer);
1837     }
1838 
1839     /**
1840      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1841      */
1842     function toHexString(uint256 value) internal pure returns (string memory) {
1843         if (value == 0) {
1844             return "0x00";
1845         }
1846         uint256 temp = value;
1847         uint256 length = 0;
1848         while (temp != 0) {
1849             length++;
1850             temp >>= 8;
1851         }
1852         return toHexString(value, length);
1853     }
1854 
1855     /**
1856      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1857      */
1858     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1859         bytes memory buffer = new bytes(2 * length + 2);
1860         buffer[0] = "0";
1861         buffer[1] = "x";
1862         for (uint256 i = 2 * length + 1; i > 1; --i) {
1863             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1864             value >>= 4;
1865         }
1866         require(value == 0, "Strings: hex length insufficient");
1867         return string(buffer);
1868     }
1869 
1870     /**
1871      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1872      */
1873     function toHexString(address addr) internal pure returns (string memory) {
1874         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1875     }
1876 }
1877 
1878 // File: contracts/RAREROSES721A.sol
1879 
1880 //                                    .....,,,,,,,,,,,,,,,,,,,,,,.....                                
1881 //                            .,,,,,,,********///*********//********,,,,,,,,,.                        
1882 //                     .,,,,**//****************////*****/////************/**,,,,,,                   
1883 //                 ,,,******************/*,.,,,************,,,,,,,,,**/************,,,                
1884 //              .*********************/,*/**************************,,,,.*/*********/*,,              
1885 //             ***********************.*******************************/*,,,,/*********/*.             
1886 //           ./***********************,,/********************************,,,/***********,.            
1887 //            ,************************,,,*//************/*,************,,.***********.*/.            
1888 //           .*,.*************************,,,,,,,,,,,,,,**/************,.*/******/*,*****,.           
1889 //           .*,,,,.**************************/////*****************/,,/*******,,/********            
1890 //           .*,,,,,,,,,.,*//***********************************/*,*///*,..*/*************            
1891 //           .,,,,,,,,,,,,,,,,,,,,.,,,,******************,,,,,..,,,,*********************/.           
1892 //            ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,********************************/,           
1893 //            ,,,,,,,*/*************///////////******************************************/,.          
1894 //            .,,,,,/********************************************************************/,.          
1895 //             ,,,,**********************************************************************/,.          
1896 //             ,,,,,/********************************************************************/.           
1897 //             .,,,,*********************************************************************/.           
1898 //              ,,,,***************************/*./&@%.****************,/@@@@@*,/*********            
1899 //               ,,,,***************************@@@@@@@(,**************,&@@@@@@%.*********.           
1900 //               ,,,,,/*********************** %@@@@@@%,/**************/,/@@@@@#.*******/.            
1901 //                ,,,,*************************.*#%#,./*******************/,..,*********/.            
1902 //                 ,,,,**************************//************************************/,             
1903 //                 .*,,,****************************************************************              
1904 //                  .,,,,*************************************************************/.              
1905 //                    ,,,,***********************************************************/,               
1906 //                     ,,,,**********************************************************,                
1907 //                      ,,,,,******************************************************/,                 
1908 //                       .*,,,****************************************************/,                  
1909 //                         .,,,,/************************************************/.                   
1910 //                           ,,,,*/********************************************//                     
1911 //                             ,,,,*/*****************************************/.                      
1912 //                              ,,,,,**************************************/,                        
1913 //                                .,,,,**********************************/.                          
1914 //                                    .,,,,,***************************/,..                           
1915 //                                        .,,,,,*******************/*,                                
1916 //                                            ..,,,,,,*********,.                                     
1917 //                                                    ....                                            
1918 
1919 pragma solidity 0.8.15;
1920 
1921 
1922 
1923 
1924 
1925 contract RAREROSES721A is ERC721A, Ownable, ReentrancyGuard {
1926 
1927   using Strings for uint256;
1928 
1929   event StartPresale(address contractAddress);
1930   event EndPresale(address contractAddress);
1931 
1932   bytes32 public merkleRoot;
1933   mapping(address => bool) public whitelistClaimed;
1934   bool public whitelistMintEnabled;
1935   uint8 public constant perWalletPresale = 6;
1936 
1937   uint16 public immutable MAX_SUPPLY;
1938   uint16 public RESERVED;
1939   uint8 public constant maxMintAmountPerTx = 3;
1940   uint256 public price = .06 ether;
1941   bool public mintEnabled;
1942 
1943   string private baseURI;
1944   string private defaultURI;
1945   address public teamWallet;
1946   bool public revealed;
1947  
1948   /**
1949    * @notice Setup ERC721A
1950    */
1951   constructor(
1952       string memory _name,
1953       string memory _symbol,
1954       string memory _defaultURI,
1955       address _teamWallet,
1956       uint16 _max_supply,
1957       uint16 _reserved
1958   ) ERC721A(_name, _symbol) {
1959       require(_teamWallet != address(0), "Zero address error");
1960       defaultURI = _defaultURI; 
1961       teamWallet = _teamWallet;
1962       MAX_SUPPLY = _max_supply;
1963       RESERVED = _reserved;
1964   }
1965 
1966   modifier mintCompliance(uint256 _mintAmount) {
1967     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, 'Invalid mint amount!');
1968     require(_totalMinted() + _mintAmount <= MAX_SUPPLY - RESERVED, 'Max supply exceeded!');
1969     _;
1970   }
1971 
1972   modifier mintPriceCompliance(uint256 _mintAmount) {
1973     require(msg.value >= price * _mintAmount, 'Insufficient funds!');
1974     _;
1975   }
1976 
1977   /**
1978    * @notice Make New Rare Roses 
1979    * @param amount Amount of Rare Roses to mint
1980    * @dev Utilize unchecked {} and calldata for gas savings.
1981    */
1982   function mint(uint256 amount) public payable mintCompliance(amount) mintPriceCompliance(amount) {
1983     require(mintEnabled, "Minting is disabled.");
1984     _safeMint(_msgSenderERC721A(), amount);
1985   }
1986 
1987   function whitelistMint(uint256 _mintAmount, bytes32[] calldata _merkleProof) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount) {
1988     // Verify whitelist requirements
1989     require(whitelistMintEnabled, 'The whitelist sale is not enabled!');
1990     require(
1991             balanceOf(_msgSenderERC721A()) + _mintAmount <=  perWalletPresale,
1992             "Amount exceeds current maximum mints per account."
1993         );
1994     bytes32 leaf = keccak256(abi.encodePacked(_msgSenderERC721A()));
1995     require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), 'Invalid proof!');
1996 
1997     whitelistClaimed[_msgSenderERC721A()] = true;
1998     _safeMint(_msgSenderERC721A(), _mintAmount);
1999   }
2000 
2001   function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
2002     merkleRoot = _merkleRoot;
2003   }
2004 
2005   /**
2006    * @notice Send ETH to team wallet 
2007    */
2008   function teamWithdraw() public onlyOwner {
2009       uint256 balance = address(this).balance;
2010       payable(teamWallet).transfer(balance);
2011   }
2012 
2013   /**
2014    * @notice Set team wallet.
2015    * @param _teamWallet new team wallet address 
2016    * @dev Only authorized accounts.
2017    */
2018   function setTeamWallet(address _teamWallet) public onlyOwner {
2019       require(_teamWallet != address(0), "Zero address error");
2020       teamWallet = _teamWallet;
2021   }
2022 
2023   /**
2024    * @notice Send RESERVED Rare Roses 
2025    * @param _to address to send reserved nfts to.
2026    * @param _amount number of nfts to send 
2027    */
2028   function fetchReserved(address _to, uint16 _amount) public onlyOwner
2029   {
2030       require( _to !=  address(0), "Zero address error");
2031       require( _amount <= RESERVED, "Exceeds reserved supply");
2032       _safeMint(_to, _amount);
2033       RESERVED -= _amount;
2034   }
2035 
2036   /**
2037    * @notice Ends presale.
2038    */
2039   function toggleWhitelistMint() public onlyOwner {
2040       whitelistMintEnabled = !whitelistMintEnabled;
2041       if (whitelistMintEnabled) {
2042         emit StartPresale(address(this));
2043       } else {
2044         emit EndPresale(address(this));
2045       }
2046   }
2047 
2048   /**
2049    * @notice Set price.
2050    * @param newPrice new minting price
2051    * @dev Only authorized accounts.
2052    */
2053   function setPrice(uint256 newPrice) public onlyOwner {
2054       price = newPrice;
2055   }
2056 
2057   /**
2058    * @notice Toggles minting state.
2059    */
2060   function toggleMintEnabled() public onlyOwner {
2061       mintEnabled = !mintEnabled;
2062   }
2063 
2064   /**
2065    * @notice Toggles revealed state.
2066    */
2067   function toggleRevealed() public onlyOwner {
2068       revealed = !revealed;
2069   }
2070 
2071   /**
2072    * @notice Set base URI.
2073    */
2074   function setBaseURI(string memory _newUri) public onlyOwner {
2075       baseURI = _newUri;
2076   }
2077 
2078   /**
2079    * @notice Set default URI.
2080    */
2081   function setDefaultURI(string memory _newUri) public onlyOwner {
2082       defaultURI = _newUri;
2083   }
2084 
2085   function _baseURI() internal view virtual override returns (string memory) {
2086         return baseURI;
2087   }
2088 
2089   function _startTokenId() internal view virtual override returns (uint256) {
2090       return 1;
2091   }
2092 
2093   /**
2094    * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
2095    */
2096   function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2097       if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
2098       if (!revealed) {
2099             return defaultURI;
2100         } 
2101       string memory bURI = _baseURI();
2102       return bytes(bURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : ''; }
2103 
2104   receive() external payable {}
2105 
2106   fallback() external payable {}
2107 }