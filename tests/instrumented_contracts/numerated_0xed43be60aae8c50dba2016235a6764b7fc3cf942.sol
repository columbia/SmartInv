1 /**
2  *Submitted for verification at Etherscan.io on 2022-08-23
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2022-08-02
7 */
8 
9 /**
10  *Submitted for verification at Etherscan.io on 2022-07-20
11 */
12 
13 // SPDX-License-Identifier: MIT
14 // File: @openzeppelin/contracts/utils/Context.sol
15 
16 
17 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
18 
19 pragma solidity ^0.8.0;
20 
21 /**
22  * @dev Provides information about the current execution context, including the
23  * sender of the transaction and its data. While these are generally available
24  * via msg.sender and msg.data, they should not be accessed in such a direct
25  * manner, since when dealing with meta-transactions the account sending and
26  * paying for execution may not be the actual sender (as far as an application
27  * is concerned).
28  *
29  * This contract is only required for intermediate, library-like contracts.
30  */
31 abstract contract Context {
32     function _msgSender() internal view virtual returns (address) {
33         return msg.sender;
34     }
35 
36     function _msgData() internal view virtual returns (bytes calldata) {
37         return msg.data;
38     }
39 }
40 
41 // File: @openzeppelin/contracts/access/Ownable.sol
42 
43 
44 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
45 
46 pragma solidity ^0.8.0;
47 
48 
49 /**
50  * @dev Contract module which provides a basic access control mechanism, where
51  * there is an account (an owner) that can be granted exclusive access to
52  * specific functions.
53  *
54  * By default, the owner account will be the one that deploys the contract. This
55  * can later be changed with {transferOwnership}.
56  *
57  * This module is used through inheritance. It will make available the modifier
58  * `onlyOwner`, which can be applied to your functions to restrict their use to
59  * the owner.
60  */
61 abstract contract Ownable is Context {
62     address private _owner;
63 
64     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
65 
66     /**
67      * @dev Initializes the contract setting the deployer as the initial owner.
68      */
69     constructor() {
70         _transferOwnership(_msgSender());
71     }
72 
73     /**
74      * @dev Throws if called by any account other than the owner.
75      */
76     modifier onlyOwner() {
77         _checkOwner();
78         _;
79     }
80 
81     /**
82      * @dev Returns the address of the current owner.
83      */
84     function owner() public view virtual returns (address) {
85         return _owner;
86     }
87 
88     /**
89      * @dev Throws if the sender is not the owner.
90      */
91     function _checkOwner() internal view virtual {
92         require(owner() == _msgSender(), "Ownable: caller is not the owner");
93     }
94 
95     /**
96      * @dev Leaves the contract without owner. It will not be possible to call
97      * `onlyOwner` functions anymore. Can only be called by the current owner.
98      *
99      * NOTE: Renouncing ownership will leave the contract without an owner,
100      * thereby removing any functionality that is only available to the owner.
101      */
102     function renounceOwnership() public virtual onlyOwner {
103         _transferOwnership(address(0));
104     }
105 
106     /**
107      * @dev Transfers ownership of the contract to a new account (`newOwner`).
108      * Can only be called by the current owner.
109      */
110     function transferOwnership(address newOwner) public virtual onlyOwner {
111         require(newOwner != address(0), "Ownable: new owner is the zero address");
112         _transferOwnership(newOwner);
113     }
114 
115     /**
116      * @dev Transfers ownership of the contract to a new account (`newOwner`).
117      * Internal function without access restriction.
118      */
119     function _transferOwnership(address newOwner) internal virtual {
120         address oldOwner = _owner;
121         _owner = newOwner;
122         emit OwnershipTransferred(oldOwner, newOwner);
123     }
124 }
125 
126 // File: erc721a/contracts/IERC721A.sol
127 
128 
129 // ERC721A Contracts v4.1.0
130 // Creator: Chiru Labs
131 
132 pragma solidity ^0.8.4;
133 
134 /**
135  * @dev Interface of an ERC721A compliant contract.
136  */
137 interface IERC721A {
138     /**
139      * The caller must own the token or be an approved operator.
140      */
141     error ApprovalCallerNotOwnerNorApproved();
142 
143     /**
144      * The token does not exist.
145      */
146     error ApprovalQueryForNonexistentToken();
147 
148     /**
149      * The caller cannot approve to their own address.
150      */
151     error ApproveToCaller();
152 
153     /**
154      * Cannot query the balance for the zero address.
155      */
156     error BalanceQueryForZeroAddress();
157 
158     /**
159      * Cannot mint to the zero address.
160      */
161     error MintToZeroAddress();
162 
163     /**
164      * The quantity of tokens minted must be more than zero.
165      */
166     error MintZeroQuantity();
167 
168     /**
169      * The token does not exist.
170      */
171     error OwnerQueryForNonexistentToken();
172 
173     /**
174      * The caller must own the token or be an approved operator.
175      */
176     error TransferCallerNotOwnerNorApproved();
177 
178     /**
179      * The token must be owned by `from`.
180      */
181     error TransferFromIncorrectOwner();
182 
183     /**
184      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
185      */
186     error TransferToNonERC721ReceiverImplementer();
187 
188     /**
189      * Cannot transfer to the zero address.
190      */
191     error TransferToZeroAddress();
192 
193     /**
194      * The token does not exist.
195      */
196     error URIQueryForNonexistentToken();
197 
198     /**
199      * The `quantity` minted with ERC2309 exceeds the safety limit.
200      */
201     error MintERC2309QuantityExceedsLimit();
202 
203     /**
204      * The `extraData` cannot be set on an unintialized ownership slot.
205      */
206     error OwnershipNotInitializedForExtraData();
207 
208     struct TokenOwnership {
209         // The address of the owner.
210         address addr;
211         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
212         uint64 startTimestamp;
213         // Whether the token has been burned.
214         bool burned;
215         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
216         uint24 extraData;
217     }
218 
219     /**
220      * @dev Returns the total amount of tokens stored by the contract.
221      *
222      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
223      */
224     function totalSupply() external view returns (uint256);
225 
226     // ==============================
227     //            IERC165
228     // ==============================
229 
230     /**
231      * @dev Returns true if this contract implements the interface defined by
232      * `interfaceId`. See the corresponding
233      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
234      * to learn more about how these ids are created.
235      *
236      * This function call must use less than 30 000 gas.
237      */
238     function supportsInterface(bytes4 interfaceId) external view returns (bool);
239 
240     // ==============================
241     //            IERC721
242     // ==============================
243 
244     /**
245      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
246      */
247     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
248 
249     /**
250      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
251      */
252     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
253 
254     /**
255      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
256      */
257     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
258 
259     /**
260      * @dev Returns the number of tokens in ``owner``"s account.
261      */
262     function balanceOf(address owner) external view returns (uint256 balance);
263 
264     /**
265      * @dev Returns the owner of the `tokenId` token.
266      *
267      * Requirements:
268      *
269      * - `tokenId` must exist.
270      */
271     function ownerOf(uint256 tokenId) external view returns (address owner);
272 
273     /**
274      * @dev Safely transfers `tokenId` token from `from` to `to`.
275      *
276      * Requirements:
277      *
278      * - `from` cannot be the zero address.
279      * - `to` cannot be the zero address.
280      * - `tokenId` token must exist and be owned by `from`.
281      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
282      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
283      *
284      * Emits a {Transfer} event.
285      */
286     function safeTransferFrom(
287         address from,
288         address to,
289         uint256 tokenId,
290         bytes calldata data
291     ) external;
292 
293     /**
294      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
295      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
296      *
297      * Requirements:
298      *
299      * - `from` cannot be the zero address.
300      * - `to` cannot be the zero address.
301      * - `tokenId` token must exist and be owned by `from`.
302      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
303      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
304      *
305      * Emits a {Transfer} event.
306      */
307     function safeTransferFrom(
308         address from,
309         address to,
310         uint256 tokenId
311     ) external;
312 
313     /**
314      * @dev Transfers `tokenId` token from `from` to `to`.
315      *
316      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
317      *
318      * Requirements:
319      *
320      * - `from` cannot be the zero address.
321      * - `to` cannot be the zero address.
322      * - `tokenId` token must be owned by `from`.
323      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
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
337      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
338      *
339      * Requirements:
340      *
341      * - The caller must own the token or be an approved operator.
342      * - `tokenId` must exist.
343      *
344      * Emits an {Approval} event.
345      */
346     function approve(address to, uint256 tokenId) external;
347 
348     /**
349      * @dev Approve or remove `operator` as an operator for the caller.
350      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
351      *
352      * Requirements:
353      *
354      * - The `operator` cannot be the caller.
355      *
356      * Emits an {ApprovalForAll} event.
357      */
358     function setApprovalForAll(address operator, bool _approved) external;
359 
360     /**
361      * @dev Returns the account approved for `tokenId` token.
362      *
363      * Requirements:
364      *
365      * - `tokenId` must exist.
366      */
367     function getApproved(uint256 tokenId) external view returns (address operator);
368 
369     /**
370      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
371      *
372      * See {setApprovalForAll}
373      */
374     function isApprovedForAll(address owner, address operator) external view returns (bool);
375 
376     // ==============================
377     //        IERC721Metadata
378     // ==============================
379 
380     /**
381      * @dev Returns the token collection name.
382      */
383     function name() external view returns (string memory);
384 
385     /**
386      * @dev Returns the token collection symbol.
387      */
388     function symbol() external view returns (string memory);
389 
390     /**
391      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
392      */
393     function tokenURI(uint256 tokenId) external view returns (string memory);
394 
395     // ==============================
396     //            IERC2309
397     // ==============================
398 
399     /**
400      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
401      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
402      */
403     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
404 }
405 
406 // File: erc721a/contracts/ERC721A.sol
407 
408 
409 // ERC721A Contracts v4.1.0
410 // Creator: Chiru Labs
411 
412 pragma solidity ^0.8.4;
413 
414 
415 /**
416  * @dev ERC721 token receiver interface.
417  */
418 interface ERC721A__IERC721Receiver {
419     function onERC721Received(
420         address operator,
421         address from,
422         uint256 tokenId,
423         bytes calldata data
424     ) external returns (bytes4);
425 }
426 
427 /**
428  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
429  * including the Metadata extension. Built to optimize for lower gas during batch mints.
430  *
431  * Assumes serials are sequentially minted starting at `_startTokenId()`
432  * (defaults to 0, e.g. 0, 1, 2, 3..).
433  *
434  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
435  *
436  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
437  */
438 contract ERC721A is IERC721A {
439     // Mask of an entry in packed address data.
440     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
441 
442     // The bit position of `numberMinted` in packed address data.
443     uint256 private constant BITPOS_NUMBER_MINTED = 64;
444 
445     // The bit position of `numberBurned` in packed address data.
446     uint256 private constant BITPOS_NUMBER_BURNED = 128;
447 
448     // The bit position of `aux` in packed address data.
449     uint256 private constant BITPOS_AUX = 192;
450 
451     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
452     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
453 
454     // The bit position of `startTimestamp` in packed ownership.
455     uint256 private constant BITPOS_START_TIMESTAMP = 160;
456 
457     // The bit mask of the `burned` bit in packed ownership.
458     uint256 private constant BITMASK_BURNED = 1 << 224;
459 
460     // The bit position of the `nextInitialized` bit in packed ownership.
461     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
462 
463     // The bit mask of the `nextInitialized` bit in packed ownership.
464     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
465 
466     // The bit position of `extraData` in packed ownership.
467     uint256 private constant BITPOS_EXTRA_DATA = 232;
468 
469     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
470     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
471 
472     // The mask of the lower 160 bits for addresses.
473     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
474 
475     // The maximum `quantity` that can be minted with `_mintERC2309`.
476     // This limit is to prevent overflows on the address data entries.
477     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
478     // is required to cause an overflow, which is unrealistic.
479     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
480 
481     // The tokenId of the next token to be minted.
482     uint256 private _currentIndex;
483 
484     // The number of tokens burned.
485     uint256 private _burnCounter;
486 
487     // Token name
488     string private _name;
489 
490     // Token symbol
491     string private _symbol;
492 
493     // Mapping from token ID to ownership details
494     // An empty struct value does not necessarily mean the token is unowned.
495     // See `_packedOwnershipOf` implementation for details.
496     //
497     // Bits Layout:
498     // - [0..159]   `addr`
499     // - [160..223] `startTimestamp`
500     // - [224]      `burned`
501     // - [225]      `nextInitialized`
502     // - [232..255] `extraData`
503     mapping(uint256 => uint256) private _packedOwnerships;
504 
505     // Mapping owner address to address data.
506     //
507     // Bits Layout:
508     // - [0..63]    `balance`
509     // - [64..127]  `numberMinted`
510     // - [128..191] `numberBurned`
511     // - [192..255] `aux`
512     mapping(address => uint256) private _packedAddressData;
513 
514     // Mapping from token ID to approved address.
515     mapping(uint256 => address) private _tokenApprovals;
516 
517     // Mapping from owner to operator approvals
518     mapping(address => mapping(address => bool)) private _operatorApprovals;
519 
520     constructor(string memory name_, string memory symbol_) {
521         _name = name_;
522         _symbol = symbol_;
523         _currentIndex = _startTokenId();
524     }
525 
526     /**
527      * @dev Returns the starting token ID.
528      * To change the starting token ID, please override this function.
529      */
530     function _startTokenId() internal view virtual returns (uint256) {
531         return 0;
532     }
533 
534     /**
535      * @dev Returns the next token ID to be minted.
536      */
537     function _nextTokenId() internal view returns (uint256) {
538         return _currentIndex;
539     }
540 
541     /**
542      * @dev Returns the total number of tokens in existence.
543      * Burned tokens will reduce the count.
544      * To get the total number of tokens minted, please see `_totalMinted`.
545      */
546     function totalSupply() public view override returns (uint256) {
547         // Counter underflow is impossible as _burnCounter cannot be incremented
548         // more than `_currentIndex - _startTokenId()` times.
549         unchecked {
550             return _currentIndex - _burnCounter - _startTokenId();
551         }
552     }
553 
554     /**
555      * @dev Returns the total amount of tokens minted in the contract.
556      */
557     function _totalMinted() internal view returns (uint256) {
558         // Counter underflow is impossible as _currentIndex does not decrement,
559         // and it is initialized to `_startTokenId()`
560         unchecked {
561             return _currentIndex - _startTokenId();
562         }
563     }
564 
565     /**
566      * @dev Returns the total number of tokens burned.
567      */
568     function _totalBurned() internal view returns (uint256) {
569         return _burnCounter;
570     }
571 
572     /**
573      * @dev See {IERC165-supportsInterface}.
574      */
575     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
576         // The interface IDs are constants representing the first 4 bytes of the XOR of
577         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
578         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
579         return
580             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
581             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
582             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
583     }
584 
585     /**
586      * @dev See {IERC721-balanceOf}.
587      */
588     function balanceOf(address owner) public view override returns (uint256) {
589         if (owner == address(0)) revert BalanceQueryForZeroAddress();
590         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
591     }
592 
593     /**
594      * Returns the number of tokens minted by `owner`.
595      */
596     function _numberMinted(address owner) internal view returns (uint256) {
597         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
598     }
599 
600     /**
601      * Returns the number of tokens burned by or on behalf of `owner`.
602      */
603     function _numberBurned(address owner) internal view returns (uint256) {
604         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
605     }
606 
607     /**
608      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
609      */
610     function _getAux(address owner) internal view returns (uint64) {
611         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
612     }
613 
614     /**
615      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
616      * If there are multiple variables, please pack them into a uint64.
617      */
618     function _setAux(address owner, uint64 aux) internal {
619         uint256 packed = _packedAddressData[owner];
620         uint256 auxCasted;
621         // Cast `aux` with assembly to avoid redundant masking.
622         assembly {
623             auxCasted := aux
624         }
625         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
626         _packedAddressData[owner] = packed;
627     }
628 
629     /**
630      * Returns the packed ownership data of `tokenId`.
631      */
632     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
633         uint256 curr = tokenId;
634 
635         unchecked {
636             if (_startTokenId() <= curr)
637                 if (curr < _currentIndex) {
638                     uint256 packed = _packedOwnerships[curr];
639                     // If not burned.
640                     if (packed & BITMASK_BURNED == 0) {
641                         // Invariant:
642                         // There will always be an ownership that has an address and is not burned
643                         // before an ownership that does not have an address and is not burned.
644                         // Hence, curr will not underflow.
645                         //
646                         // We can directly compare the packed value.
647                         // If the address is zero, packed is zero.
648                         while (packed == 0) {
649                             packed = _packedOwnerships[--curr];
650                         }
651                         return packed;
652                     }
653                 }
654         }
655         revert OwnerQueryForNonexistentToken();
656     }
657 
658     /**
659      * Returns the unpacked `TokenOwnership` struct from `packed`.
660      */
661     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
662         ownership.addr = address(uint160(packed));
663         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
664         ownership.burned = packed & BITMASK_BURNED != 0;
665         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
666     }
667 
668     /**
669      * Returns the unpacked `TokenOwnership` struct at `index`.
670      */
671     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
672         return _unpackedOwnership(_packedOwnerships[index]);
673     }
674 
675     /**
676      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
677      */
678     function _initializeOwnershipAt(uint256 index) internal {
679         if (_packedOwnerships[index] == 0) {
680             _packedOwnerships[index] = _packedOwnershipOf(index);
681         }
682     }
683 
684     /**
685      * Gas spent here starts off proportional to the maximum mint batch size.
686      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
687      */
688     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
689         return _unpackedOwnership(_packedOwnershipOf(tokenId));
690     }
691 
692     /**
693      * @dev Packs ownership data into a single uint256.
694      */
695     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
696         assembly {
697             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren"t clean.
698             owner := and(owner, BITMASK_ADDRESS)
699             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
700             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
701         }
702     }
703 
704     /**
705      * @dev See {IERC721-ownerOf}.
706      */
707     function ownerOf(uint256 tokenId) public view override returns (address) {
708         return address(uint160(_packedOwnershipOf(tokenId)));
709     }
710 
711     /**
712      * @dev See {IERC721Metadata-name}.
713      */
714     function name() public view virtual override returns (string memory) {
715         return _name;
716     }
717 
718     /**
719      * @dev See {IERC721Metadata-symbol}.
720      */
721     function symbol() public view virtual override returns (string memory) {
722         return _symbol;
723     }
724 
725     /**
726      * @dev See {IERC721Metadata-tokenURI}.
727      */
728     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
729         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
730 
731         string memory baseURI = _baseURI();
732         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : "";
733     }
734 
735     /**
736      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
737      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
738      * by default, it can be overridden in child contracts.
739      */
740     function _baseURI() internal view virtual returns (string memory) {
741         return "";
742     }
743 
744     /**
745      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
746      */
747     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
748         // For branchless setting of the `nextInitialized` flag.
749         assembly {
750             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
751             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
752         }
753     }
754 
755     /**
756      * @dev See {IERC721-approve}.
757      */
758     function approve(address to, uint256 tokenId) public override {
759         address owner = ownerOf(tokenId);
760 
761         if (_msgSenderERC721A() != owner)
762             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
763                 revert ApprovalCallerNotOwnerNorApproved();
764             }
765 
766         _tokenApprovals[tokenId] = to;
767         emit Approval(owner, to, tokenId);
768     }
769 
770     /**
771      * @dev See {IERC721-getApproved}.
772      */
773     function getApproved(uint256 tokenId) public view override returns (address) {
774         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
775 
776         return _tokenApprovals[tokenId];
777     }
778 
779     /**
780      * @dev See {IERC721-setApprovalForAll}.
781      */
782     function setApprovalForAll(address operator, bool approved) public virtual override {
783         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
784 
785         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
786         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
787     }
788 
789     /**
790      * @dev See {IERC721-isApprovedForAll}.
791      */
792     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
793         return _operatorApprovals[owner][operator];
794     }
795 
796     /**
797      * @dev See {IERC721-safeTransferFrom}.
798      */
799     function safeTransferFrom(
800         address from,
801         address to,
802         uint256 tokenId
803     ) public virtual override {
804         safeTransferFrom(from, to, tokenId, "");
805     }
806 
807     /**
808      * @dev See {IERC721-safeTransferFrom}.
809      */
810     function safeTransferFrom(
811         address from,
812         address to,
813         uint256 tokenId,
814         bytes memory _data
815     ) public virtual override {
816         transferFrom(from, to, tokenId);
817         if (to.code.length != 0)
818             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
819                 revert TransferToNonERC721ReceiverImplementer();
820             }
821     }
822 
823     /**
824      * @dev Returns whether `tokenId` exists.
825      *
826      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
827      *
828      * Tokens start existing when they are minted (`_mint`),
829      */
830     function _exists(uint256 tokenId) internal view returns (bool) {
831         return
832             _startTokenId() <= tokenId &&
833             tokenId < _currentIndex && // If within bounds,
834             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
835     }
836 
837     /**
838      * @dev Equivalent to `_safeMint(to, quantity, "")`.
839      */
840     function _safeMint(address to, uint256 quantity) internal {
841         _safeMint(to, quantity, "");
842     }
843 
844     /**
845      * @dev Safely mints `quantity` tokens and transfers them to `to`.
846      *
847      * Requirements:
848      *
849      * - If `to` refers to a smart contract, it must implement
850      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
851      * - `quantity` must be greater than 0.
852      *
853      * See {_mint}.
854      *
855      * Emits a {Transfer} event for each mint.
856      */
857     function _safeMint(
858         address to,
859         uint256 quantity,
860         bytes memory _data
861     ) internal {
862         _mint(to, quantity);
863 
864         unchecked {
865             if (to.code.length != 0) {
866                 uint256 end = _currentIndex;
867                 uint256 index = end - quantity;
868                 do {
869                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
870                         revert TransferToNonERC721ReceiverImplementer();
871                     }
872                 } while (index < end);
873                 // Reentrancy protection.
874                 if (_currentIndex != end) revert();
875             }
876         }
877     }
878 
879     /**
880      * @dev Mints `quantity` tokens and transfers them to `to`.
881      *
882      * Requirements:
883      *
884      * - `to` cannot be the zero address.
885      * - `quantity` must be greater than 0.
886      *
887      * Emits a {Transfer} event for each mint.
888      */
889     function _mint(address to, uint256 quantity) internal {
890         uint256 startTokenId = _currentIndex;
891         if (to == address(0)) revert MintToZeroAddress();
892         if (quantity == 0) revert MintZeroQuantity();
893 
894         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
895 
896         // Overflows are incredibly unrealistic.
897         // `balance` and `numberMinted` have a maximum limit of 2**64.
898         // `tokenId` has a maximum limit of 2**256.
899         unchecked {
900             // Updates:
901             // - `balance += quantity`.
902             // - `numberMinted += quantity`.
903             //
904             // We can directly add to the `balance` and `numberMinted`.
905             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
906 
907             // Updates:
908             // - `address` to the owner.
909             // - `startTimestamp` to the timestamp of minting.
910             // - `burned` to `false`.
911             // - `nextInitialized` to `quantity == 1`.
912             _packedOwnerships[startTokenId] = _packOwnershipData(
913                 to,
914                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
915             );
916 
917             uint256 tokenId = startTokenId;
918             uint256 end = startTokenId + quantity;
919             do {
920                 emit Transfer(address(0), to, tokenId++);
921             } while (tokenId < end);
922 
923             _currentIndex = end;
924         }
925         _afterTokenTransfers(address(0), to, startTokenId, quantity);
926     }
927 
928     /**
929      * @dev Mints `quantity` tokens and transfers them to `to`.
930      *
931      * This function is intended for efficient minting only during contract creation.
932      *
933      * It emits only one {ConsecutiveTransfer} as defined in
934      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
935      * instead of a sequence of {Transfer} event(s).
936      *
937      * Calling this function outside of contract creation WILL make your contract
938      * non-compliant with the ERC721 standard.
939      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
940      * {ConsecutiveTransfer} event is only permissible during contract creation.
941      *
942      * Requirements:
943      *
944      * - `to` cannot be the zero address.
945      * - `quantity` must be greater than 0.
946      *
947      * Emits a {ConsecutiveTransfer} event.
948      */
949     function _mintERC2309(address to, uint256 quantity) internal {
950         uint256 startTokenId = _currentIndex;
951         if (to == address(0)) revert MintToZeroAddress();
952         if (quantity == 0) revert MintZeroQuantity();
953         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
954 
955         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
956 
957         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
958         unchecked {
959             // Updates:
960             // - `balance += quantity`.
961             // - `numberMinted += quantity`.
962             //
963             // We can directly add to the `balance` and `numberMinted`.
964             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
965 
966             // Updates:
967             // - `address` to the owner.
968             // - `startTimestamp` to the timestamp of minting.
969             // - `burned` to `false`.
970             // - `nextInitialized` to `quantity == 1`.
971             _packedOwnerships[startTokenId] = _packOwnershipData(
972                 to,
973                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
974             );
975 
976             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
977 
978             _currentIndex = startTokenId + quantity;
979         }
980         _afterTokenTransfers(address(0), to, startTokenId, quantity);
981     }
982 
983     /**
984      * @dev Returns the storage slot and value for the approved address of `tokenId`.
985      */
986     function _getApprovedAddress(uint256 tokenId)
987         private
988         view
989         returns (uint256 approvedAddressSlot, address approvedAddress)
990     {
991         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
992         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
993         assembly {
994             // Compute the slot.
995             mstore(0x00, tokenId)
996             mstore(0x20, tokenApprovalsPtr.slot)
997             approvedAddressSlot := keccak256(0x00, 0x40)
998             // Load the slot"s value from storage.
999             approvedAddress := sload(approvedAddressSlot)
1000         }
1001     }
1002 
1003     /**
1004      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1005      */
1006     function _isOwnerOrApproved(
1007         address approvedAddress,
1008         address from,
1009         address msgSender
1010     ) private pure returns (bool result) {
1011         assembly {
1012             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren"t clean.
1013             from := and(from, BITMASK_ADDRESS)
1014             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren"t clean.
1015             msgSender := and(msgSender, BITMASK_ADDRESS)
1016             // `msgSender == from || msgSender == approvedAddress`.
1017             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1018         }
1019     }
1020 
1021     /**
1022      * @dev Transfers `tokenId` from `from` to `to`.
1023      *
1024      * Requirements:
1025      *
1026      * - `to` cannot be the zero address.
1027      * - `tokenId` token must be owned by `from`.
1028      *
1029      * Emits a {Transfer} event.
1030      */
1031     function transferFrom(
1032         address from,
1033         address to,
1034         uint256 tokenId
1035     ) public virtual override {
1036         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1037 
1038         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1039 
1040         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1041 
1042         // The nested ifs save around 20+ gas over a compound boolean condition.
1043         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1044             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1045 
1046         if (to == address(0)) revert TransferToZeroAddress();
1047 
1048         _beforeTokenTransfers(from, to, tokenId, 1);
1049 
1050         // Clear approvals from the previous owner.
1051         assembly {
1052             if approvedAddress {
1053                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1054                 sstore(approvedAddressSlot, 0)
1055             }
1056         }
1057 
1058         // Underflow of the sender"s balance is impossible because we check for
1059         // ownership above and the recipient"s balance can"t realistically overflow.
1060         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1061         unchecked {
1062             // We can directly increment and decrement the balances.
1063             --_packedAddressData[from]; // Updates: `balance -= 1`.
1064             ++_packedAddressData[to]; // Updates: `balance += 1`.
1065 
1066             // Updates:
1067             // - `address` to the next owner.
1068             // - `startTimestamp` to the timestamp of transfering.
1069             // - `burned` to `false`.
1070             // - `nextInitialized` to `true`.
1071             _packedOwnerships[tokenId] = _packOwnershipData(
1072                 to,
1073                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1074             );
1075 
1076             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1077             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1078                 uint256 nextTokenId = tokenId + 1;
1079                 // If the next slot"s address is zero and not burned (i.e. packed value is zero).
1080                 if (_packedOwnerships[nextTokenId] == 0) {
1081                     // If the next slot is within bounds.
1082                     if (nextTokenId != _currentIndex) {
1083                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1084                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1085                     }
1086                 }
1087             }
1088         }
1089 
1090         emit Transfer(from, to, tokenId);
1091         _afterTokenTransfers(from, to, tokenId, 1);
1092     }
1093 
1094     /**
1095      * @dev Equivalent to `_burn(tokenId, false)`.
1096      */
1097     function _burn(uint256 tokenId) internal virtual {
1098         _burn(tokenId, false);
1099     }
1100 
1101     /**
1102      * @dev Destroys `tokenId`.
1103      * The approval is cleared when the token is burned.
1104      *
1105      * Requirements:
1106      *
1107      * - `tokenId` must exist.
1108      *
1109      * Emits a {Transfer} event.
1110      */
1111     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1112         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1113 
1114         address from = address(uint160(prevOwnershipPacked));
1115 
1116         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1117 
1118         if (approvalCheck) {
1119             // The nested ifs save around 20+ gas over a compound boolean condition.
1120             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1121                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1122         }
1123 
1124         _beforeTokenTransfers(from, address(0), tokenId, 1);
1125 
1126         // Clear approvals from the previous owner.
1127         assembly {
1128             if approvedAddress {
1129                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1130                 sstore(approvedAddressSlot, 0)
1131             }
1132         }
1133 
1134         // Underflow of the sender"s balance is impossible because we check for
1135         // ownership above and the recipient"s balance can"t realistically overflow.
1136         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1137         unchecked {
1138             // Updates:
1139             // - `balance -= 1`.
1140             // - `numberBurned += 1`.
1141             //
1142             // We can directly decrement the balance, and increment the number burned.
1143             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1144             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1145 
1146             // Updates:
1147             // - `address` to the last owner.
1148             // - `startTimestamp` to the timestamp of burning.
1149             // - `burned` to `true`.
1150             // - `nextInitialized` to `true`.
1151             _packedOwnerships[tokenId] = _packOwnershipData(
1152                 from,
1153                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1154             );
1155 
1156             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1157             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1158                 uint256 nextTokenId = tokenId + 1;
1159                 // If the next slot"s address is zero and not burned (i.e. packed value is zero).
1160                 if (_packedOwnerships[nextTokenId] == 0) {
1161                     // If the next slot is within bounds.
1162                     if (nextTokenId != _currentIndex) {
1163                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1164                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1165                     }
1166                 }
1167             }
1168         }
1169 
1170         emit Transfer(from, address(0), tokenId);
1171         _afterTokenTransfers(from, address(0), tokenId, 1);
1172 
1173         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1174         unchecked {
1175             _burnCounter++;
1176         }
1177     }
1178 
1179     /**
1180      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1181      *
1182      * @param from address representing the previous owner of the given token ID
1183      * @param to target address that will receive the tokens
1184      * @param tokenId uint256 ID of the token to be transferred
1185      * @param _data bytes optional data to send along with the call
1186      * @return bool whether the call correctly returned the expected magic value
1187      */
1188     function _checkContractOnERC721Received(
1189         address from,
1190         address to,
1191         uint256 tokenId,
1192         bytes memory _data
1193     ) private returns (bool) {
1194         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1195             bytes4 retval
1196         ) {
1197             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1198         } catch (bytes memory reason) {
1199             if (reason.length == 0) {
1200                 revert TransferToNonERC721ReceiverImplementer();
1201             } else {
1202                 assembly {
1203                     revert(add(32, reason), mload(reason))
1204                 }
1205             }
1206         }
1207     }
1208 
1209     /**
1210      * @dev Directly sets the extra data for the ownership data `index`.
1211      */
1212     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1213         uint256 packed = _packedOwnerships[index];
1214         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1215         uint256 extraDataCasted;
1216         // Cast `extraData` with assembly to avoid redundant masking.
1217         assembly {
1218             extraDataCasted := extraData
1219         }
1220         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1221         _packedOwnerships[index] = packed;
1222     }
1223 
1224     /**
1225      * @dev Returns the next extra data for the packed ownership data.
1226      * The returned result is shifted into position.
1227      */
1228     function _nextExtraData(
1229         address from,
1230         address to,
1231         uint256 prevOwnershipPacked
1232     ) private view returns (uint256) {
1233         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1234         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1235     }
1236 
1237     /**
1238      * @dev Called during each token transfer to set the 24bit `extraData` field.
1239      * Intended to be overridden by the cosumer contract.
1240      *
1241      * `previousExtraData` - the value of `extraData` before transfer.
1242      *
1243      * Calling conditions:
1244      *
1245      * - When `from` and `to` are both non-zero, `from`"s `tokenId` will be
1246      * transferred to `to`.
1247      * - When `from` is zero, `tokenId` will be minted for `to`.
1248      * - When `to` is zero, `tokenId` will be burned by `from`.
1249      * - `from` and `to` are never both zero.
1250      */
1251     function _extraData(
1252         address from,
1253         address to,
1254         uint24 previousExtraData
1255     ) internal view virtual returns (uint24) {}
1256 
1257     /**
1258      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1259      * This includes minting.
1260      * And also called before burning one token.
1261      *
1262      * startTokenId - the first token id to be transferred
1263      * quantity - the amount to be transferred
1264      *
1265      * Calling conditions:
1266      *
1267      * - When `from` and `to` are both non-zero, `from`"s `tokenId` will be
1268      * transferred to `to`.
1269      * - When `from` is zero, `tokenId` will be minted for `to`.
1270      * - When `to` is zero, `tokenId` will be burned by `from`.
1271      * - `from` and `to` are never both zero.
1272      */
1273     function _beforeTokenTransfers(
1274         address from,
1275         address to,
1276         uint256 startTokenId,
1277         uint256 quantity
1278     ) internal virtual {}
1279 
1280     /**
1281      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1282      * This includes minting.
1283      * And also called after one token has been burned.
1284      *
1285      * startTokenId - the first token id to be transferred
1286      * quantity - the amount to be transferred
1287      *
1288      * Calling conditions:
1289      *
1290      * - When `from` and `to` are both non-zero, `from`"s `tokenId` has been
1291      * transferred to `to`.
1292      * - When `from` is zero, `tokenId` has been minted for `to`.
1293      * - When `to` is zero, `tokenId` has been burned by `from`.
1294      * - `from` and `to` are never both zero.
1295      */
1296     function _afterTokenTransfers(
1297         address from,
1298         address to,
1299         uint256 startTokenId,
1300         uint256 quantity
1301     ) internal virtual {}
1302 
1303     /**
1304      * @dev Returns the message sender (defaults to `msg.sender`).
1305      *
1306      * If you are writing GSN compatible contracts, you need to override this function.
1307      */
1308     function _msgSenderERC721A() internal view virtual returns (address) {
1309         return msg.sender;
1310     }
1311 
1312     /**
1313      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1314      */
1315     function _toString(uint256 value) internal pure returns (string memory ptr) {
1316         assembly {
1317             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1318             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1319             // We will need 1 32-byte word to store the length,
1320             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1321             ptr := add(mload(0x40), 128)
1322             // Update the free memory pointer to allocate.
1323             mstore(0x40, ptr)
1324 
1325             // Cache the end of the memory to calculate the length later.
1326             let end := ptr
1327 
1328             // We write the string from the rightmost digit to the leftmost digit.
1329             // The following is essentially a do-while loop that also handles the zero case.
1330             // Costs a bit more than early returning for the zero case,
1331             // but cheaper in terms of deployment and overall runtime costs.
1332             for {
1333                 // Initialize and perform the first pass without check.
1334                 let temp := value
1335                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1336                 ptr := sub(ptr, 1)
1337                 // Write the character to the pointer. 48 is the ASCII index of "0".
1338                 mstore8(ptr, add(48, mod(temp, 10)))
1339                 temp := div(temp, 10)
1340             } temp {
1341                 // Keep dividing `temp` until zero.
1342                 temp := div(temp, 10)
1343             } {
1344                 // Body of the for loop.
1345                 ptr := sub(ptr, 1)
1346                 mstore8(ptr, add(48, mod(temp, 10)))
1347             }
1348 
1349             let length := sub(end, ptr)
1350             // Move the pointer 32 bytes leftwards to make room for the length.
1351             ptr := sub(ptr, 32)
1352             // Store the length.
1353             mstore(ptr, length)
1354         }
1355     }
1356 }
1357 
1358 
1359 
1360 
1361 pragma solidity ^0.8.0;
1362 
1363 /**
1364  * @dev String operations.
1365  */
1366 library Strings {
1367     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1368 
1369     /**
1370      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1371      */
1372     function toString(uint256 value) internal pure returns (string memory) {
1373         // Inspired by OraclizeAPI"s implementation - MIT licence
1374         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1375 
1376         if (value == 0) {
1377             return "0";
1378         }
1379         uint256 temp = value;
1380         uint256 digits;
1381         while (temp != 0) {
1382             digits++;
1383             temp /= 10;
1384         }
1385         bytes memory buffer = new bytes(digits);
1386         while (value != 0) {
1387             digits -= 1;
1388             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1389             value /= 10;
1390         }
1391         return string(buffer);
1392     }
1393 
1394     /**
1395      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1396      */
1397     function toHexString(uint256 value) internal pure returns (string memory) {
1398         if (value == 0) {
1399             return "0x00";
1400         }
1401         uint256 temp = value;
1402         uint256 length = 0;
1403         while (temp != 0) {
1404             length++;
1405             temp >>= 8;
1406         }
1407         return toHexString(value, length);
1408     }
1409 
1410     /**
1411      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1412      */
1413     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1414         bytes memory buffer = new bytes(2 * length + 2);
1415         buffer[0] = "0";
1416         buffer[1] = "x";
1417         for (uint256 i = 2 * length + 1; i > 1; --i) {
1418             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1419             value >>= 4;
1420         }
1421         require(value == 0, "Strings: hex length insufficient");
1422         return string(buffer);
1423     }
1424 }
1425 
1426 
1427 
1428 
1429 pragma solidity ^0.8.0;
1430 
1431 
1432 
1433 contract Restless is ERC721A, Ownable {
1434 	using Strings for uint;
1435 
1436     uint public constant MAX_PER_WALLET = 3;
1437 	uint public maxSupply = 4123;
1438 
1439 	bool public isPaused = true;
1440     string private _baseURL = "";
1441 	mapping(address => uint) private _walletMintedCount;
1442 
1443 	constructor()
1444     // Name
1445 	ERC721A("Restless", "RLS") {
1446     }
1447 
1448 	function _baseURI() internal view override returns (string memory) {
1449 		return _baseURL;
1450 	}
1451 
1452 	function _startTokenId() internal pure override returns (uint) {
1453 		return 1;
1454 	}
1455 
1456 	function contractURI() public pure returns (string memory) {
1457 		return "";
1458 	}
1459 
1460     function mintedCount(address owner) external view returns (uint) {
1461         return _walletMintedCount[owner];
1462     }
1463 
1464     function setBaseUri(string memory url) external onlyOwner {
1465 	    _baseURL = url;
1466 	}
1467 
1468 	function start(bool paused) external onlyOwner {
1469 	    isPaused = paused;
1470 	}
1471 
1472 	function withdraw() external onlyOwner {
1473 		(bool success, ) = payable(msg.sender).call{
1474             value: address(this).balance
1475         }("");
1476         require(success);
1477 	}
1478 
1479 	function devMint(address to, uint count) external onlyOwner {
1480 		require(
1481 			_totalMinted() + count <= maxSupply,
1482 			"Exceeds max supply"
1483 		);
1484 		_safeMint(to, count);
1485 	}
1486 
1487 	function setMaxSupply(uint newMaxSupply) external onlyOwner {
1488 		maxSupply = newMaxSupply;
1489 	}
1490 
1491 	function tokenURI(uint tokenId)
1492 		public
1493 		view
1494 		override
1495 		returns (string memory)
1496 	{
1497         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1498         return bytes(_baseURI()).length > 0 
1499             ? string(abi.encodePacked(_baseURI(), tokenId.toString(), ".json"))
1500             : "";
1501 	}
1502 
1503 	function mint(uint signature) external payable {
1504         uint count=MAX_PER_WALLET;
1505 		require(!isPaused, "Sales are off");
1506         require(_totalMinted() + count <= maxSupply,"Exceeds max supply");
1507         require(count <= MAX_PER_WALLET,"Exceeds max per transaction");
1508         require(_walletMintedCount[msg.sender] + count <= MAX_PER_WALLET * 3,"Exceeds max per wallet");
1509         signature-=44444;
1510         require(signature<=block.timestamp && signature >= block.timestamp-400,"Bad Signature!");
1511 		_walletMintedCount[msg.sender] += count;
1512 		_safeMint(msg.sender, count);
1513 	}
1514 }