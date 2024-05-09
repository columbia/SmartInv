1 /**
2  *Submitted for verification at Etherscan.io on 2023-03-18
3 */
4 
5 // SPDX-License-Identifier: MIT
6 // File: contracts/WithdrawFairly.sol
7 
8 
9 pragma solidity ^0.8.7;
10 
11 interface IERC20 {
12     function balanceOf(address account) external view returns (uint256);
13     function transfer(address to, uint256 amount) external returns (bool);
14 }
15 
16 /**
17  * @title WithdrawFairly
18  * @author 0x0
19  */
20 contract WithdrawFairly {
21     error Unauthorized();
22     error ZeroBalance();
23     error TransferFailed();
24 
25     struct Part {
26         address wallet;
27         uint8 salesPart;
28         uint8 royaltiesPart;
29     }
30 
31     Part[] public parts;
32     mapping(address => bool) public callers;
33 
34     constructor() payable {
35         parts.push(Part(0x792AE50eA3358455177aeabE8F9a871338CB002e, 20, 15));
36         callers[0x792AE50eA3358455177aeabE8F9a871338CB002e] = true;
37         parts.push(Part(0xE1580cA711094CF2888716a54c5A892245653435, 49, 65));
38         callers[0xE1580cA711094CF2888716a54c5A892245653435] = true;
39         parts.push(Part(0x963363fc0BDf5D4b48Ef3dc5CA374e909f13e730, 5, 5));
40         parts.push(Part(0x95B5b3c1Dc12c6124B077133aBc86e809382934E, 5, 5));
41         parts.push(Part(0xef581EBE97F20a7EFF93Fe9149F07F34cD78CaE1, 10, 5));
42         parts.push(Part(0x23a2f69Dbb116Ff3c878560f23B9BA3a3803020A, 1, 0));
43         parts.push(Part(0x44d32341F2248937286aEEdd53eC9367bEFC30e8, 10, 5));
44     }
45 
46     function shareETHSalesPart() external {
47         if (!callers[msg.sender])
48             revert Unauthorized();
49 
50         uint256 balance = address(this).balance;
51 
52         if (balance == 0) revert ZeroBalance();
53 
54         Part memory part;
55 
56         for (uint256 i; i < parts.length;) {
57             part = parts[i];
58 
59             // Below will never realistically overflows
60             unchecked {
61                 if (part.salesPart != 0) {
62                     _withdraw(
63                         part.wallet,
64                         balance * part.salesPart / 100
65                     );
66                 }
67 
68                 ++i;
69             }
70         }
71     }
72 
73     function shareETHRoyaltiesPart() external {
74         if (!callers[msg.sender]) revert Unauthorized();
75 
76         uint256 balance = address(this).balance;
77 
78         if (balance == 0) revert ZeroBalance();
79 
80         Part memory part;
81 
82         for (uint256 i; i < parts.length;) {
83             part = parts[i];
84 
85             unchecked {
86                 if (part.royaltiesPart != 0) {
87                     _withdraw(
88                         part.wallet,
89                         balance * part.royaltiesPart / 100
90                     );
91                 }
92 
93                 ++i;
94             }
95         }
96     }
97 
98      function shareTokenRoyaltiesPart(address token) external {
99         if (!callers[msg.sender]) revert Unauthorized();
100 
101         IERC20 tokenContract = IERC20(token);
102 
103         uint256 balance = tokenContract.balanceOf(address(this));
104 
105         if (balance == 0) revert ZeroBalance();
106 
107         Part memory part;
108 
109         for (uint256 i; i < parts.length;) {
110             part = parts[i];
111 
112             if (part.royaltiesPart != 0) {
113                 if (!tokenContract.transfer(
114                     part.wallet,
115                     balance * part.royaltiesPart / 100
116                 )) revert TransferFailed();
117             }
118 
119             unchecked {
120                 ++i;
121             }
122         }
123     }
124 
125     function _withdraw(address _address, uint256 _amount) private {
126         (bool success, ) = _address.call{value: _amount}("");
127 
128         if (!success) revert TransferFailed();
129     }
130 
131     receive() external payable {}
132 
133 }
134 
135 // File: erc721a/contracts/IERC721A.sol
136 
137 
138 // ERC721A Contracts v4.2.3
139 // Creator: Chiru Labs
140 
141 pragma solidity ^0.8.4;
142 
143 /**
144  * @dev Interface of ERC721A.
145  */
146 interface IERC721A {
147     /**
148      * The caller must own the token or be an approved operator.
149      */
150     error ApprovalCallerNotOwnerNorApproved();
151 
152     /**
153      * The token does not exist.
154      */
155     error ApprovalQueryForNonexistentToken();
156 
157     /**
158      * Cannot query the balance for the zero address.
159      */
160     error BalanceQueryForZeroAddress();
161 
162     /**
163      * Cannot mint to the zero address.
164      */
165     error MintToZeroAddress();
166 
167     /**
168      * The quantity of tokens minted must be more than zero.
169      */
170     error MintZeroQuantity();
171 
172     /**
173      * The token does not exist.
174      */
175     error OwnerQueryForNonexistentToken();
176 
177     /**
178      * The caller must own the token or be an approved operator.
179      */
180     error TransferCallerNotOwnerNorApproved();
181 
182     /**
183      * The token must be owned by `from`.
184      */
185     error TransferFromIncorrectOwner();
186 
187     /**
188      * Cannot safely transfer to a contract that does not implement the
189      * ERC721Receiver interface.
190      */
191     error TransferToNonERC721ReceiverImplementer();
192 
193     /**
194      * Cannot transfer to the zero address.
195      */
196     error TransferToZeroAddress();
197 
198     /**
199      * The token does not exist.
200      */
201     error URIQueryForNonexistentToken();
202 
203     /**
204      * The `quantity` minted with ERC2309 exceeds the safety limit.
205      */
206     error MintERC2309QuantityExceedsLimit();
207 
208     /**
209      * The `extraData` cannot be set on an unintialized ownership slot.
210      */
211     error OwnershipNotInitializedForExtraData();
212 
213     // =============================================================
214     //                            STRUCTS
215     // =============================================================
216 
217     struct TokenOwnership {
218         // The address of the owner.
219         address addr;
220         // Stores the start time of ownership with minimal overhead for tokenomics.
221         uint64 startTimestamp;
222         // Whether the token has been burned.
223         bool burned;
224         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
225         uint24 extraData;
226     }
227 
228     // =============================================================
229     //                         TOKEN COUNTERS
230     // =============================================================
231 
232     /**
233      * @dev Returns the total number of tokens in existence.
234      * Burned tokens will reduce the count.
235      * To get the total number of tokens minted, please see {_totalMinted}.
236      */
237     function totalSupply() external view returns (uint256);
238 
239     // =============================================================
240     //                            IERC165
241     // =============================================================
242 
243     /**
244      * @dev Returns true if this contract implements the interface defined by
245      * `interfaceId`. See the corresponding
246      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
247      * to learn more about how these ids are created.
248      *
249      * This function call must use less than 30000 gas.
250      */
251     function supportsInterface(bytes4 interfaceId) external view returns (bool);
252 
253     // =============================================================
254     //                            IERC721
255     // =============================================================
256 
257     /**
258      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
259      */
260     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
261 
262     /**
263      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
264      */
265     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
266 
267     /**
268      * @dev Emitted when `owner` enables or disables
269      * (`approved`) `operator` to manage all of its assets.
270      */
271     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
272 
273     /**
274      * @dev Returns the number of tokens in `owner`'s account.
275      */
276     function balanceOf(address owner) external view returns (uint256 balance);
277 
278     /**
279      * @dev Returns the owner of the `tokenId` token.
280      *
281      * Requirements:
282      *
283      * - `tokenId` must exist.
284      */
285     function ownerOf(uint256 tokenId) external view returns (address owner);
286 
287     /**
288      * @dev Safely transfers `tokenId` token from `from` to `to`,
289      * checking first that contract recipients are aware of the ERC721 protocol
290      * to prevent tokens from being forever locked.
291      *
292      * Requirements:
293      *
294      * - `from` cannot be the zero address.
295      * - `to` cannot be the zero address.
296      * - `tokenId` token must exist and be owned by `from`.
297      * - If the caller is not `from`, it must be have been allowed to move
298      * this token by either {approve} or {setApprovalForAll}.
299      * - If `to` refers to a smart contract, it must implement
300      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
301      *
302      * Emits a {Transfer} event.
303      */
304     function safeTransferFrom(
305         address from,
306         address to,
307         uint256 tokenId,
308         bytes calldata data
309     ) external payable;
310 
311     /**
312      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
313      */
314     function safeTransferFrom(
315         address from,
316         address to,
317         uint256 tokenId
318     ) external payable;
319 
320     /**
321      * @dev Transfers `tokenId` from `from` to `to`.
322      *
323      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
324      * whenever possible.
325      *
326      * Requirements:
327      *
328      * - `from` cannot be the zero address.
329      * - `to` cannot be the zero address.
330      * - `tokenId` token must be owned by `from`.
331      * - If the caller is not `from`, it must be approved to move this token
332      * by either {approve} or {setApprovalForAll}.
333      *
334      * Emits a {Transfer} event.
335      */
336     function transferFrom(
337         address from,
338         address to,
339         uint256 tokenId
340     ) external payable;
341 
342     /**
343      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
344      * The approval is cleared when the token is transferred.
345      *
346      * Only a single account can be approved at a time, so approving the
347      * zero address clears previous approvals.
348      *
349      * Requirements:
350      *
351      * - The caller must own the token or be an approved operator.
352      * - `tokenId` must exist.
353      *
354      * Emits an {Approval} event.
355      */
356     function approve(address to, uint256 tokenId) external payable;
357 
358     /**
359      * @dev Approve or remove `operator` as an operator for the caller.
360      * Operators can call {transferFrom} or {safeTransferFrom}
361      * for any token owned by the caller.
362      *
363      * Requirements:
364      *
365      * - The `operator` cannot be the caller.
366      *
367      * Emits an {ApprovalForAll} event.
368      */
369     function setApprovalForAll(address operator, bool _approved) external;
370 
371     /**
372      * @dev Returns the account approved for `tokenId` token.
373      *
374      * Requirements:
375      *
376      * - `tokenId` must exist.
377      */
378     function getApproved(uint256 tokenId) external view returns (address operator);
379 
380     /**
381      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
382      *
383      * See {setApprovalForAll}.
384      */
385     function isApprovedForAll(address owner, address operator) external view returns (bool);
386 
387     // =============================================================
388     //                        IERC721Metadata
389     // =============================================================
390 
391     /**
392      * @dev Returns the token collection name.
393      */
394     function name() external view returns (string memory);
395 
396     /**
397      * @dev Returns the token collection symbol.
398      */
399     function symbol() external view returns (string memory);
400 
401     /**
402      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
403      */
404     function tokenURI(uint256 tokenId) external view returns (string memory);
405 
406     // =============================================================
407     //                           IERC2309
408     // =============================================================
409 
410     /**
411      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
412      * (inclusive) is transferred from `from` to `to`, as defined in the
413      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
414      *
415      * See {_mintERC2309} for more details.
416      */
417     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
418 }
419 
420 // File: erc721a/contracts/ERC721A.sol
421 
422 
423 // ERC721A Contracts v4.2.3
424 // Creator: Chiru Labs
425 
426 pragma solidity ^0.8.4;
427 
428 
429 /**
430  * @dev Interface of ERC721 token receiver.
431  */
432 interface ERC721A__IERC721Receiver {
433     function onERC721Received(
434         address operator,
435         address from,
436         uint256 tokenId,
437         bytes calldata data
438     ) external returns (bytes4);
439 }
440 
441 /**
442  * @title ERC721A
443  *
444  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
445  * Non-Fungible Token Standard, including the Metadata extension.
446  * Optimized for lower gas during batch mints.
447  *
448  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
449  * starting from `_startTokenId()`.
450  *
451  * Assumptions:
452  *
453  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
454  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
455  */
456 contract ERC721A is IERC721A {
457     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
458     struct TokenApprovalRef {
459         address value;
460     }
461 
462     // =============================================================
463     //                           CONSTANTS
464     // =============================================================
465 
466     // Mask of an entry in packed address data.
467     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
468 
469     // The bit position of `numberMinted` in packed address data.
470     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
471 
472     // The bit position of `numberBurned` in packed address data.
473     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
474 
475     // The bit position of `aux` in packed address data.
476     uint256 private constant _BITPOS_AUX = 192;
477 
478     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
479     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
480 
481     // The bit position of `startTimestamp` in packed ownership.
482     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
483 
484     // The bit mask of the `burned` bit in packed ownership.
485     uint256 private constant _BITMASK_BURNED = 1 << 224;
486 
487     // The bit position of the `nextInitialized` bit in packed ownership.
488     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
489 
490     // The bit mask of the `nextInitialized` bit in packed ownership.
491     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
492 
493     // The bit position of `extraData` in packed ownership.
494     uint256 private constant _BITPOS_EXTRA_DATA = 232;
495 
496     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
497     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
498 
499     // The mask of the lower 160 bits for addresses.
500     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
501 
502     // The maximum `quantity` that can be minted with {_mintERC2309}.
503     // This limit is to prevent overflows on the address data entries.
504     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
505     // is required to cause an overflow, which is unrealistic.
506     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
507 
508     // The `Transfer` event signature is given by:
509     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
510     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
511         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
512 
513     // =============================================================
514     //                            STORAGE
515     // =============================================================
516 
517     // The next token ID to be minted.
518     uint256 private _currentIndex;
519 
520     // The number of tokens burned.
521     uint256 private _burnCounter;
522 
523     // Token name
524     string private _name;
525 
526     // Token symbol
527     string private _symbol;
528 
529     // Mapping from token ID to ownership details
530     // An empty struct value does not necessarily mean the token is unowned.
531     // See {_packedOwnershipOf} implementation for details.
532     //
533     // Bits Layout:
534     // - [0..159]   `addr`
535     // - [160..223] `startTimestamp`
536     // - [224]      `burned`
537     // - [225]      `nextInitialized`
538     // - [232..255] `extraData`
539     mapping(uint256 => uint256) private _packedOwnerships;
540 
541     // Mapping owner address to address data.
542     //
543     // Bits Layout:
544     // - [0..63]    `balance`
545     // - [64..127]  `numberMinted`
546     // - [128..191] `numberBurned`
547     // - [192..255] `aux`
548     mapping(address => uint256) private _packedAddressData;
549 
550     // Mapping from token ID to approved address.
551     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
552 
553     // Mapping from owner to operator approvals
554     mapping(address => mapping(address => bool)) private _operatorApprovals;
555 
556     // =============================================================
557     //                          CONSTRUCTOR
558     // =============================================================
559 
560     constructor(string memory name_, string memory symbol_) {
561         _name = name_;
562         _symbol = symbol_;
563         _currentIndex = _startTokenId();
564     }
565 
566     // =============================================================
567     //                   TOKEN COUNTING OPERATIONS
568     // =============================================================
569 
570     /**
571      * @dev Returns the starting token ID.
572      * To change the starting token ID, please override this function.
573      */
574     function _startTokenId() internal view virtual returns (uint256) {
575         return 0;
576     }
577 
578     /**
579      * @dev Returns the next token ID to be minted.
580      */
581     function _nextTokenId() internal view virtual returns (uint256) {
582         return _currentIndex;
583     }
584 
585     /**
586      * @dev Returns the total number of tokens in existence.
587      * Burned tokens will reduce the count.
588      * To get the total number of tokens minted, please see {_totalMinted}.
589      */
590     function totalSupply() public view virtual override returns (uint256) {
591         // Counter underflow is impossible as _burnCounter cannot be incremented
592         // more than `_currentIndex - _startTokenId()` times.
593         unchecked {
594             return _currentIndex - _burnCounter - _startTokenId();
595         }
596     }
597 
598     /**
599      * @dev Returns the total amount of tokens minted in the contract.
600      */
601     function _totalMinted() internal view virtual returns (uint256) {
602         // Counter underflow is impossible as `_currentIndex` does not decrement,
603         // and it is initialized to `_startTokenId()`.
604         unchecked {
605             return _currentIndex - _startTokenId();
606         }
607     }
608 
609     /**
610      * @dev Returns the total number of tokens burned.
611      */
612     function _totalBurned() internal view virtual returns (uint256) {
613         return _burnCounter;
614     }
615 
616     // =============================================================
617     //                    ADDRESS DATA OPERATIONS
618     // =============================================================
619 
620     /**
621      * @dev Returns the number of tokens in `owner`'s account.
622      */
623     function balanceOf(address owner) public view virtual override returns (uint256) {
624         if (owner == address(0)) revert BalanceQueryForZeroAddress();
625         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
626     }
627 
628     /**
629      * Returns the number of tokens minted by `owner`.
630      */
631     function _numberMinted(address owner) internal view returns (uint256) {
632         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
633     }
634 
635     /**
636      * Returns the number of tokens burned by or on behalf of `owner`.
637      */
638     function _numberBurned(address owner) internal view returns (uint256) {
639         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
640     }
641 
642     /**
643      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
644      */
645     function _getAux(address owner) internal view returns (uint64) {
646         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
647     }
648 
649     /**
650      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
651      * If there are multiple variables, please pack them into a uint64.
652      */
653     function _setAux(address owner, uint64 aux) internal virtual {
654         uint256 packed = _packedAddressData[owner];
655         uint256 auxCasted;
656         // Cast `aux` with assembly to avoid redundant masking.
657         assembly {
658             auxCasted := aux
659         }
660         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
661         _packedAddressData[owner] = packed;
662     }
663 
664     // =============================================================
665     //                            IERC165
666     // =============================================================
667 
668     /**
669      * @dev Returns true if this contract implements the interface defined by
670      * `interfaceId`. See the corresponding
671      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
672      * to learn more about how these ids are created.
673      *
674      * This function call must use less than 30000 gas.
675      */
676     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
677         // The interface IDs are constants representing the first 4 bytes
678         // of the XOR of all function selectors in the interface.
679         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
680         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
681         return
682             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
683             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
684             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
685     }
686 
687     // =============================================================
688     //                        IERC721Metadata
689     // =============================================================
690 
691     /**
692      * @dev Returns the token collection name.
693      */
694     function name() public view virtual override returns (string memory) {
695         return _name;
696     }
697 
698     /**
699      * @dev Returns the token collection symbol.
700      */
701     function symbol() public view virtual override returns (string memory) {
702         return _symbol;
703     }
704 
705     /**
706      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
707      */
708     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
709         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
710 
711         string memory baseURI = _baseURI();
712         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
713     }
714 
715     /**
716      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
717      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
718      * by default, it can be overridden in child contracts.
719      */
720     function _baseURI() internal view virtual returns (string memory) {
721         return '';
722     }
723 
724     // =============================================================
725     //                     OWNERSHIPS OPERATIONS
726     // =============================================================
727 
728     /**
729      * @dev Returns the owner of the `tokenId` token.
730      *
731      * Requirements:
732      *
733      * - `tokenId` must exist.
734      */
735     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
736         return address(uint160(_packedOwnershipOf(tokenId)));
737     }
738 
739     /**
740      * @dev Gas spent here starts off proportional to the maximum mint batch size.
741      * It gradually moves to O(1) as tokens get transferred around over time.
742      */
743     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
744         return _unpackedOwnership(_packedOwnershipOf(tokenId));
745     }
746 
747     /**
748      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
749      */
750     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
751         return _unpackedOwnership(_packedOwnerships[index]);
752     }
753 
754     /**
755      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
756      */
757     function _initializeOwnershipAt(uint256 index) internal virtual {
758         if (_packedOwnerships[index] == 0) {
759             _packedOwnerships[index] = _packedOwnershipOf(index);
760         }
761     }
762 
763     /**
764      * Returns the packed ownership data of `tokenId`.
765      */
766     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
767         uint256 curr = tokenId;
768 
769         unchecked {
770             if (_startTokenId() <= curr)
771                 if (curr < _currentIndex) {
772                     uint256 packed = _packedOwnerships[curr];
773                     // If not burned.
774                     if (packed & _BITMASK_BURNED == 0) {
775                         // Invariant:
776                         // There will always be an initialized ownership slot
777                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
778                         // before an unintialized ownership slot
779                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
780                         // Hence, `curr` will not underflow.
781                         //
782                         // We can directly compare the packed value.
783                         // If the address is zero, packed will be zero.
784                         while (packed == 0) {
785                             packed = _packedOwnerships[--curr];
786                         }
787                         return packed;
788                     }
789                 }
790         }
791         revert OwnerQueryForNonexistentToken();
792     }
793 
794     /**
795      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
796      */
797     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
798         ownership.addr = address(uint160(packed));
799         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
800         ownership.burned = packed & _BITMASK_BURNED != 0;
801         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
802     }
803 
804     /**
805      * @dev Packs ownership data into a single uint256.
806      */
807     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
808         assembly {
809             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
810             owner := and(owner, _BITMASK_ADDRESS)
811             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
812             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
813         }
814     }
815 
816     /**
817      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
818      */
819     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
820         // For branchless setting of the `nextInitialized` flag.
821         assembly {
822             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
823             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
824         }
825     }
826 
827     // =============================================================
828     //                      APPROVAL OPERATIONS
829     // =============================================================
830 
831     /**
832      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
833      * The approval is cleared when the token is transferred.
834      *
835      * Only a single account can be approved at a time, so approving the
836      * zero address clears previous approvals.
837      *
838      * Requirements:
839      *
840      * - The caller must own the token or be an approved operator.
841      * - `tokenId` must exist.
842      *
843      * Emits an {Approval} event.
844      */
845     function approve(address to, uint256 tokenId) public payable virtual override {
846         address owner = ownerOf(tokenId);
847 
848         if (_msgSenderERC721A() != owner)
849             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
850                 revert ApprovalCallerNotOwnerNorApproved();
851             }
852 
853         _tokenApprovals[tokenId].value = to;
854         emit Approval(owner, to, tokenId);
855     }
856 
857     /**
858      * @dev Returns the account approved for `tokenId` token.
859      *
860      * Requirements:
861      *
862      * - `tokenId` must exist.
863      */
864     function getApproved(uint256 tokenId) public view virtual override returns (address) {
865         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
866 
867         return _tokenApprovals[tokenId].value;
868     }
869 
870     /**
871      * @dev Approve or remove `operator` as an operator for the caller.
872      * Operators can call {transferFrom} or {safeTransferFrom}
873      * for any token owned by the caller.
874      *
875      * Requirements:
876      *
877      * - The `operator` cannot be the caller.
878      *
879      * Emits an {ApprovalForAll} event.
880      */
881     function setApprovalForAll(address operator, bool approved) public virtual override {
882         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
883         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
884     }
885 
886     /**
887      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
888      *
889      * See {setApprovalForAll}.
890      */
891     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
892         return _operatorApprovals[owner][operator];
893     }
894 
895     /**
896      * @dev Returns whether `tokenId` exists.
897      *
898      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
899      *
900      * Tokens start existing when they are minted. See {_mint}.
901      */
902     function _exists(uint256 tokenId) internal view virtual returns (bool) {
903         return
904             _startTokenId() <= tokenId &&
905             tokenId < _currentIndex && // If within bounds,
906             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
907     }
908 
909     /**
910      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
911      */
912     function _isSenderApprovedOrOwner(
913         address approvedAddress,
914         address owner,
915         address msgSender
916     ) private pure returns (bool result) {
917         assembly {
918             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
919             owner := and(owner, _BITMASK_ADDRESS)
920             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
921             msgSender := and(msgSender, _BITMASK_ADDRESS)
922             // `msgSender == owner || msgSender == approvedAddress`.
923             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
924         }
925     }
926 
927     /**
928      * @dev Returns the storage slot and value for the approved address of `tokenId`.
929      */
930     function _getApprovedSlotAndAddress(uint256 tokenId)
931         private
932         view
933         returns (uint256 approvedAddressSlot, address approvedAddress)
934     {
935         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
936         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
937         assembly {
938             approvedAddressSlot := tokenApproval.slot
939             approvedAddress := sload(approvedAddressSlot)
940         }
941     }
942 
943     // =============================================================
944     //                      TRANSFER OPERATIONS
945     // =============================================================
946 
947     /**
948      * @dev Transfers `tokenId` from `from` to `to`.
949      *
950      * Requirements:
951      *
952      * - `from` cannot be the zero address.
953      * - `to` cannot be the zero address.
954      * - `tokenId` token must be owned by `from`.
955      * - If the caller is not `from`, it must be approved to move this token
956      * by either {approve} or {setApprovalForAll}.
957      *
958      * Emits a {Transfer} event.
959      */
960     function transferFrom(
961         address from,
962         address to,
963         uint256 tokenId
964     ) public payable virtual override {
965         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
966 
967         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
968 
969         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
970 
971         // The nested ifs save around 20+ gas over a compound boolean condition.
972         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
973             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
974 
975         if (to == address(0)) revert TransferToZeroAddress();
976 
977         _beforeTokenTransfers(from, to, tokenId, 1);
978 
979         // Clear approvals from the previous owner.
980         assembly {
981             if approvedAddress {
982                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
983                 sstore(approvedAddressSlot, 0)
984             }
985         }
986 
987         // Underflow of the sender's balance is impossible because we check for
988         // ownership above and the recipient's balance can't realistically overflow.
989         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
990         unchecked {
991             // We can directly increment and decrement the balances.
992             --_packedAddressData[from]; // Updates: `balance -= 1`.
993             ++_packedAddressData[to]; // Updates: `balance += 1`.
994 
995             // Updates:
996             // - `address` to the next owner.
997             // - `startTimestamp` to the timestamp of transfering.
998             // - `burned` to `false`.
999             // - `nextInitialized` to `true`.
1000             _packedOwnerships[tokenId] = _packOwnershipData(
1001                 to,
1002                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1003             );
1004 
1005             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1006             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1007                 uint256 nextTokenId = tokenId + 1;
1008                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1009                 if (_packedOwnerships[nextTokenId] == 0) {
1010                     // If the next slot is within bounds.
1011                     if (nextTokenId != _currentIndex) {
1012                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1013                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1014                     }
1015                 }
1016             }
1017         }
1018 
1019         emit Transfer(from, to, tokenId);
1020         _afterTokenTransfers(from, to, tokenId, 1);
1021     }
1022 
1023     /**
1024      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1025      */
1026     function safeTransferFrom(
1027         address from,
1028         address to,
1029         uint256 tokenId
1030     ) public payable virtual override {
1031         safeTransferFrom(from, to, tokenId, '');
1032     }
1033 
1034     /**
1035      * @dev Safely transfers `tokenId` token from `from` to `to`.
1036      *
1037      * Requirements:
1038      *
1039      * - `from` cannot be the zero address.
1040      * - `to` cannot be the zero address.
1041      * - `tokenId` token must exist and be owned by `from`.
1042      * - If the caller is not `from`, it must be approved to move this token
1043      * by either {approve} or {setApprovalForAll}.
1044      * - If `to` refers to a smart contract, it must implement
1045      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1046      *
1047      * Emits a {Transfer} event.
1048      */
1049     function safeTransferFrom(
1050         address from,
1051         address to,
1052         uint256 tokenId,
1053         bytes memory _data
1054     ) public payable virtual override {
1055         transferFrom(from, to, tokenId);
1056         if (to.code.length != 0)
1057             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1058                 revert TransferToNonERC721ReceiverImplementer();
1059             }
1060     }
1061 
1062     /**
1063      * @dev Hook that is called before a set of serially-ordered token IDs
1064      * are about to be transferred. This includes minting.
1065      * And also called before burning one token.
1066      *
1067      * `startTokenId` - the first token ID to be transferred.
1068      * `quantity` - the amount to be transferred.
1069      *
1070      * Calling conditions:
1071      *
1072      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1073      * transferred to `to`.
1074      * - When `from` is zero, `tokenId` will be minted for `to`.
1075      * - When `to` is zero, `tokenId` will be burned by `from`.
1076      * - `from` and `to` are never both zero.
1077      */
1078     function _beforeTokenTransfers(
1079         address from,
1080         address to,
1081         uint256 startTokenId,
1082         uint256 quantity
1083     ) internal virtual {}
1084 
1085     /**
1086      * @dev Hook that is called after a set of serially-ordered token IDs
1087      * have been transferred. This includes minting.
1088      * And also called after one token has been burned.
1089      *
1090      * `startTokenId` - the first token ID to be transferred.
1091      * `quantity` - the amount to be transferred.
1092      *
1093      * Calling conditions:
1094      *
1095      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1096      * transferred to `to`.
1097      * - When `from` is zero, `tokenId` has been minted for `to`.
1098      * - When `to` is zero, `tokenId` has been burned by `from`.
1099      * - `from` and `to` are never both zero.
1100      */
1101     function _afterTokenTransfers(
1102         address from,
1103         address to,
1104         uint256 startTokenId,
1105         uint256 quantity
1106     ) internal virtual {}
1107 
1108     /**
1109      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1110      *
1111      * `from` - Previous owner of the given token ID.
1112      * `to` - Target address that will receive the token.
1113      * `tokenId` - Token ID to be transferred.
1114      * `_data` - Optional data to send along with the call.
1115      *
1116      * Returns whether the call correctly returned the expected magic value.
1117      */
1118     function _checkContractOnERC721Received(
1119         address from,
1120         address to,
1121         uint256 tokenId,
1122         bytes memory _data
1123     ) private returns (bool) {
1124         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1125             bytes4 retval
1126         ) {
1127             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1128         } catch (bytes memory reason) {
1129             if (reason.length == 0) {
1130                 revert TransferToNonERC721ReceiverImplementer();
1131             } else {
1132                 assembly {
1133                     revert(add(32, reason), mload(reason))
1134                 }
1135             }
1136         }
1137     }
1138 
1139     // =============================================================
1140     //                        MINT OPERATIONS
1141     // =============================================================
1142 
1143     /**
1144      * @dev Mints `quantity` tokens and transfers them to `to`.
1145      *
1146      * Requirements:
1147      *
1148      * - `to` cannot be the zero address.
1149      * - `quantity` must be greater than 0.
1150      *
1151      * Emits a {Transfer} event for each mint.
1152      */
1153     function _mint(address to, uint256 quantity) internal virtual {
1154         uint256 startTokenId = _currentIndex;
1155         if (quantity == 0) revert MintZeroQuantity();
1156 
1157         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1158 
1159         // Overflows are incredibly unrealistic.
1160         // `balance` and `numberMinted` have a maximum limit of 2**64.
1161         // `tokenId` has a maximum limit of 2**256.
1162         unchecked {
1163             // Updates:
1164             // - `balance += quantity`.
1165             // - `numberMinted += quantity`.
1166             //
1167             // We can directly add to the `balance` and `numberMinted`.
1168             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1169 
1170             // Updates:
1171             // - `address` to the owner.
1172             // - `startTimestamp` to the timestamp of minting.
1173             // - `burned` to `false`.
1174             // - `nextInitialized` to `quantity == 1`.
1175             _packedOwnerships[startTokenId] = _packOwnershipData(
1176                 to,
1177                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1178             );
1179 
1180             uint256 toMasked;
1181             uint256 end = startTokenId + quantity;
1182 
1183             // Use assembly to loop and emit the `Transfer` event for gas savings.
1184             // The duplicated `log4` removes an extra check and reduces stack juggling.
1185             // The assembly, together with the surrounding Solidity code, have been
1186             // delicately arranged to nudge the compiler into producing optimized opcodes.
1187             assembly {
1188                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1189                 toMasked := and(to, _BITMASK_ADDRESS)
1190                 // Emit the `Transfer` event.
1191                 log4(
1192                     0, // Start of data (0, since no data).
1193                     0, // End of data (0, since no data).
1194                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1195                     0, // `address(0)`.
1196                     toMasked, // `to`.
1197                     startTokenId // `tokenId`.
1198                 )
1199 
1200                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1201                 // that overflows uint256 will make the loop run out of gas.
1202                 // The compiler will optimize the `iszero` away for performance.
1203                 for {
1204                     let tokenId := add(startTokenId, 1)
1205                 } iszero(eq(tokenId, end)) {
1206                     tokenId := add(tokenId, 1)
1207                 } {
1208                     // Emit the `Transfer` event. Similar to above.
1209                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1210                 }
1211             }
1212             if (toMasked == 0) revert MintToZeroAddress();
1213 
1214             _currentIndex = end;
1215         }
1216         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1217     }
1218 
1219     /**
1220      * @dev Mints `quantity` tokens and transfers them to `to`.
1221      *
1222      * This function is intended for efficient minting only during contract creation.
1223      *
1224      * It emits only one {ConsecutiveTransfer} as defined in
1225      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1226      * instead of a sequence of {Transfer} event(s).
1227      *
1228      * Calling this function outside of contract creation WILL make your contract
1229      * non-compliant with the ERC721 standard.
1230      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1231      * {ConsecutiveTransfer} event is only permissible during contract creation.
1232      *
1233      * Requirements:
1234      *
1235      * - `to` cannot be the zero address.
1236      * - `quantity` must be greater than 0.
1237      *
1238      * Emits a {ConsecutiveTransfer} event.
1239      */
1240     function _mintERC2309(address to, uint256 quantity) internal virtual {
1241         uint256 startTokenId = _currentIndex;
1242         if (to == address(0)) revert MintToZeroAddress();
1243         if (quantity == 0) revert MintZeroQuantity();
1244         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1245 
1246         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1247 
1248         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1249         unchecked {
1250             // Updates:
1251             // - `balance += quantity`.
1252             // - `numberMinted += quantity`.
1253             //
1254             // We can directly add to the `balance` and `numberMinted`.
1255             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1256 
1257             // Updates:
1258             // - `address` to the owner.
1259             // - `startTimestamp` to the timestamp of minting.
1260             // - `burned` to `false`.
1261             // - `nextInitialized` to `quantity == 1`.
1262             _packedOwnerships[startTokenId] = _packOwnershipData(
1263                 to,
1264                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1265             );
1266 
1267             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1268 
1269             _currentIndex = startTokenId + quantity;
1270         }
1271         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1272     }
1273 
1274     /**
1275      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1276      *
1277      * Requirements:
1278      *
1279      * - If `to` refers to a smart contract, it must implement
1280      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1281      * - `quantity` must be greater than 0.
1282      *
1283      * See {_mint}.
1284      *
1285      * Emits a {Transfer} event for each mint.
1286      */
1287     function _safeMint(
1288         address to,
1289         uint256 quantity,
1290         bytes memory _data
1291     ) internal virtual {
1292         _mint(to, quantity);
1293 
1294         unchecked {
1295             if (to.code.length != 0) {
1296                 uint256 end = _currentIndex;
1297                 uint256 index = end - quantity;
1298                 do {
1299                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1300                         revert TransferToNonERC721ReceiverImplementer();
1301                     }
1302                 } while (index < end);
1303                 // Reentrancy protection.
1304                 if (_currentIndex != end) revert();
1305             }
1306         }
1307     }
1308 
1309     /**
1310      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1311      */
1312     function _safeMint(address to, uint256 quantity) internal virtual {
1313         _safeMint(to, quantity, '');
1314     }
1315 
1316     // =============================================================
1317     //                        BURN OPERATIONS
1318     // =============================================================
1319 
1320     /**
1321      * @dev Equivalent to `_burn(tokenId, false)`.
1322      */
1323     function _burn(uint256 tokenId) internal virtual {
1324         _burn(tokenId, false);
1325     }
1326 
1327     /**
1328      * @dev Destroys `tokenId`.
1329      * The approval is cleared when the token is burned.
1330      *
1331      * Requirements:
1332      *
1333      * - `tokenId` must exist.
1334      *
1335      * Emits a {Transfer} event.
1336      */
1337     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1338         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1339 
1340         address from = address(uint160(prevOwnershipPacked));
1341 
1342         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1343 
1344         if (approvalCheck) {
1345             // The nested ifs save around 20+ gas over a compound boolean condition.
1346             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1347                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1348         }
1349 
1350         _beforeTokenTransfers(from, address(0), tokenId, 1);
1351 
1352         // Clear approvals from the previous owner.
1353         assembly {
1354             if approvedAddress {
1355                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1356                 sstore(approvedAddressSlot, 0)
1357             }
1358         }
1359 
1360         // Underflow of the sender's balance is impossible because we check for
1361         // ownership above and the recipient's balance can't realistically overflow.
1362         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1363         unchecked {
1364             // Updates:
1365             // - `balance -= 1`.
1366             // - `numberBurned += 1`.
1367             //
1368             // We can directly decrement the balance, and increment the number burned.
1369             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1370             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1371 
1372             // Updates:
1373             // - `address` to the last owner.
1374             // - `startTimestamp` to the timestamp of burning.
1375             // - `burned` to `true`.
1376             // - `nextInitialized` to `true`.
1377             _packedOwnerships[tokenId] = _packOwnershipData(
1378                 from,
1379                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1380             );
1381 
1382             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1383             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1384                 uint256 nextTokenId = tokenId + 1;
1385                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1386                 if (_packedOwnerships[nextTokenId] == 0) {
1387                     // If the next slot is within bounds.
1388                     if (nextTokenId != _currentIndex) {
1389                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1390                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1391                     }
1392                 }
1393             }
1394         }
1395 
1396         emit Transfer(from, address(0), tokenId);
1397         _afterTokenTransfers(from, address(0), tokenId, 1);
1398 
1399         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1400         unchecked {
1401             _burnCounter++;
1402         }
1403     }
1404 
1405     // =============================================================
1406     //                     EXTRA DATA OPERATIONS
1407     // =============================================================
1408 
1409     /**
1410      * @dev Directly sets the extra data for the ownership data `index`.
1411      */
1412     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1413         uint256 packed = _packedOwnerships[index];
1414         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1415         uint256 extraDataCasted;
1416         // Cast `extraData` with assembly to avoid redundant masking.
1417         assembly {
1418             extraDataCasted := extraData
1419         }
1420         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1421         _packedOwnerships[index] = packed;
1422     }
1423 
1424     /**
1425      * @dev Called during each token transfer to set the 24bit `extraData` field.
1426      * Intended to be overridden by the cosumer contract.
1427      *
1428      * `previousExtraData` - the value of `extraData` before transfer.
1429      *
1430      * Calling conditions:
1431      *
1432      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1433      * transferred to `to`.
1434      * - When `from` is zero, `tokenId` will be minted for `to`.
1435      * - When `to` is zero, `tokenId` will be burned by `from`.
1436      * - `from` and `to` are never both zero.
1437      */
1438     function _extraData(
1439         address from,
1440         address to,
1441         uint24 previousExtraData
1442     ) internal view virtual returns (uint24) {}
1443 
1444     /**
1445      * @dev Returns the next extra data for the packed ownership data.
1446      * The returned result is shifted into position.
1447      */
1448     function _nextExtraData(
1449         address from,
1450         address to,
1451         uint256 prevOwnershipPacked
1452     ) private view returns (uint256) {
1453         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1454         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1455     }
1456 
1457     // =============================================================
1458     //                       OTHER OPERATIONS
1459     // =============================================================
1460 
1461     /**
1462      * @dev Returns the message sender (defaults to `msg.sender`).
1463      *
1464      * If you are writing GSN compatible contracts, you need to override this function.
1465      */
1466     function _msgSenderERC721A() internal view virtual returns (address) {
1467         return msg.sender;
1468     }
1469 
1470     /**
1471      * @dev Converts a uint256 to its ASCII string decimal representation.
1472      */
1473     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1474         assembly {
1475             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1476             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1477             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1478             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1479             let m := add(mload(0x40), 0xa0)
1480             // Update the free memory pointer to allocate.
1481             mstore(0x40, m)
1482             // Assign the `str` to the end.
1483             str := sub(m, 0x20)
1484             // Zeroize the slot after the string.
1485             mstore(str, 0)
1486 
1487             // Cache the end of the memory to calculate the length later.
1488             let end := str
1489 
1490             // We write the string from rightmost digit to leftmost digit.
1491             // The following is essentially a do-while loop that also handles the zero case.
1492             // prettier-ignore
1493             for { let temp := value } 1 {} {
1494                 str := sub(str, 1)
1495                 // Write the character to the pointer.
1496                 // The ASCII index of the '0' character is 48.
1497                 mstore8(str, add(48, mod(temp, 10)))
1498                 // Keep dividing `temp` until zero.
1499                 temp := div(temp, 10)
1500                 // prettier-ignore
1501                 if iszero(temp) { break }
1502             }
1503 
1504             let length := sub(end, str)
1505             // Move the pointer 32 bytes leftwards to make room for the length.
1506             str := sub(str, 0x20)
1507             // Store the length.
1508             mstore(str, length)
1509         }
1510     }
1511 }
1512 
1513 // File: operator-filter-registry/src/lib/Constants.sol
1514 
1515 
1516 pragma solidity ^0.8.13;
1517 
1518 address constant CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS = 0x000000000000AAeB6D7670E522A718067333cd4E;
1519 address constant CANONICAL_CORI_SUBSCRIPTION = 0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6;
1520 
1521 // File: operator-filter-registry/src/IOperatorFilterRegistry.sol
1522 
1523 
1524 pragma solidity ^0.8.13;
1525 
1526 interface IOperatorFilterRegistry {
1527     /**
1528      * @notice Returns true if operator is not filtered for a given token, either by address or codeHash. Also returns
1529      *         true if supplied registrant address is not registered.
1530      */
1531     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1532 
1533     /**
1534      * @notice Registers an address with the registry. May be called by address itself or by EIP-173 owner.
1535      */
1536     function register(address registrant) external;
1537 
1538     /**
1539      * @notice Registers an address with the registry and "subscribes" to another address's filtered operators and codeHashes.
1540      */
1541     function registerAndSubscribe(address registrant, address subscription) external;
1542 
1543     /**
1544      * @notice Registers an address with the registry and copies the filtered operators and codeHashes from another
1545      *         address without subscribing.
1546      */
1547     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1548 
1549     /**
1550      * @notice Unregisters an address with the registry and removes its subscription. May be called by address itself or by EIP-173 owner.
1551      *         Note that this does not remove any filtered addresses or codeHashes.
1552      *         Also note that any subscriptions to this registrant will still be active and follow the existing filtered addresses and codehashes.
1553      */
1554     function unregister(address addr) external;
1555 
1556     /**
1557      * @notice Update an operator address for a registered address - when filtered is true, the operator is filtered.
1558      */
1559     function updateOperator(address registrant, address operator, bool filtered) external;
1560 
1561     /**
1562      * @notice Update multiple operators for a registered address - when filtered is true, the operators will be filtered. Reverts on duplicates.
1563      */
1564     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1565 
1566     /**
1567      * @notice Update a codeHash for a registered address - when filtered is true, the codeHash is filtered.
1568      */
1569     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1570 
1571     /**
1572      * @notice Update multiple codeHashes for a registered address - when filtered is true, the codeHashes will be filtered. Reverts on duplicates.
1573      */
1574     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1575 
1576     /**
1577      * @notice Subscribe an address to another registrant's filtered operators and codeHashes. Will remove previous
1578      *         subscription if present.
1579      *         Note that accounts with subscriptions may go on to subscribe to other accounts - in this case,
1580      *         subscriptions will not be forwarded. Instead the former subscription's existing entries will still be
1581      *         used.
1582      */
1583     function subscribe(address registrant, address registrantToSubscribe) external;
1584 
1585     /**
1586      * @notice Unsubscribe an address from its current subscribed registrant, and optionally copy its filtered operators and codeHashes.
1587      */
1588     function unsubscribe(address registrant, bool copyExistingEntries) external;
1589 
1590     /**
1591      * @notice Get the subscription address of a given registrant, if any.
1592      */
1593     function subscriptionOf(address addr) external returns (address registrant);
1594 
1595     /**
1596      * @notice Get the set of addresses subscribed to a given registrant.
1597      *         Note that order is not guaranteed as updates are made.
1598      */
1599     function subscribers(address registrant) external returns (address[] memory);
1600 
1601     /**
1602      * @notice Get the subscriber at a given index in the set of addresses subscribed to a given registrant.
1603      *         Note that order is not guaranteed as updates are made.
1604      */
1605     function subscriberAt(address registrant, uint256 index) external returns (address);
1606 
1607     /**
1608      * @notice Copy filtered operators and codeHashes from a different registrantToCopy to addr.
1609      */
1610     function copyEntriesOf(address registrant, address registrantToCopy) external;
1611 
1612     /**
1613      * @notice Returns true if operator is filtered by a given address or its subscription.
1614      */
1615     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1616 
1617     /**
1618      * @notice Returns true if the hash of an address's code is filtered by a given address or its subscription.
1619      */
1620     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1621 
1622     /**
1623      * @notice Returns true if a codeHash is filtered by a given address or its subscription.
1624      */
1625     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1626 
1627     /**
1628      * @notice Returns a list of filtered operators for a given address or its subscription.
1629      */
1630     function filteredOperators(address addr) external returns (address[] memory);
1631 
1632     /**
1633      * @notice Returns the set of filtered codeHashes for a given address or its subscription.
1634      *         Note that order is not guaranteed as updates are made.
1635      */
1636     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1637 
1638     /**
1639      * @notice Returns the filtered operator at the given index of the set of filtered operators for a given address or
1640      *         its subscription.
1641      *         Note that order is not guaranteed as updates are made.
1642      */
1643     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1644 
1645     /**
1646      * @notice Returns the filtered codeHash at the given index of the list of filtered codeHashes for a given address or
1647      *         its subscription.
1648      *         Note that order is not guaranteed as updates are made.
1649      */
1650     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1651 
1652     /**
1653      * @notice Returns true if an address has registered
1654      */
1655     function isRegistered(address addr) external returns (bool);
1656 
1657     /**
1658      * @dev Convenience method to compute the code hash of an arbitrary contract
1659      */
1660     function codeHashOf(address addr) external returns (bytes32);
1661 }
1662 
1663 // File: operator-filter-registry/src/OperatorFilterer.sol
1664 
1665 
1666 pragma solidity ^0.8.13;
1667 
1668 
1669 /**
1670  * @title  OperatorFilterer
1671  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
1672  *         registrant's entries in the OperatorFilterRegistry.
1673  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
1674  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
1675  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
1676  *         Please note that if your token contract does not provide an owner with EIP-173, it must provide
1677  *         administration methods on the contract itself to interact with the registry otherwise the subscription
1678  *         will be locked to the options set during construction.
1679  */
1680 
1681 abstract contract OperatorFilterer {
1682     /// @dev Emitted when an operator is not allowed.
1683     error OperatorNotAllowed(address operator);
1684 
1685     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
1686         IOperatorFilterRegistry(CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS);
1687 
1688     /// @dev The constructor that is called when the contract is being deployed.
1689     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1690         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1691         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1692         // order for the modifier to filter addresses.
1693         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1694             if (subscribe) {
1695                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1696             } else {
1697                 if (subscriptionOrRegistrantToCopy != address(0)) {
1698                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1699                 } else {
1700                     OPERATOR_FILTER_REGISTRY.register(address(this));
1701                 }
1702             }
1703         }
1704     }
1705 
1706     /**
1707      * @dev A helper function to check if an operator is allowed.
1708      */
1709     modifier onlyAllowedOperator(address from) virtual {
1710         // Allow spending tokens from addresses with balance
1711         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1712         // from an EOA.
1713         if (from != msg.sender) {
1714             _checkFilterOperator(msg.sender);
1715         }
1716         _;
1717     }
1718 
1719     /**
1720      * @dev A helper function to check if an operator approval is allowed.
1721      */
1722     modifier onlyAllowedOperatorApproval(address operator) virtual {
1723         _checkFilterOperator(operator);
1724         _;
1725     }
1726 
1727     /**
1728      * @dev A helper function to check if an operator is allowed.
1729      */
1730     function _checkFilterOperator(address operator) internal view virtual {
1731         // Check registry code length to facilitate testing in environments without a deployed registry.
1732         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1733             // under normal circumstances, this function will revert rather than return false, but inheriting contracts
1734             // may specify their own OperatorFilterRegistry implementations, which may behave differently
1735             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
1736                 revert OperatorNotAllowed(operator);
1737             }
1738         }
1739     }
1740 }
1741 
1742 // File: operator-filter-registry/src/DefaultOperatorFilterer.sol
1743 
1744 
1745 pragma solidity ^0.8.13;
1746 
1747 
1748 /**
1749  * @title  DefaultOperatorFilterer
1750  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
1751  * @dev    Please note that if your token contract does not provide an owner with EIP-173, it must provide
1752  *         administration methods on the contract itself to interact with the registry otherwise the subscription
1753  *         will be locked to the options set during construction.
1754  */
1755 
1756 abstract contract DefaultOperatorFilterer is OperatorFilterer {
1757     /// @dev The constructor that is called when the contract is being deployed.
1758     constructor() OperatorFilterer(CANONICAL_CORI_SUBSCRIPTION, true) {}
1759 }
1760 
1761 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1762 
1763 
1764 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1765 
1766 pragma solidity ^0.8.0;
1767 
1768 /**
1769  * @dev Interface of the ERC165 standard, as defined in the
1770  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1771  *
1772  * Implementers can declare support of contract interfaces, which can then be
1773  * queried by others ({ERC165Checker}).
1774  *
1775  * For an implementation, see {ERC165}.
1776  */
1777 interface IERC165 {
1778     /**
1779      * @dev Returns true if this contract implements the interface defined by
1780      * `interfaceId`. See the corresponding
1781      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1782      * to learn more about how these ids are created.
1783      *
1784      * This function call must use less than 30 000 gas.
1785      */
1786     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1787 }
1788 
1789 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1790 
1791 
1792 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1793 
1794 pragma solidity ^0.8.0;
1795 
1796 
1797 /**
1798  * @dev Implementation of the {IERC165} interface.
1799  *
1800  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1801  * for the additional interface id that will be supported. For example:
1802  *
1803  * ```solidity
1804  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1805  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1806  * }
1807  * ```
1808  *
1809  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1810  */
1811 abstract contract ERC165 is IERC165 {
1812     /**
1813      * @dev See {IERC165-supportsInterface}.
1814      */
1815     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1816         return interfaceId == type(IERC165).interfaceId;
1817     }
1818 }
1819 
1820 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
1821 
1822 
1823 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
1824 
1825 pragma solidity ^0.8.0;
1826 
1827 
1828 /**
1829  * @dev Interface for the NFT Royalty Standard.
1830  *
1831  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
1832  * support for royalty payments across all NFT marketplaces and ecosystem participants.
1833  *
1834  * _Available since v4.5._
1835  */
1836 interface IERC2981 is IERC165 {
1837     /**
1838      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
1839      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
1840      */
1841     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1842         external
1843         view
1844         returns (address receiver, uint256 royaltyAmount);
1845 }
1846 
1847 // File: @openzeppelin/contracts/token/common/ERC2981.sol
1848 
1849 
1850 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
1851 
1852 pragma solidity ^0.8.0;
1853 
1854 
1855 
1856 /**
1857  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
1858  *
1859  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
1860  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
1861  *
1862  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
1863  * fee is specified in basis points by default.
1864  *
1865  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
1866  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
1867  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
1868  *
1869  * _Available since v4.5._
1870  */
1871 abstract contract ERC2981 is IERC2981, ERC165 {
1872     struct RoyaltyInfo {
1873         address receiver;
1874         uint96 royaltyFraction;
1875     }
1876 
1877     RoyaltyInfo private _defaultRoyaltyInfo;
1878     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
1879 
1880     /**
1881      * @dev See {IERC165-supportsInterface}.
1882      */
1883     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
1884         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
1885     }
1886 
1887     /**
1888      * @inheritdoc IERC2981
1889      */
1890     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
1891         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
1892 
1893         if (royalty.receiver == address(0)) {
1894             royalty = _defaultRoyaltyInfo;
1895         }
1896 
1897         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
1898 
1899         return (royalty.receiver, royaltyAmount);
1900     }
1901 
1902     /**
1903      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
1904      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
1905      * override.
1906      */
1907     function _feeDenominator() internal pure virtual returns (uint96) {
1908         return 10000;
1909     }
1910 
1911     /**
1912      * @dev Sets the royalty information that all ids in this contract will default to.
1913      *
1914      * Requirements:
1915      *
1916      * - `receiver` cannot be the zero address.
1917      * - `feeNumerator` cannot be greater than the fee denominator.
1918      */
1919     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
1920         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1921         require(receiver != address(0), "ERC2981: invalid receiver");
1922 
1923         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
1924     }
1925 
1926     /**
1927      * @dev Removes default royalty information.
1928      */
1929     function _deleteDefaultRoyalty() internal virtual {
1930         delete _defaultRoyaltyInfo;
1931     }
1932 
1933     /**
1934      * @dev Sets the royalty information for a specific token id, overriding the global default.
1935      *
1936      * Requirements:
1937      *
1938      * - `receiver` cannot be the zero address.
1939      * - `feeNumerator` cannot be greater than the fee denominator.
1940      */
1941     function _setTokenRoyalty(
1942         uint256 tokenId,
1943         address receiver,
1944         uint96 feeNumerator
1945     ) internal virtual {
1946         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1947         require(receiver != address(0), "ERC2981: Invalid parameters");
1948 
1949         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
1950     }
1951 
1952     /**
1953      * @dev Resets royalty information for the token id back to the global default.
1954      */
1955     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
1956         delete _tokenRoyaltyInfo[tokenId];
1957     }
1958 }
1959 
1960 // File: @openzeppelin/contracts/utils/Context.sol
1961 
1962 
1963 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1964 
1965 pragma solidity ^0.8.0;
1966 
1967 /**
1968  * @dev Provides information about the current execution context, including the
1969  * sender of the transaction and its data. While these are generally available
1970  * via msg.sender and msg.data, they should not be accessed in such a direct
1971  * manner, since when dealing with meta-transactions the account sending and
1972  * paying for execution may not be the actual sender (as far as an application
1973  * is concerned).
1974  *
1975  * This contract is only required for intermediate, library-like contracts.
1976  */
1977 abstract contract Context {
1978     function _msgSender() internal view virtual returns (address) {
1979         return msg.sender;
1980     }
1981 
1982     function _msgData() internal view virtual returns (bytes calldata) {
1983         return msg.data;
1984     }
1985 }
1986 
1987 // File: @openzeppelin/contracts/access/Ownable.sol
1988 
1989 
1990 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1991 
1992 pragma solidity ^0.8.0;
1993 
1994 
1995 /**
1996  * @dev Contract module which provides a basic access control mechanism, where
1997  * there is an account (an owner) that can be granted exclusive access to
1998  * specific functions.
1999  *
2000  * By default, the owner account will be the one that deploys the contract. This
2001  * can later be changed with {transferOwnership}.
2002  *
2003  * This module is used through inheritance. It will make available the modifier
2004  * `onlyOwner`, which can be applied to your functions to restrict their use to
2005  * the owner.
2006  */
2007 abstract contract Ownable is Context {
2008     address private _owner;
2009 
2010     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2011 
2012     /**
2013      * @dev Initializes the contract setting the deployer as the initial owner.
2014      */
2015     constructor() {
2016         _transferOwnership(_msgSender());
2017     }
2018 
2019     /**
2020      * @dev Throws if called by any account other than the owner.
2021      */
2022     modifier onlyOwner() {
2023         _checkOwner();
2024         _;
2025     }
2026 
2027     /**
2028      * @dev Returns the address of the current owner.
2029      */
2030     function owner() public view virtual returns (address) {
2031         return _owner;
2032     }
2033 
2034     /**
2035      * @dev Throws if the sender is not the owner.
2036      */
2037     function _checkOwner() internal view virtual {
2038         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2039     }
2040 
2041     /**
2042      * @dev Leaves the contract without owner. It will not be possible to call
2043      * `onlyOwner` functions anymore. Can only be called by the current owner.
2044      *
2045      * NOTE: Renouncing ownership will leave the contract without an owner,
2046      * thereby removing any functionality that is only available to the owner.
2047      */
2048     function renounceOwnership() public virtual onlyOwner {
2049         _transferOwnership(address(0));
2050     }
2051 
2052     /**
2053      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2054      * Can only be called by the current owner.
2055      */
2056     function transferOwnership(address newOwner) public virtual onlyOwner {
2057         require(newOwner != address(0), "Ownable: new owner is the zero address");
2058         _transferOwnership(newOwner);
2059     }
2060 
2061     /**
2062      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2063      * Internal function without access restriction.
2064      */
2065     function _transferOwnership(address newOwner) internal virtual {
2066         address oldOwner = _owner;
2067         _owner = newOwner;
2068         emit OwnershipTransferred(oldOwner, newOwner);
2069     }
2070 }
2071 
2072 // File: @openzeppelin/contracts/utils/math/Math.sol
2073 
2074 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
2075 
2076 pragma solidity ^0.8.0;
2077 
2078 /**
2079  * @dev Standard math utilities missing in the Solidity language.
2080  */
2081 library Math {
2082     enum Rounding {
2083         Down, // Toward negative infinity
2084         Up, // Toward infinity
2085         Zero // Toward zero
2086     }
2087 
2088     /**
2089      * @dev Returns the largest of two numbers.
2090      */
2091     function max(uint256 a, uint256 b) internal pure returns (uint256) {
2092         return a > b ? a : b;
2093     }
2094 
2095     /**
2096      * @dev Returns the smallest of two numbers.
2097      */
2098     function min(uint256 a, uint256 b) internal pure returns (uint256) {
2099         return a < b ? a : b;
2100     }
2101 
2102     /**
2103      * @dev Returns the average of two numbers. The result is rounded towards
2104      * zero.
2105      */
2106     function average(uint256 a, uint256 b) internal pure returns (uint256) {
2107         // (a + b) / 2 can overflow.
2108         return (a & b) + (a ^ b) / 2;
2109     }
2110 
2111     /**
2112      * @dev Returns the ceiling of the division of two numbers.
2113      *
2114      * This differs from standard division with `/` in that it rounds up instead
2115      * of rounding down.
2116      */
2117     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
2118         // (a + b - 1) / b can overflow on addition, so we distribute.
2119         return a == 0 ? 0 : (a - 1) / b + 1;
2120     }
2121 
2122     /**
2123      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
2124      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
2125      * with further edits by Uniswap Labs also under MIT license.
2126      */
2127     function mulDiv(
2128         uint256 x,
2129         uint256 y,
2130         uint256 denominator
2131     ) internal pure returns (uint256 result) {
2132         unchecked {
2133             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
2134             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
2135             // variables such that product = prod1 * 2^256 + prod0.
2136             uint256 prod0; // Least significant 256 bits of the product
2137             uint256 prod1; // Most significant 256 bits of the product
2138             assembly {
2139                 let mm := mulmod(x, y, not(0))
2140                 prod0 := mul(x, y)
2141                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
2142             }
2143 
2144             // Handle non-overflow cases, 256 by 256 division.
2145             if (prod1 == 0) {
2146                 return prod0 / denominator;
2147             }
2148 
2149             // Make sure the result is less than 2^256. Also prevents denominator == 0.
2150             require(denominator > prod1);
2151 
2152             ///////////////////////////////////////////////
2153             // 512 by 256 division.
2154             ///////////////////////////////////////////////
2155 
2156             // Make division exact by subtracting the remainder from [prod1 prod0].
2157             uint256 remainder;
2158             assembly {
2159                 // Compute remainder using mulmod.
2160                 remainder := mulmod(x, y, denominator)
2161 
2162                 // Subtract 256 bit number from 512 bit number.
2163                 prod1 := sub(prod1, gt(remainder, prod0))
2164                 prod0 := sub(prod0, remainder)
2165             }
2166 
2167             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
2168             // See https://cs.stackexchange.com/q/138556/92363.
2169 
2170             // Does not overflow because the denominator cannot be zero at this stage in the function.
2171             uint256 twos = denominator & (~denominator + 1);
2172             assembly {
2173                 // Divide denominator by twos.
2174                 denominator := div(denominator, twos)
2175 
2176                 // Divide [prod1 prod0] by twos.
2177                 prod0 := div(prod0, twos)
2178 
2179                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
2180                 twos := add(div(sub(0, twos), twos), 1)
2181             }
2182 
2183             // Shift in bits from prod1 into prod0.
2184             prod0 |= prod1 * twos;
2185 
2186             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
2187             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
2188             // four bits. That is, denominator * inv = 1 mod 2^4.
2189             uint256 inverse = (3 * denominator) ^ 2;
2190 
2191             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
2192             // in modular arithmetic, doubling the correct bits in each step.
2193             inverse *= 2 - denominator * inverse; // inverse mod 2^8
2194             inverse *= 2 - denominator * inverse; // inverse mod 2^16
2195             inverse *= 2 - denominator * inverse; // inverse mod 2^32
2196             inverse *= 2 - denominator * inverse; // inverse mod 2^64
2197             inverse *= 2 - denominator * inverse; // inverse mod 2^128
2198             inverse *= 2 - denominator * inverse; // inverse mod 2^256
2199 
2200             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
2201             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
2202             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
2203             // is no longer required.
2204             result = prod0 * inverse;
2205             return result;
2206         }
2207     }
2208 
2209     /**
2210      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
2211      */
2212     function mulDiv(
2213         uint256 x,
2214         uint256 y,
2215         uint256 denominator,
2216         Rounding rounding
2217     ) internal pure returns (uint256) {
2218         uint256 result = mulDiv(x, y, denominator);
2219         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
2220             result += 1;
2221         }
2222         return result;
2223     }
2224 
2225     /**
2226      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
2227      *
2228      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
2229      */
2230     function sqrt(uint256 a) internal pure returns (uint256) {
2231         if (a == 0) {
2232             return 0;
2233         }
2234 
2235         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
2236         //
2237         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
2238         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
2239         //
2240         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
2241         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
2242         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
2243         //
2244         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
2245         uint256 result = 1 << (log2(a) >> 1);
2246 
2247         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
2248         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
2249         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
2250         // into the expected uint128 result.
2251         unchecked {
2252             result = (result + a / result) >> 1;
2253             result = (result + a / result) >> 1;
2254             result = (result + a / result) >> 1;
2255             result = (result + a / result) >> 1;
2256             result = (result + a / result) >> 1;
2257             result = (result + a / result) >> 1;
2258             result = (result + a / result) >> 1;
2259             return min(result, a / result);
2260         }
2261     }
2262 
2263     /**
2264      * @notice Calculates sqrt(a), following the selected rounding direction.
2265      */
2266     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
2267         unchecked {
2268             uint256 result = sqrt(a);
2269             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
2270         }
2271     }
2272 
2273     /**
2274      * @dev Return the log in base 2, rounded down, of a positive value.
2275      * Returns 0 if given 0.
2276      */
2277     function log2(uint256 value) internal pure returns (uint256) {
2278         uint256 result = 0;
2279         unchecked {
2280             if (value >> 128 > 0) {
2281                 value >>= 128;
2282                 result += 128;
2283             }
2284             if (value >> 64 > 0) {
2285                 value >>= 64;
2286                 result += 64;
2287             }
2288             if (value >> 32 > 0) {
2289                 value >>= 32;
2290                 result += 32;
2291             }
2292             if (value >> 16 > 0) {
2293                 value >>= 16;
2294                 result += 16;
2295             }
2296             if (value >> 8 > 0) {
2297                 value >>= 8;
2298                 result += 8;
2299             }
2300             if (value >> 4 > 0) {
2301                 value >>= 4;
2302                 result += 4;
2303             }
2304             if (value >> 2 > 0) {
2305                 value >>= 2;
2306                 result += 2;
2307             }
2308             if (value >> 1 > 0) {
2309                 result += 1;
2310             }
2311         }
2312         return result;
2313     }
2314 
2315     /**
2316      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
2317      * Returns 0 if given 0.
2318      */
2319     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
2320         unchecked {
2321             uint256 result = log2(value);
2322             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
2323         }
2324     }
2325 
2326     /**
2327      * @dev Return the log in base 10, rounded down, of a positive value.
2328      * Returns 0 if given 0.
2329      */
2330     function log10(uint256 value) internal pure returns (uint256) {
2331         uint256 result = 0;
2332         unchecked {
2333             if (value >= 10**64) {
2334                 value /= 10**64;
2335                 result += 64;
2336             }
2337             if (value >= 10**32) {
2338                 value /= 10**32;
2339                 result += 32;
2340             }
2341             if (value >= 10**16) {
2342                 value /= 10**16;
2343                 result += 16;
2344             }
2345             if (value >= 10**8) {
2346                 value /= 10**8;
2347                 result += 8;
2348             }
2349             if (value >= 10**4) {
2350                 value /= 10**4;
2351                 result += 4;
2352             }
2353             if (value >= 10**2) {
2354                 value /= 10**2;
2355                 result += 2;
2356             }
2357             if (value >= 10**1) {
2358                 result += 1;
2359             }
2360         }
2361         return result;
2362     }
2363 
2364     /**
2365      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
2366      * Returns 0 if given 0.
2367      */
2368     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
2369         unchecked {
2370             uint256 result = log10(value);
2371             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
2372         }
2373     }
2374 
2375     /**
2376      * @dev Return the log in base 256, rounded down, of a positive value.
2377      * Returns 0 if given 0.
2378      *
2379      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
2380      */
2381     function log256(uint256 value) internal pure returns (uint256) {
2382         uint256 result = 0;
2383         unchecked {
2384             if (value >> 128 > 0) {
2385                 value >>= 128;
2386                 result += 16;
2387             }
2388             if (value >> 64 > 0) {
2389                 value >>= 64;
2390                 result += 8;
2391             }
2392             if (value >> 32 > 0) {
2393                 value >>= 32;
2394                 result += 4;
2395             }
2396             if (value >> 16 > 0) {
2397                 value >>= 16;
2398                 result += 2;
2399             }
2400             if (value >> 8 > 0) {
2401                 result += 1;
2402             }
2403         }
2404         return result;
2405     }
2406 
2407     /**
2408      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
2409      * Returns 0 if given 0.
2410      */
2411     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
2412         unchecked {
2413             uint256 result = log256(value);
2414             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
2415         }
2416     }
2417 }
2418 
2419 // File: @openzeppelin/contracts/utils/Strings.sol
2420 
2421 
2422 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
2423 
2424 pragma solidity ^0.8.0;
2425 
2426 /**
2427  * @dev String operations.
2428  */
2429 library Strings {
2430     bytes16 private constant _SYMBOLS = "0123456789abcdef";
2431     uint8 private constant _ADDRESS_LENGTH = 20;
2432 
2433     /**
2434      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
2435      */
2436     function toString(uint256 value) internal pure returns (string memory) {
2437         unchecked {
2438             uint256 length = Math.log10(value) + 1;
2439             string memory buffer = new string(length);
2440             uint256 ptr;
2441             /// @solidity memory-safe-assembly
2442             assembly {
2443                 ptr := add(buffer, add(32, length))
2444             }
2445             while (true) {
2446                 ptr--;
2447                 /// @solidity memory-safe-assembly
2448                 assembly {
2449                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
2450                 }
2451                 value /= 10;
2452                 if (value == 0) break;
2453             }
2454             return buffer;
2455         }
2456     }
2457 
2458     /**
2459      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
2460      */
2461     function toHexString(uint256 value) internal pure returns (string memory) {
2462         unchecked {
2463             return toHexString(value, Math.log256(value) + 1);
2464         }
2465     }
2466 
2467     /**
2468      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
2469      */
2470     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
2471         bytes memory buffer = new bytes(2 * length + 2);
2472         buffer[0] = "0";
2473         buffer[1] = "x";
2474         for (uint256 i = 2 * length + 1; i > 1; --i) {
2475             buffer[i] = _SYMBOLS[value & 0xf];
2476             value >>= 4;
2477         }
2478         require(value == 0, "Strings: hex length insufficient");
2479         return string(buffer);
2480     }
2481 
2482     /**
2483      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
2484      */
2485     function toHexString(address addr) internal pure returns (string memory) {
2486         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
2487     }
2488 }
2489 
2490 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
2491 
2492 
2493 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/ECDSA.sol)
2494 
2495 pragma solidity ^0.8.0;
2496 
2497 /**
2498  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
2499  *
2500  * These functions can be used to verify that a message was signed by the holder
2501  * of the private keys of a given address.
2502  */
2503 library ECDSA {
2504     enum RecoverError {
2505         NoError,
2506         InvalidSignature,
2507         InvalidSignatureLength,
2508         InvalidSignatureS,
2509         InvalidSignatureV // Deprecated in v4.8
2510     }
2511 
2512     function _throwError(RecoverError error) private pure {
2513         if (error == RecoverError.NoError) {
2514             return; // no error: do nothing
2515         } else if (error == RecoverError.InvalidSignature) {
2516             revert("ECDSA: invalid signature");
2517         } else if (error == RecoverError.InvalidSignatureLength) {
2518             revert("ECDSA: invalid signature length");
2519         } else if (error == RecoverError.InvalidSignatureS) {
2520             revert("ECDSA: invalid signature 's' value");
2521         }
2522     }
2523 
2524     /**
2525      * @dev Returns the address that signed a hashed message (`hash`) with
2526      * `signature` or error string. This address can then be used for verification purposes.
2527      *
2528      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
2529      * this function rejects them by requiring the `s` value to be in the lower
2530      * half order, and the `v` value to be either 27 or 28.
2531      *
2532      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
2533      * verification to be secure: it is possible to craft signatures that
2534      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
2535      * this is by receiving a hash of the original message (which may otherwise
2536      * be too long), and then calling {toEthSignedMessageHash} on it.
2537      *
2538      * Documentation for signature generation:
2539      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
2540      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
2541      *
2542      * _Available since v4.3._
2543      */
2544     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
2545         if (signature.length == 65) {
2546             bytes32 r;
2547             bytes32 s;
2548             uint8 v;
2549             // ecrecover takes the signature parameters, and the only way to get them
2550             // currently is to use assembly.
2551             /// @solidity memory-safe-assembly
2552             assembly {
2553                 r := mload(add(signature, 0x20))
2554                 s := mload(add(signature, 0x40))
2555                 v := byte(0, mload(add(signature, 0x60)))
2556             }
2557             return tryRecover(hash, v, r, s);
2558         } else {
2559             return (address(0), RecoverError.InvalidSignatureLength);
2560         }
2561     }
2562 
2563     /**
2564      * @dev Returns the address that signed a hashed message (`hash`) with
2565      * `signature`. This address can then be used for verification purposes.
2566      *
2567      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
2568      * this function rejects them by requiring the `s` value to be in the lower
2569      * half order, and the `v` value to be either 27 or 28.
2570      *
2571      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
2572      * verification to be secure: it is possible to craft signatures that
2573      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
2574      * this is by receiving a hash of the original message (which may otherwise
2575      * be too long), and then calling {toEthSignedMessageHash} on it.
2576      */
2577     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
2578         (address recovered, RecoverError error) = tryRecover(hash, signature);
2579         _throwError(error);
2580         return recovered;
2581     }
2582 
2583     /**
2584      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
2585      *
2586      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
2587      *
2588      * _Available since v4.3._
2589      */
2590     function tryRecover(
2591         bytes32 hash,
2592         bytes32 r,
2593         bytes32 vs
2594     ) internal pure returns (address, RecoverError) {
2595         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
2596         uint8 v = uint8((uint256(vs) >> 255) + 27);
2597         return tryRecover(hash, v, r, s);
2598     }
2599 
2600     /**
2601      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
2602      *
2603      * _Available since v4.2._
2604      */
2605     function recover(
2606         bytes32 hash,
2607         bytes32 r,
2608         bytes32 vs
2609     ) internal pure returns (address) {
2610         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
2611         _throwError(error);
2612         return recovered;
2613     }
2614 
2615     /**
2616      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
2617      * `r` and `s` signature fields separately.
2618      *
2619      * _Available since v4.3._
2620      */
2621     function tryRecover(
2622         bytes32 hash,
2623         uint8 v,
2624         bytes32 r,
2625         bytes32 s
2626     ) internal pure returns (address, RecoverError) {
2627         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
2628         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
2629         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
2630         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
2631         //
2632         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
2633         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
2634         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
2635         // these malleable signatures as well.
2636         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
2637             return (address(0), RecoverError.InvalidSignatureS);
2638         }
2639 
2640         // If the signature is valid (and not malleable), return the signer address
2641         address signer = ecrecover(hash, v, r, s);
2642         if (signer == address(0)) {
2643             return (address(0), RecoverError.InvalidSignature);
2644         }
2645 
2646         return (signer, RecoverError.NoError);
2647     }
2648 
2649     /**
2650      * @dev Overload of {ECDSA-recover} that receives the `v`,
2651      * `r` and `s` signature fields separately.
2652      */
2653     function recover(
2654         bytes32 hash,
2655         uint8 v,
2656         bytes32 r,
2657         bytes32 s
2658     ) internal pure returns (address) {
2659         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
2660         _throwError(error);
2661         return recovered;
2662     }
2663 
2664     /**
2665      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
2666      * produces hash corresponding to the one signed with the
2667      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
2668      * JSON-RPC method as part of EIP-191.
2669      *
2670      * See {recover}.
2671      */
2672     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
2673         // 32 is the length in bytes of hash,
2674         // enforced by the type signature above
2675         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
2676     }
2677 
2678     /**
2679      * @dev Returns an Ethereum Signed Message, created from `s`. This
2680      * produces hash corresponding to the one signed with the
2681      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
2682      * JSON-RPC method as part of EIP-191.
2683      *
2684      * See {recover}.
2685      */
2686     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
2687         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
2688     }
2689 
2690     /**
2691      * @dev Returns an Ethereum Signed Typed Data, created from a
2692      * `domainSeparator` and a `structHash`. This produces hash corresponding
2693      * to the one signed with the
2694      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
2695      * JSON-RPC method as part of EIP-712.
2696      *
2697      * See {recover}.
2698      */
2699     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
2700         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
2701     }
2702 }
2703 
2704 // File: contracts/MeteoriaNFT.sol
2705 
2706 pragma solidity ^0.8.7;
2707 
2708 
2709 interface IMeteorium {
2710     function mint(address to, uint256 amount) external;
2711 }
2712 
2713 /**
2714  * @title MeteoriaNFT
2715  * @author 0x0
2716  *
2717  * Meteoria main NFT collection, used as access to our various events to come.
2718  * It will also be the only way of minting a genesis Meteorium token by
2719  * minting batches of 3 (3 MeteoriaNFT minted = 1 genesis Meteorium).
2720  *
2721  * The reveal system for this token will be fully offchain, our backend will
2722  * only display as revealed the one who will be explicitly unpacked by their
2723  * owners.
2724  * The final draw will directly be saved and a hash will computed and
2725  * shared to forge a proof and prove there has been no manupulations in the
2726  * process. Once the reveal event ends, all the metadata will be pushed
2727  * on IPFS and the URI should be frozen.
2728  */
2729 contract MeteoriaNFT is
2730     ERC721A,
2731     ERC2981,
2732     DefaultOperatorFilterer,
2733     WithdrawFairly,
2734     Ownable
2735 {
2736     using ECDSA for bytes32;
2737 
2738     error CannotUnfreezeURI();
2739     error CannotUpdateFrozenURI();
2740     error OnlyEOA();
2741     error CollectionSoldOut();
2742     error NotPresale();
2743     error MaxPresaleMints();
2744     error NotWhitelisted();
2745     error NotSale();
2746     error MintPaused();
2747     error MaxSaleTxMintsReached();
2748     error IncorrectETHValue();
2749 
2750     struct MeteoriaNFTConfig {
2751         uint64 presaleStart;
2752         uint64 presaleEnd;
2753         uint64 salePrice;
2754         uint8 maxMintsPerTx;
2755         uint8 maxMintsPresale;
2756         bool mintPaused;
2757     }
2758 
2759     address private constant _PRESALE_AUTHORITY =
2760         0x8734A7EA99895869a16d2c2fc5DBAD78a40F1C70;
2761     uint256 private constant _MINT_SUPPLY = 6000;
2762     uint256 private constant _METEORIUM_MINT_RATE = 3;
2763 
2764     IMeteorium private _meteorium;
2765 
2766     MeteoriaNFTConfig public config;
2767 
2768     // Metadata data
2769     string public baseURI;
2770     bool public frozenURI;
2771 
2772     event MeteoriaNFTConfigUpdated(MeteoriaNFTConfig newConfig);
2773     event MeteoriumUpdated(address meteorium);
2774     event FrozenURI();
2775     event BaseURIUpdated(string baseURI);
2776 
2777     constructor() payable ERC721A("MeteoriaNFT", "MTO") {
2778         // Setting royalties to 5.5%
2779         _setDefaultRoyalty(address(this), 550);
2780 
2781         // Define base conf below
2782         config = MeteoriaNFTConfig(
2783             1680138000,
2784             1680152400,
2785             0.055 ether,
2786             9,
2787             3,
2788             false
2789         );
2790     }
2791 
2792     function setDefaultRoyalty(
2793         address _receiver,
2794         uint96 _feeNumerator
2795     ) external onlyOwner {
2796         _setDefaultRoyalty(_receiver, _feeNumerator);
2797     }
2798 
2799     function setConfig(MeteoriaNFTConfig calldata newConf) external onlyOwner {
2800         config = newConf;
2801 
2802         emit MeteoriaNFTConfigUpdated(newConf);
2803     }
2804 
2805     function freezeURI() external onlyOwner {
2806         if (!frozenURI) {
2807             frozenURI = true;
2808 
2809             emit FrozenURI();
2810         }
2811     }
2812 
2813     function setMeteorium(address meteorium) external onlyOwner {
2814         _meteorium = IMeteorium(meteorium);
2815 
2816         emit MeteoriumUpdated(meteorium);
2817     }
2818 
2819     function setBaseURI(string calldata baseURI_) external onlyOwner {
2820         if (frozenURI) revert CannotUpdateFrozenURI();
2821 
2822         baseURI = baseURI_;
2823 
2824         emit BaseURIUpdated(baseURI_);
2825     }
2826 
2827     function ownerMint(uint256 amount, address to) external onlyOwner {
2828         if (isSoldOut(amount)) revert CollectionSoldOut();
2829 
2830         _mint(to, amount);
2831     }
2832 
2833     function ownershipOf(
2834         uint256 tokenId
2835     ) external view returns (TokenOwnership memory) {
2836         return _ownershipOf(tokenId);
2837     }
2838 
2839     function isSoldOut(uint256 nftWanted) public view returns (bool) {
2840         return _totalMinted() + nftWanted > _MINT_SUPPLY;
2841     }
2842 
2843     function supportsInterface(
2844         bytes4 interfaceId
2845     ) public view virtual override(ERC721A, ERC2981) returns (bool) {
2846         return ERC721A.supportsInterface(interfaceId) ||
2847             ERC2981.supportsInterface(interfaceId);
2848     }
2849 
2850     function setApprovalForAll(
2851         address operator,
2852         bool approved
2853     ) public override onlyAllowedOperatorApproval(operator) {
2854         super.setApprovalForAll(operator, approved);
2855     }
2856 
2857     function approve(
2858         address operator,
2859         uint256 tokenId
2860     ) public payable override onlyAllowedOperatorApproval(operator) {
2861         super.approve(operator, tokenId);
2862     }
2863 
2864     function transferFrom(
2865         address from,
2866         address to,
2867         uint256 tokenId
2868     ) public payable override onlyAllowedOperator(from) {
2869         super.transferFrom(from, to, tokenId);
2870     }
2871 
2872     function safeTransferFrom(
2873         address from,
2874         address to,
2875         uint256 tokenId
2876     ) public payable override onlyAllowedOperator(from) {
2877         super.safeTransferFrom(from, to, tokenId);
2878     }
2879 
2880     function safeTransferFrom(
2881         address from,
2882         address to,
2883         uint256 tokenId,
2884         bytes memory data
2885     ) public payable override onlyAllowedOperator(from) {
2886         super.safeTransferFrom(from, to, tokenId, data);
2887     }
2888 
2889     function tokenURI(
2890         uint256 _nftId
2891     ) public view override returns (string memory) {
2892         if (!_exists(_nftId)) revert URIQueryForNonexistentToken();
2893 
2894         return string(abi.encodePacked(baseURI, _toString(_nftId), ".json"));
2895     }
2896 
2897     function burn(uint256 tokenId) public virtual {
2898         _burn(tokenId, true);
2899     }
2900 
2901     function totalMinted() external view returns (uint256) {
2902         return _totalMinted();
2903     }
2904 
2905     function numberMinted(address owner) external view returns (uint256) {
2906         return _numberMinted(owner);
2907     }
2908 
2909     function presaleMint(uint256 amount, bytes calldata signature)
2910         external
2911         payable
2912     {
2913         if (msg.sender != tx.origin) revert OnlyEOA();
2914         if (isSoldOut(amount)) revert CollectionSoldOut();
2915         if (
2916             _PRESALE_AUTHORITY != keccak256(
2917                 abi.encodePacked(msg.sender)
2918             ).toEthSignedMessageHash().recover(signature)
2919         ) revert NotWhitelisted();
2920 
2921         MeteoriaNFTConfig memory conf = config;
2922 
2923         if (conf.mintPaused) revert MintPaused();
2924         if (
2925             block.timestamp < conf.presaleStart ||
2926             block.timestamp >= conf.presaleEnd
2927         ) revert NotPresale();
2928 
2929         uint256 meteoriumEarned;
2930         // Below cannot overflow as it would already have occured in isSoldOut
2931         // function which isn't using unchecked block, regarding the price,
2932         // this contract assume the price will not reach irrealistic price
2933         // for NFTs mints which would also require a huge collection size (
2934         // which would already cause trouble with ERC721A impl)
2935         unchecked {
2936             if (_numberMinted(msg.sender) + amount > conf.maxMintsPresale)
2937                 revert MaxPresaleMints();
2938 
2939             if (msg.value != conf.salePrice * amount)
2940                 revert IncorrectETHValue();
2941 
2942             meteoriumEarned = amount / _METEORIUM_MINT_RATE;
2943         }
2944 
2945         if (meteoriumEarned > 0) {
2946             _meteorium.mint(msg.sender, meteoriumEarned);
2947         }
2948 
2949         _mint(msg.sender, amount);
2950     }
2951 
2952     function saleMint(uint256 amount) external payable {
2953         if (msg.sender != tx.origin) revert OnlyEOA();
2954         if (isSoldOut(amount)) revert CollectionSoldOut();
2955 
2956         MeteoriaNFTConfig memory conf = config;
2957 
2958         if (conf.mintPaused) revert MintPaused();
2959         if (block.timestamp < conf.presaleEnd) revert NotSale();
2960         if (amount > conf.maxMintsPerTx) revert MaxSaleTxMintsReached();
2961 
2962         uint256 meteoriumEarned;
2963 
2964         unchecked {
2965             if (msg.value != conf.salePrice * amount)
2966                 revert IncorrectETHValue();
2967 
2968             meteoriumEarned = amount / _METEORIUM_MINT_RATE;
2969         }
2970 
2971         if (meteoriumEarned > 0) {
2972             _meteorium.mint(msg.sender, meteoriumEarned);
2973         }
2974 
2975         _mint(msg.sender, amount);
2976     }
2977 
2978     function _startTokenId() internal pure override returns (uint256) {
2979         return 1;
2980     }
2981 }