1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Interface of the ERC20 standard as defined in the EIP.
9  */
10 interface IERC20 {
11     /**
12      * @dev Returns the amount of tokens in existence.
13      */
14     function totalSupply() external view returns (uint256);
15 
16     /**
17      * @dev Returns the amount of tokens owned by `account`.
18      */
19     function balanceOf(address account) external view returns (uint256);
20 
21     /**
22      * @dev Moves `amount` tokens from the caller's account to `recipient`.
23      *
24      * Returns a boolean value indicating whether the operation succeeded.
25      *
26      * Emits a {Transfer} event.
27      */
28     function transfer(address recipient, uint256 amount) external returns (bool);
29 
30     /**
31      * @dev Returns the remaining number of tokens that `spender` will be
32      * allowed to spend on behalf of `owner` through {transferFrom}. This is
33      * zero by default.
34      *
35      * This value changes when {approve} or {transferFrom} are called.
36      */
37     function allowance(address owner, address spender) external view returns (uint256);
38 
39     /**
40      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * IMPORTANT: Beware that changing an allowance with this method brings the risk
45      * that someone may use both the old and the new allowance by unfortunate
46      * transaction ordering. One possible solution to mitigate this race
47      * condition is to first reduce the spender's allowance to 0 and set the
48      * desired value afterwards:
49      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
50      *
51      * Emits an {Approval} event.
52      */
53     function approve(address spender, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Moves `amount` tokens from `sender` to `recipient` using the
57      * allowance mechanism. `amount` is then deducted from the caller's
58      * allowance.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * Emits a {Transfer} event.
63      */
64     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Emitted when `value` tokens are moved from one account (`from`) to
68      * another (`to`).
69      *
70      * Note that `value` may be zero.
71      */
72     event Transfer(address indexed from, address indexed to, uint256 value);
73 
74     /**
75      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
76      * a call to {approve}. `value` is the new allowance.
77      */
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 // File: @openzeppelin/contracts/utils/Context.sol
82 
83 pragma solidity ^0.8.0;
84 
85 /*
86  * @dev Provides information about the current execution context, including the
87  * sender of the transaction and its data. While these are generally available
88  * via msg.sender and msg.data, they should not be accessed in such a direct
89  * manner, since when dealing with meta-transactions the account sending and
90  * paying for execution may not be the actual sender (as far as an application
91  * is concerned).
92  *
93  * This contract is only required for intermediate, library-like contracts.
94  */
95 abstract contract Context {
96     function _msgSender() internal view virtual returns (address) {
97         return msg.sender;
98     }
99 
100     function _msgData() internal view virtual returns (bytes calldata) {
101         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
102         return msg.data;
103     }
104 }
105 
106 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
107 
108 pragma solidity ^0.8.0;
109 
110 
111 
112 /**
113  * @dev Implementation of the {IERC20} interface.
114  *
115  * This implementation is agnostic to the way tokens are created. This means
116  * that a supply mechanism has to be added in a derived contract using {_mint}.
117  * For a generic mechanism see {ERC20PresetMinterPauser}.
118  *
119  * TIP: For a detailed writeup see our guide
120  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
121  * to implement supply mechanisms].
122  *
123  * We have followed general OpenZeppelin guidelines: functions revert instead
124  * of returning `false` on failure. This behavior is nonetheless conventional
125  * and does not conflict with the expectations of ERC20 applications.
126  *
127  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
128  * This allows applications to reconstruct the allowance for all accounts just
129  * by listening to said events. Other implementations of the EIP may not emit
130  * these events, as it isn't required by the specification.
131  *
132  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
133  * functions have been added to mitigate the well-known issues around setting
134  * allowances. See {IERC20-approve}.
135  */
136 contract ERC20 is Context, IERC20 {
137     mapping (address => uint256) private _balances;
138 
139     mapping (address => mapping (address => uint256)) private _allowances;
140 
141     uint256 private _totalSupply;
142 
143     string private _name;
144     string private _symbol;
145 
146     uint8 private _setDecimals;
147 
148     /**
149      * @dev Sets the values for {name} and {symbol}.
150      *
151      * The defaut value of {decimals} is 18. To select a different value for
152      * {decimals} you should overload it.
153      *
154      * All three of these values are immutable: they can only be set once during
155      * construction.
156      */
157     constructor (string memory name_, string memory symbol_, uint8 decimals_) {
158         _name = name_;
159         _symbol = symbol_;
160         setDecimals(decimals_);
161     }
162 
163     /**
164      * @dev Returns the name of the token.
165      */
166     function name() public view virtual returns (string memory) {
167         return _name;
168     }
169 
170     /**
171      * @dev Returns the symbol of the token, usually a shorter version of the
172      * name.
173      */
174     function symbol() public view virtual returns (string memory) {
175         return _symbol;
176     }
177 
178     /**
179      * @dev Returns the number of decimals used to get its user representation.
180      * For example, if `decimals` equals `2`, a balance of `505` tokens should
181      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
182      *
183      * Tokens usually opt for a value of 18, imitating the relationship between
184      * Ether and Wei. This is the value {ERC20} uses, unless this function is
185      * overloaded;
186      *
187      * NOTE: This information is only used for _display_ purposes: it in
188      * no way affects any of the arithmetic of the contract, including
189      * {IERC20-balanceOf} and {IERC20-transfer}.
190      */
191     function decimals() public view virtual returns (uint8) {
192         return _setDecimals;
193     }
194 
195 
196     /**
197     * Set decimals for contract
198     */
199     function setDecimals(uint8 _decimals) private returns (bool){
200         _setDecimals = _decimals;
201         return true;
202     }
203 
204 
205     /**
206      * @dev See {IERC20-totalSupply}.
207      */
208     function totalSupply() public view virtual override returns (uint256) {
209         return _totalSupply;
210     }
211 
212     /**
213      * @dev See {IERC20-balanceOf}.
214      */
215     function balanceOf(address account) public view virtual override returns (uint256) {
216         return _balances[account];
217     }
218 
219     /**
220      * @dev See {IERC20-transfer}.
221      *
222      * Requirements:
223      *
224      * - `recipient` cannot be the zero address.
225      * - the caller must have a balance of at least `amount`.
226      */
227     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
228         _transfer(_msgSender(), recipient, amount);
229         return true;
230     }
231 
232     /**
233      * @dev See {IERC20-allowance}.
234      */
235     function allowance(address owner, address spender) public view virtual override returns (uint256) {
236         return _allowances[owner][spender];
237     }
238 
239     /**
240      * @dev See {IERC20-approve}.
241      *
242      * Requirements:
243      *
244      * - `spender` cannot be the zero address.
245      */
246     function approve(address spender, uint256 amount) public virtual override returns (bool) {
247         _approve(_msgSender(), spender, amount);
248         return true;
249     }
250 
251     /**
252      * @dev See {IERC20-transferFrom}.
253      *
254      * Emits an {Approval} event indicating the updated allowance. This is not
255      * required by the EIP. See the note at the beginning of {ERC20}.
256      *
257      * Requirements:
258      *
259      * - `sender` and `recipient` cannot be the zero address.
260      * - `sender` must have a balance of at least `amount`.
261      * - the caller must have allowance for ``sender``'s tokens of at least
262      * `amount`.
263      */
264     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
265         _transfer(sender, recipient, amount);
266 
267         uint256 currentAllowance = _allowances[sender][_msgSender()];
268         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
269         _approve(sender, _msgSender(), currentAllowance - amount);
270 
271         return true;
272     }
273 
274     /**
275      * @dev Atomically increases the allowance granted to `spender` by the caller.
276      *
277      * This is an alternative to {approve} that can be used as a mitigation for
278      * problems described in {IERC20-approve}.
279      *
280      * Emits an {Approval} event indicating the updated allowance.
281      *
282      * Requirements:
283      *
284      * - `spender` cannot be the zero address.
285      */
286     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
287         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
288         return true;
289     }
290 
291     /**
292      * @dev Atomically decreases the allowance granted to `spender` by the caller.
293      *
294      * This is an alternative to {approve} that can be used as a mitigation for
295      * problems described in {IERC20-approve}.
296      *
297      * Emits an {Approval} event indicating the updated allowance.
298      *
299      * Requirements:
300      *
301      * - `spender` cannot be the zero address.
302      * - `spender` must have allowance for the caller of at least
303      * `subtractedValue`.
304      */
305     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
306         uint256 currentAllowance = _allowances[_msgSender()][spender];
307         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
308         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
309 
310         return true;
311     }
312 
313     /**
314      * @dev Moves tokens `amount` from `sender` to `recipient`.
315      *
316      * This is internal function is equivalent to {transfer}, and can be used to
317      * e.g. implement automatic token fees, slashing mechanisms, etc.
318      *
319      * Emits a {Transfer} event.
320      *
321      * Requirements:
322      *
323      * - `sender` cannot be the zero address.
324      * - `recipient` cannot be the zero address.
325      * - `sender` must have a balance of at least `amount`.
326      */
327     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
328         require(sender != address(0), "ERC20: transfer from the zero address");
329         require(recipient != address(0), "ERC20: transfer to the zero address");
330 
331         _beforeTokenTransfer(sender, recipient, amount);
332 
333         uint256 senderBalance = _balances[sender];
334         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
335         _balances[sender] = senderBalance - amount;
336         _balances[recipient] += amount;
337 
338         emit Transfer(sender, recipient, amount);
339     }
340 
341     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
342      * the total supply.
343      *
344      * Emits a {Transfer} event with `from` set to the zero address.
345      *
346      * Requirements:
347      *
348      * - `to` cannot be the zero address.
349      */
350     function _mint(address account, uint256 amount) internal virtual {
351         require(account != address(0), "ERC20: mint to the zero address");
352 
353         _beforeTokenTransfer(address(0), account, amount);
354 
355         _totalSupply += amount;
356         _balances[account] += amount;
357         emit Transfer(address(0), account, amount);
358     }
359 
360     /**
361     * Set contract total supply
362      */
363     function _setTotalSupply(uint256 totalSupply_) internal virtual{
364         _totalSupply = totalSupply_;
365     }
366 
367     /**
368     * Initially transfer tokens to multiple addresses
369      */
370     function _initialTransfer(address account, uint256 amount) internal virtual {
371         require(account != address(0), "ERC20: mint to the zero address");
372         _beforeTokenTransfer(address(0), account, amount);
373         _balances[account] += amount;
374         emit Transfer(address(0), account, amount);
375     }
376 
377     /**
378      * @dev Destroys `amount` tokens from `account`, reducing the
379      * total supply.
380      *
381      * Emits a {Transfer} event with `to` set to the zero address.
382      *
383      * Requirements:
384      *
385      * - `account` cannot be the zero address.
386      * - `account` must have at least `amount` tokens.
387      */
388     function _burn(address account, uint256 amount) internal virtual {
389         require(account != address(0), "ERC20: burn from the zero address");
390 
391         _beforeTokenTransfer(account, address(0), amount);
392 
393         uint256 accountBalance = _balances[account];
394         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
395         _balances[account] = accountBalance - amount;
396         _totalSupply -= amount;
397 
398         emit Transfer(account, address(0), amount);
399     }
400 
401     /**
402      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
403      *
404      * This internal function is equivalent to `approve`, and can be used to
405      * e.g. set automatic allowances for certain subsystems, etc.
406      *
407      * Emits an {Approval} event.
408      *
409      * Requirements:
410      *
411      * - `owner` cannot be the zero address.
412      * - `spender` cannot be the zero address.
413      */
414     function _approve(address owner, address spender, uint256 amount) internal virtual {
415         require(owner != address(0), "ERC20: approve from the zero address");
416         require(spender != address(0), "ERC20: approve to the zero address");
417 
418         _allowances[owner][spender] = amount;
419         emit Approval(owner, spender, amount);
420     }
421 
422     /**
423      * @dev Hook that is called before any transfer of tokens. This includes
424      * minting and burning.
425      *
426      * Calling conditions:
427      *
428      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
429      * will be to transferred to `to`.
430      * - when `from` is zero, `amount` tokens will be minted for `to`.
431      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
432      * - `from` and `to` are never both zero.
433      *
434      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
435      */
436     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
437 }
438 
439 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
440 
441 pragma solidity ^0.8.0;
442 
443 
444 
445 /**
446  * @dev Extension of {ERC20} that allows token holders to destroy both their own
447  * tokens and those that they have an allowance for, in a way that can be
448  * recognized off-chain (via event analysis).
449  */
450 abstract contract ERC20Burnable is Context, ERC20 {
451     /**
452      * @dev Destroys `amount` tokens from the caller.
453      *
454      * See {ERC20-_burn}.
455      */
456     function burn(uint256 amount) public virtual {
457         _burn(_msgSender(), amount);
458     }
459 
460     /**
461      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
462      * allowance.
463      *
464      * See {ERC20-_burn} and {ERC20-allowance}.
465      *
466      * Requirements:
467      *
468      * - the caller must have allowance for ``accounts``'s tokens of at least
469      * `amount`.
470      */
471     function burnFrom(address account, uint256 amount) public virtual {
472         uint256 currentAllowance = allowance(account, _msgSender());
473         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
474         _approve(account, _msgSender(), currentAllowance - amount);
475         _burn(account, amount);
476     }
477 }
478 
479 // File: @openzeppelin/contracts/security/Pausable.sol
480 
481 pragma solidity ^0.8.0;
482 
483 
484 /**
485  * @dev Contract module which allows children to implement an emergency stop
486  * mechanism that can be triggered by an authorized account.
487  *
488  * This module is used through inheritance. It will make available the
489  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
490  * the functions of your contract. Note that they will not be pausable by
491  * simply including this module, only once the modifiers are put in place.
492  */
493 abstract contract Pausable is Context {
494     /**
495      * @dev Emitted when the pause is triggered by `account`.
496      */
497     event Paused(address account);
498 
499     /**
500      * @dev Emitted when the pause is lifted by `account`.
501      */
502     event Unpaused(address account);
503 
504     bool private _paused;
505 
506     /**
507      * @dev Initializes the contract in unpaused state.
508      */
509     constructor () {
510         _paused = false;
511     }
512 
513     /**
514      * @dev Returns true if the contract is paused, and false otherwise.
515      */
516     function paused() public view virtual returns (bool) {
517         return _paused;
518     }
519 
520     /**
521      * @dev Modifier to make a function callable only when the contract is not paused.
522      *
523      * Requirements:
524      *
525      * - The contract must not be paused.
526      */
527     modifier whenNotPaused() {
528         require(!paused(), "Pausable: paused");
529         _;
530     }
531 
532     /**
533      * @dev Modifier to make a function callable only when the contract is paused.
534      *
535      * Requirements:
536      *
537      * - The contract must be paused.
538      */
539     modifier whenPaused() {
540         require(paused(), "Pausable: not paused");
541         _;
542     }
543 
544     /**
545      * @dev Triggers stopped state.
546      *
547      * Requirements:
548      *
549      * - The contract must not be paused.
550      */
551     function _pause() internal virtual whenNotPaused {
552         _paused = true;
553         emit Paused(_msgSender());
554     }
555 
556     /**
557      * @dev Returns to normal state.
558      *
559      * Requirements:
560      *
561      * - The contract must be paused.
562      */
563     function _unpause() internal virtual whenPaused {
564         _paused = false;
565         emit Unpaused(_msgSender());
566     }
567 }
568 
569 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol
570 
571 pragma solidity ^0.8.0;
572 
573 
574 
575 /**
576  * @dev ERC20 token with pausable token transfers, minting and burning.
577  *
578  * Useful for scenarios such as preventing trades until the end of an evaluation
579  * period, or having an emergency switch for freezing all token transfers in the
580  * event of a large bug.
581  */
582 abstract contract ERC20Pausable is ERC20, Pausable {
583     /**
584      * @dev See {ERC20-_beforeTokenTransfer}.
585      *
586      * Requirements:
587      *
588      * - the contract must not be paused.
589      */
590     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
591         super._beforeTokenTransfer(from, to, amount);
592 
593         require(!paused(), "ERC20Pausable: token transfer while paused");
594     }
595 }
596 
597 // File: @openzeppelin/contracts/access/Ownable.sol
598 
599 pragma solidity ^0.8.0;
600 
601 /**
602  * @dev Contract module which provides a basic access control mechanism, where
603  * there is an account (an owner) that can be granted exclusive access to
604  * specific functions.
605  *
606  * By default, the owner account will be the one that deploys the contract. This
607  * can later be changed with {transferOwnership}.
608  *
609  * This module is used through inheritance. It will make available the modifier
610  * `onlyOwner`, which can be applied to your functions to restrict their use to
611  * the owner.
612  */
613 abstract contract Ownable is Context {
614     address private _owner;
615 
616     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
617 
618     /**
619      * @dev Initializes the contract setting the deployer as the initial owner.
620      */
621     constructor () {
622         address msgSender = _msgSender();
623         _owner = msgSender;
624         emit OwnershipTransferred(address(0), msgSender);
625     }
626 
627     /**
628      * @dev Returns the address of the current owner.
629      */
630     function owner() public view virtual returns (address) {
631         return _owner;
632     }
633 
634     /**
635      * @dev Throws if called by any account other than the owner.
636      */
637     modifier onlyOwner() {
638         require(owner() == _msgSender(), "Ownable: caller is not the owner");
639         _;
640     }
641 
642     /**
643      * @dev Leaves the contract without owner. It will not be possible to call
644      * `onlyOwner` functions anymore. Can only be called by the current owner.
645      *
646      * NOTE: Renouncing ownership will leave the contract without an owner,
647      * thereby removing any functionality that is only available to the owner.
648      */
649     function renounceOwnership() public virtual onlyOwner {
650         emit OwnershipTransferred(_owner, address(0));
651         _owner = address(0);
652     }
653 
654     /**
655      * @dev Transfers ownership of the contract to a new account (`newOwner`).
656      * Can only be called by the current owner.
657      */
658     function transferOwnership(address newOwner) public virtual onlyOwner {
659         require(newOwner != address(0), "Ownable: new owner is the zero address");
660         emit OwnershipTransferred(_owner, newOwner);
661         _owner = newOwner;
662     }
663 }
664 
665 // File: EurcxToken.sol
666 
667 pragma solidity ^0.8.0;
668 
669 contract EURCXToken is ERC20, ERC20Burnable, Ownable, ERC20Pausable {
670     constructor(
671         string memory name,
672         string memory symbol,
673         uint8 decimals,
674         uint256 tokenSupply
675     ) ERC20(name, symbol, decimals) {
676         uint256 decimalFactor = 10**uint256(decimals);
677         uint256 initialSupply = tokenSupply * decimalFactor;
678 
679         _setTotalSupply(initialSupply); // 100,000,000,000
680 
681         // Public Distribution
682         uint256 publicTokens = 32000000000; // 32%
683         _initialTransfer(
684             0x1285F027136069DfEfD22BaeD6aEb4c620bbbB60,
685             (publicTokens * decimalFactor)
686         );
687         // Private Distribution
688         uint256 privateTokens = 12500000000; // 12.5%
689         _initialTransfer(
690             0x35D09D8b54a884c0099Ea937fD573de7a9553e9c,
691             (privateTokens * decimalFactor)
692         );
693         // Marketing Team
694         uint256 marketingTokens = 6000000000; // 6%
695         _initialTransfer(
696             0x44485b9BA3549162A0a4dBD0e89829C9cC215B68,
697             (marketingTokens * decimalFactor)
698         );
699         // Financial Advisors
700         uint256 financialTokens = 6000000000; // 6%
701         _initialTransfer(
702             0xb04CDD882e7A31682103CF5dA79640B98A26193F,
703             (financialTokens * decimalFactor)
704         );
705         // Development Team
706         uint256 devTokens = 6000000000; // 6%
707         _initialTransfer(
708             0xc8605293281177eE1d55107D6Ff95A97d2641959,
709             (devTokens * decimalFactor)
710         );
711 
712         // Team and Advisors
713         uint256 teamTokens = 15000000000; // 15%
714         _initialTransfer(
715             0xDb0169cd9Ee09B6e8E2bAB9056663420b3964808,
716             (teamTokens * decimalFactor)
717         );
718 
719         // Strategic Initiatives
720         uint256 strategyTokens = 10000000000; // 10%
721         _initialTransfer(
722             0xD7a77aD899D8dfAf22F56FCECE491BB982ca3f37,
723             (strategyTokens * decimalFactor)
724         );
725 
726         // Strategic Ecosystem Grant Pool
727         uint256 ecosystemTokens = 12500000000; // 12.5%
728         _initialTransfer(
729             0xecd8E5049A880CDf555CF3f746b0fB52877D57A5,
730             (ecosystemTokens * decimalFactor)
731         );
732     }
733 
734     /**
735      * Pause/Unpause smart contract in case of emergency
736      */
737     function pause() public onlyOwner returns (bool) {
738         _pause();
739         return true;
740     }
741 
742     function unpause() public onlyOwner returns (bool) {
743         _unpause();
744         return true;
745     }
746 
747     /**
748      * Only contract owner can burn tokens
749      */
750 
751     function burn(uint256 amount) public override onlyOwner {
752         _burn(_msgSender(), amount);
753     }
754 
755     /**
756      * Mint new tokens
757      */
758     function mint(address account, uint256 amount)
759         public
760         onlyOwner
761         returns (bool)
762     {
763         _mint(account, amount);
764         return true;
765     }
766 
767     // hook to execute before every token transfer
768     function _beforeTokenTransfer(
769         address from,
770         address to,
771         uint256 amount
772     ) internal virtual override(ERC20, ERC20Pausable) {
773         super._beforeTokenTransfer(from, to, amount);
774     }
775 }