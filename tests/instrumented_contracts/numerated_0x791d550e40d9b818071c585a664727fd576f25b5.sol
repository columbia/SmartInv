1 pragma solidity ^0.8.0;
2 
3 /**
4  * @dev Provides information about the current execution context, including the
5  * sender of the transaction and its data. While these are generally available
6  * via msg.sender and msg.data, they should not be accessed in such a direct
7  * manner, since when dealing with meta-transactions the account sending and
8  * paying for execution may not be the actual sender (as far as an application
9  * is concerned).
10  *
11  * This contract is only required for intermediate, library-like contracts.
12  */
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address) {
15         return msg.sender;
16     }
17 
18     function _msgData() internal view virtual returns (bytes calldata) {
19         return msg.data;
20     }
21 }
22 
23 // File: @openzeppelin/contracts/access/Ownable.sol
24 
25 
26 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
27 
28 pragma solidity ^0.8.0;
29 
30 
31 /**
32  * @dev Contract module which provides a basic access control mechanism, where
33  * there is an account (an owner) that can be granted exclusive access to
34  * specific functions.
35  *
36  * By default, the owner account will be the one that deploys the contract. This
37  * can later be changed with {transferOwnership}.
38  *
39  * This module is used through inheritance. It will make available the modifier
40  * `onlyOwner`, which can be applied to your functions to restrict their use to
41  * the owner.
42  */
43 abstract contract Ownable is Context {
44     address private _owner;
45 
46     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
47 
48     /**
49      * @dev Initializes the contract setting the deployer as the initial owner.
50      */
51     constructor() {
52         _transferOwnership(_msgSender());
53     }
54 
55     /**
56      * @dev Throws if called by any account other than the owner.
57      */
58     modifier onlyOwner() {
59         _checkOwner();
60         _;
61     }
62 
63     /**
64      * @dev Returns the address of the current owner.
65      */
66     function owner() public view virtual returns (address) {
67         return _owner;
68     }
69 
70     /**
71      * @dev Throws if the sender is not the owner.
72      */
73     function _checkOwner() internal view virtual {
74         require(owner() == _msgSender(), "Ownable: caller is not the owner");
75     }
76 
77     /**
78      * @dev Leaves the contract without owner. It will not be possible to call
79      * `onlyOwner` functions anymore. Can only be called by the current owner.
80      *
81      * NOTE: Renouncing ownership will leave the contract without an owner,
82      * thereby removing any functionality that is only available to the owner.
83      */
84     function renounceOwnership() public virtual onlyOwner {
85         _transferOwnership(address(0));
86     }
87 
88     /**
89      * @dev Transfers ownership of the contract to a new account (`newOwner`).
90      * Can only be called by the current owner.
91      */
92     function transferOwnership(address newOwner) public virtual onlyOwner {
93         require(newOwner != address(0), "Ownable: new owner is the zero address");
94         _transferOwnership(newOwner);
95     }
96 
97     /**
98      * @dev Transfers ownership of the contract to a new account (`newOwner`).
99      * Internal function without access restriction.
100      */
101     function _transferOwnership(address newOwner) internal virtual {
102         address oldOwner = _owner;
103         _owner = newOwner;
104         emit OwnershipTransferred(oldOwner, newOwner);
105     }
106 }
107 
108 // File: erc721a/contracts/IERC721A.sol
109 
110 
111 // ERC721A Contracts v4.2.3
112 // Creator: Chiru Labs
113 
114 pragma solidity ^0.8.4;
115 
116 /**
117  * @dev Interface of ERC721A.
118  */
119 interface IERC721A {
120     /**
121      * The caller must own the token or be an approved operator.
122      */
123     error ApprovalCallerNotOwnerNorApproved();
124 
125     /**
126      * The token does not exist.
127      */
128     error ApprovalQueryForNonexistentToken();
129 
130     /**
131      * Cannot query the balance for the zero address.
132      */
133     error BalanceQueryForZeroAddress();
134 
135     /**
136      * Cannot mint to the zero address.
137      */
138     error MintToZeroAddress();
139 
140     /**
141      * The quantity of tokens minted must be more than zero.
142      */
143     error MintZeroQuantity();
144 
145     /**
146      * The token does not exist.
147      */
148     error OwnerQueryForNonexistentToken();
149 
150     /**
151      * The caller must own the token or be an approved operator.
152      */
153     error TransferCallerNotOwnerNorApproved();
154 
155     /**
156      * The token must be owned by `from`.
157      */
158     error TransferFromIncorrectOwner();
159 
160     /**
161      * Cannot safely transfer to a contract that does not implement the
162      * ERC721Receiver interface.
163      */
164     error TransferToNonERC721ReceiverImplementer();
165 
166     /**
167      * Cannot transfer to the zero address.
168      */
169     error TransferToZeroAddress();
170 
171     /**
172      * The token does not exist.
173      */
174     error URIQueryForNonexistentToken();
175 
176     /**
177      * The `quantity` minted with ERC2309 exceeds the safety limit.
178      */
179     error MintERC2309QuantityExceedsLimit();
180 
181     /**
182      * The `extraData` cannot be set on an unintialized ownership slot.
183      */
184     error OwnershipNotInitializedForExtraData();
185 
186     // =============================================================
187     //                            STRUCTS
188     // =============================================================
189 
190     struct TokenOwnership {
191         // The address of the owner.
192         address addr;
193         // Stores the start time of ownership with minimal overhead for tokenomics.
194         uint64 startTimestamp;
195         // Whether the token has been burned.
196         bool burned;
197         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
198         uint24 extraData;
199     }
200 
201     // =============================================================
202     //                         TOKEN COUNTERS
203     // =============================================================
204 
205     /**
206      * @dev Returns the total number of tokens in existence.
207      * Burned tokens will reduce the count.
208      * To get the total number of tokens minted, please see {_totalMinted}.
209      */
210     function totalSupply() external view returns (uint256);
211 
212     // =============================================================
213     //                            IERC165
214     // =============================================================
215 
216     /**
217      * @dev Returns true if this contract implements the interface defined by
218      * `interfaceId`. See the corresponding
219      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
220      * to learn more about how these ids are created.
221      *
222      * This function call must use less than 30000 gas.
223      */
224     function supportsInterface(bytes4 interfaceId) external view returns (bool);
225 
226     // =============================================================
227     //                            IERC721
228     // =============================================================
229 
230     /**
231      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
232      */
233     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
234 
235     /**
236      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
237      */
238     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
239 
240     /**
241      * @dev Emitted when `owner` enables or disables
242      * (`approved`) `operator` to manage all of its assets.
243      */
244     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
245 
246     /**
247      * @dev Returns the number of tokens in `owner`'s account.
248      */
249     function balanceOf(address owner) external view returns (uint256 balance);
250 
251     /**
252      * @dev Returns the owner of the `tokenId` token.
253      *
254      * Requirements:
255      *
256      * - `tokenId` must exist.
257      */
258     function ownerOf(uint256 tokenId) external view returns (address owner);
259 
260     /**
261      * @dev Safely transfers `tokenId` token from `from` to `to`,
262      * checking first that contract recipients are aware of the ERC721 protocol
263      * to prevent tokens from being forever locked.
264      *
265      * Requirements:
266      *
267      * - `from` cannot be the zero address.
268      * - `to` cannot be the zero address.
269      * - `tokenId` token must exist and be owned by `from`.
270      * - If the caller is not `from`, it must be have been allowed to move
271      * this token by either {approve} or {setApprovalForAll}.
272      * - If `to` refers to a smart contract, it must implement
273      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
274      *
275      * Emits a {Transfer} event.
276      */
277     function safeTransferFrom(
278         address from,
279         address to,
280         uint256 tokenId,
281         bytes calldata data
282     ) external payable;
283 
284     /**
285      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
286      */
287     function safeTransferFrom(
288         address from,
289         address to,
290         uint256 tokenId
291     ) external payable;
292 
293     /**
294      * @dev Transfers `tokenId` from `from` to `to`.
295      *
296      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
297      * whenever possible.
298      *
299      * Requirements:
300      *
301      * - `from` cannot be the zero address.
302      * - `to` cannot be the zero address.
303      * - `tokenId` token must be owned by `from`.
304      * - If the caller is not `from`, it must be approved to move this token
305      * by either {approve} or {setApprovalForAll}.
306      *
307      * Emits a {Transfer} event.
308      */
309     function transferFrom(
310         address from,
311         address to,
312         uint256 tokenId
313     ) external payable;
314 
315     /**
316      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
317      * The approval is cleared when the token is transferred.
318      *
319      * Only a single account can be approved at a time, so approving the
320      * zero address clears previous approvals.
321      *
322      * Requirements:
323      *
324      * - The caller must own the token or be an approved operator.
325      * - `tokenId` must exist.
326      *
327      * Emits an {Approval} event.
328      */
329     function approve(address to, uint256 tokenId) external payable;
330 
331     /**
332      * @dev Approve or remove `operator` as an operator for the caller.
333      * Operators can call {transferFrom} or {safeTransferFrom}
334      * for any token owned by the caller.
335      *
336      * Requirements:
337      *
338      * - The `operator` cannot be the caller.
339      *
340      * Emits an {ApprovalForAll} event.
341      */
342     function setApprovalForAll(address operator, bool _approved) external;
343 
344     /**
345      * @dev Returns the account approved for `tokenId` token.
346      *
347      * Requirements:
348      *
349      * - `tokenId` must exist.
350      */
351     function getApproved(uint256 tokenId) external view returns (address operator);
352 
353     /**
354      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
355      *
356      * See {setApprovalForAll}.
357      */
358     function isApprovedForAll(address owner, address operator) external view returns (bool);
359 
360     // =============================================================
361     //                        IERC721Metadata
362     // =============================================================
363 
364     /**
365      * @dev Returns the token collection name.
366      */
367     function name() external view returns (string memory);
368 
369     /**
370      * @dev Returns the token collection symbol.
371      */
372     function symbol() external view returns (string memory);
373 
374     /**
375      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
376      */
377     function tokenURI(uint256 tokenId) external view returns (string memory);
378 
379     // =============================================================
380     //                           IERC2309
381     // =============================================================
382 
383     /**
384      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
385      * (inclusive) is transferred from `from` to `to`, as defined in the
386      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
387      *
388      * See {_mintERC2309} for more details.
389      */
390     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
391 }
392 
393 // File: erc721a/contracts/ERC721A.sol
394 
395 
396 // ERC721A Contracts v4.2.3
397 // Creator: Chiru Labs
398 
399 pragma solidity ^0.8.4;
400 
401 
402 /**
403  * @dev Interface of ERC721 token receiver.
404  */
405 interface ERC721A__IERC721Receiver {
406     function onERC721Received(
407         address operator,
408         address from,
409         uint256 tokenId,
410         bytes calldata data
411     ) external returns (bytes4);
412 }
413 
414 /**
415  * @title ERC721A
416  *
417  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
418  * Non-Fungible Token Standard, including the Metadata extension.
419  * Optimized for lower gas during batch mints.
420  *
421  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
422  * starting from `_startTokenId()`.
423  *
424  * Assumptions:
425  *
426  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
427  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
428  */
429 contract ERC721A is IERC721A {
430     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
431     struct TokenApprovalRef {
432         address value;
433     }
434 
435     // =============================================================
436     //                           CONSTANTS
437     // =============================================================
438 
439     // Mask of an entry in packed address data.
440     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
441 
442     // The bit position of `numberMinted` in packed address data.
443     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
444 
445     // The bit position of `numberBurned` in packed address data.
446     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
447 
448     // The bit position of `aux` in packed address data.
449     uint256 private constant _BITPOS_AUX = 192;
450 
451     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
452     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
453 
454     // The bit position of `startTimestamp` in packed ownership.
455     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
456 
457     // The bit mask of the `burned` bit in packed ownership.
458     uint256 private constant _BITMASK_BURNED = 1 << 224;
459 
460     // The bit position of the `nextInitialized` bit in packed ownership.
461     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
462 
463     // The bit mask of the `nextInitialized` bit in packed ownership.
464     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
465 
466     // The bit position of `extraData` in packed ownership.
467     uint256 private constant _BITPOS_EXTRA_DATA = 232;
468 
469     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
470     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
471 
472     // The mask of the lower 160 bits for addresses.
473     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
474 
475     // The maximum `quantity` that can be minted with {_mintERC2309}.
476     // This limit is to prevent overflows on the address data entries.
477     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
478     // is required to cause an overflow, which is unrealistic.
479     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
480 
481     // The `Transfer` event signature is given by:
482     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
483     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
484         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
485 
486     // =============================================================
487     //                            STORAGE
488     // =============================================================
489 
490     // The next token ID to be minted.
491     uint256 private _currentIndex;
492 
493     // The number of tokens burned.
494     uint256 private _burnCounter;
495 
496     // Token name
497     string private _name;
498 
499     // Token symbol
500     string private _symbol;
501 
502     // Mapping from token ID to ownership details
503     // An empty struct value does not necessarily mean the token is unowned.
504     // See {_packedOwnershipOf} implementation for details.
505     //
506     // Bits Layout:
507     // - [0..159]   `addr`
508     // - [160..223] `startTimestamp`
509     // - [224]      `burned`
510     // - [225]      `nextInitialized`
511     // - [232..255] `extraData`
512     mapping(uint256 => uint256) private _packedOwnerships;
513 
514     // Mapping owner address to address data.
515     //
516     // Bits Layout:
517     // - [0..63]    `balance`
518     // - [64..127]  `numberMinted`
519     // - [128..191] `numberBurned`
520     // - [192..255] `aux`
521     mapping(address => uint256) private _packedAddressData;
522 
523     // Mapping from token ID to approved address.
524     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
525 
526     // Mapping from owner to operator approvals
527     mapping(address => mapping(address => bool)) private _operatorApprovals;
528 
529     // =============================================================
530     //                          CONSTRUCTOR
531     // =============================================================
532 
533     constructor(string memory name_, string memory symbol_) {
534         _name = name_;
535         _symbol = symbol_;
536         _currentIndex = _startTokenId();
537     }
538 
539     // =============================================================
540     //                   TOKEN COUNTING OPERATIONS
541     // =============================================================
542 
543     /**
544      * @dev Returns the starting token ID.
545      * To change the starting token ID, please override this function.
546      */
547     function _startTokenId() internal view virtual returns (uint256) {
548         return 0;
549     }
550 
551     /**
552      * @dev Returns the next token ID to be minted.
553      */
554     function _nextTokenId() internal view virtual returns (uint256) {
555         return _currentIndex;
556     }
557 
558     /**
559      * @dev Returns the total number of tokens in existence.
560      * Burned tokens will reduce the count.
561      * To get the total number of tokens minted, please see {_totalMinted}.
562      */
563     function totalSupply() public view virtual override returns (uint256) {
564         // Counter underflow is impossible as _burnCounter cannot be incremented
565         // more than `_currentIndex - _startTokenId()` times.
566         unchecked {
567             return _currentIndex - _burnCounter - _startTokenId();
568         }
569     }
570 
571     /**
572      * @dev Returns the total amount of tokens minted in the contract.
573      */
574     function _totalMinted() internal view virtual returns (uint256) {
575         // Counter underflow is impossible as `_currentIndex` does not decrement,
576         // and it is initialized to `_startTokenId()`.
577         unchecked {
578             return _currentIndex - _startTokenId();
579         }
580     }
581 
582     /**
583      * @dev Returns the total number of tokens burned.
584      */
585     function _totalBurned() internal view virtual returns (uint256) {
586         return _burnCounter;
587     }
588 
589     // =============================================================
590     //                    ADDRESS DATA OPERATIONS
591     // =============================================================
592 
593     /**
594      * @dev Returns the number of tokens in `owner`'s account.
595      */
596     function balanceOf(address owner) public view virtual override returns (uint256) {
597         if (owner == address(0)) revert BalanceQueryForZeroAddress();
598         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
599     }
600 
601     /**
602      * Returns the number of tokens minted by `owner`.
603      */
604     function _numberMinted(address owner) internal view returns (uint256) {
605         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
606     }
607 
608     /**
609      * Returns the number of tokens burned by or on behalf of `owner`.
610      */
611     function _numberBurned(address owner) internal view returns (uint256) {
612         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
613     }
614 
615     /**
616      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
617      */
618     function _getAux(address owner) internal view returns (uint64) {
619         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
620     }
621 
622     /**
623      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
624      * If there are multiple variables, please pack them into a uint64.
625      */
626     function _setAux(address owner, uint64 aux) internal virtual {
627         uint256 packed = _packedAddressData[owner];
628         uint256 auxCasted;
629         // Cast `aux` with assembly to avoid redundant masking.
630         assembly {
631             auxCasted := aux
632         }
633         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
634         _packedAddressData[owner] = packed;
635     }
636 
637     // =============================================================
638     //                            IERC165
639     // =============================================================
640 
641     /**
642      * @dev Returns true if this contract implements the interface defined by
643      * `interfaceId`. See the corresponding
644      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
645      * to learn more about how these ids are created.
646      *
647      * This function call must use less than 30000 gas.
648      */
649     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
650         // The interface IDs are constants representing the first 4 bytes
651         // of the XOR of all function selectors in the interface.
652         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
653         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
654         return
655             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
656             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
657             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
658     }
659 
660     // =============================================================
661     //                        IERC721Metadata
662     // =============================================================
663 
664     /**
665      * @dev Returns the token collection name.
666      */
667     function name() public view virtual override returns (string memory) {
668         return _name;
669     }
670 
671     /**
672      * @dev Returns the token collection symbol.
673      */
674     function symbol() public view virtual override returns (string memory) {
675         return _symbol;
676     }
677 
678     /**
679      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
680      */
681     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
682         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
683 
684         string memory baseURI = _baseURI();
685         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
686     }
687 
688     /**
689      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
690      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
691      * by default, it can be overridden in child contracts.
692      */
693     function _baseURI() internal view virtual returns (string memory) {
694         return '';
695     }
696 
697     // =============================================================
698     //                     OWNERSHIPS OPERATIONS
699     // =============================================================
700 
701     /**
702      * @dev Returns the owner of the `tokenId` token.
703      *
704      * Requirements:
705      *
706      * - `tokenId` must exist.
707      */
708     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
709         return address(uint160(_packedOwnershipOf(tokenId)));
710     }
711 
712     /**
713      * @dev Gas spent here starts off proportional to the maximum mint batch size.
714      * It gradually moves to O(1) as tokens get transferred around over time.
715      */
716     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
717         return _unpackedOwnership(_packedOwnershipOf(tokenId));
718     }
719 
720     /**
721      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
722      */
723     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
724         return _unpackedOwnership(_packedOwnerships[index]);
725     }
726 
727     /**
728      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
729      */
730     function _initializeOwnershipAt(uint256 index) internal virtual {
731         if (_packedOwnerships[index] == 0) {
732             _packedOwnerships[index] = _packedOwnershipOf(index);
733         }
734     }
735 
736     /**
737      * Returns the packed ownership data of `tokenId`.
738      */
739     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
740         uint256 curr = tokenId;
741 
742         unchecked {
743             if (_startTokenId() <= curr)
744                 if (curr < _currentIndex) {
745                     uint256 packed = _packedOwnerships[curr];
746                     // If not burned.
747                     if (packed & _BITMASK_BURNED == 0) {
748                         // Invariant:
749                         // There will always be an initialized ownership slot
750                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
751                         // before an unintialized ownership slot
752                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
753                         // Hence, `curr` will not underflow.
754                         //
755                         // We can directly compare the packed value.
756                         // If the address is zero, packed will be zero.
757                         while (packed == 0) {
758                             packed = _packedOwnerships[--curr];
759                         }
760                         return packed;
761                     }
762                 }
763         }
764         revert OwnerQueryForNonexistentToken();
765     }
766 
767     /**
768      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
769      */
770     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
771         ownership.addr = address(uint160(packed));
772         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
773         ownership.burned = packed & _BITMASK_BURNED != 0;
774         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
775     }
776 
777     /**
778      * @dev Packs ownership data into a single uint256.
779      */
780     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
781         assembly {
782             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
783             owner := and(owner, _BITMASK_ADDRESS)
784             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
785             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
786         }
787     }
788 
789     /**
790      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
791      */
792     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
793         // For branchless setting of the `nextInitialized` flag.
794         assembly {
795             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
796             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
797         }
798     }
799 
800     // =============================================================
801     //                      APPROVAL OPERATIONS
802     // =============================================================
803 
804     /**
805      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
806      * The approval is cleared when the token is transferred.
807      *
808      * Only a single account can be approved at a time, so approving the
809      * zero address clears previous approvals.
810      *
811      * Requirements:
812      *
813      * - The caller must own the token or be an approved operator.
814      * - `tokenId` must exist.
815      *
816      * Emits an {Approval} event.
817      */
818     function approve(address to, uint256 tokenId) public payable virtual override {
819         address owner = ownerOf(tokenId);
820 
821         if (_msgSenderERC721A() != owner)
822             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
823                 revert ApprovalCallerNotOwnerNorApproved();
824             }
825 
826         _tokenApprovals[tokenId].value = to;
827         emit Approval(owner, to, tokenId);
828     }
829 
830     /**
831      * @dev Returns the account approved for `tokenId` token.
832      *
833      * Requirements:
834      *
835      * - `tokenId` must exist.
836      */
837     function getApproved(uint256 tokenId) public view virtual override returns (address) {
838         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
839 
840         return _tokenApprovals[tokenId].value;
841     }
842 
843     /**
844      * @dev Approve or remove `operator` as an operator for the caller.
845      * Operators can call {transferFrom} or {safeTransferFrom}
846      * for any token owned by the caller.
847      *
848      * Requirements:
849      *
850      * - The `operator` cannot be the caller.
851      *
852      * Emits an {ApprovalForAll} event.
853      */
854     function setApprovalForAll(address operator, bool approved) public virtual override {
855         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
856         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
857     }
858 
859     /**
860      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
861      *
862      * See {setApprovalForAll}.
863      */
864     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
865         return _operatorApprovals[owner][operator];
866     }
867 
868     /**
869      * @dev Returns whether `tokenId` exists.
870      *
871      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
872      *
873      * Tokens start existing when they are minted. See {_mint}.
874      */
875     function _exists(uint256 tokenId) internal view virtual returns (bool) {
876         return
877             _startTokenId() <= tokenId &&
878             tokenId < _currentIndex && // If within bounds,
879             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
880     }
881 
882     /**
883      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
884      */
885     function _isSenderApprovedOrOwner(
886         address approvedAddress,
887         address owner,
888         address msgSender
889     ) private pure returns (bool result) {
890         assembly {
891             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
892             owner := and(owner, _BITMASK_ADDRESS)
893             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
894             msgSender := and(msgSender, _BITMASK_ADDRESS)
895             // `msgSender == owner || msgSender == approvedAddress`.
896             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
897         }
898     }
899 
900     /**
901      * @dev Returns the storage slot and value for the approved address of `tokenId`.
902      */
903     function _getApprovedSlotAndAddress(uint256 tokenId)
904         private
905         view
906         returns (uint256 approvedAddressSlot, address approvedAddress)
907     {
908         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
909         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
910         assembly {
911             approvedAddressSlot := tokenApproval.slot
912             approvedAddress := sload(approvedAddressSlot)
913         }
914     }
915 
916     // =============================================================
917     //                      TRANSFER OPERATIONS
918     // =============================================================
919 
920     /**
921      * @dev Transfers `tokenId` from `from` to `to`.
922      *
923      * Requirements:
924      *
925      * - `from` cannot be the zero address.
926      * - `to` cannot be the zero address.
927      * - `tokenId` token must be owned by `from`.
928      * - If the caller is not `from`, it must be approved to move this token
929      * by either {approve} or {setApprovalForAll}.
930      *
931      * Emits a {Transfer} event.
932      */
933     function transferFrom(
934         address from,
935         address to,
936         uint256 tokenId
937     ) public payable virtual override {
938         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
939 
940         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
941 
942         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
943 
944         // The nested ifs save around 20+ gas over a compound boolean condition.
945         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
946             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
947 
948         if (to == address(0)) revert TransferToZeroAddress();
949 
950         _beforeTokenTransfers(from, to, tokenId, 1);
951 
952         // Clear approvals from the previous owner.
953         assembly {
954             if approvedAddress {
955                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
956                 sstore(approvedAddressSlot, 0)
957             }
958         }
959 
960         // Underflow of the sender's balance is impossible because we check for
961         // ownership above and the recipient's balance can't realistically overflow.
962         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
963         unchecked {
964             // We can directly increment and decrement the balances.
965             --_packedAddressData[from]; // Updates: `balance -= 1`.
966             ++_packedAddressData[to]; // Updates: `balance += 1`.
967 
968             // Updates:
969             // - `address` to the next owner.
970             // - `startTimestamp` to the timestamp of transfering.
971             // - `burned` to `false`.
972             // - `nextInitialized` to `true`.
973             _packedOwnerships[tokenId] = _packOwnershipData(
974                 to,
975                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
976             );
977 
978             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
979             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
980                 uint256 nextTokenId = tokenId + 1;
981                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
982                 if (_packedOwnerships[nextTokenId] == 0) {
983                     // If the next slot is within bounds.
984                     if (nextTokenId != _currentIndex) {
985                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
986                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
987                     }
988                 }
989             }
990         }
991 
992         emit Transfer(from, to, tokenId);
993         _afterTokenTransfers(from, to, tokenId, 1);
994     }
995 
996     /**
997      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
998      */
999     function safeTransferFrom(
1000         address from,
1001         address to,
1002         uint256 tokenId
1003     ) public payable virtual override {
1004         safeTransferFrom(from, to, tokenId, '');
1005     }
1006 
1007     /**
1008      * @dev Safely transfers `tokenId` token from `from` to `to`.
1009      *
1010      * Requirements:
1011      *
1012      * - `from` cannot be the zero address.
1013      * - `to` cannot be the zero address.
1014      * - `tokenId` token must exist and be owned by `from`.
1015      * - If the caller is not `from`, it must be approved to move this token
1016      * by either {approve} or {setApprovalForAll}.
1017      * - If `to` refers to a smart contract, it must implement
1018      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1019      *
1020      * Emits a {Transfer} event.
1021      */
1022     function safeTransferFrom(
1023         address from,
1024         address to,
1025         uint256 tokenId,
1026         bytes memory _data
1027     ) public payable virtual override {
1028         transferFrom(from, to, tokenId);
1029         if (to.code.length != 0)
1030             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1031                 revert TransferToNonERC721ReceiverImplementer();
1032             }
1033     }
1034 
1035     /**
1036      * @dev Hook that is called before a set of serially-ordered token IDs
1037      * are about to be transferred. This includes minting.
1038      * And also called before burning one token.
1039      *
1040      * `startTokenId` - the first token ID to be transferred.
1041      * `quantity` - the amount to be transferred.
1042      *
1043      * Calling conditions:
1044      *
1045      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1046      * transferred to `to`.
1047      * - When `from` is zero, `tokenId` will be minted for `to`.
1048      * - When `to` is zero, `tokenId` will be burned by `from`.
1049      * - `from` and `to` are never both zero.
1050      */
1051     function _beforeTokenTransfers(
1052         address from,
1053         address to,
1054         uint256 startTokenId,
1055         uint256 quantity
1056     ) internal virtual {}
1057 
1058     /**
1059      * @dev Hook that is called after a set of serially-ordered token IDs
1060      * have been transferred. This includes minting.
1061      * And also called after one token has been burned.
1062      *
1063      * `startTokenId` - the first token ID to be transferred.
1064      * `quantity` - the amount to be transferred.
1065      *
1066      * Calling conditions:
1067      *
1068      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1069      * transferred to `to`.
1070      * - When `from` is zero, `tokenId` has been minted for `to`.
1071      * - When `to` is zero, `tokenId` has been burned by `from`.
1072      * - `from` and `to` are never both zero.
1073      */
1074     function _afterTokenTransfers(
1075         address from,
1076         address to,
1077         uint256 startTokenId,
1078         uint256 quantity
1079     ) internal virtual {}
1080 
1081     /**
1082      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1083      *
1084      * `from` - Previous owner of the given token ID.
1085      * `to` - Target address that will receive the token.
1086      * `tokenId` - Token ID to be transferred.
1087      * `_data` - Optional data to send along with the call.
1088      *
1089      * Returns whether the call correctly returned the expected magic value.
1090      */
1091     function _checkContractOnERC721Received(
1092         address from,
1093         address to,
1094         uint256 tokenId,
1095         bytes memory _data
1096     ) private returns (bool) {
1097         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1098             bytes4 retval
1099         ) {
1100             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1101         } catch (bytes memory reason) {
1102             if (reason.length == 0) {
1103                 revert TransferToNonERC721ReceiverImplementer();
1104             } else {
1105                 assembly {
1106                     revert(add(32, reason), mload(reason))
1107                 }
1108             }
1109         }
1110     }
1111 
1112     // =============================================================
1113     //                        MINT OPERATIONS
1114     // =============================================================
1115 
1116     /**
1117      * @dev Mints `quantity` tokens and transfers them to `to`.
1118      *
1119      * Requirements:
1120      *
1121      * - `to` cannot be the zero address.
1122      * - `quantity` must be greater than 0.
1123      *
1124      * Emits a {Transfer} event for each mint.
1125      */
1126     function _mint(address to, uint256 quantity) internal virtual {
1127         uint256 startTokenId = _currentIndex;
1128         if (quantity == 0) revert MintZeroQuantity();
1129 
1130         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1131 
1132         // Overflows are incredibly unrealistic.
1133         // `balance` and `numberMinted` have a maximum limit of 2**64.
1134         // `tokenId` has a maximum limit of 2**256.
1135         unchecked {
1136             // Updates:
1137             // - `balance += quantity`.
1138             // - `numberMinted += quantity`.
1139             //
1140             // We can directly add to the `balance` and `numberMinted`.
1141             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1142 
1143             // Updates:
1144             // - `address` to the owner.
1145             // - `startTimestamp` to the timestamp of minting.
1146             // - `burned` to `false`.
1147             // - `nextInitialized` to `quantity == 1`.
1148             _packedOwnerships[startTokenId] = _packOwnershipData(
1149                 to,
1150                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1151             );
1152 
1153             uint256 toMasked;
1154             uint256 end = startTokenId + quantity;
1155 
1156             // Use assembly to loop and emit the `Transfer` event for gas savings.
1157             // The duplicated `log4` removes an extra check and reduces stack juggling.
1158             // The assembly, together with the surrounding Solidity code, have been
1159             // delicately arranged to nudge the compiler into producing optimized opcodes.
1160             assembly {
1161                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1162                 toMasked := and(to, _BITMASK_ADDRESS)
1163                 // Emit the `Transfer` event.
1164                 log4(
1165                     0, // Start of data (0, since no data).
1166                     0, // End of data (0, since no data).
1167                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1168                     0, // `address(0)`.
1169                     toMasked, // `to`.
1170                     startTokenId // `tokenId`.
1171                 )
1172 
1173                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1174                 // that overflows uint256 will make the loop run out of gas.
1175                 // The compiler will optimize the `iszero` away for performance.
1176                 for {
1177                     let tokenId := add(startTokenId, 1)
1178                 } iszero(eq(tokenId, end)) {
1179                     tokenId := add(tokenId, 1)
1180                 } {
1181                     // Emit the `Transfer` event. Similar to above.
1182                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1183                 }
1184             }
1185             if (toMasked == 0) revert MintToZeroAddress();
1186 
1187             _currentIndex = end;
1188         }
1189         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1190     }
1191 
1192     /**
1193      * @dev Mints `quantity` tokens and transfers them to `to`.
1194      *
1195      * This function is intended for efficient minting only during contract creation.
1196      *
1197      * It emits only one {ConsecutiveTransfer} as defined in
1198      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1199      * instead of a sequence of {Transfer} event(s).
1200      *
1201      * Calling this function outside of contract creation WILL make your contract
1202      * non-compliant with the ERC721 standard.
1203      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1204      * {ConsecutiveTransfer} event is only permissible during contract creation.
1205      *
1206      * Requirements:
1207      *
1208      * - `to` cannot be the zero address.
1209      * - `quantity` must be greater than 0.
1210      *
1211      * Emits a {ConsecutiveTransfer} event.
1212      */
1213     function _mintERC2309(address to, uint256 quantity) internal virtual {
1214         uint256 startTokenId = _currentIndex;
1215         if (to == address(0)) revert MintToZeroAddress();
1216         if (quantity == 0) revert MintZeroQuantity();
1217         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1218 
1219         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1220 
1221         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1222         unchecked {
1223             // Updates:
1224             // - `balance += quantity`.
1225             // - `numberMinted += quantity`.
1226             //
1227             // We can directly add to the `balance` and `numberMinted`.
1228             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1229 
1230             // Updates:
1231             // - `address` to the owner.
1232             // - `startTimestamp` to the timestamp of minting.
1233             // - `burned` to `false`.
1234             // - `nextInitialized` to `quantity == 1`.
1235             _packedOwnerships[startTokenId] = _packOwnershipData(
1236                 to,
1237                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1238             );
1239 
1240             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1241 
1242             _currentIndex = startTokenId + quantity;
1243         }
1244         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1245     }
1246 
1247     /**
1248      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1249      *
1250      * Requirements:
1251      *
1252      * - If `to` refers to a smart contract, it must implement
1253      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1254      * - `quantity` must be greater than 0.
1255      *
1256      * See {_mint}.
1257      *
1258      * Emits a {Transfer} event for each mint.
1259      */
1260     function _safeMint(
1261         address to,
1262         uint256 quantity,
1263         bytes memory _data
1264     ) internal virtual {
1265         _mint(to, quantity);
1266 
1267         unchecked {
1268             if (to.code.length != 0) {
1269                 uint256 end = _currentIndex;
1270                 uint256 index = end - quantity;
1271                 do {
1272                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1273                         revert TransferToNonERC721ReceiverImplementer();
1274                     }
1275                 } while (index < end);
1276                 // Reentrancy protection.
1277                 if (_currentIndex != end) revert();
1278             }
1279         }
1280     }
1281 
1282     /**
1283      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1284      */
1285     function _safeMint(address to, uint256 quantity) internal virtual {
1286         _safeMint(to, quantity, '');
1287     }
1288 
1289     // =============================================================
1290     //                        BURN OPERATIONS
1291     // =============================================================
1292 
1293     /**
1294      * @dev Equivalent to `_burn(tokenId, false)`.
1295      */
1296     function _burn(uint256 tokenId) internal virtual {
1297         _burn(tokenId, false);
1298     }
1299 
1300     /**
1301      * @dev Destroys `tokenId`.
1302      * The approval is cleared when the token is burned.
1303      *
1304      * Requirements:
1305      *
1306      * - `tokenId` must exist.
1307      *
1308      * Emits a {Transfer} event.
1309      */
1310     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1311         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1312 
1313         address from = address(uint160(prevOwnershipPacked));
1314 
1315         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1316 
1317         if (approvalCheck) {
1318             // The nested ifs save around 20+ gas over a compound boolean condition.
1319             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1320                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1321         }
1322 
1323         _beforeTokenTransfers(from, address(0), tokenId, 1);
1324 
1325         // Clear approvals from the previous owner.
1326         assembly {
1327             if approvedAddress {
1328                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1329                 sstore(approvedAddressSlot, 0)
1330             }
1331         }
1332 
1333         // Underflow of the sender's balance is impossible because we check for
1334         // ownership above and the recipient's balance can't realistically overflow.
1335         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1336         unchecked {
1337             // Updates:
1338             // - `balance -= 1`.
1339             // - `numberBurned += 1`.
1340             //
1341             // We can directly decrement the balance, and increment the number burned.
1342             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1343             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1344 
1345             // Updates:
1346             // - `address` to the last owner.
1347             // - `startTimestamp` to the timestamp of burning.
1348             // - `burned` to `true`.
1349             // - `nextInitialized` to `true`.
1350             _packedOwnerships[tokenId] = _packOwnershipData(
1351                 from,
1352                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1353             );
1354 
1355             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1356             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1357                 uint256 nextTokenId = tokenId + 1;
1358                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1359                 if (_packedOwnerships[nextTokenId] == 0) {
1360                     // If the next slot is within bounds.
1361                     if (nextTokenId != _currentIndex) {
1362                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1363                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1364                     }
1365                 }
1366             }
1367         }
1368 
1369         emit Transfer(from, address(0), tokenId);
1370         _afterTokenTransfers(from, address(0), tokenId, 1);
1371 
1372         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1373         unchecked {
1374             _burnCounter++;
1375         }
1376     }
1377 
1378     // =============================================================
1379     //                     EXTRA DATA OPERATIONS
1380     // =============================================================
1381 
1382     /**
1383      * @dev Directly sets the extra data for the ownership data `index`.
1384      */
1385     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1386         uint256 packed = _packedOwnerships[index];
1387         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1388         uint256 extraDataCasted;
1389         // Cast `extraData` with assembly to avoid redundant masking.
1390         assembly {
1391             extraDataCasted := extraData
1392         }
1393         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1394         _packedOwnerships[index] = packed;
1395     }
1396 
1397     /**
1398      * @dev Called during each token transfer to set the 24bit `extraData` field.
1399      * Intended to be overridden by the cosumer contract.
1400      *
1401      * `previousExtraData` - the value of `extraData` before transfer.
1402      *
1403      * Calling conditions:
1404      *
1405      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1406      * transferred to `to`.
1407      * - When `from` is zero, `tokenId` will be minted for `to`.
1408      * - When `to` is zero, `tokenId` will be burned by `from`.
1409      * - `from` and `to` are never both zero.
1410      */
1411     function _extraData(
1412         address from,
1413         address to,
1414         uint24 previousExtraData
1415     ) internal view virtual returns (uint24) {}
1416 
1417     /**
1418      * @dev Returns the next extra data for the packed ownership data.
1419      * The returned result is shifted into position.
1420      */
1421     function _nextExtraData(
1422         address from,
1423         address to,
1424         uint256 prevOwnershipPacked
1425     ) private view returns (uint256) {
1426         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1427         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1428     }
1429 
1430     // =============================================================
1431     //                       OTHER OPERATIONS
1432     // =============================================================
1433 
1434     /**
1435      * @dev Returns the message sender (defaults to `msg.sender`).
1436      *
1437      * If you are writing GSN compatible contracts, you need to override this function.
1438      */
1439     function _msgSenderERC721A() internal view virtual returns (address) {
1440         return msg.sender;
1441     }
1442 
1443     /**
1444      * @dev Converts a uint256 to its ASCII string decimal representation.
1445      */
1446     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1447         assembly {
1448             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1449             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1450             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1451             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1452             let m := add(mload(0x40), 0xa0)
1453             // Update the free memory pointer to allocate.
1454             mstore(0x40, m)
1455             // Assign the `str` to the end.
1456             str := sub(m, 0x20)
1457             // Zeroize the slot after the string.
1458             mstore(str, 0)
1459 
1460             // Cache the end of the memory to calculate the length later.
1461             let end := str
1462 
1463             // We write the string from rightmost digit to leftmost digit.
1464             // The following is essentially a do-while loop that also handles the zero case.
1465             // prettier-ignore
1466             for { let temp := value } 1 {} {
1467                 str := sub(str, 1)
1468                 // Write the character to the pointer.
1469                 // The ASCII index of the '0' character is 48.
1470                 mstore8(str, add(48, mod(temp, 10)))
1471                 // Keep dividing `temp` until zero.
1472                 temp := div(temp, 10)
1473                 // prettier-ignore
1474                 if iszero(temp) { break }
1475             }
1476 
1477             let length := sub(end, str)
1478             // Move the pointer 32 bytes leftwards to make room for the length.
1479             str := sub(str, 0x20)
1480             // Store the length.
1481             mstore(str, length)
1482         }
1483     }
1484 }
1485 
1486 // File: contracts/4_CubesNFT.sol
1487 
1488 //SPDX-License-Identifier: MIT
1489 pragma solidity ^0.8.11;
1490 
1491 
1492 
1493 contract CubesNFT is ERC721A, Ownable {
1494     uint256 public PUBLIC_SALE_TIME;
1495     uint256 public PUBLIC_SALE_PRICE;
1496     string BASE_URI;
1497     mapping(address => uint8) presaleClaimed;
1498 
1499     constructor(string memory baseURI) ERC721A("CubesNFT", "CUBES") {
1500         PUBLIC_SALE_TIME = block.timestamp + 2592000;
1501         PUBLIC_SALE_PRICE = 6e15;
1502         BASE_URI = baseURI;
1503     }
1504 
1505     function setPublicSaleTime(uint256 newTime) external onlyOwner {
1506         PUBLIC_SALE_TIME = newTime;
1507     }
1508 
1509     function setPublicSalePrice(uint256 newPrice) external onlyOwner {
1510         PUBLIC_SALE_PRICE = newPrice;
1511     }
1512 
1513     function setBaseURI(string memory newURI) external onlyOwner {
1514         BASE_URI = newURI;
1515     }
1516 
1517         function mint(uint8 quantity) external payable {
1518         uint256 unitPrice = PUBLIC_SALE_PRICE;
1519         if (PUBLIC_SALE_TIME > block.timestamp) {
1520             require(quantity == 1, "One mint at a time during presale");
1521             require(
1522                 presaleClaimed[_msgSender()] < 2,
1523                 "Presale already claimed!"
1524             );
1525             require((totalSupply() + quantity) < 1000, "Free mint limit reached");
1526             presaleClaimed[_msgSender()] += quantity;
1527             unitPrice = 0;
1528         }
1529         require(
1530             msg.value >= quantity * unitPrice,
1531             "Insufficient price to purchase"
1532         );
1533         _safeMint(_msgSender(), quantity);
1534         payable(owner()).transfer(msg.value);
1535     }
1536 
1537     function _baseURI() internal view override returns (string memory) {
1538         return BASE_URI;
1539     }
1540 }