1 pragma solidity ^0.8.14;
2 
3 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
4 /**
5  * @dev Contract module that helps prevent reentrant calls to a function.
6  *
7  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
8  * available, which can be applied to functions to make sure there are no nested
9  * (reentrant) calls to them.
10  *
11  * Note that because there is a single `nonReentrant` guard, functions marked as
12  * `nonReentrant` may not call one another. This can be worked around by making
13  * those functions `private`, and then adding `external` `nonReentrant` entry
14  * points to them.
15  *
16  * TIP: If you would like to learn more about reentrancy and alternative ways
17  * to protect against it, check out our blog post
18  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
19  */
20 abstract contract ReentrancyGuard {
21     // Booleans are more expensive than uint256 or any type that takes up a full
22     // word because each write operation emits an extra SLOAD to first read the
23     // slot's contents, replace the bits taken up by the boolean, and then write
24     // back. This is the compiler's defense against contract upgrades and
25     // pointer aliasing, and it cannot be disabled.
26 
27     // The values being non-zero value makes deployment a bit more expensive,
28     // but in exchange the refund on every call to nonReentrant will be lower in
29     // amount. Since refunds are capped to a percentage of the total
30     // transaction's gas, it is best to keep them low in cases like this one, to
31     // increase the likelihood of the full refund coming into effect.
32     uint256 private constant _NOT_ENTERED = 1;
33     uint256 private constant _ENTERED = 2;
34 
35     uint256 private _status;
36 
37     constructor() {
38         _status = _NOT_ENTERED;
39     }
40 
41     /**
42      * @dev Prevents a contract from calling itself, directly or indirectly.
43      * Calling a `nonReentrant` function from another `nonReentrant`
44      * function is not supported. It is possible to prevent this from happening
45      * by making the `nonReentrant` function external, and making it call a
46      * `private` function that does the actual work.
47      */
48     modifier nonReentrant() {
49         _nonReentrantBefore();
50         _;
51         _nonReentrantAfter();
52     }
53 
54     function _nonReentrantBefore() private {
55         // On the first call to nonReentrant, _status will be _NOT_ENTERED
56         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
57 
58         // Any calls to nonReentrant after this point will fail
59         _status = _ENTERED;
60     }
61 
62     function _nonReentrantAfter() private {
63         // By storing the original value once again, a refund is triggered (see
64         // https://eips.ethereum.org/EIPS/eip-2200)
65         _status = _NOT_ENTERED;
66     }
67 }
68 
69 
70 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
71 /**
72  * @dev Provides information about the current execution context, including the
73  * sender of the transaction and its data. While these are generally available
74  * via msg.sender and msg.data, they should not be accessed in such a direct
75  * manner, since when dealing with meta-transactions the account sending and
76  * paying for execution may not be the actual sender (as far as an application
77  * is concerned).
78  *
79  * This contract is only required for intermediate, library-like contracts.
80  */
81 abstract contract Context {
82     function _msgSender() internal view virtual returns (address) {
83         return msg.sender;
84     }
85 
86     function _msgData() internal view virtual returns (bytes calldata) {
87         return msg.data;
88     }
89 }
90 
91 
92 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
93 /**
94  * @dev Contract module which allows children to implement an emergency stop
95  * mechanism that can be triggered by an authorized account.
96  *
97  * This module is used through inheritance. It will make available the
98  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
99  * the functions of your contract. Note that they will not be pausable by
100  * simply including this module, only once the modifiers are put in place.
101  */
102 abstract contract Pausable is Context {
103     /**
104      * @dev Emitted when the pause is triggered by `account`.
105      */
106     event Paused(address account);
107 
108     /**
109      * @dev Emitted when the pause is lifted by `account`.
110      */
111     event Unpaused(address account);
112 
113     bool private _paused;
114 
115     /**
116      * @dev Initializes the contract in unpaused state.
117      */
118     constructor() {
119         _paused = false;
120     }
121 
122     /**
123      * @dev Modifier to make a function callable only when the contract is not paused.
124      *
125      * Requirements:
126      *
127      * - The contract must not be paused.
128      */
129     modifier whenNotPaused() {
130         _requireNotPaused();
131         _;
132     }
133 
134     /**
135      * @dev Modifier to make a function callable only when the contract is paused.
136      *
137      * Requirements:
138      *
139      * - The contract must be paused.
140      */
141     modifier whenPaused() {
142         _requirePaused();
143         _;
144     }
145 
146     /**
147      * @dev Returns true if the contract is paused, and false otherwise.
148      */
149     function paused() public view virtual returns (bool) {
150         return _paused;
151     }
152 
153     /**
154      * @dev Throws if the contract is paused.
155      */
156     function _requireNotPaused() internal view virtual {
157         require(!paused(), "Pausable: paused");
158     }
159 
160     /**
161      * @dev Throws if the contract is not paused.
162      */
163     function _requirePaused() internal view virtual {
164         require(paused(), "Pausable: not paused");
165     }
166 
167     /**
168      * @dev Triggers stopped state.
169      *
170      * Requirements:
171      *
172      * - The contract must not be paused.
173      */
174     function _pause() internal virtual whenNotPaused {
175         _paused = true;
176         emit Paused(_msgSender());
177     }
178 
179     /**
180      * @dev Returns to normal state.
181      *
182      * Requirements:
183      *
184      * - The contract must be paused.
185      */
186     function _unpause() internal virtual whenPaused {
187         _paused = false;
188         emit Unpaused(_msgSender());
189     }
190 }
191 
192 
193 // ERC721A Contracts v4.2.3
194 // Creator: Chiru Labs
195 /**
196  * @dev Interface of ERC721A.
197  */
198 interface IERC721A {
199     /**
200      * The caller must own the token or be an approved operator.
201      */
202     error ApprovalCallerNotOwnerNorApproved();
203 
204     /**
205      * The token does not exist.
206      */
207     error ApprovalQueryForNonexistentToken();
208 
209     /**
210      * Cannot query the balance for the zero address.
211      */
212     error BalanceQueryForZeroAddress();
213 
214     /**
215      * Cannot mint to the zero address.
216      */
217     error MintToZeroAddress();
218 
219     /**
220      * The quantity of tokens minted must be more than zero.
221      */
222     error MintZeroQuantity();
223 
224     /**
225      * The token does not exist.
226      */
227     error OwnerQueryForNonexistentToken();
228 
229     /**
230      * The caller must own the token or be an approved operator.
231      */
232     error TransferCallerNotOwnerNorApproved();
233 
234     /**
235      * The token must be owned by `from`.
236      */
237     error TransferFromIncorrectOwner();
238 
239     /**
240      * Cannot safely transfer to a contract that does not implement the
241      * ERC721Receiver interface.
242      */
243     error TransferToNonERC721ReceiverImplementer();
244 
245     /**
246      * Cannot transfer to the zero address.
247      */
248     error TransferToZeroAddress();
249 
250     /**
251      * The token does not exist.
252      */
253     error URIQueryForNonexistentToken();
254 
255     /**
256      * The `quantity` minted with ERC2309 exceeds the safety limit.
257      */
258     error MintERC2309QuantityExceedsLimit();
259 
260     /**
261      * The `extraData` cannot be set on an unintialized ownership slot.
262      */
263     error OwnershipNotInitializedForExtraData();
264 
265     // =============================================================
266     //                            STRUCTS
267     // =============================================================
268 
269     struct TokenOwnership {
270         // The address of the owner.
271         address addr;
272         // Stores the start time of ownership with minimal overhead for tokenomics.
273         uint64 startTimestamp;
274         // Whether the token has been burned.
275         bool burned;
276         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
277         uint24 extraData;
278     }
279 
280     // =============================================================
281     //                         TOKEN COUNTERS
282     // =============================================================
283 
284     /**
285      * @dev Returns the total number of tokens in existence.
286      * Burned tokens will reduce the count.
287      * To get the total number of tokens minted, please see {_totalMinted}.
288      */
289     function totalSupply() external view returns (uint256);
290 
291     // =============================================================
292     //                            IERC165
293     // =============================================================
294 
295     /**
296      * @dev Returns true if this contract implements the interface defined by
297      * `interfaceId`. See the corresponding
298      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
299      * to learn more about how these ids are created.
300      *
301      * This function call must use less than 30000 gas.
302      */
303     function supportsInterface(bytes4 interfaceId) external view returns (bool);
304 
305     // =============================================================
306     //                            IERC721
307     // =============================================================
308 
309     /**
310      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
311      */
312     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
313 
314     /**
315      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
316      */
317     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
318 
319     /**
320      * @dev Emitted when `owner` enables or disables
321      * (`approved`) `operator` to manage all of its assets.
322      */
323     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
324 
325     /**
326      * @dev Returns the number of tokens in `owner`'s account.
327      */
328     function balanceOf(address owner) external view returns (uint256 balance);
329 
330     /**
331      * @dev Returns the owner of the `tokenId` token.
332      *
333      * Requirements:
334      *
335      * - `tokenId` must exist.
336      */
337     function ownerOf(uint256 tokenId) external view returns (address owner);
338 
339     /**
340      * @dev Safely transfers `tokenId` token from `from` to `to`,
341      * checking first that contract recipients are aware of the ERC721 protocol
342      * to prevent tokens from being forever locked.
343      *
344      * Requirements:
345      *
346      * - `from` cannot be the zero address.
347      * - `to` cannot be the zero address.
348      * - `tokenId` token must exist and be owned by `from`.
349      * - If the caller is not `from`, it must be have been allowed to move
350      * this token by either {approve} or {setApprovalForAll}.
351      * - If `to` refers to a smart contract, it must implement
352      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
353      *
354      * Emits a {Transfer} event.
355      */
356     function safeTransferFrom(
357         address from,
358         address to,
359         uint256 tokenId,
360         bytes calldata data
361     ) external payable;
362 
363     /**
364      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
365      */
366     function safeTransferFrom(
367         address from,
368         address to,
369         uint256 tokenId
370     ) external payable;
371 
372     /**
373      * @dev Transfers `tokenId` from `from` to `to`.
374      *
375      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
376      * whenever possible.
377      *
378      * Requirements:
379      *
380      * - `from` cannot be the zero address.
381      * - `to` cannot be the zero address.
382      * - `tokenId` token must be owned by `from`.
383      * - If the caller is not `from`, it must be approved to move this token
384      * by either {approve} or {setApprovalForAll}.
385      *
386      * Emits a {Transfer} event.
387      */
388     function transferFrom(
389         address from,
390         address to,
391         uint256 tokenId
392     ) external payable;
393 
394     /**
395      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
396      * The approval is cleared when the token is transferred.
397      *
398      * Only a single account can be approved at a time, so approving the
399      * zero address clears previous approvals.
400      *
401      * Requirements:
402      *
403      * - The caller must own the token or be an approved operator.
404      * - `tokenId` must exist.
405      *
406      * Emits an {Approval} event.
407      */
408     function approve(address to, uint256 tokenId) external payable;
409 
410     /**
411      * @dev Approve or remove `operator` as an operator for the caller.
412      * Operators can call {transferFrom} or {safeTransferFrom}
413      * for any token owned by the caller.
414      *
415      * Requirements:
416      *
417      * - The `operator` cannot be the caller.
418      *
419      * Emits an {ApprovalForAll} event.
420      */
421     function setApprovalForAll(address operator, bool _approved) external;
422 
423     /**
424      * @dev Returns the account approved for `tokenId` token.
425      *
426      * Requirements:
427      *
428      * - `tokenId` must exist.
429      */
430     function getApproved(uint256 tokenId) external view returns (address operator);
431 
432     /**
433      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
434      *
435      * See {setApprovalForAll}.
436      */
437     function isApprovedForAll(address owner, address operator) external view returns (bool);
438 
439     // =============================================================
440     //                        IERC721Metadata
441     // =============================================================
442 
443     /**
444      * @dev Returns the token collection name.
445      */
446     function name() external view returns (string memory);
447 
448     /**
449      * @dev Returns the token collection symbol.
450      */
451     function symbol() external view returns (string memory);
452 
453     /**
454      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
455      */
456     function tokenURI(uint256 tokenId) external view returns (string memory);
457 
458     // =============================================================
459     //                           IERC2309
460     // =============================================================
461 
462     /**
463      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
464      * (inclusive) is transferred from `from` to `to`, as defined in the
465      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
466      *
467      * See {_mintERC2309} for more details.
468      */
469     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
470 }
471 
472 
473 // ERC721A Contracts v4.2.3
474 // Creator: Chiru Labs
475 /**
476  * @dev Interface of ERC721 token receiver.
477  */
478 interface ERC721A__IERC721Receiver {
479     function onERC721Received(
480         address operator,
481         address from,
482         uint256 tokenId,
483         bytes calldata data
484     ) external returns (bytes4);
485 }
486 
487 /**
488  * @title ERC721A
489  *
490  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
491  * Non-Fungible Token Standard, including the Metadata extension.
492  * Optimized for lower gas during batch mints.
493  *
494  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
495  * starting from `_startTokenId()`.
496  *
497  * Assumptions:
498  *
499  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
500  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
501  */
502 contract ERC721A is IERC721A {
503     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
504     struct TokenApprovalRef {
505         address value;
506     }
507 
508     // =============================================================
509     //                           CONSTANTS
510     // =============================================================
511 
512     // Mask of an entry in packed address data.
513     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
514 
515     // The bit position of `numberMinted` in packed address data.
516     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
517 
518     // The bit position of `numberBurned` in packed address data.
519     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
520 
521     // The bit position of `aux` in packed address data.
522     uint256 private constant _BITPOS_AUX = 192;
523 
524     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
525     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
526 
527     // The bit position of `startTimestamp` in packed ownership.
528     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
529 
530     // The bit mask of the `burned` bit in packed ownership.
531     uint256 private constant _BITMASK_BURNED = 1 << 224;
532 
533     // The bit position of the `nextInitialized` bit in packed ownership.
534     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
535 
536     // The bit mask of the `nextInitialized` bit in packed ownership.
537     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
538 
539     // The bit position of `extraData` in packed ownership.
540     uint256 private constant _BITPOS_EXTRA_DATA = 232;
541 
542     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
543     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
544 
545     // The mask of the lower 160 bits for addresses.
546     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
547 
548     // The maximum `quantity` that can be minted with {_mintERC2309}.
549     // This limit is to prevent overflows on the address data entries.
550     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
551     // is required to cause an overflow, which is unrealistic.
552     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
553 
554     // The `Transfer` event signature is given by:
555     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
556     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
557         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
558 
559     // =============================================================
560     //                            STORAGE
561     // =============================================================
562 
563     // The next token ID to be minted.
564     uint256 private _currentIndex;
565 
566     // The number of tokens burned.
567     uint256 private _burnCounter;
568 
569     // Token name
570     string private _name;
571 
572     // Token symbol
573     string private _symbol;
574 
575     // Mapping from token ID to ownership details
576     // An empty struct value does not necessarily mean the token is unowned.
577     // See {_packedOwnershipOf} implementation for details.
578     //
579     // Bits Layout:
580     // - [0..159]   `addr`
581     // - [160..223] `startTimestamp`
582     // - [224]      `burned`
583     // - [225]      `nextInitialized`
584     // - [232..255] `extraData`
585     mapping(uint256 => uint256) private _packedOwnerships;
586 
587     // Mapping owner address to address data.
588     //
589     // Bits Layout:
590     // - [0..63]    `balance`
591     // - [64..127]  `numberMinted`
592     // - [128..191] `numberBurned`
593     // - [192..255] `aux`
594     mapping(address => uint256) private _packedAddressData;
595 
596     // Mapping from token ID to approved address.
597     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
598 
599     // Mapping from owner to operator approvals
600     mapping(address => mapping(address => bool)) private _operatorApprovals;
601 
602     // =============================================================
603     //                          CONSTRUCTOR
604     // =============================================================
605 
606     constructor(string memory name_, string memory symbol_) {
607         _name = name_;
608         _symbol = symbol_;
609         _currentIndex = _startTokenId();
610     }
611 
612     // =============================================================
613     //                   TOKEN COUNTING OPERATIONS
614     // =============================================================
615 
616     /**
617      * @dev Returns the starting token ID.
618      * To change the starting token ID, please override this function.
619      */
620     function _startTokenId() internal view virtual returns (uint256) {
621         return 0;
622     }
623 
624     /**
625      * @dev Returns the next token ID to be minted.
626      */
627     function _nextTokenId() internal view virtual returns (uint256) {
628         return _currentIndex;
629     }
630 
631     /**
632      * @dev Returns the total number of tokens in existence.
633      * Burned tokens will reduce the count.
634      * To get the total number of tokens minted, please see {_totalMinted}.
635      */
636     function totalSupply() public view virtual override returns (uint256) {
637         // Counter underflow is impossible as _burnCounter cannot be incremented
638         // more than `_currentIndex - _startTokenId()` times.
639         unchecked {
640             return _currentIndex - _burnCounter - _startTokenId();
641         }
642     }
643 
644     /**
645      * @dev Returns the total amount of tokens minted in the contract.
646      */
647     function _totalMinted() internal view virtual returns (uint256) {
648         // Counter underflow is impossible as `_currentIndex` does not decrement,
649         // and it is initialized to `_startTokenId()`.
650         unchecked {
651             return _currentIndex - _startTokenId();
652         }
653     }
654 
655     /**
656      * @dev Returns the total number of tokens burned.
657      */
658     function _totalBurned() internal view virtual returns (uint256) {
659         return _burnCounter;
660     }
661 
662     // =============================================================
663     //                    ADDRESS DATA OPERATIONS
664     // =============================================================
665 
666     /**
667      * @dev Returns the number of tokens in `owner`'s account.
668      */
669     function balanceOf(address owner) public view virtual override returns (uint256) {
670         if (owner == address(0)) revert BalanceQueryForZeroAddress();
671         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
672     }
673 
674     /**
675      * Returns the number of tokens minted by `owner`.
676      */
677     function _numberMinted(address owner) internal view returns (uint256) {
678         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
679     }
680 
681     /**
682      * Returns the number of tokens burned by or on behalf of `owner`.
683      */
684     function _numberBurned(address owner) internal view returns (uint256) {
685         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
686     }
687 
688     /**
689      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
690      */
691     function _getAux(address owner) internal view returns (uint64) {
692         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
693     }
694 
695     /**
696      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
697      * If there are multiple variables, please pack them into a uint64.
698      */
699     function _setAux(address owner, uint64 aux) internal virtual {
700         uint256 packed = _packedAddressData[owner];
701         uint256 auxCasted;
702         // Cast `aux` with assembly to avoid redundant masking.
703         assembly {
704             auxCasted := aux
705         }
706         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
707         _packedAddressData[owner] = packed;
708     }
709 
710     // =============================================================
711     //                            IERC165
712     // =============================================================
713 
714     /**
715      * @dev Returns true if this contract implements the interface defined by
716      * `interfaceId`. See the corresponding
717      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
718      * to learn more about how these ids are created.
719      *
720      * This function call must use less than 30000 gas.
721      */
722     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
723         // The interface IDs are constants representing the first 4 bytes
724         // of the XOR of all function selectors in the interface.
725         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
726         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
727         return
728             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
729             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
730             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
731     }
732 
733     // =============================================================
734     //                        IERC721Metadata
735     // =============================================================
736 
737     /**
738      * @dev Returns the token collection name.
739      */
740     function name() public view virtual override returns (string memory) {
741         return _name;
742     }
743 
744     /**
745      * @dev Returns the token collection symbol.
746      */
747     function symbol() public view virtual override returns (string memory) {
748         return _symbol;
749     }
750 
751     /**
752      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
753      */
754     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
755         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
756 
757         string memory baseURI = _baseURI();
758         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
759     }
760 
761     /**
762      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
763      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
764      * by default, it can be overridden in child contracts.
765      */
766     function _baseURI() internal view virtual returns (string memory) {
767         return '';
768     }
769 
770     // =============================================================
771     //                     OWNERSHIPS OPERATIONS
772     // =============================================================
773 
774     /**
775      * @dev Returns the owner of the `tokenId` token.
776      *
777      * Requirements:
778      *
779      * - `tokenId` must exist.
780      */
781     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
782         return address(uint160(_packedOwnershipOf(tokenId)));
783     }
784 
785     /**
786      * @dev Gas spent here starts off proportional to the maximum mint batch size.
787      * It gradually moves to O(1) as tokens get transferred around over time.
788      */
789     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
790         return _unpackedOwnership(_packedOwnershipOf(tokenId));
791     }
792 
793     /**
794      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
795      */
796     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
797         return _unpackedOwnership(_packedOwnerships[index]);
798     }
799 
800     /**
801      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
802      */
803     function _initializeOwnershipAt(uint256 index) internal virtual {
804         if (_packedOwnerships[index] == 0) {
805             _packedOwnerships[index] = _packedOwnershipOf(index);
806         }
807     }
808 
809     /**
810      * Returns the packed ownership data of `tokenId`.
811      */
812     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256 packed) {
813         if (_startTokenId() <= tokenId) {
814             packed = _packedOwnerships[tokenId];
815             // If not burned.
816             if (packed & _BITMASK_BURNED == 0) {
817                 // If the data at the starting slot does not exist, start the scan.
818                 if (packed == 0) {
819                     if (tokenId >= _currentIndex) revert OwnerQueryForNonexistentToken();
820                     // Invariant:
821                     // There will always be an initialized ownership slot
822                     // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
823                     // before an unintialized ownership slot
824                     // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
825                     // Hence, `tokenId` will not underflow.
826                     //
827                     // We can directly compare the packed value.
828                     // If the address is zero, packed will be zero.
829                     for (;;) {
830                         unchecked {
831                             packed = _packedOwnerships[--tokenId];
832                         }
833                         if (packed == 0) continue;
834                         return packed;
835                     }
836                 }
837                 // Otherwise, the data exists and is not burned. We can skip the scan.
838                 // This is possible because we have already achieved the target condition.
839                 // This saves 2143 gas on transfers of initialized tokens.
840                 return packed;
841             }
842         }
843         revert OwnerQueryForNonexistentToken();
844     }
845 
846     /**
847      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
848      */
849     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
850         ownership.addr = address(uint160(packed));
851         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
852         ownership.burned = packed & _BITMASK_BURNED != 0;
853         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
854     }
855 
856     /**
857      * @dev Packs ownership data into a single uint256.
858      */
859     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
860         assembly {
861             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
862             owner := and(owner, _BITMASK_ADDRESS)
863             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
864             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
865         }
866     }
867 
868     /**
869      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
870      */
871     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
872         // For branchless setting of the `nextInitialized` flag.
873         assembly {
874             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
875             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
876         }
877     }
878 
879     // =============================================================
880     //                      APPROVAL OPERATIONS
881     // =============================================================
882 
883     /**
884      * @dev Gives permission to `to` to transfer `tokenId` token to another account. See {ERC721A-_approve}.
885      *
886      * Requirements:
887      *
888      * - The caller must own the token or be an approved operator.
889      */
890     function approve(address to, uint256 tokenId) public payable virtual override {
891         _approve(to, tokenId, true);
892     }
893 
894     /**
895      * @dev Returns the account approved for `tokenId` token.
896      *
897      * Requirements:
898      *
899      * - `tokenId` must exist.
900      */
901     function getApproved(uint256 tokenId) public view virtual override returns (address) {
902         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
903 
904         return _tokenApprovals[tokenId].value;
905     }
906 
907     /**
908      * @dev Approve or remove `operator` as an operator for the caller.
909      * Operators can call {transferFrom} or {safeTransferFrom}
910      * for any token owned by the caller.
911      *
912      * Requirements:
913      *
914      * - The `operator` cannot be the caller.
915      *
916      * Emits an {ApprovalForAll} event.
917      */
918     function setApprovalForAll(address operator, bool approved) public virtual override {
919         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
920         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
921     }
922 
923     /**
924      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
925      *
926      * See {setApprovalForAll}.
927      */
928     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
929         return _operatorApprovals[owner][operator];
930     }
931 
932     /**
933      * @dev Returns whether `tokenId` exists.
934      *
935      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
936      *
937      * Tokens start existing when they are minted. See {_mint}.
938      */
939     function _exists(uint256 tokenId) internal view virtual returns (bool) {
940         return
941             _startTokenId() <= tokenId &&
942             tokenId < _currentIndex && // If within bounds,
943             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
944     }
945 
946     /**
947      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
948      */
949     function _isSenderApprovedOrOwner(
950         address approvedAddress,
951         address owner,
952         address msgSender
953     ) private pure returns (bool result) {
954         assembly {
955             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
956             owner := and(owner, _BITMASK_ADDRESS)
957             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
958             msgSender := and(msgSender, _BITMASK_ADDRESS)
959             // `msgSender == owner || msgSender == approvedAddress`.
960             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
961         }
962     }
963 
964     /**
965      * @dev Returns the storage slot and value for the approved address of `tokenId`.
966      */
967     function _getApprovedSlotAndAddress(uint256 tokenId)
968         private
969         view
970         returns (uint256 approvedAddressSlot, address approvedAddress)
971     {
972         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
973         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
974         assembly {
975             approvedAddressSlot := tokenApproval.slot
976             approvedAddress := sload(approvedAddressSlot)
977         }
978     }
979 
980     function tokensOfOwner(address owner) external view virtual returns (uint256[] memory) {
981         uint256 tokenIdsLength = balanceOf(owner);
982         uint256[] memory tokenIds;
983         assembly {
984             // Grab the free memory pointer.
985             tokenIds := mload(0x40)
986             // Allocate one word for the length, and `tokenIdsMaxLength` words
987             // for the data. `shl(5, x)` is equivalent to `mul(32, x)`.
988             mstore(0x40, add(tokenIds, shl(5, add(tokenIdsLength, 1))))
989             // Store the length of `tokenIds`.
990             mstore(tokenIds, tokenIdsLength)
991         }
992         address currOwnershipAddr;
993         uint256 tokenIdsIdx;
994         for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ) {
995             TokenOwnership memory ownership = _ownershipAt(i);
996             assembly {
997                 // if `ownership.burned == false`.
998                 if iszero(mload(add(ownership, 0x40))) {
999                     // if `ownership.addr != address(0)`.
1000                     // The `addr` already has it's upper 96 bits clearned,
1001                     // since it is written to memory with regular Solidity.
1002                     if mload(ownership) {
1003                         currOwnershipAddr := mload(ownership)
1004                     }
1005                     // if `currOwnershipAddr == owner`.
1006                     // The `shl(96, x)` is to make the comparison agnostic to any
1007                     // dirty upper 96 bits in `owner`.
1008                     if iszero(shl(96, xor(currOwnershipAddr, owner))) {
1009                         tokenIdsIdx := add(tokenIdsIdx, 1)
1010                         mstore(add(tokenIds, shl(5, tokenIdsIdx)), i)
1011                     }
1012                 }
1013                 i := add(i, 1)
1014             }
1015         }
1016         return tokenIds;
1017     }
1018 
1019     // =============================================================
1020     //                      TRANSFER OPERATIONS
1021     // =============================================================
1022 
1023     /**
1024      * @dev Transfers `tokenId` from `from` to `to`.
1025      *
1026      * Requirements:
1027      *
1028      * - `from` cannot be the zero address.
1029      * - `to` cannot be the zero address.
1030      * - `tokenId` token must be owned by `from`.
1031      * - If the caller is not `from`, it must be approved to move this token
1032      * by either {approve} or {setApprovalForAll}.
1033      *
1034      * Emits a {Transfer} event.
1035      */
1036     function transferFrom(
1037         address from,
1038         address to,
1039         uint256 tokenId
1040     ) public payable virtual override {
1041         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1042 
1043         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1044 
1045         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1046 
1047         // The nested ifs save around 20+ gas over a compound boolean condition.
1048         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1049             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1050 
1051         if (to == address(0)) revert TransferToZeroAddress();
1052 
1053         _beforeTokenTransfers(from, to, tokenId, 1);
1054 
1055         // Clear approvals from the previous owner.
1056         assembly {
1057             if approvedAddress {
1058                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1059                 sstore(approvedAddressSlot, 0)
1060             }
1061         }
1062 
1063         // Underflow of the sender's balance is impossible because we check for
1064         // ownership above and the recipient's balance can't realistically overflow.
1065         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1066         unchecked {
1067             // We can directly increment and decrement the balances.
1068             --_packedAddressData[from]; // Updates: `balance -= 1`.
1069             ++_packedAddressData[to]; // Updates: `balance += 1`.
1070 
1071             // Updates:
1072             // - `address` to the next owner.
1073             // - `startTimestamp` to the timestamp of transfering.
1074             // - `burned` to `false`.
1075             // - `nextInitialized` to `true`.
1076             _packedOwnerships[tokenId] = _packOwnershipData(
1077                 to,
1078                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1079             );
1080 
1081             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1082             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1083                 uint256 nextTokenId = tokenId + 1;
1084                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1085                 if (_packedOwnerships[nextTokenId] == 0) {
1086                     // If the next slot is within bounds.
1087                     if (nextTokenId != _currentIndex) {
1088                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1089                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1090                     }
1091                 }
1092             }
1093         }
1094 
1095         emit Transfer(from, to, tokenId);
1096         _afterTokenTransfers(from, to, tokenId, 1);
1097     }
1098 
1099     /**
1100      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1101      */
1102     function safeTransferFrom(
1103         address from,
1104         address to,
1105         uint256 tokenId
1106     ) public payable virtual override {
1107         safeTransferFrom(from, to, tokenId, '');
1108     }
1109 
1110     /**
1111      * @dev Safely transfers `tokenId` token from `from` to `to`.
1112      *
1113      * Requirements:
1114      *
1115      * - `from` cannot be the zero address.
1116      * - `to` cannot be the zero address.
1117      * - `tokenId` token must exist and be owned by `from`.
1118      * - If the caller is not `from`, it must be approved to move this token
1119      * by either {approve} or {setApprovalForAll}.
1120      * - If `to` refers to a smart contract, it must implement
1121      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1122      *
1123      * Emits a {Transfer} event.
1124      */
1125     function safeTransferFrom(
1126         address from,
1127         address to,
1128         uint256 tokenId,
1129         bytes memory _data
1130     ) public payable virtual override {
1131         transferFrom(from, to, tokenId);
1132         if (to.code.length != 0)
1133             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1134                 revert TransferToNonERC721ReceiverImplementer();
1135             }
1136     }
1137 
1138     /**
1139      * @dev Hook that is called before a set of serially-ordered token IDs
1140      * are about to be transferred. This includes minting.
1141      * And also called before burning one token.
1142      *
1143      * `startTokenId` - the first token ID to be transferred.
1144      * `quantity` - the amount to be transferred.
1145      *
1146      * Calling conditions:
1147      *
1148      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1149      * transferred to `to`.
1150      * - When `from` is zero, `tokenId` will be minted for `to`.
1151      * - When `to` is zero, `tokenId` will be burned by `from`.
1152      * - `from` and `to` are never both zero.
1153      */
1154     function _beforeTokenTransfers(
1155         address from,
1156         address to,
1157         uint256 startTokenId,
1158         uint256 quantity
1159     ) internal virtual {}
1160 
1161     /**
1162      * @dev Hook that is called after a set of serially-ordered token IDs
1163      * have been transferred. This includes minting.
1164      * And also called after one token has been burned.
1165      *
1166      * `startTokenId` - the first token ID to be transferred.
1167      * `quantity` - the amount to be transferred.
1168      *
1169      * Calling conditions:
1170      *
1171      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1172      * transferred to `to`.
1173      * - When `from` is zero, `tokenId` has been minted for `to`.
1174      * - When `to` is zero, `tokenId` has been burned by `from`.
1175      * - `from` and `to` are never both zero.
1176      */
1177     function _afterTokenTransfers(
1178         address from,
1179         address to,
1180         uint256 startTokenId,
1181         uint256 quantity
1182     ) internal virtual {}
1183 
1184     /**
1185      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1186      *
1187      * `from` - Previous owner of the given token ID.
1188      * `to` - Target address that will receive the token.
1189      * `tokenId` - Token ID to be transferred.
1190      * `_data` - Optional data to send along with the call.
1191      *
1192      * Returns whether the call correctly returned the expected magic value.
1193      */
1194     function _checkContractOnERC721Received(
1195         address from,
1196         address to,
1197         uint256 tokenId,
1198         bytes memory _data
1199     ) private returns (bool) {
1200         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1201             bytes4 retval
1202         ) {
1203             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1204         } catch (bytes memory reason) {
1205             if (reason.length == 0) {
1206                 revert TransferToNonERC721ReceiverImplementer();
1207             } else {
1208                 assembly {
1209                     revert(add(32, reason), mload(reason))
1210                 }
1211             }
1212         }
1213     }
1214 
1215     // =============================================================
1216     //                        MINT OPERATIONS
1217     // =============================================================
1218 
1219     /**
1220      * @dev Mints `quantity` tokens and transfers them to `to`.
1221      *
1222      * Requirements:
1223      *
1224      * - `to` cannot be the zero address.
1225      * - `quantity` must be greater than 0.
1226      *
1227      * Emits a {Transfer} event for each mint.
1228      */
1229     function _mint(address to, uint256 quantity) internal virtual {
1230         uint256 startTokenId = _currentIndex;
1231         if (quantity == 0) revert MintZeroQuantity();
1232 
1233         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1234 
1235         // Overflows are incredibly unrealistic.
1236         // `balance` and `numberMinted` have a maximum limit of 2**64.
1237         // `tokenId` has a maximum limit of 2**256.
1238         unchecked {
1239             // Updates:
1240             // - `balance += quantity`.
1241             // - `numberMinted += quantity`.
1242             //
1243             // We can directly add to the `balance` and `numberMinted`.
1244             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1245 
1246             // Updates:
1247             // - `address` to the owner.
1248             // - `startTimestamp` to the timestamp of minting.
1249             // - `burned` to `false`.
1250             // - `nextInitialized` to `quantity == 1`.
1251             _packedOwnerships[startTokenId] = _packOwnershipData(
1252                 to,
1253                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1254             );
1255 
1256             uint256 toMasked;
1257             uint256 end = startTokenId + quantity;
1258 
1259             // Use assembly to loop and emit the `Transfer` event for gas savings.
1260             // The duplicated `log4` removes an extra check and reduces stack juggling.
1261             // The assembly, together with the surrounding Solidity code, have been
1262             // delicately arranged to nudge the compiler into producing optimized opcodes.
1263             assembly {
1264                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1265                 toMasked := and(to, _BITMASK_ADDRESS)
1266                 // Emit the `Transfer` event.
1267                 log4(
1268                     0, // Start of data (0, since no data).
1269                     0, // End of data (0, since no data).
1270                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1271                     0, // `address(0)`.
1272                     toMasked, // `to`.
1273                     startTokenId // `tokenId`.
1274                 )
1275 
1276                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1277                 // that overflows uint256 will make the loop run out of gas.
1278                 // The compiler will optimize the `iszero` away for performance.
1279                 for {
1280                     let tokenId := add(startTokenId, 1)
1281                 } iszero(eq(tokenId, end)) {
1282                     tokenId := add(tokenId, 1)
1283                 } {
1284                     // Emit the `Transfer` event. Similar to above.
1285                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1286                 }
1287             }
1288             if (toMasked == 0) revert MintToZeroAddress();
1289 
1290             _currentIndex = end;
1291         }
1292         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1293     }
1294 
1295     /**
1296      * @dev Mints `quantity` tokens and transfers them to `to`.
1297      *
1298      * This function is intended for efficient minting only during contract creation.
1299      *
1300      * It emits only one {ConsecutiveTransfer} as defined in
1301      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1302      * instead of a sequence of {Transfer} event(s).
1303      *
1304      * Calling this function outside of contract creation WILL make your contract
1305      * non-compliant with the ERC721 standard.
1306      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1307      * {ConsecutiveTransfer} event is only permissible during contract creation.
1308      *
1309      * Requirements:
1310      *
1311      * - `to` cannot be the zero address.
1312      * - `quantity` must be greater than 0.
1313      *
1314      * Emits a {ConsecutiveTransfer} event.
1315      */
1316     function _mintERC2309(address to, uint256 quantity) internal virtual {
1317         uint256 startTokenId = _currentIndex;
1318         if (to == address(0)) revert MintToZeroAddress();
1319         if (quantity == 0) revert MintZeroQuantity();
1320         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1321 
1322         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1323 
1324         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1325         unchecked {
1326             // Updates:
1327             // - `balance += quantity`.
1328             // - `numberMinted += quantity`.
1329             //
1330             // We can directly add to the `balance` and `numberMinted`.
1331             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1332 
1333             // Updates:
1334             // - `address` to the owner.
1335             // - `startTimestamp` to the timestamp of minting.
1336             // - `burned` to `false`.
1337             // - `nextInitialized` to `quantity == 1`.
1338             _packedOwnerships[startTokenId] = _packOwnershipData(
1339                 to,
1340                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1341             );
1342 
1343             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1344 
1345             _currentIndex = startTokenId + quantity;
1346         }
1347         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1348     }
1349 
1350     /**
1351      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1352      *
1353      * Requirements:
1354      *
1355      * - If `to` refers to a smart contract, it must implement
1356      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1357      * - `quantity` must be greater than 0.
1358      *
1359      * See {_mint}.
1360      *
1361      * Emits a {Transfer} event for each mint.
1362      */
1363     function _safeMint(
1364         address to,
1365         uint256 quantity,
1366         bytes memory _data
1367     ) internal virtual {
1368         _mint(to, quantity);
1369 
1370         unchecked {
1371             if (to.code.length != 0) {
1372                 uint256 end = _currentIndex;
1373                 uint256 index = end - quantity;
1374                 do {
1375                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1376                         revert TransferToNonERC721ReceiverImplementer();
1377                     }
1378                 } while (index < end);
1379                 // Reentrancy protection.
1380                 if (_currentIndex != end) revert();
1381             }
1382         }
1383     }
1384 
1385     /**
1386      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1387      */
1388     function _safeMint(address to, uint256 quantity) internal virtual {
1389         _safeMint(to, quantity, '');
1390     }
1391 
1392     // =============================================================
1393     //                       APPROVAL OPERATIONS
1394     // =============================================================
1395 
1396     /**
1397      * @dev Equivalent to `_approve(to, tokenId, false)`.
1398      */
1399     function _approve(address to, uint256 tokenId) internal virtual {
1400         _approve(to, tokenId, false);
1401     }
1402 
1403     /**
1404      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1405      * The approval is cleared when the token is transferred.
1406      *
1407      * Only a single account can be approved at a time, so approving the
1408      * zero address clears previous approvals.
1409      *
1410      * Requirements:
1411      *
1412      * - `tokenId` must exist.
1413      *
1414      * Emits an {Approval} event.
1415      */
1416     function _approve(
1417         address to,
1418         uint256 tokenId,
1419         bool approvalCheck
1420     ) internal virtual {
1421         address owner = ownerOf(tokenId);
1422 
1423         if (approvalCheck)
1424             if (_msgSenderERC721A() != owner)
1425                 if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1426                     revert ApprovalCallerNotOwnerNorApproved();
1427                 }
1428 
1429         _tokenApprovals[tokenId].value = to;
1430         emit Approval(owner, to, tokenId);
1431     }
1432 
1433     // =============================================================
1434     //                        BURN OPERATIONS
1435     // =============================================================
1436 
1437     /**
1438      * @dev Equivalent to `_burn(tokenId, false)`.
1439      */
1440     function _burn(uint256 tokenId) internal virtual {
1441         _burn(tokenId, false);
1442     }
1443 
1444     /**
1445      * @dev Destroys `tokenId`.
1446      * The approval is cleared when the token is burned.
1447      *
1448      * Requirements:
1449      *
1450      * - `tokenId` must exist.
1451      *
1452      * Emits a {Transfer} event.
1453      */
1454     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1455         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1456 
1457         address from = address(uint160(prevOwnershipPacked));
1458 
1459         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1460 
1461         if (approvalCheck) {
1462             // The nested ifs save around 20+ gas over a compound boolean condition.
1463             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1464                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1465         }
1466 
1467         _beforeTokenTransfers(from, address(0), tokenId, 1);
1468 
1469         // Clear approvals from the previous owner.
1470         assembly {
1471             if approvedAddress {
1472                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1473                 sstore(approvedAddressSlot, 0)
1474             }
1475         }
1476 
1477         // Underflow of the sender's balance is impossible because we check for
1478         // ownership above and the recipient's balance can't realistically overflow.
1479         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1480         unchecked {
1481             // Updates:
1482             // - `balance -= 1`.
1483             // - `numberBurned += 1`.
1484             //
1485             // We can directly decrement the balance, and increment the number burned.
1486             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1487             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1488 
1489             // Updates:
1490             // - `address` to the last owner.
1491             // - `startTimestamp` to the timestamp of burning.
1492             // - `burned` to `true`.
1493             // - `nextInitialized` to `true`.
1494             _packedOwnerships[tokenId] = _packOwnershipData(
1495                 from,
1496                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1497             );
1498 
1499             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1500             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1501                 uint256 nextTokenId = tokenId + 1;
1502                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1503                 if (_packedOwnerships[nextTokenId] == 0) {
1504                     // If the next slot is within bounds.
1505                     if (nextTokenId != _currentIndex) {
1506                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1507                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1508                     }
1509                 }
1510             }
1511         }
1512 
1513         emit Transfer(from, address(0), tokenId);
1514         _afterTokenTransfers(from, address(0), tokenId, 1);
1515 
1516         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1517         unchecked {
1518             _burnCounter++;
1519         }
1520     }
1521 
1522     // =============================================================
1523     //                     EXTRA DATA OPERATIONS
1524     // =============================================================
1525 
1526     /**
1527      * @dev Directly sets the extra data for the ownership data `index`.
1528      */
1529     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1530         uint256 packed = _packedOwnerships[index];
1531         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1532         uint256 extraDataCasted;
1533         // Cast `extraData` with assembly to avoid redundant masking.
1534         assembly {
1535             extraDataCasted := extraData
1536         }
1537         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1538         _packedOwnerships[index] = packed;
1539     }
1540 
1541     /**
1542      * @dev Called during each token transfer to set the 24bit `extraData` field.
1543      * Intended to be overridden by the cosumer contract.
1544      *
1545      * `previousExtraData` - the value of `extraData` before transfer.
1546      *
1547      * Calling conditions:
1548      *
1549      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1550      * transferred to `to`.
1551      * - When `from` is zero, `tokenId` will be minted for `to`.
1552      * - When `to` is zero, `tokenId` will be burned by `from`.
1553      * - `from` and `to` are never both zero.
1554      */
1555     function _extraData(
1556         address from,
1557         address to,
1558         uint24 previousExtraData
1559     ) internal view virtual returns (uint24) {}
1560 
1561     /**
1562      * @dev Returns the next extra data for the packed ownership data.
1563      * The returned result is shifted into position.
1564      */
1565     function _nextExtraData(
1566         address from,
1567         address to,
1568         uint256 prevOwnershipPacked
1569     ) private view returns (uint256) {
1570         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1571         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1572     }
1573 
1574     // =============================================================
1575     //                       OTHER OPERATIONS
1576     // =============================================================
1577 
1578     /**
1579      * @dev Returns the message sender (defaults to `msg.sender`).
1580      *
1581      * If you are writing GSN compatible contracts, you need to override this function.
1582      */
1583     function _msgSenderERC721A() internal view virtual returns (address) {
1584         return msg.sender;
1585     }
1586 
1587     /**
1588      * @dev Converts a uint256 to its ASCII string decimal representation.
1589      */
1590     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1591         assembly {
1592             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1593             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1594             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1595             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1596             let m := add(mload(0x40), 0xa0)
1597             // Update the free memory pointer to allocate.
1598             mstore(0x40, m)
1599             // Assign the `str` to the end.
1600             str := sub(m, 0x20)
1601             // Zeroize the slot after the string.
1602             mstore(str, 0)
1603 
1604             // Cache the end of the memory to calculate the length later.
1605             let end := str
1606 
1607             // We write the string from rightmost digit to leftmost digit.
1608             // The following is essentially a do-while loop that also handles the zero case.
1609             // prettier-ignore
1610             for { let temp := value } 1 {} {
1611                 str := sub(str, 1)
1612                 // Write the character to the pointer.
1613                 // The ASCII index of the '0' character is 48.
1614                 mstore8(str, add(48, mod(temp, 10)))
1615                 // Keep dividing `temp` until zero.
1616                 temp := div(temp, 10)
1617                 // prettier-ignore
1618                 if iszero(temp) { break }
1619             }
1620 
1621             let length := sub(end, str)
1622             // Move the pointer 32 bytes leftwards to make room for the length.
1623             str := sub(str, 0x20)
1624             // Store the length.
1625             mstore(str, length)
1626         }
1627     }
1628 }
1629 
1630 
1631 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1632 /**
1633  * @dev Contract module which provides a basic access control mechanism, where
1634  * there is an account (an owner) that can be granted exclusive access to
1635  * specific functions.
1636  *
1637  * By default, the owner account will be the one that deploys the contract. This
1638  * can later be changed with {transferOwnership}.
1639  *
1640  * This module is used through inheritance. It will make available the modifier
1641  * `onlyOwner`, which can be applied to your functions to restrict their use to
1642  * the owner.
1643  */
1644 abstract contract Ownable is Context {
1645     address private _owner;
1646 
1647     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1648 
1649     /**
1650      * @dev Initializes the contract setting the deployer as the initial owner.
1651      */
1652     constructor() {
1653         _transferOwnership(_msgSender());
1654     }
1655 
1656     /**
1657      * @dev Throws if called by any account other than the owner.
1658      */
1659     modifier onlyOwner() {
1660         _checkOwner();
1661         _;
1662     }
1663 
1664     /**
1665      * @dev Returns the address of the current owner.
1666      */
1667     function owner() public view virtual returns (address) {
1668         return _owner;
1669     }
1670 
1671     /**
1672      * @dev Throws if the sender is not the owner.
1673      */
1674     function _checkOwner() internal view virtual {
1675         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1676     }
1677 
1678     /**
1679      * @dev Leaves the contract without owner. It will not be possible to call
1680      * `onlyOwner` functions anymore. Can only be called by the current owner.
1681      *
1682      * NOTE: Renouncing ownership will leave the contract without an owner,
1683      * thereby removing any functionality that is only available to the owner.
1684      */
1685     function renounceOwnership() public virtual onlyOwner {
1686         _transferOwnership(address(0));
1687     }
1688 
1689     /**
1690      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1691      * Can only be called by the current owner.
1692      */
1693     function transferOwnership(address newOwner) public virtual onlyOwner {
1694         require(newOwner != address(0), "Ownable: new owner is the zero address");
1695         _transferOwnership(newOwner);
1696     }
1697 
1698     /**
1699      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1700      * Internal function without access restriction.
1701      */
1702     function _transferOwnership(address newOwner) internal virtual {
1703         address oldOwner = _owner;
1704         _owner = newOwner;
1705         emit OwnershipTransferred(oldOwner, newOwner);
1706     }
1707 }
1708 
1709 
1710 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/MerkleProof.sol)
1711 /**
1712  * @dev These functions deal with verification of Merkle Tree proofs.
1713  *
1714  * The tree and the proofs can be generated using our
1715  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
1716  * You will find a quickstart guide in the readme.
1717  *
1718  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1719  * hashing, or use a hash function other than keccak256 for hashing leaves.
1720  * This is because the concatenation of a sorted pair of internal nodes in
1721  * the merkle tree could be reinterpreted as a leaf value.
1722  * OpenZeppelin's JavaScript library generates merkle trees that are safe
1723  * against this attack out of the box.
1724  */
1725 library MerkleProof {
1726     /**
1727      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1728      * defined by `root`. For this, a `proof` must be provided, containing
1729      * sibling hashes on the branch from the leaf to the root of the tree. Each
1730      * pair of leaves and each pair of pre-images are assumed to be sorted.
1731      */
1732     function verify(
1733         bytes32[] memory proof,
1734         bytes32 root,
1735         bytes32 leaf
1736     ) internal pure returns (bool) {
1737         return processProof(proof, leaf) == root;
1738     }
1739 
1740     /**
1741      * @dev Calldata version of {verify}
1742      *
1743      * _Available since v4.7._
1744      */
1745     function verifyCalldata(
1746         bytes32[] calldata proof,
1747         bytes32 root,
1748         bytes32 leaf
1749     ) internal pure returns (bool) {
1750         return processProofCalldata(proof, leaf) == root;
1751     }
1752 
1753     /**
1754      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1755      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1756      * hash matches the root of the tree. When processing the proof, the pairs
1757      * of leafs & pre-images are assumed to be sorted.
1758      *
1759      * _Available since v4.4._
1760      */
1761     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1762         bytes32 computedHash = leaf;
1763         for (uint256 i = 0; i < proof.length; i++) {
1764             computedHash = _hashPair(computedHash, proof[i]);
1765         }
1766         return computedHash;
1767     }
1768 
1769     /**
1770      * @dev Calldata version of {processProof}
1771      *
1772      * _Available since v4.7._
1773      */
1774     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
1775         bytes32 computedHash = leaf;
1776         for (uint256 i = 0; i < proof.length; i++) {
1777             computedHash = _hashPair(computedHash, proof[i]);
1778         }
1779         return computedHash;
1780     }
1781 
1782     /**
1783      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
1784      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
1785      *
1786      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
1787      *
1788      * _Available since v4.7._
1789      */
1790     function multiProofVerify(
1791         bytes32[] memory proof,
1792         bool[] memory proofFlags,
1793         bytes32 root,
1794         bytes32[] memory leaves
1795     ) internal pure returns (bool) {
1796         return processMultiProof(proof, proofFlags, leaves) == root;
1797     }
1798 
1799     /**
1800      * @dev Calldata version of {multiProofVerify}
1801      *
1802      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
1803      *
1804      * _Available since v4.7._
1805      */
1806     function multiProofVerifyCalldata(
1807         bytes32[] calldata proof,
1808         bool[] calldata proofFlags,
1809         bytes32 root,
1810         bytes32[] memory leaves
1811     ) internal pure returns (bool) {
1812         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
1813     }
1814 
1815     /**
1816      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
1817      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
1818      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
1819      * respectively.
1820      *
1821      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
1822      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
1823      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
1824      *
1825      * _Available since v4.7._
1826      */
1827     function processMultiProof(
1828         bytes32[] memory proof,
1829         bool[] memory proofFlags,
1830         bytes32[] memory leaves
1831     ) internal pure returns (bytes32 merkleRoot) {
1832         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1833         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1834         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1835         // the merkle tree.
1836         uint256 leavesLen = leaves.length;
1837         uint256 totalHashes = proofFlags.length;
1838 
1839         // Check proof validity.
1840         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1841 
1842         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1843         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1844         bytes32[] memory hashes = new bytes32[](totalHashes);
1845         uint256 leafPos = 0;
1846         uint256 hashPos = 0;
1847         uint256 proofPos = 0;
1848         // At each step, we compute the next hash using two values:
1849         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1850         //   get the next hash.
1851         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1852         //   `proof` array.
1853         for (uint256 i = 0; i < totalHashes; i++) {
1854             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1855             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1856             hashes[i] = _hashPair(a, b);
1857         }
1858 
1859         if (totalHashes > 0) {
1860             return hashes[totalHashes - 1];
1861         } else if (leavesLen > 0) {
1862             return leaves[0];
1863         } else {
1864             return proof[0];
1865         }
1866     }
1867 
1868     /**
1869      * @dev Calldata version of {processMultiProof}.
1870      *
1871      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
1872      *
1873      * _Available since v4.7._
1874      */
1875     function processMultiProofCalldata(
1876         bytes32[] calldata proof,
1877         bool[] calldata proofFlags,
1878         bytes32[] memory leaves
1879     ) internal pure returns (bytes32 merkleRoot) {
1880         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1881         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1882         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1883         // the merkle tree.
1884         uint256 leavesLen = leaves.length;
1885         uint256 totalHashes = proofFlags.length;
1886 
1887         // Check proof validity.
1888         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1889 
1890         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1891         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1892         bytes32[] memory hashes = new bytes32[](totalHashes);
1893         uint256 leafPos = 0;
1894         uint256 hashPos = 0;
1895         uint256 proofPos = 0;
1896         // At each step, we compute the next hash using two values:
1897         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1898         //   get the next hash.
1899         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1900         //   `proof` array.
1901         for (uint256 i = 0; i < totalHashes; i++) {
1902             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1903             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1904             hashes[i] = _hashPair(a, b);
1905         }
1906 
1907         if (totalHashes > 0) {
1908             return hashes[totalHashes - 1];
1909         } else if (leavesLen > 0) {
1910             return leaves[0];
1911         } else {
1912             return proof[0];
1913         }
1914     }
1915 
1916     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
1917         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
1918     }
1919 
1920     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1921         /// @solidity memory-safe-assembly
1922         assembly {
1923             mstore(0x00, a)
1924             mstore(0x20, b)
1925             value := keccak256(0x00, 0x40)
1926         }
1927     }
1928 }
1929 
1930 
1931 abstract contract GuaranteelistMerkle is Ownable {
1932     bytes32 public guaranteelistMerkleRoot;
1933 
1934     /* @notice constructor
1935        @param _premiumWhitelistMerkleRoot the root of the premium whitelist merkle tree
1936        @param _standardWhitelistMerkleRoot the root of the standard whitelist merkle tree
1937        */
1938     constructor(bytes32 _guaranteelistMerkleRoot) {
1939         guaranteelistMerkleRoot = _guaranteelistMerkleRoot;
1940     }
1941 
1942     /* @notice set the premium whitelist merkle root
1943        @dev If the merkle root is changed, the whitelist is reset
1944        @param _merkleRoot the root of the merkle tree
1945        */
1946     function setguaranteelistMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
1947         guaranteelistMerkleRoot = _merkleRoot;
1948     }
1949 
1950     function _isguaranteeListed(address _account, bytes32[] calldata _merkleProof)
1951     internal
1952     view
1953     returns (bool)
1954     {
1955         return
1956         MerkleProof.verify(
1957             _merkleProof,
1958             guaranteelistMerkleRoot,
1959             keccak256(abi.encodePacked(_account))
1960         );
1961     }
1962 
1963     /* @notice Check if an account is premium whitelisted
1964        @dev verifies the merkle proof
1965        @param _account the account to check if it is whitelisted
1966        @param _merkleProof the merkle proof of for the whitelist
1967        @return true if the account is whitelisted
1968        */
1969     function isguaranteeListed(address _account, bytes32[] calldata _merkleProof)
1970     external
1971     view
1972     returns (bool)
1973     {
1974         return _isguaranteeListed(_account, _merkleProof);
1975     }
1976 }
1977 
1978 interface IOperatorFilterRegistry {
1979     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1980     function register(address registrant) external;
1981     function registerAndSubscribe(address registrant, address subscription) external;
1982     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1983     function unregister(address addr) external;
1984     function updateOperator(address registrant, address operator, bool filtered) external;
1985     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1986     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1987     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1988     function subscribe(address registrant, address registrantToSubscribe) external;
1989     function unsubscribe(address registrant, bool copyExistingEntries) external;
1990     function subscriptionOf(address addr) external returns (address registrant);
1991     function subscribers(address registrant) external returns (address[] memory);
1992     function subscriberAt(address registrant, uint256 index) external returns (address);
1993     function copyEntriesOf(address registrant, address registrantToCopy) external;
1994     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1995     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1996     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1997     function filteredOperators(address addr) external returns (address[] memory);
1998     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1999     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
2000     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
2001     function isRegistered(address addr) external returns (bool);
2002     function codeHashOf(address addr) external returns (bytes32);
2003 }
2004 
2005 abstract contract OperatorFilterer {
2006     error OperatorNotAllowed(address operator);
2007 
2008     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
2009         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
2010 
2011     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
2012         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
2013         // will not revert, but the contract will need to be registered with the registry once it is deployed in
2014         // order for the modifier to filter addresses.
2015         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
2016             if (subscribe) {
2017                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
2018             } else {
2019                 if (subscriptionOrRegistrantToCopy != address(0)) {
2020                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
2021                 } else {
2022                     OPERATOR_FILTER_REGISTRY.register(address(this));
2023                 }
2024             }
2025         }
2026     }
2027 
2028     modifier onlyAllowedOperator(address from) virtual {
2029         // Check registry code length to facilitate testing in environments without a deployed registry.
2030         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
2031             // Allow spending tokens from addresses with balance
2032             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
2033             // from an EOA.
2034             if (from == msg.sender) {
2035                 _;
2036                 return;
2037             }
2038             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), msg.sender)) {
2039                 revert OperatorNotAllowed(msg.sender);
2040             }
2041         }
2042         _;
2043     }
2044 
2045     modifier onlyAllowedOperatorApproval(address operator) virtual {
2046         // Check registry code length to facilitate testing in environments without a deployed registry.
2047         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
2048             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
2049                 revert OperatorNotAllowed(operator);
2050             }
2051         }
2052         _;
2053     }
2054 }
2055 
2056 
2057 /**
2058  * @title  DefaultOperatorFilterer
2059  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
2060  */
2061 abstract contract DefaultOperatorFilterer is OperatorFilterer {
2062     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
2063 
2064     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
2065 }
2066 
2067 
2068 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
2069 /**
2070  * @dev Interface of the ERC165 standard, as defined in the
2071  * https://eips.ethereum.org/EIPS/eip-165[EIP].
2072  *
2073  * Implementers can declare support of contract interfaces, which can then be
2074  * queried by others ({ERC165Checker}).
2075  *
2076  * For an implementation, see {ERC165}.
2077  */
2078 interface IERC165 {
2079     /**
2080      * @dev Returns true if this contract implements the interface defined by
2081      * `interfaceId`. See the corresponding
2082      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
2083      * to learn more about how these ids are created.
2084      *
2085      * This function call must use less than 30 000 gas.
2086      */
2087     function supportsInterface(bytes4 interfaceId) external view returns (bool);
2088 }
2089 
2090 
2091 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
2092 /**
2093  * @dev Required interface of an ERC721 compliant contract.
2094  */
2095 interface IERC721 is IERC165 {
2096     /**
2097      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
2098      */
2099     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
2100 
2101     /**
2102      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
2103      */
2104     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
2105 
2106     /**
2107      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
2108      */
2109     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
2110 
2111     /**
2112      * @dev Returns the number of tokens in ``owner``'s account.
2113      */
2114     function balanceOf(address owner) external view returns (uint256 balance);
2115 
2116     /**
2117      * @dev Returns the owner of the `tokenId` token.
2118      *
2119      * Requirements:
2120      *
2121      * - `tokenId` must exist.
2122      */
2123     function ownerOf(uint256 tokenId) external view returns (address owner);
2124 
2125     /**
2126      * @dev Safely transfers `tokenId` token from `from` to `to`.
2127      *
2128      * Requirements:
2129      *
2130      * - `from` cannot be the zero address.
2131      * - `to` cannot be the zero address.
2132      * - `tokenId` token must exist and be owned by `from`.
2133      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
2134      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2135      *
2136      * Emits a {Transfer} event.
2137      */
2138     function safeTransferFrom(
2139         address from,
2140         address to,
2141         uint256 tokenId,
2142         bytes calldata data
2143     ) external;
2144 
2145     /**
2146      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
2147      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
2148      *
2149      * Requirements:
2150      *
2151      * - `from` cannot be the zero address.
2152      * - `to` cannot be the zero address.
2153      * - `tokenId` token must exist and be owned by `from`.
2154      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
2155      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2156      *
2157      * Emits a {Transfer} event.
2158      */
2159     function safeTransferFrom(
2160         address from,
2161         address to,
2162         uint256 tokenId
2163     ) external;
2164 
2165     /**
2166      * @dev Transfers `tokenId` token from `from` to `to`.
2167      *
2168      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
2169      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
2170      * understand this adds an external call which potentially creates a reentrancy vulnerability.
2171      *
2172      * Requirements:
2173      *
2174      * - `from` cannot be the zero address.
2175      * - `to` cannot be the zero address.
2176      * - `tokenId` token must be owned by `from`.
2177      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
2178      *
2179      * Emits a {Transfer} event.
2180      */
2181     function transferFrom(
2182         address from,
2183         address to,
2184         uint256 tokenId
2185     ) external;
2186 
2187     /**
2188      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
2189      * The approval is cleared when the token is transferred.
2190      *
2191      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
2192      *
2193      * Requirements:
2194      *
2195      * - The caller must own the token or be an approved operator.
2196      * - `tokenId` must exist.
2197      *
2198      * Emits an {Approval} event.
2199      */
2200     function approve(address to, uint256 tokenId) external;
2201 
2202     /**
2203      * @dev Approve or remove `operator` as an operator for the caller.
2204      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
2205      *
2206      * Requirements:
2207      *
2208      * - The `operator` cannot be the caller.
2209      *
2210      * Emits an {ApprovalForAll} event.
2211      */
2212     function setApprovalForAll(address operator, bool _approved) external;
2213 
2214     /**
2215      * @dev Returns the account approved for `tokenId` token.
2216      *
2217      * Requirements:
2218      *
2219      * - `tokenId` must exist.
2220      */
2221     function getApproved(uint256 tokenId) external view returns (address operator);
2222 
2223     /**
2224      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
2225      *
2226      * See {setApprovalForAll}
2227      */
2228     function isApprovedForAll(address owner, address operator) external view returns (bool);
2229 }
2230 
2231 
2232 contract EXV is ERC721A, GuaranteelistMerkle, Pausable, ReentrancyGuard, DefaultOperatorFilterer {
2233 
2234     uint256 public MAX_SUPPLY = 6000;
2235     uint256 public constant RESERVE_MAX_SUPPLY = 100;
2236     uint256 public MAX_FREEMINT = 100;
2237     uint256 public constant ALLOWLISTLIST_MAX_SUPPLY = 2000;
2238     uint256 public publicPrice = 22000000000000000;
2239 
2240     struct TimeConfig {
2241         uint256 premiumSaleStartTime;
2242         uint256 standardSaleStartTime;
2243         uint256 freeSaleStartTime;
2244     }
2245 
2246     TimeConfig public timeConfig;
2247 
2248     uint256 public mintedDevSupply;
2249     uint256 public mintedAllowlistSupply;
2250     uint256 public mintedFreeSupply;
2251 
2252     string public baseURI;
2253 
2254     mapping(address => uint256) public maxWalletMinted;
2255     mapping(address => bool) public freeMinted;
2256 
2257     constructor(string memory initBaseURI, bytes32 _guaranteelistMerkleRoot)
2258     ERC721A("VOGUE8SIAN", "EXV")
2259     GuaranteelistMerkle(_guaranteelistMerkleRoot)
2260     {
2261         baseURI = initBaseURI;
2262     }
2263 
2264     address public baycContractAddress = 0xBC4CA0EdA7647A8aB7C2061c2E118A18a936f13D;
2265     address public maycContractAddress = 0x60E4d786628Fea6478F785A6d7e704777c86a7c6;
2266     address public cryptopunkContractAddress = 0xb47e3cd837dDF8e4c57F05d70Ab865de6e193BBB;
2267 
2268     function pause() public onlyOwner {
2269         _pause();
2270     }
2271 
2272     function unpause() public onlyOwner {
2273         _unpause();
2274     }
2275 
2276     /* Time Control */
2277 
2278     function setPremiumSaleStartTime(uint32 timestamp) external onlyOwner {
2279         timeConfig.premiumSaleStartTime = timestamp;
2280     }
2281 
2282     function setStandardSaleStartTime(uint32 timestamp) external onlyOwner {
2283         timeConfig.standardSaleStartTime = timestamp;
2284     }
2285 
2286     function setFreeSaleStartTime(uint32 timestamp) external onlyOwner {
2287         timeConfig.freeSaleStartTime = timestamp;
2288     }
2289 
2290     function setMaxSupply(uint256 _newMaxSupply) external onlyOwner {
2291         MAX_SUPPLY = _newMaxSupply;
2292     }
2293 
2294     function setPrice(uint256 _newPrice) external onlyOwner {
2295         publicPrice = _newPrice;
2296     }
2297 
2298    function setbaycContractAddress(address _address) external onlyOwner {
2299         baycContractAddress = _address;
2300     }
2301 
2302     function setmaycContractAddress(address _address) external onlyOwner {
2303         maycContractAddress = _address;
2304     }
2305 
2306     function setcryptopunkContractAddress(address _address) external onlyOwner {
2307         cryptopunkContractAddress = _address;
2308     }
2309     /* ETH Withdraw */
2310 
2311     function withdrawETH() external onlyOwner nonReentrant {
2312         (bool success, ) = msg.sender.call{value: address(this).balance}("");
2313         require(success, "Transfer failed.");
2314     }
2315 
2316     /* Minting */
2317 
2318     // @notice For marketing etc.
2319     function reserveMint(uint256 quantity) external onlyOwner {
2320         require(
2321             mintedDevSupply + quantity*2 <= RESERVE_MAX_SUPPLY,
2322             "too many already minted before reserve mint"
2323         );
2324         mintedDevSupply += quantity*2;
2325         _safeMint(msg.sender, quantity*2);
2326     }
2327 // 0x7fab62c37e16db44bb9d0a15b6e0b889b0bd1e4ec935644989bc25ef72db5eac
2328     /* @notice Safely mints NFTs from premium whitelist.
2329        @dev free mint
2330        */
2331     function allowlistMint(bytes32[] calldata _merkleProof, uint256 quantity) external payable whenNotPaused nonReentrant{
2332         uint256 _premiumSaleStartTime = uint256(timeConfig.premiumSaleStartTime);
2333         require(
2334             _premiumSaleStartTime != 0 && block.timestamp >= _premiumSaleStartTime,
2335             "not in the premium sale time"
2336         );
2337         require(MerkleProof.verify(_merkleProof, guaranteelistMerkleRoot, keccak256(abi.encodePacked(msg.sender))),
2338             "Invalid MerkleProof"
2339         );
2340         require(maxWalletMinted[msg.sender] + quantity < 5, "Max mint of 4 per wallet");
2341         require(
2342             mintedAllowlistSupply + 2 <= ALLOWLISTLIST_MAX_SUPPLY,
2343             "not enough remaining reserved for premium sale to support desired mint amount"
2344         );
2345         require(msg.value >= (publicPrice * quantity), "Need to send more ETH.");   
2346         require(msg.value <= (publicPrice * quantity), "You have tried to send too much ETH");
2347         mintedAllowlistSupply += 2;
2348         maxWalletMinted[msg.sender] += quantity;
2349         publicSaleMint(quantity);
2350     }
2351 
2352     /* @notice Safely mints NFTs from standard whitelist.
2353        @dev free mint
2354        */
2355     function freemint() public payable whenNotPaused nonReentrant {
2356         require(
2357             !freeMinted[msg.sender], "You have already claimed your free mint"
2358         );
2359         require(
2360             mintedFreeSupply < MAX_FREEMINT, "Free Mint has been fully claimed"
2361         );
2362         uint256 _freeSaleStartTime = uint256(timeConfig.freeSaleStartTime);
2363         require(
2364             _freeSaleStartTime != 0 && block.timestamp >= _freeSaleStartTime,
2365             "not in the free sale time"
2366         );
2367         IERC721 token = IERC721(baycContractAddress);
2368         uint256 ownerAmount = token.balanceOf(msg.sender);
2369         IERC721 token2 = IERC721(maycContractAddress);
2370         ownerAmount += token2.balanceOf(msg.sender);
2371         IERC721 token3 = IERC721(cryptopunkContractAddress);
2372         ownerAmount += token3.balanceOf(msg.sender);
2373         require(ownerAmount >=1, "You don't qualify for the free mint");
2374         mintedFreeSupply += 2;
2375         freeMinted[msg.sender] = true;
2376         _safeMint(msg.sender, 2);
2377     }
2378 
2379     /* @notice Safely mints NFTs from standard whitelist.
2380        @dev free mint
2381        */
2382     function mint(uint256 quantity) public payable whenNotPaused nonReentrant {
2383         uint256 _standardSaleStartTime = uint256(timeConfig.standardSaleStartTime);
2384         require(
2385              _standardSaleStartTime != 0 && block.timestamp >= _standardSaleStartTime,
2386             "sale not started"
2387         );
2388         require(quantity < 5, "Max mint of 4 per transaction");
2389         publicSaleMint(quantity);
2390     }
2391 
2392     function publicSaleMint(uint256 quantity)
2393         private
2394         callerIsUser
2395     {
2396         require(totalSupply() + quantity*2 <= MAX_SUPPLY, "reached max supply");
2397         require(msg.value >= (publicPrice * quantity), "Need to send more ETH.");
2398         require(msg.value <= (publicPrice * quantity), "You have tried to send too much ETH");
2399         _safeMint(msg.sender, quantity*2);
2400     }
2401 
2402     function _baseURI() internal view virtual override returns (string memory) {
2403         return baseURI;
2404     }
2405 
2406     function setBaseURI(string memory _tokenBaseURI) external onlyOwner {
2407         baseURI = _tokenBaseURI;
2408     }
2409 
2410     /* Operator filtering */
2411 
2412     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
2413         super.setApprovalForAll(operator, approved);
2414     }
2415 
2416     function approve(address operator, uint256 tokenId) public payable override onlyAllowedOperatorApproval(operator) {
2417         super.approve(operator, tokenId);
2418     }
2419 
2420     function transferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
2421         super.transferFrom(from, to, tokenId);
2422     }
2423 
2424     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
2425         super.safeTransferFrom(from, to, tokenId);
2426     }
2427 
2428     /* Modifiers */
2429 
2430     modifier callerIsUser() {
2431         require(tx.origin == msg.sender, "The caller is another contract");
2432         _;
2433     }
2434 }