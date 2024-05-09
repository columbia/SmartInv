1 /*
2 copcoinerc.com
3 https://twitter.com/copcoinxyz
4 t.me/copcoinxyz
5 
6 */
7 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)
8 
9 pragma solidity ^0.8.0;
10 
11 /**
12  * @dev Interface of the ERC20 standard as defined in the EIP.
13  */
14 interface IERC20 {
15     /**
16      * @dev Emitted when `value` tokens are moved from one account (`from`) to
17      * another (`to`).
18      *
19      * Note that `value` may be zero.
20      */
21     event Transfer(address indexed from, address indexed to, uint256 value);
22 
23     /**
24      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
25      * a call to {approve}. `value` is the new allowance.
26      */
27     event Approval(address indexed owner, address indexed spender, uint256 value);
28 
29     /**
30      * @dev Returns the amount of tokens in existence.
31      */
32     function totalSupply() external view returns (uint256);
33 
34     /**
35      * @dev Returns the amount of tokens owned by `account`.
36      */
37     function balanceOf(address account) external view returns (uint256);
38 
39     /**
40      * @dev Moves `amount` tokens from the caller's account to `to`.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * Emits a {Transfer} event.
45      */
46     function transfer(address to, uint256 amount) external returns (bool);
47 
48     /**
49      * @dev Returns the remaining number of tokens that `spender` will be
50      * allowed to spend on behalf of `owner` through {transferFrom}. This is
51      * zero by default.
52      *
53      * This value changes when {approve} or {transferFrom} are called.
54      */
55     function allowance(address owner, address spender) external view returns (uint256);
56 
57     /**
58      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * IMPORTANT: Beware that changing an allowance with this method brings the risk
63      * that someone may use both the old and the new allowance by unfortunate
64      * transaction ordering. One possible solution to mitigate this race
65      * condition is to first reduce the spender's allowance to 0 and set the
66      * desired value afterwards:
67      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
68      *
69      * Emits an {Approval} event.
70      */
71     function approve(address spender, uint256 amount) external returns (bool);
72 
73     /**
74      * @dev Moves `amount` tokens from `from` to `to` using the
75      * allowance mechanism. `amount` is then deducted from the caller's
76      * allowance.
77      *
78      * Returns a boolean value indicating whether the operation succeeded.
79      *
80      * Emits a {Transfer} event.
81      */
82     function transferFrom(address from, address to, uint256 amount) external returns (bool);
83 }
84 
85 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
86 
87 
88 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
89 
90 pragma solidity ^0.8.0;
91 
92 
93 /**
94  * @dev Interface for the optional metadata functions from the ERC20 standard.
95  *
96  * _Available since v4.1._
97  */
98 interface IERC20Metadata is IERC20 {
99     /**
100      * @dev Returns the name of the token.
101      */
102     function name() external view returns (string memory);
103 
104     /**
105      * @dev Returns the symbol of the token.
106      */
107     function symbol() external view returns (string memory);
108 
109     /**
110      * @dev Returns the decimals places of the token.
111      */
112     function decimals() external view returns (uint8);
113 }
114 
115 // File: @openzeppelin/contracts/utils/Context.sol
116 
117 
118 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
119 
120 pragma solidity ^0.8.0;
121 
122 /**
123  * @dev Provides information about the current execution context, including the
124  * sender of the transaction and its data. While these are generally available
125  * via msg.sender and msg.data, they should not be accessed in such a direct
126  * manner, since when dealing with meta-transactions the account sending and
127  * paying for execution may not be the actual sender (as far as an application
128  * is concerned).
129  *
130  * This contract is only required for intermediate, library-like contracts.
131  */
132 abstract contract Context {
133     function _msgSender() internal view virtual returns (address) {
134         return msg.sender;
135     }
136 
137     function _msgData() internal view virtual returns (bytes calldata) {
138         return msg.data;
139     }
140 }
141 
142 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
143 
144 
145 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/ERC20.sol)
146 
147 pragma solidity ^0.8.0;
148 
149 
150 
151 
152 /**
153  * @dev Implementation of the {IERC20} interface.
154  *
155  * This implementation is agnostic to the way tokens are created. This means
156  * that a supply mechanism has to be added in a derived contract using {_mint}.
157  * For a generic mechanism see {ERC20PresetMinterPauser}.
158  *
159  * TIP: For a detailed writeup see our guide
160  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
161  * to implement supply mechanisms].
162  *
163  * The default value of {decimals} is 18. To change this, you should override
164  * this function so it returns a different value.
165  *
166  * We have followed general OpenZeppelin Contracts guidelines: functions revert
167  * instead returning `false` on failure. This behavior is nonetheless
168  * conventional and does not conflict with the expectations of ERC20
169  * applications.
170  *
171  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
172  * This allows applications to reconstruct the allowance for all accounts just
173  * by listening to said events. Other implementations of the EIP may not emit
174  * these events, as it isn't required by the specification.
175  *
176  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
177  * functions have been added to mitigate the well-known issues around setting
178  * allowances. See {IERC20-approve}.
179  */
180 contract ERC20 is Context, IERC20, IERC20Metadata {
181     mapping(address => uint256) private _balances;
182 
183     mapping(address => mapping(address => uint256)) private _allowances;
184 
185     uint256 private _totalSupply;
186 
187     string private _name;
188     string private _symbol;
189 
190     /**
191      * @dev Sets the values for {name} and {symbol}.
192      *
193      * All two of these values are immutable: they can only be set once during
194      * construction.
195      */
196     constructor(string memory name_, string memory symbol_) {
197         _name = name_;
198         _symbol = symbol_;
199     }
200 
201     /**
202      * @dev Returns the name of the token.
203      */
204     function name() public view virtual override returns (string memory) {
205         return _name;
206     }
207 
208     /**
209      * @dev Returns the symbol of the token, usually a shorter version of the
210      * name.
211      */
212     function symbol() public view virtual override returns (string memory) {
213         return _symbol;
214     }
215 
216     /**
217      * @dev Returns the number of decimals used to get its user representation.
218      * For example, if `decimals` equals `2`, a balance of `505` tokens should
219      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
220      *
221      * Tokens usually opt for a value of 18, imitating the relationship between
222      * Ether and Wei. This is the default value returned by this function, unless
223      * it's overridden.
224      *
225      * NOTE: This information is only used for _display_ purposes: it in
226      * no way affects any of the arithmetic of the contract, including
227      * {IERC20-balanceOf} and {IERC20-transfer}.
228      */
229     function decimals() public view virtual override returns (uint8) {
230         return 18;
231     }
232 
233     /**
234      * @dev See {IERC20-totalSupply}.
235      */
236     function totalSupply() public view virtual override returns (uint256) {
237         return _totalSupply;
238     }
239 
240     /**
241      * @dev See {IERC20-balanceOf}.
242      */
243     function balanceOf(address account) public view virtual override returns (uint256) {
244         return _balances[account];
245     }
246 
247     /**
248      * @dev See {IERC20-transfer}.
249      *
250      * Requirements:
251      *
252      * - `to` cannot be the zero address.
253      * - the caller must have a balance of at least `amount`.
254      */
255     function transfer(address to, uint256 amount) public virtual override returns (bool) {
256         address owner = _msgSender();
257         _transfer(owner, to, amount);
258         return true;
259     }
260 
261     /**
262      * @dev See {IERC20-allowance}.
263      */
264     function allowance(address owner, address spender) public view virtual override returns (uint256) {
265         return _allowances[owner][spender];
266     }
267 
268     /**
269      * @dev See {IERC20-approve}.
270      *
271      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
272      * `transferFrom`. This is semantically equivalent to an infinite approval.
273      *
274      * Requirements:
275      *
276      * - `spender` cannot be the zero address.
277      */
278     function approve(address spender, uint256 amount) public virtual override returns (bool) {
279         address owner = _msgSender();
280         _approve(owner, spender, amount);
281         return true;
282     }
283 
284     /**
285      * @dev See {IERC20-transferFrom}.
286      *
287      * Emits an {Approval} event indicating the updated allowance. This is not
288      * required by the EIP. See the note at the beginning of {ERC20}.
289      *
290      * NOTE: Does not update the allowance if the current allowance
291      * is the maximum `uint256`.
292      *
293      * Requirements:
294      *
295      * - `from` and `to` cannot be the zero address.
296      * - `from` must have a balance of at least `amount`.
297      * - the caller must have allowance for ``from``'s tokens of at least
298      * `amount`.
299      */
300     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
301         address spender = _msgSender();
302         _spendAllowance(from, spender, amount);
303         _transfer(from, to, amount);
304         return true;
305     }
306 
307     /**
308      * @dev Atomically increases the allowance granted to `spender` by the caller.
309      *
310      * This is an alternative to {approve} that can be used as a mitigation for
311      * problems described in {IERC20-approve}.
312      *
313      * Emits an {Approval} event indicating the updated allowance.
314      *
315      * Requirements:
316      *
317      * - `spender` cannot be the zero address.
318      */
319     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
320         address owner = _msgSender();
321         _approve(owner, spender, allowance(owner, spender) + addedValue);
322         return true;
323     }
324 
325     /**
326      * @dev Atomically decreases the allowance granted to `spender` by the caller.
327      *
328      * This is an alternative to {approve} that can be used as a mitigation for
329      * problems described in {IERC20-approve}.
330      *
331      * Emits an {Approval} event indicating the updated allowance.
332      *
333      * Requirements:
334      *
335      * - `spender` cannot be the zero address.
336      * - `spender` must have allowance for the caller of at least
337      * `subtractedValue`.
338      */
339     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
340         address owner = _msgSender();
341         uint256 currentAllowance = allowance(owner, spender);
342         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
343         unchecked {
344             _approve(owner, spender, currentAllowance - subtractedValue);
345         }
346 
347         return true;
348     }
349 
350     /**
351      * @dev Moves `amount` of tokens from `from` to `to`.
352      *
353      * This internal function is equivalent to {transfer}, and can be used to
354      * e.g. implement automatic token fees, slashing mechanisms, etc.
355      *
356      * Emits a {Transfer} event.
357      *
358      * Requirements:
359      *
360      * - `from` cannot be the zero address.
361      * - `to` cannot be the zero address.
362      * - `from` must have a balance of at least `amount`.
363      */
364     function _transfer(address from, address to, uint256 amount) internal virtual {
365         require(from != address(0), "ERC20: transfer from the zero address");
366         require(to != address(0), "ERC20: transfer to the zero address");
367 
368         _beforeTokenTransfer(from, to, amount);
369 
370         uint256 fromBalance = _balances[from];
371         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
372         unchecked {
373             _balances[from] = fromBalance - amount;
374             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
375             // decrementing then incrementing.
376             _balances[to] += amount;
377         }
378 
379         emit Transfer(from, to, amount);
380 
381         _afterTokenTransfer(from, to, amount);
382     }
383 
384     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
385      * the total supply.
386      *
387      * Emits a {Transfer} event with `from` set to the zero address.
388      *
389      * Requirements:
390      *
391      * - `account` cannot be the zero address.
392      */
393     function _mint(address account, uint256 amount) internal virtual {
394         require(account != address(0), "ERC20: mint to the zero address");
395 
396         _beforeTokenTransfer(address(0), account, amount);
397 
398         _totalSupply += amount;
399         unchecked {
400             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
401             _balances[account] += amount;
402         }
403         emit Transfer(address(0), account, amount);
404 
405         _afterTokenTransfer(address(0), account, amount);
406     }
407 
408     /**
409      * @dev Destroys `amount` tokens from `account`, reducing the
410      * total supply.
411      *
412      * Emits a {Transfer} event with `to` set to the zero address.
413      *
414      * Requirements:
415      *
416      * - `account` cannot be the zero address.
417      * - `account` must have at least `amount` tokens.
418      */
419     function _burn(address account, uint256 amount) internal virtual {
420         require(account != address(0), "ERC20: burn from the zero address");
421 
422         _beforeTokenTransfer(account, address(0), amount);
423 
424         uint256 accountBalance = _balances[account];
425         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
426         unchecked {
427             _balances[account] = accountBalance - amount;
428             // Overflow not possible: amount <= accountBalance <= totalSupply.
429             _totalSupply -= amount;
430         }
431 
432         emit Transfer(account, address(0), amount);
433 
434         _afterTokenTransfer(account, address(0), amount);
435     }
436 
437     /**
438      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
439      *
440      * This internal function is equivalent to `approve`, and can be used to
441      * e.g. set automatic allowances for certain subsystems, etc.
442      *
443      * Emits an {Approval} event.
444      *
445      * Requirements:
446      *
447      * - `owner` cannot be the zero address.
448      * - `spender` cannot be the zero address.
449      */
450     function _approve(address owner, address spender, uint256 amount) internal virtual {
451         require(owner != address(0), "ERC20: approve from the zero address");
452         require(spender != address(0), "ERC20: approve to the zero address");
453 
454         _allowances[owner][spender] = amount;
455         emit Approval(owner, spender, amount);
456     }
457 
458     /**
459      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
460      *
461      * Does not update the allowance amount in case of infinite allowance.
462      * Revert if not enough allowance is available.
463      *
464      * Might emit an {Approval} event.
465      */
466     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
467         uint256 currentAllowance = allowance(owner, spender);
468         if (currentAllowance != type(uint256).max) {
469             require(currentAllowance >= amount, "ERC20: insufficient allowance");
470             unchecked {
471                 _approve(owner, spender, currentAllowance - amount);
472             }
473         }
474     }
475 
476     /**
477      * @dev Hook that is called before any transfer of tokens. This includes
478      * minting and burning.
479      *
480      * Calling conditions:
481      *
482      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
483      * will be transferred to `to`.
484      * - when `from` is zero, `amount` tokens will be minted for `to`.
485      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
486      * - `from` and `to` are never both zero.
487      *
488      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
489      */
490     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
491 
492     /**
493      * @dev Hook that is called after any transfer of tokens. This includes
494      * minting and burning.
495      *
496      * Calling conditions:
497      *
498      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
499      * has been transferred to `to`.
500      * - when `from` is zero, `amount` tokens have been minted for `to`.
501      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
502      * - `from` and `to` are never both zero.
503      *
504      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
505      */
506     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
507 }
508 
509 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
510 
511 
512 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)
513 
514 pragma solidity ^0.8.0;
515 
516 
517 
518 /**
519  * @dev Extension of {ERC20} that allows token holders to destroy both their own
520  * tokens and those that they have an allowance for, in a way that can be
521  * recognized off-chain (via event analysis).
522  */
523 abstract contract ERC20Burnable is Context, ERC20 {
524     /**
525      * @dev Destroys `amount` tokens from the caller.
526      *
527      * See {ERC20-_burn}.
528      */
529     function burn(uint256 amount) public virtual {
530         _burn(_msgSender(), amount);
531     }
532 
533     /**
534      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
535      * allowance.
536      *
537      * See {ERC20-_burn} and {ERC20-allowance}.
538      *
539      * Requirements:
540      *
541      * - the caller must have allowance for ``accounts``'s tokens of at least
542      * `amount`.
543      */
544     function burnFrom(address account, uint256 amount) public virtual {
545         _spendAllowance(account, _msgSender(), amount);
546         _burn(account, amount);
547     }
548 }
549 
550 // File: @openzeppelin/contracts/access/Ownable.sol
551 
552 
553 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
554 
555 pragma solidity ^0.8.0;
556 
557 
558 /**
559  * @dev Contract module which provides a basic access control mechanism, where
560  * there is an account (an owner) that can be granted exclusive access to
561  * specific functions.
562  *
563  * By default, the owner account will be the one that deploys the contract. This
564  * can later be changed with {transferOwnership}.
565  *
566  * This module is used through inheritance. It will make available the modifier
567  * `onlyOwner`, which can be applied to your functions to restrict their use to
568  * the owner.
569  */
570 abstract contract Ownable is Context {
571     address private _owner;
572 
573     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
574 
575     /**
576      * @dev Initializes the contract setting the deployer as the initial owner.
577      */
578     constructor() {
579         _transferOwnership(_msgSender());
580     }
581 
582     /**
583      * @dev Throws if called by any account other than the owner.
584      */
585     modifier onlyOwner() {
586         _checkOwner();
587         _;
588     }
589 
590     /**
591      * @dev Returns the address of the current owner.
592      */
593     function owner() public view virtual returns (address) {
594         return _owner;
595     }
596 
597     /**
598      * @dev Throws if the sender is not the owner.
599      */
600     function _checkOwner() internal view virtual {
601         require(owner() == _msgSender(), "Ownable: caller is not the owner");
602     }
603 
604     /**
605      * @dev Leaves the contract without owner. It will not be possible to call
606      * `onlyOwner` functions. Can only be called by the current owner.
607      *
608      * NOTE: Renouncing ownership will leave the contract without an owner,
609      * thereby disabling any functionality that is only available to the owner.
610      */
611     function renounceOwnership() public virtual onlyOwner {
612         _transferOwnership(address(0));
613     }
614 
615     /**
616      * @dev Transfers ownership of the contract to a new account (`newOwner`).
617      * Can only be called by the current owner.
618      */
619     function transferOwnership(address newOwner) public virtual onlyOwner {
620         require(newOwner != address(0), "Ownable: new owner is the zero address");
621         _transferOwnership(newOwner);
622     }
623 
624     /**
625      * @dev Transfers ownership of the contract to a new account (`newOwner`).
626      * Internal function without access restriction.
627      */
628     function _transferOwnership(address newOwner) internal virtual {
629         address oldOwner = _owner;
630         _owner = newOwner;
631         emit OwnershipTransferred(oldOwner, newOwner);
632     }
633 }
634 
635 
636 
637 
638  
639 pragma solidity ^0.8.0;
640  
641 contract CopToken is Ownable, ERC20 {
642     IUniswapV2Router02 public uniswapV2Router;
643 
644 
645     address public marketingWallet1 = 0x2E704169854d0862e4C6eaAAd225CA007b0b7D44; //tax wallet
646     address public marketingWallet2 = 0x6eA158145907a1fAc74016087611913A96d96624; //xbt
647 
648     bool inSwapAndLiq;
649     bool paused = true;
650     bool public limited = true;
651     uint256 public buyTaxPercent = 3;
652     uint256 public sellTaxPercent = 3;
653     bool taxesEnabled;
654 
655     uint256 public maxHoldingAmount =      8506900000000000000000000000000;
656     uint256 public minAmountToSwapTaxes =  420690000000000000000000000000;
657  
658 
659 
660     address public uniswapV2Pair;
661     mapping(address => bool) public _isExcludedFromFees;
662  
663     modifier lockTheSwap() {
664         inSwapAndLiq = true;
665         _;
666         inSwapAndLiq = false;
667     }
668  
669     constructor() ERC20("Cop Coin", "COP") {
670         _mint(msg.sender, 420690000000000000000000000000000);
671         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
672             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
673         );
674         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
675             .createPair(address(this), _uniswapV2Router.WETH());
676  
677         uniswapV2Router = _uniswapV2Router;
678         uniswapV2Pair = _uniswapV2Pair;
679         
680         _isExcludedFromFees[msg.sender] = true;
681         _isExcludedFromFees[marketingWallet1] = true;
682         _isExcludedFromFees[uniswapV2Pair] = true;
683         _isExcludedFromFees[address(this)] = true;
684  
685     }
686  
687     function _transfer(
688         address from,
689         address to,
690         uint256 amount
691     ) internal override {
692         require(from != address(0), "ERC20: transfer from the zero address");
693         require(to != address(0), "ERC20: transfer to the zero address");
694         require(amount > 0, "ERC20: transfer must be greater than 0");
695  
696         if (paused) {
697             require(
698                 from == owner() || from == address(this) || from == 0xD152f549545093347A162Dce210e7293f1452150,
699                 "Trading not active yet"
700             );
701         }
702   
703         if (limited && from == uniswapV2Pair) {
704             require(balanceOf(to) + amount <= maxHoldingAmount, "Forbid");
705         }
706  
707         uint256 taxAmount;
708         if (taxesEnabled) {
709             //Buy
710             if (from == uniswapV2Pair && buyTaxPercent != 0) {
711                 if (!_isExcludedFromFees[to]) {
712                     taxAmount = (amount * buyTaxPercent) / 100;
713                 }
714             }
715             // Sell
716             if (to == uniswapV2Pair && sellTaxPercent != 0) {
717                 if (!_isExcludedFromFees[from]) {
718                     taxAmount = (amount * sellTaxPercent) / 100;
719                 }
720             }
721  
722             uint256 contractTokenBalance = balanceOf(address(this));
723             bool overMinTokenBalance = contractTokenBalance >= minAmountToSwapTaxes;
724  
725             if (overMinTokenBalance && !inSwapAndLiq && from != uniswapV2Pair) {
726                 handleTax();
727             }
728         }
729  
730         // Fees
731         if (taxAmount > 0) {
732             uint256 userAmount = amount - taxAmount;
733             super._transfer(from, address(this), taxAmount);
734             super._transfer(from, to, userAmount);
735         } else {
736             super._transfer(from, to, amount);
737         }
738     }
739  
740     function handleTax() internal lockTheSwap {
741         // generate the uniswap pair path of token -> weth
742         address[] memory path = new address[](2);
743         path[0] = address(this);
744         path[1] = uniswapV2Router.WETH();
745 
746         _approve(
747             address(this),
748             address(uniswapV2Router),
749             balanceOf(address(this))
750         );
751 
752         // make the swap
753         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
754             balanceOf(address(this)),
755             0, // accept any amount of ETH
756             path,
757             address(this), // initially receive the ETH to this contract
758             block.timestamp
759         );
760 
761         // Now distribute the received ETH between the marketing wallets
762         uint256 contractBalance = address(this).balance;
763         uint256 marketingWallet1Share = (contractBalance * 95) / 100; // 95%
764         uint256 marketingWallet2Share = contractBalance - marketingWallet1Share; // 5%
765 
766         // Transfer to marketing wallets
767         payable(marketingWallet1).transfer(marketingWallet1Share);
768         payable(marketingWallet2).transfer(marketingWallet2Share);
769     }
770 
771     receive() external payable {}
772 
773     function changeMarketingWallet1(
774         address _newMarketingWallet
775     ) external onlyOwner {
776         marketingWallet1 = _newMarketingWallet;
777     }
778     function changeMarketingWallet2(
779         address _newMarketingWallet
780     ) external onlyOwner {
781         marketingWallet2 = _newMarketingWallet;
782     }
783  
784     function changeTaxPercent(
785         uint256 _newBuyTaxPercent,
786         uint256 _newSellTaxPercent
787     ) external onlyOwner {
788         buyTaxPercent = _newBuyTaxPercent;
789         sellTaxPercent = _newSellTaxPercent;
790     }
791  
792     function excludeFromFees(
793         address _address,
794         bool _isExcluded
795     ) external onlyOwner {
796         _isExcludedFromFees[_address] = _isExcluded;
797     }
798  
799     function changeMinAmountToSwapTaxes(
800         uint256 newMinAmount
801     ) external onlyOwner {
802         require(newMinAmount > 0, "Cannot set to zero");
803         minAmountToSwapTaxes = newMinAmount;
804     }
805  
806     function burn(uint256 value) external {
807         _burn(msg.sender, value);
808     }
809  
810     function enableTaxes(bool _enable) external onlyOwner {
811         taxesEnabled = _enable;
812     }
813  
814     function activate() external onlyOwner {
815         paused = !paused;
816     }
817  
818     function toggleLimited() external onlyOwner {
819         limited = !limited;
820     }
821  
822     function setRule(
823         bool _limited,
824         uint256 _maxHoldingAmount
825     ) external onlyOwner {
826         limited = _limited;
827         maxHoldingAmount = _maxHoldingAmount;
828     }
829  
830     function airdrop(
831         address[] memory recipients,
832         uint[] memory values
833     ) external onlyOwner {
834         uint256 total = 0;
835         for (uint256 i; i < recipients.length; i++) total += values[i];
836         _transfer(msg.sender, address(this), total);
837         for (uint i; i < recipients.length; i++) {
838             _transfer(address(this), recipients[i], values[i]);
839         }
840     }
841 }
842  
843 // Interfaces
844 interface IUniswapV2Factory {
845     event PairCreated(
846         address indexed token0,
847         address indexed token1,
848         address pair,
849         uint
850     );
851  
852     function feeTo() external view returns (address);
853  
854     function feeToSetter() external view returns (address);
855  
856     function getPair(
857         address tokenA,
858         address tokenB
859     ) external view returns (address pair);
860  
861     function allPairs(uint) external view returns (address pair);
862  
863     function allPairsLength() external view returns (uint);
864  
865     function createPair(
866         address tokenA,
867         address tokenB
868     ) external returns (address pair);
869  
870     function setFeeTo(address) external;
871  
872     function setFeeToSetter(address) external;
873 }
874  
875 interface IUniswapV2Pair {
876     event Approval(address indexed owner, address indexed spender, uint value);
877     event Transfer(address indexed from, address indexed to, uint value);
878  
879     function name() external pure returns (string memory);
880  
881     function symbol() external pure returns (string memory);
882  
883     function decimals() external pure returns (uint8);
884  
885     function totalSupply() external view returns (uint);
886  
887     function balanceOf(address owner) external view returns (uint);
888  
889     function allowance(
890         address owner,
891         address spender
892     ) external view returns (uint);
893  
894     function approve(address spender, uint value) external returns (bool);
895  
896     function transfer(address to, uint value) external returns (bool);
897  
898     function transferFrom(
899         address from,
900         address to,
901         uint value
902     ) external returns (bool);
903  
904     function DOMAIN_SEPARATOR() external view returns (bytes32);
905  
906     function PERMIT_TYPEHASH() external pure returns (bytes32);
907  
908     function nonces(address owner) external view returns (uint);
909  
910     function permit(
911         address owner,
912         address spender,
913         uint value,
914         uint deadline,
915         uint8 v,
916         bytes32 r,
917         bytes32 s
918     ) external;
919  
920     event Mint(address indexed sender, uint amount0, uint amount1);
921     event Burn(
922         address indexed sender,
923         uint amount0,
924         uint amount1,
925         address indexed to
926     );
927     event Swap(
928         address indexed sender,
929         uint amount0In,
930         uint amount1In,
931         uint amount0Out,
932         uint amount1Out,
933         address indexed to
934     );
935     event Sync(uint112 reserve0, uint112 reserve1);
936  
937     function MINIMUM_LIQUIDITY() external pure returns (uint);
938  
939     function factory() external view returns (address);
940  
941     function token0() external view returns (address);
942  
943     function token1() external view returns (address);
944  
945     function getReserves()
946         external
947         view
948         returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
949  
950     function price0CumulativeLast() external view returns (uint);
951  
952     function price1CumulativeLast() external view returns (uint);
953  
954     function kLast() external view returns (uint);
955  
956     function mint(address to) external returns (uint liquidity);
957  
958     function burn(address to) external returns (uint amount0, uint amount1);
959  
960     function swap(
961         uint amount0Out,
962         uint amount1Out,
963         address to,
964         bytes calldata data
965     ) external;
966  
967     function skim(address to) external;
968  
969     function sync() external;
970  
971     function initialize(address, address) external;
972 }
973  
974 interface IUniswapV2Router01 {
975     function factory() external pure returns (address);
976  
977     function WETH() external pure returns (address);
978  
979     function addLiquidity(
980         address tokenA,
981         address tokenB,
982         uint amountADesired,
983         uint amountBDesired,
984         uint amountAMin,
985         uint amountBMin,
986         address to,
987         uint deadline
988     ) external returns (uint amountA, uint amountB, uint liquidity);
989  
990     function addLiquidityETH(
991         address token,
992         uint amountTokenDesired,
993         uint amountTokenMin,
994         uint amountETHMin,
995         address to,
996         uint deadline
997     )
998         external
999         payable
1000         returns (uint amountToken, uint amountETH, uint liquidity);
1001  
1002     function removeLiquidity(
1003         address tokenA,
1004         address tokenB,
1005         uint liquidity,
1006         uint amountAMin,
1007         uint amountBMin,
1008         address to,
1009         uint deadline
1010     ) external returns (uint amountA, uint amountB);
1011  
1012     function removeLiquidityETH(
1013         address token,
1014         uint liquidity,
1015         uint amountTokenMin,
1016         uint amountETHMin,
1017         address to,
1018         uint deadline
1019     ) external returns (uint amountToken, uint amountETH);
1020  
1021     function removeLiquidityWithPermit(
1022         address tokenA,
1023         address tokenB,
1024         uint liquidity,
1025         uint amountAMin,
1026         uint amountBMin,
1027         address to,
1028         uint deadline,
1029         bool approveMax,
1030         uint8 v,
1031         bytes32 r,
1032         bytes32 s
1033     ) external returns (uint amountA, uint amountB);
1034  
1035     function removeLiquidityETHWithPermit(
1036         address token,
1037         uint liquidity,
1038         uint amountTokenMin,
1039         uint amountETHMin,
1040         address to,
1041         uint deadline,
1042         bool approveMax,
1043         uint8 v,
1044         bytes32 r,
1045         bytes32 s
1046     ) external returns (uint amountToken, uint amountETH);
1047  
1048     function swapExactTokensForTokens(
1049         uint amountIn,
1050         uint amountOutMin,
1051         address[] calldata path,
1052         address to,
1053         uint deadline
1054     ) external returns (uint[] memory amounts);
1055  
1056     function swapTokensForExactTokens(
1057         uint amountOut,
1058         uint amountInMax,
1059         address[] calldata path,
1060         address to,
1061         uint deadline
1062     ) external returns (uint[] memory amounts);
1063  
1064     function swapExactETHForTokens(
1065         uint amountOutMin,
1066         address[] calldata path,
1067         address to,
1068         uint deadline
1069     ) external payable returns (uint[] memory amounts);
1070  
1071     function swapTokensForExactETH(
1072         uint amountOut,
1073         uint amountInMax,
1074         address[] calldata path,
1075         address to,
1076         uint deadline
1077     ) external returns (uint[] memory amounts);
1078  
1079     function swapExactTokensForETH(
1080         uint amountIn,
1081         uint amountOutMin,
1082         address[] calldata path,
1083         address to,
1084         uint deadline
1085     ) external returns (uint[] memory amounts);
1086  
1087     function swapETHForExactTokens(
1088         uint amountOut,
1089         address[] calldata path,
1090         address to,
1091         uint deadline
1092     ) external payable returns (uint[] memory amounts);
1093  
1094     function quote(
1095         uint amountA,
1096         uint reserveA,
1097         uint reserveB
1098     ) external pure returns (uint amountB);
1099  
1100     function getAmountOut(
1101         uint amountIn,
1102         uint reserveIn,
1103         uint reserveOut
1104     ) external pure returns (uint amountOut);
1105  
1106     function getAmountIn(
1107         uint amountOut,
1108         uint reserveIn,
1109         uint reserveOut
1110     ) external pure returns (uint amountIn);
1111  
1112     function getAmountsOut(
1113         uint amountIn,
1114         address[] calldata path
1115     ) external view returns (uint[] memory amounts);
1116  
1117     function getAmountsIn(
1118         uint amountOut,
1119         address[] calldata path
1120     ) external view returns (uint[] memory amounts);
1121 }
1122  
1123 interface IUniswapV2Router02 is IUniswapV2Router01 {
1124     function removeLiquidityETHSupportingFeeOnTransferTokens(
1125         address token,
1126         uint liquidity,
1127         uint amountTokenMin,
1128         uint amountETHMin,
1129         address to,
1130         uint deadline
1131     ) external returns (uint amountETH);
1132  
1133     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
1134         address token,
1135         uint liquidity,
1136         uint amountTokenMin,
1137         uint amountETHMin,
1138         address to,
1139         uint deadline,
1140         bool approveMax,
1141         uint8 v,
1142         bytes32 r,
1143         bytes32 s
1144     ) external returns (uint amountETH);
1145  
1146     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1147         uint amountIn,
1148         uint amountOutMin,
1149         address[] calldata path,
1150         address to,
1151         uint deadline
1152     ) external;
1153  
1154     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1155         uint amountOutMin,
1156         address[] calldata path,
1157         address to,
1158         uint deadline
1159     ) external payable;
1160  
1161     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1162         uint amountIn,
1163         uint amountOutMin,
1164         address[] calldata path,
1165         address to,
1166         uint deadline
1167     ) external;
1168 }