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
26 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
27 
28 pragma solidity ^0.8.0;
29 
30 /**
31  * @dev Contract module which provides a basic access control mechanism, where
32  * there is an account (an owner) that can be granted exclusive access to
33  * specific functions.
34  *
35  * By default, the owner account will be the one that deploys the contract. This
36  * can later be changed with {transferOwnership}.
37  *
38  * This module is used through inheritance. It will make available the modifier
39  * `onlyOwner`, which can be applied to your functions to restrict their use to
40  * the owner.
41  */
42 abstract contract Ownable is Context {
43     address private _owner;
44 
45     event OwnershipTransferred(
46         address indexed previousOwner,
47         address indexed newOwner
48     );
49 
50     /**
51      * @dev Initializes the contract setting the deployer as the initial owner.
52      */
53     constructor() {
54         _transferOwnership(_msgSender());
55     }
56 
57     /**
58      * @dev Returns the address of the current owner.
59      */
60     function owner() public view virtual returns (address) {
61         return _owner;
62     }
63 
64     /**
65      * @dev Throws if called by any account other than the owner.
66      */
67     modifier onlyOwner() {
68         require(owner() == _msgSender(), "Ownable: caller is not the owner");
69         _;
70     }
71 
72     /**
73      * @dev Leaves the contract without owner. It will not be possible to call
74      * `onlyOwner` functions anymore. Can only be called by the current owner.
75      *
76      * NOTE: Renouncing ownership will leave the contract without an owner,
77      * thereby removing any functionality that is only available to the owner.
78      */
79     function renounceOwnership() public virtual onlyOwner {
80         _transferOwnership(address(0));
81     }
82 
83     /**
84      * @dev Transfers ownership of the contract to a new account (`newOwner`).
85      * Can only be called by the current owner.
86      */
87     function transferOwnership(address newOwner) public virtual onlyOwner {
88         require(
89             newOwner != address(0),
90             "Ownable: new owner is the zero address"
91         );
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
217     event Transfer(
218         address indexed from,
219         address indexed to,
220         uint256 indexed tokenId
221     );
222 
223     /**
224      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
225      */
226     event Approval(
227         address indexed owner,
228         address indexed approved,
229         uint256 indexed tokenId
230     );
231 
232     /**
233      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
234      */
235     event ApprovalForAll(
236         address indexed owner,
237         address indexed operator,
238         bool approved
239     );
240 
241     /**
242      * @dev Returns the number of tokens in ``owner``'s account.
243      */
244     function balanceOf(address owner) external view returns (uint256 balance);
245 
246     /**
247      * @dev Returns the owner of the `tokenId` token.
248      *
249      * Requirements:
250      *
251      * - `tokenId` must exist.
252      */
253     function ownerOf(uint256 tokenId) external view returns (address owner);
254 
255     /**
256      * @dev Safely transfers `tokenId` token from `from` to `to`.
257      *
258      * Requirements:
259      *
260      * - `from` cannot be the zero address.
261      * - `to` cannot be the zero address.
262      * - `tokenId` token must exist and be owned by `from`.
263      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
264      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
265      *
266      * Emits a {Transfer} event.
267      */
268     function safeTransferFrom(
269         address from,
270         address to,
271         uint256 tokenId,
272         bytes calldata data
273     ) external;
274 
275     /**
276      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
277      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
278      *
279      * Requirements:
280      *
281      * - `from` cannot be the zero address.
282      * - `to` cannot be the zero address.
283      * - `tokenId` token must exist and be owned by `from`.
284      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
285      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
286      *
287      * Emits a {Transfer} event.
288      */
289     function safeTransferFrom(
290         address from,
291         address to,
292         uint256 tokenId
293     ) external;
294 
295     /**
296      * @dev Transfers `tokenId` token from `from` to `to`.
297      *
298      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
299      *
300      * Requirements:
301      *
302      * - `from` cannot be the zero address.
303      * - `to` cannot be the zero address.
304      * - `tokenId` token must be owned by `from`.
305      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
306      *
307      * Emits a {Transfer} event.
308      */
309     function transferFrom(
310         address from,
311         address to,
312         uint256 tokenId
313     ) external;
314 
315     /**
316      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
317      * The approval is cleared when the token is transferred.
318      *
319      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
320      *
321      * Requirements:
322      *
323      * - The caller must own the token or be an approved operator.
324      * - `tokenId` must exist.
325      *
326      * Emits an {Approval} event.
327      */
328     function approve(address to, uint256 tokenId) external;
329 
330     /**
331      * @dev Approve or remove `operator` as an operator for the caller.
332      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
333      *
334      * Requirements:
335      *
336      * - The `operator` cannot be the caller.
337      *
338      * Emits an {ApprovalForAll} event.
339      */
340     function setApprovalForAll(address operator, bool _approved) external;
341 
342     /**
343      * @dev Returns the account approved for `tokenId` token.
344      *
345      * Requirements:
346      *
347      * - `tokenId` must exist.
348      */
349     function getApproved(uint256 tokenId)
350         external
351         view
352         returns (address operator);
353 
354     /**
355      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
356      *
357      * See {setApprovalForAll}
358      */
359     function isApprovedForAll(address owner, address operator)
360         external
361         view
362         returns (bool);
363 
364     // ==============================
365     //        IERC721Metadata
366     // ==============================
367 
368     /**
369      * @dev Returns the token collection name.
370      */
371     function name() external view returns (string memory);
372 
373     /**
374      * @dev Returns the token collection symbol.
375      */
376     function symbol() external view returns (string memory);
377 
378     /**
379      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
380      */
381     function tokenURI(uint256 tokenId) external view returns (string memory);
382 }
383 
384 // ERC721A Contracts v4.0.0
385 // Creator: Chiru Labs
386 
387 pragma solidity ^0.8.4;
388 
389 /**
390  * @dev ERC721 token receiver interface.
391  */
392 interface ERC721A__IERC721Receiver {
393     function onERC721Received(
394         address operator,
395         address from,
396         uint256 tokenId,
397         bytes calldata data
398     ) external returns (bytes4);
399 }
400 
401 /**
402  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
403  * the Metadata extension. Built to optimize for lower gas during batch mints.
404  *
405  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
406  *
407  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
408  *
409  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
410  */
411 contract ERC721A is IERC721A {
412     // Mask of an entry in packed address data.
413     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
414 
415     // The bit position of `numberMinted` in packed address data.
416     uint256 private constant BITPOS_NUMBER_MINTED = 64;
417 
418     // The bit position of `numberBurned` in packed address data.
419     uint256 private constant BITPOS_NUMBER_BURNED = 128;
420 
421     // The bit position of `aux` in packed address data.
422     uint256 private constant BITPOS_AUX = 192;
423 
424     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
425     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
426 
427     // The bit position of `startTimestamp` in packed ownership.
428     uint256 private constant BITPOS_START_TIMESTAMP = 160;
429 
430     // The bit mask of the `burned` bit in packed ownership.
431     uint256 private constant BITMASK_BURNED = 1 << 224;
432 
433     // The bit position of the `nextInitialized` bit in packed ownership.
434     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
435 
436     // The bit mask of the `nextInitialized` bit in packed ownership.
437     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
438 
439     // The tokenId of the next token to be minted.
440     uint256 private _currentIndex;
441 
442     // The number of tokens burned.
443     uint256 private _burnCounter;
444 
445     // Token name
446     string private _name;
447 
448     // Token symbol
449     string private _symbol;
450 
451     // Mapping from token ID to ownership details
452     // An empty struct value does not necessarily mean the token is unowned.
453     // See `_packedOwnershipOf` implementation for details.
454     //
455     // Bits Layout:
456     // - [0..159]   `addr`
457     // - [160..223] `startTimestamp`
458     // - [224]      `burned`
459     // - [225]      `nextInitialized`
460     mapping(uint256 => uint256) private _packedOwnerships;
461 
462     // Mapping owner address to address data.
463     //
464     // Bits Layout:
465     // - [0..63]    `balance`
466     // - [64..127]  `numberMinted`
467     // - [128..191] `numberBurned`
468     // - [192..255] `aux`
469     mapping(address => uint256) private _packedAddressData;
470 
471     // Mapping from token ID to approved address.
472     mapping(uint256 => address) private _tokenApprovals;
473 
474     // Mapping from owner to operator approvals
475     mapping(address => mapping(address => bool)) private _operatorApprovals;
476 
477     constructor(string memory name_, string memory symbol_) {
478         _name = name_;
479         _symbol = symbol_;
480         _currentIndex = _startTokenId();
481     }
482 
483     /**
484      * @dev Returns the starting token ID.
485      * To change the starting token ID, please override this function.
486      */
487     function _startTokenId() internal view virtual returns (uint256) {
488         return 0;
489     }
490 
491     /**
492      * @dev Returns the next token ID to be minted.
493      */
494     function _nextTokenId() internal view returns (uint256) {
495         return _currentIndex;
496     }
497 
498     /**
499      * @dev Returns the total number of tokens in existence.
500      * Burned tokens will reduce the count.
501      * To get the total number of tokens minted, please see `_totalMinted`.
502      */
503     function totalSupply() public view override returns (uint256) {
504         // Counter underflow is impossible as _burnCounter cannot be incremented
505         // more than `_currentIndex - _startTokenId()` times.
506         unchecked {
507             return _currentIndex - _burnCounter - _startTokenId();
508         }
509     }
510 
511     /**
512      * @dev Returns the total amount of tokens minted in the contract.
513      */
514     function _totalMinted() internal view returns (uint256) {
515         // Counter underflow is impossible as _currentIndex does not decrement,
516         // and it is initialized to `_startTokenId()`
517         unchecked {
518             return _currentIndex - _startTokenId();
519         }
520     }
521 
522     /**
523      * @dev Returns the total number of tokens burned.
524      */
525     function _totalBurned() internal view returns (uint256) {
526         return _burnCounter;
527     }
528 
529     /**
530      * @dev See {IERC165-supportsInterface}.
531      */
532     function supportsInterface(bytes4 interfaceId)
533         public
534         view
535         virtual
536         override
537         returns (bool)
538     {
539         // The interface IDs are constants representing the first 4 bytes of the XOR of
540         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
541         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
542         return
543             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
544             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
545             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
546     }
547 
548     /**
549      * @dev See {IERC721-balanceOf}.
550      */
551     function balanceOf(address owner) public view override returns (uint256) {
552         if (owner == address(0)) revert BalanceQueryForZeroAddress();
553         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
554     }
555 
556     /**
557      * Returns the number of tokens minted by `owner`.
558      */
559     function _numberMinted(address owner) internal view returns (uint256) {
560         return
561             (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) &
562             BITMASK_ADDRESS_DATA_ENTRY;
563     }
564 
565     /**
566      * Returns the number of tokens burned by or on behalf of `owner`.
567      */
568     function _numberBurned(address owner) internal view returns (uint256) {
569         return
570             (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) &
571             BITMASK_ADDRESS_DATA_ENTRY;
572     }
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
588         assembly {
589             // Cast aux without masking.
590             auxCasted := aux
591         }
592         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
593         _packedAddressData[owner] = packed;
594     }
595 
596     /**
597      * Returns the packed ownership data of `tokenId`.
598      */
599     function _packedOwnershipOf(uint256 tokenId)
600         private
601         view
602         returns (uint256)
603     {
604         uint256 curr = tokenId;
605 
606         unchecked {
607             if (_startTokenId() <= curr)
608                 if (curr < _currentIndex) {
609                     uint256 packed = _packedOwnerships[curr];
610                     // If not burned.
611                     if (packed & BITMASK_BURNED == 0) {
612                         // Invariant:
613                         // There will always be an ownership that has an address and is not burned
614                         // before an ownership that does not have an address and is not burned.
615                         // Hence, curr will not underflow.
616                         //
617                         // We can directly compare the packed value.
618                         // If the address is zero, packed is zero.
619                         while (packed == 0) {
620                             packed = _packedOwnerships[--curr];
621                         }
622                         return packed;
623                     }
624                 }
625         }
626         revert OwnerQueryForNonexistentToken();
627     }
628 
629     /**
630      * Returns the unpacked `TokenOwnership` struct from `packed`.
631      */
632     function _unpackedOwnership(uint256 packed)
633         private
634         pure
635         returns (TokenOwnership memory ownership)
636     {
637         ownership.addr = address(uint160(packed));
638         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
639         ownership.burned = packed & BITMASK_BURNED != 0;
640     }
641 
642     /**
643      * Returns the unpacked `TokenOwnership` struct at `index`.
644      */
645     function _ownershipAt(uint256 index)
646         internal
647         view
648         returns (TokenOwnership memory)
649     {
650         return _unpackedOwnership(_packedOwnerships[index]);
651     }
652 
653     /**
654      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
655      */
656     function _initializeOwnershipAt(uint256 index) internal {
657         if (_packedOwnerships[index] == 0) {
658             _packedOwnerships[index] = _packedOwnershipOf(index);
659         }
660     }
661 
662     /**
663      * Gas spent here starts off proportional to the maximum mint batch size.
664      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
665      */
666     function _ownershipOf(uint256 tokenId)
667         internal
668         view
669         returns (TokenOwnership memory)
670     {
671         return _unpackedOwnership(_packedOwnershipOf(tokenId));
672     }
673 
674     /**
675      * @dev See {IERC721-ownerOf}.
676      */
677     function ownerOf(uint256 tokenId) public view override returns (address) {
678         return address(uint160(_packedOwnershipOf(tokenId)));
679     }
680 
681     /**
682      * @dev See {IERC721Metadata-name}.
683      */
684     function name() public view virtual override returns (string memory) {
685         return _name;
686     }
687 
688     /**
689      * @dev See {IERC721Metadata-symbol}.
690      */
691     function symbol() public view virtual override returns (string memory) {
692         return _symbol;
693     }
694 
695     /**
696      * @dev See {IERC721Metadata-tokenURI}.
697      */
698     function tokenURI(uint256 tokenId)
699         public
700         view
701         virtual
702         override
703         returns (string memory)
704     {
705         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
706 
707         string memory baseURI = _baseURI();
708         return
709             bytes(baseURI).length != 0
710                 ? string(abi.encodePacked(baseURI, _toString(tokenId)))
711                 : "";
712     }
713 
714     /**
715      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
716      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
717      * by default, can be overriden in child contracts.
718      */
719     function _baseURI() internal view virtual returns (string memory) {
720         return "";
721     }
722 
723     /**
724      * @dev Casts the address to uint256 without masking.
725      */
726     function _addressToUint256(address value)
727         private
728         pure
729         returns (uint256 result)
730     {
731         assembly {
732             result := value
733         }
734     }
735 
736     /**
737      * @dev Casts the boolean to uint256 without branching.
738      */
739     function _boolToUint256(bool value) private pure returns (uint256 result) {
740         assembly {
741             result := value
742         }
743     }
744 
745     /**
746      * @dev See {IERC721-approve}.
747      */
748     function approve(address to, uint256 tokenId) public override {
749         address owner = address(uint160(_packedOwnershipOf(tokenId)));
750         if (to == owner) revert ApprovalToCurrentOwner();
751 
752         if (_msgSenderERC721A() != owner)
753             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
754                 revert ApprovalCallerNotOwnerNorApproved();
755             }
756 
757         _tokenApprovals[tokenId] = to;
758         emit Approval(owner, to, tokenId);
759     }
760 
761     /**
762      * @dev See {IERC721-getApproved}.
763      */
764     function getApproved(uint256 tokenId)
765         public
766         view
767         override
768         returns (address)
769     {
770         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
771 
772         return _tokenApprovals[tokenId];
773     }
774 
775     /**
776      * @dev See {IERC721-setApprovalForAll}.
777      */
778     function setApprovalForAll(address operator, bool approved)
779         public
780         virtual
781         override
782     {
783         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
784 
785         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
786         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
787     }
788 
789     /**
790      * @dev See {IERC721-isApprovedForAll}.
791      */
792     function isApprovedForAll(address owner, address operator)
793         public
794         view
795         virtual
796         override
797         returns (bool)
798     {
799         return _operatorApprovals[owner][operator];
800     }
801 
802     /**
803      * @dev See {IERC721-transferFrom}.
804      */
805     function transferFrom(
806         address from,
807         address to,
808         uint256 tokenId
809     ) public virtual override {
810         _transfer(from, to, tokenId);
811     }
812 
813     /**
814      * @dev See {IERC721-safeTransferFrom}.
815      */
816     function safeTransferFrom(
817         address from,
818         address to,
819         uint256 tokenId
820     ) public virtual override {
821         safeTransferFrom(from, to, tokenId, "");
822     }
823 
824     /**
825      * @dev See {IERC721-safeTransferFrom}.
826      */
827     function safeTransferFrom(
828         address from,
829         address to,
830         uint256 tokenId,
831         bytes memory _data
832     ) public virtual override {
833         _transfer(from, to, tokenId);
834         if (to.code.length != 0)
835             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
836                 revert TransferToNonERC721ReceiverImplementer();
837             }
838     }
839 
840     /**
841      * @dev Returns whether `tokenId` exists.
842      *
843      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
844      *
845      * Tokens start existing when they are minted (`_mint`),
846      */
847     function _exists(uint256 tokenId) internal view returns (bool) {
848         return
849             _startTokenId() <= tokenId &&
850             tokenId < _currentIndex && // If within bounds,
851             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
852     }
853 
854     /**
855      * @dev Equivalent to `_safeMint(to, quantity, '')`.
856      */
857     function _safeMint(address to, uint256 quantity) internal {
858         _safeMint(to, quantity, "");
859     }
860 
861     /**
862      * @dev Safely mints `quantity` tokens and transfers them to `to`.
863      *
864      * Requirements:
865      *
866      * - If `to` refers to a smart contract, it must implement
867      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
868      * - `quantity` must be greater than 0.
869      *
870      * Emits a {Transfer} event.
871      */
872     function _safeMint(
873         address to,
874         uint256 quantity,
875         bytes memory _data
876     ) internal {
877         uint256 startTokenId = _currentIndex;
878         if (to == address(0)) revert MintToZeroAddress();
879         if (quantity == 0) revert MintZeroQuantity();
880 
881         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
882 
883         // Overflows are incredibly unrealistic.
884         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
885         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
886         unchecked {
887             // Updates:
888             // - `balance += quantity`.
889             // - `numberMinted += quantity`.
890             //
891             // We can directly add to the balance and number minted.
892             _packedAddressData[to] +=
893                 quantity *
894                 ((1 << BITPOS_NUMBER_MINTED) | 1);
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
909             if (to.code.length != 0) {
910                 do {
911                     emit Transfer(address(0), to, updatedIndex);
912                     if (
913                         !_checkContractOnERC721Received(
914                             address(0),
915                             to,
916                             updatedIndex++,
917                             _data
918                         )
919                     ) {
920                         revert TransferToNonERC721ReceiverImplementer();
921                     }
922                 } while (updatedIndex < end);
923                 // Reentrancy protection
924                 if (_currentIndex != startTokenId) revert();
925             } else {
926                 do {
927                     emit Transfer(address(0), to, updatedIndex++);
928                 } while (updatedIndex < end);
929             }
930             _currentIndex = updatedIndex;
931         }
932         _afterTokenTransfers(address(0), to, startTokenId, quantity);
933     }
934 
935     /**
936      * @dev Mints `quantity` tokens and transfers them to `to`.
937      *
938      * Requirements:
939      *
940      * - `to` cannot be the zero address.
941      * - `quantity` must be greater than 0.
942      *
943      * Emits a {Transfer} event.
944      */
945     function _mint(address to, uint256 quantity) internal {
946         uint256 startTokenId = _currentIndex;
947         if (to == address(0)) revert MintToZeroAddress();
948         if (quantity == 0) revert MintZeroQuantity();
949 
950         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
951 
952         // Overflows are incredibly unrealistic.
953         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
954         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
955         unchecked {
956             // Updates:
957             // - `balance += quantity`.
958             // - `numberMinted += quantity`.
959             //
960             // We can directly add to the balance and number minted.
961             _packedAddressData[to] +=
962                 quantity *
963                 ((1 << BITPOS_NUMBER_MINTED) | 1);
964 
965             // Updates:
966             // - `address` to the owner.
967             // - `startTimestamp` to the timestamp of minting.
968             // - `burned` to `false`.
969             // - `nextInitialized` to `quantity == 1`.
970             _packedOwnerships[startTokenId] =
971                 _addressToUint256(to) |
972                 (block.timestamp << BITPOS_START_TIMESTAMP) |
973                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
974 
975             uint256 updatedIndex = startTokenId;
976             uint256 end = updatedIndex + quantity;
977 
978             do {
979                 emit Transfer(address(0), to, updatedIndex++);
980             } while (updatedIndex < end);
981 
982             _currentIndex = updatedIndex;
983         }
984         _afterTokenTransfers(address(0), to, startTokenId, quantity);
985     }
986 
987     /**
988      * @dev Transfers `tokenId` from `from` to `to`.
989      *
990      * Requirements:
991      *
992      * - `to` cannot be the zero address.
993      * - `tokenId` token must be owned by `from`.
994      *
995      * Emits a {Transfer} event.
996      */
997     function _transfer(
998         address from,
999         address to,
1000         uint256 tokenId
1001     ) private {
1002         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1003 
1004         if (address(uint160(prevOwnershipPacked)) != from)
1005             revert TransferFromIncorrectOwner();
1006 
1007         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1008             isApprovedForAll(from, _msgSenderERC721A()) ||
1009             getApproved(tokenId) == _msgSenderERC721A());
1010 
1011         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1012         if (to == address(0)) revert TransferToZeroAddress();
1013 
1014         _beforeTokenTransfers(from, to, tokenId, 1);
1015 
1016         // Clear approvals from the previous owner.
1017         delete _tokenApprovals[tokenId];
1018 
1019         // Underflow of the sender's balance is impossible because we check for
1020         // ownership above and the recipient's balance can't realistically overflow.
1021         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1022         unchecked {
1023             // We can directly increment and decrement the balances.
1024             --_packedAddressData[from]; // Updates: `balance -= 1`.
1025             ++_packedAddressData[to]; // Updates: `balance += 1`.
1026 
1027             // Updates:
1028             // - `address` to the next owner.
1029             // - `startTimestamp` to the timestamp of transfering.
1030             // - `burned` to `false`.
1031             // - `nextInitialized` to `true`.
1032             _packedOwnerships[tokenId] =
1033                 _addressToUint256(to) |
1034                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1035                 BITMASK_NEXT_INITIALIZED;
1036 
1037             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1038             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1039                 uint256 nextTokenId = tokenId + 1;
1040                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1041                 if (_packedOwnerships[nextTokenId] == 0) {
1042                     // If the next slot is within bounds.
1043                     if (nextTokenId != _currentIndex) {
1044                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1045                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1046                     }
1047                 }
1048             }
1049         }
1050 
1051         emit Transfer(from, to, tokenId);
1052         _afterTokenTransfers(from, to, tokenId, 1);
1053     }
1054 
1055     /**
1056      * @dev Equivalent to `_burn(tokenId, false)`.
1057      */
1058     function _burn(uint256 tokenId) internal virtual {
1059         _burn(tokenId, false);
1060     }
1061 
1062     /**
1063      * @dev Destroys `tokenId`.
1064      * The approval is cleared when the token is burned.
1065      *
1066      * Requirements:
1067      *
1068      * - `tokenId` must exist.
1069      *
1070      * Emits a {Transfer} event.
1071      */
1072     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1073         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1074 
1075         address from = address(uint160(prevOwnershipPacked));
1076 
1077         if (approvalCheck) {
1078             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1079                 isApprovedForAll(from, _msgSenderERC721A()) ||
1080                 getApproved(tokenId) == _msgSenderERC721A());
1081 
1082             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1083         }
1084 
1085         _beforeTokenTransfers(from, address(0), tokenId, 1);
1086 
1087         // Clear approvals from the previous owner.
1088         delete _tokenApprovals[tokenId];
1089 
1090         // Underflow of the sender's balance is impossible because we check for
1091         // ownership above and the recipient's balance can't realistically overflow.
1092         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1093         unchecked {
1094             // Updates:
1095             // - `balance -= 1`.
1096             // - `numberBurned += 1`.
1097             //
1098             // We can directly decrement the balance, and increment the number burned.
1099             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1100             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1101 
1102             // Updates:
1103             // - `address` to the last owner.
1104             // - `startTimestamp` to the timestamp of burning.
1105             // - `burned` to `true`.
1106             // - `nextInitialized` to `true`.
1107             _packedOwnerships[tokenId] =
1108                 _addressToUint256(from) |
1109                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1110                 BITMASK_BURNED |
1111                 BITMASK_NEXT_INITIALIZED;
1112 
1113             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1114             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1115                 uint256 nextTokenId = tokenId + 1;
1116                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1117                 if (_packedOwnerships[nextTokenId] == 0) {
1118                     // If the next slot is within bounds.
1119                     if (nextTokenId != _currentIndex) {
1120                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1121                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1122                     }
1123                 }
1124             }
1125         }
1126 
1127         emit Transfer(from, address(0), tokenId);
1128         _afterTokenTransfers(from, address(0), tokenId, 1);
1129 
1130         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1131         unchecked {
1132             _burnCounter++;
1133         }
1134     }
1135 
1136     /**
1137      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1138      *
1139      * @param from address representing the previous owner of the given token ID
1140      * @param to target address that will receive the tokens
1141      * @param tokenId uint256 ID of the token to be transferred
1142      * @param _data bytes optional data to send along with the call
1143      * @return bool whether the call correctly returned the expected magic value
1144      */
1145     function _checkContractOnERC721Received(
1146         address from,
1147         address to,
1148         uint256 tokenId,
1149         bytes memory _data
1150     ) private returns (bool) {
1151         try
1152             ERC721A__IERC721Receiver(to).onERC721Received(
1153                 _msgSenderERC721A(),
1154                 from,
1155                 tokenId,
1156                 _data
1157             )
1158         returns (bytes4 retval) {
1159             return
1160                 retval ==
1161                 ERC721A__IERC721Receiver(to).onERC721Received.selector;
1162         } catch (bytes memory reason) {
1163             if (reason.length == 0) {
1164                 revert TransferToNonERC721ReceiverImplementer();
1165             } else {
1166                 assembly {
1167                     revert(add(32, reason), mload(reason))
1168                 }
1169             }
1170         }
1171     }
1172 
1173     /**
1174      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1175      * And also called before burning one token.
1176      *
1177      * startTokenId - the first token id to be transferred
1178      * quantity - the amount to be transferred
1179      *
1180      * Calling conditions:
1181      *
1182      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1183      * transferred to `to`.
1184      * - When `from` is zero, `tokenId` will be minted for `to`.
1185      * - When `to` is zero, `tokenId` will be burned by `from`.
1186      * - `from` and `to` are never both zero.
1187      */
1188     function _beforeTokenTransfers(
1189         address from,
1190         address to,
1191         uint256 startTokenId,
1192         uint256 quantity
1193     ) internal virtual {}
1194 
1195     /**
1196      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1197      * minting.
1198      * And also called after one token has been burned.
1199      *
1200      * startTokenId - the first token id to be transferred
1201      * quantity - the amount to be transferred
1202      *
1203      * Calling conditions:
1204      *
1205      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1206      * transferred to `to`.
1207      * - When `from` is zero, `tokenId` has been minted for `to`.
1208      * - When `to` is zero, `tokenId` has been burned by `from`.
1209      * - `from` and `to` are never both zero.
1210      */
1211     function _afterTokenTransfers(
1212         address from,
1213         address to,
1214         uint256 startTokenId,
1215         uint256 quantity
1216     ) internal virtual {}
1217 
1218     /**
1219      * @dev Returns the message sender (defaults to `msg.sender`).
1220      *
1221      * If you are writing GSN compatible contracts, you need to override this function.
1222      */
1223     function _msgSenderERC721A() internal view virtual returns (address) {
1224         return msg.sender;
1225     }
1226 
1227     /**
1228      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1229      */
1230     function _toString(uint256 value)
1231         internal
1232         pure
1233         returns (string memory ptr)
1234     {
1235         assembly {
1236             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1237             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1238             // We will need 1 32-byte word to store the length,
1239             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1240             ptr := add(mload(0x40), 128)
1241             // Update the free memory pointer to allocate.
1242             mstore(0x40, ptr)
1243 
1244             // Cache the end of the memory to calculate the length later.
1245             let end := ptr
1246 
1247             // We write the string from the rightmost digit to the leftmost digit.
1248             // The following is essentially a do-while loop that also handles the zero case.
1249             // Costs a bit more than early returning for the zero case,
1250             // but cheaper in terms of deployment and overall runtime costs.
1251             for {
1252                 // Initialize and perform the first pass without check.
1253                 let temp := value
1254                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1255                 ptr := sub(ptr, 1)
1256                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1257                 mstore8(ptr, add(48, mod(temp, 10)))
1258                 temp := div(temp, 10)
1259             } temp {
1260                 // Keep dividing `temp` until zero.
1261                 temp := div(temp, 10)
1262             } {
1263                 // Body of the for loop.
1264                 ptr := sub(ptr, 1)
1265                 mstore8(ptr, add(48, mod(temp, 10)))
1266             }
1267 
1268             let length := sub(end, ptr)
1269             // Move the pointer 32 bytes leftwards to make room for the length.
1270             ptr := sub(ptr, 32)
1271             // Store the length.
1272             mstore(ptr, length)
1273         }
1274     }
1275 }
1276 
1277 pragma solidity ^0.8.4;
1278 
1279 contract OwnableDelegateProxy {}
1280 
1281 contract ProxyRegistry {
1282     mapping(address => OwnableDelegateProxy) public proxies;
1283 }
1284 
1285 contract Brute721APRTS is ERC721A, Ownable {
1286     string private baseURI = "https://brute-meta.herokuapp.com/nft/";
1287     string public contractURI = "https://brute-meta.herokuapp.com/meta";
1288     //Brute IMPL
1289     uint256 public maxSupply = 6666 + 1; // 1 extra to avoid equality checks and save gas on mint
1290     uint256 public mintCost = 25 * 10**15; //0.025 ETH / 25 Finney | 1 ETH = 1 * 10**18
1291     uint256 public maxMint = 6 + 1; //1 extra to avoid equality checks and save gas on mint
1292     string public provenance;
1293     //Giveaway IMPL
1294     mapping(address => bool) public giveawayClaimed;
1295     uint256 public giveawayCount = 666;
1296     uint256 public giveawaysDone;
1297     //Sale Control IMPL - TS
1298     uint256 public publicSaleStart = 1654365600; //Sat Jun 04 2022 18:00:00 GMT+0000
1299 
1300     function saleActive() public view returns (bool) {
1301         if (block.timestamp > publicSaleStart) {
1302             return true;
1303         } else {
1304             return false;
1305         }
1306     }
1307 
1308     //Opensea Proxy Registry
1309     address proxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1; //OpenSea Mainnet Proxy
1310 
1311     constructor() ERC721A("Brut(e)", "(e)") {
1312         _safeMint(msg.sender, 1);
1313     }
1314 
1315     // Token URI Setup
1316     function tokenURI(uint256 tokenId)
1317         public
1318         view
1319         virtual
1320         override
1321         returns (string memory)
1322     {
1323         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1324         return string(abi.encodePacked(baseURI, _toString(tokenId)));
1325     }
1326 
1327     function setBaseURI(string calldata _baseURI) external onlyOwner {
1328         baseURI = _baseURI;
1329     }
1330 
1331     function exists(uint256 tokenId) public view returns (bool) {
1332         return _exists(tokenId);
1333     }
1334 
1335     // Contract URI
1336     function setContractURI(string calldata _contractURI) external onlyOwner {
1337         contractURI = _contractURI;
1338     }
1339 
1340     // Brute IMPL Setup
1341     function setProvenance(string calldata _provenance) external onlyOwner {
1342         provenance = _provenance;
1343     }
1344 
1345     function withdraw() public onlyOwner {
1346         uint256 balance = address(this).balance;
1347         payable(msg.sender).transfer(balance);
1348     }
1349 
1350     // Minting
1351     function freeMint() external payable {
1352         require(block.timestamp > publicSaleStart, "Sale not active");
1353         require(giveawaysDone < giveawayCount, "All giveaways were claimed");
1354         require(!giveawayClaimed[msg.sender], "Giveaway already claimed");
1355         require(totalSupply() + 1 < maxSupply, "Mint would exceed max supply");
1356         giveawayClaimed[msg.sender] = true;
1357         giveawaysDone++;
1358         _safeMint(msg.sender, 1);
1359     }
1360 
1361     function publicMint(uint256 quantity) external payable {
1362         require(block.timestamp > publicSaleStart, "Sale not active");
1363         require(
1364             msg.value == quantity * mintCost,
1365             "Ether sent doesn't match minting price"
1366         );
1367         require(quantity < maxMint, "Quantity exceeds maximum allowed");
1368         require(
1369             totalSupply() + quantity < maxSupply,
1370             "Mint would exceed max supply"
1371         );
1372         _safeMint(msg.sender, quantity);
1373     }
1374 
1375     //Opensea Proxy
1376     function isApprovedForAll(address owner, address operator)
1377         public
1378         view
1379         override
1380         returns (bool)
1381     {
1382         // Whitelist OpenSea proxy contract for easy trading.
1383         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1384         if (address(proxyRegistry.proxies(owner)) == operator) {
1385             return true;
1386         }
1387 
1388         return super.isApprovedForAll(owner, operator);
1389     }
1390 }