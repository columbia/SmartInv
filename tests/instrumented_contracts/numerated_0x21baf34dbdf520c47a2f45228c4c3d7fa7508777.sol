1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
3 
4 
5 // OpenZeppelin Contracts (last updated v4.9.0) (security/ReentrancyGuard.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Contract module that helps prevent reentrant calls to a function.
11  *
12  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
13  * available, which can be applied to functions to make sure there are no nested
14  * (reentrant) calls to them.
15  *
16  * Note that because there is a single `nonReentrant` guard, functions marked as
17  * `nonReentrant` may not call one another. This can be worked around by making
18  * those functions `private`, and then adding `external` `nonReentrant` entry
19  * points to them.
20  *
21  * TIP: If you would like to learn more about reentrancy and alternative ways
22  * to protect against it, check out our blog post
23  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
24  */
25 abstract contract ReentrancyGuard {
26     // Booleans are more expensive than uint256 or any type that takes up a full
27     // word because each write operation emits an extra SLOAD to first read the
28     // slot's contents, replace the bits taken up by the boolean, and then write
29     // back. This is the compiler's defense against contract upgrades and
30     // pointer aliasing, and it cannot be disabled.
31 
32     // The values being non-zero value makes deployment a bit more expensive,
33     // but in exchange the refund on every call to nonReentrant will be lower in
34     // amount. Since refunds are capped to a percentage of the total
35     // transaction's gas, it is best to keep them low in cases like this one, to
36     // increase the likelihood of the full refund coming into effect.
37     uint256 private constant _NOT_ENTERED = 1;
38     uint256 private constant _ENTERED = 2;
39 
40     uint256 private _status;
41 
42     constructor() {
43         _status = _NOT_ENTERED;
44     }
45 
46     /**
47      * @dev Prevents a contract from calling itself, directly or indirectly.
48      * Calling a `nonReentrant` function from another `nonReentrant`
49      * function is not supported. It is possible to prevent this from happening
50      * by making the `nonReentrant` function external, and making it call a
51      * `private` function that does the actual work.
52      */
53     modifier nonReentrant() {
54         _nonReentrantBefore();
55         _;
56         _nonReentrantAfter();
57     }
58 
59     function _nonReentrantBefore() private {
60         // On the first call to nonReentrant, _status will be _NOT_ENTERED
61         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
62 
63         // Any calls to nonReentrant after this point will fail
64         _status = _ENTERED;
65     }
66 
67     function _nonReentrantAfter() private {
68         // By storing the original value once again, a refund is triggered (see
69         // https://eips.ethereum.org/EIPS/eip-2200)
70         _status = _NOT_ENTERED;
71     }
72 
73     /**
74      * @dev Returns true if the reentrancy guard is currently set to "entered", which indicates there is a
75      * `nonReentrant` function in the call stack.
76      */
77     function _reentrancyGuardEntered() internal view returns (bool) {
78         return _status == _ENTERED;
79     }
80 }
81 
82 // File: erc721a/contracts/IERC721A.sol
83 
84 
85 // ERC721A Contracts v4.2.3
86 // Creator: Chiru Labs
87 
88 pragma solidity ^0.8.4;
89 
90 /**
91  * @dev Interface of ERC721A.
92  */
93 interface IERC721A {
94     /**
95      * The caller must own the token or be an approved operator.
96      */
97     error ApprovalCallerNotOwnerNorApproved();
98 
99     /**
100      * The token does not exist.
101      */
102     error ApprovalQueryForNonexistentToken();
103 
104     /**
105      * Cannot query the balance for the zero address.
106      */
107     error BalanceQueryForZeroAddress();
108 
109     /**
110      * Cannot mint to the zero address.
111      */
112     error MintToZeroAddress();
113 
114     /**
115      * The quantity of tokens minted must be more than zero.
116      */
117     error MintZeroQuantity();
118 
119     /**
120      * The token does not exist.
121      */
122     error OwnerQueryForNonexistentToken();
123 
124     /**
125      * The caller must own the token or be an approved operator.
126      */
127     error TransferCallerNotOwnerNorApproved();
128 
129     /**
130      * The token must be owned by `from`.
131      */
132     error TransferFromIncorrectOwner();
133 
134     /**
135      * Cannot safely transfer to a contract that does not implement the
136      * ERC721Receiver interface.
137      */
138     error TransferToNonERC721ReceiverImplementer();
139 
140     /**
141      * Cannot transfer to the zero address.
142      */
143     error TransferToZeroAddress();
144 
145     /**
146      * The token does not exist.
147      */
148     error URIQueryForNonexistentToken();
149 
150     /**
151      * The `quantity` minted with ERC2309 exceeds the safety limit.
152      */
153     error MintERC2309QuantityExceedsLimit();
154 
155     /**
156      * The `extraData` cannot be set on an unintialized ownership slot.
157      */
158     error OwnershipNotInitializedForExtraData();
159 
160     // =============================================================
161     //                            STRUCTS
162     // =============================================================
163 
164     struct TokenOwnership {
165         // The address of the owner.
166         address addr;
167         // Stores the start time of ownership with minimal overhead for tokenomics.
168         uint64 startTimestamp;
169         // Whether the token has been burned.
170         bool burned;
171         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
172         uint24 extraData;
173     }
174 
175     // =============================================================
176     //                         TOKEN COUNTERS
177     // =============================================================
178 
179     /**
180      * @dev Returns the total number of tokens in existence.
181      * Burned tokens will reduce the count.
182      * To get the total number of tokens minted, please see {_totalMinted}.
183      */
184     function totalSupply() external view returns (uint256);
185 
186     // =============================================================
187     //                            IERC165
188     // =============================================================
189 
190     /**
191      * @dev Returns true if this contract implements the interface defined by
192      * `interfaceId`. See the corresponding
193      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
194      * to learn more about how these ids are created.
195      *
196      * This function call must use less than 30000 gas.
197      */
198     function supportsInterface(bytes4 interfaceId) external view returns (bool);
199 
200     // =============================================================
201     //                            IERC721
202     // =============================================================
203 
204     /**
205      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
206      */
207     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
208 
209     /**
210      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
211      */
212     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
213 
214     /**
215      * @dev Emitted when `owner` enables or disables
216      * (`approved`) `operator` to manage all of its assets.
217      */
218     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
219 
220     /**
221      * @dev Returns the number of tokens in `owner`'s account.
222      */
223     function balanceOf(address owner) external view returns (uint256 balance);
224 
225     /**
226      * @dev Returns the owner of the `tokenId` token.
227      *
228      * Requirements:
229      *
230      * - `tokenId` must exist.
231      */
232     function ownerOf(uint256 tokenId) external view returns (address owner);
233 
234     /**
235      * @dev Safely transfers `tokenId` token from `from` to `to`,
236      * checking first that contract recipients are aware of the ERC721 protocol
237      * to prevent tokens from being forever locked.
238      *
239      * Requirements:
240      *
241      * - `from` cannot be the zero address.
242      * - `to` cannot be the zero address.
243      * - `tokenId` token must exist and be owned by `from`.
244      * - If the caller is not `from`, it must be have been allowed to move
245      * this token by either {approve} or {setApprovalForAll}.
246      * - If `to` refers to a smart contract, it must implement
247      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
248      *
249      * Emits a {Transfer} event.
250      */
251     function safeTransferFrom(
252         address from,
253         address to,
254         uint256 tokenId,
255         bytes calldata data
256     ) external payable;
257 
258     /**
259      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
260      */
261     function safeTransferFrom(
262         address from,
263         address to,
264         uint256 tokenId
265     ) external payable;
266 
267     /**
268      * @dev Transfers `tokenId` from `from` to `to`.
269      *
270      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
271      * whenever possible.
272      *
273      * Requirements:
274      *
275      * - `from` cannot be the zero address.
276      * - `to` cannot be the zero address.
277      * - `tokenId` token must be owned by `from`.
278      * - If the caller is not `from`, it must be approved to move this token
279      * by either {approve} or {setApprovalForAll}.
280      *
281      * Emits a {Transfer} event.
282      */
283     function transferFrom(
284         address from,
285         address to,
286         uint256 tokenId
287     ) external payable;
288 
289     /**
290      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
291      * The approval is cleared when the token is transferred.
292      *
293      * Only a single account can be approved at a time, so approving the
294      * zero address clears previous approvals.
295      *
296      * Requirements:
297      *
298      * - The caller must own the token or be an approved operator.
299      * - `tokenId` must exist.
300      *
301      * Emits an {Approval} event.
302      */
303     function approve(address to, uint256 tokenId) external payable;
304 
305     /**
306      * @dev Approve or remove `operator` as an operator for the caller.
307      * Operators can call {transferFrom} or {safeTransferFrom}
308      * for any token owned by the caller.
309      *
310      * Requirements:
311      *
312      * - The `operator` cannot be the caller.
313      *
314      * Emits an {ApprovalForAll} event.
315      */
316     function setApprovalForAll(address operator, bool _approved) external;
317 
318     /**
319      * @dev Returns the account approved for `tokenId` token.
320      *
321      * Requirements:
322      *
323      * - `tokenId` must exist.
324      */
325     function getApproved(uint256 tokenId) external view returns (address operator);
326 
327     /**
328      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
329      *
330      * See {setApprovalForAll}.
331      */
332     function isApprovedForAll(address owner, address operator) external view returns (bool);
333 
334     // =============================================================
335     //                        IERC721Metadata
336     // =============================================================
337 
338     /**
339      * @dev Returns the token collection name.
340      */
341     function name() external view returns (string memory);
342 
343     /**
344      * @dev Returns the token collection symbol.
345      */
346     function symbol() external view returns (string memory);
347 
348     /**
349      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
350      */
351     function tokenURI(uint256 tokenId) external view returns (string memory);
352 
353     // =============================================================
354     //                           IERC2309
355     // =============================================================
356 
357     /**
358      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
359      * (inclusive) is transferred from `from` to `to`, as defined in the
360      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
361      *
362      * See {_mintERC2309} for more details.
363      */
364     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
365 }
366 
367 // File: erc721a/contracts/ERC721A.sol
368 
369 
370 // ERC721A Contracts v4.2.3
371 // Creator: Chiru Labs
372 
373 pragma solidity ^0.8.4;
374 
375 
376 /**
377  * @dev Interface of ERC721 token receiver.
378  */
379 interface ERC721A__IERC721Receiver {
380     function onERC721Received(
381         address operator,
382         address from,
383         uint256 tokenId,
384         bytes calldata data
385     ) external returns (bytes4);
386 }
387 
388 /**
389  * @title ERC721A
390  *
391  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
392  * Non-Fungible Token Standard, including the Metadata extension.
393  * Optimized for lower gas during batch mints.
394  *
395  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
396  * starting from `_startTokenId()`.
397  *
398  * Assumptions:
399  *
400  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
401  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
402  */
403 contract ERC721A is IERC721A {
404     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
405     struct TokenApprovalRef {
406         address value;
407     }
408 
409     // =============================================================
410     //                           CONSTANTS
411     // =============================================================
412 
413     // Mask of an entry in packed address data.
414     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
415 
416     // The bit position of `numberMinted` in packed address data.
417     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
418 
419     // The bit position of `numberBurned` in packed address data.
420     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
421 
422     // The bit position of `aux` in packed address data.
423     uint256 private constant _BITPOS_AUX = 192;
424 
425     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
426     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
427 
428     // The bit position of `startTimestamp` in packed ownership.
429     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
430 
431     // The bit mask of the `burned` bit in packed ownership.
432     uint256 private constant _BITMASK_BURNED = 1 << 224;
433 
434     // The bit position of the `nextInitialized` bit in packed ownership.
435     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
436 
437     // The bit mask of the `nextInitialized` bit in packed ownership.
438     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
439 
440     // The bit position of `extraData` in packed ownership.
441     uint256 private constant _BITPOS_EXTRA_DATA = 232;
442 
443     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
444     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
445 
446     // The mask of the lower 160 bits for addresses.
447     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
448 
449     // The maximum `quantity` that can be minted with {_mintERC2309}.
450     // This limit is to prevent overflows on the address data entries.
451     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
452     // is required to cause an overflow, which is unrealistic.
453     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
454 
455     // The `Transfer` event signature is given by:
456     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
457     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
458         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
459 
460     // =============================================================
461     //                            STORAGE
462     // =============================================================
463 
464     // The next token ID to be minted.
465     uint256 private _currentIndex;
466 
467     // The number of tokens burned.
468     uint256 private _burnCounter;
469 
470     // Token name
471     string private _name;
472 
473     // Token symbol
474     string private _symbol;
475 
476     // Mapping from token ID to ownership details
477     // An empty struct value does not necessarily mean the token is unowned.
478     // See {_packedOwnershipOf} implementation for details.
479     //
480     // Bits Layout:
481     // - [0..159]   `addr`
482     // - [160..223] `startTimestamp`
483     // - [224]      `burned`
484     // - [225]      `nextInitialized`
485     // - [232..255] `extraData`
486     mapping(uint256 => uint256) private _packedOwnerships;
487 
488     // Mapping owner address to address data.
489     //
490     // Bits Layout:
491     // - [0..63]    `balance`
492     // - [64..127]  `numberMinted`
493     // - [128..191] `numberBurned`
494     // - [192..255] `aux`
495     mapping(address => uint256) private _packedAddressData;
496 
497     // Mapping from token ID to approved address.
498     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
499 
500     // Mapping from owner to operator approvals
501     mapping(address => mapping(address => bool)) private _operatorApprovals;
502 
503     // =============================================================
504     //                          CONSTRUCTOR
505     // =============================================================
506 
507     constructor(string memory name_, string memory symbol_) {
508         _name = name_;
509         _symbol = symbol_;
510         _currentIndex = _startTokenId();
511     }
512 
513     // =============================================================
514     //                   TOKEN COUNTING OPERATIONS
515     // =============================================================
516 
517     /**
518      * @dev Returns the starting token ID.
519      * To change the starting token ID, please override this function.
520      */
521     function _startTokenId() internal view virtual returns (uint256) {
522         return 0;
523     }
524 
525     /**
526      * @dev Returns the next token ID to be minted.
527      */
528     function _nextTokenId() internal view virtual returns (uint256) {
529         return _currentIndex;
530     }
531 
532     /**
533      * @dev Returns the total number of tokens in existence.
534      * Burned tokens will reduce the count.
535      * To get the total number of tokens minted, please see {_totalMinted}.
536      */
537     function totalSupply() public view virtual override returns (uint256) {
538         // Counter underflow is impossible as _burnCounter cannot be incremented
539         // more than `_currentIndex - _startTokenId()` times.
540         unchecked {
541             return _currentIndex - _burnCounter - _startTokenId();
542         }
543     }
544 
545     /**
546      * @dev Returns the total amount of tokens minted in the contract.
547      */
548     function _totalMinted() internal view virtual returns (uint256) {
549         // Counter underflow is impossible as `_currentIndex` does not decrement,
550         // and it is initialized to `_startTokenId()`.
551         unchecked {
552             return _currentIndex - _startTokenId();
553         }
554     }
555 
556     /**
557      * @dev Returns the total number of tokens burned.
558      */
559     function _totalBurned() internal view virtual returns (uint256) {
560         return _burnCounter;
561     }
562 
563     // =============================================================
564     //                    ADDRESS DATA OPERATIONS
565     // =============================================================
566 
567     /**
568      * @dev Returns the number of tokens in `owner`'s account.
569      */
570     function balanceOf(address owner) public view virtual override returns (uint256) {
571         if (owner == address(0)) revert BalanceQueryForZeroAddress();
572         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
573     }
574 
575     /**
576      * Returns the number of tokens minted by `owner`.
577      */
578     function _numberMinted(address owner) internal view returns (uint256) {
579         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
580     }
581 
582     /**
583      * Returns the number of tokens burned by or on behalf of `owner`.
584      */
585     function _numberBurned(address owner) internal view returns (uint256) {
586         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
587     }
588 
589     /**
590      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
591      */
592     function _getAux(address owner) internal view returns (uint64) {
593         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
594     }
595 
596     /**
597      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
598      * If there are multiple variables, please pack them into a uint64.
599      */
600     function _setAux(address owner, uint64 aux) internal virtual {
601         uint256 packed = _packedAddressData[owner];
602         uint256 auxCasted;
603         // Cast `aux` with assembly to avoid redundant masking.
604         assembly {
605             auxCasted := aux
606         }
607         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
608         _packedAddressData[owner] = packed;
609     }
610 
611     // =============================================================
612     //                            IERC165
613     // =============================================================
614 
615     /**
616      * @dev Returns true if this contract implements the interface defined by
617      * `interfaceId`. See the corresponding
618      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
619      * to learn more about how these ids are created.
620      *
621      * This function call must use less than 30000 gas.
622      */
623     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
624         // The interface IDs are constants representing the first 4 bytes
625         // of the XOR of all function selectors in the interface.
626         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
627         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
628         return
629             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
630             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
631             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
632     }
633 
634     // =============================================================
635     //                        IERC721Metadata
636     // =============================================================
637 
638     /**
639      * @dev Returns the token collection name.
640      */
641     function name() public view virtual override returns (string memory) {
642         return _name;
643     }
644 
645     /**
646      * @dev Returns the token collection symbol.
647      */
648     function symbol() public view virtual override returns (string memory) {
649         return _symbol;
650     }
651 
652     /**
653      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
654      */
655     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
656         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
657 
658         string memory baseURI = _baseURI();
659         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
660     }
661 
662     /**
663      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
664      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
665      * by default, it can be overridden in child contracts.
666      */
667     function _baseURI() internal view virtual returns (string memory) {
668         return '';
669     }
670 
671     // =============================================================
672     //                     OWNERSHIPS OPERATIONS
673     // =============================================================
674 
675     /**
676      * @dev Returns the owner of the `tokenId` token.
677      *
678      * Requirements:
679      *
680      * - `tokenId` must exist.
681      */
682     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
683         return address(uint160(_packedOwnershipOf(tokenId)));
684     }
685 
686     /**
687      * @dev Gas spent here starts off proportional to the maximum mint batch size.
688      * It gradually moves to O(1) as tokens get transferred around over time.
689      */
690     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
691         return _unpackedOwnership(_packedOwnershipOf(tokenId));
692     }
693 
694     /**
695      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
696      */
697     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
698         return _unpackedOwnership(_packedOwnerships[index]);
699     }
700 
701     /**
702      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
703      */
704     function _initializeOwnershipAt(uint256 index) internal virtual {
705         if (_packedOwnerships[index] == 0) {
706             _packedOwnerships[index] = _packedOwnershipOf(index);
707         }
708     }
709 
710     /**
711      * Returns the packed ownership data of `tokenId`.
712      */
713     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
714         uint256 curr = tokenId;
715 
716         unchecked {
717             if (_startTokenId() <= curr)
718                 if (curr < _currentIndex) {
719                     uint256 packed = _packedOwnerships[curr];
720                     // If not burned.
721                     if (packed & _BITMASK_BURNED == 0) {
722                         // Invariant:
723                         // There will always be an initialized ownership slot
724                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
725                         // before an unintialized ownership slot
726                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
727                         // Hence, `curr` will not underflow.
728                         //
729                         // We can directly compare the packed value.
730                         // If the address is zero, packed will be zero.
731                         while (packed == 0) {
732                             packed = _packedOwnerships[--curr];
733                         }
734                         return packed;
735                     }
736                 }
737         }
738         revert OwnerQueryForNonexistentToken();
739     }
740 
741     /**
742      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
743      */
744     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
745         ownership.addr = address(uint160(packed));
746         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
747         ownership.burned = packed & _BITMASK_BURNED != 0;
748         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
749     }
750 
751     /**
752      * @dev Packs ownership data into a single uint256.
753      */
754     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
755         assembly {
756             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
757             owner := and(owner, _BITMASK_ADDRESS)
758             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
759             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
760         }
761     }
762 
763     /**
764      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
765      */
766     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
767         // For branchless setting of the `nextInitialized` flag.
768         assembly {
769             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
770             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
771         }
772     }
773 
774     // =============================================================
775     //                      APPROVAL OPERATIONS
776     // =============================================================
777 
778     /**
779      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
780      * The approval is cleared when the token is transferred.
781      *
782      * Only a single account can be approved at a time, so approving the
783      * zero address clears previous approvals.
784      *
785      * Requirements:
786      *
787      * - The caller must own the token or be an approved operator.
788      * - `tokenId` must exist.
789      *
790      * Emits an {Approval} event.
791      */
792     function approve(address to, uint256 tokenId) public payable virtual override {
793         address owner = ownerOf(tokenId);
794 
795         if (_msgSenderERC721A() != owner)
796             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
797                 revert ApprovalCallerNotOwnerNorApproved();
798             }
799 
800         _tokenApprovals[tokenId].value = to;
801         emit Approval(owner, to, tokenId);
802     }
803 
804     /**
805      * @dev Returns the account approved for `tokenId` token.
806      *
807      * Requirements:
808      *
809      * - `tokenId` must exist.
810      */
811     function getApproved(uint256 tokenId) public view virtual override returns (address) {
812         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
813 
814         return _tokenApprovals[tokenId].value;
815     }
816 
817     /**
818      * @dev Approve or remove `operator` as an operator for the caller.
819      * Operators can call {transferFrom} or {safeTransferFrom}
820      * for any token owned by the caller.
821      *
822      * Requirements:
823      *
824      * - The `operator` cannot be the caller.
825      *
826      * Emits an {ApprovalForAll} event.
827      */
828     function setApprovalForAll(address operator, bool approved) public virtual override {
829         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
830         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
831     }
832 
833     /**
834      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
835      *
836      * See {setApprovalForAll}.
837      */
838     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
839         return _operatorApprovals[owner][operator];
840     }
841 
842     /**
843      * @dev Returns whether `tokenId` exists.
844      *
845      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
846      *
847      * Tokens start existing when they are minted. See {_mint}.
848      */
849     function _exists(uint256 tokenId) internal view virtual returns (bool) {
850         return
851             _startTokenId() <= tokenId &&
852             tokenId < _currentIndex && // If within bounds,
853             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
854     }
855 
856     /**
857      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
858      */
859     function _isSenderApprovedOrOwner(
860         address approvedAddress,
861         address owner,
862         address msgSender
863     ) private pure returns (bool result) {
864         assembly {
865             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
866             owner := and(owner, _BITMASK_ADDRESS)
867             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
868             msgSender := and(msgSender, _BITMASK_ADDRESS)
869             // `msgSender == owner || msgSender == approvedAddress`.
870             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
871         }
872     }
873 
874     /**
875      * @dev Returns the storage slot and value for the approved address of `tokenId`.
876      */
877     function _getApprovedSlotAndAddress(uint256 tokenId)
878         private
879         view
880         returns (uint256 approvedAddressSlot, address approvedAddress)
881     {
882         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
883         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
884         assembly {
885             approvedAddressSlot := tokenApproval.slot
886             approvedAddress := sload(approvedAddressSlot)
887         }
888     }
889 
890     // =============================================================
891     //                      TRANSFER OPERATIONS
892     // =============================================================
893 
894     /**
895      * @dev Transfers `tokenId` from `from` to `to`.
896      *
897      * Requirements:
898      *
899      * - `from` cannot be the zero address.
900      * - `to` cannot be the zero address.
901      * - `tokenId` token must be owned by `from`.
902      * - If the caller is not `from`, it must be approved to move this token
903      * by either {approve} or {setApprovalForAll}.
904      *
905      * Emits a {Transfer} event.
906      */
907     function transferFrom(
908         address from,
909         address to,
910         uint256 tokenId
911     ) public payable virtual override {
912         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
913 
914         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
915 
916         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
917 
918         // The nested ifs save around 20+ gas over a compound boolean condition.
919         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
920             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
921 
922         if (to == address(0)) revert TransferToZeroAddress();
923 
924         _beforeTokenTransfers(from, to, tokenId, 1);
925 
926         // Clear approvals from the previous owner.
927         assembly {
928             if approvedAddress {
929                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
930                 sstore(approvedAddressSlot, 0)
931             }
932         }
933 
934         // Underflow of the sender's balance is impossible because we check for
935         // ownership above and the recipient's balance can't realistically overflow.
936         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
937         unchecked {
938             // We can directly increment and decrement the balances.
939             --_packedAddressData[from]; // Updates: `balance -= 1`.
940             ++_packedAddressData[to]; // Updates: `balance += 1`.
941 
942             // Updates:
943             // - `address` to the next owner.
944             // - `startTimestamp` to the timestamp of transfering.
945             // - `burned` to `false`.
946             // - `nextInitialized` to `true`.
947             _packedOwnerships[tokenId] = _packOwnershipData(
948                 to,
949                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
950             );
951 
952             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
953             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
954                 uint256 nextTokenId = tokenId + 1;
955                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
956                 if (_packedOwnerships[nextTokenId] == 0) {
957                     // If the next slot is within bounds.
958                     if (nextTokenId != _currentIndex) {
959                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
960                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
961                     }
962                 }
963             }
964         }
965 
966         emit Transfer(from, to, tokenId);
967         _afterTokenTransfers(from, to, tokenId, 1);
968     }
969 
970     /**
971      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
972      */
973     function safeTransferFrom(
974         address from,
975         address to,
976         uint256 tokenId
977     ) public payable virtual override {
978         safeTransferFrom(from, to, tokenId, '');
979     }
980 
981     /**
982      * @dev Safely transfers `tokenId` token from `from` to `to`.
983      *
984      * Requirements:
985      *
986      * - `from` cannot be the zero address.
987      * - `to` cannot be the zero address.
988      * - `tokenId` token must exist and be owned by `from`.
989      * - If the caller is not `from`, it must be approved to move this token
990      * by either {approve} or {setApprovalForAll}.
991      * - If `to` refers to a smart contract, it must implement
992      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
993      *
994      * Emits a {Transfer} event.
995      */
996     function safeTransferFrom(
997         address from,
998         address to,
999         uint256 tokenId,
1000         bytes memory _data
1001     ) public payable virtual override {
1002         transferFrom(from, to, tokenId);
1003         if (to.code.length != 0)
1004             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1005                 revert TransferToNonERC721ReceiverImplementer();
1006             }
1007     }
1008 
1009     /**
1010      * @dev Hook that is called before a set of serially-ordered token IDs
1011      * are about to be transferred. This includes minting.
1012      * And also called before burning one token.
1013      *
1014      * `startTokenId` - the first token ID to be transferred.
1015      * `quantity` - the amount to be transferred.
1016      *
1017      * Calling conditions:
1018      *
1019      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1020      * transferred to `to`.
1021      * - When `from` is zero, `tokenId` will be minted for `to`.
1022      * - When `to` is zero, `tokenId` will be burned by `from`.
1023      * - `from` and `to` are never both zero.
1024      */
1025     function _beforeTokenTransfers(
1026         address from,
1027         address to,
1028         uint256 startTokenId,
1029         uint256 quantity
1030     ) internal virtual {}
1031 
1032     /**
1033      * @dev Hook that is called after a set of serially-ordered token IDs
1034      * have been transferred. This includes minting.
1035      * And also called after one token has been burned.
1036      *
1037      * `startTokenId` - the first token ID to be transferred.
1038      * `quantity` - the amount to be transferred.
1039      *
1040      * Calling conditions:
1041      *
1042      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1043      * transferred to `to`.
1044      * - When `from` is zero, `tokenId` has been minted for `to`.
1045      * - When `to` is zero, `tokenId` has been burned by `from`.
1046      * - `from` and `to` are never both zero.
1047      */
1048     function _afterTokenTransfers(
1049         address from,
1050         address to,
1051         uint256 startTokenId,
1052         uint256 quantity
1053     ) internal virtual {}
1054 
1055     /**
1056      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1057      *
1058      * `from` - Previous owner of the given token ID.
1059      * `to` - Target address that will receive the token.
1060      * `tokenId` - Token ID to be transferred.
1061      * `_data` - Optional data to send along with the call.
1062      *
1063      * Returns whether the call correctly returned the expected magic value.
1064      */
1065     function _checkContractOnERC721Received(
1066         address from,
1067         address to,
1068         uint256 tokenId,
1069         bytes memory _data
1070     ) private returns (bool) {
1071         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1072             bytes4 retval
1073         ) {
1074             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1075         } catch (bytes memory reason) {
1076             if (reason.length == 0) {
1077                 revert TransferToNonERC721ReceiverImplementer();
1078             } else {
1079                 assembly {
1080                     revert(add(32, reason), mload(reason))
1081                 }
1082             }
1083         }
1084     }
1085 
1086     // =============================================================
1087     //                        MINT OPERATIONS
1088     // =============================================================
1089 
1090     /**
1091      * @dev Mints `quantity` tokens and transfers them to `to`.
1092      *
1093      * Requirements:
1094      *
1095      * - `to` cannot be the zero address.
1096      * - `quantity` must be greater than 0.
1097      *
1098      * Emits a {Transfer} event for each mint.
1099      */
1100     function _mint(address to, uint256 quantity) internal virtual {
1101         uint256 startTokenId = _currentIndex;
1102         if (quantity == 0) revert MintZeroQuantity();
1103 
1104         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1105 
1106         // Overflows are incredibly unrealistic.
1107         // `balance` and `numberMinted` have a maximum limit of 2**64.
1108         // `tokenId` has a maximum limit of 2**256.
1109         unchecked {
1110             // Updates:
1111             // - `balance += quantity`.
1112             // - `numberMinted += quantity`.
1113             //
1114             // We can directly add to the `balance` and `numberMinted`.
1115             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1116 
1117             // Updates:
1118             // - `address` to the owner.
1119             // - `startTimestamp` to the timestamp of minting.
1120             // - `burned` to `false`.
1121             // - `nextInitialized` to `quantity == 1`.
1122             _packedOwnerships[startTokenId] = _packOwnershipData(
1123                 to,
1124                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1125             );
1126 
1127             uint256 toMasked;
1128             uint256 end = startTokenId + quantity;
1129 
1130             // Use assembly to loop and emit the `Transfer` event for gas savings.
1131             // The duplicated `log4` removes an extra check and reduces stack juggling.
1132             // The assembly, together with the surrounding Solidity code, have been
1133             // delicately arranged to nudge the compiler into producing optimized opcodes.
1134             assembly {
1135                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1136                 toMasked := and(to, _BITMASK_ADDRESS)
1137                 // Emit the `Transfer` event.
1138                 log4(
1139                     0, // Start of data (0, since no data).
1140                     0, // End of data (0, since no data).
1141                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1142                     0, // `address(0)`.
1143                     toMasked, // `to`.
1144                     startTokenId // `tokenId`.
1145                 )
1146 
1147                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1148                 // that overflows uint256 will make the loop run out of gas.
1149                 // The compiler will optimize the `iszero` away for performance.
1150                 for {
1151                     let tokenId := add(startTokenId, 1)
1152                 } iszero(eq(tokenId, end)) {
1153                     tokenId := add(tokenId, 1)
1154                 } {
1155                     // Emit the `Transfer` event. Similar to above.
1156                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1157                 }
1158             }
1159             if (toMasked == 0) revert MintToZeroAddress();
1160 
1161             _currentIndex = end;
1162         }
1163         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1164     }
1165 
1166     /**
1167      * @dev Mints `quantity` tokens and transfers them to `to`.
1168      *
1169      * This function is intended for efficient minting only during contract creation.
1170      *
1171      * It emits only one {ConsecutiveTransfer} as defined in
1172      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1173      * instead of a sequence of {Transfer} event(s).
1174      *
1175      * Calling this function outside of contract creation WILL make your contract
1176      * non-compliant with the ERC721 standard.
1177      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1178      * {ConsecutiveTransfer} event is only permissible during contract creation.
1179      *
1180      * Requirements:
1181      *
1182      * - `to` cannot be the zero address.
1183      * - `quantity` must be greater than 0.
1184      *
1185      * Emits a {ConsecutiveTransfer} event.
1186      */
1187     function _mintERC2309(address to, uint256 quantity) internal virtual {
1188         uint256 startTokenId = _currentIndex;
1189         if (to == address(0)) revert MintToZeroAddress();
1190         if (quantity == 0) revert MintZeroQuantity();
1191         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1192 
1193         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1194 
1195         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1196         unchecked {
1197             // Updates:
1198             // - `balance += quantity`.
1199             // - `numberMinted += quantity`.
1200             //
1201             // We can directly add to the `balance` and `numberMinted`.
1202             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1203 
1204             // Updates:
1205             // - `address` to the owner.
1206             // - `startTimestamp` to the timestamp of minting.
1207             // - `burned` to `false`.
1208             // - `nextInitialized` to `quantity == 1`.
1209             _packedOwnerships[startTokenId] = _packOwnershipData(
1210                 to,
1211                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1212             );
1213 
1214             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1215 
1216             _currentIndex = startTokenId + quantity;
1217         }
1218         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1219     }
1220 
1221     /**
1222      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1223      *
1224      * Requirements:
1225      *
1226      * - If `to` refers to a smart contract, it must implement
1227      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1228      * - `quantity` must be greater than 0.
1229      *
1230      * See {_mint}.
1231      *
1232      * Emits a {Transfer} event for each mint.
1233      */
1234     function _safeMint(
1235         address to,
1236         uint256 quantity,
1237         bytes memory _data
1238     ) internal virtual {
1239         _mint(to, quantity);
1240 
1241         unchecked {
1242             if (to.code.length != 0) {
1243                 uint256 end = _currentIndex;
1244                 uint256 index = end - quantity;
1245                 do {
1246                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1247                         revert TransferToNonERC721ReceiverImplementer();
1248                     }
1249                 } while (index < end);
1250                 // Reentrancy protection.
1251                 if (_currentIndex != end) revert();
1252             }
1253         }
1254     }
1255 
1256     /**
1257      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1258      */
1259     function _safeMint(address to, uint256 quantity) internal virtual {
1260         _safeMint(to, quantity, '');
1261     }
1262 
1263     // =============================================================
1264     //                        BURN OPERATIONS
1265     // =============================================================
1266 
1267     /**
1268      * @dev Equivalent to `_burn(tokenId, false)`.
1269      */
1270     function _burn(uint256 tokenId) internal virtual {
1271         _burn(tokenId, false);
1272     }
1273 
1274     /**
1275      * @dev Destroys `tokenId`.
1276      * The approval is cleared when the token is burned.
1277      *
1278      * Requirements:
1279      *
1280      * - `tokenId` must exist.
1281      *
1282      * Emits a {Transfer} event.
1283      */
1284     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1285         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1286 
1287         address from = address(uint160(prevOwnershipPacked));
1288 
1289         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1290 
1291         if (approvalCheck) {
1292             // The nested ifs save around 20+ gas over a compound boolean condition.
1293             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1294                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1295         }
1296 
1297         _beforeTokenTransfers(from, address(0), tokenId, 1);
1298 
1299         // Clear approvals from the previous owner.
1300         assembly {
1301             if approvedAddress {
1302                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1303                 sstore(approvedAddressSlot, 0)
1304             }
1305         }
1306 
1307         // Underflow of the sender's balance is impossible because we check for
1308         // ownership above and the recipient's balance can't realistically overflow.
1309         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1310         unchecked {
1311             // Updates:
1312             // - `balance -= 1`.
1313             // - `numberBurned += 1`.
1314             //
1315             // We can directly decrement the balance, and increment the number burned.
1316             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1317             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1318 
1319             // Updates:
1320             // - `address` to the last owner.
1321             // - `startTimestamp` to the timestamp of burning.
1322             // - `burned` to `true`.
1323             // - `nextInitialized` to `true`.
1324             _packedOwnerships[tokenId] = _packOwnershipData(
1325                 from,
1326                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1327             );
1328 
1329             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1330             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1331                 uint256 nextTokenId = tokenId + 1;
1332                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1333                 if (_packedOwnerships[nextTokenId] == 0) {
1334                     // If the next slot is within bounds.
1335                     if (nextTokenId != _currentIndex) {
1336                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1337                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1338                     }
1339                 }
1340             }
1341         }
1342 
1343         emit Transfer(from, address(0), tokenId);
1344         _afterTokenTransfers(from, address(0), tokenId, 1);
1345 
1346         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1347         unchecked {
1348             _burnCounter++;
1349         }
1350     }
1351 
1352     // =============================================================
1353     //                     EXTRA DATA OPERATIONS
1354     // =============================================================
1355 
1356     /**
1357      * @dev Directly sets the extra data for the ownership data `index`.
1358      */
1359     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1360         uint256 packed = _packedOwnerships[index];
1361         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1362         uint256 extraDataCasted;
1363         // Cast `extraData` with assembly to avoid redundant masking.
1364         assembly {
1365             extraDataCasted := extraData
1366         }
1367         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1368         _packedOwnerships[index] = packed;
1369     }
1370 
1371     /**
1372      * @dev Called during each token transfer to set the 24bit `extraData` field.
1373      * Intended to be overridden by the cosumer contract.
1374      *
1375      * `previousExtraData` - the value of `extraData` before transfer.
1376      *
1377      * Calling conditions:
1378      *
1379      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1380      * transferred to `to`.
1381      * - When `from` is zero, `tokenId` will be minted for `to`.
1382      * - When `to` is zero, `tokenId` will be burned by `from`.
1383      * - `from` and `to` are never both zero.
1384      */
1385     function _extraData(
1386         address from,
1387         address to,
1388         uint24 previousExtraData
1389     ) internal view virtual returns (uint24) {}
1390 
1391     /**
1392      * @dev Returns the next extra data for the packed ownership data.
1393      * The returned result is shifted into position.
1394      */
1395     function _nextExtraData(
1396         address from,
1397         address to,
1398         uint256 prevOwnershipPacked
1399     ) private view returns (uint256) {
1400         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1401         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1402     }
1403 
1404     // =============================================================
1405     //                       OTHER OPERATIONS
1406     // =============================================================
1407 
1408     /**
1409      * @dev Returns the message sender (defaults to `msg.sender`).
1410      *
1411      * If you are writing GSN compatible contracts, you need to override this function.
1412      */
1413     function _msgSenderERC721A() internal view virtual returns (address) {
1414         return msg.sender;
1415     }
1416 
1417     /**
1418      * @dev Converts a uint256 to its ASCII string decimal representation.
1419      */
1420     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1421         assembly {
1422             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1423             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1424             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1425             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1426             let m := add(mload(0x40), 0xa0)
1427             // Update the free memory pointer to allocate.
1428             mstore(0x40, m)
1429             // Assign the `str` to the end.
1430             str := sub(m, 0x20)
1431             // Zeroize the slot after the string.
1432             mstore(str, 0)
1433 
1434             // Cache the end of the memory to calculate the length later.
1435             let end := str
1436 
1437             // We write the string from rightmost digit to leftmost digit.
1438             // The following is essentially a do-while loop that also handles the zero case.
1439             // prettier-ignore
1440             for { let temp := value } 1 {} {
1441                 str := sub(str, 1)
1442                 // Write the character to the pointer.
1443                 // The ASCII index of the '0' character is 48.
1444                 mstore8(str, add(48, mod(temp, 10)))
1445                 // Keep dividing `temp` until zero.
1446                 temp := div(temp, 10)
1447                 // prettier-ignore
1448                 if iszero(temp) { break }
1449             }
1450 
1451             let length := sub(end, str)
1452             // Move the pointer 32 bytes leftwards to make room for the length.
1453             str := sub(str, 0x20)
1454             // Store the length.
1455             mstore(str, length)
1456         }
1457     }
1458 }
1459 
1460 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
1461 
1462 
1463 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/MerkleProof.sol)
1464 
1465 pragma solidity ^0.8.0;
1466 
1467 /**
1468  * @dev These functions deal with verification of Merkle Tree proofs.
1469  *
1470  * The tree and the proofs can be generated using our
1471  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
1472  * You will find a quickstart guide in the readme.
1473  *
1474  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1475  * hashing, or use a hash function other than keccak256 for hashing leaves.
1476  * This is because the concatenation of a sorted pair of internal nodes in
1477  * the merkle tree could be reinterpreted as a leaf value.
1478  * OpenZeppelin's JavaScript library generates merkle trees that are safe
1479  * against this attack out of the box.
1480  */
1481 library MerkleProof {
1482     /**
1483      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1484      * defined by `root`. For this, a `proof` must be provided, containing
1485      * sibling hashes on the branch from the leaf to the root of the tree. Each
1486      * pair of leaves and each pair of pre-images are assumed to be sorted.
1487      */
1488     function verify(
1489         bytes32[] memory proof,
1490         bytes32 root,
1491         bytes32 leaf
1492     ) internal pure returns (bool) {
1493         return processProof(proof, leaf) == root;
1494     }
1495 
1496     /**
1497      * @dev Calldata version of {verify}
1498      *
1499      * _Available since v4.7._
1500      */
1501     function verifyCalldata(
1502         bytes32[] calldata proof,
1503         bytes32 root,
1504         bytes32 leaf
1505     ) internal pure returns (bool) {
1506         return processProofCalldata(proof, leaf) == root;
1507     }
1508 
1509     /**
1510      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1511      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1512      * hash matches the root of the tree. When processing the proof, the pairs
1513      * of leafs & pre-images are assumed to be sorted.
1514      *
1515      * _Available since v4.4._
1516      */
1517     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1518         bytes32 computedHash = leaf;
1519         for (uint256 i = 0; i < proof.length; i++) {
1520             computedHash = _hashPair(computedHash, proof[i]);
1521         }
1522         return computedHash;
1523     }
1524 
1525     /**
1526      * @dev Calldata version of {processProof}
1527      *
1528      * _Available since v4.7._
1529      */
1530     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
1531         bytes32 computedHash = leaf;
1532         for (uint256 i = 0; i < proof.length; i++) {
1533             computedHash = _hashPair(computedHash, proof[i]);
1534         }
1535         return computedHash;
1536     }
1537 
1538     /**
1539      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
1540      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
1541      *
1542      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
1543      *
1544      * _Available since v4.7._
1545      */
1546     function multiProofVerify(
1547         bytes32[] memory proof,
1548         bool[] memory proofFlags,
1549         bytes32 root,
1550         bytes32[] memory leaves
1551     ) internal pure returns (bool) {
1552         return processMultiProof(proof, proofFlags, leaves) == root;
1553     }
1554 
1555     /**
1556      * @dev Calldata version of {multiProofVerify}
1557      *
1558      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
1559      *
1560      * _Available since v4.7._
1561      */
1562     function multiProofVerifyCalldata(
1563         bytes32[] calldata proof,
1564         bool[] calldata proofFlags,
1565         bytes32 root,
1566         bytes32[] memory leaves
1567     ) internal pure returns (bool) {
1568         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
1569     }
1570 
1571     /**
1572      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
1573      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
1574      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
1575      * respectively.
1576      *
1577      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
1578      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
1579      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
1580      *
1581      * _Available since v4.7._
1582      */
1583     function processMultiProof(
1584         bytes32[] memory proof,
1585         bool[] memory proofFlags,
1586         bytes32[] memory leaves
1587     ) internal pure returns (bytes32 merkleRoot) {
1588         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1589         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1590         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1591         // the merkle tree.
1592         uint256 leavesLen = leaves.length;
1593         uint256 totalHashes = proofFlags.length;
1594 
1595         // Check proof validity.
1596         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1597 
1598         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1599         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1600         bytes32[] memory hashes = new bytes32[](totalHashes);
1601         uint256 leafPos = 0;
1602         uint256 hashPos = 0;
1603         uint256 proofPos = 0;
1604         // At each step, we compute the next hash using two values:
1605         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1606         //   get the next hash.
1607         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1608         //   `proof` array.
1609         for (uint256 i = 0; i < totalHashes; i++) {
1610             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1611             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1612             hashes[i] = _hashPair(a, b);
1613         }
1614 
1615         if (totalHashes > 0) {
1616             return hashes[totalHashes - 1];
1617         } else if (leavesLen > 0) {
1618             return leaves[0];
1619         } else {
1620             return proof[0];
1621         }
1622     }
1623 
1624     /**
1625      * @dev Calldata version of {processMultiProof}.
1626      *
1627      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
1628      *
1629      * _Available since v4.7._
1630      */
1631     function processMultiProofCalldata(
1632         bytes32[] calldata proof,
1633         bool[] calldata proofFlags,
1634         bytes32[] memory leaves
1635     ) internal pure returns (bytes32 merkleRoot) {
1636         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1637         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1638         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1639         // the merkle tree.
1640         uint256 leavesLen = leaves.length;
1641         uint256 totalHashes = proofFlags.length;
1642 
1643         // Check proof validity.
1644         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1645 
1646         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1647         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1648         bytes32[] memory hashes = new bytes32[](totalHashes);
1649         uint256 leafPos = 0;
1650         uint256 hashPos = 0;
1651         uint256 proofPos = 0;
1652         // At each step, we compute the next hash using two values:
1653         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1654         //   get the next hash.
1655         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1656         //   `proof` array.
1657         for (uint256 i = 0; i < totalHashes; i++) {
1658             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1659             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1660             hashes[i] = _hashPair(a, b);
1661         }
1662 
1663         if (totalHashes > 0) {
1664             return hashes[totalHashes - 1];
1665         } else if (leavesLen > 0) {
1666             return leaves[0];
1667         } else {
1668             return proof[0];
1669         }
1670     }
1671 
1672     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
1673         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
1674     }
1675 
1676     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1677         /// @solidity memory-safe-assembly
1678         assembly {
1679             mstore(0x00, a)
1680             mstore(0x20, b)
1681             value := keccak256(0x00, 0x40)
1682         }
1683     }
1684 }
1685 
1686 // File: @openzeppelin/contracts/utils/Context.sol
1687 
1688 
1689 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1690 
1691 pragma solidity ^0.8.0;
1692 
1693 /**
1694  * @dev Provides information about the current execution context, including the
1695  * sender of the transaction and its data. While these are generally available
1696  * via msg.sender and msg.data, they should not be accessed in such a direct
1697  * manner, since when dealing with meta-transactions the account sending and
1698  * paying for execution may not be the actual sender (as far as an application
1699  * is concerned).
1700  *
1701  * This contract is only required for intermediate, library-like contracts.
1702  */
1703 abstract contract Context {
1704     function _msgSender() internal view virtual returns (address) {
1705         return msg.sender;
1706     }
1707 
1708     function _msgData() internal view virtual returns (bytes calldata) {
1709         return msg.data;
1710     }
1711 }
1712 
1713 // File: @openzeppelin/contracts/access/Ownable.sol
1714 
1715 
1716 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1717 
1718 pragma solidity ^0.8.0;
1719 
1720 
1721 /**
1722  * @dev Contract module which provides a basic access control mechanism, where
1723  * there is an account (an owner) that can be granted exclusive access to
1724  * specific functions.
1725  *
1726  * By default, the owner account will be the one that deploys the contract. This
1727  * can later be changed with {transferOwnership}.
1728  *
1729  * This module is used through inheritance. It will make available the modifier
1730  * `onlyOwner`, which can be applied to your functions to restrict their use to
1731  * the owner.
1732  */
1733 abstract contract Ownable is Context {
1734     address private _owner;
1735 
1736     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1737 
1738     /**
1739      * @dev Initializes the contract setting the deployer as the initial owner.
1740      */
1741     constructor() {
1742         _transferOwnership(_msgSender());
1743     }
1744 
1745     /**
1746      * @dev Throws if called by any account other than the owner.
1747      */
1748     modifier onlyOwner() {
1749         _checkOwner();
1750         _;
1751     }
1752 
1753     /**
1754      * @dev Returns the address of the current owner.
1755      */
1756     function owner() public view virtual returns (address) {
1757         return _owner;
1758     }
1759 
1760     /**
1761      * @dev Throws if the sender is not the owner.
1762      */
1763     function _checkOwner() internal view virtual {
1764         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1765     }
1766 
1767     /**
1768      * @dev Leaves the contract without owner. It will not be possible to call
1769      * `onlyOwner` functions anymore. Can only be called by the current owner.
1770      *
1771      * NOTE: Renouncing ownership will leave the contract without an owner,
1772      * thereby removing any functionality that is only available to the owner.
1773      */
1774     function renounceOwnership() public virtual onlyOwner {
1775         _transferOwnership(address(0));
1776     }
1777 
1778     /**
1779      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1780      * Can only be called by the current owner.
1781      */
1782     function transferOwnership(address newOwner) public virtual onlyOwner {
1783         require(newOwner != address(0), "Ownable: new owner is the zero address");
1784         _transferOwnership(newOwner);
1785     }
1786 
1787     /**
1788      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1789      * Internal function without access restriction.
1790      */
1791     function _transferOwnership(address newOwner) internal virtual {
1792         address oldOwner = _owner;
1793         _owner = newOwner;
1794         emit OwnershipTransferred(oldOwner, newOwner);
1795     }
1796 }
1797 
1798 // File: lib/Constants.sol
1799 
1800 
1801 pragma solidity ^0.8.13;
1802 
1803 address constant CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS = 0x000000000000AAeB6D7670E522A718067333cd4E;
1804 address constant CANONICAL_CORI_SUBSCRIPTION = 0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6;
1805 
1806 // File: IOperatorFilterRegistry.sol
1807 
1808 
1809 pragma solidity ^0.8.13;
1810 
1811 interface IOperatorFilterRegistry {
1812     /**
1813      * @notice Returns true if operator is not filtered for a given token, either by address or codeHash. Also returns
1814      *         true if supplied registrant address is not registered.
1815      */
1816     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1817 
1818     /**
1819      * @notice Registers an address with the registry. May be called by address itself or by EIP-173 owner.
1820      */
1821     function register(address registrant) external;
1822 
1823     /**
1824      * @notice Registers an address with the registry and "subscribes" to another address's filtered operators and codeHashes.
1825      */
1826     function registerAndSubscribe(address registrant, address subscription) external;
1827 
1828     /**
1829      * @notice Registers an address with the registry and copies the filtered operators and codeHashes from another
1830      *         address without subscribing.
1831      */
1832     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1833 
1834     /**
1835      * @notice Unregisters an address with the registry and removes its subscription. May be called by address itself or by EIP-173 owner.
1836      *         Note that this does not remove any filtered addresses or codeHashes.
1837      *         Also note that any subscriptions to this registrant will still be active and follow the existing filtered addresses and codehashes.
1838      */
1839     function unregister(address addr) external;
1840 
1841     /**
1842      * @notice Update an operator address for a registered address - when filtered is true, the operator is filtered.
1843      */
1844     function updateOperator(address registrant, address operator, bool filtered) external;
1845 
1846     /**
1847      * @notice Update multiple operators for a registered address - when filtered is true, the operators will be filtered. Reverts on duplicates.
1848      */
1849     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1850 
1851     /**
1852      * @notice Update a codeHash for a registered address - when filtered is true, the codeHash is filtered.
1853      */
1854     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1855 
1856     /**
1857      * @notice Update multiple codeHashes for a registered address - when filtered is true, the codeHashes will be filtered. Reverts on duplicates.
1858      */
1859     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1860 
1861     /**
1862      * @notice Subscribe an address to another registrant's filtered operators and codeHashes. Will remove previous
1863      *         subscription if present.
1864      *         Note that accounts with subscriptions may go on to subscribe to other accounts - in this case,
1865      *         subscriptions will not be forwarded. Instead the former subscription's existing entries will still be
1866      *         used.
1867      */
1868     function subscribe(address registrant, address registrantToSubscribe) external;
1869 
1870     /**
1871      * @notice Unsubscribe an address from its current subscribed registrant, and optionally copy its filtered operators and codeHashes.
1872      */
1873     function unsubscribe(address registrant, bool copyExistingEntries) external;
1874 
1875     /**
1876      * @notice Get the subscription address of a given registrant, if any.
1877      */
1878     function subscriptionOf(address addr) external returns (address registrant);
1879 
1880     /**
1881      * @notice Get the set of addresses subscribed to a given registrant.
1882      *         Note that order is not guaranteed as updates are made.
1883      */
1884     function subscribers(address registrant) external returns (address[] memory);
1885 
1886     /**
1887      * @notice Get the subscriber at a given index in the set of addresses subscribed to a given registrant.
1888      *         Note that order is not guaranteed as updates are made.
1889      */
1890     function subscriberAt(address registrant, uint256 index) external returns (address);
1891 
1892     /**
1893      * @notice Copy filtered operators and codeHashes from a different registrantToCopy to addr.
1894      */
1895     function copyEntriesOf(address registrant, address registrantToCopy) external;
1896 
1897     /**
1898      * @notice Returns true if operator is filtered by a given address or its subscription.
1899      */
1900     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1901 
1902     /**
1903      * @notice Returns true if the hash of an address's code is filtered by a given address or its subscription.
1904      */
1905     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1906 
1907     /**
1908      * @notice Returns true if a codeHash is filtered by a given address or its subscription.
1909      */
1910     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1911 
1912     /**
1913      * @notice Returns a list of filtered operators for a given address or its subscription.
1914      */
1915     function filteredOperators(address addr) external returns (address[] memory);
1916 
1917     /**
1918      * @notice Returns the set of filtered codeHashes for a given address or its subscription.
1919      *         Note that order is not guaranteed as updates are made.
1920      */
1921     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1922 
1923     /**
1924      * @notice Returns the filtered operator at the given index of the set of filtered operators for a given address or
1925      *         its subscription.
1926      *         Note that order is not guaranteed as updates are made.
1927      */
1928     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1929 
1930     /**
1931      * @notice Returns the filtered codeHash at the given index of the list of filtered codeHashes for a given address or
1932      *         its subscription.
1933      *         Note that order is not guaranteed as updates are made.
1934      */
1935     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1936 
1937     /**
1938      * @notice Returns true if an address has registered
1939      */
1940     function isRegistered(address addr) external returns (bool);
1941 
1942     /**
1943      * @dev Convenience method to compute the code hash of an arbitrary contract
1944      */
1945     function codeHashOf(address addr) external returns (bytes32);
1946 }
1947 
1948 // File: OperatorFilterer.sol
1949 
1950 
1951 pragma solidity ^0.8.13;
1952 
1953 
1954 /**
1955  * @title  OperatorFilterer
1956  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
1957  *         registrant's entries in the OperatorFilterRegistry.
1958  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
1959  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
1960  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
1961  *         Please note that if your token contract does not provide an owner with EIP-173, it must provide
1962  *         administration methods on the contract itself to interact with the registry otherwise the subscription
1963  *         will be locked to the options set during construction.
1964  */
1965 
1966 abstract contract OperatorFilterer {
1967     /// @dev Emitted when an operator is not allowed.
1968     error OperatorNotAllowed(address operator);
1969 
1970     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
1971         IOperatorFilterRegistry(CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS);
1972 
1973     /// @dev The constructor that is called when the contract is being deployed.
1974     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1975         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1976         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1977         // order for the modifier to filter addresses.
1978         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1979             if (subscribe) {
1980                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1981             } else {
1982                 if (subscriptionOrRegistrantToCopy != address(0)) {
1983                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1984                 } else {
1985                     OPERATOR_FILTER_REGISTRY.register(address(this));
1986                 }
1987             }
1988         }
1989     }
1990 
1991     /**
1992      * @dev A helper function to check if an operator is allowed.
1993      */
1994     modifier onlyAllowedOperator(address from) virtual {
1995         // Allow spending tokens from addresses with balance
1996         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1997         // from an EOA.
1998         if (from != msg.sender) {
1999             _checkFilterOperator(msg.sender);
2000         }
2001         _;
2002     }
2003 
2004     /**
2005      * @dev A helper function to check if an operator approval is allowed.
2006      */
2007     modifier onlyAllowedOperatorApproval(address operator) virtual {
2008         _checkFilterOperator(operator);
2009         _;
2010     }
2011 
2012     /**
2013      * @dev A helper function to check if an operator is allowed.
2014      */
2015     function _checkFilterOperator(address operator) internal view virtual {
2016         // Check registry code length to facilitate testing in environments without a deployed registry.
2017         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
2018             // under normal circumstances, this function will revert rather than return false, but inheriting contracts
2019             // may specify their own OperatorFilterRegistry implementations, which may behave differently
2020             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
2021                 revert OperatorNotAllowed(operator);
2022             }
2023         }
2024     }
2025 }
2026 
2027 // File: DefaultOperatorFilterer.sol
2028 
2029 
2030 pragma solidity ^0.8.13;
2031 
2032 
2033 /**
2034  * @title  DefaultOperatorFilterer
2035  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
2036  * @dev    Please note that if your token contract does not provide an owner with EIP-173, it must provide
2037  *         administration methods on the contract itself to interact with the registry otherwise the subscription
2038  *         will be locked to the options set during construction.
2039  */
2040 
2041 abstract contract DefaultOperatorFilterer is OperatorFilterer {
2042     /// @dev The constructor that is called when the contract is being deployed.
2043     constructor() OperatorFilterer(CANONICAL_CORI_SUBSCRIPTION, true) {}
2044 }
2045 
2046 // File: HereIsPurple.sol
2047 
2048 
2049 pragma solidity ^0.8.18;
2050 
2051 
2052 
2053 
2054 
2055 
2056 contract SomethingIsComing is 
2057     ERC721A, 
2058     DefaultOperatorFilterer, 
2059     Ownable,
2060     ReentrancyGuard
2061     {
2062     uint256 MAX_SUPPLY = 10000;
2063     //Declaring contants for purplelist and public sale
2064     uint256 public PURPLELIST_MAX_MINTS = 2;
2065     uint256 public PUBLIC_MAX_MINTS = 20;
2066     //Prices for sales
2067     uint256 public purplelistPrice = 0.01 ether;
2068     uint256 public publicSalePrice = 0.05 ether;
2069     //bool for sale states
2070     bool public isPurplelistActive;
2071     bool public isPublicActive;
2072     string public saleState = "Not Active";
2073 
2074     //base URI
2075     string public baseURI;
2076 
2077     //stores the merkleroot to verify if msgSender is on the list
2078     bytes32 private purplelistMerkleRoot;
2079 
2080     //mappings for if caller has already claimed purplelist. Keeping track of amount caller has minted.
2081     mapping(address => uint) public purplelistClaimed;
2082     mapping(address => uint) public amountMinted;
2083 
2084 
2085     //In case of burn event
2086     struct BurnRecord {
2087         address user;
2088         uint256 amountBurned;
2089     }
2090 
2091     BurnRecord[] public burnRecords;
2092     mapping(address => uint) public amountBurned;
2093     bytes32 private burnMerkleroot;
2094     bool public isBurnEvent = false;
2095     bool private isBurnRootNeeded = false;
2096 
2097     address private devAddress;
2098 
2099     constructor(string memory _baseUri, bytes32 _purplelistRoot) ERC721A("627EEA", "627EEA") 
2100     {
2101         baseURI = _baseUri; 
2102         purplelistMerkleRoot = _purplelistRoot;
2103         devAddress = msg.sender; //replace with actual address
2104 
2105     }
2106 
2107 
2108 
2109 
2110     function purplelistMint(bytes32[] calldata _PurpleProof, uint256 quantity) external payable nonReentrant{
2111         require(isPurplelistActive, "Purplelist sale is not active"); //checking sale state
2112         bytes32 leaf = keccak256(abi.encodePacked(msg.sender)); 
2113         require(CheckAddressPurplelisted(_PurpleProof, leaf), "Address not on purplelist");
2114         require(purplelistClaimed[msg.sender] + quantity <= PURPLELIST_MAX_MINTS, "Address already claimed purplelist mint(s) or too many mints"); //check if address has already claimed
2115         require(msg.value >= purplelistPrice * quantity, "Not enough ether sent"); //check eth sent is sufficient
2116          //uses merkletree to verify using address and calldata
2117         require(totalSupply() + quantity <= MAX_SUPPLY, "Not enough tokens left");
2118         purplelistClaimed[msg.sender] += quantity;
2119         _safeMint(msg.sender, quantity);
2120         
2121     }
2122 
2123 
2124     function mint(uint256 quantity) external payable nonReentrant{
2125         require(isPublicActive, "Public sale is not active");//checking sale state
2126         //Not exceeding supply
2127         require(totalSupply() + quantity <= MAX_SUPPLY, "Not enough tokens left");
2128         //MAX MINTS
2129         require(quantity <= PUBLIC_MAX_MINTS, "Exceeded max amount of mints per tx");
2130         require(msg.value >= publicSalePrice * quantity, "Not enough ether sent");
2131         amountMinted[msg.sender] += quantity;
2132         _safeMint(msg.sender, quantity);
2133         
2134        
2135        
2136     }
2137 
2138     function CheckAddressPurplelisted(bytes32[] calldata _proof, bytes32 leaf) internal view returns(bool){
2139         return MerkleProof.verify(_proof, purplelistMerkleRoot, leaf);
2140 
2141     }
2142 
2143     function CheckBurnAddress(bytes32[] calldata _proof, bytes32 leaf) internal view returns(bool){
2144             return MerkleProof.verify(_proof, burnMerkleroot, leaf);
2145 
2146     }
2147 
2148     function TeamMintPurple(uint256 quantity) external payable onlyOwner {
2149         require(totalSupply() + quantity <= MAX_SUPPLY, "Not enough tokens left");
2150         _safeMint(msg.sender, quantity);
2151     }
2152     function togglePublic() external onlyOwnerOrDev{
2153         isPublicActive = !isPublicActive;
2154     }
2155     function togglePurplelist() external onlyOwnerOrDev{
2156         isPurplelistActive = !isPurplelistActive;
2157     }
2158 
2159     function getSaleState() external view returns (string memory){
2160         if(isPurplelistActive && !isPublicActive){
2161             return("PurplelistOnly");
2162         }
2163         else if(isPurplelistActive && isPublicActive){
2164             return("PurplelistAndPublic");
2165         }
2166         else if(!isPurplelistActive && isPublicActive){
2167             return("PublicOnly");
2168         }else{
2169             return("Not Active");
2170         }
2171     }
2172 
2173     function getIfPurplelistClaimed(address _addr) external view returns (bool){
2174         if(purplelistClaimed[_addr] >= PURPLELIST_MAX_MINTS){
2175             return true;
2176         }else{
2177             return false;
2178         }
2179     }
2180 
2181     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
2182         address owner = ownerOf(tokenId);
2183         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
2184     }
2185 
2186     //if burnProof is not needed, can just pass a random byte array
2187     function Burn(uint256[] calldata tokenIds, bytes32[] calldata _burnProof) external {
2188         uint256 totalBurned = 0;
2189 
2190         require(isBurnEvent, "Burn event is not currently active");
2191         if(isBurnRootNeeded){
2192             bytes32 burnLeaf = keccak256(abi.encodePacked(msg.sender)); 
2193             require(CheckBurnAddress(_burnProof, burnLeaf), "Not ellibible to burn");
2194         }
2195 
2196         for (uint256 i = 0; i < tokenIds.length; ++i) {
2197             uint256 tokenId = tokenIds[i];
2198             require(_exists(tokenId), "Token does not exist");
2199             require(_isApprovedOrOwner(msg.sender, tokenId), "Not approved or owner");
2200             _burn(tokenId);
2201             totalBurned += 1;
2202             amountBurned[msg.sender] += 1;
2203         }
2204 
2205         burnRecords.push(BurnRecord(msg.sender, totalBurned));
2206 
2207         
2208     }
2209 
2210 
2211     function Withdraw() external payable onlyOwner {
2212 
2213 
2214         address Team = 0xD8b53519656ba3fBA69B548c417f70C2F212a404; 
2215         address dev = devAddress; //replace with dev address
2216         payable(Team).transfer((address(this).balance * 90 / 100)); //90% of funds
2217 
2218         payable(dev).transfer(address(this).balance); //remaining 10% to dev
2219 
2220 
2221     }
2222 
2223 
2224     function _baseURI() internal view override returns (string memory) {
2225         return baseURI;
2226     }
2227 
2228 
2229   
2230     function updatePurplelist(bytes32 _root) external onlyOwnerOrDev {
2231         purplelistMerkleRoot = _root;
2232     }
2233 
2234     function StartToBurn() external onlyOwnerOrDev {
2235         isBurnEvent = !isBurnEvent;
2236     }
2237 
2238     function updateBurnRoot(bytes32 _root) external onlyOwnerOrDev {
2239         burnMerkleroot = _root;
2240         isBurnRootNeeded = !isBurnRootNeeded;
2241     }
2242     //in case eth does weird things with price
2243     function setPrice(uint256 _publicPrice) external onlyOwnerOrDev {
2244         publicSalePrice = _publicPrice;
2245     }
2246 
2247     function setPurplelistPrice(uint256 _purplePrice) external onlyOwnerOrDev {
2248         purplelistPrice = _purplePrice;
2249     }
2250 
2251     function setMaxMintPerPurplelist(uint amount) external onlyOwnerOrDev{
2252         PURPLELIST_MAX_MINTS = amount;
2253     }
2254 
2255     function setMaxMintPerPublic(uint amount) external onlyOwnerOrDev{
2256         PUBLIC_MAX_MINTS = amount;
2257     }
2258 
2259     function setBaseURI(string calldata _base) public onlyOwnerOrDev {
2260         baseURI = _base;
2261     }
2262 
2263     modifier onlyOwnerOrDev() {
2264         require(msg.sender == owner() || msg.sender == devAddress, "Only owner or dev can call this function");
2265     _;
2266 }
2267 
2268 
2269 
2270     /////////////////////////////
2271     // OPENSEA FILTER REGISTRY 
2272     /////////////////////////////
2273 
2274     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
2275         super.setApprovalForAll(operator, approved);
2276     }
2277 
2278     function approve(address operator, uint256 tokenId) public payable override onlyAllowedOperatorApproval(operator) {
2279         super.approve(operator, tokenId);
2280     }
2281 
2282     function transferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
2283         super.transferFrom(from, to, tokenId);
2284     }
2285 
2286     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
2287         super.safeTransferFrom(from, to, tokenId);
2288     }
2289 
2290     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
2291         public
2292         payable
2293         override
2294         onlyAllowedOperator(from)
2295     {
2296         super.safeTransferFrom(from, to, tokenId, data);
2297     }
2298 }