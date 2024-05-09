1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
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
31 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
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
61      * @dev Returns the address of the current owner.
62      */
63     function owner() public view virtual returns (address) {
64         return _owner;
65     }
66 
67     /**
68      * @dev Throws if called by any account other than the owner.
69      */
70     modifier onlyOwner() {
71         require(owner() == _msgSender(), "Ownable: caller is not the owner");
72         _;
73     }
74 
75     /**
76      * @dev Leaves the contract without owner. It will not be possible to call
77      * `onlyOwner` functions anymore. Can only be called by the current owner.
78      *
79      * NOTE: Renouncing ownership will leave the contract without an owner,
80      * thereby removing any functionality that is only available to the owner.
81      */
82     function renounceOwnership() public virtual onlyOwner {
83         _transferOwnership(address(0));
84     }
85 
86     /**
87      * @dev Transfers ownership of the contract to a new account (`newOwner`).
88      * Can only be called by the current owner.
89      */
90     function transferOwnership(address newOwner) public virtual onlyOwner {
91         require(newOwner != address(0), "Ownable: new owner is the zero address");
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
106 // File: @openzeppelin/contracts/security/Pausable.sol
107 
108 
109 // OpenZeppelin Contracts v4.4.0 (security/Pausable.sol)
110 
111 pragma solidity ^0.8.0;
112 
113 
114 /**
115  * @dev Contract module which allows children to implement an emergency stop
116  * mechanism that can be triggered by an authorized account.
117  *
118  * This module is used through inheritance. It will make available the
119  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
120  * the functions of your contract. Note that they will not be pausable by
121  * simply including this module, only once the modifiers are put in place.
122  */
123 abstract contract Pausable is Context {
124     /**
125      * @dev Emitted when the pause is triggered by `account`.
126      */
127     event Paused(address account);
128 
129     /**
130      * @dev Emitted when the pause is lifted by `account`.
131      */
132     event Unpaused(address account);
133 
134     bool private _paused;
135 
136     /**
137      * @dev Initializes the contract in unpaused state.
138      */
139     constructor() {
140         _paused = false;
141     }
142 
143     /**
144      * @dev Returns true if the contract is paused, and false otherwise.
145      */
146     function paused() public view virtual returns (bool) {
147         return _paused;
148     }
149 
150     /**
151      * @dev Modifier to make a function callable only when the contract is not paused.
152      *
153      * Requirements:
154      *
155      * - The contract must not be paused.
156      */
157     modifier whenNotPaused() {
158         require(!paused(), "Pausable: paused");
159         _;
160     }
161 
162     /**
163      * @dev Modifier to make a function callable only when the contract is paused.
164      *
165      * Requirements:
166      *
167      * - The contract must be paused.
168      */
169     modifier whenPaused() {
170         require(paused(), "Pausable: not paused");
171         _;
172     }
173 
174     /**
175      * @dev Triggers stopped state.
176      *
177      * Requirements:
178      *
179      * - The contract must not be paused.
180      */
181     function _pause() internal virtual whenNotPaused {
182         _paused = true;
183         emit Paused(_msgSender());
184     }
185 
186     /**
187      * @dev Returns to normal state.
188      *
189      * Requirements:
190      *
191      * - The contract must be paused.
192      */
193     function _unpause() internal virtual whenPaused {
194         _paused = false;
195         emit Unpaused(_msgSender());
196     }
197 }
198 
199 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
200 
201 
202 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
203 
204 pragma solidity ^0.8.0;
205 
206 /**
207  * @dev Interface of the ERC20 standard as defined in the EIP.
208  */
209 interface IERC20 {
210     /**
211      * @dev Returns the amount of tokens in existence.
212      */
213     function totalSupply() external view returns (uint256);
214 
215     /**
216      * @dev Returns the amount of tokens owned by `account`.
217      */
218     function balanceOf(address account) external view returns (uint256);
219 
220     /**
221      * @dev Moves `amount` tokens from the caller's account to `recipient`.
222      *
223      * Returns a boolean value indicating whether the operation succeeded.
224      *
225      * Emits a {Transfer} event.
226      */
227     function transfer(address recipient, uint256 amount) external returns (bool);
228 
229     /**
230      * @dev Returns the remaining number of tokens that `spender` will be
231      * allowed to spend on behalf of `owner` through {transferFrom}. This is
232      * zero by default.
233      *
234      * This value changes when {approve} or {transferFrom} are called.
235      */
236     function allowance(address owner, address spender) external view returns (uint256);
237 
238     /**
239      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
240      *
241      * Returns a boolean value indicating whether the operation succeeded.
242      *
243      * IMPORTANT: Beware that changing an allowance with this method brings the risk
244      * that someone may use both the old and the new allowance by unfortunate
245      * transaction ordering. One possible solution to mitigate this race
246      * condition is to first reduce the spender's allowance to 0 and set the
247      * desired value afterwards:
248      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
249      *
250      * Emits an {Approval} event.
251      */
252     function approve(address spender, uint256 amount) external returns (bool);
253 
254     /**
255      * @dev Moves `amount` tokens from `sender` to `recipient` using the
256      * allowance mechanism. `amount` is then deducted from the caller's
257      * allowance.
258      *
259      * Returns a boolean value indicating whether the operation succeeded.
260      *
261      * Emits a {Transfer} event.
262      */
263     function transferFrom(
264         address sender,
265         address recipient,
266         uint256 amount
267     ) external returns (bool);
268 
269     /**
270      * @dev Emitted when `value` tokens are moved from one account (`from`) to
271      * another (`to`).
272      *
273      * Note that `value` may be zero.
274      */
275     event Transfer(address indexed from, address indexed to, uint256 value);
276 
277     /**
278      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
279      * a call to {approve}. `value` is the new allowance.
280      */
281     event Approval(address indexed owner, address indexed spender, uint256 value);
282 }
283 
284 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
285 
286 
287 // OpenZeppelin Contracts v4.4.0 (utils/introspection/IERC165.sol)
288 
289 pragma solidity ^0.8.0;
290 
291 /**
292  * @dev Interface of the ERC165 standard, as defined in the
293  * https://eips.ethereum.org/EIPS/eip-165[EIP].
294  *
295  * Implementers can declare support of contract interfaces, which can then be
296  * queried by others ({ERC165Checker}).
297  *
298  * For an implementation, see {ERC165}.
299  */
300 interface IERC165 {
301     /**
302      * @dev Returns true if this contract implements the interface defined by
303      * `interfaceId`. See the corresponding
304      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
305      * to learn more about how these ids are created.
306      *
307      * This function call must use less than 30 000 gas.
308      */
309     function supportsInterface(bytes4 interfaceId) external view returns (bool);
310 }
311 
312 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
313 
314 
315 // OpenZeppelin Contracts v4.4.0 (token/ERC1155/IERC1155.sol)
316 
317 pragma solidity ^0.8.0;
318 
319 
320 /**
321  * @dev Required interface of an ERC1155 compliant contract, as defined in the
322  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
323  *
324  * _Available since v3.1._
325  */
326 interface IERC1155 is IERC165 {
327     /**
328      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
329      */
330     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
331 
332     /**
333      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
334      * transfers.
335      */
336     event TransferBatch(
337         address indexed operator,
338         address indexed from,
339         address indexed to,
340         uint256[] ids,
341         uint256[] values
342     );
343 
344     /**
345      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
346      * `approved`.
347      */
348     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
349 
350     /**
351      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
352      *
353      * If an {URI} event was emitted for `id`, the standard
354      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
355      * returned by {IERC1155MetadataURI-uri}.
356      */
357     event URI(string value, uint256 indexed id);
358 
359     /**
360      * @dev Returns the amount of tokens of token type `id` owned by `account`.
361      *
362      * Requirements:
363      *
364      * - `account` cannot be the zero address.
365      */
366     function balanceOf(address account, uint256 id) external view returns (uint256);
367 
368     /**
369      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
370      *
371      * Requirements:
372      *
373      * - `accounts` and `ids` must have the same length.
374      */
375     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
376         external
377         view
378         returns (uint256[] memory);
379 
380     /**
381      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
382      *
383      * Emits an {ApprovalForAll} event.
384      *
385      * Requirements:
386      *
387      * - `operator` cannot be the caller.
388      */
389     function setApprovalForAll(address operator, bool approved) external;
390 
391     /**
392      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
393      *
394      * See {setApprovalForAll}.
395      */
396     function isApprovedForAll(address account, address operator) external view returns (bool);
397 
398     /**
399      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
400      *
401      * Emits a {TransferSingle} event.
402      *
403      * Requirements:
404      *
405      * - `to` cannot be the zero address.
406      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
407      * - `from` must have a balance of tokens of type `id` of at least `amount`.
408      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
409      * acceptance magic value.
410      */
411     function safeTransferFrom(
412         address from,
413         address to,
414         uint256 id,
415         uint256 amount,
416         bytes calldata data
417     ) external;
418 
419     /**
420      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
421      *
422      * Emits a {TransferBatch} event.
423      *
424      * Requirements:
425      *
426      * - `ids` and `amounts` must have the same length.
427      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
428      * acceptance magic value.
429      */
430     function safeBatchTransferFrom(
431         address from,
432         address to,
433         uint256[] calldata ids,
434         uint256[] calldata amounts,
435         bytes calldata data
436     ) external;
437 }
438 
439 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
440 
441 
442 // OpenZeppelin Contracts v4.4.0 (utils/introspection/ERC165.sol)
443 
444 pragma solidity ^0.8.0;
445 
446 
447 /**
448  * @dev Implementation of the {IERC165} interface.
449  *
450  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
451  * for the additional interface id that will be supported. For example:
452  *
453  * ```solidity
454  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
455  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
456  * }
457  * ```
458  *
459  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
460  */
461 abstract contract ERC165 is IERC165 {
462     /**
463      * @dev See {IERC165-supportsInterface}.
464      */
465     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
466         return interfaceId == type(IERC165).interfaceId;
467     }
468 }
469 
470 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
471 
472 
473 // OpenZeppelin Contracts v4.4.0 (token/ERC1155/IERC1155Receiver.sol)
474 
475 pragma solidity ^0.8.0;
476 
477 
478 /**
479  * @dev _Available since v3.1._
480  */
481 interface IERC1155Receiver is IERC165 {
482     /**
483         @dev Handles the receipt of a single ERC1155 token type. This function is
484         called at the end of a `safeTransferFrom` after the balance has been updated.
485         To accept the transfer, this must return
486         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
487         (i.e. 0xf23a6e61, or its own function selector).
488         @param operator The address which initiated the transfer (i.e. msg.sender)
489         @param from The address which previously owned the token
490         @param id The ID of the token being transferred
491         @param value The amount of tokens being transferred
492         @param data Additional data with no specified format
493         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
494     */
495     function onERC1155Received(
496         address operator,
497         address from,
498         uint256 id,
499         uint256 value,
500         bytes calldata data
501     ) external returns (bytes4);
502 
503     /**
504         @dev Handles the receipt of a multiple ERC1155 token types. This function
505         is called at the end of a `safeBatchTransferFrom` after the balances have
506         been updated. To accept the transfer(s), this must return
507         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
508         (i.e. 0xbc197c81, or its own function selector).
509         @param operator The address which initiated the batch transfer (i.e. msg.sender)
510         @param from The address which previously owned the token
511         @param ids An array containing ids of each token being transferred (order and length must match values array)
512         @param values An array containing amounts of each token being transferred (order and length must match ids array)
513         @param data Additional data with no specified format
514         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
515     */
516     function onERC1155BatchReceived(
517         address operator,
518         address from,
519         uint256[] calldata ids,
520         uint256[] calldata values,
521         bytes calldata data
522     ) external returns (bytes4);
523 }
524 
525 // File: @openzeppelin/contracts/token/ERC1155/utils/ERC1155Receiver.sol
526 
527 
528 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/utils/ERC1155Receiver.sol)
529 
530 pragma solidity ^0.8.0;
531 
532 
533 
534 /**
535  * @dev _Available since v3.1._
536  */
537 abstract contract ERC1155Receiver is ERC165, IERC1155Receiver {
538     /**
539      * @dev See {IERC165-supportsInterface}.
540      */
541     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
542         return interfaceId == type(IERC1155Receiver).interfaceId || super.supportsInterface(interfaceId);
543     }
544 }
545 
546 // File: @openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol
547 
548 
549 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/utils/ERC1155Holder.sol)
550 
551 pragma solidity ^0.8.0;
552 
553 
554 /**
555  * @dev _Available since v3.1._
556  */
557 contract ERC1155Holder is ERC1155Receiver {
558     function onERC1155Received(
559         address,
560         address,
561         uint256,
562         uint256,
563         bytes memory
564     ) public virtual override returns (bytes4) {
565         return this.onERC1155Received.selector;
566     }
567 
568     function onERC1155BatchReceived(
569         address,
570         address,
571         uint256[] memory,
572         uint256[] memory,
573         bytes memory
574     ) public virtual override returns (bytes4) {
575         return this.onERC1155BatchReceived.selector;
576     }
577 }
578 
579 // File: contracts/Updated HeartbreakBearsNFTStaking.sol
580 
581 pragma solidity ^0.8.2;
582 
583 
584 
585 
586 
587 
588 // import "hardhat/console.sol";
589 
590 // ONE ISSUE ----> CHANGING MINTING AWARD
591 contract HeartbreakBearsNFTStaking is ERC1155Holder, Pausable, Ownable {
592     IERC1155 private NFT;
593     IERC20 private TOKEN;
594 
595     struct NftBundle {
596         uint256[] tokenIds;
597         uint256[] timestamps;
598         uint256[] percentageBoost;
599         bool isStaking;
600     }
601 
602     mapping(address => NftBundle) private stakers;
603     address[] private stakerList;
604     uint256 public rate = 11574074074074;
605     uint256 endTimestamp;
606     bool hasEnded;
607 
608     constructor(address _nftAddress, address _tokenAddress) {
609         NFT = IERC1155(_nftAddress);
610         TOKEN = IERC20(_tokenAddress);
611     }
612 
613     function percentageOf(uint256 pct, uint256 _number)
614         public
615         pure
616         returns (uint256)
617     {
618         require(_number >= 10000, "Number is too small for calculation");
619         uint256 bp = pct * 100;
620         return (_number * bp) / 10000;
621     }
622 
623     function endStaking() public onlyOwner {
624         hasEnded = true;
625         endTimestamp = block.timestamp;
626     }
627 
628     function stakeIds(address _staker) public view returns (uint256[] memory) {
629         return stakers[_staker].tokenIds;
630     }
631 
632     function bonusRewards(address _staker)
633         public
634         view
635         returns (uint256[] memory)
636     {
637         return stakers[_staker].percentageBoost;
638     }
639 
640     function stakeTimestamps(address _staker)
641         public
642         view
643         returns (uint256[] memory)
644     {
645         return stakers[_staker].timestamps;
646     }
647 
648     function allowance() public view returns (uint256) {
649         return TOKEN.balanceOf(address(this));
650     }
651 
652     function stakeDuration(address _staker) public view returns (uint256) {
653         uint256 startTime = stakers[_staker].timestamps[0];
654         if (startTime > 0) {
655             return block.timestamp - startTime;
656         } else {
657             return 0;
658         }
659     }
660 
661     function tokensAwarded(address _staker) public view returns (uint256) {
662         NftBundle memory staker = stakers[_staker];
663         uint256 totalReward;
664         uint256 endTime;
665 
666         if (hasEnded) {
667             endTime = endTimestamp;
668         } else {
669             endTime = block.timestamp;
670         }
671 
672         for (uint256 i = 0; i < staker.tokenIds.length; i++) {
673             uint256 _rate = rate +
674                 percentageOf(staker.percentageBoost[i], rate);
675             totalReward += (_rate * (endTime - staker.timestamps[i]));
676         }
677 
678         return totalReward;
679     }
680 
681     function tokensRemaining() public view returns (uint256) {
682         uint256 tokensSpent;
683         for (uint256 i = 0; i < stakerList.length; i++) {
684             tokensSpent += tokensAwarded(stakerList[i]);
685         }
686         return allowance() - tokensSpent;
687     }
688 
689     function tokensAwardedForNFT(address _staker, uint256 tokenId)
690         public
691         view
692         returns (uint256)
693     {
694         NftBundle memory staker = stakers[_staker];
695         uint256 endTime;
696 
697         if (hasEnded) {
698             endTime = endTimestamp;
699         } else {
700             endTime = block.timestamp;
701         }
702 
703         for (uint256 i = 0; i < staker.tokenIds.length; i++) {
704             if (staker.tokenIds[i] == tokenId) {
705                 uint256 _rate = rate +
706                     percentageOf(staker.percentageBoost[i], rate);
707                 return (_rate * (endTime - staker.timestamps[i]));
708             }
709         }
710 
711         return 0;
712     }
713 
714     function stakeBatch(uint256[] memory _tokenIds) public whenNotPaused {
715         require(_tokenIds.length > 0, "Must stake at least 1 NFT");
716         require(hasEnded == false, "Staking has ended");
717         require(allowance() > 10 ether, "No more rewards left for staking");
718 
719         if (!stakers[msg.sender].isStaking) {
720             stakerList.push(msg.sender);
721         }
722 
723         uint256[] memory _values = new uint256[](_tokenIds.length);
724         for (uint256 i = 0; i < _tokenIds.length; i++) {
725             _values[i] = 1;
726             // _timestamps[i] = block.timestamp;
727             stakers[msg.sender].tokenIds.push(_tokenIds[i]);
728             stakers[msg.sender].timestamps.push(block.timestamp);
729 
730             uint256 pctBoost = 0;
731             uint256 id = _tokenIds[i];
732             if (id >= 1 && id <= 1888) {
733                 pctBoost += 3; // Add 3%
734             }
735             if (
736                 id == 1 ||
737                 id == 5 ||
738                 id == 9 ||
739                 id == 13 ||
740                 id == 17 ||
741                 id == 23 ||
742                 id == 24 ||
743                 id == 25 ||
744                 id == 26 ||
745                 id == 71 ||
746                 id == 532 ||
747                 id == 777 ||
748                 id == 1144 ||
749                 id == 1707 ||
750                 id == 1482 ||
751                 id == 3888
752             ) {
753                 pctBoost += 5; // Add 5%
754             }
755             if (_tokenIds.length == 2) {
756                 pctBoost += 1; // Add 1%
757             } else if (_tokenIds.length >= 3) {
758                 pctBoost += 2; // Add 2%
759             }
760             stakers[msg.sender].percentageBoost.push(pctBoost);
761         }
762 
763         stakers[msg.sender].isStaking = true;
764 
765         NFT.safeBatchTransferFrom(
766             msg.sender,
767             address(this),
768             _tokenIds,
769             _values,
770             ""
771         );
772     }
773 
774     function claimTokens() public whenNotPaused {
775         
776         uint256 reward = tokensAwarded(msg.sender);
777         require(reward > 0, "No rewards available");
778         require(reward <= allowance(), "Reward exceeds tokens available");
779         uint256[] memory _tokenIds = stakeIds(msg.sender);
780 
781         for (uint256 i = 0; i < _tokenIds.length; i++) {
782             stakers[msg.sender].timestamps[i] = block.timestamp;
783         }
784 
785         TOKEN.transfer(msg.sender, reward);
786 
787     }
788 
789     function withdraw() public whenNotPaused {
790         uint256 reward = tokensAwarded(msg.sender);
791         require(reward > 0, "No rewards available");
792         require(reward <= allowance(), "Reward exceeds tokens available");
793         uint256[] memory _tokenIds = stakeIds(msg.sender);
794         uint256[] memory _values = new uint256[](_tokenIds.length);
795         for (uint256 i = 0; i < _tokenIds.length; i++) {
796             _values[i] = 1;
797         }
798         delete stakers[msg.sender];
799         TOKEN.transfer(msg.sender, reward);
800         NFT.safeBatchTransferFrom(
801             address(this),
802             msg.sender,
803             _tokenIds,
804             _values,
805             ""
806         );
807     }
808 
809     function withdrawSelected(uint256[] memory _tokenIds) public whenNotPaused {
810         uint256 reward;
811 
812         uint256[] memory _values = new uint256[](_tokenIds.length);
813         for (uint256 i = 0; i < _tokenIds.length; i++) {
814             _values[i] = 1;
815             reward += tokensAwardedForNFT(msg.sender, _tokenIds[i]);
816 
817             uint256 index = getIndexOf(
818                 _tokenIds[i],
819                 stakers[msg.sender].tokenIds
820             );
821 
822             remove(index, stakers[msg.sender].tokenIds);
823             remove(index, stakers[msg.sender].timestamps);
824             remove(index, stakers[msg.sender].percentageBoost);
825         }
826 
827         require(reward > 0, "No rewards available");
828         require(reward <= allowance(), "Reward exceeds tokens available");
829 
830         if (stakers[msg.sender].tokenIds.length == 0) {
831             delete stakers[msg.sender];
832         }
833 
834         TOKEN.transfer(msg.sender, reward);
835         NFT.safeBatchTransferFrom(
836             address(this),
837             msg.sender,
838             _tokenIds,
839             _values,
840             ""
841         );
842     }
843 
844     // uint[] array = [1,2,3,4,5];
845     function remove(uint256 index, uint256[] storage array) internal {
846         if (index >= array.length) return;
847 
848         for (uint256 i = index; i < array.length - 1; i++) {
849             array[i] = array[i + 1];
850         }
851         array.pop();
852     }
853 
854     function getIndexOf(uint256 item, uint256[] memory array)
855         public
856         pure
857         returns (uint256)
858     {
859         for (uint256 i = 0; i < array.length; i++) {
860             if (array[i] == item) {
861                 return i;
862             }
863         }
864         revert("Token not found");
865     }
866 
867     function sweep() public onlyOwner {
868         TOKEN.transfer(msg.sender, TOKEN.balanceOf(address(this)));
869     }
870 }
871 
872 // 1 - 1888 Additional benefit // x 1.5
873 // If stake two bears together you get another additional benefit of 10%
874 // If stake three bears you get 20% <----- BATCH STAKING
875 // 1/1 Bears - 15 special bears - x 2
876 //
877 // Take into account for the final token available
878 // Each NFT holder
879 // Function to change base rate
880 
881 // Problem 1: There is no way to prevent a possible over promising of tokens when we have a stable rate.
882 // Unless we set a timeframe.