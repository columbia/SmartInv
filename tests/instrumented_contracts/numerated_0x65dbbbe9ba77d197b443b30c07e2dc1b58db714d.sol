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
368 
369 // File: erc721a/contracts/ERC721A.sol
370 
371 
372 // ERC721A Contracts v4.0.0
373 // Creator: Chiru Labs
374 
375 pragma solidity ^0.8.4;
376 
377 
378 /**
379  * @dev ERC721 token receiver interface.
380  */
381 interface ERC721A__IERC721Receiver {
382     function onERC721Received(
383         address operator,
384         address from,
385         uint256 tokenId,
386         bytes calldata data
387     ) external returns (bytes4);
388 }
389 
390 /**
391  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
392  * the Metadata extension. Built to optimize for lower gas during batch mints.
393  *
394  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
395  *
396  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
397  *
398  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
399  */
400 contract ERC721A is IERC721A {
401     // Mask of an entry in packed address data.
402     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
403 
404     // The bit position of `numberMinted` in packed address data.
405     uint256 private constant BITPOS_NUMBER_MINTED = 64;
406 
407     // The bit position of `numberBurned` in packed address data.
408     uint256 private constant BITPOS_NUMBER_BURNED = 128;
409 
410     // The bit position of `aux` in packed address data.
411     uint256 private constant BITPOS_AUX = 192;
412 
413     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
414     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
415 
416     // The bit position of `startTimestamp` in packed ownership.
417     uint256 private constant BITPOS_START_TIMESTAMP = 160;
418 
419     // The bit mask of the `burned` bit in packed ownership.
420     uint256 private constant BITMASK_BURNED = 1 << 224;
421     
422     // The bit position of the `nextInitialized` bit in packed ownership.
423     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
424 
425     // The bit mask of the `nextInitialized` bit in packed ownership.
426     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
427 
428     // The tokenId of the next token to be minted.
429     uint256 private _currentIndex;
430 
431     // The number of tokens burned.
432     uint256 private _burnCounter;
433 
434     // Token name
435     string private _name;
436 
437     // Token symbol
438     string private _symbol;
439 
440     // Mapping from token ID to ownership details
441     // An empty struct value does not necessarily mean the token is unowned.
442     // See `_packedOwnershipOf` implementation for details.
443     //
444     // Bits Layout:
445     // - [0..159]   `addr`
446     // - [160..223] `startTimestamp`
447     // - [224]      `burned`
448     // - [225]      `nextInitialized`
449     mapping(uint256 => uint256) private _packedOwnerships;
450 
451     // Mapping owner address to address data.
452     //
453     // Bits Layout:
454     // - [0..63]    `balance`
455     // - [64..127]  `numberMinted`
456     // - [128..191] `numberBurned`
457     // - [192..255] `aux`
458     mapping(address => uint256) private _packedAddressData;
459 
460     // Mapping from token ID to approved address.
461     mapping(uint256 => address) private _tokenApprovals;
462 
463     // Mapping from owner to operator approvals
464     mapping(address => mapping(address => bool)) private _operatorApprovals;
465 
466     constructor(string memory name_, string memory symbol_) {
467         _name = name_;
468         _symbol = symbol_;
469         _currentIndex = _startTokenId();
470     }
471 
472     /**
473      * @dev Returns the starting token ID. 
474      * To change the starting token ID, please override this function.
475      */
476     function _startTokenId() internal view virtual returns (uint256) {
477         return 0;
478     }
479 
480     /**
481      * @dev Returns the next token ID to be minted.
482      */
483     function _nextTokenId() internal view returns (uint256) {
484         return _currentIndex;
485     }
486 
487     /**
488      * @dev Returns the total number of tokens in existence.
489      * Burned tokens will reduce the count. 
490      * To get the total number of tokens minted, please see `_totalMinted`.
491      */
492     function totalSupply() public view override returns (uint256) {
493         // Counter underflow is impossible as _burnCounter cannot be incremented
494         // more than `_currentIndex - _startTokenId()` times.
495         unchecked {
496             return _currentIndex - _burnCounter - _startTokenId();
497         }
498     }
499 
500     /**
501      * @dev Returns the total amount of tokens minted in the contract.
502      */
503     function _totalMinted() internal view returns (uint256) {
504         // Counter underflow is impossible as _currentIndex does not decrement,
505         // and it is initialized to `_startTokenId()`
506         unchecked {
507             return _currentIndex - _startTokenId();
508         }
509     }
510 
511     /**
512      * @dev Returns the total number of tokens burned.
513      */
514     function _totalBurned() internal view returns (uint256) {
515         return _burnCounter;
516     }
517 
518     /**
519      * @dev See {IERC165-supportsInterface}.
520      */
521     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
522         // The interface IDs are constants representing the first 4 bytes of the XOR of
523         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
524         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
525         return
526             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
527             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
528             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
529     }
530 
531     /**
532      * @dev See {IERC721-balanceOf}.
533      */
534     function balanceOf(address owner) public view override returns (uint256) {
535         if (owner == address(0)) revert BalanceQueryForZeroAddress();
536         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
537     }
538 
539     /**
540      * Returns the number of tokens minted by `owner`.
541      */
542     function _numberMinted(address owner) internal view returns (uint256) {
543         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
544     }
545 
546     /**
547      * Returns the number of tokens burned by or on behalf of `owner`.
548      */
549     function _numberBurned(address owner) internal view returns (uint256) {
550         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
551     }
552 
553     /**
554      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
555      */
556     function _getAux(address owner) internal view returns (uint64) {
557         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
558     }
559 
560     /**
561      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
562      * If there are multiple variables, please pack them into a uint64.
563      */
564     function _setAux(address owner, uint64 aux) internal {
565         uint256 packed = _packedAddressData[owner];
566         uint256 auxCasted;
567         assembly { // Cast aux without masking.
568             auxCasted := aux
569         }
570         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
571         _packedAddressData[owner] = packed;
572     }
573 
574     /**
575      * Returns the packed ownership data of `tokenId`.
576      */
577     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
578         uint256 curr = tokenId;
579 
580         unchecked {
581             if (_startTokenId() <= curr)
582                 if (curr < _currentIndex) {
583                     uint256 packed = _packedOwnerships[curr];
584                     // If not burned.
585                     if (packed & BITMASK_BURNED == 0) {
586                         // Invariant:
587                         // There will always be an ownership that has an address and is not burned
588                         // before an ownership that does not have an address and is not burned.
589                         // Hence, curr will not underflow.
590                         //
591                         // We can directly compare the packed value.
592                         // If the address is zero, packed is zero.
593                         while (packed == 0) {
594                             packed = _packedOwnerships[--curr];
595                         }
596                         return packed;
597                     }
598                 }
599         }
600         revert OwnerQueryForNonexistentToken();
601     }
602 
603     /**
604      * Returns the unpacked `TokenOwnership` struct from `packed`.
605      */
606     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
607         ownership.addr = address(uint160(packed));
608         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
609         ownership.burned = packed & BITMASK_BURNED != 0;
610     }
611 
612     /**
613      * Returns the unpacked `TokenOwnership` struct at `index`.
614      */
615     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
616         return _unpackedOwnership(_packedOwnerships[index]);
617     }
618 
619     /**
620      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
621      */
622     function _initializeOwnershipAt(uint256 index) internal {
623         if (_packedOwnerships[index] == 0) {
624             _packedOwnerships[index] = _packedOwnershipOf(index);
625         }
626     }
627 
628     /**
629      * Gas spent here starts off proportional to the maximum mint batch size.
630      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
631      */
632     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
633         return _unpackedOwnership(_packedOwnershipOf(tokenId));
634     }
635 
636     /**
637      * @dev See {IERC721-ownerOf}.
638      */
639     function ownerOf(uint256 tokenId) public view override returns (address) {
640         return address(uint160(_packedOwnershipOf(tokenId)));
641     }
642 
643     /**
644      * @dev See {IERC721Metadata-name}.
645      */
646     function name() public view virtual override returns (string memory) {
647         return _name;
648     }
649 
650     /**
651      * @dev See {IERC721Metadata-symbol}.
652      */
653     function symbol() public view virtual override returns (string memory) {
654         return _symbol;
655     }
656 
657     /**
658      * @dev See {IERC721Metadata-tokenURI}.
659      */
660     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
661         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
662 
663         string memory baseURI = _baseURI();
664         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId), ".json")) : '';
665     }
666 
667     /**
668      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
669      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
670      * by default, can be overriden in child contracts.
671      */
672     function _baseURI() internal view virtual returns (string memory) {
673         return "";
674     }
675 
676     /**
677      * @dev Casts the address to uint256 without masking.
678      */
679     function _addressToUint256(address value) private pure returns (uint256 result) {
680         assembly {
681             result := value
682         }
683     }
684 
685     /**
686      * @dev Casts the boolean to uint256 without branching.
687      */
688     function _boolToUint256(bool value) private pure returns (uint256 result) {
689         assembly {
690             result := value
691         }
692     }
693 
694     /**
695      * @dev See {IERC721-approve}.
696      */
697     function approve(address to, uint256 tokenId) public override {
698         address owner = address(uint160(_packedOwnershipOf(tokenId)));
699         if (to == owner) revert ApprovalToCurrentOwner();
700 
701         if (_msgSenderERC721A() != owner)
702             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
703                 revert ApprovalCallerNotOwnerNorApproved();
704             }
705 
706         _tokenApprovals[tokenId] = to;
707         emit Approval(owner, to, tokenId);
708     }
709 
710     /**
711      * @dev See {IERC721-getApproved}.
712      */
713     function getApproved(uint256 tokenId) public view override returns (address) {
714         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
715 
716         return _tokenApprovals[tokenId];
717     }
718 
719     /**
720      * @dev See {IERC721-setApprovalForAll}.
721      */
722     function setApprovalForAll(address operator, bool approved) public virtual override {
723         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
724 
725         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
726         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
727     }
728 
729     /**
730      * @dev See {IERC721-isApprovedForAll}.
731      */
732     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
733         return _operatorApprovals[owner][operator];
734     }
735 
736     /**
737      * @dev See {IERC721-transferFrom}.
738      */
739     function transferFrom(
740         address from,
741         address to,
742         uint256 tokenId
743     ) public virtual override {
744         _transfer(from, to, tokenId);
745     }
746 
747     /**
748      * @dev See {IERC721-safeTransferFrom}.
749      */
750     function safeTransferFrom(
751         address from,
752         address to,
753         uint256 tokenId
754     ) public virtual override {
755         safeTransferFrom(from, to, tokenId, '');
756     }
757 
758     /**
759      * @dev See {IERC721-safeTransferFrom}.
760      */
761     function safeTransferFrom(
762         address from,
763         address to,
764         uint256 tokenId,
765         bytes memory _data
766     ) public virtual override {
767         _transfer(from, to, tokenId);
768         if (to.code.length != 0)
769             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
770                 revert TransferToNonERC721ReceiverImplementer();
771             }
772     }
773 
774     /**
775      * @dev Returns whether `tokenId` exists.
776      *
777      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
778      *
779      * Tokens start existing when they are minted (`_mint`),
780      */
781     function _exists(uint256 tokenId) internal view returns (bool) {
782         return
783             _startTokenId() <= tokenId &&
784             tokenId < _currentIndex && // If within bounds,
785             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
786     }
787 
788     /**
789      * @dev Equivalent to `_safeMint(to, quantity, '')`.
790      */
791     function _safeMint(address to, uint256 quantity) internal {
792         _safeMint(to, quantity, '');
793     }
794 
795     /**
796      * @dev Safely mints `quantity` tokens and transfers them to `to`.
797      *
798      * Requirements:
799      *
800      * - If `to` refers to a smart contract, it must implement
801      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
802      * - `quantity` must be greater than 0.
803      *
804      * Emits a {Transfer} event.
805      */
806     function _safeMint(
807         address to,
808         uint256 quantity,
809         bytes memory _data
810     ) internal {
811         uint256 startTokenId = _currentIndex;
812         if (to == address(0)) revert MintToZeroAddress();
813         if (quantity == 0) revert MintZeroQuantity();
814 
815         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
816 
817         // Overflows are incredibly unrealistic.
818         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
819         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
820         unchecked {
821             // Updates:
822             // - `balance += quantity`.
823             // - `numberMinted += quantity`.
824             //
825             // We can directly add to the balance and number minted.
826             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
827 
828             // Updates:
829             // - `address` to the owner.
830             // - `startTimestamp` to the timestamp of minting.
831             // - `burned` to `false`.
832             // - `nextInitialized` to `quantity == 1`.
833             _packedOwnerships[startTokenId] =
834                 _addressToUint256(to) |
835                 (block.timestamp << BITPOS_START_TIMESTAMP) |
836                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
837 
838             uint256 updatedIndex = startTokenId;
839             uint256 end = updatedIndex + quantity;
840 
841             if (to.code.length != 0) {
842                 do {
843                     emit Transfer(address(0), to, updatedIndex);
844                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
845                         revert TransferToNonERC721ReceiverImplementer();
846                     }
847                 } while (updatedIndex < end);
848                 // Reentrancy protection
849                 if (_currentIndex != startTokenId) revert();
850             } else {
851                 do {
852                     emit Transfer(address(0), to, updatedIndex++);
853                 } while (updatedIndex < end);
854             }
855             _currentIndex = updatedIndex;
856         }
857         _afterTokenTransfers(address(0), to, startTokenId, quantity);
858     }
859 
860     /**
861      * @dev Mints `quantity` tokens and transfers them to `to`.
862      *
863      * Requirements:
864      *
865      * - `to` cannot be the zero address.
866      * - `quantity` must be greater than 0.
867      *
868      * Emits a {Transfer} event.
869      */
870     function _mint(address to, uint256 quantity) internal {
871         uint256 startTokenId = _currentIndex;
872         if (to == address(0)) revert MintToZeroAddress();
873         if (quantity == 0) revert MintZeroQuantity();
874 
875         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
876 
877         // Overflows are incredibly unrealistic.
878         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
879         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
880         unchecked {
881             // Updates:
882             // - `balance += quantity`.
883             // - `numberMinted += quantity`.
884             //
885             // We can directly add to the balance and number minted.
886             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
887 
888             // Updates:
889             // - `address` to the owner.
890             // - `startTimestamp` to the timestamp of minting.
891             // - `burned` to `false`.
892             // - `nextInitialized` to `quantity == 1`.
893             _packedOwnerships[startTokenId] =
894                 _addressToUint256(to) |
895                 (block.timestamp << BITPOS_START_TIMESTAMP) |
896                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
897 
898             uint256 updatedIndex = startTokenId;
899             uint256 end = updatedIndex + quantity;
900 
901             do {
902                 emit Transfer(address(0), to, updatedIndex++);
903             } while (updatedIndex < end);
904 
905             _currentIndex = updatedIndex;
906         }
907         _afterTokenTransfers(address(0), to, startTokenId, quantity);
908     }
909 
910     /**
911      * @dev Transfers `tokenId` from `from` to `to`.
912      *
913      * Requirements:
914      *
915      * - `to` cannot be the zero address.
916      * - `tokenId` token must be owned by `from`.
917      *
918      * Emits a {Transfer} event.
919      */
920     function _transfer(
921         address from,
922         address to,
923         uint256 tokenId
924     ) private {
925         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
926 
927         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
928 
929         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
930             isApprovedForAll(from, _msgSenderERC721A()) ||
931             getApproved(tokenId) == _msgSenderERC721A());
932 
933         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
934         if (to == address(0)) revert TransferToZeroAddress();
935 
936         _beforeTokenTransfers(from, to, tokenId, 1);
937 
938         // Clear approvals from the previous owner.
939         delete _tokenApprovals[tokenId];
940 
941         // Underflow of the sender's balance is impossible because we check for
942         // ownership above and the recipient's balance can't realistically overflow.
943         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
944         unchecked {
945             // We can directly increment and decrement the balances.
946             --_packedAddressData[from]; // Updates: `balance -= 1`.
947             ++_packedAddressData[to]; // Updates: `balance += 1`.
948 
949             // Updates:
950             // - `address` to the next owner.
951             // - `startTimestamp` to the timestamp of transfering.
952             // - `burned` to `false`.
953             // - `nextInitialized` to `true`.
954             _packedOwnerships[tokenId] =
955                 _addressToUint256(to) |
956                 (block.timestamp << BITPOS_START_TIMESTAMP) |
957                 BITMASK_NEXT_INITIALIZED;
958 
959             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
960             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
961                 uint256 nextTokenId = tokenId + 1;
962                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
963                 if (_packedOwnerships[nextTokenId] == 0) {
964                     // If the next slot is within bounds.
965                     if (nextTokenId != _currentIndex) {
966                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
967                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
968                     }
969                 }
970             }
971         }
972 
973         emit Transfer(from, to, tokenId);
974         _afterTokenTransfers(from, to, tokenId, 1);
975     }
976 
977     /**
978      * @dev Equivalent to `_burn(tokenId, false)`.
979      */
980     function _burn(uint256 tokenId) internal virtual {
981         _burn(tokenId, false);
982     }
983 
984     /**
985      * @dev Destroys `tokenId`.
986      * The approval is cleared when the token is burned.
987      *
988      * Requirements:
989      *
990      * - `tokenId` must exist.
991      *
992      * Emits a {Transfer} event.
993      */
994     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
995         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
996 
997         address from = address(uint160(prevOwnershipPacked));
998 
999         if (approvalCheck) {
1000             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1001                 isApprovedForAll(from, _msgSenderERC721A()) ||
1002                 getApproved(tokenId) == _msgSenderERC721A());
1003 
1004             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1005         }
1006 
1007         _beforeTokenTransfers(from, address(0), tokenId, 1);
1008 
1009         // Clear approvals from the previous owner.
1010         delete _tokenApprovals[tokenId];
1011 
1012         // Underflow of the sender's balance is impossible because we check for
1013         // ownership above and the recipient's balance can't realistically overflow.
1014         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1015         unchecked {
1016             // Updates:
1017             // - `balance -= 1`.
1018             // - `numberBurned += 1`.
1019             //
1020             // We can directly decrement the balance, and increment the number burned.
1021             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1022             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1023 
1024             // Updates:
1025             // - `address` to the last owner.
1026             // - `startTimestamp` to the timestamp of burning.
1027             // - `burned` to `true`.
1028             // - `nextInitialized` to `true`.
1029             _packedOwnerships[tokenId] =
1030                 _addressToUint256(from) |
1031                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1032                 BITMASK_BURNED | 
1033                 BITMASK_NEXT_INITIALIZED;
1034 
1035             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1036             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1037                 uint256 nextTokenId = tokenId + 1;
1038                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1039                 if (_packedOwnerships[nextTokenId] == 0) {
1040                     // If the next slot is within bounds.
1041                     if (nextTokenId != _currentIndex) {
1042                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1043                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1044                     }
1045                 }
1046             }
1047         }
1048 
1049         emit Transfer(from, address(0), tokenId);
1050         _afterTokenTransfers(from, address(0), tokenId, 1);
1051 
1052         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1053         unchecked {
1054             _burnCounter++;
1055         }
1056     }
1057 
1058     /**
1059      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1060      *
1061      * @param from address representing the previous owner of the given token ID
1062      * @param to target address that will receive the tokens
1063      * @param tokenId uint256 ID of the token to be transferred
1064      * @param _data bytes optional data to send along with the call
1065      * @return bool whether the call correctly returned the expected magic value
1066      */
1067     function _checkContractOnERC721Received(
1068         address from,
1069         address to,
1070         uint256 tokenId,
1071         bytes memory _data
1072     ) private returns (bool) {
1073         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1074             bytes4 retval
1075         ) {
1076             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1077         } catch (bytes memory reason) {
1078             if (reason.length == 0) {
1079                 revert TransferToNonERC721ReceiverImplementer();
1080             } else {
1081                 assembly {
1082                     revert(add(32, reason), mload(reason))
1083                 }
1084             }
1085         }
1086     }
1087 
1088     /**
1089      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1090      * And also called before burning one token.
1091      *
1092      * startTokenId - the first token id to be transferred
1093      * quantity - the amount to be transferred
1094      *
1095      * Calling conditions:
1096      *
1097      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1098      * transferred to `to`.
1099      * - When `from` is zero, `tokenId` will be minted for `to`.
1100      * - When `to` is zero, `tokenId` will be burned by `from`.
1101      * - `from` and `to` are never both zero.
1102      */
1103     function _beforeTokenTransfers(
1104         address from,
1105         address to,
1106         uint256 startTokenId,
1107         uint256 quantity
1108     ) internal virtual {}
1109 
1110     /**
1111      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1112      * minting.
1113      * And also called after one token has been burned.
1114      *
1115      * startTokenId - the first token id to be transferred
1116      * quantity - the amount to be transferred
1117      *
1118      * Calling conditions:
1119      *
1120      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1121      * transferred to `to`.
1122      * - When `from` is zero, `tokenId` has been minted for `to`.
1123      * - When `to` is zero, `tokenId` has been burned by `from`.
1124      * - `from` and `to` are never both zero.
1125      */
1126     function _afterTokenTransfers(
1127         address from,
1128         address to,
1129         uint256 startTokenId,
1130         uint256 quantity
1131     ) internal virtual {}
1132 
1133     /**
1134      * @dev Returns the message sender (defaults to `msg.sender`).
1135      *
1136      * If you are writing GSN compatible contracts, you need to override this function.
1137      */
1138     function _msgSenderERC721A() internal view virtual returns (address) {
1139         return msg.sender;
1140     }
1141 
1142     /**
1143      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1144      */
1145     function _toString(uint256 value) internal pure returns (string memory ptr) {
1146         assembly {
1147             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1148             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1149             // We will need 1 32-byte word to store the length, 
1150             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1151             ptr := add(mload(0x40), 128)
1152             // Update the free memory pointer to allocate.
1153             mstore(0x40, ptr)
1154 
1155             // Cache the end of the memory to calculate the length later.
1156             let end := ptr
1157 
1158             // We write the string from the rightmost digit to the leftmost digit.
1159             // The following is essentially a do-while loop that also handles the zero case.
1160             // Costs a bit more than early returning for the zero case,
1161             // but cheaper in terms of deployment and overall runtime costs.
1162             for { 
1163                 // Initialize and perform the first pass without check.
1164                 let temp := value
1165                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1166                 ptr := sub(ptr, 1)
1167                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1168                 mstore8(ptr, add(48, mod(temp, 10)))
1169                 temp := div(temp, 10)
1170             } temp { 
1171                 // Keep dividing `temp` until zero.
1172                 temp := div(temp, 10)
1173             } { // Body of the for loop.
1174                 ptr := sub(ptr, 1)
1175                 mstore8(ptr, add(48, mod(temp, 10)))
1176             }
1177             
1178             let length := sub(end, ptr)
1179             // Move the pointer 32 bytes leftwards to make room for the length.
1180             ptr := sub(ptr, 32)
1181             // Store the length.
1182             mstore(ptr, length)
1183         }
1184     }
1185 }
1186 
1187 // File: Unknown.sol
1188 
1189 
1190 
1191 pragma solidity ^0.8.4;
1192 
1193 
1194 
1195 contract UnknownNFT is ERC721A, Ownable {
1196     address public bossAddress;
1197     uint256 public maxSupply;
1198     uint256 public threshold;
1199 
1200     bool public allowPublicMint; 
1201     bool public allowWhitelistMint;
1202     
1203     uint256 public whitelistPrice;
1204     uint256 public publicPrice;
1205 
1206     mapping( address => uint256 ) public whitelist;
1207 
1208     uint256 public upperQuantityLimit;
1209 
1210     string public baseURI;
1211 
1212     constructor(
1213         address devMintAddress_,
1214         uint256 devMintCount_,
1215         address bossAddress_,
1216         string memory baseURI_
1217     ) ERC721A("UNKNOWN", "UNKNOWN") {
1218         maxSupply = 20000;
1219         threshold = 6666;
1220         whitelistPrice = 0 ether;
1221         publicPrice = 0 ether;
1222         allowPublicMint = false;
1223         allowWhitelistMint = false;
1224         upperQuantityLimit = 1;
1225         devMint(devMintCount_, devMintAddress_);
1226         bossAddress = bossAddress_;
1227         baseURI = baseURI_;
1228     }
1229 
1230     function flipAllowWhitelistMint() public onlyOwner {
1231         allowWhitelistMint = !allowWhitelistMint;
1232     }
1233 
1234     function flipAllowPublicMint() public onlyOwner {
1235         allowPublicMint = !allowPublicMint;
1236     }
1237 
1238     function setWhitelist( address[] memory newWhitelist ) external onlyOwner {
1239         for( uint256 i = 0 ; i < newWhitelist.length ; i++ ) {
1240             whitelist[newWhitelist[i]] = 1 ;
1241         }
1242     }
1243 
1244     function deleteWhitelist( address[] memory oldWhitelist ) external onlyOwner {
1245         for( uint256 i = 0 ; i < oldWhitelist.length ; i++ ) {
1246             whitelist[oldWhitelist[i]] = 0 ;
1247         }
1248     }
1249 
1250     function whitelistMint(
1251         uint256 quantity
1252     ) external payable {
1253         require( whitelist[msg.sender] > 0, "UNKNOWN: not permission to whitelist mint" );
1254         require( allowWhitelistMint, "UNKNOWN: not allow to mint now" );
1255         require( quantity >= 1, "UNKNOWN: quantity must be bigger then 1" );
1256         require( quantity <= upperQuantityLimit, string(abi.encodePacked("UNKNOWN: quantity must be smaller then upper quantity limit", upperQuantityLimit)));
1257         require( totalSupply() + quantity <= maxSupply, "UNKNOWN: out of max supply" );
1258         require( totalSupply() + quantity <= threshold, "UNKNOWN: out of current wave" );
1259         require( msg.value >= whitelistPrice * quantity, "UNKNOWN: not enough ether" );
1260         whitelist[msg.sender] = whitelist[msg.sender] - 1;
1261         _safeMint(msg.sender, quantity);
1262     }
1263 
1264     function publicMint(
1265         uint256 quantity
1266     ) external payable {
1267         require( allowPublicMint, "UNKNOWN: not allow to mint now" );
1268         require( quantity >= 1, "UNKNOWN: quantity must be bigger then 1" );
1269         require( quantity <= upperQuantityLimit, string(abi.encodePacked("UNKNOWN: quantity must be smaller then upper quantity limit", upperQuantityLimit)));
1270         require( totalSupply() + quantity <= maxSupply, "UNKNOWN: out of max supply" );
1271         require( totalSupply() + quantity <= threshold, "UNKNOWN: out of current wave" );
1272         require( msg.value >= publicPrice * quantity, "UNKNOWN: not enough ether" );
1273         _safeMint(msg.sender, quantity);
1274     }
1275 
1276     function devMint(uint256 quantity, address to) internal {
1277         _safeMint(to, quantity);
1278     }
1279 
1280     function airdrop(
1281         address to,
1282         uint256 quantity
1283     ) external onlyOwner {
1284         require( totalSupply() + quantity <= maxSupply, "UNKNOWN: out of max supply" );
1285         require( totalSupply() + quantity <= threshold, "UNKNOWN: out of current wave" );
1286         _safeMint(to, quantity);
1287     }
1288 
1289     function setTokenURI(
1290         string memory newBaseURI
1291     ) external onlyOwner {
1292         baseURI = newBaseURI;
1293     }
1294 
1295     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1296         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1297 
1298         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId), ".json")) : '';
1299     }
1300 
1301     function setWhitelistPrice(
1302         uint256 newWhitelistPrice
1303     ) external onlyOwner {
1304         whitelistPrice = newWhitelistPrice;
1305     }
1306 
1307     function setPublicPrice(
1308         uint256 newPublicPrice
1309     ) external onlyOwner {
1310         publicPrice = newPublicPrice;
1311     }
1312 
1313     function setThreshold(
1314         uint256 newThreshold
1315     ) external onlyOwner {
1316         threshold = newThreshold;
1317     }
1318 
1319     function setUpperQuantityLimit(
1320         uint256 newUpperQuantityLimit
1321     ) external onlyOwner {
1322         upperQuantityLimit = newUpperQuantityLimit;
1323     }
1324 
1325     function setBossAddress(
1326         address newBossAddress
1327     ) external onlyOwner {
1328         bossAddress = newBossAddress;
1329     }
1330 
1331     function withdraw() public onlyOwner {
1332         require(address(this).balance > 0, "UNKNOWN: insufficient balance");
1333         payable(bossAddress).transfer(address(this).balance);
1334     }
1335 }