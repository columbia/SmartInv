1 // SPDX-License-Identifier: MIT
2 // File: contracts/WAAU.sol
3 
4 /**
5  *Submitted for verification at Etherscan.io on 2022-06-11
6 */
7 
8 /**
9  *Submitted for verification at Etherscan.io on 2022-06-10
10 */
11 
12 /**
13  *Submitted for verification at Etherscan.io on 2022-06-09
14 */
15 
16 /**
17  *Submitted for verification at Etherscan.io on 2022-06-02
18 */
19 
20 // File: @openzeppelin/contracts/utils/Context.sol
21 
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
49 
50 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
51 
52 pragma solidity ^0.8.0;
53 
54 
55 /**
56  * @dev Contract module which provides a basic access control mechanism, where
57  * there is an account (an owner) that can be granted exclusive access to
58  * specific functions.
59  *
60  * By default, the owner account will be the one that deploys the contract. This
61  * can later be changed with {transferOwnership}.
62  *
63  * This module is used through inheritance. It will make available the modifier
64  * `onlyOwner`, which can be applied to your functions to restrict their use to
65  * the owner.
66  */
67 abstract contract Ownable is Context {
68     address private _owner;
69 
70     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
71 
72     /**
73      * @dev Initializes the contract setting the deployer as the initial owner.
74      */
75     constructor() {
76         _transferOwnership(_msgSender());
77     }
78 
79     /**
80      * @dev Returns the address of the current owner.
81      */
82     function owner() public view virtual returns (address) {
83         return _owner;
84     }
85 
86     /**
87      * @dev Throws if called by any account other than the owner.
88      */
89     modifier onlyOwner() {
90         require(owner() == _msgSender(), "Ownable: caller is not the owner");
91         _;
92     }
93 
94     /**
95      * @dev Leaves the contract without owner. It will not be possible to call
96      * `onlyOwner` functions anymore. Can only be called by the current owner.
97      *
98      * NOTE: Renouncing ownership will leave the contract without an owner,
99      * thereby removing any functionality that is only available to the owner.
100      */
101     function renounceOwnership() public virtual onlyOwner {
102         _transferOwnership(address(0));
103     }
104 
105     /**
106      * @dev Transfers ownership of the contract to a new account (`newOwner`).
107      * Can only be called by the current owner.
108      */
109     function transferOwnership(address newOwner) public virtual onlyOwner {
110         require(newOwner != address(0), "Ownable: new owner is the zero address");
111         _transferOwnership(newOwner);
112     }
113 
114     /**
115      * @dev Transfers ownership of the contract to a new account (`newOwner`).
116      * Internal function without access restriction.
117      */
118     function _transferOwnership(address newOwner) internal virtual {
119         address oldOwner = _owner;
120         _owner = newOwner;
121         emit OwnershipTransferred(oldOwner, newOwner);
122     }
123 }
124 
125 // File: erc721a/contracts/IERC721A.sol
126 
127 
128 // ERC721A Contracts v4.0.0
129 // Creator: Chiru Labs
130 
131 pragma solidity ^0.8.4;
132 
133 /**
134  * @dev Interface of an ERC721A compliant contract.
135  */
136 interface IERC721A {
137     /**
138      * The caller must own the token or be an approved operator.
139      */
140     error ApprovalCallerNotOwnerNorApproved();
141 
142     /**
143      * The token does not exist.
144      */
145     error ApprovalQueryForNonexistentToken();
146 
147     /**
148      * The caller cannot approve to their own address.
149      */
150     error ApproveToCaller();
151 
152     /**
153      * The caller cannot approve to the current owner.
154      */
155     error ApprovalToCurrentOwner();
156 
157     /**
158      * Cannot query the balance for the zero address.
159      */
160     error BalanceQueryForZeroAddress();
161 
162     /**
163      * Cannot mint to the zero address.
164      */
165     error MintToZeroAddress();
166 
167     /**
168      * The quantity of tokens minted must be more than zero.
169      */
170     error MintZeroQuantity();
171 
172     /**
173      * The token does not exist.
174      */
175     error OwnerQueryForNonexistentToken();
176 
177     /**
178      * The caller must own the token or be an approved operator.
179      */
180     error TransferCallerNotOwnerNorApproved();
181 
182     /**
183      * The token must be owned by `from`.
184      */
185     error TransferFromIncorrectOwner();
186 
187     /**
188      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
189      */
190     error TransferToNonERC721ReceiverImplementer();
191 
192     /**
193      * Cannot transfer to the zero address.
194      */
195     error TransferToZeroAddress();
196 
197     /**
198      * The token does not exist.
199      */
200     error URIQueryForNonexistentToken();
201 
202     struct TokenOwnership {
203         // The address of the owner.
204         address addr;
205         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
206         uint64 startTimestamp;
207         // Whether the token has been burned.
208         bool burned;
209     }
210 
211     /**
212      * @dev Returns the total amount of tokens stored by the contract.
213      *
214      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
215      */
216     function totalSupply() external view returns (uint256);
217 
218     // ==============================
219     //            IERC165
220     // ==============================
221 
222     /**
223      * @dev Returns true if this contract implements the interface defined by
224      * `interfaceId`. See the corresponding
225      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
226      * to learn more about how these ids are created.
227      *
228      * This function call must use less than 30 000 gas.
229      */
230     function supportsInterface(bytes4 interfaceId) external view returns (bool);
231 
232     // ==============================
233     //            IERC721
234     // ==============================
235 
236     /**
237      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
238      */
239     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
240 
241     /**
242      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
243      */
244     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
245 
246     /**
247      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
248      */
249     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
250 
251     /**
252      * @dev Returns the number of tokens in ``owner``'s account.
253      */
254     function balanceOf(address owner) external view returns (uint256 balance);
255 
256     /**
257      * @dev Returns the owner of the `tokenId` token.
258      *
259      * Requirements:
260      *
261      * - `tokenId` must exist.
262      */
263     function ownerOf(uint256 tokenId) external view returns (address owner);
264 
265     /**
266      * @dev Safely transfers `tokenId` token from `from` to `to`.
267      *
268      * Requirements:
269      *
270      * - `from` cannot be the zero address.
271      * - `to` cannot be the zero address.
272      * - `tokenId` token must exist and be owned by `from`.
273      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
274      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
275      *
276      * Emits a {Transfer} event.
277      */
278     function safeTransferFrom(
279         address from,
280         address to,
281         uint256 tokenId,
282         bytes calldata data
283     ) external;
284 
285     /**
286      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
287      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
288      *
289      * Requirements:
290      *
291      * - `from` cannot be the zero address.
292      * - `to` cannot be the zero address.
293      * - `tokenId` token must exist and be owned by `from`.
294      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
295      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
296      *
297      * Emits a {Transfer} event.
298      */
299     function safeTransferFrom(
300         address from,
301         address to,
302         uint256 tokenId
303     ) external;
304 
305     /**
306      * @dev Transfers `tokenId` token from `from` to `to`.
307      *
308      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
309      *
310      * Requirements:
311      *
312      * - `from` cannot be the zero address.
313      * - `to` cannot be the zero address.
314      * - `tokenId` token must be owned by `from`.
315      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
316      *
317      * Emits a {Transfer} event.
318      */
319     function transferFrom(
320         address from,
321         address to,
322         uint256 tokenId
323     ) external;
324 
325     /**
326      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
327      * The approval is cleared when the token is transferred.
328      *
329      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
330      *
331      * Requirements:
332      *
333      * - The caller must own the token or be an approved operator.
334      * - `tokenId` must exist.
335      *
336      * Emits an {Approval} event.
337      */
338     function approve(address to, uint256 tokenId) external;
339 
340     /**
341      * @dev Approve or remove `operator` as an operator for the caller.
342      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
343      *
344      * Requirements:
345      *
346      * - The `operator` cannot be the caller.
347      *
348      * Emits an {ApprovalForAll} event.
349      */
350     function setApprovalForAll(address operator, bool _approved) external;
351 
352     /**
353      * @dev Returns the account approved for `tokenId` token.
354      *
355      * Requirements:
356      *
357      * - `tokenId` must exist.
358      */
359     function getApproved(uint256 tokenId) external view returns (address operator);
360 
361     /**
362      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
363      *
364      * See {setApprovalForAll}
365      */
366     function isApprovedForAll(address owner, address operator) external view returns (bool);
367 
368     // ==============================
369     //        IERC721Metadata
370     // ==============================
371 
372     /**
373      * @dev Returns the token collection name.
374      */
375     function name() external view returns (string memory);
376 
377     /**
378      * @dev Returns the token collection symbol.
379      */
380     function symbol() external view returns (string memory);
381 
382     /**
383      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
384      */
385     function tokenURI(uint256 tokenId) external view returns (string memory);
386 }
387 
388 // File: erc721a/contracts/ERC721A.sol
389 
390 
391 // ERC721A Contracts v4.0.0
392 // Creator: Chiru Labs
393 
394 pragma solidity ^0.8.4;
395 
396 
397 /**
398  * @dev ERC721 token receiver interface.
399  */
400 interface ERC721A__IERC721Receiver {
401     function onERC721Received(
402         address operator,
403         address from,
404         uint256 tokenId,
405         bytes calldata data
406     ) external returns (bytes4);
407 }
408 
409 /**
410  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
411  * the Metadata extension. Built to optimize for lower gas during batch mints.
412  *
413  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
414  *
415  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
416  *
417  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
418  */
419 contract ERC721A is IERC721A {
420     // Mask of an entry in packed address data.
421     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
422 
423     // The bit position of `numberMinted` in packed address data.
424     uint256 private constant BITPOS_NUMBER_MINTED = 64;
425 
426     // The bit position of `numberBurned` in packed address data.
427     uint256 private constant BITPOS_NUMBER_BURNED = 128;
428 
429     // The bit position of `aux` in packed address data.
430     uint256 private constant BITPOS_AUX = 192;
431 
432     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
433     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
434 
435     // The bit position of `startTimestamp` in packed ownership.
436     uint256 private constant BITPOS_START_TIMESTAMP = 160;
437 
438     // The bit mask of the `burned` bit in packed ownership.
439     uint256 private constant BITMASK_BURNED = 1 << 224;
440     
441     // The bit position of the `nextInitialized` bit in packed ownership.
442     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
443 
444     // The bit mask of the `nextInitialized` bit in packed ownership.
445     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
446 
447     // The tokenId of the next token to be minted.
448     uint256 private _currentIndex;
449 
450     // The number of tokens burned.
451     uint256 private _burnCounter;
452 
453     // Token name
454     string private _name;
455 
456     // Token symbol
457     string private _symbol;
458 
459     // Mapping from token ID to ownership details
460     // An empty struct value does not necessarily mean the token is unowned.
461     // See `_packedOwnershipOf` implementation for details.
462     //
463     // Bits Layout:
464     // - [0..159]   `addr`
465     // - [160..223] `startTimestamp`
466     // - [224]      `burned`
467     // - [225]      `nextInitialized`
468     mapping(uint256 => uint256) private _packedOwnerships;
469 
470     // Mapping owner address to address data.
471     //
472     // Bits Layout:
473     // - [0..63]    `balance`
474     // - [64..127]  `numberMinted`
475     // - [128..191] `numberBurned`
476     // - [192..255] `aux`
477     mapping(address => uint256) private _packedAddressData;
478 
479     // Mapping from token ID to approved address.
480     mapping(uint256 => address) private _tokenApprovals;
481 
482     // Mapping from owner to operator approvals
483     mapping(address => mapping(address => bool)) private _operatorApprovals;
484 
485     constructor(string memory name_, string memory symbol_) {
486         _name = name_;
487         _symbol = symbol_;
488         _currentIndex = _startTokenId();
489     }
490 
491     /**
492      * @dev Returns the starting token ID. 
493      * To change the starting token ID, please override this function.
494      */
495     function _startTokenId() internal view virtual returns (uint256) {
496         return 0;
497     }
498 
499     /**
500      * @dev Returns the next token ID to be minted.
501      */
502     function _nextTokenId() internal view returns (uint256) {
503         return _currentIndex;
504     }
505 
506     /**
507      * @dev Returns the total number of tokens in existence.
508      * Burned tokens will reduce the count. 
509      * To get the total number of tokens minted, please see `_totalMinted`.
510      */
511     function totalSupply() public view override returns (uint256) {
512         // Counter underflow is impossible as _burnCounter cannot be incremented
513         // more than `_currentIndex - _startTokenId()` times.
514         unchecked {
515             return _currentIndex - _burnCounter - _startTokenId();
516         }
517     }
518 
519     /**
520      * @dev Returns the total amount of tokens minted in the contract.
521      */
522     function _totalMinted() internal view returns (uint256) {
523         // Counter underflow is impossible as _currentIndex does not decrement,
524         // and it is initialized to `_startTokenId()`
525         unchecked {
526             return _currentIndex - _startTokenId();
527         }
528     }
529 
530     /**
531      * @dev Returns the total number of tokens burned.
532      */
533     function _totalBurned() internal view returns (uint256) {
534         return _burnCounter;
535     }
536 
537     /**
538      * @dev See {IERC165-supportsInterface}.
539      */
540     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
541         // The interface IDs are constants representing the first 4 bytes of the XOR of
542         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
543         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
544         return
545             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
546             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
547             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
548     }
549 
550     /**
551      * @dev See {IERC721-balanceOf}.
552      */
553     function balanceOf(address owner) public view override returns (uint256) {
554         if (owner == address(0)) revert BalanceQueryForZeroAddress();
555         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
556     }
557 
558     /**
559      * Returns the number of tokens minted by `owner`.
560      */
561     function _numberMinted(address owner) internal view returns (uint256) {
562         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
563     }
564 
565     /**
566      * Returns the number of tokens burned by or on behalf of `owner`.
567      */
568     function _numberBurned(address owner) internal view returns (uint256) {
569         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
570     }
571 
572     /**
573      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
574      */
575     function _getAux(address owner) internal view returns (uint64) {
576         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
577     }
578 
579     /**
580      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
581      * If there are multiple variables, please pack them into a uint64.
582      */
583     function _setAux(address owner, uint64 aux) internal {
584         uint256 packed = _packedAddressData[owner];
585         uint256 auxCasted;
586         assembly { // Cast aux without masking.
587             auxCasted := aux
588         }
589         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
590         _packedAddressData[owner] = packed;
591     }
592 
593     /**
594      * Returns the packed ownership data of `tokenId`.
595      */
596     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
597         uint256 curr = tokenId;
598 
599         unchecked {
600             if (_startTokenId() <= curr)
601                 if (curr < _currentIndex) {
602                     uint256 packed = _packedOwnerships[curr];
603                     // If not burned.
604                     if (packed & BITMASK_BURNED == 0) {
605                         // Invariant:
606                         // There will always be an ownership that has an address and is not burned
607                         // before an ownership that does not have an address and is not burned.
608                         // Hence, curr will not underflow.
609                         //
610                         // We can directly compare the packed value.
611                         // If the address is zero, packed is zero.
612                         while (packed == 0) {
613                             packed = _packedOwnerships[--curr];
614                         }
615                         return packed;
616                     }
617                 }
618         }
619         revert OwnerQueryForNonexistentToken();
620     }
621 
622     /**
623      * Returns the unpacked `TokenOwnership` struct from `packed`.
624      */
625     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
626         ownership.addr = address(uint160(packed));
627         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
628         ownership.burned = packed & BITMASK_BURNED != 0;
629     }
630 
631     /**
632      * Returns the unpacked `TokenOwnership` struct at `index`.
633      */
634     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
635         return _unpackedOwnership(_packedOwnerships[index]);
636     }
637 
638     /**
639      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
640      */
641     function _initializeOwnershipAt(uint256 index) internal {
642         if (_packedOwnerships[index] == 0) {
643             _packedOwnerships[index] = _packedOwnershipOf(index);
644         }
645     }
646 
647     /**
648      * Gas spent here starts off proportional to the maximum mint batch size.
649      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
650      */
651     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
652         return _unpackedOwnership(_packedOwnershipOf(tokenId));
653     }
654 
655     /**
656      * @dev See {IERC721-ownerOf}.
657      */
658     function ownerOf(uint256 tokenId) public view override returns (address) {
659         return address(uint160(_packedOwnershipOf(tokenId)));
660     }
661 
662     /**
663      * @dev See {IERC721Metadata-name}.
664      */
665     function name() public view virtual override returns (string memory) {
666         return _name;
667     }
668 
669     /**
670      * @dev See {IERC721Metadata-symbol}.
671      */
672     function symbol() public view virtual override returns (string memory) {
673         return _symbol;
674     }
675 
676     /**
677      * @dev See {IERC721Metadata-tokenURI}.
678      */
679     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
680         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
681 
682         string memory baseURI = _baseURI();
683         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
684     }
685 
686     /**
687      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
688      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
689      * by default, can be overriden in child contracts.
690      */
691     function _baseURI() internal view virtual returns (string memory) {
692         return '';
693     }
694 
695     /**
696      * @dev Casts the address to uint256 without masking.
697      */
698     function _addressToUint256(address value) private pure returns (uint256 result) {
699         assembly {
700             result := value
701         }
702     }
703 
704     /**
705      * @dev Casts the boolean to uint256 without branching.
706      */
707     function _boolToUint256(bool value) private pure returns (uint256 result) {
708         assembly {
709             result := value
710         }
711     }
712 
713     /**
714      * @dev See {IERC721-approve}.
715      */
716     function approve(address to, uint256 tokenId) public override {
717         address owner = address(uint160(_packedOwnershipOf(tokenId)));
718         if (to == owner) revert ApprovalToCurrentOwner();
719 
720         if (_msgSenderERC721A() != owner)
721             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
722                 revert ApprovalCallerNotOwnerNorApproved();
723             }
724 
725         _tokenApprovals[tokenId] = to;
726         emit Approval(owner, to, tokenId);
727     }
728 
729     /**
730      * @dev See {IERC721-getApproved}.
731      */
732     function getApproved(uint256 tokenId) public view override returns (address) {
733         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
734 
735         return _tokenApprovals[tokenId];
736     }
737 
738     /**
739      * @dev See {IERC721-setApprovalForAll}.
740      */
741     function setApprovalForAll(address operator, bool approved) public virtual override {
742         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
743 
744         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
745         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
746     }
747 
748     /**
749      * @dev See {IERC721-isApprovedForAll}.
750      */
751     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
752         return _operatorApprovals[owner][operator];
753     }
754 
755     /**
756      * @dev See {IERC721-transferFrom}.
757      */
758     function transferFrom(
759         address from,
760         address to,
761         uint256 tokenId
762     ) public virtual override {
763         _transfer(from, to, tokenId);
764     }
765 
766     /**
767      * @dev See {IERC721-safeTransferFrom}.
768      */
769     function safeTransferFrom(
770         address from,
771         address to,
772         uint256 tokenId
773     ) public virtual override {
774         safeTransferFrom(from, to, tokenId, '');
775     }
776 
777     /**
778      * @dev See {IERC721-safeTransferFrom}.
779      */
780     function safeTransferFrom(
781         address from,
782         address to,
783         uint256 tokenId,
784         bytes memory _data
785     ) public virtual override {
786         _transfer(from, to, tokenId);
787         if (to.code.length != 0)
788             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
789                 revert TransferToNonERC721ReceiverImplementer();
790             }
791     }
792 
793     /**
794      * @dev Returns whether `tokenId` exists.
795      *
796      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
797      *
798      * Tokens start existing when they are minted (`_mint`),
799      */
800     function _exists(uint256 tokenId) internal view returns (bool) {
801         return
802             _startTokenId() <= tokenId &&
803             tokenId < _currentIndex && // If within bounds,
804             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
805     }
806 
807     /**
808      * @dev Equivalent to `_safeMint(to, quantity, '')`.
809      */
810     function _safeMint(address to, uint256 quantity) internal {
811         _safeMint(to, quantity, '');
812     }
813 
814     /**
815      * @dev Safely mints `quantity` tokens and transfers them to `to`.
816      *
817      * Requirements:
818      *
819      * - If `to` refers to a smart contract, it must implement
820      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
821      * - `quantity` must be greater than 0.
822      *
823      * Emits a {Transfer} event.
824      */
825     function _safeMint(
826         address to,
827         uint256 quantity,
828         bytes memory _data
829     ) internal {
830         uint256 startTokenId = _currentIndex;
831         if (to == address(0)) revert MintToZeroAddress();
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
857             uint256 updatedIndex = startTokenId;
858             uint256 end = updatedIndex + quantity;
859 
860             if (to.code.length != 0) {
861                 do {
862                     emit Transfer(address(0), to, updatedIndex);
863                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
864                         revert TransferToNonERC721ReceiverImplementer();
865                     }
866                 } while (updatedIndex < end);
867                 // Reentrancy protection
868                 if (_currentIndex != startTokenId) revert();
869             } else {
870                 do {
871                     emit Transfer(address(0), to, updatedIndex++);
872                 } while (updatedIndex < end);
873             }
874             _currentIndex = updatedIndex;
875         }
876         _afterTokenTransfers(address(0), to, startTokenId, quantity);
877     }
878 
879     /**
880      * @dev Mints `quantity` tokens and transfers them to `to`.
881      *
882      * Requirements:
883      *
884      * - `to` cannot be the zero address.
885      * - `quantity` must be greater than 0.
886      *
887      * Emits a {Transfer} event.
888      */
889     function _mint(address to, uint256 quantity) internal {
890         uint256 startTokenId = _currentIndex;
891         if (to == address(0)) revert MintToZeroAddress();
892         if (quantity == 0) revert MintZeroQuantity();
893 
894         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
895 
896         // Overflows are incredibly unrealistic.
897         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
898         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
899         unchecked {
900             // Updates:
901             // - `balance += quantity`.
902             // - `numberMinted += quantity`.
903             //
904             // We can directly add to the balance and number minted.
905             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
906 
907             // Updates:
908             // - `address` to the owner.
909             // - `startTimestamp` to the timestamp of minting.
910             // - `burned` to `false`.
911             // - `nextInitialized` to `quantity == 1`.
912             _packedOwnerships[startTokenId] =
913                 _addressToUint256(to) |
914                 (block.timestamp << BITPOS_START_TIMESTAMP) |
915                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
916 
917             uint256 updatedIndex = startTokenId;
918             uint256 end = updatedIndex + quantity;
919 
920             do {
921                 emit Transfer(address(0), to, updatedIndex++);
922             } while (updatedIndex < end);
923 
924             _currentIndex = updatedIndex;
925         }
926         _afterTokenTransfers(address(0), to, startTokenId, quantity);
927     }
928 
929     /**
930      * @dev Transfers `tokenId` from `from` to `to`.
931      *
932      * Requirements:
933      *
934      * - `to` cannot be the zero address.
935      * - `tokenId` token must be owned by `from`.
936      *
937      * Emits a {Transfer} event.
938      */
939     function _transfer(
940         address from,
941         address to,
942         uint256 tokenId
943     ) private {
944         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
945 
946         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
947 
948         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
949             isApprovedForAll(from, _msgSenderERC721A()) ||
950             getApproved(tokenId) == _msgSenderERC721A());
951 
952         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
953         if (to == address(0)) revert TransferToZeroAddress();
954 
955         _beforeTokenTransfers(from, to, tokenId, 1);
956 
957         // Clear approvals from the previous owner.
958         delete _tokenApprovals[tokenId];
959 
960         // Underflow of the sender's balance is impossible because we check for
961         // ownership above and the recipient's balance can't realistically overflow.
962         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
963         unchecked {
964             // We can directly increment and decrement the balances.
965             --_packedAddressData[from]; // Updates: `balance -= 1`.
966             ++_packedAddressData[to]; // Updates: `balance += 1`.
967 
968             // Updates:
969             // - `address` to the next owner.
970             // - `startTimestamp` to the timestamp of transfering.
971             // - `burned` to `false`.
972             // - `nextInitialized` to `true`.
973             _packedOwnerships[tokenId] =
974                 _addressToUint256(to) |
975                 (block.timestamp << BITPOS_START_TIMESTAMP) |
976                 BITMASK_NEXT_INITIALIZED;
977 
978             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
979             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
980                 uint256 nextTokenId = tokenId + 1;
981                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
982                 if (_packedOwnerships[nextTokenId] == 0) {
983                     // If the next slot is within bounds.
984                     if (nextTokenId != _currentIndex) {
985                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
986                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
987                     }
988                 }
989             }
990         }
991 
992         emit Transfer(from, to, tokenId);
993         _afterTokenTransfers(from, to, tokenId, 1);
994     }
995 
996     /**
997      * @dev Equivalent to `_burn(tokenId, false)`.
998      */
999     function _burn(uint256 tokenId) internal virtual {
1000         _burn(tokenId, false);
1001     }
1002 
1003     /**
1004      * @dev Destroys `tokenId`.
1005      * The approval is cleared when the token is burned.
1006      *
1007      * Requirements:
1008      *
1009      * - `tokenId` must exist.
1010      *
1011      * Emits a {Transfer} event.
1012      */
1013     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1014         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1015 
1016         address from = address(uint160(prevOwnershipPacked));
1017 
1018         if (approvalCheck) {
1019             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1020                 isApprovedForAll(from, _msgSenderERC721A()) ||
1021                 getApproved(tokenId) == _msgSenderERC721A());
1022 
1023             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1024         }
1025 
1026         _beforeTokenTransfers(from, address(0), tokenId, 1);
1027 
1028         // Clear approvals from the previous owner.
1029         delete _tokenApprovals[tokenId];
1030 
1031         // Underflow of the sender's balance is impossible because we check for
1032         // ownership above and the recipient's balance can't realistically overflow.
1033         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1034         unchecked {
1035             // Updates:
1036             // - `balance -= 1`.
1037             // - `numberBurned += 1`.
1038             //
1039             // We can directly decrement the balance, and increment the number burned.
1040             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1041             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1042 
1043             // Updates:
1044             // - `address` to the last owner.
1045             // - `startTimestamp` to the timestamp of burning.
1046             // - `burned` to `true`.
1047             // - `nextInitialized` to `true`.
1048             _packedOwnerships[tokenId] =
1049                 _addressToUint256(from) |
1050                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1051                 BITMASK_BURNED | 
1052                 BITMASK_NEXT_INITIALIZED;
1053 
1054             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1055             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1056                 uint256 nextTokenId = tokenId + 1;
1057                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1058                 if (_packedOwnerships[nextTokenId] == 0) {
1059                     // If the next slot is within bounds.
1060                     if (nextTokenId != _currentIndex) {
1061                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1062                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1063                     }
1064                 }
1065             }
1066         }
1067 
1068         emit Transfer(from, address(0), tokenId);
1069         _afterTokenTransfers(from, address(0), tokenId, 1);
1070 
1071         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1072         unchecked {
1073             _burnCounter++;
1074         }
1075     }
1076 
1077     /**
1078      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1079      *
1080      * @param from address representing the previous owner of the given token ID
1081      * @param to target address that will receive the tokens
1082      * @param tokenId uint256 ID of the token to be transferred
1083      * @param _data bytes optional data to send along with the call
1084      * @return bool whether the call correctly returned the expected magic value
1085      */
1086     function _checkContractOnERC721Received(
1087         address from,
1088         address to,
1089         uint256 tokenId,
1090         bytes memory _data
1091     ) private returns (bool) {
1092         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1093             bytes4 retval
1094         ) {
1095             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1096         } catch (bytes memory reason) {
1097             if (reason.length == 0) {
1098                 revert TransferToNonERC721ReceiverImplementer();
1099             } else {
1100                 assembly {
1101                     revert(add(32, reason), mload(reason))
1102                 }
1103             }
1104         }
1105     }
1106 
1107     /**
1108      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1109      * And also called before burning one token.
1110      *
1111      * startTokenId - the first token id to be transferred
1112      * quantity - the amount to be transferred
1113      *
1114      * Calling conditions:
1115      *
1116      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1117      * transferred to `to`.
1118      * - When `from` is zero, `tokenId` will be minted for `to`.
1119      * - When `to` is zero, `tokenId` will be burned by `from`.
1120      * - `from` and `to` are never both zero.
1121      */
1122     function _beforeTokenTransfers(
1123         address from,
1124         address to,
1125         uint256 startTokenId,
1126         uint256 quantity
1127     ) internal virtual {}
1128 
1129     /**
1130      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1131      * minting.
1132      * And also called after one token has been burned.
1133      *
1134      * startTokenId - the first token id to be transferred
1135      * quantity - the amount to be transferred
1136      *
1137      * Calling conditions:
1138      *
1139      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1140      * transferred to `to`.
1141      * - When `from` is zero, `tokenId` has been minted for `to`.
1142      * - When `to` is zero, `tokenId` has been burned by `from`.
1143      * - `from` and `to` are never both zero.
1144      */
1145     function _afterTokenTransfers(
1146         address from,
1147         address to,
1148         uint256 startTokenId,
1149         uint256 quantity
1150     ) internal virtual {}
1151 
1152     /**
1153      * @dev Returns the message sender (defaults to `msg.sender`).
1154      *
1155      * If you are writing GSN compatible contracts, you need to override this function.
1156      */
1157     function _msgSenderERC721A() internal view virtual returns (address) {
1158         return msg.sender;
1159     }
1160 
1161     /**
1162      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1163      */
1164     function _toString(uint256 value) internal pure returns (string memory ptr) {
1165         assembly {
1166             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1167             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1168             // We will need 1 32-byte word to store the length, 
1169             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1170             ptr := add(mload(0x40), 128)
1171             // Update the free memory pointer to allocate.
1172             mstore(0x40, ptr)
1173 
1174             // Cache the end of the memory to calculate the length later.
1175             let end := ptr
1176 
1177             // We write the string from the rightmost digit to the leftmost digit.
1178             // The following is essentially a do-while loop that also handles the zero case.
1179             // Costs a bit more than early returning for the zero case,
1180             // but cheaper in terms of deployment and overall runtime costs.
1181             for { 
1182                 // Initialize and perform the first pass without check.
1183                 let temp := value
1184                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1185                 ptr := sub(ptr, 1)
1186                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1187                 mstore8(ptr, add(48, mod(temp, 10)))
1188                 temp := div(temp, 10)
1189             } temp { 
1190                 // Keep dividing `temp` until zero.
1191                 temp := div(temp, 10)
1192             } { // Body of the for loop.
1193                 ptr := sub(ptr, 1)
1194                 mstore8(ptr, add(48, mod(temp, 10)))
1195             }
1196             
1197             let length := sub(end, ptr)
1198             // Move the pointer 32 bytes leftwards to make room for the length.
1199             ptr := sub(ptr, 32)
1200             // Store the length.
1201             mstore(ptr, length)
1202         }
1203     }
1204 }
1205 
1206 // File: nft.sol
1207 
1208 pragma solidity ^0.8.13;
1209 
1210 
1211 
1212 contract WAAU is Ownable, ERC721A {
1213     uint256 public maxSupply                    = 1501;
1214     uint256 public maxFreeSupply                = 1501;
1215     
1216     uint256 public maxPerTxDuringMint           = 10;
1217     uint256 public maxPerAddressDuringMint      = 101;
1218     uint256 public maxPerAddressDuringFreeMint  = 1;
1219     
1220     uint256 public price                        = 0.004 ether;
1221     bool    public saleIsActive                 = false;
1222 
1223     address constant internal TEAM_ADDRESS = 0x0b1f9E8Ef1C1Da1a90feE15f8859E79DA11745B2;
1224 
1225     string private _baseTokenURI;
1226 
1227     mapping(address => uint256) public freeMintedAmount;
1228     mapping(address => uint256) public mintedAmount;
1229 
1230     constructor() ERC721A("We Are All Unemployed", "WAAU") {
1231         _safeMint(msg.sender, 100);
1232     }
1233 
1234     modifier mintCompliance() {
1235         require(saleIsActive, "Sale is not active yet.");
1236         require(tx.origin == msg.sender, "Wrong Caller");
1237         _;
1238     }
1239 
1240     function mint(uint256 _quantity) external payable mintCompliance() {
1241         require(
1242             msg.value >= price * _quantity,
1243             "GDZ: Insufficient Fund."
1244         );
1245         require(
1246             maxSupply >= totalSupply() + _quantity,
1247             "GDZ: Exceeds max supply."
1248         );
1249         uint256 _mintedAmount = mintedAmount[msg.sender];
1250         require(
1251             _mintedAmount + _quantity <= maxPerAddressDuringMint,
1252             "GDZ: Exceeds max mints per address!"
1253         );
1254         require(
1255             _quantity > 0 && _quantity <= maxPerTxDuringMint,
1256             "Invalid mint amount."
1257         );
1258         mintedAmount[msg.sender] = _mintedAmount + _quantity;
1259         _safeMint(msg.sender, _quantity);
1260     }
1261 
1262     function freeMint(uint256 _quantity) external mintCompliance() {
1263         require(
1264             maxFreeSupply >= totalSupply() + _quantity,
1265             "GDZ: Exceeds max supply."
1266         );
1267         uint256 _freeMintedAmount = freeMintedAmount[msg.sender];
1268         require(
1269             _freeMintedAmount + _quantity <= maxPerAddressDuringFreeMint,
1270             "GDZ: Exceeds max free mints per address!"
1271         );
1272         freeMintedAmount[msg.sender] = _freeMintedAmount + _quantity;
1273         _safeMint(msg.sender, _quantity);
1274     }
1275 
1276     function setPrice(uint256 _price) external onlyOwner {
1277         price = _price;
1278     }
1279 
1280     function setMaxPerTx(uint256 _amount) external onlyOwner {
1281         maxPerTxDuringMint = _amount;
1282     }
1283 
1284     function setMaxPerAddress(uint256 _amount) external onlyOwner {
1285         maxPerAddressDuringMint = _amount;
1286     }
1287 
1288     function setMaxFreePerAddress(uint256 _amount) external onlyOwner {
1289         maxPerAddressDuringFreeMint = _amount;
1290     }
1291 
1292     function flipSale() public onlyOwner {
1293         saleIsActive = !saleIsActive;
1294     }
1295 
1296     function cutMaxSupply(uint256 _amount) public onlyOwner {
1297         require(
1298             maxSupply - _amount >= totalSupply(), 
1299             "Supply cannot fall below minted tokens."
1300         );
1301         maxSupply -= _amount;
1302     }
1303 
1304     function setBaseURI(string calldata baseURI) external onlyOwner {
1305         _baseTokenURI = baseURI;
1306     }
1307 
1308     function _baseURI() internal view virtual override returns (string memory) {
1309         return _baseTokenURI;
1310     }
1311 
1312     function withdrawBalance() external payable onlyOwner {
1313 
1314         (bool success, ) = payable(TEAM_ADDRESS).call{
1315             value: address(this).balance
1316         }("");
1317         require(success, "transfer failed.");
1318     }
1319 }