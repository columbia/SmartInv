1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.11;
3 
4 // ........................................................................................................................
5 // ........................................................................................................................
6 // ..............................................  .......................................  ...............................
7 // ........................................,@@@@%..........................................................................
8 // ......................................(@@////#@@...............................,@@@@%.................................
9 // ....................................@@%((##(((//@@(,,........................,,#@@##((#@@...............................
10 // ....................................@@%(#@@#((////%@@........................@@%(#@@#(#@@...............................
11 // ....................................@@%(#@@@@&((//#&&**,................,*/&&(/(#%@@#(#@@...............................
12 // ....................................@@%(#@@@@@%%/////@@(****************%&%((((&@@@@#(#@@...............................
13 // ....................................@@%(#@@@@@@@(((//%%%%%&&&&&%%&&&&&%%(/(##%%&@@&&%%%##...............................
14 // ....................................@@%(#@@@@@@@((//////////(((////(((((///((@@@@@((@@%.................................
15 // ....................................@@&##%%@@@@@//////////**(((((***//(((((((##%%%((@@%.................................
16 // ....................................@@%//((@@&##(((/////////***(((((((*******(((((((@@%.................................
17 // ....................................@@%((**///*******((////////****/((((/////****/@@**,.................................
18 // .................................*@@/****((((((((((((@@@@@@@(///////****&@@@@#((((@@,...................................
19 // .................................*@@((((/*******((%@@  %@@##@@&///////@@%#%@@@@%((//@@%.................................
20 // ...............................%@&((*****/////((@@(    %@@  &@@///////((. *@@. (@@//@@%.................................
21 // ...............................%@&**//////////((       %@@((@@@((//(((//((%@@.    //@@%.................................
22 // ...............................%@&////////////((((,    /((//@@@(((((((/////((     ////#@@...............................
23 // .............................@@#/////////((*,,,,((((((((((((((((((((((,,*//(((((((((//#@@...............................
24 // .............................@@#//////(((,,,,,,,,,/(((((((((,,,,,,,,,,,,,,*//((((((((((//@@#............................
25 // .............................@@%((((((/,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,//((((((((((@@#............................
26 // .............................@@(******/((((*,,,,(((((,,,,,,,,,,,,@@@@@@@@@@@@,,*//((/////@@#............................
27 // ...............................%@&//((/,,,,,,,,,(((((,,,,,,,,,,,,%&@@@@@@@@&&,,*//(((((((@@#............................
28 // ...............................%@&****///((*,,,,,,,,,(((((,,,,,,,,,(&&@@&&#,,,,*//((//#@@...............................
29 // ...............................%@&((((/**,,,,,,,,,,,,,,/((((((((((((((&&#(/,,%&#((((((#@@...............................
30 // .............................@@#////((((((((((((,,,,,,,,,,&&&&&&&&&&&&&&&&&&&#((((((@@%.................................
31 // .............................@@#////(((((**//*,,,,,,,,,,,,,,,,*&&/*/((**#&#,,(((((//@@%.................................
32 // .............................@@%((//(((((**///**(((((((*,,,,,,*&&/*/((**#&%(((((((((@@%.................................
33 // ..........................(@@(((((//(((((**///(((((((,,,,,,,,,*%%///////#&%(((((////((#@@...............................
34 // ..........................(@@///////(((((**///**((/(((((((,,,,,,,%&&&&&&#((((/////((((#@@...............................
35 // ..........................(@@/////((((/**/////**/////,,,,,,,,,,,,,,,,,,,,,*((((((((((((//@@#............................
36 // ........................**#&&/////((((/**//***((((/////*,,**,,,,,,,,,,,,,**(((((((((/////&&#**..........................
37 // ........................@@%(((((((//**///**////////////***//,,,,,,,,,,,,/(((((((((//((///**#@@..........................
38 // ........................@@%/////////////*///(//////((**,,,,,,,,,,,,,,,,,**/(((((((//(((**//(%%##*.......................
39 // ........................@@%/////////**//////////(((//*****//,,,,,,,,,,,,//((((////((////////**@@/.......................
40 
41 // File: IERC721A.sol
42 
43 // ERC721A Contracts v4.0.0
44 // Creator: Chiru Labs
45 
46 pragma solidity ^0.8.4;
47 
48 /**
49  * @dev Interface of an ERC721A compliant contract.
50  */
51 interface IERC721A {
52     /**
53      * The caller must own the token or be an approved operator.
54      */
55     error ApprovalCallerNotOwnerNorApproved();
56 
57     /**
58      * The token does not exist.
59      */
60     error ApprovalQueryForNonexistentToken();
61 
62     /**
63      * The caller cannot approve to their own address.
64      */
65     error ApproveToCaller();
66 
67     /**
68      * The caller cannot approve to the current owner.
69      */
70     error ApprovalToCurrentOwner();
71 
72     /**
73      * Cannot query the balance for the zero address.
74      */
75     error BalanceQueryForZeroAddress();
76 
77     /**
78      * Cannot mint to the zero address.
79      */
80     error MintToZeroAddress();
81 
82     /**
83      * The quantity of tokens minted must be more than zero.
84      */
85     error MintZeroQuantity();
86 
87     /**
88      * The token does not exist.
89      */
90     error OwnerQueryForNonexistentToken();
91 
92     /**
93      * The caller must own the token or be an approved operator.
94      */
95     error TransferCallerNotOwnerNorApproved();
96 
97     /**
98      * The token must be owned by `from`.
99      */
100     error TransferFromIncorrectOwner();
101 
102     /**
103      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
104      */
105     error TransferToNonERC721ReceiverImplementer();
106 
107     /**
108      * Cannot transfer to the zero address.
109      */
110     error TransferToZeroAddress();
111 
112     /**
113      * The token does not exist.
114      */
115     error URIQueryForNonexistentToken();
116 
117     struct TokenOwnership {
118         // The address of the owner.
119         address addr;
120         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
121         uint64 startTimestamp;
122         // Whether the token has been burned.
123         bool burned;
124     }
125 
126     /**
127      * @dev Returns the total amount of tokens stored by the contract.
128      *
129      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
130      */
131     function totalSupply() external view returns (uint256);
132 
133     // ==============================
134     //            IERC165
135     // ==============================
136 
137     /**
138      * @dev Returns true if this contract implements the interface defined by
139      * `interfaceId`. See the corresponding
140      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
141      * to learn more about how these ids are created.
142      *
143      * This function call must use less than 30 000 gas.
144      */
145     function supportsInterface(bytes4 interfaceId) external view returns (bool);
146 
147     // ==============================
148     //            IERC721
149     // ==============================
150 
151     /**
152      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
153      */
154     event Transfer(
155         address indexed from,
156         address indexed to,
157         uint256 indexed tokenId
158     );
159 
160     /**
161      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
162      */
163     event Approval(
164         address indexed owner,
165         address indexed approved,
166         uint256 indexed tokenId
167     );
168 
169     /**
170      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
171      */
172     event ApprovalForAll(
173         address indexed owner,
174         address indexed operator,
175         bool approved
176     );
177 
178     /**
179      * @dev Returns the number of tokens in ``owner``'s account.
180      */
181     function balanceOf(address owner) external view returns (uint256 balance);
182 
183     /**
184      * @dev Returns the owner of the `tokenId` token.
185      *
186      * Requirements:
187      *
188      * - `tokenId` must exist.
189      */
190     function ownerOf(uint256 tokenId) external view returns (address owner);
191 
192     /**
193      * @dev Safely transfers `tokenId` token from `from` to `to`.
194      *
195      * Requirements:
196      *
197      * - `from` cannot be the zero address.
198      * - `to` cannot be the zero address.
199      * - `tokenId` token must exist and be owned by `from`.
200      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
201      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
202      *
203      * Emits a {Transfer} event.
204      */
205     function safeTransferFrom(
206         address from,
207         address to,
208         uint256 tokenId,
209         bytes calldata data
210     ) external;
211 
212     /**
213      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
214      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
215      *
216      * Requirements:
217      *
218      * - `from` cannot be the zero address.
219      * - `to` cannot be the zero address.
220      * - `tokenId` token must exist and be owned by `from`.
221      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
222      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
223      *
224      * Emits a {Transfer} event.
225      */
226     function safeTransferFrom(
227         address from,
228         address to,
229         uint256 tokenId
230     ) external;
231 
232     /**
233      * @dev Transfers `tokenId` token from `from` to `to`.
234      *
235      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
236      *
237      * Requirements:
238      *
239      * - `from` cannot be the zero address.
240      * - `to` cannot be the zero address.
241      * - `tokenId` token must be owned by `from`.
242      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
243      *
244      * Emits a {Transfer} event.
245      */
246     function transferFrom(
247         address from,
248         address to,
249         uint256 tokenId
250     ) external;
251 
252     /**
253      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
254      * The approval is cleared when the token is transferred.
255      *
256      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
257      *
258      * Requirements:
259      *
260      * - The caller must own the token or be an approved operator.
261      * - `tokenId` must exist.
262      *
263      * Emits an {Approval} event.
264      */
265     function approve(address to, uint256 tokenId) external;
266 
267     /**
268      * @dev Approve or remove `operator` as an operator for the caller.
269      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
270      *
271      * Requirements:
272      *
273      * - The `operator` cannot be the caller.
274      *
275      * Emits an {ApprovalForAll} event.
276      */
277     function setApprovalForAll(address operator, bool _approved) external;
278 
279     /**
280      * @dev Returns the account approved for `tokenId` token.
281      *
282      * Requirements:
283      *
284      * - `tokenId` must exist.
285      */
286     function getApproved(uint256 tokenId)
287         external
288         view
289         returns (address operator);
290 
291     /**
292      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
293      *
294      * See {setApprovalForAll}
295      */
296     function isApprovedForAll(address owner, address operator)
297         external
298         view
299         returns (bool);
300 
301     // ==============================
302     //        IERC721Metadata
303     // ==============================
304 
305     /**
306      * @dev Returns the token collection name.
307      */
308     function name() external view returns (string memory);
309 
310     /**
311      * @dev Returns the token collection symbol.
312      */
313     function symbol() external view returns (string memory);
314 
315     /**
316      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
317      */
318     function tokenURI(uint256 tokenId) external view returns (string memory);
319 }
320 // File: ERC721A.sol
321 
322 // ERC721A Contracts v4.0.0
323 // Creator: Chiru Labs
324 
325 pragma solidity ^0.8.4;
326 
327 /**
328  * @dev ERC721 token receiver interface.
329  */
330 interface ERC721A__IERC721Receiver {
331     function onERC721Received(
332         address operator,
333         address from,
334         uint256 tokenId,
335         bytes calldata data
336     ) external returns (bytes4);
337 }
338 
339 /**
340  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
341  * the Metadata extension. Built to optimize for lower gas during batch mints.
342  *
343  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
344  *
345  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
346  *
347  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
348  */
349 contract ERC721A is IERC721A {
350     // Mask of an entry in packed address data.
351     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
352 
353     // The bit position of `numberMinted` in packed address data.
354     uint256 private constant BITPOS_NUMBER_MINTED = 64;
355 
356     // The bit position of `numberBurned` in packed address data.
357     uint256 private constant BITPOS_NUMBER_BURNED = 128;
358 
359     // The bit position of `aux` in packed address data.
360     uint256 private constant BITPOS_AUX = 192;
361 
362     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
363     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
364 
365     // The bit position of `startTimestamp` in packed ownership.
366     uint256 private constant BITPOS_START_TIMESTAMP = 160;
367 
368     // The bit mask of the `burned` bit in packed ownership.
369     uint256 private constant BITMASK_BURNED = 1 << 224;
370 
371     // The bit position of the `nextInitialized` bit in packed ownership.
372     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
373 
374     // The bit mask of the `nextInitialized` bit in packed ownership.
375     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
376 
377     // The tokenId of the next token to be minted.
378     uint256 private _currentIndex;
379 
380     // The number of tokens burned.
381     uint256 private _burnCounter;
382 
383     // Token name
384     string private _name;
385 
386     // Token symbol
387     string private _symbol;
388 
389     // Mapping from token ID to ownership details
390     // An empty struct value does not necessarily mean the token is unowned.
391     // See `_packedOwnershipOf` implementation for details.
392     //
393     // Bits Layout:
394     // - [0..159]   `addr`
395     // - [160..223] `startTimestamp`
396     // - [224]      `burned`
397     // - [225]      `nextInitialized`
398     mapping(uint256 => uint256) private _packedOwnerships;
399 
400     // Mapping owner address to address data.
401     //
402     // Bits Layout:
403     // - [0..63]    `balance`
404     // - [64..127]  `numberMinted`
405     // - [128..191] `numberBurned`
406     // - [192..255] `aux`
407     mapping(address => uint256) private _packedAddressData;
408 
409     // Mapping from token ID to approved address.
410     mapping(uint256 => address) private _tokenApprovals;
411 
412     // Mapping from owner to operator approvals
413     mapping(address => mapping(address => bool)) private _operatorApprovals;
414 
415     constructor(string memory name_, string memory symbol_) {
416         _name = name_;
417         _symbol = symbol_;
418         _currentIndex = _startTokenId();
419     }
420 
421     /**
422      * @dev Returns the starting token ID.
423      * To change the starting token ID, please override this function.
424      */
425     function _startTokenId() internal view virtual returns (uint256) {
426         return 0;
427     }
428 
429     /**
430      * @dev Returns the next token ID to be minted.
431      */
432     function _nextTokenId() internal view returns (uint256) {
433         return _currentIndex;
434     }
435 
436     /**
437      * @dev Returns the total number of tokens in existence.
438      * Burned tokens will reduce the count.
439      * To get the total number of tokens minted, please see `_totalMinted`.
440      */
441     function totalSupply() public view override returns (uint256) {
442         // Counter underflow is impossible as _burnCounter cannot be incremented
443         // more than `_currentIndex - _startTokenId()` times.
444         unchecked {
445             return _currentIndex - _burnCounter - _startTokenId();
446         }
447     }
448 
449     /**
450      * @dev Returns the total amount of tokens minted in the contract.
451      */
452     function _totalMinted() internal view returns (uint256) {
453         // Counter underflow is impossible as _currentIndex does not decrement,
454         // and it is initialized to `_startTokenId()`
455         unchecked {
456             return _currentIndex - _startTokenId();
457         }
458     }
459 
460     /**
461      * @dev Returns the total number of tokens burned.
462      */
463     function _totalBurned() internal view returns (uint256) {
464         return _burnCounter;
465     }
466 
467     /**
468      * @dev See {IERC165-supportsInterface}.
469      */
470     function supportsInterface(bytes4 interfaceId)
471         public
472         view
473         virtual
474         override
475         returns (bool)
476     {
477         // The interface IDs are constants representing the first 4 bytes of the XOR of
478         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
479         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
480         return
481             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
482             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
483             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
484     }
485 
486     /**
487      * @dev See {IERC721-balanceOf}.
488      */
489     function balanceOf(address owner) public view override returns (uint256) {
490         if (_addressToUint256(owner) == 0) revert BalanceQueryForZeroAddress();
491         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
492     }
493 
494     /**
495      * Returns the number of tokens minted by `owner`.
496      */
497     function _numberMinted(address owner) internal view returns (uint256) {
498         return
499             (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) &
500             BITMASK_ADDRESS_DATA_ENTRY;
501     }
502 
503     /**
504      * Returns the number of tokens burned by or on behalf of `owner`.
505      */
506     function _numberBurned(address owner) internal view returns (uint256) {
507         return
508             (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) &
509             BITMASK_ADDRESS_DATA_ENTRY;
510     }
511 
512     /**
513      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
514      */
515     function _getAux(address owner) internal view returns (uint64) {
516         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
517     }
518 
519     /**
520      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
521      * If there are multiple variables, please pack them into a uint64.
522      */
523     function _setAux(address owner, uint64 aux) internal {
524         uint256 packed = _packedAddressData[owner];
525         uint256 auxCasted;
526         assembly {
527             // Cast aux without masking.
528             auxCasted := aux
529         }
530         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
531         _packedAddressData[owner] = packed;
532     }
533 
534     /**
535      * Returns the packed ownership data of `tokenId`.
536      */
537     function _packedOwnershipOf(uint256 tokenId)
538         private
539         view
540         returns (uint256)
541     {
542         uint256 curr = tokenId;
543 
544         unchecked {
545             if (_startTokenId() <= curr)
546                 if (curr < _currentIndex) {
547                     uint256 packed = _packedOwnerships[curr];
548                     // If not burned.
549                     if (packed & BITMASK_BURNED == 0) {
550                         // Invariant:
551                         // There will always be an ownership that has an address and is not burned
552                         // before an ownership that does not have an address and is not burned.
553                         // Hence, curr will not underflow.
554                         //
555                         // We can directly compare the packed value.
556                         // If the address is zero, packed is zero.
557                         while (packed == 0) {
558                             packed = _packedOwnerships[--curr];
559                         }
560                         return packed;
561                     }
562                 }
563         }
564         revert OwnerQueryForNonexistentToken();
565     }
566 
567     /**
568      * Returns the unpacked `TokenOwnership` struct from `packed`.
569      */
570     function _unpackedOwnership(uint256 packed)
571         private
572         pure
573         returns (TokenOwnership memory ownership)
574     {
575         ownership.addr = address(uint160(packed));
576         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
577         ownership.burned = packed & BITMASK_BURNED != 0;
578     }
579 
580     /**
581      * Returns the unpacked `TokenOwnership` struct at `index`.
582      */
583     function _ownershipAt(uint256 index)
584         internal
585         view
586         returns (TokenOwnership memory)
587     {
588         return _unpackedOwnership(_packedOwnerships[index]);
589     }
590 
591     /**
592      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
593      */
594     function _initializeOwnershipAt(uint256 index) internal {
595         if (_packedOwnerships[index] == 0) {
596             _packedOwnerships[index] = _packedOwnershipOf(index);
597         }
598     }
599 
600     /**
601      * Gas spent here starts off proportional to the maximum mint batch size.
602      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
603      */
604     function _ownershipOf(uint256 tokenId)
605         internal
606         view
607         returns (TokenOwnership memory)
608     {
609         return _unpackedOwnership(_packedOwnershipOf(tokenId));
610     }
611 
612     /**
613      * @dev See {IERC721-ownerOf}.
614      */
615     function ownerOf(uint256 tokenId) public view override returns (address) {
616         return address(uint160(_packedOwnershipOf(tokenId)));
617     }
618 
619     /**
620      * @dev See {IERC721Metadata-name}.
621      */
622     function name() public view virtual override returns (string memory) {
623         return _name;
624     }
625 
626     /**
627      * @dev See {IERC721Metadata-symbol}.
628      */
629     function symbol() public view virtual override returns (string memory) {
630         return _symbol;
631     }
632 
633     /**
634      * @dev See {IERC721Metadata-tokenURI}.
635      */
636     function tokenURI(uint256 tokenId)
637         public
638         view
639         virtual
640         override
641         returns (string memory)
642     {
643         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
644 
645         string memory baseURI = _baseURI();
646         return
647             bytes(baseURI).length != 0
648                 ? string(abi.encodePacked(baseURI, _toString(tokenId)))
649                 : "";
650     }
651 
652     /**
653      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
654      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
655      * by default, can be overriden in child contracts.
656      */
657     function _baseURI() internal view virtual returns (string memory) {
658         return "";
659     }
660 
661     /**
662      * @dev Casts the address to uint256 without masking.
663      */
664     function _addressToUint256(address value)
665         private
666         pure
667         returns (uint256 result)
668     {
669         assembly {
670             result := value
671         }
672     }
673 
674     /**
675      * @dev Casts the boolean to uint256 without branching.
676      */
677     function _boolToUint256(bool value) private pure returns (uint256 result) {
678         assembly {
679             result := value
680         }
681     }
682 
683     /**
684      * @dev See {IERC721-approve}.
685      */
686     function approve(address to, uint256 tokenId) public override {
687         address owner = address(uint160(_packedOwnershipOf(tokenId)));
688         if (to == owner) revert ApprovalToCurrentOwner();
689 
690         if (_msgSenderERC721A() != owner)
691             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
692                 revert ApprovalCallerNotOwnerNorApproved();
693             }
694 
695         _tokenApprovals[tokenId] = to;
696         emit Approval(owner, to, tokenId);
697     }
698 
699     /**
700      * @dev See {IERC721-getApproved}.
701      */
702     function getApproved(uint256 tokenId)
703         public
704         view
705         override
706         returns (address)
707     {
708         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
709 
710         return _tokenApprovals[tokenId];
711     }
712 
713     /**
714      * @dev See {IERC721-setApprovalForAll}.
715      */
716     function setApprovalForAll(address operator, bool approved)
717         public
718         virtual
719         override
720     {
721         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
722 
723         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
724         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
725     }
726 
727     /**
728      * @dev See {IERC721-isApprovedForAll}.
729      */
730     function isApprovedForAll(address owner, address operator)
731         public
732         view
733         virtual
734         override
735         returns (bool)
736     {
737         return _operatorApprovals[owner][operator];
738     }
739 
740     /**
741      * @dev See {IERC721-transferFrom}.
742      */
743     function transferFrom(
744         address from,
745         address to,
746         uint256 tokenId
747     ) public virtual override {
748         _transfer(from, to, tokenId);
749     }
750 
751     /**
752      * @dev See {IERC721-safeTransferFrom}.
753      */
754     function safeTransferFrom(
755         address from,
756         address to,
757         uint256 tokenId
758     ) public virtual override {
759         safeTransferFrom(from, to, tokenId, "");
760     }
761 
762     /**
763      * @dev See {IERC721-safeTransferFrom}.
764      */
765     function safeTransferFrom(
766         address from,
767         address to,
768         uint256 tokenId,
769         bytes memory _data
770     ) public virtual override {
771         _transfer(from, to, tokenId);
772         if (to.code.length != 0)
773             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
774                 revert TransferToNonERC721ReceiverImplementer();
775             }
776     }
777 
778     /**
779      * @dev Returns whether `tokenId` exists.
780      *
781      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
782      *
783      * Tokens start existing when they are minted (`_mint`),
784      */
785     function _exists(uint256 tokenId) internal view returns (bool) {
786         return
787             _startTokenId() <= tokenId &&
788             tokenId < _currentIndex && // If within bounds,
789             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
790     }
791 
792     /**
793      * @dev Equivalent to `_safeMint(to, quantity, '')`.
794      */
795     function _safeMint(address to, uint256 quantity) internal {
796         _safeMint(to, quantity, "");
797     }
798 
799     /**
800      * @dev Safely mints `quantity` tokens and transfers them to `to`.
801      *
802      * Requirements:
803      *
804      * - If `to` refers to a smart contract, it must implement
805      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
806      * - `quantity` must be greater than 0.
807      *
808      * Emits a {Transfer} event.
809      */
810     function _safeMint(
811         address to,
812         uint256 quantity,
813         bytes memory _data
814     ) internal {
815         uint256 startTokenId = _currentIndex;
816         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
817         if (quantity == 0) revert MintZeroQuantity();
818 
819         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
820 
821         // Overflows are incredibly unrealistic.
822         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
823         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
824         unchecked {
825             // Updates:
826             // - `balance += quantity`.
827             // - `numberMinted += quantity`.
828             //
829             // We can directly add to the balance and number minted.
830             _packedAddressData[to] +=
831                 quantity *
832                 ((1 << BITPOS_NUMBER_MINTED) | 1);
833 
834             // Updates:
835             // - `address` to the owner.
836             // - `startTimestamp` to the timestamp of minting.
837             // - `burned` to `false`.
838             // - `nextInitialized` to `quantity == 1`.
839             _packedOwnerships[startTokenId] =
840                 _addressToUint256(to) |
841                 (block.timestamp << BITPOS_START_TIMESTAMP) |
842                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
843 
844             uint256 updatedIndex = startTokenId;
845             uint256 end = updatedIndex + quantity;
846 
847             if (to.code.length != 0) {
848                 do {
849                     emit Transfer(address(0), to, updatedIndex);
850                     if (
851                         !_checkContractOnERC721Received(
852                             address(0),
853                             to,
854                             updatedIndex++,
855                             _data
856                         )
857                     ) {
858                         revert TransferToNonERC721ReceiverImplementer();
859                     }
860                 } while (updatedIndex < end);
861                 // Reentrancy protection
862                 if (_currentIndex != startTokenId) revert();
863             } else {
864                 do {
865                     emit Transfer(address(0), to, updatedIndex++);
866                 } while (updatedIndex < end);
867             }
868             _currentIndex = updatedIndex;
869         }
870         _afterTokenTransfers(address(0), to, startTokenId, quantity);
871     }
872 
873     /**
874      * @dev Mints `quantity` tokens and transfers them to `to`.
875      *
876      * Requirements:
877      *
878      * - `to` cannot be the zero address.
879      * - `quantity` must be greater than 0.
880      *
881      * Emits a {Transfer} event.
882      */
883     function _mint(address to, uint256 quantity) internal {
884         uint256 startTokenId = _currentIndex;
885         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
886         if (quantity == 0) revert MintZeroQuantity();
887 
888         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
889 
890         // Overflows are incredibly unrealistic.
891         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
892         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
893         unchecked {
894             // Updates:
895             // - `balance += quantity`.
896             // - `numberMinted += quantity`.
897             //
898             // We can directly add to the balance and number minted.
899             _packedAddressData[to] +=
900                 quantity *
901                 ((1 << BITPOS_NUMBER_MINTED) | 1);
902 
903             // Updates:
904             // - `address` to the owner.
905             // - `startTimestamp` to the timestamp of minting.
906             // - `burned` to `false`.
907             // - `nextInitialized` to `quantity == 1`.
908             _packedOwnerships[startTokenId] =
909                 _addressToUint256(to) |
910                 (block.timestamp << BITPOS_START_TIMESTAMP) |
911                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
912 
913             uint256 updatedIndex = startTokenId;
914             uint256 end = updatedIndex + quantity;
915 
916             do {
917                 emit Transfer(address(0), to, updatedIndex++);
918             } while (updatedIndex < end);
919 
920             _currentIndex = updatedIndex;
921         }
922         _afterTokenTransfers(address(0), to, startTokenId, quantity);
923     }
924 
925     /**
926      * @dev Transfers `tokenId` from `from` to `to`.
927      *
928      * Requirements:
929      *
930      * - `to` cannot be the zero address.
931      * - `tokenId` token must be owned by `from`.
932      *
933      * Emits a {Transfer} event.
934      */
935     function _transfer(
936         address from,
937         address to,
938         uint256 tokenId
939     ) private {
940         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
941 
942         if (address(uint160(prevOwnershipPacked)) != from)
943             revert TransferFromIncorrectOwner();
944 
945         address approvedAddress = _tokenApprovals[tokenId];
946 
947         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
948             isApprovedForAll(from, _msgSenderERC721A()) ||
949             approvedAddress == _msgSenderERC721A());
950 
951         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
952         if (_addressToUint256(to) == 0) revert TransferToZeroAddress();
953 
954         _beforeTokenTransfers(from, to, tokenId, 1);
955 
956         // Clear approvals from the previous owner.
957         if (_addressToUint256(approvedAddress) != 0) {
958             delete _tokenApprovals[tokenId];
959         }
960 
961         // Underflow of the sender's balance is impossible because we check for
962         // ownership above and the recipient's balance can't realistically overflow.
963         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
964         unchecked {
965             // We can directly increment and decrement the balances.
966             --_packedAddressData[from]; // Updates: `balance -= 1`.
967             ++_packedAddressData[to]; // Updates: `balance += 1`.
968 
969             // Updates:
970             // - `address` to the next owner.
971             // - `startTimestamp` to the timestamp of transfering.
972             // - `burned` to `false`.
973             // - `nextInitialized` to `true`.
974             _packedOwnerships[tokenId] =
975                 _addressToUint256(to) |
976                 (block.timestamp << BITPOS_START_TIMESTAMP) |
977                 BITMASK_NEXT_INITIALIZED;
978 
979             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
980             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
981                 uint256 nextTokenId = tokenId + 1;
982                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
983                 if (_packedOwnerships[nextTokenId] == 0) {
984                     // If the next slot is within bounds.
985                     if (nextTokenId != _currentIndex) {
986                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
987                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
988                     }
989                 }
990             }
991         }
992 
993         emit Transfer(from, to, tokenId);
994         _afterTokenTransfers(from, to, tokenId, 1);
995     }
996 
997     /**
998      * @dev Equivalent to `_burn(tokenId, false)`.
999      */
1000     function _burn(uint256 tokenId) internal virtual {
1001         _burn(tokenId, false);
1002     }
1003 
1004     /**
1005      * @dev Destroys `tokenId`.
1006      * The approval is cleared when the token is burned.
1007      *
1008      * Requirements:
1009      *
1010      * - `tokenId` must exist.
1011      *
1012      * Emits a {Transfer} event.
1013      */
1014     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1015         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1016 
1017         address from = address(uint160(prevOwnershipPacked));
1018         address approvedAddress = _tokenApprovals[tokenId];
1019 
1020         if (approvalCheck) {
1021             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1022                 isApprovedForAll(from, _msgSenderERC721A()) ||
1023                 approvedAddress == _msgSenderERC721A());
1024 
1025             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1026         }
1027 
1028         _beforeTokenTransfers(from, address(0), tokenId, 1);
1029 
1030         // Clear approvals from the previous owner.
1031         if (_addressToUint256(approvedAddress) != 0) {
1032             delete _tokenApprovals[tokenId];
1033         }
1034 
1035         // Underflow of the sender's balance is impossible because we check for
1036         // ownership above and the recipient's balance can't realistically overflow.
1037         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1038         unchecked {
1039             // Updates:
1040             // - `balance -= 1`.
1041             // - `numberBurned += 1`.
1042             //
1043             // We can directly decrement the balance, and increment the number burned.
1044             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1045             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1046 
1047             // Updates:
1048             // - `address` to the last owner.
1049             // - `startTimestamp` to the timestamp of burning.
1050             // - `burned` to `true`.
1051             // - `nextInitialized` to `true`.
1052             _packedOwnerships[tokenId] =
1053                 _addressToUint256(from) |
1054                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1055                 BITMASK_BURNED |
1056                 BITMASK_NEXT_INITIALIZED;
1057 
1058             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1059             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1060                 uint256 nextTokenId = tokenId + 1;
1061                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1062                 if (_packedOwnerships[nextTokenId] == 0) {
1063                     // If the next slot is within bounds.
1064                     if (nextTokenId != _currentIndex) {
1065                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1066                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1067                     }
1068                 }
1069             }
1070         }
1071 
1072         emit Transfer(from, address(0), tokenId);
1073         _afterTokenTransfers(from, address(0), tokenId, 1);
1074 
1075         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1076         unchecked {
1077             _burnCounter++;
1078         }
1079     }
1080 
1081     /**
1082      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1083      *
1084      * @param from address representing the previous owner of the given token ID
1085      * @param to target address that will receive the tokens
1086      * @param tokenId uint256 ID of the token to be transferred
1087      * @param _data bytes optional data to send along with the call
1088      * @return bool whether the call correctly returned the expected magic value
1089      */
1090     function _checkContractOnERC721Received(
1091         address from,
1092         address to,
1093         uint256 tokenId,
1094         bytes memory _data
1095     ) private returns (bool) {
1096         try
1097             ERC721A__IERC721Receiver(to).onERC721Received(
1098                 _msgSenderERC721A(),
1099                 from,
1100                 tokenId,
1101                 _data
1102             )
1103         returns (bytes4 retval) {
1104             return
1105                 retval ==
1106                 ERC721A__IERC721Receiver(to).onERC721Received.selector;
1107         } catch (bytes memory reason) {
1108             if (reason.length == 0) {
1109                 revert TransferToNonERC721ReceiverImplementer();
1110             } else {
1111                 assembly {
1112                     revert(add(32, reason), mload(reason))
1113                 }
1114             }
1115         }
1116     }
1117 
1118     /**
1119      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1120      * And also called before burning one token.
1121      *
1122      * startTokenId - the first token id to be transferred
1123      * quantity - the amount to be transferred
1124      *
1125      * Calling conditions:
1126      *
1127      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1128      * transferred to `to`.
1129      * - When `from` is zero, `tokenId` will be minted for `to`.
1130      * - When `to` is zero, `tokenId` will be burned by `from`.
1131      * - `from` and `to` are never both zero.
1132      */
1133     function _beforeTokenTransfers(
1134         address from,
1135         address to,
1136         uint256 startTokenId,
1137         uint256 quantity
1138     ) internal virtual {}
1139 
1140     /**
1141      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1142      * minting.
1143      * And also called after one token has been burned.
1144      *
1145      * startTokenId - the first token id to be transferred
1146      * quantity - the amount to be transferred
1147      *
1148      * Calling conditions:
1149      *
1150      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1151      * transferred to `to`.
1152      * - When `from` is zero, `tokenId` has been minted for `to`.
1153      * - When `to` is zero, `tokenId` has been burned by `from`.
1154      * - `from` and `to` are never both zero.
1155      */
1156     function _afterTokenTransfers(
1157         address from,
1158         address to,
1159         uint256 startTokenId,
1160         uint256 quantity
1161     ) internal virtual {}
1162 
1163     /**
1164      * @dev Returns the message sender (defaults to `msg.sender`).
1165      *
1166      * If you are writing GSN compatible contracts, you need to override this function.
1167      */
1168     function _msgSenderERC721A() internal view virtual returns (address) {
1169         return msg.sender;
1170     }
1171 
1172     /**
1173      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1174      */
1175     function _toString(uint256 value)
1176         internal
1177         pure
1178         returns (string memory ptr)
1179     {
1180         assembly {
1181             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1182             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1183             // We will need 1 32-byte word to store the length,
1184             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1185             ptr := add(mload(0x40), 128)
1186             // Update the free memory pointer to allocate.
1187             mstore(0x40, ptr)
1188 
1189             // Cache the end of the memory to calculate the length later.
1190             let end := ptr
1191 
1192             // We write the string from the rightmost digit to the leftmost digit.
1193             // The following is essentially a do-while loop that also handles the zero case.
1194             // Costs a bit more than early returning for the zero case,
1195             // but cheaper in terms of deployment and overall runtime costs.
1196             for {
1197                 // Initialize and perform the first pass without check.
1198                 let temp := value
1199                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1200                 ptr := sub(ptr, 1)
1201                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1202                 mstore8(ptr, add(48, mod(temp, 10)))
1203                 temp := div(temp, 10)
1204             } temp {
1205                 // Keep dividing `temp` until zero.
1206                 temp := div(temp, 10)
1207             } {
1208                 // Body of the for loop.
1209                 ptr := sub(ptr, 1)
1210                 mstore8(ptr, add(48, mod(temp, 10)))
1211             }
1212 
1213             let length := sub(end, ptr)
1214             // Move the pointer 32 bytes leftwards to make room for the length.
1215             ptr := sub(ptr, 32)
1216             // Store the length.
1217             mstore(ptr, length)
1218         }
1219     }
1220 }
1221 // File: @openzeppelin/contracts@4.5.0/utils/Strings.sol
1222 
1223 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
1224 
1225 pragma solidity ^0.8.0;
1226 
1227 /**
1228  * @dev String operations.
1229  */
1230 library Strings {
1231     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1232 
1233     /**
1234      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1235      */
1236     function toString(uint256 value) internal pure returns (string memory) {
1237         // Inspired by OraclizeAPI's implementation - MIT licence
1238         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1239 
1240         if (value == 0) {
1241             return "0";
1242         }
1243         uint256 temp = value;
1244         uint256 digits;
1245         while (temp != 0) {
1246             digits++;
1247             temp /= 10;
1248         }
1249         bytes memory buffer = new bytes(digits);
1250         while (value != 0) {
1251             digits -= 1;
1252             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1253             value /= 10;
1254         }
1255         return string(buffer);
1256     }
1257 
1258     /**
1259      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1260      */
1261     function toHexString(uint256 value) internal pure returns (string memory) {
1262         if (value == 0) {
1263             return "0x00";
1264         }
1265         uint256 temp = value;
1266         uint256 length = 0;
1267         while (temp != 0) {
1268             length++;
1269             temp >>= 8;
1270         }
1271         return toHexString(value, length);
1272     }
1273 
1274     /**
1275      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1276      */
1277     function toHexString(uint256 value, uint256 length)
1278         internal
1279         pure
1280         returns (string memory)
1281     {
1282         bytes memory buffer = new bytes(2 * length + 2);
1283         buffer[0] = "0";
1284         buffer[1] = "x";
1285         for (uint256 i = 2 * length + 1; i > 1; --i) {
1286             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1287             value >>= 4;
1288         }
1289         require(value == 0, "Strings: hex length insufficient");
1290         return string(buffer);
1291     }
1292 }
1293 
1294 // File: @openzeppelin/contracts@4.5.0/utils/Context.sol
1295 
1296 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1297 
1298 pragma solidity ^0.8.0;
1299 
1300 /**
1301  * @dev Provides information about the current execution context, including the
1302  * sender of the transaction and its data. While these are generally available
1303  * via msg.sender and msg.data, they should not be accessed in such a direct
1304  * manner, since when dealing with meta-transactions the account sending and
1305  * paying for execution may not be the actual sender (as far as an application
1306  * is concerned).
1307  *
1308  * This contract is only required for intermediate, library-like contracts.
1309  */
1310 abstract contract Context {
1311     function _msgSender() internal view virtual returns (address) {
1312         return msg.sender;
1313     }
1314 
1315     function _msgData() internal view virtual returns (bytes calldata) {
1316         return msg.data;
1317     }
1318 }
1319 
1320 // File: @openzeppelin/contracts@4.5.0/access/Ownable.sol
1321 
1322 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1323 
1324 pragma solidity ^0.8.0;
1325 
1326 /**
1327  * @dev Contract module which provides a basic access control mechanism, where
1328  * there is an account (an owner) that can be granted exclusive access to
1329  * specific functions.
1330  *
1331  * By default, the owner account will be the one that deploys the contract. This
1332  * can later be changed with {transferOwnership}.
1333  *
1334  * This module is used through inheritance. It will make available the modifier
1335  * `onlyOwner`, which can be applied to your functions to restrict their use to
1336  * the owner.
1337  */
1338 abstract contract Ownable is Context {
1339     address private _owner;
1340 
1341     event OwnershipTransferred(
1342         address indexed previousOwner,
1343         address indexed newOwner
1344     );
1345 
1346     /**
1347      * @dev Initializes the contract setting the deployer as the initial owner.
1348      */
1349     constructor() {
1350         _transferOwnership(_msgSender());
1351     }
1352 
1353     /**
1354      * @dev Returns the address of the current owner.
1355      */
1356     function owner() public view virtual returns (address) {
1357         return _owner;
1358     }
1359 
1360     /**
1361      * @dev Throws if called by any account other than the owner.
1362      */
1363     modifier onlyOwner() {
1364         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1365         _;
1366     }
1367 
1368     /**
1369      * @dev Leaves the contract without owner. It will not be possible to call
1370      * `onlyOwner` functions anymore. Can only be called by the current owner.
1371      *
1372      * NOTE: Renouncing ownership will leave the contract without an owner,
1373      * thereby removing any functionality that is only available to the owner.
1374      */
1375     function renounceOwnership() public virtual onlyOwner {
1376         _transferOwnership(address(0));
1377     }
1378 
1379     /**
1380      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1381      * Can only be called by the current owner.
1382      */
1383     function transferOwnership(address newOwner) public virtual onlyOwner {
1384         require(
1385             newOwner != address(0),
1386             "Ownable: new owner is the zero address"
1387         );
1388         _transferOwnership(newOwner);
1389     }
1390 
1391     /**
1392      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1393      * Internal function without access restriction.
1394      */
1395     function _transferOwnership(address newOwner) internal virtual {
1396         address oldOwner = _owner;
1397         _owner = newOwner;
1398         emit OwnershipTransferred(oldOwner, newOwner);
1399     }
1400 }
1401 
1402 // File: ITSNOTHING.sol
1403 
1404 pragma solidity ^0.8.11;
1405 
1406 contract Moondogs is ERC721A, Ownable {
1407     using Strings for uint256;
1408 
1409     // metadata
1410     string public baseURI = "";
1411 
1412     // constants
1413     uint256 public maxSupply = 10000;
1414     uint256 public freeMaxSupply = 5555;
1415     uint256 public price = 0.002 ether;
1416     uint256 public maxFreePerAddress = 20;
1417     uint256 public maxPerTx = 5;
1418 
1419     // sale settings
1420     bool public mintPaused = false;
1421     bool public revealed = false;
1422     string public notRevealedUri;
1423     mapping(address => uint256) private _freeMinted;
1424 
1425     /**
1426      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection, and by setting supply caps, mint indexes, and reserves
1427      */
1428     constructor() ERC721A("Moondogs", "Moondogs") {
1429         _safeMint(msg.sender, 10);
1430     }
1431 
1432     /**
1433      * @dev Gets base metadata URI
1434      */
1435     function _baseURI() internal view override returns (string memory) {
1436         return baseURI;
1437     }
1438 
1439     /**
1440      * @dev Sets base metadata URI, callable by owner
1441      */
1442     function setBaseUri(string memory _uri) external onlyOwner {
1443         baseURI = _uri;
1444     }
1445 
1446     /**
1447      * ------------ MINT STATE ------------
1448      */
1449 
1450     /**
1451      * @dev Pause/unpause sale or presale
1452      */
1453     function togglePauseMinting() external onlyOwner {
1454         mintPaused = !mintPaused;
1455     }
1456 
1457     /**
1458      * @dev Returns number of NFTs minted by addr
1459      */
1460     function numberMinted(address addr) public view returns (uint256) {
1461         return _numberMinted(addr);
1462     }
1463 
1464     function setPrice(uint256 _newPrice) external onlyOwner {
1465         price = _newPrice;
1466     }
1467 
1468     function reveal() public onlyOwner {
1469         revealed = true;
1470     }
1471 
1472     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1473         notRevealedUri = _notRevealedURI;
1474     }
1475 
1476     function withdraw() public onlyOwner {
1477         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1478         require(os, "Withdraw failed!");
1479     }
1480 
1481     function tokenURI(uint256 tokenId)
1482         public
1483         view
1484         virtual
1485         override
1486         returns (string memory)
1487     {
1488         require(
1489             _exists(tokenId),
1490             "ERC721Metadata: URI query for nonexistent token"
1491         );
1492         return
1493             revealed
1494                 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json"))
1495                 : notRevealedUri;
1496     }
1497 
1498     /**
1499      * @dev Public minting during public sale
1500      */
1501     function mint(uint256 count) external payable {
1502         require(count > 0, "Count can't be 0");
1503         require(!mintPaused, "Minting is currently paused");
1504 
1505         require(totalSupply() + count <= maxSupply, "Supply exceeded");
1506 
1507         uint256 cost = price;
1508 
1509         bool free = ((totalSupply() + count <= freeMaxSupply) &&
1510             (_freeMinted[msg.sender] + count <= maxFreePerAddress));
1511         if (free) {
1512             cost = 0;
1513             _freeMinted[msg.sender] += count;
1514             require(count < maxPerTx + 1, "Max per TX reached.");
1515         }
1516 
1517         require(count * cost <= msg.value, "Invalid funds provided");
1518 
1519         _safeMint(msg.sender, count);
1520     }
1521 }