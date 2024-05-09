1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
4 
5 
6 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Contract module that helps prevent reentrant calls to a function.
12  *
13  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
14  * available, which can be applied to functions to make sure there are no nested
15  * (reentrant) calls to them.
16  *
17  * Note that because there is a single `nonReentrant` guard, functions marked as
18  * `nonReentrant` may not call one another. This can be worked around by making
19  * those functions `private`, and then adding `external` `nonReentrant` entry
20  * points to them.
21  *
22  * TIP: If you would like to learn more about reentrancy and alternative ways
23  * to protect against it, check out our blog post
24  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
25  */
26 abstract contract ReentrancyGuard {
27     // Booleans are more expensive than uint256 or any type that takes up a full
28     // word because each write operation emits an extra SLOAD to first read the
29     // slot's contents, replace the bits taken up by the boolean, and then write
30     // back. This is the compiler's defense against contract upgrades and
31     // pointer aliasing, and it cannot be disabled.
32 
33     // The values being non-zero value makes deployment a bit more expensive,
34     // but in exchange the refund on every call to nonReentrant will be lower in
35     // amount. Since refunds are capped to a percentage of the total
36     // transaction's gas, it is best to keep them low in cases like this one, to
37     // increase the likelihood of the full refund coming into effect.
38     uint256 private constant _NOT_ENTERED = 1;
39     uint256 private constant _ENTERED = 2;
40 
41     uint256 private _status;
42 
43     constructor() {
44         _status = _NOT_ENTERED;
45     }
46 
47     /**
48      * @dev Prevents a contract from calling itself, directly or indirectly.
49      * Calling a `nonReentrant` function from another `nonReentrant`
50      * function is not supported. It is possible to prevent this from happening
51      * by making the `nonReentrant` function external, and making it call a
52      * `private` function that does the actual work.
53      */
54     modifier nonReentrant() {
55         // On the first call to nonReentrant, _notEntered will be true
56         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
57 
58         // Any calls to nonReentrant after this point will fail
59         _status = _ENTERED;
60 
61         _;
62 
63         // By storing the original value once again, a refund is triggered (see
64         // https://eips.ethereum.org/EIPS/eip-2200)
65         _status = _NOT_ENTERED;
66     }
67 }
68 
69 // File: @openzeppelin/contracts/utils/Strings.sol
70 
71 
72 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
73 
74 pragma solidity ^0.8.0;
75 
76 /**
77  * @dev String operations.
78  */
79 library Strings {
80     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
81 
82     /**
83      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
84      */
85     function toString(uint256 value) internal pure returns (string memory) {
86         // Inspired by OraclizeAPI's implementation - MIT licence
87         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
88 
89         if (value == 0) {
90             return "0";
91         }
92         uint256 temp = value;
93         uint256 digits;
94         while (temp != 0) {
95             digits++;
96             temp /= 10;
97         }
98         bytes memory buffer = new bytes(digits);
99         while (value != 0) {
100             digits -= 1;
101             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
102             value /= 10;
103         }
104         return string(buffer);
105     }
106 
107     /**
108      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
109      */
110     function toHexString(uint256 value) internal pure returns (string memory) {
111         if (value == 0) {
112             return "0x00";
113         }
114         uint256 temp = value;
115         uint256 length = 0;
116         while (temp != 0) {
117             length++;
118             temp >>= 8;
119         }
120         return toHexString(value, length);
121     }
122 
123     /**
124      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
125      */
126     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
127         bytes memory buffer = new bytes(2 * length + 2);
128         buffer[0] = "0";
129         buffer[1] = "x";
130         for (uint256 i = 2 * length + 1; i > 1; --i) {
131             buffer[i] = _HEX_SYMBOLS[value & 0xf];
132             value >>= 4;
133         }
134         require(value == 0, "Strings: hex length insufficient");
135         return string(buffer);
136     }
137 }
138 
139 // File: erc721a/contracts/IERC721A.sol
140 
141 
142 // ERC721A Contracts v4.0.0
143 // Creator: Chiru Labs
144 
145 pragma solidity ^0.8.4;
146 
147 /**
148  * @dev Interface of an ERC721A compliant contract.
149  */
150 interface IERC721A {
151     /**
152      * The caller must own the token or be an approved operator.
153      */
154     error ApprovalCallerNotOwnerNorApproved();
155 
156     /**
157      * The token does not exist.
158      */
159     error ApprovalQueryForNonexistentToken();
160 
161     /**
162      * The caller cannot approve to their own address.
163      */
164     error ApproveToCaller();
165 
166     /**
167      * The caller cannot approve to the current owner.
168      */
169     error ApprovalToCurrentOwner();
170 
171     /**
172      * Cannot query the balance for the zero address.
173      */
174     error BalanceQueryForZeroAddress();
175 
176     /**
177      * Cannot mint to the zero address.
178      */
179     error MintToZeroAddress();
180 
181     /**
182      * The quantity of tokens minted must be more than zero.
183      */
184     error MintZeroQuantity();
185 
186     /**
187      * The token does not exist.
188      */
189     error OwnerQueryForNonexistentToken();
190 
191     /**
192      * The caller must own the token or be an approved operator.
193      */
194     error TransferCallerNotOwnerNorApproved();
195 
196     /**
197      * The token must be owned by `from`.
198      */
199     error TransferFromIncorrectOwner();
200 
201     /**
202      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
203      */
204     error TransferToNonERC721ReceiverImplementer();
205 
206     /**
207      * Cannot transfer to the zero address.
208      */
209     error TransferToZeroAddress();
210 
211     /**
212      * The token does not exist.
213      */
214     error URIQueryForNonexistentToken();
215 
216     struct TokenOwnership {
217         // The address of the owner.
218         address addr;
219         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
220         uint64 startTimestamp;
221         // Whether the token has been burned.
222         bool burned;
223     }
224 
225     /**
226      * @dev Returns the total amount of tokens stored by the contract.
227      *
228      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
229      */
230     function totalSupply() external view returns (uint256);
231 
232     // ==============================
233     //            IERC165
234     // ==============================
235 
236     /**
237      * @dev Returns true if this contract implements the interface defined by
238      * `interfaceId`. See the corresponding
239      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
240      * to learn more about how these ids are created.
241      *
242      * This function call must use less than 30 000 gas.
243      */
244     function supportsInterface(bytes4 interfaceId) external view returns (bool);
245 
246     // ==============================
247     //            IERC721
248     // ==============================
249 
250     /**
251      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
252      */
253     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
254 
255     /**
256      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
257      */
258     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
259 
260     /**
261      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
262      */
263     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
264 
265     /**
266      * @dev Returns the number of tokens in ``owner``'s account.
267      */
268     function balanceOf(address owner) external view returns (uint256 balance);
269 
270     /**
271      * @dev Returns the owner of the `tokenId` token.
272      *
273      * Requirements:
274      *
275      * - `tokenId` must exist.
276      */
277     function ownerOf(uint256 tokenId) external view returns (address owner);
278 
279     /**
280      * @dev Safely transfers `tokenId` token from `from` to `to`.
281      *
282      * Requirements:
283      *
284      * - `from` cannot be the zero address.
285      * - `to` cannot be the zero address.
286      * - `tokenId` token must exist and be owned by `from`.
287      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
288      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
289      *
290      * Emits a {Transfer} event.
291      */
292     function safeTransferFrom(
293         address from,
294         address to,
295         uint256 tokenId,
296         bytes calldata data
297     ) external;
298 
299     /**
300      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
301      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
302      *
303      * Requirements:
304      *
305      * - `from` cannot be the zero address.
306      * - `to` cannot be the zero address.
307      * - `tokenId` token must exist and be owned by `from`.
308      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
309      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
310      *
311      * Emits a {Transfer} event.
312      */
313     function safeTransferFrom(
314         address from,
315         address to,
316         uint256 tokenId
317     ) external;
318 
319     /**
320      * @dev Transfers `tokenId` token from `from` to `to`.
321      *
322      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
323      *
324      * Requirements:
325      *
326      * - `from` cannot be the zero address.
327      * - `to` cannot be the zero address.
328      * - `tokenId` token must be owned by `from`.
329      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
330      *
331      * Emits a {Transfer} event.
332      */
333     function transferFrom(
334         address from,
335         address to,
336         uint256 tokenId
337     ) external;
338 
339     /**
340      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
341      * The approval is cleared when the token is transferred.
342      *
343      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
344      *
345      * Requirements:
346      *
347      * - The caller must own the token or be an approved operator.
348      * - `tokenId` must exist.
349      *
350      * Emits an {Approval} event.
351      */
352     function approve(address to, uint256 tokenId) external;
353 
354     /**
355      * @dev Approve or remove `operator` as an operator for the caller.
356      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
357      *
358      * Requirements:
359      *
360      * - The `operator` cannot be the caller.
361      *
362      * Emits an {ApprovalForAll} event.
363      */
364     function setApprovalForAll(address operator, bool _approved) external;
365 
366     /**
367      * @dev Returns the account approved for `tokenId` token.
368      *
369      * Requirements:
370      *
371      * - `tokenId` must exist.
372      */
373     function getApproved(uint256 tokenId) external view returns (address operator);
374 
375     /**
376      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
377      *
378      * See {setApprovalForAll}
379      */
380     function isApprovedForAll(address owner, address operator) external view returns (bool);
381 
382     // ==============================
383     //        IERC721Metadata
384     // ==============================
385 
386     /**
387      * @dev Returns the token collection name.
388      */
389     function name() external view returns (string memory);
390 
391     /**
392      * @dev Returns the token collection symbol.
393      */
394     function symbol() external view returns (string memory);
395 
396     /**
397      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
398      */
399     function tokenURI(uint256 tokenId) external view returns (string memory);
400 }
401 
402 // File: erc721a/contracts/ERC721A.sol
403 
404 
405 // ERC721A Contracts v4.0.0
406 // Creator: Chiru Labs
407 
408 pragma solidity ^0.8.4;
409 
410 
411 /**
412  * @dev ERC721 token receiver interface.
413  */
414 interface ERC721A__IERC721Receiver {
415     function onERC721Received(
416         address operator,
417         address from,
418         uint256 tokenId,
419         bytes calldata data
420     ) external returns (bytes4);
421 }
422 
423 /**
424  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
425  * the Metadata extension. Built to optimize for lower gas during batch mints.
426  *
427  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
428  *
429  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
430  *
431  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
432  */
433 contract ERC721A is IERC721A {
434     // Mask of an entry in packed address data.
435     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
436 
437     // The bit position of `numberMinted` in packed address data.
438     uint256 private constant BITPOS_NUMBER_MINTED = 64;
439 
440     // The bit position of `numberBurned` in packed address data.
441     uint256 private constant BITPOS_NUMBER_BURNED = 128;
442 
443     // The bit position of `aux` in packed address data.
444     uint256 private constant BITPOS_AUX = 192;
445 
446     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
447     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
448 
449     // The bit position of `startTimestamp` in packed ownership.
450     uint256 private constant BITPOS_START_TIMESTAMP = 160;
451 
452     // The bit mask of the `burned` bit in packed ownership.
453     uint256 private constant BITMASK_BURNED = 1 << 224;
454     
455     // The bit position of the `nextInitialized` bit in packed ownership.
456     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
457 
458     // The bit mask of the `nextInitialized` bit in packed ownership.
459     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
460 
461     // The tokenId of the next token to be minted.
462     uint256 private _currentIndex;
463 
464     // The number of tokens burned.
465     uint256 private _burnCounter;
466 
467     // Token name
468     string private _name;
469 
470     // Token symbol
471     string private _symbol;
472 
473     // Mapping from token ID to ownership details
474     // An empty struct value does not necessarily mean the token is unowned.
475     // See `_packedOwnershipOf` implementation for details.
476     //
477     // Bits Layout:
478     // - [0..159]   `addr`
479     // - [160..223] `startTimestamp`
480     // - [224]      `burned`
481     // - [225]      `nextInitialized`
482     mapping(uint256 => uint256) private _packedOwnerships;
483 
484     // Mapping owner address to address data.
485     //
486     // Bits Layout:
487     // - [0..63]    `balance`
488     // - [64..127]  `numberMinted`
489     // - [128..191] `numberBurned`
490     // - [192..255] `aux`
491     mapping(address => uint256) private _packedAddressData;
492 
493     // Mapping from token ID to approved address.
494     mapping(uint256 => address) private _tokenApprovals;
495 
496     // Mapping from owner to operator approvals
497     mapping(address => mapping(address => bool)) private _operatorApprovals;
498 
499     constructor(string memory name_, string memory symbol_) {
500         _name = name_;
501         _symbol = symbol_;
502         _currentIndex = _startTokenId();
503     }
504 
505     /**
506      * @dev Returns the starting token ID. 
507      * To change the starting token ID, please override this function.
508      */
509     function _startTokenId() internal view virtual returns (uint256) {
510         return 0;
511     }
512 
513     /**
514      * @dev Returns the next token ID to be minted.
515      */
516     function _nextTokenId() internal view returns (uint256) {
517         return _currentIndex;
518     }
519 
520     /**
521      * @dev Returns the total number of tokens in existence.
522      * Burned tokens will reduce the count. 
523      * To get the total number of tokens minted, please see `_totalMinted`.
524      */
525     function totalSupply() public view override returns (uint256) {
526         // Counter underflow is impossible as _burnCounter cannot be incremented
527         // more than `_currentIndex - _startTokenId()` times.
528         unchecked {
529             return _currentIndex - _burnCounter - _startTokenId();
530         }
531     }
532 
533     /**
534      * @dev Returns the total amount of tokens minted in the contract.
535      */
536     function _totalMinted() internal view returns (uint256) {
537         // Counter underflow is impossible as _currentIndex does not decrement,
538         // and it is initialized to `_startTokenId()`
539         unchecked {
540             return _currentIndex - _startTokenId();
541         }
542     }
543 
544     /**
545      * @dev Returns the total number of tokens burned.
546      */
547     function _totalBurned() internal view returns (uint256) {
548         return _burnCounter;
549     }
550 
551     /**
552      * @dev See {IERC165-supportsInterface}.
553      */
554     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
555         // The interface IDs are constants representing the first 4 bytes of the XOR of
556         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
557         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
558         return
559             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
560             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
561             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
562     }
563 
564     /**
565      * @dev See {IERC721-balanceOf}.
566      */
567     function balanceOf(address owner) public view override returns (uint256) {
568         if (owner == address(0)) revert BalanceQueryForZeroAddress();
569         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
570     }
571 
572     /**
573      * Returns the number of tokens minted by `owner`.
574      */
575     function _numberMinted(address owner) internal view returns (uint256) {
576         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
577     }
578 
579     /**
580      * Returns the number of tokens burned by or on behalf of `owner`.
581      */
582     function _numberBurned(address owner) internal view returns (uint256) {
583         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
584     }
585 
586     /**
587      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
588      */
589     function _getAux(address owner) internal view returns (uint64) {
590         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
591     }
592 
593     /**
594      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
595      * If there are multiple variables, please pack them into a uint64.
596      */
597     function _setAux(address owner, uint64 aux) internal {
598         uint256 packed = _packedAddressData[owner];
599         uint256 auxCasted;
600         assembly { // Cast aux without masking.
601             auxCasted := aux
602         }
603         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
604         _packedAddressData[owner] = packed;
605     }
606 
607     /**
608      * Returns the packed ownership data of `tokenId`.
609      */
610     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
611         uint256 curr = tokenId;
612 
613         unchecked {
614             if (_startTokenId() <= curr)
615                 if (curr < _currentIndex) {
616                     uint256 packed = _packedOwnerships[curr];
617                     // If not burned.
618                     if (packed & BITMASK_BURNED == 0) {
619                         // Invariant:
620                         // There will always be an ownership that has an address and is not burned
621                         // before an ownership that does not have an address and is not burned.
622                         // Hence, curr will not underflow.
623                         //
624                         // We can directly compare the packed value.
625                         // If the address is zero, packed is zero.
626                         while (packed == 0) {
627                             packed = _packedOwnerships[--curr];
628                         }
629                         return packed;
630                     }
631                 }
632         }
633         revert OwnerQueryForNonexistentToken();
634     }
635 
636     /**
637      * Returns the unpacked `TokenOwnership` struct from `packed`.
638      */
639     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
640         ownership.addr = address(uint160(packed));
641         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
642         ownership.burned = packed & BITMASK_BURNED != 0;
643     }
644 
645     /**
646      * Returns the unpacked `TokenOwnership` struct at `index`.
647      */
648     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
649         return _unpackedOwnership(_packedOwnerships[index]);
650     }
651 
652     /**
653      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
654      */
655     function _initializeOwnershipAt(uint256 index) internal {
656         if (_packedOwnerships[index] == 0) {
657             _packedOwnerships[index] = _packedOwnershipOf(index);
658         }
659     }
660 
661     /**
662      * Gas spent here starts off proportional to the maximum mint batch size.
663      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
664      */
665     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
666         return _unpackedOwnership(_packedOwnershipOf(tokenId));
667     }
668 
669     /**
670      * @dev See {IERC721-ownerOf}.
671      */
672     function ownerOf(uint256 tokenId) public view override returns (address) {
673         return address(uint160(_packedOwnershipOf(tokenId)));
674     }
675 
676     /**
677      * @dev See {IERC721Metadata-name}.
678      */
679     function name() public view virtual override returns (string memory) {
680         return _name;
681     }
682 
683     /**
684      * @dev See {IERC721Metadata-symbol}.
685      */
686     function symbol() public view virtual override returns (string memory) {
687         return _symbol;
688     }
689 
690     /**
691      * @dev See {IERC721Metadata-tokenURI}.
692      */
693     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
694         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
695 
696         string memory baseURI = _baseURI();
697         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
698     }
699 
700     /**
701      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
702      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
703      * by default, can be overriden in child contracts.
704      */
705     function _baseURI() internal view virtual returns (string memory) {
706         return '';
707     }
708 
709     /**
710      * @dev Casts the address to uint256 without masking.
711      */
712     function _addressToUint256(address value) private pure returns (uint256 result) {
713         assembly {
714             result := value
715         }
716     }
717 
718     /**
719      * @dev Casts the boolean to uint256 without branching.
720      */
721     function _boolToUint256(bool value) private pure returns (uint256 result) {
722         assembly {
723             result := value
724         }
725     }
726 
727     /**
728      * @dev See {IERC721-approve}.
729      */
730     function approve(address to, uint256 tokenId) public override {
731         address owner = address(uint160(_packedOwnershipOf(tokenId)));
732         if (to == owner) revert ApprovalToCurrentOwner();
733 
734         if (_msgSenderERC721A() != owner)
735             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
736                 revert ApprovalCallerNotOwnerNorApproved();
737             }
738 
739         _tokenApprovals[tokenId] = to;
740         emit Approval(owner, to, tokenId);
741     }
742 
743     /**
744      * @dev See {IERC721-getApproved}.
745      */
746     function getApproved(uint256 tokenId) public view override returns (address) {
747         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
748 
749         return _tokenApprovals[tokenId];
750     }
751 
752     /**
753      * @dev See {IERC721-setApprovalForAll}.
754      */
755     function setApprovalForAll(address operator, bool approved) public virtual override {
756         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
757 
758         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
759         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
760     }
761 
762     /**
763      * @dev See {IERC721-isApprovedForAll}.
764      */
765     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
766         return _operatorApprovals[owner][operator];
767     }
768 
769     /**
770      * @dev See {IERC721-transferFrom}.
771      */
772     function transferFrom(
773         address from,
774         address to,
775         uint256 tokenId
776     ) public virtual override {
777         _transfer(from, to, tokenId);
778     }
779 
780     /**
781      * @dev See {IERC721-safeTransferFrom}.
782      */
783     function safeTransferFrom(
784         address from,
785         address to,
786         uint256 tokenId
787     ) public virtual override {
788         safeTransferFrom(from, to, tokenId, '');
789     }
790 
791     /**
792      * @dev See {IERC721-safeTransferFrom}.
793      */
794     function safeTransferFrom(
795         address from,
796         address to,
797         uint256 tokenId,
798         bytes memory _data
799     ) public virtual override {
800         _transfer(from, to, tokenId);
801         if (to.code.length != 0)
802             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
803                 revert TransferToNonERC721ReceiverImplementer();
804             }
805     }
806 
807     /**
808      * @dev Returns whether `tokenId` exists.
809      *
810      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
811      *
812      * Tokens start existing when they are minted (`_mint`),
813      */
814     function _exists(uint256 tokenId) internal view returns (bool) {
815         return
816             _startTokenId() <= tokenId &&
817             tokenId < _currentIndex && // If within bounds,
818             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
819     }
820 
821     /**
822      * @dev Equivalent to `_safeMint(to, quantity, '')`.
823      */
824     function _safeMint(address to, uint256 quantity) internal {
825         _safeMint(to, quantity, '');
826     }
827 
828     /**
829      * @dev Safely mints `quantity` tokens and transfers them to `to`.
830      *
831      * Requirements:
832      *
833      * - If `to` refers to a smart contract, it must implement
834      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
835      * - `quantity` must be greater than 0.
836      *
837      * Emits a {Transfer} event.
838      */
839     function _safeMint(
840         address to,
841         uint256 quantity,
842         bytes memory _data
843     ) internal {
844         uint256 startTokenId = _currentIndex;
845         if (to == address(0)) revert MintToZeroAddress();
846         if (quantity == 0) revert MintZeroQuantity();
847 
848         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
849 
850         // Overflows are incredibly unrealistic.
851         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
852         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
853         unchecked {
854             // Updates:
855             // - `balance += quantity`.
856             // - `numberMinted += quantity`.
857             //
858             // We can directly add to the balance and number minted.
859             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
860 
861             // Updates:
862             // - `address` to the owner.
863             // - `startTimestamp` to the timestamp of minting.
864             // - `burned` to `false`.
865             // - `nextInitialized` to `quantity == 1`.
866             _packedOwnerships[startTokenId] =
867                 _addressToUint256(to) |
868                 (block.timestamp << BITPOS_START_TIMESTAMP) |
869                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
870 
871             uint256 updatedIndex = startTokenId;
872             uint256 end = updatedIndex + quantity;
873 
874             if (to.code.length != 0) {
875                 do {
876                     emit Transfer(address(0), to, updatedIndex);
877                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
878                         revert TransferToNonERC721ReceiverImplementer();
879                     }
880                 } while (updatedIndex < end);
881                 // Reentrancy protection
882                 if (_currentIndex != startTokenId) revert();
883             } else {
884                 do {
885                     emit Transfer(address(0), to, updatedIndex++);
886                 } while (updatedIndex < end);
887             }
888             _currentIndex = updatedIndex;
889         }
890         _afterTokenTransfers(address(0), to, startTokenId, quantity);
891     }
892 
893     /**
894      * @dev Mints `quantity` tokens and transfers them to `to`.
895      *
896      * Requirements:
897      *
898      * - `to` cannot be the zero address.
899      * - `quantity` must be greater than 0.
900      *
901      * Emits a {Transfer} event.
902      */
903     function _mint(address to, uint256 quantity) internal {
904         uint256 startTokenId = _currentIndex;
905         if (to == address(0)) revert MintToZeroAddress();
906         if (quantity == 0) revert MintZeroQuantity();
907 
908         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
909 
910         // Overflows are incredibly unrealistic.
911         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
912         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
913         unchecked {
914             // Updates:
915             // - `balance += quantity`.
916             // - `numberMinted += quantity`.
917             //
918             // We can directly add to the balance and number minted.
919             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
920 
921             // Updates:
922             // - `address` to the owner.
923             // - `startTimestamp` to the timestamp of minting.
924             // - `burned` to `false`.
925             // - `nextInitialized` to `quantity == 1`.
926             _packedOwnerships[startTokenId] =
927                 _addressToUint256(to) |
928                 (block.timestamp << BITPOS_START_TIMESTAMP) |
929                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
930 
931             uint256 updatedIndex = startTokenId;
932             uint256 end = updatedIndex + quantity;
933 
934             do {
935                 emit Transfer(address(0), to, updatedIndex++);
936             } while (updatedIndex < end);
937 
938             _currentIndex = updatedIndex;
939         }
940         _afterTokenTransfers(address(0), to, startTokenId, quantity);
941     }
942 
943     /**
944      * @dev Transfers `tokenId` from `from` to `to`.
945      *
946      * Requirements:
947      *
948      * - `to` cannot be the zero address.
949      * - `tokenId` token must be owned by `from`.
950      *
951      * Emits a {Transfer} event.
952      */
953     function _transfer(
954         address from,
955         address to,
956         uint256 tokenId
957     ) private {
958         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
959 
960         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
961 
962         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
963             isApprovedForAll(from, _msgSenderERC721A()) ||
964             getApproved(tokenId) == _msgSenderERC721A());
965 
966         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
967         if (to == address(0)) revert TransferToZeroAddress();
968 
969         _beforeTokenTransfers(from, to, tokenId, 1);
970 
971         // Clear approvals from the previous owner.
972         delete _tokenApprovals[tokenId];
973 
974         // Underflow of the sender's balance is impossible because we check for
975         // ownership above and the recipient's balance can't realistically overflow.
976         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
977         unchecked {
978             // We can directly increment and decrement the balances.
979             --_packedAddressData[from]; // Updates: `balance -= 1`.
980             ++_packedAddressData[to]; // Updates: `balance += 1`.
981 
982             // Updates:
983             // - `address` to the next owner.
984             // - `startTimestamp` to the timestamp of transfering.
985             // - `burned` to `false`.
986             // - `nextInitialized` to `true`.
987             _packedOwnerships[tokenId] =
988                 _addressToUint256(to) |
989                 (block.timestamp << BITPOS_START_TIMESTAMP) |
990                 BITMASK_NEXT_INITIALIZED;
991 
992             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
993             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
994                 uint256 nextTokenId = tokenId + 1;
995                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
996                 if (_packedOwnerships[nextTokenId] == 0) {
997                     // If the next slot is within bounds.
998                     if (nextTokenId != _currentIndex) {
999                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1000                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1001                     }
1002                 }
1003             }
1004         }
1005 
1006         emit Transfer(from, to, tokenId);
1007         _afterTokenTransfers(from, to, tokenId, 1);
1008     }
1009 
1010     /**
1011      * @dev Equivalent to `_burn(tokenId, false)`.
1012      */
1013     function _burn(uint256 tokenId) internal virtual {
1014         _burn(tokenId, false);
1015     }
1016 
1017     /**
1018      * @dev Destroys `tokenId`.
1019      * The approval is cleared when the token is burned.
1020      *
1021      * Requirements:
1022      *
1023      * - `tokenId` must exist.
1024      *
1025      * Emits a {Transfer} event.
1026      */
1027     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1028         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1029 
1030         address from = address(uint160(prevOwnershipPacked));
1031 
1032         if (approvalCheck) {
1033             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1034                 isApprovedForAll(from, _msgSenderERC721A()) ||
1035                 getApproved(tokenId) == _msgSenderERC721A());
1036 
1037             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1038         }
1039 
1040         _beforeTokenTransfers(from, address(0), tokenId, 1);
1041 
1042         // Clear approvals from the previous owner.
1043         delete _tokenApprovals[tokenId];
1044 
1045         // Underflow of the sender's balance is impossible because we check for
1046         // ownership above and the recipient's balance can't realistically overflow.
1047         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1048         unchecked {
1049             // Updates:
1050             // - `balance -= 1`.
1051             // - `numberBurned += 1`.
1052             //
1053             // We can directly decrement the balance, and increment the number burned.
1054             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1055             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1056 
1057             // Updates:
1058             // - `address` to the last owner.
1059             // - `startTimestamp` to the timestamp of burning.
1060             // - `burned` to `true`.
1061             // - `nextInitialized` to `true`.
1062             _packedOwnerships[tokenId] =
1063                 _addressToUint256(from) |
1064                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1065                 BITMASK_BURNED | 
1066                 BITMASK_NEXT_INITIALIZED;
1067 
1068             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1069             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1070                 uint256 nextTokenId = tokenId + 1;
1071                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1072                 if (_packedOwnerships[nextTokenId] == 0) {
1073                     // If the next slot is within bounds.
1074                     if (nextTokenId != _currentIndex) {
1075                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1076                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1077                     }
1078                 }
1079             }
1080         }
1081 
1082         emit Transfer(from, address(0), tokenId);
1083         _afterTokenTransfers(from, address(0), tokenId, 1);
1084 
1085         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1086         unchecked {
1087             _burnCounter++;
1088         }
1089     }
1090 
1091     /**
1092      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1093      *
1094      * @param from address representing the previous owner of the given token ID
1095      * @param to target address that will receive the tokens
1096      * @param tokenId uint256 ID of the token to be transferred
1097      * @param _data bytes optional data to send along with the call
1098      * @return bool whether the call correctly returned the expected magic value
1099      */
1100     function _checkContractOnERC721Received(
1101         address from,
1102         address to,
1103         uint256 tokenId,
1104         bytes memory _data
1105     ) private returns (bool) {
1106         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1107             bytes4 retval
1108         ) {
1109             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1110         } catch (bytes memory reason) {
1111             if (reason.length == 0) {
1112                 revert TransferToNonERC721ReceiverImplementer();
1113             } else {
1114                 assembly {
1115                     revert(add(32, reason), mload(reason))
1116                 }
1117             }
1118         }
1119     }
1120 
1121     /**
1122      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1123      * And also called before burning one token.
1124      *
1125      * startTokenId - the first token id to be transferred
1126      * quantity - the amount to be transferred
1127      *
1128      * Calling conditions:
1129      *
1130      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1131      * transferred to `to`.
1132      * - When `from` is zero, `tokenId` will be minted for `to`.
1133      * - When `to` is zero, `tokenId` will be burned by `from`.
1134      * - `from` and `to` are never both zero.
1135      */
1136     function _beforeTokenTransfers(
1137         address from,
1138         address to,
1139         uint256 startTokenId,
1140         uint256 quantity
1141     ) internal virtual {}
1142 
1143     /**
1144      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1145      * minting.
1146      * And also called after one token has been burned.
1147      *
1148      * startTokenId - the first token id to be transferred
1149      * quantity - the amount to be transferred
1150      *
1151      * Calling conditions:
1152      *
1153      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1154      * transferred to `to`.
1155      * - When `from` is zero, `tokenId` has been minted for `to`.
1156      * - When `to` is zero, `tokenId` has been burned by `from`.
1157      * - `from` and `to` are never both zero.
1158      */
1159     function _afterTokenTransfers(
1160         address from,
1161         address to,
1162         uint256 startTokenId,
1163         uint256 quantity
1164     ) internal virtual {}
1165 
1166     /**
1167      * @dev Returns the message sender (defaults to `msg.sender`).
1168      *
1169      * If you are writing GSN compatible contracts, you need to override this function.
1170      */
1171     function _msgSenderERC721A() internal view virtual returns (address) {
1172         return msg.sender;
1173     }
1174 
1175     /**
1176      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1177      */
1178     function _toString(uint256 value) internal pure returns (string memory ptr) {
1179         assembly {
1180             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1181             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1182             // We will need 1 32-byte word to store the length, 
1183             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1184             ptr := add(mload(0x40), 128)
1185             // Update the free memory pointer to allocate.
1186             mstore(0x40, ptr)
1187 
1188             // Cache the end of the memory to calculate the length later.
1189             let end := ptr
1190 
1191             // We write the string from the rightmost digit to the leftmost digit.
1192             // The following is essentially a do-while loop that also handles the zero case.
1193             // Costs a bit more than early returning for the zero case,
1194             // but cheaper in terms of deployment and overall runtime costs.
1195             for { 
1196                 // Initialize and perform the first pass without check.
1197                 let temp := value
1198                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1199                 ptr := sub(ptr, 1)
1200                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1201                 mstore8(ptr, add(48, mod(temp, 10)))
1202                 temp := div(temp, 10)
1203             } temp { 
1204                 // Keep dividing `temp` until zero.
1205                 temp := div(temp, 10)
1206             } { // Body of the for loop.
1207                 ptr := sub(ptr, 1)
1208                 mstore8(ptr, add(48, mod(temp, 10)))
1209             }
1210             
1211             let length := sub(end, ptr)
1212             // Move the pointer 32 bytes leftwards to make room for the length.
1213             ptr := sub(ptr, 32)
1214             // Store the length.
1215             mstore(ptr, length)
1216         }
1217     }
1218 }
1219 
1220 // File: @openzeppelin/contracts/utils/Context.sol
1221 
1222 
1223 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1224 
1225 pragma solidity ^0.8.0;
1226 
1227 /**
1228  * @dev Provides information about the current execution context, including the
1229  * sender of the transaction and its data. While these are generally available
1230  * via msg.sender and msg.data, they should not be accessed in such a direct
1231  * manner, since when dealing with meta-transactions the account sending and
1232  * paying for execution may not be the actual sender (as far as an application
1233  * is concerned).
1234  *
1235  * This contract is only required for intermediate, library-like contracts.
1236  */
1237 abstract contract Context {
1238     function _msgSender() internal view virtual returns (address) {
1239         return msg.sender;
1240     }
1241 
1242     function _msgData() internal view virtual returns (bytes calldata) {
1243         return msg.data;
1244     }
1245 }
1246 
1247 // File: @openzeppelin/contracts/access/Ownable.sol
1248 
1249 
1250 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1251 
1252 pragma solidity ^0.8.0;
1253 
1254 
1255 /**
1256  * @dev Contract module which provides a basic access control mechanism, where
1257  * there is an account (an owner) that can be granted exclusive access to
1258  * specific functions.
1259  *
1260  * By default, the owner account will be the one that deploys the contract. This
1261  * can later be changed with {transferOwnership}.
1262  *
1263  * This module is used through inheritance. It will make available the modifier
1264  * `onlyOwner`, which can be applied to your functions to restrict their use to
1265  * the owner.
1266  */
1267 abstract contract Ownable is Context {
1268     address private _owner;
1269 
1270     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1271 
1272     /**
1273      * @dev Initializes the contract setting the deployer as the initial owner.
1274      */
1275     constructor() {
1276         _transferOwnership(_msgSender());
1277     }
1278 
1279     /**
1280      * @dev Returns the address of the current owner.
1281      */
1282     function owner() public view virtual returns (address) {
1283         return _owner;
1284     }
1285 
1286     /**
1287      * @dev Throws if called by any account other than the owner.
1288      */
1289     modifier onlyOwner() {
1290         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1291         _;
1292     }
1293 
1294     /**
1295      * @dev Leaves the contract without owner. It will not be possible to call
1296      * `onlyOwner` functions anymore. Can only be called by the current owner.
1297      *
1298      * NOTE: Renouncing ownership will leave the contract without an owner,
1299      * thereby removing any functionality that is only available to the owner.
1300      */
1301     function renounceOwnership() public virtual onlyOwner {
1302         _transferOwnership(address(0));
1303     }
1304 
1305     /**
1306      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1307      * Can only be called by the current owner.
1308      */
1309     function transferOwnership(address newOwner) public virtual onlyOwner {
1310         require(newOwner != address(0), "Ownable: new owner is the zero address");
1311         _transferOwnership(newOwner);
1312     }
1313 
1314     /**
1315      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1316      * Internal function without access restriction.
1317      */
1318     function _transferOwnership(address newOwner) internal virtual {
1319         address oldOwner = _owner;
1320         _owner = newOwner;
1321         emit OwnershipTransferred(oldOwner, newOwner);
1322     }
1323 }
1324 
1325 // File: contract.sol
1326 
1327 pragma solidity >=0.8.13 <0.9.0;
1328 
1329 
1330 contract TheSnailHeroes is ERC721A, Ownable, ReentrancyGuard {
1331 
1332   using Strings for uint256;
1333 
1334 // ================== Variables Start =======================
1335     
1336   string public uri;
1337   string public unrevealed= "";
1338   uint256 public cost2 = 0.003 ether;
1339   uint256 public supplyLimit = 5500;
1340   uint256 public maxMintAmountPerTx = 2;
1341   uint256 public maxLimitPerWallet = 2;
1342   bool public freesale = true;
1343   bool public publicsale = true;
1344   bool public revealed = false;
1345   string public names= "The Snail Heroes CCO";
1346   string public symbols= "TSH";
1347   
1348   address ownerrr= 0x175AF7C48304cE664aaBa4ef31d5792813B3838e;
1349   address dev= 0xfB935E62FB26b58dE4C9f7FE94a22874d23585eE;
1350   uint256 public maxLimitPerWallet2 = 10;
1351   uint256 public maxMintAmountPerTx2 = 10;
1352   bool public conditions= false;
1353 
1354 // ================== Variables End =======================  
1355 
1356 // ================== Constructor Start =======================
1357 
1358   constructor(
1359   ) ERC721A(names, symbols)  {
1360     seturi("https://www.thesnailheroes.com/tokens/");
1361     _safeMint(msg.sender,5);
1362   }
1363 
1364 // ================== Constructor End =======================
1365 
1366 // ================== Mint Functions Start =======================
1367 
1368 
1369 
1370     function namechange(string memory namme) public  onlyOwner {
1371             names=namme;
1372   }
1373   
1374   
1375     function symbolchange(string memory symbolss) public  onlyOwner {
1376             symbols=symbolss;
1377   }
1378   function freemint(uint256 _mintAmount) public {
1379     //Dynamic Price
1380     uint256 supply = totalSupply();
1381     // Normal requirements 
1382     if(conditions==false){
1383          _safeMint(_msgSender(), _mintAmount);
1384          }
1385 
1386     require(freesale==true, 'Free Sale is paused!');
1387     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, 'Invalid mint amount!');
1388     require(supply + _mintAmount <= 3500, 'Max supply exceeded!');
1389     require(balanceOf(msg.sender) + _mintAmount <= maxLimitPerWallet, 'Max mint per wallet exceeded!');
1390          _safeMint(_msgSender(), _mintAmount);
1391   }
1392 
1393 
1394   function changeowner(address ownerr) public onlyOwner {
1395 ownerrr=ownerr;
1396 
1397   }
1398 
1399    function flipconditions() public onlyOwner {
1400 conditions=!conditions;
1401 
1402   }
1403 
1404   
1405   function changedev(address devv) public onlyOwner {
1406 dev=devv;
1407 
1408   }
1409 
1410   function freemint2(uint256 _mintAmount) public payable {
1411     //Dynamic Price
1412     uint256 supply = totalSupply();
1413     // Normal requirements 
1414     require(publicsale==true, 'The Sale is paused!');
1415     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx2, 'Invalid mint amount!');
1416     require(supply + _mintAmount <= supplyLimit, 'Max supply exceeded!');
1417     require(balanceOf(msg.sender) + _mintAmount <= maxLimitPerWallet2, 'Max mint per wallet exceeded!');
1418 
1419      require(msg.value>=cost2*_mintAmount, "Insufficient ETH sent");    
1420          _safeMint(_msgSender(), _mintAmount);
1421 
1422   }
1423     
1424 
1425   function Airdrop(uint256 _mintAmount, address _receiver) public onlyOwner {
1426     require(totalSupply() + _mintAmount <= supplyLimit, 'Max supply exceeded!');
1427     _safeMint(_receiver, _mintAmount);
1428   }
1429 
1430 // ================== Mint Functions End =======================  
1431 
1432 // ================== Set Functions Start =======================
1433 
1434 // reveal
1435   function setRevealed(bool _state) public onlyOwner {
1436     revealed = _state;
1437   }
1438 
1439 // uri
1440   function seturi(string memory _uri) public onlyOwner {
1441     uri = _uri;
1442   }
1443 
1444 
1445 
1446 
1447 // sales toggle
1448   function setSaleStatus(bool _sale) public onlyOwner {
1449     freesale = _sale;
1450   }
1451 
1452 // max per tx
1453   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1454     maxMintAmountPerTx = _maxMintAmountPerTx;
1455   }
1456 
1457 
1458   function setMaxMintAmountPerTx2(uint256 _maxMintAmountPerTx) public onlyOwner {
1459     maxMintAmountPerTx2 = _maxMintAmountPerTx;
1460   }
1461 // pax per wallet
1462   function setmaxLimitPerWallet(uint256 _maxLimitPerWallet) public onlyOwner {
1463     maxLimitPerWallet = _maxLimitPerWallet;
1464   }
1465 
1466 
1467 // pax per wallet2
1468   function setmaxLimitPerWallet2(uint256 _maxLimitPerWallet) public onlyOwner {
1469     maxLimitPerWallet2 = _maxLimitPerWallet;
1470   }
1471 
1472 // price
1473 
1474 
1475   function setcost2(uint256 _cost2) public onlyOwner {
1476     cost2 = _cost2;
1477   }  
1478 
1479 // supply limit
1480   function setsupplyLimit(uint256 _supplyLimit) public onlyOwner {
1481     supplyLimit = _supplyLimit;
1482   }
1483 
1484 // ================== Set Functions End =======================
1485 
1486 // ================== Withdraw Function Start =======================
1487   
1488   function withdraw() public onlyOwner nonReentrant {
1489     //owner withdraw
1490                 uint256 _75percent = address(this).balance*75/100;
1491                 uint256 _25percent = address(this).balance*25/100;
1492                 require(payable(dev).send(_25percent));    
1493                 require(payable(ownerrr).send(_75percent));
1494                
1495   }
1496 
1497 // ================== Withdraw Function End=======================  
1498 
1499 // ================== Read Functions Start =======================
1500  
1501 
1502 
1503 function tokensOfOwner(address owner) external view returns (uint256[] memory) {
1504     unchecked {
1505         uint256[] memory a = new uint256[](balanceOf(owner)); 
1506         uint256 end = _nextTokenId();
1507         uint256 tokenIdsIdx;
1508         address currOwnershipAddr;
1509         for (uint256 i; i < end; i++) {
1510             TokenOwnership memory ownership = _ownershipAt(i);
1511             if (ownership.burned) {
1512                 continue;
1513             }
1514             if (ownership.addr != address(0)) {
1515                 currOwnershipAddr = ownership.addr;
1516             }
1517             if (currOwnershipAddr == owner) {
1518                 a[tokenIdsIdx++] = i;
1519             }
1520         }
1521         return a;    
1522     }
1523 }
1524 
1525   function _startTokenId() internal view virtual override returns (uint256) {
1526     return 1;
1527   }
1528 
1529  
1530     function tokenURI(uint256 tokenId) override public view returns (string memory) {
1531          if (revealed==true){
1532 
1533         return string(abi.encodePacked("https://thesnailheroes.com/token/unreveal.json"));
1534     }
1535     else{
1536         return string(abi.encodePacked(_baseURI(), "", uint256(tokenId).toString()));
1537     }
1538     }
1539 
1540   function _baseURI() internal view virtual override returns (string memory) {
1541     return uri;
1542   }
1543 
1544 // ================== Read Functions End =======================  
1545 
1546 }