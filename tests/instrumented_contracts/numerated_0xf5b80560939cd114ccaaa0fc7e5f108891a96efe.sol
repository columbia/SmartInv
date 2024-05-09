1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Context.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes calldata) {
25         return msg.data;
26     }
27 }
28 
29 // File: @openzeppelin/contracts/access/Ownable.sol
30 
31 
32 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
33 
34 pragma solidity ^0.8.0;
35 
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
109 
110 // ERC721A Contracts v4.0.0
111 // Creator: Chiru Labs
112 
113 pragma solidity ^0.8.4;
114 
115 /**
116  * @dev Interface of an ERC721A compliant contract.
117  */
118 interface IERC721A {
119     /**
120      * The caller must own the token or be an approved operator.
121      */
122     error ApprovalCallerNotOwnerNorApproved();
123 
124     /**
125      * The token does not exist.
126      */
127     error ApprovalQueryForNonexistentToken();
128 
129     /**
130      * The caller cannot approve to their own address.
131      */
132     error ApproveToCaller();
133 
134     /**
135      * The caller cannot approve to the current owner.
136      */
137     error ApprovalToCurrentOwner();
138 
139     /**
140      * Cannot query the balance for the zero address.
141      */
142     error BalanceQueryForZeroAddress();
143 
144     /**
145      * Cannot mint to the zero address.
146      */
147     error MintToZeroAddress();
148 
149     /**
150      * The quantity of tokens minted must be more than zero.
151      */
152     error MintZeroQuantity();
153 
154     /**
155      * The token does not exist.
156      */
157     error OwnerQueryForNonexistentToken();
158 
159     /**
160      * The caller must own the token or be an approved operator.
161      */
162     error TransferCallerNotOwnerNorApproved();
163 
164     /**
165      * The token must be owned by `from`.
166      */
167     error TransferFromIncorrectOwner();
168 
169     /**
170      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
171      */
172     error TransferToNonERC721ReceiverImplementer();
173 
174     /**
175      * Cannot transfer to the zero address.
176      */
177     error TransferToZeroAddress();
178 
179     /**
180      * The token does not exist.
181      */
182     error URIQueryForNonexistentToken();
183 
184     struct TokenOwnership {
185         // The address of the owner.
186         address addr;
187         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
188         uint64 startTimestamp;
189         // Whether the token has been burned.
190         bool burned;
191     }
192 
193     /**
194      * @dev Returns the total amount of tokens stored by the contract.
195      *
196      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
197      */
198     function totalSupply() external view returns (uint256);
199 
200     // ==============================
201     //            IERC165
202     // ==============================
203 
204     /**
205      * @dev Returns true if this contract implements the interface defined by
206      * `interfaceId`. See the corresponding
207      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
208      * to learn more about how these ids are created.
209      *
210      * This function call must use less than 30 000 gas.
211      */
212     function supportsInterface(bytes4 interfaceId) external view returns (bool);
213 
214     // ==============================
215     //            IERC721
216     // ==============================
217 
218     /**
219      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
220      */
221     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
222 
223     /**
224      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
225      */
226     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
227 
228     /**
229      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
230      */
231     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
232 
233     /**
234      * @dev Returns the number of tokens in ``owner``'s account.
235      */
236     function balanceOf(address owner) external view returns (uint256 balance);
237 
238     /**
239      * @dev Returns the owner of the `tokenId` token.
240      *
241      * Requirements:
242      *
243      * - `tokenId` must exist.
244      */
245     function ownerOf(uint256 tokenId) external view returns (address owner);
246 
247     /**
248      * @dev Safely transfers `tokenId` token from `from` to `to`.
249      *
250      * Requirements:
251      *
252      * - `from` cannot be the zero address.
253      * - `to` cannot be the zero address.
254      * - `tokenId` token must exist and be owned by `from`.
255      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
256      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
257      *
258      * Emits a {Transfer} event.
259      */
260     function safeTransferFrom(
261         address from,
262         address to,
263         uint256 tokenId,
264         bytes calldata data
265     ) external;
266 
267     /**
268      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
269      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
270      *
271      * Requirements:
272      *
273      * - `from` cannot be the zero address.
274      * - `to` cannot be the zero address.
275      * - `tokenId` token must exist and be owned by `from`.
276      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
277      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
278      *
279      * Emits a {Transfer} event.
280      */
281     function safeTransferFrom(
282         address from,
283         address to,
284         uint256 tokenId
285     ) external;
286 
287     /**
288      * @dev Transfers `tokenId` token from `from` to `to`.
289      *
290      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
291      *
292      * Requirements:
293      *
294      * - `from` cannot be the zero address.
295      * - `to` cannot be the zero address.
296      * - `tokenId` token must be owned by `from`.
297      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
298      *
299      * Emits a {Transfer} event.
300      */
301     function transferFrom(
302         address from,
303         address to,
304         uint256 tokenId
305     ) external;
306 
307     /**
308      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
309      * The approval is cleared when the token is transferred.
310      *
311      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
312      *
313      * Requirements:
314      *
315      * - The caller must own the token or be an approved operator.
316      * - `tokenId` must exist.
317      *
318      * Emits an {Approval} event.
319      */
320     function approve(address to, uint256 tokenId) external;
321 
322     /**
323      * @dev Approve or remove `operator` as an operator for the caller.
324      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
325      *
326      * Requirements:
327      *
328      * - The `operator` cannot be the caller.
329      *
330      * Emits an {ApprovalForAll} event.
331      */
332     function setApprovalForAll(address operator, bool _approved) external;
333 
334     /**
335      * @dev Returns the account approved for `tokenId` token.
336      *
337      * Requirements:
338      *
339      * - `tokenId` must exist.
340      */
341     function getApproved(uint256 tokenId) external view returns (address operator);
342 
343     /**
344      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
345      *
346      * See {setApprovalForAll}
347      */
348     function isApprovedForAll(address owner, address operator) external view returns (bool);
349 
350     // ==============================
351     //        IERC721Metadata
352     // ==============================
353 
354     /**
355      * @dev Returns the token collection name.
356      */
357     function name() external view returns (string memory);
358 
359     /**
360      * @dev Returns the token collection symbol.
361      */
362     function symbol() external view returns (string memory);
363 
364     /**
365      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
366      */
367     function tokenURI(uint256 tokenId) external view returns (string memory);
368 }
369 
370 // File: erc721a/contracts/ERC721A.sol
371 
372 
373 // ERC721A Contracts v4.0.0
374 // Creator: Chiru Labs
375 
376 pragma solidity ^0.8.4;
377 
378 
379 /**
380  * @dev ERC721 token receiver interface.
381  */
382 interface ERC721A__IERC721Receiver {
383     function onERC721Received(
384         address operator,
385         address from,
386         uint256 tokenId,
387         bytes calldata data
388     ) external returns (bytes4);
389 }
390 
391 /**
392  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
393  * the Metadata extension. Built to optimize for lower gas during batch mints.
394  *
395  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
396  *
397  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
398  *
399  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
400  */
401 contract ERC721A is IERC721A {
402     // Mask of an entry in packed address data.
403     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
404 
405     // The bit position of `numberMinted` in packed address data.
406     uint256 private constant BITPOS_NUMBER_MINTED = 64;
407 
408     // The bit position of `numberBurned` in packed address data.
409     uint256 private constant BITPOS_NUMBER_BURNED = 128;
410 
411     // The bit position of `aux` in packed address data.
412     uint256 private constant BITPOS_AUX = 192;
413 
414     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
415     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
416 
417     // The bit position of `startTimestamp` in packed ownership.
418     uint256 private constant BITPOS_START_TIMESTAMP = 160;
419 
420     // The bit mask of the `burned` bit in packed ownership.
421     uint256 private constant BITMASK_BURNED = 1 << 224;
422     
423     // The bit position of the `nextInitialized` bit in packed ownership.
424     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
425 
426     // The bit mask of the `nextInitialized` bit in packed ownership.
427     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
428 
429     // The tokenId of the next token to be minted.
430     uint256 private _currentIndex;
431 
432     // The number of tokens burned.
433     uint256 private _burnCounter;
434 
435     // Token name
436     string private _name;
437 
438     // Token symbol
439     string private _symbol;
440 
441     // Mapping from token ID to ownership details
442     // An empty struct value does not necessarily mean the token is unowned.
443     // See `_packedOwnershipOf` implementation for details.
444     //
445     // Bits Layout:
446     // - [0..159]   `addr`
447     // - [160..223] `startTimestamp`
448     // - [224]      `burned`
449     // - [225]      `nextInitialized`
450     mapping(uint256 => uint256) private _packedOwnerships;
451 
452     // Mapping owner address to address data.
453     //
454     // Bits Layout:
455     // - [0..63]    `balance`
456     // - [64..127]  `numberMinted`
457     // - [128..191] `numberBurned`
458     // - [192..255] `aux`
459     mapping(address => uint256) private _packedAddressData;
460 
461     // Mapping from token ID to approved address.
462     mapping(uint256 => address) private _tokenApprovals;
463 
464     // Mapping from owner to operator approvals
465     mapping(address => mapping(address => bool)) private _operatorApprovals;
466 
467     constructor(string memory name_, string memory symbol_) {
468         _name = name_;
469         _symbol = symbol_;
470         _currentIndex = _startTokenId();
471     }
472 
473     /**
474      * @dev Returns the starting token ID. 
475      * To change the starting token ID, please override this function.
476      */
477     function _startTokenId() internal view virtual returns (uint256) {
478         return 0;
479     }
480 
481     /**
482      * @dev Returns the next token ID to be minted.
483      */
484     function _nextTokenId() internal view returns (uint256) {
485         return _currentIndex;
486     }
487 
488     /**
489      * @dev Returns the total number of tokens in existence.
490      * Burned tokens will reduce the count. 
491      * To get the total number of tokens minted, please see `_totalMinted`.
492      */
493     function totalSupply() public view override returns (uint256) {
494         // Counter underflow is impossible as _burnCounter cannot be incremented
495         // more than `_currentIndex - _startTokenId()` times.
496         unchecked {
497             return _currentIndex - _burnCounter - _startTokenId();
498         }
499     }
500 
501     /**
502      * @dev Returns the total amount of tokens minted in the contract.
503      */
504     function _totalMinted() internal view returns (uint256) {
505         // Counter underflow is impossible as _currentIndex does not decrement,
506         // and it is initialized to `_startTokenId()`
507         unchecked {
508             return _currentIndex - _startTokenId();
509         }
510     }
511 
512     /**
513      * @dev Returns the total number of tokens burned.
514      */
515     function _totalBurned() internal view returns (uint256) {
516         return _burnCounter;
517     }
518 
519     /**
520      * @dev See {IERC165-supportsInterface}.
521      */
522     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
523         // The interface IDs are constants representing the first 4 bytes of the XOR of
524         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
525         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
526         return
527             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
528             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
529             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
530     }
531 
532     /**
533      * @dev See {IERC721-balanceOf}.
534      */
535     function balanceOf(address owner) public view override returns (uint256) {
536         if (owner == address(0)) revert BalanceQueryForZeroAddress();
537         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
538     }
539 
540     /**
541      * Returns the number of tokens minted by `owner`.
542      */
543     function _numberMinted(address owner) internal view returns (uint256) {
544         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
545     }
546 
547     /**
548      * Returns the number of tokens burned by or on behalf of `owner`.
549      */
550     function _numberBurned(address owner) internal view returns (uint256) {
551         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
552     }
553 
554     /**
555      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
556      */
557     function _getAux(address owner) internal view returns (uint64) {
558         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
559     }
560 
561     /**
562      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
563      * If there are multiple variables, please pack them into a uint64.
564      */
565     function _setAux(address owner, uint64 aux) internal {
566         uint256 packed = _packedAddressData[owner];
567         uint256 auxCasted;
568         assembly { // Cast aux without masking.
569             auxCasted := aux
570         }
571         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
572         _packedAddressData[owner] = packed;
573     }
574 
575     /**
576      * Returns the packed ownership data of `tokenId`.
577      */
578     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
579         uint256 curr = tokenId;
580 
581         unchecked {
582             if (_startTokenId() <= curr)
583                 if (curr < _currentIndex) {
584                     uint256 packed = _packedOwnerships[curr];
585                     // If not burned.
586                     if (packed & BITMASK_BURNED == 0) {
587                         // Invariant:
588                         // There will always be an ownership that has an address and is not burned
589                         // before an ownership that does not have an address and is not burned.
590                         // Hence, curr will not underflow.
591                         //
592                         // We can directly compare the packed value.
593                         // If the address is zero, packed is zero.
594                         while (packed == 0) {
595                             packed = _packedOwnerships[--curr];
596                         }
597                         return packed;
598                     }
599                 }
600         }
601         revert OwnerQueryForNonexistentToken();
602     }
603 
604     /**
605      * Returns the unpacked `TokenOwnership` struct from `packed`.
606      */
607     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
608         ownership.addr = address(uint160(packed));
609         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
610         ownership.burned = packed & BITMASK_BURNED != 0;
611     }
612 
613     /**
614      * Returns the unpacked `TokenOwnership` struct at `index`.
615      */
616     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
617         return _unpackedOwnership(_packedOwnerships[index]);
618     }
619 
620     /**
621      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
622      */
623     function _initializeOwnershipAt(uint256 index) internal {
624         if (_packedOwnerships[index] == 0) {
625             _packedOwnerships[index] = _packedOwnershipOf(index);
626         }
627     }
628 
629     /**
630      * Gas spent here starts off proportional to the maximum mint batch size.
631      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
632      */
633     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
634         return _unpackedOwnership(_packedOwnershipOf(tokenId));
635     }
636 
637     /**
638      * @dev See {IERC721-ownerOf}.
639      */
640     function ownerOf(uint256 tokenId) public view override returns (address) {
641         return address(uint160(_packedOwnershipOf(tokenId)));
642     }
643 
644     /**
645      * @dev See {IERC721Metadata-name}.
646      */
647     function name() public view virtual override returns (string memory) {
648         return _name;
649     }
650 
651     /**
652      * @dev See {IERC721Metadata-symbol}.
653      */
654     function symbol() public view virtual override returns (string memory) {
655         return _symbol;
656     }
657 
658     /**
659      * @dev See {IERC721Metadata-tokenURI}.
660      */
661     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
662         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
663 
664         string memory baseURI = _baseURI();
665         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
666     }
667 
668     /**
669      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
670      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
671      * by default, can be overriden in child contracts.
672      */
673     function _baseURI() internal view virtual returns (string memory) {
674         return '';
675     }
676 
677     /**
678      * @dev Casts the address to uint256 without masking.
679      */
680     function _addressToUint256(address value) private pure returns (uint256 result) {
681         assembly {
682             result := value
683         }
684     }
685 
686     /**
687      * @dev Casts the boolean to uint256 without branching.
688      */
689     function _boolToUint256(bool value) private pure returns (uint256 result) {
690         assembly {
691             result := value
692         }
693     }
694 
695     /**
696      * @dev See {IERC721-approve}.
697      */
698     function approve(address to, uint256 tokenId) public override {
699         address owner = address(uint160(_packedOwnershipOf(tokenId)));
700         if (to == owner) revert ApprovalToCurrentOwner();
701 
702         if (_msgSenderERC721A() != owner)
703             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
704                 revert ApprovalCallerNotOwnerNorApproved();
705             }
706 
707         _tokenApprovals[tokenId] = to;
708         emit Approval(owner, to, tokenId);
709     }
710 
711     /**
712      * @dev See {IERC721-getApproved}.
713      */
714     function getApproved(uint256 tokenId) public view override returns (address) {
715         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
716 
717         return _tokenApprovals[tokenId];
718     }
719 
720     /**
721      * @dev See {IERC721-setApprovalForAll}.
722      */
723     function setApprovalForAll(address operator, bool approved) public virtual override {
724         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
725 
726         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
727         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
728     }
729 
730     /**
731      * @dev See {IERC721-isApprovedForAll}.
732      */
733     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
734         return _operatorApprovals[owner][operator];
735     }
736 
737     /**
738      * @dev See {IERC721-transferFrom}.
739      */
740     function transferFrom(
741         address from,
742         address to,
743         uint256 tokenId
744     ) public virtual override {
745         _transfer(from, to, tokenId);
746     }
747 
748     /**
749      * @dev See {IERC721-safeTransferFrom}.
750      */
751     function safeTransferFrom(
752         address from,
753         address to,
754         uint256 tokenId
755     ) public virtual override {
756         safeTransferFrom(from, to, tokenId, '');
757     }
758 
759     /**
760      * @dev See {IERC721-safeTransferFrom}.
761      */
762     function safeTransferFrom(
763         address from,
764         address to,
765         uint256 tokenId,
766         bytes memory _data
767     ) public virtual override {
768         _transfer(from, to, tokenId);
769         if (to.code.length != 0)
770             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
771                 revert TransferToNonERC721ReceiverImplementer();
772             }
773     }
774 
775     /**
776      * @dev Returns whether `tokenId` exists.
777      *
778      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
779      *
780      * Tokens start existing when they are minted (`_mint`),
781      */
782     function _exists(uint256 tokenId) internal view returns (bool) {
783         return
784             _startTokenId() <= tokenId &&
785             tokenId < _currentIndex && // If within bounds,
786             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
787     }
788 
789     /**
790      * @dev Equivalent to `_safeMint(to, quantity, '')`.
791      */
792     function _safeMint(address to, uint256 quantity) internal {
793         _safeMint(to, quantity, '');
794     }
795 
796     /**
797      * @dev Safely mints `quantity` tokens and transfers them to `to`.
798      *
799      * Requirements:
800      *
801      * - If `to` refers to a smart contract, it must implement
802      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
803      * - `quantity` must be greater than 0.
804      *
805      * Emits a {Transfer} event.
806      */
807     function _safeMint(
808         address to,
809         uint256 quantity,
810         bytes memory _data
811     ) internal {
812         uint256 startTokenId = _currentIndex;
813         if (to == address(0)) revert MintToZeroAddress();
814         if (quantity == 0) revert MintZeroQuantity();
815 
816         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
817 
818         // Overflows are incredibly unrealistic.
819         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
820         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
821         unchecked {
822             // Updates:
823             // - `balance += quantity`.
824             // - `numberMinted += quantity`.
825             //
826             // We can directly add to the balance and number minted.
827             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
828 
829             // Updates:
830             // - `address` to the owner.
831             // - `startTimestamp` to the timestamp of minting.
832             // - `burned` to `false`.
833             // - `nextInitialized` to `quantity == 1`.
834             _packedOwnerships[startTokenId] =
835                 _addressToUint256(to) |
836                 (block.timestamp << BITPOS_START_TIMESTAMP) |
837                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
838 
839             uint256 updatedIndex = startTokenId;
840             uint256 end = updatedIndex + quantity;
841 
842             if (to.code.length != 0) {
843                 do {
844                     emit Transfer(address(0), to, updatedIndex);
845                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
846                         revert TransferToNonERC721ReceiverImplementer();
847                     }
848                 } while (updatedIndex < end);
849                 // Reentrancy protection
850                 if (_currentIndex != startTokenId) revert();
851             } else {
852                 do {
853                     emit Transfer(address(0), to, updatedIndex++);
854                 } while (updatedIndex < end);
855             }
856             _currentIndex = updatedIndex;
857         }
858         _afterTokenTransfers(address(0), to, startTokenId, quantity);
859     }
860 
861     /**
862      * @dev Mints `quantity` tokens and transfers them to `to`.
863      *
864      * Requirements:
865      *
866      * - `to` cannot be the zero address.
867      * - `quantity` must be greater than 0.
868      *
869      * Emits a {Transfer} event.
870      */
871     function _mint(address to, uint256 quantity) internal {
872         uint256 startTokenId = _currentIndex;
873         if (to == address(0)) revert MintToZeroAddress();
874         if (quantity == 0) revert MintZeroQuantity();
875 
876         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
877 
878         // Overflows are incredibly unrealistic.
879         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
880         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
881         unchecked {
882             // Updates:
883             // - `balance += quantity`.
884             // - `numberMinted += quantity`.
885             //
886             // We can directly add to the balance and number minted.
887             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
888 
889             // Updates:
890             // - `address` to the owner.
891             // - `startTimestamp` to the timestamp of minting.
892             // - `burned` to `false`.
893             // - `nextInitialized` to `quantity == 1`.
894             _packedOwnerships[startTokenId] =
895                 _addressToUint256(to) |
896                 (block.timestamp << BITPOS_START_TIMESTAMP) |
897                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
898 
899             uint256 updatedIndex = startTokenId;
900             uint256 end = updatedIndex + quantity;
901 
902             do {
903                 emit Transfer(address(0), to, updatedIndex++);
904             } while (updatedIndex < end);
905 
906             _currentIndex = updatedIndex;
907         }
908         _afterTokenTransfers(address(0), to, startTokenId, quantity);
909     }
910 
911     /**
912      * @dev Transfers `tokenId` from `from` to `to`.
913      *
914      * Requirements:
915      *
916      * - `to` cannot be the zero address.
917      * - `tokenId` token must be owned by `from`.
918      *
919      * Emits a {Transfer} event.
920      */
921     function _transfer(
922         address from,
923         address to,
924         uint256 tokenId
925     ) private {
926         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
927 
928         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
929 
930         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
931             isApprovedForAll(from, _msgSenderERC721A()) ||
932             getApproved(tokenId) == _msgSenderERC721A());
933 
934         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
935         if (to == address(0)) revert TransferToZeroAddress();
936 
937         _beforeTokenTransfers(from, to, tokenId, 1);
938 
939         // Clear approvals from the previous owner.
940         delete _tokenApprovals[tokenId];
941 
942         // Underflow of the sender's balance is impossible because we check for
943         // ownership above and the recipient's balance can't realistically overflow.
944         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
945         unchecked {
946             // We can directly increment and decrement the balances.
947             --_packedAddressData[from]; // Updates: `balance -= 1`.
948             ++_packedAddressData[to]; // Updates: `balance += 1`.
949 
950             // Updates:
951             // - `address` to the next owner.
952             // - `startTimestamp` to the timestamp of transfering.
953             // - `burned` to `false`.
954             // - `nextInitialized` to `true`.
955             _packedOwnerships[tokenId] =
956                 _addressToUint256(to) |
957                 (block.timestamp << BITPOS_START_TIMESTAMP) |
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
974         emit Transfer(from, to, tokenId);
975         _afterTokenTransfers(from, to, tokenId, 1);
976     }
977 
978     /**
979      * @dev Equivalent to `_burn(tokenId, false)`.
980      */
981     function _burn(uint256 tokenId) internal virtual {
982         _burn(tokenId, false);
983     }
984 
985     /**
986      * @dev Destroys `tokenId`.
987      * The approval is cleared when the token is burned.
988      *
989      * Requirements:
990      *
991      * - `tokenId` must exist.
992      *
993      * Emits a {Transfer} event.
994      */
995     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
996         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
997 
998         address from = address(uint160(prevOwnershipPacked));
999 
1000         if (approvalCheck) {
1001             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1002                 isApprovedForAll(from, _msgSenderERC721A()) ||
1003                 getApproved(tokenId) == _msgSenderERC721A());
1004 
1005             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1006         }
1007 
1008         _beforeTokenTransfers(from, address(0), tokenId, 1);
1009 
1010         // Clear approvals from the previous owner.
1011         delete _tokenApprovals[tokenId];
1012 
1013         // Underflow of the sender's balance is impossible because we check for
1014         // ownership above and the recipient's balance can't realistically overflow.
1015         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1016         unchecked {
1017             // Updates:
1018             // - `balance -= 1`.
1019             // - `numberBurned += 1`.
1020             //
1021             // We can directly decrement the balance, and increment the number burned.
1022             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1023             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1024 
1025             // Updates:
1026             // - `address` to the last owner.
1027             // - `startTimestamp` to the timestamp of burning.
1028             // - `burned` to `true`.
1029             // - `nextInitialized` to `true`.
1030             _packedOwnerships[tokenId] =
1031                 _addressToUint256(from) |
1032                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1033                 BITMASK_BURNED | 
1034                 BITMASK_NEXT_INITIALIZED;
1035 
1036             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1037             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1038                 uint256 nextTokenId = tokenId + 1;
1039                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1040                 if (_packedOwnerships[nextTokenId] == 0) {
1041                     // If the next slot is within bounds.
1042                     if (nextTokenId != _currentIndex) {
1043                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1044                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1045                     }
1046                 }
1047             }
1048         }
1049 
1050         emit Transfer(from, address(0), tokenId);
1051         _afterTokenTransfers(from, address(0), tokenId, 1);
1052 
1053         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1054         unchecked {
1055             _burnCounter++;
1056         }
1057     }
1058 
1059     /**
1060      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1061      *
1062      * @param from address representing the previous owner of the given token ID
1063      * @param to target address that will receive the tokens
1064      * @param tokenId uint256 ID of the token to be transferred
1065      * @param _data bytes optional data to send along with the call
1066      * @return bool whether the call correctly returned the expected magic value
1067      */
1068     function _checkContractOnERC721Received(
1069         address from,
1070         address to,
1071         uint256 tokenId,
1072         bytes memory _data
1073     ) private returns (bool) {
1074         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1075             bytes4 retval
1076         ) {
1077             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1078         } catch (bytes memory reason) {
1079             if (reason.length == 0) {
1080                 revert TransferToNonERC721ReceiverImplementer();
1081             } else {
1082                 assembly {
1083                     revert(add(32, reason), mload(reason))
1084                 }
1085             }
1086         }
1087     }
1088 
1089     /**
1090      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1091      * And also called before burning one token.
1092      *
1093      * startTokenId - the first token id to be transferred
1094      * quantity - the amount to be transferred
1095      *
1096      * Calling conditions:
1097      *
1098      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1099      * transferred to `to`.
1100      * - When `from` is zero, `tokenId` will be minted for `to`.
1101      * - When `to` is zero, `tokenId` will be burned by `from`.
1102      * - `from` and `to` are never both zero.
1103      */
1104     function _beforeTokenTransfers(
1105         address from,
1106         address to,
1107         uint256 startTokenId,
1108         uint256 quantity
1109     ) internal virtual {}
1110 
1111     /**
1112      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1113      * minting.
1114      * And also called after one token has been burned.
1115      *
1116      * startTokenId - the first token id to be transferred
1117      * quantity - the amount to be transferred
1118      *
1119      * Calling conditions:
1120      *
1121      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1122      * transferred to `to`.
1123      * - When `from` is zero, `tokenId` has been minted for `to`.
1124      * - When `to` is zero, `tokenId` has been burned by `from`.
1125      * - `from` and `to` are never both zero.
1126      */
1127     function _afterTokenTransfers(
1128         address from,
1129         address to,
1130         uint256 startTokenId,
1131         uint256 quantity
1132     ) internal virtual {}
1133 
1134     /**
1135      * @dev Returns the message sender (defaults to `msg.sender`).
1136      *
1137      * If you are writing GSN compatible contracts, you need to override this function.
1138      */
1139     function _msgSenderERC721A() internal view virtual returns (address) {
1140         return msg.sender;
1141     }
1142 
1143     /**
1144      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1145      */
1146     function _toString(uint256 value) internal pure returns (string memory ptr) {
1147         assembly {
1148             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1149             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1150             // We will need 1 32-byte word to store the length, 
1151             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1152             ptr := add(mload(0x40), 128)
1153             // Update the free memory pointer to allocate.
1154             mstore(0x40, ptr)
1155 
1156             // Cache the end of the memory to calculate the length later.
1157             let end := ptr
1158 
1159             // We write the string from the rightmost digit to the leftmost digit.
1160             // The following is essentially a do-while loop that also handles the zero case.
1161             // Costs a bit more than early returning for the zero case,
1162             // but cheaper in terms of deployment and overall runtime costs.
1163             for { 
1164                 // Initialize and perform the first pass without check.
1165                 let temp := value
1166                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1167                 ptr := sub(ptr, 1)
1168                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1169                 mstore8(ptr, add(48, mod(temp, 10)))
1170                 temp := div(temp, 10)
1171             } temp { 
1172                 // Keep dividing `temp` until zero.
1173                 temp := div(temp, 10)
1174             } { // Body of the for loop.
1175                 ptr := sub(ptr, 1)
1176                 mstore8(ptr, add(48, mod(temp, 10)))
1177             }
1178             
1179             let length := sub(end, ptr)
1180             // Move the pointer 32 bytes leftwards to make room for the length.
1181             ptr := sub(ptr, 32)
1182             // Store the length.
1183             mstore(ptr, length)
1184         }
1185     }
1186 }
1187 
1188 // File: contracts/WindowsXD.sol
1189 
1190 
1191 pragma solidity ^0.8.4;
1192 
1193 
1194 
1195 contract WindowsXD is ERC721A, Ownable {
1196     uint256 public maxPerWallet = 2;
1197     uint256 public maxSupply = 1000;
1198     uint256 public freeSupply = 300;
1199     uint256 public price = 0.003 ether;
1200     bool public isPaused = true;
1201     bool public isPublicSale = false;
1202 
1203     mapping(address => uint8) private whiteList;
1204     mapping(address => uint8) private whiteListMinted;
1205 
1206     string public baseURI = "ipfs://QmWKKo8sBRCTozVq6Ls7VWKZTeAhGjUYgqtpqynGtiBLqA/";
1207 
1208     constructor() ERC721A("WindowsXD", "WXD") {}
1209 
1210     function mintWhitelist(uint8 quantity) external payable {
1211         require(!isPaused, "Sales are off");
1212         require(quantity + _numberMinted(msg.sender) <= maxPerWallet, "Exceeded the wallet limit");
1213         require(totalSupply() + quantity <= maxSupply, "Not enough tokens left");
1214         require(quantity <= whiteList[msg.sender], "Exceeded max available to purchase in WL.");
1215         
1216         //first 'freeSupply' is free, then paid
1217         // require(
1218         //     msg.value >= getPrice(quantity),
1219         //     "Insufficient Fund."
1220         // );
1221         whiteList[msg.sender] -= quantity; //tracking minted
1222         whiteListMinted[msg.sender] += quantity;
1223         _safeMint(msg.sender, quantity);
1224     }
1225 
1226     function mint(uint256 quantity) external payable {
1227         require(!isPaused, "Sales are off");
1228         require(isPublicSale, "Public Sale is not open yet");
1229         
1230         //this way WL can mint again
1231         require(quantity + _numberMinted(msg.sender) - whiteListMinted[msg.sender] <= maxPerWallet, "Exceeded the wallet limit");
1232         
1233         require(totalSupply() + quantity <= maxSupply, "Not enough tokens left");
1234 
1235         //first 'freeSupply' is free, then paid
1236         require(
1237             msg.value >= getPrice(quantity),
1238             "Insufficient Fund."
1239         );
1240 
1241         _safeMint(msg.sender, quantity);
1242     }
1243 
1244     function setFreeAllowList(address[] calldata addresses, uint8 numAllowedToMint) external onlyOwner {
1245         for (uint256 i = 0; i < addresses.length; i++) {
1246             whiteList[addresses[i]] = numAllowedToMint;
1247         }
1248     }
1249 
1250     function getPrice(uint256 _count) internal view returns (uint256) {
1251         
1252         require(_count > 0, "Must be minting at least 1 token.");
1253         
1254         uint256 endingTokenId = _totalMinted() + _count;
1255         // If qty to mint results in a final token ID less than or equal to the cap then
1256         // the entire qty is within free mint.
1257         if(endingTokenId  <= freeSupply) {
1258             return 0;
1259         }
1260         
1261         uint256 outsideIncentiveCount = endingTokenId - freeSupply;
1262 
1263         return 0 + price * outsideIncentiveCount;
1264   }
1265 
1266     function setPause(bool value) external onlyOwner {
1267 		  isPaused = value;
1268 	  }
1269 
1270     function setPublic(bool value) external onlyOwner {
1271 		  isPublicSale = value;
1272 	  }
1273 
1274     // ERC721A overrides
1275     // ERC721A starts counting tokenIds from 0, this contract starts from 1
1276     function _startTokenId() internal pure override returns (uint256) {
1277         return 1;
1278     }
1279 
1280     function withdraw() external onlyOwner {
1281 		uint balance = address(this).balance;
1282 		require(balance > 0, "Nothing to Withdraw");
1283         payable(owner()).transfer(balance);
1284     }
1285 
1286     function withdrawTo(address to) external onlyOwner {
1287 		uint balance = address(this).balance;
1288 		require(balance > 0, "Nothing to Withdraw");
1289         payable(to).transfer(balance);
1290     }
1291 
1292     function setBaseURI(string memory newuri) external onlyOwner {
1293         baseURI = newuri;
1294     }
1295 
1296     function _baseURI() internal view override returns (string memory) {
1297         return baseURI;
1298     }
1299 
1300     function setPrice(uint256 _price) public onlyOwner {
1301         price = _price;
1302     }
1303 
1304     function setMaxPerWalleet(uint256 _maxPerWallet) public onlyOwner {
1305         maxPerWallet = _maxPerWallet;
1306     }
1307 
1308     function setFreeSupply(uint256 _freeSupply) public onlyOwner {
1309         freeSupply = _freeSupply;
1310     }
1311 
1312     function devMint(uint256 quantity) external onlyOwner {
1313         require(totalSupply() + quantity <= maxSupply, "Max supply exceeded!");
1314         _safeMint(msg.sender, quantity);
1315     }
1316 
1317     function cutSupply(uint256 _maxSupply) external onlyOwner {
1318 		require(_maxSupply < maxSupply , "badumm no ruggie scammiee");
1319         maxSupply = _maxSupply;
1320 	}
1321 }