1 /**
2  *Submitted for verification at Etherscan.io on 2022-08-12
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2022-07-08
7 */
8 
9 // SPDX-License-Identifier: MIT
10 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
11 
12 pragma solidity ^0.8.0;
13 
14 /**
15  * @dev Provides information about the current execution context, including the
16  * sender of the transaction and its data. While these are generally available
17  * via msg.sender and msg.data, they should not be accessed in such a direct
18  * manner, since when dealing with meta-transactions the account sending and
19  * paying for execution may not be the actual sender (as far as an application
20  * is concerned).
21  *
22  * This contract is only required for intermediate, library-like contracts.
23  */
24 abstract contract Context {
25     function _msgSender() internal view virtual returns (address) {
26         return msg.sender;
27     }
28 
29     function _msgData() internal view virtual returns (bytes calldata) {
30         return msg.data;
31     }
32 }
33 
34 // ERC721A Contracts v4.0.0
35 // Creator: Chiru Labs
36 
37 pragma solidity ^0.8.4;
38 
39 /**
40  * @dev Interface of an ERC721A compliant contract.
41  */
42 interface IERC721A {
43     /**
44      * The caller must own the token or be an approved operator.
45      */
46     error ApprovalCallerNotOwnerNorApproved();
47 
48     /**
49      * The token does not exist.
50      */
51     error ApprovalQueryForNonexistentToken();
52 
53     /**
54      * The caller cannot approve to their own address.
55      */
56     error ApproveToCaller();
57 
58     /**
59      * The caller cannot approve to the current owner.
60      */
61     error ApprovalToCurrentOwner();
62 
63     /**
64      * Cannot query the balance for the zero address.
65      */
66     error BalanceQueryForZeroAddress();
67 
68     /**
69      * Cannot mint to the zero address.
70      */
71     error MintToZeroAddress();
72 
73     /**
74      * The quantity of tokens minted must be more than zero.
75      */
76     error MintZeroQuantity();
77 
78     /**
79      * The token does not exist.
80      */
81     error OwnerQueryForNonexistentToken();
82 
83     /**
84      * The caller must own the token or be an approved operator.
85      */
86     error TransferCallerNotOwnerNorApproved();
87 
88     /**
89      * The token must be owned by `from`.
90      */
91     error TransferFromIncorrectOwner();
92 
93     /**
94      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
95      */
96     error TransferToNonERC721ReceiverImplementer();
97 
98     /**
99      * Cannot transfer to the zero address.
100      */
101     error TransferToZeroAddress();
102 
103     /**
104      * The token does not exist.
105      */
106     error URIQueryForNonexistentToken();
107 
108     struct TokenOwnership {
109         // The address of the owner.
110         address addr;
111         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
112         uint64 startTimestamp;
113         // Whether the token has been burned.
114         bool burned;
115     }
116 
117     /**
118      * @dev Returns the total amount of tokens stored by the contract.
119      *
120      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
121      */
122     function totalSupply() external view returns (uint256);
123 
124     // ==============================
125     //            IERC165
126     // ==============================
127 
128     /**
129      * @dev Returns true if this contract implements the interface defined by
130      * `interfaceId`. See the corresponding
131      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
132      * to learn more about how these ids are created.
133      *
134      * This function call must use less than 30 000 gas.
135      */
136     function supportsInterface(bytes4 interfaceId) external view returns (bool);
137 
138     // ==============================
139     //            IERC721
140     // ==============================
141 
142     /**
143      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
144      */
145     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
146 
147     /**
148      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
149      */
150     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
151 
152     /**
153      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
154      */
155     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
156 
157     /**
158      * @dev Returns the number of tokens in ``owner``'s account.
159      */
160     function balanceOf(address owner) external view returns (uint256 balance);
161 
162     /**
163      * @dev Returns the owner of the `tokenId` token.
164      *
165      * Requirements:
166      *
167      * - `tokenId` must exist.
168      */
169     function ownerOf(uint256 tokenId) external view returns (address owner);
170 
171     /**
172      * @dev Safely transfers `tokenId` token from `from` to `to`.
173      *
174      * Requirements:
175      *
176      * - `from` cannot be the zero address.
177      * - `to` cannot be the zero address.
178      * - `tokenId` token must exist and be owned by `from`.
179      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
180      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
181      *
182      * Emits a {Transfer} event.
183      */
184     function safeTransferFrom(
185         address from,
186         address to,
187         uint256 tokenId,
188         bytes calldata data
189     ) external;
190 
191     /**
192      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
193      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
194      *
195      * Requirements:
196      *
197      * - `from` cannot be the zero address.
198      * - `to` cannot be the zero address.
199      * - `tokenId` token must exist and be owned by `from`.
200      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
201      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
202      *
203      * Emits a {Transfer} event.
204      */
205     function safeTransferFrom(
206         address from,
207         address to,
208         uint256 tokenId
209     ) external;
210 
211     /**
212      * @dev Transfers `tokenId` token from `from` to `to`.
213      *
214      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
215      *
216      * Requirements:
217      *
218      * - `from` cannot be the zero address.
219      * - `to` cannot be the zero address.
220      * - `tokenId` token must be owned by `from`.
221      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
222      *
223      * Emits a {Transfer} event.
224      */
225     function transferFrom(
226         address from,
227         address to,
228         uint256 tokenId
229     ) external;
230 
231     /**
232      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
233      * The approval is cleared when the token is transferred.
234      *
235      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
236      *
237      * Requirements:
238      *
239      * - The caller must own the token or be an approved operator.
240      * - `tokenId` must exist.
241      *
242      * Emits an {Approval} event.
243      */
244     function approve(address to, uint256 tokenId) external;
245 
246     /**
247      * @dev Approve or remove `operator` as an operator for the caller.
248      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
249      *
250      * Requirements:
251      *
252      * - The `operator` cannot be the caller.
253      *
254      * Emits an {ApprovalForAll} event.
255      */
256     function setApprovalForAll(address operator, bool _approved) external;
257 
258     /**
259      * @dev Returns the account approved for `tokenId` token.
260      *
261      * Requirements:
262      *
263      * - `tokenId` must exist.
264      */
265     function getApproved(uint256 tokenId) external view returns (address operator);
266 
267     /**
268      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
269      *
270      * See {setApprovalForAll}
271      */
272     function isApprovedForAll(address owner, address operator) external view returns (bool);
273 
274     // ==============================
275     //        IERC721Metadata
276     // ==============================
277 
278     /**
279      * @dev Returns the token collection name.
280      */
281     function name() external view returns (string memory);
282 
283     /**
284      * @dev Returns the token collection symbol.
285      */
286     function symbol() external view returns (string memory);
287 
288     /**
289      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
290      */
291     function tokenURI(uint256 tokenId) external view returns (string memory);
292 }
293 
294 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
295 
296 pragma solidity ^0.8.0;
297 
298 /**
299  * @dev Contract module which provides a basic access control mechanism, where
300  * there is an account (an owner) that can be granted exclusive access to
301  * specific functions.
302  *
303  * By default, the owner account will be the one that deploys the contract. This
304  * can later be changed with {transferOwnership}.
305  *
306  * This module is used through inheritance. It will make available the modifier
307  * `onlyOwner`, which can be applied to your functions to restrict their use to
308  * the owner.
309  */
310 abstract contract Ownable is Context {
311     address private _owner;
312 
313     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
314 
315     /**
316      * @dev Initializes the contract setting the deployer as the initial owner.
317      */
318     constructor() {
319         _transferOwnership(_msgSender());
320     }
321 
322     /**
323      * @dev Returns the address of the current owner.
324      */
325     function owner() public view virtual returns (address) {
326         return _owner;
327     }
328 
329     /**
330      * @dev Throws if called by any account other than the owner.
331      */
332     modifier onlyOwner() {
333         require(owner() == _msgSender(), "Ownable: caller is not the owner");
334         _;
335     }
336 
337     /**
338      * @dev Leaves the contract without owner. It will not be possible to call
339      * `onlyOwner` functions anymore. Can only be called by the current owner.
340      *
341      * NOTE: Renouncing ownership will leave the contract without an owner,
342      * thereby removing any functionality that is only available to the owner.
343      */
344     function renounceOwnership() public virtual onlyOwner {
345         _transferOwnership(address(0));
346     }
347 
348     /**
349      * @dev Transfers ownership of the contract to a new account (`newOwner`).
350      * Can only be called by the current owner.
351      */
352     function transferOwnership(address newOwner) public virtual onlyOwner {
353         require(newOwner != address(0), "Ownable: new owner is the zero address");
354         _transferOwnership(newOwner);
355     }
356 
357     /**
358      * @dev Transfers ownership of the contract to a new account (`newOwner`).
359      * Internal function without access restriction.
360      */
361     function _transferOwnership(address newOwner) internal virtual {
362         address oldOwner = _owner;
363         _owner = newOwner;
364         emit OwnershipTransferred(oldOwner, newOwner);
365     }
366 }
367 
368 pragma solidity 0.8.7;
369 
370 contract Friends is IERC721A { 
371 
372     address private _owner;
373     modifier onlyOwner() { 
374         require(_owner==msg.sender, "only owner is allowed"); 
375         _; 
376     }
377 
378     bool public saleIsActive = false;
379 
380     uint256 public constant MAX_SUPPLY = 6000;
381     uint256 public constant MAX_FREE_PER_WALLET = 2;
382     uint256 public constant MAX_BUY_PER_TX = 20;
383     uint256 public constant COST = 0.002 ether;
384 
385     string private _name = "Real Friends";
386     string private _symbol = "RFNFT";
387     string private _baseURI = "ipfs://bafybeid7y65mi53f2gk4cyydhragobdvm52jkzszw7firox4xojipmesji/";
388     string private _contractURI = "ipfs://bafybeid7y65mi53f2gk4cyydhragobdvm52jkzszw7firox4xojipmesji/";
389 
390     constructor() {
391         _owner = msg.sender;
392     }
393 
394     function buy(uint256 _amount) external payable{
395         address _caller = _msgSenderERC721A();
396 
397         require(saleIsActive, "Mint is not active right now.");
398         require(totalSupply() + _amount <= MAX_SUPPLY, "Sold out");
399         require(_amount <= MAX_BUY_PER_TX, "Max Tx Limit reached");
400         require(msg.value >= _amount*COST, "Not enought Cash provided");
401         
402         _safeMint(_caller, _amount);
403     }
404 
405     function mint(uint256 _amount) external{
406         address _caller = _msgSenderERC721A();
407 
408         require(saleIsActive, "Mint is not active right now.");
409         require(totalSupply() + _amount <= MAX_SUPPLY, "Sold out");
410 
411         uint magicTokenNum;
412         uint count = totalSupply();
413 
414         if(count <= 500){
415             magicTokenNum = 5;
416         } else if (count <= 2000) {
417             magicTokenNum = 3; 
418         } else if (count <= 4000) {
419             magicTokenNum = 2; 
420         } else {
421             magicTokenNum = 1; 
422         }
423 
424         require(_amount <= magicTokenNum, "Tx limit exceeded");
425         require(_amount + _numberMinted(msg.sender) <= magicTokenNum, "Acc has token limit");
426 
427         _safeMint(_caller, _amount);
428     }
429 
430 
431     // Mask of an entry in packed address data.
432     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
433 
434     // The bit position of `numberMinted` in packed address data.
435     uint256 private constant BITPOS_NUMBER_MINTED = 64;
436 
437     // The bit position of `numberBurned` in packed address data.
438     uint256 private constant BITPOS_NUMBER_BURNED = 128;
439 
440     // The bit position of `aux` in packed address data.
441     uint256 private constant BITPOS_AUX = 192;
442 
443     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
444     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
445 
446     // The bit position of `startTimestamp` in packed ownership.
447     uint256 private constant BITPOS_START_TIMESTAMP = 160;
448 
449     // The bit mask of the `burned` bit in packed ownership.
450     uint256 private constant BITMASK_BURNED = 1 << 224;
451 
452     // The bit position of the `nextInitialized` bit in packed ownership.
453     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
454 
455     // The bit mask of the `nextInitialized` bit in packed ownership.
456     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
457 
458     // The tokenId of the next token to be minted.
459     uint256 private _currentIndex = 0;
460 
461     // The number of tokens burned.
462     // uint256 private _burnCounter;
463 
464 
465     // Mapping from token ID to ownership details
466     // An empty struct value does not necessarily mean the token is unowned.
467     // See `_packedOwnershipOf` implementation for details.
468     //
469     // Bits Layout:
470     // - [0..159] `addr`
471     // - [160..223] `startTimestamp`
472     // - [224] `burned`
473     // - [225] `nextInitialized`
474     mapping(uint256 => uint256) private _packedOwnerships;
475 
476     // Mapping owner address to address data.
477     //
478     // Bits Layout:
479     // - [0..63] `balance`
480     // - [64..127] `numberMinted`
481     // - [128..191] `numberBurned`
482     // - [192..255] `aux`
483     mapping(address => uint256) private _packedAddressData;
484 
485     // Mapping from token ID to approved address.
486     mapping(uint256 => address) private _tokenApprovals;
487 
488     // Mapping from owner to operator approvals
489     mapping(address => mapping(address => bool)) private _operatorApprovals;
490 
491 
492     // SETTER
493     function setName(string memory _newName, string memory _newSymbol) external onlyOwner {
494         _name = _newName;
495         _symbol = _newSymbol;
496     }
497 
498     function setSale(bool _saleIsActive) external onlyOwner{
499         saleIsActive = _saleIsActive;
500     }
501 
502     function setBaseURI(string memory _newBaseURI) external onlyOwner{
503         _baseURI = _newBaseURI;
504     }
505 
506     function setContractURI(string memory _new_contractURI) external onlyOwner{
507         _contractURI = _new_contractURI;
508     }
509 
510 
511 
512 
513 
514     /**
515      * @dev Returns the starting token ID. 
516      * To change the starting token ID, please override this function.
517      */
518     function _startTokenId() internal view virtual returns (uint256) {
519         return 0;
520     }
521 
522     /**
523      * @dev Returns the next token ID to be minted.
524      */
525     function _nextTokenId() internal view returns (uint256) {
526         return _currentIndex;
527     }
528 
529     /**
530      * @dev Returns the total number of tokens in existence.
531      * Burned tokens will reduce the count. 
532      * To get the total number of tokens minted, please see `_totalMinted`.
533      */
534     function totalSupply() public view override returns (uint256) {
535         // Counter underflow is impossible as _burnCounter cannot be incremented
536         // more than `_currentIndex - _startTokenId()` times.
537         unchecked {
538             return _currentIndex - _startTokenId();
539         }
540     }
541 
542     /**
543      * @dev Returns the total amount of tokens minted in the contract.
544      */
545     function _totalMinted() internal view returns (uint256) {
546         // Counter underflow is impossible as _currentIndex does not decrement,
547         // and it is initialized to `_startTokenId()`
548         unchecked {
549             return _currentIndex - _startTokenId();
550         }
551     }
552 
553 
554     /**
555      * @dev See {IERC165-supportsInterface}.
556      */
557     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
558         // The interface IDs are constants representing the first 4 bytes of the XOR of
559         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
560         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
561         return
562             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
563             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
564             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
565     }
566 
567     /**
568      * @dev See {IERC721-balanceOf}.
569      */
570     function balanceOf(address owner) public view override returns (uint256) {
571         if (_addressToUint256(owner) == 0) revert BalanceQueryForZeroAddress();
572         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
573     }
574 
575     /**
576      * Returns the number of tokens minted by `owner`.
577      */
578     function _numberMinted(address owner) internal view returns (uint256) {
579         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
580     }
581 
582 
583 
584     /**
585      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
586      */
587     function _getAux(address owner) internal view returns (uint64) {
588         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
589     }
590 
591     /**
592      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
593      * If there are multiple variables, please pack them into a uint64.
594      */
595     function _setAux(address owner, uint64 aux) internal {
596         uint256 packed = _packedAddressData[owner];
597         uint256 auxCasted;
598         assembly { // Cast aux without masking.
599 auxCasted := aux
600         }
601         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
602         _packedAddressData[owner] = packed;
603     }
604 
605     /**
606      * Returns the packed ownership data of `tokenId`.
607      */
608     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
609         uint256 curr = tokenId;
610 
611         unchecked {
612             if (_startTokenId() <= curr)
613                 if (curr < _currentIndex) {
614                     uint256 packed = _packedOwnerships[curr];
615                     // If not burned.
616                     if (packed & BITMASK_BURNED == 0) {
617                         // Invariant:
618                         // There will always be an ownership that has an address and is not burned
619                         // before an ownership that does not have an address and is not burned.
620                         // Hence, curr will not underflow.
621                         //
622                         // We can directly compare the packed value.
623                         // If the address is zero, packed is zero.
624                         while (packed == 0) {
625                             packed = _packedOwnerships[--curr];
626                         }
627                         return packed;
628                     }
629                 }
630         }
631         revert OwnerQueryForNonexistentToken();
632     }
633 
634     /**
635      * Returns the unpacked `TokenOwnership` struct from `packed`.
636      */
637     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
638         ownership.addr = address(uint160(packed));
639         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
640         ownership.burned = packed & BITMASK_BURNED != 0;
641     }
642 
643     /**
644      * Returns the unpacked `TokenOwnership` struct at `index`.
645      */
646     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
647         return _unpackedOwnership(_packedOwnerships[index]);
648     }
649 
650     /**
651      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
652      */
653     function _initializeOwnershipAt(uint256 index) internal {
654         if (_packedOwnerships[index] == 0) {
655             _packedOwnerships[index] = _packedOwnershipOf(index);
656         }
657     }
658 
659     /**
660      * Gas spent here starts off proportional to the maximum mint batch size.
661      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
662      */
663     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
664         return _unpackedOwnership(_packedOwnershipOf(tokenId));
665     }
666 
667     /**
668      * @dev See {IERC721-ownerOf}.
669      */
670     function ownerOf(uint256 tokenId) public view override returns (address) {
671         return address(uint160(_packedOwnershipOf(tokenId)));
672     }
673 
674     /**
675      * @dev See {IERC721Metadata-name}.
676      */
677     function name() public view virtual override returns (string memory) {
678         return _name;
679     }
680 
681     /**
682      * @dev See {IERC721Metadata-symbol}.
683      */
684     function symbol() public view virtual override returns (string memory) {
685         return _symbol;
686     }
687 
688     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
689         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
690         string memory baseURI = _baseURI;
691 
692         //uint256 age = aging[tokenId];
693         //uint256 type = type[tokenId];
694         //uint256 rank = ranking[tokenId];
695         // type + rank + age
696 
697         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId), ".json")) : "";
698     }
699 
700     function contractURI() public view returns (string memory) {
701         return _contractURI;
702     }
703 
704     /**
705      * @dev Casts the address to uint256 without masking.
706      */
707     function _addressToUint256(address value) private pure returns (uint256 result) {
708         assembly {
709 result := value
710         }
711     }
712 
713     /**
714      * @dev Casts the boolean to uint256 without branching.
715      */
716     function _boolToUint256(bool value) private pure returns (uint256 result) {
717         assembly {
718 result := value
719         }
720     }
721 
722     /**
723      * @dev See {IERC721-approve}.
724      */
725     function approve(address to, uint256 tokenId) public override {
726         address owner = address(uint160(_packedOwnershipOf(tokenId)));
727         if (to == owner) revert ApprovalToCurrentOwner();
728 
729         if (_msgSenderERC721A() != owner)
730             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
731                 revert ApprovalCallerNotOwnerNorApproved();
732             }
733 
734         _tokenApprovals[tokenId] = to;
735         emit Approval(owner, to, tokenId);
736     }
737 
738     /**
739      * @dev See {IERC721-getApproved}.
740      */
741     function getApproved(uint256 tokenId) public view override returns (address) {
742         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
743 
744         return _tokenApprovals[tokenId];
745     }
746 
747     /**
748      * @dev See {IERC721-setApprovalForAll}.
749      */
750     function setApprovalForAll(address operator, bool approved) public virtual override {
751         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
752 
753         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
754         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
755     }
756 
757     /**
758      * @dev See {IERC721-isApprovedForAll}.
759      */
760     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
761         return _operatorApprovals[owner][operator];
762     }
763 
764     /**
765      * @dev See {IERC721-transferFrom}.
766      */
767     function transferFrom(
768             address from,
769             address to,
770             uint256 tokenId
771             ) public virtual override {
772         _transfer(from, to, tokenId);
773     }
774 
775     /**
776      * @dev See {IERC721-safeTransferFrom}.
777      */
778     function safeTransferFrom(
779             address from,
780             address to,
781             uint256 tokenId
782             ) public virtual override {
783         safeTransferFrom(from, to, tokenId, '');
784     }
785 
786     /**
787      * @dev See {IERC721-safeTransferFrom}.
788      */
789     function safeTransferFrom(
790             address from,
791             address to,
792             uint256 tokenId,
793             bytes memory _data
794             ) public virtual override {
795         _transfer(from, to, tokenId);
796     }
797 
798     /**
799      * @dev Returns whether `tokenId` exists.
800      *
801      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
802      *
803      * Tokens start existing when they are minted (`_mint`),
804      */
805     function _exists(uint256 tokenId) internal view returns (bool) {
806         return
807             _startTokenId() <= tokenId &&
808             tokenId < _currentIndex;
809     }
810 
811     /**
812      * @dev Equivalent to `_safeMint(to, quantity, '')`.
813      */
814     function _safeMint(address to, uint256 quantity) internal {
815         _safeMint(to, quantity, '');
816     }
817 
818     /**
819      * @dev Safely mints `quantity` tokens and transfers them to `to`.
820      *
821      * Requirements:
822      *
823      * - If `to` refers to a smart contract, it must implement
824      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
825      * - `quantity` must be greater than 0.
826      *
827      * Emits a {Transfer} event.
828      */
829     function _safeMint(
830             address to,
831             uint256 quantity,
832             bytes memory _data
833             ) internal {
834         uint256 startTokenId = _currentIndex;
835         //if (_addressToUint256(to) == 0) revert MintToZeroAddress();
836         if (quantity == 0) revert MintZeroQuantity();
837 
838 
839         // Overflows are incredibly unrealistic.
840         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
841         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
842         unchecked {
843             // Updates:
844             // - `balance += quantity`.
845             // - `numberMinted += quantity`.
846             //
847             // We can directly add to the balance and number minted.
848             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
849 
850             // Updates:
851             // - `address` to the owner.
852             // - `startTimestamp` to the timestamp of minting.
853             // - `burned` to `false`.
854             // - `nextInitialized` to `quantity == 1`.
855             _packedOwnerships[startTokenId] =
856                 _addressToUint256(to) |
857                 (block.timestamp << BITPOS_START_TIMESTAMP) |
858                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
859 
860             uint256 updatedIndex = startTokenId;
861             uint256 end = updatedIndex + quantity;
862 
863             if (to.code.length != 0) {
864                 do {
865                     emit Transfer(address(0), to, updatedIndex);
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
891         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
892         if (quantity == 0) revert MintZeroQuantity();
893 
894 
895         // Overflows are incredibly unrealistic.
896         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
897         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
898         unchecked {
899             // Updates:
900             // - `balance += quantity`.
901             // - `numberMinted += quantity`.
902             //
903             // We can directly add to the balance and number minted.
904             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
905 
906             // Updates:
907             // - `address` to the owner.
908             // - `startTimestamp` to the timestamp of minting.
909             // - `burned` to `false`.
910             // - `nextInitialized` to `quantity == 1`.
911             _packedOwnerships[startTokenId] =
912                 _addressToUint256(to) |
913                 (block.timestamp << BITPOS_START_TIMESTAMP) |
914                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
915 
916             uint256 updatedIndex = startTokenId;
917             uint256 end = updatedIndex + quantity;
918 
919             do {
920                 emit Transfer(address(0), to, updatedIndex++);
921             } while (updatedIndex < end);
922 
923             _currentIndex = updatedIndex;
924         }
925         _afterTokenTransfers(address(0), to, startTokenId, quantity);
926     }
927 
928     /**
929      * @dev Transfers `tokenId` from `from` to `to`.
930      *
931      * Requirements:
932      *
933      * - `to` cannot be the zero address.
934      * - `tokenId` token must be owned by `from`.
935      *
936      * Emits a {Transfer} event.
937      */
938     function _transfer(
939             address from,
940             address to,
941             uint256 tokenId
942             ) private {
943 
944         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
945 
946         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
947 
948         address approvedAddress = _tokenApprovals[tokenId];
949 
950         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
951                 isApprovedForAll(from, _msgSenderERC721A()) ||
952                 approvedAddress == _msgSenderERC721A());
953 
954         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
955 
956         //X if (_addressToUint256(to) == 0) revert TransferToZeroAddress();
957 
958 
959         // Clear approvals from the previous owner.
960         if (_addressToUint256(approvedAddress) != 0) {
961             delete _tokenApprovals[tokenId];
962         }
963 
964         // Underflow of the sender's balance is impossible because we check for
965         // ownership above and the recipient's balance can't realistically overflow.
966         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
967         unchecked {
968             // We can directly increment and decrement the balances.
969             --_packedAddressData[from]; // Updates: `balance -= 1`.
970             ++_packedAddressData[to]; // Updates: `balance += 1`.
971 
972             // Updates:
973             // - `address` to the next owner.
974             // - `startTimestamp` to the timestamp of transfering.
975             // - `burned` to `false`.
976             // - `nextInitialized` to `true`.
977             _packedOwnerships[tokenId] =
978                 _addressToUint256(to) |
979                 (block.timestamp << BITPOS_START_TIMESTAMP) |
980                 BITMASK_NEXT_INITIALIZED;
981 
982             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
983             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
984                 uint256 nextTokenId = tokenId + 1;
985                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
986                 if (_packedOwnerships[nextTokenId] == 0) {
987                     // If the next slot is within bounds.
988                     if (nextTokenId != _currentIndex) {
989                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
990                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
991                     }
992                 }
993             }
994         }
995 
996         emit Transfer(from, to, tokenId);
997         _afterTokenTransfers(from, to, tokenId, 1);
998     }
999 
1000 
1001 
1002 
1003     /**
1004      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1005      * minting.
1006      * And also called after one token has been burned.
1007      *
1008      * startTokenId - the first token id to be transferred
1009      * quantity - the amount to be transferred
1010      *
1011      * Calling conditions:
1012      *
1013      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1014      * transferred to `to`.
1015      * - When `from` is zero, `tokenId` has been minted for `to`.
1016      * - When `to` is zero, `tokenId` has been burned by `from`.
1017      * - `from` and `to` are never both zero.
1018      */
1019     function _afterTokenTransfers(
1020             address from,
1021             address to,
1022             uint256 startTokenId,
1023             uint256 quantity
1024             ) internal virtual {}
1025 
1026     /**
1027      * @dev Returns the message sender (defaults to `msg.sender`).
1028      *
1029      * If you are writing GSN compatible contracts, you need to override this function.
1030      */
1031     function _msgSenderERC721A() internal view virtual returns (address) {
1032         return msg.sender;
1033     }
1034 
1035     /**
1036      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1037      */
1038     function _toString(uint256 value) internal pure returns (string memory ptr) {
1039         assembly {
1040             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1041             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1042             // We will need 1 32-byte word to store the length, 
1043             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1044 ptr := add(mload(0x40), 128)
1045 
1046          // Update the free memory pointer to allocate.
1047          mstore(0x40, ptr)
1048 
1049          // Cache the end of the memory to calculate the length later.
1050          let end := ptr
1051 
1052          // We write the string from the rightmost digit to the leftmost digit.
1053          // The following is essentially a do-while loop that also handles the zero case.
1054          // Costs a bit more than early returning for the zero case,
1055          // but cheaper in terms of deployment and overall runtime costs.
1056          for { 
1057              // Initialize and perform the first pass without check.
1058              let temp := value
1059                  // Move the pointer 1 byte leftwards to point to an empty character slot.
1060                  ptr := sub(ptr, 1)
1061                  // Write the character to the pointer. 48 is the ASCII index of '0'.
1062                  mstore8(ptr, add(48, mod(temp, 10)))
1063                  temp := div(temp, 10)
1064          } temp { 
1065              // Keep dividing `temp` until zero.
1066         temp := div(temp, 10)
1067          } { 
1068              // Body of the for loop.
1069         ptr := sub(ptr, 1)
1070          mstore8(ptr, add(48, mod(temp, 10)))
1071          }
1072 
1073      let length := sub(end, ptr)
1074          // Move the pointer 32 bytes leftwards to make room for the length.
1075          ptr := sub(ptr, 32)
1076          // Store the length.
1077          mstore(ptr, length)
1078         }
1079     }
1080 
1081     function whitelistMint(address _to, uint256 _amount) external onlyOwner{
1082         require(totalSupply()+_amount<MAX_SUPPLY, 'max supply reached');
1083         _safeMint(_to, _amount);
1084     }
1085 
1086     function withdraw() external onlyOwner {
1087         uint256 balance = address(this).balance;
1088         payable(msg.sender).transfer(balance);
1089     }
1090 }