1 pragma solidity ^0.8.7;
2 // SPDX-License-Identifier: MIT
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
5 /**
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         return msg.data;
22     }
23 }
24 
25 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
26 /**
27  * @dev Contract module which provides a basic access control mechanism, where
28  * there is an account (an owner) that can be granted exclusive access to
29  * specific functions.
30  *
31  * By default, the owner account will be the one that deploys the contract. This
32  * can later be changed with {transferOwnership}.
33  *
34  * This module is used through inheritance. It will make available the modifier
35  * `onlyOwner`, which can be applied to your functions to restrict their use to
36  * the owner.
37  */
38 abstract contract Ownable is Context {
39     address private _owner;
40 
41     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
42 
43     /**
44      * @dev Initializes the contract setting the deployer as the initial owner.
45      */
46     constructor() {
47         _transferOwnership(_msgSender());
48     }
49 
50     /**
51      * @dev Returns the address of the current owner.
52      */
53     function owner() public view virtual returns (address) {
54         return _owner;
55     }
56 
57     /**
58      * @dev Throws if called by any account other than the owner.
59      */
60     modifier onlyOwner() {
61         require(owner() == _msgSender(), "Ownable: caller is not the owner");
62         _;
63     }
64 
65     /**
66      * @dev Leaves the contract without owner. It will not be possible to call
67      * `onlyOwner` functions anymore. Can only be called by the current owner.
68      *
69      * NOTE: Renouncing ownership will leave the contract without an owner,
70      * thereby removing any functionality that is only available to the owner.
71      */
72     function renounceOwnership() public virtual onlyOwner {
73         _transferOwnership(address(0));
74     }
75 
76     /**
77      * @dev Transfers ownership of the contract to a new account (`newOwner`).
78      * Can only be called by the current owner.
79      */
80     function transferOwnership(address newOwner) public virtual onlyOwner {
81         require(newOwner != address(0), "Ownable: new owner is the zero address");
82         _transferOwnership(newOwner);
83     }
84 
85     /**
86      * @dev Transfers ownership of the contract to a new account (`newOwner`).
87      * Internal function without access restriction.
88      */
89     function _transferOwnership(address newOwner) internal virtual {
90         address oldOwner = _owner;
91         _owner = newOwner;
92         emit OwnershipTransferred(oldOwner, newOwner);
93     }
94 }
95 
96 
97 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
98 /**
99  * @dev Interface of the ERC165 standard, as defined in the
100  * https://eips.ethereum.org/EIPS/eip-165[EIP].
101  *
102  * Implementers can declare support of contract interfaces, which can then be
103  * queried by others ({ERC165Checker}).
104  *
105  * For an implementation, see {ERC165}.
106  */
107 interface IERC165 {
108     /**
109      * @dev Returns true if this contract implements the interface defined by
110      * `interfaceId`. See the corresponding
111      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
112      * to learn more about how these ids are created.
113      *
114      * This function call must use less than 30 000 gas.
115      */
116     function supportsInterface(bytes4 interfaceId) external view returns (bool);
117 }
118 
119 
120 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
121 /**
122  * @dev Required interface of an ERC721 compliant contract.
123  */
124 interface IERC721 is IERC165 {
125     /**
126      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
127      */
128     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
129 
130     /**
131      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
132      */
133     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
134 
135     /**
136      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
137      */
138     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
139 
140     /**
141      * @dev Returns the number of tokens in ``owner``'s account.
142      */
143     function balanceOf(address owner) external view returns (uint256 balance);
144 
145     /**
146      * @dev Returns the owner of the `tokenId` token.
147      *
148      * Requirements:
149      *
150      * - `tokenId` must exist.
151      */
152     function ownerOf(uint256 tokenId) external view returns (address owner);
153 
154     /**
155      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
156      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
157      *
158      * Requirements:
159      *
160      * - `from` cannot be the zero address.
161      * - `to` cannot be the zero address.
162      * - `tokenId` token must exist and be owned by `from`.
163      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
164      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
165      *
166      * Emits a {Transfer} event.
167      */
168     function safeTransferFrom(
169         address from,
170         address to,
171         uint256 tokenId
172     ) external;
173 
174     /**
175      * @dev Transfers `tokenId` token from `from` to `to`.
176      *
177      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
178      *
179      * Requirements:
180      *
181      * - `from` cannot be the zero address.
182      * - `to` cannot be the zero address.
183      * - `tokenId` token must be owned by `from`.
184      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
185      *
186      * Emits a {Transfer} event.
187      */
188     function transferFrom(
189         address from,
190         address to,
191         uint256 tokenId
192     ) external;
193 
194     /**
195      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
196      * The approval is cleared when the token is transferred.
197      *
198      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
199      *
200      * Requirements:
201      *
202      * - The caller must own the token or be an approved operator.
203      * - `tokenId` must exist.
204      *
205      * Emits an {Approval} event.
206      */
207     function approve(address to, uint256 tokenId) external;
208 
209     /**
210      * @dev Returns the account approved for `tokenId` token.
211      *
212      * Requirements:
213      *
214      * - `tokenId` must exist.
215      */
216     function getApproved(uint256 tokenId) external view returns (address operator);
217 
218     /**
219      * @dev Approve or remove `operator` as an operator for the caller.
220      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
221      *
222      * Requirements:
223      *
224      * - The `operator` cannot be the caller.
225      *
226      * Emits an {ApprovalForAll} event.
227      */
228     function setApprovalForAll(address operator, bool _approved) external;
229 
230     /**
231      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
232      *
233      * See {setApprovalForAll}
234      */
235     function isApprovedForAll(address owner, address operator) external view returns (bool);
236 
237     /**
238      * @dev Safely transfers `tokenId` token from `from` to `to`.
239      *
240      * Requirements:
241      *
242      * - `from` cannot be the zero address.
243      * - `to` cannot be the zero address.
244      * - `tokenId` token must exist and be owned by `from`.
245      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
246      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
247      *
248      * Emits a {Transfer} event.
249      */
250     function safeTransferFrom(
251         address from,
252         address to,
253         uint256 tokenId,
254         bytes calldata data
255     ) external;
256 }
257 
258 
259 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155.sol)
260 /**
261  * @dev Required interface of an ERC1155 compliant contract, as defined in the
262  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
263  *
264  * _Available since v3.1._
265  */
266 interface IERC1155 is IERC165 {
267     /**
268      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
269      */
270     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
271 
272     /**
273      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
274      * transfers.
275      */
276     event TransferBatch(
277         address indexed operator,
278         address indexed from,
279         address indexed to,
280         uint256[] ids,
281         uint256[] values
282     );
283 
284     /**
285      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
286      * `approved`.
287      */
288     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
289 
290     /**
291      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
292      *
293      * If an {URI} event was emitted for `id`, the standard
294      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
295      * returned by {IERC1155MetadataURI-uri}.
296      */
297     event URI(string value, uint256 indexed id);
298 
299     /**
300      * @dev Returns the amount of tokens of token type `id` owned by `account`.
301      *
302      * Requirements:
303      *
304      * - `account` cannot be the zero address.
305      */
306     function balanceOf(address account, uint256 id) external view returns (uint256);
307 
308     /**
309      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
310      *
311      * Requirements:
312      *
313      * - `accounts` and `ids` must have the same length.
314      */
315     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
316         external
317         view
318         returns (uint256[] memory);
319 
320     /**
321      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
322      *
323      * Emits an {ApprovalForAll} event.
324      *
325      * Requirements:
326      *
327      * - `operator` cannot be the caller.
328      */
329     function setApprovalForAll(address operator, bool approved) external;
330 
331     /**
332      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
333      *
334      * See {setApprovalForAll}.
335      */
336     function isApprovedForAll(address account, address operator) external view returns (bool);
337 
338     /**
339      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
340      *
341      * Emits a {TransferSingle} event.
342      *
343      * Requirements:
344      *
345      * - `to` cannot be the zero address.
346      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
347      * - `from` must have a balance of tokens of type `id` of at least `amount`.
348      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
349      * acceptance magic value.
350      */
351     function safeTransferFrom(
352         address from,
353         address to,
354         uint256 id,
355         uint256 amount,
356         bytes calldata data
357     ) external;
358 
359     /**
360      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
361      *
362      * Emits a {TransferBatch} event.
363      *
364      * Requirements:
365      *
366      * - `ids` and `amounts` must have the same length.
367      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
368      * acceptance magic value.
369      */
370     function safeBatchTransferFrom(
371         address from,
372         address to,
373         uint256[] calldata ids,
374         uint256[] calldata amounts,
375         bytes calldata data
376     ) external;
377 }
378 
379 
380 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
381 /**
382  * @dev Interface of the ERC20 standard as defined in the EIP.
383  */
384 interface IERC20 {
385     /**
386      * @dev Returns the amount of tokens in existence.
387      */
388     function totalSupply() external view returns (uint256);
389 
390     /**
391      * @dev Returns the amount of tokens owned by `account`.
392      */
393     function balanceOf(address account) external view returns (uint256);
394 
395     /**
396      * @dev Moves `amount` tokens from the caller's account to `to`.
397      *
398      * Returns a boolean value indicating whether the operation succeeded.
399      *
400      * Emits a {Transfer} event.
401      */
402     function transfer(address to, uint256 amount) external returns (bool);
403 
404     /**
405      * @dev Returns the remaining number of tokens that `spender` will be
406      * allowed to spend on behalf of `owner` through {transferFrom}. This is
407      * zero by default.
408      *
409      * This value changes when {approve} or {transferFrom} are called.
410      */
411     function allowance(address owner, address spender) external view returns (uint256);
412 
413     /**
414      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
415      *
416      * Returns a boolean value indicating whether the operation succeeded.
417      *
418      * IMPORTANT: Beware that changing an allowance with this method brings the risk
419      * that someone may use both the old and the new allowance by unfortunate
420      * transaction ordering. One possible solution to mitigate this race
421      * condition is to first reduce the spender's allowance to 0 and set the
422      * desired value afterwards:
423      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
424      *
425      * Emits an {Approval} event.
426      */
427     function approve(address spender, uint256 amount) external returns (bool);
428 
429     /**
430      * @dev Moves `amount` tokens from `from` to `to` using the
431      * allowance mechanism. `amount` is then deducted from the caller's
432      * allowance.
433      *
434      * Returns a boolean value indicating whether the operation succeeded.
435      *
436      * Emits a {Transfer} event.
437      */
438     function transferFrom(
439         address from,
440         address to,
441         uint256 amount
442     ) external returns (bool);
443 
444     /**
445      * @dev Emitted when `value` tokens are moved from one account (`from`) to
446      * another (`to`).
447      *
448      * Note that `value` may be zero.
449      */
450     event Transfer(address indexed from, address indexed to, uint256 value);
451 
452     /**
453      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
454      * a call to {approve}. `value` is the new allowance.
455      */
456     event Approval(address indexed owner, address indexed spender, uint256 value);
457 }
458 
459 
460 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
461 /**
462  * @dev Contract module that helps prevent reentrant calls to a function.
463  *
464  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
465  * available, which can be applied to functions to make sure there are no nested
466  * (reentrant) calls to them.
467  *
468  * Note that because there is a single `nonReentrant` guard, functions marked as
469  * `nonReentrant` may not call one another. This can be worked around by making
470  * those functions `private`, and then adding `external` `nonReentrant` entry
471  * points to them.
472  *
473  * TIP: If you would like to learn more about reentrancy and alternative ways
474  * to protect against it, check out our blog post
475  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
476  */
477 abstract contract ReentrancyGuard {
478     // Booleans are more expensive than uint256 or any type that takes up a full
479     // word because each write operation emits an extra SLOAD to first read the
480     // slot's contents, replace the bits taken up by the boolean, and then write
481     // back. This is the compiler's defense against contract upgrades and
482     // pointer aliasing, and it cannot be disabled.
483 
484     // The values being non-zero value makes deployment a bit more expensive,
485     // but in exchange the refund on every call to nonReentrant will be lower in
486     // amount. Since refunds are capped to a percentage of the total
487     // transaction's gas, it is best to keep them low in cases like this one, to
488     // increase the likelihood of the full refund coming into effect.
489     uint256 private constant _NOT_ENTERED = 1;
490     uint256 private constant _ENTERED = 2;
491 
492     uint256 private _status;
493 
494     constructor() {
495         _status = _NOT_ENTERED;
496     }
497 
498     /**
499      * @dev Prevents a contract from calling itself, directly or indirectly.
500      * Calling a `nonReentrant` function from another `nonReentrant`
501      * function is not supported. It is possible to prevent this from happening
502      * by making the `nonReentrant` function external, and making it call a
503      * `private` function that does the actual work.
504      */
505     modifier nonReentrant() {
506         // On the first call to nonReentrant, _notEntered will be true
507         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
508 
509         // Any calls to nonReentrant after this point will fail
510         _status = _ENTERED;
511 
512         _;
513 
514         // By storing the original value once again, a refund is triggered (see
515         // https://eips.ethereum.org/EIPS/eip-2200)
516         _status = _NOT_ENTERED;
517     }
518 }
519 
520 
521 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)
522 /**
523  * @dev _Available since v3.1._
524  */
525 interface IERC1155Receiver is IERC165 {
526     /**
527      * @dev Handles the receipt of a single ERC1155 token type. This function is
528      * called at the end of a `safeTransferFrom` after the balance has been updated.
529      *
530      * NOTE: To accept the transfer, this must return
531      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
532      * (i.e. 0xf23a6e61, or its own function selector).
533      *
534      * @param operator The address which initiated the transfer (i.e. msg.sender)
535      * @param from The address which previously owned the token
536      * @param id The ID of the token being transferred
537      * @param value The amount of tokens being transferred
538      * @param data Additional data with no specified format
539      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
540      */
541     function onERC1155Received(
542         address operator,
543         address from,
544         uint256 id,
545         uint256 value,
546         bytes calldata data
547     ) external returns (bytes4);
548 
549     /**
550      * @dev Handles the receipt of a multiple ERC1155 token types. This function
551      * is called at the end of a `safeBatchTransferFrom` after the balances have
552      * been updated.
553      *
554      * NOTE: To accept the transfer(s), this must return
555      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
556      * (i.e. 0xbc197c81, or its own function selector).
557      *
558      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
559      * @param from The address which previously owned the token
560      * @param ids An array containing ids of each token being transferred (order and length must match values array)
561      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
562      * @param data Additional data with no specified format
563      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
564      */
565     function onERC1155BatchReceived(
566         address operator,
567         address from,
568         uint256[] calldata ids,
569         uint256[] calldata values,
570         bytes calldata data
571     ) external returns (bytes4);
572 }
573 
574 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
575 /**
576  * @dev Implementation of the {IERC165} interface.
577  *
578  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
579  * for the additional interface id that will be supported. For example:
580  *
581  * ```solidity
582  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
583  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
584  * }
585  * ```
586  *
587  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
588  */
589 abstract contract ERC165 is IERC165 {
590     /**
591      * @dev See {IERC165-supportsInterface}.
592      */
593     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
594         return interfaceId == type(IERC165).interfaceId;
595     }
596 }
597 
598 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/utils/ERC1155Receiver.sol)
599 /**
600  * @dev _Available since v3.1._
601  */
602 abstract contract ERC1155Receiver is ERC165, IERC1155Receiver {
603     /**
604      * @dev See {IERC165-supportsInterface}.
605      */
606     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
607         return interfaceId == type(IERC1155Receiver).interfaceId || super.supportsInterface(interfaceId);
608     }
609 }
610 
611 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/utils/ERC1155Holder.sol)
612 /**
613  * Simple implementation of `ERC1155Receiver` that will allow a contract to hold ERC1155 tokens.
614  *
615  * IMPORTANT: When inheriting this contract, you must include a way to use the received tokens, otherwise they will be
616  * stuck.
617  *
618  * @dev _Available since v3.1._
619  */
620 contract ERC1155Holder is ERC1155Receiver {
621     function onERC1155Received(
622         address,
623         address,
624         uint256,
625         uint256,
626         bytes memory
627     ) public virtual override returns (bytes4) {
628         return this.onERC1155Received.selector;
629     }
630 
631     function onERC1155BatchReceived(
632         address,
633         address,
634         uint256[] memory,
635         uint256[] memory,
636         bytes memory
637     ) public virtual override returns (bytes4) {
638         return this.onERC1155BatchReceived.selector;
639     }
640 }
641 
642 
643 contract MoonStaking is ERC1155Holder, Ownable, ReentrancyGuard {
644     IERC721 public ApeNft;
645     IERC721 public LootNft;
646     IERC1155 public PetNft;
647     IERC721 public TreasuryNft;
648     IERC721 public BreedingNft;
649 
650     uint256 public constant SECONDS_IN_DAY = 86400;
651 
652     bool public stakingLaunched;
653     bool public depositPaused;
654 
655     mapping(address => mapping(uint256 => uint256)) stakerPetAmounts;
656     mapping(address => mapping(uint256 => uint256)) stakerApeLoot;
657 
658     struct Staker {
659       uint256 currentYield;
660       uint256 accumulatedAmount;
661       uint256 lastCheckpoint;
662       uint256[] stakedAPE;
663       uint256[] stakedTREASURY;
664       uint256[] stakedBREEDING;
665       uint256[] stakedPET;
666     }
667 
668     mapping(address => Staker) private _stakers;
669 
670     enum ContractTypes {
671       APE,
672       LOOT,
673       PET,
674       TREASURY,
675       BREEDING
676     }
677 
678     mapping(address => ContractTypes) private _contractTypes;
679 
680     mapping(address => uint256) public _baseRates;
681     mapping(address => mapping(uint256 => uint256)) private _individualRates;
682     mapping(address => mapping(uint256 => address)) private _ownerOfToken;
683     mapping (address => bool) private _authorised;
684     address[] public authorisedLog;
685 
686     event Stake721(address indexed staker,address contractAddress,uint256 tokensAmount);
687     event StakeApesWithLoots(address indexed staker,uint256 apesAmount);
688     event AddLootToStakedApes(address indexed staker,uint256 apesAmount);
689     event RemoveLootFromStakedApes(address indexed staker,uint256 lootsAmount);
690     event StakePets(address indexed staker,uint256 numberOfPetIds);
691     event Unstake721(address indexed staker,address contractAddress,uint256 tokensAmount);
692     event UnstakePets(address indexed staker,uint256 numberOfPetIds);
693     event ForceWithdraw721(address indexed receiver, address indexed tokenAddress, uint256 indexed tokenId);
694     
695 
696     constructor(address _ape) {
697         ApeNft = IERC721(_ape);
698         _contractTypes[_ape] = ContractTypes.APE;
699         _baseRates[_ape] = 150 ether;
700     }
701 
702     modifier authorised() {
703       require(_authorised[_msgSender()], "The token contract is not authorised");
704         _;
705     }
706 
707     function stake721(address contractAddress, uint256[] memory tokenIds) public nonReentrant {
708       require(!depositPaused, "Deposit paused");
709       require(stakingLaunched, "Staking is not launched yet");
710       require(contractAddress != address(0) && contractAddress == address(ApeNft) || contractAddress == address(TreasuryNft) || contractAddress == address(BreedingNft), "Unknown contract or staking is not yet enabled for this NFT");
711       ContractTypes contractType = _contractTypes[contractAddress];
712 
713       Staker storage user = _stakers[_msgSender()];
714       uint256 newYield = user.currentYield;
715 
716       for (uint256 i; i < tokenIds.length; i++) {
717         require(IERC721(contractAddress).ownerOf(tokenIds[i]) == _msgSender(), "Not the owner of staking NFT");
718         IERC721(contractAddress).safeTransferFrom(_msgSender(), address(this), tokenIds[i]);
719 
720         _ownerOfToken[contractAddress][tokenIds[i]] = _msgSender();
721 
722         newYield += getTokenYield(contractAddress, tokenIds[i]);
723 
724         if (contractType == ContractTypes.APE) { user.stakedAPE.push(tokenIds[i]); }
725         if (contractType == ContractTypes.BREEDING) { user.stakedBREEDING.push(tokenIds[i]); }
726         if (contractType == ContractTypes.TREASURY) { user.stakedTREASURY.push(tokenIds[i]); }
727       }
728 
729       accumulate(_msgSender());
730       user.currentYield = newYield;
731 
732       emit Stake721(_msgSender(), contractAddress, tokenIds.length);
733     }
734 
735     function stake1155(uint256[] memory tokenIds, uint256[] memory amounts) public nonReentrant {
736       require(!depositPaused, "Deposit paused");
737       require(stakingLaunched, "Staking is not launched yet");
738       require(address(PetNft) != address(0), "Moon Pets staking is not yet enabled");
739 
740       Staker storage user = _stakers[_msgSender()];
741       uint256 newYield = user.currentYield;
742 
743       for (uint256 i; i < tokenIds.length; i++) {
744         require(amounts[i] > 0, "Invalid amount");
745         require(PetNft.balanceOf(_msgSender(), tokenIds[i]) >= amounts[i], "Not the owner of staking Pet or insufficiant balance of staking Pet");
746 
747         newYield += getPetTokenYield(tokenIds[i], amounts[i]);
748         if (stakerPetAmounts[_msgSender()][tokenIds[i]] == 0){
749             user.stakedPET.push(tokenIds[i]);
750         }
751         stakerPetAmounts[_msgSender()][tokenIds[i]] += amounts[i];
752       }
753 
754       PetNft.safeBatchTransferFrom(_msgSender(), address(this), tokenIds, amounts, "");
755 
756       accumulate(_msgSender());
757       user.currentYield = newYield;
758 
759       emit StakePets(_msgSender(), tokenIds.length);
760     }
761 
762     function addLootToStakedApes(uint256[] memory apeIds, uint256[] memory lootIds) public nonReentrant {
763       require(!depositPaused, "Deposit paused");
764       require(stakingLaunched, "Staking is not launched yet");
765       require(apeIds.length == lootIds.length, "Lists not same length");
766       require(address(LootNft) != address(0), "Loot Bags staking is not yet enabled");
767 
768       Staker storage user = _stakers[_msgSender()];
769       uint256 newYield = user.currentYield;
770 
771       for (uint256 i; i < apeIds.length; i++) {
772         require(_ownerOfToken[address(ApeNft)][apeIds[i]] == _msgSender(), "Not the owner of staked Ape");
773         require(stakerApeLoot[_msgSender()][apeIds[i]] == 0, "Selected staked Ape already has Loot staked together");
774         require(lootIds[i] > 0, "Invalid Loot NFT");
775         require(IERC721(address(LootNft)).ownerOf(lootIds[i]) == _msgSender(), "Not the owner of staking Loot");
776         IERC721(address(LootNft)).safeTransferFrom(_msgSender(), address(this), lootIds[i]);
777 
778         _ownerOfToken[address(LootNft)][lootIds[i]] = _msgSender();
779 
780         newYield += getApeLootTokenYield(apeIds[i], lootIds[i]) - getTokenYield(address(ApeNft), apeIds[i]);
781 
782         stakerApeLoot[_msgSender()][apeIds[i]] = lootIds[i];
783       }
784 
785       accumulate(_msgSender());
786       user.currentYield = newYield;
787 
788       emit AddLootToStakedApes(_msgSender(), apeIds.length);
789     }
790 
791     function removeLootFromStakedApes(uint256[] memory apeIds) public nonReentrant{
792        Staker storage user = _stakers[_msgSender()];
793        uint256 newYield = user.currentYield;
794 
795        for (uint256 i; i < apeIds.length; i++) {
796         require(_ownerOfToken[address(ApeNft)][apeIds[i]] == _msgSender(), "Not the owner of staked Ape");
797         uint256 ape_loot = stakerApeLoot[_msgSender()][apeIds[i]];
798         require(ape_loot > 0, "Selected staked Ape does not have any Loot staked with");
799         require(_ownerOfToken[address(LootNft)][ape_loot] == _msgSender(), "Not the owner of staked Ape");
800         IERC721(address(LootNft)).safeTransferFrom(address(this), _msgSender(), ape_loot);
801 
802         _ownerOfToken[address(LootNft)][ape_loot] = address(0);
803 
804         newYield -= getApeLootTokenYield(apeIds[i], ape_loot);
805         newYield += getTokenYield(address(ApeNft), apeIds[i]);
806 
807         stakerApeLoot[_msgSender()][apeIds[i]] = 0;
808       }
809 
810       accumulate(_msgSender());
811       user.currentYield = newYield;
812 
813       emit RemoveLootFromStakedApes(_msgSender(), apeIds.length);
814     }
815 
816     function stakeApesWithLoots(uint256[] memory apeIds, uint256[] memory lootIds) public nonReentrant {
817       require(!depositPaused, "Deposit paused");
818       require(stakingLaunched, "Staking is not launched yet");
819       require(apeIds.length == lootIds.length, "Lists not same length");
820       require(address(LootNft) != address(0), "Loot Bags staking is not yet enabled");
821 
822       Staker storage user = _stakers[_msgSender()];
823       uint256 newYield = user.currentYield;
824 
825       for (uint256 i; i < apeIds.length; i++) {
826         require(IERC721(address(ApeNft)).ownerOf(apeIds[i]) == _msgSender(), "Not the owner of staking Ape");
827         if (lootIds[i] > 0){
828           require(IERC721(address(LootNft)).ownerOf(lootIds[i]) == _msgSender(), "Not the owner of staking Loot");
829           IERC721(address(LootNft)).safeTransferFrom(_msgSender(), address(this), lootIds[i]);
830           _ownerOfToken[address(LootNft)][lootIds[i]] = _msgSender();
831           stakerApeLoot[_msgSender()][apeIds[i]] = lootIds[i];
832         }
833         
834         IERC721(address(ApeNft)).safeTransferFrom(_msgSender(), address(this), apeIds[i]);
835         _ownerOfToken[address(ApeNft)][apeIds[i]] = _msgSender();
836         
837         newYield += getApeLootTokenYield(apeIds[i], lootIds[i]);
838         user.stakedAPE.push(apeIds[i]);
839       }
840 
841       accumulate(_msgSender());
842       user.currentYield = newYield;
843 
844       emit StakeApesWithLoots(_msgSender(), apeIds.length);
845     }
846 
847     function unstake721(address contractAddress, uint256[] memory tokenIds) public nonReentrant {
848       require(contractAddress != address(0) && contractAddress == address(ApeNft) || contractAddress == address(TreasuryNft) || contractAddress == address(BreedingNft), "Unknown contract or staking is not yet enabled for this NFT");
849       ContractTypes contractType = _contractTypes[contractAddress];
850       Staker storage user = _stakers[_msgSender()];
851       uint256 newYield = user.currentYield;
852 
853       for (uint256 i; i < tokenIds.length; i++) {
854         require(IERC721(contractAddress).ownerOf(tokenIds[i]) == address(this), "Not the owner");
855 
856         _ownerOfToken[contractAddress][tokenIds[i]] = address(0);
857 
858         if (user.currentYield != 0) {
859             if (contractType == ContractTypes.APE){
860                 uint256 ape_loot = stakerApeLoot[_msgSender()][tokenIds[i]];
861                 uint256 tokenYield = getApeLootTokenYield(tokenIds[i], ape_loot);
862                 newYield -= tokenYield;
863                 if (ape_loot > 0){
864                   IERC721(address(LootNft)).safeTransferFrom(address(this), _msgSender(), ape_loot);
865                   _ownerOfToken[address(LootNft)][ape_loot] = address(0);
866                 }
867                 
868             } else {
869                 uint256 tokenYield = getTokenYield(contractAddress, tokenIds[i]);
870                 newYield -= tokenYield;
871             }
872         }
873 
874         if (contractType == ContractTypes.APE) {
875           user.stakedAPE = _prepareForDeletion(user.stakedAPE, tokenIds[i]);
876           user.stakedAPE.pop();
877           stakerApeLoot[_msgSender()][tokenIds[i]] = 0;
878         }
879         if (contractType == ContractTypes.TREASURY) {
880           user.stakedTREASURY = _prepareForDeletion(user.stakedTREASURY, tokenIds[i]);
881           user.stakedTREASURY.pop();
882         }
883         if (contractType == ContractTypes.BREEDING) {
884           user.stakedBREEDING = _prepareForDeletion(user.stakedBREEDING, tokenIds[i]);
885           user.stakedBREEDING.pop();
886         }
887 
888         IERC721(contractAddress).safeTransferFrom(address(this), _msgSender(), tokenIds[i]);
889       }
890 
891       if (user.stakedAPE.length == 0 && user.stakedTREASURY.length == 0 && user.stakedPET.length == 0 && user.stakedBREEDING.length == 0) {
892         newYield = 0;
893       }
894 
895       accumulate(_msgSender());
896       user.currentYield = newYield;
897 
898       emit Unstake721(_msgSender(), contractAddress, tokenIds.length);
899     }
900 
901     function unstake1155(uint256[] memory tokenIds) public nonReentrant {
902       Staker storage user = _stakers[_msgSender()];
903       uint256 newYield = user.currentYield;
904       uint256[] memory transferAmounts = new uint256[](tokenIds.length);
905 
906       for (uint256 i; i < tokenIds.length; i++) {
907         require(stakerPetAmounts[_msgSender()][tokenIds[i]] > 0, "Not the owner of staked Pet");
908         transferAmounts[i] = stakerPetAmounts[_msgSender()][tokenIds[i]];
909 
910         newYield -= getPetTokenYield(tokenIds[i], transferAmounts[i]);
911 
912         user.stakedPET = _prepareForDeletion(user.stakedPET, tokenIds[i]);
913         user.stakedPET.pop();
914         stakerPetAmounts[_msgSender()][tokenIds[i]] = 0;
915       }
916 
917       if (user.stakedAPE.length == 0 && user.stakedTREASURY.length == 0 && user.stakedPET.length == 0 && user.stakedBREEDING.length == 0) {
918         newYield = 0;
919       }
920       PetNft.safeBatchTransferFrom(address(this), _msgSender(), tokenIds, transferAmounts, "");
921 
922       accumulate(_msgSender());
923       user.currentYield = newYield;
924 
925       emit UnstakePets(_msgSender(), tokenIds.length);
926     }
927 
928     function getTokenYield(address contractAddress, uint256 tokenId) public view returns (uint256) {
929       uint256 tokenYield = _individualRates[contractAddress][tokenId];
930       if (tokenYield == 0) { tokenYield = _baseRates[contractAddress]; }
931 
932       return tokenYield;
933     }
934 
935     function getApeLootTokenYield(uint256 apeId, uint256 lootId) public view returns (uint256){
936         uint256 apeYield = _individualRates[address(ApeNft)][apeId];
937         if (apeYield == 0) { apeYield = _baseRates[address(ApeNft)]; }
938 
939         uint256 lootBoost = _individualRates[address(LootNft)][lootId];
940         if (lootId == 0){
941             lootBoost = 10;
942         } else {
943             if (lootBoost == 0) { lootBoost = _baseRates[address(LootNft)]; }
944         }
945         
946         return apeYield * lootBoost / 10;
947     }
948 
949     function getPetTokenYield(uint256 petId, uint256 amount) public view returns(uint256){
950         uint256 petYield = _individualRates[address(PetNft)][petId];
951         if (petYield == 0) { petYield = _baseRates[address(PetNft)]; }
952         return petYield * amount;
953     }
954 
955     function getStakerYield(address staker) public view returns (uint256) {
956       return _stakers[staker].currentYield;
957     }
958 
959     function getStakerNFT(address staker) public view returns (uint256[] memory, uint256[] memory, uint256[] memory, uint256[] memory, uint256[] memory) {
960         uint256[] memory lootIds = new uint256[](_stakers[staker].stakedAPE.length);
961         uint256[] memory petAmounts = new uint256[](8);
962         for (uint256 i; i < _stakers[staker].stakedAPE.length; i++){
963             lootIds[i] = stakerApeLoot[staker][_stakers[staker].stakedAPE[i]];
964         }
965         for (uint256 i; i < 8; i++){
966             petAmounts[i] = stakerPetAmounts[staker][i];
967         }
968       return (_stakers[staker].stakedAPE, lootIds, _stakers[staker].stakedTREASURY, petAmounts, _stakers[staker].stakedBREEDING);
969     }
970 
971     function _prepareForDeletion(uint256[] memory list, uint256 tokenId) internal pure returns (uint256[] memory) {
972       uint256 tokenIndex = 0;
973       uint256 lastTokenIndex = list.length - 1;
974       uint256 length = list.length;
975 
976       for(uint256 i = 0; i < length; i++) {
977         if (list[i] == tokenId) {
978           tokenIndex = i + 1;
979           break;
980         }
981       }
982       require(tokenIndex != 0, "Not the owner or duplicate NFT in list");
983 
984       tokenIndex -= 1;
985 
986       if (tokenIndex != lastTokenIndex) {
987         list[tokenIndex] = list[lastTokenIndex];
988         list[lastTokenIndex] = tokenId;
989       }
990 
991       return list;
992     }
993 
994     function getCurrentReward(address staker) public view returns (uint256) {
995       Staker memory user = _stakers[staker];
996       if (user.lastCheckpoint == 0) { return 0; }
997       return (block.timestamp - user.lastCheckpoint) * user.currentYield / SECONDS_IN_DAY;
998     }
999 
1000     function getAccumulatedAmount(address staker) external view returns (uint256) {
1001       return _stakers[staker].accumulatedAmount + getCurrentReward(staker);
1002     }
1003 
1004     function accumulate(address staker) internal {
1005       _stakers[staker].accumulatedAmount += getCurrentReward(staker);
1006       _stakers[staker].lastCheckpoint = block.timestamp;
1007     }
1008 
1009     /**
1010     * CONTRACTS
1011     */
1012     function ownerOf(address contractAddress, uint256 tokenId) public view returns (address) {
1013       return _ownerOfToken[contractAddress][tokenId];
1014     }
1015 
1016     function balanceOf(address user) public view returns (uint256){
1017       return _stakers[user].stakedAPE.length;
1018     }
1019 
1020     function setTREASURYContract(address _treasury, uint256 _baseReward) public onlyOwner {
1021       TreasuryNft = IERC721(_treasury);
1022       _contractTypes[_treasury] = ContractTypes.TREASURY;
1023       _baseRates[_treasury] = _baseReward;
1024     }
1025 
1026     function setPETContract(address _pet, uint256 _baseReward) public onlyOwner {
1027       PetNft = IERC1155(_pet);
1028       _contractTypes[_pet] = ContractTypes.PET;
1029       _baseRates[_pet] = _baseReward;
1030     }
1031 
1032     function setLOOTContract(address _loot, uint256 _baseBoost) public onlyOwner {
1033       LootNft = IERC721(_loot);
1034       _contractTypes[_loot] = ContractTypes.LOOT;
1035       _baseRates[_loot] = _baseBoost;
1036     }
1037 
1038     function setBREEDING(address _breeding, uint256 _baseReward) public onlyOwner{
1039       BreedingNft = IERC721(_breeding);
1040       _contractTypes[_breeding] = ContractTypes.BREEDING;
1041       _baseRates[_breeding] = _baseReward;
1042     }
1043 
1044     /**
1045     * ADMIN
1046     */
1047     function authorise(address toAuth) public onlyOwner {
1048       _authorised[toAuth] = true;
1049       authorisedLog.push(toAuth);
1050     }
1051 
1052     function unauthorise(address addressToUnAuth) public onlyOwner {
1053       _authorised[addressToUnAuth] = false;
1054     }
1055 
1056     function forceWithdraw721(address tokenAddress, uint256[] memory tokenIds) public onlyOwner {
1057       require(tokenIds.length <= 50, "50 is max per tx");
1058       pauseDeposit(true);
1059       for (uint256 i; i < tokenIds.length; i++) {
1060         address receiver = _ownerOfToken[tokenAddress][tokenIds[i]];
1061         if (receiver != address(0) && IERC721(tokenAddress).ownerOf(tokenIds[i]) == address(this)) {
1062           IERC721(tokenAddress).transferFrom(address(this), receiver, tokenIds[i]);
1063           emit ForceWithdraw721(receiver, tokenAddress, tokenIds[i]);
1064         }
1065       }
1066     }
1067 
1068     function pauseDeposit(bool _pause) public onlyOwner {
1069       depositPaused = _pause;
1070     }
1071 
1072     function launchStaking() public onlyOwner {
1073       require(!stakingLaunched, "Staking has been launched already");
1074       stakingLaunched = true;
1075     }
1076 
1077     function updateBaseYield(address _contract, uint256 _yield) public onlyOwner {
1078       _baseRates[_contract] = _yield;
1079     }
1080 
1081     function setIndividualRates(address contractAddress, uint256[] memory tokenIds, uint256[] memory rates) public onlyOwner{
1082         require(contractAddress != address(0) && contractAddress == address(ApeNft) || contractAddress == address(LootNft) || contractAddress == address(TreasuryNft) || contractAddress == address(PetNft), "Unknown contract");
1083         require(tokenIds.length == rates.length, "Lists not same length");
1084         for (uint256 i; i < tokenIds.length; i++){
1085             _individualRates[contractAddress][tokenIds[i]] = rates[i];
1086         }
1087     }
1088 
1089     function onERC721Received(address, address, uint256, bytes calldata) external pure returns(bytes4){
1090       return bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"));
1091     }
1092 
1093     function withdrawETH() external onlyOwner {
1094       payable(owner()).transfer(address(this).balance);
1095     }
1096 }