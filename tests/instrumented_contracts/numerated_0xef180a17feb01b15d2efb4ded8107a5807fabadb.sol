1 /** 
2 
3   _                                                   __                       _            _     ______                  _    
4  | |                                                 / _|     /\              (_)          | |   |  ____|                | |   
5  | |_ _ __ ___  __ _ ___ _   _ _ __ ___  ___    ___ | |_     /  \   _ __   ___ _  ___ _ __ | |_  | |__   __ _ _   _ _ __ | |_  
6  | __| '__/ _ \/ _` / __| | | | '__/ _ \/ __|  / _ \|  _|   / /\ \ | '_ \ / __| |/ _ \ '_ \| __| |  __| / _` | | | | '_ \| __| 
7  | |_| | |  __/ (_| \__ \ |_| | | |  __/\__ \ | (_) | |    / ____ \| | | | (__| |  __/ | | | |_  | |___| (_| | |_| | |_) | |_  
8   \__|_|  \___|\__,_|___/\__,_|_|  \___||___/  \___/|_|   /_/    \_\_| |_|\___|_|\___|_| |_|\__| |______\__, |\__, | .__/ \__| 
9                                                                                                          __/ | __/ | |         
10                                                                                                         |___/ |___/|_|         
11                                                                
12                                                                                                             
13 
14                                                                                                                           
15 */
16 
17 /**
18  *Submitted for verification at Etherscan.io on
19 */
20 // SPDX-License-Identifier: MIT
21 // File: @openzeppelin/contracts/utils/Context.sol
22 
23 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
24 
25 pragma solidity ^0.8.0;
26 
27 /**
28  * @dev Provides information about the current execution context, including the
29  * sender of the transaction and its data. While these are generally available
30  * via msg.sender and msg.data, they should not be accessed in such a direct
31  * manner, since when dealing with meta-transactions the account sending and
32  * paying for execution may not be the actual sender (as far as an application
33  * is concerned).
34  *
35  * This contract is only required for intermediate, library-like contracts.
36  */
37 abstract contract Context {
38     function _msgSender() internal view virtual returns (address) {
39         return msg.sender;
40     }
41 
42     function _msgData() internal view virtual returns (bytes calldata) {
43         return msg.data;
44     }
45 }
46 
47 // File: @openzeppelin/contracts/access/Ownable.sol
48 
49 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
50 
51 pragma solidity ^0.8.0;
52 
53 /**
54  * @dev Contract module which provides a basic access control mechanism, where
55  * there is an account (an owner) that can be granted exclusive access to
56  * specific functions.
57  *
58  * By default, the owner account will be the one that deploys the contract. This
59  * can later be changed with {transferOwnership}.
60  *
61  * This module is used through inheritance. It will make available the modifier
62  * `onlyOwner`, which can be applied to your functions to restrict their use to
63  * the owner.
64  */
65 abstract contract Ownable is Context {
66     address private _owner;
67 
68     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
69 
70     /**
71      * @dev Initializes the contract setting the deployer as the initial owner.
72      */
73     constructor() {
74         _transferOwnership(_msgSender());
75     }
76 
77     /**
78      * @dev Returns the address of the current owner.
79      */
80     function owner() public view virtual returns (address) {
81         return _owner;
82     }
83 
84     /**
85      * @dev Throws if called by any account other than the owner.
86      */
87     modifier onlyOwner() {
88         require(owner() == _msgSender(), "Ownable: caller is not the owner");
89         _;
90     }
91 
92     /**
93      * @dev Leaves the contract without owner. It will not be possible to call
94      * `onlyOwner` functions anymore. Can only be called by the current owner.
95      *
96      * NOTE: Renouncing ownership will leave the contract without an owner,
97      * thereby removing any functionality that is only available to the owner.
98      */
99     function renounceOwnership() public virtual onlyOwner {
100         _transferOwnership(address(0));
101     }
102 
103     /**
104      * @dev Transfers ownership of the contract to a new account (`newOwner`).
105      * Can only be called by the current owner.
106      */
107     function transferOwnership(address newOwner) public virtual onlyOwner {
108         require(newOwner != address(0), "Ownable: new owner is the zero address");
109         _transferOwnership(newOwner);
110     }
111 
112     /**
113      * @dev Transfers ownership of the contract to a new account (`newOwner`).
114      * Internal function without access restriction.
115      */
116     function _transferOwnership(address newOwner) internal virtual {
117         address oldOwner = _owner;
118         _owner = newOwner;
119         emit OwnershipTransferred(oldOwner, newOwner);
120     }
121 }
122 
123 // File: erc721a/contracts/IERC721A.sol
124 
125 // ERC721A Contracts v4.0.0
126 // Creator: Chiru Labs
127 
128 pragma solidity ^0.8.4;
129 
130 /**
131  * @dev Interface of an ERC721A compliant contract.
132  */
133 interface IERC721A {
134     /**
135      * The caller must own the token or be an approved operator.
136      */
137     error ApprovalCallerNotOwnerNorApproved();
138 
139     /**
140      * The token does not exist.
141      */
142     error ApprovalQueryForNonexistentToken();
143 
144     /**
145      * The caller cannot approve to their own address.
146      */
147     error ApproveToCaller();
148 
149     /**
150      * The caller cannot approve to the current owner.
151      */
152     error ApprovalToCurrentOwner();
153 
154     /**
155      * Cannot query the balance for the zero address.
156      */
157     error BalanceQueryForZeroAddress();
158 
159     /**
160      * Cannot mint to the zero address.
161      */
162     error MintToZeroAddress();
163 
164     /**
165      * The quantity of tokens minted must be more than zero.
166      */
167     error MintZeroQuantity();
168 
169     /**
170      * The token does not exist.
171      */
172     error OwnerQueryForNonexistentToken();
173 
174     /**
175      * The caller must own the token or be an approved operator.
176      */
177     error TransferCallerNotOwnerNorApproved();
178 
179     /**
180      * The token must be owned by `from`.
181      */
182     error TransferFromIncorrectOwner();
183 
184     /**
185      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
186      */
187     error TransferToNonERC721ReceiverImplementer();
188 
189     /**
190      * Cannot transfer to the zero address.
191      */
192     error TransferToZeroAddress();
193 
194     /**
195      * The token does not exist.
196      */
197     error URIQueryForNonexistentToken();
198 
199     struct TokenOwnership {
200         // The address of the owner.
201         address addr;
202         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
203         uint64 startTimestamp;
204         // Whether the token has been burned.
205         bool burned;
206     }
207 
208     /**
209      * @dev Returns the total amount of tokens stored by the contract.
210      *
211      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
212      */
213     function totalSupply() external view returns (uint256);
214 
215     // ==============================
216     //            IERC165
217     // ==============================
218 
219     /**
220      * @dev Returns true if this contract implements the interface defined by
221      * `interfaceId`. See the corresponding
222      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
223      * to learn more about how these ids are created.
224      *
225      * This function call must use less than 30 000 gas.
226      */
227     function supportsInterface(bytes4 interfaceId) external view returns (bool);
228 
229     // ==============================
230     //            IERC721
231     // ==============================
232 
233     /**
234      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
235      */
236     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
237 
238     /**
239      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
240      */
241     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
242 
243     /**
244      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
245      */
246     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
247 
248     /**
249      * @dev Returns the number of tokens in ``owner``'s account.
250      */
251     function balanceOf(address owner) external view returns (uint256 balance);
252 
253     /**
254      * @dev Returns the owner of the `tokenId` token.
255      *
256      * Requirements:
257      *
258      * - `tokenId` must exist.
259      */
260     function ownerOf(uint256 tokenId) external view returns (address owner);
261 
262     /**
263      * @dev Safely transfers `tokenId` token from `from` to `to`.
264      *
265      * Requirements:
266      *
267      * - `from` cannot be the zero address.
268      * - `to` cannot be the zero address.
269      * - `tokenId` token must exist and be owned by `from`.
270      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
271      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
272      *
273      * Emits a {Transfer} event.
274      */
275     function safeTransferFrom(
276         address from,
277         address to,
278         uint256 tokenId,
279         bytes calldata data
280     ) external;
281 
282     /**
283      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
284      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
285      *
286      * Requirements:
287      *
288      * - `from` cannot be the zero address.
289      * - `to` cannot be the zero address.
290      * - `tokenId` token must exist and be owned by `from`.
291      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
292      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
293      *
294      * Emits a {Transfer} event.
295      */
296     function safeTransferFrom(
297         address from,
298         address to,
299         uint256 tokenId
300     ) external;
301 
302     /**
303      * @dev Transfers `tokenId` token from `from` to `to`.
304      *
305      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
306      *
307      * Requirements:
308      *
309      * - `from` cannot be the zero address.
310      * - `to` cannot be the zero address.
311      * - `tokenId` token must be owned by `from`.
312      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
313      *
314      * Emits a {Transfer} event.
315      */
316     function transferFrom(
317         address from,
318         address to,
319         uint256 tokenId
320     ) external;
321 
322     /**
323      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
324      * The approval is cleared when the token is transferred.
325      *
326      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
327      *
328      * Requirements:
329      *
330      * - The caller must own the token or be an approved operator.
331      * - `tokenId` must exist.
332      *
333      * Emits an {Approval} event.
334      */
335     function approve(address to, uint256 tokenId) external;
336 
337     /**
338      * @dev Approve or remove `operator` as an operator for the caller.
339      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
340      *
341      * Requirements:
342      *
343      * - The `operator` cannot be the caller.
344      *
345      * Emits an {ApprovalForAll} event.
346      */
347     function setApprovalForAll(address operator, bool _approved) external;
348 
349     /**
350      * @dev Returns the account approved for `tokenId` token.
351      *
352      * Requirements:
353      *
354      * - `tokenId` must exist.
355      */
356     function getApproved(uint256 tokenId) external view returns (address operator);
357 
358     /**
359      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
360      *
361      * See {setApprovalForAll}
362      */
363     function isApprovedForAll(address owner, address operator) external view returns (bool);
364 
365     // ==============================
366     //        IERC721Metadata
367     // ==============================
368 
369     /**
370      * @dev Returns the token collection name.
371      */
372     function name() external view returns (string memory);
373 
374     /**
375      * @dev Returns the token collection symbol.
376      */
377     function symbol() external view returns (string memory);
378 
379     /**
380      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
381      */
382     function tokenURI(uint256 tokenId) external view returns (string memory);
383 }
384 
385 // File: erc721a/contracts/ERC721A.sol
386 
387 // ERC721A Contracts v4.0.0
388 // Creator: Chiru Labs
389 
390 pragma solidity ^0.8.4;
391 
392 /**
393  * @dev ERC721 token receiver interface.
394  */
395 interface ERC721A__IERC721Receiver {
396     function onERC721Received(
397         address operator,
398         address from,
399         uint256 tokenId,
400         bytes calldata data
401     ) external returns (bytes4);
402 }
403 
404 /**
405  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
406  * the Metadata extension. Built to optimize for lower gas during batch mints.
407  *
408  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
409  *
410  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
411  *
412  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
413  */
414 contract ERC721A is IERC721A {
415     // Mask of an entry in packed address data.
416     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
417 
418     // The bit position of `numberMinted` in packed address data.
419     uint256 private constant BITPOS_NUMBER_MINTED = 64;
420 
421     // The bit position of `numberBurned` in packed address data.
422     uint256 private constant BITPOS_NUMBER_BURNED = 128;
423 
424     // The bit position of `aux` in packed address data.
425     uint256 private constant BITPOS_AUX = 192;
426 
427     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
428     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
429 
430     // The bit position of `startTimestamp` in packed ownership.
431     uint256 private constant BITPOS_START_TIMESTAMP = 160;
432 
433     // The bit mask of the `burned` bit in packed ownership.
434     uint256 private constant BITMASK_BURNED = 1 << 224;
435     
436     // The bit position of the `nextInitialized` bit in packed ownership.
437     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
438 
439     // The bit mask of the `nextInitialized` bit in packed ownership.
440     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
441 
442     // The tokenId of the next token to be minted.
443     uint256 private _currentIndex;
444 
445     // The number of tokens burned.
446     uint256 private _burnCounter;
447 
448     // Token name
449     string private _name;
450 
451     // Token symbol
452     string private _symbol;
453 
454     // Mapping from token ID to ownership details
455     // An empty struct value does not necessarily mean the token is unowned.
456     // See `_packedOwnershipOf` implementation for details.
457     //
458     // Bits Layout:
459     // - [0..159]   `addr`
460     // - [160..223] `startTimestamp`
461     // - [224]      `burned`
462     // - [225]      `nextInitialized`
463     mapping(uint256 => uint256) private _packedOwnerships;
464 
465     // Mapping owner address to address data.
466     //
467     // Bits Layout:
468     // - [0..63]    `balance`
469     // - [64..127]  `numberMinted`
470     // - [128..191] `numberBurned`
471     // - [192..255] `aux`
472     mapping(address => uint256) private _packedAddressData;
473 
474     // Mapping from token ID to approved address.
475     mapping(uint256 => address) private _tokenApprovals;
476 
477     // Mapping from owner to operator approvals
478     mapping(address => mapping(address => bool)) private _operatorApprovals;
479 
480     constructor(string memory name_, string memory symbol_) {
481         _name = name_;
482         _symbol = symbol_;
483         _currentIndex = _startTokenId();
484     }
485 
486     /**
487      * @dev Returns the starting token ID. 
488      * To change the starting token ID, please override this function.
489      */
490     function _startTokenId() internal view virtual returns (uint256) {
491         return 0;
492     }
493 
494     /**
495      * @dev Returns the next token ID to be minted.
496      */
497     function _nextTokenId() internal view returns (uint256) {
498         return _currentIndex;
499     }
500 
501     /**
502      * @dev Returns the total number of tokens in existence.
503      * Burned tokens will reduce the count. 
504      * To get the total number of tokens minted, please see `_totalMinted`.
505      */
506     function totalSupply() public view override returns (uint256) {
507         // Counter underflow is impossible as _burnCounter cannot be incremented
508         // more than `_currentIndex - _startTokenId()` times.
509         unchecked {
510             return _currentIndex - _burnCounter - _startTokenId();
511         }
512     }
513 
514     /**
515      * @dev Returns the total amount of tokens minted in the contract.
516      */
517     function _totalMinted() internal view returns (uint256) {
518         // Counter underflow is impossible as _currentIndex does not decrement,
519         // and it is initialized to `_startTokenId()`
520         unchecked {
521             return _currentIndex - _startTokenId();
522         }
523     }
524 
525     /**
526      * @dev Returns the total number of tokens burned.
527      */
528     function _totalBurned() internal view returns (uint256) {
529         return _burnCounter;
530     }
531 
532     /**
533      * @dev See {IERC165-supportsInterface}.
534      */
535     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
536         // The interface IDs are constants representing the first 4 bytes of the XOR of
537         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
538         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
539         return
540             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
541             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
542             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
543     }
544 
545     /**
546      * @dev See {IERC721-balanceOf}.
547      */
548     function balanceOf(address owner) public view override returns (uint256) {
549         if (owner == address(0)) revert BalanceQueryForZeroAddress();
550         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
551     }
552 
553     /**
554      * Returns the number of tokens minted by `owner`.
555      */
556     function _numberMinted(address owner) internal view returns (uint256) {
557         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
558     }
559 
560     /**
561      * Returns the number of tokens burned by or on behalf of `owner`.
562      */
563     function _numberBurned(address owner) internal view returns (uint256) {
564         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
565     }
566 
567     /**
568      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
569      */
570     function _getAux(address owner) internal view returns (uint64) {
571         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
572     }
573 
574     /**
575      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
576      * If there are multiple variables, please pack them into a uint64.
577      */
578     function _setAux(address owner, uint64 aux) internal {
579         uint256 packed = _packedAddressData[owner];
580         uint256 auxCasted;
581         assembly { // Cast aux without masking.
582             auxCasted := aux
583         }
584         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
585         _packedAddressData[owner] = packed;
586     }
587 
588     /**
589      * Returns the packed ownership data of `tokenId`.
590      */
591     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
592         uint256 curr = tokenId;
593 
594         unchecked {
595             if (_startTokenId() <= curr)
596                 if (curr < _currentIndex) {
597                     uint256 packed = _packedOwnerships[curr];
598                     // If not burned.
599                     if (packed & BITMASK_BURNED == 0) {
600                         // Invariant:
601                         // There will always be an ownership that has an address and is not burned
602                         // before an ownership that does not have an address and is not burned.
603                         // Hence, curr will not underflow.
604                         //
605                         // We can directly compare the packed value.
606                         // If the address is zero, packed is zero.
607                         while (packed == 0) {
608                             packed = _packedOwnerships[--curr];
609                         }
610                         return packed;
611                     }
612                 }
613         }
614         revert OwnerQueryForNonexistentToken();
615     }
616 
617     /**
618      * Returns the unpacked `TokenOwnership` struct from `packed`.
619      */
620     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
621         ownership.addr = address(uint160(packed));
622         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
623         ownership.burned = packed & BITMASK_BURNED != 0;
624     }
625 
626     /**
627      * Returns the unpacked `TokenOwnership` struct at `index`.
628      */
629     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
630         return _unpackedOwnership(_packedOwnerships[index]);
631     }
632 
633     /**
634      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
635      */
636     function _initializeOwnershipAt(uint256 index) internal {
637         if (_packedOwnerships[index] == 0) {
638             _packedOwnerships[index] = _packedOwnershipOf(index);
639         }
640     }
641 
642     /**
643      * Gas spent here starts off proportional to the maximum mint batch size.
644      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
645      */
646     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
647         return _unpackedOwnership(_packedOwnershipOf(tokenId));
648     }
649 
650     /**
651      * @dev See {IERC721-ownerOf}.
652      */
653     function ownerOf(uint256 tokenId) public view override returns (address) {
654         return address(uint160(_packedOwnershipOf(tokenId)));
655     }
656 
657     /**
658      * @dev See {IERC721Metadata-name}.
659      */
660     function name() public view virtual override returns (string memory) {
661         return _name;
662     }
663 
664     /**
665      * @dev See {IERC721Metadata-symbol}.
666      */
667     function symbol() public view virtual override returns (string memory) {
668         return _symbol;
669     }
670 
671     /**
672      * @dev See {IERC721Metadata-tokenURI}.
673      */
674     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
675         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
676 
677         string memory baseURI = _baseURI();
678         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
679     }
680 
681     /**
682      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
683      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
684      * by default, can be overriden in child contracts.
685      */
686     function _baseURI() internal view virtual returns (string memory) {
687         return '';
688     }
689 
690     /**
691      * @dev Casts the address to uint256 without masking.
692      */
693     function _addressToUint256(address value) private pure returns (uint256 result) {
694         assembly {
695             result := value
696         }
697     }
698 
699     /**
700      * @dev Casts the boolean to uint256 without branching.
701      */
702     function _boolToUint256(bool value) private pure returns (uint256 result) {
703         assembly {
704             result := value
705         }
706     }
707 
708     /**
709      * @dev See {IERC721-approve}.
710      */
711     function approve(address to, uint256 tokenId) public override {
712         address owner = address(uint160(_packedOwnershipOf(tokenId)));
713         if (to == owner) revert ApprovalToCurrentOwner();
714 
715         if (_msgSenderERC721A() != owner)
716             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
717                 revert ApprovalCallerNotOwnerNorApproved();
718             }
719 
720         _tokenApprovals[tokenId] = to;
721         emit Approval(owner, to, tokenId);
722     }
723 
724     /**
725      * @dev See {IERC721-getApproved}.
726      */
727     function getApproved(uint256 tokenId) public view override returns (address) {
728         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
729 
730         return _tokenApprovals[tokenId];
731     }
732 
733     /**
734      * @dev See {IERC721-setApprovalForAll}.
735      */
736     function setApprovalForAll(address operator, bool approved) public virtual override {
737         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
738 
739         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
740         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
741     }
742 
743     /**
744      * @dev See {IERC721-isApprovedForAll}.
745      */
746     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
747         return _operatorApprovals[owner][operator];
748     }
749 
750     /**
751      * @dev See {IERC721-transferFrom}.
752      */
753     function transferFrom(
754         address from,
755         address to,
756         uint256 tokenId
757     ) public virtual override {
758         _transfer(from, to, tokenId);
759     }
760 
761     /**
762      * @dev See {IERC721-safeTransferFrom}.
763      */
764     function safeTransferFrom(
765         address from,
766         address to,
767         uint256 tokenId
768     ) public virtual override {
769         safeTransferFrom(from, to, tokenId, '');
770     }
771 
772     /**
773      * @dev See {IERC721-safeTransferFrom}.
774      */
775     function safeTransferFrom(
776         address from,
777         address to,
778         uint256 tokenId,
779         bytes memory _data
780     ) public virtual override {
781         _transfer(from, to, tokenId);
782         if (to.code.length != 0)
783             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
784                 revert TransferToNonERC721ReceiverImplementer();
785             }
786     }
787 
788     /**
789      * @dev Returns whether `tokenId` exists.
790      *
791      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
792      *
793      * Tokens start existing when they are minted (`_mint`),
794      */
795     function _exists(uint256 tokenId) internal view returns (bool) {
796         return
797             _startTokenId() <= tokenId &&
798             tokenId < _currentIndex && // If within bounds,
799             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
800     }
801 
802     /**
803      * @dev Equivalent to `_safeMint(to, quantity, '')`.
804      */
805     function _safeMint(address to, uint256 quantity) internal {
806         _safeMint(to, quantity, '');
807     }
808 
809     /**
810      * @dev Safely mints `quantity` tokens and transfers them to `to`.
811      *
812      * Requirements:
813      *
814      * - If `to` refers to a smart contract, it must implement
815      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
816      * - `quantity` must be greater than 0.
817      *
818      * Emits a {Transfer} event.
819      */
820     function _safeMint(
821         address to,
822         uint256 quantity,
823         bytes memory _data
824     ) internal {
825         uint256 startTokenId = _currentIndex;
826         if (to == address(0)) revert MintToZeroAddress();
827         if (quantity == 0) revert MintZeroQuantity();
828 
829         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
830 
831         // Overflows are incredibly unrealistic.
832         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
833         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
834         unchecked {
835             // Updates:
836             // - `balance += quantity`.
837             // - `numberMinted += quantity`.
838             //
839             // We can directly add to the balance and number minted.
840             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
841 
842             // Updates:
843             // - `address` to the owner.
844             // - `startTimestamp` to the timestamp of minting.
845             // - `burned` to `false`.
846             // - `nextInitialized` to `quantity == 1`.
847             _packedOwnerships[startTokenId] =
848                 _addressToUint256(to) |
849                 (block.timestamp << BITPOS_START_TIMESTAMP) |
850                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
851 
852             uint256 updatedIndex = startTokenId;
853             uint256 end = updatedIndex + quantity;
854 
855             if (to.code.length != 0) {
856                 do {
857                     emit Transfer(address(0), to, updatedIndex);
858                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
859                         revert TransferToNonERC721ReceiverImplementer();
860                     }
861                 } while (updatedIndex < end);
862                 // Reentrancy protection
863                 if (_currentIndex != startTokenId) revert();
864             } else {
865                 do {
866                     emit Transfer(address(0), to, updatedIndex++);
867                 } while (updatedIndex < end);
868             }
869             _currentIndex = updatedIndex;
870         }
871         _afterTokenTransfers(address(0), to, startTokenId, quantity);
872     }
873 
874     /**
875      * @dev Mints `quantity` tokens and transfers them to `to`.
876      *
877      * Requirements:
878      *
879      * - `to` cannot be the zero address.
880      * - `quantity` must be greater than 0.
881      *
882      * Emits a {Transfer} event.
883      */
884     function _mint(address to, uint256 quantity) internal {
885         uint256 startTokenId = _currentIndex;
886         if (to == address(0)) revert MintToZeroAddress();
887         if (quantity == 0) revert MintZeroQuantity();
888 
889         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
890 
891         // Overflows are incredibly unrealistic.
892         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
893         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
894         unchecked {
895             // Updates:
896             // - `balance += quantity`.
897             // - `numberMinted += quantity`.
898             //
899             // We can directly add to the balance and number minted.
900             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
901 
902             // Updates:
903             // - `address` to the owner.
904             // - `startTimestamp` to the timestamp of minting.
905             // - `burned` to `false`.
906             // - `nextInitialized` to `quantity == 1`.
907             _packedOwnerships[startTokenId] =
908                 _addressToUint256(to) |
909                 (block.timestamp << BITPOS_START_TIMESTAMP) |
910                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
911 
912             uint256 updatedIndex = startTokenId;
913             uint256 end = updatedIndex + quantity;
914 
915             do {
916                 emit Transfer(address(0), to, updatedIndex++);
917             } while (updatedIndex < end);
918 
919             _currentIndex = updatedIndex;
920         }
921         _afterTokenTransfers(address(0), to, startTokenId, quantity);
922     }
923 
924     /**
925      * @dev Transfers `tokenId` from `from` to `to`.
926      *
927      * Requirements:
928      *
929      * - `to` cannot be the zero address.
930      * - `tokenId` token must be owned by `from`.
931      *
932      * Emits a {Transfer} event.
933      */
934     function _transfer(
935         address from,
936         address to,
937         uint256 tokenId
938     ) private {
939         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
940 
941         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
942 
943         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
944             isApprovedForAll(from, _msgSenderERC721A()) ||
945             getApproved(tokenId) == _msgSenderERC721A());
946 
947         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
948         if (to == address(0)) revert TransferToZeroAddress();
949 
950         _beforeTokenTransfers(from, to, tokenId, 1);
951 
952         // Clear approvals from the previous owner.
953         delete _tokenApprovals[tokenId];
954 
955         // Underflow of the sender's balance is impossible because we check for
956         // ownership above and the recipient's balance can't realistically overflow.
957         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
958         unchecked {
959             // We can directly increment and decrement the balances.
960             --_packedAddressData[from]; // Updates: `balance -= 1`.
961             ++_packedAddressData[to]; // Updates: `balance += 1`.
962 
963             // Updates:
964             // - `address` to the next owner.
965             // - `startTimestamp` to the timestamp of transfering.
966             // - `burned` to `false`.
967             // - `nextInitialized` to `true`.
968             _packedOwnerships[tokenId] =
969                 _addressToUint256(to) |
970                 (block.timestamp << BITPOS_START_TIMESTAMP) |
971                 BITMASK_NEXT_INITIALIZED;
972 
973             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
974             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
975                 uint256 nextTokenId = tokenId + 1;
976                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
977                 if (_packedOwnerships[nextTokenId] == 0) {
978                     // If the next slot is within bounds.
979                     if (nextTokenId != _currentIndex) {
980                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
981                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
982                     }
983                 }
984             }
985         }
986 
987         emit Transfer(from, to, tokenId);
988         _afterTokenTransfers(from, to, tokenId, 1);
989     }
990 
991     /**
992      * @dev Equivalent to `_burn(tokenId, false)`.
993      */
994     function _burn(uint256 tokenId) internal virtual {
995         _burn(tokenId, false);
996     }
997 
998     /**
999      * @dev Destroys `tokenId`.
1000      * The approval is cleared when the token is burned.
1001      *
1002      * Requirements:
1003      *
1004      * - `tokenId` must exist.
1005      *
1006      * Emits a {Transfer} event.
1007      */
1008     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1009         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1010 
1011         address from = address(uint160(prevOwnershipPacked));
1012 
1013         if (approvalCheck) {
1014             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1015                 isApprovedForAll(from, _msgSenderERC721A()) ||
1016                 getApproved(tokenId) == _msgSenderERC721A());
1017 
1018             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1019         }
1020 
1021         _beforeTokenTransfers(from, address(0), tokenId, 1);
1022 
1023         // Clear approvals from the previous owner.
1024         delete _tokenApprovals[tokenId];
1025 
1026         // Underflow of the sender's balance is impossible because we check for
1027         // ownership above and the recipient's balance can't realistically overflow.
1028         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1029         unchecked {
1030             // Updates:
1031             // - `balance -= 1`.
1032             // - `numberBurned += 1`.
1033             //
1034             // We can directly decrement the balance, and increment the number burned.
1035             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1036             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1037 
1038             // Updates:
1039             // - `address` to the last owner.
1040             // - `startTimestamp` to the timestamp of burning.
1041             // - `burned` to `true`.
1042             // - `nextInitialized` to `true`.
1043             _packedOwnerships[tokenId] =
1044                 _addressToUint256(from) |
1045                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1046                 BITMASK_BURNED | 
1047                 BITMASK_NEXT_INITIALIZED;
1048 
1049             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1050             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1051                 uint256 nextTokenId = tokenId + 1;
1052                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1053                 if (_packedOwnerships[nextTokenId] == 0) {
1054                     // If the next slot is within bounds.
1055                     if (nextTokenId != _currentIndex) {
1056                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1057                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1058                     }
1059                 }
1060             }
1061         }
1062 
1063         emit Transfer(from, address(0), tokenId);
1064         _afterTokenTransfers(from, address(0), tokenId, 1);
1065 
1066         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1067         unchecked {
1068             _burnCounter++;
1069         }
1070     }
1071 
1072     /**
1073      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1074      *
1075      * @param from address representing the previous owner of the given token ID
1076      * @param to target address that will receive the tokens
1077      * @param tokenId uint256 ID of the token to be transferred
1078      * @param _data bytes optional data to send along with the call
1079      * @return bool whether the call correctly returned the expected magic value
1080      */
1081     function _checkContractOnERC721Received(
1082         address from,
1083         address to,
1084         uint256 tokenId,
1085         bytes memory _data
1086     ) private returns (bool) {
1087         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1088             bytes4 retval
1089         ) {
1090             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1091         } catch (bytes memory reason) {
1092             if (reason.length == 0) {
1093                 revert TransferToNonERC721ReceiverImplementer();
1094             } else {
1095                 assembly {
1096                     revert(add(32, reason), mload(reason))
1097                 }
1098             }
1099         }
1100     }
1101 
1102     /**
1103      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1104      * And also called before burning one token.
1105      *
1106      * startTokenId - the first token id to be transferred
1107      * quantity - the amount to be transferred
1108      *
1109      * Calling conditions:
1110      *
1111      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1112      * transferred to `to`.
1113      * - When `from` is zero, `tokenId` will be minted for `to`.
1114      * - When `to` is zero, `tokenId` will be burned by `from`.
1115      * - `from` and `to` are never both zero.
1116      */
1117     function _beforeTokenTransfers(
1118         address from,
1119         address to,
1120         uint256 startTokenId,
1121         uint256 quantity
1122     ) internal virtual {}
1123 
1124     /**
1125      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1126      * minting.
1127      * And also called after one token has been burned.
1128      *
1129      * startTokenId - the first token id to be transferred
1130      * quantity - the amount to be transferred
1131      *
1132      * Calling conditions:
1133      *
1134      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1135      * transferred to `to`.
1136      * - When `from` is zero, `tokenId` has been minted for `to`.
1137      * - When `to` is zero, `tokenId` has been burned by `from`.
1138      * - `from` and `to` are never both zero.
1139      */
1140     function _afterTokenTransfers(
1141         address from,
1142         address to,
1143         uint256 startTokenId,
1144         uint256 quantity
1145     ) internal virtual {}
1146 
1147     /**
1148      * @dev Returns the message sender (defaults to `msg.sender`).
1149      *
1150      * If you are writing GSN compatible contracts, you need to override this function.
1151      */
1152     function _msgSenderERC721A() internal view virtual returns (address) {
1153         return msg.sender;
1154     }
1155 
1156     /**
1157      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1158      */
1159     function _toString(uint256 value) internal pure returns (string memory ptr) {
1160         assembly {
1161             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1162             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1163             // We will need 1 32-byte word to store the length, 
1164             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1165             ptr := add(mload(0x40), 128)
1166             // Update the free memory pointer to allocate.
1167             mstore(0x40, ptr)
1168 
1169             // Cache the end of the memory to calculate the length later.
1170             let end := ptr
1171 
1172             // We write the string from the rightmost digit to the leftmost digit.
1173             // The following is essentially a do-while loop that also handles the zero case.
1174             // Costs a bit more than early returning for the zero case,
1175             // but cheaper in terms of deployment and overall runtime costs.
1176             for { 
1177                 // Initialize and perform the first pass without check.
1178                 let temp := value
1179                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1180                 ptr := sub(ptr, 1)
1181                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1182                 mstore8(ptr, add(48, mod(temp, 10)))
1183                 temp := div(temp, 10)
1184             } temp { 
1185                 // Keep dividing `temp` until zero.
1186                 temp := div(temp, 10)
1187             } { // Body of the for loop.
1188                 ptr := sub(ptr, 1)
1189                 mstore8(ptr, add(48, mod(temp, 10)))
1190             }
1191             
1192             let length := sub(end, ptr)
1193             // Move the pointer 32 bytes leftwards to make room for the length.
1194             ptr := sub(ptr, 32)
1195             // Store the length.
1196             mstore(ptr, length)
1197         }
1198     }
1199 }
1200 
1201 // File: nft.sol
1202 
1203 
1204 pragma solidity ^0.8.7;
1205 
1206 
1207 contract TheTreasuresofAncientEgyptOfficial is Ownable, ERC721A {
1208     uint256 public maxSupply                    = 7700;
1209     uint256 public maxFreeSupply                = 2000;
1210     
1211     uint256 public maxPerTxDuringMint           = 20;
1212     uint256 public maxPerAddressDuringMint      = 60;
1213     uint256 public maxPerAddressDuringFreeMint  = 5;
1214     
1215     uint256 public price                        = 0.002 ether;
1216     bool    public saleIsActive                 = true;
1217 
1218     address constant internal TEAM_ADDRESS = 0x33E8fce4ee1eB405E59E93c9E19AD8d0fFD9bc4e;
1219 
1220     string private _baseTokenURI="ipfs://QmXu8zUdGhvRAz2Z1xSQhwUfVfxst17HLH6Xx7V38ZsYCJ/";
1221 
1222     mapping(address => uint256) public freeMintedAmount;
1223     mapping(address => uint256) public mintedAmount;
1224 
1225     constructor() ERC721A("The Treasures of Ancient Egypt Official", "Treasure") {
1226         _safeMint(msg.sender, 50);
1227     }
1228 
1229     modifier mintCompliance() {
1230         require(saleIsActive, "Sale is not active yet.");
1231         require(tx.origin == msg.sender, "Caller cannot be a contract.");
1232         _;
1233     }
1234 
1235     function mint(uint256 _quantity) external payable mintCompliance() {
1236         require(
1237             msg.value >= price * _quantity,
1238             "GDZ: Insufficient Fund."
1239         );
1240         require(
1241             maxSupply >= totalSupply() + _quantity,
1242             "GDZ: Exceeds max supply."
1243         );
1244         uint256 _mintedAmount = mintedAmount[msg.sender];
1245         require(
1246             _mintedAmount + _quantity <= maxPerAddressDuringMint,
1247             "GDZ: Exceeds max mints per address!"
1248         );
1249         require(
1250             _quantity > 0 && _quantity <= maxPerTxDuringMint,
1251             "Invalid mint amount."
1252         );
1253         mintedAmount[msg.sender] = _mintedAmount + _quantity;
1254         _safeMint(msg.sender, _quantity);
1255     }
1256 
1257     function freeMint(uint256 _quantity) external mintCompliance() {
1258         require(
1259             maxFreeSupply >= totalSupply() + _quantity,
1260             "GDZ: Exceeds max free supply."
1261         );
1262         uint256 _freeMintedAmount = freeMintedAmount[msg.sender];
1263         require(
1264             _freeMintedAmount + _quantity <= maxPerAddressDuringFreeMint,
1265             "GDZ: Exceeds max free mints per address!"
1266         );
1267         freeMintedAmount[msg.sender] = _freeMintedAmount + _quantity;
1268         _safeMint(msg.sender, _quantity);
1269     }
1270 
1271     function setPrice(uint256 _price) external onlyOwner {
1272         price = _price;
1273     }
1274 
1275     function setMaxPerTx(uint256 _amount) external onlyOwner {
1276         maxPerTxDuringMint = _amount;
1277     }
1278 
1279     function setMaxPerAddress(uint256 _amount) external onlyOwner {
1280         maxPerAddressDuringMint = _amount;
1281     }
1282 
1283     function setMaxFreePerAddress(uint256 _amount) external onlyOwner {
1284         maxPerAddressDuringFreeMint = _amount;
1285     }
1286 
1287     function flipSale() public onlyOwner {
1288         saleIsActive = !saleIsActive;
1289     }
1290 
1291     function cutMaxSupply(uint256 _amount) public onlyOwner {
1292         require(
1293             maxSupply +_amount >= 1, 
1294             "Supply cannot fall below minted tokens."
1295         );
1296         maxSupply += _amount;
1297     }
1298 
1299     function setBaseURI(string calldata baseURI) external onlyOwner {
1300         _baseTokenURI = baseURI;
1301     }
1302 
1303     function _baseURI() internal view virtual override returns (string memory) {
1304         return _baseTokenURI;
1305     }
1306 
1307     function withdrawBalance() external payable onlyOwner {
1308 
1309         (bool success, ) = payable(TEAM_ADDRESS).call{
1310             value: address(this).balance
1311         }("");
1312         require(success, "transfer failed.");
1313     }
1314 }