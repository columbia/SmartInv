1 // SPDX-License-Identifier: MIT
2 /*
3 .........................................................................................................................................................................
4 .........................................................................................................................................................................
5 ..............]/@@@@@`...................................................................................................................................................
6 .........,/@@@@@@@@@^......................................................../@@@@@/.....................................................................................
7 ......,@@@/`.@@@@@@^........................................................=@@@@@/......................................................................................
8 ..../@@@/.../@@@@@^........................................................=@@@@@O.......................................................................................
9 ...@@@@`.../@@@@@^........................................................=@@@@@@...................................]]]]]]................................,]]]]]]........
10 ..@@@@`.../@@@@@^.......]/@@@@@@`......=@@@@@@..,@@@@^......,/@@@@@@\....=@@@@@@.....@@@@@@^...=@@@@@@.............@@@@@@^]@@@@@\`........,/@@@@@@\......,@@@@@@.]@@@@@\.
11 .=@@@^...=@@@@@/.....,@@@@@@[[@@@^....=@@@@@@...@@@@@^...,@@@@@/`.@@@^..,@@@@@@.....@@@@@@^...=@@@@@@.............@@@@@@@@@@@@@@@@.....,@@@@@@[[\@@O.....@@@@@@@@@@@@@@@@
12 ..,\@^..=@@@@@/..../@@@@@/...,@@@^...,@@@@@@....../@/..,@@@@@@...,@@@`.,@@@@@@`..../@@@@@^...,@@@@@@............./@@@@@/....@@@@@@...,@@@@@@`.../@@O....@@@@@@/....@@@@@@
13 .......=@@@@@/...,@@@@@@`.../@@@@\/@@@@@@@@......=@@../@@@@@/...=@@@`.,@@@@@@`..../@@@@@/...,@@@@@@`............/@@@@@/....,@@@@@O../@@@@@^...=@@@@@]O@@@@@@@^....=@@@@@^
14 ......=@@@@@@...=@@@@@@.....\@@@/[`,@@@@@@`.....=@@`,@@@@@@^..,@@@/...@@@@@@`..../@@@@@/...,@@@@@@`............/@@@@@/...../@@@@@`,@@@@@@`....,@@@@[[.@@@@@@^.....@@@@@@.
15 .....=@@@@@@...=@@@@@@......@@@/..,@@@@@@`...../@@`,@@@@@@\/@@@/`....@@@@@@`....=@@@@@/...,@@@@@@`............=@@@@@/...../@@@@@^,@@@@@@`...../@@@.../@@@@@^.....@@@@@@`.
16 ....,@@@@@@...=@@@@@@......@@@@...@@@@@@`....,@@@`.@@@@@@@[[`.......@@@@@@^....=@@@@@/....@@@@@@`............=@@@@@/...../@@@@@^,@@@@@@^...../@@@`../@@@@@^.....@@@@@@^..
17 ...,@@@@@@`..,@@@@@@^....,@@@/...@@@@@@^..../@@/../@@@@@@........./@@@@@@^..../@@@@@@...,@@@@@@^.../@`......=@@@@@@.....@@@@@@^.O@@@@@/.....@@@@.../@@@@@/....,@@@@@@`...
18 ..,@@@@@@`...=@@@@@@`..,@@@@`.../@@@@@O..,/@@@`...@@@@@@\......]@@@@@@@@@...]@@@@@@@^../@@@@@@^..,@/.......=@@@@@@..../@@@@@@`..@@@@@@^.../@@@^...=@@@@@/...,@@@@@@/.....
19 ..@@@@@@`....=@@@@@@@@@@@@`.....O@@@@@@@@@@@`.....@@@@@@@@@@@@@/`.\@@@@@@@@@@\@@@@@@@@@@@@@@@^.]@@`.......,@@@@@@@@@@@@@@@@`....@@@@@@@@@@@@[....=@@@@@@@@@@@@@@@/.......
20 .@@@@@@\`.....,\@@@@@@/[........,@@@@@@@/`.........\@@@@@@@@[.....,@@@@@@@[...\@@@@@@`/@@@@@@@O`.........,@@@@@@\@@@@@@@[........\@@@@@@@[......=@@@@@@\@@@@@@/`.........
21 ,[[\@@@@@@@\......................................................................]/@@@@@@@/.............@@@@@@`...............................=@@@@@@...................
22 ......,\@@@@@@@].............................................................../@@/`=@@@@@/.............@@@@@@`...............................,@@@@@@....................
23 .........\@@@@@@@@@@@@@^.....................................................,@@^../@@@@@/.............@@@@@@^...............................,@@@@@@`....................
24 ...........\@@@@@@@@@@^......................................................O@@\/@@@@@@`.............@@@@@@^...............................,@@@@@@`.....................
25 .............,@@@@@@@`.......................................................,@@@@@@@/`............../@@@@/`................................@@@@O[`......................
26 .........................................................................................................................................................................
27 .........................................................................................................................................................................
28 */
29 // File: @openzeppelin/contracts/utils/Strings.sol
30 
31 
32 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
33 
34 pragma solidity ^0.8.0;
35 
36 /**
37  * @dev String operations.
38  */
39 library Strings {
40     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
41 
42     /**
43      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
44      */
45     function toString(uint256 value) internal pure returns (string memory) {
46         // Inspired by OraclizeAPI's implementation - MIT licence
47         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
48 
49         if (value == 0) {
50             return "0";
51         }
52         uint256 temp = value;
53         uint256 digits;
54         while (temp != 0) {
55             digits++;
56             temp /= 10;
57         }
58         bytes memory buffer = new bytes(digits);
59         while (value != 0) {
60             digits -= 1;
61             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
62             value /= 10;
63         }
64         return string(buffer);
65     }
66 
67     /**
68      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
69      */
70     function toHexString(uint256 value) internal pure returns (string memory) {
71         if (value == 0) {
72             return "0x00";
73         }
74         uint256 temp = value;
75         uint256 length = 0;
76         while (temp != 0) {
77             length++;
78             temp >>= 8;
79         }
80         return toHexString(value, length);
81     }
82 
83     /**
84      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
85      */
86     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
87         bytes memory buffer = new bytes(2 * length + 2);
88         buffer[0] = "0";
89         buffer[1] = "x";
90         for (uint256 i = 2 * length + 1; i > 1; --i) {
91             buffer[i] = _HEX_SYMBOLS[value & 0xf];
92             value >>= 4;
93         }
94         require(value == 0, "Strings: hex length insufficient");
95         return string(buffer);
96     }
97 }
98 
99 // File: erc721a/contracts/IERC721A.sol
100 
101 
102 // ERC721A Contracts v4.0.0
103 // Creator: Chiru Labs
104 
105 pragma solidity ^0.8.4;
106 
107 /**
108  * @dev Interface of an ERC721A compliant contract.
109  */
110 interface IERC721A {
111     /**
112      * The caller must own the token or be an approved operator.
113      */
114     error ApprovalCallerNotOwnerNorApproved();
115 
116     /**
117      * The token does not exist.
118      */
119     error ApprovalQueryForNonexistentToken();
120 
121     /**
122      * The caller cannot approve to their own address.
123      */
124     error ApproveToCaller();
125 
126     /**
127      * The caller cannot approve to the current owner.
128      */
129     error ApprovalToCurrentOwner();
130 
131     /**
132      * Cannot query the balance for the zero address.
133      */
134     error BalanceQueryForZeroAddress();
135 
136     /**
137      * Cannot mint to the zero address.
138      */
139     error MintToZeroAddress();
140 
141     /**
142      * The quantity of tokens minted must be more than zero.
143      */
144     error MintZeroQuantity();
145 
146     /**
147      * The token does not exist.
148      */
149     error OwnerQueryForNonexistentToken();
150 
151     /**
152      * The caller must own the token or be an approved operator.
153      */
154     error TransferCallerNotOwnerNorApproved();
155 
156     /**
157      * The token must be owned by `from`.
158      */
159     error TransferFromIncorrectOwner();
160 
161     /**
162      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
163      */
164     error TransferToNonERC721ReceiverImplementer();
165 
166     /**
167      * Cannot transfer to the zero address.
168      */
169     error TransferToZeroAddress();
170 
171     /**
172      * The token does not exist.
173      */
174     error URIQueryForNonexistentToken();
175 
176     struct TokenOwnership {
177         // The address of the owner.
178         address addr;
179         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
180         uint64 startTimestamp;
181         // Whether the token has been burned.
182         bool burned;
183     }
184 
185     /**
186      * @dev Returns the total amount of tokens stored by the contract.
187      *
188      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
189      */
190     function totalSupply() external view returns (uint256);
191 
192     // ==============================
193     //            IERC165
194     // ==============================
195 
196     /**
197      * @dev Returns true if this contract implements the interface defined by
198      * `interfaceId`. See the corresponding
199      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
200      * to learn more about how these ids are created.
201      *
202      * This function call must use less than 30 000 gas.
203      */
204     function supportsInterface(bytes4 interfaceId) external view returns (bool);
205 
206     // ==============================
207     //            IERC721
208     // ==============================
209 
210     /**
211      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
212      */
213     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
214 
215     /**
216      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
217      */
218     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
219 
220     /**
221      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
222      */
223     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
224 
225     /**
226      * @dev Returns the number of tokens in ``owner``'s account.
227      */
228     function balanceOf(address owner) external view returns (uint256 balance);
229 
230     /**
231      * @dev Returns the owner of the `tokenId` token.
232      *
233      * Requirements:
234      *
235      * - `tokenId` must exist.
236      */
237     function ownerOf(uint256 tokenId) external view returns (address owner);
238 
239     /**
240      * @dev Safely transfers `tokenId` token from `from` to `to`.
241      *
242      * Requirements:
243      *
244      * - `from` cannot be the zero address.
245      * - `to` cannot be the zero address.
246      * - `tokenId` token must exist and be owned by `from`.
247      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
248      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
249      *
250      * Emits a {Transfer} event.
251      */
252     function safeTransferFrom(
253         address from,
254         address to,
255         uint256 tokenId,
256         bytes calldata data
257     ) external;
258 
259     /**
260      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
261      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
262      *
263      * Requirements:
264      *
265      * - `from` cannot be the zero address.
266      * - `to` cannot be the zero address.
267      * - `tokenId` token must exist and be owned by `from`.
268      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
269      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
270      *
271      * Emits a {Transfer} event.
272      */
273     function safeTransferFrom(
274         address from,
275         address to,
276         uint256 tokenId
277     ) external;
278 
279     /**
280      * @dev Transfers `tokenId` token from `from` to `to`.
281      *
282      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
283      *
284      * Requirements:
285      *
286      * - `from` cannot be the zero address.
287      * - `to` cannot be the zero address.
288      * - `tokenId` token must be owned by `from`.
289      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
290      *
291      * Emits a {Transfer} event.
292      */
293     function transferFrom(
294         address from,
295         address to,
296         uint256 tokenId
297     ) external;
298 
299     /**
300      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
301      * The approval is cleared when the token is transferred.
302      *
303      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
304      *
305      * Requirements:
306      *
307      * - The caller must own the token or be an approved operator.
308      * - `tokenId` must exist.
309      *
310      * Emits an {Approval} event.
311      */
312     function approve(address to, uint256 tokenId) external;
313 
314     /**
315      * @dev Approve or remove `operator` as an operator for the caller.
316      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
317      *
318      * Requirements:
319      *
320      * - The `operator` cannot be the caller.
321      *
322      * Emits an {ApprovalForAll} event.
323      */
324     function setApprovalForAll(address operator, bool _approved) external;
325 
326     /**
327      * @dev Returns the account approved for `tokenId` token.
328      *
329      * Requirements:
330      *
331      * - `tokenId` must exist.
332      */
333     function getApproved(uint256 tokenId) external view returns (address operator);
334 
335     /**
336      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
337      *
338      * See {setApprovalForAll}
339      */
340     function isApprovedForAll(address owner, address operator) external view returns (bool);
341 
342     // ==============================
343     //        IERC721Metadata
344     // ==============================
345 
346     /**
347      * @dev Returns the token collection name.
348      */
349     function name() external view returns (string memory);
350 
351     /**
352      * @dev Returns the token collection symbol.
353      */
354     function symbol() external view returns (string memory);
355 
356     /**
357      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
358      */
359     function tokenURI(uint256 tokenId) external view returns (string memory);
360 }
361 
362 // File: erc721a/contracts/ERC721A.sol
363 
364 
365 // ERC721A Contracts v4.0.0
366 // Creator: Chiru Labs
367 
368 pragma solidity ^0.8.4;
369 
370 
371 /**
372  * @dev ERC721 token receiver interface.
373  */
374 interface ERC721A__IERC721Receiver {
375     function onERC721Received(
376         address operator,
377         address from,
378         uint256 tokenId,
379         bytes calldata data
380     ) external returns (bytes4);
381 }
382 
383 /**
384  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
385  * the Metadata extension. Built to optimize for lower gas during batch mints.
386  *
387  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
388  *
389  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
390  *
391  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
392  */
393 contract ERC721A is IERC721A {
394     // Mask of an entry in packed address data.
395     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
396 
397     // The bit position of `numberMinted` in packed address data.
398     uint256 private constant BITPOS_NUMBER_MINTED = 64;
399 
400     // The bit position of `numberBurned` in packed address data.
401     uint256 private constant BITPOS_NUMBER_BURNED = 128;
402 
403     // The bit position of `aux` in packed address data.
404     uint256 private constant BITPOS_AUX = 192;
405 
406     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
407     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
408 
409     // The bit position of `startTimestamp` in packed ownership.
410     uint256 private constant BITPOS_START_TIMESTAMP = 160;
411 
412     // The bit mask of the `burned` bit in packed ownership.
413     uint256 private constant BITMASK_BURNED = 1 << 224;
414     
415     // The bit position of the `nextInitialized` bit in packed ownership.
416     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
417 
418     // The bit mask of the `nextInitialized` bit in packed ownership.
419     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
420 
421     // The tokenId of the next token to be minted.
422     uint256 private _currentIndex;
423 
424     // The number of tokens burned.
425     uint256 private _burnCounter;
426 
427     // Token name
428     string private _name;
429 
430     // Token symbol
431     string private _symbol;
432 
433     // Mapping from token ID to ownership details
434     // An empty struct value does not necessarily mean the token is unowned.
435     // See `_packedOwnershipOf` implementation for details.
436     //
437     // Bits Layout:
438     // - [0..159]   `addr`
439     // - [160..223] `startTimestamp`
440     // - [224]      `burned`
441     // - [225]      `nextInitialized`
442     mapping(uint256 => uint256) private _packedOwnerships;
443 
444     // Mapping owner address to address data.
445     //
446     // Bits Layout:
447     // - [0..63]    `balance`
448     // - [64..127]  `numberMinted`
449     // - [128..191] `numberBurned`
450     // - [192..255] `aux`
451     mapping(address => uint256) private _packedAddressData;
452 
453     // Mapping from token ID to approved address.
454     mapping(uint256 => address) private _tokenApprovals;
455 
456     // Mapping from owner to operator approvals
457     mapping(address => mapping(address => bool)) private _operatorApprovals;
458 
459     constructor(string memory name_, string memory symbol_) {
460         _name = name_;
461         _symbol = symbol_;
462         _currentIndex = _startTokenId();
463     }
464 
465     /**
466      * @dev Returns the starting token ID. 
467      * To change the starting token ID, please override this function.
468      */
469     function _startTokenId() internal view virtual returns (uint256) {
470         return 0;
471     }
472 
473     /**
474      * @dev Returns the next token ID to be minted.
475      */
476     function _nextTokenId() internal view returns (uint256) {
477         return _currentIndex;
478     }
479 
480     /**
481      * @dev Returns the total number of tokens in existence.
482      * Burned tokens will reduce the count. 
483      * To get the total number of tokens minted, please see `_totalMinted`.
484      */
485     function totalSupply() public view override returns (uint256) {
486         // Counter underflow is impossible as _burnCounter cannot be incremented
487         // more than `_currentIndex - _startTokenId()` times.
488         unchecked {
489             return _currentIndex - _burnCounter - _startTokenId();
490         }
491     }
492 
493     /**
494      * @dev Returns the total amount of tokens minted in the contract.
495      */
496     function _totalMinted() internal view returns (uint256) {
497         // Counter underflow is impossible as _currentIndex does not decrement,
498         // and it is initialized to `_startTokenId()`
499         unchecked {
500             return _currentIndex - _startTokenId();
501         }
502     }
503 
504     /**
505      * @dev Returns the total number of tokens burned.
506      */
507     function _totalBurned() internal view returns (uint256) {
508         return _burnCounter;
509     }
510 
511     /**
512      * @dev See {IERC165-supportsInterface}.
513      */
514     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
515         // The interface IDs are constants representing the first 4 bytes of the XOR of
516         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
517         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
518         return
519             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
520             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
521             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
522     }
523 
524     /**
525      * @dev See {IERC721-balanceOf}.
526      */
527     function balanceOf(address owner) public view override returns (uint256) {
528         if (owner == address(0)) revert BalanceQueryForZeroAddress();
529         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
530     }
531 
532     /**
533      * Returns the number of tokens minted by `owner`.
534      */
535     function _numberMinted(address owner) internal view returns (uint256) {
536         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
537     }
538 
539     /**
540      * Returns the number of tokens burned by or on behalf of `owner`.
541      */
542     function _numberBurned(address owner) internal view returns (uint256) {
543         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
544     }
545 
546     /**
547      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
548      */
549     function _getAux(address owner) internal view returns (uint64) {
550         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
551     }
552 
553     /**
554      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
555      * If there are multiple variables, please pack them into a uint64.
556      */
557     function _setAux(address owner, uint64 aux) internal {
558         uint256 packed = _packedAddressData[owner];
559         uint256 auxCasted;
560         assembly { // Cast aux without masking.
561             auxCasted := aux
562         }
563         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
564         _packedAddressData[owner] = packed;
565     }
566 
567     /**
568      * Returns the packed ownership data of `tokenId`.
569      */
570     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
571         uint256 curr = tokenId;
572 
573         unchecked {
574             if (_startTokenId() <= curr)
575                 if (curr < _currentIndex) {
576                     uint256 packed = _packedOwnerships[curr];
577                     // If not burned.
578                     if (packed & BITMASK_BURNED == 0) {
579                         // Invariant:
580                         // There will always be an ownership that has an address and is not burned
581                         // before an ownership that does not have an address and is not burned.
582                         // Hence, curr will not underflow.
583                         //
584                         // We can directly compare the packed value.
585                         // If the address is zero, packed is zero.
586                         while (packed == 0) {
587                             packed = _packedOwnerships[--curr];
588                         }
589                         return packed;
590                     }
591                 }
592         }
593         revert OwnerQueryForNonexistentToken();
594     }
595 
596     /**
597      * Returns the unpacked `TokenOwnership` struct from `packed`.
598      */
599     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
600         ownership.addr = address(uint160(packed));
601         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
602         ownership.burned = packed & BITMASK_BURNED != 0;
603     }
604 
605     /**
606      * Returns the unpacked `TokenOwnership` struct at `index`.
607      */
608     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
609         return _unpackedOwnership(_packedOwnerships[index]);
610     }
611 
612     /**
613      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
614      */
615     function _initializeOwnershipAt(uint256 index) internal {
616         if (_packedOwnerships[index] == 0) {
617             _packedOwnerships[index] = _packedOwnershipOf(index);
618         }
619     }
620 
621     /**
622      * Gas spent here starts off proportional to the maximum mint batch size.
623      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
624      */
625     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
626         return _unpackedOwnership(_packedOwnershipOf(tokenId));
627     }
628 
629     /**
630      * @dev See {IERC721-ownerOf}.
631      */
632     function ownerOf(uint256 tokenId) public view override returns (address) {
633         return address(uint160(_packedOwnershipOf(tokenId)));
634     }
635 
636     /**
637      * @dev See {IERC721Metadata-name}.
638      */
639     function name() public view virtual override returns (string memory) {
640         return _name;
641     }
642 
643     /**
644      * @dev See {IERC721Metadata-symbol}.
645      */
646     function symbol() public view virtual override returns (string memory) {
647         return _symbol;
648     }
649 
650     /**
651      * @dev See {IERC721Metadata-tokenURI}.
652      */
653     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
654         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
655 
656         string memory baseURI = _baseURI();
657         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
658     }
659 
660     /**
661      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
662      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
663      * by default, can be overriden in child contracts.
664      */
665     function _baseURI() internal view virtual returns (string memory) {
666         return '';
667     }
668 
669     /**
670      * @dev Casts the address to uint256 without masking.
671      */
672     function _addressToUint256(address value) private pure returns (uint256 result) {
673         assembly {
674             result := value
675         }
676     }
677 
678     /**
679      * @dev Casts the boolean to uint256 without branching.
680      */
681     function _boolToUint256(bool value) private pure returns (uint256 result) {
682         assembly {
683             result := value
684         }
685     }
686 
687     /**
688      * @dev See {IERC721-approve}.
689      */
690     function approve(address to, uint256 tokenId) public override {
691         address owner = address(uint160(_packedOwnershipOf(tokenId)));
692         if (to == owner) revert ApprovalToCurrentOwner();
693 
694         if (_msgSenderERC721A() != owner)
695             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
696                 revert ApprovalCallerNotOwnerNorApproved();
697             }
698 
699         _tokenApprovals[tokenId] = to;
700         emit Approval(owner, to, tokenId);
701     }
702 
703     /**
704      * @dev See {IERC721-getApproved}.
705      */
706     function getApproved(uint256 tokenId) public view override returns (address) {
707         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
708 
709         return _tokenApprovals[tokenId];
710     }
711 
712     /**
713      * @dev See {IERC721-setApprovalForAll}.
714      */
715     function setApprovalForAll(address operator, bool approved) public virtual override {
716         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
717 
718         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
719         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
720     }
721 
722     /**
723      * @dev See {IERC721-isApprovedForAll}.
724      */
725     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
726         return _operatorApprovals[owner][operator];
727     }
728 
729     /**
730      * @dev See {IERC721-transferFrom}.
731      */
732     function transferFrom(
733         address from,
734         address to,
735         uint256 tokenId
736     ) public virtual override {
737         _transfer(from, to, tokenId);
738     }
739 
740     /**
741      * @dev See {IERC721-safeTransferFrom}.
742      */
743     function safeTransferFrom(
744         address from,
745         address to,
746         uint256 tokenId
747     ) public virtual override {
748         safeTransferFrom(from, to, tokenId, '');
749     }
750 
751     /**
752      * @dev See {IERC721-safeTransferFrom}.
753      */
754     function safeTransferFrom(
755         address from,
756         address to,
757         uint256 tokenId,
758         bytes memory _data
759     ) public virtual override {
760         _transfer(from, to, tokenId);
761         if (to.code.length != 0)
762             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
763                 revert TransferToNonERC721ReceiverImplementer();
764             }
765     }
766 
767     /**
768      * @dev Returns whether `tokenId` exists.
769      *
770      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
771      *
772      * Tokens start existing when they are minted (`_mint`),
773      */
774     function _exists(uint256 tokenId) internal view returns (bool) {
775         return
776             _startTokenId() <= tokenId &&
777             tokenId < _currentIndex && // If within bounds,
778             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
779     }
780 
781     /**
782      * @dev Equivalent to `_safeMint(to, quantity, '')`.
783      */
784     function _safeMint(address to, uint256 quantity) internal {
785         _safeMint(to, quantity, '');
786     }
787 
788     /**
789      * @dev Safely mints `quantity` tokens and transfers them to `to`.
790      *
791      * Requirements:
792      *
793      * - If `to` refers to a smart contract, it must implement
794      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
795      * - `quantity` must be greater than 0.
796      *
797      * Emits a {Transfer} event.
798      */
799     function _safeMint(
800         address to,
801         uint256 quantity,
802         bytes memory _data
803     ) internal {
804         uint256 startTokenId = _currentIndex;
805         if (to == address(0)) revert MintToZeroAddress();
806         if (quantity == 0) revert MintZeroQuantity();
807 
808         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
809 
810         // Overflows are incredibly unrealistic.
811         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
812         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
813         unchecked {
814             // Updates:
815             // - `balance += quantity`.
816             // - `numberMinted += quantity`.
817             //
818             // We can directly add to the balance and number minted.
819             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
820 
821             // Updates:
822             // - `address` to the owner.
823             // - `startTimestamp` to the timestamp of minting.
824             // - `burned` to `false`.
825             // - `nextInitialized` to `quantity == 1`.
826             _packedOwnerships[startTokenId] =
827                 _addressToUint256(to) |
828                 (block.timestamp << BITPOS_START_TIMESTAMP) |
829                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
830 
831             uint256 updatedIndex = startTokenId;
832             uint256 end = updatedIndex + quantity;
833 
834             if (to.code.length != 0) {
835                 do {
836                     emit Transfer(address(0), to, updatedIndex);
837                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
838                         revert TransferToNonERC721ReceiverImplementer();
839                     }
840                 } while (updatedIndex < end);
841                 // Reentrancy protection
842                 if (_currentIndex != startTokenId) revert();
843             } else {
844                 do {
845                     emit Transfer(address(0), to, updatedIndex++);
846                 } while (updatedIndex < end);
847             }
848             _currentIndex = updatedIndex;
849         }
850         _afterTokenTransfers(address(0), to, startTokenId, quantity);
851     }
852 
853     /**
854      * @dev Mints `quantity` tokens and transfers them to `to`.
855      *
856      * Requirements:
857      *
858      * - `to` cannot be the zero address.
859      * - `quantity` must be greater than 0.
860      *
861      * Emits a {Transfer} event.
862      */
863     function _mint(address to, uint256 quantity) internal {
864         uint256 startTokenId = _currentIndex;
865         if (to == address(0)) revert MintToZeroAddress();
866         if (quantity == 0) revert MintZeroQuantity();
867 
868         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
869 
870         // Overflows are incredibly unrealistic.
871         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
872         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
873         unchecked {
874             // Updates:
875             // - `balance += quantity`.
876             // - `numberMinted += quantity`.
877             //
878             // We can directly add to the balance and number minted.
879             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
880 
881             // Updates:
882             // - `address` to the owner.
883             // - `startTimestamp` to the timestamp of minting.
884             // - `burned` to `false`.
885             // - `nextInitialized` to `quantity == 1`.
886             _packedOwnerships[startTokenId] =
887                 _addressToUint256(to) |
888                 (block.timestamp << BITPOS_START_TIMESTAMP) |
889                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
890 
891             uint256 updatedIndex = startTokenId;
892             uint256 end = updatedIndex + quantity;
893 
894             do {
895                 emit Transfer(address(0), to, updatedIndex++);
896             } while (updatedIndex < end);
897 
898             _currentIndex = updatedIndex;
899         }
900         _afterTokenTransfers(address(0), to, startTokenId, quantity);
901     }
902 
903     /**
904      * @dev Transfers `tokenId` from `from` to `to`.
905      *
906      * Requirements:
907      *
908      * - `to` cannot be the zero address.
909      * - `tokenId` token must be owned by `from`.
910      *
911      * Emits a {Transfer} event.
912      */
913     function _transfer(
914         address from,
915         address to,
916         uint256 tokenId
917     ) private {
918         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
919 
920         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
921 
922         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
923             isApprovedForAll(from, _msgSenderERC721A()) ||
924             getApproved(tokenId) == _msgSenderERC721A());
925 
926         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
927         if (to == address(0)) revert TransferToZeroAddress();
928 
929         _beforeTokenTransfers(from, to, tokenId, 1);
930 
931         // Clear approvals from the previous owner.
932         delete _tokenApprovals[tokenId];
933 
934         // Underflow of the sender's balance is impossible because we check for
935         // ownership above and the recipient's balance can't realistically overflow.
936         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
937         unchecked {
938             // We can directly increment and decrement the balances.
939             --_packedAddressData[from]; // Updates: `balance -= 1`.
940             ++_packedAddressData[to]; // Updates: `balance += 1`.
941 
942             // Updates:
943             // - `address` to the next owner.
944             // - `startTimestamp` to the timestamp of transfering.
945             // - `burned` to `false`.
946             // - `nextInitialized` to `true`.
947             _packedOwnerships[tokenId] =
948                 _addressToUint256(to) |
949                 (block.timestamp << BITPOS_START_TIMESTAMP) |
950                 BITMASK_NEXT_INITIALIZED;
951 
952             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
953             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
954                 uint256 nextTokenId = tokenId + 1;
955                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
956                 if (_packedOwnerships[nextTokenId] == 0) {
957                     // If the next slot is within bounds.
958                     if (nextTokenId != _currentIndex) {
959                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
960                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
961                     }
962                 }
963             }
964         }
965 
966         emit Transfer(from, to, tokenId);
967         _afterTokenTransfers(from, to, tokenId, 1);
968     }
969 
970     /**
971      * @dev Equivalent to `_burn(tokenId, false)`.
972      */
973     function _burn(uint256 tokenId) internal virtual {
974         _burn(tokenId, false);
975     }
976 
977     /**
978      * @dev Destroys `tokenId`.
979      * The approval is cleared when the token is burned.
980      *
981      * Requirements:
982      *
983      * - `tokenId` must exist.
984      *
985      * Emits a {Transfer} event.
986      */
987     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
988         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
989 
990         address from = address(uint160(prevOwnershipPacked));
991 
992         if (approvalCheck) {
993             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
994                 isApprovedForAll(from, _msgSenderERC721A()) ||
995                 getApproved(tokenId) == _msgSenderERC721A());
996 
997             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
998         }
999 
1000         _beforeTokenTransfers(from, address(0), tokenId, 1);
1001 
1002         // Clear approvals from the previous owner.
1003         delete _tokenApprovals[tokenId];
1004 
1005         // Underflow of the sender's balance is impossible because we check for
1006         // ownership above and the recipient's balance can't realistically overflow.
1007         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1008         unchecked {
1009             // Updates:
1010             // - `balance -= 1`.
1011             // - `numberBurned += 1`.
1012             //
1013             // We can directly decrement the balance, and increment the number burned.
1014             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1015             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1016 
1017             // Updates:
1018             // - `address` to the last owner.
1019             // - `startTimestamp` to the timestamp of burning.
1020             // - `burned` to `true`.
1021             // - `nextInitialized` to `true`.
1022             _packedOwnerships[tokenId] =
1023                 _addressToUint256(from) |
1024                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1025                 BITMASK_BURNED | 
1026                 BITMASK_NEXT_INITIALIZED;
1027 
1028             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1029             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1030                 uint256 nextTokenId = tokenId + 1;
1031                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1032                 if (_packedOwnerships[nextTokenId] == 0) {
1033                     // If the next slot is within bounds.
1034                     if (nextTokenId != _currentIndex) {
1035                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1036                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1037                     }
1038                 }
1039             }
1040         }
1041 
1042         emit Transfer(from, address(0), tokenId);
1043         _afterTokenTransfers(from, address(0), tokenId, 1);
1044 
1045         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1046         unchecked {
1047             _burnCounter++;
1048         }
1049     }
1050 
1051     /**
1052      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1053      *
1054      * @param from address representing the previous owner of the given token ID
1055      * @param to target address that will receive the tokens
1056      * @param tokenId uint256 ID of the token to be transferred
1057      * @param _data bytes optional data to send along with the call
1058      * @return bool whether the call correctly returned the expected magic value
1059      */
1060     function _checkContractOnERC721Received(
1061         address from,
1062         address to,
1063         uint256 tokenId,
1064         bytes memory _data
1065     ) private returns (bool) {
1066         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1067             bytes4 retval
1068         ) {
1069             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1070         } catch (bytes memory reason) {
1071             if (reason.length == 0) {
1072                 revert TransferToNonERC721ReceiverImplementer();
1073             } else {
1074                 assembly {
1075                     revert(add(32, reason), mload(reason))
1076                 }
1077             }
1078         }
1079     }
1080 
1081     /**
1082      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1083      * And also called before burning one token.
1084      *
1085      * startTokenId - the first token id to be transferred
1086      * quantity - the amount to be transferred
1087      *
1088      * Calling conditions:
1089      *
1090      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1091      * transferred to `to`.
1092      * - When `from` is zero, `tokenId` will be minted for `to`.
1093      * - When `to` is zero, `tokenId` will be burned by `from`.
1094      * - `from` and `to` are never both zero.
1095      */
1096     function _beforeTokenTransfers(
1097         address from,
1098         address to,
1099         uint256 startTokenId,
1100         uint256 quantity
1101     ) internal virtual {}
1102 
1103     /**
1104      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1105      * minting.
1106      * And also called after one token has been burned.
1107      *
1108      * startTokenId - the first token id to be transferred
1109      * quantity - the amount to be transferred
1110      *
1111      * Calling conditions:
1112      *
1113      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1114      * transferred to `to`.
1115      * - When `from` is zero, `tokenId` has been minted for `to`.
1116      * - When `to` is zero, `tokenId` has been burned by `from`.
1117      * - `from` and `to` are never both zero.
1118      */
1119     function _afterTokenTransfers(
1120         address from,
1121         address to,
1122         uint256 startTokenId,
1123         uint256 quantity
1124     ) internal virtual {}
1125 
1126     /**
1127      * @dev Returns the message sender (defaults to `msg.sender`).
1128      *
1129      * If you are writing GSN compatible contracts, you need to override this function.
1130      */
1131     function _msgSenderERC721A() internal view virtual returns (address) {
1132         return msg.sender;
1133     }
1134 
1135     /**
1136      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1137      */
1138     function _toString(uint256 value) internal pure returns (string memory ptr) {
1139         assembly {
1140             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1141             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1142             // We will need 1 32-byte word to store the length, 
1143             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1144             ptr := add(mload(0x40), 128)
1145             // Update the free memory pointer to allocate.
1146             mstore(0x40, ptr)
1147 
1148             // Cache the end of the memory to calculate the length later.
1149             let end := ptr
1150 
1151             // We write the string from the rightmost digit to the leftmost digit.
1152             // The following is essentially a do-while loop that also handles the zero case.
1153             // Costs a bit more than early returning for the zero case,
1154             // but cheaper in terms of deployment and overall runtime costs.
1155             for { 
1156                 // Initialize and perform the first pass without check.
1157                 let temp := value
1158                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1159                 ptr := sub(ptr, 1)
1160                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1161                 mstore8(ptr, add(48, mod(temp, 10)))
1162                 temp := div(temp, 10)
1163             } temp { 
1164                 // Keep dividing `temp` until zero.
1165                 temp := div(temp, 10)
1166             } { // Body of the for loop.
1167                 ptr := sub(ptr, 1)
1168                 mstore8(ptr, add(48, mod(temp, 10)))
1169             }
1170             
1171             let length := sub(end, ptr)
1172             // Move the pointer 32 bytes leftwards to make room for the length.
1173             ptr := sub(ptr, 32)
1174             // Store the length.
1175             mstore(ptr, length)
1176         }
1177     }
1178 }
1179 
1180 // File: @openzeppelin/contracts/utils/Context.sol
1181 
1182 
1183 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1184 
1185 pragma solidity ^0.8.0;
1186 
1187 /**
1188  * @dev Provides information about the current execution context, including the
1189  * sender of the transaction and its data. While these are generally available
1190  * via msg.sender and msg.data, they should not be accessed in such a direct
1191  * manner, since when dealing with meta-transactions the account sending and
1192  * paying for execution may not be the actual sender (as far as an application
1193  * is concerned).
1194  *
1195  * This contract is only required for intermediate, library-like contracts.
1196  */
1197 abstract contract Context {
1198     function _msgSender() internal view virtual returns (address) {
1199         return msg.sender;
1200     }
1201 
1202     function _msgData() internal view virtual returns (bytes calldata) {
1203         return msg.data;
1204     }
1205 }
1206 
1207 // File: @openzeppelin/contracts/access/Ownable.sol
1208 
1209 
1210 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1211 
1212 pragma solidity ^0.8.0;
1213 
1214 
1215 /**
1216  * @dev Contract module which provides a basic access control mechanism, where
1217  * there is an account (an owner) that can be granted exclusive access to
1218  * specific functions.
1219  *
1220  * By default, the owner account will be the one that deploys the contract. This
1221  * can later be changed with {transferOwnership}.
1222  *
1223  * This module is used through inheritance. It will make available the modifier
1224  * `onlyOwner`, which can be applied to your functions to restrict their use to
1225  * the owner.
1226  */
1227 abstract contract Ownable is Context {
1228     address private _owner;
1229 
1230     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1231 
1232     /**
1233      * @dev Initializes the contract setting the deployer as the initial owner.
1234      */
1235     constructor() {
1236         _transferOwnership(_msgSender());
1237     }
1238 
1239     /**
1240      * @dev Returns the address of the current owner.
1241      */
1242     function owner() public view virtual returns (address) {
1243         return _owner;
1244     }
1245 
1246     /**
1247      * @dev Throws if called by any account other than the owner.
1248      */
1249     modifier onlyOwner() {
1250         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1251         _;
1252     }
1253 
1254     /**
1255      * @dev Leaves the contract without owner. It will not be possible to call
1256      * `onlyOwner` functions anymore. Can only be called by the current owner.
1257      *
1258      * NOTE: Renouncing ownership will leave the contract without an owner,
1259      * thereby removing any functionality that is only available to the owner.
1260      */
1261     function renounceOwnership() public virtual onlyOwner {
1262         _transferOwnership(address(0));
1263     }
1264 
1265     /**
1266      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1267      * Can only be called by the current owner.
1268      */
1269     function transferOwnership(address newOwner) public virtual onlyOwner {
1270         require(newOwner != address(0), "Ownable: new owner is the zero address");
1271         _transferOwnership(newOwner);
1272     }
1273 
1274     /**
1275      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1276      * Internal function without access restriction.
1277      */
1278     function _transferOwnership(address newOwner) internal virtual {
1279         address oldOwner = _owner;
1280         _owner = newOwner;
1281         emit OwnershipTransferred(oldOwner, newOwner);
1282     }
1283 }
1284 
1285 // File: contracts/lovelypop.sol
1286 
1287 
1288 pragma solidity >= 0.8.9 < 0.9.0;
1289 
1290 
1291 
1292 
1293 error AddressNotAllowlistVerified();
1294 
1295 contract Lovelypop is Ownable, ERC721A {
1296     uint256 public immutable maxPerAddressDuringMint;
1297     uint256 public immutable collectionSize;
1298     uint256 public immutable amountForDevs;
1299 
1300     struct SaleConfig {
1301         uint32 publicSaleStartTime;
1302         uint64 publicPriceWei;
1303     }
1304 
1305 
1306     SaleConfig public saleConfig;
1307 
1308     // metadata URI
1309     string private _baseTokenURI;
1310 
1311     constructor(
1312         uint256 maxBatchSize_,
1313         uint256 collectionSize_,
1314         uint256 amountForDevs_
1315     ) ERC721A("Lovelypop", "LP") {
1316         require(
1317             maxBatchSize_ < collectionSize_,
1318             "MaxBarchSize should be smaller than collectionSize"
1319         );
1320         maxPerAddressDuringMint = maxBatchSize_;
1321         collectionSize = collectionSize_;
1322         amountForDevs = amountForDevs_;
1323     }
1324 
1325     modifier callerIsUser() {
1326         require(tx.origin == msg.sender, "The caller is another contract");
1327         _;
1328     }
1329 
1330     function devMint(uint256 quantity) external onlyOwner {
1331         require(
1332             quantity <= amountForDevs,
1333             "Too many already minted before dev mint"
1334         );
1335         require(
1336             totalSupply() + quantity <= collectionSize,
1337             "Reached max supply"
1338         );
1339         _safeMint(msg.sender, quantity);
1340     }
1341     // Public Mint
1342     // *****************************************************************************
1343     // Public Functions
1344     function mint(uint256 quantity)
1345     external
1346     payable
1347     callerIsUser
1348     {
1349         require(isPublicSaleOn(), "Public sale has not begun yet");
1350         require(
1351             totalSupply() + quantity <= collectionSize,
1352             "Reached max supply"
1353         );
1354         require(
1355             numberMinted(msg.sender) + quantity <= maxPerAddressDuringMint,
1356             "Reached max quantity that one wallet can mint"
1357         );
1358 
1359         uint256 minted = numberMinted(msg.sender);
1360         uint256 priceWei;
1361         if (minted > 0) {
1362             priceWei = quantity * saleConfig.publicPriceWei;
1363         } else {
1364             priceWei = (quantity - 1) * saleConfig.publicPriceWei;
1365         }
1366         require(msg.value >= priceWei, "Insufficient funds");
1367 
1368         _safeMint(msg.sender, quantity);
1369         refundIfOver(priceWei);
1370     }
1371 
1372     function isPublicSaleOn() public view returns(bool) {
1373         require(
1374             saleConfig.publicSaleStartTime != 0,
1375             "Public Sale Time is TBD."
1376         );
1377 
1378         return block.timestamp >= saleConfig.publicSaleStartTime;
1379     }
1380 
1381     // Owner Controls
1382 
1383     // Public Views
1384     // *****************************************************************************
1385     function numberMinted(address minter) public view returns(uint256) {
1386         return _numberMinted(minter);
1387     }
1388 
1389     // Contract Controls (onlyOwner)
1390     // *****************************************************************************
1391     function setBaseURI(string calldata baseURI) external onlyOwner {
1392         _baseTokenURI = baseURI;
1393     }
1394 
1395     function withdrawMoney() external onlyOwner {
1396         (bool success, ) = msg.sender.call{ value: address(this).balance } ("");
1397         require(success, "Transfer failed.");
1398     }
1399 
1400     function setupSaleInfo(
1401         uint64 publicPriceWei,
1402         uint32 publicSaleStartTime
1403     ) public onlyOwner {
1404         saleConfig = SaleConfig(
1405             publicSaleStartTime,
1406             publicPriceWei
1407         );
1408     }
1409 
1410     // Internal Functions
1411     // *****************************************************************************
1412 
1413     function refundIfOver(uint256 price) internal {
1414         require(msg.value >= price, "Need to send more ETH.");
1415         if (msg.value > price) {
1416             payable(msg.sender).transfer(msg.value - price);
1417         }
1418     }
1419 
1420     function _baseURI() internal view virtual override returns(string memory) {
1421         return _baseTokenURI;
1422     }
1423 
1424     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1425         require(_exists(_tokenId), "Token does not exist.");
1426         return bytes(_baseTokenURI).length > 0 ? string(
1427             abi.encodePacked(
1428               _baseTokenURI,
1429               Strings.toString(_tokenId),
1430               ".json"
1431             )
1432         ) : "";
1433     }
1434 }