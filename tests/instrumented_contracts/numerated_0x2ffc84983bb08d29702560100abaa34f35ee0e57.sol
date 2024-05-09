1 /**
2  *Submitted for verification at Etherscan.io on 2022-07-08
3 */
4 
5 // SPDX-License-Identifier: MIT
6 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Provides information about the current execution context, including the
12  * sender of the transaction and its data. While these are generally available
13  * via msg.sender and msg.data, they should not be accessed in such a direct
14  * manner, since when dealing with meta-transactions the account sending and
15  * paying for execution may not be the actual sender (as far as an application
16  * is concerned).
17  *
18  * This contract is only required for intermediate, library-like contracts.
19  */
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view virtual returns (bytes calldata) {
26         return msg.data;
27     }
28 }
29 
30 // ERC721A Contracts v4.0.0
31 // Creator: Chiru Labs
32 
33 pragma solidity ^0.8.4;
34 
35 /**
36  * @dev Interface of an ERC721A compliant contract.
37  */
38 interface IERC721A {
39     /**
40      * The caller must own the token or be an approved operator.
41      */
42     error ApprovalCallerNotOwnerNorApproved();
43 
44     /**
45      * The token does not exist.
46      */
47     error ApprovalQueryForNonexistentToken();
48 
49     /**
50      * The caller cannot approve to their own address.
51      */
52     error ApproveToCaller();
53 
54     /**
55      * The caller cannot approve to the current owner.
56      */
57     error ApprovalToCurrentOwner();
58 
59     /**
60      * Cannot query the balance for the zero address.
61      */
62     error BalanceQueryForZeroAddress();
63 
64     /**
65      * Cannot mint to the zero address.
66      */
67     error MintToZeroAddress();
68 
69     /**
70      * The quantity of tokens minted must be more than zero.
71      */
72     error MintZeroQuantity();
73 
74     /**
75      * The token does not exist.
76      */
77     error OwnerQueryForNonexistentToken();
78 
79     /**
80      * The caller must own the token or be an approved operator.
81      */
82     error TransferCallerNotOwnerNorApproved();
83 
84     /**
85      * The token must be owned by `from`.
86      */
87     error TransferFromIncorrectOwner();
88 
89     /**
90      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
91      */
92     error TransferToNonERC721ReceiverImplementer();
93 
94     /**
95      * Cannot transfer to the zero address.
96      */
97     error TransferToZeroAddress();
98 
99     /**
100      * The token does not exist.
101      */
102     error URIQueryForNonexistentToken();
103 
104     struct TokenOwnership {
105         // The address of the owner.
106         address addr;
107         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
108         uint64 startTimestamp;
109         // Whether the token has been burned.
110         bool burned;
111     }
112 
113     /**
114      * @dev Returns the total amount of tokens stored by the contract.
115      *
116      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
117      */
118     function totalSupply() external view returns (uint256);
119 
120     // ==============================
121     //            IERC165
122     // ==============================
123 
124     /**
125      * @dev Returns true if this contract implements the interface defined by
126      * `interfaceId`. See the corresponding
127      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
128      * to learn more about how these ids are created.
129      *
130      * This function call must use less than 30 000 gas.
131      */
132     function supportsInterface(bytes4 interfaceId) external view returns (bool);
133 
134     // ==============================
135     //            IERC721
136     // ==============================
137 
138     /**
139      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
140      */
141     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
142 
143     /**
144      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
145      */
146     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
147 
148     /**
149      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
150      */
151     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
152 
153     /**
154      * @dev Returns the number of tokens in ``owner``'s account.
155      */
156     function balanceOf(address owner) external view returns (uint256 balance);
157 
158     /**
159      * @dev Returns the owner of the `tokenId` token.
160      *
161      * Requirements:
162      *
163      * - `tokenId` must exist.
164      */
165     function ownerOf(uint256 tokenId) external view returns (address owner);
166 
167     /**
168      * @dev Safely transfers `tokenId` token from `from` to `to`.
169      *
170      * Requirements:
171      *
172      * - `from` cannot be the zero address.
173      * - `to` cannot be the zero address.
174      * - `tokenId` token must exist and be owned by `from`.
175      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
176      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
177      *
178      * Emits a {Transfer} event.
179      */
180     function safeTransferFrom(
181         address from,
182         address to,
183         uint256 tokenId,
184         bytes calldata data
185     ) external;
186 
187     /**
188      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
189      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
190      *
191      * Requirements:
192      *
193      * - `from` cannot be the zero address.
194      * - `to` cannot be the zero address.
195      * - `tokenId` token must exist and be owned by `from`.
196      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
197      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
198      *
199      * Emits a {Transfer} event.
200      */
201     function safeTransferFrom(
202         address from,
203         address to,
204         uint256 tokenId
205     ) external;
206 
207     /**
208      * @dev Transfers `tokenId` token from `from` to `to`.
209      *
210      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
211      *
212      * Requirements:
213      *
214      * - `from` cannot be the zero address.
215      * - `to` cannot be the zero address.
216      * - `tokenId` token must be owned by `from`.
217      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
218      *
219      * Emits a {Transfer} event.
220      */
221     function transferFrom(
222         address from,
223         address to,
224         uint256 tokenId
225     ) external;
226 
227     /**
228      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
229      * The approval is cleared when the token is transferred.
230      *
231      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
232      *
233      * Requirements:
234      *
235      * - The caller must own the token or be an approved operator.
236      * - `tokenId` must exist.
237      *
238      * Emits an {Approval} event.
239      */
240     function approve(address to, uint256 tokenId) external;
241 
242     /**
243      * @dev Approve or remove `operator` as an operator for the caller.
244      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
245      *
246      * Requirements:
247      *
248      * - The `operator` cannot be the caller.
249      *
250      * Emits an {ApprovalForAll} event.
251      */
252     function setApprovalForAll(address operator, bool _approved) external;
253 
254     /**
255      * @dev Returns the account approved for `tokenId` token.
256      *
257      * Requirements:
258      *
259      * - `tokenId` must exist.
260      */
261     function getApproved(uint256 tokenId) external view returns (address operator);
262 
263     /**
264      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
265      *
266      * See {setApprovalForAll}
267      */
268     function isApprovedForAll(address owner, address operator) external view returns (bool);
269 
270     // ==============================
271     //        IERC721Metadata
272     // ==============================
273 
274     /**
275      * @dev Returns the token collection name.
276      */
277     function name() external view returns (string memory);
278 
279     /**
280      * @dev Returns the token collection symbol.
281      */
282     function symbol() external view returns (string memory);
283 
284     /**
285      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
286      */
287     function tokenURI(uint256 tokenId) external view returns (string memory);
288 }
289 
290 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
291 
292 pragma solidity ^0.8.0;
293 
294 /**
295  * @dev Contract module which provides a basic access control mechanism, where
296  * there is an account (an owner) that can be granted exclusive access to
297  * specific functions.
298  *
299  * By default, the owner account will be the one that deploys the contract. This
300  * can later be changed with {transferOwnership}.
301  *
302  * This module is used through inheritance. It will make available the modifier
303  * `onlyOwner`, which can be applied to your functions to restrict their use to
304  * the owner.
305  */
306 abstract contract Ownable is Context {
307     address private _owner;
308 
309     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
310 
311     /**
312      * @dev Initializes the contract setting the deployer as the initial owner.
313      */
314     constructor() {
315         _transferOwnership(_msgSender());
316     }
317 
318     /**
319      * @dev Returns the address of the current owner.
320      */
321     function owner() public view virtual returns (address) {
322         return _owner;
323     }
324 
325     /**
326      * @dev Throws if called by any account other than the owner.
327      */
328     modifier onlyOwner() {
329         require(owner() == _msgSender(), "Ownable: caller is not the owner");
330         _;
331     }
332 
333     /**
334      * @dev Leaves the contract without owner. It will not be possible to call
335      * `onlyOwner` functions anymore. Can only be called by the current owner.
336      *
337      * NOTE: Renouncing ownership will leave the contract without an owner,
338      * thereby removing any functionality that is only available to the owner.
339      */
340     function renounceOwnership() public virtual onlyOwner {
341         _transferOwnership(address(0));
342     }
343 
344     /**
345      * @dev Transfers ownership of the contract to a new account (`newOwner`).
346      * Can only be called by the current owner.
347      */
348     function transferOwnership(address newOwner) public virtual onlyOwner {
349         require(newOwner != address(0), "Ownable: new owner is the zero address");
350         _transferOwnership(newOwner);
351     }
352 
353     /**
354      * @dev Transfers ownership of the contract to a new account (`newOwner`).
355      * Internal function without access restriction.
356      */
357     function _transferOwnership(address newOwner) internal virtual {
358         address oldOwner = _owner;
359         _owner = newOwner;
360         emit OwnershipTransferred(oldOwner, newOwner);
361     }
362 }
363 
364 pragma solidity 0.8.7;
365 
366 contract Nftdogecat is IERC721A { 
367 
368     address private _owner;
369     modifier onlyOwner() { 
370         require(_owner==msg.sender, "only owner is allowed"); 
371         _; 
372     }
373 
374     bool public saleIsActive = false;
375 
376     uint256 public constant MAX_SUPPLY = 5555;
377     uint256 public constant MAX_FREE_PER_WALLET = 1;
378     uint256 public constant MAX_BUY_PER_TX = 10;
379     uint256 public constant COST = 0.002 ether;
380 
381     string private _name = "Doge&Cat";
382     string private _symbol = "DCN";
383     string private _baseURI = "ipfs://bafybeifjfexbhyq6tgijbp76lgt2sga6inlrifsbw7sqce3ad2chmc3wiy/";
384     string private _contractURI = "ipfs://bafybeifjfexbhyq6tgijbp76lgt2sga6inlrifsbw7sqce3ad2chmc3wiy/";
385 
386     constructor() {
387         _owner = msg.sender;
388     }
389 
390     function buy(uint256 _amount) external payable{
391         address _caller = _msgSenderERC721A();
392 
393         require(saleIsActive, "Mint is not active right now.");
394         require(totalSupply() + _amount <= MAX_SUPPLY, "Sold out");
395         require(_amount <= MAX_BUY_PER_TX, "Max Tx Limit reached");
396         require(msg.value >= _amount*COST, "Not enought Cash provided");
397         
398         _safeMint(_caller, _amount);
399     }
400 
401     function mint(uint256 _amount) external{
402         address _caller = _msgSenderERC721A();
403 
404         require(saleIsActive, "Mint is not active right now.");
405         require(totalSupply() + _amount <= MAX_SUPPLY, "Sold out");
406 
407         uint magicTokenNum;
408         uint count = totalSupply();
409 
410         if(count <= 500){
411             magicTokenNum = 5;
412         } else if (count <= 2000) {
413             magicTokenNum = 3; 
414         } else if (count <= 4000) {
415             magicTokenNum = 2; 
416         } else {
417             magicTokenNum = 1; 
418         }
419 
420         require(_amount <= magicTokenNum, "Tx limit exceeded");
421         require(_amount + _numberMinted(msg.sender) <= magicTokenNum, "Acc has token limit");
422 
423         _safeMint(_caller, _amount);
424     }
425 
426 
427     // Mask of an entry in packed address data.
428     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
429 
430     // The bit position of `numberMinted` in packed address data.
431     uint256 private constant BITPOS_NUMBER_MINTED = 64;
432 
433     // The bit position of `numberBurned` in packed address data.
434     uint256 private constant BITPOS_NUMBER_BURNED = 128;
435 
436     // The bit position of `aux` in packed address data.
437     uint256 private constant BITPOS_AUX = 192;
438 
439     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
440     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
441 
442     // The bit position of `startTimestamp` in packed ownership.
443     uint256 private constant BITPOS_START_TIMESTAMP = 160;
444 
445     // The bit mask of the `burned` bit in packed ownership.
446     uint256 private constant BITMASK_BURNED = 1 << 224;
447 
448     // The bit position of the `nextInitialized` bit in packed ownership.
449     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
450 
451     // The bit mask of the `nextInitialized` bit in packed ownership.
452     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
453 
454     // The tokenId of the next token to be minted.
455     uint256 private _currentIndex = 0;
456 
457     // The number of tokens burned.
458     // uint256 private _burnCounter;
459 
460 
461     // Mapping from token ID to ownership details
462     // An empty struct value does not necessarily mean the token is unowned.
463     // See `_packedOwnershipOf` implementation for details.
464     //
465     // Bits Layout:
466     // - [0..159] `addr`
467     // - [160..223] `startTimestamp`
468     // - [224] `burned`
469     // - [225] `nextInitialized`
470     mapping(uint256 => uint256) private _packedOwnerships;
471 
472     // Mapping owner address to address data.
473     //
474     // Bits Layout:
475     // - [0..63] `balance`
476     // - [64..127] `numberMinted`
477     // - [128..191] `numberBurned`
478     // - [192..255] `aux`
479     mapping(address => uint256) private _packedAddressData;
480 
481     // Mapping from token ID to approved address.
482     mapping(uint256 => address) private _tokenApprovals;
483 
484     // Mapping from owner to operator approvals
485     mapping(address => mapping(address => bool)) private _operatorApprovals;
486 
487 
488     // SETTER
489     function setName(string memory _newName, string memory _newSymbol) external onlyOwner {
490         _name = _newName;
491         _symbol = _newSymbol;
492     }
493 
494     function setSale(bool _saleIsActive) external onlyOwner{
495         saleIsActive = _saleIsActive;
496     }
497 
498     function setBaseURI(string memory _newBaseURI) external onlyOwner{
499         _baseURI = _newBaseURI;
500     }
501 
502     function setContractURI(string memory _new_contractURI) external onlyOwner{
503         _contractURI = _new_contractURI;
504     }
505 
506 
507 
508     /**
509      * @dev Returns the starting token ID. 
510      * To change the starting token ID, please override this function.
511      */
512     function _startTokenId() internal view virtual returns (uint256) {
513         return 0;
514     }
515 
516     /**
517      * @dev Returns the next token ID to be minted.
518      */
519     function _nextTokenId() internal view returns (uint256) {
520         return _currentIndex;
521     }
522 
523     /**
524      * @dev Returns the total number of tokens in existence.
525      * Burned tokens will reduce the count. 
526      * To get the total number of tokens minted, please see `_totalMinted`.
527      */
528     function totalSupply() public view override returns (uint256) {
529         // Counter underflow is impossible as _burnCounter cannot be incremented
530         // more than `_currentIndex - _startTokenId()` times.
531         unchecked {
532             return _currentIndex - _startTokenId();
533         }
534     }
535 
536     /**
537      * @dev Returns the total amount of tokens minted in the contract.
538      */
539     function _totalMinted() internal view returns (uint256) {
540         // Counter underflow is impossible as _currentIndex does not decrement,
541         // and it is initialized to `_startTokenId()`
542         unchecked {
543             return _currentIndex - _startTokenId();
544         }
545     }
546 
547 
548     /**
549      * @dev See {IERC165-supportsInterface}.
550      */
551     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
552         // The interface IDs are constants representing the first 4 bytes of the XOR of
553         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
554         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
555         return
556             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
557             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
558             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
559     }
560 
561     /**
562      * @dev See {IERC721-balanceOf}.
563      */
564     function balanceOf(address owner) public view override returns (uint256) {
565         if (_addressToUint256(owner) == 0) revert BalanceQueryForZeroAddress();
566         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
567     }
568 
569     /**
570      * Returns the number of tokens minted by `owner`.
571      */
572     function _numberMinted(address owner) internal view returns (uint256) {
573         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
574     }
575 
576 
577 
578     /**
579      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
580      */
581     function _getAux(address owner) internal view returns (uint64) {
582         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
583     }
584 
585     /**
586      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
587      * If there are multiple variables, please pack them into a uint64.
588      */
589     function _setAux(address owner, uint64 aux) internal {
590         uint256 packed = _packedAddressData[owner];
591         uint256 auxCasted;
592         assembly { // Cast aux without masking.
593 auxCasted := aux
594         }
595         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
596         _packedAddressData[owner] = packed;
597     }
598 
599     /**
600      * Returns the packed ownership data of `tokenId`.
601      */
602     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
603         uint256 curr = tokenId;
604 
605         unchecked {
606             if (_startTokenId() <= curr)
607                 if (curr < _currentIndex) {
608                     uint256 packed = _packedOwnerships[curr];
609                     // If not burned.
610                     if (packed & BITMASK_BURNED == 0) {
611                         // Invariant:
612                         // There will always be an ownership that has an address and is not burned
613                         // before an ownership that does not have an address and is not burned.
614                         // Hence, curr will not underflow.
615                         //
616                         // We can directly compare the packed value.
617                         // If the address is zero, packed is zero.
618                         while (packed == 0) {
619                             packed = _packedOwnerships[--curr];
620                         }
621                         return packed;
622                     }
623                 }
624         }
625         revert OwnerQueryForNonexistentToken();
626     }
627 
628     /**
629      * Returns the unpacked `TokenOwnership` struct from `packed`.
630      */
631     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
632         ownership.addr = address(uint160(packed));
633         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
634         ownership.burned = packed & BITMASK_BURNED != 0;
635     }
636 
637     /**
638      * Returns the unpacked `TokenOwnership` struct at `index`.
639      */
640     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
641         return _unpackedOwnership(_packedOwnerships[index]);
642     }
643 
644     /**
645      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
646      */
647     function _initializeOwnershipAt(uint256 index) internal {
648         if (_packedOwnerships[index] == 0) {
649             _packedOwnerships[index] = _packedOwnershipOf(index);
650         }
651     }
652 
653     /**
654      * Gas spent here starts off proportional to the maximum mint batch size.
655      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
656      */
657     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
658         return _unpackedOwnership(_packedOwnershipOf(tokenId));
659     }
660 
661     /**
662      * @dev See {IERC721-ownerOf}.
663      */
664     function ownerOf(uint256 tokenId) public view override returns (address) {
665         return address(uint160(_packedOwnershipOf(tokenId)));
666     }
667 
668     /**
669      * @dev See {IERC721Metadata-name}.
670      */
671     function name() public view virtual override returns (string memory) {
672         return _name;
673     }
674 
675     /**
676      * @dev See {IERC721Metadata-symbol}.
677      */
678     function symbol() public view virtual override returns (string memory) {
679         return _symbol;
680     }
681 
682     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
683         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
684         string memory baseURI = _baseURI;
685 
686         //uint256 age = aging[tokenId];
687         //uint256 type = type[tokenId];
688         //uint256 rank = ranking[tokenId];
689         // type + rank + age
690 
691         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId), ".json")) : "";
692     }
693 
694     function contractURI() public view returns (string memory) {
695         return _contractURI;
696     }
697 
698     /**
699      * @dev Casts the address to uint256 without masking.
700      */
701     function _addressToUint256(address value) private pure returns (uint256 result) {
702         assembly {
703 result := value
704         }
705     }
706 
707     /**
708      * @dev Casts the boolean to uint256 without branching.
709      */
710     function _boolToUint256(bool value) private pure returns (uint256 result) {
711         assembly {
712 result := value
713         }
714     }
715 
716     /**
717      * @dev See {IERC721-approve}.
718      */
719     function approve(address to, uint256 tokenId) public override {
720         address owner = address(uint160(_packedOwnershipOf(tokenId)));
721         if (to == owner) revert ApprovalToCurrentOwner();
722 
723         if (_msgSenderERC721A() != owner)
724             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
725                 revert ApprovalCallerNotOwnerNorApproved();
726             }
727 
728         _tokenApprovals[tokenId] = to;
729         emit Approval(owner, to, tokenId);
730     }
731 
732     /**
733      * @dev See {IERC721-getApproved}.
734      */
735     function getApproved(uint256 tokenId) public view override returns (address) {
736         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
737 
738         return _tokenApprovals[tokenId];
739     }
740 
741     /**
742      * @dev See {IERC721-setApprovalForAll}.
743      */
744     function setApprovalForAll(address operator, bool approved) public virtual override {
745         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
746 
747         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
748         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
749     }
750 
751     /**
752      * @dev See {IERC721-isApprovedForAll}.
753      */
754     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
755         return _operatorApprovals[owner][operator];
756     }
757 
758     /**
759      * @dev See {IERC721-transferFrom}.
760      */
761     function transferFrom(
762             address from,
763             address to,
764             uint256 tokenId
765             ) public virtual override {
766         _transfer(from, to, tokenId);
767     }
768 
769     /**
770      * @dev See {IERC721-safeTransferFrom}.
771      */
772     function safeTransferFrom(
773             address from,
774             address to,
775             uint256 tokenId
776             ) public virtual override {
777         safeTransferFrom(from, to, tokenId, '');
778     }
779 
780     /**
781      * @dev See {IERC721-safeTransferFrom}.
782      */
783     function safeTransferFrom(
784             address from,
785             address to,
786             uint256 tokenId,
787             bytes memory _data
788             ) public virtual override {
789         _transfer(from, to, tokenId);
790     }
791 
792     /**
793      * @dev Returns whether `tokenId` exists.
794      *
795      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
796      *
797      * Tokens start existing when they are minted (`_mint`),
798      */
799     function _exists(uint256 tokenId) internal view returns (bool) {
800         return
801             _startTokenId() <= tokenId &&
802             tokenId < _currentIndex;
803     }
804 
805     /**
806      * @dev Equivalent to `_safeMint(to, quantity, '')`.
807      */
808     function _safeMint(address to, uint256 quantity) internal {
809         _safeMint(to, quantity, '');
810     }
811 
812     /**
813      * @dev Safely mints `quantity` tokens and transfers them to `to`.
814      *
815      * Requirements:
816      *
817      * - If `to` refers to a smart contract, it must implement
818      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
819      * - `quantity` must be greater than 0.
820      *
821      * Emits a {Transfer} event.
822      */
823     function _safeMint(
824             address to,
825             uint256 quantity,
826             bytes memory _data
827             ) internal {
828         uint256 startTokenId = _currentIndex;
829         //if (_addressToUint256(to) == 0) revert MintToZeroAddress();
830         if (quantity == 0) revert MintZeroQuantity();
831 
832 
833         // Overflows are incredibly unrealistic.
834         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
835         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
836         unchecked {
837             // Updates:
838             // - `balance += quantity`.
839             // - `numberMinted += quantity`.
840             //
841             // We can directly add to the balance and number minted.
842             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
843 
844             // Updates:
845             // - `address` to the owner.
846             // - `startTimestamp` to the timestamp of minting.
847             // - `burned` to `false`.
848             // - `nextInitialized` to `quantity == 1`.
849             _packedOwnerships[startTokenId] =
850                 _addressToUint256(to) |
851                 (block.timestamp << BITPOS_START_TIMESTAMP) |
852                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
853 
854             uint256 updatedIndex = startTokenId;
855             uint256 end = updatedIndex + quantity;
856 
857             if (to.code.length != 0) {
858                 do {
859                     emit Transfer(address(0), to, updatedIndex);
860                 } while (updatedIndex < end);
861                 // Reentrancy protection
862                 if (_currentIndex != startTokenId) revert();
863             } else {
864                 do {
865                     emit Transfer(address(0), to, updatedIndex++);
866                 } while (updatedIndex < end);
867             }
868             _currentIndex = updatedIndex;
869         }
870         _afterTokenTransfers(address(0), to, startTokenId, quantity);
871     }
872 
873     /**
874      * @dev Mints `quantity` tokens and transfers them to `to`.
875      *
876      * Requirements:
877      *
878      * - `to` cannot be the zero address.
879      * - `quantity` must be greater than 0.
880      *
881      * Emits a {Transfer} event.
882      */
883     function _mint(address to, uint256 quantity) internal {
884         uint256 startTokenId = _currentIndex;
885         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
886         if (quantity == 0) revert MintZeroQuantity();
887 
888 
889         // Overflows are incredibly unrealistic.
890         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
891         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
892         unchecked {
893             // Updates:
894             // - `balance += quantity`.
895             // - `numberMinted += quantity`.
896             //
897             // We can directly add to the balance and number minted.
898             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
899 
900             // Updates:
901             // - `address` to the owner.
902             // - `startTimestamp` to the timestamp of minting.
903             // - `burned` to `false`.
904             // - `nextInitialized` to `quantity == 1`.
905             _packedOwnerships[startTokenId] =
906                 _addressToUint256(to) |
907                 (block.timestamp << BITPOS_START_TIMESTAMP) |
908                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
909 
910             uint256 updatedIndex = startTokenId;
911             uint256 end = updatedIndex + quantity;
912 
913             do {
914                 emit Transfer(address(0), to, updatedIndex++);
915             } while (updatedIndex < end);
916 
917             _currentIndex = updatedIndex;
918         }
919         _afterTokenTransfers(address(0), to, startTokenId, quantity);
920     }
921 
922     /**
923      * @dev Transfers `tokenId` from `from` to `to`.
924      *
925      * Requirements:
926      *
927      * - `to` cannot be the zero address.
928      * - `tokenId` token must be owned by `from`.
929      *
930      * Emits a {Transfer} event.
931      */
932     function _transfer(
933             address from,
934             address to,
935             uint256 tokenId
936             ) private {
937 
938         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
939 
940         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
941 
942         address approvedAddress = _tokenApprovals[tokenId];
943 
944         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
945                 isApprovedForAll(from, _msgSenderERC721A()) ||
946                 approvedAddress == _msgSenderERC721A());
947 
948         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
949 
950         //X if (_addressToUint256(to) == 0) revert TransferToZeroAddress();
951 
952 
953         // Clear approvals from the previous owner.
954         if (_addressToUint256(approvedAddress) != 0) {
955             delete _tokenApprovals[tokenId];
956         }
957 
958         // Underflow of the sender's balance is impossible because we check for
959         // ownership above and the recipient's balance can't realistically overflow.
960         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
961         unchecked {
962             // We can directly increment and decrement the balances.
963             --_packedAddressData[from]; // Updates: `balance -= 1`.
964             ++_packedAddressData[to]; // Updates: `balance += 1`.
965 
966             // Updates:
967             // - `address` to the next owner.
968             // - `startTimestamp` to the timestamp of transfering.
969             // - `burned` to `false`.
970             // - `nextInitialized` to `true`.
971             _packedOwnerships[tokenId] =
972                 _addressToUint256(to) |
973                 (block.timestamp << BITPOS_START_TIMESTAMP) |
974                 BITMASK_NEXT_INITIALIZED;
975 
976             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
977             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
978                 uint256 nextTokenId = tokenId + 1;
979                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
980                 if (_packedOwnerships[nextTokenId] == 0) {
981                     // If the next slot is within bounds.
982                     if (nextTokenId != _currentIndex) {
983                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
984                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
985                     }
986                 }
987             }
988         }
989 
990         emit Transfer(from, to, tokenId);
991         _afterTokenTransfers(from, to, tokenId, 1);
992     }
993 
994 
995 
996 
997     /**
998      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
999      * minting.
1000      * And also called after one token has been burned.
1001      *
1002      * startTokenId - the first token id to be transferred
1003      * quantity - the amount to be transferred
1004      *
1005      * Calling conditions:
1006      *
1007      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1008      * transferred to `to`.
1009      * - When `from` is zero, `tokenId` has been minted for `to`.
1010      * - When `to` is zero, `tokenId` has been burned by `from`.
1011      * - `from` and `to` are never both zero.
1012      */
1013     function _afterTokenTransfers(
1014             address from,
1015             address to,
1016             uint256 startTokenId,
1017             uint256 quantity
1018             ) internal virtual {}
1019 
1020     /**
1021      * @dev Returns the message sender (defaults to `msg.sender`).
1022      *
1023      * If you are writing GSN compatible contracts, you need to override this function.
1024      */
1025     function _msgSenderERC721A() internal view virtual returns (address) {
1026         return msg.sender;
1027     }
1028 
1029     /**
1030      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1031      */
1032     function _toString(uint256 value) internal pure returns (string memory ptr) {
1033         assembly {
1034             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1035             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1036             // We will need 1 32-byte word to store the length, 
1037             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1038 ptr := add(mload(0x40), 128)
1039 
1040          // Update the free memory pointer to allocate.
1041          mstore(0x40, ptr)
1042 
1043          // Cache the end of the memory to calculate the length later.
1044          let end := ptr
1045 
1046          // We write the string from the rightmost digit to the leftmost digit.
1047          // The following is essentially a do-while loop that also handles the zero case.
1048          // Costs a bit more than early returning for the zero case,
1049          // but cheaper in terms of deployment and overall runtime costs.
1050          for { 
1051              // Initialize and perform the first pass without check.
1052              let temp := value
1053                  // Move the pointer 1 byte leftwards to point to an empty character slot.
1054                  ptr := sub(ptr, 1)
1055                  // Write the character to the pointer. 48 is the ASCII index of '0'.
1056                  mstore8(ptr, add(48, mod(temp, 10)))
1057                  temp := div(temp, 10)
1058          } temp { 
1059              // Keep dividing `temp` until zero.
1060         temp := div(temp, 10)
1061          } { 
1062              // Body of the for loop.
1063         ptr := sub(ptr, 1)
1064          mstore8(ptr, add(48, mod(temp, 10)))
1065          }
1066 
1067      let length := sub(end, ptr)
1068          // Move the pointer 32 bytes leftwards to make room for the length.
1069          ptr := sub(ptr, 32)
1070          // Store the length.
1071          mstore(ptr, length)
1072         }
1073     }
1074 
1075     function ownerMint(address _to, uint256 _amount) external onlyOwner{
1076         require(totalSupply()+_amount<MAX_SUPPLY, 'max supply reached');
1077         _safeMint(_to, _amount);
1078     }
1079 
1080     function withdraw() external onlyOwner {
1081         uint256 balance = address(this).balance;
1082         payable(msg.sender).transfer(balance);
1083     }
1084 }