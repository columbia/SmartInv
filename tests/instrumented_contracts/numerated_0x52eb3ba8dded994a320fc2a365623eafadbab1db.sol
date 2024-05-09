1 // File: contracts/IOperatorFilterRegistry.sol
2 
3 
4 pragma solidity ^0.8.13;
5 
6 interface IOperatorFilterRegistry {
7     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
8     function register(address registrant) external;
9     function registerAndSubscribe(address registrant, address subscription) external;
10     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
11     function unregister(address addr) external;
12     function updateOperator(address registrant, address operator, bool filtered) external;
13     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
14     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
15     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
16     function subscribe(address registrant, address registrantToSubscribe) external;
17     function unsubscribe(address registrant, bool copyExistingEntries) external;
18     function subscriptionOf(address addr) external returns (address registrant);
19     function subscribers(address registrant) external returns (address[] memory);
20     function subscriberAt(address registrant, uint256 index) external returns (address);
21     function copyEntriesOf(address registrant, address registrantToCopy) external;
22     function isOperatorFiltered(address registrant, address operator) external returns (bool);
23     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
24     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
25     function filteredOperators(address addr) external returns (address[] memory);
26     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
27     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
28     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
29     function isRegistered(address addr) external returns (bool);
30     function codeHashOf(address addr) external returns (bytes32);
31 }
32 
33 // File: contracts/OperatorFilterer.sol
34 
35 
36 pragma solidity ^0.8.13;
37 
38 
39 abstract contract OperatorFilterer {
40     error OperatorNotAllowed(address operator);
41 
42     IOperatorFilterRegistry constant operatorFilterRegistry =
43         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
44 
45     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
46         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
47         // will not revert, but the contract will need to be registered with the registry once it is deployed in
48         // order for the modifier to filter addresses.
49         if (address(operatorFilterRegistry).code.length > 0) {
50             if (subscribe) {
51                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
52             } else {
53                 if (subscriptionOrRegistrantToCopy != address(0)) {
54                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
55                 } else {
56                     operatorFilterRegistry.register(address(this));
57                 }
58             }
59         }
60     }
61 
62     modifier onlyAllowedOperator(address from) virtual {
63         // Check registry code length to facilitate testing in environments without a deployed registry.
64         if (address(operatorFilterRegistry).code.length > 0) {
65             // Allow spending tokens from addresses with balance
66             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
67             // from an EOA.
68             if (from == msg.sender) {
69                 _;
70                 return;
71             }
72             if (
73                 !(
74                     operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
75                         && operatorFilterRegistry.isOperatorAllowed(address(this), from)
76                 )
77             ) {
78                 revert OperatorNotAllowed(msg.sender);
79             }
80         }
81         _;
82     }
83 }
84 
85 // File: contracts/DefaultOperatorFilterer.sol
86 
87 
88 pragma solidity ^0.8.13;
89 
90 
91 abstract contract DefaultOperatorFilterer is OperatorFilterer {
92     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
93 
94     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
95 }
96 
97 // File: @openzeppelin/contracts/utils/Context.sol
98 
99 
100 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
101 
102 pragma solidity ^0.8.0;
103 
104 /**
105  * @dev Provides information about the current execution context, including the
106  * sender of the transaction and its data. While these are generally available
107  * via msg.sender and msg.data, they should not be accessed in such a direct
108  * manner, since when dealing with meta-transactions the account sending and
109  * paying for execution may not be the actual sender (as far as an application
110  * is concerned).
111  *
112  * This contract is only required for intermediate, library-like contracts.
113  */
114 abstract contract Context {
115     function _msgSender() internal view virtual returns (address) {
116         return msg.sender;
117     }
118 
119     function _msgData() internal view virtual returns (bytes calldata) {
120         return msg.data;
121     }
122 }
123 
124 // File: @openzeppelin/contracts/security/Pausable.sol
125 
126 
127 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
128 
129 pragma solidity ^0.8.0;
130 
131 
132 /**
133  * @dev Contract module which allows children to implement an emergency stop
134  * mechanism that can be triggered by an authorized account.
135  *
136  * This module is used through inheritance. It will make available the
137  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
138  * the functions of your contract. Note that they will not be pausable by
139  * simply including this module, only once the modifiers are put in place.
140  */
141 abstract contract Pausable is Context {
142     /**
143      * @dev Emitted when the pause is triggered by `account`.
144      */
145     event Paused(address account);
146 
147     /**
148      * @dev Emitted when the pause is lifted by `account`.
149      */
150     event Unpaused(address account);
151 
152     bool private _paused;
153 
154     /**
155      * @dev Initializes the contract in unpaused state.
156      */
157     constructor() {
158         _paused = false;
159     }
160 
161     /**
162      * @dev Modifier to make a function callable only when the contract is not paused.
163      *
164      * Requirements:
165      *
166      * - The contract must not be paused.
167      */
168     modifier whenNotPaused() {
169         _requireNotPaused();
170         _;
171     }
172 
173     /**
174      * @dev Modifier to make a function callable only when the contract is paused.
175      *
176      * Requirements:
177      *
178      * - The contract must be paused.
179      */
180     modifier whenPaused() {
181         _requirePaused();
182         _;
183     }
184 
185     /**
186      * @dev Returns true if the contract is paused, and false otherwise.
187      */
188     function paused() public view virtual returns (bool) {
189         return _paused;
190     }
191 
192     /**
193      * @dev Throws if the contract is paused.
194      */
195     function _requireNotPaused() internal view virtual {
196         require(!paused(), "Pausable: paused");
197     }
198 
199     /**
200      * @dev Throws if the contract is not paused.
201      */
202     function _requirePaused() internal view virtual {
203         require(paused(), "Pausable: not paused");
204     }
205 
206     /**
207      * @dev Triggers stopped state.
208      *
209      * Requirements:
210      *
211      * - The contract must not be paused.
212      */
213     function _pause() internal virtual whenNotPaused {
214         _paused = true;
215         emit Paused(_msgSender());
216     }
217 
218     /**
219      * @dev Returns to normal state.
220      *
221      * Requirements:
222      *
223      * - The contract must be paused.
224      */
225     function _unpause() internal virtual whenPaused {
226         _paused = false;
227         emit Unpaused(_msgSender());
228     }
229 }
230 
231 // File: @openzeppelin/contracts/access/Ownable.sol
232 
233 
234 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
235 
236 pragma solidity ^0.8.0;
237 
238 
239 /**
240  * @dev Contract module which provides a basic access control mechanism, where
241  * there is an account (an owner) that can be granted exclusive access to
242  * specific functions.
243  *
244  * By default, the owner account will be the one that deploys the contract. This
245  * can later be changed with {transferOwnership}.
246  *
247  * This module is used through inheritance. It will make available the modifier
248  * `onlyOwner`, which can be applied to your functions to restrict their use to
249  * the owner.
250  */
251 abstract contract Ownable is Context {
252     address private _owner;
253 
254     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
255 
256     /**
257      * @dev Initializes the contract setting the deployer as the initial owner.
258      */
259     constructor() {
260         _transferOwnership(_msgSender());
261     }
262 
263     /**
264      * @dev Throws if called by any account other than the owner.
265      */
266     modifier onlyOwner() {
267         _checkOwner();
268         _;
269     }
270 
271     /**
272      * @dev Returns the address of the current owner.
273      */
274     function owner() public view virtual returns (address) {
275         return _owner;
276     }
277 
278     /**
279      * @dev Throws if the sender is not the owner.
280      */
281     function _checkOwner() internal view virtual {
282         require(owner() == _msgSender(), "Ownable: caller is not the owner");
283     }
284 
285     /**
286      * @dev Leaves the contract without owner. It will not be possible to call
287      * `onlyOwner` functions anymore. Can only be called by the current owner.
288      *
289      * NOTE: Renouncing ownership will leave the contract without an owner,
290      * thereby removing any functionality that is only available to the owner.
291      */
292     function renounceOwnership() public virtual onlyOwner {
293         _transferOwnership(address(0));
294     }
295 
296     /**
297      * @dev Transfers ownership of the contract to a new account (`newOwner`).
298      * Can only be called by the current owner.
299      */
300     function transferOwnership(address newOwner) public virtual onlyOwner {
301         require(newOwner != address(0), "Ownable: new owner is the zero address");
302         _transferOwnership(newOwner);
303     }
304 
305     /**
306      * @dev Transfers ownership of the contract to a new account (`newOwner`).
307      * Internal function without access restriction.
308      */
309     function _transferOwnership(address newOwner) internal virtual {
310         address oldOwner = _owner;
311         _owner = newOwner;
312         emit OwnershipTransferred(oldOwner, newOwner);
313     }
314 }
315 
316 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
317 
318 
319 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
320 
321 pragma solidity ^0.8.0;
322 
323 /**
324  * @dev Interface of the ERC165 standard, as defined in the
325  * https://eips.ethereum.org/EIPS/eip-165[EIP].
326  *
327  * Implementers can declare support of contract interfaces, which can then be
328  * queried by others ({ERC165Checker}).
329  *
330  * For an implementation, see {ERC165}.
331  */
332 interface IERC165 {
333     /**
334      * @dev Returns true if this contract implements the interface defined by
335      * `interfaceId`. See the corresponding
336      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
337      * to learn more about how these ids are created.
338      *
339      * This function call must use less than 30 000 gas.
340      */
341     function supportsInterface(bytes4 interfaceId) external view returns (bool);
342 }
343 
344 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
345 
346 
347 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
348 
349 pragma solidity ^0.8.0;
350 
351 
352 /**
353  * @dev Required interface of an ERC721 compliant contract.
354  */
355 interface IERC721 is IERC165 {
356     /**
357      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
358      */
359     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
360 
361     /**
362      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
363      */
364     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
365 
366     /**
367      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
368      */
369     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
370 
371     /**
372      * @dev Returns the number of tokens in ``owner``'s account.
373      */
374     function balanceOf(address owner) external view returns (uint256 balance);
375 
376     /**
377      * @dev Returns the owner of the `tokenId` token.
378      *
379      * Requirements:
380      *
381      * - `tokenId` must exist.
382      */
383     function ownerOf(uint256 tokenId) external view returns (address owner);
384 
385     /**
386      * @dev Safely transfers `tokenId` token from `from` to `to`.
387      *
388      * Requirements:
389      *
390      * - `from` cannot be the zero address.
391      * - `to` cannot be the zero address.
392      * - `tokenId` token must exist and be owned by `from`.
393      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
394      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
395      *
396      * Emits a {Transfer} event.
397      */
398     function safeTransferFrom(
399         address from,
400         address to,
401         uint256 tokenId,
402         bytes calldata data
403     ) external;
404 
405     /**
406      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
407      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
408      *
409      * Requirements:
410      *
411      * - `from` cannot be the zero address.
412      * - `to` cannot be the zero address.
413      * - `tokenId` token must exist and be owned by `from`.
414      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
415      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
416      *
417      * Emits a {Transfer} event.
418      */
419     function safeTransferFrom(
420         address from,
421         address to,
422         uint256 tokenId
423     ) external;
424 
425     /**
426      * @dev Transfers `tokenId` token from `from` to `to`.
427      *
428      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
429      *
430      * Requirements:
431      *
432      * - `from` cannot be the zero address.
433      * - `to` cannot be the zero address.
434      * - `tokenId` token must be owned by `from`.
435      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
436      *
437      * Emits a {Transfer} event.
438      */
439     function transferFrom(
440         address from,
441         address to,
442         uint256 tokenId
443     ) external;
444 
445     /**
446      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
447      * The approval is cleared when the token is transferred.
448      *
449      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
450      *
451      * Requirements:
452      *
453      * - The caller must own the token or be an approved operator.
454      * - `tokenId` must exist.
455      *
456      * Emits an {Approval} event.
457      */
458     function approve(address to, uint256 tokenId) external;
459 
460     /**
461      * @dev Approve or remove `operator` as an operator for the caller.
462      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
463      *
464      * Requirements:
465      *
466      * - The `operator` cannot be the caller.
467      *
468      * Emits an {ApprovalForAll} event.
469      */
470     function setApprovalForAll(address operator, bool _approved) external;
471 
472     /**
473      * @dev Returns the account approved for `tokenId` token.
474      *
475      * Requirements:
476      *
477      * - `tokenId` must exist.
478      */
479     function getApproved(uint256 tokenId) external view returns (address operator);
480 
481     /**
482      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
483      *
484      * See {setApprovalForAll}
485      */
486     function isApprovedForAll(address owner, address operator) external view returns (bool);
487 }
488 
489 // File: erc721a/contracts/IERC721A.sol
490 
491 
492 // ERC721A Contracts v4.2.3
493 // Creator: Chiru Labs
494 
495 pragma solidity ^0.8.4;
496 
497 /**
498  * @dev Interface of ERC721A.
499  */
500 interface IERC721A {
501     /**
502      * The caller must own the token or be an approved operator.
503      */
504     error ApprovalCallerNotOwnerNorApproved();
505 
506     /**
507      * The token does not exist.
508      */
509     error ApprovalQueryForNonexistentToken();
510 
511     /**
512      * Cannot query the balance for the zero address.
513      */
514     error BalanceQueryForZeroAddress();
515 
516     /**
517      * Cannot mint to the zero address.
518      */
519     error MintToZeroAddress();
520 
521     /**
522      * The quantity of tokens minted must be more than zero.
523      */
524     error MintZeroQuantity();
525 
526     /**
527      * The token does not exist.
528      */
529     error OwnerQueryForNonexistentToken();
530 
531     /**
532      * The caller must own the token or be an approved operator.
533      */
534     error TransferCallerNotOwnerNorApproved();
535 
536     /**
537      * The token must be owned by `from`.
538      */
539     error TransferFromIncorrectOwner();
540 
541     /**
542      * Cannot safely transfer to a contract that does not implement the
543      * ERC721Receiver interface.
544      */
545     error TransferToNonERC721ReceiverImplementer();
546 
547     /**
548      * Cannot transfer to the zero address.
549      */
550     error TransferToZeroAddress();
551 
552     /**
553      * The token does not exist.
554      */
555     error URIQueryForNonexistentToken();
556 
557     /**
558      * The `quantity` minted with ERC2309 exceeds the safety limit.
559      */
560     error MintERC2309QuantityExceedsLimit();
561 
562     /**
563      * The `extraData` cannot be set on an unintialized ownership slot.
564      */
565     error OwnershipNotInitializedForExtraData();
566 
567     // =============================================================
568     //                            STRUCTS
569     // =============================================================
570 
571     struct TokenOwnership {
572         // The address of the owner.
573         address addr;
574         // Stores the start time of ownership with minimal overhead for tokenomics.
575         uint64 startTimestamp;
576         // Whether the token has been burned.
577         bool burned;
578         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
579         uint24 extraData;
580     }
581 
582     // =============================================================
583     //                         TOKEN COUNTERS
584     // =============================================================
585 
586     /**
587      * @dev Returns the total number of tokens in existence.
588      * Burned tokens will reduce the count.
589      * To get the total number of tokens minted, please see {_totalMinted}.
590      */
591     function totalSupply() external view returns (uint256);
592 
593     // =============================================================
594     //                            IERC165
595     // =============================================================
596 
597     /**
598      * @dev Returns true if this contract implements the interface defined by
599      * `interfaceId`. See the corresponding
600      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
601      * to learn more about how these ids are created.
602      *
603      * This function call must use less than 30000 gas.
604      */
605     function supportsInterface(bytes4 interfaceId) external view returns (bool);
606 
607     // =============================================================
608     //                            IERC721
609     // =============================================================
610 
611     /**
612      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
613      */
614     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
615 
616     /**
617      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
618      */
619     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
620 
621     /**
622      * @dev Emitted when `owner` enables or disables
623      * (`approved`) `operator` to manage all of its assets.
624      */
625     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
626 
627     /**
628      * @dev Returns the number of tokens in `owner`'s account.
629      */
630     function balanceOf(address owner) external view returns (uint256 balance);
631 
632     /**
633      * @dev Returns the owner of the `tokenId` token.
634      *
635      * Requirements:
636      *
637      * - `tokenId` must exist.
638      */
639     function ownerOf(uint256 tokenId) external view returns (address owner);
640 
641     /**
642      * @dev Safely transfers `tokenId` token from `from` to `to`,
643      * checking first that contract recipients are aware of the ERC721 protocol
644      * to prevent tokens from being forever locked.
645      *
646      * Requirements:
647      *
648      * - `from` cannot be the zero address.
649      * - `to` cannot be the zero address.
650      * - `tokenId` token must exist and be owned by `from`.
651      * - If the caller is not `from`, it must be have been allowed to move
652      * this token by either {approve} or {setApprovalForAll}.
653      * - If `to` refers to a smart contract, it must implement
654      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
655      *
656      * Emits a {Transfer} event.
657      */
658     function safeTransferFrom(
659         address from,
660         address to,
661         uint256 tokenId,
662         bytes calldata data
663     ) external payable;
664 
665     /**
666      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
667      */
668     function safeTransferFrom(
669         address from,
670         address to,
671         uint256 tokenId
672     ) external payable;
673 
674     /**
675      * @dev Transfers `tokenId` from `from` to `to`.
676      *
677      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
678      * whenever possible.
679      *
680      * Requirements:
681      *
682      * - `from` cannot be the zero address.
683      * - `to` cannot be the zero address.
684      * - `tokenId` token must be owned by `from`.
685      * - If the caller is not `from`, it must be approved to move this token
686      * by either {approve} or {setApprovalForAll}.
687      *
688      * Emits a {Transfer} event.
689      */
690     function transferFrom(
691         address from,
692         address to,
693         uint256 tokenId
694     ) external payable;
695 
696     /**
697      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
698      * The approval is cleared when the token is transferred.
699      *
700      * Only a single account can be approved at a time, so approving the
701      * zero address clears previous approvals.
702      *
703      * Requirements:
704      *
705      * - The caller must own the token or be an approved operator.
706      * - `tokenId` must exist.
707      *
708      * Emits an {Approval} event.
709      */
710     function approve(address to, uint256 tokenId) external payable;
711 
712     /**
713      * @dev Approve or remove `operator` as an operator for the caller.
714      * Operators can call {transferFrom} or {safeTransferFrom}
715      * for any token owned by the caller.
716      *
717      * Requirements:
718      *
719      * - The `operator` cannot be the caller.
720      *
721      * Emits an {ApprovalForAll} event.
722      */
723     function setApprovalForAll(address operator, bool _approved) external;
724 
725     /**
726      * @dev Returns the account approved for `tokenId` token.
727      *
728      * Requirements:
729      *
730      * - `tokenId` must exist.
731      */
732     function getApproved(uint256 tokenId) external view returns (address operator);
733 
734     /**
735      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
736      *
737      * See {setApprovalForAll}.
738      */
739     function isApprovedForAll(address owner, address operator) external view returns (bool);
740 
741     // =============================================================
742     //                        IERC721Metadata
743     // =============================================================
744 
745     /**
746      * @dev Returns the token collection name.
747      */
748     function name() external view returns (string memory);
749 
750     /**
751      * @dev Returns the token collection symbol.
752      */
753     function symbol() external view returns (string memory);
754 
755     /**
756      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
757      */
758     function tokenURI(uint256 tokenId) external view returns (string memory);
759 
760     // =============================================================
761     //                           IERC2309
762     // =============================================================
763 
764     /**
765      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
766      * (inclusive) is transferred from `from` to `to`, as defined in the
767      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
768      *
769      * See {_mintERC2309} for more details.
770      */
771     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
772 }
773 
774 // File: erc721a/contracts/ERC721A.sol
775 
776 
777 // ERC721A Contracts v4.2.3
778 // Creator: Chiru Labs
779 
780 pragma solidity ^0.8.4;
781 
782 
783 /**
784  * @dev Interface of ERC721 token receiver.
785  */
786 interface ERC721A__IERC721Receiver {
787     function onERC721Received(
788         address operator,
789         address from,
790         uint256 tokenId,
791         bytes calldata data
792     ) external returns (bytes4);
793 }
794 
795 /**
796  * @title ERC721A
797  *
798  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
799  * Non-Fungible Token Standard, including the Metadata extension.
800  * Optimized for lower gas during batch mints.
801  *
802  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
803  * starting from `_startTokenId()`.
804  *
805  * Assumptions:
806  *
807  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
808  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
809  */
810 contract ERC721A is IERC721A {
811     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
812     struct TokenApprovalRef {
813         address value;
814     }
815 
816     // =============================================================
817     //                           CONSTANTS
818     // =============================================================
819 
820     // Mask of an entry in packed address data.
821     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
822 
823     // The bit position of `numberMinted` in packed address data.
824     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
825 
826     // The bit position of `numberBurned` in packed address data.
827     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
828 
829     // The bit position of `aux` in packed address data.
830     uint256 private constant _BITPOS_AUX = 192;
831 
832     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
833     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
834 
835     // The bit position of `startTimestamp` in packed ownership.
836     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
837 
838     // The bit mask of the `burned` bit in packed ownership.
839     uint256 private constant _BITMASK_BURNED = 1 << 224;
840 
841     // The bit position of the `nextInitialized` bit in packed ownership.
842     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
843 
844     // The bit mask of the `nextInitialized` bit in packed ownership.
845     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
846 
847     // The bit position of `extraData` in packed ownership.
848     uint256 private constant _BITPOS_EXTRA_DATA = 232;
849 
850     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
851     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
852 
853     // The mask of the lower 160 bits for addresses.
854     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
855 
856     // The maximum `quantity` that can be minted with {_mintERC2309}.
857     // This limit is to prevent overflows on the address data entries.
858     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
859     // is required to cause an overflow, which is unrealistic.
860     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
861 
862     // The `Transfer` event signature is given by:
863     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
864     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
865         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
866 
867     // =============================================================
868     //                            STORAGE
869     // =============================================================
870 
871     // The next token ID to be minted.
872     uint256 private _currentIndex;
873 
874     // The number of tokens burned.
875     uint256 private _burnCounter;
876 
877     // Token name
878     string private _name;
879 
880     // Token symbol
881     string private _symbol;
882 
883     // Mapping from token ID to ownership details
884     // An empty struct value does not necessarily mean the token is unowned.
885     // See {_packedOwnershipOf} implementation for details.
886     //
887     // Bits Layout:
888     // - [0..159]   `addr`
889     // - [160..223] `startTimestamp`
890     // - [224]      `burned`
891     // - [225]      `nextInitialized`
892     // - [232..255] `extraData`
893     mapping(uint256 => uint256) private _packedOwnerships;
894 
895     // Mapping owner address to address data.
896     //
897     // Bits Layout:
898     // - [0..63]    `balance`
899     // - [64..127]  `numberMinted`
900     // - [128..191] `numberBurned`
901     // - [192..255] `aux`
902     mapping(address => uint256) private _packedAddressData;
903 
904     // Mapping from token ID to approved address.
905     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
906 
907     // Mapping from owner to operator approvals
908     mapping(address => mapping(address => bool)) private _operatorApprovals;
909 
910     // =============================================================
911     //                          CONSTRUCTOR
912     // =============================================================
913 
914     constructor(string memory name_, string memory symbol_) {
915         _name = name_;
916         _symbol = symbol_;
917         _currentIndex = _startTokenId();
918     }
919 
920     // =============================================================
921     //                   TOKEN COUNTING OPERATIONS
922     // =============================================================
923 
924     /**
925      * @dev Returns the starting token ID.
926      * To change the starting token ID, please override this function.
927      */
928     function _startTokenId() internal view virtual returns (uint256) {
929         return 0;
930     }
931 
932     /**
933      * @dev Returns the next token ID to be minted.
934      */
935     function _nextTokenId() internal view virtual returns (uint256) {
936         return _currentIndex;
937     }
938 
939     /**
940      * @dev Returns the total number of tokens in existence.
941      * Burned tokens will reduce the count.
942      * To get the total number of tokens minted, please see {_totalMinted}.
943      */
944     function totalSupply() public view virtual override returns (uint256) {
945         // Counter underflow is impossible as _burnCounter cannot be incremented
946         // more than `_currentIndex - _startTokenId()` times.
947         unchecked {
948             return _currentIndex - _burnCounter - _startTokenId();
949         }
950     }
951 
952     /**
953      * @dev Returns the total amount of tokens minted in the contract.
954      */
955     function _totalMinted() internal view virtual returns (uint256) {
956         // Counter underflow is impossible as `_currentIndex` does not decrement,
957         // and it is initialized to `_startTokenId()`.
958         unchecked {
959             return _currentIndex - _startTokenId();
960         }
961     }
962 
963     /**
964      * @dev Returns the total number of tokens burned.
965      */
966     function _totalBurned() internal view virtual returns (uint256) {
967         return _burnCounter;
968     }
969 
970     // =============================================================
971     //                    ADDRESS DATA OPERATIONS
972     // =============================================================
973 
974     /**
975      * @dev Returns the number of tokens in `owner`'s account.
976      */
977     function balanceOf(address owner) public view virtual override returns (uint256) {
978         if (owner == address(0)) revert BalanceQueryForZeroAddress();
979         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
980     }
981 
982     /**
983      * Returns the number of tokens minted by `owner`.
984      */
985     function _numberMinted(address owner) internal view returns (uint256) {
986         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
987     }
988 
989     /**
990      * Returns the number of tokens burned by or on behalf of `owner`.
991      */
992     function _numberBurned(address owner) internal view returns (uint256) {
993         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
994     }
995 
996     /**
997      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
998      */
999     function _getAux(address owner) internal view returns (uint64) {
1000         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1001     }
1002 
1003     /**
1004      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1005      * If there are multiple variables, please pack them into a uint64.
1006      */
1007     function _setAux(address owner, uint64 aux) internal virtual {
1008         uint256 packed = _packedAddressData[owner];
1009         uint256 auxCasted;
1010         // Cast `aux` with assembly to avoid redundant masking.
1011         assembly {
1012             auxCasted := aux
1013         }
1014         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1015         _packedAddressData[owner] = packed;
1016     }
1017 
1018     // =============================================================
1019     //                            IERC165
1020     // =============================================================
1021 
1022     /**
1023      * @dev Returns true if this contract implements the interface defined by
1024      * `interfaceId`. See the corresponding
1025      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1026      * to learn more about how these ids are created.
1027      *
1028      * This function call must use less than 30000 gas.
1029      */
1030     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1031         // The interface IDs are constants representing the first 4 bytes
1032         // of the XOR of all function selectors in the interface.
1033         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1034         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1035         return
1036             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1037             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1038             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1039     }
1040 
1041     // =============================================================
1042     //                        IERC721Metadata
1043     // =============================================================
1044 
1045     /**
1046      * @dev Returns the token collection name.
1047      */
1048     function name() public view virtual override returns (string memory) {
1049         return _name;
1050     }
1051 
1052     /**
1053      * @dev Returns the token collection symbol.
1054      */
1055     function symbol() public view virtual override returns (string memory) {
1056         return _symbol;
1057     }
1058 
1059     /**
1060      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1061      */
1062     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1063         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1064 
1065         string memory baseURI = _baseURI();
1066         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1067     }
1068 
1069     /**
1070      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1071      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1072      * by default, it can be overridden in child contracts.
1073      */
1074     function _baseURI() internal view virtual returns (string memory) {
1075         return '';
1076     }
1077 
1078     // =============================================================
1079     //                     OWNERSHIPS OPERATIONS
1080     // =============================================================
1081 
1082     /**
1083      * @dev Returns the owner of the `tokenId` token.
1084      *
1085      * Requirements:
1086      *
1087      * - `tokenId` must exist.
1088      */
1089     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1090         return address(uint160(_packedOwnershipOf(tokenId)));
1091     }
1092 
1093     /**
1094      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1095      * It gradually moves to O(1) as tokens get transferred around over time.
1096      */
1097     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1098         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1099     }
1100 
1101     /**
1102      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1103      */
1104     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1105         return _unpackedOwnership(_packedOwnerships[index]);
1106     }
1107 
1108     /**
1109      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1110      */
1111     function _initializeOwnershipAt(uint256 index) internal virtual {
1112         if (_packedOwnerships[index] == 0) {
1113             _packedOwnerships[index] = _packedOwnershipOf(index);
1114         }
1115     }
1116 
1117     /**
1118      * Returns the packed ownership data of `tokenId`.
1119      */
1120     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1121         uint256 curr = tokenId;
1122 
1123         unchecked {
1124             if (_startTokenId() <= curr)
1125                 if (curr < _currentIndex) {
1126                     uint256 packed = _packedOwnerships[curr];
1127                     // If not burned.
1128                     if (packed & _BITMASK_BURNED == 0) {
1129                         // Invariant:
1130                         // There will always be an initialized ownership slot
1131                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1132                         // before an unintialized ownership slot
1133                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1134                         // Hence, `curr` will not underflow.
1135                         //
1136                         // We can directly compare the packed value.
1137                         // If the address is zero, packed will be zero.
1138                         while (packed == 0) {
1139                             packed = _packedOwnerships[--curr];
1140                         }
1141                         return packed;
1142                     }
1143                 }
1144         }
1145         revert OwnerQueryForNonexistentToken();
1146     }
1147 
1148     /**
1149      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1150      */
1151     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1152         ownership.addr = address(uint160(packed));
1153         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1154         ownership.burned = packed & _BITMASK_BURNED != 0;
1155         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1156     }
1157 
1158     /**
1159      * @dev Packs ownership data into a single uint256.
1160      */
1161     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1162         assembly {
1163             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1164             owner := and(owner, _BITMASK_ADDRESS)
1165             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1166             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1167         }
1168     }
1169 
1170     /**
1171      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1172      */
1173     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1174         // For branchless setting of the `nextInitialized` flag.
1175         assembly {
1176             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1177             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1178         }
1179     }
1180 
1181     // =============================================================
1182     //                      APPROVAL OPERATIONS
1183     // =============================================================
1184 
1185     /**
1186      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1187      * The approval is cleared when the token is transferred.
1188      *
1189      * Only a single account can be approved at a time, so approving the
1190      * zero address clears previous approvals.
1191      *
1192      * Requirements:
1193      *
1194      * - The caller must own the token or be an approved operator.
1195      * - `tokenId` must exist.
1196      *
1197      * Emits an {Approval} event.
1198      */
1199     function approve(address to, uint256 tokenId) public payable virtual override {
1200         address owner = ownerOf(tokenId);
1201 
1202         if (_msgSenderERC721A() != owner)
1203             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1204                 revert ApprovalCallerNotOwnerNorApproved();
1205             }
1206 
1207         _tokenApprovals[tokenId].value = to;
1208         emit Approval(owner, to, tokenId);
1209     }
1210 
1211     /**
1212      * @dev Returns the account approved for `tokenId` token.
1213      *
1214      * Requirements:
1215      *
1216      * - `tokenId` must exist.
1217      */
1218     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1219         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1220 
1221         return _tokenApprovals[tokenId].value;
1222     }
1223 
1224     /**
1225      * @dev Approve or remove `operator` as an operator for the caller.
1226      * Operators can call {transferFrom} or {safeTransferFrom}
1227      * for any token owned by the caller.
1228      *
1229      * Requirements:
1230      *
1231      * - The `operator` cannot be the caller.
1232      *
1233      * Emits an {ApprovalForAll} event.
1234      */
1235     function setApprovalForAll(address operator, bool approved) public virtual override {
1236         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1237         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1238     }
1239 
1240     /**
1241      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1242      *
1243      * See {setApprovalForAll}.
1244      */
1245     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1246         return _operatorApprovals[owner][operator];
1247     }
1248 
1249     /**
1250      * @dev Returns whether `tokenId` exists.
1251      *
1252      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1253      *
1254      * Tokens start existing when they are minted. See {_mint}.
1255      */
1256     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1257         return
1258             _startTokenId() <= tokenId &&
1259             tokenId < _currentIndex && // If within bounds,
1260             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1261     }
1262 
1263     /**
1264      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1265      */
1266     function _isSenderApprovedOrOwner(
1267         address approvedAddress,
1268         address owner,
1269         address msgSender
1270     ) private pure returns (bool result) {
1271         assembly {
1272             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1273             owner := and(owner, _BITMASK_ADDRESS)
1274             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1275             msgSender := and(msgSender, _BITMASK_ADDRESS)
1276             // `msgSender == owner || msgSender == approvedAddress`.
1277             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1278         }
1279     }
1280 
1281     /**
1282      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1283      */
1284     function _getApprovedSlotAndAddress(uint256 tokenId)
1285         private
1286         view
1287         returns (uint256 approvedAddressSlot, address approvedAddress)
1288     {
1289         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1290         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1291         assembly {
1292             approvedAddressSlot := tokenApproval.slot
1293             approvedAddress := sload(approvedAddressSlot)
1294         }
1295     }
1296 
1297     // =============================================================
1298     //                      TRANSFER OPERATIONS
1299     // =============================================================
1300 
1301     /**
1302      * @dev Transfers `tokenId` from `from` to `to`.
1303      *
1304      * Requirements:
1305      *
1306      * - `from` cannot be the zero address.
1307      * - `to` cannot be the zero address.
1308      * - `tokenId` token must be owned by `from`.
1309      * - If the caller is not `from`, it must be approved to move this token
1310      * by either {approve} or {setApprovalForAll}.
1311      *
1312      * Emits a {Transfer} event.
1313      */
1314     function transferFrom(
1315         address from,
1316         address to,
1317         uint256 tokenId
1318     ) public payable virtual override {
1319         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1320 
1321         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1322 
1323         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1324 
1325         // The nested ifs save around 20+ gas over a compound boolean condition.
1326         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1327             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1328 
1329         if (to == address(0)) revert TransferToZeroAddress();
1330 
1331         _beforeTokenTransfers(from, to, tokenId, 1);
1332 
1333         // Clear approvals from the previous owner.
1334         assembly {
1335             if approvedAddress {
1336                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1337                 sstore(approvedAddressSlot, 0)
1338             }
1339         }
1340 
1341         // Underflow of the sender's balance is impossible because we check for
1342         // ownership above and the recipient's balance can't realistically overflow.
1343         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1344         unchecked {
1345             // We can directly increment and decrement the balances.
1346             --_packedAddressData[from]; // Updates: `balance -= 1`.
1347             ++_packedAddressData[to]; // Updates: `balance += 1`.
1348 
1349             // Updates:
1350             // - `address` to the next owner.
1351             // - `startTimestamp` to the timestamp of transfering.
1352             // - `burned` to `false`.
1353             // - `nextInitialized` to `true`.
1354             _packedOwnerships[tokenId] = _packOwnershipData(
1355                 to,
1356                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1357             );
1358 
1359             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1360             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1361                 uint256 nextTokenId = tokenId + 1;
1362                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1363                 if (_packedOwnerships[nextTokenId] == 0) {
1364                     // If the next slot is within bounds.
1365                     if (nextTokenId != _currentIndex) {
1366                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1367                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1368                     }
1369                 }
1370             }
1371         }
1372 
1373         emit Transfer(from, to, tokenId);
1374         _afterTokenTransfers(from, to, tokenId, 1);
1375     }
1376 
1377     /**
1378      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1379      */
1380     function safeTransferFrom(
1381         address from,
1382         address to,
1383         uint256 tokenId
1384     ) public payable virtual override {
1385         safeTransferFrom(from, to, tokenId, '');
1386     }
1387 
1388     /**
1389      * @dev Safely transfers `tokenId` token from `from` to `to`.
1390      *
1391      * Requirements:
1392      *
1393      * - `from` cannot be the zero address.
1394      * - `to` cannot be the zero address.
1395      * - `tokenId` token must exist and be owned by `from`.
1396      * - If the caller is not `from`, it must be approved to move this token
1397      * by either {approve} or {setApprovalForAll}.
1398      * - If `to` refers to a smart contract, it must implement
1399      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1400      *
1401      * Emits a {Transfer} event.
1402      */
1403     function safeTransferFrom(
1404         address from,
1405         address to,
1406         uint256 tokenId,
1407         bytes memory _data
1408     ) public payable virtual override {
1409         transferFrom(from, to, tokenId);
1410         if (to.code.length != 0)
1411             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1412                 revert TransferToNonERC721ReceiverImplementer();
1413             }
1414     }
1415 
1416     /**
1417      * @dev Hook that is called before a set of serially-ordered token IDs
1418      * are about to be transferred. This includes minting.
1419      * And also called before burning one token.
1420      *
1421      * `startTokenId` - the first token ID to be transferred.
1422      * `quantity` - the amount to be transferred.
1423      *
1424      * Calling conditions:
1425      *
1426      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1427      * transferred to `to`.
1428      * - When `from` is zero, `tokenId` will be minted for `to`.
1429      * - When `to` is zero, `tokenId` will be burned by `from`.
1430      * - `from` and `to` are never both zero.
1431      */
1432     function _beforeTokenTransfers(
1433         address from,
1434         address to,
1435         uint256 startTokenId,
1436         uint256 quantity
1437     ) internal virtual {}
1438 
1439     /**
1440      * @dev Hook that is called after a set of serially-ordered token IDs
1441      * have been transferred. This includes minting.
1442      * And also called after one token has been burned.
1443      *
1444      * `startTokenId` - the first token ID to be transferred.
1445      * `quantity` - the amount to be transferred.
1446      *
1447      * Calling conditions:
1448      *
1449      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1450      * transferred to `to`.
1451      * - When `from` is zero, `tokenId` has been minted for `to`.
1452      * - When `to` is zero, `tokenId` has been burned by `from`.
1453      * - `from` and `to` are never both zero.
1454      */
1455     function _afterTokenTransfers(
1456         address from,
1457         address to,
1458         uint256 startTokenId,
1459         uint256 quantity
1460     ) internal virtual {}
1461 
1462     /**
1463      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1464      *
1465      * `from` - Previous owner of the given token ID.
1466      * `to` - Target address that will receive the token.
1467      * `tokenId` - Token ID to be transferred.
1468      * `_data` - Optional data to send along with the call.
1469      *
1470      * Returns whether the call correctly returned the expected magic value.
1471      */
1472     function _checkContractOnERC721Received(
1473         address from,
1474         address to,
1475         uint256 tokenId,
1476         bytes memory _data
1477     ) private returns (bool) {
1478         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1479             bytes4 retval
1480         ) {
1481             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1482         } catch (bytes memory reason) {
1483             if (reason.length == 0) {
1484                 revert TransferToNonERC721ReceiverImplementer();
1485             } else {
1486                 assembly {
1487                     revert(add(32, reason), mload(reason))
1488                 }
1489             }
1490         }
1491     }
1492 
1493     // =============================================================
1494     //                        MINT OPERATIONS
1495     // =============================================================
1496 
1497     /**
1498      * @dev Mints `quantity` tokens and transfers them to `to`.
1499      *
1500      * Requirements:
1501      *
1502      * - `to` cannot be the zero address.
1503      * - `quantity` must be greater than 0.
1504      *
1505      * Emits a {Transfer} event for each mint.
1506      */
1507     function _mint(address to, uint256 quantity) internal virtual {
1508         uint256 startTokenId = _currentIndex;
1509         if (quantity == 0) revert MintZeroQuantity();
1510 
1511         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1512 
1513         // Overflows are incredibly unrealistic.
1514         // `balance` and `numberMinted` have a maximum limit of 2**64.
1515         // `tokenId` has a maximum limit of 2**256.
1516         unchecked {
1517             // Updates:
1518             // - `balance += quantity`.
1519             // - `numberMinted += quantity`.
1520             //
1521             // We can directly add to the `balance` and `numberMinted`.
1522             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1523 
1524             // Updates:
1525             // - `address` to the owner.
1526             // - `startTimestamp` to the timestamp of minting.
1527             // - `burned` to `false`.
1528             // - `nextInitialized` to `quantity == 1`.
1529             _packedOwnerships[startTokenId] = _packOwnershipData(
1530                 to,
1531                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1532             );
1533 
1534             uint256 toMasked;
1535             uint256 end = startTokenId + quantity;
1536 
1537             // Use assembly to loop and emit the `Transfer` event for gas savings.
1538             // The duplicated `log4` removes an extra check and reduces stack juggling.
1539             // The assembly, together with the surrounding Solidity code, have been
1540             // delicately arranged to nudge the compiler into producing optimized opcodes.
1541             assembly {
1542                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1543                 toMasked := and(to, _BITMASK_ADDRESS)
1544                 // Emit the `Transfer` event.
1545                 log4(
1546                     0, // Start of data (0, since no data).
1547                     0, // End of data (0, since no data).
1548                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1549                     0, // `address(0)`.
1550                     toMasked, // `to`.
1551                     startTokenId // `tokenId`.
1552                 )
1553 
1554                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1555                 // that overflows uint256 will make the loop run out of gas.
1556                 // The compiler will optimize the `iszero` away for performance.
1557                 for {
1558                     let tokenId := add(startTokenId, 1)
1559                 } iszero(eq(tokenId, end)) {
1560                     tokenId := add(tokenId, 1)
1561                 } {
1562                     // Emit the `Transfer` event. Similar to above.
1563                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1564                 }
1565             }
1566             if (toMasked == 0) revert MintToZeroAddress();
1567 
1568             _currentIndex = end;
1569         }
1570         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1571     }
1572 
1573     /**
1574      * @dev Mints `quantity` tokens and transfers them to `to`.
1575      *
1576      * This function is intended for efficient minting only during contract creation.
1577      *
1578      * It emits only one {ConsecutiveTransfer} as defined in
1579      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1580      * instead of a sequence of {Transfer} event(s).
1581      *
1582      * Calling this function outside of contract creation WILL make your contract
1583      * non-compliant with the ERC721 standard.
1584      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1585      * {ConsecutiveTransfer} event is only permissible during contract creation.
1586      *
1587      * Requirements:
1588      *
1589      * - `to` cannot be the zero address.
1590      * - `quantity` must be greater than 0.
1591      *
1592      * Emits a {ConsecutiveTransfer} event.
1593      */
1594     function _mintERC2309(address to, uint256 quantity) internal virtual {
1595         uint256 startTokenId = _currentIndex;
1596         if (to == address(0)) revert MintToZeroAddress();
1597         if (quantity == 0) revert MintZeroQuantity();
1598         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1599 
1600         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1601 
1602         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1603         unchecked {
1604             // Updates:
1605             // - `balance += quantity`.
1606             // - `numberMinted += quantity`.
1607             //
1608             // We can directly add to the `balance` and `numberMinted`.
1609             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1610 
1611             // Updates:
1612             // - `address` to the owner.
1613             // - `startTimestamp` to the timestamp of minting.
1614             // - `burned` to `false`.
1615             // - `nextInitialized` to `quantity == 1`.
1616             _packedOwnerships[startTokenId] = _packOwnershipData(
1617                 to,
1618                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1619             );
1620 
1621             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1622 
1623             _currentIndex = startTokenId + quantity;
1624         }
1625         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1626     }
1627 
1628     /**
1629      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1630      *
1631      * Requirements:
1632      *
1633      * - If `to` refers to a smart contract, it must implement
1634      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1635      * - `quantity` must be greater than 0.
1636      *
1637      * See {_mint}.
1638      *
1639      * Emits a {Transfer} event for each mint.
1640      */
1641     function _safeMint(
1642         address to,
1643         uint256 quantity,
1644         bytes memory _data
1645     ) internal virtual {
1646         _mint(to, quantity);
1647 
1648         unchecked {
1649             if (to.code.length != 0) {
1650                 uint256 end = _currentIndex;
1651                 uint256 index = end - quantity;
1652                 do {
1653                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1654                         revert TransferToNonERC721ReceiverImplementer();
1655                     }
1656                 } while (index < end);
1657                 // Reentrancy protection.
1658                 if (_currentIndex != end) revert();
1659             }
1660         }
1661     }
1662 
1663     /**
1664      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1665      */
1666     function _safeMint(address to, uint256 quantity) internal virtual {
1667         _safeMint(to, quantity, '');
1668     }
1669 
1670     // =============================================================
1671     //                        BURN OPERATIONS
1672     // =============================================================
1673 
1674     /**
1675      * @dev Equivalent to `_burn(tokenId, false)`.
1676      */
1677     function _burn(uint256 tokenId) internal virtual {
1678         _burn(tokenId, false);
1679     }
1680 
1681     /**
1682      * @dev Destroys `tokenId`.
1683      * The approval is cleared when the token is burned.
1684      *
1685      * Requirements:
1686      *
1687      * - `tokenId` must exist.
1688      *
1689      * Emits a {Transfer} event.
1690      */
1691     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1692         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1693 
1694         address from = address(uint160(prevOwnershipPacked));
1695 
1696         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1697 
1698         if (approvalCheck) {
1699             // The nested ifs save around 20+ gas over a compound boolean condition.
1700             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1701                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1702         }
1703 
1704         _beforeTokenTransfers(from, address(0), tokenId, 1);
1705 
1706         // Clear approvals from the previous owner.
1707         assembly {
1708             if approvedAddress {
1709                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1710                 sstore(approvedAddressSlot, 0)
1711             }
1712         }
1713 
1714         // Underflow of the sender's balance is impossible because we check for
1715         // ownership above and the recipient's balance can't realistically overflow.
1716         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1717         unchecked {
1718             // Updates:
1719             // - `balance -= 1`.
1720             // - `numberBurned += 1`.
1721             //
1722             // We can directly decrement the balance, and increment the number burned.
1723             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1724             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1725 
1726             // Updates:
1727             // - `address` to the last owner.
1728             // - `startTimestamp` to the timestamp of burning.
1729             // - `burned` to `true`.
1730             // - `nextInitialized` to `true`.
1731             _packedOwnerships[tokenId] = _packOwnershipData(
1732                 from,
1733                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1734             );
1735 
1736             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1737             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1738                 uint256 nextTokenId = tokenId + 1;
1739                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1740                 if (_packedOwnerships[nextTokenId] == 0) {
1741                     // If the next slot is within bounds.
1742                     if (nextTokenId != _currentIndex) {
1743                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1744                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1745                     }
1746                 }
1747             }
1748         }
1749 
1750         emit Transfer(from, address(0), tokenId);
1751         _afterTokenTransfers(from, address(0), tokenId, 1);
1752 
1753         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1754         unchecked {
1755             _burnCounter++;
1756         }
1757     }
1758 
1759     // =============================================================
1760     //                     EXTRA DATA OPERATIONS
1761     // =============================================================
1762 
1763     /**
1764      * @dev Directly sets the extra data for the ownership data `index`.
1765      */
1766     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1767         uint256 packed = _packedOwnerships[index];
1768         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1769         uint256 extraDataCasted;
1770         // Cast `extraData` with assembly to avoid redundant masking.
1771         assembly {
1772             extraDataCasted := extraData
1773         }
1774         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1775         _packedOwnerships[index] = packed;
1776     }
1777 
1778     /**
1779      * @dev Called during each token transfer to set the 24bit `extraData` field.
1780      * Intended to be overridden by the cosumer contract.
1781      *
1782      * `previousExtraData` - the value of `extraData` before transfer.
1783      *
1784      * Calling conditions:
1785      *
1786      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1787      * transferred to `to`.
1788      * - When `from` is zero, `tokenId` will be minted for `to`.
1789      * - When `to` is zero, `tokenId` will be burned by `from`.
1790      * - `from` and `to` are never both zero.
1791      */
1792     function _extraData(
1793         address from,
1794         address to,
1795         uint24 previousExtraData
1796     ) internal view virtual returns (uint24) {}
1797 
1798     /**
1799      * @dev Returns the next extra data for the packed ownership data.
1800      * The returned result is shifted into position.
1801      */
1802     function _nextExtraData(
1803         address from,
1804         address to,
1805         uint256 prevOwnershipPacked
1806     ) private view returns (uint256) {
1807         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1808         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1809     }
1810 
1811     // =============================================================
1812     //                       OTHER OPERATIONS
1813     // =============================================================
1814 
1815     /**
1816      * @dev Returns the message sender (defaults to `msg.sender`).
1817      *
1818      * If you are writing GSN compatible contracts, you need to override this function.
1819      */
1820     function _msgSenderERC721A() internal view virtual returns (address) {
1821         return msg.sender;
1822     }
1823 
1824     /**
1825      * @dev Converts a uint256 to its ASCII string decimal representation.
1826      */
1827     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1828         assembly {
1829             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1830             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1831             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1832             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1833             let m := add(mload(0x40), 0xa0)
1834             // Update the free memory pointer to allocate.
1835             mstore(0x40, m)
1836             // Assign the `str` to the end.
1837             str := sub(m, 0x20)
1838             // Zeroize the slot after the string.
1839             mstore(str, 0)
1840 
1841             // Cache the end of the memory to calculate the length later.
1842             let end := str
1843 
1844             // We write the string from rightmost digit to leftmost digit.
1845             // The following is essentially a do-while loop that also handles the zero case.
1846             // prettier-ignore
1847             for { let temp := value } 1 {} {
1848                 str := sub(str, 1)
1849                 // Write the character to the pointer.
1850                 // The ASCII index of the '0' character is 48.
1851                 mstore8(str, add(48, mod(temp, 10)))
1852                 // Keep dividing `temp` until zero.
1853                 temp := div(temp, 10)
1854                 // prettier-ignore
1855                 if iszero(temp) { break }
1856             }
1857 
1858             let length := sub(end, str)
1859             // Move the pointer 32 bytes leftwards to make room for the length.
1860             str := sub(str, 0x20)
1861             // Store the length.
1862             mstore(str, length)
1863         }
1864     }
1865 }
1866 
1867 // File: erc721a/contracts/extensions/IERC721AQueryable.sol
1868 
1869 
1870 // ERC721A Contracts v4.2.3
1871 // Creator: Chiru Labs
1872 
1873 pragma solidity ^0.8.4;
1874 
1875 
1876 /**
1877  * @dev Interface of ERC721AQueryable.
1878  */
1879 interface IERC721AQueryable is IERC721A {
1880     /**
1881      * Invalid query range (`start` >= `stop`).
1882      */
1883     error InvalidQueryRange();
1884 
1885     /**
1886      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1887      *
1888      * If the `tokenId` is out of bounds:
1889      *
1890      * - `addr = address(0)`
1891      * - `startTimestamp = 0`
1892      * - `burned = false`
1893      * - `extraData = 0`
1894      *
1895      * If the `tokenId` is burned:
1896      *
1897      * - `addr = <Address of owner before token was burned>`
1898      * - `startTimestamp = <Timestamp when token was burned>`
1899      * - `burned = true`
1900      * - `extraData = <Extra data when token was burned>`
1901      *
1902      * Otherwise:
1903      *
1904      * - `addr = <Address of owner>`
1905      * - `startTimestamp = <Timestamp of start of ownership>`
1906      * - `burned = false`
1907      * - `extraData = <Extra data at start of ownership>`
1908      */
1909     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
1910 
1911     /**
1912      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1913      * See {ERC721AQueryable-explicitOwnershipOf}
1914      */
1915     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
1916 
1917     /**
1918      * @dev Returns an array of token IDs owned by `owner`,
1919      * in the range [`start`, `stop`)
1920      * (i.e. `start <= tokenId < stop`).
1921      *
1922      * This function allows for tokens to be queried if the collection
1923      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1924      *
1925      * Requirements:
1926      *
1927      * - `start < stop`
1928      */
1929     function tokensOfOwnerIn(
1930         address owner,
1931         uint256 start,
1932         uint256 stop
1933     ) external view returns (uint256[] memory);
1934 
1935     /**
1936      * @dev Returns an array of token IDs owned by `owner`.
1937      *
1938      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
1939      * It is meant to be called off-chain.
1940      *
1941      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1942      * multiple smaller scans if the collection is large enough to cause
1943      * an out-of-gas error (10K collections should be fine).
1944      */
1945     function tokensOfOwner(address owner) external view returns (uint256[] memory);
1946 }
1947 
1948 // File: erc721a/contracts/extensions/ERC721AQueryable.sol
1949 
1950 
1951 // ERC721A Contracts v4.2.3
1952 // Creator: Chiru Labs
1953 
1954 pragma solidity ^0.8.4;
1955 
1956 
1957 
1958 /**
1959  * @title ERC721AQueryable.
1960  *
1961  * @dev ERC721A subclass with convenience query functions.
1962  */
1963 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1964     /**
1965      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1966      *
1967      * If the `tokenId` is out of bounds:
1968      *
1969      * - `addr = address(0)`
1970      * - `startTimestamp = 0`
1971      * - `burned = false`
1972      * - `extraData = 0`
1973      *
1974      * If the `tokenId` is burned:
1975      *
1976      * - `addr = <Address of owner before token was burned>`
1977      * - `startTimestamp = <Timestamp when token was burned>`
1978      * - `burned = true`
1979      * - `extraData = <Extra data when token was burned>`
1980      *
1981      * Otherwise:
1982      *
1983      * - `addr = <Address of owner>`
1984      * - `startTimestamp = <Timestamp of start of ownership>`
1985      * - `burned = false`
1986      * - `extraData = <Extra data at start of ownership>`
1987      */
1988     function explicitOwnershipOf(uint256 tokenId) public view virtual override returns (TokenOwnership memory) {
1989         TokenOwnership memory ownership;
1990         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1991             return ownership;
1992         }
1993         ownership = _ownershipAt(tokenId);
1994         if (ownership.burned) {
1995             return ownership;
1996         }
1997         return _ownershipOf(tokenId);
1998     }
1999 
2000     /**
2001      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
2002      * See {ERC721AQueryable-explicitOwnershipOf}
2003      */
2004     function explicitOwnershipsOf(uint256[] calldata tokenIds)
2005         external
2006         view
2007         virtual
2008         override
2009         returns (TokenOwnership[] memory)
2010     {
2011         unchecked {
2012             uint256 tokenIdsLength = tokenIds.length;
2013             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
2014             for (uint256 i; i != tokenIdsLength; ++i) {
2015                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
2016             }
2017             return ownerships;
2018         }
2019     }
2020 
2021     /**
2022      * @dev Returns an array of token IDs owned by `owner`,
2023      * in the range [`start`, `stop`)
2024      * (i.e. `start <= tokenId < stop`).
2025      *
2026      * This function allows for tokens to be queried if the collection
2027      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
2028      *
2029      * Requirements:
2030      *
2031      * - `start < stop`
2032      */
2033     function tokensOfOwnerIn(
2034         address owner,
2035         uint256 start,
2036         uint256 stop
2037     ) external view virtual override returns (uint256[] memory) {
2038         unchecked {
2039             if (start >= stop) revert InvalidQueryRange();
2040             uint256 tokenIdsIdx;
2041             uint256 stopLimit = _nextTokenId();
2042             // Set `start = max(start, _startTokenId())`.
2043             if (start < _startTokenId()) {
2044                 start = _startTokenId();
2045             }
2046             // Set `stop = min(stop, stopLimit)`.
2047             if (stop > stopLimit) {
2048                 stop = stopLimit;
2049             }
2050             uint256 tokenIdsMaxLength = balanceOf(owner);
2051             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
2052             // to cater for cases where `balanceOf(owner)` is too big.
2053             if (start < stop) {
2054                 uint256 rangeLength = stop - start;
2055                 if (rangeLength < tokenIdsMaxLength) {
2056                     tokenIdsMaxLength = rangeLength;
2057                 }
2058             } else {
2059                 tokenIdsMaxLength = 0;
2060             }
2061             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
2062             if (tokenIdsMaxLength == 0) {
2063                 return tokenIds;
2064             }
2065             // We need to call `explicitOwnershipOf(start)`,
2066             // because the slot at `start` may not be initialized.
2067             TokenOwnership memory ownership = explicitOwnershipOf(start);
2068             address currOwnershipAddr;
2069             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
2070             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
2071             if (!ownership.burned) {
2072                 currOwnershipAddr = ownership.addr;
2073             }
2074             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
2075                 ownership = _ownershipAt(i);
2076                 if (ownership.burned) {
2077                     continue;
2078                 }
2079                 if (ownership.addr != address(0)) {
2080                     currOwnershipAddr = ownership.addr;
2081                 }
2082                 if (currOwnershipAddr == owner) {
2083                     tokenIds[tokenIdsIdx++] = i;
2084                 }
2085             }
2086             // Downsize the array to fit.
2087             assembly {
2088                 mstore(tokenIds, tokenIdsIdx)
2089             }
2090             return tokenIds;
2091         }
2092     }
2093 
2094     /**
2095      * @dev Returns an array of token IDs owned by `owner`.
2096      *
2097      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
2098      * It is meant to be called off-chain.
2099      *
2100      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
2101      * multiple smaller scans if the collection is large enough to cause
2102      * an out-of-gas error (10K collections should be fine).
2103      */
2104     function tokensOfOwner(address owner) external view virtual override returns (uint256[] memory) {
2105         unchecked {
2106             uint256 tokenIdsIdx;
2107             address currOwnershipAddr;
2108             uint256 tokenIdsLength = balanceOf(owner);
2109             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
2110             TokenOwnership memory ownership;
2111             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
2112                 ownership = _ownershipAt(i);
2113                 if (ownership.burned) {
2114                     continue;
2115                 }
2116                 if (ownership.addr != address(0)) {
2117                     currOwnershipAddr = ownership.addr;
2118                 }
2119                 if (currOwnershipAddr == owner) {
2120                     tokenIds[tokenIdsIdx++] = i;
2121                 }
2122             }
2123             return tokenIds;
2124         }
2125     }
2126 }
2127 
2128 // File: contracts/badbunny.sol
2129 
2130 
2131 pragma solidity ^0.8.13;
2132 
2133 
2134 
2135 
2136 
2137 
2138 contract BadBunny is ERC721AQueryable, DefaultOperatorFilterer, Ownable, Pausable {
2139     uint256 public MAX_MINTS = 500;
2140     uint256 public MAX_SUPPLY = 10000;
2141     uint256 public price = 0.00222 ether;
2142     
2143     string public baseURI;
2144 
2145     bool claimActive = false;
2146 
2147     uint256 public mintCounter = 0;
2148     uint256 public wlMintCounter = 0;
2149     uint256 public airDropCounter = 0;
2150     uint256 public claimCounter = 0;
2151 
2152     mapping(uint256 => bool) public BADtracker;
2153     mapping(uint256 => bool) public BTFDtracker;
2154 
2155     IERC721 public BADDIES;
2156     IERC721 public BTFD;
2157 
2158     string public extension = ".json";
2159     
2160     constructor(address _BADDIES, address _BTFD) ERC721A("Bad Bunny", "BBUN") {
2161         BADDIES = IERC721(_BADDIES);
2162         BTFD = IERC721(_BTFD);
2163         toggleAllMintPause();
2164     }
2165 
2166     function mint(uint256 quantity) external payable whenNotPaused {
2167         require(quantity + _numberMinted(msg.sender) <= MAX_MINTS, "mint: Exceeded the limit per wallet");
2168         require(totalSupply() + quantity <= MAX_SUPPLY, "mint: Not enough tokens left");
2169         require(msg.value >= (price * quantity), "mint: Not enough ether sent");
2170 
2171         mintCounter += quantity;
2172         _safeMint(msg.sender, quantity);
2173     }
2174 
2175     function airDrop(address[] calldata addrs, uint256 quantity) external onlyOwner {
2176         uint256 len = addrs.length;
2177         require(totalSupply() + (quantity * len) <= MAX_SUPPLY, "airDrop: Not enough tokens to airdrop");
2178         airDropCounter += quantity * len;
2179         for (uint256 i = 0; i < len; i++) {
2180             _safeMint(addrs[i], quantity);
2181         }
2182     }
2183 
2184     /*
2185         Front end must get IDs of wallet and send a matching length arrays.
2186         This will ensure a 1:1 free mint.
2187         'BADtracker(id)' and 'BTFDtracker(id)' to verify if a token has been used in a claim
2188     */
2189     function partnerClaim(uint256[] calldata BADids, uint256[] calldata BTFDids) external whenNotPaused {
2190         require(claimActive == true, "partnerClaim: is not active");
2191         require(BADids.length == BTFDids.length, "partnerClaim: Id array lengths to not match");
2192         uint256 len = BADids.length;
2193         for (uint256 i = 0; i < len; i++) {
2194             //Check BAD ids
2195             require(BADDIES.ownerOf(BADids[i]) == msg.sender, "partnerClaim: sender is not owner of ID");
2196             require(BADtracker[BADids[i]] == false, "partnerClaim: BAD ID has already been used in a claim");
2197             BADtracker[BADids[i]] = true;
2198 
2199             //Check BTFD Ids
2200             require(BTFD.ownerOf(BTFDids[i]) == msg.sender, "partnerClaim: sender is not owner of ID");
2201             require(BTFDtracker[BTFDids[i]] == false, "partnerClaim: BTFD ID has already been used in a claim");
2202             BTFDtracker[BTFDids[i]] = true;
2203         }
2204 
2205         claimCounter += len;
2206         _safeMint(msg.sender, len);
2207     }
2208 
2209 
2210     /* 
2211         These functions will return true an array of used ids
2212     */
2213     function checkBTFDids(uint256[] calldata _ids) external view returns(uint256[] memory usedIDs) {
2214         usedIDs = new uint256[](_ids.length);
2215         uint256 x = 0;
2216         
2217         for (uint256 i = 0; i < _ids.length; i++) {
2218             if (BTFDtracker[_ids[i]]) {
2219                 usedIDs[x] = _ids[i];
2220                 x++;
2221             }
2222         }
2223         return usedIDs;
2224     }
2225 
2226     function checkBADids(uint256[] calldata _ids) external view returns(uint256[] memory usedIDs) {
2227         usedIDs = new uint256[](_ids.length);
2228         uint256 x = 0;
2229 
2230         for (uint256 i = 0; i < _ids.length; i++) {
2231             if (BADtracker[_ids[i]]) {
2232                 usedIDs[x] = _ids[i];
2233                 x++;
2234             }
2235         }
2236         return usedIDs;
2237     }
2238 
2239     function _baseURI() internal view override returns (string memory) {
2240         return baseURI;
2241     }
2242 
2243     function _startTokenId() internal pure override returns (uint256) {
2244         return 1;
2245     }
2246     
2247     function tokenURI(uint256 tokenId) 
2248         public 
2249         view 
2250         override(ERC721A, IERC721A) 
2251         returns (string memory) 
2252     {
2253         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
2254         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId), extension)) : '';
2255     }
2256 
2257     function transferFrom(address from, address to, uint256 tokenId)
2258         public
2259         payable
2260         override(ERC721A, IERC721A)
2261         onlyAllowedOperator(from)
2262     {
2263         super.transferFrom(from, to, tokenId);
2264     }
2265 
2266     function safeTransferFrom(address from, address to, uint256 tokenId)
2267         public
2268         payable
2269         override(ERC721A, IERC721A)
2270         onlyAllowedOperator(from)
2271     {
2272         super.safeTransferFrom(from, to, tokenId);
2273     }
2274 
2275     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
2276         public
2277         payable
2278         override(ERC721A, IERC721A)
2279         onlyAllowedOperator(from)
2280     {
2281         super.safeTransferFrom(from, to, tokenId, data);
2282     }
2283 
2284     //ADMIN
2285 
2286     function setPrice(uint256 _price) external onlyOwner {
2287         price = _price;
2288     }
2289 
2290     function setMaxMint(uint256 _max) external onlyOwner {
2291         MAX_MINTS = _max;
2292     }
2293 
2294     function toogleClaimActive(bool state) external onlyOwner {
2295         claimActive = state;
2296     }
2297 
2298     function toggleAllMintPause() public onlyOwner {
2299         paused() ? _unpause() : _pause();
2300     }
2301 
2302     function setBaseURI(string memory _uri) external onlyOwner {
2303         baseURI = _uri;
2304     }
2305 
2306     function updateMaxSupply(uint256 _max) external onlyOwner {
2307         MAX_SUPPLY = _max;
2308     }
2309 
2310     function withdraw() external onlyOwner {
2311         require(address(this).balance > 0, "withdraw: contract balance must be greater than 0"); 
2312         uint256 balance = address(this).balance;
2313         payable(msg.sender).transfer(balance);
2314     }
2315 
2316 }