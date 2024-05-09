1 /*
2  *                    .:\\|||||||//:.
3  *                   \\.-.\|||||/.-.//
4  *                   ==(   \\|||//   )==
5  *                  ==/\           /\==
6  *                  =//| __     __ |\\=
7  *                   '//| \O\   /O/ |\\`
8  *                   //|\  "   "  /|\\
9  * ________________  /|||\_`-v-'_/|||\   _______________
10  * \_________      `-./|||\._|_./|||\ .-'     _________/
11  *    \________       |/|||\___/|||\|/      ________/
12  *       \_______     | /|||||||||\ |     _______/
13  *          \______   |  //|||||\\  |   ______/
14  *                 `-.|   |/|||\|   |.-'
15  *          .ww.     _|   |     |   |_
16  *        .\WWW=    / |   |     |   | \
17  *        \WWW=    |  |   |     |   |  |
18  *        \WW=     |  |   |     |   |  |
19  *        ( (      |  |   \     /   |  |
20  *         \ \___.-'\  \   \   /   /  /
21  *          `-.__.-(...(...)---(...)...)
22  * 
23  */
24 // File: @openzeppelin/contracts/utils/Context.sol
25 
26 
27 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
28 
29 pragma solidity ^0.8.0;
30 
31 /**
32  * @dev Provides information about the current execution context, including the
33  * sender of the transaction and its data. While these are generally available
34  * via msg.sender and msg.data, they should not be accessed in such a direct
35  * manner, since when dealing with meta-transactions the account sending and
36  * paying for execution may not be the actual sender (as far as an application
37  * is concerned).
38  *
39  * This contract is only required for intermediate, library-like contracts.
40  */
41 abstract contract Context {
42     function _msgSender() internal view virtual returns (address) {
43         return msg.sender;
44     }
45 
46     function _msgData() internal view virtual returns (bytes calldata) {
47         return msg.data;
48     }
49 }
50 
51 // File: @openzeppelin/contracts/access/Ownable.sol
52 
53 
54 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
55 
56 pragma solidity ^0.8.0;
57 
58 
59 /**
60  * @dev Contract module which provides a basic access control mechanism, where
61  * there is an account (an owner) that can be granted exclusive access to
62  * specific functions.
63  *
64  * By default, the owner account will be the one that deploys the contract. This
65  * can later be changed with {transferOwnership}.
66  *
67  * This module is used through inheritance. It will make available the modifier
68  * `onlyOwner`, which can be applied to your functions to restrict their use to
69  * the owner.
70  */
71 abstract contract Ownable is Context {
72     address private _owner;
73 
74     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
75 
76     /**
77      * @dev Initializes the contract setting the deployer as the initial owner.
78      */
79     constructor() {
80         _transferOwnership(_msgSender());
81     }
82 
83     /**
84      * @dev Throws if called by any account other than the owner.
85      */
86     modifier onlyOwner() {
87         _checkOwner();
88         _;
89     }
90 
91     /**
92      * @dev Returns the address of the current owner.
93      */
94     function owner() public view virtual returns (address) {
95         return _owner;
96     }
97 
98     /**
99      * @dev Throws if the sender is not the owner.
100      */
101     function _checkOwner() internal view virtual {
102         require(owner() == _msgSender(), "Ownable: caller is not the owner");
103     }
104 
105     /**
106      * @dev Leaves the contract without owner. It will not be possible to call
107      * `onlyOwner` functions anymore. Can only be called by the current owner.
108      *
109      * NOTE: Renouncing ownership will leave the contract without an owner,
110      * thereby removing any functionality that is only available to the owner.
111      */
112     function renounceOwnership() public virtual onlyOwner {
113         _transferOwnership(address(0));
114     }
115 
116     /**
117      * @dev Transfers ownership of the contract to a new account (`newOwner`).
118      * Can only be called by the current owner.
119      */
120     function transferOwnership(address newOwner) public virtual onlyOwner {
121         require(newOwner != address(0), "Ownable: new owner is the zero address");
122         _transferOwnership(newOwner);
123     }
124 
125     /**
126      * @dev Transfers ownership of the contract to a new account (`newOwner`).
127      * Internal function without access restriction.
128      */
129     function _transferOwnership(address newOwner) internal virtual {
130         address oldOwner = _owner;
131         _owner = newOwner;
132         emit OwnershipTransferred(oldOwner, newOwner);
133     }
134 }
135 
136 // File: erc721a/contracts/IERC721A.sol
137 
138 
139 // ERC721A Contracts v4.2.0
140 // Creator: Chiru Labs
141 
142 pragma solidity ^0.8.4;
143 
144 /**
145  * @dev Interface of ERC721A.
146  */
147 interface IERC721A {
148     /**
149      * The caller must own the token or be an approved operator.
150      */
151     error ApprovalCallerNotOwnerNorApproved();
152 
153     /**
154      * The token does not exist.
155      */
156     error ApprovalQueryForNonexistentToken();
157 
158     /**
159      * The caller cannot approve to their own address.
160      */
161     error ApproveToCaller();
162 
163     /**
164      * Cannot query the balance for the zero address.
165      */
166     error BalanceQueryForZeroAddress();
167 
168     /**
169      * Cannot mint to the zero address.
170      */
171     error MintToZeroAddress();
172 
173     /**
174      * The quantity of tokens minted must be more than zero.
175      */
176     error MintZeroQuantity();
177 
178     /**
179      * The token does not exist.
180      */
181     error OwnerQueryForNonexistentToken();
182 
183     /**
184      * The caller must own the token or be an approved operator.
185      */
186     error TransferCallerNotOwnerNorApproved();
187 
188     /**
189      * The token must be owned by `from`.
190      */
191     error TransferFromIncorrectOwner();
192 
193     /**
194      * Cannot safely transfer to a contract that does not implement the
195      * ERC721Receiver interface.
196      */
197     error TransferToNonERC721ReceiverImplementer();
198 
199     /**
200      * Cannot transfer to the zero address.
201      */
202     error TransferToZeroAddress();
203 
204     /**
205      * The token does not exist.
206      */
207     error URIQueryForNonexistentToken();
208 
209     /**
210      * The `quantity` minted with ERC2309 exceeds the safety limit.
211      */
212     error MintERC2309QuantityExceedsLimit();
213 
214     /**
215      * The `extraData` cannot be set on an unintialized ownership slot.
216      */
217     error OwnershipNotInitializedForExtraData();
218 
219     // =============================================================
220     //                            STRUCTS
221     // =============================================================
222 
223     struct TokenOwnership {
224         // The address of the owner.
225         address addr;
226         // Stores the start time of ownership with minimal overhead for tokenomics.
227         uint64 startTimestamp;
228         // Whether the token has been burned.
229         bool burned;
230         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
231         uint24 extraData;
232     }
233 
234     // =============================================================
235     //                         TOKEN COUNTERS
236     // =============================================================
237 
238     /**
239      * @dev Returns the total number of tokens in existence.
240      * Burned tokens will reduce the count.
241      * To get the total number of tokens minted, please see {_totalMinted}.
242      */
243     function totalSupply() external view returns (uint256);
244 
245     // =============================================================
246     //                            IERC165
247     // =============================================================
248 
249     /**
250      * @dev Returns true if this contract implements the interface defined by
251      * `interfaceId`. See the corresponding
252      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
253      * to learn more about how these ids are created.
254      *
255      * This function call must use less than 30000 gas.
256      */
257     function supportsInterface(bytes4 interfaceId) external view returns (bool);
258 
259     // =============================================================
260     //                            IERC721
261     // =============================================================
262 
263     /**
264      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
265      */
266     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
267 
268     /**
269      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
270      */
271     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
272 
273     /**
274      * @dev Emitted when `owner` enables or disables
275      * (`approved`) `operator` to manage all of its assets.
276      */
277     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
278 
279     /**
280      * @dev Returns the number of tokens in `owner`'s account.
281      */
282     function balanceOf(address owner) external view returns (uint256 balance);
283 
284     /**
285      * @dev Returns the owner of the `tokenId` token.
286      *
287      * Requirements:
288      *
289      * - `tokenId` must exist.
290      */
291     function ownerOf(uint256 tokenId) external view returns (address owner);
292 
293     /**
294      * @dev Safely transfers `tokenId` token from `from` to `to`,
295      * checking first that contract recipients are aware of the ERC721 protocol
296      * to prevent tokens from being forever locked.
297      *
298      * Requirements:
299      *
300      * - `from` cannot be the zero address.
301      * - `to` cannot be the zero address.
302      * - `tokenId` token must exist and be owned by `from`.
303      * - If the caller is not `from`, it must be have been allowed to move
304      * this token by either {approve} or {setApprovalForAll}.
305      * - If `to` refers to a smart contract, it must implement
306      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
307      *
308      * Emits a {Transfer} event.
309      */
310     function safeTransferFrom(
311         address from,
312         address to,
313         uint256 tokenId,
314         bytes calldata data
315     ) external;
316 
317     /**
318      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
319      */
320     function safeTransferFrom(
321         address from,
322         address to,
323         uint256 tokenId
324     ) external;
325 
326     /**
327      * @dev Transfers `tokenId` from `from` to `to`.
328      *
329      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
330      * whenever possible.
331      *
332      * Requirements:
333      *
334      * - `from` cannot be the zero address.
335      * - `to` cannot be the zero address.
336      * - `tokenId` token must be owned by `from`.
337      * - If the caller is not `from`, it must be approved to move this token
338      * by either {approve} or {setApprovalForAll}.
339      *
340      * Emits a {Transfer} event.
341      */
342     function transferFrom(
343         address from,
344         address to,
345         uint256 tokenId
346     ) external;
347 
348     /**
349      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
350      * The approval is cleared when the token is transferred.
351      *
352      * Only a single account can be approved at a time, so approving the
353      * zero address clears previous approvals.
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
366      * Operators can call {transferFrom} or {safeTransferFrom}
367      * for any token owned by the caller.
368      *
369      * Requirements:
370      *
371      * - The `operator` cannot be the caller.
372      *
373      * Emits an {ApprovalForAll} event.
374      */
375     function setApprovalForAll(address operator, bool _approved) external;
376 
377     /**
378      * @dev Returns the account approved for `tokenId` token.
379      *
380      * Requirements:
381      *
382      * - `tokenId` must exist.
383      */
384     function getApproved(uint256 tokenId) external view returns (address operator);
385 
386     /**
387      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
388      *
389      * See {setApprovalForAll}.
390      */
391     function isApprovedForAll(address owner, address operator) external view returns (bool);
392 
393     // =============================================================
394     //                        IERC721Metadata
395     // =============================================================
396 
397     /**
398      * @dev Returns the token collection name.
399      */
400     function name() external view returns (string memory);
401 
402     /**
403      * @dev Returns the token collection symbol.
404      */
405     function symbol() external view returns (string memory);
406 
407     /**
408      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
409      */
410     function tokenURI(uint256 tokenId) external view returns (string memory);
411 
412     // =============================================================
413     //                           IERC2309
414     // =============================================================
415 
416     /**
417      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
418      * (inclusive) is transferred from `from` to `to`, as defined in the
419      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
420      *
421      * See {_mintERC2309} for more details.
422      */
423     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
424 }
425 
426 // File: erc721a/contracts/ERC721A.sol
427 
428 
429 // ERC721A Contracts v4.1.0
430 // Creator: Chiru Labs
431 
432 pragma solidity ^0.8.4;
433 
434 
435 /**
436  * @dev ERC721 token receiver interface.
437  */
438 interface ERC721A__IERC721Receiver {
439     function onERC721Received(
440         address operator,
441         address from,
442         uint256 tokenId,
443         bytes calldata data
444     ) external returns (bytes4);
445 }
446 
447 /**
448  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
449  * including the Metadata extension. Built to optimize for lower gas during batch mints.
450  *
451  * Assumes serials are sequentially minted starting at `_startTokenId()`
452  * (defaults to 0, e.g. 0, 1, 2, 3..).
453  *
454  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
455  *
456  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
457  */
458 contract ERC721A is IERC721A {
459     // Mask of an entry in packed address data.
460     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
461 
462     // The bit position of `numberMinted` in packed address data.
463     uint256 private constant BITPOS_NUMBER_MINTED = 64;
464 
465     // The bit position of `numberBurned` in packed address data.
466     uint256 private constant BITPOS_NUMBER_BURNED = 128;
467 
468     // The bit position of `aux` in packed address data.
469     uint256 private constant BITPOS_AUX = 192;
470 
471     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
472     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
473 
474     // The bit position of `startTimestamp` in packed ownership.
475     uint256 private constant BITPOS_START_TIMESTAMP = 160;
476 
477     // The bit mask of the `burned` bit in packed ownership.
478     uint256 private constant BITMASK_BURNED = 1 << 224;
479 
480     // The bit position of the `nextInitialized` bit in packed ownership.
481     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
482 
483     // The bit mask of the `nextInitialized` bit in packed ownership.
484     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
485 
486     // The bit position of `extraData` in packed ownership.
487     uint256 private constant BITPOS_EXTRA_DATA = 232;
488 
489     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
490     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
491 
492     // The mask of the lower 160 bits for addresses.
493     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
494 
495     // The maximum `quantity` that can be minted with `_mintERC2309`.
496     // This limit is to prevent overflows on the address data entries.
497     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
498     // is required to cause an overflow, which is unrealistic.
499     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
500 
501     // The tokenId of the next token to be minted.
502     uint256 private _currentIndex;
503 
504     // The number of tokens burned.
505     uint256 private _burnCounter;
506 
507     // Token name
508     string private _name;
509 
510     // Token symbol
511     string private _symbol;
512 
513     // Mapping from token ID to ownership details
514     // An empty struct value does not necessarily mean the token is unowned.
515     // See `_packedOwnershipOf` implementation for details.
516     //
517     // Bits Layout:
518     // - [0..159]   `addr`
519     // - [160..223] `startTimestamp`
520     // - [224]      `burned`
521     // - [225]      `nextInitialized`
522     // - [232..255] `extraData`
523     mapping(uint256 => uint256) private _packedOwnerships;
524 
525     // Mapping owner address to address data.
526     //
527     // Bits Layout:
528     // - [0..63]    `balance`
529     // - [64..127]  `numberMinted`
530     // - [128..191] `numberBurned`
531     // - [192..255] `aux`
532     mapping(address => uint256) private _packedAddressData;
533 
534     // Mapping from token ID to approved address.
535     mapping(uint256 => address) private _tokenApprovals;
536 
537     // Mapping from owner to operator approvals
538     mapping(address => mapping(address => bool)) private _operatorApprovals;
539 
540     constructor(string memory name_, string memory symbol_) {
541         _name = name_;
542         _symbol = symbol_;
543         _currentIndex = _startTokenId();
544     }
545 
546     /**
547      * @dev Returns the starting token ID.
548      * To change the starting token ID, please override this function.
549      */
550     function _startTokenId() internal view virtual returns (uint256) {
551         return 0;
552     }
553 
554     /**
555      * @dev Returns the next token ID to be minted.
556      */
557     function _nextTokenId() internal view returns (uint256) {
558         return _currentIndex;
559     }
560 
561     /**
562      * @dev Returns the total number of tokens in existence.
563      * Burned tokens will reduce the count.
564      * To get the total number of tokens minted, please see `_totalMinted`.
565      */
566     function totalSupply() public view override returns (uint256) {
567         // Counter underflow is impossible as _burnCounter cannot be incremented
568         // more than `_currentIndex - _startTokenId()` times.
569         unchecked {
570             return _currentIndex - _burnCounter - _startTokenId();
571         }
572     }
573 
574     /**
575      * @dev Returns the total amount of tokens minted in the contract.
576      */
577     function _totalMinted() internal view returns (uint256) {
578         // Counter underflow is impossible as _currentIndex does not decrement,
579         // and it is initialized to `_startTokenId()`
580         unchecked {
581             return _currentIndex - _startTokenId();
582         }
583     }
584 
585     /**
586      * @dev Returns the total number of tokens burned.
587      */
588     function _totalBurned() internal view returns (uint256) {
589         return _burnCounter;
590     }
591 
592     /**
593      * @dev See {IERC165-supportsInterface}.
594      */
595     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
596         // The interface IDs are constants representing the first 4 bytes of the XOR of
597         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
598         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
599         return
600             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
601             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
602             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
603     }
604 
605     /**
606      * @dev See {IERC721-balanceOf}.
607      */
608     function balanceOf(address owner) public view override returns (uint256) {
609         if (owner == address(0)) revert BalanceQueryForZeroAddress();
610         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
611     }
612 
613     /**
614      * Returns the number of tokens minted by `owner`.
615      */
616     function _numberMinted(address owner) internal view returns (uint256) {
617         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
618     }
619 
620     /**
621      * Returns the number of tokens burned by or on behalf of `owner`.
622      */
623     function _numberBurned(address owner) internal view returns (uint256) {
624         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
625     }
626 
627     /**
628      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
629      */
630     function _getAux(address owner) internal view returns (uint64) {
631         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
632     }
633 
634     /**
635      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
636      * If there are multiple variables, please pack them into a uint64.
637      */
638     function _setAux(address owner, uint64 aux) internal {
639         uint256 packed = _packedAddressData[owner];
640         uint256 auxCasted;
641         // Cast `aux` with assembly to avoid redundant masking.
642         assembly {
643             auxCasted := aux
644         }
645         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
646         _packedAddressData[owner] = packed;
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
660                     if (packed & BITMASK_BURNED == 0) {
661                         // Invariant:
662                         // There will always be an ownership that has an address and is not burned
663                         // before an ownership that does not have an address and is not burned.
664                         // Hence, curr will not underflow.
665                         //
666                         // We can directly compare the packed value.
667                         // If the address is zero, packed is zero.
668                         while (packed == 0) {
669                             packed = _packedOwnerships[--curr];
670                         }
671                         return packed;
672                     }
673                 }
674         }
675         revert OwnerQueryForNonexistentToken();
676     }
677 
678     /**
679      * Returns the unpacked `TokenOwnership` struct from `packed`.
680      */
681     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
682         ownership.addr = address(uint160(packed));
683         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
684         ownership.burned = packed & BITMASK_BURNED != 0;
685         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
686     }
687 
688     /**
689      * Returns the unpacked `TokenOwnership` struct at `index`.
690      */
691     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
692         return _unpackedOwnership(_packedOwnerships[index]);
693     }
694 
695     /**
696      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
697      */
698     function _initializeOwnershipAt(uint256 index) internal {
699         if (_packedOwnerships[index] == 0) {
700             _packedOwnerships[index] = _packedOwnershipOf(index);
701         }
702     }
703 
704     /**
705      * Gas spent here starts off proportional to the maximum mint batch size.
706      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
707      */
708     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
709         return _unpackedOwnership(_packedOwnershipOf(tokenId));
710     }
711 
712     /**
713      * @dev Packs ownership data into a single uint256.
714      */
715     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
716         assembly {
717             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
718             owner := and(owner, BITMASK_ADDRESS)
719             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
720             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
721         }
722     }
723 
724     /**
725      * @dev See {IERC721-ownerOf}.
726      */
727     function ownerOf(uint256 tokenId) public view override returns (address) {
728         return address(uint160(_packedOwnershipOf(tokenId)));
729     }
730 
731     /**
732      * @dev See {IERC721Metadata-name}.
733      */
734     function name() public view virtual override returns (string memory) {
735         return _name;
736     }
737 
738     /**
739      * @dev See {IERC721Metadata-symbol}.
740      */
741     function symbol() public view virtual override returns (string memory) {
742         return _symbol;
743     }
744 
745     /**
746      * @dev See {IERC721Metadata-tokenURI}.
747      */
748     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
749         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
750 
751         string memory baseURI = _baseURI();
752         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
753     }
754 
755     /**
756      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
757      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
758      * by default, it can be overridden in child contracts.
759      */
760     function _baseURI() internal view virtual returns (string memory) {
761         return '';
762     }
763 
764     /**
765      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
766      */
767     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
768         // For branchless setting of the `nextInitialized` flag.
769         assembly {
770             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
771             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
772         }
773     }
774 
775     /**
776      * @dev See {IERC721-approve}.
777      */
778     function approve(address to, uint256 tokenId) public override {
779         address owner = ownerOf(tokenId);
780 
781         if (_msgSenderERC721A() != owner)
782             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
783                 revert ApprovalCallerNotOwnerNorApproved();
784             }
785 
786         _tokenApprovals[tokenId] = to;
787         emit Approval(owner, to, tokenId);
788     }
789 
790     /**
791      * @dev See {IERC721-getApproved}.
792      */
793     function getApproved(uint256 tokenId) public view override returns (address) {
794         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
795 
796         return _tokenApprovals[tokenId];
797     }
798 
799     /**
800      * @dev See {IERC721-setApprovalForAll}.
801      */
802     function setApprovalForAll(address operator, bool approved) public virtual override {
803         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
804 
805         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
806         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
807     }
808 
809     /**
810      * @dev See {IERC721-isApprovedForAll}.
811      */
812     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
813         return _operatorApprovals[owner][operator];
814     }
815 
816     /**
817      * @dev See {IERC721-safeTransferFrom}.
818      */
819     function safeTransferFrom(
820         address from,
821         address to,
822         uint256 tokenId
823     ) public virtual override {
824         safeTransferFrom(from, to, tokenId, '');
825     }
826 
827     /**
828      * @dev See {IERC721-safeTransferFrom}.
829      */
830     function safeTransferFrom(
831         address from,
832         address to,
833         uint256 tokenId,
834         bytes memory _data
835     ) public virtual override {
836         transferFrom(from, to, tokenId);
837         if (to.code.length != 0)
838             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
839                 revert TransferToNonERC721ReceiverImplementer();
840             }
841     }
842 
843     /**
844      * @dev Returns whether `tokenId` exists.
845      *
846      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
847      *
848      * Tokens start existing when they are minted (`_mint`),
849      */
850     function _exists(uint256 tokenId) internal view returns (bool) {
851         return
852             _startTokenId() <= tokenId &&
853             tokenId < _currentIndex && // If within bounds,
854             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
855     }
856 
857     /**
858      * @dev Equivalent to `_safeMint(to, quantity, '')`.
859      */
860     function _safeMint(address to, uint256 quantity) internal {
861         _safeMint(to, quantity, '');
862     }
863 
864     /**
865      * @dev Safely mints `quantity` tokens and transfers them to `to`.
866      *
867      * Requirements:
868      *
869      * - If `to` refers to a smart contract, it must implement
870      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
871      * - `quantity` must be greater than 0.
872      *
873      * See {_mint}.
874      *
875      * Emits a {Transfer} event for each mint.
876      */
877     function _safeMint(
878         address to,
879         uint256 quantity,
880         bytes memory _data
881     ) internal {
882         _mint(to, quantity);
883 
884         unchecked {
885             if (to.code.length != 0) {
886                 uint256 end = _currentIndex;
887                 uint256 index = end - quantity;
888                 do {
889                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
890                         revert TransferToNonERC721ReceiverImplementer();
891                     }
892                 } while (index < end);
893                 // Reentrancy protection.
894                 if (_currentIndex != end) revert();
895             }
896         }
897     }
898 
899     /**
900      * @dev Mints `quantity` tokens and transfers them to `to`.
901      *
902      * Requirements:
903      *
904      * - `to` cannot be the zero address.
905      * - `quantity` must be greater than 0.
906      *
907      * Emits a {Transfer} event for each mint.
908      */
909     function _mint(address to, uint256 quantity) internal {
910         uint256 startTokenId = _currentIndex;
911         if (to == address(0)) revert MintToZeroAddress();
912         if (quantity == 0) revert MintZeroQuantity();
913 
914         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
915 
916         // Overflows are incredibly unrealistic.
917         // `balance` and `numberMinted` have a maximum limit of 2**64.
918         // `tokenId` has a maximum limit of 2**256.
919         unchecked {
920             // Updates:
921             // - `balance += quantity`.
922             // - `numberMinted += quantity`.
923             //
924             // We can directly add to the `balance` and `numberMinted`.
925             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
926 
927             // Updates:
928             // - `address` to the owner.
929             // - `startTimestamp` to the timestamp of minting.
930             // - `burned` to `false`.
931             // - `nextInitialized` to `quantity == 1`.
932             _packedOwnerships[startTokenId] = _packOwnershipData(
933                 to,
934                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
935             );
936 
937             uint256 tokenId = startTokenId;
938             uint256 end = startTokenId + quantity;
939             do {
940                 emit Transfer(address(0), to, tokenId++);
941             } while (tokenId < end);
942 
943             _currentIndex = end;
944         }
945         _afterTokenTransfers(address(0), to, startTokenId, quantity);
946     }
947 
948     /**
949      * @dev Mints `quantity` tokens and transfers them to `to`.
950      *
951      * This function is intended for efficient minting only during contract creation.
952      *
953      * It emits only one {ConsecutiveTransfer} as defined in
954      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
955      * instead of a sequence of {Transfer} event(s).
956      *
957      * Calling this function outside of contract creation WILL make your contract
958      * non-compliant with the ERC721 standard.
959      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
960      * {ConsecutiveTransfer} event is only permissible during contract creation.
961      *
962      * Requirements:
963      *
964      * - `to` cannot be the zero address.
965      * - `quantity` must be greater than 0.
966      *
967      * Emits a {ConsecutiveTransfer} event.
968      */
969     function _mintERC2309(address to, uint256 quantity) internal {
970         uint256 startTokenId = _currentIndex;
971         if (to == address(0)) revert MintToZeroAddress();
972         if (quantity == 0) revert MintZeroQuantity();
973         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
974 
975         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
976 
977         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
978         unchecked {
979             // Updates:
980             // - `balance += quantity`.
981             // - `numberMinted += quantity`.
982             //
983             // We can directly add to the `balance` and `numberMinted`.
984             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
985 
986             // Updates:
987             // - `address` to the owner.
988             // - `startTimestamp` to the timestamp of minting.
989             // - `burned` to `false`.
990             // - `nextInitialized` to `quantity == 1`.
991             _packedOwnerships[startTokenId] = _packOwnershipData(
992                 to,
993                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
994             );
995 
996             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
997 
998             _currentIndex = startTokenId + quantity;
999         }
1000         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1001     }
1002 
1003     /**
1004      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1005      */
1006     function _getApprovedAddress(uint256 tokenId)
1007         private
1008         view
1009         returns (uint256 approvedAddressSlot, address approvedAddress)
1010     {
1011         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1012         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1013         assembly {
1014             // Compute the slot.
1015             mstore(0x00, tokenId)
1016             mstore(0x20, tokenApprovalsPtr.slot)
1017             approvedAddressSlot := keccak256(0x00, 0x40)
1018             // Load the slot's value from storage.
1019             approvedAddress := sload(approvedAddressSlot)
1020         }
1021     }
1022 
1023     /**
1024      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1025      */
1026     function _isOwnerOrApproved(
1027         address approvedAddress,
1028         address from,
1029         address msgSender
1030     ) private pure returns (bool result) {
1031         assembly {
1032             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1033             from := and(from, BITMASK_ADDRESS)
1034             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1035             msgSender := and(msgSender, BITMASK_ADDRESS)
1036             // `msgSender == from || msgSender == approvedAddress`.
1037             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1038         }
1039     }
1040 
1041     /**
1042      * @dev Transfers `tokenId` from `from` to `to`.
1043      *
1044      * Requirements:
1045      *
1046      * - `to` cannot be the zero address.
1047      * - `tokenId` token must be owned by `from`.
1048      *
1049      * Emits a {Transfer} event.
1050      */
1051     function transferFrom(
1052         address from,
1053         address to,
1054         uint256 tokenId
1055     ) public virtual override {
1056         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1057 
1058         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1059 
1060         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1061 
1062         // The nested ifs save around 20+ gas over a compound boolean condition.
1063         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1064             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1065 
1066         if (to == address(0)) revert TransferToZeroAddress();
1067 
1068         _beforeTokenTransfers(from, to, tokenId, 1);
1069 
1070         // Clear approvals from the previous owner.
1071         assembly {
1072             if approvedAddress {
1073                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1074                 sstore(approvedAddressSlot, 0)
1075             }
1076         }
1077 
1078         // Underflow of the sender's balance is impossible because we check for
1079         // ownership above and the recipient's balance can't realistically overflow.
1080         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1081         unchecked {
1082             // We can directly increment and decrement the balances.
1083             --_packedAddressData[from]; // Updates: `balance -= 1`.
1084             ++_packedAddressData[to]; // Updates: `balance += 1`.
1085 
1086             // Updates:
1087             // - `address` to the next owner.
1088             // - `startTimestamp` to the timestamp of transfering.
1089             // - `burned` to `false`.
1090             // - `nextInitialized` to `true`.
1091             _packedOwnerships[tokenId] = _packOwnershipData(
1092                 to,
1093                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1094             );
1095 
1096             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1097             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1098                 uint256 nextTokenId = tokenId + 1;
1099                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1100                 if (_packedOwnerships[nextTokenId] == 0) {
1101                     // If the next slot is within bounds.
1102                     if (nextTokenId != _currentIndex) {
1103                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1104                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1105                     }
1106                 }
1107             }
1108         }
1109 
1110         emit Transfer(from, to, tokenId);
1111         _afterTokenTransfers(from, to, tokenId, 1);
1112     }
1113 
1114     /**
1115      * @dev Equivalent to `_burn(tokenId, false)`.
1116      */
1117     function _burn(uint256 tokenId) internal virtual {
1118         _burn(tokenId, false);
1119     }
1120 
1121     /**
1122      * @dev Destroys `tokenId`.
1123      * The approval is cleared when the token is burned.
1124      *
1125      * Requirements:
1126      *
1127      * - `tokenId` must exist.
1128      *
1129      * Emits a {Transfer} event.
1130      */
1131     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1132         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1133 
1134         address from = address(uint160(prevOwnershipPacked));
1135 
1136         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1137 
1138         if (approvalCheck) {
1139             // The nested ifs save around 20+ gas over a compound boolean condition.
1140             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1141                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1142         }
1143 
1144         _beforeTokenTransfers(from, address(0), tokenId, 1);
1145 
1146         // Clear approvals from the previous owner.
1147         assembly {
1148             if approvedAddress {
1149                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1150                 sstore(approvedAddressSlot, 0)
1151             }
1152         }
1153 
1154         // Underflow of the sender's balance is impossible because we check for
1155         // ownership above and the recipient's balance can't realistically overflow.
1156         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1157         unchecked {
1158             // Updates:
1159             // - `balance -= 1`.
1160             // - `numberBurned += 1`.
1161             //
1162             // We can directly decrement the balance, and increment the number burned.
1163             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1164             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1165 
1166             // Updates:
1167             // - `address` to the last owner.
1168             // - `startTimestamp` to the timestamp of burning.
1169             // - `burned` to `true`.
1170             // - `nextInitialized` to `true`.
1171             _packedOwnerships[tokenId] = _packOwnershipData(
1172                 from,
1173                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1174             );
1175 
1176             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1177             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1178                 uint256 nextTokenId = tokenId + 1;
1179                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1180                 if (_packedOwnerships[nextTokenId] == 0) {
1181                     // If the next slot is within bounds.
1182                     if (nextTokenId != _currentIndex) {
1183                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1184                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1185                     }
1186                 }
1187             }
1188         }
1189 
1190         emit Transfer(from, address(0), tokenId);
1191         _afterTokenTransfers(from, address(0), tokenId, 1);
1192 
1193         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1194         unchecked {
1195             _burnCounter++;
1196         }
1197     }
1198 
1199     /**
1200      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1201      *
1202      * @param from address representing the previous owner of the given token ID
1203      * @param to target address that will receive the tokens
1204      * @param tokenId uint256 ID of the token to be transferred
1205      * @param _data bytes optional data to send along with the call
1206      * @return bool whether the call correctly returned the expected magic value
1207      */
1208     function _checkContractOnERC721Received(
1209         address from,
1210         address to,
1211         uint256 tokenId,
1212         bytes memory _data
1213     ) private returns (bool) {
1214         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1215             bytes4 retval
1216         ) {
1217             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1218         } catch (bytes memory reason) {
1219             if (reason.length == 0) {
1220                 revert TransferToNonERC721ReceiverImplementer();
1221             } else {
1222                 assembly {
1223                     revert(add(32, reason), mload(reason))
1224                 }
1225             }
1226         }
1227     }
1228 
1229     /**
1230      * @dev Directly sets the extra data for the ownership data `index`.
1231      */
1232     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1233         uint256 packed = _packedOwnerships[index];
1234         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1235         uint256 extraDataCasted;
1236         // Cast `extraData` with assembly to avoid redundant masking.
1237         assembly {
1238             extraDataCasted := extraData
1239         }
1240         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1241         _packedOwnerships[index] = packed;
1242     }
1243 
1244     /**
1245      * @dev Returns the next extra data for the packed ownership data.
1246      * The returned result is shifted into position.
1247      */
1248     function _nextExtraData(
1249         address from,
1250         address to,
1251         uint256 prevOwnershipPacked
1252     ) private view returns (uint256) {
1253         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1254         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1255     }
1256 
1257     /**
1258      * @dev Called during each token transfer to set the 24bit `extraData` field.
1259      * Intended to be overridden by the cosumer contract.
1260      *
1261      * `previousExtraData` - the value of `extraData` before transfer.
1262      *
1263      * Calling conditions:
1264      *
1265      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1266      * transferred to `to`.
1267      * - When `from` is zero, `tokenId` will be minted for `to`.
1268      * - When `to` is zero, `tokenId` will be burned by `from`.
1269      * - `from` and `to` are never both zero.
1270      */
1271     function _extraData(
1272         address from,
1273         address to,
1274         uint24 previousExtraData
1275     ) internal view virtual returns (uint24) {}
1276 
1277     /**
1278      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1279      * This includes minting.
1280      * And also called before burning one token.
1281      *
1282      * startTokenId - the first token id to be transferred
1283      * quantity - the amount to be transferred
1284      *
1285      * Calling conditions:
1286      *
1287      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1288      * transferred to `to`.
1289      * - When `from` is zero, `tokenId` will be minted for `to`.
1290      * - When `to` is zero, `tokenId` will be burned by `from`.
1291      * - `from` and `to` are never both zero.
1292      */
1293     function _beforeTokenTransfers(
1294         address from,
1295         address to,
1296         uint256 startTokenId,
1297         uint256 quantity
1298     ) internal virtual {}
1299 
1300     /**
1301      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1302      * This includes minting.
1303      * And also called after one token has been burned.
1304      *
1305      * startTokenId - the first token id to be transferred
1306      * quantity - the amount to be transferred
1307      *
1308      * Calling conditions:
1309      *
1310      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1311      * transferred to `to`.
1312      * - When `from` is zero, `tokenId` has been minted for `to`.
1313      * - When `to` is zero, `tokenId` has been burned by `from`.
1314      * - `from` and `to` are never both zero.
1315      */
1316     function _afterTokenTransfers(
1317         address from,
1318         address to,
1319         uint256 startTokenId,
1320         uint256 quantity
1321     ) internal virtual {}
1322 
1323     /**
1324      * @dev Returns the message sender (defaults to `msg.sender`).
1325      *
1326      * If you are writing GSN compatible contracts, you need to override this function.
1327      */
1328     function _msgSenderERC721A() internal view virtual returns (address) {
1329         return msg.sender;
1330     }
1331 
1332     /**
1333      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1334      */
1335     function _toString(uint256 value) internal pure returns (string memory ptr) {
1336         assembly {
1337             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1338             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1339             // We will need 1 32-byte word to store the length,
1340             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1341             ptr := add(mload(0x40), 128)
1342             // Update the free memory pointer to allocate.
1343             mstore(0x40, ptr)
1344 
1345             // Cache the end of the memory to calculate the length later.
1346             let end := ptr
1347 
1348             // We write the string from the rightmost digit to the leftmost digit.
1349             // The following is essentially a do-while loop that also handles the zero case.
1350             // Costs a bit more than early returning for the zero case,
1351             // but cheaper in terms of deployment and overall runtime costs.
1352             for {
1353                 // Initialize and perform the first pass without check.
1354                 let temp := value
1355                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1356                 ptr := sub(ptr, 1)
1357                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1358                 mstore8(ptr, add(48, mod(temp, 10)))
1359                 temp := div(temp, 10)
1360             } temp {
1361                 // Keep dividing `temp` until zero.
1362                 temp := div(temp, 10)
1363             } {
1364                 // Body of the for loop.
1365                 ptr := sub(ptr, 1)
1366                 mstore8(ptr, add(48, mod(temp, 10)))
1367             }
1368 
1369             let length := sub(end, ptr)
1370             // Move the pointer 32 bytes leftwards to make room for the length.
1371             ptr := sub(ptr, 32)
1372             // Store the length.
1373             mstore(ptr, length)
1374         }
1375     }
1376 }
1377 
1378 // File: BoredLionYatchClub.sol
1379 
1380 
1381 
1382 pragma solidity ^0.8.4;
1383 
1384 
1385 
1386 contract BoredLionYatchClub is ERC721A, Ownable {
1387   uint256 constant EXTRA_MINT_PRICE = 0.001 ether;
1388   uint256 constant MAX_SUPPLY_PLUS_ONE = 7777;
1389   uint256 constant MAX_PER_TRANSACTION_PLUS_ONE = 10;
1390 
1391   string tokenBaseUri = "ipfs://bafybeidwh3lpt6thzs3qrwzqr45fqdor6oupeuzcg4zyfjixy62ajilny4/";
1392 
1393   bool public paused = true;
1394 
1395   mapping(address => uint256) private _freeMintedCount;
1396 
1397   constructor() ERC721A("Bored Lion Yatch Club ", "BLYC") {}
1398 
1399   function mint(uint256 _quantity) external payable {
1400     require(!paused, "Minting paused");
1401 
1402     uint256 _totalSupply = totalSupply();
1403 
1404     require(_totalSupply + _quantity < MAX_SUPPLY_PLUS_ONE, "Exceeds supply");
1405     require(_quantity < MAX_PER_TRANSACTION_PLUS_ONE, "Exceeds max per tx");
1406 
1407     uint256 payForCount = _quantity;
1408     uint256 freeMintCount = _freeMintedCount[msg.sender];
1409 
1410     if (freeMintCount < 2) {
1411       if (_quantity > 2) {
1412         payForCount = _quantity - 2;
1413       } else {
1414         payForCount = 0;
1415       }
1416 
1417       _freeMintedCount[msg.sender] = 2;
1418     }
1419 
1420     require(msg.value >= payForCount * EXTRA_MINT_PRICE, "ETH sent not correct");
1421 
1422     _mint(msg.sender, _quantity);
1423   }
1424 
1425   function freeMintedCount(address owner) external view returns (uint256) {
1426     return _freeMintedCount[owner];
1427   }
1428 
1429   function _startTokenId() internal pure override returns (uint256) {
1430     return 1;
1431   }
1432 
1433   function _baseURI() internal view override returns (string memory) {
1434     return tokenBaseUri;
1435   }
1436 
1437   function setBaseURI(string calldata _newBaseUri) external onlyOwner {
1438     tokenBaseUri = _newBaseUri;
1439   }
1440 
1441   function flipSale() external onlyOwner {
1442     paused = !paused;
1443   }
1444 
1445   function collectReserves() external onlyOwner {
1446     _mint(msg.sender, 100);
1447   }
1448 
1449   function withdraw() external onlyOwner {
1450     require(
1451       payable(owner()).send(address(this).balance),
1452       "Withdraw unsuccessful"
1453     );
1454   }
1455 }