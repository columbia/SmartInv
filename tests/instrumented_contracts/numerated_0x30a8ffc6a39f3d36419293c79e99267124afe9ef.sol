1 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Interface of the ERC165 standard, as defined in the
10  * https://eips.ethereum.org/EIPS/eip-165[EIP].
11  *
12  * Implementers can declare support of contract interfaces, which can then be
13  * queried by others ({ERC165Checker}).
14  *
15  * For an implementation, see {ERC165}.
16  */
17 interface IERC165 {
18     /**
19      * @dev Returns true if this contract implements the interface defined by
20      * `interfaceId`. See the corresponding
21      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
22      * to learn more about how these ids are created.
23      *
24      * This function call must use less than 30 000 gas.
25      */
26     function supportsInterface(bytes4 interfaceId) external view returns (bool);
27 }
28 
29 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
30 
31 
32 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC721/IERC721.sol)
33 
34 pragma solidity ^0.8.0;
35 
36 
37 /**
38  * @dev Required interface of an ERC721 compliant contract.
39  */
40 interface IERC721 is IERC165 {
41     /**
42      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
43      */
44     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
45 
46     /**
47      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
48      */
49     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
50 
51     /**
52      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
53      */
54     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
55 
56     /**
57      * @dev Returns the number of tokens in ``owner``'s account.
58      */
59     function balanceOf(address owner) external view returns (uint256 balance);
60 
61     /**
62      * @dev Returns the owner of the `tokenId` token.
63      *
64      * Requirements:
65      *
66      * - `tokenId` must exist.
67      */
68     function ownerOf(uint256 tokenId) external view returns (address owner);
69 
70     /**
71      * @dev Safely transfers `tokenId` token from `from` to `to`.
72      *
73      * Requirements:
74      *
75      * - `from` cannot be the zero address.
76      * - `to` cannot be the zero address.
77      * - `tokenId` token must exist and be owned by `from`.
78      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
79      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
80      *
81      * Emits a {Transfer} event.
82      */
83     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
84 
85     /**
86      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
87      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
88      *
89      * Requirements:
90      *
91      * - `from` cannot be the zero address.
92      * - `to` cannot be the zero address.
93      * - `tokenId` token must exist and be owned by `from`.
94      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
95      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
96      *
97      * Emits a {Transfer} event.
98      */
99     function safeTransferFrom(address from, address to, uint256 tokenId) external;
100 
101     /**
102      * @dev Transfers `tokenId` token from `from` to `to`.
103      *
104      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
105      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
106      * understand this adds an external call which potentially creates a reentrancy vulnerability.
107      *
108      * Requirements:
109      *
110      * - `from` cannot be the zero address.
111      * - `to` cannot be the zero address.
112      * - `tokenId` token must be owned by `from`.
113      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
114      *
115      * Emits a {Transfer} event.
116      */
117     function transferFrom(address from, address to, uint256 tokenId) external;
118 
119     /**
120      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
121      * The approval is cleared when the token is transferred.
122      *
123      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
124      *
125      * Requirements:
126      *
127      * - The caller must own the token or be an approved operator.
128      * - `tokenId` must exist.
129      *
130      * Emits an {Approval} event.
131      */
132     function approve(address to, uint256 tokenId) external;
133 
134     /**
135      * @dev Approve or remove `operator` as an operator for the caller.
136      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
137      *
138      * Requirements:
139      *
140      * - The `operator` cannot be the caller.
141      *
142      * Emits an {ApprovalForAll} event.
143      */
144     function setApprovalForAll(address operator, bool approved) external;
145 
146     /**
147      * @dev Returns the account approved for `tokenId` token.
148      *
149      * Requirements:
150      *
151      * - `tokenId` must exist.
152      */
153     function getApproved(uint256 tokenId) external view returns (address operator);
154 
155     /**
156      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
157      *
158      * See {setApprovalForAll}
159      */
160     function isApprovedForAll(address owner, address operator) external view returns (bool);
161 }
162 
163 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
164 
165 
166 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
167 
168 pragma solidity ^0.8.0;
169 
170 
171 /**
172  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
173  * @dev See https://eips.ethereum.org/EIPS/eip-721
174  */
175 interface IERC721Metadata is IERC721 {
176     /**
177      * @dev Returns the token collection name.
178      */
179     function name() external view returns (string memory);
180 
181     /**
182      * @dev Returns the token collection symbol.
183      */
184     function symbol() external view returns (string memory);
185 
186     /**
187      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
188      */
189     function tokenURI(uint256 tokenId) external view returns (string memory);
190 }
191 
192 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
193 
194 
195 // OpenZeppelin Contracts (last updated v4.9.0) (security/ReentrancyGuard.sol)
196 
197 pragma solidity ^0.8.0;
198 
199 /**
200  * @dev Contract module that helps prevent reentrant calls to a function.
201  *
202  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
203  * available, which can be applied to functions to make sure there are no nested
204  * (reentrant) calls to them.
205  *
206  * Note that because there is a single `nonReentrant` guard, functions marked as
207  * `nonReentrant` may not call one another. This can be worked around by making
208  * those functions `private`, and then adding `external` `nonReentrant` entry
209  * points to them.
210  *
211  * TIP: If you would like to learn more about reentrancy and alternative ways
212  * to protect against it, check out our blog post
213  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
214  */
215 abstract contract ReentrancyGuard {
216     // Booleans are more expensive than uint256 or any type that takes up a full
217     // word because each write operation emits an extra SLOAD to first read the
218     // slot's contents, replace the bits taken up by the boolean, and then write
219     // back. This is the compiler's defense against contract upgrades and
220     // pointer aliasing, and it cannot be disabled.
221 
222     // The values being non-zero value makes deployment a bit more expensive,
223     // but in exchange the refund on every call to nonReentrant will be lower in
224     // amount. Since refunds are capped to a percentage of the total
225     // transaction's gas, it is best to keep them low in cases like this one, to
226     // increase the likelihood of the full refund coming into effect.
227     uint256 private constant _NOT_ENTERED = 1;
228     uint256 private constant _ENTERED = 2;
229 
230     uint256 private _status;
231 
232     constructor() {
233         _status = _NOT_ENTERED;
234     }
235 
236     /**
237      * @dev Prevents a contract from calling itself, directly or indirectly.
238      * Calling a `nonReentrant` function from another `nonReentrant`
239      * function is not supported. It is possible to prevent this from happening
240      * by making the `nonReentrant` function external, and making it call a
241      * `private` function that does the actual work.
242      */
243     modifier nonReentrant() {
244         _nonReentrantBefore();
245         _;
246         _nonReentrantAfter();
247     }
248 
249     function _nonReentrantBefore() private {
250         // On the first call to nonReentrant, _status will be _NOT_ENTERED
251         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
252 
253         // Any calls to nonReentrant after this point will fail
254         _status = _ENTERED;
255     }
256 
257     function _nonReentrantAfter() private {
258         // By storing the original value once again, a refund is triggered (see
259         // https://eips.ethereum.org/EIPS/eip-2200)
260         _status = _NOT_ENTERED;
261     }
262 
263     /**
264      * @dev Returns true if the reentrancy guard is currently set to "entered", which indicates there is a
265      * `nonReentrant` function in the call stack.
266      */
267     function _reentrancyGuardEntered() internal view returns (bool) {
268         return _status == _ENTERED;
269     }
270 }
271 
272 // File: erc721a/contracts/IERC721A.sol
273 
274 
275 // ERC721A Contracts v4.2.3
276 // Creator: Chiru Labs
277 
278 pragma solidity ^0.8.4;
279 
280 /**
281  * @dev Interface of ERC721A.
282  */
283 interface IERC721A {
284     /**
285      * The caller must own the token or be an approved operator.
286      */
287     error ApprovalCallerNotOwnerNorApproved();
288 
289     /**
290      * The token does not exist.
291      */
292     error ApprovalQueryForNonexistentToken();
293 
294     /**
295      * Cannot query the balance for the zero address.
296      */
297     error BalanceQueryForZeroAddress();
298 
299     /**
300      * Cannot mint to the zero address.
301      */
302     error MintToZeroAddress();
303 
304     /**
305      * The quantity of tokens minted must be more than zero.
306      */
307     error MintZeroQuantity();
308 
309     /**
310      * The token does not exist.
311      */
312     error OwnerQueryForNonexistentToken();
313 
314     /**
315      * The caller must own the token or be an approved operator.
316      */
317     error TransferCallerNotOwnerNorApproved();
318 
319     /**
320      * The token must be owned by `from`.
321      */
322     error TransferFromIncorrectOwner();
323 
324     /**
325      * Cannot safely transfer to a contract that does not implement the
326      * ERC721Receiver interface.
327      */
328     error TransferToNonERC721ReceiverImplementer();
329 
330     /**
331      * Cannot transfer to the zero address.
332      */
333     error TransferToZeroAddress();
334 
335     /**
336      * The token does not exist.
337      */
338     error URIQueryForNonexistentToken();
339 
340     /**
341      * The `quantity` minted with ERC2309 exceeds the safety limit.
342      */
343     error MintERC2309QuantityExceedsLimit();
344 
345     /**
346      * The `extraData` cannot be set on an unintialized ownership slot.
347      */
348     error OwnershipNotInitializedForExtraData();
349 
350     // =============================================================
351     //                            STRUCTS
352     // =============================================================
353 
354     struct TokenOwnership {
355         // The address of the owner.
356         address addr;
357         // Stores the start time of ownership with minimal overhead for tokenomics.
358         uint64 startTimestamp;
359         // Whether the token has been burned.
360         bool burned;
361         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
362         uint24 extraData;
363     }
364 
365     // =============================================================
366     //                         TOKEN COUNTERS
367     // =============================================================
368 
369     /**
370      * @dev Returns the total number of tokens in existence.
371      * Burned tokens will reduce the count.
372      * To get the total number of tokens minted, please see {_totalMinted}.
373      */
374     function totalSupply() external view returns (uint256);
375 
376     // =============================================================
377     //                            IERC165
378     // =============================================================
379 
380     /**
381      * @dev Returns true if this contract implements the interface defined by
382      * `interfaceId`. See the corresponding
383      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
384      * to learn more about how these ids are created.
385      *
386      * This function call must use less than 30000 gas.
387      */
388     function supportsInterface(bytes4 interfaceId) external view returns (bool);
389 
390     // =============================================================
391     //                            IERC721
392     // =============================================================
393 
394     /**
395      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
396      */
397     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
398 
399     /**
400      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
401      */
402     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
403 
404     /**
405      * @dev Emitted when `owner` enables or disables
406      * (`approved`) `operator` to manage all of its assets.
407      */
408     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
409 
410     /**
411      * @dev Returns the number of tokens in `owner`'s account.
412      */
413     function balanceOf(address owner) external view returns (uint256 balance);
414 
415     /**
416      * @dev Returns the owner of the `tokenId` token.
417      *
418      * Requirements:
419      *
420      * - `tokenId` must exist.
421      */
422     function ownerOf(uint256 tokenId) external view returns (address owner);
423 
424     /**
425      * @dev Safely transfers `tokenId` token from `from` to `to`,
426      * checking first that contract recipients are aware of the ERC721 protocol
427      * to prevent tokens from being forever locked.
428      *
429      * Requirements:
430      *
431      * - `from` cannot be the zero address.
432      * - `to` cannot be the zero address.
433      * - `tokenId` token must exist and be owned by `from`.
434      * - If the caller is not `from`, it must be have been allowed to move
435      * this token by either {approve} or {setApprovalForAll}.
436      * - If `to` refers to a smart contract, it must implement
437      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
438      *
439      * Emits a {Transfer} event.
440      */
441     function safeTransferFrom(
442         address from,
443         address to,
444         uint256 tokenId,
445         bytes calldata data
446     ) external payable;
447 
448     /**
449      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
450      */
451     function safeTransferFrom(
452         address from,
453         address to,
454         uint256 tokenId
455     ) external payable;
456 
457     /**
458      * @dev Transfers `tokenId` from `from` to `to`.
459      *
460      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
461      * whenever possible.
462      *
463      * Requirements:
464      *
465      * - `from` cannot be the zero address.
466      * - `to` cannot be the zero address.
467      * - `tokenId` token must be owned by `from`.
468      * - If the caller is not `from`, it must be approved to move this token
469      * by either {approve} or {setApprovalForAll}.
470      *
471      * Emits a {Transfer} event.
472      */
473     function transferFrom(
474         address from,
475         address to,
476         uint256 tokenId
477     ) external payable;
478 
479     /**
480      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
481      * The approval is cleared when the token is transferred.
482      *
483      * Only a single account can be approved at a time, so approving the
484      * zero address clears previous approvals.
485      *
486      * Requirements:
487      *
488      * - The caller must own the token or be an approved operator.
489      * - `tokenId` must exist.
490      *
491      * Emits an {Approval} event.
492      */
493     function approve(address to, uint256 tokenId) external payable;
494 
495     /**
496      * @dev Approve or remove `operator` as an operator for the caller.
497      * Operators can call {transferFrom} or {safeTransferFrom}
498      * for any token owned by the caller.
499      *
500      * Requirements:
501      *
502      * - The `operator` cannot be the caller.
503      *
504      * Emits an {ApprovalForAll} event.
505      */
506     function setApprovalForAll(address operator, bool _approved) external;
507 
508     /**
509      * @dev Returns the account approved for `tokenId` token.
510      *
511      * Requirements:
512      *
513      * - `tokenId` must exist.
514      */
515     function getApproved(uint256 tokenId) external view returns (address operator);
516 
517     /**
518      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
519      *
520      * See {setApprovalForAll}.
521      */
522     function isApprovedForAll(address owner, address operator) external view returns (bool);
523 
524     // =============================================================
525     //                        IERC721Metadata
526     // =============================================================
527 
528     /**
529      * @dev Returns the token collection name.
530      */
531     function name() external view returns (string memory);
532 
533     /**
534      * @dev Returns the token collection symbol.
535      */
536     function symbol() external view returns (string memory);
537 
538     /**
539      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
540      */
541     function tokenURI(uint256 tokenId) external view returns (string memory);
542 
543     // =============================================================
544     //                           IERC2309
545     // =============================================================
546 
547     /**
548      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
549      * (inclusive) is transferred from `from` to `to`, as defined in the
550      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
551      *
552      * See {_mintERC2309} for more details.
553      */
554     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
555 }
556 
557 // File: erc721a/contracts/ERC721A.sol
558 
559 
560 // ERC721A Contracts v4.2.3
561 // Creator: Chiru Labs
562 
563 pragma solidity ^0.8.4;
564 
565 
566 /**
567  * @dev Interface of ERC721 token receiver.
568  */
569 interface ERC721A__IERC721Receiver {
570     function onERC721Received(
571         address operator,
572         address from,
573         uint256 tokenId,
574         bytes calldata data
575     ) external returns (bytes4);
576 }
577 
578 /**
579  * @title ERC721A
580  *
581  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
582  * Non-Fungible Token Standard, including the Metadata extension.
583  * Optimized for lower gas during batch mints.
584  *
585  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
586  * starting from `_startTokenId()`.
587  *
588  * Assumptions:
589  *
590  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
591  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
592  */
593 contract ERC721A is IERC721A {
594     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
595     struct TokenApprovalRef {
596         address value;
597     }
598 
599     // =============================================================
600     //                           CONSTANTS
601     // =============================================================
602 
603     // Mask of an entry in packed address data.
604     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
605 
606     // The bit position of `numberMinted` in packed address data.
607     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
608 
609     // The bit position of `numberBurned` in packed address data.
610     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
611 
612     // The bit position of `aux` in packed address data.
613     uint256 private constant _BITPOS_AUX = 192;
614 
615     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
616     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
617 
618     // The bit position of `startTimestamp` in packed ownership.
619     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
620 
621     // The bit mask of the `burned` bit in packed ownership.
622     uint256 private constant _BITMASK_BURNED = 1 << 224;
623 
624     // The bit position of the `nextInitialized` bit in packed ownership.
625     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
626 
627     // The bit mask of the `nextInitialized` bit in packed ownership.
628     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
629 
630     // The bit position of `extraData` in packed ownership.
631     uint256 private constant _BITPOS_EXTRA_DATA = 232;
632 
633     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
634     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
635 
636     // The mask of the lower 160 bits for addresses.
637     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
638 
639     // The maximum `quantity` that can be minted with {_mintERC2309}.
640     // This limit is to prevent overflows on the address data entries.
641     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
642     // is required to cause an overflow, which is unrealistic.
643     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
644 
645     // The `Transfer` event signature is given by:
646     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
647     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
648         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
649 
650     // =============================================================
651     //                            STORAGE
652     // =============================================================
653 
654     // The next token ID to be minted.
655     uint256 private _currentIndex;
656 
657     // The number of tokens burned.
658     uint256 private _burnCounter;
659 
660     // Token name
661     string private _name;
662 
663     // Token symbol
664     string private _symbol;
665 
666     // Mapping from token ID to ownership details
667     // An empty struct value does not necessarily mean the token is unowned.
668     // See {_packedOwnershipOf} implementation for details.
669     //
670     // Bits Layout:
671     // - [0..159]   `addr`
672     // - [160..223] `startTimestamp`
673     // - [224]      `burned`
674     // - [225]      `nextInitialized`
675     // - [232..255] `extraData`
676     mapping(uint256 => uint256) private _packedOwnerships;
677 
678     // Mapping owner address to address data.
679     //
680     // Bits Layout:
681     // - [0..63]    `balance`
682     // - [64..127]  `numberMinted`
683     // - [128..191] `numberBurned`
684     // - [192..255] `aux`
685     mapping(address => uint256) private _packedAddressData;
686 
687     // Mapping from token ID to approved address.
688     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
689 
690     // Mapping from owner to operator approvals
691     mapping(address => mapping(address => bool)) private _operatorApprovals;
692 
693     // =============================================================
694     //                          CONSTRUCTOR
695     // =============================================================
696 
697     constructor(string memory name_, string memory symbol_) {
698         _name = name_;
699         _symbol = symbol_;
700         _currentIndex = _startTokenId();
701     }
702 
703     // =============================================================
704     //                   TOKEN COUNTING OPERATIONS
705     // =============================================================
706 
707     /**
708      * @dev Returns the starting token ID.
709      * To change the starting token ID, please override this function.
710      */
711     function _startTokenId() internal view virtual returns (uint256) {
712         return 0;
713     }
714 
715     /**
716      * @dev Returns the next token ID to be minted.
717      */
718     function _nextTokenId() internal view virtual returns (uint256) {
719         return _currentIndex;
720     }
721 
722     /**
723      * @dev Returns the total number of tokens in existence.
724      * Burned tokens will reduce the count.
725      * To get the total number of tokens minted, please see {_totalMinted}.
726      */
727     function totalSupply() public view virtual override returns (uint256) {
728         // Counter underflow is impossible as _burnCounter cannot be incremented
729         // more than `_currentIndex - _startTokenId()` times.
730         unchecked {
731             return _currentIndex - _burnCounter - _startTokenId();
732         }
733     }
734 
735     /**
736      * @dev Returns the total amount of tokens minted in the contract.
737      */
738     function _totalMinted() internal view virtual returns (uint256) {
739         // Counter underflow is impossible as `_currentIndex` does not decrement,
740         // and it is initialized to `_startTokenId()`.
741         unchecked {
742             return _currentIndex - _startTokenId();
743         }
744     }
745 
746     /**
747      * @dev Returns the total number of tokens burned.
748      */
749     function _totalBurned() internal view virtual returns (uint256) {
750         return _burnCounter;
751     }
752 
753     // =============================================================
754     //                    ADDRESS DATA OPERATIONS
755     // =============================================================
756 
757     /**
758      * @dev Returns the number of tokens in `owner`'s account.
759      */
760     function balanceOf(address owner) public view virtual override returns (uint256) {
761         if (owner == address(0)) revert BalanceQueryForZeroAddress();
762         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
763     }
764 
765     /**
766      * Returns the number of tokens minted by `owner`.
767      */
768     function _numberMinted(address owner) internal view returns (uint256) {
769         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
770     }
771 
772     /**
773      * Returns the number of tokens burned by or on behalf of `owner`.
774      */
775     function _numberBurned(address owner) internal view returns (uint256) {
776         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
777     }
778 
779     /**
780      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
781      */
782     function _getAux(address owner) internal view returns (uint64) {
783         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
784     }
785 
786     /**
787      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
788      * If there are multiple variables, please pack them into a uint64.
789      */
790     function _setAux(address owner, uint64 aux) internal virtual {
791         uint256 packed = _packedAddressData[owner];
792         uint256 auxCasted;
793         // Cast `aux` with assembly to avoid redundant masking.
794         assembly {
795             auxCasted := aux
796         }
797         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
798         _packedAddressData[owner] = packed;
799     }
800 
801     // =============================================================
802     //                            IERC165
803     // =============================================================
804 
805     /**
806      * @dev Returns true if this contract implements the interface defined by
807      * `interfaceId`. See the corresponding
808      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
809      * to learn more about how these ids are created.
810      *
811      * This function call must use less than 30000 gas.
812      */
813     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
814         // The interface IDs are constants representing the first 4 bytes
815         // of the XOR of all function selectors in the interface.
816         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
817         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
818         return
819             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
820             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
821             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
822     }
823 
824     // =============================================================
825     //                        IERC721Metadata
826     // =============================================================
827 
828     /**
829      * @dev Returns the token collection name.
830      */
831     function name() public view virtual override returns (string memory) {
832         return _name;
833     }
834 
835     /**
836      * @dev Returns the token collection symbol.
837      */
838     function symbol() public view virtual override returns (string memory) {
839         return _symbol;
840     }
841 
842     /**
843      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
844      */
845     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
846         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
847 
848         string memory baseURI = _baseURI();
849         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
850     }
851 
852     /**
853      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
854      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
855      * by default, it can be overridden in child contracts.
856      */
857     function _baseURI() internal view virtual returns (string memory) {
858         return '';
859     }
860 
861     // =============================================================
862     //                     OWNERSHIPS OPERATIONS
863     // =============================================================
864 
865     /**
866      * @dev Returns the owner of the `tokenId` token.
867      *
868      * Requirements:
869      *
870      * - `tokenId` must exist.
871      */
872     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
873         return address(uint160(_packedOwnershipOf(tokenId)));
874     }
875 
876     /**
877      * @dev Gas spent here starts off proportional to the maximum mint batch size.
878      * It gradually moves to O(1) as tokens get transferred around over time.
879      */
880     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
881         return _unpackedOwnership(_packedOwnershipOf(tokenId));
882     }
883 
884     /**
885      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
886      */
887     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
888         return _unpackedOwnership(_packedOwnerships[index]);
889     }
890 
891     /**
892      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
893      */
894     function _initializeOwnershipAt(uint256 index) internal virtual {
895         if (_packedOwnerships[index] == 0) {
896             _packedOwnerships[index] = _packedOwnershipOf(index);
897         }
898     }
899 
900     /**
901      * Returns the packed ownership data of `tokenId`.
902      */
903     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
904         uint256 curr = tokenId;
905 
906         unchecked {
907             if (_startTokenId() <= curr)
908                 if (curr < _currentIndex) {
909                     uint256 packed = _packedOwnerships[curr];
910                     // If not burned.
911                     if (packed & _BITMASK_BURNED == 0) {
912                         // Invariant:
913                         // There will always be an initialized ownership slot
914                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
915                         // before an unintialized ownership slot
916                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
917                         // Hence, `curr` will not underflow.
918                         //
919                         // We can directly compare the packed value.
920                         // If the address is zero, packed will be zero.
921                         while (packed == 0) {
922                             packed = _packedOwnerships[--curr];
923                         }
924                         return packed;
925                     }
926                 }
927         }
928         revert OwnerQueryForNonexistentToken();
929     }
930 
931     /**
932      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
933      */
934     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
935         ownership.addr = address(uint160(packed));
936         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
937         ownership.burned = packed & _BITMASK_BURNED != 0;
938         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
939     }
940 
941     /**
942      * @dev Packs ownership data into a single uint256.
943      */
944     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
945         assembly {
946             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
947             owner := and(owner, _BITMASK_ADDRESS)
948             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
949             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
950         }
951     }
952 
953     /**
954      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
955      */
956     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
957         // For branchless setting of the `nextInitialized` flag.
958         assembly {
959             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
960             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
961         }
962     }
963 
964     // =============================================================
965     //                      APPROVAL OPERATIONS
966     // =============================================================
967 
968     /**
969      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
970      * The approval is cleared when the token is transferred.
971      *
972      * Only a single account can be approved at a time, so approving the
973      * zero address clears previous approvals.
974      *
975      * Requirements:
976      *
977      * - The caller must own the token or be an approved operator.
978      * - `tokenId` must exist.
979      *
980      * Emits an {Approval} event.
981      */
982     function approve(address to, uint256 tokenId) public payable virtual override {
983         address owner = ownerOf(tokenId);
984 
985         if (_msgSenderERC721A() != owner)
986             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
987                 revert ApprovalCallerNotOwnerNorApproved();
988             }
989 
990         _tokenApprovals[tokenId].value = to;
991         emit Approval(owner, to, tokenId);
992     }
993 
994     /**
995      * @dev Returns the account approved for `tokenId` token.
996      *
997      * Requirements:
998      *
999      * - `tokenId` must exist.
1000      */
1001     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1002         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1003 
1004         return _tokenApprovals[tokenId].value;
1005     }
1006 
1007     /**
1008      * @dev Approve or remove `operator` as an operator for the caller.
1009      * Operators can call {transferFrom} or {safeTransferFrom}
1010      * for any token owned by the caller.
1011      *
1012      * Requirements:
1013      *
1014      * - The `operator` cannot be the caller.
1015      *
1016      * Emits an {ApprovalForAll} event.
1017      */
1018     function setApprovalForAll(address operator, bool approved) public virtual override {
1019         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1020         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1021     }
1022 
1023     /**
1024      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1025      *
1026      * See {setApprovalForAll}.
1027      */
1028     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1029         return _operatorApprovals[owner][operator];
1030     }
1031 
1032     /**
1033      * @dev Returns whether `tokenId` exists.
1034      *
1035      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1036      *
1037      * Tokens start existing when they are minted. See {_mint}.
1038      */
1039     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1040         return
1041             _startTokenId() <= tokenId &&
1042             tokenId < _currentIndex && // If within bounds,
1043             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1044     }
1045 
1046     /**
1047      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1048      */
1049     function _isSenderApprovedOrOwner(
1050         address approvedAddress,
1051         address owner,
1052         address msgSender
1053     ) private pure returns (bool result) {
1054         assembly {
1055             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1056             owner := and(owner, _BITMASK_ADDRESS)
1057             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1058             msgSender := and(msgSender, _BITMASK_ADDRESS)
1059             // `msgSender == owner || msgSender == approvedAddress`.
1060             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1061         }
1062     }
1063 
1064     /**
1065      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1066      */
1067     function _getApprovedSlotAndAddress(uint256 tokenId)
1068         private
1069         view
1070         returns (uint256 approvedAddressSlot, address approvedAddress)
1071     {
1072         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1073         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1074         assembly {
1075             approvedAddressSlot := tokenApproval.slot
1076             approvedAddress := sload(approvedAddressSlot)
1077         }
1078     }
1079 
1080     // =============================================================
1081     //                      TRANSFER OPERATIONS
1082     // =============================================================
1083 
1084     /**
1085      * @dev Transfers `tokenId` from `from` to `to`.
1086      *
1087      * Requirements:
1088      *
1089      * - `from` cannot be the zero address.
1090      * - `to` cannot be the zero address.
1091      * - `tokenId` token must be owned by `from`.
1092      * - If the caller is not `from`, it must be approved to move this token
1093      * by either {approve} or {setApprovalForAll}.
1094      *
1095      * Emits a {Transfer} event.
1096      */
1097     function transferFrom(
1098         address from,
1099         address to,
1100         uint256 tokenId
1101     ) public payable virtual override {
1102         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1103 
1104         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1105 
1106         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1107 
1108         // The nested ifs save around 20+ gas over a compound boolean condition.
1109         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1110             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1111 
1112         if (to == address(0)) revert TransferToZeroAddress();
1113 
1114         _beforeTokenTransfers(from, to, tokenId, 1);
1115 
1116         // Clear approvals from the previous owner.
1117         assembly {
1118             if approvedAddress {
1119                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1120                 sstore(approvedAddressSlot, 0)
1121             }
1122         }
1123 
1124         // Underflow of the sender's balance is impossible because we check for
1125         // ownership above and the recipient's balance can't realistically overflow.
1126         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1127         unchecked {
1128             // We can directly increment and decrement the balances.
1129             --_packedAddressData[from]; // Updates: `balance -= 1`.
1130             ++_packedAddressData[to]; // Updates: `balance += 1`.
1131 
1132             // Updates:
1133             // - `address` to the next owner.
1134             // - `startTimestamp` to the timestamp of transfering.
1135             // - `burned` to `false`.
1136             // - `nextInitialized` to `true`.
1137             _packedOwnerships[tokenId] = _packOwnershipData(
1138                 to,
1139                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1140             );
1141 
1142             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1143             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1144                 uint256 nextTokenId = tokenId + 1;
1145                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1146                 if (_packedOwnerships[nextTokenId] == 0) {
1147                     // If the next slot is within bounds.
1148                     if (nextTokenId != _currentIndex) {
1149                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1150                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1151                     }
1152                 }
1153             }
1154         }
1155 
1156         emit Transfer(from, to, tokenId);
1157         _afterTokenTransfers(from, to, tokenId, 1);
1158     }
1159 
1160     /**
1161      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1162      */
1163     function safeTransferFrom(
1164         address from,
1165         address to,
1166         uint256 tokenId
1167     ) public payable virtual override {
1168         safeTransferFrom(from, to, tokenId, '');
1169     }
1170 
1171     /**
1172      * @dev Safely transfers `tokenId` token from `from` to `to`.
1173      *
1174      * Requirements:
1175      *
1176      * - `from` cannot be the zero address.
1177      * - `to` cannot be the zero address.
1178      * - `tokenId` token must exist and be owned by `from`.
1179      * - If the caller is not `from`, it must be approved to move this token
1180      * by either {approve} or {setApprovalForAll}.
1181      * - If `to` refers to a smart contract, it must implement
1182      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1183      *
1184      * Emits a {Transfer} event.
1185      */
1186     function safeTransferFrom(
1187         address from,
1188         address to,
1189         uint256 tokenId,
1190         bytes memory _data
1191     ) public payable virtual override {
1192         transferFrom(from, to, tokenId);
1193         if (to.code.length != 0)
1194             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1195                 revert TransferToNonERC721ReceiverImplementer();
1196             }
1197     }
1198 
1199     /**
1200      * @dev Hook that is called before a set of serially-ordered token IDs
1201      * are about to be transferred. This includes minting.
1202      * And also called before burning one token.
1203      *
1204      * `startTokenId` - the first token ID to be transferred.
1205      * `quantity` - the amount to be transferred.
1206      *
1207      * Calling conditions:
1208      *
1209      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1210      * transferred to `to`.
1211      * - When `from` is zero, `tokenId` will be minted for `to`.
1212      * - When `to` is zero, `tokenId` will be burned by `from`.
1213      * - `from` and `to` are never both zero.
1214      */
1215     function _beforeTokenTransfers(
1216         address from,
1217         address to,
1218         uint256 startTokenId,
1219         uint256 quantity
1220     ) internal virtual {}
1221 
1222     /**
1223      * @dev Hook that is called after a set of serially-ordered token IDs
1224      * have been transferred. This includes minting.
1225      * And also called after one token has been burned.
1226      *
1227      * `startTokenId` - the first token ID to be transferred.
1228      * `quantity` - the amount to be transferred.
1229      *
1230      * Calling conditions:
1231      *
1232      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1233      * transferred to `to`.
1234      * - When `from` is zero, `tokenId` has been minted for `to`.
1235      * - When `to` is zero, `tokenId` has been burned by `from`.
1236      * - `from` and `to` are never both zero.
1237      */
1238     function _afterTokenTransfers(
1239         address from,
1240         address to,
1241         uint256 startTokenId,
1242         uint256 quantity
1243     ) internal virtual {}
1244 
1245     /**
1246      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1247      *
1248      * `from` - Previous owner of the given token ID.
1249      * `to` - Target address that will receive the token.
1250      * `tokenId` - Token ID to be transferred.
1251      * `_data` - Optional data to send along with the call.
1252      *
1253      * Returns whether the call correctly returned the expected magic value.
1254      */
1255     function _checkContractOnERC721Received(
1256         address from,
1257         address to,
1258         uint256 tokenId,
1259         bytes memory _data
1260     ) private returns (bool) {
1261         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1262             bytes4 retval
1263         ) {
1264             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1265         } catch (bytes memory reason) {
1266             if (reason.length == 0) {
1267                 revert TransferToNonERC721ReceiverImplementer();
1268             } else {
1269                 assembly {
1270                     revert(add(32, reason), mload(reason))
1271                 }
1272             }
1273         }
1274     }
1275 
1276     // =============================================================
1277     //                        MINT OPERATIONS
1278     // =============================================================
1279 
1280     /**
1281      * @dev Mints `quantity` tokens and transfers them to `to`.
1282      *
1283      * Requirements:
1284      *
1285      * - `to` cannot be the zero address.
1286      * - `quantity` must be greater than 0.
1287      *
1288      * Emits a {Transfer} event for each mint.
1289      */
1290     function _mint(address to, uint256 quantity) internal virtual {
1291         uint256 startTokenId = _currentIndex;
1292         if (quantity == 0) revert MintZeroQuantity();
1293 
1294         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1295 
1296         // Overflows are incredibly unrealistic.
1297         // `balance` and `numberMinted` have a maximum limit of 2**64.
1298         // `tokenId` has a maximum limit of 2**256.
1299         unchecked {
1300             // Updates:
1301             // - `balance += quantity`.
1302             // - `numberMinted += quantity`.
1303             //
1304             // We can directly add to the `balance` and `numberMinted`.
1305             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1306 
1307             // Updates:
1308             // - `address` to the owner.
1309             // - `startTimestamp` to the timestamp of minting.
1310             // - `burned` to `false`.
1311             // - `nextInitialized` to `quantity == 1`.
1312             _packedOwnerships[startTokenId] = _packOwnershipData(
1313                 to,
1314                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1315             );
1316 
1317             uint256 toMasked;
1318             uint256 end = startTokenId + quantity;
1319 
1320             // Use assembly to loop and emit the `Transfer` event for gas savings.
1321             // The duplicated `log4` removes an extra check and reduces stack juggling.
1322             // The assembly, together with the surrounding Solidity code, have been
1323             // delicately arranged to nudge the compiler into producing optimized opcodes.
1324             assembly {
1325                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1326                 toMasked := and(to, _BITMASK_ADDRESS)
1327                 // Emit the `Transfer` event.
1328                 log4(
1329                     0, // Start of data (0, since no data).
1330                     0, // End of data (0, since no data).
1331                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1332                     0, // `address(0)`.
1333                     toMasked, // `to`.
1334                     startTokenId // `tokenId`.
1335                 )
1336 
1337                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1338                 // that overflows uint256 will make the loop run out of gas.
1339                 // The compiler will optimize the `iszero` away for performance.
1340                 for {
1341                     let tokenId := add(startTokenId, 1)
1342                 } iszero(eq(tokenId, end)) {
1343                     tokenId := add(tokenId, 1)
1344                 } {
1345                     // Emit the `Transfer` event. Similar to above.
1346                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1347                 }
1348             }
1349             if (toMasked == 0) revert MintToZeroAddress();
1350 
1351             _currentIndex = end;
1352         }
1353         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1354     }
1355 
1356     /**
1357      * @dev Mints `quantity` tokens and transfers them to `to`.
1358      *
1359      * This function is intended for efficient minting only during contract creation.
1360      *
1361      * It emits only one {ConsecutiveTransfer} as defined in
1362      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1363      * instead of a sequence of {Transfer} event(s).
1364      *
1365      * Calling this function outside of contract creation WILL make your contract
1366      * non-compliant with the ERC721 standard.
1367      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1368      * {ConsecutiveTransfer} event is only permissible during contract creation.
1369      *
1370      * Requirements:
1371      *
1372      * - `to` cannot be the zero address.
1373      * - `quantity` must be greater than 0.
1374      *
1375      * Emits a {ConsecutiveTransfer} event.
1376      */
1377     function _mintERC2309(address to, uint256 quantity) internal virtual {
1378         uint256 startTokenId = _currentIndex;
1379         if (to == address(0)) revert MintToZeroAddress();
1380         if (quantity == 0) revert MintZeroQuantity();
1381         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1382 
1383         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1384 
1385         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1386         unchecked {
1387             // Updates:
1388             // - `balance += quantity`.
1389             // - `numberMinted += quantity`.
1390             //
1391             // We can directly add to the `balance` and `numberMinted`.
1392             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1393 
1394             // Updates:
1395             // - `address` to the owner.
1396             // - `startTimestamp` to the timestamp of minting.
1397             // - `burned` to `false`.
1398             // - `nextInitialized` to `quantity == 1`.
1399             _packedOwnerships[startTokenId] = _packOwnershipData(
1400                 to,
1401                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1402             );
1403 
1404             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1405 
1406             _currentIndex = startTokenId + quantity;
1407         }
1408         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1409     }
1410 
1411     /**
1412      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1413      *
1414      * Requirements:
1415      *
1416      * - If `to` refers to a smart contract, it must implement
1417      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1418      * - `quantity` must be greater than 0.
1419      *
1420      * See {_mint}.
1421      *
1422      * Emits a {Transfer} event for each mint.
1423      */
1424     function _safeMint(
1425         address to,
1426         uint256 quantity,
1427         bytes memory _data
1428     ) internal virtual {
1429         _mint(to, quantity);
1430 
1431         unchecked {
1432             if (to.code.length != 0) {
1433                 uint256 end = _currentIndex;
1434                 uint256 index = end - quantity;
1435                 do {
1436                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1437                         revert TransferToNonERC721ReceiverImplementer();
1438                     }
1439                 } while (index < end);
1440                 // Reentrancy protection.
1441                 if (_currentIndex != end) revert();
1442             }
1443         }
1444     }
1445 
1446     /**
1447      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1448      */
1449     function _safeMint(address to, uint256 quantity) internal virtual {
1450         _safeMint(to, quantity, '');
1451     }
1452 
1453     // =============================================================
1454     //                        BURN OPERATIONS
1455     // =============================================================
1456 
1457     /**
1458      * @dev Equivalent to `_burn(tokenId, false)`.
1459      */
1460     function _burn(uint256 tokenId) internal virtual {
1461         _burn(tokenId, false);
1462     }
1463 
1464     /**
1465      * @dev Destroys `tokenId`.
1466      * The approval is cleared when the token is burned.
1467      *
1468      * Requirements:
1469      *
1470      * - `tokenId` must exist.
1471      *
1472      * Emits a {Transfer} event.
1473      */
1474     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1475         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1476 
1477         address from = address(uint160(prevOwnershipPacked));
1478 
1479         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1480 
1481         if (approvalCheck) {
1482             // The nested ifs save around 20+ gas over a compound boolean condition.
1483             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1484                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1485         }
1486 
1487         _beforeTokenTransfers(from, address(0), tokenId, 1);
1488 
1489         // Clear approvals from the previous owner.
1490         assembly {
1491             if approvedAddress {
1492                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1493                 sstore(approvedAddressSlot, 0)
1494             }
1495         }
1496 
1497         // Underflow of the sender's balance is impossible because we check for
1498         // ownership above and the recipient's balance can't realistically overflow.
1499         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1500         unchecked {
1501             // Updates:
1502             // - `balance -= 1`.
1503             // - `numberBurned += 1`.
1504             //
1505             // We can directly decrement the balance, and increment the number burned.
1506             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1507             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1508 
1509             // Updates:
1510             // - `address` to the last owner.
1511             // - `startTimestamp` to the timestamp of burning.
1512             // - `burned` to `true`.
1513             // - `nextInitialized` to `true`.
1514             _packedOwnerships[tokenId] = _packOwnershipData(
1515                 from,
1516                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1517             );
1518 
1519             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1520             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1521                 uint256 nextTokenId = tokenId + 1;
1522                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1523                 if (_packedOwnerships[nextTokenId] == 0) {
1524                     // If the next slot is within bounds.
1525                     if (nextTokenId != _currentIndex) {
1526                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1527                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1528                     }
1529                 }
1530             }
1531         }
1532 
1533         emit Transfer(from, address(0), tokenId);
1534         _afterTokenTransfers(from, address(0), tokenId, 1);
1535 
1536         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1537         unchecked {
1538             _burnCounter++;
1539         }
1540     }
1541 
1542     // =============================================================
1543     //                     EXTRA DATA OPERATIONS
1544     // =============================================================
1545 
1546     /**
1547      * @dev Directly sets the extra data for the ownership data `index`.
1548      */
1549     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1550         uint256 packed = _packedOwnerships[index];
1551         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1552         uint256 extraDataCasted;
1553         // Cast `extraData` with assembly to avoid redundant masking.
1554         assembly {
1555             extraDataCasted := extraData
1556         }
1557         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1558         _packedOwnerships[index] = packed;
1559     }
1560 
1561     /**
1562      * @dev Called during each token transfer to set the 24bit `extraData` field.
1563      * Intended to be overridden by the cosumer contract.
1564      *
1565      * `previousExtraData` - the value of `extraData` before transfer.
1566      *
1567      * Calling conditions:
1568      *
1569      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1570      * transferred to `to`.
1571      * - When `from` is zero, `tokenId` will be minted for `to`.
1572      * - When `to` is zero, `tokenId` will be burned by `from`.
1573      * - `from` and `to` are never both zero.
1574      */
1575     function _extraData(
1576         address from,
1577         address to,
1578         uint24 previousExtraData
1579     ) internal view virtual returns (uint24) {}
1580 
1581     /**
1582      * @dev Returns the next extra data for the packed ownership data.
1583      * The returned result is shifted into position.
1584      */
1585     function _nextExtraData(
1586         address from,
1587         address to,
1588         uint256 prevOwnershipPacked
1589     ) private view returns (uint256) {
1590         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1591         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1592     }
1593 
1594     // =============================================================
1595     //                       OTHER OPERATIONS
1596     // =============================================================
1597 
1598     /**
1599      * @dev Returns the message sender (defaults to `msg.sender`).
1600      *
1601      * If you are writing GSN compatible contracts, you need to override this function.
1602      */
1603     function _msgSenderERC721A() internal view virtual returns (address) {
1604         return msg.sender;
1605     }
1606 
1607     /**
1608      * @dev Converts a uint256 to its ASCII string decimal representation.
1609      */
1610     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1611         assembly {
1612             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1613             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1614             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1615             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1616             let m := add(mload(0x40), 0xa0)
1617             // Update the free memory pointer to allocate.
1618             mstore(0x40, m)
1619             // Assign the `str` to the end.
1620             str := sub(m, 0x20)
1621             // Zeroize the slot after the string.
1622             mstore(str, 0)
1623 
1624             // Cache the end of the memory to calculate the length later.
1625             let end := str
1626 
1627             // We write the string from rightmost digit to leftmost digit.
1628             // The following is essentially a do-while loop that also handles the zero case.
1629             // prettier-ignore
1630             for { let temp := value } 1 {} {
1631                 str := sub(str, 1)
1632                 // Write the character to the pointer.
1633                 // The ASCII index of the '0' character is 48.
1634                 mstore8(str, add(48, mod(temp, 10)))
1635                 // Keep dividing `temp` until zero.
1636                 temp := div(temp, 10)
1637                 // prettier-ignore
1638                 if iszero(temp) { break }
1639             }
1640 
1641             let length := sub(end, str)
1642             // Move the pointer 32 bytes leftwards to make room for the length.
1643             str := sub(str, 0x20)
1644             // Store the length.
1645             mstore(str, length)
1646         }
1647     }
1648 }
1649 
1650 // File: @openzeppelin/contracts/utils/Context.sol
1651 
1652 
1653 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1654 
1655 pragma solidity ^0.8.0;
1656 
1657 /**
1658  * @dev Provides information about the current execution context, including the
1659  * sender of the transaction and its data. While these are generally available
1660  * via msg.sender and msg.data, they should not be accessed in such a direct
1661  * manner, since when dealing with meta-transactions the account sending and
1662  * paying for execution may not be the actual sender (as far as an application
1663  * is concerned).
1664  *
1665  * This contract is only required for intermediate, library-like contracts.
1666  */
1667 abstract contract Context {
1668     function _msgSender() internal view virtual returns (address) {
1669         return msg.sender;
1670     }
1671 
1672     function _msgData() internal view virtual returns (bytes calldata) {
1673         return msg.data;
1674     }
1675 }
1676 
1677 // File: @openzeppelin/contracts/access/Ownable.sol
1678 
1679 
1680 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
1681 
1682 pragma solidity ^0.8.0;
1683 
1684 
1685 /**
1686  * @dev Contract module which provides a basic access control mechanism, where
1687  * there is an account (an owner) that can be granted exclusive access to
1688  * specific functions.
1689  *
1690  * By default, the owner account will be the one that deploys the contract. This
1691  * can later be changed with {transferOwnership}.
1692  *
1693  * This module is used through inheritance. It will make available the modifier
1694  * `onlyOwner`, which can be applied to your functions to restrict their use to
1695  * the owner.
1696  */
1697 abstract contract Ownable is Context {
1698     address private _owner;
1699 
1700     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1701 
1702     /**
1703      * @dev Initializes the contract setting the deployer as the initial owner.
1704      */
1705     constructor() {
1706         _transferOwnership(_msgSender());
1707     }
1708 
1709     /**
1710      * @dev Throws if called by any account other than the owner.
1711      */
1712     modifier onlyOwner() {
1713         _checkOwner();
1714         _;
1715     }
1716 
1717     /**
1718      * @dev Returns the address of the current owner.
1719      */
1720     function owner() public view virtual returns (address) {
1721         return _owner;
1722     }
1723 
1724     /**
1725      * @dev Throws if the sender is not the owner.
1726      */
1727     function _checkOwner() internal view virtual {
1728         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1729     }
1730 
1731     /**
1732      * @dev Leaves the contract without owner. It will not be possible to call
1733      * `onlyOwner` functions. Can only be called by the current owner.
1734      *
1735      * NOTE: Renouncing ownership will leave the contract without an owner,
1736      * thereby disabling any functionality that is only available to the owner.
1737      */
1738     function renounceOwnership() public virtual onlyOwner {
1739         _transferOwnership(address(0));
1740     }
1741 
1742     /**
1743      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1744      * Can only be called by the current owner.
1745      */
1746     function transferOwnership(address newOwner) public virtual onlyOwner {
1747         require(newOwner != address(0), "Ownable: new owner is the zero address");
1748         _transferOwnership(newOwner);
1749     }
1750 
1751     /**
1752      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1753      * Internal function without access restriction.
1754      */
1755     function _transferOwnership(address newOwner) internal virtual {
1756         address oldOwner = _owner;
1757         _owner = newOwner;
1758         emit OwnershipTransferred(oldOwner, newOwner);
1759     }
1760 }
1761 
1762 // File: contracts/boringphunks.sol
1763 
1764 pragma solidity ^0.8.0;
1765 
1766 
1767 
1768 
1769 
1770 
1771 
1772 contract BoringPhunks is Ownable, ERC721A, ReentrancyGuard {
1773     string   public       baseURI;
1774     bool     public       publicSale                      = false;
1775     uint256  public       amountFree                      = 9000;
1776     uint256  public       price                           = 0.001 ether;
1777     uint     public       maxFreePerWallet                = 10;
1778     uint     public       maxPerTx                        = 100;
1779     uint     public       maxSupply                       = 10000;
1780 
1781     constructor() ERC721A ( "BoringPhunks", "BPHUNKS") {}
1782 
1783     modifier callerIsUser() {
1784         require(tx.origin == msg.sender, "The caller is another contract");
1785         _;
1786     }
1787 
1788     function setFree(uint256 amount) external onlyOwner {
1789         amountFree = amount;
1790     }
1791 
1792     function freeMint(uint256 quantity) external callerIsUser {
1793         require(publicSale, "Public sale has not begun yet");
1794         require(totalSupply() + quantity <= amountFree, "Reached max free supply");
1795         require(numberMinted(msg.sender) + quantity <= maxFreePerWallet,"Too many free per wallet!");
1796         _safeMint(msg.sender, quantity);
1797     }
1798 
1799 
1800   function setMaxFreePerWallet(uint256 maxFreePerWallet_) external onlyOwner {
1801       maxFreePerWallet = maxFreePerWallet_;
1802   }
1803 
1804     function mint(uint256 quantity) external payable callerIsUser {
1805         require(publicSale, "Public sale has not begun yet");
1806         require(totalSupply() + quantity <= maxSupply,"Reached max supply");
1807         require(quantity <= maxPerTx, "can not mint this many at a time");
1808         require(msg.value >= price * quantity , "Ether value sent is not correct");
1809 
1810         _safeMint(msg.sender, quantity);
1811     }
1812 
1813   function ownerMint(uint256 quantity) external onlyOwner
1814   {
1815     require(totalSupply() + quantity < maxSupply + 1,"too many!");
1816 
1817     _safeMint(msg.sender, quantity);
1818   }
1819 
1820 
1821   function setmaxPerTx(uint256 maxPerTx_) external onlyOwner {
1822       maxPerTx = maxPerTx_;
1823   }
1824 
1825   function setmaxSupply(uint256 maxSupply_) external onlyOwner {
1826       maxSupply = maxSupply_;
1827   }
1828 
1829 
1830 	function setprice(uint256 _newprice) public onlyOwner {
1831 	    price = _newprice;
1832 	}
1833     
1834     function setSaleState(bool state) external onlyOwner {
1835         publicSale = state;
1836     }
1837 
1838 
1839   function setBaseURI(string calldata baseURI_) external onlyOwner {
1840     baseURI = baseURI_;
1841   }
1842 
1843   function _baseURI() internal view virtual override returns (string memory) {
1844     return baseURI;
1845   }
1846 
1847     function withdraw() external onlyOwner nonReentrant {
1848         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1849         require(success, "Transfer failed.");
1850     }
1851 
1852 
1853     function numberMinted(address owner) public view returns (uint256) {
1854         return _numberMinted(owner);
1855     }
1856 
1857 }