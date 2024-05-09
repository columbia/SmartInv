1 /**
2  *Submitted for verification at Etherscan.io on
3 */
4 // SPDX-License-Identifier: MIT
5 // File: @openzeppelin/contracts/utils/Context.sol
6 
7 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
8 
9 pragma solidity ^0.8.0;
10 
11 /**
12  * @dev Provides information about the current execution context, including the
13  * sender of the transaction and its data. While these are generally available
14  * via msg.sender and msg.data, they should not be accessed in such a direct
15  * manner, since when dealing with meta-transactions the account sending and
16  * paying for execution may not be the actual sender (as far as an application
17  * is concerned).
18  *
19  * This contract is only required for intermediate, library-like contracts.
20  */
21 abstract contract Context {
22     function _msgSender() internal view virtual returns (address) {
23         return msg.sender;
24     }
25 
26     function _msgData() internal view virtual returns (bytes calldata) {
27         return msg.data;
28     }
29 }
30 
31 // File: @openzeppelin/contracts/access/Ownable.sol
32 
33 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
34 
35 pragma solidity ^0.8.0;
36 
37 /**
38  * @dev Contract module which provides a basic access control mechanism, where
39  * there is an account (an owner) that can be granted exclusive access to
40  * specific functions.
41  *
42  * By default, the owner account will be the one that deploys the contract. This
43  * can later be changed with {transferOwnership}.
44  *
45  * This module is used through inheritance. It will make available the modifier
46  * `onlyOwner`, which can be applied to your functions to restrict their use to
47  * the owner.
48  */
49 abstract contract Ownable is Context {
50     address private _owner;
51 
52     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
53 
54     /**
55      * @dev Initializes the contract setting the deployer as the initial owner.
56      */
57     constructor() {
58         _transferOwnership(_msgSender());
59     }
60 
61     /**
62      * @dev Returns the address of the current owner.
63      */
64     function owner() public view virtual returns (address) {
65         return _owner;
66     }
67 
68     /**
69      * @dev Throws if called by any account other than the owner.
70      */
71     modifier onlyOwner() {
72         require(owner() == _msgSender(), "Ownable: caller is not the owner");
73         _;
74     }
75 
76     /**
77      * @dev Leaves the contract without owner. It will not be possible to call
78      * `onlyOwner` functions anymore. Can only be called by the current owner.
79      *
80      * NOTE: Renouncing ownership will leave the contract without an owner,
81      * thereby removing any functionality that is only available to the owner.
82      */
83     function renounceOwnership() public virtual onlyOwner {
84         _transferOwnership(address(0));
85     }
86 
87     /**
88      * @dev Transfers ownership of the contract to a new account (`newOwner`).
89      * Can only be called by the current owner.
90      */
91     function transferOwnership(address newOwner) public virtual onlyOwner {
92         require(newOwner != address(0), "Ownable: new owner is the zero address");
93         _transferOwnership(newOwner);
94     }
95 
96     /**
97      * @dev Transfers ownership of the contract to a new account (`newOwner`).
98      * Internal function without access restriction.
99      */
100     function _transferOwnership(address newOwner) internal virtual {
101         address oldOwner = _owner;
102         _owner = newOwner;
103         emit OwnershipTransferred(oldOwner, newOwner);
104     }
105 }
106 
107 // File: erc721a/contracts/IERC721A.sol
108 
109 // ERC721A Contracts v4.0.0
110 // Creator: Chiru Labs
111 
112 pragma solidity ^0.8.4;
113 
114 /**
115  * @dev Interface of an ERC721A compliant contract.
116  */
117 interface IERC721A {
118     /**
119      * The caller must own the token or be an approved operator.
120      */
121     error ApprovalCallerNotOwnerNorApproved();
122 
123     /**
124      * The token does not exist.
125      */
126     error ApprovalQueryForNonexistentToken();
127 
128     /**
129      * The caller cannot approve to their own address.
130      */
131     error ApproveToCaller();
132 
133     /**
134      * The caller cannot approve to the current owner.
135      */
136     error ApprovalToCurrentOwner();
137 
138     /**
139      * Cannot query the balance for the zero address.
140      */
141     error BalanceQueryForZeroAddress();
142 
143     /**
144      * Cannot mint to the zero address.
145      */
146     error MintToZeroAddress();
147 
148     /**
149      * The quantity of tokens minted must be more than zero.
150      */
151     error MintZeroQuantity();
152 
153     /**
154      * The token does not exist.
155      */
156     error OwnerQueryForNonexistentToken();
157 
158     /**
159      * The caller must own the token or be an approved operator.
160      */
161     error TransferCallerNotOwnerNorApproved();
162 
163     /**
164      * The token must be owned by `from`.
165      */
166     error TransferFromIncorrectOwner();
167 
168     /**
169      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
170      */
171     error TransferToNonERC721ReceiverImplementer();
172 
173     /**
174      * Cannot transfer to the zero address.
175      */
176     error TransferToZeroAddress();
177 
178     /**
179      * The token does not exist.
180      */
181     error URIQueryForNonexistentToken();
182 
183     struct TokenOwnership {
184         // The address of the owner.
185         address addr;
186         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
187         uint64 startTimestamp;
188         // Whether the token has been burned.
189         bool burned;
190     }
191 
192     /**
193      * @dev Returns the total amount of tokens stored by the contract.
194      *
195      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
196      */
197     function totalSupply() external view returns (uint256);
198 
199     // ==============================
200     //            IERC165
201     // ==============================
202 
203     /**
204      * @dev Returns true if this contract implements the interface defined by
205      * `interfaceId`. See the corresponding
206      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
207      * to learn more about how these ids are created.
208      *
209      * This function call must use less than 30 000 gas.
210      */
211     function supportsInterface(bytes4 interfaceId) external view returns (bool);
212 
213     // ==============================
214     //            IERC721
215     // ==============================
216 
217     /**
218      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
219      */
220     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
221 
222     /**
223      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
224      */
225     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
226 
227     /**
228      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
229      */
230     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
231 
232     /**
233      * @dev Returns the number of tokens in ``owner``'s account.
234      */
235     function balanceOf(address owner) external view returns (uint256 balance);
236 
237     /**
238      * @dev Returns the owner of the `tokenId` token.
239      *
240      * Requirements:
241      *
242      * - `tokenId` must exist.
243      */
244     function ownerOf(uint256 tokenId) external view returns (address owner);
245 
246     /**
247      * @dev Safely transfers `tokenId` token from `from` to `to`.
248      *
249      * Requirements:
250      *
251      * - `from` cannot be the zero address.
252      * - `to` cannot be the zero address.
253      * - `tokenId` token must exist and be owned by `from`.
254      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
255      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
256      *
257      * Emits a {Transfer} event.
258      */
259     function safeTransferFrom(
260         address from,
261         address to,
262         uint256 tokenId,
263         bytes calldata data
264     ) external;
265 
266     /**
267      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
268      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
269      *
270      * Requirements:
271      *
272      * - `from` cannot be the zero address.
273      * - `to` cannot be the zero address.
274      * - `tokenId` token must exist and be owned by `from`.
275      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
276      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
277      *
278      * Emits a {Transfer} event.
279      */
280     function safeTransferFrom(
281         address from,
282         address to,
283         uint256 tokenId
284     ) external;
285 
286     /**
287      * @dev Transfers `tokenId` token from `from` to `to`.
288      *
289      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
290      *
291      * Requirements:
292      *
293      * - `from` cannot be the zero address.
294      * - `to` cannot be the zero address.
295      * - `tokenId` token must be owned by `from`.
296      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
297      *
298      * Emits a {Transfer} event.
299      */
300     function transferFrom(
301         address from,
302         address to,
303         uint256 tokenId
304     ) external;
305 
306     /**
307      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
308      * The approval is cleared when the token is transferred.
309      *
310      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
311      *
312      * Requirements:
313      *
314      * - The caller must own the token or be an approved operator.
315      * - `tokenId` must exist.
316      *
317      * Emits an {Approval} event.
318      */
319     function approve(address to, uint256 tokenId) external;
320 
321     /**
322      * @dev Approve or remove `operator` as an operator for the caller.
323      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
324      *
325      * Requirements:
326      *
327      * - The `operator` cannot be the caller.
328      *
329      * Emits an {ApprovalForAll} event.
330      */
331     function setApprovalForAll(address operator, bool _approved) external;
332 
333     /**
334      * @dev Returns the account approved for `tokenId` token.
335      *
336      * Requirements:
337      *
338      * - `tokenId` must exist.
339      */
340     function getApproved(uint256 tokenId) external view returns (address operator);
341 
342     /**
343      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
344      *
345      * See {setApprovalForAll}
346      */
347     function isApprovedForAll(address owner, address operator) external view returns (bool);
348 
349     // ==============================
350     //        IERC721Metadata
351     // ==============================
352 
353     /**
354      * @dev Returns the token collection name.
355      */
356     function name() external view returns (string memory);
357 
358     /**
359      * @dev Returns the token collection symbol.
360      */
361     function symbol() external view returns (string memory);
362 
363     /**
364      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
365      */
366     function tokenURI(uint256 tokenId) external view returns (string memory);
367 }
368 
369 // File: erc721a/contracts/ERC721A.sol
370 
371 // ERC721A Contracts v4.0.0
372 // Creator: Chiru Labs
373 
374 pragma solidity ^0.8.4;
375 
376 /**
377  * @dev ERC721 token receiver interface.
378  */
379 interface ERC721A__IERC721Receiver {
380     function onERC721Received(
381         address operator,
382         address from,
383         uint256 tokenId,
384         bytes calldata data
385     ) external returns (bytes4);
386 }
387 
388 /**
389  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
390  * the Metadata extension. Built to optimize for lower gas during batch mints.
391  *
392  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
393  *
394  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
395  *
396  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
397  */
398 contract ERC721A is IERC721A {
399     // Mask of an entry in packed address data.
400     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
401 
402     // The bit position of `numberMinted` in packed address data.
403     uint256 private constant BITPOS_NUMBER_MINTED = 64;
404 
405     // The bit position of `numberBurned` in packed address data.
406     uint256 private constant BITPOS_NUMBER_BURNED = 128;
407 
408     // The bit position of `aux` in packed address data.
409     uint256 private constant BITPOS_AUX = 192;
410 
411     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
412     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
413 
414     // The bit position of `startTimestamp` in packed ownership.
415     uint256 private constant BITPOS_START_TIMESTAMP = 160;
416 
417     // The bit mask of the `burned` bit in packed ownership.
418     uint256 private constant BITMASK_BURNED = 1 << 224;
419     
420     // The bit position of the `nextInitialized` bit in packed ownership.
421     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
422 
423     // The bit mask of the `nextInitialized` bit in packed ownership.
424     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
425 
426     // The tokenId of the next token to be minted.
427     uint256 private _currentIndex;
428 
429     // The number of tokens burned.
430     uint256 private _burnCounter;
431 
432     // Token name
433     string private _name;
434 
435     // Token symbol
436     string private _symbol;
437 
438     // Mapping from token ID to ownership details
439     // An empty struct value does not necessarily mean the token is unowned.
440     // See `_packedOwnershipOf` implementation for details.
441     //
442     // Bits Layout:
443     // - [0..159]   `addr`
444     // - [160..223] `startTimestamp`
445     // - [224]      `burned`
446     // - [225]      `nextInitialized`
447     mapping(uint256 => uint256) private _packedOwnerships;
448 
449     // Mapping owner address to address data.
450     //
451     // Bits Layout:
452     // - [0..63]    `balance`
453     // - [64..127]  `numberMinted`
454     // - [128..191] `numberBurned`
455     // - [192..255] `aux`
456     mapping(address => uint256) private _packedAddressData;
457 
458     // Mapping from token ID to approved address.
459     mapping(uint256 => address) private _tokenApprovals;
460 
461     // Mapping from owner to operator approvals
462     mapping(address => mapping(address => bool)) private _operatorApprovals;
463 
464     constructor(string memory name_, string memory symbol_) {
465         _name = name_;
466         _symbol = symbol_;
467         _currentIndex = _startTokenId();
468     }
469 
470     /**
471      * @dev Returns the starting token ID. 
472      * To change the starting token ID, please override this function.
473      */
474     function _startTokenId() internal view virtual returns (uint256) {
475         return 0;
476     }
477 
478     /**
479      * @dev Returns the next token ID to be minted.
480      */
481     function _nextTokenId() internal view returns (uint256) {
482         return _currentIndex;
483     }
484 
485     /**
486      * @dev Returns the total number of tokens in existence.
487      * Burned tokens will reduce the count. 
488      * To get the total number of tokens minted, please see `_totalMinted`.
489      */
490     function totalSupply() public view override returns (uint256) {
491         // Counter underflow is impossible as _burnCounter cannot be incremented
492         // more than `_currentIndex - _startTokenId()` times.
493         unchecked {
494             return _currentIndex - _burnCounter - _startTokenId();
495         }
496     }
497 
498     /**
499      * @dev Returns the total amount of tokens minted in the contract.
500      */
501     function _totalMinted() internal view returns (uint256) {
502         // Counter underflow is impossible as _currentIndex does not decrement,
503         // and it is initialized to `_startTokenId()`
504         unchecked {
505             return _currentIndex - _startTokenId();
506         }
507     }
508 
509     /**
510      * @dev Returns the total number of tokens burned.
511      */
512     function _totalBurned() internal view returns (uint256) {
513         return _burnCounter;
514     }
515 
516     /**
517      * @dev See {IERC165-supportsInterface}.
518      */
519     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
520         // The interface IDs are constants representing the first 4 bytes of the XOR of
521         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
522         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
523         return
524             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
525             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
526             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
527     }
528 
529     /**
530      * @dev See {IERC721-balanceOf}.
531      */
532     function balanceOf(address owner) public view override returns (uint256) {
533         if (owner == address(0)) revert BalanceQueryForZeroAddress();
534         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
535     }
536 
537     /**
538      * Returns the number of tokens minted by `owner`.
539      */
540     function _numberMinted(address owner) internal view returns (uint256) {
541         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
542     }
543 
544     /**
545      * Returns the number of tokens burned by or on behalf of `owner`.
546      */
547     function _numberBurned(address owner) internal view returns (uint256) {
548         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
549     }
550 
551     /**
552      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
553      */
554     function _getAux(address owner) internal view returns (uint64) {
555         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
556     }
557 
558     /**
559      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
560      * If there are multiple variables, please pack them into a uint64.
561      */
562     function _setAux(address owner, uint64 aux) internal {
563         uint256 packed = _packedAddressData[owner];
564         uint256 auxCasted;
565         assembly { // Cast aux without masking.
566             auxCasted := aux
567         }
568         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
569         _packedAddressData[owner] = packed;
570     }
571 
572     /**
573      * Returns the packed ownership data of `tokenId`.
574      */
575     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
576         uint256 curr = tokenId;
577 
578         unchecked {
579             if (_startTokenId() <= curr)
580                 if (curr < _currentIndex) {
581                     uint256 packed = _packedOwnerships[curr];
582                     // If not burned.
583                     if (packed & BITMASK_BURNED == 0) {
584                         // Invariant:
585                         // There will always be an ownership that has an address and is not burned
586                         // before an ownership that does not have an address and is not burned.
587                         // Hence, curr will not underflow.
588                         //
589                         // We can directly compare the packed value.
590                         // If the address is zero, packed is zero.
591                         while (packed == 0) {
592                             packed = _packedOwnerships[--curr];
593                         }
594                         return packed;
595                     }
596                 }
597         }
598         revert OwnerQueryForNonexistentToken();
599     }
600 
601     /**
602      * Returns the unpacked `TokenOwnership` struct from `packed`.
603      */
604     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
605         ownership.addr = address(uint160(packed));
606         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
607         ownership.burned = packed & BITMASK_BURNED != 0;
608     }
609 
610     /**
611      * Returns the unpacked `TokenOwnership` struct at `index`.
612      */
613     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
614         return _unpackedOwnership(_packedOwnerships[index]);
615     }
616 
617     /**
618      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
619      */
620     function _initializeOwnershipAt(uint256 index) internal {
621         if (_packedOwnerships[index] == 0) {
622             _packedOwnerships[index] = _packedOwnershipOf(index);
623         }
624     }
625 
626     /**
627      * Gas spent here starts off proportional to the maximum mint batch size.
628      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
629      */
630     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
631         return _unpackedOwnership(_packedOwnershipOf(tokenId));
632     }
633 
634     /**
635      * @dev See {IERC721-ownerOf}.
636      */
637     function ownerOf(uint256 tokenId) public view override returns (address) {
638         return address(uint160(_packedOwnershipOf(tokenId)));
639     }
640 
641     /**
642      * @dev See {IERC721Metadata-name}.
643      */
644     function name() public view virtual override returns (string memory) {
645         return _name;
646     }
647 
648     /**
649      * @dev See {IERC721Metadata-symbol}.
650      */
651     function symbol() public view virtual override returns (string memory) {
652         return _symbol;
653     }
654 
655     /**
656      * @dev See {IERC721Metadata-tokenURI}.
657      */
658     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
659         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
660 
661         string memory baseURI = _baseURI();
662         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
663     }
664 
665     /**
666      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
667      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
668      * by default, can be overriden in child contracts.
669      */
670     function _baseURI() internal view virtual returns (string memory) {
671         return '';
672     }
673 
674     /**
675      * @dev Casts the address to uint256 without masking.
676      */
677     function _addressToUint256(address value) private pure returns (uint256 result) {
678         assembly {
679             result := value
680         }
681     }
682 
683     /**
684      * @dev Casts the boolean to uint256 without branching.
685      */
686     function _boolToUint256(bool value) private pure returns (uint256 result) {
687         assembly {
688             result := value
689         }
690     }
691 
692     /**
693      * @dev See {IERC721-approve}.
694      */
695     function approve(address to, uint256 tokenId) public override {
696         address owner = address(uint160(_packedOwnershipOf(tokenId)));
697         if (to == owner) revert ApprovalToCurrentOwner();
698 
699         if (_msgSenderERC721A() != owner)
700             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
701                 revert ApprovalCallerNotOwnerNorApproved();
702             }
703 
704         _tokenApprovals[tokenId] = to;
705         emit Approval(owner, to, tokenId);
706     }
707 
708     /**
709      * @dev See {IERC721-getApproved}.
710      */
711     function getApproved(uint256 tokenId) public view override returns (address) {
712         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
713 
714         return _tokenApprovals[tokenId];
715     }
716 
717     /**
718      * @dev See {IERC721-setApprovalForAll}.
719      */
720     function setApprovalForAll(address operator, bool approved) public virtual override {
721         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
722 
723         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
724         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
725     }
726 
727     /**
728      * @dev See {IERC721-isApprovedForAll}.
729      */
730     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
731         return _operatorApprovals[owner][operator];
732     }
733 
734     /**
735      * @dev See {IERC721-transferFrom}.
736      */
737     function transferFrom(
738         address from,
739         address to,
740         uint256 tokenId
741     ) public virtual override {
742         _transfer(from, to, tokenId);
743     }
744 
745     /**
746      * @dev See {IERC721-safeTransferFrom}.
747      */
748     function safeTransferFrom(
749         address from,
750         address to,
751         uint256 tokenId
752     ) public virtual override {
753         safeTransferFrom(from, to, tokenId, '');
754     }
755 
756     /**
757      * @dev See {IERC721-safeTransferFrom}.
758      */
759     function safeTransferFrom(
760         address from,
761         address to,
762         uint256 tokenId,
763         bytes memory _data
764     ) public virtual override {
765         _transfer(from, to, tokenId);
766         if (to.code.length != 0)
767             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
768                 revert TransferToNonERC721ReceiverImplementer();
769             }
770     }
771 
772     /**
773      * @dev Returns whether `tokenId` exists.
774      *
775      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
776      *
777      * Tokens start existing when they are minted (`_mint`),
778      */
779     function _exists(uint256 tokenId) internal view returns (bool) {
780         return
781             _startTokenId() <= tokenId &&
782             tokenId < _currentIndex && // If within bounds,
783             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
784     }
785 
786     /**
787      * @dev Equivalent to `_safeMint(to, quantity, '')`.
788      */
789     function _safeMint(address to, uint256 quantity) internal {
790         _safeMint(to, quantity, '');
791     }
792 
793     /**
794      * @dev Safely mints `quantity` tokens and transfers them to `to`.
795      *
796      * Requirements:
797      *
798      * - If `to` refers to a smart contract, it must implement
799      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
800      * - `quantity` must be greater than 0.
801      *
802      * Emits a {Transfer} event.
803      */
804     function _safeMint(
805         address to,
806         uint256 quantity,
807         bytes memory _data
808     ) internal {
809         uint256 startTokenId = _currentIndex;
810         if (to == address(0)) revert MintToZeroAddress();
811         if (quantity == 0) revert MintZeroQuantity();
812 
813         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
814 
815         // Overflows are incredibly unrealistic.
816         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
817         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
818         unchecked {
819             // Updates:
820             // - `balance += quantity`.
821             // - `numberMinted += quantity`.
822             //
823             // We can directly add to the balance and number minted.
824             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
825 
826             // Updates:
827             // - `address` to the owner.
828             // - `startTimestamp` to the timestamp of minting.
829             // - `burned` to `false`.
830             // - `nextInitialized` to `quantity == 1`.
831             _packedOwnerships[startTokenId] =
832                 _addressToUint256(to) |
833                 (block.timestamp << BITPOS_START_TIMESTAMP) |
834                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
835 
836             uint256 updatedIndex = startTokenId;
837             uint256 end = updatedIndex + quantity;
838 
839             if (to.code.length != 0) {
840                 do {
841                     emit Transfer(address(0), to, updatedIndex);
842                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
843                         revert TransferToNonERC721ReceiverImplementer();
844                     }
845                 } while (updatedIndex < end);
846                 // Reentrancy protection
847                 if (_currentIndex != startTokenId) revert();
848             } else {
849                 do {
850                     emit Transfer(address(0), to, updatedIndex++);
851                 } while (updatedIndex < end);
852             }
853             _currentIndex = updatedIndex;
854         }
855         _afterTokenTransfers(address(0), to, startTokenId, quantity);
856     }
857 
858     /**
859      * @dev Mints `quantity` tokens and transfers them to `to`.
860      *
861      * Requirements:
862      *
863      * - `to` cannot be the zero address.
864      * - `quantity` must be greater than 0.
865      *
866      * Emits a {Transfer} event.
867      */
868     function _mint(address to, uint256 quantity) internal {
869         uint256 startTokenId = _currentIndex;
870         if (to == address(0)) revert MintToZeroAddress();
871         if (quantity == 0) revert MintZeroQuantity();
872 
873         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
874 
875         // Overflows are incredibly unrealistic.
876         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
877         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
878         unchecked {
879             // Updates:
880             // - `balance += quantity`.
881             // - `numberMinted += quantity`.
882             //
883             // We can directly add to the balance and number minted.
884             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
885 
886             // Updates:
887             // - `address` to the owner.
888             // - `startTimestamp` to the timestamp of minting.
889             // - `burned` to `false`.
890             // - `nextInitialized` to `quantity == 1`.
891             _packedOwnerships[startTokenId] =
892                 _addressToUint256(to) |
893                 (block.timestamp << BITPOS_START_TIMESTAMP) |
894                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
895 
896             uint256 updatedIndex = startTokenId;
897             uint256 end = updatedIndex + quantity;
898 
899             do {
900                 emit Transfer(address(0), to, updatedIndex++);
901             } while (updatedIndex < end);
902 
903             _currentIndex = updatedIndex;
904         }
905         _afterTokenTransfers(address(0), to, startTokenId, quantity);
906     }
907 
908     /**
909      * @dev Transfers `tokenId` from `from` to `to`.
910      *
911      * Requirements:
912      *
913      * - `to` cannot be the zero address.
914      * - `tokenId` token must be owned by `from`.
915      *
916      * Emits a {Transfer} event.
917      */
918     function _transfer(
919         address from,
920         address to,
921         uint256 tokenId
922     ) private {
923         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
924 
925         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
926 
927         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
928             isApprovedForAll(from, _msgSenderERC721A()) ||
929             getApproved(tokenId) == _msgSenderERC721A());
930 
931         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
932         if (to == address(0)) revert TransferToZeroAddress();
933 
934         _beforeTokenTransfers(from, to, tokenId, 1);
935 
936         // Clear approvals from the previous owner.
937         delete _tokenApprovals[tokenId];
938 
939         // Underflow of the sender's balance is impossible because we check for
940         // ownership above and the recipient's balance can't realistically overflow.
941         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
942         unchecked {
943             // We can directly increment and decrement the balances.
944             --_packedAddressData[from]; // Updates: `balance -= 1`.
945             ++_packedAddressData[to]; // Updates: `balance += 1`.
946 
947             // Updates:
948             // - `address` to the next owner.
949             // - `startTimestamp` to the timestamp of transfering.
950             // - `burned` to `false`.
951             // - `nextInitialized` to `true`.
952             _packedOwnerships[tokenId] =
953                 _addressToUint256(to) |
954                 (block.timestamp << BITPOS_START_TIMESTAMP) |
955                 BITMASK_NEXT_INITIALIZED;
956 
957             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
958             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
959                 uint256 nextTokenId = tokenId + 1;
960                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
961                 if (_packedOwnerships[nextTokenId] == 0) {
962                     // If the next slot is within bounds.
963                     if (nextTokenId != _currentIndex) {
964                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
965                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
966                     }
967                 }
968             }
969         }
970 
971         emit Transfer(from, to, tokenId);
972         _afterTokenTransfers(from, to, tokenId, 1);
973     }
974 
975     /**
976      * @dev Equivalent to `_burn(tokenId, false)`.
977      */
978     function _burn(uint256 tokenId) internal virtual {
979         _burn(tokenId, false);
980     }
981 
982     /**
983      * @dev Destroys `tokenId`.
984      * The approval is cleared when the token is burned.
985      *
986      * Requirements:
987      *
988      * - `tokenId` must exist.
989      *
990      * Emits a {Transfer} event.
991      */
992     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
993         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
994 
995         address from = address(uint160(prevOwnershipPacked));
996 
997         if (approvalCheck) {
998             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
999                 isApprovedForAll(from, _msgSenderERC721A()) ||
1000                 getApproved(tokenId) == _msgSenderERC721A());
1001 
1002             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1003         }
1004 
1005         _beforeTokenTransfers(from, address(0), tokenId, 1);
1006 
1007         // Clear approvals from the previous owner.
1008         delete _tokenApprovals[tokenId];
1009 
1010         // Underflow of the sender's balance is impossible because we check for
1011         // ownership above and the recipient's balance can't realistically overflow.
1012         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1013         unchecked {
1014             // Updates:
1015             // - `balance -= 1`.
1016             // - `numberBurned += 1`.
1017             //
1018             // We can directly decrement the balance, and increment the number burned.
1019             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1020             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1021 
1022             // Updates:
1023             // - `address` to the last owner.
1024             // - `startTimestamp` to the timestamp of burning.
1025             // - `burned` to `true`.
1026             // - `nextInitialized` to `true`.
1027             _packedOwnerships[tokenId] =
1028                 _addressToUint256(from) |
1029                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1030                 BITMASK_BURNED | 
1031                 BITMASK_NEXT_INITIALIZED;
1032 
1033             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1034             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1035                 uint256 nextTokenId = tokenId + 1;
1036                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1037                 if (_packedOwnerships[nextTokenId] == 0) {
1038                     // If the next slot is within bounds.
1039                     if (nextTokenId != _currentIndex) {
1040                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1041                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1042                     }
1043                 }
1044             }
1045         }
1046 
1047         emit Transfer(from, address(0), tokenId);
1048         _afterTokenTransfers(from, address(0), tokenId, 1);
1049 
1050         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1051         unchecked {
1052             _burnCounter++;
1053         }
1054     }
1055 
1056     /**
1057      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1058      *
1059      * @param from address representing the previous owner of the given token ID
1060      * @param to target address that will receive the tokens
1061      * @param tokenId uint256 ID of the token to be transferred
1062      * @param _data bytes optional data to send along with the call
1063      * @return bool whether the call correctly returned the expected magic value
1064      */
1065     function _checkContractOnERC721Received(
1066         address from,
1067         address to,
1068         uint256 tokenId,
1069         bytes memory _data
1070     ) private returns (bool) {
1071         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1072             bytes4 retval
1073         ) {
1074             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1075         } catch (bytes memory reason) {
1076             if (reason.length == 0) {
1077                 revert TransferToNonERC721ReceiverImplementer();
1078             } else {
1079                 assembly {
1080                     revert(add(32, reason), mload(reason))
1081                 }
1082             }
1083         }
1084     }
1085 
1086     /**
1087      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1088      * And also called before burning one token.
1089      *
1090      * startTokenId - the first token id to be transferred
1091      * quantity - the amount to be transferred
1092      *
1093      * Calling conditions:
1094      *
1095      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1096      * transferred to `to`.
1097      * - When `from` is zero, `tokenId` will be minted for `to`.
1098      * - When `to` is zero, `tokenId` will be burned by `from`.
1099      * - `from` and `to` are never both zero.
1100      */
1101     function _beforeTokenTransfers(
1102         address from,
1103         address to,
1104         uint256 startTokenId,
1105         uint256 quantity
1106     ) internal virtual {}
1107 
1108     /**
1109      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1110      * minting.
1111      * And also called after one token has been burned.
1112      *
1113      * startTokenId - the first token id to be transferred
1114      * quantity - the amount to be transferred
1115      *
1116      * Calling conditions:
1117      *
1118      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1119      * transferred to `to`.
1120      * - When `from` is zero, `tokenId` has been minted for `to`.
1121      * - When `to` is zero, `tokenId` has been burned by `from`.
1122      * - `from` and `to` are never both zero.
1123      */
1124     function _afterTokenTransfers(
1125         address from,
1126         address to,
1127         uint256 startTokenId,
1128         uint256 quantity
1129     ) internal virtual {}
1130 
1131     /**
1132      * @dev Returns the message sender (defaults to `msg.sender`).
1133      *
1134      * If you are writing GSN compatible contracts, you need to override this function.
1135      */
1136     function _msgSenderERC721A() internal view virtual returns (address) {
1137         return msg.sender;
1138     }
1139 
1140     /**
1141      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1142      */
1143     function _toString(uint256 value) internal pure returns (string memory ptr) {
1144         assembly {
1145             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1146             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1147             // We will need 1 32-byte word to store the length, 
1148             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1149             ptr := add(mload(0x40), 128)
1150             // Update the free memory pointer to allocate.
1151             mstore(0x40, ptr)
1152 
1153             // Cache the end of the memory to calculate the length later.
1154             let end := ptr
1155 
1156             // We write the string from the rightmost digit to the leftmost digit.
1157             // The following is essentially a do-while loop that also handles the zero case.
1158             // Costs a bit more than early returning for the zero case,
1159             // but cheaper in terms of deployment and overall runtime costs.
1160             for { 
1161                 // Initialize and perform the first pass without check.
1162                 let temp := value
1163                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1164                 ptr := sub(ptr, 1)
1165                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1166                 mstore8(ptr, add(48, mod(temp, 10)))
1167                 temp := div(temp, 10)
1168             } temp { 
1169                 // Keep dividing `temp` until zero.
1170                 temp := div(temp, 10)
1171             } { // Body of the for loop.
1172                 ptr := sub(ptr, 1)
1173                 mstore8(ptr, add(48, mod(temp, 10)))
1174             }
1175             
1176             let length := sub(end, ptr)
1177             // Move the pointer 32 bytes leftwards to make room for the length.
1178             ptr := sub(ptr, 32)
1179             // Store the length.
1180             mstore(ptr, length)
1181         }
1182     }
1183 }
1184 
1185 // File: nft.sol
1186 
1187 
1188 pragma solidity ^0.8.7;
1189 
1190 
1191 contract wearealam is Ownable, ERC721A {
1192     uint256 public maxSupply                    = 1500;
1193     uint256 public maxFreeSupply                = 600;
1194     
1195     uint256 public maxPerTxDuringMint           = 20;
1196     uint256 public maxPerAddressDuringMint      = 60;
1197     uint256 public maxPerAddressDuringFreeMint  = 2;
1198     
1199     uint256 public price                        = 0.002 ether;
1200     bool    public saleIsActive                 = false;
1201 
1202     address constant internal TEAM_ADDRESS = 0x340d092a590638A2DF356191b7c925f5aa558e03;
1203 
1204     string private _baseTokenURI;
1205 
1206     mapping(address => uint256) public freeMintedAmount;
1207     mapping(address => uint256) public mintedAmount;
1208 
1209     constructor() ERC721A("We are alam", "WAA") {
1210         _safeMint(msg.sender, 20);
1211     }
1212 
1213     modifier mintCompliance() {
1214         require(saleIsActive, "Sale is not active yet.");
1215         require(tx.origin == msg.sender, "Caller cannot be a contract.");
1216         _;
1217     }
1218 
1219     function mint(uint256 _quantity) external payable mintCompliance() {
1220         require(
1221             msg.value >= price * _quantity,
1222             "GDZ: Insufficient Fund."
1223         );
1224         require(
1225             maxSupply >= totalSupply() + _quantity,
1226             "GDZ: Exceeds max supply."
1227         );
1228         uint256 _mintedAmount = mintedAmount[msg.sender];
1229         require(
1230             _mintedAmount + _quantity <= maxPerAddressDuringMint,
1231             "GDZ: Exceeds max mints per address!"
1232         );
1233         require(
1234             _quantity > 0 && _quantity <= maxPerTxDuringMint,
1235             "Invalid mint amount."
1236         );
1237         mintedAmount[msg.sender] = _mintedAmount + _quantity;
1238         _safeMint(msg.sender, _quantity);
1239     }
1240 
1241     function freeMint(uint256 _quantity) external mintCompliance() {
1242         require(
1243             maxFreeSupply >= totalSupply() + _quantity,
1244             "GDZ: Exceeds max free supply."
1245         );
1246         uint256 _freeMintedAmount = freeMintedAmount[msg.sender];
1247         require(
1248             _freeMintedAmount + _quantity <= maxPerAddressDuringFreeMint,
1249             "GDZ: Exceeds max free mints per address!"
1250         );
1251         freeMintedAmount[msg.sender] = _freeMintedAmount + _quantity;
1252         _safeMint(msg.sender, _quantity);
1253     }
1254 
1255     function setPrice(uint256 _price) external onlyOwner {
1256         price = _price;
1257     }
1258 
1259     function setMaxPerTx(uint256 _amount) external onlyOwner {
1260         maxPerTxDuringMint = _amount;
1261     }
1262 
1263     function setMaxPerAddress(uint256 _amount) external onlyOwner {
1264         maxPerAddressDuringMint = _amount;
1265     }
1266 
1267     function setMaxFreePerAddress(uint256 _amount) external onlyOwner {
1268         maxPerAddressDuringFreeMint = _amount;
1269     }
1270 
1271     function flipSale() public onlyOwner {
1272         saleIsActive = !saleIsActive;
1273     }
1274 
1275     function cutMaxSupply(uint256 _amount) public onlyOwner {
1276         require(
1277             maxSupply - _amount >= totalSupply(), 
1278             "Supply cannot fall below minted tokens."
1279         );
1280         maxSupply -= _amount;
1281     }
1282 
1283     function setBaseURI(string calldata baseURI) external onlyOwner {
1284         _baseTokenURI = baseURI;
1285     }
1286 
1287     function _baseURI() internal view virtual override returns (string memory) {
1288         return _baseTokenURI;
1289     }
1290 
1291     function withdrawBalance() external payable onlyOwner {
1292 
1293         (bool success, ) = payable(TEAM_ADDRESS).call{
1294             value: address(this).balance
1295         }("");
1296         require(success, "transfer failed.");
1297     }
1298 }