1 // SPDX-License-Identifier: MIT
2 //              (%%                               %&(/      // TOONVERSE STUDIOS PRESENTS!
3 //             (((            */%%#.              #&(/(     // THE DEVILCATS $TOON STAKING CONTRACT.
4 //            #*#*       ./#/(%%***/**,,,       .(%%/(.     // ARTIST: KEITH (GIP) MILLER.
5 //            ,*//.,   ,,##(#%(*/(((((((*//   .*#&#((*      // DEV: ERIC (SudoAkula) WEBB.
6 //             ,.,*..*/,#*#/%(,,*(#(######**/(##/*/*        // RULES: ONE $TOON A DAY WILL BE REWARED UNTIL 1,235,813 ARE CLAIMED.
7 //               ..*/(,*(/(#%.,,*///((/*** ,,,.,*,          // LEGAL: HOLDS NO FINANCIAL VALUE, STRICTLY FOR THE LOVE OF ART & BLOCKCHAIN
8 //                 ,(*./,#,(*..,********,,..   .                  /#**/#
9 //                 *,. ..,,*,.,*/(((///***,,,,,                     /(.
10 //                ,,.(//,,/((.((((*///#./**#.**.,                   /#,
11 //                  *,,**/(((((#####((((((//*,,.       /*******, .   (,
12 //                 %((,(%&%%%%&#(,/(((/%#%/(./*,       ,***********( //.
13 //                 %#,(((/&##%%(,/(((((*%%# . ,,       ,**************/, *
14 //                 %%,(#,(/#(%#/,( . ((*&%#**,,.   ,  ,,**************/*******.
15 //                  %,(  ((%*(#,,(/  ((*&%(..,,.  @(   ,,,,,/,,...,***/*,*******
16 //               & &##,  ((#**(,./(  (/,%#/..,.%%&.  *,,,,,.          ,,.*********
17 //               .@*&#,.,../*,**.,*  *,,#(/*((%/,@. .,,,,,,,,#(,      /*,(@&@******..
18 //                (@,#,*////*. .*(%&%%&@@/*(&#*@.&&...*(########* #%(@/(..@@%&@******,*,
19 //                ,*#&(.     . %@@@@&&@@@@&%/&#@// ,**/(##((//**( ((#&&(, @@@@@@********.,
20 //                  ,*%@%*,.,./#%&&%@@@@@&#,%/%#,,,**//***,,,,,,,***/%(#%%@@(#%    *******.,
21 //                 *  ./@@@&#(/#%%%(*///  *##*.*******,,.          ,,*(#%@@@(&%#    *******,.,
22 //                  @@/ * ,. ..  /*##(%#&,#,(((((,..**               ,,**//,**       ,,,,,,,,,,,*
23 //                   &&# /&* %* #&#,,/&*#,%%%%%%/,,,..                    ..            ,,,,,,,,%%%%&&%%%%%&&##%%
24 //                    . &@*,*&***/.,,.  ########%/,,*,....                ,.              ,,*%%%#(...       .#%%&%%
25 //                           ,,       ###%%#((####%. .,**..*(**///*.(      ,,             %#%(/.......        #%%%%%%
26 //                                  .%##,%#(/((####( .  , ###/,&&@&  #.,,,,,,,...     ##(#/*    ........            #%
27 //           **/(%%               */##*/#(,** /(,######%%%&#%(&%%%,*%.,,,,,,........,**,,.   ...........
28 //        &@%/#/**,             (. ##/.#/* , *.///((,####%%%%%%%%%%%.,,,.,,.,,,........     .. .........
29 //      #/@@@@@@@%@@@         .(*.(,* ** ,.  ..,,.*.,*(,###########.,,.,,..,,,......               . .
30 //     @@&%#%&@@%@@(///,  ,//(/,##/(/,   ,.    ...,,**.*,/*,*#####...,,,....,,.,.                .
31 //     (*@@@@@&%&###### #.#*%%%%. **,     .       ...,,*,,,, */(....,,,,,,,,.,                 ,
32 //      (#%%%%(((##/#%# %#(.%#(/*,                  ........,,,......,,.....                 .
33 //      */*,,,,../*((((((((//**           ..        ,,,,,,..........,. ..               .,.
34 //     #%&&%//,.                          ,         ,,,,,,,,,,,...    .            .
35 //    /%%%%%%((*,                                 ,.********,,,,,                .
36 //    *(*%///**/(                                  **********
37 //    ***#%****(                                   ,/****/,
38 //    /(,*///**                                    //////
39 //   ///*/*(/*,                                     //,
40 //  (**/*#(%//
41 //   /#%&%%&&#                                  .
42 // File: github.com/chiru-labs/ERC721A/blob/main/contracts/IERC721A.sol
43 
44 
45 // ERC721A Contracts v4.2.3
46 // Creator: Chiru Labs
47 
48 pragma solidity ^0.8.4;
49 
50 /**
51  * @dev Interface of ERC721A.
52  */
53 interface IERC721A {
54     /**
55      * The caller must own the token or be an approved operator.
56      */
57     error ApprovalCallerNotOwnerNorApproved();
58 
59     /**
60      * The token does not exist.
61      */
62     error ApprovalQueryForNonexistentToken();
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
95      * Cannot safely transfer to a contract that does not implement the
96      * ERC721Receiver interface.
97      */
98     error TransferToNonERC721ReceiverImplementer();
99 
100     /**
101      * Cannot transfer to the zero address.
102      */
103     error TransferToZeroAddress();
104 
105     /**
106      * The token does not exist.
107      */
108     error URIQueryForNonexistentToken();
109 
110     /**
111      * The `quantity` minted with ERC2309 exceeds the safety limit.
112      */
113     error MintERC2309QuantityExceedsLimit();
114 
115     /**
116      * The `extraData` cannot be set on an unintialized ownership slot.
117      */
118     error OwnershipNotInitializedForExtraData();
119 
120     // =============================================================
121     //                            STRUCTS
122     // =============================================================
123 
124     struct TokenOwnership {
125         // The address of the owner.
126         address addr;
127         // Stores the start time of ownership with minimal overhead for tokenomics.
128         uint64 startTimestamp;
129         // Whether the token has been burned.
130         bool burned;
131         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
132         uint24 extraData;
133     }
134 
135     // =============================================================
136     //                         TOKEN COUNTERS
137     // =============================================================
138 
139     /**
140      * @dev Returns the total number of tokens in existence.
141      * Burned tokens will reduce the count.
142      * To get the total number of tokens minted, please see {_totalMinted}.
143      */
144     function totalSupply() external view returns (uint256);
145 
146     // =============================================================
147     //                            IERC165
148     // =============================================================
149 
150     /**
151      * @dev Returns true if this contract implements the interface defined by
152      * `interfaceId`. See the corresponding
153      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
154      * to learn more about how these ids are created.
155      *
156      * This function call must use less than 30000 gas.
157      */
158     function supportsInterface(bytes4 interfaceId) external view returns (bool);
159 
160     // =============================================================
161     //                            IERC721
162     // =============================================================
163 
164     /**
165      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
166      */
167     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
168 
169     /**
170      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
171      */
172     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
173 
174     /**
175      * @dev Emitted when `owner` enables or disables
176      * (`approved`) `operator` to manage all of its assets.
177      */
178     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
179 
180     /**
181      * @dev Returns the number of tokens in `owner`'s account.
182      */
183     function balanceOf(address owner) external view returns (uint256 balance);
184 
185     /**
186      * @dev Returns the owner of the `tokenId` token.
187      *
188      * Requirements:
189      *
190      * - `tokenId` must exist.
191      */
192     function ownerOf(uint256 tokenId) external view returns (address owner);
193 
194     /**
195      * @dev Safely transfers `tokenId` token from `from` to `to`,
196      * checking first that contract recipients are aware of the ERC721 protocol
197      * to prevent tokens from being forever locked.
198      *
199      * Requirements:
200      *
201      * - `from` cannot be the zero address.
202      * - `to` cannot be the zero address.
203      * - `tokenId` token must exist and be owned by `from`.
204      * - If the caller is not `from`, it must be have been allowed to move
205      * this token by either {approve} or {setApprovalForAll}.
206      * - If `to` refers to a smart contract, it must implement
207      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
208      *
209      * Emits a {Transfer} event.
210      */
211     function safeTransferFrom(
212         address from,
213         address to,
214         uint256 tokenId,
215         bytes calldata data
216     ) external payable;
217 
218     /**
219      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
220      */
221     function safeTransferFrom(
222         address from,
223         address to,
224         uint256 tokenId
225     ) external payable;
226 
227     /**
228      * @dev Transfers `tokenId` from `from` to `to`.
229      *
230      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
231      * whenever possible.
232      *
233      * Requirements:
234      *
235      * - `from` cannot be the zero address.
236      * - `to` cannot be the zero address.
237      * - `tokenId` token must be owned by `from`.
238      * - If the caller is not `from`, it must be approved to move this token
239      * by either {approve} or {setApprovalForAll}.
240      *
241      * Emits a {Transfer} event.
242      */
243     function transferFrom(
244         address from,
245         address to,
246         uint256 tokenId
247     ) external payable;
248 
249     /**
250      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
251      * The approval is cleared when the token is transferred.
252      *
253      * Only a single account can be approved at a time, so approving the
254      * zero address clears previous approvals.
255      *
256      * Requirements:
257      *
258      * - The caller must own the token or be an approved operator.
259      * - `tokenId` must exist.
260      *
261      * Emits an {Approval} event.
262      */
263     function approve(address to, uint256 tokenId) external payable;
264 
265     /**
266      * @dev Approve or remove `operator` as an operator for the caller.
267      * Operators can call {transferFrom} or {safeTransferFrom}
268      * for any token owned by the caller.
269      *
270      * Requirements:
271      *
272      * - The `operator` cannot be the caller.
273      *
274      * Emits an {ApprovalForAll} event.
275      */
276     function setApprovalForAll(address operator, bool _approved) external;
277 
278     /**
279      * @dev Returns the account approved for `tokenId` token.
280      *
281      * Requirements:
282      *
283      * - `tokenId` must exist.
284      */
285     function getApproved(uint256 tokenId) external view returns (address operator);
286 
287     /**
288      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
289      *
290      * See {setApprovalForAll}.
291      */
292     function isApprovedForAll(address owner, address operator) external view returns (bool);
293 
294     // =============================================================
295     //                        IERC721Metadata
296     // =============================================================
297 
298     /**
299      * @dev Returns the token collection name.
300      */
301     function name() external view returns (string memory);
302 
303     /**
304      * @dev Returns the token collection symbol.
305      */
306     function symbol() external view returns (string memory);
307 
308     /**
309      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
310      */
311     function tokenURI(uint256 tokenId) external view returns (string memory);
312 
313     // =============================================================
314     //                           IERC2309
315     // =============================================================
316 
317     /**
318      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
319      * (inclusive) is transferred from `from` to `to`, as defined in the
320      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
321      *
322      * See {_mintERC2309} for more details.
323      */
324     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
325 }
326 
327 // File: github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol
328 
329 
330 // ERC721A Contracts v4.2.3
331 // Creator: Chiru Labs
332 
333 pragma solidity ^0.8.4;
334 
335 
336 /**
337  * @dev Interface of ERC721 token receiver.
338  */
339 interface ERC721A__IERC721Receiver {
340     function onERC721Received(
341         address operator,
342         address from,
343         uint256 tokenId,
344         bytes calldata data
345     ) external returns (bytes4);
346 }
347 
348 /**
349  * @title ERC721A
350  *
351  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
352  * Non-Fungible Token Standard, including the Metadata extension.
353  * Optimized for lower gas during batch mints.
354  *
355  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
356  * starting from `_startTokenId()`.
357  *
358  * Assumptions:
359  *
360  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
361  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
362  */
363 contract ERC721A is IERC721A {
364     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
365     struct TokenApprovalRef {
366         address value;
367     }
368 
369     // =============================================================
370     //                           CONSTANTS
371     // =============================================================
372 
373     // Mask of an entry in packed address data.
374     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
375 
376     // The bit position of `numberMinted` in packed address data.
377     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
378 
379     // The bit position of `numberBurned` in packed address data.
380     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
381 
382     // The bit position of `aux` in packed address data.
383     uint256 private constant _BITPOS_AUX = 192;
384 
385     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
386     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
387 
388     // The bit position of `startTimestamp` in packed ownership.
389     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
390 
391     // The bit mask of the `burned` bit in packed ownership.
392     uint256 private constant _BITMASK_BURNED = 1 << 224;
393 
394     // The bit position of the `nextInitialized` bit in packed ownership.
395     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
396 
397     // The bit mask of the `nextInitialized` bit in packed ownership.
398     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
399 
400     // The bit position of `extraData` in packed ownership.
401     uint256 private constant _BITPOS_EXTRA_DATA = 232;
402 
403     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
404     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
405 
406     // The mask of the lower 160 bits for addresses.
407     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
408 
409     // The maximum `quantity` that can be minted with {_mintERC2309}.
410     // This limit is to prevent overflows on the address data entries.
411     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
412     // is required to cause an overflow, which is unrealistic.
413     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
414 
415     // The `Transfer` event signature is given by:
416     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
417     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
418         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
419 
420     // =============================================================
421     //                            STORAGE
422     // =============================================================
423 
424     // The next token ID to be minted.
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
438     // See {_packedOwnershipOf} implementation for details.
439     //
440     // Bits Layout:
441     // - [0..159]   `addr`
442     // - [160..223] `startTimestamp`
443     // - [224]      `burned`
444     // - [225]      `nextInitialized`
445     // - [232..255] `extraData`
446     mapping(uint256 => uint256) private _packedOwnerships;
447 
448     // Mapping owner address to address data.
449     //
450     // Bits Layout:
451     // - [0..63]    `balance`
452     // - [64..127]  `numberMinted`
453     // - [128..191] `numberBurned`
454     // - [192..255] `aux`
455     mapping(address => uint256) private _packedAddressData;
456 
457     // Mapping from token ID to approved address.
458     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
459 
460     // Mapping from owner to operator approvals
461     mapping(address => mapping(address => bool)) private _operatorApprovals;
462 
463     // =============================================================
464     //                          CONSTRUCTOR
465     // =============================================================
466 
467     constructor(string memory name_, string memory symbol_) {
468         _name = name_;
469         _symbol = symbol_;
470         _currentIndex = _startTokenId();
471     }
472 
473     // =============================================================
474     //                   TOKEN COUNTING OPERATIONS
475     // =============================================================
476 
477     /**
478      * @dev Returns the starting token ID.
479      * To change the starting token ID, please override this function.
480      */
481     function _startTokenId() internal view virtual returns (uint256) {
482         return 0;
483     }
484 
485     /**
486      * @dev Returns the next token ID to be minted.
487      */
488     function _nextTokenId() internal view virtual returns (uint256) {
489         return _currentIndex;
490     }
491 
492     /**
493      * @dev Returns the total number of tokens in existence.
494      * Burned tokens will reduce the count.
495      * To get the total number of tokens minted, please see {_totalMinted}.
496      */
497     function totalSupply() public view virtual override returns (uint256) {
498         // Counter underflow is impossible as _burnCounter cannot be incremented
499         // more than `_currentIndex - _startTokenId()` times.
500         unchecked {
501             return _currentIndex - _burnCounter - _startTokenId();
502         }
503     }
504 
505     /**
506      * @dev Returns the total amount of tokens minted in the contract.
507      */
508     function _totalMinted() internal view virtual returns (uint256) {
509         // Counter underflow is impossible as `_currentIndex` does not decrement,
510         // and it is initialized to `_startTokenId()`.
511         unchecked {
512             return _currentIndex - _startTokenId();
513         }
514     }
515 
516     /**
517      * @dev Returns the total number of tokens burned.
518      */
519     function _totalBurned() internal view virtual returns (uint256) {
520         return _burnCounter;
521     }
522 
523     // =============================================================
524     //                    ADDRESS DATA OPERATIONS
525     // =============================================================
526 
527     /**
528      * @dev Returns the number of tokens in `owner`'s account.
529      */
530     function balanceOf(address owner) public view virtual override returns (uint256) {
531         if (owner == address(0)) _revert(BalanceQueryForZeroAddress.selector);
532         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
533     }
534 
535     /**
536      * Returns the number of tokens minted by `owner`.
537      */
538     function _numberMinted(address owner) internal view returns (uint256) {
539         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
540     }
541 
542     /**
543      * Returns the number of tokens burned by or on behalf of `owner`.
544      */
545     function _numberBurned(address owner) internal view returns (uint256) {
546         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
547     }
548 
549     /**
550      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
551      */
552     function _getAux(address owner) internal view returns (uint64) {
553         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
554     }
555 
556     /**
557      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
558      * If there are multiple variables, please pack them into a uint64.
559      */
560     function _setAux(address owner, uint64 aux) internal virtual {
561         uint256 packed = _packedAddressData[owner];
562         uint256 auxCasted;
563         // Cast `aux` with assembly to avoid redundant masking.
564         assembly {
565             auxCasted := aux
566         }
567         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
568         _packedAddressData[owner] = packed;
569     }
570 
571     // =============================================================
572     //                            IERC165
573     // =============================================================
574 
575     /**
576      * @dev Returns true if this contract implements the interface defined by
577      * `interfaceId`. See the corresponding
578      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
579      * to learn more about how these ids are created.
580      *
581      * This function call must use less than 30000 gas.
582      */
583     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
584         // The interface IDs are constants representing the first 4 bytes
585         // of the XOR of all function selectors in the interface.
586         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
587         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
588         return
589             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
590             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
591             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
592     }
593 
594     // =============================================================
595     //                        IERC721Metadata
596     // =============================================================
597 
598     /**
599      * @dev Returns the token collection name.
600      */
601     function name() public view virtual override returns (string memory) {
602         return _name;
603     }
604 
605     /**
606      * @dev Returns the token collection symbol.
607      */
608     function symbol() public view virtual override returns (string memory) {
609         return _symbol;
610     }
611 
612     /**
613      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
614      */
615     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
616         if (!_exists(tokenId)) _revert(URIQueryForNonexistentToken.selector);
617 
618         string memory baseURI = _baseURI();
619         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
620     }
621 
622     /**
623      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
624      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
625      * by default, it can be overridden in child contracts.
626      */
627     function _baseURI() internal view virtual returns (string memory) {
628         return '';
629     }
630 
631     // =============================================================
632     //                     OWNERSHIPS OPERATIONS
633     // =============================================================
634 
635     /**
636      * @dev Returns the owner of the `tokenId` token.
637      *
638      * Requirements:
639      *
640      * - `tokenId` must exist.
641      */
642     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
643         return address(uint160(_packedOwnershipOf(tokenId)));
644     }
645 
646     /**
647      * @dev Gas spent here starts off proportional to the maximum mint batch size.
648      * It gradually moves to O(1) as tokens get transferred around over time.
649      */
650     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
651         return _unpackedOwnership(_packedOwnershipOf(tokenId));
652     }
653 
654     /**
655      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
656      */
657     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
658         return _unpackedOwnership(_packedOwnerships[index]);
659     }
660 
661     /**
662      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
663      */
664     function _initializeOwnershipAt(uint256 index) internal virtual {
665         if (_packedOwnerships[index] == 0) {
666             _packedOwnerships[index] = _packedOwnershipOf(index);
667         }
668     }
669 
670     /**
671      * Returns the packed ownership data of `tokenId`.
672      */
673     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256 packed) {
674         if (_startTokenId() <= tokenId) {
675             packed = _packedOwnerships[tokenId];
676             // If not burned.
677             if (packed & _BITMASK_BURNED == 0) {
678                 // If the data at the starting slot does not exist, start the scan.
679                 if (packed == 0) {
680                     if (tokenId >= _currentIndex) _revert(OwnerQueryForNonexistentToken.selector);
681                     // Invariant:
682                     // There will always be an initialized ownership slot
683                     // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
684                     // before an unintialized ownership slot
685                     // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
686                     // Hence, `tokenId` will not underflow.
687                     //
688                     // We can directly compare the packed value.
689                     // If the address is zero, packed will be zero.
690                     for (;;) {
691                         unchecked {
692                             packed = _packedOwnerships[--tokenId];
693                         }
694                         if (packed == 0) continue;
695                         return packed;
696                     }
697                 }
698                 // Otherwise, the data exists and is not burned. We can skip the scan.
699                 // This is possible because we have already achieved the target condition.
700                 // This saves 2143 gas on transfers of initialized tokens.
701                 return packed;
702             }
703         }
704         _revert(OwnerQueryForNonexistentToken.selector);
705     }
706 
707     /**
708      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
709      */
710     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
711         ownership.addr = address(uint160(packed));
712         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
713         ownership.burned = packed & _BITMASK_BURNED != 0;
714         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
715     }
716 
717     /**
718      * @dev Packs ownership data into a single uint256.
719      */
720     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
721         assembly {
722             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
723             owner := and(owner, _BITMASK_ADDRESS)
724             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
725             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
726         }
727     }
728 
729     /**
730      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
731      */
732     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
733         // For branchless setting of the `nextInitialized` flag.
734         assembly {
735             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
736             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
737         }
738     }
739 
740     // =============================================================
741     //                      APPROVAL OPERATIONS
742     // =============================================================
743 
744     /**
745      * @dev Gives permission to `to` to transfer `tokenId` token to another account. See {ERC721A-_approve}.
746      *
747      * Requirements:
748      *
749      * - The caller must own the token or be an approved operator.
750      */
751     function approve(address to, uint256 tokenId) public payable virtual override {
752         _approve(to, tokenId, true);
753     }
754 
755     /**
756      * @dev Returns the account approved for `tokenId` token.
757      *
758      * Requirements:
759      *
760      * - `tokenId` must exist.
761      */
762     function getApproved(uint256 tokenId) public view virtual override returns (address) {
763         if (!_exists(tokenId)) _revert(ApprovalQueryForNonexistentToken.selector);
764 
765         return _tokenApprovals[tokenId].value;
766     }
767 
768     /**
769      * @dev Approve or remove `operator` as an operator for the caller.
770      * Operators can call {transferFrom} or {safeTransferFrom}
771      * for any token owned by the caller.
772      *
773      * Requirements:
774      *
775      * - The `operator` cannot be the caller.
776      *
777      * Emits an {ApprovalForAll} event.
778      */
779     function setApprovalForAll(address operator, bool approved) public virtual override {
780         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
781         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
782     }
783 
784     /**
785      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
786      *
787      * See {setApprovalForAll}.
788      */
789     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
790         return _operatorApprovals[owner][operator];
791     }
792 
793     /**
794      * @dev Returns whether `tokenId` exists.
795      *
796      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
797      *
798      * Tokens start existing when they are minted. See {_mint}.
799      */
800     function _exists(uint256 tokenId) internal view virtual returns (bool) {
801         return
802             _startTokenId() <= tokenId &&
803             tokenId < _currentIndex && // If within bounds,
804             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
805     }
806 
807     /**
808      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
809      */
810     function _isSenderApprovedOrOwner(
811         address approvedAddress,
812         address owner,
813         address msgSender
814     ) private pure returns (bool result) {
815         assembly {
816             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
817             owner := and(owner, _BITMASK_ADDRESS)
818             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
819             msgSender := and(msgSender, _BITMASK_ADDRESS)
820             // `msgSender == owner || msgSender == approvedAddress`.
821             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
822         }
823     }
824 
825     /**
826      * @dev Returns the storage slot and value for the approved address of `tokenId`.
827      */
828     function _getApprovedSlotAndAddress(uint256 tokenId)
829         private
830         view
831         returns (uint256 approvedAddressSlot, address approvedAddress)
832     {
833         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
834         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
835         assembly {
836             approvedAddressSlot := tokenApproval.slot
837             approvedAddress := sload(approvedAddressSlot)
838         }
839     }
840 
841     // =============================================================
842     //                      TRANSFER OPERATIONS
843     // =============================================================
844 
845     /**
846      * @dev Transfers `tokenId` from `from` to `to`.
847      *
848      * Requirements:
849      *
850      * - `from` cannot be the zero address.
851      * - `to` cannot be the zero address.
852      * - `tokenId` token must be owned by `from`.
853      * - If the caller is not `from`, it must be approved to move this token
854      * by either {approve} or {setApprovalForAll}.
855      *
856      * Emits a {Transfer} event.
857      */
858     function transferFrom(
859         address from,
860         address to,
861         uint256 tokenId
862     ) public payable virtual override {
863         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
864 
865         // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
866         from = address(uint160(uint256(uint160(from)) & _BITMASK_ADDRESS));
867 
868         if (address(uint160(prevOwnershipPacked)) != from) _revert(TransferFromIncorrectOwner.selector);
869 
870         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
871 
872         // The nested ifs save around 20+ gas over a compound boolean condition.
873         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
874             if (!isApprovedForAll(from, _msgSenderERC721A())) _revert(TransferCallerNotOwnerNorApproved.selector);
875 
876         _beforeTokenTransfers(from, to, tokenId, 1);
877 
878         // Clear approvals from the previous owner.
879         assembly {
880             if approvedAddress {
881                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
882                 sstore(approvedAddressSlot, 0)
883             }
884         }
885 
886         // Underflow of the sender's balance is impossible because we check for
887         // ownership above and the recipient's balance can't realistically overflow.
888         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
889         unchecked {
890             // We can directly increment and decrement the balances.
891             --_packedAddressData[from]; // Updates: `balance -= 1`.
892             ++_packedAddressData[to]; // Updates: `balance += 1`.
893 
894             // Updates:
895             // - `address` to the next owner.
896             // - `startTimestamp` to the timestamp of transfering.
897             // - `burned` to `false`.
898             // - `nextInitialized` to `true`.
899             _packedOwnerships[tokenId] = _packOwnershipData(
900                 to,
901                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
902             );
903 
904             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
905             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
906                 uint256 nextTokenId = tokenId + 1;
907                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
908                 if (_packedOwnerships[nextTokenId] == 0) {
909                     // If the next slot is within bounds.
910                     if (nextTokenId != _currentIndex) {
911                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
912                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
913                     }
914                 }
915             }
916         }
917 
918         // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
919         uint256 toMasked = uint256(uint160(to)) & _BITMASK_ADDRESS;
920         assembly {
921             // Emit the `Transfer` event.
922             log4(
923                 0, // Start of data (0, since no data).
924                 0, // End of data (0, since no data).
925                 _TRANSFER_EVENT_SIGNATURE, // Signature.
926                 from, // `from`.
927                 toMasked, // `to`.
928                 tokenId // `tokenId`.
929             )
930         }
931         if (toMasked == 0) _revert(TransferToZeroAddress.selector);
932 
933         _afterTokenTransfers(from, to, tokenId, 1);
934     }
935 
936     /**
937      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
938      */
939     function safeTransferFrom(
940         address from,
941         address to,
942         uint256 tokenId
943     ) public payable virtual override {
944         safeTransferFrom(from, to, tokenId, '');
945     }
946 
947     /**
948      * @dev Safely transfers `tokenId` token from `from` to `to`.
949      *
950      * Requirements:
951      *
952      * - `from` cannot be the zero address.
953      * - `to` cannot be the zero address.
954      * - `tokenId` token must exist and be owned by `from`.
955      * - If the caller is not `from`, it must be approved to move this token
956      * by either {approve} or {setApprovalForAll}.
957      * - If `to` refers to a smart contract, it must implement
958      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
959      *
960      * Emits a {Transfer} event.
961      */
962     function safeTransferFrom(
963         address from,
964         address to,
965         uint256 tokenId,
966         bytes memory _data
967     ) public payable virtual override {
968         transferFrom(from, to, tokenId);
969         if (to.code.length != 0)
970             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
971                 _revert(TransferToNonERC721ReceiverImplementer.selector);
972             }
973     }
974 
975     /**
976      * @dev Hook that is called before a set of serially-ordered token IDs
977      * are about to be transferred. This includes minting.
978      * And also called before burning one token.
979      *
980      * `startTokenId` - the first token ID to be transferred.
981      * `quantity` - the amount to be transferred.
982      *
983      * Calling conditions:
984      *
985      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
986      * transferred to `to`.
987      * - When `from` is zero, `tokenId` will be minted for `to`.
988      * - When `to` is zero, `tokenId` will be burned by `from`.
989      * - `from` and `to` are never both zero.
990      */
991     function _beforeTokenTransfers(
992         address from,
993         address to,
994         uint256 startTokenId,
995         uint256 quantity
996     ) internal virtual {}
997 
998     /**
999      * @dev Hook that is called after a set of serially-ordered token IDs
1000      * have been transferred. This includes minting.
1001      * And also called after one token has been burned.
1002      *
1003      * `startTokenId` - the first token ID to be transferred.
1004      * `quantity` - the amount to be transferred.
1005      *
1006      * Calling conditions:
1007      *
1008      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1009      * transferred to `to`.
1010      * - When `from` is zero, `tokenId` has been minted for `to`.
1011      * - When `to` is zero, `tokenId` has been burned by `from`.
1012      * - `from` and `to` are never both zero.
1013      */
1014     function _afterTokenTransfers(
1015         address from,
1016         address to,
1017         uint256 startTokenId,
1018         uint256 quantity
1019     ) internal virtual {}
1020 
1021     /**
1022      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1023      *
1024      * `from` - Previous owner of the given token ID.
1025      * `to` - Target address that will receive the token.
1026      * `tokenId` - Token ID to be transferred.
1027      * `_data` - Optional data to send along with the call.
1028      *
1029      * Returns whether the call correctly returned the expected magic value.
1030      */
1031     function _checkContractOnERC721Received(
1032         address from,
1033         address to,
1034         uint256 tokenId,
1035         bytes memory _data
1036     ) private returns (bool) {
1037         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1038             bytes4 retval
1039         ) {
1040             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1041         } catch (bytes memory reason) {
1042             if (reason.length == 0) {
1043                 _revert(TransferToNonERC721ReceiverImplementer.selector);
1044             }
1045             assembly {
1046                 revert(add(32, reason), mload(reason))
1047             }
1048         }
1049     }
1050 
1051     // =============================================================
1052     //                        MINT OPERATIONS
1053     // =============================================================
1054 
1055     /**
1056      * @dev Mints `quantity` tokens and transfers them to `to`.
1057      *
1058      * Requirements:
1059      *
1060      * - `to` cannot be the zero address.
1061      * - `quantity` must be greater than 0.
1062      *
1063      * Emits a {Transfer} event for each mint.
1064      */
1065     function _mint(address to, uint256 quantity) internal virtual {
1066         uint256 startTokenId = _currentIndex;
1067         if (quantity == 0) _revert(MintZeroQuantity.selector);
1068 
1069         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1070 
1071         // Overflows are incredibly unrealistic.
1072         // `balance` and `numberMinted` have a maximum limit of 2**64.
1073         // `tokenId` has a maximum limit of 2**256.
1074         unchecked {
1075             // Updates:
1076             // - `address` to the owner.
1077             // - `startTimestamp` to the timestamp of minting.
1078             // - `burned` to `false`.
1079             // - `nextInitialized` to `quantity == 1`.
1080             _packedOwnerships[startTokenId] = _packOwnershipData(
1081                 to,
1082                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1083             );
1084 
1085             // Updates:
1086             // - `balance += quantity`.
1087             // - `numberMinted += quantity`.
1088             //
1089             // We can directly add to the `balance` and `numberMinted`.
1090             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1091 
1092             // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1093             uint256 toMasked = uint256(uint160(to)) & _BITMASK_ADDRESS;
1094 
1095             if (toMasked == 0) _revert(MintToZeroAddress.selector);
1096 
1097             uint256 end = startTokenId + quantity;
1098             uint256 tokenId = startTokenId;
1099 
1100             do {
1101                 assembly {
1102                     // Emit the `Transfer` event.
1103                     log4(
1104                         0, // Start of data (0, since no data).
1105                         0, // End of data (0, since no data).
1106                         _TRANSFER_EVENT_SIGNATURE, // Signature.
1107                         0, // `address(0)`.
1108                         toMasked, // `to`.
1109                         tokenId // `tokenId`.
1110                     )
1111                 }
1112                 // The `!=` check ensures that large values of `quantity`
1113                 // that overflows uint256 will make the loop run out of gas.
1114             } while (++tokenId != end);
1115 
1116             _currentIndex = end;
1117         }
1118         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1119     }
1120 
1121     /**
1122      * @dev Mints `quantity` tokens and transfers them to `to`.
1123      *
1124      * This function is intended for efficient minting only during contract creation.
1125      *
1126      * It emits only one {ConsecutiveTransfer} as defined in
1127      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1128      * instead of a sequence of {Transfer} event(s).
1129      *
1130      * Calling this function outside of contract creation WILL make your contract
1131      * non-compliant with the ERC721 standard.
1132      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1133      * {ConsecutiveTransfer} event is only permissible during contract creation.
1134      *
1135      * Requirements:
1136      *
1137      * - `to` cannot be the zero address.
1138      * - `quantity` must be greater than 0.
1139      *
1140      * Emits a {ConsecutiveTransfer} event.
1141      */
1142     function _mintERC2309(address to, uint256 quantity) internal virtual {
1143         uint256 startTokenId = _currentIndex;
1144         if (to == address(0)) _revert(MintToZeroAddress.selector);
1145         if (quantity == 0) _revert(MintZeroQuantity.selector);
1146         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) _revert(MintERC2309QuantityExceedsLimit.selector);
1147 
1148         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1149 
1150         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1151         unchecked {
1152             // Updates:
1153             // - `balance += quantity`.
1154             // - `numberMinted += quantity`.
1155             //
1156             // We can directly add to the `balance` and `numberMinted`.
1157             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1158 
1159             // Updates:
1160             // - `address` to the owner.
1161             // - `startTimestamp` to the timestamp of minting.
1162             // - `burned` to `false`.
1163             // - `nextInitialized` to `quantity == 1`.
1164             _packedOwnerships[startTokenId] = _packOwnershipData(
1165                 to,
1166                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1167             );
1168 
1169             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1170 
1171             _currentIndex = startTokenId + quantity;
1172         }
1173         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1174     }
1175 
1176     /**
1177      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1178      *
1179      * Requirements:
1180      *
1181      * - If `to` refers to a smart contract, it must implement
1182      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1183      * - `quantity` must be greater than 0.
1184      *
1185      * See {_mint}.
1186      *
1187      * Emits a {Transfer} event for each mint.
1188      */
1189     function _safeMint(
1190         address to,
1191         uint256 quantity,
1192         bytes memory _data
1193     ) internal virtual {
1194         _mint(to, quantity);
1195 
1196         unchecked {
1197             if (to.code.length != 0) {
1198                 uint256 end = _currentIndex;
1199                 uint256 index = end - quantity;
1200                 do {
1201                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1202                         _revert(TransferToNonERC721ReceiverImplementer.selector);
1203                     }
1204                 } while (index < end);
1205                 // Reentrancy protection.
1206                 if (_currentIndex != end) _revert(bytes4(0));
1207             }
1208         }
1209     }
1210 
1211     /**
1212      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1213      */
1214     function _safeMint(address to, uint256 quantity) internal virtual {
1215         _safeMint(to, quantity, '');
1216     }
1217 
1218     // =============================================================
1219     //                       APPROVAL OPERATIONS
1220     // =============================================================
1221 
1222     /**
1223      * @dev Equivalent to `_approve(to, tokenId, false)`.
1224      */
1225     function _approve(address to, uint256 tokenId) internal virtual {
1226         _approve(to, tokenId, false);
1227     }
1228 
1229     /**
1230      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1231      * The approval is cleared when the token is transferred.
1232      *
1233      * Only a single account can be approved at a time, so approving the
1234      * zero address clears previous approvals.
1235      *
1236      * Requirements:
1237      *
1238      * - `tokenId` must exist.
1239      *
1240      * Emits an {Approval} event.
1241      */
1242     function _approve(
1243         address to,
1244         uint256 tokenId,
1245         bool approvalCheck
1246     ) internal virtual {
1247         address owner = ownerOf(tokenId);
1248 
1249         if (approvalCheck && _msgSenderERC721A() != owner)
1250             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1251                 _revert(ApprovalCallerNotOwnerNorApproved.selector);
1252             }
1253 
1254         _tokenApprovals[tokenId].value = to;
1255         emit Approval(owner, to, tokenId);
1256     }
1257 
1258     // =============================================================
1259     //                        BURN OPERATIONS
1260     // =============================================================
1261 
1262     /**
1263      * @dev Equivalent to `_burn(tokenId, false)`.
1264      */
1265     function _burn(uint256 tokenId) internal virtual {
1266         _burn(tokenId, false);
1267     }
1268 
1269     /**
1270      * @dev Destroys `tokenId`.
1271      * The approval is cleared when the token is burned.
1272      *
1273      * Requirements:
1274      *
1275      * - `tokenId` must exist.
1276      *
1277      * Emits a {Transfer} event.
1278      */
1279     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1280         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1281 
1282         address from = address(uint160(prevOwnershipPacked));
1283 
1284         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1285 
1286         if (approvalCheck) {
1287             // The nested ifs save around 20+ gas over a compound boolean condition.
1288             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1289                 if (!isApprovedForAll(from, _msgSenderERC721A())) _revert(TransferCallerNotOwnerNorApproved.selector);
1290         }
1291 
1292         _beforeTokenTransfers(from, address(0), tokenId, 1);
1293 
1294         // Clear approvals from the previous owner.
1295         assembly {
1296             if approvedAddress {
1297                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1298                 sstore(approvedAddressSlot, 0)
1299             }
1300         }
1301 
1302         // Underflow of the sender's balance is impossible because we check for
1303         // ownership above and the recipient's balance can't realistically overflow.
1304         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1305         unchecked {
1306             // Updates:
1307             // - `balance -= 1`.
1308             // - `numberBurned += 1`.
1309             //
1310             // We can directly decrement the balance, and increment the number burned.
1311             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1312             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1313 
1314             // Updates:
1315             // - `address` to the last owner.
1316             // - `startTimestamp` to the timestamp of burning.
1317             // - `burned` to `true`.
1318             // - `nextInitialized` to `true`.
1319             _packedOwnerships[tokenId] = _packOwnershipData(
1320                 from,
1321                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1322             );
1323 
1324             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1325             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1326                 uint256 nextTokenId = tokenId + 1;
1327                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1328                 if (_packedOwnerships[nextTokenId] == 0) {
1329                     // If the next slot is within bounds.
1330                     if (nextTokenId != _currentIndex) {
1331                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1332                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1333                     }
1334                 }
1335             }
1336         }
1337 
1338         emit Transfer(from, address(0), tokenId);
1339         _afterTokenTransfers(from, address(0), tokenId, 1);
1340 
1341         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1342         unchecked {
1343             _burnCounter++;
1344         }
1345     }
1346 
1347     // =============================================================
1348     //                     EXTRA DATA OPERATIONS
1349     // =============================================================
1350 
1351     /**
1352      * @dev Directly sets the extra data for the ownership data `index`.
1353      */
1354     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1355         uint256 packed = _packedOwnerships[index];
1356         if (packed == 0) _revert(OwnershipNotInitializedForExtraData.selector);
1357         uint256 extraDataCasted;
1358         // Cast `extraData` with assembly to avoid redundant masking.
1359         assembly {
1360             extraDataCasted := extraData
1361         }
1362         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1363         _packedOwnerships[index] = packed;
1364     }
1365 
1366     /**
1367      * @dev Called during each token transfer to set the 24bit `extraData` field.
1368      * Intended to be overridden by the cosumer contract.
1369      *
1370      * `previousExtraData` - the value of `extraData` before transfer.
1371      *
1372      * Calling conditions:
1373      *
1374      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1375      * transferred to `to`.
1376      * - When `from` is zero, `tokenId` will be minted for `to`.
1377      * - When `to` is zero, `tokenId` will be burned by `from`.
1378      * - `from` and `to` are never both zero.
1379      */
1380     function _extraData(
1381         address from,
1382         address to,
1383         uint24 previousExtraData
1384     ) internal view virtual returns (uint24) {}
1385 
1386     /**
1387      * @dev Returns the next extra data for the packed ownership data.
1388      * The returned result is shifted into position.
1389      */
1390     function _nextExtraData(
1391         address from,
1392         address to,
1393         uint256 prevOwnershipPacked
1394     ) private view returns (uint256) {
1395         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1396         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1397     }
1398 
1399     // =============================================================
1400     //                       OTHER OPERATIONS
1401     // =============================================================
1402 
1403     /**
1404      * @dev Returns the message sender (defaults to `msg.sender`).
1405      *
1406      * If you are writing GSN compatible contracts, you need to override this function.
1407      */
1408     function _msgSenderERC721A() internal view virtual returns (address) {
1409         return msg.sender;
1410     }
1411 
1412     /**
1413      * @dev Converts a uint256 to its ASCII string decimal representation.
1414      */
1415     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1416         assembly {
1417             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1418             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1419             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1420             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1421             let m := add(mload(0x40), 0xa0)
1422             // Update the free memory pointer to allocate.
1423             mstore(0x40, m)
1424             // Assign the `str` to the end.
1425             str := sub(m, 0x20)
1426             // Zeroize the slot after the string.
1427             mstore(str, 0)
1428 
1429             // Cache the end of the memory to calculate the length later.
1430             let end := str
1431 
1432             // We write the string from rightmost digit to leftmost digit.
1433             // The following is essentially a do-while loop that also handles the zero case.
1434             // prettier-ignore
1435             for { let temp := value } 1 {} {
1436                 str := sub(str, 1)
1437                 // Write the character to the pointer.
1438                 // The ASCII index of the '0' character is 48.
1439                 mstore8(str, add(48, mod(temp, 10)))
1440                 // Keep dividing `temp` until zero.
1441                 temp := div(temp, 10)
1442                 // prettier-ignore
1443                 if iszero(temp) { break }
1444             }
1445 
1446             let length := sub(end, str)
1447             // Move the pointer 32 bytes leftwards to make room for the length.
1448             str := sub(str, 0x20)
1449             // Store the length.
1450             mstore(str, length)
1451         }
1452     }
1453 
1454     /**
1455      * @dev For more efficient reverts.
1456      */
1457     function _revert(bytes4 errorSelector) internal pure {
1458         assembly {
1459             mstore(0x00, errorSelector)
1460             revert(0x00, 0x04)
1461         }
1462     }
1463 }
1464 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
1465 
1466 
1467 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
1468 
1469 pragma solidity ^0.8.0;
1470 
1471 // CAUTION
1472 // This version of SafeMath should only be used with Solidity 0.8 or later,
1473 // because it relies on the compiler's built in overflow checks.
1474 
1475 /**
1476  * @dev Wrappers over Solidity's arithmetic operations.
1477  *
1478  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
1479  * now has built in overflow checking.
1480  */
1481 library SafeMath {
1482     /**
1483      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1484      *
1485      * _Available since v3.4._
1486      */
1487     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1488         unchecked {
1489             uint256 c = a + b;
1490             if (c < a) return (false, 0);
1491             return (true, c);
1492         }
1493     }
1494 
1495     /**
1496      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
1497      *
1498      * _Available since v3.4._
1499      */
1500     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1501         unchecked {
1502             if (b > a) return (false, 0);
1503             return (true, a - b);
1504         }
1505     }
1506 
1507     /**
1508      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1509      *
1510      * _Available since v3.4._
1511      */
1512     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1513         unchecked {
1514             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1515             // benefit is lost if 'b' is also tested.
1516             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1517             if (a == 0) return (true, 0);
1518             uint256 c = a * b;
1519             if (c / a != b) return (false, 0);
1520             return (true, c);
1521         }
1522     }
1523 
1524     /**
1525      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1526      *
1527      * _Available since v3.4._
1528      */
1529     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1530         unchecked {
1531             if (b == 0) return (false, 0);
1532             return (true, a / b);
1533         }
1534     }
1535 
1536     /**
1537      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1538      *
1539      * _Available since v3.4._
1540      */
1541     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1542         unchecked {
1543             if (b == 0) return (false, 0);
1544             return (true, a % b);
1545         }
1546     }
1547 
1548     /**
1549      * @dev Returns the addition of two unsigned integers, reverting on
1550      * overflow.
1551      *
1552      * Counterpart to Solidity's `+` operator.
1553      *
1554      * Requirements:
1555      *
1556      * - Addition cannot overflow.
1557      */
1558     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1559         return a + b;
1560     }
1561 
1562     /**
1563      * @dev Returns the subtraction of two unsigned integers, reverting on
1564      * overflow (when the result is negative).
1565      *
1566      * Counterpart to Solidity's `-` operator.
1567      *
1568      * Requirements:
1569      *
1570      * - Subtraction cannot overflow.
1571      */
1572     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1573         return a - b;
1574     }
1575 
1576     /**
1577      * @dev Returns the multiplication of two unsigned integers, reverting on
1578      * overflow.
1579      *
1580      * Counterpart to Solidity's `*` operator.
1581      *
1582      * Requirements:
1583      *
1584      * - Multiplication cannot overflow.
1585      */
1586     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1587         return a * b;
1588     }
1589 
1590     /**
1591      * @dev Returns the integer division of two unsigned integers, reverting on
1592      * division by zero. The result is rounded towards zero.
1593      *
1594      * Counterpart to Solidity's `/` operator.
1595      *
1596      * Requirements:
1597      *
1598      * - The divisor cannot be zero.
1599      */
1600     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1601         return a / b;
1602     }
1603 
1604     /**
1605      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1606      * reverting when dividing by zero.
1607      *
1608      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1609      * opcode (which leaves remaining gas untouched) while Solidity uses an
1610      * invalid opcode to revert (consuming all remaining gas).
1611      *
1612      * Requirements:
1613      *
1614      * - The divisor cannot be zero.
1615      */
1616     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1617         return a % b;
1618     }
1619 
1620     /**
1621      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1622      * overflow (when the result is negative).
1623      *
1624      * CAUTION: This function is deprecated because it requires allocating memory for the error
1625      * message unnecessarily. For custom revert reasons use {trySub}.
1626      *
1627      * Counterpart to Solidity's `-` operator.
1628      *
1629      * Requirements:
1630      *
1631      * - Subtraction cannot overflow.
1632      */
1633     function sub(
1634         uint256 a,
1635         uint256 b,
1636         string memory errorMessage
1637     ) internal pure returns (uint256) {
1638         unchecked {
1639             require(b <= a, errorMessage);
1640             return a - b;
1641         }
1642     }
1643 
1644     /**
1645      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1646      * division by zero. The result is rounded towards zero.
1647      *
1648      * Counterpart to Solidity's `/` operator. Note: this function uses a
1649      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1650      * uses an invalid opcode to revert (consuming all remaining gas).
1651      *
1652      * Requirements:
1653      *
1654      * - The divisor cannot be zero.
1655      */
1656     function div(
1657         uint256 a,
1658         uint256 b,
1659         string memory errorMessage
1660     ) internal pure returns (uint256) {
1661         unchecked {
1662             require(b > 0, errorMessage);
1663             return a / b;
1664         }
1665     }
1666 
1667     /**
1668      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1669      * reverting with custom message when dividing by zero.
1670      *
1671      * CAUTION: This function is deprecated because it requires allocating memory for the error
1672      * message unnecessarily. For custom revert reasons use {tryMod}.
1673      *
1674      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1675      * opcode (which leaves remaining gas untouched) while Solidity uses an
1676      * invalid opcode to revert (consuming all remaining gas).
1677      *
1678      * Requirements:
1679      *
1680      * - The divisor cannot be zero.
1681      */
1682     function mod(
1683         uint256 a,
1684         uint256 b,
1685         string memory errorMessage
1686     ) internal pure returns (uint256) {
1687         unchecked {
1688             require(b > 0, errorMessage);
1689             return a % b;
1690         }
1691     }
1692 }
1693 
1694 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
1695 
1696 
1697 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
1698 
1699 pragma solidity ^0.8.0;
1700 
1701 /**
1702  * @dev Interface of the ERC20 standard as defined in the EIP.
1703  */
1704 interface IERC20 {
1705     /**
1706      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1707      * another (`to`).
1708      *
1709      * Note that `value` may be zero.
1710      */
1711     event Transfer(address indexed from, address indexed to, uint256 value);
1712 
1713     /**
1714      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1715      * a call to {approve}. `value` is the new allowance.
1716      */
1717     event Approval(address indexed owner, address indexed spender, uint256 value);
1718 
1719     /**
1720      * @dev Returns the amount of tokens in existence.
1721      */
1722     function totalSupply() external view returns (uint256);
1723 
1724     /**
1725      * @dev Returns the amount of tokens owned by `account`.
1726      */
1727     function balanceOf(address account) external view returns (uint256);
1728 
1729     /**
1730      * @dev Moves `amount` tokens from the caller's account to `to`.
1731      *
1732      * Returns a boolean value indicating whether the operation succeeded.
1733      *
1734      * Emits a {Transfer} event.
1735      */
1736     function transfer(address to, uint256 amount) external returns (bool);
1737 
1738     /**
1739      * @dev Returns the remaining number of tokens that `spender` will be
1740      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1741      * zero by default.
1742      *
1743      * This value changes when {approve} or {transferFrom} are called.
1744      */
1745     function allowance(address owner, address spender) external view returns (uint256);
1746 
1747     /**
1748      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1749      *
1750      * Returns a boolean value indicating whether the operation succeeded.
1751      *
1752      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1753      * that someone may use both the old and the new allowance by unfortunate
1754      * transaction ordering. One possible solution to mitigate this race
1755      * condition is to first reduce the spender's allowance to 0 and set the
1756      * desired value afterwards:
1757      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1758      *
1759      * Emits an {Approval} event.
1760      */
1761     function approve(address spender, uint256 amount) external returns (bool);
1762 
1763     /**
1764      * @dev Moves `amount` tokens from `from` to `to` using the
1765      * allowance mechanism. `amount` is then deducted from the caller's
1766      * allowance.
1767      *
1768      * Returns a boolean value indicating whether the operation succeeded.
1769      *
1770      * Emits a {Transfer} event.
1771      */
1772     function transferFrom(
1773         address from,
1774         address to,
1775         uint256 amount
1776     ) external returns (bool);
1777 }
1778 
1779 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
1780 
1781 
1782 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
1783 
1784 pragma solidity ^0.8.0;
1785 
1786 
1787 /**
1788  * @dev Interface for the optional metadata functions from the ERC20 standard.
1789  *
1790  * _Available since v4.1._
1791  */
1792 interface IERC20Metadata is IERC20 {
1793     /**
1794      * @dev Returns the name of the token.
1795      */
1796     function name() external view returns (string memory);
1797 
1798     /**
1799      * @dev Returns the symbol of the token.
1800      */
1801     function symbol() external view returns (string memory);
1802 
1803     /**
1804      * @dev Returns the decimals places of the token.
1805      */
1806     function decimals() external view returns (uint8);
1807 }
1808 
1809 // File: @openzeppelin/contracts/utils/math/Math.sol
1810 
1811 
1812 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
1813 
1814 pragma solidity ^0.8.0;
1815 
1816 /**
1817  * @dev Standard math utilities missing in the Solidity language.
1818  */
1819 library Math {
1820     enum Rounding {
1821         Down, // Toward negative infinity
1822         Up, // Toward infinity
1823         Zero // Toward zero
1824     }
1825 
1826     /**
1827      * @dev Returns the largest of two numbers.
1828      */
1829     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1830         return a > b ? a : b;
1831     }
1832 
1833     /**
1834      * @dev Returns the smallest of two numbers.
1835      */
1836     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1837         return a < b ? a : b;
1838     }
1839 
1840     /**
1841      * @dev Returns the average of two numbers. The result is rounded towards
1842      * zero.
1843      */
1844     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1845         // (a + b) / 2 can overflow.
1846         return (a & b) + (a ^ b) / 2;
1847     }
1848 
1849     /**
1850      * @dev Returns the ceiling of the division of two numbers.
1851      *
1852      * This differs from standard division with `/` in that it rounds up instead
1853      * of rounding down.
1854      */
1855     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
1856         // (a + b - 1) / b can overflow on addition, so we distribute.
1857         return a == 0 ? 0 : (a - 1) / b + 1;
1858     }
1859 
1860     /**
1861      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
1862      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
1863      * with further edits by Uniswap Labs also under MIT license.
1864      */
1865     function mulDiv(
1866         uint256 x,
1867         uint256 y,
1868         uint256 denominator
1869     ) internal pure returns (uint256 result) {
1870         unchecked {
1871             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
1872             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
1873             // variables such that product = prod1 * 2^256 + prod0.
1874             uint256 prod0; // Least significant 256 bits of the product
1875             uint256 prod1; // Most significant 256 bits of the product
1876             assembly {
1877                 let mm := mulmod(x, y, not(0))
1878                 prod0 := mul(x, y)
1879                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
1880             }
1881 
1882             // Handle non-overflow cases, 256 by 256 division.
1883             if (prod1 == 0) {
1884                 return prod0 / denominator;
1885             }
1886 
1887             // Make sure the result is less than 2^256. Also prevents denominator == 0.
1888             require(denominator > prod1);
1889 
1890             ///////////////////////////////////////////////
1891             // 512 by 256 division.
1892             ///////////////////////////////////////////////
1893 
1894             // Make division exact by subtracting the remainder from [prod1 prod0].
1895             uint256 remainder;
1896             assembly {
1897                 // Compute remainder using mulmod.
1898                 remainder := mulmod(x, y, denominator)
1899 
1900                 // Subtract 256 bit number from 512 bit number.
1901                 prod1 := sub(prod1, gt(remainder, prod0))
1902                 prod0 := sub(prod0, remainder)
1903             }
1904 
1905             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
1906             // See https://cs.stackexchange.com/q/138556/92363.
1907 
1908             // Does not overflow because the denominator cannot be zero at this stage in the function.
1909             uint256 twos = denominator & (~denominator + 1);
1910             assembly {
1911                 // Divide denominator by twos.
1912                 denominator := div(denominator, twos)
1913 
1914                 // Divide [prod1 prod0] by twos.
1915                 prod0 := div(prod0, twos)
1916 
1917                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
1918                 twos := add(div(sub(0, twos), twos), 1)
1919             }
1920 
1921             // Shift in bits from prod1 into prod0.
1922             prod0 |= prod1 * twos;
1923 
1924             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
1925             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
1926             // four bits. That is, denominator * inv = 1 mod 2^4.
1927             uint256 inverse = (3 * denominator) ^ 2;
1928 
1929             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
1930             // in modular arithmetic, doubling the correct bits in each step.
1931             inverse *= 2 - denominator * inverse; // inverse mod 2^8
1932             inverse *= 2 - denominator * inverse; // inverse mod 2^16
1933             inverse *= 2 - denominator * inverse; // inverse mod 2^32
1934             inverse *= 2 - denominator * inverse; // inverse mod 2^64
1935             inverse *= 2 - denominator * inverse; // inverse mod 2^128
1936             inverse *= 2 - denominator * inverse; // inverse mod 2^256
1937 
1938             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
1939             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
1940             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
1941             // is no longer required.
1942             result = prod0 * inverse;
1943             return result;
1944         }
1945     }
1946 
1947     /**
1948      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
1949      */
1950     function mulDiv(
1951         uint256 x,
1952         uint256 y,
1953         uint256 denominator,
1954         Rounding rounding
1955     ) internal pure returns (uint256) {
1956         uint256 result = mulDiv(x, y, denominator);
1957         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
1958             result += 1;
1959         }
1960         return result;
1961     }
1962 
1963     /**
1964      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
1965      *
1966      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
1967      */
1968     function sqrt(uint256 a) internal pure returns (uint256) {
1969         if (a == 0) {
1970             return 0;
1971         }
1972 
1973         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
1974         //
1975         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
1976         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
1977         //
1978         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
1979         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
1980         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
1981         //
1982         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
1983         uint256 result = 1 << (log2(a) >> 1);
1984 
1985         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
1986         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
1987         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
1988         // into the expected uint128 result.
1989         unchecked {
1990             result = (result + a / result) >> 1;
1991             result = (result + a / result) >> 1;
1992             result = (result + a / result) >> 1;
1993             result = (result + a / result) >> 1;
1994             result = (result + a / result) >> 1;
1995             result = (result + a / result) >> 1;
1996             result = (result + a / result) >> 1;
1997             return min(result, a / result);
1998         }
1999     }
2000 
2001     /**
2002      * @notice Calculates sqrt(a), following the selected rounding direction.
2003      */
2004     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
2005         unchecked {
2006             uint256 result = sqrt(a);
2007             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
2008         }
2009     }
2010 
2011     /**
2012      * @dev Return the log in base 2, rounded down, of a positive value.
2013      * Returns 0 if given 0.
2014      */
2015     function log2(uint256 value) internal pure returns (uint256) {
2016         uint256 result = 0;
2017         unchecked {
2018             if (value >> 128 > 0) {
2019                 value >>= 128;
2020                 result += 128;
2021             }
2022             if (value >> 64 > 0) {
2023                 value >>= 64;
2024                 result += 64;
2025             }
2026             if (value >> 32 > 0) {
2027                 value >>= 32;
2028                 result += 32;
2029             }
2030             if (value >> 16 > 0) {
2031                 value >>= 16;
2032                 result += 16;
2033             }
2034             if (value >> 8 > 0) {
2035                 value >>= 8;
2036                 result += 8;
2037             }
2038             if (value >> 4 > 0) {
2039                 value >>= 4;
2040                 result += 4;
2041             }
2042             if (value >> 2 > 0) {
2043                 value >>= 2;
2044                 result += 2;
2045             }
2046             if (value >> 1 > 0) {
2047                 result += 1;
2048             }
2049         }
2050         return result;
2051     }
2052 
2053     /**
2054      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
2055      * Returns 0 if given 0.
2056      */
2057     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
2058         unchecked {
2059             uint256 result = log2(value);
2060             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
2061         }
2062     }
2063 
2064     /**
2065      * @dev Return the log in base 10, rounded down, of a positive value.
2066      * Returns 0 if given 0.
2067      */
2068     function log10(uint256 value) internal pure returns (uint256) {
2069         uint256 result = 0;
2070         unchecked {
2071             if (value >= 10**64) {
2072                 value /= 10**64;
2073                 result += 64;
2074             }
2075             if (value >= 10**32) {
2076                 value /= 10**32;
2077                 result += 32;
2078             }
2079             if (value >= 10**16) {
2080                 value /= 10**16;
2081                 result += 16;
2082             }
2083             if (value >= 10**8) {
2084                 value /= 10**8;
2085                 result += 8;
2086             }
2087             if (value >= 10**4) {
2088                 value /= 10**4;
2089                 result += 4;
2090             }
2091             if (value >= 10**2) {
2092                 value /= 10**2;
2093                 result += 2;
2094             }
2095             if (value >= 10**1) {
2096                 result += 1;
2097             }
2098         }
2099         return result;
2100     }
2101 
2102     /**
2103      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
2104      * Returns 0 if given 0.
2105      */
2106     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
2107         unchecked {
2108             uint256 result = log10(value);
2109             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
2110         }
2111     }
2112 
2113     /**
2114      * @dev Return the log in base 256, rounded down, of a positive value.
2115      * Returns 0 if given 0.
2116      *
2117      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
2118      */
2119     function log256(uint256 value) internal pure returns (uint256) {
2120         uint256 result = 0;
2121         unchecked {
2122             if (value >> 128 > 0) {
2123                 value >>= 128;
2124                 result += 16;
2125             }
2126             if (value >> 64 > 0) {
2127                 value >>= 64;
2128                 result += 8;
2129             }
2130             if (value >> 32 > 0) {
2131                 value >>= 32;
2132                 result += 4;
2133             }
2134             if (value >> 16 > 0) {
2135                 value >>= 16;
2136                 result += 2;
2137             }
2138             if (value >> 8 > 0) {
2139                 result += 1;
2140             }
2141         }
2142         return result;
2143     }
2144 
2145     /**
2146      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
2147      * Returns 0 if given 0.
2148      */
2149     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
2150         unchecked {
2151             uint256 result = log256(value);
2152             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
2153         }
2154     }
2155 }
2156 
2157 // File: @openzeppelin/contracts/utils/Strings.sol
2158 
2159 
2160 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
2161 
2162 pragma solidity ^0.8.0;
2163 
2164 
2165 /**
2166  * @dev String operations.
2167  */
2168 library Strings {
2169     bytes16 private constant _SYMBOLS = "0123456789abcdef";
2170     uint8 private constant _ADDRESS_LENGTH = 20;
2171 
2172     /**
2173      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
2174      */
2175     function toString(uint256 value) internal pure returns (string memory) {
2176         unchecked {
2177             uint256 length = Math.log10(value) + 1;
2178             string memory buffer = new string(length);
2179             uint256 ptr;
2180             /// @solidity memory-safe-assembly
2181             assembly {
2182                 ptr := add(buffer, add(32, length))
2183             }
2184             while (true) {
2185                 ptr--;
2186                 /// @solidity memory-safe-assembly
2187                 assembly {
2188                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
2189                 }
2190                 value /= 10;
2191                 if (value == 0) break;
2192             }
2193             return buffer;
2194         }
2195     }
2196 
2197     /**
2198      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
2199      */
2200     function toHexString(uint256 value) internal pure returns (string memory) {
2201         unchecked {
2202             return toHexString(value, Math.log256(value) + 1);
2203         }
2204     }
2205 
2206     /**
2207      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
2208      */
2209     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
2210         bytes memory buffer = new bytes(2 * length + 2);
2211         buffer[0] = "0";
2212         buffer[1] = "x";
2213         for (uint256 i = 2 * length + 1; i > 1; --i) {
2214             buffer[i] = _SYMBOLS[value & 0xf];
2215             value >>= 4;
2216         }
2217         require(value == 0, "Strings: hex length insufficient");
2218         return string(buffer);
2219     }
2220 
2221     /**
2222      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
2223      */
2224     function toHexString(address addr) internal pure returns (string memory) {
2225         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
2226     }
2227 }
2228 
2229 // File: @openzeppelin/contracts/utils/Context.sol
2230 
2231 
2232 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
2233 
2234 pragma solidity ^0.8.0;
2235 
2236 /**
2237  * @dev Provides information about the current execution context, including the
2238  * sender of the transaction and its data. While these are generally available
2239  * via msg.sender and msg.data, they should not be accessed in such a direct
2240  * manner, since when dealing with meta-transactions the account sending and
2241  * paying for execution may not be the actual sender (as far as an application
2242  * is concerned).
2243  *
2244  * This contract is only required for intermediate, library-like contracts.
2245  */
2246 abstract contract Context {
2247     function _msgSender() internal view virtual returns (address) {
2248         return msg.sender;
2249     }
2250 
2251     function _msgData() internal view virtual returns (bytes calldata) {
2252         return msg.data;
2253     }
2254 }
2255 
2256 // File: @openzeppelin/contracts/access/Ownable.sol
2257 
2258 
2259 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
2260 
2261 pragma solidity ^0.8.0;
2262 
2263 
2264 /**
2265  * @dev Contract module which provides a basic access control mechanism, where
2266  * there is an account (an owner) that can be granted exclusive access to
2267  * specific functions.
2268  *
2269  * By default, the owner account will be the one that deploys the contract. This
2270  * can later be changed with {transferOwnership}.
2271  *
2272  * This module is used through inheritance. It will make available the modifier
2273  * `onlyOwner`, which can be applied to your functions to restrict their use to
2274  * the owner.
2275  */
2276 abstract contract Ownable is Context {
2277     address private _owner;
2278 
2279     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2280 
2281     /**
2282      * @dev Initializes the contract setting the deployer as the initial owner.
2283      */
2284     constructor() {
2285         _transferOwnership(_msgSender());
2286     }
2287 
2288     /**
2289      * @dev Throws if called by any account other than the owner.
2290      */
2291     modifier onlyOwner() {
2292         _checkOwner();
2293         _;
2294     }
2295 
2296     /**
2297      * @dev Returns the address of the current owner.
2298      */
2299     function owner() public view virtual returns (address) {
2300         return _owner;
2301     }
2302 
2303     /**
2304      * @dev Throws if the sender is not the owner.
2305      */
2306     function _checkOwner() internal view virtual {
2307         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2308     }
2309 
2310     /**
2311      * @dev Leaves the contract without owner. It will not be possible to call
2312      * `onlyOwner` functions anymore. Can only be called by the current owner.
2313      *
2314      * NOTE: Renouncing ownership will leave the contract without an owner,
2315      * thereby removing any functionality that is only available to the owner.
2316      */
2317     function renounceOwnership() public virtual onlyOwner {
2318         _transferOwnership(address(0));
2319     }
2320 
2321     /**
2322      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2323      * Can only be called by the current owner.
2324      */
2325     function transferOwnership(address newOwner) public virtual onlyOwner {
2326         require(newOwner != address(0), "Ownable: new owner is the zero address");
2327         _transferOwnership(newOwner);
2328     }
2329 
2330     /**
2331      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2332      * Internal function without access restriction.
2333      */
2334     function _transferOwnership(address newOwner) internal virtual {
2335         address oldOwner = _owner;
2336         _owner = newOwner;
2337         emit OwnershipTransferred(oldOwner, newOwner);
2338     }
2339 }
2340 
2341 // File: @openzeppelin/contracts/security/Pausable.sol
2342 
2343 
2344 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
2345 
2346 pragma solidity ^0.8.0;
2347 
2348 
2349 /**
2350  * @dev Contract module which allows children to implement an emergency stop
2351  * mechanism that can be triggered by an authorized account.
2352  *
2353  * This module is used through inheritance. It will make available the
2354  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
2355  * the functions of your contract. Note that they will not be pausable by
2356  * simply including this module, only once the modifiers are put in place.
2357  */
2358 abstract contract Pausable is Context {
2359     /**
2360      * @dev Emitted when the pause is triggered by `account`.
2361      */
2362     event Paused(address account);
2363 
2364     /**
2365      * @dev Emitted when the pause is lifted by `account`.
2366      */
2367     event Unpaused(address account);
2368 
2369     bool private _paused;
2370 
2371     /**
2372      * @dev Initializes the contract in unpaused state.
2373      */
2374     constructor() {
2375         _paused = false;
2376     }
2377 
2378     /**
2379      * @dev Modifier to make a function callable only when the contract is not paused.
2380      *
2381      * Requirements:
2382      *
2383      * - The contract must not be paused.
2384      */
2385     modifier whenNotPaused() {
2386         _requireNotPaused();
2387         _;
2388     }
2389 
2390     /**
2391      * @dev Modifier to make a function callable only when the contract is paused.
2392      *
2393      * Requirements:
2394      *
2395      * - The contract must be paused.
2396      */
2397     modifier whenPaused() {
2398         _requirePaused();
2399         _;
2400     }
2401 
2402     /**
2403      * @dev Returns true if the contract is paused, and false otherwise.
2404      */
2405     function paused() public view virtual returns (bool) {
2406         return _paused;
2407     }
2408 
2409     /**
2410      * @dev Throws if the contract is paused.
2411      */
2412     function _requireNotPaused() internal view virtual {
2413         require(!paused(), "Pausable: paused");
2414     }
2415 
2416     /**
2417      * @dev Throws if the contract is not paused.
2418      */
2419     function _requirePaused() internal view virtual {
2420         require(paused(), "Pausable: not paused");
2421     }
2422 
2423     /**
2424      * @dev Triggers stopped state.
2425      *
2426      * Requirements:
2427      *
2428      * - The contract must not be paused.
2429      */
2430     function _pause() internal virtual whenNotPaused {
2431         _paused = true;
2432         emit Paused(_msgSender());
2433     }
2434 
2435     /**
2436      * @dev Returns to normal state.
2437      *
2438      * Requirements:
2439      *
2440      * - The contract must be paused.
2441      */
2442     function _unpause() internal virtual whenPaused {
2443         _paused = false;
2444         emit Unpaused(_msgSender());
2445     }
2446 }
2447 
2448 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
2449 
2450 
2451 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
2452 
2453 pragma solidity ^0.8.0;
2454 
2455 
2456 
2457 
2458 /**
2459  * @dev Implementation of the {IERC20} interface.
2460  *
2461  * This implementation is agnostic to the way tokens are created. This means
2462  * that a supply mechanism has to be added in a derived contract using {_mint}.
2463  * For a generic mechanism see {ERC20PresetMinterPauser}.
2464  *
2465  * TIP: For a detailed writeup see our guide
2466  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
2467  * to implement supply mechanisms].
2468  *
2469  * We have followed general OpenZeppelin Contracts guidelines: functions revert
2470  * instead returning `false` on failure. This behavior is nonetheless
2471  * conventional and does not conflict with the expectations of ERC20
2472  * applications.
2473  *
2474  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
2475  * This allows applications to reconstruct the allowance for all accounts just
2476  * by listening to said events. Other implementations of the EIP may not emit
2477  * these events, as it isn't required by the specification.
2478  *
2479  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
2480  * functions have been added to mitigate the well-known issues around setting
2481  * allowances. See {IERC20-approve}.
2482  */
2483 contract ERC20 is Context, IERC20, IERC20Metadata {
2484     mapping(address => uint256) private _balances;
2485 
2486     mapping(address => mapping(address => uint256)) private _allowances;
2487 
2488     uint256 private _totalSupply;
2489 
2490     string private _name;
2491     string private _symbol;
2492 
2493     /**
2494      * @dev Sets the values for {name} and {symbol}.
2495      *
2496      * The default value of {decimals} is 18. To select a different value for
2497      * {decimals} you should overload it.
2498      *
2499      * All two of these values are immutable: they can only be set once during
2500      * construction.
2501      */
2502     constructor(string memory name_, string memory symbol_) {
2503         _name = name_;
2504         _symbol = symbol_;
2505     }
2506 
2507     /**
2508      * @dev Returns the name of the token.
2509      */
2510     function name() public view virtual override returns (string memory) {
2511         return _name;
2512     }
2513 
2514     /**
2515      * @dev Returns the symbol of the token, usually a shorter version of the
2516      * name.
2517      */
2518     function symbol() public view virtual override returns (string memory) {
2519         return _symbol;
2520     }
2521 
2522     /**
2523      * @dev Returns the number of decimals used to get its user representation.
2524      * For example, if `decimals` equals `2`, a balance of `505` tokens should
2525      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
2526      *
2527      * Tokens usually opt for a value of 18, imitating the relationship between
2528      * Ether and Wei. This is the value {ERC20} uses, unless this function is
2529      * overridden;
2530      *
2531      * NOTE: This information is only used for _display_ purposes: it in
2532      * no way affects any of the arithmetic of the contract, including
2533      * {IERC20-balanceOf} and {IERC20-transfer}.
2534      */
2535     function decimals() public view virtual override returns (uint8) {
2536         return 18;
2537     }
2538 
2539     /**
2540      * @dev See {IERC20-totalSupply}.
2541      */
2542     function totalSupply() public view virtual override returns (uint256) {
2543         return _totalSupply;
2544     }
2545 
2546     /**
2547      * @dev See {IERC20-balanceOf}.
2548      */
2549     function balanceOf(address account) public view virtual override returns (uint256) {
2550         return _balances[account];
2551     }
2552 
2553     /**
2554      * @dev See {IERC20-transfer}.
2555      *
2556      * Requirements:
2557      *
2558      * - `to` cannot be the zero address.
2559      * - the caller must have a balance of at least `amount`.
2560      */
2561     function transfer(address to, uint256 amount) public virtual override returns (bool) {
2562         address owner = _msgSender();
2563         _transfer(owner, to, amount);
2564         return true;
2565     }
2566 
2567     /**
2568      * @dev See {IERC20-allowance}.
2569      */
2570     function allowance(address owner, address spender) public view virtual override returns (uint256) {
2571         return _allowances[owner][spender];
2572     }
2573 
2574     /**
2575      * @dev See {IERC20-approve}.
2576      *
2577      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
2578      * `transferFrom`. This is semantically equivalent to an infinite approval.
2579      *
2580      * Requirements:
2581      *
2582      * - `spender` cannot be the zero address.
2583      */
2584     function approve(address spender, uint256 amount) public virtual override returns (bool) {
2585         address owner = _msgSender();
2586         _approve(owner, spender, amount);
2587         return true;
2588     }
2589 
2590     /**
2591      * @dev See {IERC20-transferFrom}.
2592      *
2593      * Emits an {Approval} event indicating the updated allowance. This is not
2594      * required by the EIP. See the note at the beginning of {ERC20}.
2595      *
2596      * NOTE: Does not update the allowance if the current allowance
2597      * is the maximum `uint256`.
2598      *
2599      * Requirements:
2600      *
2601      * - `from` and `to` cannot be the zero address.
2602      * - `from` must have a balance of at least `amount`.
2603      * - the caller must have allowance for ``from``'s tokens of at least
2604      * `amount`.
2605      */
2606     function transferFrom(
2607         address from,
2608         address to,
2609         uint256 amount
2610     ) public virtual override returns (bool) {
2611         address spender = _msgSender();
2612         _spendAllowance(from, spender, amount);
2613         _transfer(from, to, amount);
2614         return true;
2615     }
2616 
2617     /**
2618      * @dev Atomically increases the allowance granted to `spender` by the caller.
2619      *
2620      * This is an alternative to {approve} that can be used as a mitigation for
2621      * problems described in {IERC20-approve}.
2622      *
2623      * Emits an {Approval} event indicating the updated allowance.
2624      *
2625      * Requirements:
2626      *
2627      * - `spender` cannot be the zero address.
2628      */
2629     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
2630         address owner = _msgSender();
2631         _approve(owner, spender, allowance(owner, spender) + addedValue);
2632         return true;
2633     }
2634 
2635     /**
2636      * @dev Atomically decreases the allowance granted to `spender` by the caller.
2637      *
2638      * This is an alternative to {approve} that can be used as a mitigation for
2639      * problems described in {IERC20-approve}.
2640      *
2641      * Emits an {Approval} event indicating the updated allowance.
2642      *
2643      * Requirements:
2644      *
2645      * - `spender` cannot be the zero address.
2646      * - `spender` must have allowance for the caller of at least
2647      * `subtractedValue`.
2648      */
2649     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
2650         address owner = _msgSender();
2651         uint256 currentAllowance = allowance(owner, spender);
2652         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
2653         unchecked {
2654             _approve(owner, spender, currentAllowance - subtractedValue);
2655         }
2656 
2657         return true;
2658     }
2659 
2660     /**
2661      * @dev Moves `amount` of tokens from `from` to `to`.
2662      *
2663      * This internal function is equivalent to {transfer}, and can be used to
2664      * e.g. implement automatic token fees, slashing mechanisms, etc.
2665      *
2666      * Emits a {Transfer} event.
2667      *
2668      * Requirements:
2669      *
2670      * - `from` cannot be the zero address.
2671      * - `to` cannot be the zero address.
2672      * - `from` must have a balance of at least `amount`.
2673      */
2674     function _transfer(
2675         address from,
2676         address to,
2677         uint256 amount
2678     ) internal virtual {
2679         require(from != address(0), "ERC20: transfer from the zero address");
2680         require(to != address(0), "ERC20: transfer to the zero address");
2681 
2682         _beforeTokenTransfer(from, to, amount);
2683 
2684         uint256 fromBalance = _balances[from];
2685         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
2686         unchecked {
2687             _balances[from] = fromBalance - amount;
2688             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
2689             // decrementing then incrementing.
2690             _balances[to] += amount;
2691         }
2692 
2693         emit Transfer(from, to, amount);
2694 
2695         _afterTokenTransfer(from, to, amount);
2696     }
2697 
2698     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
2699      * the total supply.
2700      *
2701      * Emits a {Transfer} event with `from` set to the zero address.
2702      *
2703      * Requirements:
2704      *
2705      * - `account` cannot be the zero address.
2706      */
2707     function _mint(address account, uint256 amount) internal virtual {
2708         require(account != address(0), "ERC20: mint to the zero address");
2709 
2710         _beforeTokenTransfer(address(0), account, amount);
2711 
2712         _totalSupply += amount;
2713         unchecked {
2714             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
2715             _balances[account] += amount;
2716         }
2717         emit Transfer(address(0), account, amount);
2718 
2719         _afterTokenTransfer(address(0), account, amount);
2720     }
2721 
2722     /**
2723      * @dev Destroys `amount` tokens from `account`, reducing the
2724      * total supply.
2725      *
2726      * Emits a {Transfer} event with `to` set to the zero address.
2727      *
2728      * Requirements:
2729      *
2730      * - `account` cannot be the zero address.
2731      * - `account` must have at least `amount` tokens.
2732      */
2733     function _burn(address account, uint256 amount) internal virtual {
2734         require(account != address(0), "ERC20: burn from the zero address");
2735 
2736         _beforeTokenTransfer(account, address(0), amount);
2737 
2738         uint256 accountBalance = _balances[account];
2739         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
2740         unchecked {
2741             _balances[account] = accountBalance - amount;
2742             // Overflow not possible: amount <= accountBalance <= totalSupply.
2743             _totalSupply -= amount;
2744         }
2745 
2746         emit Transfer(account, address(0), amount);
2747 
2748         _afterTokenTransfer(account, address(0), amount);
2749     }
2750 
2751     /**
2752      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
2753      *
2754      * This internal function is equivalent to `approve`, and can be used to
2755      * e.g. set automatic allowances for certain subsystems, etc.
2756      *
2757      * Emits an {Approval} event.
2758      *
2759      * Requirements:
2760      *
2761      * - `owner` cannot be the zero address.
2762      * - `spender` cannot be the zero address.
2763      */
2764     function _approve(
2765         address owner,
2766         address spender,
2767         uint256 amount
2768     ) internal virtual {
2769         require(owner != address(0), "ERC20: approve from the zero address");
2770         require(spender != address(0), "ERC20: approve to the zero address");
2771 
2772         _allowances[owner][spender] = amount;
2773         emit Approval(owner, spender, amount);
2774     }
2775 
2776     /**
2777      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
2778      *
2779      * Does not update the allowance amount in case of infinite allowance.
2780      * Revert if not enough allowance is available.
2781      *
2782      * Might emit an {Approval} event.
2783      */
2784     function _spendAllowance(
2785         address owner,
2786         address spender,
2787         uint256 amount
2788     ) internal virtual {
2789         uint256 currentAllowance = allowance(owner, spender);
2790         if (currentAllowance != type(uint256).max) {
2791             require(currentAllowance >= amount, "ERC20: insufficient allowance");
2792             unchecked {
2793                 _approve(owner, spender, currentAllowance - amount);
2794             }
2795         }
2796     }
2797 
2798     /**
2799      * @dev Hook that is called before any transfer of tokens. This includes
2800      * minting and burning.
2801      *
2802      * Calling conditions:
2803      *
2804      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
2805      * will be transferred to `to`.
2806      * - when `from` is zero, `amount` tokens will be minted for `to`.
2807      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
2808      * - `from` and `to` are never both zero.
2809      *
2810      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2811      */
2812     function _beforeTokenTransfer(
2813         address from,
2814         address to,
2815         uint256 amount
2816     ) internal virtual {}
2817 
2818     /**
2819      * @dev Hook that is called after any transfer of tokens. This includes
2820      * minting and burning.
2821      *
2822      * Calling conditions:
2823      *
2824      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
2825      * has been transferred to `to`.
2826      * - when `from` is zero, `amount` tokens have been minted for `to`.
2827      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
2828      * - `from` and `to` are never both zero.
2829      *
2830      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2831      */
2832     function _afterTokenTransfer(
2833         address from,
2834         address to,
2835         uint256 amount
2836     ) internal virtual {}
2837 }
2838 
2839 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
2840 
2841 
2842 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)
2843 
2844 pragma solidity ^0.8.0;
2845 
2846 
2847 
2848 /**
2849  * @dev Extension of {ERC20} that allows token holders to destroy both their own
2850  * tokens and those that they have an allowance for, in a way that can be
2851  * recognized off-chain (via event analysis).
2852  */
2853 abstract contract ERC20Burnable is Context, ERC20 {
2854     /**
2855      * @dev Destroys `amount` tokens from the caller.
2856      *
2857      * See {ERC20-_burn}.
2858      */
2859     function burn(uint256 amount) public virtual {
2860         _burn(_msgSender(), amount);
2861     }
2862 
2863     /**
2864      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
2865      * allowance.
2866      *
2867      * See {ERC20-_burn} and {ERC20-allowance}.
2868      *
2869      * Requirements:
2870      *
2871      * - the caller must have allowance for ``accounts``'s tokens of at least
2872      * `amount`.
2873      */
2874     function burnFrom(address account, uint256 amount) public virtual {
2875         _spendAllowance(account, _msgSender(), amount);
2876         _burn(account, amount);
2877     }
2878 }
2879 
2880 // File: @openzeppelin/contracts/utils/Address.sol
2881 
2882 
2883 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
2884 
2885 pragma solidity ^0.8.1;
2886 
2887 /**
2888  * @dev Collection of functions related to the address type
2889  */
2890 library Address {
2891     /**
2892      * @dev Returns true if `account` is a contract.
2893      *
2894      * [IMPORTANT]
2895      * ====
2896      * It is unsafe to assume that an address for which this function returns
2897      * false is an externally-owned account (EOA) and not a contract.
2898      *
2899      * Among others, `isContract` will return false for the following
2900      * types of addresses:
2901      *
2902      *  - an externally-owned account
2903      *  - a contract in construction
2904      *  - an address where a contract will be created
2905      *  - an address where a contract lived, but was destroyed
2906      * ====
2907      *
2908      * [IMPORTANT]
2909      * ====
2910      * You shouldn't rely on `isContract` to protect against flash loan attacks!
2911      *
2912      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
2913      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
2914      * constructor.
2915      * ====
2916      */
2917     function isContract(address account) internal view returns (bool) {
2918         // This method relies on extcodesize/address.code.length, which returns 0
2919         // for contracts in construction, since the code is only stored at the end
2920         // of the constructor execution.
2921 
2922         return account.code.length > 0;
2923     }
2924 
2925     /**
2926      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
2927      * `recipient`, forwarding all available gas and reverting on errors.
2928      *
2929      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
2930      * of certain opcodes, possibly making contracts go over the 2300 gas limit
2931      * imposed by `transfer`, making them unable to receive funds via
2932      * `transfer`. {sendValue} removes this limitation.
2933      *
2934      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
2935      *
2936      * IMPORTANT: because control is transferred to `recipient`, care must be
2937      * taken to not create reentrancy vulnerabilities. Consider using
2938      * {ReentrancyGuard} or the
2939      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
2940      */
2941     function sendValue(address payable recipient, uint256 amount) internal {
2942         require(address(this).balance >= amount, "Address: insufficient balance");
2943 
2944         (bool success, ) = recipient.call{value: amount}("");
2945         require(success, "Address: unable to send value, recipient may have reverted");
2946     }
2947 
2948     /**
2949      * @dev Performs a Solidity function call using a low level `call`. A
2950      * plain `call` is an unsafe replacement for a function call: use this
2951      * function instead.
2952      *
2953      * If `target` reverts with a revert reason, it is bubbled up by this
2954      * function (like regular Solidity function calls).
2955      *
2956      * Returns the raw returned data. To convert to the expected return value,
2957      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
2958      *
2959      * Requirements:
2960      *
2961      * - `target` must be a contract.
2962      * - calling `target` with `data` must not revert.
2963      *
2964      * _Available since v3.1._
2965      */
2966     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
2967         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
2968     }
2969 
2970     /**
2971      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
2972      * `errorMessage` as a fallback revert reason when `target` reverts.
2973      *
2974      * _Available since v3.1._
2975      */
2976     function functionCall(
2977         address target,
2978         bytes memory data,
2979         string memory errorMessage
2980     ) internal returns (bytes memory) {
2981         return functionCallWithValue(target, data, 0, errorMessage);
2982     }
2983 
2984     /**
2985      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
2986      * but also transferring `value` wei to `target`.
2987      *
2988      * Requirements:
2989      *
2990      * - the calling contract must have an ETH balance of at least `value`.
2991      * - the called Solidity function must be `payable`.
2992      *
2993      * _Available since v3.1._
2994      */
2995     function functionCallWithValue(
2996         address target,
2997         bytes memory data,
2998         uint256 value
2999     ) internal returns (bytes memory) {
3000         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
3001     }
3002 
3003     /**
3004      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
3005      * with `errorMessage` as a fallback revert reason when `target` reverts.
3006      *
3007      * _Available since v3.1._
3008      */
3009     function functionCallWithValue(
3010         address target,
3011         bytes memory data,
3012         uint256 value,
3013         string memory errorMessage
3014     ) internal returns (bytes memory) {
3015         require(address(this).balance >= value, "Address: insufficient balance for call");
3016         (bool success, bytes memory returndata) = target.call{value: value}(data);
3017         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
3018     }
3019 
3020     /**
3021      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
3022      * but performing a static call.
3023      *
3024      * _Available since v3.3._
3025      */
3026     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
3027         return functionStaticCall(target, data, "Address: low-level static call failed");
3028     }
3029 
3030     /**
3031      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
3032      * but performing a static call.
3033      *
3034      * _Available since v3.3._
3035      */
3036     function functionStaticCall(
3037         address target,
3038         bytes memory data,
3039         string memory errorMessage
3040     ) internal view returns (bytes memory) {
3041         (bool success, bytes memory returndata) = target.staticcall(data);
3042         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
3043     }
3044 
3045     /**
3046      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
3047      * but performing a delegate call.
3048      *
3049      * _Available since v3.4._
3050      */
3051     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
3052         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
3053     }
3054 
3055     /**
3056      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
3057      * but performing a delegate call.
3058      *
3059      * _Available since v3.4._
3060      */
3061     function functionDelegateCall(
3062         address target,
3063         bytes memory data,
3064         string memory errorMessage
3065     ) internal returns (bytes memory) {
3066         (bool success, bytes memory returndata) = target.delegatecall(data);
3067         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
3068     }
3069 
3070     /**
3071      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
3072      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
3073      *
3074      * _Available since v4.8._
3075      */
3076     function verifyCallResultFromTarget(
3077         address target,
3078         bool success,
3079         bytes memory returndata,
3080         string memory errorMessage
3081     ) internal view returns (bytes memory) {
3082         if (success) {
3083             if (returndata.length == 0) {
3084                 // only check isContract if the call was successful and the return data is empty
3085                 // otherwise we already know that it was a contract
3086                 require(isContract(target), "Address: call to non-contract");
3087             }
3088             return returndata;
3089         } else {
3090             _revert(returndata, errorMessage);
3091         }
3092     }
3093 
3094     /**
3095      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
3096      * revert reason or using the provided one.
3097      *
3098      * _Available since v4.3._
3099      */
3100     function verifyCallResult(
3101         bool success,
3102         bytes memory returndata,
3103         string memory errorMessage
3104     ) internal pure returns (bytes memory) {
3105         if (success) {
3106             return returndata;
3107         } else {
3108             _revert(returndata, errorMessage);
3109         }
3110     }
3111 
3112     function _revert(bytes memory returndata, string memory errorMessage) private pure {
3113         // Look for revert reason and bubble it up if present
3114         if (returndata.length > 0) {
3115             // The easiest way to bubble the revert reason is using memory via assembly
3116             /// @solidity memory-safe-assembly
3117             assembly {
3118                 let returndata_size := mload(returndata)
3119                 revert(add(32, returndata), returndata_size)
3120             }
3121         } else {
3122             revert(errorMessage);
3123         }
3124     }
3125 }
3126 
3127 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
3128 
3129 
3130 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
3131 
3132 pragma solidity ^0.8.0;
3133 
3134 /**
3135  * @title ERC721 token receiver interface
3136  * @dev Interface for any contract that wants to support safeTransfers
3137  * from ERC721 asset contracts.
3138  */
3139 interface IERC721Receiver {
3140     /**
3141      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
3142      * by `operator` from `from`, this function is called.
3143      *
3144      * It must return its Solidity selector to confirm the token transfer.
3145      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
3146      *
3147      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
3148      */
3149     function onERC721Received(
3150         address operator,
3151         address from,
3152         uint256 tokenId,
3153         bytes calldata data
3154     ) external returns (bytes4);
3155 }
3156 
3157 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
3158 
3159 
3160 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
3161 
3162 pragma solidity ^0.8.0;
3163 
3164 /**
3165  * @dev Interface of the ERC165 standard, as defined in the
3166  * https://eips.ethereum.org/EIPS/eip-165[EIP].
3167  *
3168  * Implementers can declare support of contract interfaces, which can then be
3169  * queried by others ({ERC165Checker}).
3170  *
3171  * For an implementation, see {ERC165}.
3172  */
3173 interface IERC165 {
3174     /**
3175      * @dev Returns true if this contract implements the interface defined by
3176      * `interfaceId`. See the corresponding
3177      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
3178      * to learn more about how these ids are created.
3179      *
3180      * This function call must use less than 30 000 gas.
3181      */
3182     function supportsInterface(bytes4 interfaceId) external view returns (bool);
3183 }
3184 
3185 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
3186 
3187 
3188 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
3189 
3190 pragma solidity ^0.8.0;
3191 
3192 
3193 /**
3194  * @dev Implementation of the {IERC165} interface.
3195  *
3196  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
3197  * for the additional interface id that will be supported. For example:
3198  *
3199  * ```solidity
3200  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
3201  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
3202  * }
3203  * ```
3204  *
3205  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
3206  */
3207 abstract contract ERC165 is IERC165 {
3208     /**
3209      * @dev See {IERC165-supportsInterface}.
3210      */
3211     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
3212         return interfaceId == type(IERC165).interfaceId;
3213     }
3214 }
3215 
3216 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
3217 
3218 
3219 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
3220 
3221 pragma solidity ^0.8.0;
3222 
3223 
3224 /**
3225  * @dev Required interface of an ERC721 compliant contract.
3226  */
3227 interface IERC721 is IERC165 {
3228     /**
3229      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
3230      */
3231     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
3232 
3233     /**
3234      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
3235      */
3236     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
3237 
3238     /**
3239      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
3240      */
3241     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
3242 
3243     /**
3244      * @dev Returns the number of tokens in ``owner``'s account.
3245      */
3246     function balanceOf(address owner) external view returns (uint256 balance);
3247 
3248     /**
3249      * @dev Returns the owner of the `tokenId` token.
3250      *
3251      * Requirements:
3252      *
3253      * - `tokenId` must exist.
3254      */
3255     function ownerOf(uint256 tokenId) external view returns (address owner);
3256 
3257     /**
3258      * @dev Safely transfers `tokenId` token from `from` to `to`.
3259      *
3260      * Requirements:
3261      *
3262      * - `from` cannot be the zero address.
3263      * - `to` cannot be the zero address.
3264      * - `tokenId` token must exist and be owned by `from`.
3265      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
3266      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
3267      *
3268      * Emits a {Transfer} event.
3269      */
3270     function safeTransferFrom(
3271         address from,
3272         address to,
3273         uint256 tokenId,
3274         bytes calldata data
3275     ) external;
3276 
3277     /**
3278      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
3279      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
3280      *
3281      * Requirements:
3282      *
3283      * - `from` cannot be the zero address.
3284      * - `to` cannot be the zero address.
3285      * - `tokenId` token must exist and be owned by `from`.
3286      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
3287      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
3288      *
3289      * Emits a {Transfer} event.
3290      */
3291     function safeTransferFrom(
3292         address from,
3293         address to,
3294         uint256 tokenId
3295     ) external;
3296 
3297     /**
3298      * @dev Transfers `tokenId` token from `from` to `to`.
3299      *
3300      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
3301      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
3302      * understand this adds an external call which potentially creates a reentrancy vulnerability.
3303      *
3304      * Requirements:
3305      *
3306      * - `from` cannot be the zero address.
3307      * - `to` cannot be the zero address.
3308      * - `tokenId` token must be owned by `from`.
3309      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
3310      *
3311      * Emits a {Transfer} event.
3312      */
3313     function transferFrom(
3314         address from,
3315         address to,
3316         uint256 tokenId
3317     ) external;
3318 
3319     /**
3320      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
3321      * The approval is cleared when the token is transferred.
3322      *
3323      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
3324      *
3325      * Requirements:
3326      *
3327      * - The caller must own the token or be an approved operator.
3328      * - `tokenId` must exist.
3329      *
3330      * Emits an {Approval} event.
3331      */
3332     function approve(address to, uint256 tokenId) external;
3333 
3334     /**
3335      * @dev Approve or remove `operator` as an operator for the caller.
3336      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
3337      *
3338      * Requirements:
3339      *
3340      * - The `operator` cannot be the caller.
3341      *
3342      * Emits an {ApprovalForAll} event.
3343      */
3344     function setApprovalForAll(address operator, bool _approved) external;
3345 
3346     /**
3347      * @dev Returns the account approved for `tokenId` token.
3348      *
3349      * Requirements:
3350      *
3351      * - `tokenId` must exist.
3352      */
3353     function getApproved(uint256 tokenId) external view returns (address operator);
3354 
3355     /**
3356      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
3357      *
3358      * See {setApprovalForAll}
3359      */
3360     function isApprovedForAll(address owner, address operator) external view returns (bool);
3361 }
3362 
3363 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
3364 
3365 
3366 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
3367 
3368 pragma solidity ^0.8.0;
3369 
3370 
3371 /**
3372  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
3373  * @dev See https://eips.ethereum.org/EIPS/eip-721
3374  */
3375 interface IERC721Enumerable is IERC721 {
3376     /**
3377      * @dev Returns the total amount of tokens stored by the contract.
3378      */
3379     function totalSupply() external view returns (uint256);
3380 
3381     /**
3382      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
3383      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
3384      */
3385     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
3386 
3387     /**
3388      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
3389      * Use along with {totalSupply} to enumerate all tokens.
3390      */
3391     function tokenByIndex(uint256 index) external view returns (uint256);
3392 }
3393 
3394 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
3395 
3396 
3397 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
3398 
3399 pragma solidity ^0.8.0;
3400 
3401 
3402 /**
3403  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
3404  * @dev See https://eips.ethereum.org/EIPS/eip-721
3405  */
3406 interface IERC721Metadata is IERC721 {
3407     /**
3408      * @dev Returns the token collection name.
3409      */
3410     function name() external view returns (string memory);
3411 
3412     /**
3413      * @dev Returns the token collection symbol.
3414      */
3415     function symbol() external view returns (string memory);
3416 
3417     /**
3418      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
3419      */
3420     function tokenURI(uint256 tokenId) external view returns (string memory);
3421 }
3422 
3423 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
3424 
3425 
3426 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/ERC721.sol)
3427 
3428 pragma solidity ^0.8.0;
3429 
3430 
3431 
3432 
3433 
3434 
3435 
3436 
3437 /**
3438  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
3439  * the Metadata extension, but not including the Enumerable extension, which is available separately as
3440  * {ERC721Enumerable}.
3441  */
3442 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
3443     using Address for address;
3444     using Strings for uint256;
3445 
3446     // Token name
3447     string private _name;
3448 
3449     // Token symbol
3450     string private _symbol;
3451 
3452     // Mapping from token ID to owner address
3453     mapping(uint256 => address) private _owners;
3454 
3455     // Mapping owner address to token count
3456     mapping(address => uint256) private _balances;
3457 
3458     // Mapping from token ID to approved address
3459     mapping(uint256 => address) private _tokenApprovals;
3460 
3461     // Mapping from owner to operator approvals
3462     mapping(address => mapping(address => bool)) private _operatorApprovals;
3463 
3464     /**
3465      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
3466      */
3467     constructor(string memory name_, string memory symbol_) {
3468         _name = name_;
3469         _symbol = symbol_;
3470     }
3471 
3472     /**
3473      * @dev See {IERC165-supportsInterface}.
3474      */
3475     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
3476         return
3477             interfaceId == type(IERC721).interfaceId ||
3478             interfaceId == type(IERC721Metadata).interfaceId ||
3479             super.supportsInterface(interfaceId);
3480     }
3481 
3482     /**
3483      * @dev See {IERC721-balanceOf}.
3484      */
3485     function balanceOf(address owner) public view virtual override returns (uint256) {
3486         require(owner != address(0), "ERC721: address zero is not a valid owner");
3487         return _balances[owner];
3488     }
3489 
3490     /**
3491      * @dev See {IERC721-ownerOf}.
3492      */
3493     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
3494         address owner = _ownerOf(tokenId);
3495         require(owner != address(0), "ERC721: invalid token ID");
3496         return owner;
3497     }
3498 
3499     /**
3500      * @dev See {IERC721Metadata-name}.
3501      */
3502     function name() public view virtual override returns (string memory) {
3503         return _name;
3504     }
3505 
3506     /**
3507      * @dev See {IERC721Metadata-symbol}.
3508      */
3509     function symbol() public view virtual override returns (string memory) {
3510         return _symbol;
3511     }
3512 
3513     /**
3514      * @dev See {IERC721Metadata-tokenURI}.
3515      */
3516     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
3517         _requireMinted(tokenId);
3518 
3519         string memory baseURI = _baseURI();
3520         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
3521     }
3522 
3523     /**
3524      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
3525      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
3526      * by default, can be overridden in child contracts.
3527      */
3528     function _baseURI() internal view virtual returns (string memory) {
3529         return "";
3530     }
3531 
3532     /**
3533      * @dev See {IERC721-approve}.
3534      */
3535     function approve(address to, uint256 tokenId) public virtual override {
3536         address owner = ERC721.ownerOf(tokenId);
3537         require(to != owner, "ERC721: approval to current owner");
3538 
3539         require(
3540             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
3541             "ERC721: approve caller is not token owner or approved for all"
3542         );
3543 
3544         _approve(to, tokenId);
3545     }
3546 
3547     /**
3548      * @dev See {IERC721-getApproved}.
3549      */
3550     function getApproved(uint256 tokenId) public view virtual override returns (address) {
3551         _requireMinted(tokenId);
3552 
3553         return _tokenApprovals[tokenId];
3554     }
3555 
3556     /**
3557      * @dev See {IERC721-setApprovalForAll}.
3558      */
3559     function setApprovalForAll(address operator, bool approved) public virtual override {
3560         _setApprovalForAll(_msgSender(), operator, approved);
3561     }
3562 
3563     /**
3564      * @dev See {IERC721-isApprovedForAll}.
3565      */
3566     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
3567         return _operatorApprovals[owner][operator];
3568     }
3569 
3570     /**
3571      * @dev See {IERC721-transferFrom}.
3572      */
3573     function transferFrom(
3574         address from,
3575         address to,
3576         uint256 tokenId
3577     ) public virtual override {
3578         //solhint-disable-next-line max-line-length
3579         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
3580 
3581         _transfer(from, to, tokenId);
3582     }
3583 
3584     /**
3585      * @dev See {IERC721-safeTransferFrom}.
3586      */
3587     function safeTransferFrom(
3588         address from,
3589         address to,
3590         uint256 tokenId
3591     ) public virtual override {
3592         safeTransferFrom(from, to, tokenId, "");
3593     }
3594 
3595     /**
3596      * @dev See {IERC721-safeTransferFrom}.
3597      */
3598     function safeTransferFrom(
3599         address from,
3600         address to,
3601         uint256 tokenId,
3602         bytes memory data
3603     ) public virtual override {
3604         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
3605         _safeTransfer(from, to, tokenId, data);
3606     }
3607 
3608     /**
3609      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
3610      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
3611      *
3612      * `data` is additional data, it has no specified format and it is sent in call to `to`.
3613      *
3614      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
3615      * implement alternative mechanisms to perform token transfer, such as signature-based.
3616      *
3617      * Requirements:
3618      *
3619      * - `from` cannot be the zero address.
3620      * - `to` cannot be the zero address.
3621      * - `tokenId` token must exist and be owned by `from`.
3622      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
3623      *
3624      * Emits a {Transfer} event.
3625      */
3626     function _safeTransfer(
3627         address from,
3628         address to,
3629         uint256 tokenId,
3630         bytes memory data
3631     ) internal virtual {
3632         _transfer(from, to, tokenId);
3633         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
3634     }
3635 
3636     /**
3637      * @dev Returns the owner of the `tokenId`. Does NOT revert if token doesn't exist
3638      */
3639     function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
3640         return _owners[tokenId];
3641     }
3642 
3643     /**
3644      * @dev Returns whether `tokenId` exists.
3645      *
3646      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
3647      *
3648      * Tokens start existing when they are minted (`_mint`),
3649      * and stop existing when they are burned (`_burn`).
3650      */
3651     function _exists(uint256 tokenId) internal view virtual returns (bool) {
3652         return _ownerOf(tokenId) != address(0);
3653     }
3654 
3655     /**
3656      * @dev Returns whether `spender` is allowed to manage `tokenId`.
3657      *
3658      * Requirements:
3659      *
3660      * - `tokenId` must exist.
3661      */
3662     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
3663         address owner = ERC721.ownerOf(tokenId);
3664         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
3665     }
3666 
3667     /**
3668      * @dev Safely mints `tokenId` and transfers it to `to`.
3669      *
3670      * Requirements:
3671      *
3672      * - `tokenId` must not exist.
3673      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
3674      *
3675      * Emits a {Transfer} event.
3676      */
3677     function _safeMint(address to, uint256 tokenId) internal virtual {
3678         _safeMint(to, tokenId, "");
3679     }
3680 
3681     /**
3682      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
3683      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
3684      */
3685     function _safeMint(
3686         address to,
3687         uint256 tokenId,
3688         bytes memory data
3689     ) internal virtual {
3690         _mint(to, tokenId);
3691         require(
3692             _checkOnERC721Received(address(0), to, tokenId, data),
3693             "ERC721: transfer to non ERC721Receiver implementer"
3694         );
3695     }
3696 
3697     /**
3698      * @dev Mints `tokenId` and transfers it to `to`.
3699      *
3700      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
3701      *
3702      * Requirements:
3703      *
3704      * - `tokenId` must not exist.
3705      * - `to` cannot be the zero address.
3706      *
3707      * Emits a {Transfer} event.
3708      */
3709     function _mint(address to, uint256 tokenId) internal virtual {
3710         require(to != address(0), "ERC721: mint to the zero address");
3711         require(!_exists(tokenId), "ERC721: token already minted");
3712 
3713         _beforeTokenTransfer(address(0), to, tokenId, 1);
3714 
3715         // Check that tokenId was not minted by `_beforeTokenTransfer` hook
3716         require(!_exists(tokenId), "ERC721: token already minted");
3717 
3718         unchecked {
3719             // Will not overflow unless all 2**256 token ids are minted to the same owner.
3720             // Given that tokens are minted one by one, it is impossible in practice that
3721             // this ever happens. Might change if we allow batch minting.
3722             // The ERC fails to describe this case.
3723             _balances[to] += 1;
3724         }
3725 
3726         _owners[tokenId] = to;
3727 
3728         emit Transfer(address(0), to, tokenId);
3729 
3730         _afterTokenTransfer(address(0), to, tokenId, 1);
3731     }
3732 
3733     /**
3734      * @dev Destroys `tokenId`.
3735      * The approval is cleared when the token is burned.
3736      * This is an internal function that does not check if the sender is authorized to operate on the token.
3737      *
3738      * Requirements:
3739      *
3740      * - `tokenId` must exist.
3741      *
3742      * Emits a {Transfer} event.
3743      */
3744     function _burn(uint256 tokenId) internal virtual {
3745         address owner = ERC721.ownerOf(tokenId);
3746 
3747         _beforeTokenTransfer(owner, address(0), tokenId, 1);
3748 
3749         // Update ownership in case tokenId was transferred by `_beforeTokenTransfer` hook
3750         owner = ERC721.ownerOf(tokenId);
3751 
3752         // Clear approvals
3753         delete _tokenApprovals[tokenId];
3754 
3755         unchecked {
3756             // Cannot overflow, as that would require more tokens to be burned/transferred
3757             // out than the owner initially received through minting and transferring in.
3758             _balances[owner] -= 1;
3759         }
3760         delete _owners[tokenId];
3761 
3762         emit Transfer(owner, address(0), tokenId);
3763 
3764         _afterTokenTransfer(owner, address(0), tokenId, 1);
3765     }
3766 
3767     /**
3768      * @dev Transfers `tokenId` from `from` to `to`.
3769      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
3770      *
3771      * Requirements:
3772      *
3773      * - `to` cannot be the zero address.
3774      * - `tokenId` token must be owned by `from`.
3775      *
3776      * Emits a {Transfer} event.
3777      */
3778     function _transfer(
3779         address from,
3780         address to,
3781         uint256 tokenId
3782     ) internal virtual {
3783         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
3784         require(to != address(0), "ERC721: transfer to the zero address");
3785 
3786         _beforeTokenTransfer(from, to, tokenId, 1);
3787 
3788         // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
3789         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
3790 
3791         // Clear approvals from the previous owner
3792         delete _tokenApprovals[tokenId];
3793 
3794         unchecked {
3795             // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
3796             // `from`'s balance is the number of token held, which is at least one before the current
3797             // transfer.
3798             // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
3799             // all 2**256 token ids to be minted, which in practice is impossible.
3800             _balances[from] -= 1;
3801             _balances[to] += 1;
3802         }
3803         _owners[tokenId] = to;
3804 
3805         emit Transfer(from, to, tokenId);
3806 
3807         _afterTokenTransfer(from, to, tokenId, 1);
3808     }
3809 
3810     /**
3811      * @dev Approve `to` to operate on `tokenId`
3812      *
3813      * Emits an {Approval} event.
3814      */
3815     function _approve(address to, uint256 tokenId) internal virtual {
3816         _tokenApprovals[tokenId] = to;
3817         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
3818     }
3819 
3820     /**
3821      * @dev Approve `operator` to operate on all of `owner` tokens
3822      *
3823      * Emits an {ApprovalForAll} event.
3824      */
3825     function _setApprovalForAll(
3826         address owner,
3827         address operator,
3828         bool approved
3829     ) internal virtual {
3830         require(owner != operator, "ERC721: approve to caller");
3831         _operatorApprovals[owner][operator] = approved;
3832         emit ApprovalForAll(owner, operator, approved);
3833     }
3834 
3835     /**
3836      * @dev Reverts if the `tokenId` has not been minted yet.
3837      */
3838     function _requireMinted(uint256 tokenId) internal view virtual {
3839         require(_exists(tokenId), "ERC721: invalid token ID");
3840     }
3841 
3842     /**
3843      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
3844      * The call is not executed if the target address is not a contract.
3845      *
3846      * @param from address representing the previous owner of the given token ID
3847      * @param to target address that will receive the tokens
3848      * @param tokenId uint256 ID of the token to be transferred
3849      * @param data bytes optional data to send along with the call
3850      * @return bool whether the call correctly returned the expected magic value
3851      */
3852     function _checkOnERC721Received(
3853         address from,
3854         address to,
3855         uint256 tokenId,
3856         bytes memory data
3857     ) private returns (bool) {
3858         if (to.isContract()) {
3859             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
3860                 return retval == IERC721Receiver.onERC721Received.selector;
3861             } catch (bytes memory reason) {
3862                 if (reason.length == 0) {
3863                     revert("ERC721: transfer to non ERC721Receiver implementer");
3864                 } else {
3865                     /// @solidity memory-safe-assembly
3866                     assembly {
3867                         revert(add(32, reason), mload(reason))
3868                     }
3869                 }
3870             }
3871         } else {
3872             return true;
3873         }
3874     }
3875 
3876     /**
3877      * @dev Hook that is called before any token transfer. This includes minting and burning. If {ERC721Consecutive} is
3878      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
3879      *
3880      * Calling conditions:
3881      *
3882      * - When `from` and `to` are both non-zero, ``from``'s tokens will be transferred to `to`.
3883      * - When `from` is zero, the tokens will be minted for `to`.
3884      * - When `to` is zero, ``from``'s tokens will be burned.
3885      * - `from` and `to` are never both zero.
3886      * - `batchSize` is non-zero.
3887      *
3888      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
3889      */
3890     function _beforeTokenTransfer(
3891         address from,
3892         address to,
3893         uint256, /* firstTokenId */
3894         uint256 batchSize
3895     ) internal virtual {
3896         if (batchSize > 1) {
3897             if (from != address(0)) {
3898                 _balances[from] -= batchSize;
3899             }
3900             if (to != address(0)) {
3901                 _balances[to] += batchSize;
3902             }
3903         }
3904     }
3905 
3906     /**
3907      * @dev Hook that is called after any token transfer. This includes minting and burning. If {ERC721Consecutive} is
3908      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
3909      *
3910      * Calling conditions:
3911      *
3912      * - When `from` and `to` are both non-zero, ``from``'s tokens were transferred to `to`.
3913      * - When `from` is zero, the tokens were minted for `to`.
3914      * - When `to` is zero, ``from``'s tokens were burned.
3915      * - `from` and `to` are never both zero.
3916      * - `batchSize` is non-zero.
3917      *
3918      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
3919      */
3920     function _afterTokenTransfer(
3921         address from,
3922         address to,
3923         uint256 firstTokenId,
3924         uint256 batchSize
3925     ) internal virtual {}
3926 }
3927 
3928 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
3929 
3930 
3931 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/extensions/ERC721Enumerable.sol)
3932 
3933 pragma solidity ^0.8.0;
3934 
3935 
3936 
3937 /**
3938  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
3939  * enumerability of all the token ids in the contract as well as all token ids owned by each
3940  * account.
3941  */
3942 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
3943     // Mapping from owner to list of owned token IDs
3944     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
3945 
3946     // Mapping from token ID to index of the owner tokens list
3947     mapping(uint256 => uint256) private _ownedTokensIndex;
3948 
3949     // Array with all token ids, used for enumeration
3950     uint256[] private _allTokens;
3951 
3952     // Mapping from token id to position in the allTokens array
3953     mapping(uint256 => uint256) private _allTokensIndex;
3954 
3955     /**
3956      * @dev See {IERC165-supportsInterface}.
3957      */
3958     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
3959         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
3960     }
3961 
3962     /**
3963      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
3964      */
3965     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
3966         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
3967         return _ownedTokens[owner][index];
3968     }
3969 
3970     /**
3971      * @dev See {IERC721Enumerable-totalSupply}.
3972      */
3973     function totalSupply() public view virtual override returns (uint256) {
3974         return _allTokens.length;
3975     }
3976 
3977     /**
3978      * @dev See {IERC721Enumerable-tokenByIndex}.
3979      */
3980     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
3981         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
3982         return _allTokens[index];
3983     }
3984 
3985     /**
3986      * @dev See {ERC721-_beforeTokenTransfer}.
3987      */
3988     function _beforeTokenTransfer(
3989         address from,
3990         address to,
3991         uint256 firstTokenId,
3992         uint256 batchSize
3993     ) internal virtual override {
3994         super._beforeTokenTransfer(from, to, firstTokenId, batchSize);
3995 
3996         if (batchSize > 1) {
3997             // Will only trigger during construction. Batch transferring (minting) is not available afterwards.
3998             revert("ERC721Enumerable: consecutive transfers not supported");
3999         }
4000 
4001         uint256 tokenId = firstTokenId;
4002 
4003         if (from == address(0)) {
4004             _addTokenToAllTokensEnumeration(tokenId);
4005         } else if (from != to) {
4006             _removeTokenFromOwnerEnumeration(from, tokenId);
4007         }
4008         if (to == address(0)) {
4009             _removeTokenFromAllTokensEnumeration(tokenId);
4010         } else if (to != from) {
4011             _addTokenToOwnerEnumeration(to, tokenId);
4012         }
4013     }
4014 
4015     /**
4016      * @dev Private function to add a token to this extension's ownership-tracking data structures.
4017      * @param to address representing the new owner of the given token ID
4018      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
4019      */
4020     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
4021         uint256 length = ERC721.balanceOf(to);
4022         _ownedTokens[to][length] = tokenId;
4023         _ownedTokensIndex[tokenId] = length;
4024     }
4025 
4026     /**
4027      * @dev Private function to add a token to this extension's token tracking data structures.
4028      * @param tokenId uint256 ID of the token to be added to the tokens list
4029      */
4030     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
4031         _allTokensIndex[tokenId] = _allTokens.length;
4032         _allTokens.push(tokenId);
4033     }
4034 
4035     /**
4036      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
4037      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
4038      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
4039      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
4040      * @param from address representing the previous owner of the given token ID
4041      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
4042      */
4043     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
4044         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
4045         // then delete the last slot (swap and pop).
4046 
4047         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
4048         uint256 tokenIndex = _ownedTokensIndex[tokenId];
4049 
4050         // When the token to delete is the last token, the swap operation is unnecessary
4051         if (tokenIndex != lastTokenIndex) {
4052             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
4053 
4054             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
4055             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
4056         }
4057 
4058         // This also deletes the contents at the last position of the array
4059         delete _ownedTokensIndex[tokenId];
4060         delete _ownedTokens[from][lastTokenIndex];
4061     }
4062 
4063     /**
4064      * @dev Private function to remove a token from this extension's token tracking data structures.
4065      * This has O(1) time complexity, but alters the order of the _allTokens array.
4066      * @param tokenId uint256 ID of the token to be removed from the tokens list
4067      */
4068     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
4069         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
4070         // then delete the last slot (swap and pop).
4071 
4072         uint256 lastTokenIndex = _allTokens.length - 1;
4073         uint256 tokenIndex = _allTokensIndex[tokenId];
4074 
4075         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
4076         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
4077         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
4078         uint256 lastTokenId = _allTokens[lastTokenIndex];
4079 
4080         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
4081         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
4082 
4083         // This also deletes the contents at the last position of the array
4084         delete _allTokensIndex[tokenId];
4085         _allTokens.pop();
4086     }
4087 }
4088 
4089 // File: contracts/devilCat_Staking.sol
4090 pragma solidity ^0.8.11;
4091 
4092 contract $TOON is ERC20Burnable, Ownable {
4093     using SafeMath for uint256;
4094 
4095     ERC721A public devilCatzNft;
4096 
4097     uint256 public cost = 0.0005 ether;
4098     event Bought(uint256 amount);
4099     uint256 public maxSupply = 1235813;
4100     uint256 public stakedNfts = 0;
4101     uint256 public rewardsTime = 86400;
4102 
4103     bool public nftStakingPaused = false;
4104     bool public rewardsCollectionPaused = false;
4105     mapping(address => mapping(uint256 => uint256)) public nftStakersWithTime;
4106     mapping(address => uint256[]) private nftStakersWithArray;
4107     mapping(address => uint256) public rewardsInWei;
4108 
4109     constructor() payable ERC20("$TOON", "$TOON") {
4110         _mint(address(this), 935813);
4111         _mint(0x1aBC6efe814F2766003d0c4AA5496B9b0EBC6eA3, 150000);
4112         _mint(0x4538C3d93FfdE7677EF66aB548a4Dd7f39eca785, 150000);
4113         devilCatzNft = ERC721A(0x1c4a28690482b03F6991C8c24295016cba197C12);
4114     }
4115 
4116     function getUsersStakedNfts(address _staker)
4117         public
4118         view
4119         returns (uint256[] memory)
4120     {
4121         return nftStakersWithArray[_staker];
4122     }
4123 
4124     function decimals() public view virtual override returns (uint8) {
4125         return 0;
4126     }
4127 
4128     function circulatingSupply() public view returns (uint256) {
4129         return (this.totalSupply() - balanceOf(address(this)));
4130     }
4131 
4132     function setMaxSupply(uint256 _amount) public onlyOwner {
4133         require(
4134             circulatingSupply() < _amount,
4135             "Cant set new total supply less than old supply."
4136         );
4137         maxSupply = _amount;
4138     }
4139 
4140     function setNftStakingPaused(bool _b) public onlyOwner {
4141         nftStakingPaused = _b;
4142     }
4143 
4144     function setRewardsCollectionPaused(bool _b) public onlyOwner {
4145         rewardsCollectionPaused = _b;
4146     }
4147 
4148     function buy(uint256 _quantity) public payable {
4149         require(_quantity > 0, "Quantity needs to be greater than 1");
4150         require(
4151             balanceOf(address(this)) > _quantity,
4152             "Not enough left in contract to buy.."
4153         );
4154         uint256 totalCostEth = _quantity * cost;
4155         require(msg.value >= totalCostEth, "Did not send enough ETH");
4156         _transfer(address(this), msg.sender, _quantity);
4157         emit Bought(_quantity);
4158     }
4159 
4160     function withdrawEthFromContract(uint256 _amount) public payable onlyOwner {
4161         (bool os, ) = payable(owner()).call{value: _amount}("");
4162         require(os);
4163     }
4164 
4165     function withdrawToonFromContract(uint256 _amount)
4166         public
4167         payable
4168         onlyOwner
4169     {
4170         _transfer(address(this), owner(), _amount);
4171     }
4172 
4173     function sendToonFromConract(address addy, uint256 _amount)
4174         public
4175         payable
4176         onlyOwner
4177     {
4178         _transfer(address(this), addy, _amount);
4179     }
4180 
4181     function setCost(uint256 _newCost) public onlyOwner {
4182         cost = _newCost;
4183     }
4184 
4185     function burn(uint256 _amount) public virtual override {
4186         _burn(_msgSender(), _amount);
4187         maxSupply -= _amount;
4188     }
4189 
4190     function stakeNft(uint256 _tokenID) public {
4191         require(!nftStakingPaused, "Staking NFTs is currently paused.");
4192         require(
4193             nftStakersWithTime[msg.sender][_tokenID] == 0,
4194             "This token already staked."
4195         );
4196         devilCatzNft.transferFrom(msg.sender, address(this), _tokenID);
4197         nftStakersWithTime[msg.sender][_tokenID] = block.timestamp;
4198         stakedNfts += 1;
4199         nftStakersWithArray[msg.sender].push(_tokenID);
4200     }
4201 
4202     function stakeMultipleNfts(uint256[] calldata _nftIds) public {
4203         require(!nftStakingPaused, "Staking NFTs is currently paused.");
4204         for (uint256 i = 0; i <= _nftIds.length - 1; i++) {
4205             require(
4206                 devilCatzNft.ownerOf(_nftIds[i]) == msg.sender,
4207                 "Not all of those NFTs are in your current wallet."
4208             );
4209 
4210             devilCatzNft.transferFrom(msg.sender, address(this), _nftIds[i]);
4211             nftStakersWithTime[msg.sender][_nftIds[i]] = block.timestamp;
4212             stakedNfts += 1;
4213             nftStakersWithArray[msg.sender].push(_nftIds[i]);
4214         }
4215     }
4216 
4217     function potentialAllStakedNftReward(address _addy)
4218         public
4219         view
4220         returns (uint256)
4221     {
4222         uint256[] memory nfts = getUsersStakedNfts(_addy);
4223         uint256 intDate = 0;
4224         uint256 subtracted = 0;
4225         uint256 utilToken = 0;
4226 
4227         for (uint256 i = 0; i < nfts.length; i++) {
4228             if (nftStakersWithTime[_addy][nfts[i]] != 0) {
4229                 intDate = nftStakersWithTime[_addy][nfts[i]];
4230                 subtracted = block.timestamp - intDate;
4231                 utilToken += subtracted / rewardsTime;
4232             }
4233         }
4234         return utilToken * 1;
4235     }
4236 
4237     function potentialStakedNftReward(address _addy, uint256 _tokenID)
4238         public
4239         view
4240         returns (uint256)
4241     {
4242         require(
4243             nftStakersWithTime[_addy][_tokenID] != 0,
4244             "This token not staked."
4245         );
4246         uint256 intDate = nftStakersWithTime[_addy][_tokenID];
4247         uint256 subtracted = block.timestamp - intDate;
4248         uint256 tokens = subtracted / rewardsTime;
4249         return tokens * 1;
4250     }
4251 
4252     function collectStakedNftReward(address _addy, uint256 _tokenID) public {
4253         require(!nftStakingPaused, "Staking NFTs is currently paused.");
4254         require(
4255             nftStakersWithTime[_addy][_tokenID] != 0,
4256             "This token not staked."
4257         );
4258         require(
4259             potentialStakedNftReward(_addy, _tokenID) != 0,
4260             "You dont have enough to claim."
4261         );
4262 
4263         uint256 tokens = potentialStakedNftReward(_addy, _tokenID);
4264         _transfer(address(this), _addy, tokens);
4265         nftStakersWithTime[_addy][_tokenID] = block.timestamp;
4266     }
4267 
4268     function collectMultipleStakedNftReward(uint256[] calldata _nftIds) public {
4269         require(
4270             !rewardsCollectionPaused,
4271             "Collecting Rewards is currently paused."
4272         );
4273 
4274         for (uint256 i = 0; i <= _nftIds.length-1; i++) {
4275             require(
4276                 nftStakersWithTime[msg.sender][_nftIds[i]] != 0,
4277                 "Not all those tokens are staked."
4278             );
4279         collectStakedNftReward(msg.sender, _nftIds[i]);
4280 
4281         }
4282 
4283     }
4284 
4285     function removeStakedNft(uint256 _stakedNFT) public {
4286         require(
4287             nftStakersWithTime[msg.sender][_stakedNFT] != 0,
4288             "Cant Unstake something your not staking."
4289         );
4290         devilCatzNft.transferFrom(address(this), msg.sender, _stakedNFT);
4291         nftStakersWithTime[msg.sender][_stakedNFT] = 0;
4292         stakedNfts -= 1;
4293 
4294         uint256[] storage tempArray = nftStakersWithArray[msg.sender];
4295         for (uint256 i = 0; i < tempArray.length; i++) {
4296             if (tempArray[i] == _stakedNFT) {
4297                 if (i >= tempArray.length) return;
4298 
4299                 for (uint256 j = i; j < tempArray.length - 1; j++) {
4300                     tempArray[j] = tempArray[j + 1];
4301                 }
4302                 tempArray.pop();
4303                 nftStakersWithArray[msg.sender] = tempArray;
4304             }
4305         }
4306     }
4307 
4308     function removeMultipleStakedNft(uint256[] calldata _nftIds) public {
4309         for (uint256 k = 0; k <= _nftIds.length - 1; k++) {
4310             require(
4311                 nftStakersWithTime[msg.sender][_nftIds[k]] != 0,
4312                 "Cant Unstake something your not staking."
4313             );
4314             removeStakedNft(_nftIds[k]);
4315 
4316         }
4317 
4318     }
4319 }