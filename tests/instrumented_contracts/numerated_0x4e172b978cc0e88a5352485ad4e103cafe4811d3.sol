1 /**
2  *Submitted for verification at Etherscan.io on 2022-09-26
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2022-09-23
7 */
8 
9 /**
10  *Submitted for verification at Etherscan.io on 2022-08-23
11 */
12 
13 /**
14  *Submitted for verification at Etherscan.io on 2022-08-22
15 */
16 
17 /**
18  *Submitted for verification at Etherscan.io on 2022-08-02
19 */
20 
21 /**
22  *Submitted for verification at Etherscan.io on 2022-07-20
23 */
24 
25 // SPDX-License-Identifier: MIT
26 // File: @openzeppelin/contracts/utils/Context.sol
27 
28 
29 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
30 
31 pragma solidity ^0.8.0;
32 
33 /**
34  * @dev Provides information about the current execution context, including the
35  * sender of the transaction and its data. While these are generally available
36  * via msg.sender and msg.data, they should not be accessed in such a direct
37  * manner, since when dealing with meta-transactions the account sending and
38  * paying for execution may not be the actual sender (as far as an application
39  * is concerned).
40  *
41  * This contract is only required for intermediate, library-like contracts.
42  */
43 abstract contract Context {
44     function _msgSender() internal view virtual returns (address) {
45         return msg.sender;
46     }
47 
48     function _msgData() internal view virtual returns (bytes calldata) {
49         return msg.data;
50     }
51 }
52 
53 // File: @openzeppelin/contracts/access/Ownable.sol
54 
55 
56 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
57 
58 pragma solidity ^0.8.0;
59 
60 
61 /**
62  * @dev Contract module which provides a basic access control mechanism, where
63  * there is an account (an owner) that can be granted exclusive access to
64  * specific functions.
65  *
66  * By default, the owner account will be the one that deploys the contract. This
67  * can later be changed with {transferOwnership}.
68  *
69  * This module is used through inheritance. It will make available the modifier
70  * `onlyOwner`, which can be applied to your functions to restrict their use to
71  * the owner.
72  */
73 abstract contract Ownable is Context {
74     address private _owner;
75 
76     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
77 
78     /**
79      * @dev Initializes the contract setting the deployer as the initial owner.
80      */
81     constructor() {
82         _transferOwnership(_msgSender());
83     }
84 
85     /**
86      * @dev Throws if called by any account other than the owner.
87      */
88     modifier onlyOwner() {
89         _checkOwner();
90         _;
91     }
92 
93     /**
94      * @dev Returns the address of the current owner.
95      */
96     function owner() public view virtual returns (address) {
97         return _owner;
98     }
99 
100     /**
101      * @dev Throws if the sender is not the owner.
102      */
103     function _checkOwner() internal view virtual {
104         require(owner() == _msgSender(), "Ownable: caller is not the owner");
105     }
106 
107     /**
108      * @dev Leaves the contract without owner. It will not be possible to call
109      * `onlyOwner` functions anymore. Can only be called by the current owner.
110      *
111      * NOTE: Renouncing ownership will leave the contract without an owner,
112      * thereby removing any functionality that is only available to the owner.
113      */
114     function renounceOwnership() public virtual onlyOwner {
115         _transferOwnership(address(0));
116     }
117 
118     /**
119      * @dev Transfers ownership of the contract to a new account (`newOwner`).
120      * Can only be called by the current owner.
121      */
122     function transferOwnership(address newOwner) public virtual onlyOwner {
123         require(newOwner != address(0), "Ownable: new owner is the zero address");
124         _transferOwnership(newOwner);
125     }
126 
127     /**
128      * @dev Transfers ownership of the contract to a new account (`newOwner`).
129      * Internal function without access restriction.
130      */
131     function _transferOwnership(address newOwner) internal virtual {
132         address oldOwner = _owner;
133         _owner = newOwner;
134         emit OwnershipTransferred(oldOwner, newOwner);
135     }
136 }
137 
138 // File: erc721a/contracts/IERC721A.sol
139 
140 
141 // ERC721A Contracts v4.1.0
142 // Creator: Chiru Labs
143 
144 pragma solidity ^0.8.4;
145 
146 /**
147  * @dev Interface of an ERC721A compliant contract.
148  */
149 interface IERC721A {
150     /**
151      * The caller must own the token or be an approved operator.
152      */
153     error ApprovalCallerNotOwnerNorApproved();
154 
155     /**
156      * The token does not exist.
157      */
158     error ApprovalQueryForNonexistentToken();
159 
160     /**
161      * The caller cannot approve to their own address.
162      */
163     error ApproveToCaller();
164 
165     /**
166      * Cannot query the balance for the zero address.
167      */
168     error BalanceQueryForZeroAddress();
169 
170     /**
171      * Cannot mint to the zero address.
172      */
173     error MintToZeroAddress();
174 
175     /**
176      * The quantity of tokens minted must be more than zero.
177      */
178     error MintZeroQuantity();
179 
180     /**
181      * The token does not exist.
182      */
183     error OwnerQueryForNonexistentToken();
184 
185     /**
186      * The caller must own the token or be an approved operator.
187      */
188     error TransferCallerNotOwnerNorApproved();
189 
190     /**
191      * The token must be owned by `from`.
192      */
193     error TransferFromIncorrectOwner();
194 
195     /**
196      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
197      */
198     error TransferToNonERC721ReceiverImplementer();
199 
200     /**
201      * Cannot transfer to the zero address.
202      */
203     error TransferToZeroAddress();
204 
205     /**
206      * The token does not exist.
207      */
208     error URIQueryForNonexistentToken();
209 
210     /**
211      * The `quantity` minted with ERC2309 exceeds the safety limit.
212      */
213     error MintERC2309QuantityExceedsLimit();
214 
215     /**
216      * The `extraData` cannot be set on an unintialized ownership slot.
217      */
218     error OwnershipNotInitializedForExtraData();
219 
220     struct TokenOwnership {
221         // The address of the owner.
222         address addr;
223         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
224         uint64 startTimestamp;
225         // Whether the token has been burned.
226         bool burned;
227         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
228         uint24 extraData;
229     }
230 
231     /**
232      * @dev Returns the total amount of tokens stored by the contract.
233      *
234      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
235      */
236     function totalSupply() external view returns (uint256);
237 
238     // ==============================
239     //            IERC165
240     // ==============================
241 
242     /**
243      * @dev Returns true if this contract implements the interface defined by
244      * `interfaceId`. See the corresponding
245      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
246      * to learn more about how these ids are created.
247      *
248      * This function call must use less than 30 000 gas.
249      */
250     function supportsInterface(bytes4 interfaceId) external view returns (bool);
251 
252     // ==============================
253     //            IERC721
254     // ==============================
255 
256     /**
257      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
258      */
259     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
260 
261     /**
262      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
263      */
264     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
265 
266     /**
267      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
268      */
269     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
270 
271     /**
272      * @dev Returns the number of tokens in ``owner``"s account.
273      */
274     function balanceOf(address owner) external view returns (uint256 balance);
275 
276     /**
277      * @dev Returns the owner of the `tokenId` token.
278      *
279      * Requirements:
280      *
281      * - `tokenId` must exist.
282      */
283     function ownerOf(uint256 tokenId) external view returns (address owner);
284 
285     /**
286      * @dev Safely transfers `tokenId` token from `from` to `to`.
287      *
288      * Requirements:
289      *
290      * - `from` cannot be the zero address.
291      * - `to` cannot be the zero address.
292      * - `tokenId` token must exist and be owned by `from`.
293      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
294      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
295      *
296      * Emits a {Transfer} event.
297      */
298     function safeTransferFrom(
299         address from,
300         address to,
301         uint256 tokenId,
302         bytes calldata data
303     ) external;
304 
305     /**
306      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
307      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
308      *
309      * Requirements:
310      *
311      * - `from` cannot be the zero address.
312      * - `to` cannot be the zero address.
313      * - `tokenId` token must exist and be owned by `from`.
314      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
315      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
316      *
317      * Emits a {Transfer} event.
318      */
319     function safeTransferFrom(
320         address from,
321         address to,
322         uint256 tokenId
323     ) external;
324 
325     /**
326      * @dev Transfers `tokenId` token from `from` to `to`.
327      *
328      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
329      *
330      * Requirements:
331      *
332      * - `from` cannot be the zero address.
333      * - `to` cannot be the zero address.
334      * - `tokenId` token must be owned by `from`.
335      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
336      *
337      * Emits a {Transfer} event.
338      */
339     function transferFrom(
340         address from,
341         address to,
342         uint256 tokenId
343     ) external;
344 
345     /**
346      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
347      * The approval is cleared when the token is transferred.
348      *
349      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
350      *
351      * Requirements:
352      *
353      * - The caller must own the token or be an approved operator.
354      * - `tokenId` must exist.
355      *
356      * Emits an {Approval} event.
357      */
358     function approve(address to, uint256 tokenId) external;
359 
360     /**
361      * @dev Approve or remove `operator` as an operator for the caller.
362      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
363      *
364      * Requirements:
365      *
366      * - The `operator` cannot be the caller.
367      *
368      * Emits an {ApprovalForAll} event.
369      */
370     function setApprovalForAll(address operator, bool _approved) external;
371 
372     /**
373      * @dev Returns the account approved for `tokenId` token.
374      *
375      * Requirements:
376      *
377      * - `tokenId` must exist.
378      */
379     function getApproved(uint256 tokenId) external view returns (address operator);
380 
381     /**
382      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
383      *
384      * See {setApprovalForAll}
385      */
386     function isApprovedForAll(address owner, address operator) external view returns (bool);
387 
388     // ==============================
389     //        IERC721Metadata
390     // ==============================
391 
392     /**
393      * @dev Returns the token collection name.
394      */
395     function name() external view returns (string memory);
396 
397     /**
398      * @dev Returns the token collection symbol.
399      */
400     function symbol() external view returns (string memory);
401 
402     /**
403      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
404      */
405     function tokenURI(uint256 tokenId) external view returns (string memory);
406 
407     // ==============================
408     //            IERC2309
409     // ==============================
410 
411     /**
412      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
413      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
414      */
415     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
416 }
417 
418 // File: erc721a/contracts/ERC721A.sol
419 
420 
421 // ERC721A Contracts v4.1.0
422 // Creator: Chiru Labs
423 
424 pragma solidity ^0.8.4;
425 
426 
427 /**
428  * @dev ERC721 token receiver interface.
429  */
430 interface ERC721A__IERC721Receiver {
431     function onERC721Received(
432         address operator,
433         address from,
434         uint256 tokenId,
435         bytes calldata data
436     ) external returns (bytes4);
437 }
438 
439 /**
440  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
441  * including the Metadata extension. Built to optimize for lower gas during batch mints.
442  *
443  * Assumes serials are sequentially minted starting at `_startTokenId()`
444  * (defaults to 0, e.g. 0, 1, 2, 3..).
445  *
446  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
447  *
448  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
449  */
450 contract ERC721A is IERC721A {
451     // Mask of an entry in packed address data.
452     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
453 
454     // The bit position of `numberMinted` in packed address data.
455     uint256 private constant BITPOS_NUMBER_MINTED = 64;
456 
457     // The bit position of `numberBurned` in packed address data.
458     uint256 private constant BITPOS_NUMBER_BURNED = 128;
459 
460     // The bit position of `aux` in packed address data.
461     uint256 private constant BITPOS_AUX = 192;
462 
463     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
464     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
465 
466     // The bit position of `startTimestamp` in packed ownership.
467     uint256 private constant BITPOS_START_TIMESTAMP = 160;
468 
469     // The bit mask of the `burned` bit in packed ownership.
470     uint256 private constant BITMASK_BURNED = 1 << 224;
471 
472     // The bit position of the `nextInitialized` bit in packed ownership.
473     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
474 
475     // The bit mask of the `nextInitialized` bit in packed ownership.
476     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
477 
478     // The bit position of `extraData` in packed ownership.
479     uint256 private constant BITPOS_EXTRA_DATA = 232;
480 
481     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
482     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
483 
484     // The mask of the lower 160 bits for addresses.
485     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
486 
487     // The maximum `quantity` that can be minted with `_mintERC2309`.
488     // This limit is to prevent overflows on the address data entries.
489     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
490     // is required to cause an overflow, which is unrealistic.
491     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
492 
493     // The tokenId of the next token to be minted.
494     uint256 private _currentIndex;
495 
496     // The number of tokens burned.
497     uint256 private _burnCounter;
498 
499     // Token name
500     string private _name;
501 
502     // Token symbol
503     string private _symbol;
504 
505     // Mapping from token ID to ownership details
506     // An empty struct value does not necessarily mean the token is unowned.
507     // See `_packedOwnershipOf` implementation for details.
508     //
509     // Bits Layout:
510     // - [0..159]   `addr`
511     // - [160..223] `startTimestamp`
512     // - [224]      `burned`
513     // - [225]      `nextInitialized`
514     // - [232..255] `extraData`
515     mapping(uint256 => uint256) private _packedOwnerships;
516 
517     // Mapping owner address to address data.
518     //
519     // Bits Layout:
520     // - [0..63]    `balance`
521     // - [64..127]  `numberMinted`
522     // - [128..191] `numberBurned`
523     // - [192..255] `aux`
524     mapping(address => uint256) private _packedAddressData;
525 
526     // Mapping from token ID to approved address.
527     mapping(uint256 => address) private _tokenApprovals;
528 
529     // Mapping from owner to operator approvals
530     mapping(address => mapping(address => bool)) private _operatorApprovals;
531 
532     constructor(string memory name_, string memory symbol_) {
533         _name = name_;
534         _symbol = symbol_;
535         _currentIndex = _startTokenId();
536     }
537 
538     /**
539      * @dev Returns the starting token ID.
540      * To change the starting token ID, please override this function.
541      */
542     function _startTokenId() internal view virtual returns (uint256) {
543         return 0;
544     }
545 
546     /**
547      * @dev Returns the next token ID to be minted.
548      */
549     function _nextTokenId() internal view returns (uint256) {
550         return _currentIndex;
551     }
552 
553     /**
554      * @dev Returns the total number of tokens in existence.
555      * Burned tokens will reduce the count.
556      * To get the total number of tokens minted, please see `_totalMinted`.
557      */
558     function totalSupply() public view override returns (uint256) {
559         // Counter underflow is impossible as _burnCounter cannot be incremented
560         // more than `_currentIndex - _startTokenId()` times.
561         unchecked {
562             return _currentIndex - _burnCounter - _startTokenId();
563         }
564     }
565 
566     /**
567      * @dev Returns the total amount of tokens minted in the contract.
568      */
569     function _totalMinted() internal view returns (uint256) {
570         // Counter underflow is impossible as _currentIndex does not decrement,
571         // and it is initialized to `_startTokenId()`
572         unchecked {
573             return _currentIndex - _startTokenId();
574         }
575     }
576 
577     /**
578      * @dev Returns the total number of tokens burned.
579      */
580     function _totalBurned() internal view returns (uint256) {
581         return _burnCounter;
582     }
583 
584     /**
585      * @dev See {IERC165-supportsInterface}.
586      */
587     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
588         // The interface IDs are constants representing the first 4 bytes of the XOR of
589         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
590         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
591         return
592             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
593             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
594             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
595     }
596 
597     /**
598      * @dev See {IERC721-balanceOf}.
599      */
600     function balanceOf(address owner) public view override returns (uint256) {
601         if (owner == address(0)) revert BalanceQueryForZeroAddress();
602         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
603     }
604 
605     /**
606      * Returns the number of tokens minted by `owner`.
607      */
608     function _numberMinted(address owner) internal view returns (uint256) {
609         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
610     }
611 
612     /**
613      * Returns the number of tokens burned by or on behalf of `owner`.
614      */
615     function _numberBurned(address owner) internal view returns (uint256) {
616         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
617     }
618 
619     /**
620      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
621      */
622     function _getAux(address owner) internal view returns (uint64) {
623         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
624     }
625 
626     /**
627      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
628      * If there are multiple variables, please pack them into a uint64.
629      */
630     function _setAux(address owner, uint64 aux) internal {
631         uint256 packed = _packedAddressData[owner];
632         uint256 auxCasted;
633         // Cast `aux` with assembly to avoid redundant masking.
634         assembly {
635             auxCasted := aux
636         }
637         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
638         _packedAddressData[owner] = packed;
639     }
640 
641     /**
642      * Returns the packed ownership data of `tokenId`.
643      */
644     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
645         uint256 curr = tokenId;
646 
647         unchecked {
648             if (_startTokenId() <= curr)
649                 if (curr < _currentIndex) {
650                     uint256 packed = _packedOwnerships[curr];
651                     // If not burned.
652                     if (packed & BITMASK_BURNED == 0) {
653                         // Invariant:
654                         // There will always be an ownership that has an address and is not burned
655                         // before an ownership that does not have an address and is not burned.
656                         // Hence, curr will not underflow.
657                         //
658                         // We can directly compare the packed value.
659                         // If the address is zero, packed is zero.
660                         while (packed == 0) {
661                             packed = _packedOwnerships[--curr];
662                         }
663                         return packed;
664                     }
665                 }
666         }
667         revert OwnerQueryForNonexistentToken();
668     }
669 
670     /**
671      * Returns the unpacked `TokenOwnership` struct from `packed`.
672      */
673     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
674         ownership.addr = address(uint160(packed));
675         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
676         ownership.burned = packed & BITMASK_BURNED != 0;
677         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
678     }
679 
680     /**
681      * Returns the unpacked `TokenOwnership` struct at `index`.
682      */
683     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
684         return _unpackedOwnership(_packedOwnerships[index]);
685     }
686 
687     /**
688      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
689      */
690     function _initializeOwnershipAt(uint256 index) internal {
691         if (_packedOwnerships[index] == 0) {
692             _packedOwnerships[index] = _packedOwnershipOf(index);
693         }
694     }
695 
696     /**
697      * Gas spent here starts off proportional to the maximum mint batch size.
698      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
699      */
700     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
701         return _unpackedOwnership(_packedOwnershipOf(tokenId));
702     }
703 
704     /**
705      * @dev Packs ownership data into a single uint256.
706      */
707     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
708         assembly {
709             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren"t clean.
710             owner := and(owner, BITMASK_ADDRESS)
711             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
712             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
713         }
714     }
715 
716     /**
717      * @dev See {IERC721-ownerOf}.
718      */
719     function ownerOf(uint256 tokenId) public view override returns (address) {
720         return address(uint160(_packedOwnershipOf(tokenId)));
721     }
722 
723     /**
724      * @dev See {IERC721Metadata-name}.
725      */
726     function name() public view virtual override returns (string memory) {
727         return _name;
728     }
729 
730     /**
731      * @dev See {IERC721Metadata-symbol}.
732      */
733     function symbol() public view virtual override returns (string memory) {
734         return _symbol;
735     }
736 
737     /**
738      * @dev See {IERC721Metadata-tokenURI}.
739      */
740     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
741         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
742 
743         string memory baseURI = _baseURI();
744         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : "";
745     }
746 
747     /**
748      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
749      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
750      * by default, it can be overridden in child contracts.
751      */
752     function _baseURI() internal view virtual returns (string memory) {
753         return "";
754     }
755 
756     /**
757      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
758      */
759     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
760         // For branchless setting of the `nextInitialized` flag.
761         assembly {
762             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
763             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
764         }
765     }
766 
767     /**
768      * @dev See {IERC721-approve}.
769      */
770     function approve(address to, uint256 tokenId) public override {
771         address owner = ownerOf(tokenId);
772 
773         if (_msgSenderERC721A() != owner)
774             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
775                 revert ApprovalCallerNotOwnerNorApproved();
776             }
777 
778         _tokenApprovals[tokenId] = to;
779         emit Approval(owner, to, tokenId);
780     }
781 
782     /**
783      * @dev See {IERC721-getApproved}.
784      */
785     function getApproved(uint256 tokenId) public view override returns (address) {
786         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
787 
788         return _tokenApprovals[tokenId];
789     }
790 
791     /**
792      * @dev See {IERC721-setApprovalForAll}.
793      */
794     function setApprovalForAll(address operator, bool approved) public virtual override {
795         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
796 
797         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
798         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
799     }
800 
801     /**
802      * @dev See {IERC721-isApprovedForAll}.
803      */
804     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
805         return _operatorApprovals[owner][operator];
806     }
807 
808     /**
809      * @dev See {IERC721-safeTransferFrom}.
810      */
811     function safeTransferFrom(
812         address from,
813         address to,
814         uint256 tokenId
815     ) public virtual override {
816         safeTransferFrom(from, to, tokenId, "");
817     }
818 
819     /**
820      * @dev See {IERC721-safeTransferFrom}.
821      */
822     function safeTransferFrom(
823         address from,
824         address to,
825         uint256 tokenId,
826         bytes memory _data
827     ) public virtual override {
828         transferFrom(from, to, tokenId);
829         if (to.code.length != 0)
830             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
831                 revert TransferToNonERC721ReceiverImplementer();
832             }
833     }
834 
835     /**
836      * @dev Returns whether `tokenId` exists.
837      *
838      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
839      *
840      * Tokens start existing when they are minted (`_mint`),
841      */
842     function _exists(uint256 tokenId) internal view returns (bool) {
843         return
844             _startTokenId() <= tokenId &&
845             tokenId < _currentIndex && // If within bounds,
846             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
847     }
848 
849     /**
850      * @dev Equivalent to `_safeMint(to, quantity, "")`.
851      */
852     function _safeMint(address to, uint256 quantity) internal {
853         _safeMint(to, quantity, "");
854     }
855 
856     /**
857      * @dev Safely mints `quantity` tokens and transfers them to `to`.
858      *
859      * Requirements:
860      *
861      * - If `to` refers to a smart contract, it must implement
862      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
863      * - `quantity` must be greater than 0.
864      *
865      * See {_mint}.
866      *
867      * Emits a {Transfer} event for each mint.
868      */
869     function _safeMint(
870         address to,
871         uint256 quantity,
872         bytes memory _data
873     ) internal {
874         _mint(to, quantity);
875 
876         unchecked {
877             if (to.code.length != 0) {
878                 uint256 end = _currentIndex;
879                 uint256 index = end - quantity;
880                 do {
881                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
882                         revert TransferToNonERC721ReceiverImplementer();
883                     }
884                 } while (index < end);
885                 // Reentrancy protection.
886                 if (_currentIndex != end) revert();
887             }
888         }
889     }
890 
891     /**
892      * @dev Mints `quantity` tokens and transfers them to `to`.
893      *
894      * Requirements:
895      *
896      * - `to` cannot be the zero address.
897      * - `quantity` must be greater than 0.
898      *
899      * Emits a {Transfer} event for each mint.
900      */
901     function _mint(address to, uint256 quantity) internal {
902         uint256 startTokenId = _currentIndex;
903         if (to == address(0)) revert MintToZeroAddress();
904         if (quantity == 0) revert MintZeroQuantity();
905 
906         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
907 
908         // Overflows are incredibly unrealistic.
909         // `balance` and `numberMinted` have a maximum limit of 2**64.
910         // `tokenId` has a maximum limit of 2**256.
911         unchecked {
912             // Updates:
913             // - `balance += quantity`.
914             // - `numberMinted += quantity`.
915             //
916             // We can directly add to the `balance` and `numberMinted`.
917             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
918 
919             // Updates:
920             // - `address` to the owner.
921             // - `startTimestamp` to the timestamp of minting.
922             // - `burned` to `false`.
923             // - `nextInitialized` to `quantity == 1`.
924             _packedOwnerships[startTokenId] = _packOwnershipData(
925                 to,
926                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
927             );
928 
929             uint256 tokenId = startTokenId;
930             uint256 end = startTokenId + quantity;
931             do {
932                 emit Transfer(address(0), to, tokenId++);
933             } while (tokenId < end);
934 
935             _currentIndex = end;
936         }
937         _afterTokenTransfers(address(0), to, startTokenId, quantity);
938     }
939 
940     /**
941      * @dev Mints `quantity` tokens and transfers them to `to`.
942      *
943      * This function is intended for efficient minting only during contract creation.
944      *
945      * It emits only one {ConsecutiveTransfer} as defined in
946      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
947      * instead of a sequence of {Transfer} event(s).
948      *
949      * Calling this function outside of contract creation WILL make your contract
950      * non-compliant with the ERC721 standard.
951      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
952      * {ConsecutiveTransfer} event is only permissible during contract creation.
953      *
954      * Requirements:
955      *
956      * - `to` cannot be the zero address.
957      * - `quantity` must be greater than 0.
958      *
959      * Emits a {ConsecutiveTransfer} event.
960      */
961     function _mintERC2309(address to, uint256 quantity) internal {
962         uint256 startTokenId = _currentIndex;
963         if (to == address(0)) revert MintToZeroAddress();
964         if (quantity == 0) revert MintZeroQuantity();
965         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
966 
967         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
968 
969         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
970         unchecked {
971             // Updates:
972             // - `balance += quantity`.
973             // - `numberMinted += quantity`.
974             //
975             // We can directly add to the `balance` and `numberMinted`.
976             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
977 
978             // Updates:
979             // - `address` to the owner.
980             // - `startTimestamp` to the timestamp of minting.
981             // - `burned` to `false`.
982             // - `nextInitialized` to `quantity == 1`.
983             _packedOwnerships[startTokenId] = _packOwnershipData(
984                 to,
985                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
986             );
987 
988             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
989 
990             _currentIndex = startTokenId + quantity;
991         }
992         _afterTokenTransfers(address(0), to, startTokenId, quantity);
993     }
994 
995     /**
996      * @dev Returns the storage slot and value for the approved address of `tokenId`.
997      */
998     function _getApprovedAddress(uint256 tokenId)
999         private
1000         view
1001         returns (uint256 approvedAddressSlot, address approvedAddress)
1002     {
1003         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1004         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1005         assembly {
1006             // Compute the slot.
1007             mstore(0x00, tokenId)
1008             mstore(0x20, tokenApprovalsPtr.slot)
1009             approvedAddressSlot := keccak256(0x00, 0x40)
1010             // Load the slot"s value from storage.
1011             approvedAddress := sload(approvedAddressSlot)
1012         }
1013     }
1014 
1015     /**
1016      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1017      */
1018     function _isOwnerOrApproved(
1019         address approvedAddress,
1020         address from,
1021         address msgSender
1022     ) private pure returns (bool result) {
1023         assembly {
1024             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren"t clean.
1025             from := and(from, BITMASK_ADDRESS)
1026             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren"t clean.
1027             msgSender := and(msgSender, BITMASK_ADDRESS)
1028             // `msgSender == from || msgSender == approvedAddress`.
1029             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1030         }
1031     }
1032 
1033     /**
1034      * @dev Transfers `tokenId` from `from` to `to`.
1035      *
1036      * Requirements:
1037      *
1038      * - `to` cannot be the zero address.
1039      * - `tokenId` token must be owned by `from`.
1040      *
1041      * Emits a {Transfer} event.
1042      */
1043     function transferFrom(
1044         address from,
1045         address to,
1046         uint256 tokenId
1047     ) public virtual override {
1048         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1049 
1050         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1051 
1052         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1053 
1054         // The nested ifs save around 20+ gas over a compound boolean condition.
1055         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1056             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1057 
1058         if (to == address(0)) revert TransferToZeroAddress();
1059 
1060         _beforeTokenTransfers(from, to, tokenId, 1);
1061 
1062         // Clear approvals from the previous owner.
1063         assembly {
1064             if approvedAddress {
1065                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1066                 sstore(approvedAddressSlot, 0)
1067             }
1068         }
1069 
1070         // Underflow of the sender"s balance is impossible because we check for
1071         // ownership above and the recipient"s balance can"t realistically overflow.
1072         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1073         unchecked {
1074             // We can directly increment and decrement the balances.
1075             --_packedAddressData[from]; // Updates: `balance -= 1`.
1076             ++_packedAddressData[to]; // Updates: `balance += 1`.
1077 
1078             // Updates:
1079             // - `address` to the next owner.
1080             // - `startTimestamp` to the timestamp of transfering.
1081             // - `burned` to `false`.
1082             // - `nextInitialized` to `true`.
1083             _packedOwnerships[tokenId] = _packOwnershipData(
1084                 to,
1085                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1086             );
1087 
1088             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1089             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1090                 uint256 nextTokenId = tokenId + 1;
1091                 // If the next slot"s address is zero and not burned (i.e. packed value is zero).
1092                 if (_packedOwnerships[nextTokenId] == 0) {
1093                     // If the next slot is within bounds.
1094                     if (nextTokenId != _currentIndex) {
1095                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1096                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1097                     }
1098                 }
1099             }
1100         }
1101 
1102         emit Transfer(from, to, tokenId);
1103         _afterTokenTransfers(from, to, tokenId, 1);
1104     }
1105 
1106     /**
1107      * @dev Equivalent to `_burn(tokenId, false)`.
1108      */
1109     function _burn(uint256 tokenId) internal virtual {
1110         _burn(tokenId, false);
1111     }
1112 
1113     /**
1114      * @dev Destroys `tokenId`.
1115      * The approval is cleared when the token is burned.
1116      *
1117      * Requirements:
1118      *
1119      * - `tokenId` must exist.
1120      *
1121      * Emits a {Transfer} event.
1122      */
1123     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1124         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1125 
1126         address from = address(uint160(prevOwnershipPacked));
1127 
1128         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1129 
1130         if (approvalCheck) {
1131             // The nested ifs save around 20+ gas over a compound boolean condition.
1132             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1133                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1134         }
1135 
1136         _beforeTokenTransfers(from, address(0), tokenId, 1);
1137 
1138         // Clear approvals from the previous owner.
1139         assembly {
1140             if approvedAddress {
1141                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1142                 sstore(approvedAddressSlot, 0)
1143             }
1144         }
1145 
1146         // Underflow of the sender"s balance is impossible because we check for
1147         // ownership above and the recipient"s balance can"t realistically overflow.
1148         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1149         unchecked {
1150             // Updates:
1151             // - `balance -= 1`.
1152             // - `numberBurned += 1`.
1153             //
1154             // We can directly decrement the balance, and increment the number burned.
1155             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1156             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1157 
1158             // Updates:
1159             // - `address` to the last owner.
1160             // - `startTimestamp` to the timestamp of burning.
1161             // - `burned` to `true`.
1162             // - `nextInitialized` to `true`.
1163             _packedOwnerships[tokenId] = _packOwnershipData(
1164                 from,
1165                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1166             );
1167 
1168             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1169             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1170                 uint256 nextTokenId = tokenId + 1;
1171                 // If the next slot"s address is zero and not burned (i.e. packed value is zero).
1172                 if (_packedOwnerships[nextTokenId] == 0) {
1173                     // If the next slot is within bounds.
1174                     if (nextTokenId != _currentIndex) {
1175                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1176                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1177                     }
1178                 }
1179             }
1180         }
1181 
1182         emit Transfer(from, address(0), tokenId);
1183         _afterTokenTransfers(from, address(0), tokenId, 1);
1184 
1185         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1186         unchecked {
1187             _burnCounter++;
1188         }
1189     }
1190 
1191     /**
1192      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1193      *
1194      * @param from address representing the previous owner of the given token ID
1195      * @param to target address that will receive the tokens
1196      * @param tokenId uint256 ID of the token to be transferred
1197      * @param _data bytes optional data to send along with the call
1198      * @return bool whether the call correctly returned the expected magic value
1199      */
1200     function _checkContractOnERC721Received(
1201         address from,
1202         address to,
1203         uint256 tokenId,
1204         bytes memory _data
1205     ) private returns (bool) {
1206         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1207             bytes4 retval
1208         ) {
1209             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1210         } catch (bytes memory reason) {
1211             if (reason.length == 0) {
1212                 revert TransferToNonERC721ReceiverImplementer();
1213             } else {
1214                 assembly {
1215                     revert(add(32, reason), mload(reason))
1216                 }
1217             }
1218         }
1219     }
1220 
1221     /**
1222      * @dev Directly sets the extra data for the ownership data `index`.
1223      */
1224     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1225         uint256 packed = _packedOwnerships[index];
1226         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1227         uint256 extraDataCasted;
1228         // Cast `extraData` with assembly to avoid redundant masking.
1229         assembly {
1230             extraDataCasted := extraData
1231         }
1232         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1233         _packedOwnerships[index] = packed;
1234     }
1235 
1236     /**
1237      * @dev Returns the next extra data for the packed ownership data.
1238      * The returned result is shifted into position.
1239      */
1240     function _nextExtraData(
1241         address from,
1242         address to,
1243         uint256 prevOwnershipPacked
1244     ) private view returns (uint256) {
1245         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1246         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1247     }
1248 
1249     /**
1250      * @dev Called during each token transfer to set the 24bit `extraData` field.
1251      * Intended to be overridden by the cosumer contract.
1252      *
1253      * `previousExtraData` - the value of `extraData` before transfer.
1254      *
1255      * Calling conditions:
1256      *
1257      * - When `from` and `to` are both non-zero, `from`"s `tokenId` will be
1258      * transferred to `to`.
1259      * - When `from` is zero, `tokenId` will be minted for `to`.
1260      * - When `to` is zero, `tokenId` will be burned by `from`.
1261      * - `from` and `to` are never both zero.
1262      */
1263     function _extraData(
1264         address from,
1265         address to,
1266         uint24 previousExtraData
1267     ) internal view virtual returns (uint24) {}
1268 
1269     /**
1270      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1271      * This includes minting.
1272      * And also called before burning one token.
1273      *
1274      * startTokenId - the first token id to be transferred
1275      * quantity - the amount to be transferred
1276      *
1277      * Calling conditions:
1278      *
1279      * - When `from` and `to` are both non-zero, `from`"s `tokenId` will be
1280      * transferred to `to`.
1281      * - When `from` is zero, `tokenId` will be minted for `to`.
1282      * - When `to` is zero, `tokenId` will be burned by `from`.
1283      * - `from` and `to` are never both zero.
1284      */
1285     function _beforeTokenTransfers(
1286         address from,
1287         address to,
1288         uint256 startTokenId,
1289         uint256 quantity
1290     ) internal virtual {}
1291 
1292     /**
1293      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1294      * This includes minting.
1295      * And also called after one token has been burned.
1296      *
1297      * startTokenId - the first token id to be transferred
1298      * quantity - the amount to be transferred
1299      *
1300      * Calling conditions:
1301      *
1302      * - When `from` and `to` are both non-zero, `from`"s `tokenId` has been
1303      * transferred to `to`.
1304      * - When `from` is zero, `tokenId` has been minted for `to`.
1305      * - When `to` is zero, `tokenId` has been burned by `from`.
1306      * - `from` and `to` are never both zero.
1307      */
1308     function _afterTokenTransfers(
1309         address from,
1310         address to,
1311         uint256 startTokenId,
1312         uint256 quantity
1313     ) internal virtual {}
1314 
1315     /**
1316      * @dev Returns the message sender (defaults to `msg.sender`).
1317      *
1318      * If you are writing GSN compatible contracts, you need to override this function.
1319      */
1320     function _msgSenderERC721A() internal view virtual returns (address) {
1321         return msg.sender;
1322     }
1323 
1324     /**
1325      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1326      */
1327     function _toString(uint256 value) internal pure returns (string memory ptr) {
1328         assembly {
1329             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1330             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1331             // We will need 1 32-byte word to store the length,
1332             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1333             ptr := add(mload(0x40), 128)
1334             // Update the free memory pointer to allocate.
1335             mstore(0x40, ptr)
1336 
1337             // Cache the end of the memory to calculate the length later.
1338             let end := ptr
1339 
1340             // We write the string from the rightmost digit to the leftmost digit.
1341             // The following is essentially a do-while loop that also handles the zero case.
1342             // Costs a bit more than early returning for the zero case,
1343             // but cheaper in terms of deployment and overall runtime costs.
1344             for {
1345                 // Initialize and perform the first pass without check.
1346                 let temp := value
1347                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1348                 ptr := sub(ptr, 1)
1349                 // Write the character to the pointer. 48 is the ASCII index of "0".
1350                 mstore8(ptr, add(48, mod(temp, 10)))
1351                 temp := div(temp, 10)
1352             } temp {
1353                 // Keep dividing `temp` until zero.
1354                 temp := div(temp, 10)
1355             } {
1356                 // Body of the for loop.
1357                 ptr := sub(ptr, 1)
1358                 mstore8(ptr, add(48, mod(temp, 10)))
1359             }
1360 
1361             let length := sub(end, ptr)
1362             // Move the pointer 32 bytes leftwards to make room for the length.
1363             ptr := sub(ptr, 32)
1364             // Store the length.
1365             mstore(ptr, length)
1366         }
1367     }
1368 }
1369 
1370 
1371 
1372 
1373 pragma solidity ^0.8.0;
1374 
1375 /**
1376  * @dev String operations.
1377  */
1378 library Strings {
1379     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1380 
1381     /**
1382      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1383      */
1384     function toString(uint256 value) internal pure returns (string memory) {
1385         // Inspired by OraclizeAPI"s implementation - MIT licence
1386         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1387 
1388         if (value == 0) {
1389             return "0";
1390         }
1391         uint256 temp = value;
1392         uint256 digits;
1393         while (temp != 0) {
1394             digits++;
1395             temp /= 10;
1396         }
1397         bytes memory buffer = new bytes(digits);
1398         while (value != 0) {
1399             digits -= 1;
1400             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1401             value /= 10;
1402         }
1403         return string(buffer);
1404     }
1405 
1406     /**
1407      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1408      */
1409     function toHexString(uint256 value) internal pure returns (string memory) {
1410         if (value == 0) {
1411             return "0x00";
1412         }
1413         uint256 temp = value;
1414         uint256 length = 0;
1415         while (temp != 0) {
1416             length++;
1417             temp >>= 8;
1418         }
1419         return toHexString(value, length);
1420     }
1421 
1422     /**
1423      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1424      */
1425     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1426         bytes memory buffer = new bytes(2 * length + 2);
1427         buffer[0] = "0";
1428         buffer[1] = "x";
1429         for (uint256 i = 2 * length + 1; i > 1; --i) {
1430             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1431             value >>= 4;
1432         }
1433         require(value == 0, "Strings: hex length insufficient");
1434         return string(buffer);
1435     }
1436 }
1437 
1438 
1439 
1440 
1441 pragma solidity ^0.8.0;
1442 
1443 
1444 
1445 contract UNDERWATERCLUB is ERC721A, Ownable {
1446 	using Strings for uint;
1447 
1448     uint public constant MAX_PER_WALLET = 10;
1449 	uint public maxSupply = 10000;
1450 
1451 	bool public isPaused = true;
1452     string private _baseURL = "";
1453 	mapping(address => uint) private _walletMintedCount;
1454     mapping(address => bool) private _whiteList;
1455 	constructor()
1456     // Name
1457 	ERC721A("UNDERWATER CLUB", "UC") {
1458     }
1459 
1460 	function _baseURI() internal view override returns (string memory) {
1461 		return _baseURL;
1462 	}
1463 
1464 	function _startTokenId() internal pure override returns (uint) {
1465 		return 1;
1466 	}
1467 
1468 	function contractURI() public pure returns (string memory) {
1469 		return "";
1470 	}
1471 
1472     function mintedCount(address owner) external view returns (uint) {
1473         return _walletMintedCount[owner];
1474     }
1475 
1476     function setBaseUri(string memory url) external onlyOwner {
1477 	    _baseURL = url;
1478 	}
1479 
1480 	function start(bool paused) external onlyOwner {
1481 	    isPaused = paused;
1482 	}
1483 
1484 	function withdraw() external onlyOwner {
1485 		(bool success, ) = payable(msg.sender).call{
1486             value: address(this).balance
1487         }("");
1488         require(success);
1489 	}
1490 
1491 	function devMint(address to, uint count) external onlyOwner {
1492 		require(
1493 			_totalMinted() + count <= maxSupply,
1494 			"Exceeds max supply"
1495 		);
1496 		_safeMint(to, count);
1497 	}
1498 
1499 	function setMaxSupply(uint newMaxSupply) external onlyOwner {
1500 		maxSupply = newMaxSupply;
1501 	}
1502 
1503     function addWhitelist(address[] calldata wallets) external onlyOwner {
1504 		for(uint i=0;i<wallets.length;i++)
1505             _whiteList[wallets[i]]=true;
1506 	}
1507 
1508 	function tokenURI(uint tokenId)
1509 		public
1510 		view
1511 		override
1512 		returns (string memory)
1513 	{
1514         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1515         return bytes(_baseURI()).length > 0 
1516             ? string(abi.encodePacked(_baseURI(), tokenId.toString(), ".json"))
1517             : "";
1518 	}
1519 
1520 	function mint() external payable {
1521         uint count=MAX_PER_WALLET;
1522 		require(!isPaused, "Sales are off");
1523         require(_totalMinted() + count <= maxSupply,"Exceeds max supply");
1524         require(count <= MAX_PER_WALLET,"Exceeds max per transaction");
1525         require(_walletMintedCount[msg.sender] + count <= MAX_PER_WALLET * 3,"Exceeds max per wallet");
1526         require(_whiteList[msg.sender],"You are not on the whitelist!");
1527 		_walletMintedCount[msg.sender] += count;
1528 		_safeMint(msg.sender, count);
1529 	}
1530 }