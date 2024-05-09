1 // SPDX-License-Identifier: MIT
2 
3 //╭━━━┳╮╱╱╱╱╱╱╱╱╱╭━━━╮╱╱╱╱╱╭╮╱╱╭╮╱╱╭╮╱╱╱╱╭╮╱╭╮╱╭━━━┳╮╱╱╱╭╮
4 //┃╭━╮┃┃╱╱╱╱╱╱╱╱╱╰╮╭╮┃╱╱╱╱╱┃┃╱╱┃╰╮╭╯┃╱╱╱╱┃┃╭╯╰╮┃╭━╮┃┃╱╱╱┃┃
5 //┃┃╱┃┃┃╭┳━━┳╮╱╭╮╱┃┃┃┣╮╭┳━━┫┃╭╮╰╮╰╯╭┻━┳━━┫╰┻╮╭╯┃┃╱╰┫┃╭╮╭┫╰━╮
6 //┃┃╱┃┃╰╯┫╭╮┃┃╱┃┃╱┃┃┃┃┃┃┃╭━┫╰╯╯╱╰╮╭┫╭╮┃╭━┫╭╮┃┃╱┃┃╱╭┫┃┃┃┃┃╭╮┃
7 //┃╰━╯┃╭╮┫╭╮┃╰━╯┃╭╯╰╯┃╰╯┃╰━┫╭╮╮╱╱┃┃┃╭╮┃╰━┫┃┃┃╰╮┃╰━╯┃╰┫╰╯┃╰╯┃
8 //╰━━━┻╯╰┻╯╰┻━╮╭╯╰━━━┻━━┻━━┻╯╰╯╱╱╰╯╰╯╰┻━━┻╯╰┻━╯╰━━━┻━┻━━┻━━╯
9 //╱╱╱╱╱╱╱╱╱╱╭━╯┃///////////////////////////////////////////
10 //╱╱╱╱╱╱╱╱╱╱╰━━╯///////////////////////////////////////////
11 
12 
13 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/IERC721A.sol
14 
15 
16 // ERC721A Contracts v3.3.0
17 // Creator: Chiru Labs
18 
19 pragma solidity ^0.8.4;
20 
21 /**
22  * @dev Interface of an ERC721A compliant contract.
23  */
24 interface IERC721A {
25     /**
26      * The caller must own the token or be an approved operator.
27      */
28     error ApprovalCallerNotOwnerNorApproved();
29 
30     /**
31      * The token does not exist.
32      */
33     error ApprovalQueryForNonexistentToken();
34 
35     /**
36      * The caller cannot approve to their own address.
37      */
38     error ApproveToCaller();
39 
40     /**
41      * The caller cannot approve to the current owner.
42      */
43     error ApprovalToCurrentOwner();
44 
45     /**
46      * Cannot query the balance for the zero address.
47      */
48     error BalanceQueryForZeroAddress();
49 
50     /**
51      * Cannot mint to the zero address.
52      */
53     error MintToZeroAddress();
54 
55     /**
56      * The quantity of tokens minted must be more than zero.
57      */
58     error MintZeroQuantity();
59 
60     /**
61      * The token does not exist.
62      */
63     error OwnerQueryForNonexistentToken();
64 
65     /**
66      * The caller must own the token or be an approved operator.
67      */
68     error TransferCallerNotOwnerNorApproved();
69 
70     /**
71      * The token must be owned by `from`.
72      */
73     error TransferFromIncorrectOwner();
74 
75     /**
76      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
77      */
78     error TransferToNonERC721ReceiverImplementer();
79 
80     /**
81      * Cannot transfer to the zero address.
82      */
83     error TransferToZeroAddress();
84 
85     /**
86      * The token does not exist.
87      */
88     error URIQueryForNonexistentToken();
89 
90     struct TokenOwnership {
91         // The address of the owner.
92         address addr;
93         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
94         uint64 startTimestamp;
95         // Whether the token has been burned.
96         bool burned;
97     }
98 
99     /**
100      * @dev Returns the total amount of tokens stored by the contract.
101      *
102      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
103      */
104     function totalSupply() external view returns (uint256);
105 
106     // ==============================
107     //            IERC165
108     // ==============================
109 
110     /**
111      * @dev Returns true if this contract implements the interface defined by
112      * `interfaceId`. See the corresponding
113      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
114      * to learn more about how these ids are created.
115      *
116      * This function call must use less than 30 000 gas.
117      */
118     function supportsInterface(bytes4 interfaceId) external view returns (bool);
119 
120     // ==============================
121     //            IERC721
122     // ==============================
123 
124     /**
125      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
126      */
127     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
128 
129     /**
130      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
131      */
132     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
133 
134     /**
135      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
136      */
137     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
138 
139     /**
140      * @dev Returns the number of tokens in ``owner``'s account.
141      */
142     function balanceOf(address owner) external view returns (uint256 balance);
143 
144     /**
145      * @dev Returns the owner of the `tokenId` token.
146      *
147      * Requirements:
148      *
149      * - `tokenId` must exist.
150      */
151     function ownerOf(uint256 tokenId) external view returns (address owner);
152 
153     /**
154      * @dev Safely transfers `tokenId` token from `from` to `to`.
155      *
156      * Requirements:
157      *
158      * - `from` cannot be the zero address.
159      * - `to` cannot be the zero address.
160      * - `tokenId` token must exist and be owned by `from`.
161      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
162      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
163      *
164      * Emits a {Transfer} event.
165      */
166     function safeTransferFrom(
167         address from,
168         address to,
169         uint256 tokenId,
170         bytes calldata data
171     ) external;
172 
173     /**
174      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
175      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
176      *
177      * Requirements:
178      *
179      * - `from` cannot be the zero address.
180      * - `to` cannot be the zero address.
181      * - `tokenId` token must exist and be owned by `from`.
182      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
183      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
184      *
185      * Emits a {Transfer} event.
186      */
187     function safeTransferFrom(
188         address from,
189         address to,
190         uint256 tokenId
191     ) external;
192 
193     /**
194      * @dev Transfers `tokenId` token from `from` to `to`.
195      *
196      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
197      *
198      * Requirements:
199      *
200      * - `from` cannot be the zero address.
201      * - `to` cannot be the zero address.
202      * - `tokenId` token must be owned by `from`.
203      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
204      *
205      * Emits a {Transfer} event.
206      */
207     function transferFrom(
208         address from,
209         address to,
210         uint256 tokenId
211     ) external;
212 
213     /**
214      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
215      * The approval is cleared when the token is transferred.
216      *
217      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
218      *
219      * Requirements:
220      *
221      * - The caller must own the token or be an approved operator.
222      * - `tokenId` must exist.
223      *
224      * Emits an {Approval} event.
225      */
226     function approve(address to, uint256 tokenId) external;
227 
228     /**
229      * @dev Approve or remove `operator` as an operator for the caller.
230      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
231      *
232      * Requirements:
233      *
234      * - The `operator` cannot be the caller.
235      *
236      * Emits an {ApprovalForAll} event.
237      */
238     function setApprovalForAll(address operator, bool _approved) external;
239 
240     /**
241      * @dev Returns the account approved for `tokenId` token.
242      *
243      * Requirements:
244      *
245      * - `tokenId` must exist.
246      */
247     function getApproved(uint256 tokenId) external view returns (address operator);
248 
249     /**
250      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
251      *
252      * See {setApprovalForAll}
253      */
254     function isApprovedForAll(address owner, address operator) external view returns (bool);
255 
256     // ==============================
257     //        IERC721Metadata
258     // ==============================
259 
260     /**
261      * @dev Returns the token collection name.
262      */
263     function name() external view returns (string memory);
264 
265     /**
266      * @dev Returns the token collection symbol.
267      */
268     function symbol() external view returns (string memory);
269 
270     /**
271      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
272      */
273     function tokenURI(uint256 tokenId) external view returns (string memory);
274 }
275 
276 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol
277 
278 
279 // ERC721A Contracts v3.3.0
280 // Creator: Chiru Labs
281 
282 pragma solidity ^0.8.4;
283 
284 
285 /**
286  * @dev ERC721 token receiver interface.
287  */
288 interface ERC721A__IERC721Receiver {
289     function onERC721Received(
290         address operator,
291         address from,
292         uint256 tokenId,
293         bytes calldata data
294     ) external returns (bytes4);
295 }
296 
297 /**
298  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
299  * the Metadata extension. Built to optimize for lower gas during batch mints.
300  *
301  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
302  *
303  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
304  *
305  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
306  */
307 contract ERC721A is IERC721A {
308     // Mask of an entry in packed address data.
309     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
310 
311     // The bit position of `numberMinted` in packed address data.
312     uint256 private constant BITPOS_NUMBER_MINTED = 64;
313 
314     // The bit position of `numberBurned` in packed address data.
315     uint256 private constant BITPOS_NUMBER_BURNED = 128;
316 
317     // The bit position of `aux` in packed address data.
318     uint256 private constant BITPOS_AUX = 192;
319 
320     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
321     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
322 
323     // The bit position of `startTimestamp` in packed ownership.
324     uint256 private constant BITPOS_START_TIMESTAMP = 160;
325 
326     // The bit mask of the `burned` bit in packed ownership.
327     uint256 private constant BITMASK_BURNED = 1 << 224;
328     
329     // The bit position of the `nextInitialized` bit in packed ownership.
330     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
331 
332     // The bit mask of the `nextInitialized` bit in packed ownership.
333     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
334 
335     // The tokenId of the next token to be minted.
336     uint256 private _currentIndex;
337 
338     // The number of tokens burned.
339     uint256 private _burnCounter;
340 
341     // Token name
342     string private _name;
343 
344     // Token symbol
345     string private _symbol;
346 
347     // Mapping from token ID to ownership details
348     // An empty struct value does not necessarily mean the token is unowned.
349     // See `_packedOwnershipOf` implementation for details.
350     //
351     // Bits Layout:
352     // - [0..159]   `addr`
353     // - [160..223] `startTimestamp`
354     // - [224]      `burned`
355     // - [225]      `nextInitialized`
356     mapping(uint256 => uint256) private _packedOwnerships;
357 
358     // Mapping owner address to address data.
359     //
360     // Bits Layout:
361     // - [0..63]    `balance`
362     // - [64..127]  `numberMinted`
363     // - [128..191] `numberBurned`
364     // - [192..255] `aux`
365     mapping(address => uint256) private _packedAddressData;
366 
367     // Mapping from token ID to approved address.
368     mapping(uint256 => address) private _tokenApprovals;
369 
370     // Mapping from owner to operator approvals
371     mapping(address => mapping(address => bool)) private _operatorApprovals;
372 
373     constructor(string memory name_, string memory symbol_) {
374         _name = name_;
375         _symbol = symbol_;
376         _currentIndex = _startTokenId();
377     }
378 
379     /**
380      * @dev Returns the starting token ID. 
381      * To change the starting token ID, please override this function.
382      */
383     function _startTokenId() internal view virtual returns (uint256) {
384         return 0;
385     }
386 
387     /**
388      * @dev Returns the next token ID to be minted.
389      */
390     function _nextTokenId() internal view returns (uint256) {
391         return _currentIndex;
392     }
393 
394     /**
395      * @dev Returns the total number of tokens in existence.
396      * Burned tokens will reduce the count. 
397      * To get the total number of tokens minted, please see `_totalMinted`.
398      */
399     function totalSupply() public view override returns (uint256) {
400         // Counter underflow is impossible as _burnCounter cannot be incremented
401         // more than `_currentIndex - _startTokenId()` times.
402         unchecked {
403             return _currentIndex - _burnCounter - _startTokenId();
404         }
405     }
406 
407     /**
408      * @dev Returns the total amount of tokens minted in the contract.
409      */
410     function _totalMinted() internal view returns (uint256) {
411         // Counter underflow is impossible as _currentIndex does not decrement,
412         // and it is initialized to `_startTokenId()`
413         unchecked {
414             return _currentIndex - _startTokenId();
415         }
416     }
417 
418     /**
419      * @dev Returns the total number of tokens burned.
420      */
421     function _totalBurned() internal view returns (uint256) {
422         return _burnCounter;
423     }
424 
425     /**
426      * @dev See {IERC165-supportsInterface}.
427      */
428     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
429         // The interface IDs are constants representing the first 4 bytes of the XOR of
430         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
431         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
432         return
433             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
434             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
435             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
436     }
437 
438     /**
439      * @dev See {IERC721-balanceOf}.
440      */
441     function balanceOf(address owner) public view override returns (uint256) {
442         if (owner == address(0)) revert BalanceQueryForZeroAddress();
443         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
444     }
445 
446     /**
447      * Returns the number of tokens minted by `owner`.
448      */
449     function _numberMinted(address owner) internal view returns (uint256) {
450         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
451     }
452 
453     /**
454      * Returns the number of tokens burned by or on behalf of `owner`.
455      */
456     function _numberBurned(address owner) internal view returns (uint256) {
457         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
458     }
459 
460     /**
461      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
462      */
463     function _getAux(address owner) internal view returns (uint64) {
464         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
465     }
466 
467     /**
468      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
469      * If there are multiple variables, please pack them into a uint64.
470      */
471     function _setAux(address owner, uint64 aux) internal {
472         uint256 packed = _packedAddressData[owner];
473         uint256 auxCasted;
474         assembly { // Cast aux without masking.
475             auxCasted := aux
476         }
477         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
478         _packedAddressData[owner] = packed;
479     }
480 
481     /**
482      * Returns the packed ownership data of `tokenId`.
483      */
484     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
485         uint256 curr = tokenId;
486 
487         unchecked {
488             if (_startTokenId() <= curr)
489                 if (curr < _currentIndex) {
490                     uint256 packed = _packedOwnerships[curr];
491                     // If not burned.
492                     if (packed & BITMASK_BURNED == 0) {
493                         // Invariant:
494                         // There will always be an ownership that has an address and is not burned
495                         // before an ownership that does not have an address and is not burned.
496                         // Hence, curr will not underflow.
497                         //
498                         // We can directly compare the packed value.
499                         // If the address is zero, packed is zero.
500                         while (packed == 0) {
501                             packed = _packedOwnerships[--curr];
502                         }
503                         return packed;
504                     }
505                 }
506         }
507         revert OwnerQueryForNonexistentToken();
508     }
509 
510     /**
511      * Returns the unpacked `TokenOwnership` struct from `packed`.
512      */
513     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
514         ownership.addr = address(uint160(packed));
515         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
516         ownership.burned = packed & BITMASK_BURNED != 0;
517     }
518 
519     /**
520      * Returns the unpacked `TokenOwnership` struct at `index`.
521      */
522     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
523         return _unpackedOwnership(_packedOwnerships[index]);
524     }
525 
526     /**
527      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
528      */
529     function _initializeOwnershipAt(uint256 index) internal {
530         if (_packedOwnerships[index] == 0) {
531             _packedOwnerships[index] = _packedOwnershipOf(index);
532         }
533     }
534 
535     /**
536      * Gas spent here starts off proportional to the maximum mint batch size.
537      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
538      */
539     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
540         return _unpackedOwnership(_packedOwnershipOf(tokenId));
541     }
542 
543     /**
544      * @dev See {IERC721-ownerOf}.
545      */
546     function ownerOf(uint256 tokenId) public view override returns (address) {
547         return address(uint160(_packedOwnershipOf(tokenId)));
548     }
549 
550     /**
551      * @dev See {IERC721Metadata-name}.
552      */
553     function name() public view virtual override returns (string memory) {
554         return _name;
555     }
556 
557     /**
558      * @dev See {IERC721Metadata-symbol}.
559      */
560     function symbol() public view virtual override returns (string memory) {
561         return _symbol;
562     }
563 
564     /**
565      * @dev See {IERC721Metadata-tokenURI}.
566      */
567     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
568         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
569 
570         string memory baseURI = _baseURI();
571         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
572     }
573 
574     /**
575      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
576      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
577      * by default, can be overriden in child contracts.
578      */
579     function _baseURI() internal view virtual returns (string memory) {
580         return '';
581     }
582 
583     /**
584      * @dev Casts the address to uint256 without masking.
585      */
586     function _addressToUint256(address value) private pure returns (uint256 result) {
587         assembly {
588             result := value
589         }
590     }
591 
592     /**
593      * @dev Casts the boolean to uint256 without branching.
594      */
595     function _boolToUint256(bool value) private pure returns (uint256 result) {
596         assembly {
597             result := value
598         }
599     }
600 
601     /**
602      * @dev See {IERC721-approve}.
603      */
604     function approve(address to, uint256 tokenId) public override {
605         address owner = address(uint160(_packedOwnershipOf(tokenId)));
606         if (to == owner) revert ApprovalToCurrentOwner();
607 
608         if (_msgSenderERC721A() != owner)
609             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
610                 revert ApprovalCallerNotOwnerNorApproved();
611             }
612 
613         _tokenApprovals[tokenId] = to;
614         emit Approval(owner, to, tokenId);
615     }
616 
617     /**
618      * @dev See {IERC721-getApproved}.
619      */
620     function getApproved(uint256 tokenId) public view override returns (address) {
621         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
622 
623         return _tokenApprovals[tokenId];
624     }
625 
626     /**
627      * @dev See {IERC721-setApprovalForAll}.
628      */
629     function setApprovalForAll(address operator, bool approved) public virtual override {
630         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
631 
632         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
633         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
634     }
635 
636     /**
637      * @dev See {IERC721-isApprovedForAll}.
638      */
639     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
640         return _operatorApprovals[owner][operator];
641     }
642 
643     /**
644      * @dev See {IERC721-transferFrom}.
645      */
646     function transferFrom(
647         address from,
648         address to,
649         uint256 tokenId
650     ) public virtual override {
651         _transfer(from, to, tokenId);
652     }
653 
654     /**
655      * @dev See {IERC721-safeTransferFrom}.
656      */
657     function safeTransferFrom(
658         address from,
659         address to,
660         uint256 tokenId
661     ) public virtual override {
662         safeTransferFrom(from, to, tokenId, '');
663     }
664 
665     /**
666      * @dev See {IERC721-safeTransferFrom}.
667      */
668     function safeTransferFrom(
669         address from,
670         address to,
671         uint256 tokenId,
672         bytes memory _data
673     ) public virtual override {
674         _transfer(from, to, tokenId);
675         if (to.code.length != 0)
676             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
677                 revert TransferToNonERC721ReceiverImplementer();
678             }
679     }
680 
681     /**
682      * @dev Returns whether `tokenId` exists.
683      *
684      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
685      *
686      * Tokens start existing when they are minted (`_mint`),
687      */
688     function _exists(uint256 tokenId) internal view returns (bool) {
689         return
690             _startTokenId() <= tokenId &&
691             tokenId < _currentIndex && // If within bounds,
692             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
693     }
694 
695     /**
696      * @dev Equivalent to `_safeMint(to, quantity, '')`.
697      */
698     function _safeMint(address to, uint256 quantity) internal {
699         _safeMint(to, quantity, '');
700     }
701 
702     /**
703      * @dev Safely mints `quantity` tokens and transfers them to `to`.
704      *
705      * Requirements:
706      *
707      * - If `to` refers to a smart contract, it must implement
708      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
709      * - `quantity` must be greater than 0.
710      *
711      * Emits a {Transfer} event.
712      */
713     function _safeMint(
714         address to,
715         uint256 quantity,
716         bytes memory _data
717     ) internal {
718         uint256 startTokenId = _currentIndex;
719         if (to == address(0)) revert MintToZeroAddress();
720         if (quantity == 0) revert MintZeroQuantity();
721 
722         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
723 
724         // Overflows are incredibly unrealistic.
725         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
726         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
727         unchecked {
728             // Updates:
729             // - `balance += quantity`.
730             // - `numberMinted += quantity`.
731             //
732             // We can directly add to the balance and number minted.
733             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
734 
735             // Updates:
736             // - `address` to the owner.
737             // - `startTimestamp` to the timestamp of minting.
738             // - `burned` to `false`.
739             // - `nextInitialized` to `quantity == 1`.
740             _packedOwnerships[startTokenId] =
741                 _addressToUint256(to) |
742                 (block.timestamp << BITPOS_START_TIMESTAMP) |
743                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
744 
745             uint256 updatedIndex = startTokenId;
746             uint256 end = updatedIndex + quantity;
747 
748             if (to.code.length != 0) {
749                 do {
750                     emit Transfer(address(0), to, updatedIndex);
751                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
752                         revert TransferToNonERC721ReceiverImplementer();
753                     }
754                 } while (updatedIndex < end);
755                 // Reentrancy protection
756                 if (_currentIndex != startTokenId) revert();
757             } else {
758                 do {
759                     emit Transfer(address(0), to, updatedIndex++);
760                 } while (updatedIndex < end);
761             }
762             _currentIndex = updatedIndex;
763         }
764         _afterTokenTransfers(address(0), to, startTokenId, quantity);
765     }
766 
767     /**
768      * @dev Mints `quantity` tokens and transfers them to `to`.
769      *
770      * Requirements:
771      *
772      * - `to` cannot be the zero address.
773      * - `quantity` must be greater than 0.
774      *
775      * Emits a {Transfer} event.
776      */
777     function _mint(address to, uint256 quantity) internal {
778         uint256 startTokenId = _currentIndex;
779         if (to == address(0)) revert MintToZeroAddress();
780         if (quantity == 0) revert MintZeroQuantity();
781 
782         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
783 
784         // Overflows are incredibly unrealistic.
785         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
786         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
787         unchecked {
788             // Updates:
789             // - `balance += quantity`.
790             // - `numberMinted += quantity`.
791             //
792             // We can directly add to the balance and number minted.
793             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
794 
795             // Updates:
796             // - `address` to the owner.
797             // - `startTimestamp` to the timestamp of minting.
798             // - `burned` to `false`.
799             // - `nextInitialized` to `quantity == 1`.
800             _packedOwnerships[startTokenId] =
801                 _addressToUint256(to) |
802                 (block.timestamp << BITPOS_START_TIMESTAMP) |
803                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
804 
805             uint256 updatedIndex = startTokenId;
806             uint256 end = updatedIndex + quantity;
807 
808             do {
809                 emit Transfer(address(0), to, updatedIndex++);
810             } while (updatedIndex < end);
811 
812             _currentIndex = updatedIndex;
813         }
814         _afterTokenTransfers(address(0), to, startTokenId, quantity);
815     }
816 
817     /**
818      * @dev Transfers `tokenId` from `from` to `to`.
819      *
820      * Requirements:
821      *
822      * - `to` cannot be the zero address.
823      * - `tokenId` token must be owned by `from`.
824      *
825      * Emits a {Transfer} event.
826      */
827     function _transfer(
828         address from,
829         address to,
830         uint256 tokenId
831     ) private {
832         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
833 
834         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
835 
836         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
837             isApprovedForAll(from, _msgSenderERC721A()) ||
838             getApproved(tokenId) == _msgSenderERC721A());
839 
840         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
841         if (to == address(0)) revert TransferToZeroAddress();
842 
843         _beforeTokenTransfers(from, to, tokenId, 1);
844 
845         // Clear approvals from the previous owner.
846         delete _tokenApprovals[tokenId];
847 
848         // Underflow of the sender's balance is impossible because we check for
849         // ownership above and the recipient's balance can't realistically overflow.
850         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
851         unchecked {
852             // We can directly increment and decrement the balances.
853             --_packedAddressData[from]; // Updates: `balance -= 1`.
854             ++_packedAddressData[to]; // Updates: `balance += 1`.
855 
856             // Updates:
857             // - `address` to the next owner.
858             // - `startTimestamp` to the timestamp of transfering.
859             // - `burned` to `false`.
860             // - `nextInitialized` to `true`.
861             _packedOwnerships[tokenId] =
862                 _addressToUint256(to) |
863                 (block.timestamp << BITPOS_START_TIMESTAMP) |
864                 BITMASK_NEXT_INITIALIZED;
865 
866             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
867             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
868                 uint256 nextTokenId = tokenId + 1;
869                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
870                 if (_packedOwnerships[nextTokenId] == 0) {
871                     // If the next slot is within bounds.
872                     if (nextTokenId != _currentIndex) {
873                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
874                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
875                     }
876                 }
877             }
878         }
879 
880         emit Transfer(from, to, tokenId);
881         _afterTokenTransfers(from, to, tokenId, 1);
882     }
883 
884     /**
885      * @dev Equivalent to `_burn(tokenId, false)`.
886      */
887     function _burn(uint256 tokenId) internal virtual {
888         _burn(tokenId, false);
889     }
890 
891     /**
892      * @dev Destroys `tokenId`.
893      * The approval is cleared when the token is burned.
894      *
895      * Requirements:
896      *
897      * - `tokenId` must exist.
898      *
899      * Emits a {Transfer} event.
900      */
901     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
902         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
903 
904         address from = address(uint160(prevOwnershipPacked));
905 
906         if (approvalCheck) {
907             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
908                 isApprovedForAll(from, _msgSenderERC721A()) ||
909                 getApproved(tokenId) == _msgSenderERC721A());
910 
911             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
912         }
913 
914         _beforeTokenTransfers(from, address(0), tokenId, 1);
915 
916         // Clear approvals from the previous owner.
917         delete _tokenApprovals[tokenId];
918 
919         // Underflow of the sender's balance is impossible because we check for
920         // ownership above and the recipient's balance can't realistically overflow.
921         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
922         unchecked {
923             // Updates:
924             // - `balance -= 1`.
925             // - `numberBurned += 1`.
926             //
927             // We can directly decrement the balance, and increment the number burned.
928             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
929             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
930 
931             // Updates:
932             // - `address` to the last owner.
933             // - `startTimestamp` to the timestamp of burning.
934             // - `burned` to `true`.
935             // - `nextInitialized` to `true`.
936             _packedOwnerships[tokenId] =
937                 _addressToUint256(from) |
938                 (block.timestamp << BITPOS_START_TIMESTAMP) |
939                 BITMASK_BURNED | 
940                 BITMASK_NEXT_INITIALIZED;
941 
942             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
943             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
944                 uint256 nextTokenId = tokenId + 1;
945                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
946                 if (_packedOwnerships[nextTokenId] == 0) {
947                     // If the next slot is within bounds.
948                     if (nextTokenId != _currentIndex) {
949                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
950                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
951                     }
952                 }
953             }
954         }
955 
956         emit Transfer(from, address(0), tokenId);
957         _afterTokenTransfers(from, address(0), tokenId, 1);
958 
959         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
960         unchecked {
961             _burnCounter++;
962         }
963     }
964 
965     /**
966      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
967      *
968      * @param from address representing the previous owner of the given token ID
969      * @param to target address that will receive the tokens
970      * @param tokenId uint256 ID of the token to be transferred
971      * @param _data bytes optional data to send along with the call
972      * @return bool whether the call correctly returned the expected magic value
973      */
974     function _checkContractOnERC721Received(
975         address from,
976         address to,
977         uint256 tokenId,
978         bytes memory _data
979     ) private returns (bool) {
980         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
981             bytes4 retval
982         ) {
983             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
984         } catch (bytes memory reason) {
985             if (reason.length == 0) {
986                 revert TransferToNonERC721ReceiverImplementer();
987             } else {
988                 assembly {
989                     revert(add(32, reason), mload(reason))
990                 }
991             }
992         }
993     }
994 
995     /**
996      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
997      * And also called before burning one token.
998      *
999      * startTokenId - the first token id to be transferred
1000      * quantity - the amount to be transferred
1001      *
1002      * Calling conditions:
1003      *
1004      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1005      * transferred to `to`.
1006      * - When `from` is zero, `tokenId` will be minted for `to`.
1007      * - When `to` is zero, `tokenId` will be burned by `from`.
1008      * - `from` and `to` are never both zero.
1009      */
1010     function _beforeTokenTransfers(
1011         address from,
1012         address to,
1013         uint256 startTokenId,
1014         uint256 quantity
1015     ) internal virtual {}
1016 
1017     /**
1018      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1019      * minting.
1020      * And also called after one token has been burned.
1021      *
1022      * startTokenId - the first token id to be transferred
1023      * quantity - the amount to be transferred
1024      *
1025      * Calling conditions:
1026      *
1027      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1028      * transferred to `to`.
1029      * - When `from` is zero, `tokenId` has been minted for `to`.
1030      * - When `to` is zero, `tokenId` has been burned by `from`.
1031      * - `from` and `to` are never both zero.
1032      */
1033     function _afterTokenTransfers(
1034         address from,
1035         address to,
1036         uint256 startTokenId,
1037         uint256 quantity
1038     ) internal virtual {}
1039 
1040     /**
1041      * @dev Returns the message sender (defaults to `msg.sender`).
1042      *
1043      * If you are writing GSN compatible contracts, you need to override this function.
1044      */
1045     function _msgSenderERC721A() internal view virtual returns (address) {
1046         return msg.sender;
1047     }
1048 
1049     /**
1050      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1051      */
1052     function _toString(uint256 value) internal pure returns (string memory ptr) {
1053         assembly {
1054             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1055             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1056             // We will need 1 32-byte word to store the length, 
1057             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1058             ptr := add(mload(0x40), 128)
1059             // Update the free memory pointer to allocate.
1060             mstore(0x40, ptr)
1061 
1062             // Cache the end of the memory to calculate the length later.
1063             let end := ptr
1064 
1065             // We write the string from the rightmost digit to the leftmost digit.
1066             // The following is essentially a do-while loop that also handles the zero case.
1067             // Costs a bit more than early returning for the zero case,
1068             // but cheaper in terms of deployment and overall runtime costs.
1069             for { 
1070                 // Initialize and perform the first pass without check.
1071                 let temp := value
1072                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1073                 ptr := sub(ptr, 1)
1074                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1075                 mstore8(ptr, add(48, mod(temp, 10)))
1076                 temp := div(temp, 10)
1077             } temp { 
1078                 // Keep dividing `temp` until zero.
1079                 temp := div(temp, 10)
1080             } { // Body of the for loop.
1081                 ptr := sub(ptr, 1)
1082                 mstore8(ptr, add(48, mod(temp, 10)))
1083             }
1084             
1085             let length := sub(end, ptr)
1086             // Move the pointer 32 bytes leftwards to make room for the length.
1087             ptr := sub(ptr, 32)
1088             // Store the length.
1089             mstore(ptr, length)
1090         }
1091     }
1092 }
1093 
1094 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
1095 
1096 
1097 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
1098 
1099 pragma solidity ^0.8.0;
1100 
1101 /**
1102  * @dev String operations.
1103  */
1104 library Strings {
1105     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1106     uint8 private constant _ADDRESS_LENGTH = 20;
1107 
1108     /**
1109      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1110      */
1111     function toString(uint256 value) internal pure returns (string memory) {
1112         // Inspired by OraclizeAPI's implementation - MIT licence
1113         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1114 
1115         if (value == 0) {
1116             return "0";
1117         }
1118         uint256 temp = value;
1119         uint256 digits;
1120         while (temp != 0) {
1121             digits++;
1122             temp /= 10;
1123         }
1124         bytes memory buffer = new bytes(digits);
1125         while (value != 0) {
1126             digits -= 1;
1127             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1128             value /= 10;
1129         }
1130         return string(buffer);
1131     }
1132 
1133     /**
1134      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1135      */
1136     function toHexString(uint256 value) internal pure returns (string memory) {
1137         if (value == 0) {
1138             return "0x00";
1139         }
1140         uint256 temp = value;
1141         uint256 length = 0;
1142         while (temp != 0) {
1143             length++;
1144             temp >>= 8;
1145         }
1146         return toHexString(value, length);
1147     }
1148 
1149     /**
1150      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1151      */
1152     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1153         bytes memory buffer = new bytes(2 * length + 2);
1154         buffer[0] = "0";
1155         buffer[1] = "x";
1156         for (uint256 i = 2 * length + 1; i > 1; --i) {
1157             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1158             value >>= 4;
1159         }
1160         require(value == 0, "Strings: hex length insufficient");
1161         return string(buffer);
1162     }
1163 
1164     /**
1165      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1166      */
1167     function toHexString(address addr) internal pure returns (string memory) {
1168         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1169     }
1170 }
1171 
1172 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
1173 
1174 
1175 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1176 
1177 pragma solidity ^0.8.0;
1178 
1179 /**
1180  * @dev Provides information about the current execution context, including the
1181  * sender of the transaction and its data. While these are generally available
1182  * via msg.sender and msg.data, they should not be accessed in such a direct
1183  * manner, since when dealing with meta-transactions the account sending and
1184  * paying for execution may not be the actual sender (as far as an application
1185  * is concerned).
1186  *
1187  * This contract is only required for intermediate, library-like contracts.
1188  */
1189 abstract contract Context {
1190     function _msgSender() internal view virtual returns (address) {
1191         return msg.sender;
1192     }
1193 
1194     function _msgData() internal view virtual returns (bytes calldata) {
1195         return msg.data;
1196     }
1197 }
1198 
1199 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
1200 
1201 
1202 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1203 
1204 pragma solidity ^0.8.0;
1205 
1206 
1207 /**
1208  * @dev Contract module which provides a basic access control mechanism, where
1209  * there is an account (an owner) that can be granted exclusive access to
1210  * specific functions.
1211  *
1212  * By default, the owner account will be the one that deploys the contract. This
1213  * can later be changed with {transferOwnership}.
1214  *
1215  * This module is used through inheritance. It will make available the modifier
1216  * `onlyOwner`, which can be applied to your functions to restrict their use to
1217  * the owner.
1218  */
1219 abstract contract Ownable is Context {
1220     address private _owner;
1221 
1222     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1223 
1224     /**
1225      * @dev Initializes the contract setting the deployer as the initial owner.
1226      */
1227     constructor() {
1228         _transferOwnership(_msgSender());
1229     }
1230 
1231     /**
1232      * @dev Returns the address of the current owner.
1233      */
1234     function owner() public view virtual returns (address) {
1235         return _owner;
1236     }
1237 
1238     /**
1239      * @dev Throws if called by any account other than the owner.
1240      */
1241     modifier onlyOwner() {
1242         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1243         _;
1244     }
1245 
1246     /**
1247      * @dev Leaves the contract without owner. It will not be possible to call
1248      * `onlyOwner` functions anymore. Can only be called by the current owner.
1249      *
1250      * NOTE: Renouncing ownership will leave the contract without an owner,
1251      * thereby removing any functionality that is only available to the owner.
1252      */
1253     function renounceOwnership() public virtual onlyOwner {
1254         _transferOwnership(address(0));
1255     }
1256 
1257     /**
1258      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1259      * Can only be called by the current owner.
1260      */
1261     function transferOwnership(address newOwner) public virtual onlyOwner {
1262         require(newOwner != address(0), "Ownable: new owner is the zero address");
1263         _transferOwnership(newOwner);
1264     }
1265 
1266     /**
1267      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1268      * Internal function without access restriction.
1269      */
1270     function _transferOwnership(address newOwner) internal virtual {
1271         address oldOwner = _owner;
1272         _owner = newOwner;
1273         emit OwnershipTransferred(oldOwner, newOwner);
1274     }
1275 }
1276 
1277 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol
1278 
1279 
1280 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
1281 
1282 pragma solidity ^0.8.1;
1283 
1284 /**
1285  * @dev Collection of functions related to the address type
1286  */
1287 library Address {
1288     /**
1289      * @dev Returns true if `account` is a contract.
1290      *
1291      * [IMPORTANT]
1292      * ====
1293      * It is unsafe to assume that an address for which this function returns
1294      * false is an externally-owned account (EOA) and not a contract.
1295      *
1296      * Among others, `isContract` will return false for the following
1297      * types of addresses:
1298      *
1299      *  - an externally-owned account
1300      *  - a contract in construction
1301      *  - an address where a contract will be created
1302      *  - an address where a contract lived, but was destroyed
1303      * ====
1304      *
1305      * [IMPORTANT]
1306      * ====
1307      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1308      *
1309      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1310      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1311      * constructor.
1312      * ====
1313      */
1314     function isContract(address account) internal view returns (bool) {
1315         // This method relies on extcodesize/address.code.length, which returns 0
1316         // for contracts in construction, since the code is only stored at the end
1317         // of the constructor execution.
1318 
1319         return account.code.length > 0;
1320     }
1321 
1322     /**
1323      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1324      * `recipient`, forwarding all available gas and reverting on errors.
1325      *
1326      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1327      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1328      * imposed by `transfer`, making them unable to receive funds via
1329      * `transfer`. {sendValue} removes this limitation.
1330      *
1331      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1332      *
1333      * IMPORTANT: because control is transferred to `recipient`, care must be
1334      * taken to not create reentrancy vulnerabilities. Consider using
1335      * {ReentrancyGuard} or the
1336      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1337      */
1338     function sendValue(address payable recipient, uint256 amount) internal {
1339         require(address(this).balance >= amount, "Address: insufficient balance");
1340 
1341         (bool success, ) = recipient.call{value: amount}("");
1342         require(success, "Address: unable to send value, recipient may have reverted");
1343     }
1344 
1345     /**
1346      * @dev Performs a Solidity function call using a low level `call`. A
1347      * plain `call` is an unsafe replacement for a function call: use this
1348      * function instead.
1349      *
1350      * If `target` reverts with a revert reason, it is bubbled up by this
1351      * function (like regular Solidity function calls).
1352      *
1353      * Returns the raw returned data. To convert to the expected return value,
1354      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1355      *
1356      * Requirements:
1357      *
1358      * - `target` must be a contract.
1359      * - calling `target` with `data` must not revert.
1360      *
1361      * _Available since v3.1._
1362      */
1363     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1364         return functionCall(target, data, "Address: low-level call failed");
1365     }
1366 
1367     /**
1368      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1369      * `errorMessage` as a fallback revert reason when `target` reverts.
1370      *
1371      * _Available since v3.1._
1372      */
1373     function functionCall(
1374         address target,
1375         bytes memory data,
1376         string memory errorMessage
1377     ) internal returns (bytes memory) {
1378         return functionCallWithValue(target, data, 0, errorMessage);
1379     }
1380 
1381     /**
1382      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1383      * but also transferring `value` wei to `target`.
1384      *
1385      * Requirements:
1386      *
1387      * - the calling contract must have an ETH balance of at least `value`.
1388      * - the called Solidity function must be `payable`.
1389      *
1390      * _Available since v3.1._
1391      */
1392     function functionCallWithValue(
1393         address target,
1394         bytes memory data,
1395         uint256 value
1396     ) internal returns (bytes memory) {
1397         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1398     }
1399 
1400     /**
1401      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1402      * with `errorMessage` as a fallback revert reason when `target` reverts.
1403      *
1404      * _Available since v3.1._
1405      */
1406     function functionCallWithValue(
1407         address target,
1408         bytes memory data,
1409         uint256 value,
1410         string memory errorMessage
1411     ) internal returns (bytes memory) {
1412         require(address(this).balance >= value, "Address: insufficient balance for call");
1413         require(isContract(target), "Address: call to non-contract");
1414 
1415         (bool success, bytes memory returndata) = target.call{value: value}(data);
1416         return verifyCallResult(success, returndata, errorMessage);
1417     }
1418 
1419     /**
1420      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1421      * but performing a static call.
1422      *
1423      * _Available since v3.3._
1424      */
1425     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1426         return functionStaticCall(target, data, "Address: low-level static call failed");
1427     }
1428 
1429     /**
1430      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1431      * but performing a static call.
1432      *
1433      * _Available since v3.3._
1434      */
1435     function functionStaticCall(
1436         address target,
1437         bytes memory data,
1438         string memory errorMessage
1439     ) internal view returns (bytes memory) {
1440         require(isContract(target), "Address: static call to non-contract");
1441 
1442         (bool success, bytes memory returndata) = target.staticcall(data);
1443         return verifyCallResult(success, returndata, errorMessage);
1444     }
1445 
1446     /**
1447      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1448      * but performing a delegate call.
1449      *
1450      * _Available since v3.4._
1451      */
1452     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1453         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1454     }
1455 
1456     /**
1457      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1458      * but performing a delegate call.
1459      *
1460      * _Available since v3.4._
1461      */
1462     function functionDelegateCall(
1463         address target,
1464         bytes memory data,
1465         string memory errorMessage
1466     ) internal returns (bytes memory) {
1467         require(isContract(target), "Address: delegate call to non-contract");
1468 
1469         (bool success, bytes memory returndata) = target.delegatecall(data);
1470         return verifyCallResult(success, returndata, errorMessage);
1471     }
1472 
1473     /**
1474      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1475      * revert reason using the provided one.
1476      *
1477      * _Available since v4.3._
1478      */
1479     function verifyCallResult(
1480         bool success,
1481         bytes memory returndata,
1482         string memory errorMessage
1483     ) internal pure returns (bytes memory) {
1484         if (success) {
1485             return returndata;
1486         } else {
1487             // Look for revert reason and bubble it up if present
1488             if (returndata.length > 0) {
1489                 // The easiest way to bubble the revert reason is using memory via assembly
1490 
1491                 assembly {
1492                     let returndata_size := mload(returndata)
1493                     revert(add(32, returndata), returndata_size)
1494                 }
1495             } else {
1496                 revert(errorMessage);
1497             }
1498         }
1499     }
1500 }
1501 
1502 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721Receiver.sol
1503 
1504 
1505 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
1506 
1507 pragma solidity ^0.8.0;
1508 
1509 /**
1510  * @title ERC721 token receiver interface
1511  * @dev Interface for any contract that wants to support safeTransfers
1512  * from ERC721 asset contracts.
1513  */
1514 interface IERC721Receiver {
1515     /**
1516      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1517      * by `operator` from `from`, this function is called.
1518      *
1519      * It must return its Solidity selector to confirm the token transfer.
1520      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1521      *
1522      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
1523      */
1524     function onERC721Received(
1525         address operator,
1526         address from,
1527         uint256 tokenId,
1528         bytes calldata data
1529     ) external returns (bytes4);
1530 }
1531 
1532 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/IERC165.sol
1533 
1534 
1535 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1536 
1537 pragma solidity ^0.8.0;
1538 
1539 /**
1540  * @dev Interface of the ERC165 standard, as defined in the
1541  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1542  *
1543  * Implementers can declare support of contract interfaces, which can then be
1544  * queried by others ({ERC165Checker}).
1545  *
1546  * For an implementation, see {ERC165}.
1547  */
1548 interface IERC165 {
1549     /**
1550      * @dev Returns true if this contract implements the interface defined by
1551      * `interfaceId`. See the corresponding
1552      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1553      * to learn more about how these ids are created.
1554      *
1555      * This function call must use less than 30 000 gas.
1556      */
1557     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1558 }
1559 
1560 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/ERC165.sol
1561 
1562 
1563 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1564 
1565 pragma solidity ^0.8.0;
1566 
1567 
1568 /**
1569  * @dev Implementation of the {IERC165} interface.
1570  *
1571  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1572  * for the additional interface id that will be supported. For example:
1573  *
1574  * ```solidity
1575  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1576  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1577  * }
1578  * ```
1579  *
1580  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1581  */
1582 abstract contract ERC165 is IERC165 {
1583     /**
1584      * @dev See {IERC165-supportsInterface}.
1585      */
1586     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1587         return interfaceId == type(IERC165).interfaceId;
1588     }
1589 }
1590 
1591 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721.sol
1592 
1593 
1594 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
1595 
1596 pragma solidity ^0.8.0;
1597 
1598 
1599 /**
1600  * @dev Required interface of an ERC721 compliant contract.
1601  */
1602 interface IERC721 is IERC165 {
1603     /**
1604      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1605      */
1606     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1607 
1608     /**
1609      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1610      */
1611     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1612 
1613     /**
1614      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1615      */
1616     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1617 
1618     /**
1619      * @dev Returns the number of tokens in ``owner``'s account.
1620      */
1621     function balanceOf(address owner) external view returns (uint256 balance);
1622 
1623     /**
1624      * @dev Returns the owner of the `tokenId` token.
1625      *
1626      * Requirements:
1627      *
1628      * - `tokenId` must exist.
1629      */
1630     function ownerOf(uint256 tokenId) external view returns (address owner);
1631 
1632     /**
1633      * @dev Safely transfers `tokenId` token from `from` to `to`.
1634      *
1635      * Requirements:
1636      *
1637      * - `from` cannot be the zero address.
1638      * - `to` cannot be the zero address.
1639      * - `tokenId` token must exist and be owned by `from`.
1640      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1641      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1642      *
1643      * Emits a {Transfer} event.
1644      */
1645     function safeTransferFrom(
1646         address from,
1647         address to,
1648         uint256 tokenId,
1649         bytes calldata data
1650     ) external;
1651 
1652     /**
1653      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1654      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1655      *
1656      * Requirements:
1657      *
1658      * - `from` cannot be the zero address.
1659      * - `to` cannot be the zero address.
1660      * - `tokenId` token must exist and be owned by `from`.
1661      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1662      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1663      *
1664      * Emits a {Transfer} event.
1665      */
1666     function safeTransferFrom(
1667         address from,
1668         address to,
1669         uint256 tokenId
1670     ) external;
1671 
1672     /**
1673      * @dev Transfers `tokenId` token from `from` to `to`.
1674      *
1675      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1676      *
1677      * Requirements:
1678      *
1679      * - `from` cannot be the zero address.
1680      * - `to` cannot be the zero address.
1681      * - `tokenId` token must be owned by `from`.
1682      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1683      *
1684      * Emits a {Transfer} event.
1685      */
1686     function transferFrom(
1687         address from,
1688         address to,
1689         uint256 tokenId
1690     ) external;
1691 
1692     /**
1693      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1694      * The approval is cleared when the token is transferred.
1695      *
1696      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1697      *
1698      * Requirements:
1699      *
1700      * - The caller must own the token or be an approved operator.
1701      * - `tokenId` must exist.
1702      *
1703      * Emits an {Approval} event.
1704      */
1705     function approve(address to, uint256 tokenId) external;
1706 
1707     /**
1708      * @dev Approve or remove `operator` as an operator for the caller.
1709      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1710      *
1711      * Requirements:
1712      *
1713      * - The `operator` cannot be the caller.
1714      *
1715      * Emits an {ApprovalForAll} event.
1716      */
1717     function setApprovalForAll(address operator, bool _approved) external;
1718 
1719     /**
1720      * @dev Returns the account approved for `tokenId` token.
1721      *
1722      * Requirements:
1723      *
1724      * - `tokenId` must exist.
1725      */
1726     function getApproved(uint256 tokenId) external view returns (address operator);
1727 
1728     /**
1729      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1730      *
1731      * See {setApprovalForAll}
1732      */
1733     function isApprovedForAll(address owner, address operator) external view returns (bool);
1734 }
1735 
1736 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/IERC721Metadata.sol
1737 
1738 
1739 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1740 
1741 pragma solidity ^0.8.0;
1742 
1743 
1744 /**
1745  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1746  * @dev See https://eips.ethereum.org/EIPS/eip-721
1747  */
1748 interface IERC721Metadata is IERC721 {
1749     /**
1750      * @dev Returns the token collection name.
1751      */
1752     function name() external view returns (string memory);
1753 
1754     /**
1755      * @dev Returns the token collection symbol.
1756      */
1757     function symbol() external view returns (string memory);
1758 
1759     /**
1760      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1761      */
1762     function tokenURI(uint256 tokenId) external view returns (string memory);
1763 }
1764 
1765 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol
1766 
1767 
1768 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
1769 
1770 pragma solidity ^0.8.0;
1771 
1772 
1773 
1774 
1775 
1776 
1777 
1778 
1779 /**
1780  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1781  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1782  * {ERC721Enumerable}.
1783  */
1784 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1785     using Address for address;
1786     using Strings for uint256;
1787 
1788     // Token name
1789     string private _name;
1790 
1791     // Token symbol
1792     string private _symbol;
1793 
1794     // Mapping from token ID to owner address
1795     mapping(uint256 => address) private _owners;
1796 
1797     // Mapping owner address to token count
1798     mapping(address => uint256) private _balances;
1799 
1800     // Mapping from token ID to approved address
1801     mapping(uint256 => address) private _tokenApprovals;
1802 
1803     // Mapping from owner to operator approvals
1804     mapping(address => mapping(address => bool)) private _operatorApprovals;
1805 
1806     /**
1807      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1808      */
1809     constructor(string memory name_, string memory symbol_) {
1810         _name = name_;
1811         _symbol = symbol_;
1812     }
1813 
1814     /**
1815      * @dev See {IERC165-supportsInterface}.
1816      */
1817     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1818         return
1819             interfaceId == type(IERC721).interfaceId ||
1820             interfaceId == type(IERC721Metadata).interfaceId ||
1821             super.supportsInterface(interfaceId);
1822     }
1823 
1824     /**
1825      * @dev See {IERC721-balanceOf}.
1826      */
1827     function balanceOf(address owner) public view virtual override returns (uint256) {
1828         require(owner != address(0), "ERC721: address zero is not a valid owner");
1829         return _balances[owner];
1830     }
1831 
1832     /**
1833      * @dev See {IERC721-ownerOf}.
1834      */
1835     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1836         address owner = _owners[tokenId];
1837         require(owner != address(0), "ERC721: owner query for nonexistent token");
1838         return owner;
1839     }
1840 
1841     /**
1842      * @dev See {IERC721Metadata-name}.
1843      */
1844     function name() public view virtual override returns (string memory) {
1845         return _name;
1846     }
1847 
1848     /**
1849      * @dev See {IERC721Metadata-symbol}.
1850      */
1851     function symbol() public view virtual override returns (string memory) {
1852         return _symbol;
1853     }
1854 
1855     /**
1856      * @dev See {IERC721Metadata-tokenURI}.
1857      */
1858     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1859         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1860 
1861         string memory baseURI = _baseURI();
1862         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1863     }
1864 
1865     /**
1866      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1867      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1868      * by default, can be overridden in child contracts.
1869      */
1870     function _baseURI() internal view virtual returns (string memory) {
1871         return "";
1872     }
1873 
1874     /**
1875      * @dev See {IERC721-approve}.
1876      */
1877     function approve(address to, uint256 tokenId) public virtual override {
1878         address owner = ERC721.ownerOf(tokenId);
1879         require(to != owner, "ERC721: approval to current owner");
1880 
1881         require(
1882             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1883             "ERC721: approve caller is not owner nor approved for all"
1884         );
1885 
1886         _approve(to, tokenId);
1887     }
1888 
1889     /**
1890      * @dev See {IERC721-getApproved}.
1891      */
1892     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1893         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1894 
1895         return _tokenApprovals[tokenId];
1896     }
1897 
1898     /**
1899      * @dev See {IERC721-setApprovalForAll}.
1900      */
1901     function setApprovalForAll(address operator, bool approved) public virtual override {
1902         _setApprovalForAll(_msgSender(), operator, approved);
1903     }
1904 
1905     /**
1906      * @dev See {IERC721-isApprovedForAll}.
1907      */
1908     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1909         return _operatorApprovals[owner][operator];
1910     }
1911 
1912     /**
1913      * @dev See {IERC721-transferFrom}.
1914      */
1915     function transferFrom(
1916         address from,
1917         address to,
1918         uint256 tokenId
1919     ) public virtual override {
1920         //solhint-disable-next-line max-line-length
1921         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1922 
1923         _transfer(from, to, tokenId);
1924     }
1925 
1926     /**
1927      * @dev See {IERC721-safeTransferFrom}.
1928      */
1929     function safeTransferFrom(
1930         address from,
1931         address to,
1932         uint256 tokenId
1933     ) public virtual override {
1934         safeTransferFrom(from, to, tokenId, "");
1935     }
1936 
1937     /**
1938      * @dev See {IERC721-safeTransferFrom}.
1939      */
1940     function safeTransferFrom(
1941         address from,
1942         address to,
1943         uint256 tokenId,
1944         bytes memory data
1945     ) public virtual override {
1946         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1947         _safeTransfer(from, to, tokenId, data);
1948     }
1949 
1950     /**
1951      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1952      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1953      *
1954      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1955      *
1956      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1957      * implement alternative mechanisms to perform token transfer, such as signature-based.
1958      *
1959      * Requirements:
1960      *
1961      * - `from` cannot be the zero address.
1962      * - `to` cannot be the zero address.
1963      * - `tokenId` token must exist and be owned by `from`.
1964      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1965      *
1966      * Emits a {Transfer} event.
1967      */
1968     function _safeTransfer(
1969         address from,
1970         address to,
1971         uint256 tokenId,
1972         bytes memory data
1973     ) internal virtual {
1974         _transfer(from, to, tokenId);
1975         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1976     }
1977 
1978     /**
1979      * @dev Returns whether `tokenId` exists.
1980      *
1981      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1982      *
1983      * Tokens start existing when they are minted (`_mint`),
1984      * and stop existing when they are burned (`_burn`).
1985      */
1986     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1987         return _owners[tokenId] != address(0);
1988     }
1989 
1990     /**
1991      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1992      *
1993      * Requirements:
1994      *
1995      * - `tokenId` must exist.
1996      */
1997     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1998         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1999         address owner = ERC721.ownerOf(tokenId);
2000         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
2001     }
2002 
2003     /**
2004      * @dev Safely mints `tokenId` and transfers it to `to`.
2005      *
2006      * Requirements:
2007      *
2008      * - `tokenId` must not exist.
2009      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2010      *
2011      * Emits a {Transfer} event.
2012      */
2013     function _safeMint(address to, uint256 tokenId) internal virtual {
2014         _safeMint(to, tokenId, "");
2015     }
2016 
2017     /**
2018      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
2019      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
2020      */
2021     function _safeMint(
2022         address to,
2023         uint256 tokenId,
2024         bytes memory data
2025     ) internal virtual {
2026         _mint(to, tokenId);
2027         require(
2028             _checkOnERC721Received(address(0), to, tokenId, data),
2029             "ERC721: transfer to non ERC721Receiver implementer"
2030         );
2031     }
2032 
2033     /**
2034      * @dev Mints `tokenId` and transfers it to `to`.
2035      *
2036      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
2037      *
2038      * Requirements:
2039      *
2040      * - `tokenId` must not exist.
2041      * - `to` cannot be the zero address.
2042      *
2043      * Emits a {Transfer} event.
2044      */
2045     function _mint(address to, uint256 tokenId) internal virtual {
2046         require(to != address(0), "ERC721: mint to the zero address");
2047         require(!_exists(tokenId), "ERC721: token already minted");
2048 
2049         _beforeTokenTransfer(address(0), to, tokenId);
2050 
2051         _balances[to] += 1;
2052         _owners[tokenId] = to;
2053 
2054         emit Transfer(address(0), to, tokenId);
2055 
2056         _afterTokenTransfer(address(0), to, tokenId);
2057     }
2058 
2059     /**
2060      * @dev Destroys `tokenId`.
2061      * The approval is cleared when the token is burned.
2062      *
2063      * Requirements:
2064      *
2065      * - `tokenId` must exist.
2066      *
2067      * Emits a {Transfer} event.
2068      */
2069     function _burn(uint256 tokenId) internal virtual {
2070         address owner = ERC721.ownerOf(tokenId);
2071 
2072         _beforeTokenTransfer(owner, address(0), tokenId);
2073 
2074         // Clear approvals
2075         _approve(address(0), tokenId);
2076 
2077         _balances[owner] -= 1;
2078         delete _owners[tokenId];
2079 
2080         emit Transfer(owner, address(0), tokenId);
2081 
2082         _afterTokenTransfer(owner, address(0), tokenId);
2083     }
2084 
2085     /**
2086      * @dev Transfers `tokenId` from `from` to `to`.
2087      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2088      *
2089      * Requirements:
2090      *
2091      * - `to` cannot be the zero address.
2092      * - `tokenId` token must be owned by `from`.
2093      *
2094      * Emits a {Transfer} event.
2095      */
2096     function _transfer(
2097         address from,
2098         address to,
2099         uint256 tokenId
2100     ) internal virtual {
2101         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
2102         require(to != address(0), "ERC721: transfer to the zero address");
2103 
2104         _beforeTokenTransfer(from, to, tokenId);
2105 
2106         // Clear approvals from the previous owner
2107         _approve(address(0), tokenId);
2108 
2109         _balances[from] -= 1;
2110         _balances[to] += 1;
2111         _owners[tokenId] = to;
2112 
2113         emit Transfer(from, to, tokenId);
2114 
2115         _afterTokenTransfer(from, to, tokenId);
2116     }
2117 
2118     /**
2119      * @dev Approve `to` to operate on `tokenId`
2120      *
2121      * Emits an {Approval} event.
2122      */
2123     function _approve(address to, uint256 tokenId) internal virtual {
2124         _tokenApprovals[tokenId] = to;
2125         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
2126     }
2127 
2128     /**
2129      * @dev Approve `operator` to operate on all of `owner` tokens
2130      *
2131      * Emits an {ApprovalForAll} event.
2132      */
2133     function _setApprovalForAll(
2134         address owner,
2135         address operator,
2136         bool approved
2137     ) internal virtual {
2138         require(owner != operator, "ERC721: approve to caller");
2139         _operatorApprovals[owner][operator] = approved;
2140         emit ApprovalForAll(owner, operator, approved);
2141     }
2142 
2143     /**
2144      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2145      * The call is not executed if the target address is not a contract.
2146      *
2147      * @param from address representing the previous owner of the given token ID
2148      * @param to target address that will receive the tokens
2149      * @param tokenId uint256 ID of the token to be transferred
2150      * @param data bytes optional data to send along with the call
2151      * @return bool whether the call correctly returned the expected magic value
2152      */
2153     function _checkOnERC721Received(
2154         address from,
2155         address to,
2156         uint256 tokenId,
2157         bytes memory data
2158     ) private returns (bool) {
2159         if (to.isContract()) {
2160             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
2161                 return retval == IERC721Receiver.onERC721Received.selector;
2162             } catch (bytes memory reason) {
2163                 if (reason.length == 0) {
2164                     revert("ERC721: transfer to non ERC721Receiver implementer");
2165                 } else {
2166                     assembly {
2167                         revert(add(32, reason), mload(reason))
2168                     }
2169                 }
2170             }
2171         } else {
2172             return true;
2173         }
2174     }
2175 
2176     /**
2177      * @dev Hook that is called before any token transfer. This includes minting
2178      * and burning.
2179      *
2180      * Calling conditions:
2181      *
2182      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2183      * transferred to `to`.
2184      * - When `from` is zero, `tokenId` will be minted for `to`.
2185      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2186      * - `from` and `to` are never both zero.
2187      *
2188      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2189      */
2190     function _beforeTokenTransfer(
2191         address from,
2192         address to,
2193         uint256 tokenId
2194     ) internal virtual {}
2195 
2196     /**
2197      * @dev Hook that is called after any transfer of tokens. This includes
2198      * minting and burning.
2199      *
2200      * Calling conditions:
2201      *
2202      * - when `from` and `to` are both non-zero.
2203      * - `from` and `to` are never both zero.
2204      *
2205      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2206      */
2207     function _afterTokenTransfer(
2208         address from,
2209         address to,
2210         uint256 tokenId
2211     ) internal virtual {}
2212 }
2213 
2214 // File: contracts/ODYC.sol
2215 
2216 
2217 pragma solidity ^0.8.0;
2218 
2219 
2220 
2221 
2222 contract ODYC is ERC721A, Ownable {
2223     using Strings for uint256;
2224 
2225     string private baseURI;
2226 
2227     uint256 public price = 0.004 ether;
2228 
2229     uint256 public maxPerTx = 10;
2230 
2231     uint256 public maxFreePerWallet = 2;
2232 
2233     uint256 public totalFree = 500;
2234 
2235     uint256 public maxSupply = 5555;
2236 
2237     bool public mintEnabled = false;
2238 
2239     mapping(address => uint256) private _mintedFreeAmount;
2240 
2241     constructor() ERC721A("Okay Duck Yacht Club", "ODYC") {
2242         _safeMint(msg.sender, 5);
2243         setBaseURI("ipfs://QmUapkBYTtVpahj7gmZiAGDeSmBy5hG4HkUW1yiye1eQNC/");
2244     }
2245 
2246     function mint(uint256 count) external payable {
2247         uint256 cost = price;
2248         bool isFree = ((totalSupply() + count < totalFree + 1) &&
2249             (_mintedFreeAmount[msg.sender] + count <= maxFreePerWallet));
2250 
2251         if (isFree) {
2252             cost = 0;
2253         }
2254 
2255         require(msg.value >= count * cost, "Please send the exact amount.");
2256         require(totalSupply() + count < maxSupply + 1, "No more");
2257         require(mintEnabled, "Minting is not live yet");
2258         require(count < maxPerTx + 1, "Max per TX reached.");
2259 
2260         if (isFree) {
2261             _mintedFreeAmount[msg.sender] += count;
2262         }
2263 
2264         _safeMint(msg.sender, count);
2265     }
2266 
2267     function _baseURI() internal view virtual override returns (string memory) {
2268         return baseURI;
2269     }
2270 
2271     function tokenURI(uint256 tokenId)
2272         public
2273         view
2274         virtual
2275         override
2276         returns (string memory)
2277     {
2278         require(
2279             _exists(tokenId),
2280             "ERC721Metadata: URI query for nonexistent token"
2281         );
2282         return string(abi.encodePacked(baseURI, tokenId.toString(), ".json"));
2283     }
2284 
2285     function setBaseURI(string memory uri) public onlyOwner {
2286         baseURI = uri;
2287     }
2288 
2289     function setFreeAmount(uint256 amount) external onlyOwner {
2290         totalFree = amount;
2291     }
2292 
2293     function setPrice(uint256 _newPrice) external onlyOwner {
2294         price = _newPrice;
2295     }
2296 
2297     function flipSale() external onlyOwner {
2298         mintEnabled = !mintEnabled;
2299     }
2300 
2301     function withdraw() external onlyOwner {
2302         (bool success, ) = payable(msg.sender).call{
2303             value: address(this).balance
2304         }("");
2305         require(success, "Transfer failed.");
2306     }
2307 }