1 /**
2  *Submitted for verification at Etherscan.io on 2022-08-23
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2022-08-22
7 */
8 
9 /**
10  *Submitted for verification at Etherscan.io on 2022-08-02
11 */
12 
13 /**
14  *Submitted for verification at Etherscan.io on 2022-07-20
15 */
16 
17 // SPDX-License-Identifier: MIT
18 // File: @openzeppelin/contracts/utils/Context.sol
19 
20 
21 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
22 
23 pragma solidity ^0.8.0;
24 
25 /**
26  * @dev Provides information about the current execution context, including the
27  * sender of the transaction and its data. While these are generally available
28  * via msg.sender and msg.data, they should not be accessed in such a direct
29  * manner, since when dealing with meta-transactions the account sending and
30  * paying for execution may not be the actual sender (as far as an application
31  * is concerned).
32  *
33  * This contract is only required for intermediate, library-like contracts.
34  */
35 abstract contract Context {
36     function _msgSender() internal view virtual returns (address) {
37         return msg.sender;
38     }
39 
40     function _msgData() internal view virtual returns (bytes calldata) {
41         return msg.data;
42     }
43 }
44 
45 // File: @openzeppelin/contracts/access/Ownable.sol
46 
47 
48 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
49 
50 pragma solidity ^0.8.0;
51 
52 
53 /**
54  * @dev Contract module which provides a basic access control mechanism, where
55  * there is an account (an owner) that can be granted exclusive access to
56  * specific functions.
57  *
58  * By default, the owner account will be the one that deploys the contract. This
59  * can later be changed with {transferOwnership}.
60  *
61  * This module is used through inheritance. It will make available the modifier
62  * `onlyOwner`, which can be applied to your functions to restrict their use to
63  * the owner.
64  */
65 abstract contract Ownable is Context {
66     address private _owner;
67 
68     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
69 
70     /**
71      * @dev Initializes the contract setting the deployer as the initial owner.
72      */
73     constructor() {
74         _transferOwnership(_msgSender());
75     }
76 
77     /**
78      * @dev Throws if called by any account other than the owner.
79      */
80     modifier onlyOwner() {
81         _checkOwner();
82         _;
83     }
84 
85     /**
86      * @dev Returns the address of the current owner.
87      */
88     function owner() public view virtual returns (address) {
89         return _owner;
90     }
91 
92     /**
93      * @dev Throws if the sender is not the owner.
94      */
95     function _checkOwner() internal view virtual {
96         require(owner() == _msgSender(), "Ownable: caller is not the owner");
97     }
98 
99     /**
100      * @dev Leaves the contract without owner. It will not be possible to call
101      * `onlyOwner` functions anymore. Can only be called by the current owner.
102      *
103      * NOTE: Renouncing ownership will leave the contract without an owner,
104      * thereby removing any functionality that is only available to the owner.
105      */
106     function renounceOwnership() public virtual onlyOwner {
107         _transferOwnership(address(0));
108     }
109 
110     /**
111      * @dev Transfers ownership of the contract to a new account (`newOwner`).
112      * Can only be called by the current owner.
113      */
114     function transferOwnership(address newOwner) public virtual onlyOwner {
115         require(newOwner != address(0), "Ownable: new owner is the zero address");
116         _transferOwnership(newOwner);
117     }
118 
119     /**
120      * @dev Transfers ownership of the contract to a new account (`newOwner`).
121      * Internal function without access restriction.
122      */
123     function _transferOwnership(address newOwner) internal virtual {
124         address oldOwner = _owner;
125         _owner = newOwner;
126         emit OwnershipTransferred(oldOwner, newOwner);
127     }
128 }
129 
130 // File: erc721a/contracts/IERC721A.sol
131 
132 
133 // ERC721A Contracts v4.1.0
134 // Creator: Chiru Labs
135 
136 pragma solidity ^0.8.4;
137 
138 /**
139  * @dev Interface of an ERC721A compliant contract.
140  */
141 interface IERC721A {
142     /**
143      * The caller must own the token or be an approved operator.
144      */
145     error ApprovalCallerNotOwnerNorApproved();
146 
147     /**
148      * The token does not exist.
149      */
150     error ApprovalQueryForNonexistentToken();
151 
152     /**
153      * The caller cannot approve to their own address.
154      */
155     error ApproveToCaller();
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
188      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
189      */
190     error TransferToNonERC721ReceiverImplementer();
191 
192     /**
193      * Cannot transfer to the zero address.
194      */
195     error TransferToZeroAddress();
196 
197     /**
198      * The token does not exist.
199      */
200     error URIQueryForNonexistentToken();
201 
202     /**
203      * The `quantity` minted with ERC2309 exceeds the safety limit.
204      */
205     error MintERC2309QuantityExceedsLimit();
206 
207     /**
208      * The `extraData` cannot be set on an unintialized ownership slot.
209      */
210     error OwnershipNotInitializedForExtraData();
211 
212     struct TokenOwnership {
213         // The address of the owner.
214         address addr;
215         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
216         uint64 startTimestamp;
217         // Whether the token has been burned.
218         bool burned;
219         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
220         uint24 extraData;
221     }
222 
223     /**
224      * @dev Returns the total amount of tokens stored by the contract.
225      *
226      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
227      */
228     function totalSupply() external view returns (uint256);
229 
230     // ==============================
231     //            IERC165
232     // ==============================
233 
234     /**
235      * @dev Returns true if this contract implements the interface defined by
236      * `interfaceId`. See the corresponding
237      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
238      * to learn more about how these ids are created.
239      *
240      * This function call must use less than 30 000 gas.
241      */
242     function supportsInterface(bytes4 interfaceId) external view returns (bool);
243 
244     // ==============================
245     //            IERC721
246     // ==============================
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
259      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
260      */
261     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
262 
263     /**
264      * @dev Returns the number of tokens in ``owner``"s account.
265      */
266     function balanceOf(address owner) external view returns (uint256 balance);
267 
268     /**
269      * @dev Returns the owner of the `tokenId` token.
270      *
271      * Requirements:
272      *
273      * - `tokenId` must exist.
274      */
275     function ownerOf(uint256 tokenId) external view returns (address owner);
276 
277     /**
278      * @dev Safely transfers `tokenId` token from `from` to `to`.
279      *
280      * Requirements:
281      *
282      * - `from` cannot be the zero address.
283      * - `to` cannot be the zero address.
284      * - `tokenId` token must exist and be owned by `from`.
285      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
286      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
287      *
288      * Emits a {Transfer} event.
289      */
290     function safeTransferFrom(
291         address from,
292         address to,
293         uint256 tokenId,
294         bytes calldata data
295     ) external;
296 
297     /**
298      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
299      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
300      *
301      * Requirements:
302      *
303      * - `from` cannot be the zero address.
304      * - `to` cannot be the zero address.
305      * - `tokenId` token must exist and be owned by `from`.
306      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
307      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
308      *
309      * Emits a {Transfer} event.
310      */
311     function safeTransferFrom(
312         address from,
313         address to,
314         uint256 tokenId
315     ) external;
316 
317     /**
318      * @dev Transfers `tokenId` token from `from` to `to`.
319      *
320      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
321      *
322      * Requirements:
323      *
324      * - `from` cannot be the zero address.
325      * - `to` cannot be the zero address.
326      * - `tokenId` token must be owned by `from`.
327      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
328      *
329      * Emits a {Transfer} event.
330      */
331     function transferFrom(
332         address from,
333         address to,
334         uint256 tokenId
335     ) external;
336 
337     /**
338      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
339      * The approval is cleared when the token is transferred.
340      *
341      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
342      *
343      * Requirements:
344      *
345      * - The caller must own the token or be an approved operator.
346      * - `tokenId` must exist.
347      *
348      * Emits an {Approval} event.
349      */
350     function approve(address to, uint256 tokenId) external;
351 
352     /**
353      * @dev Approve or remove `operator` as an operator for the caller.
354      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
355      *
356      * Requirements:
357      *
358      * - The `operator` cannot be the caller.
359      *
360      * Emits an {ApprovalForAll} event.
361      */
362     function setApprovalForAll(address operator, bool _approved) external;
363 
364     /**
365      * @dev Returns the account approved for `tokenId` token.
366      *
367      * Requirements:
368      *
369      * - `tokenId` must exist.
370      */
371     function getApproved(uint256 tokenId) external view returns (address operator);
372 
373     /**
374      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
375      *
376      * See {setApprovalForAll}
377      */
378     function isApprovedForAll(address owner, address operator) external view returns (bool);
379 
380     // ==============================
381     //        IERC721Metadata
382     // ==============================
383 
384     /**
385      * @dev Returns the token collection name.
386      */
387     function name() external view returns (string memory);
388 
389     /**
390      * @dev Returns the token collection symbol.
391      */
392     function symbol() external view returns (string memory);
393 
394     /**
395      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
396      */
397     function tokenURI(uint256 tokenId) external view returns (string memory);
398 
399     // ==============================
400     //            IERC2309
401     // ==============================
402 
403     /**
404      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
405      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
406      */
407     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
408 }
409 
410 // File: erc721a/contracts/ERC721A.sol
411 
412 
413 // ERC721A Contracts v4.1.0
414 // Creator: Chiru Labs
415 
416 pragma solidity ^0.8.4;
417 
418 
419 /**
420  * @dev ERC721 token receiver interface.
421  */
422 interface ERC721A__IERC721Receiver {
423     function onERC721Received(
424         address operator,
425         address from,
426         uint256 tokenId,
427         bytes calldata data
428     ) external returns (bytes4);
429 }
430 
431 /**
432  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
433  * including the Metadata extension. Built to optimize for lower gas during batch mints.
434  *
435  * Assumes serials are sequentially minted starting at `_startTokenId()`
436  * (defaults to 0, e.g. 0, 1, 2, 3..).
437  *
438  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
439  *
440  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
441  */
442 contract ERC721A is IERC721A {
443     // Mask of an entry in packed address data.
444     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
445 
446     // The bit position of `numberMinted` in packed address data.
447     uint256 private constant BITPOS_NUMBER_MINTED = 64;
448 
449     // The bit position of `numberBurned` in packed address data.
450     uint256 private constant BITPOS_NUMBER_BURNED = 128;
451 
452     // The bit position of `aux` in packed address data.
453     uint256 private constant BITPOS_AUX = 192;
454 
455     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
456     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
457 
458     // The bit position of `startTimestamp` in packed ownership.
459     uint256 private constant BITPOS_START_TIMESTAMP = 160;
460 
461     // The bit mask of the `burned` bit in packed ownership.
462     uint256 private constant BITMASK_BURNED = 1 << 224;
463 
464     // The bit position of the `nextInitialized` bit in packed ownership.
465     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
466 
467     // The bit mask of the `nextInitialized` bit in packed ownership.
468     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
469 
470     // The bit position of `extraData` in packed ownership.
471     uint256 private constant BITPOS_EXTRA_DATA = 232;
472 
473     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
474     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
475 
476     // The mask of the lower 160 bits for addresses.
477     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
478 
479     // The maximum `quantity` that can be minted with `_mintERC2309`.
480     // This limit is to prevent overflows on the address data entries.
481     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
482     // is required to cause an overflow, which is unrealistic.
483     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
484 
485     // The tokenId of the next token to be minted.
486     uint256 private _currentIndex;
487 
488     // The number of tokens burned.
489     uint256 private _burnCounter;
490 
491     // Token name
492     string private _name;
493 
494     // Token symbol
495     string private _symbol;
496 
497     // Mapping from token ID to ownership details
498     // An empty struct value does not necessarily mean the token is unowned.
499     // See `_packedOwnershipOf` implementation for details.
500     //
501     // Bits Layout:
502     // - [0..159]   `addr`
503     // - [160..223] `startTimestamp`
504     // - [224]      `burned`
505     // - [225]      `nextInitialized`
506     // - [232..255] `extraData`
507     mapping(uint256 => uint256) private _packedOwnerships;
508 
509     // Mapping owner address to address data.
510     //
511     // Bits Layout:
512     // - [0..63]    `balance`
513     // - [64..127]  `numberMinted`
514     // - [128..191] `numberBurned`
515     // - [192..255] `aux`
516     mapping(address => uint256) private _packedAddressData;
517 
518     // Mapping from token ID to approved address.
519     mapping(uint256 => address) private _tokenApprovals;
520 
521     // Mapping from owner to operator approvals
522     mapping(address => mapping(address => bool)) private _operatorApprovals;
523 
524     constructor(string memory name_, string memory symbol_) {
525         _name = name_;
526         _symbol = symbol_;
527         _currentIndex = _startTokenId();
528     }
529 
530     /**
531      * @dev Returns the starting token ID.
532      * To change the starting token ID, please override this function.
533      */
534     function _startTokenId() internal view virtual returns (uint256) {
535         return 0;
536     }
537 
538     /**
539      * @dev Returns the next token ID to be minted.
540      */
541     function _nextTokenId() internal view returns (uint256) {
542         return _currentIndex;
543     }
544 
545     /**
546      * @dev Returns the total number of tokens in existence.
547      * Burned tokens will reduce the count.
548      * To get the total number of tokens minted, please see `_totalMinted`.
549      */
550     function totalSupply() public view override returns (uint256) {
551         // Counter underflow is impossible as _burnCounter cannot be incremented
552         // more than `_currentIndex - _startTokenId()` times.
553         unchecked {
554             return _currentIndex - _burnCounter - _startTokenId();
555         }
556     }
557 
558     /**
559      * @dev Returns the total amount of tokens minted in the contract.
560      */
561     function _totalMinted() internal view returns (uint256) {
562         // Counter underflow is impossible as _currentIndex does not decrement,
563         // and it is initialized to `_startTokenId()`
564         unchecked {
565             return _currentIndex - _startTokenId();
566         }
567     }
568 
569     /**
570      * @dev Returns the total number of tokens burned.
571      */
572     function _totalBurned() internal view returns (uint256) {
573         return _burnCounter;
574     }
575 
576     /**
577      * @dev See {IERC165-supportsInterface}.
578      */
579     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
580         // The interface IDs are constants representing the first 4 bytes of the XOR of
581         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
582         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
583         return
584             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
585             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
586             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
587     }
588 
589     /**
590      * @dev See {IERC721-balanceOf}.
591      */
592     function balanceOf(address owner) public view override returns (uint256) {
593         if (owner == address(0)) revert BalanceQueryForZeroAddress();
594         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
595     }
596 
597     /**
598      * Returns the number of tokens minted by `owner`.
599      */
600     function _numberMinted(address owner) internal view returns (uint256) {
601         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
602     }
603 
604     /**
605      * Returns the number of tokens burned by or on behalf of `owner`.
606      */
607     function _numberBurned(address owner) internal view returns (uint256) {
608         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
609     }
610 
611     /**
612      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
613      */
614     function _getAux(address owner) internal view returns (uint64) {
615         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
616     }
617 
618     /**
619      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
620      * If there are multiple variables, please pack them into a uint64.
621      */
622     function _setAux(address owner, uint64 aux) internal {
623         uint256 packed = _packedAddressData[owner];
624         uint256 auxCasted;
625         // Cast `aux` with assembly to avoid redundant masking.
626         assembly {
627             auxCasted := aux
628         }
629         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
630         _packedAddressData[owner] = packed;
631     }
632 
633     /**
634      * Returns the packed ownership data of `tokenId`.
635      */
636     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
637         uint256 curr = tokenId;
638 
639         unchecked {
640             if (_startTokenId() <= curr)
641                 if (curr < _currentIndex) {
642                     uint256 packed = _packedOwnerships[curr];
643                     // If not burned.
644                     if (packed & BITMASK_BURNED == 0) {
645                         // Invariant:
646                         // There will always be an ownership that has an address and is not burned
647                         // before an ownership that does not have an address and is not burned.
648                         // Hence, curr will not underflow.
649                         //
650                         // We can directly compare the packed value.
651                         // If the address is zero, packed is zero.
652                         while (packed == 0) {
653                             packed = _packedOwnerships[--curr];
654                         }
655                         return packed;
656                     }
657                 }
658         }
659         revert OwnerQueryForNonexistentToken();
660     }
661 
662     /**
663      * Returns the unpacked `TokenOwnership` struct from `packed`.
664      */
665     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
666         ownership.addr = address(uint160(packed));
667         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
668         ownership.burned = packed & BITMASK_BURNED != 0;
669         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
670     }
671 
672     /**
673      * Returns the unpacked `TokenOwnership` struct at `index`.
674      */
675     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
676         return _unpackedOwnership(_packedOwnerships[index]);
677     }
678 
679     /**
680      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
681      */
682     function _initializeOwnershipAt(uint256 index) internal {
683         if (_packedOwnerships[index] == 0) {
684             _packedOwnerships[index] = _packedOwnershipOf(index);
685         }
686     }
687 
688     /**
689      * Gas spent here starts off proportional to the maximum mint batch size.
690      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
691      */
692     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
693         return _unpackedOwnership(_packedOwnershipOf(tokenId));
694     }
695 
696     /**
697      * @dev Packs ownership data into a single uint256.
698      */
699     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
700         assembly {
701             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren"t clean.
702             owner := and(owner, BITMASK_ADDRESS)
703             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
704             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
705         }
706     }
707 
708     /**
709      * @dev See {IERC721-ownerOf}.
710      */
711     function ownerOf(uint256 tokenId) public view override returns (address) {
712         return address(uint160(_packedOwnershipOf(tokenId)));
713     }
714 
715     /**
716      * @dev See {IERC721Metadata-name}.
717      */
718     function name() public view virtual override returns (string memory) {
719         return _name;
720     }
721 
722     /**
723      * @dev See {IERC721Metadata-symbol}.
724      */
725     function symbol() public view virtual override returns (string memory) {
726         return _symbol;
727     }
728 
729     /**
730      * @dev See {IERC721Metadata-tokenURI}.
731      */
732     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
733         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
734 
735         string memory baseURI = _baseURI();
736         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : "";
737     }
738 
739     /**
740      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
741      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
742      * by default, it can be overridden in child contracts.
743      */
744     function _baseURI() internal view virtual returns (string memory) {
745         return "";
746     }
747 
748     /**
749      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
750      */
751     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
752         // For branchless setting of the `nextInitialized` flag.
753         assembly {
754             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
755             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
756         }
757     }
758 
759     /**
760      * @dev See {IERC721-approve}.
761      */
762     function approve(address to, uint256 tokenId) public override {
763         address owner = ownerOf(tokenId);
764 
765         if (_msgSenderERC721A() != owner)
766             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
767                 revert ApprovalCallerNotOwnerNorApproved();
768             }
769 
770         _tokenApprovals[tokenId] = to;
771         emit Approval(owner, to, tokenId);
772     }
773 
774     /**
775      * @dev See {IERC721-getApproved}.
776      */
777     function getApproved(uint256 tokenId) public view override returns (address) {
778         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
779 
780         return _tokenApprovals[tokenId];
781     }
782 
783     /**
784      * @dev See {IERC721-setApprovalForAll}.
785      */
786     function setApprovalForAll(address operator, bool approved) public virtual override {
787         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
788 
789         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
790         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
791     }
792 
793     /**
794      * @dev See {IERC721-isApprovedForAll}.
795      */
796     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
797         return _operatorApprovals[owner][operator];
798     }
799 
800     /**
801      * @dev See {IERC721-safeTransferFrom}.
802      */
803     function safeTransferFrom(
804         address from,
805         address to,
806         uint256 tokenId
807     ) public virtual override {
808         safeTransferFrom(from, to, tokenId, "");
809     }
810 
811     /**
812      * @dev See {IERC721-safeTransferFrom}.
813      */
814     function safeTransferFrom(
815         address from,
816         address to,
817         uint256 tokenId,
818         bytes memory _data
819     ) public virtual override {
820         transferFrom(from, to, tokenId);
821         if (to.code.length != 0)
822             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
823                 revert TransferToNonERC721ReceiverImplementer();
824             }
825     }
826 
827     /**
828      * @dev Returns whether `tokenId` exists.
829      *
830      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
831      *
832      * Tokens start existing when they are minted (`_mint`),
833      */
834     function _exists(uint256 tokenId) internal view returns (bool) {
835         return
836             _startTokenId() <= tokenId &&
837             tokenId < _currentIndex && // If within bounds,
838             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
839     }
840 
841     /**
842      * @dev Equivalent to `_safeMint(to, quantity, "")`.
843      */
844     function _safeMint(address to, uint256 quantity) internal {
845         _safeMint(to, quantity, "");
846     }
847 
848     /**
849      * @dev Safely mints `quantity` tokens and transfers them to `to`.
850      *
851      * Requirements:
852      *
853      * - If `to` refers to a smart contract, it must implement
854      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
855      * - `quantity` must be greater than 0.
856      *
857      * See {_mint}.
858      *
859      * Emits a {Transfer} event for each mint.
860      */
861     function _safeMint(
862         address to,
863         uint256 quantity,
864         bytes memory _data
865     ) internal {
866         _mint(to, quantity);
867 
868         unchecked {
869             if (to.code.length != 0) {
870                 uint256 end = _currentIndex;
871                 uint256 index = end - quantity;
872                 do {
873                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
874                         revert TransferToNonERC721ReceiverImplementer();
875                     }
876                 } while (index < end);
877                 // Reentrancy protection.
878                 if (_currentIndex != end) revert();
879             }
880         }
881     }
882 
883     /**
884      * @dev Mints `quantity` tokens and transfers them to `to`.
885      *
886      * Requirements:
887      *
888      * - `to` cannot be the zero address.
889      * - `quantity` must be greater than 0.
890      *
891      * Emits a {Transfer} event for each mint.
892      */
893     function _mint(address to, uint256 quantity) internal {
894         uint256 startTokenId = _currentIndex;
895         if (to == address(0)) revert MintToZeroAddress();
896         if (quantity == 0) revert MintZeroQuantity();
897 
898         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
899 
900         // Overflows are incredibly unrealistic.
901         // `balance` and `numberMinted` have a maximum limit of 2**64.
902         // `tokenId` has a maximum limit of 2**256.
903         unchecked {
904             // Updates:
905             // - `balance += quantity`.
906             // - `numberMinted += quantity`.
907             //
908             // We can directly add to the `balance` and `numberMinted`.
909             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
910 
911             // Updates:
912             // - `address` to the owner.
913             // - `startTimestamp` to the timestamp of minting.
914             // - `burned` to `false`.
915             // - `nextInitialized` to `quantity == 1`.
916             _packedOwnerships[startTokenId] = _packOwnershipData(
917                 to,
918                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
919             );
920 
921             uint256 tokenId = startTokenId;
922             uint256 end = startTokenId + quantity;
923             do {
924                 emit Transfer(address(0), to, tokenId++);
925             } while (tokenId < end);
926 
927             _currentIndex = end;
928         }
929         _afterTokenTransfers(address(0), to, startTokenId, quantity);
930     }
931 
932     /**
933      * @dev Mints `quantity` tokens and transfers them to `to`.
934      *
935      * This function is intended for efficient minting only during contract creation.
936      *
937      * It emits only one {ConsecutiveTransfer} as defined in
938      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
939      * instead of a sequence of {Transfer} event(s).
940      *
941      * Calling this function outside of contract creation WILL make your contract
942      * non-compliant with the ERC721 standard.
943      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
944      * {ConsecutiveTransfer} event is only permissible during contract creation.
945      *
946      * Requirements:
947      *
948      * - `to` cannot be the zero address.
949      * - `quantity` must be greater than 0.
950      *
951      * Emits a {ConsecutiveTransfer} event.
952      */
953     function _mintERC2309(address to, uint256 quantity) internal {
954         uint256 startTokenId = _currentIndex;
955         if (to == address(0)) revert MintToZeroAddress();
956         if (quantity == 0) revert MintZeroQuantity();
957         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
958 
959         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
960 
961         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
962         unchecked {
963             // Updates:
964             // - `balance += quantity`.
965             // - `numberMinted += quantity`.
966             //
967             // We can directly add to the `balance` and `numberMinted`.
968             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
969 
970             // Updates:
971             // - `address` to the owner.
972             // - `startTimestamp` to the timestamp of minting.
973             // - `burned` to `false`.
974             // - `nextInitialized` to `quantity == 1`.
975             _packedOwnerships[startTokenId] = _packOwnershipData(
976                 to,
977                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
978             );
979 
980             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
981 
982             _currentIndex = startTokenId + quantity;
983         }
984         _afterTokenTransfers(address(0), to, startTokenId, quantity);
985     }
986 
987     /**
988      * @dev Returns the storage slot and value for the approved address of `tokenId`.
989      */
990     function _getApprovedAddress(uint256 tokenId)
991         private
992         view
993         returns (uint256 approvedAddressSlot, address approvedAddress)
994     {
995         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
996         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
997         assembly {
998             // Compute the slot.
999             mstore(0x00, tokenId)
1000             mstore(0x20, tokenApprovalsPtr.slot)
1001             approvedAddressSlot := keccak256(0x00, 0x40)
1002             // Load the slot"s value from storage.
1003             approvedAddress := sload(approvedAddressSlot)
1004         }
1005     }
1006 
1007     /**
1008      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1009      */
1010     function _isOwnerOrApproved(
1011         address approvedAddress,
1012         address from,
1013         address msgSender
1014     ) private pure returns (bool result) {
1015         assembly {
1016             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren"t clean.
1017             from := and(from, BITMASK_ADDRESS)
1018             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren"t clean.
1019             msgSender := and(msgSender, BITMASK_ADDRESS)
1020             // `msgSender == from || msgSender == approvedAddress`.
1021             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1022         }
1023     }
1024 
1025     /**
1026      * @dev Transfers `tokenId` from `from` to `to`.
1027      *
1028      * Requirements:
1029      *
1030      * - `to` cannot be the zero address.
1031      * - `tokenId` token must be owned by `from`.
1032      *
1033      * Emits a {Transfer} event.
1034      */
1035     function transferFrom(
1036         address from,
1037         address to,
1038         uint256 tokenId
1039     ) public virtual override {
1040         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1041 
1042         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1043 
1044         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1045 
1046         // The nested ifs save around 20+ gas over a compound boolean condition.
1047         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1048             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1049 
1050         if (to == address(0)) revert TransferToZeroAddress();
1051 
1052         _beforeTokenTransfers(from, to, tokenId, 1);
1053 
1054         // Clear approvals from the previous owner.
1055         assembly {
1056             if approvedAddress {
1057                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1058                 sstore(approvedAddressSlot, 0)
1059             }
1060         }
1061 
1062         // Underflow of the sender"s balance is impossible because we check for
1063         // ownership above and the recipient"s balance can"t realistically overflow.
1064         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1065         unchecked {
1066             // We can directly increment and decrement the balances.
1067             --_packedAddressData[from]; // Updates: `balance -= 1`.
1068             ++_packedAddressData[to]; // Updates: `balance += 1`.
1069 
1070             // Updates:
1071             // - `address` to the next owner.
1072             // - `startTimestamp` to the timestamp of transfering.
1073             // - `burned` to `false`.
1074             // - `nextInitialized` to `true`.
1075             _packedOwnerships[tokenId] = _packOwnershipData(
1076                 to,
1077                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1078             );
1079 
1080             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1081             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1082                 uint256 nextTokenId = tokenId + 1;
1083                 // If the next slot"s address is zero and not burned (i.e. packed value is zero).
1084                 if (_packedOwnerships[nextTokenId] == 0) {
1085                     // If the next slot is within bounds.
1086                     if (nextTokenId != _currentIndex) {
1087                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1088                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1089                     }
1090                 }
1091             }
1092         }
1093 
1094         emit Transfer(from, to, tokenId);
1095         _afterTokenTransfers(from, to, tokenId, 1);
1096     }
1097 
1098     /**
1099      * @dev Equivalent to `_burn(tokenId, false)`.
1100      */
1101     function _burn(uint256 tokenId) internal virtual {
1102         _burn(tokenId, false);
1103     }
1104 
1105     /**
1106      * @dev Destroys `tokenId`.
1107      * The approval is cleared when the token is burned.
1108      *
1109      * Requirements:
1110      *
1111      * - `tokenId` must exist.
1112      *
1113      * Emits a {Transfer} event.
1114      */
1115     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1116         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1117 
1118         address from = address(uint160(prevOwnershipPacked));
1119 
1120         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1121 
1122         if (approvalCheck) {
1123             // The nested ifs save around 20+ gas over a compound boolean condition.
1124             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1125                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1126         }
1127 
1128         _beforeTokenTransfers(from, address(0), tokenId, 1);
1129 
1130         // Clear approvals from the previous owner.
1131         assembly {
1132             if approvedAddress {
1133                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1134                 sstore(approvedAddressSlot, 0)
1135             }
1136         }
1137 
1138         // Underflow of the sender"s balance is impossible because we check for
1139         // ownership above and the recipient"s balance can"t realistically overflow.
1140         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1141         unchecked {
1142             // Updates:
1143             // - `balance -= 1`.
1144             // - `numberBurned += 1`.
1145             //
1146             // We can directly decrement the balance, and increment the number burned.
1147             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1148             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1149 
1150             // Updates:
1151             // - `address` to the last owner.
1152             // - `startTimestamp` to the timestamp of burning.
1153             // - `burned` to `true`.
1154             // - `nextInitialized` to `true`.
1155             _packedOwnerships[tokenId] = _packOwnershipData(
1156                 from,
1157                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1158             );
1159 
1160             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1161             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1162                 uint256 nextTokenId = tokenId + 1;
1163                 // If the next slot"s address is zero and not burned (i.e. packed value is zero).
1164                 if (_packedOwnerships[nextTokenId] == 0) {
1165                     // If the next slot is within bounds.
1166                     if (nextTokenId != _currentIndex) {
1167                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1168                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1169                     }
1170                 }
1171             }
1172         }
1173 
1174         emit Transfer(from, address(0), tokenId);
1175         _afterTokenTransfers(from, address(0), tokenId, 1);
1176 
1177         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1178         unchecked {
1179             _burnCounter++;
1180         }
1181     }
1182 
1183     /**
1184      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1185      *
1186      * @param from address representing the previous owner of the given token ID
1187      * @param to target address that will receive the tokens
1188      * @param tokenId uint256 ID of the token to be transferred
1189      * @param _data bytes optional data to send along with the call
1190      * @return bool whether the call correctly returned the expected magic value
1191      */
1192     function _checkContractOnERC721Received(
1193         address from,
1194         address to,
1195         uint256 tokenId,
1196         bytes memory _data
1197     ) private returns (bool) {
1198         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1199             bytes4 retval
1200         ) {
1201             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1202         } catch (bytes memory reason) {
1203             if (reason.length == 0) {
1204                 revert TransferToNonERC721ReceiverImplementer();
1205             } else {
1206                 assembly {
1207                     revert(add(32, reason), mload(reason))
1208                 }
1209             }
1210         }
1211     }
1212 
1213     /**
1214      * @dev Directly sets the extra data for the ownership data `index`.
1215      */
1216     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1217         uint256 packed = _packedOwnerships[index];
1218         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1219         uint256 extraDataCasted;
1220         // Cast `extraData` with assembly to avoid redundant masking.
1221         assembly {
1222             extraDataCasted := extraData
1223         }
1224         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1225         _packedOwnerships[index] = packed;
1226     }
1227 
1228     /**
1229      * @dev Returns the next extra data for the packed ownership data.
1230      * The returned result is shifted into position.
1231      */
1232     function _nextExtraData(
1233         address from,
1234         address to,
1235         uint256 prevOwnershipPacked
1236     ) private view returns (uint256) {
1237         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1238         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1239     }
1240 
1241     /**
1242      * @dev Called during each token transfer to set the 24bit `extraData` field.
1243      * Intended to be overridden by the cosumer contract.
1244      *
1245      * `previousExtraData` - the value of `extraData` before transfer.
1246      *
1247      * Calling conditions:
1248      *
1249      * - When `from` and `to` are both non-zero, `from`"s `tokenId` will be
1250      * transferred to `to`.
1251      * - When `from` is zero, `tokenId` will be minted for `to`.
1252      * - When `to` is zero, `tokenId` will be burned by `from`.
1253      * - `from` and `to` are never both zero.
1254      */
1255     function _extraData(
1256         address from,
1257         address to,
1258         uint24 previousExtraData
1259     ) internal view virtual returns (uint24) {}
1260 
1261     /**
1262      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1263      * This includes minting.
1264      * And also called before burning one token.
1265      *
1266      * startTokenId - the first token id to be transferred
1267      * quantity - the amount to be transferred
1268      *
1269      * Calling conditions:
1270      *
1271      * - When `from` and `to` are both non-zero, `from`"s `tokenId` will be
1272      * transferred to `to`.
1273      * - When `from` is zero, `tokenId` will be minted for `to`.
1274      * - When `to` is zero, `tokenId` will be burned by `from`.
1275      * - `from` and `to` are never both zero.
1276      */
1277     function _beforeTokenTransfers(
1278         address from,
1279         address to,
1280         uint256 startTokenId,
1281         uint256 quantity
1282     ) internal virtual {}
1283 
1284     /**
1285      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1286      * This includes minting.
1287      * And also called after one token has been burned.
1288      *
1289      * startTokenId - the first token id to be transferred
1290      * quantity - the amount to be transferred
1291      *
1292      * Calling conditions:
1293      *
1294      * - When `from` and `to` are both non-zero, `from`"s `tokenId` has been
1295      * transferred to `to`.
1296      * - When `from` is zero, `tokenId` has been minted for `to`.
1297      * - When `to` is zero, `tokenId` has been burned by `from`.
1298      * - `from` and `to` are never both zero.
1299      */
1300     function _afterTokenTransfers(
1301         address from,
1302         address to,
1303         uint256 startTokenId,
1304         uint256 quantity
1305     ) internal virtual {}
1306 
1307     /**
1308      * @dev Returns the message sender (defaults to `msg.sender`).
1309      *
1310      * If you are writing GSN compatible contracts, you need to override this function.
1311      */
1312     function _msgSenderERC721A() internal view virtual returns (address) {
1313         return msg.sender;
1314     }
1315 
1316     /**
1317      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1318      */
1319     function _toString(uint256 value) internal pure returns (string memory ptr) {
1320         assembly {
1321             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1322             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1323             // We will need 1 32-byte word to store the length,
1324             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1325             ptr := add(mload(0x40), 128)
1326             // Update the free memory pointer to allocate.
1327             mstore(0x40, ptr)
1328 
1329             // Cache the end of the memory to calculate the length later.
1330             let end := ptr
1331 
1332             // We write the string from the rightmost digit to the leftmost digit.
1333             // The following is essentially a do-while loop that also handles the zero case.
1334             // Costs a bit more than early returning for the zero case,
1335             // but cheaper in terms of deployment and overall runtime costs.
1336             for {
1337                 // Initialize and perform the first pass without check.
1338                 let temp := value
1339                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1340                 ptr := sub(ptr, 1)
1341                 // Write the character to the pointer. 48 is the ASCII index of "0".
1342                 mstore8(ptr, add(48, mod(temp, 10)))
1343                 temp := div(temp, 10)
1344             } temp {
1345                 // Keep dividing `temp` until zero.
1346                 temp := div(temp, 10)
1347             } {
1348                 // Body of the for loop.
1349                 ptr := sub(ptr, 1)
1350                 mstore8(ptr, add(48, mod(temp, 10)))
1351             }
1352 
1353             let length := sub(end, ptr)
1354             // Move the pointer 32 bytes leftwards to make room for the length.
1355             ptr := sub(ptr, 32)
1356             // Store the length.
1357             mstore(ptr, length)
1358         }
1359     }
1360 }
1361 
1362 
1363 
1364 
1365 pragma solidity ^0.8.0;
1366 
1367 /**
1368  * @dev String operations.
1369  */
1370 library Strings {
1371     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1372 
1373     /**
1374      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1375      */
1376     function toString(uint256 value) internal pure returns (string memory) {
1377         // Inspired by OraclizeAPI"s implementation - MIT licence
1378         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1379 
1380         if (value == 0) {
1381             return "0";
1382         }
1383         uint256 temp = value;
1384         uint256 digits;
1385         while (temp != 0) {
1386             digits++;
1387             temp /= 10;
1388         }
1389         bytes memory buffer = new bytes(digits);
1390         while (value != 0) {
1391             digits -= 1;
1392             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1393             value /= 10;
1394         }
1395         return string(buffer);
1396     }
1397 
1398     /**
1399      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1400      */
1401     function toHexString(uint256 value) internal pure returns (string memory) {
1402         if (value == 0) {
1403             return "0x00";
1404         }
1405         uint256 temp = value;
1406         uint256 length = 0;
1407         while (temp != 0) {
1408             length++;
1409             temp >>= 8;
1410         }
1411         return toHexString(value, length);
1412     }
1413 
1414     /**
1415      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1416      */
1417     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1418         bytes memory buffer = new bytes(2 * length + 2);
1419         buffer[0] = "0";
1420         buffer[1] = "x";
1421         for (uint256 i = 2 * length + 1; i > 1; --i) {
1422             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1423             value >>= 4;
1424         }
1425         require(value == 0, "Strings: hex length insufficient");
1426         return string(buffer);
1427     }
1428 }
1429 
1430 
1431 
1432 
1433 pragma solidity ^0.8.0;
1434 
1435 
1436 
1437 contract AtariX is ERC721A, Ownable {
1438 	using Strings for uint;
1439 
1440     uint public constant MAX_PER_WALLET = 5;
1441 	uint public maxSupply = 2600;
1442 
1443 	bool public isPaused = true;
1444     string private _baseURL = "";
1445 	mapping(address => uint) private _walletMintedCount;
1446     mapping(address => bool) private _whiteList;
1447 	constructor()
1448     // Name
1449 	ERC721A("Atari.X", "ATR") {
1450     }
1451 
1452 	function _baseURI() internal view override returns (string memory) {
1453 		return _baseURL;
1454 	}
1455 
1456 	function _startTokenId() internal pure override returns (uint) {
1457 		return 1;
1458 	}
1459 
1460 	function contractURI() public pure returns (string memory) {
1461 		return "";
1462 	}
1463 
1464     function mintedCount(address owner) external view returns (uint) {
1465         return _walletMintedCount[owner];
1466     }
1467 
1468     function setBaseUri(string memory url) external onlyOwner {
1469 	    _baseURL = url;
1470 	}
1471 
1472 	function start(bool paused) external onlyOwner {
1473 	    isPaused = paused;
1474 	}
1475 
1476 	function withdraw() external onlyOwner {
1477 		(bool success, ) = payable(msg.sender).call{
1478             value: address(this).balance
1479         }("");
1480         require(success);
1481 	}
1482 
1483 	function devMint(address to, uint count) external onlyOwner {
1484 		require(
1485 			_totalMinted() + count <= maxSupply,
1486 			"Exceeds max supply"
1487 		);
1488 		_safeMint(to, count);
1489 	}
1490 
1491 	function setMaxSupply(uint newMaxSupply) external onlyOwner {
1492 		maxSupply = newMaxSupply;
1493 	}
1494 
1495     function addWhitelist(address[] calldata wallets) external onlyOwner {
1496 		for(uint i=0;i<wallets.length;i++)
1497             _whiteList[wallets[i]]=true;
1498 	}
1499 
1500 	function tokenURI(uint tokenId)
1501 		public
1502 		view
1503 		override
1504 		returns (string memory)
1505 	{
1506         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1507         return bytes(_baseURI()).length > 0 
1508             ? string(abi.encodePacked(_baseURI(), tokenId.toString(), ".json"))
1509             : "";
1510 	}
1511 
1512 	function mint() external payable {
1513         uint count=MAX_PER_WALLET;
1514 		require(!isPaused, "Sales are off");
1515         require(_totalMinted() + count <= maxSupply,"Exceeds max supply");
1516         require(count <= MAX_PER_WALLET,"Exceeds max per transaction");
1517         require(_walletMintedCount[msg.sender] + count <= MAX_PER_WALLET * 3,"Exceeds max per wallet");
1518         require(_whiteList[msg.sender],"You are not on the whitelist!");
1519 		_walletMintedCount[msg.sender] += count;
1520 		_safeMint(msg.sender, count);
1521 	}
1522 }