1 /*
2   __    __                            __
3  |  \  |  \                          |  \
4  | ▓▓  | ▓▓ ______   ______   ______  \▓▓ ______   _______
5  | ▓▓__| ▓▓|      \ /      \ /      \|  \/      \ /       \
6  | ▓▓    ▓▓ \▓▓▓▓▓▓\  ▓▓▓▓▓▓\  ▓▓▓▓▓▓\ ▓▓  ▓▓▓▓▓▓\  ▓▓▓▓▓▓▓
7  | ▓▓▓▓▓▓▓▓/      ▓▓ ▓▓  | ▓▓ ▓▓  | ▓▓ ▓▓ ▓▓    ▓▓\▓▓    \
8  | ▓▓  | ▓▓  ▓▓▓▓▓▓▓ ▓▓__/ ▓▓ ▓▓__/ ▓▓ ▓▓ ▓▓▓▓▓▓▓▓_\▓▓▓▓▓▓\
9  | ▓▓  | ▓▓\▓▓    ▓▓ ▓▓    ▓▓ ▓▓    ▓▓ ▓▓\▓▓     \       ▓▓
10   \▓▓   \▓▓ \▓▓▓▓▓▓▓ ▓▓▓▓▓▓▓| ▓▓▓▓▓▓▓ \▓▓ \▓▓▓▓▓▓▓\▓▓▓▓▓▓▓
11                    | ▓▓     | ▓▓
12                    | ▓▓     | ▓▓
13                     \▓▓      \▓▓
14 by
15  ╔╗  ╔╗         ╔╗  ╔╗    ╔═══╗ ╔╗       ╔╗              ╔════╗╔═╗╔═╗
16  ║╚╗╔╝║         ║║  ║║    ║╔═╗║╔╝╚╗      ║║              ║╔╗╔╗║║║╚╝║║
17  ╚╗╚╝╔╝╔══╗╔══╗ ║╚═╗║║    ║╚══╗╚╗╔╝╔╗╔╗╔═╝║╔╗╔══╗╔══╗    ╚╝║║╚╝║╔╗╔╗║
18   ╚╗╔╝ ║╔╗║╚ ╗║ ║╔╗║╚╝    ╚══╗║ ║║ ║║║║║╔╗║╠╣║╔╗║║══╣      ║║  ║║║║║║
19    ║║  ║║═╣║╚╝╚╗║║║║╔╗    ║╚═╝║ ║╚╗║╚╝║║╚╝║║║║╚╝║╠══║     ╔╝╚╗ ║║║║║║
20    ╚╝  ╚══╝╚═══╝╚╝╚╝╚╝    ╚═══╝ ╚═╝╚══╝╚══╝╚╝╚══╝╚══╝     ╚══╝ ╚╝╚╝╚╝
21 contract by
22  ██╗      █████╗ ██████╗ ██╗  ██╗██╗███╗   ██╗
23  ██║     ██╔══██╗██╔══██╗██║ ██╔╝██║████╗  ██║
24  ██║     ███████║██████╔╝█████╔╝ ██║██╔██╗ ██║
25  ██║     ██╔══██║██╔══██╗██╔═██╗ ██║██║╚██╗██║
26  ███████╗██║  ██║██║  ██║██║  ██╗██║██║ ╚████║
27  ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝
28 */
29 
30 // SPDX-License-Identifier: MIT
31 pragma solidity ^0.8.14;
32 
33 // Sources flattened with hardhat v2.9.6 https://hardhat.org
34 
35 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.6.0
36 
37 
38 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
39 
40 
41 
42 /**
43  * @dev Interface of the ERC165 standard, as defined in the
44  * https://eips.ethereum.org/EIPS/eip-165[EIP].
45  *
46  * Implementers can declare support of contract interfaces, which can then be
47  * queried by others ({ERC165Checker}).
48  *
49  * For an implementation, see {ERC165}.
50  */
51 interface IERC165 {
52     /**
53      * @dev Returns true if this contract implements the interface defined by
54      * `interfaceId`. See the corresponding
55      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
56      * to learn more about how these ids are created.
57      *
58      * This function call must use less than 30 000 gas.
59      */
60     function supportsInterface(bytes4 interfaceId) external view returns (bool);
61 }
62 
63 
64 // File @openzeppelin/contracts/interfaces/IERC2981.sol@v4.6.0
65 
66 
67 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
68 
69 
70 
71 /**
72  * @dev Interface for the NFT Royalty Standard.
73  *
74  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
75  * support for royalty payments across all NFT marketplaces and ecosystem participants.
76  *
77  * _Available since v4.5._
78  */
79 interface IERC2981 is IERC165 {
80     /**
81      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
82      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
83      */
84     function royaltyInfo(uint256 tokenId, uint256 salePrice)
85         external
86         view
87         returns (address receiver, uint256 royaltyAmount);
88 }
89 
90 
91 // File erc721a/contracts/IERC721A.sol@v4.0.0
92 
93 
94 // ERC721A Contracts v4.0.0
95 // Creator: Chiru Labs
96 
97 
98 
99 /**
100  * @dev Interface of an ERC721A compliant contract.
101  */
102 interface IERC721A {
103     /**
104      * The caller must own the token or be an approved operator.
105      */
106     error ApprovalCallerNotOwnerNorApproved();
107 
108     /**
109      * The token does not exist.
110      */
111     error ApprovalQueryForNonexistentToken();
112 
113     /**
114      * The caller cannot approve to their own address.
115      */
116     error ApproveToCaller();
117 
118     /**
119      * The caller cannot approve to the current owner.
120      */
121     error ApprovalToCurrentOwner();
122 
123     /**
124      * Cannot query the balance for the zero address.
125      */
126     error BalanceQueryForZeroAddress();
127 
128     /**
129      * Cannot mint to the zero address.
130      */
131     error MintToZeroAddress();
132 
133     /**
134      * The quantity of tokens minted must be more than zero.
135      */
136     error MintZeroQuantity();
137 
138     /**
139      * The token does not exist.
140      */
141     error OwnerQueryForNonexistentToken();
142 
143     /**
144      * The caller must own the token or be an approved operator.
145      */
146     error TransferCallerNotOwnerNorApproved();
147 
148     /**
149      * The token must be owned by `from`.
150      */
151     error TransferFromIncorrectOwner();
152 
153     /**
154      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
155      */
156     error TransferToNonERC721ReceiverImplementer();
157 
158     /**
159      * Cannot transfer to the zero address.
160      */
161     error TransferToZeroAddress();
162 
163     /**
164      * The token does not exist.
165      */
166     error URIQueryForNonexistentToken();
167 
168     struct TokenOwnership {
169         // The address of the owner.
170         address addr;
171         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
172         uint64 startTimestamp;
173         // Whether the token has been burned.
174         bool burned;
175     }
176 
177     /**
178      * @dev Returns the total amount of tokens stored by the contract.
179      *
180      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
181      */
182     function totalSupply() external view returns (uint256);
183 
184     // ==============================
185     //            IERC165
186     // ==============================
187 
188     /**
189      * @dev Returns true if this contract implements the interface defined by
190      * `interfaceId`. See the corresponding
191      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
192      * to learn more about how these ids are created.
193      *
194      * This function call must use less than 30 000 gas.
195      */
196     function supportsInterface(bytes4 interfaceId) external view returns (bool);
197 
198     // ==============================
199     //            IERC721
200     // ==============================
201 
202     /**
203      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
204      */
205     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
206 
207     /**
208      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
209      */
210     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
211 
212     /**
213      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
214      */
215     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
216 
217     /**
218      * @dev Returns the number of tokens in ``owner``'s account.
219      */
220     function balanceOf(address owner) external view returns (uint256 balance);
221 
222     /**
223      * @dev Returns the owner of the `tokenId` token.
224      *
225      * Requirements:
226      *
227      * - `tokenId` must exist.
228      */
229     function ownerOf(uint256 tokenId) external view returns (address owner);
230 
231     /**
232      * @dev Safely transfers `tokenId` token from `from` to `to`.
233      *
234      * Requirements:
235      *
236      * - `from` cannot be the zero address.
237      * - `to` cannot be the zero address.
238      * - `tokenId` token must exist and be owned by `from`.
239      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
240      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
241      *
242      * Emits a {Transfer} event.
243      */
244     function safeTransferFrom(
245         address from,
246         address to,
247         uint256 tokenId,
248         bytes calldata data
249     ) external;
250 
251     /**
252      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
253      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
254      *
255      * Requirements:
256      *
257      * - `from` cannot be the zero address.
258      * - `to` cannot be the zero address.
259      * - `tokenId` token must exist and be owned by `from`.
260      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
261      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
262      *
263      * Emits a {Transfer} event.
264      */
265     function safeTransferFrom(
266         address from,
267         address to,
268         uint256 tokenId
269     ) external;
270 
271     /**
272      * @dev Transfers `tokenId` token from `from` to `to`.
273      *
274      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
275      *
276      * Requirements:
277      *
278      * - `from` cannot be the zero address.
279      * - `to` cannot be the zero address.
280      * - `tokenId` token must be owned by `from`.
281      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
282      *
283      * Emits a {Transfer} event.
284      */
285     function transferFrom(
286         address from,
287         address to,
288         uint256 tokenId
289     ) external;
290 
291     /**
292      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
293      * The approval is cleared when the token is transferred.
294      *
295      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
296      *
297      * Requirements:
298      *
299      * - The caller must own the token or be an approved operator.
300      * - `tokenId` must exist.
301      *
302      * Emits an {Approval} event.
303      */
304     function approve(address to, uint256 tokenId) external;
305 
306     /**
307      * @dev Approve or remove `operator` as an operator for the caller.
308      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
309      *
310      * Requirements:
311      *
312      * - The `operator` cannot be the caller.
313      *
314      * Emits an {ApprovalForAll} event.
315      */
316     function setApprovalForAll(address operator, bool _approved) external;
317 
318     /**
319      * @dev Returns the account approved for `tokenId` token.
320      *
321      * Requirements:
322      *
323      * - `tokenId` must exist.
324      */
325     function getApproved(uint256 tokenId) external view returns (address operator);
326 
327     /**
328      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
329      *
330      * See {setApprovalForAll}
331      */
332     function isApprovedForAll(address owner, address operator) external view returns (bool);
333 
334     // ==============================
335     //        IERC721Metadata
336     // ==============================
337 
338     /**
339      * @dev Returns the token collection name.
340      */
341     function name() external view returns (string memory);
342 
343     /**
344      * @dev Returns the token collection symbol.
345      */
346     function symbol() external view returns (string memory);
347 
348     /**
349      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
350      */
351     function tokenURI(uint256 tokenId) external view returns (string memory);
352 }
353 
354 
355 // File erc721a/contracts/ERC721A.sol@v4.0.0
356 
357 
358 // ERC721A Contracts v4.0.0
359 // Creator: Chiru Labs
360 
361 
362 
363 /**
364  * @dev ERC721 token receiver interface.
365  */
366 interface ERC721A__IERC721Receiver {
367     function onERC721Received(
368         address operator,
369         address from,
370         uint256 tokenId,
371         bytes calldata data
372     ) external returns (bytes4);
373 }
374 
375 /**
376  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
377  * the Metadata extension. Built to optimize for lower gas during batch mints.
378  *
379  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
380  *
381  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
382  *
383  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
384  */
385 contract ERC721A is IERC721A {
386     // Mask of an entry in packed address data.
387     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
388 
389     // The bit position of `numberMinted` in packed address data.
390     uint256 private constant BITPOS_NUMBER_MINTED = 64;
391 
392     // The bit position of `numberBurned` in packed address data.
393     uint256 private constant BITPOS_NUMBER_BURNED = 128;
394 
395     // The bit position of `aux` in packed address data.
396     uint256 private constant BITPOS_AUX = 192;
397 
398     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
399     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
400 
401     // The bit position of `startTimestamp` in packed ownership.
402     uint256 private constant BITPOS_START_TIMESTAMP = 160;
403 
404     // The bit mask of the `burned` bit in packed ownership.
405     uint256 private constant BITMASK_BURNED = 1 << 224;
406 
407     // The bit position of the `nextInitialized` bit in packed ownership.
408     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
409 
410     // The bit mask of the `nextInitialized` bit in packed ownership.
411     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
412 
413     // The tokenId of the next token to be minted.
414     uint256 private _currentIndex;
415 
416     // The number of tokens burned.
417     uint256 private _burnCounter;
418 
419     // Token name
420     string private _name;
421 
422     // Token symbol
423     string private _symbol;
424 
425     // Mapping from token ID to ownership details
426     // An empty struct value does not necessarily mean the token is unowned.
427     // See `_packedOwnershipOf` implementation for details.
428     //
429     // Bits Layout:
430     // - [0..159]   `addr`
431     // - [160..223] `startTimestamp`
432     // - [224]      `burned`
433     // - [225]      `nextInitialized`
434     mapping(uint256 => uint256) private _packedOwnerships;
435 
436     // Mapping owner address to address data.
437     //
438     // Bits Layout:
439     // - [0..63]    `balance`
440     // - [64..127]  `numberMinted`
441     // - [128..191] `numberBurned`
442     // - [192..255] `aux`
443     mapping(address => uint256) private _packedAddressData;
444 
445     // Mapping from token ID to approved address.
446     mapping(uint256 => address) private _tokenApprovals;
447 
448     // Mapping from owner to operator approvals
449     mapping(address => mapping(address => bool)) private _operatorApprovals;
450 
451     constructor(string memory name_, string memory symbol_) {
452         _name = name_;
453         _symbol = symbol_;
454         _currentIndex = _startTokenId();
455     }
456 
457     /**
458      * @dev Returns the starting token ID.
459      * To change the starting token ID, please override this function.
460      */
461     function _startTokenId() internal view virtual returns (uint256) {
462         return 0;
463     }
464 
465     /**
466      * @dev Returns the next token ID to be minted.
467      */
468     function _nextTokenId() internal view returns (uint256) {
469         return _currentIndex;
470     }
471 
472     /**
473      * @dev Returns the total number of tokens in existence.
474      * Burned tokens will reduce the count.
475      * To get the total number of tokens minted, please see `_totalMinted`.
476      */
477     function totalSupply() public view override returns (uint256) {
478         // Counter underflow is impossible as _burnCounter cannot be incremented
479         // more than `_currentIndex - _startTokenId()` times.
480         unchecked {
481             return _currentIndex - _burnCounter - _startTokenId();
482         }
483     }
484 
485     /**
486      * @dev Returns the total amount of tokens minted in the contract.
487      */
488     function _totalMinted() internal view returns (uint256) {
489         // Counter underflow is impossible as _currentIndex does not decrement,
490         // and it is initialized to `_startTokenId()`
491         unchecked {
492             return _currentIndex - _startTokenId();
493         }
494     }
495 
496     /**
497      * @dev Returns the total number of tokens burned.
498      */
499     function _totalBurned() internal view returns (uint256) {
500         return _burnCounter;
501     }
502 
503     /**
504      * @dev See {IERC165-supportsInterface}.
505      */
506     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
507         // The interface IDs are constants representing the first 4 bytes of the XOR of
508         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
509         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
510         return
511             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
512             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
513             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
514     }
515 
516     /**
517      * @dev See {IERC721-balanceOf}.
518      */
519     function balanceOf(address owner) public view override returns (uint256) {
520         if (owner == address(0)) revert BalanceQueryForZeroAddress();
521         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
522     }
523 
524     /**
525      * Returns the number of tokens minted by `owner`.
526      */
527     function _numberMinted(address owner) internal view returns (uint256) {
528         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
529     }
530 
531     /**
532      * Returns the number of tokens burned by or on behalf of `owner`.
533      */
534     function _numberBurned(address owner) internal view returns (uint256) {
535         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
536     }
537 
538     /**
539      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
540      */
541     function _getAux(address owner) internal view returns (uint64) {
542         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
543     }
544 
545     /**
546      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
547      * If there are multiple variables, please pack them into a uint64.
548      */
549     function _setAux(address owner, uint64 aux) internal {
550         uint256 packed = _packedAddressData[owner];
551         uint256 auxCasted;
552         assembly { // Cast aux without masking.
553             auxCasted := aux
554         }
555         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
556         _packedAddressData[owner] = packed;
557     }
558 
559     /**
560      * Returns the packed ownership data of `tokenId`.
561      */
562     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
563         uint256 curr = tokenId;
564 
565         unchecked {
566             if (_startTokenId() <= curr)
567                 if (curr < _currentIndex) {
568                     uint256 packed = _packedOwnerships[curr];
569                     // If not burned.
570                     if (packed & BITMASK_BURNED == 0) {
571                         // Invariant:
572                         // There will always be an ownership that has an address and is not burned
573                         // before an ownership that does not have an address and is not burned.
574                         // Hence, curr will not underflow.
575                         //
576                         // We can directly compare the packed value.
577                         // If the address is zero, packed is zero.
578                         while (packed == 0) {
579                             packed = _packedOwnerships[--curr];
580                         }
581                         return packed;
582                     }
583                 }
584         }
585         revert OwnerQueryForNonexistentToken();
586     }
587 
588     /**
589      * Returns the unpacked `TokenOwnership` struct from `packed`.
590      */
591     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
592         ownership.addr = address(uint160(packed));
593         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
594         ownership.burned = packed & BITMASK_BURNED != 0;
595     }
596 
597     /**
598      * Returns the unpacked `TokenOwnership` struct at `index`.
599      */
600     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
601         return _unpackedOwnership(_packedOwnerships[index]);
602     }
603 
604     /**
605      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
606      */
607     function _initializeOwnershipAt(uint256 index) internal {
608         if (_packedOwnerships[index] == 0) {
609             _packedOwnerships[index] = _packedOwnershipOf(index);
610         }
611     }
612 
613     /**
614      * Gas spent here starts off proportional to the maximum mint batch size.
615      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
616      */
617     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
618         return _unpackedOwnership(_packedOwnershipOf(tokenId));
619     }
620 
621     /**
622      * @dev See {IERC721-ownerOf}.
623      */
624     function ownerOf(uint256 tokenId) public view override returns (address) {
625         return address(uint160(_packedOwnershipOf(tokenId)));
626     }
627 
628     /**
629      * @dev See {IERC721Metadata-name}.
630      */
631     function name() public view virtual override returns (string memory) {
632         return _name;
633     }
634 
635     /**
636      * @dev See {IERC721Metadata-symbol}.
637      */
638     function symbol() public view virtual override returns (string memory) {
639         return _symbol;
640     }
641 
642     /**
643      * @dev See {IERC721Metadata-tokenURI}.
644      */
645     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
646         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
647 
648         string memory baseURI = _baseURI();
649         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
650     }
651 
652     /**
653      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
654      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
655      * by default, can be overriden in child contracts.
656      */
657     function _baseURI() internal view virtual returns (string memory) {
658         return '';
659     }
660 
661     /**
662      * @dev Casts the address to uint256 without masking.
663      */
664     function _addressToUint256(address value) private pure returns (uint256 result) {
665         assembly {
666             result := value
667         }
668     }
669 
670     /**
671      * @dev Casts the boolean to uint256 without branching.
672      */
673     function _boolToUint256(bool value) private pure returns (uint256 result) {
674         assembly {
675             result := value
676         }
677     }
678 
679     /**
680      * @dev See {IERC721-approve}.
681      */
682     function approve(address to, uint256 tokenId) public override {
683         address owner = address(uint160(_packedOwnershipOf(tokenId)));
684         if (to == owner) revert ApprovalToCurrentOwner();
685 
686         if (_msgSenderERC721A() != owner)
687             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
688                 revert ApprovalCallerNotOwnerNorApproved();
689             }
690 
691         _tokenApprovals[tokenId] = to;
692         emit Approval(owner, to, tokenId);
693     }
694 
695     /**
696      * @dev See {IERC721-getApproved}.
697      */
698     function getApproved(uint256 tokenId) public view override returns (address) {
699         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
700 
701         return _tokenApprovals[tokenId];
702     }
703 
704     /**
705      * @dev See {IERC721-setApprovalForAll}.
706      */
707     function setApprovalForAll(address operator, bool approved) public virtual override {
708         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
709 
710         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
711         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
712     }
713 
714     /**
715      * @dev See {IERC721-isApprovedForAll}.
716      */
717     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
718         return _operatorApprovals[owner][operator];
719     }
720 
721     /**
722      * @dev See {IERC721-transferFrom}.
723      */
724     function transferFrom(
725         address from,
726         address to,
727         uint256 tokenId
728     ) public virtual override {
729         _transfer(from, to, tokenId);
730     }
731 
732     /**
733      * @dev See {IERC721-safeTransferFrom}.
734      */
735     function safeTransferFrom(
736         address from,
737         address to,
738         uint256 tokenId
739     ) public virtual override {
740         safeTransferFrom(from, to, tokenId, '');
741     }
742 
743     /**
744      * @dev See {IERC721-safeTransferFrom}.
745      */
746     function safeTransferFrom(
747         address from,
748         address to,
749         uint256 tokenId,
750         bytes memory _data
751     ) public virtual override {
752         _transfer(from, to, tokenId);
753         if (to.code.length != 0)
754             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
755                 revert TransferToNonERC721ReceiverImplementer();
756             }
757     }
758 
759     /**
760      * @dev Returns whether `tokenId` exists.
761      *
762      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
763      *
764      * Tokens start existing when they are minted (`_mint`),
765      */
766     function _exists(uint256 tokenId) internal view returns (bool) {
767         return
768             _startTokenId() <= tokenId &&
769             tokenId < _currentIndex && // If within bounds,
770             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
771     }
772 
773     /**
774      * @dev Equivalent to `_safeMint(to, quantity, '')`.
775      */
776     function _safeMint(address to, uint256 quantity) internal {
777         _safeMint(to, quantity, '');
778     }
779 
780     /**
781      * @dev Safely mints `quantity` tokens and transfers them to `to`.
782      *
783      * Requirements:
784      *
785      * - If `to` refers to a smart contract, it must implement
786      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
787      * - `quantity` must be greater than 0.
788      *
789      * Emits a {Transfer} event.
790      */
791     function _safeMint(
792         address to,
793         uint256 quantity,
794         bytes memory _data
795     ) internal {
796         uint256 startTokenId = _currentIndex;
797         if (to == address(0)) revert MintToZeroAddress();
798         if (quantity == 0) revert MintZeroQuantity();
799 
800         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
801 
802         // Overflows are incredibly unrealistic.
803         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
804         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
805         unchecked {
806             // Updates:
807             // - `balance += quantity`.
808             // - `numberMinted += quantity`.
809             //
810             // We can directly add to the balance and number minted.
811             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
812 
813             // Updates:
814             // - `address` to the owner.
815             // - `startTimestamp` to the timestamp of minting.
816             // - `burned` to `false`.
817             // - `nextInitialized` to `quantity == 1`.
818             _packedOwnerships[startTokenId] =
819                 _addressToUint256(to) |
820                 (block.timestamp << BITPOS_START_TIMESTAMP) |
821                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
822 
823             uint256 updatedIndex = startTokenId;
824             uint256 end = updatedIndex + quantity;
825 
826             if (to.code.length != 0) {
827                 do {
828                     emit Transfer(address(0), to, updatedIndex);
829                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
830                         revert TransferToNonERC721ReceiverImplementer();
831                     }
832                 } while (updatedIndex < end);
833                 // Reentrancy protection
834                 if (_currentIndex != startTokenId) revert();
835             } else {
836                 do {
837                     emit Transfer(address(0), to, updatedIndex++);
838                 } while (updatedIndex < end);
839             }
840             _currentIndex = updatedIndex;
841         }
842         _afterTokenTransfers(address(0), to, startTokenId, quantity);
843     }
844 
845     /**
846      * @dev Mints `quantity` tokens and transfers them to `to`.
847      *
848      * Requirements:
849      *
850      * - `to` cannot be the zero address.
851      * - `quantity` must be greater than 0.
852      *
853      * Emits a {Transfer} event.
854      */
855     function _mint(address to, uint256 quantity) internal {
856         uint256 startTokenId = _currentIndex;
857         if (to == address(0)) revert MintToZeroAddress();
858         if (quantity == 0) revert MintZeroQuantity();
859 
860         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
861 
862         // Overflows are incredibly unrealistic.
863         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
864         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
865         unchecked {
866             // Updates:
867             // - `balance += quantity`.
868             // - `numberMinted += quantity`.
869             //
870             // We can directly add to the balance and number minted.
871             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
872 
873             // Updates:
874             // - `address` to the owner.
875             // - `startTimestamp` to the timestamp of minting.
876             // - `burned` to `false`.
877             // - `nextInitialized` to `quantity == 1`.
878             _packedOwnerships[startTokenId] =
879                 _addressToUint256(to) |
880                 (block.timestamp << BITPOS_START_TIMESTAMP) |
881                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
882 
883             uint256 updatedIndex = startTokenId;
884             uint256 end = updatedIndex + quantity;
885 
886             do {
887                 emit Transfer(address(0), to, updatedIndex++);
888             } while (updatedIndex < end);
889 
890             _currentIndex = updatedIndex;
891         }
892         _afterTokenTransfers(address(0), to, startTokenId, quantity);
893     }
894 
895     /**
896      * @dev Transfers `tokenId` from `from` to `to`.
897      *
898      * Requirements:
899      *
900      * - `to` cannot be the zero address.
901      * - `tokenId` token must be owned by `from`.
902      *
903      * Emits a {Transfer} event.
904      */
905     function _transfer(
906         address from,
907         address to,
908         uint256 tokenId
909     ) private {
910         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
911 
912         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
913 
914         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
915             isApprovedForAll(from, _msgSenderERC721A()) ||
916             getApproved(tokenId) == _msgSenderERC721A());
917 
918         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
919         if (to == address(0)) revert TransferToZeroAddress();
920 
921         _beforeTokenTransfers(from, to, tokenId, 1);
922 
923         // Clear approvals from the previous owner.
924         delete _tokenApprovals[tokenId];
925 
926         // Underflow of the sender's balance is impossible because we check for
927         // ownership above and the recipient's balance can't realistically overflow.
928         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
929         unchecked {
930             // We can directly increment and decrement the balances.
931             --_packedAddressData[from]; // Updates: `balance -= 1`.
932             ++_packedAddressData[to]; // Updates: `balance += 1`.
933 
934             // Updates:
935             // - `address` to the next owner.
936             // - `startTimestamp` to the timestamp of transfering.
937             // - `burned` to `false`.
938             // - `nextInitialized` to `true`.
939             _packedOwnerships[tokenId] =
940                 _addressToUint256(to) |
941                 (block.timestamp << BITPOS_START_TIMESTAMP) |
942                 BITMASK_NEXT_INITIALIZED;
943 
944             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
945             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
946                 uint256 nextTokenId = tokenId + 1;
947                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
948                 if (_packedOwnerships[nextTokenId] == 0) {
949                     // If the next slot is within bounds.
950                     if (nextTokenId != _currentIndex) {
951                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
952                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
953                     }
954                 }
955             }
956         }
957 
958         emit Transfer(from, to, tokenId);
959         _afterTokenTransfers(from, to, tokenId, 1);
960     }
961 
962     /**
963      * @dev Equivalent to `_burn(tokenId, false)`.
964      */
965     function _burn(uint256 tokenId) internal virtual {
966         _burn(tokenId, false);
967     }
968 
969     /**
970      * @dev Destroys `tokenId`.
971      * The approval is cleared when the token is burned.
972      *
973      * Requirements:
974      *
975      * - `tokenId` must exist.
976      *
977      * Emits a {Transfer} event.
978      */
979     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
980         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
981 
982         address from = address(uint160(prevOwnershipPacked));
983 
984         if (approvalCheck) {
985             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
986                 isApprovedForAll(from, _msgSenderERC721A()) ||
987                 getApproved(tokenId) == _msgSenderERC721A());
988 
989             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
990         }
991 
992         _beforeTokenTransfers(from, address(0), tokenId, 1);
993 
994         // Clear approvals from the previous owner.
995         delete _tokenApprovals[tokenId];
996 
997         // Underflow of the sender's balance is impossible because we check for
998         // ownership above and the recipient's balance can't realistically overflow.
999         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1000         unchecked {
1001             // Updates:
1002             // - `balance -= 1`.
1003             // - `numberBurned += 1`.
1004             //
1005             // We can directly decrement the balance, and increment the number burned.
1006             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1007             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1008 
1009             // Updates:
1010             // - `address` to the last owner.
1011             // - `startTimestamp` to the timestamp of burning.
1012             // - `burned` to `true`.
1013             // - `nextInitialized` to `true`.
1014             _packedOwnerships[tokenId] =
1015                 _addressToUint256(from) |
1016                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1017                 BITMASK_BURNED |
1018                 BITMASK_NEXT_INITIALIZED;
1019 
1020             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1021             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1022                 uint256 nextTokenId = tokenId + 1;
1023                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1024                 if (_packedOwnerships[nextTokenId] == 0) {
1025                     // If the next slot is within bounds.
1026                     if (nextTokenId != _currentIndex) {
1027                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1028                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1029                     }
1030                 }
1031             }
1032         }
1033 
1034         emit Transfer(from, address(0), tokenId);
1035         _afterTokenTransfers(from, address(0), tokenId, 1);
1036 
1037         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1038         unchecked {
1039             _burnCounter++;
1040         }
1041     }
1042 
1043     /**
1044      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1045      *
1046      * @param from address representing the previous owner of the given token ID
1047      * @param to target address that will receive the tokens
1048      * @param tokenId uint256 ID of the token to be transferred
1049      * @param _data bytes optional data to send along with the call
1050      * @return bool whether the call correctly returned the expected magic value
1051      */
1052     function _checkContractOnERC721Received(
1053         address from,
1054         address to,
1055         uint256 tokenId,
1056         bytes memory _data
1057     ) private returns (bool) {
1058         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1059             bytes4 retval
1060         ) {
1061             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1062         } catch (bytes memory reason) {
1063             if (reason.length == 0) {
1064                 revert TransferToNonERC721ReceiverImplementer();
1065             } else {
1066                 assembly {
1067                     revert(add(32, reason), mload(reason))
1068                 }
1069             }
1070         }
1071     }
1072 
1073     /**
1074      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1075      * And also called before burning one token.
1076      *
1077      * startTokenId - the first token id to be transferred
1078      * quantity - the amount to be transferred
1079      *
1080      * Calling conditions:
1081      *
1082      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1083      * transferred to `to`.
1084      * - When `from` is zero, `tokenId` will be minted for `to`.
1085      * - When `to` is zero, `tokenId` will be burned by `from`.
1086      * - `from` and `to` are never both zero.
1087      */
1088     function _beforeTokenTransfers(
1089         address from,
1090         address to,
1091         uint256 startTokenId,
1092         uint256 quantity
1093     ) internal virtual {}
1094 
1095     /**
1096      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1097      * minting.
1098      * And also called after one token has been burned.
1099      *
1100      * startTokenId - the first token id to be transferred
1101      * quantity - the amount to be transferred
1102      *
1103      * Calling conditions:
1104      *
1105      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1106      * transferred to `to`.
1107      * - When `from` is zero, `tokenId` has been minted for `to`.
1108      * - When `to` is zero, `tokenId` has been burned by `from`.
1109      * - `from` and `to` are never both zero.
1110      */
1111     function _afterTokenTransfers(
1112         address from,
1113         address to,
1114         uint256 startTokenId,
1115         uint256 quantity
1116     ) internal virtual {}
1117 
1118     /**
1119      * @dev Returns the message sender (defaults to `msg.sender`).
1120      *
1121      * If you are writing GSN compatible contracts, you need to override this function.
1122      */
1123     function _msgSenderERC721A() internal view virtual returns (address) {
1124         return msg.sender;
1125     }
1126 
1127     /**
1128      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1129      */
1130     function _toString(uint256 value) internal pure returns (string memory ptr) {
1131         assembly {
1132             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1133             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1134             // We will need 1 32-byte word to store the length,
1135             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1136             ptr := add(mload(0x40), 128)
1137             // Update the free memory pointer to allocate.
1138             mstore(0x40, ptr)
1139 
1140             // Cache the end of the memory to calculate the length later.
1141             let end := ptr
1142 
1143             // We write the string from the rightmost digit to the leftmost digit.
1144             // The following is essentially a do-while loop that also handles the zero case.
1145             // Costs a bit more than early returning for the zero case,
1146             // but cheaper in terms of deployment and overall runtime costs.
1147             for {
1148                 // Initialize and perform the first pass without check.
1149                 let temp := value
1150                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1151                 ptr := sub(ptr, 1)
1152                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1153                 mstore8(ptr, add(48, mod(temp, 10)))
1154                 temp := div(temp, 10)
1155             } temp {
1156                 // Keep dividing `temp` until zero.
1157                 temp := div(temp, 10)
1158             } { // Body of the for loop.
1159                 ptr := sub(ptr, 1)
1160                 mstore8(ptr, add(48, mod(temp, 10)))
1161             }
1162 
1163             let length := sub(end, ptr)
1164             // Move the pointer 32 bytes leftwards to make room for the length.
1165             ptr := sub(ptr, 32)
1166             // Store the length.
1167             mstore(ptr, length)
1168         }
1169     }
1170 }
1171 
1172 
1173 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.6.0
1174 
1175 
1176 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
1177 
1178 
1179 
1180 /**
1181  * @dev Interface of the ERC20 standard as defined in the EIP.
1182  */
1183 interface IERC20 {
1184     /**
1185      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1186      * another (`to`).
1187      *
1188      * Note that `value` may be zero.
1189      */
1190     event Transfer(address indexed from, address indexed to, uint256 value);
1191 
1192     /**
1193      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1194      * a call to {approve}. `value` is the new allowance.
1195      */
1196     event Approval(address indexed owner, address indexed spender, uint256 value);
1197 
1198     /**
1199      * @dev Returns the amount of tokens in existence.
1200      */
1201     function totalSupply() external view returns (uint256);
1202 
1203     /**
1204      * @dev Returns the amount of tokens owned by `account`.
1205      */
1206     function balanceOf(address account) external view returns (uint256);
1207 
1208     /**
1209      * @dev Moves `amount` tokens from the caller's account to `to`.
1210      *
1211      * Returns a boolean value indicating whether the operation succeeded.
1212      *
1213      * Emits a {Transfer} event.
1214      */
1215     function transfer(address to, uint256 amount) external returns (bool);
1216 
1217     /**
1218      * @dev Returns the remaining number of tokens that `spender` will be
1219      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1220      * zero by default.
1221      *
1222      * This value changes when {approve} or {transferFrom} are called.
1223      */
1224     function allowance(address owner, address spender) external view returns (uint256);
1225 
1226     /**
1227      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1228      *
1229      * Returns a boolean value indicating whether the operation succeeded.
1230      *
1231      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1232      * that someone may use both the old and the new allowance by unfortunate
1233      * transaction ordering. One possible solution to mitigate this race
1234      * condition is to first reduce the spender's allowance to 0 and set the
1235      * desired value afterwards:
1236      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1237      *
1238      * Emits an {Approval} event.
1239      */
1240     function approve(address spender, uint256 amount) external returns (bool);
1241 
1242     /**
1243      * @dev Moves `amount` tokens from `from` to `to` using the
1244      * allowance mechanism. `amount` is then deducted from the caller's
1245      * allowance.
1246      *
1247      * Returns a boolean value indicating whether the operation succeeded.
1248      *
1249      * Emits a {Transfer} event.
1250      */
1251     function transferFrom(
1252         address from,
1253         address to,
1254         uint256 amount
1255     ) external returns (bool);
1256 }
1257 
1258 
1259 // File @openzeppelin/contracts/utils/Context.sol@v4.6.0
1260 
1261 
1262 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1263 
1264 
1265 
1266 /**
1267  * @dev Provides information about the current execution context, including the
1268  * sender of the transaction and its data. While these are generally available
1269  * via msg.sender and msg.data, they should not be accessed in such a direct
1270  * manner, since when dealing with meta-transactions the account sending and
1271  * paying for execution may not be the actual sender (as far as an application
1272  * is concerned).
1273  *
1274  * This contract is only required for intermediate, library-like contracts.
1275  */
1276 abstract contract Context {
1277     function _msgSender() internal view virtual returns (address) {
1278         return msg.sender;
1279     }
1280 
1281     function _msgData() internal view virtual returns (bytes calldata) {
1282         return msg.data;
1283     }
1284 }
1285 
1286 
1287 // File @openzeppelin/contracts/access/Ownable.sol@v4.6.0
1288 
1289 
1290 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1291 
1292 
1293 
1294 /**
1295  * @dev Contract module which provides a basic access control mechanism, where
1296  * there is an account (an owner) that can be granted exclusive access to
1297  * specific functions.
1298  *
1299  * By default, the owner account will be the one that deploys the contract. This
1300  * can later be changed with {transferOwnership}.
1301  *
1302  * This module is used through inheritance. It will make available the modifier
1303  * `onlyOwner`, which can be applied to your functions to restrict their use to
1304  * the owner.
1305  */
1306 abstract contract Ownable is Context {
1307     address private _owner;
1308 
1309     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1310 
1311     /**
1312      * @dev Initializes the contract setting the deployer as the initial owner.
1313      */
1314     constructor() {
1315         _transferOwnership(_msgSender());
1316     }
1317 
1318     /**
1319      * @dev Returns the address of the current owner.
1320      */
1321     function owner() public view virtual returns (address) {
1322         return _owner;
1323     }
1324 
1325     /**
1326      * @dev Throws if called by any account other than the owner.
1327      */
1328     modifier onlyOwner() {
1329         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1330         _;
1331     }
1332 
1333     /**
1334      * @dev Leaves the contract without owner. It will not be possible to call
1335      * `onlyOwner` functions anymore. Can only be called by the current owner.
1336      *
1337      * NOTE: Renouncing ownership will leave the contract without an owner,
1338      * thereby removing any functionality that is only available to the owner.
1339      */
1340     function renounceOwnership() public virtual onlyOwner {
1341         _transferOwnership(address(0));
1342     }
1343 
1344     /**
1345      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1346      * Can only be called by the current owner.
1347      */
1348     function transferOwnership(address newOwner) public virtual onlyOwner {
1349         require(newOwner != address(0), "Ownable: new owner is the zero address");
1350         _transferOwnership(newOwner);
1351     }
1352 
1353     /**
1354      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1355      * Internal function without access restriction.
1356      */
1357     function _transferOwnership(address newOwner) internal virtual {
1358         address oldOwner = _owner;
1359         _owner = newOwner;
1360         emit OwnershipTransferred(oldOwner, newOwner);
1361     }
1362 }
1363 
1364 
1365 // File @openzeppelin/contracts/utils/Address.sol@v4.6.0
1366 
1367 
1368 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
1369 
1370 
1371 
1372 /**
1373  * @dev Collection of functions related to the address type
1374  */
1375 library Address {
1376     /**
1377      * @dev Returns true if `account` is a contract.
1378      *
1379      * [IMPORTANT]
1380      * ====
1381      * It is unsafe to assume that an address for which this function returns
1382      * false is an externally-owned account (EOA) and not a contract.
1383      *
1384      * Among others, `isContract` will return false for the following
1385      * types of addresses:
1386      *
1387      *  - an externally-owned account
1388      *  - a contract in construction
1389      *  - an address where a contract will be created
1390      *  - an address where a contract lived, but was destroyed
1391      * ====
1392      *
1393      * [IMPORTANT]
1394      * ====
1395      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1396      *
1397      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1398      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1399      * constructor.
1400      * ====
1401      */
1402     function isContract(address account) internal view returns (bool) {
1403         // This method relies on extcodesize/address.code.length, which returns 0
1404         // for contracts in construction, since the code is only stored at the end
1405         // of the constructor execution.
1406 
1407         return account.code.length > 0;
1408     }
1409 
1410     /**
1411      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1412      * `recipient`, forwarding all available gas and reverting on errors.
1413      *
1414      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1415      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1416      * imposed by `transfer`, making them unable to receive funds via
1417      * `transfer`. {sendValue} removes this limitation.
1418      *
1419      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1420      *
1421      * IMPORTANT: because control is transferred to `recipient`, care must be
1422      * taken to not create reentrancy vulnerabilities. Consider using
1423      * {ReentrancyGuard} or the
1424      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1425      */
1426     function sendValue(address payable recipient, uint256 amount) internal {
1427         require(address(this).balance >= amount, "Address: insufficient balance");
1428 
1429         (bool success, ) = recipient.call{value: amount}("");
1430         require(success, "Address: unable to send value, recipient may have reverted");
1431     }
1432 
1433     /**
1434      * @dev Performs a Solidity function call using a low level `call`. A
1435      * plain `call` is an unsafe replacement for a function call: use this
1436      * function instead.
1437      *
1438      * If `target` reverts with a revert reason, it is bubbled up by this
1439      * function (like regular Solidity function calls).
1440      *
1441      * Returns the raw returned data. To convert to the expected return value,
1442      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1443      *
1444      * Requirements:
1445      *
1446      * - `target` must be a contract.
1447      * - calling `target` with `data` must not revert.
1448      *
1449      * _Available since v3.1._
1450      */
1451     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1452         return functionCall(target, data, "Address: low-level call failed");
1453     }
1454 
1455     /**
1456      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1457      * `errorMessage` as a fallback revert reason when `target` reverts.
1458      *
1459      * _Available since v3.1._
1460      */
1461     function functionCall(
1462         address target,
1463         bytes memory data,
1464         string memory errorMessage
1465     ) internal returns (bytes memory) {
1466         return functionCallWithValue(target, data, 0, errorMessage);
1467     }
1468 
1469     /**
1470      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1471      * but also transferring `value` wei to `target`.
1472      *
1473      * Requirements:
1474      *
1475      * - the calling contract must have an ETH balance of at least `value`.
1476      * - the called Solidity function must be `payable`.
1477      *
1478      * _Available since v3.1._
1479      */
1480     function functionCallWithValue(
1481         address target,
1482         bytes memory data,
1483         uint256 value
1484     ) internal returns (bytes memory) {
1485         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1486     }
1487 
1488     /**
1489      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1490      * with `errorMessage` as a fallback revert reason when `target` reverts.
1491      *
1492      * _Available since v3.1._
1493      */
1494     function functionCallWithValue(
1495         address target,
1496         bytes memory data,
1497         uint256 value,
1498         string memory errorMessage
1499     ) internal returns (bytes memory) {
1500         require(address(this).balance >= value, "Address: insufficient balance for call");
1501         require(isContract(target), "Address: call to non-contract");
1502 
1503         (bool success, bytes memory returndata) = target.call{value: value}(data);
1504         return verifyCallResult(success, returndata, errorMessage);
1505     }
1506 
1507     /**
1508      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1509      * but performing a static call.
1510      *
1511      * _Available since v3.3._
1512      */
1513     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1514         return functionStaticCall(target, data, "Address: low-level static call failed");
1515     }
1516 
1517     /**
1518      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1519      * but performing a static call.
1520      *
1521      * _Available since v3.3._
1522      */
1523     function functionStaticCall(
1524         address target,
1525         bytes memory data,
1526         string memory errorMessage
1527     ) internal view returns (bytes memory) {
1528         require(isContract(target), "Address: static call to non-contract");
1529 
1530         (bool success, bytes memory returndata) = target.staticcall(data);
1531         return verifyCallResult(success, returndata, errorMessage);
1532     }
1533 
1534     /**
1535      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1536      * but performing a delegate call.
1537      *
1538      * _Available since v3.4._
1539      */
1540     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1541         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1542     }
1543 
1544     /**
1545      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1546      * but performing a delegate call.
1547      *
1548      * _Available since v3.4._
1549      */
1550     function functionDelegateCall(
1551         address target,
1552         bytes memory data,
1553         string memory errorMessage
1554     ) internal returns (bytes memory) {
1555         require(isContract(target), "Address: delegate call to non-contract");
1556 
1557         (bool success, bytes memory returndata) = target.delegatecall(data);
1558         return verifyCallResult(success, returndata, errorMessage);
1559     }
1560 
1561     /**
1562      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1563      * revert reason using the provided one.
1564      *
1565      * _Available since v4.3._
1566      */
1567     function verifyCallResult(
1568         bool success,
1569         bytes memory returndata,
1570         string memory errorMessage
1571     ) internal pure returns (bytes memory) {
1572         if (success) {
1573             return returndata;
1574         } else {
1575             // Look for revert reason and bubble it up if present
1576             if (returndata.length > 0) {
1577                 // The easiest way to bubble the revert reason is using memory via assembly
1578 
1579                 assembly {
1580                     let returndata_size := mload(returndata)
1581                     revert(add(32, returndata), returndata_size)
1582                 }
1583             } else {
1584                 revert(errorMessage);
1585             }
1586         }
1587     }
1588 }
1589 
1590 
1591 // File @openzeppelin/contracts/utils/Strings.sol@v4.6.0
1592 
1593 
1594 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
1595 
1596 
1597 
1598 /**
1599  * @dev String operations.
1600  */
1601 library Strings {
1602     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1603 
1604     /**
1605      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1606      */
1607     function toString(uint256 value) internal pure returns (string memory) {
1608         // Inspired by OraclizeAPI's implementation - MIT licence
1609         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1610 
1611         if (value == 0) {
1612             return "0";
1613         }
1614         uint256 temp = value;
1615         uint256 digits;
1616         while (temp != 0) {
1617             digits++;
1618             temp /= 10;
1619         }
1620         bytes memory buffer = new bytes(digits);
1621         while (value != 0) {
1622             digits -= 1;
1623             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1624             value /= 10;
1625         }
1626         return string(buffer);
1627     }
1628 
1629     /**
1630      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1631      */
1632     function toHexString(uint256 value) internal pure returns (string memory) {
1633         if (value == 0) {
1634             return "0x00";
1635         }
1636         uint256 temp = value;
1637         uint256 length = 0;
1638         while (temp != 0) {
1639             length++;
1640             temp >>= 8;
1641         }
1642         return toHexString(value, length);
1643     }
1644 
1645     /**
1646      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1647      */
1648     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1649         bytes memory buffer = new bytes(2 * length + 2);
1650         buffer[0] = "0";
1651         buffer[1] = "x";
1652         for (uint256 i = 2 * length + 1; i > 1; --i) {
1653             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1654             value >>= 4;
1655         }
1656         require(value == 0, "Strings: hex length insufficient");
1657         return string(buffer);
1658     }
1659 }
1660 
1661 
1662 // File contracts/Happies.sol
1663 
1664 /*
1665  ▄▄   ▄▄ ▄▄▄▄▄▄ ▄▄▄▄▄▄▄ ▄▄▄▄▄▄▄ ▄▄▄ ▄▄▄▄▄▄▄ ▄▄▄▄▄▄▄
1666 █  █ █  █      █       █       █   █       █       █
1667 █  █▄█  █  ▄   █    ▄  █    ▄  █   █    ▄▄▄█  ▄▄▄▄▄█
1668 █       █ █▄█  █   █▄█ █   █▄█ █   █   █▄▄▄█ █▄▄▄▄▄
1669 █   ▄   █      █    ▄▄▄█    ▄▄▄█   █    ▄▄▄█▄▄▄▄▄  █
1670 █  █ █  █  ▄   █   █   █   █   █   █   █▄▄▄ ▄▄▄▄▄█ █
1671 █▄▄█ █▄▄█▄█ █▄▄█▄▄▄█   █▄▄▄█   █▄▄▄█▄▄▄▄▄▄▄█▄▄▄▄▄▄▄█
1672 
1673 contract by
1674  ██╗      █████╗ ██████╗ ██╗  ██╗██╗███╗   ██╗
1675  ██║     ██╔══██╗██╔══██╗██║ ██╔╝██║████╗  ██║
1676  ██║     ███████║██████╔╝█████╔╝ ██║██╔██╗ ██║
1677  ██║     ██╔══██║██╔══██╗██╔═██╗ ██║██║╚██╗██║
1678  ███████╗██║  ██║██║  ██║██║  ██╗██║██║ ╚████║
1679  ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝
1680 */
1681 
1682 
1683 contract Happies is ERC721A, IERC2981, Ownable {
1684     using Strings for uint256;
1685 
1686     ///////////////////////////////////////////////////////////////////////////
1687     // Public constants
1688     ///////////////////////////////////////////////////////////////////////////
1689     uint256 constant public MAX_SUPPLY = 5000;
1690     uint256 constant public MAX_PER_WALLET = 10;
1691 
1692     ///////////////////////////////////////////////////////////////////////////
1693     // Important Globals
1694     ///////////////////////////////////////////////////////////////////////////
1695     uint256 public publicSaleTime = 1653746400;  // Sat May 28 2022 10:00:00 EST
1696 
1697     // how many has each address minted
1698     mapping (address => uint256) userMinted;
1699 
1700     string public provenance;
1701     string private baseURI = "ipfs://QmYuhQ8vCQPfjjpHd5KSQB79y4AdHkkjDGTK3nk8MnyY7G/";
1702     string private transformedBaseURI = "ipfs://QmYuhQ8vCQPfjjpHd5KSQB79y4AdHkkjDGTK3nk8MnyY7G/";
1703 
1704     ///////////////////////////////////////////////////////////////////////////
1705     // Team members and shares
1706     ///////////////////////////////////////////////////////////////////////////
1707     mapping(address => bool) private isTeam;
1708 
1709     address constant public LARKIN = 0x46E50dc219BA5A26890Dc99cDe4f4AC2a48011e9;
1710 
1711     // Team Addresses
1712     address[] private team = [
1713         0x05ed59e9765Ce11ACb387B66f91A99E1514ee7c8, // Pixel
1714         LARKIN                                    , // Larkin
1715         0x1BAcD207F29Ef028C5B761A686FFE6f6a385EF5F, // makerlee
1716         0xE62798584a153D5F9f2E5fA8993ad3Bfa42DF1BF, // makewayx
1717         0x3567Da988334B8AE8a8996E1dDaa82b656A7F6e9, // mustachi0
1718         0x12FF12Ab21B2C6E432158c5816F9CC1b6b2E2894  // Korey
1719     ];
1720 
1721     // Team wallet addresses
1722     //                            Pixel Larkin makerlee makewayx mustachi0 Korey
1723     uint256[] private teamShares = [30,     20,     15,      15,     10,     10];
1724 
1725     uint256 constant private TOTAL_SHARES = 100;
1726 
1727 
1728     // For EIP-2981 (royalties)
1729     bytes4 private constant INTERFACE_ID_ERC2981 = 0x2a55205a;
1730     uint256 constant private ROYALTIES_PERCENTAGE_X10 = 69;
1731 
1732     mapping (address => uint256[]) public burnedBy;  // tokens burned by a user
1733 
1734     uint256 public maxTransforms = 42;
1735     uint256 public transformPrice = 1 ether;
1736     uint256 public numTransformed;  // so far
1737     mapping (uint256 => bool) public transformed;  // is each token transformed?
1738     // optional boost to larkin's share of 'transform' payments
1739     uint256 private devTransformBoost = 10;  // this is a percentage, so 10 means 10%
1740 
1741 
1742     ///////////////////////////////////////////////////////////////////////////
1743     // Contract initialization
1744     ///////////////////////////////////////////////////////////////////////////
1745     constructor() ERC721A("Happies", "HAPPIES") {
1746         // Validate that the team size matches number of share buckets for mint and royalties
1747         uint256 teamSize = team.length;
1748         if (teamSize != teamShares.length) revert InvalidTeam(teamShares.length);
1749 
1750         // Validate that the number of teamShares match the expected for mint and royalties
1751         uint256 totalTeamShares;
1752         for (uint256 i; i < teamSize; ) {
1753             isTeam[team[i]] = true;
1754             unchecked {
1755                 totalTeamShares += teamShares[i];
1756                 ++i;
1757             }
1758         }
1759         if (totalTeamShares != TOTAL_SHARES) revert InvalidTeam(totalTeamShares);
1760 
1761         // mint first token ID to creator
1762         _safeMint(msg.sender, 1);
1763     }
1764 
1765 
1766     ///////////////////////////////////////////////////////////////////////////
1767     // Modifiers
1768     ///////////////////////////////////////////////////////////////////////////
1769     modifier onlyDev() {
1770         if (msg.sender != LARKIN) revert OnlyAllowedAddressCanDoThat(LARKIN);
1771         _;
1772     }
1773     modifier onlyTeam() {
1774         if (!isTeam[msg.sender]) revert OnlyTeamCanDoThat();
1775         _;
1776     }
1777 
1778 
1779     ///////////////////////////////////////////////////////////////////////////
1780     // Contract setup
1781     ///////////////////////////////////////////////////////////////////////////
1782     // The developer can change a team member (in case of emergency - wallet lost etc)
1783     function setTeamMember(uint256 index, address member) external onlyDev {
1784         require(member != address(0), "Cannot set team member to 0");
1785         require(index < team.length, "Invalid team member index");
1786 
1787         isTeam[team[index]] = false;  // remove team member
1788         team[index] = member; // relace team member
1789         isTeam[member] = true;
1790     }
1791 
1792     // Provenance hash proves that the team didn't play favorites with assigning tokenIds
1793     // for rare NFTs to specific addresses with a post-mint reveal
1794     function setProvenanceHash(string memory _provenanceHash) external onlyDev {
1795         provenance = _provenanceHash;
1796     }
1797 
1798     // Base IPFS URI that points to all metadata for the collection
1799     // It basically points to the IPFS folder containing all metadata.
1800     // So, if it points to ipfs://blah/, then tokenId 69 will have
1801     // metadata URI ipfs://blah/69
1802     //
1803     // The 'image' tag in the metadat for a tokenId points to its image's IPFS URI
1804     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1805         if (tokenId >= _totalMinted()) revert TokenDNE(tokenId);
1806 
1807         string memory mBaseURI = transformed[tokenId] ? transformedBaseURI : baseURI;
1808         return bytes(mBaseURI).length > 0 ? string(abi.encodePacked(mBaseURI, tokenId.toString())) : "";
1809     }
1810 
1811 
1812     // Update the base URI (like to reveal)
1813     function setBaseURI(string memory _uri) external onlyDev {
1814         baseURI = _uri;
1815     }
1816     function setTransformedBaseURI(string memory _uri) external onlyDev {
1817         transformedBaseURI = _uri;
1818     }
1819 
1820     function setPublicSaleTime(uint256 _newTime) public onlyDev {
1821         publicSaleTime = _newTime;
1822     }
1823     function setMaxTransforms(uint256 _max) public onlyDev {
1824         maxTransforms = _max;
1825     }
1826     function setTransformPrice(uint256 _price) public onlyDev {
1827         transformPrice = _price;
1828     }
1829     function setDevTransformBoost(uint256 _boostPercent) public onlyDev {
1830         devTransformBoost = _boostPercent;
1831     }
1832 
1833     ///////////////////////////////////////////////////////////////////////////
1834     // Mint and Burn
1835     ///////////////////////////////////////////////////////////////////////////
1836     function mint(uint256 _amount) external {
1837         if (block.timestamp < publicSaleTime) revert MintClosed();
1838         if (_totalMinted() + _amount > MAX_SUPPLY) revert WouldPassSupplyCap(_totalMinted() + _amount);
1839         if (_numberMinted(msg.sender) + _amount > MAX_PER_WALLET) revert WalletCanOnlyMintNMore(MAX_PER_WALLET - _numberMinted(msg.sender));
1840 
1841         _safeMint(msg.sender, _amount);
1842     }
1843 
1844     function burn(uint256 _tokenId) external {
1845         if (ownerOf(_tokenId) != msg.sender) revert OnlyTokenOwnerCanDoThat(_tokenId, ownerOf(_tokenId));
1846 
1847         // Keep track of all tokens this address has burned
1848         burnedBy[msg.sender].push(_tokenId);
1849         _burn(_tokenId);
1850     }
1851     function getBurnedBy(address _by) external view returns (uint256[] memory) {
1852         return burnedBy[_by];
1853     }
1854 
1855 
1856     ///////////////////////////////////////////////////////////////////////////
1857     // Withdraw funds from contract
1858     ///////////////////////////////////////////////////////////////////////////
1859     // ETH is received for mint and royalties
1860     function withdrawETH() public onlyTeam {
1861         uint256 totalETH = address(this).balance;
1862         if (totalETH == 0) revert EmptyWithdraw();
1863 
1864         uint256 teamSize = team.length;
1865         for (uint256 i; i < teamSize; ) {
1866             address payable wallet = payable(team[i]);
1867             // How much is this wallet owed
1868             uint256 payment = (totalETH * teamShares[i]) / TOTAL_SHARES;
1869             // Send payment
1870             Address.sendValue(wallet, payment);
1871 
1872             unchecked { ++i; }
1873         }
1874         emit ETHWithdrawn(totalETH);
1875     }
1876 
1877     // Royalties in any ERC20 are accepted
1878     function withdrawERC20(IERC20 _token) public onlyTeam {
1879         uint256 totalERC20 = _token.balanceOf(address(this));
1880         if (totalERC20 == 0) revert EmptyWithdraw();
1881 
1882         uint256 teamSize = team.length;
1883         for (uint256 i; i < teamSize; ) {
1884             // How much is this wallet owed
1885             uint256 payment = (totalERC20 * teamShares[i]) / TOTAL_SHARES;
1886             // Send payment
1887             _token.transfer(team[i], payment);
1888 
1889             unchecked { ++i; }
1890         }
1891         emit ERC20Withdrawn(address(_token), totalERC20);
1892     }
1893 
1894 
1895     ///////////////////////////////////////////////////////////////////////////
1896     // Royalties - ERC2981
1897     ///////////////////////////////////////////////////////////////////////////
1898     // Supports ERC2981 for royalties as well as ofc 721 and 165
1899     function supportsInterface(bytes4 _interfaceId) public view override(ERC721A, IERC165) returns (bool) {
1900         return _interfaceId == INTERFACE_ID_ERC2981 || super.supportsInterface(_interfaceId);
1901     }
1902 
1903     // NFT marketplaces will call this function to determine amount of royalties
1904     // to charge and who to send them to
1905     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address _receiver, uint256 _royaltyAmount) {
1906         _receiver = address(this);
1907         _royaltyAmount = (_salePrice * ROYALTIES_PERCENTAGE_X10) / 1000;
1908     }
1909 
1910     // ensure this contract can receive payments (royalties)
1911     receive() external payable { }
1912 
1913 
1914     ///////////////////////////////////////////////////////////////////////////
1915     // Custom functions
1916     ///////////////////////////////////////////////////////////////////////////
1917     function transform(uint256 _tokenId) public payable {
1918         if (msg.value != transformPrice) revert WrongTransformPrice(msg.value, transformPrice);
1919         if (ownerOf(_tokenId) != msg.sender) revert OnlyTokenOwnerCanDoThat(_tokenId, ownerOf(_tokenId));
1920         if (transformed[_tokenId]) revert AlreadyTransformed(_tokenId);
1921         if (numTransformed >= maxTransforms) revert TransformingEnded();
1922 
1923         // As dev, Larkin may get a bump in payments for transforms
1924         if (devTransformBoost > 0) {
1925             Address.sendValue(payable(LARKIN), msg.value * devTransformBoost / 100);
1926         }
1927 
1928         numTransformed += 1;
1929         transformed[_tokenId] = true;
1930         emit Transformed(_tokenId);
1931     }
1932 
1933 
1934     ///////////////////////////////////////////////////////////////////////////
1935     // Errors and Events
1936     ///////////////////////////////////////////////////////////////////////////
1937     error InvalidTeam(uint256 sizeOrShares);
1938     error OnlyTeamCanDoThat();
1939     error OnlyAllowedAddressCanDoThat(address allowed);
1940     error MintClosed();
1941     error WouldPassSupplyCap(uint256 wouldBeSupply);
1942     error WalletCanOnlyMintNMore(uint256 more);
1943     error EmptyWithdraw();
1944     error TokenDNE(uint256 tokenId);
1945     error OnlyTokenOwnerCanDoThat(uint256 tokenId, address owner);
1946     error WrongTransformPrice(uint256 payed, uint256 price);
1947     error AlreadyTransformed(uint256 tokenId);
1948     error TransformingEnded();
1949 
1950     event ETHWithdrawn(uint256 amount);
1951     event ERC20Withdrawn(address erc20, uint256 amount);
1952     event Transformed(uint256 tokenId);
1953 }
1954 
1955 /*
1956  Product of
1957  Yeah! Studios™ - @yeah_studios - yeahstudios.io - yeahstudios.eth
1958 
1959  Lead, Design, Branding: PixelPimp - @pixelpimp
1960  Solidity & React:       Larkin    - @CodeLarkin - codelarkin.eth
1961  Marketing:              makerlee  - @0xmakerlee - makerlee.eth
1962  Marketing:              mustachi0
1963  Genrative:              makewayx
1964  Social Media Manager:   Korey     - @ayeKorey
1965 
1966 
1967 ╔╗  ╔╗         ╔╗  ╔╗    ╔═══╗ ╔╗       ╔╗              ╔════╗╔═╗╔═╗
1968 ║╚╗╔╝║         ║║  ║║    ║╔═╗║╔╝╚╗      ║║              ║╔╗╔╗║║║╚╝║║
1969 ╚╗╚╝╔╝╔══╗╔══╗ ║╚═╗║║    ║╚══╗╚╗╔╝╔╗╔╗╔═╝║╔╗╔══╗╔══╗    ╚╝║║╚╝║╔╗╔╗║
1970  ╚╗╔╝ ║╔╗║╚ ╗║ ║╔╗║╚╝    ╚══╗║ ║║ ║║║║║╔╗║╠╣║╔╗║║══╣      ║║  ║║║║║║
1971   ║║  ║║═╣║╚╝╚╗║║║║╔╗    ║╚═╝║ ║╚╗║╚╝║║╚╝║║║║╚╝║╠══║     ╔╝╚╗ ║║║║║║
1972   ╚╝  ╚══╝╚═══╝╚╝╚╝╚╝    ╚═══╝ ╚═╝╚══╝╚══╝╚╝╚══╝╚══╝     ╚══╝ ╚╝╚╝╚╝
1973 
1974 contract by:
1975  ██╗      █████╗ ██████╗ ██╗  ██╗██╗███╗   ██╗
1976  ██║     ██╔══██╗██╔══██╗██║ ██╔╝██║████╗  ██║
1977  ██║     ███████║██████╔╝█████╔╝ ██║██╔██╗ ██║
1978  ██║     ██╔══██║██╔══██╗██╔═██╗ ██║██║╚██╗██║
1979  ███████╗██║  ██║██║  ██║██║  ██╗██║██║ ╚████║
1980  ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝
1981 */