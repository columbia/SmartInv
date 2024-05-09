1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts/access/Ownable.sol
29 
30 
31 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
32 
33 pragma solidity ^0.8.0;
34 
35 
36 /**
37  * @dev Contract module which provides a basic access control mechanism, where
38  * there is an account (an owner) that can be granted exclusive access to
39  * specific functions.
40  *
41  * By default, the owner account will be the one that deploys the contract. This
42  * can later be changed with {transferOwnership}.
43  *
44  * This module is used through inheritance. It will make available the modifier
45  * `onlyOwner`, which can be applied to your functions to restrict their use to
46  * the owner.
47  */
48 abstract contract Ownable is Context {
49     address private _owner;
50 
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53     /**
54      * @dev Initializes the contract setting the deployer as the initial owner.
55      */
56     constructor() {
57         _transferOwnership(_msgSender());
58     }
59 
60     /**
61      * @dev Returns the address of the current owner.
62      */
63     function owner() public view virtual returns (address) {
64         return _owner;
65     }
66 
67     /**
68      * @dev Throws if called by any account other than the owner.
69      */
70     modifier onlyOwner() {
71         require(owner() == _msgSender(), "Ownable: caller is not the owner");
72         _;
73     }
74 
75     /**
76      * @dev Leaves the contract without owner. It will not be possible to call
77      * `onlyOwner` functions anymore. Can only be called by the current owner.
78      *
79      * NOTE: Renouncing ownership will leave the contract without an owner,
80      * thereby removing any functionality that is only available to the owner.
81      */
82     function renounceOwnership() public virtual onlyOwner {
83         _transferOwnership(address(0));
84     }
85 
86     /**
87      * @dev Transfers ownership of the contract to a new account (`newOwner`).
88      * Can only be called by the current owner.
89      */
90     function transferOwnership(address newOwner) public virtual onlyOwner {
91         require(newOwner != address(0), "Ownable: new owner is the zero address");
92         _transferOwnership(newOwner);
93     }
94 
95     /**
96      * @dev Transfers ownership of the contract to a new account (`newOwner`).
97      * Internal function without access restriction.
98      */
99     function _transferOwnership(address newOwner) internal virtual {
100         address oldOwner = _owner;
101         _owner = newOwner;
102         emit OwnershipTransferred(oldOwner, newOwner);
103     }
104 }
105 
106 // File: erc721a/contracts/IERC721A.sol
107 
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
534         if (_addressToUint256(owner) == 0) revert BalanceQueryForZeroAddress();
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
811         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
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
871         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
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
928         address approvedAddress = _tokenApprovals[tokenId];
929 
930         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
931             isApprovedForAll(from, _msgSenderERC721A()) ||
932             approvedAddress == _msgSenderERC721A());
933 
934         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
935         if (_addressToUint256(to) == 0) revert TransferToZeroAddress();
936 
937         _beforeTokenTransfers(from, to, tokenId, 1);
938 
939         // Clear approvals from the previous owner.
940         if (_addressToUint256(approvedAddress) != 0) {
941             delete _tokenApprovals[tokenId];
942         }
943 
944         // Underflow of the sender's balance is impossible because we check for
945         // ownership above and the recipient's balance can't realistically overflow.
946         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
947         unchecked {
948             // We can directly increment and decrement the balances.
949             --_packedAddressData[from]; // Updates: `balance -= 1`.
950             ++_packedAddressData[to]; // Updates: `balance += 1`.
951 
952             // Updates:
953             // - `address` to the next owner.
954             // - `startTimestamp` to the timestamp of transfering.
955             // - `burned` to `false`.
956             // - `nextInitialized` to `true`.
957             _packedOwnerships[tokenId] =
958                 _addressToUint256(to) |
959                 (block.timestamp << BITPOS_START_TIMESTAMP) |
960                 BITMASK_NEXT_INITIALIZED;
961 
962             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
963             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
964                 uint256 nextTokenId = tokenId + 1;
965                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
966                 if (_packedOwnerships[nextTokenId] == 0) {
967                     // If the next slot is within bounds.
968                     if (nextTokenId != _currentIndex) {
969                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
970                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
971                     }
972                 }
973             }
974         }
975 
976         emit Transfer(from, to, tokenId);
977         _afterTokenTransfers(from, to, tokenId, 1);
978     }
979 
980     /**
981      * @dev Equivalent to `_burn(tokenId, false)`.
982      */
983     function _burn(uint256 tokenId) internal virtual {
984         _burn(tokenId, false);
985     }
986 
987     /**
988      * @dev Destroys `tokenId`.
989      * The approval is cleared when the token is burned.
990      *
991      * Requirements:
992      *
993      * - `tokenId` must exist.
994      *
995      * Emits a {Transfer} event.
996      */
997     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
998         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
999 
1000         address from = address(uint160(prevOwnershipPacked));
1001         address approvedAddress = _tokenApprovals[tokenId];
1002 
1003         if (approvalCheck) {
1004             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1005                 isApprovedForAll(from, _msgSenderERC721A()) ||
1006                 approvedAddress == _msgSenderERC721A());
1007 
1008             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1009         }
1010 
1011         _beforeTokenTransfers(from, address(0), tokenId, 1);
1012 
1013         // Clear approvals from the previous owner.
1014         if (_addressToUint256(approvedAddress) != 0) {
1015             delete _tokenApprovals[tokenId];
1016         }
1017 
1018         // Underflow of the sender's balance is impossible because we check for
1019         // ownership above and the recipient's balance can't realistically overflow.
1020         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1021         unchecked {
1022             // Updates:
1023             // - `balance -= 1`.
1024             // - `numberBurned += 1`.
1025             //
1026             // We can directly decrement the balance, and increment the number burned.
1027             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1028             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1029 
1030             // Updates:
1031             // - `address` to the last owner.
1032             // - `startTimestamp` to the timestamp of burning.
1033             // - `burned` to `true`.
1034             // - `nextInitialized` to `true`.
1035             _packedOwnerships[tokenId] =
1036                 _addressToUint256(from) |
1037                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1038                 BITMASK_BURNED |
1039                 BITMASK_NEXT_INITIALIZED;
1040 
1041             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1042             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1043                 uint256 nextTokenId = tokenId + 1;
1044                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1045                 if (_packedOwnerships[nextTokenId] == 0) {
1046                     // If the next slot is within bounds.
1047                     if (nextTokenId != _currentIndex) {
1048                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1049                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1050                     }
1051                 }
1052             }
1053         }
1054 
1055         emit Transfer(from, address(0), tokenId);
1056         _afterTokenTransfers(from, address(0), tokenId, 1);
1057 
1058         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1059         unchecked {
1060             _burnCounter++;
1061         }
1062     }
1063 
1064     /**
1065      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1066      *
1067      * @param from address representing the previous owner of the given token ID
1068      * @param to target address that will receive the tokens
1069      * @param tokenId uint256 ID of the token to be transferred
1070      * @param _data bytes optional data to send along with the call
1071      * @return bool whether the call correctly returned the expected magic value
1072      */
1073     function _checkContractOnERC721Received(
1074         address from,
1075         address to,
1076         uint256 tokenId,
1077         bytes memory _data
1078     ) private returns (bool) {
1079         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1080             bytes4 retval
1081         ) {
1082             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1083         } catch (bytes memory reason) {
1084             if (reason.length == 0) {
1085                 revert TransferToNonERC721ReceiverImplementer();
1086             } else {
1087                 assembly {
1088                     revert(add(32, reason), mload(reason))
1089                 }
1090             }
1091         }
1092     }
1093 
1094     /**
1095      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1096      * And also called before burning one token.
1097      *
1098      * startTokenId - the first token id to be transferred
1099      * quantity - the amount to be transferred
1100      *
1101      * Calling conditions:
1102      *
1103      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1104      * transferred to `to`.
1105      * - When `from` is zero, `tokenId` will be minted for `to`.
1106      * - When `to` is zero, `tokenId` will be burned by `from`.
1107      * - `from` and `to` are never both zero.
1108      */
1109     function _beforeTokenTransfers(
1110         address from,
1111         address to,
1112         uint256 startTokenId,
1113         uint256 quantity
1114     ) internal virtual {}
1115 
1116     /**
1117      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1118      * minting.
1119      * And also called after one token has been burned.
1120      *
1121      * startTokenId - the first token id to be transferred
1122      * quantity - the amount to be transferred
1123      *
1124      * Calling conditions:
1125      *
1126      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1127      * transferred to `to`.
1128      * - When `from` is zero, `tokenId` has been minted for `to`.
1129      * - When `to` is zero, `tokenId` has been burned by `from`.
1130      * - `from` and `to` are never both zero.
1131      */
1132     function _afterTokenTransfers(
1133         address from,
1134         address to,
1135         uint256 startTokenId,
1136         uint256 quantity
1137     ) internal virtual {}
1138 
1139     /**
1140      * @dev Returns the message sender (defaults to `msg.sender`).
1141      *
1142      * If you are writing GSN compatible contracts, you need to override this function.
1143      */
1144     function _msgSenderERC721A() internal view virtual returns (address) {
1145         return msg.sender;
1146     }
1147 
1148     /**
1149      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1150      */
1151     function _toString(uint256 value) internal pure returns (string memory ptr) {
1152         assembly {
1153             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1154             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1155             // We will need 1 32-byte word to store the length,
1156             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1157             ptr := add(mload(0x40), 128)
1158             // Update the free memory pointer to allocate.
1159             mstore(0x40, ptr)
1160 
1161             // Cache the end of the memory to calculate the length later.
1162             let end := ptr
1163 
1164             // We write the string from the rightmost digit to the leftmost digit.
1165             // The following is essentially a do-while loop that also handles the zero case.
1166             // Costs a bit more than early returning for the zero case,
1167             // but cheaper in terms of deployment and overall runtime costs.
1168             for {
1169                 // Initialize and perform the first pass without check.
1170                 let temp := value
1171                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1172                 ptr := sub(ptr, 1)
1173                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1174                 mstore8(ptr, add(48, mod(temp, 10)))
1175                 temp := div(temp, 10)
1176             } temp {
1177                 // Keep dividing `temp` until zero.
1178                 temp := div(temp, 10)
1179             } { // Body of the for loop.
1180                 ptr := sub(ptr, 1)
1181                 mstore8(ptr, add(48, mod(temp, 10)))
1182             }
1183 
1184             let length := sub(end, ptr)
1185             // Move the pointer 32 bytes leftwards to make room for the length.
1186             ptr := sub(ptr, 32)
1187             // Store the length.
1188             mstore(ptr, length)
1189         }
1190     }
1191 }
1192 // File: contracts/WAGAI.sol
1193 
1194 
1195 pragma solidity ^0.8.4;
1196 
1197 
1198 
1199 contract WAGAI is ERC721A, Ownable {
1200     string public baseURI;
1201     uint256 public maxAI = 6666;
1202     uint256 public maxQty = 1;
1203 
1204     constructor(string memory _initBaseURI) ERC721A("We Are All Going to AI", "WAGAI") {
1205         setBaseURI(_initBaseURI);
1206     }
1207 
1208     function _baseURI() internal view override returns (string memory) {
1209         return baseURI;
1210     }
1211 
1212     function mint(uint256 qty) public {
1213         uint256 totalAI = totalSupply();
1214         require(totalAI + qty <= maxAI, "Error: Max supply reached");
1215         require(balanceOf(msg.sender) + qty <= maxQty, "Error: Max qty per wallet reached");
1216         _safeMint(msg.sender, qty);
1217     }
1218 
1219     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1220         baseURI = _newBaseURI;
1221     }
1222 
1223     function setMaxQty(uint256 _newmaxQty) public onlyOwner {
1224         maxQty = _newmaxQty;
1225     }
1226 }