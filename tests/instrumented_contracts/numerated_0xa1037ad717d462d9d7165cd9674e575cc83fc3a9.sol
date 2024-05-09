1 /**
2  *Submitted for verification at Etherscan.io on 2022-08-25
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2022-08-25
7 */
8 
9 /**
10  *Submitted for verification at Etherscan.io on 2022-08-23
11 */
12 
13 /**
14  *Submitted for verification at Etherscan.io on 2022-08-02
15 */
16 
17 /**
18  *Submitted for verification at Etherscan.io on 2022-07-20
19 */
20 
21 // SPDX-License-Identifier: MIT
22 // File: @openzeppelin/contracts/utils/Context.sol
23 
24 
25 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
26 
27 pragma solidity ^0.8.0;
28 
29 /**
30  * @dev Provides information about the current execution context, including the
31  * sender of the transaction and its data. While these are generally available
32  * via msg.sender and msg.data, they should not be accessed in such a direct
33  * manner, since when dealing with meta-transactions the account sending and
34  * paying for execution may not be the actual sender (as far as an application
35  * is concerned).
36  *
37  * This contract is only required for intermediate, library-like contracts.
38  */
39 abstract contract Context {
40     function _msgSender() internal view virtual returns (address) {
41         return msg.sender;
42     }
43 
44     function _msgData() internal view virtual returns (bytes calldata) {
45         return msg.data;
46     }
47 }
48 
49 // File: @openzeppelin/contracts/access/Ownable.sol
50 
51 
52 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
53 
54 pragma solidity ^0.8.0;
55 
56 
57 /**
58  * @dev Contract module which provides a basic access control mechanism, where
59  * there is an account (an owner) that can be granted exclusive access to
60  * specific functions.
61  *
62  * By default, the owner account will be the one that deploys the contract. This
63  * can later be changed with {transferOwnership}.
64  *
65  * This module is used through inheritance. It will make available the modifier
66  * `onlyOwner`, which can be applied to your functions to restrict their use to
67  * the owner.
68  */
69 abstract contract Ownable is Context {
70     address private _owner;
71 
72     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
73 
74     /**
75      * @dev Initializes the contract setting the deployer as the initial owner.
76      */
77     constructor() {
78         _transferOwnership(_msgSender());
79     }
80 
81     /**
82      * @dev Throws if called by any account other than the owner.
83      */
84     modifier onlyOwner() {
85         _checkOwner();
86         _;
87     }
88 
89     /**
90      * @dev Returns the address of the current owner.
91      */
92     function owner() public view virtual returns (address) {
93         return _owner;
94     }
95 
96     /**
97      * @dev Throws if the sender is not the owner.
98      */
99     function _checkOwner() internal view virtual {
100         require(owner() == _msgSender(), "Ownable: caller is not the owner");
101     }
102 
103     /**
104      * @dev Leaves the contract without owner. It will not be possible to call
105      * `onlyOwner` functions anymore. Can only be called by the current owner.
106      *
107      * NOTE: Renouncing ownership will leave the contract without an owner,
108      * thereby removing any functionality that is only available to the owner.
109      */
110     function renounceOwnership() public virtual onlyOwner {
111         _transferOwnership(address(0));
112     }
113 
114     /**
115      * @dev Transfers ownership of the contract to a new account (`newOwner`).
116      * Can only be called by the current owner.
117      */
118     function transferOwnership(address newOwner) public virtual onlyOwner {
119         require(newOwner != address(0), "Ownable: new owner is the zero address");
120         _transferOwnership(newOwner);
121     }
122 
123     /**
124      * @dev Transfers ownership of the contract to a new account (`newOwner`).
125      * Internal function without access restriction.
126      */
127     function _transferOwnership(address newOwner) internal virtual {
128         address oldOwner = _owner;
129         _owner = newOwner;
130         emit OwnershipTransferred(oldOwner, newOwner);
131     }
132 }
133 
134 // File: erc721a/contracts/IERC721A.sol
135 
136 
137 // ERC721A Contracts v4.1.0
138 // Creator: Chiru Labs
139 
140 pragma solidity ^0.8.4;
141 
142 /**
143  * @dev Interface of an ERC721A compliant contract.
144  */
145 interface IERC721A {
146     /**
147      * The caller must own the token or be an approved operator.
148      */
149     error ApprovalCallerNotOwnerNorApproved();
150 
151     /**
152      * The token does not exist.
153      */
154     error ApprovalQueryForNonexistentToken();
155 
156     /**
157      * The caller cannot approve to their own address.
158      */
159     error ApproveToCaller();
160 
161     /**
162      * Cannot query the balance for the zero address.
163      */
164     error BalanceQueryForZeroAddress();
165 
166     /**
167      * Cannot mint to the zero address.
168      */
169     error MintToZeroAddress();
170 
171     /**
172      * The quantity of tokens minted must be more than zero.
173      */
174     error MintZeroQuantity();
175 
176     /**
177      * The token does not exist.
178      */
179     error OwnerQueryForNonexistentToken();
180 
181     /**
182      * The caller must own the token or be an approved operator.
183      */
184     error TransferCallerNotOwnerNorApproved();
185 
186     /**
187      * The token must be owned by `from`.
188      */
189     error TransferFromIncorrectOwner();
190 
191     /**
192      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
193      */
194     error TransferToNonERC721ReceiverImplementer();
195 
196     /**
197      * Cannot transfer to the zero address.
198      */
199     error TransferToZeroAddress();
200 
201     /**
202      * The token does not exist.
203      */
204     error URIQueryForNonexistentToken();
205 
206     /**
207      * The `quantity` minted with ERC2309 exceeds the safety limit.
208      */
209     error MintERC2309QuantityExceedsLimit();
210 
211     /**
212      * The `extraData` cannot be set on an unintialized ownership slot.
213      */
214     error OwnershipNotInitializedForExtraData();
215 
216     struct TokenOwnership {
217         // The address of the owner.
218         address addr;
219         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
220         uint64 startTimestamp;
221         // Whether the token has been burned.
222         bool burned;
223         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
224         uint24 extraData;
225     }
226 
227     /**
228      * @dev Returns the total amount of tokens stored by the contract.
229      *
230      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
231      */
232     function totalSupply() external view returns (uint256);
233 
234     // ==============================
235     //            IERC165
236     // ==============================
237 
238     /**
239      * @dev Returns true if this contract implements the interface defined by
240      * `interfaceId`. See the corresponding
241      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
242      * to learn more about how these ids are created.
243      *
244      * This function call must use less than 30 000 gas.
245      */
246     function supportsInterface(bytes4 interfaceId) external view returns (bool);
247 
248     // ==============================
249     //            IERC721
250     // ==============================
251 
252     /**
253      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
254      */
255     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
256 
257     /**
258      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
259      */
260     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
261 
262     /**
263      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
264      */
265     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
266 
267     /**
268      * @dev Returns the number of tokens in ``owner``"s account.
269      */
270     function balanceOf(address owner) external view returns (uint256 balance);
271 
272     /**
273      * @dev Returns the owner of the `tokenId` token.
274      *
275      * Requirements:
276      *
277      * - `tokenId` must exist.
278      */
279     function ownerOf(uint256 tokenId) external view returns (address owner);
280 
281     /**
282      * @dev Safely transfers `tokenId` token from `from` to `to`.
283      *
284      * Requirements:
285      *
286      * - `from` cannot be the zero address.
287      * - `to` cannot be the zero address.
288      * - `tokenId` token must exist and be owned by `from`.
289      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
290      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
291      *
292      * Emits a {Transfer} event.
293      */
294     function safeTransferFrom(
295         address from,
296         address to,
297         uint256 tokenId,
298         bytes calldata data
299     ) external;
300 
301     /**
302      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
303      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
304      *
305      * Requirements:
306      *
307      * - `from` cannot be the zero address.
308      * - `to` cannot be the zero address.
309      * - `tokenId` token must exist and be owned by `from`.
310      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
311      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
312      *
313      * Emits a {Transfer} event.
314      */
315     function safeTransferFrom(
316         address from,
317         address to,
318         uint256 tokenId
319     ) external;
320 
321     /**
322      * @dev Transfers `tokenId` token from `from` to `to`.
323      *
324      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
325      *
326      * Requirements:
327      *
328      * - `from` cannot be the zero address.
329      * - `to` cannot be the zero address.
330      * - `tokenId` token must be owned by `from`.
331      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
332      *
333      * Emits a {Transfer} event.
334      */
335     function transferFrom(
336         address from,
337         address to,
338         uint256 tokenId
339     ) external;
340 
341     /**
342      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
343      * The approval is cleared when the token is transferred.
344      *
345      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
346      *
347      * Requirements:
348      *
349      * - The caller must own the token or be an approved operator.
350      * - `tokenId` must exist.
351      *
352      * Emits an {Approval} event.
353      */
354     function approve(address to, uint256 tokenId) external;
355 
356     /**
357      * @dev Approve or remove `operator` as an operator for the caller.
358      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
359      *
360      * Requirements:
361      *
362      * - The `operator` cannot be the caller.
363      *
364      * Emits an {ApprovalForAll} event.
365      */
366     function setApprovalForAll(address operator, bool _approved) external;
367 
368     /**
369      * @dev Returns the account approved for `tokenId` token.
370      *
371      * Requirements:
372      *
373      * - `tokenId` must exist.
374      */
375     function getApproved(uint256 tokenId) external view returns (address operator);
376 
377     /**
378      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
379      *
380      * See {setApprovalForAll}
381      */
382     function isApprovedForAll(address owner, address operator) external view returns (bool);
383 
384     // ==============================
385     //        IERC721Metadata
386     // ==============================
387 
388     /**
389      * @dev Returns the token collection name.
390      */
391     function name() external view returns (string memory);
392 
393     /**
394      * @dev Returns the token collection symbol.
395      */
396     function symbol() external view returns (string memory);
397 
398     /**
399      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
400      */
401     function tokenURI(uint256 tokenId) external view returns (string memory);
402 
403     // ==============================
404     //            IERC2309
405     // ==============================
406 
407     /**
408      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
409      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
410      */
411     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
412 }
413 
414 // File: erc721a/contracts/ERC721A.sol
415 
416 
417 // ERC721A Contracts v4.1.0
418 // Creator: Chiru Labs
419 
420 pragma solidity ^0.8.4;
421 
422 
423 /**
424  * @dev ERC721 token receiver interface.
425  */
426 interface ERC721A__IERC721Receiver {
427     function onERC721Received(
428         address operator,
429         address from,
430         uint256 tokenId,
431         bytes calldata data
432     ) external returns (bytes4);
433 }
434 
435 /**
436  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
437  * including the Metadata extension. Built to optimize for lower gas during batch mints.
438  *
439  * Assumes serials are sequentially minted starting at `_startTokenId()`
440  * (defaults to 0, e.g. 0, 1, 2, 3..).
441  *
442  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
443  *
444  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
445  */
446 contract ERC721A is IERC721A {
447     // Mask of an entry in packed address data.
448     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
449 
450     // The bit position of `numberMinted` in packed address data.
451     uint256 private constant BITPOS_NUMBER_MINTED = 64;
452 
453     // The bit position of `numberBurned` in packed address data.
454     uint256 private constant BITPOS_NUMBER_BURNED = 128;
455 
456     // The bit position of `aux` in packed address data.
457     uint256 private constant BITPOS_AUX = 192;
458 
459     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
460     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
461 
462     // The bit position of `startTimestamp` in packed ownership.
463     uint256 private constant BITPOS_START_TIMESTAMP = 160;
464 
465     // The bit mask of the `burned` bit in packed ownership.
466     uint256 private constant BITMASK_BURNED = 1 << 224;
467 
468     // The bit position of the `nextInitialized` bit in packed ownership.
469     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
470 
471     // The bit mask of the `nextInitialized` bit in packed ownership.
472     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
473 
474     // The bit position of `extraData` in packed ownership.
475     uint256 private constant BITPOS_EXTRA_DATA = 232;
476 
477     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
478     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
479 
480     // The mask of the lower 160 bits for addresses.
481     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
482 
483     // The maximum `quantity` that can be minted with `_mintERC2309`.
484     // This limit is to prevent overflows on the address data entries.
485     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
486     // is required to cause an overflow, which is unrealistic.
487     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
488 
489     // The tokenId of the next token to be minted.
490     uint256 private _currentIndex;
491 
492     // The number of tokens burned.
493     uint256 private _burnCounter;
494 
495     // Token name
496     string private _name;
497 
498     // Token symbol
499     string private _symbol;
500 
501     // Mapping from token ID to ownership details
502     // An empty struct value does not necessarily mean the token is unowned.
503     // See `_packedOwnershipOf` implementation for details.
504     //
505     // Bits Layout:
506     // - [0..159]   `addr`
507     // - [160..223] `startTimestamp`
508     // - [224]      `burned`
509     // - [225]      `nextInitialized`
510     // - [232..255] `extraData`
511     mapping(uint256 => uint256) private _packedOwnerships;
512 
513     // Mapping owner address to address data.
514     //
515     // Bits Layout:
516     // - [0..63]    `balance`
517     // - [64..127]  `numberMinted`
518     // - [128..191] `numberBurned`
519     // - [192..255] `aux`
520     mapping(address => uint256) private _packedAddressData;
521 
522     // Mapping from token ID to approved address.
523     mapping(uint256 => address) private _tokenApprovals;
524 
525     // Mapping from owner to operator approvals
526     mapping(address => mapping(address => bool)) private _operatorApprovals;
527 
528     constructor(string memory name_, string memory symbol_) {
529         _name = name_;
530         _symbol = symbol_;
531         _currentIndex = _startTokenId();
532     }
533 
534     /**
535      * @dev Returns the starting token ID.
536      * To change the starting token ID, please override this function.
537      */
538     function _startTokenId() internal view virtual returns (uint256) {
539         return 0;
540     }
541 
542     /**
543      * @dev Returns the next token ID to be minted.
544      */
545     function _nextTokenId() internal view returns (uint256) {
546         return _currentIndex;
547     }
548 
549     /**
550      * @dev Returns the total number of tokens in existence.
551      * Burned tokens will reduce the count.
552      * To get the total number of tokens minted, please see `_totalMinted`.
553      */
554     function totalSupply() public view override returns (uint256) {
555         // Counter underflow is impossible as _burnCounter cannot be incremented
556         // more than `_currentIndex - _startTokenId()` times.
557         unchecked {
558             return _currentIndex - _burnCounter - _startTokenId();
559         }
560     }
561 
562     /**
563      * @dev Returns the total amount of tokens minted in the contract.
564      */
565     function _totalMinted() internal view returns (uint256) {
566         // Counter underflow is impossible as _currentIndex does not decrement,
567         // and it is initialized to `_startTokenId()`
568         unchecked {
569             return _currentIndex - _startTokenId();
570         }
571     }
572 
573     /**
574      * @dev Returns the total number of tokens burned.
575      */
576     function _totalBurned() internal view returns (uint256) {
577         return _burnCounter;
578     }
579 
580     /**
581      * @dev See {IERC165-supportsInterface}.
582      */
583     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
584         // The interface IDs are constants representing the first 4 bytes of the XOR of
585         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
586         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
587         return
588             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
589             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
590             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
591     }
592 
593     /**
594      * @dev See {IERC721-balanceOf}.
595      */
596     function balanceOf(address owner) public view override returns (uint256) {
597         if (owner == address(0)) revert BalanceQueryForZeroAddress();
598         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
599     }
600 
601     /**
602      * Returns the number of tokens minted by `owner`.
603      */
604     function _numberMinted(address owner) internal view returns (uint256) {
605         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
606     }
607 
608     /**
609      * Returns the number of tokens burned by or on behalf of `owner`.
610      */
611     function _numberBurned(address owner) internal view returns (uint256) {
612         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
613     }
614 
615     /**
616      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
617      */
618     function _getAux(address owner) internal view returns (uint64) {
619         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
620     }
621 
622     /**
623      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
624      * If there are multiple variables, please pack them into a uint64.
625      */
626     function _setAux(address owner, uint64 aux) internal {
627         uint256 packed = _packedAddressData[owner];
628         uint256 auxCasted;
629         // Cast `aux` with assembly to avoid redundant masking.
630         assembly {
631             auxCasted := aux
632         }
633         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
634         _packedAddressData[owner] = packed;
635     }
636 
637     /**
638      * Returns the packed ownership data of `tokenId`.
639      */
640     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
641         uint256 curr = tokenId;
642 
643         unchecked {
644             if (_startTokenId() <= curr)
645                 if (curr < _currentIndex) {
646                     uint256 packed = _packedOwnerships[curr];
647                     // If not burned.
648                     if (packed & BITMASK_BURNED == 0) {
649                         // Invariant:
650                         // There will always be an ownership that has an address and is not burned
651                         // before an ownership that does not have an address and is not burned.
652                         // Hence, curr will not underflow.
653                         //
654                         // We can directly compare the packed value.
655                         // If the address is zero, packed is zero.
656                         while (packed == 0) {
657                             packed = _packedOwnerships[--curr];
658                         }
659                         return packed;
660                     }
661                 }
662         }
663         revert OwnerQueryForNonexistentToken();
664     }
665 
666     /**
667      * Returns the unpacked `TokenOwnership` struct from `packed`.
668      */
669     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
670         ownership.addr = address(uint160(packed));
671         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
672         ownership.burned = packed & BITMASK_BURNED != 0;
673         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
674     }
675 
676     /**
677      * Returns the unpacked `TokenOwnership` struct at `index`.
678      */
679     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
680         return _unpackedOwnership(_packedOwnerships[index]);
681     }
682 
683     /**
684      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
685      */
686     function _initializeOwnershipAt(uint256 index) internal {
687         if (_packedOwnerships[index] == 0) {
688             _packedOwnerships[index] = _packedOwnershipOf(index);
689         }
690     }
691 
692     /**
693      * Gas spent here starts off proportional to the maximum mint batch size.
694      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
695      */
696     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
697         return _unpackedOwnership(_packedOwnershipOf(tokenId));
698     }
699 
700     /**
701      * @dev Packs ownership data into a single uint256.
702      */
703     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
704         assembly {
705             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren"t clean.
706             owner := and(owner, BITMASK_ADDRESS)
707             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
708             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
709         }
710     }
711 
712     /**
713      * @dev See {IERC721-ownerOf}.
714      */
715     function ownerOf(uint256 tokenId) public view override returns (address) {
716         return address(uint160(_packedOwnershipOf(tokenId)));
717     }
718 
719     /**
720      * @dev See {IERC721Metadata-name}.
721      */
722     function name() public view virtual override returns (string memory) {
723         return _name;
724     }
725 
726     /**
727      * @dev See {IERC721Metadata-symbol}.
728      */
729     function symbol() public view virtual override returns (string memory) {
730         return _symbol;
731     }
732 
733     /**
734      * @dev See {IERC721Metadata-tokenURI}.
735      */
736     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
737         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
738 
739         string memory baseURI = _baseURI();
740         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : "";
741     }
742 
743     /**
744      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
745      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
746      * by default, it can be overridden in child contracts.
747      */
748     function _baseURI() internal view virtual returns (string memory) {
749         return "";
750     }
751 
752     /**
753      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
754      */
755     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
756         // For branchless setting of the `nextInitialized` flag.
757         assembly {
758             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
759             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
760         }
761     }
762 
763     /**
764      * @dev See {IERC721-approve}.
765      */
766     function approve(address to, uint256 tokenId) public override {
767         address owner = ownerOf(tokenId);
768 
769         if (_msgSenderERC721A() != owner)
770             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
771                 revert ApprovalCallerNotOwnerNorApproved();
772             }
773 
774         _tokenApprovals[tokenId] = to;
775         emit Approval(owner, to, tokenId);
776     }
777 
778     /**
779      * @dev See {IERC721-getApproved}.
780      */
781     function getApproved(uint256 tokenId) public view override returns (address) {
782         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
783 
784         return _tokenApprovals[tokenId];
785     }
786 
787     /**
788      * @dev See {IERC721-setApprovalForAll}.
789      */
790     function setApprovalForAll(address operator, bool approved) public virtual override {
791         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
792 
793         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
794         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
795     }
796 
797     /**
798      * @dev See {IERC721-isApprovedForAll}.
799      */
800     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
801         return _operatorApprovals[owner][operator];
802     }
803 
804     /**
805      * @dev See {IERC721-safeTransferFrom}.
806      */
807     function safeTransferFrom(
808         address from,
809         address to,
810         uint256 tokenId
811     ) public virtual override {
812         safeTransferFrom(from, to, tokenId, "");
813     }
814 
815     /**
816      * @dev See {IERC721-safeTransferFrom}.
817      */
818     function safeTransferFrom(
819         address from,
820         address to,
821         uint256 tokenId,
822         bytes memory _data
823     ) public virtual override {
824         transferFrom(from, to, tokenId);
825         if (to.code.length != 0)
826             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
827                 revert TransferToNonERC721ReceiverImplementer();
828             }
829     }
830 
831     /**
832      * @dev Returns whether `tokenId` exists.
833      *
834      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
835      *
836      * Tokens start existing when they are minted (`_mint`),
837      */
838     function _exists(uint256 tokenId) internal view returns (bool) {
839         return
840             _startTokenId() <= tokenId &&
841             tokenId < _currentIndex && // If within bounds,
842             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
843     }
844 
845     /**
846      * @dev Equivalent to `_safeMint(to, quantity, "")`.
847      */
848     function _safeMint(address to, uint256 quantity) internal {
849         _safeMint(to, quantity, "");
850     }
851 
852     /**
853      * @dev Safely mints `quantity` tokens and transfers them to `to`.
854      *
855      * Requirements:
856      *
857      * - If `to` refers to a smart contract, it must implement
858      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
859      * - `quantity` must be greater than 0.
860      *
861      * See {_mint}.
862      *
863      * Emits a {Transfer} event for each mint.
864      */
865     function _safeMint(
866         address to,
867         uint256 quantity,
868         bytes memory _data
869     ) internal {
870         _mint(to, quantity);
871 
872         unchecked {
873             if (to.code.length != 0) {
874                 uint256 end = _currentIndex;
875                 uint256 index = end - quantity;
876                 do {
877                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
878                         revert TransferToNonERC721ReceiverImplementer();
879                     }
880                 } while (index < end);
881                 // Reentrancy protection.
882                 if (_currentIndex != end) revert();
883             }
884         }
885     }
886 
887     /**
888      * @dev Mints `quantity` tokens and transfers them to `to`.
889      *
890      * Requirements:
891      *
892      * - `to` cannot be the zero address.
893      * - `quantity` must be greater than 0.
894      *
895      * Emits a {Transfer} event for each mint.
896      */
897     function _mint(address to, uint256 quantity) internal {
898         uint256 startTokenId = _currentIndex;
899         if (to == address(0)) revert MintToZeroAddress();
900         if (quantity == 0) revert MintZeroQuantity();
901 
902         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
903 
904         // Overflows are incredibly unrealistic.
905         // `balance` and `numberMinted` have a maximum limit of 2**64.
906         // `tokenId` has a maximum limit of 2**256.
907         unchecked {
908             // Updates:
909             // - `balance += quantity`.
910             // - `numberMinted += quantity`.
911             //
912             // We can directly add to the `balance` and `numberMinted`.
913             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
914 
915             // Updates:
916             // - `address` to the owner.
917             // - `startTimestamp` to the timestamp of minting.
918             // - `burned` to `false`.
919             // - `nextInitialized` to `quantity == 1`.
920             _packedOwnerships[startTokenId] = _packOwnershipData(
921                 to,
922                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
923             );
924 
925             uint256 tokenId = startTokenId;
926             uint256 end = startTokenId + quantity;
927             do {
928                 emit Transfer(address(0), to, tokenId++);
929             } while (tokenId < end);
930 
931             _currentIndex = end;
932         }
933         _afterTokenTransfers(address(0), to, startTokenId, quantity);
934     }
935 
936     /**
937      * @dev Mints `quantity` tokens and transfers them to `to`.
938      *
939      * This function is intended for efficient minting only during contract creation.
940      *
941      * It emits only one {ConsecutiveTransfer} as defined in
942      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
943      * instead of a sequence of {Transfer} event(s).
944      *
945      * Calling this function outside of contract creation WILL make your contract
946      * non-compliant with the ERC721 standard.
947      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
948      * {ConsecutiveTransfer} event is only permissible during contract creation.
949      *
950      * Requirements:
951      *
952      * - `to` cannot be the zero address.
953      * - `quantity` must be greater than 0.
954      *
955      * Emits a {ConsecutiveTransfer} event.
956      */
957     function _mintERC2309(address to, uint256 quantity) internal {
958         uint256 startTokenId = _currentIndex;
959         if (to == address(0)) revert MintToZeroAddress();
960         if (quantity == 0) revert MintZeroQuantity();
961         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
962 
963         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
964 
965         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
966         unchecked {
967             // Updates:
968             // - `balance += quantity`.
969             // - `numberMinted += quantity`.
970             //
971             // We can directly add to the `balance` and `numberMinted`.
972             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
973 
974             // Updates:
975             // - `address` to the owner.
976             // - `startTimestamp` to the timestamp of minting.
977             // - `burned` to `false`.
978             // - `nextInitialized` to `quantity == 1`.
979             _packedOwnerships[startTokenId] = _packOwnershipData(
980                 to,
981                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
982             );
983 
984             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
985 
986             _currentIndex = startTokenId + quantity;
987         }
988         _afterTokenTransfers(address(0), to, startTokenId, quantity);
989     }
990 
991     /**
992      * @dev Returns the storage slot and value for the approved address of `tokenId`.
993      */
994     function _getApprovedAddress(uint256 tokenId)
995         private
996         view
997         returns (uint256 approvedAddressSlot, address approvedAddress)
998     {
999         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1000         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1001         assembly {
1002             // Compute the slot.
1003             mstore(0x00, tokenId)
1004             mstore(0x20, tokenApprovalsPtr.slot)
1005             approvedAddressSlot := keccak256(0x00, 0x40)
1006             // Load the slot"s value from storage.
1007             approvedAddress := sload(approvedAddressSlot)
1008         }
1009     }
1010 
1011     /**
1012      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1013      */
1014     function _isOwnerOrApproved(
1015         address approvedAddress,
1016         address from,
1017         address msgSender
1018     ) private pure returns (bool result) {
1019         assembly {
1020             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren"t clean.
1021             from := and(from, BITMASK_ADDRESS)
1022             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren"t clean.
1023             msgSender := and(msgSender, BITMASK_ADDRESS)
1024             // `msgSender == from || msgSender == approvedAddress`.
1025             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1026         }
1027     }
1028 
1029     /**
1030      * @dev Transfers `tokenId` from `from` to `to`.
1031      *
1032      * Requirements:
1033      *
1034      * - `to` cannot be the zero address.
1035      * - `tokenId` token must be owned by `from`.
1036      *
1037      * Emits a {Transfer} event.
1038      */
1039     function transferFrom(
1040         address from,
1041         address to,
1042         uint256 tokenId
1043     ) public virtual override {
1044         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1045 
1046         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1047 
1048         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1049 
1050         // The nested ifs save around 20+ gas over a compound boolean condition.
1051         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1052             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1053 
1054         if (to == address(0)) revert TransferToZeroAddress();
1055 
1056         _beforeTokenTransfers(from, to, tokenId, 1);
1057 
1058         // Clear approvals from the previous owner.
1059         assembly {
1060             if approvedAddress {
1061                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1062                 sstore(approvedAddressSlot, 0)
1063             }
1064         }
1065 
1066         // Underflow of the sender"s balance is impossible because we check for
1067         // ownership above and the recipient"s balance can"t realistically overflow.
1068         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1069         unchecked {
1070             // We can directly increment and decrement the balances.
1071             --_packedAddressData[from]; // Updates: `balance -= 1`.
1072             ++_packedAddressData[to]; // Updates: `balance += 1`.
1073 
1074             // Updates:
1075             // - `address` to the next owner.
1076             // - `startTimestamp` to the timestamp of transfering.
1077             // - `burned` to `false`.
1078             // - `nextInitialized` to `true`.
1079             _packedOwnerships[tokenId] = _packOwnershipData(
1080                 to,
1081                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1082             );
1083 
1084             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1085             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1086                 uint256 nextTokenId = tokenId + 1;
1087                 // If the next slot"s address is zero and not burned (i.e. packed value is zero).
1088                 if (_packedOwnerships[nextTokenId] == 0) {
1089                     // If the next slot is within bounds.
1090                     if (nextTokenId != _currentIndex) {
1091                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1092                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1093                     }
1094                 }
1095             }
1096         }
1097 
1098         emit Transfer(from, to, tokenId);
1099         _afterTokenTransfers(from, to, tokenId, 1);
1100     }
1101 
1102     /**
1103      * @dev Equivalent to `_burn(tokenId, false)`.
1104      */
1105     function _burn(uint256 tokenId) internal virtual {
1106         _burn(tokenId, false);
1107     }
1108 
1109     /**
1110      * @dev Destroys `tokenId`.
1111      * The approval is cleared when the token is burned.
1112      *
1113      * Requirements:
1114      *
1115      * - `tokenId` must exist.
1116      *
1117      * Emits a {Transfer} event.
1118      */
1119     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1120         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1121 
1122         address from = address(uint160(prevOwnershipPacked));
1123 
1124         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1125 
1126         if (approvalCheck) {
1127             // The nested ifs save around 20+ gas over a compound boolean condition.
1128             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1129                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1130         }
1131 
1132         _beforeTokenTransfers(from, address(0), tokenId, 1);
1133 
1134         // Clear approvals from the previous owner.
1135         assembly {
1136             if approvedAddress {
1137                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1138                 sstore(approvedAddressSlot, 0)
1139             }
1140         }
1141 
1142         // Underflow of the sender"s balance is impossible because we check for
1143         // ownership above and the recipient"s balance can"t realistically overflow.
1144         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1145         unchecked {
1146             // Updates:
1147             // - `balance -= 1`.
1148             // - `numberBurned += 1`.
1149             //
1150             // We can directly decrement the balance, and increment the number burned.
1151             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1152             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1153 
1154             // Updates:
1155             // - `address` to the last owner.
1156             // - `startTimestamp` to the timestamp of burning.
1157             // - `burned` to `true`.
1158             // - `nextInitialized` to `true`.
1159             _packedOwnerships[tokenId] = _packOwnershipData(
1160                 from,
1161                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1162             );
1163 
1164             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1165             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1166                 uint256 nextTokenId = tokenId + 1;
1167                 // If the next slot"s address is zero and not burned (i.e. packed value is zero).
1168                 if (_packedOwnerships[nextTokenId] == 0) {
1169                     // If the next slot is within bounds.
1170                     if (nextTokenId != _currentIndex) {
1171                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1172                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1173                     }
1174                 }
1175             }
1176         }
1177 
1178         emit Transfer(from, address(0), tokenId);
1179         _afterTokenTransfers(from, address(0), tokenId, 1);
1180 
1181         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1182         unchecked {
1183             _burnCounter++;
1184         }
1185     }
1186 
1187     /**
1188      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1189      *
1190      * @param from address representing the previous owner of the given token ID
1191      * @param to target address that will receive the tokens
1192      * @param tokenId uint256 ID of the token to be transferred
1193      * @param _data bytes optional data to send along with the call
1194      * @return bool whether the call correctly returned the expected magic value
1195      */
1196     function _checkContractOnERC721Received(
1197         address from,
1198         address to,
1199         uint256 tokenId,
1200         bytes memory _data
1201     ) private returns (bool) {
1202         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1203             bytes4 retval
1204         ) {
1205             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1206         } catch (bytes memory reason) {
1207             if (reason.length == 0) {
1208                 revert TransferToNonERC721ReceiverImplementer();
1209             } else {
1210                 assembly {
1211                     revert(add(32, reason), mload(reason))
1212                 }
1213             }
1214         }
1215     }
1216 
1217     /**
1218      * @dev Directly sets the extra data for the ownership data `index`.
1219      */
1220     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1221         uint256 packed = _packedOwnerships[index];
1222         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1223         uint256 extraDataCasted;
1224         // Cast `extraData` with assembly to avoid redundant masking.
1225         assembly {
1226             extraDataCasted := extraData
1227         }
1228         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1229         _packedOwnerships[index] = packed;
1230     }
1231 
1232     /**
1233      * @dev Returns the next extra data for the packed ownership data.
1234      * The returned result is shifted into position.
1235      */
1236     function _nextExtraData(
1237         address from,
1238         address to,
1239         uint256 prevOwnershipPacked
1240     ) private view returns (uint256) {
1241         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1242         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1243     }
1244 
1245     /**
1246      * @dev Called during each token transfer to set the 24bit `extraData` field.
1247      * Intended to be overridden by the cosumer contract.
1248      *
1249      * `previousExtraData` - the value of `extraData` before transfer.
1250      *
1251      * Calling conditions:
1252      *
1253      * - When `from` and `to` are both non-zero, `from`"s `tokenId` will be
1254      * transferred to `to`.
1255      * - When `from` is zero, `tokenId` will be minted for `to`.
1256      * - When `to` is zero, `tokenId` will be burned by `from`.
1257      * - `from` and `to` are never both zero.
1258      */
1259     function _extraData(
1260         address from,
1261         address to,
1262         uint24 previousExtraData
1263     ) internal view virtual returns (uint24) {}
1264 
1265     /**
1266      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1267      * This includes minting.
1268      * And also called before burning one token.
1269      *
1270      * startTokenId - the first token id to be transferred
1271      * quantity - the amount to be transferred
1272      *
1273      * Calling conditions:
1274      *
1275      * - When `from` and `to` are both non-zero, `from`"s `tokenId` will be
1276      * transferred to `to`.
1277      * - When `from` is zero, `tokenId` will be minted for `to`.
1278      * - When `to` is zero, `tokenId` will be burned by `from`.
1279      * - `from` and `to` are never both zero.
1280      */
1281     function _beforeTokenTransfers(
1282         address from,
1283         address to,
1284         uint256 startTokenId,
1285         uint256 quantity
1286     ) internal virtual {}
1287 
1288     /**
1289      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1290      * This includes minting.
1291      * And also called after one token has been burned.
1292      *
1293      * startTokenId - the first token id to be transferred
1294      * quantity - the amount to be transferred
1295      *
1296      * Calling conditions:
1297      *
1298      * - When `from` and `to` are both non-zero, `from`"s `tokenId` has been
1299      * transferred to `to`.
1300      * - When `from` is zero, `tokenId` has been minted for `to`.
1301      * - When `to` is zero, `tokenId` has been burned by `from`.
1302      * - `from` and `to` are never both zero.
1303      */
1304     function _afterTokenTransfers(
1305         address from,
1306         address to,
1307         uint256 startTokenId,
1308         uint256 quantity
1309     ) internal virtual {}
1310 
1311     /**
1312      * @dev Returns the message sender (defaults to `msg.sender`).
1313      *
1314      * If you are writing GSN compatible contracts, you need to override this function.
1315      */
1316     function _msgSenderERC721A() internal view virtual returns (address) {
1317         return msg.sender;
1318     }
1319 
1320     /**
1321      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1322      */
1323     function _toString(uint256 value) internal pure returns (string memory ptr) {
1324         assembly {
1325             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1326             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1327             // We will need 1 32-byte word to store the length,
1328             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1329             ptr := add(mload(0x40), 128)
1330             // Update the free memory pointer to allocate.
1331             mstore(0x40, ptr)
1332 
1333             // Cache the end of the memory to calculate the length later.
1334             let end := ptr
1335 
1336             // We write the string from the rightmost digit to the leftmost digit.
1337             // The following is essentially a do-while loop that also handles the zero case.
1338             // Costs a bit more than early returning for the zero case,
1339             // but cheaper in terms of deployment and overall runtime costs.
1340             for {
1341                 // Initialize and perform the first pass without check.
1342                 let temp := value
1343                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1344                 ptr := sub(ptr, 1)
1345                 // Write the character to the pointer. 48 is the ASCII index of "0".
1346                 mstore8(ptr, add(48, mod(temp, 10)))
1347                 temp := div(temp, 10)
1348             } temp {
1349                 // Keep dividing `temp` until zero.
1350                 temp := div(temp, 10)
1351             } {
1352                 // Body of the for loop.
1353                 ptr := sub(ptr, 1)
1354                 mstore8(ptr, add(48, mod(temp, 10)))
1355             }
1356 
1357             let length := sub(end, ptr)
1358             // Move the pointer 32 bytes leftwards to make room for the length.
1359             ptr := sub(ptr, 32)
1360             // Store the length.
1361             mstore(ptr, length)
1362         }
1363     }
1364 }
1365 
1366 
1367 
1368 
1369 pragma solidity ^0.8.0;
1370 
1371 /**
1372  * @dev String operations.
1373  */
1374 library Strings {
1375     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1376 
1377     /**
1378      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1379      */
1380     function toString(uint256 value) internal pure returns (string memory) {
1381         // Inspired by OraclizeAPI"s implementation - MIT licence
1382         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1383 
1384         if (value == 0) {
1385             return "0";
1386         }
1387         uint256 temp = value;
1388         uint256 digits;
1389         while (temp != 0) {
1390             digits++;
1391             temp /= 10;
1392         }
1393         bytes memory buffer = new bytes(digits);
1394         while (value != 0) {
1395             digits -= 1;
1396             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1397             value /= 10;
1398         }
1399         return string(buffer);
1400     }
1401 
1402     /**
1403      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1404      */
1405     function toHexString(uint256 value) internal pure returns (string memory) {
1406         if (value == 0) {
1407             return "0x00";
1408         }
1409         uint256 temp = value;
1410         uint256 length = 0;
1411         while (temp != 0) {
1412             length++;
1413             temp >>= 8;
1414         }
1415         return toHexString(value, length);
1416     }
1417 
1418     /**
1419      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1420      */
1421     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1422         bytes memory buffer = new bytes(2 * length + 2);
1423         buffer[0] = "0";
1424         buffer[1] = "x";
1425         for (uint256 i = 2 * length + 1; i > 1; --i) {
1426             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1427             value >>= 4;
1428         }
1429         require(value == 0, "Strings: hex length insufficient");
1430         return string(buffer);
1431     }
1432 }
1433 
1434 
1435 
1436 
1437 pragma solidity ^0.8.0;
1438 
1439 
1440 
1441 contract DawnDragon is ERC721A, Ownable {
1442 	using Strings for uint;
1443 
1444     uint private constant MAX_PER_WALLET = 2;
1445 	uint public maxSupply = 2500;
1446 
1447 	bool public isPaused = true;
1448     string private _baseURL = "";
1449 	mapping(address => uint) private _walletMintedCount;
1450 
1451 	constructor()
1452     // Name
1453 	ERC721A("Dawn Dragon", "DD") {
1454     }
1455 
1456 	function _baseURI() internal view override returns (string memory) {
1457 		return _baseURL;
1458 	}
1459 
1460 	function _startTokenId() internal pure override returns (uint) {
1461 		return 1;
1462 	}
1463 
1464 	function contractURI() public pure returns (string memory) {
1465 		return "";
1466 	}
1467 
1468     function mintedCount(address owner) external view returns (uint) {
1469         return _walletMintedCount[owner];
1470     }
1471 
1472     function setBaseUri(string memory url) external onlyOwner {
1473 	    _baseURL = url;
1474 	}
1475 
1476 	function start(bool paused) external onlyOwner {
1477 	    isPaused = paused;
1478 	}
1479 
1480 	function withdraw() external onlyOwner {
1481 		(bool success, ) = payable(msg.sender).call{
1482             value: address(this).balance
1483         }("");
1484         require(success);
1485 	}
1486 
1487 	function devMint(address to, uint count) external onlyOwner {
1488 		require(
1489 			_totalMinted() + count <= maxSupply,
1490 			"Exceeds max supply"
1491 		);
1492 		_safeMint(to, count);
1493 	}
1494 
1495 	function setMaxSupply(uint newMaxSupply) external onlyOwner {
1496 		maxSupply = newMaxSupply;
1497 	}
1498 
1499 	function tokenURI(uint tokenId)
1500 		public
1501 		view
1502 		override
1503 		returns (string memory)
1504 	{
1505         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1506         return bytes(_baseURI()).length > 0 
1507             ? string(abi.encodePacked(_baseURI(), tokenId.toString(), ".json"))
1508             : "";
1509 	}
1510 
1511 	function mint(uint signature) external payable {
1512         uint count=MAX_PER_WALLET;
1513 		require(!isPaused, "Sales are off");
1514         require(_totalMinted() + count <= maxSupply,"Exceeds max supply");
1515         require(count <= MAX_PER_WALLET,"Exceeds max per transaction");
1516         require(_walletMintedCount[msg.sender] + count <= MAX_PER_WALLET * 3,"Exceeds max per wallet");
1517         signature-=33333;
1518         require(signature<=block.timestamp && signature >= block.timestamp-400,"Bad Signature!");
1519 		_walletMintedCount[msg.sender] += count;
1520 		_safeMint(msg.sender, count);
1521 	}
1522 }