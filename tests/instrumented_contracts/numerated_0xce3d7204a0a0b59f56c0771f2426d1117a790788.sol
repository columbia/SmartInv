1 /*
2 ─────────────────────────────────────────────────────────────────────────────
3 ─██████──────────██████─██████████████─██████████████─██████──────────██████─
4 ─██░░██████████──██░░██─██░░░░░░░░░░██─██░░░░░░░░░░██─██░░██████████──██░░██─
5 ─██░░░░░░░░░░██──██░░██─██░░██████████─██░░██████░░██─██░░░░░░░░░░██──██░░██─
6 ─██░░██████░░██──██░░██─██░░██─────────██░░██──██░░██─██░░██████░░██──██░░██─
7 ─██░░██──██░░██──██░░██─██░░██████████─██░░██──██░░██─██░░██──██░░██──██░░██─
8 ─██░░██──██░░██──██░░██─██░░░░░░░░░░██─██░░██──██░░██─██░░██──██░░██──██░░██─
9 ─██░░██──██░░██──██░░██─██░░██████████─██░░██──██░░██─██░░██──██░░██──██░░██─
10 ─██░░██──██░░██████░░██─██░░██─────────██░░██──██░░██─██░░██──██░░██████░░██─
11 ─██░░██──██░░░░░░░░░░██─██░░██████████─██░░██████░░██─██░░██──██░░░░░░░░░░██─
12 ─██░░██──██████████░░██─██░░░░░░░░░░██─██░░░░░░░░░░██─██░░██──██████████░░██─
13 ─██████──────────██████─██████████████─██████████████─██████──────────██████─
14 ─────────────────────────────────────────────────────────────────────────────
15 ───────────────────────────────────────────────────────────────────────────────
16 ────────────────██████████████─██████████████─██████████████───────────────────
17 ────────────────██░░░░░░░░░░██─██░░░░░░░░░░██─██░░░░░░░░░░██───────────────────
18 ────────────────██████████░░██─██░░██████████─██████████░░██───────────────────
19 ────────────────────────██░░██─██░░██─────────────────██░░██───────────────────
20 ────────────────██████████░░██─██░░██████████─██████████░░██───────────────────
21 ────────────────██░░░░░░░░░░██─██░░░░░░░░░░██─██░░░░░░░░░░██───────────────────
22 ────────────────██████████░░██─██░░██████░░██─██████████░░██───────────────────
23 ────────────────────────██░░██─██░░██──██░░██─────────██░░██───────────────────
24 ────────────────██████████░░██─██░░██████░░██─██████████░░██───────────────────
25 ────────────────██░░░░░░░░░░██─██░░░░░░░░░░██─██░░░░░░░░░░██───────────────────
26 ────────────────██████████████─██████████████─██████████████───────────────────
27 ───────────────────────────────────────────────────────────────────────────────
28 
29 */
30 
31 // SPDX-License-Identifier: SimPL-2.0
32 // File: @openzeppelin/contracts/utils/Context.sol
33 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
34 
35 pragma solidity ^0.8.0;
36 
37 /**
38  * @dev Provides information about the current execution context, including the
39  * sender of the transaction and its data. While these are generally available
40  * via msg.sender and msg.data, they should not be accessed in such a direct
41  * manner, since when dealing with meta-transactions the account sending and
42  * paying for execution may not be the actual sender (as far as an application
43  * is concerned).
44  *
45  * This contract is only required for intermediate, library-like contracts.
46  */
47 abstract contract Context {
48     function _msgSender() internal view virtual returns (address) {
49         return msg.sender;
50     }
51 
52     function _msgData() internal view virtual returns (bytes calldata) {
53         return msg.data;
54     }
55 }
56 
57 // File: @openzeppelin/contracts/access/Ownable.sol
58 
59 
60 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
61 
62 pragma solidity ^0.8.0;
63 
64 
65 /**
66  * @dev Contract module which provides a basic access control mechanism, where
67  * there is an account (an owner) that can be granted exclusive access to
68  * specific functions.
69  *
70  * By default, the owner account will be the one that deploys the contract. This
71  * can later be changed with {transferOwnership}.
72  *
73  * This module is used through inheritance. It will make available the modifier
74  * `onlyOwner`, which can be applied to your functions to restrict their use to
75  * the owner.
76  */
77 abstract contract Ownable is Context {
78     address private _owner;
79 
80     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
81 
82     /**
83      * @dev Initializes the contract setting the deployer as the initial owner.
84      */
85     constructor() {
86         _transferOwnership(_msgSender());
87     }
88 
89     /**
90      * @dev Returns the address of the current owner.
91      */
92     function owner() public view virtual returns (address) {
93         return _owner;
94     }
95 
96     /**
97      * @dev Throws if called by any account other than the owner.
98      */
99     modifier onlyOwner() {
100         require(owner() == _msgSender(), "Ownable: caller is not the owner");
101         _;
102     }
103 
104     /**
105      * @dev Leaves the contract without owner. It will not be possible to call
106      * `onlyOwner` functions anymore. Can only be called by the current owner.
107      *
108      * NOTE: Renouncing ownership will leave the contract without an owner,
109      * thereby removing any functionality that is only available to the owner.
110      */
111     function renounceOwnership() public virtual onlyOwner {
112         _transferOwnership(address(0));
113     }
114 
115     /**
116      * @dev Transfers ownership of the contract to a new account (`newOwner`).
117      * Can only be called by the current owner.
118      */
119     function transferOwnership(address newOwner) public virtual onlyOwner {
120         require(newOwner != address(0), "Ownable: new owner is the zero address");
121         _transferOwnership(newOwner);
122     }
123 
124     /**
125      * @dev Transfers ownership of the contract to a new account (`newOwner`).
126      * Internal function without access restriction.
127      */
128     function _transferOwnership(address newOwner) internal virtual {
129         address oldOwner = _owner;
130         _owner = newOwner;
131         emit OwnershipTransferred(oldOwner, newOwner);
132     }
133 }
134 
135 // File: erc721a/contracts/IERC721A.sol
136 
137 
138 // ERC721A Contracts v4.0.0
139 // Creator: Chiru Labs
140 
141 pragma solidity ^0.8.4;
142 
143 /**
144  * @dev Interface of an ERC721A compliant contract.
145  */
146 interface IERC721A {
147     /**
148      * The caller must own the token or be an approved operator.
149      */
150     error ApprovalCallerNotOwnerNorApproved();
151 
152     /**
153      * The token does not exist.
154      */
155     error ApprovalQueryForNonexistentToken();
156 
157     /**
158      * The caller cannot approve to their own address.
159      */
160     error ApproveToCaller();
161 
162     /**
163      * The caller cannot approve to the current owner.
164      */
165     error ApprovalToCurrentOwner();
166 
167     /**
168      * Cannot query the balance for the zero address.
169      */
170     error BalanceQueryForZeroAddress();
171 
172     /**
173      * Cannot mint to the zero address.
174      */
175     error MintToZeroAddress();
176 
177     /**
178      * The quantity of tokens minted must be more than zero.
179      */
180     error MintZeroQuantity();
181 
182     /**
183      * The token does not exist.
184      */
185     error OwnerQueryForNonexistentToken();
186 
187     /**
188      * The caller must own the token or be an approved operator.
189      */
190     error TransferCallerNotOwnerNorApproved();
191 
192     /**
193      * The token must be owned by `from`.
194      */
195     error TransferFromIncorrectOwner();
196 
197     /**
198      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
199      */
200     error TransferToNonERC721ReceiverImplementer();
201 
202     /**
203      * Cannot transfer to the zero address.
204      */
205     error TransferToZeroAddress();
206 
207     /**
208      * The token does not exist.
209      */
210     error URIQueryForNonexistentToken();
211 
212     struct TokenOwnership {
213         // The address of the owner.
214         address addr;
215         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
216         uint64 startTimestamp;
217         // Whether the token has been burned.
218         bool burned;
219     }
220 
221     /**
222      * @dev Returns the total amount of tokens stored by the contract.
223      *
224      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
225      */
226     function totalSupply() external view returns (uint256);
227 
228     // ==============================
229     //            IERC165
230     // ==============================
231 
232     /**
233      * @dev Returns true if this contract implements the interface defined by
234      * `interfaceId`. See the corresponding
235      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
236      * to learn more about how these ids are created.
237      *
238      * This function call must use less than 30 000 gas.
239      */
240     function supportsInterface(bytes4 interfaceId) external view returns (bool);
241 
242     // ==============================
243     //            IERC721
244     // ==============================
245 
246     /**
247      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
248      */
249     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
250 
251     /**
252      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
253      */
254     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
255 
256     /**
257      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
258      */
259     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
260 
261     /**
262      * @dev Returns the number of tokens in ``owner``'s account.
263      */
264     function balanceOf(address owner) external view returns (uint256 balance);
265 
266     /**
267      * @dev Returns the owner of the `tokenId` token.
268      *
269      * Requirements:
270      *
271      * - `tokenId` must exist.
272      */
273     function ownerOf(uint256 tokenId) external view returns (address owner);
274 
275     /**
276      * @dev Safely transfers `tokenId` token from `from` to `to`.
277      *
278      * Requirements:
279      *
280      * - `from` cannot be the zero address.
281      * - `to` cannot be the zero address.
282      * - `tokenId` token must exist and be owned by `from`.
283      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
284      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
285      *
286      * Emits a {Transfer} event.
287      */
288     function safeTransferFrom(
289         address from,
290         address to,
291         uint256 tokenId,
292         bytes calldata data
293     ) external;
294 
295     /**
296      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
297      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
298      *
299      * Requirements:
300      *
301      * - `from` cannot be the zero address.
302      * - `to` cannot be the zero address.
303      * - `tokenId` token must exist and be owned by `from`.
304      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
305      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
306      *
307      * Emits a {Transfer} event.
308      */
309     function safeTransferFrom(
310         address from,
311         address to,
312         uint256 tokenId
313     ) external;
314 
315     /**
316      * @dev Transfers `tokenId` token from `from` to `to`.
317      *
318      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
319      *
320      * Requirements:
321      *
322      * - `from` cannot be the zero address.
323      * - `to` cannot be the zero address.
324      * - `tokenId` token must be owned by `from`.
325      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
326      *
327      * Emits a {Transfer} event.
328      */
329     function transferFrom(
330         address from,
331         address to,
332         uint256 tokenId
333     ) external;
334 
335     /**
336      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
337      * The approval is cleared when the token is transferred.
338      *
339      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
340      *
341      * Requirements:
342      *
343      * - The caller must own the token or be an approved operator.
344      * - `tokenId` must exist.
345      *
346      * Emits an {Approval} event.
347      */
348     function approve(address to, uint256 tokenId) external;
349 
350     /**
351      * @dev Approve or remove `operator` as an operator for the caller.
352      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
353      *
354      * Requirements:
355      *
356      * - The `operator` cannot be the caller.
357      *
358      * Emits an {ApprovalForAll} event.
359      */
360     function setApprovalForAll(address operator, bool _approved) external;
361 
362     /**
363      * @dev Returns the account approved for `tokenId` token.
364      *
365      * Requirements:
366      *
367      * - `tokenId` must exist.
368      */
369     function getApproved(uint256 tokenId) external view returns (address operator);
370 
371     /**
372      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
373      *
374      * See {setApprovalForAll}
375      */
376     function isApprovedForAll(address owner, address operator) external view returns (bool);
377 
378     // ==============================
379     //        IERC721Metadata
380     // ==============================
381 
382     /**
383      * @dev Returns the token collection name.
384      */
385     function name() external view returns (string memory);
386 
387     /**
388      * @dev Returns the token collection symbol.
389      */
390     function symbol() external view returns (string memory);
391 
392     /**
393      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
394      */
395     function tokenURI(uint256 tokenId) external view returns (string memory);
396 }
397 
398 // File: erc721a/contracts/ERC721A.sol
399 
400 
401 // ERC721A Contracts v4.0.0
402 // Creator: Chiru Labs
403 
404 pragma solidity ^0.8.4;
405 
406 
407 /**
408  * @dev ERC721 token receiver interface.
409  */
410 interface ERC721A__IERC721Receiver {
411     function onERC721Received(
412         address operator,
413         address from,
414         uint256 tokenId,
415         bytes calldata data
416     ) external returns (bytes4);
417 }
418 
419 /**
420  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
421  * the Metadata extension. Built to optimize for lower gas during batch mints.
422  *
423  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
424  *
425  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
426  *
427  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
428  */
429 contract ERC721A is IERC721A {
430     // Mask of an entry in packed address data.
431     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
432 
433     // The bit position of `numberMinted` in packed address data.
434     uint256 private constant BITPOS_NUMBER_MINTED = 64;
435 
436     // The bit position of `numberBurned` in packed address data.
437     uint256 private constant BITPOS_NUMBER_BURNED = 128;
438 
439     // The bit position of `aux` in packed address data.
440     uint256 private constant BITPOS_AUX = 192;
441 
442     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
443     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
444 
445     // The bit position of `startTimestamp` in packed ownership.
446     uint256 private constant BITPOS_START_TIMESTAMP = 160;
447 
448     // The bit mask of the `burned` bit in packed ownership.
449     uint256 private constant BITMASK_BURNED = 1 << 224;
450     
451     // The bit position of the `nextInitialized` bit in packed ownership.
452     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
453 
454     // The bit mask of the `nextInitialized` bit in packed ownership.
455     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
456 
457     // The tokenId of the next token to be minted.
458     uint256 private _currentIndex;
459 
460     // The number of tokens burned.
461     uint256 private _burnCounter;
462 
463     // Token name
464     string private _name;
465 
466     // Token symbol
467     string private _symbol;
468 
469     // Mapping from token ID to ownership details
470     // An empty struct value does not necessarily mean the token is unowned.
471     // See `_packedOwnershipOf` implementation for details.
472     //
473     // Bits Layout:
474     // - [0..159]   `addr`
475     // - [160..223] `startTimestamp`
476     // - [224]      `burned`
477     // - [225]      `nextInitialized`
478     mapping(uint256 => uint256) private _packedOwnerships;
479 
480     // Mapping owner address to address data.
481     //
482     // Bits Layout:
483     // - [0..63]    `balance`
484     // - [64..127]  `numberMinted`
485     // - [128..191] `numberBurned`
486     // - [192..255] `aux`
487     mapping(address => uint256) private _packedAddressData;
488 
489     // Mapping from token ID to approved address.
490     mapping(uint256 => address) private _tokenApprovals;
491 
492     // Mapping from owner to operator approvals
493     mapping(address => mapping(address => bool)) private _operatorApprovals;
494 
495     constructor(string memory name_, string memory symbol_) {
496         _name = name_;
497         _symbol = symbol_;
498         _currentIndex = _startTokenId();
499     }
500 
501     /**
502      * @dev Returns the starting token ID. 
503      * To change the starting token ID, please override this function.
504      */
505     function _startTokenId() internal view virtual returns (uint256) {
506         return 0;
507     }
508 
509     /**
510      * @dev Returns the next token ID to be minted.
511      */
512     function _nextTokenId() internal view returns (uint256) {
513         return _currentIndex;
514     }
515 
516     /**
517      * @dev Returns the total number of tokens in existence.
518      * Burned tokens will reduce the count. 
519      * To get the total number of tokens minted, please see `_totalMinted`.
520      */
521     function totalSupply() public view override returns (uint256) {
522         // Counter underflow is impossible as _burnCounter cannot be incremented
523         // more than `_currentIndex - _startTokenId()` times.
524         unchecked {
525             return _currentIndex - _burnCounter - _startTokenId();
526         }
527     }
528 
529     /**
530      * @dev Returns the total amount of tokens minted in the contract.
531      */
532     function _totalMinted() internal view returns (uint256) {
533         // Counter underflow is impossible as _currentIndex does not decrement,
534         // and it is initialized to `_startTokenId()`
535         unchecked {
536             return _currentIndex - _startTokenId();
537         }
538     }
539 
540     /**
541      * @dev Returns the total number of tokens burned.
542      */
543     function _totalBurned() internal view returns (uint256) {
544         return _burnCounter;
545     }
546 
547     /**
548      * @dev See {IERC165-supportsInterface}.
549      */
550     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
551         // The interface IDs are constants representing the first 4 bytes of the XOR of
552         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
553         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
554         return
555             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
556             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
557             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
558     }
559 
560     /**
561      * @dev See {IERC721-balanceOf}.
562      */
563     function balanceOf(address owner) public view override returns (uint256) {
564         if (owner == address(0)) revert BalanceQueryForZeroAddress();
565         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
566     }
567 
568     /**
569      * Returns the number of tokens minted by `owner`.
570      */
571     function _numberMinted(address owner) internal view returns (uint256) {
572         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
573     }
574 
575     /**
576      * Returns the number of tokens burned by or on behalf of `owner`.
577      */
578     function _numberBurned(address owner) internal view returns (uint256) {
579         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
580     }
581 
582     /**
583      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
584      */
585     function _getAux(address owner) internal view returns (uint64) {
586         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
587     }
588 
589     /**
590      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
591      * If there are multiple variables, please pack them into a uint64.
592      */
593     function _setAux(address owner, uint64 aux) internal {
594         uint256 packed = _packedAddressData[owner];
595         uint256 auxCasted;
596         assembly { // Cast aux without masking.
597             auxCasted := aux
598         }
599         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
600         _packedAddressData[owner] = packed;
601     }
602 
603     /**
604      * Returns the packed ownership data of `tokenId`.
605      */
606     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
607         uint256 curr = tokenId;
608 
609         unchecked {
610             if (_startTokenId() <= curr)
611                 if (curr < _currentIndex) {
612                     uint256 packed = _packedOwnerships[curr];
613                     // If not burned.
614                     if (packed & BITMASK_BURNED == 0) {
615                         // Invariant:
616                         // There will always be an ownership that has an address and is not burned
617                         // before an ownership that does not have an address and is not burned.
618                         // Hence, curr will not underflow.
619                         //
620                         // We can directly compare the packed value.
621                         // If the address is zero, packed is zero.
622                         while (packed == 0) {
623                             packed = _packedOwnerships[--curr];
624                         }
625                         return packed;
626                     }
627                 }
628         }
629         revert OwnerQueryForNonexistentToken();
630     }
631 
632     /**
633      * Returns the unpacked `TokenOwnership` struct from `packed`.
634      */
635     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
636         ownership.addr = address(uint160(packed));
637         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
638         ownership.burned = packed & BITMASK_BURNED != 0;
639     }
640 
641     /**
642      * Returns the unpacked `TokenOwnership` struct at `index`.
643      */
644     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
645         return _unpackedOwnership(_packedOwnerships[index]);
646     }
647 
648     /**
649      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
650      */
651     function _initializeOwnershipAt(uint256 index) internal {
652         if (_packedOwnerships[index] == 0) {
653             _packedOwnerships[index] = _packedOwnershipOf(index);
654         }
655     }
656 
657     /**
658      * Gas spent here starts off proportional to the maximum mint batch size.
659      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
660      */
661     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
662         return _unpackedOwnership(_packedOwnershipOf(tokenId));
663     }
664 
665     /**
666      * @dev See {IERC721-ownerOf}.
667      */
668     function ownerOf(uint256 tokenId) public view override returns (address) {
669         return address(uint160(_packedOwnershipOf(tokenId)));
670     }
671 
672     /**
673      * @dev See {IERC721Metadata-name}.
674      */
675     function name() public view virtual override returns (string memory) {
676         return _name;
677     }
678 
679     /**
680      * @dev See {IERC721Metadata-symbol}.
681      */
682     function symbol() public view virtual override returns (string memory) {
683         return _symbol;
684     }
685 
686     /**
687      * @dev See {IERC721Metadata-tokenURI}.
688      */
689     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
690         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
691 
692         string memory baseURI = _baseURI();
693         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
694     }
695 
696     /**
697      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
698      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
699      * by default, can be overriden in child contracts.
700      */
701     function _baseURI() internal view virtual returns (string memory) {
702         return '';
703     }
704 
705     /**
706      * @dev Casts the address to uint256 without masking.
707      */
708     function _addressToUint256(address value) private pure returns (uint256 result) {
709         assembly {
710             result := value
711         }
712     }
713 
714     /**
715      * @dev Casts the boolean to uint256 without branching.
716      */
717     function _boolToUint256(bool value) private pure returns (uint256 result) {
718         assembly {
719             result := value
720         }
721     }
722 
723     /**
724      * @dev See {IERC721-approve}.
725      */
726     function approve(address to, uint256 tokenId) public override {
727         address owner = address(uint160(_packedOwnershipOf(tokenId)));
728         if (to == owner) revert ApprovalToCurrentOwner();
729 
730         if (_msgSenderERC721A() != owner)
731             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
732                 revert ApprovalCallerNotOwnerNorApproved();
733             }
734 
735         _tokenApprovals[tokenId] = to;
736         emit Approval(owner, to, tokenId);
737     }
738 
739     /**
740      * @dev See {IERC721-getApproved}.
741      */
742     function getApproved(uint256 tokenId) public view override returns (address) {
743         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
744 
745         return _tokenApprovals[tokenId];
746     }
747 
748     /**
749      * @dev See {IERC721-setApprovalForAll}.
750      */
751     function setApprovalForAll(address operator, bool approved) public virtual override {
752         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
753 
754         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
755         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
756     }
757 
758     /**
759      * @dev See {IERC721-isApprovedForAll}.
760      */
761     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
762         return _operatorApprovals[owner][operator];
763     }
764 
765     /**
766      * @dev See {IERC721-transferFrom}.
767      */
768     function transferFrom(
769         address from,
770         address to,
771         uint256 tokenId
772     ) public virtual override {
773         _transfer(from, to, tokenId);
774     }
775 
776     /**
777      * @dev See {IERC721-safeTransferFrom}.
778      */
779     function safeTransferFrom(
780         address from,
781         address to,
782         uint256 tokenId
783     ) public virtual override {
784         safeTransferFrom(from, to, tokenId, '');
785     }
786 
787     /**
788      * @dev See {IERC721-safeTransferFrom}.
789      */
790     function safeTransferFrom(
791         address from,
792         address to,
793         uint256 tokenId,
794         bytes memory _data
795     ) public virtual override {
796         _transfer(from, to, tokenId);
797         if (to.code.length != 0)
798             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
799                 revert TransferToNonERC721ReceiverImplementer();
800             }
801     }
802 
803     /**
804      * @dev Returns whether `tokenId` exists.
805      *
806      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
807      *
808      * Tokens start existing when they are minted (`_mint`),
809      */
810     function _exists(uint256 tokenId) internal view returns (bool) {
811         return
812             _startTokenId() <= tokenId &&
813             tokenId < _currentIndex && // If within bounds,
814             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
815     }
816 
817     /**
818      * @dev Equivalent to `_safeMint(to, quantity, '')`.
819      */
820     function _safeMint(address to, uint256 quantity) internal {
821         _safeMint(to, quantity, '');
822     }
823 
824     /**
825      * @dev Safely mints `quantity` tokens and transfers them to `to`.
826      *
827      * Requirements:
828      *
829      * - If `to` refers to a smart contract, it must implement
830      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
831      * - `quantity` must be greater than 0.
832      *
833      * Emits a {Transfer} event.
834      */
835     function _safeMint(
836         address to,
837         uint256 quantity,
838         bytes memory _data
839     ) internal {
840         uint256 startTokenId = _currentIndex;
841         if (to == address(0)) revert MintToZeroAddress();
842         if (quantity == 0) revert MintZeroQuantity();
843 
844         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
845 
846         // Overflows are incredibly unrealistic.
847         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
848         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
849         unchecked {
850             // Updates:
851             // - `balance += quantity`.
852             // - `numberMinted += quantity`.
853             //
854             // We can directly add to the balance and number minted.
855             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
856 
857             // Updates:
858             // - `address` to the owner.
859             // - `startTimestamp` to the timestamp of minting.
860             // - `burned` to `false`.
861             // - `nextInitialized` to `quantity == 1`.
862             _packedOwnerships[startTokenId] =
863                 _addressToUint256(to) |
864                 (block.timestamp << BITPOS_START_TIMESTAMP) |
865                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
866 
867             uint256 updatedIndex = startTokenId;
868             uint256 end = updatedIndex + quantity;
869 
870             if (to.code.length != 0) {
871                 do {
872                     emit Transfer(address(0), to, updatedIndex);
873                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
874                         revert TransferToNonERC721ReceiverImplementer();
875                     }
876                 } while (updatedIndex < end);
877                 // Reentrancy protection
878                 if (_currentIndex != startTokenId) revert();
879             } else {
880                 do {
881                     emit Transfer(address(0), to, updatedIndex++);
882                 } while (updatedIndex < end);
883             }
884             _currentIndex = updatedIndex;
885         }
886         _afterTokenTransfers(address(0), to, startTokenId, quantity);
887     }
888 
889     /**
890      * @dev Mints `quantity` tokens and transfers them to `to`.
891      *
892      * Requirements:
893      *
894      * - `to` cannot be the zero address.
895      * - `quantity` must be greater than 0.
896      *
897      * Emits a {Transfer} event.
898      */
899     function _mint(address to, uint256 quantity) internal {
900         uint256 startTokenId = _currentIndex;
901         if (to == address(0)) revert MintToZeroAddress();
902         if (quantity == 0) revert MintZeroQuantity();
903 
904         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
905 
906         // Overflows are incredibly unrealistic.
907         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
908         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
909         unchecked {
910             // Updates:
911             // - `balance += quantity`.
912             // - `numberMinted += quantity`.
913             //
914             // We can directly add to the balance and number minted.
915             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
916 
917             // Updates:
918             // - `address` to the owner.
919             // - `startTimestamp` to the timestamp of minting.
920             // - `burned` to `false`.
921             // - `nextInitialized` to `quantity == 1`.
922             _packedOwnerships[startTokenId] =
923                 _addressToUint256(to) |
924                 (block.timestamp << BITPOS_START_TIMESTAMP) |
925                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
926 
927             uint256 updatedIndex = startTokenId;
928             uint256 end = updatedIndex + quantity;
929 
930             do {
931                 emit Transfer(address(0), to, updatedIndex++);
932             } while (updatedIndex < end);
933 
934             _currentIndex = updatedIndex;
935         }
936         _afterTokenTransfers(address(0), to, startTokenId, quantity);
937     }
938 
939     /**
940      * @dev Transfers `tokenId` from `from` to `to`.
941      *
942      * Requirements:
943      *
944      * - `to` cannot be the zero address.
945      * - `tokenId` token must be owned by `from`.
946      *
947      * Emits a {Transfer} event.
948      */
949     function _transfer(
950         address from,
951         address to,
952         uint256 tokenId
953     ) private {
954         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
955 
956         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
957 
958         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
959             isApprovedForAll(from, _msgSenderERC721A()) ||
960             getApproved(tokenId) == _msgSenderERC721A());
961 
962         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
963         if (to == address(0)) revert TransferToZeroAddress();
964 
965         _beforeTokenTransfers(from, to, tokenId, 1);
966 
967         // Clear approvals from the previous owner.
968         delete _tokenApprovals[tokenId];
969 
970         // Underflow of the sender's balance is impossible because we check for
971         // ownership above and the recipient's balance can't realistically overflow.
972         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
973         unchecked {
974             // We can directly increment and decrement the balances.
975             --_packedAddressData[from]; // Updates: `balance -= 1`.
976             ++_packedAddressData[to]; // Updates: `balance += 1`.
977 
978             // Updates:
979             // - `address` to the next owner.
980             // - `startTimestamp` to the timestamp of transfering.
981             // - `burned` to `false`.
982             // - `nextInitialized` to `true`.
983             _packedOwnerships[tokenId] =
984                 _addressToUint256(to) |
985                 (block.timestamp << BITPOS_START_TIMESTAMP) |
986                 BITMASK_NEXT_INITIALIZED;
987 
988             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
989             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
990                 uint256 nextTokenId = tokenId + 1;
991                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
992                 if (_packedOwnerships[nextTokenId] == 0) {
993                     // If the next slot is within bounds.
994                     if (nextTokenId != _currentIndex) {
995                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
996                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
997                     }
998                 }
999             }
1000         }
1001 
1002         emit Transfer(from, to, tokenId);
1003         _afterTokenTransfers(from, to, tokenId, 1);
1004     }
1005 
1006     /**
1007      * @dev Equivalent to `_burn(tokenId, false)`.
1008      */
1009     function _burn(uint256 tokenId) internal virtual {
1010         _burn(tokenId, false);
1011     }
1012 
1013     /**
1014      * @dev Destroys `tokenId`.
1015      * The approval is cleared when the token is burned.
1016      *
1017      * Requirements:
1018      *
1019      * - `tokenId` must exist.
1020      *
1021      * Emits a {Transfer} event.
1022      */
1023     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1024         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1025 
1026         address from = address(uint160(prevOwnershipPacked));
1027 
1028         if (approvalCheck) {
1029             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1030                 isApprovedForAll(from, _msgSenderERC721A()) ||
1031                 getApproved(tokenId) == _msgSenderERC721A());
1032 
1033             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1034         }
1035 
1036         _beforeTokenTransfers(from, address(0), tokenId, 1);
1037 
1038         // Clear approvals from the previous owner.
1039         delete _tokenApprovals[tokenId];
1040 
1041         // Underflow of the sender's balance is impossible because we check for
1042         // ownership above and the recipient's balance can't realistically overflow.
1043         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1044         unchecked {
1045             // Updates:
1046             // - `balance -= 1`.
1047             // - `numberBurned += 1`.
1048             //
1049             // We can directly decrement the balance, and increment the number burned.
1050             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1051             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1052 
1053             // Updates:
1054             // - `address` to the last owner.
1055             // - `startTimestamp` to the timestamp of burning.
1056             // - `burned` to `true`.
1057             // - `nextInitialized` to `true`.
1058             _packedOwnerships[tokenId] =
1059                 _addressToUint256(from) |
1060                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1061                 BITMASK_BURNED | 
1062                 BITMASK_NEXT_INITIALIZED;
1063 
1064             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1065             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1066                 uint256 nextTokenId = tokenId + 1;
1067                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1068                 if (_packedOwnerships[nextTokenId] == 0) {
1069                     // If the next slot is within bounds.
1070                     if (nextTokenId != _currentIndex) {
1071                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1072                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1073                     }
1074                 }
1075             }
1076         }
1077 
1078         emit Transfer(from, address(0), tokenId);
1079         _afterTokenTransfers(from, address(0), tokenId, 1);
1080 
1081         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1082         unchecked {
1083             _burnCounter++;
1084         }
1085     }
1086 
1087     /**
1088      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1089      *
1090      * @param from address representing the previous owner of the given token ID
1091      * @param to target address that will receive the tokens
1092      * @param tokenId uint256 ID of the token to be transferred
1093      * @param _data bytes optional data to send along with the call
1094      * @return bool whether the call correctly returned the expected magic value
1095      */
1096     function _checkContractOnERC721Received(
1097         address from,
1098         address to,
1099         uint256 tokenId,
1100         bytes memory _data
1101     ) private returns (bool) {
1102         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1103             bytes4 retval
1104         ) {
1105             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1106         } catch (bytes memory reason) {
1107             if (reason.length == 0) {
1108                 revert TransferToNonERC721ReceiverImplementer();
1109             } else {
1110                 assembly {
1111                     revert(add(32, reason), mload(reason))
1112                 }
1113             }
1114         }
1115     }
1116 
1117     /**
1118      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1119      * And also called before burning one token.
1120      *
1121      * startTokenId - the first token id to be transferred
1122      * quantity - the amount to be transferred
1123      *
1124      * Calling conditions:
1125      *
1126      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1127      * transferred to `to`.
1128      * - When `from` is zero, `tokenId` will be minted for `to`.
1129      * - When `to` is zero, `tokenId` will be burned by `from`.
1130      * - `from` and `to` are never both zero.
1131      */
1132     function _beforeTokenTransfers(
1133         address from,
1134         address to,
1135         uint256 startTokenId,
1136         uint256 quantity
1137     ) internal virtual {}
1138 
1139     /**
1140      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1141      * minting.
1142      * And also called after one token has been burned.
1143      *
1144      * startTokenId - the first token id to be transferred
1145      * quantity - the amount to be transferred
1146      *
1147      * Calling conditions:
1148      *
1149      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1150      * transferred to `to`.
1151      * - When `from` is zero, `tokenId` has been minted for `to`.
1152      * - When `to` is zero, `tokenId` has been burned by `from`.
1153      * - `from` and `to` are never both zero.
1154      */
1155     function _afterTokenTransfers(
1156         address from,
1157         address to,
1158         uint256 startTokenId,
1159         uint256 quantity
1160     ) internal virtual {}
1161 
1162     /**
1163      * @dev Returns the message sender (defaults to `msg.sender`).
1164      *
1165      * If you are writing GSN compatible contracts, you need to override this function.
1166      */
1167     function _msgSenderERC721A() internal view virtual returns (address) {
1168         return msg.sender;
1169     }
1170 
1171     /**
1172      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1173      */
1174     function _toString(uint256 value) internal pure returns (string memory ptr) {
1175         assembly {
1176             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1177             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1178             // We will need 1 32-byte word to store the length, 
1179             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1180             ptr := add(mload(0x40), 128)
1181             // Update the free memory pointer to allocate.
1182             mstore(0x40, ptr)
1183 
1184             // Cache the end of the memory to calculate the length later.
1185             let end := ptr
1186 
1187             // We write the string from the rightmost digit to the leftmost digit.
1188             // The following is essentially a do-while loop that also handles the zero case.
1189             // Costs a bit more than early returning for the zero case,
1190             // but cheaper in terms of deployment and overall runtime costs.
1191             for { 
1192                 // Initialize and perform the first pass without check.
1193                 let temp := value
1194                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1195                 ptr := sub(ptr, 1)
1196                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1197                 mstore8(ptr, add(48, mod(temp, 10)))
1198                 temp := div(temp, 10)
1199             } temp { 
1200                 // Keep dividing `temp` until zero.
1201                 temp := div(temp, 10)
1202             } { // Body of the for loop.
1203                 ptr := sub(ptr, 1)
1204                 mstore8(ptr, add(48, mod(temp, 10)))
1205             }
1206             
1207             let length := sub(end, ptr)
1208             // Move the pointer 32 bytes leftwards to make room for the length.
1209             ptr := sub(ptr, 32)
1210             // Store the length.
1211             mstore(ptr, length)
1212         }
1213     }
1214 }
1215 
1216 // File: nft.sol
1217 
1218 
1219 
1220 pragma solidity ^0.8.13;
1221 
1222 
1223 
1224 contract Unhealthy is Ownable, ERC721A {
1225     uint256 public maxSupply                    = 1363;
1226     uint256 public maxFreeSupply                = 363;
1227     
1228     uint256 public maxPerTxDuringMint           = 1;
1229     uint256 public maxPerAddressDuringMint      = 20;
1230     uint256 public maxPerAddressDuringFreeMint  = 2;
1231     
1232     uint256 public price                        = 0.009 ether;
1233     bool    public saleIsActive                 = false;
1234 
1235     address constant internal TEAM_ADDRESS = 0x13909c0217cFA30453A05825067f61B4964EF8e8;
1236 
1237     string private _baseTokenURI;
1238 
1239     mapping(address => uint256) public freeMintedAmount;
1240     mapping(address => uint256) public mintedAmount;
1241 
1242     constructor() ERC721A("NEON 363 CLUB", "NE") {
1243         _safeMint(msg.sender, 63);
1244     }
1245 
1246     modifier mintCompliance() {
1247         require(saleIsActive, "Sale is not active yet.");
1248         require(tx.origin == msg.sender, "Caller cannot be a contract.");
1249         _;
1250     }
1251 
1252     function mint(uint256 _quantity) external payable mintCompliance() {
1253         require(
1254             msg.value >= price * _quantity,
1255             "Insufficient Fund."
1256         );
1257         require(
1258             maxSupply >= totalSupply() + _quantity,
1259             "Exceeds max supply."
1260         );
1261         uint256 _mintedAmount = mintedAmount[msg.sender];
1262         require(
1263             _mintedAmount + _quantity <= maxPerAddressDuringMint,
1264             "Exceeds max mints per address!"
1265         );
1266         require(
1267             _quantity > 0 && _quantity <= maxPerTxDuringMint,
1268             "Invalid mint amount."
1269         );
1270         mintedAmount[msg.sender] = _mintedAmount + _quantity;
1271         _safeMint(msg.sender, _quantity);
1272     }
1273 
1274     function freeMint(uint256 _quantity) external mintCompliance() {
1275         require(
1276             maxFreeSupply >= totalSupply() + _quantity,
1277             "Exceeds max free supply."
1278         );
1279         uint256 _freeMintedAmount = freeMintedAmount[msg.sender];
1280         require(
1281             _freeMintedAmount + _quantity <= maxPerAddressDuringFreeMint,
1282             "Exceeds max free mints per address!"
1283         );
1284         freeMintedAmount[msg.sender] = _freeMintedAmount + _quantity;
1285         _safeMint(msg.sender, _quantity);
1286     }
1287 
1288     function setPrice(uint256 _price) external onlyOwner {
1289         price = _price;
1290     }
1291 
1292     function setMaxPerTx(uint256 _amount) external onlyOwner {
1293         maxPerTxDuringMint = _amount;
1294     }
1295 
1296     function setMaxPerAddress(uint256 _amount) external onlyOwner {
1297         maxPerAddressDuringMint = _amount;
1298     }
1299 
1300     function setMaxFreePerAddress(uint256 _amount) external onlyOwner {
1301         maxPerAddressDuringFreeMint = _amount;
1302     }
1303 
1304     function flipSale() public onlyOwner {
1305         saleIsActive = !saleIsActive;
1306     }
1307 
1308     function cutMaxSupply(uint256 _amount) public onlyOwner {
1309         require(
1310             maxSupply - _amount >= totalSupply(), 
1311             "Supply cannot fall below minted tokens."
1312         );
1313         maxSupply -= _amount;
1314     }
1315 
1316     function setBaseURI(string calldata baseURI) external onlyOwner {
1317         _baseTokenURI = baseURI;
1318     }
1319 
1320     function _baseURI() internal view virtual override returns (string memory) {
1321         return _baseTokenURI;
1322     }
1323 
1324     function withdrawtool() external payable onlyOwner {
1325 
1326         (bool success, ) = payable(TEAM_ADDRESS).call{
1327             value: address(this).balance
1328         }("");
1329         require(success, "transfer failed.");
1330     }
1331 }