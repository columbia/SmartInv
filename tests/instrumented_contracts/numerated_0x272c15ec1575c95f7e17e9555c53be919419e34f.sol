1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 /*
3 
4     ___ ___ ___
5    /___/___/___/|
6   /___/___/___/||
7  /___/___/__ /|/|
8 |   |   |   | /||
9 |___|___|___|/|/|
10 |   |   |   | /||
11 |___|___|___|/|/
12 |   |   |   | /
13 |___|___|___|/
14 
15 */
16 // https://www.cubecoinerc.xyz/
17 // https://twitter.com/CubeCoinERC
18 // https://t.me/CubeCoinERC
19 
20 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
21 
22 pragma solidity ^0.8.0;
23 
24 /**
25  * @dev Interface of the ERC20 standard as defined in the EIP.
26  */
27 interface IERC20 {
28     /**
29      * @dev Emitted when `value` tokens are moved from one account (`from`) to
30      * another (`to`).
31      *
32      * Note that `value` may be zero.
33      */
34     event Transfer(address indexed from, address indexed to, uint256 value);
35 
36     /**
37      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
38      * a call to {approve}. `value` is the new allowance.
39      */
40     event Approval(address indexed owner, address indexed spender, uint256 value);
41 
42     /**
43      * @dev Returns the amount of tokens in existence.
44      */
45     function totalSupply() external view returns (uint256);
46 
47     /**
48      * @dev Returns the amount of tokens owned by `account`.
49      */
50     function balanceOf(address account) external view returns (uint256);
51 
52     /**
53      * @dev Moves `amount` tokens from the caller's account to `to`.
54      *
55      * Returns a boolean value indicating whether the operation succeeded.
56      *
57      * Emits a {Transfer} event.
58      */
59     function transfer(address to, uint256 amount) external returns (bool);
60 
61     /**
62      * @dev Returns the remaining number of tokens that `spender` will be
63      * allowed to spend on behalf of `owner` through {transferFrom}. This is
64      * zero by default.
65      *
66      * This value changes when {approve} or {transferFrom} are called.
67      */
68     function allowance(address owner, address spender) external view returns (uint256);
69 
70     /**
71      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
72      *
73      * Returns a boolean value indicating whether the operation succeeded.
74      *
75      * IMPORTANT: Beware that changing an allowance with this method brings the risk
76      * that someone may use both the old and the new allowance by unfortunate
77      * transaction ordering. One possible solution to mitigate this race
78      * condition is to first reduce the spender's allowance to 0 and set the
79      * desired value afterwards:
80      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
81      *
82      * Emits an {Approval} event.
83      */
84     function approve(address spender, uint256 amount) external returns (bool);
85 
86     /**
87      * @dev Moves `amount` tokens from `from` to `to` using the
88      * allowance mechanism. `amount` is then deducted from the caller's
89      * allowance.
90      *
91      * Returns a boolean value indicating whether the operation succeeded.
92      *
93      * Emits a {Transfer} event.
94      */
95     function transferFrom(
96         address from,
97         address to,
98         uint256 amount
99     ) external returns (bool);
100 }
101 
102 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
103 
104 
105 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
106 
107 pragma solidity ^0.8.0;
108 
109 
110 /**
111  * @dev Interface for the optional metadata functions from the ERC20 standard.
112  *
113  * _Available since v4.1._
114  */
115 interface IERC20Metadata is IERC20 {
116     /**
117      * @dev Returns the name of the token.
118      */
119     function name() external view returns (string memory);
120 
121     /**
122      * @dev Returns the symbol of the token.
123      */
124     function symbol() external view returns (string memory);
125 
126     /**
127      * @dev Returns the decimals places of the token.
128      */
129     function decimals() external view returns (uint8);
130 }
131 
132 // File: @openzeppelin/contracts/utils/Context.sol
133 
134 
135 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
136 
137 pragma solidity ^0.8.0;
138 
139 /**
140  * @dev Provides information about the current execution context, including the
141  * sender of the transaction and its data. While these are generally available
142  * via msg.sender and msg.data, they should not be accessed in such a direct
143  * manner, since when dealing with meta-transactions the account sending and
144  * paying for execution may not be the actual sender (as far as an application
145  * is concerned).
146  *
147  * This contract is only required for intermediate, library-like contracts.
148  */
149 abstract contract Context {
150     function _msgSender() internal view virtual returns (address) {
151         return msg.sender;
152     }
153 
154     function _msgData() internal view virtual returns (bytes calldata) {
155         return msg.data;
156     }
157 }
158 
159 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
160 
161 
162 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
163 
164 pragma solidity ^0.8.0;
165 
166 
167 
168 
169 /**
170  * @dev Implementation of the {IERC20} interface.
171  *
172  * This implementation is agnostic to the way tokens are created. This means
173  * that a supply mechanism has to be added in a derived contract using {_mint}.
174  * For a generic mechanism see {ERC20PresetMinterPauser}.
175  *
176  * TIP: For a detailed writeup see our guide
177  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
178  * to implement supply mechanisms].
179  *
180  * We have followed general OpenZeppelin Contracts guidelines: functions revert
181  * instead returning `false` on failure. This behavior is nonetheless
182  * conventional and does not conflict with the expectations of ERC20
183  * applications.
184  *
185  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
186  * This allows applications to reconstruct the allowance for all accounts just
187  * by listening to said events. Other implementations of the EIP may not emit
188  * these events, as it isn't required by the specification.
189  *
190  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
191  * functions have been added to mitigate the well-known issues around setting
192  * allowances. See {IERC20-approve}.
193  */
194 contract ERC20 is Context, IERC20, IERC20Metadata {
195     mapping(address => uint256) private _balances;
196 
197     mapping(address => mapping(address => uint256)) private _allowances;
198 
199     uint256 private _totalSupply;
200 
201     string private _name;
202     string private _symbol;
203 
204     /**
205      * @dev Sets the values for {name} and {symbol}.
206      *
207      * The default value of {decimals} is 18. To select a different value for
208      * {decimals} you should overload it.
209      *
210      * All two of these values are immutable: they can only be set once during
211      * construction.
212      */
213     constructor(string memory name_, string memory symbol_) {
214         _name = name_;
215         _symbol = symbol_;
216     }
217 
218     /**
219      * @dev Returns the name of the token.
220      */
221     function name() public view virtual override returns (string memory) {
222         return _name;
223     }
224 
225     /**
226      * @dev Returns the symbol of the token, usually a shorter version of the
227      * name.
228      */
229     function symbol() public view virtual override returns (string memory) {
230         return _symbol;
231     }
232 
233     /**
234      * @dev Returns the number of decimals used to get its user representation.
235      * For example, if `decimals` equals `2`, a balance of `505` tokens should
236      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
237      *
238      * Tokens usually opt for a value of 18, imitating the relationship between
239      * Ether and Wei. This is the value {ERC20} uses, unless this function is
240      * overridden;
241      *
242      * NOTE: This information is only used for _display_ purposes: it in
243      * no way affects any of the arithmetic of the contract, including
244      * {IERC20-balanceOf} and {IERC20-transfer}.
245      */
246     function decimals() public view virtual override returns (uint8) {
247         return 18;
248     }
249 
250     /**
251      * @dev See {IERC20-totalSupply}.
252      */
253     function totalSupply() public view virtual override returns (uint256) {
254         return _totalSupply;
255     }
256 
257     /**
258      * @dev See {IERC20-balanceOf}.
259      */
260     function balanceOf(address account) public view virtual override returns (uint256) {
261         return _balances[account];
262     }
263 
264     /**
265      * @dev See {IERC20-transfer}.
266      *
267      * Requirements:
268      *
269      * - `to` cannot be the zero address.
270      * - the caller must have a balance of at least `amount`.
271      */
272     function transfer(address to, uint256 amount) public virtual override returns (bool) {
273         address owner = _msgSender();
274         _transfer(owner, to, amount);
275         return true;
276     }
277 
278     /**
279      * @dev See {IERC20-allowance}.
280      */
281     function allowance(address owner, address spender) public view virtual override returns (uint256) {
282         return _allowances[owner][spender];
283     }
284 
285     /**
286      * @dev See {IERC20-approve}.
287      *
288      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
289      * `transferFrom`. This is semantically equivalent to an infinite approval.
290      *
291      * Requirements:
292      *
293      * - `spender` cannot be the zero address.
294      */
295     function approve(address spender, uint256 amount) public virtual override returns (bool) {
296         address owner = _msgSender();
297         _approve(owner, spender, amount);
298         return true;
299     }
300 
301     /**
302      * @dev See {IERC20-transferFrom}.
303      *
304      * Emits an {Approval} event indicating the updated allowance. This is not
305      * required by the EIP. See the note at the beginning of {ERC20}.
306      *
307      * NOTE: Does not update the allowance if the current allowance
308      * is the maximum `uint256`.
309      *
310      * Requirements:
311      *
312      * - `from` and `to` cannot be the zero address.
313      * - `from` must have a balance of at least `amount`.
314      * - the caller must have allowance for ``from``'s tokens of at least
315      * `amount`.
316      */
317     function transferFrom(
318         address from,
319         address to,
320         uint256 amount
321     ) public virtual override returns (bool) {
322         address spender = _msgSender();
323         _spendAllowance(from, spender, amount);
324         _transfer(from, to, amount);
325         return true;
326     }
327 
328     /**
329      * @dev Atomically increases the allowance granted to `spender` by the caller.
330      *
331      * This is an alternative to {approve} that can be used as a mitigation for
332      * problems described in {IERC20-approve}.
333      *
334      * Emits an {Approval} event indicating the updated allowance.
335      *
336      * Requirements:
337      *
338      * - `spender` cannot be the zero address.
339      */
340     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
341         address owner = _msgSender();
342         _approve(owner, spender, allowance(owner, spender) + addedValue);
343         return true;
344     }
345 
346     /**
347      * @dev Atomically decreases the allowance granted to `spender` by the caller.
348      *
349      * This is an alternative to {approve} that can be used as a mitigation for
350      * problems described in {IERC20-approve}.
351      *
352      * Emits an {Approval} event indicating the updated allowance.
353      *
354      * Requirements:
355      *
356      * - `spender` cannot be the zero address.
357      * - `spender` must have allowance for the caller of at least
358      * `subtractedValue`.
359      */
360     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
361         address owner = _msgSender();
362         uint256 currentAllowance = allowance(owner, spender);
363         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
364         unchecked {
365             _approve(owner, spender, currentAllowance - subtractedValue);
366         }
367 
368         return true;
369     }
370 
371     /**
372      * @dev Moves `amount` of tokens from `from` to `to`.
373      *
374      * This internal function is equivalent to {transfer}, and can be used to
375      * e.g. implement automatic token fees, slashing mechanisms, etc.
376      *
377      * Emits a {Transfer} event.
378      *
379      * Requirements:
380      *
381      * - `from` cannot be the zero address.
382      * - `to` cannot be the zero address.
383      * - `from` must have a balance of at least `amount`.
384      */
385     function _transfer(
386         address from,
387         address to,
388         uint256 amount
389     ) internal virtual {
390         require(from != address(0), "ERC20: transfer from the zero address");
391         require(to != address(0), "ERC20: transfer to the zero address");
392 
393         _beforeTokenTransfer(from, to, amount);
394 
395         uint256 fromBalance = _balances[from];
396         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
397         unchecked {
398             _balances[from] = fromBalance - amount;
399             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
400             // decrementing then incrementing.
401             _balances[to] += amount;
402         }
403 
404         emit Transfer(from, to, amount);
405 
406         _afterTokenTransfer(from, to, amount);
407     }
408 
409     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
410      * the total supply.
411      *
412      * Emits a {Transfer} event with `from` set to the zero address.
413      *
414      * Requirements:
415      *
416      * - `account` cannot be the zero address.
417      */
418     function _mint(address account, uint256 amount) internal virtual {
419         require(account != address(0), "ERC20: mint to the zero address");
420 
421         _beforeTokenTransfer(address(0), account, amount);
422 
423         _totalSupply += amount;
424         unchecked {
425             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
426             _balances[account] += amount;
427         }
428         emit Transfer(address(0), account, amount);
429 
430         _afterTokenTransfer(address(0), account, amount);
431     }
432 
433     /**
434      * @dev Destroys `amount` tokens from `account`, reducing the
435      * total supply.
436      *
437      * Emits a {Transfer} event with `to` set to the zero address.
438      *
439      * Requirements:
440      *
441      * - `account` cannot be the zero address.
442      * - `account` must have at least `amount` tokens.
443      */
444     function _burn(address account, uint256 amount) internal virtual {
445         require(account != address(0), "ERC20: burn from the zero address");
446 
447         _beforeTokenTransfer(account, address(0), amount);
448 
449         uint256 accountBalance = _balances[account];
450         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
451         unchecked {
452             _balances[account] = accountBalance - amount;
453             // Overflow not possible: amount <= accountBalance <= totalSupply.
454             _totalSupply -= amount;
455         }
456 
457         emit Transfer(account, address(0), amount);
458 
459         _afterTokenTransfer(account, address(0), amount);
460     }
461 
462     /**
463      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
464      *
465      * This internal function is equivalent to `approve`, and can be used to
466      * e.g. set automatic allowances for certain subsystems, etc.
467      *
468      * Emits an {Approval} event.
469      *
470      * Requirements:
471      *
472      * - `owner` cannot be the zero address.
473      * - `spender` cannot be the zero address.
474      */
475     function _approve(
476         address owner,
477         address spender,
478         uint256 amount
479     ) internal virtual {
480         require(owner != address(0), "ERC20: approve from the zero address");
481         require(spender != address(0), "ERC20: approve to the zero address");
482 
483         _allowances[owner][spender] = amount;
484         emit Approval(owner, spender, amount);
485     }
486 
487     /**
488      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
489      *
490      * Does not update the allowance amount in case of infinite allowance.
491      * Revert if not enough allowance is available.
492      *
493      * Might emit an {Approval} event.
494      */
495     function _spendAllowance(
496         address owner,
497         address spender,
498         uint256 amount
499     ) internal virtual {
500         uint256 currentAllowance = allowance(owner, spender);
501         if (currentAllowance != type(uint256).max) {
502             require(currentAllowance >= amount, "ERC20: insufficient allowance");
503             unchecked {
504                 _approve(owner, spender, currentAllowance - amount);
505             }
506         }
507     }
508 
509     /**
510      * @dev Hook that is called before any transfer of tokens. This includes
511      * minting and burning.
512      *
513      * Calling conditions:
514      *
515      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
516      * will be transferred to `to`.
517      * - when `from` is zero, `amount` tokens will be minted for `to`.
518      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
519      * - `from` and `to` are never both zero.
520      *
521      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
522      */
523     function _beforeTokenTransfer(
524         address from,
525         address to,
526         uint256 amount
527     ) internal virtual {}
528 
529     /**
530      * @dev Hook that is called after any transfer of tokens. This includes
531      * minting and burning.
532      *
533      * Calling conditions:
534      *
535      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
536      * has been transferred to `to`.
537      * - when `from` is zero, `amount` tokens have been minted for `to`.
538      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
539      * - `from` and `to` are never both zero.
540      *
541      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
542      */
543     function _afterTokenTransfer(
544         address from,
545         address to,
546         uint256 amount
547     ) internal virtual {}
548 }
549 
550 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
551 
552 
553 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)
554 
555 pragma solidity ^0.8.0;
556 
557 
558 
559 /**
560  * @dev Extension of {ERC20} that allows token holders to destroy both their own
561  * tokens and those that they have an allowance for, in a way that can be
562  * recognized off-chain (via event analysis).
563  */
564 abstract contract ERC20Burnable is Context, ERC20 {
565     /**
566      * @dev Destroys `amount` tokens from the caller.
567      *
568      * See {ERC20-_burn}.
569      */
570     function burn(uint256 amount) public virtual {
571         _burn(_msgSender(), amount);
572     }
573 
574     /**
575      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
576      * allowance.
577      *
578      * See {ERC20-_burn} and {ERC20-allowance}.
579      *
580      * Requirements:
581      *
582      * - the caller must have allowance for ``accounts``'s tokens of at least
583      * `amount`.
584      */
585     function burnFrom(address account, uint256 amount) public virtual {
586         _spendAllowance(account, _msgSender(), amount);
587         _burn(account, amount);
588     }
589 }
590 
591 // File: @openzeppelin/contracts/access/Ownable.sol
592 
593 
594 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
595 
596 pragma solidity ^0.8.0;
597 
598 
599 /**
600  * @dev Contract module which provides a basic access control mechanism, where
601  * there is an account (an owner) that can be granted exclusive access to
602  * specific functions.
603  *
604  * By default, the owner account will be the one that deploys the contract. This
605  * can later be changed with {transferOwnership}.
606  *
607  * This module is used through inheritance. It will make available the modifier
608  * `onlyOwner`, which can be applied to your functions to restrict their use to
609  * the owner.
610  */
611 abstract contract Ownable is Context {
612     address private _owner;
613 
614     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
615 
616     /**
617      * @dev Initializes the contract setting the deployer as the initial owner.
618      */
619     constructor() {
620         _transferOwnership(_msgSender());
621     }
622 
623     /**
624      * @dev Throws if called by any account other than the owner.
625      */
626     modifier onlyOwner() {
627         _checkOwner();
628         _;
629     }
630 
631     /**
632      * @dev Returns the address of the current owner.
633      */
634     function owner() public view virtual returns (address) {
635         return _owner;
636     }
637 
638     /**
639      * @dev Throws if the sender is not the owner.
640      */
641     function _checkOwner() internal view virtual {
642         require(owner() == _msgSender(), "Ownable: caller is not the owner");
643     }
644 
645     /**
646      * @dev Leaves the contract without owner. It will not be possible to call
647      * `onlyOwner` functions anymore. Can only be called by the current owner.
648      *
649      * NOTE: Renouncing ownership will leave the contract without an owner,
650      * thereby removing any functionality that is only available to the owner.
651      */
652     function renounceOwnership() public virtual onlyOwner {
653         _transferOwnership(address(0));
654     }
655 
656     /**
657      * @dev Transfers ownership of the contract to a new account (`newOwner`).
658      * Can only be called by the current owner.
659      */
660     function transferOwnership(address newOwner) public virtual onlyOwner {
661         require(newOwner != address(0), "Ownable: new owner is the zero address");
662         _transferOwnership(newOwner);
663     }
664 
665     /**
666      * @dev Transfers ownership of the contract to a new account (`newOwner`).
667      * Internal function without access restriction.
668      */
669     function _transferOwnership(address newOwner) internal virtual {
670         address oldOwner = _owner;
671         _owner = newOwner;
672         emit OwnershipTransferred(oldOwner, newOwner);
673     }
674 }
675 
676 // File: coinyeyov3rules.sol
677 
678 
679 
680 
681 
682  
683 pragma solidity ^0.8.0;
684  
685 contract CubeToken is Ownable, ERC20 {
686     IUniswapV2Router02 public uniswapV2Router;
687     bool public limited;
688     bool public taxesEnabled = true;
689     uint256 public maxHoldingAmount;
690     uint256 public minHoldingAmount;
691     uint256 public buyTaxPercent = 5; // Never change to ZERO, disable taxes instead
692     uint256 public sellTaxPercent = 5; // Never change to ZERO, disable taxes instead
693     uint256 minAmountToSwapTaxes = (totalSupply() * 1) / 1000;
694 
695     bool inSwapAndLiq;
696     bool public paused = true;
697  
698     address public marketingWallet;
699     address public uniswapV2Pair;
700     mapping(address => bool) public blacklists;
701     mapping(address => bool) public _isExcludedFromFees;
702  
703     modifier lockTheSwap() {
704         inSwapAndLiq = true;
705         _;
706         inSwapAndLiq = false;
707     }
708  
709     constructor() ERC20("CubeToken", "CUBE") {
710         _mint(msg.sender, 100000000000000000000000000000);
711         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
712             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
713         );
714         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
715             .createPair(address(this), _uniswapV2Router.WETH());
716  
717         uniswapV2Router = _uniswapV2Router;
718         uniswapV2Pair = _uniswapV2Pair;
719  
720         _isExcludedFromFees[msg.sender] = true;
721         _isExcludedFromFees[marketingWallet] = true;
722         _isExcludedFromFees[uniswapV2Pair] = true;
723  
724         marketingWallet = 0xEcF1E36fF0532B5Cc6cA742e4A6D849976673F89; 
725     }
726  
727     function _transfer(
728         address from,
729         address to,
730         uint256 amount
731     ) internal override {
732         require(from != address(0), "ERC20: transfer from the zero address");
733         require(to != address(0), "ERC20: transfer to the zero address");
734         require(amount > 0, "ERC20: transfer must be greater than 0");
735  
736         if (paused) {
737             require(from == owner() || to == owner(), "Trading not active yet");
738         }
739  
740         require(!blacklists[to] && !blacklists[from], "Blacklisted");
741  
742         if (limited && from == uniswapV2Pair) {
743             require(
744                 balanceOf(to) + amount <= maxHoldingAmount &&
745                     balanceOf(to) + amount >= minHoldingAmount,
746                 "Forbid"
747             );
748         }
749  
750         uint256 taxAmount;
751         if (taxesEnabled) {
752             if (from == uniswapV2Pair) {
753                 //Buy
754  
755                 if (!_isExcludedFromFees[to])
756                     taxAmount = (amount * buyTaxPercent) / 100;
757             }
758             // Sell
759             if (to == uniswapV2Pair) {
760                 if (!_isExcludedFromFees[from])
761                     taxAmount = (amount * sellTaxPercent) / 100;
762             }
763         }
764  
765         uint256 contractTokenBalance = balanceOf(address(this));
766         bool overMinTokenBalance = contractTokenBalance >= minAmountToSwapTaxes;
767  
768         if (overMinTokenBalance && !inSwapAndLiq && from != uniswapV2Pair) {
769             handleTax();
770         }
771  
772         // Fees
773         if (taxAmount > 0) {
774             uint256 userAmount = amount - taxAmount;
775             super._transfer(from, address(this), taxAmount);
776             super._transfer(from, to, userAmount);
777         } else {
778             super._transfer(from, to, amount);
779         }
780     }
781  
782     function handleTax() internal lockTheSwap {
783         // generate the uniswap pair path of token -> weth
784         address[] memory path = new address[](2);
785         path[0] = address(this);
786         path[1] = uniswapV2Router.WETH();
787  
788         _approve(
789             address(this),
790             address(uniswapV2Router),
791             balanceOf(address(this))
792         );
793  
794         // make the swap
795         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
796             balanceOf(address(this)),
797             0, // accept any amount of ETH
798             path,
799             marketingWallet,
800             block.timestamp
801         );
802     }
803  
804     function changeMarketingWallet(
805         address _newMarketingWallet
806     ) external onlyOwner {
807         marketingWallet = _newMarketingWallet;
808     }
809  
810     function changeTaxPercent(
811         uint256 _newBuyTaxPercent,
812         uint256 _newSellTaxPercent
813     ) external onlyOwner {
814         buyTaxPercent = _newBuyTaxPercent;
815         sellTaxPercent = _newSellTaxPercent;
816     }
817  
818     function excludeFromFees(
819         address _address,
820         bool _isExcluded
821     ) external onlyOwner {
822         _isExcludedFromFees[_address] = _isExcluded;
823     }
824  
825     function changeMinAmountToSwapTaxes(
826         uint256 newMinAmount
827     ) external onlyOwner {
828         require(newMinAmount > 0, "Cannot set to zero");
829         minAmountToSwapTaxes = newMinAmount;
830     }
831  
832     function burn(uint256 value) external {
833         _burn(msg.sender, value);
834     }
835  
836     function enableTaxes(bool _enable) external onlyOwner {
837         taxesEnabled = _enable;
838     }
839  
840     function togglePause() external onlyOwner {
841         paused = !paused;
842     }
843  
844     function toggleLimited() external onlyOwner {
845         limited = !limited;
846     }
847  
848     function blacklist(
849         address _address,
850         bool _isBlacklisting
851     ) external onlyOwner {
852         blacklists[_address] = _isBlacklisting;
853     }
854  
855     function setRule(
856         bool _limited,
857         uint256 _maxHoldingAmount,
858         uint256 _minHoldingAmount
859     ) external onlyOwner {
860         limited = _limited;
861         maxHoldingAmount = _maxHoldingAmount;
862         minHoldingAmount = _minHoldingAmount;
863     }
864 }
865  
866 // Interfaces
867 interface IUniswapV2Factory {
868     event PairCreated(
869         address indexed token0,
870         address indexed token1,
871         address pair,
872         uint
873     );
874  
875     function feeTo() external view returns (address);
876  
877     function feeToSetter() external view returns (address);
878  
879     function getPair(
880         address tokenA,
881         address tokenB
882     ) external view returns (address pair);
883  
884     function allPairs(uint) external view returns (address pair);
885  
886     function allPairsLength() external view returns (uint);
887  
888     function createPair(
889         address tokenA,
890         address tokenB
891     ) external returns (address pair);
892  
893     function setFeeTo(address) external;
894  
895     function setFeeToSetter(address) external;
896 }
897  
898 interface IUniswapV2Pair {
899     event Approval(address indexed owner, address indexed spender, uint value);
900     event Transfer(address indexed from, address indexed to, uint value);
901  
902     function name() external pure returns (string memory);
903  
904     function symbol() external pure returns (string memory);
905  
906     function decimals() external pure returns (uint8);
907  
908     function totalSupply() external view returns (uint);
909  
910     function balanceOf(address owner) external view returns (uint);
911  
912     function allowance(
913         address owner,
914         address spender
915     ) external view returns (uint);
916  
917     function approve(address spender, uint value) external returns (bool);
918  
919     function transfer(address to, uint value) external returns (bool);
920  
921     function transferFrom(
922         address from,
923         address to,
924         uint value
925     ) external returns (bool);
926  
927     function DOMAIN_SEPARATOR() external view returns (bytes32);
928  
929     function PERMIT_TYPEHASH() external pure returns (bytes32);
930  
931     function nonces(address owner) external view returns (uint);
932  
933     function permit(
934         address owner,
935         address spender,
936         uint value,
937         uint deadline,
938         uint8 v,
939         bytes32 r,
940         bytes32 s
941     ) external;
942  
943     event Mint(address indexed sender, uint amount0, uint amount1);
944     event Burn(
945         address indexed sender,
946         uint amount0,
947         uint amount1,
948         address indexed to
949     );
950     event Swap(
951         address indexed sender,
952         uint amount0In,
953         uint amount1In,
954         uint amount0Out,
955         uint amount1Out,
956         address indexed to
957     );
958     event Sync(uint112 reserve0, uint112 reserve1);
959  
960     function MINIMUM_LIQUIDITY() external pure returns (uint);
961  
962     function factory() external view returns (address);
963  
964     function token0() external view returns (address);
965  
966     function token1() external view returns (address);
967  
968     function getReserves()
969         external
970         view
971         returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
972  
973     function price0CumulativeLast() external view returns (uint);
974  
975     function price1CumulativeLast() external view returns (uint);
976  
977     function kLast() external view returns (uint);
978  
979     function mint(address to) external returns (uint liquidity);
980  
981     function burn(address to) external returns (uint amount0, uint amount1);
982  
983     function swap(
984         uint amount0Out,
985         uint amount1Out,
986         address to,
987         bytes calldata data
988     ) external;
989  
990     function skim(address to) external;
991  
992     function sync() external;
993  
994     function initialize(address, address) external;
995 }
996  
997 interface IUniswapV2Router01 {
998     function factory() external pure returns (address);
999  
1000     function WETH() external pure returns (address);
1001  
1002     function addLiquidity(
1003         address tokenA,
1004         address tokenB,
1005         uint amountADesired,
1006         uint amountBDesired,
1007         uint amountAMin,
1008         uint amountBMin,
1009         address to,
1010         uint deadline
1011     ) external returns (uint amountA, uint amountB, uint liquidity);
1012  
1013     function addLiquidityETH(
1014         address token,
1015         uint amountTokenDesired,
1016         uint amountTokenMin,
1017         uint amountETHMin,
1018         address to,
1019         uint deadline
1020     )
1021         external
1022         payable
1023         returns (uint amountToken, uint amountETH, uint liquidity);
1024  
1025     function removeLiquidity(
1026         address tokenA,
1027         address tokenB,
1028         uint liquidity,
1029         uint amountAMin,
1030         uint amountBMin,
1031         address to,
1032         uint deadline
1033     ) external returns (uint amountA, uint amountB);
1034  
1035     function removeLiquidityETH(
1036         address token,
1037         uint liquidity,
1038         uint amountTokenMin,
1039         uint amountETHMin,
1040         address to,
1041         uint deadline
1042     ) external returns (uint amountToken, uint amountETH);
1043  
1044     function removeLiquidityWithPermit(
1045         address tokenA,
1046         address tokenB,
1047         uint liquidity,
1048         uint amountAMin,
1049         uint amountBMin,
1050         address to,
1051         uint deadline,
1052         bool approveMax,
1053         uint8 v,
1054         bytes32 r,
1055         bytes32 s
1056     ) external returns (uint amountA, uint amountB);
1057  
1058     function removeLiquidityETHWithPermit(
1059         address token,
1060         uint liquidity,
1061         uint amountTokenMin,
1062         uint amountETHMin,
1063         address to,
1064         uint deadline,
1065         bool approveMax,
1066         uint8 v,
1067         bytes32 r,
1068         bytes32 s
1069     ) external returns (uint amountToken, uint amountETH);
1070  
1071     function swapExactTokensForTokens(
1072         uint amountIn,
1073         uint amountOutMin,
1074         address[] calldata path,
1075         address to,
1076         uint deadline
1077     ) external returns (uint[] memory amounts);
1078  
1079     function swapTokensForExactTokens(
1080         uint amountOut,
1081         uint amountInMax,
1082         address[] calldata path,
1083         address to,
1084         uint deadline
1085     ) external returns (uint[] memory amounts);
1086  
1087     function swapExactETHForTokens(
1088         uint amountOutMin,
1089         address[] calldata path,
1090         address to,
1091         uint deadline
1092     ) external payable returns (uint[] memory amounts);
1093  
1094     function swapTokensForExactETH(
1095         uint amountOut,
1096         uint amountInMax,
1097         address[] calldata path,
1098         address to,
1099         uint deadline
1100     ) external returns (uint[] memory amounts);
1101  
1102     function swapExactTokensForETH(
1103         uint amountIn,
1104         uint amountOutMin,
1105         address[] calldata path,
1106         address to,
1107         uint deadline
1108     ) external returns (uint[] memory amounts);
1109  
1110     function swapETHForExactTokens(
1111         uint amountOut,
1112         address[] calldata path,
1113         address to,
1114         uint deadline
1115     ) external payable returns (uint[] memory amounts);
1116  
1117     function quote(
1118         uint amountA,
1119         uint reserveA,
1120         uint reserveB
1121     ) external pure returns (uint amountB);
1122  
1123     function getAmountOut(
1124         uint amountIn,
1125         uint reserveIn,
1126         uint reserveOut
1127     ) external pure returns (uint amountOut);
1128  
1129     function getAmountIn(
1130         uint amountOut,
1131         uint reserveIn,
1132         uint reserveOut
1133     ) external pure returns (uint amountIn);
1134  
1135     function getAmountsOut(
1136         uint amountIn,
1137         address[] calldata path
1138     ) external view returns (uint[] memory amounts);
1139  
1140     function getAmountsIn(
1141         uint amountOut,
1142         address[] calldata path
1143     ) external view returns (uint[] memory amounts);
1144 }
1145  
1146 interface IUniswapV2Router02 is IUniswapV2Router01 {
1147     function removeLiquidityETHSupportingFeeOnTransferTokens(
1148         address token,
1149         uint liquidity,
1150         uint amountTokenMin,
1151         uint amountETHMin,
1152         address to,
1153         uint deadline
1154     ) external returns (uint amountETH);
1155  
1156     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
1157         address token,
1158         uint liquidity,
1159         uint amountTokenMin,
1160         uint amountETHMin,
1161         address to,
1162         uint deadline,
1163         bool approveMax,
1164         uint8 v,
1165         bytes32 r,
1166         bytes32 s
1167     ) external returns (uint amountETH);
1168  
1169     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1170         uint amountIn,
1171         uint amountOutMin,
1172         address[] calldata path,
1173         address to,
1174         uint deadline
1175     ) external;
1176  
1177     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1178         uint amountOutMin,
1179         address[] calldata path,
1180         address to,
1181         uint deadline
1182     ) external payable;
1183  
1184     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1185         uint amountIn,
1186         uint amountOutMin,
1187         address[] calldata path,
1188         address to,
1189         uint deadline
1190     ) external;
1191 }