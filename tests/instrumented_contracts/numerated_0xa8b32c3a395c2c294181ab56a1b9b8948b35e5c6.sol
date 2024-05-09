1 // SPDX-License-Identifier: MIT
2 //
3 // Developed by https://1block.one
4 //
5 
6 
7 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
8 
9 
10 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
11 
12 pragma solidity ^0.8.0;
13 
14 /**
15  * @dev Contract module that helps prevent reentrant calls to a function.
16  *
17  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
18  * available, which can be applied to functions to make sure there are no nested
19  * (reentrant) calls to them.
20  *
21  * Note that because there is a single `nonReentrant` guard, functions marked as
22  * `nonReentrant` may not call one another. This can be worked around by making
23  * those functions `private`, and then adding `external` `nonReentrant` entry
24  * points to them.
25  *
26  * TIP: If you would like to learn more about reentrancy and alternative ways
27  * to protect against it, check out our blog post
28  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
29  */
30 abstract contract ReentrancyGuard {
31     // Booleans are more expensive than uint256 or any type that takes up a full
32     // word because each write operation emits an extra SLOAD to first read the
33     // slot's contents, replace the bits taken up by the boolean, and then write
34     // back. This is the compiler's defense against contract upgrades and
35     // pointer aliasing, and it cannot be disabled.
36 
37     // The values being non-zero value makes deployment a bit more expensive,
38     // but in exchange the refund on every call to nonReentrant will be lower in
39     // amount. Since refunds are capped to a percentage of the total
40     // transaction's gas, it is best to keep them low in cases like this one, to
41     // increase the likelihood of the full refund coming into effect.
42     uint256 private constant _NOT_ENTERED = 1;
43     uint256 private constant _ENTERED = 2;
44 
45     uint256 private _status;
46 
47     constructor() {
48         _status = _NOT_ENTERED;
49     }
50 
51     /**
52      * @dev Prevents a contract from calling itself, directly or indirectly.
53      * Calling a `nonReentrant` function from another `nonReentrant`
54      * function is not supported. It is possible to prevent this from happening
55      * by making the `nonReentrant` function external, and making it call a
56      * `private` function that does the actual work.
57      */
58     modifier nonReentrant() {
59         // On the first call to nonReentrant, _notEntered will be true
60         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
61 
62         // Any calls to nonReentrant after this point will fail
63         _status = _ENTERED;
64 
65         _;
66 
67         // By storing the original value once again, a refund is triggered (see
68         // https://eips.ethereum.org/EIPS/eip-2200)
69         _status = _NOT_ENTERED;
70     }
71 }
72 
73 // File: @openzeppelin/contracts/utils/Context.sol
74 
75 
76 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
77 
78 pragma solidity ^0.8.0;
79 
80 /**
81  * @dev Provides information about the current execution context, including the
82  * sender of the transaction and its data. While these are generally available
83  * via msg.sender and msg.data, they should not be accessed in such a direct
84  * manner, since when dealing with meta-transactions the account sending and
85  * paying for execution may not be the actual sender (as far as an application
86  * is concerned).
87  *
88  * This contract is only required for intermediate, library-like contracts.
89  */
90 abstract contract Context {
91     function _msgSender() internal view virtual returns (address) {
92         return msg.sender;
93     }
94 
95     function _msgData() internal view virtual returns (bytes calldata) {
96         return msg.data;
97     }
98 }
99 
100 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
101 
102 
103 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
104 
105 pragma solidity ^0.8.0;
106 
107 /**
108  * @dev Interface of the ERC20 standard as defined in the EIP.
109  */
110 interface IERC20 {
111     /**
112      * @dev Returns the amount of tokens in existence.
113      */
114     function totalSupply() external view returns (uint256);
115 
116     /**
117      * @dev Returns the amount of tokens owned by `account`.
118      */
119     function balanceOf(address account) external view returns (uint256);
120 
121     /**
122      * @dev Moves `amount` tokens from the caller's account to `recipient`.
123      *
124      * Returns a boolean value indicating whether the operation succeeded.
125      *
126      * Emits a {Transfer} event.
127      */
128     function transfer(address recipient, uint256 amount) external returns (bool);
129 
130     /**
131      * @dev Returns the remaining number of tokens that `spender` will be
132      * allowed to spend on behalf of `owner` through {transferFrom}. This is
133      * zero by default.
134      *
135      * This value changes when {approve} or {transferFrom} are called.
136      */
137     function allowance(address owner, address spender) external view returns (uint256);
138 
139     /**
140      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
141      *
142      * Returns a boolean value indicating whether the operation succeeded.
143      *
144      * IMPORTANT: Beware that changing an allowance with this method brings the risk
145      * that someone may use both the old and the new allowance by unfortunate
146      * transaction ordering. One possible solution to mitigate this race
147      * condition is to first reduce the spender's allowance to 0 and set the
148      * desired value afterwards:
149      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
150      *
151      * Emits an {Approval} event.
152      */
153     function approve(address spender, uint256 amount) external returns (bool);
154 
155     /**
156      * @dev Moves `amount` tokens from `sender` to `recipient` using the
157      * allowance mechanism. `amount` is then deducted from the caller's
158      * allowance.
159      *
160      * Returns a boolean value indicating whether the operation succeeded.
161      *
162      * Emits a {Transfer} event.
163      */
164     function transferFrom(
165         address sender,
166         address recipient,
167         uint256 amount
168     ) external returns (bool);
169 
170     /**
171      * @dev Emitted when `value` tokens are moved from one account (`from`) to
172      * another (`to`).
173      *
174      * Note that `value` may be zero.
175      */
176     event Transfer(address indexed from, address indexed to, uint256 value);
177 
178     /**
179      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
180      * a call to {approve}. `value` is the new allowance.
181      */
182     event Approval(address indexed owner, address indexed spender, uint256 value);
183 }
184 
185 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
186 
187 
188 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
189 
190 pragma solidity ^0.8.0;
191 
192 
193 /**
194  * @dev Interface for the optional metadata functions from the ERC20 standard.
195  *
196  * _Available since v4.1._
197  */
198 interface IERC20Metadata is IERC20 {
199     /**
200      * @dev Returns the name of the token.
201      */
202     function name() external view returns (string memory);
203 
204     /**
205      * @dev Returns the symbol of the token.
206      */
207     function symbol() external view returns (string memory);
208 
209     /**
210      * @dev Returns the decimals places of the token.
211      */
212     function decimals() external view returns (uint8);
213 }
214 
215 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
216 
217 
218 // OpenZeppelin Contracts v4.4.1 (token/ERC20/ERC20.sol)
219 
220 pragma solidity ^0.8.0;
221 
222 
223 
224 
225 /**
226  * @dev Implementation of the {IERC20} interface.
227  *
228  * This implementation is agnostic to the way tokens are created. This means
229  * that a supply mechanism has to be added in a derived contract using {_mint}.
230  * For a generic mechanism see {ERC20PresetMinterPauser}.
231  *
232  * TIP: For a detailed writeup see our guide
233  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
234  * to implement supply mechanisms].
235  *
236  * We have followed general OpenZeppelin Contracts guidelines: functions revert
237  * instead returning `false` on failure. This behavior is nonetheless
238  * conventional and does not conflict with the expectations of ERC20
239  * applications.
240  *
241  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
242  * This allows applications to reconstruct the allowance for all accounts just
243  * by listening to said events. Other implementations of the EIP may not emit
244  * these events, as it isn't required by the specification.
245  *
246  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
247  * functions have been added to mitigate the well-known issues around setting
248  * allowances. See {IERC20-approve}.
249  */
250 contract ERC20 is Context, IERC20, IERC20Metadata {
251     mapping(address => uint256) private _balances;
252 
253     mapping(address => mapping(address => uint256)) private _allowances;
254 
255     uint256 private _totalSupply;
256 
257     string private _name;
258     string private _symbol;
259 
260     /**
261      * @dev Sets the values for {name} and {symbol}.
262      *
263      * The default value of {decimals} is 18. To select a different value for
264      * {decimals} you should overload it.
265      *
266      * All two of these values are immutable: they can only be set once during
267      * construction.
268      */
269     constructor(string memory name_, string memory symbol_) {
270         _name = name_;
271         _symbol = symbol_;
272     }
273 
274     /**
275      * @dev Returns the name of the token.
276      */
277     function name() public view virtual override returns (string memory) {
278         return _name;
279     }
280 
281     /**
282      * @dev Returns the symbol of the token, usually a shorter version of the
283      * name.
284      */
285     function symbol() public view virtual override returns (string memory) {
286         return _symbol;
287     }
288 
289     /**
290      * @dev Returns the number of decimals used to get its user representation.
291      * For example, if `decimals` equals `2`, a balance of `505` tokens should
292      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
293      *
294      * Tokens usually opt for a value of 18, imitating the relationship between
295      * Ether and Wei. This is the value {ERC20} uses, unless this function is
296      * overridden;
297      *
298      * NOTE: This information is only used for _display_ purposes: it in
299      * no way affects any of the arithmetic of the contract, including
300      * {IERC20-balanceOf} and {IERC20-transfer}.
301      */
302     function decimals() public view virtual override returns (uint8) {
303         return 18;
304     }
305 
306     /**
307      * @dev See {IERC20-totalSupply}.
308      */
309     function totalSupply() public view virtual override returns (uint256) {
310         return _totalSupply;
311     }
312 
313     /**
314      * @dev See {IERC20-balanceOf}.
315      */
316     function balanceOf(address account) public view virtual override returns (uint256) {
317         return _balances[account];
318     }
319 
320     /**
321      * @dev See {IERC20-transfer}.
322      *
323      * Requirements:
324      *
325      * - `recipient` cannot be the zero address.
326      * - the caller must have a balance of at least `amount`.
327      */
328     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
329         _transfer(_msgSender(), recipient, amount);
330         return true;
331     }
332 
333     /**
334      * @dev See {IERC20-allowance}.
335      */
336     function allowance(address owner, address spender) public view virtual override returns (uint256) {
337         return _allowances[owner][spender];
338     }
339 
340     /**
341      * @dev See {IERC20-approve}.
342      *
343      * Requirements:
344      *
345      * - `spender` cannot be the zero address.
346      */
347     function approve(address spender, uint256 amount) public virtual override returns (bool) {
348         _approve(_msgSender(), spender, amount);
349         return true;
350     }
351 
352     /**
353      * @dev See {IERC20-transferFrom}.
354      *
355      * Emits an {Approval} event indicating the updated allowance. This is not
356      * required by the EIP. See the note at the beginning of {ERC20}.
357      *
358      * Requirements:
359      *
360      * - `sender` and `recipient` cannot be the zero address.
361      * - `sender` must have a balance of at least `amount`.
362      * - the caller must have allowance for ``sender``'s tokens of at least
363      * `amount`.
364      */
365     function transferFrom(
366         address sender,
367         address recipient,
368         uint256 amount
369     ) public virtual override returns (bool) {
370         _transfer(sender, recipient, amount);
371 
372         uint256 currentAllowance = _allowances[sender][_msgSender()];
373         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
374         unchecked {
375             _approve(sender, _msgSender(), currentAllowance - amount);
376         }
377 
378         return true;
379     }
380 
381     /**
382      * @dev Atomically increases the allowance granted to `spender` by the caller.
383      *
384      * This is an alternative to {approve} that can be used as a mitigation for
385      * problems described in {IERC20-approve}.
386      *
387      * Emits an {Approval} event indicating the updated allowance.
388      *
389      * Requirements:
390      *
391      * - `spender` cannot be the zero address.
392      */
393     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
394         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
395         return true;
396     }
397 
398     /**
399      * @dev Atomically decreases the allowance granted to `spender` by the caller.
400      *
401      * This is an alternative to {approve} that can be used as a mitigation for
402      * problems described in {IERC20-approve}.
403      *
404      * Emits an {Approval} event indicating the updated allowance.
405      *
406      * Requirements:
407      *
408      * - `spender` cannot be the zero address.
409      * - `spender` must have allowance for the caller of at least
410      * `subtractedValue`.
411      */
412     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
413         uint256 currentAllowance = _allowances[_msgSender()][spender];
414         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
415         unchecked {
416             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
417         }
418 
419         return true;
420     }
421 
422     /**
423      * @dev Moves `amount` of tokens from `sender` to `recipient`.
424      *
425      * This internal function is equivalent to {transfer}, and can be used to
426      * e.g. implement automatic token fees, slashing mechanisms, etc.
427      *
428      * Emits a {Transfer} event.
429      *
430      * Requirements:
431      *
432      * - `sender` cannot be the zero address.
433      * - `recipient` cannot be the zero address.
434      * - `sender` must have a balance of at least `amount`.
435      */
436     function _transfer(
437         address sender,
438         address recipient,
439         uint256 amount
440     ) internal virtual {
441         require(sender != address(0), "ERC20: transfer from the zero address");
442         require(recipient != address(0), "ERC20: transfer to the zero address");
443 
444         _beforeTokenTransfer(sender, recipient, amount);
445 
446         uint256 senderBalance = _balances[sender];
447         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
448         unchecked {
449             _balances[sender] = senderBalance - amount;
450         }
451         _balances[recipient] += amount;
452 
453         emit Transfer(sender, recipient, amount);
454 
455         _afterTokenTransfer(sender, recipient, amount);
456     }
457 
458     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
459      * the total supply.
460      *
461      * Emits a {Transfer} event with `from` set to the zero address.
462      *
463      * Requirements:
464      *
465      * - `account` cannot be the zero address.
466      */
467     function _mint(address account, uint256 amount) internal virtual {
468         require(account != address(0), "ERC20: mint to the zero address");
469 
470         _beforeTokenTransfer(address(0), account, amount);
471 
472         _totalSupply += amount;
473         _balances[account] += amount;
474         emit Transfer(address(0), account, amount);
475 
476         _afterTokenTransfer(address(0), account, amount);
477     }
478 
479     /**
480      * @dev Destroys `amount` tokens from `account`, reducing the
481      * total supply.
482      *
483      * Emits a {Transfer} event with `to` set to the zero address.
484      *
485      * Requirements:
486      *
487      * - `account` cannot be the zero address.
488      * - `account` must have at least `amount` tokens.
489      */
490     function _burn(address account, uint256 amount) internal virtual {
491         require(account != address(0), "ERC20: burn from the zero address");
492 
493         _beforeTokenTransfer(account, address(0), amount);
494 
495         uint256 accountBalance = _balances[account];
496         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
497         unchecked {
498             _balances[account] = accountBalance - amount;
499         }
500         _totalSupply -= amount;
501 
502         emit Transfer(account, address(0), amount);
503 
504         _afterTokenTransfer(account, address(0), amount);
505     }
506 
507     /**
508      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
509      *
510      * This internal function is equivalent to `approve`, and can be used to
511      * e.g. set automatic allowances for certain subsystems, etc.
512      *
513      * Emits an {Approval} event.
514      *
515      * Requirements:
516      *
517      * - `owner` cannot be the zero address.
518      * - `spender` cannot be the zero address.
519      */
520     function _approve(
521         address owner,
522         address spender,
523         uint256 amount
524     ) internal virtual {
525         require(owner != address(0), "ERC20: approve from the zero address");
526         require(spender != address(0), "ERC20: approve to the zero address");
527 
528         _allowances[owner][spender] = amount;
529         emit Approval(owner, spender, amount);
530     }
531 
532     /**
533      * @dev Hook that is called before any transfer of tokens. This includes
534      * minting and burning.
535      *
536      * Calling conditions:
537      *
538      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
539      * will be transferred to `to`.
540      * - when `from` is zero, `amount` tokens will be minted for `to`.
541      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
542      * - `from` and `to` are never both zero.
543      *
544      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
545      */
546     function _beforeTokenTransfer(
547         address from,
548         address to,
549         uint256 amount
550     ) internal virtual {}
551 
552     /**
553      * @dev Hook that is called after any transfer of tokens. This includes
554      * minting and burning.
555      *
556      * Calling conditions:
557      *
558      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
559      * has been transferred to `to`.
560      * - when `from` is zero, `amount` tokens have been minted for `to`.
561      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
562      * - `from` and `to` are never both zero.
563      *
564      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
565      */
566     function _afterTokenTransfer(
567         address from,
568         address to,
569         uint256 amount
570     ) internal virtual {}
571 }
572 
573 // File: BBstaking.sol
574 
575 
576 
577 pragma solidity ^0.8.9;
578 
579 
580 
581 /*
582     Interfaces for Bohemian Bulldogs service Smart Contracts
583 */ 
584 interface TokenContract { 
585     function allowanceFor(address spender) external view returns(uint256); 
586     function transferFrom(address _from, address _to, uint256 _value) external returns(bool); 
587     function balanceOf(address owner) external view returns(uint); function burnFrom(address account, uint256 amount) external; 
588 }
589 
590 interface NFTContract { 
591     function ownerOf(uint256 _tokenId) external view returns (address); 
592     function transferFrom(address from, address to, uint tokenId) external payable; 
593 } 
594 /* 
595     End of interfaces
596 */
597 
598 contract BulldogsStaking is ReentrancyGuard {
599 
600     //// Events
601     event _adminSetCollectionEarnRate(uint collectionId, uint _earnRate);
602     event _adminSetCollectionSwapCost(uint collectionId, uint _swapRate);
603     event _adminSetTokensCollections(uint[] _tokenIds, uint _collectionId);
604     event _adminSetMinStakingPerion(uint period);
605     event _adminSetFreezePeriod(uint period);
606     event _adminSetClaimableBalance(address[] _address, uint amount);
607     event _adminAddBonus(address[] _address, uint amount);
608 
609     event _userSetTokenCollection(uint _tokenId, uint _collectionId);
610     event _setTokenContract(address _address);
611     event _setNFTContract(address _address);
612 
613     event Staked(uint tokenId);
614     event Unstaked(uint256 tokenId);
615     event BBonesClaimed(address _address, uint amount);
616     event bulldogUpgraded(uint tokenId);
617     event bulldogSwapped(uint tokenId);
618 
619     // Base variables
620     address private _owner;
621     address private _tokenContractAddress;
622     address private _nftContractAddress;
623 
624     // Minimal period before you can claim $BBONES, in blocks
625     uint minStakingPeriod = 930;
626 
627     // Freeze after which you can claim and unstake, in blocks
628     uint freezePeriod = 20000;
629 
630     /* Data storage:
631         Collections:
632         1 - Street
633         2 - Bohemian
634         3 - Boho
635         4 - Business
636         5 - Business Smokers
637         6 - Capsule
638     */
639 
640     // tokenId -> collectionId
641     mapping(uint => uint) public tokensData;
642 
643     // collectionId -> minStakingPeriod earn rate
644     mapping(uint => uint) public earnRates;
645 
646     // collectionId -> upgradeability cost in $BBONES to the next one
647     mapping(uint => uint) public upgradeabilityCost;
648 
649     // collectionId -> swapping cost in $BBONES, for interchange your NFT inside the same collection
650     mapping(uint => uint) public swappingCost;
651 
652     // list of claimableBalance
653     mapping(address => uint) public claimableBalance;
654 
655     struct Staker {
656         // list of staked tokenIds
657         uint[] stakedTokens;
658 
659         // tokenId -> blockNumber
660         mapping(uint => uint) tokenStakeBlock;
661     }
662 
663     mapping(address => Staker) private stakeHolders;
664 
665 
666     constructor () {
667         _owner = msg.sender;
668 
669         earnRates[1] = 1;
670         earnRates[2] = 2;
671         earnRates[3] = 8;
672         earnRates[4] = 24;
673         earnRates[5] = 36;
674         earnRates[6] = 0;
675 
676         upgradeabilityCost[1] = 100;
677         upgradeabilityCost[2] = 400;
678         upgradeabilityCost[3] = 2400;
679         upgradeabilityCost[4] = 4800;
680 
681         swappingCost[1] = 50;
682         swappingCost[2] = 200;
683         swappingCost[3] = 1200;
684         swappingCost[4] = 2400;
685         swappingCost[5] = 3200;
686     }
687 
688 
689     /*
690     Modifiers
691     */
692     modifier onlyOwner {
693         require(msg.sender == _owner || msg.sender == address(this), "You're not owner");
694         _;
695     }
696 
697     modifier staked(uint tokenId)  {
698         require(stakeHolders[msg.sender].tokenStakeBlock[tokenId] != 0, "You have not staked this token");
699         _;
700     }
701 
702     modifier notStaked(uint tokenId) {
703         require(stakeHolders[msg.sender].tokenStakeBlock[tokenId] == 0, "You have already staked this token");
704         _;
705     }
706 
707     modifier freezePeriodPassed(uint tokenId) {
708         uint blockNum = stakeHolders[msg.sender].tokenStakeBlock[tokenId];
709         require(blockNum + freezePeriod <= block.number, "This token is freezed, try again later");
710         _;
711     }
712 
713     modifier ownerOfToken(uint tokenId) {
714         require(msg.sender == NFTContract(_nftContractAddress).ownerOf(tokenId) || stakeHolders[msg.sender].tokenStakeBlock[tokenId] > 0, "You are not owner of this token");
715         _;
716     }
717     /*
718     End of modifiers
719     */
720 
721 
722     /*
723     Storage-related functions
724     */
725     // Set/reset collection's earn rate
726     function adminSetCollectionEarnRate(uint collectionId, uint _earnRate) external onlyOwner {
727         earnRates[collectionId] = _earnRate;
728         emit _adminSetCollectionEarnRate(collectionId, _earnRate);
729     }
730 
731     // Set/reset collection's swap rate
732     function adminSetCollectionSwapCost(uint collectionId, uint _swapCost) external onlyOwner {
733         swappingCost[collectionId] = _swapCost;
734         emit _adminSetCollectionSwapCost(collectionId, _swapCost);
735     }
736 
737     // Set/reset token's earn rate
738     function adminSetTokensCollections(uint[] memory _tokenIds, uint _collectionId) external onlyOwner {
739         for (uint i=0; i < _tokenIds.length; i++) {
740             tokensData[_tokenIds[i]] = _collectionId;
741         }
742         emit _adminSetTokensCollections(_tokenIds, _collectionId);
743     }
744 
745     // Set claimableBalance to wallets
746     function adminSetClaimableBalance(address[] memory _address, uint amount) external onlyOwner {
747         for (uint i=0; i < _address.length; i++) {
748             claimableBalance[_address[i]] = amount;
749         }
750         emit _adminSetClaimableBalance(_address, amount);
751     }
752 
753     // Add claimableBalance to wallets
754     function adminAddBonus(address[] memory _address, uint amount) public onlyOwner {
755         for (uint i=0; i < _address.length; i++) {
756             claimableBalance[_address[i]] += amount;
757         }
758         emit _adminAddBonus(_address, amount);
759     }
760 
761     // Set collectionId for tokenId
762     function userSetTokenCollection(uint _tokenId, uint _collectionId) internal {
763         tokensData[_tokenId] = _collectionId;
764         emit _userSetTokenCollection(_tokenId, _collectionId);
765     }
766 
767     // Set new minStakingPeriod
768     function setMinStakingPeriod(uint period) public onlyOwner {
769         minStakingPeriod = period;
770         emit _adminSetMinStakingPerion(period);
771     }
772 
773     // Set new freezePeriod
774     function setFreezePeriod(uint period) public onlyOwner {
775         freezePeriod = period;
776         emit _adminSetFreezePeriod(period);
777     }
778     /*
779     End of storage-related functions
780     */
781 
782 
783     /*
784     Setters
785     */
786     function setTokenContract(address _address) public onlyOwner {
787         _tokenContractAddress = _address;
788         emit _setTokenContract(_address);
789     }
790 
791     function setNFTContract(address _address) public onlyOwner {
792         _nftContractAddress = _address;
793         emit _setNFTContract(_address);
794     }
795     /*
796     End of setters
797     */
798 
799 
800     /*
801     Getters
802     */
803 
804     // In how many blocks token can be unstaked
805     function getBlocksTillUnfreeze(uint tokenId, address _address) public view returns(uint) {
806         uint blocksPassed = block.number - stakeHolders[_address].tokenStakeBlock[tokenId];
807         if (blocksPassed >= freezePeriod) {
808             return 0;
809         }
810         return freezePeriod - blocksPassed;
811     }
812 
813     function getTokenEarnRate(uint _tokenId) public view returns(uint tokenEarnRate) {
814         return earnRates[tokensData[_tokenId]];
815     }
816 
817     // Get token's unrealized pnl
818     function getTokenUPNL(uint tokenId, address _address) public view returns(uint) {
819 
820         if (stakeHolders[_address].tokenStakeBlock[tokenId] == 0) {
821             return 0;
822         }
823 
824         uint tokenBlockDiff = block.number - stakeHolders[_address].tokenStakeBlock[tokenId];
825 
826         //Token will not be in freeze period
827         if (tokenBlockDiff <= freezePeriod) {
828             return 0;
829         }
830 
831         // Token has to be staked minimum number of blocks
832         if (tokenBlockDiff >= minStakingPeriod) {
833             uint quotient;
834             uint remainder;
835 
836             // if enough blocks have passed to get at least 1 payout => proceed
837             (quotient, remainder) = superDivision(tokenBlockDiff, minStakingPeriod);
838             if (quotient > 0) {
839                 uint blockRate = getTokenEarnRate(tokenId);
840                 uint tokenEarnings = blockRate * quotient;
841                 return tokenEarnings;
842 
843             }
844         }
845         return 0;
846     }
847 
848     // Returns total unrealized pnl
849     function getTotalUPNL(address _address) public view returns(uint) {
850         uint totalUPNL = 0;
851 
852         uint tokensCount = stakeHolders[_address].stakedTokens.length;
853         for (uint i = 0; i < tokensCount; i++) {
854             totalUPNL += getTokenUPNL(stakeHolders[_address].stakedTokens[i], _address);
855         }
856         return totalUPNL;
857     }
858 
859     /*
860     End of getters
861     */
862 
863 
864     /*
865     Staking functions
866     */
867     function stake(uint tokenId, uint tokenCollection) public nonReentrant notStaked(tokenId) ownerOfToken(tokenId) {
868         // Setting token's collection if it wasn't set
869         if (tokensData[tokenId] == 0) {
870             userSetTokenCollection(tokenId, tokenCollection);
871         }
872 
873         // Checking bulldog's collection to see whether it's upgradeable
874         require(tokensData[tokenId] >= 1 && tokensData[tokenId] < 6, "You cannot stake this bulldog");
875 
876         // Making approved transfer from the main NFT contract
877         NFTContract(_nftContractAddress).transferFrom(msg.sender, address(this), tokenId);
878 
879         // Writing changes to DB
880         stakeHolders[msg.sender].tokenStakeBlock[tokenId] = block.number + 1;
881         stakeHolders[msg.sender].stakedTokens.push(tokenId);
882 
883         emit Staked(tokenId);
884     }
885 
886     function unstake(uint256 tokenId) public nonReentrant ownerOfToken(tokenId) staked(tokenId) freezePeriodPassed(tokenId) {
887         // Adding unclaimed $BBONES to claimableBalance
888         claimableBalance[msg.sender] += getTokenUPNL(tokenId, msg.sender);
889 
890         stakeHolders[msg.sender].tokenStakeBlock[tokenId] = 0;
891 
892         uint tokensCount = stakeHolders[msg.sender].stakedTokens.length;
893 
894         uint[] memory newStakedTokens = new uint[](tokensCount - 1);
895 
896         uint j = 0;
897         for (uint i = 0; i < tokensCount; i++) {
898             if (stakeHolders[msg.sender].stakedTokens[i] != tokenId) {
899                 newStakedTokens[j] = stakeHolders[msg.sender].stakedTokens[i];
900                 j += 1;
901             }
902         }
903         stakeHolders[msg.sender].stakedTokens = newStakedTokens;
904 
905         // Making approved transfer NFT back to its owner
906         NFTContract(_nftContractAddress).transferFrom(address(this), msg.sender, tokenId);
907 
908         emit Unstaked(tokenId);
909 
910     }
911 
912     // divides two numbers and returns quotient & remainder
913     function superDivision(uint numerator, uint denominator) internal pure returns(uint quotient, uint remainder) {
914         quotient  = numerator / denominator;
915         remainder = numerator - denominator * quotient;
916     }
917 
918     // Call to get you staking reward
919     function claimBBones(address _address) public nonReentrant {
920 
921         uint amountToPay = 0;
922         uint tokensCount = stakeHolders[_address].stakedTokens.length;
923 
924         for (uint i = 0; i < tokensCount; i++) {
925             uint tokenId = stakeHolders[_address].stakedTokens[i];
926             uint tokenBlockDiff = block.number - stakeHolders[_address].tokenStakeBlock[tokenId];
927 
928             // Token has to be staked minimum number of blocks
929             if (tokenBlockDiff >= minStakingPeriod && stakeHolders[_address].tokenStakeBlock[tokenId] + freezePeriod <= block.number) {
930                 uint quotient;
931                 uint remainder;
932 
933                 // if enough blocks have passed to get at least 1 payout => proceed
934                 (quotient, remainder) = superDivision(tokenBlockDiff, minStakingPeriod);
935                 if (quotient > 0) {
936                     uint blockRate = getTokenEarnRate(tokenId);
937                     uint tokenEarnings = blockRate * quotient;
938                     amountToPay += tokenEarnings;
939 
940                     stakeHolders[_address].tokenStakeBlock[tokenId] = block.number - remainder + 1;
941                 }
942             }
943         }
944 
945         // Claiming claimableBalance if any
946         if (claimableBalance[_address] > 0) {
947             amountToPay += claimableBalance[_address];
948             claimableBalance[_address] = 0;
949         }
950 
951         TokenContract(_tokenContractAddress).transferFrom(_tokenContractAddress, _address, amountToPay);
952         emit BBonesClaimed(_address, amountToPay);
953     }
954 
955     // Get user's list of staked tokens
956     function stakedTokensOf(address _address) public view returns (uint[] memory) {
957         return stakeHolders[_address].stakedTokens;
958     }
959     /*
960         End of staking
961     */
962 
963 
964     /*
965         Upgrading
966     */
967     function upgradeBulldog(uint tokenId, uint collectionId, uint upgradeType) public nonReentrant ownerOfToken(tokenId) {
968         /*
969             Upgrade types:
970                 1 - to the next collection
971                 2 - swap inside the same collection
972         */
973 
974         // Setting token's collection if it wasn't set
975         if (tokensData[tokenId] == 0) {
976             tokensData[tokenId] = collectionId;
977         }
978 
979         // Checking bulldog's collection to see whether it's upgradeable
980         require(tokensData[tokenId] >= 1 && tokensData[tokenId] < 5, "Your bulldog cannot be upgraded further");
981 
982         // User has emough $BBONES to pay for the upgrade
983         require(TokenContract(_tokenContractAddress).balanceOf(msg.sender) >= upgradeabilityCost[tokensData[tokenId]], "You don't have enough $BBONES");
984 
985         // Upgrading
986         if (upgradeType == 1) {
987 
988             // If token is staked: save his UPNL and reset
989             if (stakeHolders[msg.sender].tokenStakeBlock[tokenId] > 0) {
990                 // Adding unclaimed $BBONES to claimableBalanceses
991                 claimableBalance[msg.sender] += getTokenUPNL(tokenId, msg.sender);
992 
993                 stakeHolders[msg.sender].tokenStakeBlock[tokenId] = block.number + 1;
994             }
995             TokenContract(_tokenContractAddress).burnFrom(msg.sender, upgradeabilityCost[tokensData[tokenId]]);
996             tokensData[tokenId] += 1;
997             emit bulldogUpgraded(tokenId);
998         }
999 
1000         // Swapping
1001         if (upgradeType == 2) {
1002             TokenContract(_tokenContractAddress).burnFrom(msg.sender, upgradeabilityCost[tokensData[tokenId]]);
1003             emit bulldogSwapped(tokenId);
1004         }
1005     }
1006     /*
1007         End of upgrading
1008     */
1009 }
1010 
1011 
1012 //
1013 // Developed by https://1block.one
1014 //