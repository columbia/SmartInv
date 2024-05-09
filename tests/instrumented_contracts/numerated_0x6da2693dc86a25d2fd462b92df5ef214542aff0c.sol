1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 // SPDX-License-Identifier: MIT
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
30 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
31 
32 pragma solidity ^0.8.0;
33 
34 /**
35  * @dev Contract module which provides a basic access control mechanism, where
36  * there is an account (an owner) that can be granted exclusive access to
37  * specific functions.
38  *
39  * By default, the owner account will be the one that deploys the contract. This
40  * can later be changed with {transferOwnership}.
41  *
42  * This module is used through inheritance. It will make available the modifier
43  * `onlyOwner`, which can be applied to your functions to restrict their use to
44  * the owner.
45  */
46 abstract contract Ownable is Context {
47     address private _owner;
48 
49     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51     /**
52      * @dev Initializes the contract setting the deployer as the initial owner.
53      */
54     constructor() {
55         _transferOwnership(_msgSender());
56     }
57 
58     /**
59      * @dev Returns the address of the current owner.
60      */
61     function owner() public view virtual returns (address) {
62         return _owner;
63     }
64 
65     /**
66      * @dev Throws if called by any account other than the owner.
67      */
68     modifier onlyOwner() {
69         require(owner() == _msgSender(), "Ownable: caller is not the owner");
70         _;
71     }
72 
73     /**
74      * @dev Leaves the contract without owner. It will not be possible to call
75      * `onlyOwner` functions anymore. Can only be called by the current owner.
76      *
77      * NOTE: Renouncing ownership will leave the contract without an owner,
78      * thereby removing any functionality that is only available to the owner.
79      */
80     function renounceOwnership() public virtual onlyOwner {
81         _transferOwnership(address(0));
82     }
83 
84     /**
85      * @dev Transfers ownership of the contract to a new account (`newOwner`).
86      * Can only be called by the current owner.
87      */
88     function transferOwnership(address newOwner) public virtual onlyOwner {
89         require(newOwner != address(0), "Ownable: new owner is the zero address");
90         _transferOwnership(newOwner);
91     }
92 
93     /**
94      * @dev Transfers ownership of the contract to a new account (`newOwner`).
95      * Internal function without access restriction.
96      */
97     function _transferOwnership(address newOwner) internal virtual {
98         address oldOwner = _owner;
99         _owner = newOwner;
100         emit OwnershipTransferred(oldOwner, newOwner);
101     }
102 }
103 
104 // File: erc721a/contracts/IERC721A.sol
105 
106 // ERC721A Contracts v4.0.0
107 // Creator: Chiru Labs
108 
109 pragma solidity ^0.8.4;
110 
111 /**
112  * @dev Interface of an ERC721A compliant contract.
113  */
114 interface IERC721A {
115     /**
116      * The caller must own the token or be an approved operator.
117      */
118     error ApprovalCallerNotOwnerNorApproved();
119 
120     /**
121      * The token does not exist.
122      */
123     error ApprovalQueryForNonexistentToken();
124 
125     /**
126      * The caller cannot approve to their own address.
127      */
128     error ApproveToCaller();
129 
130     /**
131      * The caller cannot approve to the current owner.
132      */
133     error ApprovalToCurrentOwner();
134 
135     /**
136      * Cannot query the balance for the zero address.
137      */
138     error BalanceQueryForZeroAddress();
139 
140     /**
141      * Cannot mint to the zero address.
142      */
143     error MintToZeroAddress();
144 
145     /**
146      * The quantity of tokens minted must be more than zero.
147      */
148     error MintZeroQuantity();
149 
150     /**
151      * The token does not exist.
152      */
153     error OwnerQueryForNonexistentToken();
154 
155     /**
156      * The caller must own the token or be an approved operator.
157      */
158     error TransferCallerNotOwnerNorApproved();
159 
160     /**
161      * The token must be owned by `from`.
162      */
163     error TransferFromIncorrectOwner();
164 
165     /**
166      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
167      */
168     error TransferToNonERC721ReceiverImplementer();
169 
170     /**
171      * Cannot transfer to the zero address.
172      */
173     error TransferToZeroAddress();
174 
175     /**
176      * The token does not exist.
177      */
178     error URIQueryForNonexistentToken();
179 
180     struct TokenOwnership {
181         // The address of the owner.
182         address addr;
183         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
184         uint64 startTimestamp;
185         // Whether the token has been burned.
186         bool burned;
187     }
188 
189     /**
190      * @dev Returns the total amount of tokens stored by the contract.
191      *
192      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
193      */
194     function totalSupply() external view returns (uint256);
195 
196     // ==============================
197     //            IERC165
198     // ==============================
199 
200     /**
201      * @dev Returns true if this contract implements the interface defined by
202      * `interfaceId`. See the corresponding
203      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
204      * to learn more about how these ids are created.
205      *
206      * This function call must use less than 30 000 gas.
207      */
208     function supportsInterface(bytes4 interfaceId) external view returns (bool);
209 
210     // ==============================
211     //            IERC721
212     // ==============================
213 
214     /**
215      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
216      */
217     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
218 
219     /**
220      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
221      */
222     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
223 
224     /**
225      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
226      */
227     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
228 
229     /**
230      * @dev Returns the number of tokens in ``owner``'s account.
231      */
232     function balanceOf(address owner) external view returns (uint256 balance);
233 
234     /**
235      * @dev Returns the owner of the `tokenId` token.
236      *
237      * Requirements:
238      *
239      * - `tokenId` must exist.
240      */
241     function ownerOf(uint256 tokenId) external view returns (address owner);
242 
243     /**
244      * @dev Safely transfers `tokenId` token from `from` to `to`.
245      *
246      * Requirements:
247      *
248      * - `from` cannot be the zero address.
249      * - `to` cannot be the zero address.
250      * - `tokenId` token must exist and be owned by `from`.
251      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
252      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
253      *
254      * Emits a {Transfer} event.
255      */
256     function safeTransferFrom(
257         address from,
258         address to,
259         uint256 tokenId,
260         bytes calldata data
261     ) external;
262 
263     /**
264      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
265      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
266      *
267      * Requirements:
268      *
269      * - `from` cannot be the zero address.
270      * - `to` cannot be the zero address.
271      * - `tokenId` token must exist and be owned by `from`.
272      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
273      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
274      *
275      * Emits a {Transfer} event.
276      */
277     function safeTransferFrom(
278         address from,
279         address to,
280         uint256 tokenId
281     ) external;
282 
283     /**
284      * @dev Transfers `tokenId` token from `from` to `to`.
285      *
286      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
287      *
288      * Requirements:
289      *
290      * - `from` cannot be the zero address.
291      * - `to` cannot be the zero address.
292      * - `tokenId` token must be owned by `from`.
293      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
294      *
295      * Emits a {Transfer} event.
296      */
297     function transferFrom(
298         address from,
299         address to,
300         uint256 tokenId
301     ) external;
302 
303     /**
304      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
305      * The approval is cleared when the token is transferred.
306      *
307      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
308      *
309      * Requirements:
310      *
311      * - The caller must own the token or be an approved operator.
312      * - `tokenId` must exist.
313      *
314      * Emits an {Approval} event.
315      */
316     function approve(address to, uint256 tokenId) external;
317 
318     /**
319      * @dev Approve or remove `operator` as an operator for the caller.
320      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
321      *
322      * Requirements:
323      *
324      * - The `operator` cannot be the caller.
325      *
326      * Emits an {ApprovalForAll} event.
327      */
328     function setApprovalForAll(address operator, bool _approved) external;
329 
330     /**
331      * @dev Returns the account approved for `tokenId` token.
332      *
333      * Requirements:
334      *
335      * - `tokenId` must exist.
336      */
337     function getApproved(uint256 tokenId) external view returns (address operator);
338 
339     /**
340      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
341      *
342      * See {setApprovalForAll}
343      */
344     function isApprovedForAll(address owner, address operator) external view returns (bool);
345 
346     // ==============================
347     //        IERC721Metadata
348     // ==============================
349 
350     /**
351      * @dev Returns the token collection name.
352      */
353     function name() external view returns (string memory);
354 
355     /**
356      * @dev Returns the token collection symbol.
357      */
358     function symbol() external view returns (string memory);
359 
360     /**
361      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
362      */
363     function tokenURI(uint256 tokenId) external view returns (string memory);
364 }
365 
366 // File: erc721a/contracts/ERC721A.sol
367 
368 // ERC721A Contracts v4.0.0
369 // Creator: Chiru Labs
370 
371 pragma solidity ^0.8.4;
372 
373 /**
374  * @dev ERC721 token receiver interface.
375  */
376 interface ERC721A__IERC721Receiver {
377     function onERC721Received(
378         address operator,
379         address from,
380         uint256 tokenId,
381         bytes calldata data
382     ) external returns (bytes4);
383 }
384 
385 /**
386  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
387  * the Metadata extension. Built to optimize for lower gas during batch mints.
388  *
389  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
390  *
391  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
392  *
393  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
394  */
395 contract ERC721A is IERC721A {
396     // Mask of an entry in packed address data.
397     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
398 
399     // The bit position of `numberMinted` in packed address data.
400     uint256 private constant BITPOS_NUMBER_MINTED = 64;
401 
402     // The bit position of `numberBurned` in packed address data.
403     uint256 private constant BITPOS_NUMBER_BURNED = 128;
404 
405     // The bit position of `aux` in packed address data.
406     uint256 private constant BITPOS_AUX = 192;
407 
408     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
409     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
410 
411     // The bit position of `startTimestamp` in packed ownership.
412     uint256 private constant BITPOS_START_TIMESTAMP = 160;
413 
414     // The bit mask of the `burned` bit in packed ownership.
415     uint256 private constant BITMASK_BURNED = 1 << 224;
416     
417     // The bit position of the `nextInitialized` bit in packed ownership.
418     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
419 
420     // The bit mask of the `nextInitialized` bit in packed ownership.
421     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
422 
423     // The tokenId of the next token to be minted.
424     uint256 private _currentIndex;
425 
426     // The number of tokens burned.
427     uint256 private _burnCounter;
428 
429     // Token name
430     string private _name;
431 
432     // Token symbol
433     string private _symbol;
434 
435     // Mapping from token ID to ownership details
436     // An empty struct value does not necessarily mean the token is unowned.
437     // See `_packedOwnershipOf` implementation for details.
438     //
439     // Bits Layout:
440     // - [0..159]   `addr`
441     // - [160..223] `startTimestamp`
442     // - [224]      `burned`
443     // - [225]      `nextInitialized`
444     mapping(uint256 => uint256) private _packedOwnerships;
445 
446     // Mapping owner address to address data.
447     //
448     // Bits Layout:
449     // - [0..63]    `balance`
450     // - [64..127]  `numberMinted`
451     // - [128..191] `numberBurned`
452     // - [192..255] `aux`
453     mapping(address => uint256) private _packedAddressData;
454 
455     // Mapping from token ID to approved address.
456     mapping(uint256 => address) private _tokenApprovals;
457 
458     // Mapping from owner to operator approvals
459     mapping(address => mapping(address => bool)) private _operatorApprovals;
460 
461     constructor(string memory name_, string memory symbol_) {
462         _name = name_;
463         _symbol = symbol_;
464         _currentIndex = _startTokenId();
465     }
466 
467     /**
468      * @dev Returns the starting token ID. 
469      * To change the starting token ID, please override this function.
470      */
471     function _startTokenId() internal view virtual returns (uint256) {
472         return 0;
473     }
474 
475     /**
476      * @dev Returns the next token ID to be minted.
477      */
478     function _nextTokenId() internal view returns (uint256) {
479         return _currentIndex;
480     }
481 
482     /**
483      * @dev Returns the total number of tokens in existence.
484      * Burned tokens will reduce the count. 
485      * To get the total number of tokens minted, please see `_totalMinted`.
486      */
487     function totalSupply() public view override returns (uint256) {
488         // Counter underflow is impossible as _burnCounter cannot be incremented
489         // more than `_currentIndex - _startTokenId()` times.
490         unchecked {
491             return _currentIndex - _burnCounter - _startTokenId();
492         }
493     }
494 
495     /**
496      * @dev Returns the total amount of tokens minted in the contract.
497      */
498     function _totalMinted() internal view returns (uint256) {
499         // Counter underflow is impossible as _currentIndex does not decrement,
500         // and it is initialized to `_startTokenId()`
501         unchecked {
502             return _currentIndex - _startTokenId();
503         }
504     }
505 
506     /**
507      * @dev Returns the total number of tokens burned.
508      */
509     function _totalBurned() internal view returns (uint256) {
510         return _burnCounter;
511     }
512 
513     /**
514      * @dev See {IERC165-supportsInterface}.
515      */
516     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
517         // The interface IDs are constants representing the first 4 bytes of the XOR of
518         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
519         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
520         return
521             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
522             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
523             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
524     }
525 
526     /**
527      * @dev See {IERC721-balanceOf}.
528      */
529     function balanceOf(address owner) public view override returns (uint256) {
530         if (owner == address(0)) revert BalanceQueryForZeroAddress();
531         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
532     }
533 
534     /**
535      * Returns the number of tokens minted by `owner`.
536      */
537     function _numberMinted(address owner) internal view returns (uint256) {
538         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
539     }
540 
541     /**
542      * Returns the number of tokens burned by or on behalf of `owner`.
543      */
544     function _numberBurned(address owner) internal view returns (uint256) {
545         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
546     }
547 
548     /**
549      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
550      */
551     function _getAux(address owner) internal view returns (uint64) {
552         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
553     }
554 
555     /**
556      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
557      * If there are multiple variables, please pack them into a uint64.
558      */
559     function _setAux(address owner, uint64 aux) internal {
560         uint256 packed = _packedAddressData[owner];
561         uint256 auxCasted;
562         assembly { // Cast aux without masking.
563             auxCasted := aux
564         }
565         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
566         _packedAddressData[owner] = packed;
567     }
568 
569     /**
570      * Returns the packed ownership data of `tokenId`.
571      */
572     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
573         uint256 curr = tokenId;
574 
575         unchecked {
576             if (_startTokenId() <= curr)
577                 if (curr < _currentIndex) {
578                     uint256 packed = _packedOwnerships[curr];
579                     // If not burned.
580                     if (packed & BITMASK_BURNED == 0) {
581                         // Invariant:
582                         // There will always be an ownership that has an address and is not burned
583                         // before an ownership that does not have an address and is not burned.
584                         // Hence, curr will not underflow.
585                         //
586                         // We can directly compare the packed value.
587                         // If the address is zero, packed is zero.
588                         while (packed == 0) {
589                             packed = _packedOwnerships[--curr];
590                         }
591                         return packed;
592                     }
593                 }
594         }
595         revert OwnerQueryForNonexistentToken();
596     }
597 
598     /**
599      * Returns the unpacked `TokenOwnership` struct from `packed`.
600      */
601     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
602         ownership.addr = address(uint160(packed));
603         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
604         ownership.burned = packed & BITMASK_BURNED != 0;
605     }
606 
607     /**
608      * Returns the unpacked `TokenOwnership` struct at `index`.
609      */
610     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
611         return _unpackedOwnership(_packedOwnerships[index]);
612     }
613 
614     /**
615      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
616      */
617     function _initializeOwnershipAt(uint256 index) internal {
618         if (_packedOwnerships[index] == 0) {
619             _packedOwnerships[index] = _packedOwnershipOf(index);
620         }
621     }
622 
623     /**
624      * Gas spent here starts off proportional to the maximum mint batch size.
625      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
626      */
627     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
628         return _unpackedOwnership(_packedOwnershipOf(tokenId));
629     }
630 
631     /**
632      * @dev See {IERC721-ownerOf}.
633      */
634     function ownerOf(uint256 tokenId) public view override returns (address) {
635         return address(uint160(_packedOwnershipOf(tokenId)));
636     }
637 
638     /**
639      * @dev See {IERC721Metadata-name}.
640      */
641     function name() public view virtual override returns (string memory) {
642         return _name;
643     }
644 
645     /**
646      * @dev See {IERC721Metadata-symbol}.
647      */
648     function symbol() public view virtual override returns (string memory) {
649         return _symbol;
650     }
651 
652     /**
653      * @dev See {IERC721Metadata-tokenURI}.
654      */
655     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
656         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
657 
658         string memory baseURI = _baseURI();
659         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
660     }
661 
662     /**
663      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
664      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
665      * by default, can be overriden in child contracts.
666      */
667     function _baseURI() internal view virtual returns (string memory) {
668         return '';
669     }
670 
671     /**
672      * @dev Casts the address to uint256 without masking.
673      */
674     function _addressToUint256(address value) private pure returns (uint256 result) {
675         assembly {
676             result := value
677         }
678     }
679 
680     /**
681      * @dev Casts the boolean to uint256 without branching.
682      */
683     function _boolToUint256(bool value) private pure returns (uint256 result) {
684         assembly {
685             result := value
686         }
687     }
688 
689     /**
690      * @dev See {IERC721-approve}.
691      */
692     function approve(address to, uint256 tokenId) public override {
693         address owner = address(uint160(_packedOwnershipOf(tokenId)));
694         if (to == owner) revert ApprovalToCurrentOwner();
695 
696         if (_msgSenderERC721A() != owner)
697             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
698                 revert ApprovalCallerNotOwnerNorApproved();
699             }
700 
701         _tokenApprovals[tokenId] = to;
702         emit Approval(owner, to, tokenId);
703     }
704 
705     /**
706      * @dev See {IERC721-getApproved}.
707      */
708     function getApproved(uint256 tokenId) public view override returns (address) {
709         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
710 
711         return _tokenApprovals[tokenId];
712     }
713 
714     /**
715      * @dev See {IERC721-setApprovalForAll}.
716      */
717     function setApprovalForAll(address operator, bool approved) public virtual override {
718         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
719 
720         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
721         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
722     }
723 
724     /**
725      * @dev See {IERC721-isApprovedForAll}.
726      */
727     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
728         return _operatorApprovals[owner][operator];
729     }
730 
731     /**
732      * @dev See {IERC721-transferFrom}.
733      */
734     function transferFrom(
735         address from,
736         address to,
737         uint256 tokenId
738     ) public virtual override {
739         _transfer(from, to, tokenId);
740     }
741 
742     /**
743      * @dev See {IERC721-safeTransferFrom}.
744      */
745     function safeTransferFrom(
746         address from,
747         address to,
748         uint256 tokenId
749     ) public virtual override {
750         safeTransferFrom(from, to, tokenId, '');
751     }
752 
753     /**
754      * @dev See {IERC721-safeTransferFrom}.
755      */
756     function safeTransferFrom(
757         address from,
758         address to,
759         uint256 tokenId,
760         bytes memory _data
761     ) public virtual override {
762         _transfer(from, to, tokenId);
763         if (to.code.length != 0)
764             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
765                 revert TransferToNonERC721ReceiverImplementer();
766             }
767     }
768 
769     /**
770      * @dev Returns whether `tokenId` exists.
771      *
772      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
773      *
774      * Tokens start existing when they are minted (`_mint`),
775      */
776     function _exists(uint256 tokenId) internal view returns (bool) {
777         return
778             _startTokenId() <= tokenId &&
779             tokenId < _currentIndex && // If within bounds,
780             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
781     }
782 
783     /**
784      * @dev Equivalent to `_safeMint(to, quantity, '')`.
785      */
786     function _safeMint(address to, uint256 quantity) internal {
787         _safeMint(to, quantity, '');
788     }
789 
790     /**
791      * @dev Safely mints `quantity` tokens and transfers them to `to`.
792      *
793      * Requirements:
794      *
795      * - If `to` refers to a smart contract, it must implement
796      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
797      * - `quantity` must be greater than 0.
798      *
799      * Emits a {Transfer} event.
800      */
801     function _safeMint(
802         address to,
803         uint256 quantity,
804         bytes memory _data
805     ) internal {
806         uint256 startTokenId = _currentIndex;
807         if (to == address(0)) revert MintToZeroAddress();
808         if (quantity == 0) revert MintZeroQuantity();
809 
810         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
811 
812         // Overflows are incredibly unrealistic.
813         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
814         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
815         unchecked {
816             // Updates:
817             // - `balance += quantity`.
818             // - `numberMinted += quantity`.
819             //
820             // We can directly add to the balance and number minted.
821             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
822 
823             // Updates:
824             // - `address` to the owner.
825             // - `startTimestamp` to the timestamp of minting.
826             // - `burned` to `false`.
827             // - `nextInitialized` to `quantity == 1`.
828             _packedOwnerships[startTokenId] =
829                 _addressToUint256(to) |
830                 (block.timestamp << BITPOS_START_TIMESTAMP) |
831                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
832 
833             uint256 updatedIndex = startTokenId;
834             uint256 end = updatedIndex + quantity;
835 
836             if (to.code.length != 0) {
837                 do {
838                     emit Transfer(address(0), to, updatedIndex);
839                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
840                         revert TransferToNonERC721ReceiverImplementer();
841                     }
842                 } while (updatedIndex < end);
843                 // Reentrancy protection
844                 if (_currentIndex != startTokenId) revert();
845             } else {
846                 do {
847                     emit Transfer(address(0), to, updatedIndex++);
848                 } while (updatedIndex < end);
849             }
850             _currentIndex = updatedIndex;
851         }
852         _afterTokenTransfers(address(0), to, startTokenId, quantity);
853     }
854 
855     /**
856      * @dev Mints `quantity` tokens and transfers them to `to`.
857      *
858      * Requirements:
859      *
860      * - `to` cannot be the zero address.
861      * - `quantity` must be greater than 0.
862      *
863      * Emits a {Transfer} event.
864      */
865     function _mint(address to, uint256 quantity) internal {
866         uint256 startTokenId = _currentIndex;
867         if (to == address(0)) revert MintToZeroAddress();
868         if (quantity == 0) revert MintZeroQuantity();
869 
870         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
871 
872         // Overflows are incredibly unrealistic.
873         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
874         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
875         unchecked {
876             // Updates:
877             // - `balance += quantity`.
878             // - `numberMinted += quantity`.
879             //
880             // We can directly add to the balance and number minted.
881             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
882 
883             // Updates:
884             // - `address` to the owner.
885             // - `startTimestamp` to the timestamp of minting.
886             // - `burned` to `false`.
887             // - `nextInitialized` to `quantity == 1`.
888             _packedOwnerships[startTokenId] =
889                 _addressToUint256(to) |
890                 (block.timestamp << BITPOS_START_TIMESTAMP) |
891                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
892 
893             uint256 updatedIndex = startTokenId;
894             uint256 end = updatedIndex + quantity;
895 
896             do {
897                 emit Transfer(address(0), to, updatedIndex++);
898             } while (updatedIndex < end);
899 
900             _currentIndex = updatedIndex;
901         }
902         _afterTokenTransfers(address(0), to, startTokenId, quantity);
903     }
904 
905     /**
906      * @dev Transfers `tokenId` from `from` to `to`.
907      *
908      * Requirements:
909      *
910      * - `to` cannot be the zero address.
911      * - `tokenId` token must be owned by `from`.
912      *
913      * Emits a {Transfer} event.
914      */
915     function _transfer(
916         address from,
917         address to,
918         uint256 tokenId
919     ) private {
920         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
921 
922         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
923 
924         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
925             isApprovedForAll(from, _msgSenderERC721A()) ||
926             getApproved(tokenId) == _msgSenderERC721A());
927 
928         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
929         if (to == address(0)) revert TransferToZeroAddress();
930 
931         _beforeTokenTransfers(from, to, tokenId, 1);
932 
933         // Clear approvals from the previous owner.
934         delete _tokenApprovals[tokenId];
935 
936         // Underflow of the sender's balance is impossible because we check for
937         // ownership above and the recipient's balance can't realistically overflow.
938         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
939         unchecked {
940             // We can directly increment and decrement the balances.
941             --_packedAddressData[from]; // Updates: `balance -= 1`.
942             ++_packedAddressData[to]; // Updates: `balance += 1`.
943 
944             // Updates:
945             // - `address` to the next owner.
946             // - `startTimestamp` to the timestamp of transfering.
947             // - `burned` to `false`.
948             // - `nextInitialized` to `true`.
949             _packedOwnerships[tokenId] =
950                 _addressToUint256(to) |
951                 (block.timestamp << BITPOS_START_TIMESTAMP) |
952                 BITMASK_NEXT_INITIALIZED;
953 
954             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
955             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
956                 uint256 nextTokenId = tokenId + 1;
957                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
958                 if (_packedOwnerships[nextTokenId] == 0) {
959                     // If the next slot is within bounds.
960                     if (nextTokenId != _currentIndex) {
961                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
962                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
963                     }
964                 }
965             }
966         }
967 
968         emit Transfer(from, to, tokenId);
969         _afterTokenTransfers(from, to, tokenId, 1);
970     }
971 
972     /**
973      * @dev Equivalent to `_burn(tokenId, false)`.
974      */
975     function _burn(uint256 tokenId) internal virtual {
976         _burn(tokenId, false);
977     }
978 
979     /**
980      * @dev Destroys `tokenId`.
981      * The approval is cleared when the token is burned.
982      *
983      * Requirements:
984      *
985      * - `tokenId` must exist.
986      *
987      * Emits a {Transfer} event.
988      */
989     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
990         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
991 
992         address from = address(uint160(prevOwnershipPacked));
993 
994         if (approvalCheck) {
995             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
996                 isApprovedForAll(from, _msgSenderERC721A()) ||
997                 getApproved(tokenId) == _msgSenderERC721A());
998 
999             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1000         }
1001 
1002         _beforeTokenTransfers(from, address(0), tokenId, 1);
1003 
1004         // Clear approvals from the previous owner.
1005         delete _tokenApprovals[tokenId];
1006 
1007         // Underflow of the sender's balance is impossible because we check for
1008         // ownership above and the recipient's balance can't realistically overflow.
1009         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1010         unchecked {
1011             // Updates:
1012             // - `balance -= 1`.
1013             // - `numberBurned += 1`.
1014             //
1015             // We can directly decrement the balance, and increment the number burned.
1016             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1017             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1018 
1019             // Updates:
1020             // - `address` to the last owner.
1021             // - `startTimestamp` to the timestamp of burning.
1022             // - `burned` to `true`.
1023             // - `nextInitialized` to `true`.
1024             _packedOwnerships[tokenId] =
1025                 _addressToUint256(from) |
1026                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1027                 BITMASK_BURNED | 
1028                 BITMASK_NEXT_INITIALIZED;
1029 
1030             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1031             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1032                 uint256 nextTokenId = tokenId + 1;
1033                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1034                 if (_packedOwnerships[nextTokenId] == 0) {
1035                     // If the next slot is within bounds.
1036                     if (nextTokenId != _currentIndex) {
1037                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1038                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1039                     }
1040                 }
1041             }
1042         }
1043 
1044         emit Transfer(from, address(0), tokenId);
1045         _afterTokenTransfers(from, address(0), tokenId, 1);
1046 
1047         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1048         unchecked {
1049             _burnCounter++;
1050         }
1051     }
1052 
1053     /**
1054      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1055      *
1056      * @param from address representing the previous owner of the given token ID
1057      * @param to target address that will receive the tokens
1058      * @param tokenId uint256 ID of the token to be transferred
1059      * @param _data bytes optional data to send along with the call
1060      * @return bool whether the call correctly returned the expected magic value
1061      */
1062     function _checkContractOnERC721Received(
1063         address from,
1064         address to,
1065         uint256 tokenId,
1066         bytes memory _data
1067     ) private returns (bool) {
1068         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1069             bytes4 retval
1070         ) {
1071             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1072         } catch (bytes memory reason) {
1073             if (reason.length == 0) {
1074                 revert TransferToNonERC721ReceiverImplementer();
1075             } else {
1076                 assembly {
1077                     revert(add(32, reason), mload(reason))
1078                 }
1079             }
1080         }
1081     }
1082 
1083     /**
1084      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1085      * And also called before burning one token.
1086      *
1087      * startTokenId - the first token id to be transferred
1088      * quantity - the amount to be transferred
1089      *
1090      * Calling conditions:
1091      *
1092      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1093      * transferred to `to`.
1094      * - When `from` is zero, `tokenId` will be minted for `to`.
1095      * - When `to` is zero, `tokenId` will be burned by `from`.
1096      * - `from` and `to` are never both zero.
1097      */
1098     function _beforeTokenTransfers(
1099         address from,
1100         address to,
1101         uint256 startTokenId,
1102         uint256 quantity
1103     ) internal virtual {}
1104 
1105     /**
1106      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1107      * minting.
1108      * And also called after one token has been burned.
1109      *
1110      * startTokenId - the first token id to be transferred
1111      * quantity - the amount to be transferred
1112      *
1113      * Calling conditions:
1114      *
1115      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1116      * transferred to `to`.
1117      * - When `from` is zero, `tokenId` has been minted for `to`.
1118      * - When `to` is zero, `tokenId` has been burned by `from`.
1119      * - `from` and `to` are never both zero.
1120      */
1121     function _afterTokenTransfers(
1122         address from,
1123         address to,
1124         uint256 startTokenId,
1125         uint256 quantity
1126     ) internal virtual {}
1127 
1128     /**
1129      * @dev Returns the message sender (defaults to `msg.sender`).
1130      *
1131      * If you are writing GSN compatible contracts, you need to override this function.
1132      */
1133     function _msgSenderERC721A() internal view virtual returns (address) {
1134         return msg.sender;
1135     }
1136 
1137     /**
1138      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1139      */
1140     function _toString(uint256 value) internal pure returns (string memory ptr) {
1141         assembly {
1142             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1143             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1144             // We will need 1 32-byte word to store the length, 
1145             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1146             ptr := add(mload(0x40), 128)
1147             // Update the free memory pointer to allocate.
1148             mstore(0x40, ptr)
1149 
1150             // Cache the end of the memory to calculate the length later.
1151             let end := ptr
1152 
1153             // We write the string from the rightmost digit to the leftmost digit.
1154             // The following is essentially a do-while loop that also handles the zero case.
1155             // Costs a bit more than early returning for the zero case,
1156             // but cheaper in terms of deployment and overall runtime costs.
1157             for { 
1158                 // Initialize and perform the first pass without check.
1159                 let temp := value
1160                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1161                 ptr := sub(ptr, 1)
1162                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1163                 mstore8(ptr, add(48, mod(temp, 10)))
1164                 temp := div(temp, 10)
1165             } temp { 
1166                 // Keep dividing `temp` until zero.
1167                 temp := div(temp, 10)
1168             } { // Body of the for loop.
1169                 ptr := sub(ptr, 1)
1170                 mstore8(ptr, add(48, mod(temp, 10)))
1171             }
1172             
1173             let length := sub(end, ptr)
1174             // Move the pointer 32 bytes leftwards to make room for the length.
1175             ptr := sub(ptr, 32)
1176             // Store the length.
1177             mstore(ptr, length)
1178         }
1179     }
1180 }
1181 
1182 // File: @openzeppelin/contracts/utils/Strings.sol
1183 
1184 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
1185 
1186 pragma solidity ^0.8.0;
1187 
1188 /**
1189  * @dev String operations.
1190  */
1191 library Strings {
1192     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1193 
1194     /**
1195      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1196      */
1197     function toString(uint256 value) internal pure returns (string memory) {
1198         // Inspired by OraclizeAPI's implementation - MIT licence
1199         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1200 
1201         if (value == 0) {
1202             return "0";
1203         }
1204         uint256 temp = value;
1205         uint256 digits;
1206         while (temp != 0) {
1207             digits++;
1208             temp /= 10;
1209         }
1210         bytes memory buffer = new bytes(digits);
1211         while (value != 0) {
1212             digits -= 1;
1213             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1214             value /= 10;
1215         }
1216         return string(buffer);
1217     }
1218 
1219     /**
1220      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1221      */
1222     function toHexString(uint256 value) internal pure returns (string memory) {
1223         if (value == 0) {
1224             return "0x00";
1225         }
1226         uint256 temp = value;
1227         uint256 length = 0;
1228         while (temp != 0) {
1229             length++;
1230             temp >>= 8;
1231         }
1232         return toHexString(value, length);
1233     }
1234 
1235     /**
1236      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1237      */
1238     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1239         bytes memory buffer = new bytes(2 * length + 2);
1240         buffer[0] = "0";
1241         buffer[1] = "x";
1242         for (uint256 i = 2 * length + 1; i > 1; --i) {
1243             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1244             value >>= 4;
1245         }
1246         require(value == 0, "Strings: hex length insufficient");
1247         return string(buffer);
1248     }
1249 }
1250 
1251 // File: contracts/GoblinWomen.sol
1252 
1253 
1254 pragma solidity >=0.7.0 <0.9.0;
1255 
1256 
1257 
1258 contract GoblinWomen is Ownable, ERC721A {
1259   using Strings for uint256;
1260 
1261   string public uriPrefix = "ipfs://QmcfTQgWnLBjps2jUqSEmLnaFKnhaPjjLjYwpqhB7hGTVt/";
1262   string public uriSuffix = ".json";
1263   string public hiddenMetadataUri;
1264   
1265   uint256 public cost = 0.02 ether;
1266   uint256 public maxSupply = 10000;
1267   uint256 public maxMintAmountPerTx = 50;
1268   uint256 public maxMintAmount = 1;
1269 
1270   bool public paused = false;
1271   bool public revealed = true;
1272 
1273   mapping(address => uint256) public allowedlist;
1274 
1275   constructor() ERC721A("Goblin Women", "GW")  {
1276     setHiddenMetadataUri("");
1277   }
1278 
1279   modifier mintCompliance(uint256 _mintAmount) {
1280     require(totalSupply() + _mintAmount <= maxSupply, "Max supply exceeded!");
1281     require(!paused, "The contract is paused!");
1282     _;
1283   }
1284 
1285   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1286     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1287     if (allowedlist[msg.sender] > maxMintAmount) {
1288       require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1289     } else {
1290       if(_mintAmount > maxMintAmount) {
1291         uint256 _tempMintAmount = _mintAmount - maxMintAmount;
1292         require(msg.value >= cost * _tempMintAmount, "Insufficient funds!");
1293       }
1294     }
1295 
1296     allowedlist[msg.sender] = allowedlist[msg.sender] + _mintAmount;
1297 
1298     _safeMint(msg.sender, _mintAmount);
1299   }
1300   
1301   function mintForAddress(uint256 _mintAmount, address[] memory _receiver) public mintCompliance(_mintAmount) onlyOwner {
1302     for (uint256 i = 0; i < _receiver.length; i++) {
1303       _safeMint(_receiver[i], _mintAmount);
1304     }
1305   }
1306 
1307   function isAllowed(address _address) public view returns (uint256)  {
1308       return allowedlist[_address];
1309   }
1310 
1311   function walletOfOwner(address _owner)
1312     public
1313     view
1314     returns (uint256[] memory)
1315   {
1316     uint256 ownerTokenCount = balanceOf(_owner);
1317     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1318     uint256 currentTokenId = 1;
1319     uint256 ownedTokenIndex = 0;
1320 
1321     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1322       address currentTokenOwner = ownerOf(currentTokenId);
1323 
1324       if (currentTokenOwner == _owner) {
1325         ownedTokenIds[ownedTokenIndex] = currentTokenId+1;
1326 
1327         ownedTokenIndex++;
1328       }
1329 
1330       currentTokenId++;
1331     }
1332 
1333     return ownedTokenIds;
1334   }
1335 
1336   function tokenURI(uint256 _tokenId)
1337     public
1338     view
1339     virtual
1340     override
1341     returns (string memory)
1342   {
1343     require(
1344       _exists(_tokenId),
1345       "ERC721Metadata: URI query for nonexistent token"
1346     );
1347 
1348     if (revealed == false) {
1349       return hiddenMetadataUri;
1350     }
1351 
1352     string memory currentBaseURI = _baseURI();
1353     _tokenId = _tokenId+1;
1354     return bytes(currentBaseURI).length > 0
1355         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1356         : "";
1357   }
1358 
1359   function setRevealed(bool _state) public onlyOwner {
1360     revealed = _state;
1361   }
1362 
1363   function setCost(uint256 _cost) public onlyOwner {
1364     cost = _cost;
1365   }
1366 
1367   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1368     maxMintAmountPerTx = _maxMintAmountPerTx;
1369   }
1370 
1371   function setMaxMintAmount(uint256 _maxMintAmount) public onlyOwner {
1372     maxMintAmount = _maxMintAmount;
1373   }
1374 
1375   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1376     hiddenMetadataUri = _hiddenMetadataUri;
1377   }
1378 
1379   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1380     uriPrefix = _uriPrefix;
1381   }
1382 
1383   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1384     uriSuffix = _uriSuffix;
1385   }
1386 
1387   function setMaxSupply(uint256 _maxSupply) public onlyOwner {
1388     maxSupply = _maxSupply;
1389   }
1390 
1391   function setPaused(bool _state) public onlyOwner {
1392     paused = _state;
1393   }
1394 
1395   function withdraw() public onlyOwner {
1396     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1397     require(os);
1398   }
1399 
1400   function _baseURI() internal view virtual override returns (string memory) {
1401     return uriPrefix;
1402   }
1403 }