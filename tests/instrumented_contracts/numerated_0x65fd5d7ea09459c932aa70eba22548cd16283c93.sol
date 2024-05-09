1 pragma solidity ^0.8.7;
2 
3 // SPDX-License-Identifier: MIT
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
6 /**
7  * @dev Provides information about the current execution context, including the
8  * sender of the transaction and its data. While these are generally available
9  * via msg.sender and msg.data, they should not be accessed in such a direct
10  * manner, since when dealing with meta-transactions the account sending and
11  * paying for execution may not be the actual sender (as far as an application
12  * is concerned).
13  *
14  * This contract is only required for intermediate, library-like contracts.
15  */
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes calldata) {
22         return msg.data;
23     }
24 }
25 
26 
27 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
28 /**
29  * @dev Contract module which provides a basic access control mechanism, where
30  * there is an account (an owner) that can be granted exclusive access to
31  * specific functions.
32  *
33  * By default, the owner account will be the one that deploys the contract. This
34  * can later be changed with {transferOwnership}.
35  *
36  * This module is used through inheritance. It will make available the modifier
37  * `onlyOwner`, which can be applied to your functions to restrict their use to
38  * the owner.
39  */
40 abstract contract Ownable is Context {
41     address private _owner;
42 
43     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45     /**
46      * @dev Initializes the contract setting the deployer as the initial owner.
47      */
48     constructor() {
49         _transferOwnership(_msgSender());
50     }
51 
52     /**
53      * @dev Returns the address of the current owner.
54      */
55     function owner() public view virtual returns (address) {
56         return _owner;
57     }
58 
59     /**
60      * @dev Throws if called by any account other than the owner.
61      */
62     modifier onlyOwner() {
63         require(owner() == _msgSender(), "Ownable: caller is not the owner");
64         _;
65     }
66 
67     /**
68      * @dev Leaves the contract without owner. It will not be possible to call
69      * `onlyOwner` functions anymore. Can only be called by the current owner.
70      *
71      * NOTE: Renouncing ownership will leave the contract without an owner,
72      * thereby removing any functionality that is only available to the owner.
73      */
74     function renounceOwnership() public virtual onlyOwner {
75         _transferOwnership(address(0));
76     }
77 
78     /**
79      * @dev Transfers ownership of the contract to a new account (`newOwner`).
80      * Can only be called by the current owner.
81      */
82     function transferOwnership(address newOwner) public virtual onlyOwner {
83         require(newOwner != address(0), "Ownable: new owner is the zero address");
84         _transferOwnership(newOwner);
85     }
86 
87     /**
88      * @dev Transfers ownership of the contract to a new account (`newOwner`).
89      * Internal function without access restriction.
90      */
91     function _transferOwnership(address newOwner) internal virtual {
92         address oldOwner = _owner;
93         _owner = newOwner;
94         emit OwnershipTransferred(oldOwner, newOwner);
95     }
96 }
97 
98 
99 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
100 /**
101  * @dev Interface of the ERC20 standard as defined in the EIP.
102  */
103 interface IERC20 {
104     /**
105      * @dev Returns the amount of tokens in existence.
106      */
107     function totalSupply() external view returns (uint256);
108 
109     /**
110      * @dev Returns the amount of tokens owned by `account`.
111      */
112     function balanceOf(address account) external view returns (uint256);
113 
114     /**
115      * @dev Moves `amount` tokens from the caller's account to `to`.
116      *
117      * Returns a boolean value indicating whether the operation succeeded.
118      *
119      * Emits a {Transfer} event.
120      */
121     function transfer(address to, uint256 amount) external returns (bool);
122 
123     /**
124      * @dev Returns the remaining number of tokens that `spender` will be
125      * allowed to spend on behalf of `owner` through {transferFrom}. This is
126      * zero by default.
127      *
128      * This value changes when {approve} or {transferFrom} are called.
129      */
130     function allowance(address owner, address spender) external view returns (uint256);
131 
132     /**
133      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
134      *
135      * Returns a boolean value indicating whether the operation succeeded.
136      *
137      * IMPORTANT: Beware that changing an allowance with this method brings the risk
138      * that someone may use both the old and the new allowance by unfortunate
139      * transaction ordering. One possible solution to mitigate this race
140      * condition is to first reduce the spender's allowance to 0 and set the
141      * desired value afterwards:
142      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
143      *
144      * Emits an {Approval} event.
145      */
146     function approve(address spender, uint256 amount) external returns (bool);
147 
148     /**
149      * @dev Moves `amount` tokens from `from` to `to` using the
150      * allowance mechanism. `amount` is then deducted from the caller's
151      * allowance.
152      *
153      * Returns a boolean value indicating whether the operation succeeded.
154      *
155      * Emits a {Transfer} event.
156      */
157     function transferFrom(
158         address from,
159         address to,
160         uint256 amount
161     ) external returns (bool);
162 
163     /**
164      * @dev Emitted when `value` tokens are moved from one account (`from`) to
165      * another (`to`).
166      *
167      * Note that `value` may be zero.
168      */
169     event Transfer(address indexed from, address indexed to, uint256 value);
170 
171     /**
172      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
173      * a call to {approve}. `value` is the new allowance.
174      */
175     event Approval(address indexed owner, address indexed spender, uint256 value);
176 }
177 
178 
179 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
180 /**
181  * @dev Interface for the optional metadata functions from the ERC20 standard.
182  *
183  * _Available since v4.1._
184  */
185 interface IERC20Metadata is IERC20 {
186     /**
187      * @dev Returns the name of the token.
188      */
189     function name() external view returns (string memory);
190 
191     /**
192      * @dev Returns the symbol of the token.
193      */
194     function symbol() external view returns (string memory);
195 
196     /**
197      * @dev Returns the decimals places of the token.
198      */
199     function decimals() external view returns (uint8);
200 }
201 
202 
203 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/ERC20.sol)
204 /**
205  * @dev Implementation of the {IERC20} interface.
206  *
207  * This implementation is agnostic to the way tokens are created. This means
208  * that a supply mechanism has to be added in a derived contract using {_mint}.
209  * For a generic mechanism see {ERC20PresetMinterPauser}.
210  *
211  * TIP: For a detailed writeup see our guide
212  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
213  * to implement supply mechanisms].
214  *
215  * We have followed general OpenZeppelin Contracts guidelines: functions revert
216  * instead returning `false` on failure. This behavior is nonetheless
217  * conventional and does not conflict with the expectations of ERC20
218  * applications.
219  *
220  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
221  * This allows applications to reconstruct the allowance for all accounts just
222  * by listening to said events. Other implementations of the EIP may not emit
223  * these events, as it isn't required by the specification.
224  *
225  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
226  * functions have been added to mitigate the well-known issues around setting
227  * allowances. See {IERC20-approve}.
228  */
229 contract ERC20 is Context, IERC20, IERC20Metadata {
230     mapping(address => uint256) private _balances;
231 
232     mapping(address => mapping(address => uint256)) private _allowances;
233 
234     uint256 private _totalSupply;
235 
236     string private _name;
237     string private _symbol;
238 
239     /**
240      * @dev Sets the values for {name} and {symbol}.
241      *
242      * The default value of {decimals} is 18. To select a different value for
243      * {decimals} you should overload it.
244      *
245      * All two of these values are immutable: they can only be set once during
246      * construction.
247      */
248     constructor(string memory name_, string memory symbol_) {
249         _name = name_;
250         _symbol = symbol_;
251     }
252 
253     /**
254      * @dev Returns the name of the token.
255      */
256     function name() public view virtual override returns (string memory) {
257         return _name;
258     }
259 
260     /**
261      * @dev Returns the symbol of the token, usually a shorter version of the
262      * name.
263      */
264     function symbol() public view virtual override returns (string memory) {
265         return _symbol;
266     }
267 
268     /**
269      * @dev Returns the number of decimals used to get its user representation.
270      * For example, if `decimals` equals `2`, a balance of `505` tokens should
271      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
272      *
273      * Tokens usually opt for a value of 18, imitating the relationship between
274      * Ether and Wei. This is the value {ERC20} uses, unless this function is
275      * overridden;
276      *
277      * NOTE: This information is only used for _display_ purposes: it in
278      * no way affects any of the arithmetic of the contract, including
279      * {IERC20-balanceOf} and {IERC20-transfer}.
280      */
281     function decimals() public view virtual override returns (uint8) {
282         return 18;
283     }
284 
285     /**
286      * @dev See {IERC20-totalSupply}.
287      */
288     function totalSupply() public view virtual override returns (uint256) {
289         return _totalSupply;
290     }
291 
292     /**
293      * @dev See {IERC20-balanceOf}.
294      */
295     function balanceOf(address account) public view virtual override returns (uint256) {
296         return _balances[account];
297     }
298 
299     /**
300      * @dev See {IERC20-transfer}.
301      *
302      * Requirements:
303      *
304      * - `to` cannot be the zero address.
305      * - the caller must have a balance of at least `amount`.
306      */
307     function transfer(address to, uint256 amount) public virtual override returns (bool) {
308         address owner = _msgSender();
309         _transfer(owner, to, amount);
310         return true;
311     }
312 
313     /**
314      * @dev See {IERC20-allowance}.
315      */
316     function allowance(address owner, address spender) public view virtual override returns (uint256) {
317         return _allowances[owner][spender];
318     }
319 
320     /**
321      * @dev See {IERC20-approve}.
322      *
323      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
324      * `transferFrom`. This is semantically equivalent to an infinite approval.
325      *
326      * Requirements:
327      *
328      * - `spender` cannot be the zero address.
329      */
330     function approve(address spender, uint256 amount) public virtual override returns (bool) {
331         address owner = _msgSender();
332         _approve(owner, spender, amount);
333         return true;
334     }
335 
336     /**
337      * @dev See {IERC20-transferFrom}.
338      *
339      * Emits an {Approval} event indicating the updated allowance. This is not
340      * required by the EIP. See the note at the beginning of {ERC20}.
341      *
342      * NOTE: Does not update the allowance if the current allowance
343      * is the maximum `uint256`.
344      *
345      * Requirements:
346      *
347      * - `from` and `to` cannot be the zero address.
348      * - `from` must have a balance of at least `amount`.
349      * - the caller must have allowance for ``from``'s tokens of at least
350      * `amount`.
351      */
352     function transferFrom(
353         address from,
354         address to,
355         uint256 amount
356     ) public virtual override returns (bool) {
357         address spender = _msgSender();
358         _spendAllowance(from, spender, amount);
359         _transfer(from, to, amount);
360         return true;
361     }
362 
363     /**
364      * @dev Atomically increases the allowance granted to `spender` by the caller.
365      *
366      * This is an alternative to {approve} that can be used as a mitigation for
367      * problems described in {IERC20-approve}.
368      *
369      * Emits an {Approval} event indicating the updated allowance.
370      *
371      * Requirements:
372      *
373      * - `spender` cannot be the zero address.
374      */
375     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
376         address owner = _msgSender();
377         _approve(owner, spender, _allowances[owner][spender] + addedValue);
378         return true;
379     }
380 
381     /**
382      * @dev Atomically decreases the allowance granted to `spender` by the caller.
383      *
384      * This is an alternative to {approve} that can be used as a mitigation for
385      * problems described in {IERC20-approve}.
386      *
387      * Emits an {Approval} event indicating the updated allowance.
388      *
389      * Requirements:
390      *
391      * - `spender` cannot be the zero address.
392      * - `spender` must have allowance for the caller of at least
393      * `subtractedValue`.
394      */
395     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
396         address owner = _msgSender();
397         uint256 currentAllowance = _allowances[owner][spender];
398         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
399         unchecked {
400             _approve(owner, spender, currentAllowance - subtractedValue);
401         }
402 
403         return true;
404     }
405 
406     /**
407      * @dev Moves `amount` of tokens from `sender` to `recipient`.
408      *
409      * This internal function is equivalent to {transfer}, and can be used to
410      * e.g. implement automatic token fees, slashing mechanisms, etc.
411      *
412      * Emits a {Transfer} event.
413      *
414      * Requirements:
415      *
416      * - `from` cannot be the zero address.
417      * - `to` cannot be the zero address.
418      * - `from` must have a balance of at least `amount`.
419      */
420     function _transfer(
421         address from,
422         address to,
423         uint256 amount
424     ) internal virtual {
425         require(from != address(0), "ERC20: transfer from the zero address");
426         require(to != address(0), "ERC20: transfer to the zero address");
427 
428         _beforeTokenTransfer(from, to, amount);
429 
430         uint256 fromBalance = _balances[from];
431         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
432         unchecked {
433             _balances[from] = fromBalance - amount;
434         }
435         _balances[to] += amount;
436 
437         emit Transfer(from, to, amount);
438 
439         _afterTokenTransfer(from, to, amount);
440     }
441 
442     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
443      * the total supply.
444      *
445      * Emits a {Transfer} event with `from` set to the zero address.
446      *
447      * Requirements:
448      *
449      * - `account` cannot be the zero address.
450      */
451     function _mint(address account, uint256 amount) internal virtual {
452         require(account != address(0), "ERC20: mint to the zero address");
453 
454         _beforeTokenTransfer(address(0), account, amount);
455 
456         _totalSupply += amount;
457         _balances[account] += amount;
458         emit Transfer(address(0), account, amount);
459 
460         _afterTokenTransfer(address(0), account, amount);
461     }
462 
463     /**
464      * @dev Destroys `amount` tokens from `account`, reducing the
465      * total supply.
466      *
467      * Emits a {Transfer} event with `to` set to the zero address.
468      *
469      * Requirements:
470      *
471      * - `account` cannot be the zero address.
472      * - `account` must have at least `amount` tokens.
473      */
474     function _burn(address account, uint256 amount) internal virtual {
475         require(account != address(0), "ERC20: burn from the zero address");
476 
477         _beforeTokenTransfer(account, address(0), amount);
478 
479         uint256 accountBalance = _balances[account];
480         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
481         unchecked {
482             _balances[account] = accountBalance - amount;
483         }
484         _totalSupply -= amount;
485 
486         emit Transfer(account, address(0), amount);
487 
488         _afterTokenTransfer(account, address(0), amount);
489     }
490 
491     /**
492      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
493      *
494      * This internal function is equivalent to `approve`, and can be used to
495      * e.g. set automatic allowances for certain subsystems, etc.
496      *
497      * Emits an {Approval} event.
498      *
499      * Requirements:
500      *
501      * - `owner` cannot be the zero address.
502      * - `spender` cannot be the zero address.
503      */
504     function _approve(
505         address owner,
506         address spender,
507         uint256 amount
508     ) internal virtual {
509         require(owner != address(0), "ERC20: approve from the zero address");
510         require(spender != address(0), "ERC20: approve to the zero address");
511 
512         _allowances[owner][spender] = amount;
513         emit Approval(owner, spender, amount);
514     }
515 
516     /**
517      * @dev Spend `amount` form the allowance of `owner` toward `spender`.
518      *
519      * Does not update the allowance amount in case of infinite allowance.
520      * Revert if not enough allowance is available.
521      *
522      * Might emit an {Approval} event.
523      */
524     function _spendAllowance(
525         address owner,
526         address spender,
527         uint256 amount
528     ) internal virtual {
529         uint256 currentAllowance = allowance(owner, spender);
530         if (currentAllowance != type(uint256).max) {
531             require(currentAllowance >= amount, "ERC20: insufficient allowance");
532             unchecked {
533                 _approve(owner, spender, currentAllowance - amount);
534             }
535         }
536     }
537 
538     /**
539      * @dev Hook that is called before any transfer of tokens. This includes
540      * minting and burning.
541      *
542      * Calling conditions:
543      *
544      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
545      * will be transferred to `to`.
546      * - when `from` is zero, `amount` tokens will be minted for `to`.
547      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
548      * - `from` and `to` are never both zero.
549      *
550      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
551      */
552     function _beforeTokenTransfer(
553         address from,
554         address to,
555         uint256 amount
556     ) internal virtual {}
557 
558     /**
559      * @dev Hook that is called after any transfer of tokens. This includes
560      * minting and burning.
561      *
562      * Calling conditions:
563      *
564      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
565      * has been transferred to `to`.
566      * - when `from` is zero, `amount` tokens have been minted for `to`.
567      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
568      * - `from` and `to` are never both zero.
569      *
570      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
571      */
572     function _afterTokenTransfer(
573         address from,
574         address to,
575         uint256 amount
576     ) internal virtual {}
577 }
578 
579 
580 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
581 /**
582  * @dev Contract module that helps prevent reentrant calls to a function.
583  *
584  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
585  * available, which can be applied to functions to make sure there are no nested
586  * (reentrant) calls to them.
587  *
588  * Note that because there is a single `nonReentrant` guard, functions marked as
589  * `nonReentrant` may not call one another. This can be worked around by making
590  * those functions `private`, and then adding `external` `nonReentrant` entry
591  * points to them.
592  *
593  * TIP: If you would like to learn more about reentrancy and alternative ways
594  * to protect against it, check out our blog post
595  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
596  */
597 abstract contract ReentrancyGuard {
598     // Booleans are more expensive than uint256 or any type that takes up a full
599     // word because each write operation emits an extra SLOAD to first read the
600     // slot's contents, replace the bits taken up by the boolean, and then write
601     // back. This is the compiler's defense against contract upgrades and
602     // pointer aliasing, and it cannot be disabled.
603 
604     // The values being non-zero value makes deployment a bit more expensive,
605     // but in exchange the refund on every call to nonReentrant will be lower in
606     // amount. Since refunds are capped to a percentage of the total
607     // transaction's gas, it is best to keep them low in cases like this one, to
608     // increase the likelihood of the full refund coming into effect.
609     uint256 private constant _NOT_ENTERED = 1;
610     uint256 private constant _ENTERED = 2;
611 
612     uint256 private _status;
613 
614     constructor() {
615         _status = _NOT_ENTERED;
616     }
617 
618     /**
619      * @dev Prevents a contract from calling itself, directly or indirectly.
620      * Calling a `nonReentrant` function from another `nonReentrant`
621      * function is not supported. It is possible to prevent this from happening
622      * by making the `nonReentrant` function external, and making it call a
623      * `private` function that does the actual work.
624      */
625     modifier nonReentrant() {
626         // On the first call to nonReentrant, _notEntered will be true
627         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
628 
629         // Any calls to nonReentrant after this point will fail
630         _status = _ENTERED;
631 
632         _;
633 
634         // By storing the original value once again, a refund is triggered (see
635         // https://eips.ethereum.org/EIPS/eip-2200)
636         _status = _NOT_ENTERED;
637     }
638 }
639 
640 
641 // est funkcija ClaimTax (4el mozhet polu4it tax) kotoraja mozhet bqt vqpolnena drugim kontraktom esli nado (dlja buduwego kontrakta)
642 interface IStaking {
643   function getAccumulatedAmount(address staker) external view returns (uint256);
644 }
645 
646 contract MAL is ERC20, ReentrancyGuard, Ownable {
647     IStaking public STAKING;
648 
649     uint256 public MAX_SUPPLY;
650     bool public tokenCapSet;
651 
652     uint256 public spendTaxAmount;
653     bool public spendTaxCollectionStopped;
654     uint256 public withdrawTaxPercent;
655     bool public withdrawTaxCollectionStopped;
656 
657     uint256 public totalTaxCollected; // on withdraw & spend (can be claimed)
658     uint256 public totalClaimedTax; // how many MAL has been claimed
659 
660     bool public isPaused; // deposit, withdraw, transfer
661     bool public isDepositPaused;
662     bool public isWithdrawPaused;
663     bool public isTransferPaused;
664 
665     mapping (address => bool) private _isAuthorised;
666     address[] public authorisedLog;
667 
668     mapping(address => uint256) public depositedAmount;
669     mapping(address => uint256) public spentAmount;
670 
671     uint256 public moonRoyaleTicketPrice;
672 
673     modifier onlyAuthorised {
674       require(_isAuthorised[_msgSender()], "Not Authorised");
675       _;
676     }
677 
678     modifier whenNotPaused {
679       require(!isPaused, "Transfers paused!");
680       _;
681     }
682 
683     event Withdraw(address indexed userAddress, uint256 amount, uint256 tax);
684     event Deposit(address indexed userAddress, uint256 amount);
685     event DepositFor(address indexed caller, address indexed userAddress, uint256 amount);
686     event Spend(address indexed caller, address indexed userAddress, uint256 amount, uint256 tax);
687     event ClaimTax(address indexed caller, address indexed userAddress, uint256 amount);
688     event InternalTransfer(address indexed from, address indexed to, uint256 amount);
689     event RoyaleTicketsPurchase(address indexed buyer, uint256 amount);
690 
691     constructor(address _staking) ERC20("Moon Ape Lab", "MAL") {
692       _isAuthorised[_msgSender()] = true;
693       isPaused = true;
694       isTransferPaused = true;
695       isWithdrawPaused = true;
696 
697       withdrawTaxPercent = 30;
698       spendTaxAmount = 0;
699 
700       STAKING = IStaking(_staking);
701       _isAuthorised[_staking] = true;
702     }
703 
704     /**
705     * @dev Returns current spendable/withdrawable balance of a specific user. This balance can be spent by user for other collections purchase without
706     *      withdrawing to ERC-20 MAL or this balance can be withdrawn to ERC-20 MAL.
707     */
708     function getUserBalance(address user) public view returns (uint256) {
709       return (STAKING.getAccumulatedAmount(user) + depositedAmount[user] - spentAmount[user]);
710     }
711 
712     /**
713     * @dev Returns total deposited amount for address
714     */
715     function getUserSpentAmount(address user) public view returns (uint256) {
716       return spentAmount[user];
717     }
718 
719     /**
720     * @dev Returns total deposited amount for address
721     */
722     function getUserDepositedAmount(address user) public view returns (uint256) {
723       return depositedAmount[user];
724     }
725 
726     /**
727     * @dev Function to deposit ERC-20 MAL to the in-game balance in order to purchases other MOON APE LAB collections with in-game MAL tokens.
728     */
729     function depositMAL(uint256 amount) public nonReentrant whenNotPaused {
730       require(!isDepositPaused, "Deposit Paused");
731       require(balanceOf(_msgSender()) >= amount, "Insufficient balance");
732 
733       _burn(_msgSender(), amount);
734       depositedAmount[_msgSender()] += amount;
735 
736       emit Deposit(
737         _msgSender(),
738         amount
739       );
740     }
741 
742     /**
743     * @dev Function to withdraw in-game MAL to ERC-20 MAL.
744     */
745     function withdrawMAL(uint256 amount) public nonReentrant whenNotPaused {
746       require(!isWithdrawPaused, "Withdraw Paused");
747       require(getUserBalance(_msgSender()) >= amount, "Insufficient balance");
748       uint256 tax = withdrawTaxCollectionStopped ? 0 : (amount * withdrawTaxPercent) / 100;
749 
750       spentAmount[_msgSender()] += amount;
751       totalTaxCollected += tax;
752       _mint(_msgSender(), (amount - tax));
753 
754       emit Withdraw(
755         _msgSender(),
756         amount,
757         tax
758       );
759     }
760 
761     /**
762     * @dev Function to transfer game MAL from one account to another.
763     */
764     function transferMAL(address to, uint256 amount) public nonReentrant whenNotPaused {
765       require(!isTransferPaused, "Transfer Paused");
766       require(getUserBalance(_msgSender()) >= amount, "Insufficient balance");
767 
768       spentAmount[_msgSender()] += amount;
769       depositedAmount[to] += amount;
770 
771       emit InternalTransfer(
772         _msgSender(),
773         to,
774         amount
775       );
776     }
777 
778     function purchaseRoyaleTickets(uint256 ticketsAmount) public nonReentrant{
779       require(moonRoyaleTicketPrice > 0, "Moon Royale is not yet enabled");
780       require(ticketsAmount > 0, "Please purchase at least 1 Moon Royale Ticket");
781       uint256 totalPrice = moonRoyaleTicketPrice * ticketsAmount;
782       require(getUserBalance(_msgSender()) >= totalPrice, "Insufficient balance");
783       spentAmount[_msgSender()] += totalPrice;
784       emit RoyaleTicketsPurchase(_msgSender(), ticketsAmount);
785     }
786 
787     /**
788     * @dev Function to spend user balance. Can be called by other authorised contracts. To be used for internal purchases of other NFTs, etc.
789     */
790     function spendMAL(address user, uint256 amount) external onlyAuthorised nonReentrant {
791       require(getUserBalance(user) >= amount, "Insufficient balance");
792       uint256 tax = spendTaxCollectionStopped ? 0 : (amount * spendTaxAmount) / 100;
793 
794       spentAmount[user] += amount;
795       totalTaxCollected += tax;
796 
797       emit Spend(
798         _msgSender(),
799         user,
800         amount,
801         tax
802       );
803     }
804 
805     function _depositMALFor(address user, uint256 amount) internal {
806       require(user != address(0), "Deposit to 0 address");
807       depositedAmount[user] += amount;
808 
809       emit DepositFor(_msgSender(), user, amount);
810     }
811 
812     /**
813     * @dev Function to deposit tokens to a user balance. Can be only called by an authorised contracts.
814     */
815     function depositMALFor(address user, uint256 amount) public onlyAuthorised nonReentrant {
816       _depositMALFor(user, amount);
817     }
818 
819     /**
820     * @dev Function to mint tokens to a user balance. Can be only called by an authorised contracts.
821     */
822     function mintFor(address user, uint256 amount) external onlyAuthorised nonReentrant {
823       if (tokenCapSet) require(totalSupply() + amount <= MAX_SUPPLY, "You try to mint more than max supply");
824       _mint(user, amount);
825     }
826 
827      function giveMAL(address user, uint256 amount) public onlyOwner{
828       depositedAmount[user] += amount;
829     }
830 
831     /**
832     * @dev Function to claim tokens from the tax accumulated pot. Can be only called by an authorised contracts.
833     */
834     function claimMALTax(address user, uint256 amount) public onlyAuthorised nonReentrant {
835       require(totalTaxCollected >= amount, "Insufficiend tax balance");
836 
837       totalTaxCollected -= amount;
838       depositedAmount[user] += amount;
839       totalClaimedTax += amount;
840 
841       emit ClaimTax(
842         _msgSender(),
843         user,
844         amount
845       );
846     }
847 
848     /**
849     * @dev Function returns maxSupply set by contract owner. By default returns error (Max supply is not set).
850     */
851     function getMaxSupply() public view returns (uint256) {
852       require(tokenCapSet, "Max supply is not set");
853       return MAX_SUPPLY;
854     }
855 
856     /*
857       CONTRACT OWNER FUNCTIONS
858     */
859 
860     /**
861     * @dev Function allows contract owner to set total supply of MAL token.
862     */
863     function setTokenCap(uint256 tokenCup) public onlyOwner {
864       require(totalSupply() < tokenCup, "Value is smaller than the number of existing tokens");
865       require(!tokenCapSet, "Token cap has been already set");
866 
867       MAX_SUPPLY = tokenCup;
868     }
869 
870     /**
871     * @dev Function allows contract owner to add authorised address.
872     */
873     function authorise(address addressToAuth) public onlyOwner {
874       _isAuthorised[addressToAuth] = true;
875       authorisedLog.push(addressToAuth);
876     }
877 
878     /**
879     * @dev Function allows contract owner to add unauthorised address.
880     */
881     function unauthorise(address addressToUnAuth) public onlyOwner {
882       _isAuthorised[addressToUnAuth] = false;
883     }
884 
885     /**
886     * @dev Function allows contract owner update the address of staking address.
887     */
888     function updateMALStakingContract(address _staking_address) public onlyOwner {
889       STAKING = IStaking(_staking_address);
890       authorise(_staking_address);
891     }
892 
893     /**
894     * @dev Function allows contract owner to update limmit of tax on withdraw.
895     */
896     function updateWithdrawTaxPercent(uint256 _taxPercent) public onlyOwner {
897       require(_taxPercent <= 100, "Wrong value passed");
898       withdrawTaxPercent = _taxPercent;
899     }
900 
901     /**
902     * @dev Function allows contract owner to update tax amount on spend.
903     */
904     function updateSpendTaxAmount(uint256 _taxPercent) public onlyOwner {
905       require(_taxPercent <= 100, "Wrong value passed");
906       spendTaxAmount = _taxPercent;
907     }
908 
909     /**
910     * @dev Function allows contract owner to stop tax collection on withdraw.
911     */
912     function stopTaxCollectionOnWithdraw(bool _stop) public onlyOwner {
913       withdrawTaxCollectionStopped = _stop;
914     }
915 
916     /**
917     * @dev Function allows contract owner to stop tax collection on spend.
918     */
919     function stopTaxCollectionOnSpend(bool _stop) public onlyOwner {
920       spendTaxCollectionStopped = _stop;
921     }
922 
923     /**
924     * @dev Function allows contract owner to pause all in-game MAL transactions.
925     */
926     function pauseMAL(bool _to_pause) public onlyOwner {
927       isPaused = _to_pause;
928     }
929 
930     /**
931     * @dev Function allows contract owner to pause in game MAL transfers.
932     */
933     function pauseTransfers(bool _pause) public onlyOwner {
934       isTransferPaused = _pause;
935     }
936 
937     function setMoonRoyaleTicketPrice(uint256 _newPrice) public onlyOwner{
938       moonRoyaleTicketPrice = _newPrice;
939     }
940 
941     /**
942     * @dev Function allows contract owner to pause in game MAL withdraw.
943     */
944     function pauseWithdrawals(bool _pause) public onlyOwner {
945       isWithdrawPaused = _pause;
946     }
947 
948     /**
949     * @dev Function allows contract owner to pause in game MAL deposit.
950     */
951     function pauseDeposits(bool _pause) public onlyOwner {
952       isDepositPaused = _pause;
953     }
954 
955     /**
956     * @dev Function allows contract owner to withdraw ETH accidentally dropped to the contract.
957     */
958     function withdrawETH() external onlyOwner {
959       payable(owner()).transfer(address(this).balance);
960     }
961 }