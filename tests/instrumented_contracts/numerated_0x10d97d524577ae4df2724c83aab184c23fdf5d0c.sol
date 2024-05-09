1 /**
2  *Submitted for verification at Etherscan.io on 2022-06-05
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 
8 
9 /* 
10 
11                                                          ,----,                                          
12               ,----..                  ,----..         ,/   .`|  ,----..                            ,--. 
13 ,-.----.     /   /   \      ,---,.    /   /   \      ,`   .'  : /   /   \             .---.       ,--.'| 
14 \    /  \   /   .     :   ,'  .'  \  /   .     :   ;    ;     //   .     :           /. ./|   ,--,:  : | 
15 ;   :    \ .   /   ;.  \,---.' .' | .   /   ;.  \.'___,/    ,'.   /   ;.  \      .--'.  ' ;,`--.'`|  ' : 
16 |   | .\ :.   ;   /  ` ;|   |  |: |.   ;   /  ` ;|    :     |.   ;   /  ` ;     /__./ \ : ||   :  :  | | 
17 .   : |: |;   |  ; \ ; |:   :  :  /;   |  ; \ ; |;    |.';  ;;   |  ; \ ; | .--'.  '   \' .:   |   \ | : 
18 |   |  \ :|   :  | ; | ':   |    ; |   :  | ; | '`----'  |  ||   :  | ; | '/___/ \ |    ' '|   : '  '; | 
19 |   : .  /.   |  ' ' ' :|   :     \.   |  ' ' ' :    '   :  ;.   |  ' ' ' :;   \  \;      :'   ' ;.    ; 
20 ;   | |  \'   ;  \; /  ||   |   . |'   ;  \; /  |    |   |  ''   ;  \; /  | \   ;  `      ||   | | \   | 
21 |   | ;\  \\   \  ',  / '   :  '; | \   \  ',  /     '   :  | \   \  ',  /   .   \    .\  ;'   : |  ; .' 
22 :   ' | \.' ;   :    /  |   |  | ;   ;   :    /      ;   |.'   ;   :    /     \   \   ' \ ||   | '`--'   
23 :   : :-'    \   \ .'   |   :   /     \   \ .'       '---'      \   \ .'       :   '  |--" '   : |       
24 |   |.'       `---`     |   | ,'       `---`                     `---`          \   \ ;    ;   |.'       
25 `---'                   `----'                                                   '---"     '---'         
26                                                                                                          
27 
28 */
29 
30 
31 
32 // File: @openzeppelin/contracts/utils/Strings.sol
33 
34 
35 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
36 
37 pragma solidity ^0.8.0;
38 
39 /**
40  * @dev String operations.
41  */
42 library Strings {
43     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
44 
45     /**
46      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
47      */
48     function toString(uint256 value) internal pure returns (string memory) {
49         // Inspired by OraclizeAPI's implementation - MIT licence
50         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
51 
52         if (value == 0) {
53             return "0";
54         }
55         uint256 temp = value;
56         uint256 digits;
57         while (temp != 0) {
58             digits++;
59             temp /= 10;
60         }
61         bytes memory buffer = new bytes(digits);
62         while (value != 0) {
63             digits -= 1;
64             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
65             value /= 10;
66         }
67         return string(buffer);
68     }
69 
70     /**
71      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
72      */
73     function toHexString(uint256 value) internal pure returns (string memory) {
74         if (value == 0) {
75             return "0x00";
76         }
77         uint256 temp = value;
78         uint256 length = 0;
79         while (temp != 0) {
80             length++;
81             temp >>= 8;
82         }
83         return toHexString(value, length);
84     }
85 
86     /**
87      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
88      */
89     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
90         bytes memory buffer = new bytes(2 * length + 2);
91         buffer[0] = "0";
92         buffer[1] = "x";
93         for (uint256 i = 2 * length + 1; i > 1; --i) {
94             buffer[i] = _HEX_SYMBOLS[value & 0xf];
95             value >>= 4;
96         }
97         require(value == 0, "Strings: hex length insufficient");
98         return string(buffer);
99     }
100 }
101 
102 // File: erc721a/contracts/IERC721A.sol
103 
104 
105 // ERC721A Contracts v4.0.0
106 // Creator: Chiru Labs
107 
108 pragma solidity ^0.8.4;
109 
110 /**
111  * @dev Interface of an ERC721A compliant contract.
112  */
113 interface IERC721A {
114     /**
115      * The caller must own the token or be an approved operator.
116      */
117     error ApprovalCallerNotOwnerNorApproved();
118 
119     /**
120      * The token does not exist.
121      */
122     error ApprovalQueryForNonexistentToken();
123 
124     /**
125      * The caller cannot approve to their own address.
126      */
127     error ApproveToCaller();
128 
129     /**
130      * The caller cannot approve to the current owner.
131      */
132     error ApprovalToCurrentOwner();
133 
134     /**
135      * Cannot query the balance for the zero address.
136      */
137     error BalanceQueryForZeroAddress();
138 
139     /**
140      * Cannot mint to the zero address.
141      */
142     error MintToZeroAddress();
143 
144     /**
145      * The quantity of tokens minted must be more than zero.
146      */
147     error MintZeroQuantity();
148 
149     /**
150      * The token does not exist.
151      */
152     error OwnerQueryForNonexistentToken();
153 
154     /**
155      * The caller must own the token or be an approved operator.
156      */
157     error TransferCallerNotOwnerNorApproved();
158 
159     /**
160      * The token must be owned by `from`.
161      */
162     error TransferFromIncorrectOwner();
163 
164     /**
165      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
166      */
167     error TransferToNonERC721ReceiverImplementer();
168 
169     /**
170      * Cannot transfer to the zero address.
171      */
172     error TransferToZeroAddress();
173 
174     /**
175      * The token does not exist.
176      */
177     error URIQueryForNonexistentToken();
178 
179     struct TokenOwnership {
180         // The address of the owner.
181         address addr;
182         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
183         uint64 startTimestamp;
184         // Whether the token has been burned.
185         bool burned;
186     }
187 
188     /**
189      * @dev Returns the total amount of tokens stored by the contract.
190      *
191      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
192      */
193     function totalSupply() external view returns (uint256);
194 
195     // ==============================
196     //            IERC165
197     // ==============================
198 
199     /**
200      * @dev Returns true if this contract implements the interface defined by
201      * `interfaceId`. See the corresponding
202      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
203      * to learn more about how these ids are created.
204      *
205      * This function call must use less than 30 000 gas.
206      */
207     function supportsInterface(bytes4 interfaceId) external view returns (bool);
208 
209     // ==============================
210     //            IERC721
211     // ==============================
212 
213     /**
214      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
215      */
216     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
217 
218     /**
219      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
220      */
221     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
222 
223     /**
224      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
225      */
226     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
227 
228     /**
229      * @dev Returns the number of tokens in ``owner``'s account.
230      */
231     function balanceOf(address owner) external view returns (uint256 balance);
232 
233     /**
234      * @dev Returns the owner of the `tokenId` token.
235      *
236      * Requirements:
237      *
238      * - `tokenId` must exist.
239      */
240     function ownerOf(uint256 tokenId) external view returns (address owner);
241 
242     /**
243      * @dev Safely transfers `tokenId` token from `from` to `to`.
244      *
245      * Requirements:
246      *
247      * - `from` cannot be the zero address.
248      * - `to` cannot be the zero address.
249      * - `tokenId` token must exist and be owned by `from`.
250      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
251      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
252      *
253      * Emits a {Transfer} event.
254      */
255     function safeTransferFrom(
256         address from,
257         address to,
258         uint256 tokenId,
259         bytes calldata data
260     ) external;
261 
262     /**
263      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
264      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
265      *
266      * Requirements:
267      *
268      * - `from` cannot be the zero address.
269      * - `to` cannot be the zero address.
270      * - `tokenId` token must exist and be owned by `from`.
271      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
272      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
273      *
274      * Emits a {Transfer} event.
275      */
276     function safeTransferFrom(
277         address from,
278         address to,
279         uint256 tokenId
280     ) external;
281 
282     /**
283      * @dev Transfers `tokenId` token from `from` to `to`.
284      *
285      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
286      *
287      * Requirements:
288      *
289      * - `from` cannot be the zero address.
290      * - `to` cannot be the zero address.
291      * - `tokenId` token must be owned by `from`.
292      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
293      *
294      * Emits a {Transfer} event.
295      */
296     function transferFrom(
297         address from,
298         address to,
299         uint256 tokenId
300     ) external;
301 
302     /**
303      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
304      * The approval is cleared when the token is transferred.
305      *
306      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
307      *
308      * Requirements:
309      *
310      * - The caller must own the token or be an approved operator.
311      * - `tokenId` must exist.
312      *
313      * Emits an {Approval} event.
314      */
315     function approve(address to, uint256 tokenId) external;
316 
317     /**
318      * @dev Approve or remove `operator` as an operator for the caller.
319      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
320      *
321      * Requirements:
322      *
323      * - The `operator` cannot be the caller.
324      *
325      * Emits an {ApprovalForAll} event.
326      */
327     function setApprovalForAll(address operator, bool _approved) external;
328 
329     /**
330      * @dev Returns the account approved for `tokenId` token.
331      *
332      * Requirements:
333      *
334      * - `tokenId` must exist.
335      */
336     function getApproved(uint256 tokenId) external view returns (address operator);
337 
338     /**
339      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
340      *
341      * See {setApprovalForAll}
342      */
343     function isApprovedForAll(address owner, address operator) external view returns (bool);
344 
345     // ==============================
346     //        IERC721Metadata
347     // ==============================
348 
349     /**
350      * @dev Returns the token collection name.
351      */
352     function name() external view returns (string memory);
353 
354     /**
355      * @dev Returns the token collection symbol.
356      */
357     function symbol() external view returns (string memory);
358 
359     /**
360      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
361      */
362     function tokenURI(uint256 tokenId) external view returns (string memory);
363 }
364 
365 // File: erc721a/contracts/ERC721A.sol
366 
367 
368 // ERC721A Contracts v4.0.0
369 // Creator: Chiru Labs
370 
371 pragma solidity ^0.8.4;
372 
373 
374 /**
375  * @dev ERC721 token receiver interface.
376  */
377 interface ERC721A__IERC721Receiver {
378     function onERC721Received(
379         address operator,
380         address from,
381         uint256 tokenId,
382         bytes calldata data
383     ) external returns (bytes4);
384 }
385 
386 /**
387  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
388  * the Metadata extension. Built to optimize for lower gas during batch mints.
389  *
390  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
391  *
392  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
393  *
394  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
395  */
396 contract ERC721A is IERC721A {
397     // Mask of an entry in packed address data.
398     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
399 
400     // The bit position of `numberMinted` in packed address data.
401     uint256 private constant BITPOS_NUMBER_MINTED = 64;
402 
403     // The bit position of `numberBurned` in packed address data.
404     uint256 private constant BITPOS_NUMBER_BURNED = 128;
405 
406     // The bit position of `aux` in packed address data.
407     uint256 private constant BITPOS_AUX = 192;
408 
409     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
410     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
411 
412     // The bit position of `startTimestamp` in packed ownership.
413     uint256 private constant BITPOS_START_TIMESTAMP = 160;
414 
415     // The bit mask of the `burned` bit in packed ownership.
416     uint256 private constant BITMASK_BURNED = 1 << 224;
417     
418     // The bit position of the `nextInitialized` bit in packed ownership.
419     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
420 
421     // The bit mask of the `nextInitialized` bit in packed ownership.
422     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
423 
424     // The tokenId of the next token to be minted.
425     uint256 private _currentIndex;
426 
427     // The number of tokens burned.
428     uint256 private _burnCounter;
429 
430     // Token name
431     string private _name;
432 
433     // Token symbol
434     string private _symbol;
435 
436     // Mapping from token ID to ownership details
437     // An empty struct value does not necessarily mean the token is unowned.
438     // See `_packedOwnershipOf` implementation for details.
439     //
440     // Bits Layout:
441     // - [0..159]   `addr`
442     // - [160..223] `startTimestamp`
443     // - [224]      `burned`
444     // - [225]      `nextInitialized`
445     mapping(uint256 => uint256) private _packedOwnerships;
446 
447     // Mapping owner address to address data.
448     //
449     // Bits Layout:
450     // - [0..63]    `balance`
451     // - [64..127]  `numberMinted`
452     // - [128..191] `numberBurned`
453     // - [192..255] `aux`
454     mapping(address => uint256) private _packedAddressData;
455 
456     // Mapping from token ID to approved address.
457     mapping(uint256 => address) private _tokenApprovals;
458 
459     // Mapping from owner to operator approvals
460     mapping(address => mapping(address => bool)) private _operatorApprovals;
461 
462     constructor(string memory name_, string memory symbol_) {
463         _name = name_;
464         _symbol = symbol_;
465         _currentIndex = _startTokenId();
466     }
467 
468     /**
469      * @dev Returns the starting token ID. 
470      * To change the starting token ID, please override this function.
471      */
472     function _startTokenId() internal view virtual returns (uint256) {
473         return 0;
474     }
475 
476     /**
477      * @dev Returns the next token ID to be minted.
478      */
479     function _nextTokenId() internal view returns (uint256) {
480         return _currentIndex;
481     }
482 
483     /**
484      * @dev Returns the total number of tokens in existence.
485      * Burned tokens will reduce the count. 
486      * To get the total number of tokens minted, please see `_totalMinted`.
487      */
488     function totalSupply() public view override returns (uint256) {
489         // Counter underflow is impossible as _burnCounter cannot be incremented
490         // more than `_currentIndex - _startTokenId()` times.
491         unchecked {
492             return _currentIndex - _burnCounter - _startTokenId();
493         }
494     }
495 
496     /**
497      * @dev Returns the total amount of tokens minted in the contract.
498      */
499     function _totalMinted() internal view returns (uint256) {
500         // Counter underflow is impossible as _currentIndex does not decrement,
501         // and it is initialized to `_startTokenId()`
502         unchecked {
503             return _currentIndex - _startTokenId();
504         }
505     }
506 
507     /**
508      * @dev Returns the total number of tokens burned.
509      */
510     function _totalBurned() internal view returns (uint256) {
511         return _burnCounter;
512     }
513 
514     /**
515      * @dev See {IERC165-supportsInterface}.
516      */
517     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
518         // The interface IDs are constants representing the first 4 bytes of the XOR of
519         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
520         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
521         return
522             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
523             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
524             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
525     }
526 
527     /**
528      * @dev See {IERC721-balanceOf}.
529      */
530     function balanceOf(address owner) public view override returns (uint256) {
531         if (owner == address(0)) revert BalanceQueryForZeroAddress();
532         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
533     }
534 
535     /**
536      * Returns the number of tokens minted by `owner`.
537      */
538     function _numberMinted(address owner) internal view returns (uint256) {
539         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
540     }
541 
542     /**
543      * Returns the number of tokens burned by or on behalf of `owner`.
544      */
545     function _numberBurned(address owner) internal view returns (uint256) {
546         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
547     }
548 
549     /**
550      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
551      */
552     function _getAux(address owner) internal view returns (uint64) {
553         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
554     }
555 
556     /**
557      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
558      * If there are multiple variables, please pack them into a uint64.
559      */
560     function _setAux(address owner, uint64 aux) internal {
561         uint256 packed = _packedAddressData[owner];
562         uint256 auxCasted;
563         assembly { // Cast aux without masking.
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
606     }
607 
608     /**
609      * Returns the unpacked `TokenOwnership` struct at `index`.
610      */
611     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
612         return _unpackedOwnership(_packedOwnerships[index]);
613     }
614 
615     /**
616      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
617      */
618     function _initializeOwnershipAt(uint256 index) internal {
619         if (_packedOwnerships[index] == 0) {
620             _packedOwnerships[index] = _packedOwnershipOf(index);
621         }
622     }
623 
624     /**
625      * Gas spent here starts off proportional to the maximum mint batch size.
626      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
627      */
628     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
629         return _unpackedOwnership(_packedOwnershipOf(tokenId));
630     }
631 
632     /**
633      * @dev See {IERC721-ownerOf}.
634      */
635     function ownerOf(uint256 tokenId) public view override returns (address) {
636         return address(uint160(_packedOwnershipOf(tokenId)));
637     }
638 
639     /**
640      * @dev See {IERC721Metadata-name}.
641      */
642     function name() public view virtual override returns (string memory) {
643         return _name;
644     }
645 
646     /**
647      * @dev See {IERC721Metadata-symbol}.
648      */
649     function symbol() public view virtual override returns (string memory) {
650         return _symbol;
651     }
652 
653     /**
654      * @dev See {IERC721Metadata-tokenURI}.
655      */
656     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
657         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
658 
659         string memory baseURI = _baseURI();
660         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
661     }
662 
663     /**
664      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
665      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
666      * by default, can be overriden in child contracts.
667      */
668     function _baseURI() internal view virtual returns (string memory) {
669         return '';
670     }
671 
672     /**
673      * @dev Casts the address to uint256 without masking.
674      */
675     function _addressToUint256(address value) private pure returns (uint256 result) {
676         assembly {
677             result := value
678         }
679     }
680 
681     /**
682      * @dev Casts the boolean to uint256 without branching.
683      */
684     function _boolToUint256(bool value) private pure returns (uint256 result) {
685         assembly {
686             result := value
687         }
688     }
689 
690     /**
691      * @dev See {IERC721-approve}.
692      */
693     function approve(address to, uint256 tokenId) public override {
694         address owner = address(uint160(_packedOwnershipOf(tokenId)));
695         if (to == owner) revert ApprovalToCurrentOwner();
696 
697         if (_msgSenderERC721A() != owner)
698             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
699                 revert ApprovalCallerNotOwnerNorApproved();
700             }
701 
702         _tokenApprovals[tokenId] = to;
703         emit Approval(owner, to, tokenId);
704     }
705 
706     /**
707      * @dev See {IERC721-getApproved}.
708      */
709     function getApproved(uint256 tokenId) public view override returns (address) {
710         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
711 
712         return _tokenApprovals[tokenId];
713     }
714 
715     /**
716      * @dev See {IERC721-setApprovalForAll}.
717      */
718     function setApprovalForAll(address operator, bool approved) public virtual override {
719         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
720 
721         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
722         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
723     }
724 
725     /**
726      * @dev See {IERC721-isApprovedForAll}.
727      */
728     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
729         return _operatorApprovals[owner][operator];
730     }
731 
732     /**
733      * @dev See {IERC721-transferFrom}.
734      */
735     function transferFrom(
736         address from,
737         address to,
738         uint256 tokenId
739     ) public virtual override {
740         _transfer(from, to, tokenId);
741     }
742 
743     /**
744      * @dev See {IERC721-safeTransferFrom}.
745      */
746     function safeTransferFrom(
747         address from,
748         address to,
749         uint256 tokenId
750     ) public virtual override {
751         safeTransferFrom(from, to, tokenId, '');
752     }
753 
754     /**
755      * @dev See {IERC721-safeTransferFrom}.
756      */
757     function safeTransferFrom(
758         address from,
759         address to,
760         uint256 tokenId,
761         bytes memory _data
762     ) public virtual override {
763         _transfer(from, to, tokenId);
764         if (to.code.length != 0)
765             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
766                 revert TransferToNonERC721ReceiverImplementer();
767             }
768     }
769 
770     /**
771      * @dev Returns whether `tokenId` exists.
772      *
773      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
774      *
775      * Tokens start existing when they are minted (`_mint`),
776      */
777     function _exists(uint256 tokenId) internal view returns (bool) {
778         return
779             _startTokenId() <= tokenId &&
780             tokenId < _currentIndex && // If within bounds,
781             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
782     }
783 
784     /**
785      * @dev Equivalent to `_safeMint(to, quantity, '')`.
786      */
787     function _safeMint(address to, uint256 quantity) internal {
788         _safeMint(to, quantity, '');
789     }
790 
791     /**
792      * @dev Safely mints `quantity` tokens and transfers them to `to`.
793      *
794      * Requirements:
795      *
796      * - If `to` refers to a smart contract, it must implement
797      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
798      * - `quantity` must be greater than 0.
799      *
800      * Emits a {Transfer} event.
801      */
802     function _safeMint(
803         address to,
804         uint256 quantity,
805         bytes memory _data
806     ) internal {
807         uint256 startTokenId = _currentIndex;
808         if (to == address(0)) revert MintToZeroAddress();
809         if (quantity == 0) revert MintZeroQuantity();
810 
811         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
812 
813         // Overflows are incredibly unrealistic.
814         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
815         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
816         unchecked {
817             // Updates:
818             // - `balance += quantity`.
819             // - `numberMinted += quantity`.
820             //
821             // We can directly add to the balance and number minted.
822             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
823 
824             // Updates:
825             // - `address` to the owner.
826             // - `startTimestamp` to the timestamp of minting.
827             // - `burned` to `false`.
828             // - `nextInitialized` to `quantity == 1`.
829             _packedOwnerships[startTokenId] =
830                 _addressToUint256(to) |
831                 (block.timestamp << BITPOS_START_TIMESTAMP) |
832                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
833 
834             uint256 updatedIndex = startTokenId;
835             uint256 end = updatedIndex + quantity;
836 
837             if (to.code.length != 0) {
838                 do {
839                     emit Transfer(address(0), to, updatedIndex);
840                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
841                         revert TransferToNonERC721ReceiverImplementer();
842                     }
843                 } while (updatedIndex < end);
844                 // Reentrancy protection
845                 if (_currentIndex != startTokenId) revert();
846             } else {
847                 do {
848                     emit Transfer(address(0), to, updatedIndex++);
849                 } while (updatedIndex < end);
850             }
851             _currentIndex = updatedIndex;
852         }
853         _afterTokenTransfers(address(0), to, startTokenId, quantity);
854     }
855 
856     /**
857      * @dev Mints `quantity` tokens and transfers them to `to`.
858      *
859      * Requirements:
860      *
861      * - `to` cannot be the zero address.
862      * - `quantity` must be greater than 0.
863      *
864      * Emits a {Transfer} event.
865      */
866     function _mint(address to, uint256 quantity) internal {
867         uint256 startTokenId = _currentIndex;
868         if (to == address(0)) revert MintToZeroAddress();
869         if (quantity == 0) revert MintZeroQuantity();
870 
871         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
872 
873         // Overflows are incredibly unrealistic.
874         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
875         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
876         unchecked {
877             // Updates:
878             // - `balance += quantity`.
879             // - `numberMinted += quantity`.
880             //
881             // We can directly add to the balance and number minted.
882             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
883 
884             // Updates:
885             // - `address` to the owner.
886             // - `startTimestamp` to the timestamp of minting.
887             // - `burned` to `false`.
888             // - `nextInitialized` to `quantity == 1`.
889             _packedOwnerships[startTokenId] =
890                 _addressToUint256(to) |
891                 (block.timestamp << BITPOS_START_TIMESTAMP) |
892                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
893 
894             uint256 updatedIndex = startTokenId;
895             uint256 end = updatedIndex + quantity;
896 
897             do {
898                 emit Transfer(address(0), to, updatedIndex++);
899             } while (updatedIndex < end);
900 
901             _currentIndex = updatedIndex;
902         }
903         _afterTokenTransfers(address(0), to, startTokenId, quantity);
904     }
905 
906     /**
907      * @dev Transfers `tokenId` from `from` to `to`.
908      *
909      * Requirements:
910      *
911      * - `to` cannot be the zero address.
912      * - `tokenId` token must be owned by `from`.
913      *
914      * Emits a {Transfer} event.
915      */
916     function _transfer(
917         address from,
918         address to,
919         uint256 tokenId
920     ) private {
921         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
922 
923         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
924 
925         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
926             isApprovedForAll(from, _msgSenderERC721A()) ||
927             getApproved(tokenId) == _msgSenderERC721A());
928 
929         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
930         if (to == address(0)) revert TransferToZeroAddress();
931 
932         _beforeTokenTransfers(from, to, tokenId, 1);
933 
934         // Clear approvals from the previous owner.
935         delete _tokenApprovals[tokenId];
936 
937         // Underflow of the sender's balance is impossible because we check for
938         // ownership above and the recipient's balance can't realistically overflow.
939         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
940         unchecked {
941             // We can directly increment and decrement the balances.
942             --_packedAddressData[from]; // Updates: `balance -= 1`.
943             ++_packedAddressData[to]; // Updates: `balance += 1`.
944 
945             // Updates:
946             // - `address` to the next owner.
947             // - `startTimestamp` to the timestamp of transfering.
948             // - `burned` to `false`.
949             // - `nextInitialized` to `true`.
950             _packedOwnerships[tokenId] =
951                 _addressToUint256(to) |
952                 (block.timestamp << BITPOS_START_TIMESTAMP) |
953                 BITMASK_NEXT_INITIALIZED;
954 
955             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
956             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
957                 uint256 nextTokenId = tokenId + 1;
958                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
959                 if (_packedOwnerships[nextTokenId] == 0) {
960                     // If the next slot is within bounds.
961                     if (nextTokenId != _currentIndex) {
962                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
963                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
964                     }
965                 }
966             }
967         }
968 
969         emit Transfer(from, to, tokenId);
970         _afterTokenTransfers(from, to, tokenId, 1);
971     }
972 
973     /**
974      * @dev Equivalent to `_burn(tokenId, false)`.
975      */
976     function _burn(uint256 tokenId) internal virtual {
977         _burn(tokenId, false);
978     }
979 
980     /**
981      * @dev Destroys `tokenId`.
982      * The approval is cleared when the token is burned.
983      *
984      * Requirements:
985      *
986      * - `tokenId` must exist.
987      *
988      * Emits a {Transfer} event.
989      */
990     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
991         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
992 
993         address from = address(uint160(prevOwnershipPacked));
994 
995         if (approvalCheck) {
996             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
997                 isApprovedForAll(from, _msgSenderERC721A()) ||
998                 getApproved(tokenId) == _msgSenderERC721A());
999 
1000             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1001         }
1002 
1003         _beforeTokenTransfers(from, address(0), tokenId, 1);
1004 
1005         // Clear approvals from the previous owner.
1006         delete _tokenApprovals[tokenId];
1007 
1008         // Underflow of the sender's balance is impossible because we check for
1009         // ownership above and the recipient's balance can't realistically overflow.
1010         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1011         unchecked {
1012             // Updates:
1013             // - `balance -= 1`.
1014             // - `numberBurned += 1`.
1015             //
1016             // We can directly decrement the balance, and increment the number burned.
1017             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1018             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1019 
1020             // Updates:
1021             // - `address` to the last owner.
1022             // - `startTimestamp` to the timestamp of burning.
1023             // - `burned` to `true`.
1024             // - `nextInitialized` to `true`.
1025             _packedOwnerships[tokenId] =
1026                 _addressToUint256(from) |
1027                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1028                 BITMASK_BURNED | 
1029                 BITMASK_NEXT_INITIALIZED;
1030 
1031             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1032             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1033                 uint256 nextTokenId = tokenId + 1;
1034                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1035                 if (_packedOwnerships[nextTokenId] == 0) {
1036                     // If the next slot is within bounds.
1037                     if (nextTokenId != _currentIndex) {
1038                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1039                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1040                     }
1041                 }
1042             }
1043         }
1044 
1045         emit Transfer(from, address(0), tokenId);
1046         _afterTokenTransfers(from, address(0), tokenId, 1);
1047 
1048         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1049         unchecked {
1050             _burnCounter++;
1051         }
1052     }
1053 
1054     /**
1055      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1056      *
1057      * @param from address representing the previous owner of the given token ID
1058      * @param to target address that will receive the tokens
1059      * @param tokenId uint256 ID of the token to be transferred
1060      * @param _data bytes optional data to send along with the call
1061      * @return bool whether the call correctly returned the expected magic value
1062      */
1063     function _checkContractOnERC721Received(
1064         address from,
1065         address to,
1066         uint256 tokenId,
1067         bytes memory _data
1068     ) private returns (bool) {
1069         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1070             bytes4 retval
1071         ) {
1072             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1073         } catch (bytes memory reason) {
1074             if (reason.length == 0) {
1075                 revert TransferToNonERC721ReceiverImplementer();
1076             } else {
1077                 assembly {
1078                     revert(add(32, reason), mload(reason))
1079                 }
1080             }
1081         }
1082     }
1083 
1084     /**
1085      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1086      * And also called before burning one token.
1087      *
1088      * startTokenId - the first token id to be transferred
1089      * quantity - the amount to be transferred
1090      *
1091      * Calling conditions:
1092      *
1093      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1094      * transferred to `to`.
1095      * - When `from` is zero, `tokenId` will be minted for `to`.
1096      * - When `to` is zero, `tokenId` will be burned by `from`.
1097      * - `from` and `to` are never both zero.
1098      */
1099     function _beforeTokenTransfers(
1100         address from,
1101         address to,
1102         uint256 startTokenId,
1103         uint256 quantity
1104     ) internal virtual {}
1105 
1106     /**
1107      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1108      * minting.
1109      * And also called after one token has been burned.
1110      *
1111      * startTokenId - the first token id to be transferred
1112      * quantity - the amount to be transferred
1113      *
1114      * Calling conditions:
1115      *
1116      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1117      * transferred to `to`.
1118      * - When `from` is zero, `tokenId` has been minted for `to`.
1119      * - When `to` is zero, `tokenId` has been burned by `from`.
1120      * - `from` and `to` are never both zero.
1121      */
1122     function _afterTokenTransfers(
1123         address from,
1124         address to,
1125         uint256 startTokenId,
1126         uint256 quantity
1127     ) internal virtual {}
1128 
1129     /**
1130      * @dev Returns the message sender (defaults to `msg.sender`).
1131      *
1132      * If you are writing GSN compatible contracts, you need to override this function.
1133      */
1134     function _msgSenderERC721A() internal view virtual returns (address) {
1135         return msg.sender;
1136     }
1137 
1138     /**
1139      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1140      */
1141     function _toString(uint256 value) internal pure returns (string memory ptr) {
1142         assembly {
1143             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1144             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1145             // We will need 1 32-byte word to store the length, 
1146             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1147             ptr := add(mload(0x40), 128)
1148             // Update the free memory pointer to allocate.
1149             mstore(0x40, ptr)
1150 
1151             // Cache the end of the memory to calculate the length later.
1152             let end := ptr
1153 
1154             // We write the string from the rightmost digit to the leftmost digit.
1155             // The following is essentially a do-while loop that also handles the zero case.
1156             // Costs a bit more than early returning for the zero case,
1157             // but cheaper in terms of deployment and overall runtime costs.
1158             for { 
1159                 // Initialize and perform the first pass without check.
1160                 let temp := value
1161                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1162                 ptr := sub(ptr, 1)
1163                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1164                 mstore8(ptr, add(48, mod(temp, 10)))
1165                 temp := div(temp, 10)
1166             } temp { 
1167                 // Keep dividing `temp` until zero.
1168                 temp := div(temp, 10)
1169             } { // Body of the for loop.
1170                 ptr := sub(ptr, 1)
1171                 mstore8(ptr, add(48, mod(temp, 10)))
1172             }
1173             
1174             let length := sub(end, ptr)
1175             // Move the pointer 32 bytes leftwards to make room for the length.
1176             ptr := sub(ptr, 32)
1177             // Store the length.
1178             mstore(ptr, length)
1179         }
1180     }
1181 }
1182 
1183 // File: @openzeppelin/contracts/utils/Context.sol
1184 
1185 
1186 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1187 
1188 pragma solidity ^0.8.0;
1189 
1190 /**
1191  * @dev Provides information about the current execution context, including the
1192  * sender of the transaction and its data. While these are generally available
1193  * via msg.sender and msg.data, they should not be accessed in such a direct
1194  * manner, since when dealing with meta-transactions the account sending and
1195  * paying for execution may not be the actual sender (as far as an application
1196  * is concerned).
1197  *
1198  * This contract is only required for intermediate, library-like contracts.
1199  */
1200 abstract contract Context {
1201     function _msgSender() internal view virtual returns (address) {
1202         return msg.sender;
1203     }
1204 
1205     function _msgData() internal view virtual returns (bytes calldata) {
1206         return msg.data;
1207     }
1208 }
1209 
1210 // File: @openzeppelin/contracts/access/Ownable.sol
1211 
1212 
1213 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1214 
1215 pragma solidity ^0.8.0;
1216 
1217 
1218 /**
1219  * @dev Contract module which provides a basic access control mechanism, where
1220  * there is an account (an owner) that can be granted exclusive access to
1221  * specific functions.
1222  *
1223  * By default, the owner account will be the one that deploys the contract. This
1224  * can later be changed with {transferOwnership}.
1225  *
1226  * This module is used through inheritance. It will make available the modifier
1227  * `onlyOwner`, which can be applied to your functions to restrict their use to
1228  * the owner.
1229  */
1230 abstract contract Ownable is Context {
1231     address private _owner;
1232 
1233     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1234 
1235     /**
1236      * @dev Initializes the contract setting the deployer as the initial owner.
1237      */
1238     constructor() {
1239         _transferOwnership(_msgSender());
1240     }
1241 
1242     /**
1243      * @dev Returns the address of the current owner.
1244      */
1245     function owner() public view virtual returns (address) {
1246         return _owner;
1247     }
1248 
1249     /**
1250      * @dev Throws if called by any account other than the owner.
1251      */
1252     modifier onlyOwner() {
1253         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1254         _;
1255     }
1256 
1257     /**
1258      * @dev Leaves the contract without owner. It will not be possible to call
1259      * `onlyOwner` functions anymore. Can only be called by the current owner.
1260      *
1261      * NOTE: Renouncing ownership will leave the contract without an owner,
1262      * thereby removing any functionality that is only available to the owner.
1263      */
1264     function renounceOwnership() public virtual onlyOwner {
1265         _transferOwnership(address(0));
1266     }
1267 
1268     /**
1269      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1270      * Can only be called by the current owner.
1271      */
1272     function transferOwnership(address newOwner) public virtual onlyOwner {
1273         require(newOwner != address(0), "Ownable: new owner is the zero address");
1274         _transferOwnership(newOwner);
1275     }
1276 
1277     /**
1278      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1279      * Internal function without access restriction.
1280      */
1281     function _transferOwnership(address newOwner) internal virtual {
1282         address oldOwner = _owner;
1283         _owner = newOwner;
1284         emit OwnershipTransferred(oldOwner, newOwner);
1285     }
1286 }
1287 
1288 // File: contracts/robo.sol
1289 
1290 
1291 pragma solidity 0.8.12;
1292 
1293 
1294 contract ROBOTOWN is ERC721A, Ownable {
1295 
1296 	using Strings for uint256;
1297 	
1298 	uint public constant MAX_TOKENS = 5000;
1299 	
1300 	uint public CURR_MINT_COST = 0.008 ether;
1301 	
1302 	//---- Round based supplies
1303 	string private CURR_ROUND_NAME = "ROBO";
1304 	uint private CURR_ROUND_SUPPLY = MAX_TOKENS;
1305 	uint private maxMintAmount = 8;
1306 	uint private nftPerAddressLimit = 10;
1307     uint private freeMints = 2;
1308 
1309 	bool public hasSaleStarted = true;
1310 	
1311 	string public baseURI;
1312     
1313 
1314 	constructor() ERC721A("robotown", "r.wtf") {
1315 		setBaseURI("ipfs://QmPK1kRYnhqrThmxej2dF67P1boXuhGJ25ac8WPRbG9ZuZ/");
1316 	}
1317 
1318 
1319 	function _baseURI() internal view virtual override returns (string memory) {
1320 		return baseURI;
1321 	}
1322 
1323 	function _startTokenId() internal view virtual override returns (uint256) {
1324 		return 1;
1325 	}
1326 
1327 	function mintNFT(uint _mintAmount) external payable {
1328 		
1329 		require(hasSaleStarted == true, "Sale hasn't started");
1330 		require(_mintAmount > 0, "Need to mint at least 1 NFT");
1331         require(_mintAmount <= CURR_ROUND_SUPPLY, "We're at max supply!");
1332         
1333 		
1334         if(balanceOf(msg.sender) == 0)
1335         {
1336             _mintAmount = freeMints;
1337         }
1338         else
1339         {
1340             require(msg.value >= CURR_MINT_COST * _mintAmount, "Insufficient funds");
1341             require(_mintAmount <= maxMintAmount, "Max mint amount per transaction exceeded");
1342     		require((_mintAmount  + balanceOf(msg.sender)) <= nftPerAddressLimit, "Max NFT per address exceeded");
1343         }
1344 
1345 		CURR_ROUND_SUPPLY -= _mintAmount;
1346 		_safeMint(msg.sender, _mintAmount);
1347 		
1348 	}
1349 
1350 	
1351 	function getInformations() external view returns (string memory, uint, uint, uint, uint,uint,uint, bool,bool)
1352 	{
1353 		return (CURR_ROUND_NAME,CURR_ROUND_SUPPLY,0,CURR_MINT_COST,maxMintAmount,nftPerAddressLimit, totalSupply(), hasSaleStarted,false);
1354 	}
1355 
1356 	function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1357 		require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
1358 
1359 		string memory currentBaseURI = _baseURI();
1360 		return bytes(currentBaseURI).length > 0
1361 			? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), ".json"))
1362 			: '';
1363 	}
1364 
1365 	//only owner functions
1366 
1367     function setFreeMints(uint amount) external onlyOwner {
1368         freeMints = amount;
1369     }
1370 	function setBaseURI(string memory _newBaseURI) public onlyOwner {
1371 		baseURI = _newBaseURI;
1372 	}
1373 
1374 	function Giveaways(uint numTokens, address recipient) public onlyOwner {
1375 		require(numTokens <= CURR_ROUND_SUPPLY, "We're at max supply!");
1376 		CURR_ROUND_SUPPLY -= numTokens;
1377 		_safeMint(recipient, numTokens);
1378 	}
1379 
1380 	function withdraw(uint amount) public onlyOwner {
1381 		require(payable(msg.sender).send(amount));
1382 	}
1383 	
1384 	function setSaleStarted(bool _state) public onlyOwner {
1385 		hasSaleStarted = _state;
1386 	}
1387 }