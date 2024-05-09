1 // SPDX-License-Identifier: MIT
2 //                          T h e  B I r B  S c r E A m !   
3 //https://www.birbscream.wtf/
4 //
5 //   /##*   *####*        *######* /%,             *######* *######,        *##/  
6 //   /##*   *(/,            ,**, /@@@@@@@@@@@%,    ,/(####* *######,        *##/  
7 //   /##*    .            *%%&&&%(,,,,,,,,**/(%&&&&*  ..*#* *######((((((((((##/  
8 //   /#(*            .,,/&%#((///*.........,,**///(#&&#.    *(/(/(#,        *##/  
9 //   //.            .#@@@@&#/**,,,,,,,,/(((#((((/*,/(##(((,      .,.        *##/  
10 //                  .#@@@@&%#(/***,***/#&@@@@@@&%(****/&@@/                 *##/  
11 //             .,(&@@@@@@@@@@&(/**,/#&&(*.,**,,*/%@#/*,,**#&%#/****#&&#.    *##/  
12 //      *%&%*  *&&#((&@@@@@@@@%(/*,/#&&(, /@&#**/%@#/*,,.,,,(%&@@@@(,/#%(    ..   
13 //   ./&%***%@&%#((((&@@@@@@@@%((/,/#&&(,  ... .*#@#*,....*///(#&@@/ ,(&#         
14 //  .#@@#..,#@&#////(&@@@@@@@@(/*,,,*/(((#######((/*,,...,*////(&@@/ .*(#((#, *,  
15 //  .(&@#.  (%#/**//(&@@@@@@@%/,,.....,/#%%%%&%%(*.......,**//*/#%%* .,*(%&@*     
16 //  .(&@#.  ,****/(##&@@@&%(//***,,,,,,................,,,,**//*,..  .,*(#%%(**,  
17 //  .(&@#.  ,***,(&@@@@@%/*******,,,,,,,,.............,,******/*.    .,***,,#@@#. 
18 //  .(&@%*,,*(/**(&@@#///***************,,,,,*********,********,.     .,,,,,#@@#. 
19 //  .(&@%///////*/(((/*****************************************,.   ....*(#%/,,.  
20 //  .(&@&(((((//************************************************,,,,,,,,*#&@*     
21 //  .(&@&((/////********************************************///////*,,*/#%#/. ,,  
22 //  .(&@&(((/***********************************************///(///*,/#@#.  *(#/  
23 //      *@@@(****/////*****************************************//((%@%/.          
24 //      *@@@#///*//((////*********,***********//////***********(%&&(,             
25 //          (%%(**////(/////////////////**//////////***/////(#%%###,  ,(#####(,   
26 //          ,(#%%(/**//////////((((((((////(((((////***//(#%%%(*     ,,*,*,*(##/  
27 //           .(&@%///////*****///((((((((/(((((((((///*///%@&#.  ,(,        *##/  
28 //          ..   *&@&#//(((//****/(((((((((((((((((%@@@@@@/   .*(##,        *##/  
29 //   *//,   *((*  ,,*#@@@@&#(//////////////((#&@@@@@@@%*,,.   ...*#(////////(##/  
30 //  .#@@@@@@*       .#@@%(((/(%&@@@@@@@@@@@@&%(((((%@@%.         /@@@@@@@@@@@@@#. 
31 //   /######,        ,/*(%#(//%@@%//////#@&%##//(#%(*/*          ,#############/  
32 //   ,/////*.           *@&#((%&@(      *@%//(((#&@/             ./////////////*  
33 //   *//////.             /&@%,         ,(((####(*   ,,,,,,...,,.,///////((((((*  
34 //   *((((((,             *%%#,           /@@%,    *#%%%%%#((((((((((((((((((((*  
35 //                                                                                
36 
37 
38 pragma solidity ^0.8.4;
39 
40 /**
41  * @dev Interface of an ERC721A compliant contract.
42  */
43 interface IERC721A {
44     /**
45      * The caller must own the token or be an approved operator.
46      */
47     error ApprovalCallerNotOwnerNorApproved();
48 
49     /**
50      * The token does not exist.
51      */
52     error ApprovalQueryForNonexistentToken();
53 
54     /**
55      * The caller cannot approve to their own address.
56      */
57     error ApproveToCaller();
58 
59     /**
60      * The caller cannot approve to the current owner.
61      */
62     error ApprovalToCurrentOwner();
63 
64     /**
65      * Cannot query the balance for the zero address.
66      */
67     error BalanceQueryForZeroAddress();
68 
69     /**
70      * Cannot mint to the zero address.
71      */
72     error MintToZeroAddress();
73 
74     /**
75      * The quantity of tokens minted must be more than zero.
76      */
77     error MintZeroQuantity();
78 
79     /**
80      * The token does not exist.
81      */
82     error OwnerQueryForNonexistentToken();
83 
84     /**
85      * The caller must own the token or be an approved operator.
86      */
87     error TransferCallerNotOwnerNorApproved();
88 
89     /**
90      * The token must be owned by `from`.
91      */
92     error TransferFromIncorrectOwner();
93 
94     /**
95      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
96      */
97     error TransferToNonERC721ReceiverImplementer();
98 
99     /**
100      * Cannot transfer to the zero address.
101      */
102     error TransferToZeroAddress();
103 
104     /**
105      * The token does not exist.
106      */
107     error URIQueryForNonexistentToken();
108 
109     struct TokenOwnership {
110         // The address of the owner.
111         address addr;
112         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
113         uint64 startTimestamp;
114         // Whether the token has been burned.
115         bool burned;
116     }
117 
118     /**
119      * @dev Returns the total amount of tokens stored by the contract.
120      *
121      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
122      */
123     function totalSupply() external view returns (uint256);
124 
125     // ==============================
126     //            IERC165
127     // ==============================
128 
129     /**
130      * @dev Returns true if this contract implements the interface defined by
131      * `interfaceId`. See the corresponding
132      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
133      * to learn more about how these ids are created.
134      *
135      * This function call must use less than 30 000 gas.
136      */
137     function supportsInterface(bytes4 interfaceId) external view returns (bool);
138 
139     // ==============================
140     //            IERC721
141     // ==============================
142 
143     /**
144      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
145      */
146     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
147 
148     /**
149      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
150      */
151     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
152 
153     /**
154      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
155      */
156     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
157 
158     /**
159      * @dev Returns the number of tokens in ``owner``'s account.
160      */
161     function balanceOf(address owner) external view returns (uint256 balance);
162 
163     /**
164      * @dev Returns the owner of the `tokenId` token.
165      *
166      * Requirements:
167      *
168      * - `tokenId` must exist.
169      */
170     function ownerOf(uint256 tokenId) external view returns (address owner);
171 
172     /**
173      * @dev Safely transfers `tokenId` token from `from` to `to`.
174      *
175      * Requirements:
176      *
177      * - `from` cannot be the zero address.
178      * - `to` cannot be the zero address.
179      * - `tokenId` token must exist and be owned by `from`.
180      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
181      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
182      *
183      * Emits a {Transfer} event.
184      */
185     function safeTransferFrom(
186         address from,
187         address to,
188         uint256 tokenId,
189         bytes calldata data
190     ) external;
191 
192     /**
193      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
194      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
195      *
196      * Requirements:
197      *
198      * - `from` cannot be the zero address.
199      * - `to` cannot be the zero address.
200      * - `tokenId` token must exist and be owned by `from`.
201      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
202      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
203      *
204      * Emits a {Transfer} event.
205      */
206     function safeTransferFrom(
207         address from,
208         address to,
209         uint256 tokenId
210     ) external;
211 
212     /**
213      * @dev Transfers `tokenId` token from `from` to `to`.
214      *
215      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
216      *
217      * Requirements:
218      *
219      * - `from` cannot be the zero address.
220      * - `to` cannot be the zero address.
221      * - `tokenId` token must be owned by `from`.
222      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
223      *
224      * Emits a {Transfer} event.
225      */
226     function transferFrom(
227         address from,
228         address to,
229         uint256 tokenId
230     ) external;
231 
232     /**
233      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
234      * The approval is cleared when the token is transferred.
235      *
236      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
237      *
238      * Requirements:
239      *
240      * - The caller must own the token or be an approved operator.
241      * - `tokenId` must exist.
242      *
243      * Emits an {Approval} event.
244      */
245     function approve(address to, uint256 tokenId) external;
246 
247     /**
248      * @dev Approve or remove `operator` as an operator for the caller.
249      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
250      *
251      * Requirements:
252      *
253      * - The `operator` cannot be the caller.
254      *
255      * Emits an {ApprovalForAll} event.
256      */
257     function setApprovalForAll(address operator, bool _approved) external;
258 
259     /**
260      * @dev Returns the account approved for `tokenId` token.
261      *
262      * Requirements:
263      *
264      * - `tokenId` must exist.
265      */
266     function getApproved(uint256 tokenId) external view returns (address operator);
267 
268     /**
269      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
270      *
271      * See {setApprovalForAll}
272      */
273     function isApprovedForAll(address owner, address operator) external view returns (bool);
274 
275     // ==============================
276     //        IERC721Metadata
277     // ==============================
278 
279     /**
280      * @dev Returns the token collection name.
281      */
282     function name() external view returns (string memory);
283 
284     /**
285      * @dev Returns the token collection symbol.
286      */
287     function symbol() external view returns (string memory);
288 
289     /**
290      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
291      */
292     function tokenURI(uint256 tokenId) external view returns (string memory);
293 }
294 // File: contracts/ERC721A.sol
295 
296 
297 // ERC721A Contracts v4.0.0
298 // Creator: Chiru Labs
299 
300 pragma solidity ^0.8.4;
301 
302 
303 /**
304  * @dev ERC721 token receiver interface.
305  */
306 interface ERC721A__IERC721Receiver {
307     function onERC721Received(
308         address operator,
309         address from,
310         uint256 tokenId,
311         bytes calldata data
312     ) external returns (bytes4);
313 }
314 
315 /**
316  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
317  * the Metadata extension. Built to optimize for lower gas during batch mints.
318  *
319  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
320  *
321  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
322  *
323  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
324  */
325 contract ERC721A is IERC721A {
326     // Mask of an entry in packed address data.
327     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
328 
329     // The bit position of `numberMinted` in packed address data.
330     uint256 private constant BITPOS_NUMBER_MINTED = 64;
331 
332     // The bit position of `numberBurned` in packed address data.
333     uint256 private constant BITPOS_NUMBER_BURNED = 128;
334 
335     // The bit position of `aux` in packed address data.
336     uint256 private constant BITPOS_AUX = 192;
337 
338     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
339     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
340 
341     // The bit position of `startTimestamp` in packed ownership.
342     uint256 private constant BITPOS_START_TIMESTAMP = 160;
343 
344     // The bit mask of the `burned` bit in packed ownership.
345     uint256 private constant BITMASK_BURNED = 1 << 224;
346     
347     // The bit position of the `nextInitialized` bit in packed ownership.
348     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
349 
350     // The bit mask of the `nextInitialized` bit in packed ownership.
351     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
352 
353     // The tokenId of the next token to be minted.
354     uint256 private _currentIndex;
355 
356     // The number of tokens burned.
357     uint256 private _burnCounter;
358 
359     // Token name
360     string private _name;
361 
362     // Token symbol
363     string private _symbol;
364 
365     // Mapping from token ID to ownership details
366     // An empty struct value does not necessarily mean the token is unowned.
367     // See `_packedOwnershipOf` implementation for details.
368     //
369     // Bits Layout:
370     // - [0..159]   `addr`
371     // - [160..223] `startTimestamp`
372     // - [224]      `burned`
373     // - [225]      `nextInitialized`
374     mapping(uint256 => uint256) private _packedOwnerships;
375 
376     // Mapping owner address to address data.
377     //
378     // Bits Layout:
379     // - [0..63]    `balance`
380     // - [64..127]  `numberMinted`
381     // - [128..191] `numberBurned`
382     // - [192..255] `aux`
383     mapping(address => uint256) private _packedAddressData;
384 
385     // Mapping from token ID to approved address.
386     mapping(uint256 => address) private _tokenApprovals;
387 
388     // Mapping from owner to operator approvals
389     mapping(address => mapping(address => bool)) private _operatorApprovals;
390 
391     constructor(string memory name_, string memory symbol_) {
392         _name = name_;
393         _symbol = symbol_;
394         _currentIndex = _startTokenId();
395     }
396 
397     /**
398      * @dev Returns the starting token ID. 
399      * To change the starting token ID, please override this function.
400      */
401     function _startTokenId() internal view virtual returns (uint256) {
402         return 0;
403     }
404 
405     /**
406      * @dev Returns the next token ID to be minted.
407      */
408     function _nextTokenId() internal view returns (uint256) {
409         return _currentIndex;
410     }
411 
412     /**
413      * @dev Returns the total number of tokens in existence.
414      * Burned tokens will reduce the count. 
415      * To get the total number of tokens minted, please see `_totalMinted`.
416      */
417     function totalSupply() public view override returns (uint256) {
418         // Counter underflow is impossible as _burnCounter cannot be incremented
419         // more than `_currentIndex - _startTokenId()` times.
420         unchecked {
421             return _currentIndex - _burnCounter - _startTokenId();
422         }
423     }
424 
425     /**
426      * @dev Returns the total amount of tokens minted in the contract.
427      */
428     function _totalMinted() internal view returns (uint256) {
429         // Counter underflow is impossible as _currentIndex does not decrement,
430         // and it is initialized to `_startTokenId()`
431         unchecked {
432             return _currentIndex - _startTokenId();
433         }
434     }
435 
436     /**
437      * @dev Returns the total number of tokens burned.
438      */
439     function _totalBurned() internal view returns (uint256) {
440         return _burnCounter;
441     }
442 
443     /**
444      * @dev See {IERC165-supportsInterface}.
445      */
446     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
447         // The interface IDs are constants representing the first 4 bytes of the XOR of
448         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
449         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
450         return
451             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
452             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
453             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
454     }
455 
456     /**
457      * @dev See {IERC721-balanceOf}.
458      */
459     function balanceOf(address owner) public view override returns (uint256) {
460         if (owner == address(0)) revert BalanceQueryForZeroAddress();
461         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
462     }
463 
464     /**
465      * Returns the number of tokens minted by `owner`.
466      */
467     function _numberMinted(address owner) internal view returns (uint256) {
468         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
469     }
470 
471     /**
472      * Returns the number of tokens burned by or on behalf of `owner`.
473      */
474     function _numberBurned(address owner) internal view returns (uint256) {
475         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
476     }
477 
478     /**
479      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
480      */
481     function _getAux(address owner) internal view returns (uint64) {
482         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
483     }
484 
485     /**
486      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
487      * If there are multiple variables, please pack them into a uint64.
488      */
489     function _setAux(address owner, uint64 aux) internal {
490         uint256 packed = _packedAddressData[owner];
491         uint256 auxCasted;
492         assembly { // Cast aux without masking.
493             auxCasted := aux
494         }
495         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
496         _packedAddressData[owner] = packed;
497     }
498 
499     /**
500      * Returns the packed ownership data of `tokenId`.
501      */
502     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
503         uint256 curr = tokenId;
504 
505         unchecked {
506             if (_startTokenId() <= curr)
507                 if (curr < _currentIndex) {
508                     uint256 packed = _packedOwnerships[curr];
509                     // If not burned.
510                     if (packed & BITMASK_BURNED == 0) {
511                         // Invariant:
512                         // There will always be an ownership that has an address and is not burned
513                         // before an ownership that does not have an address and is not burned.
514                         // Hence, curr will not underflow.
515                         //
516                         // We can directly compare the packed value.
517                         // If the address is zero, packed is zero.
518                         while (packed == 0) {
519                             packed = _packedOwnerships[--curr];
520                         }
521                         return packed;
522                     }
523                 }
524         }
525         revert OwnerQueryForNonexistentToken();
526     }
527 
528     /**
529      * Returns the unpacked `TokenOwnership` struct from `packed`.
530      */
531     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
532         ownership.addr = address(uint160(packed));
533         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
534         ownership.burned = packed & BITMASK_BURNED != 0;
535     }
536 
537     /**
538      * Returns the unpacked `TokenOwnership` struct at `index`.
539      */
540     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
541         return _unpackedOwnership(_packedOwnerships[index]);
542     }
543 
544     /**
545      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
546      */
547     function _initializeOwnershipAt(uint256 index) internal {
548         if (_packedOwnerships[index] == 0) {
549             _packedOwnerships[index] = _packedOwnershipOf(index);
550         }
551     }
552 
553     /**
554      * Gas spent here starts off proportional to the maximum mint batch size.
555      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
556      */
557     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
558         return _unpackedOwnership(_packedOwnershipOf(tokenId));
559     }
560 
561     /**
562      * @dev See {IERC721-ownerOf}.
563      */
564     function ownerOf(uint256 tokenId) public view override returns (address) {
565         return address(uint160(_packedOwnershipOf(tokenId)));
566     }
567 
568     /**
569      * @dev See {IERC721Metadata-name}.
570      */
571     function name() public view virtual override returns (string memory) {
572         return _name;
573     }
574 
575     /**
576      * @dev See {IERC721Metadata-symbol}.
577      */
578     function symbol() public view virtual override returns (string memory) {
579         return _symbol;
580     }
581 
582     /**
583      * @dev See {IERC721Metadata-tokenURI}.
584      */
585     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
586         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
587 
588         string memory baseURI = _baseURI();
589         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
590     }
591 
592     /**
593      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
594      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
595      * by default, can be overriden in child contracts.
596      */
597     function _baseURI() internal view virtual returns (string memory) {
598         return '';
599     }
600 
601     /**
602      * @dev Casts the address to uint256 without masking.
603      */
604     function _addressToUint256(address value) private pure returns (uint256 result) {
605         assembly {
606             result := value
607         }
608     }
609 
610     /**
611      * @dev Casts the boolean to uint256 without branching.
612      */
613     function _boolToUint256(bool value) private pure returns (uint256 result) {
614         assembly {
615             result := value
616         }
617     }
618 
619     /**
620      * @dev See {IERC721-approve}.
621      */
622     function approve(address to, uint256 tokenId) public override {
623         address owner = address(uint160(_packedOwnershipOf(tokenId)));
624         if (to == owner) revert ApprovalToCurrentOwner();
625 
626         if (_msgSenderERC721A() != owner)
627             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
628                 revert ApprovalCallerNotOwnerNorApproved();
629             }
630 
631         _tokenApprovals[tokenId] = to;
632         emit Approval(owner, to, tokenId);
633     }
634 
635     /**
636      * @dev See {IERC721-getApproved}.
637      */
638     function getApproved(uint256 tokenId) public view override returns (address) {
639         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
640 
641         return _tokenApprovals[tokenId];
642     }
643 
644     /**
645      * @dev See {IERC721-setApprovalForAll}.
646      */
647     function setApprovalForAll(address operator, bool approved) public virtual override {
648         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
649 
650         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
651         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
652     }
653 
654     /**
655      * @dev See {IERC721-isApprovedForAll}.
656      */
657     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
658         return _operatorApprovals[owner][operator];
659     }
660 
661     /**
662      * @dev See {IERC721-transferFrom}.
663      */
664     function transferFrom(
665         address from,
666         address to,
667         uint256 tokenId
668     ) public virtual override {
669         _transfer(from, to, tokenId);
670     }
671 
672     /**
673      * @dev See {IERC721-safeTransferFrom}.
674      */
675     function safeTransferFrom(
676         address from,
677         address to,
678         uint256 tokenId
679     ) public virtual override {
680         safeTransferFrom(from, to, tokenId, '');
681     }
682 
683     /**
684      * @dev See {IERC721-safeTransferFrom}.
685      */
686     function safeTransferFrom(
687         address from,
688         address to,
689         uint256 tokenId,
690         bytes memory _data
691     ) public virtual override {
692         _transfer(from, to, tokenId);
693         if (to.code.length != 0)
694             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
695                 revert TransferToNonERC721ReceiverImplementer();
696             }
697     }
698 
699     /**
700      * @dev Returns whether `tokenId` exists.
701      *
702      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
703      *
704      * Tokens start existing when they are minted (`_mint`),
705      */
706     function _exists(uint256 tokenId) internal view returns (bool) {
707         return
708             _startTokenId() <= tokenId &&
709             tokenId < _currentIndex && // If within bounds,
710             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
711     }
712 
713     /**
714      * @dev Equivalent to `_safeMint(to, quantity, '')`.
715      */
716     function _safeMint(address to, uint256 quantity) internal {
717         _safeMint(to, quantity, '');
718     }
719 
720     /**
721      * @dev Safely mints `quantity` tokens and transfers them to `to`.
722      *
723      * Requirements:
724      *
725      * - If `to` refers to a smart contract, it must implement
726      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
727      * - `quantity` must be greater than 0.
728      *
729      * Emits a {Transfer} event.
730      */
731     function _safeMint(
732         address to,
733         uint256 quantity,
734         bytes memory _data
735     ) internal {
736         uint256 startTokenId = _currentIndex;
737         if (to == address(0)) revert MintToZeroAddress();
738         if (quantity == 0) revert MintZeroQuantity();
739 
740         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
741 
742         // Overflows are incredibly unrealistic.
743         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
744         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
745         unchecked {
746             // Updates:
747             // - `balance += quantity`.
748             // - `numberMinted += quantity`.
749             //
750             // We can directly add to the balance and number minted.
751             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
752 
753             // Updates:
754             // - `address` to the owner.
755             // - `startTimestamp` to the timestamp of minting.
756             // - `burned` to `false`.
757             // - `nextInitialized` to `quantity == 1`.
758             _packedOwnerships[startTokenId] =
759                 _addressToUint256(to) |
760                 (block.timestamp << BITPOS_START_TIMESTAMP) |
761                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
762 
763             uint256 updatedIndex = startTokenId;
764             uint256 end = updatedIndex + quantity;
765 
766             if (to.code.length != 0) {
767                 do {
768                     emit Transfer(address(0), to, updatedIndex);
769                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
770                         revert TransferToNonERC721ReceiverImplementer();
771                     }
772                 } while (updatedIndex < end);
773                 // Reentrancy protection
774                 if (_currentIndex != startTokenId) revert();
775             } else {
776                 do {
777                     emit Transfer(address(0), to, updatedIndex++);
778                 } while (updatedIndex < end);
779             }
780             _currentIndex = updatedIndex;
781         }
782         _afterTokenTransfers(address(0), to, startTokenId, quantity);
783     }
784 
785     /**
786      * @dev Mints `quantity` tokens and transfers them to `to`.
787      *
788      * Requirements:
789      *
790      * - `to` cannot be the zero address.
791      * - `quantity` must be greater than 0.
792      *
793      * Emits a {Transfer} event.
794      */
795     function _mint(address to, uint256 quantity) internal {
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
826             do {
827                 emit Transfer(address(0), to, updatedIndex++);
828             } while (updatedIndex < end);
829 
830             _currentIndex = updatedIndex;
831         }
832         _afterTokenTransfers(address(0), to, startTokenId, quantity);
833     }
834 
835     /**
836      * @dev Transfers `tokenId` from `from` to `to`.
837      *
838      * Requirements:
839      *
840      * - `to` cannot be the zero address.
841      * - `tokenId` token must be owned by `from`.
842      *
843      * Emits a {Transfer} event.
844      */
845     function _transfer(
846         address from,
847         address to,
848         uint256 tokenId
849     ) private {
850         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
851 
852         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
853 
854         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
855             isApprovedForAll(from, _msgSenderERC721A()) ||
856             getApproved(tokenId) == _msgSenderERC721A());
857 
858         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
859         if (to == address(0)) revert TransferToZeroAddress();
860 
861         _beforeTokenTransfers(from, to, tokenId, 1);
862 
863         // Clear approvals from the previous owner.
864         delete _tokenApprovals[tokenId];
865 
866         // Underflow of the sender's balance is impossible because we check for
867         // ownership above and the recipient's balance can't realistically overflow.
868         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
869         unchecked {
870             // We can directly increment and decrement the balances.
871             --_packedAddressData[from]; // Updates: `balance -= 1`.
872             ++_packedAddressData[to]; // Updates: `balance += 1`.
873 
874             // Updates:
875             // - `address` to the next owner.
876             // - `startTimestamp` to the timestamp of transfering.
877             // - `burned` to `false`.
878             // - `nextInitialized` to `true`.
879             _packedOwnerships[tokenId] =
880                 _addressToUint256(to) |
881                 (block.timestamp << BITPOS_START_TIMESTAMP) |
882                 BITMASK_NEXT_INITIALIZED;
883 
884             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
885             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
886                 uint256 nextTokenId = tokenId + 1;
887                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
888                 if (_packedOwnerships[nextTokenId] == 0) {
889                     // If the next slot is within bounds.
890                     if (nextTokenId != _currentIndex) {
891                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
892                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
893                     }
894                 }
895             }
896         }
897 
898         emit Transfer(from, to, tokenId);
899         _afterTokenTransfers(from, to, tokenId, 1);
900     }
901 
902     /**
903      * @dev Equivalent to `_burn(tokenId, false)`.
904      */
905     function _burn(uint256 tokenId) internal virtual {
906         _burn(tokenId, false);
907     }
908 
909     /**
910      * @dev Destroys `tokenId`.
911      * The approval is cleared when the token is burned.
912      *
913      * Requirements:
914      *
915      * - `tokenId` must exist.
916      *
917      * Emits a {Transfer} event.
918      */
919     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
920         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
921 
922         address from = address(uint160(prevOwnershipPacked));
923 
924         if (approvalCheck) {
925             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
926                 isApprovedForAll(from, _msgSenderERC721A()) ||
927                 getApproved(tokenId) == _msgSenderERC721A());
928 
929             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
930         }
931 
932         _beforeTokenTransfers(from, address(0), tokenId, 1);
933 
934         // Clear approvals from the previous owner.
935         delete _tokenApprovals[tokenId];
936 
937         // Underflow of the sender's balance is impossible because we check for
938         // ownership above and the recipient's balance can't realistically overflow.
939         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
940         unchecked {
941             // Updates:
942             // - `balance -= 1`.
943             // - `numberBurned += 1`.
944             //
945             // We can directly decrement the balance, and increment the number burned.
946             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
947             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
948 
949             // Updates:
950             // - `address` to the last owner.
951             // - `startTimestamp` to the timestamp of burning.
952             // - `burned` to `true`.
953             // - `nextInitialized` to `true`.
954             _packedOwnerships[tokenId] =
955                 _addressToUint256(from) |
956                 (block.timestamp << BITPOS_START_TIMESTAMP) |
957                 BITMASK_BURNED | 
958                 BITMASK_NEXT_INITIALIZED;
959 
960             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
961             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
962                 uint256 nextTokenId = tokenId + 1;
963                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
964                 if (_packedOwnerships[nextTokenId] == 0) {
965                     // If the next slot is within bounds.
966                     if (nextTokenId != _currentIndex) {
967                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
968                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
969                     }
970                 }
971             }
972         }
973 
974         emit Transfer(from, address(0), tokenId);
975         _afterTokenTransfers(from, address(0), tokenId, 1);
976 
977         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
978         unchecked {
979             _burnCounter++;
980         }
981     }
982 
983     /**
984      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
985      *
986      * @param from address representing the previous owner of the given token ID
987      * @param to target address that will receive the tokens
988      * @param tokenId uint256 ID of the token to be transferred
989      * @param _data bytes optional data to send along with the call
990      * @return bool whether the call correctly returned the expected magic value
991      */
992     function _checkContractOnERC721Received(
993         address from,
994         address to,
995         uint256 tokenId,
996         bytes memory _data
997     ) private returns (bool) {
998         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
999             bytes4 retval
1000         ) {
1001             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1002         } catch (bytes memory reason) {
1003             if (reason.length == 0) {
1004                 revert TransferToNonERC721ReceiverImplementer();
1005             } else {
1006                 assembly {
1007                     revert(add(32, reason), mload(reason))
1008                 }
1009             }
1010         }
1011     }
1012 
1013     /**
1014      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1015      * And also called before burning one token.
1016      *
1017      * startTokenId - the first token id to be transferred
1018      * quantity - the amount to be transferred
1019      *
1020      * Calling conditions:
1021      *
1022      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1023      * transferred to `to`.
1024      * - When `from` is zero, `tokenId` will be minted for `to`.
1025      * - When `to` is zero, `tokenId` will be burned by `from`.
1026      * - `from` and `to` are never both zero.
1027      */
1028     function _beforeTokenTransfers(
1029         address from,
1030         address to,
1031         uint256 startTokenId,
1032         uint256 quantity
1033     ) internal virtual {}
1034 
1035     /**
1036      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1037      * minting.
1038      * And also called after one token has been burned.
1039      *
1040      * startTokenId - the first token id to be transferred
1041      * quantity - the amount to be transferred
1042      *
1043      * Calling conditions:
1044      *
1045      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1046      * transferred to `to`.
1047      * - When `from` is zero, `tokenId` has been minted for `to`.
1048      * - When `to` is zero, `tokenId` has been burned by `from`.
1049      * - `from` and `to` are never both zero.
1050      */
1051     function _afterTokenTransfers(
1052         address from,
1053         address to,
1054         uint256 startTokenId,
1055         uint256 quantity
1056     ) internal virtual {}
1057 
1058     /**
1059      * @dev Returns the message sender (defaults to `msg.sender`).
1060      *
1061      * If you are writing GSN compatible contracts, you need to override this function.
1062      */
1063     function _msgSenderERC721A() internal view virtual returns (address) {
1064         return msg.sender;
1065     }
1066 
1067     /**
1068      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1069      */
1070     function _toString(uint256 value) internal pure returns (string memory ptr) {
1071         assembly {
1072             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1073             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1074             // We will need 1 32-byte word to store the length, 
1075             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1076             ptr := add(mload(0x40), 128)
1077             // Update the free memory pointer to allocate.
1078             mstore(0x40, ptr)
1079 
1080             // Cache the end of the memory to calculate the length later.
1081             let end := ptr
1082 
1083             // We write the string from the rightmost digit to the leftmost digit.
1084             // The following is essentially a do-while loop that also handles the zero case.
1085             // Costs a bit more than early returning for the zero case,
1086             // but cheaper in terms of deployment and overall runtime costs.
1087             for { 
1088                 // Initialize and perform the first pass without check.
1089                 let temp := value
1090                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1091                 ptr := sub(ptr, 1)
1092                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1093                 mstore8(ptr, add(48, mod(temp, 10)))
1094                 temp := div(temp, 10)
1095             } temp { 
1096                 // Keep dividing `temp` until zero.
1097                 temp := div(temp, 10)
1098             } { // Body of the for loop.
1099                 ptr := sub(ptr, 1)
1100                 mstore8(ptr, add(48, mod(temp, 10)))
1101             }
1102             
1103             let length := sub(end, ptr)
1104             // Move the pointer 32 bytes leftwards to make room for the length.
1105             ptr := sub(ptr, 32)
1106             // Store the length.
1107             mstore(ptr, length)
1108         }
1109     }
1110 }
1111 // File: contracts/Strings.sol
1112 
1113 
1114 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
1115 
1116 pragma solidity ^0.8.0;
1117 
1118 /**
1119  * @dev String operations.
1120  */
1121 library Strings {
1122     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1123 
1124     /**
1125      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1126      */
1127     function toString(uint256 value) internal pure returns (string memory) {
1128         // Inspired by OraclizeAPI's implementation - MIT licence
1129         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1130 
1131         if (value == 0) {
1132             return "0";
1133         }
1134         uint256 temp = value;
1135         uint256 digits;
1136         while (temp != 0) {
1137             digits++;
1138             temp /= 10;
1139         }
1140         bytes memory buffer = new bytes(digits);
1141         while (value != 0) {
1142             digits -= 1;
1143             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1144             value /= 10;
1145         }
1146         return string(buffer);
1147     }
1148 
1149     /**
1150      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1151      */
1152     function toHexString(uint256 value) internal pure returns (string memory) {
1153         if (value == 0) {
1154             return "0x00";
1155         }
1156         uint256 temp = value;
1157         uint256 length = 0;
1158         while (temp != 0) {
1159             length++;
1160             temp >>= 8;
1161         }
1162         return toHexString(value, length);
1163     }
1164 
1165     /**
1166      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1167      */
1168     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1169         bytes memory buffer = new bytes(2 * length + 2);
1170         buffer[0] = "0";
1171         buffer[1] = "x";
1172         for (uint256 i = 2 * length + 1; i > 1; --i) {
1173             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1174             value >>= 4;
1175         }
1176         require(value == 0, "Strings: hex length insufficient");
1177         return string(buffer);
1178     }
1179 }
1180 // File: contracts/ReentrancyGuard.sol
1181 
1182 
1183 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1184 
1185 pragma solidity ^0.8.0;
1186 
1187 /**
1188  * @dev Contract module that helps prevent reentrant calls to a function.
1189  *
1190  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1191  * available, which can be applied to functions to make sure there are no nested
1192  * (reentrant) calls to them.
1193  *
1194  * Note that because there is a single `nonReentrant` guard, functions marked as
1195  * `nonReentrant` may not call one another. This can be worked around by making
1196  * those functions `private`, and then adding `external` `nonReentrant` entry
1197  * points to them.
1198  *
1199  * TIP: If you would like to learn more about reentrancy and alternative ways
1200  * to protect against it, check out our blog post
1201  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1202  */
1203 abstract contract ReentrancyGuard {
1204     // Booleans are more expensive than uint256 or any type that takes up a full
1205     // word because each write operation emits an extra SLOAD to first read the
1206     // slot's contents, replace the bits taken up by the boolean, and then write
1207     // back. This is the compiler's defense against contract upgrades and
1208     // pointer aliasing, and it cannot be disabled.
1209 
1210     // The values being non-zero value makes deployment a bit more expensive,
1211     // but in exchange the refund on every call to nonReentrant will be lower in
1212     // amount. Since refunds are capped to a percentage of the total
1213     // transaction's gas, it is best to keep them low in cases like this one, to
1214     // increase the likelihood of the full refund coming into effect.
1215     uint256 private constant _NOT_ENTERED = 1;
1216     uint256 private constant _ENTERED = 2;
1217 
1218     uint256 private _status;
1219 
1220     constructor() {
1221         _status = _NOT_ENTERED;
1222     }
1223 
1224     /**
1225      * @dev Prevents a contract from calling itself, directly or indirectly.
1226      * Calling a `nonReentrant` function from another `nonReentrant`
1227      * function is not supported. It is possible to prevent this from happening
1228      * by making the `nonReentrant` function external, and making it call a
1229      * `private` function that does the actual work.
1230      */
1231     modifier nonReentrant() {
1232         // On the first call to nonReentrant, _notEntered will be true
1233         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1234 
1235         // Any calls to nonReentrant after this point will fail
1236         _status = _ENTERED;
1237 
1238         _;
1239 
1240         // By storing the original value once again, a refund is triggered (see
1241         // https://eips.ethereum.org/EIPS/eip-2200)
1242         _status = _NOT_ENTERED;
1243     }
1244 }
1245 // File: contracts/Context.sol
1246 
1247 
1248 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1249 
1250 pragma solidity ^0.8.0;
1251 
1252 /**
1253  * @dev Provides information about the current execution context, including the
1254  * sender of the transaction and its data. While these are generally available
1255  * via msg.sender and msg.data, they should not be accessed in such a direct
1256  * manner, since when dealing with meta-transactions the account sending and
1257  * paying for execution may not be the actual sender (as far as an application
1258  * is concerned).
1259  *
1260  * This contract is only required for intermediate, library-like contracts.
1261  */
1262 abstract contract Context {
1263     function _msgSender() internal view virtual returns (address) {
1264         return msg.sender;
1265     }
1266 
1267     function _msgData() internal view virtual returns (bytes calldata) {
1268         return msg.data;
1269     }
1270 }
1271 // File: contracts/Ownable.sol
1272 
1273 
1274 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1275 
1276 pragma solidity ^0.8.0;
1277 
1278 
1279 /**
1280  * @dev Contract module which provides a basic access control mechanism, where
1281  * there is an account (an owner) that can be granted exclusive access to
1282  * specific functions.
1283  *
1284  * By default, the owner account will be the one that deploys the contract. This
1285  * can later be changed with {transferOwnership}.
1286  *
1287  * This module is used through inheritance. It will make available the modifier
1288  * `onlyOwner`, which can be applied to your functions to restrict their use to
1289  * the owner.
1290  */
1291 abstract contract Ownable is Context {
1292     address private _owner;
1293 
1294     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1295 
1296     /**
1297      * @dev Initializes the contract setting the deployer as the initial owner.
1298      */
1299     constructor() {
1300         _transferOwnership(_msgSender());
1301     }
1302 
1303     /**
1304      * @dev Returns the address of the current owner.
1305      */
1306     function owner() public view virtual returns (address) {
1307         return _owner;
1308     }
1309 
1310     /**
1311      * @dev Throws if called by any account other than the owner.
1312      */
1313     modifier onlyOwner() {
1314         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1315         _;
1316     }
1317 
1318     /**
1319      * @dev Leaves the contract without owner. It will not be possible to call
1320      * `onlyOwner` functions anymore. Can only be called by the current owner.
1321      *
1322      * NOTE: Renouncing ownership will leave the contract without an owner,
1323      * thereby removing any functionality that is only available to the owner.
1324      */
1325     function renounceOwnership() public virtual onlyOwner {
1326         _transferOwnership(address(0));
1327     }
1328 
1329     /**
1330      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1331      * Can only be called by the current owner.
1332      */
1333     function transferOwnership(address newOwner) public virtual onlyOwner {
1334         require(newOwner != address(0), "Ownable: new owner is the zero address");
1335         _transferOwnership(newOwner);
1336     }
1337 
1338     /**
1339      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1340      * Internal function without access restriction.
1341      */
1342     function _transferOwnership(address newOwner) internal virtual {
1343         address oldOwner = _owner;
1344         _owner = newOwner;
1345         emit OwnershipTransferred(oldOwner, newOwner);
1346     }
1347 }
1348 // File: contracts/BirbScream.sol
1349 
1350 pragma solidity >=0.8.0;
1351 
1352 contract BirbScream is ERC721A, Ownable, ReentrancyGuard {
1353   using Strings for uint256;
1354 
1355   string public uriPrefix = '';
1356   string public uriSuffix = '.json';
1357   string public hiddenMetadataUri;
1358 
1359   // mint config
1360   uint256 public cost = 0.0069 ether; // 6900000000000000 wei
1361   uint256 public maxSupply = 4069;
1362   uint256 public maxMintAmount = 10;
1363   uint256 public maxPerTxn = 10;
1364   uint256 public maxFreeAmt = 1; // 1 free per wallet
1365 
1366   bool public revealed = false;
1367   bool public paused = true;
1368 
1369   constructor(
1370     string memory _tokenName,
1371     string memory _tokenSymbol,
1372     string memory _hiddenMetadataUri //https://birbscream.sfo3.digitaloceanspaces.com/unrevealed.json
1373   ) ERC721A(_tokenName, _tokenSymbol) {
1374     setHiddenMetadataUri(_hiddenMetadataUri);  
1375   }
1376 
1377   modifier mintCompliance(uint256 _mintAmount) {
1378     require(!paused, "Sale is paused...");
1379     require(totalSupply() + _mintAmount <= maxSupply, "Sold out!");
1380     require(_mintAmount > 0 && _mintAmount <= maxPerTxn, "Max birbs per transaction exceeded...");
1381     require(tx.origin == msg.sender, "Contract minters gets no birbs...");
1382     require(
1383       _mintAmount > 0 && numberMinted(msg.sender) + _mintAmount <= maxMintAmount,
1384        " max birbs reached..."
1385     );
1386     _;
1387   }
1388 
1389   modifier mintPriceCompliance(uint256 _mintAmount) {
1390     uint256 costToSubtract = 0;
1391     
1392     if (numberMinted(msg.sender) < maxFreeAmt) {
1393       uint256 freeMintsLeft = maxFreeAmt - numberMinted(msg.sender);
1394       costToSubtract = cost * freeMintsLeft;
1395     }
1396    
1397     require(msg.value >= cost * _mintAmount - costToSubtract, "Insufficient funds.");
1398     _;
1399   }
1400 
1401   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount) {
1402     _safeMint(_msgSender(), _mintAmount);
1403   }
1404   
1405   function mintForAddress(uint256 _mintAmount, address _receiver) public onlyOwner {
1406     require(totalSupply() + _mintAmount <= maxSupply, "Max supply exceeded!");
1407     _safeMint(_receiver, _mintAmount);
1408   }
1409 
1410   function _startTokenId() internal view virtual override returns (uint256) {
1411     return 1;
1412   }
1413 
1414   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1415     require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
1416 
1417     if (revealed == false) {
1418       return hiddenMetadataUri;
1419     }
1420 
1421     string memory currentBaseURI = _baseURI();
1422     return bytes(currentBaseURI).length > 0
1423         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1424         : '';
1425   }
1426 
1427   function setCost(uint256 _cost) public onlyOwner {
1428     cost = _cost;
1429   }
1430 
1431   function setMaxMintAmount(uint256 _maxMintAmount) public onlyOwner {
1432     maxMintAmount = _maxMintAmount;
1433   }
1434 
1435   function setRevealed(bool _state) public onlyOwner {
1436     revealed = _state;
1437   }
1438 
1439    function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1440     hiddenMetadataUri = _hiddenMetadataUri;
1441   }
1442 
1443   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1444     uriPrefix = _uriPrefix;
1445   }
1446 
1447   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1448     uriSuffix = _uriSuffix;
1449   }
1450 
1451   function setPaused(bool _state) public onlyOwner {
1452     paused = _state;
1453   }
1454 
1455   function numberMinted(address owner) public view returns (uint256) {
1456     return _numberMinted(owner);
1457   }
1458 
1459   function _baseURI() internal view virtual override returns (string memory) {
1460     return uriPrefix;
1461   }
1462 
1463   function withdraw() public onlyOwner nonReentrant {
1464     uint256 scbalance = address(this).balance * 100 / 100;
1465 
1466     (bool dev, ) = payable(0x77D7EEA7CE5A13eB1e20f1DA9Dc86135945d1c8f).call{value: scbalance}('');
1467     require(dev);
1468 
1469   }
1470 }