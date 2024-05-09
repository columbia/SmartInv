1 // SPDX-License-Identifier: MIT
2 
3 // File: TheNFTWar.sol
4 
5 
6 
7 
8 // File: @openzeppelin/contracts/utils/Context.sol
9 
10 
11 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
12 
13 
14 pragma solidity ^0.8.0;
15 
16 /**
17  * @dev Provides information about the current execution context, including the
18  * sender of the transaction and its data. While these are generally available
19  * via msg.sender and msg.data, they should not be accessed in such a direct
20  * manner, since when dealing with meta-transactions the account sending and
21  * paying for execution may not be the actual sender (as far as an application
22  * is concerned).
23  *
24  * This contract is only required for intermediate, library-like contracts.
25  */
26 abstract contract Context {
27     function _msgSender() internal view virtual returns (address) {
28         return msg.sender;
29     }
30 
31     function _msgData() internal view virtual returns (bytes calldata) {
32         return msg.data;
33     }
34 }
35 
36 // File: @openzeppelin/contracts/access/Ownable.sol
37 
38 
39 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
40 
41 pragma solidity ^0.8.0;
42 
43 
44 /**
45  * @dev Contract module which provides a basic access control mechanism, where
46  * there is an account (an owner) that can be granted exclusive access to
47  * specific functions.
48  *
49  * By default, the owner account will be the one that deploys the contract. This
50  * can later be changed with {transferOwnership}.
51  *
52  * This module is used through inheritance. It will make available the modifier
53  * `onlyOwner`, which can be applied to your functions to restrict their use to
54  * the owner.
55  */
56 abstract contract Ownable is Context {
57     address private _owner;
58 
59     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
60 
61     /**
62      * @dev Initializes the contract setting the deployer as the initial owner.
63      */
64     constructor() {
65         _transferOwnership(_msgSender());
66     }
67 
68     /**
69      * @dev Throws if called by any account other than the owner.
70      */
71     modifier onlyOwner() {
72         _checkOwner();
73         _;
74     }
75 
76     /**
77      * @dev Returns the address of the current owner.
78      */
79     function owner() public view virtual returns (address) {
80         return _owner;
81     }
82 
83     /**
84      * @dev Throws if the sender is not the owner.
85      */
86     function _checkOwner() internal view virtual {
87         require(owner() == _msgSender(), "Ownable: caller is not the owner");
88     }
89 
90     /**
91      * @dev Leaves the contract without owner. It will not be possible to call
92      * `onlyOwner` functions anymore. Can only be called by the current owner.
93      *
94      * NOTE: Renouncing ownership will leave the contract without an owner,
95      * thereby removing any functionality that is only available to the owner.
96      */
97     function renounceOwnership() public virtual onlyOwner {
98         _transferOwnership(address(0));
99     }
100 
101     /**
102      * @dev Transfers ownership of the contract to a new account (`newOwner`).
103      * Can only be called by the current owner.
104      */
105     function transferOwnership(address newOwner) public virtual onlyOwner {
106         require(newOwner != address(0), "Ownable: new owner is the zero address");
107         _transferOwnership(newOwner);
108     }
109 
110     /**
111      * @dev Transfers ownership of the contract to a new account (`newOwner`).
112      * Internal function without access restriction.
113      */
114     function _transferOwnership(address newOwner) internal virtual {
115         address oldOwner = _owner;
116         _owner = newOwner;
117         emit OwnershipTransferred(oldOwner, newOwner);
118     }
119 }
120 
121 // File: erc721a/contracts/IERC721A.sol
122 
123 
124 // ERC721A Contracts v4.2.2
125 // Creator: Chiru Labs
126 
127 pragma solidity ^0.8.4;
128 
129 /**
130  * @dev Interface of ERC721A.
131  */
132 interface IERC721A {
133     /**
134      * The caller must own the token or be an approved operator.
135      */
136     error ApprovalCallerNotOwnerNorApproved();
137 
138     /**
139      * The token does not exist.
140      */
141     error ApprovalQueryForNonexistentToken();
142 
143     /**
144      * The caller cannot approve to their own address.
145      */
146     error ApproveToCaller();
147 
148     /**
149      * Cannot query the balance for the zero address.
150      */
151     error BalanceQueryForZeroAddress();
152 
153     /**
154      * Cannot mint to the zero address.
155      */
156     error MintToZeroAddress();
157 
158     /**
159      * The quantity of tokens minted must be more than zero.
160      */
161     error MintZeroQuantity();
162 
163     /**
164      * The token does not exist.
165      */
166     error OwnerQueryForNonexistentToken();
167 
168     /**
169      * The caller must own the token or be an approved operator.
170      */
171     error TransferCallerNotOwnerNorApproved();
172 
173     /**
174      * The token must be owned by `from`.
175      */
176     error TransferFromIncorrectOwner();
177 
178     /**
179      * Cannot safely transfer to a contract that does not implement the
180      * ERC721Receiver interface.
181      */
182     error TransferToNonERC721ReceiverImplementer();
183 
184     /**
185      * Cannot transfer to the zero address.
186      */
187     error TransferToZeroAddress();
188 
189     /**
190      * The token does not exist.
191      */
192     error URIQueryForNonexistentToken();
193 
194     /**
195      * The `quantity` minted with ERC2309 exceeds the safety limit.
196      */
197     error MintERC2309QuantityExceedsLimit();
198 
199     /**
200      * The `extraData` cannot be set on an unintialized ownership slot.
201      */
202     error OwnershipNotInitializedForExtraData();
203 
204     // =============================================================
205     //                            STRUCTS
206     // =============================================================
207 
208     struct TokenOwnership {
209         // The address of the owner.
210         address addr;
211         // Stores the start time of ownership with minimal overhead for tokenomics.
212         uint64 startTimestamp;
213         // Whether the token has been burned.
214         bool burned;
215         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
216         uint24 extraData;
217     }
218 
219     // =============================================================
220     //                         TOKEN COUNTERS
221     // =============================================================
222 
223     /**
224      * @dev Returns the total number of tokens in existence.
225      * Burned tokens will reduce the count.
226      * To get the total number of tokens minted, please see {_totalMinted}.
227      */
228     function totalSupply() external view returns (uint256);
229 
230     // =============================================================
231     //                            IERC165
232     // =============================================================
233 
234     /**
235      * @dev Returns true if this contract implements the interface defined by
236      * `interfaceId`. See the corresponding
237      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
238      * to learn more about how these ids are created.
239      *
240      * This function call must use less than 30000 gas.
241      */
242     function supportsInterface(bytes4 interfaceId) external view returns (bool);
243 
244     // =============================================================
245     //                            IERC721
246     // =============================================================
247 
248     /**
249      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
250      */
251     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
252 
253     /**
254      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
255      */
256     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
257 
258     /**
259      * @dev Emitted when `owner` enables or disables
260      * (`approved`) `operator` to manage all of its assets.
261      */
262     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
263 
264     /**
265      * @dev Returns the number of tokens in `owner`'s account.
266      */
267     function balanceOf(address owner) external view returns (uint256 balance);
268 
269     /**
270      * @dev Returns the owner of the `tokenId` token.
271      *
272      * Requirements:
273      *
274      * - `tokenId` must exist.
275      */
276     function ownerOf(uint256 tokenId) external view returns (address owner);
277 
278     /**
279      * @dev Safely transfers `tokenId` token from `from` to `to`,
280      * checking first that contract recipients are aware of the ERC721 protocol
281      * to prevent tokens from being forever locked.
282      *
283      * Requirements:
284      *
285      * - `from` cannot be the zero address.
286      * - `to` cannot be the zero address.
287      * - `tokenId` token must exist and be owned by `from`.
288      * - If the caller is not `from`, it must be have been allowed to move
289      * this token by either {approve} or {setApprovalForAll}.
290      * - If `to` refers to a smart contract, it must implement
291      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
292      *
293      * Emits a {Transfer} event.
294      */
295     function safeTransferFrom(
296         address from,
297         address to,
298         uint256 tokenId,
299         bytes calldata data
300     ) external;
301 
302     /**
303      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
304      */
305     function safeTransferFrom(
306         address from,
307         address to,
308         uint256 tokenId
309     ) external;
310 
311     /**
312      * @dev Transfers `tokenId` from `from` to `to`.
313      *
314      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
315      * whenever possible.
316      *
317      * Requirements:
318      *
319      * - `from` cannot be the zero address.
320      * - `to` cannot be the zero address.
321      * - `tokenId` token must be owned by `from`.
322      * - If the caller is not `from`, it must be approved to move this token
323      * by either {approve} or {setApprovalForAll}.
324      *
325      * Emits a {Transfer} event.
326      */
327     function transferFrom(
328         address from,
329         address to,
330         uint256 tokenId
331     ) external;
332 
333     /**
334      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
335      * The approval is cleared when the token is transferred.
336      *
337      * Only a single account can be approved at a time, so approving the
338      * zero address clears previous approvals.
339      *
340      * Requirements:
341      *
342      * - The caller must own the token or be an approved operator.
343      * - `tokenId` must exist.
344      *
345      * Emits an {Approval} event.
346      */
347     function approve(address to, uint256 tokenId) external;
348 
349     /**
350      * @dev Approve or remove `operator` as an operator for the caller.
351      * Operators can call {transferFrom} or {safeTransferFrom}
352      * for any token owned by the caller.
353      *
354      * Requirements:
355      *
356      * - The `operator` cannot be the caller.
357      *
358      * Emits an {ApprovalForAll} event.
359      */
360     function setApprovalForAll(address operator, bool _approved) external;
361 
362     /**
363      * @dev Returns the account approved for `tokenId` token.
364      *
365      * Requirements:
366      *
367      * - `tokenId` must exist.
368      */
369     function getApproved(uint256 tokenId) external view returns (address operator);
370 
371     /**
372      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
373      *
374      * See {setApprovalForAll}.
375      */
376     function isApprovedForAll(address owner, address operator) external view returns (bool);
377 
378     // =============================================================
379     //                        IERC721Metadata
380     // =============================================================
381 
382     /**
383      * @dev Returns the token collection name.
384      */
385     function name() external view returns (string memory);
386 
387     /**
388      * @dev Returns the token collection symbol.
389      */
390     function symbol() external view returns (string memory);
391 
392     /**
393      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
394      */
395     function tokenURI(uint256 tokenId) external view returns (string memory);
396 
397     // =============================================================
398     //                           IERC2309
399     // =============================================================
400 
401     /**
402      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
403      * (inclusive) is transferred from `from` to `to`, as defined in the
404      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
405      *
406      * See {_mintERC2309} for more details.
407      */
408     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
409 }
410 
411 // File: erc721a/contracts/ERC721A.sol
412 
413 
414 // ERC721A Contracts v4.2.2
415 // Creator: Chiru Labs
416 
417 pragma solidity ^0.8.4;
418 
419 
420 /**
421  * @dev Interface of ERC721 token receiver.
422  */
423 interface ERC721A__IERC721Receiver {
424     function onERC721Received(
425         address operator,
426         address from,
427         uint256 tokenId,
428         bytes calldata data
429     ) external returns (bytes4);
430 }
431 
432 /**
433  * @title ERC721A
434  *
435  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
436  * Non-Fungible Token Standard, including the Metadata extension.
437  * Optimized for lower gas during batch mints.
438  *
439  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
440  * starting from `_startTokenId()`.
441  *
442  * Assumptions:
443  *
444  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
445  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
446  */
447 contract ERC721A is IERC721A {
448     // Reference type for token approval.
449     struct TokenApprovalRef {
450         address value;
451     }
452 
453     // =============================================================
454     //                           CONSTANTS
455     // =============================================================
456 
457     // Mask of an entry in packed address data.
458     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
459 
460     // The bit position of `numberMinted` in packed address data.
461     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
462 
463     // The bit position of `numberBurned` in packed address data.
464     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
465 
466     // The bit position of `aux` in packed address data.
467     uint256 private constant _BITPOS_AUX = 192;
468 
469     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
470     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
471 
472     // The bit position of `startTimestamp` in packed ownership.
473     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
474 
475     // The bit mask of the `burned` bit in packed ownership.
476     uint256 private constant _BITMASK_BURNED = 1 << 224;
477 
478     // The bit position of the `nextInitialized` bit in packed ownership.
479     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
480 
481     // The bit mask of the `nextInitialized` bit in packed ownership.
482     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
483 
484     // The bit position of `extraData` in packed ownership.
485     uint256 private constant _BITPOS_EXTRA_DATA = 232;
486 
487     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
488     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
489 
490     // The mask of the lower 160 bits for addresses.
491     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
492 
493     // The maximum `quantity` that can be minted with {_mintERC2309}.
494     // This limit is to prevent overflows on the address data entries.
495     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
496     // is required to cause an overflow, which is unrealistic.
497     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
498 
499     // The `Transfer` event signature is given by:
500     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
501     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
502         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
503 
504     // =============================================================
505     //                            STORAGE
506     // =============================================================
507 
508     // The next token ID to be minted.
509     uint256 private _currentIndex;
510 
511     // The number of tokens burned.
512     uint256 private _burnCounter;
513 
514     // Token name
515     string private _name;
516 
517     // Token symbol
518     string private _symbol;
519 
520     // Mapping from token ID to ownership details
521     // An empty struct value does not necessarily mean the token is unowned.
522     // See {_packedOwnershipOf} implementation for details.
523     //
524     // Bits Layout:
525     // - [0..159]   `addr`
526     // - [160..223] `startTimestamp`
527     // - [224]      `burned`
528     // - [225]      `nextInitialized`
529     // - [232..255] `extraData`
530     mapping(uint256 => uint256) private _packedOwnerships;
531 
532     // Mapping owner address to address data.
533     //
534     // Bits Layout:
535     // - [0..63]    `balance`
536     // - [64..127]  `numberMinted`
537     // - [128..191] `numberBurned`
538     // - [192..255] `aux`
539     mapping(address => uint256) private _packedAddressData;
540 
541     // Mapping from token ID to approved address.
542     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
543 
544     // Mapping from owner to operator approvals
545     mapping(address => mapping(address => bool)) private _operatorApprovals;
546 
547     // =============================================================
548     //                          CONSTRUCTOR
549     // =============================================================
550 
551     constructor(string memory name_, string memory symbol_) {
552         _name = name_;
553         _symbol = symbol_;
554         _currentIndex = _startTokenId();
555     }
556 
557     // =============================================================
558     //                   TOKEN COUNTING OPERATIONS
559     // =============================================================
560 
561     /**
562      * @dev Returns the starting token ID.
563      * To change the starting token ID, please override this function.
564      */
565     function _startTokenId() internal view virtual returns (uint256) {
566         return 1;
567     }
568 
569     /**
570      * @dev Returns the next token ID to be minted.
571      */
572     function _nextTokenId() internal view virtual returns (uint256) {
573         return _currentIndex;
574     }
575 
576     /**
577      * @dev Returns the total number of tokens in existence.
578      * Burned tokens will reduce the count.
579      * To get the total number of tokens minted, please see {_totalMinted}.
580      */
581     function totalSupply() public view virtual override returns (uint256) {
582         // Counter underflow is impossible as _burnCounter cannot be incremented
583         // more than `_currentIndex - _startTokenId()` times.
584         unchecked {
585             return _currentIndex - _burnCounter - _startTokenId();
586         }
587     }
588 
589     /**
590      * @dev Returns the total amount of tokens minted in the contract.
591      */
592     function _totalMinted() internal view virtual returns (uint256) {
593         // Counter underflow is impossible as `_currentIndex` does not decrement,
594         // and it is initialized to `_startTokenId()`.
595         unchecked {
596             return _currentIndex - _startTokenId();
597         }
598     }
599 
600     /**
601      * @dev Returns the total number of tokens burned.
602      */
603     function _totalBurned() internal view virtual returns (uint256) {
604         return _burnCounter;
605     }
606 
607     // =============================================================
608     //                    ADDRESS DATA OPERATIONS
609     // =============================================================
610 
611     /**
612      * @dev Returns the number of tokens in `owner`'s account.
613      */
614     function balanceOf(address owner) public view virtual override returns (uint256) {
615         if (owner == address(0)) revert BalanceQueryForZeroAddress();
616         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
617     }
618 
619     /**
620      * Returns the number of tokens minted by `owner`.
621      */
622     function _numberMinted(address owner) internal view returns (uint256) {
623         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
624     }
625 
626     /**
627      * Returns the number of tokens burned by or on behalf of `owner`.
628      */
629     function _numberBurned(address owner) internal view returns (uint256) {
630         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
631     }
632 
633     /**
634      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
635      */
636     function _getAux(address owner) internal view returns (uint64) {
637         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
638     }
639 
640     /**
641      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
642      * If there are multiple variables, please pack them into a uint64.
643      */
644     function _setAux(address owner, uint64 aux) internal virtual {
645         uint256 packed = _packedAddressData[owner];
646         uint256 auxCasted;
647         // Cast `aux` with assembly to avoid redundant masking.
648         assembly {
649             auxCasted := aux
650         }
651         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
652         _packedAddressData[owner] = packed;
653     }
654 
655     // =============================================================
656     //                            IERC165
657     // =============================================================
658 
659     /**
660      * @dev Returns true if this contract implements the interface defined by
661      * `interfaceId`. See the corresponding
662      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
663      * to learn more about how these ids are created.
664      *
665      * This function call must use less than 30000 gas.
666      */
667     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
668         // The interface IDs are constants representing the first 4 bytes
669         // of the XOR of all function selectors in the interface.
670         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
671         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
672         return
673             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
674             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
675             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
676     }
677 
678     // =============================================================
679     //                        IERC721Metadata
680     // =============================================================
681 
682     /**
683      * @dev Returns the token collection name.
684      */
685     function name() public view virtual override returns (string memory) {
686         return _name;
687     }
688 
689     /**
690      * @dev Returns the token collection symbol.
691      */
692     function symbol() public view virtual override returns (string memory) {
693         return _symbol;
694     }
695 
696     /**
697      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
698      */
699     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
700         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
701 
702         string memory baseURI = _baseURI();
703         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
704     }
705 
706     /**
707      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
708      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
709      * by default, it can be overridden in child contracts.
710      */
711     function _baseURI() internal view virtual returns (string memory) {
712         return '';
713     }
714 
715     // =============================================================
716     //                     OWNERSHIPS OPERATIONS
717     // =============================================================
718 
719     /**
720      * @dev Returns the owner of the `tokenId` token.
721      *
722      * Requirements:
723      *
724      * - `tokenId` must exist.
725      */
726     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
727         return address(uint160(_packedOwnershipOf(tokenId)));
728     }
729 
730     /**
731      * @dev Gas spent here starts off proportional to the maximum mint batch size.
732      * It gradually moves to O(1) as tokens get transferred around over time.
733      */
734     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
735         return _unpackedOwnership(_packedOwnershipOf(tokenId));
736     }
737 
738     /**
739      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
740      */
741     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
742         return _unpackedOwnership(_packedOwnerships[index]);
743     }
744 
745     /**
746      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
747      */
748     function _initializeOwnershipAt(uint256 index) internal virtual {
749         if (_packedOwnerships[index] == 0) {
750             _packedOwnerships[index] = _packedOwnershipOf(index);
751         }
752     }
753 
754     /**
755      * Returns the packed ownership data of `tokenId`.
756      */
757     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
758         uint256 curr = tokenId;
759 
760         unchecked {
761             if (_startTokenId() <= curr)
762                 if (curr < _currentIndex) {
763                     uint256 packed = _packedOwnerships[curr];
764                     // If not burned.
765                     if (packed & _BITMASK_BURNED == 0) {
766                         // Invariant:
767                         // There will always be an initialized ownership slot
768                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
769                         // before an unintialized ownership slot
770                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
771                         // Hence, `curr` will not underflow.
772                         //
773                         // We can directly compare the packed value.
774                         // If the address is zero, packed will be zero.
775                         while (packed == 0) {
776                             packed = _packedOwnerships[--curr];
777                         }
778                         return packed;
779                     }
780                 }
781         }
782         revert OwnerQueryForNonexistentToken();
783     }
784 
785     /**
786      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
787      */
788     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
789         ownership.addr = address(uint160(packed));
790         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
791         ownership.burned = packed & _BITMASK_BURNED != 0;
792         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
793     }
794 
795     /**
796      * @dev Packs ownership data into a single uint256.
797      */
798     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
799         assembly {
800             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
801             owner := and(owner, _BITMASK_ADDRESS)
802             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
803             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
804         }
805     }
806 
807     /**
808      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
809      */
810     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
811         // For branchless setting of the `nextInitialized` flag.
812         assembly {
813             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
814             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
815         }
816     }
817 
818     // =============================================================
819     //                      APPROVAL OPERATIONS
820     // =============================================================
821 
822     /**
823      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
824      * The approval is cleared when the token is transferred.
825      *
826      * Only a single account can be approved at a time, so approving the
827      * zero address clears previous approvals.
828      *
829      * Requirements:
830      *
831      * - The caller must own the token or be an approved operator.
832      * - `tokenId` must exist.
833      *
834      * Emits an {Approval} event.
835      */
836     function approve(address to, uint256 tokenId) public virtual override {
837         address owner = ownerOf(tokenId);
838             if (_msgSenderERC721A() != owner)
839                 if (!isApprovedForAll(owner, _msgSenderERC721A())) {
840                     revert ApprovalCallerNotOwnerNorApproved();
841                 }
842 
843             _tokenApprovals[tokenId].value = to;
844             emit Approval(owner, to, tokenId);
845         
846     }
847 
848     /**
849      * @dev Returns the account approved for `tokenId` token.
850      *
851      * Requirements:
852      *
853      * - `tokenId` must exist.
854      */
855     function getApproved(uint256 tokenId) public view virtual override returns (address) {
856         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
857 
858         return _tokenApprovals[tokenId].value;
859     }
860 
861     /**
862      * @dev Approve or remove `operator` as an operator for the caller.
863      * Operators can call {transferFrom} or {safeTransferFrom}
864      * for any token owned by the caller.
865      *
866      * Requirements:
867      *
868      * - The `operator` cannot be the caller.
869      *
870      * Emits an {ApprovalForAll} event.
871      */
872     function setApprovalForAll(address operator, bool approved) public virtual override {
873         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
874 
875         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
876         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
877     }
878 
879     /**
880      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
881      *
882      * See {setApprovalForAll}.
883      */
884     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
885         return _operatorApprovals[owner][operator];
886     }
887 
888     /**
889      * @dev Returns whether `tokenId` exists.
890      *
891      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
892      *
893      * Tokens start existing when they are minted. See {_mint}.
894      */
895     function _exists(uint256 tokenId) internal view virtual returns (bool) {
896         return
897             _startTokenId() <= tokenId &&
898             tokenId < _currentIndex && // If within bounds,
899             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
900     }
901 
902     /**
903      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
904      */
905     function _isSenderApprovedOrOwner(
906         address approvedAddress,
907         address owner,
908         address msgSender
909     ) private pure returns (bool result) {
910         assembly {
911             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
912             owner := and(owner, _BITMASK_ADDRESS)
913             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
914             msgSender := and(msgSender, _BITMASK_ADDRESS)
915             // `msgSender == owner || msgSender == approvedAddress`.
916             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
917         }
918     }
919 
920     /**
921      * @dev Returns the storage slot and value for the approved address of `tokenId`.
922      */
923     function _getApprovedSlotAndAddress(uint256 tokenId)
924         private
925         view
926         returns (uint256 approvedAddressSlot, address approvedAddress)
927     {
928         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
929         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
930         assembly {
931             approvedAddressSlot := tokenApproval.slot
932             approvedAddress := sload(approvedAddressSlot)
933         }
934     }
935 
936     // =============================================================
937     //                      TRANSFER OPERATIONS
938     // =============================================================
939 
940     /**
941      * @dev Transfers `tokenId` from `from` to `to`.
942      *
943      * Requirements:
944      *
945      * - `from` cannot be the zero address.
946      * - `to` cannot be the zero address.
947      * - `tokenId` token must be owned by `from`.
948      * - If the caller is not `from`, it must be approved to move this token
949      * by either {approve} or {setApprovalForAll}.
950      *
951      * Emits a {Transfer} event.
952      */
953     function transferFrom(
954         address from,
955         address to,
956         uint256 tokenId
957     ) public virtual override {
958         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
959 
960         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
961 
962         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
963 
964         // The nested ifs save around 20+ gas over a compound boolean condition.
965         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
966             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
967 
968         if (to == address(0)) revert TransferToZeroAddress();
969 
970         _beforeTokenTransfers(from, to, tokenId, 1);
971 
972         // Clear approvals from the previous owner.
973         assembly {
974             if approvedAddress {
975                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
976                 sstore(approvedAddressSlot, 0)
977             }
978         }
979 
980         // Underflow of the sender's balance is impossible because we check for
981         // ownership above and the recipient's balance can't realistically overflow.
982         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
983         unchecked {
984             // We can directly increment and decrement the balances.
985             --_packedAddressData[from]; // Updates: `balance -= 1`.
986             ++_packedAddressData[to]; // Updates: `balance += 1`.
987 
988             // Updates:
989             // - `address` to the next owner.
990             // - `startTimestamp` to the timestamp of transfering.
991             // - `burned` to `false`.
992             // - `nextInitialized` to `true`.
993             _packedOwnerships[tokenId] = _packOwnershipData(
994                 to,
995                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
996             );
997 
998             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
999             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1000                 uint256 nextTokenId = tokenId + 1;
1001                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1002                 if (_packedOwnerships[nextTokenId] == 0) {
1003                     // If the next slot is within bounds.
1004                     if (nextTokenId != _currentIndex) {
1005                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1006                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1007                     }
1008                 }
1009             }
1010         }
1011 
1012         emit Transfer(from, to, tokenId);
1013         _afterTokenTransfers(from, to, tokenId, 1);
1014     }
1015 
1016     /**
1017      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1018      */
1019     function safeTransferFrom(
1020         address from,
1021         address to,
1022         uint256 tokenId
1023     ) public virtual override {
1024         safeTransferFrom(from, to, tokenId, '');
1025     }
1026 
1027     /**
1028      * @dev Safely transfers `tokenId` token from `from` to `to`.
1029      *
1030      * Requirements:
1031      *
1032      * - `from` cannot be the zero address.
1033      * - `to` cannot be the zero address.
1034      * - `tokenId` token must exist and be owned by `from`.
1035      * - If the caller is not `from`, it must be approved to move this token
1036      * by either {approve} or {setApprovalForAll}.
1037      * - If `to` refers to a smart contract, it must implement
1038      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1039      *
1040      * Emits a {Transfer} event.
1041      */
1042     function safeTransferFrom(
1043         address from,
1044         address to,
1045         uint256 tokenId,
1046         bytes memory _data
1047     ) public virtual override {
1048         transferFrom(from, to, tokenId);
1049         if (to.code.length != 0)
1050             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1051                 revert TransferToNonERC721ReceiverImplementer();
1052             }
1053     }
1054 
1055     /**
1056      * @dev Hook that is called before a set of serially-ordered token IDs
1057      * are about to be transferred. This includes minting.
1058      * And also called before burning one token.
1059      *
1060      * `startTokenId` - the first token ID to be transferred.
1061      * `quantity` - the amount to be transferred.
1062      *
1063      * Calling conditions:
1064      *
1065      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1066      * transferred to `to`.
1067      * - When `from` is zero, `tokenId` will be minted for `to`.
1068      * - When `to` is zero, `tokenId` will be burned by `from`.
1069      * - `from` and `to` are never both zero.
1070      */
1071     function _beforeTokenTransfers(
1072         address from,
1073         address to,
1074         uint256 startTokenId,
1075         uint256 quantity
1076     ) internal virtual {}
1077 
1078     /**
1079      * @dev Hook that is called after a set of serially-ordered token IDs
1080      * have been transferred. This includes minting.
1081      * And also called after one token has been burned.
1082      *
1083      * `startTokenId` - the first token ID to be transferred.
1084      * `quantity` - the amount to be transferred.
1085      *
1086      * Calling conditions:
1087      *
1088      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1089      * transferred to `to`.
1090      * - When `from` is zero, `tokenId` has been minted for `to`.
1091      * - When `to` is zero, `tokenId` has been burned by `from`.
1092      * - `from` and `to` are never both zero.
1093      */
1094     function _afterTokenTransfers(
1095         address from,
1096         address to,
1097         uint256 startTokenId,
1098         uint256 quantity
1099     ) internal virtual {}
1100 
1101     /**
1102      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1103      *
1104      * `from` - Previous owner of the given token ID.
1105      * `to` - Target address that will receive the token.
1106      * `tokenId` - Token ID to be transferred.
1107      * `_data` - Optional data to send along with the call.
1108      *
1109      * Returns whether the call correctly returned the expected magic value.
1110      */
1111     function _checkContractOnERC721Received(
1112         address from,
1113         address to,
1114         uint256 tokenId,
1115         bytes memory _data
1116     ) private returns (bool) {
1117         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1118             bytes4 retval
1119         ) {
1120             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1121         } catch (bytes memory reason) {
1122             if (reason.length == 0) {
1123                 revert TransferToNonERC721ReceiverImplementer();
1124             } else {
1125                 assembly {
1126                     revert(add(32, reason), mload(reason))
1127                 }
1128             }
1129         }
1130     }
1131 
1132     // =============================================================
1133     //                        MINT OPERATIONS
1134     // =============================================================
1135 
1136     /**
1137      * @dev Mints `quantity` tokens and transfers them to `to`.
1138      *
1139      * Requirements:
1140      *
1141      * - `to` cannot be the zero address.
1142      * - `quantity` must be greater than 0.
1143      *
1144      * Emits a {Transfer} event for each mint.
1145      */
1146     function _mint(address to, uint256 quantity) internal virtual {
1147         uint256 startTokenId = _currentIndex;
1148         if (quantity == 0) revert MintZeroQuantity();
1149 
1150         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1151 
1152         // Overflows are incredibly unrealistic.
1153         // `balance` and `numberMinted` have a maximum limit of 2**64.
1154         // `tokenId` has a maximum limit of 2**256.
1155         unchecked {
1156             // Updates:
1157             // - `balance += quantity`.
1158             // - `numberMinted += quantity`.
1159             //
1160             // We can directly add to the `balance` and `numberMinted`.
1161             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1162 
1163             // Updates:
1164             // - `address` to the owner.
1165             // - `startTimestamp` to the timestamp of minting.
1166             // - `burned` to `false`.
1167             // - `nextInitialized` to `quantity == 1`.
1168             _packedOwnerships[startTokenId] = _packOwnershipData(
1169                 to,
1170                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1171             );
1172 
1173             uint256 toMasked;
1174             uint256 end = startTokenId + quantity;
1175 
1176             // Use assembly to loop and emit the `Transfer` event for gas savings.
1177             assembly {
1178                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1179                 toMasked := and(to, _BITMASK_ADDRESS)
1180                 // Emit the `Transfer` event.
1181                 log4(
1182                     0, // Start of data (0, since no data).
1183                     0, // End of data (0, since no data).
1184                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1185                     0, // `address(0)`.
1186                     toMasked, // `to`.
1187                     startTokenId // `tokenId`.
1188                 )
1189 
1190                 for {
1191                     let tokenId := add(startTokenId, 1)
1192                 } iszero(eq(tokenId, end)) {
1193                     tokenId := add(tokenId, 1)
1194                 } {
1195                     // Emit the `Transfer` event. Similar to above.
1196                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1197                 }
1198             }
1199             if (toMasked == 0) revert MintToZeroAddress();
1200 
1201             _currentIndex = end;
1202         }
1203         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1204     }
1205 
1206     /**
1207      * @dev Mints `quantity` tokens and transfers them to `to`.
1208      *
1209      * This function is intended for efficient minting only during contract creation.
1210      *
1211      * It emits only one {ConsecutiveTransfer} as defined in
1212      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1213      * instead of a sequence of {Transfer} event(s).
1214      *
1215      * Calling this function outside of contract creation WILL make your contract
1216      * non-compliant with the ERC721 standard.
1217      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1218      * {ConsecutiveTransfer} event is only permissible during contract creation.
1219      *
1220      * Requirements:
1221      *
1222      * - `to` cannot be the zero address.
1223      * - `quantity` must be greater than 0.
1224      *
1225      * Emits a {ConsecutiveTransfer} event.
1226      */
1227     function _mintERC2309(address to, uint256 quantity) internal virtual {
1228         uint256 startTokenId = _currentIndex;
1229         if (to == address(0)) revert MintToZeroAddress();
1230         if (quantity == 0) revert MintZeroQuantity();
1231         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1232 
1233         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1234 
1235         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1236         unchecked {
1237             // Updates:
1238             // - `balance += quantity`.
1239             // - `numberMinted += quantity`.
1240             //
1241             // We can directly add to the `balance` and `numberMinted`.
1242             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1243 
1244             // Updates:
1245             // - `address` to the owner.
1246             // - `startTimestamp` to the timestamp of minting.
1247             // - `burned` to `false`.
1248             // - `nextInitialized` to `quantity == 1`.
1249             _packedOwnerships[startTokenId] = _packOwnershipData(
1250                 to,
1251                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1252             );
1253 
1254             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1255 
1256             _currentIndex = startTokenId + quantity;
1257         }
1258         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1259     }
1260 
1261     /**
1262      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1263      *
1264      * Requirements:
1265      *
1266      * - If `to` refers to a smart contract, it must implement
1267      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1268      * - `quantity` must be greater than 0.
1269      *
1270      * See {_mint}.
1271      *
1272      * Emits a {Transfer} event for each mint.
1273      */
1274     function _safeMint(
1275         address to,
1276         uint256 quantity,
1277         bytes memory _data
1278     ) internal virtual {
1279         _mint(to, quantity);
1280 
1281         unchecked {
1282             if (to.code.length != 0) {
1283                 uint256 end = _currentIndex;
1284                 uint256 index = end - quantity;
1285                 do {
1286                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1287                         revert TransferToNonERC721ReceiverImplementer();
1288                     }
1289                 } while (index < end);
1290                 // Reentrancy protection.
1291                 if (_currentIndex != end) revert();
1292             }
1293         }
1294     }
1295 
1296     /**
1297      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1298      */
1299     function _safeMint(address to, uint256 quantity) internal virtual {
1300         _safeMint(to, quantity, '');
1301     }
1302 
1303     // =============================================================
1304     //                        BURN OPERATIONS
1305     // =============================================================
1306 
1307     /**
1308      * @dev Equivalent to `_burn(tokenId, false)`.
1309      */
1310     function _burn(uint256 tokenId) internal virtual{
1311         _burn(tokenId, false);
1312     }
1313 
1314     /**
1315      * @dev Destroys `tokenId`.
1316      * The approval is cleared when the token is burned.
1317      *
1318      * Requirements:
1319      *
1320      * - `tokenId` must exist.
1321      *
1322      * Emits a {Transfer} event.
1323      */
1324     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1325         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1326 
1327         address from = address(uint160(prevOwnershipPacked));
1328 
1329         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1330 
1331         if (approvalCheck) {
1332             // The nested ifs save around 20+ gas over a compound boolean condition.
1333             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1334                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1335         }
1336 
1337         _beforeTokenTransfers(from, address(0), tokenId, 1);
1338 
1339         // Clear approvals from the previous owner.
1340         assembly {
1341             if approvedAddress {
1342                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1343                 sstore(approvedAddressSlot, 0)
1344             }
1345         }
1346 
1347         // Underflow of the sender's balance is impossible because we check for
1348         // ownership above and the recipient's balance can't realistically overflow.
1349         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1350         unchecked {
1351             // Updates:
1352             // - `balance -= 1`.
1353             // - `numberBurned += 1`.
1354             //
1355             // We can directly decrement the balance, and increment the number burned.
1356             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1357             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1358 
1359             // Updates:
1360             // - `address` to the last owner.
1361             // - `startTimestamp` to the timestamp of burning.
1362             // - `burned` to `true`.
1363             // - `nextInitialized` to `true`.
1364             _packedOwnerships[tokenId] = _packOwnershipData(
1365                 from,
1366                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1367             );
1368 
1369             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1370             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1371                 uint256 nextTokenId = tokenId + 1;
1372                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1373                 if (_packedOwnerships[nextTokenId] == 0) {
1374                     // If the next slot is within bounds.
1375                     if (nextTokenId != _currentIndex) {
1376                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1377                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1378                     }
1379                 }
1380             }
1381         }
1382 
1383         emit Transfer(from, address(0), tokenId);
1384         _afterTokenTransfers(from, address(0), tokenId, 1);
1385 
1386         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1387         unchecked {
1388             _burnCounter++;
1389         }
1390     }
1391 
1392     // =============================================================
1393     //                     EXTRA DATA OPERATIONS
1394     // =============================================================
1395 
1396     /**
1397      * @dev Directly sets the extra data for the ownership data `index`.
1398      */
1399     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1400         uint256 packed = _packedOwnerships[index];
1401         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1402         uint256 extraDataCasted;
1403         // Cast `extraData` with assembly to avoid redundant masking.
1404         assembly {
1405             extraDataCasted := extraData
1406         }
1407         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1408         _packedOwnerships[index] = packed;
1409     }
1410 
1411     /**
1412      * @dev Called during each token transfer to set the 24bit `extraData` field.
1413      * Intended to be overridden by the cosumer contract.
1414      *
1415      * `previousExtraData` - the value of `extraData` before transfer.
1416      *
1417      * Calling conditions:
1418      *
1419      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1420      * transferred to `to`.
1421      * - When `from` is zero, `tokenId` will be minted for `to`.
1422      * - When `to` is zero, `tokenId` will be burned by `from`.
1423      * - `from` and `to` are never both zero.
1424      */
1425     function _extraData(
1426         address from,
1427         address to,
1428         uint24 previousExtraData
1429     ) internal view virtual returns (uint24) {}
1430 
1431     /**
1432      * @dev Returns the next extra data for the packed ownership data.
1433      * The returned result is shifted into position.
1434      */
1435     function _nextExtraData(
1436         address from,
1437         address to,
1438         uint256 prevOwnershipPacked
1439     ) private view returns (uint256) {
1440         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1441         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1442     }
1443 
1444     // =============================================================
1445     //                       OTHER OPERATIONS
1446     // =============================================================
1447 
1448     /**
1449      * @dev Returns the message sender (defaults to `msg.sender`).
1450      *
1451      * If you are writing GSN compatible contracts, you need to override this function.
1452      */
1453     function _msgSenderERC721A() internal view virtual returns (address) {
1454         return msg.sender;
1455     }
1456 
1457     /**
1458      * @dev Converts a uint256 to its ASCII string decimal representation.
1459      */
1460     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1461         assembly {
1462             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1463             // but we allocate 0x80 bytes to keep the free memory pointer 32-byte word aliged.
1464             // We will need 1 32-byte word to store the length,
1465             // and 3 32-byte words to store a maximum of 78 digits. Total: 0x20 + 3 * 0x20 = 0x80.
1466             str := add(mload(0x40), 0x80)
1467             // Update the free memory pointer to allocate.
1468             mstore(0x40, str)
1469 
1470             // Cache the end of the memory to calculate the length later.
1471             let end := str
1472 
1473             // We write the string from rightmost digit to leftmost digit.
1474             // The following is essentially a do-while loop that also handles the zero case.
1475             // prettier-ignore
1476             for { let temp := value } 1 {} {
1477                 str := sub(str, 1)
1478                 // Write the character to the pointer.
1479                 // The ASCII index of the '0' character is 48.
1480                 mstore8(str, add(48, mod(temp, 10)))
1481                 // Keep dividing `temp` until zero.
1482                 temp := div(temp, 10)
1483                 // prettier-ignore
1484                 if iszero(temp) { break }
1485             }
1486 
1487             let length := sub(end, str)
1488             // Move the pointer 32 bytes leftwards to make room for the length.
1489             str := sub(str, 0x20)
1490             // Store the length.
1491             mstore(str, length)
1492         }
1493     }
1494 }
1495 
1496 // File: TheNFTWar.sol
1497 
1498 
1499 
1500 
1501 pragma solidity ^0.8.0;
1502 
1503 
1504 
1505 library MerkleProof {
1506     function verify(
1507         bytes32[] memory proof,
1508         bytes32 root,
1509         bytes32 leaf
1510     ) internal pure returns (bool) {
1511         return processProof(proof, leaf) == root;
1512     }
1513 
1514     function processProof(bytes32[] memory proof, bytes32 leaf)
1515         internal
1516         pure
1517         returns (bytes32)
1518     {
1519         bytes32 computedHash = leaf;
1520         for (uint256 i = 0; i < proof.length; i++) {
1521             bytes32 proofElement = proof[i];
1522             if (computedHash <= proofElement) {
1523                 computedHash = _efficientHash(computedHash, proofElement);
1524             } else {
1525                 computedHash = _efficientHash(proofElement, computedHash);
1526             }
1527         }
1528         return computedHash;
1529     }
1530 
1531     function _efficientHash(bytes32 a, bytes32 b)
1532         private
1533         pure
1534         returns (bytes32 value)
1535     {
1536         assembly {
1537             mstore(0x00, a)
1538             mstore(0x20, b)
1539             value := keccak256(0x00, 0x40)
1540         }
1541     }
1542 }
1543 
1544 abstract contract ReentrancyGuard {
1545     uint256 private constant _NOT_ENTERED = 1;
1546     uint256 private constant _ENTERED = 2;
1547 
1548     uint256 private _status;
1549 
1550     constructor() {
1551         _status = _NOT_ENTERED;
1552     }
1553 
1554     modifier nonReentrant() {
1555         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1556         _status = _ENTERED;
1557 
1558         _;
1559         _status = _NOT_ENTERED;
1560     }
1561 }
1562 
1563 /**
1564  * @dev Wrappers over Solidity's arithmetic operations.
1565  *
1566  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
1567  * now has built in overflow checking.
1568  */
1569 library SafeMath {
1570     /**
1571      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1572      *
1573      * _Available since v3.4._
1574      */
1575     function tryAdd(uint256 a, uint256 b)
1576         internal
1577         pure
1578         returns (bool, uint256)
1579     {
1580         unchecked {
1581             uint256 c = a + b;
1582             if (c < a) return (false, 0);
1583             return (true, c);
1584         }
1585     }
1586 
1587     /**
1588      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1589      *
1590      * _Available since v3.4._
1591      */
1592     function trySub(uint256 a, uint256 b)
1593         internal
1594         pure
1595         returns (bool, uint256)
1596     {
1597         unchecked {
1598             if (b > a) return (false, 0);
1599             return (true, a - b);
1600         }
1601     }
1602 
1603     /**
1604      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1605      *
1606      * _Available since v3.4._
1607      */
1608     function tryMul(uint256 a, uint256 b)
1609         internal
1610         pure
1611         returns (bool, uint256)
1612     {
1613         unchecked {
1614             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1615             // benefit is lost if 'b' is also tested.
1616             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1617             if (a == 0) return (true, 0);
1618             uint256 c = a * b;
1619             if (c / a != b) return (false, 0);
1620             return (true, c);
1621         }
1622     }
1623 
1624     /**
1625      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1626      *
1627      * _Available since v3.4._
1628      */
1629     function tryDiv(uint256 a, uint256 b)
1630         internal
1631         pure
1632         returns (bool, uint256)
1633     {
1634         unchecked {
1635             if (b == 0) return (false, 0);
1636             return (true, a / b);
1637         }
1638     }
1639 
1640     /**
1641      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1642      *
1643      * _Available since v3.4._
1644      */
1645     function tryMod(uint256 a, uint256 b)
1646         internal
1647         pure
1648         returns (bool, uint256)
1649     {
1650         unchecked {
1651             if (b == 0) return (false, 0);
1652             return (true, a % b);
1653         }
1654     }
1655 
1656     /**
1657      * @dev Returns the addition of two unsigned integers, reverting on
1658      * overflow.
1659      *
1660      * Counterpart to Solidity's `+` operator.
1661      *
1662      * Requirements:
1663      *
1664      * - Addition cannot overflow.
1665      */
1666     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1667         return a + b;
1668     }
1669 
1670     /**
1671      * @dev Returns the subtraction of two unsigned integers, reverting on
1672      * overflow (when the result is negative).
1673      *
1674      * Counterpart to Solidity's `-` operator.
1675      *
1676      * Requirements:
1677      *
1678      * - Subtraction cannot overflow.
1679      */
1680     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1681         return a - b;
1682     }
1683 
1684     /**
1685      * @dev Returns the multiplication of two unsigned integers, reverting on
1686      * overflow.
1687      *
1688      * Counterpart to Solidity's `*` operator.
1689      *
1690      * Requirements:
1691      *
1692      * - Multiplication cannot overflow.
1693      */
1694     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1695         return a * b;
1696     }
1697 
1698     /**
1699      * @dev Returns the integer division of two unsigned integers, reverting on
1700      * division by zero. The result is rounded towards zero.
1701      *
1702      * Counterpart to Solidity's `/` operator.
1703      *
1704      * Requirements:
1705      *
1706      * - The divisor cannot be zero.
1707      */
1708     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1709         return a / b;
1710     }
1711 
1712     /**
1713      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1714      * reverting when dividing by zero.
1715      *
1716      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1717      * opcode (which leaves remaining gas untouched) while Solidity uses an
1718      * invalid opcode to revert (consuming all remaining gas).
1719      *
1720      * Requirements:
1721      *
1722      * - The divisor cannot be zero.
1723      */
1724     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1725         return a % b;
1726     }
1727 
1728     /**
1729      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1730      * overflow (when the result is negative).
1731      *
1732      * CAUTION: This function is deprecated because it requires allocating memory for the error
1733      * message unnecessarily. For custom revert reasons use {trySub}.
1734      *
1735      * Counterpart to Solidity's `-` operator.
1736      *
1737      * Requirements:
1738      *
1739      * - Subtraction cannot overflow.
1740      */
1741     function sub(
1742         uint256 a,
1743         uint256 b,
1744         string memory errorMessage
1745     ) internal pure returns (uint256) {
1746         unchecked {
1747             require(b <= a, errorMessage);
1748             return a - b;
1749         }
1750     }
1751 
1752     /**
1753      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1754      * division by zero. The result is rounded towards zero.
1755      *
1756      * Counterpart to Solidity's `/` operator. Note: this function uses a
1757      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1758      * uses an invalid opcode to revert (consuming all remaining gas).
1759      *
1760      * Requirements:
1761      *
1762      * - The divisor cannot be zero.
1763      */
1764     function div(
1765         uint256 a,
1766         uint256 b,
1767         string memory errorMessage
1768     ) internal pure returns (uint256) {
1769         unchecked {
1770             require(b > 0, errorMessage);
1771             return a / b;
1772         }
1773     }
1774 
1775     /**
1776      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1777      * reverting with custom message when dividing by zero.
1778      *
1779      * CAUTION: This function is deprecated because it requires allocating memory for the error
1780      * message unnecessarily. For custom revert reasons use {tryMod}.
1781      *
1782      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1783      * opcode (which leaves remaining gas untouched) while Solidity uses an
1784      * invalid opcode to revert (consuming all remaining gas).
1785      *
1786      * Requirements:
1787      *
1788      * - The divisor cannot be zero.
1789      */
1790     function mod(
1791         uint256 a,
1792         uint256 b,
1793         string memory errorMessage
1794     ) internal pure returns (uint256) {
1795         unchecked {
1796             require(b > 0, errorMessage);
1797             return a % b;
1798         }
1799     }
1800 }
1801 
1802 library Strings {
1803     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1804 
1805     function toString(uint256 value) internal pure returns (string memory) {
1806         if (value == 0) {
1807             return "0";
1808         }
1809         uint256 temp = value;
1810         uint256 digits;
1811         while (temp != 0) {
1812             digits++;
1813             temp /= 10;
1814         }
1815         bytes memory buffer = new bytes(digits);
1816         while (value != 0) {
1817             digits -= 1;
1818             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1819             value /= 10;
1820         }
1821         return string(buffer);
1822     }
1823 
1824     function toHexString(uint256 value) internal pure returns (string memory) {
1825         if (value == 0) {
1826             return "0x00";
1827         }
1828         uint256 temp = value;
1829         uint256 length = 0;
1830         while (temp != 0) {
1831             length++;
1832             temp >>= 8;
1833         }
1834         return toHexString(value, length);
1835     }
1836 
1837     function toHexString(uint256 value, uint256 length)
1838         internal
1839         pure
1840         returns (string memory)
1841     {
1842         bytes memory buffer = new bytes(2 * length + 2);
1843         buffer[0] = "0";
1844         buffer[1] = "x";
1845         for (uint256 i = 2 * length + 1; i > 1; --i) {
1846             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1847             value >>= 4;
1848         }
1849         require(value == 0, "Strings: hex length insufficient");
1850         return string(buffer);
1851     }
1852 }
1853 
1854 
1855 contract TheNFTWar is Ownable, ERC721A, ReentrancyGuard {
1856     using Strings for uint256;
1857     using SafeMath for uint256;
1858 
1859 
1860     uint256 public MAX_PER_Transaction = 2; // maximum amount that user can mint per transaction
1861     uint256 public MAX_PER_Transaction_WL = 1; // maximum amount that user can mint per transaction for whitelisted members
1862     uint256 public MAX_PER_Wallet_WL = 1;
1863     
1864 
1865     //prices
1866    
1867     uint256 public cost = 0.015 ether; 
1868     uint256 public whiteListCost = 0 ether; // Free for WL
1869     uint256 public prizeValue= 0.1 ether;
1870 
1871     uint256 public freezeTill= 10; //tokenId till which team will mint
1872     
1873     uint256 public season = 1; 
1874 
1875 
1876     //supply
1877     uint256 public  TotalCollectionSize_ = 5555; // total number of nfts
1878     uint256 public  WL_Supply = 1010; // total number of nfts for wl
1879     uint256 public  team_supply = 10; // total number of nfts for team
1880     uint256 public  team_q = 2; // total number of nfts for team
1881 
1882     bool public paused = true;
1883     bool public revealed = false;
1884     bool public presaleIsActive = false;
1885     bool public publicIsActive = false;
1886     bool public frozen = true;
1887     bool public roundEnded = false;
1888     bool public burningActivated = false;
1889 
1890     bool public claimAllowed = false;
1891     bool public lvlUpgrade = false;
1892 
1893     //war phases
1894     bool public phaseOne = false;
1895     bool public phaseTwo = false;
1896     bool public phaseThree = false;
1897     bool public phaseFour = false;
1898     bool public phaseFive = false;
1899 
1900 
1901 
1902 
1903     string public uriSuffix = ".json";
1904     string private baseTokenURI="http://159.223.214.159/Contract/metadata/";
1905     string private leaderboardUri="http://159.223.214.159/leaderboard/";
1906     string public notRevealedUri="http://159.223.214.159/hidden/";
1907 
1908     bytes32 public whitelistMerkleRoot;
1909     bytes32 public teamMerkleRoot;
1910     bytes32 public claimMerkleRoot;
1911 
1912 
1913 
1914     address[] teamAddy=[0x24d900159c233655f4C25B1C8E3AEEF63b39906B,
1915             0xD6Da993902747e270a40eb050e750Cb24162aA44,
1916             0xC6605472baE5D5249E0B644958E8a0cab8e3f8eC,
1917             0xcf9b5cb8AeC81d8aEab6CF4e62DE238E6a7f82d7,
1918             0xAb1B5812936f8678E7F58837Da146d9dc118BD0E ]; // store as an array
1919                     // Will be set when battle contract is deployed
1920 
1921     event burned(address indexed burner);
1922     event roundState(bool state);
1923     event phaseState(uint256 roundNumber,bool state);
1924     event mintState(string mintState,bool state);
1925     event mintedTokens(uint256 total);
1926 
1927 
1928     constructor()
1929         ERC721A(
1930             "TheNFTWar",
1931             "TNW"      
1932         )
1933     {
1934         
1935     }
1936 
1937     modifier isValidMerkleProof(bytes32[] calldata merkleProof, bytes32 root) {
1938         require(
1939             MerkleProof.verify(
1940                 merkleProof,
1941                 root,
1942                 keccak256(abi.encodePacked(msg.sender))
1943             ),
1944             "Address does not exist in list"
1945         );
1946         _;
1947     }
1948 
1949     modifier isValidClaim(bytes32[] calldata proofOne, bytes32 root,address proofTwo ) {
1950         require(
1951             MerkleProof.verify(
1952                 proofOne,
1953                 root,
1954                 keccak256(abi.encodePacked(proofTwo))
1955             ),
1956             "Address does not exist in list"
1957         );
1958         _;
1959     }
1960     
1961     modifier isCorrectPayment(uint256 price, uint256 numberOfTokens) {
1962         require(
1963             price * numberOfTokens == msg.value,
1964             "Incorrect ETH value sent"
1965         );
1966         _;
1967     }
1968 
1969     function approve(address to, uint256 tokenId) public override {
1970         if(frozen)
1971         {
1972             require(tokenId>freezeTill,"Not allowed yet");
1973             super.approve(to,tokenId);
1974         }
1975         else
1976         {
1977             super.approve(to,tokenId);
1978 
1979         }
1980         
1981     }
1982 
1983     function setApprovalForAll(address operator, bool approved) public override {
1984         if(frozen)
1985         {
1986             for(uint i=0;i<teamAddy.length;i++)
1987             {
1988                 if(teamAddy[i]==msg.sender)
1989                 {
1990                     return;
1991                 }
1992             }
1993         }
1994 
1995         super.setApprovalForAll(operator,approved);
1996     }
1997     function safeTransferFrom(
1998         address from,
1999         address to,
2000         uint256 tokenId
2001     ) public override {
2002         if(tokenId<=freezeTill)
2003         {
2004             require(!frozen,"Asset Frozen");
2005         }
2006         super.safeTransferFrom(from, to, tokenId);
2007     }
2008 
2009     function mint(uint256 quantity) public payable {
2010         require(!paused, "mint is paused");
2011         require(publicIsActive,"public mint not active");
2012         require(
2013             totalSupply() + quantity <= TotalCollectionSize_,
2014             "reached max supply"
2015         );
2016         require(quantity <= MAX_PER_Transaction, "can not mint this many");
2017         require(msg.value >=_shouldPay(quantity), "Insufficient funds!");
2018 
2019         _safeMint(msg.sender, quantity);
2020         emit mintedTokens(totalSupply());
2021     }
2022 
2023 
2024     function mintWhitelist(bytes32[] calldata merkleProof,uint256 quantity)
2025         public
2026         payable
2027         isValidMerkleProof(merkleProof, whitelistMerkleRoot)
2028         isCorrectPayment(whiteListCost, quantity)
2029     {
2030         require(!paused, "mint is paused");
2031         require(presaleIsActive,"Whitelist mint not active");
2032         uint256 supply = totalSupply();
2033         require(supply + quantity <= WL_Supply, "max NFT limit exceeded");
2034         require(numberMinted(msg.sender) + quantity <= MAX_PER_Wallet_WL, "limit per wallet exceeded");
2035         require(quantity <= MAX_PER_Transaction_WL, "can not mint this many in one transaction");
2036         _safeMint(msg.sender, quantity);
2037         emit mintedTokens(totalSupply());
2038 
2039     }
2040 
2041     function mintTeam(bytes32[] calldata merkleProof)
2042         public
2043         payable
2044         isValidMerkleProof(merkleProof, teamMerkleRoot)
2045         isCorrectPayment(whiteListCost, team_q)
2046     {
2047         require(!paused, "mint is paused");
2048         uint256 supply = totalSupply();
2049         require(supply + team_q <= team_supply, "max NFT limit exceeded");
2050         require(numberMinted(msg.sender) + team_q <= team_q, "limit per wallet exceeded");
2051         _safeMint(msg.sender, team_q);
2052         emit mintedTokens(totalSupply());
2053 
2054     }
2055 
2056     function _shouldPay(uint256 _quantity) 
2057         private 
2058         view
2059         returns(uint256)
2060     {
2061         return cost*_quantity;
2062     }
2063 
2064     function burn(uint256 tokenId) external{
2065         //only call from website
2066         require(burningActivated,"Burning not allowed yet");
2067         require(ownerOf(tokenId)==msg.sender,"enter tokenId you own");
2068         require(balanceOf(msg.sender)>1,"You dont own more than 1 token");
2069         _burn(tokenId);
2070         emit burned(msg.sender);
2071     }
2072 
2073     function claimPrize(bytes32[] calldata proofOne,address proofTwo) public nonReentrant isValidClaim(proofOne, claimMerkleRoot,proofTwo) {
2074         require(claimAllowed,"Cant claim prize right now");
2075         require(!roundEnded,"Round has ended already");
2076         (bool os, ) = payable(msg.sender).call{value: prizeValue}("");
2077         roundEnded=true;
2078         phaseOne=false;
2079         phaseTwo=false;
2080         phaseThree=false;
2081         phaseFour=false;
2082         phaseFive=false;
2083         season++;
2084         require(os,"claim failed");
2085     }
2086  
2087 
2088     function tokenURI(uint256 tokenId)
2089         public
2090         view
2091         virtual
2092         override
2093         returns (string memory)
2094     {
2095         require(
2096             _exists(tokenId),
2097             "ERC721Metadata: URI query for nonexistent token"
2098         );
2099 
2100         if (revealed == false) {
2101             return notRevealedUri;
2102         }
2103 
2104         if(roundEnded==true)
2105         {
2106             return leaderboardUri;
2107         }
2108 
2109         string memory currentBaseURI = _baseURI();
2110         return
2111             bytes(currentBaseURI).length > 0
2112                 ? string(
2113                     abi.encodePacked(
2114                         currentBaseURI,
2115                         tokenId.toString(),
2116                         uriSuffix
2117                     )
2118                 )
2119                 : "";
2120     }
2121 
2122 
2123     function setWhitelistMerkleRoot(bytes32 merkleRoot) external onlyOwner {
2124         whitelistMerkleRoot = merkleRoot;
2125     }
2126     
2127     function setTeamMerkleRoot(bytes32 merkleRoot) external onlyOwner {
2128         teamMerkleRoot = merkleRoot;
2129     }
2130 
2131     function setClaimMerkleRoot(bytes32 merkleRoot) external onlyOwner {
2132         claimMerkleRoot = merkleRoot;
2133     }
2134 
2135     function addPrizeToContract() payable public onlyOwner returns (uint256)   {
2136         uint supply=totalSupply();
2137         return  address(this).balance;
2138     }
2139 
2140     function getMerkleRoot() public view returns (bytes32) {
2141         return whitelistMerkleRoot;
2142     }
2143 
2144     function setBaseURI(string memory baseURI) public onlyOwner {
2145         baseTokenURI = baseURI;
2146     }
2147 
2148     function setLeadboardURI(string memory uri) public onlyOwner {
2149         leaderboardUri = uri;
2150     }
2151 
2152     function _baseURI() internal view virtual override returns (string memory) {
2153         return baseTokenURI;
2154     }
2155 
2156 
2157     function numberMinted(address owner) public view returns (uint256) {
2158         return _numberMinted(owner);
2159     }
2160 
2161     function getOwnershipData(uint256 tokenId)
2162         external
2163         view
2164         returns (TokenOwnership memory)
2165     {
2166         return _ownershipOf(tokenId);
2167     }
2168 
2169     function withdraw() public onlyOwner nonReentrant {
2170         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
2171         require(os);
2172     }
2173 
2174     function setPrizeValue(uint256 q) public onlyOwner {
2175         prizeValue = q;
2176     }
2177 
2178     function setBurningActivated(bool _state) public onlyOwner {
2179         burningActivated = _state;
2180     }
2181 
2182     function setClaimAllowed(bool _state) public onlyOwner {
2183         claimAllowed = _state;
2184     }
2185 
2186     function setMAX_PER_TransactionWL(uint256 q) public onlyOwner {
2187         MAX_PER_Transaction_WL = q;
2188     }
2189   
2190     function setMaxPerWallet_WL(uint256 _newLimit) public onlyOwner {
2191         MAX_PER_Wallet_WL = _newLimit;
2192     }
2193 
2194     function setMAX_PER_Transaction(uint256 q) public onlyOwner {
2195         MAX_PER_Transaction = q;
2196     }
2197   
2198 
2199     function setMaxTeamSupply(uint256 _newLimit) public onlyOwner {
2200         team_supply = _newLimit;
2201     }
2202    
2203     function freezeTeam(bool _state) public onlyOwner {
2204         frozen = _state;
2205     }    
2206 
2207     function pause(bool _state) public onlyOwner {
2208         paused = _state;
2209     }
2210 
2211     function setLvlUpgrade(bool _state) public onlyOwner {
2212         lvlUpgrade = _state;
2213     }
2214     
2215     function setRoundState(bool _state) public onlyOwner {
2216         roundEnded = _state;
2217         emit roundState(roundEnded);
2218     }
2219 
2220     function setPhaseState(bool _state,uint256 phaseNum) public onlyOwner {
2221 
2222         if(phaseNum==1)
2223         phaseOne=_state;
2224         else if(phaseNum==2)
2225         phaseTwo=_state;
2226         else if(phaseNum==3)
2227         phaseThree=_state;
2228         else if(phaseNum==4)
2229         phaseFour=_state;
2230         else if(phaseNum==5)
2231         phaseFive=_state;
2232 
2233         emit phaseState(phaseNum,_state);
2234     }
2235 
2236     function setRevealed(bool _state) public onlyOwner {
2237         revealed = _state;
2238     }
2239 
2240     function ActivatePresale(bool _state) public onlyOwner {
2241         presaleIsActive = _state;
2242         emit mintState("Whitelist",presaleIsActive);
2243     }
2244 
2245     function ActivatePublicSale(bool _state) public onlyOwner {
2246         publicIsActive = _state;
2247         emit mintState("Public",publicIsActive);
2248 
2249     }
2250 
2251     function SetCollectionSize(uint256 num) public onlyOwner {
2252         TotalCollectionSize_ = num;
2253     }
2254 
2255     function SetWlColSize(uint256 num) public onlyOwner {
2256         WL_Supply = num;
2257 
2258     }
2259     
2260     function SetTeamColSize(uint256 num) public onlyOwner {
2261         team_supply = num;
2262 
2263     }
2264 
2265     
2266 }