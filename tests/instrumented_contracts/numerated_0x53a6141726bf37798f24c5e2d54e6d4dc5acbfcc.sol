1 /*                                                                                     
2 
3  ______   ______   ______    ______   ______   ______   __       ______   ______      
4 /_____/\ /_____/\ /_____/\  /_____/\ /_____/\ /_____/\ /_/\     /_____/\ /_____/\     
5 \:::__\/ \:::_ \ \\:::_ \ \ \:::_ \ \\:::_ \ \\:::_ \ \\:\ \    \::::_\/_\::::_\/_    
6  \:\ \  __\:\ \ \ \\:(_) ) )_\:\ \ \ \\:\ \ \ \\:\ \ \ \\:\ \    \:\/___/\\:\/___/\   
7   \:\ \/_/\\:\ \ \ \\: __ `\ \\:\ \ \ \\:\ \ \ \\:\ \ \ \\:\ \____\::___\/_\_::._\:\  
8    \:\_\ \ \\:\_\ \ \\ \ `\ \ \\:\_\ \ \\:\_\ \ \\:\/.:| |\:\/___/\\:\____/\ /____\:\ 
9     \_____\/ \_____\/ \_\/ \_\/ \_____\/ \_____\/ \____/_/ \_____\/ \_____\/ \_____\/ 
10 
11 */
12 
13 
14 pragma solidity ^0.8.0;
15 
16 /**
17  * @dev Provides information about the current execution context, including the
18  * sender of the transaction and its data. While these are generally available
19  * via msg.sender and msg.data, they should not be accessed in such a direct
20  * manner, since when dealing with meta-transactions the account sending and
21  * paying for execution may not be the actual sender (as far as an application
22  * is concerned).
23  *
24  * This contract is only required for intermediate, library-like contracts.
25  */
26 abstract contract Context {
27     function _msgSender() internal view virtual returns (address) {
28         return msg.sender;
29     }
30 
31     function _msgData() internal view virtual returns (bytes calldata) {
32         return msg.data;
33     }
34 }
35 
36 
37 pragma solidity ^0.8.0;
38 
39 
40 /**
41  * @dev Contract module which provides a basic access control mechanism, where
42  * there is an account (an owner) that can be granted exclusive access to
43  * specific functions.
44  *
45  * By default, the owner account will be the one that deploys the contract. This
46  * can later be changed with {transferOwnership}.
47  *
48  * This module is used through inheritance. It will make available the modifier
49  * `onlyOwner`, which can be applied to your functions to restrict their use to
50  * the owner.
51  */
52 abstract contract Ownable is Context {
53     address private _owner;
54 
55     event OwnershipTransferred(
56         address indexed previousOwner,
57         address indexed newOwner
58     );
59 
60     /**
61      * @dev Initializes the contract setting the deployer as the initial owner.
62      */
63     constructor() {
64         _transferOwnership(_msgSender());
65     }
66 
67     /**
68      * @dev Returns the address of the current owner.
69      */
70     function owner() public view virtual returns (address) {
71         return _owner;
72     }
73 
74     /**
75      * @dev Throws if called by any account other than the owner.
76      */
77     modifier onlyOwner() {
78         require(owner() == _msgSender(), "Ownable: caller is not the owner");
79         _;
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
98         require(
99             newOwner != address(0),
100             "Ownable: new owner is the zero address"
101         );
102         _transferOwnership(newOwner);
103     }
104 
105     /**
106      * @dev Transfers ownership of the contract to a new account (`newOwner`).
107      * Internal function without access restriction.
108      */
109     function _transferOwnership(address newOwner) internal virtual {
110         address oldOwner = _owner;
111         _owner = newOwner;
112         emit OwnershipTransferred(oldOwner, newOwner);
113     }
114 }
115 
116 
117 // SPDX-License-Identifier: MIT
118 // ERC721E Contracts v0.1.0
119 // Creator: Coroodles Dev
120 
121 pragma solidity ^0.8.4;
122 
123 /**
124  * @dev Interface of an ERC721E compliant contract.
125  */
126 interface IERC721E {
127     /**
128      * The caller must own the token or be an approved operator.
129      */
130     error ApprovalCallerNotOwnerNorApproved();
131 
132     /**
133      * The token does not exist.
134      */
135     error ApprovalQueryForNonexistentToken();
136 
137     /**
138      * The caller cannot approve to their own address.
139      */
140     error ApproveToCaller();
141 
142     /**
143      * Cannot query the balance for the zero address.
144      */
145     error BalanceQueryForZeroAddress();
146 
147     /**
148      * Cannot mint to the zero address.
149      */
150     error MintToZeroAddress();
151 
152     /**
153      * The quantity of tokens minted must be more than zero.
154      */
155     error MintZeroQuantity();
156 
157     /**
158      * The token does not exist.
159      */
160     error OwnerQueryForNonexistentToken();
161 
162     /**
163      * The caller must own the token or be an approved operator.
164      */
165     error TransferCallerNotOwnerNorApproved();
166 
167     /**
168      * The token must be owned by `from`.
169      */
170     error TransferFromIncorrectOwner();
171 
172     /**
173      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
174      */
175     error TransferToNonERC721ReceiverImplementer();
176 
177     /**
178      * Cannot transfer to the zero address.
179      */
180     error TransferToZeroAddress();
181 
182     /**
183      * The token does not exist.
184      */
185     error URIQueryForNonexistentToken();
186 
187     /**
188      * Not have withdrawable amount.
189      */
190     error NoWithdrawableAmount();
191 
192     struct TokenOwnership {
193         // The address of the owner.
194         address addr;
195         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
196         uint64 startTimestamp;
197         // Whether the token has been burned.
198         bool burned;
199     }
200 
201     /**
202      * @dev Returns the total amount of tokens stored by the contract.
203      *
204      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
205      */
206     function totalSupply() external view returns (uint256);
207 
208     // ==============================
209     //            IERC165
210     // ==============================
211 
212     /**
213      * @dev Returns true if this contract implements the interface defined by
214      * `interfaceId`. See the corresponding
215      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
216      * to learn more about how these ids are created.
217      *
218      * This function call must use less than 30 000 gas.
219      */
220     function supportsInterface(bytes4 interfaceId) external view returns (bool);
221 
222     // ==============================
223     //            IERC721
224     // ==============================
225 
226     /**
227      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
228      */
229     event Transfer(
230         address indexed from,
231         address indexed to,
232         uint256 indexed tokenId
233     );
234 
235     /**
236      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
237      */
238     event Approval(
239         address indexed owner,
240         address indexed approved,
241         uint256 indexed tokenId
242     );
243 
244     /**
245      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
246      */
247     event ApprovalForAll(
248         address indexed owner,
249         address indexed operator,
250         bool approved
251     );
252 
253     /**
254      * @dev Returns the number of tokens in ``owner``'s account.
255      */
256     function balanceOf(address owner) external view returns (uint256 balance);
257 
258     /**
259      * @dev Returns the owner of the `tokenId` token.
260      *
261      * Requirements:
262      *
263      * - `tokenId` must exist.
264      */
265     function ownerOf(uint256 tokenId) external view returns (address owner);
266 
267     /**
268      * @dev Safely transfers `tokenId` token from `from` to `to`.
269      *
270      * Requirements:
271      *
272      * - `from` cannot be the zero address.
273      * - `to` cannot be the zero address.
274      * - `tokenId` token must exist and be owned by `from`.
275      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
276      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
277      *
278      * Emits a {Transfer} event.
279      */
280     function safeTransferFrom(
281         address from,
282         address to,
283         uint256 tokenId,
284         bytes calldata data
285     ) external;
286 
287     /**
288      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
289      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
290      *
291      * Requirements:
292      *
293      * - `from` cannot be the zero address.
294      * - `to` cannot be the zero address.
295      * - `tokenId` token must exist and be owned by `from`.
296      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
297      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
298      *
299      * Emits a {Transfer} event.
300      */
301     function safeTransferFrom(
302         address from,
303         address to,
304         uint256 tokenId
305     ) external;
306 
307     /**
308      * @dev Transfers `tokenId` token from `from` to `to`.
309      *
310      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
311      *
312      * Requirements:
313      *
314      * - `from` cannot be the zero address.
315      * - `to` cannot be the zero address.
316      * - `tokenId` token must be owned by `from`.
317      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
318      *
319      * Emits a {Transfer} event.
320      */
321     function transferFrom(
322         address from,
323         address to,
324         uint256 tokenId
325     ) external;
326 
327     /**
328      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
329      * The approval is cleared when the token is transferred.
330      *
331      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
332      *
333      * Requirements:
334      *
335      * - The caller must own the token or be an approved operator.
336      * - `tokenId` must exist.
337      *
338      * Emits an {Approval} event.
339      */
340     function approve(address to, uint256 tokenId) external;
341 
342     /**
343      * @dev Approve or remove `operator` as an operator for the caller.
344      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
345      *
346      * Requirements:
347      *
348      * - The `operator` cannot be the caller.
349      *
350      * Emits an {ApprovalForAll} event.
351      */
352     function setApprovalForAll(address operator, bool _approved) external;
353 
354     /**
355      * @dev Returns the account approved for `tokenId` token.
356      *
357      * Requirements:
358      *
359      * - `tokenId` must exist.
360      */
361     function getApproved(uint256 tokenId)
362         external
363         view
364         returns (address operator);
365 
366     /**
367      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
368      *
369      * See {setApprovalForAll}
370      */
371     function isApprovedForAll(address owner, address operator)
372         external
373         view
374         returns (bool);
375 
376     // ==============================
377     //        IERC721Metadata
378     // ==============================
379 
380     /**
381      * @dev Returns the token collection name.
382      */
383     function name() external view returns (string memory);
384 
385     /**
386      * @dev Returns the token collection symbol.
387      */
388     function symbol() external view returns (string memory);
389 
390     /**
391      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
392      */
393     function tokenURI(uint256 tokenId) external view returns (string memory);
394 }
395 
396 
397 
398 pragma solidity ^0.8.4;
399 
400 
401 /**
402  * @dev ERC721 token receiver interface.
403  */
404 interface ERC721E__IERC721Receiver {
405     function onERC721Received(
406         address operator,
407         address from,
408         uint256 tokenId,
409         bytes calldata data
410     ) external returns (bytes4);
411 }
412 
413 /**
414  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
415  * the Metadata extension. Built to optimize for lower gas during batch mints.
416  *
417  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
418  *
419  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
420  *
421  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
422  */
423 contract ERC721E is IERC721E, Ownable {
424     // Mask of an entry in packed address data.
425     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
426 
427     // The bit position of `numberMinted` in packed address data.
428     uint256 private constant BITPOS_NUMBER_MINTED = 64;
429 
430     // The bit position of `numberBurned` in packed address data.
431     uint256 private constant BITPOS_NUMBER_BURNED = 128;
432 
433     // The bit position of `aux` in packed address data.
434     uint256 private constant BITPOS_AUX = 192;
435 
436     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
437     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
438 
439     // The bit position of `startTimestamp` in packed ownership.
440     uint256 private constant BITPOS_START_TIMESTAMP = 160;
441 
442     // The bit mask of the `burned` bit in packed ownership.
443     uint256 private constant BITMASK_BURNED = 1 << 224;
444 
445     // The bit position of the `nextInitialized` bit in packed ownership.
446     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
447 
448     // The bit mask of the `nextInitialized` bit in packed ownership.
449     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
450 
451     // The tokenId of the next token to be minted.
452     uint256 private _currentIndex;
453 
454     // The number of tokens burned.
455     uint256 private _burnCounter;
456 
457     // Token name
458     string private _name;
459 
460     // Token symbol
461     string private _symbol;
462 
463     // Token price
464     uint256 public _price;
465 
466     // Divided royalties sender --> Divided royalties
467     mapping(address => uint256) public hadWithdrawedAddress;
468 
469     // Get donation or fund information
470     mapping(address => uint256) public addressToAmountFunded;
471 
472     uint256 public withdrawned = 0;
473 
474     // Mapping from token ID to ownership details
475     // An empty struct value does not necessarily mean the token is unowned.
476     // See `_packedOwnershipOf` implementation for details.
477     //
478     // Bits Layout:
479     // - [0..159]   `addr`
480     // - [160..223] `startTimestamp`
481     // - [224]      `burned`
482     // - [225]      `nextInitialized`
483     mapping(uint256 => uint256) private _packedOwnerships;
484 
485     // Mapping owner address to address data.
486     //
487     // Bits Layout:
488     // - [0..63]    `balance`
489     // - [64..127]  `numberMinted`
490     // - [128..191] `numberBurned`
491     // - [192..255] `aux`
492     mapping(address => uint256) private _packedAddressData;
493 
494     // Mapping from token ID to approved address.
495     mapping(uint256 => address) private _tokenApprovals;
496 
497     // Mapping from owner to operator approvals
498     mapping(address => mapping(address => bool)) private _operatorApprovals;
499 
500     constructor(
501         string memory name_,
502         string memory symbol_,
503         uint256 price_
504     ) {
505         _name = name_;
506         _symbol = symbol_;
507         _price = price_;
508         _currentIndex = _startTokenId();
509     }
510 
511     /**
512      * @dev Returns the starting token ID.
513      * To change the starting token ID, please override this function.
514      */
515     function _startTokenId() internal view virtual returns (uint256) {
516         return 0;
517     }
518 
519     /**
520      * @dev Returns the next token ID to be minted.
521      */
522     function _nextTokenId() internal view returns (uint256) {
523         return _currentIndex;
524     }
525 
526     /**
527      * @dev Returns the total number of tokens in existence.
528      * Burned tokens will reduce the count.
529      * To get the total number of tokens minted, please see `_totalMinted`.
530      */
531     function totalSupply() public view override returns (uint256) {
532         // Counter underflow is impossible as _burnCounter cannot be incremented
533         // more than `_currentIndex - _startTokenId()` times.
534         unchecked {
535             return _currentIndex - _burnCounter - _startTokenId();
536         }
537     }
538 
539     /**
540      * @dev Returns the total amount of tokens minted in the contract.
541      */
542     function _totalMinted() internal view returns (uint256) {
543         // Counter underflow is impossible as _currentIndex does not decrement,
544         // and it is initialized to `_startTokenId()`
545         unchecked {
546             return _currentIndex - _startTokenId();
547         }
548     }
549 
550     /**
551      * @dev Returns the total number of tokens burned.
552      */
553     function _totalBurned() internal view returns (uint256) {
554         return _burnCounter;
555     }
556 
557     /**
558      * @dev See {IERC165-supportsInterface}.
559      */
560     function supportsInterface(bytes4 interfaceId)
561         public
562         view
563         virtual
564         override
565         returns (bool)
566     {
567         // The interface IDs are constants representing the first 4 bytes of the XOR of
568         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
569         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
570         return
571             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
572             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
573             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
574     }
575 
576     /**
577      * @dev See {IERC721-balanceOf}.
578      */
579     function balanceOf(address owner) public view override returns (uint256) {
580         if (_addressToUint256(owner) == 0) revert BalanceQueryForZeroAddress();
581         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
582     }
583 
584     /**
585      * Returns the number of tokens minted by `owner`.
586      */
587     function _numberMinted(address owner) internal view returns (uint256) {
588         return
589             (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) &
590             BITMASK_ADDRESS_DATA_ENTRY;
591     }
592 
593     /**
594      * Returns the number of tokens burned by or on behalf of `owner`.
595      */
596     function _numberBurned(address owner) internal view returns (uint256) {
597         return
598             (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) &
599             BITMASK_ADDRESS_DATA_ENTRY;
600     }
601 
602     /**
603      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
604      */
605     function _getAux(address owner) internal view returns (uint64) {
606         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
607     }
608 
609     /**
610      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
611      * If there are multiple variables, please pack them into a uint64.
612      */
613     function _setAux(address owner, uint64 aux) internal {
614         uint256 packed = _packedAddressData[owner];
615         uint256 auxCasted;
616         assembly {
617             // Cast aux without masking.
618             auxCasted := aux
619         }
620         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
621         _packedAddressData[owner] = packed;
622     }
623 
624     /**
625      * Returns the packed ownership data of `tokenId`.
626      */
627     function _packedOwnershipOf(uint256 tokenId)
628         private
629         view
630         returns (uint256)
631     {
632         uint256 curr = tokenId;
633 
634         unchecked {
635             if (_startTokenId() <= curr)
636                 if (curr < _currentIndex) {
637                     uint256 packed = _packedOwnerships[curr];
638                     // If not burned.
639                     if (packed & BITMASK_BURNED == 0) {
640                         // Invariant:
641                         // There will always be an ownership that has an address and is not burned
642                         // before an ownership that does not have an address and is not burned.
643                         // Hence, curr will not underflow.
644                         //
645                         // We can directly compare the packed value.
646                         // If the address is zero, packed is zero.
647                         while (packed == 0) {
648                             packed = _packedOwnerships[--curr];
649                         }
650                         return packed;
651                     }
652                 }
653         }
654         revert OwnerQueryForNonexistentToken();
655     }
656 
657     /**
658      * Returns the unpacked `TokenOwnership` struct from `packed`.
659      */
660     function _unpackedOwnership(uint256 packed)
661         private
662         pure
663         returns (TokenOwnership memory ownership)
664     {
665         ownership.addr = address(uint160(packed));
666         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
667         ownership.burned = packed & BITMASK_BURNED != 0;
668     }
669 
670     /**
671      * Returns the unpacked `TokenOwnership` struct at `index`.
672      */
673     function _ownershipAt(uint256 index)
674         internal
675         view
676         returns (TokenOwnership memory)
677     {
678         return _unpackedOwnership(_packedOwnerships[index]);
679     }
680 
681     /**
682      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
683      */
684     function _initializeOwnershipAt(uint256 index) internal {
685         if (_packedOwnerships[index] == 0) {
686             _packedOwnerships[index] = _packedOwnershipOf(index);
687         }
688     }
689 
690     /**
691      * Gas spent here starts off proportional to the maximum mint batch size.
692      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
693      */
694     function _ownershipOf(uint256 tokenId)
695         internal
696         view
697         returns (TokenOwnership memory)
698     {
699         return _unpackedOwnership(_packedOwnershipOf(tokenId));
700     }
701 
702     /**
703      * @dev See {IERC721-ownerOf}.
704      */
705     function ownerOf(uint256 tokenId) public view override returns (address) {
706         return address(uint160(_packedOwnershipOf(tokenId)));
707     }
708 
709     /**
710      * @dev See {IERC721Metadata-name}.
711      */
712     function name() public view virtual override returns (string memory) {
713         return _name;
714     }
715 
716     /**
717      * @dev See {IERC721Metadata-symbol}.
718      */
719     function symbol() public view virtual override returns (string memory) {
720         return _symbol;
721     }
722 
723     /**
724      * @dev See {IERC721Metadata-tokenURI}.
725      */
726     function tokenURI(uint256 tokenId)
727         public
728         view
729         virtual
730         override
731         returns (string memory)
732     {
733         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
734 
735         string memory baseURI = _baseURI();
736         return
737             bytes(baseURI).length != 0
738                 ? string(abi.encodePacked(baseURI, _toString(tokenId)))
739                 : "";
740     }
741 
742     /**
743      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
744      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
745      * by default, it can be overridden in child contracts.
746      */
747     function _baseURI() internal view virtual returns (string memory) {
748         return "";
749     }
750 
751     /**
752      * @dev Casts the address to uint256 without masking.
753      */
754     function _addressToUint256(address value)
755         private
756         pure
757         returns (uint256 result)
758     {
759         assembly {
760             result := value
761         }
762     }
763 
764     /**
765      * @dev Casts the boolean to uint256 without branching.
766      */
767     function _boolToUint256(bool value) private pure returns (uint256 result) {
768         assembly {
769             result := value
770         }
771     }
772 
773     /**
774      * @dev See {IERC721-approve}.
775      */
776     function approve(address to, uint256 tokenId) public override {
777         address owner = address(uint160(_packedOwnershipOf(tokenId)));
778 
779         if (_msgSenderERC721E() != owner)
780             if (!isApprovedForAll(owner, _msgSenderERC721E())) {
781                 revert ApprovalCallerNotOwnerNorApproved();
782             }
783 
784         _tokenApprovals[tokenId] = to;
785         emit Approval(owner, to, tokenId);
786     }
787 
788     /**
789      * @dev See {IERC721-getApproved}.
790      */
791     function getApproved(uint256 tokenId)
792         public
793         view
794         override
795         returns (address)
796     {
797         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
798 
799         return _tokenApprovals[tokenId];
800     }
801 
802     /**
803      * @dev See {IERC721-setApprovalForAll}.
804      */
805     function setApprovalForAll(address operator, bool approved)
806         public
807         virtual
808         override
809     {
810         if (operator == _msgSenderERC721E()) revert ApproveToCaller();
811 
812         _operatorApprovals[_msgSenderERC721E()][operator] = approved;
813         emit ApprovalForAll(_msgSenderERC721E(), operator, approved);
814     }
815 
816     /**
817      * @dev See {IERC721-isApprovedForAll}.
818      */
819     function isApprovedForAll(address owner, address operator)
820         public
821         view
822         virtual
823         override
824         returns (bool)
825     {
826         return _operatorApprovals[owner][operator];
827     }
828 
829     /**
830      * @dev See {IERC721-transferFrom}.
831      */
832     function transferFrom(
833         address from,
834         address to,
835         uint256 tokenId
836     ) public virtual override {
837         _transfer(from, to, tokenId);
838     }
839 
840     /**
841      * @dev See {IERC721-safeTransferFrom}.
842      */
843     function safeTransferFrom(
844         address from,
845         address to,
846         uint256 tokenId
847     ) public virtual override {
848         safeTransferFrom(from, to, tokenId, "");
849     }
850 
851     /**
852      * @dev See {IERC721-safeTransferFrom}.
853      */
854     function safeTransferFrom(
855         address from,
856         address to,
857         uint256 tokenId,
858         bytes memory _data
859     ) public virtual override {
860         _transfer(from, to, tokenId);
861         if (to.code.length != 0)
862             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
863                 revert TransferToNonERC721ReceiverImplementer();
864             }
865     }
866 
867     /**
868      * @dev Returns whether `tokenId` exists.
869      *
870      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
871      *
872      * Tokens start existing when they are minted (`_mint`),
873      */
874     function _exists(uint256 tokenId) internal view returns (bool) {
875         return
876             _startTokenId() <= tokenId &&
877             tokenId < _currentIndex && // If within bounds,
878             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
879     }
880 
881     /**
882      * @dev Equivalent to `_safeMint(to, quantity, '')`.
883      */
884     function _safeMint(address to, uint256 quantity) internal {
885         _safeMint(to, quantity, "");
886     }
887 
888     /**
889      * @dev Safely mints `quantity` tokens and transfers them to `to`.
890      *
891      * Requirements:
892      *
893      * - If `to` refers to a smart contract, it must implement
894      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
895      * - `quantity` must be greater than 0.
896      *
897      * Emits a {Transfer} event for each mint.
898      */
899     function _safeMint(
900         address to,
901         uint256 quantity,
902         bytes memory _data
903     ) internal {
904         _mint(to, quantity);
905 
906         unchecked {
907             if (to.code.length != 0) {
908                 uint256 end = _currentIndex;
909                 uint256 index = end - quantity;
910                 do {
911                     if (
912                         !_checkContractOnERC721Received(
913                             address(0),
914                             to,
915                             index++,
916                             _data
917                         )
918                     ) {
919                         revert TransferToNonERC721ReceiverImplementer();
920                     }
921                 } while (index < end);
922                 // Reentrancy protection.
923                 if (_currentIndex != end) revert();
924             }
925         }
926     }
927 
928     /**
929      * @dev Mints `quantity` tokens and transfers them to `to`.
930      *
931      * Requirements:
932      *
933      * - `to` cannot be the zero address.
934      * - `quantity` must be greater than 0.
935      *
936      * Emits a {Transfer} event for each mint.
937      */
938     function _mint(address to, uint256 quantity) internal {
939         uint256 startTokenId = _currentIndex;
940         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
941         if (quantity == 0) revert MintZeroQuantity();
942 
943         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
944 
945         // Overflows are incredibly unrealistic.
946         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
947         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
948         unchecked {
949             // Updates:
950             // - `balance += quantity`.
951             // - `numberMinted += quantity`.
952             //
953             // We can directly add to the balance and number minted.
954             _packedAddressData[to] +=
955                 quantity *
956                 ((1 << BITPOS_NUMBER_MINTED) | 1);
957 
958             // Updates:
959             // - `address` to the owner.
960             // - `startTimestamp` to the timestamp of minting.
961             // - `burned` to `false`.
962             // - `nextInitialized` to `quantity == 1`.
963             _packedOwnerships[startTokenId] =
964                 _addressToUint256(to) |
965                 (block.timestamp << BITPOS_START_TIMESTAMP) |
966                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
967 
968             uint256 offset;
969             do {
970                 emit Transfer(address(0), to, startTokenId + offset++);
971             } while (offset < quantity);
972 
973             _currentIndex = startTokenId + quantity;
974         }
975         _afterTokenTransfers(address(0), to, startTokenId, quantity);
976     }
977 
978     /**
979      * @dev Transfers `tokenId` from `from` to `to`.
980      *
981      * Requirements:
982      *
983      * - `to` cannot be the zero address.
984      * - `tokenId` token must be owned by `from`.
985      *
986      * Emits a {Transfer} event.
987      */
988     function _transfer(
989         address from,
990         address to,
991         uint256 tokenId
992     ) private {
993         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
994 
995         if (address(uint160(prevOwnershipPacked)) != from)
996             revert TransferFromIncorrectOwner();
997 
998         address approvedAddress = _tokenApprovals[tokenId];
999 
1000         bool isApprovedOrOwner = (_msgSenderERC721E() == from ||
1001             isApprovedForAll(from, _msgSenderERC721E()) ||
1002             approvedAddress == _msgSenderERC721E());
1003 
1004         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1005         if (_addressToUint256(to) == 0) revert TransferToZeroAddress();
1006 
1007         _beforeTokenTransfers(from, to, tokenId, 1);
1008 
1009         // Clear approvals from the previous owner.
1010         if (_addressToUint256(approvedAddress) != 0) {
1011             delete _tokenApprovals[tokenId];
1012         }
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
1071         address approvedAddress = _tokenApprovals[tokenId];
1072 
1073         if (approvalCheck) {
1074             bool isApprovedOrOwner = (_msgSenderERC721E() == from ||
1075                 isApprovedForAll(from, _msgSenderERC721E()) ||
1076                 approvedAddress == _msgSenderERC721E());
1077 
1078             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1079         }
1080 
1081         _beforeTokenTransfers(from, address(0), tokenId, 1);
1082 
1083         // Clear approvals from the previous owner.
1084         if (_addressToUint256(approvedAddress) != 0) {
1085             delete _tokenApprovals[tokenId];
1086         }
1087 
1088         // Underflow of the sender's balance is impossible because we check for
1089         // ownership above and the recipient's balance can't realistically overflow.
1090         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1091         unchecked {
1092             // Updates:
1093             // - `balance -= 1`.
1094             // - `numberBurned += 1`.
1095             //
1096             // We can directly decrement the balance, and increment the number burned.
1097             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1098             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1099 
1100             // Updates:
1101             // - `address` to the last owner.
1102             // - `startTimestamp` to the timestamp of burning.
1103             // - `burned` to `true`.
1104             // - `nextInitialized` to `true`.
1105             _packedOwnerships[tokenId] =
1106                 _addressToUint256(from) |
1107                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1108                 BITMASK_BURNED |
1109                 BITMASK_NEXT_INITIALIZED;
1110 
1111             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1112             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1113                 uint256 nextTokenId = tokenId + 1;
1114                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1115                 if (_packedOwnerships[nextTokenId] == 0) {
1116                     // If the next slot is within bounds.
1117                     if (nextTokenId != _currentIndex) {
1118                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1119                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1120                     }
1121                 }
1122             }
1123         }
1124 
1125         emit Transfer(from, address(0), tokenId);
1126         _afterTokenTransfers(from, address(0), tokenId, 1);
1127 
1128         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1129         unchecked {
1130             _burnCounter++;
1131         }
1132     }
1133 
1134     /**
1135      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1136      *
1137      * @param from address representing the previous owner of the given token ID
1138      * @param to target address that will receive the tokens
1139      * @param tokenId uint256 ID of the token to be transferred
1140      * @param _data bytes optional data to send along with the call
1141      * @return bool whether the call correctly returned the expected magic value
1142      */
1143     function _checkContractOnERC721Received(
1144         address from,
1145         address to,
1146         uint256 tokenId,
1147         bytes memory _data
1148     ) private returns (bool) {
1149         try
1150             ERC721E__IERC721Receiver(to).onERC721Received(
1151                 _msgSenderERC721E(),
1152                 from,
1153                 tokenId,
1154                 _data
1155             )
1156         returns (bytes4 retval) {
1157             return
1158                 retval ==
1159                 ERC721E__IERC721Receiver(to).onERC721Received.selector;
1160         } catch (bytes memory reason) {
1161             if (reason.length == 0) {
1162                 revert TransferToNonERC721ReceiverImplementer();
1163             } else {
1164                 assembly {
1165                     revert(add(32, reason), mload(reason))
1166                 }
1167             }
1168         }
1169     }
1170 
1171     /**
1172      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1173      * And also called before burning one token.
1174      *
1175      * startTokenId - the first token id to be transferred
1176      * quantity - the amount to be transferred
1177      *
1178      * Calling conditions:
1179      *
1180      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1181      * transferred to `to`.
1182      * - When `from` is zero, `tokenId` will be minted for `to`.
1183      * - When `to` is zero, `tokenId` will be burned by `from`.
1184      * - `from` and `to` are never both zero.
1185      */
1186     function _beforeTokenTransfers(
1187         address from,
1188         address to,
1189         uint256 startTokenId,
1190         uint256 quantity
1191     ) internal virtual {}
1192 
1193     /**
1194      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1195      * minting.
1196      * And also called after one token has been burned.
1197      *
1198      * startTokenId - the first token id to be transferred
1199      * quantity - the amount to be transferred
1200      *
1201      * Calling conditions:
1202      *
1203      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1204      * transferred to `to`.
1205      * - When `from` is zero, `tokenId` has been minted for `to`.
1206      * - When `to` is zero, `tokenId` has been burned by `from`.
1207      * - `from` and `to` are never both zero.
1208      */
1209     function _afterTokenTransfers(
1210         address from,
1211         address to,
1212         uint256 startTokenId,
1213         uint256 quantity
1214     ) internal virtual {}
1215 
1216     /**
1217      * @dev Returns the message sender (defaults to `msg.sender`).
1218      *
1219      * If you are writing GSN compatible contracts, you need to override this function.
1220      */
1221     function _msgSenderERC721E() internal view virtual returns (address) {
1222         return msg.sender;
1223     }
1224 
1225     /**
1226      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1227      */
1228     function _toString(uint256 value)
1229         internal
1230         pure
1231         returns (string memory ptr)
1232     {
1233         assembly {
1234             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1235             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1236             // We will need 1 32-byte word to store the length,
1237             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1238             ptr := add(mload(0x40), 128)
1239             // Update the free memory pointer to allocate.
1240             mstore(0x40, ptr)
1241 
1242             // Cache the end of the memory to calculate the length later.
1243             let end := ptr
1244 
1245             // We write the string from the rightmost digit to the leftmost digit.
1246             // The following is essentially a do-while loop that also handles the zero case.
1247             // Costs a bit more than early returning for the zero case,
1248             // but cheaper in terms of deployment and overall runtime costs.
1249             for {
1250                 // Initialize and perform the first pass without check.
1251                 let temp := value
1252                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1253                 ptr := sub(ptr, 1)
1254                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1255                 mstore8(ptr, add(48, mod(temp, 10)))
1256                 temp := div(temp, 10)
1257             } temp {
1258                 // Keep dividing `temp` until zero.
1259                 temp := div(temp, 10)
1260             } {
1261                 // Body of the for loop.
1262                 ptr := sub(ptr, 1)
1263                 mstore8(ptr, add(48, mod(temp, 10)))
1264             }
1265 
1266             let length := sub(end, ptr)
1267             // Move the pointer 32 bytes leftwards to make room for the length.
1268             ptr := sub(ptr, 32)
1269             // Store the length.
1270             mstore(ptr, length)
1271         }
1272     }
1273 
1274     // Donate money and record the address of the sender of the message and the amount sent
1275     function fund() public payable {
1276         addressToAmountFunded[msg.sender] += msg.value;
1277     }
1278 
1279     function getThisBalance() public view returns (uint256) {
1280         return address(this).balance;
1281     }
1282 
1283     function getAllRoyaltyProfit() public view returns (uint256) {
1284         return address(this).balance - totalSupply() * _price - withdrawned;
1285     }
1286 
1287     // Get the current maximum withdrawal of the project party
1288     function canMaxWithdraw() public view returns (uint256) {
1289         return _price * totalSupply() - withdrawned;
1290     }
1291 
1292     // Withdraws ether from the contract
1293     function withdraw() public payable virtual onlyOwner {
1294         // Amount not withdrawn by the project party = current number of units sold * selling price - amount withdrawn by the project party
1295         uint256 canWithdraw = _price * totalSupply() - withdrawned;
1296         withdrawned += canWithdraw;
1297         (bool os, ) = payable(msg.sender).call{value: canWithdraw}("");
1298         require(os);
1299     }
1300 
1301     // Users get their own royalties to be distributed
1302     function getExtractRoyalties(address userAddress)
1303         public
1304         view
1305         virtual
1306         returns (uint256)
1307     {
1308         // Access balance + amount already withdrawn by the project owner + amount already withdrawn by the user + accidental withdrawals >= contract revenue (excluding accidental withdrawals) = (sell profit + royalty profit)
1309         // Contract revenue = (sell profit + royalty profit) = (project owner's undrawn cash + project owner's withdrawn cash) + (user's undrawn cash + user's withdrawn cash)
1310         // Contract revenue = money to the project owner + money to the user = (amount of cash undrawn by the project owner + amount of cash withdrawn by the project owner) + (amount of cash undrawn by the user + amount of cash withdrawn by the user)
1311         // Contract Revenue = Projector's undrawn cash + Projector's withdrawn cash + User's undrawn cash + User's withdrawn cash = (sell profit + royalty profit)
1312         uint256 overage = address(this).balance;
1313 
1314         // Project revenue = number of units currently sold * selling price = amount of cash undrawn by the project + amount of cash withdrawn by the project
1315         // Project's undrawn cash = Number of units currently sold * Sold price - Project's withdrawn cash
1316         uint256 notWithdrawnProfit = (_currentIndex -
1317             _burnCounter -
1318             _startTokenId()) *
1319             _price -
1320             withdrawned;
1321 
1322         // royalty profit = balance + amount withdrawn by the project owner + amount withdrawn by the user - sell profit = balance + amount withdrawn by the user - (sell profit - amount withdrawn by the project owner)
1323         // Royalty Earnings = Balance + User's Withdrawn Cash - Projector's Undrawn Cash = Balance + (Royalty Earnings - User's Undrawn Cash) - Projector's Undrawn Cash
1324         // User's undrawn cash = balance - project owner's undrawn cash
1325         uint256 royaltyProfit = overage - notWithdrawnProfit;
1326 
1327         // sender's share of royalties = royalty profit / total number of issues * number of sender's purchases - the sender's share of royalties
1328         uint256 giveSender = (royaltyProfit /
1329             (_currentIndex - _burnCounter - _startTokenId())) *
1330             balanceOf(userAddress) -
1331             hadWithdrawedAddress[userAddress];
1332 
1333         // If there is a situation where a late mint user comes in, and the total undrawn amount for all current users < the calculation of the equal share (royalties to be shared), it will need to be calculated after subsequent royalty increases
1334         // This case returns 0
1335         if (giveSender <= 0) return 0;
1336         return giveSender;
1337     }
1338 
1339     function extractRoyalties() public payable {
1340         uint256 giveSender = getExtractRoyalties(msg.sender);
1341 
1342         if (giveSender == 0) revert NoWithdrawableAmount();
1343 
1344         // Update sender divided royalties
1345         hadWithdrawedAddress[msg.sender] += giveSender;
1346 
1347         // Pay the sender
1348         (bool os, ) = payable(msg.sender).call{value: giveSender}("");
1349         require(os);
1350     }
1351 }
1352 
1353 pragma solidity ^0.8.0;
1354 
1355 /**
1356  * @dev These functions deal with verification of Merkle Trees proofs.
1357  *
1358  * The proofs can be generated using the JavaScript library
1359  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1360  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1361  *
1362  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1363  *
1364  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1365  * hashing, or use a hash function other than keccak256 for hashing leaves.
1366  * This is because the concatenation of a sorted pair of internal nodes in
1367  * the merkle tree could be reinterpreted as a leaf value.
1368  */
1369 library MerkleProof {
1370     /**
1371      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1372      * defined by `root`. For this, a `proof` must be provided, containing
1373      * sibling hashes on the branch from the leaf to the root of the tree. Each
1374      * pair of leaves and each pair of pre-images are assumed to be sorted.
1375      */
1376     function verify(
1377         bytes32[] memory proof,
1378         bytes32 root,
1379         bytes32 leaf
1380     ) internal pure returns (bool) {
1381         return processProof(proof, leaf) == root;
1382     }
1383 
1384     /**
1385      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1386      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1387      * hash matches the root of the tree. When processing the proof, the pairs
1388      * of leafs & pre-images are assumed to be sorted.
1389      *
1390      * _Available since v4.4._
1391      */
1392     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1393         bytes32 computedHash = leaf;
1394         for (uint256 i = 0; i < proof.length; i++) {
1395             bytes32 proofElement = proof[i];
1396             if (computedHash <= proofElement) {
1397                 // Hash(current computed hash + current element of the proof)
1398                 computedHash = _efficientHash(computedHash, proofElement);
1399             } else {
1400                 // Hash(current element of the proof + current computed hash)
1401                 computedHash = _efficientHash(proofElement, computedHash);
1402             }
1403         }
1404         return computedHash;
1405     }
1406 
1407     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1408         assembly {
1409             mstore(0x00, a)
1410             mstore(0x20, b)
1411             value := keccak256(0x00, 0x40)
1412         }
1413     }
1414 }
1415 
1416 
1417 pragma solidity ^0.8.0;
1418 
1419 /**
1420  * @dev Contract module that helps prevent reentrant calls to a function.
1421  *
1422  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1423  * available, which can be applied to functions to make sure there are no nested
1424  * (reentrant) calls to them.
1425  *
1426  * Note that because there is a single `nonReentrant` guard, functions marked as
1427  * `nonReentrant` may not call one another. This can be worked around by making
1428  * those functions `private`, and then adding `external` `nonReentrant` entry
1429  * points to them.
1430  *
1431  * TIP: If you would like to learn more about reentrancy and alternative ways
1432  * to protect against it, check out our blog post
1433  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1434  */
1435 abstract contract ReentrancyGuard {
1436     // Booleans are more expensive than uint256 or any type that takes up a full
1437     // word because each write operation emits an extra SLOAD to first read the
1438     // slot's contents, replace the bits taken up by the boolean, and then write
1439     // back. This is the compiler's defense against contract upgrades and
1440     // pointer aliasing, and it cannot be disabled.
1441 
1442     // The values being non-zero value makes deployment a bit more expensive,
1443     // but in exchange the refund on every call to nonReentrant will be lower in
1444     // amount. Since refunds are capped to a percentage of the total
1445     // transaction's gas, it is best to keep them low in cases like this one, to
1446     // increase the likelihood of the full refund coming into effect.
1447     uint256 private constant _NOT_ENTERED = 1;
1448     uint256 private constant _ENTERED = 2;
1449 
1450     uint256 private _status;
1451 
1452     constructor() {
1453         _status = _NOT_ENTERED;
1454     }
1455 
1456     /**
1457      * @dev Prevents a contract from calling itself, directly or indirectly.
1458      * Calling a `nonReentrant` function from another `nonReentrant`
1459      * function is not supported. It is possible to prevent this from happening
1460      * by making the `nonReentrant` function external, and making it call a
1461      * `private` function that does the actual work.
1462      */
1463     modifier nonReentrant() {
1464         // On the first call to nonReentrant, _notEntered will be true
1465         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1466 
1467         // Any calls to nonReentrant after this point will fail
1468         _status = _ENTERED;
1469 
1470         _;
1471 
1472         // By storing the original value once again, a refund is triggered (see
1473         // https://eips.ethereum.org/EIPS/eip-2200)
1474         _status = _NOT_ENTERED;
1475     }
1476 }
1477 
1478 
1479 pragma solidity ^0.8.0;
1480 
1481 /**
1482  * @dev String operations.
1483  */
1484 library Strings {
1485     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1486 
1487     /**
1488      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1489      */
1490     function toString(uint256 value) internal pure returns (string memory) {
1491         // Inspired by OraclizeAPI's implementation - MIT licence
1492         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1493 
1494         if (value == 0) {
1495             return "0";
1496         }
1497         uint256 temp = value;
1498         uint256 digits;
1499         while (temp != 0) {
1500             digits++;
1501             temp /= 10;
1502         }
1503         bytes memory buffer = new bytes(digits);
1504         while (value != 0) {
1505             digits -= 1;
1506             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1507             value /= 10;
1508         }
1509         return string(buffer);
1510     }
1511 
1512     /**
1513      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1514      */
1515     function toHexString(uint256 value) internal pure returns (string memory) {
1516         if (value == 0) {
1517             return "0x00";
1518         }
1519         uint256 temp = value;
1520         uint256 length = 0;
1521         while (temp != 0) {
1522             length++;
1523             temp >>= 8;
1524         }
1525         return toHexString(value, length);
1526     }
1527 
1528     /**
1529      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1530      */
1531     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1532         bytes memory buffer = new bytes(2 * length + 2);
1533         buffer[0] = "0";
1534         buffer[1] = "x";
1535         for (uint256 i = 2 * length + 1; i > 1; --i) {
1536             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1537             value >>= 4;
1538         }
1539         require(value == 0, "Strings: hex length insufficient");
1540         return string(buffer);
1541     }
1542 }
1543 
1544 
1545 
1546 pragma solidity >=0.7.0 <0.9.0;
1547 
1548 
1549 /**
1550  * @dev Implementation of [ERC721E](https://github.com/ERC721E/ERC721E) and
1551  * [ERC721A](https://github.com/chiru-labs/ERC721A). Thanks to contributors!
1552  * Save on gas when you mint multiple NFTs at once. ERC721A is an improved implementation of the IERC721
1553  * standard that supports minting multiple tokens for close to the cost of one.
1554  */
1555 contract Coroodles is ERC721E {
1556     using Strings for uint256;
1557     string public baseURI;
1558     uint256 public price = 0 ether;
1559     uint256 public maxSupply = 2000;
1560     bool public revealed = false;
1561     bool public publicSale = false;
1562     mapping(address => uint256) public userMaxMintNum;
1563     mapping(address => uint256) public userMintNum;
1564 
1565     event Minted(address minter, uint256 amount);
1566 
1567     error NotStarted();
1568     error InsufficientSupply();
1569     error MintAtLeastOne();
1570     error InsufficientBalance();
1571     error InsufficientNumberOfNFTs();
1572     error NonexistentToken();
1573     error InvalidMerkleProof();
1574     error AddressAlreadyClaimed();
1575 
1576     modifier isNotFalse(bool _x) {
1577         if (_x == false) {
1578             revert NotStarted();
1579         }
1580         _;
1581     }
1582 
1583     modifier sufficientSupply(uint256 _mintAmount) {
1584         if (_mintAmount <= 0) {
1585             revert MintAtLeastOne();
1586         }
1587         uint256 supply = totalSupply();
1588         if (supply + _mintAmount > maxSupply) {
1589             revert InsufficientSupply();
1590         }
1591         _;
1592     }
1593 
1594     constructor(string memory _name, string memory _symbol)
1595         ERC721E(_name, _symbol, price)
1596     {}
1597 
1598     function _baseURI() internal view virtual override returns (string memory) {
1599         return baseURI;
1600     }
1601 
1602     // Airdrop NFTs to OG
1603     function reserve(address _address, uint256 _mintAmount)
1604         public
1605         onlyOwner
1606         sufficientSupply(_mintAmount)
1607     {
1608         _safeMint(_address, _mintAmount);
1609         emit Minted(_address, _mintAmount);
1610     }
1611 
1612     function setUserMaxMintNum(address[] memory userAddress, uint256 num)
1613         public
1614         onlyOwner
1615     {
1616         // uint256 public o1Mint = 3;
1617         // uint256 public o2Mint = 5;
1618         // uint256 public o3Mint = 8;
1619         // uint256 public o4Mint = 10;
1620         for (uint256 i; i < userAddress.length; i++) {
1621             userMaxMintNum[userAddress[i]] = num;
1622         }
1623     }
1624 
1625     // Get the number of mints that an address can currently mint
1626     function getCouldMintNum(address userAddress)
1627         public
1628         view
1629         returns (uint256)
1630     {
1631         uint256 _userMaxMintNum = userMaxMintNum[userAddress] == 0
1632             ? 3
1633             : userMaxMintNum[userAddress];
1634         return _userMaxMintNum - userMintNum[userAddress];
1635     }
1636 
1637     // Official of NFT minting
1638     function publicSaleMint(uint256 _mintAmount)
1639         public
1640         payable
1641         isNotFalse(publicSale)
1642         sufficientSupply(_mintAmount)
1643     {
1644         if (_mintAmount > getCouldMintNum(msg.sender)) {
1645             revert InsufficientNumberOfNFTs();
1646         }
1647         if (msg.value < price * _mintAmount) {
1648             revert InsufficientBalance();
1649         }
1650         userMintNum[msg.sender] += _mintAmount;
1651         _safeMint(msg.sender, _mintAmount);
1652         emit Minted(msg.sender, _mintAmount);
1653     }
1654 
1655     function tokenURI(uint256 tokenId)
1656         public
1657         view
1658         virtual
1659         override
1660         returns (string memory)
1661     {
1662         if (!_exists(tokenId)) {
1663             revert NonexistentToken();
1664         }
1665         if (revealed == false) {
1666             return
1667                 "https://gateway.pinata.cloud/ipfs/QmUrjCDHCGzz2sybBboopiD4tmwaQBgybc2NfsDxCn5ecJ";
1668         } else {
1669             string memory currentBaseURI = _baseURI();
1670             return
1671                 bytes(currentBaseURI).length > 0
1672                     ? string(
1673                         abi.encodePacked(
1674                             currentBaseURI,
1675                             tokenId.toString(),
1676                             ".json"
1677                         )
1678                     )
1679                     : "";
1680         }
1681     }
1682 
1683     // Open the blind box
1684     function setRreveal(bool _state, string memory _revealURI)
1685         public
1686         onlyOwner
1687     {
1688         revealed = _state;
1689         baseURI = _revealURI;
1690     }
1691 
1692     // Set the official release price
1693     function setPrice(uint256 _newPrice) public onlyOwner {
1694         price = _newPrice;
1695     }
1696 
1697     // Official sale begins
1698     function setPublicSale(bool _state) public onlyOwner {
1699         publicSale = _state;
1700     }
1701 }