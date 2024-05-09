1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 //     __        _____   ______   ________ 
3 //   _|  \_     |     \ /      \ |        \
4 //  /   $$ \     \$$$$$|  $$$$$$\| $$$$$$$$
5 // |  $$$$$$\      | $$| $$  | $$| $$__    
6 // | $$___\$$ __   | $$| $$  | $$| $$  \   
7 //  \$$    \ |  \  | $$| $$  | $$| $$$$$   
8 //  _\$$$$$$\| $$__| $$| $$__/ $$| $$_____ 
9 // |  \__/ $$ \$$    $$ \$$    $$| $$     \
10 //  \$$    $$  \$$$$$$   \$$$$$$  \$$$$$$$$
11 //   \$$$$$$                               
12 //     \$$                                 
13 
14 // sleepyjoe.wtf
15 // https://t.me/sleepyjoeportal
16 // https://twitter.com/helpjoesleep
17 
18 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
19 
20 pragma solidity ^0.8.0;
21 
22 /**
23  * @dev Interface of the ERC20 standard as defined in the EIP.
24  */
25 interface IERC20 {
26     /**
27      * @dev Emitted when `value` tokens are moved from one account (`from`) to
28      * another (`to`).
29      *
30      * Note that `value` may be zero.
31      */
32     event Transfer(address indexed from, address indexed to, uint256 value);
33 
34     /**
35      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
36      * a call to {approve}. `value` is the new allowance.
37      */
38     event Approval(address indexed owner, address indexed spender, uint256 value);
39 
40     /**
41      * @dev Returns the amount of tokens in existence.
42      */
43     function totalSupply() external view returns (uint256);
44 
45     /**
46      * @dev Returns the amount of tokens owned by `account`.
47      */
48     function balanceOf(address account) external view returns (uint256);
49 
50     /**
51      * @dev Moves `amount` tokens from the caller's account to `to`.
52      *
53      * Returns a boolean value indicating whether the operation succeeded.
54      *
55      * Emits a {Transfer} event.
56      */
57     function transfer(address to, uint256 amount) external returns (bool);
58 
59     /**
60      * @dev Returns the remaining number of tokens that `spender` will be
61      * allowed to spend on behalf of `owner` through {transferFrom}. This is
62      * zero by default.
63      *
64      * This value changes when {approve} or {transferFrom} are called.
65      */
66     function allowance(address owner, address spender) external view returns (uint256);
67 
68     /**
69      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
70      *
71      * Returns a boolean value indicating whether the operation succeeded.
72      *
73      * IMPORTANT: Beware that changing an allowance with this method brings the risk
74      * that someone may use both the old and the new allowance by unfortunate
75      * transaction ordering. One possible solution to mitigate this race
76      * condition is to first reduce the spender's allowance to 0 and set the
77      * desired value afterwards:
78      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
79      *
80      * Emits an {Approval} event.
81      */
82     function approve(address spender, uint256 amount) external returns (bool);
83 
84     /**
85      * @dev Moves `amount` tokens from `from` to `to` using the
86      * allowance mechanism. `amount` is then deducted from the caller's
87      * allowance.
88      *
89      * Returns a boolean value indicating whether the operation succeeded.
90      *
91      * Emits a {Transfer} event.
92      */
93     function transferFrom(
94         address from,
95         address to,
96         uint256 amount
97     ) external returns (bool);
98 }
99 
100 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
101 
102 
103 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
104 
105 pragma solidity ^0.8.0;
106 
107 
108 /**
109  * @dev Interface for the optional metadata functions from the ERC20 standard.
110  *
111  * _Available since v4.1._
112  */
113 interface IERC20Metadata is IERC20 {
114     /**
115      * @dev Returns the name of the token.
116      */
117     function name() external view returns (string memory);
118 
119     /**
120      * @dev Returns the symbol of the token.
121      */
122     function symbol() external view returns (string memory);
123 
124     /**
125      * @dev Returns the decimals places of the token.
126      */
127     function decimals() external view returns (uint8);
128 }
129 
130 // File: @openzeppelin/contracts/utils/Context.sol
131 
132 
133 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
134 
135 pragma solidity ^0.8.0;
136 
137 /**
138  * @dev Provides information about the current execution context, including the
139  * sender of the transaction and its data. While these are generally available
140  * via msg.sender and msg.data, they should not be accessed in such a direct
141  * manner, since when dealing with meta-transactions the account sending and
142  * paying for execution may not be the actual sender (as far as an application
143  * is concerned).
144  *
145  * This contract is only required for intermediate, library-like contracts.
146  */
147 abstract contract Context {
148     function _msgSender() internal view virtual returns (address) {
149         return msg.sender;
150     }
151 
152     function _msgData() internal view virtual returns (bytes calldata) {
153         return msg.data;
154     }
155 }
156 
157 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
158 
159 
160 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
161 
162 pragma solidity ^0.8.0;
163 
164 
165 
166 
167 /**
168  * @dev Implementation of the {IERC20} interface.
169  *
170  * This implementation is agnostic to the way tokens are created. This means
171  * that a supply mechanism has to be added in a derived contract using {_mint}.
172  * For a generic mechanism see {ERC20PresetMinterPauser}.
173  *
174  * TIP: For a detailed writeup see our guide
175  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
176  * to implement supply mechanisms].
177  *
178  * We have followed general OpenZeppelin Contracts guidelines: functions revert
179  * instead returning `false` on failure. This behavior is nonetheless
180  * conventional and does not conflict with the expectations of ERC20
181  * applications.
182  *
183  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
184  * This allows applications to reconstruct the allowance for all accounts just
185  * by listening to said events. Other implementations of the EIP may not emit
186  * these events, as it isn't required by the specification.
187  *
188  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
189  * functions have been added to mitigate the well-known issues around setting
190  * allowances. See {IERC20-approve}.
191  */
192 contract ERC20 is Context, IERC20, IERC20Metadata {
193     mapping(address => uint256) private _balances;
194 
195     mapping(address => mapping(address => uint256)) private _allowances;
196 
197     uint256 private _totalSupply;
198 
199     string private _name;
200     string private _symbol;
201 
202     /**
203      * @dev Sets the values for {name} and {symbol}.
204      *
205      * The default value of {decimals} is 18. To select a different value for
206      * {decimals} you should overload it.
207      *
208      * All two of these values are immutable: they can only be set once during
209      * construction.
210      */
211     constructor(string memory name_, string memory symbol_) {
212         _name = name_;
213         _symbol = symbol_;
214     }
215 
216     /**
217      * @dev Returns the name of the token.
218      */
219     function name() public view virtual override returns (string memory) {
220         return _name;
221     }
222 
223     /**
224      * @dev Returns the symbol of the token, usually a shorter version of the
225      * name.
226      */
227     function symbol() public view virtual override returns (string memory) {
228         return _symbol;
229     }
230 
231     /**
232      * @dev Returns the number of decimals used to get its user representation.
233      * For example, if `decimals` equals `2`, a balance of `505` tokens should
234      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
235      *
236      * Tokens usually opt for a value of 18, imitating the relationship between
237      * Ether and Wei. This is the value {ERC20} uses, unless this function is
238      * overridden;
239      *
240      * NOTE: This information is only used for _display_ purposes: it in
241      * no way affects any of the arithmetic of the contract, including
242      * {IERC20-balanceOf} and {IERC20-transfer}.
243      */
244     function decimals() public view virtual override returns (uint8) {
245         return 18;
246     }
247 
248     /**
249      * @dev See {IERC20-totalSupply}.
250      */
251     function totalSupply() public view virtual override returns (uint256) {
252         return _totalSupply;
253     }
254 
255     /**
256      * @dev See {IERC20-balanceOf}.
257      */
258     function balanceOf(address account) public view virtual override returns (uint256) {
259         return _balances[account];
260     }
261 
262     /**
263      * @dev See {IERC20-transfer}.
264      *
265      * Requirements:
266      *
267      * - `to` cannot be the zero address.
268      * - the caller must have a balance of at least `amount`.
269      */
270     function transfer(address to, uint256 amount) public virtual override returns (bool) {
271         address owner = _msgSender();
272         _transfer(owner, to, amount);
273         return true;
274     }
275 
276     /**
277      * @dev See {IERC20-allowance}.
278      */
279     function allowance(address owner, address spender) public view virtual override returns (uint256) {
280         return _allowances[owner][spender];
281     }
282 
283     /**
284      * @dev See {IERC20-approve}.
285      *
286      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
287      * `transferFrom`. This is semantically equivalent to an infinite approval.
288      *
289      * Requirements:
290      *
291      * - `spender` cannot be the zero address.
292      */
293     function approve(address spender, uint256 amount) public virtual override returns (bool) {
294         address owner = _msgSender();
295         _approve(owner, spender, amount);
296         return true;
297     }
298 
299     /**
300      * @dev See {IERC20-transferFrom}.
301      *
302      * Emits an {Approval} event indicating the updated allowance. This is not
303      * required by the EIP. See the note at the beginning of {ERC20}.
304      *
305      * NOTE: Does not update the allowance if the current allowance
306      * is the maximum `uint256`.
307      *
308      * Requirements:
309      *
310      * - `from` and `to` cannot be the zero address.
311      * - `from` must have a balance of at least `amount`.
312      * - the caller must have allowance for ``from``'s tokens of at least
313      * `amount`.
314      */
315     function transferFrom(
316         address from,
317         address to,
318         uint256 amount
319     ) public virtual override returns (bool) {
320         address spender = _msgSender();
321         _spendAllowance(from, spender, amount);
322         _transfer(from, to, amount);
323         return true;
324     }
325 
326     /**
327      * @dev Atomically increases the allowance granted to `spender` by the caller.
328      *
329      * This is an alternative to {approve} that can be used as a mitigation for
330      * problems described in {IERC20-approve}.
331      *
332      * Emits an {Approval} event indicating the updated allowance.
333      *
334      * Requirements:
335      *
336      * - `spender` cannot be the zero address.
337      */
338     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
339         address owner = _msgSender();
340         _approve(owner, spender, allowance(owner, spender) + addedValue);
341         return true;
342     }
343 
344     /**
345      * @dev Atomically decreases the allowance granted to `spender` by the caller.
346      *
347      * This is an alternative to {approve} that can be used as a mitigation for
348      * problems described in {IERC20-approve}.
349      *
350      * Emits an {Approval} event indicating the updated allowance.
351      *
352      * Requirements:
353      *
354      * - `spender` cannot be the zero address.
355      * - `spender` must have allowance for the caller of at least
356      * `subtractedValue`.
357      */
358     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
359         address owner = _msgSender();
360         uint256 currentAllowance = allowance(owner, spender);
361         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
362         unchecked {
363             _approve(owner, spender, currentAllowance - subtractedValue);
364         }
365 
366         return true;
367     }
368 
369     /**
370      * @dev Moves `amount` of tokens from `from` to `to`.
371      *
372      * This internal function is equivalent to {transfer}, and can be used to
373      * e.g. implement automatic token fees, slashing mechanisms, etc.
374      *
375      * Emits a {Transfer} event.
376      *
377      * Requirements:
378      *
379      * - `from` cannot be the zero address.
380      * - `to` cannot be the zero address.
381      * - `from` must have a balance of at least `amount`.
382      */
383     function _transfer(
384         address from,
385         address to,
386         uint256 amount
387     ) internal virtual {
388         require(from != address(0), "ERC20: transfer from the zero address");
389         require(to != address(0), "ERC20: transfer to the zero address");
390 
391         _beforeTokenTransfer(from, to, amount);
392 
393         uint256 fromBalance = _balances[from];
394         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
395         unchecked {
396             _balances[from] = fromBalance - amount;
397             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
398             // decrementing then incrementing.
399             _balances[to] += amount;
400         }
401 
402         emit Transfer(from, to, amount);
403 
404         _afterTokenTransfer(from, to, amount);
405     }
406 
407     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
408      * the total supply.
409      *
410      * Emits a {Transfer} event with `from` set to the zero address.
411      *
412      * Requirements:
413      *
414      * - `account` cannot be the zero address.
415      */
416     function _mint(address account, uint256 amount) internal virtual {
417         require(account != address(0), "ERC20: mint to the zero address");
418 
419         _beforeTokenTransfer(address(0), account, amount);
420 
421         _totalSupply += amount;
422         unchecked {
423             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
424             _balances[account] += amount;
425         }
426         emit Transfer(address(0), account, amount);
427 
428         _afterTokenTransfer(address(0), account, amount);
429     }
430 
431     /**
432      * @dev Destroys `amount` tokens from `account`, reducing the
433      * total supply.
434      *
435      * Emits a {Transfer} event with `to` set to the zero address.
436      *
437      * Requirements:
438      *
439      * - `account` cannot be the zero address.
440      * - `account` must have at least `amount` tokens.
441      */
442     function _burn(address account, uint256 amount) internal virtual {
443         require(account != address(0), "ERC20: burn from the zero address");
444 
445         _beforeTokenTransfer(account, address(0), amount);
446 
447         uint256 accountBalance = _balances[account];
448         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
449         unchecked {
450             _balances[account] = accountBalance - amount;
451             // Overflow not possible: amount <= accountBalance <= totalSupply.
452             _totalSupply -= amount;
453         }
454 
455         emit Transfer(account, address(0), amount);
456 
457         _afterTokenTransfer(account, address(0), amount);
458     }
459 
460     /**
461      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
462      *
463      * This internal function is equivalent to `approve`, and can be used to
464      * e.g. set automatic allowances for certain subsystems, etc.
465      *
466      * Emits an {Approval} event.
467      *
468      * Requirements:
469      *
470      * - `owner` cannot be the zero address.
471      * - `spender` cannot be the zero address.
472      */
473     function _approve(
474         address owner,
475         address spender,
476         uint256 amount
477     ) internal virtual {
478         require(owner != address(0), "ERC20: approve from the zero address");
479         require(spender != address(0), "ERC20: approve to the zero address");
480 
481         _allowances[owner][spender] = amount;
482         emit Approval(owner, spender, amount);
483     }
484 
485     /**
486      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
487      *
488      * Does not update the allowance amount in case of infinite allowance.
489      * Revert if not enough allowance is available.
490      *
491      * Might emit an {Approval} event.
492      */
493     function _spendAllowance(
494         address owner,
495         address spender,
496         uint256 amount
497     ) internal virtual {
498         uint256 currentAllowance = allowance(owner, spender);
499         if (currentAllowance != type(uint256).max) {
500             require(currentAllowance >= amount, "ERC20: insufficient allowance");
501             unchecked {
502                 _approve(owner, spender, currentAllowance - amount);
503             }
504         }
505     }
506 
507     /**
508      * @dev Hook that is called before any transfer of tokens. This includes
509      * minting and burning.
510      *
511      * Calling conditions:
512      *
513      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
514      * will be transferred to `to`.
515      * - when `from` is zero, `amount` tokens will be minted for `to`.
516      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
517      * - `from` and `to` are never both zero.
518      *
519      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
520      */
521     function _beforeTokenTransfer(
522         address from,
523         address to,
524         uint256 amount
525     ) internal virtual {}
526 
527     /**
528      * @dev Hook that is called after any transfer of tokens. This includes
529      * minting and burning.
530      *
531      * Calling conditions:
532      *
533      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
534      * has been transferred to `to`.
535      * - when `from` is zero, `amount` tokens have been minted for `to`.
536      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
537      * - `from` and `to` are never both zero.
538      *
539      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
540      */
541     function _afterTokenTransfer(
542         address from,
543         address to,
544         uint256 amount
545     ) internal virtual {}
546 }
547 
548 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
549 
550 
551 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)
552 
553 pragma solidity ^0.8.0;
554 
555 
556 
557 /**
558  * @dev Extension of {ERC20} that allows token holders to destroy both their own
559  * tokens and those that they have an allowance for, in a way that can be
560  * recognized off-chain (via event analysis).
561  */
562 abstract contract ERC20Burnable is Context, ERC20 {
563     /**
564      * @dev Destroys `amount` tokens from the caller.
565      *
566      * See {ERC20-_burn}.
567      */
568     function burn(uint256 amount) public virtual {
569         _burn(_msgSender(), amount);
570     }
571 
572     /**
573      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
574      * allowance.
575      *
576      * See {ERC20-_burn} and {ERC20-allowance}.
577      *
578      * Requirements:
579      *
580      * - the caller must have allowance for ``accounts``'s tokens of at least
581      * `amount`.
582      */
583     function burnFrom(address account, uint256 amount) public virtual {
584         _spendAllowance(account, _msgSender(), amount);
585         _burn(account, amount);
586     }
587 }
588 
589 // File: @openzeppelin/contracts/access/Ownable.sol
590 
591 
592 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
593 
594 pragma solidity ^0.8.0;
595 
596 
597 /**
598  * @dev Contract module which provides a basic access control mechanism, where
599  * there is an account (an owner) that can be granted exclusive access to
600  * specific functions.
601  *
602  * By default, the owner account will be the one that deploys the contract. This
603  * can later be changed with {transferOwnership}.
604  *
605  * This module is used through inheritance. It will make available the modifier
606  * `onlyOwner`, which can be applied to your functions to restrict their use to
607  * the owner.
608  */
609 abstract contract Ownable is Context {
610     address private _owner;
611 
612     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
613 
614     /**
615      * @dev Initializes the contract setting the deployer as the initial owner.
616      */
617     constructor() {
618         _transferOwnership(_msgSender());
619     }
620 
621     /**
622      * @dev Throws if called by any account other than the owner.
623      */
624     modifier onlyOwner() {
625         _checkOwner();
626         _;
627     }
628 
629     /**
630      * @dev Returns the address of the current owner.
631      */
632     function owner() public view virtual returns (address) {
633         return _owner;
634     }
635 
636     /**
637      * @dev Throws if the sender is not the owner.
638      */
639     function _checkOwner() internal view virtual {
640         require(owner() == _msgSender(), "Ownable: caller is not the owner");
641     }
642 
643     /**
644      * @dev Leaves the contract without owner. It will not be possible to call
645      * `onlyOwner` functions anymore. Can only be called by the current owner.
646      *
647      * NOTE: Renouncing ownership will leave the contract without an owner,
648      * thereby removing any functionality that is only available to the owner.
649      */
650     function renounceOwnership() public virtual onlyOwner {
651         _transferOwnership(address(0));
652     }
653 
654     /**
655      * @dev Transfers ownership of the contract to a new account (`newOwner`).
656      * Can only be called by the current owner.
657      */
658     function transferOwnership(address newOwner) public virtual onlyOwner {
659         require(newOwner != address(0), "Ownable: new owner is the zero address");
660         _transferOwnership(newOwner);
661     }
662 
663     /**
664      * @dev Transfers ownership of the contract to a new account (`newOwner`).
665      * Internal function without access restriction.
666      */
667     function _transferOwnership(address newOwner) internal virtual {
668         address oldOwner = _owner;
669         _owner = newOwner;
670         emit OwnershipTransferred(oldOwner, newOwner);
671     }
672 }
673 
674 // File: TESTINGREMOVELINE37T040.sol
675 
676 
677 
678 
679 
680 
681 pragma solidity ^0.8.0;
682 
683 contract SleepyJoeCoin is Ownable, ERC20 {
684     bool public limited;
685     uint256 public maxHoldingAmount;
686     uint256 public minHoldingAmount;
687     address public uniswapV2Pair;
688     mapping(address => bool) public blacklists;
689     
690     constructor() ERC20("SleepyJoe", "JOE") {
691         _mint(msg.sender, 80000000000000000000000000000000);
692     }
693 
694     function toggleLimited() external onlyOwner{
695         limited = !limited;
696     }
697     
698     function blacklist(address _address, bool _isBlacklisting) external onlyOwner {
699         blacklists[_address] = _isBlacklisting;
700     }
701 
702     function setRule(bool _limited, address _uniswapV2Pair, uint256 _maxHoldingAmount, uint256 _minHoldingAmount) external onlyOwner {
703         limited = _limited;
704         uniswapV2Pair = _uniswapV2Pair;
705         maxHoldingAmount = _maxHoldingAmount;
706         minHoldingAmount = _minHoldingAmount;
707     }
708 
709     function _beforeTokenTransfer(
710         address from,
711         address to,
712         uint256 amount
713     ) override internal virtual {
714         require(!blacklists[to] && !blacklists[from], "Blacklisted");
715         
716         if (limited && from == uniswapV2Pair) {
717             require(super.balanceOf(to) + amount <= maxHoldingAmount && super.balanceOf(to) + amount >= minHoldingAmount, "Forbid");
718         }
719     }
720 
721     function burn(uint256 value) external {
722         _burn(msg.sender, value);
723     }
724 }