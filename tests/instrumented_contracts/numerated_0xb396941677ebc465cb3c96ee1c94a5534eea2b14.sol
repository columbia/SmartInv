1 //MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
2 //MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
3 //MMMMMMMWXKKKXWMMWNKKKXNMMMMMMMMMMMMMMWMMMMMMMMMMMWWNK00KKNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
4 //MMMMMW0l,...,l0Kd;'..':kNMMMMMMNxcccclOWMMMMMMMW0oc;'.',':kNMMMMMMMMMMMMMMWX0kk0XKKXNWMMMMMMMMMMMMMM
5 //MMMMWk,.......''........dWMMMMMK:.....oNMMMMMMXo......'....dWMMMMMMMMMMXOo:'...:l,.',:okKWMMMMMMMMMM
6 //MMMMMk..................oNMMMMMK;.....oNMMMMMWd.......'....oNMMMMMMMWKd,.......cl.......'lOWMMMMMMMM
7 //MMMMMk'....,:'...;:.....dWMMMMM0;.....oNMMMMMNl.......''.,oXMMMMMMMWk,.........lo..........oNMMMMMMM
8 //MMMMMk.....oXKkkOXk'....oWMMMMM0,.....oNMMMMMWd.......:OKNWMMMMMMMWx'..........ox'..........oNMMMMMM
9 //MMMMMx.....dWMMMMMk'....dWMMMMM0,.....oNMMMMMMXd'.....cXMMMMMMMMMMK;...........xk'...........xWMMMMM
10 //MMMMWx.....xWMMMMMk'....dWMMMMM0,.....oNMMMMMMMWKdlc,.,oOKNMMMMMMM0;...........xO'...........oNMMMMM
11 //MMMMWd.....dWMMMMMk'....oWMMMMMk'.....oNMMMMMMMMMMMWNO;...;dXMMMMM0;...........xO,...........lNMMMMM
12 //MMMMWd.....xWMMMMMk'....oWMMMMMx......oNMMMMMMMMMMMMMX:.....:0MMMMK:...........oO;...........lNMMMMM
13 //MMMMWo....'kMMMMMMk'....oWMMMMMx......oWMMMMMMMMMMWN0k;......lNMMMWk'..........oO;..........,OWMMMMM
14 //MMMMNl.....kMMMMMMk'....dWMMMMMx......oWMMMMMMMMWOo:.........cXMMMMWk;.........d0:.........;OWMMMMMM
15 //MMMMXc....'OMMMMMMk'....dWMMMMWx......oWMMMMMMMMK:...........oNMMMMMMXx:.......o0:.......'oKMMMMMMMM
16 //MMMMX:....,0MMMMMMk'....xWMMMMMk;'''',xWMMMMMMMMXl'........,dXMMMMMMMMMN0xl:,''o0c....,cxKWMMMMMMMMM
17 //MMMMNklllldXMMMMMMXxolco0MMMMMMWXXXXXXNMMMMMMMMMMNKOoc;;:lxKWMMMMMMMMMMMMMMWNXKNWKkkOKNWMMMMMMMMMMMM
18 //MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
19 //MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
20 
21 // SPDX-License-Identifier: MIT
22 
23 // File: erc721a/contracts/IERC721A.sol
24 
25 // ERC721A Contracts v4.0.0
26 // Creator: Chiru Labs
27 
28 pragma solidity ^0.8.4;
29 
30 /**
31  * @dev Interface of an ERC721A compliant contract.
32  */
33 interface IERC721A {
34     /**
35      * The caller must own the token or be an approved operator.
36      */
37     error ApprovalCallerNotOwnerNorApproved();
38 
39     /**
40      * The token does not exist.
41      */
42     error ApprovalQueryForNonexistentToken();
43 
44     /**
45      * The caller cannot approve to their own address.
46      */
47     error ApproveToCaller();
48 
49     /**
50      * The caller cannot approve to the current owner.
51      */
52     error ApprovalToCurrentOwner();
53 
54     /**
55      * Cannot query the balance for the zero address.
56      */
57     error BalanceQueryForZeroAddress();
58 
59     /**
60      * Cannot mint to the zero address.
61      */
62     error MintToZeroAddress();
63 
64     /**
65      * The quantity of tokens minted must be more than zero.
66      */
67     error MintZeroQuantity();
68 
69     /**
70      * The token does not exist.
71      */
72     error OwnerQueryForNonexistentToken();
73 
74     /**
75      * The caller must own the token or be an approved operator.
76      */
77     error TransferCallerNotOwnerNorApproved();
78 
79     /**
80      * The token must be owned by `from`.
81      */
82     error TransferFromIncorrectOwner();
83 
84     /**
85      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
86      */
87     error TransferToNonERC721ReceiverImplementer();
88 
89     /**
90      * Cannot transfer to the zero address.
91      */
92     error TransferToZeroAddress();
93 
94     /**
95      * The token does not exist.
96      */
97     error URIQueryForNonexistentToken();
98 
99     struct TokenOwnership {
100         // The address of the owner.
101         address addr;
102         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
103         uint64 startTimestamp;
104         // Whether the token has been burned.
105         bool burned;
106     }
107 
108     /**
109      * @dev Returns the total amount of tokens stored by the contract.
110      *
111      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
112      */
113     function totalSupply() external view returns (uint256);
114 
115     // ==============================
116     //            IERC165
117     // ==============================
118 
119     /**
120      * @dev Returns true if this contract implements the interface defined by
121      * `interfaceId`. See the corresponding
122      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
123      * to learn more about how these ids are created.
124      *
125      * This function call must use less than 30 000 gas.
126      */
127     function supportsInterface(bytes4 interfaceId) external view returns (bool);
128 
129     // ==============================
130     //            IERC721
131     // ==============================
132 
133     /**
134      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
135      */
136     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
137 
138     /**
139      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
140      */
141     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
142 
143     /**
144      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
145      */
146     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
147 
148     /**
149      * @dev Returns the number of tokens in ``owner``'s account.
150      */
151     function balanceOf(address owner) external view returns (uint256 balance);
152 
153     /**
154      * @dev Returns the owner of the `tokenId` token.
155      *
156      * Requirements:
157      *
158      * - `tokenId` must exist.
159      */
160     function ownerOf(uint256 tokenId) external view returns (address owner);
161 
162     /**
163      * @dev Safely transfers `tokenId` token from `from` to `to`.
164      *
165      * Requirements:
166      *
167      * - `from` cannot be the zero address.
168      * - `to` cannot be the zero address.
169      * - `tokenId` token must exist and be owned by `from`.
170      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
171      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
172      *
173      * Emits a {Transfer} event.
174      */
175     function safeTransferFrom(
176         address from,
177         address to,
178         uint256 tokenId,
179         bytes calldata data
180     ) external;
181 
182     /**
183      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
184      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
185      *
186      * Requirements:
187      *
188      * - `from` cannot be the zero address.
189      * - `to` cannot be the zero address.
190      * - `tokenId` token must exist and be owned by `from`.
191      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
192      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
193      *
194      * Emits a {Transfer} event.
195      */
196     function safeTransferFrom(
197         address from,
198         address to,
199         uint256 tokenId
200     ) external;
201 
202     /**
203      * @dev Transfers `tokenId` token from `from` to `to`.
204      *
205      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
206      *
207      * Requirements:
208      *
209      * - `from` cannot be the zero address.
210      * - `to` cannot be the zero address.
211      * - `tokenId` token must be owned by `from`.
212      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
213      *
214      * Emits a {Transfer} event.
215      */
216     function transferFrom(
217         address from,
218         address to,
219         uint256 tokenId
220     ) external;
221 
222     /**
223      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
224      * The approval is cleared when the token is transferred.
225      *
226      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
227      *
228      * Requirements:
229      *
230      * - The caller must own the token or be an approved operator.
231      * - `tokenId` must exist.
232      *
233      * Emits an {Approval} event.
234      */
235     function approve(address to, uint256 tokenId) external;
236 
237     /**
238      * @dev Approve or remove `operator` as an operator for the caller.
239      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
240      *
241      * Requirements:
242      *
243      * - The `operator` cannot be the caller.
244      *
245      * Emits an {ApprovalForAll} event.
246      */
247     function setApprovalForAll(address operator, bool _approved) external;
248 
249     /**
250      * @dev Returns the account approved for `tokenId` token.
251      *
252      * Requirements:
253      *
254      * - `tokenId` must exist.
255      */
256     function getApproved(uint256 tokenId) external view returns (address operator);
257 
258     /**
259      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
260      *
261      * See {setApprovalForAll}
262      */
263     function isApprovedForAll(address owner, address operator) external view returns (bool);
264 
265     // ==============================
266     //        IERC721Metadata
267     // ==============================
268 
269     /**
270      * @dev Returns the token collection name.
271      */
272     function name() external view returns (string memory);
273 
274     /**
275      * @dev Returns the token collection symbol.
276      */
277     function symbol() external view returns (string memory);
278 
279     /**
280      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
281      */
282     function tokenURI(uint256 tokenId) external view returns (string memory);
283 }
284 
285 // File: erc721a/contracts/ERC721A.sol
286 
287 
288 // ERC721A Contracts v4.0.0
289 // Creator: Chiru Labs
290 
291 pragma solidity ^0.8.4;
292 
293 
294 /**
295  * @dev ERC721 token receiver interface.
296  */
297 interface ERC721A__IERC721Receiver {
298     function onERC721Received(
299         address operator,
300         address from,
301         uint256 tokenId,
302         bytes calldata data
303     ) external returns (bytes4);
304 }
305 
306 /**
307  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
308  * the Metadata extension. Built to optimize for lower gas during batch mints.
309  *
310  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
311  *
312  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
313  *
314  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
315  */
316 contract ERC721A is IERC721A {
317     // Mask of an entry in packed address data.
318     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
319 
320     // The bit position of `numberMinted` in packed address data.
321     uint256 private constant BITPOS_NUMBER_MINTED = 64;
322 
323     // The bit position of `numberBurned` in packed address data.
324     uint256 private constant BITPOS_NUMBER_BURNED = 128;
325 
326     // The bit position of `aux` in packed address data.
327     uint256 private constant BITPOS_AUX = 192;
328 
329     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
330     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
331 
332     // The bit position of `startTimestamp` in packed ownership.
333     uint256 private constant BITPOS_START_TIMESTAMP = 160;
334 
335     // The bit mask of the `burned` bit in packed ownership.
336     uint256 private constant BITMASK_BURNED = 1 << 224;
337     
338     // The bit position of the `nextInitialized` bit in packed ownership.
339     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
340 
341     // The bit mask of the `nextInitialized` bit in packed ownership.
342     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
343 
344     // The tokenId of the next token to be minted.
345     uint256 private _currentIndex;
346 
347     // The number of tokens burned.
348     uint256 private _burnCounter;
349 
350     // Token name
351     string private _name;
352 
353     // Token symbol
354     string private _symbol;
355 
356     // Mapping from token ID to ownership details
357     // An empty struct value does not necessarily mean the token is unowned.
358     // See `_packedOwnershipOf` implementation for details.
359     //
360     // Bits Layout:
361     // - [0..159]   `addr`
362     // - [160..223] `startTimestamp`
363     // - [224]      `burned`
364     // - [225]      `nextInitialized`
365     mapping(uint256 => uint256) private _packedOwnerships;
366 
367     // Mapping owner address to address data.
368     //
369     // Bits Layout:
370     // - [0..63]    `balance`
371     // - [64..127]  `numberMinted`
372     // - [128..191] `numberBurned`
373     // - [192..255] `aux`
374     mapping(address => uint256) private _packedAddressData;
375 
376     // Mapping from token ID to approved address.
377     mapping(uint256 => address) private _tokenApprovals;
378 
379     // Mapping from owner to operator approvals
380     mapping(address => mapping(address => bool)) private _operatorApprovals;
381 
382     constructor(string memory name_, string memory symbol_) {
383         _name = name_;
384         _symbol = symbol_;
385         _currentIndex = _startTokenId();
386     }
387 
388     /**
389      * @dev Returns the starting token ID. 
390      * To change the starting token ID, please override this function.
391      */
392     function _startTokenId() internal view virtual returns (uint256) {
393         return 1;
394     }
395 
396     /**
397      * @dev Returns the next token ID to be minted.
398      */
399     function _nextTokenId() internal view returns (uint256) {
400         return _currentIndex;
401     }
402 
403     /**
404      * @dev Returns the total number of tokens in existence.
405      * Burned tokens will reduce the count. 
406      * To get the total number of tokens minted, please see `_totalMinted`.
407      */
408     function totalSupply() public view override returns (uint256) {
409         // Counter underflow is impossible as _burnCounter cannot be incremented
410         // more than `_currentIndex - _startTokenId()` times.
411         unchecked {
412             return _currentIndex - _burnCounter - _startTokenId();
413         }
414     }
415 
416     /**
417      * @dev Returns the total amount of tokens minted in the contract.
418      */
419     function _totalMinted() internal view returns (uint256) {
420         // Counter underflow is impossible as _currentIndex does not decrement,
421         // and it is initialized to `_startTokenId()`
422         unchecked {
423             return _currentIndex - _startTokenId();
424         }
425     }
426 
427     /**
428      * @dev Returns the total number of tokens burned.
429      */
430     function _totalBurned() internal view returns (uint256) {
431         return _burnCounter;
432     }
433 
434     /**
435      * @dev See {IERC165-supportsInterface}.
436      */
437     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
438         // The interface IDs are constants representing the first 4 bytes of the XOR of
439         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
440         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
441         return
442             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
443             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
444             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
445     }
446 
447     /**
448      * @dev See {IERC721-balanceOf}.
449      */
450     function balanceOf(address owner) public view override returns (uint256) {
451         if (owner == address(0)) revert BalanceQueryForZeroAddress();
452         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
453     }
454 
455     /**
456      * Returns the number of tokens minted by `owner`.
457      */
458     function _numberMinted(address owner) internal view returns (uint256) {
459         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
460     }
461 
462     /**
463      * Returns the number of tokens burned by or on behalf of `owner`.
464      */
465     function _numberBurned(address owner) internal view returns (uint256) {
466         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
467     }
468 
469     /**
470      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
471      */
472     function _getAux(address owner) internal view returns (uint64) {
473         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
474     }
475 
476     /**
477      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
478      * If there are multiple variables, please pack them into a uint64.
479      */
480     function _setAux(address owner, uint64 aux) internal {
481         uint256 packed = _packedAddressData[owner];
482         uint256 auxCasted;
483         assembly { // Cast aux without masking.
484             auxCasted := aux
485         }
486         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
487         _packedAddressData[owner] = packed;
488     }
489 
490     /**
491      * Returns the packed ownership data of `tokenId`.
492      */
493     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
494         uint256 curr = tokenId;
495 
496         unchecked {
497             if (_startTokenId() <= curr)
498                 if (curr < _currentIndex) {
499                     uint256 packed = _packedOwnerships[curr];
500                     // If not burned.
501                     if (packed & BITMASK_BURNED == 0) {
502                         // Invariant:
503                         // There will always be an ownership that has an address and is not burned
504                         // before an ownership that does not have an address and is not burned.
505                         // Hence, curr will not underflow.
506                         //
507                         // We can directly compare the packed value.
508                         // If the address is zero, packed is zero.
509                         while (packed == 0) {
510                             packed = _packedOwnerships[--curr];
511                         }
512                         return packed;
513                     }
514                 }
515         }
516         revert OwnerQueryForNonexistentToken();
517     }
518 
519     /**
520      * Returns the unpacked `TokenOwnership` struct from `packed`.
521      */
522     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
523         ownership.addr = address(uint160(packed));
524         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
525         ownership.burned = packed & BITMASK_BURNED != 0;
526     }
527 
528     /**
529      * Returns the unpacked `TokenOwnership` struct at `index`.
530      */
531     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
532         return _unpackedOwnership(_packedOwnerships[index]);
533     }
534 
535     /**
536      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
537      */
538     function _initializeOwnershipAt(uint256 index) internal {
539         if (_packedOwnerships[index] == 0) {
540             _packedOwnerships[index] = _packedOwnershipOf(index);
541         }
542     }
543 
544     /**
545      * Gas spent here starts off proportional to the maximum mint batch size.
546      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
547      */
548     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
549         return _unpackedOwnership(_packedOwnershipOf(tokenId));
550     }
551 
552     /**
553      * @dev See {IERC721-ownerOf}.
554      */
555     function ownerOf(uint256 tokenId) public view override returns (address) {
556         return address(uint160(_packedOwnershipOf(tokenId)));
557     }
558 
559     /**
560      * @dev See {IERC721Metadata-name}.
561      */
562     function name() public view virtual override returns (string memory) {
563         return _name;
564     }
565 
566     /**
567      * @dev See {IERC721Metadata-symbol}.
568      */
569     function symbol() public view virtual override returns (string memory) {
570         return _symbol;
571     }
572 
573     /**
574      * @dev See {IERC721Metadata-tokenURI}.
575      */
576     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
577         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
578 
579         string memory baseURI = _baseURI();
580         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
581     }
582 
583     /**
584      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
585      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
586      * by default, can be overriden in child contracts.
587      */
588     function _baseURI() internal view virtual returns (string memory) {
589         return '';
590     }
591 
592     /**
593      * @dev Casts the address to uint256 without masking.
594      */
595     function _addressToUint256(address value) private pure returns (uint256 result) {
596         assembly {
597             result := value
598         }
599     }
600 
601     /**
602      * @dev Casts the boolean to uint256 without branching.
603      */
604     function _boolToUint256(bool value) private pure returns (uint256 result) {
605         assembly {
606             result := value
607         }
608     }
609 
610     /**
611      * @dev See {IERC721-approve}.
612      */
613     function approve(address to, uint256 tokenId) public override {
614         address owner = address(uint160(_packedOwnershipOf(tokenId)));
615         if (to == owner) revert ApprovalToCurrentOwner();
616 
617         if (_msgSenderERC721A() != owner)
618             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
619                 revert ApprovalCallerNotOwnerNorApproved();
620             }
621 
622         _tokenApprovals[tokenId] = to;
623         emit Approval(owner, to, tokenId);
624     }
625 
626     /**
627      * @dev See {IERC721-getApproved}.
628      */
629     function getApproved(uint256 tokenId) public view override returns (address) {
630         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
631 
632         return _tokenApprovals[tokenId];
633     }
634 
635     /**
636      * @dev See {IERC721-setApprovalForAll}.
637      */
638     function setApprovalForAll(address operator, bool approved) public virtual override {
639         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
640 
641         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
642         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
643     }
644 
645     /**
646      * @dev See {IERC721-isApprovedForAll}.
647      */
648     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
649         return _operatorApprovals[owner][operator];
650     }
651 
652     /**
653      * @dev See {IERC721-transferFrom}.
654      */
655     function transferFrom(
656         address from,
657         address to,
658         uint256 tokenId
659     ) public virtual override {
660         _transfer(from, to, tokenId);
661     }
662 
663     /**
664      * @dev See {IERC721-safeTransferFrom}.
665      */
666     function safeTransferFrom(
667         address from,
668         address to,
669         uint256 tokenId
670     ) public virtual override {
671         safeTransferFrom(from, to, tokenId, '');
672     }
673 
674     /**
675      * @dev See {IERC721-safeTransferFrom}.
676      */
677     function safeTransferFrom(
678         address from,
679         address to,
680         uint256 tokenId,
681         bytes memory _data
682     ) public virtual override {
683         _transfer(from, to, tokenId);
684         if (to.code.length != 0)
685             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
686                 revert TransferToNonERC721ReceiverImplementer();
687             }
688     }
689 
690     /**
691      * @dev Returns whether `tokenId` exists.
692      *
693      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
694      *
695      * Tokens start existing when they are minted (`_mint`),
696      */
697     function _exists(uint256 tokenId) internal view returns (bool) {
698         return
699             _startTokenId() <= tokenId &&
700             tokenId < _currentIndex && // If within bounds,
701             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
702     }
703 
704     /**
705      * @dev Equivalent to `_safeMint(to, quantity, '')`.
706      */
707     function _safeMint(address to, uint256 quantity) internal {
708         _safeMint(to, quantity, '');
709     }
710 
711     /**
712      * @dev Safely mints `quantity` tokens and transfers them to `to`.
713      *
714      * Requirements:
715      *
716      * - If `to` refers to a smart contract, it must implement
717      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
718      * - `quantity` must be greater than 0.
719      *
720      * Emits a {Transfer} event.
721      */
722     function _safeMint(
723         address to,
724         uint256 quantity,
725         bytes memory _data
726     ) internal {
727         uint256 startTokenId = _currentIndex;
728         if (to == address(0)) revert MintToZeroAddress();
729         if (quantity == 0) revert MintZeroQuantity();
730 
731         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
732 
733         // Overflows are incredibly unrealistic.
734         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
735         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
736         unchecked {
737             // Updates:
738             // - `balance += quantity`.
739             // - `numberMinted += quantity`.
740             //
741             // We can directly add to the balance and number minted.
742             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
743 
744             // Updates:
745             // - `address` to the owner.
746             // - `startTimestamp` to the timestamp of minting.
747             // - `burned` to `false`.
748             // - `nextInitialized` to `quantity == 1`.
749             _packedOwnerships[startTokenId] =
750                 _addressToUint256(to) |
751                 (block.timestamp << BITPOS_START_TIMESTAMP) |
752                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
753 
754             uint256 updatedIndex = startTokenId;
755             uint256 end = updatedIndex + quantity;
756 
757             if (to.code.length != 0) {
758                 do {
759                     emit Transfer(address(0), to, updatedIndex);
760                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
761                         revert TransferToNonERC721ReceiverImplementer();
762                     }
763                 } while (updatedIndex < end);
764                 // Reentrancy protection
765                 if (_currentIndex != startTokenId) revert();
766             } else {
767                 do {
768                     emit Transfer(address(0), to, updatedIndex++);
769                 } while (updatedIndex < end);
770             }
771             _currentIndex = updatedIndex;
772         }
773         _afterTokenTransfers(address(0), to, startTokenId, quantity);
774     }
775 
776     /**
777      * @dev Mints `quantity` tokens and transfers them to `to`.
778      *
779      * Requirements:
780      *
781      * - `to` cannot be the zero address.
782      * - `quantity` must be greater than 0.
783      *
784      * Emits a {Transfer} event.
785      */
786     function _mint(address to, uint256 quantity) internal {
787         uint256 startTokenId = _currentIndex;
788         if (to == address(0)) revert MintToZeroAddress();
789         if (quantity == 0) revert MintZeroQuantity();
790 
791         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
792 
793         // Overflows are incredibly unrealistic.
794         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
795         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
796         unchecked {
797             // Updates:
798             // - `balance += quantity`.
799             // - `numberMinted += quantity`.
800             //
801             // We can directly add to the balance and number minted.
802             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
803 
804             // Updates:
805             // - `address` to the owner.
806             // - `startTimestamp` to the timestamp of minting.
807             // - `burned` to `false`.
808             // - `nextInitialized` to `quantity == 1`.
809             _packedOwnerships[startTokenId] =
810                 _addressToUint256(to) |
811                 (block.timestamp << BITPOS_START_TIMESTAMP) |
812                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
813 
814             uint256 updatedIndex = startTokenId;
815             uint256 end = updatedIndex + quantity;
816 
817             do {
818                 emit Transfer(address(0), to, updatedIndex++);
819             } while (updatedIndex < end);
820 
821             _currentIndex = updatedIndex;
822         }
823         _afterTokenTransfers(address(0), to, startTokenId, quantity);
824     }
825 
826     /**
827      * @dev Transfers `tokenId` from `from` to `to`.
828      *
829      * Requirements:
830      *
831      * - `to` cannot be the zero address.
832      * - `tokenId` token must be owned by `from`.
833      *
834      * Emits a {Transfer} event.
835      */
836     function _transfer(
837         address from,
838         address to,
839         uint256 tokenId
840     ) private {
841         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
842 
843         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
844 
845         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
846             isApprovedForAll(from, _msgSenderERC721A()) ||
847             getApproved(tokenId) == _msgSenderERC721A());
848 
849         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
850         if (to == address(0)) revert TransferToZeroAddress();
851 
852         _beforeTokenTransfers(from, to, tokenId, 1);
853 
854         // Clear approvals from the previous owner.
855         delete _tokenApprovals[tokenId];
856 
857         // Underflow of the sender's balance is impossible because we check for
858         // ownership above and the recipient's balance can't realistically overflow.
859         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
860         unchecked {
861             // We can directly increment and decrement the balances.
862             --_packedAddressData[from]; // Updates: `balance -= 1`.
863             ++_packedAddressData[to]; // Updates: `balance += 1`.
864 
865             // Updates:
866             // - `address` to the next owner.
867             // - `startTimestamp` to the timestamp of transfering.
868             // - `burned` to `false`.
869             // - `nextInitialized` to `true`.
870             _packedOwnerships[tokenId] =
871                 _addressToUint256(to) |
872                 (block.timestamp << BITPOS_START_TIMESTAMP) |
873                 BITMASK_NEXT_INITIALIZED;
874 
875             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
876             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
877                 uint256 nextTokenId = tokenId + 1;
878                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
879                 if (_packedOwnerships[nextTokenId] == 0) {
880                     // If the next slot is within bounds.
881                     if (nextTokenId != _currentIndex) {
882                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
883                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
884                     }
885                 }
886             }
887         }
888 
889         emit Transfer(from, to, tokenId);
890         _afterTokenTransfers(from, to, tokenId, 1);
891     }
892 
893     /**
894      * @dev Equivalent to `_burn(tokenId, false)`.
895      */
896     function _burn(uint256 tokenId) internal virtual {
897         _burn(tokenId, false);
898     }
899 
900     /**
901      * @dev Destroys `tokenId`.
902      * The approval is cleared when the token is burned.
903      *
904      * Requirements:
905      *
906      * - `tokenId` must exist.
907      *
908      * Emits a {Transfer} event.
909      */
910     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
911         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
912 
913         address from = address(uint160(prevOwnershipPacked));
914 
915         if (approvalCheck) {
916             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
917                 isApprovedForAll(from, _msgSenderERC721A()) ||
918                 getApproved(tokenId) == _msgSenderERC721A());
919 
920             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
921         }
922 
923         _beforeTokenTransfers(from, address(0), tokenId, 1);
924 
925         // Clear approvals from the previous owner.
926         delete _tokenApprovals[tokenId];
927 
928         // Underflow of the sender's balance is impossible because we check for
929         // ownership above and the recipient's balance can't realistically overflow.
930         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
931         unchecked {
932             // Updates:
933             // - `balance -= 1`.
934             // - `numberBurned += 1`.
935             //
936             // We can directly decrement the balance, and increment the number burned.
937             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
938             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
939 
940             // Updates:
941             // - `address` to the last owner.
942             // - `startTimestamp` to the timestamp of burning.
943             // - `burned` to `true`.
944             // - `nextInitialized` to `true`.
945             _packedOwnerships[tokenId] =
946                 _addressToUint256(from) |
947                 (block.timestamp << BITPOS_START_TIMESTAMP) |
948                 BITMASK_BURNED | 
949                 BITMASK_NEXT_INITIALIZED;
950 
951             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
952             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
953                 uint256 nextTokenId = tokenId + 1;
954                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
955                 if (_packedOwnerships[nextTokenId] == 0) {
956                     // If the next slot is within bounds.
957                     if (nextTokenId != _currentIndex) {
958                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
959                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
960                     }
961                 }
962             }
963         }
964 
965         emit Transfer(from, address(0), tokenId);
966         _afterTokenTransfers(from, address(0), tokenId, 1);
967 
968         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
969         unchecked {
970             _burnCounter++;
971         }
972     }
973 
974     /**
975      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
976      *
977      * @param from address representing the previous owner of the given token ID
978      * @param to target address that will receive the tokens
979      * @param tokenId uint256 ID of the token to be transferred
980      * @param _data bytes optional data to send along with the call
981      * @return bool whether the call correctly returned the expected magic value
982      */
983     function _checkContractOnERC721Received(
984         address from,
985         address to,
986         uint256 tokenId,
987         bytes memory _data
988     ) private returns (bool) {
989         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
990             bytes4 retval
991         ) {
992             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
993         } catch (bytes memory reason) {
994             if (reason.length == 0) {
995                 revert TransferToNonERC721ReceiverImplementer();
996             } else {
997                 assembly {
998                     revert(add(32, reason), mload(reason))
999                 }
1000             }
1001         }
1002     }
1003 
1004     /**
1005      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1006      * And also called before burning one token.
1007      *
1008      * startTokenId - the first token id to be transferred
1009      * quantity - the amount to be transferred
1010      *
1011      * Calling conditions:
1012      *
1013      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1014      * transferred to `to`.
1015      * - When `from` is zero, `tokenId` will be minted for `to`.
1016      * - When `to` is zero, `tokenId` will be burned by `from`.
1017      * - `from` and `to` are never both zero.
1018      */
1019     function _beforeTokenTransfers(
1020         address from,
1021         address to,
1022         uint256 startTokenId,
1023         uint256 quantity
1024     ) internal virtual {}
1025 
1026     /**
1027      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1028      * minting.
1029      * And also called after one token has been burned.
1030      *
1031      * startTokenId - the first token id to be transferred
1032      * quantity - the amount to be transferred
1033      *
1034      * Calling conditions:
1035      *
1036      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1037      * transferred to `to`.
1038      * - When `from` is zero, `tokenId` has been minted for `to`.
1039      * - When `to` is zero, `tokenId` has been burned by `from`.
1040      * - `from` and `to` are never both zero.
1041      */
1042     function _afterTokenTransfers(
1043         address from,
1044         address to,
1045         uint256 startTokenId,
1046         uint256 quantity
1047     ) internal virtual {}
1048 
1049     /**
1050      * @dev Returns the message sender (defaults to `msg.sender`).
1051      *
1052      * If you are writing GSN compatible contracts, you need to override this function.
1053      */
1054     function _msgSenderERC721A() internal view virtual returns (address) {
1055         return msg.sender;
1056     }
1057 
1058     /**
1059      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1060      */
1061     function _toString(uint256 value) internal pure returns (string memory ptr) {
1062         assembly {
1063             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1064             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1065             // We will need 1 32-byte word to store the length, 
1066             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1067             ptr := add(mload(0x40), 128)
1068             // Update the free memory pointer to allocate.
1069             mstore(0x40, ptr)
1070 
1071             // Cache the end of the memory to calculate the length later.
1072             let end := ptr
1073 
1074             // We write the string from the rightmost digit to the leftmost digit.
1075             // The following is essentially a do-while loop that also handles the zero case.
1076             // Costs a bit more than early returning for the zero case,
1077             // but cheaper in terms of deployment and overall runtime costs.
1078             for { 
1079                 // Initialize and perform the first pass without check.
1080                 let temp := value
1081                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1082                 ptr := sub(ptr, 1)
1083                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1084                 mstore8(ptr, add(48, mod(temp, 10)))
1085                 temp := div(temp, 10)
1086             } temp { 
1087                 // Keep dividing `temp` until zero.
1088                 temp := div(temp, 10)
1089             } { // Body of the for loop.
1090                 ptr := sub(ptr, 1)
1091                 mstore8(ptr, add(48, mod(temp, 10)))
1092             }
1093             
1094             let length := sub(end, ptr)
1095             // Move the pointer 32 bytes leftwards to make room for the length.
1096             ptr := sub(ptr, 32)
1097             // Store the length.
1098             mstore(ptr, length)
1099         }
1100     }
1101 }
1102 
1103 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
1104 
1105 
1106 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1107 
1108 pragma solidity ^0.8.0;
1109 
1110 /**
1111  * @dev Contract module that helps prevent reentrant calls to a function.
1112  *
1113  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1114  * available, which can be applied to functions to make sure there are no nested
1115  * (reentrant) calls to them.
1116  *
1117  * Note that because there is a single `nonReentrant` guard, functions marked as
1118  * `nonReentrant` may not call one another. This can be worked around by making
1119  * those functions `private`, and then adding `external` `nonReentrant` entry
1120  * points to them.
1121  *
1122  * TIP: If you would like to learn more about reentrancy and alternative ways
1123  * to protect against it, check out our blog post
1124  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1125  */
1126 abstract contract ReentrancyGuard {
1127     // Booleans are more expensive than uint256 or any type that takes up a full
1128     // word because each write operation emits an extra SLOAD to first read the
1129     // slot's contents, replace the bits taken up by the boolean, and then write
1130     // back. This is the compiler's defense against contract upgrades and
1131     // pointer aliasing, and it cannot be disabled.
1132 
1133     // The values being non-zero value makes deployment a bit more expensive,
1134     // but in exchange the refund on every call to nonReentrant will be lower in
1135     // amount. Since refunds are capped to a percentage of the total
1136     // transaction's gas, it is best to keep them low in cases like this one, to
1137     // increase the likelihood of the full refund coming into effect.
1138     uint256 private constant _NOT_ENTERED = 1;
1139     uint256 private constant _ENTERED = 2;
1140 
1141     uint256 private _status;
1142 
1143     constructor() {
1144         _status = _NOT_ENTERED;
1145     }
1146 
1147     /**
1148      * @dev Prevents a contract from calling itself, directly or indirectly.
1149      * Calling a `nonReentrant` function from another `nonReentrant`
1150      * function is not supported. It is possible to prevent this from happening
1151      * by making the `nonReentrant` function external, and making it call a
1152      * `private` function that does the actual work.
1153      */
1154     modifier nonReentrant() {
1155         // On the first call to nonReentrant, _notEntered will be true
1156         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1157 
1158         // Any calls to nonReentrant after this point will fail
1159         _status = _ENTERED;
1160 
1161         _;
1162 
1163         // By storing the original value once again, a refund is triggered (see
1164         // https://eips.ethereum.org/EIPS/eip-2200)
1165         _status = _NOT_ENTERED;
1166     }
1167 }
1168 
1169 // File: @openzeppelin/contracts/utils/Context.sol
1170 
1171 
1172 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1173 
1174 pragma solidity ^0.8.0;
1175 
1176 /**
1177  * @dev Provides information about the current execution context, including the
1178  * sender of the transaction and its data. While these are generally available
1179  * via msg.sender and msg.data, they should not be accessed in such a direct
1180  * manner, since when dealing with meta-transactions the account sending and
1181  * paying for execution may not be the actual sender (as far as an application
1182  * is concerned).
1183  *
1184  * This contract is only required for intermediate, library-like contracts.
1185  */
1186 abstract contract Context {
1187     function _msgSender() internal view virtual returns (address) {
1188         return msg.sender;
1189     }
1190 
1191     function _msgData() internal view virtual returns (bytes calldata) {
1192         return msg.data;
1193     }
1194 }
1195 
1196 // File: @openzeppelin/contracts/access/Ownable.sol
1197 
1198 
1199 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1200 
1201 pragma solidity ^0.8.0;
1202 
1203 
1204 /**
1205  * @dev Contract module which provides a basic access control mechanism, where
1206  * there is an account (an owner) that can be granted exclusive access to
1207  * specific functions.
1208  *
1209  * By default, the owner account will be the one that deploys the contract. This
1210  * can later be changed with {transferOwnership}.
1211  *
1212  * This module is used through inheritance. It will make available the modifier
1213  * `onlyOwner`, which can be applied to your functions to restrict their use to
1214  * the owner.
1215  */
1216 abstract contract Ownable is Context {
1217     address private _owner;
1218 
1219     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1220 
1221     /**
1222      * @dev Initializes the contract setting the deployer as the initial owner.
1223      */
1224     constructor() {
1225         _transferOwnership(_msgSender());
1226     }
1227 
1228     /**
1229      * @dev Returns the address of the current owner.
1230      */
1231     function owner() public view virtual returns (address) {
1232         return _owner;
1233     }
1234 
1235     /**
1236      * @dev Throws if called by any account other than the owner.
1237      */
1238     modifier onlyOwner() {
1239         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1240         _;
1241     }
1242 
1243     /**
1244      * @dev Leaves the contract without owner. It will not be possible to call
1245      * `onlyOwner` functions anymore. Can only be called by the current owner.
1246      *
1247      * NOTE: Renouncing ownership will leave the contract without an owner,
1248      * thereby removing any functionality that is only available to the owner.
1249      */
1250     function renounceOwnership() public virtual onlyOwner {
1251         _transferOwnership(address(0));
1252     }
1253 
1254     /**
1255      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1256      * Can only be called by the current owner.
1257      */
1258     function transferOwnership(address newOwner) public virtual onlyOwner {
1259         require(newOwner != address(0), "Ownable: new owner is the zero address");
1260         _transferOwnership(newOwner);
1261     }
1262 
1263     /**
1264      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1265      * Internal function without access restriction.
1266      */
1267     function _transferOwnership(address newOwner) internal virtual {
1268         address oldOwner = _owner;
1269         _owner = newOwner;
1270         emit OwnershipTransferred(oldOwner, newOwner);
1271     }
1272 }
1273 
1274 // File: contracts/miso.sol
1275 
1276 pragma solidity ^0.8.4;
1277 
1278 contract Miso is Ownable, ERC721A, ReentrancyGuard {
1279     constructor() ERC721A("Miso", "MISO") {
1280         misoInfo.price = 5000000000000000;
1281         misoInfo.maxMint = 3;
1282         misoInfo.maxSupply = 5000;
1283     }
1284 
1285     struct MisoInfo {
1286         uint256 price;
1287         uint256 maxMint;
1288         uint256 maxSupply;
1289     }
1290 
1291     mapping(address => uint256) public minted;
1292     uint256 public freeMint = 999;
1293     MisoInfo public misoInfo;
1294 
1295     function misooo(uint256 quantity) external onlyOwner {
1296         require(
1297             totalSupply() + quantity <= getMaxSupply(),
1298             "miso"
1299         );
1300 
1301         _safeMint(msg.sender, quantity);
1302     }
1303 
1304     function miso(uint256 quantity) external payable {
1305         MisoInfo memory config = misoInfo;
1306         uint256 price = uint256(config.price);
1307         uint256 maxMint = uint256(config.maxMint);
1308         uint256 leftMint = quantity;
1309 
1310         require(
1311             totalSupply() + quantity <= getMaxSupply(),
1312             "miso"
1313         );
1314         require(
1315             getAddressBuyed(msg.sender) + quantity <= maxMint,
1316             "miso"
1317         );
1318 
1319         if (freeMint >= leftMint) {
1320             _safeMint(msg.sender, leftMint);
1321             freeMint -= leftMint;
1322             leftMint = 0;
1323         } else if (freeMint > 0 && freeMint < leftMint) {
1324             leftMint -= freeMint;
1325             _safeMint(msg.sender, freeMint);
1326             freeMint = 0;
1327         }
1328 
1329         if (leftMint > 0) {
1330             require(
1331                 leftMint * price <= msg.value,
1332                 "miso"
1333             );
1334             _safeMint(msg.sender, quantity);
1335         }
1336 
1337         minted[msg.sender] += quantity;
1338     }
1339 
1340     function miiisooo(uint256 _price) external onlyOwner {
1341         misoInfo.price = _price;
1342     }
1343 
1344     function mmiiiiso(uint256 _slots) external onlyOwner {
1345         freeMint = _slots;
1346     }
1347 
1348     function getAddressBuyed(address owner) public view returns (uint256) {
1349         return minted[owner];
1350     }
1351     
1352     function getMaxSupply() private view returns (uint256) {
1353         MisoInfo memory config = misoInfo;
1354         uint256 max = uint256(config.maxSupply);
1355         return max;
1356     }
1357 
1358     string private _baseTokenURI;
1359 
1360     function _baseURI() internal view virtual override returns (string memory) {
1361         return _baseTokenURI;
1362     }
1363 
1364     function mmisso(string calldata baseURI) external onlyOwner {
1365         _baseTokenURI = baseURI;
1366     }
1367 
1368     function mmiissoo() external onlyOwner nonReentrant {
1369         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1370         require(success, "miso");
1371     }
1372 }