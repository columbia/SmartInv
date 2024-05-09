1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
3 
4 pragma solidity ^0.8.0;
5 
6 /**
7  * @dev Provides information about the current execution context, including the
8  * sender of the transaction and its data. While these are generally available
9  * via msg.sender and msg.data, they should not be accessed in such a direct
10  * manner, since when dealing with meta-transactions the account sending and
11  * paying for execution may not be the actual sender (as far as an application
12  * is concerned).
13  *
14  * This contract is only required for intermediate, library-like contracts.
15  */
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes calldata) {
22         return msg.data;
23     }
24 }
25 
26 // ERC721A Contracts v4.0.0
27 // Creator: Chiru Labs
28 
29 pragma solidity ^0.8.4;
30 
31 /**
32  * @dev Interface of an ERC721A compliant contract.
33  */
34 interface IERC721A {
35     /**
36      * The caller must own the token or be an approved operator.
37      */
38     error ApprovalCallerNotOwnerNorApproved();
39 
40     /**
41      * The token does not exist.
42      */
43     error ApprovalQueryForNonexistentToken();
44 
45     /**
46      * The caller cannot approve to their own address.
47      */
48     error ApproveToCaller();
49 
50     /**
51      * The caller cannot approve to the current owner.
52      */
53     error ApprovalToCurrentOwner();
54 
55     /**
56      * Cannot query the balance for the zero address.
57      */
58     error BalanceQueryForZeroAddress();
59 
60     /**
61      * Cannot mint to the zero address.
62      */
63     error MintToZeroAddress();
64 
65     /**
66      * The quantity of tokens minted must be more than zero.
67      */
68     error MintZeroQuantity();
69 
70     /**
71      * The token does not exist.
72      */
73     error OwnerQueryForNonexistentToken();
74 
75     /**
76      * The caller must own the token or be an approved operator.
77      */
78     error TransferCallerNotOwnerNorApproved();
79 
80     /**
81      * The token must be owned by `from`.
82      */
83     error TransferFromIncorrectOwner();
84 
85     /**
86      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
87      */
88     error TransferToNonERC721ReceiverImplementer();
89 
90     /**
91      * Cannot transfer to the zero address.
92      */
93     error TransferToZeroAddress();
94 
95     /**
96      * The token does not exist.
97      */
98     error URIQueryForNonexistentToken();
99 
100     struct TokenOwnership {
101         // The address of the owner.
102         address addr;
103         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
104         uint64 startTimestamp;
105         // Whether the token has been burned.
106         bool burned;
107     }
108 
109     /**
110      * @dev Returns the total amount of tokens stored by the contract.
111      *
112      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
113      */
114     function totalSupply() external view returns (uint256);
115 
116     // ==============================
117     //            IERC165
118     // ==============================
119 
120     /**
121      * @dev Returns true if this contract implements the interface defined by
122      * `interfaceId`. See the corresponding
123      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
124      * to learn more about how these ids are created.
125      *
126      * This function call must use less than 30 000 gas.
127      */
128     function supportsInterface(bytes4 interfaceId) external view returns (bool);
129 
130     // ==============================
131     //            IERC721
132     // ==============================
133 
134     /**
135      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
136      */
137     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
138 
139     /**
140      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
141      */
142     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
143 
144     /**
145      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
146      */
147     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
148 
149     /**
150      * @dev Returns the number of tokens in ``owner``'s account.
151      */
152     function balanceOf(address owner) external view returns (uint256 balance);
153 
154     /**
155      * @dev Returns the owner of the `tokenId` token.
156      *
157      * Requirements:
158      *
159      * - `tokenId` must exist.
160      */
161     function ownerOf(uint256 tokenId) external view returns (address owner);
162 
163     /**
164      * @dev Safely transfers `tokenId` token from `from` to `to`.
165      *
166      * Requirements:
167      *
168      * - `from` cannot be the zero address.
169      * - `to` cannot be the zero address.
170      * - `tokenId` token must exist and be owned by `from`.
171      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
172      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
173      *
174      * Emits a {Transfer} event.
175      */
176     function safeTransferFrom(
177         address from,
178         address to,
179         uint256 tokenId,
180         bytes calldata data
181     ) external;
182 
183     /**
184      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
185      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
186      *
187      * Requirements:
188      *
189      * - `from` cannot be the zero address.
190      * - `to` cannot be the zero address.
191      * - `tokenId` token must exist and be owned by `from`.
192      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
193      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
194      *
195      * Emits a {Transfer} event.
196      */
197     function safeTransferFrom(
198         address from,
199         address to,
200         uint256 tokenId
201     ) external;
202 
203     /**
204      * @dev Transfers `tokenId` token from `from` to `to`.
205      *
206      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
207      *
208      * Requirements:
209      *
210      * - `from` cannot be the zero address.
211      * - `to` cannot be the zero address.
212      * - `tokenId` token must be owned by `from`.
213      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
214      *
215      * Emits a {Transfer} event.
216      */
217     function transferFrom(
218         address from,
219         address to,
220         uint256 tokenId
221     ) external;
222 
223     /**
224      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
225      * The approval is cleared when the token is transferred.
226      *
227      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
228      *
229      * Requirements:
230      *
231      * - The caller must own the token or be an approved operator.
232      * - `tokenId` must exist.
233      *
234      * Emits an {Approval} event.
235      */
236     function approve(address to, uint256 tokenId) external;
237 
238     /**
239      * @dev Approve or remove `operator` as an operator for the caller.
240      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
241      *
242      * Requirements:
243      *
244      * - The `operator` cannot be the caller.
245      *
246      * Emits an {ApprovalForAll} event.
247      */
248     function setApprovalForAll(address operator, bool _approved) external;
249 
250     /**
251      * @dev Returns the account approved for `tokenId` token.
252      *
253      * Requirements:
254      *
255      * - `tokenId` must exist.
256      */
257     function getApproved(uint256 tokenId) external view returns (address operator);
258 
259     /**
260      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
261      *
262      * See {setApprovalForAll}
263      */
264     function isApprovedForAll(address owner, address operator) external view returns (bool);
265 
266     // ==============================
267     //        IERC721Metadata
268     // ==============================
269 
270     /**
271      * @dev Returns the token collection name.
272      */
273     function name() external view returns (string memory);
274 
275     /**
276      * @dev Returns the token collection symbol.
277      */
278     function symbol() external view returns (string memory);
279 
280     /**
281      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
282      */
283     function tokenURI(uint256 tokenId) external view returns (string memory);
284 }
285 
286 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
287 
288 pragma solidity ^0.8.0;
289 
290 /**
291  * @dev Contract module which provides a basic access control mechanism, where
292  * there is an account (an owner) that can be granted exclusive access to
293  * specific functions.
294  *
295  * By default, the owner account will be the one that deploys the contract. This
296  * can later be changed with {transferOwnership}.
297  *
298  * This module is used through inheritance. It will make available the modifier
299  * `onlyOwner`, which can be applied to your functions to restrict their use to
300  * the owner.
301  */
302 abstract contract Ownable is Context {
303     address private _owner;
304 
305     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
306 
307     /**
308      * @dev Initializes the contract setting the deployer as the initial owner.
309      */
310     constructor() {
311         _transferOwnership(_msgSender());
312     }
313 
314     /**
315      * @dev Returns the address of the current owner.
316      */
317     function owner() public view virtual returns (address) {
318         return _owner;
319     }
320 
321     /**
322      * @dev Throws if called by any account other than the owner.
323      */
324     modifier onlyOwner() {
325         require(owner() == _msgSender(), "Ownable: caller is not the owner");
326         _;
327     }
328 
329     /**
330      * @dev Leaves the contract without owner. It will not be possible to call
331      * `onlyOwner` functions anymore. Can only be called by the current owner.
332      *
333      * NOTE: Renouncing ownership will leave the contract without an owner,
334      * thereby removing any functionality that is only available to the owner.
335      */
336     function renounceOwnership() public virtual onlyOwner {
337         _transferOwnership(address(0));
338     }
339 
340     /**
341      * @dev Transfers ownership of the contract to a new account (`newOwner`).
342      * Can only be called by the current owner.
343      */
344     function transferOwnership(address newOwner) public virtual onlyOwner {
345         require(newOwner != address(0), "Ownable: new owner is the zero address");
346         _transferOwnership(newOwner);
347     }
348 
349     /**
350      * @dev Transfers ownership of the contract to a new account (`newOwner`).
351      * Internal function without access restriction.
352      */
353     function _transferOwnership(address newOwner) internal virtual {
354         address oldOwner = _owner;
355         _owner = newOwner;
356         emit OwnershipTransferred(oldOwner, newOwner);
357     }
358 }
359 
360 pragma solidity 0.8.7;
361 
362 contract LittleWarriors is IERC721A { 
363 
364     address private _owner;
365     modifier onlyOwner() { 
366         require(_owner==msg.sender, "only owner is allowed"); 
367         _; 
368     }
369 
370     bool public saleIsActive = false;
371 
372     uint256 public constant MAX_SUPPLY = 5000;
373     uint256 public constant MAX_FREE_PER_WALLET = 2;
374     uint256 public constant MAX_BUY_PER_TX = 5;
375     uint256 public constant COST = 0.002 ether;
376 
377     string private _name = "LittleWarriors";
378     string private _symbol = "LWNFT";
379     string private _baseURI = "ipfs://QmYoFtEh3jsGYKST9n1HpbioSpaNvFPCqNQQ3QZjuY3FNg/";
380     string private _contractURI = "ipfs://QmYoFtEh3jsGYKST9n1HpbioSpaNvFPCqNQQ3QZjuY3FNg/";
381 
382     constructor() {
383         _owner = msg.sender;
384     }
385 
386     function buy(uint256 _amount) external payable{
387         address _caller = _msgSenderERC721A();
388 
389         require(saleIsActive, "Mint is not active right now.");
390         require(totalSupply() + _amount <= MAX_SUPPLY, "Sold out");
391         require(_amount <= MAX_BUY_PER_TX, "Max Tx Limit reached");
392         require(msg.value >= _amount*COST, "Not enought Cash provided");
393         
394         _safeMint(_caller, _amount);
395     }
396 
397     function mint(uint256 _amount) external{
398         address _caller = _msgSenderERC721A();
399 
400         require(saleIsActive, "Mint is not active right now.");
401         require(totalSupply() + _amount <= MAX_SUPPLY, "Sold out");
402 
403         uint magicTokenNum;
404         uint count = totalSupply();
405 
406         if(count <= 500){
407             magicTokenNum = 5;
408         } else if (count <= 2000) {
409             magicTokenNum = 3; 
410         } else if (count <= 4000) {
411             magicTokenNum = 2; 
412         } else {
413             magicTokenNum = 1; 
414         }
415 
416         require(_amount <= magicTokenNum, "Tx limit exceeded");
417         require(_amount + _numberMinted(msg.sender) <= magicTokenNum, "Acc has token limit");
418 
419         _safeMint(_caller, _amount);
420     }
421 
422 
423     // Mask of an entry in packed address data.
424     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
425 
426     // The bit position of `numberMinted` in packed address data.
427     uint256 private constant BITPOS_NUMBER_MINTED = 64;
428 
429     // The bit position of `numberBurned` in packed address data.
430     uint256 private constant BITPOS_NUMBER_BURNED = 128;
431 
432     // The bit position of `aux` in packed address data.
433     uint256 private constant BITPOS_AUX = 192;
434 
435     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
436     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
437 
438     // The bit position of `startTimestamp` in packed ownership.
439     uint256 private constant BITPOS_START_TIMESTAMP = 160;
440 
441     // The bit mask of the `burned` bit in packed ownership.
442     uint256 private constant BITMASK_BURNED = 1 << 224;
443 
444     // The bit position of the `nextInitialized` bit in packed ownership.
445     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
446 
447     // The bit mask of the `nextInitialized` bit in packed ownership.
448     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
449 
450     // The tokenId of the next token to be minted.
451     uint256 private _currentIndex = 0;
452 
453     // The number of tokens burned.
454     // uint256 private _burnCounter;
455 
456 
457     // Mapping from token ID to ownership details
458     // An empty struct value does not necessarily mean the token is unowned.
459     // See `_packedOwnershipOf` implementation for details.
460     //
461     // Bits Layout:
462     // - [0..159] `addr`
463     // - [160..223] `startTimestamp`
464     // - [224] `burned`
465     // - [225] `nextInitialized`
466     mapping(uint256 => uint256) private _packedOwnerships;
467 
468     // Mapping owner address to address data.
469     //
470     // Bits Layout:
471     // - [0..63] `balance`
472     // - [64..127] `numberMinted`
473     // - [128..191] `numberBurned`
474     // - [192..255] `aux`
475     mapping(address => uint256) private _packedAddressData;
476 
477     // Mapping from token ID to approved address.
478     mapping(uint256 => address) private _tokenApprovals;
479 
480     // Mapping from owner to operator approvals
481     mapping(address => mapping(address => bool)) private _operatorApprovals;
482 
483 
484     // SETTER
485     function setName(string memory _newName, string memory _newSymbol) external onlyOwner {
486         _name = _newName;
487         _symbol = _newSymbol;
488     }
489 
490     function setSale(bool _saleIsActive) external onlyOwner{
491         saleIsActive = _saleIsActive;
492     }
493 
494     function setBaseURI(string memory _newBaseURI) external onlyOwner{
495         _baseURI = _newBaseURI;
496     }
497 
498     function setContractURI(string memory _new_contractURI) external onlyOwner{
499         _contractURI = _new_contractURI;
500     }
501 
502 
503 
504     /**
505      * @dev Returns the starting token ID. 
506      * To change the starting token ID, please override this function.
507      */
508     function _startTokenId() internal view virtual returns (uint256) {
509         return 0;
510     }
511 
512     /**
513      * @dev Returns the next token ID to be minted.
514      */
515     function _nextTokenId() internal view returns (uint256) {
516         return _currentIndex;
517     }
518 
519     /**
520      * @dev Returns the total number of tokens in existence.
521      * Burned tokens will reduce the count. 
522      * To get the total number of tokens minted, please see `_totalMinted`.
523      */
524     function totalSupply() public view override returns (uint256) {
525         // Counter underflow is impossible as _burnCounter cannot be incremented
526         // more than `_currentIndex - _startTokenId()` times.
527         unchecked {
528             return _currentIndex - _startTokenId();
529         }
530     }
531 
532     /**
533      * @dev Returns the total amount of tokens minted in the contract.
534      */
535     function _totalMinted() internal view returns (uint256) {
536         // Counter underflow is impossible as _currentIndex does not decrement,
537         // and it is initialized to `_startTokenId()`
538         unchecked {
539             return _currentIndex - _startTokenId();
540         }
541     }
542 
543 
544     /**
545      * @dev See {IERC165-supportsInterface}.
546      */
547     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
548         // The interface IDs are constants representing the first 4 bytes of the XOR of
549         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
550         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
551         return
552             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
553             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
554             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
555     }
556 
557     /**
558      * @dev See {IERC721-balanceOf}.
559      */
560     function balanceOf(address owner) public view override returns (uint256) {
561         if (_addressToUint256(owner) == 0) revert BalanceQueryForZeroAddress();
562         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
563     }
564 
565     /**
566      * Returns the number of tokens minted by `owner`.
567      */
568     function _numberMinted(address owner) internal view returns (uint256) {
569         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
570     }
571 
572 
573 
574     /**
575      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
576      */
577     function _getAux(address owner) internal view returns (uint64) {
578         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
579     }
580 
581     /**
582      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
583      * If there are multiple variables, please pack them into a uint64.
584      */
585     function _setAux(address owner, uint64 aux) internal {
586         uint256 packed = _packedAddressData[owner];
587         uint256 auxCasted;
588         assembly { // Cast aux without masking.
589 auxCasted := aux
590         }
591         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
592         _packedAddressData[owner] = packed;
593     }
594 
595     /**
596      * Returns the packed ownership data of `tokenId`.
597      */
598     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
599         uint256 curr = tokenId;
600 
601         unchecked {
602             if (_startTokenId() <= curr)
603                 if (curr < _currentIndex) {
604                     uint256 packed = _packedOwnerships[curr];
605                     // If not burned.
606                     if (packed & BITMASK_BURNED == 0) {
607                         // Invariant:
608                         // There will always be an ownership that has an address and is not burned
609                         // before an ownership that does not have an address and is not burned.
610                         // Hence, curr will not underflow.
611                         //
612                         // We can directly compare the packed value.
613                         // If the address is zero, packed is zero.
614                         while (packed == 0) {
615                             packed = _packedOwnerships[--curr];
616                         }
617                         return packed;
618                     }
619                 }
620         }
621         revert OwnerQueryForNonexistentToken();
622     }
623 
624     /**
625      * Returns the unpacked `TokenOwnership` struct from `packed`.
626      */
627     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
628         ownership.addr = address(uint160(packed));
629         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
630         ownership.burned = packed & BITMASK_BURNED != 0;
631     }
632 
633     /**
634      * Returns the unpacked `TokenOwnership` struct at `index`.
635      */
636     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
637         return _unpackedOwnership(_packedOwnerships[index]);
638     }
639 
640     /**
641      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
642      */
643     function _initializeOwnershipAt(uint256 index) internal {
644         if (_packedOwnerships[index] == 0) {
645             _packedOwnerships[index] = _packedOwnershipOf(index);
646         }
647     }
648 
649     /**
650      * Gas spent here starts off proportional to the maximum mint batch size.
651      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
652      */
653     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
654         return _unpackedOwnership(_packedOwnershipOf(tokenId));
655     }
656 
657     /**
658      * @dev See {IERC721-ownerOf}.
659      */
660     function ownerOf(uint256 tokenId) public view override returns (address) {
661         return address(uint160(_packedOwnershipOf(tokenId)));
662     }
663 
664     /**
665      * @dev See {IERC721Metadata-name}.
666      */
667     function name() public view virtual override returns (string memory) {
668         return _name;
669     }
670 
671     /**
672      * @dev See {IERC721Metadata-symbol}.
673      */
674     function symbol() public view virtual override returns (string memory) {
675         return _symbol;
676     }
677 
678     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
679         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
680         string memory baseURI = _baseURI;
681 
682         //uint256 age = aging[tokenId];
683         //uint256 type = type[tokenId];
684         //uint256 rank = ranking[tokenId];
685         // type + rank + age
686 
687         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId), ".json")) : "";
688     }
689 
690     function contractURI() public view returns (string memory) {
691         return _contractURI;
692     }
693 
694     /**
695      * @dev Casts the address to uint256 without masking.
696      */
697     function _addressToUint256(address value) private pure returns (uint256 result) {
698         assembly {
699 result := value
700         }
701     }
702 
703     /**
704      * @dev Casts the boolean to uint256 without branching.
705      */
706     function _boolToUint256(bool value) private pure returns (uint256 result) {
707         assembly {
708 result := value
709         }
710     }
711 
712     /**
713      * @dev See {IERC721-approve}.
714      */
715     function approve(address to, uint256 tokenId) public override {
716         address owner = address(uint160(_packedOwnershipOf(tokenId)));
717         if (to == owner) revert ApprovalToCurrentOwner();
718 
719         if (_msgSenderERC721A() != owner)
720             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
721                 revert ApprovalCallerNotOwnerNorApproved();
722             }
723 
724         _tokenApprovals[tokenId] = to;
725         emit Approval(owner, to, tokenId);
726     }
727 
728     /**
729      * @dev See {IERC721-getApproved}.
730      */
731     function getApproved(uint256 tokenId) public view override returns (address) {
732         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
733 
734         return _tokenApprovals[tokenId];
735     }
736 
737     /**
738      * @dev See {IERC721-setApprovalForAll}.
739      */
740     function setApprovalForAll(address operator, bool approved) public virtual override {
741         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
742 
743         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
744         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
745     }
746 
747     /**
748      * @dev See {IERC721-isApprovedForAll}.
749      */
750     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
751         return _operatorApprovals[owner][operator];
752     }
753 
754     /**
755      * @dev See {IERC721-transferFrom}.
756      */
757     function transferFrom(
758             address from,
759             address to,
760             uint256 tokenId
761             ) public virtual override {
762         _transfer(from, to, tokenId);
763     }
764 
765     /**
766      * @dev See {IERC721-safeTransferFrom}.
767      */
768     function safeTransferFrom(
769             address from,
770             address to,
771             uint256 tokenId
772             ) public virtual override {
773         safeTransferFrom(from, to, tokenId, '');
774     }
775 
776     /**
777      * @dev See {IERC721-safeTransferFrom}.
778      */
779     function safeTransferFrom(
780             address from,
781             address to,
782             uint256 tokenId,
783             bytes memory _data
784             ) public virtual override {
785         _transfer(from, to, tokenId);
786     }
787 
788     /**
789      * @dev Returns whether `tokenId` exists.
790      *
791      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
792      *
793      * Tokens start existing when they are minted (`_mint`),
794      */
795     function _exists(uint256 tokenId) internal view returns (bool) {
796         return
797             _startTokenId() <= tokenId &&
798             tokenId < _currentIndex;
799     }
800 
801     /**
802      * @dev Equivalent to `_safeMint(to, quantity, '')`.
803      */
804     function _safeMint(address to, uint256 quantity) internal {
805         _safeMint(to, quantity, '');
806     }
807 
808     /**
809      * @dev Safely mints `quantity` tokens and transfers them to `to`.
810      *
811      * Requirements:
812      *
813      * - If `to` refers to a smart contract, it must implement
814      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
815      * - `quantity` must be greater than 0.
816      *
817      * Emits a {Transfer} event.
818      */
819     function _safeMint(
820             address to,
821             uint256 quantity,
822             bytes memory _data
823             ) internal {
824         uint256 startTokenId = _currentIndex;
825         //if (_addressToUint256(to) == 0) revert MintToZeroAddress();
826         if (quantity == 0) revert MintZeroQuantity();
827 
828 
829         // Overflows are incredibly unrealistic.
830         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
831         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
832         unchecked {
833             // Updates:
834             // - `balance += quantity`.
835             // - `numberMinted += quantity`.
836             //
837             // We can directly add to the balance and number minted.
838             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
839 
840             // Updates:
841             // - `address` to the owner.
842             // - `startTimestamp` to the timestamp of minting.
843             // - `burned` to `false`.
844             // - `nextInitialized` to `quantity == 1`.
845             _packedOwnerships[startTokenId] =
846                 _addressToUint256(to) |
847                 (block.timestamp << BITPOS_START_TIMESTAMP) |
848                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
849 
850             uint256 updatedIndex = startTokenId;
851             uint256 end = updatedIndex + quantity;
852 
853             if (to.code.length != 0) {
854                 do {
855                     emit Transfer(address(0), to, updatedIndex);
856                 } while (updatedIndex < end);
857                 // Reentrancy protection
858                 if (_currentIndex != startTokenId) revert();
859             } else {
860                 do {
861                     emit Transfer(address(0), to, updatedIndex++);
862                 } while (updatedIndex < end);
863             }
864             _currentIndex = updatedIndex;
865         }
866         _afterTokenTransfers(address(0), to, startTokenId, quantity);
867     }
868 
869     /**
870      * @dev Mints `quantity` tokens and transfers them to `to`.
871      *
872      * Requirements:
873      *
874      * - `to` cannot be the zero address.
875      * - `quantity` must be greater than 0.
876      *
877      * Emits a {Transfer} event.
878      */
879     function _mint(address to, uint256 quantity) internal {
880         uint256 startTokenId = _currentIndex;
881         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
882         if (quantity == 0) revert MintZeroQuantity();
883 
884 
885         // Overflows are incredibly unrealistic.
886         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
887         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
888         unchecked {
889             // Updates:
890             // - `balance += quantity`.
891             // - `numberMinted += quantity`.
892             //
893             // We can directly add to the balance and number minted.
894             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
895 
896             // Updates:
897             // - `address` to the owner.
898             // - `startTimestamp` to the timestamp of minting.
899             // - `burned` to `false`.
900             // - `nextInitialized` to `quantity == 1`.
901             _packedOwnerships[startTokenId] =
902                 _addressToUint256(to) |
903                 (block.timestamp << BITPOS_START_TIMESTAMP) |
904                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
905 
906             uint256 updatedIndex = startTokenId;
907             uint256 end = updatedIndex + quantity;
908 
909             do {
910                 emit Transfer(address(0), to, updatedIndex++);
911             } while (updatedIndex < end);
912 
913             _currentIndex = updatedIndex;
914         }
915         _afterTokenTransfers(address(0), to, startTokenId, quantity);
916     }
917 
918     /**
919      * @dev Transfers `tokenId` from `from` to `to`.
920      *
921      * Requirements:
922      *
923      * - `to` cannot be the zero address.
924      * - `tokenId` token must be owned by `from`.
925      *
926      * Emits a {Transfer} event.
927      */
928     function _transfer(
929             address from,
930             address to,
931             uint256 tokenId
932             ) private {
933 
934         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
935 
936         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
937 
938         address approvedAddress = _tokenApprovals[tokenId];
939 
940         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
941                 isApprovedForAll(from, _msgSenderERC721A()) ||
942                 approvedAddress == _msgSenderERC721A());
943 
944         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
945 
946         //X if (_addressToUint256(to) == 0) revert TransferToZeroAddress();
947 
948 
949         // Clear approvals from the previous owner.
950         if (_addressToUint256(approvedAddress) != 0) {
951             delete _tokenApprovals[tokenId];
952         }
953 
954         // Underflow of the sender's balance is impossible because we check for
955         // ownership above and the recipient's balance can't realistically overflow.
956         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
957         unchecked {
958             // We can directly increment and decrement the balances.
959             --_packedAddressData[from]; // Updates: `balance -= 1`.
960             ++_packedAddressData[to]; // Updates: `balance += 1`.
961 
962             // Updates:
963             // - `address` to the next owner.
964             // - `startTimestamp` to the timestamp of transfering.
965             // - `burned` to `false`.
966             // - `nextInitialized` to `true`.
967             _packedOwnerships[tokenId] =
968                 _addressToUint256(to) |
969                 (block.timestamp << BITPOS_START_TIMESTAMP) |
970                 BITMASK_NEXT_INITIALIZED;
971 
972             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
973             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
974                 uint256 nextTokenId = tokenId + 1;
975                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
976                 if (_packedOwnerships[nextTokenId] == 0) {
977                     // If the next slot is within bounds.
978                     if (nextTokenId != _currentIndex) {
979                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
980                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
981                     }
982                 }
983             }
984         }
985 
986         emit Transfer(from, to, tokenId);
987         _afterTokenTransfers(from, to, tokenId, 1);
988     }
989 
990 
991 
992 
993     /**
994      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
995      * minting.
996      * And also called after one token has been burned.
997      *
998      * startTokenId - the first token id to be transferred
999      * quantity - the amount to be transferred
1000      *
1001      * Calling conditions:
1002      *
1003      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1004      * transferred to `to`.
1005      * - When `from` is zero, `tokenId` has been minted for `to`.
1006      * - When `to` is zero, `tokenId` has been burned by `from`.
1007      * - `from` and `to` are never both zero.
1008      */
1009     function _afterTokenTransfers(
1010             address from,
1011             address to,
1012             uint256 startTokenId,
1013             uint256 quantity
1014             ) internal virtual {}
1015 
1016     /**
1017      * @dev Returns the message sender (defaults to `msg.sender`).
1018      *
1019      * If you are writing GSN compatible contracts, you need to override this function.
1020      */
1021     function _msgSenderERC721A() internal view virtual returns (address) {
1022         return msg.sender;
1023     }
1024 
1025     /**
1026      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1027      */
1028     function _toString(uint256 value) internal pure returns (string memory ptr) {
1029         assembly {
1030             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1031             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1032             // We will need 1 32-byte word to store the length, 
1033             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1034 ptr := add(mload(0x40), 128)
1035 
1036          // Update the free memory pointer to allocate.
1037          mstore(0x40, ptr)
1038 
1039          // Cache the end of the memory to calculate the length later.
1040          let end := ptr
1041 
1042          // We write the string from the rightmost digit to the leftmost digit.
1043          // The following is essentially a do-while loop that also handles the zero case.
1044          // Costs a bit more than early returning for the zero case,
1045          // but cheaper in terms of deployment and overall runtime costs.
1046          for { 
1047              // Initialize and perform the first pass without check.
1048              let temp := value
1049                  // Move the pointer 1 byte leftwards to point to an empty character slot.
1050                  ptr := sub(ptr, 1)
1051                  // Write the character to the pointer. 48 is the ASCII index of '0'.
1052                  mstore8(ptr, add(48, mod(temp, 10)))
1053                  temp := div(temp, 10)
1054          } temp { 
1055              // Keep dividing `temp` until zero.
1056         temp := div(temp, 10)
1057          } { 
1058              // Body of the for loop.
1059         ptr := sub(ptr, 1)
1060          mstore8(ptr, add(48, mod(temp, 10)))
1061          }
1062 
1063      let length := sub(end, ptr)
1064          // Move the pointer 32 bytes leftwards to make room for the length.
1065          ptr := sub(ptr, 32)
1066          // Store the length.
1067          mstore(ptr, length)
1068         }
1069     }
1070 
1071     function ownerMint(address _to, uint256 _amount) external onlyOwner{
1072         require(totalSupply()+_amount<MAX_SUPPLY, 'max supply reached');
1073         _safeMint(_to, _amount);
1074     }
1075 
1076     function withdraw() external onlyOwner {
1077         uint256 balance = address(this).balance;
1078         payable(msg.sender).transfer(balance);
1079     }
1080 }