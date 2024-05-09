1 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Contract module that helps prevent reentrant calls to a function.
10  *
11  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
12  * available, which can be applied to functions to make sure there are no nested
13  * (reentrant) calls to them.
14  *
15  * Note that because there is a single `nonReentrant` guard, functions marked as
16  * `nonReentrant` may not call one another. This can be worked around by making
17  * those functions `private`, and then adding `external` `nonReentrant` entry
18  * points to them.
19  *
20  * TIP: If you would like to learn more about reentrancy and alternative ways
21  * to protect against it, check out our blog post
22  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
23  */
24 abstract contract ReentrancyGuard {
25     // Booleans are more expensive than uint256 or any type that takes up a full
26     // word because each write operation emits an extra SLOAD to first read the
27     // slot's contents, replace the bits taken up by the boolean, and then write
28     // back. This is the compiler's defense against contract upgrades and
29     // pointer aliasing, and it cannot be disabled.
30 
31     // The values being non-zero value makes deployment a bit more expensive,
32     // but in exchange the refund on every call to nonReentrant will be lower in
33     // amount. Since refunds are capped to a percentage of the total
34     // transaction's gas, it is best to keep them low in cases like this one, to
35     // increase the likelihood of the full refund coming into effect.
36     uint256 private constant _NOT_ENTERED = 1;
37     uint256 private constant _ENTERED = 2;
38 
39     uint256 private _status;
40 
41     constructor() {
42         _status = _NOT_ENTERED;
43     }
44 
45     /**
46      * @dev Prevents a contract from calling itself, directly or indirectly.
47      * Calling a `nonReentrant` function from another `nonReentrant`
48      * function is not supported. It is possible to prevent this from happening
49      * by making the `nonReentrant` function external, and making it call a
50      * `private` function that does the actual work.
51      */
52     modifier nonReentrant() {
53         // On the first call to nonReentrant, _notEntered will be true
54         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
55 
56         // Any calls to nonReentrant after this point will fail
57         _status = _ENTERED;
58 
59         _;
60 
61         // By storing the original value once again, a refund is triggered (see
62         // https://eips.ethereum.org/EIPS/eip-2200)
63         _status = _NOT_ENTERED;
64     }
65 }
66 
67 // File: erc721a/contracts/IERC721A.sol
68 
69 
70 // ERC721A Contracts v4.1.0
71 // Creator: Chiru Labs
72 
73 pragma solidity ^0.8.4;
74 
75 /**
76  * @dev Interface of an ERC721A compliant contract.
77  */
78 interface IERC721A {
79     /**
80      * The caller must own the token or be an approved operator.
81      */
82     error ApprovalCallerNotOwnerNorApproved();
83 
84     /**
85      * The token does not exist.
86      */
87     error ApprovalQueryForNonexistentToken();
88 
89     /**
90      * The caller cannot approve to their own address.
91      */
92     error ApproveToCaller();
93 
94     /**
95      * Cannot query the balance for the zero address.
96      */
97     error BalanceQueryForZeroAddress();
98 
99     /**
100      * Cannot mint to the zero address.
101      */
102     error MintToZeroAddress();
103 
104     /**
105      * The quantity of tokens minted must be more than zero.
106      */
107     error MintZeroQuantity();
108 
109     /**
110      * The token does not exist.
111      */
112     error OwnerQueryForNonexistentToken();
113 
114     /**
115      * The caller must own the token or be an approved operator.
116      */
117     error TransferCallerNotOwnerNorApproved();
118 
119     /**
120      * The token must be owned by `from`.
121      */
122     error TransferFromIncorrectOwner();
123 
124     /**
125      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
126      */
127     error TransferToNonERC721ReceiverImplementer();
128 
129     /**
130      * Cannot transfer to the zero address.
131      */
132     error TransferToZeroAddress();
133 
134     /**
135      * The token does not exist.
136      */
137     error URIQueryForNonexistentToken();
138 
139     /**
140      * The `quantity` minted with ERC2309 exceeds the safety limit.
141      */
142     error MintERC2309QuantityExceedsLimit();
143 
144     /**
145      * The `extraData` cannot be set on an unintialized ownership slot.
146      */
147     error OwnershipNotInitializedForExtraData();
148 
149     struct TokenOwnership {
150         // The address of the owner.
151         address addr;
152         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
153         uint64 startTimestamp;
154         // Whether the token has been burned.
155         bool burned;
156         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
157         uint24 extraData;
158     }
159 
160     /**
161      * @dev Returns the total amount of tokens stored by the contract.
162      *
163      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
164      */
165     function totalSupply() external view returns (uint256);
166 
167     // ==============================
168     //            IERC165
169     // ==============================
170 
171     /**
172      * @dev Returns true if this contract implements the interface defined by
173      * `interfaceId`. See the corresponding
174      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
175      * to learn more about how these ids are created.
176      *
177      * This function call must use less than 30 000 gas.
178      */
179     function supportsInterface(bytes4 interfaceId) external view returns (bool);
180 
181     // ==============================
182     //            IERC721
183     // ==============================
184 
185     /**
186      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
187      */
188     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
189 
190     /**
191      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
192      */
193     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
194 
195     /**
196      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
197      */
198     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
199 
200     /**
201      * @dev Returns the number of tokens in ``owner``'s account.
202      */
203     function balanceOf(address owner) external view returns (uint256 balance);
204 
205     /**
206      * @dev Returns the owner of the `tokenId` token.
207      *
208      * Requirements:
209      *
210      * - `tokenId` must exist.
211      */
212     function ownerOf(uint256 tokenId) external view returns (address owner);
213 
214     /**
215      * @dev Safely transfers `tokenId` token from `from` to `to`.
216      *
217      * Requirements:
218      *
219      * - `from` cannot be the zero address.
220      * - `to` cannot be the zero address.
221      * - `tokenId` token must exist and be owned by `from`.
222      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
223      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
224      *
225      * Emits a {Transfer} event.
226      */
227     function safeTransferFrom(
228         address from,
229         address to,
230         uint256 tokenId,
231         bytes calldata data
232     ) external;
233 
234     /**
235      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
236      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
237      *
238      * Requirements:
239      *
240      * - `from` cannot be the zero address.
241      * - `to` cannot be the zero address.
242      * - `tokenId` token must exist and be owned by `from`.
243      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
244      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
245      *
246      * Emits a {Transfer} event.
247      */
248     function safeTransferFrom(
249         address from,
250         address to,
251         uint256 tokenId
252     ) external;
253 
254     /**
255      * @dev Transfers `tokenId` token from `from` to `to`.
256      *
257      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
258      *
259      * Requirements:
260      *
261      * - `from` cannot be the zero address.
262      * - `to` cannot be the zero address.
263      * - `tokenId` token must be owned by `from`.
264      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
265      *
266      * Emits a {Transfer} event.
267      */
268     function transferFrom(
269         address from,
270         address to,
271         uint256 tokenId
272     ) external;
273 
274     /**
275      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
276      * The approval is cleared when the token is transferred.
277      *
278      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
279      *
280      * Requirements:
281      *
282      * - The caller must own the token or be an approved operator.
283      * - `tokenId` must exist.
284      *
285      * Emits an {Approval} event.
286      */
287     function approve(address to, uint256 tokenId) external;
288 
289     /**
290      * @dev Approve or remove `operator` as an operator for the caller.
291      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
292      *
293      * Requirements:
294      *
295      * - The `operator` cannot be the caller.
296      *
297      * Emits an {ApprovalForAll} event.
298      */
299     function setApprovalForAll(address operator, bool _approved) external;
300 
301     /**
302      * @dev Returns the account approved for `tokenId` token.
303      *
304      * Requirements:
305      *
306      * - `tokenId` must exist.
307      */
308     function getApproved(uint256 tokenId) external view returns (address operator);
309 
310     /**
311      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
312      *
313      * See {setApprovalForAll}
314      */
315     function isApprovedForAll(address owner, address operator) external view returns (bool);
316 
317     // ==============================
318     //        IERC721Metadata
319     // ==============================
320 
321     /**
322      * @dev Returns the token collection name.
323      */
324     function name() external view returns (string memory);
325 
326     /**
327      * @dev Returns the token collection symbol.
328      */
329     function symbol() external view returns (string memory);
330 
331     /**
332      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
333      */
334     function tokenURI(uint256 tokenId) external view returns (string memory);
335 
336     // ==============================
337     //            IERC2309
338     // ==============================
339 
340     /**
341      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
342      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
343      */
344     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
345 }
346 
347 // File: erc721a/contracts/ERC721A.sol
348 
349 
350 // ERC721A Contracts v4.1.0
351 // Creator: Chiru Labs
352 
353 pragma solidity ^0.8.4;
354 
355 
356 /**
357  * @dev ERC721 token receiver interface.
358  */
359 interface ERC721A__IERC721Receiver {
360     function onERC721Received(
361         address operator,
362         address from,
363         uint256 tokenId,
364         bytes calldata data
365     ) external returns (bytes4);
366 }
367 
368 /**
369  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
370  * including the Metadata extension. Built to optimize for lower gas during batch mints.
371  *
372  * Assumes serials are sequentially minted starting at `_startTokenId()`
373  * (defaults to 0, e.g. 0, 1, 2, 3..).
374  *
375  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
376  *
377  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
378  */
379 contract ERC721A is IERC721A {
380     // Mask of an entry in packed address data.
381     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
382 
383     // The bit position of `numberMinted` in packed address data.
384     uint256 private constant BITPOS_NUMBER_MINTED = 64;
385 
386     // The bit position of `numberBurned` in packed address data.
387     uint256 private constant BITPOS_NUMBER_BURNED = 128;
388 
389     // The bit position of `aux` in packed address data.
390     uint256 private constant BITPOS_AUX = 192;
391 
392     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
393     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
394 
395     // The bit position of `startTimestamp` in packed ownership.
396     uint256 private constant BITPOS_START_TIMESTAMP = 160;
397 
398     // The bit mask of the `burned` bit in packed ownership.
399     uint256 private constant BITMASK_BURNED = 1 << 224;
400 
401     // The bit position of the `nextInitialized` bit in packed ownership.
402     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
403 
404     // The bit mask of the `nextInitialized` bit in packed ownership.
405     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
406 
407     // The bit position of `extraData` in packed ownership.
408     uint256 private constant BITPOS_EXTRA_DATA = 232;
409 
410     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
411     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
412 
413     // The mask of the lower 160 bits for addresses.
414     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
415 
416     // The maximum `quantity` that can be minted with `_mintERC2309`.
417     // This limit is to prevent overflows on the address data entries.
418     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
419     // is required to cause an overflow, which is unrealistic.
420     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
421 
422     // The tokenId of the next token to be minted.
423     uint256 private _currentIndex;
424 
425     // The number of tokens burned.
426     uint256 private _burnCounter;
427 
428     // Token name
429     string private _name;
430 
431     // Token symbol
432     string private _symbol;
433 
434     // Mapping from token ID to ownership details
435     // An empty struct value does not necessarily mean the token is unowned.
436     // See `_packedOwnershipOf` implementation for details.
437     //
438     // Bits Layout:
439     // - [0..159]   `addr`
440     // - [160..223] `startTimestamp`
441     // - [224]      `burned`
442     // - [225]      `nextInitialized`
443     // - [232..255] `extraData`
444     mapping(uint256 => uint256) private _packedOwnerships;
445 
446     // Mapping owner address to address data.
447     //
448     // Bits Layout:
449     // - [0..63]    `balance`
450     // - [64..127]  `numberMinted`
451     // - [128..191] `numberBurned`
452     // - [192..255] `aux`
453     mapping(address => uint256) private _packedAddressData;
454 
455     // Mapping from token ID to approved address.
456     mapping(uint256 => address) private _tokenApprovals;
457 
458     // Mapping from owner to operator approvals
459     mapping(address => mapping(address => bool)) private _operatorApprovals;
460 
461     constructor(string memory name_, string memory symbol_) {
462         _name = name_;
463         _symbol = symbol_;
464         _currentIndex = _startTokenId();
465     }
466 
467     /**
468      * @dev Returns the starting token ID.
469      * To change the starting token ID, please override this function.
470      */
471     function _startTokenId() internal view virtual returns (uint256) {
472         return 0;
473     }
474 
475     /**
476      * @dev Returns the next token ID to be minted.
477      */
478     function _nextTokenId() internal view returns (uint256) {
479         return _currentIndex;
480     }
481 
482     /**
483      * @dev Returns the total number of tokens in existence.
484      * Burned tokens will reduce the count.
485      * To get the total number of tokens minted, please see `_totalMinted`.
486      */
487     function totalSupply() public view override returns (uint256) {
488         // Counter underflow is impossible as _burnCounter cannot be incremented
489         // more than `_currentIndex - _startTokenId()` times.
490         unchecked {
491             return _currentIndex - _burnCounter - _startTokenId();
492         }
493     }
494 
495     /**
496      * @dev Returns the total amount of tokens minted in the contract.
497      */
498     function _totalMinted() internal view returns (uint256) {
499         // Counter underflow is impossible as _currentIndex does not decrement,
500         // and it is initialized to `_startTokenId()`
501         unchecked {
502             return _currentIndex - _startTokenId();
503         }
504     }
505 
506     /**
507      * @dev Returns the total number of tokens burned.
508      */
509     function _totalBurned() internal view returns (uint256) {
510         return _burnCounter;
511     }
512 
513     /**
514      * @dev See {IERC165-supportsInterface}.
515      */
516     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
517         // The interface IDs are constants representing the first 4 bytes of the XOR of
518         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
519         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
520         return
521             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
522             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
523             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
524     }
525 
526     /**
527      * @dev See {IERC721-balanceOf}.
528      */
529     function balanceOf(address owner) public view override returns (uint256) {
530         if (owner == address(0)) revert BalanceQueryForZeroAddress();
531         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
532     }
533 
534     /**
535      * Returns the number of tokens minted by `owner`.
536      */
537     function _numberMinted(address owner) internal view returns (uint256) {
538         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
539     }
540 
541     /**
542      * Returns the number of tokens burned by or on behalf of `owner`.
543      */
544     function _numberBurned(address owner) internal view returns (uint256) {
545         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
546     }
547 
548     /**
549      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
550      */
551     function _getAux(address owner) internal view returns (uint64) {
552         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
553     }
554 
555     /**
556      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
557      * If there are multiple variables, please pack them into a uint64.
558      */
559     function _setAux(address owner, uint64 aux) internal {
560         uint256 packed = _packedAddressData[owner];
561         uint256 auxCasted;
562         // Cast `aux` with assembly to avoid redundant masking.
563         assembly {
564             auxCasted := aux
565         }
566         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
567         _packedAddressData[owner] = packed;
568     }
569 
570     /**
571      * Returns the packed ownership data of `tokenId`.
572      */
573     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
574         uint256 curr = tokenId;
575 
576         unchecked {
577             if (_startTokenId() <= curr)
578                 if (curr < _currentIndex) {
579                     uint256 packed = _packedOwnerships[curr];
580                     // If not burned.
581                     if (packed & BITMASK_BURNED == 0) {
582                         // Invariant:
583                         // There will always be an ownership that has an address and is not burned
584                         // before an ownership that does not have an address and is not burned.
585                         // Hence, curr will not underflow.
586                         //
587                         // We can directly compare the packed value.
588                         // If the address is zero, packed is zero.
589                         while (packed == 0) {
590                             packed = _packedOwnerships[--curr];
591                         }
592                         return packed;
593                     }
594                 }
595         }
596         revert OwnerQueryForNonexistentToken();
597     }
598 
599     /**
600      * Returns the unpacked `TokenOwnership` struct from `packed`.
601      */
602     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
603         ownership.addr = address(uint160(packed));
604         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
605         ownership.burned = packed & BITMASK_BURNED != 0;
606         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
607     }
608 
609     /**
610      * Returns the unpacked `TokenOwnership` struct at `index`.
611      */
612     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
613         return _unpackedOwnership(_packedOwnerships[index]);
614     }
615 
616     /**
617      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
618      */
619     function _initializeOwnershipAt(uint256 index) internal {
620         if (_packedOwnerships[index] == 0) {
621             _packedOwnerships[index] = _packedOwnershipOf(index);
622         }
623     }
624 
625     /**
626      * Gas spent here starts off proportional to the maximum mint batch size.
627      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
628      */
629     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
630         return _unpackedOwnership(_packedOwnershipOf(tokenId));
631     }
632 
633     /**
634      * @dev Packs ownership data into a single uint256.
635      */
636     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
637         assembly {
638             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
639             owner := and(owner, BITMASK_ADDRESS)
640             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
641             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
642         }
643     }
644 
645     /**
646      * @dev See {IERC721-ownerOf}.
647      */
648     function ownerOf(uint256 tokenId) public view override returns (address) {
649         return address(uint160(_packedOwnershipOf(tokenId)));
650     }
651 
652     /**
653      * @dev See {IERC721Metadata-name}.
654      */
655     function name() public view virtual override returns (string memory) {
656         return _name;
657     }
658 
659     /**
660      * @dev See {IERC721Metadata-symbol}.
661      */
662     function symbol() public view virtual override returns (string memory) {
663         return _symbol;
664     }
665 
666     /**
667      * @dev See {IERC721Metadata-tokenURI}.
668      */
669     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
670         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
671 
672         string memory baseURI = _baseURI();
673         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
674     }
675 
676     /**
677      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
678      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
679      * by default, it can be overridden in child contracts.
680      */
681     function _baseURI() internal view virtual returns (string memory) {
682         return '';
683     }
684 
685     /**
686      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
687      */
688     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
689         // For branchless setting of the `nextInitialized` flag.
690         assembly {
691             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
692             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
693         }
694     }
695 
696     /**
697      * @dev See {IERC721-approve}.
698      */
699     function approve(address to, uint256 tokenId) public override {
700         address owner = ownerOf(tokenId);
701 
702         if (_msgSenderERC721A() != owner)
703             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
704                 revert ApprovalCallerNotOwnerNorApproved();
705             }
706 
707         _tokenApprovals[tokenId] = to;
708         emit Approval(owner, to, tokenId);
709     }
710 
711     /**
712      * @dev See {IERC721-getApproved}.
713      */
714     function getApproved(uint256 tokenId) public view override returns (address) {
715         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
716 
717         return _tokenApprovals[tokenId];
718     }
719 
720     /**
721      * @dev See {IERC721-setApprovalForAll}.
722      */
723     function setApprovalForAll(address operator, bool approved) public virtual override {
724         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
725 
726         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
727         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
728     }
729 
730     /**
731      * @dev See {IERC721-isApprovedForAll}.
732      */
733     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
734         return _operatorApprovals[owner][operator];
735     }
736 
737     /**
738      * @dev See {IERC721-safeTransferFrom}.
739      */
740     function safeTransferFrom(
741         address from,
742         address to,
743         uint256 tokenId
744     ) public virtual override {
745         safeTransferFrom(from, to, tokenId, '');
746     }
747 
748     /**
749      * @dev See {IERC721-safeTransferFrom}.
750      */
751     function safeTransferFrom(
752         address from,
753         address to,
754         uint256 tokenId,
755         bytes memory _data
756     ) public virtual override {
757         transferFrom(from, to, tokenId);
758         if (to.code.length != 0)
759             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
760                 revert TransferToNonERC721ReceiverImplementer();
761             }
762     }
763 
764     /**
765      * @dev Returns whether `tokenId` exists.
766      *
767      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
768      *
769      * Tokens start existing when they are minted (`_mint`),
770      */
771     function _exists(uint256 tokenId) internal view returns (bool) {
772         return
773             _startTokenId() <= tokenId &&
774             tokenId < _currentIndex && // If within bounds,
775             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
776     }
777 
778     /**
779      * @dev Equivalent to `_safeMint(to, quantity, '')`.
780      */
781     function _safeMint(address to, uint256 quantity) internal {
782         _safeMint(to, quantity, '');
783     }
784 
785     /**
786      * @dev Safely mints `quantity` tokens and transfers them to `to`.
787      *
788      * Requirements:
789      *
790      * - If `to` refers to a smart contract, it must implement
791      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
792      * - `quantity` must be greater than 0.
793      *
794      * See {_mint}.
795      *
796      * Emits a {Transfer} event for each mint.
797      */
798     function _safeMint(
799         address to,
800         uint256 quantity,
801         bytes memory _data
802     ) internal {
803         _mint(to, quantity);
804 
805         unchecked {
806             if (to.code.length != 0) {
807                 uint256 end = _currentIndex;
808                 uint256 index = end - quantity;
809                 do {
810                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
811                         revert TransferToNonERC721ReceiverImplementer();
812                     }
813                 } while (index < end);
814                 // Reentrancy protection.
815                 if (_currentIndex != end) revert();
816             }
817         }
818     }
819 
820     /**
821      * @dev Mints `quantity` tokens and transfers them to `to`.
822      *
823      * Requirements:
824      *
825      * - `to` cannot be the zero address.
826      * - `quantity` must be greater than 0.
827      *
828      * Emits a {Transfer} event for each mint.
829      */
830     function _mint(address to, uint256 quantity) internal {
831         uint256 startTokenId = _currentIndex;
832         if (to == address(0)) revert MintToZeroAddress();
833         if (quantity == 0) revert MintZeroQuantity();
834 
835         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
836 
837         // Overflows are incredibly unrealistic.
838         // `balance` and `numberMinted` have a maximum limit of 2**64.
839         // `tokenId` has a maximum limit of 2**256.
840         unchecked {
841             // Updates:
842             // - `balance += quantity`.
843             // - `numberMinted += quantity`.
844             //
845             // We can directly add to the `balance` and `numberMinted`.
846             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
847 
848             // Updates:
849             // - `address` to the owner.
850             // - `startTimestamp` to the timestamp of minting.
851             // - `burned` to `false`.
852             // - `nextInitialized` to `quantity == 1`.
853             _packedOwnerships[startTokenId] = _packOwnershipData(
854                 to,
855                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
856             );
857 
858             uint256 tokenId = startTokenId;
859             uint256 end = startTokenId + quantity;
860             do {
861                 emit Transfer(address(0), to, tokenId++);
862             } while (tokenId < end);
863 
864             _currentIndex = end;
865         }
866         _afterTokenTransfers(address(0), to, startTokenId, quantity);
867     }
868 
869     /**
870      * @dev Mints `quantity` tokens and transfers them to `to`.
871      *
872      * This function is intended for efficient minting only during contract creation.
873      *
874      * It emits only one {ConsecutiveTransfer} as defined in
875      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
876      * instead of a sequence of {Transfer} event(s).
877      *
878      * Calling this function outside of contract creation WILL make your contract
879      * non-compliant with the ERC721 standard.
880      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
881      * {ConsecutiveTransfer} event is only permissible during contract creation.
882      *
883      * Requirements:
884      *
885      * - `to` cannot be the zero address.
886      * - `quantity` must be greater than 0.
887      *
888      * Emits a {ConsecutiveTransfer} event.
889      */
890     function _mintERC2309(address to, uint256 quantity) internal {
891         uint256 startTokenId = _currentIndex;
892         if (to == address(0)) revert MintToZeroAddress();
893         if (quantity == 0) revert MintZeroQuantity();
894         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
895 
896         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
897 
898         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
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
917             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
918 
919             _currentIndex = startTokenId + quantity;
920         }
921         _afterTokenTransfers(address(0), to, startTokenId, quantity);
922     }
923 
924     /**
925      * @dev Returns the storage slot and value for the approved address of `tokenId`.
926      */
927     function _getApprovedAddress(uint256 tokenId)
928         private
929         view
930         returns (uint256 approvedAddressSlot, address approvedAddress)
931     {
932         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
933         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
934         assembly {
935             // Compute the slot.
936             mstore(0x00, tokenId)
937             mstore(0x20, tokenApprovalsPtr.slot)
938             approvedAddressSlot := keccak256(0x00, 0x40)
939             // Load the slot's value from storage.
940             approvedAddress := sload(approvedAddressSlot)
941         }
942     }
943 
944     /**
945      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
946      */
947     function _isOwnerOrApproved(
948         address approvedAddress,
949         address from,
950         address msgSender
951     ) private pure returns (bool result) {
952         assembly {
953             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
954             from := and(from, BITMASK_ADDRESS)
955             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
956             msgSender := and(msgSender, BITMASK_ADDRESS)
957             // `msgSender == from || msgSender == approvedAddress`.
958             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
959         }
960     }
961 
962     /**
963      * @dev Transfers `tokenId` from `from` to `to`.
964      *
965      * Requirements:
966      *
967      * - `to` cannot be the zero address.
968      * - `tokenId` token must be owned by `from`.
969      *
970      * Emits a {Transfer} event.
971      */
972     function transferFrom(
973         address from,
974         address to,
975         uint256 tokenId
976     ) public virtual override {
977         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
978 
979         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
980 
981         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
982 
983         // The nested ifs save around 20+ gas over a compound boolean condition.
984         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
985             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
986 
987         if (to == address(0)) revert TransferToZeroAddress();
988 
989         _beforeTokenTransfers(from, to, tokenId, 1);
990 
991         // Clear approvals from the previous owner.
992         assembly {
993             if approvedAddress {
994                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
995                 sstore(approvedAddressSlot, 0)
996             }
997         }
998 
999         // Underflow of the sender's balance is impossible because we check for
1000         // ownership above and the recipient's balance can't realistically overflow.
1001         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1002         unchecked {
1003             // We can directly increment and decrement the balances.
1004             --_packedAddressData[from]; // Updates: `balance -= 1`.
1005             ++_packedAddressData[to]; // Updates: `balance += 1`.
1006 
1007             // Updates:
1008             // - `address` to the next owner.
1009             // - `startTimestamp` to the timestamp of transfering.
1010             // - `burned` to `false`.
1011             // - `nextInitialized` to `true`.
1012             _packedOwnerships[tokenId] = _packOwnershipData(
1013                 to,
1014                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1015             );
1016 
1017             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1018             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1019                 uint256 nextTokenId = tokenId + 1;
1020                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1021                 if (_packedOwnerships[nextTokenId] == 0) {
1022                     // If the next slot is within bounds.
1023                     if (nextTokenId != _currentIndex) {
1024                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1025                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1026                     }
1027                 }
1028             }
1029         }
1030 
1031         emit Transfer(from, to, tokenId);
1032         _afterTokenTransfers(from, to, tokenId, 1);
1033     }
1034 
1035     /**
1036      * @dev Equivalent to `_burn(tokenId, false)`.
1037      */
1038     function _burn(uint256 tokenId) internal virtual {
1039         _burn(tokenId, false);
1040     }
1041 
1042     /**
1043      * @dev Destroys `tokenId`.
1044      * The approval is cleared when the token is burned.
1045      *
1046      * Requirements:
1047      *
1048      * - `tokenId` must exist.
1049      *
1050      * Emits a {Transfer} event.
1051      */
1052     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1053         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1054 
1055         address from = address(uint160(prevOwnershipPacked));
1056 
1057         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1058 
1059         if (approvalCheck) {
1060             // The nested ifs save around 20+ gas over a compound boolean condition.
1061             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1062                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1063         }
1064 
1065         _beforeTokenTransfers(from, address(0), tokenId, 1);
1066 
1067         // Clear approvals from the previous owner.
1068         assembly {
1069             if approvedAddress {
1070                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1071                 sstore(approvedAddressSlot, 0)
1072             }
1073         }
1074 
1075         // Underflow of the sender's balance is impossible because we check for
1076         // ownership above and the recipient's balance can't realistically overflow.
1077         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1078         unchecked {
1079             // Updates:
1080             // - `balance -= 1`.
1081             // - `numberBurned += 1`.
1082             //
1083             // We can directly decrement the balance, and increment the number burned.
1084             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1085             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1086 
1087             // Updates:
1088             // - `address` to the last owner.
1089             // - `startTimestamp` to the timestamp of burning.
1090             // - `burned` to `true`.
1091             // - `nextInitialized` to `true`.
1092             _packedOwnerships[tokenId] = _packOwnershipData(
1093                 from,
1094                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1095             );
1096 
1097             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1098             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1099                 uint256 nextTokenId = tokenId + 1;
1100                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1101                 if (_packedOwnerships[nextTokenId] == 0) {
1102                     // If the next slot is within bounds.
1103                     if (nextTokenId != _currentIndex) {
1104                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1105                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1106                     }
1107                 }
1108             }
1109         }
1110 
1111         emit Transfer(from, address(0), tokenId);
1112         _afterTokenTransfers(from, address(0), tokenId, 1);
1113 
1114         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1115         unchecked {
1116             _burnCounter++;
1117         }
1118     }
1119 
1120     /**
1121      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1122      *
1123      * @param from address representing the previous owner of the given token ID
1124      * @param to target address that will receive the tokens
1125      * @param tokenId uint256 ID of the token to be transferred
1126      * @param _data bytes optional data to send along with the call
1127      * @return bool whether the call correctly returned the expected magic value
1128      */
1129     function _checkContractOnERC721Received(
1130         address from,
1131         address to,
1132         uint256 tokenId,
1133         bytes memory _data
1134     ) private returns (bool) {
1135         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1136             bytes4 retval
1137         ) {
1138             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1139         } catch (bytes memory reason) {
1140             if (reason.length == 0) {
1141                 revert TransferToNonERC721ReceiverImplementer();
1142             } else {
1143                 assembly {
1144                     revert(add(32, reason), mload(reason))
1145                 }
1146             }
1147         }
1148     }
1149 
1150     /**
1151      * @dev Directly sets the extra data for the ownership data `index`.
1152      */
1153     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1154         uint256 packed = _packedOwnerships[index];
1155         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1156         uint256 extraDataCasted;
1157         // Cast `extraData` with assembly to avoid redundant masking.
1158         assembly {
1159             extraDataCasted := extraData
1160         }
1161         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1162         _packedOwnerships[index] = packed;
1163     }
1164 
1165     /**
1166      * @dev Returns the next extra data for the packed ownership data.
1167      * The returned result is shifted into position.
1168      */
1169     function _nextExtraData(
1170         address from,
1171         address to,
1172         uint256 prevOwnershipPacked
1173     ) private view returns (uint256) {
1174         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1175         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1176     }
1177 
1178     /**
1179      * @dev Called during each token transfer to set the 24bit `extraData` field.
1180      * Intended to be overridden by the cosumer contract.
1181      *
1182      * `previousExtraData` - the value of `extraData` before transfer.
1183      *
1184      * Calling conditions:
1185      *
1186      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1187      * transferred to `to`.
1188      * - When `from` is zero, `tokenId` will be minted for `to`.
1189      * - When `to` is zero, `tokenId` will be burned by `from`.
1190      * - `from` and `to` are never both zero.
1191      */
1192     function _extraData(
1193         address from,
1194         address to,
1195         uint24 previousExtraData
1196     ) internal view virtual returns (uint24) {}
1197 
1198     /**
1199      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1200      * This includes minting.
1201      * And also called before burning one token.
1202      *
1203      * startTokenId - the first token id to be transferred
1204      * quantity - the amount to be transferred
1205      *
1206      * Calling conditions:
1207      *
1208      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1209      * transferred to `to`.
1210      * - When `from` is zero, `tokenId` will be minted for `to`.
1211      * - When `to` is zero, `tokenId` will be burned by `from`.
1212      * - `from` and `to` are never both zero.
1213      */
1214     function _beforeTokenTransfers(
1215         address from,
1216         address to,
1217         uint256 startTokenId,
1218         uint256 quantity
1219     ) internal virtual {}
1220 
1221     /**
1222      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1223      * This includes minting.
1224      * And also called after one token has been burned.
1225      *
1226      * startTokenId - the first token id to be transferred
1227      * quantity - the amount to be transferred
1228      *
1229      * Calling conditions:
1230      *
1231      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1232      * transferred to `to`.
1233      * - When `from` is zero, `tokenId` has been minted for `to`.
1234      * - When `to` is zero, `tokenId` has been burned by `from`.
1235      * - `from` and `to` are never both zero.
1236      */
1237     function _afterTokenTransfers(
1238         address from,
1239         address to,
1240         uint256 startTokenId,
1241         uint256 quantity
1242     ) internal virtual {}
1243 
1244     /**
1245      * @dev Returns the message sender (defaults to `msg.sender`).
1246      *
1247      * If you are writing GSN compatible contracts, you need to override this function.
1248      */
1249     function _msgSenderERC721A() internal view virtual returns (address) {
1250         return msg.sender;
1251     }
1252 
1253     /**
1254      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1255      */
1256     function _toString(uint256 value) internal pure returns (string memory ptr) {
1257         assembly {
1258             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1259             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1260             // We will need 1 32-byte word to store the length,
1261             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1262             ptr := add(mload(0x40), 128)
1263             // Update the free memory pointer to allocate.
1264             mstore(0x40, ptr)
1265 
1266             // Cache the end of the memory to calculate the length later.
1267             let end := ptr
1268 
1269             // We write the string from the rightmost digit to the leftmost digit.
1270             // The following is essentially a do-while loop that also handles the zero case.
1271             // Costs a bit more than early returning for the zero case,
1272             // but cheaper in terms of deployment and overall runtime costs.
1273             for {
1274                 // Initialize and perform the first pass without check.
1275                 let temp := value
1276                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1277                 ptr := sub(ptr, 1)
1278                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1279                 mstore8(ptr, add(48, mod(temp, 10)))
1280                 temp := div(temp, 10)
1281             } temp {
1282                 // Keep dividing `temp` until zero.
1283                 temp := div(temp, 10)
1284             } {
1285                 // Body of the for loop.
1286                 ptr := sub(ptr, 1)
1287                 mstore8(ptr, add(48, mod(temp, 10)))
1288             }
1289 
1290             let length := sub(end, ptr)
1291             // Move the pointer 32 bytes leftwards to make room for the length.
1292             ptr := sub(ptr, 32)
1293             // Store the length.
1294             mstore(ptr, length)
1295         }
1296     }
1297 }
1298 
1299 // File: @openzeppelin/contracts/utils/Strings.sol
1300 
1301 
1302 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
1303 
1304 pragma solidity ^0.8.0;
1305 
1306 /**
1307  * @dev String operations.
1308  */
1309 library Strings {
1310     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1311 
1312     /**
1313      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1314      */
1315     function toString(uint256 value) internal pure returns (string memory) {
1316         // Inspired by OraclizeAPI's implementation - MIT licence
1317         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1318 
1319         if (value == 0) {
1320             return "0";
1321         }
1322         uint256 temp = value;
1323         uint256 digits;
1324         while (temp != 0) {
1325             digits++;
1326             temp /= 10;
1327         }
1328         bytes memory buffer = new bytes(digits);
1329         while (value != 0) {
1330             digits -= 1;
1331             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1332             value /= 10;
1333         }
1334         return string(buffer);
1335     }
1336 
1337     /**
1338      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1339      */
1340     function toHexString(uint256 value) internal pure returns (string memory) {
1341         if (value == 0) {
1342             return "0x00";
1343         }
1344         uint256 temp = value;
1345         uint256 length = 0;
1346         while (temp != 0) {
1347             length++;
1348             temp >>= 8;
1349         }
1350         return toHexString(value, length);
1351     }
1352 
1353     /**
1354      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1355      */
1356     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1357         bytes memory buffer = new bytes(2 * length + 2);
1358         buffer[0] = "0";
1359         buffer[1] = "x";
1360         for (uint256 i = 2 * length + 1; i > 1; --i) {
1361             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1362             value >>= 4;
1363         }
1364         require(value == 0, "Strings: hex length insufficient");
1365         return string(buffer);
1366     }
1367 }
1368 
1369 // File: @openzeppelin/contracts/utils/Context.sol
1370 
1371 
1372 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1373 
1374 pragma solidity ^0.8.0;
1375 
1376 /**
1377  * @dev Provides information about the current execution context, including the
1378  * sender of the transaction and its data. While these are generally available
1379  * via msg.sender and msg.data, they should not be accessed in such a direct
1380  * manner, since when dealing with meta-transactions the account sending and
1381  * paying for execution may not be the actual sender (as far as an application
1382  * is concerned).
1383  *
1384  * This contract is only required for intermediate, library-like contracts.
1385  */
1386 abstract contract Context {
1387     function _msgSender() internal view virtual returns (address) {
1388         return msg.sender;
1389     }
1390 
1391     function _msgData() internal view virtual returns (bytes calldata) {
1392         return msg.data;
1393     }
1394 }
1395 
1396 // File: @openzeppelin/contracts/access/Ownable.sol
1397 
1398 
1399 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1400 
1401 pragma solidity ^0.8.0;
1402 
1403 
1404 /**
1405  * @dev Contract module which provides a basic access control mechanism, where
1406  * there is an account (an owner) that can be granted exclusive access to
1407  * specific functions.
1408  *
1409  * By default, the owner account will be the one that deploys the contract. This
1410  * can later be changed with {transferOwnership}.
1411  *
1412  * This module is used through inheritance. It will make available the modifier
1413  * `onlyOwner`, which can be applied to your functions to restrict their use to
1414  * the owner.
1415  */
1416 abstract contract Ownable is Context {
1417     address private _owner;
1418 
1419     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1420 
1421     /**
1422      * @dev Initializes the contract setting the deployer as the initial owner.
1423      */
1424     constructor() {
1425         _transferOwnership(_msgSender());
1426     }
1427 
1428     /**
1429      * @dev Returns the address of the current owner.
1430      */
1431     function owner() public view virtual returns (address) {
1432         return _owner;
1433     }
1434 
1435     /**
1436      * @dev Throws if called by any account other than the owner.
1437      */
1438     modifier onlyOwner() {
1439         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1440         _;
1441     }
1442 
1443     /**
1444      * @dev Leaves the contract without owner. It will not be possible to call
1445      * `onlyOwner` functions anymore. Can only be called by the current owner.
1446      *
1447      * NOTE: Renouncing ownership will leave the contract without an owner,
1448      * thereby removing any functionality that is only available to the owner.
1449      */
1450     function renounceOwnership() public virtual onlyOwner {
1451         _transferOwnership(address(0));
1452     }
1453 
1454     /**
1455      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1456      * Can only be called by the current owner.
1457      */
1458     function transferOwnership(address newOwner) public virtual onlyOwner {
1459         require(newOwner != address(0), "Ownable: new owner is the zero address");
1460         _transferOwnership(newOwner);
1461     }
1462 
1463     /**
1464      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1465      * Internal function without access restriction.
1466      */
1467     function _transferOwnership(address newOwner) internal virtual {
1468         address oldOwner = _owner;
1469         _owner = newOwner;
1470         emit OwnershipTransferred(oldOwner, newOwner);
1471     }
1472 }
1473 
1474 // File: contracts/ppa.sol
1475 
1476 
1477 
1478 pragma solidity 0.8.7;
1479 
1480 
1481 
1482 
1483 
1484 contract PPA is ERC721A, Ownable, ReentrancyGuard {
1485     string private baseURI;
1486 
1487     // Public Variables
1488     bool public started = false;
1489     uint256 public minted = 0;
1490     uint256 public freeMinted = 0;
1491     bool public devCliamed = false;
1492 
1493     // Public Constants
1494     uint256 public constant MAX_SUPPLY = 5000;
1495     uint256 public constant FREE_SUPPLY = 2000;
1496     uint256 public constant PRICE = 0.0177 ether;
1497     uint256 public constant MAX_MINT = 2;
1498     uint256 public constant DEV_MINT = 200;
1499 
1500     mapping(address => uint256) public addressClaimed;
1501 
1502     constructor() ERC721A("Poke Poke Ahh", "PPA") {}
1503 
1504     // Start tokenid at 1 instead of 0
1505     function _startTokenId() internal view virtual override returns (uint256) {
1506         return 1;
1507     }
1508 
1509     function mint(uint256 amount) external payable notContract nonReentrant {
1510         require(started, "Minting not started yet");
1511         require(
1512             addressClaimed[_msgSender()] + amount <= MAX_MINT,
1513             "Exceed wallet max mint: 2"
1514         );
1515         require(totalSupply() < MAX_SUPPLY, "Minting Finished");
1516         require(totalSupply() + amount <= MAX_SUPPLY, "Exceed max supply");
1517         require(msg.sender != owner(), "Dev is not allowd to use public mint");
1518 
1519         uint256 freeQuota = FREE_SUPPLY - freeMinted;
1520         uint256 freeAmount = 0;
1521 
1522         if (freeQuota >= MAX_MINT) {
1523             // all free
1524             freeAmount = amount;
1525         } else if (freeQuota > 0) {
1526             // partially free
1527             freeAmount = freeQuota;
1528         } else {
1529             freeAmount = 0;
1530         }
1531 
1532         uint256 requiredValue = (amount - freeAmount) * PRICE;
1533         require(requiredValue <= msg.value, "Insufficient funds");
1534 
1535         _safeMint(msg.sender, amount);
1536         addressClaimed[_msgSender()] += amount;
1537         freeMinted += freeAmount;
1538         minted += amount;
1539     }
1540 
1541     function setBaseURI(string memory baseURI_) external onlyOwner {
1542         baseURI = baseURI_;
1543     }
1544 
1545     function _baseURI() internal view virtual override returns (string memory) {
1546         return baseURI;
1547     }
1548 
1549     function enableMint(bool mintStarted) external onlyOwner {
1550         started = mintStarted;
1551     }
1552 
1553     function getBalance() external view returns (uint256) {
1554         return address(this).balance;
1555     }
1556 
1557     function withdraw() external onlyOwner {
1558         payable(msg.sender).transfer(address(this).balance);
1559     }
1560 
1561     function _isContract(address account) internal view returns (bool) {
1562         uint256 size;
1563         assembly {
1564             size := extcodesize(account)
1565         }
1566         return size > 0;
1567     }
1568 
1569     function devMint() external onlyOwner {
1570         require(totalSupply() < MAX_SUPPLY, "Minting Finished");
1571         require(devCliamed == false, "Dev mint over");
1572         _safeMint(msg.sender, DEV_MINT);
1573         freeMinted += DEV_MINT;
1574         minted += DEV_MINT;
1575         devCliamed = true;
1576     }
1577 
1578     modifier notContract() {
1579         require(!_isContract(msg.sender), "Contract not allowed");
1580         require(msg.sender == tx.origin, "Proxy contract not allowed");
1581         _;
1582     }
1583 }