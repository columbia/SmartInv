1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
3 //
4 //  ▄▀▀▀▀▄   ▄▀▀▀█▀▀▄  ▄▀▀▄▀▀▀▄ 
5 // █        █    █  ▐ █   █   █ 
6 // █    ▀▄▄ ▐   █     ▐  █▀▀█▀  
7 // █     █ █   █       ▄▀    █  
8 // ▐▀▄▄▄▄▀ ▐ ▄▀       █     █   
9 // ▐        █         ▐     ▐   
10 //          ▐                   
11 // @goblinrejects 2022
12 
13 pragma solidity ^0.8.0;
14 
15 /**
16  * @dev Provides information about the current execution context, including the
17  * sender of the transaction and its data. While these are generally available
18  * via msg.sender and msg.data, they should not be accessed in such a direct
19  * manner, since when dealing with meta-transactions the account sending and
20  * paying for execution may not be the actual sender (as far as an application
21  * is concerned).
22  *
23  * This contract is only required for intermediate, library-like contracts.
24  */
25 abstract contract Context {
26     function _msgSender() internal view virtual returns (address) {
27         return msg.sender;
28     }
29 
30     function _msgData() internal view virtual returns (bytes calldata) {
31         return msg.data;
32     }
33 }
34 
35 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
36 
37 pragma solidity ^0.8.0;
38 
39 /**
40  * @dev Contract module which provides a basic access control mechanism, where
41  * there is an account (an owner) that can be granted exclusive access to
42  * specific functions.
43  *
44  * By default, the owner account will be the one that deploys the contract. This
45  * can later be changed with {transferOwnership}.
46  *
47  * This module is used through inheritance. It will make available the modifier
48  * `onlyOwner`, which can be applied to your functions to restrict their use to
49  * the owner.
50  */
51 abstract contract Ownable is Context {
52     address private _owner;
53 
54     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
55 
56     /**
57      * @dev Initializes the contract setting the deployer as the initial owner.
58      */
59     constructor() {
60         _transferOwnership(_msgSender());
61     }
62 
63     /**
64      * @dev Returns the address of the current owner.
65      */
66     function owner() public view virtual returns (address) {
67         return _owner;
68     }
69 
70     /**
71      * @dev Throws if called by any account other than the owner.
72      */
73     modifier onlyOwner() {
74         require(owner() == _msgSender(), "Ownable: caller is not the owner");
75         _;
76     }
77 
78     /**
79      * @dev Leaves the contract without owner. It will not be possible to call
80      * `onlyOwner` functions anymore. Can only be called by the current owner.
81      *
82      * NOTE: Renouncing ownership will leave the contract without an owner,
83      * thereby removing any functionality that is only available to the owner.
84      */
85     function renounceOwnership() public virtual onlyOwner {
86         _transferOwnership(address(0));
87     }
88 
89     /**
90      * @dev Transfers ownership of the contract to a new account (`newOwner`).
91      * Can only be called by the current owner.
92      */
93     function transferOwnership(address newOwner) public virtual onlyOwner {
94         require(newOwner != address(0), "Ownable: new owner is the zero address");
95         _transferOwnership(newOwner);
96     }
97 
98     /**
99      * @dev Transfers ownership of the contract to a new account (`newOwner`).
100      * Internal function without access restriction.
101      */
102     function _transferOwnership(address newOwner) internal virtual {
103         address oldOwner = _owner;
104         _owner = newOwner;
105         emit OwnershipTransferred(oldOwner, newOwner);
106     }
107 }
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
134      * Cannot query the balance for the zero address.
135      */
136     error BalanceQueryForZeroAddress();
137 
138     /**
139      * Cannot mint to the zero address.
140      */
141     error MintToZeroAddress();
142 
143     /**
144      * The quantity of tokens minted must be more than zero.
145      */
146     error MintZeroQuantity();
147 
148     /**
149      * The token does not exist.
150      */
151     error OwnerQueryForNonexistentToken();
152 
153     /**
154      * The caller must own the token or be an approved operator.
155      */
156     error TransferCallerNotOwnerNorApproved();
157 
158     /**
159      * The token must be owned by `from`.
160      */
161     error TransferFromIncorrectOwner();
162 
163     /**
164      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
165      */
166     error TransferToNonERC721ReceiverImplementer();
167 
168     /**
169      * Cannot transfer to the zero address.
170      */
171     error TransferToZeroAddress();
172 
173     /**
174      * The token does not exist.
175      */
176     error URIQueryForNonexistentToken();
177 
178     struct TokenOwnership {
179         // The address of the owner.
180         address addr;
181         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
182         uint64 startTimestamp;
183         // Whether the token has been burned.
184         bool burned;
185     }
186 
187     /**
188      * @dev Returns the total amount of tokens stored by the contract.
189      *
190      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
191      */
192     function totalSupply() external view returns (uint256);
193 
194     // ==============================
195     //            IERC165
196     // ==============================
197 
198     /**
199      * @dev Returns true if this contract implements the interface defined by
200      * `interfaceId`. See the corresponding
201      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
202      * to learn more about how these ids are created.
203      *
204      * This function call must use less than 30 000 gas.
205      */
206     function supportsInterface(bytes4 interfaceId) external view returns (bool);
207 
208     // ==============================
209     //            IERC721
210     // ==============================
211 
212     /**
213      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
214      */
215     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
216 
217     /**
218      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
219      */
220     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
221 
222     /**
223      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
224      */
225     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
226 
227     /**
228      * @dev Returns the number of tokens in ``owner``'s account.
229      */
230     function balanceOf(address owner) external view returns (uint256 balance);
231 
232     /**
233      * @dev Returns the owner of the `tokenId` token.
234      *
235      * Requirements:
236      *
237      * - `tokenId` must exist.
238      */
239     function ownerOf(uint256 tokenId) external view returns (address owner);
240 
241     /**
242      * @dev Safely transfers `tokenId` token from `from` to `to`.
243      *
244      * Requirements:
245      *
246      * - `from` cannot be the zero address.
247      * - `to` cannot be the zero address.
248      * - `tokenId` token must exist and be owned by `from`.
249      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
250      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
251      *
252      * Emits a {Transfer} event.
253      */
254     function safeTransferFrom(
255         address from,
256         address to,
257         uint256 tokenId,
258         bytes calldata data
259     ) external;
260 
261     /**
262      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
263      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
264      *
265      * Requirements:
266      *
267      * - `from` cannot be the zero address.
268      * - `to` cannot be the zero address.
269      * - `tokenId` token must exist and be owned by `from`.
270      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
271      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
272      *
273      * Emits a {Transfer} event.
274      */
275     function safeTransferFrom(
276         address from,
277         address to,
278         uint256 tokenId
279     ) external;
280 
281     /**
282      * @dev Transfers `tokenId` token from `from` to `to`.
283      *
284      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
285      *
286      * Requirements:
287      *
288      * - `from` cannot be the zero address.
289      * - `to` cannot be the zero address.
290      * - `tokenId` token must be owned by `from`.
291      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
292      *
293      * Emits a {Transfer} event.
294      */
295     function transferFrom(
296         address from,
297         address to,
298         uint256 tokenId
299     ) external;
300 
301     /**
302      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
303      * The approval is cleared when the token is transferred.
304      *
305      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
306      *
307      * Requirements:
308      *
309      * - The caller must own the token or be an approved operator.
310      * - `tokenId` must exist.
311      *
312      * Emits an {Approval} event.
313      */
314     function approve(address to, uint256 tokenId) external;
315 
316     /**
317      * @dev Approve or remove `operator` as an operator for the caller.
318      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
319      *
320      * Requirements:
321      *
322      * - The `operator` cannot be the caller.
323      *
324      * Emits an {ApprovalForAll} event.
325      */
326     function setApprovalForAll(address operator, bool _approved) external;
327 
328     /**
329      * @dev Returns the account approved for `tokenId` token.
330      *
331      * Requirements:
332      *
333      * - `tokenId` must exist.
334      */
335     function getApproved(uint256 tokenId) external view returns (address operator);
336 
337     /**
338      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
339      *
340      * See {setApprovalForAll}
341      */
342     function isApprovedForAll(address owner, address operator) external view returns (bool);
343 
344     // ==============================
345     //        IERC721Metadata
346     // ==============================
347 
348     /**
349      * @dev Returns the token collection name.
350      */
351     function name() external view returns (string memory);
352 
353     /**
354      * @dev Returns the token collection symbol.
355      */
356     function symbol() external view returns (string memory);
357 
358     /**
359      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
360      */
361     function tokenURI(uint256 tokenId) external view returns (string memory);
362 }
363 
364 // ERC721A Contracts v4.0.0
365 // Creator: Chiru Labs
366 
367 pragma solidity ^0.8.4;
368 
369 /**
370  * @dev ERC721 token receiver interface.
371  */
372 interface ERC721A__IERC721Receiver {
373     function onERC721Received(
374         address operator,
375         address from,
376         uint256 tokenId,
377         bytes calldata data
378     ) external returns (bytes4);
379 }
380 
381 /**
382  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
383  * the Metadata extension. Built to optimize for lower gas during batch mints.
384  *
385  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
386  *
387  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
388  *
389  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
390  */
391 contract ERC721A is IERC721A {
392     // Mask of an entry in packed address data.
393     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
394 
395     // The bit position of `numberMinted` in packed address data.
396     uint256 private constant BITPOS_NUMBER_MINTED = 64;
397 
398     // The bit position of `numberBurned` in packed address data.
399     uint256 private constant BITPOS_NUMBER_BURNED = 128;
400 
401     // The bit position of `aux` in packed address data.
402     uint256 private constant BITPOS_AUX = 192;
403 
404     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
405     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
406 
407     // The bit position of `startTimestamp` in packed ownership.
408     uint256 private constant BITPOS_START_TIMESTAMP = 160;
409 
410     // The bit mask of the `burned` bit in packed ownership.
411     uint256 private constant BITMASK_BURNED = 1 << 224;
412 
413     // The bit position of the `nextInitialized` bit in packed ownership.
414     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
415 
416     // The bit mask of the `nextInitialized` bit in packed ownership.
417     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
418 
419     // The tokenId of the next token to be minted.
420     uint256 private _currentIndex;
421 
422     // The number of tokens burned.
423     uint256 private _burnCounter;
424 
425     // Token name
426     string private _name;
427 
428     // Token symbol
429     string private _symbol;
430 
431     // Mapping from token ID to ownership details
432     // An empty struct value does not necessarily mean the token is unowned.
433     // See `_packedOwnershipOf` implementation for details.
434     //
435     // Bits Layout:
436     // - [0..159]   `addr`
437     // - [160..223] `startTimestamp`
438     // - [224]      `burned`
439     // - [225]      `nextInitialized`
440     mapping(uint256 => uint256) private _packedOwnerships;
441 
442     // Mapping owner address to address data.
443     //
444     // Bits Layout:
445     // - [0..63]    `balance`
446     // - [64..127]  `numberMinted`
447     // - [128..191] `numberBurned`
448     // - [192..255] `aux`
449     mapping(address => uint256) private _packedAddressData;
450 
451     // Mapping from token ID to approved address.
452     mapping(uint256 => address) private _tokenApprovals;
453 
454     // Mapping from owner to operator approvals
455     mapping(address => mapping(address => bool)) private _operatorApprovals;
456 
457     constructor(string memory name_, string memory symbol_) {
458         _name = name_;
459         _symbol = symbol_;
460         _currentIndex = _startTokenId();
461     }
462 
463     /**
464      * @dev Returns the starting token ID.
465      * To change the starting token ID, please override this function.
466      */
467     function _startTokenId() internal view virtual returns (uint256) {
468         return 0;
469     }
470 
471     /**
472      * @dev Returns the next token ID to be minted.
473      */
474     function _nextTokenId() internal view returns (uint256) {
475         return _currentIndex;
476     }
477 
478     /**
479      * @dev Returns the total number of tokens in existence.
480      * Burned tokens will reduce the count.
481      * To get the total number of tokens minted, please see `_totalMinted`.
482      */
483     function totalSupply() public view override returns (uint256) {
484         // Counter underflow is impossible as _burnCounter cannot be incremented
485         // more than `_currentIndex - _startTokenId()` times.
486         unchecked {
487             return _currentIndex - _burnCounter - _startTokenId();
488         }
489     }
490 
491     /**
492      * @dev Returns the total amount of tokens minted in the contract.
493      */
494     function _totalMinted() internal view returns (uint256) {
495         // Counter underflow is impossible as _currentIndex does not decrement,
496         // and it is initialized to `_startTokenId()`
497         unchecked {
498             return _currentIndex - _startTokenId();
499         }
500     }
501 
502     /**
503      * @dev Returns the total number of tokens burned.
504      */
505     function _totalBurned() internal view returns (uint256) {
506         return _burnCounter;
507     }
508 
509     /**
510      * @dev See {IERC165-supportsInterface}.
511      */
512     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
513         // The interface IDs are constants representing the first 4 bytes of the XOR of
514         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
515         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
516         return
517             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
518             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
519             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
520     }
521 
522     /**
523      * @dev See {IERC721-balanceOf}.
524      */
525     function balanceOf(address owner) public view override returns (uint256) {
526         if (_addressToUint256(owner) == 0) revert BalanceQueryForZeroAddress();
527         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
528     }
529 
530     /**
531      * Returns the number of tokens minted by `owner`.
532      */
533     function _numberMinted(address owner) internal view returns (uint256) {
534         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
535     }
536 
537     /**
538      * Returns the number of tokens burned by or on behalf of `owner`.
539      */
540     function _numberBurned(address owner) internal view returns (uint256) {
541         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
542     }
543 
544     /**
545      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
546      */
547     function _getAux(address owner) internal view returns (uint64) {
548         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
549     }
550 
551     /**
552      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
553      * If there are multiple variables, please pack them into a uint64.
554      */
555     function _setAux(address owner, uint64 aux) internal {
556         uint256 packed = _packedAddressData[owner];
557         uint256 auxCasted;
558         assembly {
559             // Cast aux without masking.
560             auxCasted := aux
561         }
562         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
563         _packedAddressData[owner] = packed;
564     }
565 
566     /**
567      * Returns the packed ownership data of `tokenId`.
568      */
569     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
570         uint256 curr = tokenId;
571 
572         unchecked {
573             if (_startTokenId() <= curr)
574                 if (curr < _currentIndex) {
575                     uint256 packed = _packedOwnerships[curr];
576                     // If not burned.
577                     if (packed & BITMASK_BURNED == 0) {
578                         // Invariant:
579                         // There will always be an ownership that has an address and is not burned
580                         // before an ownership that does not have an address and is not burned.
581                         // Hence, curr will not underflow.
582                         //
583                         // We can directly compare the packed value.
584                         // If the address is zero, packed is zero.
585                         while (packed == 0) {
586                             packed = _packedOwnerships[--curr];
587                         }
588                         return packed;
589                     }
590                 }
591         }
592         revert OwnerQueryForNonexistentToken();
593     }
594 
595     /**
596      * Returns the unpacked `TokenOwnership` struct from `packed`.
597      */
598     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
599         ownership.addr = address(uint160(packed));
600         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
601         ownership.burned = packed & BITMASK_BURNED != 0;
602     }
603 
604     /**
605      * Returns the unpacked `TokenOwnership` struct at `index`.
606      */
607     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
608         return _unpackedOwnership(_packedOwnerships[index]);
609     }
610 
611     /**
612      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
613      */
614     function _initializeOwnershipAt(uint256 index) internal {
615         if (_packedOwnerships[index] == 0) {
616             _packedOwnerships[index] = _packedOwnershipOf(index);
617         }
618     }
619 
620     /**
621      * Gas spent here starts off proportional to the maximum mint batch size.
622      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
623      */
624     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
625         return _unpackedOwnership(_packedOwnershipOf(tokenId));
626     }
627 
628     /**
629      * @dev See {IERC721-ownerOf}.
630      */
631     function ownerOf(uint256 tokenId) public view override returns (address) {
632         return address(uint160(_packedOwnershipOf(tokenId)));
633     }
634 
635     /**
636      * @dev See {IERC721Metadata-name}.
637      */
638     function name() public view virtual override returns (string memory) {
639         return _name;
640     }
641 
642     /**
643      * @dev See {IERC721Metadata-symbol}.
644      */
645     function symbol() public view virtual override returns (string memory) {
646         return _symbol;
647     }
648 
649     /**
650      * @dev See {IERC721Metadata-tokenURI}.
651      */
652     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
653         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
654 
655         string memory baseURI = _baseURI();
656         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
657     }
658 
659     /**
660      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
661      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
662      * by default, can be overriden in child contracts.
663      */
664     function _baseURI() internal view virtual returns (string memory) {
665         return '';
666     }
667 
668     /**
669      * @dev Casts the address to uint256 without masking.
670      */
671     function _addressToUint256(address value) private pure returns (uint256 result) {
672         assembly {
673             result := value
674         }
675     }
676 
677     /**
678      * @dev Casts the boolean to uint256 without branching.
679      */
680     function _boolToUint256(bool value) private pure returns (uint256 result) {
681         assembly {
682             result := value
683         }
684     }
685 
686     /**
687      * @dev See {IERC721-approve}.
688      */
689     function approve(address to, uint256 tokenId) public override {
690         address owner = address(uint160(_packedOwnershipOf(tokenId)));
691 
692         if (_msgSenderERC721A() != owner)
693             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
694                 revert ApprovalCallerNotOwnerNorApproved();
695             }
696 
697         _tokenApprovals[tokenId] = to;
698         emit Approval(owner, to, tokenId);
699     }
700 
701     /**
702      * @dev See {IERC721-getApproved}.
703      */
704     function getApproved(uint256 tokenId) public view override returns (address) {
705         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
706 
707         return _tokenApprovals[tokenId];
708     }
709 
710     /**
711      * @dev See {IERC721-setApprovalForAll}.
712      */
713     function setApprovalForAll(address operator, bool approved) public virtual override {
714         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
715 
716         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
717         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
718     }
719 
720     /**
721      * @dev See {IERC721-isApprovedForAll}.
722      */
723     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
724         return _operatorApprovals[owner][operator];
725     }
726 
727     /**
728      * @dev See {IERC721-transferFrom}.
729      */
730     function transferFrom(
731         address from,
732         address to,
733         uint256 tokenId
734     ) public virtual override {
735         _transfer(from, to, tokenId);
736     }
737 
738     /**
739      * @dev See {IERC721-safeTransferFrom}.
740      */
741     function safeTransferFrom(
742         address from,
743         address to,
744         uint256 tokenId
745     ) public virtual override {
746         safeTransferFrom(from, to, tokenId, '');
747     }
748 
749     /**
750      * @dev See {IERC721-safeTransferFrom}.
751      */
752     function safeTransferFrom(
753         address from,
754         address to,
755         uint256 tokenId,
756         bytes memory _data
757     ) public virtual override {
758         _transfer(from, to, tokenId);
759         if (to.code.length != 0)
760             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
761                 revert TransferToNonERC721ReceiverImplementer();
762             }
763     }
764 
765     /**
766      * @dev Returns whether `tokenId` exists.
767      *
768      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
769      *
770      * Tokens start existing when they are minted (`_mint`),
771      */
772     function _exists(uint256 tokenId) internal view returns (bool) {
773         return
774             _startTokenId() <= tokenId &&
775             tokenId < _currentIndex && // If within bounds,
776             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
777     }
778 
779     /**
780      * @dev Equivalent to `_safeMint(to, quantity, '')`.
781      */
782     function _safeMint(address to, uint256 quantity) internal {
783         _safeMint(to, quantity, '');
784     }
785 
786     /**
787      * @dev Safely mints `quantity` tokens and transfers them to `to`.
788      *
789      * Requirements:
790      *
791      * - If `to` refers to a smart contract, it must implement
792      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
793      * - `quantity` must be greater than 0.
794      *
795      * Emits a {Transfer} event for each mint.
796      */
797     function _safeMint(
798         address to,
799         uint256 quantity,
800         bytes memory _data
801     ) internal {
802         _mint(to, quantity);
803 
804         unchecked {
805             if (to.code.length != 0) {
806                 uint256 end = _currentIndex;
807                 uint256 index = end - quantity;
808                 do {
809                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
810                         revert TransferToNonERC721ReceiverImplementer();
811                     }
812                 } while (index < end);
813                 // Reentrancy protection.
814                 if (_currentIndex != end) revert();
815             }
816         }
817     }
818 
819     /**
820      * @dev Mints `quantity` tokens and transfers them to `to`.
821      *
822      * Requirements:
823      *
824      * - `to` cannot be the zero address.
825      * - `quantity` must be greater than 0.
826      *
827      * Emits a {Transfer} event for each mint.
828      */
829     function _mint(address to, uint256 quantity) internal {
830         uint256 startTokenId = _currentIndex;
831         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
832         if (quantity == 0) revert MintZeroQuantity();
833 
834         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
835 
836         // Overflows are incredibly unrealistic.
837         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
838         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
839         unchecked {
840             // Updates:
841             // - `balance += quantity`.
842             // - `numberMinted += quantity`.
843             //
844             // We can directly add to the balance and number minted.
845             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
846 
847             // Updates:
848             // - `address` to the owner.
849             // - `startTimestamp` to the timestamp of minting.
850             // - `burned` to `false`.
851             // - `nextInitialized` to `quantity == 1`.
852             _packedOwnerships[startTokenId] =
853                 _addressToUint256(to) |
854                 (block.timestamp << BITPOS_START_TIMESTAMP) |
855                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
856 
857             uint256 offset;
858             do {
859                 emit Transfer(address(0), to, startTokenId + offset++);
860             } while (offset < quantity);
861 
862             _currentIndex = startTokenId + quantity;
863         }
864         _afterTokenTransfers(address(0), to, startTokenId, quantity);
865     }
866 
867     /**
868      * @dev Transfers `tokenId` from `from` to `to`.
869      *
870      * Requirements:
871      *
872      * - `to` cannot be the zero address.
873      * - `tokenId` token must be owned by `from`.
874      *
875      * Emits a {Transfer} event.
876      */
877     function _transfer(
878         address from,
879         address to,
880         uint256 tokenId
881     ) private {
882         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
883 
884         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
885 
886         address approvedAddress = _tokenApprovals[tokenId];
887 
888         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
889             isApprovedForAll(from, _msgSenderERC721A()) ||
890             approvedAddress == _msgSenderERC721A());
891 
892         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
893         if (_addressToUint256(to) == 0) revert TransferToZeroAddress();
894 
895         _beforeTokenTransfers(from, to, tokenId, 1);
896 
897         // Clear approvals from the previous owner.
898         if (_addressToUint256(approvedAddress) != 0) {
899             delete _tokenApprovals[tokenId];
900         }
901 
902         // Underflow of the sender's balance is impossible because we check for
903         // ownership above and the recipient's balance can't realistically overflow.
904         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
905         unchecked {
906             // We can directly increment and decrement the balances.
907             --_packedAddressData[from]; // Updates: `balance -= 1`.
908             ++_packedAddressData[to]; // Updates: `balance += 1`.
909 
910             // Updates:
911             // - `address` to the next owner.
912             // - `startTimestamp` to the timestamp of transfering.
913             // - `burned` to `false`.
914             // - `nextInitialized` to `true`.
915             _packedOwnerships[tokenId] =
916                 _addressToUint256(to) |
917                 (block.timestamp << BITPOS_START_TIMESTAMP) |
918                 BITMASK_NEXT_INITIALIZED;
919 
920             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
921             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
922                 uint256 nextTokenId = tokenId + 1;
923                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
924                 if (_packedOwnerships[nextTokenId] == 0) {
925                     // If the next slot is within bounds.
926                     if (nextTokenId != _currentIndex) {
927                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
928                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
929                     }
930                 }
931             }
932         }
933 
934         emit Transfer(from, to, tokenId);
935         _afterTokenTransfers(from, to, tokenId, 1);
936     }
937 
938     /**
939      * @dev Equivalent to `_burn(tokenId, false)`.
940      */
941     function _burn(uint256 tokenId) internal virtual {
942         _burn(tokenId, false);
943     }
944 
945     /**
946      * @dev Destroys `tokenId`.
947      * The approval is cleared when the token is burned.
948      *
949      * Requirements:
950      *
951      * - `tokenId` must exist.
952      *
953      * Emits a {Transfer} event.
954      */
955     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
956         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
957 
958         address from = address(uint160(prevOwnershipPacked));
959         address approvedAddress = _tokenApprovals[tokenId];
960 
961         if (approvalCheck) {
962             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
963                 isApprovedForAll(from, _msgSenderERC721A()) ||
964                 approvedAddress == _msgSenderERC721A());
965 
966             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
967         }
968 
969         _beforeTokenTransfers(from, address(0), tokenId, 1);
970 
971         // Clear approvals from the previous owner.
972         if (_addressToUint256(approvedAddress) != 0) {
973             delete _tokenApprovals[tokenId];
974         }
975 
976         // Underflow of the sender's balance is impossible because we check for
977         // ownership above and the recipient's balance can't realistically overflow.
978         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
979         unchecked {
980             // Updates:
981             // - `balance -= 1`.
982             // - `numberBurned += 1`.
983             //
984             // We can directly decrement the balance, and increment the number burned.
985             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
986             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
987 
988             // Updates:
989             // - `address` to the last owner.
990             // - `startTimestamp` to the timestamp of burning.
991             // - `burned` to `true`.
992             // - `nextInitialized` to `true`.
993             _packedOwnerships[tokenId] =
994                 _addressToUint256(from) |
995                 (block.timestamp << BITPOS_START_TIMESTAMP) |
996                 BITMASK_BURNED |
997                 BITMASK_NEXT_INITIALIZED;
998 
999             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1000             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1001                 uint256 nextTokenId = tokenId + 1;
1002                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1003                 if (_packedOwnerships[nextTokenId] == 0) {
1004                     // If the next slot is within bounds.
1005                     if (nextTokenId != _currentIndex) {
1006                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1007                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1008                     }
1009                 }
1010             }
1011         }
1012 
1013         emit Transfer(from, address(0), tokenId);
1014         _afterTokenTransfers(from, address(0), tokenId, 1);
1015 
1016         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1017         unchecked {
1018             _burnCounter++;
1019         }
1020     }
1021 
1022     /**
1023      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1024      *
1025      * @param from address representing the previous owner of the given token ID
1026      * @param to target address that will receive the tokens
1027      * @param tokenId uint256 ID of the token to be transferred
1028      * @param _data bytes optional data to send along with the call
1029      * @return bool whether the call correctly returned the expected magic value
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
1043                 revert TransferToNonERC721ReceiverImplementer();
1044             } else {
1045                 assembly {
1046                     revert(add(32, reason), mload(reason))
1047                 }
1048             }
1049         }
1050     }
1051 
1052     /**
1053      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1054      * And also called before burning one token.
1055      *
1056      * startTokenId - the first token id to be transferred
1057      * quantity - the amount to be transferred
1058      *
1059      * Calling conditions:
1060      *
1061      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1062      * transferred to `to`.
1063      * - When `from` is zero, `tokenId` will be minted for `to`.
1064      * - When `to` is zero, `tokenId` will be burned by `from`.
1065      * - `from` and `to` are never both zero.
1066      */
1067     function _beforeTokenTransfers(
1068         address from,
1069         address to,
1070         uint256 startTokenId,
1071         uint256 quantity
1072     ) internal virtual {}
1073 
1074     /**
1075      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1076      * minting.
1077      * And also called after one token has been burned.
1078      *
1079      * startTokenId - the first token id to be transferred
1080      * quantity - the amount to be transferred
1081      *
1082      * Calling conditions:
1083      *
1084      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1085      * transferred to `to`.
1086      * - When `from` is zero, `tokenId` has been minted for `to`.
1087      * - When `to` is zero, `tokenId` has been burned by `from`.
1088      * - `from` and `to` are never both zero.
1089      */
1090     function _afterTokenTransfers(
1091         address from,
1092         address to,
1093         uint256 startTokenId,
1094         uint256 quantity
1095     ) internal virtual {}
1096 
1097     /**
1098      * @dev Returns the message sender (defaults to `msg.sender`).
1099      *
1100      * If you are writing GSN compatible contracts, you need to override this function.
1101      */
1102     function _msgSenderERC721A() internal view virtual returns (address) {
1103         return msg.sender;
1104     }
1105 
1106     /**
1107      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1108      */
1109     function _toString(uint256 value) internal pure returns (string memory ptr) {
1110         assembly {
1111             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1112             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1113             // We will need 1 32-byte word to store the length,
1114             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1115             ptr := add(mload(0x40), 128)
1116             // Update the free memory pointer to allocate.
1117             mstore(0x40, ptr)
1118 
1119             // Cache the end of the memory to calculate the length later.
1120             let end := ptr
1121 
1122             // We write the string from the rightmost digit to the leftmost digit.
1123             // The following is essentially a do-while loop that also handles the zero case.
1124             // Costs a bit more than early returning for the zero case,
1125             // but cheaper in terms of deployment and overall runtime costs.
1126             for {
1127                 // Initialize and perform the first pass without check.
1128                 let temp := value
1129                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1130                 ptr := sub(ptr, 1)
1131                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1132                 mstore8(ptr, add(48, mod(temp, 10)))
1133                 temp := div(temp, 10)
1134             } temp {
1135                 // Keep dividing `temp` until zero.
1136                 temp := div(temp, 10)
1137             } {
1138                 // Body of the for loop.
1139                 ptr := sub(ptr, 1)
1140                 mstore8(ptr, add(48, mod(temp, 10)))
1141             }
1142 
1143             let length := sub(end, ptr)
1144             // Move the pointer 32 bytes leftwards to make room for the length.
1145             ptr := sub(ptr, 32)
1146             // Store the length.
1147             mstore(ptr, length)
1148         }
1149     }
1150 }
1151 
1152 // BEGIN FREE MINT
1153 //  ▄▀▀▀▀▄   ▄▀▀▀█▀▀▄  ▄▀▀▄▀▀▀▄ 
1154 // █        █    █  ▐ █   █   █ 
1155 // █    ▀▄▄ ▐   █     ▐  █▀▀█▀  
1156 // █     █ █   █       ▄▀    █  
1157 // ▐▀▄▄▄▄▀ ▐ ▄▀       █     █   
1158 // ▐        █         ▐     ▐   
1159 //          ▐                   
1160 // @goblinrejects 2022                                                                                                    
1161 
1162 pragma solidity 0.8.9;
1163 
1164 
1165 contract GoblinRejects is ERC721A, Ownable {
1166   // "Private" Variables
1167   address private constant REJECT1 = 0x576cf2Bf8773754C17f633F286aE746eA33fC6d7;
1168   address private constant REJECT2 = 0xf64ddaF90b58a9eb38D6dCd491b27b4093cf3EdA;
1169   string private baseURI;
1170 
1171   // Public Variables
1172   bool public started = false;
1173   bool public claimed = false;
1174   uint256 public constant MAX_SUPPLY = 3333;
1175   uint256 public constant MAX_MINT = 1;
1176   uint256 public constant TEAM_CLAIM_AMOUNT = 333;
1177 
1178   mapping(address => uint) public addressClaimed;
1179 
1180   constructor() ERC721A("Goblin Rejects", "GTR") {}
1181 
1182   // Start tokenid at 1 instead of 0
1183   function _startTokenId() internal view virtual override returns (uint256) {
1184       return 1;
1185   }
1186 
1187   function Mint() external {
1188     require(started, "Fuck 0ff");
1189     require(addressClaimed[_msgSender()] < MAX_MINT, "Fuck 0ff too many for you!");
1190     require(totalSupply() < MAX_SUPPLY, "Fuck 0ff we're all g0ne");
1191     // mint
1192     addressClaimed[_msgSender()] += 1;
1193     _safeMint(msg.sender, 1);
1194   }
1195 
1196   function fuckOff() external onlyOwner {
1197     require(!claimed, "Team already claimed");
1198     // claim
1199     _safeMint(REJECT1, TEAM_CLAIM_AMOUNT);
1200     _safeMint(REJECT2, TEAM_CLAIM_AMOUNT);
1201     claimed = true;
1202   }
1203 
1204   function URInate(string memory baseURI_) external onlyOwner {
1205       baseURI = baseURI_;
1206   }
1207 
1208   function _baseURI() internal view virtual override returns (string memory) {
1209       return baseURI;
1210   }
1211 
1212   function startMeDaddy(bool mintStarted) external onlyOwner {
1213       started = mintStarted;
1214   }
1215 }