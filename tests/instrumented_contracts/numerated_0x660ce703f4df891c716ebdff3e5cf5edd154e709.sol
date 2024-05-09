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
31 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
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
61      * @dev Throws if called by any account other than the owner.
62      */
63     modifier onlyOwner() {
64         _checkOwner();
65         _;
66     }
67 
68     /**
69      * @dev Returns the address of the current owner.
70      */
71     function owner() public view virtual returns (address) {
72         return _owner;
73     }
74 
75     /**
76      * @dev Throws if the sender is not the owner.
77      */
78     function _checkOwner() internal view virtual {
79         require(owner() == _msgSender(), "Ownable: caller is not the owner");
80     }
81 
82     /**
83      * @dev Leaves the contract without owner. It will not be possible to call
84      * `onlyOwner` functions anymore. Can only be called by the current owner.
85      *
86      * NOTE: Renouncing ownership will leave the contract without an owner,
87      * thereby removing any functionality that is only available to the owner.
88      */
89     function renounceOwnership() public virtual onlyOwner {
90         _transferOwnership(address(0));
91     }
92 
93     /**
94      * @dev Transfers ownership of the contract to a new account (`newOwner`).
95      * Can only be called by the current owner.
96      */
97     function transferOwnership(address newOwner) public virtual onlyOwner {
98         require(newOwner != address(0), "Ownable: new owner is the zero address");
99         _transferOwnership(newOwner);
100     }
101 
102     /**
103      * @dev Transfers ownership of the contract to a new account (`newOwner`).
104      * Internal function without access restriction.
105      */
106     function _transferOwnership(address newOwner) internal virtual {
107         address oldOwner = _owner;
108         _owner = newOwner;
109         emit OwnershipTransferred(oldOwner, newOwner);
110     }
111 }
112 
113 // File: contracts/IERC721A.sol
114 
115 
116 // ERC721A Contracts v4.0.0
117 // Creator: Chiru Labs
118 
119 pragma solidity ^0.8.4;
120 
121 /**
122  * @dev Interface of an ERC721A compliant contract.
123  */
124 interface IERC721A {
125     /**
126      * The caller must own the token or be an approved operator.
127      */
128     error ApprovalCallerNotOwnerNorApproved();
129 
130     /**
131      * The token does not exist.
132      */
133     error ApprovalQueryForNonexistentToken();
134 
135     /**
136      * The caller cannot approve to their own address.
137      */
138     error ApproveToCaller();
139 
140     /**
141      * The caller cannot approve to the current owner.
142      */
143     error ApprovalToCurrentOwner();
144 
145     /**
146      * Cannot query the balance for the zero address.
147      */
148     error BalanceQueryForZeroAddress();
149 
150     /**
151      * Cannot mint to the zero address.
152      */
153     error MintToZeroAddress();
154 
155     /**
156      * The quantity of tokens minted must be more than zero.
157      */
158     error MintZeroQuantity();
159 
160     /**
161      * The token does not exist.
162      */
163     error OwnerQueryForNonexistentToken();
164 
165     /**
166      * The caller must own the token or be an approved operator.
167      */
168     error TransferCallerNotOwnerNorApproved();
169 
170     /**
171      * The token must be owned by `from`.
172      */
173     error TransferFromIncorrectOwner();
174 
175     /**
176      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
177      */
178     error TransferToNonERC721ReceiverImplementer();
179 
180     /**
181      * Cannot transfer to the zero address.
182      */
183     error TransferToZeroAddress();
184 
185     /**
186      * The token does not exist.
187      */
188     error URIQueryForNonexistentToken();
189 
190     struct TokenOwnership {
191         // The address of the owner.
192         address addr;
193         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
194         uint64 startTimestamp;
195         // Whether the token has been burned.
196         bool burned;
197     }
198 
199     /**
200      * @dev Returns the total amount of tokens stored by the contract.
201      *
202      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
203      */
204     function totalSupply() external view returns (uint256);
205 
206     // ==============================
207     //            IERC165
208     // ==============================
209 
210     /**
211      * @dev Returns true if this contract implements the interface defined by
212      * `interfaceId`. See the corresponding
213      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
214      * to learn more about how these ids are created.
215      *
216      * This function call must use less than 30 000 gas.
217      */
218     function supportsInterface(bytes4 interfaceId) external view returns (bool);
219 
220     // ==============================
221     //            IERC721
222     // ==============================
223 
224     /**
225      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
226      */
227     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
228 
229     /**
230      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
231      */
232     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
233 
234     /**
235      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
236      */
237     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
238 
239     /**
240      * @dev Returns the number of tokens in ``owner``'s account.
241      */
242     function balanceOf(address owner) external view returns (uint256 balance);
243 
244     /**
245      * @dev Returns the owner of the `tokenId` token.
246      *
247      * Requirements:
248      *
249      * - `tokenId` must exist.
250      */
251     function ownerOf(uint256 tokenId) external view returns (address owner);
252 
253     /**
254      * @dev Safely transfers `tokenId` token from `from` to `to`.
255      *
256      * Requirements:
257      *
258      * - `from` cannot be the zero address.
259      * - `to` cannot be the zero address.
260      * - `tokenId` token must exist and be owned by `from`.
261      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
262      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
263      *
264      * Emits a {Transfer} event.
265      */
266     function safeTransferFrom(
267         address from,
268         address to,
269         uint256 tokenId,
270         bytes calldata data
271     ) external;
272 
273     /**
274      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
275      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
276      *
277      * Requirements:
278      *
279      * - `from` cannot be the zero address.
280      * - `to` cannot be the zero address.
281      * - `tokenId` token must exist and be owned by `from`.
282      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
283      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
284      *
285      * Emits a {Transfer} event.
286      */
287     function safeTransferFrom(
288         address from,
289         address to,
290         uint256 tokenId
291     ) external;
292 
293     /**
294      * @dev Transfers `tokenId` token from `from` to `to`.
295      *
296      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
297      *
298      * Requirements:
299      *
300      * - `from` cannot be the zero address.
301      * - `to` cannot be the zero address.
302      * - `tokenId` token must be owned by `from`.
303      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
304      *
305      * Emits a {Transfer} event.
306      */
307     function transferFrom(
308         address from,
309         address to,
310         uint256 tokenId
311     ) external;
312 
313     /**
314      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
315      * The approval is cleared when the token is transferred.
316      *
317      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
318      *
319      * Requirements:
320      *
321      * - The caller must own the token or be an approved operator.
322      * - `tokenId` must exist.
323      *
324      * Emits an {Approval} event.
325      */
326     function approve(address to, uint256 tokenId) external;
327 
328     /**
329      * @dev Approve or remove `operator` as an operator for the caller.
330      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
331      *
332      * Requirements:
333      *
334      * - The `operator` cannot be the caller.
335      *
336      * Emits an {ApprovalForAll} event.
337      */
338     function setApprovalForAll(address operator, bool _approved) external;
339 
340     /**
341      * @dev Returns the account approved for `tokenId` token.
342      *
343      * Requirements:
344      *
345      * - `tokenId` must exist.
346      */
347     function getApproved(uint256 tokenId) external view returns (address operator);
348 
349     /**
350      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
351      *
352      * See {setApprovalForAll}
353      */
354     function isApprovedForAll(address owner, address operator) external view returns (bool);
355 
356     // ==============================
357     //        IERC721Metadata
358     // ==============================
359 
360     /**
361      * @dev Returns the token collection name.
362      */
363     function name() external view returns (string memory);
364 
365     /**
366      * @dev Returns the token collection symbol.
367      */
368     function symbol() external view returns (string memory);
369 
370     /**
371      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
372      */
373     function tokenURI(uint256 tokenId) external view returns (string memory);
374 }
375 // File: contracts/ERC721A.sol
376 
377 
378 // ERC721A Contracts v4.0.0
379 // Creator: Chiru Labs
380 
381 pragma solidity ^0.8.4;
382 
383 
384 /**
385  * @dev ERC721 token receiver interface.
386  */
387 interface ERC721A__IERC721Receiver {
388     function onERC721Received(
389         address operator,
390         address from,
391         uint256 tokenId,
392         bytes calldata data
393     ) external returns (bytes4);
394 }
395 
396 /**
397  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
398  * the Metadata extension. Built to optimize for lower gas during batch mints.
399  *
400  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
401  *
402  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
403  *
404  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
405  */
406 contract ERC721A is IERC721A {
407     // Mask of an entry in packed address data.
408     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
409 
410     // The bit position of `numberMinted` in packed address data.
411     uint256 private constant BITPOS_NUMBER_MINTED = 64;
412 
413     // The bit position of `numberBurned` in packed address data.
414     uint256 private constant BITPOS_NUMBER_BURNED = 128;
415 
416     // The bit position of `aux` in packed address data.
417     uint256 private constant BITPOS_AUX = 192;
418 
419     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
420     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
421 
422     // The bit position of `startTimestamp` in packed ownership.
423     uint256 private constant BITPOS_START_TIMESTAMP = 160;
424 
425     // The bit mask of the `burned` bit in packed ownership.
426     uint256 private constant BITMASK_BURNED = 1 << 224;
427 
428     // The bit position of the `nextInitialized` bit in packed ownership.
429     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
430 
431     // The bit mask of the `nextInitialized` bit in packed ownership.
432     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
433 
434     // The tokenId of the next token to be minted.
435     uint256 private _currentIndex;
436 
437     // The number of tokens burned.
438     uint256 private _burnCounter;
439 
440     // Token name
441     string private _name;
442 
443     // Token symbol
444     string private _symbol;
445 
446     // Mapping from token ID to ownership details
447     // An empty struct value does not necessarily mean the token is unowned.
448     // See `_packedOwnershipOf` implementation for details.
449     //
450     // Bits Layout:
451     // - [0..159]   `addr`
452     // - [160..223] `startTimestamp`
453     // - [224]      `burned`
454     // - [225]      `nextInitialized`
455     mapping(uint256 => uint256) private _packedOwnerships;
456 
457     // Mapping owner address to address data.
458     //
459     // Bits Layout:
460     // - [0..63]    `balance`
461     // - [64..127]  `numberMinted`
462     // - [128..191] `numberBurned`
463     // - [192..255] `aux`
464     mapping(address => uint256) private _packedAddressData;
465 
466     // Mapping from token ID to approved address.
467     mapping(uint256 => address) private _tokenApprovals;
468 
469     // Mapping from owner to operator approvals
470     mapping(address => mapping(address => bool)) private _operatorApprovals;
471 
472     constructor(string memory name_, string memory symbol_) {
473         _name = name_;
474         _symbol = symbol_;
475         _currentIndex = _startTokenId();
476     }
477 
478     /**
479      * @dev Returns the starting token ID.
480      * To change the starting token ID, please override this function.
481      */
482     function _startTokenId() internal view virtual returns (uint256) {
483         return 0;
484     }
485 
486     /**
487      * @dev Returns the next token ID to be minted.
488      */
489     function _nextTokenId() internal view returns (uint256) {
490         return _currentIndex;
491     }
492 
493     /**
494      * @dev Returns the total number of tokens in existence.
495      * Burned tokens will reduce the count.
496      * To get the total number of tokens minted, please see `_totalMinted`.
497      */
498     function totalSupply() public view override returns (uint256) {
499         // Counter underflow is impossible as _burnCounter cannot be incremented
500         // more than `_currentIndex - _startTokenId()` times.
501         unchecked {
502             return _currentIndex - _burnCounter - _startTokenId();
503         }
504     }
505 
506     /**
507      * @dev Returns the total amount of tokens minted in the contract.
508      */
509     function _totalMinted() internal view returns (uint256) {
510         // Counter underflow is impossible as _currentIndex does not decrement,
511         // and it is initialized to `_startTokenId()`
512         unchecked {
513             return _currentIndex - _startTokenId();
514         }
515     }
516 
517     /**
518      * @dev Returns the total number of tokens burned.
519      */
520     function _totalBurned() internal view returns (uint256) {
521         return _burnCounter;
522     }
523 
524     /**
525      * @dev See {IERC165-supportsInterface}.
526      */
527     function supportsInterface(bytes4 interfaceId)
528         public
529         view
530         virtual
531         override
532         returns (bool)
533     {
534         // The interface IDs are constants representing the first 4 bytes of the XOR of
535         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
536         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
537         return
538             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
539             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
540             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
541     }
542 
543     /**
544      * @dev See {IERC721-balanceOf}.
545      */
546     function balanceOf(address owner) public view override returns (uint256) {
547         if (owner == address(0)) revert BalanceQueryForZeroAddress();
548         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
549     }
550 
551     /**
552      * Returns the number of tokens minted by `owner`.
553      */
554     function _numberMinted(address owner) internal view returns (uint256) {
555         return
556             (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) &
557             BITMASK_ADDRESS_DATA_ENTRY;
558     }
559 
560     /**
561      * Returns the number of tokens burned by or on behalf of `owner`.
562      */
563     function _numberBurned(address owner) internal view returns (uint256) {
564         return
565             (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) &
566             BITMASK_ADDRESS_DATA_ENTRY;
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
583         assembly {
584             // Cast aux without masking.
585             auxCasted := aux
586         }
587         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
588         _packedAddressData[owner] = packed;
589     }
590 
591     /**
592      * Returns the packed ownership data of `tokenId`.
593      */
594     function _packedOwnershipOf(uint256 tokenId)
595         private
596         view
597         returns (uint256)
598     {
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
627     function _unpackedOwnership(uint256 packed)
628         private
629         pure
630         returns (TokenOwnership memory ownership)
631     {
632         ownership.addr = address(uint160(packed));
633         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
634         ownership.burned = packed & BITMASK_BURNED != 0;
635     }
636 
637     /**
638      * Returns the unpacked `TokenOwnership` struct at `index`.
639      */
640     function _ownershipAt(uint256 index)
641         internal
642         view
643         returns (TokenOwnership memory)
644     {
645         return _unpackedOwnership(_packedOwnerships[index]);
646     }
647 
648     /**
649      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
650      */
651     function _initializeOwnershipAt(uint256 index) internal {
652         if (_packedOwnerships[index] == 0) {
653             _packedOwnerships[index] = _packedOwnershipOf(index);
654         }
655     }
656 
657     /**
658      * Gas spent here starts off proportional to the maximum mint batch size.
659      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
660      */
661     function _ownershipOf(uint256 tokenId)
662         internal
663         view
664         returns (TokenOwnership memory)
665     {
666         return _unpackedOwnership(_packedOwnershipOf(tokenId));
667     }
668 
669     /**
670      * @dev See {IERC721-ownerOf}.
671      */
672     function ownerOf(uint256 tokenId) public view override returns (address) {
673         return address(uint160(_packedOwnershipOf(tokenId)));
674     }
675 
676     /**
677      * @dev See {IERC721Metadata-name}.
678      */
679     function name() public view virtual override returns (string memory) {
680         return _name;
681     }
682 
683     /**
684      * @dev See {IERC721Metadata-symbol}.
685      */
686     function symbol() public view virtual override returns (string memory) {
687         return _symbol;
688     }
689 
690     /**
691      * @dev See {IERC721Metadata-tokenURI}.
692      */
693     function tokenURI(uint256 tokenId)
694         public
695         view
696         virtual
697         override
698         returns (string memory)
699     {
700         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
701 
702         string memory baseURI = _baseURI();
703         return
704             bytes(baseURI).length != 0
705                 ? string(abi.encodePacked(baseURI, _toString(tokenId)))
706                 : "";
707     }
708 
709     /**
710      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
711      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
712      * by default, can be overriden in child contracts.
713      */
714     function _baseURI() internal view virtual returns (string memory) {
715         return "";
716     }
717 
718     /**
719      * @dev Casts the address to uint256 without masking.
720      */
721     function _addressToUint256(address value)
722         private
723         pure
724         returns (uint256 result)
725     {
726         assembly {
727             result := value
728         }
729     }
730 
731     /**
732      * @dev Casts the boolean to uint256 without branching.
733      */
734     function _boolToUint256(bool value) private pure returns (uint256 result) {
735         assembly {
736             result := value
737         }
738     }
739 
740     /**
741      * @dev See {IERC721-approve}.
742      */
743     function approve(address to, uint256 tokenId) public override {
744         address owner = address(uint160(_packedOwnershipOf(tokenId)));
745         if (to == owner) revert ApprovalToCurrentOwner();
746 
747         if (_msgSenderERC721A() != owner)
748             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
749                 revert ApprovalCallerNotOwnerNorApproved();
750             }
751 
752         _tokenApprovals[tokenId] = to;
753         emit Approval(owner, to, tokenId);
754     }
755 
756     /**
757      * @dev See {IERC721-getApproved}.
758      */
759     function getApproved(uint256 tokenId)
760         public
761         view
762         override
763         returns (address)
764     {
765         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
766 
767         return _tokenApprovals[tokenId];
768     }
769 
770     /**
771      * @dev See {IERC721-setApprovalForAll}.
772      */
773     function setApprovalForAll(address operator, bool approved)
774         public
775         virtual
776         override
777     {
778         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
779 
780         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
781         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
782     }
783 
784     /**
785      * @dev See {IERC721-isApprovedForAll}.
786      */
787     function isApprovedForAll(address owner, address operator)
788         public
789         view
790         virtual
791         override
792         returns (bool)
793     {
794         return _operatorApprovals[owner][operator];
795     }
796 
797     /**
798      * @dev See {IERC721-transferFrom}.
799      */
800     function transferFrom(
801         address from,
802         address to,
803         uint256 tokenId
804     ) public virtual override {
805         _transfer(from, to, tokenId);
806     }
807 
808     /**
809      * @dev See {IERC721-safeTransferFrom}.
810      */
811     function safeTransferFrom(
812         address from,
813         address to,
814         uint256 tokenId
815     ) public virtual override {
816         safeTransferFrom(from, to, tokenId, "");
817     }
818 
819     /**
820      * @dev See {IERC721-safeTransferFrom}.
821      */
822     function safeTransferFrom(
823         address from,
824         address to,
825         uint256 tokenId,
826         bytes memory _data
827     ) public virtual override {
828         _transfer(from, to, tokenId);
829         if (to.code.length != 0)
830             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
831                 revert TransferToNonERC721ReceiverImplementer();
832             }
833     }
834 
835     /**
836      * @dev Returns whether `tokenId` exists.
837      *
838      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
839      *
840      * Tokens start existing when they are minted (`_mint`),
841      */
842     function _exists(uint256 tokenId) internal view returns (bool) {
843         return
844             _startTokenId() <= tokenId &&
845             tokenId < _currentIndex && // If within bounds,
846             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
847     }
848 
849     /**
850      * @dev Equivalent to `_safeMint(to, quantity, '')`.
851      */
852     function _safeMint(address to, uint256 quantity) internal {
853         _safeMint(to, quantity, "");
854     }
855 
856     /**
857      * @dev Safely mints `quantity` tokens and transfers them to `to`.
858      *
859      * Requirements:
860      *
861      * - If `to` refers to a smart contract, it must implement
862      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
863      * - `quantity` must be greater than 0.
864      *
865      * Emits a {Transfer} event.
866      */
867     function _safeMint(
868         address to,
869         uint256 quantity,
870         bytes memory _data
871     ) internal {
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
887             _packedAddressData[to] +=
888                 quantity *
889                 ((1 << BITPOS_NUMBER_MINTED) | 1);
890 
891             // Updates:
892             // - `address` to the owner.
893             // - `startTimestamp` to the timestamp of minting.
894             // - `burned` to `false`.
895             // - `nextInitialized` to `quantity == 1`.
896             _packedOwnerships[startTokenId] =
897                 _addressToUint256(to) |
898                 (block.timestamp << BITPOS_START_TIMESTAMP) |
899                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
900 
901             uint256 updatedIndex = startTokenId;
902             uint256 end = updatedIndex + quantity;
903 
904             if (to.code.length != 0) {
905                 do {
906                     emit Transfer(address(0), to, updatedIndex);
907                     if (
908                         !_checkContractOnERC721Received(
909                             address(0),
910                             to,
911                             updatedIndex++,
912                             _data
913                         )
914                     ) {
915                         revert TransferToNonERC721ReceiverImplementer();
916                     }
917                 } while (updatedIndex < end);
918                 // Reentrancy protection
919                 if (_currentIndex != startTokenId) revert();
920             } else {
921                 do {
922                     emit Transfer(address(0), to, updatedIndex++);
923                 } while (updatedIndex < end);
924             }
925             _currentIndex = updatedIndex;
926         }
927         _afterTokenTransfers(address(0), to, startTokenId, quantity);
928     }
929 
930     /**
931      * @dev Mints `quantity` tokens and transfers them to `to`.
932      *
933      * Requirements:
934      *
935      * - `to` cannot be the zero address.
936      * - `quantity` must be greater than 0.
937      *
938      * Emits a {Transfer} event.
939      */
940     function _mint(address to, uint256 quantity) internal {
941         uint256 startTokenId = _currentIndex;
942         if (to == address(0)) revert MintToZeroAddress();
943         if (quantity == 0) revert MintZeroQuantity();
944 
945         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
946 
947         // Overflows are incredibly unrealistic.
948         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
949         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
950         unchecked {
951             // Updates:
952             // - `balance += quantity`.
953             // - `numberMinted += quantity`.
954             //
955             // We can directly add to the balance and number minted.
956             _packedAddressData[to] +=
957                 quantity *
958                 ((1 << BITPOS_NUMBER_MINTED) | 1);
959 
960             // Updates:
961             // - `address` to the owner.
962             // - `startTimestamp` to the timestamp of minting.
963             // - `burned` to `false`.
964             // - `nextInitialized` to `quantity == 1`.
965             _packedOwnerships[startTokenId] =
966                 _addressToUint256(to) |
967                 (block.timestamp << BITPOS_START_TIMESTAMP) |
968                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
969 
970             uint256 updatedIndex = startTokenId;
971             uint256 end = updatedIndex + quantity;
972 
973             do {
974                 emit Transfer(address(0), to, updatedIndex++);
975             } while (updatedIndex < end);
976 
977             _currentIndex = updatedIndex;
978         }
979         _afterTokenTransfers(address(0), to, startTokenId, quantity);
980     }
981 
982     /**
983      * @dev Transfers `tokenId` from `from` to `to`.
984      *
985      * Requirements:
986      *
987      * - `to` cannot be the zero address.
988      * - `tokenId` token must be owned by `from`.
989      *
990      * Emits a {Transfer} event.
991      */
992     function _transfer(
993         address from,
994         address to,
995         uint256 tokenId
996     ) private {
997         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
998 
999         if (address(uint160(prevOwnershipPacked)) != from)
1000             revert TransferFromIncorrectOwner();
1001 
1002         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1003             isApprovedForAll(from, _msgSenderERC721A()) ||
1004             getApproved(tokenId) == _msgSenderERC721A());
1005 
1006         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1007         if (to == address(0)) revert TransferToZeroAddress();
1008 
1009         _beforeTokenTransfers(from, to, tokenId, 1);
1010 
1011         // Clear approvals from the previous owner.
1012         delete _tokenApprovals[tokenId];
1013 
1014         // Underflow of the sender's balance is impossible because we check for
1015         // ownership above and the recipient's balance can't realistically overflow.
1016         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1017         unchecked {
1018             // We can directly increment and decrement the balances.
1019             --_packedAddressData[from]; // Updates: `balance -= 1`.
1020             ++_packedAddressData[to]; // Updates: `balance += 1`.
1021 
1022             // Updates:
1023             // - `address` to the next owner.
1024             // - `startTimestamp` to the timestamp of transfering.
1025             // - `burned` to `false`.
1026             // - `nextInitialized` to `true`.
1027             _packedOwnerships[tokenId] =
1028                 _addressToUint256(to) |
1029                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1030                 BITMASK_NEXT_INITIALIZED;
1031 
1032             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1033             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1034                 uint256 nextTokenId = tokenId + 1;
1035                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1036                 if (_packedOwnerships[nextTokenId] == 0) {
1037                     // If the next slot is within bounds.
1038                     if (nextTokenId != _currentIndex) {
1039                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1040                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1041                     }
1042                 }
1043             }
1044         }
1045 
1046         emit Transfer(from, to, tokenId);
1047         _afterTokenTransfers(from, to, tokenId, 1);
1048     }
1049 
1050     /**
1051      * @dev Equivalent to `_burn(tokenId, false)`.
1052      */
1053     function _burn(uint256 tokenId) internal virtual {
1054         _burn(tokenId, false);
1055     }
1056 
1057     /**
1058      * @dev Destroys `tokenId`.
1059      * The approval is cleared when the token is burned.
1060      *
1061      * Requirements:
1062      *
1063      * - `tokenId` must exist.
1064      *
1065      * Emits a {Transfer} event.
1066      */
1067     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1068         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1069 
1070         address from = address(uint160(prevOwnershipPacked));
1071 
1072         if (approvalCheck) {
1073             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1074                 isApprovedForAll(from, _msgSenderERC721A()) ||
1075                 getApproved(tokenId) == _msgSenderERC721A());
1076 
1077             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1078         }
1079 
1080         _beforeTokenTransfers(from, address(0), tokenId, 1);
1081 
1082         // Clear approvals from the previous owner.
1083         delete _tokenApprovals[tokenId];
1084 
1085         // Underflow of the sender's balance is impossible because we check for
1086         // ownership above and the recipient's balance can't realistically overflow.
1087         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1088         unchecked {
1089             // Updates:
1090             // - `balance -= 1`.
1091             // - `numberBurned += 1`.
1092             //
1093             // We can directly decrement the balance, and increment the number burned.
1094             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1095             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1096 
1097             // Updates:
1098             // - `address` to the last owner.
1099             // - `startTimestamp` to the timestamp of burning.
1100             // - `burned` to `true`.
1101             // - `nextInitialized` to `true`.
1102             _packedOwnerships[tokenId] =
1103                 _addressToUint256(from) |
1104                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1105                 BITMASK_BURNED |
1106                 BITMASK_NEXT_INITIALIZED;
1107 
1108             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1109             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1110                 uint256 nextTokenId = tokenId + 1;
1111                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1112                 if (_packedOwnerships[nextTokenId] == 0) {
1113                     // If the next slot is within bounds.
1114                     if (nextTokenId != _currentIndex) {
1115                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1116                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1117                     }
1118                 }
1119             }
1120         }
1121 
1122         emit Transfer(from, address(0), tokenId);
1123         _afterTokenTransfers(from, address(0), tokenId, 1);
1124 
1125         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1126         unchecked {
1127             _burnCounter++;
1128         }
1129     }
1130 
1131     /**
1132      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1133      *
1134      * @param from address representing the previous owner of the given token ID
1135      * @param to target address that will receive the tokens
1136      * @param tokenId uint256 ID of the token to be transferred
1137      * @param _data bytes optional data to send along with the call
1138      * @return bool whether the call correctly returned the expected magic value
1139      */
1140     function _checkContractOnERC721Received(
1141         address from,
1142         address to,
1143         uint256 tokenId,
1144         bytes memory _data
1145     ) private returns (bool) {
1146         try
1147             ERC721A__IERC721Receiver(to).onERC721Received(
1148                 _msgSenderERC721A(),
1149                 from,
1150                 tokenId,
1151                 _data
1152             )
1153         returns (bytes4 retval) {
1154             return
1155                 retval ==
1156                 ERC721A__IERC721Receiver(to).onERC721Received.selector;
1157         } catch (bytes memory reason) {
1158             if (reason.length == 0) {
1159                 revert TransferToNonERC721ReceiverImplementer();
1160             } else {
1161                 assembly {
1162                     revert(add(32, reason), mload(reason))
1163                 }
1164             }
1165         }
1166     }
1167 
1168     /**
1169      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1170      * And also called before burning one token.
1171      *
1172      * startTokenId - the first token id to be transferred
1173      * quantity - the amount to be transferred
1174      *
1175      * Calling conditions:
1176      *
1177      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1178      * transferred to `to`.
1179      * - When `from` is zero, `tokenId` will be minted for `to`.
1180      * - When `to` is zero, `tokenId` will be burned by `from`.
1181      * - `from` and `to` are never both zero.
1182      */
1183     function _beforeTokenTransfers(
1184         address from,
1185         address to,
1186         uint256 startTokenId,
1187         uint256 quantity
1188     ) internal virtual {}
1189 
1190     /**
1191      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1192      * minting.
1193      * And also called after one token has been burned.
1194      *
1195      * startTokenId - the first token id to be transferred
1196      * quantity - the amount to be transferred
1197      *
1198      * Calling conditions:
1199      *
1200      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1201      * transferred to `to`.
1202      * - When `from` is zero, `tokenId` has been minted for `to`.
1203      * - When `to` is zero, `tokenId` has been burned by `from`.
1204      * - `from` and `to` are never both zero.
1205      */
1206     function _afterTokenTransfers(
1207         address from,
1208         address to,
1209         uint256 startTokenId,
1210         uint256 quantity
1211     ) internal virtual {}
1212 
1213     /**
1214      * @dev Returns the message sender (defaults to `msg.sender`).
1215      *
1216      * If you are writing GSN compatible contracts, you need to override this function.
1217      */
1218     function _msgSenderERC721A() internal view virtual returns (address) {
1219         return msg.sender;
1220     }
1221 
1222     /**
1223      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1224      */
1225     function _toString(uint256 value)
1226         internal
1227         pure
1228         returns (string memory ptr)
1229     {
1230         assembly {
1231             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1232             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1233             // We will need 1 32-byte word to store the length,
1234             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1235             ptr := add(mload(0x40), 128)
1236             // Update the free memory pointer to allocate.
1237             mstore(0x40, ptr)
1238 
1239             // Cache the end of the memory to calculate the length later.
1240             let end := ptr
1241 
1242             // We write the string from the rightmost digit to the leftmost digit.
1243             // The following is essentially a do-while loop that also handles the zero case.
1244             // Costs a bit more than early returning for the zero case,
1245             // but cheaper in terms of deployment and overall runtime costs.
1246             for {
1247                 // Initialize and perform the first pass without check.
1248                 let temp := value
1249                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1250                 ptr := sub(ptr, 1)
1251                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1252                 mstore8(ptr, add(48, mod(temp, 10)))
1253                 temp := div(temp, 10)
1254             } temp {
1255                 // Keep dividing `temp` until zero.
1256                 temp := div(temp, 10)
1257             } {
1258                 // Body of the for loop.
1259                 ptr := sub(ptr, 1)
1260                 mstore8(ptr, add(48, mod(temp, 10)))
1261             }
1262 
1263             let length := sub(end, ptr)
1264             // Move the pointer 32 bytes leftwards to make room for the length.
1265             ptr := sub(ptr, 32)
1266             // Store the length.
1267             mstore(ptr, length)
1268         }
1269     }
1270 }
1271 // File: contracts/SniperNFT.sol
1272 
1273 
1274 pragma solidity ^0.8.4;
1275 
1276 
1277 
1278 contract SniperNFTBot is ERC721A, Ownable {
1279     uint256 public maxSupply = 3000;
1280     uint256 public maxPerWallet = 20;
1281     uint256 public maxPerTx = 20;
1282     uint256 public _price = 0 ether;
1283 
1284     bool public activated;
1285     string public unrevealedTokenURI = "";
1286     string public baseURI = "https://gateway.pinata.cloud/ipfs/QmS7fb9ucSg5P8qj13eP8aVPduUYebCqQzTN1EMSeVNE85/";
1287 
1288     mapping(uint256 => string) private _tokenURIs;
1289 
1290     address private _ownerWallet = 0x46a4ed210Daf81801C80CF47B63dFF0283B8Ae17;
1291 
1292     constructor(
1293         string memory name,
1294         string memory symbol,
1295         address ownerWallet
1296     ) ERC721A(name, symbol) {
1297         _ownerWallet = ownerWallet;
1298     }
1299 
1300     ////  OVERIDES
1301     function tokenURI(uint256 tokenId)
1302         public
1303         view
1304         override
1305         returns (string memory)
1306     {
1307         require(
1308             _exists(tokenId),
1309             "ERC721Metadata: URI query for nonexistent token"
1310         );
1311         return
1312             bytes(baseURI).length != 0
1313                 ? string(abi.encodePacked(baseURI, _toString(tokenId), ""))
1314                 : unrevealedTokenURI;
1315     }
1316 
1317     function _startTokenId() internal view virtual override returns (uint256) {
1318         return 1;
1319     }
1320 
1321     ////  MINT
1322     function mint(uint256 numberOfTokens) external payable {
1323         require(activated, "Inactive");
1324         require(totalSupply() + numberOfTokens <= maxSupply, "All minted");
1325         require(numberOfTokens <= maxPerTx, "Too many for Tx");
1326         require(
1327             _numberMinted(msg.sender) + numberOfTokens <= maxPerWallet,
1328             "Too many for address"
1329         );
1330         _safeMint(msg.sender, numberOfTokens);
1331     }
1332 
1333     ////  SETTERS
1334     function setTokenURI(string calldata newURI) external onlyOwner {
1335         baseURI = newURI;
1336     }
1337 
1338     function setMaxSupply(uint256 _maxSupply) external onlyOwner {
1339         maxSupply = _maxSupply;
1340     }
1341 
1342     function setIsActive(bool _isActive) external onlyOwner {
1343         activated = _isActive;
1344     }
1345 }