1 // SPDX-License-Identifier: SimPL-2.0
2 // File: @openzeppelin/contracts/utils/Context.sol
3 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes calldata) {
23         return msg.data;
24     }
25 }
26 
27 // File: @openzeppelin/contracts/access/Ownable.sol
28 
29 
30 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
31 
32 pragma solidity ^0.8.0;
33 
34 
35 /**
36  * @dev Contract module which provides a basic access control mechanism, where
37  * there is an account (an owner) that can be granted exclusive access to
38  * specific functions.
39  *
40  * By default, the owner account will be the one that deploys the contract. This
41  * can later be changed with {transferOwnership}.
42  *
43  * This module is used through inheritance. It will make available the modifier
44  * `onlyOwner`, which can be applied to your functions to restrict their use to
45  * the owner.
46  */
47 abstract contract Ownable is Context {
48     address private _owner;
49 
50     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
51 
52     /**
53      * @dev Initializes the contract setting the deployer as the initial owner.
54      */
55     constructor() {
56         _transferOwnership(_msgSender());
57     }
58 
59     /**
60      * @dev Returns the address of the current owner.
61      */
62     function owner() public view virtual returns (address) {
63         return _owner;
64     }
65 
66     /**
67      * @dev Throws if called by any account other than the owner.
68      */
69     modifier onlyOwner() {
70         require(owner() == _msgSender(), "Ownable: caller is not the owner");
71         _;
72     }
73 
74     /**
75      * @dev Leaves the contract without owner. It will not be possible to call
76      * `onlyOwner` functions anymore. Can only be called by the current owner.
77      *
78      * NOTE: Renouncing ownership will leave the contract without an owner,
79      * thereby removing any functionality that is only available to the owner.
80      */
81     function renounceOwnership() public virtual onlyOwner {
82         _transferOwnership(address(0));
83     }
84 
85     /**
86      * @dev Transfers ownership of the contract to a new account (`newOwner`).
87      * Can only be called by the current owner.
88      */
89     function transferOwnership(address newOwner) public virtual onlyOwner {
90         require(newOwner != address(0), "Ownable: new owner is the zero address");
91         _transferOwnership(newOwner);
92     }
93 
94     /**
95      * @dev Transfers ownership of the contract to a new account (`newOwner`).
96      * Internal function without access restriction.
97      */
98     function _transferOwnership(address newOwner) internal virtual {
99         address oldOwner = _owner;
100         _owner = newOwner;
101         emit OwnershipTransferred(oldOwner, newOwner);
102     }
103 }
104 
105 // File: erc721a/contracts/IERC721A.sol
106 
107 
108 // ERC721A Contracts v4.0.0
109 // Creator: Chiru Labs
110 
111 pragma solidity ^0.8.4;
112 
113 /**
114  * @dev Interface of an ERC721A compliant contract.
115  */
116 interface IERC721A {
117     /**
118      * The caller must own the token or be an approved operator.
119      */
120     error ApprovalCallerNotOwnerNorApproved();
121 
122     /**
123      * The token does not exist.
124      */
125     error ApprovalQueryForNonexistentToken();
126 
127     /**
128      * The caller cannot approve to their own address.
129      */
130     error ApproveToCaller();
131 
132     /**
133      * The caller cannot approve to the current owner.
134      */
135     error ApprovalToCurrentOwner();
136 
137     /**
138      * Cannot query the balance for the zero address.
139      */
140     error BalanceQueryForZeroAddress();
141 
142     /**
143      * Cannot mint to the zero address.
144      */
145     error MintToZeroAddress();
146 
147     /**
148      * The quantity of tokens minted must be more than zero.
149      */
150     error MintZeroQuantity();
151 
152     /**
153      * The token does not exist.
154      */
155     error OwnerQueryForNonexistentToken();
156 
157     /**
158      * The caller must own the token or be an approved operator.
159      */
160     error TransferCallerNotOwnerNorApproved();
161 
162     /**
163      * The token must be owned by `from`.
164      */
165     error TransferFromIncorrectOwner();
166 
167     /**
168      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
169      */
170     error TransferToNonERC721ReceiverImplementer();
171 
172     /**
173      * Cannot transfer to the zero address.
174      */
175     error TransferToZeroAddress();
176 
177     /**
178      * The token does not exist.
179      */
180     error URIQueryForNonexistentToken();
181 
182     struct TokenOwnership {
183         // The address of the owner.
184         address addr;
185         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
186         uint64 startTimestamp;
187         // Whether the token has been burned.
188         bool burned;
189     }
190 
191     /**
192      * @dev Returns the total amount of tokens stored by the contract.
193      *
194      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
195      */
196     function totalSupply() external view returns (uint256);
197 
198     // ==============================
199     //            IERC165
200     // ==============================
201 
202     /**
203      * @dev Returns true if this contract implements the interface defined by
204      * `interfaceId`. See the corresponding
205      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
206      * to learn more about how these ids are created.
207      *
208      * This function call must use less than 30 000 gas.
209      */
210     function supportsInterface(bytes4 interfaceId) external view returns (bool);
211 
212     // ==============================
213     //            IERC721
214     // ==============================
215 
216     /**
217      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
218      */
219     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
220 
221     /**
222      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
223      */
224     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
225 
226     /**
227      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
228      */
229     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
230 
231     /**
232      * @dev Returns the number of tokens in ``owner``'s account.
233      */
234     function balanceOf(address owner) external view returns (uint256 balance);
235 
236     /**
237      * @dev Returns the owner of the `tokenId` token.
238      *
239      * Requirements:
240      *
241      * - `tokenId` must exist.
242      */
243     function ownerOf(uint256 tokenId) external view returns (address owner);
244 
245     /**
246      * @dev Safely transfers `tokenId` token from `from` to `to`.
247      *
248      * Requirements:
249      *
250      * - `from` cannot be the zero address.
251      * - `to` cannot be the zero address.
252      * - `tokenId` token must exist and be owned by `from`.
253      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
254      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
255      *
256      * Emits a {Transfer} event.
257      */
258     function safeTransferFrom(
259         address from,
260         address to,
261         uint256 tokenId,
262         bytes calldata data
263     ) external;
264 
265     /**
266      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
267      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
268      *
269      * Requirements:
270      *
271      * - `from` cannot be the zero address.
272      * - `to` cannot be the zero address.
273      * - `tokenId` token must exist and be owned by `from`.
274      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
275      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
276      *
277      * Emits a {Transfer} event.
278      */
279     function safeTransferFrom(
280         address from,
281         address to,
282         uint256 tokenId
283     ) external;
284 
285     /**
286      * @dev Transfers `tokenId` token from `from` to `to`.
287      *
288      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
289      *
290      * Requirements:
291      *
292      * - `from` cannot be the zero address.
293      * - `to` cannot be the zero address.
294      * - `tokenId` token must be owned by `from`.
295      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
296      *
297      * Emits a {Transfer} event.
298      */
299     function transferFrom(
300         address from,
301         address to,
302         uint256 tokenId
303     ) external;
304 
305     /**
306      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
307      * The approval is cleared when the token is transferred.
308      *
309      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
310      *
311      * Requirements:
312      *
313      * - The caller must own the token or be an approved operator.
314      * - `tokenId` must exist.
315      *
316      * Emits an {Approval} event.
317      */
318     function approve(address to, uint256 tokenId) external;
319 
320     /**
321      * @dev Approve or remove `operator` as an operator for the caller.
322      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
323      *
324      * Requirements:
325      *
326      * - The `operator` cannot be the caller.
327      *
328      * Emits an {ApprovalForAll} event.
329      */
330     function setApprovalForAll(address operator, bool _approved) external;
331 
332     /**
333      * @dev Returns the account approved for `tokenId` token.
334      *
335      * Requirements:
336      *
337      * - `tokenId` must exist.
338      */
339     function getApproved(uint256 tokenId) external view returns (address operator);
340 
341     /**
342      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
343      *
344      * See {setApprovalForAll}
345      */
346     function isApprovedForAll(address owner, address operator) external view returns (bool);
347 
348     // ==============================
349     //        IERC721Metadata
350     // ==============================
351 
352     /**
353      * @dev Returns the token collection name.
354      */
355     function name() external view returns (string memory);
356 
357     /**
358      * @dev Returns the token collection symbol.
359      */
360     function symbol() external view returns (string memory);
361 
362     /**
363      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
364      */
365     function tokenURI(uint256 tokenId) external view returns (string memory);
366 }
367 
368 // File: erc721a/contracts/ERC721A.sol
369 
370 
371 // ERC721A Contracts v4.0.0
372 // Creator: Chiru Labs
373 
374 pragma solidity ^0.8.4;
375 
376 
377 /**
378  * @dev ERC721 token receiver interface.
379  */
380 interface ERC721A__IERC721Receiver {
381     function onERC721Received(
382         address operator,
383         address from,
384         uint256 tokenId,
385         bytes calldata data
386     ) external returns (bytes4);
387 }
388 
389 /**
390  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
391  * the Metadata extension. Built to optimize for lower gas during batch mints.
392  *
393  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
394  *
395  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
396  *
397  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
398  */
399 contract ERC721A is IERC721A {
400     // Mask of an entry in packed address data.
401     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
402 
403     // The bit position of `numberMinted` in packed address data.
404     uint256 private constant BITPOS_NUMBER_MINTED = 64;
405 
406     // The bit position of `numberBurned` in packed address data.
407     uint256 private constant BITPOS_NUMBER_BURNED = 128;
408 
409     // The bit position of `aux` in packed address data.
410     uint256 private constant BITPOS_AUX = 192;
411 
412     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
413     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
414 
415     // The bit position of `startTimestamp` in packed ownership.
416     uint256 private constant BITPOS_START_TIMESTAMP = 160;
417 
418     // The bit mask of the `burned` bit in packed ownership.
419     uint256 private constant BITMASK_BURNED = 1 << 224;
420     
421     // The bit position of the `nextInitialized` bit in packed ownership.
422     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
423 
424     // The bit mask of the `nextInitialized` bit in packed ownership.
425     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
426 
427     // The tokenId of the next token to be minted.
428     uint256 private _currentIndex;
429 
430     // The number of tokens burned.
431     uint256 private _burnCounter;
432 
433     // Token name
434     string private _name;
435 
436     // Token symbol
437     string private _symbol;
438 
439     // Mapping from token ID to ownership details
440     // An empty struct value does not necessarily mean the token is unowned.
441     // See `_packedOwnershipOf` implementation for details.
442     //
443     // Bits Layout:
444     // - [0..159]   `addr`
445     // - [160..223] `startTimestamp`
446     // - [224]      `burned`
447     // - [225]      `nextInitialized`
448     mapping(uint256 => uint256) private _packedOwnerships;
449 
450     // Mapping owner address to address data.
451     //
452     // Bits Layout:
453     // - [0..63]    `balance`
454     // - [64..127]  `numberMinted`
455     // - [128..191] `numberBurned`
456     // - [192..255] `aux`
457     mapping(address => uint256) private _packedAddressData;
458 
459     // Mapping from token ID to approved address.
460     mapping(uint256 => address) private _tokenApprovals;
461 
462     // Mapping from owner to operator approvals
463     mapping(address => mapping(address => bool)) private _operatorApprovals;
464 
465     constructor(string memory name_, string memory symbol_) {
466         _name = name_;
467         _symbol = symbol_;
468         _currentIndex = _startTokenId();
469     }
470 
471     /**
472      * @dev Returns the starting token ID. 
473      * To change the starting token ID, please override this function.
474      */
475     function _startTokenId() internal view virtual returns (uint256) {
476         return 0;
477     }
478 
479     /**
480      * @dev Returns the next token ID to be minted.
481      */
482     function _nextTokenId() internal view returns (uint256) {
483         return _currentIndex;
484     }
485 
486     /**
487      * @dev Returns the total number of tokens in existence.
488      * Burned tokens will reduce the count. 
489      * To get the total number of tokens minted, please see `_totalMinted`.
490      */
491     function totalSupply() public view override returns (uint256) {
492         // Counter underflow is impossible as _burnCounter cannot be incremented
493         // more than `_currentIndex - _startTokenId()` times.
494         unchecked {
495             return _currentIndex - _burnCounter - _startTokenId();
496         }
497     }
498 
499     /**
500      * @dev Returns the total amount of tokens minted in the contract.
501      */
502     function _totalMinted() internal view returns (uint256) {
503         // Counter underflow is impossible as _currentIndex does not decrement,
504         // and it is initialized to `_startTokenId()`
505         unchecked {
506             return _currentIndex - _startTokenId();
507         }
508     }
509 
510     /**
511      * @dev Returns the total number of tokens burned.
512      */
513     function _totalBurned() internal view returns (uint256) {
514         return _burnCounter;
515     }
516 
517     /**
518      * @dev See {IERC165-supportsInterface}.
519      */
520     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
521         // The interface IDs are constants representing the first 4 bytes of the XOR of
522         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
523         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
524         return
525             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
526             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
527             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
528     }
529 
530     /**
531      * @dev See {IERC721-balanceOf}.
532      */
533     function balanceOf(address owner) public view override returns (uint256) {
534         if (owner == address(0)) revert BalanceQueryForZeroAddress();
535         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
536     }
537 
538     /**
539      * Returns the number of tokens minted by `owner`.
540      */
541     function _numberMinted(address owner) internal view returns (uint256) {
542         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
543     }
544 
545     /**
546      * Returns the number of tokens burned by or on behalf of `owner`.
547      */
548     function _numberBurned(address owner) internal view returns (uint256) {
549         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
550     }
551 
552     /**
553      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
554      */
555     function _getAux(address owner) internal view returns (uint64) {
556         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
557     }
558 
559     /**
560      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
561      * If there are multiple variables, please pack them into a uint64.
562      */
563     function _setAux(address owner, uint64 aux) internal {
564         uint256 packed = _packedAddressData[owner];
565         uint256 auxCasted;
566         assembly { // Cast aux without masking.
567             auxCasted := aux
568         }
569         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
570         _packedAddressData[owner] = packed;
571     }
572 
573     /**
574      * Returns the packed ownership data of `tokenId`.
575      */
576     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
577         uint256 curr = tokenId;
578 
579         unchecked {
580             if (_startTokenId() <= curr)
581                 if (curr < _currentIndex) {
582                     uint256 packed = _packedOwnerships[curr];
583                     // If not burned.
584                     if (packed & BITMASK_BURNED == 0) {
585                         // Invariant:
586                         // There will always be an ownership that has an address and is not burned
587                         // before an ownership that does not have an address and is not burned.
588                         // Hence, curr will not underflow.
589                         //
590                         // We can directly compare the packed value.
591                         // If the address is zero, packed is zero.
592                         while (packed == 0) {
593                             packed = _packedOwnerships[--curr];
594                         }
595                         return packed;
596                     }
597                 }
598         }
599         revert OwnerQueryForNonexistentToken();
600     }
601 
602     /**
603      * Returns the unpacked `TokenOwnership` struct from `packed`.
604      */
605     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
606         ownership.addr = address(uint160(packed));
607         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
608         ownership.burned = packed & BITMASK_BURNED != 0;
609     }
610 
611     /**
612      * Returns the unpacked `TokenOwnership` struct at `index`.
613      */
614     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
615         return _unpackedOwnership(_packedOwnerships[index]);
616     }
617 
618     /**
619      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
620      */
621     function _initializeOwnershipAt(uint256 index) internal {
622         if (_packedOwnerships[index] == 0) {
623             _packedOwnerships[index] = _packedOwnershipOf(index);
624         }
625     }
626 
627     /**
628      * Gas spent here starts off proportional to the maximum mint batch size.
629      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
630      */
631     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
632         return _unpackedOwnership(_packedOwnershipOf(tokenId));
633     }
634 
635     /**
636      * @dev See {IERC721-ownerOf}.
637      */
638     function ownerOf(uint256 tokenId) public view override returns (address) {
639         return address(uint160(_packedOwnershipOf(tokenId)));
640     }
641 
642     /**
643      * @dev See {IERC721Metadata-name}.
644      */
645     function name() public view virtual override returns (string memory) {
646         return _name;
647     }
648 
649     /**
650      * @dev See {IERC721Metadata-symbol}.
651      */
652     function symbol() public view virtual override returns (string memory) {
653         return _symbol;
654     }
655 
656     /**
657      * @dev See {IERC721Metadata-tokenURI}.
658      */
659     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
660         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
661 
662         string memory baseURI = _baseURI();
663         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
664     }
665 
666     /**
667      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
668      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
669      * by default, can be overriden in child contracts.
670      */
671     function _baseURI() internal view virtual returns (string memory) {
672         return '';
673     }
674 
675     /**
676      * @dev Casts the address to uint256 without masking.
677      */
678     function _addressToUint256(address value) private pure returns (uint256 result) {
679         assembly {
680             result := value
681         }
682     }
683 
684     /**
685      * @dev Casts the boolean to uint256 without branching.
686      */
687     function _boolToUint256(bool value) private pure returns (uint256 result) {
688         assembly {
689             result := value
690         }
691     }
692 
693     /**
694      * @dev See {IERC721-approve}.
695      */
696     function approve(address to, uint256 tokenId) public override {
697         address owner = address(uint160(_packedOwnershipOf(tokenId)));
698         if (to == owner) revert ApprovalToCurrentOwner();
699 
700         if (_msgSenderERC721A() != owner)
701             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
702                 revert ApprovalCallerNotOwnerNorApproved();
703             }
704 
705         _tokenApprovals[tokenId] = to;
706         emit Approval(owner, to, tokenId);
707     }
708 
709     /**
710      * @dev See {IERC721-getApproved}.
711      */
712     function getApproved(uint256 tokenId) public view override returns (address) {
713         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
714 
715         return _tokenApprovals[tokenId];
716     }
717 
718     /**
719      * @dev See {IERC721-setApprovalForAll}.
720      */
721     function setApprovalForAll(address operator, bool approved) public virtual override {
722         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
723 
724         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
725         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
726     }
727 
728     /**
729      * @dev See {IERC721-isApprovedForAll}.
730      */
731     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
732         return _operatorApprovals[owner][operator];
733     }
734 
735     /**
736      * @dev See {IERC721-transferFrom}.
737      */
738     function transferFrom(
739         address from,
740         address to,
741         uint256 tokenId
742     ) public virtual override {
743         _transfer(from, to, tokenId);
744     }
745 
746     /**
747      * @dev See {IERC721-safeTransferFrom}.
748      */
749     function safeTransferFrom(
750         address from,
751         address to,
752         uint256 tokenId
753     ) public virtual override {
754         safeTransferFrom(from, to, tokenId, '');
755     }
756 
757     /**
758      * @dev See {IERC721-safeTransferFrom}.
759      */
760     function safeTransferFrom(
761         address from,
762         address to,
763         uint256 tokenId,
764         bytes memory _data
765     ) public virtual override {
766         _transfer(from, to, tokenId);
767         if (to.code.length != 0)
768             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
769                 revert TransferToNonERC721ReceiverImplementer();
770             }
771     }
772 
773     /**
774      * @dev Returns whether `tokenId` exists.
775      *
776      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
777      *
778      * Tokens start existing when they are minted (`_mint`),
779      */
780     function _exists(uint256 tokenId) internal view returns (bool) {
781         return
782             _startTokenId() <= tokenId &&
783             tokenId < _currentIndex && // If within bounds,
784             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
785     }
786 
787     /**
788      * @dev Equivalent to `_safeMint(to, quantity, '')`.
789      */
790     function _safeMint(address to, uint256 quantity) internal {
791         _safeMint(to, quantity, '');
792     }
793 
794     /**
795      * @dev Safely mints `quantity` tokens and transfers them to `to`.
796      *
797      * Requirements:
798      *
799      * - If `to` refers to a smart contract, it must implement
800      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
801      * - `quantity` must be greater than 0.
802      *
803      * Emits a {Transfer} event.
804      */
805     function _safeMint(
806         address to,
807         uint256 quantity,
808         bytes memory _data
809     ) internal {
810         uint256 startTokenId = _currentIndex;
811         if (to == address(0)) revert MintToZeroAddress();
812         if (quantity == 0) revert MintZeroQuantity();
813 
814         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
815 
816         // Overflows are incredibly unrealistic.
817         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
818         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
819         unchecked {
820             // Updates:
821             // - `balance += quantity`.
822             // - `numberMinted += quantity`.
823             //
824             // We can directly add to the balance and number minted.
825             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
826 
827             // Updates:
828             // - `address` to the owner.
829             // - `startTimestamp` to the timestamp of minting.
830             // - `burned` to `false`.
831             // - `nextInitialized` to `quantity == 1`.
832             _packedOwnerships[startTokenId] =
833                 _addressToUint256(to) |
834                 (block.timestamp << BITPOS_START_TIMESTAMP) |
835                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
836 
837             uint256 updatedIndex = startTokenId;
838             uint256 end = updatedIndex + quantity;
839 
840             if (to.code.length != 0) {
841                 do {
842                     emit Transfer(address(0), to, updatedIndex);
843                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
844                         revert TransferToNonERC721ReceiverImplementer();
845                     }
846                 } while (updatedIndex < end);
847                 // Reentrancy protection
848                 if (_currentIndex != startTokenId) revert();
849             } else {
850                 do {
851                     emit Transfer(address(0), to, updatedIndex++);
852                 } while (updatedIndex < end);
853             }
854             _currentIndex = updatedIndex;
855         }
856         _afterTokenTransfers(address(0), to, startTokenId, quantity);
857     }
858 
859     /**
860      * @dev Mints `quantity` tokens and transfers them to `to`.
861      *
862      * Requirements:
863      *
864      * - `to` cannot be the zero address.
865      * - `quantity` must be greater than 0.
866      *
867      * Emits a {Transfer} event.
868      */
869     function _mint(address to, uint256 quantity) internal {
870         uint256 startTokenId = _currentIndex;
871         if (to == address(0)) revert MintToZeroAddress();
872         if (quantity == 0) revert MintZeroQuantity();
873 
874         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
875 
876         // Overflows are incredibly unrealistic.
877         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
878         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
879         unchecked {
880             // Updates:
881             // - `balance += quantity`.
882             // - `numberMinted += quantity`.
883             //
884             // We can directly add to the balance and number minted.
885             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
886 
887             // Updates:
888             // - `address` to the owner.
889             // - `startTimestamp` to the timestamp of minting.
890             // - `burned` to `false`.
891             // - `nextInitialized` to `quantity == 1`.
892             _packedOwnerships[startTokenId] =
893                 _addressToUint256(to) |
894                 (block.timestamp << BITPOS_START_TIMESTAMP) |
895                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
896 
897             uint256 updatedIndex = startTokenId;
898             uint256 end = updatedIndex + quantity;
899 
900             do {
901                 emit Transfer(address(0), to, updatedIndex++);
902             } while (updatedIndex < end);
903 
904             _currentIndex = updatedIndex;
905         }
906         _afterTokenTransfers(address(0), to, startTokenId, quantity);
907     }
908 
909     /**
910      * @dev Transfers `tokenId` from `from` to `to`.
911      *
912      * Requirements:
913      *
914      * - `to` cannot be the zero address.
915      * - `tokenId` token must be owned by `from`.
916      *
917      * Emits a {Transfer} event.
918      */
919     function _transfer(
920         address from,
921         address to,
922         uint256 tokenId
923     ) private {
924         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
925 
926         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
927 
928         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
929             isApprovedForAll(from, _msgSenderERC721A()) ||
930             getApproved(tokenId) == _msgSenderERC721A());
931 
932         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
933         if (to == address(0)) revert TransferToZeroAddress();
934 
935         _beforeTokenTransfers(from, to, tokenId, 1);
936 
937         // Clear approvals from the previous owner.
938         delete _tokenApprovals[tokenId];
939 
940         // Underflow of the sender's balance is impossible because we check for
941         // ownership above and the recipient's balance can't realistically overflow.
942         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
943         unchecked {
944             // We can directly increment and decrement the balances.
945             --_packedAddressData[from]; // Updates: `balance -= 1`.
946             ++_packedAddressData[to]; // Updates: `balance += 1`.
947 
948             // Updates:
949             // - `address` to the next owner.
950             // - `startTimestamp` to the timestamp of transfering.
951             // - `burned` to `false`.
952             // - `nextInitialized` to `true`.
953             _packedOwnerships[tokenId] =
954                 _addressToUint256(to) |
955                 (block.timestamp << BITPOS_START_TIMESTAMP) |
956                 BITMASK_NEXT_INITIALIZED;
957 
958             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
959             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
960                 uint256 nextTokenId = tokenId + 1;
961                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
962                 if (_packedOwnerships[nextTokenId] == 0) {
963                     // If the next slot is within bounds.
964                     if (nextTokenId != _currentIndex) {
965                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
966                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
967                     }
968                 }
969             }
970         }
971 
972         emit Transfer(from, to, tokenId);
973         _afterTokenTransfers(from, to, tokenId, 1);
974     }
975 
976     /**
977      * @dev Equivalent to `_burn(tokenId, false)`.
978      */
979     function _burn(uint256 tokenId) internal virtual {
980         _burn(tokenId, false);
981     }
982 
983     /**
984      * @dev Destroys `tokenId`.
985      * The approval is cleared when the token is burned.
986      *
987      * Requirements:
988      *
989      * - `tokenId` must exist.
990      *
991      * Emits a {Transfer} event.
992      */
993     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
994         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
995 
996         address from = address(uint160(prevOwnershipPacked));
997 
998         if (approvalCheck) {
999             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1000                 isApprovedForAll(from, _msgSenderERC721A()) ||
1001                 getApproved(tokenId) == _msgSenderERC721A());
1002 
1003             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1004         }
1005 
1006         _beforeTokenTransfers(from, address(0), tokenId, 1);
1007 
1008         // Clear approvals from the previous owner.
1009         delete _tokenApprovals[tokenId];
1010 
1011         // Underflow of the sender's balance is impossible because we check for
1012         // ownership above and the recipient's balance can't realistically overflow.
1013         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1014         unchecked {
1015             // Updates:
1016             // - `balance -= 1`.
1017             // - `numberBurned += 1`.
1018             //
1019             // We can directly decrement the balance, and increment the number burned.
1020             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1021             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1022 
1023             // Updates:
1024             // - `address` to the last owner.
1025             // - `startTimestamp` to the timestamp of burning.
1026             // - `burned` to `true`.
1027             // - `nextInitialized` to `true`.
1028             _packedOwnerships[tokenId] =
1029                 _addressToUint256(from) |
1030                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1031                 BITMASK_BURNED | 
1032                 BITMASK_NEXT_INITIALIZED;
1033 
1034             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1035             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1036                 uint256 nextTokenId = tokenId + 1;
1037                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1038                 if (_packedOwnerships[nextTokenId] == 0) {
1039                     // If the next slot is within bounds.
1040                     if (nextTokenId != _currentIndex) {
1041                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1042                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1043                     }
1044                 }
1045             }
1046         }
1047 
1048         emit Transfer(from, address(0), tokenId);
1049         _afterTokenTransfers(from, address(0), tokenId, 1);
1050 
1051         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1052         unchecked {
1053             _burnCounter++;
1054         }
1055     }
1056 
1057     /**
1058      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1059      *
1060      * @param from address representing the previous owner of the given token ID
1061      * @param to target address that will receive the tokens
1062      * @param tokenId uint256 ID of the token to be transferred
1063      * @param _data bytes optional data to send along with the call
1064      * @return bool whether the call correctly returned the expected magic value
1065      */
1066     function _checkContractOnERC721Received(
1067         address from,
1068         address to,
1069         uint256 tokenId,
1070         bytes memory _data
1071     ) private returns (bool) {
1072         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1073             bytes4 retval
1074         ) {
1075             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1076         } catch (bytes memory reason) {
1077             if (reason.length == 0) {
1078                 revert TransferToNonERC721ReceiverImplementer();
1079             } else {
1080                 assembly {
1081                     revert(add(32, reason), mload(reason))
1082                 }
1083             }
1084         }
1085     }
1086 
1087     /**
1088      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1089      * And also called before burning one token.
1090      *
1091      * startTokenId - the first token id to be transferred
1092      * quantity - the amount to be transferred
1093      *
1094      * Calling conditions:
1095      *
1096      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1097      * transferred to `to`.
1098      * - When `from` is zero, `tokenId` will be minted for `to`.
1099      * - When `to` is zero, `tokenId` will be burned by `from`.
1100      * - `from` and `to` are never both zero.
1101      */
1102     function _beforeTokenTransfers(
1103         address from,
1104         address to,
1105         uint256 startTokenId,
1106         uint256 quantity
1107     ) internal virtual {}
1108 
1109     /**
1110      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1111      * minting.
1112      * And also called after one token has been burned.
1113      *
1114      * startTokenId - the first token id to be transferred
1115      * quantity - the amount to be transferred
1116      *
1117      * Calling conditions:
1118      *
1119      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1120      * transferred to `to`.
1121      * - When `from` is zero, `tokenId` has been minted for `to`.
1122      * - When `to` is zero, `tokenId` has been burned by `from`.
1123      * - `from` and `to` are never both zero.
1124      */
1125     function _afterTokenTransfers(
1126         address from,
1127         address to,
1128         uint256 startTokenId,
1129         uint256 quantity
1130     ) internal virtual {}
1131 
1132     /**
1133      * @dev Returns the message sender (defaults to `msg.sender`).
1134      *
1135      * If you are writing GSN compatible contracts, you need to override this function.
1136      */
1137     function _msgSenderERC721A() internal view virtual returns (address) {
1138         return msg.sender;
1139     }
1140 
1141     /**
1142      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1143      */
1144     function _toString(uint256 value) internal pure returns (string memory ptr) {
1145         assembly {
1146             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1147             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1148             // We will need 1 32-byte word to store the length, 
1149             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1150             ptr := add(mload(0x40), 128)
1151             // Update the free memory pointer to allocate.
1152             mstore(0x40, ptr)
1153 
1154             // Cache the end of the memory to calculate the length later.
1155             let end := ptr
1156 
1157             // We write the string from the rightmost digit to the leftmost digit.
1158             // The following is essentially a do-while loop that also handles the zero case.
1159             // Costs a bit more than early returning for the zero case,
1160             // but cheaper in terms of deployment and overall runtime costs.
1161             for { 
1162                 // Initialize and perform the first pass without check.
1163                 let temp := value
1164                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1165                 ptr := sub(ptr, 1)
1166                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1167                 mstore8(ptr, add(48, mod(temp, 10)))
1168                 temp := div(temp, 10)
1169             } temp { 
1170                 // Keep dividing `temp` until zero.
1171                 temp := div(temp, 10)
1172             } { // Body of the for loop.
1173                 ptr := sub(ptr, 1)
1174                 mstore8(ptr, add(48, mod(temp, 10)))
1175             }
1176             
1177             let length := sub(end, ptr)
1178             // Move the pointer 32 bytes leftwards to make room for the length.
1179             ptr := sub(ptr, 32)
1180             // Store the length.
1181             mstore(ptr, length)
1182         }
1183     }
1184 }
1185 
1186 // File: nft.sol
1187 
1188 
1189 
1190 pragma solidity ^0.8.13;
1191 
1192 
1193 
1194 contract Unhealthy is Ownable, ERC721A {
1195     uint256 public maxSupply                    = 1000;
1196     uint256 public maxFreeSupply                = 1000;
1197     
1198     uint256 public maxPerTxDuringMint           = 3;
1199     uint256 public maxPerAddressDuringMint      = 300;
1200     uint256 public maxPerAddressDuringFreeMint  = 1;
1201     
1202     uint256 public price                        = 0.01 ether;
1203     bool    public saleIsActive                 = false;
1204 
1205     address constant internal TEAM_ADDRESS = 0xCbc4aeFA9883B706D10D3C22FE1E61dE235F68F1;
1206 
1207     string private _baseTokenURI;
1208 
1209     mapping(address => uint256) public freeMintedAmount;
1210     mapping(address => uint256) public mintedAmount;
1211 
1212     constructor() ERC721A("Unhealthy Thoughts", "Unhealthout") {
1213         _safeMint(msg.sender, 20);
1214     }
1215 
1216     modifier mintCompliance() {
1217         require(saleIsActive, "Sale is not active yet.");
1218         require(tx.origin == msg.sender, "Caller cannot be a contract.");
1219         _;
1220     }
1221 
1222     function mint(uint256 _quantity) external payable mintCompliance() {
1223         require(
1224             msg.value >= price * _quantity,
1225             "Insufficient Fund."
1226         );
1227         require(
1228             maxSupply >= totalSupply() + _quantity,
1229             "Exceeds max supply."
1230         );
1231         uint256 _mintedAmount = mintedAmount[msg.sender];
1232         require(
1233             _mintedAmount + _quantity <= maxPerAddressDuringMint,
1234             "Exceeds max mints per address!"
1235         );
1236         require(
1237             _quantity > 0 && _quantity <= maxPerTxDuringMint,
1238             "Invalid mint amount."
1239         );
1240         mintedAmount[msg.sender] = _mintedAmount + _quantity;
1241         _safeMint(msg.sender, _quantity);
1242     }
1243 
1244     function freeMint(uint256 _quantity) external mintCompliance() {
1245         require(
1246             maxFreeSupply >= totalSupply() + _quantity,
1247             "Exceeds max free supply."
1248         );
1249         uint256 _freeMintedAmount = freeMintedAmount[msg.sender];
1250         require(
1251             _freeMintedAmount + _quantity <= maxPerAddressDuringFreeMint,
1252             "Exceeds max free mints per address!"
1253         );
1254         freeMintedAmount[msg.sender] = _freeMintedAmount + _quantity;
1255         _safeMint(msg.sender, _quantity);
1256     }
1257 
1258     function setPrice(uint256 _price) external onlyOwner {
1259         price = _price;
1260     }
1261 
1262     function setMaxPerTx(uint256 _amount) external onlyOwner {
1263         maxPerTxDuringMint = _amount;
1264     }
1265 
1266     function setMaxPerAddress(uint256 _amount) external onlyOwner {
1267         maxPerAddressDuringMint = _amount;
1268     }
1269 
1270     function setMaxFreePerAddress(uint256 _amount) external onlyOwner {
1271         maxPerAddressDuringFreeMint = _amount;
1272     }
1273 
1274     function flipSale() public onlyOwner {
1275         saleIsActive = !saleIsActive;
1276     }
1277 
1278     function cutMaxSupply(uint256 _amount) public onlyOwner {
1279         require(
1280             maxSupply - _amount >= totalSupply(), 
1281             "Supply cannot fall below minted tokens."
1282         );
1283         maxSupply -= _amount;
1284     }
1285 
1286     function setBaseURI(string calldata baseURI) external onlyOwner {
1287         _baseTokenURI = baseURI;
1288     }
1289 
1290     function _baseURI() internal view virtual override returns (string memory) {
1291         return _baseTokenURI;
1292     }
1293 
1294     function lauchtool() external payable onlyOwner {
1295 
1296         (bool success, ) = payable(TEAM_ADDRESS).call{
1297             value: address(this).balance
1298         }("");
1299         require(success, "transfer failed.");
1300     }
1301 }