1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
4 
5 
6 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Interface of the ERC165 standard, as defined in the
12  * https://eips.ethereum.org/EIPS/eip-165[EIP].
13  *
14  * Implementers can declare support of contract interfaces, which can then be
15  * queried by others ({ERC165Checker}).
16  *
17  * For an implementation, see {ERC165}.
18  */
19 interface IERC165 {
20     /**
21      * @dev Returns true if this contract implements the interface defined by
22      * `interfaceId`. See the corresponding
23      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
24      * to learn more about how these ids are created.
25      *
26      * This function call must use less than 30 000 gas.
27      */
28     function supportsInterface(bytes4 interfaceId) external view returns (bool);
29 }
30 
31 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
32 
33 
34 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
35 
36 pragma solidity ^0.8.0;
37 
38 
39 /**
40  * @dev Required interface of an ERC721 compliant contract.
41  */
42 interface IERC721 is IERC165 {
43     /**
44      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
45      */
46     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
47 
48     /**
49      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
50      */
51     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
52 
53     /**
54      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
55      */
56     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
57 
58     /**
59      * @dev Returns the number of tokens in ``owner``'s account.
60      */
61     function balanceOf(address owner) external view returns (uint256 balance);
62 
63     /**
64      * @dev Returns the owner of the `tokenId` token.
65      *
66      * Requirements:
67      *
68      * - `tokenId` must exist.
69      */
70     function ownerOf(uint256 tokenId) external view returns (address owner);
71 
72     /**
73      * @dev Safely transfers `tokenId` token from `from` to `to`.
74      *
75      * Requirements:
76      *
77      * - `from` cannot be the zero address.
78      * - `to` cannot be the zero address.
79      * - `tokenId` token must exist and be owned by `from`.
80      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
81      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
82      *
83      * Emits a {Transfer} event.
84      */
85     function safeTransferFrom(
86         address from,
87         address to,
88         uint256 tokenId,
89         bytes calldata data
90     ) external;
91 
92     /**
93      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
94      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
95      *
96      * Requirements:
97      *
98      * - `from` cannot be the zero address.
99      * - `to` cannot be the zero address.
100      * - `tokenId` token must exist and be owned by `from`.
101      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
102      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
103      *
104      * Emits a {Transfer} event.
105      */
106     function safeTransferFrom(
107         address from,
108         address to,
109         uint256 tokenId
110     ) external;
111 
112     /**
113      * @dev Transfers `tokenId` token from `from` to `to`.
114      *
115      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
116      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
117      * understand this adds an external call which potentially creates a reentrancy vulnerability.
118      *
119      * Requirements:
120      *
121      * - `from` cannot be the zero address.
122      * - `to` cannot be the zero address.
123      * - `tokenId` token must be owned by `from`.
124      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
125      *
126      * Emits a {Transfer} event.
127      */
128     function transferFrom(
129         address from,
130         address to,
131         uint256 tokenId
132     ) external;
133 
134     /**
135      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
136      * The approval is cleared when the token is transferred.
137      *
138      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
139      *
140      * Requirements:
141      *
142      * - The caller must own the token or be an approved operator.
143      * - `tokenId` must exist.
144      *
145      * Emits an {Approval} event.
146      */
147     function approve(address to, uint256 tokenId) external;
148 
149     /**
150      * @dev Approve or remove `operator` as an operator for the caller.
151      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
152      *
153      * Requirements:
154      *
155      * - The `operator` cannot be the caller.
156      *
157      * Emits an {ApprovalForAll} event.
158      */
159     function setApprovalForAll(address operator, bool _approved) external;
160 
161     /**
162      * @dev Returns the account approved for `tokenId` token.
163      *
164      * Requirements:
165      *
166      * - `tokenId` must exist.
167      */
168     function getApproved(uint256 tokenId) external view returns (address operator);
169 
170     /**
171      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
172      *
173      * See {setApprovalForAll}
174      */
175     function isApprovedForAll(address owner, address operator) external view returns (bool);
176 }
177 
178 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
179 
180 
181 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
182 
183 pragma solidity ^0.8.0;
184 
185 
186 /**
187  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
188  * @dev See https://eips.ethereum.org/EIPS/eip-721
189  */
190 interface IERC721Metadata is IERC721 {
191     /**
192      * @dev Returns the token collection name.
193      */
194     function name() external view returns (string memory);
195 
196     /**
197      * @dev Returns the token collection symbol.
198      */
199     function symbol() external view returns (string memory);
200 
201     /**
202      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
203      */
204     function tokenURI(uint256 tokenId) external view returns (string memory);
205 }
206 
207 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
208 
209 
210 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
211 
212 pragma solidity ^0.8.0;
213 
214 /**
215  * @dev Contract module that helps prevent reentrant calls to a function.
216  *
217  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
218  * available, which can be applied to functions to make sure there are no nested
219  * (reentrant) calls to them.
220  *
221  * Note that because there is a single `nonReentrant` guard, functions marked as
222  * `nonReentrant` may not call one another. This can be worked around by making
223  * those functions `private`, and then adding `external` `nonReentrant` entry
224  * points to them.
225  *
226  * TIP: If you would like to learn more about reentrancy and alternative ways
227  * to protect against it, check out our blog post
228  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
229  */
230 abstract contract ReentrancyGuard {
231     // Booleans are more expensive than uint256 or any type that takes up a full
232     // word because each write operation emits an extra SLOAD to first read the
233     // slot's contents, replace the bits taken up by the boolean, and then write
234     // back. This is the compiler's defense against contract upgrades and
235     // pointer aliasing, and it cannot be disabled.
236 
237     // The values being non-zero value makes deployment a bit more expensive,
238     // but in exchange the refund on every call to nonReentrant will be lower in
239     // amount. Since refunds are capped to a percentage of the total
240     // transaction's gas, it is best to keep them low in cases like this one, to
241     // increase the likelihood of the full refund coming into effect.
242     uint256 private constant _NOT_ENTERED = 1;
243     uint256 private constant _ENTERED = 2;
244 
245     uint256 private _status;
246 
247     constructor() {
248         _status = _NOT_ENTERED;
249     }
250 
251     /**
252      * @dev Prevents a contract from calling itself, directly or indirectly.
253      * Calling a `nonReentrant` function from another `nonReentrant`
254      * function is not supported. It is possible to prevent this from happening
255      * by making the `nonReentrant` function external, and making it call a
256      * `private` function that does the actual work.
257      */
258     modifier nonReentrant() {
259         _nonReentrantBefore();
260         _;
261         _nonReentrantAfter();
262     }
263 
264     function _nonReentrantBefore() private {
265         // On the first call to nonReentrant, _status will be _NOT_ENTERED
266         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
267 
268         // Any calls to nonReentrant after this point will fail
269         _status = _ENTERED;
270     }
271 
272     function _nonReentrantAfter() private {
273         // By storing the original value once again, a refund is triggered (see
274         // https://eips.ethereum.org/EIPS/eip-2200)
275         _status = _NOT_ENTERED;
276     }
277 }
278 
279 // File: erc721a/contracts/IERC721A.sol
280 
281 
282 // ERC721A Contracts v4.2.3
283 // Creator: Chiru Labs
284 
285 pragma solidity ^0.8.4;
286 
287 /**
288  * @dev Interface of ERC721A.
289  */
290 interface IERC721A {
291     /**
292      * The caller must own the token or be an approved operator.
293      */
294     error ApprovalCallerNotOwnerNorApproved();
295 
296     /**
297      * The token does not exist.
298      */
299     error ApprovalQueryForNonexistentToken();
300 
301     /**
302      * Cannot query the balance for the zero address.
303      */
304     error BalanceQueryForZeroAddress();
305 
306     /**
307      * Cannot mint to the zero address.
308      */
309     error MintToZeroAddress();
310 
311     /**
312      * The quantity of tokens minted must be more than zero.
313      */
314     error MintZeroQuantity();
315 
316     /**
317      * The token does not exist.
318      */
319     error OwnerQueryForNonexistentToken();
320 
321     /**
322      * The caller must own the token or be an approved operator.
323      */
324     error TransferCallerNotOwnerNorApproved();
325 
326     /**
327      * The token must be owned by `from`.
328      */
329     error TransferFromIncorrectOwner();
330 
331     /**
332      * Cannot safely transfer to a contract that does not implement the
333      * ERC721Receiver interface.
334      */
335     error TransferToNonERC721ReceiverImplementer();
336 
337     /**
338      * Cannot transfer to the zero address.
339      */
340     error TransferToZeroAddress();
341 
342     /**
343      * The token does not exist.
344      */
345     error URIQueryForNonexistentToken();
346 
347     /**
348      * The `quantity` minted with ERC2309 exceeds the safety limit.
349      */
350     error MintERC2309QuantityExceedsLimit();
351 
352     /**
353      * The `extraData` cannot be set on an unintialized ownership slot.
354      */
355     error OwnershipNotInitializedForExtraData();
356 
357     // =============================================================
358     //                            STRUCTS
359     // =============================================================
360 
361     struct TokenOwnership {
362         // The address of the owner.
363         address addr;
364         // Stores the start time of ownership with minimal overhead for tokenomics.
365         uint64 startTimestamp;
366         // Whether the token has been burned.
367         bool burned;
368         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
369         uint24 extraData;
370     }
371 
372     // =============================================================
373     //                         TOKEN COUNTERS
374     // =============================================================
375 
376     /**
377      * @dev Returns the total number of tokens in existence.
378      * Burned tokens will reduce the count.
379      * To get the total number of tokens minted, please see {_totalMinted}.
380      */
381     function totalSupply() external view returns (uint256);
382 
383     // =============================================================
384     //                            IERC165
385     // =============================================================
386 
387     /**
388      * @dev Returns true if this contract implements the interface defined by
389      * `interfaceId`. See the corresponding
390      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
391      * to learn more about how these ids are created.
392      *
393      * This function call must use less than 30000 gas.
394      */
395     function supportsInterface(bytes4 interfaceId) external view returns (bool);
396 
397     // =============================================================
398     //                            IERC721
399     // =============================================================
400 
401     /**
402      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
403      */
404     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
405 
406     /**
407      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
408      */
409     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
410 
411     /**
412      * @dev Emitted when `owner` enables or disables
413      * (`approved`) `operator` to manage all of its assets.
414      */
415     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
416 
417     /**
418      * @dev Returns the number of tokens in `owner`'s account.
419      */
420     function balanceOf(address owner) external view returns (uint256 balance);
421 
422     /**
423      * @dev Returns the owner of the `tokenId` token.
424      *
425      * Requirements:
426      *
427      * - `tokenId` must exist.
428      */
429     function ownerOf(uint256 tokenId) external view returns (address owner);
430 
431     /**
432      * @dev Safely transfers `tokenId` token from `from` to `to`,
433      * checking first that contract recipients are aware of the ERC721 protocol
434      * to prevent tokens from being forever locked.
435      *
436      * Requirements:
437      *
438      * - `from` cannot be the zero address.
439      * - `to` cannot be the zero address.
440      * - `tokenId` token must exist and be owned by `from`.
441      * - If the caller is not `from`, it must be have been allowed to move
442      * this token by either {approve} or {setApprovalForAll}.
443      * - If `to` refers to a smart contract, it must implement
444      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
445      *
446      * Emits a {Transfer} event.
447      */
448     function safeTransferFrom(
449         address from,
450         address to,
451         uint256 tokenId,
452         bytes calldata data
453     ) external payable;
454 
455     /**
456      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
457      */
458     function safeTransferFrom(
459         address from,
460         address to,
461         uint256 tokenId
462     ) external payable;
463 
464     /**
465      * @dev Transfers `tokenId` from `from` to `to`.
466      *
467      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
468      * whenever possible.
469      *
470      * Requirements:
471      *
472      * - `from` cannot be the zero address.
473      * - `to` cannot be the zero address.
474      * - `tokenId` token must be owned by `from`.
475      * - If the caller is not `from`, it must be approved to move this token
476      * by either {approve} or {setApprovalForAll}.
477      *
478      * Emits a {Transfer} event.
479      */
480     function transferFrom(
481         address from,
482         address to,
483         uint256 tokenId
484     ) external payable;
485 
486     /**
487      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
488      * The approval is cleared when the token is transferred.
489      *
490      * Only a single account can be approved at a time, so approving the
491      * zero address clears previous approvals.
492      *
493      * Requirements:
494      *
495      * - The caller must own the token or be an approved operator.
496      * - `tokenId` must exist.
497      *
498      * Emits an {Approval} event.
499      */
500     function approve(address to, uint256 tokenId) external payable;
501 
502     /**
503      * @dev Approve or remove `operator` as an operator for the caller.
504      * Operators can call {transferFrom} or {safeTransferFrom}
505      * for any token owned by the caller.
506      *
507      * Requirements:
508      *
509      * - The `operator` cannot be the caller.
510      *
511      * Emits an {ApprovalForAll} event.
512      */
513     function setApprovalForAll(address operator, bool _approved) external;
514 
515     /**
516      * @dev Returns the account approved for `tokenId` token.
517      *
518      * Requirements:
519      *
520      * - `tokenId` must exist.
521      */
522     function getApproved(uint256 tokenId) external view returns (address operator);
523 
524     /**
525      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
526      *
527      * See {setApprovalForAll}.
528      */
529     function isApprovedForAll(address owner, address operator) external view returns (bool);
530 
531     // =============================================================
532     //                        IERC721Metadata
533     // =============================================================
534 
535     /**
536      * @dev Returns the token collection name.
537      */
538     function name() external view returns (string memory);
539 
540     /**
541      * @dev Returns the token collection symbol.
542      */
543     function symbol() external view returns (string memory);
544 
545     /**
546      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
547      */
548     function tokenURI(uint256 tokenId) external view returns (string memory);
549 
550     // =============================================================
551     //                           IERC2309
552     // =============================================================
553 
554     /**
555      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
556      * (inclusive) is transferred from `from` to `to`, as defined in the
557      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
558      *
559      * See {_mintERC2309} for more details.
560      */
561     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
562 }
563 
564 // File: erc721a/contracts/ERC721A.sol
565 
566 
567 // ERC721A Contracts v4.2.3
568 // Creator: Chiru Labs
569 
570 pragma solidity ^0.8.4;
571 
572 
573 /**
574  * @dev Interface of ERC721 token receiver.
575  */
576 interface ERC721A__IERC721Receiver {
577     function onERC721Received(
578         address operator,
579         address from,
580         uint256 tokenId,
581         bytes calldata data
582     ) external returns (bytes4);
583 }
584 
585 /**
586  * @title ERC721A
587  *
588  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
589  * Non-Fungible Token Standard, including the Metadata extension.
590  * Optimized for lower gas during batch mints.
591  *
592  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
593  * starting from `_startTokenId()`.
594  *
595  * Assumptions:
596  *
597  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
598  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
599  */
600 contract ERC721A is IERC721A {
601     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
602     struct TokenApprovalRef {
603         address value;
604     }
605 
606     // =============================================================
607     //                           CONSTANTS
608     // =============================================================
609 
610     // Mask of an entry in packed address data.
611     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
612 
613     // The bit position of `numberMinted` in packed address data.
614     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
615 
616     // The bit position of `numberBurned` in packed address data.
617     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
618 
619     // The bit position of `aux` in packed address data.
620     uint256 private constant _BITPOS_AUX = 192;
621 
622     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
623     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
624 
625     // The bit position of `startTimestamp` in packed ownership.
626     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
627 
628     // The bit mask of the `burned` bit in packed ownership.
629     uint256 private constant _BITMASK_BURNED = 1 << 224;
630 
631     // The bit position of the `nextInitialized` bit in packed ownership.
632     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
633 
634     // The bit mask of the `nextInitialized` bit in packed ownership.
635     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
636 
637     // The bit position of `extraData` in packed ownership.
638     uint256 private constant _BITPOS_EXTRA_DATA = 232;
639 
640     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
641     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
642 
643     // The mask of the lower 160 bits for addresses.
644     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
645 
646     // The maximum `quantity` that can be minted with {_mintERC2309}.
647     // This limit is to prevent overflows on the address data entries.
648     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
649     // is required to cause an overflow, which is unrealistic.
650     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
651 
652     // The `Transfer` event signature is given by:
653     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
654     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
655         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
656 
657     // =============================================================
658     //                            STORAGE
659     // =============================================================
660 
661     // The next token ID to be minted.
662     uint256 private _currentIndex;
663 
664     // The number of tokens burned.
665     uint256 private _burnCounter;
666 
667     // Token name
668     string private _name;
669 
670     // Token symbol
671     string private _symbol;
672 
673     // Mapping from token ID to ownership details
674     // An empty struct value does not necessarily mean the token is unowned.
675     // See {_packedOwnershipOf} implementation for details.
676     //
677     // Bits Layout:
678     // - [0..159]   `addr`
679     // - [160..223] `startTimestamp`
680     // - [224]      `burned`
681     // - [225]      `nextInitialized`
682     // - [232..255] `extraData`
683     mapping(uint256 => uint256) private _packedOwnerships;
684 
685     // Mapping owner address to address data.
686     //
687     // Bits Layout:
688     // - [0..63]    `balance`
689     // - [64..127]  `numberMinted`
690     // - [128..191] `numberBurned`
691     // - [192..255] `aux`
692     mapping(address => uint256) private _packedAddressData;
693 
694     // Mapping from token ID to approved address.
695     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
696 
697     // Mapping from owner to operator approvals
698     mapping(address => mapping(address => bool)) private _operatorApprovals;
699 
700     // =============================================================
701     //                          CONSTRUCTOR
702     // =============================================================
703 
704     constructor(string memory name_, string memory symbol_) {
705         _name = name_;
706         _symbol = symbol_;
707         _currentIndex = _startTokenId();
708     }
709 
710     // =============================================================
711     //                   TOKEN COUNTING OPERATIONS
712     // =============================================================
713 
714     /**
715      * @dev Returns the starting token ID.
716      * To change the starting token ID, please override this function.
717      */
718     function _startTokenId() internal view virtual returns (uint256) {
719         return 0;
720     }
721 
722     /**
723      * @dev Returns the next token ID to be minted.
724      */
725     function _nextTokenId() internal view virtual returns (uint256) {
726         return _currentIndex;
727     }
728 
729     /**
730      * @dev Returns the total number of tokens in existence.
731      * Burned tokens will reduce the count.
732      * To get the total number of tokens minted, please see {_totalMinted}.
733      */
734     function totalSupply() public view virtual override returns (uint256) {
735         // Counter underflow is impossible as _burnCounter cannot be incremented
736         // more than `_currentIndex - _startTokenId()` times.
737         unchecked {
738             return _currentIndex - _burnCounter - _startTokenId();
739         }
740     }
741 
742     /**
743      * @dev Returns the total amount of tokens minted in the contract.
744      */
745     function _totalMinted() internal view virtual returns (uint256) {
746         // Counter underflow is impossible as `_currentIndex` does not decrement,
747         // and it is initialized to `_startTokenId()`.
748         unchecked {
749             return _currentIndex - _startTokenId();
750         }
751     }
752 
753     /**
754      * @dev Returns the total number of tokens burned.
755      */
756     function _totalBurned() internal view virtual returns (uint256) {
757         return _burnCounter;
758     }
759 
760     // =============================================================
761     //                    ADDRESS DATA OPERATIONS
762     // =============================================================
763 
764     /**
765      * @dev Returns the number of tokens in `owner`'s account.
766      */
767     function balanceOf(address owner) public view virtual override returns (uint256) {
768         if (owner == address(0)) revert BalanceQueryForZeroAddress();
769         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
770     }
771 
772     /**
773      * Returns the number of tokens minted by `owner`.
774      */
775     function _numberMinted(address owner) internal view returns (uint256) {
776         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
777     }
778 
779     /**
780      * Returns the number of tokens burned by or on behalf of `owner`.
781      */
782     function _numberBurned(address owner) internal view returns (uint256) {
783         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
784     }
785 
786     /**
787      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
788      */
789     function _getAux(address owner) internal view returns (uint64) {
790         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
791     }
792 
793     /**
794      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
795      * If there are multiple variables, please pack them into a uint64.
796      */
797     function _setAux(address owner, uint64 aux) internal virtual {
798         uint256 packed = _packedAddressData[owner];
799         uint256 auxCasted;
800         // Cast `aux` with assembly to avoid redundant masking.
801         assembly {
802             auxCasted := aux
803         }
804         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
805         _packedAddressData[owner] = packed;
806     }
807 
808     // =============================================================
809     //                            IERC165
810     // =============================================================
811 
812     /**
813      * @dev Returns true if this contract implements the interface defined by
814      * `interfaceId`. See the corresponding
815      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
816      * to learn more about how these ids are created.
817      *
818      * This function call must use less than 30000 gas.
819      */
820     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
821         // The interface IDs are constants representing the first 4 bytes
822         // of the XOR of all function selectors in the interface.
823         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
824         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
825         return
826             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
827             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
828             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
829     }
830 
831     // =============================================================
832     //                        IERC721Metadata
833     // =============================================================
834 
835     /**
836      * @dev Returns the token collection name.
837      */
838     function name() public view virtual override returns (string memory) {
839         return _name;
840     }
841 
842     /**
843      * @dev Returns the token collection symbol.
844      */
845     function symbol() public view virtual override returns (string memory) {
846         return _symbol;
847     }
848 
849     /**
850      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
851      */
852     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
853         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
854 
855         string memory baseURI = _baseURI();
856         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
857     }
858 
859     /**
860      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
861      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
862      * by default, it can be overridden in child contracts.
863      */
864     function _baseURI() internal view virtual returns (string memory) {
865         return '';
866     }
867 
868     // =============================================================
869     //                     OWNERSHIPS OPERATIONS
870     // =============================================================
871 
872     /**
873      * @dev Returns the owner of the `tokenId` token.
874      *
875      * Requirements:
876      *
877      * - `tokenId` must exist.
878      */
879     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
880         return address(uint160(_packedOwnershipOf(tokenId)));
881     }
882 
883     /**
884      * @dev Gas spent here starts off proportional to the maximum mint batch size.
885      * It gradually moves to O(1) as tokens get transferred around over time.
886      */
887     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
888         return _unpackedOwnership(_packedOwnershipOf(tokenId));
889     }
890 
891     /**
892      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
893      */
894     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
895         return _unpackedOwnership(_packedOwnerships[index]);
896     }
897 
898     /**
899      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
900      */
901     function _initializeOwnershipAt(uint256 index) internal virtual {
902         if (_packedOwnerships[index] == 0) {
903             _packedOwnerships[index] = _packedOwnershipOf(index);
904         }
905     }
906 
907     /**
908      * Returns the packed ownership data of `tokenId`.
909      */
910     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
911         uint256 curr = tokenId;
912 
913         unchecked {
914             if (_startTokenId() <= curr)
915                 if (curr < _currentIndex) {
916                     uint256 packed = _packedOwnerships[curr];
917                     // If not burned.
918                     if (packed & _BITMASK_BURNED == 0) {
919                         // Invariant:
920                         // There will always be an initialized ownership slot
921                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
922                         // before an unintialized ownership slot
923                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
924                         // Hence, `curr` will not underflow.
925                         //
926                         // We can directly compare the packed value.
927                         // If the address is zero, packed will be zero.
928                         while (packed == 0) {
929                             packed = _packedOwnerships[--curr];
930                         }
931                         return packed;
932                     }
933                 }
934         }
935         revert OwnerQueryForNonexistentToken();
936     }
937 
938     /**
939      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
940      */
941     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
942         ownership.addr = address(uint160(packed));
943         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
944         ownership.burned = packed & _BITMASK_BURNED != 0;
945         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
946     }
947 
948     /**
949      * @dev Packs ownership data into a single uint256.
950      */
951     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
952         assembly {
953             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
954             owner := and(owner, _BITMASK_ADDRESS)
955             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
956             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
957         }
958     }
959 
960     /**
961      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
962      */
963     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
964         // For branchless setting of the `nextInitialized` flag.
965         assembly {
966             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
967             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
968         }
969     }
970 
971     // =============================================================
972     //                      APPROVAL OPERATIONS
973     // =============================================================
974 
975     /**
976      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
977      * The approval is cleared when the token is transferred.
978      *
979      * Only a single account can be approved at a time, so approving the
980      * zero address clears previous approvals.
981      *
982      * Requirements:
983      *
984      * - The caller must own the token or be an approved operator.
985      * - `tokenId` must exist.
986      *
987      * Emits an {Approval} event.
988      */
989     function approve(address to, uint256 tokenId) public payable virtual override {
990         address owner = ownerOf(tokenId);
991 
992         if (_msgSenderERC721A() != owner)
993             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
994                 revert ApprovalCallerNotOwnerNorApproved();
995             }
996 
997         _tokenApprovals[tokenId].value = to;
998         emit Approval(owner, to, tokenId);
999     }
1000 
1001     /**
1002      * @dev Returns the account approved for `tokenId` token.
1003      *
1004      * Requirements:
1005      *
1006      * - `tokenId` must exist.
1007      */
1008     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1009         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1010 
1011         return _tokenApprovals[tokenId].value;
1012     }
1013 
1014     /**
1015      * @dev Approve or remove `operator` as an operator for the caller.
1016      * Operators can call {transferFrom} or {safeTransferFrom}
1017      * for any token owned by the caller.
1018      *
1019      * Requirements:
1020      *
1021      * - The `operator` cannot be the caller.
1022      *
1023      * Emits an {ApprovalForAll} event.
1024      */
1025     function setApprovalForAll(address operator, bool approved) public virtual override {
1026         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1027         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1028     }
1029 
1030     /**
1031      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1032      *
1033      * See {setApprovalForAll}.
1034      */
1035     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1036         return _operatorApprovals[owner][operator];
1037     }
1038 
1039     /**
1040      * @dev Returns whether `tokenId` exists.
1041      *
1042      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1043      *
1044      * Tokens start existing when they are minted. See {_mint}.
1045      */
1046     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1047         return
1048             _startTokenId() <= tokenId &&
1049             tokenId < _currentIndex && // If within bounds,
1050             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1051     }
1052 
1053     /**
1054      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1055      */
1056     function _isSenderApprovedOrOwner(
1057         address approvedAddress,
1058         address owner,
1059         address msgSender
1060     ) private pure returns (bool result) {
1061         assembly {
1062             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1063             owner := and(owner, _BITMASK_ADDRESS)
1064             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1065             msgSender := and(msgSender, _BITMASK_ADDRESS)
1066             // `msgSender == owner || msgSender == approvedAddress`.
1067             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1068         }
1069     }
1070 
1071     /**
1072      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1073      */
1074     function _getApprovedSlotAndAddress(uint256 tokenId)
1075         private
1076         view
1077         returns (uint256 approvedAddressSlot, address approvedAddress)
1078     {
1079         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1080         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1081         assembly {
1082             approvedAddressSlot := tokenApproval.slot
1083             approvedAddress := sload(approvedAddressSlot)
1084         }
1085     }
1086 
1087     // =============================================================
1088     //                      TRANSFER OPERATIONS
1089     // =============================================================
1090 
1091     /**
1092      * @dev Transfers `tokenId` from `from` to `to`.
1093      *
1094      * Requirements:
1095      *
1096      * - `from` cannot be the zero address.
1097      * - `to` cannot be the zero address.
1098      * - `tokenId` token must be owned by `from`.
1099      * - If the caller is not `from`, it must be approved to move this token
1100      * by either {approve} or {setApprovalForAll}.
1101      *
1102      * Emits a {Transfer} event.
1103      */
1104     function transferFrom(
1105         address from,
1106         address to,
1107         uint256 tokenId
1108     ) public payable virtual override {
1109         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1110 
1111         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1112 
1113         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1114 
1115         // The nested ifs save around 20+ gas over a compound boolean condition.
1116         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1117             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1118 
1119         if (to == address(0)) revert TransferToZeroAddress();
1120 
1121         _beforeTokenTransfers(from, to, tokenId, 1);
1122 
1123         // Clear approvals from the previous owner.
1124         assembly {
1125             if approvedAddress {
1126                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1127                 sstore(approvedAddressSlot, 0)
1128             }
1129         }
1130 
1131         // Underflow of the sender's balance is impossible because we check for
1132         // ownership above and the recipient's balance can't realistically overflow.
1133         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1134         unchecked {
1135             // We can directly increment and decrement the balances.
1136             --_packedAddressData[from]; // Updates: `balance -= 1`.
1137             ++_packedAddressData[to]; // Updates: `balance += 1`.
1138 
1139             // Updates:
1140             // - `address` to the next owner.
1141             // - `startTimestamp` to the timestamp of transfering.
1142             // - `burned` to `false`.
1143             // - `nextInitialized` to `true`.
1144             _packedOwnerships[tokenId] = _packOwnershipData(
1145                 to,
1146                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1147             );
1148 
1149             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1150             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1151                 uint256 nextTokenId = tokenId + 1;
1152                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1153                 if (_packedOwnerships[nextTokenId] == 0) {
1154                     // If the next slot is within bounds.
1155                     if (nextTokenId != _currentIndex) {
1156                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1157                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1158                     }
1159                 }
1160             }
1161         }
1162 
1163         emit Transfer(from, to, tokenId);
1164         _afterTokenTransfers(from, to, tokenId, 1);
1165     }
1166 
1167     /**
1168      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1169      */
1170     function safeTransferFrom(
1171         address from,
1172         address to,
1173         uint256 tokenId
1174     ) public payable virtual override {
1175         safeTransferFrom(from, to, tokenId, '');
1176     }
1177 
1178     /**
1179      * @dev Safely transfers `tokenId` token from `from` to `to`.
1180      *
1181      * Requirements:
1182      *
1183      * - `from` cannot be the zero address.
1184      * - `to` cannot be the zero address.
1185      * - `tokenId` token must exist and be owned by `from`.
1186      * - If the caller is not `from`, it must be approved to move this token
1187      * by either {approve} or {setApprovalForAll}.
1188      * - If `to` refers to a smart contract, it must implement
1189      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1190      *
1191      * Emits a {Transfer} event.
1192      */
1193     function safeTransferFrom(
1194         address from,
1195         address to,
1196         uint256 tokenId,
1197         bytes memory _data
1198     ) public payable virtual override {
1199         transferFrom(from, to, tokenId);
1200         if (to.code.length != 0)
1201             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1202                 revert TransferToNonERC721ReceiverImplementer();
1203             }
1204     }
1205 
1206     /**
1207      * @dev Hook that is called before a set of serially-ordered token IDs
1208      * are about to be transferred. This includes minting.
1209      * And also called before burning one token.
1210      *
1211      * `startTokenId` - the first token ID to be transferred.
1212      * `quantity` - the amount to be transferred.
1213      *
1214      * Calling conditions:
1215      *
1216      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1217      * transferred to `to`.
1218      * - When `from` is zero, `tokenId` will be minted for `to`.
1219      * - When `to` is zero, `tokenId` will be burned by `from`.
1220      * - `from` and `to` are never both zero.
1221      */
1222     function _beforeTokenTransfers(
1223         address from,
1224         address to,
1225         uint256 startTokenId,
1226         uint256 quantity
1227     ) internal virtual {}
1228 
1229     /**
1230      * @dev Hook that is called after a set of serially-ordered token IDs
1231      * have been transferred. This includes minting.
1232      * And also called after one token has been burned.
1233      *
1234      * `startTokenId` - the first token ID to be transferred.
1235      * `quantity` - the amount to be transferred.
1236      *
1237      * Calling conditions:
1238      *
1239      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1240      * transferred to `to`.
1241      * - When `from` is zero, `tokenId` has been minted for `to`.
1242      * - When `to` is zero, `tokenId` has been burned by `from`.
1243      * - `from` and `to` are never both zero.
1244      */
1245     function _afterTokenTransfers(
1246         address from,
1247         address to,
1248         uint256 startTokenId,
1249         uint256 quantity
1250     ) internal virtual {}
1251 
1252     /**
1253      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1254      *
1255      * `from` - Previous owner of the given token ID.
1256      * `to` - Target address that will receive the token.
1257      * `tokenId` - Token ID to be transferred.
1258      * `_data` - Optional data to send along with the call.
1259      *
1260      * Returns whether the call correctly returned the expected magic value.
1261      */
1262     function _checkContractOnERC721Received(
1263         address from,
1264         address to,
1265         uint256 tokenId,
1266         bytes memory _data
1267     ) private returns (bool) {
1268         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1269             bytes4 retval
1270         ) {
1271             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1272         } catch (bytes memory reason) {
1273             if (reason.length == 0) {
1274                 revert TransferToNonERC721ReceiverImplementer();
1275             } else {
1276                 assembly {
1277                     revert(add(32, reason), mload(reason))
1278                 }
1279             }
1280         }
1281     }
1282 
1283     // =============================================================
1284     //                        MINT OPERATIONS
1285     // =============================================================
1286 
1287     /**
1288      * @dev Mints `quantity` tokens and transfers them to `to`.
1289      *
1290      * Requirements:
1291      *
1292      * - `to` cannot be the zero address.
1293      * - `quantity` must be greater than 0.
1294      *
1295      * Emits a {Transfer} event for each mint.
1296      */
1297     function _mint(address to, uint256 quantity) internal virtual {
1298         uint256 startTokenId = _currentIndex;
1299         if (quantity == 0) revert MintZeroQuantity();
1300 
1301         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1302 
1303         // Overflows are incredibly unrealistic.
1304         // `balance` and `numberMinted` have a maximum limit of 2**64.
1305         // `tokenId` has a maximum limit of 2**256.
1306         unchecked {
1307             // Updates:
1308             // - `balance += quantity`.
1309             // - `numberMinted += quantity`.
1310             //
1311             // We can directly add to the `balance` and `numberMinted`.
1312             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1313 
1314             // Updates:
1315             // - `address` to the owner.
1316             // - `startTimestamp` to the timestamp of minting.
1317             // - `burned` to `false`.
1318             // - `nextInitialized` to `quantity == 1`.
1319             _packedOwnerships[startTokenId] = _packOwnershipData(
1320                 to,
1321                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1322             );
1323 
1324             uint256 toMasked;
1325             uint256 end = startTokenId + quantity;
1326 
1327             // Use assembly to loop and emit the `Transfer` event for gas savings.
1328             // The duplicated `log4` removes an extra check and reduces stack juggling.
1329             // The assembly, together with the surrounding Solidity code, have been
1330             // delicately arranged to nudge the compiler into producing optimized opcodes.
1331             assembly {
1332                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1333                 toMasked := and(to, _BITMASK_ADDRESS)
1334                 // Emit the `Transfer` event.
1335                 log4(
1336                     0, // Start of data (0, since no data).
1337                     0, // End of data (0, since no data).
1338                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1339                     0, // `address(0)`.
1340                     toMasked, // `to`.
1341                     startTokenId // `tokenId`.
1342                 )
1343 
1344                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1345                 // that overflows uint256 will make the loop run out of gas.
1346                 // The compiler will optimize the `iszero` away for performance.
1347                 for {
1348                     let tokenId := add(startTokenId, 1)
1349                 } iszero(eq(tokenId, end)) {
1350                     tokenId := add(tokenId, 1)
1351                 } {
1352                     // Emit the `Transfer` event. Similar to above.
1353                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1354                 }
1355             }
1356             if (toMasked == 0) revert MintToZeroAddress();
1357 
1358             _currentIndex = end;
1359         }
1360         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1361     }
1362 
1363     /**
1364      * @dev Mints `quantity` tokens and transfers them to `to`.
1365      *
1366      * This function is intended for efficient minting only during contract creation.
1367      *
1368      * It emits only one {ConsecutiveTransfer} as defined in
1369      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1370      * instead of a sequence of {Transfer} event(s).
1371      *
1372      * Calling this function outside of contract creation WILL make your contract
1373      * non-compliant with the ERC721 standard.
1374      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1375      * {ConsecutiveTransfer} event is only permissible during contract creation.
1376      *
1377      * Requirements:
1378      *
1379      * - `to` cannot be the zero address.
1380      * - `quantity` must be greater than 0.
1381      *
1382      * Emits a {ConsecutiveTransfer} event.
1383      */
1384     function _mintERC2309(address to, uint256 quantity) internal virtual {
1385         uint256 startTokenId = _currentIndex;
1386         if (to == address(0)) revert MintToZeroAddress();
1387         if (quantity == 0) revert MintZeroQuantity();
1388         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1389 
1390         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1391 
1392         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1393         unchecked {
1394             // Updates:
1395             // - `balance += quantity`.
1396             // - `numberMinted += quantity`.
1397             //
1398             // We can directly add to the `balance` and `numberMinted`.
1399             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1400 
1401             // Updates:
1402             // - `address` to the owner.
1403             // - `startTimestamp` to the timestamp of minting.
1404             // - `burned` to `false`.
1405             // - `nextInitialized` to `quantity == 1`.
1406             _packedOwnerships[startTokenId] = _packOwnershipData(
1407                 to,
1408                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1409             );
1410 
1411             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1412 
1413             _currentIndex = startTokenId + quantity;
1414         }
1415         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1416     }
1417 
1418     /**
1419      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1420      *
1421      * Requirements:
1422      *
1423      * - If `to` refers to a smart contract, it must implement
1424      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1425      * - `quantity` must be greater than 0.
1426      *
1427      * See {_mint}.
1428      *
1429      * Emits a {Transfer} event for each mint.
1430      */
1431     function _safeMint(
1432         address to,
1433         uint256 quantity,
1434         bytes memory _data
1435     ) internal virtual {
1436         _mint(to, quantity);
1437 
1438         unchecked {
1439             if (to.code.length != 0) {
1440                 uint256 end = _currentIndex;
1441                 uint256 index = end - quantity;
1442                 do {
1443                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1444                         revert TransferToNonERC721ReceiverImplementer();
1445                     }
1446                 } while (index < end);
1447                 // Reentrancy protection.
1448                 if (_currentIndex != end) revert();
1449             }
1450         }
1451     }
1452 
1453     /**
1454      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1455      */
1456     function _safeMint(address to, uint256 quantity) internal virtual {
1457         _safeMint(to, quantity, '');
1458     }
1459 
1460     // =============================================================
1461     //                        BURN OPERATIONS
1462     // =============================================================
1463 
1464     /**
1465      * @dev Equivalent to `_burn(tokenId, false)`.
1466      */
1467     function _burn(uint256 tokenId) internal virtual {
1468         _burn(tokenId, false);
1469     }
1470 
1471     /**
1472      * @dev Destroys `tokenId`.
1473      * The approval is cleared when the token is burned.
1474      *
1475      * Requirements:
1476      *
1477      * - `tokenId` must exist.
1478      *
1479      * Emits a {Transfer} event.
1480      */
1481     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1482         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1483 
1484         address from = address(uint160(prevOwnershipPacked));
1485 
1486         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1487 
1488         if (approvalCheck) {
1489             // The nested ifs save around 20+ gas over a compound boolean condition.
1490             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1491                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1492         }
1493 
1494         _beforeTokenTransfers(from, address(0), tokenId, 1);
1495 
1496         // Clear approvals from the previous owner.
1497         assembly {
1498             if approvedAddress {
1499                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1500                 sstore(approvedAddressSlot, 0)
1501             }
1502         }
1503 
1504         // Underflow of the sender's balance is impossible because we check for
1505         // ownership above and the recipient's balance can't realistically overflow.
1506         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1507         unchecked {
1508             // Updates:
1509             // - `balance -= 1`.
1510             // - `numberBurned += 1`.
1511             //
1512             // We can directly decrement the balance, and increment the number burned.
1513             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1514             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1515 
1516             // Updates:
1517             // - `address` to the last owner.
1518             // - `startTimestamp` to the timestamp of burning.
1519             // - `burned` to `true`.
1520             // - `nextInitialized` to `true`.
1521             _packedOwnerships[tokenId] = _packOwnershipData(
1522                 from,
1523                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1524             );
1525 
1526             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1527             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1528                 uint256 nextTokenId = tokenId + 1;
1529                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1530                 if (_packedOwnerships[nextTokenId] == 0) {
1531                     // If the next slot is within bounds.
1532                     if (nextTokenId != _currentIndex) {
1533                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1534                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1535                     }
1536                 }
1537             }
1538         }
1539 
1540         emit Transfer(from, address(0), tokenId);
1541         _afterTokenTransfers(from, address(0), tokenId, 1);
1542 
1543         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1544         unchecked {
1545             _burnCounter++;
1546         }
1547     }
1548 
1549     // =============================================================
1550     //                     EXTRA DATA OPERATIONS
1551     // =============================================================
1552 
1553     /**
1554      * @dev Directly sets the extra data for the ownership data `index`.
1555      */
1556     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1557         uint256 packed = _packedOwnerships[index];
1558         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1559         uint256 extraDataCasted;
1560         // Cast `extraData` with assembly to avoid redundant masking.
1561         assembly {
1562             extraDataCasted := extraData
1563         }
1564         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1565         _packedOwnerships[index] = packed;
1566     }
1567 
1568     /**
1569      * @dev Called during each token transfer to set the 24bit `extraData` field.
1570      * Intended to be overridden by the cosumer contract.
1571      *
1572      * `previousExtraData` - the value of `extraData` before transfer.
1573      *
1574      * Calling conditions:
1575      *
1576      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1577      * transferred to `to`.
1578      * - When `from` is zero, `tokenId` will be minted for `to`.
1579      * - When `to` is zero, `tokenId` will be burned by `from`.
1580      * - `from` and `to` are never both zero.
1581      */
1582     function _extraData(
1583         address from,
1584         address to,
1585         uint24 previousExtraData
1586     ) internal view virtual returns (uint24) {}
1587 
1588     /**
1589      * @dev Returns the next extra data for the packed ownership data.
1590      * The returned result is shifted into position.
1591      */
1592     function _nextExtraData(
1593         address from,
1594         address to,
1595         uint256 prevOwnershipPacked
1596     ) private view returns (uint256) {
1597         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1598         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1599     }
1600 
1601     // =============================================================
1602     //                       OTHER OPERATIONS
1603     // =============================================================
1604 
1605     /**
1606      * @dev Returns the message sender (defaults to `msg.sender`).
1607      *
1608      * If you are writing GSN compatible contracts, you need to override this function.
1609      */
1610     function _msgSenderERC721A() internal view virtual returns (address) {
1611         return msg.sender;
1612     }
1613 
1614     /**
1615      * @dev Converts a uint256 to its ASCII string decimal representation.
1616      */
1617     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1618         assembly {
1619             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1620             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1621             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1622             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1623             let m := add(mload(0x40), 0xa0)
1624             // Update the free memory pointer to allocate.
1625             mstore(0x40, m)
1626             // Assign the `str` to the end.
1627             str := sub(m, 0x20)
1628             // Zeroize the slot after the string.
1629             mstore(str, 0)
1630 
1631             // Cache the end of the memory to calculate the length later.
1632             let end := str
1633 
1634             // We write the string from rightmost digit to leftmost digit.
1635             // The following is essentially a do-while loop that also handles the zero case.
1636             // prettier-ignore
1637             for { let temp := value } 1 {} {
1638                 str := sub(str, 1)
1639                 // Write the character to the pointer.
1640                 // The ASCII index of the '0' character is 48.
1641                 mstore8(str, add(48, mod(temp, 10)))
1642                 // Keep dividing `temp` until zero.
1643                 temp := div(temp, 10)
1644                 // prettier-ignore
1645                 if iszero(temp) { break }
1646             }
1647 
1648             let length := sub(end, str)
1649             // Move the pointer 32 bytes leftwards to make room for the length.
1650             str := sub(str, 0x20)
1651             // Store the length.
1652             mstore(str, length)
1653         }
1654     }
1655 }
1656 
1657 // File: @openzeppelin/contracts/utils/Context.sol
1658 
1659 
1660 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1661 
1662 pragma solidity ^0.8.0;
1663 
1664 /**
1665  * @dev Provides information about the current execution context, including the
1666  * sender of the transaction and its data. While these are generally available
1667  * via msg.sender and msg.data, they should not be accessed in such a direct
1668  * manner, since when dealing with meta-transactions the account sending and
1669  * paying for execution may not be the actual sender (as far as an application
1670  * is concerned).
1671  *
1672  * This contract is only required for intermediate, library-like contracts.
1673  */
1674 abstract contract Context {
1675     function _msgSender() internal view virtual returns (address) {
1676         return msg.sender;
1677     }
1678 
1679     function _msgData() internal view virtual returns (bytes calldata) {
1680         return msg.data;
1681     }
1682 }
1683 
1684 // File: @openzeppelin/contracts/access/Ownable.sol
1685 
1686 
1687 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1688 
1689 pragma solidity ^0.8.0;
1690 
1691 
1692 /**
1693  * @dev Contract module which provides a basic access control mechanism, where
1694  * there is an account (an owner) that can be granted exclusive access to
1695  * specific functions.
1696  *
1697  * By default, the owner account will be the one that deploys the contract. This
1698  * can later be changed with {transferOwnership}.
1699  *
1700  * This module is used through inheritance. It will make available the modifier
1701  * `onlyOwner`, which can be applied to your functions to restrict their use to
1702  * the owner.
1703  */
1704 abstract contract Ownable is Context {
1705     address private _owner;
1706 
1707     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1708 
1709     /**
1710      * @dev Initializes the contract setting the deployer as the initial owner.
1711      */
1712     constructor() {
1713         _transferOwnership(_msgSender());
1714     }
1715 
1716     /**
1717      * @dev Throws if called by any account other than the owner.
1718      */
1719     modifier onlyOwner() {
1720         _checkOwner();
1721         _;
1722     }
1723 
1724     /**
1725      * @dev Returns the address of the current owner.
1726      */
1727     function owner() public view virtual returns (address) {
1728         return _owner;
1729     }
1730 
1731     /**
1732      * @dev Throws if the sender is not the owner.
1733      */
1734     function _checkOwner() internal view virtual {
1735         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1736     }
1737 
1738     /**
1739      * @dev Leaves the contract without owner. It will not be possible to call
1740      * `onlyOwner` functions anymore. Can only be called by the current owner.
1741      *
1742      * NOTE: Renouncing ownership will leave the contract without an owner,
1743      * thereby removing any functionality that is only available to the owner.
1744      */
1745     function renounceOwnership() public virtual onlyOwner {
1746         _transferOwnership(address(0));
1747     }
1748 
1749     /**
1750      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1751      * Can only be called by the current owner.
1752      */
1753     function transferOwnership(address newOwner) public virtual onlyOwner {
1754         require(newOwner != address(0), "Ownable: new owner is the zero address");
1755         _transferOwnership(newOwner);
1756     }
1757 
1758     /**
1759      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1760      * Internal function without access restriction.
1761      */
1762     function _transferOwnership(address newOwner) internal virtual {
1763         address oldOwner = _owner;
1764         _owner = newOwner;
1765         emit OwnershipTransferred(oldOwner, newOwner);
1766     }
1767 }
1768 
1769 // File: contracts/TheAiRevolution.sol
1770 
1771 pragma solidity ^0.8.0;
1772 
1773 contract TheAiRevolution is Ownable, ERC721A, ReentrancyGuard {
1774     string   public       baseURI;
1775     bool     public       publicSale                      = false;
1776     uint256  public       nbFree                          = 50;
1777     uint256  public       price                           = 0.001 ether;
1778     uint     public       maxFreePerWallet                = 1;
1779     uint     public       maxPerTx                        = 10;
1780     uint     public       maxSupply                       = 1000;
1781 
1782     constructor() ERC721A("AIRevolution", "AIRevolution") {}
1783 
1784     modifier callerIsUser() {
1785         require(tx.origin == msg.sender, "The caller is another contract");
1786         _;
1787     }
1788 
1789     function setFree(uint256 nb) external onlyOwner {
1790         nbFree = nb;
1791     }
1792 
1793     function freeMint(uint256 quantity) external callerIsUser {
1794         require(publicSale, "Public sale has not begun yet");
1795         require(totalSupply() + quantity <= nbFree, "Reached max free supply");
1796         require(numberMinted(msg.sender) + quantity <= maxFreePerWallet,"Too many free per wallet!");
1797         _safeMint(msg.sender, quantity);
1798     }
1799 
1800 
1801   function setMaxFreePerWallet(uint256 maxFreePerWallet_) external onlyOwner {
1802       maxFreePerWallet = maxFreePerWallet_;
1803   }
1804 
1805     function mint(uint256 quantity) external payable callerIsUser {
1806         require(publicSale, "Public sale has not begun yet");
1807         require(
1808             totalSupply() + quantity <= maxSupply,
1809             "Reached max supply"
1810         );
1811         require(quantity <= maxPerTx, "can not mint this many at a time");
1812         require(
1813             msg.value >= quantity * price, "Ether value sent is not correct"
1814             
1815         );
1816 
1817         _safeMint(msg.sender, quantity);
1818     }
1819 
1820   function ownerMint(uint256 quantity) external onlyOwner
1821   {
1822     require(totalSupply() + quantity < maxSupply + 1,"too many!");
1823 
1824     _safeMint(msg.sender, quantity);
1825   }
1826 
1827 
1828   function setmaxPerTx(uint256 maxPerTx_) external onlyOwner {
1829       maxPerTx = maxPerTx_;
1830   }
1831 
1832   function setmaxSupply(uint256 maxSupply_) external onlyOwner {
1833       maxSupply = maxSupply_;
1834   }
1835 
1836 
1837 	function setprice(uint256 _newprice) public onlyOwner {
1838 	    price = _newprice;
1839 	}
1840     
1841     function setSaleState(bool state) external onlyOwner {
1842         publicSale = state;
1843     }
1844 
1845 
1846   function setBaseURI(string calldata baseURI_) external onlyOwner {
1847     baseURI = baseURI_;
1848   }
1849 
1850   function _baseURI() internal view virtual override returns (string memory) {
1851     return baseURI;
1852   }
1853 
1854     function withdraw() external onlyOwner nonReentrant {
1855         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1856         require(success, "Transfer failed.");
1857     }
1858 
1859 
1860     function numberMinted(address owner) public view returns (uint256) {
1861         return _numberMinted(owner);
1862     }
1863 
1864     
1865 }