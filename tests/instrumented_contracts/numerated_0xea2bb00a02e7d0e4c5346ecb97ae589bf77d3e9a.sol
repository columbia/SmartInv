1 /**
2  *Submitted for verification at Etherscan.io on 2022-06-11
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2022-06-10
7 */
8 
9 /**
10  *Submitted for verification at Etherscan.io on 2022-06-09
11 */
12 
13 /**
14  *Submitted for verification at Etherscan.io on 2022-06-02
15 */
16 
17 // File: @openzeppelin/contracts/utils/Context.sol
18 
19 
20 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
21 
22 pragma solidity ^0.8.0;
23 
24 /**
25  * @dev Provides information about the current execution context, including the
26  * sender of the transaction and its data. While these are generally available
27  * via msg.sender and msg.data, they should not be accessed in such a direct
28  * manner, since when dealing with meta-transactions the account sending and
29  * paying for execution may not be the actual sender (as far as an application
30  * is concerned).
31  *
32  * This contract is only required for intermediate, library-like contracts.
33  */
34 abstract contract Context {
35     function _msgSender() internal view virtual returns (address) {
36         return msg.sender;
37     }
38 
39     function _msgData() internal view virtual returns (bytes calldata) {
40         return msg.data;
41     }
42 }
43 
44 // File: @openzeppelin/contracts/access/Ownable.sol
45 
46 
47 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
48 
49 pragma solidity ^0.8.0;
50 
51 
52 /**
53  * @dev Contract module which provides a basic access control mechanism, where
54  * there is an account (an owner) that can be granted exclusive access to
55  * specific functions.
56  *
57  * By default, the owner account will be the one that deploys the contract. This
58  * can later be changed with {transferOwnership}.
59  *
60  * This module is used through inheritance. It will make available the modifier
61  * `onlyOwner`, which can be applied to your functions to restrict their use to
62  * the owner.
63  */
64 abstract contract Ownable is Context {
65     address private _owner;
66 
67     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
68 
69     /**
70      * @dev Initializes the contract setting the deployer as the initial owner.
71      */
72     constructor() {
73         _transferOwnership(_msgSender());
74     }
75 
76     /**
77      * @dev Returns the address of the current owner.
78      */
79     function owner() public view virtual returns (address) {
80         return _owner;
81     }
82 
83     /**
84      * @dev Throws if called by any account other than the owner.
85      */
86     modifier onlyOwner() {
87         require(owner() == _msgSender(), "Ownable: caller is not the owner");
88         _;
89     }
90 
91     /**
92      * @dev Leaves the contract without owner. It will not be possible to call
93      * `onlyOwner` functions anymore. Can only be called by the current owner.
94      *
95      * NOTE: Renouncing ownership will leave the contract without an owner,
96      * thereby removing any functionality that is only available to the owner.
97      */
98     function renounceOwnership() public virtual onlyOwner {
99         _transferOwnership(address(0));
100     }
101 
102     /**
103      * @dev Transfers ownership of the contract to a new account (`newOwner`).
104      * Can only be called by the current owner.
105      */
106     function transferOwnership(address newOwner) public virtual onlyOwner {
107         require(newOwner != address(0), "Ownable: new owner is the zero address");
108         _transferOwnership(newOwner);
109     }
110 
111     /**
112      * @dev Transfers ownership of the contract to a new account (`newOwner`).
113      * Internal function without access restriction.
114      */
115     function _transferOwnership(address newOwner) internal virtual {
116         address oldOwner = _owner;
117         _owner = newOwner;
118         emit OwnershipTransferred(oldOwner, newOwner);
119     }
120 }
121 
122 // File: erc721a/contracts/IERC721A.sol
123 
124 
125 // ERC721A Contracts v4.0.0
126 // Creator: Chiru Labs
127 
128 pragma solidity ^0.8.4;
129 
130 /**
131  * @dev Interface of an ERC721A compliant contract.
132  */
133 interface IERC721A {
134     /**
135      * The caller must own the token or be an approved operator.
136      */
137     error ApprovalCallerNotOwnerNorApproved();
138 
139     /**
140      * The token does not exist.
141      */
142     error ApprovalQueryForNonexistentToken();
143 
144     /**
145      * The caller cannot approve to their own address.
146      */
147     error ApproveToCaller();
148 
149     /**
150      * The caller cannot approve to the current owner.
151      */
152     error ApprovalToCurrentOwner();
153 
154     /**
155      * Cannot query the balance for the zero address.
156      */
157     error BalanceQueryForZeroAddress();
158 
159     /**
160      * Cannot mint to the zero address.
161      */
162     error MintToZeroAddress();
163 
164     /**
165      * The quantity of tokens minted must be more than zero.
166      */
167     error MintZeroQuantity();
168 
169     /**
170      * The token does not exist.
171      */
172     error OwnerQueryForNonexistentToken();
173 
174     /**
175      * The caller must own the token or be an approved operator.
176      */
177     error TransferCallerNotOwnerNorApproved();
178 
179     /**
180      * The token must be owned by `from`.
181      */
182     error TransferFromIncorrectOwner();
183 
184     /**
185      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
186      */
187     error TransferToNonERC721ReceiverImplementer();
188 
189     /**
190      * Cannot transfer to the zero address.
191      */
192     error TransferToZeroAddress();
193 
194     /**
195      * The token does not exist.
196      */
197     error URIQueryForNonexistentToken();
198 
199     struct TokenOwnership {
200         // The address of the owner.
201         address addr;
202         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
203         uint64 startTimestamp;
204         // Whether the token has been burned.
205         bool burned;
206     }
207 
208     /**
209      * @dev Returns the total amount of tokens stored by the contract.
210      *
211      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
212      */
213     function totalSupply() external view returns (uint256);
214 
215     // ==============================
216     //            IERC165
217     // ==============================
218 
219     /**
220      * @dev Returns true if this contract implements the interface defined by
221      * `interfaceId`. See the corresponding
222      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
223      * to learn more about how these ids are created.
224      *
225      * This function call must use less than 30 000 gas.
226      */
227     function supportsInterface(bytes4 interfaceId) external view returns (bool);
228 
229     // ==============================
230     //            IERC721
231     // ==============================
232 
233     /**
234      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
235      */
236     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
237 
238     /**
239      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
240      */
241     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
242 
243     /**
244      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
245      */
246     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
247 
248     /**
249      * @dev Returns the number of tokens in ``owner``'s account.
250      */
251     function balanceOf(address owner) external view returns (uint256 balance);
252 
253     /**
254      * @dev Returns the owner of the `tokenId` token.
255      *
256      * Requirements:
257      *
258      * - `tokenId` must exist.
259      */
260     function ownerOf(uint256 tokenId) external view returns (address owner);
261 
262     /**
263      * @dev Safely transfers `tokenId` token from `from` to `to`.
264      *
265      * Requirements:
266      *
267      * - `from` cannot be the zero address.
268      * - `to` cannot be the zero address.
269      * - `tokenId` token must exist and be owned by `from`.
270      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
271      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
272      *
273      * Emits a {Transfer} event.
274      */
275     function safeTransferFrom(
276         address from,
277         address to,
278         uint256 tokenId,
279         bytes calldata data
280     ) external;
281 
282     /**
283      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
284      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
285      *
286      * Requirements:
287      *
288      * - `from` cannot be the zero address.
289      * - `to` cannot be the zero address.
290      * - `tokenId` token must exist and be owned by `from`.
291      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
292      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
293      *
294      * Emits a {Transfer} event.
295      */
296     function safeTransferFrom(
297         address from,
298         address to,
299         uint256 tokenId
300     ) external;
301 
302     /**
303      * @dev Transfers `tokenId` token from `from` to `to`.
304      *
305      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
306      *
307      * Requirements:
308      *
309      * - `from` cannot be the zero address.
310      * - `to` cannot be the zero address.
311      * - `tokenId` token must be owned by `from`.
312      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
313      *
314      * Emits a {Transfer} event.
315      */
316     function transferFrom(
317         address from,
318         address to,
319         uint256 tokenId
320     ) external;
321 
322     /**
323      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
324      * The approval is cleared when the token is transferred.
325      *
326      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
327      *
328      * Requirements:
329      *
330      * - The caller must own the token or be an approved operator.
331      * - `tokenId` must exist.
332      *
333      * Emits an {Approval} event.
334      */
335     function approve(address to, uint256 tokenId) external;
336 
337     /**
338      * @dev Approve or remove `operator` as an operator for the caller.
339      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
340      *
341      * Requirements:
342      *
343      * - The `operator` cannot be the caller.
344      *
345      * Emits an {ApprovalForAll} event.
346      */
347     function setApprovalForAll(address operator, bool _approved) external;
348 
349     /**
350      * @dev Returns the account approved for `tokenId` token.
351      *
352      * Requirements:
353      *
354      * - `tokenId` must exist.
355      */
356     function getApproved(uint256 tokenId) external view returns (address operator);
357 
358     /**
359      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
360      *
361      * See {setApprovalForAll}
362      */
363     function isApprovedForAll(address owner, address operator) external view returns (bool);
364 
365     // ==============================
366     //        IERC721Metadata
367     // ==============================
368 
369     /**
370      * @dev Returns the token collection name.
371      */
372     function name() external view returns (string memory);
373 
374     /**
375      * @dev Returns the token collection symbol.
376      */
377     function symbol() external view returns (string memory);
378 
379     /**
380      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
381      */
382     function tokenURI(uint256 tokenId) external view returns (string memory);
383 }
384 
385 // File: erc721a/contracts/ERC721A.sol
386 
387 
388 // ERC721A Contracts v4.0.0
389 // Creator: Chiru Labs
390 
391 pragma solidity ^0.8.4;
392 
393 
394 /**
395  * @dev ERC721 token receiver interface.
396  */
397 interface ERC721A__IERC721Receiver {
398     function onERC721Received(
399         address operator,
400         address from,
401         uint256 tokenId,
402         bytes calldata data
403     ) external returns (bytes4);
404 }
405 
406 /**
407  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
408  * the Metadata extension. Built to optimize for lower gas during batch mints.
409  *
410  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
411  *
412  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
413  *
414  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
415  */
416 contract ERC721A is IERC721A {
417     // Mask of an entry in packed address data.
418     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
419 
420     // The bit position of `numberMinted` in packed address data.
421     uint256 private constant BITPOS_NUMBER_MINTED = 64;
422 
423     // The bit position of `numberBurned` in packed address data.
424     uint256 private constant BITPOS_NUMBER_BURNED = 128;
425 
426     // The bit position of `aux` in packed address data.
427     uint256 private constant BITPOS_AUX = 192;
428 
429     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
430     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
431 
432     // The bit position of `startTimestamp` in packed ownership.
433     uint256 private constant BITPOS_START_TIMESTAMP = 160;
434 
435     // The bit mask of the `burned` bit in packed ownership.
436     uint256 private constant BITMASK_BURNED = 1 << 224;
437     
438     // The bit position of the `nextInitialized` bit in packed ownership.
439     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
440 
441     // The bit mask of the `nextInitialized` bit in packed ownership.
442     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
443 
444     // The tokenId of the next token to be minted.
445     uint256 private _currentIndex;
446 
447     // The number of tokens burned.
448     uint256 private _burnCounter;
449 
450     // Token name
451     string private _name;
452 
453     // Token symbol
454     string private _symbol;
455 
456     // Mapping from token ID to ownership details
457     // An empty struct value does not necessarily mean the token is unowned.
458     // See `_packedOwnershipOf` implementation for details.
459     //
460     // Bits Layout:
461     // - [0..159]   `addr`
462     // - [160..223] `startTimestamp`
463     // - [224]      `burned`
464     // - [225]      `nextInitialized`
465     mapping(uint256 => uint256) private _packedOwnerships;
466 
467     // Mapping owner address to address data.
468     //
469     // Bits Layout:
470     // - [0..63]    `balance`
471     // - [64..127]  `numberMinted`
472     // - [128..191] `numberBurned`
473     // - [192..255] `aux`
474     mapping(address => uint256) private _packedAddressData;
475 
476     // Mapping from token ID to approved address.
477     mapping(uint256 => address) private _tokenApprovals;
478 
479     // Mapping from owner to operator approvals
480     mapping(address => mapping(address => bool)) private _operatorApprovals;
481 
482     constructor(string memory name_, string memory symbol_) {
483         _name = name_;
484         _symbol = symbol_;
485         _currentIndex = _startTokenId();
486     }
487 
488     /**
489      * @dev Returns the starting token ID. 
490      * To change the starting token ID, please override this function.
491      */
492     function _startTokenId() internal view virtual returns (uint256) {
493         return 0;
494     }
495 
496     /**
497      * @dev Returns the next token ID to be minted.
498      */
499     function _nextTokenId() internal view returns (uint256) {
500         return _currentIndex;
501     }
502 
503     /**
504      * @dev Returns the total number of tokens in existence.
505      * Burned tokens will reduce the count. 
506      * To get the total number of tokens minted, please see `_totalMinted`.
507      */
508     function totalSupply() public view override returns (uint256) {
509         // Counter underflow is impossible as _burnCounter cannot be incremented
510         // more than `_currentIndex - _startTokenId()` times.
511         unchecked {
512             return _currentIndex - _burnCounter - _startTokenId();
513         }
514     }
515 
516     /**
517      * @dev Returns the total amount of tokens minted in the contract.
518      */
519     function _totalMinted() internal view returns (uint256) {
520         // Counter underflow is impossible as _currentIndex does not decrement,
521         // and it is initialized to `_startTokenId()`
522         unchecked {
523             return _currentIndex - _startTokenId();
524         }
525     }
526 
527     /**
528      * @dev Returns the total number of tokens burned.
529      */
530     function _totalBurned() internal view returns (uint256) {
531         return _burnCounter;
532     }
533 
534     /**
535      * @dev See {IERC165-supportsInterface}.
536      */
537     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
538         // The interface IDs are constants representing the first 4 bytes of the XOR of
539         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
540         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
541         return
542             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
543             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
544             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
545     }
546 
547     /**
548      * @dev See {IERC721-balanceOf}.
549      */
550     function balanceOf(address owner) public view override returns (uint256) {
551         if (owner == address(0)) revert BalanceQueryForZeroAddress();
552         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
553     }
554 
555     /**
556      * Returns the number of tokens minted by `owner`.
557      */
558     function _numberMinted(address owner) internal view returns (uint256) {
559         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
560     }
561 
562     /**
563      * Returns the number of tokens burned by or on behalf of `owner`.
564      */
565     function _numberBurned(address owner) internal view returns (uint256) {
566         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
567     }
568 
569     /**
570      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
571      */
572     function _getAux(address owner) internal view returns (uint64) {
573         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
574     }
575 
576     /**
577      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
578      * If there are multiple variables, please pack them into a uint64.
579      */
580     function _setAux(address owner, uint64 aux) internal {
581         uint256 packed = _packedAddressData[owner];
582         uint256 auxCasted;
583         assembly { // Cast aux without masking.
584             auxCasted := aux
585         }
586         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
587         _packedAddressData[owner] = packed;
588     }
589 
590     /**
591      * Returns the packed ownership data of `tokenId`.
592      */
593     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
594         uint256 curr = tokenId;
595 
596         unchecked {
597             if (_startTokenId() <= curr)
598                 if (curr < _currentIndex) {
599                     uint256 packed = _packedOwnerships[curr];
600                     // If not burned.
601                     if (packed & BITMASK_BURNED == 0) {
602                         // Invariant:
603                         // There will always be an ownership that has an address and is not burned
604                         // before an ownership that does not have an address and is not burned.
605                         // Hence, curr will not underflow.
606                         //
607                         // We can directly compare the packed value.
608                         // If the address is zero, packed is zero.
609                         while (packed == 0) {
610                             packed = _packedOwnerships[--curr];
611                         }
612                         return packed;
613                     }
614                 }
615         }
616         revert OwnerQueryForNonexistentToken();
617     }
618 
619     /**
620      * Returns the unpacked `TokenOwnership` struct from `packed`.
621      */
622     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
623         ownership.addr = address(uint160(packed));
624         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
625         ownership.burned = packed & BITMASK_BURNED != 0;
626     }
627 
628     /**
629      * Returns the unpacked `TokenOwnership` struct at `index`.
630      */
631     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
632         return _unpackedOwnership(_packedOwnerships[index]);
633     }
634 
635     /**
636      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
637      */
638     function _initializeOwnershipAt(uint256 index) internal {
639         if (_packedOwnerships[index] == 0) {
640             _packedOwnerships[index] = _packedOwnershipOf(index);
641         }
642     }
643 
644     /**
645      * Gas spent here starts off proportional to the maximum mint batch size.
646      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
647      */
648     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
649         return _unpackedOwnership(_packedOwnershipOf(tokenId));
650     }
651 
652     /**
653      * @dev See {IERC721-ownerOf}.
654      */
655     function ownerOf(uint256 tokenId) public view override returns (address) {
656         return address(uint160(_packedOwnershipOf(tokenId)));
657     }
658 
659     /**
660      * @dev See {IERC721Metadata-name}.
661      */
662     function name() public view virtual override returns (string memory) {
663         return _name;
664     }
665 
666     /**
667      * @dev See {IERC721Metadata-symbol}.
668      */
669     function symbol() public view virtual override returns (string memory) {
670         return _symbol;
671     }
672 
673     /**
674      * @dev See {IERC721Metadata-tokenURI}.
675      */
676     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
677         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
678 
679         string memory baseURI = _baseURI();
680         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
681     }
682 
683     /**
684      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
685      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
686      * by default, can be overriden in child contracts.
687      */
688     function _baseURI() internal view virtual returns (string memory) {
689         return '';
690     }
691 
692     /**
693      * @dev Casts the address to uint256 without masking.
694      */
695     function _addressToUint256(address value) private pure returns (uint256 result) {
696         assembly {
697             result := value
698         }
699     }
700 
701     /**
702      * @dev Casts the boolean to uint256 without branching.
703      */
704     function _boolToUint256(bool value) private pure returns (uint256 result) {
705         assembly {
706             result := value
707         }
708     }
709 
710     /**
711      * @dev See {IERC721-approve}.
712      */
713     function approve(address to, uint256 tokenId) public override {
714         address owner = address(uint160(_packedOwnershipOf(tokenId)));
715         if (to == owner) revert ApprovalToCurrentOwner();
716 
717         if (_msgSenderERC721A() != owner)
718             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
719                 revert ApprovalCallerNotOwnerNorApproved();
720             }
721 
722         _tokenApprovals[tokenId] = to;
723         emit Approval(owner, to, tokenId);
724     }
725 
726     /**
727      * @dev See {IERC721-getApproved}.
728      */
729     function getApproved(uint256 tokenId) public view override returns (address) {
730         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
731 
732         return _tokenApprovals[tokenId];
733     }
734 
735     /**
736      * @dev See {IERC721-setApprovalForAll}.
737      */
738     function setApprovalForAll(address operator, bool approved) public virtual override {
739         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
740 
741         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
742         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
743     }
744 
745     /**
746      * @dev See {IERC721-isApprovedForAll}.
747      */
748     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
749         return _operatorApprovals[owner][operator];
750     }
751 
752     /**
753      * @dev See {IERC721-transferFrom}.
754      */
755     function transferFrom(
756         address from,
757         address to,
758         uint256 tokenId
759     ) public virtual override {
760         _transfer(from, to, tokenId);
761     }
762 
763     /**
764      * @dev See {IERC721-safeTransferFrom}.
765      */
766     function safeTransferFrom(
767         address from,
768         address to,
769         uint256 tokenId
770     ) public virtual override {
771         safeTransferFrom(from, to, tokenId, '');
772     }
773 
774     /**
775      * @dev See {IERC721-safeTransferFrom}.
776      */
777     function safeTransferFrom(
778         address from,
779         address to,
780         uint256 tokenId,
781         bytes memory _data
782     ) public virtual override {
783         _transfer(from, to, tokenId);
784         if (to.code.length != 0)
785             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
786                 revert TransferToNonERC721ReceiverImplementer();
787             }
788     }
789 
790     /**
791      * @dev Returns whether `tokenId` exists.
792      *
793      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
794      *
795      * Tokens start existing when they are minted (`_mint`),
796      */
797     function _exists(uint256 tokenId) internal view returns (bool) {
798         return
799             _startTokenId() <= tokenId &&
800             tokenId < _currentIndex && // If within bounds,
801             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
802     }
803 
804     /**
805      * @dev Equivalent to `_safeMint(to, quantity, '')`.
806      */
807     function _safeMint(address to, uint256 quantity) internal {
808         _safeMint(to, quantity, '');
809     }
810 
811     /**
812      * @dev Safely mints `quantity` tokens and transfers them to `to`.
813      *
814      * Requirements:
815      *
816      * - If `to` refers to a smart contract, it must implement
817      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
818      * - `quantity` must be greater than 0.
819      *
820      * Emits a {Transfer} event.
821      */
822     function _safeMint(
823         address to,
824         uint256 quantity,
825         bytes memory _data
826     ) internal {
827         uint256 startTokenId = _currentIndex;
828         if (to == address(0)) revert MintToZeroAddress();
829         if (quantity == 0) revert MintZeroQuantity();
830 
831         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
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
860                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
861                         revert TransferToNonERC721ReceiverImplementer();
862                     }
863                 } while (updatedIndex < end);
864                 // Reentrancy protection
865                 if (_currentIndex != startTokenId) revert();
866             } else {
867                 do {
868                     emit Transfer(address(0), to, updatedIndex++);
869                 } while (updatedIndex < end);
870             }
871             _currentIndex = updatedIndex;
872         }
873         _afterTokenTransfers(address(0), to, startTokenId, quantity);
874     }
875 
876     /**
877      * @dev Mints `quantity` tokens and transfers them to `to`.
878      *
879      * Requirements:
880      *
881      * - `to` cannot be the zero address.
882      * - `quantity` must be greater than 0.
883      *
884      * Emits a {Transfer} event.
885      */
886     function _mint(address to, uint256 quantity) internal {
887         uint256 startTokenId = _currentIndex;
888         if (to == address(0)) revert MintToZeroAddress();
889         if (quantity == 0) revert MintZeroQuantity();
890 
891         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
892 
893         // Overflows are incredibly unrealistic.
894         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
895         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
896         unchecked {
897             // Updates:
898             // - `balance += quantity`.
899             // - `numberMinted += quantity`.
900             //
901             // We can directly add to the balance and number minted.
902             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
903 
904             // Updates:
905             // - `address` to the owner.
906             // - `startTimestamp` to the timestamp of minting.
907             // - `burned` to `false`.
908             // - `nextInitialized` to `quantity == 1`.
909             _packedOwnerships[startTokenId] =
910                 _addressToUint256(to) |
911                 (block.timestamp << BITPOS_START_TIMESTAMP) |
912                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
913 
914             uint256 updatedIndex = startTokenId;
915             uint256 end = updatedIndex + quantity;
916 
917             do {
918                 emit Transfer(address(0), to, updatedIndex++);
919             } while (updatedIndex < end);
920 
921             _currentIndex = updatedIndex;
922         }
923         _afterTokenTransfers(address(0), to, startTokenId, quantity);
924     }
925 
926     /**
927      * @dev Transfers `tokenId` from `from` to `to`.
928      *
929      * Requirements:
930      *
931      * - `to` cannot be the zero address.
932      * - `tokenId` token must be owned by `from`.
933      *
934      * Emits a {Transfer} event.
935      */
936     function _transfer(
937         address from,
938         address to,
939         uint256 tokenId
940     ) private {
941         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
942 
943         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
944 
945         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
946             isApprovedForAll(from, _msgSenderERC721A()) ||
947             getApproved(tokenId) == _msgSenderERC721A());
948 
949         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
950         if (to == address(0)) revert TransferToZeroAddress();
951 
952         _beforeTokenTransfers(from, to, tokenId, 1);
953 
954         // Clear approvals from the previous owner.
955         delete _tokenApprovals[tokenId];
956 
957         // Underflow of the sender's balance is impossible because we check for
958         // ownership above and the recipient's balance can't realistically overflow.
959         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
960         unchecked {
961             // We can directly increment and decrement the balances.
962             --_packedAddressData[from]; // Updates: `balance -= 1`.
963             ++_packedAddressData[to]; // Updates: `balance += 1`.
964 
965             // Updates:
966             // - `address` to the next owner.
967             // - `startTimestamp` to the timestamp of transfering.
968             // - `burned` to `false`.
969             // - `nextInitialized` to `true`.
970             _packedOwnerships[tokenId] =
971                 _addressToUint256(to) |
972                 (block.timestamp << BITPOS_START_TIMESTAMP) |
973                 BITMASK_NEXT_INITIALIZED;
974 
975             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
976             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
977                 uint256 nextTokenId = tokenId + 1;
978                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
979                 if (_packedOwnerships[nextTokenId] == 0) {
980                     // If the next slot is within bounds.
981                     if (nextTokenId != _currentIndex) {
982                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
983                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
984                     }
985                 }
986             }
987         }
988 
989         emit Transfer(from, to, tokenId);
990         _afterTokenTransfers(from, to, tokenId, 1);
991     }
992 
993     /**
994      * @dev Equivalent to `_burn(tokenId, false)`.
995      */
996     function _burn(uint256 tokenId) internal virtual {
997         _burn(tokenId, false);
998     }
999 
1000     /**
1001      * @dev Destroys `tokenId`.
1002      * The approval is cleared when the token is burned.
1003      *
1004      * Requirements:
1005      *
1006      * - `tokenId` must exist.
1007      *
1008      * Emits a {Transfer} event.
1009      */
1010     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1011         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1012 
1013         address from = address(uint160(prevOwnershipPacked));
1014 
1015         if (approvalCheck) {
1016             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1017                 isApprovedForAll(from, _msgSenderERC721A()) ||
1018                 getApproved(tokenId) == _msgSenderERC721A());
1019 
1020             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1021         }
1022 
1023         _beforeTokenTransfers(from, address(0), tokenId, 1);
1024 
1025         // Clear approvals from the previous owner.
1026         delete _tokenApprovals[tokenId];
1027 
1028         // Underflow of the sender's balance is impossible because we check for
1029         // ownership above and the recipient's balance can't realistically overflow.
1030         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1031         unchecked {
1032             // Updates:
1033             // - `balance -= 1`.
1034             // - `numberBurned += 1`.
1035             //
1036             // We can directly decrement the balance, and increment the number burned.
1037             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1038             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1039 
1040             // Updates:
1041             // - `address` to the last owner.
1042             // - `startTimestamp` to the timestamp of burning.
1043             // - `burned` to `true`.
1044             // - `nextInitialized` to `true`.
1045             _packedOwnerships[tokenId] =
1046                 _addressToUint256(from) |
1047                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1048                 BITMASK_BURNED | 
1049                 BITMASK_NEXT_INITIALIZED;
1050 
1051             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1052             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1053                 uint256 nextTokenId = tokenId + 1;
1054                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1055                 if (_packedOwnerships[nextTokenId] == 0) {
1056                     // If the next slot is within bounds.
1057                     if (nextTokenId != _currentIndex) {
1058                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1059                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1060                     }
1061                 }
1062             }
1063         }
1064 
1065         emit Transfer(from, address(0), tokenId);
1066         _afterTokenTransfers(from, address(0), tokenId, 1);
1067 
1068         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1069         unchecked {
1070             _burnCounter++;
1071         }
1072     }
1073 
1074     /**
1075      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1076      *
1077      * @param from address representing the previous owner of the given token ID
1078      * @param to target address that will receive the tokens
1079      * @param tokenId uint256 ID of the token to be transferred
1080      * @param _data bytes optional data to send along with the call
1081      * @return bool whether the call correctly returned the expected magic value
1082      */
1083     function _checkContractOnERC721Received(
1084         address from,
1085         address to,
1086         uint256 tokenId,
1087         bytes memory _data
1088     ) private returns (bool) {
1089         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1090             bytes4 retval
1091         ) {
1092             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1093         } catch (bytes memory reason) {
1094             if (reason.length == 0) {
1095                 revert TransferToNonERC721ReceiverImplementer();
1096             } else {
1097                 assembly {
1098                     revert(add(32, reason), mload(reason))
1099                 }
1100             }
1101         }
1102     }
1103 
1104     /**
1105      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1106      * And also called before burning one token.
1107      *
1108      * startTokenId - the first token id to be transferred
1109      * quantity - the amount to be transferred
1110      *
1111      * Calling conditions:
1112      *
1113      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1114      * transferred to `to`.
1115      * - When `from` is zero, `tokenId` will be minted for `to`.
1116      * - When `to` is zero, `tokenId` will be burned by `from`.
1117      * - `from` and `to` are never both zero.
1118      */
1119     function _beforeTokenTransfers(
1120         address from,
1121         address to,
1122         uint256 startTokenId,
1123         uint256 quantity
1124     ) internal virtual {}
1125 
1126     /**
1127      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1128      * minting.
1129      * And also called after one token has been burned.
1130      *
1131      * startTokenId - the first token id to be transferred
1132      * quantity - the amount to be transferred
1133      *
1134      * Calling conditions:
1135      *
1136      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1137      * transferred to `to`.
1138      * - When `from` is zero, `tokenId` has been minted for `to`.
1139      * - When `to` is zero, `tokenId` has been burned by `from`.
1140      * - `from` and `to` are never both zero.
1141      */
1142     function _afterTokenTransfers(
1143         address from,
1144         address to,
1145         uint256 startTokenId,
1146         uint256 quantity
1147     ) internal virtual {}
1148 
1149     /**
1150      * @dev Returns the message sender (defaults to `msg.sender`).
1151      *
1152      * If you are writing GSN compatible contracts, you need to override this function.
1153      */
1154     function _msgSenderERC721A() internal view virtual returns (address) {
1155         return msg.sender;
1156     }
1157 
1158     /**
1159      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1160      */
1161     function _toString(uint256 value) internal pure returns (string memory ptr) {
1162         assembly {
1163             // The maximum value of a uint256 contains 78 digits (1 byte per digit), 
1164             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1165             // We will need 1 32-byte word to store the length, 
1166             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1167             ptr := add(mload(0x40), 128)
1168             // Update the free memory pointer to allocate.
1169             mstore(0x40, ptr)
1170 
1171             // Cache the end of the memory to calculate the length later.
1172             let end := ptr
1173 
1174             // We write the string from the rightmost digit to the leftmost digit.
1175             // The following is essentially a do-while loop that also handles the zero case.
1176             // Costs a bit more than early returning for the zero case,
1177             // but cheaper in terms of deployment and overall runtime costs.
1178             for { 
1179                 // Initialize and perform the first pass without check.
1180                 let temp := value
1181                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1182                 ptr := sub(ptr, 1)
1183                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1184                 mstore8(ptr, add(48, mod(temp, 10)))
1185                 temp := div(temp, 10)
1186             } temp { 
1187                 // Keep dividing `temp` until zero.
1188                 temp := div(temp, 10)
1189             } { // Body of the for loop.
1190                 ptr := sub(ptr, 1)
1191                 mstore8(ptr, add(48, mod(temp, 10)))
1192             }
1193             
1194             let length := sub(end, ptr)
1195             // Move the pointer 32 bytes leftwards to make room for the length.
1196             ptr := sub(ptr, 32)
1197             // Store the length.
1198             mstore(ptr, length)
1199         }
1200     }
1201 }
1202 
1203 // File: nft.sol
1204 
1205 
1206 // SPDX-License-Identifier: MIT
1207 pragma solidity ^0.8.13;
1208 
1209 
1210 
1211 contract wondercats is Ownable, ERC721A {
1212     uint256 public maxSupply                    = 7777;
1213     uint256 public maxFreeSupply                = 7777;
1214     
1215     uint256 public maxPerTxDuringMint           = 10;
1216     uint256 public maxPerAddressDuringMint      = 101;
1217     uint256 public maxPerAddressDuringFreeMint  = 1;
1218     
1219     uint256 public price                        = 0.003 ether;
1220     bool    public saleIsActive                 = false;
1221 
1222     address constant internal TEAM_ADDRESS = 0x7bDC9dFc38ab3772577F67bdfc3890Dd078209F5;
1223 
1224     string private _baseTokenURI;
1225 
1226     mapping(address => uint256) public freeMintedAmount;
1227     mapping(address => uint256) public mintedAmount;
1228 
1229     constructor() ERC721A("wondercats", "WCATS") {
1230         _safeMint(msg.sender, 10);
1231     }
1232 
1233     modifier mintCompliance() {
1234         require(saleIsActive, "Sale is not active yet.");
1235         require(tx.origin == msg.sender, "Wrong Caller");
1236         _;
1237     }
1238 
1239     function mint(uint256 _quantity) external payable mintCompliance() {
1240         require(
1241             msg.value >= price * _quantity,
1242             "GDZ: Insufficient Fund."
1243         );
1244         require(
1245             maxSupply >= totalSupply() + _quantity,
1246             "GDZ: Exceeds max supply."
1247         );
1248         uint256 _mintedAmount = mintedAmount[msg.sender];
1249         require(
1250             _mintedAmount + _quantity <= maxPerAddressDuringMint,
1251             "GDZ: Exceeds max mints per address!"
1252         );
1253         require(
1254             _quantity > 0 && _quantity <= maxPerTxDuringMint,
1255             "Invalid mint amount."
1256         );
1257         mintedAmount[msg.sender] = _mintedAmount + _quantity;
1258         _safeMint(msg.sender, _quantity);
1259     }
1260 
1261     function freeMint(uint256 _quantity) external mintCompliance() {
1262         require(
1263             maxFreeSupply >= totalSupply() + _quantity,
1264             "GDZ: Exceeds max supply."
1265         );
1266         uint256 _freeMintedAmount = freeMintedAmount[msg.sender];
1267         require(
1268             _freeMintedAmount + _quantity <= maxPerAddressDuringFreeMint,
1269             "GDZ: Exceeds max free mints per address!"
1270         );
1271         freeMintedAmount[msg.sender] = _freeMintedAmount + _quantity;
1272         _safeMint(msg.sender, _quantity);
1273     }
1274 
1275     function setPrice(uint256 _price) external onlyOwner {
1276         price = _price;
1277     }
1278 
1279     function setMaxPerTx(uint256 _amount) external onlyOwner {
1280         maxPerTxDuringMint = _amount;
1281     }
1282 
1283     function setMaxPerAddress(uint256 _amount) external onlyOwner {
1284         maxPerAddressDuringMint = _amount;
1285     }
1286 
1287     function setMaxFreePerAddress(uint256 _amount) external onlyOwner {
1288         maxPerAddressDuringFreeMint = _amount;
1289     }
1290 
1291     function flipSale() public onlyOwner {
1292         saleIsActive = !saleIsActive;
1293     }
1294 
1295     function cutMaxSupply(uint256 _amount) public onlyOwner {
1296         require(
1297             maxSupply - _amount >= totalSupply(), 
1298             "Supply cannot fall below minted tokens."
1299         );
1300         maxSupply -= _amount;
1301     }
1302 
1303     function setBaseURI(string calldata baseURI) external onlyOwner {
1304         _baseTokenURI = baseURI;
1305     }
1306 
1307     function _baseURI() internal view virtual override returns (string memory) {
1308         return _baseTokenURI;
1309     }
1310 
1311     function withdrawBalance() external payable onlyOwner {
1312 
1313         (bool success, ) = payable(TEAM_ADDRESS).call{
1314             value: address(this).balance
1315         }("");
1316         require(success, "transfer failed.");
1317     }
1318 }