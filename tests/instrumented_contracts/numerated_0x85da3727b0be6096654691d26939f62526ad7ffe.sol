1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.15;
4 
5 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
6 
7 /**
8  * @dev Contract module that helps prevent reentrant calls to a function.
9  *
10  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
11  * available, which can be applied to functions to make sure there are no nested
12  * (reentrant) calls to them.
13  *
14  * Note that because there is a single `nonReentrant` guard, functions marked as
15  * `nonReentrant` may not call one another. This can be worked around by making
16  * those functions `private`, and then adding `external` `nonReentrant` entry
17  * points to them.
18  *
19  * TIP: If you would like to learn more about reentrancy and alternative ways
20  * to protect against it, check out our blog post
21  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
22  */
23 abstract contract ReentrancyGuard {
24     // Booleans are more expensive than uint256 or any type that takes up a full
25     // word because each write operation emits an extra SLOAD to first read the
26     // slot's contents, replace the bits taken up by the boolean, and then write
27     // back. This is the compiler's defense against contract upgrades and
28     // pointer aliasing, and it cannot be disabled.
29 
30     // The values being non-zero value makes deployment a bit more expensive,
31     // but in exchange the refund on every call to nonReentrant will be lower in
32     // amount. Since refunds are capped to a percentage of the total
33     // transaction's gas, it is best to keep them low in cases like this one, to
34     // increase the likelihood of the full refund coming into effect.
35     uint256 private constant _NOT_ENTERED = 1;
36     uint256 private constant _ENTERED = 2;
37 
38     uint256 private _status;
39 
40     constructor() {
41         _status = _NOT_ENTERED;
42     }
43 
44     /**
45      * @dev Prevents a contract from calling itself, directly or indirectly.
46      * Calling a `nonReentrant` function from another `nonReentrant`
47      * function is not supported. It is possible to prevent this from happening
48      * by making the `nonReentrant` function external, and making it call a
49      * `private` function that does the actual work.
50      */
51     modifier nonReentrant() {
52         _nonReentrantBefore();
53         _;
54         _nonReentrantAfter();
55     }
56 
57     function _nonReentrantBefore() private {
58         // On the first call to nonReentrant, _status will be _NOT_ENTERED
59         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
60 
61         // Any calls to nonReentrant after this point will fail
62         _status = _ENTERED;
63     }
64 
65     function _nonReentrantAfter() private {
66         // By storing the original value once again, a refund is triggered (see
67         // https://eips.ethereum.org/EIPS/eip-2200)
68         _status = _NOT_ENTERED;
69     }
70 
71     /**
72      * @dev Returns true if the reentrancy guard is currently set to "entered", which indicates there is a
73      * `nonReentrant` function in the call stack.
74      */
75     function _reentrancyGuardEntered() internal view returns (bool) {
76         return _status == _ENTERED;
77     }
78 }
79 
80 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
81 
82 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
83 
84 /**
85  * @dev Provides information about the current execution context, including the
86  * sender of the transaction and its data. While these are generally available
87  * via msg.sender and msg.data, they should not be accessed in such a direct
88  * manner, since when dealing with meta-transactions the account sending and
89  * paying for execution may not be the actual sender (as far as an application
90  * is concerned).
91  *
92  * This contract is only required for intermediate, library-like contracts.
93  */
94 abstract contract Context {
95     function _msgSender() internal view virtual returns (address) {
96         return msg.sender;
97     }
98 
99     function _msgData() internal view virtual returns (bytes calldata) {
100         return msg.data;
101     }
102 }
103 
104 /**
105  * @dev Contract module which provides a basic access control mechanism, where
106  * there is an account (an owner) that can be granted exclusive access to
107  * specific functions.
108  *
109  * By default, the owner account will be the one that deploys the contract. This
110  * can later be changed with {transferOwnership}.
111  *
112  * This module is used through inheritance. It will make available the modifier
113  * `onlyOwner`, which can be applied to your functions to restrict their use to
114  * the owner.
115  */
116 abstract contract Ownable is Context {
117     address private _owner;
118 
119     event OwnershipTransferred(
120         address indexed previousOwner,
121         address indexed newOwner
122     );
123 
124     /**
125      * @dev Initializes the contract setting the deployer as the initial owner.
126      */
127     constructor() {
128         _transferOwnership(_msgSender());
129     }
130 
131     /**
132      * @dev Throws if called by any account other than the owner.
133      */
134     modifier onlyOwner() {
135         _checkOwner();
136         _;
137     }
138 
139     /**
140      * @dev Returns the address of the current owner.
141      */
142     function owner() public view virtual returns (address) {
143         return _owner;
144     }
145 
146     /**
147      * @dev Throws if the sender is not the owner.
148      */
149     function _checkOwner() internal view virtual {
150         require(owner() == _msgSender(), "Ownable: caller is not the owner");
151     }
152 
153     /**
154      * @dev Leaves the contract without owner. It will not be possible to call
155      * `onlyOwner` functions anymore. Can only be called by the current owner.
156      *
157      * NOTE: Renouncing ownership will leave the contract without an owner,
158      * thereby removing any functionality that is only available to the owner.
159      */
160     function renounceOwnership() public virtual onlyOwner {
161         _transferOwnership(address(0));
162     }
163 
164     /**
165      * @dev Transfers ownership of the contract to a new account (`newOwner`).
166      * Can only be called by the current owner.
167      */
168     function transferOwnership(address newOwner) public virtual onlyOwner {
169         require(
170             newOwner != address(0),
171             "Ownable: new owner is the zero address"
172         );
173         _transferOwnership(newOwner);
174     }
175 
176     /**
177      * @dev Transfers ownership of the contract to a new account (`newOwner`).
178      * Internal function without access restriction.
179      */
180     function _transferOwnership(address newOwner) internal virtual {
181         address oldOwner = _owner;
182         _owner = newOwner;
183         emit OwnershipTransferred(oldOwner, newOwner);
184     }
185 }
186 
187 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
188 
189 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
190 
191 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
192 
193 /**
194  * @dev Interface of the ERC165 standard, as defined in the
195  * https://eips.ethereum.org/EIPS/eip-165[EIP].
196  *
197  * Implementers can declare support of contract interfaces, which can then be
198  * queried by others ({ERC165Checker}).
199  *
200  * For an implementation, see {ERC165}.
201  */
202 interface IERC165Upgradeable {
203     /**
204      * @dev Returns true if this contract implements the interface defined by
205      * `interfaceId`. See the corresponding
206      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
207      * to learn more about how these ids are created.
208      *
209      * This function call must use less than 30 000 gas.
210      */
211     function supportsInterface(bytes4 interfaceId) external view returns (bool);
212 }
213 
214 /**
215  * @dev Required interface of an ERC721 compliant contract.
216  */
217 interface IERC721Upgradeable is IERC165Upgradeable {
218     /**
219      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
220      */
221     event Transfer(
222         address indexed from,
223         address indexed to,
224         uint256 indexed tokenId
225     );
226 
227     /**
228      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
229      */
230     event Approval(
231         address indexed owner,
232         address indexed approved,
233         uint256 indexed tokenId
234     );
235 
236     /**
237      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
238      */
239     event ApprovalForAll(
240         address indexed owner,
241         address indexed operator,
242         bool approved
243     );
244 
245     /**
246      * @dev Returns the number of tokens in ``owner``'s account.
247      */
248     function balanceOf(address owner) external view returns (uint256 balance);
249 
250     /**
251      * @dev Returns the owner of the `tokenId` token.
252      *
253      * Requirements:
254      *
255      * - `tokenId` must exist.
256      */
257     function ownerOf(uint256 tokenId) external view returns (address owner);
258 
259     /**
260      * @dev Safely transfers `tokenId` token from `from` to `to`.
261      *
262      * Requirements:
263      *
264      * - `from` cannot be the zero address.
265      * - `to` cannot be the zero address.
266      * - `tokenId` token must exist and be owned by `from`.
267      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
268      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
269      *
270      * Emits a {Transfer} event.
271      */
272     function safeTransferFrom(
273         address from,
274         address to,
275         uint256 tokenId,
276         bytes calldata data
277     ) external;
278 
279     /**
280      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
281      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
282      *
283      * Requirements:
284      *
285      * - `from` cannot be the zero address.
286      * - `to` cannot be the zero address.
287      * - `tokenId` token must exist and be owned by `from`.
288      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
289      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
290      *
291      * Emits a {Transfer} event.
292      */
293     function safeTransferFrom(
294         address from,
295         address to,
296         uint256 tokenId
297     ) external;
298 
299     /**
300      * @dev Transfers `tokenId` token from `from` to `to`.
301      *
302      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
303      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
304      * understand this adds an external call which potentially creates a reentrancy vulnerability.
305      *
306      * Requirements:
307      *
308      * - `from` cannot be the zero address.
309      * - `to` cannot be the zero address.
310      * - `tokenId` token must be owned by `from`.
311      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
312      *
313      * Emits a {Transfer} event.
314      */
315     function transferFrom(
316         address from,
317         address to,
318         uint256 tokenId
319     ) external;
320 
321     /**
322      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
323      * The approval is cleared when the token is transferred.
324      *
325      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
326      *
327      * Requirements:
328      *
329      * - The caller must own the token or be an approved operator.
330      * - `tokenId` must exist.
331      *
332      * Emits an {Approval} event.
333      */
334     function approve(address to, uint256 tokenId) external;
335 
336     /**
337      * @dev Approve or remove `operator` as an operator for the caller.
338      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
339      *
340      * Requirements:
341      *
342      * - The `operator` cannot be the caller.
343      *
344      * Emits an {ApprovalForAll} event.
345      */
346     function setApprovalForAll(address operator, bool _approved) external;
347 
348     /**
349      * @dev Returns the account approved for `tokenId` token.
350      *
351      * Requirements:
352      *
353      * - `tokenId` must exist.
354      */
355     function getApproved(uint256 tokenId)
356         external
357         view
358         returns (address operator);
359 
360     /**
361      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
362      *
363      * See {setApprovalForAll}
364      */
365     function isApprovedForAll(address owner, address operator)
366         external
367         view
368         returns (bool);
369 }
370 
371 /**
372  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
373  * @dev See https://eips.ethereum.org/EIPS/eip-721
374  */
375 interface IERC721MetadataUpgradeable is IERC721Upgradeable {
376     /**
377      * @dev Returns the token collection name.
378      */
379     function name() external view returns (string memory);
380 
381     /**
382      * @dev Returns the token collection symbol.
383      */
384     function symbol() external view returns (string memory);
385 
386     /**
387      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
388      */
389     function tokenURI(uint256 tokenId) external view returns (string memory);
390 }
391 
392 interface ITokenRecoverable {
393     // Events for token recovery (ERC20) and (ERC721)
394     event TokenRecoveredERC20(
395         address indexed recipient,
396         address indexed erc20,
397         uint256 amount
398     );
399     event TokenRecoveredERC721(
400         address indexed recipient,
401         address indexed erc721,
402         uint256 tokenId
403     );
404 
405     /**
406      * Allows the owner of an ERC20Club or ERC721Collective to return
407      * any ERC20 tokens erroneously sent to the contract.
408      *
409      * Emits a `TokenRecoveredERC20` event.
410      *
411      * Requirements:
412      * - The caller must be the (Club or Collective) token contract owner.
413      * @param recipient Address that erroneously sent the ERC20 token(s)
414      * @param erc20 Erroneously-sent ERC20 token to recover
415      * @param amount Amount to recover
416      */
417     function recoverERC20(
418         address recipient,
419         address erc20,
420         uint256 amount
421     ) external;
422 
423     /**
424      * Allows the owner of an ERC20Club or ERC721Collective to return
425      * any ERC721 tokens erroneously sent to the contract.
426      *
427      * Emits a `TokenRecoveredERC721` event.
428      *
429      * Requirements:
430      * - The caller must be the (Club or Collective) token contract owner.
431      * @param recipient Address that erroneously sent the ERC721 token
432      * @param erc721 Erroneously-sent ERC721 token to recover
433      * @param tokenId The tokenId to recover
434      */
435     function recoverERC721(
436         address recipient,
437         address erc721,
438         uint256 tokenId
439     ) external;
440 }
441 
442 /**
443  * Interface for a Guard that governs whether a token can be minted, burned, or
444  * transferred by a particular operator, from a particular sender (`from` is
445  * address 0 iff the token is being minted), to a particular recipient (`to` is
446  * address 0 iff the token is being burned).
447  */
448 interface IGuard {
449     /**
450      * @return True iff the transaction is allowed
451      * @param operator Transaction msg.sender
452      * @param from Token sender
453      * @param to Token recipient
454      * @param value Amount (ERC20) or token ID (ERC721)
455      */
456     function isAllowed(
457         address operator,
458         address from,
459         address to,
460         uint256 value // amount (ERC20) or tokenId (ERC721)
461     ) external view returns (bool);
462 }
463 
464 interface ITokenEnforceable is ITokenRecoverable {
465     event ControlDisabled(address indexed controller);
466     event BatcherUpdated(address batcher);
467     event GuardUpdated(GuardType indexed guard, address indexed implementation);
468     event GuardLocked(
469         bool mintGuardLocked,
470         bool burnGuardLocked,
471         bool transferGuardLocked
472     );
473 
474     /**
475      * @return The address of the transaction batcher used to batch calls over
476      * onlyOwner functions.
477      */
478     function batcher() external view returns (address);
479 
480     /**
481      * @return True iff the token contract owner is allowed to mint, burn, or
482      * transfer on behalf of arbitrary addresses.
483      */
484     function isControllable() external view returns (bool);
485 
486     /**
487      * @return The address of the Guard used to determine whether a mint is
488      * allowed. The contract at this address is assumed to implement the IGuard
489      * interface.
490      */
491     function mintGuard() external view returns (IGuard);
492 
493     /**
494      * @return The address of the Guard used to determine whether a burn is
495      * allowed. The contract at this address is assumed to implement the IGuard
496      * interface.
497      */
498     function burnGuard() external view returns (IGuard);
499 
500     /**
501      * @return The address of the Guard used to determine whether a transfer is
502      * allowed. The contract at this address is assumed to implement the IGuard
503      * interface.
504      */
505     function transferGuard() external view returns (IGuard);
506 
507     /**
508      * @return True iff the mint Guard cannot be changed.
509      */
510     function mintGuardLocked() external view returns (bool);
511 
512     /**
513      * @return True iff the burn Guard cannot be changed.
514      */
515     function burnGuardLocked() external view returns (bool);
516 
517     /**
518      * @return True iff the transfer Guard cannot be changed.
519      */
520     function transferGuardLocked() external view returns (bool);
521 
522     /**
523      * Irreversibly disables the token contract owner from minting, burning,
524      * and transferring on behalf of arbitrary addresses.
525      *
526      * Emits a `ControlDisabled` event.
527      *
528      * Requirements:
529      * - The caller must be the token contract owner or the batcher.
530      */
531     function disableControl() external;
532 
533     /**
534      * Irreversibly prevents the token contract owner from changing the mint,
535      * burn, and/or transfer Guards.
536      *
537      * If at least one guard was requested to be locked, emits a `GuardLocked`
538      * event confirming whether each Guard is locked.
539      *
540      * Requirements:
541      * - The caller must be the token contract owner or the batcher.
542      * @param mintGuardLock If true, the mint Guard will be locked. If false,
543      * does nothing to the mint Guard.
544      * @param burnGuardLock If true, the mint Guard will be locked. If false,
545      * does nothing to the burn Guard.
546      * @param transferGuardLock If true, the mint Guard will be locked. If
547      * false, does nothing to the transfer Guard.
548      */
549     function lockGuards(
550         bool mintGuardLock,
551         bool burnGuardLock,
552         bool transferGuardLock
553     ) external;
554 
555     /**
556      * Update the address of the batcher for batching calls over
557      * onlyOwner functions.
558      *
559      * Emits a `BatcherUpdated` event.
560      *
561      * Requirements:
562      * - The caller must be the token contract owner or the batcher.
563      * @param implementation Address of new batcher
564      */
565     function updateBatcher(address implementation) external;
566 
567     /**
568      * Update the address of the Guard for minting. The contract at the
569      * passed-in address is assumed to implement the IGuard interface.
570      *
571      * Emits a `GuardUpdated` event with `GuardType.Mint`.
572      *
573      * Requirements:
574      * - The caller must be the token contract owner or the batcher.
575      * - The mint Guard must not be locked.
576      * @param implementation Address of new mint Guard
577      */
578     function updateMintGuard(address implementation) external;
579 
580     /**
581      * Update the address of the Guard for burning. The contract at the
582      * passed-in address is assumed to implement the IGuard interface.
583      *
584      * Emits a `GuardUpdated` event with `GuardType.Burn`.
585      *
586      * Requirements:
587      * - The caller must be the token contract owner or the batcher.
588      * - The burn Guard must not be locked.
589      * @param implementation Address of new burn Guard
590      */
591     function updateBurnGuard(address implementation) external;
592 
593     /**
594      * Update the address of the Guard for transferring. The contract at the
595      * passed-in address is assumed to implement the IGuard interface.
596      *
597      * Emits a `GuardUpdated` event with `GuardType.Transfer`.
598      *
599      * Requirements:
600      * - The caller must be the token contract owner or the batcher.
601      * - The transfer Guard must not be locked.
602      * @param implementation Address of transfer Guard
603      */
604     function updateTransferGuard(address implementation) external;
605 
606     /**
607      * @return True iff a token can be minted, burned, or transferred by a
608      * particular operator, from a particular sender (`from` is address 0 iff
609      * the token is being minted), to a particular recipient (`to` is address 0
610      * iff the token is being burned).
611      * @param operator Transaction msg.sender
612      * @param from Token sender
613      * @param to Token recipient
614      * @param value Amount (ERC20) or token ID (ERC721)
615      */
616     function isAllowed(
617         address operator,
618         address from,
619         address to,
620         uint256 value // amount (ERC20) or tokenId (ERC721)
621     ) external view returns (bool);
622 
623     /**
624      * @return owner The address of the token contract owner
625      */
626     function owner() external view returns (address);
627 
628     /**
629      * Transfers ownership of the contract to a new account (`newOwner`)
630      *
631      * Emits an `OwnershipTransferred` event.
632      *
633      * Requirements:
634      * - The caller must be the current owner.
635      * @param newOwner Address that will become the owner
636      */
637     function transferOwnership(address newOwner) external;
638 
639     /**
640      * Leaves the contract without an owner. After calling this function, it
641      * will no longer be possible to call `onlyOwner` functions.
642      *
643      * Requirements:
644      * - The caller must be the current owner.
645      */
646     function renounceOwnership() external;
647 }
648 
649 enum GuardType {
650     Mint,
651     Burn,
652     Transfer
653 }
654 
655 /**
656  * @title IERC1644 Controller Token Operation (part of the ERC1400 Security
657  * Token Standards)
658  *
659  * See https://github.com/ethereum/EIPs/issues/1644. Data and operatorData
660  * parameters were removed.
661  */
662 interface IERC1644 {
663     event ControllerRedemption(
664         address account,
665         address indexed from,
666         uint256 value
667     );
668 
669     event ControllerTransfer(
670         address controller,
671         address indexed from,
672         address indexed to,
673         uint256 value
674     );
675 
676     /**
677      * Burns `tokenId` without checking whether the caller owns or is approved
678      * to spend the token.
679      *
680      * Emits a `Transfer` event with `address(0)` as `to` AND a
681      * `ControllerRedemption` event.
682      *
683      * Requirements:
684      * - The caller must be the token contract owner or the batcher.
685      * - `isControllable` must be true.
686      * @param account The account whose token will be burned.
687      * @param value Amount (ERC20) or token ID (ERC721)
688      */
689     function controllerRedeem(
690         address account,
691         uint256 value // amount (ERC20) or tokenId (ERC721))
692     ) external;
693 
694     /**
695      * Transfers `tokenId` token from `from` to `to`, without checking whether
696      * the caller owns or is approved to spend the token.
697      *
698      * Emits a `Transfer` event with `address(0)` as `to` AND a
699      * `ControllerRedemption` event.
700      *
701      * Requirements:
702      * - The caller must be the token contract owner or the batcher.
703      * - `isControllable` must be true.
704      * @param from The account sending the token.
705      * @param to The account to receive the token.
706      * @param value Amount (ERC20) or token ID (ERC721)
707      */
708     function controllerTransfer(
709         address from,
710         address to,
711         uint256 value // amount (ERC20) or tokenId (ERC721)
712     ) external;
713 }
714 
715 /**
716  * Interface for functions defined in ERC721UpgradeableFork
717  */
718 interface IERC721UpgradeableFork is IERC721MetadataUpgradeable {
719     /**
720      * @return ID of the first token that will be minted.
721      */
722     function STARTING_TOKEN_ID() external view returns (uint256);
723 
724     /**
725      * Max consecutive tokenIds of bulk-minted tokens whose owner can be stored
726      * as address(0). This number is capped to reduce the cost of owner lookup.
727      */
728     function OWNER_ID_STAGGER() external view returns (uint256);
729 
730     /**
731      * @return ID of the next token that will be minted. Existing tokens are
732      * limited to IDs between `STARTING_TOKEN_ID` and `_nextTokenId` (including
733      * `STARTING_TOKEN_ID` and excluding `_nextTokenId`, though not all of these
734      * IDs may be in use if tokens have been burned).
735      */
736     function nextTokenId() external view returns (uint256);
737 
738     /**
739      * @return receiver Address that should receive royalties from sales.
740      * @return royaltyAmount How much royalty that should be sent to `receiver`,
741      * denominated in the same unit of exchange as `salePrice`.
742      * @param tokenId The token being sold.
743      * @param salePrice The sale price of the token, denominated in any unit of
744      * exchange. The royalty amount will be denominated and should be paid in
745      * that same unit of exchange.
746      */
747     function royaltyInfo(uint256 tokenId, uint256 salePrice)
748         external
749         view
750         returns (address receiver, uint256 royaltyAmount);
751 }
752 
753 /**
754  * Interface for only functions defined in ERC721Collective (excludes inherited
755  * and overridden functions)
756  */
757 interface IERC721CollectiveUnchained is IERC1644 {
758     event RendererUpdated(address indexed implementation);
759     event RendererLocked();
760 
761     /**
762      * Initializes `ERC721Collective`.
763      *
764      * Emits an `Initialized` event.
765      *
766      * @param name_ Name of token
767      * @param symbol_ Symbol of token
768      * @param mintGuard_ Address of mint guard
769      * @param burnGuard_ Address of burn guard
770      * @param transferGuard_ Address of transfer guard
771      * @param renderer_ Address of renderer
772      */
773     function __ERC721Collective_init(
774         string memory name_,
775         string memory symbol_,
776         address mintGuard_,
777         address burnGuard_,
778         address transferGuard_,
779         address renderer_
780     ) external;
781 
782     /**
783      * @return Number of currently-existing tokens (tokens that have been
784      * minted and that have not been burned).
785      */
786     function totalSupply() external view returns (uint256);
787 
788     // name(), symbol(), and tokenURI() overriding ERC721UpgradeableFork
789     // declared in IERC721Fork
790 
791     /**
792      * @return The address of the token Renderer. The contract at this address
793      * is assumed to implement the IRenderer interface.
794      */
795     function renderer() external view returns (address);
796 
797     /**
798      * @return True iff the Renderer cannot be changed.
799      */
800     function rendererLocked() external view returns (bool);
801 
802     /**
803      * Update the address of the token Renderer. The contract at the passed-in
804      * address is assumed to implement the IRenderer interface.
805      *
806      * Emits a `RendererUpdated` event.
807      *
808      * Requirements:
809      * - The caller must be the token contract owner or the batcher.
810      * - Renderer must not be locked.
811      * @param implementation Address of new Renderer
812      */
813     function updateRenderer(address implementation) external;
814 
815     /**
816      * Irreversibly prevents the token contract owner from changing the token
817      * Renderer.
818      *
819      * Emits a `RendererLocked` event.
820      *
821      * Requirements:
822      * - The caller must be the token contract owner or the batcher.
823      */
824     function lockRenderer() external;
825 
826     // supportsInterface(bytes4 interfaceId) overriding ERC1644 declared in
827     // IERC1644
828 
829     /**
830      * @return True after successfully executing mint and transfer of
831      * `nextTokenId` to `account`.
832      *
833      * Emits a `Transfer` event with `address(0)` as `from`.
834      *
835      * Requirements:
836      * - `account` cannot be the zero address.
837      * @param account The account to receive the minted token.
838      */
839     function mintTo(address account) external returns (bool);
840 
841     /**
842      * @return True after successfully bulk minting and transferring the
843      * `nextTokenId` through `nextTokenId + amount` tokens to `account`.
844      *
845      * Emits a `Transfer` event (with `address(0)` as `from`) for each token
846      * that is minted.
847      *
848      * Requirements:
849      * - `account` cannot be the zero address.
850      * @param account The account to receive the minted tokens.
851      * @param amount The number of tokens to be minted.
852      */
853     function bulkMintToOneAddress(address account, uint256 amount)
854         external
855         returns (bool);
856 
857     /**
858      * @return True after successfully bulk minting and transferring one of the
859      * `nextTokenId` through `nextTokenId + accounts.length` tokens to each of
860      * the addresses in `accounts`.
861      *
862      * Emits a `Transfer` event (with `address(0)` as `from`) for each token
863      * that is minted.
864      *
865      * Requirements:
866      * - `accounts` cannot have length 0.
867      * - None of the addresses in `accounts` can be the zero address.
868      * @param accounts The accounts to receive the minted tokens.
869      */
870     function bulkMintToNAddresses(address[] calldata accounts)
871         external
872         returns (bool);
873 
874     /**
875      * @return True after successfully burning `tokenId`.
876      *
877      * Emits a `Transfer` event with `address(0)` as `to`.
878      *
879      * Requirements:
880      * - The caller must either own or be approved to spend the `tokenId` token.
881      * - `tokenId` must exist.
882      * @param tokenId The tokenId to be burned.
883      */
884     function redeem(uint256 tokenId) external returns (bool);
885 
886     // controllerRedeem() and controllerTransfer() declared in IERC1644
887 
888     /**
889      * Sets the default royalty fee percentage for the ERC721.
890      *
891      * A custom royalty fee will override the default if set for specific tokenIds.
892      *
893      * Requirements:
894      * - The caller must be the token contract owner.
895      * - `isControllable` must be true.
896      * @param receiver The account to receive the royalty.
897      * @param feeNumerator The fee amount in basis points.
898      */
899     function setDefaultRoyalty(address receiver, uint96 feeNumerator) external;
900 
901     /**
902      * Sets a custom royalty fee percentage for the specified `tokenId`.
903      *
904      * Requirements:
905      * - The caller must be the token contract owner.
906      * - `isControllable` must be true.
907      * - `tokenId` must exist.
908      * @param tokenId The tokenId to set a custom royalty for.
909      * @param receiver The account to receive the royalty.
910      * @param feeNumerator The fee amount in basis points.
911      */
912     function setTokenRoyalty(
913         uint256 tokenId,
914         address receiver,
915         uint96 feeNumerator
916     ) external;
917 }
918 
919 /**
920  * Interface for all functions in ERC721Collective, including inherited and
921  * overridden functions
922  */
923 interface IERC721Collective is
924     ITokenEnforceable,
925     IERC721UpgradeableFork,
926     IERC721CollectiveUnchained
927 {
928 
929 }
930 
931 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165Checker.sol)
932 
933 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
934 
935 /**
936  * @dev Interface of the ERC165 standard, as defined in the
937  * https://eips.ethereum.org/EIPS/eip-165[EIP].
938  *
939  * Implementers can declare support of contract interfaces, which can then be
940  * queried by others ({ERC165Checker}).
941  *
942  * For an implementation, see {ERC165}.
943  */
944 interface IERC165 {
945     /**
946      * @dev Returns true if this contract implements the interface defined by
947      * `interfaceId`. See the corresponding
948      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
949      * to learn more about how these ids are created.
950      *
951      * This function call must use less than 30 000 gas.
952      */
953     function supportsInterface(bytes4 interfaceId) external view returns (bool);
954 }
955 
956 /**
957  * @dev Library used to query support of an interface declared via {IERC165}.
958  *
959  * Note that these functions return the actual result of the query: they do not
960  * `revert` if an interface is not supported. It is up to the caller to decide
961  * what to do in these cases.
962  */
963 library ERC165Checker {
964     // As per the EIP-165 spec, no interface should ever match 0xffffffff
965     bytes4 private constant _INTERFACE_ID_INVALID = 0xffffffff;
966 
967     /**
968      * @dev Returns true if `account` supports the {IERC165} interface.
969      */
970     function supportsERC165(address account) internal view returns (bool) {
971         // Any contract that implements ERC165 must explicitly indicate support of
972         // InterfaceId_ERC165 and explicitly indicate non-support of InterfaceId_Invalid
973         return
974             supportsERC165InterfaceUnchecked(
975                 account,
976                 type(IERC165).interfaceId
977             ) &&
978             !supportsERC165InterfaceUnchecked(account, _INTERFACE_ID_INVALID);
979     }
980 
981     /**
982      * @dev Returns true if `account` supports the interface defined by
983      * `interfaceId`. Support for {IERC165} itself is queried automatically.
984      *
985      * See {IERC165-supportsInterface}.
986      */
987     function supportsInterface(address account, bytes4 interfaceId)
988         internal
989         view
990         returns (bool)
991     {
992         // query support of both ERC165 as per the spec and support of _interfaceId
993         return
994             supportsERC165(account) &&
995             supportsERC165InterfaceUnchecked(account, interfaceId);
996     }
997 
998     /**
999      * @dev Returns a boolean array where each value corresponds to the
1000      * interfaces passed in and whether they're supported or not. This allows
1001      * you to batch check interfaces for a contract where your expectation
1002      * is that some interfaces may not be supported.
1003      *
1004      * See {IERC165-supportsInterface}.
1005      *
1006      * _Available since v3.4._
1007      */
1008     function getSupportedInterfaces(
1009         address account,
1010         bytes4[] memory interfaceIds
1011     ) internal view returns (bool[] memory) {
1012         // an array of booleans corresponding to interfaceIds and whether they're supported or not
1013         bool[] memory interfaceIdsSupported = new bool[](interfaceIds.length);
1014 
1015         // query support of ERC165 itself
1016         if (supportsERC165(account)) {
1017             // query support of each interface in interfaceIds
1018             for (uint256 i = 0; i < interfaceIds.length; i++) {
1019                 interfaceIdsSupported[i] = supportsERC165InterfaceUnchecked(
1020                     account,
1021                     interfaceIds[i]
1022                 );
1023             }
1024         }
1025 
1026         return interfaceIdsSupported;
1027     }
1028 
1029     /**
1030      * @dev Returns true if `account` supports all the interfaces defined in
1031      * `interfaceIds`. Support for {IERC165} itself is queried automatically.
1032      *
1033      * Batch-querying can lead to gas savings by skipping repeated checks for
1034      * {IERC165} support.
1035      *
1036      * See {IERC165-supportsInterface}.
1037      */
1038     function supportsAllInterfaces(
1039         address account,
1040         bytes4[] memory interfaceIds
1041     ) internal view returns (bool) {
1042         // query support of ERC165 itself
1043         if (!supportsERC165(account)) {
1044             return false;
1045         }
1046 
1047         // query support of each interface in interfaceIds
1048         for (uint256 i = 0; i < interfaceIds.length; i++) {
1049             if (!supportsERC165InterfaceUnchecked(account, interfaceIds[i])) {
1050                 return false;
1051             }
1052         }
1053 
1054         // all interfaces supported
1055         return true;
1056     }
1057 
1058     /**
1059      * @notice Query if a contract implements an interface, does not check ERC165 support
1060      * @param account The address of the contract to query for support of an interface
1061      * @param interfaceId The interface identifier, as specified in ERC-165
1062      * @return true if the contract at account indicates support of the interface with
1063      * identifier interfaceId, false otherwise
1064      * @dev Assumes that account contains a contract that supports ERC165, otherwise
1065      * the behavior of this method is undefined. This precondition can be checked
1066      * with {supportsERC165}.
1067      * Interface identification is specified in ERC-165.
1068      */
1069     function supportsERC165InterfaceUnchecked(
1070         address account,
1071         bytes4 interfaceId
1072     ) internal view returns (bool) {
1073         // prepare call
1074         bytes memory encodedParams = abi.encodeWithSelector(
1075             IERC165.supportsInterface.selector,
1076             interfaceId
1077         );
1078 
1079         // perform static call
1080         bool success;
1081         uint256 returnSize;
1082         uint256 returnValue;
1083         assembly {
1084             success := staticcall(
1085                 30000,
1086                 account,
1087                 add(encodedParams, 0x20),
1088                 mload(encodedParams),
1089                 0x00,
1090                 0x20
1091             )
1092             returnSize := returndatasize()
1093             returnValue := mload(0x00)
1094         }
1095 
1096         return success && returnSize >= 0x20 && returnValue > 0;
1097     }
1098 }
1099 
1100 /// Mixin can be used by any module using an address that should be an
1101 /// ERC721Collective and needs to check if it indeed is one.
1102 abstract contract ERC165CheckerERC721Collective {
1103     /// Only proceed if collective implements IERC721Collective interface
1104     /// @param collective collective to check
1105     modifier onlyCollectiveInterface(address collective) {
1106         _checkCollectiveInterface(collective);
1107         _;
1108     }
1109 
1110     function _checkCollectiveInterface(address collective) internal view {
1111         require(
1112             ERC165Checker.supportsInterface(
1113                 collective,
1114                 type(IERC721Collective).interfaceId
1115             ),
1116             "ERC165CheckerERC721Collective: collective address does not implement proper interface"
1117         );
1118     }
1119 }
1120 
1121 interface IOwner {
1122     function owner() external view returns (address);
1123 }
1124 
1125 /**
1126  * Utility for use by any module or guard that needs to check if an address is
1127  * the owner of the TokenEnforceable (ERC20Club or ERC721Collective)
1128  */
1129 
1130 abstract contract TokenOwnerChecker {
1131     /**
1132      * Only proceed if msg.sender owns TokenEnforceable contract
1133      * @param token TokenEnforceable whose owner to check
1134      */
1135     modifier onlyTokenOwner(address token) {
1136         _onlyTokenOwner(token);
1137         _;
1138     }
1139 
1140     function _onlyTokenOwner(address token) internal view {
1141         require(
1142             msg.sender == IOwner(token).owner(),
1143             "TokenOwnerChecker: Caller not token owner"
1144         );
1145     }
1146 }
1147 
1148 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
1149 
1150 /**
1151  * @dev Interface of the ERC20 standard as defined in the EIP.
1152  */
1153 interface IERC20 {
1154     /**
1155      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1156      * another (`to`).
1157      *
1158      * Note that `value` may be zero.
1159      */
1160     event Transfer(address indexed from, address indexed to, uint256 value);
1161 
1162     /**
1163      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1164      * a call to {approve}. `value` is the new allowance.
1165      */
1166     event Approval(
1167         address indexed owner,
1168         address indexed spender,
1169         uint256 value
1170     );
1171 
1172     /**
1173      * @dev Returns the amount of tokens in existence.
1174      */
1175     function totalSupply() external view returns (uint256);
1176 
1177     /**
1178      * @dev Returns the amount of tokens owned by `account`.
1179      */
1180     function balanceOf(address account) external view returns (uint256);
1181 
1182     /**
1183      * @dev Moves `amount` tokens from the caller's account to `to`.
1184      *
1185      * Returns a boolean value indicating whether the operation succeeded.
1186      *
1187      * Emits a {Transfer} event.
1188      */
1189     function transfer(address to, uint256 amount) external returns (bool);
1190 
1191     /**
1192      * @dev Returns the remaining number of tokens that `spender` will be
1193      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1194      * zero by default.
1195      *
1196      * This value changes when {approve} or {transferFrom} are called.
1197      */
1198     function allowance(address owner, address spender)
1199         external
1200         view
1201         returns (uint256);
1202 
1203     /**
1204      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1205      *
1206      * Returns a boolean value indicating whether the operation succeeded.
1207      *
1208      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1209      * that someone may use both the old and the new allowance by unfortunate
1210      * transaction ordering. One possible solution to mitigate this race
1211      * condition is to first reduce the spender's allowance to 0 and set the
1212      * desired value afterwards:
1213      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1214      *
1215      * Emits an {Approval} event.
1216      */
1217     function approve(address spender, uint256 amount) external returns (bool);
1218 
1219     /**
1220      * @dev Moves `amount` tokens from `from` to `to` using the
1221      * allowance mechanism. `amount` is then deducted from the caller's
1222      * allowance.
1223      *
1224      * Returns a boolean value indicating whether the operation succeeded.
1225      *
1226      * Emits a {Transfer} event.
1227      */
1228     function transferFrom(
1229         address from,
1230         address to,
1231         uint256 amount
1232     ) external returns (bool);
1233 }
1234 
1235 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
1236 
1237 /**
1238  * @dev Required interface of an ERC721 compliant contract.
1239  */
1240 interface IERC721 is IERC165 {
1241     /**
1242      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1243      */
1244     event Transfer(
1245         address indexed from,
1246         address indexed to,
1247         uint256 indexed tokenId
1248     );
1249 
1250     /**
1251      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1252      */
1253     event Approval(
1254         address indexed owner,
1255         address indexed approved,
1256         uint256 indexed tokenId
1257     );
1258 
1259     /**
1260      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1261      */
1262     event ApprovalForAll(
1263         address indexed owner,
1264         address indexed operator,
1265         bool approved
1266     );
1267 
1268     /**
1269      * @dev Returns the number of tokens in ``owner``'s account.
1270      */
1271     function balanceOf(address owner) external view returns (uint256 balance);
1272 
1273     /**
1274      * @dev Returns the owner of the `tokenId` token.
1275      *
1276      * Requirements:
1277      *
1278      * - `tokenId` must exist.
1279      */
1280     function ownerOf(uint256 tokenId) external view returns (address owner);
1281 
1282     /**
1283      * @dev Safely transfers `tokenId` token from `from` to `to`.
1284      *
1285      * Requirements:
1286      *
1287      * - `from` cannot be the zero address.
1288      * - `to` cannot be the zero address.
1289      * - `tokenId` token must exist and be owned by `from`.
1290      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1291      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1292      *
1293      * Emits a {Transfer} event.
1294      */
1295     function safeTransferFrom(
1296         address from,
1297         address to,
1298         uint256 tokenId,
1299         bytes calldata data
1300     ) external;
1301 
1302     /**
1303      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1304      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1305      *
1306      * Requirements:
1307      *
1308      * - `from` cannot be the zero address.
1309      * - `to` cannot be the zero address.
1310      * - `tokenId` token must exist and be owned by `from`.
1311      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1312      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1313      *
1314      * Emits a {Transfer} event.
1315      */
1316     function safeTransferFrom(
1317         address from,
1318         address to,
1319         uint256 tokenId
1320     ) external;
1321 
1322     /**
1323      * @dev Transfers `tokenId` token from `from` to `to`.
1324      *
1325      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
1326      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
1327      * understand this adds an external call which potentially creates a reentrancy vulnerability.
1328      *
1329      * Requirements:
1330      *
1331      * - `from` cannot be the zero address.
1332      * - `to` cannot be the zero address.
1333      * - `tokenId` token must be owned by `from`.
1334      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1335      *
1336      * Emits a {Transfer} event.
1337      */
1338     function transferFrom(
1339         address from,
1340         address to,
1341         uint256 tokenId
1342     ) external;
1343 
1344     /**
1345      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1346      * The approval is cleared when the token is transferred.
1347      *
1348      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1349      *
1350      * Requirements:
1351      *
1352      * - The caller must own the token or be an approved operator.
1353      * - `tokenId` must exist.
1354      *
1355      * Emits an {Approval} event.
1356      */
1357     function approve(address to, uint256 tokenId) external;
1358 
1359     /**
1360      * @dev Approve or remove `operator` as an operator for the caller.
1361      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1362      *
1363      * Requirements:
1364      *
1365      * - The `operator` cannot be the caller.
1366      *
1367      * Emits an {ApprovalForAll} event.
1368      */
1369     function setApprovalForAll(address operator, bool _approved) external;
1370 
1371     /**
1372      * @dev Returns the account approved for `tokenId` token.
1373      *
1374      * Requirements:
1375      *
1376      * - `tokenId` must exist.
1377      */
1378     function getApproved(uint256 tokenId)
1379         external
1380         view
1381         returns (address operator);
1382 
1383     /**
1384      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1385      *
1386      * See {setApprovalForAll}
1387      */
1388     function isApprovedForAll(address owner, address operator)
1389         external
1390         view
1391         returns (bool);
1392 }
1393 
1394 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/utils/SafeERC20.sol)
1395 
1396 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
1397 
1398 /**
1399  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
1400  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
1401  *
1402  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
1403  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
1404  * need to send a transaction, and thus is not required to hold Ether at all.
1405  */
1406 interface IERC20Permit {
1407     /**
1408      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
1409      * given ``owner``'s signed approval.
1410      *
1411      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
1412      * ordering also apply here.
1413      *
1414      * Emits an {Approval} event.
1415      *
1416      * Requirements:
1417      *
1418      * - `spender` cannot be the zero address.
1419      * - `deadline` must be a timestamp in the future.
1420      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
1421      * over the EIP712-formatted function arguments.
1422      * - the signature must use ``owner``'s current nonce (see {nonces}).
1423      *
1424      * For more information on the signature format, see the
1425      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
1426      * section].
1427      */
1428     function permit(
1429         address owner,
1430         address spender,
1431         uint256 value,
1432         uint256 deadline,
1433         uint8 v,
1434         bytes32 r,
1435         bytes32 s
1436     ) external;
1437 
1438     /**
1439      * @dev Returns the current nonce for `owner`. This value must be
1440      * included whenever a signature is generated for {permit}.
1441      *
1442      * Every successful call to {permit} increases ``owner``'s nonce by one. This
1443      * prevents a signature from being used multiple times.
1444      */
1445     function nonces(address owner) external view returns (uint256);
1446 
1447     /**
1448      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
1449      */
1450     // solhint-disable-next-line func-name-mixedcase
1451     function DOMAIN_SEPARATOR() external view returns (bytes32);
1452 }
1453 
1454 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
1455 
1456 /**
1457  * @dev Collection of functions related to the address type
1458  */
1459 library Address {
1460     /**
1461      * @dev Returns true if `account` is a contract.
1462      *
1463      * [IMPORTANT]
1464      * ====
1465      * It is unsafe to assume that an address for which this function returns
1466      * false is an externally-owned account (EOA) and not a contract.
1467      *
1468      * Among others, `isContract` will return false for the following
1469      * types of addresses:
1470      *
1471      *  - an externally-owned account
1472      *  - a contract in construction
1473      *  - an address where a contract will be created
1474      *  - an address where a contract lived, but was destroyed
1475      * ====
1476      *
1477      * [IMPORTANT]
1478      * ====
1479      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1480      *
1481      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1482      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1483      * constructor.
1484      * ====
1485      */
1486     function isContract(address account) internal view returns (bool) {
1487         // This method relies on extcodesize/address.code.length, which returns 0
1488         // for contracts in construction, since the code is only stored at the end
1489         // of the constructor execution.
1490 
1491         return account.code.length > 0;
1492     }
1493 
1494     /**
1495      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1496      * `recipient`, forwarding all available gas and reverting on errors.
1497      *
1498      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1499      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1500      * imposed by `transfer`, making them unable to receive funds via
1501      * `transfer`. {sendValue} removes this limitation.
1502      *
1503      * https://consensys.net/diligence/blog/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1504      *
1505      * IMPORTANT: because control is transferred to `recipient`, care must be
1506      * taken to not create reentrancy vulnerabilities. Consider using
1507      * {ReentrancyGuard} or the
1508      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1509      */
1510     function sendValue(address payable recipient, uint256 amount) internal {
1511         require(
1512             address(this).balance >= amount,
1513             "Address: insufficient balance"
1514         );
1515 
1516         (bool success, ) = recipient.call{value: amount}("");
1517         require(
1518             success,
1519             "Address: unable to send value, recipient may have reverted"
1520         );
1521     }
1522 
1523     /**
1524      * @dev Performs a Solidity function call using a low level `call`. A
1525      * plain `call` is an unsafe replacement for a function call: use this
1526      * function instead.
1527      *
1528      * If `target` reverts with a revert reason, it is bubbled up by this
1529      * function (like regular Solidity function calls).
1530      *
1531      * Returns the raw returned data. To convert to the expected return value,
1532      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1533      *
1534      * Requirements:
1535      *
1536      * - `target` must be a contract.
1537      * - calling `target` with `data` must not revert.
1538      *
1539      * _Available since v3.1._
1540      */
1541     function functionCall(address target, bytes memory data)
1542         internal
1543         returns (bytes memory)
1544     {
1545         return
1546             functionCallWithValue(
1547                 target,
1548                 data,
1549                 0,
1550                 "Address: low-level call failed"
1551             );
1552     }
1553 
1554     /**
1555      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1556      * `errorMessage` as a fallback revert reason when `target` reverts.
1557      *
1558      * _Available since v3.1._
1559      */
1560     function functionCall(
1561         address target,
1562         bytes memory data,
1563         string memory errorMessage
1564     ) internal returns (bytes memory) {
1565         return functionCallWithValue(target, data, 0, errorMessage);
1566     }
1567 
1568     /**
1569      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1570      * but also transferring `value` wei to `target`.
1571      *
1572      * Requirements:
1573      *
1574      * - the calling contract must have an ETH balance of at least `value`.
1575      * - the called Solidity function must be `payable`.
1576      *
1577      * _Available since v3.1._
1578      */
1579     function functionCallWithValue(
1580         address target,
1581         bytes memory data,
1582         uint256 value
1583     ) internal returns (bytes memory) {
1584         return
1585             functionCallWithValue(
1586                 target,
1587                 data,
1588                 value,
1589                 "Address: low-level call with value failed"
1590             );
1591     }
1592 
1593     /**
1594      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1595      * with `errorMessage` as a fallback revert reason when `target` reverts.
1596      *
1597      * _Available since v3.1._
1598      */
1599     function functionCallWithValue(
1600         address target,
1601         bytes memory data,
1602         uint256 value,
1603         string memory errorMessage
1604     ) internal returns (bytes memory) {
1605         require(
1606             address(this).balance >= value,
1607             "Address: insufficient balance for call"
1608         );
1609         (bool success, bytes memory returndata) = target.call{value: value}(
1610             data
1611         );
1612         return
1613             verifyCallResultFromTarget(
1614                 target,
1615                 success,
1616                 returndata,
1617                 errorMessage
1618             );
1619     }
1620 
1621     /**
1622      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1623      * but performing a static call.
1624      *
1625      * _Available since v3.3._
1626      */
1627     function functionStaticCall(address target, bytes memory data)
1628         internal
1629         view
1630         returns (bytes memory)
1631     {
1632         return
1633             functionStaticCall(
1634                 target,
1635                 data,
1636                 "Address: low-level static call failed"
1637             );
1638     }
1639 
1640     /**
1641      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1642      * but performing a static call.
1643      *
1644      * _Available since v3.3._
1645      */
1646     function functionStaticCall(
1647         address target,
1648         bytes memory data,
1649         string memory errorMessage
1650     ) internal view returns (bytes memory) {
1651         (bool success, bytes memory returndata) = target.staticcall(data);
1652         return
1653             verifyCallResultFromTarget(
1654                 target,
1655                 success,
1656                 returndata,
1657                 errorMessage
1658             );
1659     }
1660 
1661     /**
1662      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1663      * but performing a delegate call.
1664      *
1665      * _Available since v3.4._
1666      */
1667     function functionDelegateCall(address target, bytes memory data)
1668         internal
1669         returns (bytes memory)
1670     {
1671         return
1672             functionDelegateCall(
1673                 target,
1674                 data,
1675                 "Address: low-level delegate call failed"
1676             );
1677     }
1678 
1679     /**
1680      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1681      * but performing a delegate call.
1682      *
1683      * _Available since v3.4._
1684      */
1685     function functionDelegateCall(
1686         address target,
1687         bytes memory data,
1688         string memory errorMessage
1689     ) internal returns (bytes memory) {
1690         (bool success, bytes memory returndata) = target.delegatecall(data);
1691         return
1692             verifyCallResultFromTarget(
1693                 target,
1694                 success,
1695                 returndata,
1696                 errorMessage
1697             );
1698     }
1699 
1700     /**
1701      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
1702      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
1703      *
1704      * _Available since v4.8._
1705      */
1706     function verifyCallResultFromTarget(
1707         address target,
1708         bool success,
1709         bytes memory returndata,
1710         string memory errorMessage
1711     ) internal view returns (bytes memory) {
1712         if (success) {
1713             if (returndata.length == 0) {
1714                 // only check isContract if the call was successful and the return data is empty
1715                 // otherwise we already know that it was a contract
1716                 require(isContract(target), "Address: call to non-contract");
1717             }
1718             return returndata;
1719         } else {
1720             _revert(returndata, errorMessage);
1721         }
1722     }
1723 
1724     /**
1725      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
1726      * revert reason or using the provided one.
1727      *
1728      * _Available since v4.3._
1729      */
1730     function verifyCallResult(
1731         bool success,
1732         bytes memory returndata,
1733         string memory errorMessage
1734     ) internal pure returns (bytes memory) {
1735         if (success) {
1736             return returndata;
1737         } else {
1738             _revert(returndata, errorMessage);
1739         }
1740     }
1741 
1742     function _revert(bytes memory returndata, string memory errorMessage)
1743         private
1744         pure
1745     {
1746         // Look for revert reason and bubble it up if present
1747         if (returndata.length > 0) {
1748             // The easiest way to bubble the revert reason is using memory via assembly
1749             /// @solidity memory-safe-assembly
1750             assembly {
1751                 let returndata_size := mload(returndata)
1752                 revert(add(32, returndata), returndata_size)
1753             }
1754         } else {
1755             revert(errorMessage);
1756         }
1757     }
1758 }
1759 
1760 /**
1761  * @title SafeERC20
1762  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1763  * contract returns false). Tokens that return no value (and instead revert or
1764  * throw on failure) are also supported, non-reverting calls are assumed to be
1765  * successful.
1766  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
1767  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1768  */
1769 library SafeERC20 {
1770     using Address for address;
1771 
1772     function safeTransfer(
1773         IERC20 token,
1774         address to,
1775         uint256 value
1776     ) internal {
1777         _callOptionalReturn(
1778             token,
1779             abi.encodeWithSelector(token.transfer.selector, to, value)
1780         );
1781     }
1782 
1783     function safeTransferFrom(
1784         IERC20 token,
1785         address from,
1786         address to,
1787         uint256 value
1788     ) internal {
1789         _callOptionalReturn(
1790             token,
1791             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
1792         );
1793     }
1794 
1795     /**
1796      * @dev Deprecated. This function has issues similar to the ones found in
1797      * {IERC20-approve}, and its usage is discouraged.
1798      *
1799      * Whenever possible, use {safeIncreaseAllowance} and
1800      * {safeDecreaseAllowance} instead.
1801      */
1802     function safeApprove(
1803         IERC20 token,
1804         address spender,
1805         uint256 value
1806     ) internal {
1807         // safeApprove should only be called when setting an initial allowance,
1808         // or when resetting it to zero. To increase and decrease it, use
1809         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1810         require(
1811             (value == 0) || (token.allowance(address(this), spender) == 0),
1812             "SafeERC20: approve from non-zero to non-zero allowance"
1813         );
1814         _callOptionalReturn(
1815             token,
1816             abi.encodeWithSelector(token.approve.selector, spender, value)
1817         );
1818     }
1819 
1820     function safeIncreaseAllowance(
1821         IERC20 token,
1822         address spender,
1823         uint256 value
1824     ) internal {
1825         uint256 newAllowance = token.allowance(address(this), spender) + value;
1826         _callOptionalReturn(
1827             token,
1828             abi.encodeWithSelector(
1829                 token.approve.selector,
1830                 spender,
1831                 newAllowance
1832             )
1833         );
1834     }
1835 
1836     function safeDecreaseAllowance(
1837         IERC20 token,
1838         address spender,
1839         uint256 value
1840     ) internal {
1841         unchecked {
1842             uint256 oldAllowance = token.allowance(address(this), spender);
1843             require(
1844                 oldAllowance >= value,
1845                 "SafeERC20: decreased allowance below zero"
1846             );
1847             uint256 newAllowance = oldAllowance - value;
1848             _callOptionalReturn(
1849                 token,
1850                 abi.encodeWithSelector(
1851                     token.approve.selector,
1852                     spender,
1853                     newAllowance
1854                 )
1855             );
1856         }
1857     }
1858 
1859     function safePermit(
1860         IERC20Permit token,
1861         address owner,
1862         address spender,
1863         uint256 value,
1864         uint256 deadline,
1865         uint8 v,
1866         bytes32 r,
1867         bytes32 s
1868     ) internal {
1869         uint256 nonceBefore = token.nonces(owner);
1870         token.permit(owner, spender, value, deadline, v, r, s);
1871         uint256 nonceAfter = token.nonces(owner);
1872         require(
1873             nonceAfter == nonceBefore + 1,
1874             "SafeERC20: permit did not succeed"
1875         );
1876     }
1877 
1878     /**
1879      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1880      * on the return value: the return value is optional (but if data is returned, it must not be false).
1881      * @param token The token targeted by the call.
1882      * @param data The call data (encoded using abi.encode or one of its variants).
1883      */
1884     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1885         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1886         // we're implementing it ourselves. We use {Address-functionCall} to perform this call, which verifies that
1887         // the target address contains contract code and also asserts for success in the low-level call.
1888 
1889         bytes memory returndata = address(token).functionCall(
1890             data,
1891             "SafeERC20: low-level call failed"
1892         );
1893         if (returndata.length > 0) {
1894             // Return data is optional
1895             require(
1896                 abi.decode(returndata, (bool)),
1897                 "SafeERC20: ERC20 operation did not succeed"
1898             );
1899         }
1900     }
1901 }
1902 
1903 abstract contract TokenRecoverable is ITokenRecoverable {
1904     // Using safeTransfer since interacting with other ERC20s
1905     using SafeERC20 for IERC20;
1906 
1907     address public admin;
1908 
1909     constructor(address _admin) {
1910         admin = _admin;
1911     }
1912 
1913     modifier isAdmin() {
1914         require(msg.sender == admin, "TokenRecoverable: Caller not admin");
1915         _;
1916     }
1917 
1918     /**
1919      * Only allows a syndicate address to access any ERC20 tokens erroneously sent to the contract.
1920      *
1921      * Emits a `TokenRecoveredERC20` event.
1922      *
1923      * Requirements:
1924      * - None
1925      * @param recipient Address that erroneously sent the ERC20 token(s)
1926      * @param erc20 Erroneously-sent ERC20 token to recover
1927      * @param amount Amount to recover
1928      */
1929     function recoverERC20(
1930         address recipient,
1931         address erc20,
1932         uint256 amount
1933     ) external isAdmin {
1934         IERC20(erc20).safeTransfer(recipient, amount);
1935         emit TokenRecoveredERC20(recipient, erc20, amount);
1936     }
1937 
1938     /**
1939      * Only allows a syndicate address to access any ERC721 tokens erroneously sent to the contract.
1940      *
1941      * Emits a `TokenRecoveredERC721` event.
1942      *
1943      * Requirements:
1944      * - None
1945      * @param recipient Address that erroneously sent the ERC721 token
1946      * @param erc721 Erroneously-sent ERC721 token to recover
1947      * @param tokenId The tokenId to recover
1948      */
1949     function recoverERC721(
1950         address recipient,
1951         address erc721,
1952         uint256 tokenId
1953     ) external isAdmin {
1954         IERC721(erc721).transferFrom(address(this), recipient, tokenId);
1955         emit TokenRecoveredERC721(recipient, erc721, tokenId);
1956     }
1957 }
1958 
1959 // Public mint module that allows anyone willing to pay the ETH price to mint.
1960 contract EthPriceMintModule is
1961     ReentrancyGuard,
1962     ERC165CheckerERC721Collective,
1963     TokenOwnerChecker,
1964     TokenRecoverable
1965 {
1966     // Collective => price to mint 1 token in wei
1967     mapping(address => uint256) public ethPrice;
1968 
1969     event EthPriceUpdated(address indexed collective, uint256 ethPrice_);
1970     event Minted(
1971         address indexed collective,
1972         address indexed account,
1973         uint256 amount
1974     );
1975 
1976     constructor(address admin) TokenRecoverable(admin) {}
1977 
1978     /// Update eth price for minting
1979     /// @param collective Collective to update
1980     /// @param ethPrice_ The price per ERC721
1981     function updateEthPrice(address collective, uint256 ethPrice_)
1982         public
1983         onlyTokenOwner(collective)
1984     {
1985         ethPrice[collective] = ethPrice_;
1986         emit EthPriceUpdated(collective, ethPrice_);
1987     }
1988 
1989     /// Mint Collective NFT - one per person
1990     /// @param collective Collective to mint
1991     /// @param amount amount to be minted
1992     /// @return true
1993     function mint(address collective, uint256 amount)
1994         external
1995         payable
1996         nonReentrant
1997         onlyCollectiveInterface(collective)
1998         returns (bool)
1999     {
2000         require(
2001             msg.value == ethPrice[collective] * amount,
2002             "EthPriceMintModule: Must send ETH value equal to ethPrice"
2003         );
2004 
2005         // solhint-disable-next-line avoid-low-level-calls
2006         (bool success, ) = payable(Ownable(collective).owner()).call{
2007             value: msg.value
2008         }("");
2009         require(success, "EthPriceMintModule: Failed to send Ether to owner");
2010 
2011         IERC721Collective(collective).bulkMintToOneAddress(msg.sender, amount);
2012         emit Minted(collective, msg.sender, amount);
2013         return true;
2014     }
2015 
2016     /// This function is called for all messages sent to this contract (there
2017     /// are no other functions). Sending Ether to this contract will cause an
2018     /// exception, because the fallback function does not have the `payable`
2019     /// modifier.
2020     /// Source: https://docs.soliditylang.org/en/v0.8.9/contracts.html?highlight=fallback#fallback-function
2021     fallback() external {
2022         revert("EthPriceMintModule: non-existent function");
2023     }
2024 }