1 // SPDX-License-Identifier: MIT
2 // File: IOperatorFilterRegistry.sol
3 
4 pragma solidity ^0.8.13;
5 
6 interface IOperatorFilterRegistry {
7     function isOperatorAllowed(address registrant, address operator)
8         external
9         view
10         returns (bool);
11 
12     function register(address registrant) external;
13 
14     function registerAndSubscribe(address registrant, address subscription)
15         external;
16 
17     function registerAndCopyEntries(
18         address registrant,
19         address registrantToCopy
20     ) external;
21 
22     function unregister(address addr) external;
23 
24     function updateOperator(
25         address registrant,
26         address operator,
27         bool filtered
28     ) external;
29 
30     function updateOperators(
31         address registrant,
32         address[] calldata operators,
33         bool filtered
34     ) external;
35 
36     function updateCodeHash(
37         address registrant,
38         bytes32 codehash,
39         bool filtered
40     ) external;
41 
42     function updateCodeHashes(
43         address registrant,
44         bytes32[] calldata codeHashes,
45         bool filtered
46     ) external;
47 
48     function subscribe(address registrant, address registrantToSubscribe)
49         external;
50 
51     function unsubscribe(address registrant, bool copyExistingEntries) external;
52 
53     function subscriptionOf(address addr) external returns (address registrant);
54 
55     function subscribers(address registrant)
56         external
57         returns (address[] memory);
58 
59     function subscriberAt(address registrant, uint256 index)
60         external
61         returns (address);
62 
63     function copyEntriesOf(address registrant, address registrantToCopy)
64         external;
65 
66     function isOperatorFiltered(address registrant, address operator)
67         external
68         returns (bool);
69 
70     function isCodeHashOfFiltered(address registrant, address operatorWithCode)
71         external
72         returns (bool);
73 
74     function isCodeHashFiltered(address registrant, bytes32 codeHash)
75         external
76         returns (bool);
77 
78     function filteredOperators(address addr)
79         external
80         returns (address[] memory);
81 
82     function filteredCodeHashes(address addr)
83         external
84         returns (bytes32[] memory);
85 
86     function filteredOperatorAt(address registrant, uint256 index)
87         external
88         returns (address);
89 
90     function filteredCodeHashAt(address registrant, uint256 index)
91         external
92         returns (bytes32);
93 
94     function isRegistered(address addr) external returns (bool);
95 
96     function codeHashOf(address addr) external returns (bytes32);
97 }
98 
99 // File: OperatorFilterer.sol
100 
101 pragma solidity ^0.8.13;
102 
103 /**
104  * @title  OperatorFilterer
105  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
106  *         registrant's entries in the OperatorFilterRegistry.
107  */
108 abstract contract OperatorFilterer {
109     error OperatorNotAllowed(address operator);
110 
111     IOperatorFilterRegistry constant OPERATOR_FILTER_REGISTRY =
112         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
113 
114     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
115         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
116         // will not revert, but the contract will need to be registered with the registry once it is deployed in
117         // order for the modifier to filter addresses.
118         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
119             if (subscribe) {
120                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(
121                     address(this),
122                     subscriptionOrRegistrantToCopy
123                 );
124             } else {
125                 if (subscriptionOrRegistrantToCopy != address(0)) {
126                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(
127                         address(this),
128                         subscriptionOrRegistrantToCopy
129                     );
130                 } else {
131                     OPERATOR_FILTER_REGISTRY.register(address(this));
132                 }
133             }
134         }
135     }
136 
137     modifier onlyAllowedOperator(address from) virtual {
138         // Check registry code length to facilitate testing in environments without a deployed registry.
139         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
140             // Allow spending tokens from addresses with balance
141             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
142             // from an EOA.
143             if (from == msg.sender) {
144                 _;
145                 return;
146             }
147             if (
148                 !OPERATOR_FILTER_REGISTRY.isOperatorAllowed(
149                     address(this),
150                     msg.sender
151                 )
152             ) {
153                 revert OperatorNotAllowed(msg.sender);
154             }
155         }
156         _;
157     }
158 
159     modifier onlyAllowedOperatorApproval(address operator) virtual {
160         // Check registry code length to facilitate testing in environments without a deployed registry.
161         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
162             if (
163                 !OPERATOR_FILTER_REGISTRY.isOperatorAllowed(
164                     address(this),
165                     operator
166                 )
167             ) {
168                 revert OperatorNotAllowed(operator);
169             }
170         }
171         _;
172     }
173 }
174 
175 // File: DefaultOperatorFilterer.sol
176 
177 pragma solidity ^0.8.13;
178 
179 /**
180  * @title  DefaultOperatorFilterer
181  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
182  */
183 abstract contract DefaultOperatorFilterer is OperatorFilterer {
184     address constant DEFAULT_SUBSCRIPTION =
185         address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
186 
187     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
188 }
189 
190 // File: OrigamiClubNFTv3.sol
191 
192 /**
193  *Submitted for verification at Etherscan.io on 2022-08-31
194  */
195 
196 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/IERC721A.sol
197 
198 // ERC721A Contracts v4.2.2
199 // Creator: Chiru Labs
200 
201 pragma solidity ^0.8.4;
202 
203 /**
204  * @dev Interface of ERC721A.
205  */
206 interface IERC721A {
207     /**
208      * The caller must own the token or be an approved operator.
209      */
210     error ApprovalCallerNotOwnerNorApproved();
211 
212     /**
213      * The token does not exist.
214      */
215     error ApprovalQueryForNonexistentToken();
216 
217     /**
218      * Cannot query the balance for the zero address.
219      */
220     error BalanceQueryForZeroAddress();
221 
222     /**
223      * Cannot mint to the zero address.
224      */
225     error MintToZeroAddress();
226 
227     /**
228      * The quantity of tokens minted must be more than zero.
229      */
230     error MintZeroQuantity();
231 
232     /**
233      * The token does not exist.
234      */
235     error OwnerQueryForNonexistentToken();
236 
237     /**
238      * The caller must own the token or be an approved operator.
239      */
240     error TransferCallerNotOwnerNorApproved();
241 
242     /**
243      * The token must be owned by `from`.
244      */
245     error TransferFromIncorrectOwner();
246 
247     /**
248      * Cannot safely transfer to a contract that does not implement the
249      * ERC721Receiver interface.
250      */
251     error TransferToNonERC721ReceiverImplementer();
252 
253     /**
254      * Cannot transfer to the zero address.
255      */
256     error TransferToZeroAddress();
257 
258     /**
259      * The token does not exist.
260      */
261     error URIQueryForNonexistentToken();
262 
263     /**
264      * The `quantity` minted with ERC2309 exceeds the safety limit.
265      */
266     error MintERC2309QuantityExceedsLimit();
267 
268     /**
269      * The `extraData` cannot be set on an unintialized ownership slot.
270      */
271     error OwnershipNotInitializedForExtraData();
272 
273     // =============================================================
274     //                            STRUCTS
275     // =============================================================
276 
277     struct TokenOwnership {
278         // The address of the owner.
279         address addr;
280         // Stores the start time of ownership with minimal overhead for tokenomics.
281         uint64 startTimestamp;
282         // Whether the token has been burned.
283         bool burned;
284         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
285         uint24 extraData;
286     }
287 
288     // =============================================================
289     //                         TOKEN COUNTERS
290     // =============================================================
291 
292     /**
293      * @dev Returns the total number of tokens in existence.
294      * Burned tokens will reduce the count.
295      * To get the total number of tokens minted, please see {_totalMinted}.
296      */
297     function totalSupply() external view returns (uint256);
298 
299     // =============================================================
300     //                            IERC165
301     // =============================================================
302 
303     /**
304      * @dev Returns true if this contract implements the interface defined by
305      * `interfaceId`. See the corresponding
306      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
307      * to learn more about how these ids are created.
308      *
309      * This function call must use less than 30000 gas.
310      */
311     function supportsInterface(bytes4 interfaceId) external view returns (bool);
312 
313     // =============================================================
314     //                            IERC721
315     // =============================================================
316 
317     /**
318      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
319      */
320     event Transfer(
321         address indexed from,
322         address indexed to,
323         uint256 indexed tokenId
324     );
325 
326     /**
327      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
328      */
329     event Approval(
330         address indexed owner,
331         address indexed approved,
332         uint256 indexed tokenId
333     );
334 
335     /**
336      * @dev Emitted when `owner` enables or disables
337      * (`approved`) `operator` to manage all of its assets.
338      */
339     event ApprovalForAll(
340         address indexed owner,
341         address indexed operator,
342         bool approved
343     );
344 
345     /**
346      * @dev Returns the number of tokens in `owner`'s account.
347      */
348     function balanceOf(address owner) external view returns (uint256 balance);
349 
350     /**
351      * @dev Returns the owner of the `tokenId` token.
352      *
353      * Requirements:
354      *
355      * - `tokenId` must exist.
356      */
357     function ownerOf(uint256 tokenId) external view returns (address owner);
358 
359     /**
360      * @dev Safely transfers `tokenId` token from `from` to `to`,
361      * checking first that contract recipients are aware of the ERC721 protocol
362      * to prevent tokens from being forever locked.
363      *
364      * Requirements:
365      *
366      * - `from` cannot be the zero address.
367      * - `to` cannot be the zero address.
368      * - `tokenId` token must exist and be owned by `from`.
369      * - If the caller is not `from`, it must be have been allowed to move
370      * this token by either {approve} or {setApprovalForAll}.
371      * - If `to` refers to a smart contract, it must implement
372      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
373      *
374      * Emits a {Transfer} event.
375      */
376     function safeTransferFrom(
377         address from,
378         address to,
379         uint256 tokenId,
380         bytes calldata data
381     ) external;
382 
383     /**
384      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
385      */
386     function safeTransferFrom(
387         address from,
388         address to,
389         uint256 tokenId
390     ) external;
391 
392     /**
393      * @dev Transfers `tokenId` from `from` to `to`.
394      *
395      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
396      * whenever possible.
397      *
398      * Requirements:
399      *
400      * - `from` cannot be the zero address.
401      * - `to` cannot be the zero address.
402      * - `tokenId` token must be owned by `from`.
403      * - If the caller is not `from`, it must be approved to move this token
404      * by either {approve} or {setApprovalForAll}.
405      *
406      * Emits a {Transfer} event.
407      */
408     function transferFrom(
409         address from,
410         address to,
411         uint256 tokenId
412     ) external;
413 
414     /**
415      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
416      * The approval is cleared when the token is transferred.
417      *
418      * Only a single account can be approved at a time, so approving the
419      * zero address clears previous approvals.
420      *
421      * Requirements:
422      *
423      * - The caller must own the token or be an approved operator.
424      * - `tokenId` must exist.
425      *
426      * Emits an {Approval} event.
427      */
428     function approve(address to, uint256 tokenId) external;
429 
430     /**
431      * @dev Approve or remove `operator` as an operator for the caller.
432      * Operators can call {transferFrom} or {safeTransferFrom}
433      * for any token owned by the caller.
434      *
435      * Requirements:
436      *
437      * - The `operator` cannot be the caller.
438      *
439      * Emits an {ApprovalForAll} event.
440      */
441     function setApprovalForAll(address operator, bool _approved) external;
442 
443     /**
444      * @dev Returns the account approved for `tokenId` token.
445      *
446      * Requirements:
447      *
448      * - `tokenId` must exist.
449      */
450     function getApproved(uint256 tokenId)
451         external
452         view
453         returns (address operator);
454 
455     /**
456      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
457      *
458      * See {setApprovalForAll}.
459      */
460     function isApprovedForAll(address owner, address operator)
461         external
462         view
463         returns (bool);
464 
465     // =============================================================
466     //                        IERC721Metadata
467     // =============================================================
468 
469     /**
470      * @dev Returns the token collection name.
471      */
472     function name() external view returns (string memory);
473 
474     /**
475      * @dev Returns the token collection symbol.
476      */
477     function symbol() external view returns (string memory);
478 
479     /**
480      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
481      */
482     function tokenURI(uint256 tokenId) external view returns (string memory);
483 
484     // =============================================================
485     //                           IERC2309
486     // =============================================================
487 
488     /**
489      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
490      * (inclusive) is transferred from `from` to `to`, as defined in the
491      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
492      *
493      * See {_mintERC2309} for more details.
494      */
495     event ConsecutiveTransfer(
496         uint256 indexed fromTokenId,
497         uint256 toTokenId,
498         address indexed from,
499         address indexed to
500     );
501 }
502 
503 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol
504 
505 // ERC721A Contracts v4.2.2
506 // Creator: Chiru Labs
507 
508 pragma solidity ^0.8.4;
509 
510 /**
511  * @dev Interface of ERC721 token receiver.
512  */
513 interface ERC721A__IERC721Receiver {
514     function onERC721Received(
515         address operator,
516         address from,
517         uint256 tokenId,
518         bytes calldata data
519     ) external returns (bytes4);
520 }
521 
522 /**
523  * @title ERC721A
524  *
525  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
526  * Non-Fungible Token Standard, including the Metadata extension.
527  * Optimized for lower gas during batch mints.
528  *
529  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
530  * starting from `_startTokenId()`.
531  *
532  * Assumptions:
533  *
534  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
535  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
536  */
537 contract ERC721A is IERC721A {
538     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
539     struct TokenApprovalRef {
540         address value;
541     }
542 
543     // =============================================================
544     //                           CONSTANTS
545     // =============================================================
546 
547     // Mask of an entry in packed address data.
548     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
549 
550     // The bit position of `numberMinted` in packed address data.
551     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
552 
553     // The bit position of `numberBurned` in packed address data.
554     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
555 
556     // The bit position of `aux` in packed address data.
557     uint256 private constant _BITPOS_AUX = 192;
558 
559     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
560     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
561 
562     // The bit position of `startTimestamp` in packed ownership.
563     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
564 
565     // The bit mask of the `burned` bit in packed ownership.
566     uint256 private constant _BITMASK_BURNED = 1 << 224;
567 
568     // The bit position of the `nextInitialized` bit in packed ownership.
569     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
570 
571     // The bit mask of the `nextInitialized` bit in packed ownership.
572     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
573 
574     // The bit position of `extraData` in packed ownership.
575     uint256 private constant _BITPOS_EXTRA_DATA = 232;
576 
577     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
578     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
579 
580     // The mask of the lower 160 bits for addresses.
581     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
582 
583     // The maximum `quantity` that can be minted with {_mintERC2309}.
584     // This limit is to prevent overflows on the address data entries.
585     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
586     // is required to cause an overflow, which is unrealistic.
587     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
588 
589     // The `Transfer` event signature is given by:
590     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
591     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
592         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
593 
594     // =============================================================
595     //                            STORAGE
596     // =============================================================
597 
598     // The next token ID to be minted.
599     uint256 private _currentIndex;
600 
601     // The number of tokens burned.
602     uint256 private _burnCounter;
603 
604     // Token name
605     string private _name;
606 
607     // Token symbol
608     string private _symbol;
609 
610     // Mapping from token ID to ownership details
611     // An empty struct value does not necessarily mean the token is unowned.
612     // See {_packedOwnershipOf} implementation for details.
613     //
614     // Bits Layout:
615     // - [0..159]   `addr`
616     // - [160..223] `startTimestamp`
617     // - [224]      `burned`
618     // - [225]      `nextInitialized`
619     // - [232..255] `extraData`
620     mapping(uint256 => uint256) private _packedOwnerships;
621 
622     // Mapping owner address to address data.
623     //
624     // Bits Layout:
625     // - [0..63]    `balance`
626     // - [64..127]  `numberMinted`
627     // - [128..191] `numberBurned`
628     // - [192..255] `aux`
629     mapping(address => uint256) private _packedAddressData;
630 
631     // Mapping from token ID to approved address.
632     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
633 
634     // Mapping from owner to operator approvals
635     mapping(address => mapping(address => bool)) private _operatorApprovals;
636 
637     // =============================================================
638     //                          CONSTRUCTOR
639     // =============================================================
640 
641     constructor(string memory name_, string memory symbol_) {
642         _name = name_;
643         _symbol = symbol_;
644         _currentIndex = _startTokenId();
645     }
646 
647     // =============================================================
648     //                   TOKEN COUNTING OPERATIONS
649     // =============================================================
650 
651     /**
652      * @dev Returns the starting token ID.
653      * To change the starting token ID, please override this function.
654      */
655     function _startTokenId() internal view virtual returns (uint256) {
656         return 0;
657     }
658 
659     /**
660      * @dev Returns the next token ID to be minted.
661      */
662     function _nextTokenId() internal view virtual returns (uint256) {
663         return _currentIndex;
664     }
665 
666     /**
667      * @dev Returns the total number of tokens in existence.
668      * Burned tokens will reduce the count.
669      * To get the total number of tokens minted, please see {_totalMinted}.
670      */
671     function totalSupply() public view virtual override returns (uint256) {
672         // Counter underflow is impossible as _burnCounter cannot be incremented
673         // more than `_currentIndex - _startTokenId()` times.
674         unchecked {
675             return _currentIndex - _burnCounter - _startTokenId();
676         }
677     }
678 
679     /**
680      * @dev Returns the total amount of tokens minted in the contract.
681      */
682     function _totalMinted() internal view virtual returns (uint256) {
683         // Counter underflow is impossible as `_currentIndex` does not decrement,
684         // and it is initialized to `_startTokenId()`.
685         unchecked {
686             return _currentIndex - _startTokenId();
687         }
688     }
689 
690     /**
691      * @dev Returns the total number of tokens burned.
692      */
693     function _totalBurned() internal view virtual returns (uint256) {
694         return _burnCounter;
695     }
696 
697     // =============================================================
698     //                    ADDRESS DATA OPERATIONS
699     // =============================================================
700 
701     /**
702      * @dev Returns the number of tokens in `owner`'s account.
703      */
704     function balanceOf(address owner)
705         public
706         view
707         virtual
708         override
709         returns (uint256)
710     {
711         if (owner == address(0)) revert BalanceQueryForZeroAddress();
712         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
713     }
714 
715     /**
716      * Returns the number of tokens minted by `owner`.
717      */
718     function _numberMinted(address owner) internal view returns (uint256) {
719         return
720             (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) &
721             _BITMASK_ADDRESS_DATA_ENTRY;
722     }
723 
724     /**
725      * Returns the number of tokens burned by or on behalf of `owner`.
726      */
727     function _numberBurned(address owner) internal view returns (uint256) {
728         return
729             (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) &
730             _BITMASK_ADDRESS_DATA_ENTRY;
731     }
732 
733     /**
734      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
735      */
736     function _getAux(address owner) internal view returns (uint64) {
737         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
738     }
739 
740     /**
741      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
742      * If there are multiple variables, please pack them into a uint64.
743      */
744     function _setAux(address owner, uint64 aux) internal virtual {
745         uint256 packed = _packedAddressData[owner];
746         uint256 auxCasted;
747         // Cast `aux` with assembly to avoid redundant masking.
748         assembly {
749             auxCasted := aux
750         }
751         packed =
752             (packed & _BITMASK_AUX_COMPLEMENT) |
753             (auxCasted << _BITPOS_AUX);
754         _packedAddressData[owner] = packed;
755     }
756 
757     // =============================================================
758     //                            IERC165
759     // =============================================================
760 
761     /**
762      * @dev Returns true if this contract implements the interface defined by
763      * `interfaceId`. See the corresponding
764      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
765      * to learn more about how these ids are created.
766      *
767      * This function call must use less than 30000 gas.
768      */
769     function supportsInterface(bytes4 interfaceId)
770         public
771         view
772         virtual
773         override
774         returns (bool)
775     {
776         // The interface IDs are constants representing the first 4 bytes
777         // of the XOR of all function selectors in the interface.
778         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
779         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
780         return
781             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
782             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
783             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
784     }
785 
786     // =============================================================
787     //                        IERC721Metadata
788     // =============================================================
789 
790     /**
791      * @dev Returns the token collection name.
792      */
793     function name() public view virtual override returns (string memory) {
794         return _name;
795     }
796 
797     /**
798      * @dev Returns the token collection symbol.
799      */
800     function symbol() public view virtual override returns (string memory) {
801         return _symbol;
802     }
803 
804     /**
805      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
806      */
807     function tokenURI(uint256 tokenId)
808         public
809         view
810         virtual
811         override
812         returns (string memory)
813     {
814         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
815 
816         string memory baseURI = _baseURI();
817         return
818             bytes(baseURI).length != 0
819                 ? string(abi.encodePacked(baseURI, _toString(tokenId)))
820                 : "";
821     }
822 
823     /**
824      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
825      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
826      * by default, it can be overridden in child contracts.
827      */
828     function _baseURI() internal view virtual returns (string memory) {
829         return "";
830     }
831 
832     // =============================================================
833     //                     OWNERSHIPS OPERATIONS
834     // =============================================================
835 
836     /**
837      * @dev Returns the owner of the `tokenId` token.
838      *
839      * Requirements:
840      *
841      * - `tokenId` must exist.
842      */
843     function ownerOf(uint256 tokenId)
844         public
845         view
846         virtual
847         override
848         returns (address)
849     {
850         return address(uint160(_packedOwnershipOf(tokenId)));
851     }
852 
853     /**
854      * @dev Gas spent here starts off proportional to the maximum mint batch size.
855      * It gradually moves to O(1) as tokens get transferred around over time.
856      */
857     function _ownershipOf(uint256 tokenId)
858         internal
859         view
860         virtual
861         returns (TokenOwnership memory)
862     {
863         return _unpackedOwnership(_packedOwnershipOf(tokenId));
864     }
865 
866     /**
867      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
868      */
869     function _ownershipAt(uint256 index)
870         internal
871         view
872         virtual
873         returns (TokenOwnership memory)
874     {
875         return _unpackedOwnership(_packedOwnerships[index]);
876     }
877 
878     /**
879      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
880      */
881     function _initializeOwnershipAt(uint256 index) internal virtual {
882         if (_packedOwnerships[index] == 0) {
883             _packedOwnerships[index] = _packedOwnershipOf(index);
884         }
885     }
886 
887     /**
888      * Returns the packed ownership data of `tokenId`.
889      */
890     function _packedOwnershipOf(uint256 tokenId)
891         private
892         view
893         returns (uint256)
894     {
895         uint256 curr = tokenId;
896 
897         unchecked {
898             if (_startTokenId() <= curr)
899                 if (curr < _currentIndex) {
900                     uint256 packed = _packedOwnerships[curr];
901                     // If not burned.
902                     if (packed & _BITMASK_BURNED == 0) {
903                         // Invariant:
904                         // There will always be an initialized ownership slot
905                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
906                         // before an unintialized ownership slot
907                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
908                         // Hence, `curr` will not underflow.
909                         //
910                         // We can directly compare the packed value.
911                         // If the address is zero, packed will be zero.
912                         while (packed == 0) {
913                             packed = _packedOwnerships[--curr];
914                         }
915                         return packed;
916                     }
917                 }
918         }
919         revert OwnerQueryForNonexistentToken();
920     }
921 
922     /**
923      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
924      */
925     function _unpackedOwnership(uint256 packed)
926         private
927         pure
928         returns (TokenOwnership memory ownership)
929     {
930         ownership.addr = address(uint160(packed));
931         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
932         ownership.burned = packed & _BITMASK_BURNED != 0;
933         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
934     }
935 
936     /**
937      * @dev Packs ownership data into a single uint256.
938      */
939     function _packOwnershipData(address owner, uint256 flags)
940         private
941         view
942         returns (uint256 result)
943     {
944         assembly {
945             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
946             owner := and(owner, _BITMASK_ADDRESS)
947             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
948             result := or(
949                 owner,
950                 or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags)
951             )
952         }
953     }
954 
955     /**
956      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
957      */
958     function _nextInitializedFlag(uint256 quantity)
959         private
960         pure
961         returns (uint256 result)
962     {
963         // For branchless setting of the `nextInitialized` flag.
964         assembly {
965             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
966             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
967         }
968     }
969 
970     // =============================================================
971     //                      APPROVAL OPERATIONS
972     // =============================================================
973 
974     /**
975      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
976      * The approval is cleared when the token is transferred.
977      *
978      * Only a single account can be approved at a time, so approving the
979      * zero address clears previous approvals.
980      *
981      * Requirements:
982      *
983      * - The caller must own the token or be an approved operator.
984      * - `tokenId` must exist.
985      *
986      * Emits an {Approval} event.
987      */
988     function approve(address to, uint256 tokenId) public virtual override {
989         address owner = ownerOf(tokenId);
990 
991         if (_msgSenderERC721A() != owner)
992             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
993                 revert ApprovalCallerNotOwnerNorApproved();
994             }
995 
996         _tokenApprovals[tokenId].value = to;
997         emit Approval(owner, to, tokenId);
998     }
999 
1000     /**
1001      * @dev Returns the account approved for `tokenId` token.
1002      *
1003      * Requirements:
1004      *
1005      * - `tokenId` must exist.
1006      */
1007     function getApproved(uint256 tokenId)
1008         public
1009         view
1010         virtual
1011         override
1012         returns (address)
1013     {
1014         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1015 
1016         return _tokenApprovals[tokenId].value;
1017     }
1018 
1019     /**
1020      * @dev Approve or remove `operator` as an operator for the caller.
1021      * Operators can call {transferFrom} or {safeTransferFrom}
1022      * for any token owned by the caller.
1023      *
1024      * Requirements:
1025      *
1026      * - The `operator` cannot be the caller.
1027      *
1028      * Emits an {ApprovalForAll} event.
1029      */
1030     function setApprovalForAll(address operator, bool approved)
1031         public
1032         virtual
1033         override
1034     {
1035         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1036         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1037     }
1038 
1039     /**
1040      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1041      *
1042      * See {setApprovalForAll}.
1043      */
1044     function isApprovedForAll(address owner, address operator)
1045         public
1046         view
1047         virtual
1048         override
1049         returns (bool)
1050     {
1051         return _operatorApprovals[owner][operator];
1052     }
1053 
1054     /**
1055      * @dev Returns whether `tokenId` exists.
1056      *
1057      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1058      *
1059      * Tokens start existing when they are minted. See {_mint}.
1060      */
1061     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1062         return
1063             _startTokenId() <= tokenId &&
1064             tokenId < _currentIndex && // If within bounds,
1065             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1066     }
1067 
1068     /**
1069      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1070      */
1071     function _isSenderApprovedOrOwner(
1072         address approvedAddress,
1073         address owner,
1074         address msgSender
1075     ) private pure returns (bool result) {
1076         assembly {
1077             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1078             owner := and(owner, _BITMASK_ADDRESS)
1079             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1080             msgSender := and(msgSender, _BITMASK_ADDRESS)
1081             // `msgSender == owner || msgSender == approvedAddress`.
1082             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1083         }
1084     }
1085 
1086     /**
1087      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1088      */
1089     function _getApprovedSlotAndAddress(uint256 tokenId)
1090         private
1091         view
1092         returns (uint256 approvedAddressSlot, address approvedAddress)
1093     {
1094         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1095         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1096         assembly {
1097             approvedAddressSlot := tokenApproval.slot
1098             approvedAddress := sload(approvedAddressSlot)
1099         }
1100     }
1101 
1102     // =============================================================
1103     //                      TRANSFER OPERATIONS
1104     // =============================================================
1105 
1106     /**
1107      * @dev Transfers `tokenId` from `from` to `to`.
1108      *
1109      * Requirements:
1110      *
1111      * - `from` cannot be the zero address.
1112      * - `to` cannot be the zero address.
1113      * - `tokenId` token must be owned by `from`.
1114      * - If the caller is not `from`, it must be approved to move this token
1115      * by either {approve} or {setApprovalForAll}.
1116      *
1117      * Emits a {Transfer} event.
1118      */
1119     function transferFrom(
1120         address from,
1121         address to,
1122         uint256 tokenId
1123     ) public virtual override {
1124         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1125 
1126         if (address(uint160(prevOwnershipPacked)) != from)
1127             revert TransferFromIncorrectOwner();
1128 
1129         (
1130             uint256 approvedAddressSlot,
1131             address approvedAddress
1132         ) = _getApprovedSlotAndAddress(tokenId);
1133 
1134         // The nested ifs save around 20+ gas over a compound boolean condition.
1135         if (
1136             !_isSenderApprovedOrOwner(
1137                 approvedAddress,
1138                 from,
1139                 _msgSenderERC721A()
1140             )
1141         )
1142             if (!isApprovedForAll(from, _msgSenderERC721A()))
1143                 revert TransferCallerNotOwnerNorApproved();
1144 
1145         if (to == address(0)) revert TransferToZeroAddress();
1146 
1147         _beforeTokenTransfers(from, to, tokenId, 1);
1148 
1149         // Clear approvals from the previous owner.
1150         assembly {
1151             if approvedAddress {
1152                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1153                 sstore(approvedAddressSlot, 0)
1154             }
1155         }
1156 
1157         // Underflow of the sender's balance is impossible because we check for
1158         // ownership above and the recipient's balance can't realistically overflow.
1159         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1160         unchecked {
1161             // We can directly increment and decrement the balances.
1162             --_packedAddressData[from]; // Updates: `balance -= 1`.
1163             ++_packedAddressData[to]; // Updates: `balance += 1`.
1164 
1165             // Updates:
1166             // - `address` to the next owner.
1167             // - `startTimestamp` to the timestamp of transfering.
1168             // - `burned` to `false`.
1169             // - `nextInitialized` to `true`.
1170             _packedOwnerships[tokenId] = _packOwnershipData(
1171                 to,
1172                 _BITMASK_NEXT_INITIALIZED |
1173                     _nextExtraData(from, to, prevOwnershipPacked)
1174             );
1175 
1176             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1177             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1178                 uint256 nextTokenId = tokenId + 1;
1179                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1180                 if (_packedOwnerships[nextTokenId] == 0) {
1181                     // If the next slot is within bounds.
1182                     if (nextTokenId != _currentIndex) {
1183                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1184                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1185                     }
1186                 }
1187             }
1188         }
1189 
1190         emit Transfer(from, to, tokenId);
1191         _afterTokenTransfers(from, to, tokenId, 1);
1192     }
1193 
1194     /**
1195      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1196      */
1197     function safeTransferFrom(
1198         address from,
1199         address to,
1200         uint256 tokenId
1201     ) public virtual override {
1202         safeTransferFrom(from, to, tokenId, "");
1203     }
1204 
1205     /**
1206      * @dev Safely transfers `tokenId` token from `from` to `to`.
1207      *
1208      * Requirements:
1209      *
1210      * - `from` cannot be the zero address.
1211      * - `to` cannot be the zero address.
1212      * - `tokenId` token must exist and be owned by `from`.
1213      * - If the caller is not `from`, it must be approved to move this token
1214      * by either {approve} or {setApprovalForAll}.
1215      * - If `to` refers to a smart contract, it must implement
1216      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1217      *
1218      * Emits a {Transfer} event.
1219      */
1220     function safeTransferFrom(
1221         address from,
1222         address to,
1223         uint256 tokenId,
1224         bytes memory _data
1225     ) public virtual override {
1226         transferFrom(from, to, tokenId);
1227         if (to.code.length != 0)
1228             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1229                 revert TransferToNonERC721ReceiverImplementer();
1230             }
1231     }
1232 
1233     /**
1234      * @dev Hook that is called before a set of serially-ordered token IDs
1235      * are about to be transferred. This includes minting.
1236      * And also called before burning one token.
1237      *
1238      * `startTokenId` - the first token ID to be transferred.
1239      * `quantity` - the amount to be transferred.
1240      *
1241      * Calling conditions:
1242      *
1243      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1244      * transferred to `to`.
1245      * - When `from` is zero, `tokenId` will be minted for `to`.
1246      * - When `to` is zero, `tokenId` will be burned by `from`.
1247      * - `from` and `to` are never both zero.
1248      */
1249     function _beforeTokenTransfers(
1250         address from,
1251         address to,
1252         uint256 startTokenId,
1253         uint256 quantity
1254     ) internal virtual {}
1255 
1256     /**
1257      * @dev Hook that is called after a set of serially-ordered token IDs
1258      * have been transferred. This includes minting.
1259      * And also called after one token has been burned.
1260      *
1261      * `startTokenId` - the first token ID to be transferred.
1262      * `quantity` - the amount to be transferred.
1263      *
1264      * Calling conditions:
1265      *
1266      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1267      * transferred to `to`.
1268      * - When `from` is zero, `tokenId` has been minted for `to`.
1269      * - When `to` is zero, `tokenId` has been burned by `from`.
1270      * - `from` and `to` are never both zero.
1271      */
1272     function _afterTokenTransfers(
1273         address from,
1274         address to,
1275         uint256 startTokenId,
1276         uint256 quantity
1277     ) internal virtual {}
1278 
1279     /**
1280      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1281      *
1282      * `from` - Previous owner of the given token ID.
1283      * `to` - Target address that will receive the token.
1284      * `tokenId` - Token ID to be transferred.
1285      * `_data` - Optional data to send along with the call.
1286      *
1287      * Returns whether the call correctly returned the expected magic value.
1288      */
1289     function _checkContractOnERC721Received(
1290         address from,
1291         address to,
1292         uint256 tokenId,
1293         bytes memory _data
1294     ) private returns (bool) {
1295         try
1296             ERC721A__IERC721Receiver(to).onERC721Received(
1297                 _msgSenderERC721A(),
1298                 from,
1299                 tokenId,
1300                 _data
1301             )
1302         returns (bytes4 retval) {
1303             return
1304                 retval ==
1305                 ERC721A__IERC721Receiver(to).onERC721Received.selector;
1306         } catch (bytes memory reason) {
1307             if (reason.length == 0) {
1308                 revert TransferToNonERC721ReceiverImplementer();
1309             } else {
1310                 assembly {
1311                     revert(add(32, reason), mload(reason))
1312                 }
1313             }
1314         }
1315     }
1316 
1317     // =============================================================
1318     //                        MINT OPERATIONS
1319     // =============================================================
1320 
1321     /**
1322      * @dev Mints `quantity` tokens and transfers them to `to`.
1323      *
1324      * Requirements:
1325      *
1326      * - `to` cannot be the zero address.
1327      * - `quantity` must be greater than 0.
1328      *
1329      * Emits a {Transfer} event for each mint.
1330      */
1331     function _mint(address to, uint256 quantity) internal virtual {
1332         uint256 startTokenId = _currentIndex;
1333         if (quantity == 0) revert MintZeroQuantity();
1334 
1335         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1336 
1337         // Overflows are incredibly unrealistic.
1338         // `balance` and `numberMinted` have a maximum limit of 2**64.
1339         // `tokenId` has a maximum limit of 2**256.
1340         unchecked {
1341             // Updates:
1342             // - `balance += quantity`.
1343             // - `numberMinted += quantity`.
1344             //
1345             // We can directly add to the `balance` and `numberMinted`.
1346             _packedAddressData[to] +=
1347                 quantity *
1348                 ((1 << _BITPOS_NUMBER_MINTED) | 1);
1349 
1350             // Updates:
1351             // - `address` to the owner.
1352             // - `startTimestamp` to the timestamp of minting.
1353             // - `burned` to `false`.
1354             // - `nextInitialized` to `quantity == 1`.
1355             _packedOwnerships[startTokenId] = _packOwnershipData(
1356                 to,
1357                 _nextInitializedFlag(quantity) |
1358                     _nextExtraData(address(0), to, 0)
1359             );
1360 
1361             uint256 toMasked;
1362             uint256 end = startTokenId + quantity;
1363 
1364             // Use assembly to loop and emit the `Transfer` event for gas savings.
1365             // The duplicated `log4` removes an extra check and reduces stack juggling.
1366             // The assembly, together with the surrounding Solidity code, have been
1367             // delicately arranged to nudge the compiler into producing optimized opcodes.
1368             assembly {
1369                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1370                 toMasked := and(to, _BITMASK_ADDRESS)
1371                 // Emit the `Transfer` event.
1372                 log4(
1373                     0, // Start of data (0, since no data).
1374                     0, // End of data (0, since no data).
1375                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1376                     0, // `address(0)`.
1377                     toMasked, // `to`.
1378                     startTokenId // `tokenId`.
1379                 )
1380 
1381                 for {
1382                     let tokenId := add(startTokenId, 1)
1383                 } iszero(eq(tokenId, end)) {
1384                     tokenId := add(tokenId, 1)
1385                 } {
1386                     // Emit the `Transfer` event. Similar to above.
1387                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1388                 }
1389             }
1390             if (toMasked == 0) revert MintToZeroAddress();
1391 
1392             _currentIndex = end;
1393         }
1394         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1395     }
1396 
1397     /**
1398      * @dev Mints `quantity` tokens and transfers them to `to`.
1399      *
1400      * This function is intended for efficient minting only during contract creation.
1401      *
1402      * It emits only one {ConsecutiveTransfer} as defined in
1403      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1404      * instead of a sequence of {Transfer} event(s).
1405      *
1406      * Calling this function outside of contract creation WILL make your contract
1407      * non-compliant with the ERC721 standard.
1408      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1409      * {ConsecutiveTransfer} event is only permissible during contract creation.
1410      *
1411      * Requirements:
1412      *
1413      * - `to` cannot be the zero address.
1414      * - `quantity` must be greater than 0.
1415      *
1416      * Emits a {ConsecutiveTransfer} event.
1417      */
1418     function _mintERC2309(address to, uint256 quantity) internal virtual {
1419         uint256 startTokenId = _currentIndex;
1420         if (to == address(0)) revert MintToZeroAddress();
1421         if (quantity == 0) revert MintZeroQuantity();
1422         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT)
1423             revert MintERC2309QuantityExceedsLimit();
1424 
1425         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1426 
1427         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1428         unchecked {
1429             // Updates:
1430             // - `balance += quantity`.
1431             // - `numberMinted += quantity`.
1432             //
1433             // We can directly add to the `balance` and `numberMinted`.
1434             _packedAddressData[to] +=
1435                 quantity *
1436                 ((1 << _BITPOS_NUMBER_MINTED) | 1);
1437 
1438             // Updates:
1439             // - `address` to the owner.
1440             // - `startTimestamp` to the timestamp of minting.
1441             // - `burned` to `false`.
1442             // - `nextInitialized` to `quantity == 1`.
1443             _packedOwnerships[startTokenId] = _packOwnershipData(
1444                 to,
1445                 _nextInitializedFlag(quantity) |
1446                     _nextExtraData(address(0), to, 0)
1447             );
1448 
1449             emit ConsecutiveTransfer(
1450                 startTokenId,
1451                 startTokenId + quantity - 1,
1452                 address(0),
1453                 to
1454             );
1455 
1456             _currentIndex = startTokenId + quantity;
1457         }
1458         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1459     }
1460 
1461     /**
1462      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1463      *
1464      * Requirements:
1465      *
1466      * - If `to` refers to a smart contract, it must implement
1467      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1468      * - `quantity` must be greater than 0.
1469      *
1470      * See {_mint}.
1471      *
1472      * Emits a {Transfer} event for each mint.
1473      */
1474     function _safeMint(
1475         address to,
1476         uint256 quantity,
1477         bytes memory _data
1478     ) internal virtual {
1479         _mint(to, quantity);
1480 
1481         unchecked {
1482             if (to.code.length != 0) {
1483                 uint256 end = _currentIndex;
1484                 uint256 index = end - quantity;
1485                 do {
1486                     if (
1487                         !_checkContractOnERC721Received(
1488                             address(0),
1489                             to,
1490                             index++,
1491                             _data
1492                         )
1493                     ) {
1494                         revert TransferToNonERC721ReceiverImplementer();
1495                     }
1496                 } while (index < end);
1497                 // Reentrancy protection.
1498                 if (_currentIndex != end) revert();
1499             }
1500         }
1501     }
1502 
1503     /**
1504      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1505      */
1506     function _safeMint(address to, uint256 quantity) internal virtual {
1507         _safeMint(to, quantity, "");
1508     }
1509 
1510     // =============================================================
1511     //                        BURN OPERATIONS
1512     // =============================================================
1513 
1514     /**
1515      * @dev Equivalent to `_burn(tokenId, false)`.
1516      */
1517     function _burn(uint256 tokenId) internal virtual {
1518         _burn(tokenId, false);
1519     }
1520 
1521     /**
1522      * @dev Destroys `tokenId`.
1523      * The approval is cleared when the token is burned.
1524      *
1525      * Requirements:
1526      *
1527      * - `tokenId` must exist.
1528      *
1529      * Emits a {Transfer} event.
1530      */
1531     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1532         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1533 
1534         address from = address(uint160(prevOwnershipPacked));
1535 
1536         (
1537             uint256 approvedAddressSlot,
1538             address approvedAddress
1539         ) = _getApprovedSlotAndAddress(tokenId);
1540 
1541         if (approvalCheck) {
1542             // The nested ifs save around 20+ gas over a compound boolean condition.
1543             if (
1544                 !_isSenderApprovedOrOwner(
1545                     approvedAddress,
1546                     from,
1547                     _msgSenderERC721A()
1548                 )
1549             )
1550                 if (!isApprovedForAll(from, _msgSenderERC721A()))
1551                     revert TransferCallerNotOwnerNorApproved();
1552         }
1553 
1554         _beforeTokenTransfers(from, address(0), tokenId, 1);
1555 
1556         // Clear approvals from the previous owner.
1557         assembly {
1558             if approvedAddress {
1559                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1560                 sstore(approvedAddressSlot, 0)
1561             }
1562         }
1563 
1564         // Underflow of the sender's balance is impossible because we check for
1565         // ownership above and the recipient's balance can't realistically overflow.
1566         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1567         unchecked {
1568             // Updates:
1569             // - `balance -= 1`.
1570             // - `numberBurned += 1`.
1571             //
1572             // We can directly decrement the balance, and increment the number burned.
1573             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1574             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1575 
1576             // Updates:
1577             // - `address` to the last owner.
1578             // - `startTimestamp` to the timestamp of burning.
1579             // - `burned` to `true`.
1580             // - `nextInitialized` to `true`.
1581             _packedOwnerships[tokenId] = _packOwnershipData(
1582                 from,
1583                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) |
1584                     _nextExtraData(from, address(0), prevOwnershipPacked)
1585             );
1586 
1587             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1588             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1589                 uint256 nextTokenId = tokenId + 1;
1590                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1591                 if (_packedOwnerships[nextTokenId] == 0) {
1592                     // If the next slot is within bounds.
1593                     if (nextTokenId != _currentIndex) {
1594                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1595                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1596                     }
1597                 }
1598             }
1599         }
1600 
1601         emit Transfer(from, address(0), tokenId);
1602         _afterTokenTransfers(from, address(0), tokenId, 1);
1603 
1604         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1605         unchecked {
1606             _burnCounter++;
1607         }
1608     }
1609 
1610     // =============================================================
1611     //                     EXTRA DATA OPERATIONS
1612     // =============================================================
1613 
1614     /**
1615      * @dev Directly sets the extra data for the ownership data `index`.
1616      */
1617     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1618         uint256 packed = _packedOwnerships[index];
1619         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1620         uint256 extraDataCasted;
1621         // Cast `extraData` with assembly to avoid redundant masking.
1622         assembly {
1623             extraDataCasted := extraData
1624         }
1625         packed =
1626             (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) |
1627             (extraDataCasted << _BITPOS_EXTRA_DATA);
1628         _packedOwnerships[index] = packed;
1629     }
1630 
1631     /**
1632      * @dev Called during each token transfer to set the 24bit `extraData` field.
1633      * Intended to be overridden by the cosumer contract.
1634      *
1635      * `previousExtraData` - the value of `extraData` before transfer.
1636      *
1637      * Calling conditions:
1638      *
1639      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1640      * transferred to `to`.
1641      * - When `from` is zero, `tokenId` will be minted for `to`.
1642      * - When `to` is zero, `tokenId` will be burned by `from`.
1643      * - `from` and `to` are never both zero.
1644      */
1645     function _extraData(
1646         address from,
1647         address to,
1648         uint24 previousExtraData
1649     ) internal view virtual returns (uint24) {}
1650 
1651     /**
1652      * @dev Returns the next extra data for the packed ownership data.
1653      * The returned result is shifted into position.
1654      */
1655     function _nextExtraData(
1656         address from,
1657         address to,
1658         uint256 prevOwnershipPacked
1659     ) private view returns (uint256) {
1660         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1661         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1662     }
1663 
1664     // =============================================================
1665     //                       OTHER OPERATIONS
1666     // =============================================================
1667 
1668     /**
1669      * @dev Returns the message sender (defaults to `msg.sender`).
1670      *
1671      * If you are writing GSN compatible contracts, you need to override this function.
1672      */
1673     function _msgSenderERC721A() internal view virtual returns (address) {
1674         return msg.sender;
1675     }
1676 
1677     /**
1678      * @dev Converts a uint256 to its ASCII string decimal representation.
1679      */
1680     function _toString(uint256 value)
1681         internal
1682         pure
1683         virtual
1684         returns (string memory str)
1685     {
1686         assembly {
1687             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1688             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1689             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1690             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1691             let m := add(mload(0x40), 0xa0)
1692             // Update the free memory pointer to allocate.
1693             mstore(0x40, m)
1694             // Assign the `str` to the end.
1695             str := sub(m, 0x20)
1696             // Zeroize the slot after the string.
1697             mstore(str, 0)
1698 
1699             // Cache the end of the memory to calculate the length later.
1700             let end := str
1701 
1702             // We write the string from rightmost digit to leftmost digit.
1703             // The following is essentially a do-while loop that also handles the zero case.
1704             // prettier-ignore
1705             for { let temp := value } 1 {} {
1706                 str := sub(str, 1)
1707                 // Write the character to the pointer.
1708                 // The ASCII index of the '0' character is 48.
1709                 mstore8(str, add(48, mod(temp, 10)))
1710                 // Keep dividing `temp` until zero.
1711                 temp := div(temp, 10)
1712                 // prettier-ignore
1713                 if iszero(temp) { break }
1714             }
1715 
1716             let length := sub(end, str)
1717             // Move the pointer 32 bytes leftwards to make room for the length.
1718             str := sub(str, 0x20)
1719             // Store the length.
1720             mstore(str, length)
1721         }
1722     }
1723 }
1724 
1725 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/extensions/IERC721AQueryable.sol
1726 
1727 // ERC721A Contracts v4.2.2
1728 // Creator: Chiru Labs
1729 
1730 pragma solidity ^0.8.4;
1731 
1732 /**
1733  * @dev Interface of ERC721AQueryable.
1734  */
1735 interface IERC721AQueryable is IERC721A {
1736     /**
1737      * Invalid query range (`start` >= `stop`).
1738      */
1739     error InvalidQueryRange();
1740 
1741     /**
1742      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1743      *
1744      * If the `tokenId` is out of bounds:
1745      *
1746      * - `addr = address(0)`
1747      * - `startTimestamp = 0`
1748      * - `burned = false`
1749      * - `extraData = 0`
1750      *
1751      * If the `tokenId` is burned:
1752      *
1753      * - `addr = <Address of owner before token was burned>`
1754      * - `startTimestamp = <Timestamp when token was burned>`
1755      * - `burned = true`
1756      * - `extraData = <Extra data when token was burned>`
1757      *
1758      * Otherwise:
1759      *
1760      * - `addr = <Address of owner>`
1761      * - `startTimestamp = <Timestamp of start of ownership>`
1762      * - `burned = false`
1763      * - `extraData = <Extra data at start of ownership>`
1764      */
1765     function explicitOwnershipOf(uint256 tokenId)
1766         external
1767         view
1768         returns (TokenOwnership memory);
1769 
1770     /**
1771      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1772      * See {ERC721AQueryable-explicitOwnershipOf}
1773      */
1774     function explicitOwnershipsOf(uint256[] memory tokenIds)
1775         external
1776         view
1777         returns (TokenOwnership[] memory);
1778 
1779     /**
1780      * @dev Returns an array of token IDs owned by `owner`,
1781      * in the range [`start`, `stop`)
1782      * (i.e. `start <= tokenId < stop`).
1783      *
1784      * This function allows for tokens to be queried if the collection
1785      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1786      *
1787      * Requirements:
1788      *
1789      * - `start < stop`
1790      */
1791     function tokensOfOwnerIn(
1792         address owner,
1793         uint256 start,
1794         uint256 stop
1795     ) external view returns (uint256[] memory);
1796 
1797     /**
1798      * @dev Returns an array of token IDs owned by `owner`.
1799      *
1800      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
1801      * It is meant to be called off-chain.
1802      *
1803      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1804      * multiple smaller scans if the collection is large enough to cause
1805      * an out-of-gas error (10K collections should be fine).
1806      */
1807     function tokensOfOwner(address owner)
1808         external
1809         view
1810         returns (uint256[] memory);
1811 }
1812 
1813 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/extensions/ERC721AQueryable.sol
1814 
1815 // ERC721A Contracts v4.2.2
1816 // Creator: Chiru Labs
1817 
1818 pragma solidity ^0.8.4;
1819 
1820 /**
1821  * @title ERC721AQueryable.
1822  *
1823  * @dev ERC721A subclass with convenience query functions.
1824  */
1825 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1826     /**
1827      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1828      *
1829      * If the `tokenId` is out of bounds:
1830      *
1831      * - `addr = address(0)`
1832      * - `startTimestamp = 0`
1833      * - `burned = false`
1834      * - `extraData = 0`
1835      *
1836      * If the `tokenId` is burned:
1837      *
1838      * - `addr = <Address of owner before token was burned>`
1839      * - `startTimestamp = <Timestamp when token was burned>`
1840      * - `burned = true`
1841      * - `extraData = <Extra data when token was burned>`
1842      *
1843      * Otherwise:
1844      *
1845      * - `addr = <Address of owner>`
1846      * - `startTimestamp = <Timestamp of start of ownership>`
1847      * - `burned = false`
1848      * - `extraData = <Extra data at start of ownership>`
1849      */
1850     function explicitOwnershipOf(uint256 tokenId)
1851         public
1852         view
1853         virtual
1854         override
1855         returns (TokenOwnership memory)
1856     {
1857         TokenOwnership memory ownership;
1858         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1859             return ownership;
1860         }
1861         ownership = _ownershipAt(tokenId);
1862         if (ownership.burned) {
1863             return ownership;
1864         }
1865         return _ownershipOf(tokenId);
1866     }
1867 
1868     /**
1869      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1870      * See {ERC721AQueryable-explicitOwnershipOf}
1871      */
1872     function explicitOwnershipsOf(uint256[] calldata tokenIds)
1873         external
1874         view
1875         virtual
1876         override
1877         returns (TokenOwnership[] memory)
1878     {
1879         unchecked {
1880             uint256 tokenIdsLength = tokenIds.length;
1881             TokenOwnership[] memory ownerships = new TokenOwnership[](
1882                 tokenIdsLength
1883             );
1884             for (uint256 i; i != tokenIdsLength; ++i) {
1885                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1886             }
1887             return ownerships;
1888         }
1889     }
1890 
1891     /**
1892      * @dev Returns an array of token IDs owned by `owner`,
1893      * in the range [`start`, `stop`)
1894      * (i.e. `start <= tokenId < stop`).
1895      *
1896      * This function allows for tokens to be queried if the collection
1897      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1898      *
1899      * Requirements:
1900      *
1901      * - `start < stop`
1902      */
1903     function tokensOfOwnerIn(
1904         address owner,
1905         uint256 start,
1906         uint256 stop
1907     ) external view virtual override returns (uint256[] memory) {
1908         unchecked {
1909             if (start >= stop) revert InvalidQueryRange();
1910             uint256 tokenIdsIdx;
1911             uint256 stopLimit = _nextTokenId();
1912             // Set `start = max(start, _startTokenId())`.
1913             if (start < _startTokenId()) {
1914                 start = _startTokenId();
1915             }
1916             // Set `stop = min(stop, stopLimit)`.
1917             if (stop > stopLimit) {
1918                 stop = stopLimit;
1919             }
1920             uint256 tokenIdsMaxLength = balanceOf(owner);
1921             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1922             // to cater for cases where `balanceOf(owner)` is too big.
1923             if (start < stop) {
1924                 uint256 rangeLength = stop - start;
1925                 if (rangeLength < tokenIdsMaxLength) {
1926                     tokenIdsMaxLength = rangeLength;
1927                 }
1928             } else {
1929                 tokenIdsMaxLength = 0;
1930             }
1931             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1932             if (tokenIdsMaxLength == 0) {
1933                 return tokenIds;
1934             }
1935             // We need to call `explicitOwnershipOf(start)`,
1936             // because the slot at `start` may not be initialized.
1937             TokenOwnership memory ownership = explicitOwnershipOf(start);
1938             address currOwnershipAddr;
1939             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1940             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1941             if (!ownership.burned) {
1942                 currOwnershipAddr = ownership.addr;
1943             }
1944             for (
1945                 uint256 i = start;
1946                 i != stop && tokenIdsIdx != tokenIdsMaxLength;
1947                 ++i
1948             ) {
1949                 ownership = _ownershipAt(i);
1950                 if (ownership.burned) {
1951                     continue;
1952                 }
1953                 if (ownership.addr != address(0)) {
1954                     currOwnershipAddr = ownership.addr;
1955                 }
1956                 if (currOwnershipAddr == owner) {
1957                     tokenIds[tokenIdsIdx++] = i;
1958                 }
1959             }
1960             // Downsize the array to fit.
1961             assembly {
1962                 mstore(tokenIds, tokenIdsIdx)
1963             }
1964             return tokenIds;
1965         }
1966     }
1967 
1968     /**
1969      * @dev Returns an array of token IDs owned by `owner`.
1970      *
1971      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
1972      * It is meant to be called off-chain.
1973      *
1974      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1975      * multiple smaller scans if the collection is large enough to cause
1976      * an out-of-gas error (10K collections should be fine).
1977      */
1978     function tokensOfOwner(address owner)
1979         external
1980         view
1981         virtual
1982         override
1983         returns (uint256[] memory)
1984     {
1985         unchecked {
1986             uint256 tokenIdsIdx;
1987             address currOwnershipAddr;
1988             uint256 tokenIdsLength = balanceOf(owner);
1989             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1990             TokenOwnership memory ownership;
1991             for (
1992                 uint256 i = _startTokenId();
1993                 tokenIdsIdx != tokenIdsLength;
1994                 ++i
1995             ) {
1996                 ownership = _ownershipAt(i);
1997                 if (ownership.burned) {
1998                     continue;
1999                 }
2000                 if (ownership.addr != address(0)) {
2001                     currOwnershipAddr = ownership.addr;
2002                 }
2003                 if (currOwnershipAddr == owner) {
2004                     tokenIds[tokenIdsIdx++] = i;
2005                 }
2006             }
2007             return tokenIds;
2008         }
2009     }
2010 }
2011 
2012 // File: https://github.com/transmissions11/solmate/blob/main/src/auth/Owned.sol
2013 
2014 pragma solidity >=0.8.0;
2015 
2016 /// @notice Simple single owner authorization mixin.
2017 /// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/auth/Owned.sol)
2018 abstract contract Owned {
2019     /*//////////////////////////////////////////////////////////////
2020                                  EVENTS
2021     //////////////////////////////////////////////////////////////*/
2022 
2023     event OwnerUpdated(address indexed user, address indexed newOwner);
2024 
2025     /*//////////////////////////////////////////////////////////////
2026                             OWNERSHIP STORAGE
2027     //////////////////////////////////////////////////////////////*/
2028 
2029     address public owner;
2030 
2031     modifier onlyOwner() virtual {
2032         require(msg.sender == owner, "UNAUTHORIZED");
2033 
2034         _;
2035     }
2036 
2037     /*//////////////////////////////////////////////////////////////
2038                                CONSTRUCTOR
2039     //////////////////////////////////////////////////////////////*/
2040 
2041     constructor(address _owner) {
2042         owner = _owner;
2043 
2044         emit OwnerUpdated(address(0), _owner);
2045     }
2046 
2047     /*//////////////////////////////////////////////////////////////
2048                              OWNERSHIP LOGIC
2049     //////////////////////////////////////////////////////////////*/
2050 
2051     function setOwner(address newOwner) public virtual onlyOwner {
2052         owner = newOwner;
2053 
2054         emit OwnerUpdated(msg.sender, newOwner);
2055     }
2056 }
2057 
2058 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
2059 
2060 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
2061 
2062 pragma solidity ^0.8.0;
2063 
2064 /**
2065  * @dev String operations.
2066  */
2067 library Strings {
2068     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
2069     uint8 private constant _ADDRESS_LENGTH = 20;
2070 
2071     /**
2072      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
2073      */
2074     function toString(uint256 value) internal pure returns (string memory) {
2075         // Inspired by OraclizeAPI's implementation - MIT licence
2076         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
2077 
2078         if (value == 0) {
2079             return "0";
2080         }
2081         uint256 temp = value;
2082         uint256 digits;
2083         while (temp != 0) {
2084             digits++;
2085             temp /= 10;
2086         }
2087         bytes memory buffer = new bytes(digits);
2088         while (value != 0) {
2089             digits -= 1;
2090             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
2091             value /= 10;
2092         }
2093         return string(buffer);
2094     }
2095 
2096     /**
2097      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
2098      */
2099     function toHexString(uint256 value) internal pure returns (string memory) {
2100         if (value == 0) {
2101             return "0x00";
2102         }
2103         uint256 temp = value;
2104         uint256 length = 0;
2105         while (temp != 0) {
2106             length++;
2107             temp >>= 8;
2108         }
2109         return toHexString(value, length);
2110     }
2111 
2112     /**
2113      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
2114      */
2115     function toHexString(uint256 value, uint256 length)
2116         internal
2117         pure
2118         returns (string memory)
2119     {
2120         bytes memory buffer = new bytes(2 * length + 2);
2121         buffer[0] = "0";
2122         buffer[1] = "x";
2123         for (uint256 i = 2 * length + 1; i > 1; --i) {
2124             buffer[i] = _HEX_SYMBOLS[value & 0xf];
2125             value >>= 4;
2126         }
2127         require(value == 0, "Strings: hex length insufficient");
2128         return string(buffer);
2129     }
2130 
2131     /**
2132      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
2133      */
2134     function toHexString(address addr) internal pure returns (string memory) {
2135         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
2136     }
2137 }
2138 
2139 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
2140 
2141 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
2142 
2143 pragma solidity ^0.8.0;
2144 
2145 /**
2146  * @dev Provides information about the current execution context, including the
2147  * sender of the transaction and its data. While these are generally available
2148  * via msg.sender and msg.data, they should not be accessed in such a direct
2149  * manner, since when dealing with meta-transactions the account sending and
2150  * paying for execution may not be the actual sender (as far as an application
2151  * is concerned).
2152  *
2153  * This contract is only required for intermediate, library-like contracts.
2154  */
2155 abstract contract Context {
2156     function _msgSender() internal view virtual returns (address) {
2157         return msg.sender;
2158     }
2159 
2160     function _msgData() internal view virtual returns (bytes calldata) {
2161         return msg.data;
2162     }
2163 }
2164 
2165 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol
2166 
2167 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
2168 
2169 pragma solidity ^0.8.1;
2170 
2171 /**
2172  * @dev Collection of functions related to the address type
2173  */
2174 library Address {
2175     /**
2176      * @dev Returns true if `account` is a contract.
2177      *
2178      * [IMPORTANT]
2179      * ====
2180      * It is unsafe to assume that an address for which this function returns
2181      * false is an externally-owned account (EOA) and not a contract.
2182      *
2183      * Among others, `isContract` will return false for the following
2184      * types of addresses:
2185      *
2186      *  - an externally-owned account
2187      *  - a contract in construction
2188      *  - an address where a contract will be created
2189      *  - an address where a contract lived, but was destroyed
2190      * ====
2191      *
2192      * [IMPORTANT]
2193      * ====
2194      * You shouldn't rely on `isContract` to protect against flash loan attacks!
2195      *
2196      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
2197      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
2198      * constructor.
2199      * ====
2200      */
2201     function isContract(address account) internal view returns (bool) {
2202         // This method relies on extcodesize/address.code.length, which returns 0
2203         // for contracts in construction, since the code is only stored at the end
2204         // of the constructor execution.
2205 
2206         return account.code.length > 0;
2207     }
2208 
2209     /**
2210      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
2211      * `recipient`, forwarding all available gas and reverting on errors.
2212      *
2213      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
2214      * of certain opcodes, possibly making contracts go over the 2300 gas limit
2215      * imposed by `transfer`, making them unable to receive funds via
2216      * `transfer`. {sendValue} removes this limitation.
2217      *
2218      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
2219      *
2220      * IMPORTANT: because control is transferred to `recipient`, care must be
2221      * taken to not create reentrancy vulnerabilities. Consider using
2222      * {ReentrancyGuard} or the
2223      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
2224      */
2225     function sendValue(address payable recipient, uint256 amount) internal {
2226         require(
2227             address(this).balance >= amount,
2228             "Address: insufficient balance"
2229         );
2230 
2231         (bool success, ) = recipient.call{value: amount}("");
2232         require(
2233             success,
2234             "Address: unable to send value, recipient may have reverted"
2235         );
2236     }
2237 
2238     /**
2239      * @dev Performs a Solidity function call using a low level `call`. A
2240      * plain `call` is an unsafe replacement for a function call: use this
2241      * function instead.
2242      *
2243      * If `target` reverts with a revert reason, it is bubbled up by this
2244      * function (like regular Solidity function calls).
2245      *
2246      * Returns the raw returned data. To convert to the expected return value,
2247      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
2248      *
2249      * Requirements:
2250      *
2251      * - `target` must be a contract.
2252      * - calling `target` with `data` must not revert.
2253      *
2254      * _Available since v3.1._
2255      */
2256     function functionCall(address target, bytes memory data)
2257         internal
2258         returns (bytes memory)
2259     {
2260         return
2261             functionCallWithValue(
2262                 target,
2263                 data,
2264                 0,
2265                 "Address: low-level call failed"
2266             );
2267     }
2268 
2269     /**
2270      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
2271      * `errorMessage` as a fallback revert reason when `target` reverts.
2272      *
2273      * _Available since v3.1._
2274      */
2275     function functionCall(
2276         address target,
2277         bytes memory data,
2278         string memory errorMessage
2279     ) internal returns (bytes memory) {
2280         return functionCallWithValue(target, data, 0, errorMessage);
2281     }
2282 
2283     /**
2284      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
2285      * but also transferring `value` wei to `target`.
2286      *
2287      * Requirements:
2288      *
2289      * - the calling contract must have an ETH balance of at least `value`.
2290      * - the called Solidity function must be `payable`.
2291      *
2292      * _Available since v3.1._
2293      */
2294     function functionCallWithValue(
2295         address target,
2296         bytes memory data,
2297         uint256 value
2298     ) internal returns (bytes memory) {
2299         return
2300             functionCallWithValue(
2301                 target,
2302                 data,
2303                 value,
2304                 "Address: low-level call with value failed"
2305             );
2306     }
2307 
2308     /**
2309      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
2310      * with `errorMessage` as a fallback revert reason when `target` reverts.
2311      *
2312      * _Available since v3.1._
2313      */
2314     function functionCallWithValue(
2315         address target,
2316         bytes memory data,
2317         uint256 value,
2318         string memory errorMessage
2319     ) internal returns (bytes memory) {
2320         require(
2321             address(this).balance >= value,
2322             "Address: insufficient balance for call"
2323         );
2324         (bool success, bytes memory returndata) = target.call{value: value}(
2325             data
2326         );
2327         return
2328             verifyCallResultFromTarget(
2329                 target,
2330                 success,
2331                 returndata,
2332                 errorMessage
2333             );
2334     }
2335 
2336     /**
2337      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
2338      * but performing a static call.
2339      *
2340      * _Available since v3.3._
2341      */
2342     function functionStaticCall(address target, bytes memory data)
2343         internal
2344         view
2345         returns (bytes memory)
2346     {
2347         return
2348             functionStaticCall(
2349                 target,
2350                 data,
2351                 "Address: low-level static call failed"
2352             );
2353     }
2354 
2355     /**
2356      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
2357      * but performing a static call.
2358      *
2359      * _Available since v3.3._
2360      */
2361     function functionStaticCall(
2362         address target,
2363         bytes memory data,
2364         string memory errorMessage
2365     ) internal view returns (bytes memory) {
2366         (bool success, bytes memory returndata) = target.staticcall(data);
2367         return
2368             verifyCallResultFromTarget(
2369                 target,
2370                 success,
2371                 returndata,
2372                 errorMessage
2373             );
2374     }
2375 
2376     /**
2377      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
2378      * but performing a delegate call.
2379      *
2380      * _Available since v3.4._
2381      */
2382     function functionDelegateCall(address target, bytes memory data)
2383         internal
2384         returns (bytes memory)
2385     {
2386         return
2387             functionDelegateCall(
2388                 target,
2389                 data,
2390                 "Address: low-level delegate call failed"
2391             );
2392     }
2393 
2394     /**
2395      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
2396      * but performing a delegate call.
2397      *
2398      * _Available since v3.4._
2399      */
2400     function functionDelegateCall(
2401         address target,
2402         bytes memory data,
2403         string memory errorMessage
2404     ) internal returns (bytes memory) {
2405         (bool success, bytes memory returndata) = target.delegatecall(data);
2406         return
2407             verifyCallResultFromTarget(
2408                 target,
2409                 success,
2410                 returndata,
2411                 errorMessage
2412             );
2413     }
2414 
2415     /**
2416      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
2417      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
2418      *
2419      * _Available since v4.8._
2420      */
2421     function verifyCallResultFromTarget(
2422         address target,
2423         bool success,
2424         bytes memory returndata,
2425         string memory errorMessage
2426     ) internal view returns (bytes memory) {
2427         if (success) {
2428             if (returndata.length == 0) {
2429                 // only check isContract if the call was successful and the return data is empty
2430                 // otherwise we already know that it was a contract
2431                 require(isContract(target), "Address: call to non-contract");
2432             }
2433             return returndata;
2434         } else {
2435             _revert(returndata, errorMessage);
2436         }
2437     }
2438 
2439     /**
2440      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
2441      * revert reason or using the provided one.
2442      *
2443      * _Available since v4.3._
2444      */
2445     function verifyCallResult(
2446         bool success,
2447         bytes memory returndata,
2448         string memory errorMessage
2449     ) internal pure returns (bytes memory) {
2450         if (success) {
2451             return returndata;
2452         } else {
2453             _revert(returndata, errorMessage);
2454         }
2455     }
2456 
2457     function _revert(bytes memory returndata, string memory errorMessage)
2458         private
2459         pure
2460     {
2461         // Look for revert reason and bubble it up if present
2462         if (returndata.length > 0) {
2463             // The easiest way to bubble the revert reason is using memory via assembly
2464             /// @solidity memory-safe-assembly
2465             assembly {
2466                 let returndata_size := mload(returndata)
2467                 revert(add(32, returndata), returndata_size)
2468             }
2469         } else {
2470             revert(errorMessage);
2471         }
2472     }
2473 }
2474 
2475 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721Receiver.sol
2476 
2477 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
2478 
2479 pragma solidity ^0.8.0;
2480 
2481 /**
2482  * @title ERC721 token receiver interface
2483  * @dev Interface for any contract that wants to support safeTransfers
2484  * from ERC721 asset contracts.
2485  */
2486 interface IERC721Receiver {
2487     /**
2488      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
2489      * by `operator` from `from`, this function is called.
2490      *
2491      * It must return its Solidity selector to confirm the token transfer.
2492      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
2493      *
2494      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
2495      */
2496     function onERC721Received(
2497         address operator,
2498         address from,
2499         uint256 tokenId,
2500         bytes calldata data
2501     ) external returns (bytes4);
2502 }
2503 
2504 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/IERC165.sol
2505 
2506 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
2507 
2508 pragma solidity ^0.8.0;
2509 
2510 /**
2511  * @dev Interface of the ERC165 standard, as defined in the
2512  * https://eips.ethereum.org/EIPS/eip-165[EIP].
2513  *
2514  * Implementers can declare support of contract interfaces, which can then be
2515  * queried by others ({ERC165Checker}).
2516  *
2517  * For an implementation, see {ERC165}.
2518  */
2519 interface IERC165 {
2520     /**
2521      * @dev Returns true if this contract implements the interface defined by
2522      * `interfaceId`. See the corresponding
2523      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
2524      * to learn more about how these ids are created.
2525      *
2526      * This function call must use less than 30 000 gas.
2527      */
2528     function supportsInterface(bytes4 interfaceId) external view returns (bool);
2529 }
2530 
2531 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/ERC165.sol
2532 
2533 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
2534 
2535 pragma solidity ^0.8.0;
2536 
2537 /**
2538  * @dev Implementation of the {IERC165} interface.
2539  *
2540  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
2541  * for the additional interface id that will be supported. For example:
2542  *
2543  * ```solidity
2544  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2545  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
2546  * }
2547  * ```
2548  *
2549  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
2550  */
2551 abstract contract ERC165 is IERC165 {
2552     /**
2553      * @dev See {IERC165-supportsInterface}.
2554      */
2555     function supportsInterface(bytes4 interfaceId)
2556         public
2557         view
2558         virtual
2559         override
2560         returns (bool)
2561     {
2562         return interfaceId == type(IERC165).interfaceId;
2563     }
2564 }
2565 
2566 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721.sol
2567 
2568 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
2569 
2570 pragma solidity ^0.8.0;
2571 
2572 /**
2573  * @dev Required interface of an ERC721 compliant contract.
2574  */
2575 interface IERC721 is IERC165 {
2576     /**
2577      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
2578      */
2579     event Transfer(
2580         address indexed from,
2581         address indexed to,
2582         uint256 indexed tokenId
2583     );
2584 
2585     /**
2586      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
2587      */
2588     event Approval(
2589         address indexed owner,
2590         address indexed approved,
2591         uint256 indexed tokenId
2592     );
2593 
2594     /**
2595      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
2596      */
2597     event ApprovalForAll(
2598         address indexed owner,
2599         address indexed operator,
2600         bool approved
2601     );
2602 
2603     /**
2604      * @dev Returns the number of tokens in ``owner``'s account.
2605      */
2606     function balanceOf(address owner) external view returns (uint256 balance);
2607 
2608     /**
2609      * @dev Returns the owner of the `tokenId` token.
2610      *
2611      * Requirements:
2612      *
2613      * - `tokenId` must exist.
2614      */
2615     function ownerOf(uint256 tokenId) external view returns (address owner);
2616 
2617     /**
2618      * @dev Safely transfers `tokenId` token from `from` to `to`.
2619      *
2620      * Requirements:
2621      *
2622      * - `from` cannot be the zero address.
2623      * - `to` cannot be the zero address.
2624      * - `tokenId` token must exist and be owned by `from`.
2625      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
2626      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2627      *
2628      * Emits a {Transfer} event.
2629      */
2630     function safeTransferFrom(
2631         address from,
2632         address to,
2633         uint256 tokenId,
2634         bytes calldata data
2635     ) external;
2636 
2637     /**
2638      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
2639      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
2640      *
2641      * Requirements:
2642      *
2643      * - `from` cannot be the zero address.
2644      * - `to` cannot be the zero address.
2645      * - `tokenId` token must exist and be owned by `from`.
2646      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
2647      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2648      *
2649      * Emits a {Transfer} event.
2650      */
2651     function safeTransferFrom(
2652         address from,
2653         address to,
2654         uint256 tokenId
2655     ) external;
2656 
2657     /**
2658      * @dev Transfers `tokenId` token from `from` to `to`.
2659      *
2660      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
2661      *
2662      * Requirements:
2663      *
2664      * - `from` cannot be the zero address.
2665      * - `to` cannot be the zero address.
2666      * - `tokenId` token must be owned by `from`.
2667      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
2668      *
2669      * Emits a {Transfer} event.
2670      */
2671     function transferFrom(
2672         address from,
2673         address to,
2674         uint256 tokenId
2675     ) external;
2676 
2677     /**
2678      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
2679      * The approval is cleared when the token is transferred.
2680      *
2681      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
2682      *
2683      * Requirements:
2684      *
2685      * - The caller must own the token or be an approved operator.
2686      * - `tokenId` must exist.
2687      *
2688      * Emits an {Approval} event.
2689      */
2690     function approve(address to, uint256 tokenId) external;
2691 
2692     /**
2693      * @dev Approve or remove `operator` as an operator for the caller.
2694      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
2695      *
2696      * Requirements:
2697      *
2698      * - The `operator` cannot be the caller.
2699      *
2700      * Emits an {ApprovalForAll} event.
2701      */
2702     function setApprovalForAll(address operator, bool _approved) external;
2703 
2704     /**
2705      * @dev Returns the account approved for `tokenId` token.
2706      *
2707      * Requirements:
2708      *
2709      * - `tokenId` must exist.
2710      */
2711     function getApproved(uint256 tokenId)
2712         external
2713         view
2714         returns (address operator);
2715 
2716     /**
2717      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
2718      *
2719      * See {setApprovalForAll}
2720      */
2721     function isApprovedForAll(address owner, address operator)
2722         external
2723         view
2724         returns (bool);
2725 }
2726 
2727 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/IERC721Metadata.sol
2728 
2729 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
2730 
2731 pragma solidity ^0.8.0;
2732 
2733 /**
2734  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
2735  * @dev See https://eips.ethereum.org/EIPS/eip-721
2736  */
2737 interface IERC721Metadata is IERC721 {
2738     /**
2739      * @dev Returns the token collection name.
2740      */
2741     function name() external view returns (string memory);
2742 
2743     /**
2744      * @dev Returns the token collection symbol.
2745      */
2746     function symbol() external view returns (string memory);
2747 
2748     /**
2749      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
2750      */
2751     function tokenURI(uint256 tokenId) external view returns (string memory);
2752 }
2753 
2754 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol
2755 
2756 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
2757 
2758 pragma solidity ^0.8.0;
2759 
2760 /**
2761  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
2762  * the Metadata extension, but not including the Enumerable extension, which is available separately as
2763  * {ERC721Enumerable}.
2764  */
2765 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
2766     using Address for address;
2767     using Strings for uint256;
2768 
2769     // Token name
2770     string private _name;
2771 
2772     // Token symbol
2773     string private _symbol;
2774 
2775     // Mapping from token ID to owner address
2776     mapping(uint256 => address) private _owners;
2777 
2778     // Mapping owner address to token count
2779     mapping(address => uint256) private _balances;
2780 
2781     // Mapping from token ID to approved address
2782     mapping(uint256 => address) private _tokenApprovals;
2783 
2784     // Mapping from owner to operator approvals
2785     mapping(address => mapping(address => bool)) private _operatorApprovals;
2786 
2787     /**
2788      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
2789      */
2790     constructor(string memory name_, string memory symbol_) {
2791         _name = name_;
2792         _symbol = symbol_;
2793     }
2794 
2795     /**
2796      * @dev See {IERC165-supportsInterface}.
2797      */
2798     function supportsInterface(bytes4 interfaceId)
2799         public
2800         view
2801         virtual
2802         override(ERC165, IERC165)
2803         returns (bool)
2804     {
2805         return
2806             interfaceId == type(IERC721).interfaceId ||
2807             interfaceId == type(IERC721Metadata).interfaceId ||
2808             super.supportsInterface(interfaceId);
2809     }
2810 
2811     /**
2812      * @dev See {IERC721-balanceOf}.
2813      */
2814     function balanceOf(address owner)
2815         public
2816         view
2817         virtual
2818         override
2819         returns (uint256)
2820     {
2821         require(
2822             owner != address(0),
2823             "ERC721: address zero is not a valid owner"
2824         );
2825         return _balances[owner];
2826     }
2827 
2828     /**
2829      * @dev See {IERC721-ownerOf}.
2830      */
2831     function ownerOf(uint256 tokenId)
2832         public
2833         view
2834         virtual
2835         override
2836         returns (address)
2837     {
2838         address owner = _owners[tokenId];
2839         require(owner != address(0), "ERC721: invalid token ID");
2840         return owner;
2841     }
2842 
2843     /**
2844      * @dev See {IERC721Metadata-name}.
2845      */
2846     function name() public view virtual override returns (string memory) {
2847         return _name;
2848     }
2849 
2850     /**
2851      * @dev See {IERC721Metadata-symbol}.
2852      */
2853     function symbol() public view virtual override returns (string memory) {
2854         return _symbol;
2855     }
2856 
2857     /**
2858      * @dev See {IERC721Metadata-tokenURI}.
2859      */
2860     function tokenURI(uint256 tokenId)
2861         public
2862         view
2863         virtual
2864         override
2865         returns (string memory)
2866     {
2867         _requireMinted(tokenId);
2868 
2869         string memory baseURI = _baseURI();
2870         return
2871             bytes(baseURI).length > 0
2872                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
2873                 : "";
2874     }
2875 
2876     /**
2877      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
2878      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
2879      * by default, can be overridden in child contracts.
2880      */
2881     function _baseURI() internal view virtual returns (string memory) {
2882         return "";
2883     }
2884 
2885     /**
2886      * @dev See {IERC721-approve}.
2887      */
2888     function approve(address to, uint256 tokenId) public virtual override {
2889         address owner = ERC721.ownerOf(tokenId);
2890         require(to != owner, "ERC721: approval to current owner");
2891 
2892         require(
2893             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
2894             "ERC721: approve caller is not token owner or approved for all"
2895         );
2896 
2897         _approve(to, tokenId);
2898     }
2899 
2900     /**
2901      * @dev See {IERC721-getApproved}.
2902      */
2903     function getApproved(uint256 tokenId)
2904         public
2905         view
2906         virtual
2907         override
2908         returns (address)
2909     {
2910         _requireMinted(tokenId);
2911 
2912         return _tokenApprovals[tokenId];
2913     }
2914 
2915     /**
2916      * @dev See {IERC721-setApprovalForAll}.
2917      */
2918     function setApprovalForAll(address operator, bool approved)
2919         public
2920         virtual
2921         override
2922     {
2923         _setApprovalForAll(_msgSender(), operator, approved);
2924     }
2925 
2926     /**
2927      * @dev See {IERC721-isApprovedForAll}.
2928      */
2929     function isApprovedForAll(address owner, address operator)
2930         public
2931         view
2932         virtual
2933         override
2934         returns (bool)
2935     {
2936         return _operatorApprovals[owner][operator];
2937     }
2938 
2939     /**
2940      * @dev See {IERC721-transferFrom}.
2941      */
2942     function transferFrom(
2943         address from,
2944         address to,
2945         uint256 tokenId
2946     ) public virtual override {
2947         //solhint-disable-next-line max-line-length
2948         require(
2949             _isApprovedOrOwner(_msgSender(), tokenId),
2950             "ERC721: caller is not token owner or approved"
2951         );
2952 
2953         _transfer(from, to, tokenId);
2954     }
2955 
2956     /**
2957      * @dev See {IERC721-safeTransferFrom}.
2958      */
2959     function safeTransferFrom(
2960         address from,
2961         address to,
2962         uint256 tokenId
2963     ) public virtual override {
2964         safeTransferFrom(from, to, tokenId, "");
2965     }
2966 
2967     /**
2968      * @dev See {IERC721-safeTransferFrom}.
2969      */
2970     function safeTransferFrom(
2971         address from,
2972         address to,
2973         uint256 tokenId,
2974         bytes memory data
2975     ) public virtual override {
2976         require(
2977             _isApprovedOrOwner(_msgSender(), tokenId),
2978             "ERC721: caller is not token owner or approved"
2979         );
2980         _safeTransfer(from, to, tokenId, data);
2981     }
2982 
2983     /**
2984      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
2985      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
2986      *
2987      * `data` is additional data, it has no specified format and it is sent in call to `to`.
2988      *
2989      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
2990      * implement alternative mechanisms to perform token transfer, such as signature-based.
2991      *
2992      * Requirements:
2993      *
2994      * - `from` cannot be the zero address.
2995      * - `to` cannot be the zero address.
2996      * - `tokenId` token must exist and be owned by `from`.
2997      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2998      *
2999      * Emits a {Transfer} event.
3000      */
3001     function _safeTransfer(
3002         address from,
3003         address to,
3004         uint256 tokenId,
3005         bytes memory data
3006     ) internal virtual {
3007         _transfer(from, to, tokenId);
3008         require(
3009             _checkOnERC721Received(from, to, tokenId, data),
3010             "ERC721: transfer to non ERC721Receiver implementer"
3011         );
3012     }
3013 
3014     /**
3015      * @dev Returns whether `tokenId` exists.
3016      *
3017      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
3018      *
3019      * Tokens start existing when they are minted (`_mint`),
3020      * and stop existing when they are burned (`_burn`).
3021      */
3022     function _exists(uint256 tokenId) internal view virtual returns (bool) {
3023         return _owners[tokenId] != address(0);
3024     }
3025 
3026     /**
3027      * @dev Returns whether `spender` is allowed to manage `tokenId`.
3028      *
3029      * Requirements:
3030      *
3031      * - `tokenId` must exist.
3032      */
3033     function _isApprovedOrOwner(address spender, uint256 tokenId)
3034         internal
3035         view
3036         virtual
3037         returns (bool)
3038     {
3039         address owner = ERC721.ownerOf(tokenId);
3040         return (spender == owner ||
3041             isApprovedForAll(owner, spender) ||
3042             getApproved(tokenId) == spender);
3043     }
3044 
3045     /**
3046      * @dev Safely mints `tokenId` and transfers it to `to`.
3047      *
3048      * Requirements:
3049      *
3050      * - `tokenId` must not exist.
3051      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
3052      *
3053      * Emits a {Transfer} event.
3054      */
3055     function _safeMint(address to, uint256 tokenId) internal virtual {
3056         _safeMint(to, tokenId, "");
3057     }
3058 
3059     /**
3060      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
3061      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
3062      */
3063     function _safeMint(
3064         address to,
3065         uint256 tokenId,
3066         bytes memory data
3067     ) internal virtual {
3068         _mint(to, tokenId);
3069         require(
3070             _checkOnERC721Received(address(0), to, tokenId, data),
3071             "ERC721: transfer to non ERC721Receiver implementer"
3072         );
3073     }
3074 
3075     /**
3076      * @dev Mints `tokenId` and transfers it to `to`.
3077      *
3078      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
3079      *
3080      * Requirements:
3081      *
3082      * - `tokenId` must not exist.
3083      * - `to` cannot be the zero address.
3084      *
3085      * Emits a {Transfer} event.
3086      */
3087     function _mint(address to, uint256 tokenId) internal virtual {
3088         require(to != address(0), "ERC721: mint to the zero address");
3089         require(!_exists(tokenId), "ERC721: token already minted");
3090 
3091         _beforeTokenTransfer(address(0), to, tokenId);
3092 
3093         // Check that tokenId was not minted by `_beforeTokenTransfer` hook
3094         require(!_exists(tokenId), "ERC721: token already minted");
3095 
3096         unchecked {
3097             // Will not overflow unless all 2**256 token ids are minted to the same owner.
3098             // Given that tokens are minted one by one, it is impossible in practice that
3099             // this ever happens. Might change if we allow batch minting.
3100             // The ERC fails to describe this case.
3101             _balances[to] += 1;
3102         }
3103 
3104         _owners[tokenId] = to;
3105 
3106         emit Transfer(address(0), to, tokenId);
3107 
3108         _afterTokenTransfer(address(0), to, tokenId);
3109     }
3110 
3111     /**
3112      * @dev Destroys `tokenId`.
3113      * The approval is cleared when the token is burned.
3114      * This is an internal function that does not check if the sender is authorized to operate on the token.
3115      *
3116      * Requirements:
3117      *
3118      * - `tokenId` must exist.
3119      *
3120      * Emits a {Transfer} event.
3121      */
3122     function _burn(uint256 tokenId) internal virtual {
3123         address owner = ERC721.ownerOf(tokenId);
3124 
3125         _beforeTokenTransfer(owner, address(0), tokenId);
3126 
3127         // Update ownership in case tokenId was transferred by `_beforeTokenTransfer` hook
3128         owner = ERC721.ownerOf(tokenId);
3129 
3130         // Clear approvals
3131         delete _tokenApprovals[tokenId];
3132 
3133         unchecked {
3134             // Cannot overflow, as that would require more tokens to be burned/transferred
3135             // out than the owner initially received through minting and transferring in.
3136             _balances[owner] -= 1;
3137         }
3138         delete _owners[tokenId];
3139 
3140         emit Transfer(owner, address(0), tokenId);
3141 
3142         _afterTokenTransfer(owner, address(0), tokenId);
3143     }
3144 
3145     /**
3146      * @dev Transfers `tokenId` from `from` to `to`.
3147      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
3148      *
3149      * Requirements:
3150      *
3151      * - `to` cannot be the zero address.
3152      * - `tokenId` token must be owned by `from`.
3153      *
3154      * Emits a {Transfer} event.
3155      */
3156     function _transfer(
3157         address from,
3158         address to,
3159         uint256 tokenId
3160     ) internal virtual {
3161         require(
3162             ERC721.ownerOf(tokenId) == from,
3163             "ERC721: transfer from incorrect owner"
3164         );
3165         require(to != address(0), "ERC721: transfer to the zero address");
3166 
3167         _beforeTokenTransfer(from, to, tokenId);
3168 
3169         // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
3170         require(
3171             ERC721.ownerOf(tokenId) == from,
3172             "ERC721: transfer from incorrect owner"
3173         );
3174 
3175         // Clear approvals from the previous owner
3176         delete _tokenApprovals[tokenId];
3177 
3178         unchecked {
3179             // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
3180             // `from`'s balance is the number of token held, which is at least one before the current
3181             // transfer.
3182             // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
3183             // all 2**256 token ids to be minted, which in practice is impossible.
3184             _balances[from] -= 1;
3185             _balances[to] += 1;
3186         }
3187         _owners[tokenId] = to;
3188 
3189         emit Transfer(from, to, tokenId);
3190 
3191         _afterTokenTransfer(from, to, tokenId);
3192     }
3193 
3194     /**
3195      * @dev Approve `to` to operate on `tokenId`
3196      *
3197      * Emits an {Approval} event.
3198      */
3199     function _approve(address to, uint256 tokenId) internal virtual {
3200         _tokenApprovals[tokenId] = to;
3201         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
3202     }
3203 
3204     /**
3205      * @dev Approve `operator` to operate on all of `owner` tokens
3206      *
3207      * Emits an {ApprovalForAll} event.
3208      */
3209     function _setApprovalForAll(
3210         address owner,
3211         address operator,
3212         bool approved
3213     ) internal virtual {
3214         require(owner != operator, "ERC721: approve to caller");
3215         _operatorApprovals[owner][operator] = approved;
3216         emit ApprovalForAll(owner, operator, approved);
3217     }
3218 
3219     /**
3220      * @dev Reverts if the `tokenId` has not been minted yet.
3221      */
3222     function _requireMinted(uint256 tokenId) internal view virtual {
3223         require(_exists(tokenId), "ERC721: invalid token ID");
3224     }
3225 
3226     /**
3227      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
3228      * The call is not executed if the target address is not a contract.
3229      *
3230      * @param from address representing the previous owner of the given token ID
3231      * @param to target address that will receive the tokens
3232      * @param tokenId uint256 ID of the token to be transferred
3233      * @param data bytes optional data to send along with the call
3234      * @return bool whether the call correctly returned the expected magic value
3235      */
3236     function _checkOnERC721Received(
3237         address from,
3238         address to,
3239         uint256 tokenId,
3240         bytes memory data
3241     ) private returns (bool) {
3242         if (to.isContract()) {
3243             try
3244                 IERC721Receiver(to).onERC721Received(
3245                     _msgSender(),
3246                     from,
3247                     tokenId,
3248                     data
3249                 )
3250             returns (bytes4 retval) {
3251                 return retval == IERC721Receiver.onERC721Received.selector;
3252             } catch (bytes memory reason) {
3253                 if (reason.length == 0) {
3254                     revert(
3255                         "ERC721: transfer to non ERC721Receiver implementer"
3256                     );
3257                 } else {
3258                     /// @solidity memory-safe-assembly
3259                     assembly {
3260                         revert(add(32, reason), mload(reason))
3261                     }
3262                 }
3263             }
3264         } else {
3265             return true;
3266         }
3267     }
3268 
3269     /**
3270      * @dev Hook that is called before any token transfer. This includes minting
3271      * and burning.
3272      *
3273      * Calling conditions:
3274      *
3275      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
3276      * transferred to `to`.
3277      * - When `from` is zero, `tokenId` will be minted for `to`.
3278      * - When `to` is zero, ``from``'s `tokenId` will be burned.
3279      * - `from` and `to` are never both zero.
3280      *
3281      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
3282      */
3283     function _beforeTokenTransfer(
3284         address from,
3285         address to,
3286         uint256 tokenId
3287     ) internal virtual {}
3288 
3289     /**
3290      * @dev Hook that is called after any transfer of tokens. This includes
3291      * minting and burning.
3292      *
3293      * Calling conditions:
3294      *
3295      * - when `from` and `to` are both non-zero.
3296      * - `from` and `to` are never both zero.
3297      *
3298      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
3299      */
3300     function _afterTokenTransfer(
3301         address from,
3302         address to,
3303         uint256 tokenId
3304     ) internal virtual {}
3305 }
3306 
3307 // File: contracts/OrigamiClub.sol
3308 
3309 pragma solidity ^0.8.4;
3310 
3311 contract OrigamiClub is
3312     ERC721A,
3313     ERC721AQueryable,
3314     DefaultOperatorFilterer,
3315     Owned
3316 {
3317     uint256 public FIRST_MINT_PRICE = 0 ether;
3318     uint256 constant EXTRA_MINT_PRICE = 0.02 ether;
3319     uint256 constant MAX_SUPPLY_PLUS_ONE = 1001;
3320     uint256 constant MAX_PER_WALLET_PLUS_ONE = 5;
3321     uint256 RESERVED = 50;
3322 
3323     string tokenBaseUri =
3324         "ipfs://QmTViFpnui9XJLhnBiakbs3WUKXz2jaq4yttqJH117yxX1/hidden.json";
3325 
3326     bool public paused = true;
3327 
3328     mapping(address => uint256) private _freeMintedCount;
3329     mapping(address => uint256) private _totalMintedCount;
3330 
3331     constructor() ERC721A("OrigamiClub", "OGClub") Owned(msg.sender) {}
3332 
3333     // Rename mint function to optimize gas
3334     function mint_540(uint256 _quantity) external payable {
3335         unchecked {
3336             require(!paused, "MINTING PAUSED");
3337             require(
3338                 _totalMintedCount[msg.sender] + _quantity <
3339                     MAX_PER_WALLET_PLUS_ONE,
3340                 "MAX PER WALLET IS 5"
3341             );
3342 
3343             uint256 _totalSupply = totalSupply();
3344 
3345             require(
3346                 _totalSupply + _quantity + RESERVED < MAX_SUPPLY_PLUS_ONE,
3347                 "MAX SUPPLY REACHED"
3348             );
3349 
3350             uint256 payForCount = _quantity;
3351             uint256 payForFirstMint = 0;
3352             uint256 freeMintCount = _freeMintedCount[msg.sender];
3353 
3354             if (freeMintCount < 1) {
3355                 if (_quantity > 1) {
3356                     payForCount = _quantity - 1;
3357                 } else {
3358                     payForCount = 0;
3359                 }
3360                 payForFirstMint = 1;
3361 
3362                 _freeMintedCount[msg.sender] = 1;
3363             }
3364             _totalMintedCount[msg.sender] += _quantity;
3365 
3366             require(
3367                 msg.value >=
3368                     (payForCount *
3369                         EXTRA_MINT_PRICE +
3370                         payForFirstMint *
3371                         FIRST_MINT_PRICE),
3372                 "INCORRECT ETH AMOUNT"
3373             );
3374 
3375             _mint(msg.sender, _quantity);
3376         }
3377     }
3378 
3379     // Set first mint price
3380     function setFirstMintPrice(uint256 _newPrice) public onlyOwner {
3381         FIRST_MINT_PRICE = _newPrice;
3382     }
3383 
3384     function freeMintedCount(address owner) external view returns (uint256) {
3385         return _freeMintedCount[owner];
3386     }
3387 
3388     function totalMintedCount(address owner) external view returns (uint256) {
3389         return _totalMintedCount[owner];
3390     }
3391 
3392     function _startTokenId() internal pure override returns (uint256) {
3393         return 1;
3394     }
3395 
3396     function _baseURI() internal view override returns (string memory) {
3397         return tokenBaseUri;
3398     }
3399 
3400     function setBaseURI(string calldata _newBaseUri) external onlyOwner {
3401         tokenBaseUri = _newBaseUri;
3402     }
3403 
3404     function flipSale() external onlyOwner {
3405         paused = !paused;
3406     }
3407 
3408     function collectReserves() external onlyOwner {
3409         require(RESERVED > 0, "RESERVES TAKEN");
3410 
3411         _mint(msg.sender, 50);
3412         RESERVED = 0;
3413     }
3414 
3415     function withdraw() external onlyOwner {
3416         require(payable(owner).send(address(this).balance), "UNSUCCESSFUL");
3417     }
3418 
3419     function setApprovalForAll(address operator, bool approved)
3420         public
3421         override(ERC721A, IERC721A)
3422         onlyAllowedOperatorApproval(operator)
3423     {
3424         super.setApprovalForAll(operator, approved);
3425     }
3426 
3427     function approve(address operator, uint256 tokenId)
3428         public
3429         override(ERC721A, IERC721A)
3430         onlyAllowedOperatorApproval(operator)
3431     {
3432         super.approve(operator, tokenId);
3433     }
3434 
3435     function transferFrom(
3436         address from,
3437         address to,
3438         uint256 tokenId
3439     ) public override(ERC721A, IERC721A) onlyAllowedOperator(from) {
3440         super.transferFrom(from, to, tokenId);
3441     }
3442 
3443     function safeTransferFrom(
3444         address from,
3445         address to,
3446         uint256 tokenId
3447     ) public override(ERC721A, IERC721A) onlyAllowedOperator(from) {
3448         super.safeTransferFrom(from, to, tokenId);
3449     }
3450 
3451     function safeTransferFrom(
3452         address from,
3453         address to,
3454         uint256 tokenId,
3455         bytes memory data
3456     ) public override(ERC721A, IERC721A) onlyAllowedOperator(from) {
3457         super.safeTransferFrom(from, to, tokenId, data);
3458     }
3459 }