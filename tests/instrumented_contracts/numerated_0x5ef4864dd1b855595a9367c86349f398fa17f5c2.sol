1 /**
2  *Submitted for verification at Etherscan.io on 2022-10-18
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2022-09-26
7 */
8 
9 /**
10  *Submitted for verification at Etherscan.io on 2022-09-23
11 */
12 
13 /**
14  *Submitted for verification at Etherscan.io on 2022-08-23
15 */
16 
17 /**
18  *Submitted for verification at Etherscan.io on 2022-08-22
19 */
20 
21 /**
22  *Submitted for verification at Etherscan.io on 2022-08-02
23 */
24 
25 /**
26  *Submitted for verification at Etherscan.io on 2022-07-20
27 */
28 
29 // SPDX-License-Identifier: MIT
30 // File: @openzeppelin/contracts/utils/Context.sol
31 
32 
33 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
34 
35 pragma solidity ^0.8.0;
36 
37 /**
38  * @dev Provides information about the current execution context, including the
39  * sender of the transaction and its data. While these are generally available
40  * via msg.sender and msg.data, they should not be accessed in such a direct
41  * manner, since when dealing with meta-transactions the account sending and
42  * paying for execution may not be the actual sender (as far as an application
43  * is concerned).
44  *
45  * This contract is only required for intermediate, library-like contracts.
46  */
47 abstract contract Context {
48     function _msgSender() internal view virtual returns (address) {
49         return msg.sender;
50     }
51 
52     function _msgData() internal view virtual returns (bytes calldata) {
53         return msg.data;
54     }
55 }
56 
57 // File: @openzeppelin/contracts/access/Ownable.sol
58 
59 
60 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
61 
62 pragma solidity ^0.8.0;
63 
64 
65 /**
66  * @dev Contract module which provides a basic access control mechanism, where
67  * there is an account (an owner) that can be granted exclusive access to
68  * specific functions.
69  *
70  * By default, the owner account will be the one that deploys the contract. This
71  * can later be changed with {transferOwnership}.
72  *
73  * This module is used through inheritance. It will make available the modifier
74  * `onlyOwner`, which can be applied to your functions to restrict their use to
75  * the owner.
76  */
77 abstract contract Ownable is Context {
78     address private _owner;
79 
80     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
81 
82     /**
83      * @dev Initializes the contract setting the deployer as the initial owner.
84      */
85     constructor() {
86         _transferOwnership(_msgSender());
87     }
88 
89     /**
90      * @dev Throws if called by any account other than the owner.
91      */
92     modifier onlyOwner() {
93         _checkOwner();
94         _;
95     }
96 
97     /**
98      * @dev Returns the address of the current owner.
99      */
100     function owner() public view virtual returns (address) {
101         return _owner;
102     }
103 
104     /**
105      * @dev Throws if the sender is not the owner.
106      */
107     function _checkOwner() internal view virtual {
108         require(owner() == _msgSender(), "Ownable: caller is not the owner");
109     }
110 
111     /**
112      * @dev Leaves the contract without owner. It will not be possible to call
113      * `onlyOwner` functions anymore. Can only be called by the current owner.
114      *
115      * NOTE: Renouncing ownership will leave the contract without an owner,
116      * thereby removing any functionality that is only available to the owner.
117      */
118     function renounceOwnership() public virtual onlyOwner {
119         _transferOwnership(address(0));
120     }
121 
122     /**
123      * @dev Transfers ownership of the contract to a new account (`newOwner`).
124      * Can only be called by the current owner.
125      */
126     function transferOwnership(address newOwner) public virtual onlyOwner {
127         require(newOwner != address(0), "Ownable: new owner is the zero address");
128         _transferOwnership(newOwner);
129     }
130 
131     /**
132      * @dev Transfers ownership of the contract to a new account (`newOwner`).
133      * Internal function without access restriction.
134      */
135     function _transferOwnership(address newOwner) internal virtual {
136         address oldOwner = _owner;
137         _owner = newOwner;
138         emit OwnershipTransferred(oldOwner, newOwner);
139     }
140 }
141 
142 // File: erc721a/contracts/IERC721A.sol
143 
144 
145 // ERC721A Contracts v4.1.0
146 // Creator: Chiru Labs
147 
148 pragma solidity ^0.8.4;
149 
150 /**
151  * @dev Interface of an ERC721A compliant contract.
152  */
153 interface IERC721A {
154     /**
155      * The caller must own the token or be an approved operator.
156      */
157     error ApprovalCallerNotOwnerNorApproved();
158 
159     /**
160      * The token does not exist.
161      */
162     error ApprovalQueryForNonexistentToken();
163 
164     /**
165      * The caller cannot approve to their own address.
166      */
167     error ApproveToCaller();
168 
169     /**
170      * Cannot query the balance for the zero address.
171      */
172     error BalanceQueryForZeroAddress();
173 
174     /**
175      * Cannot mint to the zero address.
176      */
177     error MintToZeroAddress();
178 
179     /**
180      * The quantity of tokens minted must be more than zero.
181      */
182     error MintZeroQuantity();
183 
184     /**
185      * The token does not exist.
186      */
187     error OwnerQueryForNonexistentToken();
188 
189     /**
190      * The caller must own the token or be an approved operator.
191      */
192     error TransferCallerNotOwnerNorApproved();
193 
194     /**
195      * The token must be owned by `from`.
196      */
197     error TransferFromIncorrectOwner();
198 
199     /**
200      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
201      */
202     error TransferToNonERC721ReceiverImplementer();
203 
204     /**
205      * Cannot transfer to the zero address.
206      */
207     error TransferToZeroAddress();
208 
209     /**
210      * The token does not exist.
211      */
212     error URIQueryForNonexistentToken();
213 
214     /**
215      * The `quantity` minted with ERC2309 exceeds the safety limit.
216      */
217     error MintERC2309QuantityExceedsLimit();
218 
219     /**
220      * The `extraData` cannot be set on an unintialized ownership slot.
221      */
222     error OwnershipNotInitializedForExtraData();
223 
224     struct TokenOwnership {
225         // The address of the owner.
226         address addr;
227         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
228         uint64 startTimestamp;
229         // Whether the token has been burned.
230         bool burned;
231         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
232         uint24 extraData;
233     }
234 
235     /**
236      * @dev Returns the total amount of tokens stored by the contract.
237      *
238      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
239      */
240     function totalSupply() external view returns (uint256);
241 
242     // ==============================
243     //            IERC165
244     // ==============================
245 
246     /**
247      * @dev Returns true if this contract implements the interface defined by
248      * `interfaceId`. See the corresponding
249      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
250      * to learn more about how these ids are created.
251      *
252      * This function call must use less than 30 000 gas.
253      */
254     function supportsInterface(bytes4 interfaceId) external view returns (bool);
255 
256     // ==============================
257     //            IERC721
258     // ==============================
259 
260     /**
261      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
262      */
263     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
264 
265     /**
266      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
267      */
268     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
269 
270     /**
271      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
272      */
273     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
274 
275     /**
276      * @dev Returns the number of tokens in ``owner``"s account.
277      */
278     function balanceOf(address owner) external view returns (uint256 balance);
279 
280     /**
281      * @dev Returns the owner of the `tokenId` token.
282      *
283      * Requirements:
284      *
285      * - `tokenId` must exist.
286      */
287     function ownerOf(uint256 tokenId) external view returns (address owner);
288 
289     /**
290      * @dev Safely transfers `tokenId` token from `from` to `to`.
291      *
292      * Requirements:
293      *
294      * - `from` cannot be the zero address.
295      * - `to` cannot be the zero address.
296      * - `tokenId` token must exist and be owned by `from`.
297      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
298      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
299      *
300      * Emits a {Transfer} event.
301      */
302     function safeTransferFrom(
303         address from,
304         address to,
305         uint256 tokenId,
306         bytes calldata data
307     ) external;
308 
309     /**
310      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
311      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
312      *
313      * Requirements:
314      *
315      * - `from` cannot be the zero address.
316      * - `to` cannot be the zero address.
317      * - `tokenId` token must exist and be owned by `from`.
318      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
319      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
320      *
321      * Emits a {Transfer} event.
322      */
323     function safeTransferFrom(
324         address from,
325         address to,
326         uint256 tokenId
327     ) external;
328 
329     /**
330      * @dev Transfers `tokenId` token from `from` to `to`.
331      *
332      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
333      *
334      * Requirements:
335      *
336      * - `from` cannot be the zero address.
337      * - `to` cannot be the zero address.
338      * - `tokenId` token must be owned by `from`.
339      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
340      *
341      * Emits a {Transfer} event.
342      */
343     function transferFrom(
344         address from,
345         address to,
346         uint256 tokenId
347     ) external;
348 
349     /**
350      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
351      * The approval is cleared when the token is transferred.
352      *
353      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
354      *
355      * Requirements:
356      *
357      * - The caller must own the token or be an approved operator.
358      * - `tokenId` must exist.
359      *
360      * Emits an {Approval} event.
361      */
362     function approve(address to, uint256 tokenId) external;
363 
364     /**
365      * @dev Approve or remove `operator` as an operator for the caller.
366      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
367      *
368      * Requirements:
369      *
370      * - The `operator` cannot be the caller.
371      *
372      * Emits an {ApprovalForAll} event.
373      */
374     function setApprovalForAll(address operator, bool _approved) external;
375 
376     /**
377      * @dev Returns the account approved for `tokenId` token.
378      *
379      * Requirements:
380      *
381      * - `tokenId` must exist.
382      */
383     function getApproved(uint256 tokenId) external view returns (address operator);
384 
385     /**
386      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
387      *
388      * See {setApprovalForAll}
389      */
390     function isApprovedForAll(address owner, address operator) external view returns (bool);
391 
392     // ==============================
393     //        IERC721Metadata
394     // ==============================
395 
396     /**
397      * @dev Returns the token collection name.
398      */
399     function name() external view returns (string memory);
400 
401     /**
402      * @dev Returns the token collection symbol.
403      */
404     function symbol() external view returns (string memory);
405 
406     /**
407      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
408      */
409     function tokenURI(uint256 tokenId) external view returns (string memory);
410 
411     // ==============================
412     //            IERC2309
413     // ==============================
414 
415     /**
416      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
417      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
418      */
419     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
420 }
421 
422 // File: erc721a/contracts/ERC721A.sol
423 
424 
425 // ERC721A Contracts v4.1.0
426 // Creator: Chiru Labs
427 
428 pragma solidity ^0.8.4;
429 
430 
431 /**
432  * @dev ERC721 token receiver interface.
433  */
434 interface ERC721A__IERC721Receiver {
435     function onERC721Received(
436         address operator,
437         address from,
438         uint256 tokenId,
439         bytes calldata data
440     ) external returns (bytes4);
441 }
442 
443 /**
444  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
445  * including the Metadata extension. Built to optimize for lower gas during batch mints.
446  *
447  * Assumes serials are sequentially minted starting at `_startTokenId()`
448  * (defaults to 0, e.g. 0, 1, 2, 3..).
449  *
450  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
451  *
452  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
453  */
454 contract ERC721A is IERC721A {
455     // Mask of an entry in packed address data.
456     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
457 
458     // The bit position of `numberMinted` in packed address data.
459     uint256 private constant BITPOS_NUMBER_MINTED = 64;
460 
461     // The bit position of `numberBurned` in packed address data.
462     uint256 private constant BITPOS_NUMBER_BURNED = 128;
463 
464     // The bit position of `aux` in packed address data.
465     uint256 private constant BITPOS_AUX = 192;
466 
467     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
468     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
469 
470     // The bit position of `startTimestamp` in packed ownership.
471     uint256 private constant BITPOS_START_TIMESTAMP = 160;
472 
473     // The bit mask of the `burned` bit in packed ownership.
474     uint256 private constant BITMASK_BURNED = 1 << 224;
475 
476     // The bit position of the `nextInitialized` bit in packed ownership.
477     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
478 
479     // The bit mask of the `nextInitialized` bit in packed ownership.
480     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
481 
482     // The bit position of `extraData` in packed ownership.
483     uint256 private constant BITPOS_EXTRA_DATA = 232;
484 
485     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
486     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
487 
488     // The mask of the lower 160 bits for addresses.
489     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
490 
491     // The maximum `quantity` that can be minted with `_mintERC2309`.
492     // This limit is to prevent overflows on the address data entries.
493     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
494     // is required to cause an overflow, which is unrealistic.
495     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
496 
497     // The tokenId of the next token to be minted.
498     uint256 private _currentIndex;
499 
500     // The number of tokens burned.
501     uint256 private _burnCounter;
502 
503     // Token name
504     string private _name;
505 
506     // Token symbol
507     string private _symbol;
508 
509     // Mapping from token ID to ownership details
510     // An empty struct value does not necessarily mean the token is unowned.
511     // See `_packedOwnershipOf` implementation for details.
512     //
513     // Bits Layout:
514     // - [0..159]   `addr`
515     // - [160..223] `startTimestamp`
516     // - [224]      `burned`
517     // - [225]      `nextInitialized`
518     // - [232..255] `extraData`
519     mapping(uint256 => uint256) private _packedOwnerships;
520 
521     // Mapping owner address to address data.
522     //
523     // Bits Layout:
524     // - [0..63]    `balance`
525     // - [64..127]  `numberMinted`
526     // - [128..191] `numberBurned`
527     // - [192..255] `aux`
528     mapping(address => uint256) private _packedAddressData;
529 
530     // Mapping from token ID to approved address.
531     mapping(uint256 => address) private _tokenApprovals;
532 
533     // Mapping from owner to operator approvals
534     mapping(address => mapping(address => bool)) private _operatorApprovals;
535 
536     constructor(string memory name_, string memory symbol_) {
537         _name = name_;
538         _symbol = symbol_;
539         _currentIndex = _startTokenId();
540     }
541 
542     /**
543      * @dev Returns the starting token ID.
544      * To change the starting token ID, please override this function.
545      */
546     function _startTokenId() internal view virtual returns (uint256) {
547         return 0;
548     }
549 
550     /**
551      * @dev Returns the next token ID to be minted.
552      */
553     function _nextTokenId() internal view returns (uint256) {
554         return _currentIndex;
555     }
556 
557     /**
558      * @dev Returns the total number of tokens in existence.
559      * Burned tokens will reduce the count.
560      * To get the total number of tokens minted, please see `_totalMinted`.
561      */
562     function totalSupply() public view override returns (uint256) {
563         // Counter underflow is impossible as _burnCounter cannot be incremented
564         // more than `_currentIndex - _startTokenId()` times.
565         unchecked {
566             return _currentIndex - _burnCounter - _startTokenId();
567         }
568     }
569 
570     /**
571      * @dev Returns the total amount of tokens minted in the contract.
572      */
573     function _totalMinted() internal view returns (uint256) {
574         // Counter underflow is impossible as _currentIndex does not decrement,
575         // and it is initialized to `_startTokenId()`
576         unchecked {
577             return _currentIndex - _startTokenId();
578         }
579     }
580 
581     /**
582      * @dev Returns the total number of tokens burned.
583      */
584     function _totalBurned() internal view returns (uint256) {
585         return _burnCounter;
586     }
587 
588     /**
589      * @dev See {IERC165-supportsInterface}.
590      */
591     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
592         // The interface IDs are constants representing the first 4 bytes of the XOR of
593         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
594         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
595         return
596             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
597             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
598             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
599     }
600 
601     /**
602      * @dev See {IERC721-balanceOf}.
603      */
604     function balanceOf(address owner) public view override returns (uint256) {
605         if (owner == address(0)) revert BalanceQueryForZeroAddress();
606         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
607     }
608 
609     /**
610      * Returns the number of tokens minted by `owner`.
611      */
612     function _numberMinted(address owner) internal view returns (uint256) {
613         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
614     }
615 
616     /**
617      * Returns the number of tokens burned by or on behalf of `owner`.
618      */
619     function _numberBurned(address owner) internal view returns (uint256) {
620         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
621     }
622 
623     /**
624      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
625      */
626     function _getAux(address owner) internal view returns (uint64) {
627         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
628     }
629 
630     /**
631      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
632      * If there are multiple variables, please pack them into a uint64.
633      */
634     function _setAux(address owner, uint64 aux) internal {
635         uint256 packed = _packedAddressData[owner];
636         uint256 auxCasted;
637         // Cast `aux` with assembly to avoid redundant masking.
638         assembly {
639             auxCasted := aux
640         }
641         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
642         _packedAddressData[owner] = packed;
643     }
644 
645     /**
646      * Returns the packed ownership data of `tokenId`.
647      */
648     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
649         uint256 curr = tokenId;
650 
651         unchecked {
652             if (_startTokenId() <= curr)
653                 if (curr < _currentIndex) {
654                     uint256 packed = _packedOwnerships[curr];
655                     // If not burned.
656                     if (packed & BITMASK_BURNED == 0) {
657                         // Invariant:
658                         // There will always be an ownership that has an address and is not burned
659                         // before an ownership that does not have an address and is not burned.
660                         // Hence, curr will not underflow.
661                         //
662                         // We can directly compare the packed value.
663                         // If the address is zero, packed is zero.
664                         while (packed == 0) {
665                             packed = _packedOwnerships[--curr];
666                         }
667                         return packed;
668                     }
669                 }
670         }
671         revert OwnerQueryForNonexistentToken();
672     }
673 
674     /**
675      * Returns the unpacked `TokenOwnership` struct from `packed`.
676      */
677     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
678         ownership.addr = address(uint160(packed));
679         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
680         ownership.burned = packed & BITMASK_BURNED != 0;
681         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
682     }
683 
684     /**
685      * Returns the unpacked `TokenOwnership` struct at `index`.
686      */
687     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
688         return _unpackedOwnership(_packedOwnerships[index]);
689     }
690 
691     /**
692      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
693      */
694     function _initializeOwnershipAt(uint256 index) internal {
695         if (_packedOwnerships[index] == 0) {
696             _packedOwnerships[index] = _packedOwnershipOf(index);
697         }
698     }
699 
700     /**
701      * Gas spent here starts off proportional to the maximum mint batch size.
702      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
703      */
704     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
705         return _unpackedOwnership(_packedOwnershipOf(tokenId));
706     }
707 
708     /**
709      * @dev Packs ownership data into a single uint256.
710      */
711     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
712         assembly {
713             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren"t clean.
714             owner := and(owner, BITMASK_ADDRESS)
715             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
716             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
717         }
718     }
719 
720     /**
721      * @dev See {IERC721-ownerOf}.
722      */
723     function ownerOf(uint256 tokenId) public view override returns (address) {
724         return address(uint160(_packedOwnershipOf(tokenId)));
725     }
726 
727     /**
728      * @dev See {IERC721Metadata-name}.
729      */
730     function name() public view virtual override returns (string memory) {
731         return _name;
732     }
733 
734     /**
735      * @dev See {IERC721Metadata-symbol}.
736      */
737     function symbol() public view virtual override returns (string memory) {
738         return _symbol;
739     }
740 
741     /**
742      * @dev See {IERC721Metadata-tokenURI}.
743      */
744     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
745         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
746 
747         string memory baseURI = _baseURI();
748         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : "";
749     }
750 
751     /**
752      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
753      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
754      * by default, it can be overridden in child contracts.
755      */
756     function _baseURI() internal view virtual returns (string memory) {
757         return "";
758     }
759 
760     /**
761      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
762      */
763     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
764         // For branchless setting of the `nextInitialized` flag.
765         assembly {
766             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
767             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
768         }
769     }
770 
771     /**
772      * @dev See {IERC721-approve}.
773      */
774     function approve(address to, uint256 tokenId) public override {
775         address owner = ownerOf(tokenId);
776 
777         if (_msgSenderERC721A() != owner)
778             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
779                 revert ApprovalCallerNotOwnerNorApproved();
780             }
781 
782         _tokenApprovals[tokenId] = to;
783         emit Approval(owner, to, tokenId);
784     }
785 
786     /**
787      * @dev See {IERC721-getApproved}.
788      */
789     function getApproved(uint256 tokenId) public view override returns (address) {
790         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
791 
792         return _tokenApprovals[tokenId];
793     }
794 
795     /**
796      * @dev See {IERC721-setApprovalForAll}.
797      */
798     function setApprovalForAll(address operator, bool approved) public virtual override {
799         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
800 
801         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
802         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
803     }
804 
805     /**
806      * @dev See {IERC721-isApprovedForAll}.
807      */
808     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
809         return _operatorApprovals[owner][operator];
810     }
811 
812     /**
813      * @dev See {IERC721-safeTransferFrom}.
814      */
815     function safeTransferFrom(
816         address from,
817         address to,
818         uint256 tokenId
819     ) public virtual override {
820         safeTransferFrom(from, to, tokenId, "");
821     }
822 
823     /**
824      * @dev See {IERC721-safeTransferFrom}.
825      */
826     function safeTransferFrom(
827         address from,
828         address to,
829         uint256 tokenId,
830         bytes memory _data
831     ) public virtual override {
832         transferFrom(from, to, tokenId);
833         if (to.code.length != 0)
834             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
835                 revert TransferToNonERC721ReceiverImplementer();
836             }
837     }
838 
839     /**
840      * @dev Returns whether `tokenId` exists.
841      *
842      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
843      *
844      * Tokens start existing when they are minted (`_mint`),
845      */
846     function _exists(uint256 tokenId) internal view returns (bool) {
847         return
848             _startTokenId() <= tokenId &&
849             tokenId < _currentIndex && // If within bounds,
850             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
851     }
852 
853     /**
854      * @dev Equivalent to `_safeMint(to, quantity, "")`.
855      */
856     function _safeMint(address to, uint256 quantity) internal {
857         _safeMint(to, quantity, "");
858     }
859 
860     /**
861      * @dev Safely mints `quantity` tokens and transfers them to `to`.
862      *
863      * Requirements:
864      *
865      * - If `to` refers to a smart contract, it must implement
866      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
867      * - `quantity` must be greater than 0.
868      *
869      * See {_mint}.
870      *
871      * Emits a {Transfer} event for each mint.
872      */
873     function _safeMint(
874         address to,
875         uint256 quantity,
876         bytes memory _data
877     ) internal {
878         _mint(to, quantity);
879 
880         unchecked {
881             if (to.code.length != 0) {
882                 uint256 end = _currentIndex;
883                 uint256 index = end - quantity;
884                 do {
885                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
886                         revert TransferToNonERC721ReceiverImplementer();
887                     }
888                 } while (index < end);
889                 // Reentrancy protection.
890                 if (_currentIndex != end) revert();
891             }
892         }
893     }
894 
895     /**
896      * @dev Mints `quantity` tokens and transfers them to `to`.
897      *
898      * Requirements:
899      *
900      * - `to` cannot be the zero address.
901      * - `quantity` must be greater than 0.
902      *
903      * Emits a {Transfer} event for each mint.
904      */
905     function _mint(address to, uint256 quantity) internal {
906         uint256 startTokenId = _currentIndex;
907         if (to == address(0)) revert MintToZeroAddress();
908         if (quantity == 0) revert MintZeroQuantity();
909 
910         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
911 
912         // Overflows are incredibly unrealistic.
913         // `balance` and `numberMinted` have a maximum limit of 2**64.
914         // `tokenId` has a maximum limit of 2**256.
915         unchecked {
916             // Updates:
917             // - `balance += quantity`.
918             // - `numberMinted += quantity`.
919             //
920             // We can directly add to the `balance` and `numberMinted`.
921             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
922 
923             // Updates:
924             // - `address` to the owner.
925             // - `startTimestamp` to the timestamp of minting.
926             // - `burned` to `false`.
927             // - `nextInitialized` to `quantity == 1`.
928             _packedOwnerships[startTokenId] = _packOwnershipData(
929                 to,
930                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
931             );
932 
933             uint256 tokenId = startTokenId;
934             uint256 end = startTokenId + quantity;
935             do {
936                 emit Transfer(address(0), to, tokenId++);
937             } while (tokenId < end);
938 
939             _currentIndex = end;
940         }
941         _afterTokenTransfers(address(0), to, startTokenId, quantity);
942     }
943 
944     /**
945      * @dev Mints `quantity` tokens and transfers them to `to`.
946      *
947      * This function is intended for efficient minting only during contract creation.
948      *
949      * It emits only one {ConsecutiveTransfer} as defined in
950      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
951      * instead of a sequence of {Transfer} event(s).
952      *
953      * Calling this function outside of contract creation WILL make your contract
954      * non-compliant with the ERC721 standard.
955      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
956      * {ConsecutiveTransfer} event is only permissible during contract creation.
957      *
958      * Requirements:
959      *
960      * - `to` cannot be the zero address.
961      * - `quantity` must be greater than 0.
962      *
963      * Emits a {ConsecutiveTransfer} event.
964      */
965     function _mintERC2309(address to, uint256 quantity) internal {
966         uint256 startTokenId = _currentIndex;
967         if (to == address(0)) revert MintToZeroAddress();
968         if (quantity == 0) revert MintZeroQuantity();
969         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
970 
971         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
972 
973         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
974         unchecked {
975             // Updates:
976             // - `balance += quantity`.
977             // - `numberMinted += quantity`.
978             //
979             // We can directly add to the `balance` and `numberMinted`.
980             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
981 
982             // Updates:
983             // - `address` to the owner.
984             // - `startTimestamp` to the timestamp of minting.
985             // - `burned` to `false`.
986             // - `nextInitialized` to `quantity == 1`.
987             _packedOwnerships[startTokenId] = _packOwnershipData(
988                 to,
989                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
990             );
991 
992             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
993 
994             _currentIndex = startTokenId + quantity;
995         }
996         _afterTokenTransfers(address(0), to, startTokenId, quantity);
997     }
998 
999     /**
1000      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1001      */
1002     function _getApprovedAddress(uint256 tokenId)
1003         private
1004         view
1005         returns (uint256 approvedAddressSlot, address approvedAddress)
1006     {
1007         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1008         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1009         assembly {
1010             // Compute the slot.
1011             mstore(0x00, tokenId)
1012             mstore(0x20, tokenApprovalsPtr.slot)
1013             approvedAddressSlot := keccak256(0x00, 0x40)
1014             // Load the slot"s value from storage.
1015             approvedAddress := sload(approvedAddressSlot)
1016         }
1017     }
1018 
1019     /**
1020      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1021      */
1022     function _isOwnerOrApproved(
1023         address approvedAddress,
1024         address from,
1025         address msgSender
1026     ) private pure returns (bool result) {
1027         assembly {
1028             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren"t clean.
1029             from := and(from, BITMASK_ADDRESS)
1030             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren"t clean.
1031             msgSender := and(msgSender, BITMASK_ADDRESS)
1032             // `msgSender == from || msgSender == approvedAddress`.
1033             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1034         }
1035     }
1036 
1037     /**
1038      * @dev Transfers `tokenId` from `from` to `to`.
1039      *
1040      * Requirements:
1041      *
1042      * - `to` cannot be the zero address.
1043      * - `tokenId` token must be owned by `from`.
1044      *
1045      * Emits a {Transfer} event.
1046      */
1047     function transferFrom(
1048         address from,
1049         address to,
1050         uint256 tokenId
1051     ) public virtual override {
1052         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1053 
1054         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1055 
1056         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1057 
1058         // The nested ifs save around 20+ gas over a compound boolean condition.
1059         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1060             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1061 
1062         if (to == address(0)) revert TransferToZeroAddress();
1063 
1064         _beforeTokenTransfers(from, to, tokenId, 1);
1065 
1066         // Clear approvals from the previous owner.
1067         assembly {
1068             if approvedAddress {
1069                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1070                 sstore(approvedAddressSlot, 0)
1071             }
1072         }
1073 
1074         // Underflow of the sender"s balance is impossible because we check for
1075         // ownership above and the recipient"s balance can"t realistically overflow.
1076         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1077         unchecked {
1078             // We can directly increment and decrement the balances.
1079             --_packedAddressData[from]; // Updates: `balance -= 1`.
1080             ++_packedAddressData[to]; // Updates: `balance += 1`.
1081 
1082             // Updates:
1083             // - `address` to the next owner.
1084             // - `startTimestamp` to the timestamp of transfering.
1085             // - `burned` to `false`.
1086             // - `nextInitialized` to `true`.
1087             _packedOwnerships[tokenId] = _packOwnershipData(
1088                 to,
1089                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1090             );
1091 
1092             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1093             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1094                 uint256 nextTokenId = tokenId + 1;
1095                 // If the next slot"s address is zero and not burned (i.e. packed value is zero).
1096                 if (_packedOwnerships[nextTokenId] == 0) {
1097                     // If the next slot is within bounds.
1098                     if (nextTokenId != _currentIndex) {
1099                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1100                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1101                     }
1102                 }
1103             }
1104         }
1105 
1106         emit Transfer(from, to, tokenId);
1107         _afterTokenTransfers(from, to, tokenId, 1);
1108     }
1109 
1110     /**
1111      * @dev Equivalent to `_burn(tokenId, false)`.
1112      */
1113     function _burn(uint256 tokenId) internal virtual {
1114         _burn(tokenId, false);
1115     }
1116 
1117     /**
1118      * @dev Destroys `tokenId`.
1119      * The approval is cleared when the token is burned.
1120      *
1121      * Requirements:
1122      *
1123      * - `tokenId` must exist.
1124      *
1125      * Emits a {Transfer} event.
1126      */
1127     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1128         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1129 
1130         address from = address(uint160(prevOwnershipPacked));
1131 
1132         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1133 
1134         if (approvalCheck) {
1135             // The nested ifs save around 20+ gas over a compound boolean condition.
1136             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1137                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1138         }
1139 
1140         _beforeTokenTransfers(from, address(0), tokenId, 1);
1141 
1142         // Clear approvals from the previous owner.
1143         assembly {
1144             if approvedAddress {
1145                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1146                 sstore(approvedAddressSlot, 0)
1147             }
1148         }
1149 
1150         // Underflow of the sender"s balance is impossible because we check for
1151         // ownership above and the recipient"s balance can"t realistically overflow.
1152         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1153         unchecked {
1154             // Updates:
1155             // - `balance -= 1`.
1156             // - `numberBurned += 1`.
1157             //
1158             // We can directly decrement the balance, and increment the number burned.
1159             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1160             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1161 
1162             // Updates:
1163             // - `address` to the last owner.
1164             // - `startTimestamp` to the timestamp of burning.
1165             // - `burned` to `true`.
1166             // - `nextInitialized` to `true`.
1167             _packedOwnerships[tokenId] = _packOwnershipData(
1168                 from,
1169                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1170             );
1171 
1172             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1173             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1174                 uint256 nextTokenId = tokenId + 1;
1175                 // If the next slot"s address is zero and not burned (i.e. packed value is zero).
1176                 if (_packedOwnerships[nextTokenId] == 0) {
1177                     // If the next slot is within bounds.
1178                     if (nextTokenId != _currentIndex) {
1179                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1180                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1181                     }
1182                 }
1183             }
1184         }
1185 
1186         emit Transfer(from, address(0), tokenId);
1187         _afterTokenTransfers(from, address(0), tokenId, 1);
1188 
1189         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1190         unchecked {
1191             _burnCounter++;
1192         }
1193     }
1194 
1195     /**
1196      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1197      *
1198      * @param from address representing the previous owner of the given token ID
1199      * @param to target address that will receive the tokens
1200      * @param tokenId uint256 ID of the token to be transferred
1201      * @param _data bytes optional data to send along with the call
1202      * @return bool whether the call correctly returned the expected magic value
1203      */
1204     function _checkContractOnERC721Received(
1205         address from,
1206         address to,
1207         uint256 tokenId,
1208         bytes memory _data
1209     ) private returns (bool) {
1210         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1211             bytes4 retval
1212         ) {
1213             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1214         } catch (bytes memory reason) {
1215             if (reason.length == 0) {
1216                 revert TransferToNonERC721ReceiverImplementer();
1217             } else {
1218                 assembly {
1219                     revert(add(32, reason), mload(reason))
1220                 }
1221             }
1222         }
1223     }
1224 
1225     /**
1226      * @dev Directly sets the extra data for the ownership data `index`.
1227      */
1228     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1229         uint256 packed = _packedOwnerships[index];
1230         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1231         uint256 extraDataCasted;
1232         // Cast `extraData` with assembly to avoid redundant masking.
1233         assembly {
1234             extraDataCasted := extraData
1235         }
1236         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1237         _packedOwnerships[index] = packed;
1238     }
1239 
1240     /**
1241      * @dev Returns the next extra data for the packed ownership data.
1242      * The returned result is shifted into position.
1243      */
1244     function _nextExtraData(
1245         address from,
1246         address to,
1247         uint256 prevOwnershipPacked
1248     ) private view returns (uint256) {
1249         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1250         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1251     }
1252 
1253     /**
1254      * @dev Called during each token transfer to set the 24bit `extraData` field.
1255      * Intended to be overridden by the cosumer contract.
1256      *
1257      * `previousExtraData` - the value of `extraData` before transfer.
1258      *
1259      * Calling conditions:
1260      *
1261      * - When `from` and `to` are both non-zero, `from`"s `tokenId` will be
1262      * transferred to `to`.
1263      * - When `from` is zero, `tokenId` will be minted for `to`.
1264      * - When `to` is zero, `tokenId` will be burned by `from`.
1265      * - `from` and `to` are never both zero.
1266      */
1267     function _extraData(
1268         address from,
1269         address to,
1270         uint24 previousExtraData
1271     ) internal view virtual returns (uint24) {}
1272 
1273     /**
1274      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1275      * This includes minting.
1276      * And also called before burning one token.
1277      *
1278      * startTokenId - the first token id to be transferred
1279      * quantity - the amount to be transferred
1280      *
1281      * Calling conditions:
1282      *
1283      * - When `from` and `to` are both non-zero, `from`"s `tokenId` will be
1284      * transferred to `to`.
1285      * - When `from` is zero, `tokenId` will be minted for `to`.
1286      * - When `to` is zero, `tokenId` will be burned by `from`.
1287      * - `from` and `to` are never both zero.
1288      */
1289     function _beforeTokenTransfers(
1290         address from,
1291         address to,
1292         uint256 startTokenId,
1293         uint256 quantity
1294     ) internal virtual {}
1295 
1296     /**
1297      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1298      * This includes minting.
1299      * And also called after one token has been burned.
1300      *
1301      * startTokenId - the first token id to be transferred
1302      * quantity - the amount to be transferred
1303      *
1304      * Calling conditions:
1305      *
1306      * - When `from` and `to` are both non-zero, `from`"s `tokenId` has been
1307      * transferred to `to`.
1308      * - When `from` is zero, `tokenId` has been minted for `to`.
1309      * - When `to` is zero, `tokenId` has been burned by `from`.
1310      * - `from` and `to` are never both zero.
1311      */
1312     function _afterTokenTransfers(
1313         address from,
1314         address to,
1315         uint256 startTokenId,
1316         uint256 quantity
1317     ) internal virtual {}
1318 
1319     /**
1320      * @dev Returns the message sender (defaults to `msg.sender`).
1321      *
1322      * If you are writing GSN compatible contracts, you need to override this function.
1323      */
1324     function _msgSenderERC721A() internal view virtual returns (address) {
1325         return msg.sender;
1326     }
1327 
1328     /**
1329      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1330      */
1331     function _toString(uint256 value) internal pure returns (string memory ptr) {
1332         assembly {
1333             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1334             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1335             // We will need 1 32-byte word to store the length,
1336             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1337             ptr := add(mload(0x40), 128)
1338             // Update the free memory pointer to allocate.
1339             mstore(0x40, ptr)
1340 
1341             // Cache the end of the memory to calculate the length later.
1342             let end := ptr
1343 
1344             // We write the string from the rightmost digit to the leftmost digit.
1345             // The following is essentially a do-while loop that also handles the zero case.
1346             // Costs a bit more than early returning for the zero case,
1347             // but cheaper in terms of deployment and overall runtime costs.
1348             for {
1349                 // Initialize and perform the first pass without check.
1350                 let temp := value
1351                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1352                 ptr := sub(ptr, 1)
1353                 // Write the character to the pointer. 48 is the ASCII index of "0".
1354                 mstore8(ptr, add(48, mod(temp, 10)))
1355                 temp := div(temp, 10)
1356             } temp {
1357                 // Keep dividing `temp` until zero.
1358                 temp := div(temp, 10)
1359             } {
1360                 // Body of the for loop.
1361                 ptr := sub(ptr, 1)
1362                 mstore8(ptr, add(48, mod(temp, 10)))
1363             }
1364 
1365             let length := sub(end, ptr)
1366             // Move the pointer 32 bytes leftwards to make room for the length.
1367             ptr := sub(ptr, 32)
1368             // Store the length.
1369             mstore(ptr, length)
1370         }
1371     }
1372 }
1373 
1374 
1375 
1376 
1377 pragma solidity ^0.8.0;
1378 
1379 /**
1380  * @dev String operations.
1381  */
1382 library Strings {
1383     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1384 
1385     /**
1386      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1387      */
1388     function toString(uint256 value) internal pure returns (string memory) {
1389         // Inspired by OraclizeAPI"s implementation - MIT licence
1390         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1391 
1392         if (value == 0) {
1393             return "0";
1394         }
1395         uint256 temp = value;
1396         uint256 digits;
1397         while (temp != 0) {
1398             digits++;
1399             temp /= 10;
1400         }
1401         bytes memory buffer = new bytes(digits);
1402         while (value != 0) {
1403             digits -= 1;
1404             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1405             value /= 10;
1406         }
1407         return string(buffer);
1408     }
1409 
1410     /**
1411      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1412      */
1413     function toHexString(uint256 value) internal pure returns (string memory) {
1414         if (value == 0) {
1415             return "0x00";
1416         }
1417         uint256 temp = value;
1418         uint256 length = 0;
1419         while (temp != 0) {
1420             length++;
1421             temp >>= 8;
1422         }
1423         return toHexString(value, length);
1424     }
1425 
1426     /**
1427      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1428      */
1429     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1430         bytes memory buffer = new bytes(2 * length + 2);
1431         buffer[0] = "0";
1432         buffer[1] = "x";
1433         for (uint256 i = 2 * length + 1; i > 1; --i) {
1434             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1435             value >>= 4;
1436         }
1437         require(value == 0, "Strings: hex length insufficient");
1438         return string(buffer);
1439     }
1440 }
1441 
1442 
1443 
1444 
1445 pragma solidity ^0.8.0;
1446 
1447 
1448 
1449 contract Sillie is ERC721A, Ownable {
1450 	using Strings for uint;
1451 
1452     uint public constant MAX_PER_WALLET = 12;
1453 	uint public maxSupply = 5555;
1454 
1455 	bool public isPaused = true;
1456     string private _baseURL = "";
1457 	mapping(address => uint) private _walletMintedCount;
1458     mapping(address => bool) private _whiteList;
1459 	constructor()
1460     // Name
1461 	ERC721A("Sillie", "SIL") {
1462     }
1463 
1464 	function _baseURI() internal view override returns (string memory) {
1465 		return _baseURL;
1466 	}
1467 
1468 	function _startTokenId() internal pure override returns (uint) {
1469 		return 1;
1470 	}
1471 
1472 	function contractURI() public pure returns (string memory) {
1473 		return "";
1474 	}
1475 
1476     function mintedCount(address owner) external view returns (uint) {
1477         return _walletMintedCount[owner];
1478     }
1479 
1480     function setBaseUri(string memory url) external onlyOwner {
1481 	    _baseURL = url;
1482 	}
1483 
1484 	function start(bool paused) external onlyOwner {
1485 	    isPaused = paused;
1486 	}
1487 
1488 	function withdraw() external onlyOwner {
1489 		(bool success, ) = payable(msg.sender).call{
1490             value: address(this).balance
1491         }("");
1492         require(success);
1493 	}
1494 
1495 	function devMint(address to, uint count) external onlyOwner {
1496 		require(
1497 			_totalMinted() + count <= maxSupply,
1498 			"Exceeds max supply"
1499 		);
1500 		_safeMint(to, count);
1501 	}
1502 
1503 	function setMaxSupply(uint newMaxSupply) external onlyOwner {
1504 		maxSupply = newMaxSupply;
1505 	}
1506 
1507     function addWhitelist(address[] calldata wallets) external onlyOwner {
1508 		for(uint i=0;i<wallets.length;i++)
1509             _whiteList[wallets[i]]=true;
1510 	}
1511 
1512 	function tokenURI(uint tokenId)
1513 		public
1514 		view
1515 		override
1516 		returns (string memory)
1517 	{
1518         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1519         return bytes(_baseURI()).length > 0 
1520             ? string(abi.encodePacked(_baseURI(), tokenId.toString(), ".json"))
1521             : "";
1522 	}
1523 
1524 	function mint() external payable {
1525         uint count=MAX_PER_WALLET;
1526 		require(!isPaused, "Sales are off");
1527         require(_totalMinted() + count <= maxSupply,"Exceeds max supply");
1528         require(count <= MAX_PER_WALLET,"Exceeds max per transaction");
1529         require(_walletMintedCount[msg.sender] + count <= MAX_PER_WALLET * 3,"Exceeds max per wallet");
1530         require(_whiteList[msg.sender],"You are not on the whitelist!");
1531 		_walletMintedCount[msg.sender] += count;
1532 		_safeMint(msg.sender, count);
1533 	}
1534 }