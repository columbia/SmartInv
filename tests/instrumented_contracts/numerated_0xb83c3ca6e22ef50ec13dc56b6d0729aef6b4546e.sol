1 //SPDX-License-Identifier: MIT
2 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/security/ReentrancyGuard.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
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
82 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/IERC721A.sol
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
367 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol
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
1460 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/extensions/IERC721AQueryable.sol
1461 
1462 
1463 // ERC721A Contracts v4.2.3
1464 // Creator: Chiru Labs
1465 
1466 pragma solidity ^0.8.4;
1467 
1468 
1469 /**
1470  * @dev Interface of ERC721AQueryable.
1471  */
1472 interface IERC721AQueryable is IERC721A {
1473     /**
1474      * Invalid query range (`start` >= `stop`).
1475      */
1476     error InvalidQueryRange();
1477 
1478     /**
1479      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1480      *
1481      * If the `tokenId` is out of bounds:
1482      *
1483      * - `addr = address(0)`
1484      * - `startTimestamp = 0`
1485      * - `burned = false`
1486      * - `extraData = 0`
1487      *
1488      * If the `tokenId` is burned:
1489      *
1490      * - `addr = <Address of owner before token was burned>`
1491      * - `startTimestamp = <Timestamp when token was burned>`
1492      * - `burned = true`
1493      * - `extraData = <Extra data when token was burned>`
1494      *
1495      * Otherwise:
1496      *
1497      * - `addr = <Address of owner>`
1498      * - `startTimestamp = <Timestamp of start of ownership>`
1499      * - `burned = false`
1500      * - `extraData = <Extra data at start of ownership>`
1501      */
1502     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
1503 
1504     /**
1505      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1506      * See {ERC721AQueryable-explicitOwnershipOf}
1507      */
1508     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
1509 
1510     /**
1511      * @dev Returns an array of token IDs owned by `owner`,
1512      * in the range [`start`, `stop`)
1513      * (i.e. `start <= tokenId < stop`).
1514      *
1515      * This function allows for tokens to be queried if the collection
1516      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1517      *
1518      * Requirements:
1519      *
1520      * - `start < stop`
1521      */
1522     function tokensOfOwnerIn(
1523         address owner,
1524         uint256 start,
1525         uint256 stop
1526     ) external view returns (uint256[] memory);
1527 
1528     /**
1529      * @dev Returns an array of token IDs owned by `owner`.
1530      *
1531      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
1532      * It is meant to be called off-chain.
1533      *
1534      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1535      * multiple smaller scans if the collection is large enough to cause
1536      * an out-of-gas error (10K collections should be fine).
1537      */
1538     function tokensOfOwner(address owner) external view returns (uint256[] memory);
1539 }
1540 
1541 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/extensions/ERC721AQueryable.sol
1542 
1543 
1544 // ERC721A Contracts v4.2.3
1545 // Creator: Chiru Labs
1546 
1547 pragma solidity ^0.8.4;
1548 
1549 
1550 
1551 /**
1552  * @title ERC721AQueryable.
1553  *
1554  * @dev ERC721A subclass with convenience query functions.
1555  */
1556 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1557     /**
1558      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1559      *
1560      * If the `tokenId` is out of bounds:
1561      *
1562      * - `addr = address(0)`
1563      * - `startTimestamp = 0`
1564      * - `burned = false`
1565      * - `extraData = 0`
1566      *
1567      * If the `tokenId` is burned:
1568      *
1569      * - `addr = <Address of owner before token was burned>`
1570      * - `startTimestamp = <Timestamp when token was burned>`
1571      * - `burned = true`
1572      * - `extraData = <Extra data when token was burned>`
1573      *
1574      * Otherwise:
1575      *
1576      * - `addr = <Address of owner>`
1577      * - `startTimestamp = <Timestamp of start of ownership>`
1578      * - `burned = false`
1579      * - `extraData = <Extra data at start of ownership>`
1580      */
1581     function explicitOwnershipOf(uint256 tokenId) public view virtual override returns (TokenOwnership memory) {
1582         TokenOwnership memory ownership;
1583         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1584             return ownership;
1585         }
1586         ownership = _ownershipAt(tokenId);
1587         if (ownership.burned) {
1588             return ownership;
1589         }
1590         return _ownershipOf(tokenId);
1591     }
1592 
1593     /**
1594      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1595      * See {ERC721AQueryable-explicitOwnershipOf}
1596      */
1597     function explicitOwnershipsOf(uint256[] calldata tokenIds)
1598         external
1599         view
1600         virtual
1601         override
1602         returns (TokenOwnership[] memory)
1603     {
1604         unchecked {
1605             uint256 tokenIdsLength = tokenIds.length;
1606             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1607             for (uint256 i; i != tokenIdsLength; ++i) {
1608                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1609             }
1610             return ownerships;
1611         }
1612     }
1613 
1614     /**
1615      * @dev Returns an array of token IDs owned by `owner`,
1616      * in the range [`start`, `stop`)
1617      * (i.e. `start <= tokenId < stop`).
1618      *
1619      * This function allows for tokens to be queried if the collection
1620      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1621      *
1622      * Requirements:
1623      *
1624      * - `start < stop`
1625      */
1626     function tokensOfOwnerIn(
1627         address owner,
1628         uint256 start,
1629         uint256 stop
1630     ) external view virtual override returns (uint256[] memory) {
1631         unchecked {
1632             if (start >= stop) revert InvalidQueryRange();
1633             uint256 tokenIdsIdx;
1634             uint256 stopLimit = _nextTokenId();
1635             // Set `start = max(start, _startTokenId())`.
1636             if (start < _startTokenId()) {
1637                 start = _startTokenId();
1638             }
1639             // Set `stop = min(stop, stopLimit)`.
1640             if (stop > stopLimit) {
1641                 stop = stopLimit;
1642             }
1643             uint256 tokenIdsMaxLength = balanceOf(owner);
1644             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1645             // to cater for cases where `balanceOf(owner)` is too big.
1646             if (start < stop) {
1647                 uint256 rangeLength = stop - start;
1648                 if (rangeLength < tokenIdsMaxLength) {
1649                     tokenIdsMaxLength = rangeLength;
1650                 }
1651             } else {
1652                 tokenIdsMaxLength = 0;
1653             }
1654             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1655             if (tokenIdsMaxLength == 0) {
1656                 return tokenIds;
1657             }
1658             // We need to call `explicitOwnershipOf(start)`,
1659             // because the slot at `start` may not be initialized.
1660             TokenOwnership memory ownership = explicitOwnershipOf(start);
1661             address currOwnershipAddr;
1662             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1663             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1664             if (!ownership.burned) {
1665                 currOwnershipAddr = ownership.addr;
1666             }
1667             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1668                 ownership = _ownershipAt(i);
1669                 if (ownership.burned) {
1670                     continue;
1671                 }
1672                 if (ownership.addr != address(0)) {
1673                     currOwnershipAddr = ownership.addr;
1674                 }
1675                 if (currOwnershipAddr == owner) {
1676                     tokenIds[tokenIdsIdx++] = i;
1677                 }
1678             }
1679             // Downsize the array to fit.
1680             assembly {
1681                 mstore(tokenIds, tokenIdsIdx)
1682             }
1683             return tokenIds;
1684         }
1685     }
1686 
1687     /**
1688      * @dev Returns an array of token IDs owned by `owner`.
1689      *
1690      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
1691      * It is meant to be called off-chain.
1692      *
1693      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1694      * multiple smaller scans if the collection is large enough to cause
1695      * an out-of-gas error (10K collections should be fine).
1696      */
1697     function tokensOfOwner(address owner) external view virtual override returns (uint256[] memory) {
1698         unchecked {
1699             uint256 tokenIdsIdx;
1700             address currOwnershipAddr;
1701             uint256 tokenIdsLength = balanceOf(owner);
1702             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1703             TokenOwnership memory ownership;
1704             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1705                 ownership = _ownershipAt(i);
1706                 if (ownership.burned) {
1707                     continue;
1708                 }
1709                 if (ownership.addr != address(0)) {
1710                     currOwnershipAddr = ownership.addr;
1711                 }
1712                 if (currOwnershipAddr == owner) {
1713                     tokenIds[tokenIdsIdx++] = i;
1714                 }
1715             }
1716             return tokenIds;
1717         }
1718     }
1719 }
1720 
1721 // File: contracts/VOXVOTBlindVox.sol
1722 
1723 
1724 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
1725 
1726 
1727 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1728 
1729 pragma solidity ^0.8.0;
1730 
1731 
1732 
1733 
1734 
1735 /**
1736  * @dev Provides information about the current execution context, including the
1737  * sender of the transaction and its data. While these are generally available
1738  * via msg.sender and msg.data, they should not be accessed in such a direct
1739  * manner, since when dealing with meta-transactions the account sending and
1740  * paying for execution may not be the actual sender (as far as an application
1741  * is concerned).
1742  *
1743  * This contract is only required for intermediate, library-like contracts.
1744  */
1745 abstract contract Context {
1746     function _msgSender() internal view virtual returns (address) {
1747         return msg.sender;
1748     }
1749 
1750     function _msgData() internal view virtual returns (bytes calldata) {
1751         return msg.data;
1752     }
1753 }
1754 
1755 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/security/Pausable.sol
1756 
1757 
1758 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
1759 
1760 pragma solidity ^0.8.0;
1761 
1762 
1763 /**
1764  * @dev Contract module which allows children to implement an emergency stop
1765  * mechanism that can be triggered by an authorized account.
1766  *
1767  * This module is used through inheritance. It will make available the
1768  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1769  * the functions of your contract. Note that they will not be pausable by
1770  * simply including this module, only once the modifiers are put in place.
1771  */
1772 abstract contract Pausable is Context {
1773     /**
1774      * @dev Emitted when the pause is triggered by `account`.
1775      */
1776     event Paused(address account);
1777 
1778     /**
1779      * @dev Emitted when the pause is lifted by `account`.
1780      */
1781     event Unpaused(address account);
1782 
1783     bool private _paused;
1784 
1785     /**
1786      * @dev Initializes the contract in unpaused state.
1787      */
1788     constructor() {
1789         _paused = false;
1790     }
1791 
1792     /**
1793      * @dev Modifier to make a function callable only when the contract is not paused.
1794      *
1795      * Requirements:
1796      *
1797      * - The contract must not be paused.
1798      */
1799     modifier whenNotPaused() {
1800         _requireNotPaused();
1801         _;
1802     }
1803 
1804     /**
1805      * @dev Modifier to make a function callable only when the contract is paused.
1806      *
1807      * Requirements:
1808      *
1809      * - The contract must be paused.
1810      */
1811     modifier whenPaused() {
1812         _requirePaused();
1813         _;
1814     }
1815 
1816     /**
1817      * @dev Returns true if the contract is paused, and false otherwise.
1818      */
1819     function paused() public view virtual returns (bool) {
1820         return _paused;
1821     }
1822 
1823     /**
1824      * @dev Throws if the contract is paused.
1825      */
1826     function _requireNotPaused() internal view virtual {
1827         require(!paused(), "Pausable: paused");
1828     }
1829 
1830     /**
1831      * @dev Throws if the contract is not paused.
1832      */
1833     function _requirePaused() internal view virtual {
1834         require(paused(), "Pausable: not paused");
1835     }
1836 
1837     /**
1838      * @dev Triggers stopped state.
1839      *
1840      * Requirements:
1841      *
1842      * - The contract must not be paused.
1843      */
1844     function _pause() internal virtual whenNotPaused {
1845         _paused = true;
1846         emit Paused(_msgSender());
1847     }
1848 
1849     /**
1850      * @dev Returns to normal state.
1851      *
1852      * Requirements:
1853      *
1854      * - The contract must be paused.
1855      */
1856     function _unpause() internal virtual whenPaused {
1857         _paused = false;
1858         emit Unpaused(_msgSender());
1859     }
1860 }
1861 
1862 
1863 // File: @openzeppelin/contracts/access/Ownable.sol
1864 pragma solidity ^0.8.0;
1865 /**
1866  * @dev Contract module which provides a basic access control mechanism, where
1867  * there is an account (an owner) that can be granted exclusive access to
1868  * specific functions.
1869  *
1870  * By default, the owner account will be the one that deploys the contract. This
1871  * can later be changed with {transferOwnership}.
1872  *
1873  * This module is used through inheritance. It will make available the modifier
1874  * `onlyOwner`, which can be applied to your functions to restrict their use to
1875  * the owner.
1876  */
1877 abstract contract Ownable is Context {
1878     address private _owner;
1879 
1880     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1881 
1882     /**
1883      * @dev Initializes the contract setting the deployer as the initial owner.
1884      */
1885     constructor() {
1886         _setOwner(_msgSender());
1887     }
1888 
1889     /**
1890      * @dev Returns the address of the current owner.
1891      */
1892     function owner() public view virtual returns (address) {
1893         return _owner;
1894     }
1895 
1896     /**
1897      * @dev Throws if called by any account other than the owner.
1898      */
1899     modifier onlyOwner() {
1900         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1901         _;
1902     }
1903 
1904     /**
1905      * @dev Leaves the contract without owner. It will not be possible to call
1906      * `onlyOwner` functions anymore. Can only be called by the current owner.
1907      *
1908      * NOTE: Renouncing ownership will leave the contract without an owner,
1909      * thereby removing any functionality that is only available to the owner.
1910      */
1911     function renounceOwnership() public virtual onlyOwner {
1912         _setOwner(address(0));
1913     }
1914 
1915     /**
1916      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1917      * Can only be called by the current owner.
1918      */
1919     function transferOwnership(address newOwner) public virtual onlyOwner {
1920         require(newOwner != address(0), "Ownable: new owner is the zero address");
1921         _setOwner(newOwner);
1922     }
1923 
1924     function _setOwner(address newOwner) private {
1925         address oldOwner = _owner;
1926         _owner = newOwner;
1927         emit OwnershipTransferred(oldOwner, newOwner);
1928     }
1929 }
1930 
1931 
1932 
1933 pragma solidity ^0.8.0;
1934 
1935 /**
1936  * @dev These functions deal with verification of Merkle Trees proofs.
1937  *
1938  * The proofs can be generated using the JavaScript library
1939  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1940  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1941  *
1942  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1943  *
1944  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1945  * hashing, or use a hash function other than keccak256 for hashing leaves.
1946  * This is because the concatenation of a sorted pair of internal nodes in
1947  * the merkle tree could be reinterpreted as a leaf value.
1948  */
1949 library MerkleProof {
1950     /**
1951      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1952      * defined by `root`. For this, a `proof` must be provided, containing
1953      * sibling hashes on the branch from the leaf to the root of the tree. Each
1954      * pair of leaves and each pair of pre-images are assumed to be sorted.
1955      */
1956     function verify(
1957         bytes32[] memory proof,
1958         bytes32 root,
1959         bytes32 leaf
1960     ) internal pure returns (bool) {
1961         return processProof(proof, leaf) == root;
1962     }
1963 
1964     /**
1965      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1966      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1967      * hash matches the root of the tree. When processing the proof, the pairs
1968      * of leafs & pre-images are assumed to be sorted.
1969      *
1970      * _Available since v4.4._
1971      */
1972     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1973         bytes32 computedHash = leaf;
1974         for (uint256 i = 0; i < proof.length; i++) {
1975             computedHash = _hashPair(computedHash, proof[i]);
1976         }
1977         return computedHash;
1978     }
1979 
1980     /**
1981      * @dev Returns true if a `leafs` can be proved to be a part of a Merkle tree
1982      * defined by `root`. For this, `proofs` for each leaf must be provided, containing
1983      * sibling hashes on the branch from the leaf to the root of the tree. Then
1984      * 'proofFlag' designates the nodes needed for the multi proof.
1985      *
1986      * _Available since v4.7._
1987      */
1988     function multiProofVerify(
1989         bytes32 root,
1990         bytes32[] memory leafs,
1991         bytes32[] memory proofs,
1992         bool[] memory proofFlag
1993     ) internal pure returns (bool) {
1994         return processMultiProof(leafs, proofs, proofFlag) == root;
1995     }
1996 
1997     /**
1998      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1999      * from `leaf` using the multi proof as `proofFlag`. A multi proof is
2000      * valid if the final hash matches the root of the tree.
2001      *
2002      * _Available since v4.7._
2003      */
2004     function processMultiProof(
2005         bytes32[] memory leafs,
2006         bytes32[] memory proofs,
2007         bool[] memory proofFlag
2008     ) internal pure returns (bytes32 merkleRoot) {
2009         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
2010         // consuming and producing values on a queue. The queue starts with the `leafs` array, then goes onto the
2011         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
2012         // the merkle tree.
2013         uint256 leafsLen = leafs.length;
2014         uint256 proofsLen = proofs.length;
2015         uint256 totalHashes = proofFlag.length;
2016 
2017         // Check proof validity.
2018         require(leafsLen + proofsLen - 1 == totalHashes, "MerkleProof: invalid multiproof");
2019 
2020         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
2021         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
2022         bytes32[] memory hashes = new bytes32[](totalHashes);
2023         uint256 leafPos = 0;
2024         uint256 hashPos = 0;
2025         uint256 proofPos = 0;
2026         // At each step, we compute the next hash using two values:
2027         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
2028         //   get the next hash.
2029         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
2030         //   `proofs` array.
2031         for (uint256 i = 0; i < totalHashes; i++) {
2032             bytes32 a = leafPos < leafsLen ? leafs[leafPos++] : hashes[hashPos++];
2033             bytes32 b = proofFlag[i] ? leafPos < leafsLen ? leafs[leafPos++] : hashes[hashPos++] : proofs[proofPos++];
2034             hashes[i] = _hashPair(a, b);
2035         }
2036 
2037         return hashes[totalHashes - 1];
2038     }
2039 
2040     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
2041         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
2042     }
2043 
2044     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
2045         /// @solidity memory-safe-assembly
2046         assembly {
2047             mstore(0x00, a)
2048             mstore(0x20, b)
2049             value := keccak256(0x00, 0x40)
2050         }
2051     }
2052 }
2053 
2054 /**
2055  * @dev String operations.
2056  */
2057 library Strings {
2058     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
2059 
2060     /**
2061      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
2062      */
2063     function toString(uint256 value) internal pure returns (string memory) {
2064         // Inspired by OraclizeAPI's implementation - MIT licence
2065         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
2066 
2067         if (value == 0) {
2068             return "0";
2069         }
2070         uint256 temp = value;
2071         uint256 digits;
2072         while (temp != 0) {
2073             digits++;
2074             temp /= 10;
2075         }
2076         bytes memory buffer = new bytes(digits);
2077         while (value != 0) {
2078             digits -= 1;
2079             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
2080             value /= 10;
2081         }
2082         return string(buffer);
2083     }
2084 
2085     /**
2086      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
2087      */
2088     function toHexString(uint256 value) internal pure returns (string memory) {
2089         if (value == 0) {
2090             return "0x00";
2091         }
2092         uint256 temp = value;
2093         uint256 length = 0;
2094         while (temp != 0) {
2095             length++;
2096             temp >>= 8;
2097         }
2098         return toHexString(value, length);
2099     }
2100 
2101     /**
2102      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
2103      */
2104     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
2105         bytes memory buffer = new bytes(2 * length + 2);
2106         buffer[0] = "0";
2107         buffer[1] = "x";
2108         for (uint256 i = 2 * length + 1; i > 1; --i) {
2109             buffer[i] = _HEX_SYMBOLS[value & 0xf];
2110             value >>= 4;
2111         }
2112         require(value == 0, "Strings: hex length insufficient");
2113         return string(buffer);
2114     }
2115 }
2116 
2117 //custom reverts
2118 error NotOwner();
2119 error NotOpenable();
2120 error NoBotMint();
2121 error AlreadyMinted();
2122 error InvalidAddr();
2123 error NonexistsToken();
2124 error SoldOut();
2125 error InvalidInput();
2126 error ExcessMint();
2127 error IsPublicMint();
2128 error IsWhiteListMint();
2129 
2130 pragma solidity >=0.7.0 <0.9.0;
2131 
2132 abstract contract voxvotNFT {
2133     function openVox(address _to, uint256 _tokenID) public virtual;
2134 }
2135 
2136 //tested contract
2137 contract VOXVOT_BlindVox is ERC721AQueryable, Ownable, Pausable, ReentrancyGuard{
2138   using Strings for uint256;
2139 
2140   string baseURI;
2141   string public baseExtension = ".json";
2142   uint256 public maxSupply = 6666;
2143   uint256 public WLMintlimit;
2144   uint256 public publicMintlimit;
2145   mapping (address => uint256) public WLMintCount;
2146   mapping (address => uint256) public publicMintCount;
2147   address private NftContract;
2148   uint256 public totalMints;
2149 
2150   //state
2151   bool public isWhitelistMint = false;
2152   bool public isOpenable = false;
2153 
2154   //merkle proof
2155   bytes32 private rootHash;
2156 
2157   constructor(
2158     string memory _name,
2159     string memory _symbol,
2160     string memory _baseUri
2161   ) ERC721A(_name, _symbol) {
2162       setBaseUri(_baseUri);
2163   }
2164 
2165   function _startTokenId() internal view virtual override returns (uint256) {
2166         return 1;
2167   }
2168 
2169   function _baseURI() internal view virtual override returns (string memory) {
2170         return baseURI;
2171     }
2172 
2173   function tokenURI(uint256 tokenId) public view virtual override returns (string memory)
2174   {
2175     if (!_exists(tokenId)) revert NonexistsToken();
2176     string memory currentBaseURI = _baseURI();
2177     return bytes(currentBaseURI).length > 0
2178         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
2179         : "";
2180   }
2181 
2182   function openVox(uint256 tokenid) public nonReentrant() {
2183       if(!isOpenable) revert NotOpenable();
2184       if(msg.sender != ownerOf(tokenid)) revert NotOwner();
2185       voxvotNFT nftcontract = voxvotNFT(NftContract);
2186       _burn(tokenid, true);
2187       nftcontract.openVox(msg.sender, tokenid);
2188   }
2189 
2190   function openVoxes(uint256[] calldata tokenids) external {
2191       for (uint256 i; i < tokenids.length; ) {
2192         openVox(tokenids[i]);
2193         unchecked { ++i; }
2194       }
2195   }
2196 
2197   function whitelistMint(bytes32[] calldata proof) external payable whenNotPaused {
2198       if(!isWhitelistMint) revert IsPublicMint();
2199       if (WLMintCount[msg.sender] + 2 > WLMintlimit || 2 + totalMints > maxSupply) revert ExcessMint();
2200       bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
2201       if (!MerkleProof.verify(proof, rootHash, leaf)) revert InvalidAddr();
2202       totalMints += 2;
2203       WLMintCount[msg.sender] += 2;
2204       _mint(msg.sender,2);
2205   }
2206 
2207   function mintBlindVox(uint256 amount) external payable whenNotPaused {
2208       if (isWhitelistMint) revert IsWhiteListMint();
2209       if (tx.origin != msg.sender) revert NoBotMint();
2210       if (publicMintCount[msg.sender] + amount > publicMintlimit || amount + totalMints > maxSupply) revert ExcessMint();
2211       totalMints += amount;
2212       publicMintCount[msg.sender] += amount;
2213       _safeMint(msg.sender,amount);
2214   }
2215 
2216   //-----air drop-----
2217   function preMint(address[] calldata listedAddr, uint256[] calldata sendAmounts) external onlyOwner {
2218       if (listedAddr.length != sendAmounts.length || listedAddr.length == 0) revert InvalidInput();
2219       
2220       for (uint256 i; i < listedAddr.length; ) {
2221         totalMints += sendAmounts[i];
2222         _mint(listedAddr[i], sendAmounts[i]);
2223         unchecked { ++i; }
2224       }
2225   }
2226 
2227   //-----only owner-----
2228   function ownerMint(uint256 amount) external onlyOwner {
2229       if(amount + totalMints > maxSupply) revert ExcessMint();
2230       totalMints += amount;
2231       _mint(msg.sender,amount);
2232   }
2233 
2234   function setBaseUri(string memory _newBaseUri) public onlyOwner {
2235       baseURI = _newBaseUri;
2236   }
2237 
2238   function setRootHash(bytes32 _newHash) external onlyOwner {
2239       rootHash = _newHash;
2240   }
2241 
2242   function setMaxSupply(uint256 _newSupply) external onlyOwner {
2243       if(_newSupply > maxSupply) revert InvalidInput();
2244       maxSupply = _newSupply;
2245   }
2246 
2247   function setWLMintLimit(uint256 _newLimit) external onlyOwner {
2248       WLMintlimit = _newLimit;
2249   }
2250 
2251   function setPublicMintLimit(uint256 _newLimit) external onlyOwner {
2252       publicMintlimit = _newLimit;
2253   }
2254 
2255   function setNftContract(address _newAddr) external onlyOwner {
2256       NftContract = _newAddr;
2257   }
2258 
2259   function setMintStatus() external onlyOwner {
2260       if(isWhitelistMint){
2261           isWhitelistMint = false;
2262       } else {
2263           isWhitelistMint = true;
2264       }
2265   }
2266 
2267   function setIsOpenable() external onlyOwner {
2268       if(!isOpenable){
2269           isOpenable = true;
2270       }
2271   }
2272 
2273   function pause() external onlyOwner {
2274 	_pause();
2275   }
2276 
2277 	function unpause() external onlyOwner {
2278 	_unpause();
2279   }
2280 
2281 
2282 }