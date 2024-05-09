1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev String operations.
10  */
11 library Strings {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
13 
14     /**
15      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
16      */
17     function toString(uint256 value) internal pure returns (string memory) {
18         // Inspired by OraclizeAPI's implementation - MIT licence
19         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
20 
21         if (value == 0) {
22             return "0";
23         }
24         uint256 temp = value;
25         uint256 digits;
26         while (temp != 0) {
27             digits++;
28             temp /= 10;
29         }
30         bytes memory buffer = new bytes(digits);
31         while (value != 0) {
32             digits -= 1;
33             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
34             value /= 10;
35         }
36         return string(buffer);
37     }
38 
39     /**
40      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
41      */
42     function toHexString(uint256 value) internal pure returns (string memory) {
43         if (value == 0) {
44             return "0x00";
45         }
46         uint256 temp = value;
47         uint256 length = 0;
48         while (temp != 0) {
49             length++;
50             temp >>= 8;
51         }
52         return toHexString(value, length);
53     }
54 
55     /**
56      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
57      */
58     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
59         bytes memory buffer = new bytes(2 * length + 2);
60         buffer[0] = "0";
61         buffer[1] = "x";
62         for (uint256 i = 2 * length + 1; i > 1; --i) {
63             buffer[i] = _HEX_SYMBOLS[value & 0xf];
64             value >>= 4;
65         }
66         require(value == 0, "Strings: hex length insufficient");
67         return string(buffer);
68     }
69 }
70 
71 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
72 
73 
74 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
75 
76 pragma solidity ^0.8.0;
77 
78 /**
79  * @dev Contract module that helps prevent reentrant calls to a function.
80  *
81  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
82  * available, which can be applied to functions to make sure there are no nested
83  * (reentrant) calls to them.
84  *
85  * Note that because there is a single `nonReentrant` guard, functions marked as
86  * `nonReentrant` may not call one another. This can be worked around by making
87  * those functions `private`, and then adding `external` `nonReentrant` entry
88  * points to them.
89  *
90  * TIP: If you would like to learn more about reentrancy and alternative ways
91  * to protect against it, check out our blog post
92  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
93  */
94 abstract contract ReentrancyGuard {
95     // Booleans are more expensive than uint256 or any type that takes up a full
96     // word because each write operation emits an extra SLOAD to first read the
97     // slot's contents, replace the bits taken up by the boolean, and then write
98     // back. This is the compiler's defense against contract upgrades and
99     // pointer aliasing, and it cannot be disabled.
100 
101     // The values being non-zero value makes deployment a bit more expensive,
102     // but in exchange the refund on every call to nonReentrant will be lower in
103     // amount. Since refunds are capped to a percentage of the total
104     // transaction's gas, it is best to keep them low in cases like this one, to
105     // increase the likelihood of the full refund coming into effect.
106     uint256 private constant _NOT_ENTERED = 1;
107     uint256 private constant _ENTERED = 2;
108 
109     uint256 private _status;
110 
111     constructor() {
112         _status = _NOT_ENTERED;
113     }
114 
115     /**
116      * @dev Prevents a contract from calling itself, directly or indirectly.
117      * Calling a `nonReentrant` function from another `nonReentrant`
118      * function is not supported. It is possible to prevent this from happening
119      * by making the `nonReentrant` function external, and making it call a
120      * `private` function that does the actual work.
121      */
122     modifier nonReentrant() {
123         // On the first call to nonReentrant, _notEntered will be true
124         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
125 
126         // Any calls to nonReentrant after this point will fail
127         _status = _ENTERED;
128 
129         _;
130 
131         // By storing the original value once again, a refund is triggered (see
132         // https://eips.ethereum.org/EIPS/eip-2200)
133         _status = _NOT_ENTERED;
134     }
135 }
136 
137 // File: erc721a/contracts/IERC721A.sol
138 
139 
140 // ERC721A Contracts v4.1.0
141 // Creator: Chiru Labs
142 
143 pragma solidity ^0.8.4;
144 
145 /**
146  * @dev Interface of an ERC721A compliant contract.
147  */
148 interface IERC721A {
149     /**
150      * The caller must own the token or be an approved operator.
151      */
152     error ApprovalCallerNotOwnerNorApproved();
153 
154     /**
155      * The token does not exist.
156      */
157     error ApprovalQueryForNonexistentToken();
158 
159     /**
160      * The caller cannot approve to their own address.
161      */
162     error ApproveToCaller();
163 
164     /**
165      * Cannot query the balance for the zero address.
166      */
167     error BalanceQueryForZeroAddress();
168 
169     /**
170      * Cannot mint to the zero address.
171      */
172     error MintToZeroAddress();
173 
174     /**
175      * The quantity of tokens minted must be more than zero.
176      */
177     error MintZeroQuantity();
178 
179     /**
180      * The token does not exist.
181      */
182     error OwnerQueryForNonexistentToken();
183 
184     /**
185      * The caller must own the token or be an approved operator.
186      */
187     error TransferCallerNotOwnerNorApproved();
188 
189     /**
190      * The token must be owned by `from`.
191      */
192     error TransferFromIncorrectOwner();
193 
194     /**
195      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
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
219     struct TokenOwnership {
220         // The address of the owner.
221         address addr;
222         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
223         uint64 startTimestamp;
224         // Whether the token has been burned.
225         bool burned;
226         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
227         uint24 extraData;
228     }
229 
230     /**
231      * @dev Returns the total amount of tokens stored by the contract.
232      *
233      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
234      */
235     function totalSupply() external view returns (uint256);
236 
237     // ==============================
238     //            IERC165
239     // ==============================
240 
241     /**
242      * @dev Returns true if this contract implements the interface defined by
243      * `interfaceId`. See the corresponding
244      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
245      * to learn more about how these ids are created.
246      *
247      * This function call must use less than 30 000 gas.
248      */
249     function supportsInterface(bytes4 interfaceId) external view returns (bool);
250 
251     // ==============================
252     //            IERC721
253     // ==============================
254 
255     /**
256      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
257      */
258     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
259 
260     /**
261      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
262      */
263     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
264 
265     /**
266      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
267      */
268     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
269 
270     /**
271      * @dev Returns the number of tokens in ``owner``'s account.
272      */
273     function balanceOf(address owner) external view returns (uint256 balance);
274 
275     /**
276      * @dev Returns the owner of the `tokenId` token.
277      *
278      * Requirements:
279      *
280      * - `tokenId` must exist.
281      */
282     function ownerOf(uint256 tokenId) external view returns (address owner);
283 
284     /**
285      * @dev Safely transfers `tokenId` token from `from` to `to`.
286      *
287      * Requirements:
288      *
289      * - `from` cannot be the zero address.
290      * - `to` cannot be the zero address.
291      * - `tokenId` token must exist and be owned by `from`.
292      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
293      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
294      *
295      * Emits a {Transfer} event.
296      */
297     function safeTransferFrom(
298         address from,
299         address to,
300         uint256 tokenId,
301         bytes calldata data
302     ) external;
303 
304     /**
305      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
306      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
307      *
308      * Requirements:
309      *
310      * - `from` cannot be the zero address.
311      * - `to` cannot be the zero address.
312      * - `tokenId` token must exist and be owned by `from`.
313      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
314      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
315      *
316      * Emits a {Transfer} event.
317      */
318     function safeTransferFrom(
319         address from,
320         address to,
321         uint256 tokenId
322     ) external;
323 
324     /**
325      * @dev Transfers `tokenId` token from `from` to `to`.
326      *
327      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
328      *
329      * Requirements:
330      *
331      * - `from` cannot be the zero address.
332      * - `to` cannot be the zero address.
333      * - `tokenId` token must be owned by `from`.
334      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
335      *
336      * Emits a {Transfer} event.
337      */
338     function transferFrom(
339         address from,
340         address to,
341         uint256 tokenId
342     ) external;
343 
344     /**
345      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
346      * The approval is cleared when the token is transferred.
347      *
348      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
349      *
350      * Requirements:
351      *
352      * - The caller must own the token or be an approved operator.
353      * - `tokenId` must exist.
354      *
355      * Emits an {Approval} event.
356      */
357     function approve(address to, uint256 tokenId) external;
358 
359     /**
360      * @dev Approve or remove `operator` as an operator for the caller.
361      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
362      *
363      * Requirements:
364      *
365      * - The `operator` cannot be the caller.
366      *
367      * Emits an {ApprovalForAll} event.
368      */
369     function setApprovalForAll(address operator, bool _approved) external;
370 
371     /**
372      * @dev Returns the account approved for `tokenId` token.
373      *
374      * Requirements:
375      *
376      * - `tokenId` must exist.
377      */
378     function getApproved(uint256 tokenId) external view returns (address operator);
379 
380     /**
381      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
382      *
383      * See {setApprovalForAll}
384      */
385     function isApprovedForAll(address owner, address operator) external view returns (bool);
386 
387     // ==============================
388     //        IERC721Metadata
389     // ==============================
390 
391     /**
392      * @dev Returns the token collection name.
393      */
394     function name() external view returns (string memory);
395 
396     /**
397      * @dev Returns the token collection symbol.
398      */
399     function symbol() external view returns (string memory);
400 
401     /**
402      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
403      */
404     function tokenURI(uint256 tokenId) external view returns (string memory);
405 
406     // ==============================
407     //            IERC2309
408     // ==============================
409 
410     /**
411      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
412      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
413      */
414     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
415 }
416 
417 // File: erc721a/contracts/ERC721A.sol
418 
419 
420 // ERC721A Contracts v4.1.0
421 // Creator: Chiru Labs
422 
423 pragma solidity ^0.8.4;
424 
425 
426 /**
427  * @dev ERC721 token receiver interface.
428  */
429 interface ERC721A__IERC721Receiver {
430     function onERC721Received(
431         address operator,
432         address from,
433         uint256 tokenId,
434         bytes calldata data
435     ) external returns (bytes4);
436 }
437 
438 /**
439  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
440  * including the Metadata extension. Built to optimize for lower gas during batch mints.
441  *
442  * Assumes serials are sequentially minted starting at `_startTokenId()`
443  * (defaults to 0, e.g. 0, 1, 2, 3..).
444  *
445  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
446  *
447  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
448  */
449 contract ERC721A is IERC721A {
450     // Mask of an entry in packed address data.
451     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
452 
453     // The bit position of `numberMinted` in packed address data.
454     uint256 private constant BITPOS_NUMBER_MINTED = 64;
455 
456     // The bit position of `numberBurned` in packed address data.
457     uint256 private constant BITPOS_NUMBER_BURNED = 128;
458 
459     // The bit position of `aux` in packed address data.
460     uint256 private constant BITPOS_AUX = 192;
461 
462     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
463     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
464 
465     // The bit position of `startTimestamp` in packed ownership.
466     uint256 private constant BITPOS_START_TIMESTAMP = 160;
467 
468     // The bit mask of the `burned` bit in packed ownership.
469     uint256 private constant BITMASK_BURNED = 1 << 224;
470 
471     // The bit position of the `nextInitialized` bit in packed ownership.
472     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
473 
474     // The bit mask of the `nextInitialized` bit in packed ownership.
475     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
476 
477     // The bit position of `extraData` in packed ownership.
478     uint256 private constant BITPOS_EXTRA_DATA = 232;
479 
480     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
481     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
482 
483     // The mask of the lower 160 bits for addresses.
484     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
485 
486     // The maximum `quantity` that can be minted with `_mintERC2309`.
487     // This limit is to prevent overflows on the address data entries.
488     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
489     // is required to cause an overflow, which is unrealistic.
490     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
491 
492     // The tokenId of the next token to be minted.
493     uint256 private _currentIndex;
494 
495     // The number of tokens burned.
496     uint256 private _burnCounter;
497 
498     // Token name
499     string private _name;
500 
501     // Token symbol
502     string private _symbol;
503 
504     // Mapping from token ID to ownership details
505     // An empty struct value does not necessarily mean the token is unowned.
506     // See `_packedOwnershipOf` implementation for details.
507     //
508     // Bits Layout:
509     // - [0..159]   `addr`
510     // - [160..223] `startTimestamp`
511     // - [224]      `burned`
512     // - [225]      `nextInitialized`
513     // - [232..255] `extraData`
514     mapping(uint256 => uint256) private _packedOwnerships;
515 
516     // Mapping owner address to address data.
517     //
518     // Bits Layout:
519     // - [0..63]    `balance`
520     // - [64..127]  `numberMinted`
521     // - [128..191] `numberBurned`
522     // - [192..255] `aux`
523     mapping(address => uint256) private _packedAddressData;
524 
525     // Mapping from token ID to approved address.
526     mapping(uint256 => address) private _tokenApprovals;
527 
528     // Mapping from owner to operator approvals
529     mapping(address => mapping(address => bool)) private _operatorApprovals;
530 
531     constructor(string memory name_, string memory symbol_) {
532         _name = name_;
533         _symbol = symbol_;
534         _currentIndex = _startTokenId();
535     }
536 
537     /**
538      * @dev Returns the starting token ID.
539      * To change the starting token ID, please override this function.
540      */
541     function _startTokenId() internal view virtual returns (uint256) {
542         return 0;
543     }
544 
545     /**
546      * @dev Returns the next token ID to be minted.
547      */
548     function _nextTokenId() internal view returns (uint256) {
549         return _currentIndex;
550     }
551 
552     /**
553      * @dev Returns the total number of tokens in existence.
554      * Burned tokens will reduce the count.
555      * To get the total number of tokens minted, please see `_totalMinted`.
556      */
557     function totalSupply() public view override returns (uint256) {
558         // Counter underflow is impossible as _burnCounter cannot be incremented
559         // more than `_currentIndex - _startTokenId()` times.
560         unchecked {
561             return _currentIndex - _burnCounter - _startTokenId();
562         }
563     }
564 
565     /**
566      * @dev Returns the total amount of tokens minted in the contract.
567      */
568     function _totalMinted() internal view returns (uint256) {
569         // Counter underflow is impossible as _currentIndex does not decrement,
570         // and it is initialized to `_startTokenId()`
571         unchecked {
572             return _currentIndex - _startTokenId();
573         }
574     }
575 
576     /**
577      * @dev Returns the total number of tokens burned.
578      */
579     function _totalBurned() internal view returns (uint256) {
580         return _burnCounter;
581     }
582 
583     /**
584      * @dev See {IERC165-supportsInterface}.
585      */
586     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
587         // The interface IDs are constants representing the first 4 bytes of the XOR of
588         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
589         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
590         return
591             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
592             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
593             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
594     }
595 
596     /**
597      * @dev See {IERC721-balanceOf}.
598      */
599     function balanceOf(address owner) public view override returns (uint256) {
600         if (owner == address(0)) revert BalanceQueryForZeroAddress();
601         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
602     }
603 
604     /**
605      * Returns the number of tokens minted by `owner`.
606      */
607     function _numberMinted(address owner) internal view returns (uint256) {
608         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
609     }
610 
611     /**
612      * Returns the number of tokens burned by or on behalf of `owner`.
613      */
614     function _numberBurned(address owner) internal view returns (uint256) {
615         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
616     }
617 
618     /**
619      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
620      */
621     function _getAux(address owner) internal view returns (uint64) {
622         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
623     }
624 
625     /**
626      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
627      * If there are multiple variables, please pack them into a uint64.
628      */
629     function _setAux(address owner, uint64 aux) internal {
630         uint256 packed = _packedAddressData[owner];
631         uint256 auxCasted;
632         // Cast `aux` with assembly to avoid redundant masking.
633         assembly {
634             auxCasted := aux
635         }
636         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
637         _packedAddressData[owner] = packed;
638     }
639 
640     /**
641      * Returns the packed ownership data of `tokenId`.
642      */
643     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
644         uint256 curr = tokenId;
645 
646         unchecked {
647             if (_startTokenId() <= curr)
648                 if (curr < _currentIndex) {
649                     uint256 packed = _packedOwnerships[curr];
650                     // If not burned.
651                     if (packed & BITMASK_BURNED == 0) {
652                         // Invariant:
653                         // There will always be an ownership that has an address and is not burned
654                         // before an ownership that does not have an address and is not burned.
655                         // Hence, curr will not underflow.
656                         //
657                         // We can directly compare the packed value.
658                         // If the address is zero, packed is zero.
659                         while (packed == 0) {
660                             packed = _packedOwnerships[--curr];
661                         }
662                         return packed;
663                     }
664                 }
665         }
666         revert OwnerQueryForNonexistentToken();
667     }
668 
669     /**
670      * Returns the unpacked `TokenOwnership` struct from `packed`.
671      */
672     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
673         ownership.addr = address(uint160(packed));
674         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
675         ownership.burned = packed & BITMASK_BURNED != 0;
676         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
677     }
678 
679     /**
680      * Returns the unpacked `TokenOwnership` struct at `index`.
681      */
682     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
683         return _unpackedOwnership(_packedOwnerships[index]);
684     }
685 
686     /**
687      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
688      */
689     function _initializeOwnershipAt(uint256 index) internal {
690         if (_packedOwnerships[index] == 0) {
691             _packedOwnerships[index] = _packedOwnershipOf(index);
692         }
693     }
694 
695     /**
696      * Gas spent here starts off proportional to the maximum mint batch size.
697      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
698      */
699     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
700         return _unpackedOwnership(_packedOwnershipOf(tokenId));
701     }
702 
703     /**
704      * @dev Packs ownership data into a single uint256.
705      */
706     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
707         assembly {
708             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
709             owner := and(owner, BITMASK_ADDRESS)
710             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
711             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
712         }
713     }
714 
715     /**
716      * @dev See {IERC721-ownerOf}.
717      */
718     function ownerOf(uint256 tokenId) public view override returns (address) {
719         return address(uint160(_packedOwnershipOf(tokenId)));
720     }
721 
722     /**
723      * @dev See {IERC721Metadata-name}.
724      */
725     function name() public view virtual override returns (string memory) {
726         return _name;
727     }
728 
729     /**
730      * @dev See {IERC721Metadata-symbol}.
731      */
732     function symbol() public view virtual override returns (string memory) {
733         return _symbol;
734     }
735 
736     /**
737      * @dev See {IERC721Metadata-tokenURI}.
738      */
739     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
740         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
741 
742         string memory baseURI = _baseURI();
743         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
744     }
745 
746     /**
747      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
748      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
749      * by default, it can be overridden in child contracts.
750      */
751     function _baseURI() internal view virtual returns (string memory) {
752         return '';
753     }
754 
755     /**
756      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
757      */
758     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
759         // For branchless setting of the `nextInitialized` flag.
760         assembly {
761             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
762             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
763         }
764     }
765 
766     /**
767      * @dev See {IERC721-approve}.
768      */
769     function approve(address to, uint256 tokenId) public override {
770         address owner = ownerOf(tokenId);
771 
772         if (_msgSenderERC721A() != owner)
773             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
774                 revert ApprovalCallerNotOwnerNorApproved();
775             }
776 
777         _tokenApprovals[tokenId] = to;
778         emit Approval(owner, to, tokenId);
779     }
780 
781     /**
782      * @dev See {IERC721-getApproved}.
783      */
784     function getApproved(uint256 tokenId) public view override returns (address) {
785         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
786 
787         return _tokenApprovals[tokenId];
788     }
789 
790     /**
791      * @dev See {IERC721-setApprovalForAll}.
792      */
793     function setApprovalForAll(address operator, bool approved) public virtual override {
794         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
795 
796         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
797         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
798     }
799 
800     /**
801      * @dev See {IERC721-isApprovedForAll}.
802      */
803     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
804         return _operatorApprovals[owner][operator];
805     }
806 
807     /**
808      * @dev See {IERC721-safeTransferFrom}.
809      */
810     function safeTransferFrom(
811         address from,
812         address to,
813         uint256 tokenId
814     ) public virtual override {
815         safeTransferFrom(from, to, tokenId, '');
816     }
817 
818     /**
819      * @dev See {IERC721-safeTransferFrom}.
820      */
821     function safeTransferFrom(
822         address from,
823         address to,
824         uint256 tokenId,
825         bytes memory _data
826     ) public virtual override {
827         transferFrom(from, to, tokenId);
828         if (to.code.length != 0)
829             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
830                 revert TransferToNonERC721ReceiverImplementer();
831             }
832     }
833 
834     /**
835      * @dev Returns whether `tokenId` exists.
836      *
837      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
838      *
839      * Tokens start existing when they are minted (`_mint`),
840      */
841     function _exists(uint256 tokenId) internal view returns (bool) {
842         return
843             _startTokenId() <= tokenId &&
844             tokenId < _currentIndex && // If within bounds,
845             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
846     }
847 
848     /**
849      * @dev Equivalent to `_safeMint(to, quantity, '')`.
850      */
851     function _safeMint(address to, uint256 quantity) internal {
852         _safeMint(to, quantity, '');
853     }
854 
855     /**
856      * @dev Safely mints `quantity` tokens and transfers them to `to`.
857      *
858      * Requirements:
859      *
860      * - If `to` refers to a smart contract, it must implement
861      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
862      * - `quantity` must be greater than 0.
863      *
864      * See {_mint}.
865      *
866      * Emits a {Transfer} event for each mint.
867      */
868     function _safeMint(
869         address to,
870         uint256 quantity,
871         bytes memory _data
872     ) internal {
873         _mint(to, quantity);
874 
875         unchecked {
876             if (to.code.length != 0) {
877                 uint256 end = _currentIndex;
878                 uint256 index = end - quantity;
879                 do {
880                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
881                         revert TransferToNonERC721ReceiverImplementer();
882                     }
883                 } while (index < end);
884                 // Reentrancy protection.
885                 if (_currentIndex != end) revert();
886             }
887         }
888     }
889 
890     /**
891      * @dev Mints `quantity` tokens and transfers them to `to`.
892      *
893      * Requirements:
894      *
895      * - `to` cannot be the zero address.
896      * - `quantity` must be greater than 0.
897      *
898      * Emits a {Transfer} event for each mint.
899      */
900     function _mint(address to, uint256 quantity) internal {
901         uint256 startTokenId = _currentIndex;
902         if (to == address(0)) revert MintToZeroAddress();
903         if (quantity == 0) revert MintZeroQuantity();
904 
905         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
906 
907         // Overflows are incredibly unrealistic.
908         // `balance` and `numberMinted` have a maximum limit of 2**64.
909         // `tokenId` has a maximum limit of 2**256.
910         unchecked {
911             // Updates:
912             // - `balance += quantity`.
913             // - `numberMinted += quantity`.
914             //
915             // We can directly add to the `balance` and `numberMinted`.
916             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
917 
918             // Updates:
919             // - `address` to the owner.
920             // - `startTimestamp` to the timestamp of minting.
921             // - `burned` to `false`.
922             // - `nextInitialized` to `quantity == 1`.
923             _packedOwnerships[startTokenId] = _packOwnershipData(
924                 to,
925                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
926             );
927 
928             uint256 tokenId = startTokenId;
929             uint256 end = startTokenId + quantity;
930             do {
931                 emit Transfer(address(0), to, tokenId++);
932             } while (tokenId < end);
933 
934             _currentIndex = end;
935         }
936         _afterTokenTransfers(address(0), to, startTokenId, quantity);
937     }
938 
939     /**
940      * @dev Mints `quantity` tokens and transfers them to `to`.
941      *
942      * This function is intended for efficient minting only during contract creation.
943      *
944      * It emits only one {ConsecutiveTransfer} as defined in
945      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
946      * instead of a sequence of {Transfer} event(s).
947      *
948      * Calling this function outside of contract creation WILL make your contract
949      * non-compliant with the ERC721 standard.
950      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
951      * {ConsecutiveTransfer} event is only permissible during contract creation.
952      *
953      * Requirements:
954      *
955      * - `to` cannot be the zero address.
956      * - `quantity` must be greater than 0.
957      *
958      * Emits a {ConsecutiveTransfer} event.
959      */
960     function _mintERC2309(address to, uint256 quantity) internal {
961         uint256 startTokenId = _currentIndex;
962         if (to == address(0)) revert MintToZeroAddress();
963         if (quantity == 0) revert MintZeroQuantity();
964         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
965 
966         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
967 
968         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
969         unchecked {
970             // Updates:
971             // - `balance += quantity`.
972             // - `numberMinted += quantity`.
973             //
974             // We can directly add to the `balance` and `numberMinted`.
975             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
976 
977             // Updates:
978             // - `address` to the owner.
979             // - `startTimestamp` to the timestamp of minting.
980             // - `burned` to `false`.
981             // - `nextInitialized` to `quantity == 1`.
982             _packedOwnerships[startTokenId] = _packOwnershipData(
983                 to,
984                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
985             );
986 
987             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
988 
989             _currentIndex = startTokenId + quantity;
990         }
991         _afterTokenTransfers(address(0), to, startTokenId, quantity);
992     }
993 
994     /**
995      * @dev Returns the storage slot and value for the approved address of `tokenId`.
996      */
997     function _getApprovedAddress(uint256 tokenId)
998         private
999         view
1000         returns (uint256 approvedAddressSlot, address approvedAddress)
1001     {
1002         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1003         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1004         assembly {
1005             // Compute the slot.
1006             mstore(0x00, tokenId)
1007             mstore(0x20, tokenApprovalsPtr.slot)
1008             approvedAddressSlot := keccak256(0x00, 0x40)
1009             // Load the slot's value from storage.
1010             approvedAddress := sload(approvedAddressSlot)
1011         }
1012     }
1013 
1014     /**
1015      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1016      */
1017     function _isOwnerOrApproved(
1018         address approvedAddress,
1019         address from,
1020         address msgSender
1021     ) private pure returns (bool result) {
1022         assembly {
1023             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1024             from := and(from, BITMASK_ADDRESS)
1025             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1026             msgSender := and(msgSender, BITMASK_ADDRESS)
1027             // `msgSender == from || msgSender == approvedAddress`.
1028             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1029         }
1030     }
1031 
1032     /**
1033      * @dev Transfers `tokenId` from `from` to `to`.
1034      *
1035      * Requirements:
1036      *
1037      * - `to` cannot be the zero address.
1038      * - `tokenId` token must be owned by `from`.
1039      *
1040      * Emits a {Transfer} event.
1041      */
1042     function transferFrom(
1043         address from,
1044         address to,
1045         uint256 tokenId
1046     ) public virtual override {
1047         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1048 
1049         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1050 
1051         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1052 
1053         // The nested ifs save around 20+ gas over a compound boolean condition.
1054         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1055             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1056 
1057         if (to == address(0)) revert TransferToZeroAddress();
1058 
1059         _beforeTokenTransfers(from, to, tokenId, 1);
1060 
1061         // Clear approvals from the previous owner.
1062         assembly {
1063             if approvedAddress {
1064                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1065                 sstore(approvedAddressSlot, 0)
1066             }
1067         }
1068 
1069         // Underflow of the sender's balance is impossible because we check for
1070         // ownership above and the recipient's balance can't realistically overflow.
1071         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1072         unchecked {
1073             // We can directly increment and decrement the balances.
1074             --_packedAddressData[from]; // Updates: `balance -= 1`.
1075             ++_packedAddressData[to]; // Updates: `balance += 1`.
1076 
1077             // Updates:
1078             // - `address` to the next owner.
1079             // - `startTimestamp` to the timestamp of transfering.
1080             // - `burned` to `false`.
1081             // - `nextInitialized` to `true`.
1082             _packedOwnerships[tokenId] = _packOwnershipData(
1083                 to,
1084                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1085             );
1086 
1087             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1088             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1089                 uint256 nextTokenId = tokenId + 1;
1090                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1091                 if (_packedOwnerships[nextTokenId] == 0) {
1092                     // If the next slot is within bounds.
1093                     if (nextTokenId != _currentIndex) {
1094                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1095                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1096                     }
1097                 }
1098             }
1099         }
1100 
1101         emit Transfer(from, to, tokenId);
1102         _afterTokenTransfers(from, to, tokenId, 1);
1103     }
1104 
1105     /**
1106      * @dev Equivalent to `_burn(tokenId, false)`.
1107      */
1108     function _burn(uint256 tokenId) internal virtual {
1109         _burn(tokenId, false);
1110     }
1111 
1112     /**
1113      * @dev Destroys `tokenId`.
1114      * The approval is cleared when the token is burned.
1115      *
1116      * Requirements:
1117      *
1118      * - `tokenId` must exist.
1119      *
1120      * Emits a {Transfer} event.
1121      */
1122     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1123         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1124 
1125         address from = address(uint160(prevOwnershipPacked));
1126 
1127         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1128 
1129         if (approvalCheck) {
1130             // The nested ifs save around 20+ gas over a compound boolean condition.
1131             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1132                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1133         }
1134 
1135         _beforeTokenTransfers(from, address(0), tokenId, 1);
1136 
1137         // Clear approvals from the previous owner.
1138         assembly {
1139             if approvedAddress {
1140                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1141                 sstore(approvedAddressSlot, 0)
1142             }
1143         }
1144 
1145         // Underflow of the sender's balance is impossible because we check for
1146         // ownership above and the recipient's balance can't realistically overflow.
1147         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1148         unchecked {
1149             // Updates:
1150             // - `balance -= 1`.
1151             // - `numberBurned += 1`.
1152             //
1153             // We can directly decrement the balance, and increment the number burned.
1154             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1155             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1156 
1157             // Updates:
1158             // - `address` to the last owner.
1159             // - `startTimestamp` to the timestamp of burning.
1160             // - `burned` to `true`.
1161             // - `nextInitialized` to `true`.
1162             _packedOwnerships[tokenId] = _packOwnershipData(
1163                 from,
1164                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1165             );
1166 
1167             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1168             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1169                 uint256 nextTokenId = tokenId + 1;
1170                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1171                 if (_packedOwnerships[nextTokenId] == 0) {
1172                     // If the next slot is within bounds.
1173                     if (nextTokenId != _currentIndex) {
1174                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1175                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1176                     }
1177                 }
1178             }
1179         }
1180 
1181         emit Transfer(from, address(0), tokenId);
1182         _afterTokenTransfers(from, address(0), tokenId, 1);
1183 
1184         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1185         unchecked {
1186             _burnCounter++;
1187         }
1188     }
1189 
1190     /**
1191      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1192      *
1193      * @param from address representing the previous owner of the given token ID
1194      * @param to target address that will receive the tokens
1195      * @param tokenId uint256 ID of the token to be transferred
1196      * @param _data bytes optional data to send along with the call
1197      * @return bool whether the call correctly returned the expected magic value
1198      */
1199     function _checkContractOnERC721Received(
1200         address from,
1201         address to,
1202         uint256 tokenId,
1203         bytes memory _data
1204     ) private returns (bool) {
1205         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1206             bytes4 retval
1207         ) {
1208             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1209         } catch (bytes memory reason) {
1210             if (reason.length == 0) {
1211                 revert TransferToNonERC721ReceiverImplementer();
1212             } else {
1213                 assembly {
1214                     revert(add(32, reason), mload(reason))
1215                 }
1216             }
1217         }
1218     }
1219 
1220     /**
1221      * @dev Directly sets the extra data for the ownership data `index`.
1222      */
1223     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1224         uint256 packed = _packedOwnerships[index];
1225         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1226         uint256 extraDataCasted;
1227         // Cast `extraData` with assembly to avoid redundant masking.
1228         assembly {
1229             extraDataCasted := extraData
1230         }
1231         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1232         _packedOwnerships[index] = packed;
1233     }
1234 
1235     /**
1236      * @dev Returns the next extra data for the packed ownership data.
1237      * The returned result is shifted into position.
1238      */
1239     function _nextExtraData(
1240         address from,
1241         address to,
1242         uint256 prevOwnershipPacked
1243     ) private view returns (uint256) {
1244         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1245         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1246     }
1247 
1248     /**
1249      * @dev Called during each token transfer to set the 24bit `extraData` field.
1250      * Intended to be overridden by the cosumer contract.
1251      *
1252      * `previousExtraData` - the value of `extraData` before transfer.
1253      *
1254      * Calling conditions:
1255      *
1256      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1257      * transferred to `to`.
1258      * - When `from` is zero, `tokenId` will be minted for `to`.
1259      * - When `to` is zero, `tokenId` will be burned by `from`.
1260      * - `from` and `to` are never both zero.
1261      */
1262     function _extraData(
1263         address from,
1264         address to,
1265         uint24 previousExtraData
1266     ) internal view virtual returns (uint24) {}
1267 
1268     /**
1269      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1270      * This includes minting.
1271      * And also called before burning one token.
1272      *
1273      * startTokenId - the first token id to be transferred
1274      * quantity - the amount to be transferred
1275      *
1276      * Calling conditions:
1277      *
1278      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1279      * transferred to `to`.
1280      * - When `from` is zero, `tokenId` will be minted for `to`.
1281      * - When `to` is zero, `tokenId` will be burned by `from`.
1282      * - `from` and `to` are never both zero.
1283      */
1284     function _beforeTokenTransfers(
1285         address from,
1286         address to,
1287         uint256 startTokenId,
1288         uint256 quantity
1289     ) internal virtual {}
1290 
1291     /**
1292      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1293      * This includes minting.
1294      * And also called after one token has been burned.
1295      *
1296      * startTokenId - the first token id to be transferred
1297      * quantity - the amount to be transferred
1298      *
1299      * Calling conditions:
1300      *
1301      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1302      * transferred to `to`.
1303      * - When `from` is zero, `tokenId` has been minted for `to`.
1304      * - When `to` is zero, `tokenId` has been burned by `from`.
1305      * - `from` and `to` are never both zero.
1306      */
1307     function _afterTokenTransfers(
1308         address from,
1309         address to,
1310         uint256 startTokenId,
1311         uint256 quantity
1312     ) internal virtual {}
1313 
1314     /**
1315      * @dev Returns the message sender (defaults to `msg.sender`).
1316      *
1317      * If you are writing GSN compatible contracts, you need to override this function.
1318      */
1319     function _msgSenderERC721A() internal view virtual returns (address) {
1320         return msg.sender;
1321     }
1322 
1323     /**
1324      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1325      */
1326     function _toString(uint256 value) internal pure returns (string memory ptr) {
1327         assembly {
1328             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1329             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1330             // We will need 1 32-byte word to store the length,
1331             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1332             ptr := add(mload(0x40), 128)
1333             // Update the free memory pointer to allocate.
1334             mstore(0x40, ptr)
1335 
1336             // Cache the end of the memory to calculate the length later.
1337             let end := ptr
1338 
1339             // We write the string from the rightmost digit to the leftmost digit.
1340             // The following is essentially a do-while loop that also handles the zero case.
1341             // Costs a bit more than early returning for the zero case,
1342             // but cheaper in terms of deployment and overall runtime costs.
1343             for {
1344                 // Initialize and perform the first pass without check.
1345                 let temp := value
1346                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1347                 ptr := sub(ptr, 1)
1348                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1349                 mstore8(ptr, add(48, mod(temp, 10)))
1350                 temp := div(temp, 10)
1351             } temp {
1352                 // Keep dividing `temp` until zero.
1353                 temp := div(temp, 10)
1354             } {
1355                 // Body of the for loop.
1356                 ptr := sub(ptr, 1)
1357                 mstore8(ptr, add(48, mod(temp, 10)))
1358             }
1359 
1360             let length := sub(end, ptr)
1361             // Move the pointer 32 bytes leftwards to make room for the length.
1362             ptr := sub(ptr, 32)
1363             // Store the length.
1364             mstore(ptr, length)
1365         }
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
1473 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
1474 
1475 
1476 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
1477 
1478 pragma solidity ^0.8.0;
1479 
1480 /**
1481  * @dev These functions deal with verification of Merkle Trees proofs.
1482  *
1483  * The proofs can be generated using the JavaScript library
1484  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1485  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1486  *
1487  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1488  *
1489  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1490  * hashing, or use a hash function other than keccak256 for hashing leaves.
1491  * This is because the concatenation of a sorted pair of internal nodes in
1492  * the merkle tree could be reinterpreted as a leaf value.
1493  */
1494 library MerkleProof {
1495     /**
1496      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1497      * defined by `root`. For this, a `proof` must be provided, containing
1498      * sibling hashes on the branch from the leaf to the root of the tree. Each
1499      * pair of leaves and each pair of pre-images are assumed to be sorted.
1500      */
1501     function verify(
1502         bytes32[] memory proof,
1503         bytes32 root,
1504         bytes32 leaf
1505     ) internal pure returns (bool) {
1506         return processProof(proof, leaf) == root;
1507     }
1508 
1509     /**
1510      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1511      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1512      * hash matches the root of the tree. When processing the proof, the pairs
1513      * of leafs & pre-images are assumed to be sorted.
1514      *
1515      * _Available since v4.4._
1516      */
1517     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1518         bytes32 computedHash = leaf;
1519         for (uint256 i = 0; i < proof.length; i++) {
1520             bytes32 proofElement = proof[i];
1521             if (computedHash <= proofElement) {
1522                 // Hash(current computed hash + current element of the proof)
1523                 computedHash = _efficientHash(computedHash, proofElement);
1524             } else {
1525                 // Hash(current element of the proof + current computed hash)
1526                 computedHash = _efficientHash(proofElement, computedHash);
1527             }
1528         }
1529         return computedHash;
1530     }
1531 
1532     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1533         assembly {
1534             mstore(0x00, a)
1535             mstore(0x20, b)
1536             value := keccak256(0x00, 0x40)
1537         }
1538     }
1539 }
1540 
1541 // File: contracts/ChronixPushers.sol
1542 
1543 
1544 pragma solidity ^0.8.7;
1545 
1546 
1547 
1548 
1549 
1550 
1551 
1552 interface IBUDS {
1553   function depositBudsFor(address user, uint256 amount) external;
1554 }
1555 
1556 interface ISTAKING {
1557   function getStakerPot() external view returns(uint256) ;
1558 }
1559 
1560 
1561 contract ChronixPushers is ERC721A, Ownable, ReentrancyGuard  {
1562     using Strings for uint256;
1563 
1564     string public baseURI;
1565     uint256 public constant MAX_PER_WALLET = 3;
1566     uint256 public constant MAX_SUPPLY = 3000;
1567     bool public publicMinting;
1568     bool public whitelistMinting;
1569 
1570     bytes32 public merkleRoot;
1571 
1572     mapping (address => uint256) public addressBalance;
1573     mapping (address => uint256) public userPot;
1574     IBUDS public BUDS;
1575     ISTAKING public STAKING;
1576     
1577     constructor(
1578         string memory _initBaseURI, address _buds, address _staking
1579     ) ERC721A("Chronix Pushers", "CRP") {
1580         baseURI = _initBaseURI;
1581         BUDS = IBUDS(_buds);
1582         STAKING = ISTAKING(_staking);
1583     }
1584 
1585     modifier mintCompliance(uint tokensToMint) {
1586         require(tokensToMint >= 1, "Min mint is 1 token");
1587         require(totalSupply() + tokensToMint <= MAX_SUPPLY, "Minting more tokens than allowed");
1588         require(addressBalance[msg.sender] + tokensToMint <= MAX_PER_WALLET,"Max per wallet is 3");
1589         _;
1590     }
1591   
1592 
1593     function mint(uint256 tokensToMint) public  nonReentrant mintCompliance(tokensToMint)  {
1594         require(publicMinting, "The mint has not started yet");
1595         addressBalance[msg.sender] += tokensToMint;
1596         _safeMint(msg.sender, tokensToMint);
1597     }
1598 
1599     function whitelistMint(uint256 tokensToMint, bytes32[] memory proof) public nonReentrant mintCompliance(tokensToMint) {
1600         require(whitelistMinting && !publicMinting,"Whitelist mint not active");
1601         require(isValid(proof, msg.sender), "Not whitelisted");
1602         addressBalance[msg.sender] += tokensToMint;
1603         _safeMint(msg.sender, tokensToMint);
1604     }
1605     
1606 
1607     function isValid(bytes32[] memory proof, address sender) public view returns (bool) {
1608         return MerkleProof.verify(proof, merkleRoot, keccak256(abi.encodePacked(sender)));
1609     }
1610 
1611      function _baseURI() internal view override returns (string memory) {
1612         return baseURI;
1613     }
1614 
1615     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1616     require(_exists(tokenId),"ERC721Metadata: URI query for nonexistent token");
1617     return
1618       bytes(baseURI).length > 0
1619         ? string(abi.encodePacked(_baseURI(), tokenId.toString(), '.json'))
1620         : "";
1621     }
1622 
1623     function setBaseURI(string calldata _newBaseURI) external onlyOwner {
1624         baseURI = _newBaseURI;
1625     }
1626 
1627     function setMerkleRoot(bytes32 root) external onlyOwner { 
1628         merkleRoot = root;
1629     }
1630 
1631     function reserveNfts(uint tokensToMint) public onlyOwner {
1632         _safeMint(msg.sender, tokensToMint);
1633     }
1634     
1635     function flipPublicMinting() public onlyOwner { 
1636         publicMinting = !publicMinting;
1637     }
1638     function flipWhitelistMinting() public onlyOwner { 
1639         whitelistMinting = !whitelistMinting;
1640     }
1641 
1642     function setStakingContract(address _source) public onlyOwner {
1643       STAKING = ISTAKING(_source);
1644       
1645     }
1646     function setBudsContract(address _source) public onlyOwner {
1647       BUDS = IBUDS(_source);
1648       
1649     }
1650 
1651 
1652     //STAKING
1653     function getPotTax(address staker) public view returns(uint amountEarned) {
1654         if(totalSupply() !=0 ){
1655           return (STAKING.getStakerPot()- userPot[staker])*((balanceOf(staker) * 10000) / totalSupply()) /10000;
1656         }
1657         else {
1658           return 0;
1659         }
1660     }
1661 
1662     function claim() public nonReentrant {
1663         uint amount=getPotTax(msg.sender);
1664         require(amount != 0);
1665         BUDS.depositBudsFor(msg.sender,amount);
1666         userPot[msg.sender]=STAKING.getStakerPot();
1667     }
1668     
1669 }